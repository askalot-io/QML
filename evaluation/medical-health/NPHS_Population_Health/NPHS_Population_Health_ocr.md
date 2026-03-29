National Population Health Survey
    Content For Main Survey


          May 1, 1994
                                                                        Table of Contents
                                                                                                                                                                           Page

Household Record Variables......................................................................................................................................... 3
General Component (Form H05) .................................................................................................................................. 6
  Two-Week Disability ................................................................................................................................................ 6
  Health Care Utilization ............................................................................................................................................. 6
  Restriction of Activities ............................................................................................................................................ 9
  Chronic Conditions ................................................................................................................................................. 10
  Socio-demographic Characteristics ......................................................................................................................... 11
     Country of Birth/Year of Immigration ................................................................................................................ 12
     Ethnicity .............................................................................................................................................................. 12
     Language............................................................................................................................................................. 12
     Race .................................................................................................................................................................... 13
     Education ............................................................................................................................................................ 13
     Labour Force....................................................................................................................................................... 14
     Income................................................................................................................................................................. 18
  Administration......................................................................................................................................................... 19
Health Component for Respondents Aged 12 Years and Older (Form H06) .............................................................. 20
  General Health ........................................................................................................................................................ 20
  Height/Weight ......................................................................................................................................................... 20
  Preventive Health Practices..................................................................................................................................... 21
  Smoking .................................................................................................................................................................. 22
  Alcohol.................................................................................................................................................................... 23
  Physical Activities................................................................................................................................................... 24
  Injuries .................................................................................................................................................................... 26
  Stress ....................................................................................................................................................................... 28
     Ongoing Problems............................................................................................................................................... 28
     Recent Life Events .............................................................................................................................................. 31
     Childhood and adult stressors ............................................................................................................................. 32
  Work Stress............................................................................................................................................................. 33
  Self-Esteem and Mastery......................................................................................................................................... 33
  Sense of Coherence ................................................................................................................................................. 34
  Health Status ........................................................................................................................................................... 37
     Vision.................................................................................................................................................................. 37
     Hearing................................................................................................................................................................ 38
     Speech ................................................................................................................................................................. 39
     Getting Around.................................................................................................................................................... 39
     Hands and Fingers............................................................................................................................................... 40
     Feelings ............................................................................................................................................................... 41
     Memory............................................................................................................................................................... 41
     Thinking .............................................................................................................................................................. 41
     Pain and Discomfort............................................................................................................................................ 41
  Drug Use ................................................................................................................................................................. 42
  Mental Health.......................................................................................................................................................... 43
  Social Support......................................................................................................................................................... 49
  Health Number ........................................................................................................................................................ 50
  Agreement to Share................................................................................................................................................. 51
  Manitoba Buy-in Questions..................................................................................................................................... 52
  Alberta Buy-in Questions........................................................................................................................................ 55
Notes ........................................................................................................................................................................... 56
Appendix A: Health Component for Respondents Aged 0 to 11 Years Old (Form H06)..…………………………A-1
                                             Household Record Variables
                      (To be collected at initial contact from knowledgeable household member)

DEMO_INT          The next few questions will provide important basic information on the people in your household.

DEMO_Q1           What are the names of all persons now living or staying here who have no usual place of residence
                  elsewhere?
                  (First and last names )

DEMO_Q2           Are there any persons away from this household attending school, visiting, travelling or in hospital
DHC4_3A           who usually live here?

                  ___         Yes      (go to DEMO-Q1)
                  ___         No

DEMO_Q3           Does anyone else live at this dwelling such as young children, relatives, roomers, boarders or
DHC4_3B           employees?

                  ___         Yes      (go to DEMO-Q1)
                  ___         No

DEMO_Q4           What is ... 's date of birth?
DHC4_DAT          DD/MM/YY (Age is calculated and confirmed with respondent.)
DHC4_DOB
DHC4_MOB
DHC4_YOB
DHC4_AGE
DEMO_Q5           Enter or ask ... 's sex.
DHC4_SEX
                  ___         Male
                  ___         Female

DEMO_Q6           What is ... current marital status?
DHC4_MAR          (Note: if age < 15, marital status is automatically = single)

                  ___         Now married
                  ___         Common-law
                  ___         Living with a partner
                  ___         Single (never married)
                  ___         Widowed
                  ___         Separated
                  ___         Divorced

DEMO_Q7           Enter ... 's family Id code.
DHC4_FID          (A to Z)

Legal household check.

Reject household at this point if screening criteria are not met.

Selection criteria applied.




                                                           3
DEMO_Q8    Relationships of everyone to everyone else

           Birth Parent      Common law partner
           Step Parent       In-law
           Foster Parent     Other Related
           Birth Child       Unrelated
           Step Child        Husband/Wife
           Foster Child      Adopted Child
           Sister/brother    Adoptive Parent
           Grandparent       Same-sex Partner
           Grandchild

HHLD_Q1    Now a few questions about your dwelling. Is this dwelling owned by a member of this household
           (even if being paid for)?
DHC4_OWN
           ___      Yes
           ___      No

HHLD_Q3    How many bedrooms are there in this dwelling?
           (If no separate, enclosed bedroom enter "00".)
DHC4_BED
           ___      number of bedrooms (2 digits)

HHLD_Q4    Is there a pet in this household?
DH_4_P1
           ___      Yes
           ___      No       (Go to HHLD-Q6)

HHLD_Q5    What kind of pet?
DH_4DP2    (Do not read list. Mark all that apply)

           ___      Dog
           ___      Cat
           ___      Other    (Go to HHLD-Q6)

HHLD_Q5a   Does this pet or do any of these pets live mainly indoors?
DH 4 P3
           ___      Yes
           ___      No




                                                     4
HHLD_Q6    Record type of dwelling (by interviewer observation)
DHC4_DWE
           ___     Single detached house
           ___     Semi-detached or double (side-by-side)
           ___     Garden house, town-house or row house
           ___     Duplex (one above the other)
           ___     Low-rise apartment (less than 5 stories)
           ___     High-rise apartment (5 or more stories)
           ___     Institution
           ___     Hotel, rooming or lodging house, logging or construction camp, Hutterite Colony
           ___     Mobile home
           ___     Other (Specify _____________)

HHLD_Q7    Information Source Indicator i.e. who is providing the information
AM34_SRC
HHLD_Q8    Record language of interview
AM34_LNG
           English          Persian (Farsi)
           French           Polish
           Arabic           Portuguese
           Chinese          Punjabi
           Cree             Spanish
           German           Tagalog (Filipino)
           Greek            Ukrainian
           Hungarian        Vietnamese
           Italian          Other (Specify_________)
           Korean




                                                  5
                                         General Component (Form H05)
                                 (To be completed for all members of the household)

Note: In computer-assisted interviewing the options Don't Know (DK) and Refusal (R) are allowed on every
question.

H05-P1          Who is providing the information for this person's form?
                _______________________________
AM54_SRC
Two-Week Disability

TWOWK-INT       The first few questions ask about ...(r/'s) health during the past 14 days.

TWOWK-Q1        It is important for you to refer to the 14-day period1 from %2WKSAGO% to %YESTERDAY%.
                During that period, did ... stay in bed at all because of illness or injury including any nights spent
TWC4_1
                as a patient in a hospital?

                ___       Yes
                ___       No    (Go to TWOWK-Q3)
                          DK, R (Go to TWOWK-Q5)

TWOWK-Q2        How many days did ... stay in bed for all or most of the day?
TWC4_2
                ___       Days      (Enter <0> if less than a day.)
                                    (If = 14 days go to TWOWK-Q5)
                                    DK, R (Go to TWOWK-Q5)

TWOWK-Q3        (Not counting days spent in bed) During those 14 days, were there any days that ... cut down on
                things you/he/she normally do/does because of illness or injury?
TWC4_3
                ___       Yes
                ___       No    (Go to TWOWK-Q5)
                          DK, R (Go to TWOWK-Q5)

TWOWK-Q4        How many days did ... cut down on things for all or most of the day?
TWC4_4
                ___       Days
                          (Enter <0> if less than a day.)

TWOWK-Q5        Do(es) ... have a regular medical doctor?
TWC4_5          ___       Yes
                ___       No

Health Care Utilization

UTIL-CINT       If age<12, go to next section.

UTIL-INT        Now I'd like to ask about ...(r/'s) contacts with health professionals during the past 12 months2.




                                                            6
UTIL-Q1          In the past 12 months, have/has ... been a patient overnight in a hospital, nursing home or
HCC4_1           convalescent home?

                 ___      Yes
                 ___      No       (Go to UTIL-Q2)
                          DK       (Go to UTIL-Q2)
                          R        (Go to next section)

UTIL-Q1a         For how many nights in the past 12 months?
HCC4_1A
                 ___      nights

UTIL-Q2          (Not counting when ... were/was an overnight patient) In the past 12 months, how many times
                 have/has ... seen or talked on the telephone with [fill category] about your/his/her physical,
                 emotional or mental health:

HCC4_2A          a)       General practitioner or family physician
HCC4_2B          b)       Eye specialist (such as an ophthalmologist or optometrist)
HCC4_2C          c)       Other medical doctor (such as surgeon, allergist, gynaecologist, psychiatrist, etc.)
HCC4_2D          d)       A nurse for care or advice
HCC4_2E          e)       Dentist or orthodontist
HCC4_2F          f)       Chiropractor
HCC4_2G          g)       Physiotherapist
HCC4_2H          h)       Social worker or counsellor
HCC4_2I          i)       Psychologist
HCC4_2J          j)       Speech, audiology or occupational therapist

For each response >0 in a), c), or d), ask UTIL-Q3.

UTIL-Q3          Where did the most recent contact take place?
HCC4_3n                  (Read list. Mark one only.)

                 ___      Walk-in clinic
                 ___      Outpatient clinic in hospital
                 ___      Hospital emergency room
                 ___      Health professional's office
                 ___      Community health centre /CLSC
                 ___      At home
                 ___      Telephone consultation only
                 ___      Other (Specify_____________)

UTIL-Q4          People may also use alternative health care services. In the past 12 months, have/has ... seen or
HCC4_4           talked to an alternative health care provider such as an acupuncturist, naturopath, homeopath or
                 massage therapist about your/his/her physical, emotional or mental health?

                 ___      Yes
                 ___      No    (Go to UTIL-Q6)
                          DK, R (Go to UTIL-Q6)




                                                          7
UTIL-Q5    Who did ... see or talk to?
                  (Do not read list. Mark all that apply.)

HCC4_5A    ___      Massage therapist
HCC4_5B    ___      Acupuncturist
HCC4_5C    ___      Homeopath or naturopath
HCC4_5D    ___      Feldenkrais or Alexander teacher
HCC4_5E    ___      Relaxation therapist
HCC4_5F    ___      Biofeedback teacher
HCC4_5G    ___      Rolfer
HCC4_5H    ___      Herbalist
HCC4_5I    ___      Reflexologist
HCC4_5J    ___      Spiritual healer
HCC4_5K    ___      Religious healer
HCC4_4A    ___      Self help group (such as AA, cancer therapy, etc.)
HCC4_5L    ___      Other (Specify _____________________)

UTIL-Q6    During the past 12 months, was there ever a time when you/he/she needed health care or advice but
           did not receive it?
HCC4_6
           ___      Yes
           ___      No    (Go to UTIL-C9)
                    DK, R (Go to UTIL-C9)

UTIL-Q7    Thinking of the most recent time, why did ... not get care?
HCC4_7WC
and        ____________________________________
HCC4G7
           ___      Difficulty getting access to health professional
           ___      Financial constraints
           ___      Felt health care provided inadequate
           ___      Chose not to see health professional
           ___      Other

UTIL-Q8    Again, thinking of the most recent time, what was the type of care that was needed?
                    (Do not read list. Mark all that apply.)

HCC4_8A    ___      Treatment of a physical health problem
HCC4_8B    ___      Treatment of an emotional or mental health problem
HCC4_8C    ___      A regular check-up (or for regular pre-natal care)
HCC4_8D    ___      Care of an injury
HCC4_8E    ___      Any other reason (Specify______________)

UTIL-C9    IF age < 18 then go to next section.

UTIL-Q9    Home care services are health care or homemaker services received at home, with the cost being
HCC4_9     entirely or partially covered by government. Examples are: nursing care; help with bathing; help
           around the home; physiotherapy; counselling; and meal delivery. Have/Has ... received any home
           care services in the past 12 months?

           ___      Yes
           ___      No    (Go to next section)
                    DK, R (Go to next section)

UTIL-Q10   What type of services have/has ... received?


                                                   8
HCC4_SC          (Specify______________________)
and
HCC4_10A         ___        Nursing care
HCC4_10C         ___        Personal care
HCC4_10D         ___        Housework
HCC4_10E         ___        Meal preparation
HCC4_10F         ___        Shopping
HCC4_10H         ___        Other

Restriction of Activities

RESTR-CINT       If age<12, go to next section.

RESTR-INT        The next few questions deal with any health limitations which affect ... (r/'s) daily activities. In
                 these questions, "long-term conditions" refer to conditions that have lasted or are expected to last 6
                 months or more.

RESTR-Q1         Because of a long-term physical or mental condition or a health problem, are/is ... limited in the
                 kind or amount of activity you/he/she can do:

RAC4_1A          a)         at home?

                            ___        Yes
                            ___        No
                                       R       (Go to next section)

RAC4_1B          b)         at school?

                            ___        Yes
                            ___        No
                            ___        Not applicable
                                       R       (Go to next section)

RAC4_1C          c)         at work?

                            ___        Yes
                            ___        No
                            ___        Not applicable
                                       R       (Go to next section)

RAC4_1D          d)         in other activities such as transportation to or from work or leisure time activities?

                            ___        Yes
                            ___        No
                                       R       (Go to next section)

RESTR-Q2         Do(es) ... have any long term disabilities or handicaps?
RAC4_2
                            ___        Yes
                            ___        No
                                       R       (Go to next section)

If any yes in RESTR-Q1 (a)-(d), ask RESTR-Q3.
If yes in RESTR-Q2 only, ask RESTR-Q4.


                                                            9
Otherwise go to RESTR-Q6.

RESTR-Q3       What is the main condition or health problem causing ... to be limited in your/his/her activities?
RAC4_3C
               ___________________(25 spaces) (Go to RESTR-Q5)

