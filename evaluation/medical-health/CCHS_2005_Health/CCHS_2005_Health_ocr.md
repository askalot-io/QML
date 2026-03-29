CANADIAN COMMUNITY HEALTH SURVEY


            CYCLE 3.1



        FINAL Questionnaire

            June 2005
TABLE OF CONTENTS

AGE OF SELECTED RESPONDENT (ANC) ............................................................................................... 1
GENERAL HEALTH (GEN)........................................................................................................................... 3
VOLUNTARY ORGANIZATIONS (ORG)...................................................................................................... 6
SLEEP (SLP) ................................................................................................................................................ 7
CHANGES MADE TO IMPROVE HEALTH (CIH) ........................................................................................ 9
HEALTH CARE SYSTEM SATISFACTION (HCS)..................................................................................... 12
HEIGHT and WEIGHT (HWT)..................................................................................................................... 14
CHRONIC CONDITIONS (CCC)................................................................................................................. 18
DIABETES CARE (DIA) .............................................................................................................................. 28
MEDICATION USE (MED).......................................................................................................................... 32
HEALTH CARE UTILIZATION (HCU)......................................................................................................... 37
HOME CARE SERVICES(HMC) ................................................................................................................ 46
PATIENT SATISFACTION (PAS) ............................................................................................................... 51
RESTRICTION OF ACTIVITIES (RAC) ...................................................................................................... 55
TWO-WEEK DISABILITY (TWD) ................................................................................................................ 60
FLU SHOTS (FLU)...................................................................................................................................... 63
BLOOD PRESSURE CHECK (BPC) .......................................................................................................... 65
PAP SMEAR TEST (PAP) .......................................................................................................................... 67
MAMMOGRAPHY (MAM) ........................................................................................................................... 69
BREAST EXAMINATIONS (BRX)............................................................................................................... 72
BREAST SELF-EXAMINATIONS (BSX)..................................................................................................... 74
EYE EXAMINATIONS (EYX) ...................................................................................................................... 75
PHYSICAL CHECK-UP (PCU).................................................................................................................... 77
PROSTATE CANCER SCREENING (PSA) ...............................................................................................79
COLORECTAL CANCER SCREENING (CCS) ..........................................................................................81
DENTAL VISITS (DEN)............................................................................................................................... 84
ORAL HEALTH 2 (OH2) ............................................................................................................................. 86
FOOD CHOICES (FDC).............................................................................................................................. 90
FRUIT AND VEGETABLE CONSUMPTION (FVC).................................................................................... 93
PHYSICAL ACTIVITY (PAC) ...................................................................................................................... 99
SEDENTARY ACTIVITIES (SAC)............................................................................................................. 102
USE OF PROTECTIVE EQUIPMENT (UPE) ...........................................................................................104
SUN SAFETY (SSB) ................................................................................................................................. 107
SMOKING (SMK) ...................................................................................................................................... 110
SMOKING - STAGES OF CHANGE (SCH)..............................................................................................115
NICOTINE DEPENDENCE (NDE)............................................................................................................ 116
SMOKING CESSATION AIDS (SCA) ....................................................................................................... 117
SMOKING - PHYSICIAN COUNSELLING (SPC)..................................................................................... 120
YOUTH SMOKING (YSM) ........................................................................................................................ 122
EXPOSURE TO SECOND-HAND SMOKE (ETS)....................................................................................124
ALCOHOL USE (ALC) ............................................................................................................................. 126
MATERNAL EXPERIENCES (MEX)......................................................................................................... 129
ILLICIT DRUGS (IDG)............................................................................................................................... 135
PROBLEM GAMBLING INDEX(CPG) ...................................................................................................... 144
SATISFACTION WITH LIFE (SWL).......................................................................................................... 154
STRESS - SOURCES (STS) .................................................................................................................... 156
STRESS - COPING (STC)........................................................................................................................ 158
CHILDHOOD AND ADULT STRESSORS (CST) ..................................................................................... 161
WORK STRESS (WST) ............................................................................................................................ 163
SELF-ESTEEM (SFE)............................................................................................................................... 166
SOCIAL SUPPORT - AVAILABILITY (SSA) ............................................................................................. 168
SOCIAL SUPPORT - UTILIZATION (SSU) .............................................................................................. 175
CONTACTS WITH MENTAL HEALTH PROFESSIONALS (CMH) .......................................................... 179
DISTRESS (DIS)....................................................................................................................................... 181

Statistics Canada                                                                                                                                          iii
Canadian Community Health Survey - Cycle 3.1

DEPRESSION (DPS)................................................................................................................................ 185
SUICIDAL THOUGHTS AND ATTEMPTS (SUI) ......................................................................................191
INJURIES (INJ) (REP) .............................................................................................................................. 193
HEALTH UTILITY INDEX (HUI) ................................................................................................................ 201
HEALTH STATUS – SF-36 (SFR) ........................................................................................................... 207
SEXUAL BEHAVIOURS (SXB)................................................................................................................. 216
ACCESS TO HEALTH CARE SERVICES (ACC).....................................................................................220
WAITING TIMES (WTM)........................................................................................................................... 231
MEASURED HEIGHT AND WEIGHT (MHW)...........................................................................................246
LABOUR FORCE (LBF)............................................................................................................................ 250
LABOUR FORCE – Common Portion (LF2) ............................................................................................ 264
SOCIO-DEMOGRAPHIC CHARACTERISTICS (SDC)............................................................................ 267
EDUCATION (EDU) .................................................................................................................................. 274
INSURANCE COVERAGE (INS) .............................................................................................................. 278
INCOME (INC) .......................................................................................................................................... 280
FOOD SECURITY (FSC) .......................................................................................................................... 285
DWELLING CHARACTERISTICS (DWL).................................................................................................290
ADMINISTRATION (ADM) ........................................................................................................................ 292




iv                                                                                                                             Statistics Canada
                                                        Canadian Community Health Survey - Cycle 3.1



AGE OF SELECTED RESPONDENT (ANC)
ANC_BEG

ANC_C01A      If (do ANC block = 1), go to ANC_R01.
              Otherwise, go to ANC_END.

ANC_R01       For some of the questions I’ll be asking, I need to know ^YOUR2 exact date of
              birth.
              INTERVIEWER: Press <Enter> to continue.

Date Block
ANC_Q01       INTERVIEWER: Enter the day.
              If necessary, ask (What is the day?)

              |_|_|
              (MIN: 1) (MAX: 31)
              DK, R

ANC_Q01       INTERVIEWER: Enter the month.
              If necessary, ask (What is the month?)

              1           January                  7       July
              2           February                 8       August
              3           March                    9       September
              4           April                    10      October
              5           May                      11      November
              6           June                     12      December
                          DK, R

ANC_Q01       INTERVIEWER: Enter a four-digit year.
              If necessary, ask (What is the year?)

              |_|_|_|_|
              DK, R

ANC_C02       Calculate age based on the entered date of birth.

ANC_Q02       So ^YOUR1 age is [calculated age].
              Is that correct?

              1           Yes                                    (Go to ANC_C03)
              2           No, return and correct date of birth   (Go to ANC_Q01)
              3           No, collect age                        (Go to ANC_Q03)
                          (DK, R are not allowed)

ANC_C03       If [calculated age] < 12 years go to ANC_R04.
              Otherwise go to ANC_END.




Statistics Canada                                                                                 1
Canadian Community Health Survey - Cycle 3.1

ANC_Q03      What is ^YOUR1 age?

             |_|_|_|         Age in years
             (MIN: 0) (MAX: 130)
             (DK, R are not allowed)

ANC_C04      If age < 12 years, go to ANC_R04.
             Otherwise, go to ANC_END.

ANC_R04      Because ^YOU1 ^ARE less than 12 years old, ^YOU1 ^ARE not eligible to
             participate in the Canadian Community Health Survey.
             INTERVIEWER: Press <Enter> to continue.

             NOTE: Auto code as 90 Unusual/Special circumstances and call the exit block.

ANC_END




2                                                                               Statistics Canada
                                                   Canadian Community Health Survey - Cycle 3.1



GENERAL HEALTH (GEN)
GEN_BEG

GEN_C01       If (do GEN = 1), go to GEN_R01.
              Otherwise, go to GEN_END.

GEN_R01       This survey deals with various aspects of ^YOUR2 health. I’ll be asking about such
              things as physical activity, social relationships and health status. By health, we
              mean not only the absence of disease or injury but also physical, mental and
              social well-being.
              INTERVIEWER: Press <Enter> to continue.

GEN_Q01       To start, in general, would you say ^YOUR1 health is:
GENE_01       INTERVIEWER: Read categories to respondent.

              1      … excellent?
              2      … very good?
              3      … good?
              4      … fair?
              5      … poor?
                     DK, R

GEN_Q02       Compared to one year ago, how would you say ^YOUR1 health is
GENE_02       now? Is it:
              INTERVIEWER: Read categories to respondent.

              1      … much better now than 1 year ago?
              2      … somewhat better now (than 1 year ago)?
              3      … about the same as 1 year ago?
              4      … somewhat worse now (than 1 year ago)?
              5      … much worse now (than 1 year ago)?
                     DK, R

GEN_C02A      If proxy interview, go to GEN_C07.
              Otherwise, go to GEN_Q02A.

GEN_Q02A      How satisfied are you with your life in general?
GENE_02A      INTERVIEWER: Read categories to respondent.

              1      Very satisfied
              2      Satisfied
              3      Neither satisfied nor dissatisfied
              4      Dissatisfied
              5      Very dissatisfied
                     DK, R




Statistics Canada                                                                              3
Canadian Community Health Survey - Cycle 3.1

GEN_Q02B     In general, would you say your mental health is:
GENE_02B     INTERVIEWER: Read categories to respondent.

             1      … excellent?
             2      … very good?
             3      … good?
             4      … fair?
             5      … poor?
                    DK, R

GEN_C07      If age < 15, go to GEN_C08A.
             Otherwise, go to GEN_Q07.

GEN_Q07      Thinking about the amount of stress in ^YOUR1 life, would you say
GENE_07      that most days are:
             INTERVIEWER: Read categories to respondent.

             1      … not at all stressful?
             2      … not very stressful?
             3      … a bit stressful?
             4      … quite a bit stressful?
             5      … extremely stressful?
                    DK, R

GEN_C08A     If proxy interview, go to GEN_END.
             Otherwise, go to GEN_C08B.

GEN_C08B     If age < 15 or age > 75, go to GEN_Q10.
             Otherwise, go to GEN_Q08.

GEN_Q08      Have you worked at a job or business at any time in the past 12 months?
GENE_08
             1      Yes
             2      No    (Go to GEN_Q10)
                    DK, R (Go to GEN_Q10)

GEN_Q09      The next question is about your main job or business in the past 12 months.
GENE_09      Would you say that most days at work were:
             INTERVIEWER: Read categories to respondent.

             1      … not at all stressful?
             2      … not very stressful?
             3      … a bit stressful?
             4      … quite a bit stressful?
             5      … extremely stressful?
                    DK, R




4                                                                            Statistics Canada
                                              Canadian Community Health Survey - Cycle 3.1

GEN_Q10       How would you describe your sense of belonging to your local community?
GENE_10       Would you say it is:
              INTERVIEWER: Read categories to respondent.

              1      … very strong?
              2      … somewhat strong?
              3      … somewhat weak?
              4      … very weak?
                     DK, R

GEN_END




Statistics Canada                                                                       5
Canadian Community Health Survey - Cycle 3.1



VOLUNTARY ORGANIZATIONS (ORG)
ORG_BEG

ORG_C1A      If (ORG block = 1), go to ORG_C1B.
ORGEFOPT     Otherwise, go to ORG_END.

ORG_C1B      If proxy interview, go to ORG_END.
             Otherwise, go to ORG_Q1.

ORG_Q1       Are you a member of any voluntary organizations or associations such as school
ORGE_1       groups, church social groups, community centres, ethnic associations or social,
             civic or fraternal clubs?

             1      Yes
             2      No    (Go to ORG_END)
                    DK, R (Go to ORG_END)

ORG_Q2       How often did you participate in meetings or activities of these groups in the past
ORGE_2       12 months? If you belong to many, just think of the ones in which you are most
             active.
             INTERVIEWER: Read categories to respondent.

             1      At least once a week
             2      At least once a month
             3      At least 3 or 4 times a year
             4      At least once a year
             5      Not at all
                    DK, R

ORG_END




6                                                                              Statistics Canada
                                                   Canadian Community Health Survey - Cycle 3.1



SLEEP (SLP)
SLP_BEG

SLP_C1        If (SLP block = 1), go to SLP_C2.
SLPEFOPT      Otherwise, go to SLP_END.

SLP_C2        If proxy interview, go to SLP_END.
              Otherwise, go to SLP_Q01.

SLP_Q01       Now a few questions about sleep.
SLPE_01
              How long do you usually spend sleeping each night?
              INTERVIEWER: Do not include time spent resting.

              1       Under 2 hours
              2       2 hours to less than 3 hours
              3       3 hours to less than 4 hours
              4       4 hours to less than 5 hours
              5       5 hours to less than 6 hours
              6       6 hours to less than 7 hours
              7       7 hours to less than 8 hours
              8       8 hours to less than 9 hours
              9       9 hours to less than 10 hours
              10      10 hours to less than 11 hours
              11      11 hours to less than 12 hours
              12      12 hours or more
                      DK
                      R       (Go to SLP_END)

SLP_Q02       How often do you have trouble going to sleep or staying asleep?
SLPE_02       INTERVIEWER: Read categories to respondent.

              1       None of the time
              2       A little of the time
              3       Some of the time
              4       Most of the time
              5       All of the time
                      DK, R

SLP_Q03       How often do you find your sleep refreshing?
SLPE_03
              1       None of the time
              2       A little of the time
              3       Some of the time
              4       Most of the time
              5       All of the time
                      DK, R




Statistics Canada                                                                            7
Canadian Community Health Survey - Cycle 3.1

SLP_Q04      How often do you find it difficult to stay awake when you want to?
SLPE_04
             1      None of the time
             2      A little of the time
             3      Some of the time
             4      Most of the time
             5      All of the time
                    DK, R

SLP_END




8                                                                             Statistics Canada
                                                    Canadian Community Health Survey - Cycle 3.1



CHANGES MADE TO IMPROVE HEALTH (CIH)
CIH_BEG

CIH_C1A       If (do CIH block = 1), go to CIH_C1B.
CIHEFOPT      Otherwise, go to CIH_END.

CIH_C1B       If proxy interview, go to CIH_END.
              Otherwise, go to CIH_Q1.

CIH_Q1        Next, some questions about changes made to improve health.
CIHE_1
              In the past 12 months, did you do anything to improve your health? (For example,
              lost weight, quit smoking, increased exercise)

              1       Yes
              2       No    (Go to CIH_Q3)
                      DK, R (Go to CIH_END)

CIH_Q2        What is the single most important change you have made?
CIHE_2
              1       Increased exercise, sports / physical activity
              2       Lost weight
              3       Changed diet / improved eating habits
              4       Quit smoking / reduced amount smoked
              5       Drank less alcohol
              6       Reduced stress level
              7       Received medical treatment
              8       Took vitamins
              9       Other – Specify
                      DK, R

CIH_C2S       If CIH_Q2 = 9, go to CIH_Q2S.
              Otherwise, go to CIH_Q3.

CIH_Q2S       INTERVIEWER: Specify.

              _________________________
              (80 spaces)
              DK, R

CIH_Q3        Do you think there is [anything else/anything] you should do to improve
CIHE_3        your physical health?

              1       Yes
              2       No    (Go to CIH_END)
                      DK, R (Go to CIH_END)

Note:         If CIH_Q1 = 1, use “anything else” in CIH_Q3. Otherwise, use “anything” in CIH_Q3.




Statistics Canada                                                                                  9
Canadian Community Health Survey - Cycle 3.1

CIH_Q4       What is the most important thing?
CIHE_4
             1      Start / Increase exercise, sports / physical activity
             2      Lose weight
             3      Change diet / improve eating habits
             4      Quit smoking / reduce amount smoked
             5      Drink less alcohol
             6      Reduce stress level
             7      Receive medical treatment
             8      Take vitamins
             9      Other – Specify
                    DK, R

CIH_C4S      If CIH_Q4 = 9, go to CIH_Q4S.
             Otherwise, go to CIH_Q5.

CIH_Q4S      INTERVIEWER: Specify.

             _________________________
             (80 spaces)
             DK, R

CIH_Q5       Is there anything stopping you from making this improvement?
CIHE_5
             1      Yes
             2      No    (Go to CIH_Q7)
                    DK, R (Go to CIH_Q7)

CIH_Q6       What is that?
             INTERVIEWER: Mark all that apply.

CIHE_6A      1      Lack of will power / self-discipline
CIHE_6I      2      Family responsibilities
CIHE_6B      3      Work schedule
CIHE_6J      4      Addiction to drugs / alcohol
CIHE_6K      5      Physical condition
CIHE_6G      6      Disability / health problem
CIHE_6F      7      Too stressed
CIHE_6E      8      Too costly / financial constraints
CIHE_6L      9      Not available - in area
CIHE_6M      10     Transportation problems
CIHE_6N      11     Weather problems
CIHE_6H      12     Other - Specify
                    DK, R

CIH_C6S      If CIH_Q6 = 12, go to CIH_Q6S.
             Otherwise, go to CIH_Q7.

CIH_Q6S      INTERVIEWER: Specify.

             _________________________
             (80 spaces)
             DK, R




10                                                                          Statistics Canada
                                                    Canadian Community Health Survey - Cycle 3.1

CIH_Q7        Is there anything you intend to do to improve your physical health in the
CIHE_7        next year?

              1      Yes
              2      No    (Go to CIH_END)
                     DK, R (Go to CIH_END)

CIH_Q8        What is that?
              INTERVIEWER : Mark all that apply.

CIHE_8A       1      Start / Increase exercise, sports / physical activity
CIHE_8B       2      Lose weight
CIHE_8C       3      Change diet / improve eating habits
CIHE_8J       4      Quit smoking / reduce amount smoked
CIHE_8K       5      Drink less alcohol
CIHE_8G       6      Reduce stress level
CIHE_8L       7      Receive medical treatment
CIHE_8H       8      Take vitamins
CIHE_8I       9      Other – Specify
                     DK, R

CIH_C8S       If CIH_Q8 = 9, go to CIH_Q8S.
              Otherwise, go to CIH_END.

CIH_Q8S       INTERVIEWER: Specify.

              _________________________
              (80 spaces)
              DK, R

CIH_END




Statistics Canada                                                                            11
Canadian Community Health Survey - Cycle 3.1



HEALTH CARE SYSTEM SATISFACTION (HCS)
HCS_BEG

HCS_C1A      If (do HCS block = 1), go to HCS_ C1B.
HCSEFOPT     Otherwise, go to HCS_END.

HCS_C1B      If proxy interview or if age < 15, go to HCS_END.
             Otherwise, go to HCS_C1C.

HCS_C1C      If province = 10, [province] = [Newfoundland and Labrador]
             If province = 11, [province] = [Prince Edward Island]
             If province = 12, [province] = [Nova Scotia]
             If province = 13, [province] = [New Brunswick]
             If province = 24, [province] = [Quebec]
             If province = 35, [province] = [Ontario]
             If province = 46, [province] = [Manitoba]
             If province = 47, [province] = [Saskatchewan]
             If province = 48, [province] = [Alberta]
             If province = 59, [province] = [British Columbia]
             If province = 60, [province] = [Yukon]
             If province = 61, [province] = [the Northwest Territories]
             If province = 62, [province] = [Nunavut]

HCS_Q1       Now, a few questions about health care services in [province].
HCSE_1       Overall, how would you rate the availability of health care services in [province]?
             Would you say it is:
             INTERVIEWER: Read categories to respondent.

             1       ... excellent?
             2       ... good?
             3       ... fair?
             4       ... poor?
                     DK, R (Go to HCS_END)

HCS_Q2       Overall, how would you rate the quality of the health care services that are
HCSE_2       available in [province]?
             INTERVIEWER: Read categories to respondent.

             1       Excellent
             2       Good
             3       Fair
             4       Poor
                     DK, R

HCS_Q3       Overall, how would you rate the availability of health care services in your
HCSE_3       community?

             1       Excellent
             2       Good
             3       Fair
             4       Poor
                     DK, R




12                                                                              Statistics Canada
                                                 Canadian Community Health Survey - Cycle 3.1

HCS_Q4        Overall, how would you rate the quality of the health care services that are
HCSE_4        available in your community?

              1      Excellent
              2      Good
              3      Fair
              4      Poor
                     DK, R

HCS_END




Statistics Canada                                                                            13
Canadian Community Health Survey - Cycle 3.1



HEIGHT and WEIGHT (HWT)
HWT_BEG

HWT_C1       If (do HWT block = 1), go to HWT_Q2.
             Otherwise, go to HWT_END.

HWT_Q2       The next questions are about height and weight.
HWTE_2
             How tall ^ARE ^YOU2 without shoes on?

             0       Less than 1’ / 12” (less than 29.2 cm.)
             1       1’0” to 1’11” / 12” to 23” (29.2 to 59.6 cm.)
             2       2’0” to 2’11” / 24” to 35” (59.7 to 90.1 cm.)
             3       3’0” to 3’11” / 36” to 47” (90.2 to 120.6 cm.)    (Go to HWT_N2C)
             4       4’0” to 4’11” / 48” to 59” (120.7 to 151.0 cm.)   (Go to HWT_N2D)
             5       5’0” to 5’11” (151.1 to 181.5 cm.)                (Go to HWT_N2E)
             6       6’0” to 6’11” (181.6 to 212.0 cm.)                (Go to HWT_N2F)
             7       7’0” and over (212.1 cm. and over)                (Go to HWT_Q3)
                     DK, R                                             (Go to HWT_Q3)

HWT_E2       The selected height is too short for a [current age] year old respondent. Please
             return and correct.

             Trigger hard edit if (HWT_Q2 < 3).

HWT_N2A      INTERVIEWER: Select the exact height.
HWTE_2A
             0       1’0” / 12” (29.2 to 31.7 cm.)
             1       1’1” / 13” (31.8 to 34.2 cm.)
             2       1’2” / 14” (34.3 to 36.7 cm.)
             3       1’3” / 15” (36.8 to 39.3 cm.)
             4       1’4” / 16” (39.4 to 41.8 cm.)
             5       1’5” / 17” (41.9 to 44.4 cm.)
             6       1’6” / 18” (44.5 to 46.9 cm.)
             7       1’7” / 19” (47.0 to 49.4 cm.)
             8       1’8” / 20” (49.5 to 52.0 cm.)
             9       1’9” / 21” (52.1 to 54.5 cm.)
             10      1’10” / 22” (54.6 to 57.1 cm.)
             11      1’11” / 23” (57.2 to 59.6 cm.)
                     DK, R




14                                                                               Statistics Canada
                                                      Canadian Community Health Survey - Cycle 3.1

HWT_N2B       INTERVIEWER: Select the exact height.
HWTE_2B
              0      2’0” / 24” (59.7 to 62.1 cm.)
              1      2’1” / 25” (62.2 to 64.7 cm.)
              2      2’2” / 26” (64.8 to 67.2 cm.)
              3      2’3” / 27” (67.3 to 69.8 cm.)
              4      2’4” / 28” (69.9 to 72.3 cm.)
              5      2’5” / 29” (72.4 to 74.8 cm.)
              6      2’6” / 30” (74.9 to 77.4 cm.)
              7      2’7” / 31” (77.5 to 79.9 cm.)
              8      2’8” / 32” (80.0 to 82.5 cm.)
              9      2’9” / 33” (82.6 to 85.0 cm.)
              10     2’10” / 34” (85.1 to 87.5 cm.)
              11     2’11” / 35” (87.6 to 90.1 cm.)
                     DK, R

HWT_N2C       INTERVIEWER: Select the exact height.
HWTE_2C
              0      3’0” / 36” (90.2 to 92.6 cm.)
              1      3’1” / 37” (92.7 to 95.2 cm.)
              2      3’2” / 38” (95.3 to 97.7 cm.)
              3      3’3” / 39” (97.8 to 100.2 cm.)
              4      3’4” / 40” (100.3 to 102.8 cm.)
              5      3’5” / 41” (102.9 to 105.3 cm.)
              6      3’6” / 42” (105.4 to 107.9 cm.)
              7      3’7” / 43” (108.0 to 110.4 cm.)
              8      3’8” / 44” (110.5 to 112.9 cm.)
              9      3’9” / 45” (113.0 to 115.5 cm.)
              10     3’10” / 46” (115.6 to 118.0 cm.)
              11     3’11” / 47” (118.1 to 120.6 cm.)
                     DK, R

              Go to HWT_Q3

HWT_N2D       INTERVIEWER: Select the exact height.
HWTE_2D
              0      4’0” / 48” (120.7 to 123.1 cm.)
              1      4’1” / 49” (123.2 to 125.6 cm.)
              2      4’2” / 50” (125.7 to 128.2 cm.)
              3      4’3” / 51” (128.3 to 130.7 cm.)
              4      4’4” / 52” (130.8 to 133.3 cm.)
              5      4’5” / 53” (133.4 to 135.8 cm.)
              6      4’6” / 54” (135.9 to 138.3 cm.)
              7      4’7” / 55” (138.4 to 140.9 cm.)
              8      4’8” / 56” (141.0 to 143.4 cm.)
              9      4’9” / 57” (143.5 to 146.0 cm.)
              10     4’10” / 58” (146.1 to 148.5 cm.)
              11     4’11” / 59” (148.6 to 151.0 cm.)
                     DK, R

              Go to HWT_Q3




Statistics Canada                                                                              15
Canadian Community Health Survey - Cycle 3.1

HWT_N2E      INTERVIEWER: Select the exact height.
HWTE_2E
             0       5’0” (151.1 to 153.6 cm.)
             1       5’1” (153.7 to 156.1 cm.)
             2       5’2” (156.2 to 158.7 cm.)
             3       5’3” (158.8 to 161.2 cm.)
             4       5’4” (161.3 to 163.7 cm.)
             5       5’5” (163.8 to 166.3 cm.)
             6       5’6” (166.4 to 168.8 cm.)
             7       5’7” (168.9 to 171.4 cm.)
             8       5’8” (171.5 to 173.9 cm.)
             9       5’9” (174.0 to 176.4 cm.)
             10      5’10” (176.5 to 179.0 cm.)
             11      5’11” (179.1 to 181.5 cm.)
                     DK, R

             Go to HWT_Q3

HWT_N2F      INTERVIEWER: Select the exact height.
HWTE_2F
             0       6’0” (181.6 to 184.1 cm.)
             1       6’1” (184.2 to 186.6 cm.)
             2       6’2” (186.7 to 189.1 cm.)
             3       6’3” (189.2 to 191.7 cm.)
             4       6’4” (191.8 to 194.2 cm.)
             5       6’5” (194.3 to 196.8 cm.)
             6       6’6” (196.9 to 199.3 cm.)
             7       6’7” (199.4 to 201.8 cm.)
             8       6’8” (201.9 to 204.4 cm.)
             9       6’9” (204.5 to 206.9 cm.)
             10      6’10” (207.0 to 209.5 cm.)
             11      6’11” (209.6 to 212.0 cm.)
                     DK, R

HWT_Q3       How much ^DOVERB ^YOU2 weigh?
HWTE_3       INTERVIEWER: Enter amount only.

             |_|_|_|        Weight
             (MIN: 1) (MAX: 575; warning after 300 lb or 136 kg and warning under 60 lb or 27 kg.)
             DK, R          (Go to HWT_END)

HWT_N4       INTERVIEWER: Was that in pounds or kilograms?
HWTE_N4
             1       Pounds
             2       Kilograms
                     (DK, R are not allowed)




16                                                                                Statistics Canada
                                                   Canadian Community Health Survey - Cycle 3.1

HWT_E4        An unusual value has been entered. Please confirm.

              Trigger soft edit if (HWT_Q3 > 300 and HWT_N4 = 1 or HWT_Q3 > 136 and
              HWT_N4 = 2) or (HWT_Q3 < 60 and HWT_N4 = 1 or HWT_Q3 < 27 and HWT_N4 = 2).

HWT_C4        If proxy interview, go to HWT_END.
              Otherwise, go to HWT_Q4.

HWT_Q4        Do you consider yourself:
HWTE_4        INTERVIEWER: Read categories to respondent.

              1      … overweight?
              2      … underweight?
              3      … just about right?
                     DK, R

HWT_END




Statistics Canada                                                                           17
Canadian Community Health Survey - Cycle 3.1



CHRONIC CONDITIONS (CCC)
CCC_BEG      Set HasSkinCancer = No

CCC_C011     If (do CCC block = 1), go to CCC_R011.
             Otherwise, go to CCC_END.

CCC_R011     Now I’d like to ask about certain chronic health conditions which ^YOU2 may have.
             We are interested in “long-term conditions” which are expected to last or have
             already lasted 6 months or more and that have been diagnosed by a health
             professional.
             INTERVIEWER: Press <Enter> to continue.

CCC_Q011     ^DOVERB_C ^YOU2 have:
CCCE_011
             ... food allergies?

             1       Yes
             2       No
                     DK
                     R                  (Go to CCC_END)

CCC_Q021     (^DOVERB_C ^YOU2 have:)
CCCE_021
             ... any other allergies?

             1       Yes
             2       No
                     DK, R

CCC_Q031     (^DOVERB_C ^YOU2 have:)
CCCE_031
             ... asthma?

             1       Yes
             2       No                 (Go to CCC_Q041)
                     DK, R              (Go to CCC_Q041)

CCC_Q035     ^HAVE_C ^YOU2 had any asthma symptoms or asthma attacks in the past
CCCE_035     12 months?

             1       Yes
             2       No
                     DK, R

CCC_Q036     In the past 12 months, ^HAVE ^YOU1 taken any medicine for asthma such as
CCCE_036     inhalers, nebulizers, pills, liquids or injections?

             1       Yes
             2       No
                     DK, R




18                                                                          Statistics Canada
                                               Canadian Community Health Survey - Cycle 3.1

CCC_Q041      ^DOVERB_C ^YOU2 have fibromyalgia?
CCCE_041
              1      Yes
              2      No
                     DK, R

CCC_Q051      Remember, we’re interested in conditions diagnosed by a health professional.

CCCE_051      ^DOVERB_C ^YOU2 have arthritis or rheumatism, excluding fibromyalgia?

              1      Yes
              2      No              (Go to CCC_Q061)
                     DK, R           (Go to CCC_Q061)

CCC_Q05A      What kind of arthritis ^DOVERB ^YOU1 have?
CCCE_05A
              1      Rheumatoid arthritis
              2      Osteoarthritis
              3      Rheumatism
              4      Other - Specify
                     DK, R

CCC_C05AS     If CCC_Q05A = 4, go to CCC_Q05AS.
              Otherwise, go to CCC_Q061.

CCC_Q05AS     INTERVIEWER: Specify.

              ________________________
              (80 spaces)
              DK, R

CCC_Q061      (Remember, we’re interested in conditions diagnosed by a health professional.)

CCCE_061      ^DOVERB_C ^YOU2 have back problems, excluding fibromyalgia and arthritis?

              1      Yes
              2      No
                     DK, R

CCC_Q071      ^DOVERB_C ^YOU2 have high blood pressure?
CCCE_071
              1      Yes             (Go to CCC_Q073)
              2      No
                     DK
                     R               (Go to CCC_Q081)

CCC_Q072      ^HAVE_C ^YOU1 ever been diagnosed with high blood pressure?
CCCE_072
              1      Yes
              2      No              (Go to CCC_Q081)
                     DK, R           (Go to CCC_Q081)




Statistics Canada                                                                              19
Canadian Community Health Survey - Cycle 3.1

CCC_Q073     In the past month, ^HAVE ^YOU1 taken any medicine for high blood pressure?
CCCE_073
             1      Yes
             2      No
                    DK, R

CCC_Q074     In the past month, did ^YOU1 do anything else, recommended by a health
CCCE_074     professional, to reduce or control ^YOUR1 blood pressure?

             1      Yes
             2      No                 (Go to CCC_Q081)
                    DK, R              (Go to CCC_Q081)

CCC_Q075     What did ^YOU1 do?
             INTERVIEWER: Mark all that apply.

CCCE_75A     1      Changed diet (e.g., reduced salt intake)
CCCE_75B     2      Exercised more
CCCE_75C     3      Reduced alcohol intake
CCCE_75D     4      Other
                    DK, R

CCC_Q081     Remember, we’re interested in conditions diagnosed by a health
             professional.

CCCE_081     ^DOVERB_C ^YOU2 have migraine headaches?

             1      Yes
             2      No
                    DK, R

CCC_Q091A    (Remember, we’re interested in conditions diagnosed by a health professional.)

CCCE_91A     (^DOVERB_C ^YOU2 have:)

             ... chronic bronchitis?

             1      Yes
             2      No
                    DK, R

CCC_C091E    If age < 30, go to CCC_Q101.
             Otherwise, go to CCC_Q091E.

CCC_Q091E    (^DOVERB_C ^YOU2 have:)
CCCE_91E
             ... emphysema?

             1      Yes
             2      No
                    DK, R




20                                                                            Statistics Canada
                                                Canadian Community Health Survey - Cycle 3.1

CCC_Q091F     (^DOVERB_C ^YOU2 have:)
CCCE_91F
              ... chronic obstructive pulmonary disease (COPD)?

              1       Yes
              2       No
                      DK, R

CCC_Q101      (^DOVERB_C ^YOU2 have:)
CCCE_101
              ... diabetes?

              1       Yes
              2       No            (Go to CCC_Q111)
                      DK, R         (Go to CCC_Q111)

CCC_Q102      How old ^WERE ^YOU1 when this was first diagnosed?
CCCE_102      INTERVIEWER: Maximum is [current age].

              |_|_|_|        Age in years
              (MIN: 0) (MAX: current age)
              DK, R

CCC_C10A      If age < 15 or sex = male or CCC_Q102 < 15 or CCC_Q102 > 49, go to
              CCC_Q10C.
              Otherwise, go to CCC_Q10A.

CCC_Q10A      ^WERE ^YOU1 pregnant when ^YOU1 ^WERE first diagnosed with diabetes?
CCCE_10A
              1       Yes
              2       No            (Go to CCC_Q10C)
                      DK, R         (Go to CCC_Q10C)

CCC_Q10B      Other than during pregnancy, has a health professional ever told ^YOU1 that
CCCE_10B      ^YOU1 ^HAVE diabetes?

              1       Yes
              2       No            (Go to CCC_Q111)
                      DK, R         (Go to CCC_Q111)

CCC_Q10C      When ^YOU1 ^WERE first diagnosed with diabetes, how long was it before
CCCE_10C      ^YOU1 ^WERE started on insulin?

              1       Less than 1 month
              2       1 month to less than 2 months
              3       2 months to less than 6 months
              4       6 months to less than 1 year
              5       1 year or more
              6       Never           (Go to CCC_Q106)
                      DK, R




Statistics Canada                                                                           21
Canadian Community Health Survey - Cycle 3.1

CCC_Q105     ^DOVERB_C ^YOU2 currently take insulin for ^YOUR1 diabetes?
CCCE_105
             1       Yes
             2       No
                     DK, R

             (If CCC_Q10C = 6, CCC_Q105 will be filled with “No“ during processing)

CCC_Q106     In the past month, did ^YOU2 take pills to control ^YOUR1 blood sugar?
CCCE_106
             1       Yes
             2       No
                     DK, R

CCC_Q111     (Remember, we’re interested in conditions diagnosed by a health professional.)

CCCE_111     ^DOVERB_C ^YOU2 have epilepsy?

             1       Yes
             2       No
                     DK, R

CCC_Q121     (^DOVERB_C ^YOU2 have:)
CCCE_121
             … heart disease?

             1       Yes
             2       No
                     DK, R

CCC_Q131     (^DOVERB_C ^YOU2 have:)
CCCE_131
             ... cancer?

             1      Yes             (Go to CCC_C133)
             2      No
                    DK
                    R               (Go to CCC_Q141)

CCC_Q132     ^HAVE ^YOU1 ever been diagnosed with cancer?
CCCE_31A
             1      Yes
             2      No              (Go to CCC_Q141)
                    DK, R           (Go to CCC_Q141)

CCC_C133     If sex = male, go to CCC_Q133B.
             Otherwise, go to CCC_Q133A.

Note:        In processing, responses from CCC_Q133A and CCC_Q133B are combined.




22                                                                              Statistics Canada
                                                Canadian Community Health Survey - Cycle 3.1

CCC_D33       If CCC_Q131 = 1 and non-proxy interview, DoDid = “Do”
              If CCC_Q131 = 1 and proxy interview, DoDid = “Does”.
              If CCC_Q132 = 1, and proxy interview, DoDid = “Did”

CCC_Q133A     What type of cancer ^DoDid ^YOU1 have?
              INTERVIEWER: Mark all that apply.

CCCE_13A      1      Breast
CCCE_13C      2      Colorectal
CCCE_13D      3      Skin - Melanoma
CCCE_13E      4      Skin - Non-melanoma
CCCE_13F      5      Other
                     DK, R

              Go to CCC_D133

CCC_Q133B     What type of cancer ^DoDid ^YOU1 have?
              INTERVIEWER: Mark all that apply.

CCCE_13B      1      Prostate
CCCE_13C      2      Colorectal
CCCE_13D      3      Skin - Melanoma
CCCE_13E      4      Skin - Non-melanoma
CCCE_13F      5      Other
                     DK, R

CCC_D133      If (CCC_Q133A = 3 or 4) or (CCC_Q133B = 3 or 4), HasSkinCancer = “Yes”.
              Otherwise, HasSkinCancer = “No”.

CCC_Q141      (Remember, we’re interested in conditions diagnosed by a health professional.)

CCCE_141      ^DOVERB ^YOU2 have intestinal or stomach ulcers?

              1      Yes
              2      No
                     DK, R

CCC_Q151      ^DOVERB ^YOU2 suffer from the effects of a stroke?
CCCE_151
              1      Yes
              2      No
                     DK, R




Statistics Canada                                                                              23
Canadian Community Health Survey - Cycle 3.1

CCC_Q161     (^DOVERB ^YOU2 suffer:)
CCCE_161
             ... from urinary incontinence?

             1       Yes
             2       No
                     DK, R

CCC_Q171     ^DOVERB_C ^YOU2 suffer from a bowel disorder such as Crohn’s Disease,
CCCE_171     ulcerative colitis, Irritable Bowel Syndrome or bowel incontinence?

             1       Yes
             2       No    (Go to CCC_C181)
                     DK, R (Go to CCC_C181)

CCC_Q171A    What kind of bowel disease ^DOVERB ^YOU1 have?
CCCE_17A
             1       Crohn’s Disease
             2       Ulcerative colitis
             3       Irritable Bowel Syndrome
             4       Bowel incontinence
             5       Other
                     DK, R

CCC_C181     If age < 18, go to CCC_Q211.
             Otherwise, go to CCC_Q181.

CCC_Q181     (Remember, we’re interested in conditions diagnosed by a health professional.)

CCCE_181     (^DOVERB_C ^YOU2 have:)

             ... Alzheimer’s Disease or any other dementia?

             1       Yes
             2       No
                     DK, R

CCC_Q191     (^DOVERB_C ^YOU2 have:)
CCCE_191
             ... cataracts?

             1       Yes
             2       No
                     DK, R

CCC_Q201     (^DOVERB_C ^YOU2 have:)
CCCE_201
             ... glaucoma?

             1       Yes
             2       No
                     DK, R




24                                                                           Statistics Canada
                                               Canadian Community Health Survey - Cycle 3.1

CCC_Q211      (^DOVERB_C ^YOU2 have:)
CCCE_211
              ... a thyroid condition?

              1       Yes
              2       No
                      DK, R

CCC_Q251      (Remember, we’re interested in conditions diagnosed by a health professional.)

CCCE_251      ^DOVERB_C ^YOU2 have chronic fatigue syndrome?

              1       Yes
              2       No
                      DK, R

CCC_Q261      ^DOVERB_C ^YOU2 suffer from multiple chemical sensitivities?
CCCE_261
              1       Yes
              2       No
                      DK, R

CCC_Q271      ^DOVERB_C ^YOU2 have schizophrenia?
CCCE_271
              1       Yes
              2       No
                      DK, R

CCC_Q280      Remember, we’re interested in conditions diagnosed by a health professional.

CCCE_280      ^DOVERB_C ^YOU2 have a mood disorder such as depression, bipolar disorder,
              mania or dysthymia?
              INTERVIEWER: Include manic depression.

              1       Yes
              2       No
                      DK, R

CCC_Q290      (Remember, we’re interested in conditions diagnosed by a health professional.)

CCCE_290      ^DOVERB_C ^YOU2 have an anxiety disorder such as a phobia, obsessive-
              compulsive disorder or a panic disorder?

              1       Yes
              2       No
                      DK, R




Statistics Canada                                                                              25
Canadian Community Health Survey - Cycle 3.1

CCC_Q321     ^DOVERB_C ^YOU2 have autism or any other developmental disorder such as
CCCE_321     Down’s syndrome, Asperger’s syndrome or Rett syndrome?

             1      Yes
             2      No
                    DK, R

CCC_Q331     (Remember, we’re interested in conditions diagnosed by a health professional.)

CCCE_331     ^DOVERB_C ^YOU2 have a learning disability?

             1      Yes
             2      No              (Go to CCC_Q341)
                    DK, R           (Go to CCC_Q341)

CCC_Q331A    What kind of learning disability ^DOVERB ^YOU2 have?
             INTERVIEWER: Mark all that apply.

CCCE_33A     1      Attention Deficit Disorder, no hyperactivity (ADD)
CCCE_33B     2      Attention Deficit Hyperactivity Disorder (ADHD)
CCCE_33C     3      Dyslexia
CCCE_33D     4      Other - Specify
                    DK, R

CCC_C331AS If CCC_Q331A = 4, go to CCC_Q331AS.
           Otherwise, go to CCC_Q341.

CCC_Q331AS INTERVIEWER: Specify.

             ________________________
             (80 spaces)
             DK, R

CCC_Q341     ^DOVERB_C ^YOU2 have an eating disorder such as anorexia or bulimia?
CCCE_341
             1      Yes
             2      No
                    DK, R




26                                                                           Statistics Canada
                                              Canadian Community Health Survey - Cycle 3.1

CCC_Q901      ^DOVERB_C ^YOU2 have any other long-term physical or mental health condition
CCCE_901      that has been diagnosed by a health professional?

              1      Yes
              2      No            (Go to CCC_END)
                     DK, R         (Go to CCC_END)

CCC_C901S     If CCC_Q901 = 1, go to CCC_Q901S.
              Otherwise, go to CCC_END.

CCC_Q901S     INTERVIEWER: Specify.

              ________________________
              (80 spaces)
              DK, R

CCC_END




Statistics Canada                                                                       27
Canadian Community Health Survey - Cycle 3.1



DIABETES CARE (DIA)
DIA_BEG

DIA_C01A     If (do DIA block = 1), go to DIA_C01B.
DIAEFOPT     Otherwise, go to DIA_END.

DIA_C01B     If (CCC_Q101 = 1), go to DIA_C01C.
             Otherwise, go to DIA_END.

DIA_C01C     If (CCC_Q10A = 1), go to DIA_END.
             Otherwise, go to DIA_R01.

DIA_R01      It was reported earlier that ^YOU2 ^HAVE diabetes. The following questions are
             about diabetes care.
             INTERVIEWER: Press <Enter> to continue.

DIA_Q01      In the past 12 months, has a health care professional tested ^YOU2 for
DIAE_01      haemoglobin “A-one-C”? (An “A-one-C” haemoglobin test measures the
             average level of blood sugar over a 3-month period.)

             1       Yes
             2       No              (Go to DIA_Q03)
                     DK              (Go to DIA_Q03)
                     R               (Go to DIA_END)

DIA_Q02      How many times? (In the past 12 months, has a health care professional tested
DIAE_02      ^YOU2 for haemoglobin “A-one-C”?)

             |_|_|   Times
             (MIN: 1) (MAX: 99)
             DK, R

DIA_Q03      In the past 12 months, has a health care professional checked ^YOUR1 feet for any
DIAE_03      sores or irritations?

             1       Yes
             2       No              (Go to DIA_Q05)
             3       No feet         (Go to DIA_Q05)
                     DK, R           (Go to DIA_Q05)

DIA_Q04      How many times? (In the past 12 months, has a health care professional checked
DIAE_04      ^YOUR1 feet for any sores or irritations?)

             |_|_|   Times
             (MIN: 1) (MAX: 99)
             DK, R




28                                                                          Statistics Canada
                                               Canadian Community Health Survey - Cycle 3.1

DIA_Q05       In the past 12 months, has a health care professional tested ^YOUR1
DIAE_05       urine for protein (i.e., Microalbumin)?

              1      Yes
              2      No
                     DK, R

DIA_Q06       ^HAVE_C ^YOU2 ever had an eye exam where the pupils of ^YOUR1 eyes were
DIAE_06       dilated? (This procedure would have made ^HIMHER temporarily sensitive to
              light.)

              1      Yes
              2      No             (Go to DIA_R08)
                     DK, R          (Go to DIA_R08)

DIA_Q07       When was the last time?
DIAE_07       INTERVIEWER: Read categories to respondent.

              1      Less than one month ago
              2      1 month to less than 1 year ago
              3      1 year to less than 2 years ago
              4      2 or more years ago
                     DK, R

DIA_R08       Now some questions about diabetes care not provided by a health care
              professional.
              INTERVIEWER: Press <Enter> to continue.

DIA_Q08       How often ^DOVERB ^YOU2 usually have ^YOUR1 blood checked for glucose or
DIAE_08       sugar by ^YOURSELF or by a family member or friend?
              INTERVIEWER: Select the reporting period here and enter the number in the next
              screen.

              1      Per day
              2      Per week       (Go to DIA_N08C)
              3      Per month      (Go to DIA_N08D)
              4      Per year       (Go to DIA_N08E)
              5      Never          (Go to DIA_C09)
                     DK, R          (Go to DIA_C09)

DIA_N08B      INTERVIEWER: Enter number of times per day.
DIAE_N8B
              l_l_l   Times
              (MIN: 1) (MAX: 99)
              DK, R

              Go to DIA_C09

DIA_N08C      INTERVIEWER: Enter number of times per week.
DIAE_N8C
              l_l_l   Times
              (MIN: 1) (MAX: 99)
              DK, R

              Go to DIA_C09




Statistics Canada                                                                          29
Canadian Community Health Survey - Cycle 3.1

DIA_N08D     INTERVIEWER: Enter number of times per month.
DIAE_N8D
             l_l_l   Times
             (MIN: 1) (MAX: 99)
             DK, R

             Go to DIA_C09

DIA_N08E     INTERVIEWER: Enter number of times per year.
DIAE_N8E
             l_l_l   Times
             (MIN: 1) (MAX: 99)
             DK, R

DIA_C09      If DIA_Q03 = 3 (no feet), go to DIA_C10.
             Otherwise, go to DIA_Q09.

DIA_Q09      How often ^DOVERB ^YOU2 usually have ^YOUR1 feet checked for any sores or
DIAE_09      irritations by ^YOURSELF or by a family member or friend?
             INTERVIEWER: Select the reporting period here and enter the number in the next
             screen.

             1      Per day
             2      Per week        (Go to DIA_N09C)
             3      Per month       (Go to DIA_N09D)
             4      Per year        (Go to DIA_N09E)
             5      Never           (Go to DIA_C10)
                    DK, R           (Go to DIA_C10)

DIA_N09B     INTERVIEWER: Enter number of times per day.
DIAE_N9B
             l_l_l   Times
             (MIN: 1) (MAX: 99)
             DK, R

             Go to DIA_C10

DIA_N09C     INTERVIEWER: Enter number of times per week.
DIAE_N9C
             l_l_l   Times
             (MIN: 1) (MAX: 99)
             DK, R

             Go to DIA_C10

DIA_N09D     INTERVIEWER: Enter number of times per month.
DIAE_N9D
             l_l_l   Times
             (MIN: 1) (MAX: 99)
             DK, R

             Go to DIA_C10




30                                                                          Statistics Canada
                                                Canadian Community Health Survey - Cycle 3.1

DIA_N09E      INTERVIEWER: Enter number of times per year.
DIAE_N9E
              l_l_l   Times
              (MIN: 1) (MAX: 99)
              DK, R

DIA_C10       If age >= 35, go to DIA_R10.
              Otherwise, go to DIA_END.

DIA_R10       Now a few questions about medication.
              INTERVIEWER: Press <Enter> to continue

DIA_Q10       In the past month, did ^YOU2 take aspirin or other ASA (acetylsalicylic acid)
DIAE_10       medication every day or every second day?

              1      Yes
              2      No
                     DK, R

DIA_Q11       In the past month, did ^YOU1 take prescription medications such as Lipitor or
DIAE_11       Zocor to control ^YOUR1 blood cholesterol levels?

              1      Yes
              2      No
                     DK, R

DIA_END




Statistics Canada                                                                             31
Canadian Community Health Survey - Cycle 3.1



MEDICATION USE (MED)
MED_BEG

MED_C1       If (do MED block = 1), go to MED_R1.
MEDEFOPT     Otherwise, go to MED_END.

MED_R1       Now I’d like to ask a few questions about ^YOUR2 use of medications, both
             prescription and over-the-counter.
             INTERVIEWER: Press <Enter> to continue.

MED_Q1A      In the past month, that is, from [date one month ago] to yesterday, did
MEDE_1A      ^YOU2 take:

             ... pain relievers such as aspirin or Tylenol (including arthritis medicine and
             anti-inflammatories)?

             1      Yes
             2      No
                    DK
                    R               (Go to MED_END)

MED_Q1B      In the past month, that is, from [date one month ago] to yesterday, did ^YOU2
MEDE_1B      take:

             ... tranquilizers such as Valium or Ativan?

             1      Yes
             2      No
                    DK, R

MED_Q1C      (In the past month, that is, from [date one month ago] to yesterday, did
MEDE_1C      ^YOU2 take:)

             ... diet pills such Dexatrim, Ponderal or Fastin?

             1      Yes
             2      No
                    DK, R

MED_Q1D      (In the past month, that is, from [date one month ago] to yesterday, did In the past
MEDE_1D      month, that is, from [date one month ago] to yesterday, did ^YOU2 take:)

             ... anti-depressants such as Prozac, Paxil or Effexor?

             1      Yes
             2      No
                    DK, R




32                                                                               Statistics Canada
                                                     Canadian Community Health Survey - Cycle 3.1

MED_Q1E       (In the past month, that is, from [date one month ago] to yesterday, did
MEDE_1E       ^YOU2 take:)

              ... codeine, Demerol or morphine?

              1       Yes
              2       No
                      DK, R

MED_Q1F       (In the past month, that is, from [date one month ago] to yesterday, did
MEDE_1F       ^YOU2 take:)

              ... allergy medicine such as Reactine or Allegra?

              1       Yes
              2       No
                      DK, R

MED_Q1G       (In the past month, that is, from [date one month ago] to yesterday, did
MEDE_1G       ^YOU2 take:)

              ... asthma medications such as inhalers or nebulizers?

              1       Yes
              2       No
                      DK, R

MED_E1G       Inconsistent answers have been entered. The respondent has taken medicine for asthma
              in the past month but previously reported that he/she did not. Please confirm.

              Trigger soft edit if MED_Q1G = 1 and CCC_Q036 = 2.

MED_Q1H       (In the past month, that is, from [date one month ago] to yesterday, did
MEDE_1H       ^YOU2 take:)

              ... cough or cold remedies?

              1       Yes
              2       No
                      DK, R

MED_Q1I       (In the past month, that is, from [date one month ago] to yesterday, did
MEDE_1I       ^YOU2 take:)

              ... penicillin or other antibiotics?

              1       Yes
              2       No
                      DK, R




Statistics Canada                                                                              33
Canadian Community Health Survey - Cycle 3.1

MED_Q1J      (In the past month, that is, from [date one month ago] to yesterday, did
MEDE_1J      ^YOU2 take:)

             ... medicine for the heart?

             1       Yes
             2       No
                     DK, R

MED_Q1L      In the past month, that is, from [date one month ago] to yesterday, did
MEDE_1L      ^YOU2 take:

             ... diuretics or water pills?

             1       Yes
             2       No
                     DK, R

MED_Q1M      (In the past month, that is, from [date one month ago] to yesterday, did
MEDE_1M      ^YOU2 take:)

             ... steroids?

             1       Yes
             2       No
                     DK, R

MED_Q1P      (In the past month, that is, from [date one month ago] to yesterday, did
MEDE_1P      ^YOU2 take:)

             ... sleeping pills such as Imovane, Nytol or Starnoc?

             1       Yes
             2       No
                     DK, R

MED_Q1Q      (In the past month, that is, from [date one month ago] to yesterday, did
MEDE_1Q      ^YOU2 take:)

             ... stomach remedies?

             1       Yes
             2       No
                     DK, R

MED_Q1R      (In the past month, that is, from [date one month ago] to yesterday, did
MEDE_1R      ^YOU2 take:)

             ... laxatives?

             1       Yes
             2       No
                     DK, R




34                                                                             Statistics Canada
                                                    Canadian Community Health Survey - Cycle 3.1

MED_C1S       If sex = female and age <= 49, go to MED_Q1S.
              Otherwise, go to MED_C1TA.

MED_Q1S       (In the past month, that is, from [date one month ago] to yesterday, did
MEDE_1S       ^YOU2 take:)

              ... birth control pills?

              1       Yes
              2       No
                      DK, R

MED_C1TA      If (do HRT block = 1), go to MED_Q1U.
              Otherwise, go to MED_C1T.

MED_C1T       If sex is female and age >= 30, go to MED_Q1T.
              Otherwise, go to MED_Q1U.

MED_Q1T       (In the past month, that is, from [date one month ago] to yesterday, did
MEDE_1T       ^YOU2 take:)

              ... hormones for menopause or ageing symptoms?

              1       Yes
              2       No                 (Go to MED_Q1U)
                      DK, R              (Go to MED_Q1U)

MED_Q1T1      What type of hormones ^ARE ^YOU1 taking?
MEDE_1T1      INTERVIEWER: Read categories to respondent.

              1       Estrogen only
              2       Progesterone only
              3       Both
              4       Neither
                      DK, R

MED_Q1T2      When did ^YOU1 start this hormone therapy?
MEDE_1T2      INTERVIEWER: Enter the year (minimum is [year of birth + 30]; maximum is
              [current year]).

              |_|_|_|_| Year
              (MIN: year of birth + 30) (MAX: current year)
              DK, R

MED_E1T2      Year must be between [year of birth + 30] and [current year]. Please return and
              correct.

              Trigger hard edit if outside these ranges.




Statistics Canada                                                                               35
Canadian Community Health Survey - Cycle 3.1

MED_Q1U      In the past month, that is, from [date one month ago] to yesterday, did
MEDE_1U      ^YOU2 take:

             ... thyroid medication such as Synthroid or Levothyroxine?

             1      Yes
             2      No
                    DK, R

MED_Q1V      (In the past month, that is, from [date one month ago] to yesterday, did
MEDE_1V      ^YOU2 take:)

             ... any other medication?

             1      Yes
             2      No
                    DK, R

MED_C1V      If MED_Q1V = 1, go to MED_Q1VS.
             Otherwise, go to MED_END.

MED_Q1VS     INTERVIEWER: Specify.

             _______________________________
             (80 spaces)
             DK, R

MED_END




36                                                                             Statistics Canada
                                                   Canadian Community Health Survey - Cycle 3.1



HEALTH CARE UTILIZATION (HCU)
HCU_BEG

HCU_C01       If (HCU block = 1), go to HCU_R01.
              Otherwise, go to HCU_END.

HCU_R01       Now I’d like to ask about ^YOUR2 contacts with various health professionals
              during the past 12 months, that is, from [date one year ago] to yesterday.
              INTERVIEWER: Press <Enter> to continue.

HCU_Q01AA     ^DOVERB ^YOU2 have a regular medical doctor?
HCUE_1AA
              1      Yes   (Go to HCU_Q01AC)
              2      No
                     DK, R (Go to HCU_Q01BA)

HCU_Q01AB     Why ^DOVERB ^YOU2 not have a regular medical doctor?
              INTERVIEWER: Mark all that apply.

HCUE_1BA      1      No medical doctors available in the area
HCUE_1BB      2      Medical doctors in the area are not taking new patients
HCUE_1BC      3      Have not tried to contact one
HCUE_1BD      4      Had a medical doctor who left or retired
HCUE_1BE      5      Other - Specify
                     DK, R

HCU_C01ABS If HCU_Q01AB = 5, go to HCU_Q01ABS.
           Otherwise, go to HCU_Q01BA.

HCU_Q01ABS INTERVIEWER: Specify.

              ______________________
              (80 spaces)
              DK, R

              (Go to HCU_Q01BA)




Statistics Canada                                                                           37
Canadian Community Health Survey - Cycle 3.1

HCU_Q01AC    ^DOVERB_C ^YOU2 and this doctor usually speak in English, in French, or in
HCUE_1AC     another language?

              1      English                 13       Portuguese
              2      French                  14       Punjabi
              3      Arabic                  15       Spanish
              4      Chinese                 16       Tagalog (Pilipino)
              5      Cree                    17       Ukrainian
              6      German                  18       Vietnamese
              7      Greek                   19       Dutch
              8      Hungarian               20       Hindi
              9      Italian                 21       Russian
              10     Korean                  22       Tamil
              11     Persian (Farsi)         23       Other - Specify
              12     Polish                           DK, R

HCU_C01ACS If HCU_Q01AC = 23, go to HCU_Q01ACS.
           Otherwise, go to HCU_Q01BA.

HCU_Q01ACS INTERVIEWER: Specify.

             ________________________
             (80 spaces)
             DK, R

HCU_Q01BA    In the past 12 months, ^HAVE ^YOU2 been a patient overnight in a
HCUE_01      hospital, nursing home or convalescent home?

             1      Yes
             2      No                 (Go to HCU_Q02A)
                    DK                 (Go to HCU_Q02A)
                    R                  (Go to HCU_END)

HCU_Q01BB    For how many nights in the past 12 months?
HCUE_01A
             |_|_|_| Nights
             (MIN: 1) (MAX: 366; warning after 100)
             DK, R




38                                                                         Statistics Canada
                                                    Canadian Community Health Survey - Cycle 3.1

HCU_Q02A      [Not counting when ^YOU2 ^WERE an overnight patient, in the past
HCUE_02A      12 months/In the past 12 months], how many times ^HAVE ^YOU2 seen,
              or talked on the telephone, about ^YOUR1 physical, emotional or mental
              health with:

              … a family doctor[, pediatrician] or general practitioner?
              (include pediatrician if age < 18)

              |_|_|_| Times
              (MIN: 0) (MAX: 366; warning after 12)
              DK, R

Note:         If HCU_Q01AB = 1, use “Not counting when you were an overnight patient, in the past 12
              months”. Otherwise, use “In the past 12 months”.

HCU_Q02B      ([Not counting when ^YOU2 ^WERE an overnight patient, in the past
HCUE_02B      12 months/In the past 12 months], how many times ^HAVE ^YOU2 seen,
              or talked on the telephone, about ^YOUR1 physical, emotional or mental health
              with:)

              … an eye specialist (such as an ophthalmologist or optometrist)?

              |_|_|_| Times
              (MIN: 0) (MAX: 75; warning after 3)
              DK, R

Note:         If HCU_Q01AB = 1, use “Not counting when you were an overnight patient, in the past 12
              months”. Otherwise, use “In the past 12 months”.

HCU_Q02C      ([Not counting when ^YOU2 ^WERE an overnight patient, in the past
HCUE_02C      12 months/In the past 12 months], how many times ^HAVE ^YOU2 seen,
              or talked on the telephone, about ^YOUR1 physical, emotional or mental
              health with:)

              … any other medical doctor (such as a surgeon, allergist, orthopedist,
              gynaecologist or psychiatrist)?

              |_|_|_| Times
              (MIN: 0) (MAX: 300; warning after 7)
              DK, R

Note:         If HCU_Q01AB = 1, use “Not counting when you were an overnight patient, in the past 12
              months”. Otherwise, use “In the past 12 months”.




Statistics Canada                                                                                39
Canadian Community Health Survey - Cycle 3.1

HCU_Q02D     [Not counting when ^YOU2 ^WERE an overnight patient, in the past
HCUE_02D     12 months/In the past 12 months], how many times ^HAVE ^YOU2 seen,
             or talked on the telephone, about ^YOUR1 physical, emotional or mental
             health with:

             … a nurse for care or advice?

             |_|_|_| Times
             (MIN: 0) (MAX: 366; warning after 15)
             DK, R

Note:        If HCU_Q01AB = 1, use “Not counting when you were an overnight patient, in the past 12
             months”. Otherwise, use “In the past 12 months”.

HCU_Q02E     ([Not counting when ^YOU2 ^WERE an overnight patient, in the past
HCUE_02E     12 months/In the past 12 months], how many times ^HAVE ^YOU2 seen,
             or talked on the telephone, about ^YOUR1 physical, emotional or mental
             health with:)

             … a dentist or orthodontist?

             |_|_|_| Times
             (MIN: 0) (MAX: 99; warning after 4)
             DK, R

Note:        If HCU_Q01AB = 1, use “Not counting when you were an overnight patient, in the past 12
             months”. Otherwise, use “In the past 12 months”.

HCU_Q02F     ([Not counting when ^YOU2 ^WERE an overnight patient, in the past
HCUE_02F     12 months/In the past 12 months], how many times ^HAVE ^YOU2 seen,
             or talked on the telephone, about ^YOUR1 physical, emotional or mental
             health with:)

             … a chiropractor?

             |_|_|_| Times
             (MIN: 0) (MAX: 366; warning after 20)
             DK, R

Note:        If HCU_Q01AB = 1, use “Not counting when you were an overnight patient, in the past 12
             months”. Otherwise, use “In the past 12 months”.




40                                                                              Statistics Canada
                                                 Canadian Community Health Survey - Cycle 3.1

HCU_Q02G      [Not counting when ^YOU2 ^WERE an overnight patient, in the past
HCUE_02G      12 months/In the past 12 months], how many times ^HAVE ^YOU2 seen,
              or talked on the telephone, about ^YOUR1 physical, emotional or mental
              health with:

              … a physiotherapist?

              |_|_|_| Times
              (MIN: 0) (MAX: 366; warning after 30)
              DK, R

Note:         If HCU_Q01AB = 1, use “Not counting when you were an overnight patient, in the past 12
              months”. Otherwise, use “In the past 12 months”.

HCU_Q02H      ([Not counting when ^YOU2 ^WERE an overnight patient, in the past
HCUE_02H      12 months/In the past 12 months], how many times ^HAVE ^YOU2 seen,
              or talked on the telephone, about ^YOUR1 physical, emotional or mental
              health with:)

              … a social worker or counsellor?

              |_|_|_| Times
              (MIN: 0) (MAX: 366; warning after 20)
              DK, R

Note:         If HCU_Q01AB = 1, use “Not counting when you were an overnight patient, in the past 12
              months”. Otherwise, use “In the past 12 months”.

HCU_Q02I      ([Not counting when ^YOU2 ^WERE an overnight patient, in the past
HCUE_02I      12 months/In the past 12 months], how many times ^HAVE ^YOU2 seen,
              or talked on the telephone, about ^YOUR1 physical, emotional or mental
              health with:)

              … a psychologist?

              |_|_|_| Times
              (MIN: 0) (MAX: 366; warning after 25)
              DK, R

Note:         If HCU_Q01AB = 1, use “Not counting when you were an overnight patient, in the past 12
              months”. Otherwise, use “In the past 12 months”.




Statistics Canada                                                                                41
Canadian Community Health Survey - Cycle 3.1

HCU_Q02J     [Not counting when ^YOU2 ^WERE an overnight patient, in the past
HCUE_02J     12 months/In the past 12 months], how many times ^HAVE ^YOU2 seen,
             or talked on the telephone, about ^YOUR1 physical, emotional or mental
             health with:

             … a speech, audiology or occupational therapist?

             |_|_|_| Times
             (MIN: 0) (MAX: 200; warning after 12)
             DK, R

Note:        If HCU_Q01AB = 1, use “Not counting when you were an overnight patient, in the past 12
             months”. Otherwise, use “In the past 12 months”.

HCU_C03      If HCU_Q02A or HCU_Q02C or HCU_Q02D > 0, go to HCU_Q03.
             Otherwise, go to HCU_Q04A.

HCU_Q03      Where did the most recent contact take place?
             INTERVIEWER: If respondent says “hospital”, probe for details.

HCUE_03A     1       Doctor’s office
HCUE_03C     2       Hospital emergency room
HCUE_03D     3       Hospital outpatient clinic (e.g. day surgery, cancer)
             4       Walk-in clinic
             5       Appointment clinic
             6       Community health centre / CLSC
             7       At work
             8       At school
             9       At home
             10      Telephone consultation only
             11      Other - Specify
                     DK, R

HCU_C03S     If HCU_Q03 = 11, go to HCU_Q03S.
             Otherwise, go to HCU_C031.

HCU_Q03S     INTERVIEWER: Specify.

             _____________________
             (80 spaces)
             DK, R

HCU_C031     If HCU_Q03 = 3 (Hospital outpatient clinic), or 5 (Appointment clinic) or 6 (Community
             health centre), go to HCU_Q03_1.
             Otherwise, go to HCU_Q04A.

HCU_Q03_1    Did this most recent contact occur:
HCUE_3A1     INTERVIEWER: Read categories to respondent.
HCUE_3C1
HCUE_3D1     1       … in-person (face-to-face)?
             2       … through a videoconference?
             3       … through another method?
                     DK, R




42                                                                                 Statistics Canada
                                                  Canadian Community Health Survey - Cycle 3.1

HCU_Q04A      In the past 12 months, ^HAVE ^YOU1 attended a meeting of a self-
HCUE_04A      help group such as AA or a cancer support group?

              1      Yes
              2      No
                     DK, R

HCU_Q04       People may also use alternative or complementary medicine. In the past 12
HCUE_04       months, ^HAVE ^YOU2 seen or talked to an alternative health care
              provider such as an acupuncturist, homeopath or massage therapist about
              ^YOUR1 physical, emotional or mental health?

              1      Yes
              2      No             (Go to HCU_C06)
                     DK, R          (Go to HCU_C06)

HCU_Q05       Who did ^YOU2 see or talk to?
              INTERVIEWER: Mark all that apply.

HCUE_05A      1      Massage therapist
HCUE_05B      2      Acupuncturist
HCUE_05C      3      Homeopath or naturopath
HCUE_05D      4      Feldenkrais or Alexander teacher
HCUE_05E      5      Relaxation therapist
HCUE_05F      6      Biofeedback teacher
HCUE_05G      7      Rolfer
HCUE_05H      8      Herbalist
HCUE_05I      9      Reflexologist
HCUE_05J      10     Spiritual healer
HCUE_05K      11     Religious healer
HCUE_05L      12     Other - Specify
                     DK, R

HCU_C05S      If HCU_Q05 = 12, go to HCU_Q05S.
              Otherwise, go to HCU_C06.

HCU_Q05S      INTERVIEWER: Specify.

              _____________________
              (80 spaces)
              DK, R




Statistics Canada                                                                          43
Canadian Community Health Survey - Cycle 3.1

HCU_C06      If non-proxy interview, ask “During the past 12 months, was there ever a time when you
             felt that you needed health care but you didn’t receive it?” in HCU_Q06.

             If proxy interview and age < 18, ask “During the past 12 months, was there ever a time
             when you felt that FNAME needed health care but [he/she] didn’t receive it?” in
             HCU_Q06.

             If proxy interview and age >= 18, ask “During the past 12 months, was there ever a time
             when FNAME felt that [he/she] needed health care but [he/she] didn’t receive it?” in
             HCU_Q06.

HCU_Q06      During the past 12 months, was there ever a time when ^YOU2 felt that
HCUE_06      [you/FNAME/he/she] needed health care but ^YOU1 didn’t receive it?

             1       Yes
             2       No              (Go to HCU_END)
                     DK, R           (Go to HCU_END)

HCU_Q07      Thinking of the most recent time, why didn’t ^YOU1 get care?
             INTERVIEWER: Mark all that apply.

HCUE_07A     1       Not available - in the area
HCUE_07B     2       Not available - at time required (e.g. doctor on holidays, inconvenient
                     hours)
HCUE_07C     3       Waiting time too long
HCUE_07D     4       Felt would be inadequate
HCUE_07E     5       Cost
HCUE_07F     6       Too busy
HCUE_07G     7       Didn’t get around to it / didn’t bother
HCUE_07H     8       Didn’t know where to go
HCUE_07I     9       Transportation problems
HCUE_07J     10      Language problems
HCUE_07K     11      Personal or family responsibilities
HCUE_07L     12      Dislikes doctors / afraid
HCUE_07M     13      Decided not to seek care
HCUE_07O     14      Doctor - didn’t think it was necessary
HCUE_07P     15      Unable to leave the house because of a health problem
HCUE_07N     16      Other - Specify
                     DK, R

HCU_C07S     If HCU_Q07 = 16, go to HCU_Q07S.
             Otherwise, go to HCU_Q08.

HCU_Q07S     INTERVIEWER: Specify.

             _____________________
             (80 spaces)
             DK, R




44                                                                                   Statistics Canada
                                                   Canadian Community Health Survey - Cycle 3.1

HCU_Q08       Again, thinking of the most recent time, what was the type of care that was
              needed?
              INTERVIEWER: Mark all that apply.

HCUE_08A      1      Treatment of - a physical health problem
HCUE_08B      2      Treatment of - an emotional or mental health problem
HCUE_08C      3      A regular check-up (including regular pre-natal care)
HCUE_08D      4      Care of an injury
HCUE_08E      5      Other - Specify
                     DK, R

HCU_C08S      If HCU_Q08 = 5, go to HCU_Q08S.
              Otherwise, go to HCU_Q09.

HCU_Q08S      INTERVIEWER: Specify.

              _____________________
              (80 spaces)
              DK, R

HCU_Q09       Where did ^YOU1 try to get the service ^YOU1 ^WERE seeking?
              INTERVIEWER: Mark all that apply.

HCUE_09A      1      Doctor’s office
HCUE_09B      2      Hospital - emergency room
HCUE_09C      3      Hospital - overnight patient
HCUE_09D      4      Hospital - outpatient clinic (e.g., day surgery, cancer)
HCUE_09E      5      Walk-in clinic
HCUE_09F      6      Appointment clinic
HCUE_09G      7      Community health centre / CLSC
HCUE_09H      8      Other - Specify
                     DK, R

HCU_C09S      If HCU_Q09 = 8, go to HCU_Q09S.
              Otherwise, go to HCU_END.

HCU_Q09S      INTERVIEWER: Specify.

              _____________________
              (80 spaces)
              DK, R

HCU_END




Statistics Canada                                                                           45
Canadian Community Health Survey - Cycle 3.1



HOME CARE SERVICES(HMC)
HMC_BEG

HMC_C09A     If (do HMC block = 1), go to HMC_C09B.
             Otherwise, go to HMC_END.

HMC_C09B     If age < 18, go to HMC_END.
             Otherwise, go to HMC_R09.

HMC_R09      Now some questions on home care services. These are health care, home maker
             or other support services received at home. People may receive home care due to
             a health problem or condition that affects their daily activities. Examples include:
             nursing care, personal care or help with bathing, housework, meal preparation,
             meal delivery and respite care.
             INTERVIEWER: Press <Enter> to continue.

HMC_Q09      ^HAVE_C ^YOU2 received any home care services in the past 12 months, with the
HMCE_09      cost being entirely or partially covered by government?

             1      Yes
             2      No              (Go to HMC_Q11)
                    DK              (Go to HMC_Q11)
                    R               (Go to HMC_END)

HMC_Q10      What type of services ^HAVE ^YOU1 received?
             INTERVIEWER: Read categories to respondent. Mark all that apply.
             Cost must be entirely or partially covered by government.

HMCE_10A     1      Nursing care (e.g., dressing changes, preparing medications,
                    V.O.N. visits)
HMCE_10B     2      Other health care services (e.g., physiotherapy, occupational or
                    speech therapy, nutrition counselling)
HMCE_10I     3      Medical equipment or supplies
HMCE_10C     4      Personal care (e.g., bathing, foot care)
HMCE_10D     5      Housework (e.g., cleaning, laundry)
HMCE_10E     6      Meal preparation or delivery
HMCE_10F     7      Shopping
HMCE_10G     8      Respite care (i.e., caregiver relief)
HMCE_10H     9      Other - Specify
                    DK, R

HMC_C10S     If HMC_Q10 = 9, go to HMC_Q10S.
             Otherwise, go to HMC_Q11.

HMC_Q10S     INTERVIEWER: Specify.

             ______________________________
             (80 spaces)
             DK, R




46                                                                              Statistics Canada
                                                Canadian Community Health Survey - Cycle 3.1

HMC_Q11       ^HAVE ^YOU2 received any [other] home care services in the past 12 months, with
HMCE_11       the cost not covered by government (for example: care provided by a private
              agency or by a spouse or friends)?
              INTERVIEWER: Include only health care, homemaker or other support services (e.g.,
              housework) that are provided because of a respondent’s health problem or condition.

              1      Yes
              2      No             (Go to HMC_Q14)
                     DK, R          (Go to HMC_Q14)

Note:         If HMC_Q09 = 1, use “any other home care services” in HMC_Q11.
              Otherwise, use “any home care services” in HMC_Q11.

HMC_Q12       Who provided these [other] home care services?
              INTERVIEWER: Read categories to respondent. Mark all that apply.

HMCE_12A      1      Nurse from a private agency
HMCE_12B      2      Homemaker or other support services from a private agency
HMCE_12G      3      Physiotherapist or other therapist from a private agency
HMCE_12C      4      Neighbour or friend
HMCE_12D      5      Family member or spouse
HMCE_12E      6      Volunteer
HMCE_12F      7      Other - Specify
                     DK, R

HMC_C12S      If HMC_Q12 = 7, go to HMC_Q12S.
              Otherwise, go to HMC_C13.

HMC_Q12S      INTERVIEWER: Specify.

              _________________________
              (80 spaces)
              DK, R

Note:         If HMC_Q09 = 1, use “any other home care services” in HMC_Q12.
              Otherwise, use “any home care services” in HMC_Q12.




Statistics Canada                                                                             47
Canadian Community Health Survey - Cycle 3.1

HMC_C13      For each person identified in HMC_Q12, ask HMC_Q13n up to 7 times,
             n = where A, B, C, D, E, F, G.

HMC_Q13n     What type of services ^HAVE ^YOU1 received from [person identified in
             HMC_Q12]?
             INTERVIEWER: Read categories to respondent. Mark all that apply.

HMCE_3nA     1      Nursing care (e.g., dressing changes, preparing medications,
                    V.O.N. visits)
HMCE_3nB     2      Other health care services (e.g., physiotherapy, occupational or
                    speech therapy, nutrition counselling)
HMCE_3nI     3      Medical equipment or supplies
HMCE_3nC     4      Personal care (e.g., bathing, foot care)
HMCE_3nD     5      Housework (e.g., cleaning, laundry)
HMCE_3nE     6      Meal preparation or delivery
HMCE_3nF     7      Shopping
HMCE_3nG     8      Respite care (i.e., caregiver relief)
HMCE_3nH     9      Other - Specify
                    DK, R

HMC_C13S     If HMC_Q13 = 9, go to HMC_Q13S.
             Otherwise, go to HMC_Q14.

HMC_Q13S     INTERVIEWER: Specify.

             _________________________
             (80 spaces)
             DK, R

HMC_Q14      During the past 12 months, was there ever a time when ^YOU2 felt
HMCE_14      that ^YOU1 needed home care services but ^YOU1 didn’t receive them?

             1      Yes
             2      No             (Go to HMC_END)
                    DK, R          (Go to HMC_END)




48                                                                            Statistics Canada
                                                  Canadian Community Health Survey - Cycle 3.1

HMC_Q15       Thinking of the most recent time, why didn’t ^YOU1 get these services?
              INTERVIEWER: Mark all that apply.

HMCE_15A      1      Not available - in the area
HMCE_15B      2      Not available - at time required (e.g., inconvenient hours)
HMCE_15C      3      Waiting time too long
HMCE_15D      4      Felt would be inadequate
HMCE_15E      5      Cost
HMCE_15F      6      Too busy
HMCE_15G      7      Didn’t get around to it / didn’t bother
HMCE_15H      8      Didn’t know where to go / call
HMCE_15I      9      Language problems
HMCE_15J      10     Personal or family responsibilities
HMCE_15K      11     Decided not to seek services
HMCE_15L      12     Doctor - did not think it was necessary
HMCE_15N      13     Did not qualify / not eligible for homecare
HMCE_15O      14     Still waiting for homecare
HMCE_15M      15     Other - Specify
                     DK, R

HMC_C15S      If HMC_Q15 = 15, go to HMC_Q15S.
              Otherwise, go to HMC_Q16.

HMC_Q15S      INTERVIEWER: Specify.

              _________________________
              (80 spaces)
              DK, R




Statistics Canada                                                                          49
Canadian Community Health Survey - Cycle 3.1

HMC_Q16      Again, thinking of the most recent time, what type of home care was needed?
             INTERVIEWER: Mark all that apply.

HMCE_16A     1      Nursing care (e.g., dressing changes, preparing medications,
                    V.O.N. visits)
HMCE_16B     2      Other health care services (e.g., physiotherapy, occupational or
                    speech therapy, nutrition counselling)
HMCE_16I     3      Medical equipment or supplies
HMCE_16C     4      Personal care (e.g., bathing, foot care)
HMCE_16D     5      Housework (e.g., cleaning, laundry)
HMCE_16E     6      Meal preparation or delivery
HMCE_16F     7      Shopping
HMCE_16G     8      Respite care (i.e., caregiver relief)
HMCE_16H     9      Other - Specify
                    DK, R

HMC_C16S     If HMC_Q16 = 9, go to HMC_Q16S.
             Otherwise, go to HMC_Q17.

HMC_Q16S     INTERVIEWER: Specify.

             _______________________
             (80 spaces)
             DK, R

HMC_Q17      Where did ^YOU2 try to get this home care service?
             INTERVIEWER: Mark all that apply.

HMCE_17A     1      A government sponsored program
HMCE_17B     2      A private agency
HMCE_17C     3      A family member, friend or neighbour
HMCE_17D     4      A volunteer organization
HMCE_17E     5      Other
                    DK, R

HMC_END




50                                                                                Statistics Canada
                                                   Canadian Community Health Survey - Cycle 3.1



PATIENT SATISFACTION (PAS)
PAS_BEG

Note:         This module was only collected as part of the subsample.

PAS_C11A      If (do block = 1), go to PAS_C11B.
              Otherwise, go to PAS_END.

PAS_C11B      If proxy interview or if age < 15, go to PAS_END.
              Otherwise, go to PAS_R1.

PAS_R1        Earlier, I asked about your use of health care services in the past 12 months.
              Now I’d like to get your opinion on the quality of the care you received.
              INTERVIEWER: Press <Enter> to continue.

PAS_C11D      If HCU_Q01BA = 1 or at least one of HCU_Q02A to HCU_Q02J > 0, go to PAS_Q12.
              Otherwise, go to PAS_Q11.

Note:         In processing, if a respondent answered HCU_Q01BA = 1 or at least one of HCU_Q02A
              to HCU_Q02J > 0, set PAS_Q11 = 1.

PAS_Q11       In the past 12 months, have you received any health care services?
PASZ_11
              1       Yes
              2       No    (Go to PAS_Q51)
                      DK, R (Go to PAS_Q51)

PAS_Q12       Overall, how would you rate the quality of the health care you received?
PASZ_12       Would you say it was:
              INTERVIEWER: Read categories to respondent.

              1       … excellent?
              2       … good?
              3       … fair?
              4       … poor?
                      DK, R

PAS_Q13       Overall, how satisfied were you with the way health care services were provided?
PASZ_13       Were you:
              INTERVIEWER: Read categories to respondent.

              1       … very satisfied?
              2       … somewhat satisfied?
              3       … neither satisfied nor dissatisfied?
              4       … somewhat dissatisfied?
              5       … very dissatisfied?
                      DK, R




Statistics Canada                                                                              51
Canadian Community Health Survey - Cycle 3.1

PAS_Q21A     In the past 12 months, have you received any health care services at a hospital,
PASZ_21A     for any diagnostic or day surgery service, overnight stay, or as an emergency
             room patient?

             1      Yes
             2      No    (Go to PAS_Q31A)
                    DK, R (Go to PAS_Q31A)

PAS_Q21B     Thinking of your most recent hospital visit, were you:
PASZ_21B     INTERVIEWER: Read categories to respondent.

             1      … admitted overnight or longer (an inpatient)?
             2      … a patient at a diagnostic or day surgery clinic (an outpatient)?
             3      … an emergency room patient?
                    DK, R (Go to PAS_Q31A)

PAS_Q22      (Thinking of this most recent hospital visit:)
PASZ_22
             … how would you rate the quality of the care you received? Would you say it was:
             INTERVIEWER: Read categories to respondent.

             1      … excellent?
             2      … good?
             3      … fair?
             4      … poor?
                    DK, R

PAS_Q23      (Thinking of this most recent hospital visit:)
PASZ_23
             … how satisfied were you with the way hospital services were provided?
             Were you:
             INTERVIEWER: Read categories to respondent.

             1      … very satisfied?
             2      … somewhat satisfied?
             3      … neither satisfied nor dissatisfied?
             4      … somewhat dissatisfied?
             5      … very dissatisfied?
                    DK, R

PAS_Q31A     In the past 12 months, not counting hospital visits, have you received any
PASZ_31A     health care services from a family doctor or other physician?

             1      Yes
             2      No    (Go to PAS_R2)
                    DK, R (Go to PAS_R2)

PAS_Q31B     Thinking of the most recent time, was care provided by:
PASZ_31B     INTERVIEWER: Read categories to respondent.

             1      … a family doctor (general practitioner)?
             2      … a medical specialist?
                    DK, R (Go to PAS_R2)




52                                                                             Statistics Canada
                                                Canadian Community Health Survey - Cycle 3.1

PAS_Q32       (Thinking of this most recent care from a physician:)
PASZ_32
              … how would you rate the quality of the care you received? Would you say it was:
              INTERVIEWER: Read categories to respondent.

              1      … excellent?
              2      … good?
              3      … fair?
              4      … poor?
                     DK, R

PAS_Q33       (Thinking of this most recent care from a physician:)
PASZ_33
              … how satisfied were you with the way physician care was provided?
              Were you:
              INTERVIEWER: Read categories to respondent.

              1      … very satisfied?
              2      … somewhat satisfied?
              3      … neither satisfied nor dissatisfied?
              4      … somewhat dissatisfied?
              5      … very dissatisfied?
                     DK, R

PAS_R2        The next questions are about community-based health care which includes any
              health care received outside of a hospital or doctor’s office.

              Examples are: home nursing care, home-based counselling or therapy, personal
              care and community walk-in clinics.
              INTERVIEWER: Press <Enter> to continue.

PAS_Q41       In the past 12 months, have you received any community-based care?
PASZ_41
              1      Yes
              2      No    (Go to PAS_Q51)
                     DK, R (Go to PAS_Q51)

PAS_Q42       Overall, how would you rate the quality of the community-based care you
PASZ_42       received?
              Would you say it was:
              INTERVIEWER: Read categories to respondent.

              1      … excellent?
              2      … good?
              3      … fair?
              4      … poor?
                     DK, R




Statistics Canada                                                                            53
Canadian Community Health Survey - Cycle 3.1

PAS_Q43      Overall, how satisfied were you with the way community-based care was provided?
PASZ_43      Were you:
             INTERVIEWER: Read categories to respondent.

             1      … very satisfied?
             2      … somewhat satisfied?
             3      … neither satisfied nor dissatisfied?
             4      … somewhat dissatisfied?
             5      … very dissatisfied?
                    DK, R

PAS_Q51      In the past 12 months, have you used a telephone health line or telehealth
PASZ_51      service?

             1      Yes
             2      No    (Go to PAS_END)
                    DK, R (Go to PAS_END)

PAS_Q52      Overall, how would you rate the quality of the service you received?
PASZ_52      Would you say it was:
             INTERVIEWER: Read categories to respondent.

             1      … excellent?
             2      … good?
             3      … fair?
             4      … poor?
                    DK, R

PAS_END




54                                                                            Statistics Canada
                                                 Canadian Community Health Survey - Cycle 3.1



RESTRICTION OF ACTIVITIES (RAC)
RAC_BEG

RAC_C1        If (do RAC block = 1), go to RAC_R1.
              Otherwise, go to RAC_END.

RAC_R1        The next few questions deal with any current limitations in ^YOUR2 daily
              activities caused by a long-term health condition or problem. In these questions, a
              “long-term condition” refers to a condition that is expected to last or has already
              lasted 6 months or more.
              INTERVIEWER: Press <Enter> to continue.

RAC_Q1        ^DOVERB ^YOU1 have any difficulty hearing, seeing, communicating,
RACE_1        walking, climbing stairs, bending, learning or doing any similar activities?
              INTERVIEWER: Read categories to respondent.

              1      Sometimes
              2      Often
              3      Never
                     DK
                     R               (Go to RAC_END)

RAC_Q2A       Does a long-term physical condition or mental condition or health problem,
RACE_2A       reduce the amount or the kind of activity ^YOU1 can do:

              … at home?
              INTERVIEWER: Read categories to respondent.

              1      Sometimes
              2      Often
              3      Never
                     DK
                     R               (Go to RAC_END)

RAC_Q2B_1     (Does a long-term physical condition or mental condition or health problem,
RACE_2B1      reduce the amount or the kind of activity ^YOU1 can do:)

              … at school?

              1      Sometimes
              2      Often
              3      Never
              4      Does not attend school
                     DK
                     R               (Go to RAC_END)




Statistics Canada                                                                             55
Canadian Community Health Survey - Cycle 3.1

RAC_Q2B_2    (Does a long-term physical condition or mental condition or health problem,
RACE_2B2     reduce the amount or the kind of activity ^YOU1 can do:)

             … at work?

             1       Sometimes
             2       Often
             3       Never
             4       Does not work at a job
                     DK
                     R              (Go to RAC_END)

RAC_Q2C      (Does a long-term physical condition or mental condition or health problem,
RACE_2C      reduce the amount or the kind of activity ^YOU1 can do:)

             … in other activities, for example, transportation or leisure?

             1       Sometimes
             2       Often
             3       Never
                     DK
                     R               (Go to RAC_END)

RAC_C5       If respondent has difficulty or is limited in activities (RAC_Q1 = 1 or 2) or (RAC_Q2A-C =
             1 or 2), go to RAC_C5A.
             Otherwise, go to RAC_Q6A.

RAC_C5A      If (RAC_Q2A to RAC_Q2C = 3 or 4) and RAC_Q1 < 3 go to RAC_R5.
             Otherwise, go to RAC_Q5.

RAC_R5       You reported that ^YOU2 ^HAVE difficulty hearing, seeing, communicating,
             walking, climbing stairs, bending, learning or doing any similar activities.

RAC_Q5       Which one of the following is the best description of the cause of this
RACE_5       condition?
             INTERVIEWER: Read categories to respondent.

             1       Accident at home
             2       Motor vehicle accident
             3       Accident at work
             4       Other type of accident
             5       Existed from birth or genetic
             6       Work conditions
             7       Disease or illness
             8       Ageing
             9       Emotional or mental health problem or condition
             10      Use of alcohol or drugs
             11      Other - Specify
                     DK, R




56                                                                                  Statistics Canada
                                               Canadian Community Health Survey - Cycle 3.1

RAC_C5S       If RAC_Q5 = 11, go to RAC_Q5S.
              Otherwise, go to RAC_Q5B_1.

RAC_Q5S       INTERVIEWER: Specify.

              ________________________
              (80 spaces)
              DK, R

RAC_Q5B_1     Because of ^YOUR1 condition or health problem, ^HAVE ^YOU1 ever experienced
RACE_5B1      discrimination or unfair treatment?

              1      Yes
              2      No    (Go to RAC_Q6A)
                     DK, R (Go to RAC_Q6A)

RAC_Q5B_2     In the past 12 months, how much discrimination or unfair treatment did
RACE_5B2      ^YOU1 experience?

              1      A lot
              2      Some
              3      A little
              4      None at all
                     DK, R

RAC_Q6A       The next few questions may not apply to ^YOU2, but we need to ask the
RACE_6A       same questions of everyone.

              Because of any physical condition or mental condition or health problem,
              ^DOVERB ^YOU1 need the help of another person:

              ... with preparing meals?

              1      Yes
              2      No
                     DK, R

RAC_Q6B_1     (Because of any physical condition or mental condition or health problem,
RACE_6B1      ^DOVERB ^YOU1 need the help of another person:)

              … with getting to appointments and running errands such as shopping for
              groceries?

              1      Yes
              2      No
                     DK, R

RAC_Q6C       (Because of any physical condition or mental condition or health problem,
RACE_6C       ^DOVERB ^YOU1 need the help of another person:)

              ... with doing everyday housework?

              1      Yes
              2      No
                     DK, R




Statistics Canada                                                                         57
Canadian Community Health Survey - Cycle 3.1

RAC_Q6D      (Because of any physical condition or mental condition or health problem,
RACE_6D      ^DOVERB ^YOU1 need the help of another person:)

             ... with doing heavy household chores such as spring cleaning or yard work?

             1      Yes
             2      No
                    DK, R

RAC_Q6E      (Because of any physical condition or mental condition or health problem,
RACE_6E      ^DOVERB ^YOU1 need the help of another person:)

             ... with personal care such as washing, dressing, eating or taking medication?

             1      Yes
             2      No
                    DK, R

RAC_Q6F      (Because of any physical condition or mental condition or health problem,
RACE_6F      ^DOVERB ^YOU1 need the help of another person:)

             ... with moving about inside the house?

             1      Yes
             2      No
                    DK, R

RAC_Q6G      (Because of any physical condition or mental condition or health problem,
RACE_6G      ^DOVERB ^YOU1 need the help of another person:)

             ... with looking after ^YOUR1 personal finances such as making bank
             transactions or paying bills?

             1      Yes
             2      No
                    DK, R

RAC_Q7A      Because of any physical condition or mental condition or health problem,
RACE_7A      ^DOVERB ^YOU1 have difficulty:

             … making new friends or maintaining friendships?

             1      Yes
             2      No
                    DK, R

RAC_Q7B      (Because of any physical condition or mental condition or health problem,
RACE_7B      ^DOVERB ^YOU1 have difficulty:)

             … dealing with people ^YOU1 ^DOVERB not know well?

             1      Yes
             2      No
                    DK, R




58                                                                            Statistics Canada
                                                  Canadian Community Health Survey - Cycle 3.1

RAC_Q7C       (Because of any physical condition or mental condition or health problem,
RACE_7C       ^DOVERB ^YOU1 have difficulty:)

              … starting and maintaining a conversation?

              1      Yes
              2      No
                     DK, R

RAC_C8        If any of RAC_Q6A to RAC_Q6G or RAC_Q7A to RAC_Q7C = 1, go to RAC_Q8.
              Otherwise, go to RAC_END.

RAC_Q8        Are these difficulties due to YOUR1 physical health, to YOUR1 emotional or mental
              health, to YOUR1 use of alcohol or drugs, or to another reason?
              INTERVIEWER: Mark all that apply.

RACE_8A       1      Physical health
RACE_8B       2      Emotional or mental health
RACE_8C       3      Use of alcohol or drugs
RACE_8D       4      Another reason – Specify
                     DK, R

RAC_C8S       If RAC_Q8 = 4, go to RAC_Q8S.
              Otherwise, go to RAC_END.

RAC_Q8S       INTERVIEWER: Specify.

              ___________________
              (80 spaces)
              DK, R

RAC_END




Statistics Canada                                                                           59
Canadian Community Health Survey - Cycle 3.1



TWO-WEEK DISABILITY (TWD)
TWD_BEG

TWD_C1       If (do TWD block = 1), go to TWD_QINT.
             Otherwise, go to TWD_END.

TWD_QINT     The next few questions ask about ^YOUR2 health during the past 14 days.
             It is important for you to refer to the 14-day period from [date two weeks ago] to
             [date yesterday].
             INTERVIEWER: Press <Enter> to continue.

TWD_Q1       During that period, did ^YOU2 stay in bed at all because of illness or injury,
TWDE_1       including any nights spent as a patient in a hospital?

             1       Yes
             2       No             (Go to TWD_Q3)
                     DK, R          (Go to TWD_END)

TWD_Q2       How many days did ^YOU1 stay in bed for all or most of the day?
TWDE_2       INTERVIEWER: Enter 0 if less than a day.

             |_|_|   Days
             (MIN: 0) (MAX: 14)

             DK, R           (Go to TWD_END)

TWD_C2A      If TWD_Q2 > 1, go to TWD_Q2B.

TWD_Q2A      Was that due to ^YOUR1 emotional or mental health or ^YOUR1 use of
TWDE_2A      alcohol or drugs?

             1       Yes
             2       No
                     DK, R

             Go to TWD_C3

TWD_Q2B      How many of these [TWD_Q2] days were due to ^YOUR1 emotional or mental
TWDE_2B      health or ^YOUR1 use of alcohol or drugs?
             INTERVIEWER: Minimum is 0; maximum is [TWD_Q2].

             |_|_|   Days
             (MIN: 0) (MAX: days in TWD_Q2)
             DK, R

Note:        In processing, if a respondent answered TWD_Q2A = 1, the variable TWD_Q2B is given
             the value of TWD_Q2.

TWD_C3       If TWD_Q2 = 14 days, go to TWD_END.




60                                                                              Statistics Canada
                                                 Canadian Community Health Survey - Cycle 3.1

TWD_Q3        [Not counting days spent in bed, during those 14 days,/During those 14 days,]
TWDE_3        were there any days that ^YOU2 cut down on things ^YOU1 normally ^DOVERB
              because of illness or injury?

              1      Yes
              2      No              (Go to TWD_Q5)
                     DK, R           (Go to TWD_Q5)

Note:         If TWD_Q1 = 2, use “During those 14 days,” in TWD_Q3.
              Otherwise, use “Not counting days spent in bed, during those 14 days,” in TWD_Q3.

TWD_Q4        How many days did ^YOU2 cut down on things for all or most of the day?
TWDE_4        INTERVIEWER: Enter 0 if less than a day. Maximum is [14 - TWD_Q2].

              |_|_|   Days
              (MIN: 0) (MAX: 14 - days in TWD_Q2)
              DK, R          (Go to TWD_Q5)

TWD_C4A       If TWD_Q4 > 1, go to TWD_Q4B.

TWD_Q4A       Was that due to ^YOUR1 emotional or mental health or ^YOUR1 use of
TWDE_4A       alcohol or drugs?

              1      Yes
              2      No
                     DK, R

              Go to TWD_Q5

TWD_Q4B       How many of these [TWD_Q4] days were due to ^YOUR1 emotional or mental
TWDE_4B       health or YOUR1 use of alcohol or drugs?
              INTERVIEWER: Minimum is 0; maximum is [TWD_Q4].

              |_|_|   Days
              (MIN: 0) (MAX: days in TWD_Q4)
              DK, R

Note:         In processing, if a respondent answered TWD_Q4A = 1, the variable TWD_Q4B is given
              the value of TWD_Q4.

TWD_Q5        [Not counting days spent in bed, during those 14 days,/During those 14 days,]
TWDE_5A       were there any days when it took extra effort to perform up to ^YOUR1 usual level
              at work or at ^YOUR1 other daily activities, because of illness or injury?

              1      Yes
              2      No    (Go to TWD_END)
                     DK, R (Go to TWD_END)

Note:         If TWD_Q1 = 2, use “During those 14 days,” in TWD_Q5.
              Otherwise, use “Not counting days spent in bed, during those 14 days,” in TWD_Q5.




Statistics Canada                                                                                 61
Canadian Community Health Survey - Cycle 3.1

TWD_Q6       How many days required extra effort?
TWDE_6       INTERVIEWER: Enter 0 if less than a day. Maximum is [14 - TWD_Q2].

             |_|_|   Days
             (MIN: 0) (MAX: 14 - days in TWD_Q2)
             DK, R          (Go to TWD_END)

TWD_C6A      If TWD_Q6 > 1, go to TWD_Q6B.
             Otherwise, go to TWD_Q6A.

TWD_Q6A      Was that due to ^YOUR1 emotional or mental health or ^YOUR1
TWDE_6A      use of alcohol or drugs?

             1      Yes
             2      No
                    DK, R

             Go to TWD_END

TWD_Q6B      How many of these [TWD_Q6] days were due to ^YOUR1 emotional or mental
TWDE_6B      health or YOUR1 use of alcohol or drugs?
             INTERVIEWER: Minimum is 0; maximum is [TWD_Q6].

             |_|_|   Days
             (MIN: 0) (MAX: days in TWD_Q6)
             DK, R

Note:        In processing, if a respondent answered TWD_Q6A = 1, the variable TWD_Q6B is given
             the value of TWD_Q6.

TWD_END




62                                                                            Statistics Canada
                                                   Canadian Community Health Survey - Cycle 3.1



FLU SHOTS (FLU)
FLU_BEG

FLU_C1        If (do FLU block = 1), then go to FLU_C160.
              Otherwise, go to FLU_END.

FLU_C160      If proxy interview, go to FLU_END.
              Otherwise, go to FLU_Q160.

FLU_Q160      Now a few questions about your use of various health care services.
FLUE_160      Have you ever had a flu shot?

              1      Yes
              2      No                               (Go to FLU_Q166)
                     DK, R                            (Go to FLU_END)

FLU_Q162      When did you have your last flu shot?
FLUE_162      INTERVIEWER: Read categories to respondent.

              1      Less than 1 year ago           (Go to FLU_END)
              2      1 year to less than 2 years ago
              3      2 years ago or more
                     DK, R                          (Go to FLU_END)

FLU_Q166      What are the reasons that you have not had a flu shot in the past year?
              INTERVIEWER: Mark all that apply.

FLUE_66A      1      Have not gotten around to it
FLUE_66B      2      Respondent - did not think it was necessary
FLUE_66C      3      Doctor - did not think it was necessary
FLUE_66D      4      Personal or family responsibilities
FLUE_66E      5      Not available - at time required
FLUE_66F      6      Not available - at all in the area
FLUE_66G      7      Waiting time was too long
FLUE_66H      8      Transportation - problems
FLUE_66I      9      Language - problem
FLUE_66J      10     Cost
FLUE_66K      11     Did not know where to go / uninformed
FLUE_66L      12     Fear (e.g., painful, embarrassing, find something wrong)
FLUE_66M      13     Bad reaction to previous shot
FLUE_66O      14     Unable to leave the house because of a health problem
FLUE_66N      15     Other - Specify
                     DK, R




Statistics Canada                                                                           63
Canadian Community Health Survey - Cycle 3.1

FLU_C166S    If FLU_Q166 = 15, go to FLU_Q166S.
             Otherwise, go to FLU_END.

FLU_Q166S    INTERVIEWER: Specify.

             _________________________
             (80 spaces)
             DK, R

FLU_END




64                                                Statistics Canada
                                                  Canadian Community Health Survey - Cycle 3.1



BLOOD PRESSURE CHECK (BPC)
BPC_BEG

BPC_C01       If (do BPC block = 2) or proxy interview, go to BPC_END.
BPCEFOPT      Otherwise, go to BPC_Q010.

BPC_Q010      (Now blood pressure)
BPCE_010      Have you ever had your blood pressure taken?

              1      Yes
              2      No                      (Go to BPC_C016)
                     DK, R                   (Go to BPC_END)

BPC_Q012      When was the last time?
BPCE_012
              1      Less than 6 months ago                  (Go to BPC_END)
              2      6 months to less than 1 year ago        (Go to BPC_END)
              3      1 year to less than 2 years ago         (Go to BPC_END)
              4      2 years to less than 5 years ago
              5      5 or more years ago
                     DK, R                                   (Go to BPC_END)

BPC_C016      If age < 25, go to BPC_END.
              Otherwise, go to BPC_Q016.

BPC_Q016      What are the reasons that you have not had your blood pressure taken in the past
              2 years?
              INTERVIEWER: Mark all that apply.

BPCE_16A      1      Have not gotten around to it
BPCE_16B      2      Respondent - did not think it was necessary
BPCE_16C      3      Doctor - did not think it was necessary
BPCE_16D      4      Personal or family responsibilities
BPCE_16E      5      Not available - at time required
BPCE_16F      6      Not available - at all in the area
BPCE_16G      7      Waiting time was too long
BPCE_16H      8      Transportation - problems
BPCE_16I      9      Language - problem
BPCE_16J      10     Cost
BPCE_16K      11     Did not know where to go / uninformed
BPCE_16L      12     Fear (e.g., painful, embarrassing, find something wrong)
BPCE_16N      13     Unable to leave the house because of a health problem
BPCE_16M      14     Other - Specify
                     DK, R




Statistics Canada                                                                           65
Canadian Community Health Survey - Cycle 3.1

BPC_C016S    If BPC_Q016 = 14, go to BPC_Q016S.
             Otherwise, go to BPC_END.

BPC_Q016S    INTERVIEWER: Specify.

             _________________________
             (80 spaces)
             DK, R

BPC_END




66                                                Statistics Canada
                                                  Canadian Community Health Survey - Cycle 3.1



PAP SMEAR TEST (PAP)
PAP_BEG

PAP_C1        If (do PAP block = 1), go to PAP_C020.
              Otherwise, go to PAP_END.

PAP_C020      If proxy interview or male or age < 18, go to PAP_END.
              Otherwise, go to PAP_Q020.

PAP_Q020      (Now PAP tests)
PAPE_020      Have you ever had a PAP smear test?

              1      Yes
              2      No    (Go to PAP_Q026)
                     DK, R (Go to PAP_END)

PAP_Q022      When was the last time?
PAPE_022
              1      Less than 6 months ago                  (Go to PAP_END)
              2      6 months to less than 1 year ago        (Go to PAP_END)
              3      1 year to less than 3 years ago         (Go to PAP_END)
              4      3 years to less than 5 years ago
              5      5 or more years ago
                     DK, R                                   (Go to PAP_END)

PAP_Q026      What are the reasons that you have not had a PAP smear test in the past 3 years?
              INTERVIEWER: Mark all that apply.

PAPE_26A      1      Have not gotten around to it
PAPE_26B      2      Respondent - did not think it was necessary
PAPE_26C      3      Doctor - did not think it was necessary
PAPE_26D      4      Personal or family responsibilities
PAPE_26E      5      Not available - at time required
PAPE_26F      6      Not available - at all in the area
PAPE_26G      7      Waiting time was too long
PAPE_26H      8      Transportation - problems
PAPE_26I      9      Language - problem
PAPE_26J      10     Cost
PAPE_26K      11     Did not know where to go / uninformed
PAPE_26L      12     Fear (e.g., painful, embarrassing, find something wrong)
PAPE_26M      13     Have had a hysterectomy
PAPE_26N      14     Hate / dislike having one done
PAPE_26P      15     Unable to leave the house because of a health problem
PAPE_26O      16     Other - Specify
                     DK, R




Statistics Canada                                                                            67
Canadian Community Health Survey - Cycle 3.1

PAP_C026S    If PAP_Q026 = 16, go to PAP_Q026S.
             Otherwise, go to PAP_END.

PAP_Q026S    INTERVIEWER: Specify.

             ____________________________
             (80 spaces)
             DK, R
PAP_END




68                                                Statistics Canada
                                                  Canadian Community Health Survey - Cycle 3.1



MAMMOGRAPHY (MAM)
MAM_BEG

MAM_C1        If (do MAM block = 1), go to MAM_C030.
              Otherwise, go to MAM_END.

MAM_C030      If proxy interview or male, go to MAM_END.
              Otherwise, go to MAM_C030A.

MAM_C030A     If (female and age < 35), go to MAM_C037.
              Otherwise, go to MAM_Q030.

MAM_Q030      (Now Mammography)
MAME_030      Have you ever had a mammogram, that is, a breast x-ray?

              1      Yes
              2      No    (Go to MAM_C036)
                     DK, R (Go to MAM_END)

MAM_Q031      Why did you have it?
              INTERVIEWER: Mark all that apply.
              If respondent says “doctor recommended it”, probe for reason.

MAME_31A      1      Family history of breast cancer
MAME_31B      2      Part of regular check-up / routine screening
MAME_31C      3      Age
MAME_31D      4      Previously detected lump
MAME_31E      5      Follow-up of breast cancer treatment
MAME_31F      6      On hormone replacement therapy
MAME_31G      7      Breast problem
MAME_31H      8      Other - Specify
                     DK, R

MAM_C031S     If MAM_Q031 = 8, go to MAM_Q031S.
              Otherwise, go to MAM_Q032.

MAM_Q031S     INTERVIEWER: Specify.

              _______________________________
              (80 spaces)
              DK, R

MAM_Q032      When was the last time?
MAME_032
              1      Less than 6 months ago                   (Go to MAM_C037)
              2      6 months to less than 1 year ago         (Go to MAM_C037)
              3      1 year to less than 2 years ago          (Go to MAM_C037)
              4      2 years to less than 5 years ago
              5      5 or more years ago
                     DK, R                                    (Go to MAM_C037)




Statistics Canada                                                                          69
Canadian Community Health Survey - Cycle 3.1

MAM_C036     If age < 50 or age > 69, go to MAM_C037.
             Otherwise, go to MAM_Q036.

MAM_Q036     What are the reasons you have not had one in the past 2 years?
             INTERVIEWER: Mark all that apply.

MAME_36A     1      Have not gotten around to it
MAME_36B     2      Respondent - did not think it was necessary
MAME_36C     3      Doctor - did not think it was necessary
MAME_36D     4      Personal or family responsibilities
MAME_36E     5      Not available - at time required
MAME_36F     6      Not available - at all in the area
MAME_36G     7      Waiting time was too long
MAME_36H     8      Transportation - problems
MAME_36I     9      Language - problem
MAME_36J     10     Cost
MAME_36K     11     Did not know where to go / uninformed
MAME_36L     12     Fear (e.g., painful, embarrassing, find something wrong)
MAME_36N     13     Unable to leave the house because of a health problem
MAME_36O     14     Breasts removed / Mastectomy
MAME_36M     15     Other - Specify
                    DK, R

MAM_C036S    If MAM_Q036 = 15, go to MAM_Q036S.
             Otherwise, go to MAM_C037.

MAM_Q036S    INTERVIEWER: Specify.

             _______________________________
             (80 spaces)
             DK, R

MAM_C037     If (age < 15 or age > 49), go to MAM_C038.
             Otherwise, go to MAM_Q037.

MAM_Q037     It is important to know when analyzing health whether or not the person is
MAME_037     pregnant. Are you pregnant?

             1      Yes   (Go to MAM_END)
             2      No
                    DK, R




70                                                                             Statistics Canada
                                                Canadian Community Health Survey - Cycle 3.1

MAM_C038      If age < 18, go to MAM_END.
              Otherwise, go to MAM_C038A.

MAM_C038A     If PAP_Q026 = 13, go to MAM_END.
              Otherwise, go to MAM_Q038.

MAM_Q038      Have you had a hysterectomy? (in other words, has your uterus been removed)?
MAME_038
              1      Yes
              2      No
                     DK, R

Note:         In processing, if a respondent answered MAM_Q037 = 1, the variable MAM_Q038 is
              given the value of 2.

MAM_END




Statistics Canada                                                                              71
Canadian Community Health Survey - Cycle 3.1



BREAST EXAMINATIONS (BRX)
BRX_BEG

BRX_C1       If (do BRX block = 1), go to BRX_C110.
BRXEFOPT     Otherwise, go to BRX_END.

BRX_C110     If proxy interview or sex = male or age < 18, go to BRX_END.
             Otherwise, go to BRX_Q110.

BRX_Q110     (Now breast examinations)
BRXE_110     Other than a mammogram, have you ever had your breasts examined for lumps
             (tumours, cysts) by a doctor or other health professional?

             1      Yes
             2      No              (Go to BRX_Q116)
                    DK, R           (Go to BRX_END)

BRX_Q112     When was the last time?
BRXE_112
             1      Less than 6 months ago                  (Go to BRX_END)
             2      6 months to less than 1 year ago        (Go to BRX_END)
             3      1 year to less than 2 years ago         (Go to BRX_END)
             4      2 years to less than 5 years ago
             5      5 or more years ago
                    DK, R                                   (Go to BRX_END)

BRX_Q116     What are the reasons that you have not had a breast exam in the past 2 years?
             INTERVIEWER: Mark all that apply.

BRXE_16A     1      Have not gotten around to it
BRXE_16B     2      Respondent - did not think it was necessary
BRXE_16C     3      Doctor - did not think it was necessary
BRXE_16D     4      Personal or family responsibilities
BRXE_16E     5      Not available - at time required
BRXE_16F     6      Not available - at all in the area
BRXE_16G     7      Waiting time was too long
BRXE_16H     8      Transportation - problems
BRXE_16I     9      Language - problem
BRXE_16J     10     Cost
BRXE_16K     11     Did not know where to go / uninformed
BRXE_16L     12     Fear (e.g., painful, embarrassing, find something wrong)
BRXE_16N     13     Unable to leave the house because of a health problem
BRXE_16O     14     Breasts removed / mastectomy
BRXE_16M     15     Other - Specify
                    DK, R




72                                                                             Statistics Canada
                                              Canadian Community Health Survey - Cycle 3.1

BRX_C116S     If BRX_Q116 = 15, go to BRX_Q116S.
              Otherwise, go to BRX_END.

BRX_Q116S     INTERVIEWER: Specify.

              _________________________
              (80 spaces)
              DK, R

BRX_END




Statistics Canada                                                                      73
Canadian Community Health Survey - Cycle 3.1



BREAST SELF-EXAMINATIONS (BSX)
BSX_BEG

BSX_C120A    If (do BSX block = 1), go to BSX_C120B.
BSXEOPT      Otherwise, go to BSX_END.

BSX_C120B    If proxy interview, go to BSX_END.
             Otherwise, go to BSX_C120C.

BSX_C120C    If male or age < 18, go to BSX_END.
             Otherwise, go to BSX_Q120.

BSX_Q120     (Now breast self examinations)
BSXE_120     Have you ever examined your breasts for lumps (tumours, cysts)?

             1      Yes
             2      No              (Go to BSX_END)
                    DK, R           (Go to BSX_END)

BSX_Q121     How often?
BSXE_121
             1      At least once a month
             2      Once every 2 to 3 months
             3      Less often than every 2 to 3 months
                    DK, R

BSX_Q122     How did you learn to do this?
             INTERVIEWER: Mark all that apply.

BSXE_22A     1      Doctor
BSXE_22B     2      Nurse
BSXE_22C     3      Book / magazine / pamphlet
BSXE_22D     4      TV / video / film
BSXE_22H     5      Family member (e.g., mother, sister, cousin)
BSXE_22G     6      Other - Specify
                    DK, R

BSX_C122S    If BSX_Q122 = 6, go to BSX_ Q122S.
             Otherwise, go to BSX_END.

BSX_Q122S    INTERVIEWER: Specify.

             _________________________
             (80 spaces)
             DK, R

BSX_END




74                                                                         Statistics Canada
                                                  Canadian Community Health Survey - Cycle 3.1



EYE EXAMINATIONS (EYX)
EYX_BEG

EYX_C140A     If (EYX block = 2) or proxy interview, go to EYX_END.
EYXEFOPT      Otherwise, go to EYX_C140B.

EYX_C140B     If HCU_Q02B = 0, DK or R (not seen or talked to eye doctor), go to EYX_Q142.
              Otherwise, go to EYX_Q140.

EYX_Q140      (Now eye examinations)
EYXE_140      It was reported earlier that you have “seen” or “talked to” an optometrist or
              ophthalmologist in the past 12 months. Did you actually visit one?

              1      Yes
              2      No
                     DK, R (Go to EYX_END)

EYX_Q142      When did you last have an eye examination?
EYXE_142
              1      Less than 1 year ago                    (Go to EYX_END)
              2      1 year to less than 2 years ago         (Go to EYX_END)
              3      2 years to less than 3 years ago
              4      3 or more years ago
              5      Never
                     DK, R                                   (Go to EYX_END)

Note:         In processing, if a respondent answered EYX_Q140 = 1, the variable EYX_Q142 is given
              the value of 1.

EYX_Q146      What are the reasons that you have not had an eye examination in the past
              2 years?
              INTERVIEWER: Mark all that apply.

EYXE_46A      1      Have not gotten around to it
EYXE_46B      2      Respondent - did not think it was necessary
EYXE_46C      3      Doctor - did not think it was necessary
EYXE_46D      4      Personal or family responsibilities
EYXE_46E      5      Not available - at time required
EYXE_46F      6      Not available - at all in the area
EYXE_46G      7      Waiting time was too long
EYXE_46H      8      Transportation - problems
EYXE_46I      9      Language - problem
EYXE_46J      10     Cost
EYXE_46K      11     Did not know where to go / uninformed
EYXE_46L      12     Fear (e.g., painful, embarrassing, find something wrong)
EYXE_46N      13     Unable to leave the house because of a health problem
EYXE_46M      14     Other – Specify
                     DK, R




Statistics Canada                                                                              75
Canadian Community Health Survey - Cycle 3.1

EYX_C146S    If EYX_Q146 = 14, go to EYX_Q146S.
             Otherwise, go to EYX_END.

EYX_Q146S    INTERVIEWER: Specify.

             _________________________
             (80 spaces)
             DK, R

EYX_END




76                                                Statistics Canada
                                                    Canadian Community Health Survey - Cycle 3.1



PHYSICAL CHECK-UP (PCU)
PCU_BEG

PCU_C1        If (PCU block = 1), go to PCU_C150.
PCUEFOPT      Otherwise go to PCU_END.

PCU_C150      If proxy interview, go to PCU_END.
              Otherwise, go to PCU_Q150.

PCU_Q150      (Now physical check-ups)
PCUE_150      Have you ever had a physical check-up without having a specific health problem?

              1      Yes   (Go to PCU_Q152)
              2      No
                     DK, R (Go to PCU_END)

PCU_Q151      Have you ever had one during a visit for a health problem?
PCUE_151
              1      Yes
              2      No    (Go to PCU_Q156)
                     DK, R (Go to PCU_END)

PCU_Q152      When was the last time?
PCUE_152
              1      Less than 1 year ago                    (Go to PCU_END)
              2      1 year to less than 2 years ago         (Go to PCU_END)
              3      2 years to less than 3 years ago        (Go to PCU_END)
              4      3 years to less than 4 years ago
              5      4 years to less than 5 years ago
              6      5 or more years ago
                     DK, R                                   (Go to PCU_END)

PCU_Q156      What are the reasons that you have not had a check-up in the past 3 years?
              INTERVIEWER: Mark all that apply.

PCUE_56A      1      Have not gotten around to it
PCUE_56B      2      Respondent - did not think it was necessary
PCUE_56C      3      Doctor - did not think it was necessary
PCUE_56D      4      Personal or family responsibilities
PCUE_56E      5      Not available - at time required
PCUE_56F      6      Not available - at all in the area
PCUE_56G      7      Waiting time was too long
PCUE_56H      8      Transportation - problems
PCUE_56I      9      Language - problem
PCUE_56J      10     Cost
PCUE_56K      11     Did not know where to go / uninformed
PCUE_56L      12     Fear (e.g., painful, embarrassing, find something wrong)
PCUE_56N      13     Unable to leave the house because of a health problem
PCUE_56M      14     Other - Specify
                     DK, R




Statistics Canada                                                                            77
Canadian Community Health Survey - Cycle 3.1

PCU_C156S    If PCU_Q156 = 14, go to PCU_Q156S.
             Otherwise, go to PCU_END.

PCU_Q156S    INTERVIEWER: Specify.

             _______________________________
             (80 spaces)
             DK, R

PCU_END




78                                                Statistics Canada
                                                   Canadian Community Health Survey - Cycle 3.1



PROSTATE CANCER SCREENING (PSA)
PSA_BEG

PSA_C1        If (do PSA block = 1), go to PSA_C170.
PSAEFOPT      Otherwise, go to PSA_END.

PSA_C170      If proxy interview, go to PSA_END.
              Otherwise, go to PSA_C170A.

PSA_C170A     If female or age < 35, go to PSA_END.
              Otherwise, go to PSA_Q170.

PSA_Q170      (Now Prostate tests)
PSAE_170      Have you ever had a prostate specific antigen test for prostate cancer, that is, a
              PSA blood test?

              1       Yes
              2       No              (Go to PSA_Q174)
                      DK              (Go to PSA_Q174)
                      R               (Go to PSA_END)

PSA_Q172      When was the last time?
PSAE_172
              1       Less than 1 year ago
              2       1 year to less than 2 years ago
              3       2 years to less than 3 years ago
              4       3 years to less than 5 years ago
              5       5 or more years ago
                      DK, R

PSA_Q173      Why did you have it?
              INTERVIEWER: Mark all that apply.

              If respondent says ‘Doctor recommended it’ or ‘I requested it’, probe for reason.

PSAE_73A      1       Family history of prostate cancer
PSAE_73B      2       Part of regular check-up / routine screening
PSAE_73C      3       Age
PSAE_73G      4       Race
PSAE_73D      5       Follow-up of problem
PSAE_73E      6       Follow-up of prostate cancer treatment
PSAE_73F      7       Other - Specify
                      DK, R

PSA_C173S     If PSA_Q173 = 7, go to PSA_Q173S.
              Otherwise, go to PSA_Q174.

PSA_Q173S     INTERVIEWER: Specify.

              ________________________
              (80 spaces)
              DK, R




Statistics Canada                                                                                  79
Canadian Community Health Survey - Cycle 3.1

PSA_Q174     A Digital Rectal Exam is an exam in which a gloved finger is inserted into the
PSAE_174     rectum in order to feel the prostate gland.
             Have you ever had this exam?

             1      Yes
             2      No    (Go to PSA_END)
                    DK, R (Go to PSA_END)

PSA_Q175     When was the last time?
PSAE_175
             1      Less than 1 year ago
             2      1 year to less than 2 years ago
             3      2 years to less than 3 years ago
             4      3 years to less than 5 years ago
             5      5 or more years ago
                    DK, R

PSA_END




80                                                                             Statistics Canada
                                                   Canadian Community Health Survey - Cycle 3.1



COLORECTAL CANCER SCREENING (CCS)
CCS_BEG

CCS_C1        If (do CCS block = 1), go to CCS_C180.
CCSEFOPT      Otherwise, go to CCS_END.

CCS_C180      If proxy interview or age < 35, go to CCS_END.
              Otherwise, go to CCS_Q180.

CCS_Q180      Now a few questions about various colorectal exams.
CCSE_180
              An FOBT is a test to check for blood in your stool, where you have a bowel
              movement and use a stick to smear a small sample on a special card.

              Have you ever had this test?

              1       Yes
              2       No              (Go to CCS_Q184)
                      DK              (Go to CCS_Q184)
                      R               (Go to CCS_END)

CCS_Q182      When was the last time?
CCSE_182
              1       Less than 1 year ago
              2       1 year to less than 2 years ago
              3       2 years to less than 3 years ago
              4       3 years to less than 5 years ago
              5       5 years to less than 10 years ago
              6       10 or more years ago
                      DK, R

CCS_Q183      Why did you have it?
              INTERVIEWER: Mark all that apply.
              If respondent says ‘Doctor recommended it’ or ‘I requested it’, probe for reason.

CCSE_83A      1       Family history of colorectal cancer
CCSE_83B      2       Part of regular check-up / routine screening
CCSE_83C      3       Age
CCSE_83G      4       Race
CCSE_83D      5       Follow-up of problem
CCSE_83E      6       Follow-up of colorectal cancer treatment
CCSE_83F      7       Other - Specify
                      DK, R




Statistics Canada                                                                                 81
Canadian Community Health Survey - Cycle 3.1

CCS_C183S    If CCS_Q183 = 7, go to CCS_Q183S.
             Otherwise, go to CCS_Q184.

CCS_Q183S    INTERVIEWER: Specify.

             ________________________
             (80 spaces)
             DK, R

CCS_Q184     A colonoscopy or sigmoidoscopy is when a tube is inserted into the rectum
CCSE_184     to view the bowel for early signs of cancer and other health problems.
             Have you ever had either of these exams?

             1       Yes
             2       No    (Go to CCS_END)
                     DK, R (Go to CCS_END)

CCS_Q185     When was the last time?
CCSE_185
             1       Less than 1 year ago
             2       1 year to less than 2 years ago
             3       2 years to less than 3 years ago
             4       3 years to less than 5 years ago
             5       5 years to less than 10 years ago
             6       10 or more years ago
                     DK, R

CCS_Q186     Why did you have it?
             INTERVIEWER: Mark all that apply.
             If respondent says “Doctor recommended it” or “I requested it”, probe for reason.

CCSE_86A     1       Family history of colorectal cancer
CCSE_86B     2       Part of regular check-up / routine screening
CCSE_86C     3       Age
CCSE_86G     4       Race
CCSE_86D     5       Follow-up of problem
CCSE_86E     6       Follow-up of colorectal cancer treatment
CCSE_86F     7       Other - Specify
                     DK, R

CCS_C186S    If CCS_Q186 = 7, go to CCS_Q186S.
             Otherwise, go to CCS_C187.




82                                                                                 Statistics Canada
                                              Canadian Community Health Survey - Cycle 3.1

CCS_Q186S     INTERVIEWER: Specify.

              ________________________
              (80 spaces)
              DK, R

CCS_C187      If CCS_Q180 = 1 (had a FOBT), go to CCS_Q187.
              Otherwise, go to CCS_END.

CCS_Q187      Was the colonoscopy or sigmoidoscopy a follow-up of the results of an FOBT?
CCSE_187

              1      Yes
              2      No
                     DK, R

CCS_END




Statistics Canada                                                                           83
Canadian Community Health Survey - Cycle 3.1



DENTAL VISITS (DEN)
DEN_BEG

DEN_C130A    If (do DEN block = 1), go to DEN_C130B.
DENEFOPT     Otherwise, go to DEN_END.

DEN_C130B    If proxy interview, go to DEN_END.
             Otherwise, go to DEN_C130C.

DEN_C130C    If HCU_Q02E = 0, DK or R, go to DEN_C132.
             Otherwise, go to DEN_Q130.

DEN_Q130     Now dental visits
DENE_130     It was reported earlier that you have “seen” or “talked to” a dentist in the past
             12 months. Did you actually visit one?

             1       Yes   (Go to DEN_END)
             2       No
                     DK, R (Go to DEN_END)

DEN_C132     If HCU_Q02E = 0, DK, R, go to DEN_R132.
             Otherwise, go to DEN_Q132.

DEN_R132     Now dental visits

DEN_Q132     When was the last time that you went to a dentist?
DENE_132
             1       Less than 1 year ago
             2       1 year to less than 2 years ago           (Go to DEN_END)
             3       2 years to less than 3 years ago          (Go to DEN_END)
             4       3 years to less than 4 years ago          (Go to DEN_Q136)
             5       4 years to less than 5 years ago          (Go to DEN_Q136)
             6       5 or more years ago                       (Go to DEN_Q136)
             7       Never                                     (Go to DEN_Q136)
                     DK, R                                     (Go to DEN_END)

Note:        In processing, if a respondent answered DEN_Q130 = 1, the variable DEN_Q132 is
             given the value of 1.

DEN_E132     Inconsistent answers have been entered. The respondent went to a dentist less than 1
             year ago but previously reported that he/she had not “seen” or “talked” to a dentist in the
             past 12 months. Please confirm.

             Trigger soft edit if DEN_Q132 = 1 and HCU_Q02E = 0.

             If DEN_Q132 = 1, go to DEN_END.




84                                                                                   Statistics Canada
                                                 Canadian Community Health Survey - Cycle 3.1

DEN_Q136      What are the reasons that you have not been to a dentist in the past 3 years?
              INTERVIEWER: Mark all that apply.

DENE_36A      1      Have not gotten around to it
DENE_36B      2      Respondent - did not think it was necessary
DENE_36C      3      Dentist - did not think it was necessary
DENE_36D      4      Personal or family responsibilities
DENE_36E      5      Not available - at time required
DENE_36F      6      Not available - at all in the area
DENE_36G      7      Waiting time was too long
DENE_36H      8      Transportation - problems
DENE_36I      9      Language - problem
DENE_36J      10     Cost
DENE_36K      11     Did not know where to go / uninformed
DENE_36L      12     Fear (e.g., painful, embarrassing, find something wrong)
DENE_36M      13     Wears dentures
DENE_36O      14     Unable to leave the house because of a health problem
DENE_36N      15     Other – Specify
                     DK, R

DEN_C136S     If DEN_Q136 = 15, go to DEN_Q136S.
              Otherwise, go to DEN_END.

DEN_Q136S     INTERVIEWER: Specify.

              ________________________
              (80 spaces)
              DK, R

DEN_END




Statistics Canada                                                                             85
Canadian Community Health Survey - Cycle 3.1



ORAL HEALTH 2 (OH2)
OH2_BEG

OH2_C10A     If (do OH2 block = 1), go to OH2_C10B.
OH2EFOPT     Otherwise, go to OH2_END.

OH2_C10B     If proxy interview, go to OH2_END.
             Otherwise, go to OH2_C10C.

OH2_C10C     If DEN_Q132 = 7 (never goes to dentist), go to OH2_Q11.
             Otherwise, go to OH2_Q10.

OH2_Q10      Do you usually visit the dentist:
OH2E_10      INTERVIEWER: Read categories to respondent.

             1      … more than once a year for check-ups?
             2      … about once a year for check-ups?
             3      … less than once a year for check-ups?
             4      … only for emergency care?
                    DK, R         (Go to OH2_END)

OH2_Q11      Do you have insurance that covers all or part of your dental expenses?
OH2E_11
             1      Yes
             2      No              (Go to OH2_C12)
                    DK, R           (Go to OH2_C12)

OH2_Q11A     Is it:
             INTERVIEWER: Read categories to respondent. Mark all that apply.

OH2E_11A     1      … a government-sponsored plan?
OH2E_11B     2      … an employer-sponsored plan?
OH2E_11C     3      … a private plan?
                    DK, R

OH2_C12      If DEN_Q130 = 1 or DEN_Q132 = 1, go to OH2_Q12.
             Otherwise, go to OH2_Q20.

OH2_Q12      In the past 12 months, have you had any teeth removed by a dentist?
OH2E_12
             1      Yes
             2      No    (Go to OH2_Q20)
                    DK, R (Go to OH2_Q20)

OH2_Q13      (In the past 12 months,) were any teeth removed because of decay or gum
OH2E_13      disease?

             1      Yes
             2      No
                    DK, R




86                                                                              Statistics Canada
                                                 Canadian Community Health Survey - Cycle 3.1

OH2_Q20       Do you have one or more of your own teeth?
OH2E_20
              1      Yes
              2      No
                     DK, R

OH2_C21       If DEN_Q136 = 13, go to OH2_Q22.
              Otherwise, go to OH2_Q21.

OH2_Q21       Do you wear dentures or false teeth?
OH2E_21
              1      Yes
              2      No
                     DK, R

Note:         In processing, if a respondent answered DEN_Q136 = 13, the variable OH2_Q21 is given
              the value of 1.

OH2_R22       Now we have some additional questions about oral health, that is the health of
              your teeth and mouth.
              INTERVIEWER: Press <Enter> to continue.

OH2_Q22       Because of the condition of your [teeth, mouth or dentures/teeth or mouth], do you
OH2E_22       have difficulty pronouncing any words or speaking clearly?

              1      Yes
              2      No
                     DK, R

Note:         If OH2_Q21= 1 or DEN_Q136 = 13, use “teeth, mouth or dentures”.
              Otherwise, use “teeth or mouth”.

OH2_Q23       In the past 12 months, how often have you avoided:
OH2E_23
              ... conversation or contact with other people, because of the condition of your
              [teeth, mouth or dentures/teeth or mouth]?
              INTERVIEWER: Read categories to respondent.

              1      Often
              2      Sometimes
              3      Rarely
              4      Never
                     DK, R

Note:         If OH2_Q21= 1 or DEN_Q136 = 13, use “teeth, mouth or dentures”.
              Otherwise, use “teeth or mouth”.




Statistics Canada                                                                               87
Canadian Community Health Survey - Cycle 3.1

OH2_Q24      (In the past 12 months, how often have you avoided:)
OH2E_24
             ... laughing or smiling, because of the condition of your [teeth, mouth or
             dentures/teeth or mouth]?

             1      Often
             2      Sometimes
             3      Rarely
             4      Never
                    DK, R

Note:        If OH2_Q21= 1 or DEN_Q136 = 13, use “teeth, mouth or dentures”.
             Otherwise, use “teeth or mouth”.

OH2_R25      Now some questions about the health of your teeth and mouth during the past
             month.
             INTERVIEWER: Press <Enter> to continue.

OH2_Q25A     In the past month, have you had:
OH2E_25A
             … a toothache?

             1      Yes
             2      No
                    DK, R

OH2_Q25B     In the past month, were your teeth:
OH2E_25B
             … sensitive to hot or cold food or drinks?

             1      Yes
             2      No
                    DK, R

OH2_Q25C     In the past month, have you had:
OH2E_25C
             … pain in or around the jaw joints?

             1      Yes
             2      No
                    DK, R

OH2_Q25D     (In the past month, have you had:)
OH2E_25D
             … other pain in the mouth or face?

             1      Yes
             2      No
                    DK, R




88                                                                              Statistics Canada
                                                   Canadian Community Health Survey - Cycle 3.1

OH2_Q25E      (In the past month, have you had:)
OH2E_25E
              … bleeding gums?

              1      Yes
              2      No
                     DK, R

OH2_Q25F      (In the past month, have you had:)
OH2E_25F
              … dry mouth?
              INTERVIEWER: Do not include thirst caused by exercise.

              1      Yes
              2      No
                     DK, R

OH2_Q25G      (In the past month, have you had:)
OH2E_25G
              … bad breath?

              1      Yes
              2      No
                     DK, R

OH2_C30       If OH2_Q20 = 1, go to OH2_Q30.
              Otherwise, go to OH2_END.

OH2_Q30       How often do you brush your teeth?
OH2E_30
              1      More than twice a day
              2      Twice a day
              3      Once a day
              4      Less than once a day but more than once a week
              5      Once a week
              6      Less than once a week
                     DK, R

OH2_END




Statistics Canada                                                                           89
Canadian Community Health Survey - Cycle 3.1



FOOD CHOICES (FDC)
FDC_BEG

FDC_C1A      If (do FDC block = 1), go to FDC_C1B.
FDCEFOPT     Otherwise, go to FDC_END.

FDC_C1B      If proxy interview, go to FDC_END.
             Otherwise, go to FDC_QINT.

FDC_QINT     Now, some questions about the foods you eat.
             INTERVIEWER: Press <Enter> to continue.

FDC_Q1A      Do you choose certain foods or avoid others:
FDCE_1A
             … because you are concerned about your body weight?

             1      Yes (or sometimes)
             2      No
                    DK, R          (Go to FDC_END)

FDC_Q1B      (Do you choose certain foods or avoid others:)
FDCE_1B
             … because you are concerned about heart disease?

             1      Yes (or sometimes)
             2      No
                    DK, R

FDC_Q1C      (Do you choose certain foods or avoid others:)
FDCE_1C
             … because you are concerned about cancer?

             1      Yes (or sometimes)
             2      No
                    DK, R

FDC_Q1D      (Do you choose certain foods or avoid others:)
FDCE_1D
             … because you are concerned about osteoporosis (brittle bones)?

             1      Yes (or sometimes)
             2      No
                    DK, R

FDC_Q2A      Do you choose certain foods because of:
FDCE_2A
             … the lower fat content?

             1      Yes (or sometimes)
             2      No
                    DK, R




90                                                                         Statistics Canada
                                                Canadian Community Health Survey - Cycle 3.1

FDC_Q2B       (Do you choose certain foods because of:)
FDCE_2B
              … the fibre content?

              1      Yes (or sometimes)
              2      No
                     DK, R

FDC_Q2C       (Do you choose certain foods because of:)
FDCE_2C
              … the calcium content?

              1      Yes (or sometimes)
              2      No
                     DK, R

FDC_Q3A       Do you avoid certain foods because of:
FDCE_3A
              … the fat content?

              1      Yes (or sometimes)
              2      No
                     DK, R

FDC_Q3B       (Do you avoid certain foods because of:)
FDCE_3B
              … the type of fat they contain?

              1      Yes (or sometimes)
              2      No
                     DK, R

FDC_Q3C       (Do you avoid certain foods because of:)
FDCE_3C
              … the salt content?

              1      Yes (or sometimes)
              2      No
                     DK, R

FDC_Q3D       (Do you avoid certain foods because of:)
FDCE_3D
              … the cholesterol content?

              1      Yes (or sometimes)
              2      No
                     DK, R




Statistics Canada                                                                        91
Canadian Community Health Survey - Cycle 3.1

FDC_Q3E      (Do you avoid certain foods because of:)
FDCE_3E
             … the calorie content?

             1      Yes (or sometimes)
             2      No
                    DK, R

FDC_END




92                                                      Statistics Canada
                                                  Canadian Community Health Survey - Cycle 3.1



FRUIT AND VEGETABLE CONSUMPTION (FVC)
FVC_BEG

Note:         This module was collected as optional content and as part of a sub-sample.

FVC_C1A       If (do FVC block = 2) or proxy interview, go to FVC_END.
FVCEFOPT      Otherwise, go to FVC_QINT.

FVC_QINT      The next questions are about the foods you usually eat or drink. Think about all the
              foods you eat, both meals and snacks, at home and away from home.
              INTERVIEWER: Press <Enter> to continue.

FVC_Q1A       How often do you usually drink fruit juices such as orange, grapefruit or tomato?
FVCE_1A       (For example: once a day, three times a week, twice a month)
              INTERVIEWER: Select the reporting period here and enter the number in the next
              screen.

              1      Per day
              2      Per week        (Go to FVC_N1C)
              3      Per month       (Go to FVC_N1D)
              4      Per year        (Go to FVC_N1E)
              5      Never           (Go to FVC_Q2A)
                     DK, R           (Go to FVC_END)

FVC_N1B       INTERVIEWER: Enter number of times per day.
FVCE_1B
              l_l_l   Times
              (MIN: 1) (MAX: 20)
              DK, R

              Go to FVC_Q2A

FVC_N1C       INTERVIEWER: Enter number of times per week.
FVCE_1C
              l_l_l   Times
              (MIN: 1) (MAX: 90)
              DK, R

              Go to FVC_Q2A

FVC_N1D       INTERVIEWER: Enter number of times per month.
FVCE_1D
              l_l_l_l Times
              (MIN: 1) (MAX: 200)
              DK, R

              Go to FVC_Q2A

FVC_N1E       INTERVIEWER: Enter number of times per year.
FVCE_1E
              l_l_l_l Times
              (MIN: 1) (MAX: 500)
              DK, R



Statistics Canada                                                                              93
Canadian Community Health Survey - Cycle 3.1

FVC_Q2A      Not counting juice, how often do you usually eat fruit?
FVCE_2A      INTERVIEWER: Select the reporting period here and enter the number in the next
             screen.

             1      Per day
             2      Per week        (Go to FVC_N2C)
             3      Per month       (Go to FVC_N2D)
             4      Per year        (Go to FVC_N2E)
             5      Never           (Go to FVC_Q3A)
                    DK, R           (Go to FVC_Q3A)

FVC_N2B      INTERVIEWER: Enter number of times per day.
FVCE_2B
             l_l_l   Times
             (MIN: 1) (MAX: 20)
             DK, R

             Go to FVC_Q3A

FVC_N2C      INTERVIEWER: Enter number of times per week.
FVCE_2C
             l_l_l   Times
             (MIN: 1) (MAX: 90)
             DK, R

             Go to FVC_Q3A

FVC_N2D      INTERVIEWER: Enter number of times per month.
FVCE_2D
             l_l_l_l Times
             (MIN: 1) (MAX: 200)
             DK, R

             Go to FVC_Q3A

FVC_N2E      INTERVIEWER: Enter number of times per year.
FVCE_2E
             l_l_l_l Times
             (MIN: 1) (MAX: 500)
             DK, R




94                                                                             Statistics Canada
                                                 Canadian Community Health Survey - Cycle 3.1

FVC_Q3A       How often do you (usually) eat green salad?
FVCE_3A       INTERVIEWER: Select the reporting period here and enter the number in the next
              screen.

              1      Per day
              2      Per week        (Go to FVC_N3C)
              3      Per month       (Go to FVC_N3D)
              4      Per year        (Go to FVC_N3E)
              5      Never           (Go to FVC_Q4A)
                     DK, R           (Go to FVC_Q4A)

FVC_N3B       INTERVIEWER: Enter number of times per day.
FVCE_3B
              l_l_l   Times
              (MIN: 1) (MAX: 20)
              DK, R

              Go to FVC_Q4A

FVC_N3C       INTERVIEWER: Enter number of times per week.
FVCE_3C
              l_l_l   Times
              (MIN: 1) (MAX: 90)
              DK, R

              Go to FVC_Q4A

FVC_N3D       INTERVIEWER: Enter number of times per month.
FVCE_3D
              l_l_l_l Times
              (MIN: 1) (MAX: 200)
              DK, R

              Go to FVC_Q4A

FVC_N3E       INTERVIEWER: Enter number of times per year.
FVCE_3E
              l_l_l_l Times
              (MIN: 1) (MAX: 500)
              DK, R




Statistics Canada                                                                              95
Canadian Community Health Survey - Cycle 3.1

FVC_Q4A      How often do you usually eat potatoes, not including french fries, fried potatoes,
FVCE_4A      or potato chips?
             INTERVIEWER: Select the reporting period here and enter the number in the next
             screen.

             1      Per day
             2      Per week        (Go to FVC_N4C)
             3      Per month       (Go to FVC_N4D)
             4      Per year        (Go to FVC_N4E)
             5      Never           (Go to FVC_Q5A)
                    DK, R           (Go to FVC_Q5A)

FVC_N4B      INTERVIEWER: Enter number of times per day.
FVCE_4B
             l_l_l   Times
             (MIN: 1) (MAX: 20)
             DK, R

             Go to FVC_Q5A

FVC_N4C      INTERVIEWER: Enter number of times per week.
FVCE_4C
             l_l_l   Times
             (MIN: 1) (MAX: 90)
             DK, R

             Go to FVC_Q5A

FVC_N4D      INTERVIEWER: Enter number of times per month.
FVCE_4D
             l_l_l_l Times
             (MIN: 1) (MAX: 200)
             DK, R

             Go to FVC_Q5A

FVC_N4E      INTERVIEWER: Enter number of times per year.
FVCE_4E
             l_l_l_l Times
             (MIN: 1) (MAX: 500)
             DK, R




96                                                                             Statistics Canada
                                                 Canadian Community Health Survey - Cycle 3.1

FVC_Q5A       How often do you (usually) eat carrots?
FVCE_5A       INTERVIEWER: Select the reporting period here and enter the number in the next
              screen.

              1      Per day
              2      Per week        (Go to FVC_N5C)
              3      Per month       (Go to FVC_N5D)
              4      Per year        (Go to FVC_N5E)
              5      Never           (Go to FVC_Q6A)
                     DK, R           (Go to FVC_Q6A)

FVC_N5B       INTERVIEWER: Enter number of times per day.
FVCE_5B
              l_l_l   Times
              (MIN: 1) (MAX: 20)
              DK, R

              Go to FVC_Q6A

FVC_N5C       INTERVIEWER: Enter number of times per week.
FVCE_5C
              l_l_l   Times
              (MIN: 1) (MAX: 90)
              DK, R

              Go to FVC_Q6A

FVC_N5D       INTERVIEWER: Enter number of times per month.
FVCE_5D
              l_l_l_l Times
              (MIN: 1) (MAX: 200)
              DK, R

              Go to FVC_Q6A
FVC_N5E       INTERVIEWER: Enter number of times per year.
FVCE_5E
              l_l_l_l Times
              (MIN: 1) (MAX: 500)
              DK, R




Statistics Canada                                                                              97
Canadian Community Health Survey - Cycle 3.1

FVC_Q6A      Not counting carrots, potatoes, or salad, how many servings of other vegetables
FVCE_6A      do you usually eat?
             INTERVIEWER: Select the reporting period here and enter the number in the next
             screen.

             1      Per day
             2      Per week       (Go to FVC_N6C)
             3      Per month      (Go to FVC_N6D)
             4      Per year       (Go to FVC_N6E)
             5      Never          (Go to FVC_END)
                    DK, R          (Go to FVC_END)

FVC_N6B      INTERVIEWER: Enter number of servings per day.
FVCE_6B
             l_l_l   Servings
             (MIN: 1) (MAX: 20)
             DK, R

             Go to FVC_END

FVC_N6C      INTERVIEWER: Enter number of servings per week.
FVCE_6C
             l_l_l   Servings
             (MIN: 1) (MAX: 90)
             DK, R

             Go to FVC_END

FVC_N6D      INTERVIEWER: Enter number of servings per month.
FVCE_6D
             l_l_l_l Servings
             (MIN: 1) (MAX: 200)
             DK, R

             Go to FVC_END

FVC_N6E      INTERVIEWER: Enter number of servings per year.
FVCE_6E
             l_l_l_l Servings
             (MIN: 1) (MAX: 500)
             DK, R

FVC_END




98                                                                           Statistics Canada
                                                   Canadian Community Health Survey - Cycle 3.1



PHYSICAL ACTIVITY (PAC)
PAC_BEG

PAC_C1        If (do PAC block = 1), go to PAC_C2.
              Otherwise, go to PAC_END.

PAC_C2        If proxy interview, go to PAC_END.

PAC_R1        Now I’d like to ask you about some of your physical activities. To begin with, I’ll be
              dealing with physical activities not related to work, that is, leisure time activities.
              INTERVIEWER: Press <Enter> to continue.

PAC_Q1        Have you done any of the following in the past 3 months, that is, from [date three
              months ago] to yesterday?
              INTERVIEWER: Read categories to respondent. Mark all that apply.

PACE_1A       1      Walking for exercise    PACE_1M         13      Downhill skiing or
                                                                     snowboarding
PACE_1B       2      Gardening or
                     yard work               PACE_1N         14      Bowling
PACE_1C       3      Swimming                PACE_1O         15      Baseball or softball
PACE_1D       4      Bicycling               PACE_1P         16      Tennis
PACE_1E       5      Popular or
                     social dance            PACE_1Q         17      Weight-training
PACE_1F       6      Home exercises          PACE_1R         18      Fishing
PACE_1G       7      Ice hockey              PACE_1S         19      Volleyball
PACE_1H       8      Ice skating             PACE_1T         20      Basketball
PACE_1I       9      In-line skating or
                     rollerblading           PACE_1Z         21      Soccer
PACE_1J       10     Jogging or running      PACE_1U         22      Any other
PACE_1K       11     Golfing                 PACE_1V         23      No physical activity
PACE_1L       12     Exercise class or                               (Go to PAC_R2)
                     aerobics

                     DK, R (Go to PAC_END)

PAC_C1VS      If “Any other” is chosen as a response, go to PAC_Q1VS.
              Otherwise, go to PAC_Q2.

PAC_Q1VS      What was this activity?
              INTERVIEWER: Enter one activity only.

              ________________________
              (80 spaces)
              DK, R              (Go to PAC_Q2)

PAC_Q1X       In the past 3 months, did you do any other physical activity for leisure?
PACE_1W
              1      Yes
              2      No              (Go to PAC_Q2)
                     DK, R           (Go to PAC_Q2)




Statistics Canada                                                                                  99
Canadian Community Health Survey - Cycle 3.1

PAC_Q1XS     What was this activity?
             INTERVIEWER: Enter one activity only.

             ________________________
             (80 spaces)
             DK, R              (Go to PAC_Q2)

PAC_Q1Y      In the past 3 months, did you do any other physical activity for leisure?
PACE_1X
             1       Yes
             2       No              (Go to PAC_Q2)
                     DK, R           (Go to PAC_Q2)

PAC_Q1YS     What was this activity?
             INTERVIEWER: Enter one activity only.

             ________________________
             (80 spaces)
             DK, R              (Go to PAC_Q2)

             For each activity identified in PAC_Q1, ask PAC_Q2 and PAC_Q3

PAC_E1       You cannot select “No physical activity” and another category.
             Please return and correct.

             Trigger hard edit if PAC_Q1 = 23 with any other response.

PAC_Q2n      In the past 3 months, how many times did you [participate in identified activity]?
PACE_2n
             |_|_|_|        Times
             (MIN: 1) (MAX: 99 for each activity except the following:
                            Walking: MAX = 270
                            Bicycling: MAX = 200
                            Other activities: MAX = 200)
             DK, R (Go to next activity)

PAC_Q3n      About how much time did you spend on each occasion?
PACE_3n
             1       1 to 15 minutes
             2       16 to 30 minutes
             3       31 to 60 minutes
             4       More than one hour
                     DK, R

PAC_R2       Next, some questions about the amount of time you spent in the past 3 months on
             physical activity at work or while doing daily chores around the house, but not
             leisure time activity.
             INTERVIEWER: Press <Enter> to continue.




100                                                                             Statistics Canada
                                                 Canadian Community Health Survey - Cycle 3.1

PAC_Q4A       In a typical week in the past 3 months, how many hours did you usually spend
PACE_4A       walking to work or to school or while doing errands?

              1      None
              2      Less than 1 hour
              3      From 1 to 5 hours
              4      From 6 to 10 hours
              5      From 11 to 20 hours
              6      More than 20 hours
                     DK, R

PAC_Q4B       (In a typical week in the past 3 months,) how many hours did you usually spend
PACE_4B       bicycling to work or to school or while doing errands?

              1      None
              2      Less than 1 hour
              3      From 1 to 5 hours
              4      From 6 to 10 hours
              5      From 11 to 20 hours
              6      More than 20 hours
                     DK, R

PAC_Q6        Thinking back over the past 3 months, which of the following best describes your
PACE_6        usual daily activities or work habits?
              INTERVIEWER: Read categories to respondent.

              1      Usually sit during the day and don’t walk around very much
              2      Stand or walk quite a lot during the day but don’t have to carry or lift
                     things very often
              3      Usually lift or carry light loads, or have to climb stairs or hills often
              4      Do heavy work or carry very heavy loads
                     DK, R

PAC_END




Statistics Canada                                                                                101
Canadian Community Health Survey - Cycle 3.1



SEDENTARY ACTIVITIES (SAC)
SAC_BEG

SAC_C1       If (do SAC block = 1), go to SAC_CINT.
SACEFOPT     Otherwise, go to SAC_END.

SAC_CINT     If proxy interview, go to SAC_END.
             Otherwise, go to SAC_R1.

SAC_R1       Now, a few additional questions about activities you do in your leisure time, that is,
             activities not at work or at school.
             INTERVIEWER: Press <Enter> to continue.

SAC_Q1       In a typical week in the past 3 months, how much time did you usually spend:
SACE_1
             ... on a computer, including playing computer games and using the Internet?
             INTERVIEWER: Do not include time spent at work or at school.

             1      None
             2      Less than 1 hour
             3      From 1 to 2 hours
             4      From 3 to 5 hours
             5      From 6 to 10 hours
             6      From 11 to 14 hours
             7      From 15 to 20 hours
             8      More than 20 hours
                    DK, R                   (Go to SAC_END)

SAC_C2       If age > 19, go to SAC_Q3.

SAC_Q2       (In a typical week, in the past 3 months, how much time did you usually spend:)
SACE_2
             ... playing video games, such as XBOX, Nintendo and Playstation?

             1      None
             2      Less than 1 hour
             3      From 1 to 2 hours
             4      From 3 to 5 hours
             5      From 6 to 10 hours
             6      From 11 to 14 hours
             7      From 15 to 20 hours
             8      More than 20 hours
                    DK, R




102                                                                             Statistics Canada
                                                   Canadian Community Health Survey - Cycle 3.1

SAC_Q3        (In a typical week in the past 3 months, how much time did you usually spend:)
SACE_3
              ... watching television or videos?

              1      None
              2      Less than 1 hour
              3      From 1 to 2 hours
              4      From 3 to 5 hours
              5      From 6 to 10 hours
              6      From 11 to 14 hours
              7      From 15 to 20 hours
              8      More than 20 hours
                     DK, R

SAC_Q4        (In a typical week, in the past 3 months, how much time did you usually spend:)
SACE_4
              ... reading, not counting at work or at school?
              INTERVIEWER: Include books, magazines, newspapers, homework.

              1      None
              2      Less than 1 hour
              3      From 1 to 2 hours
              4      From 3 to 5 hours
              5      From 6 to 10 hours
              6      From 11 to 14 hours
              7      From 15 to 20 hours
              8      More than 20 hours
                     DK, R

SAC_END




Statistics Canada                                                                              103
Canadian Community Health Survey - Cycle 3.1



USE OF PROTECTIVE EQUIPMENT (UPE)
UPE_BEG

UPE_C1A      If (do UPE block = 1), go to UPE_C1B.
UPEEFOPT     Otherwise, go to UPE_END.

UPE_C1B      If proxy interview, go to UPE_END.
             Otherwise, go to UPE_CINT.

UPE_CINT     If PAC_Q1 = 4 (bicycling for leisure) or PAC_Q1 = 9 (in-line skating or rollerblading) or
             PAC_Q1 = 13 (downhill skiing or snowboarding), or PAC_Q4B > 1 and PAC_Q4B < 7
             (bicycling to work), go to UPE_QINT.
             Otherwise, go to UPE_C3A.

UPE_QINT     Now a few questions about precautions you take while participating in physical
             activities.
             INTERVIEWER: Press <Enter> to continue.

UPE_C1C      If PAC_Q1 = 4 (bicycling for leisure) or PAC_Q4B > 1 and PAC_Q4B < 7 (bicycling to
             work), go to UPE_Q1.
             Otherwise, go to UPE_C2A.

UPE_Q1       When riding a bicycle, how often do you wear a helmet?
UPEE_01      INTERVIEWER: Read categories to respondent.

             1       Always
             2       Most of the time
             3       Rarely
             4       Never
                     DK, R

UPE_C2A      If PAC_Q1 = 9 (in-line skating or rollerblading), go to UPE_Q2A.
             Otherwise, go to UPE_C3A.

UPE_Q2A      When in-line skating or rollerblading, how often do you wear a helmet?
UPEE_02A
             1       Always
             2       Most of the time
             3       Rarely
             4       Never
                     DK, R

UPE_Q2B      How often do you wear wrist guards or wrist protectors?
UPEE_02B
             1       Always
             2       Most of the time
             3       Rarely
             4       Never
                     DK, R




104                                                                                  Statistics Canada
                                                Canadian Community Health Survey - Cycle 3.1

UPE_Q2C       How often do you wear elbow pads?
UPEE_02C
              1      Always
              2      Most of the time
              3      Rarely
              4      Never
                     DK, R

UPE_C3A       If PAC_Q1 = 13 (downhill skiing or snowboarding), go to UPE_Q3A.
              Otherwise, go to UPE_Q3B.

UPE_Q3A       Earlier, you mentioned going downhill skiing or snowboarding in the past
UPEE_03A      3 months. Was that:
              INTERVIEWER: Read categories to respondent.

              1      … downhill skiing only?        (Go to UPE_Q4A)
              2      … snowboarding only?           (Go to UPE_C5A)
              3      … both?                        (Go to UPE_Q4A)
                     DK, R                          (Go to UPE_C6)

UPE_Q3B       In the past 12 months, did you do any downhill skiing or snowboarding?
UPEE_03B      INTERVIEWER: Read categories to respondent.

              1      Downhill skiing only           (Go to UPE_Q4A)
              2      Snowboarding only              (Go to UPE_C5A)
              3      Both                           (Go to UPE_Q4A)
              4      Neither                        (Go to UPE_C6)
                     DK, R                          (Go to UPE_C6)

UPE_Q4A       When downhill skiing, how often do you wear a helmet?
UPEE_04A      INTERVIEWER: Read categories to respondent.

              1      Always
              2      Most of the time
              3      Rarely
              4      Never
                     DK, R

UPE_C5A       If UPE_Q3A = 2 or 3 (snowboarding or both) or UPE_Q3B = 2 or 3, go to UPE_Q5A.
              Otherwise, go to UPE_C6.

UPE_Q5A       When snowboarding, how often do you wear a helmet?
UPEE_05A
              1      Always
              2      Most of the time
              3      Rarely
              4      Never
                     DK, R




Statistics Canada                                                                              105
Canadian Community Health Survey - Cycle 3.1

UPE_Q5B      How often do you wear wrist guards or wrist protectors?
UPEE_05B
             1      Always
             2      Most of the time
             3      Rarely
             4      Never
                    DK, R

UPE_C6       If age >= 12 or <=19, go to UPE_Q6.
             Otherwise, go to UPE_END.

UPE_Q6       In the past 12 months, have you done any skateboarding?
UPEE_06
             1      Yes
             2      No    (Go to UPE_END)
                    DK, R (Go to UPE_END)

UPE_Q6A      How often do you wear a helmet?
UPEE_06A     INTERVIEWER: Read categories to respondent.

             1      Always
             2      Most of the time
             3      Rarely
             4      Never
                    DK, R

UPE_Q6B      How often do you wear wrist guards or wrist protectors?
UPEE_06B
             1      Always
             2      Most of the time
             3      Rarely
             4      Never
                    DK, R

UPE_Q6C      How often do you wear elbow pads?
UPEE_06C
             1      Always
             2      Most of the time
             3      Rarely
             4      Never
                    DK, R

UPE_END




106                                                                    Statistics Canada
                                                     Canadian Community Health Survey - Cycle 3.1



SUN SAFETY (SSB)
SSB_BEG

SSB_C1        If (do SSB block = 1), go to SSB_C2.
SSBEFOPT      Otherwise, go to SSB_END.

SSB_C2        If proxy interview, go to SSB_END.
              Otherwise, go to SSB_R01.

SSB_R01       The next few questions are about exposure to the sun and sunburns. Sunburn is
              defined as any reddening or discomfort of the skin, that lasts longer than 12 hours
              after exposure to the sun or other UV sources, such as tanning beds or sun lamps.
              INTERVIEWER: Press <Enter> to continue.

SSB_Q01       In the past 12 months, has any part of your body been sunburnt?
SSBE_01
              1      Yes
              2      No              (Go to SSB_R06)
                     DK, R           (Go to SSB_END)

SSB_Q02       Did any of your sunburns involve blistering?
SSBE_02
              1      Yes
              2      No
                     DK, R

SSB_Q03       Did any of your sunburns involve pain or discomfort that lasted for more than
SSBE_03       1 day?

              1      Yes
              2      No
                     DK, R

SSB_R06       For the next questions, think about a typical weekend, or day off from work or
              school in the summer months.
              INTERVIEWER: Press <Enter> to continue.

SSB_Q06       About how much time each day do you spend in the sun between 11 am and 4 pm?
SSBE_06
              1      None                     (Go to SSB_END)
              2      Less than 30 minutes (Go to SSB_END)
              3      30 to 59 minutes
              4      1 hour to less than 2 hours
              5      2 hours to less than 3 hours
              6      3 hours to less than 4 hours
              7      4 hours to less than 5 hours
              8      5 hours
                     DK, R                    (Go to SSB_END)




Statistics Canada                                                                              107
Canadian Community Health Survey - Cycle 3.1

SSB_Q07      In the summer months, on a typical weekend or day off, when you are in the sun
SSBE_07      for 30 minutes or more, how often do you:

             … seek shade?
             INTERVIEWER: Read categories to respondent.

             1      Always
             2      Often
             3      Sometimes
             4      Rarely
             5      Never
                    DK, R

SSB_Q08      (In the summer months, on a typical weekend or day off, when you are in the sun
SSBE_08      for 30 minutes or more, how often do you:)

             … wear a hat that shades your face, ears and neck?

             1      Always
             2      Often
             3      Sometimes
             4      Rarely
             5      Never
                    DK, R

SSB_Q09A     (In the summer months, on a typical weekend or day off, when you are in the sun
SSBE_09A     for 30 minutes or more, how often do you:)

             … wear long pants or a long skirt to protect your skin from the sun?

             1      Always
             2      Often
             3      Sometimes
             4      Rarely
             5      Never
                    DK, R

SSB_Q09B     (In the summer months, on a typical weekend or day off, when you are in the sun
SSBE_09B     for 30 minutes or more, how often do you:)

             … use sunscreen on your face?

             1      Always
             2      Often
             3      Sometimes
             4      Rarely         (Go to SSB_Q11)
             5      Never          (Go to SSB_Q11)
                    DK, R          (Go to SSB_Q11)




108                                                                           Statistics Canada
                                               Canadian Community Health Survey - Cycle 3.1

SSB_Q10       What Sun Protection factor (SPF) do you usually use?
SSBE_10
              1      Less than 15
              2      15 to 25
              3      More than 25
                     DK, R

SSB_Q11       In the summer months, on a typical weekend or day off, when you are in the sun
SSBE_11       for 30 minutes or more, how often do you:

              … use sunscreen on your body?

              1      Always
              2      Often
              3      Sometimes
              4      Rarely         (Go to SSB_END)
              5      Never          (Go to SSB_END)
                     DK, R          (Go to SSB_END)

SSB_Q12       What Sun Protection factor (SPF) do you usually use?
SSBE_12
              1      Less than 15
              2      15 to 25
              3      More than 25
                     DK, R

SSB_END




Statistics Canada                                                                          109
Canadian Community Health Survey - Cycle 3.1



SMOKING (SMK)
SMK_BEG

SMK_C1       If (do SMK block = 1), go to SMK_QINT.
             Otherwise, go to SMK_END.

SMK_QINT     The next questions are about smoking.
             INTERVIEWER: Press <Enter> to continue.

SMK_Q201A    In ^YOUR1 lifetime, ^HAVE ^YOU2 smoked a total of 100 or more
SMKE_01A     cigarettes (about 4 packs)?

             1      Yes   (Go to SMK_Q201C)
             2      No
                    DK, R

SMK_Q201B    ^HAVE_C ^YOU1 ever smoked a whole cigarette?
SMKE_01B
             1      Yes     (Go to SMK_Q201C)
             2      No      (Go to SMK_Q202)
                    DK      (Go to SMK_Q202)
                    R

SMK_C201C    If SMK_Q201A = R and SMK_Q201B = R, go to SMK_END.
             Otherwise, go to SMK_Q202.

SMK_Q201C    At what age did ^YOU1 smoke ^YOUR1 first whole cigarette?
SMKE_01C     INTERVIEWER: Minimum is 5; maximum is [current age].

             |_|_|_| Age in years
             (MIN: 5) (MAX: current age)
             DK, R (Go to SMK_Q202)

SMK_E201C    The entered age at which the respondent first smoked a whole cigarette is invalid.
             Please return and correct.

             Trigger hard edit if SMK_Q201C < 5 or SMK_Q201C > [current age].

SMK_Q202     At the present time, ^DOVERB ^YOU2 smoke cigarettes daily, occasionally
SMKE_202     or not at all?

             1      Daily
             2      Occasionally    (Go to SMK_Q205B)
             3      Not at all      (Go to SMK_C205D)
                    DK, R           (Go to SMK_END)




110                                                                             Statistics Canada
                                                   Canadian Community Health Survey - Cycle 3.1

Daily smoker (current)

SMK_Q203        At what age did ^YOU1 begin to smoke cigarettes daily?
SMKE_203        INTERVIEWER: Minimum is 5; maximum is [current age].

                |_|_|_| Age in years
                (MIN: 5) (MAX: current age)
                DK, R (Go to SMK_Q204)

SMK_E203        The entered age at which the respondent first began to smoke cigarettes daily is
                invalid. Please return and correct.

                Trigger hard edit if SMK_Q203 < 5 or SMK_Q203 > [current age]

SMK_Q204        How many cigarettes ^DOVERB ^YOU1 smoke each day now?
SMKE_204
                |_|_|   Cigarettes
                (MIN: 1) (MAX: 99; warning after 60)
                DK, R

                Go to SMK_END

Occasional smoker (current)

SMK_Q205B       On the days that ^YOU2 ^DOVERB smoke, how many cigarettes ^DOVERB
SMKE_05B        ^YOU1 usually smoke?

                |_|_|   Cigarettes
                (MIN: 1) (MAX: 99; warning after 60)
                DK, R

SMK_Q205C       In the past month, on how many days ^HAVE ^YOU1 smoked 1 or more
SMKE_05C        cigarettes?

                |_|_|   Days
                (MIN: 0) (MAX: 30)
                DK, R

SMK_C205D       If SMK_Q201A = 2 (has not smoked 100 or more cigarettes lifetime), DK or R, go to
                SMK_END.


Occasional smoker or non-smoker (current)

SMK_Q205D       ^HAVE ^YOU1 ever smoked cigarettes daily?
SMKE_05D
                1        Yes   (Go to SMK_Q207)
                2        No
                         DK, R (Go to SMK_END)

SMK_C206A       If SMK_Q202 = 2 (current occasional smoker), go to SMK_END.
                Otherwise, go to SMK_Q206A.




Statistics Canada                                                                                   111
Canadian Community Health Survey - Cycle 3.1

Non-smoker (current)

SMK_Q206A      When did ^YOU1 stop smoking? Was it:
SMKE_06A       INTERVIEWER: Read categories to respondent.

               1       … less than one year ago?
               2       … 1 year to less than 2 years ago?     (Go to SMK_END)
               3       … 2 years to less than 3 years ago?    (Go to SMK_END)
               4       … 3 or more years ago?                 (Go to SMK_Q206C)
                       DK, R                                  (Go to SMK_END)

SMK_Q206B      In what month did ^YOU1 stop?
SMKE_06B
               1       January                        7       July
               2       February                       8       August
               3       March                          9       September
               4       April                          10      October
               5       May                            11      November
               6       June                           12      December
                       DK, R

               Go to SMK_END

SMK_Q206C      How many years ago was it?
SMKE_06C       INTERVIEWER: Minimum is 3; maximum is [current age] - 5.

               |_|_|_| Years
               (MIN: 3) (MAX: current age - 5)
               DK, R (Go to SMK_END)

SMK_E206C      The number of years ago that the respondent stopped smoking is invalid.
               Please return and correct.

               Trigger hard edit if SMK_Q206C < 3 or (SMK_Q206C > [current age] - 5).

Occasional smoker or non-smoker (current) – Daily smoker (previously)

SMK_Q207       At what age did ^YOU1 begin to smoke (cigarettes) daily?
SMKE_207       INTERVIEWER: Minimum is 5; maximum is [current age].

               |_|_|_| Age in years
               (MIN: 5) (MAX: current age)
               DK, R (Go to SMK_Q208)

SMK_E207       The entered age at which the respondent first began to smoke cigarettes daily is
               invalid. Please return and correct.

               Trigger hard edit if SMK_Q207 < 5 or SMK_Q207 > [current age].




112                                                                               Statistics Canada
                                                      Canadian Community Health Survey - Cycle 3.1

SMK_Q208       How many cigarettes did ^YOU1 usually smoke each day?
SMKE_208
               |_|_|   Cigarettes
               (MIN: 1) (MAX: 99; warning after 60)
               DK, R

SMK_Q209A      When did ^YOU1 stop smoking daily? Was it:
SMKE_09A       INTERVIEWER: Read categories to respondent.

               1       … less than one year ago?
               2       … 1 year to less than 2 years ago?      (Go to SMK_C210)
               3       … 2 years to less than 3 years ago?     (Go to SMK_C210)
               4       … 3 or more years ago?                  (Go to SMK_Q209C)
                       DK, R                                   (Go to SMK_END)

SMK_Q209B      In what month did ^YOU1 stop?
SMKE_09B
               1       January                   7       July
               2       February                  8       August
               3       March                     9       September
               4       April                     10      October
               5       May                       11      November
               6       June                      12      December
                       DK, R

               Go to SMK_C210

SMK_Q209C      How many years ago was it?
SMKE_09C       INTERVIEWER: Minimum is 3; maximum is [current age] - 5.

               |_|_|_| Years
               (MIN: 3) (MAX: current age - 5)
               DK, R (Go to SMK_C210)

SMK_E209C      The number of years ago that the respondent stopped smoking daily is invalid.
               Please return and correct.

               Trigger hard edit if SMK_Q209C < 3 or (SMK_Q209C > [current age] – 5).

SMK_C210       If SMK_Q202 = 2 (current occasional smoker), go to SMK_END.
               Otherwise, go to SMK_Q210.

Non-smoker (current)

SMK_Q210       Was that when ^YOU1 completely quit smoking?
SMKE_10
               1       Yes   (Go to SMK_END)
               2       No
                       DK, R (Go to SMK_END)




Statistics Canada                                                                              113
Canadian Community Health Survey - Cycle 3.1

SMK_Q210A    When did ^YOU1 stop smoking completely? Was it:
SMKE_10A     INTERVIEWER: Read categories to respondent.

             1      … less than one year ago?
             2      … 1 year to less than 2 years ago?     (Go to SMK_END)
             3      … 2 years to less than 3 years ago?    (Go to SMK_END)
             4      … 3 or more years ago?                 (Go to SMK_Q210C)
                    DK, R                                  (Go to SMK_END)

SMK_Q210B    In what month did ^YOU1 stop?
SMKE_10B
             1      January                    7    July
             2      February                   8    August
             3      March                      9    September
             4      April                      10   October
             5      May                        11   November
             6      June                       12   December
                    DK, R

             Go to SMK_END

SMK_Q210C    How many years ago was it?
SMKE_10C     INTERVIEWER: Minimum is 3; maximum is [current age] - 5.

             |_|_|_| Years
             (MIN: 3) (MAX: current age - 5)
             DK, R (Go to SMK_END)

SMK_E210C    The number of years ago that the respondent completely stopped smoking is
             invalid. Please return and correct.

             Trigger hard edit if SMK_Q210C < 3 or (SMK_Q210C > [current age] - 5).

SMK_END




114                                                                             Statistics Canada
                                                   Canadian Community Health Survey - Cycle 3.1



SMOKING - STAGES OF CHANGE (SCH)
SCH_BEG

SCH_C1        If (do SCH block = 1), go to SCH_C2.
SCHEFOPT      Otherwise, go to SCH_END.

SCH_C2        If SMK_Q202 = 1 or 2 (current daily or occasional smokers), go to SCH_C3.
              Otherwise, go to SCH_END.

SCH_C3        If proxy interview, go to SCH_END.
              Otherwise, go to SCH_Q1.

SCH_Q1        Are you seriously considering quitting smoking within the next 6 months?
SCHE_1
              1      Yes
              2      No              (Go to SCH_Q3)
                     DK, R           (Go to SCH_Q3)

SCH_Q2        Are you seriously considering quitting within the next 30 days?
SCHE_2
              1      Yes
              2      No
                     DK, R

SCH_Q3        In the past 12 months, did you stop smoking for at least 24 hours because
SCHE_3        you were trying to quit?

              1      Yes
              2      No              (Go to SCH_END)
                     DK, R           (Go to SCH_END)

SCH_Q4        How many times? (in the past 12 months, did you stop smoking for at least
SCHE_4        24 hours because you were trying to quit)

              |_|_|   Times
              (MIN: 1) (MAX: 95; warning after 48)
              DK, R

SCH_END




Statistics Canada                                                                          115
Canadian Community Health Survey - Cycle 3.1



NICOTINE DEPENDENCE (NDE)
NDE_BEG

NDE_C1       If (do NDE block = 1), go to NDE_C2.
NDEEFOPT     Otherwise, go to NDE_END.

NDE_C2       If SMK_Q202 = 1 (current daily smokers), go to NDE_C3.
             Otherwise, go to NDE_END.

NDE_C3       If proxy interview, go to NDE_END.
             Otherwise, go to NDE_Q1.

NDE_Q1       How soon after you wake up do you smoke your first cigarette?
NDEE_1
             1      Within 5 minutes
             2      6 - 30 minutes after waking
             3      31 - 60 minutes after waking
             4      More than 60 minutes after waking
                    DK, R (Go to NDE_END)

NDE_Q2       Do you find it difficult to refrain from smoking in places where it is forbidden?
NDEE_2
             1      Yes
             2      No
                    DK, R

NDE_Q3       Which cigarette would you most hate to give up?
NDEE_3       INTERVIEWER: Read categories to respondent.

             1      The first one of the day
             2      Another one
                    DK, R

NDE_Q4       Do you smoke more frequently during the first hours after waking, compared with
NDEE_4       the rest of the day?

             1      Yes
             2      No
                    DK, R

NDE_Q5       Do you smoke even if you are so ill that you are in bed most of the day?
NDEE_5
             1      Yes
             2      No
                    DK, R

NDE_END




116                                                                              Statistics Canada
                                                   Canadian Community Health Survey - Cycle 3.1



SMOKING CESSATION AIDS (SCA)
SCA_BEG

SCA_C1        If (do SCA block = 1), go to SCA_C10A.
SCAEFOPT      Otherwise, go to SCA_END.

SCA_C10A      If proxy interview, go to SCA_END.
              Otherwise, go to SCA_C10B.

SCA_C10B      If SMK_Q202 = 1 or 2 (current daily or occasional smoker), go to SCA_C50.
              Otherwise, go to SCA_C10C.

SCA_C10C      If SMK_Q206A = 1 or SMK_Q209A = 1 (former smoker who quit less than 1 year ago),
              go to SCA_Q10.
              Otherwise, go to SCA_END.

SCA_Q10       In the past 12 months, did you try a nicotine patch to quit smoking?
SCAE_10
              1      Yes
              2      No    (Go to SCA_Q11)
                     DK, R (Go to SCA_END)

SCA_Q10A      How useful was that in helping you quit?
SCAE_10A
              1      Very useful
              2      Somewhat useful
              3      Not very useful
              4      Not useful at all
                     DK, R

SCA_Q11       Did you try Nicorettes or other nicotine gum or candy to quit smoking? (In the
SCAE_11       past 12 months)

              1      Yes
              2      No    (Go to SCA_Q12)
                     DK, R (Go to SCA_Q12)

SCA_Q11A      How useful was that in helping you quit?
SCAE_11A
              1      Very useful
              2      Somewhat useful
              3      Not very useful
              4      Not useful at all
                     DK, R




Statistics Canada                                                                              117
Canadian Community Health Survey - Cycle 3.1

SCA_Q12      In the past 12 months, did you try medication such as Zyban, Prolev or Wellbutrin
SCAE_12      to quit smoking?

             1      Yes
             2      No    (Go to SCA_END)
                    DK, R (Go to SCA_END)

SCA_Q12A     How useful was that in helping you quit?
SCAE_12A
             1      Very useful
             2      Somewhat useful
             3      Not very useful
             4      Not useful at all
                    DK, R

             Go to SCA_END

SCA_C50      If (do SCH block = 2), go to SCA_Q50.
             Otherwise, go to SCA_C50A.

SCA_C50A     If SCH_Q3 = 1, go to SCA_Q60.
             Otherwise, go to SCA_END.

SCA_Q50      In the past 12 months, did you stop smoking for at least 24 hours because you
SCAE_50      were trying to quit?

             1      Yes
             2      No    (Go to SCA_END)
                    DK, R (Go to SCA_END)

Note:        In processing, if a respondent answered SCH_Q3 = 1, the variable SCA_Q50 is given
             the value of 1.

SCA_Q60      In the past 12 months, did you try any of the following to quit smoking:
SCAE_60
             … a nicotine patch?

             1      Yes
             2      No
                    DK, R

SCA_Q61      (In the past 12 months, did you try any of the following to quit smoking:)
SCAE_61
             … Nicorettes or other nicotine gum or candy?

             1      Yes
             2      No
                    DK, R




118                                                                             Statistics Canada
                                                 Canadian Community Health Survey - Cycle 3.1

SCA_Q62       (In the past 12 months, did you try any of the following to quit smoking:)
SCAE_62
              … medication such as Zyban, Prolev or Wellbutrin?

              1      Yes
              2      No
                     DK, R

SCA_END




Statistics Canada                                                                          119
Canadian Community Health Survey - Cycle 3.1



SMOKING - PHYSICIAN COUNSELLING (SPC)
SPC_BEG

SPC_C1       If (do SPC block = 1), go to SPC_C2.
SPCEFOPT     Otherwise, go to SPC_END.

SPC_C2       If proxy interview, go to SPC_END.
             Otherwise, go to SPC_C3.

SPC_C3       If SMK_Q202 = 1 or 2 or SMK_Q206A = 1 or SMK_Q209A = 1, go to SPC_C4.
             Otherwise, go to SPC_END.

SPC_C4       If (do HCU block = 1) and (HCU_Q01AA = 1) (i.e. has a regular medical doctor), go to
             SPC_Q10.
             Otherwise, go to SPC_C20A.

SPC_Q10      Earlier, you mentioned having a regular medical doctor. In the past 12 months,
SPCE_10      did you go see this doctor?

             1      Yes
             2      No    (Go to SPC_C20A)
                    DK, R (Go to SPC_C20A)

SPC_Q11      Does your doctor know that you [smoke/smoked] cigarettes?
SPCE_11
             1      Yes
             2      No    (Go to SPC_C20A)
                    DK, R (Go to SPC_C20A)

Note:        If SMK_Q202 = 1 or 2, use “smoke”. If SMK_Q206A = 1 or SMK_Q209A = 1, use
             “smoked”.

SPC_Q12      In the past 12 months, did your doctor advise you to quit smoking?
SPCE_12
             1      Yes
             2      No
                    DK, R (Go to SPC_C20A)

SPC_Q13      (In the past 12 months,) did your doctor give you any specific help or information
SPCE_13      to quit smoking?

             1      Yes
             2      No    (Go to SPC_C20A)
                    DK, R (Go to SPC_C20A)




120                                                                               Statistics Canada
                                                  Canadian Community Health Survey - Cycle 3.1

SPC_Q14       What type of help did the doctor give?
              INTERVIEWER: Mark all that apply.

SPCE_14A      1      Referral to a one-on-one cessation program
SPCE_14B      2      Referral to a group cessation program
SPCE_14C      3      Recommended use of nicotine patch or nicotine gum
SPCE_14D      4      Recommended Zyban or other medication
SPCE_14E      5      Provided self-help information (e.g., pamphlet, referral to website)
SPCE_14F      6      Own doctor offered counselling
SPCE_14G      7      Other
                     DK, R

SPC_C20A      If (do DEN block = 1) and (DEN_Q130 = 1 or DEN_Q132 = 1) (visited dentist in past
              12 months), go to SPC_Q21.
              If (do DEN block = 1) and (DEN_Q130 = 2, DK or R) (did not visit dentist in past
              12 months), go to SPC_END.
              Otherwise, go to SPC_C20.

SPC_C20       If (do HCU block = 1) and (HCU_Q02E > 0 and HCU_Q02E < 998) (saw or talked to
              dentist in past 12 months), go to SPC_Q20.
              Otherwise, go to SPC_END.

SPC_Q20       Earlier, you mentioned having “seen or talked to” a dentist in the past 12 months.
SPCE_20       Did you actually go to the dentist?

              1      Yes
              2      No    (Go to SPC_END)
                     DK, R (Go to SPC_END)

SPC_Q21       Does your dentist or dental hygienist know that you [smoke/smoked] cigarettes?
SPCE_21
              1      Yes
              2      No    (Go to SPC_END)
                     DK, R (Go to SPC_END)

Note:         If SMK_Q202 = 1 or 2, use “smoke”. If SMK_Q206A = 1 or SMK_Q209A = 1, use
              “smoked”.

SPC_Q22       In the past 12 months, did the dentist or hygienist advise you to quit smoking?
SPCE_22
              1      Yes
              2      No
                     DK, R

SPC_END




Statistics Canada                                                                                 121
Canadian Community Health Survey - Cycle 3.1



YOUTH SMOKING (YSM)
YSM_BEG

YSM_C1       If (do YSM block = 1), go to YSM_C1A.
             Otherwise, go to YSM_END.

YSM_C1A      If proxy interview or age > 19, go to YSM_END.
             Otherwise, go to YSM_C1B.

YSM_C1B      If SMK_Q202 = 1 or 2 (current daily or occasional smoker), go to YSM_Q1.
             Otherwise, go to YSM_END.

YSM_Q1       Where do you usually get your cigarettes?
YSME_1
             1       Buy from - Vending machine
             2       Buy from - Small grocery / corner store
             3       Buy from - Supermarket
             4       Buy from - Drug store
             5       Buy from - Gas station
             6       Buy from - Other store
             7       Buy from - Friend or someone else
             8       Given them by - Brother or sister
             9       Given them by - Mother or father
             10      Given them by - Friend or someone else
             11      Take them from - Mother, father or sibling
             12      Other - Specify
                     DK, R (Go to YSM_END)

YSM_C1S      If YSM_Q1 = 12, go to YSM_Q1S.
             Otherwise, go to YSM_C2.

YSM_Q1S      INTERVIEWER: Specify.

             ___________________________
             (80 spaces)
             DK, R

YSM_C2       If YSM_Q1 = 1, 2, 3, 4, 5, 6 or 7, go to YSM_Q3.
             Otherwise, go to YSM_Q2.

YSM_Q2       In the past 12 months, have you bought cigarettes for yourself or for someone
YSME_2       else?

             1       Yes
             2       No    (Go to YSM_Q5)
                     DK, R (Go to YSM_Q5)




122                                                                             Statistics Canada
                                                Canadian Community Health Survey - Cycle 3.1

YSM_Q3        In the past 12 months, have you been asked your age when buying cigarettes in
YSME_3        a store?

              1      Yes
              2      No
                     DK, R

YSM_Q4        In the past 12 months, has anyone in a store refused to sell you cigarettes?
YSME_4
              1      Yes
              2      No
                     DK, R

YSM_Q5        In the past 12 months, have you asked a stranger to buy you cigarettes?
YSME_5
              1      Yes
              2      No
                     DK, R

YSM_END




Statistics Canada                                                                            123
Canadian Community Health Survey - Cycle 3.1



EXPOSURE TO SECOND-HAND SMOKE (ETS)
ETS_BEG

ETS_C1       If (do ETS block = 1), go to ETS_QINT.
             Otherwise, go to ETS_END.

ETS_QINT     The next questions are about exposure to second-hand smoke.
             INTERVIEWER: Press <Enter> to continue.

ETS_C10      If the number of household members = 1 and (SMK_Q202 = 1 or 2), go to ETS_Q30.
             Otherwise, go to ETS_Q10.

ETS_Q10      Including both household members and regular visitors, does anyone smoke
ETSE_10      inside your home, every day or almost every day?
             INTERVIEWER: Include cigarettes, cigars and pipes.

             1      Yes
             2      No    (Go to ETS_C20)
                    DK, R (Go to ETS_END)

ETS_Q11      How many people smoke inside your home every day or almost every day?
ETSE_11      INTERVIEWER: Include household members and regular visitors.

             I_I_I   Number of people
             (MIN:1) (MAX:15)
             DK, R

ETS_C20      If SMK_Q202 = 1 or 2 (current daily or occasional smoker), go to ETS_Q30.
             Otherwise, go to ETS_Q20.

ETS_Q20      In the past month, ^WERE ^YOU2 exposed to second-hand smoke,
ETSE_20      every day or almost every day, in a car or other private vehicle?

             1      Yes
             2      No
                    DK, R

ETS_Q20B     (In the past month,) ^WERE ^YOU1 exposed to second-hand smoke,
ETSE_20B     every day or almost every day, in public places (such as bars, restaurants,
             shopping malls, arenas, bingo halls, bowling alleys)?

             1      Yes
             2      No
                    DK, R




124                                                                             Statistics Canada
                                                Canadian Community Health Survey - Cycle 3.1

ETS_Q30       Are there any restrictions against smoking cigarettes in your home?
ETSE_5
              1      Yes
              2      No             (Go to ETS_END)
                     DK, R          (Go to ETS_END)

ETS_Q31       How is smoking restricted in your home?
              INTERVIEWER: Read categories to respondent. Mark all that apply.

ETSE_6A       1      Smokers are asked to refrain from smoking in the house
ETSE_6B       2      Smoking is allowed in certain rooms only
ETSE_6C       3      Smoking is restricted in the presence of young children
ETSE_6D       4      Other restriction
                     DK, R

ETS_END




Statistics Canada                                                                       125
Canadian Community Health Survey - Cycle 3.1



ALCOHOL USE (ALC)
ALC_BEG

ALC_C1A      If (do ALC block = 1), go to ALC_R1.
             Otherwise, go to ALC_END.

ALC_R1       Now, some questions about ^YOUR2 alcohol consumption.
             When we use the word ‘drink’ it means:
                    - one bottle or can of beer or a glass of draft
                    - one glass of wine or a wine cooler
                    - one drink or cocktail with 1 and a 1/2 ounces of liquor.
             INTERVIEWER: Press <Enter> to continue.

ALC_Q1       During the past 12 months, that is, from [date one year ago] to yesterday,
ALCE_1       ^HAVE ^YOU2 had a drink of beer, wine, liquor or any other alcoholic beverage?

             1      Yes
             2      No              (Go to ALC_Q5B)
                    DK, R           (Go to ALC_END)

ALC_Q2       During the past 12 months, how often did ^YOU1 drink alcoholic beverages?
ALCE_2
             1      Less than once a month
             2      Once a month
             3      2 to 3 times a month
             4      Once a week
             5      2 to 3 times a week
             6      4 to 6 times a week
             7      Every day
                    DK, R

ALC_Q3       How often in the past 12 months ^HAVE ^YOU1 had 5 or more drinks
ALCE_3       on one occasion?

             1      Never
             2      Less than once a month
             3      Once a month
             4      2 to 3 times a month
             5      Once a week
             6      More than once a week
                    DK, R




126                                                                              Statistics Canada
                                                Canadian Community Health Survey - Cycle 3.1

ALC_Q5        Thinking back over the past week, that is, from [date last week] to yesterday,
ALCE_5        did ^YOU2 have a drink of beer, wine, liquor or any other alcoholic beverage?

              1      Yes
              2      No             (Go to ALC_C8)
                     DK, R          (Go to ALC_C8)

ALC_Q5A       Starting with yesterday, that is [day name], how many drinks did ^YOU2 have:
              (If R on first day, go to ALC_C8)
              (MIN: 0 MAX: 99 for each day; warning after 12 for each day)

ALCE_5A1      1      Sunday?
ALCE_5A2      2      Monday?
ALCE_5A3      3      Tuesday?
ALCE_5A4      4      Wednesday?
ALCE_5A5      5      Thursday?
ALCE_5A6      6      Friday?
ALCE_5A7      7      Saturday?
                     DK, R

              Go to ALC_C8

ALC_E5A       Inconsistent answers have been entered. The respondent has not had 5 or more
              drinks on one occasion in the past 12 months but had 5 drinks on [day name].

              Trigger hard edit if ALC_Q3 = 1 and ALC_Q5A => 5.

ALC_Q5B       ^HAVE_C ^YOU2 ever had a drink?
ALCE_5B
              1      Yes
              2      No             (Go to ALC_END)
                     DK, R          (Go to ALC_END)

ALC_Q6        Did ^YOU1 ever regularly drink more than 12 drinks a week?
ALCE_6
              1      Yes
              2      No             (Go to ALC_C8)
                     DK, R          (Go to ALC_C8)




Statistics Canada                                                                              127
Canadian Community Health Survey - Cycle 3.1

ALC_Q7       Why did ^YOU1 reduce or quit drinking altogether?
             INTERVIEWER: Mark all that apply.

ALCE_7A      1      Dieting
ALCE_7B      2      Athletic training
ALCE_7C      3      Pregnancy
ALCE_7D      4      Getting older
ALCE_7E      5      Drinking too much / drinking problem
ALCE_7F      6      Affected - work, studies, employment opportunities
ALCE_7G      7      Interfered with family or home life
ALCE_7H      8      Affected - physical health
ALCE_7I      9      Affected - friendships or social relationships
ALCE_7J      10     Affected - financial position
ALCE_7K      11     Affected - outlook on life, happiness
ALCE_7L      12     Influence of family or friends
ALCE_7N      13     Life change
ALCE_7M      14     Other - Specify
                    DK, R

ALC_C7S      If ALC_Q7 = 14, go to ALC_Q7S.
             Otherwise, go to ALC_C8.

ALC_Q7S      INTERVIEWER: Specify.

             _________________________
             (80 spaces)
             DK, R

ALC_C8       If age > 19, go to ALC_END.

ALC_Q8       Not counting small sips, how old ^WERE ^YOU1 when ^YOU1 started drinking
ALCE_8       alcoholic beverages?
             INTERVIEWER: Drinking does not include having a few sips of wine for religious
             purposes. Minimum is 5; maximum is [current age].

             |_|_|_| Age in years
             (MIN: 5) (MAX: current age)
             DK, R

ALC_E8       Age must be between 5 and [current age].
             Please return and correct.

             Trigger hard edit if ALC_Q8 < 5 or ALC_Q8 > [current age].

ALC_END




128                                                                           Statistics Canada
                                                    Canadian Community Health Survey - Cycle 3.1



MATERNAL EXPERIENCES (MEX)
MEX_BEG

MEX_C01A      If (do MEX block = 1), go to MEX_C01B.
              Otherwise, go to MEX_END.

MEX_C01B      If proxy interview or sex = male or age < 15 or > 55, go to MEX_END.
              Otherwise, go to MEX_Q01.

MEX_Q01       The next questions are for recent mothers.
MEXE_01       Have you given birth in the past 5 years?
              INTERVIEWER: Do not include stillbirths.

              1       Yes
              2       No    (Go to MEX_END)
                      DK, R (Go to MEX_END)

MEX_Q01A      In what year?
MEXE_01A      INTERVIEWER: Enter year of birth of last baby.
              Minimum is [current year - 5]; maximum is [current year].

              l_l_l_l_l       Year
              (MIN: 2000)     (MAX: current year)
              DK, R

MEX_Q02       Did you take a vitamin supplement containing folic acid before your (last)
MEXE_02       pregnancy, that is, before you found out that you were pregnant?

              1       Yes
              2       No
                      DK, R

MEX_Q03       (For your last baby,) did you breastfeed or try to breastfeed your baby, even if only
MEXE_03       for a short time?

              1       Yes   (Go to MEX_Q05)
              2       No
                      DK, R (Go to MEX_C20)




Statistics Canada                                                                              129
Canadian Community Health Survey - Cycle 3.1

MEX_Q04      What is the main reason that you did not breastfeed?
MEXE_04
             1      Bottle feeding easier
             2      Formula as good as breast milk
             3      Breastfeeding is unappealing / disgusting
             4      Father / partner didn’t want me to
             5      Returned to work / school early
             6      C-Section
             7      Medical condition - mother
             8      Medical condition - baby
             9      Premature birth
             10     Multiple births (e.g. twins)
             11     Wanted to drink alcohol
             12     Wanted to smoke
             13     Other - Specify
                    DK, R

MEX_C04S     If MEX_Q04 = 13, go to MEX_Q04S.
             Otherwise, go to MEX_C20.

MEX_Q04S     INTERVIEWER: Specify.

             _________________________
             (80 spaces)
             DK, R

             Go to MEX_C20

MEX_Q05      Are you still breastfeeding?
MEXE_05
             1      Yes   (Go to MEX_Q07)
             2      No
                    DK, R (Go to MEX_C20)

MEX_Q06      How long did you breastfeed (your last baby)?
MEXE_06
             1      Less than 1 week
             2      1 to 2 weeks
             3      3 to 4 weeks
             4      5 to 8 weeks
             5      9 weeks to less than 12 weeks
             6      3 months (12 weeks to less than 16 weeks)
             7      4 months (16 weeks to less than 20 weeks)
             8      5 months (20 weeks to less than 24 weeks)
             9      6 months (24 weeks to less than 28 weeks)
             10     7 to 9 months
             11     10 to 12 months
             12     More than 1 year
                    DK, R (Go to MEX_C20)




130                                                                 Statistics Canada
                                                  Canadian Community Health Survey - Cycle 3.1

MEX_Q07       How old was your (last) baby when you first added any other liquids (e.g. milk,
MEXE_07       formula, water, teas, herbal mixtures) or solid foods to the baby’s feeds?
              INTERVIEWER: If exact age not known, obtain best estimate.

              1      Less than 1 week
              2      1 to 2 weeks
              3      3 to 4 weeks
              4      5 to 8 weeks
              5      9 weeks to less than 12 weeks
              6      3 months (12 weeks to less than 16 weeks)
              7      4 months (16 weeks to less than 20 weeks)
              8      5 months (20 weeks to less than 24 weeks)
              9      6 months (24 weeks to less than 28 weeks)
              10     7 to 9 months
              11     10 to 12 months
              12     More than 1 year
              13     Have not added liquids or solids      (Go to MEX_Q09)
                     DK, R                                 (Go to MEX_C20)

MEX_Q08       What is the main reason that you first added other liquids or solid foods?
MEXE_08
              1      Not enough breast milk
              2      Baby was ready for solid foods
              3      Inconvenience / fatigue due to breastfeeding
              4      Difficulty with BF techniques (e.g., sore nipples, engorged breasts,
                     mastitis)
              5      Medical condition - mother
              6      Medical condition - baby
              7      Advice of doctor / health professional
              8      Returned to work / school
              9      Advice of partner / family / friends
              10     Formula equally healthy for baby
              11     Wanted to drink alcohol
              12     Wanted to smoke
              13     Other - Specify
                     DK, R

MEX_C08S      If MEX_Q08 = 13, go to MEX_Q08S.
              Otherwise, go to MEX_C09.

MEX_Q08S      INTERVIEWER: Specify.

              _________________________
              (80 spaces)
              DK, R

MEX_C09       If MEX_Q07 = 1 (baby less than 1 week), go to MEX_C10.
              Otherwise, go to MEX_Q09.




Statistics Canada                                                                               131
Canadian Community Health Survey - Cycle 3.1

MEX_Q09      During the time when your (last) baby was only fed breast milk, did you give
MEXE_09      the baby a vitamin supplement containing Vitamin D?

             1      Yes
             2      No
                    DK, R

MEX_C10      If MEX_Q05 = 1 (still breastfeeding), go to MEX_C20.
             Otherwise, go to MEX_Q10.

MEX_Q10      What is the main reason that you stopped breastfeeding?
MEXE_10
             1      Not enough breast milk
             2      Baby was ready for solid foods
             3      Inconvenience / fatigue due to breastfeeding
             4      Difficulty with BF techniques (e.g., sore nipples, engorged breasts,
                    mastitis)
             5      Medical condition - mother
             6      Medical condition - baby
             7      Planned to stop at this time
             8      Child weaned him / herself (e.g., baby biting, refusing breast)
             9      Advice of doctor / health professional
             10     Returned to work / school
             11     Advice of partner
             12     Formula equally healthy for baby
             13     Wanted to drink alcohol
             14     Wanted to smoke
             15     Other - Specify
                    DK, R

MEX_C10S     If MEX_Q10 = 15, go to MEX_Q10S.
             Otherwise, go to MEX_C20.

MEX_Q10S     INTERVIEWER: Specify.

             _________________________
             (80 spaces)
             DK, R

MEX_C20      If SMK_Q202 = 1 or 2 or SMK_Q201A = 1 or SMK_Q201B = 1(current or former
             smoker), go to MEX_Q20.
             Otherwise, go to MEX_Q26.

MEX_Q20      During your last pregnancy, did you smoke daily, occasionally or not at all?
MEXE_20
             1      Daily
             2      Occasionally    (Go to MEX_Q22)
             3      Not at all      (Go to MEX_C23)
                    DK, R           (Go to MEX_Q26)




132                                                                                Statistics Canada
                                                  Canadian Community Health Survey - Cycle 3.1

Daily Smokers only

MEX_Q21        How many cigarettes did you usually smoke each day?
MEXE_21
               l_l_l   Number of cigarettes
               (MIN: 1) (MAX: 99; warning after 60)
               DK, R

               Go to MEX_C23

Occasional Smokers only

MEX_Q22        On the days that you smoked, how many cigarettes did you usually smoke?
MEXE_22
               l_l_l   Number of cigarettes
               (MIN: 1) (MAX: 99; warning after 60)
               DK, R

MEX_C23        If MEX_Q03 = 1 (breastfed last baby), go to MEX_Q23.
               Otherwise, go to MEX_Q26.

MEX_Q23        When you were breastfeeding (your last baby), did you smoke daily,
MEXE_23        occasionally or not at all?

               1      Daily
               2      Occasionally    (Go to MEX_Q25)
               3      Not at all      (Go to MEX_Q26)
                      DK, R           (Go to MEX_Q26)

Daily smokers only

MEX_Q24        How many cigarettes did you usually smoke each day?
MEXE_24
               l_l_l   Number of cigarettes
               (MIN: 1) (MAX: 99; warning after 60)
               DK, R

               Go to MEX_Q26

Occasional smokers only

MEX_Q25        On the days that you smoked, how many cigarettes did you usually smoke?
MEXE_25
               l_l_l   Number of cigarettes
               (MIN: 1) (MAX: 99; warning after 60)
               DK, R

MEX_Q26        Did anyone regularly smoke in your presence during or after the pregnancy
MEXE_26        (about 6 months after)?

               1      Yes
               2      No
                      DK, R




Statistics Canada                                                                          133
Canadian Community Health Survey - Cycle 3.1

MEX_C30      If ALC_Q1 = 1 or ALC_Q5B = 1 (drank in past 12 months or ever drank), go to
             MEX_Q30.
             Otherwise, go to MEX_END.

MEX_Q30      Did you drink any alcohol during your last pregnancy?
MEXE_30
             1      Yes
             2      No    (Go to MEX_C32)
                    DK, R (Go to MEX_END)

MEX_Q31      How often did you drink?
MEXE_31
             1      Less than once a month
             2      Once a month
             3      2 to 3 times a month
             4      Once a week
             5      2 to 3 times a week
             6      4 to 6 times a week
             7      Every day
                    DK, R

MEX_C32      If MEX_Q03 = 2 (did not breastfeed last baby), go to MEX_END.
             Otherwise, go to MEX_Q32.

MEX_Q32      Did you drink any alcohol while you were breastfeeding (your last baby)?
MEXE_32
             1      Yes
             2      No    (Go to MEX_END)
                    DK, R (Go to MEX_END)

MEX_Q33      How often did you drink?
MEXE_33
             1      Less than once a month
             2      Once a month
             3      2 to 3 times a month
             4      Once a week
             5      2 to 3 times a week
             6      4 to 6 times a week
             7      Every day
                    DK, R

MEX_END




134                                                                             Statistics Canada
                                                   Canadian Community Health Survey - Cycle 3.1



ILLICIT DRUGS (IDG)
DRG_BEG

DRG_C1        If (do DRG block = 1), go to DRG_C2.
IDGEFOPT      Otherwise, go to DRG_END.

DRG_C2        If proxy interview, go to DRG_END.
              Otherwise, go to DRG_R1.

DRG_R1        I am going to ask some questions about drug use. Again, I would like to remind
              you that everything you say will remain strictly confidential.
              INTERVIEWER: Press <Enter> to continue.

DRG_Q01       Have you ever used or tried marijuana, cannabis or hashish?
IDGE_01       INTERVIEWER: Read categories to respondent.

              1      Yes, just once
              2      Yes, more than once
              3      No                      (Go to DRG_Q04)
                     DK, R                   (Go to DRG_END)

DRG_Q02       Have you used it in the past 12 months?
IDGE_02
              1      Yes
              2      No                      (Go to DRG_Q04)
                     DK, R                   (Go to DRG_Q04)

DRG_C03       If DRG_Q01 = 1, go to DRG_Q04.

DRG_Q03       How often (did you use marijuana, cannabis or hashish in the past 12 months)?
IDGE_03       INTERVIEWER: Read categories to respondent.

              1      Less than once a month
              2      1 to 3 times a month
              3      Once a week
              4      More than once a week
              5      Every day
                     DK, R

DRG_Q04       Have you ever used or tried cocaine or crack?
IDGE_04
              1      Yes, just once
              2      Yes, more than once
              3      No                      (Go to DRG_Q07)
                     DK, R                   (Go to DRG_Q07)




Statistics Canada                                                                              135
Canadian Community Health Survey - Cycle 3.1

DRG_Q05      Have you used it in the past 12 months?
IDGE_05
             1      Yes
             2      No             (Go to DRG_Q07)
                    DK, R          (Go to DRG_Q07)

DRG_C06      If DRG_Q04 = 1, go to DRG_Q07.

DRG_Q06      How often (did you use cocaine or crack in the past 12 months)?
IDGE_06      INTERVIEWER: Read categories to respondent.

             1      Less than once a month
             2      1 to 3 times a month
             3      Once a week
             4      More than once a week
             5      Every day
                    DK, R

DRG_Q07      Have you ever used or tried speed (amphetamines)?
IDGE_07
             1      Yes, just once
             2      Yes, more than once
             3      No                    (Go to DRG_Q10)
                    DK, R                 (Go to DRG_Q10)

DRG_Q08      Have you used it in the past 12 months?
IDGE_08
             1      Yes
             2      No                    (Go to DRG_Q10)
                    DK, R                 (Go to DRG_Q10)

DRG_C09      If DRG_Q07 = 1, go to DRG_Q10.

DRG_Q09      How often (did you use speed (amphetamines) in the past 12 months)?
IDGE_09      INTERVIEWER: Read categories to respondent.

             1      Less than once a month
             2      1 to 3 times a month
             3      Once a week
             4      More than once a week
             5      Every day
                    DK, R

DRG_Q10      Have you ever used or tried ecstasy (MDMA) or other similar drugs?
IDGE_10
             1      Yes, just once
             2      Yes, more than once
             3      No                    (Go to DRG_Q13)
                    DK, R                 (Go to DRG_Q13)




136                                                                            Statistics Canada
                                                Canadian Community Health Survey - Cycle 3.1

DRG_Q11       Have you used it in the past 12 months?
IDGE_11
              1      Yes
              2      No                     (Go to DRG_Q13)
                     DK, R                  (Go to DRG_Q13)

DRG_C12       If DRG_Q10 = 1, go to DRG_Q13.

DRG_Q12       How often (did you use ecstasy or other similar drugs in the past 12 months)?
IDGE_12       INTERVIEWER: Read categories to respondent.

              1      Less than once a month
              2      1 to 3 times a month
              3      Once a week
              4      More than once a week
              5      Every day
                     DK, R

DRG_Q13       Have you ever used or tried hallucinogens, PCP or LSD (acid)?
IDGE_13
              1      Yes, just once
              2      Yes, more than once
              3      No                     (Go to DRG_Q16)
                     DK, R                  (Go to DRG_Q16)

DRG_Q14       Have you used it in the past 12 months?
IDGE_14
              1      Yes
              2      No                     (Go to DRG_Q16)
                     DK, R                  (Go to DRG_Q16)

DRG_C15       If DRG_Q13 = 1, go to DRG_Q16.

DRG_Q15       How often (did you use hallucinogens, PCP or LSD in the past 12 months)?
IDGE_15       INTERVIEWER: Read categories to respondent.

              1      Less than once a month
              2      1 to 3 times a month
              3      Once a week
              4      More than once a week
              5      Every day
                     DK, R

DRG_Q16       Did you ever sniff glue, gasoline or other solvents?
IDGE_16
              1      Yes, just once
              2      Yes, more than once
              3      No                     (Go to DRG_Q19)
                     DK, R                  (Go to DRG_Q19)




Statistics Canada                                                                             137
Canadian Community Health Survey - Cycle 3.1

DRG_Q17      Did you sniff some in the past 12 months?
IDGE_17
             1      Yes
             2      No                      (Go to DRG_Q19)
                    DK, R                   (Go to DRG_Q19)

DRG_C18      If DRG_Q16 = 1, go to DRG_Q19.

DRG_Q18      How often (did you sniff glue, gasoline or other solvents in the past 12
IDGE_18      months)?
             INTERVIEWER: Read categories to respondent.

             1      Less than once a month
             2      1 to 3 times a month
             3      Once a week
             4      More than once a week
             5      Every day
                    DK, R

DRG_Q19      Have you ever used or tried heroin?
IDGE_19
             1      Yes, just once
             2      Yes, more than once
             3      No                      (Go to DRG_Q22)
                    DK, R                   (Go to DRG_Q22)

DRG_Q20      Have you used it in the past 12 months?
IDGE_20
             1      Yes
             2      No                      (Go to DRG_Q22)
                    DK, R                   (Go to DRG_Q22)

DRG_C21      If DRG_Q19 = 1, go to DRG_Q22.

DRG_Q21      How often (did you use heroin in the past 12 months)?
IDGE_21      INTERVIEWER: Read categories to respondent.

             1      Less than once a month
             2      1 to 3 times a month
             3      Once a week
             4      More than once a week
             5      Every day
                    DK, R

DRG_Q22      Have you ever used or tried steroids, such as testosterone, dianabol or growth
IDGE_22      hormones, to increase your performance in a sport or activity or to change your
             physical appearance?

             1      Yes, just once
             2      Yes, more than once
             3      No                             (Go to DRG_C25A1)
                    DK, R                          (Go to DRG_C25A1)




138                                                                             Statistics Canada
                                                 Canadian Community Health Survey - Cycle 3.1

DRG_Q23       Have you used it in the past 12 months?
IDGE_23
              1      Yes
              2      No                             (Go to DRG_C25A1)
                     DK, R                          (Go to DRG_C25A1)

DRG_C24       If DRG_Q22 = 1, go to DRG_C25A1.

DRG_Q24       How often (did you use steroids in the past 12 months)?
IDGE_24       INTERVIEWER: Read categories to respondent.

              1      Less than once a month
              2      1 to 3 times a month
              3      Once a week
              4      More than once a week
              5      Every day
                     DK, R

DRG_C25A_1 DRG_C25A1 = Count of instances where DRG_Q01, DRG_Q04, DRG_Q07, DRG_Q10,
           DRG_Q13, DRG_Q16 and DRG_Q19 = 3, DK or R.

              If DRG_C25A1 = 7, go to DRG_END.

DRG_C25A_2 DRG_C25A2 = Count of instances where DRG_Q03, DRG_Q06, DRG_Q09, DRG_Q12,
           DRG_Q15, DRG_Q18 and DRG_Q21 >= 2.

              If DRG_C25A_2 >= 1, go to DRG_Q25A.
              Otherwise, go to DRG_END.

DRG_Q25A      During the past 12 months, did you ever need to use more drugs than usual in
IDGE_25A      order to get high, or did you ever find that you could no longer get high on the
              amount you usually took?

              1      Yes
              2      No
                     DK, R

DRG_R25B      People who cut down their substance use or stop using drugs altogether may not
              feel well if they have been using steadily for some time. These feelings are more
              intense and can last longer than the usual hangover.
              INTERVIEWER: Press <Enter> to continue.

DRG_Q25B      During the past 12 months, did you ever have times when you stopped, cut down
IDGE_25B      or went without drugs and then experienced symptoms like fatigue, headaches,
              diarrhoea, the shakes or emotional problems?

              1      Yes
              2      No
                     DK, R




Statistics Canada                                                                                139
Canadian Community Health Survey - Cycle 3.1

DRG_Q25C     (During the past 12 months,) did you ever have times when you used drugs to keep
IDGE_25C     from having such symptoms?

             1      Yes
             2      No
                    DK, R

DRG_Q25D     (During the past 12 months,) did you ever have times when you used drugs
IDGE_25D     even though you promised yourself you wouldn’t, or times when you used
             a lot more drugs than you intended?

             1      Yes
             2      No
                    DK, R

DRG_Q25E     (During the past 12 months,) were there ever times when you used drugs more
IDGE_25E     frequently, or for more days in a row than you intended?

             1      Yes
             2      No
                    DK, R

DRG_Q25F     (During the past 12 months,) did you ever have periods of several days or more
IDGE_25F     when you spent so much time using drugs or recovering from the effects of using
             drugs that you had little time for anything else?

             1      Yes
             2      No
                    DK, R

DRG_Q25G     (During the past 12 months,) did you ever have periods of a month or longer
IDGE_25G     when you gave up or greatly reduced important activities because of your use of
             drugs?

             1      Yes
             2      No
                    DK, R

DRG_Q25H     (During the past 12 months,) did you ever continue to use drugs when you knew
IDGE_25H     you had a serious physical or emotional problem that might have been caused by
             or made worse by your use?

             1      Yes
             2      No
                    DK, R




140                                                                          Statistics Canada
                                                  Canadian Community Health Survey - Cycle 3.1

DRG_R26        Please tell me what number best describes how much your use of drugs interfered
               with each of the following activities during the past 12 months. For each activity,
               answer with a number between 0 and 10; 0 means “no interference”, while 10
               means “very severe interference”.
               INTERVIEWER: Press <Enter> to continue.

DRG_Q26A       How much did your use of drugs interfere with:
IDGE_26A
               ... your home responsibilities, like cleaning, shopping and taking care of the house
               or apartment?

               0      No interference
               1              I
               2              I
               3              I
               4              I
               5              I
               6              I
               7              I
               8              I
               9              V
               10     Very severe interference

               |_|_|   Number
               (MIN: 0) (MAX: 10)
               DK, R

DRG_Q26B_1 (How much did your use interfere with:)
IDGE_6B1
           ... your ability to attend school?
           INTERVIEWER: If necessary, enter “11” to indicate “Not applicable”.

               0      No interference
               1              I
               2              I
               3              I
               4              I
               5              I
               6              I
               7              I
               8              I
               9              V
               10     Very severe interference

               |_|_|   Number
               (MIN: 0) (MAX: 11)
               DK, R




Statistics Canada                                                                              141
Canadian Community Health Survey - Cycle 3.1

DRG_Q26B_2 (How much did your use interfere with:)
IDGE_6B2
           ... your ability to work at a regular job?
           INTERVIEWER: If necessary, enter “11” to indicate “Not applicable”.

               0      No interference
               1              I
               2              I
               3              I
               4              I
               5              I
               6              I
               7              I
               8              I
               9              V
               10     Very severe interference

               |_|_|   Number
               (MIN: 0) (MAX: 11)
               DK, R

DRG_Q26C       (During the past 12 months,) how much did your use of drugs interfere with your
IDGE_26C       ability to form and maintain close relationships with other people?
               Remember that 0 means “no interference” and 10 means “very severe
               interference”.

               0      No interference
               1              I
               2              I
               3              I
               4              I
               5              I
               6              I
               7              I
               8              I
               9              V
               10     Very severe interference

               |_|_|   Number
               (MIN: 0) (MAX: 10)
               DK, R




142                                                                              Statistics Canada
                                                Canadian Community Health Survey - Cycle 3.1

DRG_Q26D      How much did your use of drugs interfere with your social life?
IDGE_26D
              0      No interference
              1              I
              2              I
              3              I
              4              I
              5              I
              6              I
              7              I
              8              I
              9              V
              10     Very severe interference

              |_|_|   Number
              (MIN: 0) (MAX: 10)
              DK, R

DRG_END




Statistics Canada                                                                       143
Canadian Community Health Survey - Cycle 3.1



PROBLEM GAMBLING INDEX(CPG)
CPG_BEG

CPG_C1       If (do CPG block = 1), go to CPG_C2.
CPGEFOPT     Otherwise, go to CPG_END.

CPG_C2       If proxy interview, go to CPG_END.
             Otherwise, go to CPG_C3.

CPG_C3       Count instances where CPG_Q01B to CPG_Q01M = 7, 8, DK or R.

CPG_R01      People have different definitions of gambling. They may bet money and gamble on
             many different things, including buying lottery tickets, playing bingo or playing
             card games with their family or friends.

             The next questions are about gambling activities and experiences. Some of these
             questions may not apply to you; however, they need to be asked of all
             respondents.
             INTERVIEWER: Press <Enter> to continue.

CPG_Q01A     In the past 12 months, how often have you bet or spent money on instant
CPGE_01A     win/scratch tickets or daily lottery tickets (Keno, Pick 3, Encore, Banco, Extra)?
             INTERVIEWER: Read categories to respondent.
             Exclude all other kinds of lottery tickets such as 6/49, Super 7, sports lotteries and fund
             raising tickets.

             1       Daily
             2       Between 2 to 6 times a week
             3       About once a week
             4       Between 2 to 3 times a month
             5       About once a month
             6       Between 6 to 11 times a year
             7       Between 1 to 5 times a year
             8       Never
                     DK, R

CPG_C01A     If CPG_Q01A = R, go to CPG_END
             Otherwise, go to CPG_Q01B.




144                                                                                   Statistics Canada
                                                Canadian Community Health Survey - Cycle 3.1

CPG_Q01B      (In the past 12 months,) how often have you bet or spent money on lottery tickets
CPGE_01B      such as 6/49 and Super 7, raffles or fund-raising tickets?

              1      Daily
              2      Between 2 to 6 times a week
              3      About once a week
              4      Between 2 to 3 times a month
              5      About once a month
              6      Between 6 to 11 times a year
              7      Between 1 to 5 times a year
              8      Never
                     DK, R

CPG_Q01C      (In the past 12 months,) how often have you bet or spent money on Bingo?
CPGE_01C
              1      Daily
              2      Between 2 to 6 times a week
              3      About once a week
              4      Between 2 to 3 times a month
              5      About once a month
              6      Between 6 to 11 times a year
              7      Between 1 to 5 times a year
              8      Never
                     DK, R

CPG_Q01D      (In the past 12 months,) how often have you bet or spent money playing cards or
CPGE_01D      board games with family or friends?

              1      Daily
              2      Between 2 to 6 times a week
              3      About once a week
              4      Between 2 to 3 times a month
              5      About once a month
              6      Between 6 to 11 times a year
              7      Between 1 to 5 times a year
              8      Never
                     DK, R

CPG_Q01E      (In the past 12 months,) how often have you bet or spent money on video lottery
CPGE_01E      terminals (VLTs) outside of casinos?

              1      Daily
              2      Between 2 to 6 times a week
              3      About once a week
              4      Between 2 to 3 times a month
              5      About once a month
              6      Between 6 to 11 times a year
              7      Between 1 to 5 times a year
              8      Never
                     DK, R




Statistics Canada                                                                            145
Canadian Community Health Survey - Cycle 3.1

CPG_Q01F     (In the past 12 months,) how often have you bet or spent money on coin slots or
CPGE_01F     VLTs at a casino?

             1      Daily
             2      Between 2 to 6 times a week
             3      About once a week
             4      Between 2 to 3 times a month
             5      About once a month
             6      Between 6 to 11 times a year
             7      Between 1 to 5 times a year
             8      Never
                    DK, R

CPG_Q01G     (In the past 12 months,) how often have you bet or spent money on casino games
CPGE_01G     other than coin slots or VLTs (for example, poker, roulette, blackjack, Keno)?

             1      Daily
             2      Between 2 to 6 times a week
             3      About once a week
             4      Between 2 to 3 times a month
             5      About once a month
             6      Between 6 to 11 times a year
             7      Between 1 to 5 times a year
             8      Never
                    DK, R

CPG_Q01H     (In the past 12 months,) how often have you bet or spent money on Internet or
CPGE_01H     arcade gambling?

             1      Daily
             2      Between 2 to 6 times a week
             3      About once a week
             4      Between 2 to 3 times a month
             5      About once a month
             6      Between 6 to 11 times a year
             7      Between 1 to 5 times a year
             8      Never
                    DK, R

CPG_Q01I     In the past 12 months, how often have you bet or spent money on live horse racing
CPGE_01I     at the track or off track?

             1      Daily
             2      Between 2 to 6 times a week
             3      About once a week
             4      Between 2 to 3 times a month
             5      About once a month
             6      Between 6 to 11 times a year
             7      Between 1 to 5 times a year
             8      Never
                    DK, R




146                                                                          Statistics Canada
                                                 Canadian Community Health Survey - Cycle 3.1

CPG_Q01J      (In the past 12 months,) how often have you bet or spent money on sports such as
CPGE_01J      sports lotteries (Sport Select, Pro-Line, Mise-au-jeu, Total), sports pool or sporting
              events?

              1      Daily
              2      Between 2 to 6 times a week
              3      About once a week
              4      Between 2 to 3 times a month
              5      About once a month
              6      Between 6 to 11 times a year
              7      Between 1 to 5 times a year
              8      Never
                     DK, R

CPG_Q01K      (In the past 12 months,) how often have you bet or spent money on speculative
CPGE_01K      investments such as stocks, options or commodities?
              INTERVIEWER: Speculative investments refers to buying high-risk stocks, but does not
              include low-risk bonds, RRSPs and/or mutual funds.

              1      Daily
              2      Between 2 to 6 times a week
              3      About once a week
              4      Between 2 to 3 times a month
              5      About once a month
              6      Between 6 to 11 times a year
              7      Between 1 to 5 times a year
              8      Never
                     DK, R

CPG_Q01L      In the past 12 months, how often have you bet or spent money on games of skill
CPGE_01L      such as pool, golf, bowling or darts?

              1      Daily
              2      Between 2 to 6 times a week
              3      About once a week
              4      Between 2 to 3 times a month
              5      About once a month
              6      Between 6 to 11 times a year
              7      Between 1 to 5 times a year
              8      Never
                     DK, R




Statistics Canada                                                                               147
Canadian Community Health Survey - Cycle 3.1

CPG_Q01M     (In the past 12 months,) how often have you bet or spent money on any other
CPGE_01M     forms of gambling such as dog races, gambling at casino nights/country fairs, bet
             on sports with a bookie or gambling pools at work?

             1      Daily
             2      Between 2 to 6 times a week
             3      About once a week
             4      Between 2 to 3 times a month
             5      About once a month
             6      Between 6 to 11 times a year
             7      Between 1 to 5 times a year
             8      Never
                    DK, R

CPG_C01N     If CPG_C03 = 12 and CPG_Q01A = 7, 8 or DK, go to CPG_END.
             Otherwise, go to CPG_Q01N.

CPG_Q01N     In the past 12 months, how much money, not including winnings, did you spend on
CPGE_01N     all of your gambling activities?
             INTERVIEWER: Read categories to respondent.

             1      Between 1 dollar and 50 dollars
             2      Between 51 dollars and 100 dollars
             3      Between 101 dollars and 250 dollars
             4      Between 251 dollars and 500 dollars
             5      Between 501 dollars and 1000 dollars
             6      More than 1000 dollars
                    DK, R

CPG_QINT2    The next questions are about gambling attitudes and experiences. Again, all the
             questions will refer to the past 12 months.
             INTERVIEWER: Press <Enter> to continue.

CPG_Q02      In the past 12 months, how often have you bet or spent more money than you
CPGE_02      wanted to on gambling?
             INTERVIEWER: Read categories to respondent.

             1      Never
             2      Sometimes
             3      Most of the time
             4      Almost always
             5      I am not a gambler    (Go to CPG_END)
                    DK
                    R                     (Go to CPG_END)

CPG_Q03      (In the past 12 months,) how often have you needed to gamble with larger amounts
CPGE_03      of money to get the same feeling of excitement?

             1      Never
             2      Sometimes
             3      Most of the time
             4      Almost always
                    DK, R




148                                                                          Statistics Canada
                                                Canadian Community Health Survey - Cycle 3.1

CPG_Q04       (In the past 12 months,) when you gambled, how often did you go back another
CPGE_04       day to try to win back the money you lost?

              1      Never
              2      Sometimes
              3      Most of the time
              4      Almost always
                     DK, R

CPG_Q05       In the past 12 months, how often have you borrowed money or sold anything to
CPGE_05       get money to gamble?

              1      Never
              2      Sometimes
              3      Most of the time
              4      Almost always
                     DK, R

CPG_Q06       (In the past 12 months,) how often have you felt that you might have a problem
CPGE_06       with gambling?

              1      Never
              2      Sometimes
              3      Most of the time
              4      Almost always
                     DK, R

CPG_Q07       (In the past 12 months,) how often has gambling caused you any health problems,
CPGE_07       including stress or anxiety?

              1      Never
              2      Sometimes
              3      Most of the time
              4      Almost always
                     DK, R

CPG_Q08       (In the past 12 months,) how often have people criticized your betting or told you
CPGE_08       that you had a gambling problem, regardless of whether or not you thought it was
              true?

              1      Never
              2      Sometimes
              3      Most of the time
              4      Almost always
                     DK, R

CPG_Q09       (In the past 12 months,) how often has your gambling caused financial problems
CPGE_09       for you or your family?

              1      Never
              2      Sometimes
              3      Most of the time
              4      Almost always
                     DK, R




Statistics Canada                                                                              149
Canadian Community Health Survey - Cycle 3.1

CPG_Q10      In the past 12 months, how often have you felt guilty about the way you gamble
CPGE_10      or what happens when you gamble?

             1      Never
             2      Sometimes
             3      Most of the time
             4      Almost always
                    DK, R

CPG_Q11      (In the past 12 months,) how often have you lied to family members or others
CPGE_11      to hide your gambling?

             1      Never
             2      Sometimes
             3      Most of the time
             4      Almost always
                    DK, R

CPG_Q12      (In the past 12 months,) how often have you wanted to stop betting money or
CPGE_12      gambling, but didn’t think you could?

             1      Never
             2      Sometimes
             3      Most of the time
             4      Almost always
                    DK, R

CPG_Q13      In the past 12 months, how often have you bet more than you could really afford
CPGE_13      to lose?

             1      Never
             2      Sometimes
             3      Most of the time
             4      Almost always
                    DK, R

CPG_Q14      (In the past 12 months,) have you tried to quit or cut down on your gambling but
CPGE_14      were unable to do it?

             1      Never
             2      Sometimes
             3      Most of the time
             4      Almost always
                    DK, R

CPG_Q15      (In the past 12 months,) have you gambled as a way of forgetting problems or to
CPGE_15      feel better when you were depressed?

             1      Never
             2      Sometimes
             3      Most of the time
             4      Almost always
                    DK, R




150                                                                           Statistics Canada
                                                Canadian Community Health Survey - Cycle 3.1

CPG_Q16       (In the past 12 months,) has your gambling caused any problems with your
CPGE_16       relationship with any of your family members or friends?

              1      Never
              2      Sometimes
              3      Most of the time
              4      Almost always
                     DK, R

CPG_C17       For CPG_Q03 through CPG_Q10 and CPG_Q13, recode 1=0, 2=1, 3=2 and 4=3 into
              CPG_C17A through CPG_C17I.
              CPG_C17J = Sum CPG_C17A through CPG_C17I.
              If CPG_C17J <= 2, go to CPG_END.
              Otherwise, go to CPG_Q17.

CPG_Q17       Has anyone in your family ever had a gambling problem?
CPGE_17
              1      Yes
              2      No
                     DK, R

CPG_Q18       In the past 12 months, have you used alcohol or drugs while gambling?
CPGE_18
              1      Yes
              2      No
                     DK, R

CPG_QINT19 Please tell me what number best describes how much your gambling activities
           interfered with each of the following activities during the past 12 months. For each
           activity, answer with a number between 0 and 10; 0 means “no interference”, while
           10 means “very severe interference”.
           INTERVIEWER: Press <Enter> to continue.

CPG_Q19A      During the past 12 months, how much did your gambling activities interfere with
CPGE_19A      your home responsibilities, like cleaning, shopping and taking care of the house or
              apartment?

              0      No interference
              1              I
              2              I
              3              I
              4              I
              5              I
              6              I
              7              I
              8              I
              9             V
              10     Very severe interference

              |_|_|   Number
              (MIN: 0) (MAX: 10)
              DK, R




Statistics Canada                                                                            151
Canadian Community Health Survey - Cycle 3.1

CPG_Q19B_1 How much did these activities interfere with your ability to attend school?
CPGE_9B1   INTERVIEWER: If necessary, enter “11” to indicate “Not applicable”.

               0      No interference
               1              I
               2              I
               3              I
               4              I
               5              I
               6              I
               7              I
               8              I
               9             V
               10     Very severe interference

               |_|_|   Number
               (MIN: 0) (MAX: 11)
               DK, R

CPG_Q19B_2 How much did they interfere with your ability to work at a job?
CPGE_9B2   INTERVIEWER: If necessary, enter “11” to indicate “Not applicable”.

               0      No interference
               1              I
               2              I
               3              I
               4              I
               5              I
               6              I
               7              I
               8              I
               9             V
               10     Very severe interference

               |_|_|   Number
               (MIN: 0) (MAX: 11)
               DK, R




152                                                                              Statistics Canada
                                                Canadian Community Health Survey - Cycle 3.1

CPG_Q19C      (During the past 12 months,) how much did your gambling activities interfere with
CPGE_19C      your ability to form and maintain close relationships with other people?
              (Remember that 0 means “no interference” and 10 means “very severe
              interference”.)

              0      No interference
              1              I
              2              I
              3              I
              4              I
              5              I
              6              I
              7              I
              8              I
              9             V
              10     Very severe interference

              |_|_|   Number
              (MIN: 0) (MAX: 10)
              DK, R

CPG_Q19D      How much did they interfere with your social life?
CPGE_19D

              0      No interference
              1              I
              2              I
              3              I
              4              I
              5              I
              6              I
              7              I
              8              I
              9              V
              10     Very severe interference

              |_|_|   Number
              (MIN: 0) (MAX: 10)
              DK, R

CPG_END




Statistics Canada                                                                           153
Canadian Community Health Survey - Cycle 3.1



SATISFACTION WITH LIFE (SWL)
SWL_BEG

SWL_C1       If (do SWL block = 1), go to SWL_C2.
SWLEFOPT     Otherwise, go to SWL_END.

SWL_C2       If proxy interview, go to SWL_END.
             Otherwise, go to SWL_QINT.

SWL_QINT     Now I’d like to ask about your satisfaction with various aspects of your life. For
             each question, please tell me whether you are very satisfied, satisfied, neither
             satisfied nor dissatisfied, dissatisfied, or very dissatisfied.
             INTERVIEWER: Press <Enter> to continue.

SWL_Q02      How satisfied are you with your job or main activity?
SWLE_02
             1      Very satisfied
             2      Satisfied
             3      Neither satisfied nor dissatisfied
             4      Dissatisfied
             5      Very dissatisfied
                    DK
                    R        (Go to SWL_END)

SWL_Q03      How satisfied are you with your leisure activities?
SWLE_03
             1      Very satisfied
             2      Satisfied
             3      Neither satisfied nor dissatisfied
             4      Dissatisfied
             5      Very dissatisfied
                    DK, R

SWL_Q04      (How satisfied are you) with your financial situation?
SWLE_04
             1      Very satisfied
             2      Satisfied
             3      Neither satisfied nor dissatisfied
             4      Dissatisfied
             5      Very dissatisfied
                    DK, R

SWL_Q05      How satisfied are you with yourself?
SWLE_05
             1      Very satisfied
             2      Satisfied
             3      Neither satisfied nor dissatisfied
             4      Dissatisfied
             5      Very dissatisfied
                    DK, R




154                                                                             Statistics Canada
                                                   Canadian Community Health Survey - Cycle 3.1

SWL_Q06       How satisfied are you with the way your body looks?
SWLE_06
              1      Very satisfied
              2      Satisfied
              3      Neither satisfied nor dissatisfied
              4      Dissatisfied
              5      Very dissatisfied
                     DK, R

SWL_Q07       How satisfied are you with your relationships with other family members?
SWLE_07
              1      Very satisfied
              2      Satisfied
              3      Neither satisfied nor dissatisfied
              4      Dissatisfied
              5      Very dissatisfied
                     DK, R

SWL_Q08       (How satisfied are you) with your relationships with friends?
SWLE_08
              1      Very satisfied
              2      Satisfied
              3      Neither satisfied nor dissatisfied
              4      Dissatisfied
              5      Very dissatisfied
                     DK, R

SWL_Q09       (How satisfied are you) with your housing?
SWLE_09
              1      Very satisfied
              2      Satisfied
              3      Neither satisfied nor dissatisfied
              4      Dissatisfied
              5      Very dissatisfied
                     DK, R

SWL_Q10       (How satisfied are you) with your neighbourhood?
SWLE_10
              1      Very satisfied
              2      Satisfied
              3      Neither satisfied nor dissatisfied
              4      Dissatisfied
              5      Very dissatisfied
                     DK, R

SWL_END




Statistics Canada                                                                          155
Canadian Community Health Survey - Cycle 3.1



STRESS - SOURCES (STS)
STS_BEG

STS_C1       If (do STS block = 1), go to STS_C2.
STSEFOPT     Otherwise, go to STS_END.

STS_C2       If proxy interview, go to STS_END.
             Otherwise, go to STS_R1.

STS_R1       Now a few questions about the stress in your life.
             INTERVIEWER: Press <Enter> to continue.

STS_Q1       In general, how would you rate your ability to handle unexpected and difficult
STSE_1       problems, for example, a family or personal crisis? Would you say your ability is:
             INTERVIEWER: Read categories to respondent.

             1      … excellent?
             2      … very good?
             3      … good?
             4      … fair?
             5      … poor?
                    DK, R                   (Go to STS_END)

STS_Q2       In general, how would you rate your ability to handle the day-to-day demands in
STSE_2       your life, for example, handling work, family and volunteer responsibilities?
             Would you say your ability is:
             INTERVIEWER: Read categories to respondent.

             1      … excellent?
             2      … very good?
             3      … good?
             4      … fair?
             5      … poor?
                    DK, R




156                                                                            Statistics Canada
                                                  Canadian Community Health Survey - Cycle 3.1

STS_Q3        Thinking about stress in your day-to-day life, what would you say is the most
STSE_3        important thing contributing to feelings of stress you may have?
              INTERVIEWER: Do not probe.

              1      Time pressures / not enough time
              2      Own physical health problem or condition
              3      Own emotional or mental health problem or condition
              4      Financial situation (e.g., not enough money, debt)
              5      Own work situation (e.g., hours of work, working conditions)
              6      School
              7      Employment status (e.g., unemployment)
              8      Caring for - own children
              9      Caring for - others
              10     Other personal or family responsibilities
              11     Personal relationships
              12     Discrimination
              13     Personal and family’s safety
              14     Health of family members
              15     Other - Specify
              16     Nothing                    (Go to STS_END)
                     DK, R                      (Go to STS_END)

STS_C3S       If STS_Q3 = 16, go to STS_Q3S.
              Otherwise, go to STS_END.

STS_Q3S       INTERVIEWER: Specify.

              ________________________
              (80 spaces)
              DK, R

STS_END




Statistics Canada                                                                             157
Canadian Community Health Survey - Cycle 3.1



STRESS - COPING (STC)
STC_BEG

STC_C1       If (do STC block = 1), go to STC_C2.
STCEFOPT     Otherwise, go to STR_END.

STC_C2       If proxy interview, go to STC_END.
             Otherwise, go to STC_R1.

STC_R1       Now a few questions about coping with stress.
             INTERVIEWER: Press <Enter> to continue.

STC_Q1_1     People have different ways of dealing with stress. Thinking about the ways you
STCE_61      deal with stress, please tell me how often you do each of the following.

             How often do you try to solve the problem?
             INTERVIEWER: Read categories to respondent.

             1      Often
             2      Sometimes
             3      Rarely
             4      Never
                    DK, R           (Go to STC_END)

STC_Q1_2     To deal with stress, how often do you talk to others?
STCE_62
             1      Often
             2      Sometimes
             3      Rarely
             4      Never
                    DK, R

STC_Q1_3     (When dealing with stress,) how often do you avoid being with people?
STCE_63
             1      Often
             2      Sometimes
             3      Rarely
             4      Never
                    DK, R

STC_Q1_4     How often do you sleep more than usual to deal with stress?
STCE_64
             1      Often
             2      Sometimes
             3      Rarely
             4      Never
                    DK, R




158                                                                          Statistics Canada
                                                Canadian Community Health Survey - Cycle 3.1

STC_Q1_5A     When dealing with stress, how often do you try to feel better by eating more,
STCE_65A      or less, than usual?

              1      Often
              2      Sometimes
              3      Rarely
              4      Never
                     DK, R

STC_Q1_5B     (When dealing with stress,) how often do you try to feel better by smoking more
STCE_65B      cigarettes than usual?

              1      Often
              2      Sometimes
              3      Rarely
              4      Never
              5      Do not smoke
                     DK, R

STC_Q1_5C     When dealing with stress, how often do you try to feel better by drinking alcohol?
STCE_65C
              1      Often
              2      Sometimes
              3      Rarely
              4      Never
                     DK, R

STC_Q1_5D     (When dealing with stress,) how often do you try to feel better by using drugs or
STCE_65D      medication?

              1      Often
              2      Sometimes
              3      Rarely
              4      Never
                     DK, R

STC_Q1_6      How often do you jog or do other exercise to deal with stress?
STCE_66

              1      Often
              2      Sometimes
              3      Rarely
              4      Never
                     DK, R


STC_Q1_7      How often do you pray or seek spiritual help to deal with stress?
STCE_67
              1      Often
              2      Sometimes
              3      Rarely
              4      Never
                     DK, R




Statistics Canada                                                                             159
Canadian Community Health Survey - Cycle 3.1

STC_Q1_8     (To deal with stress,) how often do you try to relax by doing something enjoyable?
STCE_68
             1      Often
             2      Sometimes
             3      Rarely
             4      Never
                    DK, R

STC_Q1_9     (To deal with stress,) how often do you try to look on the bright side of things?
STCE_69
             1      Often
             2      Sometimes
             3      Rarely
             4      Never
                    DK, R

STC_Q1_10    How often do you blame yourself?
STCE_610
             1      Often
             2      Sometimes
             3      Rarely
             4      Never
                    DK, R

STC_Q1_11    To deal with stress, how often do you wish the situation would go away or
STCE_611     somehow be finished?

             1      Often
             2      Sometimes
             3      Rarely
             4      Never
                    DK, R

STC_END




160                                                                             Statistics Canada
                                                    Canadian Community Health Survey - Cycle 3.1



CHILDHOOD AND ADULT STRESSORS (CST)
CST_BEG

CST_C1        If (do CST block = 1) go to CST_C2.
CSTEFOPT      Otherwise, go to CST_END.

CST_C2        If proxy interview or age < 18, go to CST_END.
              Otherwise, go to CST_R1.

CST_R1        The next few questions ask about some things that may have happened to you
              while you were a child or a teenager, before you moved out of the house.
              Please tell me if any of these things have happened to you.
              INTERVIEWER: Press <Enter> to continue.

CST_Q1        Did you spend 2 weeks or more in the hospital?
CSTE_1
              1      Yes
              2      No
                     DK
                     R               (Go to CST_END)

CST_Q2        Did your parents get a divorce?
CSTE_2
              1      Yes
              2      No
                     DK, R

CST_Q3        Did your father or mother not have a job for a long time when they wanted
CSTE_3        to be working?

              1      Yes
              2      No
                     DK, R

CST_Q4        Did something happen that scared you so much you thought about it for
CSTE_4        years after?

              1      Yes
              2      No
                     DK, R

CST_Q5        Were you sent away from home because you did something wrong?
CSTE_5
              1      Yes
              2      No
                     DK, R




Statistics Canada                                                                           161
Canadian Community Health Survey - Cycle 3.1

CST_Q6       Did either of your parents drink or use drugs so often that it caused
CSTE_6       problems for the family?

             1      Yes
             2      No
                    DK, R

CST_Q7       Were you ever physically abused by someone close to you?
CSTE_7
             1      Yes
             2      No
                    DK, R

CST_END




162                                                                            Statistics Canada
                                                   Canadian Community Health Survey - Cycle 3.1



WORK STRESS (WST)
WST_BEG

WST_C1        If (do WST block) = 1, go to WST_C2.
WSTEFOPT      Otherwise, go to WST_END.

WST_C2        If proxy interview, go to WST_END.
              Otherwise, go to WST_C3.

WST_C3        If age < 15 or > 75, or GEN_Q08 = 2, go to WST_END.
              Otherwise, go to WST_R4.

WST_R4        The next few questions are about your main job or business in the past 12 months.
              I’m going to read you a series of statements that might describe your job situation.
              Please tell me if you strongly agree, agree, neither agree nor disagree, disagree, or
              strongly disagree.
              INTERVIEWER: Press <Enter> to continue.

WST_Q401      Your job required that you learn new things.
WSTE_401
              1       Strongly agree
              2       Agree
              3       Neither agree nor disagree
              4       Disagree
              5       Strongly disagree
                      DK
                      R       (Go to WST_END)

WST_Q402      Your job required a high level of skill.
WSTE_402
              1       Strongly agree
              2       Agree
              3       Neither agree nor disagree
              4       Disagree
              5       Strongly disagree
                      DK, R

WST_Q403      Your job allowed you freedom to decide how you did your job.
WSTE_403
              1       Strongly agree
              2       Agree
              3       Neither agree nor disagree
              4       Disagree
              5       Strongly disagree
                      DK, R




Statistics Canada                                                                              163
Canadian Community Health Survey - Cycle 3.1

WST_Q404     Your job required that you do things over and over.
WSTE_404
             1       Strongly agree
             2       Agree
             3       Neither agree nor disagree
             4       Disagree
             5       Strongly disagree
                     DK, R

WST_Q405     Your job was very hectic.
WSTE_405
             1       Strongly agree
             2       Agree
             3       Neither agree nor disagree
             4       Disagree
             5       Strongly disagree
                     DK, R

WST_Q406     You were free from conflicting demands that others made.
WSTE_406
             1       Strongly agree
             2       Agree
             3       Neither agree nor disagree
             4       Disagree
             5       Strongly disagree
                     DK, R

WST_Q407     Your job security was good.
WSTE_407
             1       Strongly agree
             2       Agree
             3       Neither agree nor disagree
             4       Disagree
             5       Strongly disagree
                     DK, R

WST_Q408     Your job required a lot of physical effort.
WSTE_408
             1       Strongly agree
             2       Agree
             3       Neither agree nor disagree
             4       Disagree
             5       Strongly disagree
                     DK, R

WST_Q409     You had a lot to say about what happened in your job.
WSTE_409
             1       Strongly agree
             2       Agree
             3       Neither agree nor disagree
             4       Disagree
             5       Strongly disagree
                     DK, R




164                                                                     Statistics Canada
                                                  Canadian Community Health Survey - Cycle 3.1

WST_Q410      You were exposed to hostility or conflict from the people you worked with.
WSTE_410
              1      Strongly agree
              2      Agree
              3      Neither agree nor disagree
              4      Disagree
              5      Strongly disagree
                     DK, R

WST_Q411      Your supervisor was helpful in getting the job done.
WSTE_411
              1      Strongly agree
              2      Agree
              3      Neither agree nor disagree
              4      Disagree
              5      Strongly disagree
                     DK, R

WST_Q412      The people you worked with were helpful in getting the job done.
WSTE_412
              1      Strongly agree
              2      Agree
              3      Neither agree nor disagree
              4      Disagree
              5      Strongly disagree
                     DK, R

WST_Q412A     You had the materials and equipment you needed to do your job.
WSTE_12A
              1      Strongly agree
              2      Agree
              3      Neither agree nor disagree
              4      Disagree
              5      Strongly disagree
                     DK, R

WST_Q413      How satisfied were you with your job?
WSTE_413      INTERVIEWER: Read categories to respondent.

              1      Very satisfied
              2      Somewhat satisfied
              3      Not too satisfied
              4      Not at all satisfied
                     DK, R

WST_END




Statistics Canada                                                                          165
Canadian Community Health Survey - Cycle 3.1



SELF-ESTEEM (SFE)
SFE_BEG

SFE_C500A    If (do SFE block = 1), go to SFE_C500B.
SFEEFOPT     Otherwise, go to SFE_END.

SFE_C500B    If proxy interview, go to SFE_END.
             Otherwise, go to SFE_R5.

SFE_R5       Now a series of statements that people might use to describe themselves.

             Please tell me if you strongly agree, agree, neither agree nor disagree, disagree, or
             strongly disagree.
             INTERVIEWER: Press <Enter> to continue.

SFE_Q501     You feel that you have a number of good qualities.
SFEE_501
             1      Strongly agree
             2      Agree
             3      Neither agree nor disagree
             4      Disagree
             5      Strongly disagree
                    DK
                    R               (Go to SFE_END)

SFE_Q502     You feel that you’re a person of worth at least equal to others.
SFEE_502
             1      Strongly agree
             2      Agree
             3      Neither agree nor disagree
             4      Disagree
             5      Strongly disagree
                    DK, R

SFE_Q503     You are able to do things as well as most other people.
SFEE_503
             1      Strongly agree
             2      Agree
             3      Neither agree nor disagree
             4      Disagree
             5      Strongly disagree
                    DK, R

SFE_Q504     You take a positive attitude toward yourself.
SFEE_504
             1      Strongly agree
             2      Agree
             3      Neither agree nor disagree
             4      Disagree
             5      Strongly disagree
                    DK, R




166                                                                             Statistics Canada
                                                    Canadian Community Health Survey - Cycle 3.1

SFE_Q505      On the whole you are satisfied with yourself.
SFEE_505
              1       Strongly agree
              2       Agree
              3       Neither agree nor disagree
              4       Disagree
              5       Strongly disagree
                      DK, R

SFE_Q506      All in all, you’re inclined to feel you’re a failure.
SFEE_506
              1       Strongly agree
              2       Agree
              3       Neither agree nor disagree
              4       Disagree
              5       Strongly disagree
                      DK, R

SFE_END




Statistics Canada                                                                           167
Canadian Community Health Survey - Cycle 3.1



SOCIAL SUPPORT - AVAILABILITY (SSA)
SSA_BEG

SSA_C1       If (do SSA block = 1), go to SSA_C2.
SSAEFOPT     Otherwise, go to SSA_END.

SSA_C2       If proxy interview, go to SSA_END.
             Otherwise, go to SSA_R1.

SSA_R1       Next are some questions about the support that is available to you.
             INTERVIEWER : Press <Enter> to continue.

SSA_Q01      Starting with a question on friendship, about how many close friends and close
SSAE_01      relatives do you have, that is, people you feel at ease with and can talk to about
             what is on your mind?

             |_|_|   Close friends
             (MIN: 0) (MAX: 99; warning after 20)

             DK, R (Go to SSA_END)

SSA_R2       People sometimes look to others for companionship, assistance or other types of
             support.
             INTERVIEWER: Press <Enter> to continue.

SSA_Q02      How often is each of the following kinds of support available to you if you need it:
SSAE_02
             … someone to help you if you were confined to bed?
             INTERVIEWER: Read categories to respondent.

             1       None of the time
             2       A little of the time
             3       Some of the time
             4       Most of the time
             5       All of the time
                     DK, R             (Go to SSA_END)

SSA_C02      If SSA_Q02 = 2, 3, 4 or 5 then KEY_PHRASES21A = “to help you if you were confined to
             bed”.




168                                                                             Statistics Canada
                                                 Canadian Community Health Survey - Cycle 3.1

SSA_Q03       (How often is each of the following kinds of support available to you if you need it:)
SSAE_03
              … someone you can count on to listen to you when you need to talk?

              1      None of the time
              2      A little of the time
              3      Some of the time
              4      Most of the time
              5      All of the time
                     DK, R

SSA_C03       If SSA_Q03 = 2, 3, 4 or 5 then KEY_PHRASES24A = “to listen to you”.

SSA_Q04       (How often is each of the following kinds of support available to you if you need it:)
SSAE_04
              … someone to give you advice about a crisis?

              1      None of the time
              2      A little of the time
              3      Some of the time
              4      Most of the time
              5      All of the time
                     DK, R

SSA_C04       If SSA_Q04 = 2, 3, 4 or 5 then KEY_PHRASES24A = “to give you advice”.

SSA_Q05       (How often is each of the following kinds of support available to you if you need it:)
SSAE_05
              … someone to take you to the doctor if you needed it?

              1      None of the time
              2      A little of the time
              3      Some of the time
              4      Most of the time
              5      All of the time
                     DK, R

SSA_C05       If SSA_Q05 = 2, 3, 4 or 5 then KEY_PHRASES21A = “to take you to the doctor”.




Statistics Canada                                                                               169
Canadian Community Health Survey - Cycle 3.1

SSA_Q06      (How often is each of the following kinds of support available to you if you need it:)
SSAE_06
             … someone who shows you love and affection?

             1      None of the time
             2      A little of the time
             3      Some of the time
             4      Most of the time
             5      All of the time
                    DK, R

SSA_C06       If SSA_Q06 = 2, 3, 4 or 5 then KEY_PHRASES22A = “to show you affection”.

SSA_Q07      Again, how often is each of the following kinds of support available to you if you
SSAE_07      need it:)

             … someone to have a good time with?

             1      None of the time
             2      A little of the time
             3      Some of the time
             4      Most of the time
             5      All of the time
                    DK, R

SSA_C07      If SSA_Q07 = 2, 3, 4 or 5 then KEY_PHRASES23A = “to have a good time with”.

SSA_Q08      (How often is each of the following kinds of support available to you if you need it:)
SSAE_08
             … someone to give you information in order to help you understand a situation?

             1      None of the time
             2      A little of the time
             3      Some of the time
             4      Most of the time
             5      All of the time
                    DK, R

SSA_C08      If SSA_Q08 = 2, 3, 4 or 5 then KEY_PHRASES24A = “to give you information”.




170                                                                             Statistics Canada
                                                 Canadian Community Health Survey - Cycle 3.1

SSA_Q09       (How often is each of the following kinds of support available to you if you need it:)
SSAE_09
              … someone to confide in or talk to about yourself or your problems?

              1       None of the time
              2       A little of the time
              3       Some of the time
              4       Most of the time
              5       All of the time
                      DK, R

SSA_C09       If SSA_Q09 = 2, 3, 4 or 5 then KEY_PHRASES24A =“to confide in”.

SSA_Q10       (How often is each of the following kinds of support available to you if you need it:)
SSAE_10
              … someone who hugs you?

              1       None of the time
              2       A little of the time
              3       Some of the time
              4       Most of the time
              5       All of the time
                      DK, R

SSA_C10       If SSA_Q10 = 2, 3, 4 or 5 then KEY_PHRASES22A = “to hug you”.

SSA_Q11       (How often is each of the following kinds of support available to you if you need it:)
SSAE_11
              … someone to get together with for relaxation?

              1       None of the time
              2       A little of the time
              3       Some of the time
              4       Most of the time
              5       All of the time
                      DK, R

SSA_C11        If SSA_Q11 = 2, 3, 4 or 5 then KEY_PHRASE23A = “to relax with”.




Statistics Canada                                                                               171
Canadian Community Health Survey - Cycle 3.1

SSA_Q12      (How often is each of the following kinds of support available to you if you need it:)
SSAE_12
             … someone to prepare your meals if you were unable to do it yourself?

             1      None of the time
             2      A little of the time
             3      Some of the time
             4      Most of the time
             5      All of the time
                    DK, R

SSA_C12      If SSA_Q12 = 2, 3, 4 or 5 then KEY_PHRASES21A = “to prepare your meals”.

SSA_Q13      (How often is each of the following kinds of support available to you if you need it:)
SSAE_13
             … someone whose advice you really want?

             1      None of the time
             2      A little of the time
             3      Some of the time
             4      Most of the time
             5      All of the time
                    DK, R

SSA_C13      If SSA_Q13 = 2, 3, 4 or 5 then KEY_PHRASES24A = “to advise you”.

SSA_Q14      Again, how often is each of the following kinds of support available to you if you
SSAE_14      need it:)

             … someone to do things with to help you get your mind off things?

             1      None of the time
             2      A little of the time
             3      Some of the time
             4      Most of the time
             5      All of the time
                    DK, R

SSA_C14      If SSA_Q14 = 2, 3, 4 or 5 then KEY_PHRASES23A = “to do things with”.




172                                                                             Statistics Canada
                                                 Canadian Community Health Survey - Cycle 3.1

SSA_Q15       (How often is each of the following kinds of support available to you if you need it:)
SSAE_15
              … someone to help with daily chores if you were sick?

              1      None of the time
              2      A little of the time
              3      Some of the time
              4      Most of the time
              5      All of the time
                     DK, R

SSA_C15       If SSA_Q15 = 2, 3, 4 or 5 then KEY_PHRASES21A = “to help with daily chores”.

SSA_Q16       (How often is each of the following kinds of support available to you if you
SSAE_16       need it:)

              … someone to share your most private worries and fears with?

              1      None of the time
              2      A little of the time
              3      Some of the time
              4      Most of the time
              5      All of the time
                     DK, R

SSA_C16       If SSA_Q16 = 2, 3, 4 or 5 then KEY_PHRASES24A = “to share your worries and fears
              with”.

SSA_Q17       (How often is each of the following kinds of support available to you if you need it:)
SSAE_17
              … someone to turn to for suggestions about how to deal with a personal problem?

              1      None of the time
              2      A little of the time
              3      Some of the time
              4      Most of the time
              5      All of the time
                     DK, R

SSA_C17       If SSA_Q17 = 2, 3, 4 or 5 then KEY_PHRASES24A = “to turn to for suggestions”.




Statistics Canada                                                                               173
Canadian Community Health Survey - Cycle 3.1

SSA_Q18      (How often is each of the following kinds of support available to you if you need it:)
SSAE_18
             … someone to do something enjoyable with?

             1       None of the time
             2       A little of the time
             3       Some of the time
             4       Most of the time
             5       All of the time
                     DK, R

SSA_C18      If SSA_Q18 = 2, 3, 4 or 5 then KEY_PHRASES23A = “to do something enjoyable with”.

SSA_Q19      (How often is each of the following kinds of support available to you if you need it:)
SSAE_19
             … someone who understands your problems?

             1       None of the time
             2       A little of the time
             3       Some of the time
             4       Most of the time
             5       All of the time
                     DK, R

SSA_C19      If SSA_Q19 = 2, 3, 4 or 5 then KEY_PHRASES24A = “to understand your problems”.

SSA_Q20      (How often is each of the following kinds of support available to you if you need it:)
SSAE_20
             … someone to love you and make you feel wanted?

             1       None of the time
             2       A little of the time
             3       Some of the time
             4       Most of the time
             5       All of the time
             DK, R

SSA_C20      If SSA_Q20 = 2, 3, 4 or 5 then KEY_PHRASES22A = “to love you and make you feel
             wanted”.

SSA_END




174                                                                             Statistics Canada
                                                   Canadian Community Health Survey - Cycle 3.1



SOCIAL SUPPORT - UTILIZATION (SSU)
SSU_BEG

SSU_C1        If (do SSU block = 1), go to SSU_C2.
SSUEFOPT      Otherwise, go to SSU_END.

SSU_C2        If proxy interview, go to SSU_END.
              Otherwise, go to SSU_C3.

SSU_C3        If any responses of 2, 3, 4 or 5 in SSA_Q02 to SSA_Q20, go to SSU_R1.
              Otherwise, go to SSU_END.

SSU_R1        You have just mentioned that if you needed support, someone would be available
              for you. The next questions are about the support or help you actually received in
              the past 12 months.
              INTERVIEWER: Press <Enter> to continue.

SSU_C21       If any responses of 2, 3, 4 or 5 in SSA_Q02 or SSA_Q05 or SSA_Q12 or SSA_Q15, then
              SSU_C21 = 1 (Yes) and go to SSU_Q21A.
              Otherwise, SSU_C21=2 (No) and go to SSU_C22.

SSU_Q21A      In the past 12 months, did you receive the following support:
SSUE_21A      someone ^KEY_PHRASES21A?

              1       Yes
              2       No    (Go to SSU_C22)
                      DK, R (Go to SSU_C22)

Note:         (^KEY_PHRASES for all positive answers (2, 3, 4 and 5) of questions SSA_Q02,
              SSA_Q05, SSA_Q12, SSA_Q15) If SSA_Q02 = 2, 3, 4 or 5 show ^PHRASE from
              SSA_C02 always in the 1st place. If 1 PHRASE, show 1st ^PHRASE in lowercase:
              ^PHRASE1. If 2 PHRASES, show 1st two ^PHRASES in lowercase: ^PHRASE1 and
              ^PHRASE2. If 3 or more PHRASES, show in lowercase: ^PHRASE1, ^PHRASE2 and
              ^PHRASE3).

              If SSA_Q02 = 2, 3, 4, 5 use “to help you if you were confined to bed”.
              If SSA_Q05 = 2, 3, 4, 5 use “to take you to the doctor”.
              If SSA_Q12 = 2, 3, 4, 5 use “to prepare your meals”.
              If SSA_Q15= 2, 3, 4, 5 use “to help with daily chores”.




Statistics Canada                                                                            175
Canadian Community Health Survey - Cycle 3.1

SSU_Q21B     When you needed it, how often did you receive this kind of support (in the past
SSUE_21B     12 months)?
             INTERVIEWER: Read categories to respondent.

             1      Almost always
             2      Frequently
             3      Half the time
             4      Rarely
             5      Never
                    DK, R

SSU_C22      If any responses of 2, 3, 4 or 5 in SSA_Q06 or SSA_Q10 or SSA_Q20 then SSU_C22= 1
             (Yes) and go to SSU_Q22A.
             Otherwise, SSU_C22=2 (No) and go to SSU_C23.

SSU_Q22A     (In the past 12 months, did you receive the following support:)
SSUE_22A     someone ^KEY_PHRASES22A?

             1      Yes
             2      No    (Go to SSU_C23)
                    DK, R (Go to SSU_C23)

Note:        (^KEY_PHRASES for all positive answers (2, 3, 4 and 5) of questions SSA_Q06,
             SSA_Q10, SSA_Q20). If 1 PHRASE, show 1st ^PHRASE in lowercase: ^PHRASE1;If 2
             PHRASES, show 1st two ^PHRASES in lowercase: ^PHRASE1 and ^PHRASE2; If 3
             PHRASES, show in lowercase: ^PHRASE1, ^PHRASE2 and ^PHRASE3).

             If SSA_Q06 = 2, 3, 4, 5 use “to show you affection”.
             If SSA_Q10 = 2, 3, 4, 5 use “to hug you”.
             If SSA_Q20 = 2, 3, 4, 5 use “to love you and make you feel wanted”.

SSU_Q22B     When you needed it, how often did you receive this kind of support (in the past
SSUE_22B     12 months)?
             INTERVIEWER: Read categories to respondent.

             1      Almost always
             2      Frequently
             3      Half the time
             4      Rarely
             5      Never
                    DK, R




176                                                                                Statistics Canada
                                                  Canadian Community Health Survey - Cycle 3.1

SSU_C23       If any responses of 2, 3, 4 or 5 in SSA_Q07 or SSA_Q11 or SSA_Q14 or SSA_Q18, then
              SSU_C23 =1 (Yes) and go to SSU_Q23A.
              Otherwise, SSU_C23=2 (No) and go to SSU_C24.

SSU_Q23A      (In the past 12 months, did you receive the following support:)
SSUE_23A      someone ^KEY_PHRASES23A?

              1       Yes
              2       No    (Go to SSU_C24)
                      DK, R (Go to SSU_C24)

Note:         (^KEY_PHRASES for all positive answers (2, 3, 4 and 5) of questions SSA_Q07,
              SSA_Q11, SSA_Q14, SSA_Q18). If 1 PHRASE, show 1st ^PHRASE in lowercase:
              ^PHRASE1. If 2 PHRASES, show 1st two ^PHRASES in lowercase: ^PHRASE1 and
              ^PHRASE2. If 3 or more PHRASES, show in lowercase: ^PHRASE1, ^PHRASE2 and
              ^PHRASE3).

              If SSA_Q07 = 2, 3, 4, 5 use “to have a good time with”.
              If SSA_Q11 = 2, 3, 4, 5 use “to relax with”.
              If SSA_Q14 = 2, 3, 4, 5 use “to do things with”.
              If SSA_Q18 = 2, 3, 4, 5 use “to do something enjoyable with”.

SSU_Q23B      When you needed it, how often did you receive this kind of support (in the past
SSUE_23B      12 months)?
              INTERVIEWER: Read categories to respondent.

              1       Almost always
              2       Frequently
              3       Half the time
              4       Rarely
              5       Never
              DK, R




Statistics Canada                                                                               177
Canadian Community Health Survey - Cycle 3.1

SSU_C24      If any responses of 2, 3, 4 or 5 in SSA_Q03 or SSA_Q04 or SSA_Q08 or SSA_Q09,
             SSA_Q13, SSA_Q16, SSA_Q17 or SSA_Q19, then SSU_C24 =1 (Yes) and go to
             SSU_Q24A.
             Otherwise, SSU_C24=2 (No) and go to SSU_END.

SSU_Q24A     (In the past 12 months, did you receive the following support:)
SSUE_24A     someone ^KEY_PHRASES24A?

             1       Yes
             2       No    (Go to SSU_END)
                     DK, R (Go to SSU_END)

Note:        (^KEY_PHRASES for all positive answers (2, 3, 4 and 5) of questions SSA_Q03,
             SSA_Q04, SSA_Q08, SSA_Q09, SSA_Q13, SSA_Q16, SSA_Q17or SSA_Q19;). If
             SSA_Q04 and SSA_Q13 = 2, 3, 4 or 5 use only ^KEY_PHRASE SSA_C04, If 1
             PHRASE, show 1st ^PHRASE in lowercase: ^PHRASE1. If 2 PHRASES, show 1st two
             ^PHRASES in lowercase: ^PHRASE1 and ^PHRASE2. If 3 or more PHRASES, show in
             lowercase: ^PHRASE1, ^PHRASE2 and ^PHRASE3).

             If SSA_Q03 = 2, 3, 4, 5 use “to listen to you”.
             If SSA_Q04 = 2, 3, 4, 5 use “to give you advise”.
             If SSA_Q08 = 2, 3, 4, 5 use “to give you information”.
             If SSA_Q09 = 2, 3, 4, 5 use “to confide in”.
             If SSA_Q13 = 2, 3, 4, 5 use “to advise you”.
             If SSA_Q16 = 2, 3, 4, 5 use “to share your worries and fears with”.
             If SSA_Q17 = 2, 3, 4, 5 use “to turn to for suggestions”.
             If SSA_Q19 = 2, 3, 4, 5 use “to understand your problems”.

SSU_Q24B     When you needed it, how often did you receive this kind of support (in the
SSUE_24B     past 12 months)?
             INTERVIEWER: Read categories to respondent.

             1       Almost always
             2       Frequently
             3       Half the time
             4       Rarely
             5       Never
                     DK, R

SSU_END




178                                                                                Statistics Canada
                                                   Canadian Community Health Survey - Cycle 3.1



CONTACTS WITH MENTAL HEALTH PROFESSIONALS (CMH)
CMH_BEG

CMH_C01A      If (CMH block = 1), go to CMH_C01B.
CMHEFOPT      Otherwise, go to CMH_END.

CMH_C01B      If proxy interview, go to CMH_END.
              Otherwise, go to CMH_R01K.

CMH_R1K       Now some questions about mental and emotional well-being.
              INTERVIEWER: Press <Enter> to continue.

CMH_Q01K      In the past 12 months, that is, from [date one year ago] to yesterday, have you
CMHE_01K      seen, or talked on the telephone, to a health professional about your emotional or
              mental health?

              1      Yes
              2      No              (Go to CMH_END)
                     DK, R           (Go to CMH_END)

CMH_Q01L      How many times (in the past 12 months)?
CHME_01L
              l_l_l_l        Times
              (MIN: 1) (MAX: 366; warning after 25)
              DK, R

CMH_Q01M      Whom did you see or talk to?
              INTERVIEWER: Read categories to respondent. Mark all that apply.

CMHE_1MA      1      Family doctor or general practitioner
CMHE_1MB      2      Psychiatrist
CMHE_1MC      3      Psychologist
CMHE_1MD      4      Nurse
CMHE_1ME      5      Social worker or counselor
CMHE_1MF      6      Other - Specify

CMH_C01MS     If CMH_Q01M = 6, go to CMH_Q01MS.
              Otherwise, go to CMH_END.

CMH_Q01MS INTERVIEWER: Specify.

              ______________________
              (80 spaces)
              DK, R




Statistics Canada                                                                            179
Canadian Community Health Survey - Cycle 3.1

CMH_E01M[1] Inconsistent answers have been entered. The respondent has saw or talked with a family
            doctor or general practitioner in the past 12 months but previously reported that he/she
            did not. Please confirm.

               Trigger soft edit if CMH_Q01M = 1 and HCU_Q02A = 0.

CMH_E01M[2] Inconsistent answers have been entered. The respondent has saw or talked with a
            psychiatrist in the past 12 months but previously reported that he/she did not. Please
            confirm.

               Trigger soft edit if CMH_Q01M = 2 and HCU_Q02C = 0.

CMH_E01M[3] Inconsistent answers have been entered. The respondent has saw or talked with a
            psychologist in the past 12 months but previously reported that he/she did not. Please
            confirm.

               Trigger soft edit if CMH_Q01M = 3 and HCU_Q02I = 0.

CMH_E01M[4] Inconsistent answers have been entered. The respondent has saw or talked with a nurse
            in the past 12 months but previously reported that he/she did not. Please confirm.

               Trigger soft edit if CMH_Q01M = 4 and HCU_Q02D = 0.

CMH_E01M[5] Inconsistent answers have been entered. The respondent has saw or talked with a social
            worker or counsellor in the past 12 months but previously reported that he/she did not.
            Please confirm.

               Trigger soft edit if CMH_Q01M = 5 and HCU_Q02H = 0.

CMH_END




180                                                                                 Statistics Canada
                                                     Canadian Community Health Survey - Cycle 3.1



DISTRESS (DIS)
DIS_BEG

DIS_C1        If (do DIS block = 1), go to DIS_C2.
DISEFOPT      Otherwise, go to DIS_END.

DIS_C2        If proxy interview, go to DIS_END.
              Otherwise, go to DIS_R01.

DIS_R01       The following questions deal with feelings you may have had during the past
              month.
              INTERVIEWER: Press <Enter> to continue.

DIS_Q01A      During the past month, that is, from [date one month ago] to yesterday, about
DISE_10A      how often did you feel:

              ... tired out for no good reason?
              INTERVIEWER: Read categories to respondent.

              1       All of the time
              2       Most of the time
              3       Some of the time
              4       A little of the time
              5       None of the time
                      DK, R                    (Go to DIS_END)

DIS_Q01B      During the past month, that is, from [date one month ago] to yesterday, about how
DISE_10B      often did you feel:

              … nervous?

              1       All of the time
              2       Most of the time
              3       Some of the time
              4       A little of the time
              5       None of the time         (Go to DIS_Q01D)
                      DK, R                    (Go to DIS_Q01D)

DIS_Q01C      (During the past month, that is, from [date one month ago] to yesterday, about how
DISE_10C      often did you feel:)

              ... so nervous that nothing could calm you down?

              1       All of the time
              2       Most of the time
              3       Some of the time
              4       A little of the time
              5       None of the time
                      DK, R

Note:         In processing, if a respondent answered DIS_Q01B = 5 (none of the time), the variable
              DIS_Q01C will be given the value of 5 (none of the time).




Statistics Canada                                                                                181
Canadian Community Health Survey - Cycle 3.1

DIS_Q01D     (During the past month, that is, from [date one month ago] to yesterday, about how
DISE_10D     often did you feel:)

             ... hopeless?

             1       All of the time
             2       Most of the time
             3       Some of the time
             4       A little of the time
             5       None of the time
                     DK, R

DIS_Q01E     During the past month, that is, from [date one month ago] to yesterday, about how
DISE_10E     often did you feel:

             ... restless or fidgety?

             1       All of the time
             2       Most of the time
             3       Some of the time
             4       A little of the time
             5       None of the time       (Go to DIS_Q01G)
                     DK, R                  (Go to DIS_Q01G)

DIS_Q01F     (During the past month, that is, from [date one month ago] to yesterday, about how
DISE_10F     often did you feel:)

             … so restless you could not sit still?

             1       All of the time
             2       Most of the time
             3       Some of the time
             4       A little of the time
             5       None of the time
                     DK, R

Note:        In processing, if a respondent answered DIS_Q01E = 5 (none of the time), the variable
             DIS_Q01F will be given the value of 5 (none of the time).

DIS_Q01G     (During the past month, that is, from [date one month ago] to yesterday, about how
DISE_10G     often did you feel:)

             …sad or depressed?

             1       All of the time
             2       Most of the time
             3       Some of the time
             4       A little of the time
             5       None of the time       (Go to DIS_Q01I)
                     DK, R                  (Go to DIS_Q01I)




182                                                                               Statistics Canada
                                                  Canadian Community Health Survey - Cycle 3.1

DIS_Q01H      (During the past month, that is, from [date one month ago] to yesterday, about how
DISE_10H      often did you feel:)

              …so depressed that nothing could cheer you up?

              1      All of the time
              2      Most of the time
              3      Some of the time
              4      A little of the time
              5      None of the time
                     DK, R

Note:         In processing, if a respondent answered DIS_Q01G = 5 (none of the time), the variable
              DIS_Q01H will be given the value of 5 (none of the time).

DIS_Q01I      (During the past month, that is, from [date one month ago] to yesterday, about how
DISE_10I      often did you feel:)

              …that everything was an effort?

              1      All of the time
              2      Most of the time
              3      Some of the time
              4      A little of the time
              5      None of the time
                     DK, R

DIS_Q01J      (During the past month, that is, from [date one month ago] to yesterday, about how
DISE_10J      often did you feel:)

              …worthless?

              1      All of the time
              2      Most of the time
              3      Some of the time
              4      A little of the time
              5      None of the time
                     DK, R

Note:         If DIS_Q01B to DIS_Q01J are DK or R, go to DIS_END.

DIS_Q01K      We just talked about feelings that occurred to different degrees during the
DISE_10K      past month.
              Taking them altogether, did these feelings occur more often in the past month than
              is usual for you, less often than usual or about the same as usual?

              1      More often
              2      Less often                              (Go to DIS_Q01M)
              3      About the same                          (Go to DIS_Q01N)
              4      Never have had any                      (Go to DIS_END)
                     DK, R                                   (Go to DIS_END)




Statistics Canada                                                                                183
Canadian Community Health Survey - Cycle 3.1

DIS_Q01L     Is that a lot more, somewhat more or only a little more often than usual?
DISE_10L
             1       A lot
             2       Somewhat
             3       A little
                     DK, R

             Go to DIS_Q01N

DIS_Q01M     Is that a lot less, somewhat less or only a little less often than usual?
DISE_10M
             1       A lot
             2       Somewhat
             3       A little
                     DK, R

DIS_Q01N     During the past month, how much did these feelings usually interfere with your
DISE_10N     life or activities?
             INTERVIEWER: Read categories to respondent.

             1       A lot
             2       Some
             3       A little
             4       Not at all
                     DK, R

DIS_END




184                                                                               Statistics Canada
                                                   Canadian Community Health Survey - Cycle 3.1



DEPRESSION (DPS)
DEP_BEG

DEP_C01       If (do DEP block = 1), go to DEP_C02.
DPSEFOPT      Otherwise, go to DEP_END.

DEP_C02       If proxy interview, go to DEP_END.
              Otherwise, go to DEP_Q02.

DEP_Q02       During the past 12 months, was there ever a time when you felt sad, blue, or
DPSE_02       depressed for 2 weeks or more in a row?

              1      Yes
              2      No              (Go to DEP_Q16)
                     DK, R           (Go to DEP_END)

DEP_Q03       For the next few questions, please think of the 2-week period during the past
DPSE_03       12 months when these feelings were the worst. During that time, how long did
              these feelings usually last?
              INTERVIEWER: Read categories to respondent.

              1      All day long
              2      Most of the day
              3      About half of the day            (Go to DEP_Q16)
              4      Less than half of a day          (Go to DEP_Q16)
                     DK, R                            (Go to DEP_END)

DEP_Q04       How often did you feel this way during those 2 weeks?
DPSE_04       INTERVIEWER: Read categories to respondent.

              1      Every day
              2      Almost every day
              3      Less often                (Go to DEP_Q16)
                     DK, R                     (Go to DEP_END)

DEP_Q05       During those 2 weeks did you lose interest in most things?
DPSE_05
              1      Yes             (KEY PHRASE = Losing interest)
              2      No
                     DK, R           (Go to DEP_END)

DEP_Q06       Did you feel tired out or low on energy all of the time?
DPSE_06
              1      Yes             (KEY PHRASE = Feeling tired)
              2      No
                     DK, R           (Go to DEP_END)




Statistics Canada                                                                             185
Canadian Community Health Survey - Cycle 3.1

DEP_Q07      Did you gain weight, lose weight or stay about the same?
DPSE_07
             1       Gained weight                   (KEY PHRASE = Gaining weight)
             2       Lost weight                     (KEY PHRASE = Losing weight)
             3       Stayed about the same           (Go to DEP_Q09)
             4       Was on a diet                   (Go to DEP_Q09)
                     DK, R                           (Go to DEP_END)

DEP_Q08A     About how much did you [gain/lose]?
DPSE_08A     INTERVIEWER: Enter amount only.

             |_|_|   Weight
             (MIN: 1) (MAX: 99; warning after 20 pounds / 9 kilograms)
             DK, R          (Go to DEP_Q09)

Note:        If DEP_Q07 = 1, use “gain”.
             Otherwise, use “lose”

DEP_Q08B     INTERVIEWER: Was that in pounds or in kilograms?
DPSE_08B
             1       Pounds
             2       Kilograms
                     (DK, R are not allowed)

DEP_Q09      Did you have more trouble falling asleep than you usually do?
DPSE_09
             1       Yes             (KEY PHRASE = Trouble falling asleep)
             2       No              (Go to DEP_Q11)
                     DK, R           (Go to DEP_END)

DEP_Q10      How often did that happen?
DPSE_10      INTERVIEWER: Read categories to respondent.

             1       Every night
             2       Nearly every night
             3       Less often
                     DK, R          (Go to DEP_END)

DEP_Q11      Did you have a lot more trouble concentrating than usual?
DPSE_11
             1       Yes             (KEY PHRASE = Trouble concentrating)
             2       No
                     DK, R           (Go to DEP_END)

DEP_Q12      At these times, people sometimes feel down on themselves, no good or worthless.
DPSE_12      Did you feel this way?

             1       Yes             (KEY PHRASE = Feeling down on yourself)
             2       No
                     DK, R           (Go to DEP_END)




186                                                                            Statistics Canada
                                                  Canadian Community Health Survey - Cycle 3.1

DEP_Q13       Did you think a lot about death - either your own, someone else’s or death in
DPSE_13       general?

              1      Yes             (KEY PHRASE =Thoughts about death)
              2      No
                     DK, R           (Go to DEP_END)

DEP_C14       If “Yes” in DEP_Q5, DEP_Q6, DEP_Q9, DEP_Q11, DEP_Q12 or DEP_Q13, or DEP_Q7
              is “gain” or “lose”, go to DEP_Q14C.
              Otherwise, go to DEP_END.

DEP_Q14C      Reviewing what you just told me, you had 2 weeks in a row during the past 12
              months when you were sad, blue or depressed and also had some other things like
              (KEY PHRASES).
              INTERVIEWER: Press <Enter> to continue.

DEP_Q14       About how many weeks altogether did you feel this way during the past 12
DPSE_14       months?

              |_|_|    Weeks
              (MIN: 2 MAX: 53)
              (If > 51 weeks, go to DEP_END)
              DK, R            (Go to DEP_END)

DEP_Q15       Think about the last time you felt this way for 2 weeks or more in a row. In what
DPSE_15       month was that?

              1      January                         7       July
              2      February                        8       August
              3      March                           9       September
              4      April                           10      October
              5      May                             11      November
              6      June                            12      December
                     DK, R

              Go to DEP_END

DEP_Q16       During the past 12 months, was there ever a time lasting 2 weeks or more when
DPSE_16       you lost interest in most things like hobbies, work or activities that usually give
              you pleasure?

              1      Yes
              2      No    (Go to DEP_END)
                     DK, R (Go to DEP_END)




Statistics Canada                                                                                   187
Canadian Community Health Survey - Cycle 3.1

DEP_Q17      For the next few questions, please think of the 2-week period during the past
DPSE_17      12 months when you had the most complete loss of interest in things. During that
             2-week period, how long did the loss of interest usually last?
             INTERVIEWER: Read categories to respondent.

             1       All day long
             2       Most of the day
             3       About half of the day           (Go to DEP_END)
             4       Less than half of a day         (Go to DEP_END)
                     DK, R                           (Go to DEP_END)

DEP_Q18      How often did you feel this way during those 2 weeks?
DPSE_18      INTERVIEWER: Read categories to respondent.

             1       Every day
             2       Almost every day
             3       Less often                (Go to DEP_END)
                     DK, R                     (Go to DEP_END)

DEP_Q19      During those 2 weeks did you feel tired out or low on energy all the time?
DPSE_19
             1       Yes               (KEY PHRASE = Feeling tired)
             2       No
                     DK, R             (Go to DEP_END)

DEP_Q20      Did you gain weight, lose weight, or stay about the same?
DPSE_20
             1       Gained weight                   (KEY PHRASE = Gaining weight)
             2       Lost weight                     (KEY PHRASE = Losing weight)
             3       Stayed about the same           (Go to DEP_Q22)
             4       Was on a diet                   (Go to DEP_Q22)
                     DK, R                           (Go to DEP_END)

DEP_Q21A     About how much did you [gain/lose]?
DPSE_21A     INTERVIEWER: Enter amount only.

             |_|_|   Weight
             (MIN: 1) (MAX: 99; warning after 20 pounds / 9 kilograms)
             DK, R          (Go to DEP_Q22)

Note:        If DEP_Q20 = 1, use “gain”.
             Otherwise, use “lose”.

DEP_Q21B     INTERVIEWER: Was that in pounds or in kilograms?
DPSE_21B
             1       Pounds
             2       Kilograms
             (DK, R are not allowed)




188                                                                            Statistics Canada
                                                Canadian Community Health Survey - Cycle 3.1

DEP_Q22       Did you have more trouble falling asleep than you usually do?
DPSE_22
              1      Yes             (KEY PHRASE = Trouble falling asleep)
              2      No              (Go to DEP_Q24)
                     DK, R           (Go to DEP_END)

DEP_Q23       How often did that happen?
DPSE_23       INTERVIEWER: Read categories to respondent.

              1      Every night
              2      Nearly every night
              3      Less often
                     DK, R          (Go to DEP_END)

DEP_Q24       Did you have a lot more trouble concentrating than usual?
DPSE_24
              1      Yes             (KEY PHRASE = Trouble concentrating)
              2      No
                     DK, R           (Go to DEP_END)

DEP_Q25       At these times, people sometimes feel down on themselves, no good, or worthless.
DPSE_25       Did you feel this way?

              1      Yes             (KEY PHRASE = Feeling down on yourself)
              2      No
                     DK, R           (Go to DEP_END)

DEP_Q26       Did you think a lot about death - either your own, someone else’s, or death in
DPSE_26       general?

              1      Yes             (KEY PHRASE =Thoughts about death)
              2      No
                     DK, R           (Go to DEP_END)

DEP_C27       If any “Yes” in DEP_Q19, DEP_Q22, DEP_Q24, DEP_Q25 or DEP_Q26, or DEP_Q20 is
              “gain” or “lose”, go to DEP_Q27C.
              Otherwise, go to DEP_END.

DEP_Q27C      Reviewing what you just told me, you had 2 weeks in a row during the past 12
              months when you lost interest in most things and also had some other things like
              (KEY PHRASES).
              INTERVIEWER: Press <Enter> to continue.

DEP_Q27       About how many weeks did you feel this way during the past 12 months?
DPSE_27
              |_|_|    Weeks
              (MIN: 2 MAX: 53)
              (If > 51 weeks, go to DEP_END)
              DK, R (Go to DEP_END)




Statistics Canada                                                                              189
Canadian Community Health Survey - Cycle 3.1

DEP_Q28      Think about the last time you had 2 weeks in a row when you felt this way. In what
DPSE_28      month was that?

             1      January                       7       July
             2      February                      8       August
             3      March                         9       September
             4      April                         10      October
             5      May                           11      November
             6      June                          12      December
                    DK, R

DEP_END




190                                                                           Statistics Canada
                                                      Canadian Community Health Survey - Cycle 3.1



SUICIDAL THOUGHTS AND ATTEMPTS (SUI)
SUI_BEG

SUI_C1A       If (do SUI block = 1), go to SUI_C1B.
SUIEFOPT      Otherwise, go to SUI_END.

SUI_C1B       If proxy interview or if age < 15, go to SUI_END.
              Otherwise, go to SUI_QINT.

SUI_QINT      The following questions relate to the sensitive issue of suicide.
              INTERVIEWER: Press <Enter> to continue.

SUI_Q1        Have you ever seriously considered committing suicide or taking your own life?
SUIE_1
              1       Yes
              2       No    (Go to SUI_END)
                      DK, R (Go to SUI_END)

SUI_Q2        Has this happened in the past 12 months?
SUIE_2
              1       Yes
              2       No    (Go to SUI_END)
                      DK, R (Go to SUI_END)

SUI_Q3        Have you ever attempted to commit suicide or tried taking your own life?
SUIE_3
              1       Yes
              2       No    (Go to SUI_END)
                      DK, R (Go to SUI_END)

SUI_Q4        Did this happen in the past 12 months?
SUIE_4
              1       Yes
              2       No    (Go to SUI_END)
                      DK, R (Go to SUI_END)

SUI_Q5        Did you see, or talk on the telephone, to a health professional following your
SUIE_5        attempt to commit suicide?

              1       Yes
              2       No    (Go to SUI_END)
                      DK, R (Go to SUI_END)




Statistics Canada                                                                              191
Canadian Community Health Survey - Cycle 3.1

SUI_Q6       Whom did you see or talk to?
             INTERVIEWER: Read categories to respondent. Mark all that apply.

SUIE_6A      1      Family doctor or general practitioner
SUIE_6B      2      Psychiatrist
SUIE_6C      3      Psychologist
SUIE_6D      4      Nurse
SUIE_6E      5      Social worker or counsellor
SUIE_6G      6      Religious or spiritual advisor such as a priest, chaplain or rabbi
SUIE_6H      7      Teacher or guidance counsellor
SUIE_6F      8      Other
                    DK, R

SUI_END




192                                                                             Statistics Canada
                                                           Canadian Community Health Survey - Cycle 3.1



INJURIES (INJ) (REP)
INJ_BEG

INJ_C1              If (do INJ block = 1), go to REP_R1.
                    Otherwise, go to INJ_END.

Repetitive strain

REP_R1              This next section deals with repetitive strain injuries. By this we mean injuries
                    caused by overuse or by repeating the same movement frequently. (For example,
                    carpal tunnel syndrome, tennis elbow or tendonitis.)
                    INTERVIEWER: Press <Enter> to continue.

REP_Q1              In the past 12 months, that is, from [date one year ago] to yesterday, did
REPE_1              ^YOU2 have any injuries due to repetitive strain which were serious enough
                    to limit ^YOUR1 normal activities?

                    1       Yes
                    2       No              (Go to INJ_R1)
                            DK, R           (Go to INJ_R1)

REP_Q3              Thinking about the most serious repetitive strain, what part of the body was
REPE_3              affected?

                    1       Head
                    2       Neck
                    3       Shoulder, upper arm
                    4       Elbow, lower arm
                    5       Wrist
                    6       Hand
                    7       Hip
                    8       Thigh
                    9       Knee, lower leg
                    10      Ankle, foot
                    11      Upper back or upper spine (excluding neck)
                    12      Lower back or lower spine
                    13      Chest (excluding back and spine)
                    14      Abdomen or pelvis (excluding back and spine)
                            DK, R




Statistics Canada                                                                                  193
Canadian Community Health Survey - Cycle 3.1

REP_Q4          What type of activity ^WERE ^YOU1 doing when ^YOU1 got this
                repetitive strain?
                INTERVIEWER: Mark all that apply.

REPE_4A         1       Sports or physical exercise (include school activities)
REPE_4B         2       Leisure or hobby (include volunteering)
REPE_4C         3       Working at a job or business (exclude travel to or from work)
REPE_4G         4       Travel to or from work
REPE_4D         5       Household chores, other unpaid work or education
REPE_4E         6       Sleeping, eating, personal care
REPE_4F         7       Other - Specify
                        DK, R

REP_C4S         If REP_Q4 = 7, go to INJ_Q4S.
                Otherwise, go to REP_R1.

REP_Q4S         INTERVIEWER: Specify.

                _________________________
                (80 spaces)
                DK, R

Number of injuries and details of most serious injury

INJ_R1          Now some questions about [other] injuries which occurred in the past 12 months,
                and were serious enough to limit ^YOUR2 normal activities. For example, a
                broken bone, a bad cut or burn, a sprain, or a poisoning.
                INTERVIEWER: Press <Enter> to continue.

Note:           If REP_Q1 = 1, use “other injuries”. Otherwise, use “injuries”.

INJ_Q01         [Not counting repetitive strain injuries, in the past 12 months,/In the past 12
INJE_01         months,] that is, from [date one year ago] to yesterday, ^WERE ^YOU2
                injured?

                1       Yes
                2       No               (Go to INJ_Q16)
                        DK, R            (Go to INJ_END)

Note:           If REP_Q1 = 1, use “Not counting repetitive strain injuries, in the past 12 months,”.
                Otherwise, use “In the past 12 months,”.

INJ_Q02         How many times ^WERE ^YOU1 injured?
INJE_02
                |_|_|   Times
                (MIN: 1) (MAX: 30; warning after 6)
                DK, R          (Go to INJ_END)




194                                                                                     Statistics Canada
                                                  Canadian Community Health Survey - Cycle 3.1

INJ_Q03       [Thinking about the most serious injury, in which month/In which month]
INJE_03       did it happen?

              1       January                                 7       July
              2       February                                8       August
              3       March                                   9       September
              4       April                                   10      October
              5       May                                     11      November
              6       June                                    12      December

                      DK, R (Go to INJ_Q05)

Note:         If INJ_Q02 = 1 use “In which month”.
              Otherwise, use “Thinking about the most serious injury, in which month”.

INJ_C04       If INJ_Q03 = [current month], go to INJ_Q04.
              Otherwise, go to INJ_Q05.

INJ_Q04       Was that this year or last year?
INJE_04
              1       This year
              2       Last year
                      DK, R

INJ_Q05       What type of injury did ^YOU1 have? For example, a broken bone or burn.
INJE_05
              1       Multiple injuries
              2       Broken or fractured bones
              3       Burn, scald, chemical burn
              4       Dislocation
              5       Sprain or strain
              6       Cut, puncture, animal or human bite (open wound)
              7       Scrape, bruise, blister
              8       Concussion or other brain injury              (Go to INJ_Q08)
              9       Poisoning                                     (Go to INJ_Q08)
              10      Injury to internal organs                     (Go to INJ_Q07)
              11      Other - Specify
                      DK, R

INJ_C05S      If INJ_Q05 = 11, go to INJ_Q05S.
              Otherwise, go to INJ_Q06.

INJ_Q05S      INTERVIEWER: Specify.

              _________________________
              (80 spaces)
              DK, R




Statistics Canada                                                                         195
Canadian Community Health Survey - Cycle 3.1

INJ_Q06      What part of the body was injured?
INJE_06
             1      Multiple sites
             2      Eyes
             3      Head (excluding eyes)
             4      Neck
             5      Shoulder, upper arm
             6      Elbow, lower arm
             7      Wrist
             8      Hand
             9      Hip
             10     Thigh
             11     Knee, lower leg
             12     Ankle, foot
             13     Upper back or upper spine (excluding neck)
             14     Lower back or lower spine
             15     Chest (excluding back and spine)
             16     Abdomen or pelvis (excluding back and spine)
                    DK, R

             Go to INJ_Q08

INJ_Q07      What part of the body was injured?
INJE_07
             1      Chest (within rib cage)
             2      Abdomen or pelvis (below ribs)
             3      Other - Specify
                    DK, R

INJ_C07S     If INJ_Q07 = 3, go to INJ_Q07S.
             Otherwise, go to INJ_Q08.

INJ_Q07S     INTERVIEWER: Specify.

             _________________________
             (80 spaces)
             DK, R




196                                                                Statistics Canada
                                                   Canadian Community Health Survey - Cycle 3.1

INJ_Q08       Where did the injury happen?
INJE_08       INTERVIEWER: If respondent says ‘At work’, probe for type of workplace.

              1      In a home or its surrounding area
              2      Residential institution
              3      School, college, university (exclude sports areas)
              4      Sports or athletics area of school, college, university
              5      Other sports or athletics area (exclude school sports areas)
              6      Other institution (e.g., church, hospital, theatre, civic building)
              7      Street, highway, sidewalk
              8      Commercial area (e.g., store, restaurant, office building, transport
                     terminal)
              9      Industrial or construction area
              10     Farm (exclude farmhouse and its surrounding area)
              11     Countryside, forest, lake, ocean, mountains, prairie, etc.
              12     Other - Specify
                     DK, R

INJ_C08S      If INJ_Q08 = 12, go to INJ_Q08S.
              Otherwise, go to INJ_Q09.

INJ_Q08S      INTERVIEWER: Specify.

              _________________________
              (80 spaces)
              DK, R

INJ_Q09       What type of activity ^WERE ^YOU1 doing when ^YOU1 ^WERE injured?
INJE_09
              1      Sports or physical exercise (include school activities)
              2      Leisure or hobby (include volunteering)
              3      Working at a job or business (exclude travel to or from work)
              4      Travel to or from work
              5      Household chores, other unpaid work or education
              6      Sleeping, eating, personal care
              7      Other - Specify
                     DK, R

INJ_C09S      If INJ_Q09 = 7, go to INJ_Q09S.
              Otherwise, go to INJ_Q10.

INJ_Q09S      INTERVIEWER: Specify.

              _________________________
              (80 spaces)
              DK, R




Statistics Canada                                                                           197
Canadian Community Health Survey - Cycle 3.1

INJ_Q10      Was the injury the result of a fall?
INJE_10      INTERVIEWER: Select “No” for transportation accidents.

             1      Yes
             2      No              (Go to INJ_Q12)
                    DK, R           (Go to INJ_Q12)

INJ_Q11      How did ^YOU1 fall?
INJE_11
             1      While skating, skiing, snowboarding, in-line skating or skateboarding
             2      Going up or down stairs / steps (icy or not)
             3      Slip, trip or stumble on ice or snow
             4      Slip, trip or stumble on any other surface
             5      From furniture (e.g., bed, chair)
             6      From elevated position (e.g., ladder, tree)
             7      Other - Specify
                    DK, R

INJ_C11S     If INJ_Q11 = 7, go to INJ_Q11S.
             Otherwise, go to INJ_Q13.

INJ_Q11S     INTERVIEWER: Specify.

             _________________________
             (80 spaces)
             DK, R

             Go to INJ_Q13

INJ_Q12      What caused the injury?
INJE_12
             1      Transportation accident
             2      Accidentally bumped, pushed, bitten, etc. by person or animal
             3      Accidentally struck or crushed by object(s)
             4      Accidental contact with sharp object, tool or machine
             5      Smoke, fire, flames
             6      Accidental contact with hot object, liquid or gas
             7      Extreme weather or natural disaster
             8      Overexertion or strenuous movement
             9      Physical assault
             10     Other - Specify
                    DK, R

INJ_C12S     If INJ_Q12 = 10, go to INJ_Q12S.
             Otherwise, go to INJ_Q13.

INJ_Q12S     INTERVIEWER: Specify.

             _________________________
             (80 spaces)
             DK, R




198                                                                                 Statistics Canada
                                                   Canadian Community Health Survey - Cycle 3.1

INJ_Q13       Did ^YOU2 receive any medical attention for the injury from a health
INJE_13       professional in the 48 hours following the injury?

              1      Yes
              2      No              (Go to INJ_Q16)
                     DK, R           (Go to INJ_Q16)

INJ_Q14       Where did ^YOU1 receive treatment?
              INTERVIEWER: Mark all that apply.

INJE_14A      1      Doctor’s office
INJE_14B      2      Hospital emergency room
INJE_14C      3      Hospital outpatient clinic (e.g. day surgery, cancer)
INJE_14D      4      Walk-in clinic
INJE_14E      5      Appointment clinic
INJE_14F      6      Community health centre / CLSC
INJE_14G      7      At work
INJE_14H      8      At school
INJE_14I      9      At home
INJE_14J      10     Telephone consultation only
INJE_14K      11     Other - Specify
                     DK, R

INJ_C14S      If INJ_Q14 = 11, go to INJ_Q14S.
              Otherwise, go to INJ_Q15.

INJ_Q14S      INTERVIEWER: Specify.

              _________________________
              (80 spaces)
              DK, R

INJ_Q15       ^WERE ^YOU1 admitted to a hospital overnight?
INJE_15
              1      Yes
              2      No
                     DK, R

INJ_E15       Inconsistent answers have been entered. Please confirm.

              Trigger soft edit if (INJ_Q15 = 1 and HCU_Q01BA = 2).




Statistics Canada                                                                          199
Canadian Community Health Survey - Cycle 3.1

INJ_Q16      Did ^YOU2 have any other injuries in the past 12 months that were treated
INJE_16      by a health professional, but did not limit ^YOUR1 normal activities?

             1      Yes
             2      No              (Go to INJ_END)
                    DK, R           (Go to INJ_END)

INJ_Q17      How many injuries?
INJE_17
             |_|_|   Injuries
             (MIN: 1) (MAX: 30; warning after 6)
             DK, R

INJ_END




200                                                                          Statistics Canada
                                                  Canadian Community Health Survey - Cycle 3.1



HEALTH UTILITY INDEX (HUI)
HIU_BEG

Note:         This module was collected as optional content and as part of a subsample.

HUI_C1        If (do HUI block = 1), go to HUI_QINT1.
HUIEFOPT      Otherwise, go to HUI_END.

HUI_QINT1     The next set of questions asks about ^YOUR2 day-to-day health. The questions are
              not about illnesses like colds that affect people for short periods of time. They are
              concerned with a person’s usual abilities.

              You may feel that some of these questions do not apply to ^YOU2, but it is
              important that we ask the same questions of everyone.
              INTERVIEWER: Press <Enter> to continue.

Vision

HUI_Q01       ^ARE_C ^YOU1 usually able to see well enough to read ordinary newsprint
HUIE_01       without glasses or contact lenses?

              1       Yes             (Go to HUI_Q04)
              2       No
                      DK, R           (Go to HUI_END)

HUI_Q02       ^ARE_C ^YOU1 usually able to see well enough to read ordinary newsprint
HUIE_02       with glasses or contact lenses?

              1       Yes             (Go to HUI_Q04)
              2       No
                      DK, R

HUI_Q03       ^ARE_C ^YOU1 able to see at all?
HUIE_03
              1       Yes
              2       No              (Go to HUI_Q06)
                      DK, R           (Go to HUI_Q06)

HUI_Q04       ^ARE_C ^YOU1 able to see well enough to recognize a friend on the other
HUIE_04       side of the street without glasses or contact lenses?

              1       Yes             (Go to HUI_Q06)
              2       No
                      DK, R           (Go to HUI_Q06)

HUI_Q05       ^ARE_C ^YOU1 usually able to see well enough to recognize a friend on the
HUIE_05       other side of the street with glasses or contact lenses?

              1       Yes
              2       No
                      DK, R




Statistics Canada                                                                              201
Canadian Community Health Survey - Cycle 3.1

Hearing

HUI_Q06      ^ARE_C ^YOU2 usually able to hear what is said in a group conversation with
HUIE_06      at least 3 other people without a hearing aid?

             1      Yes           (Go to HUI_Q10)
             2      No
                    DK, R         (Go to HUI_Q10)

HUI_Q07      ^ARE_C ^YOU1 usually able to hear what is said in a group conversation with
HUIE_07      at least 3 other people with a hearing aid?

             1      Yes           (Go to HUI_Q08)
             2      No
                    DK, R

HUI_Q07A     ^ARE_C ^YOU1 able to hear at all?
HUIE_07A
             1      Yes
             2      No            (Go to HUI_Q10)
                    DK, R         (Go to HUI_Q10)

HUI_Q08      ^ARE_C ^YOU1 usually able to hear what is said in a conversation with one
HUIE_08      other person in a quiet room without a hearing aid ?

             1      Yes           (Go to HUI_Q10)
             2      No
                    DK
                    R             (Go to HUI_Q10)

HUI_Q09      ^ARE_C ^YOU1 usually able to hear what is said in a conversation with one
HUIE_09      other person in a quiet room with a hearing aid?

             1      Yes
             2      No
                    DK, R

Speech

HUI_Q10      ^ARE_C ^YOU2 usually able to be understood completely when speaking
HUIE_10      with strangers in ^YOUR1 own language?

             1      Yes           (Go to HUI_Q14)
             2      No
                    DK
                    R             (Go to HUI_Q14)




202                                                                         Statistics Canada
                                                  Canadian Community Health Survey - Cycle 3.1

HUI_Q11          ^ARE_C ^YOU1 able to be understood partially when speaking with
HUIE_11          strangers?

                 1      Yes
                 2      No
                        DK, R

HUI_Q12          ^ARE_C ^YOU1 able to be understood completely when speaking with those
HUIE_12          who know ^HIMHER well?

                 1      Yes            (Go to HUI_Q14)
                 2      No
                        DK
                        R              (Go to HUI_Q14)

HUI_Q13          ^ARE_C ^YOU1 able to be understood partially when speaking with those
HUIE_13          who know ^HIMHER well?

                 1      Yes
                 2      No
                        DK, R

Getting Around

HUI_Q14          ^ARE_C ^YOU2 usually able to walk around the neighbourhood without
HUIE_14          difficulty and without mechanical support such as braces, a cane or crutches?

                 1      Yes            (Go to HUI_Q21)
                 2      No
                        DK, R          (Go to HUI_Q21)

HUI_Q15          ^ARE_C ^YOU1 able to walk at all?
HUIE_15
                 1      Yes
                 2      No             (Go to HUI_Q18)
                        DK, R          (Go to HUI_Q18)

HUI_Q16          ^DOVERB_C ^YOU1 require mechanical support such as braces, a cane or
HUIE_16          crutches to be able to walk around the neighbourhood?

                 1      Yes
                 2      No
                        DK, R

HUI_Q17          ^DOVERB_C ^YOU1 require the help of another person to be able to walk?
HUIE_17
                 1      Yes
                 2      No
                        DK, R




Statistics Canada                                                                                203
Canadian Community Health Survey - Cycle 3.1

HUI_Q18       ^DOVERB_C ^YOU1 require a wheelchair to get around?
HUIE_18
              1      Yes
              2      No            (Go to HUI_Q21)
                     DK, R         (Go to HUI_Q21)

HUI_Q19       How often ^DOVERB ^YOU1 use a wheelchair?
HUIE_19       INTERVIEWER: Read categories to respondent.

              1      Always
              2      Often
              3      Sometimes
              4      Never
                     DK, R

HUI_Q20       ^DOVERB_C ^YOU1 need the help of another person to get around in the
HUIE_20       wheelchair?

              1      Yes
              2      No
                     DK, R

Hands and Fingers

HUI_Q21       ^ARE_C ^YOU2 usually able to grasp and handle small objects such as a
HUIE_21       pencil or scissors?

              1      Yes           (Go to HUI_Q25)
              2      No
                     DK, R         (Go to HUI_Q25)

HUI_Q22       ^DOVERB_C ^YOU1 require the help of another person because of limitations
HUIE_22       in the use of hands or fingers?

              1      Yes
              2      No            (Go to HUI_Q24)
                     DK, R         (Go to HUI_Q24)

HUI_Q23       ^DOVERB_C ^YOU1 require the help of another person with:
HUIE_23       INTERVIEWER: Read categories to respondent.

              1      … some tasks?
              2      … most tasks?
              3      … almost all tasks?
              4      … all tasks?
                     DK, R




204                                                                        Statistics Canada
                                                  Canadian Community Health Survey - Cycle 3.1

HUI_Q24       ^DOVERB_C ^YOU1 require special equipment, for example, devices to assist
HUIE_24       in dressing, because of limitations in the use of hands or fingers?

              1       Yes
              2       No
                      DK, R

Feelings

HUI_Q25       Would you describe [yourself/FNAME] as being usually:
HUIE_25       INTERVIEWER: Read categories to respondent.

              1       … happy and interested in life?
              2       … somewhat happy?
              3       … somewhat unhappy?
              4       … unhappy with little interest in life?
              5       … so unhappy that life is not worthwhile?
                      DK, R

Note:         If interview non-proxy, use “yourself”. Otherwise, use ^FNAME.

Memory

HUI_Q26       How would you describe ^YOUR1 usual ability to remember things?
HUIE_26       INTERVIEWER: Read categories to respondent.

              1       Able to remember most things
              2       Somewhat forgetful
              3       Very forgetful
              4       Unable to remember anything at all
                      DK, R

Thinking

HUI_Q27       How would you describe ^YOUR1 usual ability to think and solve day-to-day
HUIE_27       problems?
              INTERVIEWER: Read categories to respondent.

              1       Able to think clearly and solve problems
              2       Having a little difficulty
              3       Having some difficulty
              4       Having a great deal of difficulty
              5       Unable to think or solve problems
                      DK, R




Statistics Canada                                                                         205
Canadian Community Health Survey - Cycle 3.1

Pain and Discomfort

HUI_Q28        ^ARE ^YOU2 usually free of pain or discomfort?
HUIE_28
               1      Yes           (Go to HUI_END)
               2      No
                      DK, R         (Go to HUI_END)

HUI_Q29        How would you describe the usual intensity of ^YOUR1 pain or discomfort?
HUIE_29        INTERVIEWER: Read categories to respondent.

               1      Mild
               2      Moderate
               3      Severe
                      DK, R

HUI_Q30        How many activities does ^YOUR1 pain or discomfort prevent?
HUIE_30        INTERVIEWER: Read categories to respondent.

               1      None
               2      A few
               3      Some
               4      Most
                      DK, R

HUI_END




206                                                                          Statistics Canada
                                                       Canadian Community Health Survey - Cycle 3.1



HEALTH STATUS – SF-36 (SFR)
SFR_BEG

SFR_C03       If (do SFR block = 1), go to SFR_R03A.
SFREFOPT      Otherwise, go to SFR_END.

SFR_R03A      Although some of the following questions may seem repetitive, the next section
              deals with another way of measuring health status.
              INTERVIEWER: Press <Enter> to continue.

SFR_R03B      The questions are about how ^YOU2 [feel/feels] and how well ^YOU1 ^ARE able to
              do ^YOUR1 usual activities.
              INTERVIEWER: Press <Enter> to continue.

Note:         If interview is non-proxy, use “feel”.
              Otherwise, use “feels”.

SFR_Q03       I’ll start with a few questions concerning activities ^YOU2 might do during
SFRE_03       a typical day. Does ^YOUR1 health limit ^HIMHER in any of the following
              activities:

              … in vigorous activities, such as running, lifting heavy objects, or participating in
              strenuous sports?
              INTERVIEWER: Read categories to respondent.

              1       Limited a lot
              2       Limited a little
              3       Not at all limited
                      DK, R (Go to SFR_END)

SFR_Q04       (Does ^YOUR1 health limit ^HIMHER:)
SFRE_04
              … in moderate activities, such as moving a table, pushing a vacuum cleaner,
              bowling, or playing golf?
              INTERVIEWER: Read categories to respondent.

              1       Limited a lot
              2       Limited a little
              3       Not at all limited
                      DK, R

SFR_Q05       (Does ^YOUR1 health limit ^HIMHER:)
SFRE_05
              … in lifting or carrying groceries?

              1       Limited a lot
              2       Limited a little
              3       Not at all limited
                      DK, R




Statistics Canada                                                                               207
Canadian Community Health Survey - Cycle 3.1

SFR_Q06      (Does ^YOUR1 health limit ^HIMHER:)
SFRE_06
             … in climbing several flights of stairs?

             1      Limited a lot
             2      Limited a little
             3      Not at all limited
                    DK, R

SFR_Q07      (Does ^YOUR1 health limit ^HIMHER:)
SFRE_07
             … in climbing one flight of stairs?

             1      Limited a lot
             2      Limited a little
             3      Not at all limited
                    DK, R

SFR_Q08      (Does ^YOUR1 health limit ^HIMHER:)
SFRE_08
             … in bending, kneeling, or stooping?

             1      Limited a lot
             2      Limited a little
             3      Not at all limited
                    DK, R

SFR_Q09      (Does ^YOUR1 health limit ^HIMHER:)
SFRE_09
             … in walking more than one kilometre?

             1      Limited a lot
             2      Limited a little
             3      Not at all limited
                    DK, R

SFR_Q10      (Does ^YOUR1 health limit ^HIMHER:)
SFRE_10
             … in walking several blocks?

             1      Limited a lot
             2      Limited a little
             3      Not at all limited
                    DK, R




208                                                     Statistics Canada
                                                 Canadian Community Health Survey - Cycle 3.1

SFR_Q11       (Does ^YOUR1 health limit ^HIMHER:)
SFRE_11
              … in walking one block?

              1      Limited a lot
              2      Limited a little
              3      Not at all limited
                     DK, R

SFR_Q12       (Does ^YOUR1 health limit ^HIMHER:)
SFRE_12
              … in bathing and dressing ^YOURSELF?

              1      Limited a lot
              2      Limited a little
              3      Not at all limited
                     DK, R

SFR_Q13       Now a few questions about problems with ^YOUR2 work or with other
SFRE_13       regular daily activities. Because of ^YOUR1 physical health, during the past
              4 weeks, did ^YOU2:

              … cut down on the amount of time ^YOU1 spent on work or other activities?

              1      Yes
              2      No
                     DK, R

SFR_Q14       Because of ^YOUR1 physical health, during the past 4 weeks, did ^YOU2:
SFRE_14
              … accomplish less than ^YOU1 would like?

              1      Yes
              2      No
                     DK, R

SFR_Q15       (Because of ^YOUR1 physical health, during the past 4 weeks,) ^WERE ^YOU2:
SFRE_15
              … limited in the kind of work or other activities?

              1      Yes
              2      No
                     DK, R




Statistics Canada                                                                            209
Canadian Community Health Survey - Cycle 3.1

SFR_Q16      (Because of ^YOUR1 physical health, during the past 4 weeks,) did ^YOU2:
SFRE_16
             … have difficulty performing the work or other activities (for example, it took extra
             effort)?

             1      Yes
             2      No
                    DK, R

SFR_Q17      Next a few questions about problems with ^YOUR2 work or with other regular
SFRE_17      daily activities due to emotional problems (such as feeling depressed or anxious).
             Because of emotional problems, during the past 4 weeks, did ^YOU2:

             … cut down on the amount of time ^YOU1 spent on work or other activities?

             1      Yes
             2      No
                    DK, R
                    R     (Go to SFR_END)

SFR_Q18      Because of emotional problems, during the past 4 weeks, did ^YOU2:
SFRE_18
             … accomplish less than ^YOU1 would like?

             1      Yes
             2      No
                    DK, R

SFR_Q19      (Because of emotional problems, during the past 4 weeks,) did ^YOU2:
SFRE_19
             … not do work or other activities as carefully as usual?

             1      Yes
             2      No
                    DK, R

SFR_Q20      During the past 4 weeks, how much has ^YOUR1 physical health or emotional
SFRE_20      problems interfered with ^YOUR1 normal social activities with family, friends,
             neighbours, or groups?
             INTERVIEWER: Read categories to respondent.

             1      Not at all
             2      A little bit
             3      Moderately
             4      Quite a bit
             5      Extremely
                    DK, R




210                                                                             Statistics Canada
                                               Canadian Community Health Survey - Cycle 3.1

SFR_Q21       During the past 4 weeks, how much bodily pain ^HAVE ^YOU1 had?
SFRE_21       INTERVIEWER: Read categories to respondent

              1      None
              2      Very mild
              3      Mild
              4      Moderate
              5      Severe
              6      Very severe
                     DK, R

SFR_Q22       During the past 4 weeks, how much did pain interfere with ^YOUR1 normal
SFRE_22       work (including work both outside the home and housework)?
              INTERVIEWER: Read categories to respondent.

              1      Not at all
              2      A little bit
              3      Moderately
              4      Quite a bit
              5      Extremely
                     DK, R

SFR_R23       The next questions are about how ^YOU2 felt and how things have been with
              ^HIMHER during the past 4 weeks. For each question, please indicate the answer
              that comes closest to the way ^YOU2 ^HAVE been feeling.
              INTERVIEWER: Press <Enter> to continue.

SFR_Q23       During the past 4 weeks, how much of the time:
SFRE_23
              … did ^YOU2 feel full of pep?
              INTERVIEWER: Read categories to respondent.

              1      All of the time
              2      Most of the time
              3      A good bit of the time
              4      Some of the time
              5      A little of the time
              6      None of the time
                     DK, R

SFR_Q24       (During the past 4 weeks, how much of the time:)
SFRE_24
              … ^HAVE ^YOU2 been a very nervous person?
              INTERVIEWER: Read categories to respondent.

              1      All of the time
              2      Most of the time
              3      A good bit of the time
              4      Some of the time
              5      A little of the time
              6      None of the time
                     DK, R




Statistics Canada                                                                         211
Canadian Community Health Survey - Cycle 3.1

SFR_Q25      (During the past 4 weeks, how much of the time:)
SFRE_25
             … ^HAVE ^YOU1 felt so down in the dumps that nothing could cheer ^HIMHER
             up?

             1      All of the time
             2      Most of the time
             3      A good bit of the time
             4      Some of the time
             5      A little of the time
             6      None of the time
                    DK, R

SFR_Q26      (During the past 4 weeks, how much of the time:)
SFRE_26
             … ^HAVE ^YOU1 felt calm and peaceful?

             1      All of the time
             2      Most of the time
             3      A good bit of the time
             4      Some of the time
             5      A little of the time
             6      None of the time
                    DK, R

SFR_Q27      (During the past 4 weeks, how much of the time:)
SFRE_27
             … did ^YOU1 have a lot of energy?

             1      All of the time
             2      Most of the time
             3      A good bit of the time
             4      Some of the time
             5      A little of the time
             6      None of the time
                    DK, R

SFR_Q28      During the past 4 weeks, how much of the time:
SFRE_28
             … ^HAVE ^YOU1 felt downhearted and blue?

             1      All of the time
             2      Most of the time
             3      A good bit of the time
             4      Some of the time
             5      A little of the time
             6      None of the time
                    DK, R




212                                                                     Statistics Canada
                                                 Canadian Community Health Survey - Cycle 3.1

SFR_Q29       (During the past 4 weeks, how much of the time:)
SFRE_29
              … did ^YOU1 feel worn out?

              1      All of the time
              2      Most of the time
              3      A good bit of the time
              4      Some of the time
              5      A little of the time
              6      None of the time
                     DK, R

SFR_Q30       (During the past 4 weeks, how much of the time:)
SFRE_30
              … ^HAVE ^YOU1 been a happy person?

              1      All of the time
              2      Most of the time
              3      A good bit of the time
              4      Some of the time
              5      A little of the time
              6      None of the time
                     DK, R

SFR_Q31       (During the past 4 weeks, how much of the time:)
SFRE_31
              … did ^YOU1 feel tired?

              1      All of the time
              2      Most of the time
              3      A good bit of the time
              4      Some of the time
              5      A little of the time
              6      None of the time
                     DK, R

SFR_Q32       During the past 4 weeks, how much of the time has ^YOUR1 health
SFRE_32       limited ^YOUR1 social activities (such as visiting with friends or close
              relatives)?

              1      All of the time
              2      Most of the time
              3      A good bit of the time
              4      Some of the time
              5      A little of the time
              6      None of the time
                     DK, R




Statistics Canada                                                                        213
Canadian Community Health Survey - Cycle 3.1

SFR_Q33      Now please tell me the answer that best describes how true or false each of
SFRE_33      the following statements is for ^YOU2.

             [I/FNAME] [seem/seems] to get sick a little easier than other people.
             INTERVIEWER: Read categories to respondent.

             1       Definitely true
             2       Mostly true
             3       Not sure
             4       Mostly false
             5       Definitely false
                     DK, R

Note:        If interview non-proxy, use “I” and “seem”.
             Otherwise, use ^FNAME and “seems”.

SFR_Q34      (Please tell me the answer that best describes how true or false each of the
SFRE_34      following statements is for ^YOU2.)

             [I/FNAME] [am/is] as healthy as anybody [I/he/she] [know/knows].
             INTERVIEWER: Read categories to respondent.

             1       Definitely true
             2       Mostly true
             3       Not sure
             4       Mostly false
             5       Definitely false
                     DK, R

Note:        If interview non-proxy, use “I”, “am“, “I” and “know”.
             If interview proxy and sex = male, use ^FNAME, “is”, “he” and “knows”.
             Otherwise, use ^FNAME, “is”, “she” and “knows”.

SFR_Q35      (Please tell me the answer that best describes how true or false each of the
SFRE_35      following statements is for ^YOU2.)

             [I/FNAME] [expect/expects] [my/his/her] health to get worse.

             1       Definitely true
             2       Mostly true
             3       Not sure
             4       Mostly false
             5       Definitely false
                     DK, R

Note:        If interview non-proxy, use “I”, “expect”, and “my”.
             If proxy interview and sex = male, use ^FNAME, “expects” and “his”.
             Otherwise, use ^FNAME, “expects” and “her”.




214                                                                                Statistics Canada
                                                  Canadian Community Health Survey - Cycle 3.1

SFR_Q36       (Please tell me the answer that best describes how true or false each of the
SFRE_36       following statements is for ^YOU2.)

              [My/FNAME’s] health is excellent.

              1      Definitely true
              2      Mostly true
              3      Not sure
              4      Mostly false
              5      Definitely false
                     DK, R

Note:         If interview non-proxy, use “My”. Otherwise, use ^FNAME’s.

SFR_END




Statistics Canada                                                                            215
Canadian Community Health Survey - Cycle 3.1



SEXUAL BEHAVIOURS (SXB)
SXB_BEG

SXB_C01A     If (do SXB block = 1), go to SXB_C01B.
             Otherwise, go to SXB_END.

SXB_C01B     If proxy interview or age < 15 or > 49, go to SXB_END.
             Otherwise, go to SXB_R01.

SXB_R01      I would like to ask you a few questions about sexual behaviour. We ask these
              questions because sexual behaviours can have very important and long-lasting
             effects on personal health. You can be assured that anything you say will remain
             confidential.
             INTERVIEWER: Press <Enter> to continue.

SXB_Q01      Have you ever had sexual intercourse?
SXBE_1
             1       Yes
             2       No    (Go to SXB_END)
                     DK, R (Go to SXB_END)

SXB_Q02      How old were you the first time?
SXBE_2       INTERVIEWER: Maximum is [current age].

             |_|_|   Age in years
             (MIN: 1; warning below 12) (MAX: current age)
             DK, R (Go to SXB_END)

SXB_E02      The entered age at which the respondent first had sexual intercourse is invalid.
             Please return and correct.

             Trigger hard edit if SXB_Q02 < 1 or SXB_Q02 > [current age].

SXB_Q03      In the past 12 months, have you had sexual intercourse?
SXBE_3
             1       Yes
             2       No    (Go to SXB_Q07)
                     DK, R (Go to SXB_END)

SXB_Q04      With how many different partners?
SXBE_4
             1       1 partner
             2       2 partners
             3       3 partners
             4       4 or more partners
                     DK
                     R               (Go to SXB_END)




216                                                                            Statistics Canada
                                                   Canadian Community Health Survey - Cycle 3.1

SXB_Q07       Have you ever been diagnosed with a sexually transmitted disease?
SXBE_07
              1       Yes
              2       No
                      DK, R

SXB_C08A      If SXB_Q03 = 1 (had intercourse in last 12 months), go to SXB_C08C.
              Otherwise, go to SXB_END.

SXB_C08C      If marital status = 1 (married) or 2 (common-law) and SXB_Q04 = 1 (one partner), go to
              SXB_C09B.
              Otherwise, go to SXB_Q08.

SXB_Q08       Did you use a condom the last time you had sexual intercourse?
SXBE_7A
              1       Yes
              2       No
                      DK, R

SXB_C09B      If age > 24, go to SXB_END.
              Otherwise, go to SXB_R9A.

SXB_R9A       Now a few questions about birth control.
              INTERVIEWER: Press <Enter> to continue.

SXB_C09C      If sex = female, go to SXB_C09D.
              Otherwise, go to SXB_R10.

SXB_C09D      If MAM_Q037 = 1 (currently pregnant), go to SXB_Q11.
              Otherwise, go to SXB_R9B.

SXB_R9B       I’m going to read you a statement about pregnancy. Please tell me if you strongly
              agree, agree, neither agree nor disagree, disagree, or strongly disagree.
              INTERVIEWER: Press <Enter> to continue.

SXB_Q09       It is important to me to avoid getting pregnant right now.
SXBE_09
              1       Strongly agree                  (Go to SXB_Q11)
              2       Agree                           (Go to SXB_Q11)
              3       Neither agree nor disagree      (Go to SXB_Q11)
              4       Disagree                        (Go to SXB_Q11)
              5       Strongly disagree               (Go to SXB_Q11)
                      DK                              (Go to SXB_Q11)
                      R                               (Go to SXB_END)

SXB_R10       I’m going to read you a statement about pregnancy. Please tell me if you strongly
              agree, agree, neither agree nor disagree, disagree, or strongly disagree.
              INTERVIEWER: Press <Enter> to continue.




Statistics Canada                                                                                 217
Canadian Community Health Survey - Cycle 3.1

SXB_Q10      It is important to me to avoid getting my partner pregnant right now.
SXBE_10
             1      Strongly agree
             2      Agree
             3      Neither agree nor disagree
             4      Disagree
             5      Strongly disagree
             6      Doesn’t have a partner right now
                    DK
                    R       (Go to SXB_END)

SXB_Q11      In the past 12 months, did you and your partner usually use birth control?
SXBE_11
             1      Yes   (Go to SXB_Q12)
             2      No    (Go to SXB_END)
                    DK, R (Go to SXB_END)

SXB_Q12      What kind of birth control did you and your partner usually use?
             INTERVIEWER: Mark all that apply.

SXBE_12A     1      Condom (male or female condom)
SXBE_12B     2      Birth control pill
SXBE_12C     3      Diaphragm
SXBE_12D     4      Spermicide (e.g., foam, jelly, film)
SXBE_12F     5      Birth control injection (Deprovera)
SXBE_12E     6      Other - Specify
                    DK, R (Go to SXB_END)

SXB_C12S     If SXB_Q12 = 6, go to SXB_Q12S.
             Otherwise, go to SXB_C13.

SXB_Q12S     INTERVIEWER: Specify.

             ________________________
             (80 spaces)
             DK, R

SXB_C13      If MAM_Q037 = 1 (currently pregnant), go to SXB_END.
             Otherwise, go to SXB_Q13.

SXB_Q13      What kind of birth control did you and your partner use the last time you had sex?
             INTERVIEWER: Mark all that apply.

SXBE_13A     1      Condom (male or female condom)
SXBE_13B     2      Birth control pill
SXBE_13C     3      Diaphragm
SXBE_13D     4      Spermicide (e.g., foam, jelly, film)
SXBE_13F     5      Birth control injection (Deprovera)
SXBE_13G     6      Nothing
SXBE_13E     7      Other - Specify
                    DK, R              (Go to SXB_END)




218                                                                             Statistics Canada
                                                Canadian Community Health Survey - Cycle 3.1

SXB_C13S      If SXB_Q13 = 7, go to SXB_Q13S.
              Otherwise, go to SXB_END.

SXB_Q13S      INTERVIEWER: Specify.

              ________________________
              (80 spaces)
              DK, R

SXB_END




Statistics Canada                                                                       219
Canadian Community Health Survey - Cycle 3.1



ACCESS TO HEALTH CARE SERVICES (ACC)
ACC_BEG

Note:        This module was collected as optional content and as part of a subsample.

ACC_C1       If (do ACC block = 1), go to ACC_C2.
ACCEFOPT     Otherwise, go to ACC_END.

ACC_C2       If proxy interview or if age < 15, go to ACC_END.
             Otherwise, go to ACC_QINT10.

ACC_QINT10   The next questions are about the use of various health care services.

             I will start by asking about your experiences getting health care from a medical
             specialist such as a cardiologist, allergist, gynaecologist or psychiatrist (excluding
             an optometrist).
             INTERVIEWER: Press <Enter> to continue.

ACC_Q10      In the past 12 months, did you require a visit to a medical specialist for a diagnosis
ACCE_10      or a consultation?

             1       Yes
             2       No    (Go to ACC_QINT20)
                     DK, R (Go to ACC_QINT20)

ACC_Q11      In the past 12 months, did you ever experience any difficulties getting the
ACCE_11      specialist care you needed for a diagnosis or consultation?

             1       Yes
             2       No    (Go to ACC_QINT20)
                     DK, R (Go to ACC_QINT20)

ACC_Q12      What type of difficulties did you experience?
             INTERVIEWER: Mark all that apply.

ACCE_12A     1       Difficulty getting a referral
ACCE_12B     2       Difficulty getting an appointment
ACCE_12C     3       No specialists in the area
ACCE_12D     4       Waited too long - between booking appointment and visit
ACCE_12E     5       Waited too long - to see the doctor (i.e. in-office waiting)
ACCE_12F     6       Transportation - problems
ACCE_12G     7       Language - problem
ACCE_12H     8       Cost
ACCE_12I     9       Personal or family responsibilities
ACCE_12J     10      General deterioration of health
ACCE_12K     11      Appointment cancelled or deferred by specialist
ACCE_12L     12      Still waiting for visit
ACCE_12M     13      Unable to leave the house because of a health problem
ACCE_12N     14      Other - Specify
                     DK, R

ACC_C12S     If ACC_Q12 = 14 , go to ACC_Q12S.
             Otherwise, go to ACC_QINT20.



220                                                                                 Statistics Canada
                                                 Canadian Community Health Survey - Cycle 3.1

ACC_Q12S      INTERVIEWER: Specify.

              ___________________________
              (80 spaces)
              DK, R

ACC_QINT20    The following questions are about any surgery not provided in an emergency that
              you may have required, such as cardiac surgery, joint surgery, caesarean sections
              and cataract surgery, excluding laser eye surgery.
              INTERVIEWER: Press <Enter> to continue.

ACC_Q20       In the past 12 months, did you require any non-emergency surgery?
ACCE_20
              1      Yes
              2      No    (Go to ACC_QINT30)
                     DK, R (Go to ACC_QINT30)

ACC_Q21       In the past 12 months, did you ever experience any difficulties getting the surgery
ACCE_21       you needed?

              1      Yes
              2      No    (Go to ACC_QINT30)
                     DK, R (Go to ACC_QINT30)

ACC_Q22       What type of difficulties did you experience?
              INTERVIEWER: Mark all that apply.

ACCE_22A      1      Difficulty getting an appointment with a surgeon
ACCE_22B      2      Difficulty getting a diagnosis
ACCE_22C      3      Waited too long - for a diagnostic test
ACCE_22D      4      Waited too long - for a hospital bed to become available
ACCE_22E      5      Waited too long - for surgery
ACCE_22F      6      Service not available - in the area
ACCE_22G      7      Transportation - problems
ACCE_22H      8      Language - problem
ACCE_22I      9      Cost
ACCE_22J      10     Personal or family responsibilities
ACCE_22K      11     General deterioration of health
ACCE_22L      12     Appointment cancelled or deferred by surgeon or hospital
ACCE_22M      13     Still waiting for surgery
ACCE_22N      14     Unable to leave the house because of a health problem
ACCE_22O      15     Other - Specify
                     DK, R

ACC_C22S      If ACC_Q22 = 15, go to ACC_Q22S.
              Otherwise, go to ACC_QINT30.

ACC_Q22S      INTERVIEWER: Specify.

              ___________________________
              (80 spaces)
              DK, R




Statistics Canada                                                                             221
Canadian Community Health Survey - Cycle 3.1

ACC_QINT30   Now some questions about MRIs, CAT Scans and angiographies provided in a
             non-emergency situation.
             INTERVIEWER: Press <Enter> to continue.

ACC_Q30      In the past 12 months, did you require one of these tests?
ACCE_30
             1      Yes
             2      No    (Go to ACC_QINT40)
                    DK, R (Go to ACC_QINT40)

ACC_Q31      In the past 12 months, did you ever experience any difficulties getting the
ACCE_31      tests you needed?

             1      Yes
             2      No    (Go to ACC_QINT40)
                    DK, R (Go to ACC_QINT40)

ACC_Q32      What type of difficulties did you experience?
             INTERVIEWER: Mark all that apply.

ACCE_32A     1      Difficulty getting a referral
ACCE_32B     2      Difficulty getting an appointment
ACCE_32C     3      Waited too long - to get an appointment
ACCE_32D     4      Waited too long - to get test (i.e. in-office waiting)
ACCE_32E     5      Service not available - at time required
ACCE_32F     6      Service not available - in the area
ACCE_32G     7      Transportation - problems
ACCE_32H     8      Language - problem
ACCE_32I     9      Cost
ACCE_32J     10     General deterioration of health
ACCE_32K     11     Did not know where to go (i.e. information problems)
ACCE_32L     12     Still waiting for test
ACCE_32M     13     Unable to leave the house because of a health problem
ACCE_32N     14     Other - Specify
                    DK, R

ACC_C32S     If ACC_Q32 = 14, go to ACC_ Q32S.
             Otherwise, go to ACC_QINT40.

ACC_Q32S     INTERVIEWER: Specify.

             ___________________________
             (80 spaces)
             DK, R

ACC_QINT40   Now I’d like you to think about yourself and family members living in your
             dwelling.

             The next questions are about your experiences getting health information or
             advice when you needed them for yourself or a family member living in your
             dwelling.
             INTERVIEWER: Press <Enter> to continue.




222                                                                            Statistics Canada
                                                 Canadian Community Health Survey - Cycle 3.1

ACC_Q40       In the past 12 months, have you required health information or advice for yourself
ACCE_40       or a family member?

              1      Yes
              2      No    (Go to ACC_QINT50)
                     DK, R (Go to ACC_QINT50)

ACC_Q40A      Who did you contact when you needed health information or advice for yourself or
              a family member?
              INTERVIEWER: Read categories to respondent. Mark all that apply.

ACCE_40A      1      Doctor’s office
ACCE_40B      2      Community health centre / CLSC
ACCE_40C      3      Walk-in clinic
ACCE_40D      4      Telephone health line (e.g., HealthLinks, Telehealth Ontario,
                     HealthLink, Health-Line, TeleCare, Info-Santé)
ACCE_40E      5      Hospital emergency room
ACCE_40F      6      Other hospital service
ACCE_40G      7      Other - Specify

ACC_C40AS     If ACC_Q40A = 7, go to ACC_Q40AS.
              Otherwise, go to ACC_Q41.

ACC_Q40AS     INTERVIEWER: Specify.

              ___________________________
              (80 spaces)
              DK, R

ACC_Q41       In the past 12 months, did you ever experience any difficulties getting the
ACCE_41       health information or advice you needed for yourself or a family member?

              1      Yes
              2      No    (Go to ACC_QINT50)
                     DK, R (Go to ACC_QINT50)

ACC_Q42       Did you experience difficulties during “regular” office hours (that is, 9:00 am to
ACCE_42       5:00 pm, Monday to Friday)?
              INTERVIEWER: It is important to make a distinction between “No” (Did not experience
              problems) and “Did not require at this time”.

              1      Yes
              2      No                              (Go to ACC_Q44)
              3      Not required at this time       (Go to ACC_Q44)
                     DK, R                           (Go to ACC_Q44)




Statistics Canada                                                                               223
Canadian Community Health Survey - Cycle 3.1

ACC_Q43      What type of difficulties did you experience?
             INTERVIEWER: Mark all that apply.

ACCE_43A     1      Difficulty contacting a physician or nurse
ACCE_43B     2      Did not have a phone number
ACCE_43C     3      Could not get through (i.e. no answer)
ACCE_43D     4      Waited too long to speak to someone
ACCE_43E     5      Did not get adequate info or advice
ACCE_43F     6      Language - problem
ACCE_43G     7      Did not know where to go / call / uninformed
ACCE_43H     8      Unable to leave the house because of a health problem
ACCE_43I     9      Other - Specify
                    DK, R

ACC_C43S     If ACC_Q43 = 9, go to ACC_Q43S.
             Otherwise, go to ACC_Q44.

ACC_Q43S     INTERVIEWER: Specify.

             ___________________________
             (80 spaces)
             DK, R

ACC_Q44      Did you experience difficulties getting health information or advice during
ACCE_44      evenings and weekends (that is, 5:00 to 9:00 pm Monday to Friday, or
             9:00 am to 5:00 pm, Saturdays and Sundays)?
             INTERVIEWER: It is important to make a distinction between “No” (Did not experience
             problems) and “Did not require at this time”.

             1      Yes
             2      No                              (Go to ACC_Q46)
             3      Not required at this time       (Go to ACC_Q46)
                    DK, R                           (Go to ACC_Q46)

ACC_Q45      What type of difficulties did you experience?
             INTERVIEWER: Mark all that apply.

ACCE_45A     1      Difficulty contacting a physician or nurse
ACCE_45B     2      Did not have a phone number
ACCE_45C     3      Could not get through (i.e. no answer)
ACCE_45D     4      Waited too long to speak to someone
ACCE_45E     5      Did not get adequate info or advice
ACCE_45F     6      Language - problem
ACCE_45G     7      Did not know where to go / call / uninformed
ACCE_45H     8      Unable to leave the house because of a health problem
ACCE_45I     9      Other - Specify
                    DK, R

ACC_C45S     If ACC_Q45 = 9, go to ACC_Q45S.
             Otherwise, go to ACC_Q46.

ACC_Q45S     INTERVIEWER: Specify.

             ___________________________
             (80 spaces)
             DK, R


224                                                                             Statistics Canada
                                                 Canadian Community Health Survey - Cycle 3.1

ACC_Q46       Did you experience difficulties getting health information or advice during the
ACCE_46       middle of the night?
              INTERVIEWER: It is important to make a distinction between “No” (Did not experience
              problems) and “Did not require at this time”.

              1      Yes
              2      No                        (Go to ACC_QINT50)
              3      Not required at this time (Go to ACC_QINT50)
                     DK, R                     (Go to ACC_QINT50)

ACC_Q47       What type of difficulties did you experience?
              INTERVIEWER: Mark all that apply.

ACCE_47A      1      Difficulty contacting a physician or nurse
ACCE_47B      2      Did not have a phone number
ACCE_47C      3      Could not get through (i.e. no answer)
ACCE_47D      4      Waited too long to speak to someone
ACCE_47E      5      Did not get adequate info or advice
ACCE_47F      6      Language - problem
ACCE_47G      7      Did not know where to go / call / uninformed
ACCE_47H      8      Unable to leave the house because of a health problem
ACCE_47I      9      Other - Specify
                     DK, R

ACC_C47S      If ACC_Q47 = 9, go to ACC_Q47S.
              Otherwise, go to ACC_QINT50.

ACC_Q47S      INTERVIEWER: Specify.

              ___________________________
              (80 spaces)
              DK, R

ACC_QINT50    Now some questions about your experiences when you needed health care
              services for routine or on-going care such as a medical exam or follow-up for
              yourself or a family member living in your dwelling.
              INTERVIEWER: Press <Enter> to continue.

ACC_Q50A      Do you have a regular family doctor?
ACCE_50A
              1      Yes
              2      No
                     DK, R

ACC_Q50       In the past 12 months, did you require any routine or on-going care for yourself
ACCE_50       or a family member?

              1      Yes
              2      No    (Go to ACC_QINT60)
                     DK, R (Go to ACC_QINT60)




Statistics Canada                                                                                225
Canadian Community Health Survey - Cycle 3.1

ACC_Q51      In the past 12 months, did you ever experience any difficulties getting the
ACCE_51      routine or on-going care you or a family member needed?

             1      Yes
             2      No    (Go to ACC_QINT60)
                    DK, R (Go to ACC_QINT60)

ACC_Q52      Did you experience difficulties getting such care during “regular” office hours
ACCE_52      (that is, 9:00 am to 5:00 pm, Monday to Friday)?
             INTERVIEWER: It is important to make a distinction between “No” (Did not
             experience problems) and “Did not require at this time”.

             1      Yes
             2      No                        (Go to ACC_Q54)
             3      Not required at this time (Go to ACC_Q54)
                    DK, R                     (Go to ACC_Q54)

ACC_Q53      What type of difficulties did you experience?
             INTERVIEWER: Mark all that apply.

ACCE_53A     1      Difficulty contacting a physician
ACCE_53B     2      Difficulty getting an appointment
ACCE_53C     3      Do not have personal / family physician
ACCE_53D     4      Waited too long - to get an appointment
ACCE_53E     5      Waited too long - to see the doctor (i.e. in-office waiting)
ACCE_53F     6      Service not available - at time required
ACCE_53G     7      Service not available - in the area
ACCE_53H     8      Transportation - problems
ACCE_53I     9      Language - problem
ACCE_53J     10     Cost
ACCE_53K     11     Did not know where to go (i.e. information problems)
ACCE_53L     12     Unable to leave the house because of a health problem
ACCE_53M     13     Other - Specify
                    DK, R

ACC_C53S     If ACC_Q53 = 13, go to ACC_Q53S.
             Otherwise, go to ACC_Q54.

ACC_Q53S     INTERVIEWER: Specify.

             ___________________________
             (80 spaces)
             DK, R




226                                                                                Statistics Canada
                                                   Canadian Community Health Survey - Cycle 3.1

ACC_Q54       Did you experience difficulties getting such care during evenings and
ACCE_54       weekends (that is, 5:00 to 9:00 pm, Monday to Friday or 9:00 am to 5:00 pm,
              Saturdays and Sundays)?
              INTERVIEWER: It is important to make a distinction between “No” (Did not experience
              problems) and “Did not require at this time”.

              1      Yes
              2      No                        (Go to ACC_QINT60)
              3      Not required at this time (Go to ACC_QINT60)
                     DK, R                     (Go to ACC_QINT60)

ACC_Q55       What type of difficulties did you experience?
              INTERVIEWER: Mark all that apply.

ACCE_55A      1      Difficulty contacting a physician
ACCE_55B      2      Difficulty getting an appointment
ACCE_55C      3      Do not have personal / family physician
ACCE_55D      4      Waited too long - to get an appointment
ACCE_55E      5      Waited too long - to see the doctor (i.e. in-office waiting)
ACCE_55F      6      Service not available - at time required
ACCE_55G      7      Service not available - in the area
ACCE_55H      8      Transportation - problems
ACCE_55I      9      Language - problem
ACCE_55J      10     Cost
ACCE_55K      11     Did not know where to go (i.e. information problems)
ACCE_55L      12     Unable to leave the house because of a health problem
ACCE_55M      13     Other - Specify
                     DK, R

ACC_C55S      If ACC_Q55 = 13, go to ACC_Q55S.
              Otherwise, go to ACC_QINT60.

ACC_Q55S      INTERVIEWER: Specify.

              ___________________________
              (80 spaces)
              DK, R

ACC_QINT60    The next questions are about situations when you or a family member have needed
              immediate care for a minor health problem such as fever, headache, a sprained
              ankle, vomiting or an unexplained rash.
              INTERVIEWER: Press <Enter> to continue.

ACC_Q60       In the past 12 months, have you or a family member required immediate health
ACCE_60       care services for a minor health problem?

              1      Yes
              2      No    (Go to ACC_END)
                     DK, R (Go to ACC_END)




Statistics Canada                                                                               227
Canadian Community Health Survey - Cycle 3.1

ACC_Q61      In the past 12 months, did you ever experience any difficulties getting the
ACCE_61      immediate care needed for a minor health problem for yourself or a family
             member?

             1      Yes
             2      No    (Go to ACC_END)
                    DK, R (Go to ACC_END)

ACC_Q62      Did you experience difficulties getting such care during “regular” office hours
ACCE_62      (that is, 9:00 am to 5:00 pm, Monday to Friday)?
             INTERVIEWER: It is important to make a distinction between “No” (Did not experience
             problems) and “Did not require at this time”.

             1      Yes
             2      No                        (Go to ACC_Q64)
             3      Not required at this time (Go to ACC_Q64)
                    DK, R                     (Go to ACC_Q64)

ACC_Q63      What type of difficulties did you experience?
             INTERVIEWER: Mark all that apply.

ACCE_63A     1      Difficulty contacting a physician
ACCE_63B     2      Difficulty getting an appointment
ACCE_63C     3      Do not have personal / family physician
ACCE_63D     4      Waited too long - to get an appointment
ACCE_63E     5      Waited too long - to see the doctor (i.e. in-office waiting)
ACCE_63F     6      Service not available - at time required
ACCE_63G     7      Service not available - in the area
ACCE_63H     8      Transportation - problems
ACCE_63I     9      Language - problem
ACCE_63J     10     Cost
ACCE_63K     11     Did not know where to go (i.e. information problems)
ACCE_63L     12     Unable to leave the house because of a health problem
ACCE_63M     13     Other - Specify
                    DK, R

ACC_C63S     If ACC_Q63 = 13, go to ACC_Q63S.
             Otherwise, go to ACC_Q64.

ACC_Q63S     INTERVIEWER: Specify.

             ___________________________
             (80 spaces)
             DK, R

ACC_Q64      Did you experience difficulties getting such care during evenings and weekends
ACCE_64      (that is, 5:00 to 9:00 pm, Monday to Friday or 9:00 am to 5:00 pm, Saturdays and
             Sundays)?
             INTERVIEWER: It is important to make a distinction between “No” (Did not experience
             problems) and “Did not require at this time”.

             1      Yes
             2      No                        (Go to ACC_Q66)
             3      Not required at this time (Go to ACC_Q66)
                    DK, R                     (Go to ACC_Q66)




228                                                                                Statistics Canada
                                                   Canadian Community Health Survey - Cycle 3.1

ACC_Q65       What type of difficulties did you experience?
              INTERVIEWER: Mark all that apply.

ACCE_65A      1      Difficulty contacting a physician
ACCE_65B      2      Difficulty getting an appointment
ACCE_65C      3      Do not have personal / family physician
ACCE_65D      4      Waited too long - to get an appointment
ACCE_65E      5      Waited too long - to see the doctor (i.e. in-office waiting)
ACCE_65F      6      Service not available - at time required
ACCE_65G      7      Service not available - in the area
ACCE_65H      8      Transportation - problems
ACCE_65I      9      Language - problem
ACCE_65J      10     Cost
ACCE_65K      11     Did not know where to go (i.e. information problems)
ACCE_65L      12     Unable to leave the house because of a health problem
ACCE_65M      13     Other - Specify
                     DK, R

ACC_C65S      If ACC_Q65 = 13, go to ACC_Q65S.
              Otherwise, go to ACC_Q66.

ACC_Q65S      INTERVIEWER: Specify.

              ___________________________
              (80 spaces)
              DK, R

ACC_Q66       Did you experience difficulties getting such care during the middle of the
ACCE_66       night?
              INTERVIEWER: It is important to make a distinction between “No” (Did not experience
              problems) and “Did not require at this time”.

              1      Yes
              2      No                        (Go to ACC_END)
              3      Not required at this time (Go to ACC_END)
                     DK, R                     (Go to ACC_END)

ACC_Q67       What type of difficulties did you experience?
              INTERVIEWER: Mark all that apply.

ACCE_67A      1      Difficulty contacting a physician
ACCE_67B      2      Difficulty getting an appointment
ACCE_67C      3      Do not have personal / family physician
ACCE_67D      4      Waited too long - to get an appointment
ACCE_67E      5      Waited too long - to see the doctor (i.e. in-office waiting)
ACCE_67F      6      Service not available - at time required
ACCE_67G      7      Service not available - in the area
ACCE_67H      8      Transportation - problems
ACCE_67I      9      Language - problem
ACCE_67J      10     Cost
ACCE_67K      11     Did not know where to go (i.e. information problems)
ACCE_67L      12     Unable to leave the house because of a health problem
ACCE_67M      13     Other - Specify
                     DK, R




Statistics Canada                                                                               229
Canadian Community Health Survey - Cycle 3.1

ACC_C67S     If ACC_Q67 = 13, go to ACC_Q67S.
             Otherwise, go to ACC_END.

ACC_Q67S     INTERVIEWER: Specify.

             ___________________________
             (80 spaces)
             DK, R

ACC_END




230                                             Statistics Canada
                                                   Canadian Community Health Survey - Cycle 3.1



WAITING TIMES (WTM)
WTM_BEG

WTM_C01       If (do WTM block = 1), go to WTM_C02.
WTMEFOPT      Otherwise, go to WTM_END.

Note:         This module was collected as optional content and as part of a subsample.

WTM_C02       If proxy interview or if age < 15, go to WTM_END.
              Otherwise, go to WTM_C03.

WTM_C03       If ACC_Q10 = 2 (did not require a visit to a specialist) and
                     ACC_Q20 = 2 (did not require non emergency surgery) and
                     ACC_Q30 = 2 (did not require tests), go to WTM_END.
              Otherwise, go to WTM_QINT.

WTM_QINT      Now some additional questions about your experiences waiting for health care
              services.
              INTERVIEWER: Press <Enter> to continue.

WTM_C04       If ACC_Q10 = 2 (did not require a visit to a specialist), go to WTM_C16.
              Otherwise, go to WTM_Q01.

WTM_Q01       You mentioned that you required a visit to a medical specialist such as a
WTME_01       cardiologist, allergist, gynaecologist or psychiatrist.

              In the past 12 months, did you require a visit to a medical specialist for a diagnosis
              or a consultation for a new illness or condition?

              1       Yes
              2       No              (Go to WTM_C16)
                      DK, R           (Go to WTM_C16)

WTM_Q02       For what type of condition?
WTME_02
              If you have had more than one such visit, please answer for the most recent visit.
              INTERVIEWER: Read categories to respondent.

              1       Heart condition or stroke
              2       Cancer
              3       Asthma or other breathing conditions
              4       Arthritis or rheumatism
              5       Cataract or other eye conditions
              6       Mental health disorder
              7       Skin conditions
              8       [Gynaecological problems/blank]
              9       Other – Specify
                      DK, R

Note:         If sex = female, use “Gynaecological problems”, in WTM_Q02, category 8.
              Otherwise, use blank.




Statistics Canada                                                                               231
Canadian Community Health Survey - Cycle 3.1

WTM_E02      A blank answer has been selected. Please return and correct.

             Trigger hard edit if WTM_Q02 = 8 and sex = male.

WTM_C02S     If WTM_Q02 = 9, go to WTM_Q02S.
             Otherwise, go to WTM_Q03.

WTM_Q02S     INTERVIEWER: Specify.

             ________________________
             (80 spaces)
             DK, R

WTM_Q03      Were you referred by:
WTME_03      INTERVIEWER: Read categories to respondent.

             1       … a family doctor?
             2       … another specialist?
             3       … another health care provider?
             4       Did not require a referral
                     DK, R

WTM_Q04      Have you already visited the medical specialist?
WTME_04
             1       Yes
             2       No               (Go to WTM_Q08A)
                     DK, R            (Go to WTM_Q08A)

WTM_Q05      Thinking about this visit, did you experience any difficulties seeing the specialist?
WTME_05
             1       Yes
             2       No                       (Go to WTM_Q07A)
                     DK, R                    (Go to WTM_Q07A)

WTM_Q06      What type of difficulties did you experience?
             INTERVIEWER: Mark all that apply. Question ACC_Q12 previously asked about any
             difficulties getting specialist care. This question (WTM_Q06) deals with difficulties
             experienced for the most recent visit for a new illness or condition.

WTME_06A     1       Difficulty getting a referral
WTME_06B     2       Difficulty getting an appointment
WTME_06C     3       No specialists in the area
WTME_06D     4       Waited too long - between booking appointment and visit
WTME_06E     5       Waited too long - to see the doctor (i.e. in-office waiting)
WTME_06F     6       Transportation – problems
WTME_06G     7       Language – problem
WTME_06H     8       Cost
WTME_06I     9       Personal or family responsibilities
WTME_06J     10      General deterioration of health
WTME_06K     11      Appointment cancelled or deferred by specialist
WTME_06L     12      Unable to leave the house because of a health problem
WTME_06M     13      Other – Specify
                     DK, R




232                                                                                 Statistics Canada
                                                  Canadian Community Health Survey - Cycle 3.1

WTM_C06S      If WTM_Q06 = 13, go to WTM_Q06S.
              Otherwise, go to WTM_Q07A.

WTM_Q06S      INTERVIEWER: Specify.

              ________________________
              (80 spaces)
              DK, R

WTM_Q07A      How long did you have to wait between when [you and your doctor decided that
WTME_07A      you should see a specialist/you and your health care provider decided that you
              should see a specialist/the appointment was initially scheduled] and when you
              actually visited the specialist?
              INTERVIEWER: Probe to get the most precise answer possible.

              |_|_|_| (3 spaces)
              (MIN:1) (MAX: 365)
              DK, R                   (Go to WTM_Q10)

Note:         If WTM_Q03 = 1 or 2, use “you and your doctor decided that you should see a specialist”.
              If WTM_Q03 = 3, use “you and your health care provider decided that you should see a
              specialist”.
              Otherwise, use “the appointment was initially scheduled”.
WTM_N07B      INTERVIEWER: Enter unit of time.
WTME_07B
              1       Days
              2       Weeks
              3       Months
                      (DK, R are not allowed)

WTM_E07B      An unusual number has been entered. Please confirm.

              Trigger soft edit if (WTM_Q07A > 31 and WTM_N07B = 1) or (WTM_Q07A > 12 and
              WTM_N07B = 2) or (WTM_Q07A > 18 and WTM_N07B=3).

              Go to WTM_Q10

WTM_Q08A      How long have you been waiting since [you and your doctor decided that you
WTME_08A      should see a specialist/you and your health care provider decided that you should
              see a specialist/the appointment was initially scheduled]?
              INTERVIEWER: Probe to get the most precise answer possible.

              |_|_|_| (3 spaces)
              (MIN:1) (MAX: 365)
              DK, R                   (Go to WTM_Q10)

Note:         If WTM_Q03 = 1 or 2, use “you and your doctor decided that you should see a specialist”.
              If WTM_Q03 = 3, use “you and your health care provider decided that you should see a
              specialist”.
              Otherwise, use “the appointment was initially scheduled”.




Statistics Canada                                                                                 233
Canadian Community Health Survey - Cycle 3.1

WTM_N08B     INTERVIEWER: Enter unit of time.
WTME_08B
             1      Days
             2      Weeks
             3      Months
                    (DK, R are not allowed)

WTM_E08B     An unusual number has been entered. Please confirm.

             Trigger soft edit if (WTM_Q08A > 31 and WTM_N08B = 1) or (WTM_Q08A > 12 and
             WTM_N08B = 2), or (WTM_Q08A > 18 and WTM_N08B = 3).

WTM_Q10      In your view, [was the waiting time / has the waiting time been]:
WTME_10      INTERVIEWER: Read categories to respondent. It is important to make a distinction
             between “No view” and “Don’t Know”.

             1      … acceptable?             (Go to WTM_Q12)
             2      … not acceptable?
             3      No view
                    DK, R

Note:        If WTM_Q04 = 1, use “was the waiting time”.
             Otherwise, use “has the waiting time been”.

WTM_Q11A     In this particular case, what do you think is an acceptable waiting time?
WTME_11A
             |_|_|_| (3 spaces)
             (MIN:1) (MAX: 365)
             DK, R                  (Go to WTM_Q12)

WTM_N11B     INTERVIEWER: Enter unit of time.
WTME_11B
             1      Days
             2      Weeks
             3      Months
                    (DK, R are not allowed)

WTM_E11B     An unusual number has been entered. Please confirm.

             Trigger soft edit if (WTM_Q11A > 31 and WTM_N11B = 1) or (WTM_Q11A > 12 and
             WTM_N11B = 2) or (WTM_Q11A > 18 and WTM_N11B=3).

WTM_Q12      Was your visit cancelled or postponed at any time?
WTME_12
             1      Yes
             2      No              (Go to WTM_Q14)
                    DK, R           (Go to WTM_Q14)




234                                                                             Statistics Canada
                                                    Canadian Community Health Survey - Cycle 3.1

WTM_Q13       Was it cancelled or postponed by:
              INTERVIEWER: Read categories to respondent. Mark all that apply.

WTME_13A      1      … yourself?
WTME_13B      2      … the specialist?
WTME_13C      3      Other - Specify
                     DK, R

WTM_C13S      If WTM_Q13 = 3, go to WTM_Q13S.
              Otherwise, go to WTM_Q14.

WTM_Q13S      INTERVIEWER: Specify.

              ________________________
              (80 spaces)
              DK, R

WTM_Q14       Do you think that your health, or other aspects of your life, have been affected in
WTME_14       any way because you had to wait for this visit?

              1      Yes
              2      No               (Go to WTM_C16)
                     DK, R            (Go to WTM_C16)

WTM_Q15       How was your life affected as a result of waiting for this visit?
              INTERVIEWER: Mark all that apply.

WTME_15A      1      Worry, anxiety, stress
WTME_15B      2      Worry or stress for family or friends
WTME_15C      3      Pain
WTME_15D      4      Problems with activities of daily living (e.g., dressing, driving)
WTME_15E      5      Loss of work
WTME_15F      6      Loss of income
WTME_15G      7      Increased dependence on relatives/friends
WTME_15H      8      Increased use of over-the-counter drugs
WTME_15I      9      Overall health deteriorated, condition got worse
WTME_15J      10     Health problem improved
WTME_15K      11     Personal relationships suffered
WTME_15L      12     Other - Specify
                     DK, R

WTM_C15S      If WTM_Q15 = 12, go to WTM_Q15S.
              Otherwise, go to WTM_C16.

WTM_Q15S      INTERVIEWER: Specify.

              ________________________
              (80 spaces)
              DK, R

WTM_C16       If ACC_Q20 = 2 (did not require non-emergency surgery), go to WTM_C30.
              Otherwise, go to WTM_Q16.




Statistics Canada                                                                              235
Canadian Community Health Survey - Cycle 3.1

WTM_Q16      You mentioned that in the past 12 months you required non emergency surgery.
WTME_16
             What type of surgery did you require? If you have had more than one in the past
             12 months, please answer for the most recent surgery.
             INTERVIEWER: Read categories to respondent.

             1      Cardiac surgery
             2      Cancer related surgery
             3      Hip or knee replacement surgery
             4      Cataract or other eye surgery
             5      Hysterectomy (Removal of uterus) / blank]
             6      Removal of gall bladder
             7      Other - Specify
                    DK, R

Note:        If sex = female, use “Hysterectomy (Removal of uterus)” in WTM_Q16, category 5.
             Otherwise, use blank.

WTM_E16      A blank answer has been selected. Please return and correct.

             Trigger hard edit if WTM_Q16 = 5 and sex = male.

WTM_C16S     If WTM_Q16 = 7, go to WTM_Q16S.
             Otherwise, go to WTM_Q17.

WTM_Q16S     INTERVIEWER: Specify.

             ________________________
             (80 spaces)
             DK, R

WTM_Q17      Did you already have this surgery?
WTME_17
             1      Yes
             2      No              (Go to WTM_Q22)
                    DK, R           (Go to WTM_Q22)

WTM_Q18      Did the surgery require an overnight hospital stay?
WTME_18
             1      Yes
             2      No
                    DK, R

WTM_Q19      Did you experience any difficulties getting this surgery?
WTME_19
             1      Yes
             2      No              (Go to WTM_Q21A)
                    DK, R           (Go to WTM_Q21A)




236                                                                             Statistics Canada
                                                 Canadian Community Health Survey - Cycle 3.1

WTM_Q20       What type of difficulties did you experience?
              INTERVIEWER: Mark all that apply. ACC_Q22 asked previously about any difficulties
              experienced getting the surgery you needed. This question (WTM_Q20) refers to
              difficulties experienced for the most recent non emergency surgery.

WTME_20A      1      Difficulty getting an appointment with a surgeon
WTME_20B      2      Difficulty getting a diagnosis
WTME_20C      3      Waited too long - for a diagnostic test
WTME_20D      4      Waited too long - for a hospital bed to become available
WTME_20E      5      Waited too long - for surgery
WTME_20F      6      Service not available - in the area
WTME_20G      7      Transportation - problems
WTME_20H      8      Language - problem
WTME_20I      9      Cost
WTME_20J      10     Personal or family responsibilities
WTME_20K      11     General deterioration of health
WTME_20L      12     Appointment cancelled or deferred by surgeon or hospital
WTME_20M      13     Unable to leave the house because of a health problem
WTME_20N      14     Other - Specify
                     DK, R

WTM_C20S      If WTM_Q20 = 14. go to WTM_Q20S.
              Otherwise, go to WTM_Q21A.

WTM_Q20S      INTERVIEWER: Specify.

              ________________________
              (80 spaces)
              DK, R

WTM_Q21A      How long did you have to wait between when you and the surgeon decided to go
WTME_21A      ahead with surgery and the day of surgery?
              INTERVIEWER: Probe to get the most precise answer possible.

              |_|_|_| (3 spaces)
              (MIN:1) (MAX: 365)
              DK, R                  (Go to WTM_Q24)

WTM_N21B      INTERVIEWER: Enter unit of time.
WTME_21B
              1      Days
              2      Weeks
              3      Months
                     (DK, R are not allowed)

WTM_E21B      An unusual number has been entered. Please confirm.

              Trigger a soft edit if (WTM_Q21A > 31 and WTM_N21B = 1) or (WTM_Q21A > 12 and
              WTM_N21B = 2) or (WTM_Q21A > 18 and WTM_N21B=3).

              Go to WTM_C24




Statistics Canada                                                                             237
Canadian Community Health Survey - Cycle 3.1

WTM_Q22      Will the surgery require an overnight hospital stay?
WTME_22
             1      Yes
             2      No
                    DK, R

WTM_Q23A     How long have you been waiting since you and the surgeon decided to go ahead
WTME_23A     with the surgery?
             INTERVIEWER: Probe to get the most precise answer possible.

             |_|_|_| (3 spaces)
             (MIN:1) (MAX: 365)
             DK, R                  (Go to WTM_Q24)

WTM_N23B     INTERVIEWER: Enter unit of time.
WTME_23B
             1      Days
             2      Weeks
             3      Months
                    (DK, R are not allowed)

WTM_E23B     An unusual number has been entered. Please confirm.

             Trigger soft edit if (WTM_Q23A > 31 and WTM_N23B = 1) or (WTM_Q23A > 12 and
             WTM_N23B = 2) or (WTM_Q23A > 18 and WTM_N23B = 3).

WTM_Q24      In your view, [was the waiting time / has the waiting time been]:
WTME_24      INTERVIEWER: Read categories to respondent. It is important to make a distinction
             between “No view” and “Don’t Know”.

             1      … acceptable?             (Go to WTM_Q26)
             2      … not acceptable?
             3      No view
                    DK, R

Note:        If WTM_Q17 = 1, use “was the waiting time”.
             Otherwise, use “has the waiting time been”.

WTM_Q25A     In this particular case, what do you think is an acceptable waiting time?
WTME_25A
             |_|_|_| (3 spaces)
             (MIN:1) (MAX: 365)
             DK, R                  (Go to WTM_Q26)

WTM_N25B     INTERVIEWER: Enter unit of time.
WTME_25B
             1      Days
             2      Weeks
             3      Months
                    (DK, R are not allowed)

WTM_E25B     An unusual number has been entered. Please confirm.

             Trigger soft edit if (WTM_Q25A > 31 and WTM_N25B = 1) or (WTM_Q25A > 12 and
             WTM_N25B = 2) or (WTM_Q25A > 18 and WTM_N25B=3).




238                                                                             Statistics Canada
                                                    Canadian Community Health Survey - Cycle 3.1

WTM_Q26       Was your surgery cancelled or postponed at any time?
WTME_26
              1      Yes
              2      No               (Go to WTM_Q28)
                     DK, R            (Go to WTM_Q28)

WTM_Q27       Was it cancelled or postponed by:
              INTERVIEWER: Read categories to respondent. Mark all that apply.

WTME_27A      1      … yourself?
WTME_27B      2      … the surgeon?
WTME_27C      3      … the hospital?
WTME_27D      4      Other - Specify
                     DK, R

WTM_C27S      If WTM_Q27 = 4, go to WTM_Q27S.
              Otherwise, go to WTM_Q28.

WTM_Q27S      INTERVIEWER: Specify.

              ________________________
              (80 spaces)
              DK, R

WTM_Q28       Do you think that your health, or other aspects of your life, have been affected
WTME_28       in any way due to waiting for this surgery?

              1      Yes
              2      No               (Go to WTM_C30)
                     DK, R            (Go to WTM_C30)

WTM_Q29       How was your life affected as a result of waiting for surgery?
              INTERVIEWER: Mark all that apply.

WTME_29A      1      Worry, anxiety, stress
WTME_29B      2      Worry or stress for family or friends
WTME_29C      3      Pain
WTME_29D      4      Problems with activities of daily living (e.g., dressing, driving)
WTME_29E      5      Loss of work
WTME_29F      6      Loss of income
WTME_29G      7      Increased dependence on relatives/friends
WTME_29H      8      Increased use of over-the-counter drugs
WTME_29I      9      Overall health deteriorated, condition got worse
WTME_29J      10     Health problem improved
WTME_29K      11     Personal relationships suffered
WTME_29L      12     Other - Specify
                     DK, R

WTM_C29S      If WTM_Q29 = 12 go to WTM_Q29S.
              Otherwise, go to WTM_C30.

WTM_Q29S      INTERVIEWER: Specify.

              ________________________
              (80 spaces)
              DK, R


Statistics Canada                                                                                239
Canadian Community Health Survey - Cycle 3.1

WTM_C30      If ACC_Q30 = 2 (did not require tests), go to WTM_END.
             Otherwise, go to WTM_Q30.

WTM_Q30      Now for MRIs, CAT Scans and angiographies provided in a non emergency
WTME_30      situation.

             You mentioned that in the past 12 months you required one of these tests.

             What type of test did you require?

             If you have had more than one in the past 12 months, please answer for the most
             recent test.
             INTERVIEWER: Read categories to respondent.

             1      MRI
             2      CAT Scan
             3      Angiography
                    DK, R

WTM_Q31      For what type of condition?
WTME_31      INTERVIEWER: Read categories to respondent.
             1      Heart disease or stroke
             2      Cancer
             3      Joints or fractures
             4      Neurological or brain disorders (e.g., for MS, migraine or headaches)
             5      Other - Specify
                    DK, R

WTM_C31S     If WTM_Q31 = 5, go to WTM_Q31S.
             Otherwise, go to WTM_Q32.

WTM_Q31S     INTERVIEWER: Specify.

             ________________________
             (80 spaces)
             DK, R

WTM_Q32      Did you already have this test?
WTME_32
             1      Yes
             2      No                (Go to WTM_Q39A)
                    DK, R             (Go to WTM_Q39A)

WTM_Q33      Where was the test done?
WTME_33      INTERVIEWER: Read categories to respondent.

             1      Hospital                (Go to WTM_Q35)
             2      Public clinic           (Go to WTM_Q35)
             3      Private clinic          (Go to WTM_Q34)
             4      Other - Specify         (Go to WTM_C33S)
                    DK, R                   (Go to WTM_Q36)




240                                                                           Statistics Canada
                                                 Canadian Community Health Survey - Cycle 3.1

WTM_C33S      If WTM_Q33 = 4, go to WTM_Q33S.
              Otherwise, go to WTM_Q34.

WTM_Q33S      INTERVIEWER: Specify.

              ________________________
              (80 spaces)
              DK, R

              Go to WTM_Q35

WTM_Q34       Was the clinic located:
WTME_34       INTERVIEWER: Read categories to respondent.

              1      … in your province?
              2      … in another province?
              3      Other – Specify
                     DK, R

WTM_C34S      If WTM_Q34 = 3, go to WTM_Q34S.
              Otherwise, go to WTM_Q35.

WTM_Q34S      INTERVIEWER: Specify.

              ________________________
              (80 spaces)
              DK, R

WTM_Q35       Were you a patient in a hospital at the time of the test?
WTME_35
              1      Yes
              2      No
                     DK, R

WTM_Q36       Did you experience any difficulties getting this test?
WTME_36
              1      Yes
              2      No              (Go to WTM_Q38A)
                     DK, R           (Go to WTM_Q38A)




Statistics Canada                                                                        241
Canadian Community Health Survey - Cycle 3.1

WTM_Q37      What type of difficulties did you experience?
             INTERVIEWER: Mark all that apply. ACC_Q32 asked previously about any difficulties
             experienced getting the tests you needed. This question (WTM_Q37) refers to difficulties
             experienced for the most recent diagnostic test.

WTME_37A     1       Difficulty getting a referral
WTME_37B     2       Difficulty getting an appointment
WTME_37C     3       Waited too long - to get an appointment
WTME_37D     4       Waited too long - to get test (i.e. in-office waiting)
WTME_37E     5       Service not available - at time required
WTME_37F     6       Service not available - in the area
WTME_37G     7       Transportation - problems
WTME_37H     8       Language - problem
WTME_37I     9       Cost
WTME_37J     10      General deterioration of health
WTME_37K     11      Did not know where to go (i.e. information problems)
WTME_37L     12      Unable to leave the house because of a health problem
WTME_37M     13      Other - Specify
                     DK, R

WTM_C37S     If WTM_Q37 = 13, go to WTM_Q37S.
             Otherwise, go to WTM_Q38A.

WTM_Q37S     INTERVIEWER: Specify.

             ________________________
             (80 spaces)
             DK, R

WTM_Q38A     How long did you have to wait between when you and your doctor decided
WTME_38A     to go ahead with the test and the day of the test?
             INTERVIEWER: Probe to get the most precise answer possible.

             |_|_|_| (3 spaces)
             (MIN:1) (MAX: 365)
             DK, R                   (Go to WTM_C40)

WTM_N38B     INTERVIEWER: Enter unit of time.
WTME_38B
             1       Days
             2       Weeks
             3       Months
                     (DK, R are not allowed)

WTM_E38B     An unusual number has been entered. Please confirm.

             Trigger soft edit if (WTM_Q38A > 31 and WTM_N38B = 1) or (WTM_Q38A > 12 and
             WTM_N38B = 2) or (WTM_Q38A > 18 and WTM_N38B=3).

             Go to WTM_C40




242                                                                               Statistics Canada
                                                  Canadian Community Health Survey - Cycle 3.1

WTM_Q39A      How long have you been waiting for the test since you and your doctor decided
WTME_39A      to go ahead with the test?
              INTERVIEWER: Probe to get the most precise answer possible.

              |_|_|_| (3 spaces)
              (MIN:1) (MAX: 365)
              DK, R                            (Go to WTM_C40)

WTM_N39B      INTERVIEWER: Enter unit of time.
WTME_39B
              1      Days
              2      Weeks
              3      Months
                     (DK, R are not allowed)

WTM_E39B      An unusual number has been entered. Please confirm.

              Trigger soft edit if (WTM_Q39A > 31 and WTM_N39B = 1) or (WTM_Q39A > 12 and
              WTM_N39 = 2) or (WTM_Q39A > 18 and WTM_N39B= 3).

WTM_Q40       In your view, [was the waiting time / has the waiting time been]:
WTME_40       INTERVIEWER: Read categories to respondent. It is important to make a distinction
              between “No view” and “Don’t Know”.

              1      … acceptable?             (Go to WTM_Q42)
              2      … not acceptable?
              3      No view
                     DK, R

Note:         If WTM_Q32 = 1, use “was the waiting time”.
              Otherwise, use “has the waiting time been”.

WTM_Q41A      In this particular case, what do you think is an acceptable waiting time?
WTME_41A
              |_|_|_| (3 spaces)
              (MIN:1) (MAX: 365)
              DK, R                  (Go to WTM_Q42)

WTM_N41B      INTERVIEWER: Enter unit of time.
WTME_41B
              1      Days
              2      Weeks
              3      Months
                     (DK, R are not allowed)

WTM_E41B      An unusual number has been entered. Please confirm.

              Trigger soft edit if (WTM_Q41A > 31 and WTM_N41B = 1) or (WTM_Q41A > 12 and
              WTM_N41B = 2) or (WTM_Q41A > 18 and WTM_N41B=3).




Statistics Canada                                                                                 243
Canadian Community Health Survey - Cycle 3.1

WTM_Q42      Was your test cancelled or postponed at any time?
WTME_42
             1      Yes
             2      No               (Go to WTM_Q44)
                    DK, R            (Go to WTM_Q44)

WTM_Q43      Was it cancelled or postponed by:
WTME_43      INTERVIEWER: Read categories to respondent.

             1      … yourself?
             2      … the specialist?
             3      … the hospital?
             4      … the clinic?
             5      Other - Specify
                    DK, R

WTM_C43S     If WTM_Q43 = 5, go to WTM_Q43S.
             Otherwise, go to WTM_Q44.

WTM_Q43S     INTERVIEWER: Specify.

             _____________________
             (80 spaces)
             DK, R

WTM_Q44      Do you think that your health, or other aspects of your life, have been affected
WTME_44      in any way due to waiting for this test?

             1      Yes
             2      No               (Go to WTM_END)
                    DK, R            (Go to WTM_END)

WTM_Q45      How was your life affected as a result of waiting for this test?
             INTERVIEWER: Mark all that apply.

WTME_45A     1      Worry, anxiety, stress
WTME_45B     2      Worry or stress for family or friends
WTME_45C     3      Pain
WTME_45D     4      Problems with activities of daily living (e.g., dressing, driving)
WTME_45E     5      Loss of work
WTME_45F     6      Loss of income
WTME_45G     7      Increased dependence on relatives/friends
WTME_45H     8      Increased use of over-the-counter drugs
WTME_45I     9      Overall health deteriorated, condition got worse
WTME_45J     10     Health problem improved
WTME_45K     11     Personal relationships suffered
WTME_45L     12     Other - Specify
                    DK, R




244                                                                                      Statistics Canada
                                             Canadian Community Health Survey - Cycle 3.1

WTM_C45S      If WTM_Q45 = 12, go to WTM_Q45S.
              Otherwise, go to WTM_END.

WTM_Q45S      INTERVIEWER: Specify.

              _________________________
              (80 spaces)
              DK, R

WTM_END




Statistics Canada                                                                    245
Canadian Community Health Survey - Cycle 3.1



MEASURED HEIGHT AND WEIGHT (MHW)
MHW_BEG

Note:        This module is collected as part of a subsample only.

MHW_C01A     If (do MHW block =1), go to MHW_C01B.
             Otherwise, go to MHW_END.

MHW_C01B     If proxy interview, go to MHW_END.
             Otherwise, go to MHW_C01C.

MHW_C01C     If area frame, go to MHW_N1A.
             Otherwise, go to MHW_END.

MHW_N1A      INTERVIEWER: Are there any reasons that make it impossible to measure the
MHWZ_N1      respondent’s weight?

             1       Yes
             2       No      (Go to MHW_R2)
                     (DK, R not allowed)

MHW_N1B      INTERVIEWER: Select reasons why it is impossible to measure the respondent’s weight.
             Mark all that apply.

MHWZ_N1A     1       Unable to stand unassisted         (go to MHW_END)
MHWZ_N1B     2       In a wheel chair                   (go to MHW_END)
MHWZ_N1C     3       Bedridden                          (go to MHW_END)
MHWZ_N1D     4       Interview setting (e.g., interview outdoors or in a public place)
MHWZ_N1E     5       Safety concerns
MHWZ_N1F     6       Has already refused to be measured
MHWZ_N1G     7       Other – Specify
                     (DK, R not allowed)

MHW_C1C      If MHW_N1B = 7, go to MHW_S1B.
             Otherwise, go to MHW_N5A.

MHW_S1B      INTERVIEWER: Specify.

             ______________________
             (80 spaces)
             (DK, R not allowed)

             Go to MHW_N5A

MHW_R2       A person’s size is important in understanding health. Because of this, I would like
             to measure your height and weight. The measurements taken will not require any
             touching.
             INTERVIEWER: Press <Enter> to continue.




246                                                                                      Statistics Canada
                                                  Canadian Community Health Survey - Cycle 3.1

MHW_Q2A       Do I have your permission to measure your weight?
MHWZ_2
              1       Yes
              2       No      (Go to MHW_N5A)
                      (DK, R not allowed)

MHW_N2A       INTERVIEWER: Record weight to the nearest 0.01 kg. If the scale does not work, or if for
MHWZ_N2A      some other reason you cannot weigh the respondent, enter DK.

              |_|_|_|.|_|_| kilograms
              (MIN: 1.00; warning under 27.00 kg.) (MAX: 261.00; warning above 136.00 kg)
              DK        (Go to MSW_N4)
              (R not allowed)

MHW_N3A       INTERVIEWER: Were there any articles of clothing or physical characteristics which
MHWZ_N3       affected the accuracy of this measurement?

              1       Yes
              2       No      (Go to MHW_N5A)
                      (DK, R not allowed)

MHW_N3B       INTERVIEWER: Select reasons affecting accuracy. Mark all that apply.

MHWZ_N3A      1       Shoes or boots
MHWZ_N3B      2       Heavy sweater or jacket
MHWZ_N3C      3       Jewellery
MHWZ_N3D      4       Other - Specify
                      (DK, R not allowed)

MHW_C3B       If MHW_N3B = 4, go to MHW_S3B.
              Otherwise, go to MHW_N5A.

MHW_S3B       INTERVIEWER: Specify.

              ______________________
              (80 spaces)
              (DK, R not allowed)

              Go to MSW_N5A




Statistics Canada                                                                                  247
Canadian Community Health Survey - Cycle 3.1

MHW_N4       INTERVIEWER: Select the reason for not weighing the respondent.
MHWZ_N4
             1      Scale not functioning properly    (go to MHW_N5A)
             2      Other – Specify
                    (DK, R not allowed)

MHW_C4       If MHW_N4 = 2, go to MHW_S4.
             Otherwise, go to MHW_N5A.

MHW_S4       INTERVIEWER: Specify.

             _____________________
             (80 spaces)
             (DK, R not allowed)

MHW_N5A      INTERVIEWER: Are there any reasons that make it impossible to measure the
MHWZ_N5      respondent’s height?

             1      Yes
             2      No      (Go to MHW_C6)
                    (DK, R not allowed)

MHW_N5B      INTERVIEWER: Select reasons why it is impossible to measure the respondent’s height.
             Mark all that apply.

MHWZ_N5A     1      Too tall
MHWZ_N5B     2      Interview setting (e.g., interview outdoors or in a public place)
MHWZ_N5C     3      Safety concerns
MHWZ_N5D     4      Has already refused to be measured
MHWZ_N5E     5      Other – Specify
                    (DK, R not allowed)

MHW_C5B      If MHW_N5B = 5, go to MHW_S5B.
             Otherwise, go to MHW_ END.

MHW_S5B      INTERVIEWER: Specify.

             _______________________
             (80 spaces)
             (DK, R not allowed)

             Go to MHW_END

MHW_C6       If MHW_N1A = 2, go to MHW_Q6A.
             Otherwise, go to MHW_R6.

MHW_R6       A person’s size is important in understanding health. Because of this, I would like
             to measure your height. The measurement will not require any touching.
             INTERVIEWER: Press <Enter> to continue.




248                                                                                     Statistics Canada
                                                  Canadian Community Health Survey - Cycle 3.1

MHW_Q6A       Do I have your permission to measure your height?
MHWZ_6
              1      Yes
              2      No      (Go to MHW_END)
                     (DK, R not allowed)

MHW_N6B       INTERVIEWER: Enter height to nearest 0.5 cm.
MHWZ_N6
              |_|_|_|.|_|
              (MIN: 90.0 cm) (MAX: 250.0 cm)
              DK, R (Go to MHW_ END)

MHW_N7A       INTERVIEWER: Were there any articles of clothing or physical characteristics
MHWZ_N7       which affected the accuracy of this measurement?

              1      Yes
              2      No      (Go to MHW_END)
                     (DK, R not allowed)

MHW_N7B       INTERVIEWER: Select reasons affecting accuracy. Mark all that apply.

MHWZ_N7A      1      Shoes or boots
MHWZ_N7B      2      Hairstyle
MHWZ_N7C      3      Hat
MHWZ_N7D      4      Other - Specify
                     (DK, R not allowed)

MHW_C7B       If MHW_N7B = 4, go to MHW_S7B.
              Otherwise, go to MHW_END.

MHW_S7B       INTERVIEWER: Specify.

              ______________________
              (80 spaces)
              (DK, R not allowed)

MHW_END




Statistics Canada                                                                            249
Canadian Community Health Survey - Cycle 3.1



LABOUR FORCE (LBF)
LBF_BEG

Note:            This module was only collected as part of a sub-sample only.

LBF_C01          If (do LBF block = 1), go to LBF_C02.
                 Otherwise, go to LBF_END.

LBF_C02          If age < 15 or age > 75, go to LBF_END.
                 Otherwise, go to LBF_QINT.

LBF_QINT         The next few questions concern ^YOUR2 activities in the last 7 days. By the last
                 7 days, I mean beginning [date one week ago], and ending [date yesterday].
                 INTERVIEWER: Press <Enter> to continue.

Job Attachment

LBF_Q01          Last week, did ^YOU2 work at a job or a business? Please include part-time
LBFZ_01          jobs, seasonal work, contract work, self-employment, baby-sitting and any other
                 paid work, regardless of the number of hours worked.

                 1       Yes                               (Go to LBF_Q03)
                 2       No
                 3       Permanently unable to work        (Go to LBF_QINT2)
                         DK, R                             (Go to LBF_END)

LBF_E01          A response inconsistent with a response to a previous question has been entered.
                 Please confirm.

                 Trigger soft edit if GEN_Q08 = 2 and LBF_Q01 = 1.

LBF_Q02          Last week, did ^YOU2 have a job or business from which ^YOU1 ^WERE absent?
LBFZ_02
                 1       Yes
                 2       No              (Go to LBF_Q11)
                         DK, R           (Go to LBF_END)

LBF_Q03          Did ^YOU1 have more than one job or business last week?
LBFZ_03
                 1       Yes
                 2       No
                         DK, R

                 Go to LBF_C31




250                                                                                  Statistics Canada
                                                    Canadian Community Health Survey - Cycle 3.1

Job Search – Last 4 Weeks

LBF_Q11       In the past 4 weeks, did ^YOU2 do anything to find work?
LBFZ_11
              1       Yes              (Go to LBF_QINT2)
              2       No
                      DK, R            (Go to LBF_QINT2)

LBF_Q13       What is the main reason that ^YOU1 ^ARE not currently working at a job or
LBFZ_13       business?

              1       Own illness or disability
              2       Caring for - own children
              3       Caring for - elder relatives
              4       Pregnancy (Females only)
              5       Other personal or family responsibilities
              6       Vacation
              7       School or educational leave
              8       Retired
              9       Believes no work available (in area or suited to skills)
              10      Other - Specify
                      DK, R

LBF_C13S      If LBF_Q13 = 10, go to LBF_Q13S.
              Otherwise, go to LBF_C13.

LBF_Q13S      INTERVIEWER: Specify.

              ________________________
              (80 spaces)
              DK, R

LBF_E13       A response of “Pregnancy” is invalid for a male respondent.
              Please return and correct.

              Trigger hard edit if sex = male and LBF_Q13 = 4.

LBF_C13A      If LBF_Q13 = 1 (Own illness or disability), go to LBF_Q13A.
              Otherwise, go to LBF_QINT2.

LBF_Q13A      Is this due to ^YOUR1 physical health, to ^YOUR1 emotional or mental
LBFZ_13A      health, to ^YOUR1 use of alcohol or drugs, or to another reason?

              1       Physical health
              2       Emotional or mental health (including stress)
              3       Use of alcohol or drugs
              4       Another reason
                      DK, R




Statistics Canada                                                                           251
Canadian Community Health Survey - Cycle 3.1

Past Job Attachment

LBF_QINT2     Now some questions about jobs or employment which ^YOU2 ^HAVE had during
              the past 12 months, that is, from [date one year ago] to yesterday.
              INTERVIEWER: Press <Enter> to continue.

LBF_Q21       Did ^YOU1 work at a job or a business at any time in the past 12 months?
LBFZ_21       Please include part-time jobs, seasonal work, contract work, self-employment,
              baby-sitting and any other paid work, regardless of the number of hours worked.

              1       Yes            (Go to LBF_Q23)
              2       No
                      DK, R

LBF_E21       A response inconsistent with a response to a previous question has been entered.
              Please confirm.

              Trigger soft edit if (GEN_Q08 = 2 and LBF_Q21 = 1) or (GEN_Q08 = 1 and
              LBF_Q21 = 2).

LBF_C22       If LBF_Q11 = 1, go to LBF_Q71.
              Otherwise, go to LBF_Q22.

LBF_Q22       During the past 12 months, did ^YOU1 do anything to find work?
LBFZ_22
              1       Yes            (Go to LBF_Q71)
              2       No             (Go to LBF_END)
                      DK, R          (Go to LBF_END)

LBF_Q23       During that 12 months, did ^YOU1 work at more than one job or business at
LBFZ_23       the same time?

              1       Yes
              2       No
                      DK, R




252                                                                               Statistics Canada
                                                     Canadian Community Health Survey - Cycle 3.1

Occupation, Smoking Restrictions at Work

Note:          If LBF_Q01 = 1 or LBF_Q02 = 1, then the following questions will be asked about the
               current job. Otherwise, they will be asked about the most recent job.

LBF_QINT3      The next questions are about ^YOUR2 [current/most recent] job or business.
               (If person currently holds more than one job or if the last time he/she worked it was at
               more than one job: [INTERVIEWER: Report on the job for which the number of hours
               worked per week is the greatest.])

               INTERVIEWER: Press <Enter> to continue.

Note:          If LBF_Q03 = 1 or LBF_Q23 = 1, then the interviewer instructions in LBF_QINT3 should
               appear as:

               INTERVIEWER: Report on the job for which the number of hours worked per week is the
               greatest.

               INTERVIEWER: Press <Enter> to continue.

               Otherwise, the instruction should appear as:

               INTERVIEWER: Press <Enter> to continue.

LBF_Q31        [Are/Were/Is/Was] ^YOU1 an employee or self-employed?
LBFZ_31
               1       Employee                                          (Go to LBF_Q33)
               2       Self-employed
               3       Working in a family business without pay          (Go to LBF_Q33)
                       DK, R                                             (Go to LBF_Q33)

Note:          If non-proxy interview and (LBF_Q01 = 1 or LBF_Q02 = 1), use “are”.
               If non-proxy interview and not (LBF_Q01 = 1 or LBF_Q02 = 1), use “were”.
               If proxy interview and (LBF_Q01 = 1 or LBF_Q02 = 1), use “is”.
               If proxy interview and not (LBF_Q01 = 1 or LBF_Q02 = 1), use “was”.




Statistics Canada                                                                                     253
Canadian Community Health Survey - Cycle 3.1

LBF_Q31A     [Do/Does/Did] ^YOU1 have any employees?
LBFZ_31A
             1      Yes
             2      No
                    DK, R

Note:        If non-proxy interview and (LBF_Q01 = 1 or LBF_Q02 = 1), use “Do”.
             If proxy interview and (LBF_Q01 = 1 or LBF_Q02 = 1), use “Does”.
             Otherwise, use “Did”.

LBF_Q32      What [is/was] the name of ^YOUR1 business?

LBFZF32      ________________
             (50 spaces)
             DK, R

             Go to LBF_Q34

Note:        If LBF_Q01 = 1 or LBF_Q02 = 1, use “is”.
             Otherwise, use “was”.

LBF_Q33      For whom [do/does/did] ^YOU1 [currently/last] work? (For example: name of
             business, government department or agency, or person)

LBFZF33      ________________________
             (50 spaces)
             DK, R

Note:        If non-proxy interview and (LBF_Q01 = 1 or LBF_Q02 = 1), use “do”.
             If proxy interview and (LBF_Q01 = 1 or LBF_Q02 = 1), use “does”
             Otherwise, use “did”.

             If LBF_Q01 = 1 or LBF_Q02 = 1, use “currently”.
             Otherwise, use “last”.

LBF_Q34      What kind of business, industry or service [is/was] this? (For example: cardboard
             box manufacturing, road maintenance, retail shoe store, secondary school, dairy
             farm, municipal government)

LBFZF34      ________________________
             (50 spaces)
             DK, R

Note:        If LBF_Q01 = 1 or LBF_Q02 = 1, use “is”.
             Otherwise, use “was”.




254                                                                               Statistics Canada
                                                 Canadian Community Health Survey - Cycle 3.1

LBF_Q35       What kind of work [is/was] ^YOU1 doing? (For example: babysitting in own home,
              factory worker, forestry technician)

LBFZF35       _______________________
              (50 spaces)
              DK, R

Note:         If LBF_Q01 = 1 or LBF_Q02 = 1, use “is”.
              Otherwise, use “was”.

              Note: Use trigram search.

LBF_D35       SIC_CODE (4 bytes)
LBFZCNIC
LBFZCSOC      Note: Store SOC Code associated with LBF_Q35

LBF_C35       If LBF_D35 = 1 OR LBF_D35 = 2 (OtherSpec), go to LBF_S35.
              Otherwise, go to LBF_Q36.

LBF_S35       INTERVIEWER: Specify.

LBFZF35S      ______________________
              (50 spaces)
              DK, R

LBF_Q36       What [are/were] ^YOUR1 most important activities or duties? (For
              example: caring for children, stamp press machine operator, forest examiner)

LBFZF36       ________________________
              (50 spaces)
              DK, R

Note:         If LBF_Q01 = 1 or LBF_Q02 = 1, “are”.
              Otherwise, use “were”.

LBF_Q36A      [Is/Was] ^YOUR1 job permanent, or is there some way that it [is/was] not
LBFZ_36A      permanent? (e.g., seasonal, temporary, term, casual)

              1      Permanent     (Go to LBF_Q37)
              2      Not permanent
                     DK, R         (Go to LBF_Q37)

Note:         If LBF_Q01 = 1 or LBF_Q02 = 1, use “is”.
              Otherwise, use “was”.




Statistics Canada                                                                            255
Canadian Community Health Survey - Cycle 3.1

LBF_Q36B      In what way [is/was] ^YOUR1 job not permanent?
LBFZ_36B
              1      Seasonal
              2      Temporary, term or contract
              3      Casual job
              4      Work done through a temporary help agency
              5      Other
                     DK, R

Note:         If LBF_Q01 = 1 or LBF_Q02 = 1, use “is”.
              Otherwise, use “was”.

LBF_Q37       At ^YOUR1 place of work, what [are/were] the restrictions on smoking?
ETSZ_7        INTERVIEWER: Read categories to respondent.

              1      Restricted completely
              2      Allowed in designated areas
              3      Restricted only in certain places
              4      Not restricted at all
                     DK, R

Note:         If LBF_Q01 = 1 or LBF_Q02 = 1, use “are”.
              Otherwise, use “were”.

              The data from this variable can be found under the Exposure to Second Hand Smoke
              (ETS) in the data dictionary.

Absence / Hours

LBF_C41       If LBF_Q02 = 1, go to LBF_Q41.
              Otherwise, go to LBF_Q42.

LBF_Q41       What was the main reason ^YOU2 ^WERE absent from work last week?
LBFZ_41
              1      Own illness or disability
              2      Caring for - own children
              3      Caring for - elder relatives
              4      Maternity leave (Females only)
              5      Other personal or family responsibilities
              6      Vacation
              7      Labour dispute (strike or lockout)
              8      Temporary layoff due to business conditions (Employees only)
              9      Seasonal layoff (Employees only)
              10     Casual job, no work available (Employees only)
              11     Work schedule (e.g., shift work) (Employees only)
              12     Self-employed, no work available (Self-employed only)
              13     Seasonal business (Excluding employees)
              14     School or educational leave
              15     Other - Specify
                     DK, R




256                                                                             Statistics Canada
                                                   Canadian Community Health Survey - Cycle 3.1

LBF_C41S      If LBF_Q41 = 15, go to LBF_Q41S.
              Otherwise, go to LBF_C41A_1.

LBF_Q41S      INTERVIEWER: Specify.

              ________________________
              (80 spaces)
              DK, R

LBF_E41A      A response of “Maternity Leave” is invalid for a male respondent.
              Please return and correct.

              Trigger hard edit if sex = male and LBF_Q13 = 4.

              Go to LBF_C41A_1

LBF_E41B      A response of “Self-employed, no work available” or “Seasonal Business” is
              invalid for an employee. Please return and correct.

              Trigger hard edit if LBF_Q31 = 1 and LBF_Q41 = 12 or 13.

              Go to LBF_C41A_1

LBF_E41C      A response of “Temporary layoff due to business conditions”, “Seasonal layoff”,
              “Casual job, no work available” or “Work schedule” is invalid for a self-employed
              person. Please return and correct.

              Trigger hard edit if LBF_Q31 = 2 and LBF_Q41 = 8, 9, 10 or 11.

              Go to LBF_C41A_1

LBF_E41D      A response of “Temporary layoff due to business conditions”, “Seasonal layoff”,
              “Casual job, no work available”, “Work schedule” or “Self-employed, no work
              available” is invalid for a person working in a family business without pay.
              Please return and correct.

              Trigger hard edit If LBF_Q31 = 3 and LBF_Q41 = 8, 9, 10, 11 or 12.

              Go to LBF_C41A_1

LBF_C41A_1    If LBF_Q41 = 1 (Own illness or disability), go to LBF_Q41A.
              Otherwise, go to LBF_Q42.

LBF_Q41A      Was that due to ^YOUR1 physical health, to ^YOUR1 emotional or mental
LBFZ_41A      health, to ^YOUR1 use of alcohol or drugs, or to another reason?

              1       Physical health
              2       Emotional or mental health (including stress)
              3       Use of alcohol or drugs
              4       Another reason
                      DK, R




Statistics Canada                                                                            257
Canadian Community Health Survey - Cycle 3.1

LBF_Q42      About how many hours a week [do/does/did] ^YOU2 usually work at ^YOUR1
LBFZ_42      [job/business]? If ^YOU2 usually [work/works/worked] extra hours, paid or unpaid,
             please include these hours.

             |_|_|_| Hours
             (MIN: 1) (MAX: 168; warning after 84)
             DK, R

Note:        If non-proxy interview and (LBF_Q01 = 1 or LBF_Q02 = 1), use “do” and “work”.
             If proxy interview and (LBF_Q01 = 1 or LBF_Q02 = 1), use “does” and “works”.
             Otherwise, use “did” and “worked”.

             If LBF_Q31 = 1, use “job”.
             Otherwise, use “business”.

LBF_Q44      Which of the following best describes the hours ^YOU2 usually
LBFZ_44      [work/works/worked] at ^YOUR1 [job/business]?
             INTERVIEWER: Read categories to respondent.

             1      Regular - daytime schedule or shift          (Go to LBF_Q46)
             2      Regular - evening shift
             3      Regular - night shift
             4      Rotating shift (change from days to evenings to nights)
             5      Split shift
             6      On call
             7      Irregular schedule
             8      Other - Specify
                    DK, R                                        (Go to LBF_Q46)

Note:        If non-proxy interview and (LBF_Q01 = 1 or LBF_Q02 = 1), use “work”.
             If proxy interview and (LBF_Q01 = 1 or LBF_Q02 = 1), use “works”.
             Otherwise, use “worked”.

             If LBF_Q31 = 1, use “job”.
             Otherwise, use “business”.

LBF_C44S     If LBF_Q44 = 8, go to LBF_Q44S.
             Otherwise, go to LBF_Q45.

LBF_Q44S     INTERVIEWER: Specify.

             ________________________
             (80 spaces)
             DK, R




258                                                                             Statistics Canada
                                                 Canadian Community Health Survey - Cycle 3.1

LBF_Q45       What is the main reason that ^YOU [work/works/worked] this schedule?
LBFZ_45
              1      Requirement of job / no choice
              2      Going to school
              3      Caring for - own children
              4      Caring for - other relatives
              5      To earn more money
              6      Likes to work this schedule
              7      Other - Specify
                     DK, R

Note:         If non-proxy interview and (LBF_Q01 = 1 or LBF_Q02 = 1), use and “work”.
              If proxy interview and (LBF_Q01 = 1 or LBF_Q02 = 1), use “works”.
              Otherwise, use “worked”.

LBF_C45S      If LBF_Q45 = 7, go to LBF_Q45S.
              Otherwise, go to LBF_Q46.

LBF_Q45S      INTERVIEWER: Specify.

              ________________________
              (80 spaces)
              DK, R

LBF_Q46       [Do/Does/Did] ^YOU1 usually work on weekends at this [job/business]?
LBFZ_46
              1      Yes
              2      No
                     DK, R

Note:         If non-proxy interview and (LBF_Q01 = 1 or LBF_Q02 = 1), use “do”.
              If proxy interview and (LBF_Q01 = 1 or LBF_Q02 = 1), use “does”
              Otherwise, use “did”.

              If LBF_Q31 = 1, use “job”.
              Otherwise, use “business”.

Other Job

LBF_C51       If LBF_Q03 = 1 or LBF_Q23=1, go to LBF_Q51.
              Otherwise, go to LBF_Q61.




Statistics Canada                                                                        259
Canadian Community Health Survey - Cycle 3.1

LBF_Q51      You indicated that ^YOU2 [have/has/had] had more than one job. For how many
LBFZ_51      weeks in a row [have/has/had] ^YOU1 [job/business] at more than one job [(in the
             past 12 months)]?
             INTERVIEWER: Obtain best estimate.

             |_|_|   Weeks
             (MIN: 1) (MAX: 52)
             DK, R

Note:        If non-proxy interview and (LBF_Q01 = 1 or LBF_Q02 = 1), use “have”.
             If proxy interview and (LBF_Q01 = 1 or LBF_Q02 = 1), use “has”.
             Otherwise, use “had”.

             If LBF_Q31 = 1, use “job”.
             Otherwise, use “business”.

             If LBF_Q23 = 1, use “in the past 12 months”.
             Otherwise, leave blank.

LBF_Q52      What is the main reason that ^YOU1 [job/business] at more than one job?
LBFZ_52
             1       To meet regular household expenses
             2       To pay off debts
             3       To buy something special
             4       To save for the future
             5       To gain experience
             6       To build up a business
             7       Enjoys the work of the second job
             8       Other - Specify
                     DK, R

Note:        If LBF_Q31 = 1, use “job”.
             Otherwise, use “business”.

LBF_C52S     If LBF_Q52 = 8, go to LBF_Q52S.
             Otherwise, go to LBF_Q53.

LBF_Q52S     INTERVIEWER: Specify.

             ________________________
             (80 spaces)
             DK, R




260                                                                             Statistics Canada
                                                  Canadian Community Health Survey - Cycle 3.1

LBF_Q53        About how many hours a week [do/does/did] ^YOU1 usually work at ^YOUR1 other
LBFZ_53        job(s)? If ^YOU1 usually [work/works/worked] extra hours, paid or unpaid, please
               include these hours.
               INTERVIEWER: Minimum is 1; maximum is [168 - LBF_Q42].

               |_|_|_| Hours
               (MIN: 1) (MAX: 168 - LBF_Q42; warning after 30)
               DK, R

Note:          If LBF_Q42 = 168, then maximum = 1.
               If LBF_Q42 = DK or R, then maximum = 168.

               If non-proxy interview and (LBF_Q01 = 1 or LBF_Q02 = 1), use “do” and “work”.
               If proxy interview and (LBF_Q01 = 1 or LBF_Q02 = 1), use “does” and “works”.
               Otherwise, use “did” and “worked”.

LBF_Q54        [Do/Does/Did] ^YOU1 usually work on weekends at ^YOUR1 other job(s)?
LBFZ_54
               1      Yes
               2      No
                      DK, R

Note:          If LBF_Q01 = 1 or LBF_Q02 = 1 and non-proxy interview, use “do”.
               If LBF_Q01 = 1 or LBF_Q02 = 1 and proxy interview, use “does”
               Otherwise, use “did”.

Weeks Worked

LBF_Q61        During the past 52 weeks, how many weeks did ^YOU2 do any work at a job or
LBFZ_61        a business? (Include paid vacation leave, paid maternity leave, and paid sick
               leave.)

               |_|_|   Weeks
               (MIN: 1) (MAX: 52)
               DK, R




Statistics Canada                                                                              261
Canadian Community Health Survey - Cycle 3.1

Looking For Work

LBF_C71       If LBF_Q61 = 52, go to LBF_END.
              If LBF_Q61 = 51, go to LBF_Q71A.

LBF_Q71       During the past 52 weeks, how many weeks ^WERE ^YOU1 looking for work?
LBFZ_71
              That leaves [52 - LBF_Q61] weeks. During those [52 - LBF_Q61] weeks, how many
              weeks ^WERE ^YOU1 looking for work?
              INTERVIEWER: Minimum is 0; maximum is [52 - LBF_Q61].

              |_|_|   Weeks
              (MIN: 0) (MAX: 52 - LBF_Q61)
              DK, R

              Go to LBF_C72

Note:         If LBF_Q61 was answered, use the second wording. Otherwise, use the first wording.

              If LBF_Q61 = DK or R, max of LBF_Q71 = 52.

LBF_Q71A      That leaves 1 week. During that week, did ^YOU1 look for work?
LBFZ_71A
              1       Yes   (make LBF_Q71 = 1)
              2       No    (make LBF_Q71 = 0)
                      DK, R

LBF_C72       If either LBF_Q61 or LBF_Q71 are non-response, go to LBF_END.
              If the total number of weeks reported in LBF_Q61 and LBF_Q71 = 52, go to LBF_END.

              If LBF_Q61 and LBF_Q71 were answered, [WEEKS] = [52 - (LBF_Q61 + LBF_Q71)].
              If LBF_Q61 was not answered, [WEEKS] = (52 - LBF_Q71).

LBF_Q72       That leaves [WEEKS] week[s] during which ^YOU1 ^WERE neither working
LBFZ_72       nor looking for work. Is that correct?

              1       Yes             (Go to LBF_C73)
              2       No
                      DK, R           (Go to LBF_C73)

LBF_E72       You have indicated that ^YOU1 worked for ^LBF_Q61 week[s] and that ^YOU1
              ^WERE looking for work for ^LBF_Q71 week[s], leaving [WEEKS] week[s] during
              which ^YOU1 ^WERE neither working nor looking for work. The total number of
              weeks must add to 52. Please return and correct.

              Trigger hard edit if LBF_Q72 = 2.




262                                                                              Statistics Canada
                                                    Canadian Community Health Survey - Cycle 3.1

LBF_C73       If (LBF_Q01 = 1 or LBF_Q02 = 1 or LBF_Q11 = 1), go to LBF_Q73.
              Otherwise, go to LBF_END.

LBF_Q73       What is the main reason that ^YOU1 ^WERE not looking for work?
LBFZ_73       INTERVIEWER: If more than one reason, choose the one that explains the most number
              of weeks.

              1       Own illness or disability
              2       Caring for - own children
              3       Caring for - elder relatives
              4       Pregnancy (Females only)
              5       Other personal or family responsibilities
              6       Vacation
              7       Labour dispute (strike or lockout)
              8       Temporary layoff due to business conditions
              9       Seasonal layoff
              10      Casual job, no work available
              11      Work schedule (e.g., shift work)
              12      School or educational leave
              13      Retired
              14      Believes no work available (in area or suited to skills)
              15      Other - Specify

LBF_C73S      If LBF_Q73 = 15, go to LBF_Q73S.
              Otherwise, go to LBF_C73A.

LBF_Q73S      INTERVIEWER: Specify.

              ________________________
              (80 spaces)
              DK, R

LBF_E73       A response of “Pregnancy” is invalid for a male respondent.
              Please return and correct.

              Trigger hard edit if sex = male and LBF_Q13 = 4.

LBF_C73B      If LBF_Q73 = 1 (own illness or disability), go to LBF_Q73A.
              Otherwise, go to LBF_END.

LBF_Q73A      Was that due to ^YOUR1 physical health, to ^YOUR1 emotional or mental
LBFZ_73A      health, to ^YOUR1 use of alcohol or drugs, or to another reason?

              1       Physical health
              2       Emotional or mental health (including stress)
              3       Use of alcohol or drugs
              4       Another reason
                      DK, R

LBF_END




Statistics Canada                                                                            263
Canadian Community Health Survey - Cycle 3.1



LABOUR FORCE – Common Portion (LF2)
LABOUR FORCE (SectLabel)

LF2_BEG

LF2_C1       If (do LBF block = 1) or (m79 = 1), go to LF2_ END. (LBF module included in
             sub-sample)
             Otherwise, go to LF2_ C2.

LF2_C2       If age < 15 or age > 75, go to LF2_END.
             Otherwise, go to LF2_R1.

LF2_R1       The next questions concern ^YOUR2 activities in the last 7 days. By the last
             7 days, I mean beginning [date one week ago], and ending [date yesterday].
             INTERVIEWER: Press <Enter> to continue.

LF2_Q1       Last week, did ^YOU2 work at a job or a business? Please include part-time jobs,
LBSE_01      seasonal work, contract work, self-employment, baby-sitting and any other paid
             work, regardless of the number of hours worked.

             1      Yes                                (Go to LF2_ Q3)
             2      No
             3      Permanently unable to work         (Go to LF2_END)
                    DK, R                              (Go to LF2_END)

             (Question is equivalent to LBF_Q01).

LF2_E1       A response inconsistent with a response to a previous question has been entered.
             Please confirm.

             Trigger soft edit if GEN_Q08 = 2 and LF2_Q1 = 1.

LF2_Q2       Last week, did ^YOU2 have a job or business from which ^YOU1 ^WERE
LBSE_02      absent?

             1      Yes
             2      No              (Go to LF2_Q4)
                    DK, R           (Go to LF2_END)

             (Question is equivalent to LBF_Q02).

LF2_Q3       Did ^YOU1 have more than one job or business last week?
LBSE_03
             1      Yes
             2      No
                    DK, R

             Go to LF2_R5

             (Question is equivalent to LBF_Q03).




264                                                                              Statistics Canada
                                                   Canadian Community Health Survey - Cycle 3.1

LF2_Q4        In the past 4 weeks, did ^YOU2 do anything to find work?
LBSE_11
              1       Yes
              2       No
                      DK, R

              Go to LF2_END

              (Question is equivalent to LBF_Q11).

LF2_R5        The next questions are about ^YOUR1 current job or business.
              INTERVIEWER: If person currently holds more than one job, report on the job for which
              the number of hours worked per week is the greatest.

              Press <Enter> to continue.

LF2_Q5        About how many hours a week ^DOVERB ^YOU1 usually work at ^YOUR1 job or
LBSE_42       business? If ^YOU2 usually [work/works] extra hours, paid or unpaid, please
              include these hours.

              |_|_|_|        Hours
              (MIN: 1) (MAX: 168; warning after 84)
              DK, R

Note:         If LF2_Q1 = 1 or LF2_Q2 = 1 and non-proxy interview, use “work”.
              Otherwise, use “works”.

              (Question is equivalent to LBF_Q42 except that it is asked only of those who currently
              have a job (i.e. those who do not currently have a job but who had a job in the past 12
              months are not included here but they are in the universe of LBF_Q42. Also the question
              text uses the phrase “job or business” rather then a fill because LBF_Q31
              (employee or self-employed) is not in the Common LF2 module.).

LF2_Q6        At ^YOUR1 place of work, what are the restrictions on smoking?
ETSE_7        INTERVIEWER: Read categories to respondent.

              1       Restricted completely
              2       Allowed in designated areas
              3       Restricted only in certain places
              4       Not restricted at all
                      DK, R

              (Question is equivalent to LBF_Q37, except it is for the current job only whereas
              LBF_Q37 is for the current job or the most recent job, (i.e. those who do not currently
              have a job but who had a job in the past 12 months are not included here but they are in
              the universe of LBF_Q37).

Note:         The data from this variable can be found under the Exposure to Second Hand Smoke
              (ETS) in the data dictionary.




Statistics Canada                                                                                  265
Canadian Community Health Survey - Cycle 3.1

LF2_C7       If LF2_Q3=1, go to LF2_Q7.
             Otherwise, go to LF2_END.

LF2_Q7       You indicated that ^YOU2 ^HAVE more than one job.
LBSE_53
             About how many hours a week ^DOVERB ^YOU1 usually work at ^YOUR1 other
             job(s)? If ^YOU2 usually [work/works] extra hours, paid or unpaid, please include
             these hours.
             INTERVIEWER: Minimum is 1; maximum is [168 – LF2_Q5].

             |_|_|_| Hours
             (MIN: 1) (MAX: 168 – LF2_Q5; warning after 30)
             DK, R

Note:        If non-proxy interview and (LF2_Q1 = 1 or LF2_Q2 = 1), use “work”.
             Otherwise, use “works”.

             If LF2_Q5 = 168, then maximum = 1.
             If LF2_Q5 = DK or R, then maximum = 168.

             (Note that this question is equivalent to LBF_Q53 except that again the universe is
             current job holders only).

LF2_END




266                                                                                Statistics Canada
                                                 Canadian Community Health Survey - Cycle 3.1



SOCIO-DEMOGRAPHIC CHARACTERISTICS (SDC)
SDC_BEG

SDC_C1        If (do SDC block = 1), go to SDC_R1.
              Otherwise, go to SDC_END.

SDC_R1        Now some general background questions which will help us compare the health of
              people in Canada.
              INTERVIEWER: Press <Enter> to continue.

SDC_Q1        In what country ^WERE ^YOU1 born?
SDCE_1
              1      Canada        (Go to SDC_Q4)         11     Jamaica
              2      China                                12     Netherlands / Holland
              3      France                               13     Philippines
              4      Germany                              14     Poland
              5      Greece                               15     Portugal
              6      Guyana                               16     United Kingdom
              7      Hong Kong                            17     United States
              8      Hungary                              18     Viet Nam
              9      India                                19     Sri Lanka
              10     Italy                                20     Other - Specify
                     DK, R (Go to SDC_Q4)

SDC_C1S       If SDC_Q1 = 20, go to SDC_Q1S.
              Otherwise, go to SDC_Q2.

SDC_Q1S       INTERVIEWER: Specify.

              ________________________
              (80 spaces)
              DK, R

SDC_Q2        ^WERE_C ^YOU1 born a Canadian citizen?
SDCE_2
              1      Yes             (Go to SDC_Q4)
              2      No
                     DK, R           (Go to SDC_Q4)




Statistics Canada                                                                        267
Canadian Community Health Survey - Cycle 3.1

SDC_Q3       In what year did ^YOU1 first come to Canada to live?
SDCE_3       INTERVIEWER: Minimum is [year of birth]; maximum is [current year].

             |_|_|_|_|        Year
             (MIN: year of birth) (MAX: current year)
             DK, R

SDC_E3       Year must be between ^Info.YearofBirth and ^Info.CurrentYear.

             Trigger hard edit if SDC_Q3 < [year of birth] or SDC_Q3 > [current year].

SDC_Q4       To which ethnic or cultural group(s) did ^YOUR2 ancestors belong? (For
             example: French, Scottish, Chinese, East Indian)
             INTERVIEWER: Mark all that apply. If “Canadian” is the only response, probe. If the
             respondent hesitates, do not suggest Canadian.

SDCE_4A      1       Canadian                SDCE_4L          12      Polish
SDCE_4B      2       French                  SDCE_4M          13      Portuguese
SDCE_4C      3       English                 SDCE_4N          14      South Asian (e.g. East
SDCE_4D      4       German                                           Indian, Pakistani, Sri
                                                                      Lankan)
SDCE_4E      5       Scottish                SDCE_4T          15      Norwegian
SDCE_4F      6       Irish                   SDCE_4U          16      Welsh
SDCE_4G      7       Italian                 SDCE_4V          17      Swedish
SDCE_4H      8       Ukrainian               SDCE_4P          18      North American Indian
SDCE_4I      9       Dutch (Netherlands)     SDCE_4Q          19      Métis
SDCE_4J      10      Chinese                 SDCE_4R          20      Inuit
SDCE_4K      11      Jewish                  SDCE_4S          21      Other – Specify
                     DK, R

SDC_C4S      If SDC_Q4 = 21, go to SDC_Q4S.
             Otherwise, go to SDC_Q5.

SDC_Q4S      INTERVIEWER: Specify.

             ________________________
             (80 spaces)
             DK, R




268                                                                                Statistics Canada
                                               Canadian Community Health Survey - Cycle 3.1



Note: Question SDC_Q4, had minor revisions and was used starting with June 2005 collection.

SDC_Q4        To which ethnic or cultural groups did ^YOUR2 ancestors belong? (For example:
              French, Scottish, Chinese, East Indian).
              INTERVIEWER: Mark all that apply.
              If “Canadian” is the only response, probe.
              If the respondent hesitates, do not suggest Canadian.
              If the respondent answers “Eskimo”, enter “20”.

SDCE_4A       1      Canadian        SDCE_4L      12     Polish
SDCE_4B       2      French          SDCE_4M      13     Portuguese
SDCE_4C       3      English         SDCE_4N      14     South Asian (e.g. East
SDCE_4D       4      German                              Indian, Pakistani, Sri Lankan)
SDCE_4E       5      Scottish        SDCE_4T      15     Norwegian
SDCE_4F       6      Irish           SDCE_4U      16     Welsh
SDCE_4G       7      Italian         SDCE_4V      17     Swedish
SDCE_4H       8      Ukrainian       SDCE_4P      18     North American Indian
SDCE_4I       9      Dutch
                     (Netherlands)   SDCE_4Q      19     Métis

SDCE_4J       10     Chinese         SDCE_4R      20     Inuit
SDCE_4K       11     Jewish          SDCE_4S      21     Other - Specify
                     DK, R

SDC_C4S       If SDC_Q4 = 21, go to SDC_Q4S.
              Otherwise, go to SDC_Q4_1.

Note: The otherwise part of condition SDC_C4S, now flows to SDC_Q4_1, starting with June
2005 collection

SDC_Q4S       INTERVIEWER: Specify.

              ________________________
              (80 spaces)
              DK, R




Statistics Canada                                                                         269
Canadian Community Health Survey - Cycle 3.1


Note: Starting with June, 2005 data collection, the SDC module has been changed. Between
questions SDC_Q4 and SDC_Q5, three revised questions have been added to identify
Aboriginal people.

SDC_Q4_1     ^ARE_C ^YOU1 an Aboriginal person, that is, North American Indian, Métis
SDCE_41      or Inuit?

             1       Yes
             2       No            (Go to SDC_Q4_3)
                     DK, R         (Go to SDE_Q5)

SDC_Q4_2     ^ARE_C ^YOU1:
             INTERVIEWER: Read categories to respondent. Mark all that apply.
             If respondent answers “Eskimo”, enter “3”.

SDCE_42A     1    … North American Indian?
SDCE_42B     2    … Métis?
SDCE_42C     3    … Inuit?
                     DK, R

             Go to SDC_Q5

SDC_Q4_3     People living in Canada come from many different cultural and racial
             Backgrounds. ^ARE_C ^YOU1:
             INTERVIEWER: Read categories to respondent. Mark all that apply.

SDCE_43A     1       … White?
SDCE_43B     2       … Chinese?
SDCE_43C     3       … South Asian (e.g., East Indian, Pakistani, Sri Lankan)?
SDCE_43D     4       … Black?
SDCE_43E     5       … Filipino?
SDCE_43F     6       … Latin American?
SDCE_43G     7       … Southeast Asian (e.g., Cambodian, Indonesian, Laotian,
                     Vietnamese)?
SDCE_43H     8       … Arab?
SDCE_43I     9       … West Asian (e.g., Afghan, Iranian)?
SDCE_43J     10      … Japanese?
SDCE_43K     11      … Korean?
SDCE_43M     12      Other - Specify
                     DK, R

SDC_C4_3S    If SDC_Q4_3 = 12, go to SDC_Q4_3S.
             Otherwise, go to SDC_Q5.

SDC_Q4_3S    INTERVIEWER: Specify.

             ________________________
             (80 spaces)
             DK, R




270                                                                             Statistics Canada
                                               Canadian Community Health Survey - Cycle 3.1

SDC_Q5        In what languages can ^YOU1 conduct a conversation?
              INTERVIEWER: Mark all that apply.

SDCE_5A       1       English             SDCE_5M       13      Portuguese
SDCE_5B       2       French              SDCE_5N       14      Punjabi
SDCE_5C       3       Arabic              SDCE_5O       15      Spanish
SDCE_5D       4       Chinese             SDCE_5P       16      Tagalog (Pilipino)
SDCE_5E       5       Cree                SDCE_5Q       17      Ukrainian
SDCE_5F       6       German              SDCE_5R       18      Vietnamese
SDCE_5G       7       Greek               SDCE_5T       19      Dutch
SDCE_5H       8       Hungarian           SDCE_5U       20      Hindi
SDCE_5I       9       Italian             SDCE_5V       21      Russian
SDCE_5J       10      Korean              SDCE_5W       22      Tamil
SDCE_5K       11      Persian (Farsi)     SDCE_5S       23      Other – Specify
SDCE_5L       12      Polish                                    DK, R

SDC_C5S       If SDC_Q5 = 23, go to SDC_Q5S.
              Otherwise, go to SDC_Q5A.

SDC_Q5S       INTERVIEWER: Specify.

              ________________________
              (80 spaces)

              DK, R

SDC_Q5A       What language ^DOVERB ^YOU1 speak most often at home?
SDCE_5AA
              1       English                     13    Portuguese
              2       French                      14    Punjabi
              3       Arabic                      15    Spanish
              4       Chinese                     16    Tagalog (Pilipino)
              5       Cree                        17    Ukrainian
              6       German                      18    Vietnamese
              7       Greek                       19    Dutch
              8       Hungarian                   20    Hindi
              9       Italian                     21    Russian
              10      Korean                      22    Tamil
              11      Persian (Farsi)             23    Other – Specify
              12      Polish                            DK, R

SDC_C5AS      If SDC_Q5A = 23, go to SDC_Q5AS.
              Otherwise, go to SDC_Q6.

SDC_Q5AS      INTERVIEWER: Specify.

              ________________________
              (80 spaces)
              DK, R




Statistics Canada                                                                      271
Canadian Community Health Survey - Cycle 3.1

SDC_Q6       What is the language that ^YOU2 first learned at home in childhood
             and can still understand?
             INTERVIEWER: Mark all that apply.
             If person can no longer understand the first language learned, mark the
             second.

SDCE_6A      1      English                 SDCE_6M         13      Portuguese
SDCE_6B      2      French                  SDCE_6N         14      Punjabi
SDCE_6C      3      Arabic                  SDCE_6O         15      Spanish
SDCE_6D      4      Chinese                 SDCE_6P         16      Tagalog (Pilipino)
SDCE_6E      5      Cree                    SDCE_6Q         17      Ukrainian
SDCE_6F      6      German                  SDCE_6R         18      Vietnamese
SDCE_6G      7      Greek                   SDCE_6T         19      Dutch
SDCE_6H      8      Hungarian               SDCE_6U         20      Hindi
SDCE_6I      9      Italian                 SDCE_6V         21      Russian
SDCE_6J      10     Korean                  SDCE_6W         22      Tamil
SDCE_6K      11     Persian (Farsi)         SDCE_6S         23      Other - Specify
SDCE_6L      12     Polish                                          DK, R


SDC_C6S      If SDC_Q6 = 23, go to SDC_Q6S.
             Otherwise, go to SDC_Q7.

SDC_Q6S      INTERVIEWER: Specify.

             ________________________
             (80 spaces)
             DK, R

Note:        Questions SDC_Q7 and SDC_Q7B were only collected from January to May,
             2005.

SDC_Q7       People living in Canada come from many different cultural and racial
             backgrounds. ^ARE_C ^YOU1:
             INTERVIEWER: Read categories to respondent. Mark all that apply.

SDCE_7A      1      …White?
SDCE_7B      2      …Chinese?
SDCE_7C      3      …South Asian (e.g., East Indian, Pakistani, Sri Lankan)?
SDCE_7D      4      …Black?
SDCE_7E      5      …Filipino?
SDCE_7F      6      …Latin American?
SDCE_7G      7      …Southeast Asian (e.g., Cambodian, Indonesian, Laotian,
                    Vietnamese)?
SDCE_7H      8      …Arab?
SDCE_7I      9      …West Asian (e.g., Afghan, Iranian)?
SDCE_7J      10     …Japanese?
SDCE_7K      11     …Korean?
SDCE_7L      12     …Aboriginal (North American Indian, Métis or Inuit)?
SDCE_7M      13     Other - Specify
                    DK, R




272                                                                              Statistics Canada
                                                  Canadian Community Health Survey - Cycle 3.1

SDC_C7S       If SDC_Q7 = 13, go to SDC_Q7S.
              Otherwise, go to SDC_C7B.

SDC_Q7S       INTERVIEWER: Specify.

              ________________________
              (80 spaces)
              DK, R

SDC_C7B       If SDC_Q7 = 12, go to SDC_Q7B.
              Otherwise, go to SDC_C7A.

SDC_Q7B       ^ARE_C ^YOU1:
SDCE_7BA      INTERVIEWER: Read categories to respondent.

              1      … North American Indian?
              2      … Métis?
              3      … Inuit?
              4      Other - Specify
                     DK, R

SDC_C7BS      If SDC_Q7B = 4, go to SDC_Q7BS.
              Otherwise, go to SDC_C7A.

SDC_Q7BS      INTERVIEWER: Specify.

              ________________________
              (80 spaces)
              DK, R

SDC_C7A       If proxy interview or age < 18 or age > 59, go to SDC_END.
              Otherwise, go to SDC_Q7A.

SDC_Q7A       Do you consider yourself to be:
SDCE_7AA      INTERVIEWER: Read categories to respondent.

              1      … heterosexual? (sexual relations with people of the opposite sex)
              2      … homosexual, that is lesbian or gay? (sexual relations with people of your
                     own sex)
              3      … bisexual? (sexual relations with people of both sexes)
                     DK, R

SDC_END




Statistics Canada                                                                           273
Canadian Community Health Survey - Cycle 3.1



EDUCATION (EDU)
EDU_BEG

EDU_C01A     If (do EDU block = 1), go to EDU_C01B.
             Otherwise, go to EDU_END.

EDU_C01B     If age of selected respondent < 14, go to EDU_C07A.
             Otherwise, go to EDU_B01.

EDU_B01      Call Education Sub Block 1 (EDU1)

EDU_C07A     If there is at least one household member who is >= 14 years of age other than the
             selected respondent, go to EDU_R07A.
             Otherwise, go to EDU_END.

EDU_R07A     Now I’d like you to think about the rest of your household.
             INTERVIEWER: Press <Enter> to continue.

EDU_B02      Call Education Sub Block 2 (EDU2)

Note:        Ask this block for each household member aged 14 and older other than selected
             respondent. Maximum of 19 times.

             If it is a proxy interview then begin with person providing information about selected
             respondent.

             Otherwise, begin with first person rostered. Continue with household members in the
             order in which they were rostered.

             If calling the block for the person providing the information about selected respondent, set
             proxyMode = NonProxy.
             Otherwise, set proxymode = Proxy.

EDU_END




274                                                                                  Statistics Canada
                                                 Canadian Community Health Survey - Cycle 3.1

Education Sub Block 1 (EDU1)

EDU1_BEG

EDU_R01       Next, education.
              INTERVIEWER: Press <Enter> to continue.

EDU_Q01       What is the highest grade of elementary or high school ^YOU2 ^HAVE ever
EDUE_01       completed?

              1      Grade 8 or lower
                     (Québec: Secondary II or lower)                 (Go to EDU_Q03)
              2      Grade 9 – 10
                     (Québec: Secondary III or IV, Newfoundland
                     and Labrador: 1st year of secondary)            (Go to EDU_Q03)
              3      Grade 11 – 13
                     (Québec: Secondary V, Newfoundland and
                     Labrador: 2nd to 4th year of secondary)
                     DK, R                                           (Go to EDU_Q03)

EDU_Q02       Did ^YOU1 graduate from high school (secondary school)?
EDUE_02
              1      Yes
              2      No
                     DK, R

EDU_Q03       ^HAVE_C ^YOU1 received any other education that could be counted towards a
EDUE_03       degree, certificate or diploma from an educational institution?

              1      Yes
              2      No              (Go to EDU_Q05)
                     DK, R           (Go to EDU_Q05)

EDU_Q04       What is the highest degree, certificate or diploma ^YOU1 ^HAVE obtained?
EDUE_04
              1      No post-secondary degree, certificate or diploma
              2      Trade certificate or diploma from a vocational school or apprenticeship training
              3      Non-university certificate or diploma from a community college, CEGEP, school
                     of nursing, etc.
              4      University certificate below bachelor’s level
              5      Bachelor’s degree
              6      University degree or certificate above bachelor’s degree
                     DK, R

EDU_Q05       ^ARE_C ^YOU1 currently attending a school, college or university?
SDCE_08
              1      Yes
              2      No    (Go to EDU1_END)
                     DK, R (Go to EDU1_END)




Statistics Canada                                                                                 275
Canadian Community Health Survey - Cycle 3.1

EDU_Q06      ^ARE_C ^YOU1 enrolled as a full-time student or a part-time student?
SDCE_09
             1      Full-time
             2      Part-time
                    DK, R

EDU1_END




276                                                                         Statistics Canada
                                                   Canadian Community Health Survey - Cycle 3.1

Education Sub Block 2 (EDU2)

EDU2_BEG

EDU_Q07       What is the highest grade of elementary or high school [you/FNAME] ever
EDUE_01       completed?

              1       Grade 8 or lower
                      (Québec: Secondary II or lower)                   (Go to EDU_Q09)
              2       Grade 9 – 10 (Québec: Secondary III or IV,
                      Newfoundland and Labrador: 1st year of secondary) (Go to EDU_Q09)
              3       Grade 11 – 13 (Québec: Secondary V, Newfoundland
                      and Labrador: 2nd to 4th year of secondary)
                      DK, R                                             (Go to EDU_Q09)

Note:         If non-proxy interview, use “you”.
              Otherwise, use ^FNAME.

EDU_Q08       Did [you/he/she] graduate from high school (secondary school)?
EDUE_02
              1       Yes
              2       No
                      DK, R

Note:         If non-proxy interview, use ”you”.
              Otherwise, use “he” or “she”.

EDU_Q09       [Have/Has] [you/he/she] received any other education that could be counted
EDUE_03       towards a degree, certificate or diploma from an educational institution?

              1       Yes
              2       No                       (Go to next family member or EDU_END)
                      DK, R                    (Go to next family member or EDU_END)

Note:         If non-proxy interview, use ”Have” and “you”.
              Otherwise, use “Has” and “he” or “she”.

EDU_Q10       What is the highest degree, certificate or diploma [you/he/she] [have/has]
EDUE_04       obtained?

              1       No post-secondary degree, certificate or diploma
              2       Trade certificate or diploma from a vocational school or apprenticeship training
              3       Non-university certificate or diploma from a community college, CEGEP, school
                      of nursing, etc.
              4       University certificate below bachelor’s level
              5       Bachelor’s degree
              6       University degree or certificate above bachelor’s degree
                      DK, R

Note:         If non-proxy interview, use ”you” and “have”.
              Otherwise, use “he” or “she” and “has”.

EDU2_END




Statistics Canada                                                                                  277
Canadian Community Health Survey - Cycle 3.1



INSURANCE COVERAGE (INS)
INS_BEG

INS_C1A      If (do INS block = 1), go to INS_QINT.
INSEFOPT     Otherwise, go to INS_END.

INS_QINT     Now, turning to ^YOUR2 insurance coverage. Please include any private,
             government or employer-paid plans.
             INTERVIEWER: Press <Enter> to continue.

INS_Q1       ^DOVERB_C ^YOU2 have insurance that covers all or part of the cost of
INSE_1       YOUR1 prescription medications?

             1       Yes
             2       No      (Go to INS_Q2)
                     DK      (Go to INS_Q2)
                     R       (Go to INS_END)

INS_Q1A      Is it:
             INTERVIEWER: Read categories to respondent. Mark all that apply.

INSE_1A      1       … a government-sponsored plan?
INSE_1B      2       … an employer-sponsored plan?
INSE_1C      3       … a private plan?
                     DK, R

INS_Q2       (^DOVERB_C ^YOU2 have insurance that covers all or part of:)
INSE_2
             … ^YOUR1 dental expenses?

             1       Yes
             2       No    (Go to INS_Q3)
                     DK, R (Go to INS_Q3)

INS_Q2A      Is it:
             INTERVIEWER: Read categories to respondent. Mark all that apply.

INSE_2A      1       … a government-sponsored plan?
INSE_2B      2       … an employer-sponsored plan?
INSE_2C      3       … a private plan?
                     DK, R




278                                                                             Statistics Canada
                                                Canadian Community Health Survey - Cycle 3.1

INS_Q3        (^DOVERB_C ^YOU2 have insurance that covers all or part of:)
INSE_3
              … the costs of eye glasses or contact lenses?

              1      Yes
              2      No    (Go to INS_Q4)
                     DK, R (Go to INS_Q4)

INS_Q3A       Is it:
              INTERVIEWER: Read categories to respondent. Mark all that apply.

INSE_3A       1      … a government-sponsored plan?
INSE_3B       2      … an employer-sponsored plan?
INSE_3C       3      … a private plan?
                     DK, R

INS_Q4        (^DOVERB_C ^YOU2 have insurance that covers all or part of:)
INSE_4
              … hospital charges for a private or semi-private room?

              1      Yes
              2      No    (Go to INS_END)
                     DK, R (Go to INS_END)

INS_Q4A       Is it:
              INTERVIEWER: Read categories to respondent. Mark all that apply.

INSE_4A       1      … a government-sponsored plan?
INSE_4B       2      … an employer-sponsored plan?
INSE_4C       3      … a private plan?
                     DK, R

INS_END




Statistics Canada                                                                       279
Canadian Community Health Survey - Cycle 3.1



INCOME (INC)
INC_BEG

INC_C1       If (do INC block = 1), go to INC_QINT.
             Otherwise, go to INC_END.

INC_QINT     Although many health expenses are covered by health insurance, there is still a
             relationship between health and income. Please be assured that, like all other
             information you have provided, these answers will be kept strictly confidential.
             INTERVIEWER: Press <Enter> to continue.

INC_Q1       Thinking about the total income for all household members, from which of the
             following sources did your household receive any income in the past 12 months?
             INTERVIEWER: Read categories to respondent. Mark all that apply.

INCE_1A      1       Wages and salaries
INCE_1B      2       Income from self-employment
INCE_1C      3       Dividends and interest (e.g., on bonds, savings)
INCE_1D      4       Employment insurance
INCE_1E      5       Worker’s compensation
INCE_1F      6       Benefits from Canada or Quebec Pension Plan
INCE_1G      7       Retirement pensions, superannuation and annuities
INCE_1H      8       Old Age Security and Guaranteed Income Supplement
INCE_1I      9       Child Tax Benefit
INCE_1J      10      Provincial or municipal social assistance or welfare
INCE_1K      11      Child support
INCE_1L      12      Alimony
INCE_1M      13      Other (e.g., rental income, scholarships)
INCE_1N      14      None            (Go to INC_Q3)
                     DK, R           (Go to INC_END)

INC_E1       You cannot select “None” and another category. Please return and correct.

             Trigger hard edit if INC_Q1 = 14 and any other response selected in INC_Q1.

INC_E2       Inconsistent answers have been entered. Please confirm.

             Trigger soft edit if (INC_Q1 <> 1 or 2) and (LBF_Q01 = 1 or LBF_Q02 = 1 or
             LBF_Q21 = 1).

INC_C2       If more than one source of income is indicated, go to INC_Q2.
             Otherwise, go to INC_Q3.

Note:        In processing, if the respondent reported only one source of income in INC_Q1, the
             variable INC_Q2 is given its value.




280                                                                               Statistics Canada
                                                  Canadian Community Health Survey - Cycle 3.1

INC_Q2        What was the main source of income?
INCE_2
              1      Wages and salaries
              2      Income from self-employment
              3      Dividends and interest (e.g., on bonds, savings)
              4      Employment insurance
              5      Worker’s compensation
              6      Benefits from Canada or Quebec Pension
              7      Retirement pensions, superannuation and annuities
              8      Old Age Security and Guaranteed Income Supplement
              9      Child Tax Benefit
              10     Provincial or municipal social assistance or welfare
              11     Child support
              12     Alimony
              13     Other (e.g., rental income, scholarships)
              14     None (category created during processing)
                     DK, R

INC_E3        The main source of income is not selected as one of the sources of income for all
              household members. Please return and correct.

              Trigger hard edit if the response in INC_Q2 was not selected in INC_Q1.

INC_Q3        What is your best estimate of the total income, before taxes and deductions, of all
INCE_3        household members from all sources in the past 12 months?

              |_|_|_|_|_|_|  Income         (Go to INC_C4)
              (MIN: 0) (MAX: 500,000; warning after 150,000)
                             0              (Go to INC_END)
                             DK, R          (Go to INC_Q3A)

Note:         In processing, responses reported in INC_Q3 are also being recoded into the cascade
              categories of INC_Q3A to INC_Q3G.

INC_Q3A       Can you estimate in which of the following groups your household income falls?
INCE_3A       Was the total household income less than $20,000 or $20,000 or more?

              1      Less than $20,000
              2      $20,000 or more         (Go to INC_Q3E)
              3      No income               (Go to INC_END)
                     DK, R                   (Go to INC_END)

INC_Q3B       Was the total household income from all sources less than $10,000 or $10,000 or
INCE_3B       more?

              1      Less than $10,000
              2      $10,000 or more         (Go to INC_Q3D)
                     DK, R                   (Go to INC_C4)




Statistics Canada                                                                               281
Canadian Community Health Survey - Cycle 3.1

INC_Q3C      Was the total household income from all sources less than $5,000 or $5,000 or
INCE_3C      more?

             1      Less than $5,000
             2      $5,000 or more
                    DK, R

             Go to INC_C4

INC_Q3D      Was the total household income from all sources less than $15,000 or $15,000 or
INCE_3D      more?

             1      Less than $15,000
             2      $15,000 or more
                    DK, R

             Go to INC_C4

INC_Q3E      Was the total household income from all sources less than $40,000 or $40,000 or
INCE_3E      more?

             1      Less than $40,000
             2      $40,000 or more        (Go to INC_Q3G)
                    DK, R                  (Go to INC_C4)

INC_Q3F      Was the total household income from all sources less than $30,000 or $30,000 or
INCE_3F      more?

             1      Less than $30,000
             2      $30,000 or more
                    DK, R

             Go to INC_C4

INC_Q3G      Was the total household income from all sources:
INCE_3G      INTERVIEWER: Read categories to respondent.

             1      … less than $50,000?
             2      … $50,000 to less than $60,000?
             3      … $60,000 to less than $80,000?
             4      … $80,000 to less than $100,000?
             5      … $100,000 or more?
                    DK, R

INC_C4       If age >= 15, go to INC_Q4.
             Otherwise, go to INC_END.




282                                                                          Statistics Canada
                                                 Canadian Community Health Survey - Cycle 3.1

INC_Q4        What is your best estimate of ^YOUR2 total personal income, before taxes
INCE_4        and other deductions, from all sources in the past 12 months?

              |_|_|_|_|_|_|  Income         (Go to INC_END)
              (MIN: 0) (MAX: 500,000; warning after 150,000)
                             0              (Go to INC_END)
                             DK, R          (Go to INC_Q4A)

Note:         In processing, responses reported in INC_Q4 are also coded into the cascade categories
              of INC_Q4A to INC_Q4G.

INC_Q4A       Can you estimate in which of the following groups ^YOUR2 personal
INCE_4A       income falls? Was ^YOUR1 total personal income less than $20,000 or
              $20,000 or more?

              1      Less than $20,000
              2      $20,000 or more         (Go to INC_Q4E)
              3      No income               (Go to INC_END)
                     DK, R                   (Go to INC_END)

INC_Q4B       Was ^YOUR1 total personal income less than $10,000 or $10,000 or more?
INCE_4B
              1      Less than $10,000
              2      $10,000 or more         (Go to INC_Q4D)
                     DK, R                   (Go to INC_END)

INC_Q4C       Was ^YOUR1 total personal income less than $5,000 or $5,000 or more?
INCE_4C
              1      Less than $5,000
              2      $5,000 or more
                     DK, R

              Go to INC_END

INC_Q4D       Was ^YOUR1 total personal income less than $15,000 or $15,000 or more?
INCE_4D
              1      Less than $15,000
              2      $15,000 or more
                     DK, R

              Go to INC_END

INC_Q4E       Was ^YOUR1 total personal income less than $40,000 or $40,000 or more?
INCE_4E
              1      Less than $40,000
              2      $40,000 or more         (Go to INC_Q4G)
                     DK, R                   (Go to INC_END)




Statistics Canada                                                                               283
Canadian Community Health Survey - Cycle 3.1

INC_Q4F      Was ^YOUR1 total personal income less than $30,000 or $30,000 or more?
INCE_4F
             1      Less than $30,000
             2      $30,000 or more
                    DK, R

             Go to INC_END

INC_Q4G      Was ^YOUR1 total personal income:
INCE_4G      INTERVIEWER: Read categories to respondent.

             1      … less than $50,000?
             2      … $50,000 to less than $60,000?
             3      … $60,000 to less than $80,000?
             4      … $80,000 to less than $100,000?
             5      … $100,000 or more?
                    DK, R

INC_END




284                                                                       Statistics Canada
                                                  Canadian Community Health Survey - Cycle 3.1



FOOD SECURITY (FSC)
FSC_BEG

FSC_C01       If (do FSC block = 1), then go to FSC_D010.
FSCEFOPT      Otherwise, go to FSC_END.

FSC_D010      If HhldSize = 1, then
                      ^YouAndOthers =”you”
                      ^YouAndOthers_C =”You”
              Else
                      ^YouAndOthers =”you and other household members”
                      ^YouAndOthers_C =”You and other household members”
              Endif

              If (OlderKids + YoungKids = 1), then
                       ^ChildFName = ChildFName
                       ^ChildWas = ChildFName + ”was”
                       ^AnyChild = ChildFName
                       ^AnyChilds = ChildFName + “ ’s”
                       ^WasAnyChild = “was” + ChildFName
              Else
                       ^ChildFName = ”the children”
                       ^ChildWas = ”The children were”
                       ^AnyChild = “any of the children”
                       ^AnyChilds = “any of the children’s”
                       ^WasAnyChild = “were any of the children”
              Endif

              If (Adults + YoungAdults) = 1, then
                       ^YouOtherAdults =”you”
                       ^YouOtherAdults_C =”You”
              Else
                       ^YouOtherAdults = ”you or other adults in your household”
                       ^YouOtherAdults_C =”You or other adults in your household”
              Endif

FSC_R010      The following questions are about the food situation for your household in the past
              12 months.
              INTERVIEWER: Press <Enter> to continue.




Statistics Canada                                                                            285
Canadian Community Health Survey - Cycle 3.1

FSC_Q010     Which of the following statements best describes the food eaten in your household
FSCE_010     in the past 12 months, that is, since [current month] of last year?
             INTERVIEWER: Read categories to respondent.

             1      ^YouAndOthers_C always had enough of the kinds of food you wanted to
                    eat.
             2      ^YouAndOthers_C had enough to eat, but not always the kinds of food you
                    wanted.
             3      Sometimes ^YouAndOthers did not have enough to eat.
             4      Often ^YouAndOthers didn’t have enough to eat.
                    DK, R                              (Go to FSC_END)

FSC_R020     Now I’m going to read you several statements that may be used to describe the
             food situation for a household. Please tell me if the statement was often true,
             sometimes true, or never true for ^YouAndOthers in the past 12 months.
             INTERVIEWER: Press <Enter> to continue.

FSC_Q020     The first statement is: …^YouAndOthers_C worried that food would run out before
FSCE_020     you got money to buy more. Was that often true, sometimes true, or never true in
             the past 12 months?

             1      Often true
             2      Sometimes true
             3      Never true
                    DK, R

FSC_Q030     The food that ^YouAndOthers bought just didn’t last, and there wasn’t any money
FSCE_030     to get more. Was that often true, sometimes true, or never true in the past 12
             months?

             1      Often true
             2      Sometimes true
             3      Never true
                    DK, R

FSC_Q040     ^YouAndOthers_C couldn’t afford to eat balanced meals. In the past 12 months
FSCE_040     was that often true, sometimes true, or never true?

             1      Often true
             2      Sometimes true
             3      Never true
                    DK, R

FSC_C050     If (OlderKids + YoungKids > 0), go to FSC_R050.
             Otherwise, go to FSC_C070.

FSC_R050     Now I’m going to read a few statements that may describe the food situation for
             households with children.
             INTERVIEWER: Press <Enter> to continue.




286                                                                           Statistics Canada
                                                 Canadian Community Health Survey - Cycle 3.1

FSC_Q050      ^YouOtherAdults_C relied on only a few kinds of low-cost food to feed
FSCE_050      ^ChildFName because you were running out of money to buy food. Was that often
              true, sometimes true, or never true in the past 12 months?

              1      Often true
              2      Sometimes true
              3      Never true
                     DK, R

FSC_Q060      ^YouOtherAdults_C couldn’t feed ^ChildFName a balanced meal, because you
FSCE_060      couldn’t afford it. Was that often true, sometimes true, or never true in the past
              12 months?

              1      Often true
              2      Sometimes true
              3      Never true
                     DK, R

FSC_C070      If (FSC_Q020 or FSC_Q030 or FSC_Q040 or FSC_Q050 or FSC_Q060 <= 2) or
              (FSC_Q010 = 3 or 4) and (OlderKids + YoungKids > 0), go to FSC_Q070.
              Else if (FSC_Q020 or FSC_Q030 or FSC_Q040 or FSC_Q050 or FSC_Q060 <= 2) or
              (FSC_Q010 = 3 or 4), go to FSC_R080.
              Otherwise, go to FSC_END.

FSC_Q070      ^ChildWas not eating enough because ^YouOtherAdults just couldn't afford
FSCE_070      enough food. Was that often, sometimes, or never true in the past 12 months?

              1      Often true
              2      Sometimes true
              3      Never true
                     DK, R

FSC_R080      The following few questions are about the food situation in the past 12 months for
              you or any other adults in your household.
              INTERVIEWER: Press <Enter> to continue.

FSC_Q080      In the past 12 months, since last [current month] did ^YouOtherAdults ever cut
FSCE_080      the size of your meals or skip meals because there wasn’t enough money for food?

              1      Yes
              2      No               (Go to FSC_Q090)
                     DK, R            (Go to FSC_Q090)

FSC_Q081      How often did this happen---almost every month, some months but not every
FSCE_081      month, or in only 1 or 2 months?

              1      Almost every month
              2      Some months but not every month
              3      Only 1 or 2 months
                     DK, R




Statistics Canada                                                                                  287
Canadian Community Health Survey - Cycle 3.1

FSC_Q090     In the past 12 months, did you (personally) ever eat less than you felt you should
FSCE_090     because there wasn't enough money to buy food?

             1      Yes
             2      No
                    DK, R

FSC_Q100     In the past 12 months, were you (personally) ever hungry but didn't eat because
FSCE_100     you couldn't afford enough food?

             1      Yes
             2      No
                    DK, R

FSC_Q110     In the past 12 months, did you (personally) lose weight because you didn't have
FSCE_110     enough money for food?

             1      Yes
             2      No
                    DK, R

FSC_C120     If (FSC_Q070 = 1 or 2) or (FSC_Q080 or FSC_Q090 or FSC_Q100 or FSC_Q110 = 1),
             go to FSC_Q120.
             Otherwise, go to FSC_END.

FSC_Q120     In the past 12 months, did ^YouOtherAdults ever not eat for a whole day because
FSCE_120     there wasn't enough money for food?

             1      Yes
             2      No    (Go to FSC_C130)
                    DK, R (Go to FSC_C130)

FSC_Q121     How often did this happen---almost every month, some months but not every
FSCE_121     month, or in only 1 or 2 months?

             1      Almost every month
             2      Some months but not every month
             3      Only 1 or 2 months
                    DK, R

FSC_C130     If (OlderKids + YoungKids <> 0) go to FSC_R130.
             Otherwise, go to FSC_END.

FSC_R130     Now, a few questions on the food experiences for children in your household.
             INTERVIEWER: Press <Enter> to continue.




288                                                                            Statistics Canada
                                                Canadian Community Health Survey - Cycle 3.1

FSC_Q130      In the past 12 months, did ^YouOtherAdults ever cut the size of ^AnyChilds meals
FSCE_130      because there wasn't enough money for food?

              1      Yes
              2      No
                     DK, R

FSC_Q140      In the past 12 months, did ^AnyChild ever skip meals because there wasn't enough
FSCE_140      money for food?

              1      Yes
              2      No             (Go to FSC_Q150)
                     DK, R          (Go to FSC_Q150)

FSC_Q141      How often did this happen---almost every month, some months but not every
FSCE_141      month, or in only 1 or 2 months?

              1      Almost every month
              2      Some months but not every month
              3      Only 1 or 2 months
                     DK, R

FSC_Q150      In the past 12 months, ^WasAnyChild ever hungry but you just couldn't afford
FSCE_150      more food?

              1      Yes
              2      No
                     DK, R

FSC_Q160      In the past 12 months, did ^AnyChild ever not eat for a whole day because there
FSCE_160      wasn't enough money for food?

              1      Yes
              2      No
                     DK, R

FSC_END




Statistics Canada                                                                            289
Canadian Community Health Survey - Cycle 3.1



DWELLING CHARACTERISTICS (DWL)
DWL_BEG

DWL_C01      If (do block DWL = 1), go to DWL_R01.
             Otherwise, go to DWL_END.

DWL_R01      Now a few questions about your dwelling.
             INTERVIEWER: Press <Enter> to continue.

DWL_C01B     If area frame, go to DWL_Q02.
             Otherwise, go to DWL_Q01.

DWL_Q01      What type of dwelling ^DOVERB ^YOU2 live in? Is it a:
DHHEDDWE     INTERVIEWER: Read categories to respondent.

             1       … single detached?
             2       … double?
             3       … row or terrace?
             4       … duplex?
             5       … low-rise apartment of fewer than 5 stories or a flat?
             6       … high-rise apartment of 5 stories or more?
             7       … institution?
             8       … hotel; rooming/lodging house; camp?
             9       … mobile home?
             10      … other – Specify
                     DK, R

DWL_C01S     If DWL_Q01 = 10, go to DW_Q01S.
             Otherwise, go to DWL_Q02.

DWL_Q01S     INTERVIEWER: Specify.

             ________________________
             (80 spaces)
             DK, R

DWL_Q02      How many bedrooms are there in this dwelling?
DHHE_BED     INTERVIEWER: Enter “0” if no separate, enclosed bedroom.

             |_|_|   Number of bedrooms
             (MIN: 0) (MAX: 20)
             DK, R

DWL_E02      An unusual value has been entered. Select <Suppress> to accept answer
             and continue or <Go to> to return and correct.

             Trigger soft edit if (DWL_Q02 > 10).




290                                                                            Statistics Canada
                                               Canadian Community Health Survey - Cycle 3.1

DWL_Q03       Is this dwelling owned by a member of this household?
DHHE_OWN
              1      Yes
              2      No
                     DK, R

DWL_END




Statistics Canada                                                                      291
Canadian Community Health Survey - Cycle 3.1



ADMINISTRATION (ADM)
ADM_BEG

ADM_C01         If (do ADM block = 1), go to ADM_Q01A.
                Otherwise, go to ADM_END.

Health Number

ADM_Q01A        Statistics Canada and your [provincial/territorial] ministry of health would like your
                permission to link information collected during this interview. This includes
                linking your survey information to your past and continuing use of health services
                such as visits to hospitals, clinics and doctor’s offices.
                INTERVIEWER: Press <Enter> to continue.

Note:           If province = 60, 61 or 62, use “territorial”. Otherwise, use “provincial”.

ADM_Q01B        This linked information will be kept confidential and used only for statistical
SAMEDLNK        purposes. Do we have your permission?

                1       Yes
                2       No    (Go to ADM_Q04A)
                        DK, R (Go to ADM_Q04A)

ADM_C3A         If province = 10, [province] = [Newfoundland and Labrador]
                If province = 11, [province] = [Prince Edward Island]
                If province = 12, [province] = [Nova Scotia]
                If province = 13, [province] = [New Brunswick]
                If province = 24, [province] = [Quebec]
                If province = 35, [province] = [Ontario]
                If province = 46, [province] = [Manitoba]
                If province = 47, [province] = [Saskatchewan]
                If province = 48, [province] = [Alberta]
                If province = 59, [province] = [British Columbia]
                If province = 60, [province] = [Yukon]
                If province = 61, [province] = [Northwest Territories]
                If province = 62, [province] = [Nunavut]

ADM_Q03A        (Having a [provincial/territorial] health number will assist us in linking to this other
                information.)

                ^DOVERB_C ^YOU1 have a(n) [province] health number?

                1       Yes   (Go to HN)
                2       No
                        DK, R (Go to ADM_Q04A)

Note:           If province = 60, 61 or 62, use “territorial”. Otherwise, use “provincial”.




292                                                                                           Statistics Canada
                                                        Canadian Community Health Survey - Cycle 3.1

ADM_Q03B        For which [province/territory] is ^YOUR2 health number?
LNKE_HNP
                10       Newfoundland and Labrador
                11       Prince Edward Island
                12       Nova Scotia
                13       New Brunswick
                24       Quebec
                35       Ontario
                46       Manitoba
                47       Saskatchewan
                48       Alberta
                59       British Columbia
                60       Yukon
                61       Northwest Territories
                62       Nunavut
                88       Do not have a [provincial/territorial] health number (Go to ADM_Q04A)
                         DK, R (Go to ADM_Q04A)

Note:           If province = 60. 61 or 62, use “territory” and “territorial”
                Otherwise, use “province” and “provincial”.

HN              What is ^YOUR2 health number?
                INTERVIEWER: Enter a health number for [province]. Do not insert blanks, hyphens or
                commas between the numbers.

                ________________________
                (8 - 12 spaces)
                DK, R

Data Sharing – All Provinces (excluding Québec and the territories)

ADM_Q04A        Statistics Canada would like your permission to share the information collected in
                this survey with provincial and territorial ministries of health[,Health Canada and
                the Public Health Agency of Canada / and Health Canada].

                Your provincial ministry of health may make some of this information available to
                your local health region, but names, addresses, telephone numbers and health
                numbers will not be provided.
                INTERVIEWER: Press <Enter> to continue.

Note:           If Shareflag = 1, use ”, Health Canada and the Public Health Agency of Canada”.
                Otherwise, use “and Health Canada”.

Note:           A phrase has been added to the share question to be turned on, once the Public
                Health Agency of Canada has legal status.

Data Sharing – NWT, Yukon, Nunavut

ADM_Q04A        Statistics Canada would like your permission to share the information collected in
                this survey with [Health Canada, the Public Health Agency of Canada / Health
                Canada] and provincial and territorial ministries of health.
                INTERVIEWER: Press <Enter> to continue.

Note:           If Shareflag = 1, use ”Health Canada and the Public Health Agency of Canada”.
                Otherwise, use “Health Canada”.




Statistics Canada                                                                                 293
Canadian Community Health Survey - Cycle 3.1

Data Sharing – Québec

ADM_Q04A      Statistics Canada would like your permission to share the information collected in
              this survey with provincial and territorial ministries of health, the « l’Institut de la
              Statistique du Québec »[, Health Canada and the Public Health Agency of Canada /
              and Health Canada].

              The « l’Institut de la Statistique du Québec » may make some of this information
              available to your local health region, but names, addresses, telephone numbers
              and health numbers will not be provided.
              INTERVIEWER: Press <Enter> to continue.

Note:         If Shareflag = 1, use ”, Health Canada and the Public Health Agency of Canada”.
              Otherwise, use “ and Health Canada”.

ADM_Q04B      All information will be kept confidential and used only for statistical purposes.
SAMEDSHR
              Do you agree to share the information provided?

              1         Yes
              2         No
                        DK, R

Frame Evaluation

FRE_C1        If RDD or FREFLAG = 1 (i.e. the frame evaluation questions have been done for the
              household), go to ADM_N05.

FRE_QINT      And finally, a few questions to evaluate the way households were selected for this
              survey.
              INTERVIEWER: Press <Enter> to continue.

FRE_Q1        How many different telephone numbers are there for your household, not counting
ADME_FE1      cellular phone numbers and phone numbers used strictly for business purposes?

              1         1
              2         2
              3         3 or more
              4         None                  (Go to FRE_Q4)
                        DK, R                 (Go to ADM_N05)

FRE_Q2        What is [your/your main] phone number, including the area code?
              INTERVIEWER: Do not include cellular or business phone numbers.
              Telephone number: [telnum].

Note:         If FRE_Q1 = 1, use “your”.
              Otherwise, use “your main”.

              Code              INTERVIEWER: Enter the area code.
              Tel               INTERVIEWER: Enter the telephone number.

              Go to FRE_C3

              DK                (Go to ADM_N05)
              R                 (Go to FRE_Q2A)




294                                                                                Statistics Canada
                                                 Canadian Community Health Survey - Cycle 3.1

FRE_Q2A       Could you tell me the area code and the first 5 digits of your phone number? Even
              that will help evaluate the way households were selected.

              I_I_I_I_I_I_I_I_I
              DK, R (Go to ADM_N05)

FRE_C3        If FRE_Q1 = 1 (1 phone), go to ADM_N05.

FRE_Q3        What is [your other phone number/another of your phone numbers], including the
              area code?
              INTERVIEWER: Do not include cellular or business phone numbers.

Note:         If FRE_Q1 = 2, use “your other phone number”.
              Otherwise, use “another of your phone numbers”.

              CODE2          INTERVIEWER: Enter the area code.
              TEL2           INTERVIEWER: Enter the telephone number.

              Go to ADM_N05

              DK             (Go to ADM_N05)
              R              (Go to FRE_Q3A)




Statistics Canada                                                                           295
Canadian Community Health Survey - Cycle 3.1

FRE_Q3A          Could you tell me the area code and the first 5 digits of [your other phone
                 number/another of your phone numbers]? (Even that will help evaluate the way
                 households were selected.)

                 I_I_I_I_I_I_I_I_I
                 DK, R
                 Go to ADM_N05

Note:            If FRE_Q1 = 2, use “your other phone number” in FRE_Q3.
                 Otherwise, use “another of your phone numbers” in FRE_Q3.

FRE_Q4           ^DOVERB_C ^YOU2 have a working cellular phone that can place and receive
ADME_F4          calls?

                 1       Yes
                 2       No
                         DK, R

Administration

ADM_N05          INTERVIEWER: Is this a fictitious name for the respondent?
ADME_N05
                 1       Yes
                 2       No    (Go to ADM_C09)
                         DK, R (Go to ADM_C09)

ADM_N06          INTERVIEWER: Remind respondent about the importance of getting correct names.
ADME_N06         Do you want to make corrections to:

                 1       … first name only?
                 2       … last name only?      (Go to ADM_N08)
                 3       … both names?
                 4       … no corrections?      (Go to ADM_C09)
                         DK, R                  (Go to ADM_C09)

ADM_N07          INTERVIEWER: Enter the first name only.

                 ________________________
                 (25 spaces)
                 DK, R

ADM_C08          If ADM_N06 <> “both names”, go to ADM_C09.

ADM_N08          INTERVIEWER: Enter the last name only.

                 ________________________
                 (25 spaces)
                 DK, R

ADM_C09          If RDD, go to ADM_N10.




296                                                                              Statistics Canada
                                                 Canadian Community Health Survey - Cycle 3.1

ADM_N09       INTERVIEWER: Was this interview conducted on the telephone or in person?
ADME_N09
              1      On telephone
              2      In person
              3      Both
                     DK, R

ADM_N10       INTERVIEWER: Was the respondent alone when you asked this health questionnaire?
ADME_N10
              1      Yes   (Go to ADM_N12)
              2      No
                     DK, R (Go to ADM_N12)

ADM_N11       INTERVIEWER: Do you think that the answers of the respondent were affected by
ADME_N11      someone else being there?

              1      Yes
              2      No
                     DK, R

ADM_N12       INTERVIEWER: Record language of interview
ADME_N12
              1      English                        14     Tamil
              2      French                         15     Cree
              3      Chinese                        16     Afghan
              4      Italian                        17     Cantonese
              5      Punjabi                        18     Hindi
              6      Spanish                        19     Mandarin
              7      Portuguese                     20     Persian
              8      Polish                         21     Russian
              9      German                         22     Ukrainian
              10     Vietnamese                     23     Urdu
              11     Arabic                         24     Inuktitut
              12     Tagalog                        90     Other – Specify
              13     Greek                                 DK, R

ADM_C12S      If ADM_N12 = 90, go to ADM_N12S.
              Otherwise, go to ADM_END.

ADM_N12S      INTERVIEWER: Specify

              ________________________
              (80 spaces)
              DK, R

ADM_END




Statistics Canada                                                                             297
Canadian Community Health Survey - Cycle 3.1

                                        ALPHABETIC INDEX

Module Name                                                Page Number

Access to health care services (acc)                           220
Administration (adm)                                           292
Age of selected respondent (anc)                                 1
Alcohol use (alc)                                              126
Blood pressure check (bpc)                                      65
Breast examinations (brx)                                       72
Breast self examinations (bsx)                                  74
Canadian problem gambling index(cpg)                           144
Changes made to improve health (cih)                             9
Childhood and adult stressors (cst)                            161
Chronic conditions (ccc)                                        18
Colorectal cancer exams (ccs)                                   81
Contacts with mental health professionals (cmh)                179
Dental visits (den)                                             84
Depression (dps)                                               185
Diabetes care (dia)                                             28
Distress (dis)                                                 181
Dwelling characteristics (dwl)                                 290
Education (edu)                                                274
Exposure to second-hand smoke (ets)                            124
Eye examinations (eyx)                                          75
Flu shots (flu)                                                 63
Food choices (fdc)                                              90
Food security (fsc)                                            285
Fruit and vegetable consumption (fvc)                           93
General health (gen)                                             3
Health care system satisfaction (hcs)                           12
Health care utilization (hcu)                                   37
Health status – sf-36 (sfr)                                    207
Health utility index (hui)                                     201
HEIGHT and WEIGHT (HWT)                                         14
Home care (hmc)                                                 46
Illicit drugs (idg)                                            135
Income (inc)                                                   280
Injuries (inj) (rep)                                           193
Insurance coverage (ins)                                       278
Labour force – common portion (lf2)                            264
Labour force (lbf)                                             250
Mammography (mam)                                               69
Maternal experiences (mex)                                     129
Measured height and weight (mhw)                               246
Medication use (med)                                            32
Nicotine dependence (nde)                                      116
Oral health 2 (oh2)                                             86
Pap smear test (pap)                                            67
Patient satisfaction (pas)                                      51
Physical activities (pac)                                       99


298                                                                      Statistics Canada
                                          Canadian Community Health Survey - Cycle 3.1

Physical check-up (pcu)                                   77
Prostate cancer screening (psa)                           79
Restriction of activities (rac)                           55
Satisfaction with life (swl)                             154
Sedentary activities (sac)                               102
Self-esteem (sfe)                                        166
Sexual behaviour (sxb)                                   216
Sleep (slp)                                                7
Smoking - physician counselling (spc)                    120
Smoking - stages of change (sch)                         115
Smoking (smk)                                            110
Smoking cessation aids (sca)                             117
Social support - availability (ssa)                      168
Social support - utilization (ssu)                       175
Socio-demographic characteristics (sdc)                  267
Stress - coping (stc)                                    158
Stress - sources (sts)                                   156
Suicidal thoughts and attempts (sui)                     191
Sun safety (ssb)                                         107
Two-week disability (twd)                                 60
Use of protective equipment (upe)                        104
Voluntary organizations (org)                              6
Waiting times (wtm)                                      231
Work stress (wst)                                        163
Youth smoking (ysm)                                      122




Statistics Canada                                                                 299
