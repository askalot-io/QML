---
askalot_import: 1
source_file: NPHS_Population_Health.pdf
kind: pdf
pages: 66
vision_pages: [1]
assumed_blank: false
normalizer:
  pages: 66
  pages_by_route: {soft: 1, text: 65}
  route_reasons: {reading_order: 1}
  running_lines_dropped: 119
  page_labels_found: 54
  answers_discarded: 0
---

<!-- page 1 read_by="vision" -->

## National Population Health Survey Content For Main Survey

**May 1, 1994**

<!-- page 2 read_by="text_layer" -->

## Table of Contents

Page

Household Record Variables.........................................................................................................................................3
General Component (Form H05)..................................................................................................................................6
Two-Week Disability................................................................................................................................................6
Health Care Utilization.............................................................................................................................................6
Restriction of Activities............................................................................................................................................9
Chronic Conditions.................................................................................................................................................10
Socio-demographic Characteristics.........................................................................................................................11
Country of Birth/Year of Immigration................................................................................................................12
Ethnicity..............................................................................................................................................................12
Language.............................................................................................................................................................12
Race....................................................................................................................................................................13
Education............................................................................................................................................................13
Labour Force.......................................................................................................................................................14
Income.................................................................................................................................................................18
Administration.........................................................................................................................................................19
Health Component for Respondents Aged 12 Years and Older (Form H06)..............................................................20
General Health........................................................................................................................................................20
Height/Weight.........................................................................................................................................................20
Preventive Health Practices.....................................................................................................................................21
Smoking..................................................................................................................................................................22
Alcohol....................................................................................................................................................................23
Physical Activities...................................................................................................................................................24
Injuries....................................................................................................................................................................26
Stress.......................................................................................................................................................................28
Ongoing Problems...............................................................................................................................................28
Recent Life Events..............................................................................................................................................31
Childhood and adult stressors.............................................................................................................................32
Work Stress.............................................................................................................................................................33
Self-Esteem and Mastery.........................................................................................................................................33
Sense of Coherence.................................................................................................................................................34
Health Status...........................................................................................................................................................37
Vision..................................................................................................................................................................37
Hearing................................................................................................................................................................38
Speech.................................................................................................................................................................39
Getting Around....................................................................................................................................................39
Hands and Fingers...............................................................................................................................................40
Feelings...............................................................................................................................................................41
Memory...............................................................................................................................................................41
Thinking..............................................................................................................................................................41
Pain and Discomfort............................................................................................................................................41
Drug Use.................................................................................................................................................................42
Mental Health..........................................................................................................................................................43
Social Support.........................................................................................................................................................49
Health Number........................................................................................................................................................50
Agreement to Share.................................................................................................................................................51
Manitoba Buy-in Questions.....................................................................................................................................52
Alberta Buy-in Questions........................................................................................................................................55
Notes...........................................................................................................................................................................56
Appendix A: Health Component for Respondents Aged 0 to 11 Years Old (Form H06)..…………………………A-1

<!-- page 3 printed="3" read_by="text_layer" -->

**Household Record Variables**
(To be collected at initial contact from knowledgeable household member)
DEMO_INT The next few questions will provide important basic information on the people in your household.
DEMO_Q1 What are the names of all persons now living or staying here who have no usual place of residence
elsewhere?
(First and last names )
DEMO_Q2 Are there any persons away from this household attending school, visiting, travelling or in hospital
who usually live here?

- ___ Yes (go to DEMO-Q1)
- ___ No

DEMO_Q3 Does anyone else live at this dwelling such as young children, relatives, roomers, boarders or
employees?

- ___ Yes (go to DEMO-Q1)
- ___ No

DEMO_Q4 What is ... 's date of birth?
DD/MM/YY (Age is calculated and confirmed with respondent.)

DEMO_Q5 Enter or ask ... 's sex.

- ___ Male
- ___ Female

DEMO_Q6 What is ... current marital status?
(Note: if age < 15, marital status is automatically = single)

- ___ Now married
- ___ Common-law
- ___ Living with a partner
- ___ Single (never married)
- ___ Widowed
- ___ Separated
- ___ Divorced

DEMO_Q7 Enter ... 's family Id code.
(A to Z)
Legal household check.
Reject household at this point if screening criteria are not met.
Selection criteria applied.
DHC4_DAT
DHC4_DOB
DHC4_MOB
DHC4_YOB
DHC4_AGE

DHC4_SEX

DHC4_MAR

DHC4_FID
DHC4_3A

DHC4_3B

<!-- page 4 printed="4" read_by="text_layer" -->

DEMO_Q8 Relationships of everyone to everyone else

Birth Parent Common law partner
Step Parent In-law
Foster Parent Other Related
Birth Child Unrelated
Step Child Husband/Wife
Foster Child Adopted Child
Sister/brother Adoptive Parent
Grandparent Same-sex Partner
Grandchild

HHLD_Q1 Now a few questions about your dwelling. Is this dwelling owned by a member of this household
(even if being paid for)?

- ___ Yes
- ___ No

HHLD_Q3 How many bedrooms are there in this dwelling?
(If no separate, enclosed bedroom enter "00".)

- ___ number of bedrooms (2 digits)

HHLD_Q4 Is there a pet in this household?

- ___ Yes
- ___ No (Go to HHLD-Q6)

HHLD_Q5 What kind of pet?
(Do not read list. Mark all that apply)

- ___ Dog
- ___ Cat
- ___ Other (Go to HHLD-Q6)

HHLD_Q5a Does this pet or do any of these pets live mainly indoors?

- ___ Yes
- ___ No

DHC4_OWN

DHC4_BED

DH_4_P1

DH_4DP2

DH 4 P3

<!-- page 5 printed="5" read_by="text_layer" -->

HHLD_Q6 Record type of dwelling (by interviewer observation)

- ___ Single detached house
- ___ Semi-detached or double (side-by-side)
- ___ Garden house, town-house or row house
- ___ Duplex (one above the other)
- ___ Low-rise apartment (less than 5 stories)
- ___ High-rise apartment (5 or more stories)
- ___ Institution
- ___ Hotel, rooming or lodging house, logging or construction camp, Hutterite Colony
- ___ Mobile home
- ___ Other (Specify _____________)

HHLD_Q7 Information Source Indicator i.e. who is providing the information

HHLD_Q8 Record language of interview

English Persian (Farsi)
French Polish
Arabic Portuguese
Chinese Punjabi
Cree Spanish
German Tagalog (Filipino)
Greek Ukrainian
Hungarian Vietnamese
Italian Other (Specify_________)
Korean
DHC4_DWE

AM34_SRC

AM34_LNG

<!-- page 6 printed="6" read_by="text_layer" -->

**General Component (Form H05)**
(To be completed for all members of the household)
Note: In computer-assisted interviewing the options Don't Know (DK) and Refusal (R) are allowed on every
question.
H05-P1 Who is providing the information for this person's form?
\_______________________________
Two-Week Disability
TWOWK-INT The first few questions ask about ...(r/'s) health during the past 14 days.
TWOWK-Q1 It is important for you to refer to the 14-day period1 from %2WKSAGO% to %YESTERDAY%.
During that period, did ... stay in bed at all because of illness or injury including any nights spent
as a patient in a hospital?

- ___ Yes
- ___ No (Go to TWOWK-Q3)

DK, R (Go to TWOWK-Q5)
TWOWK-Q2 How many days did ... stay in bed for all or most of the day?

- ___ Days (Enter <0> if less than a day.)

(If = 14 days go to TWOWK-Q5)
DK, R (Go to TWOWK-Q5)
TWOWK-Q3 (Not counting days spent in bed) During those 14 days, were there any days that ... cut down on
things you/he/she normally do/does because of illness or injury?

- ___ Yes
- ___ No (Go to TWOWK-Q5)

DK, R (Go to TWOWK-Q5)
TWOWK-Q4 How many days did ... cut down on things for all or most of the day?

- ___ Days

(Enter <0> if less than a day.)
TWOWK-Q5 Do(es) ... have a regular medical doctor?

- ___ Yes
- ___ No

**Health Care Utilization**
UTIL-CINT If age<12, go to next section.
UTIL-INT Now I'd like to ask about ...(r/'s) contacts with health professionals during the past 12 months2.
TWC4_1

TWC4_2

TWC4_3

TWC4_4

TWC4_5
AM54_SRC

<!-- page 7 printed="7" read_by="text_layer" -->

UTIL-Q1 In the past 12 months, have/has ... been a patient overnight in a hospital, nursing home or
convalescent home?

- ___ Yes
- ___ No (Go to UTIL-Q2)

DK (Go to UTIL-Q2)
R (Go to next section)

UTIL-Q1a For how many nights in the past 12 months?

- ___ nights

UTIL-Q2 (Not counting when ... were/was an overnight patient) In the past 12 months, how many times
have/has ... seen or talked on the telephone with [fill category] about your/his/her physical,
emotional or mental health:

a) General practitioner or family physician
b) Eye specialist (such as an ophthalmologist or optometrist)
c) Other medical doctor (such as surgeon, allergist, gynaecologist, psychiatrist, etc.)
d) A nurse for care or advice
e) Dentist or orthodontist
f) Chiropractor
g) Physiotherapist
h) Social worker or counsellor
i) Psychologist
j) Speech, audiology or occupational therapist

For each response >0 in a), c), or d), ask UTIL-Q3.

UTIL-Q3 Where did the most recent contact take place?
(Read list. Mark one only.)

- ___ Walk-in clinic
- ___ Outpatient clinic in hospital
- ___ Hospital emergency room
- ___ Health professional's office
- ___ Community health centre /CLSC
- ___ At home
- ___ Telephone consultation only
- ___ Other (Specify_____________)

UTIL-Q4 People may also use alternative health care services. In the past 12 months, have/has ... seen or
talked to an alternative health care provider such as an acupuncturist, naturopath, homeopath or
massage therapist about your/his/her physical, emotional or mental health?

- ___ Yes
- ___ No (Go to UTIL-Q6)

DK, R (Go to UTIL-Q6)
HCC4_1

HCC4_1A

HCC4_2A
HCC4_2B
HCC4_2C
HCC4_2D
HCC4_2E
HCC4_2F
HCC4_2G
HCC4_2H
HCC4_2I
HCC4_2J

HCC4_3n

HCC4_4

<!-- page 8 printed="8" read_by="text_layer" -->

UTIL-Q5 Who did ... see or talk to?
(Do not read list. Mark all that apply.)

- ___ Massage therapist
- ___ Acupuncturist
- ___ Homeopath or naturopath
- ___ Feldenkrais or Alexander teacher
- ___ Relaxation therapist
- ___ Biofeedback teacher
- ___ Rolfer
- ___ Herbalist
- ___ Reflexologist
- ___ Spiritual healer
- ___ Religious healer
- ___ Self help group (such as AA, cancer therapy, etc.)
- ___ Other (Specify _____________________)

UTIL-Q6 During the past 12 months, was there ever a time when you/he/she needed health care or advice but
did not receive it?

- ___ Yes
- ___ No (Go to UTIL-C9)

DK, R (Go to UTIL-C9)

UTIL-Q7 Thinking of the most recent time, why did ... not get care?

\____________________________________

- ___ Difficulty getting access to health professional
- ___ Financial constraints
- ___ Felt health care provided inadequate
- ___ Chose not to see health professional
- ___ Other

UTIL-Q8 Again, thinking of the most recent time, what was the type of care that was needed?
(Do not read list. Mark all that apply.)

- ___ Treatment of a physical health problem
- ___ Treatment of an emotional or mental health problem
- ___ A regular check-up (or for regular pre-natal care)
- ___ Care of an injury
- ___ Any other reason (Specify______________)

UTIL-C9 IF age < 18 then go to next section.

UTIL-Q9 Home care services are health care or homemaker services received at home, with the cost being
entirely or partially covered by government. Examples are: nursing care; help with bathing; help
around the home; physiotherapy; counselling; and meal delivery. Have/Has ... received any home
care services in the past 12 months?

- ___ Yes
- ___ No (Go to next section)

DK, R (Go to next section)

UTIL-Q10 What type of services have/has ... received?
HCC4_5A
HCC4_5B
HCC4_5C
HCC4_5D
HCC4_5E
HCC4_5F
HCC4_5G
HCC4_5H
HCC4_5I
HCC4_5J
HCC4_5K
HCC4_4A
HCC4_5L

HCC4_6

HCC4_7WC
and
HCC4G7

HCC4_8A
HCC4_8B
HCC4_8C
HCC4_8D
HCC4_8E

HCC4_9

<!-- page 9 printed="9" read_by="text_layer" -->

(Specify______________________)

- ___ Nursing care
- ___ Personal care
- ___ Housework
- ___ Meal preparation
- ___ Shopping
- ___ Other

**Restriction of Activities**

RESTR-CINT If age<12, go to next section.

RESTR-INT The next few questions deal with any health limitations which affect ... (r/'s) daily activities. In
these questions, "long-term conditions" refer to conditions that have lasted or are expected to last 6
months or more.

RESTR-Q1 Because of a long-term physical or mental condition or a health problem, are/is ... limited in the
kind or amount of activity you/he/she can do:

a) at home?

- ___ Yes
- ___ No

R (Go to next section)

b) at school?

- ___ Yes
- ___ No
- ___ Not applicable

R (Go to next section)

c) at work?

- ___ Yes
- ___ No
- ___ Not applicable

R (Go to next section)

d) in other activities such as transportation to or from work or leisure time activities?

- ___ Yes
- ___ No

R (Go to next section)

RESTR-Q2 Do(es) ... have any long term disabilities or handicaps?

- ___ Yes
- ___ No

R (Go to next section)

If any yes in RESTR-Q1 (a)-(d), ask RESTR-Q3.
If yes in RESTR-Q2 only, ask RESTR-Q4.
RAC4_1A

RAC4_1B

RAC4_1C

RAC4_1D

RAC4_2
HCC4_SC
and
HCC4_10A
HCC4_10C
HCC4_10D
HCC4_10E
HCC4_10F
HCC4_10H

<!-- page 10 printed="10" read_by="text_layer" -->

Otherwise go to RESTR-Q6.

RESTR-Q3 What is the main condition or health problem causing ... to be limited in your/his/her activities?

___________________(25 spaces) (Go to RESTR-Q5)