RESTR-Q4       What is the main condition or health problem causing ... to have a long term disability or
               handicap?
RAC4_3C
               ___________________(25 spaces)

RESTR-Q5       Which one of the following is the best description of the cause of this condition?
RAC4_5                (Read list. Mark one only.)

               ___      Injury - at home
               ___      Injury - sports or recreation
               ___      Injury - motor vehicle
               ___      Injury - work-related
               ___      Existed at birth
               ___      Work environment
               ___      Disease or illness
               ___      Natural aging process
               ___      Psychological or physical abuse
               ___      Other (Specify____________________)

RESTR-Q6       The next question asks about help received. This may not apply to ... , but we need to ask the same
               question of everyone. Because of any condition or health problem, do(es) ... need the help of
               another person in:

                        (Read list. Mark all that apply.)

RAC4_6A        ___      Preparing meals?
RAC4_6B        ___      Shopping for groceries or other necessities?
RAC4_6C        ___      Doing normal everyday housework?
RAC4_6D        ___      Doing heavy household chores such as washing walls, yard work, etc.?
RAC4_6E        ___      Personal care such as washing, dressing or eating?
RAC4_6F        ___      Moving about inside the house?
RAC4_6G        ___      None of the above

Chronic Conditions

CHRON-CINT     If age<12 go to next section.

CHRON-INT      Now I'd like to ask about any chronic health conditions ... may have. Again, "long-term
               conditions" refer to conditions that have lasted or are expected to last 6 months or more.




                                                       10
CHRON-Q1          Do(es) ... have any of the following long-term conditions that have been diagnosed by a health
                  professional:
                           (Read list. Mark all that apply.)

CCC4_1A           (a)      Food allergies?
CCC4_1B           (b)      Other allergies?
CCC4_1C           (c)      Asthma?(If YES ask CHRON-Q1cc1)
CCC4_1D           (d)      Arthritis or rheumatism?
CCC4_1E           (e)      Back problems excluding arthritis?
CCC4_1F           (f)      High blood pressure?
CCC4_1G           (g)      Migraine headaches?
CCC4_1H           (h)      Chronic bronchitis or emphysema?
CCC4_1I           (i)      Sinusitis?
CCC4_1J           (j)      Diabetes?
CCC4_1K           (k)      Epilepsy?
CCC4_1L           (l)      Heart disease?
CCC4_1M           (m)      Cancer? (If yes ask CHRON-Q1mm)
CCC4_1N           (n)      Stomach or intestinal ulcers?
CCC4_1O           (o)      Effects of stroke?
CCC4_1P           (p)      Urinary incontinence?
CCC4_1W           (q)      Acne requiring prescription medication?    (Ask if age<30)

For persons aged < 18 years go to (u).

CCC4_1R           (r)      Alzheimer's disease or other dementia?
CCC4_1S           (s)      Cataracts?
CCC4_1T           (t)      Glaucoma?
CCC4_1V           (u)      Any other long term condition?     (Specify ______________)
CCC4_NON          (v)      None
                           DK, R (Go to next section)

CHRON-Q1mm What type(s) of cancer is this? For example, skin, lung or colon cancer.
CCC4_M1
                  __________________________

CHRON-Q1cc1 Have/Has ... had an attack of asthma in the past 12 months?
CCC4 C7
                  ___      Yes
                  ___      No

CHRON-Q1cc2 Have/Has ... had wheezing or whistling in the chest at any time in the past 12 months?
CCC4_C8
                  ___      Yes
                  ___      No

Socio-demographic Characteristics

SOCIO-INT         Now I'd like to ask some general background questions about the characteristics of people in your
                  household.




                                                        11
Country of Birth/Year of Immigration

SOCIO-Q1       In what country were/was ... born?
                        (Do not read list. Mark one only.)
SDC4_1
               ___      Canada (Go to next section)
               ___      China                    ___          Jamaica
               ___      France                   ___          Netherlands
               ___      Germany                  ___          Philippines
               ___      Greece                   ___          Poland
               ___      Guyana                   ___          Portugal
               ___      Hong Kong                ___          United Kingdom
               ___      Hungary                  ___          United States
               ___      India                    ___          Viet Nam
               ___      Italy                    ___          Other (Specify___)
                                                              DK, R (Go to SOCIO-Q4)

SOCIO-Q3       In what year did ... first immigrate to Canada?
SDC4_3
               ___      Year    (4 digits)
               (Enter <1999> if Canadian citizen by birth.)

Ethnicity

SOCIO-Q4       To which ethnic or cultural group(s) did your/his/her ancestors belong? (For example: French,
               British, Chinese, etc.)
                         (Do not read list. Mark all that apply.)

SDC4_4A        ___      Canadian              SDC4_4J         ___    Chinese
SDC4_4B        ___      French                SDC4_4K         ___    Jewish
SDC4_4C        ___      English               SDC4_4L         ___    Polish
SDC4_4D        ___      German                SDC4_4M         ___    Portuguese
SDC4_4E        ___      Scottish              SDC4_4N         ___    South Asian
SDC4_4F        ___      Irish                 SDC4_4O         ___    Black
SDC4_4G        ___      Italian               SDC4_4P         ___    North American Indian
SDC4_4H        ___      Ukrainian             SDC4_4Q         ___    Métis
SDC4_4I        ___      Dutch (Netherlands)   SDC4_4R         ___    Inuit/Eskimo
                                              SDC4_4S         ___    Other ethnic or cultural group(s)
                                                                      (Specify___)
Language

SOCIO-Q5       In which languages can ... conduct a conversation?
                       (Do not read list. Mark all that apply.)

SDC4_5A        ___      English               SDC4_5K         ___    Persian (Farsi)
SDC4_5B        ___      French                SDC4_5L         ___    Polish
SDC4_5C        ___      Arabic                SDC4_5M         ___    Portuguese
SDC4_5D        ___      Chinese               SDC4_5N         ___    Punjabi
SDC4_5E        ___      Cree                  SDC4_5O         ___    Spanish
SDC4_5F        ___      German                SDC4_5P         ___    Tagalog (Filipino)
SDC4_5G        ___      Greek                 SDC4_5Q         ___    Ukrainian
SDC4_5H        ___      Hungarian             SDC4_5R         ___    Vietnamese
SDC4_5I        ___      Italian               SDC4_5S         ___    Other (Specify______)
SDC4_5J        ___      Korean



                                                       12
SOCIO-Q6          What is the language that ... first learned at home in childhood and can still understand? (If ... can
                  no longer understand the first language learned, choose the second language learned.)
                           (Do not read list. Mark all that apply.)

SDC4_6A           ___      English                 SDC4_6K      ___       Persian (Farsi)
SDC4_6B           ___      French                  SDC4_6L      ___       Polish
SDC4_6C           ___      Arabic                  SDC4_6M      ___       Portuguese
SDC4_6D           ___      Chinese                 SDC4_6N      ___       Punjabi
SDC4_6E           ___      Cree                    SDC4_6O      ___       Spanish
SDC4_6F           ___      German                  SDC4_6P      ___       Tagalog (Filipino)
SDC4_6G           ___      Greek                   SDC4_6Q      ___       Ukrainian
SDC4_6H           ___      Hungarian               SDC4_6R      ___       Vietnamese
SDC4_6I           ___      Italian                 SDC4_6S      ___       Other (Specify______)
SDC4_6J           ___      Korean

Race

SOCIO-Q7          How would you best describe ...(r/'s) race or colour?
                        (Do not read list. Mark all that apply.)

SDC4_7A           ___      White (e.g. British, French, European, Latin/South American of European background)
SDC4_7D           ___      Black
SDC4_7K           ___      Korean
SDC4_7G           ___      Filipino
SDC4_7J           ___      Japanese
SDC4_7B           ___      Chinese
SDC4_7E           ___      Native/Aboriginal Peoples of North America
                           (North American Indian, Métis, Inuit/Eskimo)
SDC4_7C           ___      South Asian (e.g. Indian from India or Uganda, Pakistani, Punjabi, Tamil)
SDC4_7H           ___      South East Asian (e.g. Vietnamese, Thai, Laotian)
SDC4_7F           ___      West East Asian or North African (e.g. Armenian, Syrian, Moroccan)
SDC4_7L           ___      Other (Specify ____________)

Education

EDUC-C1           If age<12, go to next section.

EDUC-Q1           Excluding kindergarten, how many years of elementary and high school have/has ... successfully
EDC4_4            completed?
                          (Do not read list. Mark one only.)

                  ___      No schooling (Go to next section)
                  ___      One to five years         ___        Ten
                  ___      Six                       ___        Eleven
                  ___      Seven                     ___        Twelve
                  ___      Eight                     ___        Thirteen
                  ___      Nine                                 DK, R (Go to next section)

(If age < 15 then go to next section)

EDUC-Q2           Have/has ... graduated from high school?
EDC4_5
                  ___      Yes
                  ___      No



                                                          13
EDUC-Q3        Have/has ... ever attended any other kind of school such as university, community college, business
               school, trade or vocational school, CEGEP or other post-secondary institution?
EDC4_6
               ___      Yes
               ___      No    (Go to EDUC-C5)
                        DK, R (Go to next section)

EDUC-Q4        What is the highest level of education that ... have/has attained?
                        (Do not read list. Mark one only.)
EDC4_7
               ___      Some trade, technical, vocational school or business college
               ___      Some community college, CEGEP or nursing school
               ___      Some university
               ___      Diploma or certificate from trade, technical or vocational school, or business college
               ___      Diploma or certificate from community college, CEGEP, or nursing school)
               ___      Bachelor's or undergraduate degree or teacher's college (e.g., B.A., B.Sc., LL.B.)
               ___      Master's (e.g. M.A., M. Sc., M.Ed.)
               ___      Degree in medicine, dentistry, veterinary medicine or optometry (M.D., D.D.S., D.M.D.,
                        D.V.M., O.D.)
               ___      Earned doctorate (e.g. Ph.D., D.Sc., D.Ed.)
               ___      Other (Specify_____)

EDUC-C5        If age >= 65, go to next section.

EDUC-Q5        Are/Is ... currently attending a school, college or university?
EDC4_1
               ___      Yes
               ___      No    (Go to next section)
                        DK, R (Go to next section)

EDUC-Q6        Are/Is ... enrolled as a full-time or part-time student?
EDC4_2
               ___      full-time
               ___      part-time

Labour Force

LFS-C1         If age<15 go to next section.

LFS-Q1         What do/does ... consider to be your/his/her current main activity? (For example, working for pay,
               caring for family.)
LFC4_1                  (Do not read list. Mark one only.)

               ___      Caring for family
               ___      Working for pay or profit
               ___      Caring for family and working for pay or profit
               ___      Going to school
               ___      Recovering from illness/on disability
               ___      Looking for work
               ___      Retired
               ___      Other (Specify)

LFS-I2         The next section contains questions about jobs or employment which ... have/has had during the
               past 12 months2. Please include such employment as part-time jobs, contract work, baby sitting
               and any other paid work.


                                                        14
LFS-C2     If LFS-Q1 = 2 or 3 ---> go to LFS-Q3.1

LFS-Q2     Have/has you/he/she worked for pay or profit at any time in the past 12 months?
LFC4_2
           ___     Yes   (Go to LFS-Q3.1)
           ___     No
                   DK, R (Go to next section)

LFS-C2A    If LFS-Q1=7 (retired) ---> go to LFS-C18 else go to LFS-Q17B


Note:      Questions LFS-Q3 to LFS-Q11 are done as a roster allowing up to 6 jobs to be entered.

LFS-Q3.n   For whom/whom else have/has you/he/she worked for pay or profit in the past 12 months?
LFC4_EnC
           _____________________ (50 chars)

LFS-Q4.n   Did you/he/she have that job 1 year ago, that is, on %12MOSAGO% without a break in
LFC4_4n    employment since then?

           ___     Yes   (Go to LFS-Q6.n)
           ___     No
                   DK, R (Go to next section)

LFS-Q5.n   When did you/he/she start working at this job or business?
LFC4_5nM
LFC4_5nD   MM/DD/YY
LFC4 5nY   DK, R (Go to next section)

LFS-Q6.n   Do/Does you/he/she now have that job?
LFC4_6n
           ___     Yes   (Go to LFS-Q8.n)
           ___     No
                   DK, R (Go to next section)

LFS-Q7.n   When did you/he/she stop working at this job or business?
LFC4_7nM
LFC4_7nD   MM/DD/YY
LFC4_7nY   DK, R (Go to next section)

LFS-Q8.n   About how many hours per week do/does/did you/he/she usually work at this job?
LFC4_8n
           |_|_|   HOURS




                                                  15
LFS-Q9.n    Which of the following best describes the hours you/he/she usually work/works/worked at this job?
LFC4_9n             (Read list. Mark one only.)

            ___      Regular daytime schedule or shift
            ___      Regular evening shift
            ___      Regular night
            ___      Rotating shift (change from days to evenings to nights)
            ___      Split shift
            ___      On call
            ___      Irregular schedule
            ___      Other (Specify_______)

LFS-Q10.n   Do/Does/Did you/he/she usually work on weekends at this job?
LFC4_10n
            ___      Yes
            ___      No

LFS-Q11.n   Did you/he/she do any other work for pay or profit in the past 12 months?
LFC4_11n
            ___      Yes
            ___      No
                     DK, R    (Go to LFS-Q12)

LFS-C12     If LFS-Q11.1 = No go to LFS-Q13.

LFS-Q12     Which was the main job?
            (Answer will be chosen from roster of jobs.)
LFC4FMN
            (Definition of main job will be supplied in the interviewers manual.)

LFS-Q13     Thinking about this/the main job, what kind of business, service or industry is this? (For example,
LFC4_13C    wheat farm, trapping, road maintenance, retail shoe store, secondary school.)

            _____________________ (50 chars)

LFS-Q14     Again, thinking about this/the main job, what kind of work was/were ... doing? (For example,
LFC4_14C    medical lab technician, accounting clerk, secondary school teacher, supervisor of data entry unit,
            food processing labourer.)

            _____________________ (50 chars)

