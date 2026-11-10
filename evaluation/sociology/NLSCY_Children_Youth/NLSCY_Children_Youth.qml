qmlVersion: '2.7'
questionnaire:
  title: National Longitudinal Survey of Children — Survey Instruments for 1994-95, Data Collection, Cycle 1
  blocks:
  - id: b_s1_preamble
    title: Household record setup
    items:
    - id: AGE
      kind: Question
      title: 'External input: age of the person the form is about (IF AGE<12, IF AGE >= 65 etc.); derived from the date of birth in DEMO-Q4'
      external: true
      input:
        control: Editbox
        min: 0
        max: 120
    - id: PARENT
      kind: Question
      title: 'External input: whether the person the form is about / the respondent is the parent of the child (IF NOT PARENT; IF RESPONDENT IS NOT THE PARENT); known from the household roster relationships (DEMO-Q8)'
      external: true
      input:
        control: Radio
        labels:
          1: PARENT
          2: NOT PARENT
  - id: b_s1_language
    title: Interview language preference
    items:
    - id: CONT_Q2
      kind: Question
      title: Would you prefer to be interviewed in English or French?
      input:
        control: Radio
        labels:
          1: ENGLISH
          2: FRENCH
          3: EITHER
  - id: b_s1_roster
    title: Household roster
    items:
    - id: DEMO_Q1
      kind: Question
      title: What are the names of all persons now living or staying here who have no usual place of residence elsewhere? (First and last names)
      input:
        control: Textarea
    - id: DEMO_Q2
      kind: Question
      title: Are there any persons away from this household attending school, visiting, travelling, or in hospital who usually live here?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
    - id: DEMO_Q3
      kind: Question
      title: Does anyone else live at this dwelling such as young children, relatives, roomers, boarders, or employees?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
    - id: DEMO_Q4
      kind: Question
      title: What is ...'s date of birth?
      input:
        control: Textarea
    - id: DEMO_Q5
      kind: Question
      title: Enter or ask ...'s sex.
      input:
        control: Radio
        labels:
          1: MALE
          2: FEMALE
    - id: DEMO_Q6
      kind: Question
      title: What is ... 's marital status?
      input:
        control: Dropdown
        labels:
          1: NOW MARRIED
          2: COMMON-LAW
          3: LIVING WITH A PARTNER
          4: SINGLE (NEVER MARRIED)
          5: WIDOWED
          6: SEPARATED
          7: DIVORCED
    - id: DEMO_Q7
      kind: Question
      title: ENTER ...'S FAMILY ID CODE. (A to Z)
      input:
        control: Textarea
    - id: DEMO_Q8
      kind: Question
      title: Relationships of everyone to everyone else;
      input:
        control: Dropdown
        labels:
          1: HUSBAND/WIFE
          2: COMMON LAW PARTNER
          3: BIRTH PARENT
          4: STEP PARENT
          5: ADOPTIVE PARENT
          6: FOSTER PARENT
          7: BIRTH CHILD
          8: STEP CHILD
          9: ADOPTED CHILD
          10: FOSTER CHILD
          11: SISTER/BROTHER
          12: GRANDPARENT
          13: GRANDCHILD
          14: IN-LAW
          15: OTHER RELATED
          16: UNRELATED
          17: SAME SEX PARTNER
  - id: b_s1_dwelling
    title: Dwelling
    items:
    - id: HHLD_Q1
      kind: Question
      title: Now a few questions about your dwelling. Is this dwelling owned by a member of this household (even if being paid for)?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
    - id: HHLD_Q2
      kind: Question
      title: Is this dwelling subsidized by the government for any reason? (Eg. low income housing project, co-operative housing project, public housing.)
      precondition:
      - predicate: not (HHLD_Q1.outcome == 1)
        hint: Asked only when question HHLD-Q1 is not "YES".
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
    - id: HHLD_Q2B
      kind: Question
      title: Is this dwelling in need of any repairs? (READ LIST. MARK ONE ONLY.)
      input:
        control: Radio
        labels:
          1: Yes, minor repairs (missing or loose floor tiles, bricks or shingles, defective steps, railing or siding, etc.)
          2: Yes, major repairs (defective plumbing or electrical wiring, structural repairs to walls, floors or ceiling, etc.)
          3: No, only regular maintenance is needed (painting, furnace cleaning, etc.)
    - id: HHLD_Q3
      kind: Question
      title: How many bedrooms are there in this dwelling? (IF NO SEPARATE ENCLOSED BEDROOM, ENTER "00".) NUMBER OF BEDROOMS (2 DIGITS)
      input:
        control: Editbox
        min: 0
        max: 99
    - id: HHLD_Q6
      kind: Question
      title: RECORD TYPE OF DWELLING (BY INTERVIEWER OBSERVATION)
      input:
        control: Dropdown
        labels:
          1: SINGLE DETACHED HOUSE
          2: SEMI-DETACHED OR DOUBLE (SIDE-BY-SIDE)
          3: GARDEN HOUSE, TOWN-HOUSE OR ROW HOUSE
          4: DUPLEX (ONE ABOVE THE OTHER)
          5: LOW-RISE APARTMENT (LESS THAN 5 STORIES)
          6: HIGH-RISE APARTMENT (5 OR MORE STORIES)
          7: INSTITUTION
          8: HOTEL, ROOMING OR LODGING HOUSE, LOGGING OR CONSTRUCTION CAMP, HUTTERITE COLONY
          9: MOBILE HOME
          10: OTHER (SPECIFY)
  - id: b_s1_interview
    title: Interview record
    items:
    - id: HHLD_Q7
      kind: Question
      title: INFORMATION SOURCE INDICATOR I.E. WHO IS PROVIDING THE INFORMATION
      input:
        control: Textarea
    - id: HHLD_Q8
      kind: Question
      title: RECORD LANGUAGE OF INTERVIEW
      input:
        control: Dropdown
        labels:
          1: ENGLISH
          2: FRENCH
          3: ARABIC
          4: CHINESE
          5: CREE
          6: GERMAN
          7: GREEK
          8: HUNGARIAN
          9: ITALIAN
          10: KOREAN
          11: PERSIAN (FARSI)
          12: POLISH
          13: PORTUGUESE
          14: PUNJABI
          15: SPANISH
          16: TAGALOG (FILIPINO)
          17: UKRAINIAN
          18: VIETNAMESE
          19: OTHER (SPECIFY)
    - id: CAID_INT_1
      kind: Question
      title: Who is the most knowledgeable about ...? (THE INTERVIEWER SHOULD ASK FOR THE PERSON MOST KNOWLEDGEABLE ABOUT THE CHILD TO RESPOND ON BEHALF OF FAMILY MEMBERS.)
      input:
        control: Textarea
  - id: b_s2_respondent
    title: 'Restriction of Activities: respondent'
    items:
    - id: PICKRESP
      kind: Question
      title: Who is providing the information for this person's form?
      input:
        control: Textarea
  - id: b_s2_restriction
    title: Restriction of Activities
    precondition:
    - predicate: not (AGE.outcome < 12)
      hint: Asked only of persons aged 12 and over
    items:
    - id: RESTR_Q1a
      kind: Question
      title: 'Because of a long-term physical or mental condition or a health problem, are/is ... limited in the kind or amount of activity you/he/she can do: a) At home?'
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
    - id: RESTR_Q1b
      kind: Question
      title: b) At school?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          3: NOT APPLICABLE
    - id: RESTR_Q1c
      kind: Question
      title: c) At work?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          3: NOT APPLICABLE
    - id: RESTR_Q1d
      kind: Question
      title: d) In other activities such as transportation to or from work or leisure time activities?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
    - id: RESTR_Q1e
      kind: Question
      title: e) In caring for children?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          3: NOT APPLICABLE
  - id: b_s3_chronic_conditions
    title: Chronic Conditions
    precondition:
    - predicate: not (AGE.outcome < 12 or PARENT.outcome == 2)
      hint: Asked only when the person is aged 12 or over and PARENT is not 2
    items:
    - id: CHRON_Q1
      kind: Question
      title: 'Do(es) ... have any of the following long-term conditions that have been diagnosed by a health professional: (READ LIST. MARK ALL THAT APPLY.)'
      input:
        control: Checkbox
        labels:
          1: (a) Food allergies?
          2: (b) Other allergies?
          4: (c) Asthma? (IF YES ASK CHRON-Q1cc1)
          8: (d) Arthritis or rheumatism?
          16: (e) Back problems excluding arthritis?
          32: (f) High blood pressure?
          64: (g) Migraine headaches?
          128: (h) Chronic bronchitis or emphysema?
          256: (i) Sinusitis?
          512: (j) Diabetes?
          1024: (k) Epilepsy?
          2048: (l) Heart disease?
          4096: (m) Cancer? (IF YES ASK CHRON-Q1mm)
          8192: (n) Stomach or intestinal ulcers?
          16384: (o) Effects of stroke?
          32768: (p) Urinary incontinence?
          65536: (r) Alzheimer's disease or other dementia?
          131072: (s) Cataracts?
          262144: (t) Glaucoma?
          524288: (u) Any other long term condition? (Specify)
          1048576: (v) None
      postcondition:
      - predicate: CHRON_Q1.outcome & 1048576 == 0 or CHRON_Q1.outcome == 1048576
        hint: If "None" (v) is ticked in CHRON-Q1, no other condition can be ticked. Untick "None" or the other conditions.
        invented: true
    - id: CHRON_Q1mm
      kind: Question
      title: What type(s) of cancer is this? For example, skin, lung or colon cancer.
      precondition:
      - predicate: CHRON_Q1.outcome & 4096 > 0
        hint: Asked only when cancer is ticked in CHRON-Q1
      input:
        control: Textarea
    - id: CHRON_Q1cc1
      kind: Question
      title: Have/Has ... had an attack of asthma in the past 12 months?
      precondition:
      - predicate: CHRON_Q1.outcome & 4 > 0
        hint: Asked only when asthma is ticked in CHRON-Q1
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
    - id: CHRON_Q1cc2
      kind: Question
      title: Have/Has ... had wheezing or whistling in the chest at any time in the past 12 months?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
  - id: b_s4_birth
    title: 'Socio-demographic Characteristics: Birthplace'
    items:
    - id: SOCIO_Q1
      kind: Question
      title: In what country were/was ... born? (DO NOT READ LIST. MARK ONE ONLY.)
      input:
        control: Dropdown
        labels:
          1: CANADA (GO TO NEXT SECTION)
          2: CHINA
          3: FRANCE
          4: GERMANY
          5: GREECE
          6: GUYANA
          7: HONG KONG
          8: HUNGARY
          9: INDIA
          10: ITALY
          11: JAMAICA
          12: NETHERLANDS
          13: PHILIPPINES
          14: POLAND
          15: PORTUGAL
          16: UNITED KINGDOM
          17: UNITED STATES
          18: VIET NAM
          19: OTHER (SPECIFY)
  - id: b_s4_citizenship
    title: Citizenship
    items:
    - id: SOCIO_Q2a
      kind: Question
      title: Of what country are/is ... a citizen? (DO NOT READ LIST. MARK ALL THAT APPLY.)
      precondition:
      - predicate: not (SOCIO_Q1.outcome == 1)
        hint: Asked only when question SOCIO-Q1 is not "CANADA (GO TO NEXT SECTION)".
      input:
        control: Checkbox
        labels:
          1: CANADA, CITIZEN BY BIRTH (GO TO NEXT SECTION)
          2: CANADA, BY NATURALIZATION
          4: SAME AS COUNTRY OF BIRTH
          8: OTHER COUNTRY
  - id: b_s4_foreign_born
    title: Immigration, ethnicity, language and religion
    precondition:
    - predicate: not (SOCIO_Q1.outcome == 1)
      hint: Asked only when question SOCIO-Q1 is not "CANADA (GO TO NEXT SECTION)".
    - predicate: SOCIO_Q2a.outcome is not None and SOCIO_Q2a.outcome % 2 == 0
      hint: Asked only when the person is not a Canadian citizen by birth.
    items:
    - id: SOCIO_Q2b
      kind: Question
      title: Are/Is ... now, or have/has ... ever been a landed immigrant?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
    - id: SOCIO_Q3
      kind: Question
      title: In what year did ... first immigrate to Canada? YEAR (4 DIGITS) (ENTER <1999> IF CANADIAN CITIZEN BY BIRTH.)
      input:
        control: Editbox
        min: 1900
        max: 1999
    - id: SOCIO_Q4
      kind: Question
      title: 'To which ethnic or cultural group(s) did your/...''s ancestors belong? (For example: French, British, Chinese) (DO NOT READ LIST. MARK ALL THAT APPLY.)'
      input:
        control: Checkbox
        labels:
          1: CANADIAN
          2: FRENCH
          4: ENGLISH
          8: GERMAN
          16: SCOTTISH
          32: IRISH
          64: ITALIAN
          128: UKRAINIAN
          256: DUTCH (NETHERLANDS)
          512: CHINESE
          1024: JEWISH
          2048: POLISH
          4096: PORTUGUESE
          8192: SOUTH ASIAN
          16384: BLACK
          32768: NORTH AMERICAN INDIAN
          65536: MÉTIS
          131072: INUIT/ESKIMO
          262144: OTHER (SPECIFY)
    - id: SOCIO_Q5
      kind: Question
      title: In what language(s) can ... conduct a conversation? (DO NOT READ LIST. MARK ALL THAT APPLY.)
      input:
        control: Checkbox
        labels:
          1: ENGLISH
          2: FRENCH
          4: ARABIC
          8: CHINESE
          16: CREE
          32: GERMAN
          64: GREEK
          128: HUNGARIAN
          256: ITALIAN
          512: KOREAN
          1024: PERSIAN (FARSI)
          2048: POLISH
          4096: PORTUGUESE
          8192: PUNJABI
          16384: SPANISH
          32768: TAGALOG (FILIPINO)
          65536: UKRAINIAN
          131072: VIETNAMESE
          262144: OTHER (SPECIFY)
    - id: SOCIO_Q6
      kind: Question
      title: What is the language that ... first learned at home in childhood and can still understand? (IF ... CAN NO LONGER UNDERSTAND THE FIRST LANGUAGE LEARNED, CHOOSE THE SECOND LANGUAGE LEARNED.) (DO NOT READ LIST. MARK ALL THAT APPLY.)
      input:
        control: Checkbox
        labels:
          1: ENGLISH
          2: FRENCH
          4: ARABIC
          8: CHINESE
          16: CREE
          32: GERMAN
          64: GREEK
          128: HUNGARIAN
          256: ITALIAN
          512: KOREAN
          1024: PERSIAN (FARSI)
          2048: POLISH
          4096: PORTUGUESE
          8192: PUNJABI
          16384: SPANISH
          32768: TAGALOG (FILIPINO)
          65536: UKRAINIAN
          131072: VIETNAMESE
          262144: OTHER (SPECIFY)
    - id: SOCIO_Q8
      kind: Question
      title: What, if any, is your/...'s religion? (DO NOT READ LIST. MARK ONE ONLY.)
      input:
        control: Dropdown
        labels:
          1: NO RELIGION (GO TO NEXT SECTION)
          2: ROMAN CATHOLIC
          3: UNITED CHURCH
          4: ANGLICAN
          5: PRESBYTERIAN
          6: LUTHERAN
          7: BAPTIST
          8: EASTERN ORTHODOX
          9: JEWISH
          10: ISLAM (MUSLIM)
          11: BUDDHIST
          12: HINDU
          13: SIKH
          14: JEHOVAH'S WITNESS
          15: OTHER (SPECIFY)
    - id: SOCIO_Q9
      kind: Question
      title: Other than on special occasions (such as weddings, funerals or baptisms), how often did ... attend religious services or meetings in the past 12 months? (READ LIST. MARK ONE ONLY.)
      precondition:
      - predicate: not (SOCIO_Q8.outcome == 1)
        hint: Asked only when question SOCIO-Q8 is not "NO RELIGION (GO TO NEXT SECTION)".
      input:
        control: Radio
        labels:
          1: At least once a week
          2: At least once a month
          3: At least 3 or 4 times a year
          4: At least once a year
          5: Not at all
  - id: b_s5_schooling
    title: Education
    precondition:
    - predicate: not (AGE.outcome < 12)
      hint: Asked of respondents aged 12 and over
    items:
    - id: EDUC_Q1
      kind: Question
      title: Excluding kindergarten, how many years of elementary and high school have/has ... successfully completed? (DO NOT READ LIST. MARK ONE ONLY.)
      input:
        control: Dropdown
        labels:
          1: NO SCHOOLING (GO TO NEXT SECTION)
          2: 1-5 YEARS
          3: '6'
          4: '7'
          5: '8'
          6: '9'
          7: '10'
          8: '11'
          9: '12'
          10: '13'
  - id: b_s5_postsecondary
    title: 'Education: high school graduation and further schooling'
    precondition:
    - predicate: not (AGE.outcome < 12)
      hint: Asked of respondents aged 12 and over
    - predicate: not (EDUC_Q1.outcome == 1)
      hint: Asked only when question EDUC-Q1 is not NO SCHOOLING
    - predicate: not (AGE.outcome < 15)
      hint: Asked of respondents aged 15 and over
    items:
    - id: EDUC_Q2
      kind: Question
      title: Have/has ... graduated from high school?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
    - id: EDUC_Q3
      kind: Question
      title: Have/has ... ever attended any other kind of school such as a university, community college, business school, trade or vocational school, CEGEP or other post-secondary institution?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: NO (GO TO EDUC-C5)
    - id: EDUC_Q4
      kind: Question
      title: What is the highest level of education that ... have/has attained? (DO NOT READ LIST. MARK ONE ONLY.)
      precondition:
      - predicate: not (EDUC_Q3.outcome == 2)
        hint: Asked only when question EDUC-Q3 is not NO
      input:
        control: Dropdown
        labels:
          1: SOME TRADE, TECHNICAL OR VOCATIONAL SCHOOL, OR BUSINESS COLLEGE
          2: SOME COMMUNITY COLLEGE, CEGEP, OR NURSING SCHOOL
          3: SOME UNIVERSITY
          4: DIPLOMA OR CERTIFICATE FROM TRADE, TECHNICAL OR VOCATIONAL SCHOOL, OR BUSINESS COLLEGE
          5: DIPLOMA OR CERTIFICATE FROM COMMUNITY COLLEGE, CEGEP OR NURSING SCHOOL
          6: BACHELOR OR UNDERGRADUATE DEGREE, OR TEACHER'S COLLEGE (E.G. B.A., B.SC., LL.B.)
          7: MASTER'S (E.G. M.A., M. SC., M.ED.)
          8: DEGREE IN MEDICINE, DENTISTRY, VETERINARY MEDICINE OR OPTOMETRY (E.G. M.D., D.D.S., D.M.D., D.V.M., O.D.)
          9: EARNED DOCTORATE (E.G. PH.D., D.SC., D.ED.)
          10: OTHER (SPECIFY)
  - id: b_s5_current
    title: 'Education: current attendance'
    precondition:
    - predicate: not (AGE.outcome < 12)
      hint: Asked of respondents aged 12 and over
    - predicate: not (EDUC_Q1.outcome == 1)
      hint: Asked only when question EDUC-Q1 is not NO SCHOOLING
    - predicate: not (AGE.outcome < 15)
      hint: Asked of respondents aged 15 and over
    - predicate: not (AGE.outcome >= 65)
      hint: Not asked of respondents aged 65 and over
    items:
    - id: EDUC_Q5
      kind: Question
      title: Are/Is ... currently attending a school, college or university?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: NO (GO TO NEXT SECTION)
    - id: EDUC_Q6
      kind: Question
      title: Are/Is ... enrolled as a full-time or part-time student?
      precondition:
      - predicate: not (EDUC_Q5.outcome == 2)
        hint: Asked only when question EDUC-Q5 is not NO
      input:
        control: Radio
        labels:
          1: FULL-TIME
          2: PART-TIME
  - id: b_s6_main_activity
    title: Labour Force
    items:
    - id: LFS_Q1
      kind: Question
      title: What do/does ... consider to be your/his/her current main activity? (For example, working for pay, caring for family.) (DO NOT READ LIST. MARK ONE ONLY.)
      input:
        control: Radio
        labels:
          1: CARING FOR FAMILY
          2: WORKING FOR PAY OR PROFIT
          3: CARING FOR FAMILY AND WORKING FOR PAY OR PROFIT
          4: GOING TO SCHOOL
          5: RECOVERING FROM ILLNESS/ON DISABILITY
          6: LOOKING FOR WORK
          7: RETIRED
          8: OTHER (SPECIFY)
    - id: LFS_Q2
      kind: Question
      title: Have/has you/he/she worked for pay or profit at any time in the past 12 months?
      precondition:
      - predicate: not (LFS_Q1.outcome in [2, 3])
        hint: Asked only when question LFS-Q1 is none of "WORKING FOR PAY OR PROFIT", "CARING FOR FAMILY AND WORKING FOR PAY OR PROFIT".
      input:
        control: Radio
        labels:
          1: YES (GO TO LFS-Q3)
          2: 'NO'
  - id: b_s6_job_roster
    title: Jobs in the past 12 months
    precondition:
    - predicate: not (LFS_Q2.outcome == 2 and LFS_Q1.outcome != 7)
      hint: Asked only of those who worked for pay or profit in the past 12 months, or who are retired.
    items:
    - id: LFS_Q3
      kind: Question
      title: 'For whom/whom else have/has you/he/she worked for pay or profit in the past 12 months? (50 chars) [Roster: LFS-Q3 to LFS-Q11 allow up to 6 jobs]'
      input:
        control: Textarea
        maxLength: 50
    - id: LFS_Q4
      kind: Question
      title: Did you/he/she have that job 1 year ago, that is, on (date 12 months ago) without a break in employment since then?
      input:
        control: Radio
        labels:
          1: YES (GO TO LFS-Q6)
          2: 'NO'
    - id: LFS_Q5
      kind: Question
      title: When did you/he/she start working at this job or business? MM/DD/YY
      precondition:
      - predicate: not (LFS_Q4.outcome == 1)
        hint: Asked only when question LFS-Q4 is not "YES (GO TO LFS-Q6)".
      input:
        control: Textarea
    - id: LFS_Q6
      kind: Question
      title: Do/Does you/he/she now have that job?
      input:
        control: Radio
        labels:
          1: YES (GO TO LFS-Q8)
          2: 'NO'
    - id: LFS_Q7
      kind: Question
      title: When did you/he/she stop working at this job or business? MM/DD/YY
      precondition:
      - predicate: not (LFS_Q6.outcome == 1)
        hint: Asked only when question LFS-Q6 is not "YES (GO TO LFS-Q8)".
      input:
        control: Textarea
    - id: LFS_Q8
      kind: Question
      title: About how many hours per week do/does/did you/he/she usually work at this job? (IF IRREGULAR WORKING SCHEDULE, ENTER THE AVERAGE PER WEEK FOR THE LAST 4 WEEKS WORKED.) HOURS
      input:
        control: Editbox
        min: 0
        max: 99
    - id: LFS_Q9
      kind: Question
      title: Which of the following best describes the hours you/he/she usually work/works/worked at this job? (READ LIST. MARK ONE ONLY.)
      input:
        control: Radio
        labels:
          1: Regular daytime schedule or shift
          2: Regular evening shift
          3: Regular night shift
          4: Rotating shift (change from days to evenings to nights)
          5: Split shift
          6: On call
          7: Irregular schedule
          8: Other (Specify)
    - id: LFS_Q10
      kind: Question
      title: Do/Does/Did you/he/she usually work on weekends at this job?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
  - id: b_s7_preamble
    title: 'Labour Force Survey (continued): setup'
    precondition:
    - predicate: not (LFS_Q2.outcome == 2 and LFS_Q1.outcome != 7)
      hint: Asked unless the section is skipped by LFS-Q1 and LFS-Q2
    items:
    - id: LFS_GAPS
      kind: Question
      title: 'Number of gaps > 6 days found when checking the calendar (LFS-C17: CHECK THE CALENDAR FOR GAPS > 6 DAYS; IF # GAPS = 0 ---> GO TO NEXT SECTION)'
      external: true
      input:
        control: Editbox
        min: 0
        max: 99
  - id: b_s7_main_job
    title: Main job in the past 12 months
    precondition:
    - predicate: not (LFS_Q2.outcome == 2 and LFS_Q1.outcome != 7)
      hint: Asked unless the section is skipped by LFS-Q1 and LFS-Q2
    items:
    - id: LFS_Q11
      kind: Question
      title: Did you/he/she do any other work for pay or profit in the past 12 months?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
    - id: LFS_Q12
      kind: Question
      title: Which was the main job? (Answer will be chosen from roster of jobs.) (Definition of main job will be supplied in the interviewers manual.)
      precondition:
      - predicate: LFS_Q11.outcome == 1
        hint: Asked only when question LFS-Q11 is "YES".
      input:
        control: Textarea
    - id: LFS_Q13
      kind: Question
      title: Thinking about this/the main job, what kind of business, service or industry is this? (For example, wheat farm, trapping, road maintenance, retail shoe store, secondary school.) (50 chars)
      input:
        control: Textarea
        maxLength: 50
    - id: LFS_Q14
      kind: Question
      title: Again, thinking about this/the main job, what kind of work was/were ... doing? (For example, medical lab technician, accounting clerk, secondary school teacher, supervisor of data entry unit, food processing labourer.) (50 chars)
      input:
        control: Textarea
        maxLength: 50
    - id: LFS_Q15
      kind: Question
      title: In this work, what were your/his/her most important duties or activities? (For example, analysis of blood samples, verifying invoices, teaching mathematics, organizing work schedules, cleaning vegetables.) (50 chars)
      input:
        control: Textarea
        maxLength: 50
    - id: LFS_Q16
      kind: Question
      title: Did you/he/she work mainly for others for wages, salary or commission, or in your/his/her own business, farm or professional practice? (DO NOT READ LIST. MARK ONE ONLY.)
      input:
        control: Radio
        labels:
          1: FOR OTHERS FOR WAGES, SALARY OR COMMISSION
          2: IN OWN BUSINESS, FARM OR PROFESSIONAL PRACTICE
          3: UNPAID FAMILY WORKER
    - id: LFS_Q16A
      kind: Question
      title: At this job, about how many hours per week were/was you/he/she paid for? (HOURS PER WEEK) * Questions LFS-Q16A to LFS Q16E were not asked in November 1994 collection.
      input:
        control: Editbox
        min: 0
        max: 168
    - id: LFS_Q16B
      kind: Question
      title: At this job, did you/he/she receive any tips, commissions, bonuses, or paid overtime? * Not asked in November 1994 collection.
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: LFS_Q16C
      kind: Question
      title: At this job, including tips, commissions, bonuses, or paid overtime, what was your/his/her usual wage or salary before taxes and other deductions from the employer? (TO ENTER CENTS, ENTER . THEN THE CENTS.) * Not asked in November 1994 collection.
      precondition:
      - predicate: not (LFS_Q16B.outcome in [2, 8])
        hint: Asked only when question LFS-Q16B is none of "NO", "DON'T KNOW".
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: LFS_Q16CC
      kind: Question
      title: At this job, what was your/his/her usual wage or salary before taxes and other deductions from the employer? (TO ENTER CENTS, ENTER . THEN THE CENTS.) * Not asked in November 1994 collection.
      precondition:
      - predicate: not (LFS_Q16C.outcome != 8 and LFS_Q16C.outcome != 9)
        hint: Asked only when LFS-Q16C was answered don't know or refusal
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: LFS_Q16D
      kind: Question
      title: Was this ...
      input:
        control: Dropdown
        labels:
          1: 01 — PER HOUR
          2: 02 — PER DAY
          3: 03 — PER WEEK
          4: 04 — EVERY TWO WEEKS
          5: 05 — TWICE A MONTH
          6: 06 — PER MONTH
          7: 07 — PER YEAR
          8: 08 — SINCE STARTING AT THIS JOB THIS YEAR
          9: 09 — OTHER
          98: DON'T KNOW
          99: REFUSAL
    - id: LFS_Q16E
      kind: Question
      title: At this job, what was your/his/her total earnings? * Not asked in November 1994 collection.
      input:
        control: Editbox
        min: 0
        max: 9999999
  - id: b_s7_time_away
    title: Reasons for time away from work
    precondition:
    - predicate: not (LFS_Q2.outcome == 2 and LFS_Q1.outcome != 7)
      hint: Asked unless the section is skipped by LFS-Q1 and LFS-Q2
    items:
    - id: LFS_Q17A
      kind: Question
      title: What was the reason that ... were/was not working for pay or profit during the most recent period away from work in the past year? (DO NOT READ LIST. MARK ONE ONLY.)
      precondition:
      - predicate: LFS_GAPS.outcome > 0 and LFS_Q6.outcome == 1
        hint: Asked only when the calendar has gaps and LFS-Q6 is 1
      input:
        control: Dropdown
        labels:
          1: 01 — OWN ILLNESS OR DISABILITY
          2: 02 — PREGNANCY
          3: 03 — CARING FOR OWN CHILDREN
          4: 04 — CARING FOR ELDER RELATIVE(S)
          5: 05 — OTHER PERSONAL OR FAMILY RESPONSIBILITIES
          6: 06 — SCHOOL OR EDUCATIONAL LEAVE
          7: 07 — LABOUR DISPUTE
          8: 08 — TEMPORARY LAYOFF DUE TO SEASONAL CONDITIONS
          9: 09 — TEMPORARY LAYOFF - NON-SEASONAL
          10: 10 — PERMANENT LAYOFF
          11: 11 — UNPAID OR PARTIALLY PAID LEAVE
          12: 12 — OTHER (SPECIFY________)
          13: 13 — NO PERIOD NOT WORKING FOR PAY OR PROFIT IN THE PAST YEAR
    - id: LFS_Q17B
      kind: Question
      title: What is the reason that ... are/is currently not working for pay or profit? (DO NOT READ LIST. MARK ONE ONLY.)
      precondition:
      - predicate: LFS_GAPS.outcome > 0 and LFS_Q6.outcome != 1
        hint: Asked only when the calendar has gaps and LFS-Q6 is not 1
      - predicate: LFS_Q17A.outcome is None or not (LFS_Q17A.outcome >= 1)
        hint: Not asked when LFS-Q17A was answered
      input:
        control: Dropdown
        labels:
          1: 01 — OWN ILLNESS OR DISABILITY
          2: 02 — PREGNANCY
          3: 03 — CARING FOR OWN CHILDREN
          4: 04 — CARING FOR ELDER RELATIVE(S)
          5: 05 — OTHER PERSONAL OR FAMILY RESPONSIBILITIES
          6: 06 — SCHOOL OR EDUCATIONAL LEAVE
          7: 07 — LABOUR DISPUTE
          8: 08 — TEMPORARY LAYOFF DUE TO SEASONAL CONDITIONS
          9: 09 — TEMPORARY LAYOFF - NON-SEASONAL
          10: 10 — PERMANENT LAYOFF
          11: 11 — UNPAID OR PARTIALLY PAID LEAVE
          12: 12 — OTHER (SPECIFY_______)
          13: 13 — NO PERIOD NOT WORKING FOR PAY OR PROFIT IN THE PAST YEAR
  - id: b_s8_sources
    title: Income sources
    items:
    - id: INCOM_Q1
      kind: Question
      title: Thinking about your total household income, from which of the following sources did your household receive any income in the past 12 months? (READ LIST. MARK ALL THAT APPLY.)
      input:
        control: Checkbox
        labels:
          1: 01 — Wages and salaries
          2: 02 — Income from self-employment
          4: 03 — Dividends and interest (e.g.on bonds,deposits,etc.)
          8: 04 — Unemployment insurance
          16: 05 — Worker's compensation
          32: 06 — Benefits from Canada or Quebec Pension Plan
          64: 07 — Retirement pensions, superannuation and annuities
          128: 08 — Old Age Security and Guaranteed Income Supplement
          256: 09 — Child Tax Benefit
          512: 10 — Provincial or municipal social assistance or welfare
          1024: 11 — Child Support
          2048: 12 — Alimony
          4096: 13 — Other (e.g. other gov't, rental income, scholarships, etc.)
          8192: 14 — None (Go to next section)
      postcondition:
      - predicate: (INCOM_Q1.outcome & 8192) == 0 or INCOM_Q1.outcome == 8192
        hint: '"None" (14) cannot be combined with other income sources in INCOM-Q1. Remove either "None" or the sources ticked.'
        invented: true
  - id: b_s8_amounts
    title: Income amounts
    precondition:
    - predicate: not (INCOM_Q1.outcome & 8192 > 0)
      hint: Asked only when the household reported at least one income source in INCOM-Q1
    items:
    - id: INCOM_Q2
      kind: Question
      title: What was the main source of income? (DO NOT READ LIST. MARK ONE ONLY.)
      precondition:
      - predicate: INCOM_Q1.outcome & (INCOM_Q1.outcome - 1) > 0
        hint: Asked only when more than one income source was reported in INCOM-Q1
      input:
        control: Dropdown
        labels:
          1: 01 — WAGES AND SALARIES
          2: 02 — INCOME FROM SELF-EMPLOYMENT
          3: 03 — DIVIDENDS AND INTEREST (E.G.ON BONDS,DEPOSITS, ETC.)
          4: 04 — UNEMPLOYMENT INSURANCE
          5: 05 — WORKER'S COMPENSATION
          6: 06 — BENEFITS FROM CANADA OR QUEBEC PENSION PLAN
          7: 07 — RETIREMENT PENSIONS, SUPERANNUATION AND ANNUITIES
          8: 08 — OLD AGE SECURITY AND GUARANTEED INCOME SUPPLEMENT
          9: 09 — CHILD TAX BENEFIT
          10: 10 — PROVINCIAL OR MUNICIPAL SOCIAL ASSISTANCE OR WELFARE
          11: 11 — CHILD SUPPORT
          12: 12 — ALIMONY
          13: 13 — OTHER (E.G. OTHER GOV'T, RENTAL INCOME, SCHOLARSHIPS, ETC.)
      postcondition:
      - predicate: (INCOM_Q2.outcome == 1 and INCOM_Q1.outcome & 1 > 0) or (INCOM_Q2.outcome == 2 and INCOM_Q1.outcome & 2 > 0) or (INCOM_Q2.outcome == 3 and INCOM_Q1.outcome & 4 > 0) or (INCOM_Q2.outcome == 4 and INCOM_Q1.outcome & 8 > 0) or (INCOM_Q2.outcome == 5 and INCOM_Q1.outcome & 16 > 0) or (INCOM_Q2.outcome == 6 and INCOM_Q1.outcome & 32 > 0) or (INCOM_Q2.outcome == 7 and INCOM_Q1.outcome & 64 > 0) or (INCOM_Q2.outcome == 8 and INCOM_Q1.outcome & 128 > 0) or (INCOM_Q2.outcome == 9 and INCOM_Q1.outcome & 256 > 0) or (INCOM_Q2.outcome == 10 and INCOM_Q1.outcome & 512 > 0) or (INCOM_Q2.outcome == 11 and INCOM_Q1.outcome & 1024 > 0) or (INCOM_Q2.outcome == 12 and INCOM_Q1.outcome & 2048 > 0) or (INCOM_Q2.outcome == 13 and INCOM_Q1.outcome & 4096 > 0)
        hint: The main source of income in INCOM-Q2 must be one of the sources reported in INCOM-Q1.
        invented: true
    - id: INCOM_Q3
      kind: Question
      title: What is your best estimate of the total income before taxes and deductions of all household members from all sources in the past 12 months? * Question was not asked in November 1994 collection. (Enter 8 for DON'T KNOW, 9 for REFUSAL.)
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
    - id: INCOM_Q3B
      kind: Question
      title: Can you estimate in which of the following groups your household income falls?
      precondition:
      - predicate: INCOM_Q3.outcome in [8, 9]
        hint: Asked only when question INCOM-Q3 is one of "DON'T KNOW", "REFUSAL".
      - predicate: not (INCOM_Q3.outcome != 8 and INCOM_Q3.outcome != 9)
      input:
        control: Dropdown
        labels:
          1: 01 — LESS THAN $20,000?
          2: 02 — LESS THAN $10,000?
          3: 03 — LESS THAN $5,000? (GO TO INCOM-Q4)
          4: 04 — $5,000 OR MORE? (GO TO INCOM-Q4)
          5: 05 — $10,000 OR MORE?
          6: 06 — LESS THAN $15,000? (GO TO INCOM-Q4)
          7: 07 — $15,000 OR MORE? (GO TO INCOM-Q4)
          8: 08 — $20,000 OR MORE?
          9: 09 — LESS THAN $40,000?
          10: 10 — LESS THAN $30,000? (GO TO INCOM-Q4)
          11: 11 — $30,000 OR MORE? (GO TO INCOM-Q4)
          12: 12 — $40,000 OR MORE?
          13: 13 — LESS THAN $50,000? (GO TO INCOM-Q4)
          14: 14 — $50,000 TO LESS THAN $60,000? (GO TO INCOM-Q4)
          15: 15 — $60,000 TO LESS THAN $80,000? (GO TO INCOM-Q4)
          16: 16 — $80,000 OR MORE? (GO TO INCOM-Q4)
          17: 17 — NO INCOME
    - id: INCOM_Q4
      kind: Question
      title: What is your best estimate of your total personal income before taxes and deductions from all sources in the past 12 months? * Question was not asked in November 1994 collection. (Enter 8 for DON'T KNOW, 9 for REFUSAL.)
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
      postcondition:
      - predicate: INCOM_Q4.outcome in [8, 9] or INCOM_Q3.outcome in [8, 9] or INCOM_Q4.outcome <= INCOM_Q3.outcome
        hint: Personal income (INCOM-Q4) cannot exceed the total household income (INCOM-Q3). Please verify both amounts.
        invented: true
    - id: INCOM_Q4B
      kind: Question
      title: Can you estimate in which of the following groups your personal income falls?
      precondition:
      - predicate: INCOM_Q4.outcome in [8, 9]
        hint: Asked only when question INCOM-Q4 is one of "DON'T KNOW", "REFUSAL".
      - predicate: not (INCOM_Q4.outcome != 8 and INCOM_Q4.outcome != 9)
      input:
        control: Dropdown
        labels:
          1: 01 — LESS THAN $20,000?
          2: 02 — LESS THAN $10,000?
          3: 03 — LESS THAN $5,000? (GO TO NEXT SECTION)
          4: 04 — $5,000 OR MORE? (GO TO NEXT SECTION)
          5: 05 — $10,000 OR MORE?
          6: 06 — LESS THAN $15,000? (GO TO NEXT SECTION)
          7: 07 — $15,000 OR MORE? (GO TO NEXT SECTION)
          8: 08 — $20,000 OR MORE?
          9: 09 — LESS THAN $40,000?
          10: 10 — LESS THAN $30,000? (GO TO NEXT SECTION)
          11: 11 — $30,000 OR MORE? (GO TO NEXT SECTION)
          12: 12 — $40,000 OR MORE?
          13: 13 — LESS THAN $50,000? (GO TO NEXT SECTION)
          14: 14 — $50,000 TO LESS THAN $60,000? (GO TO NEXT SECTION)
          15: 15 — $60,000 TO LESS THAN $80,000? (GO TO NEXT SECTION)
          16: 16 — $80,000 OR MORE? (GO TO NEXT SECTION)
          17: 17 — NO INCOME
  - id: b_s9_administration
    title: Administration
    items:
    - id: H05_P1
      kind: Question
      title: Was this interview conducted on the telephone or in person?
      input:
        control: Radio
        labels:
          1: ON TELEPHONE
          2: IN PERSON
          3: BOTH (SPECIFY REASON)
    - id: H05_P2
      kind: Question
      title: Record language of interview
      input:
        control: Dropdown
        labels:
          1: 01 ENGLISH
          2: 02 FRENCH
          3: 03 ARABIC
          4: 04 CHINESE
          5: 05 CREE
          6: 06 GERMAN
          7: 07 GREEK
          8: 08 HUNGARIAN
          9: 09 ITALIAN
          10: 10 KOREAN
          11: 11 PERSIAN (FARSI)
          12: 12 POLISH
          13: 13 PORTUGUESE
          14: 14 PUNJABI
          15: 15 SPANISH
          16: 16 TAGALOG (FILIPINO)
          17: 17 UKRAINIAN
          18: 18 VIETNAMESE
          19: 19 OTHER (SPECIFY_______________)
  - id: b_s10_preamble
    title: 'Adult health: interview setup'
    items:
    - id: CHLT_FEMBIO
      kind: Question
      title: 'External input: respondent is the female biological parent of at least 1 child in the family under 2 years of age, and this component is non-proxy (CHLT-C8)'
      external: true
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: CHLT_PMK
      kind: Question
      title: 'External input: respondent is the person most knowledgeable about the child (CHLT-C12)'
      external: true
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
  - id: b_s10_health_smoking
    title: General health and smoking
    items:
    - id: CHLT_Q1
      kind: Question
      title: 'The following questions ask about your/...''s general health and smoking habits. In general, would you say your/his/her health is:'
      input:
        control: Radio
        labels:
          1: Excellent?
          2: Very good?
          3: Good?
          4: Fair?
          5: Poor?
          8: DON'T KNOW
          9: REFUSAL
    - id: CHLT_Q2
      kind: Question
      title: At the present time do you/does ... smoke cigarettesdaily, occasionally or not at all?
      input:
        control: Radio
        labels:
          1: DAILY
          2: OCCASIONALLY
          3: NOT AT ALL
          8: DON'T KNOW
          9: REFUSAL
    - id: CHLT_Q3
      kind: Question
      title: How many cigarettes do you/does ... smoke each day now? (NUMBER OF CIGARETTES)
      precondition:
      - predicate: CHLT_Q2.outcome == 1
        hint: Asked only when question CHLT-Q2 is "DAILY".
      input:
        control: Editbox
        min: 0
        max: 99
        right: cigarettes (98 = DON'T KNOW, 99 = REFUSAL)
  - id: b_s10_alcohol
    title: Alcohol
    items:
    - id: CHLT_Q4
      kind: Question
      title: During the past 12 months, have you/has ... had a drink of beer, wine, liquor or any other alcoholic beverage?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: CHLT_Q5
      kind: Question
      title: During the past 12 months, how often did you/he/she drink alcoholic beverages? (MARK ONE ONLY.)
      precondition:
      - predicate: CHLT_Q4.outcome == 1
        hint: Asked only when question CHLT-Q4 is "YES".
      input:
        control: Dropdown
        labels:
          1: EVERY DAY
          2: 4-6 TIMES A WEEK
          3: 2-3 TIMES A WEEK
          4: ONCE A WEEK
          5: 2-3 TIMES A MONTH
          6: ONCE A MONTH
          7: LESS THAN ONCE A MONTH
          8: DON'T KNOW
          9: REFUSAL
    - id: CHLT_Q6
      kind: Question
      title: 'How many times in the past 12 months have you/has he/she had 5 or more drinks on one occasion? (NUMBER OF TIMES) NOTE: IF 0 ---> GO TO CHLT-C8'
      input:
        control: Editbox
        min: 0
        max: 366
        right: times
    - id: CHLT_Q7
      kind: Question
      title: In the past 12 months, what is the highest number of drinks you/he/she had on one occasion?
      precondition:
      - predicate: CHLT_Q6.outcome > 0
        hint: Asked only when CHLT-Q6 is greater than 0.
      postcondition:
      - predicate: CHLT_Q6.outcome == 0 or CHLT_Q7.outcome >= 5
        hint: If you had 5 or more drinks on one occasion (CHLT-Q6), the highest number of drinks on one occasion (CHLT-Q7) must be at least 5.
        invented: true
      input:
        control: Editbox
        min: 0
        max: 100
        right: drinks
  - id: b_s10_pregnancy
    title: Pregnancy history
    items:
    - id: CHLT_Q8
      kind: Question
      title: Now I would like to ask you some questions about your past pregnancies. How many times throughout your life have you been pregnant including any pregnancies which did not go full term? (TIMES)
      precondition:
      - predicate: CHLT_FEMBIO.outcome == 1
        hint: Asked only when question CHLT-FEMBIO is "Yes".
      input:
        control: Editbox
        min: 0
        max: 99
        right: times (98 = DON'T KNOW, 99 = REFUSAL)
    - id: CHLT_Q9
      kind: Question
      title: How many babies have you had?
      postcondition:
      - predicate: CHLT_Q9.outcome in [98, 99] or CHLT_Q8.outcome in [98, 99] or CHLT_Q9.outcome <= CHLT_Q8.outcome
        hint: The number of babies (CHLT-Q9) cannot exceed the number of pregnancies (CHLT-Q8).
        invented: true
      input:
        control: Editbox
        min: 0
        max: 99
        right: babies (98 = DON'T KNOW, 99 = REFUSAL)
    - id: CHLT_Q11
      kind: Question
      title: At what age did you have your first baby? (YEARS)
      input:
        control: Editbox
        min: 0
        max: 99
        right: years (98 = DON'T KNOW, 99 = REFUSAL)
  - id: b_s10_depression
    title: Depressive feelings
    items:
    - id: CHLT_Q12A
      kind: Question
      title: 'How often have you felt or behaved this way during the past week: I did not feel like eating; my appetite was poor.'
      input:
        control: Radio
        labels:
          1: RARELY OR NONE OF THE TIME (LESS THAN 1 DAY)
          2: SOME OR A LITTLE OF THE TIME (1-2 DAYS)
          3: OCCASIONALLY OR A MODERATE AMOUNT OF TIME (3-4 DAYS)
          4: MOST OR ALL OF THE TIME (5-7 DAYS)
          8: DON'T KNOW
          9: REFUSAL
    - id: CHLT_Q12B
      kind: Question
      title: I felt that I could not shake off the blues even with help from my family or friends.
      input:
        control: Radio
        labels:
          1: RARELY OR NONE OF THE TIME (LESS THAN 1 DAY)
          2: SOME OR A LITTLE OF THE TIME (1-2 DAYS)
          3: OCCASIONALLY OR A MODERATE AMOUNT OF TIME (3-4 DAYS)
          4: MOST OR ALL OF THE TIME (5-7 DAYS)
          8: DON'T KNOW
          9: REFUSAL
    - id: CHLT_Q12C
      kind: Question
      title: I had trouble keeping my mind on what I was doing.
      input:
        control: Radio
        labels:
          1: RARELY OR NONE OF THE TIME (LESS THAN 1 DAY)
          2: SOME OR A LITTLE OF THE TIME (1-2 DAYS)
          3: OCCASIONALLY OR A MODERATE AMOUNT OF TIME (3-4 DAYS)
          4: MOST OR ALL OF THE TIME (5-7 DAYS)
          8: DON'T KNOW
          9: REFUSAL
    - id: CHLT_Q12D
      kind: Question
      title: I felt depressed.
      input:
        control: Radio
        labels:
          1: RARELY OR NONE OF THE TIME (LESS THAN 1 DAY)
          2: SOME OR A LITTLE OF THE TIME (1-2 DAYS)
          3: OCCASIONALLY OR A MODERATE AMOUNT OF TIME (3-4 DAYS)
          4: MOST OR ALL OF THE TIME (5-7 DAYS)
          8: DON'T KNOW
          9: REFUSAL
    - id: CHLT_Q12E
      kind: Question
      title: I felt that everything I did was an effort.
      input:
        control: Radio
        labels:
          1: RARELY OR NONE OF THE TIME (LESS THAN 1 DAY)
          2: SOME OR A LITTLE OF THE TIME (1-2 DAYS)
          3: OCCASIONALLY OR A MODERATE AMOUNT OF TIME (3-4 DAYS)
          4: MOST OR ALL OF THE TIME (5-7 DAYS)
          8: DON'T KNOW
          9: REFUSAL
    - id: CHLT_Q12F
      kind: Question
      title: I felt hopeful about the future.
      input:
        control: Radio
        labels:
          1: RARELY OR NONE OF THE TIME (LESS THAN 1 DAY)
          2: SOME OR A LITTLE OF THE TIME (1-2 DAYS)
          3: OCCASIONALLY OR A MODERATE AMOUNT OF TIME (3-4 DAYS)
          4: MOST OR ALL OF THE TIME (5-7 DAYS)
          8: DON'T KNOW
          9: REFUSAL
    - id: CHLT_Q12G
      kind: Question
      title: My sleep was restless.
      input:
        control: Radio
        labels:
          1: RARELY OR NONE OF THE TIME (LESS THAN 1 DAY)
          2: SOME OR A LITTLE OF THE TIME (1-2 DAYS)
          3: OCCASIONALLY OR A MODERATE AMOUNT OF TIME (3-4 DAYS)
          4: MOST OR ALL OF THE TIME (5-7 DAYS)
          8: DON'T KNOW
          9: REFUSAL
    - id: CHLT_Q12H
      kind: Question
      title: I was happy.
      input:
        control: Radio
        labels:
          1: RARELY OR NONE OF THE TIME (LESS THAN 1 DAY)
          2: SOME OR A LITTLE OF THE TIME (1-2 DAYS)
          3: OCCASIONALLY OR A MODERATE AMOUNT OF TIME (3-4 DAYS)
          4: MOST OR ALL OF THE TIME (5-7 DAYS)
          8: DON'T KNOW
          9: REFUSAL
    - id: CHLT_Q12I
      kind: Question
      title: I felt lonely.
      input:
        control: Radio
        labels:
          1: RARELY OR NONE OF THE TIME (LESS THAN 1 DAY)
          2: SOME OR A LITTLE OF THE TIME (1-2 DAYS)
          3: OCCASIONALLY OR A MODERATE AMOUNT OF TIME (3-4 DAYS)
          4: MOST OR ALL OF THE TIME (5-7 DAYS)
          8: DON'T KNOW
          9: REFUSAL
    - id: CHLT_Q12J
      kind: Question
      title: I enjoyed life.
      input:
        control: Radio
        labels:
          1: RARELY OR NONE OF THE TIME (LESS THAN 1 DAY)
          2: SOME OR A LITTLE OF THE TIME (1-2 DAYS)
          3: OCCASIONALLY OR A MODERATE AMOUNT OF TIME (3-4 DAYS)
          4: MOST OR ALL OF THE TIME (5-7 DAYS)
          8: DON'T KNOW
          9: REFUSAL
    - id: CHLT_Q12K
      kind: Question
      title: I had crying spells.
      input:
        control: Radio
        labels:
          1: RARELY OR NONE OF THE TIME (LESS THAN 1 DAY)
          2: SOME OR A LITTLE OF THE TIME (1-2 DAYS)
          3: OCCASIONALLY OR A MODERATE AMOUNT OF TIME (3-4 DAYS)
          4: MOST OR ALL OF THE TIME (5-7 DAYS)
          8: DON'T KNOW
          9: REFUSAL
    - id: CHLT_Q12L
      kind: Question
      title: I felt that people disliked me.
      input:
        control: Radio
        labels:
          1: RARELY OR NONE OF THE TIME (LESS THAN 1 DAY)
          2: SOME OR A LITTLE OF THE TIME (1-2 DAYS)
          3: OCCASIONALLY OR A MODERATE AMOUNT OF TIME (3-4 DAYS)
          4: MOST OR ALL OF THE TIME (5-7 DAYS)
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s11_preamble
    title: 'Family Section: interview setup'
    items:
    - id: FNC_DONE
      kind: Question
      title: 'External input: this section has already been completed for another household member (FNC-C1)'
      external: true
      input:
        control: Radio
        labels:
          1: Already completed
          2: Not yet completed
    - id: FNC_PARTNERED
      kind: Question
      title: 'External input: person is married, living common-law or living with a partner (FNC-C2)'
      external: true
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
  - id: b_s11_family_functioning
    title: 'Family Section: family functioning'
    items:
    - id: FNC_Q1A
      kind: Question
      title: Planning family activities is difficult because we misunderstand each other.
      input:
        control: Radio
        labels:
          1: STRONGLY AGREE
          2: AGREE
          3: DISAGREE
          4: STRONGLY DISAGREE
          8: DON'T KNOW
          9: REFUSAL
    - id: FNC_Q1B
      kind: Question
      title: In times of crisis we can turn to each other for support.
      input:
        control: Radio
        labels:
          1: STRONGLY AGREE
          2: AGREE
          3: DISAGREE
          4: STRONGLY DISAGREE
          8: DON'T KNOW
          9: REFUSAL
    - id: FNC_Q1C
      kind: Question
      title: We cannot talk to each other about sadness we feel.
      input:
        control: Radio
        labels:
          1: STRONGLY AGREE
          2: AGREE
          3: DISAGREE
          4: STRONGLY DISAGREE
          8: DON'T KNOW
          9: REFUSAL
    - id: FNC_Q1D
      kind: Question
      title: Individuals (in the family) are accepted for what they are.
      input:
        control: Radio
        labels:
          1: STRONGLY AGREE
          2: AGREE
          3: DISAGREE
          4: STRONGLY DISAGREE
          8: DON'T KNOW
          9: REFUSAL
    - id: FNC_Q1E
      kind: Question
      title: We avoid discussing our fears or concerns.
      input:
        control: Radio
        labels:
          1: STRONGLY AGREE
          2: AGREE
          3: DISAGREE
          4: STRONGLY DISAGREE
          8: DON'T KNOW
          9: REFUSAL
    - id: FNC_Q1F
      kind: Question
      title: We express feelings to each other.
      input:
        control: Radio
        labels:
          1: STRONGLY AGREE
          2: AGREE
          3: DISAGREE
          4: STRONGLY DISAGREE
          8: DON'T KNOW
          9: REFUSAL
    - id: FNC_Q1G
      kind: Question
      title: There are lots of bad feelings in our family.
      input:
        control: Radio
        labels:
          1: STRONGLY AGREE
          2: AGREE
          3: DISAGREE
          4: STRONGLY DISAGREE
          8: DON'T KNOW
          9: REFUSAL
    - id: FNC_Q1H
      kind: Question
      title: We feel accepted for what we are.
      input:
        control: Radio
        labels:
          1: STRONGLY AGREE
          2: AGREE
          3: DISAGREE
          4: STRONGLY DISAGREE
          8: DON'T KNOW
          9: REFUSAL
    - id: FNC_Q1I
      kind: Question
      title: Making decisions is a problem for our family.
      input:
        control: Radio
        labels:
          1: STRONGLY AGREE
          2: AGREE
          3: DISAGREE
          4: STRONGLY DISAGREE
          8: DON'T KNOW
          9: REFUSAL
    - id: FNC_Q1J
      kind: Question
      title: We are able to make decisions about how to solve problems.
      input:
        control: Radio
        labels:
          1: STRONGLY AGREE
          2: AGREE
          3: DISAGREE
          4: STRONGLY DISAGREE
          8: DON'T KNOW
          9: REFUSAL
    - id: FNC_Q1K
      kind: Question
      title: We don't get along well together.
      input:
        control: Radio
        labels:
          1: STRONGLY AGREE
          2: AGREE
          3: DISAGREE
          4: STRONGLY DISAGREE
          8: DON'T KNOW
          9: REFUSAL
    - id: FNC_Q1L
      kind: Question
      title: We confide in each other.
      input:
        control: Radio
        labels:
          1: STRONGLY AGREE
          2: AGREE
          3: DISAGREE
          4: STRONGLY DISAGREE
          8: DON'T KNOW
          9: REFUSAL
    - id: FNC_Q1M
      kind: Question
      title: Drinking is a source of tension or disagreement in our family.
      input:
        control: Radio
        labels:
          1: STRONGLY AGREE
          2: AGREE
          3: DISAGREE
          4: STRONGLY DISAGREE
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s11_relationship
    title: 'Family Section: relationship satisfaction'
    items:
    - id: FNC_Q2
      kind: Question
      title: All things considered, how satisfied or dissatisfied are you with your marriage or relationship with your partner? Which number comes the closest to how you feel, where 1 is completely dissatisfied and 11 is completely satisfied?
      precondition:
      - predicate: FNC_PARTNERED.outcome == 1
        hint: Asked only when question FNC-PARTNERED is "Yes".
      input:
        control: Dropdown
        labels:
          1: 01 COMPLETELY DISSATISFIED
          2: '02'
          3: '03'
          4: '04'
          5: '05'
          6: 06 NEUTRAL
          7: '07'
          8: 08
          9: 09
          10: '10'
          11: 11 COMPLETELY SATISFIED
          98: DON'T KNOW
          99: REFUSAL
  - id: b_s12_preamble
    title: 'Neighbourhood: setup'
    items:
    - id: SAF_DONE
      kind: Question
      title: 'External input: this section has already been completed for another household member (SAF-C1)'
      external: true
      input:
        control: Radio
        labels:
          1: Already completed
          2: Not yet completed
  - id: b_s12_residence
    title: 'Neighbourhood: residence and quality'
    items:
    - id: SAF_Q1
      kind: Question
      title: This section asks questions about your neighbourhood. How many years have you lived at this address? (ENTER 0 IF LESS THAN 1 YEAR.) (YEARS)
      input:
        control: Editbox
        min: 0
        max: 120
        right: years
    - id: SAF_Q2
      kind: Question
      title: How do you feel about your neighbourhood as a place to bring up children? Is it... (READ LIST. MARK ONE ONLY.)
      input:
        control: Radio
        labels:
          1: Excellent?
          2: Good?
          3: Average?
          4: Poor?
          5: Very poor?
          8: DON'T KNOW
          9: REFUSAL
    - id: SAF_Q3
      kind: Question
      title: Are you involved in any local voluntary organizations such as school groups, church groups, community or ethnic associations?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s12_safety
    title: 'Neighbourhood: safety'
    items:
    - id: SAF_Q5A
      kind: Question
      title: It is safe to walk alone in this neighbourhood after dark.
      input:
        control: Radio
        labels:
          1: STRONGLY AGREE
          2: AGREE
          3: DISAGREE
          4: STRONGLY DISAGREE
          8: DON'T KNOW
          9: REFUSAL
    - id: SAF_Q5B
      kind: Question
      title: It is safe for children to play outside during the day.
      input:
        control: Radio
        labels:
          1: STRONGLY AGREE
          2: AGREE
          3: DISAGREE
          4: STRONGLY DISAGREE
          8: DON'T KNOW
          9: REFUSAL
    - id: SAF_Q5C
      kind: Question
      title: There are good parks, playgrounds and play spaces in this neighbourhood.
      input:
        control: Radio
        labels:
          1: STRONGLY AGREE
          2: AGREE
          3: DISAGREE
          4: STRONGLY DISAGREE
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s12_cohesion
    title: 'Neighbourhood: cohesion'
    items:
    - id: SAF_Q6A
      kind: Question
      title: Please tell me whether you strongly agree, agree, disagree, or strongly disagree about the following statement when thinking of your neighbours. If there is a problem around here, the neighbours get together to deal with it.
      input:
        control: Radio
        labels:
          1: STRONGLY AGREE
          2: AGREE
          3: DISAGREE
          4: STRONGLY DISAGREE
          8: DON'T KNOW
          9: REFUSAL
    - id: SAF_Q6B
      kind: Question
      title: There are adults in the neighbourhood that children can look up to.
      input:
        control: Radio
        labels:
          1: STRONGLY AGREE
          2: AGREE
          3: DISAGREE
          4: STRONGLY DISAGREE
          8: DON'T KNOW
          9: REFUSAL
    - id: SAF_Q6C
      kind: Question
      title: People around here are willing to help their neighbours.
      input:
        control: Radio
        labels:
          1: STRONGLY AGREE
          2: AGREE
          3: DISAGREE
          4: STRONGLY DISAGREE
          8: DON'T KNOW
          9: REFUSAL
    - id: SAF_Q6D
      kind: Question
      title: You can count on adults in this neighbourhood to watch out that children are safe and don't get in trouble.
      input:
        control: Radio
        labels:
          1: STRONGLY AGREE
          2: AGREE
          3: DISAGREE
          4: STRONGLY DISAGREE
          8: DON'T KNOW
          9: REFUSAL
    - id: SAF_Q6E
      kind: Question
      title: When I'm away from home, I know that my neighbours will keep their eyes open for possible trouble.
      input:
        control: Radio
        labels:
          1: STRONGLY AGREE
          2: AGREE
          3: DISAGREE
          4: STRONGLY DISAGREE
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s12_problems
    title: 'Neighbourhood: problems'
    items:
    - id: SAF_Q7A
      kind: Question
      title: 'How much of a problem is the following in this neighbourhood: Litter, broken glass or garbage in the street or road, on the sidewalk, or in yards?'
      input:
        control: Radio
        labels:
          1: A BIG PROBLEM
          2: SOMEWHAT OF A PROBLEM
          3: NO PROBLEM
          8: DON'T KNOW
          9: REFUSAL
    - id: SAF_Q7B
      kind: Question
      title: Selling or using drugs?
      input:
        control: Radio
        labels:
          1: A BIG PROBLEM
          2: SOMEWHAT OF A PROBLEM
          3: NO PROBLEM
          8: DON'T KNOW
          9: REFUSAL
    - id: SAF_Q7C
      kind: Question
      title: Alcoholics and excessive drinking in public?
      input:
        control: Radio
        labels:
          1: A BIG PROBLEM
          2: SOMEWHAT OF A PROBLEM
          3: NO PROBLEM
          8: DON'T KNOW
          9: REFUSAL
    - id: SAF_Q7D
      kind: Question
      title: Groups of young people who cause trouble?
      input:
        control: Radio
        labels:
          1: A BIG PROBLEM
          2: SOMEWHAT OF A PROBLEM
          3: NO PROBLEM
          8: DON'T KNOW
          9: REFUSAL
    - id: SAF_Q7E
      kind: Question
      title: Burglary of homes and apartments?
      input:
        control: Radio
        labels:
          1: A BIG PROBLEM
          2: SOMEWHAT OF A PROBLEM
          3: NO PROBLEM
          8: DON'T KNOW
          9: REFUSAL
    - id: SAF_Q7F
      kind: Question
      title: Unrest due to ethnic or religious differences?
      input:
        control: Radio
        labels:
          1: A BIG PROBLEM
          2: SOMEWHAT OF A PROBLEM
          3: NO PROBLEM
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s13_preamble
    title: 'Social support: setup'
    items:
    - id: SUP_DONE
      kind: Question
      title: 'External input: this section has already been completed for another household member (SUP-C1)'
      external: true
      input:
        control: Radio
        labels:
          1: Already completed
          2: Not yet completed
  - id: b_s13_first
    title: 'Social support: first statement'
    items:
    - id: SUP_Q1A
      kind: Question
      title: If something went wrong, no one would help me.
      input:
        control: Radio
        labels:
          1: STRONGLY DISAGREE
          2: DISAGREE
          3: AGREE
          4: STRONGLY AGREE
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s13_statements
    title: 'Social support: statements'
    precondition:
    - predicate: not (SUP_Q1A.outcome == 9)
      hint: Asked only when question SUP-Q1A is not "REFUSAL".
    items:
    - id: SUP_Q1B
      kind: Question
      title: I have family and friends who help me feel safe, secure and happy.
      input:
        control: Radio
        labels:
          1: STRONGLY DISAGREE
          2: DISAGREE
          3: AGREE
          4: STRONGLY AGREE
          8: DON'T KNOW
          9: REFUSAL
    - id: SUP_Q1C
      kind: Question
      title: There is someone I trust whom I would turn to for advice if I were having problems.
      input:
        control: Radio
        labels:
          1: STRONGLY DISAGREE
          2: DISAGREE
          3: AGREE
          4: STRONGLY AGREE
          8: DON'T KNOW
          9: REFUSAL
    - id: SUP_Q1D
      kind: Question
      title: There is no one I feel comfortable talking about problems with.
      input:
        control: Radio
        labels:
          1: STRONGLY DISAGREE
          2: DISAGREE
          3: AGREE
          4: STRONGLY AGREE
          8: DON'T KNOW
          9: REFUSAL
    - id: SUP_Q1E
      kind: Question
      title: I lack a feeling of closeness with another person.
      input:
        control: Radio
        labels:
          1: STRONGLY DISAGREE
          2: DISAGREE
          3: AGREE
          4: STRONGLY AGREE
          8: DON'T KNOW
          9: REFUSAL
    - id: SUP_Q1F
      kind: Question
      title: There are people I can count on in an emergency.
      input:
        control: Radio
        labels:
          1: STRONGLY DISAGREE
          2: DISAGREE
          3: AGREE
          4: STRONGLY AGREE
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s13_outside_help
    title: 'Social support: outside help'
    items:
    - id: SUP_Q2A
      kind: Question
      title: Besides your friends and family, did any of the following help with your personal problems during the past 12 months? Community or social service professionals?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: SUP_Q2B
      kind: Question
      title: Health professionals?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: SUP_Q2C
      kind: Question
      title: Religious or spiritual leaders or communities?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: SUP_Q2D
      kind: Question
      title: Books or magazines?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s14_relationships
    title: CHILDREN'S QUESTIONNAIRE — Relationships confirmation
    items:
    - id: DVS_Q1
      kind: Question
      title: What is your relationship to ......?
      input:
        control: Radio
        labels:
          1: BIRTH PARENT
          2: STEP PARENT (INCLUDING COMMON-LAW PARENT)
          3: ADOPTIVE PARENT
          4: FOSTER PARENT
          5: SISTER/BROTHER
          6: GRANDPARENT
          7: IN-LAW
          8: OTHER RELATED
          9: UNRELATED
    - id: DVS_Q2
      kind: Question
      title: What is .....'s relationship to ...........? (first child)
      input:
        control: Radio
        labels:
          1: FULL SISTER/BROTHER BY BIRTH
          2: SISTER/BROTHER - HALF, STEP, ADOPTED, FOSTER (INCLUDE COMMON-LAW SIBLINGS)
          3: OTHER RELATED
          4: UNRELATED
  - id: b_s15_preamble
    title: Health setup
    items:
    - id: AGE_2
      kind: Question
      title: 'External input: age in years of the selected child (from the household roster); used by the age routing in HEALTH (AGE 0-1, 2-3, 4-5, 6-11 years)'
      external: true
      input:
        control: Editbox
        min: 0
        max: 11
  - id: b_s15_general
    title: General health
    items:
    - id: HLT_Q1
      kind: Question
      title: 'In general, would you say ...''s health is:'
      input:
        control: Radio
        labels:
          1: Excellent?
          2: Very good?
          3: Good?
          4: Fair?
          5: Poor?
          8: DON'T KNOW
          9: REFUSAL
    - id: HLT_Q2
      kind: Question
      title: Over the past few months, how often has he/she been in good health?
      precondition:
      - predicate: not (HLT_Q1.outcome in [8, 9])
        hint: Asked only when question HLT-Q1 is none of "DON'T KNOW", "REFUSAL".
      input:
        control: Radio
        labels:
          1: ALMOST ALL THE TIME
          2: OFTEN
          3: ABOUT HALF OF THE TIME
          4: SOMETIMES
          5: ALMOST NEVER
          8: DON'T KNOW
    - id: HLT_Q3
      kind: Question
      title: What is his/her height in feet and inches or in metres/centimetres (without shoes on)?
      input:
        control: Textarea
    - id: HLT_Q4
      kind: Question
      title: What is his/her weight in kilograms (and grams) or in pounds (and ounces)?
      input:
        control: Textarea
  - id: b_s15_activity
    title: Physical activity
    precondition:
    - predicate: AGE_2.outcome >= 2
      hint: Asked only of children aged 2 or older.
    items:
    - id: HLT_Q5
      kind: Question
      title: In your opinion, how physically active is ... compared to other children the same age and sex? (READ LIST. MARK ONE ONLY.)
      input:
        control: Radio
        labels:
          1: Much more?
          2: Moderately more?
          3: Equally?
          4: Moderately less?
          5: Much less?
  - id: b_s15_vision_6plus
    title: Vision, newsprint
    precondition:
    - predicate: AGE_2.outcome >= 6
      hint: Asked only of children aged 6 or older.
    items:
    - id: HLT_Q6
      kind: Question
      title: Is he/she usually able to see well enough to read ordinary newsprint without glasses or contact lenses?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: HLT_Q7
      kind: Question
      title: Is he/she usually able to see well enough to read ordinary newsprint with glasses or contact lenses?
      precondition:
      - predicate: not (HLT_Q6.outcome == 1)
        hint: Asked only when question HLT-Q6 is not "YES".
      - predicate: not (HLT_Q6.outcome == 9)
        hint: Asked only when question HLT-Q6 is not "REFUSAL".
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          3: DOESN'T WEAR GLASSES OR CONTACT LENSES
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s15_vision_4to5
    title: Vision, story book
    precondition:
    - predicate: AGE_2.outcome >= 4 and AGE_2.outcome <= 5
      hint: Asked only of children aged 4 to 5.
    - predicate: not (HLT_Q6.outcome == 1)
      hint: Asked only when question HLT-Q6 is not "YES".
    - predicate: not (HLT_Q6.outcome == 9)
      hint: Asked only when question HLT-Q6 is not "REFUSAL".
    - predicate: not (HLT_Q7.outcome == 1)
      hint: Asked only when question HLT-Q7 is not "YES".
    - predicate: not (HLT_Q7.outcome in [2, 3, 8])
      hint: Asked only when question HLT-Q7 is none of "NO", "DOESN'T WEAR GLASSES OR CONTACT LENSES", "DON'T KNOW".
    - predicate: not (HLT_Q7.outcome == 9)
      hint: Asked only when question HLT-Q7 is not "REFUSAL".
    items:
    - id: HLT_Q6A
      kind: Question
      title: Is he/she usually able to see clearly, and without distortion, the words in a story book without glasses or contact lenses?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: HLT_Q7A
      kind: Question
      title: Is he/she usually able to see clearly, and without distortion, the words in a story book with glasses or contact lenses?
      precondition:
      - predicate: not (HLT_Q6A.outcome == 1)
        hint: Asked only when question HLT-Q6A is not "YES".
      - predicate: not (HLT_Q6A.outcome == 9)
        hint: Asked only when question HLT-Q6A is not "REFUSAL".
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          3: DOESN'T WEAR GLASSES OR CONTACT LENSES
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s15_vision_see_at_all
    title: Vision, seeing at all
    precondition:
    - predicate: AGE_2.outcome >= 4
      hint: Asked only of children aged 4 or older.
    items:
    - id: HLT_Q8
      kind: Question
      title: Is he/she able to see at all?
      precondition:
      - predicate: not (HLT_Q6.outcome == 1)
        hint: Asked only when question HLT-Q6 is not "YES".
      - predicate: not (HLT_Q6.outcome == 9)
        hint: Asked only when question HLT-Q6 is not "REFUSAL".
      - predicate: not (HLT_Q7.outcome == 1)
        hint: Asked only when question HLT-Q7 is not "YES".
      - predicate: not (HLT_Q7.outcome == 9)
        hint: Asked only when question HLT-Q7 is not "REFUSAL".
      - predicate: not (HLT_Q6A.outcome == 1)
        hint: Asked only when question HLT-Q6A is not "YES".
      - predicate: not (HLT_Q6A.outcome == 9)
        hint: Asked only when question HLT-Q6A is not "REFUSAL".
      - predicate: not (HLT_Q7A.outcome == 1)
        hint: Asked only when question HLT-Q7A is not "YES".
      - predicate: not (HLT_Q7A.outcome == 9)
        hint: Asked only when question HLT-Q7A is not "REFUSAL".
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s15_vision_street
    title: Vision, recognizing a friend
    precondition:
    - predicate: AGE_2.outcome >= 4
      hint: Asked only of children aged 4 or older.
    - predicate: not (HLT_Q6.outcome == 9)
      hint: Asked only when question HLT-Q6 is not "REFUSAL".
    - predicate: not (HLT_Q7.outcome == 9)
      hint: Asked only when question HLT-Q7 is not "REFUSAL".
    - predicate: not (HLT_Q6A.outcome == 9)
      hint: Asked only when question HLT-Q6A is not "REFUSAL".
    - predicate: not (HLT_Q7A.outcome == 9)
      hint: Asked only when question HLT-Q7A is not "REFUSAL".
    - predicate: not (HLT_Q8.outcome in [2, 8, 9])
      hint: Asked only when question HLT-Q8 is none of "NO", "DON'T KNOW", "REFUSAL".
    items:
    - id: HLT_Q9
      kind: Question
      title: Is he/she able to see well enough to recognize a friend on the other side of the street without glasses or contact lenses?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: HLT_Q10
      kind: Question
      title: Is he/she usually able to see well enough to recognize a friend on the other side of the street with glasses or contact lenses?
      precondition:
      - predicate: not (HLT_Q9.outcome in [1, 9])
        hint: Asked only when question HLT-Q9 is none of "YES", "REFUSAL".
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          3: DOESN'T WEAR GLASSES OR CONTACTS
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s15_hearing
    title: Hearing
    precondition:
    - predicate: AGE_2.outcome >= 4
      hint: Asked only of children aged 4 or older.
    items:
    - id: HLT_Q11
      kind: Question
      title: Is ... usually able to hear what is said in a group conversation with at least three other people without a hearing aid?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: HLT_Q12
      kind: Question
      title: Is he/she usually able to hear what is said in a group conversation with at least three other people with a hearing aid?
      precondition:
      - predicate: not (HLT_Q11.outcome in [1, 9])
        hint: Asked only when question HLT-Q11 is none of "YES", "REFUSAL".
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          3: DOESN'T WEAR A HEARING AID
          8: DON'T KNOW
          9: REFUSAL
    - id: HLT_Q13
      kind: Question
      title: Is he/she able to hear at all?
      precondition:
      - predicate: not (HLT_Q11.outcome in [1, 9])
        hint: Asked only when question HLT-Q11 is none of "YES", "REFUSAL".
      - predicate: not (HLT_Q12.outcome == 1)
        hint: Asked only when question HLT-Q12 is not "YES".
      - predicate: not (HLT_Q12.outcome == 9)
        hint: Asked only when question HLT-Q12 is not "REFUSAL".
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: HLT_Q14
      kind: Question
      title: Is he/she usually able to hear what is said in a conversation with one other person in a quiet room without a hearing aid?
      precondition:
      - predicate: not (HLT_Q11.outcome in [1, 9])
        hint: Asked only when question HLT-Q11 is none of "YES", "REFUSAL".
      - predicate: not (HLT_Q12.outcome == 9)
        hint: Asked only when question HLT-Q12 is not "REFUSAL".
      - predicate: not (HLT_Q13.outcome in [2, 8, 9])
        hint: Asked only when question HLT-Q13 is none of "NO", "DON'T KNOW", "REFUSAL".
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s16_hearing_aid
    title: HEARING (continued from previous part)
    precondition:
    - predicate: not (HLT_Q11.outcome in [1, 9])
      hint: Asked only when question HLT-Q11 is none of "YES", "REFUSAL".
    - predicate: not (HLT_Q12.outcome == 9)
      hint: Asked only when question HLT-Q12 is not "REFUSAL".
    - predicate: not (HLT_Q13.outcome in [2, 8, 9])
      hint: Asked only when question HLT-Q13 is none of "NO", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q14.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q14 is none of "YES", "DON'T KNOW", "REFUSAL".
    items:
    - id: HLT_Q15
      kind: Question
      title: Is he/she usually able to hear what is said in a conversation with one other person in a quiet room with a hearing aid?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          3: DOESN'T WEAR A HEARING AID
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s17_speech
    title: SPEECH
    items:
    - id: HLT_Q16
      kind: Question
      title: Is ... usually able to be understood completely when speaking with strangers in his/her own language?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: HLT_Q17
      kind: Question
      title: Is he/she able to be understood partially when speaking with strangers in his/her own language?
      precondition:
      - predicate: not (HLT_Q16.outcome == 8)
        hint: Asked only when question HLT-Q16 is not "DON'T KNOW".
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: HLT_Q18
      kind: Question
      title: Is he/she able to be understood completely when speaking with those who know him/her well?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: HLT_Q19
      kind: Question
      title: Is he/she able to be understood partially when speaking with those who know him/her well?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s18_getting_around
    title: GETTING AROUND
    items:
    - id: HLT_Q20
      kind: Question
      title: Is ... usually able to walk around the neighbourhood without difficulty and without mechanical support such as braces, a cane or crutches?
      precondition:
      - predicate: AGE_2.outcome >= 6
        hint: Asked only when the child is 6 or older
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: HLT_Q20A
      kind: Question
      title: Is he/she usually able to walk without difficulty and without mechanical support such as braces, a cane or crutches?
      precondition:
      - predicate: AGE_2.outcome < 6
        hint: Asked only when the child is under 6
      - predicate: not (HLT_Q20.outcome in [1, 9])
        hint: Asked only when question HLT-Q20 is none of "YES", "REFUSAL".
      - predicate: not (HLT_Q20.outcome in [2, 8])
        hint: Asked only when question HLT-Q20 is none of "NO", "DON'T KNOW".
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: HLT_Q21
      kind: Question
      title: Is he/she able to walk at all?
      precondition:
      - predicate: not (HLT_Q20.outcome in [1, 9])
        hint: Asked only when question HLT-Q20 is none of "YES", "REFUSAL".
      - predicate: not (HLT_Q20A.outcome in [1, 9])
        hint: Asked only when question HLT-Q20A is none of "YES", "REFUSAL".
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: HLT_Q22
      kind: Question
      title: Does he/she require mechanical support such as braces, a cane or crutches to be able to walk around the neighbourhood?
      precondition:
      - predicate: AGE_2.outcome >= 6
        hint: Asked only when the child is 6 or older
      - predicate: not (HLT_Q20.outcome in [1, 9])
        hint: Asked only when question HLT-Q20 is none of "YES", "REFUSAL".
      - predicate: not (HLT_Q20A.outcome in [1, 9])
        hint: Asked only when question HLT-Q20A is none of "YES", "REFUSAL".
      - predicate: not (HLT_Q21.outcome in [2, 8])
        hint: Asked only when question HLT-Q21 is none of "NO", "DON'T KNOW".
      - predicate: not (HLT_Q21.outcome == 9)
        hint: Asked only when question HLT-Q21 is not "REFUSAL".
      - predicate: not (HLT_Q21.outcome == 1 and AGE_2.outcome < 6)
        hint: Not asked when the child is under 6 and able to walk at all
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: HLT_Q22A
      kind: Question
      title: Does he/she require mechanical support such as braces, a cane or crutches to be able to walk?
      precondition:
      - predicate: AGE_2.outcome < 6
        hint: Asked only when the child is under 6
      - predicate: not (HLT_Q20.outcome in [1, 9])
        hint: Asked only when question HLT-Q20 is none of "YES", "REFUSAL".
      - predicate: not (HLT_Q20A.outcome in [1, 9])
        hint: Asked only when question HLT-Q20A is none of "YES", "REFUSAL".
      - predicate: not (HLT_Q21.outcome in [2, 8])
        hint: Asked only when question HLT-Q21 is none of "NO", "DON'T KNOW".
      - predicate: not (HLT_Q21.outcome == 9)
        hint: Asked only when question HLT-Q21 is not "REFUSAL".
      - predicate: not (HLT_Q22.outcome in [1, 2, 8])
        hint: Asked only when question HLT-Q22 is none of "YES", "NO", "DON'T KNOW".
      - predicate: not (HLT_Q22.outcome == 9)
        hint: Asked only when question HLT-Q22 is not "REFUSAL".
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: HLT_Q23
      kind: Question
      title: Does he/she require the help of another person to be able to walk?
      precondition:
      - predicate: not (HLT_Q20.outcome in [1, 9])
        hint: Asked only when question HLT-Q20 is none of "YES", "REFUSAL".
      - predicate: not (HLT_Q20A.outcome in [1, 9])
        hint: Asked only when question HLT-Q20A is none of "YES", "REFUSAL".
      - predicate: not (HLT_Q21.outcome in [2, 8])
        hint: Asked only when question HLT-Q21 is none of "NO", "DON'T KNOW".
      - predicate: not (HLT_Q21.outcome == 9)
        hint: Asked only when question HLT-Q21 is not "REFUSAL".
      - predicate: not (HLT_Q22.outcome == 9)
        hint: Asked only when question HLT-Q22 is not "REFUSAL".
      - predicate: not (HLT_Q22A.outcome == 9)
        hint: Asked only when question HLT-Q22A is not "REFUSAL".
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: HLT_Q24
      kind: Question
      title: Does he/she require a wheelchair to get around?
      precondition:
      - predicate: not (HLT_Q20.outcome in [1, 9])
        hint: Asked only when question HLT-Q20 is none of "YES", "REFUSAL".
      - predicate: not (HLT_Q20A.outcome in [1, 9])
        hint: Asked only when question HLT-Q20A is none of "YES", "REFUSAL".
      - predicate: not (HLT_Q21.outcome == 9)
        hint: Asked only when question HLT-Q21 is not "REFUSAL".
      - predicate: not (HLT_Q22.outcome == 9)
        hint: Asked only when question HLT-Q22 is not "REFUSAL".
      - predicate: not (HLT_Q22A.outcome == 9)
        hint: Asked only when question HLT-Q22A is not "REFUSAL".
      - predicate: not (HLT_Q23.outcome == 9)
        hint: Asked only when question HLT-Q23 is not "REFUSAL".
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: HLT_Q25
      kind: Question
      title: How often does he/she use a wheelchair?
      precondition:
      - predicate: not (HLT_Q20.outcome in [1, 9])
        hint: Asked only when question HLT-Q20 is none of "YES", "REFUSAL".
      - predicate: not (HLT_Q20A.outcome in [1, 9])
        hint: Asked only when question HLT-Q20A is none of "YES", "REFUSAL".
      - predicate: not (HLT_Q21.outcome == 9)
        hint: Asked only when question HLT-Q21 is not "REFUSAL".
      - predicate: not (HLT_Q22.outcome == 9)
        hint: Asked only when question HLT-Q22 is not "REFUSAL".
      - predicate: not (HLT_Q22A.outcome == 9)
        hint: Asked only when question HLT-Q22A is not "REFUSAL".
      - predicate: not (HLT_Q23.outcome == 9)
        hint: Asked only when question HLT-Q23 is not "REFUSAL".
      - predicate: not (HLT_Q24.outcome in [2, 8, 9])
        hint: Asked only when question HLT-Q24 is none of "NO", "DON'T KNOW", "REFUSAL".
      input:
        control: Radio
        labels:
          1: ALWAYS
          2: OFTEN
          3: SOMETIMES
          4: NEVER
          8: DON'T KNOW
          9: REFUSAL
    - id: HLT_Q26
      kind: Question
      title: Does he/she need the help of another person to get around in the wheelchair?
      precondition:
      - predicate: not (HLT_Q20.outcome in [1, 9])
        hint: Asked only when question HLT-Q20 is none of "YES", "REFUSAL".
      - predicate: not (HLT_Q20A.outcome in [1, 9])
        hint: Asked only when question HLT-Q20A is none of "YES", "REFUSAL".
      - predicate: not (HLT_Q21.outcome == 9)
        hint: Asked only when question HLT-Q21 is not "REFUSAL".
      - predicate: not (HLT_Q22.outcome == 9)
        hint: Asked only when question HLT-Q22 is not "REFUSAL".
      - predicate: not (HLT_Q22A.outcome == 9)
        hint: Asked only when question HLT-Q22A is not "REFUSAL".
      - predicate: not (HLT_Q23.outcome == 9)
        hint: Asked only when question HLT-Q23 is not "REFUSAL".
      - predicate: not (HLT_Q24.outcome in [2, 8, 9])
        hint: Asked only when question HLT-Q24 is none of "NO", "DON'T KNOW", "REFUSAL".
      - predicate: not (HLT_Q25.outcome == 9)
        hint: Asked only when question HLT-Q25 is not "REFUSAL".
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s19_grasp
    title: HANDS AND FINGERS
    items:
    - id: HLT_Q27
      kind: Question
      title: Is ... usually able to grasp and handle small objects such as a pencil or scissors?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s19_help
    title: Help or equipment needed for hands and fingers
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    items:
    - id: HLT_Q28
      kind: Question
      title: Does he/she require the help of another person because of limitations in the use of hands or fingers?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: HLT_Q29
      kind: Question
      title: 'Does he/she require the help of another person with: (READ LIST. MARK ONE ONLY.)'
      precondition:
      - predicate: not (HLT_Q28.outcome in [2, 8])
        hint: Asked only when question HLT-Q28 is none of "NO", "DON'T KNOW".
      - predicate: not (HLT_Q28.outcome == 9)
        hint: Asked only when question HLT-Q28 is not "REFUSAL".
      input:
        control: Radio
        labels:
          1: Some tasks?
          2: Most tasks?
          3: Almost all tasks?
          4: All tasks?
          8: DON'T KNOW
          9: REFUSAL
    - id: HLT_Q30
      kind: Question
      title: Does he/she require special equipment, for example, devices to assist in dressing because of limitations in the use of hands or fingers?
      precondition:
      - predicate: not (HLT_Q28.outcome == 9)
        hint: Asked only when question HLT-Q28 is not "REFUSAL".
      - predicate: not (HLT_Q29.outcome == 9)
        hint: Asked only when question HLT-Q29 is not "REFUSAL".
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s20_discipline
    title: 'Parenting: discipline'
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    items:
    - id: PAR_Q10
      kind: Question
      title: When you give him/her a command or order to do something, what proportion of the time do you make sure that he/she does it?
      input:
        control: Radio
        labels:
          1: ALWAYS
          2: OFTEN
          3: SOMETIMES
          4: RARELY
          5: NEVER
          8: DON'T KNOW
          9: REFUSAL
    - id: PAR_Q11
      kind: Question
      title: If you tell him/her he/she will get punished if he/she doesn't stop doing something, and he/she keeps doing it, how often will you punish him/her?
      input:
        control: Radio
        labels:
          1: ALWAYS
          2: OFTEN
          3: SOMETIMES
          4: RARELY
          5: NEVER
          8: DON'T KNOW
          9: REFUSAL
    - id: PAR_Q12
      kind: Question
      title: How often does he/she get away with things that you feel should have been punished?
      input:
        control: Radio
        labels:
          1: ALWAYS
          2: OFTEN
          3: SOMETIMES
          4: RARELY
          5: NEVER
          8: DON'T KNOW
          9: REFUSAL
    - id: PAR_Q13
      kind: Question
      title: How often do you get angry when you punish ...?
      input:
        control: Radio
        labels:
          1: ALWAYS
          2: OFTEN
          3: SOMETIMES
          4: RARELY
          5: NEVER
          8: DON'T KNOW
          9: REFUSAL
    - id: PAR_Q14
      kind: Question
      title: How often do you think that the kind of punishment you give him/her depends on your mood?
      input:
        control: Radio
        labels:
          1: ALWAYS
          2: OFTEN
          3: SOMETIMES
          4: RARELY
          5: NEVER
          8: DON'T KNOW
          9: REFUSAL
    - id: PAR_Q15
      kind: Question
      title: How often do you feel you are having problems managing him/her in general?
      input:
        control: Radio
        labels:
          1: ALWAYS
          2: OFTEN
          3: SOMETIMES
          4: RARELY
          5: NEVER
          8: DON'T KNOW
          9: REFUSAL
    - id: PAR_Q16
      kind: Question
      title: How often is he/she able to get out of a punishment when he/she really sets his/her mind to it?
      input:
        control: Radio
        labels:
          1: ALWAYS
          2: OFTEN
          3: SOMETIMES
          4: RARELY
          5: NEVER
          8: DON'T KNOW
          9: REFUSAL
    - id: PAR_Q17
      kind: Question
      title: How often when you discipline him/her, does he/she ignore the punishment?
      input:
        control: Radio
        labels:
          1: ALWAYS
          2: OFTEN
          3: SOMETIMES
          4: RARELY
          5: NEVER
          8: DON'T KNOW
          9: REFUSAL
    - id: PAR_Q18
      kind: Question
      title: How often do you have to discipline him/her repeatedly for the same thing?
      input:
        control: Radio
        labels:
          1: ALWAYS
          2: OFTEN
          3: SOMETIMES
          4: RARELY
          5: NEVER
          8: DON'T KNOW
          9: REFUSAL
    - id: PAR_Q19
      kind: Question
      title: 'How often do you: Tell him/her to stop?'
      input:
        control: Radio
        labels:
          1: ALWAYS
          2: OFTEN
          3: SOMETIMES
          4: RARELY
          5: NEVER
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s20_responses
    title: 'Parenting: responses, food insecurity and violence'
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    - predicate: not (PAR_Q19.outcome == 9)
      hint: Asked only when question PAR-Q19 is not "REFUSAL".
    items:
    - id: PAR_Q20
      kind: Question
      title: Ignore it, do nothing?
      input:
        control: Radio
        labels:
          1: ALWAYS
          2: OFTEN
          3: SOMETIMES
          4: RARELY
          5: NEVER
          8: DON'T KNOW
          9: REFUSAL
    - id: PAR_Q21
      kind: Question
      title: Raise your voice, scold or yell at him/her?
      input:
        control: Radio
        labels:
          1: ALWAYS
          2: OFTEN
          3: SOMETIMES
          4: RARELY
          5: NEVER
          8: DON'T KNOW
          9: REFUSAL
    - id: PAR_Q22
      kind: Question
      title: Calmly discuss the problem?
      input:
        control: Radio
        labels:
          1: ALWAYS
          2: OFTEN
          3: SOMETIMES
          4: RARELY
          5: NEVER
          8: DON'T KNOW
          9: REFUSAL
    - id: PAR_Q23
      kind: Question
      title: Use physical punishment?
      input:
        control: Radio
        labels:
          1: ALWAYS
          2: OFTEN
          3: SOMETIMES
          4: RARELY
          5: NEVER
          8: DON'T KNOW
          9: REFUSAL
    - id: PAR_Q24
      kind: Question
      title: Describe alternative ways of behaving that are acceptable?
      input:
        control: Radio
        labels:
          1: ALWAYS
          2: OFTEN
          3: SOMETIMES
          4: RARELY
          5: NEVER
          8: DON'T KNOW
          9: REFUSAL
    - id: PAR_Q25
      kind: Question
      title: Take away privileges or put in room?
      input:
        control: Radio
        labels:
          1: ALWAYS
          2: OFTEN
          3: SOMETIMES
          4: RARELY
          5: NEVER
          8: DON'T KNOW
          9: REFUSAL
    - id: PAR_Q26A
      kind: Question
      title: Has he/she ever experienced being hungry because the family has run out of food or money to buy food?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: PAR_Q26B
      kind: Question
      title: How often?
      precondition:
      - predicate: not (PAR_Q26A.outcome in [2, 8])
        hint: Asked only when question PAR-Q26A is none of "NO", "DON'T KNOW".
      - predicate: not (PAR_Q26A.outcome == 9)
        hint: Asked only when question PAR-Q26A is not "REFUSAL".
      input:
        control: Radio
        labels:
          1: REGULARLY, END OF THE MONTH
          2: MORE OFTEN THAN END OF EACH MONTH
          3: EVERY FEW MONTHS
          4: OCCASIONALLY, NOT A REGULAR OCCURRENCE
          8: DON'T KNOW
          9: REFUSAL
    - id: PAR_Q26C
      kind: Question
      title: How do you cope with feeding ... when this happens? (MARK ALL THAT APPLY.)
      precondition:
      - predicate: PAR_Q26A.outcome == 1
        hint: Asked only when question PAR-Q26A is "YES".
      - predicate: not (PAR_Q26A.outcome in [2, 8])
        hint: Asked only when question PAR-Q26A is none of "NO", "DON'T KNOW".
      - predicate: not (PAR_Q26A.outcome == 9)
        hint: Asked only when question PAR-Q26A is not "REFUSAL".
      - predicate: not (PAR_Q26B.outcome == 9)
        hint: Asked only when question PAR-Q26B is not "REFUSAL".
      input:
        control: Checkbox
        labels:
          1: 01 — PARENT/GUARDIAN SKIPS MEALS OR EATS LESS
          2: 02 — CHILDREN SKIP MEALS OR EAT LESS
          4: 03 — CUT DOWN ON VARIETY OF FOOD FAMILY USUALLY EATS
          8: 04 — SEEK HELP FROM RELATIVES
          16: 05 — SEEK HELP FROM FRIENDS
          32: 06 — SEEK HELP FROM SOCIAL WORKER/GOVERNMENT OFFICE
          64: 07 — SEEK HELP FROM FOOD BANK (EMERGENCY FOOD PROGRAM)
          128: 08 — USE SCHOOL MEAL PROGRAM
          256: 09 — OTHER
          512: 98 — DON'T KNOW
          1024: 99 — REFUSAL
    - id: PAR_Q27
      kind: Question
      title: How often does he/she see television shows or movies that have a lot of violence in them?
      precondition:
      - predicate: not (PAR_Q26A.outcome == 9)
        hint: Asked only when question PAR-Q26A is not "REFUSAL".
      - predicate: not (PAR_Q26B.outcome == 9)
        hint: Asked only when question PAR-Q26B is not "REFUSAL".
      - predicate: PAR_Q26C.outcome is None or not (PAR_Q26C.outcome & 1024 > 0)
      input:
        control: Radio
        labels:
          1: OFTEN
          2: SOMETIMES
          3: SELDOM
          4: NEVER
          8: DON'T KNOW
          9: REFUSAL
    - id: PAR_Q28
      kind: Question
      title: How often does he/she see adults or teenagers in your house physically fighting, hitting or otherwise trying to hurt others?
      precondition:
      - predicate: not (PAR_Q26A.outcome == 9)
        hint: Asked only when question PAR-Q26A is not "REFUSAL".
      - predicate: not (PAR_Q26B.outcome == 9)
        hint: Asked only when question PAR-Q26B is not "REFUSAL".
      - predicate: PAR_Q26C.outcome is None or not (PAR_Q26C.outcome & 1024 > 0)
      - predicate: not (PAR_Q27.outcome == 9)
        hint: Asked only when question PAR-Q27 is not "REFUSAL".
      input:
        control: Radio
        labels:
          1: OFTEN
          2: SOMETIMES
          3: SELDOM
          4: NEVER
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s21_p1_a
    title: 'Family and custody history: birth'
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    items:
    - id: CUS_Q1A
      kind: Question
      title: Did ... live with you when he/she was born?
      precondition:
      - predicate: DVS_Q1.outcome != 4 and PMK_OR_SPOUSE.outcome == 1
        hint: Asked only when the child is not excluded by DVS-Q1 and the respondent is the PMK or spouse.
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s21_p1_b
    title: 'Family and custody history: start of living together'
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    - predicate: not (CUS_Q1A.outcome == 1 and ELDEST_SELECTED_CHILD.outcome == 1)
      hint: Not asked when the child was born in the household and is the eldest selected child.
    - predicate: not (CUS_Q1A.outcome == 1 and ELDEST_SELECTED_CHILD.outcome != 1 and ELDEST_CUSTODY_DONE.outcome == 1 and FULL_SIBLING_OF_ELDEST.outcome == 1 and PARENTS_TOGETHER_SINCE_ELDEST_BIRTH.outcome != 1 and PARENTS_SEPARATED_NO_REMARRIAGE.outcome == 1 and CHILD_BORN_BEFORE_SEPARATION.outcome == 1)
      hint: Not asked when the custody answers are already known from the eldest child.
    - predicate: not (CUS_Q1A.outcome == 1 and ELDEST_SELECTED_CHILD.outcome != 1 and not (ELDEST_CUSTODY_DONE.outcome == 1 and FULL_SIBLING_OF_ELDEST.outcome == 1))
      hint: Not asked when the child lived with the respondent from birth and is not covered by the eldest child's custody answers.
    items:
    - id: CUS_Q1B
      kind: Question
      title: At what age did ... start living with you?
      input:
        control: Dropdown
        labels:
          1: 01 LESS THAN ONE YEAR OLD
          2: 02 ONE YEAR OLD
          3: 03 TWO YEARS OLD
          4: 04 THREE YEARS OLD
          5: 05 FOUR YEARS OLD
          6: 06 FIVE YEARS OLD
          7: 07 SIX YEARS OLD
          8: 08 SEVEN YEARS OLD
          9: 09 EIGHT YEARS OLD
          10: 10 NINE YEARS OLD
          11: 11 TEN YEARS OLD
          12: 12 ELEVEN YEARS OLD
          98: 98 DON'T KNOW
          99: 99 REFUSAL
    - id: CUS_Q1B2
      kind: Question
      title: ENTER THE AGE IN MONTHS  |_|_| AGE IN MONTHS (98 DON'T KNOW, 99 REFUSAL)
      precondition:
      - predicate: CUS_Q1B.outcome == 1
        hint: Asked only when question CUS-Q1B is "01 LESS THAN ONE YEAR OLD".
      - predicate: not (CUS_Q1B.outcome in [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 98])
        hint: Asked only when question CUS-Q1B is none of "02 ONE YEAR OLD" to "12 ELEVEN YEARS OLD", "98 DON'T KNOW".
      input:
        control: Editbox
        min: 0
        max: 99
    - id: CUS_Q1C
      kind: Question
      title: What was the reason ... did not live with you right from birth?
      input:
        control: Dropdown
        labels:
          1: 01 YOU HAVE ADOPTED HER/HIM
          2: 02 SHE/HE IS A STEPCHILD
          3: 03 SHE/HE WAS PUT IN YOUR CARE BY A CHILD WELFARE AGENCY (FOSTER CARE)
          4: 04 SHE/HE WAS PUT IN YOUR CARE BY ANOTHER TYPE OF AGENCY
          5: 05 SHE/HE WAS SICK AND HAD TO REMAIN IN A HOSPITAL OR OTHER INSTITUTION
          6: 06 YOU HAD TO LEAVE HER/HIM IN THE CARE OF SOMEONE ELSE FOR A WHILE, BEFORE YOU COULD TAKE CHARGE OF HER/HIM
          7: 07 CHILD WAS IN CARE OF A CHILD WELFARE AGENCY (FOSTER CARE) FOR A TIME
          8: 08 OTHER
          98: 98 DON'T KNOW
          99: 99 REFUSAL
  - id: b_s21_p1_c
    title: 'Family and custody history: siblings, parents'' unions'
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    - predicate: not (CUS_Q1A.outcome == 1 and ELDEST_SELECTED_CHILD.outcome != 1 and ELDEST_CUSTODY_DONE.outcome == 1 and FULL_SIBLING_OF_ELDEST.outcome == 1 and PARENTS_TOGETHER_SINCE_ELDEST_BIRTH.outcome != 1 and PARENTS_SEPARATED_NO_REMARRIAGE.outcome == 1 and CHILD_BORN_BEFORE_SEPARATION.outcome == 1)
      hint: Not asked when the custody answers are already known from the eldest child.
    - predicate: not (CUS_Q1C.outcome != 99 and ELDEST_SELECTED_CHILD.outcome != 1 and ELDEST_CUSTODY_DONE.outcome == 1 and FULL_SIBLING_OF_ELDEST.outcome == 1 and PARENTS_TOGETHER_SINCE_ELDEST_BIRTH.outcome != 1 and PARENTS_SEPARATED_NO_REMARRIAGE.outcome == 1 and CHILD_BORN_BEFORE_SEPARATION.outcome == 1)
      hint: Not asked when the custody answers are already known from the eldest child.
    items:
    - id: CUS_Q1D
      kind: Question
      title: Does ... have any brothers or sisters who do not regularly live in this household, excluding step and half brothers and sisters?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: CUS_Q1E
      kind: Question
      title: How many?  |_|_| NUMBER
      postcondition:
      - predicate: CUS_Q1D.outcome != 1 or CUS_Q1E.outcome >= 1
        hint: If CUS-Q1D is YES (brothers or sisters not living in the household), the number in CUS-Q1E must be at least 1.
        invented: true
      input:
        control: Editbox
        min: 0
        max: 99
    - id: CUS_Q1F
      kind: Question
      title: 'What is the age of the youngest one/him/her? (INTERVIEWER: ENTER AGE IN YEARS. IF LESS THAN ONE YEAR ENTER 0.)'
      input:
        control: Editbox
        min: 0
        max: 99
    - id: CUS_Q1G
      kind: Question
      title: 'What is the age of the oldest one? (INTERVIEWER: ENTER AGE IN YEARS. IF LESS THAN ONE YEAR ENTER 0.)'
      precondition:
      - predicate: CUS_Q1E.outcome != 1
        hint: Asked only when question CUS-Q1E is not 1.
      postcondition:
      - predicate: CUS_Q1F.outcome <= CUS_Q1G.outcome
        hint: The age of the oldest brother or sister (CUS-Q1G) cannot be less than the age of the youngest (CUS-Q1F).
        invented: true
      input:
        control: Editbox
        min: 0
        max: 99
    - id: CUS_Q2
      kind: Question
      title: When ... was born/adopted, were his/her parents (biological/adoptive) living together?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: CUS_Q3A
      kind: Question
      title: When ... was born/adopted, were his/her parents married, were they living together in a common-law relationship, or were they living together and eventually got married?
      precondition:
      - predicate: CUS_Q2.outcome == 1
        hint: Asked only when question CUS-Q2 is "YES".
      - predicate: not (CUS_Q2.outcome == 2)
        hint: Asked only when question CUS-Q2 is not "NO".
      input:
        control: Radio
        labels:
          1: MARRIED
          2: COMMON LAW
          3: COMMON-LAW, BUT MARRIED LATER
          8: DON'T KNOW
          9: REFUSAL
    - id: CUS_Q3B
      kind: Question
      title: Had they been living together before getting married?
      precondition:
      - predicate: CUS_Q3A.outcome == 1
        hint: Asked only when question CUS-Q3A is "MARRIED".
      - predicate: not (CUS_Q2.outcome == 2)
        hint: Asked only when question CUS-Q2 is not "NO".
      - predicate: not (CUS_Q3A.outcome == 2)
        hint: Asked only when question CUS-Q3A is not "COMMON LAW".
      - predicate: not (CUS_Q3A.outcome == 3)
        hint: Asked only when question CUS-Q3A is not "COMMON-LAW, BUT MARRIED LATER".
      - predicate: not (CUS_Q3A.outcome == 8)
        hint: Asked only when question CUS-Q3A is not "DON'T KNOW".
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: CUS_Q3C
      kind: Question
      title: What date were they married?  MONTH YEAR |_|_| |_|_|
      precondition:
      - predicate: CUS_Q3A.outcome in [1, 3]
        hint: Asked only when question CUS-Q3A is one of "MARRIED", "COMMON-LAW, BUT MARRIED LATER".
      - predicate: not (CUS_Q2.outcome == 2)
        hint: Asked only when question CUS-Q2 is not "NO".
      - predicate: not (CUS_Q3A.outcome == 2)
        hint: Asked only when question CUS-Q3A is not "COMMON LAW".
      - predicate: not (CUS_Q3A.outcome == 8)
        hint: Asked only when question CUS-Q3A is not "DON'T KNOW".
      input:
        control: Textarea
    - id: CUS_Q3D
      kind: Question
      title: Approximately since when had they been living together?  MONTH YEAR |_|_| |_|_|
      precondition:
      - predicate: not (CUS_Q2.outcome == 2)
        hint: Asked only when question CUS-Q2 is not "NO".
      - predicate: not (CUS_Q3A.outcome == 8)
        hint: Asked only when question CUS-Q3A is not "DON'T KNOW".
      - predicate: not (CUS_Q3A.outcome == 1 and CUS_Q3B.outcome == 2)
        hint: Not asked when the parents were married and had not lived together before.
      input:
        control: Textarea
    - id: CUS_Q4
      kind: Question
      title: 'Did ... live with his/her:'
      precondition:
      - predicate: CUS_Q2.outcome == 2
        hint: Asked only when question CUS-Q2 is "NO".
      - predicate: not (CUS_Q3A.outcome == 8)
        hint: Asked only when question CUS-Q3A is not "DON'T KNOW".
      - predicate: not (CUS_Q3A.outcome == 1 and CUS_Q3B.outcome == 2)
        hint: Not asked when the parents were married and had not lived together before.
      - predicate: not (CUS_Q2.outcome == 1)
        hint: Asked only when question CUS-Q2 is not "YES".
      input:
        control: Radio
        labels:
          1: Mother alone?
          2: Father alone?
          3: Mother and other?
          4: Father and other?
          5: Other?
          8: DON'T KNOW
          9: REFUSAL
    - id: CUS_Q5A
      kind: Question
      title: Have ...'s parents ever lived together as a couple?
      precondition:
      - predicate: not (CUS_Q3A.outcome == 8)
        hint: Asked only when question CUS-Q3A is not "DON'T KNOW".
      - predicate: not (CUS_Q3A.outcome == 1 and CUS_Q3B.outcome == 2)
        hint: Not asked when the parents were married and had not lived together before.
      - predicate: not (CUS_Q2.outcome == 1)
        hint: Asked only when question CUS-Q2 is not "YES".
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: CUS_Q5B
      kind: Question
      title: Was that before or after his/her birth?
      precondition:
      - predicate: not (CUS_Q3A.outcome == 8)
        hint: Asked only when question CUS-Q3A is not "DON'T KNOW".
      - predicate: not (CUS_Q3A.outcome == 1 and CUS_Q3B.outcome == 2)
        hint: Not asked when the parents were married and had not lived together before.
      - predicate: not (CUS_Q2.outcome == 1)
        hint: Asked only when question CUS-Q2 is not "YES".
      - predicate: not (CUS_Q5A.outcome in [2, 8])
        hint: Asked only when question CUS-Q5A is none of "NO", "DON'T KNOW".
      input:
        control: Radio
        labels:
          1: BEFORE
          2: AFTER
          3: BOTH BEFORE AND AFTER
          8: DON'T KNOW
          9: REFUSAL
    - id: CUS_Q5C
      kind: Question
      title: Were ...'s parents ever married?
      precondition:
      - predicate: not (CUS_Q3A.outcome == 8)
        hint: Asked only when question CUS-Q3A is not "DON'T KNOW".
      - predicate: not (CUS_Q3A.outcome == 1 and CUS_Q3B.outcome == 2)
        hint: Not asked when the parents were married and had not lived together before.
      - predicate: not (CUS_Q2.outcome == 1)
        hint: Asked only when question CUS-Q2 is not "YES".
      - predicate: not (CUS_Q5A.outcome in [2, 8])
        hint: Asked only when question CUS-Q5A is none of "NO", "DON'T KNOW".
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: CUS_Q5D
      kind: Question
      title: When did they marry?  MONTH YEAR |_|_| |_|_|
      precondition:
      - predicate: not (CUS_Q3A.outcome == 8)
        hint: Asked only when question CUS-Q3A is not "DON'T KNOW".
      - predicate: not (CUS_Q3A.outcome == 1 and CUS_Q3B.outcome == 2)
        hint: Not asked when the parents were married and had not lived together before.
      - predicate: not (CUS_Q2.outcome == 1)
        hint: Asked only when question CUS-Q2 is not "YES".
      - predicate: not (CUS_Q5A.outcome in [2, 8])
        hint: Asked only when question CUS-Q5A is none of "NO", "DON'T KNOW".
      - predicate: not (CUS_Q5C.outcome in [2, 8] and CUS_Q5B.outcome == 2)
        hint: Not asked when the parents never married and lived together only after the birth.
      - predicate: not (CUS_Q5C.outcome in [2, 8] and CUS_Q5B.outcome != 2)
        hint: Not asked when the parents never married.
      input:
        control: Textarea
    - id: CUS_Q5E
      kind: Question
      title: At the time ... was born, since when had his/her parents stopped living together?  MONTH YEAR |_|_| |_|_|
      precondition:
      - predicate: CUS_Q5B.outcome != 2
        hint: Asked only when question CUS-Q5B is not "AFTER".
      - predicate: not (CUS_Q3A.outcome == 8)
        hint: Asked only when question CUS-Q3A is not "DON'T KNOW".
      - predicate: not (CUS_Q3A.outcome == 1 and CUS_Q3B.outcome == 2)
        hint: Not asked when the parents were married and had not lived together before.
      - predicate: not (CUS_Q2.outcome == 1)
        hint: Asked only when question CUS-Q2 is not "YES".
      - predicate: not (CUS_Q5A.outcome in [2, 8])
        hint: Asked only when question CUS-Q5A is none of "NO", "DON'T KNOW".
      - predicate: not (CUS_Q5C.outcome in [2, 8] and CUS_Q5B.outcome == 2)
        hint: Not asked when the parents never married and lived together only after the birth.
      - predicate: not (CUS_Q5B.outcome == 2)
        hint: Asked only when question CUS-Q5B is not "AFTER".
      input:
        control: Textarea
    - id: CUS_Q5F
      kind: Question
      title: Without living together, did ...'s parents have a steady relationship at the time of his/her birth?
      precondition:
      - predicate: not (CUS_Q3A.outcome == 8)
        hint: Asked only when question CUS-Q3A is not "DON'T KNOW".
      - predicate: not (CUS_Q3A.outcome == 1 and CUS_Q3B.outcome == 2)
        hint: Not asked when the parents were married and had not lived together before.
      - predicate: not (CUS_Q2.outcome == 1)
        hint: Asked only when question CUS-Q2 is not "YES".
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: CUS_Q6A
      kind: Question
      title: Had ...'s mother been in any common-law relationships or been married before the union with ...'s father? (MARK ALL THAT APPLY)
      precondition:
      - predicate: not (CUS_Q5F.outcome in [1, 2, 8])
        hint: Asked only when question CUS-Q5F is none of "YES", "NO", "DON'T KNOW".
      input:
        control: Checkbox
        labels:
          1: 1 — YES, COMMON-LAW
          2: 2 — YES, MARRIAGE
          4: 3 — YES, COMMON LAW WHICH RESULTED IN MARRIAGE
          8: 4 — NO
          16: 8 — DON'T KNOW
          32: 9 — REFUSAL
    - id: CUS_Q6B
      kind: Question
      title: How many times?  |_|_| NUMBER (98 DON'T KNOW, 99 REFUSAL)
      precondition:
      - predicate: CUS_Q6A.outcome & 7 > 0
        hint: Asked only when CUS-Q6A includes a common-law relationship or marriage.
      - predicate: not (CUS_Q5F.outcome in [1, 2, 8])
        hint: Asked only when question CUS-Q5F is none of "YES", "NO", "DON'T KNOW".
      - predicate: not (CUS_Q6A.outcome & 8 > 0 or CUS_Q6A.outcome & 16 > 0)
        hint: Not asked when CUS-Q6A is "NO" or "DON'T KNOW".
      input:
        control: Editbox
        min: 0
        max: 99
    - id: CUS_Q6C
      kind: Question
      title: Before ... 's birth, had his/her mother been in any common-law relationships or been married to a person other than ...'s father? (MARK ALL THAT APPLY)
      precondition:
      - predicate: not (CUS_Q6A.outcome & 8 > 0 or CUS_Q6A.outcome & 16 > 0)
        hint: Not asked when CUS-Q6A is "NO" or "DON'T KNOW".
      - predicate: not (CUS_Q6B.outcome != 99)
        hint: Asked only when question CUS-Q6B is "REFUSAL".
      input:
        control: Checkbox
        labels:
          1: 1 — YES, COMMON-LAW
          2: 2 — YES, MARRIAGE
          4: 3 — YES, COMMON LAW WHICH RESULTED IN MARRIAGE
          8: 4 — NO
          16: 8 — DON'T KNOW
          32: 9 — REFUSAL
    - id: CUS_Q6D
      kind: Question
      title: How many times?  |_|_| NUMBER (98 DON'T KNOW, 99 REFUSAL)
      precondition:
      - predicate: CUS_Q6C.outcome & 7 > 0
        hint: Asked only when CUS-Q6C includes a common-law relationship or marriage.
      - predicate: not (CUS_Q6A.outcome & 8 > 0 or CUS_Q6A.outcome & 16 > 0)
        hint: Not asked when CUS-Q6A is "NO" or "DON'T KNOW".
      - predicate: not (CUS_Q6B.outcome != 99)
        hint: Asked only when question CUS-Q6B is "REFUSAL".
      - predicate: not (CUS_Q6C.outcome & 8 > 0 or CUS_Q6C.outcome & 16 > 0)
        hint: Not asked when CUS-Q6C is "NO" or "DON'T KNOW".
      input:
        control: Editbox
        min: 0
        max: 99
    - id: CUS_Q6E
      kind: Question
      title: Did ...'s mother have any children before entering into union with ...'s father?
      precondition:
      - predicate: not (CUS_Q6C.outcome & 8 > 0 or CUS_Q6C.outcome & 16 > 0)
        hint: Not asked when CUS-Q6C is "NO" or "DON'T KNOW".
      - predicate: not (CUS_Q6D.outcome != 99)
        hint: Asked only when question CUS-Q6D is "REFUSAL".
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: CUS_Q6F
      kind: Question
      title: How many?  |_|_| NUMBER
      precondition:
      - predicate: not (CUS_Q6C.outcome & 8 > 0 or CUS_Q6C.outcome & 16 > 0)
        hint: Not asked when CUS-Q6C is "NO" or "DON'T KNOW".
      - predicate: not (CUS_Q6D.outcome != 99)
        hint: Asked only when question CUS-Q6D is "REFUSAL".
      - predicate: not (CUS_Q6E.outcome in [2, 8])
        hint: Asked only when question CUS-Q6E is none of "NO", "DON'T KNOW".
      postcondition:
      - predicate: CUS_Q6E.outcome != 1 or CUS_Q6F.outcome >= 1
        hint: If CUS-Q6E is YES (the mother had children before the union), the number in CUS-Q6F must be at least 1.
        invented: true
      input:
        control: Editbox
        min: 0
        max: 99
    - id: CUS_Q6G
      kind: Question
      title: Did that child/any of those children live at least part time in the household when ... was born? (MARK ALL THAT APPLY)
      precondition:
      - predicate: not (CUS_Q6C.outcome & 8 > 0 or CUS_Q6C.outcome & 16 > 0)
        hint: Not asked when CUS-Q6C is "NO" or "DON'T KNOW".
      - predicate: not (CUS_Q6D.outcome != 99)
        hint: Asked only when question CUS-Q6D is "REFUSAL".
      - predicate: not (CUS_Q6E.outcome in [2, 8])
        hint: Asked only when question CUS-Q6E is none of "NO", "DON'T KNOW".
      input:
        control: Checkbox
        labels:
          1: 1 — YES, ALL OF THEM, FULL-TIME
          2: 2 — YES, ALL OF THEM, PART-TIME
          4: 3 — YES, SOME OF THEM, FULL-TIME
          8: 4 — YES, SOME OF THEM, PART-TIME
          16: 5 — NO, NONE OF THEM
          32: 8 — DON'T KNOW
          64: 9 — REFUSAL
    - id: CUS_Q6H
      kind: Question
      title: How many children did ...'s mother have before ...?  |_|_| NUMBER
      precondition:
      - predicate: not (CUS_Q6E.outcome in [2, 8])
        hint: Asked only when question CUS-Q6E is none of "NO", "DON'T KNOW".
      - predicate: not (CUS_Q6G.outcome & 64 == 0)
        hint: Asked only when CUS-Q6G includes "REFUSAL".
      input:
        control: Editbox
        min: 0
        max: 99
    - id: CUS_Q6I
      kind: Question
      title: Did that child/any of those children live at least part time in the household when ... was born? (MARK ALL THAT APPLY)
      precondition:
      - predicate: CUS_Q6H.outcome != 0
        hint: Asked only when question CUS-Q6H is not 0.
      - predicate: not (CUS_Q6E.outcome in [2, 8])
        hint: Asked only when question CUS-Q6E is none of "NO", "DON'T KNOW".
      - predicate: not (CUS_Q6G.outcome & 64 == 0)
        hint: Asked only when CUS-Q6G includes "REFUSAL".
      - predicate: not (CUS_Q6H.outcome == 0 and CUS_Q5A.outcome == 1)
        hint: Not asked when the mother had no earlier children and the parents lived together.
      - predicate: not (CUS_Q6H.outcome == 0 and CUS_Q5A.outcome != 1)
        hint: Not asked when the mother had no earlier children.
      input:
        control: Checkbox
        labels:
          1: 1 — YES, ALL OF THEM, FULL-TIME
          2: 2 — YES, ALL OF THEM, PART-TIME
          4: 3 — YES, SOME OF THEM, FULL-TIME
          8: 4 — YES, SOME OF THEM, PART-TIME
          16: 5 — NO, NONE OF THEM
          32: 8 — DON'T KNOW
          64: 9 — REFUSAL
    - id: CUS_Q7A
      kind: Question
      title: Had ...'s father been in any common-law relationships or been married before the union with ...'s mother? (MARK ALL THAT APPLY)
      precondition:
      - predicate: not (CUS_Q6H.outcome == 0 and CUS_Q5A.outcome == 1)
        hint: Not asked when the mother had no earlier children and the parents lived together.
      - predicate: not (CUS_Q6H.outcome == 0 and CUS_Q5A.outcome != 1)
        hint: Not asked when the mother had no earlier children.
      - predicate: not (CUS_Q6I.outcome & 64 == 0 and CUS_Q5A.outcome == 1)
        hint: Not asked when CUS-Q6I does not include "REFUSAL" and the parents lived together.
      - predicate: not (CUS_Q6I.outcome & 64 == 0 and CUS_Q5A.outcome != 1)
        hint: Not asked when CUS-Q6I does not include "REFUSAL".
      input:
        control: Checkbox
        labels:
          1: 1 — YES, COMMON-LAW
          2: 2 — YES, MARRIAGE
          4: 3 — YES, COMMON LAW WHICH RESULTED IN MARRIAGE
          8: 4 — NO
          16: 8 — DON'T KNOW
          32: 9 — REFUSAL
    - id: CUS_Q7B
      kind: Question
      title: How many times?  |_|_| NUMBER (98 DON'T KNOW, 99 REFUSAL)
      precondition:
      - predicate: CUS_Q7A.outcome & 7 > 0
        hint: Asked only when CUS-Q7A includes a common-law relationship or marriage.
      - predicate: not (CUS_Q6H.outcome == 0 and CUS_Q5A.outcome == 1)
        hint: Not asked when the mother had no earlier children and the parents lived together.
      - predicate: not (CUS_Q6H.outcome == 0 and CUS_Q5A.outcome != 1)
        hint: Not asked when the mother had no earlier children.
      - predicate: not (CUS_Q6I.outcome & 64 == 0 and CUS_Q5A.outcome == 1)
        hint: Not asked when CUS-Q6I does not include "REFUSAL" and the parents lived together.
      - predicate: not (CUS_Q6I.outcome & 64 == 0 and CUS_Q5A.outcome != 1)
        hint: Not asked when CUS-Q6I does not include "REFUSAL".
      - predicate: not (CUS_Q7A.outcome & 8 > 0 or CUS_Q7A.outcome & 16 > 0)
        hint: Not asked when CUS-Q7A is "NO" or "DON'T KNOW".
      input:
        control: Editbox
        min: 0
        max: 99
    - id: CUS_Q7C
      kind: Question
      title: Before ...'s birth, had his/her father been in any common-law relationships or been married to a person other than ...'s mother? (MARK ALL THAT APPLY)
      precondition:
      - predicate: not (CUS_Q6H.outcome == 0 and CUS_Q5A.outcome != 1)
        hint: Not asked when the mother had no earlier children.
      - predicate: not (CUS_Q6I.outcome & 64 == 0 and CUS_Q5A.outcome != 1)
        hint: Not asked when CUS-Q6I does not include "REFUSAL".
      - predicate: not (CUS_Q7A.outcome & 8 > 0 or CUS_Q7A.outcome & 16 > 0)
        hint: Not asked when CUS-Q7A is "NO" or "DON'T KNOW".
      - predicate: not (CUS_Q7B.outcome != 99)
        hint: Asked only when question CUS-Q7B is "REFUSAL".
      input:
        control: Checkbox
        labels:
          1: 1 — YES, COMMON-LAW
          2: 2 — YES, MARRIAGE
          4: 3 — YES, COMMON LAW WHICH RESULTED IN MARRIAGE
          8: 4 — NO
          16: 8 — DON'T KNOW
          32: 9 — REFUSAL
    - id: CUS_Q7D
      kind: Question
      title: How many times?  |_|_| NUMBER (98 DON'T KNOW, 99 REFUSAL)
      precondition:
      - predicate: CUS_Q7C.outcome & 7 > 0
        hint: Asked only when CUS-Q7C includes a common-law relationship or marriage.
      - predicate: not (CUS_Q6H.outcome == 0 and CUS_Q5A.outcome != 1)
        hint: Not asked when the mother had no earlier children.
      - predicate: not (CUS_Q6I.outcome & 64 == 0 and CUS_Q5A.outcome != 1)
        hint: Not asked when CUS-Q6I does not include "REFUSAL".
      - predicate: not (CUS_Q7A.outcome & 8 > 0 or CUS_Q7A.outcome & 16 > 0)
        hint: Not asked when CUS-Q7A is "NO" or "DON'T KNOW".
      - predicate: not (CUS_Q7B.outcome != 99)
        hint: Asked only when question CUS-Q7B is "REFUSAL".
      - predicate: not (CUS_Q7C.outcome & 8 > 0 or CUS_Q7C.outcome & 16 > 0)
        hint: Not asked when CUS-Q7C is "NO" or "DON'T KNOW".
      input:
        control: Editbox
        min: 0
        max: 99
    - id: CUS_Q7E
      kind: Question
      title: Did ...'s father have any children before entering into union with ...'s mother?
      precondition:
      - predicate: not (CUS_Q6H.outcome == 0 and CUS_Q5A.outcome != 1)
        hint: Not asked when the mother had no earlier children.
      - predicate: not (CUS_Q6I.outcome & 64 == 0 and CUS_Q5A.outcome != 1)
        hint: Not asked when CUS-Q6I does not include "REFUSAL".
      - predicate: not (CUS_Q7C.outcome & 8 > 0 or CUS_Q7C.outcome & 16 > 0)
        hint: Not asked when CUS-Q7C is "NO" or "DON'T KNOW".
      - predicate: not (CUS_Q7D.outcome != 99)
        hint: Asked only when question CUS-Q7D is "REFUSAL".
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: CUS_Q7F
      kind: Question
      title: How many?
      precondition:
      - predicate: not (CUS_Q6H.outcome == 0 and CUS_Q5A.outcome != 1)
        hint: Not asked when the mother had no earlier children.
      - predicate: not (CUS_Q6I.outcome & 64 == 0 and CUS_Q5A.outcome != 1)
        hint: Not asked when CUS-Q6I does not include "REFUSAL".
      - predicate: not (CUS_Q7C.outcome & 8 > 0 or CUS_Q7C.outcome & 16 > 0)
        hint: Not asked when CUS-Q7C is "NO" or "DON'T KNOW".
      - predicate: not (CUS_Q7D.outcome != 99)
        hint: Asked only when question CUS-Q7D is "REFUSAL".
      - predicate: not (CUS_Q7E.outcome in [2, 8])
        hint: Asked only when question CUS-Q7E is none of "NO", "DON'T KNOW".
      postcondition:
      - predicate: CUS_Q7E.outcome != 1 or CUS_Q7F.outcome >= 1
        hint: If CUS-Q7E is YES (the father had children before the union), the number in CUS-Q7F must be at least 1.
        invented: true
      input:
        control: Editbox
        min: 0
        max: 99
    - id: CUS_Q7G
      kind: Question
      title: Did that child/any of those children live at least part time in the household when ... was born? (MARK ALL THAT APPLY)
      precondition:
      - predicate: not (CUS_Q6H.outcome == 0 and CUS_Q5A.outcome != 1)
        hint: Not asked when the mother had no earlier children.
      - predicate: not (CUS_Q6I.outcome & 64 == 0 and CUS_Q5A.outcome != 1)
        hint: Not asked when CUS-Q6I does not include "REFUSAL".
      - predicate: not (CUS_Q7C.outcome & 8 > 0 or CUS_Q7C.outcome & 16 > 0)
        hint: Not asked when CUS-Q7C is "NO" or "DON'T KNOW".
      - predicate: not (CUS_Q7D.outcome != 99)
        hint: Asked only when question CUS-Q7D is "REFUSAL".
      - predicate: not (CUS_Q7E.outcome in [2, 8])
        hint: Asked only when question CUS-Q7E is none of "NO", "DON'T KNOW".
      input:
        control: Checkbox
        labels:
          1: 1 — YES, ALL OF THEM, FULL-TIME
          2: 2 — YES, ALL OF THEM, PART-TIME
          4: 3 — YES, SOME OF THEM, FULL-TIME
          8: 4 — YES, SOME OF THEM, PART-TIME
          16: 5 — NO, NONE OF THEM
          32: 8 — DON'T KNOW
          64: 9 — REFUSAL
  - id: b_s21_p2_prior_children
    title: Father's earlier children
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    - predicate: not (CUS_Q1A.outcome == 1 and ELDEST_SELECTED_CHILD.outcome != 1 and ELDEST_CUSTODY_DONE.outcome == 1 and FULL_SIBLING_OF_ELDEST.outcome == 1 and PARENTS_TOGETHER_SINCE_ELDEST_BIRTH.outcome != 1 and PARENTS_SEPARATED_NO_REMARRIAGE.outcome == 1 and CHILD_BORN_BEFORE_SEPARATION.outcome == 1)
      hint: Routing condition from the source questionnaire.
    - predicate: not (CUS_Q1C.outcome != 99 and ELDEST_SELECTED_CHILD.outcome != 1 and ELDEST_CUSTODY_DONE.outcome == 1 and FULL_SIBLING_OF_ELDEST.outcome == 1 and PARENTS_TOGETHER_SINCE_ELDEST_BIRTH.outcome != 1 and PARENTS_SEPARATED_NO_REMARRIAGE.outcome == 1 and CHILD_BORN_BEFORE_SEPARATION.outcome == 1)
      hint: Routing condition from the source questionnaire.
    - predicate: not (CUS_Q6H.outcome == 0 and CUS_Q5A.outcome != 1)
      hint: Routing condition from the source questionnaire.
    - predicate: not (CUS_Q6I.outcome & 64 == 0 and CUS_Q5A.outcome != 1)
      hint: Routing condition from the source questionnaire.
    - predicate: not (CUS_Q7E.outcome in [2, 8])
      hint: Asked only when question CUS-Q7E is none of "NO", "DON'T KNOW".
    - predicate: not (CUS_Q7G.outcome & 64 == 0)
      hint: Routing condition from the source questionnaire.
    items:
    - id: CUS_Q7H
      kind: Question
      title: How many children did ...'s father have before ...?
      input:
        control: Editbox
        min: 0
        max: 99
    - id: CUS_Q7I
      kind: Question
      title: Did that child/any of those children live at least part time in the household when ... was born? (MARK ALL THAT APPLY)
      precondition:
      - predicate: CUS_Q7H.outcome != 0
        hint: Asked only when question CUS-Q7H is not 0.
      input:
        control: Checkbox
        labels:
          1: 1 — YES, ALL OF THEM, FULL-TIME
          2: 2 — YES, ALL OF THEM, PART-TIME
          4: 3 — YES, SOME OF THEM, FULL-TIME
          8: 4 — YES, SOME OF THEM, PART-TIME
          16: 5 — NO, NONE OF THEM
          32: 8 — DON'T KNOW
          64: 9 — REFUSAL
  - id: b_s21_p2_contact
    title: Father declaration and contact with other parent
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    - predicate: not (CUS_Q1A.outcome == 1 and ELDEST_SELECTED_CHILD.outcome != 1 and ELDEST_CUSTODY_DONE.outcome == 1 and FULL_SIBLING_OF_ELDEST.outcome == 1 and PARENTS_TOGETHER_SINCE_ELDEST_BIRTH.outcome != 1 and PARENTS_SEPARATED_NO_REMARRIAGE.outcome == 1 and CHILD_BORN_BEFORE_SEPARATION.outcome == 1)
      hint: Routing condition from the source questionnaire.
    - predicate: not (CUS_Q1C.outcome != 99 and ELDEST_SELECTED_CHILD.outcome != 1 and ELDEST_CUSTODY_DONE.outcome == 1 and FULL_SIBLING_OF_ELDEST.outcome == 1 and PARENTS_TOGETHER_SINCE_ELDEST_BIRTH.outcome != 1 and PARENTS_SEPARATED_NO_REMARRIAGE.outcome == 1 and CHILD_BORN_BEFORE_SEPARATION.outcome == 1)
      hint: Routing condition from the source questionnaire.
    - predicate: not (CUS_Q7E.outcome in [2, 8])
      hint: Asked only when question CUS-Q7E is none of "NO", "DON'T KNOW".
    - predicate: not (CUS_Q7G.outcome & 64 == 0)
      hint: Routing condition from the source questionnaire.
    items:
    - id: CUS_Q8A
      kind: Question
      title: Was ... 's father declared on his/her birth certificate?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: CUS_Q8B
      kind: Question
      title: What kind of contact did ... first have with his/her other parent?
      input:
        control: Dropdown
        labels:
          1: 01 SHARING LIVING ARRANGEMENTS ON AN EQUAL TIME BASIS
          2: 02 SHARING LIVING ARRANGEMENTS WITH MOST TIME WITH MOTHER
          3: 03 SHARING LIVING ARRANGEMENTS WITH MOST TIME WITH FATHER
          4: 04 REGULAR VISITING
          5: 05 IRREGULAR VISITING
          6: 06 TELEPHONE OR LETTER CONTACT ONLY
          7: 07 NO CONTACT AT ALL
          8: 08 OTHER
          98: 98 DON'T KNOW
          99: 99 REFUSAL
    - id: CUS_Q8C
      kind: Question
      title: How many times would you say this situation has changed over time?
      precondition:
      - predicate: not (CUS_Q8B.outcome == 98)
        hint: Asked only when question CUS-Q8B is not "98 DON'T KNOW".
      input:
        control: Radio
        labels:
          1: NONE
          2: ONCE
          3: TWICE
          4: THREE TIMES
          5: FOUR OR MORE TIMES
          8: DON'T KNOW
          9: REFUSAL
    - id: CUS_Q8D
      kind: Question
      title: How old was ... when the last change happened? (ENTER AGE IN YEARS. IF LESS THAN ONE YEAR ENTER 0.)  |_|_| Age in Years
      precondition:
      - predicate: not (CUS_Q8B.outcome == 98)
        hint: Asked only when question CUS-Q8B is not "98 DON'T KNOW".
      - predicate: not (CUS_Q8C.outcome == 1)
        hint: Asked only when question CUS-Q8C is not "NONE".
      input:
        control: Editbox
        min: 0
        max: 99
    - id: CUS_Q8E
      kind: Question
      title: What type of contact does ... now have with his/her other parent?
      precondition:
      - predicate: not (CUS_Q8C.outcome == 1)
        hint: Asked only when question CUS-Q8C is not "NONE".
      input:
        control: Dropdown
        labels:
          1: 01 SHARING LIVING ARRANGEMENTS ON AN EQUAL TIME BASIS
          2: 02 SHARING LIVING ARRANGEMENTS WITH MOST TIME WITH MOTHER
          3: 03 SHARING LIVING ARRANGEMENTS WITH MOST TIME WITH FATHER
          4: 04 REGULAR VISITING
          5: 05 IRREGULAR VISITING
          6: 06 TELEPHONE OR LETTER CONTACT ONLY
          7: 07 BOTH PARENTS NOW LIVING WITH THE CHILD
          8: 08 NO CONTACT AT ALL
          9: 09 OTHER
          98: 98 DON'T KNOW
          99: 99 REFUSAL
  - id: b_s21_p2_deaths_separation
    title: Parent deaths and separation
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    - predicate: not (CUS_Q1A.outcome == 1 and ELDEST_SELECTED_CHILD.outcome != 1 and ELDEST_CUSTODY_DONE.outcome == 1 and FULL_SIBLING_OF_ELDEST.outcome == 1 and PARENTS_TOGETHER_SINCE_ELDEST_BIRTH.outcome != 1 and PARENTS_SEPARATED_NO_REMARRIAGE.outcome == 1 and CHILD_BORN_BEFORE_SEPARATION.outcome == 1)
      hint: Routing condition from the source questionnaire.
    - predicate: not (CUS_Q1C.outcome != 99 and ELDEST_SELECTED_CHILD.outcome != 1 and ELDEST_CUSTODY_DONE.outcome == 1 and FULL_SIBLING_OF_ELDEST.outcome == 1 and PARENTS_TOGETHER_SINCE_ELDEST_BIRTH.outcome != 1 and PARENTS_SEPARATED_NO_REMARRIAGE.outcome == 1 and CHILD_BORN_BEFORE_SEPARATION.outcome == 1)
      hint: Routing condition from the source questionnaire.
    items:
    - id: CUS_Q9A
      kind: Question
      title: Between ...'s birth and now, has one of his/her parents died?
      precondition:
      - predicate: not (CUS_Q8C.outcome == 1)
        hint: Asked only when question CUS-Q8C is not "NONE".
      - predicate: not (CUS_Q8E.outcome != 99)
        hint: Asked only when question CUS-Q8E is "99 REFUSAL".
      input:
        control: Radio
        labels:
          1: YES, MOTHER
          2: YES, FATHER
          3: YES, BOTH
          4: 'NO'
          5: DON'T KNOW (ABOUT FATHER)
          6: DON'T KNOW (ABOUT MOTHER)
          8: DON'T KNOW
          9: REFUSAL
    - id: CUS_Q9B
      kind: Question
      title: Has one of ...'s parents died?
      precondition:
      - predicate: not (CUS_Q9A.outcome in [1, 2, 3])
        hint: Asked only when question CUS-Q9A is none of "YES, MOTHER", "YES, FATHER", "YES, BOTH".
      - predicate: not (CUS_Q9A.outcome in [4, 5, 6, 8])
        hint: Asked only when question CUS-Q9A is none of "NO", "DON'T KNOW (ABOUT FATHER)", "DON'T KNOW (ABOUT MOTHER)", "DON'T KNOW".
      input:
        control: Radio
        labels:
          1: YES, MOTHER
          2: YES, FATHER
          3: YES, BOTH
          4: 'NO'
          5: DON'T KNOW (ABOUT FATHER)
          6: DON'T KNOW (ABOUT MOTHER)
          8: DON'T KNOW
          9: REFUSAL
    - id: CUS_Q9C
      kind: Question
      title: When did it happen? (DATE OF FIRST DEATH, IF BOTH)
      precondition:
      - predicate: not (CUS_Q9A.outcome in [4, 5, 6, 8])
        hint: Asked only when question CUS-Q9A is none of "NO", "DON'T KNOW (ABOUT FATHER)", "DON'T KNOW (ABOUT MOTHER)", "DON'T KNOW".
      input:
        control: Textarea
    - id: CUS_Q9D
      kind: Question
      title: With whom did ... go on living at the time it happened?
      precondition:
      - predicate: not (CUS_Q9A.outcome in [4, 5, 6, 8])
        hint: Asked only when question CUS-Q9A is none of "NO", "DON'T KNOW (ABOUT FATHER)", "DON'T KNOW (ABOUT MOTHER)", "DON'T KNOW".
      input:
        control: Radio
        labels:
          1: MOTHER
          2: FATHER
          3: OTHER
          8: DON'T KNOW
          9: REFUSAL
    - id: CUS_Q10A
      kind: Question
      title: Prior to the death of ...'s parent, did his/her parents break up and stop living together?
      precondition:
      - predicate: not (CUS_Q9A.outcome in [4, 5, 6, 8])
        hint: Asked only when question CUS-Q9A is none of "NO", "DON'T KNOW (ABOUT FATHER)", "DON'T KNOW (ABOUT MOTHER)", "DON'T KNOW".
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: CUS_Q10B
      kind: Question
      title: Since ...'s birth, did his/her parents break up and stop living together?
      precondition:
      - predicate: not (CUS_Q10A.outcome == 1)
        hint: Asked only when question CUS-Q10A is not "YES".
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: CUS_Q11A
      kind: Question
      title: When did the separation happen?  MONTH YEAR |_|_| |_|_|
      input:
        control: Textarea
    - id: CUS_Q11B
      kind: Question
      title: Did ...'s parents eventually divorce?
      precondition:
      - predicate: CUS_Q3A.outcome in [1, 3] or CUS_Q5C.outcome == 1
        hint: Routing condition from the source questionnaire.
      - predicate: not (not (CUS_Q3A.outcome in [1, 3] or CUS_Q5C.outcome == 1))
        hint: Routing condition from the source questionnaire.
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: CUS_Q11C
      kind: Question
      title: When was the divorce pronounced?  MONTH YEAR |_|_| |_|_|
      precondition:
      - predicate: CUS_Q11B.outcome == 1
        hint: Asked only when question CUS-Q11B is "YES".
      - predicate: not (not (CUS_Q3A.outcome in [1, 3] or CUS_Q5C.outcome == 1))
        hint: Routing condition from the source questionnaire.
      - predicate: not (CUS_Q11B.outcome in [2, 8])
        hint: Asked only when question CUS-Q11B is none of "NO", "DON'T KNOW".
      input:
        control: Textarea
  - id: b_s21_p2_court_support
    title: Custody orders and support
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    items:
    - id: CUS_Q11D
      kind: Question
      title: Was there a court order concerning ...'s custody when his/her parents separated or divorced?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: YES, IN PROGRESS
          3: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: CUS_Q11E
      kind: Question
      title: 'Did the court order him/her to be put into:'
      precondition:
      - predicate: CUS_Q11D.outcome == 1
        hint: Asked only when question CUS-Q11D is "YES".
      - predicate: not (CUS_Q11D.outcome in [2, 3, 8])
        hint: Asked only when question CUS-Q11D is none of "YES, IN PROGRESS", "NO", "DON'T KNOW".
      input:
        control: Radio
        labels:
          1: Sole custody of mother?
          2: Sole custody of father?
          3: Shared physical custody of both parents?
          4: Other?
          8: DON'T KNOW
          9: REFUSAL
    - id: CUS_Q11F
      kind: Question
      title: What type of agreement was made regarding support/maintenance payments when ...'s parents separated or divorced?
      input:
        control: Radio
        labels:
          1: NONE
          2: PRIVATE AGREEMENT BETWEEN SPOUSES
          3: COURT-ORDERED AGREEMENT IN PROGRESS
          4: COURT-ORDERED AGREEMENT
          8: DON'T KNOW
          9: REFUSAL
    - id: CUS_Q11G
      kind: Question
      title: 'Was this:'
      precondition:
      - predicate: CUS_Q11F.outcome == 4
        hint: Asked only when question CUS-Q11F is "COURT-ORDERED AGREEMENT".
      input:
        control: Radio
        labels:
          1: For child support only?
          2: For spousal support only?
          3: For both?
          8: DON'T KNOW
          9: REFUSAL
    - id: CUS_Q11H
      kind: Question
      title: How regular have the maintenance support payments been?
      input:
        control: Dropdown
        labels:
          1: 01 REGULAR AND ON TIME
          2: 02 REGULAR BUT LATE SOMETIMES
          3: 03 IRREGULAR
          4: 04 NO PAYMENTS FOR THE LAST 6 MONTHS
          5: 05 NO PAYMENTS FOR THE LAST YEAR
          6: 06 NO PAYMENTS FOR THE LAST FEW YEARS
          7: 07 PAYMENTS NEVER BEEN RECEIVED
          8: 08 PAYMENTS STOPPED DUE TO A CHANGE IN CIRCUMSTANCES, E.G. COURT ORDER, DEATH OF PAYOR, ETC.
          98: 98 DON'T KNOW
          99: 99 REFUSAL
  - id: b_s22_external_inputs
    title: External inputs referenced by the routing of this part
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    items:
    - id: AGE_3
      kind: Question
      title: Age of the person (from earlier in the questionnaire/sample), used in HLT-C20 and HLT-C22 (IF AGE < 6)
      external: true
      input:
        control: Editbox
        min: 0
        max: 120
    - id: PMK_OR_SPOUSE
      kind: Question
      title: Respondent is the person most knowledgeable about the child, or that person's spouse/partner (CUS-C1)
      external: true
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
    - id: ELDEST_SELECTED_CHILD
      kind: Question
      title: Selected child is the eldest selected child (CUS-C1A, CUS-C1D)
      external: true
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
    - id: ELDEST_CUSTODY_DONE
      kind: Question
      title: Eldest selected child's custody section was completed (CUS-C1A, CUS-C1D)
      external: true
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
    - id: FULL_SIBLING_OF_ELDEST
      kind: Question
      title: Selected child is a full sibling (by birth) of the eldest selected child (CUS-C1A, CUS-C1D)
      external: true
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
    - id: PARENTS_TOGETHER_SINCE_ELDEST_BIRTH
      kind: Question
      title: Parents together since eldest child's birth (CUS-C1B, CUS-C1E)
      external: true
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
    - id: PARENTS_SEPARATED_NO_REMARRIAGE
      kind: Question
      title: Parents separated after eldest child's birth, neither remarried (CUS-C1B, CUS-C1E)
      external: true
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
    - id: CHILD_BORN_BEFORE_SEPARATION
      kind: Question
      title: This child was born before the parents' separation (CUS-C1B, CUS-C1E)
      external: true
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
  - id: b_s23_separation_living
    title: Living arrangements after separation
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    items:
    - id: CUS_Q12
      kind: Question
      title: With whom did ... go on living at the time of the separation?
      precondition:
      - predicate: not (CUS_Q11E.outcome in [1, 2])
        hint: Not asked when CUS-Q11E is 1 or 2
      input:
        control: Radio
        labels:
          1: MOTHER ONLY
          2: FATHER ONLY
          3: SHARED TIME BASIS, MOSTLY MOTHER
          4: SHARED TIME BASIS, MOSTLY FATHER
          5: EQUALLY SHARED TIME, MOTHER AND FATHER
          6: OTHER
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s23_contact_unshared
    title: Contact with the other parent (non-shared arrangements)
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    - predicate: not (CUS_Q12.outcome in [3, 4, 5])
      hint: Asked only when question CUS-Q12 is none of "SHARED TIME BASIS, MOSTLY MOTHER", "SHARED TIME BASIS, MOSTLY FATHER", "EQUALLY SHARED TIME, MOTHER AND FATHER".
    - predicate: not (CUS_Q12.outcome == 6)
      hint: Asked only when question CUS-Q12 is not "OTHER".
    items:
    - id: CUS_Q13
      kind: Question
      title: At that time, what type of contact did ... have with his/her other parent?
      input:
        control: Dropdown
        labels:
          1: 01 REGULAR VISITING, EVERY WEEK
          2: 02 REGULAR VISITING, EVERY TWO WEEKS
          3: 03 REGULAR VISITING, MONTHLY
          4: 04 IRREGULAR VISITING, ON HOLIDAYS ONLY
          5: 05 IRREGULAR VISITING, WITHOUT SET PATTERN
          6: 06 TELEPHONE OR LETTER CONTACT ONLY
          7: 07 NO CONTACT AT ALL
          8: 08 OTHER
          98: 98 DON'T KNOW
          99: 99 REFUSAL
    - id: CUS_Q14
      kind: Question
      title: Since then, how many times has the type of contact changed?
      input:
        control: Radio
        labels:
          1: NONE
          2: ONCE
          3: TWICE
          4: THREE TIMES
          5: FOUR OR MORE TIMES
          8: DON'T KNOW
          9: REFUSAL
    - id: CUS_Q15A
      kind: Question
      title: What type of contact does ... now have with his/her other parent?
      precondition:
      - predicate: not (CUS_Q9A.outcome in [1, 2, 5, 6, 8] or CUS_Q9B.outcome in [1, 2, 5, 6, 8])
        hint: Not asked when CUS-Q9A or CUS-Q9B is 1, 2, 5, 6 or 8
      - predicate: not (CUS_Q14.outcome == 1)
        hint: Asked only when question CUS-Q14 is not "NONE".
      input:
        control: Dropdown
        labels:
          1: 01 REGULAR VISITING, EVERY WEEK
          2: 02 REGULAR VISITING, EVERY TWO WEEKS
          3: 03 REGULAR VISITING, MONTHLY
          4: 04 IRREGULAR VISITING, ON HOLIDAYS ONLY
          5: 05 IRREGULAR VISITING, WITHOUT SET PATTERN
          6: 06 TELEPHONE OR LETTER CONTACT ONLY
          7: 07 LOST CONTACT COMPLETELY
          8: 08 CHILD NOW SHARES LIVING ARRANGEMENTS WITH OTHER PARENT
          9: 09 PARENTS NOW LIVING TOGETHER AGAIN
          10: 10 CHILD NOW LIVES WITH OTHER PARENT
          11: 11 OTHER
          98: 98 DON'T KNOW
          99: 99 REFUSAL
    - id: CUS_Q15B
      kind: Question
      title: How much time does ... live at his/her other parent's home? (MARK ALL THAT APPLY)
      precondition:
      - predicate: CUS_Q15A.outcome in [8, 10]
        hint: Asked only when question CUS-Q15A is one of "08 CHILD NOW SHARES LIVING ARRANGEMENTS WITH OTHER PARENT", "10 CHILD NOW LIVES WITH OTHER PARENT".
      - predicate: not (CUS_Q14.outcome == 1)
        hint: Asked only when question CUS-Q14 is not "NONE".
      - predicate: not (CUS_Q15A.outcome in [1, 2, 3, 4, 5, 6, 7, 11, 98])
        hint: Asked only when question CUS-Q15A is none of the visiting, lost contact, other or don't know answers.
      - predicate: not (CUS_Q15A.outcome == 9)
        hint: Asked only when question CUS-Q15A is not "09 PARENTS NOW LIVING TOGETHER AGAIN".
      input:
        control: Checkbox
        labels:
          1: 01 ON WEEKDAYS, NOT WEEKENDS
          2: 02 EVERY OTHER NIGHT
          4: 03 ONE WEEK OUT OF TWO
          8: 04 TWO WEEKS ALTERNATELY
          16: 05 EVERY WEEK END
          32: 06 ONE WEEKEND OUT OF TWO
          64: 07 LESS THAN TWO DAYS EVERY MONTH
          128: 08 SOME HOLIDAYS
          256: 09 NEVER
          512: 10 ALL THE TIME
          1024: 11 OTHER
          2048: 98 DON'T KNOW
          4096: 99 REFUSAL
  - id: b_s23_shared_time
    title: Shared time at the other parent's home
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    items:
    - id: CUS_Q16
      kind: Question
      title: At that time, how much time did ... live at his/her other parent's home? (MARK ALL THAT APPLY)
      precondition:
      - predicate: CUS_Q12.outcome in [3, 4, 5]
        hint: Asked only when question CUS-Q12 is a shared arrangement.
      - predicate: not (CUS_Q12.outcome == 6)
        hint: Asked only when question CUS-Q12 is not "OTHER".
      - predicate: not (CUS_Q14.outcome == 1)
        hint: Asked only when question CUS-Q14 is not "NONE".
      - predicate: not (CUS_Q15A.outcome in [1, 2, 3, 4, 5, 6, 7, 11, 98])
        hint: Asked only when question CUS-Q15A is none of the visiting, lost contact, other or don't know answers.
      - predicate: not (CUS_Q15A.outcome == 9)
        hint: Asked only when question CUS-Q15A is not "09 PARENTS NOW LIVING TOGETHER AGAIN".
      - predicate: CUS_Q15B.outcome is None or not (CUS_Q15B.outcome & 4096 == 0)
        hint: Asked only when CUS-Q15B, if answered, includes the refusal code.
      input:
        control: Checkbox
        labels:
          1: 01 ON WEEKDAYS, NOT WEEKENDS
          2: 02 EVERY OTHER NIGHT
          4: 03 ONE WEEK OUT OF TWO
          8: 04 TWO WEEKS ALTERNATELY
          16: 05 EVERY WEEKEND
          32: 06 ONE WEEKEND OUT OF TWO
          64: 07 LESS THAN TWO DAYS EVERY MONTH
          128: 08 SOME HOLIDAYS
          256: 09 OTHER
          512: 98 DON'T KNOW
          1024: 99 REFUSAL
  - id: b_s23_changes
    title: Changes in living arrangements over time
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    - predicate: not (CUS_Q14.outcome == 1)
      hint: Asked only when question CUS-Q14 is not "NONE".
    - predicate: not (CUS_Q15A.outcome in [1, 2, 3, 4, 5, 6, 7, 11, 98])
      hint: Asked only when question CUS-Q15A is none of the visiting, lost contact, other or don't know answers.
    - predicate: not (CUS_Q15A.outcome == 9)
      hint: Asked only when question CUS-Q15A is not "09 PARENTS NOW LIVING TOGETHER AGAIN".
    - predicate: CUS_Q15B.outcome is None or not (CUS_Q15B.outcome & 4096 == 0)
      hint: Asked only when CUS-Q15B, if answered, includes the refusal code.
    items:
    - id: CUS_Q17
      kind: Question
      title: How many times would you say these living arrangements have changed over time?
      input:
        control: Radio
        labels:
          1: NONE
          2: ONCE
          3: TWICE
          4: THREE TIMES
          5: FOUR OR MORE TIMES
          8: DON'T KNOW
          9: REFUSAL
    - id: CUS_Q18A
      kind: Question
      title: Currently, how much time does ... live at his/her other parent's home? (MARK ALL THAT APPLY.)
      precondition:
      - predicate: not (CUS_Q9A.outcome in [1, 2, 5, 6, 8] or CUS_Q9B.outcome in [1, 2, 5, 6, 8])
        hint: Not asked when CUS-Q9A or CUS-Q9B is 1, 2, 5, 6 or 8
      - predicate: not (CUS_Q17.outcome == 1)
        hint: Asked only when question CUS-Q17 is not "NONE".
      input:
        control: Checkbox
        labels:
          1: 01 ON WEEKDAYS, NOT WEEKENDS
          2: 02 EVERY OTHER NIGHT
          4: 03 ONE WEEK OUT OF TWO
          8: 04 TWO WEEKS ALTERNATELY
          16: 05 EVERY WEEK END
          32: 06 ONE WEEKEND OUT OF TWO
          64: 07 LESS THAN TWO DAYS EVERY MONTH
          128: 08 SOME HOLIDAYS
          256: 09 VISITS OR LETTER OR TELEPHONE CALLS ONLY
          512: 10 NO CONTACT
          1024: 11 ALL THE TIME
          2048: 12 PARENTS NOW LIVING TOGETHER AGAIN
          4096: 13 OTHER
          8192: 98 DON'T KNOW
          16384: 99 REFUSAL
    - id: CUS_Q18B
      kind: Question
      title: Which type of contact does ... now have with his/her other parent?
      precondition:
      - predicate: CUS_Q18A.outcome is not None and (CUS_Q18A.outcome & 256 > 0 and CUS_Q18A.outcome & 2048 == 0)
        hint: Asked only when CUS-Q18A includes visits/letter/telephone only and not parents living together again.
      - predicate: not (CUS_Q17.outcome == 1)
        hint: Asked only when question CUS-Q17 is not "NONE".
      input:
        control: Radio
        labels:
          1: REGULAR VISITING, EVERY WEEK
          2: REGULAR VISITING, EVERY TWO WEEKS
          3: REGULAR VISITING, MONTHLY
          4: IRREGULAR VISITING, ON HOLIDAYS ONLY
          5: IRREGULAR VISITING, WITHOUT SET PATTERN
          6: TELEPHONE OR LETTER CONTACT ONLY
          7: OTHER
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s23_custody
    title: Custody and tension
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    items:
    - id: CUS_Q19A
      kind: Question
      title: Has a court order modified the custody of ... since his/her parents separated (or divorced)?
      precondition:
      - predicate: not (CUS_Q15A.outcome == 9)
        hint: Asked only when question CUS-Q15A is not "09 PARENTS NOW LIVING TOGETHER AGAIN".
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: CUS_Q19B
      kind: Question
      title: 'Is he/she now in:'
      precondition:
      - predicate: CUS_Q19A.outcome == 1
        hint: Asked only when question CUS-Q19A is "YES".
      - predicate: not (CUS_Q15A.outcome == 9)
        hint: Asked only when question CUS-Q15A is not "09 PARENTS NOW LIVING TOGETHER AGAIN".
      - predicate: not (CUS_Q19A.outcome in [2, 8])
        hint: Asked only when question CUS-Q19A is none of "NO", "DON'T KNOW".
      input:
        control: Radio
        labels:
          1: Sole custody of mother?
          2: Sole custody of father?
          3: Shared physical custody of both parents?
          4: Other?
          8: DON'T KNOW
          9: REFUSAL
    - id: CUS_Q19C
      kind: Question
      title: 'Between ...''s parents, has the question of living arrangements or visiting rights been:'
      input:
        control: Radio
        labels:
          1: A great source of tension?
          2: Some source of tension?
          3: Very little source of tension?
          4: No source of tension at all?
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s24_unions
    title: Information on subsequent unions of child's mother
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    items:
    - id: CUS_Q20A
      kind: Question
      title: Has ...'s mother entered into another marriage, common-law relationship or common-law relationship that resulted in marriage? (MARK ALL THAT APPLY)
      input:
        control: Checkbox
        labels:
          1: 1 — YES, A MARRIAGE
          2: 2 — YES, A COMMON-LAW RELATIONSHIP
          4: 3 — YES, A COMMON-LAW RELATIONSHIP THAT RESULTED IN MARRIAGE
          8: 4 — NO
          16: 8 — DON'T KNOW
          32: 9 — REFUSAL
    - id: CUS_Q20B
      kind: Question
      title: When did ...'s mother start living with her new partner? MONTH YEAR |_|_| |_|_|
      precondition:
      - predicate: (CUS_Q20A.outcome & 6) > 0
      input:
        control: Textarea
    - id: CUS_Q20C
      kind: Question
      title: When did the marriage take place? MONTH YEAR |_|_| |_|_|
      precondition:
      - predicate: (CUS_Q20A.outcome & 5) > 0
      input:
        control: Textarea
    - id: CUS_Q20D
      kind: Question
      title: When they started living together, did ... live in the household with his/her mother's new partner?
      input:
        control: Radio
        labels:
          1: YES, FULL-TIME
          2: YES, PART-TIME
          3: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: CUS_Q20E
      kind: Question
      title: Did the mother's new partner have any children of his own?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s24_partner_children
    title: New partner's children
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    - predicate: CUS_Q20E.outcome == 1
      hint: Asked only when question CUS-Q20E is "YES".
    - predicate: not (CUS_Q20E.outcome in [2, 8])
      hint: Asked only when question CUS-Q20E is none of "NO", "DON'T KNOW".
    items:
    - id: CUS_Q20F
      kind: Question
      title: How many?
      postcondition:
      - predicate: CUS_Q20F.outcome >= 1
        hint: 'CUS-Q20F: si le conjoint a des enfants (CUS-Q20E = Yes), le nombre doit être au moins 1. Please enter at least 1, or correct CUS-Q20E.'
        invented: true
      input:
        control: Editbox
        min: 0
        max: 30
    - id: CUS_Q20G
      kind: Question
      title: Did he/she/they live in the household with their father? (MARK ALL THAT APPLY)
      input:
        control: Checkbox
        labels:
          1: 1 — YES, ALL OF THEM, FULL-TIME
          2: 2 — YES, ALL OF THEM, PART-TIME
          4: 3 — YES, SOME OF THEM, FULL-TIME
          8: 4 — YES, SOME OF THEM, PART-TIME
          16: 5 — NO, NONE OF THEM
          32: 8 — DON'T KNOW
          64: 9 — REFUSAL
  - id: b_s24_new_union_children
    title: Children of the new union
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    items:
    - id: CUS_Q20H
      kind: Question
      title: Did ...'s mother have any children with this new spouse/partner?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s25_early
    title: LIT - Early literacy
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    items:
    - id: LIT_Q4
      kind: Question
      title: How often does ... look at books, magazines, comics, etc. on his/her own? (Think about what he/she does at home only, do not include day care or school.)
      precondition:
      - predicate: AGE_3.outcome >= 2 and AGE_3.outcome <= 4
        hint: Asked only of children aged 2 to 4.
      input:
        control: Radio
        labels:
          1: 01 NEVER OR RARELY
          2: 02 LESS THAN ONCE A MONTH
          3: 03 ONCE A MONTH
          4: 04 A FEW TIMES A MONTH
          5: 05 ONCE A WEEK
          6: 06 A FEW TIMES A WEEK
          7: 07 DAILY
          8: 08 MANY TIMES EACH DAY
          98: 98 DON'T KNOW
          99: 99 REFUSAL
    - id: LIT_Q5
      kind: Question
      title: How often does he/she play with pencils or markers doing real or pretend writing?
      input:
        control: Radio
        labels:
          1: 01 NEVER OR RARELY
          2: 02 LESS THAN ONCE A MONTH
          3: 03 ONCE A MONTH
          4: 04 A FEW TIMES A MONTH
          5: 05 ONCE A WEEK
          6: 06 A FEW TIMES A WEEK
          7: 07 DAILY
          8: 08 MANY TIMES EACH DAY
          98: 98 DON'T KNOW
          99: 99 REFUSAL
    - id: LIT_Q6A
      kind: Question
      title: Have you or another adult ever read aloud to ... on a regular basis?
      precondition:
      - predicate: AGE_3.outcome == 5
        hint: Asked only when question AGE is 5.
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: LIT_Q6B1
      kind: Question
      title: How old was he/she when you started (to the nearest month of age)?
      precondition:
      - predicate: LIT_Q6A.outcome == 1
        hint: Asked only when question LIT-Q6A is "YES".
      - predicate: not (LIT_Q6A.outcome == 2)
        hint: Asked only when question LIT-Q6A is not "NO".
      postcondition:
      - predicate: LIT_Q6B1.outcome <= AGE_3.outcome * 12 + 11
        hint: 'LIT-Q6B1: l''âge (en mois) au début de la lecture ne peut pas dépasser l''âge actuel de l''enfant (AGE). The age when reading started cannot exceed the child''s current age.'
        invented: true
      input:
        control: Editbox
        min: 0
        max: 200
  - id: b_s25_reading_aloud
    title: LIT - Reading aloud
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    - predicate: not (LIT_Q6A.outcome == 2)
      hint: Asked only when question LIT-Q6A is not "NO".
    items:
    - id: LIT_Q7
      kind: Question
      title: Currently, how often do you or another adult read to him/her? (Also include if he/she reads or pretends to read to adult.)
      precondition:
      - predicate: AGE_3.outcome < 5
        hint: Asked only of children under 5.
      input:
        control: Radio
        labels:
          1: 01 NEVER OR RARELY
          2: 02 LESS THAN ONCE A MONTH
          3: 03 ONCE A MONTH
          4: 04 A FEW TIMES A MONTH
          5: 05 ONCE A WEEK
          6: 06 A FEW TIMES A WEEK
          7: 07 DAILY
          8: 08 MANY TIMES EACH DAY
          98: 98 DON'T KNOW
          99: 99 REFUSAL
    - id: LIT_Q7A
      kind: Question
      title: Currently, how often do you or another adult read aloud to him/her or listen to him/her read or attempt to read aloud?
      precondition:
      - predicate: AGE_3.outcome >= 5
        hint: Asked only of children aged 5 or older.
      input:
        control: Radio
        labels:
          1: 01 NEVER OR RARELY
          2: 02 LESS THAN ONCE A MONTH
          3: 03 ONCE A MONTH
          4: 04 A FEW TIMES A MONTH
          5: 05 ONCE A WEEK
          6: 06 A FEW TIMES A WEEK
          7: 07 DAILY
          8: 08 MANY TIMES EACH DAY
          98: 98 DON'T KNOW
          99: 99 REFUSAL
    - id: LIT_Q7B
      kind: Question
      title: Currently, how often do you or another adult read aloud to him/her or listen to him/her read?
      precondition:
      - predicate: AGE_3.outcome >= 8
        hint: Asked only of children aged 8 or older.
      input:
        control: Radio
        labels:
          1: 01 NEVER OR RARELY
          2: 02 LESS THAN ONCE A MONTH
          3: 03 ONCE A MONTH
          4: 04 A FEW TIMES A MONTH
          5: 05 ONCE A WEEK
          6: 06 A FEW TIMES A WEEK
          7: 07 DAILY
          8: 08 MANY TIMES EACH DAY
          98: 98 DON'T KNOW
          99: 99 REFUSAL
  - id: b_s25_writing
    title: LIT - Writing
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    items:
    - id: LIT_Q8
      kind: Question
      title: How often do you help or encourage him/her to write or pretend to write?
      precondition:
      - predicate: AGE_3.outcome <= 5
        hint: Asked only of children aged 5 or younger.
      input:
        control: Radio
        labels:
          1: 01 NEVER OR RARELY
          2: 02 LESS THAN ONCE A MONTH
          3: 03 ONCE A MONTH
          4: 04 A FEW TIMES A MONTH
          5: 05 ONCE A WEEK
          6: 06 A FEW TIMES A WEEK
          7: 07 DAILY
          8: 08 MANY TIMES EACH DAY
          98: 98 DON'T KNOW
          99: 99 REFUSAL
  - id: b_s25_homework_screen
    title: LIT - Homework
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    items:
    - id: LIT_Q9
      kind: Question
      title: How often is ... assigned homework?
      precondition:
      - predicate: AGE_3.outcome > 5
        hint: Asked only of children older than 5.
      input:
        control: Radio
        labels:
          1: NEVER
          2: LESS THAN ONCE A MONTH
          3: ONCE A MONTH
          4: A FEW TIMES A MONTH
          5: ONCE A WEEK
          6: A FEW TIMES A WEEK
          7: DAILY
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s25_homework_details
    title: LIT - Homework details
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    - predicate: LIT_Q9.outcome in [2, 3, 4, 5, 6, 7]
      hint: Asked only when question LIT-Q9 is one of "LESS THAN ONCE A MONTH", "ONCE A MONTH", "A FEW TIMES A MONTH", "ONCE A WEEK", "A FEW TIMES A WEEK", "DAILY".
    items:
    - id: LIT_Q10A
      kind: Question
      title: On days when he/she is assigned homework, how much time does he/she usually spend doing homework?
      input:
        control: Editbox
        min: 0
        max: 1440
    - id: LIT_Q11
      kind: Question
      title: How often do you check his/her homework or provide help with homework?
      input:
        control: Radio
        labels:
          1: NEVER OR RARELY
          2: LESS THAN ONCE A MONTH
          3: ONCE A MONTH
          4: A FEW TIMES A MONTH
          5: ONCE A WEEK
          6: A FEW TIMES A WEEK
          7: DAILY
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s25_own_reading
    title: LIT - Child's own reading
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    items:
    - id: LIT_Q12
      kind: Question
      title: How often does ... look at books or try to read on his/her own?
      input:
        control: Radio
        labels:
          1: 01 NEVER OR RARELY
          2: 02 LESS THAN ONCE A MONTH
          3: 03 ONCE A MONTH
          4: 04 A FEW TIMES A MONTH
          5: 05 ONCE A WEEK
          6: 06 A FEW TIMES A WEEK
          7: 07 DAILY
          8: 08 MANY TIMES EACH DAY
          98: 98 DON'T KNOW
          99: 99 REFUSAL
    - id: LIT_Q12A
      kind: Question
      title: How often does ... read for pleasure?
      precondition:
      - predicate: AGE_3.outcome != 6
        hint: Asked only when question AGE is not 6.
      - predicate: not (LIT_Q12.outcome != 99)
        hint: Asked only when question LIT-Q12 is 99.
      input:
        control: Radio
        labels:
          1: 01 NEVER OR RARELY
          2: 02 LESS THAN ONCE A MONTH
          3: 03 ONCE A MONTH
          4: 04 A FEW TIMES A MONTH
          5: 05 ONCE A WEEK
          6: 06 A FEW TIMES A WEEK
          7: 07 DAILY
          8: 08 MANY TIMES EACH DAY
          98: 98 DON'T KNOW
          99: 99 REFUSAL
    - id: LIT_Q13
      kind: Question
      title: How often does he/she talk about a book with family or friends?
      input:
        control: Radio
        labels:
          1: 01 NEVER OR RARELY
          2: 02 LESS THAN ONCE A MONTH
          3: 03 ONCE A MONTH
          4: 04 A FEW TIMES A MONTH
          5: 05 ONCE A WEEK
          6: 06 A FEW TIMES A WEEK
          7: 07 DAILY
          8: 08 MANY TIMES EACH DAY
          98: 98 DON'T KNOW
          99: 99 REFUSAL
    - id: LIT_Q14
      kind: Question
      title: How often does he/she go to the library, including the school library?
      input:
        control: Radio
        labels:
          1: 01 NEVER OR RARELY
          2: 02 LESS THAN ONCE A MONTH
          3: 03 ONCE A MONTH
          4: 04 A FEW TIMES A MONTH
          5: 05 ONCE A WEEK
          6: 06 A FEW TIMES A WEEK
          7: 07 DAILY
          8: 08 MANY TIMES EACH DAY
          98: 98 DON'T KNOW
          99: 99 REFUSAL
  - id: b_s26_early_childhood
    title: Early childhood programs
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    items:
    - id: ACT_Q1
      kind: Question
      title: Does he/she currently attend any nursery school, play group or other early childhood program or activity? (Please do not include child care programs or time spent in elementary school.)
      precondition:
      - predicate: AGE_3.outcome <= 5
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s26_early_details
    title: Early childhood program details
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    - predicate: ACT_Q1.outcome == 1
      hint: Asked only when question ACT-Q1 is "YES".
    items:
    - id: ACT_Q2A
      kind: Question
      title: What type(s) of programs or activities? (MARK ALL THAT APPLY.)
      input:
        control: Checkbox
        labels:
          1: 1 — NURSERY SCHOOL, PRESCHOOL OR KINDERGARTEN
          2: 2 — PLAY GROUP
          4: 3 — DROP-IN CENTRE
          8: 4 — TOY LIBRARY
          16: 5 — INFANT STIMULATION PROGRAM
          32: 6 — MOM AND TOT PROGRAM
          64: 7 — OTHER
          128: 8 — DON'T KNOW
          256: 9 — REFUSAL
    - id: ACT_Q2B
      kind: Question
      title: For about how many hours a week does he/she attend these in total?
      input:
        control: Editbox
        min: 0
        max: 168
  - id: b_s26_leisure
    title: Sports, lessons, clubs and screen time
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    items:
    - id: ACT_Q3A
      kind: Question
      title: 'In the last 12 months, outside of school hours, how often has ...: taken part in any sports which involved coaching or instruction?'
      precondition:
      - predicate: AGE_3.outcome >= 4
      input:
        control: Radio
        labels:
          1: MOST DAYS
          2: A FEW TIMES A WEEK
          3: ABOUT ONCE A WEEK
          4: ABOUT ONCE A MONTH
          5: ALMOST NEVER
          8: DON'T KNOW
          9: REFUSAL
    - id: ACT_Q3B
      kind: Question
      title: Taken part in unorganized sports or physical activities?
      input:
        control: Radio
        labels:
          1: MOST DAYS
          2: A FEW TIMES A WEEK
          3: ABOUT ONCE A WEEK
          4: ABOUT ONCE A MONTH
          5: ALMOST NEVER
          8: DON'T KNOW
          9: REFUSAL
    - id: ACT_Q3C
      kind: Question
      title: Taken lessons or instruction in music, dance, art or other non-sport activities?
      input:
        control: Radio
        labels:
          1: MOST DAYS
          2: A FEW TIMES A WEEK
          3: ABOUT ONCE A WEEK
          4: ABOUT ONCE A MONTH
          5: ALMOST NEVER
          8: DON'T KNOW
          9: REFUSAL
    - id: ACT_Q3D1
      kind: Question
      title: Taken part in any clubs, groups or community programs with leadership, such as Beavers, Sparks or church groups?
      precondition:
      - predicate: AGE_3.outcome >= 4 and AGE_3.outcome <= 5
      input:
        control: Radio
        labels:
          1: MOST DAYS
          2: A FEW TIMES A WEEK
          3: ABOUT ONCE A WEEK
          4: ABOUT ONCE A MONTH
          5: ALMOST NEVER
          8: DON'T KNOW
          9: REFUSAL
    - id: ACT_Q3D2
      kind: Question
      title: Taken part in any clubs, groups or community programs with leadership, such as Brownies, Cubs or church groups?
      precondition:
      - predicate: AGE_3.outcome >= 6 and AGE_3.outcome <= 9
      - predicate: ACT_Q3D1.outcome is None or not (ACT_Q3D1.outcome >= 1)
      input:
        control: Radio
        labels:
          1: MOST DAYS
          2: A FEW TIMES A WEEK
          3: ABOUT ONCE A WEEK
          4: ABOUT ONCE A MONTH
          5: ALMOST NEVER
          8: DON'T KNOW
          9: REFUSAL
    - id: ACT_Q3D3
      kind: Question
      title: Taken part in any clubs, groups or community programs with leadership, such as Boys and Girls Clubs, Scouts, Guides or church groups?
      precondition:
      - predicate: AGE_3.outcome >= 10 and AGE_3.outcome <= 11
      - predicate: ACT_Q3D1.outcome is None or not (ACT_Q3D1.outcome >= 1)
      - predicate: ACT_Q3D2.outcome is None or not (ACT_Q3D2.outcome >= 1)
      input:
        control: Radio
        labels:
          1: MOST DAYS
          2: A FEW TIMES A WEEK
          3: ABOUT ONCE A WEEK
          4: ABOUT ONCE A MONTH
          5: ALMOST NEVER
          8: DON'T KNOW
          9: REFUSAL
    - id: ACT_Q3E
      kind: Question
      title: Played computer or video games?
      input:
        control: Radio
        labels:
          1: MOST DAYS
          2: A FEW TIMES A WEEK
          3: ABOUT ONCE A WEEK
          4: ABOUT ONCE A MONTH
          5: ALMOST NEVER
          8: DON'T KNOW
          9: REFUSAL
    - id: ACT_Q4A
      kind: Question
      title: About how many days a week on average does ... watch T.V. or videos at home?
      input:
        control: Radio
        labels:
          0: NONE
          1: '1'
          2: '2'
          3: '3'
          4: '4'
          5: '5'
          6: '6'
          7: '7'
          8: DON'T KNOW
          9: REFUSAL
    - id: ACT_Q4B
      kind: Question
      title: On those days, how many hours on average does he/she spend watching T.V. or videos?
      precondition:
      - predicate: ACT_Q4A.outcome in [1, 2, 3, 4, 5, 6, 7]
        hint: Asked only when question ACT-Q4A is one of 1, 2, 3, 4, 5, 6, 7.
      - predicate: not (ACT_Q4A.outcome in [0, 8])
        hint: Asked only when question ACT-Q4A is none of "NONE", "DON'T KNOW".
      input:
        control: Editbox
        min: 0
        max: 24
    - id: ACT_Q5
      kind: Question
      title: How often does he/she play alone (e.g., riding a bike, doing a craft or hobby, playing ball)?
      input:
        control: Radio
        labels:
          1: OFTEN
          2: SOMETIMES
          3: SELDOM
          4: NEVER
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s26_chores
    title: Responsibilities at home
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    items:
    - id: ACT_Q6A
      kind: Question
      title: I would like to ask you some questions about his/her responsibilities at home. How often does he/she make his/her own bed?
      precondition:
      - predicate: AGE_3.outcome >= 10
      input:
        control: Radio
        labels:
          1: OFTEN
          2: SOMETIMES
          3: SELDOM
          4: NEVER
          8: DON'T KNOW
          9: REFUSAL
    - id: ACT_Q6B
      kind: Question
      title: Clean his/her own room?
      input:
        control: Radio
        labels:
          1: OFTEN
          2: SOMETIMES
          3: SELDOM
          4: NEVER
          8: DON'T KNOW
          9: REFUSAL
    - id: ACT_Q6C
      kind: Question
      title: Pick up after him/herself?
      input:
        control: Radio
        labels:
          1: OFTEN
          2: SOMETIMES
          3: SELDOM
          4: NEVER
          8: DON'T KNOW
          9: REFUSAL
    - id: ACT_Q6D
      kind: Question
      title: Help keep shared living areas clean and straight?
      input:
        control: Radio
        labels:
          1: OFTEN
          2: SOMETIMES
          3: SELDOM
          4: NEVER
          8: DON'T KNOW
          9: REFUSAL
    - id: ACT_Q6E
      kind: Question
      title: Do routine chores such as mow the lawn, help with dinner, wash dishes, etc.?
      input:
        control: Radio
        labels:
          1: OFTEN
          2: SOMETIMES
          3: SELDOM
          4: NEVER
          8: DON'T KNOW
          9: REFUSAL
    - id: ACT_Q6F
      kind: Question
      title: Help manage his/her own time (get up on time, be ready for school, etc.)
      input:
        control: Radio
        labels:
          1: OFTEN
          2: SOMETIMES
          3: SELDOM
          4: NEVER
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s26_camps
    title: Camps
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    items:
    - id: ACT_Q7A
      kind: Question
      title: Did ... attend an overnight camp last summer?
      precondition:
      - predicate: AGE_3.outcome >= 6
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: ACT_Q7B
      kind: Question
      title: For how many days?
      precondition:
      - predicate: ACT_Q7A.outcome == 1
        hint: Asked only when question ACT-Q7A is "YES".
      - predicate: not (ACT_Q7A.outcome in [2, 8])
        hint: Asked only when question ACT-Q7A is none of "NO", "DON'T KNOW".
      input:
        control: Editbox
        min: 0
        max: 92
    - id: ACT_Q8A
      kind: Question
      title: Last summer, did ... attend a day camp or recreational or skill-building activity that ran for half days or full days (e.g., music program, reading program, athletic program?)
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: ACT_Q8B
      kind: Question
      title: For how many days?
      precondition:
      - predicate: ACT_Q8A.outcome == 1
        hint: Asked only when question ACT-Q8A is "YES".
      input:
        control: Editbox
        min: 0
        max: 92
  - id: b_s27_behaviour
    title: Behaviour
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of YES, DON'T KNOW, REFUSAL.
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not REFUSAL.
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not REFUSAL.
    items:
    - id: BEH_Q1
      kind: Question
      title: The following questions relate to ...'s sleep patterns. When you put him/her to bed, how often does he/she have trouble falling asleep? (READ LIST. MARK ONE ONLY.)
      precondition:
      - predicate: AGE_3.outcome <= 3
        hint: Asked only for children aged 3 or younger.
      input:
        control: Radio
        labels:
          1: Almost every time
          2: Often
          3: About half of the time
          4: Sometimes
          5: Almost never
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q2
      kind: Question
      title: Does he/she have a particular and long routine (more than 30 minutes) to go to bed (rocking, songs, nursery rhymes, etc.) that he/she cannot go to sleep without?
      input:
        control: Radio
        labels:
          1: ALMOST EVERY TIME
          2: OFTEN
          3: ABOUT HALF OF THE TIME
          4: SOMETIMES
          5: ALMOST NEVER
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q3
      kind: Question
      title: Does ... wake up several times during his/her sleep?
      input:
        control: Radio
        labels:
          1: ALMOST EVERY TIME
          2: OFTEN
          3: ABOUT HALF OF THE TIME
          4: SOMETIMES
          5: ALMOST NEVER
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q4
      kind: Question
      title: Does he/she have a restless sleep?
      input:
        control: Radio
        labels:
          1: ALMOST EVERY TIME
          2: OFTEN
          3: ABOUT HALF OF THE TIME
          4: SOMETIMES
          5: ALMOST NEVER
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q5
      kind: Question
      title: The following are a few examples of how infants react to new foods (orange juice, apple purée, porridge, vegetables, etc.). Which of the following is the best approximation of how ... reacts?
      precondition:
      - predicate: AGE_3.outcome >= 1
        hint: Asked only for children aged 1 or older.
      input:
        control: Radio
        labels:
          1: He/she swallows everything without complaining
          2: The first time he/she made faces or spit out the food, but after a few tries, he/she got used to it
          3: The same reaction after several attempts, he/she continued to refuse most of the new foods
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q5A
      kind: Question
      title: How often do you find him/her difficult to feed?
      precondition:
      - predicate: AGE_3.outcome < 1
        hint: Asked only for children younger than 1.
      input:
        control: Radio
        labels:
          1: ALMOST EVERY TIME
          2: OFTEN
          3: ABOUT HALF OF THE TIME
          4: SOMETIMES
          5: ALMOST NEVER
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q6A
      kind: Question
      title: 'Using the answers never or not true, sometimes or somewhat true, or often or very true, how often would you say that ...: shows sympathy to someone who has made a mistake?'
      precondition:
      - predicate: AGE_3.outcome >= 4
        hint: Asked only for children aged 4 or older.
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q6B
      kind: Question
      title: Can't sit still, is restless, or hyperactive?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q6C
      kind: Question
      title: Destroys his/her own things?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q6D
      kind: Question
      title: Will try to help someone who has been hurt?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q6E
      kind: Question
      title: Steals at home?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q6F
      kind: Question
      title: Seems to be unhappy, sad, or depressed?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q6G
      kind: Question
      title: Gets into many fights?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q6H
      kind: Question
      title: Volunteers to help clear up a mess someone else has made?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q6I
      kind: Question
      title: Is distractible, has trouble sticking to any activity?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q6J
      kind: Question
      title: When mad at someone, tries to get others to dislike that person?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q6K
      kind: Question
      title: Is not as happy as other children?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q6L
      kind: Question
      title: Destroys things belonging to his/her family, or other children?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q6M
      kind: Question
      title: If there is a quarrel or dispute, will try to stop it?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q6N
      kind: Question
      title: Fidgets?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q6O
      kind: Question
      title: Is disobedient at school?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q6P
      kind: Question
      title: Can't concentrate, can't pay attention for long?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q6Q
      kind: Question
      title: Is too fearful or anxious?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q6R
      kind: Question
      title: When mad at someone, becomes friends with another as revenge?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q6S
      kind: Question
      title: Is impulsive, acts without thinking?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q6T
      kind: Question
      title: Tells lies or cheats?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q6U
      kind: Question
      title: Offers to help other children (friend, brother or sister) who are having difficulty with a task?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q6V
      kind: Question
      title: Is worried?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q6W
      kind: Question
      title: Has difficulty awaiting turn in games or groups?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q6X
      kind: Question
      title: When another child accidentally hurts him/her (such as by bumping into him/her), assumes that the other child meant to do it, and then reacts with anger and fighting?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q6Y
      kind: Question
      title: Tends to do things on his/her own - is rather solitary?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q6Z
      kind: Question
      title: When mad at someone, says bad things behind the other's back?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q6AA
      kind: Question
      title: Physically attacks people?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q6BB
      kind: Question
      title: Comforts a child (friend, brother, or sister) who is crying or upset?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q6CC
      kind: Question
      title: Cries a lot?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q6DD
      kind: Question
      title: Vandalizes?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q6EE
      kind: Question
      title: Gives up easily?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q6FF
      kind: Question
      title: Threatens people?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q6GG
      kind: Question
      title: Spontaneously helps to pick up objects which another child has dropped (e.g. pencils, books, etc.)?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q6HH
      kind: Question
      title: Cannot settle to anything for more than a few moments?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q6II
      kind: Question
      title: Appears miserable, unhappy, tearful, or distressed?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q6JJ
      kind: Question
      title: Is cruel, bullies or is mean to others?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q6KK
      kind: Question
      title: Stares into space?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q6LL
      kind: Question
      title: 'When mad at someone, says to others: let''s not be with him/her?'
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q6MM
      kind: Question
      title: Is nervous, highstrung or tense?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q6NN
      kind: Question
      title: Kicks, bites, hits other children?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q6OO
      kind: Question
      title: Will invite bystanders to join in a game?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q6PP
      kind: Question
      title: Steals outside the home?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q6QQ
      kind: Question
      title: Is inattentive?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q6RR
      kind: Question
      title: Has trouble enjoying him/herself?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q6SS
      kind: Question
      title: Helps other children (friends, brother or sister) who are feeling sick?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q6TT
      kind: Question
      title: When mad at someone, tells the other one's secrets to a third person?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q6UU
      kind: Question
      title: Takes the opportunity to praise the work of less able children?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q7A
      kind: Question
      title: In the past year, about how many times has ... stayed out later than you said he/she should?
      precondition:
      - predicate: AGE_3.outcome >= 10
        hint: Asked only for children aged 10 or older.
      input:
        control: Radio
        labels:
          1: NEVER
          2: ONCE
          3: TWICE
          4: MORE THAN TWICE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q7B
      kind: Question
      title: Stayed out all night without permission?
      input:
        control: Radio
        labels:
          1: NEVER
          2: ONCE
          3: TWICE
          4: MORE THAN TWICE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q7C
      kind: Question
      title: Skipped a day of school without permission?
      input:
        control: Radio
        labels:
          1: NEVER
          2: ONCE
          3: TWICE
          4: MORE THAN TWICE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q7D
      kind: Question
      title: Gotten drunk?
      input:
        control: Radio
        labels:
          1: NEVER
          2: ONCE
          3: TWICE
          4: MORE THAN TWICE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q7E
      kind: Question
      title: Been questioned by the police about anything he/she might have done such as stealing, damaging property, or something else?
      input:
        control: Radio
        labels:
          1: NEVER
          2: ONCE
          3: TWICE
          4: MORE THAN TWICE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q7F
      kind: Question
      title: Has he/she ever run away from home?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q8B
      kind: Question
      title: 'Using the answers never or not true, sometimes or somewhat true, or often or very true, how often would you say that ...: can''t sit still, is restless, or hyperactive?'
      precondition:
      - predicate: AGE_3.outcome >= 2 and AGE_3.outcome <= 3
        hint: Asked only for children aged 2 to 3.
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q8D
      kind: Question
      title: Will try to help someone who has been hurt?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q8E1
      kind: Question
      title: Is defiant?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q8F
      kind: Question
      title: Seems to be unhappy, sad, or depressed?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q8G
      kind: Question
      title: Gets into many fights?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q8I
      kind: Question
      title: Is distractible, has trouble sticking to any activity?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q8J1
      kind: Question
      title: Doesn't seem to feel guilty after misbehaving?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q8K
      kind: Question
      title: Is not as happy as other children?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q8N
      kind: Question
      title: Fidgets?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q8P
      kind: Question
      title: Can't concentrate, can't pay attention for long?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q8Q
      kind: Question
      title: Is too fearful or anxious?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q8R1
      kind: Question
      title: Punishment doesn't change his/her behaviour?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q8S
      kind: Question
      title: Is impulsive, acts without thinking?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q8T1
      kind: Question
      title: Has temper tantrums or hot temper?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q8U
      kind: Question
      title: Offers to help other children (friend, brother or sister) who are having difficulty with a task?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q8V
      kind: Question
      title: Is worried?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q8W
      kind: Question
      title: Has difficulty awaiting turn in games or groups?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q8X
      kind: Question
      title: When another child accidentally hurts him/her (such as by bumping into him/her), assumes that the other child meant to do it, and then reacts with anger and fighting?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q8Z1
      kind: Question
      title: Has angry moods?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q8BB
      kind: Question
      title: Comforts a child (friend, brother, or sister) who is crying or upset?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q8CC
      kind: Question
      title: Cries a lot?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q8DD1
      kind: Question
      title: Clings to adults or is too dependent?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q8EE
      kind: Question
      title: Gives up easily?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q8HH
      kind: Question
      title: Cannot settle to anything for more than a few moments?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q8KK
      kind: Question
      title: Stares into space?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q8LL1
      kind: Question
      title: Constantly seeks help?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q8MM
      kind: Question
      title: Is nervous, highstrung or tense?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q8NN
      kind: Question
      title: Kicks, bites, hits other children?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q8PP1
      kind: Question
      title: Doesn't want to sleep alone?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q8QQ
      kind: Question
      title: Is inattentive?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q8RR
      kind: Question
      title: Has trouble enjoying him/herself?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q8SS
      kind: Question
      title: Helps other children (friends, brother or sister) who are feeling sick?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q8TT
      kind: Question
      title: Gets too upset when separated from parents?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
    - id: BEH_Q8UU
      kind: Question
      title: Takes the opportunity to praise the work of less able children?
      input:
        control: Radio
        labels:
          1: NEVER OR NOT TRUE
          2: SOMETIMES OR SOMEWHAT TRUE
          3: OFTEN OR VERY TRUE
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s28_external_inputs
    title: EXTERNAL INPUTS
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    items:
    - id: AGE_4
      kind: Question
      title: Age in years of the selected child (value used by the LIT, ACT and BEH routing; from the sample/earlier part)
      external: true
      input:
        control: Editbox
        min: 0
        max: 17
        right: years
    - id: ELDEST_SIBLING_SAME_SEPARATION
      kind: Question
      title: 'Derived flag for CUS-C20A: eldest selected child''s custody section completed AND selected child is a full sibling by birth AND parents separated after eldest child''s birth, neither remarried, and this child born before the separation (1 = yes, 2 = no)'
      external: true
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
  - id: b_s29_preamble
    title: 'Motor and social development: setup'
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    items:
    - id: AGE_5
      kind: Question
      title: 'Age of the selected child in years (external input: from the sample/household file; referenced by the routing as AGE)'
      external: true
      input:
        control: Editbox
        min: 0
        max: 11
    - id: AGE_MONTHS
      kind: Question
      title: 'Age of the selected child in months (external input: from the sample/household file; referenced as AGE IN MONTHS)'
      external: true
      input:
        control: Editbox
        min: 0
        max: 47
    - id: PROVINCE
      kind: Question
      title: 'Province of residence (external input: from the sample file; referenced as PROVINCE IS ...)'
      external: true
      input:
        control: Radio
        labels:
          1: NEWFOUNDLAND
          2: QUEBEC
          3: ONTARIO
          4: NOVA SCOTIA
          5: P.E.I.
          6: OTHERWISE (New Brunswick, Manitoba, Saskatchewan, Alberta, British Columbia)
    - id: SIBLINGS_IN_HH
      kind: Question
      title: 'Whether there are brothers or sisters of the selected child living in the household (external input: household roster; used in REL-C9)'
      external: true
      input:
        control: Radio
        labels:
          1: BROTHERS OR SISTERS LIVING IN THE HOUSEHOLD
          2: NO BROTHERS OR SISTERS LIVING IN THE HOUSEHOLD
    - id: RESP_REL
      kind: Question
      title: 'Respondent''s relationship to the selected child (external input: household roster; used in the PARENTING note and PAR-C1)'
      external: true
      input:
        control: Radio
        labels:
          1: BIRTH, STEP OR ADOPTIVE PARENT
          2: FOSTER PARENT
          3: OTHER
    - id: RESP_PMK
      kind: Question
      title: 'Whether the respondent is the person most knowledgeable about the child, or that person''s spouse/partner (external input: household roster; used in PAR-C1)'
      external: true
      input:
        control: Radio
        labels:
          1: RESPONDENT IS THE PMK OR THE PMK'S SPOUSE/PARTNER
          2: 'NO'
  - id: b_s29_0_3_months
    title: 'Milestones: up to 3 months'
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    - predicate: AGE_MONTHS.outcome <= 3
      hint: Asked of children aged 3 months or less.
    items:
    - id: MSD_Q1
      kind: Question
      title: When lying on his/her stomach, has ... ever turned his/her head from side to side?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: MSD_Q2
      kind: Question
      title: Have his/her eyes ever followed a moving object?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: MSD_Q3
      kind: Question
      title: When lying on his/her stomach on a flat surface, has he/she ever lifted his/her head off the surface for a moment?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: MSD_Q4
      kind: Question
      title: Have his/her eyes ever followed a moving object all the way from one side to the other?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: MSD_Q5
      kind: Question
      title: Has he/she ever smiled at someone when that person talked to or smiled at (but did not touch) him/her?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: MSD_Q6
      kind: Question
      title: When lying on his/her stomach, has he/she ever raised his/her head and chest from the surface while resting his/her weight on his/her lower arms or hands?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: MSD_Q7
      kind: Question
      title: Has he/she ever turned his/her head around to look at something?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s29_0_6_months
    title: 'Milestones: up to 6 months'
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    - predicate: AGE_MONTHS.outcome <= 6
      hint: Asked of children aged 6 months or less.
    items:
    - id: MSD_Q8
      kind: Question
      title: When lying on his/her back and being pulled up to a sitting position, did ... ever hold his/her head stiffly so that it did not hang back as he/she was pulled up?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: MSD_Q9
      kind: Question
      title: Has he/she ever laughed out loud without being tickled or touched?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: MSD_Q10
      kind: Question
      title: Has he/she ever held in one hand a moderate size object such as a block or a rattle?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: MSD_Q11
      kind: Question
      title: Has he/she ever rolled over on his/her own on purpose?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s29_0_9_months
    title: 'Milestones: up to 9 months'
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    - predicate: AGE_MONTHS.outcome <= 9
      hint: Asked of children aged 9 months or less.
    items:
    - id: MSD_Q12
      kind: Question
      title: Has ... ever seemed to enjoy looking in the mirror at him/herself?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: MSD_Q13
      kind: Question
      title: Has he/she ever been pulled from a sitting to a standing position and supported his/her own weight with legs stretched out?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: MSD_Q14
      kind: Question
      title: Has he/she ever looked around with his/her eyes for a toy which was lost or not nearby?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: MSD_Q15
      kind: Question
      title: Has he/she ever sat alone with no help except for leaning forward on his/her hands or with just a little help from someone else?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s29_4_9_months
    title: 'Milestones: 4 to 9 months'
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    - predicate: AGE_MONTHS.outcome >= 4 and AGE_MONTHS.outcome <= 9
      hint: Asked of children aged 4 to 9 months.
    items:
    - id: MSD_Q16
      kind: Question
      title: Has he/she ever sat for 10 minutes without any support at all?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: MSD_Q17
      kind: Question
      title: Has he/she ever pulled him/herself to a standing position without help from another person?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s29_4_12_months
    title: 'Milestones: 4 to 12 months'
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    - predicate: AGE_MONTHS.outcome >= 4 and AGE_MONTHS.outcome <= 12
      hint: Asked of children aged 4 to 12 months.
    items:
    - id: MSD_Q18
      kind: Question
      title: Has ... ever crawled when left lying on his/her stomach?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: MSD_Q19
      kind: Question
      title: Has he/she ever said any recognizable words such as "mama" or "dada"?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: MSD_Q20
      kind: Question
      title: Has he/she ever picked up small objects such as raisins or cookie crumbs, using only his/her thumb and first finger?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: MSD_Q21
      kind: Question
      title: Has he/she ever walked at least 2 steps with one hand held or holding on to something?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s29_q22
    title: 'Milestones: 4 to 15 months'
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    items:
    - id: MSD_Q22
      kind: Question
      title: Has ... ever waved good-bye without help from another person?
      precondition:
      - predicate: AGE_MONTHS.outcome >= 4 and AGE_MONTHS.outcome <= 15
        hint: Asked of children aged 4 to 15 months.
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s29_7_15_months
    title: 'Milestones: 7 to 15 months'
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    - predicate: AGE_MONTHS.outcome >= 7 and AGE_MONTHS.outcome <= 15
      hint: Asked of children aged 7 to 15 months.
    items:
    - id: MSD_Q23
      kind: Question
      title: Has he/she ever shown by his/her behavior that he/she knows the names of common objects when somebody else names them out loud?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: MSD_Q24
      kind: Question
      title: Has he/she ever shown that he/she wanted something by pointing, pulling, or making pleasant sounds rather than crying or whining?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: MSD_Q25
      kind: Question
      title: Has he/she ever stood alone on his/her feet for 10 seconds or more without holding on to anything or another person?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s29_q26
    title: 'Milestones: 7 to 18 months'
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    items:
    - id: MSD_Q26
      kind: Question
      title: Has ... ever walked at least 2 steps without holding on to anything or another person?
      precondition:
      - predicate: AGE_MONTHS.outcome >= 7 and AGE_MONTHS.outcome <= 18
        hint: Asked of children aged 7 to 18 months.
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s29_10_18_months
    title: 'Milestones: 10 to 18 months'
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    - predicate: AGE_MONTHS.outcome >= 10 and AGE_MONTHS.outcome <= 18
      hint: Asked of children aged 10 to 18 months.
    items:
    - id: MSD_Q27
      kind: Question
      title: Has he/she ever crawled up at least 2 stairs or steps?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: MSD_Q28
      kind: Question
      title: Has he/she said 2 recognizable words besides "mama" or "dada"?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s29_10_21_months
    title: 'Milestones: 10 to 21 months'
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    - predicate: AGE_MONTHS.outcome >= 10 and AGE_MONTHS.outcome <= 21
      hint: Asked of children aged 10 to 21 months.
    items:
    - id: MSD_Q29
      kind: Question
      title: Has ... ever run?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: MSD_Q30
      kind: Question
      title: Has he/she ever said the name of a familiar object, such as a ball?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: MSD_Q31
      kind: Question
      title: Has he/she ever made a line with a crayon or pencil?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: MSD_Q32
      kind: Question
      title: Did he/she ever walk up at least 2 stairs with one hand held or holding the railing?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s29_q33
    title: 'Milestones: 13 to 21 months'
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    items:
    - id: MSD_Q33
      kind: Question
      title: Has he/she ever fed him/herself with a spoon or fork without spilling much?
      precondition:
      - predicate: AGE_MONTHS.outcome >= 13 and AGE_MONTHS.outcome <= 21
        hint: Asked of children aged 13 to 21 months.
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s29_13_plus_months
    title: 'Milestones: 13 months and older'
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    - predicate: AGE_MONTHS.outcome >= 13
      hint: Asked of children aged 13 months or more.
    items:
    - id: MSD_Q34
      kind: Question
      title: Has ... ever let someone know, without crying, that wearing wet (soiled) pants or diapers bothered him/her?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: MSD_Q35
      kind: Question
      title: Has he/she ever spoken a partial sentence of 3 words or more?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: MSD_Q36
      kind: Question
      title: Has he/she ever walked up stairs by him/herself without holding on to a rail?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s29_16_plus_months
    title: 'Milestones: 16 months and older'
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    - predicate: AGE_MONTHS.outcome >= 16
      hint: Asked of children aged 16 months or more.
    items:
    - id: MSD_Q37
      kind: Question
      title: Has he/she ever washed and dried his/her hands without any help except for turning the water on and off?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: MSD_Q38
      kind: Question
      title: Has he/she ever counted 3 objects correctly?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: MSD_Q39
      kind: Question
      title: Has he/she ever gone to the toilet alone?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: MSD_Q40
      kind: Question
      title: Has he/she ever walked upstairs by him/herself with no help, stepping on each step with only one foot?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s29_19_plus_months
    title: 'Milestones: 19 months and older'
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    - predicate: AGE_MONTHS.outcome >= 19
      hint: Asked of children aged 19 months or more.
    items:
    - id: MSD_Q41
      kind: Question
      title: Does he/she know his/her own age and sex?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: MSD_Q42
      kind: Question
      title: Has he/she ever said the names of at least 4 colors?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: MSD_Q43
      kind: Question
      title: Has he/she ever pedaled a tricycle at least 10 feet?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s29_22_plus_months
    title: 'Milestones: 22 months and older'
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    - predicate: AGE_MONTHS.outcome >= 22
      hint: Asked of children aged 22 months or more.
    items:
    - id: MSD_Q44
      kind: Question
      title: Has he/she ever done a somersault without help from anybody?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: MSD_Q45
      kind: Question
      title: Has he/she ever dressed him/herself without any help except for tying shoes (and buttoning the backs of dresses)?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: MSD_Q46
      kind: Question
      title: Has he/she ever said his/her first and last name together without someone's help? (Nickname may be used for first name.)
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: MSD_Q47
      kind: Question
      title: Has he/she ever counted out loud up to 10?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: MSD_Q48
      kind: Question
      title: Has he/she ever drawn a picture of a man or woman with at least 2 parts of the body besides a head?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s30_friends_days
    title: RELATIONSHIPS
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    items:
    - id: REL_Q1
      kind: Question
      title: About how many days a week does he/she do things with friends?
      precondition:
      - predicate: AGE_5.outcome >= 4 and AGE_5.outcome <= 11
        hint: Asked only of children aged 4 to 11
      input:
        control: Radio
        labels:
          1: NEVER
          2: 1 DAY A WEEK
          3: 2-3 DAYS A WEEK
          4: 4-5 DAYS A WEEK
          5: 6-7 DAYS A WEEK
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s30_close_friends
    title: Close friends
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    items:
    - id: REL_Q2
      kind: Question
      title: About how many close friends does he/she have?
      precondition:
      - predicate: AGE_5.outcome >= 6 and AGE_5.outcome <= 11
        hint: Asked only of children aged 6 to 11
      - predicate: not (REL_Q1.outcome != 9 and AGE_5.outcome < 6)
        hint: Not asked of children under 6 who answered the friends question
      input:
        control: Radio
        labels:
          1: NONE
          2: '1'
          3: 2 OR 3
          4: 4 OR 5
          5: 6 OR MORE
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s30_know_friends
    title: Knowing close friends
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    items:
    - id: REL_Q3
      kind: Question
      title: How many of his/her close friends do you know by sight and by first and last name?
      precondition:
      - predicate: AGE_5.outcome >= 8 and AGE_5.outcome <= 11
        hint: Asked only of children aged 8 to 11
      - predicate: not (REL_Q1.outcome != 9 and AGE_5.outcome < 6)
        hint: Not asked of children under 6 who answered the friends question
      - predicate: not (REL_Q2.outcome == 1 and AGE_5.outcome >= 8)
        hint: Not asked when the child has no close friends
      - predicate: not (REL_Q2.outcome == 1 and AGE_5.outcome < 8)
        hint: Not asked when the child has no close friends
      - predicate: not (REL_Q2.outcome != 1 and REL_Q2.outcome != 9 and AGE_5.outcome < 8)
        hint: Not asked of children under 8
      input:
        control: Radio
        labels:
          1: ALL
          2: MOST
          3: ABOUT HALF
          4: ONLY A FEW
          5: NONE
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s30_new_friends
    title: Making friends
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    - predicate: AGE_5.outcome >= 8 and AGE_5.outcome <= 11
      hint: Asked only of children aged 8 to 11
    - predicate: not (REL_Q1.outcome != 9 and AGE_5.outcome < 6)
      hint: Not asked of children under 6 who answered the friends question
    - predicate: not (REL_Q2.outcome == 1 and AGE_5.outcome < 8)
      hint: Not asked of children under 8 with no close friends
    - predicate: not (REL_Q2.outcome != 1 and REL_Q2.outcome != 9 and AGE_5.outcome < 8)
      hint: Not asked of children under 8
    items:
    - id: REL_Q4
      kind: Question
      title: 'When it comes to meeting new children and making new friends is he/she :'
      input:
        control: Radio
        labels:
          1: Somewhat shy?
          2: About average?
          3: Very outgoing - makes friends easily?
          8: DON'T KNOW
          9: REFUSAL
    - id: REL_Q5
      kind: Question
      title: How often does he/she hang around with kids you think are frequently in trouble?
      input:
        control: Radio
        labels:
          1: OFTEN
          2: SOMETIMES
          3: SELDOM
          4: NEVER
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s30_getting_along
    title: Getting along with others
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    items:
    - id: REL_Q6
      kind: Question
      title: During the past 6 months, how well has ... gotten along with other kids, such as friends or classmates (excluding brothers or sisters)?
      input:
        control: Radio
        labels:
          1: VERY WELL, NO PROBLEMS
          2: QUITE WELL, HARDLY ANY PROBLEMS
          3: PRETTY WELL, OCCASIONAL PROBLEMS
          4: NOT TOO WELL, FREQUENT PROBLEMS
          5: NOT WELL AT ALL, CONSTANT PROBLEMS
          6: NOT APPLICABLE
          8: DON'T KNOW
          9: REFUSAL
    - id: REL_Q7
      kind: Question
      title: Since starting school in the fall, how well has he/she gotten along with his/her teacher(s) at school?
      input:
        control: Radio
        labels:
          1: VERY WELL, NO PROBLEMS
          2: QUITE WELL, HARDLY ANY PROBLEMS
          3: PRETTY WELL, OCCASIONAL PROBLEMS
          4: NOT TOO WELL, FREQUENT PROBLEMS
          5: NOT WELL AT ALL, CONSTANT PROBLEMS
          6: NOT APPLICABLE
          8: DON'T KNOW
          9: REFUSAL
    - id: REL_Q8
      kind: Question
      title: During the past 6 months, how well has he/she gotten along with his/her parent(s)?
      input:
        control: Radio
        labels:
          1: VERY WELL, NO PROBLEMS
          2: QUITE WELL, HARDLY ANY PROBLEMS
          3: PRETTY WELL, OCCASIONAL PROBLEMS
          4: NOT TOO WELL, FREQUENT PROBLEMS
          5: NOT WELL AT ALL, CONSTANT PROBLEMS
          6: NOT APPLICABLE
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s30_siblings
    title: Brothers and sisters
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    items:
    - id: REL_Q9
      kind: Question
      title: During the past 6 months, how well has ... gotten along with his/her brother(s)/sister(s)?
      precondition:
      - predicate: SIBLINGS_IN_HH.outcome == 1
        hint: Asked only when question SIBLINGS_IN_HH is "BROTHERS OR SISTERS LIVING IN THE HOUSEHOLD".
      input:
        control: Radio
        labels:
          1: VERY WELL, NO PROBLEMS
          2: QUITE WELL, HARDLY ANY PROBLEMS
          3: PRETTY WELL, OCCASIONAL PROBLEMS
          4: NOT TOO WELL, FREQUENT PROBLEMS
          5: NOT WELL AT ALL, CONSTANT PROBLEMS
          6: NOT APPLICABLE
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s31_core
    title: PARENTING
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    items:
    - id: PAR_Q1
      kind: Question
      title: How often do you praise ..., by saying something like "Good for you!" or "What a nice thing you did!" or "That's good going!"?
      precondition:
      - predicate: RESP_REL.outcome == 1 and RESP_PMK.outcome == 1
        hint: Asked only of the birth parent who is the person most knowledgeable
      input:
        control: Radio
        labels:
          1: NEVER
          2: ABOUT ONCE A WEEK OR LESS
          3: A FEW TIMES A WEEK
          4: ONE OR TWO TIMES A DAY
          5: MANY TIMES EACH DAY
          8: DON'T KNOW
          9: REFUSAL
    - id: PAR_Q2
      kind: Question
      title: How often do you and he/she talk or play with each other, focusing attention on each other for five minutes or more, just for fun?
      input:
        control: Radio
        labels:
          1: NEVER
          2: ABOUT ONCE A WEEK OR LESS
          3: A FEW TIMES A WEEK
          4: ONE OR TWO TIMES A DAY
          5: MANY TIMES EACH DAY
          8: DON'T KNOW
          9: REFUSAL
    - id: PAR_Q3
      kind: Question
      title: How often do you and he/she laugh together?
      input:
        control: Radio
        labels:
          1: NEVER
          2: ABOUT ONCE A WEEK OR LESS
          3: A FEW TIMES A WEEK
          4: ONE OR TWO TIMES A DAY
          5: MANY TIMES EACH DAY
          8: DON'T KNOW
          9: REFUSAL
    - id: PAR_Q4
      kind: Question
      title: How often do you get annoyed with ... for saying or doing something he/she is not supposed to?
      input:
        control: Radio
        labels:
          1: NEVER
          2: ABOUT ONCE A WEEK OR LESS
          3: A FEW TIMES A WEEK
          4: ONE OR TWO TIMES A DAY
          5: MANY TIMES EACH DAY
          8: DON'T KNOW
          9: REFUSAL
    - id: PAR_Q5
      kind: Question
      title: How often do you tell him/her that he/she is bad or not as good as others?
      input:
        control: Radio
        labels:
          1: NEVER
          2: ABOUT ONCE A WEEK OR LESS
          3: A FEW TIMES A WEEK
          4: ONE OR TWO TIMES A DAY
          5: MANY TIMES EACH DAY
          8: DON'T KNOW
          9: REFUSAL
    - id: PAR_Q6
      kind: Question
      title: How often do you do something special with him/her that he/she enjoys?
      input:
        control: Radio
        labels:
          1: NEVER
          2: ABOUT ONCE A WEEK OR LESS
          3: A FEW TIMES A WEEK
          4: ONE OR TWO TIMES A DAY
          5: MANY TIMES EACH DAY
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s31_play
    title: 'PARENTING: play'
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    items:
    - id: PAR_Q7
      kind: Question
      title: How often do you play sports, hobbies or games with him/her?
      precondition:
      - predicate: AGE_5.outcome >= 3
        hint: Asked only of children in the older age group
      - predicate: not (AGE_5.outcome < 3)
        hint: Not asked of children in the younger age group
      input:
        control: Radio
        labels:
          1: NEVER
          2: ABOUT ONCE A WEEK OR LESS
          3: A FEW TIMES A WEEK
          4: ONE OR TWO TIMES A DAY
          5: MANY TIMES EACH DAY
          8: DON'T KNOW
          9: REFUSAL
    - id: PAR_Q7A
      kind: Question
      title: How often do you play games with him/her?
      precondition:
      - predicate: AGE_5.outcome < 3
        hint: Asked only of children in the younger age group
      input:
        control: Radio
        labels:
          1: NEVER
          2: ABOUT ONCE A WEEK OR LESS
          3: A FEW TIMES A WEEK
          4: ONE OR TWO TIMES A DAY
          5: MANY TIMES EACH DAY
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s31_behaviour
    title: 'PARENTING: talking about behaviour'
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    - predicate: AGE_5.outcome >= 2
      hint: Asked only of children in the age group 2 or older
    items:
    - id: PAR_Q8
      kind: Question
      title: Of all the times that you talk to ... about his/her behaviour, what proportion is praise?
      input:
        control: Radio
        labels:
          1: NEVER
          2: LESS THAN HALF THE TIME
          3: ABOUT HALF THE TIME
          4: MORE THAN HALF THE TIME
          5: ALL THE TIME
          8: DON'T KNOW
          9: REFUSAL
    - id: PAR_Q9
      kind: Question
      title: Of all the times that you talk to him/her about his/her behaviour, what proportion is disapproval?
      input:
        control: Radio
        labels:
          1: NEVER
          2: LESS THAN HALF THE TIME
          3: ABOUT HALF THE TIME
          4: MORE THAN HALF THE TIME
          5: ALL THE TIME
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s32_attention
    title: 'Temperament: attention and play'
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    items:
    - id: TMP_Q19
      kind: Question
      title: On the average, how much attention does he/she require, other than for caregiving (feeding, bathing, diaper changes, etc.)?
      input:
        control: Radio
        labels:
          1: VERY LITTLE -- MUCH LESS THAN THE AVERAGE BABY/CHILD
          2: '2'
          3: '3'
          4: AVERAGE AMOUNT
          5: '5'
          6: '6'
          7: A LOT -- MUCH MORE THAN THE AVERAGE BABY/CHILD
          9: REFUSAL
    - id: TMP_Q19A
      kind: Question
      title: On the average, how much attention does he/she require, other than for caregiving (bathing, eating, etc.)?
      precondition:
      - predicate: not (TMP_Q19.outcome != 9)
        hint: Asked only when question TMP-Q19 is "REFUSAL".
      input:
        control: Radio
        labels:
          1: VERY LITTLE -- MUCH LESS THAN THE AVERAGE BABY/CHILD
          2: '2'
          3: '3'
          4: AVERAGE AMOUNT
          5: '5'
          6: '6'
          7: A LOT -- MUCH MORE THAN THE AVERAGE BABY/CHILD
          9: REFUSAL
    - id: TMP_Q20
      kind: Question
      title: When left alone, he/she plays well by him/herself?
      input:
        control: Radio
        labels:
          1: ALMOST ALWAYS
          2: '2'
          3: '3'
          4: ABOUT HALF THE TIME
          5: '5'
          6: '6'
          7: ALMOST NEVER -- WON'T PLAY BY SELF
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s32_confined
    title: 'Temperament: reaction to confinement'
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    items:
    - id: TMP_Q21
      kind: Question
      title: How does he/she react to being confined (as in a carseat, infant seat, playpen, etc.)?
      precondition:
      - predicate: AGE_MONTHS.outcome >= 12 and AGE_MONTHS.outcome <= 23
        hint: Asked when the child is 12 to 23 months old.
      - predicate: not (TMP_Q20.outcome != 9 and AGE_MONTHS.outcome >= 3 and AGE_MONTHS.outcome <= 11)
        hint: Not asked when TMP-Q20 was answered and the child is 3 to 11 months old.
      - predicate: not (TMP_Q20.outcome != 9 and AGE_MONTHS.outcome >= 24 and AGE_MONTHS.outcome <= 35)
        hint: Not asked when TMP-Q20 was answered and the child is 24 to 35 months old.
      - predicate: not (TMP_Q20.outcome != 9 and (AGE_MONTHS.outcome < 3 or AGE_MONTHS.outcome >= 36))
        hint: Not asked when TMP-Q20 was answered and the child is under 3 or over 35 months old.
      input:
        control: Radio
        labels:
          1: VERY WELL -- LIKES IT
          2: '2'
          3: '3'
          4: MINDS A LITTLE OR PROTESTS ONCE IN A WHILE
          5: '5'
          6: '6'
          7: DOESN'T LIKE IT AT ALL
          8: DON'T KNOW
          9: REFUSAL
    - id: TMP_Q21A
      kind: Question
      title: How does he/she react to being confined (as in a carseat, bedroom, crib, etc.)?
      precondition:
      - predicate: AGE_MONTHS.outcome >= 24 and AGE_MONTHS.outcome <= 35
        hint: Asked when the child is 24 to 35 months old.
      - predicate: not (TMP_Q20.outcome != 9 and AGE_MONTHS.outcome >= 3 and AGE_MONTHS.outcome <= 11)
        hint: Not asked when TMP-Q20 was answered and the child is 3 to 11 months old.
      - predicate: not (TMP_Q20.outcome != 9 and (AGE_MONTHS.outcome < 3 or AGE_MONTHS.outcome >= 36))
        hint: Not asked when TMP-Q20 was answered and the child is under 3 or over 35 months old.
      - predicate: not (TMP_Q21.outcome != 9)
        hint: Asked only when question TMP-Q21 is "REFUSAL".
      input:
        control: Radio
        labels:
          1: VERY WELL -- LIKES IT
          2: '2'
          3: '3'
          4: MINDS A LITTLE OR PROTESTS ONCE IN A WHILE
          5: '5'
          6: '6'
          7: DOESN'T LIKE IT AT ALL
          8: DON'T KNOW
          9: REFUSAL
    - id: TMP_Q21B
      kind: Question
      title: How does he/she react to being confined (as in a boosterseat, seatbelt, bedroom, bed, etc.)
      precondition:
      - predicate: AGE_MONTHS.outcome >= 36
        hint: Asked when the child is 36 months or older.
      - predicate: not (TMP_Q20.outcome != 9 and AGE_MONTHS.outcome >= 3 and AGE_MONTHS.outcome <= 11)
        hint: Not asked when TMP-Q20 was answered and the child is 3 to 11 months old.
      - predicate: not (TMP_Q21.outcome != 9)
        hint: Asked only when question TMP-Q21 is "REFUSAL".
      input:
        control: Radio
        labels:
          1: VERY WELL -- LIKES IT
          2: '2'
          3: '3'
          4: MINDS A LITTLE OR PROTESTS ONCE IN A WHILE
          5: '5'
          6: '6'
          7: DOESN'T LIKE IT AT ALL
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s32_cuddle_bath
    title: 'Temperament: cuddling, bath and new playthings'
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    items:
    - id: TMP_Q22
      kind: Question
      title: How much does he/she cuddle and snuggle when held?
      precondition:
      - predicate: not (TMP_Q20.outcome != 9 and AGE_MONTHS.outcome >= 3 and AGE_MONTHS.outcome <= 11)
        hint: Not asked when TMP-Q20 was answered and the child is 3 to 11 months old.
      input:
        control: Radio
        labels:
          1: A GREAT DEAL -- ALMOST EVERY TIME
          2: '2'
          3: '3'
          4: AVERAGE, SOMETIMES DOES AND SOMETIMES DOES NOT
          5: '5'
          6: '6'
          7: VERY LITTLE -- SELDOM CUDDLES
          9: REFUSAL
    - id: TMP_Q22A
      kind: Question
      title: How much does he/she cuddle and snuggle when close to you?
      precondition:
      - predicate: not (TMP_Q20.outcome != 9 and AGE_MONTHS.outcome >= 3 and AGE_MONTHS.outcome <= 11)
        hint: Not asked when TMP-Q20 was answered and the child is 3 to 11 months old.
      - predicate: not (TMP_Q22.outcome != 9 and AGE_5.outcome >= 1 and AGE_5.outcome <= 3)
        hint: Not asked when TMP-Q22 was answered and the child's age group is 1 to 3.
      input:
        control: Radio
        labels:
          1: A GREAT DEAL -- ALMOST EVERY TIME
          2: '2'
          3: '3'
          4: AVERAGE, SOMETIMES DOES AND SOMETIMES DOES NOT
          5: '5'
          6: '6'
          7: VERY LITTLE -- SELDOM CUDDLES
          9: REFUSAL
    - id: TMP_Q23
      kind: Question
      title: How did he/she respond to his/her first bath?
      precondition:
      - predicate: not (TMP_Q22.outcome != 9 and AGE_5.outcome >= 1 and AGE_5.outcome <= 3)
        hint: Not asked when TMP-Q22 was answered and the child's age group is 1 to 3.
      - predicate: not (AGE_5.outcome >= 1 and AGE_5.outcome <= 3)
        hint: Not asked when the child's age group is 1 to 3.
      input:
        control: Radio
        labels:
          1: VERY WELL -- BABY LOVED IT
          2: '2'
          3: '3'
          4: NEITHER LIKED NOR DISLIKED IT
          5: '5'
          6: '6'
          7: TERRIBLY -- DIDN'T LIKE IT
          9: REFUSAL
    - id: TMP_Q23A
      kind: Question
      title: How does he/she typically respond to new playthings?
      precondition:
      - predicate: AGE_5.outcome >= 1 and AGE_5.outcome <= 3
        hint: Asked when the child's age group is 1 to 3.
      - predicate: not (TMP_Q23.outcome != 9 and AGE_MONTHS.outcome >= 3 and AGE_MONTHS.outcome <= 5)
        hint: Not asked when TMP-Q23 was answered and the child is 3 to 5 months old.
      - predicate: not (TMP_Q23.outcome != 9 and (AGE_MONTHS.outcome < 3 or AGE_MONTHS.outcome > 5))
        hint: Not asked when TMP-Q23 was answered and the child is outside 3 to 5 months.
      input:
        control: Radio
        labels:
          1: ALWAYS RESPONDS FAVOURABLY
          2: '2'
          3: '3'
          4: RESPONDS FAVOURABLY ABOUT HALF THE TIME OR IS ALWAYS NEUTRAL
          5: '5'
          6: '6'
          7: ALWAYS RESPONDS NEGATIVELY OR FEARFULLY
          9: REFUSAL
  - id: b_s32_foods
    title: 'Temperament: solid and new foods'
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    - predicate: not (TMP_Q23.outcome != 9 and AGE_MONTHS.outcome >= 3 and AGE_MONTHS.outcome <= 5)
      hint: Not asked when TMP-Q23 was answered and the child is 3 to 5 months old.
    items:
    - id: TMP_Q24
      kind: Question
      title: How did he/she respond to his/her first solid food?
      precondition:
      - predicate: not (TMP_Q23A.outcome != 9)
        hint: Asked only when question TMP-Q23A is "REFUSAL".
      input:
        control: Radio
        labels:
          1: VERY FAVOURABLY -- LIKED IT IMMEDIATELY
          2: '2'
          3: '3'
          4: NEITHER LIKED NOR DISLIKED IT
          5: '5'
          6: '6'
          7: VERY NEGATIVELY -- DID NOT LIKE IT AT ALL
          9: REFUSAL
    - id: TMP_Q24A
      kind: Question
      title: How does he/she typically respond to new foods?
      precondition:
      - predicate: not (TMP_Q24.outcome != 9)
        hint: Asked only when question TMP-Q24 is "REFUSAL".
      input:
        control: Radio
        labels:
          1: ALWAYS RESPONDS FAVOURABLY
          2: '2'
          3: '3'
          4: RESPONDS FAVOURABLY ABOUT HALF OF THE TIME OR IS ALWAYS NEUTRAL
          5: '5'
          6: '6'
          7: VERY NEGATIVELY--DOES NOT LIKE IT AT ALL
          9: REFUSAL
    - id: TMP_Q25
      kind: Question
      title: How does he/she typically respond to a new person?
      input:
        control: Radio
        labels:
          1: ALMOST ALWAYS RESPONDS FAVORABLY
          2: '2'
          3: '3'
          4: RESPONDS FAVORABLY ABOUT HALF THE TIME
          5: '5'
          6: '6'
          7: ALMOST ALWAYS RESPONDS NEGATIVELY AT FIRST
          8: DON'T KNOW
          9: REFUSAL
    - id: TMP_Q26
      kind: Question
      title: How does he/she typically respond to being in a new place?
      input:
        control: Radio
        labels:
          1: ALMOST ALWAYS RESPONDS FAVORABLY
          2: '2'
          3: '3'
          4: RESPONDS FAVORABLY ABOUT HALF THE TIME
          5: '5'
          6: '6'
          7: ALMOST ALWAYS RESPONDS NEGATIVELY AT FIRST
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s32_adapt
    title: 'Temperament: adaptability and persistence'
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    - predicate: not (TMP_Q23.outcome != 9 and AGE_MONTHS.outcome >= 3 and AGE_MONTHS.outcome <= 5)
      hint: Not asked when TMP-Q23 was answered and the child is 3 to 5 months old.
    items:
    - id: TMP_Q27
      kind: Question
      title: How well does he/she adapt to things (such as baths, new people & new places) eventually?
      precondition:
      - predicate: AGE_5.outcome < 1
        hint: Asked when the child's age group is below 1.
      - predicate: not (AGE_5.outcome >= 1)
        hint: Not asked when the child's age group is 1 or above.
      input:
        control: Radio
        labels:
          1: VERY WELL -- ALWAYS LIKES IT EVENTUALLY
          2: '2'
          3: '3'
          4: ENDS UP LIKING IT ABOUT HALF THE TIME
          5: '5'
          6: '6'
          7: ALMOST ALWAYS DISLIKES IT IN THE END
          9: REFUSAL
    - id: TMP_Q27A
      kind: Question
      title: How well does he/she adapt to new experiences (such as new playthings, new foods, new persons, etc.) eventually?
      precondition:
      - predicate: AGE_5.outcome >= 1
        hint: Asked when the child's age group is 1 or above.
      - predicate: not (TMP_Q27.outcome != 9 and AGE_5.outcome < 1)
        hint: Not asked when TMP-Q27 was answered and the child's age group is below 1.
      input:
        control: Radio
        labels:
          1: VERY WELL -- ALWAYS LIKES IT EVENTUALLY
          2: '2'
          3: '3'
          4: ENDS UP LIKING IT ABOUT HALF THE TIME
          5: '5'
          6: '6'
          7: ALMOST ALWAYS DISLIKES IT IN THE END
          9: REFUSAL
    - id: TMP_Q28
      kind: Question
      title: How easy or difficult is it to take him/her places?
      precondition:
      - predicate: AGE_5.outcome >= 1
        hint: Asked when the child's age group is 1 or above.
      - predicate: not (TMP_Q27.outcome != 9 and AGE_5.outcome < 1)
        hint: Not asked when TMP-Q27 was answered and the child's age group is below 1.
      - predicate: not (AGE_5.outcome < 1)
        hint: Not asked when the child's age group is below 1.
      input:
        control: Radio
        labels:
          1: EASY; FUN TO TAKE BABY/CHILD WITH ME
          2: '2'
          3: '3'
          4: OKAY; BABY/CHILD MAY FUSS BUT NO REAL TROUBLE
          5: '5'
          6: '6'
          7: DIFFICULT; BABY/CHILD IS USUALLY DISRUPTIVE
          9: REFUSAL
    - id: TMP_Q29
      kind: Question
      title: Does he/she persist in playing with objects when he/she is told to leave them alone?
      precondition:
      - predicate: not (TMP_Q27.outcome != 9 and AGE_5.outcome < 1)
        hint: Not asked when TMP-Q27 was answered and the child's age group is below 1.
      - predicate: not (AGE_5.outcome < 1)
        hint: Not asked when the child's age group is below 1.
      input:
        control: Radio
        labels:
          1: RARELY OR NEVER PERSISTS
          2: '2'
          3: '3'
          4: SOMETIMES DOES AND SOMETIMES DOES NOT
          5: '5'
          6: '6'
          7: ALMOST ALWAYS PERSISTS
          8: DON'T KNOW
          9: REFUSAL
    - id: TMP_Q30
      kind: Question
      title: Does he/she continue to go someplace even when you told him/her something like "stop", "come here", or "no-no"?
      precondition:
      - predicate: AGE_5.outcome < 3
        hint: Asked when the child's age group is below 3.
      - predicate: not (TMP_Q27.outcome != 9 and AGE_5.outcome < 1)
        hint: Not asked when TMP-Q27 was answered and the child's age group is below 1.
      - predicate: not (AGE_5.outcome < 1)
        hint: Not asked when the child's age group is below 1.
      - predicate: not (TMP_Q29.outcome != 9 and AGE_5.outcome >= 3)
        hint: Not asked when TMP-Q29 was answered and the child's age group is 3 or above.
      input:
        control: Radio
        labels:
          1: RARELY OR NEVER
          2: '2'
          3: '3'
          4: SOMETIMES DOES AND SOMETIMES DOES NOT
          5: '5'
          6: '6'
          7: ALMOST ALWAYS
          9: REFUSAL
    - id: TMP_Q30A
      kind: Question
      title: Does he/she continue to go someplace even when you told him/her something like "stop", "come here", or "please don't"?
      precondition:
      - predicate: AGE_5.outcome >= 3
        hint: Asked when the child's age group is 3 or above.
      - predicate: not (TMP_Q27.outcome != 9 and AGE_5.outcome < 1)
        hint: Not asked when TMP-Q27 was answered and the child's age group is below 1.
      - predicate: not (AGE_5.outcome < 1)
        hint: Not asked when the child's age group is below 1.
      - predicate: not (TMP_Q30.outcome != 9)
        hint: Asked only when question TMP-Q30 is "REFUSAL".
      input:
        control: Radio
        labels:
          1: RARELY OR NEVER
          2: '2'
          3: '3'
          4: SOMETIMES DOES AND SOMETIMES DOES NOT
          5: '5'
          6: '6'
          7: ALMOST ALWAYS
          9: REFUSAL
    - id: TMP_Q31
      kind: Question
      title: When removed from something he/she is interested in but should not be getting into, he/she gets upset.
      precondition:
      - predicate: not (TMP_Q27.outcome != 9 and AGE_5.outcome < 1)
        hint: Not asked when TMP-Q27 was answered and the child's age group is below 1.
      - predicate: not (AGE_5.outcome < 1)
        hint: Not asked when the child's age group is below 1.
      input:
        control: Radio
        labels:
          1: NEVER
          2: '2'
          3: '3'
          4: SOMETIMES DOES AND SOMETIMES DOES NOT
          5: '5'
          6: '6'
          7: ALWAYS GETS VERY UPSET
          9: REFUSAL
    - id: TMP_Q32
      kind: Question
      title: How persistent is he/she in trying to get your attention when you are busy?
      precondition:
      - predicate: not (TMP_Q27.outcome != 9 and AGE_5.outcome < 1)
        hint: Not asked when TMP-Q27 was answered and the child's age group is below 1.
      - predicate: not (AGE_5.outcome < 1)
        hint: Not asked when the child's age group is below 1.
      input:
        control: Radio
        labels:
          1: DOESN'T PERSIST AT ALL
          2: '2'
          3: '3'
          4: WILL TRY, BUT WILL ONLY MILDLY PERSIST
          5: '5'
          6: '6'
          7: VERY PERSISTENT -- WILL DO ANYTHING TO GET ATTENTION
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s32_overall
    title: 'Temperament: overall difficulty'
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    items:
    - id: TMP_Q33
      kind: Question
      title: Please rate the overall degree of difficulty ... would present for the average parent.
      input:
        control: Radio
        labels:
          1: VERY EASY
          2: '2'
          3: '3'
          4: ORDINARY, SOME PROBLEMS
          5: '5'
          6: '6'
          7: HIGHLY DIFFICULT TO DEAL WITH
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s33_grade
    title: 'Education: current grade'
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of YES, DON'T KNOW, REFUSAL.
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not REFUSAL.
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not REFUSAL.
    items:
    - id: EDU_Q1
      kind: Question
      title: What school grade is ... in? (New Brunswick, Manitoba, Saskatchewan, Alberta or British Columbia)
      precondition:
      - predicate: AGE_5.outcome >= 4 and PROVINCE.outcome == 6
        hint: Asked of children aged 4 and over in these provinces.
      input:
        control: Dropdown
        labels:
          1: 01 NOT IN SCHOOL
          2: 02 KINDERGARTEN
          3: 03 GRADE 1
          4: 04 GRADE 2
          5: 05 GRADE 3
          6: 06 GRADE 4
          7: 07 GRADE 5
          8: 08 GRADE 6
          9: 09 GRADE 7
          10: 10 GRADE 8
          11: 11 GRADE 9
          12: 12 GRADE 10
          13: 13 GRADE 11
          14: 14 GRADE 12
          15: 15 UNGRADED
    - id: EDU_Q1A
      kind: Question
      title: What school grade is ... in? (Newfoundland)
      precondition:
      - predicate: AGE_5.outcome >= 4 and PROVINCE.outcome == 1
        hint: Asked of children aged 4 and over in Newfoundland.
      - predicate: not (EDU_Q1.outcome == 15)
        hint: Asked only when question EDU-Q1 is not 15 UNGRADED.
      - predicate: not (EDU_Q1.outcome >= 2 and EDU_Q1.outcome <= 14)
        hint: Asked only when EDU-Q1 has not already given a grade.
      input:
        control: Dropdown
        labels:
          1: 01 NOT IN SCHOOL
          2: 02 KINDERGARTEN
          3: 03 GRADE 1 ELEMENTARY
          4: 04 GRADE 2 ELEMENTARY
          5: 05 GRADE 3 ELEMENTARY
          6: 06 GRADE 4 ELEMENTARY
          7: 07 GRADE 5 ELEMENTARY
          8: 08 GRADE 6 ELEMENTARY
          9: 09 GRADE 7 ELEMENTARY
          10: 10 GRADE 8 ELEMENTARY
          11: 11 GRADE 9 ELEMENTARY
          12: 12 LEVEL 1 SECONDARY
          13: 13 LEVEL 2 SECONDARY
          14: 14 LEVEL 3 SECONDARY
          15: 15 UNGRADED
    - id: EDU_Q1B
      kind: Question
      title: What school grade is ... in? (Quebec)
      precondition:
      - predicate: AGE_5.outcome >= 4 and PROVINCE.outcome == 2
        hint: Asked of children aged 4 and over in Quebec.
      - predicate: not (EDU_Q1.outcome == 15)
        hint: Asked only when question EDU-Q1 is not 15 UNGRADED.
      - predicate: not (EDU_Q1.outcome >= 2 and EDU_Q1.outcome <= 14)
        hint: Asked only when EDU-Q1 has not already given a grade.
      - predicate: not (EDU_Q1A.outcome == 15)
        hint: Asked only when question EDU-Q1A is not 15 UNGRADED.
      - predicate: not (EDU_Q1A.outcome >= 2 and EDU_Q1A.outcome <= 14)
        hint: Asked only when EDU-Q1A has not already given a grade.
      input:
        control: Dropdown
        labels:
          1: 01 NOT IN SCHOOL
          2: 02 JUNIOR KINDERGARTEN
          3: 03 KINDERGARTEN
          4: 04 GRADE 1 ELEMENTARY
          5: 05 GRADE 2 ELEMENTARY
          6: 06 GRADE 3 ELEMENTARY
          7: 07 GRADE 4 ELEMENTARY
          8: 08 GRADE 5 ELEMENTARY
          9: 09 GRADE 6 ELEMENTARY
          10: 10 SECONDARY I
          11: 11 SECONDARY II
          12: 12 SECONDARY III
          13: 13 SECONDARY IV
          14: 14 SECONDARY V
          15: 15 UNGRADED
    - id: EDU_Q1C
      kind: Question
      title: What school grade is ... in? (Ontario)
      precondition:
      - predicate: AGE_5.outcome >= 4 and PROVINCE.outcome == 3
        hint: Asked of children aged 4 and over in Ontario.
      - predicate: not (EDU_Q1.outcome == 15)
        hint: Asked only when question EDU-Q1 is not 15 UNGRADED.
      - predicate: not (EDU_Q1.outcome >= 2 and EDU_Q1.outcome <= 14)
        hint: Asked only when EDU-Q1 has not already given a grade.
      - predicate: not (EDU_Q1A.outcome == 15)
        hint: Asked only when question EDU-Q1A is not 15 UNGRADED.
      - predicate: not (EDU_Q1A.outcome >= 2 and EDU_Q1A.outcome <= 14)
        hint: Asked only when EDU-Q1A has not already given a grade.
      - predicate: not (EDU_Q1B.outcome in [15, 2])
        hint: Asked only when question EDU-Q1B is none of 15 UNGRADED, 02 JUNIOR KINDERGARTEN.
      - predicate: not (EDU_Q1B.outcome >= 3 and EDU_Q1B.outcome <= 14)
        hint: Asked only when EDU-Q1B has not already given a grade.
      input:
        control: Dropdown
        labels:
          1: 01 NOT IN SCHOOL
          2: 02 JUNIOR KINDERGARTEN
          3: 03 KINDERGARTEN
          4: 04 GRADE 1
          5: 05 GRADE 2
          6: 06 GRADE 3
          7: 07 GRADE 4
          8: 08 GRADE 5
          9: 09 GRADE 6
          10: 10 GRADE 7
          11: 11 GRADE 8
          12: 12 GRADE 9
          13: 13 GRADE 10
          14: 14 GRADE 11
          15: 15 GRADE 12
          16: 16 OAC GRADE 13
          17: 17 UNGRADED
    - id: EDU_Q1D
      kind: Question
      title: What school grade is ... in? (Nova Scotia)
      precondition:
      - predicate: AGE_5.outcome >= 4 and PROVINCE.outcome == 4
        hint: Asked of children aged 4 and over in Nova Scotia.
      - predicate: not (EDU_Q1.outcome == 15)
        hint: Asked only when question EDU-Q1 is not 15 UNGRADED.
      - predicate: not (EDU_Q1.outcome >= 2 and EDU_Q1.outcome <= 14)
        hint: Asked only when EDU-Q1 has not already given a grade.
      - predicate: not (EDU_Q1A.outcome == 15)
        hint: Asked only when question EDU-Q1A is not 15 UNGRADED.
      - predicate: not (EDU_Q1A.outcome >= 2 and EDU_Q1A.outcome <= 14)
        hint: Asked only when EDU-Q1A has not already given a grade.
      - predicate: not (EDU_Q1B.outcome in [15, 2])
        hint: Asked only when question EDU-Q1B is none of 15 UNGRADED, 02 JUNIOR KINDERGARTEN.
      - predicate: not (EDU_Q1B.outcome >= 3 and EDU_Q1B.outcome <= 14)
        hint: Asked only when EDU-Q1B has not already given a grade.
      - predicate: not (EDU_Q1C.outcome in [17, 2])
        hint: Asked only when question EDU-Q1C is none of 17 UNGRADED, 02 JUNIOR KINDERGARTEN.
      - predicate: not (EDU_Q1C.outcome >= 3 and EDU_Q1C.outcome <= 16)
        hint: Asked only when EDU-Q1C has not already given a grade.
      input:
        control: Dropdown
        labels:
          1: 01 NOT IN SCHOOL
          2: 02 PRIMARY
          3: 03 GRADE 1
          4: 04 GRADE 2
          5: 05 GRADE 3
          6: 06 GRADE 4
          7: 07 GRADE 5
          8: 08 GRADE 6
          9: 09 GRADE 7
          10: 10 GRADE 8
          11: 11 GRADE 9
          12: 12 GRADE 10
          13: 13 GRADE 11
          14: 14 GRADE 12
          15: 15 UNGRADED
    - id: EDU_Q1E
      kind: Question
      title: What school grade is ... in? (Prince Edward Island)
      precondition:
      - predicate: AGE_5.outcome >= 4 and PROVINCE.outcome == 5
        hint: Asked of children aged 4 and over in Prince Edward Island.
      - predicate: not (EDU_Q1.outcome == 15)
        hint: Asked only when question EDU-Q1 is not 15 UNGRADED.
      - predicate: not (EDU_Q1.outcome >= 2 and EDU_Q1.outcome <= 14)
        hint: Asked only when EDU-Q1 has not already given a grade.
      - predicate: not (EDU_Q1A.outcome == 15)
        hint: Asked only when question EDU-Q1A is not 15 UNGRADED.
      - predicate: not (EDU_Q1A.outcome >= 2 and EDU_Q1A.outcome <= 14)
        hint: Asked only when EDU-Q1A has not already given a grade.
      - predicate: not (EDU_Q1B.outcome in [15, 2])
        hint: Asked only when question EDU-Q1B is none of 15 UNGRADED, 02 JUNIOR KINDERGARTEN.
      - predicate: not (EDU_Q1B.outcome >= 3 and EDU_Q1B.outcome <= 14)
        hint: Asked only when EDU-Q1B has not already given a grade.
      - predicate: not (EDU_Q1C.outcome in [17, 2])
        hint: Asked only when question EDU-Q1C is none of 17 UNGRADED, 02 JUNIOR KINDERGARTEN.
      - predicate: not (EDU_Q1C.outcome >= 3 and EDU_Q1C.outcome <= 16)
        hint: Asked only when EDU-Q1C has not already given a grade.
      - predicate: not (EDU_Q1D.outcome == 15)
        hint: Asked only when question EDU-Q1D is not 15 UNGRADED.
      - predicate: not (EDU_Q1D.outcome >= 2 and EDU_Q1D.outcome <= 14)
        hint: Asked only when EDU-Q1D has not already given a grade.
      input:
        control: Dropdown
        labels:
          1: 01 NOT IN SCHOOL
          2: 02 GRADE 1
          3: 03 GRADE 2
          4: 04 GRADE 3
          5: 05 GRADE 4
          6: 06 GRADE 5
          7: 07 GRADE 6
          8: 08 GRADE 7
          9: 09 GRADE 8
          10: 10 GRADE 9
          11: 11 GRADE 10
          12: 12 GRADE 11
          13: 13 GRADE 12
          14: 14 UNGRADED
  - id: b_s33_schooling
    title: 'Education: kindergarten, skipped and repeated grades'
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of YES, DON'T KNOW, REFUSAL.
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not REFUSAL.
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not REFUSAL.
    - predicate: not (EDU_Q1.outcome == 15)
      hint: Asked only when question EDU-Q1 is not 15 UNGRADED.
    - predicate: not (EDU_Q1A.outcome == 15)
      hint: Asked only when question EDU-Q1A is not 15 UNGRADED.
    - predicate: not (EDU_Q1B.outcome in [15, 2])
      hint: Asked only when question EDU-Q1B is none of 15 UNGRADED, 02 JUNIOR KINDERGARTEN.
    - predicate: not (EDU_Q1C.outcome in [17, 2])
      hint: Asked only when question EDU-Q1C is none of 17 UNGRADED, 02 JUNIOR KINDERGARTEN.
    - predicate: not (EDU_Q1D.outcome == 15)
      hint: Asked only when question EDU-Q1D is not 15 UNGRADED.
    - predicate: not (EDU_Q1E.outcome == 14)
      hint: Asked only when question EDU-Q1E is not 14 UNGRADED.
    items:
    - id: EDU_Q2
      kind: Question
      title: Did he/she attend junior kindergarten?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: EDU_Q3
      kind: Question
      title: Did he/she attend kindergarten/primary?
      precondition:
      - predicate: not (EDU_Q2.outcome != 9 and (EDU_Q1.outcome == 2 or EDU_Q1A.outcome == 2 or EDU_Q1B.outcome == 3 or EDU_Q1C.outcome == 3 or EDU_Q1D.outcome == 2))
        hint: Not asked when the child is currently in kindergarten/primary and EDU-Q2 was answered.
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: EDU_Q4
      kind: Question
      title: Has ... ever skipped a grade at school? (INCLUDE KINDERGARTEN)
      precondition:
      - predicate: not (EDU_Q2.outcome != 9 and (EDU_Q1.outcome == 2 or EDU_Q1A.outcome == 2 or EDU_Q1B.outcome == 3 or EDU_Q1C.outcome == 3 or EDU_Q1D.outcome == 2))
        hint: Not asked when the child is currently in kindergarten/primary and EDU-Q2 was answered.
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: EDU_Q5
      kind: Question
      title: What grade(s) has he/she skipped? (New Brunswick, Manitoba, Saskatchewan, Alberta, British Columbia) (MARK ONE ONLY. IF MORE THAN ONE REPORTED, MARK THE MOST RECENT.)
      precondition:
      - predicate: EDU_Q4.outcome == 1 and PROVINCE.outcome == 6
        hint: Asked when a grade was skipped, in these provinces.
      - predicate: not (EDU_Q2.outcome != 9 and (EDU_Q1.outcome == 2 or EDU_Q1A.outcome == 2 or EDU_Q1B.outcome == 3 or EDU_Q1C.outcome == 3 or EDU_Q1D.outcome == 2))
        hint: Not asked when the child is currently in kindergarten/primary and EDU-Q2 was answered.
      - predicate: not (EDU_Q4.outcome in [2, 8, 9])
        hint: Asked only when question EDU-Q4 is none of NO, DON'T KNOW, REFUSAL.
      - predicate: not (EDU_Q4.outcome == 1 and PROVINCE.outcome == 1)
        hint: Not asked in Newfoundland.
      - predicate: not (EDU_Q4.outcome == 1 and PROVINCE.outcome == 2)
        hint: Not asked in Quebec.
      - predicate: not (EDU_Q4.outcome == 1 and PROVINCE.outcome == 3)
        hint: Not asked in Ontario.
      - predicate: not (EDU_Q4.outcome == 1 and PROVINCE.outcome == 4)
        hint: Not asked in Nova Scotia.
      - predicate: not (EDU_Q4.outcome == 1 and PROVINCE.outcome == 5)
        hint: Not asked in Prince Edward Island.
      input:
        control: Dropdown
        labels:
          1: 01 KINDERGARTEN
          2: 02 GRADE 1
          3: 03 GRADE 2
          4: 04 GRADE 3
          5: 05 GRADE 4
          6: 06 GRADE 5
          7: 07 GRADE 6
          8: 08 GRADE 7
          9: 09 GRADE 8
          10: 10 GRADE 9
          11: 11 GRADE 10
          12: 12 GRADE 11
          13: 13 GRADE 12
          98: DON'T KNOW
          99: REFUSAL
    - id: EDU_Q5A
      kind: Question
      title: What grade(s) has he/she skipped? (Newfoundland) (MARK ONE ONLY. IF MORE THAN ONE REPORTED, MARK THE MOST RECENT.)
      precondition:
      - predicate: EDU_Q4.outcome == 1 and PROVINCE.outcome == 1
        hint: Asked when a grade was skipped, in Newfoundland.
      - predicate: not (EDU_Q2.outcome != 9 and (EDU_Q1.outcome == 2 or EDU_Q1A.outcome == 2 or EDU_Q1B.outcome == 3 or EDU_Q1C.outcome == 3 or EDU_Q1D.outcome == 2))
        hint: Not asked when the child is currently in kindergarten/primary and EDU-Q2 was answered.
      - predicate: not (EDU_Q4.outcome in [2, 8, 9])
        hint: Asked only when question EDU-Q4 is none of NO, DON'T KNOW, REFUSAL.
      - predicate: not (EDU_Q4.outcome == 1 and PROVINCE.outcome == 2)
        hint: Not asked in Quebec.
      - predicate: not (EDU_Q4.outcome == 1 and PROVINCE.outcome == 3)
        hint: Not asked in Ontario.
      - predicate: not (EDU_Q4.outcome == 1 and PROVINCE.outcome == 4)
        hint: Not asked in Nova Scotia.
      - predicate: not (EDU_Q4.outcome == 1 and PROVINCE.outcome == 5)
        hint: Not asked in Prince Edward Island.
      - predicate: not (EDU_Q5.outcome != 99)
        hint: Asked only when question EDU-Q5 is REFUSAL.
      input:
        control: Dropdown
        labels:
          1: 01 KINDERGARTEN
          2: 02 GRADE 1 ELEMENTARY
          3: 03 GRADE 2 ELEMENTARY
          4: 04 GRADE 3 ELEMENTARY
          5: 05 GRADE 4 ELEMENTARY
          6: 06 GRADE 5 ELEMENTARY
          7: 07 GRADE 6 ELEMENTARY
          8: 08 GRADE 7 ELEMENTARY
          9: 09 GRADE 8 ELEMENTARY
          10: 10 GRADE 9 ELEMENTARY
          11: 11 LEVEL 1 SECONDARY
          12: 12 LEVEL 2 SECONDARY
          13: 13 LEVEL 3 SECONDARY
          98: DON'T KNOW
          99: REFUSAL
    - id: EDU_Q5B
      kind: Question
      title: What grade(s) has he/she skipped? (Quebec) (MARK ONE ONLY. IF MORE THAN ONE REPORTED, MARK THE MOST RECENT.)
      precondition:
      - predicate: EDU_Q4.outcome == 1 and PROVINCE.outcome == 2
        hint: Asked when a grade was skipped, in Quebec.
      - predicate: not (EDU_Q2.outcome != 9 and (EDU_Q1.outcome == 2 or EDU_Q1A.outcome == 2 or EDU_Q1B.outcome == 3 or EDU_Q1C.outcome == 3 or EDU_Q1D.outcome == 2))
        hint: Not asked when the child is currently in kindergarten/primary and EDU-Q2 was answered.
      - predicate: not (EDU_Q4.outcome in [2, 8, 9])
        hint: Asked only when question EDU-Q4 is none of NO, DON'T KNOW, REFUSAL.
      - predicate: not (EDU_Q4.outcome == 1 and PROVINCE.outcome == 3)
        hint: Not asked in Ontario.
      - predicate: not (EDU_Q4.outcome == 1 and PROVINCE.outcome == 4)
        hint: Not asked in Nova Scotia.
      - predicate: not (EDU_Q4.outcome == 1 and PROVINCE.outcome == 5)
        hint: Not asked in Prince Edward Island.
      - predicate: not (EDU_Q5.outcome != 99)
        hint: Asked only when question EDU-Q5 is REFUSAL.
      - predicate: not (EDU_Q5A.outcome != 99)
        hint: Asked only when question EDU-Q5A is REFUSAL.
      input:
        control: Dropdown
        labels:
          1: 01 KINDERGARTEN
          2: 02 GRADE 1 ELEMENTARY
          3: 03 GRADE 2 ELEMENTARY
          4: 04 GRADE 3 ELEMENTARY
          5: 05 GRADE 4 ELEMENTARY
          6: 06 GRADE 5 ELEMENTARY
          7: 07 GRADE 6 ELEMENTARY
          8: 08 SECONDARY I
          9: 09 SECONDARY II
          10: 10 SECONDARY III
          11: 11 SECONDARY IV
          12: 12 SECONDARY V
          98: DON'T KNOW
          99: REFUSAL
    - id: EDU_Q5C
      kind: Question
      title: What grade(s) has he/she skipped? (Ontario) (MARK ONE ONLY. IF MORE THAN ONE REPORTED, MARK THE MOST RECENT.)
      precondition:
      - predicate: EDU_Q4.outcome == 1 and PROVINCE.outcome == 3
        hint: Asked when a grade was skipped, in Ontario.
      - predicate: not (EDU_Q2.outcome != 9 and (EDU_Q1.outcome == 2 or EDU_Q1A.outcome == 2 or EDU_Q1B.outcome == 3 or EDU_Q1C.outcome == 3 or EDU_Q1D.outcome == 2))
        hint: Not asked when the child is currently in kindergarten/primary and EDU-Q2 was answered.
      - predicate: not (EDU_Q4.outcome in [2, 8, 9])
        hint: Asked only when question EDU-Q4 is none of NO, DON'T KNOW, REFUSAL.
      - predicate: not (EDU_Q4.outcome == 1 and PROVINCE.outcome == 4)
        hint: Not asked in Nova Scotia.
      - predicate: not (EDU_Q4.outcome == 1 and PROVINCE.outcome == 5)
        hint: Not asked in Prince Edward Island.
      - predicate: not (EDU_Q5.outcome != 99)
        hint: Asked only when question EDU-Q5 is REFUSAL.
      - predicate: not (EDU_Q5A.outcome != 99)
        hint: Asked only when question EDU-Q5A is REFUSAL.
      - predicate: not (EDU_Q5B.outcome != 99)
        hint: Asked only when question EDU-Q5B is REFUSAL.
      input:
        control: Dropdown
        labels:
          1: 01 KINDERGARTEN
          2: 02 GRADE 1
          3: 03 GRADE 2
          4: 04 GRADE 3
          5: 05 GRADE 4
          6: 06 GRADE 5
          7: 07 GRADE 6
          8: 08 GRADE 7
          9: 09 GRADE 8
          10: 10 GRADE 9
          11: 11 GRADE 10
          12: 12 GRADE 11
          13: 13 GRADE 12
          14: 14 OAC GRADE 13
          98: DON'T KNOW
          99: REFUSAL
    - id: EDU_Q5D
      kind: Question
      title: What grade(s) has he/she skipped? (Nova Scotia) (MARK ONE ONLY. IF MORE THAN ONE REPORTED, MARK THE MOST RECENT.)
      precondition:
      - predicate: EDU_Q4.outcome == 1 and PROVINCE.outcome == 4
        hint: Asked when a grade was skipped, in Nova Scotia.
      - predicate: not (EDU_Q2.outcome != 9 and (EDU_Q1.outcome == 2 or EDU_Q1A.outcome == 2 or EDU_Q1B.outcome == 3 or EDU_Q1C.outcome == 3 or EDU_Q1D.outcome == 2))
        hint: Not asked when the child is currently in kindergarten/primary and EDU-Q2 was answered.
      - predicate: not (EDU_Q4.outcome in [2, 8, 9])
        hint: Asked only when question EDU-Q4 is none of NO, DON'T KNOW, REFUSAL.
      - predicate: not (EDU_Q4.outcome == 1 and PROVINCE.outcome == 5)
        hint: Not asked in Prince Edward Island.
      - predicate: not (EDU_Q5.outcome != 99)
        hint: Asked only when question EDU-Q5 is REFUSAL.
      - predicate: not (EDU_Q5A.outcome != 99)
        hint: Asked only when question EDU-Q5A is REFUSAL.
      - predicate: not (EDU_Q5B.outcome != 99)
        hint: Asked only when question EDU-Q5B is REFUSAL.
      - predicate: not (EDU_Q5C.outcome != 99)
        hint: Asked only when question EDU-Q5C is REFUSAL.
      input:
        control: Dropdown
        labels:
          1: 01 PRIMARY
          2: 02 GRADE 1
          3: 03 GRADE 2
          4: 04 GRADE 3
          5: 05 GRADE 4
          6: 06 GRADE 5
          7: 07 GRADE 6
          8: 08 GRADE 7
          9: 09 GRADE 8
          10: 10 GRADE 9
          11: 11 GRADE 10
          12: 12 GRADE 11
          13: 13 GRADE 12
          98: DON'T KNOW
          99: REFUSAL
    - id: EDU_Q5E
      kind: Question
      title: What grade(s) has he/she skipped? (Prince Edward Island) (MARK ONE ONLY. IF MORE THAN ONE REPORTED, MARK THE MOST RECENT.)
      precondition:
      - predicate: EDU_Q4.outcome == 1 and PROVINCE.outcome == 5
        hint: Asked when a grade was skipped, in Prince Edward Island.
      - predicate: not (EDU_Q2.outcome != 9 and (EDU_Q1.outcome == 2 or EDU_Q1A.outcome == 2 or EDU_Q1B.outcome == 3 or EDU_Q1C.outcome == 3 or EDU_Q1D.outcome == 2))
        hint: Not asked when the child is currently in kindergarten/primary and EDU-Q2 was answered.
      - predicate: not (EDU_Q4.outcome in [2, 8, 9])
        hint: Asked only when question EDU-Q4 is none of NO, DON'T KNOW, REFUSAL.
      - predicate: not (EDU_Q5.outcome != 99)
        hint: Asked only when question EDU-Q5 is REFUSAL.
      - predicate: not (EDU_Q5A.outcome != 99)
        hint: Asked only when question EDU-Q5A is REFUSAL.
      - predicate: not (EDU_Q5B.outcome != 99)
        hint: Asked only when question EDU-Q5B is REFUSAL.
      - predicate: not (EDU_Q5C.outcome != 99)
        hint: Asked only when question EDU-Q5C is REFUSAL.
      - predicate: not (EDU_Q5D.outcome != 99)
        hint: Asked only when question EDU-Q5D is REFUSAL.
      input:
        control: Dropdown
        labels:
          1: 01 GRADE 1
          2: 02 GRADE 2
          3: 03 GRADE 3
          4: 04 GRADE 4
          5: 05 GRADE 5
          6: 06 GRADE 6
          7: 07 GRADE 7
          8: 08 GRADE 8
          9: 09 GRADE 9
          10: 10 GRADE 10
          11: 11 GRADE 11
          12: 12 GRADE 12
          98: DON'T KNOW
          99: REFUSAL
    - id: EDU_Q6
      kind: Question
      title: Has ... ever repeated a grade at school (INCLUDE KINDERGARTEN)?
      precondition:
      - predicate: not (EDU_Q2.outcome != 9 and (EDU_Q1.outcome == 2 or EDU_Q1A.outcome == 2 or EDU_Q1B.outcome == 3 or EDU_Q1C.outcome == 3 or EDU_Q1D.outcome == 2))
        hint: Not asked when the child is currently in kindergarten/primary and EDU-Q2 was answered.
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s34_p1_pre
    title: Interview context
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    - predicate: not (EDU_Q1.outcome == 15)
      hint: Asked only when question EDU-Q1 is not "15 UNGRADED".
    - predicate: not (EDU_Q1A.outcome == 15)
      hint: Asked only when question EDU-Q1A is not "15 UNGRADED".
    - predicate: not (EDU_Q1B.outcome in [15, 2])
      hint: Asked only when question EDU-Q1B is none of "15 UNGRADED", "02 JUNIOR KINDERGARTEN".
    - predicate: not (EDU_Q1C.outcome in [17, 2])
      hint: Asked only when question EDU-Q1C is none of "17 UNGRADED", "02 JUNIOR KINDERGARTEN".
    - predicate: not (EDU_Q1D.outcome == 15)
      hint: Asked only when question EDU-Q1D is not "15 UNGRADED".
    - predicate: not (EDU_Q1E.outcome == 14)
      hint: Asked only when question EDU-Q1E is not "14 UNGRADED".
    - predicate: not (EDU_Q2.outcome != 9 and (EDU_Q1.outcome == 2 or EDU_Q1A.outcome == 2 or EDU_Q1B.outcome == 3 or EDU_Q1C.outcome == 3 or EDU_Q1D.outcome == 2))
      hint: Routing from EDU-Q2 and the grade questions.
    - predicate: not (EDU_Q6.outcome in [2, 8, 9])
      hint: Asked only when question EDU-Q6 is none of "NO", "DON'T KNOW", "REFUSAL".
    - predicate: not (EDU_Q6.outcome == 1 and PROVINCE.outcome == 1)
      hint: Routing from EDU-Q6 and province.
    - predicate: not (EDU_Q6.outcome == 1 and PROVINCE.outcome == 2)
      hint: Routing from EDU-Q6 and province.
    - predicate: not (EDU_Q6.outcome == 1 and PROVINCE.outcome == 3)
      hint: Routing from EDU-Q6 and province.
    - predicate: not (EDU_Q6.outcome == 1 and PROVINCE.outcome == 4)
      hint: Routing from EDU-Q6 and province.
    - predicate: not (EDU_Q6.outcome == 1 and PROVINCE.outcome == 5)
      hint: Routing from EDU-Q6 and province.
    - predicate: not (EDU_Q6.outcome == 1 and PROVINCE.outcome == 6)
      hint: Routing from EDU-Q6 and province.
    items:
    - id: PROVINCE_2
      kind: Question
      external: true
      title: Province of residence (from the sample file / interview context); selects which provincial grade list EDU-Q7 to EDU-Q7E is asked
      input:
        control: Dropdown
        labels:
          1: New Brunswick
          2: Manitoba
          3: Saskatchewan
          4: Alberta
          5: British Columbia
          6: Newfoundland
          7: Quebec
          8: Ontario
          9: Nova Scotia
          10: Prince Edward Island
    - id: AGE_6
      kind: Question
      external: true
      title: Child's age in completed years (from the household roster / sample file; used as AGE in the routing checks)
      input:
        control: Editbox
        min: 0
        max: 17
    - id: AGE_MONTHS_2
      kind: Question
      external: true
      title: Child's age in months (from the household roster / sample file; the source prints AGE IN MONTHS)
      input:
        control: Editbox
        min: 0
        max: 216
    - id: RESPONDENT
      kind: Question
      external: true
      title: 'Respondent''s relationship to the child (from the interview context: the source prints RESPONDENT IS THE BIOLOGICAL MOTHER / BIOLOGICAL FATHER OF THE CHILD)'
      input:
        control: Radio
        labels:
          1: Biological mother
          2: Biological father
          3: Other
  - id: b_s34_p1_repeat
    title: Grade repeated
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    - predicate: not (EDU_Q1.outcome == 15)
      hint: Asked only when question EDU-Q1 is not "15 UNGRADED".
    - predicate: not (EDU_Q1A.outcome == 15)
      hint: Asked only when question EDU-Q1A is not "15 UNGRADED".
    - predicate: not (EDU_Q1B.outcome in [15, 2])
      hint: Asked only when question EDU-Q1B is none of "15 UNGRADED", "02 JUNIOR KINDERGARTEN".
    - predicate: not (EDU_Q1C.outcome in [17, 2])
      hint: Asked only when question EDU-Q1C is none of "17 UNGRADED", "02 JUNIOR KINDERGARTEN".
    - predicate: not (EDU_Q1D.outcome == 15)
      hint: Asked only when question EDU-Q1D is not "15 UNGRADED".
    - predicate: not (EDU_Q1E.outcome == 14)
      hint: Asked only when question EDU-Q1E is not "14 UNGRADED".
    - predicate: not (EDU_Q2.outcome != 9 and (EDU_Q1.outcome == 2 or EDU_Q1A.outcome == 2 or EDU_Q1B.outcome == 3 or EDU_Q1C.outcome == 3 or EDU_Q1D.outcome == 2))
      hint: Routing from EDU-Q2 and the grade questions.
    - predicate: not (EDU_Q6.outcome in [2, 8, 9])
      hint: Asked only when question EDU-Q6 is none of "NO", "DON'T KNOW", "REFUSAL".
    items:
    - id: EDU_Q7
      kind: Question
      title: What grade(s) has he/she repeated? (New Brunswick, Manitoba, Saskatchewan, Alberta, British Columbia) (MARK ONE ONLY. IF MORE THAN ONE REPORTED, MARK THE MOST RECENT.)
      precondition:
      - predicate: PROVINCE_2.outcome in [1, 2, 3, 4, 5]
        hint: Asked only for New Brunswick, Manitoba, Saskatchewan, Alberta, British Columbia.
      - predicate: not (EDU_Q6.outcome == 1 and PROVINCE.outcome == 1)
        hint: Routing from EDU-Q6 and province.
      - predicate: not (EDU_Q6.outcome == 1 and PROVINCE.outcome == 2)
        hint: Routing from EDU-Q6 and province.
      - predicate: not (EDU_Q6.outcome == 1 and PROVINCE.outcome == 3)
        hint: Routing from EDU-Q6 and province.
      - predicate: not (EDU_Q6.outcome == 1 and PROVINCE.outcome == 4)
        hint: Routing from EDU-Q6 and province.
      - predicate: not (EDU_Q6.outcome == 1 and PROVINCE.outcome == 5)
        hint: Routing from EDU-Q6 and province.
      input:
        control: Dropdown
        labels:
          1: KINDERGARTEN
          2: GRADE 1
          3: GRADE 2
          4: GRADE 3
          5: GRADE 4
          6: GRADE 5
          7: GRADE 6
          8: GRADE 7
          9: GRADE 8
          10: GRADE 9
          11: GRADE 10
          12: GRADE 11
          13: GRADE 12
          98: DON'T KNOW
          99: REFUSAL
    - id: EDU_Q7A
      kind: Question
      title: What grade(s) has he/she repeated? (Newfoundland) (MARK ONE ONLY. IF MORE THAN ONE REPORTED, MARK THE MOST RECENT.)
      precondition:
      - predicate: PROVINCE_2.outcome == 6
        hint: Asked only when question PROVINCE is "Newfoundland".
      - predicate: not (EDU_Q6.outcome == 1 and PROVINCE.outcome == 2)
        hint: Routing from EDU-Q6 and province.
      - predicate: not (EDU_Q6.outcome == 1 and PROVINCE.outcome == 3)
        hint: Routing from EDU-Q6 and province.
      - predicate: not (EDU_Q6.outcome == 1 and PROVINCE.outcome == 4)
        hint: Routing from EDU-Q6 and province.
      - predicate: not (EDU_Q6.outcome == 1 and PROVINCE.outcome == 5)
        hint: Routing from EDU-Q6 and province.
      - predicate: not (EDU_Q7.outcome == 99)
        hint: Asked only when question EDU-Q7 is not "REFUSAL".
      input:
        control: Dropdown
        labels:
          1: KINDERGARTEN
          2: GRADE 1 ELEMENTARY
          3: GRADE 2 ELEMENTARY
          4: GRADE 3 ELEMENTARY
          5: GRADE 4 ELEMENTARY
          6: GRADE 5 ELEMENTARY
          7: GRADE 6 ELEMENTARY
          8: GRADE 7 ELEMENTARY
          9: GRADE 8 ELEMENTARY
          10: GRADE 9 ELEMENTARY
          11: LEVEL 1 SECONDARY
          12: LEVEL 2 SECONDARY
          13: LEVEL 3 SECONDARY
          98: DON'T KNOW
          99: REFUSAL
    - id: EDU_Q7B
      kind: Question
      title: What grade(s) has he/she repeated? (Quebec) (MARK ONE ONLY. IF MORE THAN ONE REPORTED, MARK THE MOST RECENT.)
      precondition:
      - predicate: PROVINCE_2.outcome == 7
        hint: Asked only when question PROVINCE is "Quebec".
      - predicate: not (EDU_Q6.outcome == 1 and PROVINCE.outcome == 3)
        hint: Routing from EDU-Q6 and province.
      - predicate: not (EDU_Q6.outcome == 1 and PROVINCE.outcome == 4)
        hint: Routing from EDU-Q6 and province.
      - predicate: not (EDU_Q6.outcome == 1 and PROVINCE.outcome == 5)
        hint: Routing from EDU-Q6 and province.
      - predicate: not (EDU_Q7.outcome == 99)
        hint: Asked only when question EDU-Q7 is not "REFUSAL".
      - predicate: not (EDU_Q7A.outcome == 99)
        hint: Asked only when question EDU-Q7A is not "REFUSAL".
      input:
        control: Dropdown
        labels:
          1: KINDERGARTEN
          2: GRADE 1 ELEMENTARY
          3: GRADE 2 ELEMENTARY
          4: GRADE 3 ELEMENTARY
          5: GRADE 4 ELEMENTARY
          6: GRADE 5 ELEMENTARY
          7: GRADE 6 ELEMENTARY
          8: SECONDARY I
          9: SECONDARY II
          10: SECONDARY III
          11: SECONDARY IV
          12: SECONDARY V
          98: DON'T KNOW
          99: REFUSAL
    - id: EDU_Q7C
      kind: Question
      title: What grade(s) has he/she repeated? (Ontario) (MARK ONE ONLY. IF MORE THAN ONE REPORTED, MARK THE MOST RECENT.)
      precondition:
      - predicate: PROVINCE_2.outcome == 8
        hint: Asked only when question PROVINCE is "Ontario".
      - predicate: not (EDU_Q6.outcome == 1 and PROVINCE.outcome == 4)
        hint: Routing from EDU-Q6 and province.
      - predicate: not (EDU_Q6.outcome == 1 and PROVINCE.outcome == 5)
        hint: Routing from EDU-Q6 and province.
      - predicate: not (EDU_Q7.outcome == 99)
        hint: Asked only when question EDU-Q7 is not "REFUSAL".
      - predicate: not (EDU_Q7A.outcome == 99)
        hint: Asked only when question EDU-Q7A is not "REFUSAL".
      - predicate: not (EDU_Q7B.outcome == 99)
        hint: Asked only when question EDU-Q7B is not "REFUSAL".
      input:
        control: Dropdown
        labels:
          1: KINDERGARTEN
          2: GRADE 1
          3: GRADE 2
          4: GRADE 3
          5: GRADE 4
          6: GRADE 5
          7: GRADE 6
          8: GRADE 7
          9: GRADE 8
          10: GRADE 9
          11: GRADE 10
          12: GRADE 11
          13: GRADE 12
          14: OAC GRADE 13
          98: DON'T KNOW
          99: REFUSAL
    - id: EDU_Q7D
      kind: Question
      title: What grade(s) has he/she repeated? (Nova Scotia) (MARK ONE ONLY. IF MORE THAN ONE REPORTED, MARK THE MOST RECENT.)
      precondition:
      - predicate: PROVINCE_2.outcome == 9
        hint: Asked only when question PROVINCE is "Nova Scotia".
      - predicate: not (EDU_Q6.outcome == 1 and PROVINCE.outcome == 5)
        hint: Routing from EDU-Q6 and province.
      - predicate: not (EDU_Q7.outcome == 99)
        hint: Asked only when question EDU-Q7 is not "REFUSAL".
      - predicate: not (EDU_Q7A.outcome == 99)
        hint: Asked only when question EDU-Q7A is not "REFUSAL".
      - predicate: not (EDU_Q7B.outcome == 99)
        hint: Asked only when question EDU-Q7B is not "REFUSAL".
      - predicate: not (EDU_Q7C.outcome == 99)
        hint: Asked only when question EDU-Q7C is not "REFUSAL".
      input:
        control: Dropdown
        labels:
          1: PRIMARY
          2: GRADE 1
          3: GRADE 2
          4: GRADE 3
          5: GRADE 4
          6: GRADE 5
          7: GRADE 6
          8: GRADE 7
          9: GRADE 8
          10: GRADE 9
          11: GRADE 10
          12: GRADE 11
          13: GRADE 12
          98: DON'T KNOW
          99: REFUSAL
    - id: EDU_Q7E
      kind: Question
      title: What grade(s) has he/she repeated? (Prince Edward Island) (MARK ONE ONLY. IF MORE THAN ONE REPORTED, MARK THE MOST RECENT.)
      precondition:
      - predicate: PROVINCE_2.outcome == 10
        hint: Asked only when question PROVINCE is "Prince Edward Island".
      - predicate: not (EDU_Q7.outcome == 99)
        hint: Asked only when question EDU-Q7 is not "REFUSAL".
      - predicate: not (EDU_Q7A.outcome == 99)
        hint: Asked only when question EDU-Q7A is not "REFUSAL".
      - predicate: not (EDU_Q7B.outcome == 99)
        hint: Asked only when question EDU-Q7B is not "REFUSAL".
      - predicate: not (EDU_Q7C.outcome == 99)
        hint: Asked only when question EDU-Q7C is not "REFUSAL".
      - predicate: not (EDU_Q7D.outcome == 99)
        hint: Asked only when question EDU-Q7D is not "REFUSAL".
      input:
        control: Dropdown
        labels:
          1: GRADE 1
          2: GRADE 2
          3: GRADE 3
          4: GRADE 4
          5: GRADE 5
          6: GRADE 6
          7: GRADE 7
          8: GRADE 8
          9: GRADE 9
          10: GRADE 10
          11: GRADE 11
          12: GRADE 12
          98: DON'T KNOW
          99: REFUSAL
  - id: b_s34_p1_school
    title: School type
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    - predicate: not (EDU_Q7.outcome == 99)
      hint: Asked only when question EDU-Q7 is not "REFUSAL".
    - predicate: not (EDU_Q7A.outcome == 99)
      hint: Asked only when question EDU-Q7A is not "REFUSAL".
    - predicate: not (EDU_Q7B.outcome == 99)
      hint: Asked only when question EDU-Q7B is not "REFUSAL".
    - predicate: not (EDU_Q7C.outcome == 99)
      hint: Asked only when question EDU-Q7C is not "REFUSAL".
    - predicate: not (EDU_Q7D.outcome == 99)
      hint: Asked only when question EDU-Q7D is not "REFUSAL".
    - predicate: not (EDU_Q7E.outcome == 99)
      hint: Asked only when question EDU-Q7E is not "REFUSAL".
    items:
    - id: EDU_Q8
      kind: Question
      title: 'What type of school is ... currently in? Is it a: (READ LIST. MARK ONE ONLY.)'
      input:
        control: Radio
        labels:
          1: Public school?
          2: Catholic school, publicly funded?
          3: Private school?
          4: Other
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s34_p1_changes
    title: School changes
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    - predicate: not (EDU_Q7.outcome == 99)
      hint: Asked only when question EDU-Q7 is not "REFUSAL".
    - predicate: not (EDU_Q7A.outcome == 99)
      hint: Asked only when question EDU-Q7A is not "REFUSAL".
    - predicate: not (EDU_Q7B.outcome == 99)
      hint: Asked only when question EDU-Q7B is not "REFUSAL".
    - predicate: not (EDU_Q7C.outcome == 99)
      hint: Asked only when question EDU-Q7C is not "REFUSAL".
    - predicate: not (EDU_Q7D.outcome == 99)
      hint: Asked only when question EDU-Q7D is not "REFUSAL".
    - predicate: not (EDU_Q7E.outcome == 99)
      hint: Asked only when question EDU-Q7E is not "REFUSAL".
    - predicate: not (EDU_Q8.outcome == 9)
      hint: Asked only when question EDU-Q8 is not "REFUSAL".
    items:
    - id: EDU_Q9A
      kind: Question
      title: Other than natural progression through the school system in your area, has ... ever changed schools?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          3: NOT APPLICABLE
          8: DON'T KNOW
          9: REFUSAL
    - id: EDU_Q9B
      kind: Question
      title: How many times has he\she changed schools?
      precondition:
      - predicate: EDU_Q9A.outcome == 1
        hint: Asked only when question EDU-Q9A is "YES".
      - predicate: not (EDU_Q9A.outcome in [2, 3, 8, 9])
        hint: Asked only when question EDU-Q9A is none of "NO", "NOT APPLICABLE", "DON'T KNOW", "REFUSAL".
      input:
        control: Editbox
        min: 1
        max: 99
    - id: EDU_Q10
      kind: Question
      title: For the most recent change in schools, what was the reason for changing?
      precondition:
      - predicate: EDU_Q9A.outcome == 1
        hint: Asked only when question EDU-Q9A is "YES".
      - predicate: not (EDU_Q9A.outcome in [2, 3, 8, 9])
        hint: Asked only when question EDU-Q9A is none of "NO", "NOT APPLICABLE", "DON'T KNOW", "REFUSAL".
      input:
        control: Dropdown
        labels:
          1: FAMILY OR CHILD MOVED
          2: CHILD NOT PROGRESSING WELL ACADEMICALLY
          3: CHILD NOT PROGRESSING WELL IN LANGUAGE OF INSTRUCTION
          4: CHILD NOT GETTING ALONG WELL WITH OTHERS AT SCHOOL
          5: CONCERNS ABOUT SCHOOL'S ACADEMIC STANDARDS OR QUALITY
          6: CONCERNS ABOUT SCHOOL SAFETY OR DISCIPLINE
          7: CONCERNS ABOUT SCHOOL FACILITIES OR RESOURCES
          8: OTHER
          98: DON'T KNOW
          99: REFUSAL
  - id: b_s34_p1_current
    title: Current education
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    - predicate: not (EDU_Q7.outcome == 99)
      hint: Asked only when question EDU-Q7 is not "REFUSAL".
    - predicate: not (EDU_Q7A.outcome == 99)
      hint: Asked only when question EDU-Q7A is not "REFUSAL".
    - predicate: not (EDU_Q7B.outcome == 99)
      hint: Asked only when question EDU-Q7B is not "REFUSAL".
    - predicate: not (EDU_Q7C.outcome == 99)
      hint: Asked only when question EDU-Q7C is not "REFUSAL".
    - predicate: not (EDU_Q7D.outcome == 99)
      hint: Asked only when question EDU-Q7D is not "REFUSAL".
    - predicate: not (EDU_Q7E.outcome == 99)
      hint: Asked only when question EDU-Q7E is not "REFUSAL".
    - predicate: not (EDU_Q8.outcome == 9)
      hint: Asked only when question EDU-Q8 is not "REFUSAL".
    - predicate: not (EDU_Q10.outcome == 99)
      hint: Asked only when question EDU-Q10 is not "REFUSAL".
    items:
    - id: EDU_Q11
      kind: Question
      title: Aside from school changes, how many times in ...'s life has he/she moved, that is, changed his/her usual place of residence?
      input:
        control: Editbox
        min: 0
        max: 99
    - id: EDU_Q12A
      kind: Question
      title: 'CURRENT EDUCATION: In what language is he/she mainly taught?'
      input:
        control: Radio
        labels:
          1: ENGLISH
          2: FRENCH
          3: BOTH
          4: OTHER
          8: DON'T KNOW
          9: REFUSAL
    - id: EDU_Q12B
      kind: Question
      title: What language does he/she speak most often at home? (MARK ALL THAT APPLY.)
      precondition:
      - predicate: AGE_6.outcome <= 5
        hint: Asked only for children aged 5 or under.
      - predicate: not (EDU_Q12A.outcome == 9)
        hint: Asked only when question EDU-Q12A is not "REFUSAL".
      - predicate: not (EDU_Q12A.outcome != 9 and AGE_6.outcome > 5)
        hint: Routing from EDU-Q12A and the child's age.
      input:
        control: Checkbox
        labels:
          1: 1 — ENGLISH
          2: 2 — FRENCH
          4: 3 — OTHER
          8: 4 — NONE
          16: 8 — DON'T KNOW
          32: 9 — REFUSAL
    - id: EDU_Q13
      kind: Question
      title: Since he/she started school in the fall, about how many days has he/she been away from school for any reason?
      precondition:
      - predicate: not (EDU_Q12A.outcome == 9)
        hint: Asked only when question EDU-Q12A is not "REFUSAL".
      - predicate: not (EDU_Q12B.outcome & 32 > 0)
        hint: Not asked when EDU-Q12B was a refusal.
      input:
        control: Editbox
        min: 0
        max: 365
    - id: EDU_Q14A
      kind: Question
      title: 'GRADE ONE AND OVER: Based on your knowledge of his/her school work, including his/her report cards, how is ... doing in the following areas at school this year: reading?'
      precondition:
      - predicate: not (EDU_Q12A.outcome == 9)
        hint: Asked only when question EDU-Q12A is not "REFUSAL".
      - predicate: not (EDU_Q12B.outcome & 32 > 0)
        hint: Not asked when EDU-Q12B was a refusal.
      - predicate: not (EDU_Q1.outcome in [2, 8, 9] or EDU_Q1A.outcome in [2, 8, 9] or EDU_Q1B.outcome in [2, 3, 8, 9] or EDU_Q1C.outcome in [2, 3, 8, 9] or EDU_Q1D.outcome in [2, 8, 9] or EDU_Q1E.outcome in [8, 9])
        hint: Asked only for children in grade one and over.
      input:
        control: Radio
        labels:
          1: VERY WELL
          2: WELL
          3: AVERAGE
          4: POORLY
          5: VERY POORLY
          6: NOT APPLICABLE
          8: DON'T KNOW
          9: REFUSAL
    - id: EDU_Q14B
      kind: Question
      title: Mathematics?
      precondition:
      - predicate: not (EDU_Q12A.outcome == 9)
        hint: Asked only when question EDU-Q12A is not "REFUSAL".
      - predicate: not (EDU_Q12B.outcome & 32 > 0)
        hint: Not asked when EDU-Q12B was a refusal.
      - predicate: not (EDU_Q1.outcome in [2, 8, 9] or EDU_Q1A.outcome in [2, 8, 9] or EDU_Q1B.outcome in [2, 3, 8, 9] or EDU_Q1C.outcome in [2, 3, 8, 9] or EDU_Q1D.outcome in [2, 8, 9] or EDU_Q1E.outcome in [8, 9])
        hint: Asked only for children in grade one and over.
      - predicate: not (EDU_Q14A.outcome == 9)
        hint: Asked only when question EDU-Q14A is not "REFUSAL".
      input:
        control: Radio
        labels:
          1: VERY WELL
          2: WELL
          3: AVERAGE
          4: POORLY
          5: VERY POORLY
          6: NOT APPLICABLE
          8: DON'T KNOW
          9: REFUSAL
    - id: EDU_Q14C
      kind: Question
      title: Written work such as composition?
      precondition:
      - predicate: not (EDU_Q12A.outcome == 9)
        hint: Asked only when question EDU-Q12A is not "REFUSAL".
      - predicate: not (EDU_Q12B.outcome & 32 > 0)
        hint: Not asked when EDU-Q12B was a refusal.
      - predicate: not (EDU_Q1.outcome in [2, 8, 9] or EDU_Q1A.outcome in [2, 8, 9] or EDU_Q1B.outcome in [2, 3, 8, 9] or EDU_Q1C.outcome in [2, 3, 8, 9] or EDU_Q1D.outcome in [2, 8, 9] or EDU_Q1E.outcome in [8, 9])
        hint: Asked only for children in grade one and over.
      - predicate: not (EDU_Q14A.outcome == 9)
        hint: Asked only when question EDU-Q14A is not "REFUSAL".
      input:
        control: Radio
        labels:
          1: VERY WELL
          2: WELL
          3: AVERAGE
          4: POORLY
          5: VERY POORLY
          6: NOT APPLICABLE
          8: DON'T KNOW
          9: REFUSAL
    - id: EDU_Q14D
      kind: Question
      title: How is he/she doing overall?
      precondition:
      - predicate: not (EDU_Q12A.outcome == 9)
        hint: Asked only when question EDU-Q12A is not "REFUSAL".
      - predicate: not (EDU_Q12B.outcome & 32 > 0)
        hint: Not asked when EDU-Q12B was a refusal.
      - predicate: not (EDU_Q1.outcome in [2, 8, 9] or EDU_Q1A.outcome in [2, 8, 9] or EDU_Q1B.outcome in [2, 3, 8, 9] or EDU_Q1C.outcome in [2, 3, 8, 9] or EDU_Q1D.outcome in [2, 8, 9] or EDU_Q1E.outcome in [8, 9])
        hint: Asked only for children in grade one and over.
      - predicate: not (EDU_Q14A.outcome == 9)
        hint: Asked only when question EDU-Q14A is not "REFUSAL".
      input:
        control: Radio
        labels:
          1: VERY WELL
          2: WELL
          3: AVERAGE
          4: POORLY
          5: VERY POORLY
          6: NOT APPLICABLE
          8: DON'T KNOW
          9: REFUSAL
    - id: EDU_Q15A
      kind: Question
      title: Since ... started school in the fall, has he/she received any help or tutoring outside of school?
      precondition:
      - predicate: not (EDU_Q12A.outcome == 9)
        hint: Asked only when question EDU-Q12A is not "REFUSAL".
      - predicate: not (EDU_Q12B.outcome & 32 > 0)
        hint: Not asked when EDU-Q12B was a refusal.
      - predicate: not (EDU_Q1.outcome in [2, 8, 9] or EDU_Q1A.outcome in [2, 8, 9] or EDU_Q1B.outcome in [2, 3, 8, 9] or EDU_Q1C.outcome in [2, 3, 8, 9] or EDU_Q1D.outcome in [2, 8, 9] or EDU_Q1E.outcome in [8, 9])
        hint: Asked only for children in grade one and over.
      - predicate: not (EDU_Q14A.outcome == 9)
        hint: Asked only when question EDU-Q14A is not "REFUSAL".
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: EDU_Q15B
      kind: Question
      title: How often?
      precondition:
      - predicate: EDU_Q15A.outcome == 1
        hint: Asked only when question EDU-Q15A is "YES".
      - predicate: not (EDU_Q12A.outcome == 9)
        hint: Asked only when question EDU-Q12A is not "REFUSAL".
      - predicate: not (EDU_Q12B.outcome & 32 > 0)
        hint: Not asked when EDU-Q12B was a refusal.
      - predicate: not (EDU_Q1.outcome in [2, 8, 9] or EDU_Q1A.outcome in [2, 8, 9] or EDU_Q1B.outcome in [2, 3, 8, 9] or EDU_Q1C.outcome in [2, 3, 8, 9] or EDU_Q1D.outcome in [2, 8, 9] or EDU_Q1E.outcome in [8, 9])
        hint: Asked only for children in grade one and over.
      - predicate: not (EDU_Q14A.outcome == 9)
        hint: Asked only when question EDU-Q14A is not "REFUSAL".
      - predicate: not (EDU_Q15A.outcome in [2, 8, 9])
        hint: Asked only when question EDU-Q15A is none of "NO", "DON'T KNOW", "REFUSAL".
      input:
        control: Radio
        labels:
          1: ONCE A WEEK OR LESS OFTEN
          2: TWICE A WEEK
          3: MORE THAN TWICE A WEEK
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s34_p2_behaviour
    title: School contact and attitude
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of YES, DON'T KNOW, REFUSAL.
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not REFUSAL.
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not REFUSAL.
    - predicate: not (EDU_Q7.outcome == 99)
      hint: Asked only when question EDU-Q7 is not REFUSAL.
    - predicate: not (EDU_Q7A.outcome == 99)
      hint: Asked only when question EDU-Q7A is not REFUSAL.
    - predicate: not (EDU_Q7B.outcome == 99)
      hint: Asked only when question EDU-Q7B is not REFUSAL.
    - predicate: not (EDU_Q7C.outcome == 99)
      hint: Asked only when question EDU-Q7C is not REFUSAL.
    - predicate: not (EDU_Q7D.outcome == 99)
      hint: Asked only when question EDU-Q7D is not REFUSAL.
    - predicate: not (EDU_Q7E.outcome == 99)
      hint: Asked only when question EDU-Q7E is not REFUSAL.
    - predicate: not (EDU_Q8.outcome == 9)
      hint: Asked only when question EDU-Q8 is not REFUSAL.
    - predicate: not (EDU_Q10.outcome == 99)
      hint: Asked only when question EDU-Q10 is not REFUSAL.
    - predicate: not (EDU_Q12A.outcome == 9)
      hint: Asked only when question EDU-Q12A is not REFUSAL.
    - predicate: not (EDU_Q12B.outcome & 32 > 0)
      hint: Not asked when the EDU-Q12B answer includes option 32.
    - predicate: not (EDU_Q14A.outcome == 9)
      hint: Asked only when question EDU-Q14A is not REFUSAL.
    - predicate: not (EDU_Q15B.outcome == 9)
      hint: Asked only when question EDU-Q15B is not REFUSAL.
    items:
    - id: EDU_Q16
      kind: Question
      title: Since ... started school in the fall how many times have you been contacted by his/her school regarding his/her behaviour at school?
      input:
        control: Radio
        labels:
          1: NONE/ONCE
          2: TWICE/THREE TIMES
          3: FOUR OR MORE TIMES
          8: DON'T KNOW
          9: REFUSAL
    - id: EDU_Q17
      kind: Question
      title: With regard to how he/she feels about school, how often does he/she look forward to going to school?
      precondition:
      - predicate: not (EDU_Q16.outcome == 9)
        hint: Asked only when question EDU-Q16 is not REFUSAL.
      input:
        control: Radio
        labels:
          1: ALM0ST NEVER
          2: RARELY
          3: SOMETIMES
          4: OFTEN
          5: ALMOST ALWAYS
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s34_p2_expectations
    title: Parental expectations
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of YES, DON'T KNOW, REFUSAL.
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not REFUSAL.
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not REFUSAL.
    - predicate: not (EDU_Q7.outcome == 99)
      hint: Asked only when question EDU-Q7 is not REFUSAL.
    - predicate: not (EDU_Q7A.outcome == 99)
      hint: Asked only when question EDU-Q7A is not REFUSAL.
    - predicate: not (EDU_Q7B.outcome == 99)
      hint: Asked only when question EDU-Q7B is not REFUSAL.
    - predicate: not (EDU_Q7C.outcome == 99)
      hint: Asked only when question EDU-Q7C is not REFUSAL.
    - predicate: not (EDU_Q7D.outcome == 99)
      hint: Asked only when question EDU-Q7D is not REFUSAL.
    - predicate: not (EDU_Q7E.outcome == 99)
      hint: Asked only when question EDU-Q7E is not REFUSAL.
    - predicate: not (EDU_Q8.outcome == 9)
      hint: Asked only when question EDU-Q8 is not REFUSAL.
    - predicate: not (EDU_Q10.outcome == 99)
      hint: Asked only when question EDU-Q10 is not REFUSAL.
    - predicate: not (EDU_Q12A.outcome == 9)
      hint: Asked only when question EDU-Q12A is not REFUSAL.
    - predicate: not (EDU_Q12B.outcome & 32 > 0)
      hint: Not asked when the EDU-Q12B answer includes option 32.
    - predicate: not (EDU_Q14A.outcome == 9)
      hint: Asked only when question EDU-Q14A is not REFUSAL.
    - predicate: not (EDU_Q15B.outcome == 9)
      hint: Asked only when question EDU-Q15B is not REFUSAL.
    - predicate: not (EDU_Q16.outcome == 9)
      hint: Asked only when question EDU-Q16 is not REFUSAL.
    - predicate: not (EDU_Q17.outcome == 9)
      hint: Asked only when question EDU-Q17 is not REFUSAL.
    items:
    - id: EDU_Q18A
      kind: Question
      title: How important is it to you that ... have good grades in school?
      precondition:
      - predicate: AGE_6.outcome >= 8
        hint: Asked only of children aged 8 or older.
      - predicate: not (EDU_Q17.outcome != 9 and AGE_6.outcome < 8)
        hint: Asked only of children aged 8 or older.
      input:
        control: Radio
        labels:
          1: VERY IMPORTANT
          2: IMPORTANT
          3: SOMEWHAT IMPORTANT
          4: NOT IMPORTANT AT ALL
          8: DON'T KNOW
          9: REFUSAL
    - id: EDU_Q18B
      kind: Question
      title: How far do you hope he/she will go in school?
      precondition:
      - predicate: AGE_6.outcome < 8
        hint: Asked only of children younger than 8.
      - predicate: not (EDU_Q18A.outcome == 9)
        hint: Asked only when question EDU-Q18A is not REFUSAL.
      input:
        control: Radio
        labels:
          1: PRIMARY SCHOOL
          2: SECONDARY OR HIGH SCHOOL
          3: GO TO COMMUNITY COLLEGE, TECHNICAL COLLEGE OR CEGEP
          4: GO TO UNIVERSITY
          5: LEARN A TRADE
          6: OTHER
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s34_p2_school_description
    title: Description of present school
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of YES, DON'T KNOW, REFUSAL.
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not REFUSAL.
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not REFUSAL.
    - predicate: not (EDU_Q7.outcome == 99)
      hint: Asked only when question EDU-Q7 is not REFUSAL.
    - predicate: not (EDU_Q7A.outcome == 99)
      hint: Asked only when question EDU-Q7A is not REFUSAL.
    - predicate: not (EDU_Q7B.outcome == 99)
      hint: Asked only when question EDU-Q7B is not REFUSAL.
    - predicate: not (EDU_Q7C.outcome == 99)
      hint: Asked only when question EDU-Q7C is not REFUSAL.
    - predicate: not (EDU_Q7D.outcome == 99)
      hint: Asked only when question EDU-Q7D is not REFUSAL.
    - predicate: not (EDU_Q7E.outcome == 99)
      hint: Asked only when question EDU-Q7E is not REFUSAL.
    - predicate: not (EDU_Q8.outcome == 9)
      hint: Asked only when question EDU-Q8 is not REFUSAL.
    - predicate: not (EDU_Q10.outcome == 99)
      hint: Asked only when question EDU-Q10 is not REFUSAL.
    - predicate: not (EDU_Q12A.outcome == 9)
      hint: Asked only when question EDU-Q12A is not REFUSAL.
    - predicate: not (EDU_Q12B.outcome & 32 > 0)
      hint: Not asked when the EDU-Q12B answer includes option 32.
    - predicate: not (EDU_Q14A.outcome == 9)
      hint: Asked only when question EDU-Q14A is not REFUSAL.
    - predicate: not (EDU_Q15B.outcome == 9)
      hint: Asked only when question EDU-Q15B is not REFUSAL.
    - predicate: not (EDU_Q16.outcome == 9)
      hint: Asked only when question EDU-Q16 is not REFUSAL.
    - predicate: not (EDU_Q17.outcome == 9)
      hint: Asked only when question EDU-Q17 is not REFUSAL.
    - predicate: not (EDU_Q18A.outcome == 9)
      hint: Asked only when question EDU-Q18A is not REFUSAL.
    - predicate: not (EDU_Q18B.outcome == 9)
      hint: Asked only when question EDU-Q18B is not REFUSAL.
    - predicate: not (EDU_Q18A.outcome != 9 and (EDU_Q1.outcome in [2, 8, 9] or EDU_Q1A.outcome in [2, 8, 9] or EDU_Q1B.outcome in [2, 3, 8, 9] or EDU_Q1C.outcome in [2, 3, 8, 9] or EDU_Q1D.outcome in [2, 8, 9] or EDU_Q1E.outcome in [8, 9]))
      hint: Not asked after EDU-Q18A for the earlier education answers given.
    - predicate: not (EDU_Q18B.outcome != 9 and (EDU_Q1.outcome in [2, 8, 9] or EDU_Q1A.outcome in [2, 8, 9] or EDU_Q1B.outcome in [2, 3, 8, 9] or EDU_Q1C.outcome in [2, 3, 8, 9] or EDU_Q1D.outcome in [2, 8, 9] or EDU_Q1E.outcome in [8, 9]))
      hint: Not asked after EDU-Q18B for the earlier education answers given.
    items:
    - id: EDU_Q19A
      kind: Question
      title: The following are possible descriptions of his/her present school. For each, please indicate whether you strongly agree, agree, disagree, or strongly disagree. Academic progress is very important at this school.
      input:
        control: Radio
        labels:
          1: Strongly agree
          2: Agree
          3: Disagree
          4: Strongly disagree
    - id: EDU_Q19B
      kind: Question
      title: Most children in this school enjoy being there.
      input:
        control: Radio
        labels:
          1: Strongly agree
          2: Agree
          3: Disagree
          4: Strongly disagree
    - id: EDU_Q19C
      kind: Question
      title: Parents are made to feel welcome in this school.
      input:
        control: Radio
        labels:
          1: Strongly agree
          2: Agree
          3: Disagree
          4: Strongly disagree
    - id: EDU_Q19D
      kind: Question
      title: School spirit is very high.
      input:
        control: Radio
        labels:
          1: Strongly agree
          2: Agree
          3: Disagree
          4: Strongly disagree
  - id: b_s34_p2_special_education
    title: Special education
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of YES, DON'T KNOW, REFUSAL.
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not REFUSAL.
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not REFUSAL.
    - predicate: not (EDU_Q7.outcome == 99)
      hint: Asked only when question EDU-Q7 is not REFUSAL.
    - predicate: not (EDU_Q7A.outcome == 99)
      hint: Asked only when question EDU-Q7A is not REFUSAL.
    - predicate: not (EDU_Q7B.outcome == 99)
      hint: Asked only when question EDU-Q7B is not REFUSAL.
    - predicate: not (EDU_Q7C.outcome == 99)
      hint: Asked only when question EDU-Q7C is not REFUSAL.
    - predicate: not (EDU_Q7D.outcome == 99)
      hint: Asked only when question EDU-Q7D is not REFUSAL.
    - predicate: not (EDU_Q7E.outcome == 99)
      hint: Asked only when question EDU-Q7E is not REFUSAL.
    - predicate: not (EDU_Q8.outcome == 9)
      hint: Asked only when question EDU-Q8 is not REFUSAL.
    - predicate: not (EDU_Q10.outcome == 99)
      hint: Asked only when question EDU-Q10 is not REFUSAL.
    - predicate: not (EDU_Q12A.outcome == 9)
      hint: Asked only when question EDU-Q12A is not REFUSAL.
    - predicate: not (EDU_Q12B.outcome & 32 > 0)
      hint: Not asked when the EDU-Q12B answer includes option 32.
    - predicate: not (EDU_Q14A.outcome == 9)
      hint: Asked only when question EDU-Q14A is not REFUSAL.
    - predicate: not (EDU_Q15B.outcome == 9)
      hint: Asked only when question EDU-Q15B is not REFUSAL.
    - predicate: not (EDU_Q16.outcome == 9)
      hint: Asked only when question EDU-Q16 is not REFUSAL.
    - predicate: not (EDU_Q17.outcome == 9)
      hint: Asked only when question EDU-Q17 is not REFUSAL.
    - predicate: not (EDU_Q18A.outcome == 9)
      hint: Asked only when question EDU-Q18A is not REFUSAL.
    - predicate: not (EDU_Q18B.outcome == 9)
      hint: Asked only when question EDU-Q18B is not REFUSAL.
    items:
    - id: EDU_Q20
      kind: Question
      title: Does ... receive special education because a physical, emotional, behavioral, or some other problem limits the kind or amount of school work he/she can do?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s35_read_screen
    title: LITERACY
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    items:
    - id: LIT_Q1
      kind: Question
      title: Do you or another adult ever read to ..., or show him/her pictures or wordless baby books?
      precondition:
      - predicate: AGE_MONTHS_2.outcome <= 23
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s35_read_details
    title: 'LITERACY: reading frequency and starting age'
    precondition:
    - predicate: not (HLT_Q27.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q27 is none of "YES", "DON'T KNOW", "REFUSAL".
    - predicate: not (HLT_Q28.outcome == 9)
      hint: Asked only when question HLT-Q28 is not "REFUSAL".
    - predicate: not (HLT_Q29.outcome == 9)
      hint: Asked only when question HLT-Q29 is not "REFUSAL".
    - predicate: LIT_Q1.outcome == 1
      hint: Asked only when question LIT-Q1 is "YES".
    items:
    - id: LIT_Q2
      kind: Question
      title: How often do you do this?
      input:
        control: Dropdown
        labels:
          1: 01 — RARELY
          2: 02 — LESS THAN ONCE A MONTH
          3: 03 — ONCE A MONTH
          4: 04 — A FEW TIMES A MONTH
          5: 05 — ONCE A WEEK
          6: 06 — A FEW TIMES A WEEK
          7: 07 — DAILY
          8: 08 — MANY TIMES EACH DAY
          98: DON'T KNOW
          99: REFUSAL
    - id: LIT_Q3
      kind: Question
      title: How old was he/she when you started to do this (to nearest month)?
      postcondition:
      - predicate: LIT_Q3.outcome <= AGE_MONTHS_2.outcome
        hint: La edad (en meses) a la que empezó la lectura (LIT-Q3) no puede ser mayor que la edad actual del niño en meses (AGE_MONTHS).
        invented: true
      input:
        control: Editbox
        min: 0
        max: 23
  - id: b_s36_feelings
    title: 'Health: feelings, memory, thinking, pain and discomfort'
    items:
    - id: HLT_Q31
      kind: Question
      title: 'FEELINGS: Would you describe ... as being usually: (READ LIST. MARK ONE ONLY.)'
      input:
        control: Radio
        labels:
          1: Happy and interested in life?
          2: Somewhat happy?
          3: Somewhat unhappy?
          4: Unhappy with little interest in life?
          5: So unhappy that life is not worthwhile?
          8: DON'T KNOW
          9: REFUSAL
    - id: HLT_Q32
      kind: Question
      title: 'MEMORY: How would you describe his/her usual ability to remember things? Is he/she: (READ LIST. MARK ONE ONLY.)'
      input:
        control: Radio
        labels:
          1: Able to remember most things?
          2: Somewhat forgetful?
          3: Very forgetful?
          4: Unable to remember anything at all?
          8: DON'T KNOW
          9: REFUSAL
    - id: HLT_Q33
      kind: Question
      title: 'THINKING: How would you describe his/her usual ability to think and solve day-to-day problems? Is he/she: (READ LIST. MARK ONE ONLY.)'
      input:
        control: Radio
        labels:
          1: Able to think clearly and solve problems?
          2: Having a little difficulty?
          3: Having some difficulty?
          4: Having a great deal of difficulty?
          5: Unable to think or solve problems?
          8: DON'T KNOW
          9: REFUSAL
    - id: HLT_Q34
      kind: Question
      title: 'PAIN AND DISCOMFORT: Is ... usually free of pain or discomfort?'
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s36_pain_followup
    title: Pain and discomfort follow-up
    precondition:
    - predicate: HLT_Q34.outcome == 2
      hint: Asked only when question HLT-Q34 is "NO".
    - predicate: not (HLT_Q34.outcome in [1, 8, 9])
      hint: Asked only when question HLT-Q34 is none of "YES", "DON'T KNOW", "REFUSAL".
    items:
    - id: HLT_Q35
      kind: Question
      title: 'How would you describe the usual intensity of his/her pain or discomfort: (READ LIST. MARK ONE ONLY.)'
      input:
        control: Radio
        labels:
          1: Mild?
          2: Moderate?
          3: Severe?
          8: DON'T KNOW
          9: REFUSAL
    - id: HLT_Q36
      kind: Question
      title: How many activities does his/her pain or discomfort prevent? (READ LIST. MARK ONE ONLY.)
      precondition:
      - predicate: HLT_Q34.outcome == 2 and HLT_Q35.outcome != 9
        hint: Asked only when the pain intensity question HLT-Q35 was not refused.
      - predicate: not (HLT_Q35.outcome == 9)
        hint: Asked only when question HLT-Q35 is not "REFUSAL".
      input:
        control: Radio
        labels:
          1: None?
          2: A few?
          3: Some?
          4: Most?
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s36_injury_screen
    title: Injuries
    items:
    - id: HLT_Q37
      kind: Question
      title: 'INJURIES (HLT-I37: The following questions refer to injuries, such as a broken bone, bad cut or burn, head injury, poisoning, or a sprained ankle, which occurred in the past 12 months, and were serious enough to require medical attention by a doctor, nurse, or dentist.) In the past 12 months was ... injured?'
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s36_injury_details
    title: Injury details
    precondition:
    - predicate: HLT_Q37.outcome == 1
      hint: Asked only when question HLT-Q37 is "YES".
    - predicate: not (HLT_Q37.outcome in [2, 8, 9])
      hint: Asked only when question HLT-Q37 is none of "NO", "DON'T KNOW", "REFUSAL".
    items:
    - id: HLT_Q38
      kind: Question
      title: How many times was he/she injured? |_|_| TIMES
      input:
        control: Editbox
        min: 1
        max: 99
        right: TIMES
    - id: HLT_Q39
      kind: Question
      title: For the most serious injury, what type of injury did he/she have? (DO NOT READ LIST. MARK ONE ONLY.)
      input:
        control: Dropdown
        labels:
          1: 01 — BROKEN OR FRACTURED BONES
          2: 02 — BURN OR SCALD
          3: 03 — DISLOCATION
          4: 04 — SPRAIN OR STRAIN
          5: 05 — CUT, SCRAPE OR BRUISE
          6: 06 — CONCUSSION
          7: 07 — POISONING BY SUBSTANCE OR LIQUID
          8: 08 — INTERNAL INJURY
          9: 09 — DENTAL INJURY
          10: 10 — OTHER
          11: 11 — MULTIPLE INJURIES
          98: DON'T KNOW
          99: REFUSAL
    - id: HLT_Q40
      kind: Question
      title: What part of his/her body was injured? (DO NOT READ LIST. MARK ONE ONLY.)
      precondition:
      - predicate: HLT_Q39.outcome in [1, 2, 3, 4, 5]
        hint: Asked only when the type of injury in HLT-Q39 is a fracture, burn, dislocation, sprain or cut.
      - predicate: not (HLT_Q39.outcome == 99)
        hint: Asked only when question HLT-Q39 is not "REFUSAL".
      - predicate: not (HLT_Q39.outcome in [6, 7, 8, 9, 10, 11, 98])
        hint: Asked only when the type of injury in HLT-Q39 is not concussion, poisoning, internal, dental, other, multiple or don't know.
      input:
        control: Dropdown
        labels:
          1: 01 — EYES
          2: 02 — FACE OR SCALP (EXCLUDING EYES)
          3: 03 — HEAD OR NECK (EXCLUDING EYES AND FACE OR SCALP)
          4: 04 — ARMS OR HANDS
          5: 05 — LEGS OR FEET
          6: 06 — BACK OR SPINE
          7: 07 — TRUNK (EXCLUDING BACK OR SPINE) (INCLUDE CHEST, INTERNAL ORGANS, ETC.)
          8: 08 — SHOULDER
          9: 09 — HIP
          10: 10 — MULTIPLE SITES
          98: DON'T KNOW
          99: REFUSAL
    - id: HLT_Q41
      kind: Question
      title: What happened, for example, was the injury the result of a fall, motor vehicle collision, a physical assault, etc.? (DO NOT READ LIST. MARK ONE ONLY.)
      precondition:
      - predicate: not (HLT_Q39.outcome == 99)
        hint: Asked only when question HLT-Q39 is not "REFUSAL".
      - predicate: not (HLT_Q40.outcome == 99)
        hint: Asked only when question HLT-Q40 is not "REFUSAL".
      input:
        control: Dropdown
        labels:
          1: 01 — MOTOR VEHICLE COLLISION-PASSENGER
          2: 02 — MOTOR VEHICLE COLLISION-PEDESTRIAN
          3: 03 — MOTOR VEHICLE COLLISION-RIDING BICYCLE
          4: 04 — OTHER BICYCLE ACCIDENT
          5: 05 — FALL (EXCLUDING BICYCLE OR SPORTS)
          6: 06 — SPORTS (EXCLUDING BICYCLE)
          7: 07 — PHYSICAL ASSAULT
          8: 08 — SCALDED BY HOT LIQUIDS OR FOOD
          9: 09 — ACCIDENTAL POISONING
          10: 10 — SELF-INFLICTED POISONING
          11: 11 — OTHER INTENTIONALLY SELF-INFLICTED INJURIES
          12: 12 — NATURAL/ENVIRONMENTAL FACTORS (EX. ANIMAL BITE, STING)
          13: 13 — FIRE/FLAMES OR RESULTING FUMES
          14: 14 — NEAR DROWNING
          15: 15 — OTHER
          98: DON'T KNOW
          99: REFUSAL
    - id: HLT_Q42
      kind: Question
      title: Where did the injury happen, for example at home, on the street, in a playground, at school, etc.? (DO NOT READ LIST. MARK ONE ONLY.)
      precondition:
      - predicate: not (HLT_Q39.outcome == 99)
        hint: Asked only when question HLT-Q39 is not "REFUSAL".
      - predicate: not (HLT_Q40.outcome == 99)
        hint: Asked only when question HLT-Q40 is not "REFUSAL".
      - predicate: not (HLT_Q41.outcome == 99)
        hint: Asked only when question HLT-Q41 is not "REFUSAL".
      input:
        control: Dropdown
        labels:
          1: 01 — INSIDE RESPONDENT'S OWN HOME/APARTMENT
          2: 02 — OUTSIDE RESPONDENT'S HOME, APARTMENT, INCLUDING YARD, DRIVEWAY, PARKING LOT OR IN SHARED AREAS RELATED TO HOME SUCH AS APARTMENT HALLWAY OR LAUNDRY ROOM
          3: 03 — IN OR AROUND OTHER PRIVATE RESIDENCE
          4: 04 — INSIDE SCHOOL/DAYCARE CENTRE OR ON SCHOOL/CENTRE GROUNDS
          5: 05 — AT AN INDOOR OR OUTDOOR SPORTS FACILITY (OTHER THAN SCHOOL)
          6: 06 — OTHER BUILDING USED BY GENERAL PUBLIC
          7: 07 — ON SIDEWALK/STREET/HIGHWAY IN RESPONDENT'S NEIGHBOURHOOD
          8: 08 — ON ANY OTHER SIDEWALK/STREET/HIGHWAY
          9: 09 — IN A PLAYGROUND/PARK (OTHER THAN SCHOOL)
          10: 10 — OTHER
          98: DON'T KNOW
          99: REFUSAL
  - id: b_s36_asthma_screen
    title: Asthma
    items:
    - id: HLT_Q43A
      kind: Question
      title: The following questions are about asthma. Has ... ever had asthma that was diagnosed by a health professional?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s36_asthma_followup
    title: Asthma follow-up
    precondition:
    - predicate: HLT_Q43A.outcome in [1, 8]
      hint: Asked only when question HLT-Q43A is one of "YES", "DON'T KNOW".
    - predicate: not (HLT_Q43A.outcome == 2)
      hint: Asked only when question HLT-Q43A is not "NO".
    - predicate: not (HLT_Q43A.outcome == 9 and AGE_6.outcome < 6)
      hint: Not asked when HLT-Q43A was refused for a child under 6.
    - predicate: not (HLT_Q43A.outcome == 9 and AGE_6.outcome >= 6)
      hint: Not asked when HLT-Q43A was refused for a child aged 6 or over.
    items:
    - id: HLT_Q43B
      kind: Question
      title: Does this condition or health problem prevent or limit his/her participation in school, at play or any other activity normal for a child his/her age?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: HLT_Q43C
      kind: Question
      title: Has he/she had an attack of asthma in the last 12 months?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s36_wheezing
    title: Wheezing
    items:
    - id: HLT_Q44
      kind: Question
      title: Has he/she had wheezing or whistling in the chest at any time in the last 12 months?
      precondition:
      - predicate: HLT_Q43A.outcome != 9
        hint: Asked only when question HLT-Q43A is not "REFUSAL".
      - predicate: not (HLT_Q43A.outcome == 9 and AGE_6.outcome < 6)
        hint: Not asked when HLT-Q43A was refused for a child under 6.
      - predicate: not (HLT_Q43A.outcome == 9 and AGE_6.outcome >= 6)
        hint: Not asked when HLT-Q43A was refused for a child aged 6 or over.
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s36_longterm
    title: Long-term conditions
    items:
    - id: HLT_Q45
      kind: Question
      title: 'LONG-TERM CONDITIONS: In the following questions long-term conditions refer to conditions that have lasted or are expected to last 6 months or more. Does ... have any of the following long-term conditions that have been diagnosed by a health professional? (READ LIST. MARK ALL THAT APPLY)'
      precondition:
      - predicate: AGE_6.outcome < 6
        hint: Asked only for children under 6.
      - predicate: not (HLT_Q43A.outcome == 9 and AGE_6.outcome >= 6)
        hint: Not asked when HLT-Q43A was refused for a child aged 6 or over.
      - predicate: not (AGE_6.outcome >= 6)
        hint: Not asked for children aged 6 or over.
      postcondition:
      - predicate: not (HLT_Q45.outcome & 256 > 0 and HLT_Q45.outcome & 255 > 0)
        hint: No se puede marcar 'None' (09) junto con una enfermedad de larga duración en HLT-Q45; corrija la respuesta.
        invented: true
      input:
        control: Checkbox
        labels:
          1: 01 — Allergies?
          2: 02 — Bronchitis?
          4: 03 — Heart condition or disease?
          8: 04 — Epilepsy?
          16: 05 — Cerebral Palsy?
          32: 06 — Kidney Condition or disease?
          64: 07 — Mental handicap?
          128: 08 — Any other long term condition?
          256: 09 — None
          512: 98 — DON'T KNOW
          1024: 99 — REFUSAL
    - id: HLT_Q45A
      kind: Question
      title: In the following questions long-term conditions refer to conditions that have lasted or are expected to last 6 months or more. Does.... have any of the following long-term conditions that have been diagnosed by a health professional? (READ LIST. MARK ALL THAT APPLY)
      precondition:
      - predicate: AGE_6.outcome >= 6
        hint: Asked only for children aged 6 or over.
      - predicate: HLT_Q45.outcome is None or not (HLT_Q45.outcome >= 0)
        hint: Not asked when HLT-Q45 was answered.
      postcondition:
      - predicate: not (HLT_Q45A.outcome & 1024 > 0 and HLT_Q45A.outcome & 1023 > 0)
        hint: No se puede marcar 'None' (11) junto con una enfermedad de larga duración en HLT-Q45A; corrija la respuesta.
        invented: true
      input:
        control: Checkbox
        labels:
          1: 01 — Allergies?
          2: 02 — Bronchitis?
          4: 03 — Heart condition or disease?
          8: 04 — Epilepsy?
          16: 05 — Cerebral Palsy?
          32: 06 — Kidney Condition or disease?
          64: 07 — Mental handicap?
          128: 08 — Learning disability?
          256: 09 — Emotional, psychological or nervous difficulties?
          512: 10 — Any other long term condition?
          1024: 11 — None
          2048: 98 — DON'T KNOW
          4096: 99 — REFUSAL
    - id: HLT_Q45B
      kind: Question
      title: Does ... have any long term conditions or health problems which prevent or limit his/her participation in school, at play, or in any other activity for a child of his/her age?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s36_infections
    title: Nose, throat and ear infections
    precondition:
    - predicate: AGE_6.outcome <= 3
      hint: Asked only for children aged 3 or under.
    - predicate: not (AGE_6.outcome > 3)
      hint: Not asked for children over 3.
    items:
    - id: HLT_Q46
      kind: Question
      title: How often does ... have nose or throat infections?
      input:
        control: Radio
        labels:
          1: ALMOST ALL THE TIME
          2: OFTEN
          3: FROM TIME TO TIME
          4: RARELY
          5: NEVER
          8: DON'T KNOW
          9: REFUSAL
    - id: HLT_Q47A
      kind: Question
      title: Since his/her birth, has he/she had an ear infection (otitis)?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: HLT_Q47B
      kind: Question
      title: How many times?
      precondition:
      - predicate: HLT_Q47A.outcome == 1
        hint: Asked only when question HLT-Q47A is "YES".
      - predicate: not (HLT_Q47A.outcome in [2, 8, 9])
        hint: Asked only when question HLT-Q47A is none of "NO", "DON'T KNOW", "REFUSAL".
      input:
        control: Radio
        labels:
          1: ONCE
          2: 2 TIMES
          3: 3 TIMES
          4: 4 OR MORE TIMES
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s36_health_prof_first
    title: Use of health professionals
    items:
    - id: HLT_Q48A
      kind: Question
      title: 'USE OF HEALTH PROFESSIONALS (HLT-I48: In the past year, how many times have you seen or talked on the telephone with any of the following about ...''s physical or mental health? (Exclude at time of birth for babies.)) A general practitioner, family physician? (ENTER 0 IF NONE.) |_|_| TIMES'
      input:
        control: Editbox
        min: 0
        max: 99
        right: TIMES (98 = DON'T KNOW, 99 = REFUSAL)
  - id: b_s36_health_prof_rest
    title: Use of health professionals (continued)
    precondition:
    - predicate: HLT_Q48A.outcome != 99
      hint: Asked only when question HLT-Q48A is not "REFUSAL".
    - predicate: not (HLT_Q48A.outcome == 99)
      hint: Asked only when question HLT-Q48A is not "REFUSAL".
    items:
    - id: HLT_Q48B
      kind: Question
      title: A pediatrician?
      input:
        control: Editbox
        min: 0
        max: 99
        right: TIMES (98 = DON'T KNOW, 99 = REFUSAL)
    - id: HLT_Q48C
      kind: Question
      title: An other medical doctor (such as an orthopedist, or eye specialist)?
      input:
        control: Editbox
        min: 0
        max: 99
        right: TIMES (98 = DON'T KNOW, 99 = REFUSAL)
    - id: HLT_Q48D
      kind: Question
      title: A public health nurse or nurse practitioner?
      input:
        control: Editbox
        min: 0
        max: 99
        right: TIMES (98 = DON'T KNOW, 99 = REFUSAL)
    - id: HLT_Q48E
      kind: Question
      title: A dentist or orthodontist?
      input:
        control: Editbox
        min: 0
        max: 99
        right: TIMES (98 = DON'T KNOW, 99 = REFUSAL)
    - id: HLT_Q48G
      kind: Question
      title: A psychiatrist or psychologist?
      input:
        control: Editbox
        min: 0
        max: 99
        right: TIMES (98 = DON'T KNOW, 99 = REFUSAL)
    - id: HLT_Q48H
      kind: Question
      title: Child welfare worker or children's aid worker?
      input:
        control: Editbox
        min: 0
        max: 99
        right: TIMES (98 = DON'T KNOW, 99 = REFUSAL)
    - id: HLT_Q48I
      kind: Question
      title: Any other person trained to provide treatment or counsel, for example a speech therapist, a social worker?
      input:
        control: Editbox
        min: 0
        max: 99
        right: TIMES (98 = DON'T KNOW, 99 = REFUSAL)
  - id: b_s36_hospital
    title: Hospital stays
    items:
    - id: HLT_Q49
      kind: Question
      title: In the past 12 months, was ... ever an overnight patient in a hospital?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
    - id: HLT_Q50
      kind: Question
      title: For what reason?
      precondition:
      - predicate: HLT_Q49.outcome == 1
        hint: Asked only when question HLT-Q49 is "YES".
      - predicate: not (HLT_Q49.outcome in [2, 8])
        hint: Asked only when question HLT-Q49 is none of "NO", "DON'T KNOW".
      input:
        control: Radio
        labels:
          1: RESPIRATORY ILLNESS OR DISEASE
          2: GASTROINTESTINAL ILLNESS OR DISEASE
          3: INJURIES
          4: OTHER
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s36_medication_first
    title: Use of medication
    items:
    - id: HLT_Q51A
      kind: Question
      title: 'USE OF MEDICATION: Does he/she take any of the following prescribed medication on a regular basis: Ventolin or other inhalants?'
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s36_medication_rest
    title: Use of medication (continued)
    precondition:
    - predicate: HLT_Q51A.outcome != 9
      hint: Asked only when question HLT-Q51A is not "REFUSAL".
    - predicate: not (HLT_Q51A.outcome == 9 and AGE_6.outcome < 4)
      hint: Not asked when HLT-Q51A was refused for a child under 4.
    - predicate: not (HLT_Q51A.outcome == 9 and AGE_6.outcome >= 4)
      hint: Not asked when HLT-Q51A was refused for a child aged 4 or over.
    items:
    - id: HLT_Q51B
      kind: Question
      title: Ritalin?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: HLT_Q51C
      kind: Question
      title: Tranquilizers or nerve pills?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: HLT_Q51D
      kind: Question
      title: Anti-convulsants or anti-epileptic pills?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: HLT_Q51E
      kind: Question
      title: Other?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s36_stress
    title: Stressful events
    precondition:
    - predicate: AGE_6.outcome >= 4
      hint: Asked only for children aged 4 or over.
    - predicate: not (HLT_Q51A.outcome == 9 and AGE_6.outcome < 4)
      hint: Not asked when HLT-Q51A was refused for a child under 4.
    - predicate: not (AGE_6.outcome < 4)
      hint: Not asked for children under 4.
    items:
    - id: HLT_Q52A
      kind: Question
      title: Has ... ever experienced any event or situation that has caused him/her a great amount of worry or unhappiness?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
    - id: HLT_Q52B
      kind: Question
      title: What was this? (DO NOT READ LIST. MARK ALL THAT APPLY.)
      precondition:
      - predicate: HLT_Q52A.outcome == 1
        hint: Asked only when question HLT-Q52A is "YES".
      - predicate: not (HLT_Q52A.outcome == 2)
        hint: Asked only when question HLT-Q52A is not "NO".
      input:
        control: Checkbox
        labels:
          1: 01 — DEATH OF PARENTS
          2: 02 — DEATH IN FAMILY (OTHER THAN PARENTS)
          4: 03 — DIVORCE/SEPARATION OF PARENTS
          8: 04 — MOVE
          16: 05 — STAY IN HOSPITAL
          32: 06 — STAY IN FOSTER HOME
          64: 07 — OTHER SEPARATION FROM PARENTS
          128: 08 — ILLNESS/INJURY OF CHILD
          256: 09 — ILLNESS/INJURY OF A FAMILY MEMBER
          512: 10 — ABUSE/FEAR OF ABUSE
          1024: 11 — CHANGE IN HOUSEHOLD MEMBERS
          2048: 12 — ALCOHOLISM OR MENTAL HEALTH DISORDER IN FAMILY
          4096: 13 — CONFLICT BETWEEN PARENTS
          8192: 14 — OTHER
          16384: 98 — DON'T KNOW
          32768: 99 — REFUSAL
  - id: b_s37_prenatal_health
    title: 'MEDICAL/BIOLOGICAL: Prenatal'
    items:
    - id: MED_Q1A
      kind: Question
      title: 'PRENATAL QUESTIONS: The following are prenatal questions concerning .... During the pregnancy with ... did you suffer from any of the following: pregnancy diabetes?'
      precondition:
      - predicate: AGE_6.outcome <= 3 and RESPONDENT.outcome == 1 and AGE_MONTHS_2.outcome <= 23
        hint: Asked of the person most knowledgeable about children aged 0-3 years
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: MED_Q1B
      kind: Question
      title: High blood pressure?
      precondition:
      - predicate: MED_Q1A.outcome != 9
        hint: Asked only when question MED-Q1A is not "REFUSAL".
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: MED_Q1C
      kind: Question
      title: Other physical problems?
      precondition:
      - predicate: MED_Q1A.outcome != 9
        hint: Asked only when question MED-Q1A is not "REFUSAL".
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: MED_Q2
      kind: Question
      title: From whom did you receive pre-natal care?
      input:
        control: Radio
        labels:
          1: A DOCTOR
          2: A NURSE
          3: A MIDWIFE
          4: OTHER
          5: NOBODY
    - id: MED_Q3
      kind: Question
      title: Did you smoke during your pregnancy with ...?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
  - id: b_s37_smoking_amount
    title: Smoking during pregnancy
    precondition:
    - predicate: MED_Q3.outcome == 1
      hint: Asked only when question MED-Q3 is "YES".
    items:
    - id: MED_Q4
      kind: Question
      title: How many cigarettes per day did you smoke during your pregnancy with ...? |_|_| Number of cigarettes
      input:
        control: Editbox
        min: 1
        max: 99
    - id: MED_Q5
      kind: Question
      title: At what stage in your pregnancy did you smoke this amount? (MARK MORE THAN ONE IF NECESSARY)
      input:
        control: Checkbox
        labels:
          1: 1 — DURING THE FIRST THREE MONTHS
          2: 2 — DURING THE SECOND THREE MONTHS
          4: 3 — DURING THE THIRD THREE MONTHS
          8: 4 — THROUGHOUT
  - id: b_s37_alcohol_frequency
    title: Alcohol during pregnancy
    items:
    - id: MED_Q6
      kind: Question
      title: How frequently did you consume alcohol during your pregnancy with ... (Eg. Beer, wine, liquor)?
      input:
        control: Radio
        labels:
          1: NEVER
          2: LESS THAN ONCE A MONTH
          3: 1-3 TIMES A MONTH
          4: ONCE A WEEK
          5: 2-3 TIMES A WEEK
          6: 4-6 TIMES A WEEK
          7: EVERYDAY
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s37_alcohol_amount
    title: Alcohol quantity during pregnancy
    precondition:
    - predicate: MED_Q6.outcome in [2, 3, 4, 5, 6, 7, 8]
      hint: Asked only when question MED-Q6 is not "NEVER" or "REFUSAL".
    items:
    - id: MED_Q7
      kind: Question
      title: On the days when you drank, how many drinks did you usually have?
      input:
        control: Radio
        labels:
          1: 1 TO 2
          2: 3 TO 4
          3: 5 OR MORE
          8: DON'T KNOW
          9: REFUSAL
    - id: MED_Q8
      kind: Question
      title: At what stage in your pregnancy did you consume this quantity? (MARK MORE THAN ONE IF NECESSARY)
      precondition:
      - predicate: MED_Q7.outcome != 9
        hint: Asked only when question MED-Q7 is not "REFUSAL".
      input:
        control: Checkbox
        labels:
          1: 1 — DURING THE FIRST THREE MONTHS
          2: 2 — DURING THE SECOND THREE MONTHS
          4: 3 — DURING THE THIRD THREE MONTHS
          8: 4 — THROUGHOUT
          16: 8 — DON'T KNOW
          32: 9 — REFUSAL
  - id: b_s37_medications
    title: Medications during pregnancy
    items:
    - id: MED_Q9A
      kind: Question
      title: Did you take any prescription medications during your pregnancy with ...?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: MED_Q9B
      kind: Question
      title: At what stage in your pregnancy did you take these? (MARK ALL THAT APPLY)
      precondition:
      - predicate: MED_Q9A.outcome == 1
        hint: Asked only when question MED-Q9A is "YES".
      input:
        control: Checkbox
        labels:
          1: 1 — DURING THE FIRST THREE MONTHS
          2: 2 — DURING THE SECOND THREE MONTHS
          4: 3 — DURING THE THIRD THREE MONTHS
          8: 4 — THROUGHOUT
          16: 8 — DON'T KNOW
          32: 9 — REFUSAL
    - id: MED_Q10A
      kind: Question
      title: Did you take any over-the-counter drugs during your pregnancy with ...?
      precondition:
      - predicate: MED_Q9A.outcome != 9 and (MED_Q9B.outcome is None or MED_Q9B.outcome // 32 % 2 == 0)
        hint: Asked only when MED-Q9A and MED-Q9B were not "REFUSAL".
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: MED_Q10B
      kind: Question
      title: At what stage in your pregnancy did you take these? (MARK ALL THAT APPLY)
      precondition:
      - predicate: MED_Q10A.outcome == 1 and MED_Q9A.outcome != 9 and (MED_Q9B.outcome is None or MED_Q9B.outcome // 32 % 2 == 0)
        hint: Asked only when question MED-Q10A is "YES".
      input:
        control: Checkbox
        labels:
          1: 1 — DURING THE FIRST THREE MONTHS
          2: 2 — DURING THE SECOND THREE MONTHS
          4: 3 — DURING THE THIRD THREE MONTHS
          8: 4 — THROUGHOUT
          16: 8 — DON'T KNOW
          32: 9 — REFUSAL
  - id: b_s37_birth
    title: Birth
    precondition:
    - predicate: AGE_6.outcome <= 3 and RESPONDENT.outcome in [1, 2]
      hint: Asked of children aged 0-3 years
    items:
    - id: MED_Q12A
      kind: Question
      title: The following are questions concerning ... 's birth. Was he/she born before or after the due date?
      input:
        control: Radio
        labels:
          1: BEFORE
          2: AFTER
          3: ON DUE DATE
    - id: MED_Q12B
      kind: Question
      title: How many days or weeks before or after the due date was he/she born?
      precondition:
      - predicate: MED_Q12A.outcome in [1, 2]
        hint: Asked only when question MED-Q12A is "BEFORE" or "AFTER".
      input:
        control: Textarea
  - id: b_s37_birth_measures
    title: Birth weight and length
    items:
    - id: MED_Q13A
      kind: Question
      title: What was his/her birth weight in kilograms and grams or pounds and ounces?
      input:
        control: Textarea
    - id: MED_Q14A
      kind: Question
      title: What was his/her length at birth in centimetres or inches?
      input:
        control: Textarea
    - id: MED_Q15
      kind: Question
      title: 'DELIVERY: Was this a single birth or twins, or triplets?'
      input:
        control: Radio
        labels:
          1: SINGLE BIRTH
          2: TWINS
          3: TRIPLETS
          4: MORE THAN TRIPLETS
          8: DON'T KNOW
          9: REFUSAL
    - id: MED_Q16
      kind: Question
      title: Was the delivery vaginal or caesarian?
      precondition:
      - predicate: AGE_MONTHS_2.outcome <= 11 and MED_Q15.outcome != 9
        hint: Asked only for children under 12 months, when MED-Q15 is not "REFUSAL".
      input:
        control: Radio
        labels:
          1: VAGINAL
          2: CAESARIAN
  - id: b_s37_vaginal_delivery
    title: Vaginal delivery details
    precondition:
    - predicate: AGE_MONTHS_2.outcome <= 11 and MED_Q16.outcome == 1 and MED_Q15.outcome != 9
      hint: Asked only for vaginal deliveries of children under 12 months.
    items:
    - id: MED_Q17
      kind: Question
      title: Was ... born head first?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: MED_Q18
      kind: Question
      title: Were birthing aids used?
      input:
        control: Radio
        labels:
          1: NONE
          2: FORCEPS
          3: CUPPING GLASS (SUCTION CUP)
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s37_infant_care
    title: Infant after birth
    precondition:
    - predicate: AGE_MONTHS_2.outcome <= 23
      hint: Asked only for children under 24 months.
    items:
    - id: MED_Q21A
      kind: Question
      title: 'INFANT AFTER HIS/HER BIRTH: Did ... receive special medical care following his/her birth?'
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: MED_Q21B
      kind: Question
      title: What type of special medical care was received? (MARK ALL THAT APPLY)
      precondition:
      - predicate: MED_Q21A.outcome == 1
        hint: Asked only when question MED-Q21A is "YES".
      input:
        control: Checkbox
        labels:
          1: 1 — INTENSIVE CARE
          2: 2 — VENTILATION/OXYGEN
          4: 3 — TRANSFER TO A SPECIALIZED HOSPITAL
          8: 4 — OTHER
          16: 8 — DON'T KNOW
    - id: MED_Q21C
      kind: Question
      title: For how many days, in total, was this care received? |_|_|_| DAYS
      precondition:
      - predicate: MED_Q21A.outcome == 1 and (MED_Q21B.outcome is None or MED_Q21B.outcome // 16 % 2 == 0)
        hint: Asked only when care was received and the type was not "DON'T KNOW".
      input:
        control: Editbox
        min: 1
        max: 999
  - id: b_s37_health_at_birth
    title: Health at birth
    items:
    - id: MED_Q22
      kind: Question
      title: 'Compared to other babies in general, would you say that ...''s health at birth was:'
      input:
        control: Radio
        labels:
          1: Excellent?
          2: Very good?
          3: Good?
          4: Fair?
          5: Poor?
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s37_postnatal
    title: Postnatal health
    precondition:
    - predicate: AGE_MONTHS_2.outcome <= 11
      hint: Asked only for children under 12 months.
    items:
    - id: MED_Q23A
      kind: Question
      title: 'POSTNATAL/POST-DELIVERY PHYSICAL AND MENTAL HEALTH: The following are postnatal questions concerning .... After ...''s delivery, did you/her/his-mother suffer from any of the following conditions: postpartum haemorrhage?'
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: MED_Q24A
      kind: Question
      title: Were/Was you/her/his mother hospitalized for special medical care for any period immediately following the birth of ...?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
    - id: MED_Q24B
      kind: Question
      title: For how many days?
      precondition:
      - predicate: MED_Q24A.outcome == 1
        hint: Asked only when question MED-Q24A is "YES".
      input:
        control: Editbox
        min: 1
        max: 999
  - id: b_s37_postnatal_conditions
    title: Postpartum conditions
    precondition:
    - predicate: MED_Q23A.outcome != 9 and not (AGE_MONTHS_2.outcome >= 12 and AGE_MONTHS_2.outcome <= 23)
      hint: Asked only when question MED-Q23A is not "REFUSAL".
    items:
    - id: MED_Q23B
      kind: Question
      title: Postpartum infection?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: MED_Q23C1
      kind: Question
      title: Postpartum depression?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: MED_Q23C2
      kind: Question
      title: For how long? (ENTER NUMBER OF DAYS OR WEEKS OR MONTHS)
      precondition:
      - predicate: MED_Q23C1.outcome == 1
        hint: Asked only when question MED-Q23C1 is "YES".
      input:
        control: Textarea
    - id: MED_Q23D
      kind: Question
      title: Postpartum hypertension?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s38_routing_inputs
    title: ROUTING INPUTS (not collected in this part)
    precondition:
    - predicate: not (AGE_MONTHS_2.outcome >= 12 and AGE_MONTHS_2.outcome <= 23)
      hint: Not asked when the child's age in months is 12 to 23.
    - predicate: not (MED_Q24A.outcome == 2)
      hint: Asked only when question MED-Q24A is not "NO".
    items:
    - id: AGE_YEARS
      kind: Question
      title: 'Child''s age in completed years, from the survey file/demographics (read by TMP and CAR routing: AGE < 1, AGE = 3, AGE 4-5, AGE > 5 ...)'
      external: true
      input:
        control: Editbox
        min: 0
        max: 120
    - id: AGE_MONTHS_3
      kind: Question
      title: 'Child''s age in months, from the survey file/demographics (read by TMP routing: AGE IN MONTHS < 3 or > 47, 6 - 11, < 12)'
      external: true
      input:
        control: Editbox
        min: 0
        max: 1440
    - id: BIRTH_MONTH_STATED
      kind: Question
      title: Whether the month of birth was stated in the demographics or in the child component (read by TMP-C1)
      external: true
      input:
        control: Switch
        'on': Stated
        'off': Not stated
    - id: ELDEST_DONE
      kind: Question
      title: ELDEST-DONE flag (read by CUS-C25A; set outside this part)
      external: true
      input:
        control: Switch
        'on': '1'
        'off': Any other value
  - id: b_s39_breastfeeding
    title: BREAST-FEEDING
    items:
    - id: MED_Q25
      kind: Question
      title: Are/Is you/her/his mother currently breast-feeding ...?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
    - id: MED_Q26
      kind: Question
      title: Did you/her/his mother breast-feed him/her even if only for a short time?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
    - id: MED_Q27
      kind: Question
      title: For how long? (DO NOT READ LIST. MARK ONE ONLY.)
      input:
        control: Dropdown
        labels:
          1: LESS THAN 1 WEEK
          2: 1-4 WEEKS
          3: 5-8 WEEKS
          4: 9-12 WEEKS
          5: 3-6 MONTHS
          6: 7-9 MONTHS
          7: 10-12 MONTHS
          8: 13-16 MONTHS
          9: MORE THAN 16 MONTHS
    - id: MED_Q28
      kind: Question
      title: What was the main reason you/her/his mother stopped breast-feeding him/her? (DO NOT READ LIST. MARK ALL THAT APPLY.)
      input:
        control: Checkbox
        labels:
          1: 01 — NOT ENOUGH MILK/HUNGRY BABY
          2: 02 — INCONVENIENCED/FATIGUE
          4: 03 — DIFFICULTY WITH BF TECHNIQUES
          8: 04 — SORE NIPPLES/ENGORGED BREAST
          16: 05 — MOTHER'S ILLNESS
          32: 06 — PLANNED TO STOP AT THIS TIME
          64: 07 — BABY WEANED HIMSELF/HERSELF
          128: 08 — PHYSICIAN TOLD ME/HER TO STOP
          256: 09 — RETURNED TO WORK/SCHOOL
          512: 10 — PARTNER/FATHER WANTED ME/HER TO STOP
          1024: 11 — FORMULA FEEDING PREFERABLE
          2048: 12 — WANTED TO DRINK ALCOHOL
          4096: 13 — OTHER
  - id: b_s40_temperament
    title: TEMPERAMENT
    items:
    - id: TMP_Q1
      kind: Question
      title: How easy or difficult is it for you to calm or soothe ... when he/she is upset?
      input:
        control: Radio
        labels:
          1: VERY EASY
          2: '2'
          3: '3'
          4: ABOUT AVERAGE
          5: '5'
          6: '6'
          7: DIFFICULT
          9: REFUSAL
    - id: TMP_Q2
      kind: Question
      title: How easy or difficult is it for you to predict when he/she will go to sleep and wake up?
      input:
        control: Radio
        labels:
          1: VERY EASY
          2: '2'
          3: '3'
          4: ABOUT AVERAGE
          5: '5'
          6: '6'
          7: DIFFICULT
          9: REFUSAL
    - id: TMP_Q2A
      kind: Question
      title: How consistent is he/she in sticking with his/her sleeping routine?
      precondition:
      - predicate: not (TMP_Q2.outcome != 9)
        hint: Asked only when question TMP-Q2 is "REFUSAL".
      input:
        control: Radio
        labels:
          1: VERY CONSISTENT; LITTLE OR NO VARIABILITY
          2: '2'
          3: '3'
          4: SOME VARIABILITY
          5: '5'
          6: '6'
          7: VERY INCONSISTENT; HIGHLY VARIABLE
          9: REFUSAL
    - id: TMP_Q3
      kind: Question
      title: How easy or difficult is it for you to predict when he/she will become hungry?
      precondition:
      - predicate: not (TMP_Q2A.outcome != 9)
        hint: Asked only when question TMP-Q2A is "REFUSAL".
      input:
        control: Radio
        labels:
          1: VERY EASY
          2: '2'
          3: '3'
          4: ABOUT AVERAGE
          5: '5'
          6: '6'
          7: DIFFICULT
          9: REFUSAL
    - id: TMP_Q3A
      kind: Question
      title: How consistent is he/she in sticking with his/her eating routine?
      input:
        control: Radio
        labels:
          1: VERY CONSISTENT; LITTLE OR NO VARIABILITY
          2: '2'
          3: '3'
          4: SOME VARIABILITY
          5: '5'
          6: '6'
          7: VERY INCONSISTENT; HIGHLY VARIABLE
          9: REFUSAL
    - id: TMP_Q4
      kind: Question
      title: How easy or difficult is it for you to know what's bothering him/her when he/she cries or fusses?
      input:
        control: Radio
        labels:
          1: VERY EASY
          2: '2'
          3: '3'
          4: ABOUT AVERAGE
          5: '5'
          6: '6'
          7: VERY DIFFICULT
          9: REFUSAL
    - id: TMP_Q4A
      kind: Question
      title: How easy or difficult is it for you to know what's bothering him/her when he/she is irritable?
      precondition:
      - predicate: not (TMP_Q4.outcome != 9)
        hint: Asked only when question TMP-Q4 is "REFUSAL".
      input:
        control: Radio
        labels:
          1: VERY EASY
          2: '2'
          3: '3'
          4: ABOUT AVERAGE
          5: '5'
          6: '6'
          7: VERY DIFFICULT
          9: REFUSAL
    - id: TMP_Q5
      kind: Question
      title: How many times per day, on average, does ... get fussy and irritable - for either short or long periods of time?
      precondition:
      - predicate: not (TMP_Q4A.outcome != 9)
        hint: Asked only when question TMP-Q4A is "REFUSAL".
      input:
        control: Radio
        labels:
          1: NEVER
          2: 1-2 TIMES PER DAY
          3: 3-4 TIMES PER DAY
          4: 5-6 TIMES PER DAY
          5: 7-9 TIMES PER DAY
          6: 10-14 TIMES PER DAY
          7: 15 TIMES PER DAY OR MORE
          9: REFUSAL
    - id: TMP_Q5A
      kind: Question
      title: How many times per day on average does ... get cranky and irritable - for either short or long periods of time?
      precondition:
      - predicate: not (TMP_Q5.outcome != 9)
        hint: Asked only when question TMP-Q5 is "REFUSAL".
      input:
        control: Radio
        labels:
          1: NEVER
          2: 1-2 TIMES PER DAY
          3: 3-4 TIMES PER DAY
          4: 5-6 TIMES PER DAY
          5: 7-9 TIMES PER DAY
          6: 10-14 TIMES PER DAY
          7: 15 TIMES PER DAY OR MORE
          9: REFUSAL
    - id: TMP_Q6
      kind: Question
      title: How much does he/she cry and fuss in general?
      precondition:
      - predicate: not (TMP_Q5A.outcome != 9)
        hint: Asked only when question TMP-Q5A is "REFUSAL".
      input:
        control: Radio
        labels:
          1: VERY LITTLE; MUCH LESS THAN THE AVERAGE BABY/CHILD
          2: '2'
          3: '3'
          4: AVERAGE AMOUNT; ABOUT AS MUCH AS THE AVERAGE BABY/CHILD
          5: '5'
          6: '6'
          7: A LOT; MUCH MORE THAN THE AVERAGE BABY/CHILD
          9: REFUSAL
    - id: TMP_Q6A
      kind: Question
      title: How much does he/she cry, fuss or whine in general?
      precondition:
      - predicate: not (TMP_Q6.outcome != 9)
        hint: Asked only when question TMP-Q6 is "REFUSAL".
      input:
        control: Radio
        labels:
          1: VERY LITTLE; MUCH LESS THAN THE AVERAGE BABY/CHILD
          2: '2'
          3: '3'
          4: AVERAGE AMOUNT; ABOUT AS MUCH AS THE AVERAGE BABY/CHILD
          5: '5'
          6: '6'
          7: A LOT; MUCH MORE THAN THE AVERAGE BABY/CHILD
          9: REFUSAL
    - id: TMP_Q7
      kind: Question
      title: How easily does he/she get upset?
      input:
        control: Radio
        labels:
          1: VERY HARD TO UPSET -- EVEN BY THINGS THAT UPSET MOST BABIES/CHILDREN
          2: '2'
          3: '3'
          4: ABOUT AVERAGE
          5: '5'
          6: '6'
          7: VERY EASILY UPSET BY THINGS THAT WOULDN'T BOTHER MOST BABIES/CHILDREN
          8: DON'T KNOW
          9: REFUSAL
    - id: TMP_Q8
      kind: Question
      title: When he/she gets upset (e.g., before feeding, during diapering, etc.), how vigorously or loudly does he/she cry and fuss?
      input:
        control: Radio
        labels:
          1: VERY MILD INTENSITY OR LOUDNESS
          2: '2'
          3: '3'
          4: MODERATE INTENSITY OR LOUDNESS
          5: '5'
          6: '6'
          7: VERY LOUD OR INTENSE, REALLY CUTS LOOSE
          9: REFUSAL
    - id: TMP_Q8A
      kind: Question
      title: When he/she gets upset, how vigorously or loudly does he/she cry and fuss?
      precondition:
      - predicate: not (TMP_Q8.outcome != 9)
        hint: Asked only when question TMP-Q8 is "REFUSAL".
      input:
        control: Radio
        labels:
          1: VERY MILD INTENSITY OR LOUDNESS
          2: '2'
          3: '3'
          4: MODERATE INTENSITY OR LOUDNESS
          5: '5'
          6: '6'
          7: VERY LOUD OR INTENSE, REALLY CUTS LOOSE
          9: REFUSAL
    - id: TMP_Q8B
      kind: Question
      title: When he/she gets upset, how vigourously or loudly does he/she cry and whine?
      precondition:
      - predicate: not (TMP_Q8.outcome != 9)
        hint: Asked only when question TMP-Q8 is "REFUSAL".
      - predicate: not (TMP_Q8A.outcome != 9)
        hint: Asked only when question TMP-Q8A is "REFUSAL".
      input:
        control: Radio
        labels:
          1: VERY MILD INTENSITY OR LOUDNESS
          2: '2'
          3: '3'
          4: MODERATE INTENSITY OR LOUDNESS
          5: '5'
          6: '6'
          7: VERY LOUD OR INTENSE, REALLY CUTS LOOSE
          9: REFUSAL
    - id: TMP_Q9
      kind: Question
      title: How does he/she react when you are dressing him/her?
      input:
        control: Radio
        labels:
          1: VERY WELL -- LIKES IT
          2: '2'
          3: '3'
          4: ABOUT AVERAGE -- DOESN'T MIND IT
          5: '5'
          6: '6'
          7: DOESN'T LIKE IT AT ALL
          9: REFUSAL
    - id: TMP_Q9A
      kind: Question
      title: How does he/she react during hairwashing?
      precondition:
      - predicate: not (TMP_Q9.outcome != 9)
        hint: Asked only when question TMP-Q9 is "REFUSAL".
      input:
        control: Radio
        labels:
          1: VERY WELL -- LIKES IT
          2: '2'
          3: '3'
          4: ABOUT AVERAGE -- DOESN'T MIND IT
          5: '5'
          6: '6'
          7: DOESN'T LIKE IT AT ALL
          9: REFUSAL
    - id: TMP_Q10
      kind: Question
      title: How active is ... in general?
      input:
        control: Radio
        labels:
          1: VERY CALM AND QUIET
          2: '2'
          3: '3'
          4: AVERAGE
          5: '5'
          6: '6'
          7: VERY ACTIVE AND VIGOROUS
          8: DON'T KNOW
          9: REFUSAL
    - id: TMP_Q11
      kind: Question
      title: How much does he/she smile and make happy sounds?
      input:
        control: Radio
        labels:
          1: A GREAT DEAL, MUCH MORE THAN MOST INFANTS/CHILDREN
          2: '2'
          3: '3'
          4: AN AVERAGE AMOUNT
          5: '5'
          6: '6'
          7: VERY LITTLE, MUCH LESS THAN MOST INFANTS/CHILDREN
          9: REFUSAL
    - id: TMP_Q11A
      kind: Question
      title: How much does he/she smile and laugh?
      precondition:
      - predicate: not (TMP_Q11.outcome != 9)
        hint: Asked only when question TMP-Q11 is "REFUSAL".
      input:
        control: Radio
        labels:
          1: A GREAT DEAL, MUCH MORE THAN MOST INFANTS/CHILDREN
          2: '2'
          3: '3'
          4: AN AVERAGE AMOUNT
          5: '5'
          6: '6'
          7: VERY LITTLE, MUCH LESS THAN MOST INFANTS/CHILDREN
          9: REFUSAL
    - id: TMP_Q12
      kind: Question
      title: What kind of mood is he/she generally in?
      input:
        control: Radio
        labels:
          1: VERY HAPPY AND CHEERFUL
          2: '2'
          3: '3'
          4: NEITHER SERIOUS NOR CHEERFUL
          5: '5'
          6: '6'
          7: SERIOUS
          9: REFUSAL
    - id: TMP_Q13
      kind: Question
      title: How much does he/she enjoy playing little games with you?
      input:
        control: Radio
        labels:
          1: A GREAT DEAL -- REALLY LOVES IT
          2: '2'
          3: '3'
          4: ABOUT AVERAGE
          5: '5'
          6: '6'
          7: VERY LITTLE -- DOESN'T LIKE IT VERY MUCH
          9: REFUSAL
    - id: TMP_Q13A
      kind: Question
      title: How much does he/she enjoy playing with you?
      precondition:
      - predicate: not (TMP_Q13.outcome != 9)
        hint: Asked only when question TMP-Q13 is "REFUSAL".
      input:
        control: Radio
        labels:
          1: A GREAT DEAL -- REALLY LOVES IT
          2: '2'
          3: '3'
          4: ABOUT AVERAGE
          5: '5'
          6: '6'
          7: VERY LITTLE -- DOESN'T LIKE IT VERY MUCH
          9: REFUSAL
    - id: TMP_Q14
      kind: Question
      title: How much does he/she want to be held?
      input:
        control: Radio
        labels:
          1: WANTS TO BE FREE MOST OF THE TIME
          2: '2'
          3: '3'
          4: SOMETIMES WANTS TO BE HELD; SOMETIMES NOT
          5: '5'
          6: '6'
          7: A GREAT DEAL -- WANTS TO BE HELD ALMOST ALL THE TIME
          9: REFUSAL
    - id: TMP_Q14A
      kind: Question
      title: How much does he/she want to be cuddled?
      precondition:
      - predicate: not (TMP_Q14.outcome != 9)
        hint: Asked only when question TMP-Q14 is "REFUSAL".
      input:
        control: Radio
        labels:
          1: WANTS TO BE FREE MOST OF THE TIME
          2: '2'
          3: '3'
          4: SOMETIMES WANTS TO BE HELD; SOMETIMES NOT
          5: '5'
          6: '6'
          7: A GREAT DEAL -- WANTS TO BE HELD ALMOST ALL THE TIME
          9: REFUSAL
    - id: TMP_Q15
      kind: Question
      title: How does he/she respond to disruptions and changes in everyday routine, such as when you go to church, a meeting, on trips, etc.,?
      input:
        control: Radio
        labels:
          1: VERY FAVOURABLY, DOESN'T GET UPSET
          2: '2'
          3: '3'
          4: ABOUT AVERAGE
          5: '5'
          6: '6'
          7: VERY UNFAVOURABLY, GETS QUITE UPSET
          9: REFUSAL
    - id: TMP_Q16
      kind: Question
      title: How easy is it for you to predict when he/she will need a diaper change?
      input:
        control: Radio
        labels:
          1: VERY EASY
          2: '2'
          3: '3'
          4: ABOUT AVERAGE
          5: '5'
          6: '6'
          7: VERY DIFFICULT
          9: REFUSAL
    - id: TMP_Q17
      kind: Question
      title: How changeable is ...'s mood?
      input:
        control: Radio
        labels:
          1: CHANGES SELDOM AND CHANGES SLOWLY WHEN HE/SHE DOES CHANGE
          2: '2'
          3: '3'
          4: ABOUT AVERAGE
          5: '5'
          6: '6'
          7: CHANGES OFTEN AND RAPIDLY
          9: REFUSAL
    - id: TMP_Q18
      kind: Question
      title: How excited does he/she become when people play with or talk to him/her?
      input:
        control: Radio
        labels:
          1: VERY EXCITED
          2: '2'
          3: '3'
          4: ABOUT AVERAGE
          5: '5'
          6: '6'
          7: NOT AT ALL
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s41_cus_q20i
    title: CUS-Q20I
    items:
    - id: CUS_Q20I
      kind: Question
      title: How many?
      input:
        control: Editbox
        min: 0
        max: 99
  - id: b_s42_subsequent_unions
    title: INFORMATION ON SUBSEQUENT UNIONS OF CHILD'S FATHER
    items:
    - id: CUS_Q21A
      kind: Question
      title: Has ...'s father entered into another marriage, common-law relationship or common-law relationship that resulted in marriage? (MARK ALL THAT APPLY)
      input:
        control: Checkbox
        labels:
          1: 1 — YES, A MARRIAGE
          2: 2 — YES, A COMMON-LAW RELATIONSHIP
          4: 3 — YES, A COMMON-LAW RELATIONSHIP THAT RESULTED IN MARRIAGE
          8: 4 — NO
          16: 8 — DON'T KNOW
          32: 9 — REFUSAL
    - id: CUS_Q21B
      kind: Question
      title: When did ...'s father start living with his new partner? MONTH YEAR
      precondition:
      - predicate: not (CUS_Q21A.outcome & 1 > 0)
        hint: Asked unless the father's new union is recorded as a marriage
      input:
        control: Textarea
    - id: CUS_Q21C
      kind: Question
      title: When did the marriage take place? MONTH YEAR
      input:
        control: Textarea
    - id: CUS_Q21D
      kind: Question
      title: When they started living together, did ... live in the household with his/her father's new partner?
      input:
        control: Radio
        labels:
          1: YES, FULL-TIME
          2: YES, PART-TIME
          3: 'NO'
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s43_partner_children
    title: INFORMATION ON PREVIOUS CHILDREN OF PARTNER
    items:
    - id: CUS_Q21E
      kind: Question
      title: Did the father's new partner have any children of her own?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s43_partner_children_details
    title: Partner's children and where they lived
    precondition:
    - predicate: not (CUS_Q21E.outcome in [2, 8])
      hint: Asked only when question CUS-Q21E is none of "NO", "DON'T KNOW".
    items:
    - id: CUS_Q21F
      kind: Question
      title: How many?
      input:
        control: Editbox
        min: 1
        max: 20
    - id: CUS_Q21G
      kind: Question
      title: Did he/she/they live in the household with their mother? (MARK ALL THAT APPLY)
      input:
        control: Checkbox
        labels:
          1: 1 — YES, ALL OF THEM, FULL-TIME
          2: 2 — YES, ALL OF THEM, PART-TIME
          4: 3 — YES, SOME OF THEM, FULL-TIME
          8: 4 — YES, SOME OF THEM, PART-TIME
          16: 5 — NO, NONE OF THEM
          32: 8 — DON'T KNOW
          64: 9 — REFUSAL
  - id: b_s44_children_of_union
    title: INFORMATION ON CHILDREN OF UNION
    items:
    - id: CUS_Q21H
      kind: Question
      title: Did ...'s father have any children with this new spouse/partner?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: CUS_Q21I
      kind: Question
      title: How many?
      input:
        control: Editbox
        min: 0
        max: 20
  - id: b_s45_union_breakup
    title: INFORMATION ON POSSIBLE BREAK-UP OF NEW UNION
    items:
    - id: CUS_Q22A
      kind: Question
      title: Has this other union of ...'s mother or father broken up?
      input:
        control: Radio
        labels:
          1: YES, MOTHER'S UNION
          2: YES, FATHER'S UNION
          3: YES, BOTH UNIONS
          4: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: CUS_Q22B
      kind: Question
      title: When did that happen? (IF BOTH UNIONS HAVE BROKEN UP, USE DATE OF FIRST EVENT)
      input:
        control: Textarea
    - id: CUS_Q22C
      kind: Question
      title: With whom did ... go on living after it happened?
      input:
        control: Radio
        labels:
          1: MOTHER, FULL-TIME
          2: FATHER, FULL-TIME
          3: PART-TIME, MOTHER AND FATHER
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s46_subsequent_unions
    title: INFORMATION ON SUBSEQUENT UNIONS
    items:
    - id: CUS_Q23
      kind: Question
      title: Did ... live through any other family reconstitution between then and now?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s47_arrangements
    title: Child care arrangements currently used
    items:
    - id: CAR_Q1A
      kind: Question
      title: Do you currently use child care such as daycare or babysitting while you (and your spouse/partner) are at work or studying?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: CAR_Q1B
      kind: Question
      title: Which of the following methods of child care do you currently use? Care provided in someone else's home by a non-relative?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: CAR_Q1B1
      kind: Question
      title: For about how many hours per week is that?
      precondition:
      - predicate: not (CAR_Q1B.outcome in [2, 8, 9])
        hint: Asked only when question CAR-Q1B is none of "NO", "DON'T KNOW", "REFUSAL".
      input:
        control: Editbox
        min: 0
        max: 168
        right: hours per week
    - id: CAR_Q1B2
      kind: Question
      title: Is the person providing this care licensed by the government or approved by a family daycare agency?
      precondition:
      - predicate: not (CAR_Q1B.outcome in [2, 8, 9])
        hint: Asked only when question CAR-Q1B is none of "NO", "DON'T KNOW", "REFUSAL".
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
    - id: CAR_Q1C
      kind: Question
      title: Care in someone else's home by a relative?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          3: NO, AND NO OTHER ARRANGEMENT
          8: DON'T KNOW
          9: REFUSAL
    - id: CAR_Q1C1
      kind: Question
      title: For about how many hours per week is that?
      precondition:
      - predicate: not (CAR_Q1C.outcome in [2, 8, 9])
        hint: Asked only when question CAR-Q1C is none of "NO", "DON'T KNOW", "REFUSAL".
      input:
        control: Editbox
        min: 0
        max: 168
        right: hours per week
    - id: CAR_Q1C2
      kind: Question
      title: Is the person providing this care licensed by the government or approved by a family daycare agency?
      precondition:
      - predicate: not (CAR_Q1C.outcome in [2, 8, 9])
        hint: Asked only when question CAR-Q1C is none of "NO", "DON'T KNOW", "REFUSAL".
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: CAR_Q1D
      kind: Question
      title: Care in own home by brother or sister of the child?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          3: NO, AND NO OTHER ARRANGEMENT
          4: NOT APPLICABLE
          8: DON'T KNOW
          9: REFUSAL
    - id: CAR_Q1D1
      kind: Question
      title: For about how many hours per week is that?
      precondition:
      - predicate: not (CAR_Q1D.outcome in [2, 4, 8, 9])
        hint: Asked only when question CAR-Q1D is none of "NO", "NOT APPLICABLE", "DON'T KNOW", "REFUSAL".
      input:
        control: Editbox
        min: 0
        max: 168
        right: hours per week
    - id: CAR_Q1E
      kind: Question
      title: Care in own home by a relative other than a sister or brother of the child?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          3: NO, AND NO OTHER ARRANGEMENT
          8: DON'T KNOW
          9: REFUSAL
    - id: CAR_Q1E1
      kind: Question
      title: For about how many hours per week is that?
      precondition:
      - predicate: not (CAR_Q1E.outcome in [2, 8, 9])
        hint: Asked only when question CAR-Q1E is none of "NO", "DON'T KNOW", "REFUSAL".
      input:
        control: Editbox
        min: 0
        max: 168
        right: hours per week
    - id: CAR_Q1F
      kind: Question
      title: Care in own home by a non-relative?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          3: NO, AND NO OTHER ARRANGEMENT
          8: DON'T KNOW
          9: REFUSAL
    - id: CAR_Q1F1
      kind: Question
      title: For about how many hours per week is that?
      precondition:
      - predicate: not (CAR_Q1F.outcome in [2, 8, 9])
        hint: Asked only when question CAR-Q1F is none of "NO", "DON'T KNOW", "REFUSAL".
      input:
        control: Editbox
        min: 0
        max: 168
        right: hours per week
    - id: CAR_Q1G
      kind: Question
      title: Care in a daycare centre (including at workplace)?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          3: NO AND NO OTHER ARRANGEMENT
          8: DON'T KNOW
          9: REFUSAL
    - id: CAR_Q1G1
      kind: Question
      title: For about how many hours per week is that?
      input:
        control: Editbox
        min: 0
        max: 168
        right: hours per week
    - id: CAR_Q1G2
      kind: Question
      title: Is the child care program or daycare centre operated on a profit or non-profit basis (include government sponsored care)?
      input:
        control: Radio
        labels:
          1: PROFIT
          2: NON-PROFIT
          8: DON'T KNOW
          9: REFUSAL
    - id: CAR_Q1H
      kind: Question
      title: Care in a before or after school program?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          3: NO, AND NO OTHER ARRANGEMENT
          8: DON'T KNOW
          9: REFUSAL
    - id: CAR_Q1H1
      kind: Question
      title: For about how many hours per week is that?
      input:
        control: Editbox
        min: 0
        max: 168
        right: hours per week
    - id: CAR_Q1I
      kind: Question
      title: Is ... in his/her own care (e.g. before/after school)?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          3: NO, AND NO OTHER ARRANGEMENT
          8: DON'T KNOW
          9: REFUSAL
    - id: CAR_Q1I1
      kind: Question
      title: For about how many hours per week is that?
      precondition:
      - predicate: not (CAR_Q1I.outcome in [2, 8, 9])
        hint: Asked only when question CAR-Q1I is none of "NO", "DON'T KNOW", "REFUSAL".
      input:
        control: Editbox
        min: 0
        max: 168
        right: hours per week
    - id: CAR_Q1J
      kind: Question
      title: Do you currently use other child care arrangements?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: CAR_Q1J1
      kind: Question
      title: For about how many hours per week is that?
      postcondition:
      - predicate: CAR_Q1B1.outcome + CAR_Q1C1.outcome + CAR_Q1D1.outcome + CAR_Q1E1.outcome + CAR_Q1F1.outcome + CAR_Q1G1.outcome + CAR_Q1H1.outcome + CAR_Q1I1.outcome + CAR_Q1J1.outcome <= 168
        hint: El total de horas por semana de todos los arrangements (CAR-Q1B1 à CAR-Q1J1) ne peut pas dépasser 168 heures; revisez les heures de CAR-Q1J1 et des questions précédentes.
        invented: true
      input:
        control: Editbox
        min: 0
        max: 168
        right: hours per week
  - id: b_s47_main_arrangement
    title: Main arrangement and changes
    items:
    - id: CAR_Q2
      kind: Question
      title: When did you start using this child care arrangement?
      input:
        control: Textarea
    - id: CAR_Q3
      kind: Question
      title: During the past 6 months, how well has he/she gotten along with his/her main child care provider?
      input:
        control: Radio
        labels:
          1: VERY WELL, NO PROBLEMS
          2: QUITE WELL, HARDLY ANY PROBLEMS
          3: PRETTY WELL, OCCASIONAL PROBLEMS
          4: NOT TOO WELL, FREQUENT PROBLEMS
          5: NOT WELL AT ALL, CONSTANT PROBLEMS
          8: DON'T KNOW
          9: REFUSAL
    - id: CAR_Q4
      kind: Question
      title: In the past 12 months, how many times have you changed your main child care arrangement and/or caregiver, excluding periods of care by yourself (or spouse/partner)?
      input:
        control: Radio
        labels:
          1: NONE
          2: '1'
          3: '2'
          4: 3 OR 4
          5: 5 OR MORE
          8: DON'T KNOW
          9: REFUSAL
    - id: CAR_Q5
      kind: Question
      title: What were the reasons for changing? (DO NOT READ. MARK ALL THAT APPLY.)
      input:
        control: Checkbox
        labels:
          1: 1 — DISSATISFACTION WITH CAREGIVER/PROGRAM
          2: 2 — CAREGIVER/PROGRAM NO LONGER AVAILABLE
          4: 3 — FAMILY OR CHILD MOVED, PARENTAL WORK STATUS, OR CUSTODY ARRANGEMENT CHANGED
          8: 4 — CHANGES IN CHILD OR CHILD'S NEEDS (E.G. SPECIAL CARE, CHILD'S AGE)
          16: 5 — A PREFERRED ARRANGEMENT BECAME AVAILABLE (E.G. SUBSIDIZED SPACE)
          32: 6 — COST
          64: 7 — OTHER
          128: 8 — DON'T KNOW
          256: 9 — REFUSAL
    - id: CAR_Q6
      kind: Question
      title: Have you ever used child care for ... while you (and your spouse/partner) were at work or studying?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: CAR_Q7
      kind: Question
      title: Overall, how many changes in child care arrangements has ... experienced since you began using child care, excluding periods of care by yourself (or spouse/partner)? NUMBER
      input:
        control: Editbox
        min: 0
        max: 99
  - id: b_s47_summer
    title: Summer care
    items:
    - id: CAR_Q8
      kind: Question
      title: Last summer while ... was not in school, what type of child care arrangement did you use while you (and your spouse/partner) were at work/studying? (MARK ALL THAT APPLY.)
      input:
        control: Checkbox
        labels:
          1: 01 — DAY CARE CENTRE
          2: 02 — CARE IN SOMEONE ELSE'S HOME BY A NON-RELATIVE
          4: 03 — CARE IN SOMEONE ELSE'S HOME BY A RELATIVE
          8: 04 — CARE IN OWN HOME BY A NON-RELATIVE
          16: 05 — CARE IN OWN HOME BY BROTHER/SISTER
          32: 06 — CARE IN OWN HOME BY OTHER RELATIVE
          64: 07 — CHILD IN OWN CARE
          128: 08 — STRUCTURED SUMMER PROGRAM
          256: 09 — OTHER
          512: 10 — NOT APPLICABLE
          1024: 98 — DON'T KNOW
          2048: 99 — REFUSAL
  - id: b_s48_friends_family
    title: SECTION A. FRIENDS AND FAMILY
    items:
    - id: A_01
      kind: Question
      title: I have a lot of friends.
      input:
        control: Radio
        labels:
          0: 'False'
          1: Mostly false
          2: Sometimes false/Sometimes true
          3: Mostly true
          4: 'True'
    - id: A_02
      kind: Question
      title: I get along with kids easily.
      input:
        control: Radio
        labels:
          5: 'False'
          6: Mostly false
          7: Sometimes false/Sometimes true
          8: Mostly true
          9: 'True'
    - id: A_03
      kind: Question
      title: Other kids want me to be their friend.
      input:
        control: Radio
        labels:
          0: 'False'
          1: Mostly false
          2: Sometimes false/Sometimes true
          3: Mostly true
          4: 'True'
    - id: A_04
      kind: Question
      title: Most other kids like me.
      input:
        control: Radio
        labels:
          5: 'False'
          6: Mostly false
          7: Sometimes false/Sometimes true
          8: Mostly true
          9: 'True'
    - id: A_05
      kind: Question
      title: About how many days a week do you do things with friends outside of school hours?
      input:
        control: Radio
        labels:
          0: Never
          1: Less than once a week
          2: 1 day a week
          3: 2-3 days a week
          4: 4-5 days a week
          5: 6-7 days a week
    - id: A_06
      kind: Question
      title: How many close friends do you have? (If none write 00)
      input:
        control: Editbox
        min: 0
        max: 99
    - id: A_07
      kind: Question
      title: Other than your friends, do you have anyone else in particular you can talk to about yourself or your problems?
      input:
        control: Switch
        'on': 'Yes'
        'off': 'No'
  - id: b_s49_talk_to
    title: People you can talk to
    items:
    - id: A_08
      kind: Question
      title: What is their relationship to you? (Mark everyone you feel you can talk to about yourself or your problems)
      precondition:
      - predicate: A_07.outcome == 0
        hint: Asked only when question A.07 is 0.
      - predicate: not (A_07.outcome == 1)
        hint: Asked only when question A.07 is not 1.
      input:
        control: Checkbox
        labels:
          1: 01 — Mother
          2: 02 — Father
          4: 03 — Stepmother
          8: 04 — Stepfather
          16: 05 — Brother
          32: 06 — Sister
          64: 07 — Grandparents
          128: 08 — Other relatives
          256: 09 — A friend of the family
          512: 10 — Sitter or babysitter
          1024: 11 — Parent's boyfriend/girlfriend
          2048: 12 — Teacher
          4096: 13 — Coach or leader (e.g. scout or church leader)
          8192: 14 — Other
  - id: b_s49_getting_along
    title: Getting along with others
    items:
    - id: A_09
      kind: Question
      title: During the past 6 months, how well have you gotten along with other children such as friends or classmates?
      input:
        control: Radio
        labels:
          15: Very well, no problems
          16: Quite well, hardly any problems
          17: Pretty well, occasional problems
          18: Not too well, frequent problems
          19: Not well at all, constant problems
    - id: A_10
      kind: Question
      title: During the past 6 months, how well have you gotten along with your mother?
      input:
        control: Radio
        labels:
          20: Very well, no problems
          21: Quite well, hardly any problems
          22: Pretty well, occasional problems
          23: Not too well, frequent problems
          24: Not well at all, constant problems
          25: Don't have a mother or am not in touch with her
    - id: A_11
      kind: Question
      title: During the past 6 months, how well have you gotten along with your father?
      input:
        control: Radio
        labels:
          26: Very well, no problems
          27: Quite well, hardly any problems
          28: Pretty well, occasional problems
          29: Not too well, frequent problems
          30: Not well at all, constant problems
          31: Don't have a father or am not in touch with him
    - id: A_12
      kind: Question
      title: During the past 6 months, how well have you gotten along with your brothers and sisters?
      input:
        control: Radio
        labels:
          32: Very well, no problems
          33: Quite well, hardly any problems
          34: Pretty well, occasional problems
          35: Not too well, frequent problems
          36: Not well at all, constant problems
          37: Don't have brothers and sisters or am not in touch with them
  - id: b_s50_school
    title: SECTION B. SCHOOL
    items:
    - id: B_01
      kind: Question
      title: How do you feel about school?
      input:
        control: Radio
        labels:
          0: I like school very much
          1: I like school quite a bit
          2: I like school a bit
          3: I don't like school very much
          4: I hate school
    - id: B_02
      kind: Question
      title: How well do you think you are doing in your school work?
      input:
        control: Radio
        labels:
          5: Very well
          6: Well
          7: Average
          8: Poorly
          9: Very poorly
    - id: B_03
      kind: Question
      title: How important is it to you to have good grades in school?
      input:
        control: Radio
        labels:
          0: Very important
          1: Important
          2: Somewhat important
          3: Not very important
          4: Not important at all
    - id: B_04
      kind: Question
      title: I like mathematics.
      input:
        control: Radio
        labels:
          5: 'False'
          6: Mostly false
          7: Sometimes false\sometimes true
          8: Mostly true
          9: 'True'
    - id: B_05
      kind: Question
      title: I feel safe at school.
      input:
        control: Radio
        labels:
          0: All the time
          1: Most of the time
          2: Some of the time
          3: Rarely
          4: Never
    - id: B_06
      kind: Question
      title: I feel safe on my way to and from school.
      input:
        control: Radio
        labels:
          5: All the time
          6: Most of the time
          7: Some of the time
          8: Rarely
          9: Never
    - id: B_07
      kind: Question
      title: Children say nasty and unpleasant things to me at school.
      input:
        control: Radio
        labels:
          0: All the time
          1: Most of the time
          2: Some of the time
          3: Rarely
          4: Never
    - id: B_08
      kind: Question
      title: I am bullied in school.
      input:
        control: Radio
        labels:
          5: All the time
          6: Most of the time
          7: Some of the time
          8: Rarely
          9: Never
    - id: B_09
      kind: Question
      title: I am bullied on my way to and from school.
      input:
        control: Radio
        labels:
          0: All the time
          1: Most of the time
          2: Some of the time
          3: Rarely
          4: Never
    - id: B_10
      kind: Question
      title: I feel like an outsider (or left out of things) at my school.
      input:
        control: Radio
        labels:
          5: All the time
          6: Most of the time
          7: Some of the time
          8: Rarely
          9: Never
    - id: B_11
      kind: Question
      title: When I need extra help, my teacher gives it to me.
      input:
        control: Radio
        labels:
          1: All the time
          2: Most of the time
          3: Some of the time
          4: Rarely
          5: Never
          6: Don't need extra help
    - id: B_12
      kind: Question
      title: My teacher treats me fairly.
      input:
        control: Radio
        labels:
          7: All the time
          8: Most of the time
          9: Some of the time
          10: Rarely
          11: Never
    - id: B_13
      kind: Question
      title: If I have problems at school, my parents are ready to help.
      input:
        control: Radio
        labels:
          12: All the time
          13: Most of the time
          14: Some of the time
          15: Rarely
          16: Never
          17: Don't have problems at school
    - id: B_14
      kind: Question
      title: My parents encourage me to do well at school.
      input:
        control: Radio
        labels:
          0: All the time
          1: Most of the time
          2: Some of the time
          3: Rarely
          4: Never
    - id: B_15
      kind: Question
      title: My parents expect too much of me at school.
      input:
        control: Radio
        labels:
          5: All the time
          6: Most of the time
          7: Some of the time
          8: Rarely
          9: Never
    - id: B_16
      kind: Question
      title: I have a place at home to do homework or study.
      input:
        control: Radio
        labels:
          0: All the time
          1: Most of the time
          2: Some of the time
          3: Rarely
          4: Never
    - id: B_17
      kind: Question
      title: When my teacher gives me homework, I do it.
      input:
        control: Radio
        labels:
          5: All the time
          6: Most of the time
          7: Some of the time
          8: Rarely
          9: Never
  - id: b_s51_about_me
    title: SECTION C. ABOUT ME
    items:
    - id: C_01a
      kind: Question
      title: In general, I like the way I am.
      input:
        control: Radio
        labels:
          0: 'False'
          1: Mostly false
          2: Sometimes false/sometimes true
          3: Mostly true
          4: 'True'
    - id: C_01b
      kind: Question
      title: Overall I have a lot to be proud of.
      input:
        control: Radio
        labels:
          5: 'False'
          6: Mostly false
          7: Sometimes false/sometimes true
          8: Mostly true
          9: 'True'
    - id: C_01c
      kind: Question
      title: A lot of things about me are good.
      input:
        control: Radio
        labels:
          0: 'False'
          1: Mostly false
          2: Sometimes false/sometimes true
          3: Mostly true
          4: 'True'
    - id: C_01d
      kind: Question
      title: When I do something, I do it well.
      input:
        control: Radio
        labels:
          5: 'False'
          6: Mostly false
          7: Sometimes false/sometimes true
          8: Mostly true
          9: 'True'
    - id: C_01e
      kind: Question
      title: I am good looking.
      input:
        control: Radio
        labels:
          0: 'False'
          1: Mostly false
          2: Sometimes false/sometimes true
          3: Mostly true
          4: 'True'
    - id: C_01f
      kind: Question
      title: I have a pleasant looking face.
      input:
        control: Radio
        labels:
          5: 'False'
          6: Mostly false
          7: Sometimes false/sometimes true
          8: Mostly true
          9: 'True'
    - id: C_01g
      kind: Question
      title: Other kids think I am good looking.
      input:
        control: Radio
        labels:
          0: 'False'
          1: Mostly false
          2: Sometimes false/sometimes true
          3: Mostly true
          4: 'True'
    - id: C_01h
      kind: Question
      title: I have a good looking body.
      input:
        control: Radio
        labels:
          5: 'False'
          6: Mostly false
          7: Sometimes false/sometimes true
          8: Mostly true
          9: 'True'
  - id: b_s52_behaviours
    title: SECTION D. FEELINGS AND BEHAVIOURS
    items:
    - id: D_01a
      kind: Question
      title: I show sympathy to (feel sorry for) someone who has made a mistake
      input:
        control: Radio
        labels:
          1: Never or not true
          2: Sometimes or somewhat true
          3: Often or very true
    - id: D_01b
      kind: Question
      title: I can't sit still, am restless or hyperactive
      input:
        control: Radio
        labels:
          4: Never or not true
          5: Sometimes or somewhat true
          6: Often or very true
    - id: D_01c
      kind: Question
      title: I destroy my own things
      input:
        control: Radio
        labels:
          7: Never or not true
          8: Sometimes or somewhat true
          9: Often or very true
    - id: D_01d
      kind: Question
      title: I will try to help someone who has been hurt
      input:
        control: Radio
        labels:
          1: Never or not true
          2: Sometimes or somewhat true
          3: Often or very true
    - id: D_01e
      kind: Question
      title: I steal at home
      input:
        control: Radio
        labels:
          4: Never or not true
          5: Sometimes or somewhat true
          6: Often or very true
    - id: D_01f
      kind: Question
      title: I am unhappy, sad or depressed
      input:
        control: Radio
        labels:
          7: Never or not true
          8: Sometimes or somewhat true
          9: Often or very true
    - id: D_01g
      kind: Question
      title: I get into many fights
      input:
        control: Radio
        labels:
          1: Never or not true
          2: Sometimes or somewhat true
          3: Often or very true
    - id: D_01h
      kind: Question
      title: I volunteer to help clear up a mess someone else has made
      input:
        control: Radio
        labels:
          4: Never or not true
          5: Sometimes or somewhat true
          6: Often or very true
    - id: D_01i
      kind: Question
      title: I am distractible, have trouble sticking to any activity
      input:
        control: Radio
        labels:
          7: Never or not true
          8: Sometimes or somewhat true
          9: Often or very true
    - id: D_01j
      kind: Question
      title: I try when I am mad at someone, to get others to dislike him/her
      input:
        control: Radio
        labels:
          1: Never or not true
          2: Sometimes or somewhat true
          3: Often or very true
    - id: D_01k
      kind: Question
      title: I am not as happy as other children
      input:
        control: Radio
        labels:
          4: Never or not true
          5: Sometimes or somewhat true
          6: Often or very true
    - id: D_01l
      kind: Question
      title: I destroy things belonging to my family or other children
      input:
        control: Radio
        labels:
          7: Never or not true
          8: Sometimes or somewhat true
          9: Often or very true
    - id: D_01m
      kind: Question
      title: I will try, if there is an argument, to stop it
      input:
        control: Radio
        labels:
          1: Never or not true
          2: Sometimes or somewhat true
          3: Often or very true
    - id: D_01n
      kind: Question
      title: I fidget
      input:
        control: Radio
        labels:
          4: Never or not true
          5: Sometimes or somewhat true
          6: Often or very true
    - id: D_01o
      kind: Question
      title: I am disobedient at school
      input:
        control: Radio
        labels:
          7: Never or not true
          8: Sometimes or somewhat true
          9: Often or very true
    - id: D_01p
      kind: Question
      title: I can't concentrate, can't pay attention
      input:
        control: Radio
        labels:
          1: Never or not true
          2: Sometimes or somewhat true
          3: Often or very true
    - id: D_01q
      kind: Question
      title: I am too fearful or anxious
      input:
        control: Radio
        labels:
          4: Never or not true
          5: Sometimes or somewhat true
          6: Often or very true
    - id: D_01r
      kind: Question
      title: When I am mad at someone, I become friends with another as revenge
      input:
        control: Radio
        labels:
          7: Never or not true
          8: Sometimes or somewhat true
          9: Often or very true
    - id: D_01s
      kind: Question
      title: I am impulsive, act without thinking
      input:
        control: Radio
        labels:
          1: Never or not true
          2: Sometimes or somewhat true
          3: Often or very true
    - id: D_01t
      kind: Question
      title: I tell lies or cheat
      input:
        control: Radio
        labels:
          4: Never or not true
          5: Sometimes or somewhat true
          6: Often or very true
    - id: D_01u
      kind: Question
      title: I offer to help other children (friend, brother or sister) who are having difficulty with a task
      input:
        control: Radio
        labels:
          7: Never or not true
          8: Sometimes or somewhat true
          9: Often or very true
    - id: D_01v
      kind: Question
      title: I am worried
      input:
        control: Radio
        labels:
          1: Never or not true
          2: Sometimes or somewhat true
          3: Often or very true
    - id: D_01w
      kind: Question
      title: I have difficulty awaiting my turn in games or groups
      input:
        control: Radio
        labels:
          4: Never or not true
          5: Sometimes or somewhat true
          6: Often or very true
    - id: D_01x
      kind: Question
      title: I assume, when another child accidentally hurts me (such as bumping into me), that the other child meant to do it, and then react with anger and fighting
      input:
        control: Radio
        labels:
          7: Never or not true
          8: Sometimes or somewhat true
          9: Often or very true
    - id: D_01y
      kind: Question
      title: I tend to do things on my your own - am rather solitary
      input:
        control: Radio
        labels:
          1: Never or not true
          2: Sometimes or somewhat true
          3: Often or very true
    - id: D_01z
      kind: Question
      title: when mad at someone, I say bad things behind the other's back
      input:
        control: Radio
        labels:
          4: Never or not true
          5: Sometimes or somewhat true
          6: Often or very true
    - id: D_01aa
      kind: Question
      title: I physically attack people
      input:
        control: Radio
        labels:
          7: Never or not true
          8: Sometimes or somewhat true
          9: Often or very true
    - id: D_01bb
      kind: Question
      title: I comfort a child (friend, brother or sister) who is crying or upset
      input:
        control: Radio
        labels:
          1: Never or not true
          2: Sometimes or somewhat true
          3: Often or very true
    - id: D_01cc
      kind: Question
      title: I cry a lot
      input:
        control: Radio
        labels:
          4: Never or not true
          5: Sometimes or somewhat true
          6: Often or very true
    - id: D_01dd
      kind: Question
      title: I vandalize
      input:
        control: Radio
        labels:
          7: Never or not true
          8: Sometimes or somewhat true
          9: Often or very true
    - id: D_01ee
      kind: Question
      title: I give up easily
      input:
        control: Radio
        labels:
          1: Never or not true
          2: Sometimes or somewhat true
          3: Often or very true
    - id: D_01ff
      kind: Question
      title: I threaten people
      input:
        control: Radio
        labels:
          4: Never or not true
          5: Sometimes or somewhat true
          6: Often or very true
    - id: D_01gg
      kind: Question
      title: I help to pick up objects which another child has dropped (e.g. pencils, books.)
      input:
        control: Radio
        labels:
          7: Never or not true
          8: Sometimes or somewhat true
          9: Often or very true
    - id: D_01hh
      kind: Question
      title: I cannot settle to anything for more than a few moments
      input:
        control: Radio
        labels:
          1: Never or not true
          2: Sometimes or somewhat true
          3: Often or very true
    - id: D_01ii
      kind: Question
      title: I feel miserable, unhappy, tearful, or distressed
      input:
        control: Radio
        labels:
          4: Never or not true
          5: Sometimes or somewhat true
          6: Often or very true
    - id: D_01jj
      kind: Question
      title: I am cruel, bully or am mean to others
      input:
        control: Radio
        labels:
          7: Never or not true
          8: Sometimes or somewhat true
          9: Often or very true
    - id: D_01kk
      kind: Question
      title: I stare into space
      input:
        control: Radio
        labels:
          1: Never or not true
          2: Sometimes or somewhat true
          3: Often or very true
    - id: D_01ll
      kind: Question
      title: 'when mad at someone, I say to others: let''s not be with him/her'
      input:
        control: Radio
        labels:
          4: Never or not true
          5: Sometimes or somewhat true
          6: Often or very true
    - id: D_01mm
      kind: Question
      title: I am nervous, highstrung or tense
      input:
        control: Radio
        labels:
          7: Never or not true
          8: Sometimes or somewhat true
          9: Often or very true
    - id: D_01nn
      kind: Question
      title: I kick, bite, hit other children
      input:
        control: Radio
        labels:
          1: Never or not true
          2: Sometimes or somewhat true
          3: Often or very true
    - id: D_01oo
      kind: Question
      title: I will invite bystanders to join in a game
      input:
        control: Radio
        labels:
          4: Never or not true
          5: Sometimes or somewhat true
          6: Often or very true
    - id: D_01pp
      kind: Question
      title: I steal outside the home
      input:
        control: Radio
        labels:
          7: Never or not true
          8: Sometimes or somewhat true
          9: Often or very true
    - id: D_01qq
      kind: Question
      title: I am inattentive, have difficulty paying attention to someone
      input:
        control: Radio
        labels:
          1: Never or not true
          2: Sometimes or somewhat true
          3: Often or very true
    - id: D_01rr
      kind: Question
      title: I have trouble enjoying myself
      input:
        control: Radio
        labels:
          4: Never or not true
          5: Sometimes or somewhat true
          6: Often or very true
    - id: D_01ss
      kind: Question
      title: I help other children (friends, brother or sister) who are feeling sick
      input:
        control: Radio
        labels:
          7: Never or not true
          8: Sometimes or somewhat true
          9: Often or very true
    - id: D_01tt
      kind: Question
      title: When mad at someone, I tell the other one's secrets to a third person
      input:
        control: Radio
        labels:
          1: Never or not true
          2: Sometimes or somewhat true
          3: Often or very true
    - id: D_01uu
      kind: Question
      title: I take the opportunity to show support for the work of children who can't do things as well as me
      input:
        control: Radio
        labels:
          4: Never or not true
          5: Sometimes or somewhat true
          6: Often or very true
  - id: b_s52_past_year
    title: Past year
    items:
    - id: D_02a
      kind: Question
      title: In the past year, about how many times... did you stay out later than your parents said you should?
      input:
        control: Radio
        labels:
          1: Never
          2: Once
          3: Twice
          4: More than twice
    - id: D_02b
      kind: Question
      title: In the past year, about how many times... did you stay out all night without permission?
      input:
        control: Radio
        labels:
          5: Never
          6: Once
          7: Twice
          8: More than twice
    - id: D_02c
      kind: Question
      title: In the past year, about how many times... did you skip a day of school without permission?
      input:
        control: Radio
        labels:
          1: Never
          2: Once
          3: Twice
          4: More than twice
    - id: D_02d
      kind: Question
      title: In the past year, about how many times... did you get drunk?
      input:
        control: Radio
        labels:
          5: Never
          6: Once
          7: Twice
          8: More than twice
    - id: D_02e
      kind: Question
      title: In the past year, about how many times... were you questioned by the police about anything you might have done such as stealing, damaging property or anything else?
      input:
        control: Radio
        labels:
          1: Never
          2: Once
          3: Twice
          4: More than twice
    - id: D_02f
      kind: Question
      title: In the past year, about how many times... did you run away from home?
      input:
        control: Radio
        labels:
          5: Never
          6: Once
          7: Twice
          8: More than twice
    - id: D_03
      kind: Question
      title: In the past year were you part of a group that did bad things?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
  - id: b_s53_parents_and_me
    title: SECTION E. MY PARENT(S) AND ME
    items:
    - id: E_01a
      kind: Question
      title: My parents (or step parents or foster parents)... smile at me
      input:
        control: Radio
        labels:
          1: Never
          2: Sometimes
          3: Often
          4: Very often
    - id: E_01b
      kind: Question
      title: My parents (or step parents or foster parents)... want to know exactly where I am and what I am doing
      input:
        control: Radio
        labels:
          5: Never
          6: Sometimes
          7: Often
          8: Very often
    - id: E_01c
      kind: Question
      title: My parents (or step parents or foster parents)... soon forget a rule they have made
      input:
        control: Radio
        labels:
          1: Never
          2: Sometimes
          3: Often
          4: Very often
    - id: E_01d
      kind: Question
      title: My parents (or step parents or foster parents)... praise me
      input:
        control: Radio
        labels:
          5: Never
          6: Sometimes
          7: Often
          8: Very often
    - id: E_01e
      kind: Question
      title: My parents (or step parents or foster parents)... let me go out any evening I want
      input:
        control: Radio
        labels:
          1: Never
          2: Sometimes
          3: Often
          4: Very often
    - id: E_01f
      kind: Question
      title: My parents (or step parents or foster parents)... do tell me what time to be home when I go out
      input:
        control: Radio
        labels:
          5: Never
          6: Sometimes
          7: Often
          8: Very often
    - id: E_01g
      kind: Question
      title: My parents (or step parents or foster parents)... nag me about little things
      input:
        control: Radio
        labels:
          1: Never
          2: Sometimes
          3: Often
          4: Very often
    - id: E_01h
      kind: Question
      title: My parents (or step parents or foster parents)... tell me what I can watch on TV
      input:
        control: Radio
        labels:
          5: Never
          6: Sometimes
          7: Often
          8: Very often
    - id: E_01i
      kind: Question
      title: My parents (or step parents or foster parents)... make sure I do my homework
      input:
        control: Radio
        labels:
          1: Never
          2: Sometimes
          3: Often
          4: Very often
    - id: E_01j
      kind: Question
      title: My parents (or step parents or foster parents)... only keep rules when it suits them
      input:
        control: Radio
        labels:
          5: Never
          6: Sometimes
          7: Often
          8: Very often
    - id: E_01k
      kind: Question
      title: My parents (or step parents or foster parents)... make sure I know I am appreciated
      input:
        control: Radio
        labels:
          1: Never
          2: Sometimes
          3: Often
          4: Very often
    - id: E_01l
      kind: Question
      title: My parents (or step parents or foster parents)... threaten punishment more often than they use it
      input:
        control: Radio
        labels:
          5: Never
          6: Sometimes
          7: Often
          8: Very often
    - id: E_01m
      kind: Question
      title: My parents (or step parents or foster parents)... speak of the good things I do
      input:
        control: Radio
        labels:
          1: Never
          2: Sometimes
          3: Often
          4: Very often
    - id: E_01n
      kind: Question
      title: My parents (or step parents or foster parents)... find out about my misbehaviour
      input:
        control: Radio
        labels:
          5: Never
          6: Sometimes
          7: Often
          8: Very often
    - id: E_01o
      kind: Question
      title: My parents (or step parents or foster parents)... enforce a rule or do not enforce a rule depending upon their mood
      input:
        control: Radio
        labels:
          1: Never
          2: Sometimes
          3: Often
          4: Very often
    - id: E_01p
      kind: Question
      title: My parents (or step parents or foster parents)... hit me or threaten to do so
      input:
        control: Radio
        labels:
          5: Never
          6: Sometimes
          7: Often
          8: Very often
    - id: E_01q
      kind: Question
      title: My parents (or step parents or foster parents)... seem proud of the things I do
      input:
        control: Radio
        labels:
          1: Never
          2: Sometimes
          3: Often
          4: Very often
  - id: b_s54_preamble
    title: Puberty setup
    items:
    - id: SEX
      kind: Question
      title: Respondent's sex (value from earlier in the questionnaire or sample file; the source gates F.02-F.05 on FOR GIRLS ONLY / FOR BOYS ONLY and prints no code values here, 1 and 2 are assumed)
      external: true
      input:
        control: Radio
        labels:
          1: Girl
          2: Boy
  - id: b_s54_common
    title: SECTION F. PUBERTY
    items:
    - id: F_01
      kind: Question
      title: 'Would you say that your body hair ("body hair" means underarm and pubic hair):'
      input:
        control: Radio
        labels:
          5: has not yet started growing
          6: has barely started growing
          7: growth of body hair is definitely underway
          8: growth of body hair seems completed
  - id: b_s54_girls
    title: Puberty questions for girls
    precondition:
    - predicate: SEX.outcome == 1
      hint: Asked only when question SEX is "Girl".
    items:
    - id: F_02
      kind: Question
      title: FOR GIRLS ONLY. Have your breasts begun to grow?
      input:
        control: Radio
        labels:
          1: Not yet started growing
          2: Have barely started growing
          3: Breast growth is definitely underway
          4: Breast growth seems completed
    - id: F_03
      kind: Question
      title: FOR GIRLS ONLY. Have you begun to menstruate (your monthly periods)?
      input:
        control: Radio
        labels:
          5: 'Yes'
          6: 'No'
  - id: b_s54_boys
    title: Puberty questions for boys
    precondition:
    - predicate: SEX.outcome == 2
      hint: Asked only when question SEX is "Boy".
    items:
    - id: F_04
      kind: Question
      title: FOR BOYS ONLY. Have you noticed a deepening of your voice?
      input:
        control: Radio
        labels:
          1: Not yet started changing
          2: Has barely started changing
          3: Voice is definitely changing
          4: Voice change seems completed
    - id: F_05
      kind: Question
      title: FOR BOYS ONLY. Have you begun to grow hair on your face?
      input:
        control: Radio
        labels:
          5: Not yet started growing
          6: Has barely started growing
          7: Facial hair growth is definitely underway
          8: Facial hair growth seems completed
  - id: b_s55_tobacco_experience
    title: SECTION G. SMOKING, DRINKING AND DRUGS
    items:
    - id: G_01
      kind: Question
      title: Have you ever tried cigarette smoking, even just a few puffs?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: G_01_reasons
      kind: Question
      title: If No, which of the following are the most important reasons why you have never tried smoking? (follow-up to G.01, printed without its own id)
      precondition:
      - predicate: G_01.outcome == 2
        hint: Asked only when question G.01 is "No".
      input:
        control: Checkbox
        labels:
          1: 01 — Most of my friends do not smoke
          2: 02 — My parents do not smoke
          4: 03 — I think it might be bad for my health
          8: 04 — I think I might not be able to stop
          16: 05 — It is against the law for me to smoke
          32: 06 — I would get into trouble with my parents or teachers
          64: 07 — I would get into trouble with the police
          128: 08 — I cannot get cigarettes or afford them
          256: 09 — I have other things I enjoy doing
          512: 10 — Some other reason
    - id: G_02
      kind: Question
      title: If you do smoke, how often do you smoke cigarettes?
      postcondition:
      - predicate: not (G_01.outcome == 2 and G_02.outcome in [1, 2, 3, 4])
        hint: 'If you answered No to G.01 (never tried smoking), you cannot report smoking regularly in G.02: please check G.01 and G.02.'
        invented: true
      input:
        control: Radio
        labels:
          0: I do not smoke, or only tried once or twice
          1: Every day
          2: At least once or twice a week but not every day
          3: At least once or twice a month but not every week
          4: A few times a year
          5: Once or twice a year
  - id: b_s55_regular_smokers
    title: Regular smoking
    precondition:
    - predicate: not (G_02.outcome == 0)
      hint: Asked only when question G.02 is not "I do not smoke, or only tried once or twice".
    - predicate: not (G_02.outcome == 5)
      hint: Asked only when question G.02 is not "Once or twice a year".
    items:
    - id: G_03
      kind: Question
      title: If you have smoked one or more cigarettes every day for at least 7 days in a row, how old were you when you first did so? (Mark one only)
      postcondition:
      - predicate: not (G_01.outcome == 2 and G_03.outcome != 98)
        hint: If you answered No to G.01 (never tried smoking), mark 'I have never done this' in G.03.
        invented: true
      input:
        control: Editbox
        min: 0
        max: 98
        left: 'Age (enter 98 if I have never done this):'
    - id: G_04
      kind: Question
      title: On the days that you smoke, about how many cigarettes do you usually smoke?
      input:
        control: Editbox
        min: 0
        max: 99
        left: 'Cigarettes (enter 99 if I do not smoke):'
  - id: b_s55_friends_alcohol
    title: Friends who smoke and alcohol
    items:
    - id: G_05
      kind: Question
      title: How many of your friends smoke? (If none write 00)
      input:
        control: Editbox
        min: 0
        max: 99
    - id: G_06
      kind: Question
      title: Have you ever drunk alcohol?
      input:
        control: Switch
        'on': 'Yes'
        'off': 'No'
  - id: b_s56_alcohol
    title: Alcohol use
    precondition:
    - predicate: not (G_06.outcome == 8)
      hint: Asked only when question G.06 is not 8.
    items:
    - id: G_07
      kind: Question
      title: If you have ever drunk more alcohol than the amount allowed by your parents, how old were you when you first did this? (Mark one only) O I have never drunk alcohol OR O I have only drunk the amount allowed by my parents OR I was ___ ___ years old
      input:
        control: Editbox
        min: 0
        max: 99
        left: I was
        right: years old (98 = I have never drunk alcohol; 99 = I have only drunk the amount allowed by my parents)
    - id: G_08
      kind: Question
      title: If you drink anything alcoholic such as wine, liquor or beer, how often do you do so?
      input:
        control: Radio
        labels:
          0: I do not drink alcohol, or only tried once or twice
          1: Every day
          2: At least once or twice a week but not every day
          3: At least once or twice a month but not every week
          4: A few times a year
          5: Once or twice a year
  - id: b_s56_friends_drug_screen
    title: Friends who drink, and drug screener
    items:
    - id: G_09
      kind: Question
      title: How many of your friends drink alcohol? __ __ Friends who drink alcohol (If none write 00)
      input:
        control: Editbox
        min: 0
        max: 99
        right: friends who drink alcohol
    - id: G_10
      kind: Question
      title: Have you ever tried drugs or sniffed glue or solvents?
      input:
        control: Radio
        labels:
          8: 'Yes'
          9: 'No'
  - id: b_s56_drugs
    title: Drug use
    precondition:
    - predicate: not (G_10.outcome == 9)
      hint: Asked only when question G.10 is not "No".
    items:
    - id: G_11a
      kind: Question
      title: a. use marijuana ("pot", "grass" or "hash") (item of G.11; the id G.11a is formed from the printed letter a.)
      input:
        control: Radio
        labels:
          1: I do not use marijuana, or only tried once or twice
          2: Every day
          3: At least once or twice a week but not every day
          4: At least once or twice a month but not every week
          5: A few times a year
          6: Once or twice a year
    - id: G_11b
      kind: Question
      title: b. sniff glue or solvents (item of G.11)
      input:
        control: Radio
        labels:
          7: I do not sniff glue or solvents, or only tried once or twice
          8: Every day
          9: At least once or twice a week but not every day
          10: At least once or twice a month but not every week
          11: A few times a year
          12: Once or twice a year
    - id: G_11c
      kind: Question
      title: c. use other drugs like cocaine, crack, speed, LSD/acid (item of G.11)
      input:
        control: Radio
        labels:
          13: I do not use other drugs. or only tried once or twice
          14: Every day
          15: At least once or twice a week but not every day
          16: At least once or twice a month but not every week
          17: A few times a year
          18: Once or twice a year
    - id: G_12
      kind: Question
      title: If you have used drugs (such as marijuana, glue, solvents or cocaine, etc.) how old were you when you first did so? (Mark one only) O I have never used drugs OR I was ___ ___ years old
      input:
        control: Editbox
        min: 0
        max: 99
        left: I was
        right: years old (99 = I have never used drugs)
  - id: b_s56_friends_drugs
    title: Friends who have tried drugs
    items:
    - id: G_13
      kind: Question
      title: How many of your friends have tried drugs or sniffed glue or solvents? __ __ Friends who have tried drugs or sniffed glue or solvents? (If none write 00)
      input:
        control: Editbox
        min: 0
        max: 99
        right: friends who have tried drugs or sniffed glue or solvents
  - id: b_s57_activities
    title: SECTION H. ACTIVITIES
    items:
    - id: H_01a
      kind: Question
      title: a. Outside of school hours, I take part in sports with a coach or an instructor
      input:
        control: Radio
        labels:
          6: Never
          7: Less than once a week
          8: 1 to 3 times a week
          9: 4 or more times a week
    - id: H_01b
      kind: Question
      title: b. Outside of school, I play sports or do physical activities WITHOUT a coach or instructor.
      input:
        control: Radio
        labels:
          2: Never
          3: Less than once a week
          4: 1 to 3 times a week
          5: 4 or more times a week
    - id: H_01c
      kind: Question
      title: c. Outside of school hours, I take part in Art, Dance or Music Groups or Lessons
      input:
        control: Radio
        labels:
          6: Never
          7: Less than once a week
          8: 1 to 3 times a week
          9: 4 or more times a week
    - id: H_01d
      kind: Question
      title: d. I take part in Clubs or groups such as Girl Guides or Boy Scouts
      input:
        control: Radio
        labels:
          2: Never
          3: Less than once a week
          4: 1 to 3 times a week
          5: 4 or more times a week
    - id: H_01e
      kind: Question
      title: e. I have a job (a paper route, baby sitting, etc.)
      input:
        control: Radio
        labels:
          6: Never
          7: Less than once a week
          8: 1 to 3 times a week
          9: 4 or more times a week
    - id: H_01f
      kind: Question
      title: f. I play computer or video games
      input:
        control: Radio
        labels:
          2: Never
          3: Less than once a week
          4: 1 to 3 times a week
          5: 4 or more times a week
    - id: H_01g
      kind: Question
      title: g. I watch TV
      input:
        control: Radio
        labels:
          6: Never
          7: Less than once a week
          8: 1 to 3 times a week
          9: 4 or more times a week
    - id: H_02
      kind: Question
      title: On average, about how many hours a day do you watch TV?
      input:
        control: Radio
        labels:
          0: 0 - 1 hour a day
          1: 1 - 2 hours a day
          2: 3 - 4 hours a day
          3: 5 - 6 hours a day
          4: 7 or more hours a day
    - id: H_03
      kind: Question
      title: How often do you read for fun (not just for school)
      input:
        control: Radio
        labels:
          4: Every day
          5: A few times a week
          6: Once a week
          7: A few times a month
          8: Less than once a month
          9: Almost never
  - id: b_s58_informed_consent
    title: APPENDIX B Informed Consent
    items:
    - id: Appendix_B_consent
      kind: Question
      title: YES, I agree that my child's teacher may be contacted and asked to complete a questionnaire regarding my child. / YES, I agree that my child's teacher may give my child a brief test of math skills. (no id printed; two checkbox statements, each ticked or not)
      input:
        control: Checkbox
        labels:
          1: YES, I agree that my child's teacher may be contacted and asked to complete a questionnaire regarding my child.
          2: YES, I agree that my child's teacher may give my child a brief test of math skills.
  - id: b_s59_screen
    title: SECTION 1 THIS STUDENT'S EDUCATION
    items:
    - id: Q1
      kind: Question
      title: 'Is this student currently in kindergarten or a similar pre-grade one programme (i.e.: Junior Kindergarten, Primary (Nova Scotia), Nursery (Manitoba), Early Childhood Services (Alberta), or First Year of Primary (British Columbia))? (Mark one circle only)'
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
  - id: b_s59_education
    title: This student's education
    precondition:
    - predicate: not (Q1.outcome == 1)
      hint: Asked only when question 1 is not "Yes".
    items:
    - id: Q2
      kind: Question
      title: Is this student assigned to a grade? (Mark one circle only)
      input:
        control: Radio
        labels:
          3: 'Yes'
          4: No, this student is not assigned to a grade
    - id: Q2a
      kind: Question
      title: In what grade is this student? grade |_|_| (follow-up printed inside the Yes option of Question 2; no id printed, so 2a)
      precondition:
      - predicate: Q2.outcome == 3
        hint: Asked only when question 2 is "Yes".
      input:
        control: Editbox
        min: 1
        max: 99
    - id: Q3
      kind: Question
      title: Is this student in a split or multi-grade class? (Mark one circle only)
      input:
        control: Radio
        labels:
          5: 'Yes'
          6: No, the class contains a single grade
          7: No, the class is ungraded
    - id: Q3a
      kind: Question
      title: What grades are contained in this class? grade |_|_| (lowest grade; follow-up printed inside the Yes option of Question 3, no id printed, so 3a)
      precondition:
      - predicate: Q3.outcome == 5
        hint: Asked only when question 3 is "Yes".
      input:
        control: Editbox
        min: 1
        max: 99
    - id: Q3b
      kind: Question
      title: '... to grade |_|_| (highest grade; no id printed, so 3b)'
      precondition:
      - predicate: Q3.outcome == 5
        hint: Asked only when question 3 is "Yes".
      postcondition:
      - predicate: Q3b.outcome >= Q3a.outcome
        hint: The highest grade in the class (3b) cannot be lower than the lowest grade (3a).
        invented: true
      input:
        control: Editbox
        min: 1
        max: 99
    - id: Q4
      kind: Question
      title: Has this student ever skipped a grade? (Mark one circle only)
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Don't know
    - id: Q5
      kind: Question
      title: Is this student currently repeating his or her grade? (Mark one circle only)
      input:
        control: Radio
        labels:
          4: 'Yes'
          5: 'No'
    - id: Q6
      kind: Question
      title: Has this student previously repeated a grade(s), been retained, or not been promoted to a new grade for any reason? (Mark one circle only)
      input:
        control: Radio
        labels:
          6: 'Yes'
          7: 'No'
          8: Don't know
    - id: Q7
      kind: Question
      title: How would you rate this student's current academic achievement in reading? (Mark one circle only)
      input:
        control: Radio
        labels:
          1: I do not teach reading
          2: Near the top of the class
          3: Above the middle of the class, but not at the top
          4: In the middle of the class
          5: Below the middle of the class, but above the bottom
          6: Near the bottom of the class
    - id: Q8
      kind: Question
      title: How would you rate this student's current academic achievement in mathematics? (Mark one circle only)
      input:
        control: Radio
        labels:
          7: I do not teach mathematics
          8: Near the top of the class
          9: Above the middle of the class, but not at the top
          10: In the middle of the class
          11: Below the middle of the class, but above the bottom
          12: Near the bottom of the class
    - id: Q9
      kind: Question
      title: How would you rate this student's current academic achievement in written work (e.g., spelling and composition)? (Mark one circle only)
      input:
        control: Radio
        labels:
          1: I do not teach spelling or composition
          2: Near the top of the class
          3: Above the middle of the class, but not at the top
          4: In the middle of the class
          5: Below the middle of the class, but above the bottom
          6: Near the bottom of the class
    - id: Q10
      kind: Question
      title: How would you rate this student's current academic achievement across all areas of instruction? (Mark one circle only)
      input:
        control: Radio
        labels:
          7: Near the top of the class
          8: Above the middle of the class, but not at the top
          9: In the middle of the class
          10: Below the middle of the class, but above the bottom
          11: Near the bottom of the class
    - id: Q11
      kind: Question
      title: Looking ahead, how far do you expect this student will go in school? Will he/she... (Mark one circle only)
      input:
        control: Radio
        labels:
          1: Complete primary/elementary school?
          2: Complete some secondary or high school?
          3: Graduate from secondary or high school?
          4: Obtain a community college, technical college, vocational college, business school, or CEGEP certificate or diploma?
          5: Obtain a university degree?
          6: Don’t know
    - id: Q12
      kind: Question
      title: Overall, how long is one cycle of instruction in this student’s homeroom class? (Specify the number of days) |_|_| days
      input:
        control: Editbox
        min: 1
        max: 99
        right: days
    - id: Q13
      kind: Question
      title: How long is the normal school year for this school? (Specify the number of days) |_|_|_| days
      postcondition:
      - predicate: Q12.outcome <= Q13.outcome
        hint: One cycle of instruction (Question 12) cannot be longer than the school year (Question 13).
        invented: true
      input:
        control: Editbox
        min: 1
        max: 999
        right: days
    - id: Q14a
      kind: Question
      title: a) Reading and other language arts (e.g. spelling, grammar, composition)... |_|_|_|_|_| minutes/cycle (item of Question 14; printed code 01)
      input:
        control: Editbox
        min: 0
        max: 99999
        right: minutes/cycle
  - id: b_s60_class_time
    title: Class time per subject (continued) and computer use
    precondition:
    - predicate: not (Q1.outcome == 1)
      hint: Asked only when question 1 is not "Yes".
    items:
    - id: Q14b
      kind: Question
      title: b) Second language education... |_|_|_|_|_| minutes/cycle
      input:
        control: Editbox
        min: 0
        max: 99999
        right: minutes/cycle
    - id: Q14c
      kind: Question
      title: c) Mathematics... |_|_|_|_|_| minutes/cycle
      input:
        control: Editbox
        min: 0
        max: 99999
        right: minutes/cycle
    - id: Q14d
      kind: Question
      title: d) Science... |_|_|_|_|_| minutes/cycle
      input:
        control: Editbox
        min: 0
        max: 99999
        right: minutes/cycle
    - id: Q14e
      kind: Question
      title: e) Social Studies... |_|_|_|_|_| minutes/cycle
      input:
        control: Editbox
        min: 0
        max: 99999
        right: minutes/cycle
    - id: Q14f
      kind: Question
      title: f) Environmental Studies... |_|_|_|_|_| minutes/cycle
      input:
        control: Editbox
        min: 0
        max: 99999
        right: minutes/cycle
    - id: Q14g
      kind: Question
      title: g) Music... |_|_|_|_|_| minutes/cycle
      input:
        control: Editbox
        min: 0
        max: 99999
        right: minutes/cycle
    - id: Q14h
      kind: Question
      title: h) Art... |_|_|_|_|_| minutes/cycle
      input:
        control: Editbox
        min: 0
        max: 99999
        right: minutes/cycle
    - id: Q14i
      kind: Question
      title: i) Physical Education... |_|_|_|_|_| minutes/cycle
      input:
        control: Editbox
        min: 0
        max: 99999
        right: minutes/cycle
    - id: Q14j
      kind: Question
      title: j) Learning how to use computers... |_|_|_|_|_| minutes/cycle
      input:
        control: Editbox
        min: 0
        max: 99999
        right: minutes/cycle
    - id: Q14k
      kind: Question
      title: k) Other topics... |_|_|_|_|_| minutes/cycle
      input:
        control: Editbox
        min: 0
        max: 99999
        right: minutes/cycle
    - id: Q15
      kind: Question
      title: 15. How much class time per cycle does this student spend using a computer? (Specify the number of minutes per cycle)
      input:
        control: Editbox
        min: 0
        max: 99999
        right: minutes/cycle
  - id: b_s60_language
    title: Language of instruction
    precondition:
    - predicate: not (Q1.outcome == 1)
      hint: Asked only when question 1 is not "Yes".
    items:
    - id: Q16
      kind: Question
      title: 16. Thinking about the most recent full instructional cycle, what is the main language of instruction in this student's class? (Mark the circle corresponding to the predominant language of instruction in this student's regular class)
      input:
        control: Radio
        labels:
          1: French
          2: English
          3: An equal combination of French and English
          4: Other
  - id: b_s60_social_skills
    title: Social and personal skills
    precondition:
    - predicate: not (Q1.outcome == 1)
      hint: Asked only when question 1 is not "Yes".
    items:
    - id: Q17a
      kind: Question
      title: 17. a) Works cooperatively with other students... (how often this student demonstrates)
      input:
        control: Radio
        labels:
          1: Never
          2: Rarely
          3: Sometimes
          4: Usually
          5: Always
    - id: Q17b
      kind: Question
      title: 17. b) Plays cooperatively with other students...
      input:
        control: Radio
        labels:
          6: Never
          7: Rarely
          8: Sometimes
          9: Usually
          10: Always
    - id: Q17c
      kind: Question
      title: 17. c) Follows rules...
      input:
        control: Radio
        labels:
          11: Never
          12: Rarely
          13: Sometimes
          14: Usually
          15: Always
    - id: Q17d
      kind: Question
      title: 17. d) Follows instructions...
      input:
        control: Radio
        labels:
          16: Never
          17: Rarely
          18: Sometimes
          19: Usually
          20: Always
    - id: Q17e
      kind: Question
      title: 17. e) Respects the property of others...
      input:
        control: Radio
        labels:
          21: Never
          22: Rarely
          23: Sometimes
          24: Usually
          25: Always
    - id: Q17f
      kind: Question
      title: 17. f) Demonstrates self-control...
      input:
        control: Radio
        labels:
          26: Never
          27: Rarely
          28: Sometimes
          29: Usually
          30: Always
    - id: Q17g
      kind: Question
      title: 17. g) Shows self-confidence...
      input:
        control: Radio
        labels:
          31: Never
          32: Rarely
          33: Sometimes
          34: Usually
          35: Always
    - id: Q17h
      kind: Question
      title: 17. h) Demonstrates respect for adults...
      input:
        control: Radio
        labels:
          36: Never
          37: Rarely
          38: Sometimes
          39: Usually
          40: Always
    - id: Q17i
      kind: Question
      title: 17. i) Demonstrates respect for other children...
      input:
        control: Radio
        labels:
          41: Never
          42: Rarely
          43: Sometimes
          44: Usually
          45: Always
    - id: Q17j
      kind: Question
      title: 17. j) Accepts responsibility for actions...
      input:
        control: Radio
        labels:
          46: Never
          47: Rarely
          48: Sometimes
          49: Usually
          50: Always
  - id: b_s60_work_habits
    title: Work habits
    precondition:
    - predicate: not (Q1.outcome == 1)
      hint: Asked only when question 1 is not "Yes".
    items:
    - id: Q18a
      kind: Question
      title: 18. a) Listens attentively... (how often this student demonstrates each work habit)
      input:
        control: Radio
        labels:
          1: Never
          2: Rarely
          3: Sometimes
          4: Usually
          5: Always
    - id: Q18b
      kind: Question
      title: 18. b) Follows directions...
      input:
        control: Radio
        labels:
          6: Never
          7: Rarely
          8: Sometimes
          9: Usually
          10: Always
    - id: Q18c
      kind: Question
      title: 18. c) Completes work on time...
      input:
        control: Radio
        labels:
          11: Never
          12: Rarely
          13: Sometimes
          14: Usually
          15: Always
    - id: Q18d
      kind: Question
      title: 18. d) Works independently...
      input:
        control: Radio
        labels:
          16: Never
          17: Rarely
          18: Sometimes
          19: Usually
          20: Always
    - id: Q18e
      kind: Question
      title: 18. e) Takes care of materials...
      input:
        control: Radio
        labels:
          21: Never
          22: Rarely
          23: Sometimes
          24: Usually
          25: Always
    - id: Q18f
      kind: Question
      title: 18. f) Works neatly and carefully...
      input:
        control: Radio
        labels:
          26: Never
          27: Rarely
          28: Sometimes
          29: Usually
          30: Always
  - id: b_s60_enhanced
    title: Enhanced instruction
    precondition:
    - predicate: not (Q1.outcome == 1)
      hint: Asked only when question 1 is not "Yes".
    items:
    - id: Q19
      kind: Question
      title: 19. Does this student receive enhanced or extra instruction at school because of his/her exceptionally advanced intellectual or artistic abilities? (Mark one circle only)
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: Q20
      kind: Question
      title: 20. Where does this student receive this enhanced or extra instruction? (Mark one circle only)
      precondition:
      - predicate: not (Q19.outcome == 2)
        hint: Asked only when question 19 is not "No".
      input:
        control: Radio
        labels:
          3: Exclusively within a regular classroom
          4: Primarily within a regular classroom but with some time spent in a special education class or resource room
          5: Primarily within a special education class or resource room but with some integration into a regular classroom
          6: Exclusively within a special education class or resource room within a regular school
          7: Exclusively within a special school in the school district
          8: Exclusively within a special residential school
          9: Other
  - id: b_s60_special_screen
    title: Special education
    precondition:
    - predicate: not (Q1.outcome == 1)
      hint: Asked only when question 1 is not "Yes".
    items:
    - id: Q21
      kind: Question
      title: 21. Does this student receive special education because a physical, emotional, behavioural, or some other problem limits the kind or amount of school work he/she can do? (Mark one circle only)
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
  - id: b_s60_special_details
    title: Special education details
    precondition:
    - predicate: not (Q1.outcome == 1)
      hint: Asked only when question 1 is not "Yes".
    - predicate: not (Q21.outcome == 2)
      hint: Asked only when question 21 is not "No".
    items:
    - id: Q22
      kind: Question
      title: 22. What type of problem limits this student's ability to do school work in a regular classroom? (Mark as many circles as applicable)
      input:
        control: Checkbox
        labels:
          1: 01 — A physical disability
          2: 02 — A visual impairment
          4: 03 — A hearing impairment
          8: 04 — A speech impairment
          16: 05 — A learning disability
          32: 06 — An emotional or behavioural problem
          64: 07 — A mental disability or limitation
          128: 08 — Home environment/problems at home
          256: 09 — He/she does not understand the language spoken at school
          512: 10 — Some other type of problem
    - id: Q23
      kind: Question
      title: 23. Where does this student receive this special education? (Mark one circle only)
      input:
        control: Radio
        labels:
          1: Exclusively within a regular classroom
          2: Primarily within a regular classroom but with some time spent in a special education class or resource room
          3: Primarily within a special education class or resource room but with some integration into a regular classroom
          4: Exclusively within a special education class or resource room within a regular school
          5: Exclusively within a special school in the school district
          6: Exclusively within a special residential school
          7: Other
  - id: b_s61_absence
    title: SECTION 2 THIS STUDENT'S BEHAVIOUR AND ABSENTEEISM
    precondition:
    - predicate: not (Q1.outcome == 1)
      hint: Asked only when question 1 is not "Yes".
    items:
    - id: Q24
      kind: Question
      title: 24. About how many regular school days has this student been absent since the beginning of school in the fall (Specify the number of days absent)
      input:
        control: Editbox
        min: 0
        max: 999
    - id: Q25
      kind: Question
      title: 25. Since the beginning of school in the fall about how many times has this student skipped a day of school without permission? (Mark one circle only)
      input:
        control: Radio
        labels:
          0: Never
          1: Once
          2: Twice
          3: More than twice
          4: Don't know
  - id: b_s61_preparedness
    title: School preparedness
    precondition:
    - predicate: not (Q1.outcome == 1)
      hint: Asked only when question 1 is not "Yes".
    items:
    - id: Q26a
      kind: Question
      title: 26. Since the start of school in the fall, how often has this student arrived .... a) Without the materials (e.g., notebooks, paper) needed to do his/her schoolwork...
      input:
        control: Radio
        labels:
          1: Never
          2: Rarely
          3: Sometimes
          4: Usually
          5: Always
    - id: Q26b
      kind: Question
      title: 26. b) Inadequately clothed to participate in school related activities (e.g., gym, sports, field trips, recess)...
      input:
        control: Radio
        labels:
          6: Never
          7: Rarely
          8: Sometimes
          9: Usually
          10: Always
    - id: Q26c
      kind: Question
      title: 26. c) Inadequately dressed for the weather conditions (e.g., canvas running shoes in winter)...
      input:
        control: Radio
        labels:
          11: Never
          12: Rarely
          13: Sometimes
          14: Usually
          15: Always
    - id: Q26d
      kind: Question
      title: 26. d) Too tired to do school work...
      input:
        control: Radio
        labels:
          16: Never
          17: Rarely
          18: Sometimes
          19: Usually
          20: Always
    - id: Q26e
      kind: Question
      title: 26. e) Without his/her homework completed...
      input:
        control: Radio
        labels:
          21: Never
          22: Rarely
          23: Sometimes
          24: Usually
          25: Always
    - id: Q26f
      kind: Question
      title: 26. f) Late for school...
      input:
        control: Radio
        labels:
          26: Never
          27: Rarely
          28: Sometimes
          29: Usually
          30: Always
  - id: b_s61_behaviour
    title: Student behaviour
    precondition:
    - predicate: not (Q1.outcome == 1)
      hint: Asked only when question 1 is not "Yes".
    items:
    - id: Q27a
      kind: Question
      title: '27. Using the answers never or not true, sometimes or somewhat true and often or very true, how often would you say that this student: a) Shows sympathy to someone who has made a mistake...'
      input:
        control: Radio
        labels:
          1: Never or not true
          2: Sometimes or somewhat true
          3: Often or very true
    - id: Q27b
      kind: Question
      title: 27. b) Can't sit still, is restless or hyperactive...
      input:
        control: Radio
        labels:
          4: Never or not true
          5: Sometimes or somewhat true
          6: Often or very true
    - id: Q27c
      kind: Question
      title: 27. c) Destroys his/her own things...
      input:
        control: Radio
        labels:
          7: Never or not true
          8: Sometimes or somewhat true
          9: Often or very true
    - id: Q27d
      kind: Question
      title: 27. d) Will try to help someone who has been hurt...
      input:
        control: Radio
        labels:
          10: Never or not true
          11: Sometimes or somewhat true
          12: Often or very true
    - id: Q27e
      kind: Question
      title: 27. e) Steals...
      input:
        control: Radio
        labels:
          13: Never or not true
          14: Sometimes or somewhat true
          15: Often or very true
    - id: Q27f
      kind: Question
      title: 27. f) Seems to be unhappy, sad or depressed...
      input:
        control: Radio
        labels:
          16: Never or not true
          17: Sometimes or somewhat true
          18: Often or very true
    - id: Q27g
      kind: Question
      title: 27. g) Gets into many fights...
      input:
        control: Radio
        labels:
          19: Never or not true
          20: Sometimes or somewhat true
          21: Often or very true
    - id: Q27h
      kind: Question
      title: 27. h) Volunteers to help clear up a mess someone else has made...
      input:
        control: Radio
        labels:
          22: Never or not true
          23: Sometimes or somewhat true
          24: Often or very true
    - id: Q27i
      kind: Question
      title: 27. i) Is distractible, has trouble sticking to any activity...
      input:
        control: Radio
        labels:
          25: Never or not true
          26: Sometimes or somewhat true
          27: Often or very true
    - id: Q27j
      kind: Question
      title: 27. j) When mad at someone tries to get others to dislike her/him...
      input:
        control: Radio
        labels:
          28: Never or not true
          29: Sometimes or somewhat true
          30: Often or very true
    - id: Q27k
      kind: Question
      title: 27. k) Is not as happy as other children...
      input:
        control: Radio
        labels:
          31: Never or not true
          32: Sometimes or somewhat true
          33: Often or very true
    - id: Q27l
      kind: Question
      title: 27. l) Destroys things belonging to others...
      input:
        control: Radio
        labels:
          34: Never or not true
          35: Sometimes or somewhat true
          36: Often or very true
    - id: Q27m
      kind: Question
      title: 27. m) If there is a quarrel or dispute will try to stop it...
      input:
        control: Radio
        labels:
          37: Never or not true
          38: Sometimes or somewhat true
          39: Often or very true
    - id: Q27n
      kind: Question
      title: 27. n) Fidgets...
      input:
        control: Radio
        labels:
          40: Never or not true
          41: Sometimes or somewhat true
          42: Often or very true
    - id: Q27o
      kind: Question
      title: 27. o) Is disobedient at school...
      input:
        control: Radio
        labels:
          43: Never or not true
          44: Sometimes or somewhat true
          45: Often or very true
    - id: Q27p
      kind: Question
      title: 27. p) Can't concentrate, can't pay attention for long...
      input:
        control: Radio
        labels:
          46: Never or not true
          47: Sometimes or somewhat true
          48: Often or very true
    - id: Q27q
      kind: Question
      title: 27. q) Is too fearful or anxious...
      input:
        control: Radio
        labels:
          49: Never or not true
          50: Sometimes or somewhat true
          51: Often or very true
    - id: Q27r
      kind: Question
      title: 27. r) When mad at someone, becomes friends with another as revenge...
      input:
        control: Radio
        labels:
          52: Never or not true
          53: Sometimes or somewhat true
          54: Often or very true
    - id: Q27s
      kind: Question
      title: 27. s) Is impulsive, acts without thinking...
      input:
        control: Radio
        labels:
          55: Never or not true
          56: Sometimes or somewhat true
          57: Often or very true
    - id: Q27t
      kind: Question
      title: 27. t) Tells lies or cheats...
      input:
        control: Radio
        labels:
          58: Never or not true
          59: Sometimes or somewhat true
          60: Often or very true
    - id: Q27u
      kind: Question
      title: 27. u) Offers to help other children (friend, brother, or sister) who are having difficulty with a task...
      input:
        control: Radio
        labels:
          61: Never or not true
          62: Sometimes or somewhat true
          63: Often or very true
    - id: Q27v
      kind: Question
      title: 27. v) Is worried...
      input:
        control: Radio
        labels:
          64: Never or not true
          65: Sometimes or somewhat true
          66: Often or very true
    - id: Q27w
      kind: Question
      title: 27. w) Has difficulty awaiting turn in games or groups...
      input:
        control: Radio
        labels:
          67: Never or not true
          68: Sometimes or somewhat true
          69: Often or very true
    - id: Q27x
      kind: Question
      title: 27. x) When another child accidentally hurts her/him (such as by bumping into her or him), assumes that the other child meant to do it and then reacts with anger and fighting...
      input:
        control: Radio
        labels:
          70: Never or not true
          71: Sometimes or somewhat true
          72: Often or very true
    - id: Q27y
      kind: Question
      title: 27. y) Tends to do things on his/her own - is rather solitary...
      input:
        control: Radio
        labels:
          73: Never or not true
          74: Sometimes or somewhat true
          75: Often or very true
    - id: Q27z
      kind: Question
      title: 27. z) When mad at someone, says bad things behind the other's back...
      input:
        control: Radio
        labels:
          76: Never or not true
          77: Sometimes or somewhat true
          78: Often or very true
    - id: Q27aa
      kind: Question
      title: 27. aa) Physically attacks people...
      input:
        control: Radio
        labels:
          79: Never or not true
          80: Sometimes or somewhat true
          81: Often or very true
    - id: Q27bb
      kind: Question
      title: 27. bb) Comforts a child (friend, brother, or sister) who is crying or upset...
      input:
        control: Radio
        labels:
          82: Never or not true
          83: Sometimes or somewhat true
          84: Often or very true
    - id: Q27cc
      kind: Question
      title: 27. cc) Cries a lot...
      input:
        control: Radio
        labels:
          85: Never or not true
          86: Sometimes or somewhat true
          87: Often or very true
    - id: Q27dd
      kind: Question
      title: 27. dd) Vandalizes...
      input:
        control: Radio
        labels:
          88: Never or not true
          89: Sometimes or somewhat true
          90: Often or very true
    - id: Q27ee
      kind: Question
      title: 27. ee) Gives up easily...
      input:
        control: Radio
        labels:
          91: Never or not true
          92: Sometimes or somewhat true
          93: Often or very true
    - id: Q27ff
      kind: Question
      title: 27. ff) Threatens people...
      input:
        control: Radio
        labels:
          94: Never or not true
          95: Sometimes or somewhat true
          96: Often or very true
    - id: Q27gg
      kind: Question
      title: 27. gg) Spontaneously helps to pick up objects which another child has dropped (e.g., pencils, books)...
      input:
        control: Radio
        labels:
          97: Never or not true
          98: Sometimes or somewhat true
          99: Often or very true
    - id: Q27hh
      kind: Question
      title: 27. hh) Cannot settle to anything for more than a few moments...
      input:
        control: Radio
        labels:
          100: Never or not true
          101: Sometimes or somewhat true
          102: Often or very true
    - id: Q27ii
      kind: Question
      title: 27. ii) Appears miserable, unhappy, tearful or distressed...
      input:
        control: Radio
        labels:
          103: Never or not true
          104: Sometimes or somewhat true
          105: Often or very true
    - id: Q27jj
      kind: Question
      title: 27. jj) Is cruel, bullies or is mean to others...
      input:
        control: Radio
        labels:
          106: Never or not true
          107: Sometimes or somewhat true
          108: Often or very true
    - id: Q27kk
      kind: Question
      title: 27. kk) Stares into space...
      input:
        control: Radio
        labels:
          109: Never or not true
          110: Sometimes or somewhat true
          111: Often or very true
    - id: Q27ll
      kind: Question
      title: '27. ll) When mad at someone, says to others: let''s not be with her/him...'
      input:
        control: Radio
        labels:
          112: Never or not true
          113: Sometimes or somewhat true
          114: Often or very true
    - id: Q27mm
      kind: Question
      title: 27. mm) Is nervous, high-strung, or tense...
      input:
        control: Radio
        labels:
          115: Never or not true
          116: Sometimes or somewhat true
          117: Often or very true
    - id: Q27nn
      kind: Question
      title: 27. nn) Kicks, bites, hits other children...
      input:
        control: Radio
        labels:
          118: Never or not true
          119: Sometimes or somewhat true
          120: Often or very true
    - id: Q27oo
      kind: Question
      title: 27. oo) Will invite bystanders to join in a game...
      input:
        control: Radio
        labels:
          121: Never or not true
          122: Sometimes or somewhat true
          123: Often or very true
    - id: Q27pp
      kind: Question
      title: 27. pp) Is inattentive...
      input:
        control: Radio
        labels:
          124: Never or not true
          125: Sometimes or somewhat true
          126: Often or very true
    - id: Q27qq
      kind: Question
      title: 27. qq) Has trouble enjoying self...
      input:
        control: Radio
        labels:
          127: Never or not true
          128: Sometimes or somewhat true
          129: Often or very true
    - id: Q27rr
      kind: Question
      title: 27. rr) Helps other children (friends, brother or sister) who are feeling sick...
      input:
        control: Radio
        labels:
          130: Never or not true
          131: Sometimes or somewhat true
          132: Often or very true
    - id: Q27ss
      kind: Question
      title: 27. ss) When mad at someone, tells the other one's secrets to a third person...
      input:
        control: Radio
        labels:
          133: Never or not true
          134: Sometimes or somewhat true
          135: Often or very true
    - id: Q27tt
      kind: Question
      title: 27. tt) Takes the opportunity to praise the work of less able children...
      input:
        control: Radio
        labels:
          136: Never or not true
          137: Sometimes or somewhat true
          138: Often or very true
  - id: b_s62_parental_involvement
    title: SECTION 3 PARENT'S(S') / GUARDIAN'S(S') INVOLVEMENT IN THIS STUDENT'S EDUCATION
    precondition:
    - predicate: not (Q1.outcome == 1)
      hint: Asked only when question 1 is not "Yes".
    items:
    - id: Q28a
      kind: Question
      title: 28. Since the beginning of school last fall did a parent/guardian of this student... a) Participate in regularly scheduled parent-teacher conferences (either in person or on the telephone)...
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Not Applicable
    - id: Q28b
      kind: Question
      title: 28. b) Contact you to discuss this student's academic performance or behaviour...
      input:
        control: Radio
        labels:
          4: 'Yes'
          5: 'No'
          6: Not Applicable
    - id: Q28c
      kind: Question
      title: 28. c) Return your call to talk about this student's academic performance or behaviour...
      input:
        control: Radio
        labels:
          7: 'Yes'
          8: 'No'
          9: Not Applicable
    - id: Q29
      kind: Question
      title: 29. In your opinion, how involved is/are the parent(s)/guardian(s) in this student's education? (Mark one circle only)
      input:
        control: Radio
        labels:
          1: Very Involved
          2: Somewhat involved
          3: Not involved
          4: Don't know the parent(s)/guardian(s) well enough
    - id: Q30
      kind: Question
      title: 30. In your opinion, how important is school considered to be to this student's parent(s)/guardian(s)? (Mark one circle only)
      input:
        control: Radio
        labels:
          5: Very important
          6: Somewhat important
          7: Little importance
          8: Don't know the parent(s)/guardian(s) well enough
    - id: Q31
      kind: Question
      title: 31. In your opinion, to what extent do the parent(s)/guardian(s) of this student support your teaching efforts? (Mark one circle only)
      input:
        control: Radio
        labels:
          1: Strongly support
          2: Somewhat support
          3: Do not support
          4: Don't know the parent(s)/guardian(s) well enough
    - id: Q32
      kind: Question
      title: 32. How often during the past month has a parent/guardian of this child volunteered in your kindergarten class? (Mark one circle only)
      input:
        control: Radio
        labels:
          5: Not applicable because the child is not in kindergarten
          6: Never
          7: Once
          8: Twice
          9: More than twice
  - id: b_s63_class
    title: SECTION 4 YOUR CLASS AND TEACHING PRACTICES
    precondition:
    - predicate: not (Q1.outcome == 1)
      hint: Asked only when question 1 is not "Yes".
    items:
    - id: Q33
      kind: Question
      title: 33. Currently, how many students are enrolled in your class? (Specify the number of students)
      input:
        control: Editbox
        min: 0
        max: 999
    - id: Q34a
      kind: Question
      title: '34. Including those who have not been officially identified as having the following long-term problems, how many students in your class have: (Some children may belong to more than one category) a) A speech, hearing, vision, mobility or other health impairment that affects their learning?'
      input:
        control: Editbox
        min: 0
        max: 999
      postcondition:
      - predicate: Q34a.outcome <= Q33.outcome
        hint: The number of students in 34a cannot exceed the number of students enrolled in your class (Q33).
        invented: true
    - id: Q34b
      kind: Question
      title: 34. b) An emotional, or behavioural problem?
      input:
        control: Editbox
        min: 0
        max: 999
      postcondition:
      - predicate: Q34b.outcome <= Q33.outcome
        hint: The number of students in 34b cannot exceed the number of students enrolled in your class (Q33).
        invented: true
    - id: Q34c
      kind: Question
      title: '34. c) A learning problem? (e.g.: a problem with attention, memory, reasoning, reading, writing, spelling, or calculation which interferes with learning)?'
      input:
        control: Editbox
        min: 0
        max: 999
      postcondition:
      - predicate: Q34c.outcome <= Q33.outcome
        hint: The number of students in 34c cannot exceed the number of students enrolled in your class (Q33).
        invented: true
    - id: Q35a
      kind: Question
      title: '35. How many students in your class: (Some children may belong to more than one category) a) Have a first language other than English or French?'
      input:
        control: Editbox
        min: 0
        max: 999
      postcondition:
      - predicate: Q35a.outcome <= Q33.outcome
        hint: The number of students in 35a cannot exceed the number of students enrolled in your class (Q33).
        invented: true
    - id: Q35b
      kind: Question
      title: 35. b) Have immigrated to Canada within the last year?
      input:
        control: Editbox
        min: 0
        max: 999
      postcondition:
      - predicate: Q35b.outcome <= Q33.outcome
        hint: The number of students in 35b cannot exceed the number of students enrolled in your class (Q33).
        invented: true
    - id: Q36
      kind: Question
      title: 36. Compared with other teachers in your school who are teaching the same grade(s), do you feel that your class has .... (Mark one circle only)
      input:
        control: Radio
        labels:
          1: Lower overall academic ability than their classes
          2: Similar overall academic ability to their classes
          3: Higher overall academic ability than their classes
          4: A greater diversity of academic abilities than their classes
          5: There are no other classes at the same grade(s)
    - id: Q37
      kind: Question
      title: 37. Do you teach reading to your class? (Mark one circle only)
      input:
        control: Radio
        labels:
          6: 'Yes'
          7: 'No'
  - id: b_s63_reading
    title: Strategies to teach reading
    precondition:
    - predicate: not (Q1.outcome == 1) and not (Q37.outcome == 7)
      hint: Asked only when question 1 is not "Yes" and question 37 is not "No".
    items:
    - id: Q38a
      kind: Question
      title: 38. How often do you use each of the following strategies to teach reading to your class? a) Teach reading to the class as a whole...
      input:
        control: Radio
        labels:
          1: Never
          2: Rarely
          3: Sometimes
          4: Usually
          5: Always
    - id: Q38b
      kind: Question
      title: 38. b) Divide the class into groups having similar reading abilities...
      input:
        control: Radio
        labels:
          6: Never
          7: Rarely
          8: Sometimes
          9: Usually
          10: Always
    - id: Q38c
      kind: Question
      title: 38. c) Divide the class into groups having a mixture of reading abilities...
      input:
        control: Radio
        labels:
          11: Never
          12: Rarely
          13: Sometimes
          14: Usually
          15: Always
    - id: Q38d
      kind: Question
      title: 38. d) Allow students to form their own reading groups...
      input:
        control: Radio
        labels:
          16: Never
          17: Rarely
          18: Sometimes
          19: Usually
          20: Always
    - id: Q38e
      kind: Question
      title: 38. e) Use individualized instruction plans to teach reading...
      input:
        control: Radio
        labels:
          21: Never
          22: Rarely
          23: Sometimes
          24: Usually
          25: Always
    - id: Q38f
      kind: Question
      title: 38. f) Other
      input:
        control: Radio
        labels:
          26: Never
          27: Rarely
          28: Sometimes
          29: Usually
          30: Always
  - id: b_s63_writing_screen
    title: Teaching writing
    precondition:
    - predicate: not (Q1.outcome == 1)
      hint: Asked only when question 1 is not "Yes".
    items:
    - id: Q39
      kind: Question
      title: 39. Do you teach writing (composition) to your class? (Mark one circle only)
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
  - id: b_s63_writing
    title: Strategies to teach writing
    precondition:
    - predicate: not (Q1.outcome == 1) and not (Q39.outcome == 2)
      hint: Asked only when question 1 is not "Yes" and question 39 is not "No".
    items:
    - id: Q40a
      kind: Question
      title: 40. How often do you use each of the following strategies to teach writing (composition) to your class? a) Teach writing to the class as a whole...
      input:
        control: Radio
        labels:
          1: Never
          2: Rarely
          3: Sometimes
          4: Usually
          5: Always
    - id: Q40b
      kind: Question
      title: 40. b) Divide the class into groups having similar writing abilities...
      input:
        control: Radio
        labels:
          6: Never
          7: Rarely
          8: Sometimes
          9: Usually
          10: Always
    - id: Q40c
      kind: Question
      title: 40. c) Divide the class ...
      input:
        control: Radio
        labels:
          11: Never
          12: Rarely
          13: Sometimes
          14: Usually
          15: Always
  - id: b_s64_writing
    title: Strategies to teach writing (continued)
    precondition:
    - predicate: not (Q1.outcome == 1)
      hint: Asked only when question 1 is not "Yes".
    - predicate: not (Q39.outcome == 2)
      hint: Asked only when question 39 is not "No".
    items:
    - id: Q40c_2
      kind: Question
      title: '[Strategies to teach writing, continued from previous part; wording cut at page start] c) ... Divide the class into groups having a mixture of writing abilities... (Never/Rarely/Sometimes/Usually/Always)'
      input:
        control: Radio
        labels:
          1: Never
          2: Rarely
          3: Sometimes
          4: Usually
          5: Always
    - id: Q40d
      kind: Question
      title: d) Allow students to form their own writing groups...
      input:
        control: Radio
        labels:
          1: Never
          2: Rarely
          3: Sometimes
          4: Usually
          5: Always
    - id: Q40e
      kind: Question
      title: e) Use individualized instruction plans to teach writing...
      input:
        control: Radio
        labels:
          1: Never
          2: Rarely
          3: Sometimes
          4: Usually
          5: Always
    - id: Q40f
      kind: Question
      title: f) Other
      input:
        control: Radio
        labels:
          1: Never
          2: Rarely
          3: Sometimes
          4: Usually
          5: Always
  - id: b_s64_math
    title: Teaching mathematics
    precondition:
    - predicate: not (Q1.outcome == 1)
      hint: Asked only when question 1 is not "Yes".
    items:
    - id: Q41
      kind: Question
      title: 41. Do you teach mathematics to your class? (Mark one circle only)
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: Q42a
      kind: Question
      title: 42. How often do you use each of the following strategies to teach mathematics to your class? a) Teach mathematics to the class as a whole...
      input:
        control: Radio
        labels:
          1: Never
          2: Rarely
          3: Sometimes
          4: Usually
          5: Always
    - id: Q42b
      kind: Question
      title: b) Divide the class into groups having similar mathematical abilities...
      input:
        control: Radio
        labels:
          1: Never
          2: Rarely
          3: Sometimes
          4: Usually
          5: Always
    - id: Q42c
      kind: Question
      title: c) Divide the class into groups having a mixture of mathematical abilities...
      input:
        control: Radio
        labels:
          1: Never
          2: Rarely
          3: Sometimes
          4: Usually
          5: Always
    - id: Q42d
      kind: Question
      title: d) Allow students to form their own mathematics groups...
      input:
        control: Radio
        labels:
          1: Never
          2: Rarely
          3: Sometimes
          4: Usually
          5: Always
    - id: Q42e
      kind: Question
      title: e) Use individualized instruction plans to teach mathematics...
      input:
        control: Radio
        labels:
          1: Never
          2: Rarely
          3: Sometimes
          4: Usually
          5: Always
    - id: Q42f
      kind: Question
      title: f) Other
      input:
        control: Radio
        labels:
          1: Never
          2: Rarely
          3: Sometimes
          4: Usually
          5: Always
  - id: b_s64_time
    title: Non-instructional time
    precondition:
    - predicate: not (Q1.outcome == 1)
      hint: Asked only when question 1 is not "Yes".
    items:
    - id: Q43a
      kind: Question
      title: 43. For the most recent full cycle of instruction, please indicate the number of minutes you spent on the following non-instructional activities. (Specify the number of minutes per cycle) a) Maintaining order and discipline
      input:
        control: Editbox
        min: 0
        max: 99999
        right: minutes/cycle
    - id: Q43b
      kind: Question
      title: b) Performing routine tasks (e.g., taking attendance, filling out forms) minutes/cycle
      input:
        control: Editbox
        min: 0
        max: 99999
        right: minutes/cycle
    - id: Q43c
      kind: Question
      title: c) Professional discussions with colleagues minutes/cycle
      input:
        control: Editbox
        min: 0
        max: 99999
        right: minutes/cycle
    - id: Q43d
      kind: Question
      title: d) Supervising children at noon/recess minutes/cycle
      input:
        control: Editbox
        min: 0
        max: 99999
        right: minutes/cycle
    - id: Q43e
      kind: Question
      title: e) Assisting/directing extra-curricular activities minutes/cycle
      input:
        control: Editbox
        min: 0
        max: 99999
        right: minutes/cycle
    - id: Q43f
      kind: Question
      title: f) In discussions with students' parents/guardians minutes/cycle
      input:
        control: Editbox
        min: 0
        max: 99999
        right: minutes/cycle
  - id: b_s64_homework
    title: Homework
    precondition:
    - predicate: not (Q1.outcome == 1)
      hint: Asked only when question 1 is not "Yes".
    items:
    - id: Q44
      kind: Question
      title: 44. How often do you assign your class homework? (Do not include students' uncompleted classroom work)
      input:
        control: Radio
        labels:
          1: Always
          2: Usually
          3: Sometimes
          4: Rarely
          5: Never
    - id: Q45
      kind: Question
      title: 45. Approximately how much homework do you assign each day? (Specify the number of minutes per day) minutes/day
      input:
        control: Editbox
        min: 0
        max: 999
        right: minutes/day
    - id: Q46a
      kind: Question
      title: 46. How often do you monitor homework in the following ways? a) By keeping a record of who turned in assignments...
      input:
        control: Radio
        labels:
          1: Never
          2: Rarely
          3: Sometimes
          4: Usually
          5: Always
    - id: Q46b
      kind: Question
      title: b) By returning assignments with corrections or grades...
      input:
        control: Radio
        labels:
          1: Never
          2: Rarely
          3: Sometimes
          4: Usually
          5: Always
    - id: Q46c
      kind: Question
      title: c) By discussing homework in class...
      input:
        control: Radio
        labels:
          1: Never
          2: Rarely
          3: Sometimes
          4: Usually
          5: Always
    - id: Q46d
      kind: Question
      title: d) By having parent(s)/guardian(s) sign a homework book/note...
      input:
        control: Radio
        labels:
          1: Never
          2: Rarely
          3: Sometimes
          4: Usually
          5: Always
    - id: Q46e
      kind: Question
      title: e) By student's own or their peer's evaluations...
      input:
        control: Radio
        labels:
          1: Never
          2: Rarely
          3: Sometimes
          4: Usually
          5: Always
  - id: b_s64_attitudes
    title: Teacher attitudes
    precondition:
    - predicate: not (Q1.outcome == 1)
      hint: Asked only when question 1 is not "Yes".
    items:
    - id: Q47a
      kind: Question
      title: 47. Please indicate the extent to which you agree or disagree with each statement. a) Many of the students I teach are not capable of mastering the curriculum at their grade...
      input:
        control: Radio
        labels:
          1: Strongly disagree
          2: Disagree
          3: Neither agree nor disagree
          4: Agree
          5: Strongly agree
    - id: Q47b
      kind: Question
      title: b) The emphasis in my classroom is on the development of academic skills...
      input:
        control: Radio
        labels:
          1: Strongly disagree
          2: Disagree
          3: Neither agree nor disagree
          4: Agree
          5: Strongly agree
    - id: Q47c
      kind: Question
      title: c) I have a strong effect on the academic achievement of the students I teach
      input:
        control: Radio
        labels:
          1: Strongly disagree
          2: Disagree
          3: Neither agree nor disagree
          4: Agree
          5: Strongly agree
    - id: Q47d
      kind: Question
      title: d) I feel competent in dealing with student's behavioural problems...
      input:
        control: Radio
        labels:
          1: Strongly disagree
          2: Disagree
          3: Neither agree nor disagree
          4: Agree
          5: Strongly agree
    - id: Q47e
      kind: Question
      title: e) I feel students' success at school is determined mainly by their home environment...
      input:
        control: Radio
        labels:
          1: Strongly disagree
          2: Disagree
          3: Neither agree nor disagree
          4: Agree
          5: Strongly agree
    - id: Q47f
      kind: Question
      title: f) I have high expectations for the academic success of my students...
      input:
        control: Radio
        labels:
          1: Strongly disagree
          2: Disagree
          3: Neither agree nor disagree
          4: Agree
          5: Strongly agree
    - id: Q47g
      kind: Question
      title: g) I push students to achieve their full academic potential...
      input:
        control: Radio
        labels:
          1: Strongly disagree
          2: Disagree
          3: Neither agree nor disagree
          4: Agree
          5: Strongly agree
  - id: b_s64_behaviour
    title: Class behaviour
    precondition:
    - predicate: not (Q1.outcome == 1)
      hint: Asked only when question 1 is not "Yes".
    items:
    - id: Q48a
      kind: Question
      title: 48. Overall, with the exception of a few individual students, the class as a whole ... a) Moves smoothly from one classroom activity to another...
      input:
        control: Radio
        labels:
          1: Never
          2: Rarely
          3: Sometimes
          4: Usually
          5: Always
    - id: Q48b
      kind: Question
      title: b) Is easily distracted by the disruptive behaviour of a few...
      input:
        control: Radio
        labels:
          1: Never
          2: Rarely
          3: Sometimes
          4: Usually
          5: Always
    - id: Q48c
      kind: Question
      title: c) Works well together on group activities...
      input:
        control: Radio
        labels:
          1: Never
          2: Rarely
          3: Sometimes
          4: Usually
          5: Always
    - id: Q48d
      kind: Question
      title: d) Misbehaves when I am called to the door or must attend to other interruptions...
      input:
        control: Radio
        labels:
          1: Never
          2: Rarely
          3: Sometimes
          4: Usually
          5: Always
  - id: b_s64_resources
    title: Adequacy of resources
    precondition:
    - predicate: not (Q1.outcome == 1)
      hint: Asked only when question 1 is not "Yes".
    items:
    - id: Q49a
      kind: Question
      title: 49. Please rate the extent to which each of the following meets the needs of your class. a) Instructional resources (e.g., curriculum documents, books)...
      input:
        control: Radio
        labels:
          1: Does not meet my needs
          2: Partially meets my needs
          3: Adequately meets my needs
          4: Completely meets my needs
          5: Not applicable
    - id: Q49b
      kind: Question
      title: b) School supplies (e.g. paper, pencils)...
      input:
        control: Radio
        labels:
          1: Does not meet my needs
          2: Partially meets my needs
          3: Adequately meets my needs
          4: Completely meets my needs
          5: Not applicable
    - id: Q49c
      kind: Question
      title: c) Space within the classroom...
      input:
        control: Radio
        labels:
          1: Does not meet my needs
          2: Partially meets my needs
          3: Adequately meets my needs
          4: Completely meets my needs
          5: Not applicable
    - id: Q49d
      kind: Question
      title: d) Computers for course instruction...
      input:
        control: Radio
        labels:
          1: Does not meet my needs
          2: Partially meets my needs
          3: Adequately meets my needs
          4: Completely meets my needs
          5: Not applicable
    - id: Q49e
      kind: Question
      title: e) Computer software for course instruction...
      input:
        control: Radio
        labels:
          1: Does not meet my needs
          2: Partially meets my needs
          3: Adequately meets my needs
          4: Completely meets my needs
          5: Not applicable
    - id: Q49f
      kind: Question
      title: f) Audio-visual resources (e.g. VCR's, film projector)...
      input:
        control: Radio
        labels:
          1: Does not meet my needs
          2: Partially meets my needs
          3: Adequately meets my needs
          4: Completely meets my needs
          5: Not applicable
    - id: Q49g
      kind: Question
      title: g) Science equipment...
      input:
        control: Radio
        labels:
          1: Does not meet my needs
          2: Partially meets my needs
          3: Adequately meets my needs
          4: Completely meets my needs
          5: Not applicable
    - id: Q49h
      kind: Question
      title: h) Equipment for mathematics instruction...
      input:
        control: Radio
        labels:
          1: Does not meet my needs
          2: Partially meets my needs
          3: Adequately meets my needs
          4: Completely meets my needs
          5: Not applicable
    - id: Q49i
      kind: Question
      title: i) Special equipment for handicapped students...
      input:
        control: Radio
        labels:
          1: Does not meet my needs
          2: Partially meets my needs
          3: Adequately meets my needs
          4: Completely meets my needs
          5: Not applicable
    - id: Q49j
      kind: Question
      title: j) Library or teacher-librarian...
      input:
        control: Radio
        labels:
          1: Does not meet my needs
          2: Partially meets my needs
          3: Adequately meets my needs
          4: Completely meets my needs
          5: Not applicable
    - id: Q49k
      kind: Question
      title: k) Other...
      input:
        control: Radio
        labels:
          1: Does not meet my needs
          2: Partially meets my needs
          3: Adequately meets my needs
          4: Completely meets my needs
          5: Not applicable
  - id: b_s65_climate
    title: SECTION 5 PERCEPTIONS OF YOUR SCHOOL
    precondition:
    - predicate: not (Q1.outcome == 1)
      hint: Asked only when question 1 is not "Yes".
    items:
    - id: Q50a
      kind: Question
      title: 50. Below are a number of statements which describe the social climate of your school. a) The administrative, support, and teaching staff work together as a team...
      input:
        control: Radio
        labels:
          1: Strongly disagree
          2: Disagree
          3: Neither agree nor disagree
          4: Agree
          5: Strongly agree
    - id: Q50b
      kind: Question
      title: b) All staff are involved in decision-making at this school...
      input:
        control: Radio
        labels:
          1: Strongly disagree
          2: Disagree
          3: Neither agree nor disagree
          4: Agree
          5: Strongly agree
    - id: Q50c
      kind: Question
      title: c) School staff know what is expected of them in terms of their roles and responsibilities...
      input:
        control: Radio
        labels:
          1: Strongly disagree
          2: Disagree
          3: Neither agree nor disagree
          4: Agree
          5: Strongly agree
    - id: Q50d
      kind: Question
      title: d) Staff clearly understand school policies and procedures...
      input:
        control: Radio
        labels:
          1: Strongly disagree
          2: Disagree
          3: Neither agree nor disagree
          4: Agree
          5: Strongly agree
    - id: Q50e
      kind: Question
      title: e) Teachers in this school have considerable influence on school policies...
      input:
        control: Radio
        labels:
          1: Strongly disagree
          2: Disagree
          3: Neither agree nor disagree
          4: Agree
          5: Strongly agree
    - id: Q50f
      kind: Question
      title: f) Teachers have a strong influence on how resources (e.g. money, staff, instructional materials) are allocated at this school...
      input:
        control: Radio
        labels:
          1: Strongly disagree
          2: Disagree
          3: Neither agree nor disagree
          4: Agree
          5: Strongly agree
    - id: Q50g
      kind: Question
      title: g) Students clearly understand school rules...
      input:
        control: Radio
        labels:
          1: Strongly disagree
          2: Disagree
          3: Neither agree nor disagree
          4: Agree
          5: Strongly agree
    - id: Q50h
      kind: Question
      title: h) The principal provides support to teachers...
      input:
        control: Radio
        labels:
          1: Strongly disagree
          2: Disagree
          3: Neither agree nor disagree
          4: Agree
          5: Strongly agree
    - id: Q50i
      kind: Question
      title: i) Teachers receive positive feed-back from the principal...
      input:
        control: Radio
        labels:
          1: Strongly disagree
          2: Disagree
          3: Neither agree nor disagree
          4: Agree
          5: Strongly agree
    - id: Q50j
      kind: Question
      title: j) The principal gets around the school to talk to staff...
      input:
        control: Radio
        labels:
          1: Strongly disagree
          2: Disagree
          3: Neither agree nor disagree
          4: Agree
          5: Strongly agree
    - id: Q50k
      kind: Question
      title: k) The principal spends time getting to know students...
      input:
        control: Radio
        labels:
          1: Strongly disagree
          2: Disagree
          3: Neither agree nor disagree
          4: Agree
          5: Strongly agree
    - id: Q50l
      kind: Question
      title: l) The school provides a positive working environment for teachers...
      input:
        control: Radio
        labels:
          1: Strongly disagree
          2: Disagree
          3: Neither agree nor disagree
          4: Agree
          5: Strongly agree
    - id: Q50m
      kind: Question
      title: m) The school provides a positive working environment for students...
      input:
        control: Radio
        labels:
          1: Strongly disagree
          2: Disagree
          3: Neither agree nor disagree
          4: Agree
          5: Strongly agree
    - id: Q51a
      kind: Question
      title: 51. Please indicate the extent to which you agree with each of these statements regarding the disciplinary policies of your school. a) Teachers in this school have reached a consensus about ways to discipline children who break rules...
      input:
        control: Radio
        labels:
          1: Strongly disagree
          2: Disagree
          3: Neither agree nor disagree
          4: Agree
          5: Strongly agree
    - id: Q51b
      kind: Question
      title: b) All children who break rules in this school face the same consequences...
      input:
        control: Radio
        labels:
          1: Strongly disagree
          2: Disagree
          3: Neither agree nor disagree
          4: Agree
          5: Strongly agree
    - id: Q51c
      kind: Question
      title: c) Teachers in this school rarely overlook physical aggression among students...
      input:
        control: Radio
        labels:
          1: Strongly disagree
          2: Disagree
          3: Neither agree nor disagree
          4: Agree
          5: Strongly agree
    - id: Q51d
      kind: Question
      title: d) Teachers in this school rarely overlook verbal aggression among students...
      input:
        control: Radio
        labels:
          1: Strongly disagree
          2: Disagree
          3: Neither agree nor disagree
          4: Agree
          5: Strongly agree
    - id: Q51e
      kind: Question
      title: e) Teachers feel there is insufficient support within the school for managing disciplinary problems...
      input:
        control: Radio
        labels:
          1: Strongly disagree
          2: Disagree
          3: Neither agree nor disagree
          4: Agree
          5: Strongly agree
  - id: b_s66_personal
    title: SECTION 6 PERSONAL INFORMATION
    precondition:
    - predicate: not (Q1.outcome == 1)
      hint: Asked only when question 1 is not "Yes".
    items:
    - id: Q52
      kind: Question
      title: 52. Are you... (Mark one circle)
      input:
        control: Radio
        labels:
          1: Female?
          2: Male?
    - id: Q53
      kind: Question
      title: 53. To which age category do you belong? (Mark one circle)
      input:
        control: Radio
        labels:
          3: 20 to 29 years
          4: 30 to 39 years
          5: 40 to 49 years
          6: 50 to 59 years
          7: 60 years or older
    - id: Q54a_years
      kind: Question
      title: '54. How much experience do you have as... (Specify the number of years and months of experience; e.g., 1 year and 5 months. Please specify 00 years and 00 months if you have no experience in a particular position) a) a teacher: years'
      input:
        control: Editbox
        min: 0
        max: 99
    - id: Q54a_months
      kind: Question
      title: 'a) a teacher: months'
      input:
        control: Editbox
        min: 0
        max: 11
    - id: Q54b_years
      kind: Question
      title: 'b) a teacher at this grade: years'
      postcondition:
      - predicate: Q54b_years.outcome <= Q54a_years.outcome
        hint: Los años de experiencia en este grado (54b) no pueden superar los años de experiencia como docente (54a).
        invented: true
      input:
        control: Editbox
        min: 0
        max: 99
    - id: Q54b_months
      kind: Question
      title: 'b) a teacher at this grade: months'
      input:
        control: Editbox
        min: 0
        max: 11
    - id: Q54c_years
      kind: Question
      title: 'c) a teacher at this school: years'
      postcondition:
      - predicate: Q54c_years.outcome <= Q54a_years.outcome
        hint: Years of experience at this school (54c) cannot exceed your years of experience as a teacher (54a).
        invented: true
      input:
        control: Editbox
        min: 0
        max: 99
    - id: Q54c_months
      kind: Question
      title: 'c) a teacher at this school: months'
      input:
        control: Editbox
        min: 0
        max: 11
    - id: Q55
      kind: Question
      title: 55. Please specify the levels of education you have attained? (Mark all that apply)
      input:
        control: Checkbox
        labels:
          1: 1 — Some coursework towards a Bachelor's degree
          2: 2 — A teaching certificate, diploma or licence
          4: 3 — A Bachelor's degree
          8: 4 — A Bachelor of Education degree
          16: 5 — Some post-baccalaureate coursework
          32: 6 — A post-baccalaureate diploma or certificate
          64: 7 — Some coursework towards a Master's degree
          128: 8 — A Master's degree
          256: 9 — Some coursework towards a Doctorate
          512: 10 — A Doctorate
          1024: 11 — Other
    - id: Q56
      kind: Question
      title: 56. Have you obtained any of the following advanced qualifications in special education? (Mark all that apply)
      postcondition:
      - predicate: not (Q56.outcome & 8 > 0 and Q56.outcome > 8)
        hint: In question 56, 'None of the above' cannot be marked together with another qualification; unmark one of them.
        invented: true
      input:
        control: Checkbox
        labels:
          1: 12 — One class in, or part of a special education programme
          2: 13 — A special education certificate
          4: 14 — A graduate degree in special education
          8: 15 — None of the above
          16: 16 — Other
    - id: Q57
      kind: Question
      title: 57. Have you obtained any of the following advanced qualifications in second language education? (Mark all that apply)
      postcondition:
      - predicate: not (Q57.outcome & 8 > 0 and Q57.outcome > 8)
        hint: In question 57, 'None of the above' cannot be marked together with another qualification; unmark one of them.
        invented: true
      input:
        control: Checkbox
        labels:
          1: 17 — One class in, or part of a second language programme
          2: 18 — A certificate in second language education
          4: 19 — A graduate degree in second language education
          8: 20 — None of the above
          16: 21 — Other
    - id: Q58
      kind: Question
      title: 58. Statistics Canada is conducting this survey jointly with another federal department, Human Resources Development Canada. The information collected will be kept confidential and used only for statistical purposes. Do you agree to share the information collected with Human Resources Development Canada?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: Q59
      kind: Question
      title: Do you have any comments about this survey? If so, please use the space below. (unnumbered in source; id is its position after Q58)
      input:
        control: Textarea
  - id: b_s67_low_grades_screen
    title: Students in grade 3 and under
    precondition:
    - predicate: not (Q1.outcome == 1)
      hint: Asked only when question 1 is not "Yes".
    items:
    - id: Q1_2
      kind: Question
      title: Are there students in your school who are enrolled in grade 3 or under? (Please include students enrolled in kindergarten/pre-grade one (junior kindergarten, primary, nursery, early childhood services, or first year of primary))? (Mark one circle only)
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: Q2_2
      kind: Question
      title: Does your school contain sufficient students enrolled in grade 3 or under to form more than one class per grade? (Please include students enrolled in kindergarten/pre-grade one classes (junior kindergarten, primary, nursery, early childhood services, or first year of primary)). (Mark one circle only)
      precondition:
      - predicate: not (Q1_2.outcome == 2)
        hint: Asked only when question 1 is not "No".
      input:
        control: Radio
        labels:
          3: 'Yes'
          4: 'No'
  - id: b_s67_low_grades_assign
    title: Assigning students to classrooms, grade 3 and under
    precondition:
    - predicate: not (Q1.outcome == 1)
      hint: Asked only when question 1 is not "Yes".
    - predicate: not (Q1_2.outcome == 2)
      hint: Asked only when question 1 is not "No".
    - predicate: not (Q2_2.outcome == 4)
      hint: Asked only when question 2 is not "No".
    items:
    - id: Q3a_2
      kind: Question
      title: 3. In general, how often do you use the following ways to assign students to classrooms for grade 3 and under. (Please include kindergarten/pre-grade 1 classes) — a) Students are grouped together more or less at random...
      input:
        control: Radio
        labels:
          1: Never
          2: Rarely
          3: Sometimes
          4: Usually
          5: Always
    - id: Q3b_2
      kind: Question
      title: 3. (grade 3 and under) — b) Students are grouped according to similar ability levels...
      input:
        control: Radio
        labels:
          6: Never
          7: Rarely
          8: Sometimes
          9: Usually
          10: Always
    - id: Q3c
      kind: Question
      title: 3. (grade 3 and under) — c) Students are grouped so that classes contain a mixture of ability levels...
      input:
        control: Radio
        labels:
          11: Never
          12: Rarely
          13: Sometimes
          14: Usually
          15: Always
    - id: Q3d
      kind: Question
      title: 3. (grade 3 and under) — d) Students are assigned according to the special expertise of teachers...
      input:
        control: Radio
        labels:
          16: Never
          17: Rarely
          18: Sometimes
          19: Usually
          20: Always
    - id: Q3e
      kind: Question
      title: 3. (grade 3 and under) — e) Assign students to classes composed of students of similar ages...
      input:
        control: Radio
        labels:
          21: Never
          22: Rarely
          23: Sometimes
          24: Usually
          25: Always
    - id: Q3f
      kind: Question
      title: 3. (grade 3 and under) — f) Groupings are based on social considerations (e.g., friendships, siblings, rivalries)...
      input:
        control: Radio
        labels:
          26: Never
          27: Rarely
          28: Sometimes
          29: Usually
          30: Always
    - id: Q3g
      kind: Question
      title: 3. (grade 3 and under) — g) Parents'/guardians' requests are considered when grouping students...
      input:
        control: Radio
        labels:
          31: Never
          32: Rarely
          33: Sometimes
          34: Usually
          35: Always
    - id: Q3h
      kind: Question
      title: 3. (grade 3 and under) — h) Consider teachers' input when grouping students...
      input:
        control: Radio
        labels:
          36: Never
          37: Rarely
          38: Sometimes
          39: Usually
          40: Always
  - id: b_s67_upper_grades
    title: Students in grade 4 and higher
    precondition:
    - predicate: not (Q1.outcome == 1)
      hint: Asked only when question 1 is not "Yes".
    items:
    - id: Q4_2
      kind: Question
      title: Are there students in your school who are enrolled in the middle and later elementary grades (grade 4 and higher)? (Mark one circle only)
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: Q5_2
      kind: Question
      title: Does your school contain sufficient students in the middle and later elementary grades (grade 4 and higher) to form more than one class per grade? (Mark one circle only)
      input:
        control: Radio
        labels:
          3: 'Yes'
          4: 'No'
    - id: Q6a
      kind: Question
      title: 6. In general, how often do you use the following ways to assign students to classrooms for the middle and later elementary grades (grade 4 and higher)? — a) Students are grouped together more or less at random...
      input:
        control: Radio
        labels:
          1: Never
          2: Rarely
          3: Sometimes
          4: Usually
          5: Always
    - id: Q6b
      kind: Question
      title: 6. (grade 4 and higher) — b) Students are grouped according to similar ability levels...
      input:
        control: Radio
        labels:
          6: Never
          7: Rarely
          8: Sometimes
          9: Usually
          10: Always
    - id: Q6c
      kind: Question
      title: 6. (grade 4 and higher) — c) Students are grouped so that classes contain a mixture of ability levels...
      input:
        control: Radio
        labels:
          11: Never
          12: Rarely
          13: Sometimes
          14: Usually
          15: Always
    - id: Q6d
      kind: Question
      title: 6. (grade 4 and higher) — d) Students are assigned according to the special expertise of teachers...
      input:
        control: Radio
        labels:
          16: Never
          17: Rarely
          18: Sometimes
          19: Usually
          20: Always
    - id: Q6e
      kind: Question
      title: 6. (grade 4 and higher) — e) Assign students to classes composed of students of similar ages...
      input:
        control: Radio
        labels:
          21: Never
          22: Rarely
          23: Sometimes
          24: Usually
          25: Always
    - id: Q6f
      kind: Question
      title: 6. (grade 4 and higher) — f) Groupings are based on social considerations (e.g., friendships, siblings, rivalries)...
      input:
        control: Radio
        labels:
          26: Never
          27: Rarely
          28: Sometimes
          29: Usually
          30: Always
    - id: Q6g
      kind: Question
      title: 6. (grade 4 and higher) — g) Parents'/guardians' requests are considered when grouping students...
      input:
        control: Radio
        labels:
          31: Never
          32: Rarely
          33: Sometimes
          34: Usually
          35: Always
    - id: Q6h
      kind: Question
      title: 6. (grade 4 and higher) — h) Consider teachers' input when grouping students...
      input:
        control: Radio
        labels:
          36: Never
          37: Rarely
          38: Sometimes
          39: Usually
          40: Always
  - id: b_s67_economic
    title: Economic background of students
    precondition:
    - predicate: not (Q1.outcome == 1)
      hint: Asked only when question 1 is not "Yes".
    items:
    - id: Q7a
      kind: Question
      title: How would you describe the economic background of the students attending your school? (Specify the percentage of families in each category) — a) High income (family income above $60,000 per year) |_|_| %
      input:
        control: Editbox
        min: 0
        max: 100
        right: '%'
    - id: Q7b
      kind: Question
      title: 7. (percentage of families) — b) Middle income (family income between $40,000 and $60,000 per year) |_|_| %
      input:
        control: Editbox
        min: 0
        max: 100
        right: '%'
    - id: Q7c
      kind: Question
      title: 7. (percentage of families) — c) Low income (family income below $40,000 per year) |_|_| %
      postcondition:
      - predicate: Q7a.outcome + Q7b.outcome + Q7c.outcome == 100
        hint: The percentages in 7a, 7b and 7c (high, middle and low income) must add up to 100%.
        invented: true
      input:
        control: Editbox
        min: 0
        max: 100
        right: '%'
  - id: b_s67_enrollment
    title: Enrollment and student characteristics
    precondition:
    - predicate: not (Q1.outcome == 1)
      hint: Asked only when question 1 is not "Yes".
    items:
    - id: Q8_2
      kind: Question
      title: As of the first day of school in January 1995, what was the total enrollment of your school? (Specify the number of students)
      input:
        control: Editbox
        min: 0
        max: 9999
        right: students
    - id: Q9a
      kind: Question
      title: 'Including those who have not been officially identified as having the following long-term problems, how many students attending your school have: (Some students may belong to more than one category) — a) A speech, hearing, vision, mobility or other health impairment that affects their learning? |_|_|_| students'
      postcondition:
      - predicate: Q9a.outcome <= Q8_2.outcome
        hint: The number of students in 9a cannot exceed the total enrollment reported in question 8.
        invented: true
      input:
        control: Editbox
        min: 0
        max: 999
        right: students
    - id: Q9b
      kind: Question
      title: 9. (long-term problems) — b) An emotional, or behavioural problem? |_|_|_| students
      postcondition:
      - predicate: Q9b.outcome <= Q8_2.outcome
        hint: The number of students in 9b cannot exceed the total enrollment reported in question 8.
        invented: true
      input:
        control: Editbox
        min: 0
        max: 999
        right: students
    - id: Q9c
      kind: Question
      title: '9. (long-term problems) — c) A learning problem (i.e.: a problem with attention, memory, reasoning, reading, writing, spelling, or calculation which interferes with learning)? |_|_|_| students'
      postcondition:
      - predicate: Q9c.outcome <= Q8_2.outcome
        hint: The number of students in 9c cannot exceed the total enrollment reported in question 8.
        invented: true
      input:
        control: Editbox
        min: 0
        max: 999
        right: students
    - id: Q10a
      kind: Question
      title: 'How many students attending your school: (Some students may belong to more than one category) — a) Have a first language other than English or French? |_|_|_| students'
      postcondition:
      - predicate: Q10a.outcome <= Q8_2.outcome
        hint: The number of students in 10a cannot exceed the total enrollment reported in question 8.
        invented: true
      input:
        control: Editbox
        min: 0
        max: 999
        right: students
    - id: Q10b
      kind: Question
      title: 10. — b) Have immigrated to Canada within the last year? |_|_|_| students
      postcondition:
      - predicate: Q10b.outcome <= Q8_2.outcome
        hint: The number of students in 10b cannot exceed the total enrollment reported in question 8.
        invented: true
      input:
        control: Editbox
        min: 0
        max: 999
        right: students
    - id: Q10c
      kind: Question
      title: 10. — c) Are from a rural or farm setting? |_|_|_| students
      postcondition:
      - predicate: Q10c.outcome <= Q8_2.outcome
        hint: The number of students in 10c cannot exceed the total enrollment reported in question 8.
        invented: true
      input:
        control: Editbox
        min: 0
        max: 999
        right: students
    - id: Q11_2
      kind: Question
      title: Excluding students registering for the first time at the start of your school year, how many students have registered as new students during the course of the school year? (Specify the number of students)
      input:
        control: Editbox
        min: 0
        max: 9999
        right: students
    - id: Q12_2
      kind: Question
      title: Excluding students who must leave your school to attend a higher grade, how many students have left this school during the course of the school year? (Specify the number of students)
      input:
        control: Editbox
        min: 0
        max: 9999
        right: students
  - id: b_s67_attendance
    title: Absenteeism and lateness
    precondition:
    - predicate: not (Q1.outcome == 1)
      hint: Asked only when question 1 is not "Yes".
    items:
    - id: Q13_2
      kind: Question
      title: What is the average absenteeism rate at your school this year? Please only include students that are absent for a full school day. (Mark one circle only)
      input:
        control: Radio
        labels:
          1: Less than 1 %
          2: 1 to 5 %
          3: 6 to 10 %
          4: 11 to 15%
          5: 16 to 20%
          6: More than 20%
          7: Don't know
    - id: Q14
      kind: Question
      title: Approximately, what percentage of students are chronically late for school? By chronically late we mean that a student is late for the start of school two or more times each week. (Mark one circle only)
      input:
        control: Radio
        labels:
          8: Less than 1 %
          9: 1 to 5 %
          10: 6 to 10 %
          11: 11 to 15%
          12: 16 to 20%
          13: More than 20%
          14: Don't know
  - id: b_s67_discipline
    title: Disciplinary problems
    precondition:
    - predicate: not (Q1.outcome == 1)
      hint: Asked only when question 1 is not "Yes".
    items:
    - id: Q15a
      kind: Question
      title: Listed below are a number of different disciplinary problems that may occur in a school. How often do you have to discipline students because of ... — a) Verbal conflicts among students...
      input:
        control: Radio
        labels:
          1: Never
          2: Rarely
          3: Sometimes
          4: Usually
          5: Always
    - id: Q15b
      kind: Question
      title: 15. — b) Physical conflicts among students...
      input:
        control: Radio
        labels:
          6: Never
          7: Rarely
          8: Sometimes
          9: Usually
          10: Always
    - id: Q15c
      kind: Question
      title: 15. — c) Vandalism of school property...
      input:
        control: Radio
        labels:
          11: Never
          12: Rarely
          13: Sometimes
          14: Usually
          15: Always
    - id: Q15d
      kind: Question
      title: 15. — d) Theft of student belongings...
      input:
        control: Radio
        labels:
          16: Never
          17: Rarely
          18: Sometimes
          19: Usually
          20: Always
    - id: Q15e
      kind: Question
      title: 15. — e) Theft of staff belongings...
      input:
        control: Radio
        labels:
          21: Never
          22: Rarely
          23: Sometimes
          24: Usually
          25: Always
    - id: Q15f
      kind: Question
      title: 15. — f) Smoking on school property...
      input:
        control: Radio
        labels:
          26: Never
          27: Rarely
          28: Sometimes
          29: Usually
          30: Always
    - id: Q15g
      kind: Question
      title: 15. — g) Use of drugs on school property...
      input:
        control: Radio
        labels:
          31: Never
          32: Rarely
          33: Sometimes
          34: Usually
          35: Always
    - id: Q15h
      kind: Question
      title: 15. — h) Verbal abuse of a staff member...
      input:
        control: Radio
        labels:
          36: Never
          37: Rarely
          38: Sometimes
          39: Usually
          40: Always
    - id: Q15i
      kind: Question
      title: 15. — i) Physical assault of a staff member...
      input:
        control: Radio
        labels:
          41: Never
          42: Rarely
          43: Sometimes
          44: Usually
          45: Always
    - id: Q15j
      kind: Question
      title: 15. — j) Harassment of certain students by groups of students...
      input:
        control: Radio
        labels:
          46: Never
          47: Rarely
          48: Sometimes
          49: Usually
          50: Always
    - id: Q15k
      kind: Question
      title: 15. — k) Conflicts among students of differing racial or ethnic backgrounds...
      input:
        control: Radio
        labels:
          51: Never
          52: Rarely
          53: Sometimes
          54: Usually
          55: Always
    - id: Q15l
      kind: Question
      title: 15. — l) Students possessing weapons (e.g., pocket knife, gun)...
      input:
        control: Radio
        labels:
          56: Never
          57: Rarely
          58: Sometimes
          59: Usually
          60: Always
  - id: b_s68_volunteering
    title: Parents'/guardians' involvement in your school
    precondition:
    - predicate: not (Q1.outcome == 1)
      hint: Asked only when question 1 is not "Yes".
    items:
    - id: Q16a
      kind: Question
      title: What proportion of parents/guardians volunteer to help with ... (Specify the proportion of parents/guardians for each category) — a) School events (e.g., sports, plays)...
      input:
        control: Radio
        labels:
          1: 1 to 5%
          2: 6 to 10%
          3: 11 to 15%
          4: 16 to 20%
          5: 21% or more
          6: Not applicable
    - id: Q16b
      kind: Question
      title: 16. — b) Fund raising activities...
      input:
        control: Radio
        labels:
          7: 1 to 5%
          8: 6 to 10%
          9: 11 to 15%
          10: 16 to 20%
          11: 21% or more
          12: Not applicable
    - id: Q16c
      kind: Question
      title: 16. — c) Field trips...
      input:
        control: Radio
        labels:
          13: 1 to 5%
          14: 6 to 10%
          15: 11 to 15%
          16: 16 to 20%
          17: 21% or more
          18: Not applicable
    - id: Q16d
      kind: Question
      title: 16. — d) Classroom activities...
      input:
        control: Radio
        labels:
          19: 1 to 5%
          20: 6 to 10%
          21: 11 to 15%
          22: 16 to 20%
          23: 21% or more
          24: Not applicable
    - id: Q16e
      kind: Question
      title: 16. — e) Supervising children (i.e., at recess or lunch time)...
      input:
        control: Radio
        labels:
          25: 1 to 5%
          26: 6 to 10%
          27: 11 to 15%
          28: 16 to 20%
          29: 21% or more
          30: Not applicable
    - id: Q16f
      kind: Question
      title: 16. — f) The parent-school association/home and school liaison committee/parent advisory committee...
      input:
        control: Radio
        labels:
          31: 1 to 5%
          32: 6 to 10%
          33: 11 to 15%
          34: 16 to 20%
          35: 21% or more
          36: Not applicable
  - id: b_s68_support
    title: Parent support and association activity
    items:
    - id: Q17
      kind: Question
      title: In your opinion, how strongly do parents/guardians support the efforts of the school's staff? (Mark one circle only)
      input:
        control: Radio
        labels:
          1: Strongly support the efforts of the school's staff
          2: Support the efforts of the school's staff
          3: Support some of the efforts of the school's staff
          4: Oppose the efforts of the school's staff
          5: Strongly oppose the efforts of the school's staff
          6: I don't know the parents/guardians well enough
    - id: Q18
      kind: Question
      title: How active is the parent-school association, home and school liaison committee, or parent advisory committee in your school? (Mark one circle only)
      input:
        control: Radio
        labels:
          7: Very active
          8: Active
          9: Somewhat active
          10: Not very active
          11: Not at all active
          12: There is no parent-school association/home and school liaison committee/parent advisory committee
    - id: Q19_2
      kind: Question
      title: How much influence does the parent-school association, home and school liaison committee, or parent advisory committee have on school policies or practices? (Mark one circle only)
      precondition:
      - predicate: not (Q18.outcome == 12)
        hint: Asked only when question 18 is not "There is no parent-school association/home and school liaison committee/parent advisory committee".
      input:
        control: Radio
        labels:
          13: A strong influence
          14: A considerable influence
          15: Some influence
          16: A little influence
          17: No influence
  - id: b_s69_school
    title: SECTION 3 CHARACTERISTICS OF YOUR SCHOOL
    items:
    - id: Q20_2
      kind: Question
      title: What is the range of grades taught in your school (e.g., Junior kindergarten to grade 8)? For schools containing junior kindergarten and kindergarten/pre-grade one classes please use "JK" to indicate junior kindergarten and "KN" to indicate kindergarten. (Specify the grades) grade |_|_| to grade |_|_|
      input:
        control: Textarea
        maxLength: 50
    - id: Q21a
      kind: Question
      title: 'How many of the following positions are staffed in your school? (Specify in full-time equivalent units: e.g., 1.0, or 1.5 full-time equivalent units. Please use 00.00 to indicate that the position is not staffed) — a) Principal... |_|_|.|_|_| full time equivalent positions'
      input:
        control: Editbox
        min: 0
        max: 9999
        right: hundredths of a full-time equivalent position (e.g., 150 = 1.50)
    - id: Q21b
      kind: Question
      title: 21. — b) Vice-principals/assistant principals... |_|_|.|_|_| full time equivalent positions
      input:
        control: Editbox
        min: 0
        max: 9999
        right: hundredths of a full-time equivalent position (e.g., 150 = 1.50)
    - id: Q21c
      kind: Question
      title: 21. — c) Classroom teachers... |_|_|.|_|_| full time equivalent positions
      input:
        control: Editbox
        min: 0
        max: 9999
        right: hundredths of a full-time equivalent position (e.g., 150 = 1.50)
    - id: Q21d
      kind: Question
      title: 21. — d) Teaching assistants/student assistants/teacher's aides... |_|_|.|_|_| full time equivalent positions
      input:
        control: Editbox
        min: 0
        max: 9999
        right: hundredths of a full-time equivalent position (e.g., 150 = 1.50)
    - id: Q21e
      kind: Question
      title: 21. — e) Librarians... |_|_|.|_|_| full time equivalent positions
      input:
        control: Editbox
        min: 0
        max: 9999
        right: hundredths of a full-time equivalent position (e.g., 150 = 1.50)
    - id: Q21f
      kind: Question
      title: 21. — f) Resource teachers (e.g. special education teachers, educational therapists, music teachers, etc.)... |_|_|.|_|_| full time equivalent positions
      input:
        control: Editbox
        min: 0
        max: 9999
        right: hundredths of a full-time equivalent position (e.g., 150 = 1.50)
    - id: Q21g
      kind: Question
      title: 21. — g) Physical educators for special needs students... |_|_|.|_|_| full time equivalent positions
      input:
        control: Editbox
        min: 0
        max: 9999
        right: hundredths of a full-time equivalent position (e.g., 150 = 1.50)
    - id: Q21h
      kind: Question
      title: 21. — h) Guidance counsellors... |_|_|.|_|_| full time equivalent positions
      input:
        control: Editbox
        min: 0
        max: 9999
        right: hundredths of a full-time equivalent position (e.g., 150 = 1.50)
    - id: Q21i
      kind: Question
      title: 21. — i) Secretaries, custodians, and other non-certified, non-teaching staff... |_|_|.|_|_| full time equivalent positions
      input:
        control: Editbox
        min: 0
        max: 9999
        right: hundredths of a full-time equivalent position (e.g., 150 = 1.50)
    - id: Q22_2
      kind: Question
      title: Including special education, physical education, and itinerant/part-time teachers, how many teachers did you have in your school on January 1, 1995? (Specify the total number of teachers)
      input:
        control: Editbox
        min: 0
        max: 999
    - id: Q23_2
      kind: Question
      title: How many teachers in your school are not assigned a specific homeroom class (e.g., librarians, music teachers, physical education teachers, etc.)? (Specify the number of teachers)
      postcondition:
      - predicate: Q23_2.outcome <= Q22_2.outcome
        hint: The number of teachers without a homeroom class (question 23) cannot exceed the total number of teachers (question 22).
        invented: true
      input:
        control: Editbox
        min: 0
        max: 999
    - id: Q24_2
      kind: Question
      title: Excluding teachers, how many other paid staff (e.g., teacher's aides/student assistants/teaching assistants) provide direct instructional assistance in students' classrooms? (Specify the number of staff. Please use 000 to indicate that there are no such staff)
      input:
        control: Editbox
        min: 0
        max: 999
    - id: Q25_2
      kind: Question
      title: How many volunteers (e.g., co-op students, parents/guardians) are working directly with students on a regular basis? (Specify the number of volunteers. If none please write "00")
      input:
        control: Editbox
        min: 0
        max: 99
    - id: Q26
      kind: Question
      title: 'How many of the teachers and teaching assistants/student assistants/teacher''s aides at your school have: (Some teachers may belong to more than one category. If none please write "0")'
      input:
        control: Editbox
        min: 0
        max: 999
  - id: b_s70_teachers
    title: Teachers
    items:
    - id: Q26a_2
      kind: Question
      title: a) A first language other than English or French?... |_|_| teachers
      input:
        control: Editbox
        min: 0
        max: 999
        right: teachers
    - id: Q26b_2
      kind: Question
      title: b) A speech, hearing, visual, mobility or other health impairment?... |_|_| teachers
      input:
        control: Editbox
        min: 0
        max: 999
        right: teachers
  - id: b_s70_services
    title: Support services
    items:
    - id: c_s70_q27_note
      kind: Comment
      title: Days used are entered in hundredths of a full-time day per week (for example, 1.50 days/week is entered as 150).
    - id: Q27a_2
      kind: Question
      title: 27. Listed below are several types of support services available to some schools. Please indicate whether the service is available to your school, and if it is, how often has the service been used in your school during a typical week.(For example, a community health nurse who spends one full day and one half day each week at your school would be recorded as 1.50 full-time days/week) a) School psychologist... Available? No / Yes
      input:
        control: Radio
        labels:
          1: 'No'
          2: 'Yes'
    - id: Q27a_days
      kind: Question
      title: a) School psychologist... Full-time days used in a typical week |_|_|.|_|_| full-time days/week
      precondition:
      - predicate: Q27a_2.outcome == 2
        hint: Asked only when question 27a is "Yes".
      input:
        control: Editbox
        min: 0
        max: 500
        right: hundredths of full-time days/week
    - id: Q27b_2
      kind: Question
      title: 27. Listed below are several types of support services available to some schools. Please indicate whether the service is available to your school, and if it is, how often has the service been used in your school during a typical week.(For example, a community health nurse who spends one full day and one half day each week at your school would be recorded as 1.50 full-time days/week) b) Psychiatrist... Available? No / Yes
      input:
        control: Radio
        labels:
          1: 'No'
          2: 'Yes'
    - id: Q27b_days
      kind: Question
      title: b) Psychiatrist... Full-time days used in a typical week |_|_|.|_|_| full-time days/week
      precondition:
      - predicate: Q27b_2.outcome == 2
        hint: Asked only when question 27b is "Yes".
      input:
        control: Editbox
        min: 0
        max: 500
        right: hundredths of full-time days/week
    - id: Q27c_2
      kind: Question
      title: 27. Listed below are several types of support services available to some schools. Please indicate whether the service is available to your school, and if it is, how often has the service been used in your school during a typical week.(For example, a community health nurse who spends one full day and one half day each week at your school would be recorded as 1.50 full-time days/week) c) Speech and language therapist... Available? No / Yes
      input:
        control: Radio
        labels:
          1: 'No'
          2: 'Yes'
    - id: Q27c_days
      kind: Question
      title: c) Speech and language therapist... Full-time days used in a typical week |_|_|.|_|_| full-time days/week
      precondition:
      - predicate: Q27c_2.outcome == 2
        hint: Asked only when question 27c is "Yes".
      input:
        control: Editbox
        min: 0
        max: 500
        right: hundredths of full-time days/week
    - id: Q27d_2
      kind: Question
      title: 27. Listed below are several types of support services available to some schools. Please indicate whether the service is available to your school, and if it is, how often has the service been used in your school during a typical week.(For example, a community health nurse who spends one full day and one half day each week at your school would be recorded as 1.50 full-time days/week) d) Audiologist... Available? No / Yes
      input:
        control: Radio
        labels:
          1: 'No'
          2: 'Yes'
    - id: Q27d_days
      kind: Question
      title: d) Audiologist... Full-time days used in a typical week |_|_|.|_|_| full-time days/week
      precondition:
      - predicate: Q27d_2.outcome == 2
        hint: Asked only when question 27d is "Yes".
      input:
        control: Editbox
        min: 0
        max: 500
        right: hundredths of full-time days/week
    - id: Q27e_2
      kind: Question
      title: 27. Listed below are several types of support services available to some schools. Please indicate whether the service is available to your school, and if it is, how often has the service been used in your school during a typical week.(For example, a community health nurse who spends one full day and one half day each week at your school would be recorded as 1.50 full-time days/week) e) Occupational therapist... Available? No / Yes
      input:
        control: Radio
        labels:
          1: 'No'
          2: 'Yes'
    - id: Q27e_days
      kind: Question
      title: e) Occupational therapist... Full-time days used in a typical week |_|_|.|_|_| full-time days/week
      precondition:
      - predicate: Q27e_2.outcome == 2
        hint: Asked only when question 27e is "Yes".
      input:
        control: Editbox
        min: 0
        max: 500
        right: hundredths of full-time days/week
    - id: Q27f_2
      kind: Question
      title: 27. Listed below are several types of support services available to some schools. Please indicate whether the service is available to your school, and if it is, how often has the service been used in your school during a typical week.(For example, a community health nurse who spends one full day and one half day each week at your school would be recorded as 1.50 full-time days/week) f) Physical therapist... Available? No / Yes
      input:
        control: Radio
        labels:
          1: 'No'
          2: 'Yes'
    - id: Q27f_days
      kind: Question
      title: f) Physical therapist... Full-time days used in a typical week |_|_|.|_|_| full-time days/week
      precondition:
      - predicate: Q27f_2.outcome == 2
        hint: Asked only when question 27f is "Yes".
      input:
        control: Editbox
        min: 0
        max: 500
        right: hundredths of full-time days/week
    - id: Q27g_2
      kind: Question
      title: 27. Listed below are several types of support services available to some schools. Please indicate whether the service is available to your school, and if it is, how often has the service been used in your school during a typical week.(For example, a community health nurse who spends one full day and one half day each week at your school would be recorded as 1.50 full-time days/week) g) Social worker... Available? No / Yes
      input:
        control: Radio
        labels:
          1: 'No'
          2: 'Yes'
    - id: Q27g_days
      kind: Question
      title: g) Social worker... Full-time days used in a typical week |_|_|.|_|_| full-time days/week
      precondition:
      - predicate: Q27g_2.outcome == 2
        hint: Asked only when question 27g is "Yes".
      input:
        control: Editbox
        min: 0
        max: 500
        right: hundredths of full-time days/week
    - id: Q27h_2
      kind: Question
      title: 27. Listed below are several types of support services available to some schools. Please indicate whether the service is available to your school, and if it is, how often has the service been used in your school during a typical week.(For example, a community health nurse who spends one full day and one half day each week at your school would be recorded as 1.50 full-time days/week) h) Community health nurse... Available? No / Yes
      input:
        control: Radio
        labels:
          1: 'No'
          2: 'Yes'
    - id: Q27h_days
      kind: Question
      title: h) Community health nurse... Full-time days used in a typical week |_|_|.|_|_| full-time days/week
      precondition:
      - predicate: Q27h_2.outcome == 2
        hint: Asked only when question 27h is "Yes".
      input:
        control: Editbox
        min: 0
        max: 500
        right: hundredths of full-time days/week
    - id: Q27i_2
      kind: Question
      title: 27. Listed below are several types of support services available to some schools. Please indicate whether the service is available to your school, and if it is, how often has the service been used in your school during a typical week.(For example, a community health nurse who spends one full day and one half day each week at your school would be recorded as 1.50 full-time days/week) i) Instructor in Aboriginal Peoples’ culture... Available? No / Yes
      input:
        control: Radio
        labels:
          1: 'No'
          2: 'Yes'
    - id: Q27i_days
      kind: Question
      title: i) Instructor in Aboriginal Peoples’ culture... Full-time days used in a typical week |_|_|.|_|_| full-time days/week
      precondition:
      - predicate: Q27i_2.outcome == 2
        hint: Asked only when question 27i is "Yes".
      input:
        control: Editbox
        min: 0
        max: 500
        right: hundredths of full-time days/week
    - id: Q27j_2
      kind: Question
      title: 27. Listed below are several types of support services available to some schools. Please indicate whether the service is available to your school, and if it is, how often has the service been used in your school during a typical week.(For example, a community health nurse who spends one full day and one half day each week at your school would be recorded as 1.50 full-time days/week) j) Instructor in culture awareness... Available? No / Yes
      input:
        control: Radio
        labels:
          1: 'No'
          2: 'Yes'
    - id: Q27j_days
      kind: Question
      title: j) Instructor in culture awareness... Full-time days used in a typical week |_|_|.|_|_| full-time days/week
      precondition:
      - predicate: Q27j_2.outcome == 2
        hint: Asked only when question 27j is "Yes".
      input:
        control: Editbox
        min: 0
        max: 500
        right: hundredths of full-time days/week
    - id: Q27k_2
      kind: Question
      title: 27. Listed below are several types of support services available to some schools. Please indicate whether the service is available to your school, and if it is, how often has the service been used in your school during a typical week.(For example, a community health nurse who spends one full day and one half day each week at your school would be recorded as 1.50 full-time days/week) k) Police officer... Available? No / Yes
      input:
        control: Radio
        labels:
          1: 'No'
          2: 'Yes'
    - id: Q27k_days
      kind: Question
      title: k) Police officer... Full-time days used in a typical week |_|_|.|_|_| full-time days/week
      precondition:
      - predicate: Q27k_2.outcome == 2
        hint: Asked only when question 27k is "Yes".
      input:
        control: Editbox
        min: 0
        max: 500
        right: hundredths of full-time days/week
    - id: Q27l_2
      kind: Question
      title: 27. Listed below are several types of support services available to some schools. Please indicate whether the service is available to your school, and if it is, how often has the service been used in your school during a typical week.(For example, a community health nurse who spends one full day and one half day each week at your school would be recorded as 1.50 full-time days/week) l) Other (Specify) _____________________ Available? No / Yes
      input:
        control: Radio
        labels:
          1: 'No'
          2: 'Yes'
    - id: Q27l_specify
      kind: Question
      title: l) Other (Specify) _____________________
      input:
        control: Textarea
    - id: Q27l_days
      kind: Question
      title: l) Other (Specify)... Full-time days used in a typical week |_|_|.|_|_| full-time days/week
      precondition:
      - predicate: Q27l_2.outcome == 2
        hint: Asked only when question 27l is "Yes".
      input:
        control: Editbox
        min: 0
        max: 500
        right: hundredths of full-time days/week
  - id: b_s70_resources
    title: School resources
    items:
    - id: Q28a_2
      kind: Question
      title: 28. Below are a number of different resources which may be available to your school. Please rate the extent to which each attribute currently meets the needs of your school. (Mark the circle corresponding to your answer for each of the following) a) Instructional resources (e.g., curriculum documents, books)...
      input:
        control: Radio
        labels:
          1: Does not meet my school’s needs
          2: Partially meets my school’s needs
          3: Adequately meets my school’s needs
          4: Completely meets my school’s needs
          5: Not applicable
    - id: Q28b_2
      kind: Question
      title: 28. Below are a number of different resources which may be available to your school. Please rate the extent to which each attribute currently meets the needs of your school. (Mark the circle corresponding to your answer for each of the following) b) School supplies (e.g. paper, pencils)...
      input:
        control: Radio
        labels:
          6: Does not meet my school’s needs
          7: Partially meets my school’s needs
          8: Adequately meets my school’s needs
          9: Completely meets my school’s needs
          10: Not applicable
    - id: Q28c_2
      kind: Question
      title: 28. Below are a number of different resources which may be available to your school. Please rate the extent to which each attribute currently meets the needs of your school. (Mark the circle corresponding to your answer for each of the following) c) Instructional space (e.g., classroom size)...
      input:
        control: Radio
        labels:
          11: Does not meet my school’s needs
          12: Partially meets my school’s needs
          13: Adequately meets my school’s needs
          14: Completely meets my school’s needs
          15: Not applicable
    - id: Q28d
      kind: Question
      title: 28. Below are a number of different resources which may be available to your school. Please rate the extent to which each attribute currently meets the needs of your school. (Mark the circle corresponding to your answer for each of the following) d) Computers for course instruction...
      input:
        control: Radio
        labels:
          16: Does not meet my school’s needs
          17: Partially meets my school’s needs
          18: Adequately meets my school’s needs
          19: Completely meets my school’s needs
          20: Not applicable
    - id: Q28e
      kind: Question
      title: 28. Below are a number of different resources which may be available to your school. Please rate the extent to which each attribute currently meets the needs of your school. (Mark the circle corresponding to your answer for each of the following) e) Computer software for course instruction...
      input:
        control: Radio
        labels:
          21: Does not meet my school’s needs
          22: Partially meets my school’s needs
          23: Adequately meets my school’s needs
          24: Completely meets my school’s needs
          25: Not applicable
    - id: Q28f
      kind: Question
      title: 28. Below are a number of different resources which may be available to your school. Please rate the extent to which each attribute currently meets the needs of your school. (Mark the circle corresponding to your answer for each of the following) f) Library materials...
      input:
        control: Radio
        labels:
          26: Does not meet my school’s needs
          27: Partially meets my school’s needs
          28: Adequately meets my school’s needs
          29: Completely meets my school’s needs
          30: Not applicable
    - id: Q28g
      kind: Question
      title: 28. Below are a number of different resources which may be available to your school. Please rate the extent to which each attribute currently meets the needs of your school. (Mark the circle corresponding to your answer for each of the following) g) Audio-visual resources (e.g. VCR’s, film projector)...
      input:
        control: Radio
        labels:
          31: Does not meet my school’s needs
          32: Partially meets my school’s needs
          33: Adequately meets my school’s needs
          34: Completely meets my school’s needs
          35: Not applicable
    - id: Q28h
      kind: Question
      title: 28. Below are a number of different resources which may be available to your school. Please rate the extent to which each attribute currently meets the needs of your school. (Mark the circle corresponding to your answer for each of the following) h) School buildings...
      input:
        control: Radio
        labels:
          36: Does not meet my school’s needs
          37: Partially meets my school’s needs
          38: Adequately meets my school’s needs
          39: Completely meets my school’s needs
          40: Not applicable
    - id: Q28i
      kind: Question
      title: 28. Below are a number of different resources which may be available to your school. Please rate the extent to which each attribute currently meets the needs of your school. (Mark the circle corresponding to your answer for each of the following) i) School grounds...
      input:
        control: Radio
        labels:
          41: Does not meet my school’s needs
          42: Partially meets my school’s needs
          43: Adequately meets my school’s needs
          44: Completely meets my school’s needs
          45: Not applicable
    - id: Q28j
      kind: Question
      title: 28. Below are a number of different resources which may be available to your school. Please rate the extent to which each attribute currently meets the needs of your school. (Mark the circle corresponding to your answer for each of the following) j) Heating and lighting...
      input:
        control: Radio
        labels:
          46: Does not meet my school’s needs
          47: Partially meets my school’s needs
          48: Adequately meets my school’s needs
          49: Completely meets my school’s needs
          50: Not applicable
    - id: Q28k
      kind: Question
      title: 28. Below are a number of different resources which may be available to your school. Please rate the extent to which each attribute currently meets the needs of your school. (Mark the circle corresponding to your answer for each of the following) k) Science equipment...
      input:
        control: Radio
        labels:
          51: Does not meet my school’s needs
          52: Partially meets my school’s needs
          53: Adequately meets my school’s needs
          54: Completely meets my school’s needs
          55: Not applicable
    - id: Q28l
      kind: Question
      title: 28. Below are a number of different resources which may be available to your school. Please rate the extent to which each attribute currently meets the needs of your school. (Mark the circle corresponding to your answer for each of the following) l) Equipment for mathematics instruction (e.g., counting blocks, calculators)...
      input:
        control: Radio
        labels:
          56: Does not meet my school’s needs
          57: Partially meets my school’s needs
          58: Adequately meets my school’s needs
          59: Completely meets my school’s needs
          60: Not applicable
    - id: Q28m
      kind: Question
      title: 28. Below are a number of different resources which may be available to your school. Please rate the extent to which each attribute currently meets the needs of your school. (Mark the circle corresponding to your answer for each of the following) m) Budget for consumables...
      input:
        control: Radio
        labels:
          61: Does not meet my school’s needs
          62: Partially meets my school’s needs
          63: Adequately meets my school’s needs
          64: Completely meets my school’s needs
          65: Not applicable
    - id: Q28n
      kind: Question
      title: 28. Below are a number of different resources which may be available to your school. Please rate the extent to which each attribute currently meets the needs of your school. (Mark the circle corresponding to your answer for each of the following) n) Special equipment for handicapped students...
      input:
        control: Radio
        labels:
          66: Does not meet my school’s needs
          67: Partially meets my school’s needs
          68: Adequately meets my school’s needs
          69: Completely meets my school’s needs
          70: Not applicable
    - id: Q28o
      kind: Question
      title: 28. Below are a number of different resources which may be available to your school. Please rate the extent to which each attribute currently meets the needs of your school. (Mark the circle corresponding to your answer for each of the following) o) Gymnasium...
      input:
        control: Radio
        labels:
          71: Does not meet my school’s needs
          72: Partially meets my school’s needs
          73: Adequately meets my school’s needs
          74: Completely meets my school’s needs
          75: Not applicable
    - id: Q28p
      kind: Question
      title: 28. Below are a number of different resources which may be available to your school. Please rate the extent to which each attribute currently meets the needs of your school. (Mark the circle corresponding to your answer for each of the following) p) Gym equipment (e.g., mats, balls)...
      input:
        control: Radio
        labels:
          76: Does not meet my school’s needs
          77: Partially meets my school’s needs
          78: Adequately meets my school’s needs
          79: Completely meets my school’s needs
          80: Not applicable
    - id: Q28q
      kind: Question
      title: 28. Below are a number of different resources which may be available to your school. Please rate the extent to which each attribute currently meets the needs of your school. (Mark the circle corresponding to your answer for each of the following) q) Outdoor play equipment...
      input:
        control: Radio
        labels:
          81: Does not meet my school’s needs
          82: Partially meets my school’s needs
          83: Adequately meets my school’s needs
          84: Completely meets my school’s needs
          85: Not applicable
    - id: Q28r
      kind: Question
      title: 28. Below are a number of different resources which may be available to your school. Please rate the extent to which each attribute currently meets the needs of your school. (Mark the circle corresponding to your answer for each of the following) r) Other (Specify) _______________
      input:
        control: Radio
        labels:
          86: Does not meet my school’s needs
          87: Partially meets my school’s needs
          88: Adequately meets my school’s needs
          89: Completely meets my school’s needs
          90: Not applicable
    - id: Q28r_specify
      kind: Question
      title: r) Other (Specify) _______________
      input:
        control: Textarea
  - id: b_s71_perceptions
    title: SECTION 4 PERCEPTIONS OF YOUR SCHOOL
    items:
    - id: Q29a
      kind: Question
      title: 29. Below are a number of statements which describe different aspects of schooling. Please indicate how strongly you agree or disagree with each of the following statements. (Mark the circle corresponding to your answer for each of the following) a) I find my professional role satisfying...
      input:
        control: Radio
        labels:
          1: Strongly disagree
          2: Disagree
          3: Neither agree nor disagree
          4: Agree
          5: Strongly agree
    - id: Q29b
      kind: Question
      title: 29. Below are a number of statements which describe different aspects of schooling. Please indicate how strongly you agree or disagree with each of the following statements. (Mark the circle corresponding to your answer for each of the following) b) If I had to do it again, I would remain a teacher rather than become a principal...
      input:
        control: Radio
        labels:
          6: Strongly disagree
          7: Disagree
          8: Neither agree nor disagree
          9: Agree
          10: Strongly agree
    - id: Q29c
      kind: Question
      title: 29. Below are a number of statements which describe different aspects of schooling. Please indicate how strongly you agree or disagree with each of the following statements. (Mark the circle corresponding to your answer for each of the following) c) I feel good about continuing my career in this school district...
      input:
        control: Radio
        labels:
          11: Strongly disagree
          12: Disagree
          13: Neither agree nor disagree
          14: Agree
          15: Strongly agree
    - id: Q29d
      kind: Question
      title: 29. Below are a number of statements which describe different aspects of schooling. Please indicate how strongly you agree or disagree with each of the following statements. (Mark the circle corresponding to your answer for each of the following) d) I feel competent to deal with students’ behavioural problems...
      input:
        control: Radio
        labels:
          16: Strongly disagree
          17: Disagree
          18: Neither agree nor disagree
          19: Agree
          20: Strongly agree
    - id: Q29e
      kind: Question
      title: 29. Below are a number of statements which describe different aspects of schooling. Please indicate how strongly you agree or disagree with each of the following statements. (Mark the circle corresponding to your answer for each of the following) e) I have a considerable influence on my school’s policies...
      input:
        control: Radio
        labels:
          21: Strongly disagree
          22: Disagree
          23: Neither agree nor disagree
          24: Agree
          25: Strongly agree
    - id: Q29f
      kind: Question
      title: 29. Below are a number of statements which describe different aspects of schooling. Please indicate how strongly you agree or disagree with each of the following statements. (Mark the circle corresponding to your answer for each of the following) f) I have little influence on how money is allocated for school resources...
      input:
        control: Radio
        labels:
          26: Strongly disagree
          27: Disagree
          28: Neither agree nor disagree
          29: Agree
          30: Strongly agree
    - id: Q29g
      kind: Question
      title: 29. Below are a number of statements which describe different aspects of schooling. Please indicate how strongly you agree or disagree with each of the following statements. (Mark the circle corresponding to your answer for each of the following) g) The emphasis in my school is on the development of academic skills...
      input:
        control: Radio
        labels:
          31: Strongly disagree
          32: Disagree
          33: Neither agree nor disagree
          34: Agree
          35: Strongly agree
    - id: Q29h
      kind: Question
      title: 29. Below are a number of statements which describe different aspects of schooling. Please indicate how strongly you agree or disagree with each of the following statements. (Mark the circle corresponding to your answer for each of the following) h) I have high expectations for the academic success of students attending this school...
      input:
        control: Radio
        labels:
          36: Strongly disagree
          37: Disagree
          38: Neither agree nor disagree
          39: Agree
          40: Strongly agree
    - id: Q29i
      kind: Question
      title: 29. Below are a number of statements which describe different aspects of schooling. Please indicate how strongly you agree or disagree with each of the following statements. (Mark the circle corresponding to your answer for each of the following) i) I try to ensure that students are pushed to achieve their full academic potential...
      input:
        control: Radio
        labels:
          41: Strongly disagree
          42: Disagree
          43: Neither agree nor disagree
          44: Agree
          45: Strongly agree
    - id: Q29j
      kind: Question
      title: 29. Below are a number of statements which describe different aspects of schooling. Please indicate how strongly you agree or disagree with each of the following statements. (Mark the circle corresponding to your answer for each of the following) j) I feel students’ success at school is determined mainly by their home environments...
      input:
        control: Radio
        labels:
          46: Strongly disagree
          47: Disagree
          48: Neither agree nor disagree
          49: Agree
          50: Strongly agree
  - id: b_s72_demographics
    title: Personal Information
    items:
    - id: Q30_2
      kind: Question
      title: 30. Are you... (Mark one circle)
      input:
        control: Radio
        labels:
          1: Female?
          2: Male?
    - id: Q31_2
      kind: Question
      title: 31. To which age category do you belong? (Mark one circle)
      input:
        control: Radio
        labels:
          3: 20 to 29 years
          4: 30 to 39 years
          5: 40 to 49 years
          6: 50 to 59 years
          7: 60 years or older
  - id: b_s72_experience
    title: Experience
    items:
    - id: Q32_intro
      kind: Comment
      title: 32. How much experience do you have as... (Specify the number of years and months of experience; e.g., 1 year and 5 months. Please specify 00 years and 00 months if you have no experience in a particular position)
    - id: Q32a
      kind: Question
      title: '32. How much experience do you have as... (Specify the number of years and months of experience; e.g., 1 year and 5 months. Please specify 00 years and 00 months if you have no experience in a particular position) a) a principal: |_|_| years'
      input:
        control: Editbox
        min: 0
        max: 60
        right: years
    - id: Q32a_months
      kind: Question
      title: 'a) a principal: and |_|_| months'
      input:
        control: Editbox
        min: 0
        max: 11
        right: months
    - id: Q32b
      kind: Question
      title: '32. How much experience do you have as... b) a principal at this school: |_|_| years'
      input:
        control: Editbox
        min: 0
        max: 60
        right: years
    - id: Q32b_months
      kind: Question
      title: 'b) a principal at this school: and |_|_| months'
      postcondition:
      - predicate: Q32b.outcome * 12 + Q32b_months.outcome <= Q32a.outcome * 12 + Q32a_months.outcome
        hint: Experience as a principal at this school (32b) cannot exceed your total experience as a principal (32a).
        invented: true
      input:
        control: Editbox
        min: 0
        max: 11
        right: months
    - id: Q32c
      kind: Question
      title: '32. How much experience do you have as... c) a vice-principal: |_|_| years'
      input:
        control: Editbox
        min: 0
        max: 60
        right: years
    - id: Q32c_months
      kind: Question
      title: 'c) a vice-principal: and |_|_| months'
      input:
        control: Editbox
        min: 0
        max: 11
        right: months
    - id: Q32d
      kind: Question
      title: '32. How much experience do you have as... d) a vice-principal at this school: |_|_| years'
      input:
        control: Editbox
        min: 0
        max: 60
        right: years
    - id: Q32d_months
      kind: Question
      title: 'd) a vice-principal at this school: and |_|_| months'
      postcondition:
      - predicate: Q32d.outcome * 12 + Q32d_months.outcome <= Q32c.outcome * 12 + Q32c_months.outcome
        hint: Experience as a vice-principal at this school (32d) cannot exceed your total experience as a vice-principal (32c).
        invented: true
      input:
        control: Editbox
        min: 0
        max: 11
        right: months
    - id: Q32e
      kind: Question
      title: '32. How much experience do you have as... e) a teacher: |_|_| years'
      input:
        control: Editbox
        min: 0
        max: 60
        right: years
    - id: Q32e_months
      kind: Question
      title: 'e) a teacher: and |_|_| months'
      input:
        control: Editbox
        min: 0
        max: 11
        right: months
    - id: Q32f
      kind: Question
      title: '32. How much experience do you have as... f) a teacher at this school: |_|_| years'
      input:
        control: Editbox
        min: 0
        max: 60
        right: years
    - id: Q32f_months
      kind: Question
      title: 'f) a teacher at this school: and |_|_| months'
      postcondition:
      - predicate: Q32f.outcome * 12 + Q32f_months.outcome <= Q32e.outcome * 12 + Q32e_months.outcome
        hint: Experience as a teacher at this school (32f) cannot exceed your total experience as a teacher (32e).
        invented: true
      input:
        control: Editbox
        min: 0
        max: 11
        right: months
  - id: b_s72_education
    title: Education
    items:
    - id: Q33_2
      kind: Question
      title: 33. Please specify the levels of education you have attained. (Mark all that apply)
      input:
        control: Checkbox
        labels:
          1: 1 — Some coursework towards a Bachelor’s degree
          2: 2 — A teaching certificate, diploma or licence
          4: 3 — A Bachelor’s degree
          8: 4 — A Bachelor of Education degree
          16: 5 — Some post-baccalaureate coursework
          32: 6 — A post-baccalaureate diploma or certificate
          64: 7 — Some coursework towards a Master’s degree
          128: 8 — A Master’s degree
          256: 9 — Some coursework towards a Doctorate
          512: 10 — A Doctorate
          1024: 11 — Other (Specify)
    - id: Q33_other
      kind: Question
      title: Other (Specify) ______________________________________________
      precondition:
      - predicate: Q33_2.outcome & 1024 > 0
        hint: Asked only when 'Other' is marked in question 33
      input:
        control: Textarea
        maxLength: 200
  - id: b_s72_consent
    title: Consent and Comments
    items:
    - id: Q34
      kind: Question
      title: 34. Statistics Canada is conducting this survey jointly with another federal department, Human Resources Development Canada. The information collected will be kept confidential and used only for statistical purposes. Do you agree to share the information collected with Human Resources Development Canada?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: Q35
      kind: Question
      title: Do you have any comments about this survey? If so, please use the space below.
      input:
        control: Textarea
        maxLength: 2000
  - id: b_s73_preamble
    title: 'NPHS questions: setup'
    items:
    - id: AGE_7
      kind: Question
      title: Age of the person the questions are about (from the household record; read by UTIL-C9)
      external: true
      input:
        control: Editbox
        min: 0
        max: 120
  - id: b_s73_household
    title: Household
    items:
    - id: HHLD_Q4
      kind: Question
      title: Is there a pet in this household?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
    - id: HHLD_Q5
      kind: Question
      title: What kind of pet? (Do not read list. Mark all that apply.)
      input:
        control: Checkbox
        labels:
          1: DOG
          2: CAT
          4: OTHER
    - id: HHLD_Q5a
      kind: Question
      title: Does this pet or do any of these pets live mainly indoors?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
  - id: b_s73_twoweek
    title: Two-week disability days and regular doctor
    items:
    - id: TWOWK_Q1
      kind: Question
      title: It is important for you to refer to the 14-day periodfrom (2 weeks ago) to (YESTERDAY). During that period, did ... stay in bed at all because of illness or injury including any nights spent as a patient in a hospital?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
    - id: TWOWK_Q2
      kind: Question
      title: How many days did ... stay in bed for all or most of the day? ___ DAYS (ENTER <0> IF LESS THAN A DAY.)
      precondition:
      - predicate: not (TWOWK_Q1.outcome == 2)
        hint: Asked only when question TWOWK-Q1 is not "NO".
      input:
        control: Editbox
        min: 0
        max: 14
        right: days
    - id: TWOWK_Q3
      kind: Question
      title: (Not counting days spent in bed) During those 14 days, were there any days that ... cut down on things you/he/she normally do/does because of illness or injury?
      precondition:
      - predicate: not (TWOWK_Q2.outcome == 14)
        hint: Asked only when question TWOWK-Q2 is not 14.
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
    - id: TWOWK_Q4
      kind: Question
      title: How many days did ... cut down on things for all or most of the day? ___ DAYS (ENTER <0> IF LESS THAN A DAY.)
      precondition:
      - predicate: not (TWOWK_Q2.outcome == 14)
        hint: Asked only when question TWOWK-Q2 is not 14.
      - predicate: not (TWOWK_Q3.outcome == 2)
        hint: Asked only when question TWOWK-Q3 is not "NO".
      postcondition:
      - predicate: TWOWK_Q2.outcome + TWOWK_Q4.outcome <= 14
        hint: Los días en cama (TWOWK-Q2) más los días con actividades reducidas (TWOWK-Q4) no pueden superar los 14 días del período.
        invented: true
      input:
        control: Editbox
        min: 0
        max: 14
        right: days
    - id: TWOWK_Q5
      kind: Question
      title: Do(es) ... have a regular medical doctor?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
  - id: b_s73_utilization
    title: Health care utilization
    items:
    - id: UTIL_Q1
      kind: Question
      title: In the past 12 months, have/has ... been a patient overnight in a hospital, nursing home or convalescent home?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
    - id: UTIL_Q1a
      kind: Question
      title: For how many nights in the past 12 months? ___ NIGHTS
      precondition:
      - predicate: not (UTIL_Q1.outcome == 2)
        hint: Asked only when question UTIL-Q1 is not "NO".
      input:
        control: Editbox
        min: 0
        max: 366
        right: nights
    - id: UTIL_Q2
      kind: Question
      title: '(Not counting when ... were/was an overnight patient) In the past 12 months, have/has ... seen or talked on the telephone with [fill category] about your/his/her physical, emotional or mental health: a) General practitioner or family physician b) Eye specialist (such as an ophthalmologist or optometrist) c) Other medical doctor (such as surgeon, allergist, gynaecologist, psychiatrist, etc.) d) A nurse for care or advice e) Dentist or orthodontist f) Chiropractor g) Physiotherapist h) Social worker or counsellor i) Psychologist j) Speech, audiology or occupational therapist'
      input:
        control: Checkbox
        labels:
          1: a) General practitioner or family physician
          2: b) Eye specialist (such as an ophthalmologist or optometrist)
          4: c) Other medical doctor (such as surgeon, allergist, gynaecologist, psychiatrist, etc.)
          8: d) A nurse for care or advice
          16: e) Dentist or orthodontist
          32: f) Chiropractor
          64: g) Physiotherapist
          128: h) Social worker or counsellor
          256: i) Psychologist
          512: j) Speech, audiology or occupational therapist
    - id: UTIL_Q3
      kind: Question
      title: Where did the most recent contact take place? (READ LIST. MARK ONE ONLY.)
      precondition:
      - predicate: UTIL_Q2.outcome & 1 > 0 or UTIL_Q2.outcome & 4 > 0 or UTIL_Q2.outcome & 8 > 0
      input:
        control: Dropdown
        labels:
          1: Walk-in clinic
          2: Outpatient clinic in hospital
          3: Hospital emergency room
          4: Health professional's office
          5: Community health centre /clsc
          6: At home
          7: Telephone consultation only
          8: Other (specify_________________________)
    - id: UTIL_Q4
      kind: Question
      title: People may also use alternative health care services. In the past 12 months, have/has ... seen or talked to an alternative health care provider such as an acupuncturist, naturopath, homeopath or massage therapist about your/his/her physical, emotional or mental health?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
    - id: UTIL_Q5
      kind: Question
      title: Who did ... see or talk to? (DO NOT READ LIST. MARK ALL THAT APPLY.)
      precondition:
      - predicate: not (UTIL_Q4.outcome == 2)
        hint: Asked only when question UTIL-Q4 is not "NO".
      input:
        control: Checkbox
        labels:
          1: MASSAGE THERAPIST
          2: ACUPUNCTURIST
          4: HOMEOPATH OR NATUROPATH
          8: FELDENKRAIS OR ALEXANDER TEACHER
          16: RELAXATION THERAPIST
          32: BIOFEEDBACK TEACHER
          64: ROLFER
          128: HERBALIST
          256: REFLEXOLOGIST
          512: SPIRITUAL HEALER
          1024: RELIGIOUS HEALER
          2048: SELF HELP GROUP (SUCH AS AA, CANCER THERAPY, ETC.)
          4096: OTHER (SPECIFY _____________________)
    - id: UTIL_Q6
      kind: Question
      title: During the past 12 months, was there ever a time when you/he/she needed health care or advice but did not receive it?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
    - id: UTIL_Q7
      kind: Question
      title: Thinking of the most recent time, why did ... not get care?
      input:
        control: Textarea
    - id: UTIL_Q8
      kind: Question
      title: 'Again, thinking of the most recent time, what was the type of care that was needed? Was it for: (DO NOT READ LIST. MARK ALL THAT APPLY.)'
      input:
        control: Checkbox
        labels:
          1: TREATMENT OF A PHYSICAL HEALTH PROBLEM
          2: TREATMENT OF AN EMOTIONAL OR MENTAL HEALTH PROBLEM
          4: A REGULAR CHECK-UP (OR FOR REGULAR PRE-NATAL CARE)
          8: CARE OF AN INJURY
          16: ANY OTHER REASON (SPECIFY______________)
    - id: UTIL_Q9
      kind: Question
      title: 'Home care services are health care or homemaker services received at home, with the cost being entirely or partially covered by government. Examples are: nursing care; help with bathing; help around the home; physiotherapy; counselling; and meal delivery. Have/Has ... received any home care services in the past 12 months?'
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
    - id: UTIL_Q10
      kind: Question
      title: What type of services have/has ... received? (Specify______________________)
      input:
        control: Textarea
  - id: b_s74_preamble
    title: Administrative information setup
    items:
    - id: COLLECTION_PERIOD
      kind: Question
      title: 'Collection period of the interview (external): KCON-Q1A is asked when both NPHS and NLSC data are collected (November 1994 and March 1995); KCON-Q1B when only NLSC data are collected (December 1994 and February 1995)'
      external: true
      input:
        control: Radio
        labels:
          1: NPHS and NLSC both collected (November 1994 and March 1995)
          2: NLSC only collected (December 1994 and February 1995)
    - id: IN_SCHOOL
      kind: Question
      title: Whether the selected child attended school in the past 12 months / is in school (from earlier in the interview; read by TCH-C1)
      external: true
      input:
        control: Radio
        labels:
          1: IN SCHOOL
          2: NOT IN SCHOOL
    - id: GRADE
      kind: Question
      title: Grade of the selected child (from earlier in the interview; read by TCH-C2)
      external: true
      input:
        control: Editbox
        min: 0
        max: 13
  - id: b_s74_data_sharing
    title: Data-sharing agreement
    items:
    - id: KCON_Q1A
      kind: Question
      title: To avoid duplication, Statistics Canada intends to share the information from this survey with provincial ministries of health, Health Canada and Human Resources Development Canada. These organizations have undertaken to keep this information confidential and use it only for statistical purposes. Do you agree to share the information you have provided, including any that may be provided by your child(ren)?
      precondition:
      - predicate: COLLECTION_PERIOD.outcome == 1
        hint: Asked only when question COLLECTION_PERIOD is "NPHS and NLSC both collected (November 1994 and March 1995)".
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: KCON_Q1B
      kind: Question
      title: Statistics Canada is conducting this survey jointly with another federal department, Human Resources Development Canada. The information collected will be kept confidential and used only for statistical purposes. Do you agree to share the information collected, including any that may be provided by your child(ren), with Human Resources Development Canada?
      precondition:
      - predicate: COLLECTION_PERIOD.outcome == 2
        hint: Asked only when question COLLECTION_PERIOD is "NLSC only collected (December 1994 and February 1995)".
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s74_contact_1
    title: Alternate contact
    items:
    - id: KCON_Q2A
      kind: Question
      title: 'I want to emphasize that Statistics Canada will contact this person only if you move, and then only to obtain your new address or telephone number. (ENTER FIRST AND LAST NAME OF CONTACT) NAME OF CONTACT:'
      input:
        control: Textarea
    - id: KCON_Q2A_DKRF
      kind: Question
      title: 'KCON-Q2A: DON''T KNOW / REFUSAL (interviewer options printed beside NAME OF CONTACT)'
      input:
        control: Radio
        labels:
          1: DON'T KNOW
          2: REFUSAL
    - id: KCON_Q2B
      kind: Question
      title: 'ENTER ADDRESS OF CONTACT ADDRESS OF CONTACT:'
      input:
        control: Textarea
    - id: KCON_Q2B_DKRF
      kind: Question
      title: 'KCON-Q2B: DON''T KNOW / REFUSAL'
      precondition:
      - predicate: not (KCON_Q2B_DKRF.outcome == 1)
        hint: Asked only when question KCON-Q2B-DKRF is not "DON'T KNOW".
      input:
        control: Radio
        labels:
          1: DON'T KNOW
          2: REFUSAL
    - id: KCON_Q2C
      kind: Question
      title: 'ENTER PHONE NUMBER OF CONTACT (AREA CODE, PREFIX AND SUFFIX) TELEPHONE NUMBER: |_|_|_|-|_|_|_|-|_|_|_|_|'
      input:
        control: Textarea
    - id: KCON_Q2C_DKRF
      kind: Question
      title: 'KCON-Q2C: DON''T KNOW / REFUSAL'
      input:
        control: Radio
        labels:
          1: DON'T KNOW
          2: REFUSAL
  - id: b_s74_contact_2
    title: Second alternate contact
    items:
    - id: KCON_Q3A
      kind: Question
      title: 'In case we can''t reach that person, we would like to ask for the name, address and telephone number of another person that we could contact. (ENTER FIRST AND LAST NAME OF CONTACT) NAME OF CONTACT:'
      input:
        control: Textarea
    - id: KCON_Q3A_DKRF
      kind: Question
      title: 'KCON-Q3A: DON''T KNOW / REFUSAL'
      input:
        control: Radio
        labels:
          1: DON'T KNOW
          2: REFUSAL
    - id: KCON_Q3B
      kind: Question
      title: 'ENTER ADDRESS OF CONTACT ADDRESS OF CONTACT:'
      input:
        control: Textarea
    - id: KCON_Q3B_DKRF
      kind: Question
      title: 'KCON-Q3B: DON''T KNOW / REFUSAL'
      precondition:
      - predicate: not (KCON_Q3B_DKRF.outcome == 1)
        hint: Asked only when question KCON-Q3B-DKRF is not "DON'T KNOW".
      input:
        control: Radio
        labels:
          1: DON'T KNOW
          2: REFUSAL
    - id: KCON_Q3C
      kind: Question
      title: 'ENTER PHONE NUMBER OF CONTACT (AREA CODE, PREFIX AND SUFFIX) TELEPHONE NUMBER: |_|_|_|-|_|_|_|-|_|_|_|_|'
      input:
        control: Textarea
    - id: KCON_Q3C_DKRF
      kind: Question
      title: 'KCON-Q3C: DON''T KNOW / REFUSAL'
      input:
        control: Radio
        labels:
          1: DON'T KNOW
          2: REFUSAL
  - id: b_s74_teacher_consent
    title: Teacher contact consent
    items:
    - id: TCH_Q1
      kind: Question
      title: Do you agree that ...'s teacher may be contacted and asked to complete a questionnaire regarding ...?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          7: DON'T KNOW
          8: REFUSAL
    - id: TCH_Q2
      kind: Question
      title: Do you agree that ...'s teacher may give ... a brief test of math skills?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          7: DON'T KNOW
          8: REFUSAL
  - id: b_s75_consent_ids
    title: 'TCH-I3 INTERVIEWER: FILL IN THE FOLLOWING ITEMS ON THE CONSENT FORM, AND COMPLETE ALL OTHER REQUESTED INFORMATION.'
    items:
    - id: SAMPLE_ID
      kind: Question
      title: SAMPLE-ID
      input:
        control: Textarea
        maxLength: 50
    - id: PERSON
      kind: Question
      title: PERSON#
      input:
        control: Editbox
        min: 1
        max: 99
    - id: FIRST_NAME
      kind: Question
      title: FIRST NAME
      input:
        control: Textarea
        maxLength: 100
    - id: LAST_NAME
      kind: Question
      title: LAST NAME
      input:
        control: Textarea
        maxLength: 100
  - id: b_s76_observation
    title: NEIGHBOURHOOD OBSERVATION BY INTERVIEWER
    items:
    - id: OBS_Q1
      kind: Question
      title: How would you rate the volume of traffic on the street or road?
      input:
        control: Radio
        labels:
          1: VERY LIGHT
          2: LIGHT
          3: MODERATE
          4: HEAVY
          5: VERY HEAVY
          8: DON'T KNOW
          9: REFUSAL
    - id: OBS_Q2
      kind: Question
      title: Is there garbage, litter, or broken glass in the street or road, on the sidewalks, or in yards?
      input:
        control: Radio
        labels:
          1: ALMOST NONE
          2: YES, BUT NOT A LOT
          3: YES, QUITE A BIT
          4: YES, ALMOST EVERYWHERE
          8: DON'T KNOW
          9: REFUSAL
    - id: OBS_Q4
      kind: Question
      title: Are people loitering, congregating or hanging out?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: OBS_Q5
      kind: Question
      title: Are any persons arguing, shouting, fighting or otherwise behaving in hostile or threatening ways?
      input:
        control: Radio
        labels:
          1: NO PERSONS OBSERVED
          2: NO, NONE BEHAVING IN HOSTILE OR THREATENING WAYS
          3: YES SOME OBSERVED
          8: DON'T KNOW
          9: REFUSAL
    - id: OBS_Q6
      kind: Question
      title: Are drunken or otherwise intoxicated persons visible?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          8: DON'T KNOW
          9: REFUSAL
    - id: OBS_Q7
      kind: Question
      title: Based on street level frontage, how would you characterize land use on this block/road?
      input:
        control: Dropdown
        labels:
          1: 01 PRIMARILY RESIDENTIAL
          2: 02 PRIMARILY COMMERCIAL
          3: 03 MIXED RESIDENTIAL AND COMMERCIAL USE
          4: 04 PRIMARILY INDUSTRIAL, WAREHOUSE, MANUFACTURING
          5: 05 PRIMARILY VACANT HOUSES
          6: 06 PRIMARILY VACANT LOTS OR OPEN SPACE
          7: 07 PRIMARILY SERVICES OR INSTITUTIONAL, E.G., SCHOOLS, CHURCHES, HOSPITALS
          8: 08 PRIMARILY PARK, PLAYGROUND
          9: 09 PRIMARILY RURAL, RESIDENTIAL
          10: 10 PRIMARILY RURAL, FARM
          11: 11 OTHER
          98: 98 DON'T KNOW
          99: 99 REFUSAL
    - id: OBS_Q8
      kind: Question
      title: How would you rate the general condition of most of the buildings, on the block/or within 100 yards of the respondents house?
      input:
        control: Radio
        labels:
          1: BADLY DETERIORATED
          2: POOR CONDITION WITH PEELING PAINT AND NEED OF REPAIR
          3: FAIR CONDITION
          4: WELL KEPT WITH GOOD REPAIR AND EXTERIOR SURFACE
          8: DON'T KNOW
          9: REFUSAL
    - id: OBS_Q9
      kind: Question
      title: Did you first contact this dwelling by phone or in person?
      input:
        control: Radio
        labels:
          1: BY PHONE
          2: IN PERSON
          8: DON'T KNOW
          9: REFUSAL
  - id: b_s77_behaviour
    title: PEABODY (PPVT) ASSESSMENT
    items:
    - id: PPVT_Q1
      kind: Question
      title: 'During the Peabody, how was ...''s: Attitude towards being tested?'
      input:
        control: Radio
        labels:
          1: POOR
          2: '2'
          3: AVERAGE
          4: '4'
          5: EXCELLENT
          7: DON'T KNOW
          8: REFUSAL
    - id: PPVT_Q2
      kind: Question
      title: Rapport with you?
      input:
        control: Radio
        labels:
          1: POOR
          2: '2'
          3: AVERAGE
          4: '4'
          5: EXCELLENT
          7: DON'T KNOW
          8: REFUSAL
    - id: PPVT_Q3
      kind: Question
      title: Perseverance/persistence?
      input:
        control: Radio
        labels:
          1: POOR
          2: '2'
          3: AVERAGE
          4: '4'
          5: EXCELLENT
          7: DON'T KNOW
          8: REFUSAL
    - id: PPVT_Q4
      kind: Question
      title: Cooperation?
      input:
        control: Radio
        labels:
          1: POOR
          2: '2'
          3: AVERAGE
          4: '4'
          5: EXCELLENT
          7: DON'T KNOW
          8: REFUSAL
    - id: PPVT_Q5
      kind: Question
      title: Motivation/interest?
      input:
        control: Radio
        labels:
          1: POOR
          2: '2'
          3: AVERAGE
          4: '4'
          5: EXCELLENT
          7: DON'T KNOW
          8: REFUSAL
    - id: PPVT_Q6
      kind: Question
      title: 'During the Peabody, were there any problems with ...''s: Visual sharpness?'
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          7: DON'T KNOW
          8: REFUSAL
    - id: PPVT_Q6A
      kind: Question
      title: Specify the problems with ...'s visual sharpness.
      precondition:
      - predicate: not (PPVT_Q6.outcome == 2)
        hint: Asked only when question PPVT-Q6 is not "NO".
      input:
        control: Textarea
    - id: PPVT_Q7
      kind: Question
      title: Hearing?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          7: DON'T KNOW
          8: REFUSAL
    - id: PPVT_Q7A
      kind: Question
      title: Specify the problems with ...'s hearing.
      precondition:
      - predicate: not (PPVT_Q7.outcome == 2)
        hint: Asked only when question PPVT-Q7 is not "NO".
      input:
        control: Textarea
    - id: PPVT_Q8
      kind: Question
      title: During the Peabody, were there any problems with ...'s state of health?
      input:
        control: Radio
        labels:
          1: 'YES'
          2: 'NO'
          7: DON'T KNOW
          8: REFUSAL
    - id: PPVT_Q8A
      kind: Question
      title: Specify the problems with ...'s state of health.
      precondition:
      - predicate: not (PPVT_Q8.outcome == 2)
        hint: Asked only when question PPVT-Q8 is not "NO".
      input:
        control: Textarea
    - id: PPVT_Q9
      kind: Question
      title: How shy or anxious was ... at the end of the Peabody?
      input:
        control: Radio
        labels:
          1: NOT AT ALL SHY OR ANXIOUS/SOCIABLE AND FRIENDLY
          2: '2'
          3: '3'
          4: '4'
          5: EXTREMELY SHY/QUIET/WITHDRAWN
          7: DON'T KNOW
          8: REFUSAL
    - id: PPVT_Q10
      kind: Question
      title: 'During the Peabody with ..., was the following an interference: Noise level?'
      input:
        control: Radio
        labels:
          1: INTERFERING
          2: '2'
          3: '3'
          4: '4'
          5: NOT INTERFERING
          7: DON'T KNOW
          8: REFUSAL
    - id: PPVT_Q11
      kind: Question
      title: Interruptions?
      input:
        control: Radio
        labels:
          1: INTERFERING
          2: '2'
          3: '3'
          4: '4'
          5: NOT INTERFERING
          7: DON'T KNOW
          8: REFUSAL
    - id: PPVT_Q12
      kind: Question
      title: Distractions?
      input:
        control: Radio
        labels:
          1: INTERFERING
          2: '2'
          3: '3'
          4: '4'
          5: NOT INTERFERING
          7: DON'T KNOW
          8: REFUSAL
    - id: PPVT_Q13
      kind: Question
      title: Light?
      input:
        control: Radio
        labels:
          1: INTERFERING
          2: '2'
          3: '3'
          4: '4'
          5: NOT INTERFERING
          7: DON'T KNOW
          8: REFUSAL
    - id: PPVT_Q14
      kind: Question
      title: Temperature?
      input:
        control: Radio
        labels:
          1: INTERFERING
          2: '2'
          3: '3'
          4: '4'
          5: NOT INTERFERING
          7: DON'T KNOW
          8: REFUSAL
    - id: PPVT_Q15
      kind: Question
      title: Presence of others?
      input:
        control: Radio
        labels:
          1: INTERFERING
          2: '2'
          3: '3'
          4: '4'
          5: NOT INTERFERING
          7: DON'T KNOW
          8: REFUSAL
    - id: PPVT_Q16
      kind: Question
      title: Please enter any general comments not covered above for the Peabody with ....
      input:
        control: Textarea