RESTR-Q4 What is the main condition or health problem causing ... to have a long term disability or
handicap?
___________________(25 spaces)

RESTR-Q5 Which one of the following is the best description of the cause of this condition?
(Read list. Mark one only.)

- ___ Injury - at home
- ___ Injury - sports or recreation
- ___ Injury - motor vehicle
- ___ Injury - work-related
- ___ Existed at birth
- ___ Work environment
- ___ Disease or illness
- ___ Natural aging process
- ___ Psychological or physical abuse
- ___ Other (Specify____________________)

RESTR-Q6 The next question asks about help received. This may not apply to ... , but we need to ask the same
question of everyone. Because of any condition or health problem, do(es) ... need the help of
another person in:

(Read list. Mark all that apply.)

- ___ Preparing meals?
- ___ Shopping for groceries or other necessities?
- ___ Doing normal everyday housework?
- ___ Doing heavy household chores such as washing walls, yard work, etc.?
- ___ Personal care such as washing, dressing or eating?
- ___ Moving about inside the house?
- ___ None of the above

**Chronic Conditions**

CHRON-CINT If age<12 go to next section.

CHRON-INT Now I'd like to ask about any chronic health conditions ... may have. Again, "long-term
conditions" refer to conditions that have lasted or are expected to last 6 months or more.
RAC4_5

RAC4_6A
RAC4_6B
RAC4_6C
RAC4_6D
RAC4_6E
RAC4_6F
RAC4_6G
RAC4_3C
RAC4_3C

<!-- page 11 printed="11" read_by="text_layer" -->

CHRON-Q1 Do(es) ... have any of the following long-term conditions that have been diagnosed by a health
professional:
(Read list. Mark all that apply.)

- (a) Food allergies?
- (b) Other allergies?
- (c) Asthma?(If YES ask CHRON-Q1cc1)
- (d) Arthritis or rheumatism?
- (e) Back problems excluding arthritis?
- (f) High blood pressure?
- (g) Migraine headaches?
- (h) Chronic bronchitis or emphysema?
- (i) Sinusitis?
- (j) Diabetes?
- (k) Epilepsy?
- (l) Heart disease?
- (m) Cancer? (If yes ask CHRON-Q1mm)
- (n) Stomach or intestinal ulcers?
- (o) Effects of stroke?
- (p) Urinary incontinence?
- (q) Acne requiring prescription medication? (Ask if age<30)

For persons aged < 18 years go to (u).

- (r) Alzheimer's disease or other dementia?
- (s) Cataracts?
- (t) Glaucoma?
- (u) Any other long term condition? (Specify ______________)
- (v) None

DK, R (Go to next section)

CHRON-Q1mm What type(s) of cancer is this? For example, skin, lung or colon cancer.

\__________________________

CHRON-Q1cc1 Have/Has ... had an attack of asthma in the past 12 months?

- ___ Yes
- ___ No

CHRON-Q1cc2 Have/Has ... had wheezing or whistling in the chest at any time in the past 12 months?

- ___ Yes
- ___ No

**Socio-demographic Characteristics**

SOCIO-INT Now I'd like to ask some general background questions about the characteristics of people in your
household.
CCC4_1K
CCC4_1L
CCC4_1M
CCC4_1N
CCC4_1O
CCC4_1P
CCC4_1W
CCC4_1A
CCC4_1B
CCC4_1C
CCC4_1D
CCC4_1E
CCC4_1F
CCC4_1G
CCC4_1H
CCC4_1I
CCC4_1J

CCC4_1R
CCC4_1S
CCC4_1T
CCC4_1V
CCC4_NON

CCC4_M1

CCC4 C7

CCC4_C8

<!-- page 12 printed="12" read_by="text_layer" -->

**Country of Birth/Year of Immigration**

SOCIO-Q1 In what country were/was ... born?
(Do not read list. Mark one only.)

- ___ Canada (Go to next section)
- ___ China ___ Jamaica
- ___ France ___ Netherlands
- ___ Germany ___ Philippines
- ___ Greece ___ Poland
- ___ Guyana ___ Portugal
- ___ Hong Kong ___ United Kingdom
- ___ Hungary ___ United States
- ___ India ___ Viet Nam
- ___ Italy ___ Other (Specify___)

DK, R (Go to SOCIO-Q4)

SOCIO-Q3 In what year did ... first immigrate to Canada?

- ___ Year (4 digits)

(Enter <1999> if Canadian citizen by birth.)

**Ethnicity**

SOCIO-Q4 To which ethnic or cultural group(s) did your/his/her ancestors belong? (For example: French,
British, Chinese, etc.)
(Do not read list. Mark all that apply.)

- ___ Canadian ___ Chinese
- ___ French ___ Jewish
- ___ English ___ Polish
- ___ German ___ Portuguese
- ___ Scottish ___ South Asian
- ___ Irish ___ Black
- ___ Italian ___ North American Indian
- ___ Ukrainian ___ Métis
- ___ Dutch (Netherlands) ___ Inuit/Eskimo
- ___ Other ethnic or cultural group(s)

(Specify___)
Language

SOCIO-Q5 In which languages can ... conduct a conversation?
(Do not read list. Mark all that apply.)

- ___ English ___ Persian (Farsi)
- ___ French ___ Polish
- ___ Arabic ___ Portuguese
- ___ Chinese ___ Punjabi
- ___ Cree ___ Spanish
- ___ German ___ Tagalog (Filipino)
- ___ Greek ___ Ukrainian
- ___ Hungarian ___ Vietnamese
- ___ Italian ___ Other (Specify______)
- ___ Korean

SDC4_4A
SDC4_4B
SDC4_4C
SDC4_4D
SDC4_4E
SDC4_4F
SDC4_4G
SDC4_4H
SDC4_4I
SDC4_4J
SDC4_4K
SDC4_4L
SDC4_4M
SDC4_4N
SDC4_4O
SDC4_4P
SDC4_4Q
SDC4_4R
SDC4_4S
SDC4_1

SDC4_5A
SDC4_5B
SDC4_5C
SDC4_5D
SDC4_5E
SDC4_5F
SDC4_5G
SDC4_5H
SDC4_5I
SDC4_5J
SDC4_3

SDC4_5K
SDC4_5L
SDC4_5M
SDC4_5N
SDC4_5O
SDC4_5P
SDC4_5Q
SDC4_5R
SDC4_5S

<!-- page 13 printed="13" read_by="text_layer" -->

SOCIO-Q6 What is the language that ... first learned at home in childhood and can still understand? (If ... can
no longer understand the first language learned, choose the second language learned.)
(Do not read list. Mark all that apply.)

- ___ English ___ Persian (Farsi)
- ___ French ___ Polish
- ___ Arabic ___ Portuguese
- ___ Chinese ___ Punjabi
- ___ Cree ___ Spanish
- ___ German ___ Tagalog (Filipino)
- ___ Greek ___ Ukrainian
- ___ Hungarian ___ Vietnamese
- ___ Italian ___ Other (Specify______)
- ___ Korean

**Race**

SOCIO-Q7 How would you best describe ...(r/'s) race or colour?
(Do not read list. Mark all that apply.)

- ___ White (e.g. British, French, European, Latin/South American of European background)
- ___ Black
- ___ Korean
- ___ Filipino
- ___ Japanese
- ___ Chinese
- ___ Native/Aboriginal Peoples of North America

(North American Indian, Métis, Inuit/Eskimo)

- ___ South Asian (e.g. Indian from India or Uganda, Pakistani, Punjabi, Tamil)
- ___ South East Asian (e.g. Vietnamese, Thai, Laotian)
- ___ West East Asian or North African (e.g. Armenian, Syrian, Moroccan)
- ___ Other (Specify ____________)

**Education**

EDUC-C1 If age<12, go to next section.

EDUC-Q1 Excluding kindergarten, how many years of elementary and high school have/has ... successfully
completed?
(Do not read list. Mark one only.)

- ___ No schooling (Go to next section)
- ___ One to five years ___ Ten
- ___ Six ___ Eleven
- ___ Seven ___ Twelve
- ___ Eight ___ Thirteen
- ___ Nine DK, R (Go to next section)

(If age < 15 then go to next section)

EDUC-Q2 Have/has ... graduated from high school?

- ___ Yes
- ___ No

SDC4_7A
SDC4_7D
SDC4_7K
SDC4_7G
SDC4_7J
SDC4_7B
SDC4_7E

SDC4_7C
SDC4_7H
SDC4_7F
SDC4_7L

EDC4_4

EDC4_5
SDC4_6A
SDC4_6B
SDC4_6C
SDC4_6D
SDC4_6E
SDC4_6F
SDC4_6G
SDC4_6H
SDC4_6I
SDC4_6J
SDC4_6K
SDC4_6L
SDC4_6M
SDC4_6N
SDC4_6O
SDC4_6P
SDC4_6Q
SDC4_6R
SDC4_6S

<!-- page 14 printed="14" read_by="text_layer" -->

EDUC-Q3 Have/has ... ever attended any other kind of school such as university, community college, business
school, trade or vocational school, CEGEP or other post-secondary institution?

- ___ Yes
- ___ No (Go to EDUC-C5)

DK, R (Go to next section)

EDUC-Q4 What is the highest level of education that ... have/has attained?
(Do not read list. Mark one only.)

- ___ Some trade, technical, vocational school or business college
- ___ Some community college, CEGEP or nursing school
- ___ Some university
- ___ Diploma or certificate from trade, technical or vocational school, or business college
- ___ Diploma or certificate from community college, CEGEP, or nursing school)
- ___ Bachelor's or undergraduate degree or teacher's college (e.g., B.A., B.Sc., LL.B.)
- ___ Master's (e.g. M.A., M. Sc., M.Ed.)
- ___ Degree in medicine, dentistry, veterinary medicine or optometry (M.D., D.D.S., D.M.D.,

D.V.M., O.D.)

- ___ Earned doctorate (e.g. Ph.D., D.Sc., D.Ed.)
- ___ Other (Specify_____)

EDUC-C5 If age >= 65, go to next section.

EDUC-Q5 Are/Is ... currently attending a school, college or university?

- ___ Yes
- ___ No (Go to next section)

DK, R (Go to next section)

EDUC-Q6 Are/Is ... enrolled as a full-time or part-time student?

- ___ full-time
- ___ part-time

**Labour Force**

LFS-C1 If age<15 go to next section.

LFS-Q1 What do/does ... consider to be your/his/her current main activity? (For example, working for pay,
caring for family.)
(Do not read list. Mark one only.)

- ___ Caring for family
- ___ Working for pay or profit
- ___ Caring for family and working for pay or profit
- ___ Going to school
- ___ Recovering from illness/on disability
- ___ Looking for work
- ___ Retired
- ___ Other (Specify)

LFS-I2 The next section contains questions about jobs or employment which ... have/has had during the
past 12 months2. Please include such employment as part-time jobs, contract work, baby sitting
and any other paid work.
EDC4_7

EDC4_1

EDC4_2
EDC4_6

LFC4_1

<!-- page 15 printed="15" read_by="text_layer" -->

LFS-C2 If LFS-Q1 = 2 or 3 ---> go to LFS-Q3.1
LFS-Q2 Have/has you/he/she worked for pay or profit at any time in the past 12 months?

- ___ Yes (Go to LFS-Q3.1)
- ___ No

DK, R (Go to next section)
LFS-C2A If LFS-Q1=7 (retired) ---> go to LFS-C18 else go to LFS-Q17B
Note: Questions LFS-Q3 to LFS-Q11 are done as a roster allowing up to 6 jobs to be entered.
LFS-Q3.n For whom/whom else have/has you/he/she worked for pay or profit in the past 12 months?
_____________________ (50 chars)
LFS-Q4.n Did you/he/she have that job 1 year ago, that is, on %12MOSAGO% without a break in
employment since then?

- ___ Yes (Go to LFS-Q6.n)
- ___ No

DK, R (Go to next section)
LFS-Q5.n When did you/he/she start working at this job or business?
MM/DD/YY
DK, R (Go to next section)
LFS-Q6.n Do/Does you/he/she now have that job?

- ___ Yes (Go to LFS-Q8.n)
- ___ No

DK, R (Go to next section)
LFS-Q7.n When did you/he/she stop working at this job or business?
MM/DD/YY
DK, R (Go to next section)
LFS-Q8.n About how many hours per week do/does/did you/he/she usually work at this job?
|_|_| HOURS
LFC4_EnC

LFC4_4n

LFC4_5nM
LFC4_5nD
LFC4 5nY
LFC4_2

LFC4_6n

LFC4_7nM
LFC4_7nD
LFC4_7nY
LFC4_8n

<!-- page 16 printed="16" read_by="text_layer" -->

LFS-Q9.n Which of the following best describes the hours you/he/she usually work/works/worked at this job?
(Read list. Mark one only.)

- ___ Regular daytime schedule or shift
- ___ Regular evening shift
- ___ Regular night
- ___ Rotating shift (change from days to evenings to nights)
- ___ Split shift
- ___ On call
- ___ Irregular schedule
- ___ Other (Specify_______)

LFS-Q10.n Do/Does/Did you/he/she usually work on weekends at this job?

- ___ Yes
- ___ No

LFS-Q11.n Did you/he/she do any other work for pay or profit in the past 12 months?

- ___ Yes
- ___ No

DK, R (Go to LFS-Q12)

LFS-C12 If LFS-Q11.1 = No go to LFS-Q13.

LFS-Q12 Which was the main job?
(Answer will be chosen from roster of jobs.)
(Definition of main job will be supplied in the interviewers manual.)

LFS-Q13 Thinking about this/the main job, what kind of business, service or industry is this? (For example,
wheat farm, trapping, road maintenance, retail shoe store, secondary school.)

_____________________ (50 chars)

LFS-Q14 Again, thinking about this/the main job, what kind of work was/were ... doing? (For example,
medical lab technician, accounting clerk, secondary school teacher, supervisor of data entry unit,
food processing labourer.)

_____________________ (50 chars)

LFS-Q15 In this work, what were your/his/her most important duties or activities? (For example, analysis of
blood samples, verifying invoices, teaching mathematics, organizing work schedules, cleaning
vegetables.)

_____________________ (50 chars)

LFS-Q16 Did you/he/she work mainly for others for wages or commission or in your/his/her own business,
farm or practice?
(Do not read list. Mark one only.)