LFS-Q15     In this work, what were your/his/her most important duties or activities? (For example, analysis of
LFC4_15C    blood samples, verifying invoices, teaching mathematics, organizing work schedules, cleaning
            vegetables.)

            _____________________ (50 chars)

LFS-Q16     Did you/he/she work mainly for others for wages or commission or in your/his/her own business,
LFC4_16     farm or practice?
                     (Do not read list. Mark one only.)

            ___      For others for wages, salary or commission
            ___      In own business, farm or professional practice
            ___      Unpaid family worker




                                                   16
LFS-C17         Check the calendar for gaps > 6 days.
                If # gaps = 0 ---> go to LFS-C18

LFS-C17A        If any LFS-Q6 = 1 (currently employed) ---> go to LFS-Q17A
                Otherwise ---> go to LFS-Q17B

LFS-Q17A        What was the reason that ... were/was not working for pay or profit during the most recent period
LFC4_17A        away from work in the past year?
                        (Do not read list. Mark one only.)

                ___      Own illness or disability
                ___      Pregnancy
                ___      Caring for own children
                ___      Caring for elder relative(s)
                ___      Other personal or family responsibilities
                ___      School or educational leave
                ___      Labour dispute
                ___      Temporary layoff due to seasonal conditions
                ___      Temporary layoff - non-seasonal
                ___      Permanent layoff
                ___      Unpaid or partially paid vacation
                ___      Other (Specify________)
                ___      No period not working for pay or profit in the past year

GO TO LFS-C18

LFS-Q17B        What is the reason that ... are/is currently not working for pay or profit?
LFC4_17B                 (Do not read list. Mark one only.)

                ___      Own illness or disability
                ___      Pregnancy
                ___      Caring for own children
                ___      Caring for elder relative(s)
                ___      Other personal or family responsibilities
                ___      School or educational leave
                ___      Labour dispute
                ___      Temporary layoff due to seasonal conditions
                ___      Temporary layoff - non-seasonal
                ___      Permanent layoff
                ___      Unpaid or partially paid vacation
                ___      Other (Specify_______)
                ___      No period not working for pay or profit in the past year

LFS-C18         If LFS-Q1 = 2 or 3 or any one of LFS-Q6.1 to LFS-Q6.6 = 1 (currently working) then %LFS-
                WORK% =1;
                Otherwise %LFS-WORK% =0;




                                                         17
Income
(Ask from knowledgeable person only)

INCOM-Q1        Thinking about your total household income, from which of the following sources did your
                household receive any income in the past 12 months?
                        (Read list. Mark all that apply.)

INC4_1A         ___      Wages and salaries
INC4_1B         ___      Income from self-employment
INC4_1C         ___      Dividends and interest on bonds, deposits and savings, stocks, mutual funds, etc.
INC4_1D         ___      Unemployment insurance
INC4_1E         ___      Worker's compensation
INC4_1F         ___      Benefits from Canada or Quebec Pension Plan
INC4_1G         ___      Retirement pensions, superannuation and annuities
INC4_1H         ___      Old Age Security and Guaranteed Income Supplement
INC4_1I         ___      Child Tax Benefit
INC4_1J         ___      Provincial or municipal social assistance or welfare
INC4_1K         ___      Child Support
INC4_1L         ___      Alimony
INC4_1M         ___      Other Income (eg. rental income, scholarships, other government income, etc.)
INC4_1N         ___      None (Go to next section)
                         DK, R (Go to next section)

If more than one source of income is indicated ask INCOM-Q2.
Otherwise ask INCOM-Q3.


INCOM-Q2        What was the main source of income?
                       (Do not read list. Mark one only.)
INC4_2
                ___      Wages and salaries
                ___      Income from self-employment
                ___      Dividends and interest on bonds, deposits and savings, stocks, mutual funds, etc.
                ___      Unemployment insurance
                ___      Worker's compensation
                ___      Benefits from Canada or Quebec Pension Plan
                ___      Retirement pensions, superannuation and annuities
                ___      Old Age Security and Guaranteed Income Supplement
                ___      Child Tax Benefit
                ___      Provincial or Municipal Social Assistance or Welfare
                ___      Child Support
                ___      Alimony
                ___      Other Income (eg. rental income, scholarships, other government income, etc.)




                                                       18
INCOM-Q3         What is your best estimate of the total income before taxes and deductions of all household
                 members from all sources in the past 12 months? Was the total household income:

INC4_3A          ___     Less than $20,000?
INC4_3B                  ___      Less than $10,000?
INC4_3C                           ___      Less than $5,000?                   (go to next section)
INC4_3C                           ___      $5,000 and more?                    (go to next section)
INC4_3B                  ___      $10,000 and more?
INC4_3D                           ___      Less than $15,000?                  (go to next section)
INC4_3D                           ___      $15,000 and more?                   (go to next section)
INC4_3A          ___     $20,000 and more?
INC4_3E                  ___      Less than $40,000?
INC4_3F                           ___      Less than $30,000?                  (go to next section)
INC4_3F                           ___      $30,000 and more?                   (go to next section)
INC4_3E                  ___      $40,000 and more?
INC4_3G                           ___      Less than $50,000                   (go to next section)
INC4_3G                           ___      $50,000 to less than $60,000?       (go to next section)
INC4_3G                           ___      $60,000 to less than $80,000?       (go to next section)
INC4_3G                           ___      $80,000 and more?                   (go to next section)
INC4_3A          ___     No income
                         DK, R (Go to next section)

Administration

H05-P1           Was this interview conducted on the telephone or in person?
AM54_TEL
                 ___     On telephone
                 ___     In person
                 ___     Both (Specify in comments)

H05-P2           Record language of interview
AM54_LNG
                 English          Persian (Farsi)
                 French           Polish
                 Arabic           Portuguese
                 Chinese          Punjabi
                 Cree             Spanish
                 German           Tagalog (Filipino)
                 Greek            Ukrainian
                 Hungarian        Vietnamese
                 Italian          Other (Specify_______________)
                 Korean




                                                       19
                 Health Component for Respondents Aged 12 Years and Older (Form H06)
                         (To be completed for selected respondent only and age>=12)
                        (Proxy for those unable to answer due to special circumstances)

H06-P1           Who is providing the information for this person's form?
AM64_SRC         _______________________________

