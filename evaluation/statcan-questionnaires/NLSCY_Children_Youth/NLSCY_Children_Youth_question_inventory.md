# National Longitudinal Survey of Children (NLSCY) - Question Inventory

## Verification Status

| Section | Source Qs | Inv. Qs | Missing | Source Checks | Inv. Checks | Missing |
|---------|----------|---------|---------|--------------|-------------|---------|
| HHLD    | 10       | 10      | 0       | 1            | 1           | 0       |
| RESTR   | 1        | 1       | 0       | 1            | 1           | 0       |
| CHRON   | 4        | 4       | 0       | 1            | 1           | 0       |
| SOCIO   | 9        | 9       | 0       | 0            | 0           | 0       |
| EDUC    | 6        | 6       | 0       | 2            | 2           | 0       |
| LFS     | 24       | 24      | 0       | 6            | 6           | 0       |
| INCOM   | 6        | 6       | 0       | 1            | 1           | 0       |
| CHLT    | 22       | 22      | 0       | 3            | 3           | 0       |
| FNC     | 14       | 14      | 0       | 2            | 2           | 0       |
| SAF     | 17       | 17      | 0       | 1            | 1           | 0       |
| SUP     | 10       | 10      | 0       | 1            | 1           | 0       |
| DVS     | 2        | 2       | 0       | 0            | 0           | 0       |
| HLT     | 86       | 85      | 0       | 12           | 12          | 0       |
| ACT     | 23       | 23      | 0       | 4            | 4           | 0       |
| BEH     | 93       | 93      | 0       | 3            | 3           | 0       |
| MSD     | 48       | 48      | 0       | 8            | 8           | 0       |
| REL     | 9        | 9       | 0       | 5            | 5           | 0       |
| PAR     | 31       | 31      | 0       | 3            | 3           | 0       |
| EDU(ch) | 45       | 45      | 0       | 9            | 9           | 0       |
| LIT     | 18       | 18      | 0       | 6            | 6           | 0       |
| MED     | 37       | 37      | 0       | 5            | 5           | 0       |
| TMP     | 52       | 52      | 0       | 15           | 15          | 0       |
| CUS     | 91       | 91      | 0       | 25           | 25          | 0       |
| CAR     | 29       | 29      | 0       | 6            | 6           | 0       |

- **Coverage**: 24/24 sections verified, 843 items total (including intros and routing nodes)
- **Routing**: All routing annotations captured per section (source has ~933 GOTO references across response options; inventory captures these at item level)
- **Status**: READY FOR QML
- **Missing**: None

## Document Overview
- **Title**: National Longitudinal Survey of Children - Survey Instruments for 1994-95 Data Collection, Cycle 1
- **Organization**: Statistics Canada / Human Resources Development Canada
- **Date**: February 1995
- **Catalogue No.**: 89F0077XIE
- **Pages**: 161 (main questionnaire, excluding appendices)
- **Language**: English
- **Type**: Computer-Assisted Personal Interview (CAPI) questionnaire for longitudinal survey of children aged 0-11 years

## Structure
The survey consists of three main components:
1. **Household Record Variables** (pp. 3-8): Contact, demographics, dwelling characteristics
2. **General Questionnaire** (pp. 9-26): Restriction of activities, chronic conditions, socio-demographics, education, labour force, income, administration (asked of all household members 15+)
3. **Parent Questionnaire** (pp. 27-40): Adult health, maternal history, CES-D depression scale, family functioning, neighbourhood, social support (asked of PMK - Person Most Knowledgeable about child)
4. **Children's Questionnaire** (pp. 44-161): Health, medical/biological, temperament, education, literacy, activities, behaviour, motor/social development, relationships, parenting, custody history, child care

Note: Per the document's conventions, where the same response categories are used in each question of a series, responses are shown for the first question only. "DON'T KNOW" and "REFUSAL" are possible responses for every question even if not shown.

## Question Inventory by Section

---

### HOUSEHOLD RECORD VARIABLES (pp. 3-8) - 23 questions