- ___ For others for wages, salary or commission
- ___ In own business, farm or professional practice
- ___ Unpaid family worker

LFC4_11n

LFC4_13C

LFC4_14C

LFC4_15C

LFC4_16
LFC4_9n

LFC4_10n

LFC4FMN

<!-- page 17 printed="17" read_by="text_layer" -->

LFS-C17 Check the calendar for gaps > 6 days.
If # gaps = 0 ---> go to LFS-C18

LFS-C17A If any LFS-Q6 = 1 (currently employed) ---> go to LFS-Q17A
Otherwise ---> go to LFS-Q17B

LFS-Q17A What was the reason that ... were/was not working for pay or profit during the most recent period
away from work in the past year?
(Do not read list. Mark one only.)

- ___ Own illness or disability
- ___ Pregnancy
- ___ Caring for own children
- ___ Caring for elder relative(s)
- ___ Other personal or family responsibilities
- ___ School or educational leave
- ___ Labour dispute
- ___ Temporary layoff due to seasonal conditions
- ___ Temporary layoff - non-seasonal
- ___ Permanent layoff
- ___ Unpaid or partially paid vacation
- ___ Other (Specify________)
- ___ No period not working for pay or profit in the past year

GO TO LFS-C18

LFS-Q17B What is the reason that ... are/is currently not working for pay or profit?
(Do not read list. Mark one only.)

- ___ Own illness or disability
- ___ Pregnancy
- ___ Caring for own children
- ___ Caring for elder relative(s)
- ___ Other personal or family responsibilities
- ___ School or educational leave
- ___ Labour dispute
- ___ Temporary layoff due to seasonal conditions
- ___ Temporary layoff - non-seasonal
- ___ Permanent layoff
- ___ Unpaid or partially paid vacation
- ___ Other (Specify_______)
- ___ No period not working for pay or profit in the past year

LFS-C18 If LFS-Q1 = 2 or 3 or any one of LFS-Q6.1 to LFS-Q6.6 = 1 (currently working) then %LFS-
WORK% =1;
Otherwise %LFS-WORK% =0;
LFC4_17B
LFC4_17A

<!-- page 18 printed="18" read_by="text_layer" -->

**Income**
(Ask from knowledgeable person only)

INCOM-Q1 Thinking about your total household income, from which of the following sources did your
household receive any income in the past 12 months?
(Read list. Mark all that apply.)

- ___ Wages and salaries
- ___ Income from self-employment
- ___ Dividends and interest on bonds, deposits and savings, stocks, mutual funds, etc.
- ___ Unemployment insurance
- ___ Worker's compensation
- ___ Benefits from Canada or Quebec Pension Plan
- ___ Retirement pensions, superannuation and annuities
- ___ Old Age Security and Guaranteed Income Supplement
- ___ Child Tax Benefit
- ___ Provincial or municipal social assistance or welfare
- ___ Child Support
- ___ Alimony
- ___ Other Income (eg. rental income, scholarships, other government income, etc.)
- ___ None (Go to next section)

DK, R (Go to next section)

If more than one source of income is indicated ask INCOM-Q2.
Otherwise ask INCOM-Q3.

INCOM-Q2 What was the main source of income?
(Do not read list. Mark one only.)

- ___ Wages and salaries
- ___ Income from self-employment
- ___ Dividends and interest on bonds, deposits and savings, stocks, mutual funds, etc.
- ___ Unemployment insurance
- ___ Worker's compensation
- ___ Benefits from Canada or Quebec Pension Plan
- ___ Retirement pensions, superannuation and annuities
- ___ Old Age Security and Guaranteed Income Supplement
- ___ Child Tax Benefit
- ___ Provincial or Municipal Social Assistance or Welfare
- ___ Child Support
- ___ Alimony
- ___ Other Income (eg. rental income, scholarships, other government income, etc.)

INC4_2
INC4_1A
INC4_1B
INC4_1C
INC4_1D
INC4_1E
INC4_1F
INC4_1G
INC4_1H
INC4_1I
INC4_1J
INC4_1K
INC4_1L
INC4_1M
INC4_1N

<!-- page 19 printed="19" read_by="text_layer" -->

INCOM-Q3 What is your best estimate of the total income before taxes and deductions of all household
members from all sources in the past 12 months? Was the total household income:

- ___ Less than $20,000?
- ___ Less than $10,000?
- ___ Less than $5,000? (go to next section)
- ___ $5,000 and more? (go to next section)
- ___ $10,000 and more?
- ___ Less than $15,000? (go to next section)
- ___ $15,000 and more? (go to next section)
- ___ $20,000 and more?
- ___ Less than $40,000?
- ___ Less than $30,000? (go to next section)
- ___ $30,000 and more? (go to next section)
- ___ $40,000 and more?
- ___ Less than $50,000 (go to next section)
- ___ $50,000 to less than $60,000? (go to next section)
- ___ $60,000 to less than $80,000? (go to next section)
- ___ $80,000 and more? (go to next section)
- ___ No income

DK, R (Go to next section)

**Administration**

H05-P1 Was this interview conducted on the telephone or in person?

- ___ On telephone
- ___ In person
- ___ Both (Specify in comments)

H05-P2 Record language of interview

English Persian (Farsi)
French Polish
Arabic Portuguese
Chinese Punjabi
Cree Spanish
German Tagalog (Filipino)
Greek Ukrainian
Hungarian Vietnamese
Italian Other (Specify_______________)
Korean
AM54_TEL
INC4_3A
INC4_3B
INC4_3C
INC4_3C
INC4_3B
INC4_3D
INC4_3D
INC4_3A
INC4_3E
INC4_3F
INC4_3F
INC4_3E
INC4_3G
INC4_3G
INC4_3G
INC4_3G
INC4_3A

AM54_LNG

<!-- page 20 printed="20" read_by="text_layer" -->

**Health Component for Respondents Aged 12 Years and Older (Form H06)**
(To be completed for selected respondent only and age>=12)
(Proxy for those unable to answer due to special circumstances)

H06-P1 Who is providing the information for this person's form?
\_______________________________