H06-INT          This part of the survey deals with various aspects of ... (r/'s) health. I'll be asking about such things
                 as physical activity, social relationships, health status and stress. By health, we mean not only the
                 absence of disease or injury but also physical, mental and social well-being. I'll start with a few
                 questions concerning ... (r/'s) health in general.

General Health

GENHLT-Q1        In general, would you say ... r/'s health is:
GHC4_1                    (Read list. Mark one only.)

                 ___      Excellent?
                 ___      Very good?
                 ___      Good?
                 ___      Fair?
                 ___      Poor?

GENHLT-C2        Check item: If sex = female & (age >= 15 & age <= 49) ask GENHLT-Q2. Otherwise go to next
                 section.

GENHLT-Q2        It is important to know when analyzing health whether or not the person is pregnant. Are/Is ...
HWC4_1           pregnant?

                 ___      Yes
                 ___      No    (Go to next section)
                          DK, R (Go to next section)

GENHLT-Q3        Are/Is you/she planning to use the services of a physician, midwife or both?
GHC4_3                    (Do not read list. Mark one only.)

                 ___      Physician only
                 ___      Midwife only
                 ___      Both physician and midwife
                 ___      Neither

Height/Weight

HTWT-Q1          How tall are/is ... without shoes on?
HWC4_2HT
                 ___      feet      ___       inches     OR      ___      centimetres

HTWT-Q2          How much do/does you/he/she weigh?
HWC4_3LB
HWC4_3KG         ___      pounds OR           ___        kilograms




                                                           20
Preventive Health Practices
(Non-proxy only)

PHP-Q1          When did you last have your blood pressure checked by a health professional?
BPC4_1                 (Do not read list. Mark one only.)

                ___     Less than 6 months ago
                ___     6 months to less than a year ago
                ___     1 year to less than 2 years ago
                ___     2 years to less than 5 years ago
                ___     5 years or more ago
                ___     Never
                        R         (Go to next section)

PHP-C2          If sex = female and age >= 35 then ask PHP-Q2.
                If sex = female and age >= 18 and age < 35 then ask PHP-Q3.
                If sex=male or females <= 17 then go to next section.

PHP-Q2          Have you ever had a mammogram, that is, a breast X-ray?
WHC4_30
                ___     Yes
                ___     No       (Go to PHP-Q3)
                        DK       (Go to PHP-Q3)
                        R        (Go to next section)

PHP-Q2a         When was the last time?
WHC4_32                (Do not read list. Mark one only.)

                ___     Less than 6 months ago
                ___     6 months to less than one year ago
                ___     1 year to less than 2 years ago
                ___     2 years or more ago

PHP-Q2b         Why did you have your last mammogram?
WHC4_33                 (Read list. Mark one only.)

                ___     Breast problem
                ___     Check-up, no particular problem
                ___     Other (specify_____________)

PHP-Q3          Have you ever had a PAP smear test?
WHC4_20
                ___     Yes
                ___     No    (Go to next section)
                        DK, R (Go to next section)




                                                        21
PHP-Q3a           When was the last time?
WHC4_22                  (Do not read list. Mark one only.)

                  ___      Less than 6 months ago
                  ___      6 months to less than one year ago
                  ___      1 year to less than 3 years ago
                  ___      3 years to less than 5 years ago
                  ___      5 years or more ago

Smoking

SMOK-INT          The next few questions are about smoking.

SMOK-Q1           Does anyone in this household smoke regularly inside the house?
SMC4_1
                  ___      Yes
                  ___      No

SMOK-Q2           At the present time do/does ... smoke cigarettes daily, occasionally or not at all?
SMC4_2
                  ___      Daily
                  ___      Occasionally       (Go to SMOK-Q5)
                  ___      Not at all         (Go to SMOK-Q4a)
                           DK, R              (Go to next section)

SMOK-Q3           At what age did you/he/she begin to smoke cigarettes daily?
SMC4_3
                  ___      Age

SMOK-Q4           How many cigarettes do/does you/he/she smoke each day now?
SMC4_4
                  ___      Number of cigarettes

         (Go to next section)

SMOK-Q4a          Have/has you/he/she ever smoked cigarettes at all?
SMC4_4A
                  ___      Yes
                  ___      No    (Go to next section)
                           DK, R (Go to next section)

SMOK-Q5           Have/has you/he/she ever smoked cigarettes daily?
SMC4_5
                  ___      Yes
                  ___
                           No    (Go to next section)
                           DK, R (Go to next section)

SMOK-Q6           At what age did you/he/she begin to smoke (cigarettes) daily?
SMC4_6
                  ___      Age




                                                          22
SMOK-Q7       How many cigarettes did you/he/she usually smoke each day?
SMC4_7
              ___      Number of cigarettes

SMOK-Q8       At what age did you/he/she stop smoking (cigarettes) daily?
SMC4_8
              ___      Age

Alcohol

ALCO-INT      Now, some questions about ... (r/'s) alcohol consumption. When we use the word drink it means:

              - one bottle or can of beer or a glass of draft
              - one glass of wine or a wine cooler
              - one straight or mixed drink with one and a half ounces of hard liquor.

ALCO-Q1       During the past 12 months2, have/has ... had a drink of beer, wine, liquor or any other alcoholic
ALC4_1        beverage?

              ___      Yes
              ___      No    (Go to ALCO-Q5B)
                       DK, R (Go to next section)

ALCO-Q2       During the past 12 months, how often did you/he/she drink alcoholic beverages?
                       (Do not read list. Mark one only.)
ALC4_2
              ___      Every day
              ___      4-6 times a week
              ___      2-3 times a week
              ___      Once a week
              ___      2-3 times a month
              ___      Once a month
              ___      Less than once a month

ALCO-Q3       How many times in the past 12 months have/has you/he/she had 5 or more drinks on one occasion?
ALC4_3
              ___      Number of times

If PROXY=yes then go to ALCO-Q5

ALCO-Q4       In the past 12 months, what is the highest number of drinks you had on one occasion?
ALC4_4
              ___      Number of drinks

ALCO-Q5       Thinking back over the past week, that is, from %1WKAGO% to yesterday, did ... have a drink of
ALC4_5        beer, wine, liquor or any other alcoholic beverage?

              ___      Yes
              ___      No    (Go to next section)
                       DK, R (Go to next section)




                                                     23
ALCO-Q5A          Starting with yesterday, how many drinks did ... have on:

ALC4_5A1          ___      Monday?                    R on first day    (Go to next section)
ALC4_5A2          ___      Tuesday?
ALC4_5A3          ___      Wednesday?
ALC4_5A4          ___      Thursday?
ALC4_5A5          ___      Friday?
ALC4_5A6          ___      Saturday?
ALC4_5A7          ___      Sunday?

         (Go to next section)

ALCO-Q5B          Did you/he/she ever have a drink?
ALC4_5B
                  ___      Yes
                  ___      No    (Go to next section)
                           DK, R (Go to next section)

ALCO-Q6           Did you/he/she ever regularly drink more than 12 drinks a week?
ALC4_6
                  ___      Yes
                  ___      No    (Go to next section)
                           DK, R (Go to next section)

ALCO-Q7           Why did you/he/she reduce or quit drinking altogether?
                          (Do not read list. Mark all that apply.)

ALC4_7A           ___      Dieting
ALC4_7B           ___      Athletic training
ALC4_7C           ___      Pregnancy
ALC4_7D           ___      Getting older
ALC4_7E           ___      Drinking too much/drinking problem
ALC4_7F           ___      Affected work, studies, employment opportunities
ALC4_7G           ___      Interfered with family or home life
ALC4_7H           ___      Affected physical health
ALC4_71           ___      Affected friendships or social relationships
ALC4_7J           ___      Affected financial position
ALC4_7K           ___      Affected outlook on life, happiness
ALC4_7L           ___      Because of influence of family or friends
ALC4_7M           ___      Other (specify______________)

Physical Activities
(Non-proxy only)

PHYS-INTa         Now I'd like to ask you about some of your physical activities. To begin with, I'll be dealing with
                  physical activities not related to work, that is, leisure time activities.




                                                         24
PHYS-Q1      Have you done any of the following in the past 3 months3?
                     (Read list. Mark all that apply.)

PAC4_1A      ___     Walking for exercise         PAC4_1M        ___      Cross-country skiing
PAC4_1B      ___     Gardening, yard work         PAC4_1N        ___      Bowling
PAC4_1C      ___     Swimming                     PAC4_1O        ___      Baseball/softball
PAC4_1D      ___     Bicycling                    PAC4_1P        ___      Tennis
PAC4_1E      ___     Popular or social dance      PAC4_1Q        ___      Weight-training
PAC4_1F      ___     Home exercises               PAC4_1R        ___      Fishing
PAC4_1G      ___     Ice hockey                   PAC4_1S        ___      Volleyball
PAC4_1H      ___     Skating                      PAC4_1Z        ___      Yoga or tai-chi
PAC4_1I      ___     Downhill skiing              PAC4_1U        ___      Other (specify)
PAC4_1J      ___     Jogging/running              PAC4_1W        ___      Other (specify)
PAC4_1K      ___     Golfing                      PAC4_1X        ___      Other (specify)
PAC4_1L      ___     Exercise class/aerobics           _
                                                  PAC4_1V        __       None
                                                                          DK, R (Go to next section)

      For each response ask PHYS-Q2 to PHYS-Q3.
      If "none" go to PHYS-INTb.

PHYS-Q2      In the past 3 months, how many times did you participate in %ACTIVITY%?
PAC4_2n
             ___     Number of times
                     DK, R (Go to next activity)

PHYS-Q3      About how much time did you usually spend on each occasion?
PAC4_3n              (Do not read list. Mark one only.)

             ___     1 to 15 minutes
             ___     16 to 30 minutes
             ___     31 to 60 minutes
             ___     More than one hour

PHYS-INTb    Next, some questions about the amount of time you spent in the past 3 months on physical activity
             at work or while doing daily chores around the house, but not leisure time activity.

PHYS-Q4a     In a typical week in the past 3 months, how many hours did you usually spend walking to work or
PAC4_4A      to school or while doing errands?
                      (Do not read list. Mark one only.)

             ___     None
             ___     Less than 1 hour
             ___     From 1 to 5 hours
             ___     From 6 to 10 hours
             ___     From 11 to 20 hours
             ___     More than 20 hours




                                                   25
PHYS-Q4b   In a typical week, how much time did you usually spend bicycling to work or to school or while
PAC4_4B    doing errands?
                    (Do not read list. Mark one only.)

           ___     None
           ___     Less than 1 hour
           ___     From 1 to 5 hours
           ___     From 6 to 10 hours
           ___     From 11 to 20 hours
           ___     More than 20 hours

PHYS-C1    If Bicycling was indicated as an activity in PHYS-Q1 or not a "none" in PHYS-Q4b, ask PHYS-
           Q5. Otherwise go to PHYS-Q6.

PHYS-Q5    When riding a bicycle how often did you wear a helmet?
PAC4_5             (Read list. Mark one only.)

           ___      Always
           ___      Most of the time
           ___      Rarely
           ___      Never

PHYS-Q6    Thinking back over the past 3 months, which of the following best describes your usual daily
PAC4_6     activities or work habits?
                     (Read list. Mark one only.)

           ___     Usually sit during day and do not walk about very much
           ___     Stand or walk about quite a lot during the day but do not have to carry or lift things very
                   often
           ___     Usually lift or carry light loads, or have to climb stairs or hills often
           ___     Do heavy work or carry very heavy loads

Injuries

INJ-INT    Now some questions about any injuries, which occurred in the past 12 months2, that were serious
           enough to limit ... (r/'s) normal activities. For example, a broken bone, a bad cut or burn, a sore
           back or sprained ankle, or a poisoning.

INJ-Q1     In the past 12 months, did ... have any injuries that were serious enough to limit your/his/her
IJC4_1     normal activities?

           ___      Yes
           ___      No    (Go to next section)
                    DK, R (Go to next section)

INJ-Q2     How many times were/was you/he/she injured?
IJC4_2
           ___      times
                    DK, R (Go to next section)




                                                  26
INJ-Q3   Thinking about the most serious injury, what type of injury did you/he/she have? For example, a
IJC4_3   broken bone or burn.
                 (Do not read list. Mark one only.)

         ___     Multiple injuries
         ___     Broken or fractured bones
         ___     Burn or scald
         ___     Dislocation
         ___     Sprain or strain
         ___     Cut or scrape
         ___     Bruise or abrasion
         ___     Concussion
         ___     Poisoning by substance or liquid
         ___     Internal injury
         ___     Other (specify________________)

INJ-Q4   What part of your/his/her body was injured?
IJC4_4           (Do not read list. Mark one only.)

         ___     Multiple sites
         ___     Eyes
         ___     Head (excluding eyes)
         ___     Neck
         ___     Shoulder
         ___     Arms or hands
         ___     Hip
         ___     Legs or feet
         ___     Back or spine
         ___     Trunk (excluding back or spine) (including chest, internal organs, etc.)

INJ-Q5   Where did the injury happen?
IJC4_5           (Do not read list. Mark one only.)

         ___     Home and surrounding area
         ___     Farm
         ___     Place for recreation or sport
                 (e.g. golf course, basketball court, playground (including school))
         ___     Street or highway
         ___     Building used by general public (e.g. hotel, shopping plaza, restaurant, office building,
                 school)
         ___     Residential institution (e.g. hospital, jail, etc.)
         ___     Mine
         ___     Industrial place or premise (e.g. dockyard)
         ___     Other (specify _______________)




                                               27
INJ-Q6          What happened? For example, was the injury the result of a fall, motor vehicle accident, a physical
IJC4_6          assault etc.?
                          (Do not read list. Mark one only.)

                ___      Motor vehicle accident
                ___      Accidental fall
                ___      Fire, flames or resulting fumes
                ___      Accidentally struck by an object/person
                ___      Physical assault
                ___      Suicide attempt
                ___      Accidental injury caused by explosion
                ___      Accidental injury caused by natural/environmental factors (e.g. weather conditions,
                         Poison ivy, animal bites, stings)
                ___      Accidental drowning or submersion
                ___      Accidental suffocation
                ___      Hot or corrosive liquids, foods or substances
                ___      Accident caused by machinery (e.g. farm machinery, forklift, woodworking machinery)
                ___      Accident caused by cutting and piercing instruments or objects (lawnmower, knife,
                         stapler)
                ___      Accidental poisoning
                ___      Other (specify__________________)

INJ-Q7          Was this a work-related injury?
IJC4_7
                ___      Yes
                ___      No

INJ-Q8          We would like to know what precautions ... are/is taking, if any, to prevent this kind of injury from
                happening again. What precautions are/is you/he/she taking?

                         (Do not read list. Mark all that apply.)

IJC4_8A         ___      Gave up the activity
IJC4_8B         ___      Being more careful
IJC4_8C         ___      Took safety training
IJC4_8H         ___      Increased supervision of child
IJC4_8D         ___      Using protective gear/safety equipment (e.g. bike helmet, car safety restraint, etc.)
IJC4_8E         ___      Changing physical situation (e.g. removing rugs, storing medications out of reach, safety
                         gates, etc.)
IJC4_8F         ___      Other (specify)
IJC4_8G         ___      No precautions

Stress
(Age >= 18 and non-proxy only)

                Ongoing Problems

STRESS-INT      The next portion of the questionnaire deals with different kinds of stress. Although the questions
                may seem repetitive, they are related to various aspects of a person's physical, emotional and
                mental health.




                                                        28
CSTRESS-INT      I'll start by describing situations that sometimes come up in people's lives. As there are no right or
                 wrong answers, the idea is to choose the answer best suited to your personal situation. I'd like you
                 to tell me if these things are true for you at this time by answering "true" if it applies to you now or
                 "false" if it does not.

CSTRESS-Q1       You are trying to take on too many things at once.
ST_4_C1
                 ___      True
                 ___      False
                          R        (Go to next section)

CSTRESS-Q2       There is too much pressure on you to be like other people.
ST_4_C2
                 ___      True
                 ___      False

CSTRESS-Q3       Too much is expected of you by others.
ST_4_C3
                 ___      True
                 ___      False

CSTRESS-Q4       You don't have enough money to buy the things you need.
ST_4_C4
                 ___      True
                 ___      False

If marital status =married or living with a partner or common-law go to CSTRESS-Q5.
If marital status=single,widowed, separated or divorced go to CSTRESS-Q8.
Otherwise (i.e. marital status is unknown) go to CSTRESS-Q9.

CSTRESS-Q5       Your partner doesn't understand you.
ST_4_C5
                 ___      True
                 ___      False

CSTRESS-Q6       Your partner doesn't show enough affection.
ST_4_C6
                 ___     True
                 ___     False
CSTRESS-Q7       Your partner is not committed enough to your relationship.
ST_4_C7
                 ___      True
                 ___      False

        Go to CSTRESS-Q9

CSTRESS-Q8       You find it is very difficult to find someone compatible with you.
ST_4_C8
                 ___      True
                 ___      False




                                                          29
CSTRESS-Q9       Do you have any children?
ST_4_C9
                 ___     Yes
                 ___     No    (Go to CSTRESS-Q12)
                         DK, R (Go to CSTRESS-Q12)

CSTRESS-Q10 Remember I want to know if you feel any of these statements are true for you at this time.
ST_4_C10    One of your children seems very unhappy.

                 ___     True
                 ___     False

CSTRESS-Q11 A child's behaviour is a source of serious concern to you.
ST_4_C11
                 ___     True
                 ___     False

CSTRESS-Q12 Your work around the home is not appreciated.
ST_4_C12
                 ___     True
                 ___     False

CSTRESS-Q13 Your friends are a bad influence.
ST_4_C13
                 ___     True
                 ___     False

CSTRESS-Q14 You would like to move but you cannot.
ST_4_C14
                 ___     True
                 ___     False

CSTRESS-Q15 Your neighbourhood or community is too noisy or too polluted.
ST_4_C15
                 ___     True
                 ___     False

CSTRESS-Q16 You have a parent, a child or partner who is in very bad health and may die.
ST_4_C16
                 ___     True
                 ___     False

CSTRESS-Q17 Someone in your family has an alcohol or drug problem.
ST_4_C17
                 ___     True
                 ___     False

CSTRESS-Q18 People are too critical of you or what you do.
ST_4_C18
                 ___     True
                 ___     False




                                                      30
        Recent Life Events

RECENT-INTa Now I'd like to ask you about some things that may have happened in the past 12 months2. Some of
            these experiences happen to most people at one time or another, while some happen to only a few.
            First, I'd like to ask about yourself or anyone close to you (that is, your spouse or partner, children,
            relatives or close friends).

RECENT-Q1        In the past 12 months, was any one of you beaten up or physically attacked?
ST_4_R1
                 ___      Yes
                 ___      No
                          R        (Go to next section)

RECENT-INTb Now I'd like you to think just about your family, (that is, yourself and your spouse/partner or
            children, if any).

RECENT-Q2        In the past 12 months, did you or someone in your family, have an unwanted pregnancy?
ST_4_R2
                 ___      Yes
                 ___      No

RECENT-Q3        In the past 12 months, did you or someone in your family have an abortion or miscarriage?
ST_4_R3
                 ___      Yes
                 ___      No

RECENT-Q4        In the past 12 months, did you or someone in your family have a major financial crisis?
ST_4_R4
                 ___      Yes
                 ___      No

RECENT-Q5        In the past 12 months, did you or someone in your family fail school or a training program?
ST_4_R5
                 ___      Yes
                 ___      No

RECENT-INTc Now I'd like you to think just about yourself and your spouse or partner.

If marital status = married/living together/common-law include the phrase "or your partner" in the RECENT-Q6 and
RECENT-Q7.

RECENT-Q6        In the past 12 months, did you (or your partner) experience a change of job for a worse one?
ST_4_R6
                 ___      Yes
                 ___      No

RECENT-Q7        In the past 12 months, were you (or your partner) demoted at work or did you/either of you take a
ST_4_R7          cut in pay?

                 ___      Yes
                 ___      No




                                                          31
If marital status = married/living together/common-law ask RECENT-Q8.
Otherwise go to RECENT-Q9.

RECENT-Q8       In the past 12 months, did you have increased arguments with your partner?
ST_4_R8
                ___      Yes
                ___      No

RECENT-Q9       Now, just you personally, in the past 12 months, did you go on Welfare?
ST_4_R9
                ___      Yes
                ___      No

        IF CSTRESS-Q9 = yes (have children) ask RECENT-Q10.
        Otherwise go to next section.

RECENT-Q10      In the past 12 months, did you have a child move back into the house?
ST_4_R10
                ___      Yes
                ___      No

        Childhood and Adult Stressors ("traumas")

TRAUM-INTa      The next few questions ask about some things that may have happened to you while you were a
                child or a teenager, before you moved out of the house. Please tell me if any of these things have
                happened.

TRAUM-Q1        Did you spend 2 weeks or more in the hospital?
ST_4_T1
                ___      Yes
                ___      No
                         R       (Go to next section)

TRAUM-Q2        Did your parents get a divorce?
ST_4_T2
                ___      Yes
                ___      No

TRAUM-Q3        Did your father or mother not have a job for a long time when they wanted to be working?
ST_4_T3
                ___      Yes
                ___      No

TRAUM-Q4        Did something happen that scared you so much you thought about it for years after?
ST_4_T4
                ___      Yes
                ___      No

TRAUM-Q5        Were you sent away from home because you did something wrong?
ST_4_T5
                ___      Yes
                ___      No




                                                        32
TRAUM-Q6         Did either of your parents drink or use drugs so often that it caused problems for the family?
ST_4_T6
                 ___      Yes
                 ___      No

TRAUM-Q7         Were you ever physically abused by someone close to you?
ST_4_T7
                 ___      Yes
                 ___      No

Work Stress
(Age >= 15 and non-proxy only)

Check item: ask only of those currently employed. If more than one job is held ask for the main job.

WSTRESS-Q1       Now I'm going to read you a series of statements that might describe your job situation. Please tell
                 me if you STRONGLY AGREE, AGREE, NEITHER AGREE NOR DISAGREE, DISAGREE, or
                 STRONGLY DISAGREE with each of the following:

ST_4_W1A         a)       Your job requires that you learn new things R on first item (Go to next section)
ST_4_W1B         b)       Your job requires a high level of skill
ST_4_W1C         c)       Your job allows you freedom to decide how you do your job
ST_4_W1D         d)       Your job requires that you do things over and over
ST_4_W1E         e)       Your job is very hectic
ST_4_W1F         f)       You are free from conflicting demands that others make
ST_4_W1G         g)       Your job security is good
ST_4_W1H         h)       Your job requires a lot of physical effort
ST_4_W1I         i)       You have a lot to say about what happens in your job
ST_4_W1J         j)       You are exposed to hostility or conflict from the people you work with
ST_4_W1K         k)       Your supervisor is helpful in getting the job done
ST_4_W1L         l)       The people you work with are helpful in getting the job done

