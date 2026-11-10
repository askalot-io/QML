qmlVersion: '2.7'
questionnaire:
  title: 'General Social Survey 1986, Cycle 2: Time Use (GSS 2-2 main questionnaire, Social Activities and Language Use)'
  blocks:
  - id: b_s1_birth
    title: SECTION A
    items:
    - id: A1
      kind: Question
      title: In what country were you born?
      input:
        control: Dropdown
        labels:
          1: Canada (In which province or territory?)
          2: Newfoundland
          3: Prince Edward Island
          4: Nova Scotia
          5: New Brunswick
          6: Québec
          7: Ontario
          8: Manitoba
          9: Saskatchewan
          10: Alberta
          11: British Columbia
          12: Yukon Territory
          13: Northwest Territories (Go to A3)
          14: Country outside Canada (specify)
    - id: A2
      kind: Question
      title: In what year did you first immigrate to Canada? (Enter 1 for Canadian citizen by birth)
      precondition:
      - predicate: not (A1.outcome <= 13)
        hint: Asked only of respondents born outside Canada
      input:
        control: Editbox
        min: 1
        max: 1986
    - id: A3
      kind: Question
      title: What is your date of birth? Day ___ Month ___ Year 1___
      input:
        control: Textarea
    - id: A4
      kind: Question
      title: Did you live in the same community from birth up to age 15? By community I mean city, town or rural area.
      input:
        control: Radio
        labels:
          1: Yes (Go to A7)
          2: 'No'
          3: Don't know (Go to SECTION B)
  - id: b_s1_moves
    title: Communities lived in up to age 15
    precondition:
    - predicate: not (A4.outcome == 1)
      hint: Asked only when question A4 is not "Yes (Go to A7)".
    - predicate: not (A4.outcome == 3)
      hint: Asked only when question A4 is not "Don't know (Go to SECTION B)".
    items:
    - id: A5
      kind: Question
      title: In how many different communities did you live during this time? (98 = Don't know, go to SECTION B)
      input:
        control: Editbox
        min: 1
        max: 98
    - id: A6
      kind: Question
      title: Think about the community you lived in for the longest time from when you were born until you were 15 years old. For how many of those 15 years did you live there? (99 = Don't know)
      precondition:
      - predicate: not (A5.outcome == 98)
        hint: Asked only when question A5 is not "Don't know (Go to SECTION B)".
      input:
        control: Editbox
        min: 0
        max: 99
  - id: b_s1_community
    title: Community of upbringing
    precondition:
    - predicate: not (A4.outcome == 3)
      hint: Asked only when question A4 is not "Don't know (Go to SECTION B)".
    - predicate: not (A5.outcome == 98)
      hint: Asked only when question A5 is not "Don't know (Go to SECTION B)".
    items:
    - id: A7
      kind: Question
      title: What was the approximate size of that community?
      input:
        control: Radio
        labels:
          1: Less than 5,000 population or a rural area
          2: 5,000 to less than 25,000 population
          3: 25,000 to less than 100,000 population
          4: 100,000 to 1 million population
          5: Over 1 million population
    - id: A8
      kind: Question
      title: Was this place in Canada or elsewhere?
      input:
        control: Radio
        labels:
          6: In Canada (What was the name of that town or nearest town? Town / Prov.)
          7: Elsewhere (Which country? (specify))
  - id: b_s2_father_living
    title: Father at age 15
    items:
    - id: B1
      kind: Question
      title: When you were 15 years old, did you live with your own father? (Include adoptive father)
      input:
        control: Radio
        labels:
          1: Yes (Go to B4)
          2: 'No'
  - id: b_s2_father_absent
    title: Father absent
    precondition:
    - predicate: not (B1.outcome == 1)
      hint: Asked only when question B1 is not "Yes (Go to B4)".
    items:
    - id: B2
      kind: Question
      title: Why was this? Was it because ...
      input:
        control: Radio
        labels:
          3: Your father died
          4: Parents were divorced or separated
          5: You or your father were temporarily living away from home (Go to B4)
          6: Other (specify)
    - id: B3
      kind: Question
      title: During that time, was there a male who took the role of your father?
      precondition:
      - predicate: not (B2.outcome == 5)
        hint: Asked only when question B2 is not "You or your father were temporarily living away from home (Go to B4)".
      input:
        control: Radio
        labels:
          7: 'Yes'
          8: No (Go to B8)
  - id: b_s2_father_activity
    title: Father's main activity
    precondition:
    - predicate: not (B3.outcome == 8)
      hint: Asked only when question B3 is not "No (Go to B8)".
    items:
    - id: B4
      kind: Question
      title: Which of the following best describes your father's (or father substitute's) main activity when you were 15 years old? (Accept one response only)
      input:
        control: Radio
        labels:
          1: Working at a job or business (In this job was he mainly ...)
          2: A student (Go to B8)
          3: Retired (Go to B8)
          4: Keeping house (Go to B8)
          5: Other (specify) (Go to B8)
          6: An employee working for someone else (Go to B5)
          7: Self-employed (Go to B6)
  - id: b_s2_father_job
    title: Father's job
    precondition:
    - predicate: not (B3.outcome == 8)
      hint: Asked only when question B3 is not "No (Go to B8)".
    - predicate: not (B4.outcome in [2, 3, 4, 5])
      hint: Asked only when question B4 is none of "A student (Go to B8)", "Retired (Go to B8)", "Keeping house (Go to B8)", "Other (specify) (Go to B8)".
    items:
    - id: B5
      kind: Question
      title: For whom did he work? (Name of business, government department or agency or person)
      precondition:
      - predicate: not (B4.outcome == 7)
        hint: Asked only when question B4 is not "Self-employed (Go to B6)".
      input:
        control: Textarea
        placeholder: Don't know
    - id: B6
      kind: Question
      title: 'What was the main kind of business, industry or service? (Give a full description: e.g., paper box manufacturing, retail shoe store, municipal board of education)'
      input:
        control: Textarea
        placeholder: Don't know
    - id: B7
      kind: Question
      title: 'What kind of work was he doing? (Give a full description: e.g., posting invoices, selling shoes, teaching primary school)'
      input:
        control: Textarea
        placeholder: Don't know
  - id: b_s2_father_education
    title: Father's education, origin and language
    items:
    - id: B8
      kind: Question
      title: In total, how many years of elementary or secondary education did your father (or father substitute) complete?
      input:
        control: Editbox
        min: 0
        max: 99
        right: years (98 = No schooling, Go to B11; 99 = Don't know)
  - id: b_s2_father_further
    title: Father's further schooling
    precondition:
    - predicate: not (B8.outcome == 98)
      hint: Asked only when question B8 is not "No schooling (Go to B11)".
    items:
    - id: B9
      kind: Question
      title: Did he have any further schooling beyond elementary/secondary school?
      input:
        control: Radio
        labels:
          3: 'Yes'
          4: No (Go to B11)
          5: Don't know (Go to B11)
    - id: B10
      kind: Question
      title: What was the highest level he attained? (Accept one response only)
      precondition:
      - predicate: not (B9.outcome in [4, 5])
        hint: Asked only when question B9 is none of "No (Go to B11)", "Don't know (Go to B11)".
      input:
        control: Dropdown
        labels:
          1: Some community college, CEGEP or nursing school
          2: Diploma or certificate from community college, CEGEP or nursing school
          3: Some university
          4: Bachelor or undergraduate degree or teacher's college
          5: Master's or earned doctorate
          6: Other (specify)
          7: Don't know
  - id: b_s2_father_background
    title: Father's birthplace, ethnicity and language
    items:
    - id: B11
      kind: Question
      title: In what country was he born?
      input:
        control: Dropdown
        labels:
          1: Canada → In which province or territory?
          2: Newfoundland
          3: Prince Edward Island
          4: Nova Scotia
          5: New Brunswick
          6: Québec
          7: Ontario
          8: Manitoba
          9: Saskatchewan
          10: Alberta
          11: British Columbia
          12: Yukon Territory
          13: Northwest Territories
          14: Country outside Canada (specify)
    - id: B12
      kind: Question
      title: To which ethnic or cultural group did he belong? (Accept multiple response)
      input:
        control: Checkbox
        labels:
          1: 1 — English
          2: 2 — French
          4: 3 — Irish
          8: 4 — Scottish
          16: 5 — German
          32: 6 — Italian
          64: 7 — Ukrainian
          128: 8 — Other (specify)
          256: 9 — Don't know
    - id: B13
      kind: Question
      title: What was the first language he learned in childhood? (Accept multiple response only if languages learned at same time)
      input:
        control: Checkbox
        labels:
          1: 1 — English
          2: 2 — French
          4: 3 — Other (specify)
          8: 4 — Don't know
  - id: b_s2_mother_living
    title: Mother at age 15
    items:
    - id: B14
      kind: Question
      title: The next questions ask about your mother. When you were 15 years old, did you live with your own mother? (Include adoptive mother)
      input:
        control: Radio
        labels:
          1: Yes (Go to B17)
          2: 'No'
  - id: b_s2_mother_absent
    title: Mother absent
    precondition:
    - predicate: not (B14.outcome == 1)
      hint: Asked only when question B14 is not "Yes (Go to B17)".
    items:
    - id: B15
      kind: Question
      title: Why was this? Was it because ...
      input:
        control: Radio
        labels:
          3: Your mother died
          4: Parents were divorced or separated
          5: You or your mother were temporarily living away from home (Go to B17)
          6: Other (specify)
    - id: B16
      kind: Question
      title: During that time, was there a female who took the role of your mother?
      precondition:
      - predicate: not (B15.outcome == 5)
        hint: Asked only when question B15 is not "You or your mother were temporarily living away from home (Go to B17)".
      input:
        control: Radio
        labels:
          7: 'Yes'
          8: No (Go to B21)
  - id: b_s2_mother_activity
    title: Mother's main activity
    precondition:
    - predicate: not (B16.outcome == 8)
      hint: Asked only when question B16 is not "No (Go to B21)".
    items:
    - id: B17
      kind: Question
      title: Which of the following best describes your mother's (or mother substitute's) main activity when you were 15 years old? (Accept one response only)
      input:
        control: Radio
        labels:
          1: Working at a job or business → In this job was she mainly ...
          2: Keeping house (Go to B21)
          3: A student (Go to B21)
          4: Retired (Go to B21)
          5: Other (specify) (Go to B21)
          6: An employee working for someone else (Go to B18)
          7: Self-employed (Go to B19)
  - id: b_s2_mother_job
    title: Mother's job
    precondition:
    - predicate: not (B16.outcome == 8)
      hint: Asked only when question B16 is not "No (Go to B21)".
    - predicate: not (B17.outcome in [2, 3, 4, 5])
      hint: Asked only when question B17 is none of "Keeping house (Go to B21)", "A student (Go to B21)", "Retired (Go to B21)", "Other (specify) (Go to B21)".
    items:
    - id: B18
      kind: Question
      title: For whom did she work? (Name of business, government department or agency or person)
      precondition:
      - predicate: not (B17.outcome == 7)
        hint: Asked only when question B17 is not "Self-employed (Go to B19)".
      input:
        control: Textarea
        placeholder: Don't know
    - id: B19
      kind: Question
      title: 'What was the main kind of business, industry or service? (Give a full description: e.g. paper box manufacturing, retail shoe store, municipal board of education)'
      input:
        control: Textarea
        placeholder: Don't know
    - id: B20
      kind: Question
      title: 'What kind of work was she doing? (Give a full description: e.g., posting invoices, selling shoes, teaching primary school)'
      input:
        control: Textarea
        placeholder: Don't know
  - id: b_s2_mother_education
    title: Mother's education
    items:
    - id: B21
      kind: Question
      title: In total, how many years of elementary or secondary education did your mother (or mother substitute) complete?
      input:
        control: Editbox
        min: 0
        max: 99
        right: years (98 = No schooling, Go to B24; 99 = Don't know)
  - id: b_s2_mother_further
    title: Mother's further schooling
    precondition:
    - predicate: not (B21.outcome == 98)
      hint: Asked only when question B21 is not "No schooling → Go to B24".
    items:
    - id: B22
      kind: Question
      title: Did she have any further schooling beyond elementary/secondary school?
      input:
        control: Radio
        labels:
          3: 'Yes'
          4: No → Go to B24
          5: Don't know → Go to B24
    - id: B23
      kind: Question
      title: What was the highest level she attained? (Accept one response only)
      precondition:
      - predicate: not (B22.outcome in [4, 5])
        hint: Asked only when question B22 is none of "No → Go to B24", "Don't know → Go to B24".
      input:
        control: Dropdown
        labels:
          1: Some community college, CEGEP or nursing school
          2: Diploma or certificate from community college, CEGEP or nursing school
          3: Some university
          4: Bachelor or undergraduate degree or teacher's college
          5: Master's or earned doctorate
          6: Other (specify)
          7: Don't know
  - id: b_s2_mother_background
    title: Mother's birthplace, ethnicity and language; own first language
    items:
    - id: B24
      kind: Question
      title: In what country was she born?
      input:
        control: Dropdown
        labels:
          1: Canada → In which province or territory?
          2: Newfoundland
          3: Prince Edward Island
          4: Nova Scotia
          5: New Brunswick
          6: Québec
          7: Ontario
          8: Manitoba
          9: Saskatchewan
          10: Alberta
          11: British Columbia
          12: Yukon Territory
          13: Northwest Territories
          14: Country outside Canada (specify)
    - id: B25
      kind: Question
      title: To which ethnic or cultural group did she belong? (Accept multiple response)
      input:
        control: Checkbox
        labels:
          1: 1 — English
          2: 2 — French
          4: 3 — Irish
          8: 4 — Scottish
          16: 5 — German
          32: 6 — Italian
          64: 7 — Ukrainian
          128: 8 — Other (specify)
          256: 9 — Don't know
    - id: B26
      kind: Question
      title: What was the first language she learned in childhood? (Accept multiple response only if languages learned at same time)
      input:
        control: Checkbox
        labels:
          1: 1 — English
          2: 2 — French
          4: 3 — Other (specify)
          8: 4 — Don't know
    - id: B27
      kind: Question
      title: What language did you yourself first speak in childhood? (Accept multiple response only if languages were spoken equally)
      input:
        control: Checkbox
        labels:
          1: 5 — English
          2: 6 — French
          4: 7 — Other (specify)
  - id: b_s2_siblings
    title: Siblings
    items:
    - id: B28
      kind: Question
      title: How many brothers have you ever had? (Include step-, half- and adopted brothers and those no longer living)
      input:
        control: Editbox
        min: 0
        max: 50
    - id: B29
      kind: Question
      title: How many sisters have you ever had? (Include step-, half- and adopted sisters and those no longer living)
      input:
        control: Editbox
        min: 0
        max: 50
  - id: b_s3_day
    title: SECTION D - Reference day
    items:
    - id: D_DAY
      kind: Question
      title: INTERVIEWER - "X" DAY TO WHICH ACTIVITIES REFER
      input:
        control: Radio
        labels:
          1: Sunday
          2: Monday
          3: Tuesday
          4: Wednesday
          5: Thursday
          6: Friday
          7: Saturday
  - id: b_s3_ep1
    title: Activity 1
    items:
    - id: Q1a
      kind: Question
      title: First of all, starting at 4:00 a.m. what were you doing?
      input:
        control: Textarea
    - id: Q1c
      kind: Question
      title: 'When did this end? [ ][ ] : [ ][ ]'
      input:
        control: Editbox
        min: 0
        max: 2359
    - id: Q1d
      kind: Question
      title: Where were you?/ Were you still ... Place or In Transit
      input:
        control: Radio
        labels:
          1: R's Home
          2: Work Place
          3: Other Place
          4: Car
          5: Walk
          6: Bus & Subway
          7: Other
    - id: Q1e
      kind: Question
      title: Who was with you?/ Were you still ... (Do not ask question "e" about sleep, sex or other personal care activities.)
      input:
        control: Radio
        labels:
          1: Alone
          2: Spouse/Partner
          3: Child(ren) of Household
          4: Other Family Member(s)
          5: Friend(s)
          6: Other Person(s)
  - id: b_s3_ep2
    title: Activity 2
    items:
    - id: Q2a
      kind: Question
      title: And then, what did you do next?
      input:
        control: Textarea
    - id: Q2b
      kind: Question
      title: 'When did this start? [ ][ ] : [ ][ ]'
      postcondition:
      - predicate: Q2b.outcome == Q1c.outcome
        hint: The start time in 2b must equal the end time of the previous activity in 1c.
        invented: true
      input:
        control: Editbox
        min: 0
        max: 2359
    - id: Q2c
      kind: Question
      title: 'When did this end? [ ][ ] : [ ][ ]'
      input:
        control: Editbox
        min: 0
        max: 2359
    - id: Q2d
      kind: Question
      title: Where were you?/ Were you still ... Place or In Transit
      input:
        control: Radio
        labels:
          1: R's Home
          2: Work Place
          3: Other Place
          4: Car
          5: Walk
          6: Bus & Subway
          7: Other
    - id: Q2e
      kind: Question
      title: Who was with you?/ Were you still ...
      input:
        control: Radio
        labels:
          1: Alone
          2: Spouse/Partner
          3: Child(ren) of Household
          4: Other Family Member(s)
          5: Friend(s)
          6: Other Person(s)
  - id: b_s3_ep3
    title: Activity 3
    items:
    - id: Q3a
      kind: Question
      title: And then, what did you do next?
      input:
        control: Textarea
    - id: Q3b
      kind: Question
      title: 'When did this start? [ ][ ] : [ ][ ]'
      postcondition:
      - predicate: Q3b.outcome == Q2c.outcome
        hint: The start time in 3b must equal the end time of the previous activity in 2c.
        invented: true
      input:
        control: Editbox
        min: 0
        max: 2359
    - id: Q3c
      kind: Question
      title: 'When did this end? [ ][ ] : [ ][ ]'
      input:
        control: Editbox
        min: 0
        max: 2359
    - id: Q3d
      kind: Question
      title: Where were you?/ Were you still ... Place or In Transit
      input:
        control: Radio
        labels:
          1: R's Home
          2: Work Place
          3: Other Place
          4: Car
          5: Walk
          6: Bus & Subway
          7: Other
    - id: Q3e
      kind: Question
      title: Who was with you?/ Were you still ...
      input:
        control: Radio
        labels:
          1: Alone
          2: Spouse/Partner
          3: Child(ren) of Household
          4: Other Family Member(s)
          5: Friend(s)
          6: Other Person(s)
  - id: b_s3_ep4
    title: Activity 4
    items:
    - id: Q4a
      kind: Question
      title: And then, what did you do next?
      input:
        control: Textarea
    - id: Q4b
      kind: Question
      title: When did this start?
      postcondition:
      - predicate: Q4b.outcome == Q3c.outcome
        hint: The start time in 4b must equal the end time of the previous activity in 3c.
        invented: true
      input:
        control: Editbox
        min: 0
        max: 2359
    - id: Q4c
      kind: Question
      title: When did this end?
      input:
        control: Editbox
        min: 0
        max: 2359
    - id: Q4d
      kind: Question
      title: Where were you?/ Were you still . . . Place or In Transit
      input:
        control: Radio
        labels:
          1: R's Home
          2: Work Place
          3: Other Place
          4: Car
          5: Walk
          6: Bus & Subway
          7: Other
    - id: Q4e
      kind: Question
      title: Who was with you?/ Were you still . . . (Do not ask question "e" about sleep, sex or other personal care activities.)
      input:
        control: Radio
        labels:
          1: Alone
          2: Spouse/Partner
          3: Child(ren) of Household
          4: Other Family Member(s)
          5: Friend(s)
          6: Other Person(s)
  - id: b_s3_ep5
    title: Activity 5
    items:
    - id: Q5a
      kind: Question
      title: And then, what did you do next?
      input:
        control: Textarea
    - id: Q5b
      kind: Question
      title: When did this start?
      postcondition:
      - predicate: Q5b.outcome == Q4c.outcome
        hint: The start time in 5b must equal the end time of the previous activity in 4c.
        invented: true
      input:
        control: Editbox
        min: 0
        max: 2359
    - id: Q5c
      kind: Question
      title: When did this end?
      input:
        control: Editbox
        min: 0
        max: 2359
    - id: Q5d
      kind: Question
      title: Where were you?/ Were you still . . . Place or In Transit
      input:
        control: Radio
        labels:
          1: R's Home
          2: Work Place
          3: Other Place
          4: Car
          5: Walk
          6: Bus & Subway
          7: Other
    - id: Q5e
      kind: Question
      title: Who was with you?/ Were you still . . .
      input:
        control: Radio
        labels:
          1: Alone
          2: Spouse/Partner
          3: Child(ren) of Household
          4: Other Family Member(s)
          5: Friend(s)
          6: Other Person(s)
  - id: b_s3_ep6
    title: Activity 6
    items:
    - id: Q6a
      kind: Question
      title: And then, what did you do next?
      input:
        control: Textarea
    - id: Q6b
      kind: Question
      title: When did this start?
      postcondition:
      - predicate: Q6b.outcome == Q5c.outcome
        hint: The start time in 6b must equal the end time of the previous activity in 5c.
        invented: true
      input:
        control: Editbox
        min: 0
        max: 2359
    - id: Q6c
      kind: Question
      title: When did this end?
      input:
        control: Editbox
        min: 0
        max: 2359
    - id: Q6d
      kind: Question
      title: Where were you?/ Were you still . . . Place or In Transit
      input:
        control: Radio
        labels:
          1: R's Home
          2: Work Place
          3: Other Place
          4: Car
          5: Walk
          6: Bus & Subway
          7: Other
    - id: Q6e
      kind: Question
      title: Who was with you?/ Were you still . . .
      input:
        control: Radio
        labels:
          1: Alone
          2: Spouse/Partner
          3: Child(ren) of Household
          4: Other Family Member(s)
          5: Friend(s)
          6: Other Person(s)
  - id: b_s3_ep7
    title: Activity 7
    items:
    - id: Q7a
      kind: Question
      title: And then, what did you do next?
      input:
        control: Textarea
    - id: Q7b
      kind: Question
      title: When did this start?
      postcondition:
      - predicate: Q7b.outcome == Q6c.outcome
        hint: The start time in 7b must equal the end time of the previous activity in 6c.
        invented: true
      input:
        control: Editbox
        min: 0
        max: 2359
    - id: Q7c
      kind: Question
      title: When did this end?
      input:
        control: Editbox
        min: 0
        max: 2359
    - id: Q7d
      kind: Question
      title: Where were you?/ Were you still . . . Place or In Transit
      input:
        control: Radio
        labels:
          1: R's Home
          2: Work Place
          3: Other Place
          4: Car
          5: Walk
          6: Bus & Subway
          7: Other
    - id: Q7e
      kind: Question
      title: Who was with you?/ Were you still . . .
      input:
        control: Radio
        labels:
          1: Alone
          2: Spouse/Partner
          3: Child(ren) of Household
          4: Other Family Member(s)
          5: Friend(s)
          6: Other Person(s)
  - id: b_s3_ep8
    title: Activity 8
    items:
    - id: Q8a
      kind: Question
      title: And then, what did you do next?
      input:
        control: Textarea
    - id: Q8b
      kind: Question
      title: When did this start?
      postcondition:
      - predicate: Q8b.outcome == Q7c.outcome
        hint: The start time in 8b must equal the end time of the previous activity in 7c.
        invented: true
      input:
        control: Editbox
        min: 0
        max: 2359
    - id: Q8c
      kind: Question
      title: When did this end?
      input:
        control: Editbox
        min: 0
        max: 2359
    - id: Q8d
      kind: Question
      title: Where were you?/ Were you still . . . Place or In Transit
      input:
        control: Radio
        labels:
          1: R's Home
          2: Work Place
          3: Other Place
          4: Car
          5: Walk
          6: Bus & Subway
          7: Other
    - id: Q8e
      kind: Question
      title: Who was with you?/ Were you still . . .
      input:
        control: Radio
        labels:
          1: Alone
          2: Spouse/Partner
          3: Child(ren) of Household
          4: Other Family Member(s)
          5: Friend(s)
          6: Other Person(s)
  - id: b_s3_ep9
    title: Activity 9
    items:
    - id: Q9a
      kind: Question
      title: And then, what did you do next?
      input:
        control: Textarea
    - id: Q9b
      kind: Question
      title: When did this start?
      postcondition:
      - predicate: Q9b.outcome == Q8c.outcome
        hint: The start time in 9b must equal the end time of the previous activity in 8c.
        invented: true
      input:
        control: Editbox
        min: 0
        max: 2359
    - id: Q9c
      kind: Question
      title: When did this end?
      input:
        control: Editbox
        min: 0
        max: 2359
    - id: Q9d
      kind: Question
      title: Where were you?/ Were you still . . . Place or In Transit
      input:
        control: Radio
        labels:
          1: R's Home
          2: Work Place
          3: Other Place
          4: Car
          5: Walk
          6: Bus & Subway
          7: Other
    - id: Q9e
      kind: Question
      title: Who was with you?/ Were you still . . .
      input:
        control: Radio
        labels:
          1: Alone
          2: Spouse/Partner
          3: Child(ren) of Household
          4: Other Family Member(s)
          5: Friend(s)
          6: Other Person(s)
  - id: b_s4_p1_ep10
    title: Episode 10
    items:
    - id: Q10a
      kind: Question
      title: And then, what did you do next?
      input:
        control: Textarea
    - id: Q10b
      kind: Question
      title: When did this start?
      input:
        control: Textarea
    - id: Q10c
      kind: Question
      title: When did this end?
      input:
        control: Textarea
    - id: Q10d
      kind: Question
      title: Where were you?/ Were you still . . .
      input:
        control: Radio
        labels:
          1: R's Home
          2: Work Place
          3: Other Place
          4: Car
          5: Walk
          6: Bus & Subway
          7: Other
    - id: Q10e
      kind: Question
      title: Who was with you?/ Were you still . . . (Do not ask question "e" about sleep, sex or other personal care activities.)
      input:
        control: Radio
        labels:
          1: Alone
          2: Spouse/Partner
          3: Child(ren) of Household
          4: Other Family Member(s)
          5: Friend(s)
          6: Other Person(s)
  - id: b_s4_p1_ep11
    title: Episode 11
    items:
    - id: Q11a
      kind: Question
      title: And then, what did you do next?
      input:
        control: Textarea
    - id: Q11b
      kind: Question
      title: When did this start?
      input:
        control: Textarea
    - id: Q11c
      kind: Question
      title: When did this end?
      input:
        control: Textarea
    - id: Q11d
      kind: Question
      title: Where were you?/ Were you still . . .
      input:
        control: Radio
        labels:
          1: R's Home
          2: Work Place
          3: Other Place
          4: Car
          5: Walk
          6: Bus & Subway
          7: Other
    - id: Q11e
      kind: Question
      title: Who was with you?/ Were you still . . . (Do not ask question "e" about sleep, sex or other personal care activities.)
      input:
        control: Radio
        labels:
          1: Alone
          2: Spouse/Partner
          3: Child(ren) of Household
          4: Other Family Member(s)
          5: Friend(s)
          6: Other Person(s)
  - id: b_s4_p1_ep12
    title: Episode 12
    items:
    - id: Q12a
      kind: Question
      title: And then, what did you do next?
      input:
        control: Textarea
    - id: Q12b
      kind: Question
      title: When did this start?
      input:
        control: Textarea
    - id: Q12c
      kind: Question
      title: When did this end?
      input:
        control: Textarea
    - id: Q12d
      kind: Question
      title: Where were you?/ Were you still . . .
      input:
        control: Radio
        labels:
          1: R's Home
          2: Work Place
          3: Other Place
          4: Car
          5: Walk
          6: Bus & Subway
          7: Other
    - id: Q12e
      kind: Question
      title: Who was with you?/ Were you still . . . (Do not ask question "e" about sleep, sex or other personal care activities.)
      input:
        control: Radio
        labels:
          1: Alone
          2: Spouse/Partner
          3: Child(ren) of Household
          4: Other Family Member(s)
          5: Friend(s)
          6: Other Person(s)
  - id: b_s4_p1_ep13
    title: Episode 13
    items:
    - id: Q13a
      kind: Question
      title: And then, what did you do next?
      input:
        control: Textarea
    - id: Q13b
      kind: Question
      title: When did this start?
      input:
        control: Textarea
    - id: Q13c
      kind: Question
      title: When did this end?
      input:
        control: Textarea
    - id: Q13d
      kind: Question
      title: Where were you?/ Were you still . . .
      input:
        control: Radio
        labels:
          1: R's Home
          2: Work Place
          3: Other Place
          4: Car
          5: Walk
          6: Bus & Subway
          7: Other
    - id: Q13e
      kind: Question
      title: Who was with you?/ Were you still . . . (Do not ask question "e" about sleep, sex or other personal care activities.)
      input:
        control: Radio
        labels:
          1: Alone
          2: Spouse/Partner
          3: Child(ren) of Household
          4: Other Family Member(s)
          5: Friend(s)
          6: Other Person(s)
  - id: b_s4_p1_ep14
    title: Episode 14
    items:
    - id: Q14a
      kind: Question
      title: And then, what did you do next?
      input:
        control: Textarea
    - id: Q14b
      kind: Question
      title: When did this start?
      input:
        control: Textarea
    - id: Q14c
      kind: Question
      title: When did this end?
      input:
        control: Textarea
    - id: Q14d
      kind: Question
      title: Where were you?/ Were you still . . .
      input:
        control: Radio
        labels:
          1: R's Home
          2: Work Place
          3: Other Place
          4: Car
          5: Walk
          6: Bus & Subway
          7: Other
    - id: Q14e
      kind: Question
      title: Who was with you?/ Were you still . . . (Do not ask question "e" about sleep, sex or other personal care activities.)
      input:
        control: Radio
        labels:
          1: Alone
          2: Spouse/Partner
          3: Child(ren) of Household
          4: Other Family Member(s)
          5: Friend(s)
          6: Other Person(s)
  - id: b_s4_p1_ep15
    title: Episode 15
    items:
    - id: Q15a
      kind: Question
      title: And then, what did you do next?
      input:
        control: Textarea
    - id: Q15b
      kind: Question
      title: When did this start?
      input:
        control: Textarea
    - id: Q15c
      kind: Question
      title: When did this end?
      input:
        control: Textarea
    - id: Q15d
      kind: Question
      title: Where were you?/ Were you still . . .
      input:
        control: Radio
        labels:
          1: R's Home
          2: Work Place
          3: Other Place
          4: Car
          5: Walk
          6: Bus & Subway
          7: Other
    - id: Q15e
      kind: Question
      title: Who was with you?/ Were you still . . . (Do not ask question "e" about sleep, sex or other personal care activities.)
      input:
        control: Radio
        labels:
          1: Alone
          2: Spouse/Partner
          3: Child(ren) of Household
          4: Other Family Member(s)
          5: Friend(s)
          6: Other Person(s)
  - id: b_s4_p1_ep16
    title: Episode 16
    items:
    - id: Q16a
      kind: Question
      title: And then, what did you do next?
      input:
        control: Textarea
    - id: Q16b
      kind: Question
      title: When did this start?
      input:
        control: Textarea
    - id: Q16c
      kind: Question
      title: When did this end?
      input:
        control: Textarea
    - id: Q16d
      kind: Question
      title: Where were you?/ Were you still . . .
      input:
        control: Radio
        labels:
          1: R's Home
          2: Work Place
          3: Other Place
          4: Car
          5: Walk
          6: Bus & Subway
          7: Other
    - id: Q16e
      kind: Question
      title: Who was with you?/ Were you still . . . (Do not ask question "e" about sleep, sex or other personal care activities.)
      input:
        control: Radio
        labels:
          1: Alone
          2: Spouse/Partner
          3: Child(ren) of Household
          4: Other Family Member(s)
          5: Friend(s)
          6: Other Person(s)
  - id: b_s4_p1_ep17
    title: Episode 17
    items:
    - id: Q17a
      kind: Question
      title: And then, what did you do next?
      input:
        control: Textarea
    - id: Q17b
      kind: Question
      title: When did this start?
      input:
        control: Textarea
    - id: Q17c
      kind: Question
      title: When did this end?
      input:
        control: Textarea
    - id: Q17d
      kind: Question
      title: Where were you?/ Were you still . . .
      input:
        control: Radio
        labels:
          1: R's Home
          2: Work Place
          3: Other Place
          4: Car
          5: Walk
          6: Bus & Subway
          7: Other
    - id: Q17e
      kind: Question
      title: Who was with you?/ Were you still . . . (Do not ask question "e" about sleep, sex or other personal care activities.)
      input:
        control: Radio
        labels:
          1: Alone
          2: Spouse/Partner
          3: Child(ren) of Household
          4: Other Family Member(s)
          5: Friend(s)
          6: Other Person(s)
  - id: b_s4_p1_ep18
    title: Episode 18
    items:
    - id: Q18a
      kind: Question
      title: And then, what did you do next?
      input:
        control: Textarea
    - id: Q18b
      kind: Question
      title: When did this start?
      input:
        control: Textarea
    - id: Q18c
      kind: Question
      title: When did this end?
      input:
        control: Textarea
    - id: Q18d
      kind: Question
      title: Where were you?/ Were you still . . .
      input:
        control: Radio
        labels:
          1: R's Home
          2: Work Place
          3: Other Place
          4: Car
          5: Walk
          6: Bus & Subway
          7: Other
    - id: Q18e
      kind: Question
      title: Who was with you?/ Were you still . . . (Do not ask question "e" about sleep, sex or other personal care activities.)
      input:
        control: Radio
        labels:
          1: Alone
          2: Spouse/Partner
          3: Child(ren) of Household
          4: Other Family Member(s)
          5: Friend(s)
          6: Other Person(s)
  - id: b_s4_p1_ep19
    title: Episode 19
    items:
    - id: Q19a
      kind: Question
      title: And then, what did you do next?
      input:
        control: Textarea
    - id: Q19b
      kind: Question
      title: When did this start?
      input:
        control: Textarea
    - id: Q19c
      kind: Question
      title: When did this end?
      input:
        control: Textarea
    - id: Q19d
      kind: Question
      title: Where were you?/ Were you still . . .
      input:
        control: Radio
        labels:
          1: R's Home
          2: Work Place
          3: Other Place
          4: Car
          5: Walk
          6: Bus & Subway
          7: Other
    - id: Q19e
      kind: Question
      title: Who was with you?/ Were you still . . . (Do not ask question "e" about sleep, sex or other personal care activities.)
      input:
        control: Radio
        labels:
          1: Alone
          2: Spouse/Partner
          3: Child(ren) of Household
          4: Other Family Member(s)
          5: Friend(s)
          6: Other Person(s)
  - id: b_s4_p1_ep20
    title: Episode 20
    items:
    - id: Q20a
      kind: Question
      title: And then, what did you do next?
      input:
        control: Textarea
    - id: Q20b
      kind: Question
      title: When did this start?
      input:
        control: Textarea
    - id: Q20c
      kind: Question
      title: When did this end?
      input:
        control: Textarea
    - id: Q20d
      kind: Question
      title: Where were you?/ Were you still . . .
      input:
        control: Radio
        labels:
          1: R's Home
          2: Work Place
          3: Other Place
          4: Car
          5: Walk
          6: Bus & Subway
          7: Other
    - id: Q20e
      kind: Question
      title: Who was with you?/ Were you still . . . (Do not ask question "e" about sleep, sex or other personal care activities.)
      input:
        control: Radio
        labels:
          1: Alone
          2: Spouse/Partner
          3: Child(ren) of Household
          4: Other Family Member(s)
          5: Friend(s)
          6: Other Person(s)
  - id: b_s4_p1_ep21
    title: Episode 21
    items:
    - id: Q21a
      kind: Question
      title: And then, what did you do next?
      input:
        control: Textarea
    - id: Q21b
      kind: Question
      title: When did this start?
      input:
        control: Textarea
    - id: Q21c
      kind: Question
      title: When did this end?
      input:
        control: Textarea
    - id: Q21d
      kind: Question
      title: Where were you?/ Were you still . . .
      input:
        control: Radio
        labels:
          1: R's Home
          2: Work Place
          3: Other Place
          4: Car
          5: Walk
          6: Bus & Subway
          7: Other
    - id: Q21e
      kind: Question
      title: Who was with you?/ Were you still . . . (Do not ask question "e" about sleep, sex or other personal care activities.)
      input:
        control: Radio
        labels:
          1: Alone
          2: Spouse/Partner
          3: Child(ren) of Household
          4: Other Family Member(s)
          5: Friend(s)
          6: Other Person(s)
  - id: b_s4_p1_ep22
    title: Episode 22
    items:
    - id: Q22a
      kind: Question
      title: And then, what did you do next?
      input:
        control: Textarea
    - id: Q22b
      kind: Question
      title: When did this start?
      input:
        control: Textarea
    - id: Q22c
      kind: Question
      title: When did this end?
      input:
        control: Textarea
    - id: Q22d
      kind: Question
      title: Where were you?/ Were you still . . .
      input:
        control: Radio
        labels:
          1: R's Home
          2: Work Place
          3: Other Place
          4: Car
          5: Walk
          6: Bus & Subway
          7: Other
    - id: Q22e
      kind: Question
      title: Who was with you?/ Were you still . . . (Do not ask question "e" about sleep, sex or other personal care activities.)
      input:
        control: Radio
        labels:
          1: Alone
          2: Spouse/Partner
          3: Child(ren) of Household
          4: Other Family Member(s)
          5: Friend(s)
          6: Other Person(s)
  - id: b_s4_p1_ep23
    title: Episode 23
    items:
    - id: Q23a
      kind: Question
      title: And then, what did you do next?
      input:
        control: Textarea
    - id: Q23b
      kind: Question
      title: When did this start?
      input:
        control: Textarea
    - id: Q23c
      kind: Question
      title: When did this end?
      input:
        control: Textarea
    - id: Q23d
      kind: Question
      title: Where were you?/ Were you still . . .
      input:
        control: Radio
        labels:
          1: R's Home
          2: Work Place
          3: Other Place
          4: Car
          5: Walk
          6: Bus & Subway
          7: Other
    - id: Q23e
      kind: Question
      title: Who was with you?/ Were you still . . . (Do not ask question "e" about sleep, sex or other personal care activities.)
      input:
        control: Radio
        labels:
          1: Alone
          2: Spouse/Partner
          3: Child(ren) of Household
          4: Other Family Member(s)
          5: Friend(s)
          6: Other Person(s)
  - id: b_s4_p1_ep24
    title: Episode 24
    items:
    - id: Q24a
      kind: Question
      title: And then, what did you do next?
      input:
        control: Textarea
    - id: Q24b
      kind: Question
      title: When did this start?
      input:
        control: Textarea
    - id: Q24c
      kind: Question
      title: When did this end?
      input:
        control: Textarea
    - id: Q24d
      kind: Question
      title: Where were you?/ Were you still . . .
      input:
        control: Radio
        labels:
          1: R's Home
          2: Work Place
          3: Other Place
          4: Car
          5: Walk
          6: Bus & Subway
          7: Other
    - id: Q24e
      kind: Question
      title: Who was with you?/ Were you still . . . (Do not ask question "e" about sleep, sex or other personal care activities.)
      input:
        control: Radio
        labels:
          1: Alone
          2: Spouse/Partner
          3: Child(ren) of Household
          4: Other Family Member(s)
          5: Friend(s)
          6: Other Person(s)
  - id: b_s4_p1_ep25
    title: Episode 25
    items:
    - id: Q25a
      kind: Question
      title: And then, what did you do next?
      input:
        control: Textarea
    - id: Q25b
      kind: Question
      title: When did this start?
      input:
        control: Textarea
    - id: Q25c
      kind: Question
      title: When did this end?
      input:
        control: Textarea
    - id: Q25d
      kind: Question
      title: Where were you?/ Were you still . . .
      input:
        control: Radio
        labels:
          1: R's Home
          2: Work Place
          3: Other Place
          4: Car
          5: Walk
          6: Bus & Subway
          7: Other
    - id: Q25e
      kind: Question
      title: Who was with you?/ Were you still . . . (Do not ask question "e" about sleep, sex or other personal care activities.)
      input:
        control: Radio
        labels:
          1: Alone
          2: Spouse/Partner
          3: Child(ren) of Household
          4: Other Family Member(s)
          5: Friend(s)
          6: Other Person(s)
  - id: b_s4_p1_ep26
    title: Episode 26
    items:
    - id: Q26a
      kind: Question
      title: And then, what did you do next?
      input:
        control: Textarea
    - id: Q26b
      kind: Question
      title: When did this start?
      input:
        control: Textarea
    - id: Q26c
      kind: Question
      title: When did this end?
      input:
        control: Textarea
    - id: Q26d
      kind: Question
      title: Where were you?/ Were you still . . .
      input:
        control: Radio
        labels:
          1: R's Home
          2: Work Place
          3: Other Place
          4: Car
          5: Walk
          6: Bus & Subway
          7: Other
    - id: Q26e
      kind: Question
      title: Who was with you?/ Were you still . . . (Do not ask question "e" about sleep, sex or other personal care activities.)
      input:
        control: Radio
        labels:
          1: Alone
          2: Spouse/Partner
          3: Child(ren) of Household
          4: Other Family Member(s)
          5: Friend(s)
          6: Other Person(s)
  - id: b_s4_p1_ep27
    title: Episode 27
    items:
    - id: Q27a
      kind: Question
      title: And then, what did you do next?
      input:
        control: Textarea
    - id: Q27b
      kind: Question
      title: When did this start?
      input:
        control: Textarea
    - id: Q27c
      kind: Question
      title: When did this end?
      input:
        control: Textarea
    - id: Q27d
      kind: Question
      title: Where were you?/ Were you still . . .
      input:
        control: Radio
        labels:
          1: R's Home
          2: Work Place
          3: Other Place
          4: Car
          5: Walk
          6: Bus & Subway
          7: Other
    - id: Q27e
      kind: Question
      title: Who was with you?/ Were you still . . . (Do not ask question "e" about sleep, sex or other personal care activities.)
      input:
        control: Radio
        labels:
          1: Alone
          2: Spouse/Partner
          3: Child(ren) of Household
          4: Other Family Member(s)
          5: Friend(s)
          6: Other Person(s)
  - id: b_s4_p1_ep28
    title: Episode 28
    items:
    - id: Q28a
      kind: Question
      title: And then, what did you do next?
      input:
        control: Textarea
    - id: Q28b
      kind: Question
      title: When did this start?
      input:
        control: Textarea
    - id: Q28c
      kind: Question
      title: When did this end?
      input:
        control: Textarea
    - id: Q28d
      kind: Question
      title: Where were you?/ Were you still . . .
      input:
        control: Radio
        labels:
          1: R's Home
          2: Work Place
          3: Other Place
          4: Car
          5: Walk
          6: Bus & Subway
          7: Other
    - id: Q28e
      kind: Question
      title: Who was with you?/ Were you still . . . (Do not ask question "e" about sleep, sex or other personal care activities.)
      input:
        control: Radio
        labels:
          1: Alone
          2: Spouse/Partner
          3: Child(ren) of Household
          4: Other Family Member(s)
          5: Friend(s)
          6: Other Person(s)
  - id: b_s4_p1_ep29
    title: Episode 29
    items:
    - id: Q29a
      kind: Question
      title: And then, what did you do next?
      input:
        control: Textarea
    - id: Q29b
      kind: Question
      title: When did this start?
      input:
        control: Textarea
    - id: Q29c
      kind: Question
      title: When did this end?
      input:
        control: Textarea
    - id: Q29d
      kind: Question
      title: Where were you?/ Were you still . . .
      input:
        control: Radio
        labels:
          1: R's Home
          2: Work Place
          3: Other Place
          4: Car
          5: Walk
          6: Bus & Subway
          7: Other
    - id: Q29e
      kind: Question
      title: Who was with you?/ Were you still . . . (Do not ask question "e" about sleep, sex or other personal care activities.)
      input:
        control: Radio
        labels:
          1: Alone
          2: Spouse/Partner
          3: Child(ren) of Household
          4: Other Family Member(s)
          5: Friend(s)
          6: Other Person(s)
  - id: b_s4_p1_ep30
    title: Episode 30
    items:
    - id: Q30a
      kind: Question
      title: And then, what did you do next?
      input:
        control: Textarea
    - id: Q30b
      kind: Question
      title: When did this start?
      input:
        control: Textarea
    - id: Q30c
      kind: Question
      title: When did this end?
      input:
        control: Textarea
    - id: Q30d
      kind: Question
      title: Where were you?/ Were you still . . .
      input:
        control: Radio
        labels:
          1: R's Home
          2: Work Place
          3: Other Place
          4: Car
          5: Walk
          6: Bus & Subway
          7: Other
    - id: Q30e
      kind: Question
      title: Who was with you?/ Were you still . . . (Do not ask question "e" about sleep, sex or other personal care activities.)
      input:
        control: Radio
        labels:
          1: Alone
          2: Spouse/Partner
          3: Child(ren) of Household
          4: Other Family Member(s)
          5: Friend(s)
          6: Other Person(s)
  - id: b_s4_p1_ep31
    title: Episode 31
    items:
    - id: Q31a
      kind: Question
      title: And then, what did you do next?
      input:
        control: Textarea
    - id: Q31b
      kind: Question
      title: When did this start?
      input:
        control: Textarea
    - id: Q31c
      kind: Question
      title: When did this end?
      input:
        control: Textarea
    - id: Q31d
      kind: Question
      title: Where were you?/ Were you still . . .
      input:
        control: Radio
        labels:
          1: R's Home
          2: Work Place
          3: Other Place
          4: Car
          5: Walk
          6: Bus & Subway
          7: Other
    - id: Q31e
      kind: Question
      title: Who was with you?/ Were you still . . . (Do not ask question "e" about sleep, sex or other personal care activities.)
      input:
        control: Radio
        labels:
          1: Alone
          2: Spouse/Partner
          3: Child(ren) of Household
          4: Other Family Member(s)
          5: Friend(s)
          6: Other Person(s)
  - id: b_s4_p1_ep32
    title: Episode 32
    items:
    - id: Q32a
      kind: Question
      title: And then, what did you do next?
      input:
        control: Textarea
    - id: Q32b
      kind: Question
      title: When did this start?
      input:
        control: Textarea
    - id: Q32c
      kind: Question
      title: When did this end?
      input:
        control: Textarea
    - id: Q32d
      kind: Question
      title: Where were you?/ Were you still . . .
      input:
        control: Radio
        labels:
          1: R's Home
          2: Work Place
          3: Other Place
          4: Car
          5: Walk
          6: Bus & Subway
          7: Other
    - id: Q32e
      kind: Question
      title: Who was with you?/ Were you still . . . (Do not ask question "e" about sleep, sex or other personal care activities.)
      input:
        control: Radio
        labels:
          1: Alone
          2: Spouse/Partner
          3: Child(ren) of Household
          4: Other Family Member(s)
          5: Friend(s)
          6: Other Person(s)
  - id: b_s4_p1_ep33
    title: Episode 33
    items:
    - id: Q33a
      kind: Question
      title: And then, what did you do next?
      input:
        control: Textarea
    - id: Q33b
      kind: Question
      title: When did this start?
      input:
        control: Textarea
    - id: Q33c
      kind: Question
      title: When did this end?
      input:
        control: Textarea
    - id: Q33d
      kind: Question
      title: Where were you?/ Were you still . . .
      input:
        control: Radio
        labels:
          1: R's Home
          2: Work Place
          3: Other Place
          4: Car
          5: Walk
          6: Bus & Subway
          7: Other
    - id: Q33e
      kind: Question
      title: Who was with you?/ Were you still . . . (Do not ask question "e" about sleep, sex or other personal care activities.)
      input:
        control: Radio
        labels:
          1: Alone
          2: Spouse/Partner
          3: Child(ren) of Household
          4: Other Family Member(s)
          5: Friend(s)
          6: Other Person(s)
  - id: b_s4_p1_ep34
    title: Episode 34
    items:
    - id: Q34a
      kind: Question
      title: And then, what did you do next?
      input:
        control: Textarea
    - id: Q34b
      kind: Question
      title: When did this start?
      input:
        control: Textarea
    - id: Q34c
      kind: Question
      title: When did this end?
      input:
        control: Textarea
    - id: Q34d
      kind: Question
      title: Where were you?/ Were you still . . .
      input:
        control: Radio
        labels:
          1: R's Home
          2: Work Place
          3: Other Place
          4: Car
          5: Walk
          6: Bus & Subway
          7: Other
    - id: Q34e
      kind: Question
      title: Who was with you?/ Were you still . . . (Do not ask question "e" about sleep, sex or other personal care activities.)
      input:
        control: Radio
        labels:
          1: Alone
          2: Spouse/Partner
          3: Child(ren) of Household
          4: Other Family Member(s)
          5: Friend(s)
          6: Other Person(s)
  - id: b_s4_p1_ep35
    title: Episode 35
    items:
    - id: Q35a
      kind: Question
      title: And then, what did you do next?
      input:
        control: Textarea
    - id: Q35b
      kind: Question
      title: When did this start?
      input:
        control: Textarea
    - id: Q35c
      kind: Question
      title: When did this end?
      input:
        control: Textarea
    - id: Q35d
      kind: Question
      title: Where were you?/ Were you still . . .
      input:
        control: Radio
        labels:
          1: R's Home
          2: Work Place
          3: Other Place
          4: Car
          5: Walk
          6: Bus & Subway
          7: Other
    - id: Q35e
      kind: Question
      title: Who was with you?/ Were you still . . . (Do not ask question "e" about sleep, sex or other personal care activities.)
      input:
        control: Radio
        labels:
          1: Alone
          2: Spouse/Partner
          3: Child(ren) of Household
          4: Other Family Member(s)
          5: Friend(s)
          6: Other Person(s)
  - id: b_s4_p1_ep36
    title: Episode 36
    items:
    - id: Q36a
      kind: Question
      title: And then, what did you do next?
      input:
        control: Textarea
    - id: Q36b
      kind: Question
      title: When did this start?
      input:
        control: Textarea
    - id: Q36c
      kind: Question
      title: When did this end?
      input:
        control: Textarea
    - id: Q36d
      kind: Question
      title: Where were you?/ Were you still . . .
      input:
        control: Radio
        labels:
          1: R's Home
          2: Work Place
          3: Other Place
          4: Car
          5: Walk
          6: Bus & Subway
          7: Other
    - id: Q36e
      kind: Question
      title: Who was with you?/ Were you still . . . (Do not ask question "e" about sleep, sex or other personal care activities.)
      input:
        control: Radio
        labels:
          1: Alone
          2: Spouse/Partner
          3: Child(ren) of Household
          4: Other Family Member(s)
          5: Friend(s)
          6: Other Person(s)
  - id: b_s4_p1_ep37
    title: Episode 37
    items:
    - id: Q37a
      kind: Question
      title: And then, what did you do next?
      input:
        control: Textarea
    - id: Q37b
      kind: Question
      title: When did this start?
      input:
        control: Textarea
    - id: Q37c
      kind: Question
      title: When did this end?
      input:
        control: Textarea
    - id: Q37d
      kind: Question
      title: Where were you?/ Were you still . . .
      input:
        control: Radio
        labels:
          1: R's Home
          2: Work Place
          3: Other Place
          4: Car
          5: Walk
          6: Bus & Subway
          7: Other
    - id: Q37e
      kind: Question
      title: Who was with you?/ Were you still . . . (Do not ask question "e" about sleep, sex or other personal care activities.)
      input:
        control: Radio
        labels:
          1: Alone
          2: Spouse/Partner
          3: Child(ren) of Household
          4: Other Family Member(s)
          5: Friend(s)
          6: Other Person(s)
  - id: b_s4_p1_ep38
    title: Episode 38
    items:
    - id: Q38a
      kind: Question
      title: And then, what did you do next?
      input:
        control: Textarea
    - id: Q38b
      kind: Question
      title: When did this start?
      input:
        control: Textarea
  - id: b_s4_p2_ep10
    title: Activity diary, episode 10 (continued)
    items:
    - id: Q38c
      kind: Question
      title: When did this end?
      input:
        control: Textarea
    - id: Q38d
      kind: Question
      title: Where were you?/ Were you still . . .
      input:
        control: Radio
        labels:
          1: R's Home
          2: Work Place
          3: Other Place
          4: Car
          5: Walk
          6: Bus & Subway
          7: Other
    - id: Q38e
      kind: Question
      title: Who was with you?/ Were you still . . . (Do not ask question "e" about sleep, sex or other personal care activities.)
      input:
        control: Radio
        labels:
          1: Alone
          2: Spouse/Partner
          3: Child(ren) of Household
          4: Other Family Member(s)
          5: Friend(s)
          6: Other Person(s)
  - id: b_s4_p2_ep11
    title: Activity diary, episode 11
    items:
    - id: Q39a
      kind: Question
      title: And then, what did you do next?
      input:
        control: Textarea
    - id: Q39b
      kind: Question
      title: When did this start?
      input:
        control: Textarea
    - id: Q39c
      kind: Question
      title: When did this end?
      input:
        control: Textarea
    - id: Q39d
      kind: Question
      title: Where were you?/ Were you still . . .
      input:
        control: Radio
        labels:
          1: R's Home
          2: Work Place
          3: Other Place
          4: Car
          5: Walk
          6: Bus & Subway
          7: Other
    - id: Q39e
      kind: Question
      title: Who was with you?/ Were you still . . . (Do not ask question "e" about sleep, sex or other personal care activities.)
      input:
        control: Radio
        labels:
          1: Alone
          2: Spouse/Partner
          3: Child(ren) of Household
          4: Other Family Member(s)
          5: Friend(s)
          6: Other Person(s)
  - id: b_s4_p2_ep12
    title: Activity diary, episode 12
    items:
    - id: Q40a
      kind: Question
      title: And then, what did you do next?
      input:
        control: Textarea
    - id: Q40b
      kind: Question
      title: When did this start?
      input:
        control: Textarea
    - id: Q40c
      kind: Question
      title: When did this end?
      input:
        control: Textarea
    - id: Q40d
      kind: Question
      title: Where were you?/ Were you still ...
      input:
        control: Radio
        labels:
          1: R's Home
          2: Work Place
          3: Other Place
          4: Car
          5: Walk
          6: Bus & Subway
          7: Other
    - id: Q40e
      kind: Question
      title: Who was with you?/ Were you still ... (Do not ask question "e" about sleep, sex or other personal care activities.)
      input:
        control: Radio
        labels:
          1: Alone
          2: Spouse/Partner
          3: Child(ren) of Household
          4: Other Family Member(s)
          5: Friend(s)
          6: Other Person(s)
  - id: b_s4_p2_ep13
    title: Activity diary, episode 13
    items:
    - id: Q41a
      kind: Question
      title: And then, what did you do next?
      input:
        control: Textarea
    - id: Q41b
      kind: Question
      title: When did this start?
      input:
        control: Textarea
    - id: Q41c
      kind: Question
      title: When did this end?
      input:
        control: Textarea
    - id: Q41d
      kind: Question
      title: Where were you?/ Were you still ...
      input:
        control: Radio
        labels:
          1: R's Home
          2: Work Place
          3: Other Place
          4: Car
          5: Walk
          6: Bus & Subway
          7: Other
    - id: Q41e
      kind: Question
      title: Who was with you?/ Were you still ... (Do not ask question "e" about sleep, sex or other personal care activities.)
      input:
        control: Radio
        labels:
          1: Alone
          2: Spouse/Partner
          3: Child(ren) of Household
          4: Other Family Member(s)
          5: Friend(s)
          6: Other Person(s)
  - id: b_s4_p2_ep14
    title: Activity diary, episode 14
    items:
    - id: Q42a
      kind: Question
      title: And then, what did you do next?
      input:
        control: Textarea
    - id: Q42b
      kind: Question
      title: When did this start?
      input:
        control: Textarea
    - id: Q42c
      kind: Question
      title: When did this end?
      input:
        control: Textarea
    - id: Q42d
      kind: Question
      title: Where were you?/ Were you still ...
      input:
        control: Radio
        labels:
          1: R's Home
          2: Work Place
          3: Other Place
          4: Car
          5: Walk
          6: Bus & Subway
          7: Other
    - id: Q42e
      kind: Question
      title: Who was with you?/ Were you still ... (Do not ask question "e" about sleep, sex or other personal care activities.)
      input:
        control: Radio
        labels:
          1: Alone
          2: Spouse/Partner
          3: Child(ren) of Household
          4: Other Family Member(s)
          5: Friend(s)
          6: Other Person(s)
  - id: b_s4_p2_ep15
    title: Activity diary, episode 15
    items:
    - id: Q43a
      kind: Question
      title: And then, what did you do next?
      input:
        control: Textarea
    - id: Q43b
      kind: Question
      title: When did this start?
      input:
        control: Textarea
    - id: Q43c
      kind: Question
      title: When did this end?
      input:
        control: Textarea
    - id: Q43d
      kind: Question
      title: Where were you?/ Were you still ...
      input:
        control: Radio
        labels:
          1: R's Home
          2: Work Place
          3: Other Place
          4: Car
          5: Walk
          6: Bus & Subway
          7: Other
    - id: Q43e
      kind: Question
      title: Who was with you?/ Were you still ... (Do not ask question "e" about sleep, sex or other personal care activities.)
      input:
        control: Radio
        labels:
          1: Alone
          2: Spouse/Partner
          3: Child(ren) of Household
          4: Other Family Member(s)
          5: Friend(s)
          6: Other Person(s)
  - id: b_s4_p2_ep16
    title: Activity diary, episode 16
    items:
    - id: Q44a
      kind: Question
      title: And then, what did you do next?
      input:
        control: Textarea
    - id: Q44b
      kind: Question
      title: When did this start?
      input:
        control: Textarea
    - id: Q44c
      kind: Question
      title: When did this end?
      input:
        control: Textarea
    - id: Q44d
      kind: Question
      title: Where were you?/ Were you still ...
      input:
        control: Radio
        labels:
          1: R's Home
          2: Work Place
          3: Other Place
          4: Car
          5: Walk
          6: Bus & Subway
          7: Other
    - id: Q44e
      kind: Question
      title: Who was with you?/ Were you still ... (Do not ask question "e" about sleep, sex or other personal care activities.)
      input:
        control: Radio
        labels:
          1: Alone
          2: Spouse/Partner
          3: Child(ren) of Household
          4: Other Family Member(s)
          5: Friend(s)
          6: Other Person(s)
  - id: b_s4_p2_extra_forms
    title: Additional activity forms
    items:
    - id: GSS2_2D
      kind: Question
      title: 'INTERVIEWER: To record additional activities, use Form GSS 2-2D and "X" the circle below. (If you use GSS 2-2D)'
      input:
        control: Switch
        'on': 'Yes'
        'off': 'No'
    - id: GSS2_2D_N
      kind: Question
      title: Number of forms
      precondition:
      - predicate: GSS2_2D.outcome == 1
        hint: Asked only when question GSS2-2D is "Yes".
      input:
        control: Editbox
        min: 1
        max: 99
  - id: b_s5_happiness
    title: SECTION E
    items:
    - id: E1
      kind: Question
      title: Presently, would you describe yourself as ...
      input:
        control: Radio
        labels:
          1: Very happy
          2: Somewhat happy
          3: Somewhat unhappy
          4: Very unhappy
          5: No opinion
    - id: E2a
      kind: Question
      title: I am going to ask you to rate certain areas of your life. Please rate your feelings about them as very satisfied, somewhat satisfied, somewhat dissatisfied or very dissatisfied. a) Your health
      input:
        control: Radio
        labels:
          1: Satisfied
          2: Dissatisfied
          3: No opinion
    - id: E2a_degree
      kind: Question
      title: 'a) Your health: Somewhat or Very (satisfied or dissatisfied)'
      precondition:
      - predicate: E2a.outcome in [1, 2]
        hint: Asked only when question E2a is one of "Satisfied", "Dissatisfied".
      input:
        control: Radio
        labels:
          1: 'Satisfied: Somewhat'
          2: 'Satisfied: Very'
          3: 'Dissatisfied: Somewhat'
          4: 'Dissatisfied: Very'
    - id: E2b
      kind: Question
      title: b) Your job or main activity
      input:
        control: Radio
        labels:
          4: Satisfied
          5: Dissatisfied
          6: No opinion
    - id: E2b_degree
      kind: Question
      title: 'b) Your job or main activity: Somewhat or Very (satisfied or dissatisfied)'
      precondition:
      - predicate: E2b.outcome in [4, 5]
        hint: Asked only when question E2b is one of "Satisfied", "Dissatisfied".
      input:
        control: Radio
        labels:
          5: 'Satisfied: Somewhat'
          6: 'Satisfied: Very'
          7: 'Dissatisfied: Somewhat'
          8: 'Dissatisfied: Very'
    - id: E2c
      kind: Question
      title: c) The way you spend your other time
      input:
        control: Radio
        labels:
          7: Satisfied
          8: Dissatisfied
          9: No opinion
    - id: E2c_degree
      kind: Question
      title: 'c) The way you spend your other time: Somewhat or Very (satisfied or dissatisfied)'
      precondition:
      - predicate: E2c.outcome in [7, 8]
        hint: Asked only when question E2c is one of "Satisfied", "Dissatisfied".
      input:
        control: Radio
        labels:
          1: 'Satisfied: Somewhat'
          2: 'Satisfied: Very'
          3: 'Dissatisfied: Somewhat'
          4: 'Dissatisfied: Very'
    - id: E2d
      kind: Question
      title: d) Your finances
      input:
        control: Radio
        labels:
          1: Satisfied
          2: Dissatisfied
          3: No opinion
    - id: E2d_degree
      kind: Question
      title: 'd) Your finances: Somewhat or Very (satisfied or dissatisfied)'
      precondition:
      - predicate: E2d.outcome in [1, 2]
        hint: Asked only when question E2d is one of "Satisfied", "Dissatisfied".
      input:
        control: Radio
        labels:
          5: 'Satisfied: Somewhat'
          6: 'Satisfied: Very'
          7: 'Dissatisfied: Somewhat'
          8: 'Dissatisfied: Very'
    - id: E2e
      kind: Question
      title: e) Your housing
      input:
        control: Radio
        labels:
          4: Satisfied
          5: Dissatisfied
          6: No opinion
    - id: E2e_degree
      kind: Question
      title: 'e) Your housing: Somewhat or Very (satisfied or dissatisfied)'
      precondition:
      - predicate: E2e.outcome in [4, 5]
        hint: Asked only when question E2e is one of "Satisfied", "Dissatisfied".
      input:
        control: Radio
        labels:
          1: 'Satisfied: Somewhat'
          2: 'Satisfied: Very'
          3: 'Dissatisfied: Somewhat'
          4: 'Dissatisfied: Very'
    - id: E2f
      kind: Question
      title: f) Your friendships
      input:
        control: Radio
        labels:
          7: Satisfied
          8: Dissatisfied
          9: No opinion
    - id: E2f_degree
      kind: Question
      title: 'f) Your friendships: Somewhat or Very (satisfied or dissatisfied)'
      precondition:
      - predicate: E2f.outcome in [7, 8]
        hint: Asked only when question E2f is one of "Satisfied", "Dissatisfied".
      input:
        control: Radio
        labels:
          5: 'Satisfied: Somewhat'
          6: 'Satisfied: Very'
          7: 'Dissatisfied: Somewhat'
          8: 'Dissatisfied: Very'
    - id: E2g
      kind: Question
      title: g) Living partner or single status
      input:
        control: Radio
        labels:
          1: Satisfied
          2: Dissatisfied
          3: No opinion
    - id: E2g_degree
      kind: Question
      title: 'g) Living partner or single status: Somewhat or Very (satisfied or dissatisfied)'
      precondition:
      - predicate: E2g.outcome in [1, 2]
        hint: Asked only when question E2g is one of "Satisfied", "Dissatisfied".
      input:
        control: Radio
        labels:
          1: 'Satisfied: Somewhat'
          2: 'Satisfied: Very'
          3: 'Dissatisfied: Somewhat'
          4: 'Dissatisfied: Very'
    - id: E2h
      kind: Question
      title: h) Your relationship with other family members
      input:
        control: Radio
        labels:
          4: Satisfied
          5: Dissatisfied
          6: No opinion
    - id: E2h_degree
      kind: Question
      title: 'h) Your relationship with other family members: Somewhat or Very (satisfied or dissatisfied)'
      precondition:
      - predicate: E2h.outcome in [4, 5]
        hint: Asked only when question E2h is one of "Satisfied", "Dissatisfied".
      input:
        control: Radio
        labels:
          5: 'Satisfied: Somewhat'
          6: 'Satisfied: Very'
          7: 'Dissatisfied: Somewhat'
          8: 'Dissatisfied: Very'
    - id: E2i
      kind: Question
      title: i) Yourself (self-esteem)
      input:
        control: Radio
        labels:
          7: Satisfied
          8: Dissatisfied
          9: No opinion
    - id: E2i_degree
      kind: Question
      title: 'i) Yourself (self-esteem): Somewhat or Very (satisfied or dissatisfied)'
      precondition:
      - predicate: E2i.outcome in [7, 8]
        hint: Asked only when question E2i is one of "Satisfied", "Dissatisfied".
      input:
        control: Radio
        labels:
          1: 'Satisfied: Somewhat'
          2: 'Satisfied: Very'
          3: 'Dissatisfied: Somewhat'
          4: 'Dissatisfied: Very'
    - id: E3
      kind: Question
      title: Now, using the same scale, how do you feel about your life as a whole right now?
      input:
        control: Radio
        labels:
          1: 'Satisfied: Very'
          2: 'Satisfied: Somewhat'
          3: 'Dissatisfied: Somewhat'
          4: 'Dissatisfied: Very'
          5: No opinion
  - id: b_s6_main_language
    title: SECTION F
    items:
    - id: F1
      kind: Question
      title: What is your main language, that is, the language in which you are most at ease? (Report two if the respondent is equally at ease in two languages)
      input:
        control: Radio
        labels:
          1: English
          2: English and French
          3: English and Other (specify)
          4: French
          5: French and Other (specify)
          6: Other (specify)
    - id: F1a
      kind: Question
      title: Have you ever had any knowledge or understanding of a language other than English?
      precondition:
      - predicate: F1.outcome == 1
        hint: Asked only when question F1 is "English".
      - predicate: not (F1.outcome == 2)
        hint: Asked only when question F1 is not "English and French".
      input:
        control: Radio
        labels:
          7: 'Yes'
          8: 'No'
  - id: b_s7_french_screen
    title: 'SECTION G: Knowledge of French'
    precondition:
    - predicate: not (F1.outcome == 2)
      hint: Asked only when question F1 is not "English and French".
    items:
    - id: G1
      kind: Question
      title: Do you have any knowledge or understanding of French?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
  - id: b_s7_french_detail
    title: Use and ability in French
    precondition:
    - predicate: not (F1.outcome == 2)
      hint: Asked only when question F1 is not "English and French".
    - predicate: not (G1.outcome == 2)
      hint: Asked only when question G1 is not "No".
    items:
    - id: G2
      kind: Question
      title: When was the last time that you had a conversation in French, excluding language courses?
      input:
        control: Radio
        labels:
          1: During the last week
          2: During the last month
          3: During the last year
          4: More than a year
          5: Never
    - id: G3a
      kind: Question
      title: How would you rate yourself in the following language abilities in French? Reading
      input:
        control: Radio
        labels:
          1: Very good
          2: Good
          3: Not very good
          4: Not at all
    - id: G3b
      kind: Question
      title: How would you rate yourself in the following language abilities in French? Understanding
      input:
        control: Radio
        labels:
          5: Very good
          6: Good
          7: Not very good
          8: Not at all
    - id: G3c
      kind: Question
      title: How would you rate yourself in the following language abilities in French? Speaking
      input:
        control: Radio
        labels:
          9: Very good
          10: Good
          11: Not very good
          12: Not at all
    - id: G4
      kind: Question
      title: What would you say contributed the most to your present knowledge of French? (Accept multiple response)
      input:
        control: Checkbox
        labels:
          1: Language instruction at school
          2: Other language courses
          4: Speaking with family
          8: Speaking with friends
          16: Speaking at work
          32: Watching television
          64: Other (specify)
    - id: G5a
      kind: Question
      title: Compared to five years ago, would you say that you now ... more French, less French or about the same? KNOW
      input:
        control: Radio
        labels:
          1: More
          2: Less
          3: Same
    - id: G5b
      kind: Question
      title: Compared to five years ago, would you say that you now ... more French, less French or about the same? USE
      input:
        control: Radio
        labels:
          4: More
          5: Less
          6: Same
  - id: b_s7_other_languages
    title: Other languages and English
    precondition:
    - predicate: not (F1.outcome == 2)
      hint: Asked only when question F1 is not "English and French".
    items:
    - id: G6
      kind: Question
      title: Do you have any knowledge or understanding of a language other than English or French?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: G6a
      kind: Question
      title: How many other languages do you know or understand?
      precondition:
      - predicate: G6.outcome == 1
        hint: Asked only when question G6 is "Yes".
      input:
        control: Radio
        labels:
          3: One language (specify)
          4: ___ languages
    - id: G6b
      kind: Question
      title: Which one do you know best? (specify)
      precondition:
      - predicate: G6a.outcome == 4
        hint: Asked only when question G6a is "___ languages".
      input:
        control: Textarea
    - id: G7
      kind: Question
      title: When was the last time you had a conversation in that language (language reported in G6), excluding language courses?
      input:
        control: Radio
        labels:
          5: During the last week
          6: During the last month
          7: During the last year
          8: More than a year
          9: Never
    - id: G8a
      kind: Question
      title: In that language (language reported in G6), how would you rate yourself in the following abilities? Reading
      input:
        control: Radio
        labels:
          1: Very good
          2: Good
          3: Not very good
          4: Not at all
    - id: G8b
      kind: Question
      title: In that language (language reported in G6), how would you rate yourself in the following abilities? Understanding
      input:
        control: Radio
        labels:
          5: Very good
          6: Good
          7: Not very good
          8: Not at all
    - id: G8c
      kind: Question
      title: In that language (language reported in G6), how would you rate yourself in the following abilities? Speaking
      input:
        control: Radio
        labels:
          9: Very good
          10: Good
          11: Not very good
          12: Not at all
    - id: G10
      kind: Question
      title: Compared to five years ago, would you say that you now use more English, less English or about the same?
      input:
        control: Radio
        labels:
          1: More
          2: Less
          3: Same
  - id: b_s8_change_in_language
    title: 'SECTION H: Change in knowledge and use of English and French'
    items:
    - id: H1a
      kind: Question
      title: Compared to five years ago, would you say that you now... more English, less English or about the same? KNOW
      input:
        control: Radio
        labels:
          1: More
          2: Less
          3: Same
    - id: H1b
      kind: Question
      title: Compared to five years ago, would you say that you now... more English, less English or about the same? USE
      input:
        control: Radio
        labels:
          4: More
          5: Less
          6: Same
    - id: H2a
      kind: Question
      title: Compared to five years ago, would you say that you now... more French, less French or about the same? KNOW
      input:
        control: Radio
        labels:
          4: More
          5: Less
          6: Same
    - id: H2b
      kind: Question
      title: Compared to five years ago, would you say that you now... more French, less French or about the same? USE
      input:
        control: Radio
        labels:
          7: More
          8: Less
          9: Same
  - id: b_s8_other_languages
    title: Other languages
    items:
    - id: H3
      kind: Question
      title: Do you have any knowledge or understanding of a language other than English or French?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: H3a
      kind: Question
      title: How many other languages do you know or understand?
      precondition:
      - predicate: H3.outcome == 1
        hint: Asked only when question H3 is "Yes".
      input:
        control: Radio
        labels:
          3: One language (specify)
          4: ___ languages
    - id: H3b
      kind: Question
      title: Which one do you know best? (specify)
      precondition:
      - predicate: H3a.outcome == 4
        hint: Asked only when question H3a is "___ languages".
      input:
        control: Textarea
    - id: H4
      kind: Question
      title: When was the last time you had a conversation in that language (language reported in H3) excluding language courses?
      input:
        control: Radio
        labels:
          5: During the last week
          6: During the last month
          7: During the last year
          8: More than a year
          9: Never
    - id: H5a
      kind: Question
      title: In that language (language reported in H3), how would you rate yourself in the following abilities? Reading
      input:
        control: Radio
        labels:
          1: Very good
          2: Good
          3: Not very good
          4: Not at all
    - id: H5b
      kind: Question
      title: In that language (language reported in H3), how would you rate yourself in the following abilities? Understanding
      input:
        control: Radio
        labels:
          5: Very good
          6: Good
          7: Not very good
          8: Not at all
    - id: H5c
      kind: Question
      title: In that language (language reported in H3), how would you rate yourself in the following abilities? Speaking
      input:
        control: Radio
        labels:
          9: Very good
          10: Good
          11: Not very good
          12: Not at all
  - id: b_s9_english_and_screen
    title: SECTION J
    items:
    - id: J1_KNOW
      kind: Question
      title: J1. Compared to five years ago, would you say that you now... more English, less English or about the same? KNOW
      input:
        control: Radio
        labels:
          1: More
          2: Less
          3: Same
    - id: J1_USE
      kind: Question
      title: J1. Compared to five years ago, would you say that you now... more English, less English or about the same? USE
      input:
        control: Radio
        labels:
          4: More
          5: Less
          6: Same
    - id: J2
      kind: Question
      title: J2. Do you have any knowledge or understanding of French?
      input:
        control: Radio
        labels:
          7: 'Yes'
          8: 'No'
  - id: b_s9_french
    title: French knowledge and use
    precondition:
    - predicate: not (J2.outcome == 8)
      hint: Asked only when question J2 is not "No".
    items:
    - id: J3
      kind: Question
      title: J3. When was the last time you had a conversation in French, excluding language courses?
      input:
        control: Radio
        labels:
          1: During the last week
          2: During the last month
          3: During the last year
          4: More than a year
          5: Never
    - id: J4_Reading
      kind: Question
      title: J4. How would you rate yourself in the following language abilities in French? Reading
      input:
        control: Radio
        labels:
          1: Very good
          2: Good
          3: Not very good
          4: Not at all
    - id: J4_Understanding
      kind: Question
      title: J4. How would you rate yourself in the following language abilities in French? Understanding
      input:
        control: Radio
        labels:
          5: Very good
          6: Good
          7: Not very good
          8: Not at all
    - id: J4_Speaking
      kind: Question
      title: J4. How would you rate yourself in the following language abilities in French? Speaking
      input:
        control: Radio
        labels:
          9: Very good
          10: Good
          11: Not very good
          12: Not at all
    - id: J5
      kind: Question
      title: J5. What would you say contributed the most to your present knowledge of French? (Accept multiple response)
      input:
        control: Checkbox
        labels:
          1: 1 — Language instruction at school
          2: 2 — Other language courses
          4: 3 — Speaking with family
          8: 4 — Speaking with friends
          16: 5 — Speaking at work
          32: 6 — Watching television
          64: 7 — Other (specify)
    - id: J6_KNOW
      kind: Question
      title: J6. Compared to five years ago, would you say that you now... more French, less French or about the same? KNOW
      input:
        control: Radio
        labels:
          1: More
          2: Less
          3: Same
    - id: J6_USE
      kind: Question
      title: J6. Compared to five years ago, would you say that you now... more French, less French or about the same? USE
      input:
        control: Radio
        labels:
          4: More
          5: Less
          6: Same
  - id: b_s9_other_languages
    title: Other languages
    items:
    - id: J7
      kind: Question
      title: J7. Other than English or French, how many languages do you know or understand? ___ languages
      input:
        control: Editbox
        min: 0
        max: 99
  - id: b_s10_english
    title: 'SECTION K: English'
    items:
    - id: K1
      kind: Question
      title: K1 How would you rate your ability to read in English? Is it...
      input:
        control: Radio
        labels:
          1: Very good
          2: Good
          3: Not very good
          4: Not at all
    - id: K2
      kind: Question
      title: K2 What would you say contributed the most to your present knowledge of English? (Accept multiple response)
      input:
        control: Checkbox
        labels:
          1: 1 — Language instruction at school
          2: 2 — Other language courses
          4: 3 — Speaking with family
          8: 4 — Speaking with friends
          16: 5 — Speaking at work
          32: 6 — Watching television
          64: 7 — Other (specify)
    - id: K3_KNOW
      kind: Question
      title: K3 Compared to five years ago, would you say that you now... more English, less English or about the same? KNOW
      input:
        control: Radio
        labels:
          4: More
          5: Less
          6: Same
    - id: K3_USE
      kind: Question
      title: K3 Compared to five years ago, would you say that you now... more English, less English or about the same? USE
      input:
        control: Radio
        labels:
          7: More
          8: Less
          9: Same
    - id: K4
      kind: Question
      title: K4 Do you have any knowledge or understanding of a language other than English or French?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
  - id: b_s10_k4_detail
    title: Other languages known
    precondition:
    - predicate: K4.outcome == 1
      hint: Asked only when question K4 is "Yes".
    - predicate: not (K4.outcome == 2)
      hint: Asked only when question K4 is not "No".
    items:
    - id: K4_how_many
      kind: Question
      title: How many other languages do you know or understand?
      input:
        control: Radio
        labels:
          3: One language (specify)
          4: ___ languages
    - id: K4_language
      kind: Question
      title: One language (specify) / Which one do you know best? (specify)
      input:
        control: Textarea
  - id: b_s10_k5_k6
    title: Use and ability in the other language
    precondition:
    - predicate: not (K4.outcome == 2)
      hint: Asked only when question K4 is not "No".
    items:
    - id: K5
      kind: Question
      title: K5 When was the last time you had a conversation in that language (language reported in K4) excluding language courses?
      input:
        control: Radio
        labels:
          5: During the last week
          6: During the last month
          7: During the last year
          8: More than a year
          9: Never
    - id: K6_Reading
      kind: Question
      title: K6 In that language (language reported in K4), how would you rate yourself in the following abilities? Reading
      input:
        control: Radio
        labels:
          1: Very good
          2: Good
          3: Not very good
          4: Not at all
    - id: K6_Understanding
      kind: Question
      title: K6 In that language (language reported in K4), how would you rate yourself in the following abilities? Understanding
      input:
        control: Radio
        labels:
          5: Very good
          6: Good
          7: Not very good
          8: Not at all
    - id: K6_Speaking
      kind: Question
      title: K6 In that language (language reported in K4), how would you rate yourself in the following abilities? Speaking
      input:
        control: Radio
        labels:
          9: Very good
          10: Good
          11: Not very good
          12: Not at all
  - id: b_s10_french
    title: French use over time
    items:
    - id: K7
      kind: Question
      title: K7 Compared to five years ago, would you say that you now use more French, less French or about the same?
      input:
        control: Radio
        labels:
          1: More
          2: Less
          3: Same
  - id: b_s11_language_change
    title: SECTION L
    items:
    - id: L1_KNOW
      kind: Question
      title: L1 Compared to five years ago, would you say that you now... more French, less French or about the same? KNOW
      input:
        control: Radio
        labels:
          1: More
          2: Less
          3: Same
    - id: L1_USE
      kind: Question
      title: L1 Compared to five years ago, would you say that you now... more French, less French or about the same? USE
      input:
        control: Radio
        labels:
          4: More
          5: Less
          6: Same
    - id: L2
      kind: Question
      title: L2 How would you rate your ability to read in English? Is it...
      input:
        control: Radio
        labels:
          6: Very good
          7: Good
          8: Not very good
          9: Not at all
    - id: L3
      kind: Question
      title: L3 What would you say contributed the most to your present knowledge of English? (Accept multiple response)
      input:
        control: Checkbox
        labels:
          1: 1 — Language instruction at school
          2: 2 — Other language courses
          4: 3 — Speaking with family
          8: 4 — Speaking with friends
          16: 5 — Speaking at work
          32: 6 — Watching television
          64: 7 — Other (specify)
    - id: L4_KNOW
      kind: Question
      title: L4 Compared to five years ago, would you say that you now... more English, less English or about the same? KNOW
      input:
        control: Radio
        labels:
          4: More
          5: Less
          6: Same
    - id: L4_USE
      kind: Question
      title: L4 Compared to five years ago, would you say that you now... more English, less English or about the same? USE
      input:
        control: Radio
        labels:
          7: More
          8: Less
          9: Same
    - id: L5
      kind: Question
      title: L5 Other than English or French, how many languages do you know or understand? ___ languages
      input:
        control: Editbox
        min: 0
        max: 50
        right: languages
  - id: b_s12_english
    title: 'SECTION M: English'
    items:
    - id: M1
      kind: Question
      title: M1. How would you rate your ability to read in English? Is it...
      input:
        control: Radio
        labels:
          1: Very good
          2: Good
          3: Not very good
          4: Not at all
    - id: M2
      kind: Question
      title: M2. What would you say contributed the most to your present knowledge of English? (Accept multiple response)
      input:
        control: Checkbox
        labels:
          1: 1 — Language instruction at school
          2: 2 — Other language courses
          4: 3 — Speaking with family
          8: 4 — Speaking with friends
          16: 5 — Speaking at work
          32: 6 — Watching television
          64: 7 — Other (specify)
    - id: M3_KNOW
      kind: Question
      title: M3. Compared to five years ago, would you say that you now... more English, less English or about the same? KNOW
      input:
        control: Radio
        labels:
          4: More
          5: Less
          6: Same
    - id: M3_USE
      kind: Question
      title: M3. Compared to five years ago, would you say that you now... more English, less English or about the same? USE
      input:
        control: Radio
        labels:
          7: More
          8: Less
          9: Same
  - id: b_s12_french_screen
    title: 'SECTION M: French knowledge'
    items:
    - id: M4
      kind: Question
      title: M4 Do you have any knowledge or understanding of French?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
  - id: b_s12_french_details
    title: 'SECTION M: French use and ability'
    precondition:
    - predicate: not (M4.outcome == 2)
      hint: Asked only when question M4 is not "No".
    items:
    - id: M5
      kind: Question
      title: M5. When was the last time you had a conversation in French, excluding language courses?
      input:
        control: Radio
        labels:
          3: During the last week
          4: During the last month
          5: During the last year
          6: More than a year
          7: Never
    - id: M6_Reading
      kind: Question
      title: M6 How would you rate yourself in the following language abilities in French? Reading
      input:
        control: Radio
        labels:
          1: Very good
          2: Good
          3: Not very good
          4: Not at all
    - id: M6_Understanding
      kind: Question
      title: M6 How would you rate yourself in the following language abilities in French? Understanding
      input:
        control: Radio
        labels:
          5: Very good
          6: Good
          7: Not very good
          8: Not at all
    - id: M6_Speaking
      kind: Question
      title: M6 How would you rate yourself in the following language abilities in French? Speaking
      input:
        control: Radio
        labels:
          9: Very good
          10: Good
          11: Not very good
          12: Not at all
    - id: M7
      kind: Question
      title: M7 What would you say contributed the most to your present knowledge of French? (Accept multiple response)
      input:
        control: Checkbox
        labels:
          1: 1 — Language instruction at school
          2: 2 — Other language courses
          4: 3 — Speaking with family
          8: 4 — Speaking with friends
          16: 5 — Speaking at work
          32: 6 — Watching television
          64: 7 — Other (specify)
    - id: M8_KNOW
      kind: Question
      title: M8. Compared to five years ago, would you say that you now... more French, less French or about the same? KNOW
      input:
        control: Radio
        labels:
          4: More
          5: Less
          6: Same
    - id: M8_USE
      kind: Question
      title: M8. Compared to five years ago, would you say that you now... more French, less French or about the same? USE
      input:
        control: Radio
        labels:
          7: More
          8: Less
          9: Same
  - id: b_s12_other_languages
    title: 'SECTION M: Other languages'
    items:
    - id: M9
      kind: Question
      title: M9 Other than English or French, how many languages do you know or understand?
      input:
        control: Editbox
        min: 0
        max: 20
        right: languages
  - id: b_s13_home_languages
    title: 'SECTION N: Languages spoken in the home before age six'
    items:
    - id: N1
      kind: Question
      title: N1 Before you were six years old, which languages were spoken in your home by people living there?
      input:
        control: Checkbox
        labels:
          1: 1 — English
          2: 2 — French
          4: 3 — Other (specify)
  - id: b_s13_own_language_childhood
    title: Languages the respondent spoke at home
    precondition:
    - predicate: not (N1.outcome in [1, 2, 4])
      hint: Asked only when question N1 is none of "1 — English", "2 — French", "3 — Other (specify)".
    items:
    - id: N3
      kind: Question
      title: N3. Which languages did you yourself speak at home?
      input:
        control: Checkbox
        labels:
          1: 1 — English
          2: 2 — French
          4: 3 — Other (specify)
    - id: N3_most_often
      kind: Question
      title: N3. (Most often)
      input:
        control: Radio
        labels:
          4: English
          5: French
          6: Other (specify)
          7: Other (specify), second line
    - id: N3_90
      kind: Question
      title: Did you speak this language at home more than 90% of the time?
      input:
        control: Radio
        labels:
          8: 'Yes'
          9: 'No'
  - id: b_s13_age15_and_friends
    title: Languages at age fifteen and with friends
    items:
    - id: N4
      kind: Question
      title: N4 When you were fifteen years old, which languages did you yourself speak at home?
      input:
        control: Checkbox
        labels:
          1: 3 — English
          2: 4 — French
          4: 5 — Other (specify)
    - id: N4_most_often
      kind: Question
      title: N4 (Most often)
      input:
        control: Radio
        labels:
          6: English
          7: French
          8: Other (specify)
          9: Other (specify), second line
    - id: N5
      kind: Question
      title: N5. At that time, which languages did you speak with your friends?
      input:
        control: Checkbox
        labels:
          1: 1 — English
          2: 2 — French
          4: 3 — Other (specify)
    - id: N5_most_often
      kind: Question
      title: N5. (Most often)
      input:
        control: Radio
        labels:
          4: English
          5: French
          6: Other (specify)
          7: Other (specify), second line
  - id: b_s14_p1
    title: 'SECTION P: Education'
    items:
    - id: P1
      kind: Question
      title: P1 How many years of elementary and secondary education have you completed?
      input:
        control: Dropdown
        labels:
          0: No schooling
          5: One to five years
          6: Six
          7: Seven
          8: Eight
          9: Nine
          10: Ten
          11: Eleven
          12: Twelve
          13: Thirteen
  - id: b_s14_p1a
    title: Primary school languages (after P1)
    precondition:
    - predicate: not (P1.outcome == 0)
      hint: Asked only when question P1 is not "No schooling".
    - predicate: not (P1.outcome in [9, 10])
      hint: Asked only when question P1 is none of "Nine", "Ten".
    - predicate: not (P1.outcome in [11, 12, 13])
      hint: Asked only when question P1 is none of "Eleven", "Twelve", "Thirteen".
    items:
    - id: P1a
      kind: Question
      title: Which languages were used for teaching your courses at primary school, excluding language courses? (Most often) — printed unnumbered under P1 after codes 05–08
      input:
        control: Checkbox
        labels:
          1: 1 — English
          2: 2 — French
          4: 3 — Other (specify)
    - id: P1a_most_often
      kind: Question
      title: Which languages were used for teaching your courses at primary school, excluding language courses? (Most often) — unnumbered, under P1
      input:
        control: Radio
        labels:
          4: Language 1 (most often)
          5: Language 2
          6: Language 3
          7: Language 4
  - id: b_s14_p1b
    title: Secondary school graduation
    items:
    - id: P1b
      kind: Question
      title: Have you graduated from secondary school? — printed unnumbered under P1 after codes 11–13
      precondition:
      - predicate: not (P1.outcome == 0)
        hint: Asked only when question P1 is not "No schooling".
      - predicate: not (P1.outcome in [9, 10])
        hint: Asked only when question P1 is none of "Nine", "Ten".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
  - id: b_s14_p2_p3
    title: Languages of instruction, primary and secondary school
    precondition:
    - predicate: not (P1.outcome == 0)
      hint: Asked only when question P1 is not "No schooling".
    items:
    - id: P2
      kind: Question
      title: P2. Which languages were used for teaching your courses at primary school, excluding language courses?
      input:
        control: Checkbox
        labels:
          1: 1 — English
          2: 2 — French
          4: 3 — Other (specify)
    - id: P2_most_often
      kind: Question
      title: P2. (Most often)
      input:
        control: Radio
        labels:
          4: Language 1 (most often)
          5: Language 2
          6: Language 3
          7: Language 4
    - id: P3
      kind: Question
      title: P3. What about languages used for teaching your courses at secondary school, excluding language courses?
      input:
        control: Checkbox
        labels:
          1: 3 — English
          2: 4 — French
          4: 5 — Other (specify)
    - id: P3_most_often
      kind: Question
      title: P3. (Most often)
      input:
        control: Radio
        labels:
          6: Language 1 (most often)
          7: Language 2
          8: Language 3
          9: Language 4
  - id: b_s14_further
    title: Further schooling
    precondition:
    - predicate: not (P1.outcome == 0)
      hint: Asked only when question P1 is not "No schooling".
    items:
    - id: P4
      kind: Question
      title: P4 Have you had any further schooling beyond elementary/secondary school?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
  - id: b_s14_p5_p6
    title: Post-secondary languages and level
    precondition:
    - predicate: not (P1.outcome == 0)
      hint: Asked only when question P1 is not "No schooling".
    - predicate: not (P4.outcome == 2)
      hint: Asked only when question P4 is not "No".
    items:
    - id: P5
      kind: Question
      title: P5. Which languages were/are used for teaching your courses at these levels, excluding language courses?
      input:
        control: Checkbox
        labels:
          1: 3 — English
          2: 4 — French
          4: 5 — Other (specify)
    - id: P5_most_often
      kind: Question
      title: P5. (Most often)
      input:
        control: Radio
        labels:
          6: Language 1 (most often)
          7: Language 2
          8: Language 3
          9: Language 4
    - id: P6
      kind: Question
      title: P6 What is the highest level you attained? (Accept one response only)
      input:
        control: Radio
        labels:
          1: Some community college, CEGEP or nursing school
          2: Diploma or certificate from community college, CEGEP or nursing school
          3: Some university
          4: Bachelor or undergraduate degree or teacher's college
          5: Master's or earned doctorate
          6: Other (specify)
  - id: b_s14_p7_p8
    title: Year of highest level and first job
    precondition:
    - predicate: not (P1.outcome == 0)
      hint: Asked only when question P1 is not "No schooling".
    items:
    - id: P7
      kind: Question
      title: P7. In which year did you reach your highest level of education?
      input:
        control: Editbox
        min: 1900
        max: 1986
    - id: P8
      kind: Question
      title: P8 Think about the first full-time job you had after reaching your highest level of education in . . . (date reported in P7). Were you an employee working for someone else or self-employed?
      input:
        control: Radio
        labels:
          1: An employee working for someone else
          2: Self-employed
          3: Never had a full-time job after this date
  - id: b_s14_p9
    title: 'First job: employer'
    precondition:
    - predicate: not (P1.outcome == 0)
      hint: Asked only when question P1 is not "No schooling".
    - predicate: not (P8.outcome == 2)
      hint: Asked only when question P8 is not "Self-employed".
    - predicate: not (P8.outcome == 3)
      hint: Asked only when question P8 is not "Never had a full-time job after this date".
    items:
    - id: P9
      kind: Question
      title: P9. For whom did you work? (Name of business, government department or agency or person)
      input:
        control: Textarea
  - id: b_s14_p10_p12
    title: 'First job: industry, occupation, start year'
    precondition:
    - predicate: not (P1.outcome == 0)
      hint: Asked only when question P1 is not "No schooling".
    - predicate: not (P8.outcome == 3)
      hint: Asked only when question P8 is not "Never had a full-time job after this date".
    items:
    - id: P10
      kind: Question
      title: 'P10 What was the main kind of business, industry or service? (Give a full description: e.g., paper box manufacturing, retail shoe store, municipal board of education)'
      input:
        control: Textarea
    - id: P11
      kind: Question
      title: 'P11 What kind of work were you doing? (Give a full description: e.g., posting invoices, selling shoes, teaching primary school)'
      input:
        control: Textarea
    - id: P12
      kind: Question
      title: P12. In what year did you begin working at this job?
      postcondition:
      - predicate: P12.outcome >= P7.outcome
        hint: The year you began this job (P12) cannot be earlier than the year you reached your highest level of education (P7).
        invented: true
      input:
        control: Editbox
        min: 1900
        max: 1986
  - id: b_s14_p13
    title: Language courses in full-time school
    precondition:
    - predicate: not (P1.outcome == 0)
      hint: Asked only when question P1 is not "No schooling".
    items:
    - id: P13
      kind: Question
      title: P13. Have you ever taken any language courses as part of full-time school?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: P13_languages
      kind: Question
      title: Which languages?
      precondition:
      - predicate: P13.outcome == 1
        hint: Asked only when question P13 is "Yes".
      input:
        control: Checkbox
        labels:
          1: English
          2: French
          4: Other (specify)
  - id: b_s14_p14
    title: Language courses outside full-time school
    items:
    - id: P14
      kind: Question
      title: P14. Have you ever taken any language courses outside of full-time school?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: P14_languages
      kind: Question
      title: Which languages?
      precondition:
      - predicate: P14.outcome == 1
        hint: Asked only when question P14 is "Yes".
      input:
        control: Checkbox
        labels:
          1: English
          2: French
          4: Other (specify)
  - id: b_s15_home
    title: 'SECTION Q: Language use at home'
    items:
    - id: Q1
      kind: Question
      title: Q1. Think about the people you live with. Which languages do you speak among yourselves at home?
      input:
        control: Checkbox
        labels:
          1: Live alone
          2: English
          4: French
          8: Other (specify)
  - id: b_s15_home_self
    title: Own language at home
    precondition:
    - predicate: not (Q1.outcome % 2 == 1)
      hint: Asked only when question Q1 does not include "Live alone".
    - predicate: not (Q1.outcome in [2, 4, 8])
      hint: Asked only when question Q1 is none of "English", "French", "Other (specify)".
    items:
    - id: Q3
      kind: Question
      title: Q3. Which languages do you yourself speak at home? (Most often)
      input:
        control: Checkbox
        labels:
          1: English
          2: French
          4: Other (specify)
    - id: Q3_90
      kind: Question
      title: Do you speak this language at home more than 90% of the time?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
  - id: b_s15_friends_activity
    title: Friends and main activity
    items:
    - id: Q4
      kind: Question
      title: Q4. Which languages do you yourself speak with your friends outside your home? (Most often)
      input:
        control: Checkbox
        labels:
          1: English
          2: French
          4: Other (specify)
    - id: Q5
      kind: Question
      title: Q5. Which of the following best describes your main activity during the last 7 days? Were you mainly . . . (Accept one response only)
      input:
        control: Radio
        labels:
          1: Working at a job or business
          2: Looking for work
          3: A student
          4: Keeping house
          5: Retired
          6: Other (specify)
    - id: Q6
      kind: Question
      title: Q6. What about your main activity during the last 12 months? Were you mainly . . . (Accept one response only)
      input:
        control: Radio
        labels:
          1: Working at a job or business
          2: Looking for work
          3: A student
          4: Keeping house
          5: Retired
          6: Other (specify)
    - id: Q7
      kind: Question
      title: Q7. Did you have a job at any time during the last 12 months?
      precondition:
      - predicate: not (Q6.outcome == 1)
        hint: Asked only when question Q6 is not "Working at a job or business".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
  - id: b_s15_work
    title: Work and work languages
    precondition:
    - predicate: not (Q7.outcome == 2)
      hint: Asked only when question Q7 is not "No".
    items:
    - id: Q8
      kind: Question
      title: Q8. For how many weeks of those 12 months did you do any work at a job or business? (Include vacation, illness, strikes, lock-outs and paid maternity leave) ____ weeks (Code number from 00 to 52)
      input:
        control: Editbox
        min: 0
        max: 52
        right: weeks
    - id: Q9
      kind: Question
      title: Q9 During those weeks of work were you mainly . . .
      input:
        control: Radio
        labels:
          1: An employee working for someone else
          2: Self-employed
    - id: Q10
      kind: Question
      title: Q10 During those weeks of work were you mostly full-time or part-time?
      precondition:
      - predicate: not (Q9.outcome == 2)
        hint: Asked only when question Q9 is not "Self-employed".
      input:
        control: Radio
        labels:
          1: Full-time
          2: Part-time
    - id: Q11
      kind: Question
      title: Q11. For whom do you/did you last work? (Name of business, government department or agency or person)
      precondition:
      - predicate: not (Q9.outcome == 2)
        hint: Asked only when question Q9 is not "Self-employed".
      input:
        control: Textarea
    - id: Q12
      kind: Question
      title: 'Q12. What was the main kind of business, industry or service? (Give a full description: e.g., paper box manufacturing, retail shoe store, municipal board of education)'
      input:
        control: Textarea
    - id: Q13
      kind: Question
      title: 'Q13. What kind of work were you doing? (Give a full description: e.g., posting invoices, selling shoes, teaching primary school)'
      input:
        control: Textarea
    - id: Q14
      kind: Question
      title: Q14 Which languages are/were spoken at work by people with whom you have/had regular contact?
      input:
        control: Checkbox
        labels:
          1: English
          2: French
          4: Other (specify)
    - id: Q15
      kind: Question
      title: Q15 Considering the last 12 months, which languages have you yourself spoken at work? (Most often)
      input:
        control: Checkbox
        labels:
          1: English
          2: French
          4: Other (specify)
    - id: Q15_90
      kind: Question
      title: Did you speak this language at work more than 90% of the time?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: Q16
      kind: Question
      title: Q16 During the last 12 months have you done any writing at work?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: Q17
      kind: Question
      title: Q17 Over this period, which languages did you yourself use for writing at work? (Most often)
      precondition:
      - predicate: not (Q16.outcome == 2)
        hint: Asked only when question Q16 is not "No".
      input:
        control: Checkbox
        labels:
          1: English
          2: French
          4: Other (specify)
    - id: Q17_90
      kind: Question
      title: Did you use this language for writing at work more than 90 % of the time?
      precondition:
      - predicate: not (Q16.outcome == 2)
        hint: Asked only when question Q16 is not "No".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
  - id: b_s16_r1
    title: SECTION R - Federal agency contacts
    items:
    - id: R1a
      kind: Question
      title: R1 During this period, have you talked with employees of the following federal agencies in connection with the services they provide? — Post Office (excluding letter carriers)
      input:
        control: Radio
        labels:
          1: 'No'
          2: 'Yes'
    - id: R1b
      kind: Question
      title: R1 … Canada Employment or Immigration Centres
      input:
        control: Radio
        labels:
          3: 'No'
          4: 'Yes'
    - id: R1c
      kind: Question
      title: R1 … Old age security or family allowance
      input:
        control: Radio
        labels:
          5: 'No'
          6: 'Yes'
    - id: R1d
      kind: Question
      title: R1 … National parks
      input:
        control: Radio
        labels:
          7: 'No'
          8: 'Yes'
    - id: R1e
      kind: Question
      title: R1 … Federal personal income tax
      input:
        control: Radio
        labels:
          9: 'No'
          10: 'Yes'
    - id: R1f
      kind: Question
      title: R1 … Customs, at border crossings only
      input:
        control: Radio
        labels:
          11: 'No'
          12: 'Yes'
    - id: R1g
      kind: Question
      title: R1 … R.C.M.P.
      input:
        control: Radio
        labels:
          13: 'No'
          14: 'Yes'
    - id: R1h
      kind: Question
      title: R1 … Air Canada
      input:
        control: Radio
        labels:
          15: 'No'
          16: 'Yes'
    - id: R1i
      kind: Question
      title: R1 … Agriculture Canada
      input:
        control: Radio
        labels:
          17: 'No'
          18: 'Yes'
    - id: R1j
      kind: Question
      title: R1 … Via Rail or CN Marine
      input:
        control: Radio
        labels:
          19: 'No'
          20: 'Yes'
    - id: R1k
      kind: Question
      title: R1 … Federal Public Service Commission
      input:
        control: Radio
        labels:
          21: 'No'
          22: 'Yes'
  - id: b_s16_r2
    title: R2 Language of service
    precondition:
    - predicate: not (R1a.outcome == 1 and R1b.outcome == 3 and R1c.outcome == 5 and R1d.outcome == 7 and R1e.outcome == 9 and R1f.outcome == 11 and R1g.outcome == 13 and R1h.outcome == 15 and R1i.outcome == 17 and R1j.outcome == 19 and R1k.outcome == 21)
      hint: Asked only when at least one agency contact was reported in R1.
    items:
    - id: R2a
      kind: Question
      title: R2 In your last contact with ... (agency), in which language did you obtain service? — Post Office (excluding letter carriers)
      precondition:
      - predicate: R1a.outcome == 2
        hint: Asked only when question R1a is "Yes".
      input:
        control: Radio
        labels:
          1: English
          2: French
          3: Other
    - id: R2b
      kind: Question
      title: R2 … Canada Employment or Immigration Centres
      precondition:
      - predicate: R1b.outcome == 4
        hint: Asked only when question R1b is "Yes".
      input:
        control: Radio
        labels:
          4: English
          5: French
          6: Other
    - id: R2c
      kind: Question
      title: R2 … Old age security or family allowance
      precondition:
      - predicate: R1c.outcome == 6
        hint: Asked only when question R1c is "Yes".
      input:
        control: Radio
        labels:
          7: English
          8: French
          9: Other
    - id: R2d
      kind: Question
      title: R2 … National parks
      precondition:
      - predicate: R1d.outcome == 8
        hint: Asked only when question R1d is "Yes".
      input:
        control: Radio
        labels:
          10: English
          11: French
          12: Other
    - id: R2e
      kind: Question
      title: R2 … Federal personal income tax
      precondition:
      - predicate: R1e.outcome == 10
        hint: Asked only when question R1e is "Yes".
      input:
        control: Radio
        labels:
          13: English
          14: French
          15: Other
    - id: R2f
      kind: Question
      title: R2 … Customs, at border crossings only
      precondition:
      - predicate: R1f.outcome == 12
        hint: Asked only when question R1f is "Yes".
      input:
        control: Radio
        labels:
          16: English
          17: French
          18: Other
    - id: R2g
      kind: Question
      title: R2 … R.C.M.P.
      precondition:
      - predicate: R1g.outcome == 14
        hint: Asked only when question R1g is "Yes".
      input:
        control: Radio
        labels:
          19: English
          20: French
          21: Other
    - id: R2h
      kind: Question
      title: R2 … Air Canada
      precondition:
      - predicate: R1h.outcome == 16
        hint: Asked only when question R1h is "Yes".
      input:
        control: Radio
        labels:
          22: English
          23: French
          24: Other
    - id: R2i
      kind: Question
      title: R2 … Agriculture Canada
      precondition:
      - predicate: R1i.outcome == 18
        hint: Asked only when question R1i is "Yes".
      input:
        control: Radio
        labels:
          25: English
          26: French
          27: Other
    - id: R2j
      kind: Question
      title: R2 … Via Rail or CN Marine
      precondition:
      - predicate: R1j.outcome == 20
        hint: Asked only when question R1j is "Yes".
      input:
        control: Radio
        labels:
          28: English
          29: French
          30: Other
    - id: R2k
      kind: Question
      title: R2 … Federal Public Service Commission
      precondition:
      - predicate: R1k.outcome == 22
        hint: Asked only when question R1k is "Yes".
      input:
        control: Radio
        labels:
          31: English
          32: French
          33: Other
  - id: b_s16_r3
    title: R3 Preferred language
    precondition:
    - predicate: not (R1a.outcome == 1 and R1b.outcome == 3 and R1c.outcome == 5 and R1d.outcome == 7 and R1e.outcome == 9 and R1f.outcome == 11 and R1g.outcome == 13 and R1h.outcome == 15 and R1i.outcome == 17 and R1j.outcome == 19 and R1k.outcome == 21)
      hint: Asked only when at least one agency contact was reported in R1.
    items:
    - id: R3a
      kind: Question
      title: R3 Was this your preferred language? — Post Office (excluding letter carriers)
      precondition:
      - predicate: R1a.outcome == 2
        hint: Asked only when question R1a is "Yes".
      input:
        control: Radio
        labels:
          34: 'Yes'
          35: 'No'
    - id: R3b
      kind: Question
      title: R3 … Canada Employment or Immigration Centres
      precondition:
      - predicate: R1b.outcome == 4
        hint: Asked only when question R1b is "Yes".
      input:
        control: Radio
        labels:
          36: 'Yes'
          37: 'No'
    - id: R3c
      kind: Question
      title: R3 … Old age security or family allowance
      precondition:
      - predicate: R1c.outcome == 6
        hint: Asked only when question R1c is "Yes".
      input:
        control: Radio
        labels:
          38: 'Yes'
          39: 'No'
    - id: R3d
      kind: Question
      title: R3 … National parks
      precondition:
      - predicate: R1d.outcome == 8
        hint: Asked only when question R1d is "Yes".
      input:
        control: Radio
        labels:
          40: 'Yes'
          41: 'No'
    - id: R3e
      kind: Question
      title: R3 … Federal personal income tax
      precondition:
      - predicate: R1e.outcome == 10
        hint: Asked only when question R1e is "Yes".
      input:
        control: Radio
        labels:
          42: 'Yes'
          43: 'No'
    - id: R3f
      kind: Question
      title: R3 … Customs, at border crossings only
      precondition:
      - predicate: R1f.outcome == 12
        hint: Asked only when question R1f is "Yes".
      input:
        control: Radio
        labels:
          44: 'Yes'
          45: 'No'
    - id: R3g
      kind: Question
      title: R3 … R.C.M.P.
      precondition:
      - predicate: R1g.outcome == 14
        hint: Asked only when question R1g is "Yes".
      input:
        control: Radio
        labels:
          46: 'Yes'
          47: 'No'
    - id: R3h
      kind: Question
      title: R3 … Air Canada
      precondition:
      - predicate: R1h.outcome == 16
        hint: Asked only when question R1h is "Yes".
      input:
        control: Radio
        labels:
          48: 'Yes'
          49: 'No'
    - id: R3i
      kind: Question
      title: R3 … Agriculture Canada
      precondition:
      - predicate: R1i.outcome == 18
        hint: Asked only when question R1i is "Yes".
      input:
        control: Radio
        labels:
          50: 'Yes'
          51: 'No'
    - id: R3j
      kind: Question
      title: R3 … Via Rail or CN Marine
      precondition:
      - predicate: R1j.outcome == 20
        hint: Asked only when question R1j is "Yes".
      input:
        control: Radio
        labels:
          52: 'Yes'
          53: 'No'
    - id: R3k
      kind: Question
      title: R3 … Federal Public Service Commission
      precondition:
      - predicate: R1k.outcome == 22
        hint: Asked only when question R1k is "Yes".
      input:
        control: Radio
        labels:
          54: 'Yes'
          55: 'No'
  - id: b_s16_r4
    title: R4 Preferred language, if not the one used
    precondition:
    - predicate: not (R1a.outcome == 1 and R1b.outcome == 3 and R1c.outcome == 5 and R1d.outcome == 7 and R1e.outcome == 9 and R1f.outcome == 11 and R1g.outcome == 13 and R1h.outcome == 15 and R1i.outcome == 17 and R1j.outcome == 19 and R1k.outcome == 21)
      hint: Asked only when at least one agency contact was reported in R1.
    items:
    - id: R4a
      kind: Question
      title: R4 What was your preferred language? — Post Office (excluding letter carriers)
      precondition:
      - predicate: R3a.outcome == 35
        hint: Asked only when question R3a is "No".
      input:
        control: Radio
        labels:
          1: English
          2: French
          3: Other
    - id: R4b
      kind: Question
      title: R4 … Canada Employment or Immigration Centres
      precondition:
      - predicate: R3b.outcome == 37
        hint: Asked only when question R3b is "No".
      input:
        control: Radio
        labels:
          4: English
          5: French
          6: Other
    - id: R4c
      kind: Question
      title: R4 … Old age security or family allowance
      precondition:
      - predicate: R3c.outcome == 39
        hint: Asked only when question R3c is "No".
      input:
        control: Radio
        labels:
          7: English
          8: French
          9: Other
    - id: R4d
      kind: Question
      title: R4 … National parks
      precondition:
      - predicate: R3d.outcome == 41
        hint: Asked only when question R3d is "No".
      input:
        control: Radio
        labels:
          10: English
          11: French
          12: Other
    - id: R4e
      kind: Question
      title: R4 … Federal personal income tax
      precondition:
      - predicate: R3e.outcome == 43
        hint: Asked only when question R3e is "No".
      input:
        control: Radio
        labels:
          13: English
          14: French
          15: Other
    - id: R4f
      kind: Question
      title: R4 … Customs, at border crossings only
      precondition:
      - predicate: R3f.outcome == 45
        hint: Asked only when question R3f is "No".
      input:
        control: Radio
        labels:
          16: English
          17: French
          18: Other
    - id: R4g
      kind: Question
      title: R4 … R.C.M.P.
      precondition:
      - predicate: R3g.outcome == 47
        hint: Asked only when question R3g is "No".
      input:
        control: Radio
        labels:
          19: English
          20: French
          21: Other
    - id: R4h
      kind: Question
      title: R4 … Air Canada
      precondition:
      - predicate: R3h.outcome == 49
        hint: Asked only when question R3h is "No".
      input:
        control: Radio
        labels:
          22: English
          23: French
          24: Other
    - id: R4i
      kind: Question
      title: R4 … Agriculture Canada
      precondition:
      - predicate: R3i.outcome == 51
        hint: Asked only when question R3i is "No".
      input:
        control: Radio
        labels:
          25: English
          26: French
          27: Other
    - id: R4j
      kind: Question
      title: R4 … Via Rail or CN Marine
      precondition:
      - predicate: R3j.outcome == 53
        hint: Asked only when question R3j is "No".
      input:
        control: Radio
        labels:
          28: English
          29: French
          30: Other
    - id: R4k
      kind: Question
      title: R4 … Federal Public Service Commission
      precondition:
      - predicate: R3k.outcome == 55
        hint: Asked only when question R3k is "No".
      input:
        control: Radio
        labels:
          31: English
          32: French
          33: Other
  - id: b_s16_r5
    title: R5 Asked for service in preferred language
    precondition:
    - predicate: not (R1a.outcome == 1 and R1b.outcome == 3 and R1c.outcome == 5 and R1d.outcome == 7 and R1e.outcome == 9 and R1f.outcome == 11 and R1g.outcome == 13 and R1h.outcome == 15 and R1i.outcome == 17 and R1j.outcome == 19 and R1k.outcome == 21)
      hint: Asked only when at least one agency contact was reported in R1.
    items:
    - id: R5a
      kind: Question
      title: R5 Did you ask for service in that language? — Post Office (excluding letter carriers)
      precondition:
      - predicate: R3a.outcome == 35
        hint: Asked only when question R3a is "No".
      input:
        control: Radio
        labels:
          34: 'Yes'
          35: 'No'
    - id: R5b
      kind: Question
      title: R5 … Canada Employment or Immigration Centres
      precondition:
      - predicate: R3b.outcome == 37
        hint: Asked only when question R3b is "No".
      input:
        control: Radio
        labels:
          36: 'Yes'
          37: 'No'
    - id: R5c
      kind: Question
      title: R5 … Old age security or family allowance
      precondition:
      - predicate: R3c.outcome == 39
        hint: Asked only when question R3c is "No".
      input:
        control: Radio
        labels:
          38: 'Yes'
          39: 'No'
    - id: R5d
      kind: Question
      title: R5 … National parks
      precondition:
      - predicate: R3d.outcome == 41
        hint: Asked only when question R3d is "No".
      input:
        control: Radio
        labels:
          40: 'Yes'
          41: 'No'
    - id: R5e
      kind: Question
      title: R5 … Federal personal income tax
      precondition:
      - predicate: R3e.outcome == 43
        hint: Asked only when question R3e is "No".
      input:
        control: Radio
        labels:
          42: 'Yes'
          43: 'No'
    - id: R5f
      kind: Question
      title: R5 … Customs, at border crossings only
      precondition:
      - predicate: R3f.outcome == 45
        hint: Asked only when question R3f is "No".
      input:
        control: Radio
        labels:
          44: 'Yes'
          45: 'No'
    - id: R5g
      kind: Question
      title: R5 … R.C.M.P.
      precondition:
      - predicate: R3g.outcome == 47
        hint: Asked only when question R3g is "No".
      input:
        control: Radio
        labels:
          46: 'Yes'
          47: 'No'
    - id: R5h
      kind: Question
      title: R5 … Air Canada
      precondition:
      - predicate: R3h.outcome == 49
        hint: Asked only when question R3h is "No".
      input:
        control: Radio
        labels:
          48: 'Yes'
          49: 'No'
    - id: R5i
      kind: Question
      title: R5 … Agriculture Canada
      precondition:
      - predicate: R3i.outcome == 51
        hint: Asked only when question R3i is "No".
      input:
        control: Radio
        labels:
          50: 'Yes'
          51: 'No'
    - id: R5j
      kind: Question
      title: R5 … Via Rail or CN Marine
      precondition:
      - predicate: R3j.outcome == 53
        hint: Asked only when question R3j is "No".
      input:
        control: Radio
        labels:
          52: 'Yes'
          53: 'No'
    - id: R5k
      kind: Question
      title: R5 … Federal Public Service Commission
      precondition:
      - predicate: R3k.outcome == 55
        hint: Asked only when question R3k is "No".
      input:
        control: Radio
        labels:
          54: 'Yes'
          55: 'No'
  - id: b_s16_lang
    title: Federal services, television and doctor language
    items:
    - id: R6
      kind: Question
      title: R6 Would you say that, in your area, federal services are generally available in your preferred official language?
      input:
        control: Radio
        labels:
          7: 'Yes'
          8: 'No'
          9: Don't know
    - id: R7
      kind: Question
      title: R7 In which languages are the television programs you watch?
      input:
        control: Checkbox
        labels:
          1: 0 — Never watch television
          2: 1 — English
          4: 2 — French
          8: 3 — Other (specify)
    - id: R7_most_often
      kind: Question
      title: 'R7 Most often:'
      input:
        control: Radio
        labels:
          4: Language 1 (most often)
          5: Language 2
          6: Language 3
          7: Language 4
    - id: R7_90
      kind: Question
      title: Do you watch programs in this language more than 90% of the time?
      input:
        control: Radio
        labels:
          8: 'Yes'
          9: 'No'
    - id: R8
      kind: Question
      title: R8 Which language did the doctor use during your last visit?
      input:
        control: Radio
        labels:
          1: Never visited doctor
          2: English
          3: French
          4: Other (specify)
  - id: b_s17_background
    title: Ethnicity, religion and community
    items:
    - id: S1
      kind: Question
      title: S1 To which ethnic or cultural group do you or did your ancestors belong? (Accept multiple response)
      input:
        control: Checkbox
        labels:
          1: 1 — English
          2: 2 — French
          4: 3 — Irish
          8: 4 — Scottish
          16: 5 — German
          32: 6 — Italian
          64: 7 — Ukrainian
          128: 8 — Other (specify)
          256: 9 — Don't know
    - id: S2
      kind: Question
      title: S2 What, if any, is your religion?
      input:
        control: Dropdown
        labels:
          0: No religion
          1: Roman Catholic
          2: United Church
          3: Anglican
          4: Presbyterian
          5: Lutheran
          6: Baptist
          7: Eastern Orthodox
          8: Jewish
          9: Other (specify)
    - id: S3
      kind: Question
      title: S3 Other than on special occasions, such as weddings, funerals or baptisms, how often do you attend services or meetings connected with your religion?
      precondition:
      - predicate: not (S2.outcome == 0)
        hint: Asked only when question S2 is not "No religion".
      input:
        control: Radio
        labels:
          0: At least once a week
          1: At least once a month
          2: At least once a year
          3: Less than once a year
          4: Never
    - id: S4
      kind: Question
      title: S4 What is the approximate size of the community in which you are now living? By community I mean city, town or rural area?
      input:
        control: Radio
        labels:
          5: Less than 5,000 population or a rural area
          6: 5,000 to less than 25,000 population
          7: 25,000 to less than 100,000 population
          8: 100,000 to 1 million population
          9: Over 1 million population
    - id: S5
      kind: Question
      title: S5 What is the name of that town or nearest town? Town
      input:
        control: Textarea
        maxLength: 100
    - id: S5_Prov
      kind: Question
      title: S5 Prov.
      input:
        control: Textarea
        maxLength: 50
    - id: S6
      kind: Question
      title: S6 What are the first three characters of your postal code? (9 — Don't know)
      input:
        control: Textarea
        maxLength: 10
    - id: S7
      kind: Question
      title: S7 In what type of dwelling are you now living? Is it . . .
      input:
        control: Radio
        labels:
          1: Single detached house
          2: Semi-detached or double (side-by-side)
          3: Garden house, town-house or row house
          4: Duplex (one above the other)
          5: Low-rise apartment (less than five stories)
          6: High-rise apartment (five or more stories)
          7: Other (specify)
    - id: S8
      kind: Question
      title: S8 Is this dwelling owned or rented by a member of this household?
      input:
        control: Radio
        labels:
          8: Owned
          9: Rented
  - id: b_s17_telephones
    title: Telephones
    items:
    - id: S9
      kind: Question
      title: S9 How many telephones, counting extensions, are there in your dwelling?
      input:
        control: Radio
        labels:
          1: One
          2: Two or more
  - id: b_s17_phone_same_number
    title: 'Telephone numbers: same number'
    precondition:
    - predicate: not (S9.outcome == 1)
      hint: Asked only when question S9 is not "One".
    items:
    - id: S10
      kind: Question
      title: S10 Do all the telephones have the same number?
      input:
        control: Radio
        labels:
          3: 'Yes'
          4: 'No'
  - id: b_s17_phone_numbers
    title: 'Telephone numbers: different numbers'
    precondition:
    - predicate: not (S9.outcome == 1)
      hint: Asked only when question S9 is not "One".
    - predicate: not (S10.outcome == 3)
      hint: Asked only when question S10 is not "Yes".
    items:
    - id: S11
      kind: Question
      title: S11 How many different numbers are there?
      input:
        control: Editbox
        min: 1
        max: 20
    - id: S12
      kind: Question
      title: S12 Are any of these numbers for business use only?
      input:
        control: Radio
        labels:
          5: 'Yes'
          6: 'No'
  - id: b_s17_phone_business
    title: 'Telephone numbers: business use'
    precondition:
    - predicate: not (S9.outcome == 1)
      hint: Asked only when question S9 is not "One".
    - predicate: not (S10.outcome == 3)
      hint: Asked only when question S10 is not "Yes".
    - predicate: not (S12.outcome == 6)
      hint: Asked only when question S12 is not "No".
    items:
    - id: S13
      kind: Question
      title: S13 How many are for business use only?
      postcondition:
      - predicate: S13.outcome <= S11.outcome
        hint: The number of business-only numbers (S13) cannot exceed the number of different numbers (S11).
        invented: true
      input:
        control: Editbox
        min: 1
        max: 20
  - id: b_s17_income
    title: Personal income
    items:
    - id: S14
      kind: Question
      title: S14 What was your income before taxes, from wages, salaries and self-employment during the last 12 months?
      input:
        control: Radio
        labels:
          1: Income
          2: Loss
          3: No income
          4: Don't know
    - id: S14_amount
      kind: Question
      title: S14 Income / Loss → $ ________ 00
      precondition:
      - predicate: S14.outcome in [1, 2]
        hint: Asked only when question S14 is one of "Income", "Loss".
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
    - id: S15
      kind: Question
      title: S15. What was your income from government sources such as Family Allowance, U.I.C., Social Assistance, Canada or Quebec Pension Plan or Old Age Security? $ ________ .00
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
    - id: S15_no_amount
      kind: Question
      title: S15. No income / Don't know
      input:
        control: Radio
        labels:
          5: No income
          6: Don't know
    - id: S16
      kind: Question
      title: S16. What was your income from investments or private pensions?
      input:
        control: Radio
        labels:
          1: Income
          2: Loss
          3: No income
          4: Don't know
    - id: S16_amount
      kind: Question
      title: S16. Income / Loss → $ ________ 00
      precondition:
      - predicate: S16.outcome in [1, 2]
        hint: Asked only when question S16 is one of "Income", "Loss".
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
  - id: b_s17_household_income
    title: Household income
    items:
    - id: S17
      kind: Question
      title: S17 What is your best estimate of the total income of all household members from all sources during the last 12 months? Was the total household income . . .
      input:
        control: Radio
        labels:
          1: Less than $20,000
          2: $20,000 and more
          3: No income
          4: Don't know
    - id: S17a
      kind: Question
      title: S17 (follow-up to Less than $20,000; unnumbered)
      precondition:
      - predicate: S17.outcome == 1
        hint: Asked only when question S17 is "Less than $20,000".
      - predicate: not (S17.outcome in [3, 4])
        hint: Asked only when question S17 is none of "No income", "Don't know".
      input:
        control: Radio
        labels:
          5: Less than $10,000
          6: $10,000 and more
    - id: S17b
      kind: Question
      title: S17 (follow-up to Less than $10,000; unnumbered)
      precondition:
      - predicate: S17a.outcome == 5
        hint: Asked only when question S17a is "Less than $10,000".
      - predicate: not (S17.outcome in [3, 4])
        hint: Asked only when question S17 is none of "No income", "Don't know".
      input:
        control: Radio
        labels:
          1: Less than $5,000
          2: $5,000 and more
    - id: S17c
      kind: Question
      title: S17 (follow-up to $10,000 and more; unnumbered)
      precondition:
      - predicate: S17a.outcome == 6
        hint: Asked only when question S17a is "$10,000 and more".
      - predicate: not (S17.outcome in [3, 4])
        hint: Asked only when question S17 is none of "No income", "Don't know".
      - predicate: not (S17b.outcome in [1, 2])
        hint: Asked only when question S17b is none of "Less than $5,000", "$5,000 and more".
      input:
        control: Radio
        labels:
          3: Less than $15,000
          4: $15,000 and more
    - id: S17d
      kind: Question
      title: S17 (follow-up to $20,000 and more; unnumbered)
      precondition:
      - predicate: S17.outcome == 2
        hint: Asked only when question S17 is "$20,000 and more".
      - predicate: not (S17.outcome in [3, 4])
        hint: Asked only when question S17 is none of "No income", "Don't know".
      - predicate: not (S17b.outcome in [1, 2])
        hint: Asked only when question S17b is none of "Less than $5,000", "$5,000 and more".
      - predicate: not (S17c.outcome in [3, 4])
        hint: Asked only when question S17c is none of "Less than $15,000", "$15,000 and more".
      input:
        control: Radio
        labels:
          7: Less than $40,000
          8: $40,000 and more
    - id: S17e
      kind: Question
      title: S17 (follow-up to Less than $40,000; unnumbered)
      precondition:
      - predicate: S17d.outcome == 7
        hint: Asked only when question S17d is "Less than $40,000".
      - predicate: not (S17.outcome in [3, 4])
        hint: Asked only when question S17 is none of "No income", "Don't know".
      - predicate: not (S17b.outcome in [1, 2])
        hint: Asked only when question S17b is none of "Less than $5,000", "$5,000 and more".
      - predicate: not (S17c.outcome in [3, 4])
        hint: Asked only when question S17c is none of "Less than $15,000", "$15,000 and more".
      input:
        control: Radio
        labels:
          5: Less than $30,000
          6: $30,000 and more
    - id: S17f
      kind: Question
      title: S17 (follow-up to $40,000 and more; unnumbered)
      precondition:
      - predicate: S17d.outcome == 8
        hint: Asked only when question S17d is "$40,000 and more".
      - predicate: not (S17.outcome in [3, 4])
        hint: Asked only when question S17 is none of "No income", "Don't know".
      - predicate: not (S17b.outcome in [1, 2])
        hint: Asked only when question S17b is none of "Less than $5,000", "$5,000 and more".
      - predicate: not (S17c.outcome in [3, 4])
        hint: Asked only when question S17c is none of "Less than $15,000", "$15,000 and more".
      - predicate: not (S17e.outcome in [5, 6])
        hint: Asked only when question S17e is none of "Less than $30,000", "$30,000 and more".
      input:
        control: Radio
        labels:
          7: Less than $60,000
          8: $60,000 and more
  - id: b_s18_t1
    title: T1. Contacts with federal agencies
    precondition:
    - predicate: not (S17.outcome in [3, 4])
      hint: Asked only when question S17 is none of "No income", "Don't know".
    - predicate: not (S17b.outcome in [1, 2])
      hint: Asked only when question S17b is none of "Less than $5,000", "$5,000 and more".
    - predicate: not (S17c.outcome in [3, 4])
      hint: Asked only when question S17c is none of "Less than $15,000", "$15,000 and more".
    - predicate: not (S17e.outcome in [5, 6])
      hint: Asked only when question S17e is none of "Less than $30,000", "$30,000 and more".
    - predicate: not (S17f.outcome in [7, 8])
      hint: Asked only when question S17f is none of "Less than $60,000", "$60,000 and more".
    items:
    - id: T1a
      kind: Question
      title: T1. During this period, have you talked with employees of the following federal agencies in connection with the services they provide? — Post Office (excluding letter carriers). Ids T1a–T1k and T3a–T3k are the grid rows in printed order (a Post Office … k Federal Public Service Commission); the source prints no row ids.
      input:
        control: Radio
        labels:
          1: 'No'
          2: 'Yes'
    - id: T1b
      kind: Question
      title: T1 … Canada Employment or Immigration Centres
      input:
        control: Radio
        labels:
          3: 'No'
          4: 'Yes'
    - id: T1c
      kind: Question
      title: T1 … Old age security or family allowance
      input:
        control: Radio
        labels:
          5: 'No'
          6: 'Yes'
    - id: T1d
      kind: Question
      title: T1 … National Parks
      input:
        control: Radio
        labels:
          7: 'No'
          8: 'Yes'
    - id: T1e
      kind: Question
      title: T1 … Federal personnal income tax
      input:
        control: Radio
        labels:
          9: 'No'
          10: 'Yes'
    - id: T1f
      kind: Question
      title: T1 … Customs, at border crossings only
      input:
        control: Radio
        labels:
          11: 'No'
          12: 'Yes'
    - id: T1g
      kind: Question
      title: T1 … R.C.M.P.
      input:
        control: Radio
        labels:
          13: 'No'
          14: 'Yes'
    - id: T1h
      kind: Question
      title: T1 … Air Canada
      input:
        control: Radio
        labels:
          15: 'No'
          16: 'Yes'
    - id: T1i
      kind: Question
      title: T1 … Agriculture Canada
      input:
        control: Radio
        labels:
          17: 'No'
          18: 'Yes'
    - id: T1j
      kind: Question
      title: T1 … Via Rail or CN Marine
      input:
        control: Radio
        labels:
          19: 'No'
          20: 'Yes'
    - id: T1k
      kind: Question
      title: T1 … Federal Public Service Commission
      input:
        control: Radio
        labels:
          21: 'No'
          22: 'Yes'
  - id: b_s18_t2
    title: T2. Service in English
    precondition:
    - predicate: not (S17.outcome in [3, 4])
      hint: Asked only when question S17 is none of "No income", "Don't know".
    - predicate: not (S17b.outcome in [1, 2])
      hint: Asked only when question S17b is none of "Less than $5,000", "$5,000 and more".
    - predicate: not (S17c.outcome in [3, 4])
      hint: Asked only when question S17c is none of "Less than $15,000", "$15,000 and more".
    - predicate: not (S17e.outcome in [5, 6])
      hint: Asked only when question S17e is none of "Less than $30,000", "$30,000 and more".
    - predicate: not (S17f.outcome in [7, 8])
      hint: Asked only when question S17f is none of "Less than $60,000", "$60,000 and more".
    - predicate: not (T1a.outcome == 1 and T1b.outcome == 3 and T1c.outcome == 5 and T1d.outcome == 7 and T1e.outcome == 9 and T1f.outcome == 11 and T1g.outcome == 13 and T1h.outcome == 15 and T1i.outcome == 17 and T1j.outcome == 19 and T1k.outcome == 21)
      hint: Asked only when at least one agency was contacted in T1.
    items:
    - id: T2
      kind: Question
      title: T2 Did you obtain service in English for all these contacts?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
  - id: b_s18_t3
    title: T2 (which ones) and T3. Asking for service in English
    precondition:
    - predicate: not (S17.outcome in [3, 4])
      hint: Asked only when question S17 is none of "No income", "Don't know".
    - predicate: not (S17b.outcome in [1, 2])
      hint: Asked only when question S17b is none of "Less than $5,000", "$5,000 and more".
    - predicate: not (S17c.outcome in [3, 4])
      hint: Asked only when question S17c is none of "Less than $15,000", "$15,000 and more".
    - predicate: not (S17e.outcome in [5, 6])
      hint: Asked only when question S17e is none of "Less than $30,000", "$30,000 and more".
    - predicate: not (S17f.outcome in [7, 8])
      hint: Asked only when question S17f is none of "Less than $60,000", "$60,000 and more".
    - predicate: not (T1a.outcome == 1 and T1b.outcome == 3 and T1c.outcome == 5 and T1d.outcome == 7 and T1e.outcome == 9 and T1f.outcome == 11 and T1g.outcome == 13 and T1h.outcome == 15 and T1i.outcome == 17 and T1j.outcome == 19 and T1k.outcome == 21)
      hint: Asked only when at least one agency was contacted in T1.
    - predicate: not (T2.outcome == 1)
      hint: Asked only when question T2 is not "Yes".
    items:
    - id: T2_which_ones
      kind: Question
      title: No → Which ones? (agencies marked in the T2 column)
      precondition:
      - predicate: T2.outcome == 2
        hint: Asked only when question T2 is "No".
      input:
        control: Checkbox
        labels:
          1: 01 — Post Office (excluding letter carriers)
          2: 02 — Canada Employment or Immigration Centres
          4: 03 — Old age security or family allowance
          8: 04 — National Parks
          16: 05 — Federal personnal income tax
          32: 06 — Customs, at border crossings only
          64: 07 — R.C.M.P.
          128: 08 — Air Canada
          256: 09 — Agriculture Canada
          512: 10 — Via Rail or CN Marine
          1024: 11 — Federal Public Service Commission
    - id: T3a
      kind: Question
      title: T3. Did you ask for service in English? — Post Office (excluding letter carriers)
      precondition:
      - predicate: T2_which_ones.outcome & 1 > 0
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: T3b
      kind: Question
      title: T3 … Canada Employment or Immigration Centres
      precondition:
      - predicate: T2_which_ones.outcome & 2 > 0
      input:
        control: Radio
        labels:
          3: 'Yes'
          4: 'No'
    - id: T3c
      kind: Question
      title: T3 … Old age security or family allowance
      precondition:
      - predicate: T2_which_ones.outcome & 4 > 0
      input:
        control: Radio
        labels:
          5: 'Yes'
          6: 'No'
    - id: T3d
      kind: Question
      title: T3 … National Parks
      precondition:
      - predicate: T2_which_ones.outcome & 8 > 0
      input:
        control: Radio
        labels:
          7: 'Yes'
          8: 'No'
    - id: T3e
      kind: Question
      title: T3 … Federal personnal income tax
      precondition:
      - predicate: T2_which_ones.outcome & 16 > 0
      input:
        control: Radio
        labels:
          9: 'Yes'
          10: 'No'
    - id: T3f
      kind: Question
      title: T3 … Customs, at border crossings only
      precondition:
      - predicate: T2_which_ones.outcome & 32 > 0
      input:
        control: Radio
        labels:
          11: 'Yes'
          12: 'No'
    - id: T3g
      kind: Question
      title: T3 … R.C.M.P.
      precondition:
      - predicate: T2_which_ones.outcome & 64 > 0
      input:
        control: Radio
        labels:
          13: 'Yes'
          14: 'No'
    - id: T3h
      kind: Question
      title: T3 … Air Canada
      precondition:
      - predicate: T2_which_ones.outcome & 128 > 0
      input:
        control: Radio
        labels:
          15: 'Yes'
          16: 'No'
    - id: T3i
      kind: Question
      title: T3 … Agriculture Canada
      precondition:
      - predicate: T2_which_ones.outcome & 256 > 0
      input:
        control: Radio
        labels:
          17: 'Yes'
          18: 'No'
    - id: T3j
      kind: Question
      title: T3 … Via Rail or CN Marine
      precondition:
      - predicate: T2_which_ones.outcome & 512 > 0
      input:
        control: Radio
        labels:
          19: 'Yes'
          20: 'No'
    - id: T3k
      kind: Question
      title: T3 … Federal Public Service Commission
      precondition:
      - predicate: T2_which_ones.outcome & 1024 > 0
      input:
        control: Radio
        labels:
          21: 'Yes'
          22: 'No'
  - id: b_s18_t4_t6
    title: T4–T6. Federal services, television and doctor language
    precondition:
    - predicate: not (S17.outcome in [3, 4])
      hint: Asked only when question S17 is none of "No income", "Don't know".
    - predicate: not (S17b.outcome in [1, 2])
      hint: Asked only when question S17b is none of "Less than $5,000", "$5,000 and more".
    - predicate: not (S17c.outcome in [3, 4])
      hint: Asked only when question S17c is none of "Less than $15,000", "$15,000 and more".
    - predicate: not (S17e.outcome in [5, 6])
      hint: Asked only when question S17e is none of "Less than $30,000", "$30,000 and more".
    - predicate: not (S17f.outcome in [7, 8])
      hint: Asked only when question S17f is none of "Less than $60,000", "$60,000 and more".
    items:
    - id: T4
      kind: Question
      title: T4. Would you say that, in your area, federal services are generally available in English?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Don't know
    - id: T5
      kind: Question
      title: T5. In which languages are the television programs you watch?
      input:
        control: Checkbox
        labels:
          1: 0 — Never watch television
          2: 1 — English
          4: 2 — French
          8: 3 — Other (specify)
    - id: T5_most_often
      kind: Question
      title: 'T5. Most often: 4, 5, 6, 7'
      input:
        control: Radio
        labels:
          4: Language 1 (most often)
          5: Language 2
          6: Language 3
          7: Language 4
    - id: T5_90
      kind: Question
      title: Do you watch programs in this language more than 90% of the time?
      input:
        control: Radio
        labels:
          8: 'Yes'
          9: 'No'
    - id: T6
      kind: Question
      title: T6. Which language did the doctor use during your last visit?
      input:
        control: Radio
        labels:
          1: Never visited doctor
          2: English
          3: French
          4: Other (specify)
  - id: b_s19_education
    title: 'SECTION U: Education'
    precondition:
    - predicate: not (S17.outcome in [3, 4])
      hint: Asked only when question S17 is none of "No income", "Don't know".
    - predicate: not (S17b.outcome in [1, 2])
      hint: Asked only when question S17b is none of "Less than $5,000", "$5,000 and more".
    - predicate: not (S17c.outcome in [3, 4])
      hint: Asked only when question S17c is none of "Less than $15,000", "$15,000 and more".
    - predicate: not (S17e.outcome in [5, 6])
      hint: Asked only when question S17e is none of "Less than $30,000", "$30,000 and more".
    - predicate: not (S17f.outcome in [7, 8])
      hint: Asked only when question S17f is none of "Less than $60,000", "$60,000 and more".
    items:
    - id: U1
      kind: Question
      title: How many years of elementary and secondary education have you completed?
      input:
        control: Dropdown
        labels:
          0: 00 — No schooling (Go to U12)
          5: 05 — One to five years (Go to U3)
          6: 06 — Six (Go to U3)
          7: 07 — Seven (Go to U3)
          8: 08 — Eight (Go to U3)
          9: 09 — Nine (Go to U3)
          10: 10 — Ten (Go to U3)
          11: 11 — Eleven
          12: 12 — Twelve
          13: 13 — Thirteen
  - id: b_s19_schooling
    title: Schooling
    precondition:
    - predicate: not (S17.outcome in [3, 4])
      hint: Asked only when question S17 is none of "No income", "Don't know".
    - predicate: not (S17b.outcome in [1, 2])
      hint: Asked only when question S17b is none of "Less than $5,000", "$5,000 and more".
    - predicate: not (S17c.outcome in [3, 4])
      hint: Asked only when question S17c is none of "Less than $15,000", "$15,000 and more".
    - predicate: not (S17e.outcome in [5, 6])
      hint: Asked only when question S17e is none of "Less than $30,000", "$30,000 and more".
    - predicate: not (S17f.outcome in [7, 8])
      hint: Asked only when question S17f is none of "Less than $60,000", "$60,000 and more".
    - predicate: not (U1.outcome == 0)
      hint: Asked only when question U1 is not "00 — No schooling (Go to U12)".
    items:
    - id: U2
      kind: Question
      title: Have you graduated from secondary school?
      precondition:
      - predicate: U1.outcome in [11, 12, 13]
        hint: Asked only when question U1 is one of "11 — Eleven", "12 — Twelve", "13 — Thirteen".
      - predicate: not (U1.outcome in [5, 6, 7, 8, 9, 10])
        hint: Asked only when question U1 is none of "05 — One to five years (Go to U3)", "06 — Six (Go to U3)", "07 — Seven (Go to U3)", "08 — Eight (Go to U3)", "09 — Nine (Go to U3)", "10 — Ten (Go to U3)".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: U3
      kind: Question
      title: Have you had any further schooling beyond elementary/secondary school?
      input:
        control: Radio
        labels:
          3: 'Yes'
          4: No (Go to U5)
    - id: U4
      kind: Question
      title: What was the highest level you attained?
      precondition:
      - predicate: U3.outcome == 3
        hint: Asked only when question U3 is "Yes".
      - predicate: not (U3.outcome == 4)
        hint: Asked only when question U3 is not "No (Go to U5)".
      input:
        control: Radio
        labels:
          1: Some community college, CEGEP or nursing school
          2: Diploma or certificate from community college, CEGEP or nursing school
          3: Some university
          4: Bachelor or undergraduate degree or teacher's college
          5: Master's or earned doctorate
          6: Other (specify)
    - id: U5
      kind: Question
      title: In which year did you reach your highest level of education?
      input:
        control: Editbox
        min: 1900
        max: 1986
    - id: U6
      kind: Question
      title: Think about the first full-time job you had after reaching your highest level of education in . . . (date reported in U5) Were you an employee working for someone else or self-employed?
      input:
        control: Radio
        labels:
          7: An employee working for someone else
          8: Self-employed (Go to U8)
          9: Never had full-time job after this date (Go to U11)
    - id: U11
      kind: Question
      title: Have you ever taken any language courses as part of full-time school?
      input:
        control: Radio
        labels:
          1: Yes → Which languages?
          2: 'No'
    - id: U11a
      kind: Question
      title: Which languages? (follow-up to U11 Yes; source prints no separate id)
      precondition:
      - predicate: U11.outcome == 1
        hint: Asked only when question U11 is "Yes → Which languages?".
      input:
        control: Checkbox
        labels:
          1: 3 — English
          2: 4 — French
          4: 5 — Other (specify)
  - id: b_s19_first_job
    title: First full-time job
    precondition:
    - predicate: not (S17.outcome in [3, 4])
      hint: Asked only when question S17 is none of "No income", "Don't know".
    - predicate: not (S17b.outcome in [1, 2])
      hint: Asked only when question S17b is none of "Less than $5,000", "$5,000 and more".
    - predicate: not (S17c.outcome in [3, 4])
      hint: Asked only when question S17c is none of "Less than $15,000", "$15,000 and more".
    - predicate: not (S17e.outcome in [5, 6])
      hint: Asked only when question S17e is none of "Less than $30,000", "$30,000 and more".
    - predicate: not (S17f.outcome in [7, 8])
      hint: Asked only when question S17f is none of "Less than $60,000", "$60,000 and more".
    - predicate: not (U1.outcome == 0)
      hint: Asked only when question U1 is not "00 — No schooling (Go to U12)".
    - predicate: U6.outcome in [7, 8]
      hint: Asked only when question U6 is one of "An employee working for someone else", "Self-employed (Go to U8)".
    - predicate: not (U6.outcome == 9)
      hint: Asked only when question U6 is not "Never had full-time job after this date (Go to U11)".
    items:
    - id: U7
      kind: Question
      title: For whom did you work? (Name of business, government department or agency or person)
      precondition:
      - predicate: U6.outcome == 7
        hint: Asked only when question U6 is "An employee working for someone else".
      - predicate: not (U6.outcome == 8)
        hint: Asked only when question U6 is not "Self-employed (Go to U8)".
      input:
        control: Textarea
    - id: U8
      kind: Question
      title: 'What was the main kind of business, industry or service? (Give a full description: e.g., paper box manufacturing, retail shoe store, municipal board of education)'
      input:
        control: Textarea
    - id: U9
      kind: Question
      title: What kind of work were you doing? (Give a full description e.g., posting invoices, selling shoes, teaching primary school)
      input:
        control: Textarea
    - id: U10
      kind: Question
      title: In what year did you begin working at this job?
      postcondition:
      - predicate: U10.outcome >= U5.outcome
        hint: El año de inicio del empleo (U10) no puede ser anterior al año en que alcanzó su nivel de educación más alto (U5).
        invented: true
      input:
        control: Editbox
        min: 1900
        max: 1986
  - id: b_s19_background
    title: Languages, religion, ethnicity and dwelling
    precondition:
    - predicate: not (S17.outcome in [3, 4])
      hint: Asked only when question S17 is none of "No income", "Don't know".
    - predicate: not (S17b.outcome in [1, 2])
      hint: Asked only when question S17b is none of "Less than $5,000", "$5,000 and more".
    - predicate: not (S17c.outcome in [3, 4])
      hint: Asked only when question S17c is none of "Less than $15,000", "$15,000 and more".
    - predicate: not (S17e.outcome in [5, 6])
      hint: Asked only when question S17e is none of "Less than $30,000", "$30,000 and more".
    - predicate: not (S17f.outcome in [7, 8])
      hint: Asked only when question S17f is none of "Less than $60,000", "$60,000 and more".
    items:
    - id: U12
      kind: Question
      title: Have you ever taken any language courses outside of full-time school?
      input:
        control: Radio
        labels:
          3: Yes → Which languages?
          4: 'No'
    - id: U12a
      kind: Question
      title: Which languages? (follow-up to U12 Yes; source prints no separate id)
      precondition:
      - predicate: U12.outcome == 3
        hint: Asked only when question U12 is "Yes → Which languages?".
      input:
        control: Checkbox
        labels:
          1: 5 — English
          2: 6 — French
          4: 7 — Other (specify)
    - id: U13
      kind: Question
      title: What, if any, is your religion?
      input:
        control: Dropdown
        labels:
          0: No religion (Go to U15)
          1: Roman Catholic
          2: United Church
          3: Anglican
          4: Presbyterian
          5: Lutheran
          6: Baptist
          7: Eastern Orthodox
          8: Jewish
          9: Other (specify)
    - id: U14
      kind: Question
      title: Other than on special occasions, such as weddings, funerals or baptisms, how often do you attend services or meetings connected with your religion?
      precondition:
      - predicate: U13.outcome != 0
        hint: Asked only when question U13 is not "No religion (Go to U15)".
      - predicate: not (U13.outcome == 0)
        hint: Asked only when question U13 is not "No religion (Go to U15)".
      input:
        control: Radio
        labels:
          1: At least once a week
          2: At least once a month
          3: At least once a year
          4: Less than once a year
          5: Never
    - id: U15
      kind: Question
      title: To which ethnic or cultural group do you or did your ancestors belong? (Accept multiple response)
      input:
        control: Checkbox
        labels:
          1: 1 — English
          2: 2 — French
          4: 3 — Irish
          8: 4 — Scottish
          16: 5 — German
          32: 6 — Italian
          64: 7 — Ukrainian
          128: 8 — Other (specify)
          256: 9 — Don't know
    - id: U16
      kind: Question
      title: What is the approximate size of the community in which you are now living? By community I mean city, town or rural area?
      input:
        control: Radio
        labels:
          1: (1) Less than 5,000 population or a rural area
          2: (2) 5,000 to less than 25,000 population
          3: (3) 25,000 to less than 100,000 population
          4: (4) 100,000 to 1 million population
          5: (5) Over 1 million population
    - id: U17
      kind: Question
      title: What is the name of that town or nearest town? (Town / Prov.)
      input:
        control: Textarea
    - id: U18
      kind: Question
      title: What are the first three characters of your postal code? ((9) Don't know)
      input:
        control: Textarea
    - id: U19
      kind: Question
      title: In what type of dwelling are you now living? Is it . . .
      input:
        control: Radio
        labels:
          1: (1) Single detached house
          2: (2) Semi-detached or double (side-by-side)
          3: (3) Garden house, town-house or row house
          4: (4) Duplex (one above the other)
          5: (5) Low-rise apartment (less than five stories)
          6: (6) High-rise apartment (five or more stories)
          7: (7) Other (specify)
    - id: U20
      kind: Question
      title: Is this dwelling owned or rented by a member of this household?
      input:
        control: Radio
        labels:
          8: (8) Owned
          9: (9) Rented
    - id: U21
      kind: Question
      title: Is there a language, other than English, spoken in your home by the people living there?
      input:
        control: Radio
        labels:
          1: (1) Person lives alone
          2: (2) Yes → Which languages?
          3: (3) No
    - id: U21a
      kind: Question
      title: Which languages? (other than English; follow-up to U21 Yes; source prints no separate id)
      precondition:
      - predicate: U21.outcome == 2
        hint: Asked only when question U21 is "(2) Yes → Which languages?".
      input:
        control: Checkbox
        labels:
          1: (4) French
          2: (5) Other (specify)
    - id: U22
      kind: Question
      title: How many telephones, counting extensions, are there in your dwelling?
      input:
        control: Radio
        labels:
          1: (1) One → Go to U27
          2: (2) Two or more
  - id: b_s19_phones_multi
    title: Telephone numbers
    precondition:
    - predicate: not (S17.outcome in [3, 4])
      hint: Asked only when question S17 is none of "No income", "Don't know".
    - predicate: not (S17b.outcome in [1, 2])
      hint: Asked only when question S17b is none of "Less than $5,000", "$5,000 and more".
    - predicate: not (S17c.outcome in [3, 4])
      hint: Asked only when question S17c is none of "Less than $15,000", "$15,000 and more".
    - predicate: not (S17e.outcome in [5, 6])
      hint: Asked only when question S17e is none of "Less than $30,000", "$30,000 and more".
    - predicate: not (S17f.outcome in [7, 8])
      hint: Asked only when question S17f is none of "Less than $60,000", "$60,000 and more".
    - predicate: not (U22.outcome == 1)
      hint: Asked only when question U22 is not "(1) One → Go to U27".
    items:
    - id: U23
      kind: Question
      title: Do all the telephones have the same number?
      input:
        control: Radio
        labels:
          3: (3) Yes → Go to U27
          4: (4) No
    - id: U24
      kind: Question
      title: How many different numbers are there?
      precondition:
      - predicate: not (U23.outcome == 3)
        hint: Asked only when question U23 is not "(3) Yes → Go to U27".
      input:
        control: Editbox
        min: 0
        max: 99
    - id: U25
      kind: Question
      title: Are any of these numbers for business use only?
      precondition:
      - predicate: not (U23.outcome == 3)
        hint: Asked only when question U23 is not "(3) Yes → Go to U27".
      input:
        control: Radio
        labels:
          5: (5) Yes
          6: (6) No → Go to U27
    - id: U26
      kind: Question
      title: How many are for business use only?
      precondition:
      - predicate: not (U23.outcome == 3)
        hint: Asked only when question U23 is not "(3) Yes → Go to U27".
      - predicate: not (U25.outcome == 6)
        hint: Asked only when question U25 is not "(6) No → Go to U27".
      postcondition:
      - predicate: U26.outcome <= U24.outcome
        hint: El número de números solo para uso comercial (U26) no puede superar el número de números diferentes (U24).
        invented: true
      input:
        control: Editbox
        min: 0
        max: 99
  - id: b_s19_activity
    title: Main activity
    precondition:
    - predicate: not (S17.outcome in [3, 4])
      hint: Asked only when question S17 is none of "No income", "Don't know".
    - predicate: not (S17b.outcome in [1, 2])
      hint: Asked only when question S17b is none of "Less than $5,000", "$5,000 and more".
    - predicate: not (S17c.outcome in [3, 4])
      hint: Asked only when question S17c is none of "Less than $15,000", "$15,000 and more".
    - predicate: not (S17e.outcome in [5, 6])
      hint: Asked only when question S17e is none of "Less than $30,000", "$30,000 and more".
    - predicate: not (S17f.outcome in [7, 8])
      hint: Asked only when question S17f is none of "Less than $60,000", "$60,000 and more".
    items:
    - id: U27
      kind: Question
      title: Which of the following best describes your main activity during the last 7 days? Were you mainly . . . (Accept one response only)
      input:
        control: Radio
        labels:
          1: (1) Working at a job or business
          2: (2) Looking for work
          3: (3) A student
          4: (4) Keeping house
          5: (5) Retired
          6: (6) Other (specify)
    - id: U28
      kind: Question
      title: What about your main activity during the last 12 months? Were you mainly . . . (Accept one response only)
      input:
        control: Radio
        labels:
          1: (1) Working at a job or business → Go to U31
          2: (2) Looking for work
          3: (3) A student
          4: (4) Keeping house
          5: (5) Retired
          6: (6) Other (specify)
  - id: b_s19_no_main_job
    title: Job during the last 12 months
    precondition:
    - predicate: not (S17.outcome in [3, 4])
      hint: Asked only when question S17 is none of "No income", "Don't know".
    - predicate: not (S17b.outcome in [1, 2])
      hint: Asked only when question S17b is none of "Less than $5,000", "$5,000 and more".
    - predicate: not (S17c.outcome in [3, 4])
      hint: Asked only when question S17c is none of "Less than $15,000", "$15,000 and more".
    - predicate: not (S17e.outcome in [5, 6])
      hint: Asked only when question S17e is none of "Less than $30,000", "$30,000 and more".
    - predicate: not (S17f.outcome in [7, 8])
      hint: Asked only when question S17f is none of "Less than $60,000", "$60,000 and more".
    - predicate: not (U28.outcome == 1)
      hint: Asked only when question U28 is not "(1) Working at a job or business → Go to U31".
    items:
    - id: U29
      kind: Question
      title: Did you have a job at any time during the last 12 months?
      input:
        control: Radio
        labels:
          7: (7) Yes → Go to U31
          8: (8) No
    - id: U30
      kind: Question
      title: Did you have any income from wages, salaries and self-employment during the last 12 months?
      precondition:
      - predicate: not (U29.outcome == 7)
        hint: Asked only when question U29 is not "(7) Yes → Go to U31".
      input:
        control: Radio
        labels:
          1: (1) Yes → What was your income before taxes?
          2: (2) No income → Go to U39
          3: (3) Don't know → Go to U39
    - id: U30a
      kind: Question
      title: What was your income before taxes? (Income / Loss; follow-up to U30 Yes; source prints no separate id)
      precondition:
      - predicate: U30.outcome == 1
        hint: Asked only when question U30 is "(1) Yes → What was your income before taxes?".
      - predicate: not (U29.outcome == 7)
        hint: Asked only when question U29 is not "(7) Yes → Go to U31".
      - predicate: not (U30.outcome in [2, 3])
        hint: Asked only when question U30 is none of "(2) No income → Go to U39", "(3) Don't know → Go to U39".
      input:
        control: Radio
        labels:
          4: (4) Income
          5: (5) Loss
    - id: U30b
      kind: Question
      title: 'Amount: $ ______ .00 (income or loss before taxes; follow-up to U30 Yes; source prints no separate id)'
      precondition:
      - predicate: U30.outcome == 1
        hint: Asked only when question U30 is "(1) Yes → What was your income before taxes?".
      - predicate: not (U29.outcome == 7)
        hint: Asked only when question U29 is not "(7) Yes → Go to U31".
      - predicate: not (U30.outcome in [2, 3])
        hint: Asked only when question U30 is none of "(2) No income → Go to U39", "(3) Don't know → Go to U39".
      input:
        control: Editbox
        min: 0
        max: 9999999
  - id: b_s19_work
    title: Work during the last 12 months
    precondition:
    - predicate: not (S17.outcome in [3, 4])
      hint: Asked only when question S17 is none of "No income", "Don't know".
    - predicate: not (S17b.outcome in [1, 2])
      hint: Asked only when question S17b is none of "Less than $5,000", "$5,000 and more".
    - predicate: not (S17c.outcome in [3, 4])
      hint: Asked only when question S17c is none of "Less than $15,000", "$15,000 and more".
    - predicate: not (S17e.outcome in [5, 6])
      hint: Asked only when question S17e is none of "Less than $30,000", "$30,000 and more".
    - predicate: not (S17f.outcome in [7, 8])
      hint: Asked only when question S17f is none of "Less than $60,000", "$60,000 and more".
    - predicate: not (U30.outcome in [2, 3])
      hint: Asked only when question U30 is none of "(2) No income → Go to U39", "(3) Don't know → Go to U39".
    - predicate: not (U30.outcome == 1)
      hint: Asked only when question U30 is not "(1) Yes → What was your income before taxes?".
    items:
    - id: U31
      kind: Question
      title: For how many weeks of those 12 months did you do any work at a job or business? (Include vacation, illness, strikes, lock-outs and paid maternity leave) (Code number from 00 to 52)
      input:
        control: Editbox
        min: 0
        max: 52
    - id: U32
      kind: Question
      title: During those weeks of work were you mainly . . .
      input:
        control: Radio
        labels:
          1: (1) An employee working for someone else
          2: (2) Self-employed → Go to U35
    - id: U33
      kind: Question
      title: During those weeks of work were you mostly full-time or part-time?
      precondition:
      - predicate: U32.outcome == 1
        hint: Asked only when question U32 is "(1) An employee working for someone else".
      - predicate: not (U32.outcome == 2)
        hint: Asked only when question U32 is not "(2) Self-employed → Go to U35".
      input:
        control: Radio
        labels:
          3: (3) Full-time
          4: (4) Part-time
    - id: U34
      kind: Question
      title: For whom do you/did you last work? (Name of business, government department or agency or person)
      precondition:
      - predicate: U32.outcome == 1
        hint: Asked only when question U32 is "(1) An employee working for someone else".
      - predicate: not (U32.outcome == 2)
        hint: Asked only when question U32 is not "(2) Self-employed → Go to U35".
      input:
        control: Textarea
    - id: U35
      kind: Question
      title: What was the main kind of business, industry or service? (Give a full description. e.g., paper box manufacturing, retail shoe store, municipal board of education)
      input:
        control: Textarea
    - id: U36
      kind: Question
      title: 'What kind of work were you doing? (Give a full description: e.g., posting invoices, selling shoes, teaching primary school)'
      input:
        control: Textarea
    - id: U37
      kind: Question
      title: Which languages are were spoken at work by people with whom you have/had regular contact?
      input:
        control: Checkbox
        labels:
          1: 5 — English
          2: 6 — French
          4: 7 — Other (specify)
    - id: U38
      kind: Question
      title: What was your income before taxes from wages, salaries and self-employment during the last 12 months?
      input:
        control: Radio
        labels:
          1: 1 — Income → $
          2: 2 — Loss → $
          3: 3 — No income
          4: 4 — Don't know
    - id: U38a
      kind: Question
      title: 'Amount: $ ________ 00 (income or loss; follow-up to U38 codes 1/2; source prints no separate id)'
      precondition:
      - predicate: U38.outcome in [1, 2]
        hint: Asked only when question U38 is one of "1 — Income → $", "2 — Loss → $".
      input:
        control: Editbox
        min: 0
        max: 9999999
  - id: b_s19_income
    title: Other income and household income
    precondition:
    - predicate: not (S17.outcome in [3, 4])
      hint: Asked only when question S17 is none of "No income", "Don't know".
    - predicate: not (S17b.outcome in [1, 2])
      hint: Asked only when question S17b is none of "Less than $5,000", "$5,000 and more".
    - predicate: not (S17c.outcome in [3, 4])
      hint: Asked only when question S17c is none of "Less than $15,000", "$15,000 and more".
    - predicate: not (S17e.outcome in [5, 6])
      hint: Asked only when question S17e is none of "Less than $30,000", "$30,000 and more".
    - predicate: not (S17f.outcome in [7, 8])
      hint: Asked only when question S17f is none of "Less than $60,000", "$60,000 and more".
    items:
    - id: U39
      kind: Question
      title: What was your income from government sources such as Family Allowance, U.I.C., Social Assistance, Canada or Quebec Pension Plan or Old Age Security? $ ________ .00
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: U39a
      kind: Question
      title: 'U39 alternative answers: No income / Don''t know (source prints no separate id)'
      input:
        control: Radio
        labels:
          5: 5 — No income
          6: 6 — Don't know
    - id: U40
      kind: Question
      title: What was your income from investments or private pensions?
      input:
        control: Radio
        labels:
          1: 1 — Income → $
          2: 2 — Loss → $
          3: 3 — No income
          4: 4 — Don't know
    - id: U40a
      kind: Question
      title: 'Amount: $ ________ .00 (income or loss; follow-up to U40 codes 1/2; source prints no separate id)'
      precondition:
      - predicate: U40.outcome in [1, 2]
        hint: Asked only when question U40 is one of "1 — Income → $", "2 — Loss → $".
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: U41
      kind: Question
      title: What is your best estimate of the total income of all household members from all sources during the last 12 months? Was the total household income . . .
      input:
        control: Radio
        labels:
          1: 1 — Less than $20,000
          2: 2 — $20,000 and more
          3: 3 — No income
          4: 4 — Don't know
    - id: U41a
      kind: Question
      title: 'Less than $20,000: narrowing bracket (source prints no separate id)'
      precondition:
      - predicate: U41.outcome == 1
        hint: Asked only when question U41 is "1 — Less than $20,000".
      input:
        control: Radio
        labels:
          5: 5 — Less than $10,000
          6: 6 — $10,000 and more
    - id: U41b
      kind: Question
      title: 'Less than $10,000: narrowing bracket (source prints no separate id)'
      precondition:
      - predicate: U41a.outcome == 5
        hint: Asked only when question U41a is "5 — Less than $10,000".
      input:
        control: Radio
        labels:
          1: 1 — Less than $5,000
          2: 2 — $5,000 and more
    - id: U41c
      kind: Question
      title: '$10,000 and more (under $20,000): narrowing bracket (source prints no separate id)'
      precondition:
      - predicate: U41a.outcome == 6
        hint: Asked only when question U41a is "6 — $10,000 and more".
      input:
        control: Radio
        labels:
          3: 3 — Less than $15,000
          4: 4 — $15,000 and more
    - id: U41d
      kind: Question
      title: '$20,000 and more: narrowing bracket (source prints no separate id)'
      precondition:
      - predicate: U41.outcome == 2
        hint: Asked only when question U41 is "2 — $20,000 and more".
      input:
        control: Radio
        labels:
          7: 7 — Less than $40,000
          8: 8 — $40,000 and more
    - id: U41e
      kind: Question
      title: 'Less than $40,000: narrowing bracket (source prints no separate id)'
      precondition:
      - predicate: U41d.outcome == 7
        hint: Asked only when question U41d is "7 — Less than $40,000".
      input:
        control: Radio
        labels:
          5: 5 — Less than $30,000
          6: 6 — $30,000 and more
    - id: U41f
      kind: Question
      title: '$40,000 and more: narrowing bracket (source prints no separate id)'
      precondition:
      - predicate: U41d.outcome == 8
        hint: Asked only when question U41d is "8 — $40,000 and more".
      input:
        control: Radio
        labels:
          7: 7 — Less than $60,000
          8: 8 — $60,000 and more
  - id: b_s20_screening
    title: 'Selection control form: screening'
    precondition:
    - predicate: not (S17.outcome in [3, 4])
      hint: Asked only when question S17 is none of "No income", "Don't know".
    - predicate: not (S17b.outcome in [1, 2])
      hint: Asked only when question S17b is none of "Less than $5,000", "$5,000 and more".
    - predicate: not (S17c.outcome in [3, 4])
      hint: Asked only when question S17c is none of "Less than $15,000", "$15,000 and more".
    - predicate: not (S17e.outcome in [5, 6])
      hint: Asked only when question S17e is none of "Less than $30,000", "$30,000 and more".
    - predicate: not (S17f.outcome in [7, 8])
      hint: Asked only when question S17f is none of "Less than $60,000", "$60,000 and more".
    items:
    - id: Q5_2
      kind: Question
      title: Screening Interviewer Number
      input:
        control: Textarea
    - id: Q6_2
      kind: Question
      title: Screening Final Status
      input:
        control: Textarea
    - id: Q21
      kind: Question
      title: I'd like to make sure that I've dialed the right number. Is this ....... (read number)?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: No → Dial again. If still wrong, END
  - id: b_s20_residence
    title: 'Selection control form: type of number'
    precondition:
    - predicate: not (S17.outcome in [3, 4])
      hint: Asked only when question S17 is none of "No income", "Don't know".
    - predicate: not (S17b.outcome in [1, 2])
      hint: Asked only when question S17b is none of "Less than $5,000", "$5,000 and more".
    - predicate: not (S17c.outcome in [3, 4])
      hint: Asked only when question S17c is none of "Less than $15,000", "$15,000 and more".
    - predicate: not (S17e.outcome in [5, 6])
      hint: Asked only when question S17e is none of "Less than $30,000", "$30,000 and more".
    - predicate: not (S17f.outcome in [7, 8])
      hint: Asked only when question S17f is none of "Less than $60,000", "$60,000 and more".
    - predicate: not (Q21.outcome == 2)
      hint: Asked only when question 21 is not "No → Dial again. If still wrong, END".
    items:
    - id: Q22
      kind: Question
      title: Is this number for a business, an institution or a private home?
      input:
        control: Radio
        labels:
          1: Private home (Go to 30)
          2: Both home and business (Go to 30)
          3: Business, institution or other non-residence
    - id: Q23
      kind: Question
      title: Does anyone use this telephone number as a home phone number?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: No → Thank respondent and END
  - id: b_s20_household_size
    title: 'Selection control form: household size'
    precondition:
    - predicate: not (S17.outcome in [3, 4])
      hint: Asked only when question S17 is none of "No income", "Don't know".
    - predicate: not (S17b.outcome in [1, 2])
      hint: Asked only when question S17b is none of "Less than $5,000", "$5,000 and more".
    - predicate: not (S17c.outcome in [3, 4])
      hint: Asked only when question S17c is none of "Less than $15,000", "$15,000 and more".
    - predicate: not (S17e.outcome in [5, 6])
      hint: Asked only when question S17e is none of "Less than $30,000", "$30,000 and more".
    - predicate: not (S17f.outcome in [7, 8])
      hint: Asked only when question S17f is none of "Less than $60,000", "$60,000 and more".
    - predicate: not (Q21.outcome == 2)
      hint: Asked only when question 21 is not "No → Dial again. If still wrong, END".
    - predicate: not (Q23.outcome == 2)
      hint: Asked only when question 23 is not "No → Thank respondent and END".
    items:
    - id: Q24
      kind: Question
      title: How many persons live or stay at this address and use this number as a home phone number?
      input:
        control: Radio
        labels:
          1: Less than 15 → Go to 30
          2: 15 or more → Make appointment
  - id: b_s20_roster_selection
    title: 'Selection control form: household roster and selection'
    precondition:
    - predicate: not (S17.outcome in [3, 4])
      hint: Asked only when question S17 is none of "No income", "Don't know".
    - predicate: not (S17b.outcome in [1, 2])
      hint: Asked only when question S17b is none of "Less than $5,000", "$5,000 and more".
    - predicate: not (S17c.outcome in [3, 4])
      hint: Asked only when question S17c is none of "Less than $15,000", "$15,000 and more".
    - predicate: not (S17e.outcome in [5, 6])
      hint: Asked only when question S17e is none of "Less than $30,000", "$30,000 and more".
    - predicate: not (S17f.outcome in [7, 8])
      hint: Asked only when question S17f is none of "Less than $60,000", "$60,000 and more".
    - predicate: not (Q21.outcome == 2)
      hint: Asked only when question 21 is not "No → Dial again. If still wrong, END".
    - predicate: not (Q23.outcome == 2)
      hint: Asked only when question 23 is not "No → Thank respondent and END".
    - predicate: not (Q24.outcome == 2)
      hint: Asked only when question 24 is not "15 or more → Make appointment".
    items:
    - id: Q74
      kind: Question
      title: 'INTERVIEWER: Transcribe selected person name from item 35 and related Page-Line No. from items 33 & 34. (Selected person name / Page-line)'
      input:
        control: Textarea
    - id: Q75
      kind: Question
      title: Would you prefer to be interviewed in English or French?
      input:
        control: Radio
        labels:
          1: (1) English
          2: (2) French
    - id: Q76
      kind: Question
      title: Interviewer Number
      input:
        control: Textarea
    - id: Q31
      kind: Question
      title: I need to select one person from your household for an interview which will be conducted in November. Starting with the oldest, what is the first name and age of each person living or staying here who has no usual place of residence elsewhere? Enter names and ages in items 35 and 37
      input:
        control: Textarea
    - id: Q33
      kind: Question
      title: Pg (page number of the household roster row)
      input:
        control: Editbox
        min: 1
        max: 99
    - id: Q34
      kind: Question
      title: Ln (line number of the household roster row, 1 to 8)
      input:
        control: Range
        min: 1
        max: 8
        step: 1
    - id: Q35
      kind: Question
      title: NAMES OF HOUSEHOLD MEMBERS (GIVEN NAME / SURNAME), one per roster line
      input:
        control: Textarea
    - id: Q36
      kind: Question
      title: 'SEL # (number given to persons 15 years of age and over, oldest to youngest; selected person circled)'
      input:
        control: Editbox
        min: 0
        max: 99
    - id: Q37
      kind: Question
      title: AGE (of each household member, roster item 37)
      input:
        control: Editbox
        min: 0
        max: 120
    - id: Q38
      kind: Question
      title: SEX (code per Interviewer Reference Card)
      input:
        control: Textarea
    - id: Q39
      kind: Question
      title: MS (code per Interviewer Reference Card)
      input:
        control: Textarea
    - id: Q40
      kind: Question
      title: Fam ID (code per Interviewer Reference Card)
      input:
        control: Textarea
    - id: Q41
      kind: Question
      title: R to H (code per Interviewer Reference Card)
      input:
        control: Textarea
    - id: Q42
      kind: Question
      title: First Lang Learn (code per Interviewer Reference Card)
      input:
        control: Textarea
    - id: Q43
      kind: Question
      title: CN in E (code per Interviewer Reference Card)
      input:
        control: Textarea
    - id: Q44
      kind: Question
      title: CN in F (code per Interviewer Reference Card)
      input:
        control: Textarea
    - id: Q45
      kind: Question
      title: Main language of Education (Only for persons aged 6-14 yrs)
      precondition:
      - predicate: Q37.outcome >= 6 and Q37.outcome <= 14
        hint: Asked only of persons aged 6 to 14.
      input:
        control: Radio
        labels:
          1: English
          2: French
          3: Other
    - id: Q46
      kind: Question
      title: CR in E (code per Interviewer Reference Card)
      input:
        control: Textarea
    - id: Q47
      kind: Question
      title: CR in F (code per Interviewer Reference Card)
      input:
        control: Textarea
    - id: Q48
      kind: Question
      title: FR IM (code per Interviewer Reference Card)
      input:
        control: Textarea
    - id: Q49
      kind: Question
      title: Are there any persons away from this household attending school, visiting, travelling or in the hospital who USUALLY live here?
      input:
        control: Radio
        labels:
          1: Yes → Enter names and complete items 37 through 48
          2: 'No'
    - id: Q50
      kind: Question
      title: Does anyone else live at this address, such as other relatives, roomers, boarders or employees?
      input:
        control: Radio
        labels:
          1: Yes → Enter names and complete items 37 through 48
          2: 'No'
    - id: Q54
      kind: Question
      title: INTERVIEWER If the respondent volunteers a best time to be contacted, mark below.
      input:
        control: Textarea
    - id: Q55
      kind: Question
      title: Final Status
      input:
        control: Textarea
    - id: Q56
      kind: Question
      title: Number of Eligible Household Members
      input:
        control: Editbox
        min: 0
        max: 99
    - id: Q57
      kind: Question
      title: 'NOTES (Item #)'
      input:
        control: Textarea
  - id: b_s21_diary
    title: APPENDIX C — General social survey (GSS 2-2D)
    precondition:
    - predicate: not (S17.outcome in [3, 4])
      hint: Asked only when question S17 is none of "No income", "Don't know".
    - predicate: not (S17b.outcome in [1, 2])
      hint: Asked only when question S17b is none of "Less than $5,000", "$5,000 and more".
    - predicate: not (S17c.outcome in [3, 4])
      hint: Asked only when question S17c is none of "Less than $15,000", "$15,000 and more".
    - predicate: not (S17e.outcome in [5, 6])
      hint: Asked only when question S17e is none of "Less than $30,000", "$30,000 and more".
    - predicate: not (S17f.outcome in [7, 8])
      hint: Asked only when question S17f is none of "Less than $60,000", "$60,000 and more".
    - predicate: not (Q21.outcome == 2)
      hint: Asked only when question 21 is not "No → Dial again. If still wrong, END".
    - predicate: not (Q23.outcome == 2)
      hint: Asked only when question 23 is not "No → Thank respondent and END".
    - predicate: not (Q24.outcome == 2)
      hint: Asked only when question 24 is not "15 or more → Make appointment".
    items:
    - id: a
      kind: Question
      title: And then, what did you do next?
      input:
        control: Textarea
    - id: b
      kind: Question
      title: When did this start?
      input:
        control: Textarea
    - id: c
      kind: Question
      title: When did this end?
      input:
        control: Textarea
    - id: d
      kind: Question
      title: Where were you?/ Were you still . . . (Place or In Transit)
      input:
        control: Radio
        labels:
          1: 1 R's Home
          2: 2 Work Place
          3: 3 Other Place
          4: 4 Car
          5: 5 Walk
          6: 6 Bus & Subway
          7: 7 Other
    - id: e
      kind: Question
      title: Who was with you?/ Were you still . . .
      precondition:
      - predicate: 1 == 1
        hint: No pregunte e para actividades de sueño, sexo u otro cuidado personal.
      input:
        control: Checkbox
        labels:
          1: 1 — Alone
          2: 2 — Spouse/Partner
          4: 3 — Child(ren) of Household
          8: 4 — Other Family Member(s)
          16: 5 — Friend(s)
          32: 6 — Other Person(s)