H06-INT This part of the survey deals with various aspects of ... (r/'s) health. I'll be asking about such things
as physical activity, social relationships, health status and stress. By health, we mean not only the
absence of disease or injury but also physical, mental and social well-being. I'll start with a few
questions concerning ... (r/'s) health in general.

**General Health**

GENHLT-Q1 In general, would you say ... r/'s health is:
(Read list. Mark one only.)

- ___ Excellent?
- ___ Very good?
- ___ Good?
- ___ Fair?
- ___ Poor?

GENHLT-C2 Check item: If sex = female & (age >= 15 & age <= 49) ask GENHLT-Q2. Otherwise go to next
section.

GENHLT-Q2 It is important to know when analyzing health whether or not the person is pregnant. Are/Is ...
pregnant?

- ___ Yes
- ___ No (Go to next section)

DK, R (Go to next section)

GENHLT-Q3 Are/Is you/she planning to use the services of a physician, midwife or both?
(Do not read list. Mark one only.)

- ___ Physician only
- ___ Midwife only
- ___ Both physician and midwife
- ___ Neither

**Height/Weight**

HTWT-Q1 How tall are/is ... without shoes on?

- ___ feet ___ inches OR ___ centimetres

HTWT-Q2 How much do/does you/he/she weigh?

- ___ pounds OR ___ kilograms

HWC4_2HT

HWC4_3LB
HWC4_3KG
GHC4_1
AM64_SRC

HWC4_1

GHC4_3

<!-- page 21 printed="21" read_by="text_layer" -->

**Preventive Health Practices**
(Non-proxy only)

PHP-Q1 When did you last have your blood pressure checked by a health professional?
(Do not read list. Mark one only.)

- ___ Less than 6 months ago
- ___ 6 months to less than a year ago
- ___ 1 year to less than 2 years ago
- ___ 2 years to less than 5 years ago
- ___ 5 years or more ago
- ___ Never

R (Go to next section)

PHP-C2 If sex = female and age >= 35 then ask PHP-Q2.
If sex = female and age >= 18 and age < 35 then ask PHP-Q3.
If sex=male or females <= 17 then go to next section.

PHP-Q2 Have you ever had a mammogram, that is, a breast X-ray?

- ___ Yes
- ___ No (Go to PHP-Q3)

DK (Go to PHP-Q3)
R (Go to next section)

PHP-Q2a When was the last time?
(Do not read list. Mark one only.)

- ___ Less than 6 months ago
- ___ 6 months to less than one year ago
- ___ 1 year to less than 2 years ago
- ___ 2 years or more ago

PHP-Q2b Why did you have your last mammogram?
(Read list. Mark one only.)

- ___ Breast problem
- ___ Check-up, no particular problem
- ___ Other (specify_____________)

PHP-Q3 Have you ever had a PAP smear test?

- ___ Yes
- ___ No (Go to next section)

DK, R (Go to next section)
WHC4_20
WHC4_30

WHC4_32
BPC4_1

WHC4_33

<!-- page 22 printed="22" read_by="text_layer" -->

PHP-Q3a When was the last time?
(Do not read list. Mark one only.)

- ___ Less than 6 months ago
- ___ 6 months to less than one year ago
- ___ 1 year to less than 3 years ago
- ___ 3 years to less than 5 years ago
- ___ 5 years or more ago

**Smoking**
SMOK-INT The next few questions are about smoking.
SMOK-Q1 Does anyone in this household smoke regularly inside the house?

- ___ Yes
- ___ No

SMOK-Q2 At the present time do/does ... smoke cigarettes daily, occasionally or not at all?

- ___ Daily
- ___ Occasionally (Go to SMOK-Q5)
- ___ Not at all (Go to SMOK-Q4a)

DK, R (Go to next section)
SMOK-Q3 At what age did you/he/she begin to smoke cigarettes daily?

- ___ Age

SMOK-Q4 How many cigarettes do/does you/he/she smoke each day now?

- ___ Number of cigarettes

(Go to next section)
SMOK-Q4a Have/has you/he/she ever smoked cigarettes at all?

- ___ Yes
- ___ No (Go to next section)

DK, R (Go to next section)
SMOK-Q5 Have/has you/he/she ever smoked cigarettes daily?

- ___ Yes

\___
No (Go to next section)
DK, R (Go to next section)
SMOK-Q6 At what age did you/he/she begin to smoke (cigarettes) daily?

- ___ Age

SMC4_1
WHC4_22

SMC4_2

SMC4_3

SMC4_4

SMC4_4A

SMC4_5

SMC4_6

<!-- page 23 printed="23" read_by="text_layer" -->

SMOK-Q7 How many cigarettes did you/he/she usually smoke each day?

- ___ Number of cigarettes

SMOK-Q8 At what age did you/he/she stop smoking (cigarettes) daily?

- ___ Age

**Alcohol**
ALCO-INT Now, some questions about ... (r/'s) alcohol consumption. When we use the word drink it means:
- one bottle or can of beer or a glass of draft
- one glass of wine or a wine cooler
- one straight or mixed drink with one and a half ounces of hard liquor.
ALCO-Q1 During the past 12 months2, have/has ... had a drink of beer, wine, liquor or any other alcoholic
beverage?

- ___ Yes
- ___ No (Go to ALCO-Q5B)

DK, R (Go to next section)
ALCO-Q2 During the past 12 months, how often did you/he/she drink alcoholic beverages?
(Do not read list. Mark one only.)

- ___ Every day
- ___ 4-6 times a week
- ___ 2-3 times a week
- ___ Once a week
- ___ 2-3 times a month
- ___ Once a month
- ___ Less than once a month

ALCO-Q3 How many times in the past 12 months have/has you/he/she had 5 or more drinks on one occasion?

- ___ Number of times

If PROXY=yes then go to ALCO-Q5
ALCO-Q4 In the past 12 months, what is the highest number of drinks you had on one occasion?

- ___ Number of drinks

ALCO-Q5 Thinking back over the past week, that is, from %1WKAGO% to yesterday, did ... have a drink of
beer, wine, liquor or any other alcoholic beverage?

- ___ Yes
- ___ No (Go to next section)

DK, R (Go to next section)
SMC4_8

ALC4_1

ALC4_2

ALC4_3

ALC4_5
SMC4_7

ALC4_4

<!-- page 24 printed="24" read_by="text_layer" -->

ALCO-Q5A Starting with yesterday, how many drinks did ... have on:

- ___ Monday? R on first day (Go to next section)
- ___ Tuesday?
- ___ Wednesday?
- ___ Thursday?
- ___ Friday?
- ___ Saturday?
- ___ Sunday?

(Go to next section)

ALCO-Q5B Did you/he/she ever have a drink?

- ___ Yes
- ___ No (Go to next section)

DK, R (Go to next section)

ALCO-Q6 Did you/he/she ever regularly drink more than 12 drinks a week?

- ___ Yes
- ___ No (Go to next section)

DK, R (Go to next section)

ALCO-Q7 Why did you/he/she reduce or quit drinking altogether?
(Do not read list. Mark all that apply.)

- ___ Dieting
- ___ Athletic training
- ___ Pregnancy
- ___ Getting older
- ___ Drinking too much/drinking problem
- ___ Affected work, studies, employment opportunities
- ___ Interfered with family or home life
- ___ Affected physical health
- ___ Affected friendships or social relationships
- ___ Affected financial position
- ___ Affected outlook on life, happiness
- ___ Because of influence of family or friends
- ___ Other (specify______________)

**Physical Activities**
(Non-proxy only)

PHYS-INTa Now I'd like to ask you about some of your physical activities. To begin with, I'll be dealing with
physical activities not related to work, that is, leisure time activities.
ALC4_5B

ALC4_6

ALC4_7A
ALC4_7B
ALC4_7C
ALC4_7D
ALC4_7E
ALC4_7F
ALC4_7G
ALC4_7H
ALC4_71
ALC4_7J
ALC4_7K
ALC4_7L
ALC4_7M
ALC4_5A1
ALC4_5A2
ALC4_5A3
ALC4_5A4
ALC4_5A5
ALC4_5A6
ALC4_5A7

<!-- page 25 printed="25" read_by="text_layer" -->

PHYS-Q1 Have you done any of the following in the past 3 months3?
(Read list. Mark all that apply.)

- ___ Walking for exercise ___ Cross-country skiing
- ___ Gardening, yard work ___ Bowling
- ___ Swimming ___ Baseball/softball
- ___ Bicycling ___ Tennis
- ___ Popular or social dance ___ Weight-training
- ___ Home exercises ___ Fishing
- ___ Ice hockey ___ Volleyball
- ___ Skating ___ Yoga or tai-chi
- ___ Downhill skiing ___ Other (specify)
- ___ Jogging/running ___ Other (specify)
- ___ Golfing ___ Other (specify)
- ___ Exercise class/aerobics _ __ None

DK, R (Go to next section)

For each response ask PHYS-Q2 to PHYS-Q3.
If "none" go to PHYS-INTb.

PHYS-Q2 In the past 3 months, how many times did you participate in %ACTIVITY%?

- ___ Number of times

DK, R (Go to next activity)

PHYS-Q3 About how much time did you usually spend on each occasion?
(Do not read list. Mark one only.)

- ___ 1 to 15 minutes
- ___ 16 to 30 minutes
- ___ 31 to 60 minutes
- ___ More than one hour

PHYS-INTb Next, some questions about the amount of time you spent in the past 3 months on physical activity
at work or while doing daily chores around the house, but not leisure time activity.

PHYS-Q4a In a typical week in the past 3 months, how many hours did you usually spend walking to work or
to school or while doing errands?
(Do not read list. Mark one only.)

- ___ None
- ___ Less than 1 hour
- ___ From 1 to 5 hours
- ___ From 6 to 10 hours
- ___ From 11 to 20 hours
- ___ More than 20 hours

PAC4_2n

PAC4_3n

PAC4_4A
PAC4_1A
PAC4_1B
PAC4_1C
PAC4_1D
PAC4_1E
PAC4_1F
PAC4_1G
PAC4_1H
PAC4_1I
PAC4_1J
PAC4_1K
PAC4_1L
PAC4_1M
PAC4_1N
PAC4_1O
PAC4_1P
PAC4_1Q
PAC4_1R
PAC4_1S
PAC4_1Z
PAC4_1U
PAC4_1W
PAC4_1X
PAC4_1V

<!-- page 26 printed="26" read_by="text_layer" -->

PHYS-Q4b In a typical week, how much time did you usually spend bicycling to work or to school or while
doing errands?
(Do not read list. Mark one only.)

- ___ None
- ___ Less than 1 hour
- ___ From 1 to 5 hours
- ___ From 6 to 10 hours
- ___ From 11 to 20 hours
- ___ More than 20 hours

PHYS-C1 If Bicycling was indicated as an activity in PHYS-Q1 or not a "none" in PHYS-Q4b, ask PHYS-
Q5. Otherwise go to PHYS-Q6.

PHYS-Q5 When riding a bicycle how often did you wear a helmet?
(Read list. Mark one only.)

- ___ Always
- ___ Most of the time
- ___ Rarely
- ___ Never

PHYS-Q6 Thinking back over the past 3 months, which of the following best describes your usual daily
activities or work habits?
(Read list. Mark one only.)

- ___ Usually sit during day and do not walk about very much
- ___ Stand or walk about quite a lot during the day but do not have to carry or lift things very

often

- ___ Usually lift or carry light loads, or have to climb stairs or hills often
- ___ Do heavy work or carry very heavy loads

**Injuries**

INJ-INT Now some questions about any injuries, which occurred in the past 12 months2, that were serious
enough to limit ... (r/'s) normal activities. For example, a broken bone, a bad cut or burn, a sore
back or sprained ankle, or a poisoning.

INJ-Q1 In the past 12 months, did ... have any injuries that were serious enough to limit your/his/her
normal activities?

- ___ Yes
- ___ No (Go to next section)

DK, R (Go to next section)

INJ-Q2 How many times were/was you/he/she injured?

- ___ times

DK, R (Go to next section)
IJC4_1

IJC4_2
PAC4_4B

PAC4_5

PAC4_6

<!-- page 27 printed="27" read_by="text_layer" -->

INJ-Q3 Thinking about the most serious injury, what type of injury did you/he/she have? For example, a
broken bone or burn.
(Do not read list. Mark one only.)

- ___ Multiple injuries
- ___ Broken or fractured bones
- ___ Burn or scald
- ___ Dislocation
- ___ Sprain or strain
- ___ Cut or scrape
- ___ Bruise or abrasion
- ___ Concussion
- ___ Poisoning by substance or liquid
- ___ Internal injury
- ___ Other (specify________________)

INJ-Q4 What part of your/his/her body was injured?
(Do not read list. Mark one only.)

- ___ Multiple sites
- ___ Eyes
- ___ Head (excluding eyes)
- ___ Neck
- ___ Shoulder
- ___ Arms or hands
- ___ Hip
- ___ Legs or feet
- ___ Back or spine
- ___ Trunk (excluding back or spine) (including chest, internal organs, etc.)

INJ-Q5 Where did the injury happen?
(Do not read list. Mark one only.)

- ___ Home and surrounding area
- ___ Farm
- ___ Place for recreation or sport

(e.g. golf course, basketball court, playground (including school))

- ___ Street or highway
- ___ Building used by general public (e.g. hotel, shopping plaza, restaurant, office building,

school)

- ___ Residential institution (e.g. hospital, jail, etc.)
- ___ Mine
- ___ Industrial place or premise (e.g. dockyard)
- ___ Other (specify _______________)

IJC4_5
IJC4_3

IJC4_4

<!-- page 28 printed="28" read_by="text_layer" -->

INJ-Q6 What happened? For example, was the injury the result of a fall, motor vehicle accident, a physical
assault etc.?
(Do not read list. Mark one only.)

- ___ Motor vehicle accident
- ___ Accidental fall
- ___ Fire, flames or resulting fumes
- ___ Accidentally struck by an object/person
- ___ Physical assault
- ___ Suicide attempt
- ___ Accidental injury caused by explosion
- ___ Accidental injury caused by natural/environmental factors (e.g. weather conditions,

Poison ivy, animal bites, stings)

- ___ Accidental drowning or submersion
- ___ Accidental suffocation
- ___ Hot or corrosive liquids, foods or substances
- ___ Accident caused by machinery (e.g. farm machinery, forklift, woodworking machinery)
- ___ Accident caused by cutting and piercing instruments or objects (lawnmower, knife,

stapler)

- ___ Accidental poisoning
- ___ Other (specify__________________)

INJ-Q7 Was this a work-related injury?

- ___ Yes
- ___ No

INJ-Q8 We would like to know what precautions ... are/is taking, if any, to prevent this kind of injury from
happening again. What precautions are/is you/he/she taking?

(Do not read list. Mark all that apply.)

- ___ Gave up the activity
- ___ Being more careful
- ___ Took safety training
- ___ Increased supervision of child
- ___ Using protective gear/safety equipment (e.g. bike helmet, car safety restraint, etc.)
- ___ Changing physical situation (e.g. removing rugs, storing medications out of reach, safety

gates, etc.)

- ___ Other (specify)
- ___ No precautions

**Stress**
(Age >= 18 and non-proxy only)

**Ongoing Problems**

STRESS-INT The next portion of the questionnaire deals with different kinds of stress. Although the questions
may seem repetitive, they are related to various aspects of a person's physical, emotional and
mental health.
IJC4_8A
IJC4_8B
IJC4_8C
IJC4_8H
IJC4_8D
IJC4_8E

IJC4_8F
IJC4_8G
IJC4_6

IJC4_7

<!-- page 29 printed="29" read_by="text_layer" -->

CSTRESS-INT I'll start by describing situations that sometimes come up in people's lives. As there are no right or
wrong answers, the idea is to choose the answer best suited to your personal situation. I'd like you
to tell me if these things are true for you at this time by answering "true" if it applies to you now or
"false" if it does not.
CSTRESS-Q1 You are trying to take on too many things at once.

- ___ True
- ___ False

R (Go to next section)
CSTRESS-Q2 There is too much pressure on you to be like other people.

- ___ True
- ___ False

CSTRESS-Q3 Too much is expected of you by others.

- ___ True
- ___ False

CSTRESS-Q4 You don't have enough money to buy the things you need.

- ___ True
- ___ False

If marital status =married or living with a partner or common-law go to CSTRESS-Q5.
If marital status=single,widowed, separated or divorced go to CSTRESS-Q8.
Otherwise (i.e. marital status is unknown) go to CSTRESS-Q9.
CSTRESS-Q5 Your partner doesn't understand you.

- ___ True
- ___ False

CSTRESS-Q6 Your partner doesn't show enough affection.

- ___ True
- ___ False

CSTRESS-Q7 Your partner is not committed enough to your relationship.

- ___ True
- ___ False

Go to CSTRESS-Q9
CSTRESS-Q8 You find it is very difficult to find someone compatible with you.

- ___ True
- ___ False

ST_4_C1

ST_4_C2

ST_4_C3

ST_4_C4

ST_4_C5

ST_4_C6

ST_4_C7

ST_4_C8

<!-- page 30 printed="30" read_by="text_layer" -->

CSTRESS-Q9 Do you have any children?

- ___ Yes
- ___ No (Go to CSTRESS-Q12)

DK, R (Go to CSTRESS-Q12)
CSTRESS-Q10 Remember I want to know if you feel any of these statements are true for you at this time.
One of your children seems very unhappy.

- ___ True
- ___ False

CSTRESS-Q11 A child's behaviour is a source of serious concern to you.

- ___ True
- ___ False

CSTRESS-Q12 Your work around the home is not appreciated.

- ___ True
- ___ False

CSTRESS-Q13 Your friends are a bad influence.

- ___ True
- ___ False

CSTRESS-Q14 You would like to move but you cannot.

- ___ True
- ___ False

CSTRESS-Q15 Your neighbourhood or community is too noisy or too polluted.

- ___ True
- ___ False

CSTRESS-Q16 You have a parent, a child or partner who is in very bad health and may die.

- ___ True
- ___ False

CSTRESS-Q17 Someone in your family has an alcohol or drug problem.

- ___ True
- ___ False

CSTRESS-Q18 People are too critical of you or what you do.

- ___ True
- ___ False

ST_4_C9

ST_4_C10

ST_4_C11

ST_4_C12

ST_4_C13

ST_4_C14

ST_4_C15

ST_4_C16

ST_4_C17

ST_4_C18

<!-- page 31 printed="31" read_by="text_layer" -->

**Recent Life Events**
RECENT-INTa Now I'd like to ask you about some things that may have happened in the past 12 months2. Some of
these experiences happen to most people at one time or another, while some happen to only a few.
First, I'd like to ask about yourself or anyone close to you (that is, your spouse or partner, children,
relatives or close friends).
RECENT-Q1 In the past 12 months, was any one of you beaten up or physically attacked?

- ___ Yes
- ___ No

R (Go to next section)
RECENT-INTb Now I'd like you to think just about your family, (that is, yourself and your spouse/partner or
children, if any).
RECENT-Q2 In the past 12 months, did you or someone in your family, have an unwanted pregnancy?

- ___ Yes
- ___ No

RECENT-Q3 In the past 12 months, did you or someone in your family have an abortion or miscarriage?

- ___ Yes
- ___ No

RECENT-Q4 In the past 12 months, did you or someone in your family have a major financial crisis?

- ___ Yes
- ___ No

RECENT-Q5 In the past 12 months, did you or someone in your family fail school or a training program?

- ___ Yes
- ___ No

RECENT-INTc Now I'd like you to think just about yourself and your spouse or partner.
If marital status = married/living together/common-law include the phrase "or your partner" in the RECENT-Q6 and
RECENT-Q7.
RECENT-Q6 In the past 12 months, did you (or your partner) experience a change of job for a worse one?

- ___ Yes
- ___ No

RECENT-Q7 In the past 12 months, were you (or your partner) demoted at work or did you/either of you take a
cut in pay?

- ___ Yes
- ___ No

ST_4_R1

ST_4_R2

ST_4_R3

ST_4_R4

ST_4_R5

ST_4_R6

ST_4_R7

<!-- page 32 printed="32" read_by="text_layer" -->

If marital status = married/living together/common-law ask RECENT-Q8.
Otherwise go to RECENT-Q9.
RECENT-Q8 In the past 12 months, did you have increased arguments with your partner?

- ___ Yes
- ___ No

RECENT-Q9 Now, just you personally, in the past 12 months, did you go on Welfare?

- ___ Yes
- ___ No

IF CSTRESS-Q9 = yes (have children) ask RECENT-Q10.
Otherwise go to next section.
RECENT-Q10 In the past 12 months, did you have a child move back into the house?

- ___ Yes
- ___ No

**Childhood and Adult Stressors ("traumas")**
TRAUM-INTa The next few questions ask about some things that may have happened to you while you were a
child or a teenager, before you moved out of the house. Please tell me if any of these things have
happened.
TRAUM-Q1 Did you spend 2 weeks or more in the hospital?

- ___ Yes
- ___ No

R (Go to next section)
TRAUM-Q2 Did your parents get a divorce?

- ___ Yes
- ___ No

TRAUM-Q3 Did your father or mother not have a job for a long time when they wanted to be working?

- ___ Yes
- ___ No

TRAUM-Q4 Did something happen that scared you so much you thought about it for years after?

- ___ Yes
- ___ No

TRAUM-Q5 Were you sent away from home because you did something wrong?

- ___ Yes
- ___ No

ST_4_R8

ST_4_R9

ST_4_R10

ST_4_T1

ST_4_T2

ST_4_T3

ST_4_T4

ST_4_T5

<!-- page 33 printed="33" read_by="text_layer" -->

TRAUM-Q6 Did either of your parents drink or use drugs so often that it caused problems for the family?

- ___ Yes
- ___ No

TRAUM-Q7 Were you ever physically abused by someone close to you?

- ___ Yes
- ___ No

**Work Stress**
(Age >= 15 and non-proxy only)

Check item: ask only of those currently employed. If more than one job is held ask for the main job.

WSTRESS-Q1 Now I'm going to read you a series of statements that might describe your job situation. Please tell
me if you STRONGLY AGREE, AGREE, NEITHER AGREE NOR DISAGREE, DISAGREE, or
STRONGLY DISAGREE with each of the following:

a) Your job requires that you learn new things R on first item (Go to next section)
b) Your job requires a high level of skill
c) Your job allows you freedom to decide how you do your job
d) Your job requires that you do things over and over
e) Your job is very hectic
f) You are free from conflicting demands that others make
g) Your job security is good
h) Your job requires a lot of physical effort
i) You have a lot to say about what happens in your job
j) You are exposed to hostility or conflict from the people you work with
k) Your supervisor is helpful in getting the job done
l) The people you work with are helpful in getting the job done