WSTRESS-Q2       How satisfied are you with your job?
ST_4_W2                  (Read list. Mark one only.)

                 ___      Very satisfied
                 ___      Somewhat satisfied
                 ___      Not too satisfied
                 ___      Not at all satisfied

Self-Esteem and Mastery
(Age >= 12 and non-proxy only)

ESTMAST-INT Now, I am going to read you a series of statements that people might use to describe themselves.
            Please tell me if you STRONGLY AGREE, AGREE, NEITHER AGREE NOR DISAGREE,
            DISAGREE or STRONGLY DISAGREE with each of the following:




                                                         33
ESTEEM-Q1

PY_4_E1A        a)       You feel that you have a number of good qualities. R on first item       (Go to next section)
PY_4_E1B        b)       You feel that you're a person of worth at least equal to others.
PY_4_E1C        c)       You are able to do things as well as most other people.
PY_4_E1D        d)       You take a positive attitude toward yourself.
PY_4_E1E        e)       On the whole you are satisfied with yourself.
PY_4_E1F        f)       All in all, you're inclined to feel you're a failure.

(Age > 12 and non-proxy only)

MAST-Q1

PY_4_M1A        a)       You have little control over the things that happen to you R on first item(Go to next section)
PY_4_M1B        b)       There is really no way you can solve some of the problems you have.
PY_4_M1C        c)       There is little you can do to change many of the important things in your life.
PY_4_M1D        d)       You often feel helpless in dealing with problems of life.
PY_4_M1E        e)       Sometimes you feel that you are being pushed around in life.
PY_4_M1F        f)       What happens to you in the future mostly depends on you.
PY_4_M1G        g)       You can do just about anything you really set your mind to.

Sense of Coherence
(Age>=18 and non-proxy only.)

SCOH-INT        Next is a series of questions relating to various aspects of people's lives. For each question please
                answer with a number between 1 and 7. Take your time to think about each question before
                answering.

SCOH-Q1         In this first question 1 means very seldom or never and 7 means very often. How often do you have
                the feeling that you don't really care about what goes on around you?
PY_4_H1
                1        Very seldom or never
                2         &
                3         |
                4         |
                5         |
                6         '
                7        Very often
                         DK, R (Go to next section)

SCOH-Q2         In this question 1 that means it has never happened and 7 means it has always happened. How
                often in the past were you surprised by the behaviour of people whom you thought you knew well?
PY_4_H2
                1        Never happened
                2         &
                3         |
                4         |
                5         |
                6         '
                7        Always happened




                                                        34
SCOH-Q3   In this question 1 means that it has never happened and 7 means it has always happened. How
PY_4_H3   often have people you counted on disappointed you?

          1       Never happened
          2        &
          3        |
          4        |
          5        |
          6        '
          7       Always happened

SCOH-Q4   In this question 1 means very often and 7 means very seldom or never. How often do you have the
PY_4_H4   feeling you're being treated unfairly?

          1       Very often
          2        &
          3        |
          4        |
          5        |
          6        '
          7       Very seldom or never

SCOH-Q5   In this question 1 means very often and 7 means very seldom or never. How often do you have the
          feeling you are in an unfamiliar situation and don't know what to do?
PY_4_H5
          1       Very often
          2        &
          3        |
          4        |
          5        |
          6        '
          7       Very seldom or never

SCOH-Q6   In this question 1 means very often and 7 means very seldom or never. How often do you have
PY_4_H6   very mixed-up feelings and ideas?

          1       Very often
          2        &
          3        |
          4        |
          5        |
          6        '
          7       Very seldom or never




                                               35
SCOH-Q7    In this question 1 means very often and 7 means very seldom or never. how often do you have
PY_4_H7    feelings inside that you would rather not feel?

           1       Very often
           2        &
           3        |
           4        |
           5        |
           6        '
           7       Very seldom or never

SCOH-Q8    In this question 1 means very seldom or never and 7 means very often. Many people -- even those
PY_4_H8    with a strong character -- sometimes feel like sad sacks (losers) in certain situations. How often
           have you felt this way in the past?

           1       Very seldom or never
           2        &
           3        |
           4        |
           5        |
           6        '
           7       Very often

SCOH-Q9    In this question 1 means very often and 7 means very seldom or never. How often do you have the
PY_4_H9    feeling that there's little meaning in the things you do in your daily life?

           1       Very often
           2        &
           3        |
           4        |
           5        |
           6        '
           7       Very seldom or never

SCOH-Q10   In this question 1 means very often and 7 means very seldom or never. How often do you have
           feelings that you're not sure you can keep under control?
PY_4_H10
           1       Very often
           2        &
           3        |
           4        |
           5        |
           6        '
           7       Very seldom or never




                                                 36
SCOH-Q11          In this question 1 means no clear goals or purpose and 7 means very clear goals and purpose. Until
                  now your life has had no clear goals or purpose or has it had very clear goals and purpose?
PY_4_H11
                  1        No clear goals or no purpose at all
                  2         &
                  3         |
                  4         |
                  5         |
                  6         '
                  7        Very clear goals and purpose

SCOH-Q12          In this question 1 means you overestimate or underestimate importance and 7 means you see things
                  in the right proportion. When something happens, you generally find that you overestimate or
PY_4_H12
                  underestimate its importance or you see things in the right proportion?

                  1        Overestimate or underestimate its importance
                  2         &
                  3         |
                  4         |
                  5         |
                  6         '
                  7        See things in the right proportion

SCOH-Q13          In this question 1 means a source of great pleasure and satisfaction and 7 means a source of pain
PY_4_H13          and boredom. Is doing the things you do every day a source of great pleasure and satisfaction or a
                  source of pain and boredom?

                  1        A great deal of pleasure and satisfaction
                  2         &
                  3         |
                  4         |
                  5         |
                  6         '
                  7        A source of pain and boredom

Health Status