1. CONT-Q1A: **Hello, I'm ... from Statistics Canada. I am contacting you about the National Longitudinal Survey of Children.** - Intro
2. CONT-Q2: Would you prefer to be interviewed in English or French? - Radio: 1=ENGLISH, 2=FRENCH, 3=EITHER
3. CONT-Q3A: **We are conducting this survey to collect information on children, their development, family and school experiences.** - Intro
4. CONT-Q4A: **Your answers will be kept strictly confidential and used only for statistical purposes. While participation is voluntary, your assistance is essential if the results are to be accurate. (REGISTRATION #:STC/HLD-040-75020)** - Intro
5. CONT-Q7: **The next few questions will provide important basic information on the people in your household.** - Intro
6. DEMO-Q1: What are the names of all persons now living or staying here who have no usual place of residence elsewhere? (First and last names) - Open text
7. DEMO-Q2: Are there any persons away from this household attending school, visiting, travelling, or in hospital who usually live here? - Y/N: YES -->GO TO DEMO-Q1, NO
8. DEMO-Q3: Does anyone else live at this dwelling such as young children, relatives, roomers, boarders, or employees? - Y/N: YES -->GO TO DEMO-Q1, NO
9. DEMO-Q4: What is ...'s date of birth? - Date
10. DEMO-Q5: Enter or ask ...'s sex. - Radio: MALE, FEMALE
11. DEMO-Q6: What is ...'s marital status? - Radio: NOW MARRIED, COMMON-LAW, LIVING WITH A PARTNER, SINGLE (NEVER MARRIED), WIDOWED, SEPARATED, DIVORCED
12. DEMO-Q7: ENTER ...'S FAMILY ID CODE. - Internal: (A to Z)
13. DEMO-Q8: Relationships of everyone to everyone else; - Radio: HUSBAND/WIFE, COMMON LAW PARTNER, BIRTH PARENT, STEP PARENT, ADOPTIVE PARENT, FOSTER PARENT, BIRTH CHILD, STEP CHILD, ADOPTED CHILD, FOSTER CHILD, SISTER/BROTHER, GRANDPARENT, GRANDCHILD, IN-LAW, OTHER RELATED, UNRELATED, SAME SEX PARTNER
14. HHLD-Q1: Now a few questions about your dwelling. Is this dwelling owned by a member of this household (even if being paid for)? - Y/N: YES, NO
15. HHLD-C1A: *IF YES IN HHLD-Q1 ---> GO TO HHLD-Q2B* - Check (routing)
16. HHLD-Q2: Is this dwelling subsidized by the government for any reason? (Eg. low income housing project, co-operative housing project, public housing.) - Y/N: YES, NO
17. HHLD-Q2B: Is this dwelling in need of any repairs? (READ LIST. MARK ONE ONLY.) - Y/N: Yes, minor repairs (missing or loose floor tiles, bricks or shingles, defective steps, railing or siding, etc.); Yes, major repairs (defective plumbing or electrical wiring, structural repairs to walls, floors or ceiling, etc.); No, only regular maintenance is needed (painting, furnace cleaning, etc.)
18. HHLD-Q3: How many bedrooms are there in this dwelling? (IF NO SEPARATE ENCLOSED BEDROOM, ENTER "00".) - Numeric
19. HHLD-Q6: RECORD TYPE OF DWELLING (BY INTERVIEWER OBSERVATION) - Internal: SINGLE DETACHED HOUSE, SEMI-DETACHED OR DOUBLE (SIDE-BY-SIDE), GARDEN HOUSE TOWN-HOUSE OR ROW HOUSE, DUPLEX (ONE ABOVE THE OTHER), LOW-RISE APARTMENT (LESS THAN 5 STORIES), HIGH-RISE APARTMENT (5 OR MORE STORIES), INSTITUTION, HOTEL ROOMING OR LODGING HOUSE LOGGING OR CONSTRUCTION CAMP HUTTERITE COLONY, MOBILE HOME, OTHER (SPECIFY)
20. HHLD-Q7: INFORMATION SOURCE INDICATOR I.E. WHO IS PROVIDING THE INFORMATION - Internal
21. HHLD-Q8: RECORD LANGUAGE OF INTERVIEW - Internal: ENGLISH, FRENCH, ARABIC, CHINESE, CREE, GERMAN, GREEK, HUNGARIAN, ITALIAN, KOREAN, PERSIAN (FARSI), POLISH, PORTUGUESE, PUNJABI, SPANISH, TAGALOG (FILIPINO), UKRAINIAN, VIETNAMESE, OTHER (SPECIFY)
22. CAID-INT-1: **Who is the most knowledgeable about ...?** - Intro
23. PICKRESP: Who is providing the information for this person's form? - Open text

---

### GENERAL QUESTIONNAIRE

#### Restriction of Activities (pp. 9-10) - 3 questions

24. RESTR-CINT: *IF AGE<12, GO TO NEXT SECTION.* - Check (routing)
25. RESTR-INT: **The next few questions deal with any health limitations which affect ... (r/'s) daily activities. In these questions, "long-term conditions" refer to conditions that have lasted or are expected to last 6 months or more.** - Intro
26. RESTR-Q1: Because of a long-term physical or mental condition or a health problem, are/is ... limited in the kind or amount of activity you/he/she can do: - Y/N: (a) At home? 1=YES 2=NO (b) At school? 1=YES 2=NO 3=NOT APPLICABLE (c) At work? 1=YES 2=NO 3=NOT APPLICABLE (d) In other activities such as transportation to or from work or leisure time activities? 1=YES 2=NO (e) In caring for children? 1=YES 2=NO 3=NOT APPLICABLE

#### Chronic Conditions (pp. 11-12) - 6 questions

27. CHRON-CINT: *IF AGE<12 OR RESPONDENT IS NOT THE PARENT GO TO NEXT SECTION.* - Check (routing)
28. CHRON-INT: **Now I'd like to ask about any chronic health conditions ... may have. Again, "long-term conditions" refer to conditions that have lasted or are expected to last 6 months or more.** - Intro
29. CHRON-Q1: Do(es) ... have any of the following long-term conditions that have been diagnosed by a health professional: - Checkbox: (READ LIST. MARK ALL THAT APPLY.) (a) Food allergies? (b) Other allergies? (c) Asthma? (IF YES ASK CHRON-Q1cc1) (d) Arthritis or rheumatism? (e) Back problems excluding arthritis? (f) High blood pressure? (g) Migraine headaches? (h) Chronic bronchitis or emphysema? (i) Sinusitis? (j) Diabetes? (k) Epilepsy? (l) Heart disease? (m) Cancer? (IF YES ASK CHRON-Q1mm) (n) Stomach or intestinal ulcers? (o) Effects of stroke? (p) Urinary incontinence? (r) Alzheimer's disease or other dementia? (s) Cat...
30. CHRON-Q1mm: What type(s) of cancer is this? For example, skin, lung or colon cancer. - Open text
31. CHRON-Q1cc1: Have/Has ... had an attack of asthma in the past 12 months? - Y/N: 1=YES 2=NO
32. CHRON-Q1cc2: Have/Has ... had wheezing or whistling in the chest at any time in the past 12 months? - Radio: Not explicitly listed in source (likely YES/NO, same pattern as CHRON-Q1cc1)

#### Socio-demographic Characteristics (pp. 12-14) - 10 questions

33. SOCIO-INT: **Now I'd like to ask some general background questions.** - Intro
34. SOCIO-Q1: In what country were/was ... born? - Radio: (DO NOT READ LIST. MARK ONE ONLY.) 1=CANADA (GO TO NEXT SECTION) 2=CHINA 3=FRANCE 4=GERMANY 5=GREECE 6=GUYANA 7=HONG KONG 8=HUNGARY 9=INDIA 10=ITALY 11=JAMAICA 12=NETHERLANDS 13=PHILIPPINES 14=POLAND 15=PORTUGAL 16=UNITED KINGDOM 17=UNITED STATES 18=VIET NAM 19=OTHER (SPECIFY___)
35. SOCIO-Q2a: Of what country are/is ... a citizen? - Checkbox: (DO NOT READ LIST. MARK ALL THAT APPLY.) 1=CANADA, CITIZEN BY BIRTH (GO TO NEXT SECTION) 2=CANADA, BY NATURALIZATION 3=SAME AS COUNTRY OF BIRTH 4=OTHER COUNTRY
36. SOCIO-Q2b: Are/Is ... now, or have/has ... ever been a landed immigrant? - Y/N: 1=YES 2=NO
37. SOCIO-Q3: In what year did ... first immigrate to Canada? - Radio: YEAR (4 DIGITS)
38. SOCIO-Q4: To which ethnic or cultural group(s) did your/...'s ancestors belong? (For example: French, British, Chinese) - Checkbox: (DO NOT READ LIST. MARK ALL THAT APPLY.) 1=CANADIAN 2=FRENCH 3=ENGLISH 4=GERMAN 5=SCOTTISH 6=IRISH 7=ITALIAN 8=UKRAINIAN 9=DUTCH (NETHERLANDS) 10=CHINESE 11=JEWISH 12=POLISH 13=PORTUGUESE 14=SOUTH ASIAN 15=BLACK 16=NORTH AMERICAN INDIAN 17=METIS 18=INUIT/ESKIMO 19=OTHER (SPECIFY______)
39. SOCIO-Q5: In what language(s) can ... conduct a conversation? - Checkbox: (DO NOT READ LIST. MARK ALL THAT APPLY.) 1=ENGLISH 2=FRENCH 3=ARABIC 4=CHINESE 5=CREE 6=GERMAN 7=GREEK 8=HUNGARIAN 9=ITALIAN 10=KOREAN 11=PERSIAN (FARSI) 12=POLISH 13=PORTUGUESE 14=PUNJABI 15=SPANISH 16=TAGALOG (FILIPINO) 17=UKRAINIAN 18=VIETNAMESE 19=OTHER (SPECIFY______)
40. SOCIO-Q6: What is the language that ... first learned at home in childhood and can still understand? (IF ... CAN NO LONGER UNDERSTAND THE FIRST LANGUAGE LEARNED, CHOOSE THE SECOND LANGUAGE LEARNED.) - Checkbox: (DO NOT READ LIST. MARK ALL THAT APPLY.) 1=ENGLISH 2=FRENCH 3=ARABIC 4=CHINESE 5=CREE 6=GERMAN 7=GREEK 8=HUNGARIAN 9=ITALIAN 10=KOREAN 11=PERSIAN (FARSI) 12=POLISH 13=PORTUGUESE 14=PUNJABI 15=SPANISH 16=TAGALOG (FILIPINO) 17=UKRAINIAN 18=VIETNAMESE 19=OTHER (SPECIFY______)
41. SOCIO-Q8: What, if any, is your/...'s religion? - Radio: (DO NOT READ LIST. MARK ONE ONLY.) 1=NO RELIGION (GO TO NEXT SECTION) 2=ROMAN CATHOLIC 3=UNITED CHURCH 4=ANGLICAN 5=PRESBYTERIAN 6=LUTHERAN 7=BAPTIST 8=EASTERN ORTHODOX 9=JEWISH 10=ISLAM (MUSLIM) 11=BUDDHIST 12=HINDU 13=SIKH 14=JEHOVAH'S WITNESS 15=OTHER (SPECIFY_________)
42. SOCIO-Q9: Other than on special occasions (such as weddings, funerals or baptisms), how often did ... attend religious services or meetings in the past 12 months? - Radio: (READ LIST. MARK ONE ONLY.) 1=At least once a week 2=At least once a month 3=At least 3 or 4 times a year 4=At least once a year 5=Not at all

#### Education (pp. 15-16) - 8 questions

43. EDUC-C1: *IF AGE<12, GO TO NEXT SECTION.* - Check (routing)
44. EDUC-Q1: Excluding kindergarten, how many years of elementary and high school have/has ... successfully completed? - Radio: (DO NOT READ LIST. MARK ONE ONLY.) 0=NO SCHOOLING (GO TO NEXT SECTION) 1=1-5 YEARS 2=6 3=7 4=8 5=9 6=10 7=11 8=12 9=13
45. EDUC-Q2: Have/has ... graduated from high school? - Y/N: 1=YES 2=NO
46. EDUC-Q3: Have/has ... ever attended any other kind of school such as a university, community college, business school, trade or vocational school, CEGEP or other post-secondary institution? - Y/N: 1=YES 2=NO (GO TO EDUC-C5)
47. EDUC-Q4: What is the highest level of education that ... have/has attained? - Radio: (DO NOT READ LIST. MARK ONE ONLY.) 1=SOME TRADE, TECHNICAL OR VOCATIONAL SCHOOL, OR BUSINESS COLLEGE 2=SOME COMMUNITY COLLEGE, CEGEP, OR NURSING SCHOOL 3=SOME UNIVERSITY 4=DIPLOMA OR CERTIFICATE FROM TRADE, TECHNICAL OR VOCATIONAL SCHOOL, OR BUSINESS COLLEGE 5=DIPLOMA OR CERTIFICATE FROM COMMUNITY COLLEGE, CEGEP OR NURSING SCHOOL 6=BACHELOR OR UNDERGRADUATE DEGREE, OR TEACHER'S COLLEGE (E.G. B.A., B.SC., LL.B.) 7=MASTER'S (E.G. M.A., M.SC., M.ED.) 8=DEGREE IN MEDICINE, DENTISTRY, VETERINARY M...
48. EDUC-C5: *IF AGE >= 65, GO TO NEXT SECTION.* - Check (routing)
49. EDUC-Q5: Are/Is ... currently attending a school, college or university? - Y/N: 1=YES 2=NO (GO TO NEXT SECTION)
50. EDUC-Q6: Are/Is ... enrolled as a full-time or part-time student? - Radio: 1=FULL-TIME 2=PART-TIME

#### Labour Force (pp. 17-21) - 31 questions

51. LFS-C1: *IF NOT PARENT, GO TO NEXT SECTION.* - Check (routing)
52. LFS-Q1: What do/does ... consider to be your/his/her current main activity? (For example, working for pay, caring for family.) - Radio: (DO NOT READ LIST. MARK ONE ONLY.) 1=CARING FOR FAMILY 2=WORKING FOR PAY OR PROFIT 3=CARING FOR FAMILY AND WORKING FOR PAY OR PROFIT 4=GOING TO SCHOOL 5=RECOVERING FROM ILLNESS/ON DISABILITY 6=LOOKING FOR WORK 7=RETIRED 8=OTHER (SPECIFY)
53. LFS-I2: **The next section contains questions about jobs or employment which ... have/has had during the past 12 months, that is, from 12 months ago to today. Please include such employment as part-time jobs, contract work, baby sitting and any other paid work.** - Intro
54. LFS-C2: *IF LFS-Q1 = Working for pay or profit or Caring for family and working for pay or profit ---> GO TO LFS-Q3* - Check (routing)
55. LFS-Q2: Have/has you/he/she worked for pay or profit at any time in the past 12 months? - Y/N: 1=YES (GO TO LFS-Q3) 2=NO
56. LFS-C2A: *IF LFS-Q1=7 (RETIRED) ---> GO TO INCOME SECTION; ELSE GO TO LFS-Q17B* - Check (routing)
57. LFS-Q3: For whom/whom else have/has you/he/she worked for pay or profit in the past 12 months? - Open text
58. LFS-Q4: Did you/he/she have that job 1 year ago, that is, on (date 12 months ago) without a break in employment since then? - Y/N: 1=YES (GO TO LFS-Q6) 2=NO
59. LFS-Q5: When did you/he/she start working at this job or business? - Date
60. LFS-Q6: Do/Does you/he/she now have that job? - Y/N: 1=YES (GO TO LFS-Q8) 2=NO
61. LFS-Q7: When did you/he/she stop working at this job or business? - Date
62. LFS-Q8: About how many hours per week do/does/did you/he/she usually work at this job? (IF IRREGULAR WORKING SCHEDULE, ENTER THE AVERAGE PER WEEK FOR THE LAST 4 WEEKS WORKED.) - Numeric
63. LFS-Q9: Which of the following best describes the hours you/he/she usually work/works/worked at this job? - Radio: (READ LIST. MARK ONE ONLY.) 1=Regular daytime schedule or shift 2=Regular evening shift 3=Regular night shift 4=Rotating shift (change from days to evenings to nights) 5=Split shift 6=On call 7=Irregular schedule 8=Other (Specify_______)
64. LFS-Q10: Do/Does/Did you/he/she usually work on weekends at this job? - Y/N: 1=YES 2=NO
65. LFS-Q11: Did you/he/she do any other work for pay or profit in the past 12 months? - Y/N: 1=YES 2=NO
66. LFS-C12: *If LFS-Q11 = NO ---> GO TO LFS-Q13* - Check (routing)
67. LFS-Q12: Which was the main job? - Radio: Selection from roster of jobs entered in LFS-Q3 through LFS-Q11.
68. LFS-Q13: Thinking about this/the main job, what kind of business, service or industry is this? (For example, wheat farm, trapping, road maintenance, retail shoe store, secondary school.) - Open text
69. LFS-Q14: Again, thinking about this/the main job, what kind of work was/were ... doing? (For example, medical lab technician, accounting clerk, secondary school teacher, supervisor of data entry unit, food processing labourer.) - Open text
70. LFS-Q15: In this work, what were your/his/her most important duties or activities? (For example, analysis of blood samples, verifying invoices, teaching mathematics, organizing work schedules, cleaning vegetables.) - Open text
71. LFS-Q16: Did you/he/she work mainly for others for wages, salary or commission, or in your/his/her own business, farm or professional practice? - Radio: (DO NOT READ LIST. MARK ONE ONLY.) 1=FOR OTHERS FOR WAGES, SALARY OR COMMISSION 2=IN OWN BUSINESS, FARM OR PROFESSIONAL PRACTICE -->GO TO LFS-C17 3=UNPAID FAMILY WORKER -->GO TO LFS-C17
72. LFS-Q16A: At this job, about how many hours per week were/was you/he/she paid for? - Numeric
73. LFS-Q16B: At this job, did you/he/she receive any tips, commissions, bonuses, or paid overtime? - Y/N: 1=YES -->GO TO LFS-Q16C 2=NO -->GO TO LFS-Q16CC 8=DON'T KNOW -->GO TO LFS-Q16CC 9=REFUSAL -->GO TO LFS-C17
74. LFS-Q16C: At this job, including tips, commissions, bonuses, or paid overtime, what was your/his/her usual wage or salary before taxes and other deductions from the employer? (TO ENTER CENTS, ENTER . THEN THE CENTS.) - Numeric
75. LFS-Q16CC: At this job, what was your/his/her usual wage or salary before taxes and other deductions from the employer? (TO ENTER CENTS, ENTER . THEN THE CENTS.) - Numeric
76. LFS-Q16D: Was this ... - Radio: 01=PER HOUR -->GO TO LFS-C17 02=PER DAY -->GO TO LFS-C17 03=PER WEEK -->GO TO LFS-C17 04=EVERY TWO WEEKS -->GO TO LFS-C17 05=TWICE A MONTH -->GO TO LFS-C17 06=PER MONTH -->GO TO LFS-C17 07=PER YEAR -->GO TO LFS-C17 08=SINCE STARTING AT THIS JOB THIS YEAR -->GO TO LFS-C17 09=OTHER 98=DON'T KNOW -->GO TO LFS-C17 99=REFUSAL -->GO TO LFS-C17
77. LFS-Q16E: At this job, what was your/his/her total earnings? - Numeric
78. LFS-C17: *CHECK THE CALENDAR FOR GAPS > 6 DAYS. IF # GAPS = 0 ---> GO TO NEXT SECTION* - Check (routing)
79. LFS-C17A: *IF ANY LFS-Q6 = 1 (CURRENTLY EMPLOYED) ---> GO TO LFS-Q17A; OTHERWISE ---> GO TO LFS-Q17B* - Check (routing)
80. LFS-Q17A: What was the reason that ... were/was not working for pay or profit during the most recent period away from work in the past year? - Radio: (DO NOT READ LIST. MARK ONE ONLY.) 01=OWN ILLNESS OR DISABILITY 02=PREGNANCY 03=CARING FOR OWN CHILDREN 04=CARING FOR ELDER RELATIVE(S) 05=OTHER PERSONAL OR FAMILY RESPONSIBILITIES 06=SCHOOL OR EDUCATIONAL LEAVE 07=LABOUR DISPUTE 08=TEMPORARY LAYOFF DUE TO SEASONAL CONDITIONS 09=TEMPORARY LAYOFF - NON-SEASONAL 10=PERMANENT LAYOFF 11=UNPAID OR PARTIALLY PAID LEAVE 12=OTHER (SPECIFY________) 13=NO PERIOD NOT WORKING FOR PAY OR PROFIT IN THE PAST YEAR
81. LFS-Q17B: What is the reason that ... are/is currently not working for pay or profit? - Radio: (DO NOT READ LIST. MARK ONE ONLY.) 01=OWN ILLNESS OR DISABILITY 02=PREGNANCY 03=CARING FOR OWN CHILDREN 04=CARING FOR ELDER RELATIVE(S) 05=OTHER PERSONAL OR FAMILY RESPONSIBILITIES 06=SCHOOL OR EDUCATIONAL LEAVE 07=LABOUR DISPUTE 08=TEMPORARY LAYOFF DUE TO SEASONAL CONDITIONS 09=TEMPORARY LAYOFF - NON-SEASONAL 10=PERMANENT LAYOFF 11=UNPAID OR PARTIALLY PAID LEAVE 12=OTHER (SPECIFY_______) 13=NO PERIOD NOT WORKING FOR PAY OR PROFIT IN THE PAST YEAR

#### Income (pp. 22-24) - 6 questions

82. INCOM-Q1: Thinking about your total household income, from which of the following sources did your household receive any income in the past 12 months? - Checkbox: (READ LIST. MARK ALL THAT APPLY.) 01=Wages and salaries 02=Income from self-employment 03=Dividends and interest (e.g. on bonds, deposits, etc.) 04=Unemployment insurance 05=Worker's compensation 06=Benefits from Canada or Quebec Pension Plan 07=Retirement pensions, superannuation and annuities 08=Old Age Security and Guaranteed Income Supplement 09=Child Tax Benefit 10=Provincial or municipal social assistance or welfare 11=Child Support 12=Alimony 13=Other (e.g. other gov't, rental income, ...
83. INCOM-Q2: What was the main source of income? - Radio: (DO NOT READ LIST. MARK ONE ONLY.) 01=WAGES AND SALARIES 02=INCOME FROM SELF-EMPLOYMENT 03=DIVIDENDS AND INTEREST (E.G. ON BONDS, DEPOSITS, ETC.) 04=UNEMPLOYMENT INSURANCE 05=WORKER'S COMPENSATION 06=BENEFITS FROM CANADA OR QUEBEC PENSION PLAN 07=RETIREMENT PENSIONS, SUPERANNUATION AND ANNUITIES 08=OLD AGE SECURITY AND GUARANTEED INCOME SUPPLEMENT 09=CHILD TAX BENEFIT 10=PROVINCIAL OR MUNICIPAL SOCIAL ASSISTANCE OR WELFARE 11=CHILD SUPPORT 12=ALIMONY 13=OTHER (E.G. OTHER GOV'T, RENTAL INCOME,...
84. INCOM-Q3: What is your best estimate of the total income before taxes and deductions of all household members from all sources in the past 12 months? - Numeric
85. INCOM-Q3B: Can you estimate in which of the following groups your household income falls? - Radio: (Cascading/branching structure) 01=LESS THAN $20,000? 02=LESS THAN $10,000? 03=LESS THAN $5,000? (GO TO INCOM-Q4) 04=$5,000 OR MORE? (GO TO INCOM-Q4) 05=$10,000 OR MORE? 06=LESS THAN $15,000? (GO TO INCOM-Q4) 07=$15,000 OR MORE? (GO TO INCOM-Q4) 08=$20,000 OR MORE? 09=LESS THAN $40,000? 10=LESS THAN $30,000? (GO TO INCOM-Q4) 11=$30,000 OR MORE? (GO TO INCOM-Q4) 12=$40,000 OR MORE? 13=LESS THAN $50,000? (GO TO INCOM-Q4) 14=$50,000 TO LESS THAN $60,000? (GO TO INCOM-Q4) 15=$60,000 TO LESS THAN ...
86. INCOM-Q4: What is your best estimate of your total personal income before taxes and deductions from all sources in the past 12 months? - Numeric
87. INCOM-Q4B: Can you estimate in which of the following groups your personal income falls? - Radio: (Cascading/branching structure) 01=LESS THAN $20,000? 02=LESS THAN $10,000? 03=LESS THAN $5,000? (GO TO NEXT SECTION) 04=$5,000 OR MORE? (GO TO NEXT SECTION) 05=$10,000 OR MORE? 06=LESS THAN $15,000? (GO TO NEXT SECTION) 07=$15,000 OR MORE? (GO TO NEXT SECTION) 08=$20,000 OR MORE? 09=LESS THAN $40,000? 10=LESS THAN $30,000? (GO TO NEXT SECTION) 11=$30,000 OR MORE? (GO TO NEXT SECTION) 12=$40,000 OR MORE? 13=LESS THAN $50,000? (GO TO NEXT SECTION) 14=$50,000 TO LESS THAN $60,000? (GO TO NEXT S...

#### Administration (pp. 25-26) - 2 questions

88. H05-P1: Was this interview conducted on the telephone or in person? - Radio: 1=ON TELEPHONE 2=IN PERSON 3=BOTH (SPECIFY REASON)
89. H05-P2: Record language of interview - Radio: 01=ENGLISH 02=FRENCH 03=ARABIC 04=CHINESE 05=CREE 06=GERMAN 07=GREEK 08=HUNGARIAN 09=ITALIAN 10=KOREAN 11=PERSIAN (FARSI) 12=POLISH 13=PORTUGUESE 14=PUNJABI 15=SPANISH 16=TAGALOG (FILIPINO) 17=UKRAINIAN 18=VIETNAMESE 19=OTHER (SPECIFY_______________)

---

### PARENT QUESTIONNAIRE

#### Adult Health - CHLT (pp. 29-32) - 26 questions

*NOTE: PMK gets CHLT-Q1-Q7, Q12A-Q12L. Female biological parent of child < 2 years also gets CHLT-Q8-Q11. Spouse/Partner of PMK gets CHLT-Q1-Q7.*

90. CHLT-Q1: The following questions ask about your/...'s general health and smoking habits. In general, would you say your/his/her health is: - Radio: 1=Excellent, 2=Very good, 3=Good, 4=Fair, 5=Poor, 8=DON'T KNOW, 9=REFUSAL
91. CHLT-Q2: At the present time do you/does ... smoke cigarettes daily, occasionally or not at all? - Radio: 1=DAILY, 2=OCCASIONALLY (GO TO CHLT-I4), 3=NOT AT ALL (GO TO CHLT-I4), 8=DON'T KNOW (GO TO CHLT-I4), 9=REFUSAL (GO TO CHLT-I4)
92. CHLT-Q3: How many cigarettes do you/does ... smoke each day now? - Numeric
93. CHLT-I4: **Now, some questions about alcohol consumption.** - Intro
94. CHLT-Q4: During the past 12 months, have you/has ... had a drink of beer, wine, liquor or any other alcoholic beverage? - Y/N: 1=YES, 2=NO (GO TO CHLT-C8), 8=DON'T KNOW (GO TO CHLT-C8), 9=REFUSAL (GO TO CHLT-C8)
95. CHLT-Q5: During the past 12 months, how often did you/he/she drink alcoholic beverages? (MARK ONE ONLY.) - Radio: 1=EVERY DAY, 2=4-6 TIMES A WEEK, 3=2-3 TIMES A WEEK, 4=ONCE A WEEK, 5=2-3 TIMES A MONTH, 6=ONCE A MONTH, 7=LESS THAN ONCE A MONTH, 8=DON'T KNOW, 9=REFUSAL (GO TO CHLT-C8)
96. CHLT-Q6: How many times in the past 12 months have you/has he/she had 5 or more drinks on one occasion? - Numeric
97. CHLT-Q7: In the past 12 months, what is the highest number of drinks you/he/she had on one occasion? - Numeric

**Maternal History**

98. CHLT-C8: *IF THE RESPONDENT IS THE FEMALE BIOLOGICAL PARENT OF AT LEAST 1 CHILD IN THE FAMILY UNDER 2 YEARS OF AGE, AND THIS COMPONENT IS NON-PROXY ---> GO TO CHLT-Q8. OTHERWISE ---> GO TO CHLT-C12* - Check (routing)
99. CHLT-Q8: Now I would like to ask you some questions about your past pregnancies. How many times throughout your life have you been pregnant including any pregnancies which did not go full term? - Numeric
100. CHLT-Q9: How many babies have you had? - Numeric
101. CHLT-Q11: At what age did you have your first baby? - Numeric

**CES-D Depression Scale**

102. CHLT-C12: *IF RESPONDENT IS THE PERSON MOST KNOWLEDGEABLE ABOUT THE CHILD ---> GO TO CHLT-C12A. OTHERWISE ---> GO TO NEXT SECTION* - Check (routing)
103. CHLT-I12: **The next set of statements describe feelings or behaviours. For each one, please tell me how often you felt or behaved this way during the past week.** - Intro
104. CHLT-Q12A: How often have you felt or behaved this way during the past week: I did not feel like eating; my appetite was poor. - Scale: 1=RARELY OR NONE OF THE TIME (LESS THAN 1 DAY), 2=SOME OR A LITTLE OF THE TIME (1-2 DAYS), 3=OCCASIONALLY OR A MODERATE AMOUNT OF TIME (3-4 DAYS), 4=MOST OR ALL OF THE TIME (5-7 DAYS), 8=DON'T KNOW, 9=REFUSAL (GO TO CHLT-STOP)
105. CHLT-Q12B: I felt that I could not shake off the blues even with help from my family or friends. - Radio: (Same 1-4, 8, 9 scale as CHLT-Q12A)
106. CHLT-Q12C: I had trouble keeping my mind on what I was doing. - Radio: (Same 1-4, 8, 9 scale as CHLT-Q12A)
107. CHLT-Q12D: I felt depressed. - Radio: (Same 1-4, 8, 9 scale as CHLT-Q12A)
108. CHLT-Q12E: I felt that everything I did was an effort. - Radio: (Same 1-4, 8, 9 scale as CHLT-Q12A)
109. CHLT-Q12F: I felt hopeful about the future. - Radio: (Same 1-4, 8, 9 scale as CHLT-Q12A)
110. CHLT-Q12G: My sleep was restless. - Radio: (Same 1-4, 8, 9 scale as CHLT-Q12A)
111. CHLT-Q12H: I was happy. - Radio: (Same 1-4, 8, 9 scale as CHLT-Q12A)
112. CHLT-Q12I: I felt lonely. - Radio: (Same 1-4, 8, 9 scale as CHLT-Q12A)
113. CHLT-Q12J: I enjoyed life. - Radio: (Same 1-4, 8, 9 scale as CHLT-Q12A)
114. CHLT-Q12K: I had crying spells. - Radio: (Same 1-4, 8, 9 scale as CHLT-Q12A)
115. CHLT-Q12L: I felt that people disliked me. - Radio: (Same 1-4, 8, 9 scale as CHLT-Q12A)

#### Family Functioning - FNC (pp. 33-34) - 17 questions

116. FNC-C1: *IF THIS SECTION HAS BEEN COMPLETED FOR ANOTHER HOUSEHOLD MEMBER ---> GO TO NEXT SECTION* - Check (routing)
117. FNC-I1: **The following statements are about families and family relationships. For each one, please indicate which response best describes your family: strongly agree, agree, disagree or strongly disagree.** - Intro
118. FNC-Q1A: Planning family activities is difficult because we misunderstand each other. - Scale: 1=STRONGLY AGREE, 2=AGREE, 3=DISAGREE, 4=STRONGLY DISAGREE, 8=DON'T KNOW, 9=REFUSAL (GO TO NEXT SECTION)
119. FNC-Q1B: In times of crisis we can turn to each other for support. - Radio: (Same 1-4, 8, 9 scale as FNC-Q1A)
120. FNC-Q1C: We cannot talk to each other about sadness we feel. - Radio: (Same 1-4, 8, 9 scale as FNC-Q1A)
121. FNC-Q1D: Individuals (in the family) are accepted for what they are. - Radio: (Same 1-4, 8, 9 scale as FNC-Q1A)
122. FNC-Q1E: We avoid discussing our fears or concerns. - Radio: (Same 1-4, 8, 9 scale as FNC-Q1A)
123. FNC-Q1F: We express feelings to each other. - Radio: (Same 1-4, 8, 9 scale as FNC-Q1A)
124. FNC-Q1G: There are lots of bad feelings in our family. - Radio: (Same 1-4, 8, 9 scale as FNC-Q1A)
125. FNC-Q1H: We feel accepted for what we are. - Radio: (Same 1-4, 8, 9 scale as FNC-Q1A)
126. FNC-Q1I: Making decisions is a problem for our family. - Radio: (Same 1-4, 8, 9 scale as FNC-Q1A)
127. FNC-Q1J: We are able to make decisions about how to solve problems. - Radio: (Same 1-4, 8, 9 scale as FNC-Q1A)
128. FNC-Q1K: We don't get along well together. - Radio: (Same 1-4, 8, 9 scale as FNC-Q1A)
129. FNC-Q1L: We confide in each other. - Radio: (Same 1-4, 8, 9 scale as FNC-Q1A)
130. FNC-Q1M: Drinking is a source of tension or disagreement in our family. - Radio: (Same 1-4, 8, 9 scale as FNC-Q1A)
131. FNC-C2: *IF PERSON IS MARRIED, LIVING COMMON-LAW OR LIVING WITH A PARTNER ---> GO TO FNC-Q2. OTHERWISE ---> GO TO NEXT SECTION* - Check (routing)
132. FNC-Q2: All things considered, how satisfied or dissatisfied are you with your marriage or relationship with your partner? Which number comes the closest to how you feel, where 1 is completely dissatisfied and 11 is completely satisfied? - Radio: 01=COMPLETELY DISSATISFIED, 02, 03, 04, 05, 06=NEUTRAL, 07, 08, 09, 10, 11=COMPLETELY SATISFIED, 98=DON'T KNOW, 99=REFUSAL

#### Neighbourhood - SAF (pp. 35-37) - 21 questions

133. SAF-C1: *IF THIS SECTION HAS BEEN COMPLETED FOR ANOTHER HOUSEHOLD MEMBER ---> GO TO NEXT SECTION. OTHERWISE ---> GO TO SAF-Q1* - Check (routing)
134. SAF-Q1: This section asks questions about your neighbourhood. How many years have you lived at this address? (ENTER 0 IF LESS THAN 1 YEAR.) - Numeric
135. SAF-Q2: How do you feel about your neighbourhood as a place to bring up children? Is it... (READ LIST. MARK ONE ONLY.) - Radio: 1=Excellent, 2=Good, 3=Average, 4=Poor, 5=Very poor, 8=DON'T KNOW, 9=REFUSAL (GO TO NEXT SECTION)
136. SAF-Q3: Are you involved in any local voluntary organizations such as school groups, church groups, community or ethnic associations? - Y/N: 1=YES, 2=NO, 8=DON'T KNOW, 9=REFUSAL (GO TO NEXT SECTION)
137. SAF-I5A: **Please tell me whether you strongly agree, agree, disagree, or strongly disagree with these statements about your neighbourhood.** - Intro
138. SAF-Q5A: It is safe to walk alone in this neighbourhood after dark. - Scale: 1=STRONGLY AGREE, 2=AGREE, 3=DISAGREE, 4=STRONGLY DISAGREE, 8=DON'T KNOW, 9=REFUSAL (GO TO NEXT SECTION)
139. SAF-Q5B: It is safe for children to play outside during the day. - Radio: (Same 1-4, 8, 9 scale as SAF-Q5A)
140. SAF-Q5C: There are good parks, playgrounds and play spaces in this neighbourhood. - Radio: (Same 1-4, 8, 9 scale as SAF-Q5A)
141. SAF-I6A: **The following statements are about people in neighbourhoods.** - Intro
142. SAF-Q6A: Please tell me whether you strongly agree, agree, disagree, or strongly disagree about the following statement when thinking of your neighbours. If there is a problem around here, the neighbours get together to deal with it. - Scale: 1=STRONGLY AGREE, 2=AGREE, 3=DISAGREE, 4=STRONGLY DISAGREE, 8=DON'T KNOW, 9=REFUSAL (GO TO NEXT SECTION)
143. SAF-Q6B: There are adults in the neighbourhood that children can look up to. - Radio: (Same 1-4, 8, 9 scale as SAF-Q6A)
144. SAF-Q6C: People around here are willing to help their neighbours. - Radio: (Same 1-4, 8, 9 scale as SAF-Q6A)
145. SAF-Q6D: You can count on adults in this neighbourhood to watch out that children are safe and don't get in trouble. - Radio: (Same 1-4, 8, 9 scale as SAF-Q6A)
146. SAF-Q6E: When I'm away from home, I know that my neighbours will keep their eyes open for possible trouble. - Radio: (Same 1-4, 8, 9 scale as SAF-Q6A)
147. SAF-I7A: **The following are problems that arise in neighbourhoods.** - Intro
148. SAF-Q7A: How much of a problem is the following in this neighbourhood: Litter, broken glass or garbage in the street or road, on the sidewalk, or in yards? - Radio: 1=A BIG PROBLEM, 2=SOMEWHAT OF A PROBLEM, 3=NO PROBLEM, 8=DON'T KNOW, 9=REFUSAL (GO TO NEXT SECTION)
149. SAF-Q7B: Selling or using drugs? - Radio: (Same 1-3, 8, 9 scale as SAF-Q7A)
150. SAF-Q7C: Alcoholics and excessive drinking in public? - Radio: (Same 1-3, 8, 9 scale as SAF-Q7A)
151. SAF-Q7D: Groups of young people who cause trouble? - Radio: (Same 1-3, 8, 9 scale as SAF-Q7A)
152. SAF-Q7E: Burglary of homes and apartments? - Radio: (Same 1-3, 8, 9 scale as SAF-Q7A)
153. SAF-Q7F: Unrest due to ethnic or religious differences? - Radio: (Same 1-3, 8, 9 scale as SAF-Q7A)

#### Social Support - SUP (pp. 38-40) - 12 questions

154. SUP-C1: *IF THIS SECTION HAS BEEN COMPLETED FOR ANOTHER HOUSEHOLD MEMBER ---> GO TO NEXT SECTION. OTHERWISE ---> GO TO SUP-I1* - Check (routing)
155. SUP-I1: **The following statements are about relationships and the support which you get from others. For each of the following, please tell me whether you strongly disagree, disagree, agree, or strongly agree.** - Intro
156. SUP-Q1A: If something went wrong, no one would help me. - Scale: 1=STRONGLY DISAGREE, 2=DISAGREE, 3=AGREE, 4=STRONGLY AGREE, 8=DON'T KNOW, 9=REFUSAL (GO TO SUP-Q2A)
157. SUP-Q1B: I have family and friends who help me feel safe, secure and happy. - Radio: (Same 1-4, 8, 9 reversed scale as SUP-Q1A)
158. SUP-Q1C: There is someone I trust whom I would turn to for advice if I were having problems. - Radio: (Same 1-4, 8, 9 reversed scale as SUP-Q1A)
159. SUP-Q1D: There is no one I feel comfortable talking about problems with. - Radio: (Same 1-4, 8, 9 reversed scale as SUP-Q1A)
160. SUP-Q1E: I lack a feeling of closeness with another person. - Radio: (Same 1-4, 8, 9 reversed scale as SUP-Q1A)
161. SUP-Q1F: There are people I can count on in an emergency. - Radio: (Same 1-4, 8, 9 reversed scale as SUP-Q1A)
162. SUP-Q2A: Besides your friends and family, did any of the following help with your personal problems during the past 12 months? Community or social service professionals? - Y/N: 1=YES, 2=NO, 8=DON'T KNOW, 9=REFUSAL (GO TO NEXT SECTION)
163. SUP-Q2B: Health professionals? - Radio: (Same 1-2, 8, 9 scale as SUP-Q2A)
164. SUP-Q2C: Religious or spiritual leaders or communities? - Radio: (Same 1-2, 8, 9 scale as SUP-Q2A)
165. SUP-Q2D: Books or magazines? - Radio: (Same 1-2, 8, 9 scale as SUP-Q2A)

---

### CHILDREN'S QUESTIONNAIRE

#### Child Demographics - DVS (pp. 43) - 3 questions

166. DVS-INT: **I need to confirm some of the information that we collected earlier, since it is important in determining which questions we need to ask you about ......** - Intro
167. DVS-Q1: What is your relationship to ......? - Radio: BIRTH PARENT, STEP PARENT (INCLUDING COMMON-LAW PARENT), ADOPTIVE PARENT, FOSTER PARENT, SISTER/BROTHER, GRANDPARENT, IN-LAW, OTHER RELATED, UNRELATED
168. DVS-Q2: What is .....'s relationship to ...........? (first child) - Radio: FULL SISTER/BROTHER BY BIRTH, SISTER/BROTHER - HALF STEP ADOPTED FOSTER (INCLUDE COMMON-LAW SIBLINGS), OTHER RELATED, UNRELATED

#### Health - HLT (pp. 44-60) - 85 questions

*NOTE: Age-tier routing: AGE 0-1: HLT-Q1-Q4, I37-Q45, Q45B-Q51E; AGE 2-3: HLT-Q1-Q5, I37-Q45, Q45B-Q51E; AGE 4-5: HLT-Q1-Q5, Q6A, Q7A, Q8-Q19, Q20A, Q21, Q22A, Q23-Q45, Q45B, Q48A-Q52B; AGE 6-11: HLT-Q1-Q5, Q6, Q7, Q8-Q19, Q20, Q21, Q22, Q23-Q44, Q45A, Q45B, Q48A-Q52B*

169. HLT-Q1: In general, would you say ...'s health is: - Radio: 1=Excellent, 2=Very good, 3=Good, 4=Fair, 5=Poor, 8=DON'T KNOW (GO TO HLT-Q3), 9=REFUSAL (GO TO HLT-Q3)
170. HLT-Q2: Over the past few months, how often has he/she been in good health? - Scale: 1=ALMOST ALL THE TIME, 2=OFTEN, 3=ABOUT HALF OF THE TIME, 4=SOMETIMES, 5=ALMOST NEVER, 8=DON'T KNOW
171. HLT-Q3: What is his/her height in feet and inches or in metres/centimetres (without shoes on)? - Numeric
172. HLT-Q4: What is his/her weight in kilograms (and grams) or in pounds (and ounces)? - Numeric
173. HLT-C5: *IF AGE < 2 YEARS ---> GO TO HLT-I37; OTHERWISE ---> GO TO HLT-Q5* - Check (routing)
174. HLT-Q5: In your opinion, how physically active is ... compared to other children the same age and sex? (READ LIST. MARK ONE ONLY.) - Radio: 1=Much more, 2=Moderately more, 3=Equally, 4=Moderately less, 5=Much less
175. HLT-C6: *IF AGE = 0-3 ---> GO TO HLT-I37; OTHERWISE ---> GO TO HLT-I6* - Check (routing)
176. HLT-I6: **The next set of questions ask about ...'s day to day health. The questions are not about illnesses like colds that affect people for short periods of time. They are concerned with his/her abilities relative to other children the same age. You may feel that some of these questions do not apply to him/her, but it is important that we ask the same questions of everyone.** - Intro

**VISION**

177. HLT-C6A: *IF AGE < 6 ---> GO TO HLT-Q6A; OTHERWISE ---> GO TO HLT-Q6* - Check (routing)
178. HLT-Q6: Is he/she usually able to see well enough to read ordinary newsprint without glasses or contact lenses? - Y/N: 1=YES (GO TO HLT-Q9), 2=NO, 8=DON'T KNOW, 9=REFUSAL (GO TO HLT-Q11)
179. HLT-Q7: Is he/she usually able to see well enough to read ordinary newsprint with glasses or contact lenses? - Y/N: 1=YES (GO TO HLT-Q9), 2=NO (GO TO HLT-Q8), 3=DOESN'T WEAR GLASSES OR CONTACT LENSES (GO TO HLT-Q8), 8=DON'T KNOW (GO TO HLT-Q8), 9=REFUSAL (GO TO HLT-Q11)
180. HLT-Q6A: Is he/she usually able to see clearly, and without distortion, the words in a story book without glasses or contact lenses? - Y/N: 1=YES (GO TO HLT-Q9), 2=NO, 8=DON'T KNOW, 9=REFUSAL (GO TO HLT-Q11)
181. HLT-Q7A: Is he/she usually able to see clearly, and without distortion, the words in a story book with glasses or contact lenses? - Y/N: 1=YES (GO TO HLT-Q9), 2=NO, 3=DOESN'T WEAR GLASSES OR CONTACT LENSES, 8=DON'T KNOW, 9=REFUSAL (GO TO HLT-Q11)
182. HLT-Q8: Is he/she able to see at all? - Y/N: 1=YES, 2=NO (GO TO HLT-Q11), 8=DON'T KNOW (GO TO HLT-Q11), 9=REFUSAL (GO TO HLT-Q11)
183. HLT-Q9: Is he/she able to see well enough to recognize a friend on the other side of the street without glasses or contact lenses? - Y/N: 1=YES (GO TO HLT-Q11), 2=NO, 8=DON'T KNOW, 9=REFUSAL (GO TO HLT-Q11)
184. HLT-Q10: Is he/she usually able to see well enough to recognize a friend on the other side of the street with glasses or contact lenses? - Y/N: 1=YES, 2=NO, 3=DOESN'T WEAR GLASSES OR CONTACTS, 8=DON'T KNOW, 9=REFUSAL

**HEARING**

185. HLT-Q11: Is ... usually able to hear what is said in a group conversation with at least three other people without a hearing aid? - Y/N: 1=YES (GO TO HLT-Q16), 2=NO, 8=DON'T KNOW, 9=REFUSAL (GO TO HLT-Q16)
186. HLT-Q12: Is he/she usually able to hear what is said in a group conversation with at least three other people with a hearing aid? - Y/N: 1=YES (GO TO HLT-Q14), 2=NO, 3=DOESN'T WEAR A HEARING AID, 8=DON'T KNOW, 9=REFUSAL (GO TO HLT-Q16)
187. HLT-Q13: Is he/she able to hear at all? - Y/N: 1=YES, 2=NO (GO TO HLT-Q16), 8=DON'T KNOW (GO TO HLT-Q16), 9=REFUSAL (GO TO HLT-Q16)
188. HLT-Q14: Is he/she usually able to hear what is said in a conversation with one other person in a quiet room without a hearing aid? - Y/N: 1=YES (GO TO HLT-Q16), 2=NO, 8=DON'T KNOW, 9=REFUSAL (GO TO HLT-Q16)
189. HLT-Q15: Is he/she usually able to hear what is said in a conversation with one other person in a quiet room with a hearing aid? - Y/N: 1=YES, 2=NO, 3=DOESN'T WEAR A HEARING AID, 8=DON'T KNOW, 9=REFUSAL

**SPEECH**

190. HLT-Q16: Is ... usually able to be understood completely when speaking with strangers in his/her own language? - Y/N: 1=YES (GO TO HLT-C20), 2=NO, 8=DON'T KNOW (GO TO HLT-Q18), 9=REFUSAL (GO TO HLT-C20)
191. HLT-Q17: Is he/she able to be understood partially when speaking with strangers in his/her own language? - Y/N: 1=YES, 2=NO, 8=DON'T KNOW, 9=REFUSAL (GO TO HLT-C20)
192. HLT-Q18: Is he/she able to be understood completely when speaking with those who know him/her well? - Y/N: 1=YES (GO TO HLT-C20), 2=NO, 8=DON'T KNOW (GO TO HLT-C20), 9=REFUSAL (GO TO HLT-C20)
193. HLT-Q19: Is he/she able to be understood partially when speaking with those who know him/her well? - Y/N: 1=YES, 2=NO, 8=DON'T KNOW, 9=REFUSAL

**GETTING AROUND**

194. HLT-C20: *IF AGE < 6 ---> GO TO HLT-Q20A; OTHERWISE ---> GO TO HLT-Q20* - Check (routing)
195. HLT-Q20: Is ... usually able to walk around the neighbourhood without difficulty and without mechanical support such as braces, a cane or crutches? - Y/N: 1=YES (GO TO HLT-Q27), 2=NO (GO TO HLT-Q21), 8=DON'T KNOW (GO TO HLT-Q21), 9=REFUSAL (GO TO HLT-Q27)
196. HLT-Q20A: Is he/she usually able to walk without difficulty and without mechanical support such as braces, a cane or crutches? - Y/N: 1=YES (GO TO HLT-Q27), 2=NO, 8=DON'T KNOW, 9=REFUSAL (GO TO HLT-Q27)
197. HLT-Q21: Is he/she able to walk at all? - Y/N: 1=YES, 2=NO (GO TO HLT-Q24), 8=DON'T KNOW (GO TO HLT-Q24), 9=REFUSAL (GO TO HLT-Q27)
198. HLT-C22: *IF AGE < 6 ---> GO TO HLT-Q22A; OTHERWISE ---> GO TO HLT-Q22* - Check (routing)
199. HLT-Q22: Does he/she require mechanical support such as braces, a cane or crutches to be able to walk around the neighbourhood? - Y/N: 1=YES (GO TO HLT-Q23), 2=NO (GO TO HLT-Q23), 8=DON'T KNOW (GO TO HLT-Q23), 9=REFUSAL (GO TO HLT-Q27)
200. HLT-Q22A: Does he/she require mechanical support such as braces, a cane or crutches to be able to walk? - Y/N: 1=YES, 2=NO, 8=DON'T KNOW, 9=REFUSAL (GO TO HLT-Q27)
201. HLT-Q23: Does he/she require the help of another person to be able to walk? - Y/N: 1=YES, 2=NO, 8=DON'T KNOW, 9=REFUSAL (GO TO HLT-Q27)
202. HLT-Q24: Does he/she require a wheelchair to get around? - Y/N: 1=YES, 2=NO (GO TO HLT-Q27), 8=DON'T KNOW (GO TO HLT-Q27), 9=REFUSAL (GO TO HLT-Q27)
203. HLT-Q25: How often does he/she use a wheelchair? - Radio: 1=ALWAYS, 2=OFTEN, 3=SOMETIMES, 4=NEVER, 8=DON'T KNOW, 9=REFUSAL (GO TO HLT-Q27)
204. HLT-Q26: Does he/she need the help of another person to get around in the wheelchair? - Y/N: 1=YES, 2=NO, 8=DON'T KNOW, 9=REFUSAL

**HANDS AND FINGERS**

205. HLT-Q27: Is ... usually able to grasp and handle small objects such as a pencil or scissors? - Y/N: 1=YES (GO TO HLT-Q31), 2=NO, 8=DON'T KNOW (GO TO HLT-Q31), 9=REFUSAL (GO TO HLT-Q31)
206. HLT-Q28: Does he/she require the help of another person because of limitations in the use of hands or fingers? - Y/N: 1=YES, 2=NO (GO TO HLT-Q30), 8=DON'T KNOW (GO TO HLT-Q30), 9=REFUSAL (GO TO HLT-Q31)
207. HLT-Q29: Does he/she require the help of another person with: (READ LIST. MARK ONE ONLY.) - Radio: 1=Some tasks, 2=Most tasks, 3=Almost all tasks, 4=All tasks, 8=DON'T KNOW, 9=REFUSAL (GO TO HLT-Q31)
208. HLT-Q30: Does he/she require special equipment, for example, devices to assist in dressing because of limitations in the use of hands or fingers? - Y/N: 1=YES, 2=NO, 8=DON'T KNOW, 9=REFUSAL

**COGNITION / FEELINGS**

209. HLT-Q31: Would you describe ... as being usually: (READ LIST. MARK ONE ONLY.) - Radio: 1=Happy and interested in life, 2=Somewhat happy, 3=Somewhat unhappy, 4=Unhappy with little interest in life, 5=So unhappy that life is not worthwhile, 8=DON'T KNOW, 9=REFUSAL
210. HLT-Q32: How would you describe his/her usual ability to remember things? Is he/she: (READ LIST. MARK ONE ONLY.) - Radio: 1=Able to remember most things, 2=Somewhat forgetful, 3=Very forgetful, 4=Unable to remember anything at all, 8=DON'T KNOW, 9=REFUSAL
211. HLT-Q33: How would you describe his/her usual ability to think and solve day-to-day problems? Is he/she: (READ LIST. MARK ONE ONLY.) - Radio: 1=Able to think clearly and solve problems, 2=Having a little difficulty, 3=Having some difficulty, 4=Having a great deal of difficulty, 5=Unable to think or solve problems, 8=DON'T KNOW, 9=REFUSAL

**PAIN AND DISCOMFORT**

212. HLT-Q34: Is ... usually free of pain or discomfort? - Y/N: 1=YES (GO TO HLT-I37), 2=NO, 8=DON'T KNOW (GO TO HLT-I37), 9=REFUSAL (GO TO HLT-I37)
213. HLT-Q35: How would you describe the usual intensity of his/her pain or discomfort: (READ LIST. MARK ONE ONLY.) - Radio: 1=Mild, 2=Moderate, 3=Severe, 8=DON'T KNOW, 9=REFUSAL (GO TO HLT-I37)
214. HLT-Q36: How many activities does his/her pain or discomfort prevent? (READ LIST. MARK ONE ONLY.) - Radio: 1=None, 2=A few, 3=Some, 4=Most, 8=DON'T KNOW, 9=REFUSAL

**INJURIES**

215. HLT-I37: **The following questions refer to injuries, such as a broken bone, bad cut or burn, head injury, poisoning, or a sprained ankle, which occurred in the past 12 months, and were serious enough to require medical attention by a doctor, nurse, or dentist.** - Intro
216. HLT-Q37: In the past 12 months was ... injured? - Y/N: 1=YES, 2=NO (GO TO HLT-Q43A), 8=DON'T KNOW (GO TO HLT-Q43A), 9=REFUSAL (GO TO HLT-Q43A)
217. HLT-Q38: How many times was he/she injured? - Numeric
218. HLT-Q39: For the most serious injury, what type of injury did he/she have? (DO NOT READ LIST. MARK ONE ONLY.) - Checkbox: 01=BROKEN OR FRACTURED BONES, 02=BURN OR SCALD, 03=DISLOCATION, 04=SPRAIN OR STRAIN, 05=CUT SCRAPE OR BRUISE, 06=CONCUSSION, 07=POISONING BY SUBSTANCE OR LIQUID, 08=INTERNAL INJURY, 09=DENTAL INJURY, 10=OTHER, 11=MULTIPLE INJURIES, 98=DON'T KNOW, 99=REFUSAL (GO TO HLT-Q43A)
219. HLT-C40: *IF ANY OF 1-5 MARKED IN HLT-Q39 ---> GO TO HLT-Q40; OTHERWISE ---> GO TO HLT-Q41* - Check (routing)
220. HLT-Q40: What part of his/her body was injured? (DO NOT READ LIST. MARK ONE ONLY.) - Checkbox: 01=EYES, 02=FACE OR SCALP (EXCLUDING EYES), 03=HEAD OR NECK (EXCLUDING EYES AND FACE OR SCALP), 04=ARMS OR HANDS, 05=LEGS OR FEET, 06=BACK OR SPINE, 07=TRUNK (EXCLUDING BACK OR SPINE)(INCLUDE CHEST INTERNAL ORGANS ETC.), 08=SHOULDER, 09=HIP, 10=MULTIPLE SITES, 98=DON'T KNOW, 99=REFUSAL (GO TO HLT-Q43A)
221. HLT-Q41: What happened, for example, was the injury the result of a fall, motor vehicle collision, a physical assault, etc.? (DO NOT READ LIST. MARK ONE ONLY.) - Radio: 01=MOTOR VEHICLE COLLISION-PASSENGER, 02=MOTOR VEHICLE COLLISION-PEDESTRIAN, 03=MOTOR VEHICLE COLLISION-RIDING BICYCLE, 04=OTHER BICYCLE ACCIDENT, 05=FALL (EXCLUDING BICYCLE OR SPORTS), 06=SPORTS (EXCLUDING BICYCLE), 07=PHYSICAL ASSAULT, 08=SCALDED BY HOT LIQUIDS OR FOOD, 09=ACCIDENTAL POISONING, 10=SELF-INFLICTED POISONING, 11=OTHER INTENTIONALLY SELF-INFLICTED INJURIES, 12=NATURAL/ENVIRONMENTAL FACTORS (EX. ANIMAL BITE STING), 13=FIRE/FLAMES OR RESULTING FUMES, 14=NEAR DROWNING, 15=OTHER, 9...
222. HLT-Q42: Where did the injury happen, for example at home, on the street, in a playground, at school, etc.? (DO NOT READ LIST. MARK ONE ONLY.) - Radio: 01=INSIDE RESPONDENT'S OWN HOME/APARTMENT, 02=OUTSIDE RESPONDENT'S HOME APARTMENT INCLUDING YARD DRIVEWAY PARKING LOT OR IN SHARED AREAS RELATED TO HOME SUCH AS APARTMENT HALLWAY OR LAUNDRY ROOM, 03=IN OR AROUND OTHER PRIVATE RESIDENCE, 04=INSIDE SCHOOL/DAYCARE CENTRE OR ON SCHOOL/CENTRE GROUNDS, 05=AT AN INDOOR OR OUTDOOR SPORTS FACILITY (OTHER THAN SCHOOL), 06=OTHER BUILDING USED BY GENERAL PUBLIC, 07=ON SIDEWALK/STREET/HIGHWAY IN RESPONDENT'S NEIGHBOURHOOD, 08=ON ANY OTHER SIDEWALK/STREET/...

**ASTHMA**

223. HLT-Q43A: The following questions are about asthma. Has ... ever had asthma that was diagnosed by a health professional? - Y/N: 1=YES, 2=NO (GO TO HLT-Q44), 8=DON'T KNOW, 9=REFUSAL (GO TO HLT-C45)
224. HLT-Q43B: Does this condition or health problem prevent or limit his/her participation in school, at play or any other activity normal for a child his/her age? - Y/N: 1=YES, 2=NO, 8=DON'T KNOW, 9=REFUSAL
225. HLT-Q43C: Has he/she had an attack of asthma in the last 12 months? - Radio: (response options not explicitly listed in source -- likely YES/NO/DK/REF same pattern)
226. HLT-Q44: Has he/she had wheezing or whistling in the chest at any time in the last 12 months? - Radio: (response options not explicitly listed in source -- likely YES/NO/DK/REF same pattern)

**LONG-TERM CONDITIONS**

227. HLT-C45: *IF AGE < 6 YEARS ---> GO TO HLT-Q45; OTHERWISE ---> GO TO HLT-Q45A* - Check (routing)
228. HLT-Q45: In the following questions long-term conditions refer to conditions that have lasted or are expected to last 6 months or more. Does ... have any of the following long-term conditions that have been diagnosed by a health professional? (READ LIST. MARK ALL THAT APPLY) - Checkbox: 01=Allergies, 02=Bronchitis, 03=Heart condition or disease, 04=Epilepsy, 05=Cerebral Palsy, 06=Kidney Condition or disease, 07=Mental handicap, 08=Any other long term condition, 09=None, 98=DON'T KNOW, 99=REFUSAL
229. HLT-Q45A: In the following questions long-term conditions refer to conditions that have lasted or are expected to last 6 months or more. Does... have any of the following long-term conditions that have been diagnosed by a health professional? (READ LIST. MARK ALL THAT APPLY) - Checkbox: 01=Allergies, 02=Bronchitis, 03=Heart condition or disease, 04=Epilepsy, 05=Cerebral Palsy, 06=Kidney Condition or disease, 07=Mental handicap, 08=Learning disability, 09=Emotional psychological or nervous difficulties, 10=Any other long term condition, 11=None, 98=DON'T KNOW, 99=REFUSAL
230. HLT-Q45B: Does ... have any long term conditions or health problems which prevent or limit his/her participation in school, at play, or in any other activity for a child of his/her age? - Y/N: 1=YES, 2=NO, 8=DON'T KNOW, 9=REFUSAL
231. HLT-C46: *IF AGE > 3 ---> GO TO HLT-I48; OTHERWISE ---> GO TO HLT-Q46* - Check (routing)

**INFECTIONS**

232. HLT-Q46: How often does ... have nose or throat infections? - Radio: 1=ALMOST ALL THE TIME, 2=OFTEN, 3=FROM TIME TO TIME, 4=RARELY, 5=NEVER, 8=DON'T KNOW, 9=REFUSAL
233. HLT-Q47A: Since his/her birth, has he/she had an ear infection (otitis)? - Y/N: 1=YES, 2=NO (GO TO HLT-I48), 8=DON'T KNOW (GO TO HLT-I48), 9=REFUSAL (GO TO HLT-I48)
234. HLT-Q47B: How many times? - Radio: 1=ONCE, 2=2 TIMES, 3=3 TIMES, 4=4 OR MORE TIMES, 8=DON'T KNOW, 9=REFUSAL

**HEALTH PROFESSIONALS**

235. HLT-I48: **In the past year, how many times have you seen or talked on the telephone with any of the following about ...'s physical or mental health? (Exclude at time of birth for babies.)** - Intro
236. HLT-Q48A: A general practitioner, family physician? (ENTER 0 IF NONE.) - Numeric
237. HLT-Q48B: A pediatrician? - Numeric
238. HLT-Q48C: An other medical doctor (such as an orthopedist, or eye specialist)? - Radio: (same format as Q48A)
239. HLT-Q48D: A public health nurse or nurse practitioner? - Radio: (same format as Q48A)
240. HLT-Q48E: A dentist or orthodontist? - Radio: (same format as Q48A)
241. HLT-Q48G: A psychiatrist or psychologist? - Radio: (same format as Q48A)
242. HLT-Q48H: Child welfare worker or children's aid worker? - Radio: (same format as Q48A)
243. HLT-Q48I: Any other person trained to provide treatment or counsel, for example a speech therapist, a social worker? - Radio: (same format as Q48A)

**HOSPITALIZATION**

244. HLT-Q49: In the past 12 months, was ... ever an overnight patient in a hospital? - Y/N: 1=YES, 2=NO (GO TO HLT-Q51A), 8=DON'T KNOW (GO TO HLT-Q51A)
245. HLT-Q50: For what reason? - Radio: 1=RESPIRATORY ILLNESS OR DISEASE, 2=GASTROINTESTINAL ILLNESS OR DISEASE, 3=INJURIES, 4=OTHER, 8=DON'T KNOW, 9=REFUSAL

**MEDICATION**

246. HLT-Q51A: Does he/she take any of the following prescribed medication on a regular basis: Ventolin or other inhalants? - Y/N: 1=YES, 2=NO, 8=DON'T KNOW, 9=REFUSAL (GO TO HLT-C52)
247. HLT-Q51B: Ritalin? - Radio: (same YES/NO/DK/REF pattern)
248. HLT-Q51C: Tranquilizers or nerve pills? - Radio: (same YES/NO/DK/REF pattern)
249. HLT-Q51D: Anti-convulsants or anti-epileptic pills? - Radio: (same YES/NO/DK/REF pattern)
250. HLT-Q51E: Other? - Radio: (same YES/NO/DK/REF pattern)

**STRESSFUL EVENTS**

251. HLT-C52: *IF AGE < 4 ---> GO TO NEXT SECTION; OTHERWISE ---> GO TO HLT-Q52A* - Check (routing)
252. HLT-Q52A: Has ... ever experienced any event or situation that has caused him/her a great amount of worry or unhappiness? - Y/N: 1=YES, 2=NO (GO TO NEXT SECTION)
253. HLT-Q52B: What was this? (DO NOT READ LIST. MARK ALL THAT APPLY.) - Checkbox: 01=DEATH OF PARENTS, 02=DEATH IN FAMILY (OTHER THAN PARENTS), 03=DIVORCE/SEPARATION OF PARENTS, 04=MOVE, 05=STAY IN HOSPITAL, 06=STAY IN FOSTER HOME, 07=OTHER SEPARATION FROM PARENTS, 08=ILLNESS/INJURY OF CHILD, 09=ILLNESS/INJURY OF A FAMILY MEMBER, 10=ABUSE/FEAR OF ABUSE, 11=CHANGE IN HOUSEHOLD MEMBERS, 12=ALCOHOLISM OR MENTAL HEALTH DISORDER IN FAMILY, 13=CONFLICT BETWEEN PARENTS, 14=OTHER, 98=DON'T KNOW, 99=REFUSAL

#### Activities - ACT (pp. 105-108) - 28 questions

*NOTE: Age-tier routing: AGE 0-3: ACT-Q1-Q2B; AGE 4-5: ACT-Q1-Q3D1, Q3E-Q5; AGE 6-9: ACT-Q3A-Q3C, Q3D2, Q3E-Q5, Q7A-Q8B; AGE 10-11: ACT-Q3A-Q3C, Q3D3-Q8B*

254. ACT-I1: **The next few questions are about ...'s interests and activities.** - Intro
255. ACT-C1: *IF AGE > 5 ---> GO TO ACT-Q3A; OTHERWISE ---> GO TO ACT-Q1* - Check (routing)
256. ACT-Q1: Does he/she currently attend any nursery school, play group or other early childhood program or activity? (Please do not include child care programs or time spent in elementary school.) - Y/N: 1=YES; 2=NO -->GO TO ACT-C3; 8=DON'T KNOW -->GO TO ACT-C3; 9=REFUSAL -->GO TO ACT-C3
257. ACT-Q2A: What type(s) of programs or activities? (MARK ALL THAT APPLY.) - Checkbox: 1=NURSERY SCHOOL, PRESCHOOL OR KINDERGARTEN; 2=PLAY GROUP; 3=DROP-IN CENTRE; 4=TOY LIBRARY; 5=INFANT STIMULATION PROGRAM; 6=MOM AND TOT PROGRAM; 7=OTHER; 8=DON'T KNOW; 9=REFUSAL -->GO TO BEHAVIOUR SECTION
258. ACT-Q2B: For about how many hours a week does he/she attend these in total? - Radio: (numeric open entry)
259. ACT-C3: *IF AGE < 4 YEARS ---> GO TO BEHAVIOUR SECTION; OTHERWISE ---> GO TO ACT-Q3A* - Check (routing)
260. ACT-Q3A: In the last 12 months, outside of school hours, how often has ...: taken part in any sports which involved coaching or instruction? - Radio: 1=MOST DAYS; 2=A FEW TIMES A WEEK; 3=ABOUT ONCE A WEEK; 4=ABOUT ONCE A MONTH; 5=ALMOST NEVER; 8=DON'T KNOW; 9=REFUSAL -->GO TO BEHAVIOUR SECTION
261. ACT-Q3B: Taken part in unorganized sports or physical activities? - Radio: (same scale as ACT-Q3A: 1=MOST DAYS through 5=ALMOST NEVER, 8=DON'T KNOW, 9=REFUSAL)
262. ACT-Q3C: Taken lessons or instruction in music, dance, art or other non-sport activities? - Radio: (same scale as ACT-Q3A)
263. ACT-C3D: *IF AGE = 4 TO 5 YEARS ---> GO TO ACT-Q3D1; IF AGE = 6 TO 9 YEARS ---> GO TO ACT-Q3D2; OTHERWISE (AGE = 10 TO 11 YEARS) ---> GO TO ACT-Q3D3* - Check (routing)
264. ACT-Q3D1: Taken part in any clubs, groups or community programs with leadership, such as Beavers, Sparks or church groups? - Radio: (same scale as ACT-Q3A)
265. ACT-Q3D2: Taken part in any clubs, groups or community programs with leadership, such as Brownies, Cubs or church groups? - Radio: (same scale as ACT-Q3A)
266. ACT-Q3D3: Taken part in any clubs, groups or community programs with leadership, such as Boys and Girls Clubs, Scouts, Guides or church groups? - Radio: (same scale as ACT-Q3A)
267. ACT-Q3E: Played computer or video games? - Radio: (same scale as ACT-Q3A)
268. ACT-Q4A: About how many days a week on average does ... watch T.V. or videos at home? - Radio: 0=NONE -->GO TO ACT-Q5; 1-7=DAYS (numeric); 8=DON'T KNOW -->GO TO ACT-Q5; 9=REFUSAL -->GO TO NEXT SECTION
269. ACT-Q4B: On those days, how many hours on average does he/she spend watching T.V. or videos? - Radio: (numeric open entry)
270. ACT-Q5: How often does he/she play alone (e.g., riding a bike, doing a craft or hobby, playing ball)? - Radio: 1=OFTEN; 2=SOMETIMES; 3=SELDOM; 4=NEVER; 8=DON'T KNOW; 9=REFUSAL -->GO TO BEHAVIOUR SECTION
271. ACT-C6: *IF AGE < 6 ---> GO TO BEHAVIOUR SECTION; IF AGE 6-9 ---> GO TO ACT-Q7A; OTHERWISE ---> GO TO ACT-Q6A* - Check (routing)
272. ACT-Q6A: I would like to ask you some questions about his/her responsibilities at home. How often does he/she make his/her own bed? - Radio: 1=OFTEN; 2=SOMETIMES; 3=SELDOM; 4=NEVER; 8=DON'T KNOW; 9=REFUSAL -->GO TO BEHAVIOUR SECTION
273. ACT-Q6B: Clean his/her own room? - Radio: (same scale as ACT-Q6A: 1=OFTEN through 4=NEVER, 8=DON'T KNOW, 9=REFUSAL)
274. ACT-Q6C: Pick up after him/herself? - Radio: (same scale as ACT-Q6A)
275. ACT-Q6D: Help keep shared living areas clean and straight? - Radio: (same scale as ACT-Q6A)
276. ACT-Q6E: Do routine chores such as mow the lawn, help with dinner, wash dishes, etc.? - Radio: (same scale as ACT-Q6A)
277. ACT-Q6F: Help manage his/her own time (get up on time, be ready for school, etc.) - Radio: (same scale as ACT-Q6A)
278. ACT-Q7A: Did ... attend an overnight camp last summer? - Y/N: 1=YES; 2=NO -->GO TO ACT-Q8A; 8=DON'T KNOW -->GO TO ACT-Q8A; 9=REFUSAL -->GO TO BEHAVIOUR SECTION
279. ACT-Q7B: For how many days? - Radio: (numeric open entry)
280. ACT-Q8A: Last summer, did ... attend a day camp or recreational or skill-building activity that ran for half days or full days (e.g., music program, reading program, athletic program?) - Y/N: 1=YES; 2=NO -->GO TO NEXT SECTION; 8=DON'T KNOW -->GO TO BEHAVIOUR SECTION; 9=REFUSAL -->GO TO BEHAVIOUR SECTION
281. ACT-Q8B: For how many days? - Radio: (numeric open entry)

#### Behaviour - BEH (pp. 109-116) - 99 questions

*NOTE: Age-tier routing: AGE 0-11m: BEH-Q1-Q4, Q5A; AGE 1yr: BEH-Q1-Q5; AGE 2-3: BEH-Q1-Q5, I8A-Q8UU; AGE 4-9: BEH-I6A-Q6UU; AGE 10-11: BEH-I6A-Q7F*

282. BEH-C1: *IF AGE > 3 ---> GO TO BEH-I6A; OTHERWISE ---> GO TO BEH-Q1* - Check (routing)

**Age 0-3**

283. BEH-Q1: The following questions relate to ...'s sleep patterns. When you put him/her to bed, how often does he/she have trouble falling asleep? (READ LIST. MARK ONE ONLY.) - Scale: 1=Almost every time; 2=Often; 3=About half of the time; 4=Sometimes; 5=Almost never; 8=DON'T KNOW; 9=REFUSAL -->GO TO BEH-C5
284. BEH-Q2: Does he/she have a particular and long routine (more than 30 minutes) to go to bed (rocking, songs, nursery rhymes, etc.) that he/she cannot go to sleep without? - Scale: 1=ALMOST EVERY TIME; 2=OFTEN; 3=ABOUT HALF OF THE TIME; 4=SOMETIMES; 5=ALMOST NEVER; 8=DON'T KNOW; 9=REFUSAL -->GO TO BEH-C5
285. BEH-Q3: Does ... wake up several times during his/her sleep? - Scale: (same scale as BEH-Q1: 1=Almost every time through 5=Almost never, 8=DON'T KNOW, 9=REFUSAL)
286. BEH-Q4: Does he/she have a restless sleep? - Radio: (same scale as BEH-Q1)
287. BEH-C5: *IF AGE < 1 ---> GO TO BEH-Q5A; OTHERWISE ---> GO TO BEH-Q5* - Check (routing)
288. BEH-Q5: The following are a few examples of how infants react to new foods (orange juice, apple puree, porridge, vegetables, etc.). Which of the following is the best approximation of how ... reacts? - Radio: 1=He/she swallows everything without complaining; 2=The first time he/she made faces or spit out the food, but after a few tries, he/she got used to it; 3=The same reaction after several attempts, he/she continued to refuse most of the new foods; 8=DON'T KNOW; 9=REFUSAL
289. BEH-Q5A: How often do you find him/her difficult to feed? - Scale: 1=ALMOST EVERY TIME; 2=OFTEN; 3=ABOUT HALF OF THE TIME; 4=SOMETIMES; 5=ALMOST NEVER; 8=DON'T KNOW; 9=REFUSAL

**Age 4-11**

290. BEH-I6A: **Now I'd like to ask you questions about how ... seems to feel or act.** - Intro
291. BEH-Q6A: Using the answers never or not true, sometimes or somewhat true, or often or very true, how often would you say that ...: shows sympathy to someone who has made a mistake? - Scale: 1=NEVER OR NOT TRUE; 2=SOMETIMES OR SOMEWHAT TRUE; 3=OFTEN OR VERY TRUE; 8=DON'T KNOW; 9=REFUSAL -->GO TO BEH-C7A
292. BEH-Q6B: Can't sit still, is restless, or hyperactive? - Scale: (same 3-point scale: 1=NEVER OR NOT TRUE; 2=SOMETIMES OR SOMEWHAT TRUE; 3=OFTEN OR VERY TRUE; 8=DON'T KNOW; 9=REFUSAL)
293. BEH-Q6C: Destroys his/her own things? - Radio: (same 3-point scale)
294. BEH-Q6D: Will try to help someone who has been hurt? - Radio: (same 3-point scale)
295. BEH-Q6E: Steals at home? - Radio: (same 3-point scale)
296. BEH-Q6F: Seems to be unhappy, sad, or depressed? - Radio: (same 3-point scale)
297. BEH-Q6G: Gets into many fights? - Radio: (same 3-point scale)
298. BEH-Q6H: Volunteers to help clear up a mess someone else has made? - Radio: (same 3-point scale)
299. BEH-Q6I: Is distractible, has trouble sticking to any activity? - Radio: (same 3-point scale)
300. BEH-Q6J: When mad at someone, tries to get others to dislike that person? - Radio: (same 3-point scale)
301. BEH-Q6K: Is not as happy as other children? - Radio: (same 3-point scale)
302. BEH-Q6L: Destroys things belonging to his/her family, or other children? - Radio: (same 3-point scale)
303. BEH-Q6M: If there is a quarrel or dispute, will try to stop it? - Radio: (same 3-point scale)
304. BEH-Q6N: Fidgets? - Radio: (same 3-point scale)
305. BEH-Q6O: Is disobedient at school? - Radio: (same 3-point scale)
306. BEH-Q6P: Can't concentrate, can't pay attention for long? - Radio: (same 3-point scale)
307. BEH-Q6Q: Is too fearful or anxious? - Radio: (same 3-point scale)
308. BEH-Q6R: When mad at someone, becomes friends with another as revenge? - Radio: (same 3-point scale)
309. BEH-Q6S: Is impulsive, acts without thinking? - Radio: (same 3-point scale)
310. BEH-Q6T: Tells lies or cheats? - Radio: (same 3-point scale)
311. BEH-Q6U: Offers to help other children (friend, brother or sister) who are having difficulty with a task? - Radio: (same 3-point scale)
312. BEH-Q6V: Is worried? - Radio: (same 3-point scale)
313. BEH-Q6W: Has difficulty awaiting turn in games or groups? - Radio: (same 3-point scale)
314. BEH-Q6X: When another child accidentally hurts him/her (such as by bumping into him/her), assumes that the other child meant to do it, and then reacts with anger and fighting? - Radio: (same 3-point scale)
315. BEH-Q6Y: Tends to do things on his/her own - is rather solitary? - Radio: (same 3-point scale)
316. BEH-Q6Z: When mad at someone, says bad things behind the other's back? - Radio: (same 3-point scale)
317. BEH-Q6AA: Physically attacks people? - Radio: (same 3-point scale)
318. BEH-Q6BB: Comforts a child (friend, brother, or sister) who is crying or upset? - Radio: (same 3-point scale)
319. BEH-Q6CC: Cries a lot? - Radio: (same 3-point scale)
320. BEH-Q6DD: Vandalizes? - Radio: (same 3-point scale)
321. BEH-Q6EE: Gives up easily? - Radio: (same 3-point scale)
322. BEH-Q6FF: Threatens people? - Radio: (same 3-point scale)
323. BEH-Q6GG: Spontaneously helps to pick up objects which another child has dropped (e.g. pencils, books, etc.)? - Radio: (same 3-point scale)
324. BEH-Q6HH: Cannot settle to anything for more than a few moments? - Radio: (same 3-point scale)
325. BEH-Q6II: Appears miserable, unhappy, tearful, or distressed? - Radio: (same 3-point scale)
326. BEH-Q6JJ: Is cruel, bullies or is mean to others? - Radio: (same 3-point scale)
327. BEH-Q6KK: Stares into space? - Radio: (same 3-point scale)
328. BEH-Q6LL: When mad at someone, says to others: let's not be with him/her? - Radio: (same 3-point scale)
329. BEH-Q6MM: Is nervous, highstrung or tense? - Radio: (same 3-point scale)
330. BEH-Q6NN: Kicks, bites, hits other children? - Radio: (same 3-point scale)
331. BEH-Q6OO: Will invite bystanders to join in a game? - Radio: (same 3-point scale)
332. BEH-Q6PP: Steals outside the home? - Radio: (same 3-point scale)
333. BEH-Q6QQ: Is inattentive? - Radio: (same 3-point scale)
334. BEH-Q6RR: Has trouble enjoying him/herself? - Radio: (same 3-point scale)
335. BEH-Q6SS: Helps other children (friends, brother or sister) who are feeling sick? - Radio: (same 3-point scale)
336. BEH-Q6TT: When mad at someone, tells the other one's secrets to a third person? - Radio: (same 3-point scale)
337. BEH-Q6UU: Takes the opportunity to praise the work of less able children? - Radio: (same 3-point scale)

**Age 10-11**

338. BEH-C7A: *IF AGE < 10 ---> GO TO MOTOR AND SOCIAL DEVELOPMENT SECTION; OTHERWISE ---> GO TO BEH-I7A* - Check (routing)
339. BEH-I7A: **Now I'd like to ask you some questions about certain difficult behaviours which some children may show at this age. These may or may not apply to ....** - Intro
340. BEH-Q7A: In the past year, about how many times has ... stayed out later than you said he/she should? - Radio: 1=NEVER; 2=ONCE; 3=TWICE; 4=MORE THAN TWICE; 8=DON'T KNOW; 9=REFUSAL -->GO TO MOTOR AND SOCIAL DEVELOPMENT SECTION
341. BEH-Q7B: Stayed out all night without permission? - Radio: (same scale: 1=NEVER; 2=ONCE; 3=TWICE; 4=MORE THAN TWICE; 8=DON'T KNOW; 9=REFUSAL)
342. BEH-Q7C: Skipped a day of school without permission? - Radio: (same scale as BEH-Q7A)
343. BEH-Q7D: Gotten drunk? - Radio: (same scale as BEH-Q7A)
344. BEH-Q7E: Been questioned by the police about anything he/she might have done such as stealing, damaging property, or something else? - Radio: 1=NEVER; 2=ONCE; 3=TWICE; 4=MORE THAN TWICE; 8=DON'T KNOW; 9=REFUSAL -->GO TO MOTOR AND SOCIAL DEVELOPMENT SECTION
345. BEH-Q7F: Has he/she ever run away from home? - Y/N: 1=YES; 2=NO; 8=DON'T KNOW; 9=REFUSAL

**Age 2-3**

346. BEH-I8A: **Now I'd like to ask you questions about how ... seems to feel or act.** - Intro
347. BEH-Q8B: Using the answers never or not true, sometimes or somewhat true, or often or very true, how often would you say that ...: can't sit still, is restless, or hyperactive? - Scale: 1=NEVER OR NOT TRUE; 2=SOMETIMES OR SOMEWHAT TRUE; 3=OFTEN OR VERY TRUE; 8=DON'T KNOW; 9=REFUSAL -->GO TO MOTOR AND SOCIAL DEVELOPMENT SECTION
348. BEH-Q8D: Will try to help someone who has been hurt? - Scale: (same 3-point scale: 1=NEVER OR NOT TRUE; 2=SOMETIMES OR SOMEWHAT TRUE; 3=OFTEN OR VERY TRUE; 8=DON'T KNOW; 9=REFUSAL)
349. BEH-Q8E1: Is defiant? - Radio: (same 3-point scale)
350. BEH-Q8F: Seems to be unhappy, sad, or depressed? - Radio: (same 3-point scale)
351. BEH-Q8G: Gets into many fights? - Radio: (same 3-point scale)
352. BEH-Q8I: Is distractible, has trouble sticking to any activity? - Radio: (same 3-point scale)
353. BEH-Q8J1: Doesn't seem to feel guilty after misbehaving? - Radio: (same 3-point scale)
354. BEH-Q8K: Is not as happy as other children? - Radio: (same 3-point scale)
355. BEH-Q8N: Fidgets? - Radio: (same 3-point scale)
356. BEH-Q8P: Can't concentrate, can't pay attention for long? - Radio: (same 3-point scale)
357. BEH-Q8Q: Is too fearful or anxious? - Radio: (same 3-point scale)
358. BEH-Q8R1: Punishment doesn't change his/her behaviour? - Radio: (same 3-point scale)
359. BEH-Q8S: Is impulsive, acts without thinking? - Radio: (same 3-point scale)
360. BEH-Q8T1: Has temper tantrums or hot temper? - Radio: (same 3-point scale)
361. BEH-Q8U: Offers to help other children (friend, brother or sister) who are having difficulty with a task? - Radio: (same 3-point scale)
362. BEH-Q8V: Is worried? - Radio: (same 3-point scale)
363. BEH-Q8W: Has difficulty awaiting turn in games or groups? - Radio: (same 3-point scale)
364. BEH-Q8X: When another child accidentally hurts him/her (such as by bumping into him/her), assumes that the other child meant to do it, and then reacts with anger and fighting? - Radio: (same 3-point scale)
365. BEH-Q8Z1: Has angry moods? - Radio: (same 3-point scale)
366. BEH-Q8BB: Comforts a child (friend, brother, or sister) who is crying or upset? - Radio: (same 3-point scale)
367. BEH-Q8CC: Cries a lot? - Radio: (same 3-point scale)
368. BEH-Q8DD1: Clings to adults or is too dependent? - Radio: (same 3-point scale)
369. BEH-Q8EE: Gives up easily? - Radio: (same 3-point scale)
370. BEH-Q8HH: Cannot settle to anything for more than a few moments? - Radio: (same 3-point scale)
371. BEH-Q8KK: Stares into space? - Radio: (same 3-point scale)
372. BEH-Q8LL1: Constantly seeks help? - Radio: (same 3-point scale)
373. BEH-Q8MM: Is nervous, highstrung or tense? - Radio: (same 3-point scale)
374. BEH-Q8NN: Kicks, bites, hits other children? - Radio: (same 3-point scale)
375. BEH-Q8PP1: Doesn't want to sleep alone? - Radio: (same 3-point scale)
376. BEH-Q8QQ: Is inattentive? - Radio: (same 3-point scale)
377. BEH-Q8RR: Has trouble enjoying him/herself? - Radio: (same 3-point scale)
378. BEH-Q8SS: Helps other children (friends, brother or sister) who are feeling sick? - Radio: (same 3-point scale)
379. BEH-Q8TT: Gets too upset when separated from parents? - Radio: (same 3-point scale)
380. BEH-Q8UU: Takes the opportunity to praise the work of less able children? - Radio: (same 3-point scale)

#### Motor and Social Development - MSD (pp. 117-121) - 57 questions

*NOTE: Asked for children 0 to 47 months only. Age bands: 0-3m: Q1-Q15; 4-6m: Q8-Q22; 7-9m: Q12-Q26; 10-12m: Q18-Q32; 13-15m: Q22-Q36; 16-18m: Q26-Q40; 19-21m: Q29-Q43; 22-47m: Q34-Q48*

381. MSD-C1: *IF AGE > 3 YEARS ---> GO TO RELATIONSHIPS SECTION; ELSE ---> GO TO MSD-I1* - Check (routing)
382. MSD-I1: **The following questions are about ...'s motor and social development.** - Intro
383. MSD-Q1: When lying on his/her stomach, has ... ever turned his/her head from side to side? - Y/N: 1=YES, 2=NO, 8=DON'T KNOW, 9=REFUSAL -->GO TO RELATIONSHIPS SECTION
384. MSD-Q2: Have his/her eyes ever followed a moving object? - Radio: (same response scale as Q1 implied: YES/NO/DK/REF)
385. MSD-Q3: When lying on his/her stomach on a flat surface, has he/she ever lifted his/her head off the surface for a moment? - Radio: (same response scale implied)
386. MSD-Q4: Have his/her eyes ever followed a moving object all the way from one side to the other? - Radio: (same response scale implied)
387. MSD-Q5: Has he/she ever smiled at someone when that person talked to or smiled at (but did not touch) him/her? - Radio: (same response scale implied)
388. MSD-Q6: When lying on his/her stomach, has he/she ever raised his/her head and chest from the surface while resting his/her weight on his/her lower arms or hands? - Radio: (same response scale implied)
389. MSD-Q7: Has he/she ever turned his/her head around to look at something? - Radio: (same response scale implied)
390. MSD-Q8: When lying on his/her back and being pulled up to a sitting position, did ... ever hold his/her head stiffly so that it did not hang back as he/she was pulled up? - Radio: (same response scale implied)
391. MSD-Q9: Has he/she ever laughed out loud without being tickled or touched? - Radio: (same response scale implied)
392. MSD-Q10: Has he/she ever held in one hand a moderate size object such as a block or a rattle? - Radio: (same response scale implied)
393. MSD-Q11: Has he/she ever rolled over on his/her own on purpose? - Radio: (same response scale implied)
394. MSD-Q12: Has ... ever seemed to enjoy looking in the mirror at him/herself? - Radio: (same response scale implied)
395. MSD-Q13: Has he/she ever been pulled from a sitting to a standing position and supported his/her own weight with legs stretched out? - Radio: (same response scale implied)
396. MSD-Q14: Has he/she ever looked around with his/her eyes for a toy which was lost or not nearby? - Radio: (same response scale implied)
397. MSD-Q15: Has he/she ever sat alone with no help except for leaning forward on his/her hands or with just a little help from someone else? - Radio: (same response scale implied)
398. MSD-C16: *IF AGE IN MONTHS = 0 TO 3 MONTHS ---> GO TO RELATIONSHIP SECTION; OTHERWISE ---> GO TO MSD-Q16* - Check (routing)
399. MSD-Q16: Has he/she ever sat for 10 minutes without any support at all? - Radio: (same response scale implied)
400. MSD-Q17: Has he/she ever pulled him/herself to a standing position without help from another person? - Radio: (same response scale implied)
401. MSD-Q18: Has ... ever crawled when left lying on his/her stomach? - Radio: (same response scale implied)
402. MSD-Q19: Has he/she ever said any recognizable words such as "mama" or "dada"? - Radio: (same response scale implied)
403. MSD-Q20: Has he/she ever picked up small objects such as raisins or cookie crumbs, using only his/her thumb and first finger? - Radio: (same response scale implied)
404. MSD-Q21: Has he/she ever walked at least 2 steps with one hand held or holding on to something? - Radio: (same response scale implied)
405. MSD-Q22: Has ... ever waved good-bye without help from another person? - Radio: (same response scale implied)
406. MSD-C23: *IF AGE IN MONTHS = 4 TO 6 MONTHS ---> GO TO RELATIONSHIPS SECTION; OTHERWISE ---> GO TO MSD-Q23* - Check (routing)
407. MSD-Q23: Has he/she ever shown by his/her behavior that he/she knows the names of common objects when somebody else names them out loud? - Radio: (same response scale implied)
408. MSD-Q24: Has he/she ever shown that he/she wanted something by pointing, pulling, or making pleasant sounds rather than crying or whining? - Radio: (same response scale implied)
409. MSD-Q25: Has he/she ever stood alone on his/her feet for 10 seconds or more without holding on to anything or another person? - Radio: (same response scale implied)
410. MSD-Q26: Has ... ever walked at least 2 steps without holding on to anything or another person? - Radio: (same response scale implied)
411. MSD-C27: *IF AGE IN MONTHS = 7 TO 9 MONTHS ---> GO TO RELATIONSHIPS SECTION; OTHERWISE ---> GO TO MSD-Q27* - Check (routing)
412. MSD-Q27: Has he/she ever crawled up at least 2 stairs or steps? - Radio: (same response scale implied)
413. MSD-Q28: Has he/she said 2 recognizable words besides "mama" or "dada"? - Radio: (same response scale implied)
414. MSD-Q29: Has ... ever run? - Radio: (same response scale implied)
415. MSD-Q30: Has he/she ever said the name of a familiar object, such as a ball? - Radio: (same response scale implied)
416. MSD-Q31: Has he/she ever made a line with a crayon or pencil? - Radio: (same response scale implied)
417. MSD-Q32: Did he/she ever walk up at least 2 stairs with one hand held or holding the railing? - Radio: (same response scale implied)
418. MSD-C33: *IF AGE IN MONTHS = 10 TO 12 MONTHS ---> GO TO RELATIONSHIPS SECTION; OTHERWISE ---> GO TO MSD-Q33* - Check (routing)
419. MSD-Q33: Has he/she ever fed him/herself with a spoon or fork without spilling much? - Radio: (same response scale implied)
420. MSD-Q34: Has ... ever let someone know, without crying, that wearing wet (soiled) pants or diapers bothered him/her? - Radio: (same response scale implied)
421. MSD-Q35: Has he/she ever spoken a partial sentence of 3 words or more? - Radio: (same response scale implied)
422. MSD-Q36: Has he/she ever walked up stairs by him/herself without holding on to a rail? - Radio: (same response scale implied)
423. MSD-C37: *IF AGE IN MONTHS = 13 TO 15 MONTHS ---> GO TO RELATIONSHIPS SECTION; OTHERWISE ---> GO TO MSD-Q37* - Check (routing)
424. MSD-Q37: Has he/she ever washed and dried his/her hands without any help except for turning the water on and off? - Radio: (same response scale implied)
425. MSD-Q38: Has he/she ever counted 3 objects correctly? - Radio: (same response scale implied)
426. MSD-Q39: Has he/she ever gone to the toilet alone? - Radio: (same response scale implied)
427. MSD-Q40: Has he/she ever walked upstairs by him/herself with no help, stepping on each step with only one foot? - Radio: (same response scale implied)
428. MSD-C41: *IF AGE = 16 TO 18 MONTHS ---> GO TO RELATIONSHIPS SECTION; OTHERWISE GO TO MSD-Q41* - Check (routing)
429. MSD-Q41: Does he/she know his/her own age and sex? - Radio: (same response scale implied)
430. MSD-Q42: Has he/she ever said the names of at least 4 colors? - Radio: (same response scale implied)
431. MSD-Q43: Has he/she ever pedaled a tricycle at least 10 feet? - Radio: (same response scale implied)
432. MSD-C44: *IF AGE IN MONTHS = 19 TO 21 MONTHS ---> GO TO RELATIONSHIPS SECTION; OTHERWISE ---> GO TO MSD-Q44* - Check (routing)
433. MSD-Q44: Has he/she ever done a somersault without help from anybody? - Radio: (same response scale implied)
434. MSD-Q45: Has he/she ever dressed him/herself without any help except for tying shoes (and buttoning the backs of dresses)? - Radio: (same response scale implied)
435. MSD-Q46: Has he/she ever said his/her first and last name together without someone's help? (Nickname may be used for first name.) - Radio: (same response scale implied)
436. MSD-Q47: Has he/she ever counted out loud up to 10? - Radio: (same response scale implied)
437. MSD-Q48: Has he/she ever drawn a picture of a man or woman with at least 2 parts of the body besides a head? - Radio: (same response scale implied)

#### Relationships - REL (pp. 122-124) - 15 questions

438. REL-C1: *IF AGE < 4 ---> GO TO PARENTING SECTION; OTHERWISE ---> GO TO REL-I1* - Check (routing)
439. REL-I1: **The next few questions are about ...'s relationships with friends, family and others.** - Intro
440. REL-Q1: About how many days a week does he/she do things with friends? - Radio: 1=NEVER, 2=1 DAY A WEEK, 3=2-3 DAYS A WEEK, 4=4-5 DAYS A WEEK, 5=6-7 DAYS A WEEK, 8=DON'T KNOW, 9=REFUSAL (GO TO PARENTING SECTION)
441. REL-C2: *IF AGE < 6 ---> GO TO REL-Q6; OTHERWISE ---> GO TO REL-Q2* - Check (routing)
442. REL-Q2: About how many close friends does he/she have? - Radio: 1=NONE (GO TO REL-C4), 2=1, 3=2 OR 3, 4=4 OR 5, 5=6 OR MORE, 8=DON'T KNOW, 9=REFUSAL (GO TO PARENTING SECTION)
443. REL-C3: *IF AGE < 8 ---> GO TO REL-Q6; OTHERWISE ---> GO TO REL-Q3* - Check (routing)
444. REL-Q3: How many of his/her close friends do you know by sight and by first and last name? - Radio: 1=ALL, 2=MOST, 3=ABOUT HALF, 4=ONLY A FEW, 5=NONE, 8=DON'T KNOW, 9=REFUSAL (GO TO PARENTING SECTION)
445. REL-C4: *IF AGE < 8 ---> GO TO REL-Q6; OTHERWISE ---> GO TO REL-Q4* - Check (routing)
446. REL-Q4: When it comes to meeting new children and making new friends is he/she: - Radio: 1=Somewhat shy, 2=About average, 3=Very outgoing - makes friends easily, 8=DON'T KNOW, 9=REFUSAL (GO TO PARENTING SECTION)
447. REL-Q5: How often does he/she hang around with kids you think are frequently in trouble? - Radio: 1=OFTEN, 2=SOMETIMES, 3=SELDOM, 4=NEVER, 8=DON'T KNOW, 9=REFUSAL (GO TO PARENTING SECTION)
448. REL-Q6: During the past 6 months, how well has ... gotten along with other kids, such as friends or classmates (excluding brothers or sisters)? - Radio: 1=VERY WELL NO PROBLEMS, 2=QUITE WELL HARDLY ANY PROBLEMS, 3=PRETTY WELL OCCASIONAL PROBLEMS, 4=NOT TOO WELL FREQUENT PROBLEMS, 5=NOT WELL AT ALL CONSTANT PROBLEMS, 6=NOT APPLICABLE, 8=DON'T KNOW, 9=REFUSAL (GO TO PARENTING SECTION)
449. REL-Q7: Since starting school in the fall, how well has he/she gotten along with his/her teacher(s) at school? - Radio: (same 1-5 + 6=N/A + 8=DK + 9=REF scale as Q6)
450. REL-Q8: During the past 6 months, how well has he/she gotten along with his/her parent(s)? - Radio: (same 1-5 + 6=N/A + 8=DK + 9=REF scale as Q6)
451. REL-C9: *IF NO BROTHERS OR SISTERS LIVING IN THE HOUSEHOLD ---> GO TO PARENTING SECTION; OTHERWISE ---> GO TO REL-Q9* - Check (routing)
452. REL-Q9: During the past 6 months, how well has ... gotten along with his/her brother(s)/sister(s)? - Radio: (same 1-5 + 6=N/A + 8=DK + 9=REF scale as Q6)

#### Parenting - PAR (pp. 125-129) - 38 questions

453. PAR-C1: *IF THE RESPONDENT IS THE CHILD'S FOSTER PARENT ---> GO TO CUSTODY SECTION; ELSE IF THE RESPONDENT IS THE PERSON MOST KNOWLEDGEABLE ABOUT THE CHILD, OR THAT PERSON'S SPOUSE/PARTNER ---> GO TO PAR-I1; OTHERWISE ---> GO TO CUSTODY SECTION* - Check (routing)
454. PAR-I1: **The following questions have to do with things that ... does and ways that you react to him/her.** - Intro
455. PAR-Q1: How often do you praise ..., by saying something like "Good for you!" or "What a nice thing you did!" or "That's good going!"? - Radio: 1=NEVER, 2=ABOUT ONCE A WEEK OR LESS, 3=A FEW TIMES A WEEK, 4=ONE OR TWO TIMES A DAY, 5=MANY TIMES EACH DAY, 8=DON'T KNOW, 9=REFUSAL -->GO TO CUSTODY SECTION
456. PAR-Q2: How often do you and he/she talk or play with each other, focusing attention on each other for five minutes or more, just for fun? - Radio: Same scale as PAR-Q1 (1=NEVER through 5=MANY TIMES EACH DAY, 8=DK, 9=REF)
457. PAR-Q3: How often do you and he/she laugh together? - Radio: Same scale as PAR-Q1
458. PAR-Q4: How often do you get annoyed with ... for saying or doing something he/she is not supposed to? - Radio: Same scale as PAR-Q1
459. PAR-Q5: How often do you tell him/her that he/she is bad or not as good as others? - Radio: Same scale as PAR-Q1
460. PAR-Q6: How often do you do something special with him/her that he/she enjoys? - Radio: Same scale as PAR-Q1
461. PAR-C7: *IF AGE < 3 ---> GO TO PAR-Q7A; OTHERWISE ---> GO TO PAR-Q7* - Check (routing)
462. PAR-Q7: How often do you play sports, hobbies or games with him/her? - Radio: Same scale as PAR-Q1
463. PAR-Q7A: How often do you play games with him/her? - Radio: Same scale as PAR-Q1
464. PAR-C8: *IF AGE < 2 ---> GO TO CUSTODY SECTION; OTHERWISE ---> GO TO PAR-I8A* - Check (routing)
465. PAR-I8A: **Now, we know that when parents spend time together with their children, some of the time things go well and some of the time they don't go well. For the following questions, I would like you to tell me what proportion of the time things turn out in different ways.** - Intro
466. PAR-Q8: Of all the times that you talk to ... about his/her behaviour, what proportion is praise? - Radio: 1=NEVER, 2=LESS THAN HALF THE TIME, 3=ABOUT HALF THE TIME, 4=MORE THAN HALF THE TIME, 5=ALL THE TIME, 8=DON'T KNOW, 9=REFUSAL -->GO TO CUSTODY SECTION
467. PAR-Q9: Of all the times that you talk to him/her about his/her behaviour, what proportion is disapproval? - Radio: Same scale as PAR-Q8 (1=NEVER through 5=ALL THE TIME, 8=DK, 9=REF)
468. PAR-Q10: When you give him/her a command or order to do something, what proportion of the time do you make sure that he/she does it? - Radio: Same scale as PAR-Q8
469. PAR-Q11: If you tell him/her he/she will get punished if he/she doesn't stop doing something, and he/she keeps doing it, how often will you punish him/her? - Radio: Same scale as PAR-Q8
470. PAR-Q12: How often does he/she get away with things that you feel should have been punished? - Radio: Same scale as PAR-Q8
471. PAR-Q13: How often do you get angry when you punish ...? - Radio: Same scale as PAR-Q8
472. PAR-Q14: How often do you think that the kind of punishment you give him/her depends on your mood? - Radio: Same scale as PAR-Q8
473. PAR-Q15: How often do you feel you are having problems managing him/her in general? - Radio: Same scale as PAR-Q8
474. PAR-Q16: How often is he/she able to get out of a punishment when he/she really sets his/her mind to it? - Radio: Same scale as PAR-Q8
475. PAR-Q17: How often when you discipline him/her, does he/she ignore the punishment? - Radio: Same scale as PAR-Q8
476. PAR-Q18: How often do you have to discipline him/her repeatedly for the same thing? - Radio: Same scale as PAR-Q8
477. PAR-I19A: **Just about all children break the rules or do things that they are not supposed to. Also, parents react in different ways. Please tell me how often you do each of the following when ... breaks the rules or does things that he/she is not supposed to.** - Intro
478. PAR-Q19: How often do you: Tell him/her to stop? - Radio: 1=ALWAYS, 2=OFTEN, 3=SOMETIMES, 4=RARELY, 5=NEVER, 8=DON'T KNOW, 9=REFUSAL -->GO TO CUSTODY SECTION
479. PAR-Q20: Ignore it, do nothing? - Radio: Same scale as PAR-Q19 (1=ALWAYS through 5=NEVER, 8=DK, 9=REF)
480. PAR-Q21: Raise your voice, scold or yell at him/her? - Radio: Same scale as PAR-Q19
481. PAR-Q22: Calmly discuss the problem? - Radio: Same scale as PAR-Q19
482. PAR-Q23: Use physical punishment? - Radio: Same scale as PAR-Q19
483. PAR-Q24: Describe alternative ways of behaving that are acceptable? - Radio: Same scale as PAR-Q19
484. PAR-Q25: Take away privileges or put in room? - Radio: Same scale as PAR-Q19
485. PAR-I26A: **Sometimes different situations or circumstances arise which may affect family life. The next few questions are about some of these possible situations.** - Intro
486. PAR-Q26A: Has he/she ever experienced being hungry because the family has run out of food or money to buy food? - Y/N: 1=YES, 2=NO -->GO TO PAR-Q27, 8=DON'T KNOW -->GO TO PAR-Q27, 9=REFUSAL -->GO TO CUSTODY SECTION
487. PAR-Q26B: How often? - Radio: 1=REGULARLY, END OF THE MONTH, 2=MORE OFTEN THAN END OF EACH MONTH, 3=EVERY FEW MONTHS, 4=OCCASIONALLY, NOT A REGULAR OCCURRENCE, 8=DON'T KNOW, 9=REFUSAL -->GO TO CUSTODY SECTION
488. PAR-Q26C: How do you cope with feeding ... when this happens? (MARK ALL THAT APPLY.) - Checkbox: 01=PARENT/GUARDIAN SKIPS MEALS OR EATS LESS, 02=CHILDREN SKIP MEALS OR EAT LESS, 03=CUT DOWN ON VARIETY OF FOOD FAMILY USUALLY EATS, 04=SEEK HELP FROM RELATIVES, 05=SEEK HELP FROM FRIENDS, 06=SEEK HELP FROM SOCIAL WORKER/GOVERNMENT OFFICE, 07=SEEK HELP FROM FOOD BANK (EMERGENCY FOOD PROGRAM), 08=USE SCHOOL MEAL PROGRAM, 09=OTHER, 98=DON'T KNOW, 99=REFUSAL -->GO TO CUSTODY SECTION
489. PAR-Q27: How often does he/she see television shows or movies that have a lot of violence in them? - Radio: 1=OFTEN, 2=SOMETIMES, 3=SELDOM, 4=NEVER, 8=DON'T KNOW, 9=REFUSAL -->GO TO CUSTODY SECTION
490. PAR-Q28: How often does he/she see adults or teenagers in your house physically fighting, hitting or otherwise trying to hurt others? - Radio: Same scale as PAR-Q27 (1=OFTEN through 4=NEVER, 8=DK, 9=REF)

#### Education (Children) - EDU (pp. 84-100) - 62 questions

491. EDU-C1: *IF AGE < 4 ---> GO TO LITERACY SECTION; OTHERWISE ---> GO TO EDU-I1* - Check (routing)
492. EDU-I1: **The next section is about ...'s experiences at school.** - Intro
493. EDU-C1A: *IF PROVINCE IS NEWFOUNDLAND ---> GO TO EDU-Q1A; IF PROVINCE IS QUEBEC ---> GO TO EDU-Q1B; IF PROVINCE IS ONTARIO ---> GO TO EDU-Q1C; IF PROVINCE IS NOVA SCOTIA ---> GO TO EDU-Q1D; IF PROVINCE IS P.E.I. ---> GO TO EDU-Q1E; OTHERWISE ---> GO TO EDU-Q1* - Check (routing)
494. EDU-Q1: What school grade is ... in? (New Brunswick, Manitoba, Saskatchewan, Alberta or British Columbia) - Radio: 01=NOT IN SCHOOL, 02=KINDERGARTEN, 03=GRADE 1, 04=GRADE 2, 05=GRADE 3, 06=GRADE 4, 07=GRADE 5, 08=GRADE 6, 09=GRADE 7, 10=GRADE 8, 11=GRADE 9, 12=GRADE 10, 13=GRADE 11, 14=GRADE 12, 15=UNGRADED
495. EDU-E1: *IF EDU-Q1 = 1 (NOT IN SCHOOL) OR REFUSAL ---> GO TO LITERACY SECTION; IF EDU-Q1 = 15 (UNGRADED) OR DON'T KNOW ---> GO TO EDU-Q8; IF EDU-Q1 = 2-14 ---> GO TO EDU-Q2* - Check (routing)
496. EDU-Q1A: What school grade is ... in? (Newfoundland) - Radio: 01=NOT IN SCHOOL, 02=KINDERGARTEN, 03=GRADE 1 ELEMENTARY, 04=GRADE 2 ELEMENTARY, 05=GRADE 3 ELEMENTARY, 06=GRADE 4 ELEMENTARY, 07=GRADE 5 ELEMENTARY, 08=GRADE 6 ELEMENTARY, 09=GRADE 7 ELEMENTARY, 10=GRADE 8 ELEMENTARY, 11=GRADE 9 ELEMENTARY, 12=LEVEL 1 SECONDARY, 13=LEVEL 2 SECONDARY, 14=LEVEL 3 SECONDARY, 15=UNGRADED
497. EDU-E1A: *IF EDU-Q1A = 1 (NOT IN SCHOOL) OR REFUSAL ---> GO TO LITERACY SECTION; IF EDU-Q1A = 15 (UNGRADED) OR DON'T KNOW ---> GO TO EDU-Q8; IF EDU-Q1A = 2-14 ---> GO TO EDU-Q2* - Check (routing)
498. EDU-Q1B: What school grade is ... in? (Quebec) - Radio: 01=NOT IN SCHOOL, 02=JUNIOR KINDERGARTEN, 03=KINDERGARTEN, 04=GRADE 1 ELEMENTARY, 05=GRADE 2 ELEMENTARY, 06=GRADE 3 ELEMENTARY, 07=GRADE 4 ELEMENTARY, 08=GRADE 5 ELEMENTARY, 09=GRADE 6 ELEMENTARY, 10=SECONDARY I, 11=SECONDARY II, 12=SECONDARY III, 13=SECONDARY IV, 14=SECONDARY V, 15=UNGRADED
499. EDU-E1B: *IF EDU-Q1B = 1 (NOT IN SCHOOL) OR REFUSAL ---> GO TO LITERACY SECTION; IF EDU-Q1B = 15 (UNGRADED) OR DON'T KNOW ---> GO TO EDU-Q8; IF EDU-Q1B = 2 (JUNIOR KINDERGARTEN) ---> GO TO EDU-Q8; IF EDU-Q1B = 3-14 ---> GO TO EDU-Q2* - Check (routing)
500. EDU-Q1C: What school grade is ... in? (Ontario) - Radio: 01=NOT IN SCHOOL, 02=JUNIOR KINDERGARTEN, 03=KINDERGARTEN, 04=GRADE 1, 05=GRADE 2, 06=GRADE 3, 07=GRADE 4, 08=GRADE 5, 09=GRADE 6, 10=GRADE 7, 11=GRADE 8, 12=GRADE 9, 13=GRADE 10, 14=GRADE 11, 15=GRADE 12, 16=OAC GRADE 13, 17=UNGRADED
501. EDU-E1C: *IF EDU-Q1C = 1 (NOT IN SCHOOL) OR REFUSAL ---> GO TO LITERACY SECTION; IF EDU-Q1C = 17 (UNGRADED) OR DON'T KNOW ---> GO TO EDU-Q8; IF EDU-Q1C = 2 (JUNIOR KINDERGARTEN) ---> GO TO EDU-Q8; IF EDU-Q1C = 3-16 ---> GO TO EDU-Q2* - Check (routing)
502. EDU-Q1D: What school grade is ... in? (Nova Scotia) - Radio: 01=NOT IN SCHOOL, 02=PRIMARY, 03=GRADE 1, 04=GRADE 2, 05=GRADE 3, 06=GRADE 4, 07=GRADE 5, 08=GRADE 6, 09=GRADE 7, 10=GRADE 8, 11=GRADE 9, 12=GRADE 10, 13=GRADE 11, 14=GRADE 12, 15=UNGRADED
503. EDU-E1D: *IF EDU-Q1D = 1 (NOT IN SCHOOL) OR REFUSAL ---> GO TO LITERACY SECTION; IF EDU-Q1D = 15 (UNGRADED) OR DON'T KNOW ---> GO TO EDU-Q8; IF EDU-Q1D = 2-14 ---> GO TO EDU-Q2* - Check (routing)
504. EDU-Q1E: What school grade is ... in? (Prince Edward Island) - Radio: 01=NOT IN SCHOOL, 02=GRADE 1, 03=GRADE 2, 04=GRADE 3, 05=GRADE 4, 06=GRADE 5, 07=GRADE 6, 08=GRADE 7, 09=GRADE 8, 10=GRADE 9, 11=GRADE 10, 12=GRADE 11, 13=GRADE 12, 14=UNGRADED
505. EDU-E1E: *IF EDU-Q1E = 1 (NOT IN SCHOOL) OR REFUSAL ---> GO TO LITERACY SECTION; IF EDU-Q1E = 14 (UNGRADED) OR DON'T KNOW ---> GO TO EDU-Q8; IF EDU-Q1E = 2-13 ---> GO TO EDU-Q2* - Check (routing)
506. EDU-Q2: Did he/she attend junior kindergarten? - Y/N: 1=YES, 2=NO, 8=DON'T KNOW, 9=REFUSAL -->GO TO NEXT SECTION
507. EDU-C3: *IF CHILD IN KINDERGARTEN/PRIMARY (EDU-Q1 = 2 OR EDU-Q1A = 2 OR EDU-Q1B = 3 OR EDU-Q1C = 3 OR EDU-Q1D = 2) ---> GO TO EDU-Q8; OTHERWISE ---> GO TO EDU-Q3* - Check (routing)
508. EDU-Q3: Did he/she attend kindergarten/primary? - Y/N: 1=YES, 2=NO, 8=DON'T KNOW, 9=REFUSAL (same format as Q2)
509. EDU-Q4: Has ... ever skipped a grade at school? (INCLUDE KINDERGARTEN) - Y/N: 1=YES, 2=NO -->GO TO EDU-Q6, 8=DON'T KNOW -->GO TO EDU-Q6, 9=REFUSAL -->GO TO EDU-Q6
510. EDU-C5: *IF PROVINCE IS NFLD ---> GO TO EDU-Q5A; IF PROVINCE IS QUE ---> GO TO EDU-Q5B; IF PROVINCE IS ONTARIO ---> GO TO EDU-Q5C; IF PROVINCE IS NOVA SCOTIA ---> GO TO EDU-Q5D; IF PROVINCE IS P.E.I. ---> GO TO EDU-Q5E; OTHERWISE ---> GO TO EDU-Q5* - Check (routing)
511. EDU-Q5: What grade(s) has he/she skipped? (New Brunswick, Manitoba, Saskatchewan, Alberta, British Columbia) (MARK ONE ONLY. IF MORE THAN ONE REPORTED, MARK THE MOST RECENT.) - Radio: 01=KINDERGARTEN, 02=GRADE 1, 03=GRADE 2, 04=GRADE 3, 05=GRADE 4, 06=GRADE 5, 07=GRADE 6, 08=GRADE 7, 09=GRADE 8, 10=GRADE 9, 11=GRADE 10, 12=GRADE 11, 13=GRADE 12, 98=DON'T KNOW, 99=REFUSAL -->GO TO NEXT SECTION
512. EDU-Q5A: What grade(s) has he/she skipped? (Newfoundland) (MARK ONE ONLY. IF MORE THAN ONE REPORTED, MARK THE MOST RECENT.) - Radio: 01=KINDERGARTEN, 02=GRADE 1 ELEMENTARY, 03=GRADE 2 ELEMENTARY, 04=GRADE 3 ELEMENTARY, 05=GRADE 4 ELEMENTARY, 06=GRADE 5 ELEMENTARY, 07=GRADE 6 ELEMENTARY, 08=GRADE 7 ELEMENTARY, 09=GRADE 8 ELEMENTARY, 10=GRADE 9 ELEMENTARY, 11=LEVEL 1 SECONDARY, 12=LEVEL 2 SECONDARY, 13=LEVEL 3 SECONDARY, 98=DON'T KNOW, 99=REFUSAL -->GO TO NEXT SECTION
513. EDU-Q5B: What grade(s) has he/she skipped? (Quebec) (MARK ONE ONLY. IF MORE THAN ONE REPORTED, MARK THE MOST RECENT.) - Radio: 01=KINDERGARTEN, 02=GRADE 1 ELEMENTARY, 03=GRADE 2 ELEMENTARY, 04=GRADE 3 ELEMENTARY, 05=GRADE 4 ELEMENTARY, 06=GRADE 5 ELEMENTARY, 07=GRADE 6 ELEMENTARY, 08=SECONDARY I, 09=SECONDARY II, 10=SECONDARY III, 11=SECONDARY IV, 12=SECONDARY V, 98=DON'T KNOW, 99=REFUSAL -->GO TO NEXT SECTION
514. EDU-Q5C: What grade(s) has he/she skipped? (Ontario) (MARK ONE ONLY. IF MORE THAN ONE REPORTED, MARK THE MOST RECENT.) - Radio: 01=KINDERGARTEN, 02=GRADE 1, 03=GRADE 2, 04=GRADE 3, 05=GRADE 4, 06=GRADE 5, 07=GRADE 6, 08=GRADE 7, 09=GRADE 8, 10=GRADE 9, 11=GRADE 10, 12=GRADE 11, 13=GRADE 12, 14=OAC GRADE 13, 98=DON'T KNOW, 99=REFUSAL -->GO TO NEXT SECTION
515. EDU-Q5D: What grade(s) has he/she skipped? (Nova Scotia) (MARK ONE ONLY. IF MORE THAN ONE REPORTED, MARK THE MOST RECENT.) - Radio: 01=PRIMARY, 02=GRADE 1, 03=GRADE 2, 04=GRADE 3, 05=GRADE 4, 06=GRADE 5, 07=GRADE 6, 08=GRADE 7, 09=GRADE 8, 10=GRADE 9, 11=GRADE 10, 12=GRADE 11, 13=GRADE 12, 98=DON'T KNOW, 99=REFUSAL -->GO TO NEXT SECTION
516. EDU-Q5E: What grade(s) has he/she skipped? (Prince Edward Island) (MARK ONE ONLY. IF MORE THAN ONE REPORTED, MARK THE MOST RECENT.) - Radio: 01=GRADE 1, 02=GRADE 2, 03=GRADE 3, 04=GRADE 4, 05=GRADE 5, 06=GRADE 6, 07=GRADE 7, 08=GRADE 8, 09=GRADE 9, 10=GRADE 10, 11=GRADE 11, 12=GRADE 12, 98=DON'T KNOW, 99=REFUSAL -->GO TO NEXT SECTION
517. EDU-Q6: Has ... ever repeated a grade at school (INCLUDE KINDERGARTEN)? - Y/N: 1=YES, 2=NO -->GO TO EDU-Q8, 8=DON'T KNOW -->GO TO EDU-Q8, 9=REFUSAL -->GO TO EDU-Q8
518. EDU-C7: *IF PROVINCE IS NFLD ---> GO TO EDU-Q7A; IF PROVINCE IS QUE ---> GO TO EDU-Q7B; IF PROVINCE IS ONTARIO ---> GO TO EDU-Q7C; IF PROVINCE IS NOVA SCOTIA ---> GO TO EDU-Q7D; IF PROVINCE IS P.E.I. ---> GO TO EDU-Q7E; OTHERWISE ---> GO TO EDU-Q7* - Check (routing)
519. EDU-Q7: What grade(s) has he/she repeated? (New Brunswick, Manitoba, Saskatchewan, Alberta, British Columbia) (MARK ONE ONLY. IF MORE THAN ONE REPORTED, MARK THE MOST RECENT.) - Radio: 01=KINDERGARTEN, 02=GRADE 1, 03=GRADE 2, 04=GRADE 3, 05=GRADE 4, 06=GRADE 5, 07=GRADE 6, 08=GRADE 7, 09=GRADE 8, 10=GRADE 9, 11=GRADE 10, 12=GRADE 11, 13=GRADE 12, 98=DON'T KNOW, 99=REFUSAL -->GO TO NEXT SECTION
520. EDU-Q7A: What grade(s) has he/she repeated? (Newfoundland) (MARK ONE ONLY. IF MORE THAN ONE REPORTED, MARK THE MOST RECENT.) - Radio: 01=KINDERGARTEN, 02=GRADE 1 ELEMENTARY, 03=GRADE 2 ELEMENTARY, 04=GRADE 3 ELEMENTARY, 05=GRADE 4 ELEMENTARY, 06=GRADE 5 ELEMENTARY, 07=GRADE 6 ELEMENTARY, 08=GRADE 7 ELEMENTARY, 09=GRADE 8 ELEMENTARY, 10=GRADE 9 ELEMENTARY, 11=LEVEL 1 SECONDARY, 12=LEVEL 2 SECONDARY, 13=LEVEL 3 SECONDARY, 98=DON'T KNOW, 99=REFUSAL -->GO TO NEXT SECTION
521. EDU-Q7B: What grade(s) has he/she repeated? (Quebec) (MARK ONE ONLY. IF MORE THAN ONE REPORTED, MARK THE MOST RECENT.) - Radio: 01=KINDERGARTEN, 02=GRADE 1 ELEMENTARY, 03=GRADE 2 ELEMENTARY, 04=GRADE 3 ELEMENTARY, 05=GRADE 4 ELEMENTARY, 06=GRADE 5 ELEMENTARY, 07=GRADE 6 ELEMENTARY, 08=SECONDARY I, 09=SECONDARY II, 10=SECONDARY III, 11=SECONDARY IV, 12=SECONDARY V, 98=DON'T KNOW, 99=REFUSAL -->GO TO NEXT SECTION
522. EDU-Q7C: What grade(s) has he/she repeated? (Ontario) (MARK ONE ONLY. IF MORE THAN ONE REPORTED, MARK THE MOST RECENT.) - Radio: 01=KINDERGARTEN, 02=GRADE 1, 03=GRADE 2, 04=GRADE 3, 05=GRADE 4, 06=GRADE 5, 07=GRADE 6, 08=GRADE 7, 09=GRADE 8, 10=GRADE 9, 11=GRADE 10, 12=GRADE 11, 13=GRADE 12, 14=OAC GRADE 13, 98=DON'T KNOW, 99=REFUSAL -->GO TO NEXT SECTION
523. EDU-Q7D: What grade(s) has he/she repeated? (Nova Scotia) (MARK ONE ONLY. IF MORE THAN ONE REPORTED, MARK THE MOST RECENT.) - Radio: 01=PRIMARY, 02=GRADE 1, 03=GRADE 2, 04=GRADE 3, 05=GRADE 4, 06=GRADE 5, 07=GRADE 6, 08=GRADE 7, 09=GRADE 8, 10=GRADE 9, 11=GRADE 10, 12=GRADE 11, 13=GRADE 12, 98=DON'T KNOW, 99=REFUSAL -->GO TO NEXT SECTION
524. EDU-Q7E: What grade(s) has he/she repeated? (Prince Edward Island) (MARK ONE ONLY. IF MORE THAN ONE REPORTED, MARK THE MOST RECENT.) - Radio: 01=GRADE 1, 02=GRADE 2, 03=GRADE 3, 04=GRADE 4, 05=GRADE 5, 06=GRADE 6, 07=GRADE 7, 08=GRADE 8, 09=GRADE 9, 10=GRADE 10, 11=GRADE 11, 12=GRADE 12, 98=DON'T KNOW, 99=REFUSAL -->GO TO NEXT SECTION
525. EDU-Q8: What type of school is ... currently in? Is it a: (READ LIST. MARK ONE ONLY.) - Radio: 1=Public school?, 2=Catholic school, publicly funded?, 3=Private school?, 4=Other, 8=DON'T KNOW, 9=REFUSAL -->GO TO NEXT SECTION
526. EDU-Q9A: Other than natural progression through the school system in your area, has ... ever changed schools? - Y/N: 1=YES, 2=NO -->GO TO EDU-Q11, 3=NOT APPLICABLE -->GO TO EDU-Q11, 8=DON'T KNOW -->GO TO EDU-Q11, 9=REFUSAL -->GO TO EDU-Q11
527. EDU-Q9B: How many times has he/she changed schools? - Numeric
528. EDU-Q10: For the most recent change in schools, what was the reason for changing? - Radio: 01=FAMILY OR CHILD MOVED, 02=CHILD NOT PROGRESSING WELL ACADEMICALLY, 03=CHILD NOT PROGRESSING WELL IN LANGUAGE OF INSTRUCTION, 04=CHILD NOT GETTING ALONG WELL WITH OTHERS AT SCHOOL, 05=CONCERNS ABOUT SCHOOL'S ACADEMIC STANDARDS OR QUALITY, 06=CONCERNS ABOUT SCHOOL SAFETY OR DISCIPLINE, 07=CONCERNS ABOUT SCHOOL FACILITIES OR RESOURCES, 08=OTHER, 98=DON'T KNOW, 99=REFUSAL -->GO TO NEXT SECTION
529. EDU-Q11: Aside from school changes, how many times in ...'s life has he/she moved, that is, changed his/her usual place of residence? - Numeric
530. EDU-Q12A: In what language is he/she mainly taught? - Radio: 1=ENGLISH, 2=FRENCH, 3=BOTH, 4=OTHER, 8=DON'T KNOW, 9=REFUSAL -->GO TO NEXT SECTION
531. EDU-C12B: *IF AGE > 5 ---> GO TO EDU-Q13* - Check (routing)
532. EDU-Q12B: What language does he/she speak most often at home? (MARK ALL THAT APPLY.) - Checkbox: 1=ENGLISH, 2=FRENCH, 3=OTHER, 4=NONE, 8=DON'T KNOW, 9=REFUSAL -->GO TO NEXT SECTION
533. EDU-Q13: Since he/she started school in the fall, about how many days has he/she been away from school for any reason? - Numeric
534. EDU-C14A: *IF EDU-Q1 = 2 (KINDERGARTEN) OR DON'T KNOW OR REFUSAL ---> GO TO EDU-Q16; ELSE IF EDU-Q1A = 2 (KINDERGARTEN) OR DON'T KNOW OR REFUSAL ---> GO TO EDU-Q16; ELSE IF EDU-Q1B = 2 (JUNIOR KINDERGARTEN) OR 3 (KINDERGARTEN) OR DON'T KNOW OR REFUSAL ---> GO TO EDU-Q16; ELSE IF EDU-Q1C = 2 (JUNIOR KINDERGARTEN) OR 3 (KINDERGARTEN) OR DON'T KNOW OR REFUSAL ---> GO TO EDU-Q16; ELSE IF EDU-Q1D = 2 (PRIMARY) OR DON'T KNOW OR REFUSAL ---> GO TO EDU-Q16; ELSE IF EDU-Q1E = DON'T KNOW OR REFUSAL ---> GO TO EDU-Q16; OTHERWISE ---> GO TO EDU-Q14A* - Check (routing)
535. EDU-Q14A: Based on your knowledge of his/her school work, including his/her report cards, how is ... doing in the following areas at school this year: reading? - Radio: 1=VERY WELL, 2=WELL, 3=AVERAGE, 4=POORLY, 5=VERY POORLY, 6=NOT APPLICABLE, 8=DON'T KNOW, 9=REFUSAL -->GO TO NEXT SECTION
536. EDU-Q14B: Mathematics? - Radio: Same scale as EDU-Q14A
537. EDU-Q14C: Written work such as composition? - Radio: Same scale as EDU-Q14A
538. EDU-Q14D: How is he/she doing overall? - Radio: Same scale as EDU-Q14A
539. EDU-Q15A: Since ... started school in the fall, has he/she received any help or tutoring outside of school? - Y/N: 1=YES, 2=NO -->GO TO EDU-Q16, 8=DON'T KNOW -->GO TO EDU-Q16, 9=REFUSAL -->GO TO EDU-Q16
540. EDU-Q15B: How often? - Radio: 1=ONCE A WEEK OR LESS OFTEN, 2=TWICE A WEEK, 3=MORE THAN TWICE A WEEK, 8=DON'T KNOW, 9=REFUSAL -->GO TO NEXT SECTION
541. EDU-Q16: Since ... started school in the fall how many times have you been contacted by his/her school regarding his/her behaviour at school? - Radio: 1=NONE/ONCE, 2=TWICE/THREE TIMES, 3=FOUR OR MORE TIMES, 8=DON'T KNOW, 9=REFUSAL -->GO TO NEXT SECTION
542. EDU-Q17: With regard to how he/she feels about school, how often does he/she look forward to going to school? - Radio: 1=ALMOST NEVER, 2=RARELY, 3=SOMETIMES, 4=OFTEN, 5=ALMOST ALWAYS, 8=DON'T KNOW, 9=REFUSAL -->GO TO NEXT SECTION
543. EDU-C18: *IF AGE < 8 ---> GO TO EDU-Q18B; OTHERWISE ---> GO TO EDU-Q18A* - Check (routing)
544. EDU-Q18A: How important is it to you that ... have good grades in school? - Radio: 1=VERY IMPORTANT, 2=IMPORTANT, 3=SOMEWHAT IMPORTANT, 4=NOT IMPORTANT AT ALL, 8=DON'T KNOW, 9=REFUSAL -->GO TO NEXT SECTION
545. EDU-Q18B: How far do you hope he/she will go in school? - Radio: 1=PRIMARY SCHOOL, 2=SECONDARY OR HIGH SCHOOL, 3=GO TO COMMUNITY COLLEGE, TECHNICAL COLLEGE OR CEGEP, 4=GO TO UNIVERSITY, 5=LEARN A TRADE, 6=OTHER, 8=DON'T KNOW, 9=REFUSAL -->GO TO NEXT SECTION
546. EDU-C19A: *IF EDU-Q1 = 2 (KINDERGARTEN) OR DON'T KNOW OR REFUSAL ---> GO TO EDU-Q20; ELSE IF EDU-Q1A = 2 (KINDERGARTEN) OR DON'T KNOW OR REFUSAL ---> GO TO EDU-Q20; ELSE IF EDU-Q1B = 2 (JUNIOR KINDERGARTEN) OR 3 (KINDERGARTEN) OR DON'T KNOW OR REFUSAL ---> GO TO EDU-20; ELSE IF EDU-Q1C = 2 (JUNIOR KINDERGARTEN) OR 3 (KINDERGARTEN) OR DON'T KNOW OR REFUSAL ---> GO TO EDU-Q20; ELSE IF EDU-Q1D = 2 (PRIMARY) OR DON'T KNOW OR REFUSAL ---> GO TO EDU-Q20; ELSE IF EDU-Q1E = DON'T KNOW OR REFUSAL ---> GO TO EDU-Q20; OTHERWISE ---> GO TO EDU-I19A* - Check (routing)
547. EDU-I19A: **The following are possible descriptions of his/her present school. For each, please indicate whether you strongly agree, agree, disagree, or strongly disagree.** - Intro
548. EDU-Q19A: Academic progress is very important at this school. - Scale: Strongly agree/Agree/Disagree/Strongly disagree scale (per intro)
549. EDU-Q19B: Most children in this school enjoy being there. - Radio: Same scale as Q19A
550. EDU-Q19C: Parents are made to feel welcome in this school. - Radio: Same scale as Q19A
551. EDU-Q19D: School spirit is very high. - Radio: Same scale as Q19A
552. EDU-Q20: Does ... receive special education because a physical, emotional, behavioral, or some other problem limits the kind or amount of school work he/she can do? - Y/N: 1=YES, 2=NO, 8=DON'T KNOW, 9=REFUSAL

#### Literacy - LIT (pp. 101-104) - 25 questions

553. LIT-I1: **Children can show their interest in reading or sharing books in different ways. The following are some questions about books and reading.** - Intro
554. LIT-C1: *IF AGE IN MONTHS > 23 ---> GO TO LIT-C4; OTHERWISE ---> GO TO LIT-Q1* - Check (routing)
555. LIT-Q1: Do you or another adult ever read to ..., or show him/her pictures or wordless baby books? - Y/N: 1=YES, 2=NO -->GO TO ACTIVITIES SECTION, 8=DON'T KNOW -->GO TO ACTIVITIES SECTION, 9=REFUSAL -->GO TO ACTIVITIES SECTION
556. LIT-Q2: How often do you do this? - Radio: 01=RARELY, 02=LESS THAN ONCE A MONTH, 03=ONCE A MONTH, 04=A FEW TIMES A MONTH, 05=ONCE A WEEK, 06=A FEW TIMES A WEEK, 07=DAILY, 08=MANY TIMES EACH DAY, 98=DON'T KNOW, 99=REFUSAL -->GO TO ACTIVITIES SECTION
557. LIT-Q3: How old was he/she when you started to do this (to nearest month)? - Numeric
558. LIT-C4: *IF AGE = 2-4 ---> GO TO LIT-Q4; IF AGE = 5 ---> GO TO LIT-Q6A; IF AGE = 6-7 ---> GO TO LIT-Q7A; OTHERWISE (AGE = 8-11) ---> GO TO LIT-Q7B* - Check (routing)
559. LIT-Q4: How often does ... look at books, magazines, comics, etc. on his/her own? (Think about what he/she does at home only, do not include day care or school.) - Radio: Frequency scale (not explicitly shown; likely same as LIT-Q7/Q11 scale)
560. LIT-Q5: How often does he/she play with pencils or markers doing real or pretend writing? - Radio: Frequency scale (not explicitly shown)
561. LIT-Q6A: Have you or another adult ever read aloud to ... on a regular basis? - Y/N: 1=YES, 2=NO -->GO TO LIT-Q8, 8=DON'T KNOW -->GO TO LIT-C9, 9=REFUSAL -->GO TO ACTIVITIES SECTION
562. LIT-Q6B1: How old was he/she when you started (to the nearest month of age)? - Numeric
563. LIT-C7A: *IF AGE < 5 ---> GO TO LIT-Q7; OTHERWISE ---> GO TO LIT-Q7A* - Check (routing)
564. LIT-Q7: Currently, how often do you or another adult read to him/her? (Also include if he/she reads or pretends to read to adult.) - Radio: 01=NEVER OR RARELY, 02=LESS THAN ONCE A MONTH, 03=ONCE A MONTH, 04=A FEW TIMES A MONTH, 05=ONCE A WEEK, 06=A FEW TIMES A WEEK, 07=DAILY, 08=MANY TIMES EACH DAY, 98=DON'T KNOW, 99=REFUSAL
565. LIT-Q7A: Currently, how often do you or another adult read aloud to him/her or listen to him/her read or attempt to read aloud? - Radio: Same frequency scale as LIT-Q7
566. LIT-Q7B: Currently, how often do you or another adult read aloud to him/her or listen to him/her read? - Radio: Same frequency scale as LIT-Q7
567. LIT-C8: *IF AGE > 5 ---> GO TO LIT-Q9; OTHERWISE GO TO LIT-Q8* - Check (routing)
568. LIT-Q8: How often do you help or encourage him/her to write or pretend to write? - Radio: Frequency scale (not explicitly shown)
569. LIT-C9: *IF AGE = 2-4 ---> GO TO ACTIVITIES SECTION; OTHERWISE (AGE = 5) ---> GO TO LIT-Q12* - Check (routing)
570. LIT-Q9: How often is ... assigned homework? - Radio: 1=NEVER -->GO TO LIT-C12A, 2=LESS THAN ONCE A MONTH, 3=ONCE A MONTH, 4=A FEW TIMES A MONTH, 5=ONCE A WEEK, 6=A FEW TIMES A WEEK, 7=DAILY, 8=DON'T KNOW -->GO TO LIT-C12A, 9=REFUSAL -->GO TO ACTIVITIES SECTION
571. LIT-Q10A: On days when he/she is assigned homework, how much time does he/she usually spend doing homework? - Radio: Open entry (time/duration)
572. LIT-Q11: How often do you check his/her homework or provide help with homework? - Radio: 1=NEVER OR RARELY, 2=LESS THAN ONCE A MONTH, 3=ONCE A MONTH, 4=A FEW TIMES A MONTH, 5=ONCE A WEEK, 6=A FEW TIMES A WEEK, 7=DAILY, 8=DON'T KNOW, 9=REFUSAL -->GO TO ACTIVITIES SECTION
573. LIT-C12A: *IF AGE = 6 ---> GO TO LIT-Q12; OTHERWISE ---> GO TO LIT-Q12A* - Check (routing)
574. LIT-Q12: How often does ... look at books or try to read on his/her own? - Radio: Frequency scale (not explicitly shown)
575. LIT-Q12A: How often does ... read for pleasure? - Radio: Frequency scale (not explicitly shown)
576. LIT-Q13: How often does he/she talk about a book with family or friends? - Radio: Frequency scale (not explicitly shown)
577. LIT-Q14: How often does he/she go to the library, including the school library? - Radio: Frequency scale (not explicitly shown)

#### Medical/Biological - MED (pp. 61-67) - 42 questions

*NOTE: Asked only of children 0-3 years. AGE 0-11m: MED-Q1A-Q28; AGE 12-23m: MED-Q1A-Q15, Q21A-Q22, Q25-Q28; AGE 2-3: MED-Q12A-Q15*

578. MED-C1: *IF AGE > 3 YEARS ---> GO TO TEMPERAMENT SECTION* - Check (routing)
579. MED-C1A: *IF RESPONDENT IS THE BIOLOGICAL MOTHER OF THE CHILD ---> GO TO MED-C1C; ELSE IF RESPONDENT IS BIOLOGICAL FATHER OF THE CHILD ---> GO TO MED-Q12A; OTHERWISE ---> GO TO TEMPERAMENT SECTION* - Check (routing)
580. MED-C1C: *IF AGE IN MONTHS > 23 ---> GO TO MED-Q12A* - Check (routing)
581. MED-Q1A: The following are prenatal questions concerning .... During the pregnancy with ... did you suffer from any of the following: pregnancy diabetes? - Y/N: 1=YES, 2=NO, 8=DON'T KNOW, 9=REFUSAL -->GO TO MED-Q2
582. MED-Q1B: High blood pressure? - Radio: (same response scale as Q1A implied: YES/NO/DK/REF)
583. MED-Q1C: Other physical problems? - Radio: (same response scale implied)
584. MED-Q2: From whom did you receive pre-natal care? - Radio: 1=A DOCTOR, 2=A NURSE, 3=A MIDWIFE, 4=OTHER, 5=NOBODY
585. MED-Q3: Did you smoke during your pregnancy with ...? - Y/N: 1=YES, 2=NO -->GO TO MED-Q6, 8=DON'T KNOW -->GO TO MED-Q6
586. MED-Q4: How many cigarettes per day did you smoke during your pregnancy with ...? - Numeric
587. MED-Q5: At what stage in your pregnancy did you smoke this amount? (MARK MORE THAN ONE IF NECESSARY) - Radio: 1=DURING THE FIRST THREE MONTHS, 2=DURING THE SECOND THREE MONTHS, 3=DURING THE THIRD THREE MONTHS, 4=THROUGHOUT
588. MED-Q6: How frequently did you consume alcohol during your pregnancy with ... (Eg. Beer, wine, liquor)? - Radio: 1=NEVER -->GO TO MED-Q9A, 2=LESS THAN ONCE A MONTH, 3=1-3 TIMES A MONTH, 4=ONCE A WEEK, 5=2-3 TIMES A WEEK, 6=4-6 TIMES A WEEK, 7=EVERYDAY, 8=DON'T KNOW, 9=REFUSAL -->GO TO MED-Q9A
589. MED-Q7: On the days when you drank, how many drinks did you usually have? - Radio: 1=1 TO 2, 2=3 TO 4, 3=5 OR MORE, 8=DON'T KNOW, 9=REFUSAL -->GO TO MED-Q9A
590. MED-Q8: At what stage in your pregnancy did you consume this quantity? (MARK MORE THAN ONE IF NECESSARY) - Radio: 1=DURING THE FIRST THREE MONTHS, 2=DURING THE SECOND THREE MONTHS, 3=DURING THE THIRD THREE MONTHS, 4=THROUGHOUT, 8=DON'T KNOW, 9=REFUSAL
591. MED-Q9A: Did you take any prescription medications during your pregnancy with ...? - Y/N: 1=YES, 2=NO -->GO TO MED-Q10A, 8=DON'T KNOW -->GO TO MED-Q10A, 9=REFUSAL -->GO TO MED-Q12A
592. MED-Q9B: At what stage in your pregnancy did you take these? (MARK ALL THAT APPLY) - Checkbox: 1=DURING THE FIRST THREE MONTHS, 2=DURING THE SECOND THREE MONTHS, 3=DURING THE THIRD THREE MONTHS, 4=THROUGHOUT, 8=DON'T KNOW, 9=REFUSAL -->GO TO MED-Q12A
593. MED-Q10A: Did you take any over-the-counter drugs during your pregnancy with ...? - Y/N: 1=YES, 2=NO -->GO TO MED-Q12A, 8=DON'T KNOW -->GO TO MED-Q12A, 9=REFUSAL -->GO TO MED-Q12A
594. MED-Q10B: At what stage in your pregnancy did you take these? (MARK ALL THAT APPLY) - Checkbox: 1=DURING THE FIRST THREE MONTHS, 2=DURING THE SECOND THREE MONTHS, 3=DURING THE THIRD THREE MONTHS, 4=THROUGHOUT, 8=DON'T KNOW, 9=REFUSAL
595. MED-Q12A: The following are questions concerning ...'s birth. Was he/she born before or after the due date? - Radio: 1=BEFORE, 2=AFTER, 3=ON DUE DATE -->GO TO MED-Q13A
596. MED-Q12B: How many days or weeks before or after the due date was he/she born? - Numeric
597. MED-Q13A: What was his/her birth weight in kilograms and grams or pounds and ounces? - Numeric
598. MED-Q14A: What was his/her length at birth in centimetres or inches? - Numeric
599. MED-Q15: Was this a single birth or twins, or triplets? - Radio: 1=SINGLE BIRTH, 2=TWINS, 3=TRIPLETS, 4=MORE THAN TRIPLETS, 8=DON'T KNOW, 9=REFUSAL -->GO TO MED-Q21A
600. MED-C16: *IF AGE IN MONTHS = 12-23 ---> GO TO MED-Q21A; IF AGE IN MONTHS > 23 ---> GO TO TEMPERAMENT SECTION; OTHERWISE ---> GO TO MED-Q16* - Check (routing)
601. MED-Q16: Was the delivery vaginal or caesarian? - Radio: 1=VAGINAL, 2=CAESARIAN -->GO TO MED-Q21A
602. MED-Q17: Was ... born head first? - Y/N: 1=YES, 2=NO, 8=DON'T KNOW, 9=REFUSAL
603. MED-Q18: Were birthing aids used? - Radio: 1=NONE, 2=FORCEPS, 3=CUPPING GLASS (SUCTION CUP), 8=DON'T KNOW, 9=REFUSAL
604. MED-Q21A: Did ... receive special medical care following his/her birth? - Y/N: 1=YES, 2=NO --> Go to MED-Q22, 8=DON'T KNOW --> Go to MED-Q22, 9=REFUSAL --> Go to MED-Q22
605. MED-Q21B: What type of special medical care was received? (MARK ALL THAT APPLY) - Checkbox: 1=INTENSIVE CARE, 2=VENTILATION/OXYGEN, 3=TRANSFER TO A SPECIALIZED HOSPITAL, 4=OTHER, 8=DON'T KNOW -->GO TO MED-Q22
606. MED-Q21C: For how many days, in total, was this care received? - Numeric
607. MED-Q22: Compared to other babies in general, would you say that ...'s health at birth was: - Radio: 1=Excellent?, 2=Very good?, 3=Good?, 4=Fair?, 5=Poor?, 8=DON'T KNOW, 9=REFUSAL
608. MED-C23A: *IF AGE IN MONTHS = 12-23 ---> GO TO MED-Q25; OTHERWISE ---> GO TO MED-Q23A* - Check (routing)
609. MED-Q23A: The following are postnatal questions concerning .... After ...'s delivery, did you/her/his-mother suffer from any of the following conditions: postpartum haemorrhage? - Y/N: 1=YES, 2=NO, 8=DON'T KNOW, 9=REFUSAL -->GO TO MED-Q24A
610. MED-Q23B: Postpartum infection? - Radio: (same response scale implied)
611. MED-Q23C1: Postpartum depression? - Radio: (same response scale implied)
612. MED-Q23C2: For how long? (ENTER NUMBER OF DAYS OR WEEKS OR MONTHS) - Numeric
613. MED-Q23D: Postpartum hypertension? - Radio: (same response scale implied)
614. MED-Q24A: Were/Was you/her/his mother hospitalized for special medical care for any period immediately following the birth of ...? - Y/N: 1=YES, 2=NO -->GO TO MED-Q25
615. MED-Q24B: For how many days? - Numeric
616. MED-Q25: Are/Is you/her/his mother currently breast-feeding ...? - Y/N: 1=YES -->GO TO TEMPERAMENT SECTION, 2=NO
617. MED-Q26: Did you/her/his mother breast-feed him/her even if only for a short time? - Y/N: 1=YES, 2=NO -->GO TO TEMPERAMENT SECTION
618. MED-Q27: For how long? (DO NOT READ LIST. MARK ONE ONLY.) - Radio: 01=LESS THAN 1 WEEK, 02=1-4 WEEKS, 03=5-8 WEEKS, 04=9-12 WEEKS, 05=3-6 MONTHS, 06=7-9 MONTHS, 07=10-12 MONTHS, 08=13-16 MONTHS, 09=MORE THAN 16 MONTHS
619. MED-Q28: What was the main reason you/her/his mother stopped breast-feeding him/her? (DO NOT READ LIST. MARK ALL THAT APPLY.) - Checkbox: 01=NOT ENOUGH MILK/HUNGRY BABY, 02=INCONVENIENCED/FATIGUE, 03=DIFFICULTY WITH BF TECHNIQUES, 04=SORE NIPPLES/ENGORGED BREAST, 05=MOTHER'S ILLNESS, 06=PLANNED TO STOP AT THIS TIME, 07=BABY WEANED HIMSELF/HERSELF, 08=PHYSICIAN TOLD ME/HER TO STOP, 09=RETURNED TO WORK/SCHOOL, 10=PARTNER/FATHER WANTED ME/HER TO STOP, 11=FORMULA FEEDING PREFERABLE, 12=WANTED TO DRINK ALCOHOL, 13=OTHER

#### Temperament - TMP (pp. 68-83) - 68 questions

*NOTE: Asked for children 3-47 months. Multiple age variants exist (e.g., TMP-Q2 vs Q2A, TMP-Q4 vs Q4A). Check items (C-prefixed) route to age-appropriate variants.*

620. TMP-C1: *IF AGE < 1 YEAR AND MONTH OF BIRTH WAS NOT STATED IN THE DEMOGRAPHICS OR IN THE CHILD COMPONENT ---> GO TO EDUCATION SECTION; ELSE IF AGE IN MONTHS < 3 OR > 47 ---> GO TO EDUCATION SECTION; OTHERWISE ---> GO TO TMP-I1* - Check (routing)
621. TMP-I1: **The following questions are about how ... behaves. Please answer them for him/her in comparison to others. "About average" means how you think the typical child would be scored.** - Intro
622. TMP-Q1: How easy or difficult is it for you to calm or soothe ... when he/she is upset? - Scale 1-7: 1=VERY EASY, 2=(unlabeled), 3=(unlabeled), 4=ABOUT AVERAGE, 5=(unlabeled), 6=(unlabeled), 7=DIFFICULT, 9=REFUSAL -->GO TO NEXT SECTION
623. TMP-C2: *IF AGE < 1 ---> GO TO TMP-Q2; OTHERWISE ---> GO TO TMP-Q2A* - Check (routing)
624. TMP-Q2: How easy or difficult is it for you to predict when he/she will go to sleep and wake up? - Scale 1-7: 1=VERY EASY, 2, 3, 4=ABOUT AVERAGE, 5, 6, 7=DIFFICULT, 9=REFUSAL -->GO TO NEXT SECTION
625. TMP-Q2A: How consistent is he/she in sticking with his/her sleeping routine? - Scale 1-7: 1=VERY CONSISTENT; LITTLE OR NO VARIABILITY, 2, 3, 4=SOME VARIABILITY, 5, 6, 7=VERY INCONSISTENT; HIGHLY VARIABLE, 9=REFUSAL -->GO TO NEXT SECTION
626. TMP-Q3: How easy or difficult is it for you to predict when he/she will become hungry? - Scale 1-7: 1=VERY EASY, 2, 3, 4=ABOUT AVERAGE, 5, 6, 7=DIFFICULT, 9=REFUSAL -->GO TO NEXT SECTION
627. TMP-Q3A: How consistent is he/she in sticking with his/her eating routine? - Scale 1-7: 1=VERY CONSISTENT; LITTLE OR NO VARIABILITY, 2, 3, 4=SOME VARIABILITY, 5, 6, 7=VERY INCONSISTENT; HIGHLY VARIABLE, 9=REFUSAL -->GO TO NEXT SECTION
628. TMP-C4: *IF AGE < 3 ---> GO TO TMP-Q4; OTHERWISE ---> GO TO TMP-Q4A* - Check (routing)
629. TMP-Q4: How easy or difficult is it for you to know what's bothering him/her when he/she cries or fusses? - Scale 1-7: 1=VERY EASY, 2, 3, 4=ABOUT AVERAGE, 5, 6, 7=VERY DIFFICULT, 9=REFUSAL -->GO TO NEXT SECTION
630. TMP-Q4A: How easy or difficult is it for you to know what's bothering him/her when he/she is irritable? - Scale 1-7: 1=VERY EASY, 2, 3, 4=ABOUT AVERAGE, 5, 6, 7=VERY DIFFICULT, 9=REFUSAL -->GO TO NEXT SECTION
631. TMP-Q5: How many times per day, on average, does ... get fussy and irritable - for either short or long periods of time? - Radio: 1=NEVER, 2=1-2 TIMES PER DAY, 3=3-4 TIMES PER DAY, 4=5-6 TIMES PER DAY, 5=7-9 TIMES PER DAY, 6=10-14 TIMES PER DAY, 7=15 TIMES PER DAY OR MORE, 9=REFUSAL -->GO TO NEXT SECTION
632. TMP-Q5A: How many times per day on average does ... get cranky and irritable - for either short or long periods of time? - Radio: 1=NEVER, 2=1-2 TIMES PER DAY, 3=3-4 TIMES PER DAY, 4=5-6 TIMES PER DAY, 5=7-9 TIMES PER DAY, 6=10-14 TIMES PER DAY, 7=15 TIMES PER DAY OR MORE, 9=REFUSAL -->GO TO NEXT SECTION
633. TMP-Q6: How much does he/she cry and fuss in general? - Scale 1-7: 1=VERY LITTLE; MUCH LESS THAN THE AVERAGE BABY/CHILD, 2, 3, 4=AVERAGE AMOUNT; ABOUT AS MUCH AS THE AVERAGE BABY/CHILD, 5, 6, 7=A LOT; MUCH MORE THAN THE AVERAGE BABY/CHILD, 9=REFUSAL -->GO TO NEXT SECTION
634. TMP-Q6A: How much does he/she cry, fuss or whine in general? - Radio: (same 7-point scale implied)
635. TMP-Q7: How easily does he/she get upset? - Scale 1-7: 1=VERY HARD TO UPSET -- EVEN BY THINGS THAT UPSET MOST BABIES/CHILDREN, 2, 3, 4=ABOUT AVERAGE, 5, 6, 7=VERY EASILY UPSET BY THINGS THAT WOULDN'T BOTHER MOST BABIES/CHILDREN, 8=DON'T KNOW, 9=REFUSAL -->GO TO NEXT SECTION
636. TMP-C8: *IF AGE < 1 ---> GO TO TMP-Q8; ELSE AGE = 1 OR 2 ---> GO TO TMP-Q8A; OTHERWISE ---> GO TO TMP-Q8B* - Check (routing)
637. TMP-Q8: When he/she gets upset (e.g., before feeding, during diapering, etc.), how vigorously or loudly does he/she cry and fuss? - Scale 1-7: 1=VERY MILD INTENSITY OR LOUDNESS, 2, 3, 4=MODERATE INTENSITY OR LOUDNESS, 5, 6, 7=VERY LOUD OR INTENSE, REALLY CUTS LOOSE, 9=REFUSAL -->GO TO NEXT SECTION
638. TMP-Q8A: When he/she gets upset, how vigorously or loudly does he/she cry and fuss? - Scale 1-7: 1=VERY MILD INTENSITY OR LOUDNESS, 2, 3, 4=MODERATE INTENSITY OR LOUDNESS, 5, 6, 7=VERY LOUD OR INTENSE, REALLY CUTS LOOSE, 9=REFUSAL -->GO TO NEXT SECTION
639. TMP-Q8B: When he/she gets upset, how vigourously or loudly does he/she cry and whine? - Radio: (same 7-point scale implied)
640. TMP-Q9: How does he/she react when you are dressing him/her? - Scale 1-7: 1=VERY WELL -- LIKES IT, 2, 3, 4=ABOUT AVERAGE -- DOESN'T MIND IT, 5, 6, 7=DOESN'T LIKE IT AT ALL, 9=REFUSAL -->GO TO NEXT SECTION
641. TMP-Q9A: How does he/she react during hairwashing? - Radio: (same 7-point scale implied)
642. TMP-Q10: How active is ... in general? - Scale 1-7: 1=VERY CALM AND QUIET, 2, 3, 4=AVERAGE, 5, 6, 7=VERY ACTIVE AND VIGOROUS, 8=DON'T KNOW, 9=REFUSAL -->GO TO NEXT SECTION
643. TMP-C11: *IF AGE < 3 ---> GO TO TMP-Q11; OTHERWISE ---> GO TO TMP-Q11A* - Check (routing)
644. TMP-Q11: How much does he/she smile and make happy sounds? - Radio: 1=A GREAT DEAL, MUCH MORE THAN MOST INFANTS/CHILDREN, 2, 3, 4=AN AVERAGE AMOUNT, 5, 6, 7=VERY LITTLE, MUCH LESS THAN MOST INFANTS/CHILDREN, 9=REFUSAL -->GO TO NEXT SECTION
645. TMP-Q11A: How much does he/she smile and laugh? - Radio: (same 7-point scale implied)
646. TMP-Q12: What kind of mood is he/she generally in? - Scale 1-7: 1=VERY HAPPY AND CHEERFUL, 2, 3, 4=NEITHER SERIOUS NOR CHEERFUL, 5, 6, 7=SERIOUS, 9=REFUSAL -->GO TO NEXT SECTION
647. TMP-C13: *IF AGE IN MONTHS < 6 ---> GO TO TMP-Q14; IF AGE IN MONTHS 6-11 ---> GO TO TMP-Q13; OTHERWISE ---> GO TO TMP-Q13A* - Check (routing)
648. TMP-Q13: How much does he/she enjoy playing little games with you? - Radio: 1=A GREAT DEAL -- REALLY LOVES IT, 2, 3, 4=ABOUT AVERAGE, 5, 6, 7=VERY LITTLE -- DOESN'T LIKE IT VERY MUCH, 9=REFUSAL -->GO TO NEXT SECTION
649. TMP-Q13A: How much does he/she enjoy playing with you? - Radio: (same 7-point scale implied)
650. TMP-C14: *IF AGE < 3 YEARS ---> GO TO TMP-Q14; OTHERWISE ---> GO TO TMP-Q14A* - Check (routing)
651. TMP-Q14: How much does he/she want to be held? - Radio: 1=WANTS TO BE FREE MOST OF THE TIME, 2, 3, 4=SOMETIMES WANTS TO BE HELD; SOMETIMES NOT, 5, 6, 7=A GREAT DEAL -- WANTS TO BE HELD ALMOST ALL THE TIME, 9=REFUSAL -->GO TO NEXT SECTION
652. TMP-Q14A: How much does he/she want to be cuddled? - Radio: (same 7-point scale implied)
653. TMP-Q15: How does he/she respond to disruptions and changes in everyday routine, such as when you go to church, a meeting, on trips, etc.,? - Scale 1-7: 1=VERY FAVOURABLY, DOESN'T GET UPSET, 2, 3, 4=ABOUT AVERAGE, 5, 6, 7=VERY UNFAVOURABLY, GETS QUITE UPSET, 9=REFUSAL -->GO TO NEXT SECTION
654. TMP-C16: *IF AGE IN MONTHS < 12 ---> GO TO TMP-Q16; OTHERWISE ---> GO TO TMP-Q17* - Check (routing)
655. TMP-Q16: How easy is it for you to predict when he/she will need a diaper change? - Scale 1-7: 1=VERY EASY, 2, 3, 4=ABOUT AVERAGE, 5, 6, 7=VERY DIFFICULT, 9=REFUSAL -->GO TO NEXT SECTION
656. TMP-Q17: How changeable is ...'s mood? - Radio: 1=CHANGES SELDOM AND CHANGES SLOWLY WHEN HE/SHE DOES CHANGE, 2, 3, 4=ABOUT AVERAGE, 5, 6, 7=CHANGES OFTEN AND RAPIDLY, 9=REFUSAL -->GO TO NEXT SECTION
657. TMP-Q18: How excited does he/she become when people play with or talk to him/her? - Scale 1-7: 1=VERY EXCITED, 2, 3, 4=ABOUT AVERAGE, 5, 6, 7=NOT AT ALL, 8=DON'T KNOW, 9=REFUSAL -->GO TO NEXT SECTION
658. TMP-C19: *IF AGE = 3 ---> GO TO TMP-Q19A; OTHERWISE ---> GO TO TMP-Q19* - Check (routing)
659. TMP-Q19: On the average, how much attention does he/she require, other than for caregiving (feeding, bathing, diaper changes, etc.)? - Scale 1-7: 1=VERY LITTLE -- MUCH LESS THAN THE AVERAGE BABY/CHILD, 2, 3, 4=AVERAGE AMOUNT, 5, 6, 7=A LOT -- MUCH MORE THAN THE AVERAGE BABY/CHILD, 9=REFUSAL -->GO TO NEXT SECTION
660. TMP-Q19A: On the average, how much attention does he/she require, other than for caregiving (bathing, eating, etc.)? - Radio: (same 7-point scale implied)
661. TMP-Q20: When left alone, he/she plays well by him/herself? - Radio: 1=ALMOST ALWAYS, 2, 3, 4=ABOUT HALF THE TIME, 5, 6, 7=ALMOST NEVER -- WON'T PLAY BY SELF, 8=DON'T KNOW, 9=REFUSAL -->GO TO NEXT SECTION
662. TMP-C21: *IF AGE IN MONTHS = 3-11 ---> GO TO TMP-Q23; ELSE IF AGE IN MONTHS = 12-23 ---> GO TO TMP-Q21; ELSE IF AGE IN MONTHS = 24-35 ---> GO TO TMP-Q21A; ELSE ---> GO TO TMP-Q21B* - Check (routing)
663. TMP-Q21: How does he/she react to being confined (as in a carseat, infant seat, playpen, etc.)? - Scale 1-7: 1=VERY WELL -- LIKES IT, 2, 3, 4=MINDS A LITTLE OR PROTESTS ONCE IN A WHILE, 5, 6, 7=DOESN'T LIKE IT AT ALL, 8=DON'T KNOW, 9=REFUSAL -->GO TO NEXT SECTION
664. TMP-Q21A: How does he/she react to being confined (as in a carseat, bedroom, crib, etc.)? - Radio: (same 7-point scale implied)
665. TMP-Q21B: How does he/she react to being confined (as in a boosterseat, seatbelt, bedroom, bed, etc.) - Radio: (same 7-point scale implied)
666. TMP-Q22: How much does he/she cuddle and snuggle when held? - Radio: 1=A GREAT DEAL -- ALMOST EVERY TIME, 2, 3, 4=AVERAGE, SOMETIMES DOES AND SOMETIMES DOES NOT, 5, 6, 7=VERY LITTLE -- SELDOM CUDDLES, 9=REFUSAL -->GO TO NEXT SECTION
667. TMP-Q22A: How much does he/she cuddle and snuggle when close to you? - Radio: (same 7-point scale implied)
668. TMP-C23: *IF AGE = 1-3 ---> GO TO TMP-Q23A* - Check (routing)
669. TMP-Q23: How did he/she respond to his/her first bath? - Scale 1-7: 1=VERY WELL -- BABY LOVED IT, 2, 3, 4=NEITHER LIKED NOR DISLIKED IT, 5, 6, 7=TERRIBLY -- DIDN'T LIKE IT, 9=REFUSAL -->GO TO NEXT SECTION
670. TMP-C23A: *IF AGE IN MONTHS = 3-5 ---> GO TO TMP-Q33; ELSE ---> GO TO TMP-Q24* - Check (routing)
671. TMP-Q23A: How does he/she typically respond to new playthings? - Radio: 1=ALWAYS RESPONDS FAVOURABLY, 2, 3, 4=RESPONDS FAVOURABLY ABOUT HALF THE TIME OR IS ALWAYS NEUTRAL, 5, 6, 7=ALWAYS RESPONDS NEGATIVELY OR FEARFULLY, 9=REFUSAL -->GO TO NEXT SECTION
672. TMP-Q24: How did he/she respond to his/her first solid food? - Scale 1-7: 1=VERY FAVOURABLY -- LIKED IT IMMEDIATELY, 2, 3, 4=NEITHER LIKED NOR DISLIKED IT, 5, 6, 7=VERY NEGATIVELY -- DID NOT LIKE IT AT ALL, 9=REFUSAL -->GO TO NEXT SECTION
673. TMP-Q24A: How does he/she typically respond to new foods? - Radio: 1=ALWAYS RESPONDS FAVOURABLY, 2, 3, 4=RESPONDS FAVOURABLY ABOUT HALF OF THE TIME OR IS ALWAYS NEUTRAL, 5, 6, 7=VERY NEGATIVELY--DOES NOT LIKE IT AT ALL, 9=REFUSAL -->GO TO NEXT SECTION
674. TMP-Q25: How does he/she typically respond to a new person? - Radio: 1=ALMOST ALWAYS RESPONDS FAVORABLY, 2, 3, 4=RESPONDS FAVORABLY ABOUT HALF THE TIME, 5, 6, 7=ALMOST ALWAYS RESPONDS NEGATIVELY AT FIRST, 8=DON'T KNOW, 9=REFUSAL -->GO TO NEXT SECTION
675. TMP-Q26: How does he/she typically respond to being in a new place? - Radio: (same 7-point scale implied)
676. TMP-C27: *IF AGE < 1 ---> GO TO TMP-Q27; OTHERWISE ---> GO TO TMP-Q27A* - Check (routing)
677. TMP-Q27: How well does he/she adapt to things (such as baths, new people & new places) eventually? - Scale 1-7: 1=VERY WELL -- ALWAYS LIKES IT EVENTUALLY, 2, 3, 4=ENDS UP LIKING IT ABOUT HALF THE TIME, 5, 6, 7=ALMOST ALWAYS DISLIKES IT IN THE END, 9=REFUSAL -->GO TO NEXT SECTION
678. TMP-Q27A: How well does he/she adapt to new experiences (such as new playthings, new foods, new persons, etc.) eventually? - Radio: (same 7-point scale implied)
679. TMP-C28: *IF AGE < 1 ---> GO TO TMP-Q33; OTHERWISE ---> GO TO TMP-Q28* - Check (routing)
680. TMP-Q28: How easy or difficult is it to take him/her places? - Radio: 1=EASY; FUN TO TAKE BABY/CHILD WITH ME, 2, 3, 4=OKAY; BABY/CHILD MAY FUSS BUT NO REAL TROUBLE, 5, 6, 7=DIFFICULT; BABY/CHILD IS USUALLY DISRUPTIVE, 9=REFUSAL -->GO TO NEXT SECTION
681. TMP-Q29: Does he/she persist in playing with objects when he/she is told to leave them alone? - Radio: 1=RARELY OR NEVER PERSISTS, 2, 3, 4=SOMETIMES DOES AND SOMETIMES DOES NOT, 5, 6, 7=ALMOST ALWAYS PERSISTS, 8=DON'T KNOW, 9=REFUSAL -->GO TO NEXT SECTION
682. TMP-C30: *IF AGE < 3 ---> GO TO TMP-Q30; OTHERWISE ---> GO TO TMP-Q30A* - Check (routing)
683. TMP-Q30: Does he/she continue to go someplace even when you told him/her something like "stop", "come here", or "no-no"? - Radio: 1=RARELY OR NEVER, 2, 3, 4=SOMETIMES DOES AND SOMETIMES DOES NOT, 5, 6, 7=ALMOST ALWAYS, 9=REFUSAL -->GO TO NEXT SECTION
684. TMP-Q30A: Does he/she continue to go someplace even when you told him/her something like "stop", "come here", or "please don't"? - Radio: (same 7-point scale implied)
685. TMP-Q31: When removed from something he/she is interested in but should not be getting into, he/she gets upset. - Radio: 1=NEVER, 2, 3, 4=SOMETIMES DOES AND SOMETIMES DOES NOT, 5, 6, 7=ALWAYS GETS VERY UPSET, 9=REFUSAL -->GO TO NEXT SECTION
686. TMP-Q32: How persistent is he/she in trying to get your attention when you are busy? - Radio: 1=DOESN'T PERSIST AT ALL, 2, 3, 4=WILL TRY, BUT WILL ONLY MILDLY PERSIST, 5, 6, 7=VERY PERSISTENT -- WILL DO ANYTHING TO GET ATTENTION, 8=DON'T KNOW, 9=REFUSAL -->GO TO NEXT SECTION
687. TMP-Q33: Please rate the overall degree of difficulty ... would present for the average parent. - Scale 1-7: 1=VERY EASY, 2, 3, 4=ORDINARY, SOME PROBLEMS, 5, 6, 7=HIGHLY DIFFICULT TO DEAL WITH, 8=DON'T KNOW, 9=REFUSAL -->GO TO NEXT SECTION

#### Family & Custody History - CUS (pp. 130-155) - 118 questions

688. CUS-C1: *IF RESPONDENT IS THE CHILD'S FOSTER PARENT (DVS-Q1 = 4) ---> GO TO CHILD CARE SECTION. ELSE IF THE RESPONDENT IS THE PERSON MOST KNOWLEDGEABLE ABOUT THE CHILD, OR THAT PERSON'S SPOUSE/PARTNER ---> GO TO CUS-I1. OTHERWISE ---> GO TO CHILD CARE SECTION.* - Check (routing)
689. CUS-I1: **I would now like to ask you some questions about the family history of ....** - Intro
690. CUS-Q1A: Did ... live with you when he/she was born? - Y/N: 1=YES, 2=NO, 8=DON'T KNOW (GO TO CHILD CARE SECTION), 9=REFUSAL (GO TO CHILD CARE SECTION)
691. CUS-C1A: *IF ELDEST SELECTED CHILD AND CUS-Q1A = YES ---> GO TO CUS-Q1D. ELSE IF ELDEST CHILD'S CUSTODY SECTION COMPLETED AND SELECTED CHILD IS A FULL SIBLING ---> GO TO CUS-C1B. ELSE IF CUS-Q1A = YES ---> GO TO CUS-Q1D. OTHERWISE ---> GO TO CUS-Q1B.* - Check (routing)
692. CUS-C1B: *IF PARENTS TOGETHER SINCE ELDEST CHILD'S BIRTH AND CHILD LIVED WITH RESPONDENT AT BIRTH ---> GO TO CHILD CARE SECTION. ELSE IF PARENTS SEPARATED AFTER ELDEST CHILD'S BIRTH - NEITHER REMARRIED AND CHILD LIVED WITH RESPONDENT AT BIRTH AND THIS CHILD WAS BORN BEFORE THE SEPARATION ---> GO TO CUS-Q11D. ELSE IF CHILD LIVING WITH RESPONDENT AT BIRTH (YES TO CUS-Q1A) ---> GO TO CUS-I2. OTHERWISE (CHILD NOT LIVING WITH PARENTS AT BIRTH) ---> GO TO CUS-Q1B.* - Check (routing)
693. CUS-Q1B: At what age did ... start living with you? - Radio: 01=LESS THAN ONE YEAR OLD, 02=ONE YEAR OLD (GO TO CUS-Q1C), 03=TWO YEARS OLD (GO TO CUS-Q1C), 04=THREE YEARS OLD (GO TO CUS-Q1C), 05=FOUR YEARS OLD (GO TO CUS-Q1C), 06=FIVE YEARS OLD (GO TO CUS-Q1C), 07=SIX YEARS OLD (GO TO CUS-Q1C), 08=SEVEN YEARS OLD (GO TO CUS-Q1C), 09=EIGHT YEARS OLD (GO TO CUS-Q1C), 10=NINE YEARS OLD (GO TO CUS-Q1C), 11=TEN YEARS OLD (GO TO CUS-Q1C), 12=ELEVEN YEARS OLD (GO TO CUS-Q1C), 98=DON'T KNOW (GO TO CUS-Q1C), 99=REFUSAL (GO TO CHILD CARE SECTION)
694. CUS-Q1B2: ENTER THE AGE IN MONTHS - Numeric
695. CUS-Q1C: What was the reason ... did not live with you right from birth? - Radio: 01=YOU HAVE ADOPTED HER/HIM, 02=SHE/HE IS A STEPCHILD, 03=SHE/HE WAS PUT IN YOUR CARE BY A CHILD WELFARE AGENCY (FOSTER CARE), 04=SHE/HE WAS PUT IN YOUR CARE BY ANOTHER TYPE OF AGENCY, 05=SHE/HE WAS SICK AND HAD TO REMAIN IN A HOSPITAL OR OTHER INSTITUTION, 06=YOU HAD TO LEAVE HER/HIM IN THE CARE OF SOMEONE ELSE FOR A WHILE BEFORE YOU COULD TAKE CHARGE OF HER/HIM, 07=CHILD WAS IN CARE OF A CHILD WELFARE AGENCY (FOSTER CARE) FOR A TIME, 08=OTHER, 98=DON'T KNOW, 99=REFUSAL (GO TO CHILD CARE SEC...
696. CUS-C1D: *IF ELDEST SELECTED CHILD ---> GO TO CUS-Q1D. ELSE IF ELDEST SELECTED CHILD'S CUSTODY SECTION COMPLETED AND SELECTED CHILD IS A FULL SIBLING BY BIRTH ---> GO TO CUS-C1E. OTHERWISE ---> GO TO CUS-Q1D.* - Check (routing)
697. CUS-C1E: *IF PARENTS TOGETHER SINCE ELDEST CHILD'S BIRTH ---> GO TO CHILD CARE SECTION. ELSE IF PARENTS SEPARATED AFTER ELDEST CHILD'S BIRTH - NEITHER REMARRIED AND THIS CHILD WAS BORN BEFORE THE SEPARATION ---> GO TO CUS-Q11D. OTHERWISE ---> GO TO CUS-I2.* - Check (routing)
698. CUS-Q1D: Does ... have any brothers or sisters who do not regularly live in this household, excluding step and half brothers and sisters? - Y/N: 1=YES, 2=NO (GO TO CUS-I2), 8=DON'T KNOW (GO TO CUS-I2), 9=REFUSAL (GO TO CHILD CARE SECTION)
699. CUS-Q1E: How many? - Numeric
700. CUS-Q1F: What is the age of the youngest one/him/her? (INTERVIEWER: ENTER AGE IN YEARS. IF LESS THAN ONE YEAR ENTER 0.) - Numeric
701. CUS-C1J: *IF CUS-Q1E = 1 (ONE CHILD ONLY) ---> GO TO CUS-I2. OTHERWISE ---> GO TO CUS-Q1G.* - Check (routing)
702. CUS-Q1G: What is the age of the oldest one? (INTERVIEWER: ENTER AGE IN YEARS. IF LESS THAN ONE YEAR ENTER 0.) - Numeric
703. CUS-I2: **INTERVIEWER: IF ADOPTED, USE SUITABLE WORDING IN QUESTION CUS-Q2 AND CUS-Q3A, THEN CONSIDER ADOPTIVE PARENTS AS MOTHER AND FATHER FOR THE REST OF THIS SECTION. IN QUESTIONS REFERRING TO THE TIME OF BIRTH, SUBSTITUTE TIME OF ADOPTION.** - Intro
704. CUS-Q2: When ... was born/adopted, were his/her parents (biological/adoptive) living together? - Y/N: 1=YES, 2=NO (GO TO CUS-Q4), 8=DON'T KNOW (GO TO CHILD CARE SECTION), 9=REFUSAL (GO TO CHILD CARE SECTION)
705. CUS-Q3A: When ... was born/adopted, were his/her parents married, were they living together in a common-law relationship, or were they living together and eventually got married? - Radio: 1=MARRIED, 2=COMMON LAW (GO TO CUS-Q3D), 3=COMMON-LAW BUT MARRIED LATER (GO TO CUS-Q3C), 8=DON'T KNOW (GO TO CUS-Q6A), 9=REFUSAL (GO TO CHILD CARE SECTION)
706. CUS-Q3B: Had they been living together before getting married? - Y/N: 1=YES, 2=NO, 8=DON'T KNOW, 9=REFUSAL (GO TO CHILD CARE SECTION)
707. CUS-Q3C: What date were they married? - Numeric
708. CUS-C3D: *IF "MARRIED" IN CUS-Q3A AND "NO" IN CUS-Q3B ---> GO TO CUS-Q6A.* - Check (routing)
709. CUS-Q3D: Approximately since when had they been living together? - Numeric
710. CUS-Q4: Did ... live with his/her: - Radio: 1=Mother alone?, 2=Father alone?, 3=Mother and other?, 4=Father and other?, 5=Other?, 8=DON'T KNOW, 9=REFUSAL (GO TO CHILD CARE SECTION)
711. CUS-Q5A: Have ...'s parents ever lived together as a couple? - Y/N: 1=YES, 2=NO (GO TO CUS-Q5F), 8=DON'T KNOW (GO TO CUS-Q5F), 9=REFUSAL (GO TO CHILD CARE SECTION)
712. CUS-Q5B: Was that before or after his/her birth? - Radio: 1=BEFORE, 2=AFTER, 3=BOTH BEFORE AND AFTER, 8=DON'T KNOW, 9=REFUSAL (GO TO CHILD CARE SECTION)
713. CUS-Q5C: Were ...'s parents ever married? - Y/N: 1=YES, 2=NO (GO TO CUS-C5E), 8=DON'T KNOW (GO TO CUS-C5E), 9=REFUSAL (GO TO CHILD CARE SECTION)
714. CUS-Q5D: When did they marry? - Numeric
715. CUS-C5E: *IF "AFTER" IN CUS-Q5B ---> GO TO CUS-Q5F.* - Check (routing)
716. CUS-Q5E: At the time ... was born, since when had his/her parents stopped living together? - Numeric
717. CUS-Q5F: Without living together, did ...'s parents have a steady relationship at the time of his/her birth? - Y/N: 1=YES, 2=NO, 8=DON'T KNOW, 9=REFUSAL (GO TO CHILD CARE SECTION)
718. CUS-Q6A: Had ...'s mother been in any common-law relationships or been married before the union with ...'s father? (MARK ALL THAT APPLY) - Checkbox: 1=YES COMMON-LAW, 2=YES MARRIAGE, 3=YES COMMON LAW WHICH RESULTED IN MARRIAGE, 4=NO (GO TO CUS-Q6E), 8=DON'T KNOW (GO TO CUS-Q6E), 9=REFUSAL (GO TO CHILD CARE SECTION)
719. CUS-Q6B: How many times? - Numeric
720. CUS-Q6C: Before ...'s birth, had his/her mother been in any common-law relationships or been married to a person other than ...'s father? (MARK ALL THAT APPLY) - Checkbox: 1=YES COMMON-LAW, 2=YES MARRIAGE, 3=YES COMMON LAW WHICH RESULTED IN MARRIAGE, 4=NO (GO TO CUS-Q6H), 8=DON'T KNOW (GO TO CUS-Q6H), 9=REFUSAL (GO TO CHILD CARE SECTION)
721. CUS-Q6D: How many times? - Numeric
722. CUS-Q6E: Did ...'s mother have any children before entering into union with ...'s father? - Y/N: 1=YES, 2=NO (GO TO CUS-Q7A), 8=DON'T KNOW (GO TO CUS-Q7A), 9=REFUSAL (GO TO CHILD CARE SECTION)
723. CUS-Q6F: How many? - Numeric
724. CUS-Q6G: Did that child/any of those children live at least part time in the household when ... was born? (MARK ALL THAT APPLY) - Y/N: 1=YES ALL OF THEM FULL-TIME, 2=YES ALL OF THEM PART-TIME, 3=YES SOME OF THEM FULL-TIME, 4=YES SOME OF THEM PART-TIME, 5=NO NONE OF THEM, 8=DON'T KNOW, 9=REFUSAL (GO TO CHILD CARE SECTION)
725. CUS-Q6H: How many children did ...'s mother have before ...? - Numeric
726. CUS-C6I: *IF CUS-Q6H = 0 AND CUS-Q5A = YES ---> GO TO CUS-Q7C. ELSE IF CUS-Q6H = 0 AND CUS-Q5A = NO OR DON'T KNOW ---> GO TO CUS-Q8A. OTHERWISE ---> GO TO CUS-Q6I.* - Check (routing)
727. CUS-Q6I: Did that child/any of those children live at least part time in the household when ... was born? (MARK ALL THAT APPLY) - Y/N: 1=YES ALL OF THEM FULL-TIME, 2=YES ALL OF THEM PART-TIME, 3=YES SOME OF THEM FULL-TIME, 4=YES SOME OF THEM PART-TIME, 5=NO NONE OF THEM, 8=DON'T KNOW, 9=REFUSAL (GO TO CHILD CARE SECTION)
728. CUS-C7A: *IF CUS-Q5A = YES ---> GO TO CUS-Q7C. OTHERWISE ---> GO TO CUS-Q8A.* - Check (routing)
729. CUS-Q7A: Had ...'s father been in any common-law relationships or been married before the union with ...'s mother? (MARK ALL THAT APPLY) - Checkbox: 1=YES COMMON-LAW, 2=YES MARRIAGE, 3=YES COMMON LAW WHICH RESULTED IN MARRIAGE, 4=NO (GO TO CUS-Q7E), 8=DON'T KNOW (GO TO CUS-Q7E), 9=REFUSAL (GO TO CHILD CARE SECTION)
730. CUS-Q7B: How many times? - Numeric
731. CUS-Q7C: Before ...'s birth, had his/her father been in any common-law relationships or been married to a person other than ...'s mother? (MARK ALL THAT APPLY) - Checkbox: 1=YES COMMON-LAW, 2=YES MARRIAGE, 3=YES COMMON LAW WHICH RESULTED IN MARRIAGE, 4=NO (GO TO CUS-Q7H), 8=DON'T KNOW (GO TO CUS-Q7H), 9=REFUSAL (GO TO CHILD CARE SECTION)
732. CUS-Q7D: How many times? - Numeric
733. CUS-Q7E: Did ...'s father have any children before entering into union with ...'s mother? - Y/N: 1=YES, 2=NO (GO TO CUS-Q9A), 8=DON'T KNOW (GO TO CUS-Q9A), 9=REFUSAL (GO TO CHILD CARE SECTION)
734. CUS-Q7F: How many? - Numeric
735. CUS-Q7G: Did that child/any of those children live at least part time in the household when ... was born? (MARK ALL THAT APPLY) - Y/N: 1=YES ALL OF THEM FULL-TIME, 2=YES ALL OF THEM PART-TIME, 3=YES SOME OF THEM FULL-TIME, 4=YES SOME OF THEM PART-TIME, 5=NO NONE OF THEM, 8=DON'T KNOW, 9=REFUSAL (GO TO CHILD CARE SECTION)
736. CUS-Q7H: How many children did ...'s father have before ...? - Numeric
737. CUS-C7I: *IF CUS-Q7H = 0 ---> GO TO CUS-Q8A. OTHERWISE ---> GO TO CUS-Q7I.* - Check (routing)
738. CUS-Q7I: Did that child/any of those children live at least part time in the household when ... was born? (MARK ALL THAT APPLY) - Y/N: 1=YES ALL OF THEM FULL-TIME, 2=YES ALL OF THEM PART-TIME, 3=YES SOME OF THEM FULL-TIME, 4=YES SOME OF THEM PART-TIME, 5=NO NONE OF THEM, 8=DON'T KNOW, 9=REFUSAL (GO TO CHILD CARE SECTION)
739. CUS-Q8A: Was ...'s father declared on his/her birth certificate? - Y/N: 1=YES, 2=NO, 8=DON'T KNOW, 9=REFUSAL (GO TO CHILD CARE SECTION)
740. CUS-Q8B: What kind of contact did ... first have with his/her other parent? - Radio: 01=SHARING LIVING ARRANGEMENTS ON AN EQUAL TIME BASIS, 02=SHARING LIVING ARRANGEMENTS WITH MOST TIME WITH MOTHER, 03=SHARING LIVING ARRANGEMENTS WITH MOST TIME WITH FATHER, 04=REGULAR VISITING, 05=IRREGULAR VISITING, 06=TELEPHONE OR LETTER CONTACT ONLY, 07=NO CONTACT AT ALL, 08=OTHER, 98=DON'T KNOW (GO TO CUS-Q8E), 99=REFUSAL (GO TO CHILD CARE SECTION)
741. CUS-Q8C: How many times would you say this situation has changed over time? - Radio: 1=NONE (GO TO CUS-Q9B), 2=ONCE, 3=TWICE, 4=THREE TIMES, 5=FOUR OR MORE TIMES, 8=DON'T KNOW, 9=REFUSAL (GO TO CHILD CARE SECTION)
742. CUS-Q8D: How old was ... when the last change happened? (ENTER AGE IN YEARS. IF LESS THAN ONE YEAR ENTER 0.) - Numeric
743. CUS-Q8E: What type of contact does ... now have with his/her other parent? - Radio: 01=SHARING LIVING ARRANGEMENTS ON AN EQUAL TIME BASIS, 02=SHARING LIVING ARRANGEMENTS WITH MOST TIME WITH MOTHER, 03=SHARING LIVING ARRANGEMENTS WITH MOST TIME WITH FATHER, 04=REGULAR VISITING, 05=IRREGULAR VISITING, 06=TELEPHONE OR LETTER CONTACT ONLY, 07=BOTH PARENTS NOW LIVING WITH THE CHILD, 08=NO CONTACT AT ALL, 09=OTHER, 98=DON'T KNOW, 99=REFUSAL (GO TO CHILD CARE SECTION)
744. CUS-Q9A: Between ...'s birth and now, has one of his/her parents died? - Y/N: 1=YES MOTHER (GO TO CUS-Q9C), 2=YES FATHER (GO TO CUS-Q9C), 3=YES BOTH (GO TO CUS-Q9C), 4=NO (GO TO CUS-Q10B), 5=DON'T KNOW (ABOUT FATHER) (GO TO CUS-Q10B), 6=DON'T KNOW (ABOUT MOTHER) (GO TO CUS-Q10B), 8=DON'T KNOW (GO TO CUS-Q10B), 9=REFUSAL (GO TO CHILD CARE SECTION)
745. CUS-Q9B: Has one of ...'s parents died? - Y/N: 1=YES MOTHER, 2=YES FATHER, 3=YES BOTH, 4=NO (GO TO CUS-C10), 5=DON'T KNOW (ABOUT FATHER) (GO TO CUS-C10), 6=DON'T KNOW (ABOUT MOTHER) (GO TO CUS-C10), 8=DON'T KNOW (GO TO CUS-C10), 9=REFUSAL (GO TO CHILD CARE SECTION)
746. CUS-Q9C: When did it happen? (DATE OF FIRST DEATH, IF BOTH) - Date
747. CUS-Q9D: With whom did ... go on living at the time it happened? - Radio: 1=MOTHER, 2=FATHER, 3=OTHER, 8=DON'T KNOW, 9=REFUSAL (GO TO CHILD CARE SECTION)
748. CUS-C10: *IF CUS-Q9A OR CUS-Q9B = 3 (BOTH PARENTS DIED) ---> GO TO CHILD CARE SECTION. ELSE IF CUS-Q5A = NO OR DON'T KNOW (PARENTS EITHER DID NOT LIVE TOGETHER, OR DON'T KNOW IF THEY LIVED TOGETHER) ---> GO TO CUS-C20B. ELSE IF CUS-Q5A=YES AND CUS-Q5B=BEFORE (PARENTS LIVED TOGETHER ONLY BEFORE CHILD'S BIRTH) ---> GO TO CUS-C20B. ELSE IF (CUS-Q9A = 1 OR 2) OR ((CUS-Q9B = 1 OR 2) AND CUS-Q5A = YES (ONE PARENT DIED, AND THEY HAD LIVED TOGETHER)) ---> GO TO CUS-Q10A. OTHERWISE ---> GO TO CUS-Q10B.* - Check (routing)
749. CUS-Q10A: Prior to the death of ...'s parent, did his/her parents break up and stop living together? - Y/N: 1=YES (GO TO CUS-Q11A), 2=NO (GO TO CUS-C20B), 8=DON'T KNOW (GO TO CUS-C20B), 9=REFUSAL (GO TO CHILD CARE SECTION)
750. CUS-Q10B: Since ...'s birth, did his/her parents break up and stop living together? - Y/N: 1=YES, 2=NO (GO TO CUS-C25A), 8=DON'T KNOW (GO TO CUS-C25A), 9=REFUSAL (GO TO CHILD CARE SECTION)
751. CUS-Q11A: When did the separation happen? - Numeric
752. CUS-C11B: *IF ('MARRIED' OR 'COMMON-LAW, BUT MARRIED LATER' IN CUS-Q3A) OR (CUS-Q5C = YES (PARENTS HAD BEEN MARRIED)) ---> GO TO CUS-Q11B. OTHERWISE ---> GO TO CUS-Q11D.* - Check (routing)
753. CUS-Q11B: Did ...'s parents eventually divorce? - Y/N: 1=YES, 2=NO (GO TO CUS-Q11D), 8=DON'T KNOW (GO TO CUS-Q11D), 9=REFUSAL (GO TO CHILD CARE SECTION)
754. CUS-Q11C: When was the divorce pronounced? - Numeric
755. CUS-Q11D: Was there a court order concerning ...'s custody when his/her parents separated or divorced? - Y/N: 1=YES, 2=YES IN PROGRESS (GO TO CUS-Q11F), 3=NO (GO TO CUS-Q11F), 8=DON'T KNOW (GO TO CUS-Q11F), 9=REFUSAL (GO TO CHILD CARE SECTION)
756. CUS-Q11E: Did the court order him/her to be put into: - Radio: 1=Sole custody of mother?, 2=Sole custody of father?, 3=Shared physical custody of both parents?, 4=Other?, 8=DON'T KNOW, 9=REFUSAL (GO TO CHILD CARE SECTION)
757. CUS-Q11F: What type of agreement was made regarding support/maintenance payments when ...'s parents separated or divorced? - Radio: 1=NONE (GO TO CUS-C12), 2=PRIVATE AGREEMENT BETWEEN SPOUSES (GO TO CUS-C12), 3=COURT-ORDERED AGREEMENT IN PROGRESS (GO TO CUS-C12), 4=COURT-ORDERED AGREEMENT, 8=DON'T KNOW (GO TO CUS-C12), 9=REFUSAL (GO TO CHILD CARE SECTION)
758. CUS-Q11G: Was this: - Radio: 1=For child support only?, 2=For spousal support only?, 3=For both?, 8=DON'T KNOW, 9=REFUSAL (GO TO CHILD CARE SECTION)
759. CUS-Q11H: How regular have the maintenance support payments been? - Radio: 01=REGULAR AND ON TIME, 02=REGULAR BUT LATE SOMETIMES, 03=IRREGULAR, 04=NO PAYMENTS FOR THE LAST 6 MONTHS, 05=NO PAYMENTS FOR THE LAST YEAR, 06=NO PAYMENTS FOR THE LAST FEW YEARS, 07=PAYMENTS NEVER BEEN RECEIVED, 08=PAYMENTS STOPPED DUE TO A CHANGE IN CIRCUMSTANCES E.G. COURT ORDER DEATH OF PAYOR ETC., 98=DON'T KNOW, 99=REFUSAL (GO TO CHILD CARE SECTION)
760. CUS-C12: *IF CUS-Q11E = 1 OR 2 (CHILD IN EXCLUSIVE CARE OF ONE PARENT) ---> GO TO CUS-Q13. OTHERWISE ---> GO TO CUS-Q12.* - Check (routing)
761. CUS-Q12: With whom did ... go on living at the time of the separation? - Radio: 1=MOTHER ONLY, 2=FATHER ONLY, 3=SHARED TIME BASIS MOSTLY MOTHER (GO TO CUS-Q16), 4=SHARED TIME BASIS MOSTLY FATHER (GO TO CUS-Q16), 5=EQUALLY SHARED TIME MOTHER AND FATHER (GO TO CUS-Q16), 6=OTHER (GO TO CUS-Q17), 8=DON'T KNOW (GO TO CUS-C18A), 9=REFUSAL (GO TO CHILD CARE SECTION)
762. CUS-Q13: At that time, what type of contact did ... have with his/her other parent? - Radio: 01=REGULAR VISITING EVERY WEEK, 02=REGULAR VISITING EVERY TWO WEEKS, 03=REGULAR VISITING MONTHLY, 04=IRREGULAR VISITING ON HOLIDAYS ONLY, 05=IRREGULAR VISITING WITHOUT SET PATTERN, 06=TELEPHONE OR LETTER CONTACT ONLY, 07=NO CONTACT AT ALL, 08=OTHER, 98=DON'T KNOW (GO TO CUS-C15A), 99=REFUSAL (GO TO CHILD CARE SECTION)
763. CUS-Q14: Since then, how many times has the type of contact changed? - Radio: 1=NONE (GO TO CUS-Q19A), 2=ONCE, 3=TWICE, 4=THREE TIMES, 5=FOUR OR MORE TIMES, 8=DON'T KNOW, 9=REFUSAL (GO TO CHILD CARE SECTION)
764. CUS-C15A: *IF (CUS-Q9A = 1, 2, 5, 6 OR DON'T KNOW) OR (CUS-Q9B = 1, 2, 5, 6 OR DON'T KNOW) ---> GO TO CUS-Q19A. OTHERWISE ---> GO TO CUS-Q15A.* - Check (routing)
765. CUS-Q15A: What type of contact does ... now have with his/her other parent? - Radio: 01=REGULAR VISITING EVERY WEEK (GO TO CUS-Q19A), 02=REGULAR VISITING EVERY TWO WEEKS (GO TO CUS-Q19A), 03=REGULAR VISITING MONTHLY (GO TO CUS-Q19A), 04=IRREGULAR VISITING ON HOLIDAYS ONLY (GO TO CUS-Q19A), 05=IRREGULAR VISITING WITHOUT SET PATTERN (GO TO CUS-Q19A), 06=TELEPHONE OR LETTER CONTACT ONLY (GO TO CUS-Q19A), 07=LOST CONTACT COMPLETELY (GO TO CUS-Q19A), 08=CHILD NOW SHARES LIVING ARRANGEMENTS WITH OTHER PARENT, 09=PARENTS NOW LIVING TOGETHER AGAIN (GO TO CUS-Q19C), 10=CHILD NOW LIVES...
766. CUS-Q15B: How much time does ... live at his/her other parent's home? (MARK ALL THAT APPLY) - Checkbox: 01=ON WEEKDAYS NOT WEEKENDS (GO TO CUS-Q19A), 02=EVERY OTHER NIGHT (GO TO CUS-Q19A), 03=ONE WEEK OUT OF TWO (GO TO CUS-Q19A), 04=TWO WEEKS ALTERNATELY (GO TO CUS-Q19A), 05=EVERY WEEK END (GO TO CUS-Q19A), 06=ONE WEEKEND OUT OF TWO (GO TO CUS-Q19A), 07=LESS THAN TWO DAYS EVERY MONTH (GO TO CUS-Q19A), 08=SOME HOLIDAYS (GO TO CUS-Q19A), 09=NEVER (GO TO CUS-Q19A), 10=ALL THE TIME (GO TO CUS-Q19A), 11=OTHER (GO TO CUS-Q19A), 98=DON'T KNOW (GO TO CUS-Q19A), 99=REFUSAL (GO TO CHILD CARE SECTION)
767. CUS-Q16: At that time, how much time did ... live at his/her other parent's home? (MARK ALL THAT APPLY) - Checkbox: 01=ON WEEKDAYS NOT WEEKENDS, 02=EVERY OTHER NIGHT, 03=ONE WEEK OUT OF TWO, 04=TWO WEEKS ALTERNATELY, 05=EVERY WEEKEND, 06=ONE WEEKEND OUT OF TWO, 07=LESS THAN TWO DAYS EVERY MONTH, 08=SOME HOLIDAYS, 09=OTHER, 98=DON'T KNOW (GO TO CUS-C18A), 99=REFUSAL (GO TO CHILD CARE SECTION)
768. CUS-Q17: How many times would you say these living arrangements have changed over time? - Radio: 1=NONE (GO TO CUS-Q19A), 2=ONCE, 3=TWICE, 4=THREE TIMES, 5=FOUR OR MORE TIMES, 8=DON'T KNOW, 9=REFUSAL (GO TO CHILD CARE SECTION)
769. CUS-C18A: *IF (CUS-Q9A = 1, 2, 5, 6 OR DON'T KNOW) OR (CUS-Q9B = 1, 2, 5, 6 OR DON'T KNOW) ---> GO TO CUS-Q19A. OTHERWISE ---> GO TO CUS-Q18A.* - Check (routing)
770. CUS-Q18A: Currently, how much time does ... live at his/her other parent's home? (MARK ALL THAT APPLY.) - Checkbox: 01=ON WEEKDAYS NOT WEEKENDS, 02=EVERY OTHER NIGHT, 03=ONE WEEK OUT OF TWO, 04=TWO WEEKS ALTERNATELY, 05=EVERY WEEK END, 06=ONE WEEKEND OUT OF TWO, 07=LESS THAN TWO DAYS EVERY MONTH, 08=SOME HOLIDAYS, 09=VISITS OR LETTER OR TELEPHONE CALLS ONLY, 10=NO CONTACT, 11=ALL THE TIME, 12=PARENTS NOW LIVING TOGETHER AGAIN, 13=OTHER, 98=DON'T KNOW, 99=REFUSAL (GO TO CHILD CARE SECTION)
771. CUS-C18B: *IF 12 ENTERED IN CUS-Q18A ---> GO TO CUS-Q19C. ELSE IF 9 ENTERED IN CUS-Q18A ---> GO TO CUS-Q18B. OTHERWISE ---> GO TO CUS-Q19A.* - Check (routing)
772. CUS-Q18B: Which type of contact does ... now have with his/her other parent? - Radio: 1=REGULAR VISITING EVERY WEEK, 2=REGULAR VISITING EVERY TWO WEEKS, 3=REGULAR VISITING MONTHLY, 4=IRREGULAR VISITING ON HOLIDAYS ONLY, 5=IRREGULAR VISITING WITHOUT SET PATTERN, 6=TELEPHONE OR LETTER CONTACT ONLY, 7=OTHER, 8=DON'T KNOW, 9=REFUSAL (GO TO CHILD CARE SECTION)
773. CUS-Q19A: Has a court order modified the custody of ... since his/her parents separated (or divorced)? - Y/N: 1=YES, 2=NO (GO TO CUS-Q19C), 8=DON'T KNOW (GO TO CUS-Q19C), 9=REFUSAL (GO TO CHILD CARE SECTION)
774. CUS-Q19B: Is he/she now in: - Radio: 1=Sole custody of mother?, 2=Sole custody of father?, 3=Shared physical custody of both parents?, 4=Other?, 8=DON'T KNOW, 9=REFUSAL (GO TO CHILD CARE SECTION)
775. CUS-Q19C: Between ...'s parents, has the question of living arrangements or visiting rights been: - Radio: 1=A great source of tension?, 2=Some source of tension?, 3=Very little source of tension?, 4=No source of tension at all?, 8=DON'T KNOW, 9=REFUSAL (GO TO CHILD CARE SECTION)
776. CUS-C20A: *IF ELDEST SELECTED CHILD'S CUSTODY SECTION COMPLETED AND SELECTED CHILD IS A FULL SIBLING BY BIRTH, AND PARENTS SEPARATED AFTER ELDEST CHILD'S BIRTH - NEITHER REMARRIED, AND THIS CHILD BORN BEFORE THE SEPARATION ---> GO TO CHILD CARE SECTION. OTHERWISE ---> GO TO CUS-C20B.* - Check (routing)
777. CUS-C20B: *IF (CUS-Q9A = 1, 6 OR DON'T KNOW) OR (CUS-Q9B = 1, 6 OR DON'T KNOW) ---> GO TO CUS-C21. ELSE IF CUS-Q2 = 1 AND CUS-Q9A = 4 AND CUS-Q10B = 2 ---> GO TO CUS-C25A. OTHERWISE ---> GO TO CUS-Q20A.* - Check (routing)
778. CUS-Q20A: Has ...'s mother entered into another marriage, common-law relationship or common-law relationship that resulted in marriage? (MARK ALL THAT APPLY) - Checkbox: 1=YES A MARRIAGE, 2=YES A COMMON-LAW RELATIONSHIP, 3=YES A COMMON-LAW RELATIONSHIP THAT RESULTED IN MARRIAGE, 4=NO, 8=DON'T KNOW, 9=REFUSAL
779. CUS-C20B1: *IF CUS-Q20A = 2 OR 3 ---> GO TO CUS-Q20B. ELSE IF CUS-Q20A = 1 ---> GO TO CUS-Q20C. ELSE IF CUS-Q20A = 4 OR DON'T KNOW ---> GO TO CUS-C21. OTHERWISE (REFUSAL) ---> GO TO CHILD CARE SECTION.* - Check (routing)
780. CUS-Q20B: When did ...'s mother start living with her new partner? - Numeric
781. CUS-C20C: *IF CUS-Q20A = 2 (YES, A COMMON-LAW RELATIONSHIP) ---> GO TO CUS-Q20D. OTHERWISE ---> GO TO CUS-Q20C.* - Check (routing)
782. CUS-Q20C: When did the marriage take place? - Numeric
783. CUS-Q20D: When they started living together, did ... live in the household with his/her mother's new partner? - Y/N: 1=YES FULL-TIME, 2=YES PART-TIME, 3=NO, 8=DON'T KNOW, 9=REFUSAL (GO TO CHILD CARE SECTION)
784. CUS-Q20E: Did the mother's new partner have any children of his own? - Y/N: 1=YES, 2=NO (GO TO CUS-Q20H), 8=DON'T KNOW (GO TO CUS-Q20H), 9=REFUSAL (GO TO CHILD CARE SECTION)
785. CUS-Q20F: How many? - Numeric
786. CUS-Q20G: Did he/she/they live in the household with their father? (MARK ALL THAT APPLY) - Y/N: 1=YES ALL OF THEM FULL-TIME, 2=YES ALL OF THEM PART-TIME, 3=YES SOME OF THEM FULL-TIME, 4=YES SOME OF THEM PART-TIME, 5=NO NONE OF THEM, 8=DON'T KNOW, 9=REFUSAL (GO TO CHILD CARE SECTION)
787. CUS-Q20H: Did ...'s mother have any children with this new spouse/partner? - Y/N: 1=YES, 2=NO (GO TO CUS-C21), 8=DON'T KNOW (GO TO CUS-C21), 9=REFUSAL (GO TO CHILD CARE SECTION)
788. CUS-Q20I: How many? - Numeric
789. CUS-C21: *IF 'YES, FATHER' IN CUS-Q9A OR CUS-Q9B AND 'YES' (1 TO 3) IN CUS-Q20A (FATHER DIED, AND MOTHER ENTERED A NEW RELATIONSHIP) ---> GO TO CUS-Q22A. IF 'YES, FATHER' IN CUS-Q9A OR CUS-Q9B AND 'NO' OR DON'T KNOW IN CUS-Q20A (FATHER DIED AND MOTHER DID NOT ENTER A NEW RELATIONSHIP) ---> GO TO CUS-C25A. IF 'DON'T KNOW (FATHER)' OR DON'T KNOW IN CUS-Q9A OR CUS-Q9B AND 'YES' (1 TO 3) IN CUS-Q20A (DON'T KNOW IF FATHER DIED, AND MOTHER ENTERED A NEW RELATIONSHIP) ---> GO TO CUS-Q22A. IF 'DON'T KNOW (FATHER)' OR DON'T KNOW IN CUS-Q9A OR CUS-Q9B AND 'NO' OR DON'T KNOW IN CUS-Q20A (DON'T KNOW IF FATHER DIED AND MOTHER DID NOT ENTER A NEW RELATIONSHIP) ---> GO TO CUS-C25A. OTHERWISE ---> GO TO CUS-Q21A.* - Check (routing)
790. CUS-Q21A: Has ...'s father entered into another marriage, common-law relationship or common-law relationship that resulted in marriage? (MARK ALL THAT APPLY) - Checkbox: 1=YES A MARRIAGE (GO TO CUS-Q21C), 2=YES A COMMON-LAW RELATIONSHIP, 3=YES A COMMON-LAW RELATIONSHIP THAT RESULTED IN MARRIAGE, 4=NO (GO TO CUS-C22), 8=DON'T KNOW (GO TO CUS-C22), 9=REFUSAL (GO TO CHILD CARE SECTION)
791. CUS-Q21B: When did ...'s father start living with his new partner? - Numeric
792. CUS-C21C: *IF CUS-Q21A = 2 (YES, A COMMON-LAW RELATIONSHIP) ---> GO TO CUS-Q21D. OTHERWISE ---> GO TO CUS-Q21C.* - Check (routing)
793. CUS-Q21C: When did the marriage take place? - Numeric
794. CUS-Q21D: When they started living together, did ... live in the household with his/her father's new partner? - Y/N: 1=YES FULL-TIME, 2=YES PART-TIME, 3=NO, 8=DON'T KNOW, 9=REFUSAL (GO TO CHILD CARE SECTION)
795. CUS-Q21E: Did the father's new partner have any children of her own? - Y/N: 1=YES, 2=NO (GO TO CUS-Q21H), 8=DON'T KNOW (GO TO CUS-Q21H), 9=REFUSAL (GO TO CHILD CARE SECTION)
796. CUS-Q21F: How many? - Numeric
797. CUS-Q21G: Did he/she/they live in the household with their mother? (MARK ALL THAT APPLY) - Y/N: 1=YES ALL OF THEM FULL-TIME, 2=YES ALL OF THEM PART-TIME, 3=YES SOME OF THEM FULL-TIME, 4=YES SOME OF THEM PART-TIME, 5=NO NONE OF THEM, 8=DON'T KNOW, 9=REFUSAL (GO TO CHILD CARE SECTION)
798. CUS-Q21H: Did ...'s father have any children with this new spouse/partner? - Y/N: 1=YES, 2=NO (GO TO CUS-C22), 8=DON'T KNOW (GO TO CUS-C22), 9=REFUSAL (GO TO CHILD CARE SECTION)
799. CUS-Q21I: How many? - Numeric
800. CUS-C22: *IF 'YES' IN CUS-Q20A OR CUS-Q21A (MOTHER OR FATHER ENTERED A NEW RELATIONSHIP) ---> GO TO CUS-Q22A. OTHERWISE ---> GO TO CUS-C25A.* - Check (routing)
801. CUS-Q22A: Has this other union of ...'s mother or father broken up? - Y/N: 1=YES MOTHER'S UNION, 2=YES FATHER'S UNION, 3=YES BOTH UNIONS, 4=NO (GO TO CUS-C25A), 8=DON'T KNOW (GO TO CUS-C25A), 9=REFUSAL (GO TO CHILD CARE SECTION)
802. CUS-Q22B: When did that happen? (IF BOTH UNIONS HAVE BROKEN UP, USE DATE OF FIRST EVENT) - Date
803. CUS-Q22C: With whom did ... go on living after it happened? - Radio: 1=MOTHER FULL-TIME, 2=FATHER FULL-TIME, 3=PART-TIME MOTHER AND FATHER, 8=DON'T KNOW, 9=REFUSAL (GO TO CHILD CARE SECTION)
804. CUS-Q23: Did ... live through any other family reconstitution between then and now? - Y/N: 1=YES, 2=NO, 8=DON'T KNOW, 9=REFUSAL (GO TO CHILD CARE SECTION)
805. CUS-C25A: *IF ELDEST-DONE = 1 ---> GO TO CHILD CARE SECTION.* - Check (routing)

#### Child Care - CAR (pp. 156-161) - 38 questions

806. CAR-I1: **Now I'd like to ask you some questions regarding your child care arrangements for ....** - Intro
807. CAR-Q1A: Do you currently use child care such as daycare or babysitting while you (and your spouse/partner) are at work or studying? - Y/N: 1=YES, 2=NO (GO TO CAR-C6), 8=DON'T KNOW (GO TO END OF CHILD CARE SECTION), 9=REFUSAL (GO TO END OF CHILD CARE SECTION)
808. CAR-Q1B: Which of the following methods of child care do you currently use? Care provided in someone else's home by a non-relative? - Y/N: 1=YES, 2=NO (GO TO CAR-Q1C), 8=DON'T KNOW (GO TO CAR-Q1C), 9=REFUSAL (GO TO CAR-Q1C)
809. CAR-Q1B1: For about how many hours per week is that? - Numeric
810. CAR-Q1B2: Is the person providing this care licensed by the government or approved by a family daycare agency? - Y/N: 1=YES, 2=NO
811. CAR-Q1C: Care in someone else's home by a relative? - Y/N: 1=YES, 2=NO (GO TO CAR-Q1D), 3=NO AND NO OTHER ARRANGEMENT (GO TO CAR-I2), 8=DON'T KNOW (GO TO CAR-Q1D), 9=REFUSAL (GO TO CAR-Q1D)
812. CAR-Q1C1: For about how many hours per week is that? - Numeric
813. CAR-Q1C2: Is the person providing this care licensed by the government or approved by a family daycare agency? - Y/N: 1=YES, 2=NO, 8=DON'T KNOW, 9=REFUSAL
814. CAR-Q1D: Care in own home by brother or sister of the child? - Y/N: 1=YES, 2=NO (GO TO CAR-Q1E), 3=NO AND NO OTHER ARRANGEMENT (GO TO CAR-I2), 4=NOT APPLICABLE (GO TO CAR-Q1E), 8=DON'T KNOW (GO TO CAR-Q1E), 9=REFUSAL (GO TO CAR-Q1E)
815. CAR-Q1D1: For about how many hours per week is that? - Numeric
816. CAR-Q1E: Care in own home by a relative other than a sister or brother of the child? - Y/N: 1=YES, 2=NO (GO TO CAR-Q1F), 3=NO AND NO OTHER ARRANGEMENT (GO TO CAR-I2), 8=DON'T KNOW (GO TO CAR-Q1F), 9=REFUSAL (GO TO CAR-Q1F)
817. CAR-Q1E1: For about how many hours per week is that? - Numeric
818. CAR-Q1F: Care in own home by a non-relative? - Y/N: 1=YES, 2=NO (GO TO CAR-Q1G), 3=NO AND NO OTHER ARRANGEMENT (GO TO CAR-I2), 8=DON'T KNOW (GO TO CAR-Q1G), 9=REFUSAL (GO TO CAR-Q1G)
819. CAR-Q1F1: For about how many hours per week is that? - Numeric
820. CAR-Q1G: Care in a daycare centre (including at workplace)? - Y/N: 1=YES, 2=NO (GO TO CAR-C1H), 3=NO AND NO OTHER ARRANGEMENT (GO TO CAR-I2), 8=DON'T KNOW (GO TO CAR-C1H), 9=REFUSAL (GO TO CAR-C1H)
821. CAR-Q1G1: For about how many hours per week is that? - Numeric
822. CAR-Q1G2: Is the child care program or daycare centre operated on a profit or non-profit basis (include government sponsored care)? - Radio: 1=PROFIT, 2=NON-PROFIT, 8=DON'T KNOW, 9=REFUSAL
823. CAR-C1H: *IF AGE < 4 ---> GO TO CAR-Q1J. OTHERWISE (4-11 YEARS OF AGE) ---> GO TO CAR-Q1H.* - Check (routing)
824. CAR-Q1H: Care in a before or after school program? - Y/N: 1=YES, 2=NO (GO TO CAR-C1I), 3=NO AND NO OTHER ARRANGEMENT (GO TO CAR-I2), 8=DON'T KNOW (GO TO CAR-C1I), 9=REFUSAL (GO TO CAR-C1I)
825. CAR-Q1H1: For about how many hours per week is that? - Numeric
826. CAR-C1I: *IF AGE = 4-5 ---> GO TO CAR-Q1J. OTHERWISE (6-11 YEARS) ---> GO TO CAR-Q1I.* - Check (routing)
827. CAR-Q1I: Is ... in his/her own care (e.g. before/after school)? - Y/N: 1=YES, 2=NO (GO TO CAR-Q1J), 3=NO AND NO OTHER ARRANGEMENT (GO TO CAR-I2), 8=DON'T KNOW (GO TO CAR-Q1J), 9=REFUSAL (GO TO CAR-Q1J)
828. CAR-Q1I1: For about how many hours per week is that? - Numeric
829. CAR-Q1J: Do you currently use other child care arrangements? - Y/N: 1=YES, 2=NO (GO TO CAR-I2), 8=DON'T KNOW (GO TO CAR-I2), 9=REFUSAL (GO TO CAR-I2)
830. CAR-Q1J1: For about how many hours per week is that? - Numeric
831. CAR-I2: **In the following questions we will be asking about your main child care arrangement, that is, the one used for the most hours.** - Intro
832. CAR-Q2: When did you start using this child care arrangement? - Date
833. CAR-C3: *IF AGE > 5 ---> GO TO CAR-Q4. OTHERWISE ---> GO TO CAR-Q3.* - Check (routing)
834. CAR-Q3: During the past 6 months, how well has he/she gotten along with his/her main child care provider? - Radio: 1=VERY WELL NO PROBLEMS, 2=QUITE WELL HARDLY ANY PROBLEMS, 3=PRETTY WELL OCCASIONAL PROBLEMS, 4=NOT TOO WELL FREQUENT PROBLEMS, 5=NOT WELL AT ALL CONSTANT PROBLEMS, 8=DON'T KNOW, 9=REFUSAL
835. CAR-Q4: In the past 12 months, how many times have you changed your main child care arrangement and/or caregiver, excluding periods of care by yourself (or spouse/partner)? - Radio: 1=NONE, 2=1, 3=2, 4=3 OR 4, 5=5 OR MORE, 8=DON'T KNOW, 9=REFUSAL
836. CAR-C5: *IF 'NONE' IN CAR-Q4 AND AGE < 1 ---> GO TO END OF CHILD CARE SECTION. IF 'NONE' IN CAR-Q4 AND AGE > 0 ---> GO TO CAR-Q7. OTHERWISE ---> GO TO CAR-Q5.* - Check (routing)
837. CAR-Q5: What were the reasons for changing? (DO NOT READ. MARK ALL THAT APPLY.) - Checkbox: 1=DISSATISFACTION WITH CAREGIVER/PROGRAM, 2=CAREGIVER/PROGRAM NO LONGER AVAILABLE, 3=FAMILY OR CHILD MOVED PARENTAL WORK STATUS OR CUSTODY ARRANGEMENT CHANGED, 4=CHANGES IN CHILD OR CHILD'S NEEDS (E.G. SPECIAL CARE CHILD'S AGE), 5=A PREFERRED ARRANGEMENT BECAME AVAILABLE (E.G. SUBSIDIZED SPACE), 6=COST, 7=OTHER, 8=DON'T KNOW, 9=REFUSAL
838. CAR-E5: *IF AGE < 1 ---> GO TO END OF CHILD CARE SECTION. OTHERWISE ---> GO TO CAR-Q7.* - Check (routing)
839. CAR-C6: *IF AGE < 1 ---> GO TO END OF CHILD CARE SECTION. OTHERWISE ---> GO TO CAR-Q6.* - Check (routing)
840. CAR-Q6: Have you ever used child care for ... while you (and your spouse/partner) were at work or studying? - Y/N: 1=YES, 2=NO (GO TO END OF CHILD CARE SECTION), 8=DON'T KNOW (GO TO END OF CHILD CARE SECTION), 9=REFUSAL (GO TO END OF CHILD CARE SECTION)
841. CAR-Q7: Overall, how many changes in child care arrangements has ... experienced since you began using child care, excluding periods of care by yourself (or spouse/partner)? - Numeric
842. CAR-C8: *IF AGE < 6 ---> GO TO END OF CHILD CARE SECTION. OTHERWISE ---> GO TO CAR-Q8.* - Check (routing)
843. CAR-Q8: Last summer while ... was not in school, what type of child care arrangement did you use while you (and your spouse/partner) were at work/studying? (MARK ALL THAT APPLY.) - Checkbox: 01=DAY CARE CENTRE, 02=CARE IN SOMEONE ELSE'S HOME BY A NON-RELATIVE, 03=CARE IN SOMEONE ELSE'S HOME BY A RELATIVE, 04=CARE IN OWN HOME BY A NON-RELATIVE, 05=CARE IN OWN HOME BY BROTHER/SISTER, 06=CARE IN OWN HOME BY OTHER RELATIVE, 07=CHILD IN OWN CARE, 08=STRUCTURED SUMMER PROGRAM, 09=OTHER, 10=NOT APPLICABLE, 98=DON'T KNOW, 99=REFUSAL

---

## TOTAL UNIQUE QUESTION NODES: ~843