WSTRESS-Q2 How satisfied are you with your job?
(Read list. Mark one only.)

- ___ Very satisfied
- ___ Somewhat satisfied
- ___ Not too satisfied
- ___ Not at all satisfied

**Self-Esteem and Mastery**
(Age >= 12 and non-proxy only)

ESTMAST-INT Now, I am going to read you a series of statements that people might use to describe themselves.
Please tell me if you STRONGLY AGREE, AGREE, NEITHER AGREE NOR DISAGREE,
DISAGREE or STRONGLY DISAGREE with each of the following:
ST_4_T6

ST_4_T7

ST_4_W1A
ST_4_W1B
ST_4_W1C
ST_4_W1D
ST_4_W1E
ST_4_W1F
ST_4_W1G
ST_4_W1H
ST_4_W1I
ST_4_W1J
ST_4_W1K
ST_4_W1L

ST_4_W2

<!-- page 34 printed="34" read_by="text_layer" -->

ESTEEM-Q1

a) You feel that you have a number of good qualities. R on first item (Go to next section)
b) You feel that you're a person of worth at least equal to others.
c) You are able to do things as well as most other people.
d) You take a positive attitude toward yourself.
e) On the whole you are satisfied with yourself.
f) All in all, you're inclined to feel you're a failure.

(Age > 12 and non-proxy only)

MAST-Q1

a) You have little control over the things that happen to you R on first item(Go to next section)
b) There is really no way you can solve some of the problems you have.
c) There is little you can do to change many of the important things in your life.
d) You often feel helpless in dealing with problems of life.
e) Sometimes you feel that you are being pushed around in life.
f) What happens to you in the future mostly depends on you.
g) You can do just about anything you really set your mind to.

**Sense of Coherence**
(Age>=18 and non-proxy only.)

SCOH-INT Next is a series of questions relating to various aspects of people's lives. For each question please
answer with a number between 1 and 7. Take your time to think about each question before
answering.

SCOH-Q1 In this first question 1 means very seldom or never and 7 means very often. How often do you have
the feeling that you don't really care about what goes on around you?

1 Very seldom or never
2 (cid:1)
3 |
4 |
5 |
6 (cid:2)
7 Very often
DK, R (Go to next section)

SCOH-Q2 In this question 1 that means it has never happened and 7 means it has always happened. How
often in the past were you surprised by the behaviour of people whom you thought you knew well?

1 Never happened
2 (cid:1)
3 |
4 |
5 |
6 (cid:2)
7 Always happened
PY_4_E1A
PY_4_E1B
PY_4_E1C
PY_4_E1D
PY_4_E1E
PY_4_E1F

PY_4_M1A
PY_4_M1B
PY_4_M1C
PY_4_M1D
PY_4_M1E
PY_4_M1F
PY_4_M1G

PY_4_H1

PY_4_H2

<!-- page 35 printed="35" read_by="text_layer" -->

SCOH-Q3 In this question 1 means that it has never happened and 7 means it has always happened. How
often have people you counted on disappointed you?

1 Never happened
2 (cid:1)
3 |
4 |
5 |
6 (cid:2)
7 Always happened

SCOH-Q4 In this question 1 means very often and 7 means very seldom or never. How often do you have the
feeling you're being treated unfairly?

1 Very often
2 (cid:1)
3 |
4 |
5 |
6 (cid:2)
7 Very seldom or never

SCOH-Q5 In this question 1 means very often and 7 means very seldom or never. How often do you have the
feeling you are in an unfamiliar situation and don't know what to do?

1 Very often
2 (cid:1)
3 |
4 |
5 |
6 (cid:2)
7 Very seldom or never

SCOH-Q6 In this question 1 means very often and 7 means very seldom or never. How often do you have
very mixed-up feelings and ideas?

1 Very often
2 (cid:1)
3 |
4 |
5 |
6 (cid:2)
7 Very seldom or never
PY_4_H4

PY_4_H5

PY_4_H6
PY_4_H3

<!-- page 36 printed="36" read_by="text_layer" -->

SCOH-Q7 In this question 1 means very often and 7 means very seldom or never. how often do you have
feelings inside that you would rather not feel?

1 Very often
2 (cid:1)
3 |
4 |
5 |
6 (cid:2)
7 Very seldom or never

SCOH-Q8 In this question 1 means very seldom or never and 7 means very often. Many people -- even those
with a strong character -- sometimes feel like sad sacks (losers) in certain situations. How often
have you felt this way in the past?

1 Very seldom or never
2 (cid:1)
3 |
4 |
5 |
6 (cid:2)
7 Very often

SCOH-Q9 In this question 1 means very often and 7 means very seldom or never. How often do you have the
feeling that there's little meaning in the things you do in your daily life?

1 Very often
2 (cid:1)
3 |
4 |
5 |
6 (cid:2)
7 Very seldom or never

SCOH-Q10 In this question 1 means very often and 7 means very seldom or never. How often do you have
feelings that you're not sure you can keep under control?

1 Very often
2 (cid:1)
3 |
4 |
5 |
6 (cid:2)
7 Very seldom or never
PY_4_H8

PY_4_H9

PY_4_H10
PY_4_H7

<!-- page 37 printed="37" read_by="text_layer" -->

SCOH-Q11 In this question 1 means no clear goals or purpose and 7 means very clear goals and purpose. Until
now your life has had no clear goals or purpose or has it had very clear goals and purpose?

1 No clear goals or no purpose at all
2 (cid:1)
3 |
4 |
5 |
6 (cid:2)
7 Very clear goals and purpose

SCOH-Q12 In this question 1 means you overestimate or underestimate importance and 7 means you see things
in the right proportion. When something happens, you generally find that you overestimate or
underestimate its importance or you see things in the right proportion?

1 Overestimate or underestimate its importance
2 (cid:1)
3 |
4 |
5 |
6 (cid:2)
7 See things in the right proportion

SCOH-Q13 In this question 1 means a source of great pleasure and satisfaction and 7 means a source of pain
and boredom. Is doing the things you do every day a source of great pleasure and satisfaction or a
source of pain and boredom?

1 A great deal of pleasure and satisfaction
2 (cid:1)
3 |
4 |
5 |
6 (cid:2)
7 A source of pain and boredom

**Health Status**