HSTAT-INT         The next set of questions ask about ... (r/'s) day to day health. The questions are not about illnesses
                  like colds that affect people for short periods of time. They are concerned with a person's usual
                  abilities. You may feel that some of these questions do not apply to you/him/her, but it is
                  important that we ask the same questions of everyone.

         Vision

HSTAT-Q1          Are/Is ... usually able to see well enough to read ordinary newsprint without glasses or contact
                  lenses?
HSC4_1
                  ___      Yes   (Go to HSTAT-Q4)
                  ___      No
                           DK, R (Go to HSTAT-Q6)




                                                          37
HSTAT-Q2           Are/Is you/he/she usually able to see well enough to read ordinary newsprint with glasses or
HSC4_2             contact lenses?

                   ___      Yes      (Go to HSTAT-Q4)
                   ___      No

HSTAT-Q3           Are/Is you/he/she able to see at all?
HSC4_3
                   ___      Yes
                   ___      No    (Go to HSTAT-Q6)
                            DK, R (Go to HSTAT-Q6)

HSTAT-Q4           Are/Is you/he/she able to see well enough to recognize a friend on the other side of the street
                   without glasses or contact lenses ?
HSC4_4
                   ___      Yes   (Go to HSTAT-Q6)
                   ___      No
                            DK, R (Go to HSTAT-Q6)

HSTAT-Q5           Are/Is you/he/she usually able to see well enough to recognize a friend on the other side of the
                   street with glasses or contact lenses?
HSC4_5
                   ___      Yes
                   ___      No

         Hearing

HSTAT-Q6           Are/Is ... usually able to hear what is said in a group conversation with at least three other people
                   without a hearing aid?
HSC4_6
                   ___      Yes   (Go to HSTAT-Q10)
                   ___      No
                            DK, R (Go to HSTAT-Q10)

HSTAT-Q7           Are/Is you/he/she usually able to hear what is said in a group conversation with at least three other
HSC4_7             people with a hearing aid?

                   ___      Yes      (Go to HSTAT-Q8)
                   ___      No

HSTAT-Q7a          Are/Is you/he/she able to hear at all?
HSC4_7A
                   ___      Yes
                   ___      No    (Go to HSTAT-Q10)
                            DK, R (Go to HSTAT-Q10)

HSTAT-Q8           Are/Is you/he/she usually able to hear what is said in a conversation with one other person in a
                   quiet room without a hearing aid ?
HSC4_8
                   ___      Yes      (Go to HSTAT-Q10)
                   ___      No
                            R        (Go to HSTAT-Q10)




                                                            38
HSTAT-Q9          Are/Is you/he/she usually able to hear what is said in a conversation with one other person in a
HSC4_9            quiet room with a hearing aid?

                  ___      Yes
                  ___      No

         Speech

HSTAT-Q10         Are/Is ... usually able to be understood completely when speaking with strangers in your own
                  language?
HSC4_10
                  ___      Yes      (Go to HSTAT-Q14)
                  ___      No
                           R        (Go to HSTAT-Q14)

HSTAT-Q11         Are/Is you/he/she able to be understood partially when speaking with strangers?
HSC4_11
                  ___      Yes
                  ___      No

HSTAT-Q12         Are/Is you/he/she able to be understood completely when speaking with those who know
HSC4_12           you/him/her well?

                  ___      Yes      (Go to HSTAT-Q14)
                  ___      No
                           R        (Go to HSTAT-Q14)

HSTAT-Q13         Are/Is you/he/she able to be understood partially when speaking with those who know you/him/her
HSC4 13           well?

                  ___      Yes
                  ___      No

         Getting Around

HSTAT-Q14         Are/Is ... usually able to walk around the neighbourhood without difficulty and without mechanical
HSC4_14           support such as braces, a cane or crutches?

                  ___      Yes   (Go to HSTAT-Q21)
                  ___      No
                           DK, R (Go to HSTAT-Q21)

HSTAT-Q15         Are/Is you/he/she able to walk at all?
HSC4_15
                  ___      Yes
                  ___      No    (Go to HSTAT-Q18
                           DK, R (Go to HSTAT-Q18)

HSTAT-Q16         Do/Does you/he/she require mechanical support such as braces, a cane or crutches to be able to
                  walk around the neighbourhood?
HSC4_16
                  ___      Yes
                  ___      No




                                                           39
HSTAT-Q17    Do/Does you/he/she require the help of another person to be able to walk?
HSC4_17
             ___      Yes
             ___      No

HSTAT-Q18    Do/Does you/he/she require a wheelchair to get around?
HSC4_18
             ___      Yes
             ___      No    (Go to HSTAT-Q21)
                      DK, R (Go to HSTAT-Q21)

HSTAT-Q19    How often do/does you/he/she use a wheelchair?
HSC4_19              (Read list. Mark one only.)

             ___      Always
             ___      Often
             ___      Sometimes
             ___      Never

HSTAT-Q20    Do/Does you/he/she need the help of another person to get around in the wheelchair?
HSC4_20
             ___      Yes
             ___      No

      Hands and Fingers

HSTAT-Q21    Are/Is ... usually able to grasp and handle small objects such as a pencil and scissors?
HSC4_21
             ___      Yes   (Go to HSTAT-Q25)
             ___      No
                      DK, R (Go to HSTAT-Q25)

HSTAT-Q22    Do/Does you/he/she require the help of another person because of limitations in the use of hands
HSC4_22      or fingers?

             ___      Yes
             ___      No    (Go to HSTAT-Q24)
                      DK, R (Go to HSTAT-Q24)

HSTAT-Q23    Do/Does you/he/she require the help of another person with:
                    (Read list. Mark one only.)
HSC4_23
             ___      Some tasks?
             ___      Most tasks?
             ___      Almost all tasks?
             ___      All tasks?

HSTAT-Q24    Do/Does you/he/she require special equipment, for example, devices to assist in dressing because
             of limitations in the use of hands or fingers?
HSC4_24
             ___      Yes
             ___      No




                                                     40
      Feelings

HSTAT-Q25        Would you describe yourself/... as being usually:
HSC4_25                 (Read list. Mark one only.)

                 ___      Happy and interested in life?
                 ___      Somewhat happy?
                 ___      Somewhat unhappy?
                 ___      Unhappy with little interest in life?
                 ___      So unhappy that life is not worthwhile?

      Memory

HSTAT-Q26        How would you describe your/his/her usual ability to remember things? Are/Is you/he/she:
                       (Read list. Mark one only.)
HSC4_26
                 ___      Able to remember most things?
                 ___      Somewhat forgetful?
                 ___      Very forgetful?
                 ___      Unable to remember anything at all?

      Thinking

HSTAT-Q27        How would you describe your/his/her usual ability to think and solve day to day problems? Are/Is
                 you/he/she:
HSC4_27
                          (Read list. Mark one only.)

                 ___      Able to think clearly and solve problems?
                 ___      Having a little difficulty?
                 ___      Having some difficulty?
                 ___      Having a great deal of difficulty?
                 ___      Unable to think or solve problems?

      Pain and Discomfort

HSTAT-Q28        Are/Is ... usually free of pain or discomfort?
HSC4_28
                 ___      Yes   (Go to next section)
                 ___      No
                          DK, R (Go to next section)

HSTAT-Q29        How would you describe the usual intensity of your/his/her pain or discomfort?
HSC4_29                (Read list. Mark one only.)

                 ___      Mild
                 ___      Moderate
                 ___      Severe




                                                          41
HSTAT-Q30   How many activities does your/his/her pain or discomfort prevent?
HSC4_30           (Read list. Mark one only.)

            ___      None
            ___      A few
            ___      Some
            ___      Most

Drug Use

DRUG-INT    Now I'd like to ask a few questions about ... (r/'s) use of medications, both prescription and over-
            the-counter as well as other health products.

DRUG-Q1     In the past month4, did ... take any of the following medications?
                     (Read list. Mark all that apply.)

DGC4_1A     ___      Pain relievers such as aspirin or tylenol (includes arthritis medicine and anti-
                     inflammatories)
DGC4_1B     ___      Tranquilizers such as valium
DGC4_1C     ___      Diet pills
DGC4_1D     ___      Anti-depressants
DGC4_1E     ___      Codeine, Demerol or Morphine
DGC4_1F     ___      Allergy medicine such as "Sinutab"
DGC4_1G     ___      Asthma medications
DGC4_1H     ___      Cough or cold remedies
DGC4_1I     ___      Penicillin or other antibiotic
DGC4_1J     ___      Medicine for the heart
DGC4_1K     ___      Medicine for blood pressure
DGC4_1L     ___      Diuretics or water pills
DGC4_1M     ___      Steroids
DGC4_1N     ___      Insulin
DGC4_1O     ___      Pills to control diabetes
DGC4_1P     ___      Sleeping pills
DGC4_1Q     ___      Stomach remedies
DGC4_1R     ___      Laxatives
DGC4_1T     ___      Hormones for menopause or aging symptoms (check item: sex=female, age >= 30)
DGC4_1S     ___      Birth control pills (check item: sex=female, age >= 12 & age <= 49)
DGC4_1V     ___      Any other medication (Specify_________)
DGC4_NON    ___      None of the above

DRUG-C1     If any drug(s) specified in DRUG-Q1 go to DRUG-Q2. Otherwise go to DRUG-Q4.

DRUG-Q2     Now, I am referring to yesterday and the day before yesterday. During those two days, how many
            different medications did you/he/she take?
DGC4_2
            ___      Number of different medications
                     DK, R (Go to DRUG-Q4)

            If number=0 then go to DRUG-Q4
            For each number >0 ask DRUG-Q3...up to a maximum of 12.




                                                    42
DRUG-Q3            What is the exact name of the medication that ... took? (Ask the person to look at the bottle, tube
DGC4_3nC           or box.)
                   ____________________________
                            DK, R to any medication (Go to next section)

DRUG-Q4            There are many other health products such as ointments, vitamins, herbs, minerals, teas or protein
                   drinks which people use to prevent illness or to improve or maintain their health. Do/Does ... use
DGC4_4             any of these or other health products?

                   ___      Yes
                   ___      No    (Go to next section)
                            DK, R (Go to next section)

DRUG-Q5            What is the exact name of the health product that ... use(s)? (Ask the person to look at the bottle,
DGC4_5nn           tube or box.) (up to 12 products)

                   ____________________________

Mental Health
(Non-proxy only)

MHLTH-INTa         Now some questions about mental and emotional well-being. During the past month4, about how
                   often did you feel:

MHLTH-Q1a          ... so sad that nothing could cheer you up?
MHC4_1A                       (Read list. Mark one only.)

                   ___      All of the time
                   ___      Most of the time
                   ___      Some of the time
                   ___      A little of the time
                   ___      None of the time
                            DK, R (Go to MHLTH-Q1k)

MHLTH-Q1b          ... nervous?
MHC4_1B                      (Read list. Mark one only.)

                   ___      All of the time
                   ___      Most of the time
                   ___      Some of the time
                   ___      A little of the time
                   ___      None of the time
                            DK, R (Go to MHLTH-Q1k)

MHLTH-Q1c          ... restless or fidgety?
MHC4_1C                       (Read list. Mark one only.)

                   ___      All of the time
                   ___      Most of the time
                   ___      Some of the time
                   ___      A little of the time
                   ___      None of the time
                            DK, R (Go to MHLTH-Q1k)




                                                            43
MHLTH-Q1d    ... hopeless?
MHC4_1D                (Read list. Mark one only.)

             ___      All of the time
             ___      Most of the time
             ___      Some of the time
             ___      A little of the time
             ___      None of the time
                      DK, R (Go to MHLTH-Q1k)

MHLTH-Q1e    ... worthless?
MHC4_1E                (Read list. Mark one only.)

             ___      All of the time
             ___      Most of the time
             ___      Some of the time
             ___      A little of the time
             ___      None of the time
                      DK, R (Go to MHLTH-Q1k)

MHLTH-Q1f    During the past month, about how often did you feel that everything was an effort?
                      (Read list. Mark one only.)
MHC4_1F
             ___      All of the time
             ___      Most of the time
             ___      Some of the time
             ___      A little of the time
             ___      None of the time
                      DK, R (Go to MHLTH-Q1k)

MHLTH-C1g    IF MHLTH-Q1a to MHLTH-Q1f are all "none" go to MHLTH-Q1k.

MHLTH-Q1g    We have just been talking about feelings and experiences that occurred to different degrees during
MHC4_1G      the past month. Taking them altogether, did these feelings occur more often in the past month than
             is usual for you, less often than usual , or about the same as usual?
                       (Do not read list. Mark one only.)

             ___      More often
             ___      Less often                 (Go to MHLTH-Q1i)
             ___      About the same             (Go to MHLTH-Q1j)
             ___      Never have had any         (Go to MHLTH-Q1k)
                      DK, R                      (Go to MHLTH-Q1k)

MHLTH-Q1h    Is that a lot more, somewhat or only a little more often than usual?
MHC4_1H                (Do not read list. Mark one only.)

             ___      A lot more
             ___      Somewhat more
             ___      A little more
                      DK, R (Go to MHLTH-Q1k)

     (Go to Q1j)




                                                     44
MHLTH-Q1i   Is that a lot less, somewhat or only a little less often than usual?
MHC4_1I               (Do not read list. Mark one only.)

            ___      A lot less
            ___      Somewhat less
            ___      A little less
                     DK, R (Go to MHLTH-Q1k)

MHLTH-Q1j   How much do these experiences usually interfere with your life or activities?
MHC4_1J           (Read list. Mark one only.)

            ___      A lot
            ___      Some
            ___      A little
            ___      Not at all

MHLTH-Q1k   In the past 12 months2, have you seen or talked on the telephone to a health professional about
            your emotional or mental health?
MHC4_1K
            ___      Yes
            ___      No    (Go to MHLTH-Q2.)
                     DK, R (Go to MHLTH-Q2)

MHLTH-Q1l   How many times (in the past 12 months)?
MHC4_1L
            ___      # of times

MHLTH-Q2    During the past 12 months, was there ever a time when you felt sad, blue, or depressed for 2 weeks
MHC4_2      or more in a row?

            ___      Yes
            ___      No    (Go to MHLTH-Q16.)
                     DK, R (Go to next section)

MHLTH-Q3    For the next few questions, please think of the 2-week period during the past 12 months when these
            feelings were worst. During that time how long did these feelings usually last?
MHC4_3
                     (Read list. Mark one only.)

            ___      All day long
            ___      Most of the day
            ___      About half of the day        (Go to MHLTH-Q16.)
            ___      Less than half the day       (Go to MHLTH-Q16.)
                     DK, R                        (Go to next section)

MHLTH-Q4    How often did you feel this way during those 2 weeks?
MHC4_4              (Read list. Mark one only.)

            ___      Every day
            ___      Almost every day
            ___      Less often       (Go to MHLTH-Q16.)
                     DK, R            (Go to next section)




                                                     45
MHLTH-Q5    During those 2 weeks did you lose interest in most things?
MHC4_5
            ___      Yes   (KEY PHRASE = LOSING INTEREST)
            ___      No
                     DK, R (Go to next section)

MHLTH-Q6    Did you feel tired out or low on energy all of the time?
MHC4_6
            ___      Yes   (KEY PHRASE = FEELING TIRED)
            ___      No
                     DK, R (Go to next section)

MHLTH-Q7    Did you gain weight, lose weight or stay about the same?
                    (Do not read list. Mark one only.)
MHC4_7
            ___      Gained weight (KEY PHRASE = GAINING WEIGHT)
            ___      Lost weight       (KEY PHRASE = LOSING WEIGHT)
            ___      Stayed about the same    (Go to MHLTH-Q9.)
            ___      Was on a diet            (Go to MHLTH-Q9.)
                     DK, R                    (Go to next section)

MHLTH-Q8    About how much did you (gain/lose)?
MHC4_8LB
MHC4_8KG    ___      pounds or kilograms

MHLTH-Q9    Did you have more trouble falling asleep than you usually do?
MHC4_9
            ___      Yes   (KEY PHRASE = TROUBLE FALLING ASLEEP)
            ___      No    (Go to MHLTH-Q11.)
                     DK, R (Go to next section)

MHLTH-Q10   How often did that happen?
                    (Read list. Mark one only.)
MHC4_10
            ___      Every night
            ___      Nearly every night
            ___      Less often
                     DK, R (Go to next section)

MHLTH-Q11   Did you have a lot more trouble concentrating than usual?
MHC4_11
            ___      Yes   (KEY PHRASE = TROUBLE CONCENTRATING)
            ___      No
                     DK, R (Go to next section)

MHLTH-Q12   At these times, people sometimes feel down on themselves, no good, or worthless. Did you feel
MHC4_12     this way?

            ___      Yes   (KEY PHRASE = FEELING DOWN ON YOURSELF)
            ___      No
                     DK, R (Go to next section)




                                                    46
MHLTH-Q13     Did you think a lot about death - either your own, someone else's, or death in general?
MHC4_13
              ___      Yes   (KEY PHRASE =THOUGHTS ABOUT DEATH)
              ___      No
                       DK, R (Go to next section)

MHLTH-C14     If any "yes" in Q5, Q6, Q9, Q11, Q12 or Q13, or Q7 is "gain" or "lose" then go to MHLTH-Q14.
              Otherwise go to next section.

MHLTH-Q14     Reviewing what you just told me, you had 2 weeks in a row during the past 12 months when you
MHC4_14       were sad, blue, or depressed and also had some other things like (KEY PHRASES). About how
              many weeks altogether did you feel this way during the past 12 months?

              ___      # of weeks (IF >51 weeks then go to next section.)
                       DK, R (Go to next section)

MHLTH-Q15     Think about the last time you felt this way for 2 weeks or more in a row. In what month was that?
MHC4_15
              ___      January           ___      July
              ___      February          ___      August
              ___      March             ___      September
              ___      April             ___      October
              ___      May               ___      November
              ___      June              ___      December

     Go to next section.

MHLTH-Q16     During the past 12 months, was there ever a time lasting 2 weeks or more when you lost interest in
MHC4_16       most things like hobbies, work, or activities that usually give you pleasure?

              ___      Yes
              ___      No    (Go to next section)
                       DK, R (Go to next section)

MHLTH-Q17     For the next few questions, please think of the 2-week period during the past 12 months when you
              had the most complete loss of interest in things. During that 2-week period, how long did the loss
MHC4_17
              of interest usually last?
                        (Read list. Mark one only.)

              ___      All day long
              ___      Most of the day
              ___      About half of the day      (Go to next section)
              ___      Less than half the day     (Go to next section)
                       DK, R                      (Go to next section)

MHLTH-Q18     How often did you feel this way during those 2 weeks?
MHC4_18               (Read list. Mark one only.)

              ___      Every day
              ___      Almost every day
              ___      Less often       (Go to next section)
                       DK, R            (Go to next section)




                                                     47
MHLTH-Q19   During those 2 weeks did you feel tired out or low on energy all the time?
MHC4_19
            ___      Yes   (KEY PHRASE = FEELING TIRED)
            ___      No
                     DK, R (Go to next section)

MHLTH-Q20   Did you gain weight, lose weight, or stay about the same?
                    (Do not read list. Mark one only.)
MHC4_20
            ___      Gained weight (KEY PHRASE = GAINING WEIGHT)
            ___      Lost weight       (KEY PHRASE = LOSING WEIGHT)
            ___      Stayed about the same    (Go to MHLTH-Q22)
            ___      Was on a diet            (Go to MHLTH-Q22)
                     DK, R                    (Go to next section)

MHLTH-Q21   About how much did you (gain/lose)?
MHC4_21L
MHC4_21K    ___      pounds or kilograms

MHLTH-Q22   Did you have more trouble falling asleep than you usually do?
MHC4_22
            ___      Yes   (KEY PHRASE = TROUBLE FALLING ASLEEP)
            ___      No    (Go to MHLTH-Q24)
                     DK, R (Go to next section)

MHLTH-Q23   How often did that happen during those 2 weeks?
MHC4_23             (Read list. Mark one only.)
            ___     Every night
            ___     Nearly every night
            ___     Less often
                    DK, R (Go to next section)

MHLTH-Q24   Did you have a lot more trouble concentrating than usual?
MHC4_24
            ___      Yes   (KEY PHRASE = TROUBLE CONCENTRATING)
            ___      No
                     DK, R (Go to next section)

MHLTH-Q25   At these times, people sometimes feel down on themselves, no good, or worthless. Did you feel
MHC4_25     this way?

            ___      Yes   (KEY PHRASE = FEELING DOWN ON YOURSELF)
            ___      No
                     DK, R (Go to next section)

MHLTH-Q26   Did you think a lot about death - either your own, someone else's, or death in general?
MHC4_26
            ___      Yes   (KEY PHRASE =THOUGHTS ABOUT DEATH)
            ___      No
                     DK, R (Go to next section)

MHLTH-C27   If any "yes" in Q19, Q22, Q24, Q25 or Q26, or Q20 is "gain" or "lose" then go to MHLTH-Q27.
            Otherwise go to next section.




                                                   48
MHLTH-Q27          Reviewing what you just told me, you had 2 weeks in a row during the past 12 months when you
MHC4_27            lost interest in most things and also had some other things like (KEY PHRASES). About how
                   many weeks did you feel this way during the past 12 months?

                   ___     # of weeks (IF >51 weeks then go to next section.)
                           DK, R (Go to next section)

MHLTH-Q28          Think about the last time you had 2 weeks in a row when you felt this way. In what month was
MHC4_28            that?

                   ___     January           ___          July
                   ___     February          ___          August
                   ___     March             ___          September
                   ___     April             ___          October
                   ___     May               ___          November
                   ___     June              ___          December

Social Support
(Non-proxy only)

SOCSUP-INT         Now, a few questions about your contact with different groups and support from family and
                   friends.

SOCSUP-Q1          Are you a member of any voluntary organizations or associations such as school groups, church
                   social groups, community centres, ethnic associations or social, civic or fraternal clubs?
SSC4_1
                   ___     Yes
                   ___     No    (Go to SOCSUP-Q2a)
                           DK, R (Go to SOCSUP-Q2a)

SOCSUP-Q2          How often did you participate in meetings or activities sponsored by these groups in the past 12
                   months? If you belong to many, just think of the ones in which you are most active.
SSC4_2                     (Read list. Mark one only.)

                   ___     At least once a week
                   ___     At least once a month
                   ___     At least 3 or 4 times a year
                   ___     At least once a year
                   ___     Not at all

SOCSUP-Q2a         Other than on special occasions (such as weddings, funerals or baptisms), how often did you attend
SSC4_2A            religious services or religious meetings in the past 12 months?
                            (Read list. Mark one only.)

                   ___     At least once a week
                   ___     At least once a month
                   ___     At least 3 or 4 times a year
                   ___     At least once a year
                   ___     Not at all

SOCSUP-Q3          Do you have someone you can confide in, or talk to about your private feelings or concerns?
SSC4_3
                   ___     Yes
                   ___     No




                                                            49
SOCSUP-Q4        Do you have someone you can really count on to help you out in a crisis situation?
SSC4_4
                 ___       Yes
                 ___       No

SOCSUP-Q5        Do you have someone you can really count on to give you advice when you are making important
SSC4_5           personal decisions?

                 ___       Yes
                 ___       No

SOCSUP-Q6        Do you have someone that makes you feel loved and cared for?
SSC4_6
                 ___       Yes
                 ___       No

SOCSUP-Q7        The next few questions are about your contact in the past 12 months with persons who do not live
                 with you either in person, by phone, or by mail. If you have more than one person in a category,
                 for example, several sisters, think of the one with whom you have the most contact. How often did
                 you have contact with [fill with categories below]?

SSC4_7A          ___       Your parents or parents-in-law
SSC4_7B          ___       Your grandparents
SSC4_7C          ___       Your daughters or daughters-in-law
SSC4_7D          ___       Your sons or sons-in-law
SSC4_7E          ___       Your brothers or sisters
SSC4_7F          ___       Other relatives (including in-laws)
SSC4_7G          ___       Your close friends
SSC4_7H          ___       Your neighbours

Choice of responses are:   (Read list. Mark one only.)

                           Don't have any
                           Every day
                           At least once a week
                           2 or 3 times a month
                           Once a month
                           A few times a year
                           Once a year
                           Never

Health Number

H06-HLTH#        We are seeking your permission to link information collected during this interview with provincial
AM64_LNK         health information. This would include information on past and continuing use of services such as
                 visits to hospitals, clinics, physician's offices or other services provided by the province. This
                 information will be used for statistical purposes only. Do we have your permission?

                 ___       Yes
                 ___       No    (Go to H06-SHARE)
                           DK, R (Go to next section)




                                                         50
H06-HLTH#l     Having a provincial health number will assist us in linking to this other information. What is ...r/s
HNC4_nn        provincial health number?

               ____________

Agreement to Share

H06-SHARE      To avoid duplication Statistics Canada intends to share the information from this survey with
AM64_SHA       provincial ministries of health, Health Canada, and Employment and Immigration Canada. These
               organizations have undertaken to keep this information confidential and use it only for statistical
               purposes. Do you agree to share the information you have provided?

               ___      Yes
               ___      No


H06-TEL        Was this interview conducted on the telephone or in person?
AM64_TEL
               ___      On telephone
               ___      In person
               ___      Both (Specify reason)

H06-CTEXT      Was the respondent alone when you asked this health questionnaire?
AM64_ALO
               ___      Yes      (Go to H06-P2)
               ___      No

H06-CTEXT1     Do you think that the answers of the respondent were affected by someone else being there?
AM64_AFF
               ___      Yes (Specify)
               ___      No

H06-P2         Record language of interview
AM64_LNG
               English           Persian (Farsi)
               French            Polish
               Arabic            Portuguese
               Chinese           Punjabi
               Cree              Spanish
               German            Tagalog (Filipino)
               Greek             Ukrainian
               Hungarian         Vietnamese
               Italian           Other (Specify_______________)
               Korean




                                                       51
Manitoba Buy-in Questions
(Age >= 18 and non-proxy only)

SPR6-INTA       The next questions are being asked for your provincial government. They deal with the day-to-
                days demands in your life.

SPR6-INTB       When relating to people, some people rely heavily on their thinking, rational side. Others rely
                much more on their emotional side. In the following questions, I will be asking about your primary
                style of relating to people. Please answer either "Yes" or "No" to each question. If you are not
                sure, it is usually best to respond with your first impression.

SPR6-Q1         Do you always try to do what is reasonable and logical?
RTP4_1
                ___      Yes
                ___      No

SPR6-Q2         Do you always try to understand people and their behaviour, to avoid responding emotionally?
RTP4_2
                ___      Yes
                ___      No

SPR6-Q3         When dealing with other people do you always try to act rationally?
RTP4_3
                ___      Yes
                ___      No

SPR6-Q4         Do you try to overcome all conflicts with other people by intelligence and reason, trying hard not
RTP4_4          to show your emotions?

                ___      Yes
                ___      No

SPR6-Q5         If someone deeply hurts your feelings, do you nevertheless try to treat him or her rationally and to
RTP4_5          understand his or her way of behaving?

                ___      Yes
                ___      No

SPR6-Q6         Do you succeed in avoiding most conflicts with other people by relying on your reason and logic,
RTP4_6          even if this is not how you feel at the time?

                ___      Yes
                ___      No




                                                       52
SPR6-Q7       If someone acts against your needs and desires, do you nevertheless try to understand that person?
RTP4_7
              ___      Yes
              ___      No

SPR6-Q8       Do you behave so rationally in most life situations that your behaviour is rarely influenced by only
RTP4_8        your emotions?

              ___      Yes
              ___      No

SPR6-Q9       Do your emotions frequently influence your behaviour to such a degree that your behaviour might
RTP4_9        be considered harmful to yourself and others?

              ___      Yes
              ___      No

SPR6-Q10      Do you try to understand others even if you don't like them?
RTP4_10
              ___      Yes
              ___      No

SPR6-Q11      Does your rationality prevent you from verbally attacking or criticizing others, even if there are
              sufficient reasons for doing so?
RTP4_11
              ___      Yes
              ___      No

SPR6-INTQ12   In the next few questions, you will be asked to imagine yourself in a particular situation. It is not
              important for you to have actually experienced the situation. Simply pretend you are in the
              described situation.

SPR6-Q12      Imagine you are afraid of the dentist and you have to get some dental work done. Which of the
              following things would you do to help you overcome your fears?
                       (Read list. Mark all that apply.)

              ___      Ask the dentist exactly what he is doing
RTP4_12A
              ___      Take a tranquilizer or have a drink before going
RTP4_12B
              ___      Try to think about other things, like pleasant memories
RTP4_12C
              ___      Have the dentist tell you when you would feel pain
RTP4_12D
              ___      Try to sleep
RTP4_12E
              ___      Watch all the dentist's movements and listen for the sound of the drill
RTP4_12F
              ___      Watch the flow of water from your mouth to see if it contained blood
RTP4_12G
              ___      Do mental puzzles in your mind
RTP4_12H
              ___      Other (Specify_______)
RTP4_12I




                                                      53
SPR6-Q13   Imagine that you are a salesperson and get along well with your fellow workers. It has been
           rumoured that, due to a large drop in sales, several people in your department will be laid off. The
           decision about lay-offs has been made and will be announced in several days. Which of the
           following would you do?

                    (Read list. Mark all that apply.)

RTP4_13A   ___      Talk to your fellow workers to see if they know anything about the supervisor's evaluation
                    of you
RTP4_13B   ___      Review the list of duties for your present job and try to figure out if you had
                    accomplished all of them
RTP4_13C   ___      Watch TV, go to the movies or do something like that, to take your mind off things
RTP4_13D   ___      Try to remember any arguments or disagreements you might have had with your
                    supervisor that might have lowered his or her opinion of you
RTP4_13E   ___      Push all thoughts of being laid off out of your mind
RTP4_13F   ___      If it came up during a conversation say that you would rather not discuss your chances of
                    being laid off
RTP4_13G   ___      Try to think which employees in your department the supervisor might evaluate more
                    poorly than you
RTP4_13H   ___      Continue doing your work as if nothing special was happening
RTP4_13I   ___      Other (Specify___)




                                                   54
Alberta Buy-in Questions
(Age >= 18 and non-proxy only)

SPR8-INT        The next questions are being asked for your provincial government. They deal with the day-to-
                days demands in your life.

SPR8-Q1         How would you rate your ability to handle the day-to-day demands in your life, for example, work,
                family and volunteer responsibilities?
COP4_1                   (Read list. Mark one only.)

                ___      Excellent
                ___      Very Good
                ___      Good
                ___      Fair
                ___      Poor

SPR8-Q2         If the day-to-day demands in your life were causing you to feel under stress, which of the following
                would you do?
                          (Read list. Mark all that apply.)

COP4_2A         ___      Try not to think about the situation and keep yourself busy to prevent thinking about it
COP4_2B         ___      Try to see the situation in a different light that makes it seem more bearable
COP4_2C         ___      Think about ways to change the situation or do something to solve the problem causing
                         the stress
COP4_2D         ___      Express your emotions to reduce your tension, anxiety or frustration
COP4_2E         ___      Admit to yourself that the situation is stressful, but otherwise do nothing
COP4_2F         ___      Talk about the situation with others
COP4_2G         ___      Do something you enjoy in order to relax
COP4_2H         ___      Pray or otherwise seek comfort or strength through religious faith
COP4_2I         ___      Do something else (Specify______)

SPR8-Q3         How would you rate your ability to handle unexpected and difficult problems, for example, family
COP4_3          or personal crisis?
                         (Read list. Mark one only.)

                ___      Excellent
                ___      Very Good
                ___      Good
                ___      Fair
                ___      Poor

SPR8-Q4         If an unexpected problem or situation was causing you to feel under stress, which of the following
                would you do?
                         (Read list. Mark all that apply.)

COP4_4A         ___      Try not to think about the situation and keep yourself busy to prevent thinking about it
COP4_4B         ___      Try to see the situation in a different light that makes it seem more bearable
COP4_4C         ___      Think about ways to change the situation or do something to solve the problem causing
                         the stress
COP4_4D         ___      Express your emotions to reduce your tension, anxiety or frustration
COP4_4E         ___      Admit to yourself that the situation is stressful, but otherwise do nothing
COP4_4F         ___      Talk about the situation with others
COP4_4G         ___      Do something you enjoy in order to relax
COP4_4H         ___      Pray or otherwise seek comfort or strength through religious faith
COP4_4I         ___      Do something else (Specify________)




                                                       55
Notes:

1.       Past 2 weeks refers to the 2 weeks leading up to the day before the interview e.g. if the day of the interview
         is September 10, 1993 then the past 2 weeks include August 27, 1993 to September 9, 1993.

2.       Past 12 months refers to the 12 months leading up to the day before the interview e.g. if the day of the
         interview is September 10, 1993 then the past 12 months include September 10, 1992 to September 9, 1993.

3.       Past 3 months refers to the 3 months leading up to the day before the interview e.g. if the day of the
         interview is September 10, 1993 then the past 3 months include June 10, 1993 to September 9, 1993.

4.       Past month refers to the month leading up to the day before the interview e.g. if the day of the interview is
         September 10, 1993 then the past month includes August 10, 1993 to September 9, 1993.




                                                          56
                                                                                                    APPENDIX A

                     Health Component for Respondents Aged 0 to 11 Years Old (Form H06)
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

Child General Health

KGH-Q1           In general, would you say %FNAME’s% health is:
GHC4_1           (READ LIST. MARK ONE ONLY.)

                 1         Excellent?
                 2         Very good?
                 3         Good?
                 4         Fair?
                 5         Poor?

KGH-Q3           Does %FNAME% have any long-term physical or mental condition or a health problem which
RAC4F1           prevents or limits %his/her% participation in school, at play, or in any other activity for a child
                 %his/her% age?

                 1         YES
                 2         NO

KGH-Q4           How tall is %he/she% without shoes on?
HWC4_HT
                 ------ FEET ----- INCHES        OR       ------- CENTIMETRES

KGH-Q5           How much does %he/she% weigh?

                 ____ (ENTER AMOUNT ONLY.)                    (MIN: 1) (MAX: 300)
                 DK, R (Go to next section)

KGH-C5INTERVIEWER: WAS THAT IN POUNDS OR IN KILOGRAMS?

                 1         POUNDS              HWC4_3LB
                 2         KILOGRAMS           HWC4_3KG




                                                        A-1
Child Health Care Utilization

KUT-INT         Now I’d like to ask about %FNAME’s% contacts with health professionals during the past 12
                months, that is, from %12MOSAGO% to yesterday.

KUT-Q1          In the past 12 months, has %FNAME% been an overnight patient in a hospital?
HCC4_1
                1        YES
                2        NO

KUT-Q3          (Not counting when %FNAME% was an overnight patient) In the past 12 months, how many times
                have you seen or talked on the telephone with a/an/any [fill category] about %his/her% physical,
                emotional or mental health? (Exclude at time of birth for babies.)

                                                                                MIN       MAX
HCC4_2A         a)       A general practitioner , family physician              0         366
HCC4_2A         b)       A pediatrician                                         0         366
HCC4_2C         c)       An other medical doctor (such as an orthopedist,       0         300
                         or eye specialist)
HCC4_2D         d)       A public health nurse or nurse practitioner            0         366
HCC4_2E         e)       A dentist or orthodontist                              0          99
HCC4_2I
                f)       A psychiatrist or psychologist                         0         366
HCC4_2H
HCK4_2OT
                g)       Child welfare worker or children’s aid worker          0         366
                h)       Any other person trained to provide treatment 0        366
                         or counsel, for example a speech therapist,
                         a social worker

Child Chronic Conditions

KCHR-C1         If age > 3, go to KCHR-Q4.

KCHR-Q1         Thinking now about illnesses, how often does %FNAME% have nose or throat infections?
CCK4_1          (READ LIST. MARK ONE ONLY.)

                1        Almost all the time
                2        Often
                3        From time to time
                4        Rarely
                5        Never

KCHR-Q2         Since %his/her% birth, has %he/she% ever had an ear infection (otitis)?
CCK4_2
                1        YES
                2        NO       (Go to KCHR-Q4)
                         DK, R    (Go to KCHR-Q4)




                                                       A-2
KCHR-Q3         How many times?
CCK4_3          (DO NOT READ LIST. MARK ONE ONLY.)

                1        ONCE
                2        2 TIMES
                3        3 TIMES
                4        4 OR MORE TIMES

KCHR-Q4         The following questions are about asthma. Has %FNAME% ever had asthma that has been diagnosed
CCC4_1C         by a health professional?

                1        YES
                2        NO        (Go to KCHR1-INT)
                         DK, R     (Go to KCHR1-INT)