HSTAT-INT The next set of questions ask about ... (r/'s) day to day health. The questions are not about illnesses
like colds that affect people for short periods of time. They are concerned with a person's usual
abilities. You may feel that some of these questions do not apply to you/him/her, but it is
important that we ask the same questions of everyone.

**Vision**

HSTAT-Q1 Are/Is ... usually able to see well enough to read ordinary newsprint without glasses or contact
lenses?

- ___ Yes (Go to HSTAT-Q4)
- ___ No

DK, R (Go to HSTAT-Q6)
HSC4_1
PY_4_H11

PY_4_H12

PY_4_H13

<!-- page 38 printed="38" read_by="text_layer" -->

HSTAT-Q2 Are/Is you/he/she usually able to see well enough to read ordinary newsprint with glasses or
contact lenses?

- ___ Yes (Go to HSTAT-Q4)
- ___ No

HSTAT-Q3 Are/Is you/he/she able to see at all?

- ___ Yes
- ___ No (Go to HSTAT-Q6)

DK, R (Go to HSTAT-Q6)
HSTAT-Q4 Are/Is you/he/she able to see well enough to recognize a friend on the other side of the street
without glasses or contact lenses ?

- ___ Yes (Go to HSTAT-Q6)
- ___ No

DK, R (Go to HSTAT-Q6)
HSTAT-Q5 Are/Is you/he/she usually able to see well enough to recognize a friend on the other side of the
street with glasses or contact lenses?

- ___ Yes
- ___ No

**Hearing**
HSTAT-Q6 Are/Is ... usually able to hear what is said in a group conversation with at least three other people
without a hearing aid?

- ___ Yes (Go to HSTAT-Q10)
- ___ No

DK, R (Go to HSTAT-Q10)
HSTAT-Q7 Are/Is you/he/she usually able to hear what is said in a group conversation with at least three other
people with a hearing aid?

- ___ Yes (Go to HSTAT-Q8)
- ___ No

HSTAT-Q7a Are/Is you/he/she able to hear at all?

- ___ Yes
- ___ No (Go to HSTAT-Q10)

DK, R (Go to HSTAT-Q10)
HSTAT-Q8 Are/Is you/he/she usually able to hear what is said in a conversation with one other person in a
quiet room without a hearing aid ?

- ___ Yes (Go to HSTAT-Q10)
- ___ No

R (Go to HSTAT-Q10)
HSC4_4
HSC4_2

HSC4_5
HSC4_3

HSC4_6

HSC4_7

HSC4_7A

HSC4_8

<!-- page 39 printed="39" read_by="text_layer" -->

HSTAT-Q9 Are/Is you/he/she usually able to hear what is said in a conversation with one other person in a
quiet room with a hearing aid?

- ___ Yes
- ___ No

**Speech**
HSTAT-Q10 Are/Is ... usually able to be understood completely when speaking with strangers in your own
language?

- ___ Yes (Go to HSTAT-Q14)
- ___ No

R (Go to HSTAT-Q14)
HSTAT-Q11 Are/Is you/he/she able to be understood partially when speaking with strangers?

- ___ Yes
- ___ No

HSTAT-Q12 Are/Is you/he/she able to be understood completely when speaking with those who know
you/him/her well?

- ___ Yes (Go to HSTAT-Q14)
- ___ No

R (Go to HSTAT-Q14)
HSTAT-Q13 Are/Is you/he/she able to be understood partially when speaking with those who know you/him/her
well?

- ___ Yes
- ___ No

**Getting Around**
HSTAT-Q14 Are/Is ... usually able to walk around the neighbourhood without difficulty and without mechanical
support such as braces, a cane or crutches?

- ___ Yes (Go to HSTAT-Q21)
- ___ No

DK, R (Go to HSTAT-Q21)
HSTAT-Q15 Are/Is you/he/she able to walk at all?

- ___ Yes
- ___ No (Go to HSTAT-Q18

DK, R (Go to HSTAT-Q18)
HSTAT-Q16 Do/Does you/he/she require mechanical support such as braces, a cane or crutches to be able to
walk around the neighbourhood?

- ___ Yes
- ___ No

HSC4_11

HSC4_12

HSC4 13

HSC4_14

HSC4_15

HSC4_16
HSC4_9

HSC4_10

<!-- page 40 printed="40" read_by="text_layer" -->

HSTAT-Q17 Do/Does you/he/she require the help of another person to be able to walk?

- ___ Yes
- ___ No

HSTAT-Q18 Do/Does you/he/she require a wheelchair to get around?

- ___ Yes
- ___ No (Go to HSTAT-Q21)

DK, R (Go to HSTAT-Q21)
HSTAT-Q19 How often do/does you/he/she use a wheelchair?
(Read list. Mark one only.)

- ___ Always
- ___ Often
- ___ Sometimes
- ___ Never

HSTAT-Q20 Do/Does you/he/she need the help of another person to get around in the wheelchair?

- ___ Yes
- ___ No

**Hands and Fingers**
HSTAT-Q21 Are/Is ... usually able to grasp and handle small objects such as a pencil and scissors?

- ___ Yes (Go to HSTAT-Q25)
- ___ No

DK, R (Go to HSTAT-Q25)
HSTAT-Q22 Do/Does you/he/she require the help of another person because of limitations in the use of hands
or fingers?

- ___ Yes
- ___ No (Go to HSTAT-Q24)

DK, R (Go to HSTAT-Q24)
HSTAT-Q23 Do/Does you/he/she require the help of another person with:
(Read list. Mark one only.)

- ___ Some tasks?
- ___ Most tasks?
- ___ Almost all tasks?
- ___ All tasks?

HSTAT-Q24 Do/Does you/he/she require special equipment, for example, devices to assist in dressing because
of limitations in the use of hands or fingers?

- ___ Yes
- ___ No

HSC4_19

HSC4_20

HSC4_21

HSC4_22

HSC4_23

HSC4_24
HSC4_17

HSC4_18

<!-- page 41 printed="41" read_by="text_layer" -->

**Feelings**

HSTAT-Q25 Would you describe yourself/... as being usually:
(Read list. Mark one only.)

- ___ Happy and interested in life?
- ___ Somewhat happy?
- ___ Somewhat unhappy?
- ___ Unhappy with little interest in life?
- ___ So unhappy that life is not worthwhile?

**Memory**

HSTAT-Q26 How would you describe your/his/her usual ability to remember things? Are/Is you/he/she:
(Read list. Mark one only.)

- ___ Able to remember most things?
- ___ Somewhat forgetful?
- ___ Very forgetful?
- ___ Unable to remember anything at all?

**Thinking**

HSTAT-Q27 How would you describe your/his/her usual ability to think and solve day to day problems? Are/Is
you/he/she:
(Read list. Mark one only.)

- ___ Able to think clearly and solve problems?
- ___ Having a little difficulty?
- ___ Having some difficulty?
- ___ Having a great deal of difficulty?
- ___ Unable to think or solve problems?

**Pain and Discomfort**

HSTAT-Q28 Are/Is ... usually free of pain or discomfort?

- ___ Yes (Go to next section)
- ___ No

DK, R (Go to next section)

HSTAT-Q29 How would you describe the usual intensity of your/his/her pain or discomfort?
(Read list. Mark one only.)

- ___ Mild
- ___ Moderate
- ___ Severe

HSC4_26

HSC4_27

HSC4_28

HSC4_29
HSC4_25

<!-- page 42 printed="42" read_by="text_layer" -->

HSTAT-Q30 How many activities does your/his/her pain or discomfort prevent?
(Read list. Mark one only.)

- ___ None
- ___ A few
- ___ Some
- ___ Most

**Drug Use**

DRUG-INT Now I'd like to ask a few questions about ... (r/'s) use of medications, both prescription and over-
the-counter as well as other health products.

DRUG-Q1 In the past month4, did ... take any of the following medications?
(Read list. Mark all that apply.)

- ___ Pain relievers such as aspirin or tylenol (includes arthritis medicine and anti-

inflammatories)

- ___ Tranquilizers such as valium
- ___ Diet pills
- ___ Anti-depressants
- ___ Codeine, Demerol or Morphine
- ___ Allergy medicine such as "Sinutab"
- ___ Asthma medications
- ___ Cough or cold remedies
- ___ Penicillin or other antibiotic
- ___ Medicine for the heart
- ___ Medicine for blood pressure
- ___ Diuretics or water pills
- ___ Steroids
- ___ Insulin
- ___ Pills to control diabetes
- ___ Sleeping pills
- ___ Stomach remedies
- ___ Laxatives
- ___ Hormones for menopause or aging symptoms (check item: sex=female, age >= 30)
- ___ Birth control pills (check item: sex=female, age >= 12 & age <= 49)
- ___ Any other medication (Specify_________)
- ___ None of the above

DRUG-C1 If any drug(s) specified in DRUG-Q1 go to DRUG-Q2. Otherwise go to DRUG-Q4.

DRUG-Q2 Now, I am referring to yesterday and the day before yesterday. During those two days, how many
different medications did you/he/she take?

- ___ Number of different medications

DK, R (Go to DRUG-Q4)

If number=0 then go to DRUG-Q4
For each number >0 ask DRUG-Q3...up to a maximum of 12.
DGC4_1A

DGC4_1B
DGC4_1C
DGC4_1D
DGC4_1E
DGC4_1F
DGC4_1G
DGC4_1H
DGC4_1I
DGC4_1J
DGC4_1K
DGC4_1L
DGC4_1M
DGC4_1N
DGC4_1O
DGC4_1P
DGC4_1Q
DGC4_1R
DGC4_1T
DGC4_1S
DGC4_1V
DGC4_NON

DGC4_2
HSC4_30

<!-- page 43 printed="43" read_by="text_layer" -->

DRUG-Q3 What is the exact name of the medication that ... took? (Ask the person to look at the bottle, tube
or box.)
\____________________________
DK, R to any medication (Go to next section)

DRUG-Q4 There are many other health products such as ointments, vitamins, herbs, minerals, teas or protein
drinks which people use to prevent illness or to improve or maintain their health. Do/Does ... use
any of these or other health products?

- ___ Yes
- ___ No (Go to next section)

DK, R (Go to next section)

DRUG-Q5 What is the exact name of the health product that ... use(s)? (Ask the person to look at the bottle,
tube or box.) (up to 12 products)

\____________________________

**Mental Health**
(Non-proxy only)

MHLTH-INTa Now some questions about mental and emotional well-being. During the past month4, about how
often did you feel:

MHLTH-Q1a ... so sad that nothing could cheer you up?
(Read list. Mark one only.)

- ___ All of the time
- ___ Most of the time
- ___ Some of the time
- ___ A little of the time
- ___ None of the time

DK, R (Go to MHLTH-Q1k)

MHLTH-Q1b ... nervous?
(Read list. Mark one only.)

- ___ All of the time
- ___ Most of the time
- ___ Some of the time
- ___ A little of the time
- ___ None of the time

DK, R (Go to MHLTH-Q1k)

MHLTH-Q1c ... restless or fidgety?
(Read list. Mark one only.)

- ___ All of the time
- ___ Most of the time
- ___ Some of the time
- ___ A little of the time
- ___ None of the time

DK, R (Go to MHLTH-Q1k)
DGC4_5nn

MHC4_1A
DGC4_3nC

MHC4_1B
DGC4_4

MHC4_1C

<!-- page 44 printed="44" read_by="text_layer" -->

MHLTH-Q1d ... hopeless?
(Read list. Mark one only.)

- ___ All of the time
- ___ Most of the time
- ___ Some of the time
- ___ A little of the time
- ___ None of the time

DK, R (Go to MHLTH-Q1k)

MHLTH-Q1e ... worthless?
(Read list. Mark one only.)

- ___ All of the time
- ___ Most of the time
- ___ Some of the time
- ___ A little of the time
- ___ None of the time

DK, R (Go to MHLTH-Q1k)

MHLTH-Q1f During the past month, about how often did you feel that everything was an effort?
(Read list. Mark one only.)

- ___ All of the time
- ___ Most of the time
- ___ Some of the time
- ___ A little of the time
- ___ None of the time

DK, R (Go to MHLTH-Q1k)

MHLTH-C1g IF MHLTH-Q1a to MHLTH-Q1f are all "none" go to MHLTH-Q1k.

MHLTH-Q1g We have just been talking about feelings and experiences that occurred to different degrees during
the past month. Taking them altogether, did these feelings occur more often in the past month than
is usual for you, less often than usual , or about the same as usual?
(Do not read list. Mark one only.)

- ___ More often
- ___ Less often (Go to MHLTH-Q1i)
- ___ About the same (Go to MHLTH-Q1j)
- ___ Never have had any (Go to MHLTH-Q1k)

DK, R (Go to MHLTH-Q1k)

MHLTH-Q1h Is that a lot more, somewhat or only a little more often than usual?
(Do not read list. Mark one only.)

- ___ A lot more
- ___ Somewhat more
- ___ A little more

DK, R (Go to MHLTH-Q1k)

(Go to Q1j)
MHC4_1E

MHC4_1F

MHC4_1G

MHC4_1H
MHC4_1D

<!-- page 45 printed="45" read_by="text_layer" -->

MHLTH-Q1i Is that a lot less, somewhat or only a little less often than usual?
(Do not read list. Mark one only.)

- ___ A lot less
- ___ Somewhat less
- ___ A little less

DK, R (Go to MHLTH-Q1k)

MHLTH-Q1j How much do these experiences usually interfere with your life or activities?
(Read list. Mark one only.)

- ___ A lot
- ___ Some
- ___ A little
- ___ Not at all

MHLTH-Q1k In the past 12 months2, have you seen or talked on the telephone to a health professional about
your emotional or mental health?

- ___ Yes
- ___ No (Go to MHLTH-Q2.)

DK, R (Go to MHLTH-Q2)

MHLTH-Q1l How many times (in the past 12 months)?

- ___ # of times

MHLTH-Q2 During the past 12 months, was there ever a time when you felt sad, blue, or depressed for 2 weeks
or more in a row?

- ___ Yes
- ___ No (Go to MHLTH-Q16.)

DK, R (Go to next section)

MHLTH-Q3 For the next few questions, please think of the 2-week period during the past 12 months when these
feelings were worst. During that time how long did these feelings usually last?
(Read list. Mark one only.)

- ___ All day long
- ___ Most of the day
- ___ About half of the day (Go to MHLTH-Q16.)
- ___ Less than half the day (Go to MHLTH-Q16.)

DK, R (Go to next section)

MHLTH-Q4 How often did you feel this way during those 2 weeks?
(Read list. Mark one only.)

- ___ Every day
- ___ Almost every day
- ___ Less often (Go to MHLTH-Q16.)

DK, R (Go to next section)
MHC4_1J

MHC4_1K

MHC4_1L

MHC4_2
MHC4_1I

MHC4_3

MHC4_4

<!-- page 46 printed="46" read_by="text_layer" -->

MHLTH-Q5 During those 2 weeks did you lose interest in most things?

- ___ Yes (KEY PHRASE = LOSING INTEREST)
- ___ No

DK, R (Go to next section)
MHLTH-Q6 Did you feel tired out or low on energy all of the time?

- ___ Yes (KEY PHRASE = FEELING TIRED)
- ___ No

DK, R (Go to next section)
MHLTH-Q7 Did you gain weight, lose weight or stay about the same?
(Do not read list. Mark one only.)

- ___ Gained weight (KEY PHRASE = GAINING WEIGHT)
- ___ Lost weight (KEY PHRASE = LOSING WEIGHT)
- ___ Stayed about the same (Go to MHLTH-Q9.)
- ___ Was on a diet (Go to MHLTH-Q9.)

DK, R (Go to next section)
MHLTH-Q8 About how much did you (gain/lose)?

- ___ pounds or kilograms

MHLTH-Q9 Did you have more trouble falling asleep than you usually do?

- ___ Yes (KEY PHRASE = TROUBLE FALLING ASLEEP)
- ___ No (Go to MHLTH-Q11.)

DK, R (Go to next section)
MHLTH-Q10 How often did that happen?
(Read list. Mark one only.)

- ___ Every night
- ___ Nearly every night
- ___ Less often

DK, R (Go to next section)
MHLTH-Q11 Did you have a lot more trouble concentrating than usual?

- ___ Yes (KEY PHRASE = TROUBLE CONCENTRATING)
- ___ No

DK, R (Go to next section)
MHLTH-Q12 At these times, people sometimes feel down on themselves, no good, or worthless. Did you feel
this way?

- ___ Yes (KEY PHRASE = FEELING DOWN ON YOURSELF)
- ___ No

DK, R (Go to next section)
MHC4_7

MHC4_8LB
MHC4_8KG

MHC4_9

MHC4_10

MHC4_11

MHC4_12
MHC4_5

MHC4_6

<!-- page 47 printed="47" read_by="text_layer" -->

MHLTH-Q13 Did you think a lot about death - either your own, someone else's, or death in general?

- ___ Yes (KEY PHRASE =THOUGHTS ABOUT DEATH)
- ___ No

DK, R (Go to next section)

MHLTH-C14 If any "yes" in Q5, Q6, Q9, Q11, Q12 or Q13, or Q7 is "gain" or "lose" then go to MHLTH-Q14.
Otherwise go to next section.

MHLTH-Q14 Reviewing what you just told me, you had 2 weeks in a row during the past 12 months when you
were sad, blue, or depressed and also had some other things like (KEY PHRASES). About how
many weeks altogether did you feel this way during the past 12 months?

- ___ # of weeks (IF >51 weeks then go to next section.)

DK, R (Go to next section)

MHLTH-Q15 Think about the last time you felt this way for 2 weeks or more in a row. In what month was that?

- ___ January ___ July
- ___ February ___ August
- ___ March ___ September
- ___ April ___ October
- ___ May ___ November
- ___ June ___ December

Go to next section.

MHLTH-Q16 During the past 12 months, was there ever a time lasting 2 weeks or more when you lost interest in
most things like hobbies, work, or activities that usually give you pleasure?

- ___ Yes
- ___ No (Go to next section)

DK, R (Go to next section)

MHLTH-Q17 For the next few questions, please think of the 2-week period during the past 12 months when you
had the most complete loss of interest in things. During that 2-week period, how long did the loss
of interest usually last?
(Read list. Mark one only.)

- ___ All day long
- ___ Most of the day
- ___ About half of the day (Go to next section)
- ___ Less than half the day (Go to next section)

DK, R (Go to next section)

MHLTH-Q18 How often did you feel this way during those 2 weeks?
(Read list. Mark one only.)

- ___ Every day
- ___ Almost every day
- ___ Less often (Go to next section)

DK, R (Go to next section)
MHC4_14

MHC4_15

MHC4_16

MHC4_17

MHC4_18
MHC4_13

<!-- page 48 printed="48" read_by="text_layer" -->

MHLTH-Q19 During those 2 weeks did you feel tired out or low on energy all the time?

- ___ Yes (KEY PHRASE = FEELING TIRED)
- ___ No

DK, R (Go to next section)

MHLTH-Q20 Did you gain weight, lose weight, or stay about the same?
(Do not read list. Mark one only.)

- ___ Gained weight (KEY PHRASE = GAINING WEIGHT)
- ___ Lost weight (KEY PHRASE = LOSING WEIGHT)
- ___ Stayed about the same (Go to MHLTH-Q22)
- ___ Was on a diet (Go to MHLTH-Q22)

DK, R (Go to next section)

MHLTH-Q21 About how much did you (gain/lose)?

- ___ pounds or kilograms

MHLTH-Q22 Did you have more trouble falling asleep than you usually do?

- ___ Yes (KEY PHRASE = TROUBLE FALLING ASLEEP)
- ___ No (Go to MHLTH-Q24)

DK, R (Go to next section)

MHLTH-Q23 How often did that happen during those 2 weeks?
(Read list. Mark one only.)

- ___ Every night
- ___ Nearly every night
- ___ Less often

DK, R (Go to next section)

MHLTH-Q24 Did you have a lot more trouble concentrating than usual?

- ___ Yes (KEY PHRASE = TROUBLE CONCENTRATING)
- ___ No

DK, R (Go to next section)

MHLTH-Q25 At these times, people sometimes feel down on themselves, no good, or worthless. Did you feel
this way?

- ___ Yes (KEY PHRASE = FEELING DOWN ON YOURSELF)
- ___ No

DK, R (Go to next section)

MHLTH-Q26 Did you think a lot about death - either your own, someone else's, or death in general?

- ___ Yes (KEY PHRASE =THOUGHTS ABOUT DEATH)
- ___ No

DK, R (Go to next section)

MHLTH-C27 If any "yes" in Q19, Q22, Q24, Q25 or Q26, or Q20 is "gain" or "lose" then go to MHLTH-Q27.
Otherwise go to next section.
MHC4_21L
MHC4_21K

MHC4_22

MHC4_23

MHC4_24

MHC4_25
MHC4_19

MHC4_26
MHC4_20

<!-- page 49 printed="49" read_by="text_layer" -->

MHLTH-Q27 Reviewing what you just told me, you had 2 weeks in a row during the past 12 months when you
lost interest in most things and also had some other things like (KEY PHRASES). About how
many weeks did you feel this way during the past 12 months?

- ___ # of weeks (IF >51 weeks then go to next section.)

DK, R (Go to next section)

MHLTH-Q28 Think about the last time you had 2 weeks in a row when you felt this way. In what month was
that?

- ___ January ___ July
- ___ February ___ August
- ___ March ___ September
- ___ April ___ October
- ___ May ___ November
- ___ June ___ December

**Social Support**
(Non-proxy only)

SOCSUP-INT Now, a few questions about your contact with different groups and support from family and
friends.

SOCSUP-Q1 Are you a member of any voluntary organizations or associations such as school groups, church
social groups, community centres, ethnic associations or social, civic or fraternal clubs?

- ___ Yes
- ___ No (Go to SOCSUP-Q2a)

DK, R (Go to SOCSUP-Q2a)

SOCSUP-Q2 How often did you participate in meetings or activities sponsored by these groups in the past 12
months? If you belong to many, just think of the ones in which you are most active.
(Read list. Mark one only.)

- ___ At least once a week
- ___ At least once a month
- ___ At least 3 or 4 times a year
- ___ At least once a year
- ___ Not at all

SOCSUP-Q2a Other than on special occasions (such as weddings, funerals or baptisms), how often did you attend
religious services or religious meetings in the past 12 months?
(Read list. Mark one only.)

- ___ At least once a week
- ___ At least once a month
- ___ At least 3 or 4 times a year
- ___ At least once a year
- ___ Not at all

SOCSUP-Q3 Do you have someone you can confide in, or talk to about your private feelings or concerns?

- ___ Yes
- ___ No

MHC4_28

SSC4_1

SSC4_2

SSC4_2A

SSC4_3
MHC4_27

<!-- page 50 printed="50" read_by="text_layer" -->

SOCSUP-Q4 Do you have someone you can really count on to help you out in a crisis situation?

- ___ Yes
- ___ No

SOCSUP-Q5 Do you have someone you can really count on to give you advice when you are making important
personal decisions?

- ___ Yes
- ___ No

SOCSUP-Q6 Do you have someone that makes you feel loved and cared for?

- ___ Yes
- ___ No

SOCSUP-Q7 The next few questions are about your contact in the past 12 months with persons who do not live
with you either in person, by phone, or by mail. If you have more than one person in a category,
for example, several sisters, think of the one with whom you have the most contact. How often did
you have contact with [fill with categories below]?

- ___ Your parents or parents-in-law
- ___ Your grandparents
- ___ Your daughters or daughters-in-law
- ___ Your sons or sons-in-law
- ___ Your brothers or sisters
- ___ Other relatives (including in-laws)
- ___ Your close friends
- ___ Your neighbours

Choice of responses are: (Read list. Mark one only.)

Don't have any
Every day
At least once a week
2 or 3 times a month
Once a month
A few times a year
Once a year
Never

**Health Number**

H06-HLTH# We are seeking your permission to link information collected during this interview with provincial
health information. This would include information on past and continuing use of services such as
visits to hospitals, clinics, physician's offices or other services provided by the province. This
information will be used for statistical purposes only. Do we have your permission?

- ___ Yes
- ___ No (Go to H06-SHARE)

DK, R (Go to next section)
SSC4_5

SSC4_6

SSC4_7A
SSC4_7B
SSC4_7C
SSC4_7D
SSC4_7E
SSC4_7F
SSC4_7G
SSC4_7H

AM64_LNK
SSC4_4

<!-- page 51 printed="51" read_by="text_layer" -->

H06-HLTH#l Having a provincial health number will assist us in linking to this other information. What is ...r/s
provincial health number?

\____________

**Agreement to Share**

H06-SHARE To avoid duplication Statistics Canada intends to share the information from this survey with
provincial ministries of health, Health Canada, and Employment and Immigration Canada. These
organizations have undertaken to keep this information confidential and use it only for statistical
purposes. Do you agree to share the information you have provided?

- ___ Yes
- ___ No

H06-TEL Was this interview conducted on the telephone or in person?

- ___ On telephone
- ___ In person
- ___ Both (Specify reason)

H06-CTEXT Was the respondent alone when you asked this health questionnaire?

- ___ Yes (Go to H06-P2)
- ___ No

H06-CTEXT1 Do you think that the answers of the respondent were affected by someone else being there?

- ___ Yes (Specify)
- ___ No

H06-P2 Record language of interview

English Persian (Farsi)
French Polish
Arabic Portuguese
Chinese Punjabi
Cree Spanish
German Tagalog (Filipino)
Greek Ukrainian
Hungarian Vietnamese
Italian Other (Specify_______________)
Korean
AM64_SHA

AM64_TEL

AM64_ALO

AM64_AFF
HNC4_nn

AM64_LNG

<!-- page 52 printed="52" read_by="text_layer" -->

**Manitoba Buy-in Questions**
(Age >= 18 and non-proxy only)
SPR6-INTA The next questions are being asked for your provincial government. They deal with the day-to-
days demands in your life.
SPR6-INTB When relating to people, some people rely heavily on their thinking, rational side. Others rely
much more on their emotional side. In the following questions, I will be asking about your primary
style of relating to people. Please answer either "Yes" or "No" to each question. If you are not
sure, it is usually best to respond with your first impression.
SPR6-Q1 Do you always try to do what is reasonable and logical?

- ___ Yes
- ___ No

SPR6-Q2 Do you always try to understand people and their behaviour, to avoid responding emotionally?

- ___ Yes
- ___ No

SPR6-Q3 When dealing with other people do you always try to act rationally?

- ___ Yes
- ___ No

SPR6-Q4 Do you try to overcome all conflicts with other people by intelligence and reason, trying hard not
to show your emotions?

- ___ Yes
- ___ No

SPR6-Q5 If someone deeply hurts your feelings, do you nevertheless try to treat him or her rationally and to
understand his or her way of behaving?

- ___ Yes
- ___ No

SPR6-Q6 Do you succeed in avoiding most conflicts with other people by relying on your reason and logic,
even if this is not how you feel at the time?

- ___ Yes
- ___ No

RTP4_1

RTP4_2

RTP4_3

RTP4_4

RTP4_5

RTP4_6

<!-- page 53 printed="53" read_by="text_layer" -->

SPR6-Q7 If someone acts against your needs and desires, do you nevertheless try to understand that person?

- ___ Yes
- ___ No

SPR6-Q8 Do you behave so rationally in most life situations that your behaviour is rarely influenced by only
your emotions?

- ___ Yes
- ___ No

SPR6-Q9 Do your emotions frequently influence your behaviour to such a degree that your behaviour might
be considered harmful to yourself and others?

- ___ Yes
- ___ No

SPR6-Q10 Do you try to understand others even if you don't like them?

- ___ Yes
- ___ No

SPR6-Q11 Does your rationality prevent you from verbally attacking or criticizing others, even if there are
sufficient reasons for doing so?

- ___ Yes
- ___ No

SPR6-INTQ12 In the next few questions, you will be asked to imagine yourself in a particular situation. It is not
important for you to have actually experienced the situation. Simply pretend you are in the
described situation.

SPR6-Q12 Imagine you are afraid of the dentist and you have to get some dental work done. Which of the
following things would you do to help you overcome your fears?
(Read list. Mark all that apply.)

- ___ Ask the dentist exactly what he is doing
- ___ Take a tranquilizer or have a drink before going
- ___ Try to think about other things, like pleasant memories
- ___ Have the dentist tell you when you would feel pain
- ___ Try to sleep
- ___ Watch all the dentist's movements and listen for the sound of the drill
- ___ Watch the flow of water from your mouth to see if it contained blood
- ___ Do mental puzzles in your mind
- ___ Other (Specify_______)

RTP4_7

RTP4_8

RTP4_9

RTP4_10

RTP4_11

RTP4_12A
RTP4_12B
RTP4_12C
RTP4_12D
RTP4_12E
RTP4_12F
RTP4_12G
RTP4_12H
RTP4_12I

<!-- page 54 printed="54" read_by="text_layer" -->

SPR6-Q13 Imagine that you are a salesperson and get along well with your fellow workers. It has been
rumoured that, due to a large drop in sales, several people in your department will be laid off. The
decision about lay-offs has been made and will be announced in several days. Which of the
following would you do?

(Read list. Mark all that apply.)

- ___ Talk to your fellow workers to see if they know anything about the supervisor's evaluation

of you

- ___ Review the list of duties for your present job and try to figure out if you had

accomplished all of them

- ___ Watch TV, go to the movies or do something like that, to take your mind off things
- ___ Try to remember any arguments or disagreements you might have had with your

supervisor that might have lowered his or her opinion of you

- ___ Push all thoughts of being laid off out of your mind
- ___ If it came up during a conversation say that you would rather not discuss your chances of

being laid off

- ___ Try to think which employees in your department the supervisor might evaluate more

poorly than you

- ___ Continue doing your work as if nothing special was happening
- ___ Other (Specify___)

RTP4_13A

RTP4_13B

RTP4_13C
RTP4_13D

RTP4_13E
RTP4_13F

RTP4_13G

RTP4_13H
RTP4_13I

<!-- page 55 printed="55" read_by="text_layer" -->

**Alberta Buy-in Questions**
(Age >= 18 and non-proxy only)

SPR8-INT The next questions are being asked for your provincial government. They deal with the day-to-
days demands in your life.

SPR8-Q1 How would you rate your ability to handle the day-to-day demands in your life, for example, work,
family and volunteer responsibilities?
(Read list. Mark one only.)

- ___ Excellent
- ___ Very Good
- ___ Good
- ___ Fair
- ___ Poor

SPR8-Q2 If the day-to-day demands in your life were causing you to feel under stress, which of the following
would you do?
(Read list. Mark all that apply.)

- ___ Try not to think about the situation and keep yourself busy to prevent thinking about it
- ___ Try to see the situation in a different light that makes it seem more bearable
- ___ Think about ways to change the situation or do something to solve the problem causing

the stress

- ___ Express your emotions to reduce your tension, anxiety or frustration
- ___ Admit to yourself that the situation is stressful, but otherwise do nothing
- ___ Talk about the situation with others
- ___ Do something you enjoy in order to relax
- ___ Pray or otherwise seek comfort or strength through religious faith
- ___ Do something else (Specify______)

SPR8-Q3 How would you rate your ability to handle unexpected and difficult problems, for example, family
or personal crisis?
(Read list. Mark one only.)

- ___ Excellent
- ___ Very Good
- ___ Good
- ___ Fair
- ___ Poor

SPR8-Q4 If an unexpected problem or situation was causing you to feel under stress, which of the following
would you do?
(Read list. Mark all that apply.)

- ___ Try not to think about the situation and keep yourself busy to prevent thinking about it
- ___ Try to see the situation in a different light that makes it seem more bearable
- ___ Think about ways to change the situation or do something to solve the problem causing

the stress

- ___ Express your emotions to reduce your tension, anxiety or frustration
- ___ Admit to yourself that the situation is stressful, but otherwise do nothing
- ___ Talk about the situation with others
- ___ Do something you enjoy in order to relax
- ___ Pray or otherwise seek comfort or strength through religious faith
- ___ Do something else (Specify________)

COP4_1

COP4_2A
COP4_2B
COP4_2C

COP4_2D
COP4_2E
COP4_2F
COP4_2G
COP4_2H
COP4_2I

COP4_3

COP4_4A
COP4_4B
COP4_4C

COP4_4D
COP4_4E
COP4_4F
COP4_4G
COP4_4H
COP4_4I

<!-- page 56 printed="56" read_by="text_layer" -->

**Notes:**
1. Past 2 weeks refers to the 2 weeks leading up to the day before the interview e.g. if the day of the interview
is September 10, 1993 then the past 2 weeks include August 27, 1993 to September 9, 1993.
2. Past 12 months refers to the 12 months leading up to the day before the interview e.g. if the day of the
interview is September 10, 1993 then the past 12 months include September 10, 1992 to September 9, 1993.
3. Past 3 months refers to the 3 months leading up to the day before the interview e.g. if the day of the
interview is September 10, 1993 then the past 3 months include June 10, 1993 to September 9, 1993.
4. Past month refers to the month leading up to the day before the interview e.g. if the day of the interview is
September 10, 1993 then the past month includes August 10, 1993 to September 9, 1993.

<!-- page 57 read_by="text_layer" -->

A-1
APPENDIX A

**Health Component for Respondents Aged 0 to 11 Years Old (Form H06)**
(Proxy only, to be completed for selected respondent only and age <= 11)

NOTE:
The data for the 1994-95 NPHS selected child 0 to 11 years old were collected by the National Longitudinal Survey
of Children and Youth (NLSCY). The data were picked up from NLSCY and were reformatted to fit into the NPHS
processing system. The question names used here were assigned during processing to be consistent with 1996. When
question wording was similar, the wording from NPHS was used. If the wording was sufficiently different that
concepts may vary, the NLSCY wording was used. See National Longitudinal Survey of Children Survey
Instruments for 1994-95 Data Collection, Cycle 1 Catalogue No. 95-01 for exact order and wording of the questions.
For complete details on the 1994-95 sample design , see Sample Design of the National Population Health Survey ,
Health Reports 1995, Vol. 7, No.1.

**Child General Health**

KGH-Q1 In general, would you say %FNAME’s% health is:
(READ LIST. MARK ONE ONLY.)

1 Excellent?
2 Very good?
3 Good?
4 Fair?
5 Poor?

KGH-Q3 Does %FNAME% have any long-term physical or mental condition or a health problem which
prevents or limits %his/her% participation in school, at play, or in any other activity for a child
%his/her% age?

1 YES
2 NO

KGH-Q4 How tall is %he/she% without shoes on?

------ FEET ----- INCHES OR ------- CENTIMETRES

KGH-Q5 How much does %he/she% weigh?

____ (ENTER AMOUNT ONLY.) (MIN: 1) (MAX: 300)
DK, R (Go to next section)

KGH-C5INTERVIEWER: WAS THAT IN POUNDS OR IN KILOGRAMS?

1 POUNDS
2 KILOGRAMS
GHC4_1

HWC4_HT

HWC4_3LB
HWC4_3KG
RAC4F1

<!-- page 58 read_by="text_layer" -->

A-2
Child Health Care Utilization

KUT-INT Now I’d like to ask about %FNAME’s% contacts with health professionals during the past 12
months, that is, from %12MOSAGO% to yesterday.

KUT-Q1 In the past 12 months, has %FNAME% been an overnight patient in a hospital?

1 YES
2 NO

KUT-Q3 (Not counting when %FNAME% was an overnight patient) In the past 12 months, how many times
have you seen or talked on the telephone with a/an/any [fill category] about %his/her% physical,
emotional or mental health? (Exclude at time of birth for babies.)

MIN MAX
a) A general practitioner , family physician 0 366
b) A pediatrician 0 366
c) An other medical doctor (such as an orthopedist, 0 300
or eye specialist)
d) A public health nurse or nurse practitioner 0 366
e) A dentist or orthodontist 0 99
f) A psychiatrist or psychologist 0 366
g) Child welfare worker or children’s aid worker 0 366
h) Any other person trained to provide treatment 0 366
or counsel, for example a speech therapist,
a social worker