KCHR-Q5         Has %he/she% had an attack of asthma in the past 12 months?
CCC4_C5
                1        YES
                2        NO

KCHR-Q6         Has %he/she% had wheezing or whistling in the chest at any time in the past 12 months?
CCC4_C6
                1        YES
                2        NO

KCHR1-INT       In the following questions long-term conditions refer to conditions that have lasted or are expected to
                last 6 months or more.

KCHR1-Q1        Does %FNAME% have any of the following long-term conditions that have been diagnosed by a
                health professional?

CCK4_1AB        a)       Allergies?
CCC4_1H         b)       Bronchitis?
CCC4_1L         c)       Heart condition or disease?
CCC4_1K         d)       Epilepsy?
CCC4_1V         e)       Cerebral palsy?
CCC4_1V         f)       Kidney condition or disease?
CCC4_1V         g)       Mental handicap?
CCC4_1V         h)       A learning disability?                                  (Ask only age>=6)
CCC4_1V         i)       An emotional, psychological or nervous condition?       (Ask only age>=6)
CCC4_1V         j)       Any other long-term condition?
CCC4_NON        k)       None

Child Health Status

KHS-C1          If age < 4, go to next section.

KHS-INT         The next set of questions asks about %you/FNAME%%r/s% day-to-day health. The questions are not
                about illnesses like colds that affect people for short periods of time. They are concerned about a
                person’s usual abilities.

KHS-INTA        You may feel that some of these questions do not apply to %you/him/her%, but it is important that we
                ask the same questions of everyone.



                                                        A-3
         Vision

KHS-Q1             Is %he/she% usually able to see clearly, and without distortion, the words in a book without glasses or
                   contact lenses?
HSC4_1
                   1        YES      (Go to KHS-Q4)
                   2        NO

KHS-Q2             Is %he/she% usually able to see clearly, and without distortion, the words in a book with glasses or
HSC4_2             contact lenses?

                   1        YES   (Go to KHS-Q4)
                   2        NO
                   3        DOESN’T WEAR GLASSES OR CONTACT LENSES

KHS-Q3             Is %he/she% able to see at all?
HSC4_3
                   1        YES
                   2        NO       (Go to KHS-Q6)

KHS-Q4             Is %he/she% able to see well enough to recognize a friend on the other side of the street without
HSC4_4             glasses or contact lenses?

                   1        YES      (Go to KHS-Q6)
                   2        NO

KHS-Q5             Is %he/she% usually able to see well enough to recognize a friend on the other side of the street with
HSC4_5             glasses or contact lenses?

                   1   YES
                   2   NO
                   3   DOESN’T WEAR GLASSES OR CONTACT LENSES

         Hearing

KHS-Q6             Is %he/she% usually able to hear what is said in a group conversation with at least 3 other people
                   without a hearing aid?
HSC4_6
                   1        YES      (Go to KHS-IN2)
                   2        NO

KHS-Q7             Is %he/she% usually able to hear what is said in a group conversation with at least 3 other people with
HSC4_7             a hearing aid?

                   1        YES   (Go to KHS-Q8)
                   2        NO
                   3        DOESN’T WEAR A HEARING AID




                                                           A-4
KHS-Q7A           Is %he/she% able to hear at all?
HSC4_7A
                  1        YES
                  2        NO       (Go to KHS-IN2)

KHS-Q8            Is %he/she% usually able to hear what is said in a conversation with one other person in a quiet room
HSC4_8            without a hearing aid?

                  1        YES      (Go to KHS-IN2)
                  2        NO

KHS-Q9            Is %he/she% usually able to hear what is said in a conversation with one other person in a quiet room
HSC4_9            with a hearing aid?

                  1        YES
                  2        NO
                  3        DOESN’T WEAR A HEARING AID

         Speech

KHS-IN2           The next few questions on day-to-day health are concerned with %FNAME%’s abilities relative to
                  other children the same age.

KHS-Q10           Is %he/she% usually able to be understood completely when speaking with strangers in %his/her%
HSC4_10           own language?

                  1        YES      (Go to KHS-Q14)
                  2        NO

KHS-Q11           Is %he/she% able to be understood partially when speaking with strangers in %his/her% own
HSC4_11           language?

                  1        YES
                  2        NO

KHS-Q12           Is %he/she% able to be understood completely when speaking with those who know %him/her%
HSC4_12           well?

                  1        YES      (Go to KHS-Q14)
                  2        NO

KHS-Q13           Is %he/she% able to be understood partially when speaking with those who know %him/her% well?
HSC4_13
                  1        YES
                  2        NO

         Getting Around

KHS-Q14           Is %FNAME% usually able to walk around the neighbourhood without difficulty and without
HSC4_14           mechanical support such as braces, a cane or crutches?

                  1        YES      (Go to KHS-Q21)
                  2        NO



                                                         A-5
KHS-Q15      Is %he/she% able to walk at all?
HSC4_15
             1        YES
             2        NO       (Go to KHS-Q18)

KHS-Q16      Does %he/she% require mechanical support such as braces, a cane or crutches to be able to walk?
HSC4_16
             1        YES
             2        NO

KHS-Q17      Does %he/she% require the help of another person to be able to walk?
HSC4_17
             1        YES
             2        NO

KHS-Q18      Does %he/she% require a wheelchair to get around?
HSC4_18
             1        YES
             2        NO       (Go to KHS-Q21)

KHS-Q19      How often does %he/she% use a wheelchair?
HSC4_19      (READ LIST. MARK ONE ONLY.)

             1        Always
             2        Often
             3        Sometimes
             4        Never

KHS-Q20      Does %he/she% need the help of another person to get around in the wheelchair?
HSC4_20
             1        YES
             2        NO

      Hands and Fingers

KHS-Q21      Is %FNAME% usually able to grasp and handle small objects such as a pencil or scissors?
HSC4_21
             1        YES      (Go to KHS-Q25)
             2        NO

KHS-Q22      Does %he/she% require the help of another person because of limitations in the use of hands or
HSC4_22      fingers?

             1        YES
             2        NO       (Go to KHS-Q24)

KHS-Q23      Does %he/she% require the help of another person with:
HSC4_23      (READ LIST. MARK ONE ONLY.)

             1        Some tasks?
             2        Most tasks?
             3        Almost all tasks?
             4        All tasks?



                                                   A-6
KHS-Q24          Does %he/she% require special equipment, for example, devices to assist in dressing because of
HSC4_24          limitations in the use of hands or fingers?

                 1       YES
                 2       NO

      Feelings

KHS-Q25          Would you describe %FNAME% as being usually:
HSC4_25          (READ LIST. MARK ONE ONLY.)

                 1       Happy and interested in life?
                 2       Somewhat happy?
                 3       Somewhat unhappy?
                 4       Unhappy with little interest in life?
                 5       So unhappy that life is not worthwhile?

      Memory

KHS-Q26          How would you describe %his/her% usual ability to remember things?
HSC4_26          (READ LIST. MARK ONE ONLY.)

                 1       Able to remember most things?
                 2       Somewhat forgetful?
                 3       Very forgetful?
                 4       Unable to remember anything at all?

      Thinking

KHS-Q27          How would you describe %his/her% usual ability to think and solve day-to-day problems?
HSC4_27          (READ LIST. MARK ONE ONLY.)

                 1       Able to think clearly and solve problems?
                 2       Having a little difficulty?
                 3       Having some difficulty?
                 4       Having a great deal of difficulty?
                 5       Unable to think or solve problems?

      Pain and Discomfort

KHS-Q28          Is %FNAME% usually free of pain or discomfort?
HSC4_28
                 1       YES      (Go to next section)
                 2       NO

KHS-Q29          How would you describe the usual intensity of %his/her% pain or discomfort?
HSC4_29          (READ LIST. MARK ONE ONLY.)

                 1       Mild
                 2       Moderate
                 3       Severe




                                                         A-7
KHS-Q30          How many activities does %his/her% pain or discomfort prevent?
HSC4_30          (READ LIST. MARK ONE ONLY.)

                 1        None
                 2        A few
                 3        Some
                 4        Most

Child Injuries

KIN-INT          The following questions refer to injuries, such as a broken bone, bad cut or burn, head injury,
                 poisoning, or a sprained ankle, which occurred in the past 12 months and were serious enough to
                 require medical attention by a doctor, nurse, or dentist.

KIN-Q1           In the past 12 months, was %FNAME% injured?
IJC4_1
                 1        YES
                 2        NO       (Go to next section)
                          DK, R    (Go to next section)

KIN-Q2           How many times was %he/she% injured?
IJC4_2           |_|_|  TIMES (MIN: 1) (MAX: 30)
                        DK, R (Go to next section)

KIN-Q3           (For the most serious injury,) what type of injury did %he/she% have?
                 (DO NOT READ LIST. MARK ONE ONLY.)

IJC4_3=2         1        BROKEN OR FRACTURED BONES
IJC4_3=3         2        BURN OR SCALD
IJC4_3=4         3        DISLOCATION
IJC4_3=5         4        SPRAIN OR STRAIN
IJC4_3=6         5        CUT, SCRAPE OR BRUISE
IJC4_3=8         6        CONCUSSION                 (Go to KIN-Q5) (KIN-Q4=3 was filled during processing)
IJC4_3=9         7        POISONING BY SUBSTANCE
                           OR LIQUID                 (Go to KIN-Q5) (KIN-Q4=11was filled during processing)
IJC4_3=10        8        INTERNAL INJURY            (Go to KIN-Q5) (KIN-Q4=11was filled during processing)
IJC4_3=11        9        DENTAL INJURY              (Go to KIN-Q5) (KIN-Q4=2 was filled during processing)
IJC4_3=11        10       OTHER (SPECIFY)
IJC4_3=1         11       MULTIPLE INJURIES                                 (Go to KIN-Q5)
                          DK, R (Go to next section)




                                                          A-8
KIN-Q4      What part of %your/his/her% body was injured?
            (DO NOT READ LIST. MARK ONE ONLY.)

IJC4_4=2    1        EYES
IJC4_4=3    2        FACE OR SCALP (EXCLUDING EYES)
IJC4_4=3    3        HEAD OR NECK (EXCLUDING EYES AND FACE OR SCALP)
IJC4_4=6    4        ARMS OR HANDS
IJC4_4=8    5        LEGS OR FEET
IJC4_4=9    6        BACK OR SPINE
IJC4_4=10   7        TRUNK (EXCLUDING BACK OR SPINE) (INCLUDING CHEST, INTERNAL
                     ORGANS)
IJC4_4=5    8        SHOULDER
IJC4_4=7    9        HIP
IJC4_4=1    9        MULTIPLE SITES
            11       SYSTEMIC (CATEGORY CREATED DURING PROCESSING)
                     DK, R (Go to next section)

KIN-Q5      Where did the injury happen, for example, at home, on the street, in the playground or at school?
            (DO NOT READ LIST. MARK ONE ONLY.)

IJC4_5=1    1        INSIDE OWN HOME/APARTMENT
IJC4_5=1    2        OUTSIDE HOME, APARTMENT, INCLUDING YARD, DRIVEWAY, PARKING LOT
                     OR IN SHARED AREAS RELATED TO HOME SUCH AS APARTMENT HALLWAY
                     OR LAUNDRY ROOM
IJC4_5=1    3        IN OR AROUND OTHER PRIVATE RESIDENCE
IJC4_5=5    4        INSIDE SCHOOL/DAYCARE CENTRE OR ON SCHOOL/CENTRE GROUNDS
IJC4_5=3    5        AT AN INDOOR OR OUTDOOR SPORTS FACILITY (OTHER THAN SCHOOL)
IJC4_5=5    6        OTHER BUILDING USED BY GENERAL PUBLIC
IJC4_5=4    7        ON SIDEWALK/STREET/HIGHWAY IN NEIGHBOURHOOD
IJC4_5=4    8        ON ANY OTHER SIDEWALK/STREET/HIGHWAY
IJC4_5=3    9        IN A PLAYGROUND/PARK (OTHER THAN SCHOOL)
IJC4_5=9    10       OTHER (SPECIFY)
                     DK, R (Go to next section)




                                                   A-9
KIN-Q6      What happened? For example, was the injury the result of a fall, a motor vehicle accident, a physical
            assault, etc.?
            (DO NOT READ LIST. MARK ONE ONLY.)

IJC4_6=1    1        MOTOR VEHICLE COLLISION - PASSENGER
IJC4_6=1    2        MOTOR VEHICLE COLLISION - PEDESTRIAN
IJC4_6=1    3        MOTOR VEHICLE COLLISION - RIDING BICYCLE
IJC4_6=15   4        OTHER BICYCLE ACCIDENT
IJC4_6=2    5        FALL (EXCLUDING BICYCLE OR SPORTS)
IJC4_6=15   6        SPORTS (EXCLUDING BICYCLE)
IJC4_6=5    7        PHYSICAL ASSAULT
IJC4_6=11   8        SCALDED BY HOT LIQUIDS OR FOOD
IJC4_6=14   9        ACCIDENTAL POISONING
IJC4_6=14   10       SELF-INFLICTED POISONING
IJC4_6=15   11       OTHER INTENTIONALLY SELF-INFLICTED INJURIES
IJC4_6=8    12       NATURAL/ENVIRONMENTAL FACTORS (EG. ANIMAL BITE, STING)
IJC4_6=3    13       FIRE/FLAMES OR RESULTING FUMES
IJC4_6=9    14       NEAR DROWNING
IJC4_6=15   15       OTHER (SPECIFY)




                                                  A-10