**Child Chronic Conditions**

KCHR-C1 If age > 3, go to KCHR-Q4.

KCHR-Q1 Thinking now about illnesses, how often does %FNAME% have nose or throat infections?
(READ LIST. MARK ONE ONLY.)

1 Almost all the time
2 Often
3 From time to time
4 Rarely
5 Never

KCHR-Q2 Since %his/her% birth, has %he/she% ever had an ear infection (otitis)?

1 YES
2 NO (Go to KCHR-Q4)
DK, R (Go to KCHR-Q4)
HCC4_2A
HCC4_2A
HCC4_2C

HCC4_2D
HCC4_2E
HCC4_2I
HCC4_2H
HCK4_2OT
HCC4_1

CCK4_1

CCK4_2

<!-- page 59 read_by="text_layer" -->

A-3
KCHR-Q3 How many times?
(DO NOT READ LIST. MARK ONE ONLY.)

1 ONCE
2 2 TIMES
3 3 TIMES
4 4 OR MORE TIMES

KCHR-Q4 The following questions are about asthma. Has %FNAME% ever had asthma that has been diagnosed
by a health professional?

1 YES
2 NO (Go to KCHR1-INT)
DK, R (Go to KCHR1-INT)

KCHR-Q5 Has %he/she% had an attack of asthma in the past 12 months?

1 YES
2 NO

KCHR-Q6 Has %he/she% had wheezing or whistling in the chest at any time in the past 12 months?

1 YES
2 NO

KCHR1-INT In the following questions long-term conditions refer to conditions that have lasted or are expected to
last 6 months or more.

KCHR1-Q1 Does %FNAME% have any of the following long-term conditions that have been diagnosed by a
health professional?

a) Allergies?
b) Bronchitis?
c) Heart condition or disease?
d) Epilepsy?
e) Cerebral palsy?
f) Kidney condition or disease?
g) Mental handicap?
h) A learning disability? (Ask only age>=6)
i) An emotional, psychological or nervous condition? (Ask only age>=6)
j) Any other long-term condition?
k) None

**Child Health Status**

KHS-C1 If age < 4, go to next section.

KHS-INT The next set of questions asks about %you/FNAME%%r/s% day-to-day health. The questions are not
about illnesses like colds that affect people for short periods of time. They are concerned about a
person’s usual abilities.

KHS-INTA You may feel that some of these questions do not apply to %you/him/her%, but it is important that we
ask the same questions of everyone.
CCC4_1C

CCC4_C5

CCC4_C6
CCK4_3

CCK4_1AB
CCC4_1H
CCC4_1L
CCC4_1K
CCC4_1V
CCC4_1V
CCC4_1V
CCC4_1V
CCC4_1V
CCC4_1V
CCC4_NON

<!-- page 60 read_by="text_layer" -->

A-4
Vision
KHS-Q1 Is %he/she% usually able to see clearly, and without distortion, the words in a book without glasses or
contact lenses?
1 YES (Go to KHS-Q4)
2 NO
KHS-Q2 Is %he/she% usually able to see clearly, and without distortion, the words in a book with glasses or
contact lenses?
1 YES (Go to KHS-Q4)
2 NO
3 DOESN’T WEAR GLASSES OR CONTACT LENSES
KHS-Q3 Is %he/she% able to see at all?
1 YES
2 NO (Go to KHS-Q6)
KHS-Q4 Is %he/she% able to see well enough to recognize a friend on the other side of the street without
glasses or contact lenses?
1 YES (Go to KHS-Q6)
2 NO
KHS-Q5 Is %he/she% usually able to see well enough to recognize a friend on the other side of the street with
glasses or contact lenses?
1 YES
2 NO
3 DOESN’T WEAR GLASSES OR CONTACT LENSES
Hearing
KHS-Q6 Is %he/she% usually able to hear what is said in a group conversation with at least 3 other people
without a hearing aid?
1 YES (Go to KHS-IN2)
2 NO
KHS-Q7 Is %he/she% usually able to hear what is said in a group conversation with at least 3 other people with
a hearing aid?
1 YES (Go to KHS-Q8)
2 NO
3 DOESN’T WEAR A HEARING AID
HSC4_2

HSC4_3

HSC4_4

HSC4_5

HSC4_6
HSC4_1

HSC4_7

<!-- page 61 read_by="text_layer" -->

A-5
KHS-Q7A Is %he/she% able to hear at all?
1 YES
2 NO (Go to KHS-IN2)
KHS-Q8 Is %he/she% usually able to hear what is said in a conversation with one other person in a quiet room
without a hearing aid?
1 YES (Go to KHS-IN2)
2 NO
KHS-Q9 Is %he/she% usually able to hear what is said in a conversation with one other person in a quiet room
with a hearing aid?
1 YES
2 NO
3 DOESN’T WEAR A HEARING AID
Speech
KHS-IN2 The next few questions on day-to-day health are concerned with %FNAME%’s abilities relative to
other children the same age.
KHS-Q10 Is %he/she% usually able to be understood completely when speaking with strangers in %his/her%
own language?
1 YES (Go to KHS-Q14)
2 NO
KHS-Q11 Is %he/she% able to be understood partially when speaking with strangers in %his/her% own
language?
1 YES
2 NO
KHS-Q12 Is %he/she% able to be understood completely when speaking with those who know %him/her%
well?
1 YES (Go to KHS-Q14)
2 NO
KHS-Q13 Is %he/she% able to be understood partially when speaking with those who know %him/her% well?
1 YES
2 NO
Getting Around
KHS-Q14 Is %FNAME% usually able to walk around the neighbourhood without difficulty and without
mechanical support such as braces, a cane or crutches?
1 YES (Go to KHS-Q21)
2 NO
HSC4_9

HSC4_10

HSC4_11

HSC4_12

HSC4_13

HSC4_14
HSC4_7A

HSC4_8

<!-- page 62 read_by="text_layer" -->

A-6
KHS-Q15 Is %he/she% able to walk at all?
1 YES
2 NO (Go to KHS-Q18)
KHS-Q16 Does %he/she% require mechanical support such as braces, a cane or crutches to be able to walk?
1 YES
2 NO
KHS-Q17 Does %he/she% require the help of another person to be able to walk?
1 YES
2 NO
KHS-Q18 Does %he/she% require a wheelchair to get around?
1 YES
2 NO (Go to KHS-Q21)
KHS-Q19 How often does %he/she% use a wheelchair?
(READ LIST. MARK ONE ONLY.)
1 Always
2 Often
3 Sometimes
4 Never
KHS-Q20 Does %he/she% need the help of another person to get around in the wheelchair?
1 YES
2 NO
Hands and Fingers
KHS-Q21 Is %FNAME% usually able to grasp and handle small objects such as a pencil or scissors?
1 YES (Go to KHS-Q25)
2 NO
KHS-Q22 Does %he/she% require the help of another person because of limitations in the use of hands or
fingers?
1 YES
2 NO (Go to KHS-Q24)
KHS-Q23 Does %he/she% require the help of another person with:
(READ LIST. MARK ONE ONLY.)
1 Some tasks?
2 Most tasks?
3 Almost all tasks?
4 All tasks?
HSC4_16

HSC4_17

HSC4_18

HSC4_19

HSC4_20

HSC4_21
HSC4_15

HSC4_22

HSC4_23

<!-- page 63 read_by="text_layer" -->

A-7
KHS-Q24 Does %he/she% require special equipment, for example, devices to assist in dressing because of
limitations in the use of hands or fingers?

1 YES
2 NO

**Feelings**

KHS-Q25 Would you describe %FNAME% as being usually:
(READ LIST. MARK ONE ONLY.)

1 Happy and interested in life?
2 Somewhat happy?
3 Somewhat unhappy?
4 Unhappy with little interest in life?
5 So unhappy that life is not worthwhile?

**Memory**

KHS-Q26 How would you describe %his/her% usual ability to remember things?
(READ LIST. MARK ONE ONLY.)

1 Able to remember most things?
2 Somewhat forgetful?
3 Very forgetful?
4 Unable to remember anything at all?

**Thinking**

KHS-Q27 How would you describe %his/her% usual ability to think and solve day-to-day problems?
(READ LIST. MARK ONE ONLY.)

1 Able to think clearly and solve problems?
2 Having a little difficulty?
3 Having some difficulty?
4 Having a great deal of difficulty?
5 Unable to think or solve problems?

**Pain and Discomfort**

KHS-Q28 Is %FNAME% usually free of pain or discomfort?

1 YES (Go to next section)
2 NO

KHS-Q29 How would you describe the usual intensity of %his/her% pain or discomfort?
(READ LIST. MARK ONE ONLY.)

1 Mild
2 Moderate
3 Severe
HSC4_24

HSC4_27
HSC4_25

HSC4_28

HSC4_29
HSC4_26

<!-- page 64 read_by="text_layer" -->

A-8
KHS-Q30 How many activities does %his/her% pain or discomfort prevent?
(READ LIST. MARK ONE ONLY.)

1 None
2 A few
3 Some
4 Most

**Child Injuries**

KIN-INT The following questions refer to injuries, such as a broken bone, bad cut or burn, head injury,
poisoning, or a sprained ankle, which occurred in the past 12 months and were serious enough to
require medical attention by a doctor, nurse, or dentist.

KIN-Q1 In the past 12 months, was %FNAME% injured?

1 YES
2 NO (Go to next section)
DK, R (Go to next section)

KIN-Q2 How many times was %he/she% injured?
|_|_| TIMES (MIN: 1) (MAX: 30)
DK, R (Go to next section)

KIN-Q3 (For the most serious injury,) what type of injury did %he/she% have?
(DO NOT READ LIST. MARK ONE ONLY.)

1 BROKEN OR FRACTURED BONES
2 BURN OR SCALD
3 DISLOCATION
4 SPRAIN OR STRAIN
5 CUT, SCRAPE OR BRUISE
6 CONCUSSION (Go to KIN-Q5) (KIN-Q4=3 was filled during processing)
7 POISONING BY SUBSTANCE
OR LIQUID (Go to KIN-Q5) (KIN-Q4=11was filled during processing)
8 INTERNAL INJURY (Go to KIN-Q5) (KIN-Q4=11was filled during processing)
9 DENTAL INJURY (Go to KIN-Q5) (KIN-Q4=2 was filled during processing)
10 OTHER (SPECIFY)
11 MULTIPLE INJURIES (Go to KIN-Q5)
DK, R (Go to next section)
IJC4_3=2
IJC4_3=3
IJC4_3=4
IJC4_3=5
IJC4_3=6
IJC4_3=8
IJC4_3=9

IJC4_3=10
IJC4_3=11
IJC4_3=11
IJC4_3=1
HSC4_30

IJC4_1

IJC4_2

<!-- page 65 read_by="text_layer" -->

A-9
KIN-Q4 What part of %your/his/her% body was injured?
(DO NOT READ LIST. MARK ONE ONLY.)

1 EYES
2 FACE OR SCALP (EXCLUDING EYES)
3 HEAD OR NECK (EXCLUDING EYES AND FACE OR SCALP)
4 ARMS OR HANDS
5 LEGS OR FEET
6 BACK OR SPINE
7 TRUNK (EXCLUDING BACK OR SPINE) (INCLUDING CHEST, INTERNAL
ORGANS)
8 SHOULDER
9 HIP
9 MULTIPLE SITES
11 SYSTEMIC (CATEGORY CREATED DURING PROCESSING)
DK, R (Go to next section)

KIN-Q5 Where did the injury happen, for example, at home, on the street, in the playground or at school?
(DO NOT READ LIST. MARK ONE ONLY.)

1 INSIDE OWN HOME/APARTMENT
2 OUTSIDE HOME, APARTMENT, INCLUDING YARD, DRIVEWAY, PARKING LOT
OR IN SHARED AREAS RELATED TO HOME SUCH AS APARTMENT HALLWAY
OR LAUNDRY ROOM
3 IN OR AROUND OTHER PRIVATE RESIDENCE
4 INSIDE SCHOOL/DAYCARE CENTRE OR ON SCHOOL/CENTRE GROUNDS
5 AT AN INDOOR OR OUTDOOR SPORTS FACILITY (OTHER THAN SCHOOL)
6 OTHER BUILDING USED BY GENERAL PUBLIC
7 ON SIDEWALK/STREET/HIGHWAY IN NEIGHBOURHOOD
8 ON ANY OTHER SIDEWALK/STREET/HIGHWAY
9 IN A PLAYGROUND/PARK (OTHER THAN SCHOOL)
10 OTHER (SPECIFY)
DK, R (Go to next section)
IJC4_4=2
IJC4_4=3
IJC4_4=3
IJC4_4=6
IJC4_4=8
IJC4_4=9
IJC4_4=10

IJC4_4=5
IJC4_4=7
IJC4_4=1

IJC4_5=1
IJC4_5=1

IJC4_5=1
IJC4_5=5
IJC4_5=3
IJC4_5=5
IJC4_5=4
IJC4_5=4
IJC4_5=3
IJC4_5=9

<!-- page 66 read_by="text_layer" -->

A-10
KIN-Q6 What happened? For example, was the injury the result of a fall, a motor vehicle accident, a physical
assault, etc.?
(DO NOT READ LIST. MARK ONE ONLY.)

1 MOTOR VEHICLE COLLISION - PASSENGER
2 MOTOR VEHICLE COLLISION - PEDESTRIAN
3 MOTOR VEHICLE COLLISION - RIDING BICYCLE
4 OTHER BICYCLE ACCIDENT
5 FALL (EXCLUDING BICYCLE OR SPORTS)
6 SPORTS (EXCLUDING BICYCLE)
7 PHYSICAL ASSAULT
8 SCALDED BY HOT LIQUIDS OR FOOD
9 ACCIDENTAL POISONING
10 SELF-INFLICTED POISONING
11 OTHER INTENTIONALLY SELF-INFLICTED INJURIES
12 NATURAL/ENVIRONMENTAL FACTORS (EG. ANIMAL BITE, STING)
13 FIRE/FLAMES OR RESULTING FUMES
14 NEAR DROWNING
15 OTHER (SPECIFY)
IJC4_6=1
IJC4_6=1
IJC4_6=1
IJC4_6=15
IJC4_6=2
IJC4_6=15
IJC4_6=5
IJC4_6=11
IJC4_6=14
IJC4_6=14
IJC4_6=15
IJC4_6=8
IJC4_6=3
IJC4_6=9
IJC4_6=15
