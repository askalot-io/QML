# GSS_1999_Victimization

- **source**: GSS_1999_Victimization.pdf
- **model**: us.anthropic.claude-sonnet-4-6
- **dpi**: 150
- **pages**: 158

--- page 1 ---

GSS – Cycle 13 – Victimization                                                                    Appendix B

General Social Survey, 1999

Cycle 13 - Victimization

Questionnaire Package

Housing, Family and Social Statistics Division

Confidential when completed

Collected under the authority of the Statistics Act,
Revised Statutes of Canada, 1985, Chapter S19.

STC/HFS-027-75137

January 13, 1999
1

--- page 2 ---

<blank page>

--- page 3 ---

GSS – Cycle 13 – Victimization                                                                                              Appendix B

The content of the control form and the main questionnaire are listed below:

**Section**          **Content**

Control Form:        All household members, sex, age, marital status and number of telephones
                        in the household.
Section A:           Perceptions, History And Risk
Section B:           Criminal Victimization Screening Section
Section C:           Emotional And Financial Abuse By A
                        Spouse/Partner
Section D:           Physical And Sexual Violence By A Spouse/Partner
Section E:           Emotional And Financial Abuse By An Ex-Partner
Section F:           Physical And Sexual Violence By An Ex-Partner
Section G:           Emotional And Financial Abuse By Children
Section H:           Physical Violence By Children
Section J:           Emotional And Financial Abuse By A Caregiver
Section K:           Physical And Sexual Violence By Caregiver
Section L:           Spousal Abuse Report
Section M:           Ex-Spousal Abuse Report
Section N:           Senior Abuse By Children Report
Section P:           Senior Abuse By Caregiver Report
Section Q:           Classification

**Appendix:**
Section V:           Crime Incident Report

--- page 4 ---

GSS – Cycle 13 – Victimization                                                                                     Appendix B

<blank page>

--- page 5 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

Housing Family and Social Statistics Division
1999 General Social Survey
Victimization Questionnaire
Ages 15 Years and over


GSS 13-1 - Control Form
Confidential when completed
Collected under the authority of the Statistics
Act, Revised Statutes of Canada, 1985, Chapter S19.
STC/HFS-027-75137

INTRODUCTION

Date / Time stamp

INTRO_1

        Hello, I'm..........from Statistics Canada.  We are calling you for a study on Canadians'
        safety.  The purpose of the study is to better understand people's perception of crime and
        the justice system, and the extent of victimization in Canada.

        All information we collect in this voluntary survey will be kept strictly confidential.   Your
        participation is essential if the survey results are to be accurate.

        (The next paragraph should be optional.)

        My supervisor is working with me today and may listen to the interview to evaluate the
        survey.

MARSTAT  Is {household member x}'s marital status .....

                              INT: ===READ LIST===

        (1)     Living common-law?
        (2)     Married?
        (3)     Widowed?
        (4)     Divorced?
        (5)     Separated?
        (6)     Single (never married)?

 [CATI]:   If household roster members = 1, then [Go to INTRO_5Y], else do until all household roster
           members are completed, then [Go to INTRO_2]

[CATI]:   If age of household member is less than 15 years of age, then MARSTAT = 6 (Single, never married)


1

--- page 6 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

INTRO_2 What is {household member x}'s relationship to {household member y}?

        (2)  Husband/wife/spouse
        (3)  Common-law partner
        (4)  Son or daughter *[Go to INTRO_3]*
        (10) Father or mother *[Go to INTRO_4]*
        (15) Brother or sister
        (20) Grandchild
        (21) Grandfather or grandmother
        (30) Son-in-law or daughter-in-law
        (31) Father-in-law or mother-in-law
        (32) Brother-in-law or sister-in-law
        (40) Nephew or niece
        (41) Uncle or aunt
        (42) Cousin
        (50) Other relative
        (60) Non-relative
        (70) Same sex partner

*[CATI]:   If value of y for {household member y} = total amount of household members and x = (y - 1), then
           [Go to INTRO_5Y], else return and select next member of roster.*

INTRO_3 Is {household member x} the birth or step-child of {household member y}?

        (5)  Birth child
        (6)  Adopted child
        (7)  Step-child
        (8)  Foster child

*[CATI]:   If value of y for {household member y} = total amount of household members and x = (y - 1), then
           [Go to INTRO_5Y], else return and select next member of roster.*

INTRO_4 Is {household member x} the birth or step-father/mother of {household
        member y}?

        (11) Birth parent
        (12) Adoptive parent
        (13) Step parent
        (14) Foster parent

*[CATI]:   If value of y for {household member y} = total amount of household members and x = (y - 1), then
           [Go to INTRO_5Y], else return and select next member of roster.*

INTRO_5Y  What is your year of birth? (year)

        |__|__|__|__|  *[CATI:  1890-1984]*

2

--- page 7 ---

GSS – Cycle 13 – Victimization                                                                    Appendix B

**INTRO_5M  What is your month of birth?** (month)

            |__|__|  *[CATI:  1-12]*
**INTRO_5D  What is your day of birth?** (day)

            |__|__|  *[CATI:  1-31]*

TE1    **To reach you for this interview, I dialed** *(fill phone number)***.**
       **Excluding cellular telephones, is this your household's only telephone number?**

       (Because the survey sample is based on random telephone numbers,
       households with more than one telephone number have a greater chance of being
       selected for the survey. We need to ask a few questions to adjust for this.)

       (1)     Yes             *[Go to START]*
       (3)     No
       (r)     Refused         *[Go to START]*

TE2    **Including** *(fill phone number)***, how many telephone numbers does your household have?**

       **INT:===Respondent must have at least two telephone numbers in this question since they
       indicated in TE1 that** *(fill phone number)* **is not their only telephone number===**

       |__|__|  *[CATI: 2-10]*
       (r)     Refused         *[Go to START]*

TE3    **Are any of these numbers for computer, fax or business use only?**

       (1)  Yes
       (3)  No          *[Go to START]*
       (r)  Refused     *[Go to START]*

TE4    **How many of these numbers are for computer, fax or business use only?**

       |__|__|  *[CATI: 1-10]*
       (r)   Refused

*CATI-TE4e:  If TE4 < TE2 then Go to START; else do CATI Error screen:*

3

--- page 8 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

*CATI Error screen:*
      **You just said that you have** [fill TE4] **telephone numbers for computer, fax or business use only.
      This number is greater than/equal to the** [fill TE2] **telephone numbers reported for your
      household..**
      **Which number should be  corrected?**

   (1)  Correct number of computer, fax, business phone numbers  in TE4
   (2)  Correct total number of phone numbers for household in TE2
   (3)  Correct both numbers  in TE2 and TE4
   (r)  Refusal             *[Go to START]*]

*[CATI - INTRO_6]: [Go to START]*

--- page 9 ---

GSS – Cycle 13 – Victimization                                                                                              Appendix B

Housing Family and Social Statistics Division
1999 General Social Survey
Victimization Questionnaire
Ages 15 Years and over

GSS 13-2
Confidential when completed
Collected under the authority of the Statistics
Act, Revised Statutes of Canada, 1985, Chapter S19.
STC/HFS-027-75137

Telephone Number |___|___|___| - |___|___|___| - |___|___|___|___|

Label Identification Number  |___|___|___|___|___|

Page-line Number     |___|___|

Type  | 1 |
Name of Interviewer:

GSS 13-2 - GENERAL SOCIAL SURVEY

START       Date / Time stamp

INTRO.
     INT:===Repeat the introduction below if selected respondent is different from household
     respondent.===

     Hello, I'm ............. from Statistics Canada.  We are calling you for a study on Canadians' safety.
     The purpose of the study is to better understand people's perception of crime and the justice
     system, and the extent of victimization in Canada.

     All information we collect in this voluntary study will be kept confidential.  Your participation is
     essential if the survey results are to be accurate.  Your responses represent those of approximately
     1,000 other Canadians.

     My supervisor is working with me today and may listen to the interview to evaluate the survey.

5

--- page 10 ---

GSS – Cycle 13 – Victimization                                                                                              Appendix B

SECTION A:  PERCEPTIONS, HISTORY AND RISK
A0     *Date / Time stamp*
A1     **Let's begin with some general questions on crime and safety.**
.       **Compared to other areas in Canada, do you think  your neighbourhood has a higher amount of crime,  about the same or a lower amount of crime?**

       (Neighbourhood refers to the area surrounding your home.)

       (1)       Higher
       (2)       About the same
       (3)       Lower
       (x)       Don't know
       (r)       Refused

A2     **During the last 5 years, do you think that crime in your neighbourhood has increased, decreased, or remained about the same?**

       **INT:===If the respondent has just moved into the neighbourhood and has not lived there long enough to have an opinion, select "don't know"===**

       (1)       Increased
       (2)       Decreased
       (3)       About the same
       (x)       Don't know
       (r)       Refused

A3     **Now, I am going to ask you about some everyday situations, and I would like you to tell me how safe you feel from crime in each situation.  How safe do you feel from crime walking ALONE in your area after dark?  Do you feel ....**

       **INT:===If respondent cannot walk, ask if they would go out in a wheelchair.===**

                              **INT: ===READ LIST===**

       (1)       Very safe?
       (2)       Reasonably safe?
       (3)       Somewhat unsafe?
       (4)       Very unsafe?

       (5)       Does not walk alone          *[Go to A5]*
       (x)       Don't know
       (r)       Refused                      *[Go to A6]*

6

--- page 11 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

A4     **How often do you walk ALONE in your area after dark?**

                                        **INT:===READ LIST===**

        (1)     Daily?                          *[Go to A6]*
        (2)     At least once a week?
        (3)     At least once a month?
        (4)     Less than once a month?
        (5)     Never?

        (r)     Refused                         *[Go to A6]*

*CATI A4e -  If A3 = (1)  then [Go to A6].*

A5     **If you felt safer from crime, would you do this (more often)?**

        (1)     Yes
        (3)     No
        (x)     Don't know
        (r)     Refused

A6     **While waiting for or using public transportation ALONE after dark, do you feel...**

                                        **INT:===READ LIST===**

        (1)     Very worried?
        (2)     Somewhat worried?
        (3)     Not at all worried about your safety from crime?

        (4)     Does not use public transportation/night          *[Go to A8]*
        (5)     No public transportation available                *[Go to A9]*
        (x)     Don't know
        (r)     Refused                                           *[Go to A9]*

A7     **How often do you use public transportation ALONE after dark?**

                                        **INT:===READ LIST===**

        (1)     Daily?...                       *[Go to A9]*
        (2)     At least once a week?
        (3)     At least once a month?
        (4)     Less than once a month?
        (5)     Never?

        (r)     Refused                         *[Go to A9]*

*CATI A7e -  If A6 = (3) then [Go to A9].*

7

--- page 12 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

A8     **If you felt safer from crime, would you use public transportation ALONE after dark (more often)?**

         (1)          Yes
         (3)          No
         (x)          Don't know
         (r)          Refused

A9     **When ALONE in your home in the evening or at night, do you feel...**

                                          INT: ===READ LIST===

         (1)          Very worried?
         (2)          Somewhat worried?
         (3)          Not at all worried about your safety from crime?

         (4)          Never alone
         (x)          Don't know
         (r)          Refused

A10    **Do you think your local police force does a good job, an average job or a poor job …**

         ("Local police force" refers to the police responsible for your municipality.  Exclude security guards,
         fire marshals and all others who have no authority to make arrests.)

                                          INT: ===READ LIST===

                                                             Good Average Poor  Don't    Refused
                                                             job   job    job   know

         a)          of enforcing the laws?                  (1)   (2)    (3)   (x)      (r)
         b)          of promptly responding to calls?        (1)   (2)    (3)   (x)      (r)
         c)          of being approachable and easy to talk to?  (1)  (2) (3)   (x)      (r)
         d)          of supplying information to the public on
                     ways to reduce crime?                   (1)   (2)    (3)   (x)      (r)
         e)          of ensuring the safety of the citizens of
                     your area?                              (1)   (2)    (3)   (x)      (r)

8

--- page 13 ---

GSS – Cycle 13 – Victimization                                                                                              Appendix B

A11   **Now I would like to ask you a similar question about  the Canadian CRIMINAL courts.  Are they doing a good job, an average job or a poor job …**

                                        INT: ===READ LIST===

                                                      Good  Average   Poor    Don't  Refused
                                                      job     job      job    know

   a)        of providing justice quickly?             (1)     (2)      (3)     (x)     (r)
   b)        of helping the victim?                    (1)     (2)      (3)     (x)     (r)
   c)        of determining whether the accused or
               the person charged is guilty or not?    (1)     (2)      (3)     (x)     (r)
   d)        of ensuring a fair trial for the accused? (1)     (2)      (3)     (x)     (r)


A13   **Do you think that the PRISON SYSTEM does a good job, an average job or a poor job …**

                                        INT: ===READ LIST===

                                                      Good  Average   Poor    Don't  Refused
                                                      job     job      job    know

   a)        of supervising and controlling prisoners
               while in prison?                        (1)     (2)      (3)     (x)     (r)
   b)        of helping prisoners become law-abiding
               citizens?                               (1)     (2)      (3)     (x)     (r)


A14   **Do you think that the PAROLE SYSTEM does a good job, an average job or a poor job …**

(The responsibility of the parole system is to decide which prison inmates can serve part
of their sentence in the community under supervision and to make sure the conditions of parole
are being met. If offenders don't meet parole conditions they can be returned to prison.)

                                        INT: ===READ LIST===

                                                      Good  Average  Poor  Don't  Refused
                                                      job     job     job   know

   a)        of releasing offenders who are not likely to
               commit another crime?                   (1)     (2)      (3)     (x)     (r)
   b)        of supervising offenders on parole?       (1)     (2)      (3)     (x)     (r)

--- page 14 ---

GSS – Cycle 13 – Victimization                                                                                              Appendix B

A19    **During the past 12 MONTHS, did you come into contact with the police …**

                                         **INT: ===READ LIST===**

                                              Yes    No     Refused
        a)       for a public information session?          (1)    (3)     (r)
        b)       for a traffic violation?                   (1)    (3)     (r)
        c)       as a victim of a crime?                    (1)    (3)     (r)
        d)       as a witness to a crime?                   (1)    (3)     (r)
        e)       by being arrested?                         (1)    (3)     (r)
        f)       for any other reason?                      (1)    (3)     (r)

*CATI-A19e: If A19f) = (1),  [Go to A19S];  Else, [Go to A19A].*

A19S   Specify....
       |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
       |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
*[CATI]: Length of field = 50*

A19A   **Have you ever had contact with the Canadian CRIMINAL courts?**

       Exclude family and traffic courts)

        (1)      Yes
        (3)      No
        (r)      Refused

A20    **On average, how many times a month do you go out during the EVENING to do the following activities?**

       **INT:===If respondent states "Less than once a month" enter (95). If the respondent says "Never" enter (0). If the respondent answers in weeks, multiply by four to convert that amount into times per month===**

                                         **INT:===READ LIST===**

                                                                        No. of times          Refused
                                                                        a month
        a)       Work nights, attend night classes, go to
                     meetings or do volunteer work?                      |__|__|  *[CATI: 0-95]*    (r)
        b)       Go to restaurants, movies or the theatre?              |__|__|  *[CATI: 0-95]*    (r)
        c)       Go to bars or pubs? (include comedy clubs)             |__|__|  *[CATI: 0-95]*    (r)
        d)       Go out for sports, exercise or recreational activities?
                     (as participant or spectator)                       |__|__|  *[CATI: 0-95]*    (r)
        e)       Shop? (include window shopping)                        |__|__|  *[CATI: 0-95]*    (r)
        f)       Visit relatives or friends in their HOMES?             |__|__|  *[CATI: 0-95]*    (r)
        g)       Go to casinos or bingos                                |__|__|  *[CATI: 0-95]*    (r)
        h)       Other evening activities not already mentioned?        |__|__|  *[CATI: 0-95]*    (r)

10

--- page 15 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

CATI-A20e - Soft edit: If (A20a) or A20b) or A20c) or A20d) or A20e) or A20f) or A20g) or A20h))
                >= (31) then interviewer verify.

A21    Have you ever done any of the following things to PROTECT yourself or your property from
       crime?  Have you ever . . .

       INT:===Probe to be sure action was taken as a protection from  crime===

                                    INT: ===READ LIST===
                                                                    Yes    No   Refused
       a)         changed your routine, activities, or avoided
                       certain places?                              (1)    (3)    (r)
       b)         installed new locks or security bars?             (1)    (3)    (r)
       c)         installed burglar alarms or motion detector lights?  (1) (3)   (r)
       d)         taken a self defense course?                      (1)    (3)    (r)
       e)         changed your phone number?                        (1)    (3)    (r)
       f)         obtained a dog?                                   (1)    (3)    (r)
       g)         obtained a gun?                                   (1)    (3)    (r)
       h)         changed residence or moved?                       (1)    (3)    (r)

CATI-A21e:   After each  question A21a) to A21h) follow the model:
             If  A21a)  = (1) - Go to A21Aa;  Else Go to A21b);
             Repeat for A21b) to A21g);
             If A21h) = (1) - Go to A21Ah ; Else Go to A22.

A21A  Have you done this in the last 12 months?
a to h
       (1)        Yes
       (3)        No
       (r)        Refused

A22    Do you do any of the following things to make yourself safer from crime?  Do you routinely....

       (Routinely means "most of the time" even if you occasionally forget.)

                                    INT: ===READ LIST===

                                                                    Yes    No    Refused
       a)         carry something to defend yourself or to alert other people?   (1)  (3)   (r)
       b)         lock the car doors for your personal safety when alone in a car?  (1)  (3)  (r)
       c)         when alone and returning to a parked car, check the back seat
                       for intruders before getting into the car?  (1)  (3)   (r)
       d)         plan your route with safety in mind?             (1)  (3)   (r)
       e)         stay at home at night because you are afraid to go out alone?  (1)  (3)  (r)

11

--- page 16 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

A23    **Is there anything else you do to increase your personal safety that I have not already mentioned?**

        |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
        |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
        (n)     Nothing else
        (r)     Refused
*[CATI]: Length of field = 50*

A24    **In general, are you satisfied or dissatisfied with your personal safety from crime?**
                                              A24A  **Is that somewhat or very?**

                                         Somewhat     Very      Refused
        (1)     Satisfied           --->    (1)        (2)        (r)
        (2)     Dissatisfied        --->    (1)        (2)        (r)
        (3)     No opinion
        (r)     Refused

A25    **People have different ideas about the sentences that should be given to offenders.  There are two different types: prison sentences and non-prison sentences such as probation, fines, and community work.**

*CATI-A26e:  Assign respondent to answer ONE of the following 8 scenarios in random order.*
_______________________________________________________________________________
A26A  Scenario 1
        **If an  adult offender  is found guilty of breaking into a house when the owners are on vacation and taking goods worth $400 and this is the offender's first offence,  which sentence would you consider the most appropriate, a…**

                                         **INT:===READ LIST===**

        (1)     Prison sentence?
        (3)     Non-prison sentence?          *[Go to A26Y]*

        (x)     Don't know
        (r)     Refused

A26AP **If a judge sentenced the offender to one year of probation and 200 hours of community work,  would that be acceptable?**

        (1)     Yes
        (3)     No

        (x)     Don't know
        (r)     Refused

--- page 17 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

A26Y  **What if this were a  young offender  instead of an adult offender, which sentence would you consider the most appropriate, a …**

      (The  young offender  is found guilty of breaking into a house when the owners are on vacation and taking goods worth $400 and this is the offender's first offence.)

                                        **INT:===READ LIST===**

         (1)       Prison sentence?
         (3)       Non-prison sentence?          *[Go to B0]*

         (x)       Don't know
         (r)       Refused

A26YP  **If a judge sentenced the offender to one year of probation and 200 hours of community work, would that be acceptable?**

         (1)       Yes
         (3)       No

         (x)       Don't know
         (r)       Refused

*[Go to B0]*

A27Y   Scenario 2
       **If a  young offender  is found guilty of breaking into a house when the owners are on vacation and taking goods worth $400 and this is the offender's first offence, which sentence would you consider the most appropriate, a …**

                                        **INT:===READ LIST===**

         (1)       Prison sentence?
         (3)       Non-prison sentence?          *[Go to A27A]*

         (x)       Don't know
         (r)       Refused

A27YP  **If a judge sentenced the offender to one year of probation and 200 hours of community work, would that be acceptable?**

         (1)       Yes
         (3)       No

         (x)       Don't know
         (r)       Refused

13

--- page 18 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

A27A  **What if this were an adult offender instead of a young offender, which sentence would you
         consider the most appropriate, a …**

         (The adult offender is found guilty of breaking into a house when the owners are on vacation and taking
         goods worth $400 and this is the offender's first offence.)

                                          **INT:===READ LIST===**

         (1)     Prison sentence?
         (3)     Non-prison sentence?          *[Go to B0]*

         (x)     Don't know
         (r)     Refused

A27AP  **If a judge sentenced the offender to one year of probation and 200 hours of community work,
            would that be acceptable?**

         (1)     Yes
         (3)     No

         (x)     Don't know
         (r)     Refused

*[Go to B0]*

___________________________________________________________________________
A28A   Scenario 3
         **If an  adult offender  is found guilty for the first time of an assault and  the victim received minor
         injuries but did not require medical attention, which sentence would you consider the most
         appropriate, a …**

                                          **INT:===READ LIST===**

         (1)     Prison sentence?
         (3)     Non-prison sentence?          *[Go to A28Y]*

         (x)     Don't know
         (r)     Refused

A28AP  **If a judge sentenced the offender to one year of probation and 200 hours of community work,
            would that be acceptable?**

         (1)     Yes
         (3)     No

         (x)     Don't know
         (r)     Refused

14

--- page 19 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

A28Y  **What if this were a young offender instead of an adult offender, which sentence would you
         consider the most appropriate, a …**

         (The young offender is found guilty for the first time of an assault and the victim received minor injuries
         but did not require medical attention.)

                                           **INT:===READ LIST===**

         (1)       Prison sentence?
         (3)       Non-prison sentence?          *[Go to B0]*

         (x)       Don't know
         (r)       Refused

A28YP  **If a judge sentenced the offender to one year of probation and 200 hours of community work,
            would that be acceptable?**

         (1)       Yes
         (3)       No

         (x)       Don't know
         (r)       Refused

*[Go to B0]*

___________________________________________________________________________
A29Y  Scenario 4
         **If a  young offender is found guilty for the first time of an assault and the victim received minor
         injuries but did not require medical attention,  which sentence would you consider the most
         appropriate, a …**

                                           **INT:===READ LIST===**

         (1)       Prison sentence?
         (3)       Non-prison sentence?          *[Go to A29A]*

         (x)       Don't know
         (r)       Refused

A29YP  **If a judge sentenced the offender to one year of probation and 200 hours of community work,
            would that be acceptable?**

         (1)       Yes
         (3)       No

         (x)       Don't know
         (r)       Refused

15

--- page 20 ---

GSS – Cycle 13 – Victimization                                                                                     Appendix B

A29A  **What if this were an adult offender instead of a young offender, which sentence would you
      consider the most appropriate, a …**

      (The  adult offender is found guilty for the first time of an assault and the victim received minor injuries
      but did not require medical attention.)

                                        INT:===READ LIST===

         (1)       Prison sentence?
         (3)       Non-prison sentence?          *[Go to B0]*

         (x)       Don't know
         (r)       Refused

A29AP  **If a judge sentenced the offender to one year of probation and 200 hours of community work,
       would that be acceptable?**

         (1)       Yes
         (3)       No

         (x)       Don't know
         (r)       Refused

*[Go to B0]*

___________________________________________________________________________

A30A  Scenario 5
      **If an  adult offender is found guilty of breaking into a house when the owners are on vacation and
      taking goods worth $400 and the offender was found guilty of a similar offence once before, which
      sentence would you consider the most appropriate, a …**

                                        INT:===READ LIST===

         (1)       Prison sentence?
         (3)       Non-prison sentence?          *[Go to A30Y]*

         (x)       Don't know
         (r)       Refused

16

--- page 21 ---

GSS – Cycle 13 – Victimization                                                                                     Appendix B

A30AP  **If a judge sentenced the offender to one year of probation and 200 hours of community work, would that be acceptable?**

        (1)        Yes
        (3)        No

        (x)        Don't know
        (r)        Refused

A30Y  **What if this were a  young offender instead of an adult offender, which sentence would you consider the most appropriate, a …**

        (The young offender is found guilty of breaking into a house when the owners are on vacation
        and taking goods worth $400 and the offender was found guilty of a similar offence once before.)

                                        **INT:===READ LIST===**

        (1)        Prison sentence?
        (3)        Non-prison sentence?          *[Go to B0]*

        (x)        Don't know
        (r)        Refused

A30YP  **If a judge sentenced the offender to one year of probation and 200 hours of community work, would that be acceptable?**

        (1)        Yes
        (3)        No

        (x)        Don't know
        (r)        Refused

*[Go to B0]*

___________________________________________________________________________
A31Y  Scenario 6
        **If a  young offender is found guilty of breaking into a house when the owners are on vacation and taking goods worth $400 and the offender was found guilty of a similar offence once before, which sentence would you consider the most appropriate, a …**

                                        **INT:===READ LIST===**

        (1)        Prison sentence?
        (3)        Non-prison sentence?          *[Go to A31A]*

        (x)        Don't know
        (r)        Refused

17

--- page 22 ---

GSS – Cycle 13 – Victimization                                                                                               Appendix B

A31YP  **If a judge sentenced the offender to one year of probation and 200 hours of community work,
         would that be acceptable?**

        (1)       Yes
        (3)       No

        (x)       Don't know
        (r)       Refused

A31A  **What if this were an  adult offender instead of an young offender, which sentence would you
        consider the most appropriate, a …**

        (The adult offender is found guilty of breaking into a house when the owners are on vacation and taking
        goods worth $400 and the offender was found guilty of a similar offence once before.)

                                          **INT:===READ LIST===**

        (1)       Prison sentence?
        (3)       Non-prison sentence?          *[Go to B0]*

        (x)       Don't know
        (r)       Refused

A31AP  **If a judge sentenced the offender to one year of probation and 200 hours of community work,
         would that be acceptable?**

        (1)       Yes
        (3)       No

        (x)       Don't know
        (r)       Refused

*[Go to B0]*

___________________________________________________________________________
A32A  Scenario 7
        **If an  adult offender is found guilty of an assault and the victim received minor injuries but did
        not require medical attention and the offender was found guilty of a similar offence once before,
        which sentence would you consider the most appropriate, a …**

                                          **INT:===READ LIST===**

        (1)       Prison sentence?
        (3)       Non-prison sentence?          *[Go to A32Y]*

        (x)       Don't know
        (r)       Refused

18

--- page 23 ---

GSS – Cycle 13 – Victimization                                                                                               Appendix B

A32AP  **If a judge sentenced the offender to one year of probation and 200 hours of community work,
         would that be acceptable?**

        (1)       Yes
        (3)       No

        (x)       Don't know
        (r)       Refused

A32Y  **What if this were a  young offender  instead of an adult offender, which sentence would you
        consider the most appropriate, a …**

        (The young offender is found guilty of an assault and the victim received minor injuries but did not
        require medical attention and the offender was found guilty of a similar offence once before.)

                                          **INT:===READ LIST===**

        (1)       Prison sentence?
        (3)       Non-prison sentence?          *[Go to B0]*

        (x)       Don't know
        (r)       Refused

A32YP  **If a judge sentenced the offender to one year of probation and 200 hours of community work,
         would that be acceptable?**

        (1)       Yes
        (3)       No

        (x)       Don't know
        (r)       Refused

*[Go to B0]*

___________________________________________________________________________
A33Y  Scenario 8
        **If a  young offender  is found guilty of an assault and the victim received minor injuries but did
        not require medical attention and the offender was found guilty of a similar offence once before,
        which sentence would you consider the most appropriate, a …**

                                          **INT:===READ LIST===**

        (1)       Prison sentence?
        (3)       Non-prison sentence?          *[Go to A33A]*

        (x)       Don't know
        (r)       Refused

19

--- page 24 ---

GSS – Cycle 13 – Victimization                                                                                                       Appendix B

A33YP  **If a judge sentenced the offender to one year of probation and 200 hours of  community work,
         would that be acceptable?**

        (1)       Yes
        (3)       No

        (x)       Don't know
        (r)       Refused

A33A  **What if this were an  adult offender instead of a young offender, which sentence would you
        consider the most appropriate, a …**

        (The adult offender is found guilty of an assault and the victim received minor injuries but did not
        require medical attention and the offender was found guilty of a similar offence once before.)

                                          INT:===READ LIST===

        (1)       Prison sentence?
        (3)       Non-prison sentence?          *[Go to B0]*

        (x)       Don't know
        (r)       Refused

A33AP  **If a judge sentenced the offender to one year of probation and 200 hours of community work,
         would that be acceptable?**

        (1)       Yes
        (3)       No

        (x)       Don't know
        (r)       Refused

20

--- page 25 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

SECTION B:  CRIMINAL VICTIMIZATION SCREENING SECTION

B0     *Date / Time stamp*

B1     **The next questions ask about things which may have happened to you during the past
       12 months.  Please include acts committed by both family and non-family members.
       During the past 12 months, did anyone deliberately damage or destroy any property belonging
       to you or anyone in your household, such as a window or a fence?**

       **INT:===Record incidents of vandalism to a motor vehicle in question B6B===**
       (Exclude damage to the halls or elevators or to the outside of an apartment building.)

          (1)     Yes               *[Go to B1A]*
          (3)     No
          (x)     Don't know
          (r)     Refused

*[ Go to B2]*

B1A    **How many times did this happen?**

          |__|__| *[CATI: 1 - 99]*

*[CATI] soft edit: If B1A >10 confirm number.*

B2     **(Excluding incidents already mentioned,) during the past 12 months,  did anyone take or try to
       take something from you by force or threat of force?**

          (1)     Yes               *[Go to B2A]*
          (3)     No
          (x)     Don't know
          (r)     Refused

*[Go to B3]*

B2A    **How many times did this happen?**

          |__|__| *[CATI: 1 - 99]*

*[CATI] soft edit: If B2A >10 confirm number.*

21

--- page 26 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

B3     **(Other than the incidents already mentioned,) during the past 12 months, did anyone illegally break into or attempt to break into your residence or any other building on your property?**

        (1)     Yes             *[Go to B3A]*
        (3)     No
        (x)     Don't know
        (r)     Refused

*[ Go to B4A]*

B3A   **How many times did this happen?**

        |__|__| *[CATI: 1 - 99]*

*[CATI] soft edit: If B3A >10 confirm number.*

B4A   **(Other than the incidents already mentioned,) was anything of yours  stolen during   the past 12 months from the things usually kept outside your home, such as yard furniture?**

        (1)     Yes             *[Go to B4AA]*
        (3)     No
        (x)     Don't know
        (r)     Refused

*[ Go to B4B]*

B4AA **How many times did this happen?**

        |__|__| *[CATI: 1 - 99]*

*[CATI] soft edit: If B4AA >10 confirm number.*

B4B    **(Other than the incidents already mentioned,) was anything of yours  stolen during   the past 12 months from your place of work, from school or from a public place, such as a restaurant?**

        **INT:===Probe to ensure property taken was their own personal property and not property
                    belonging to their work place or school.===**

        (1)     Yes             *[Go to B4BA]*
        (3)     No
        (x)     Don't know
        (r)     Refused

*[ Go to B4C]*

22

--- page 27 ---

GSS – Cycle 13 – Victimization                                                                                              Appendix B

B4BA  **How many times did this happen?**

         |__|__| *[CATI: 1 - 99]*

*[CATI] soft edit: If B4BA >10 confirm number.*

B4C    **(Other than the incidents already mentioned,) was anything of yours  stolen during   the
         past 12 months from a hotel, vacation home, cottage, car, truck or while travelling?**

         (1)     Yes               *[Go to B4CA]*
         (3)     No
         (x)     Don't know
         (r)     Refused

*[ Go to B5]*

B4CA  **How many times did this happen?**

         |__|__| *[CATI: 1 - 99]*

*[CATI] soft edit: If B4CA >10 confirm number.*

B5      **During the past 12 months, did you or anyone in your household have a motor vehicle, such as a
         car, truck, motorcycle, etc.?**

         (1)     Yes               *[Go to B6A]*
         (3)     No                *[Go to CATI-B5e]*
         (r)     Refused           *[Go to B7]*

*CATI-B5e: Soft edit:  If B5 = (3) then interviewer ask:*
         **I would like to confirm that you or no one else in your household owns or leases a car or another
         motor vehicle?**

         *(1)     Accept          [Go to B7]*
         *(3)     Correct B5*

B6A    **(Other than the incidents already mentioned,) did anyone steal or try to steal one of these
         vehicles or a part of one of them, such as a battery, hubcap or radio?**

         (1)     Yes               *[Go to B6AA]*
         (3)     No
         (x)     Don't know
         (r)     Refused

*[Go to B6B]*

23

--- page 28 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

B6AA  **How many times did this happen?**

        |__|__| *[CATI: 1 - 99]*

*[CATI] soft edit: If B6AA >10 confirm number.*

B6B     **(Other than the incidents already mentioned,) did anyone deliberately damage one of these
        vehicles, such as slashing tires?**

        (1)     Yes             *[Go to B6BA]*
        (3)     No
        (x)     Don't know
        (r)     Refused

*[ Go to B7]*


B6BA  **How many times did this happen?**

        |__|__| *[CATI: 1 - 99]*

*[CATI] soft edit: If B6BA >10 confirm number.*

B7      **(Excluding the incidents already mentioned,) during the past 12 months, did anyone steal
        or try to steal anything else that belonged to you?**

        (1)     Yes             *[Go to B7A]*
        (3)     No
        (x)     Don't know
        (r)     Refused

*[ Go to  CATI-B7e].*

B7A   **How many times did this happen?**

        |__|__| *[CATI: 1 - 99]*

*[CATI] soft edit: If B7A >10 confirm number.*

*CATI-B7e:  Verify household roster - if respondent >=65 Go to B11A.*

24

--- page 29 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

B8A   **Now I'm going to ask you about being attacked in the past 12 months.  An attack can be anything from being hit, slapped, pushed or grabbed, to being shot or beaten.
(Excluding  incidents already mentioned, and) excluding acts committed by current or previous spouses or common-law partners, were you  attacked by anyone?**

         (1)       Yes              *[Go to B8AA]*
         (3)       No
         (x)       Don't know
         (r)       Refused

*[Go to  B8B]*

B8AA  **How many times did this happen?**

         |__|__|  *[CATI: 1 - 99]*

*[CATI] soft edit: If B8AA >10 confirm number.*

B8B    **(Other than the incidents already mentioned, and) again excluding acts committed by current or previous spouses or common-law partners, did anyone THREATEN to hit or attack you, or threaten you with a weapon?**

         (1)       Yes              *[Go to B8BA]*
         (3)       No
         (x)       Don't know
         (r)       Refused
*[ Go to B9]*

B8BA  **How many times did this happen?**

         |__|__|  *[CATI: 1 - 99]*

*[CATI] soft edit: If B8BA >10 confirm number.*

B9      **(Excluding incidents already mentioned,) during the past 12 months, has anyone forced you or attempted to force you into any unwanted sexual activity, by threatening you, holding you down or hurting you in some way?  This includes acts by family and non-family but excludes acts by current or previous spouses or common-law partners.  Remember  that all information provided is strictly confidential.**

         (1)       Yes              *[Go to B9A]*
         (3)       No
         (x)       Don't know
         (r)       Refused

*[ Go to B10]*

25

--- page 30 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

B9A  **How many times did this happen?**

        |__|__| *[CATI: 1 - 99]*

*[CATI] soft edit: If B9A >10 confirm number.*

B10  **(Apart from what you have told me,) during the past 12 months, has anyone ever touched you
       against your will in any sexual way? By this I mean anything from unwanted touching
       or grabbing, to kissing or fondling. Again, please exclude acts by current or previous spouses
       or common-law partners.**

        (1)     Yes             *[Go to B10A]*
        (3)     No
        (x)     Don't know
        (r)     Refused

 *[Go to B14]*

B10A  **How many times did this happen?**

        |__|__| *[CATI: 1 - 99]*

*[CATI] soft edit: If B10A >10 confirm number.*

*[ Go to B14]*

B11A  **Now I'm going to ask you about being attacked in the past 12 months.  An attack can be
        anything from being hit, slapped, pushed or grabbed, to being shot or beaten.
        (Excluding  incidents already mentioned, and) excluding acts committed by current or
        previous spouses or common-law partners, children, or caregivers, were you attacked
        by anyone?**

        (1)     Yes             *[Go to B11AA]*
        (3)     No
        (x)     Don't know
        (r)     Refused

*[ Go to B11B]*

B11AA  **How many times did this happen?**

        |__|__| *[CATI: 1 - 99]*

*[CATI] soft edit: If B11AA >10 confirm number.*

26

--- page 31 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

B11B  **(Other than the incidents already mentioned, and) again excluding acts committed by current or previous spouses or common-law partners, children or caregivers,  did anyone threaten to hit or attack you, or threaten you with a weapon?**

        (1)        Yes              *[Go to B11BA]*
        (3)        No
        (x)        Don't know
        (r)        Refused

*[ Go to B12]*

B11BA  **How many times did this happen?**

        |__|__|  *[CATI: 1 - 99]*

*[CATI] soft edit: If B11BA >10 confirm number.*

B12    **(Excluding incidents already mentioned,) during the past 12 months, has anyone forced you or attempted to force you into any unwanted sexual activity, by threatening you, holding you down or hurting you in some way?  This includes acts by family and non-family but excludes acts by current or previous spouses or common-law partners or caregivers.  Remember that all information provided is strictly confidential.**

        (1)        Yes              *[Go to B12A]*
        (3)        No
        (x)        Don't know
        (r)        Refused

*[ Go to B13]*

B12A  **How many times did this happen?**

        |__|__|  *[CATI: 1 - 99]*

*[CATI] soft edit: If B12A >10 confirm number.*

B13    **(Apart from what you have told me,) during the past 12 months, has anyone ever touched you against your will in any sexual way?  By this I mean anything from unwanted touching or grabbing, to kissing or fondling.  Again, please exclude acts by current or previous spouses or common-law partners or caregivers.**

        (1)        Yes              *[Go to B13A]*
        (3)        No
        (x)        Don't know
        (r)        Refused

*[Go to B14]*

27

--- page 32 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

B13A  **How many times did this happen?**

        |__|__| *[CATI: 1 - 99]*

*[CATI] soft edit: If B13A >10 confirm number.*

B14    **Were there any other crimes which happened to you during the past 12 months, which
        may or may not have been reported to the police?**

        (1)     Yes          *[Go to B14S]*
        (3)     No
        (x)     Don't know
        (r)     Refused

*[ Go to CATI-B14e]*

B14S  **What were these crimes?**

        _______________________________________________________________

        _______________________________________________________________

        (r) Refused
*CATI: Length of field = 99*

B14A  **How many were there?**

        |__|__| *[CATI: 1 - 99]*

*[CATI] soft edit: If B14A >10 confirm number.*

___________________________________________________________________________________________
*CATI-B14e:    Total the number of incidents reported in B1A, B2A, B3A, B4AA, B4BA, B4CA, B6AA, B6BA,
               B7A, B8AA, B8BA, B9A, B10A, B11AA, B11BA, B12A, B13A, and B14A then enter in
               TOTB.*

*If TOTB = 0 Go to C0;*

*CATI Section B Verification Screen:*
        **I would like to confirm the information you have given me.  You said you were a victim of crime
        on [insert TOTB] (separate) occasion(s) in the past 12 months.  Is this correct?**

        *(1)*     *Yes*     *[Go to C0]*
        *(3)*     *No*      *[Go to VSCRNO Screen and select incorrect question on screen then correct the
                            appropriate questions in Section B.]*

28

--- page 33 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

SECTION C: EMOTIONAL AND FINANCIAL ABUSE BY A SPOUSE/PARTNER

C0     Date / Time stamp

CATI-C0e:  Verify respondent's current marital status from the household roster.  If married or living common
                    -law, or same-sex partner  - Go to C1;  Else [Go to E0].

C1Y   **Now I would like to ask you about some things concerning your spouse/partner.  We're interested
         in knowing how long you've been married or living together/living together.  In what year were
         you married or started living together/did you start living together?**

         **INT:====If the couple lived common-law before getting married, ask the respondent when they
         started living together.  We want to know the total length of time that the couple has lived
         together. ====**

         Year
         |__|__|__|__|  *[CATI: 1920-1999]*
         (x)       Don't know
         (r)       Refused

*CATI-C1e: If C1YEAR < 1994 or (x) or (r) then Go to C2.*

C1M   **In what month?**

         Month
         |__|__|  *[CATI: 1-12]*
         (x)       Don't know
         (r)       Refused

C2     **I'm going to read a list of statements that some people have used to describe their spouse/partner.
         I'd like you to tell me whether or not each statement describes your spouse/partner.**

         **(Please remember that all information provided is strictly confidential.)**

         **He/She tries to limit your contact with family or friends.**

         (1)       Yes
         (3)       No
         (r)       Refused

C3     **He/She puts you down or calls you names to make you feel bad.**

         (Does this statement describe your spouse/partner?)

         (1)       Yes
         (3)       No
         (r)       Refused

29

--- page 34 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

C4     **He/She is jealous and doesn't want you to talk to other men/women.**

       (Does this statement describe your spouse/partner?)

       (1)       Yes
       (3)       No
       (r)       Refused

C5     **He/She harms, or threatens to harm, someone close to you.**

       (Does this statement describe your spouse/partner?)

       (1)       Yes
       (3)       No
       (r)       Refused

C6     **He/She demands to know who you are with and where you are at all times.**

       (Does this statement describe your spouse/partner?)

       (1)       Yes
       (3)       No
       (r)       Refused

C7     **He/She damages or destroys your possessions or property.**

       (Does this statement describe your spouse/partner?)

       (1)       Yes
       (3)       No
       (r)       Refused

C8     **He/She prevents you from knowing about or having access to the family income, even if you ask.**

       (Does this statement describe your spouse/partner?)

       (1)       Yes
       (3)       No
       (r)       Refused

30

--- page 35 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

SECTION D: PHYSICAL AND SEXUAL VIOLENCE BY A SPOUSE/PARTNER

*D0     Date / Time stamp*

D1     **It is important to hear from people themselves if we are to understand the serious problem of
     violence in the home.  I'm going to ask you ten short questions and I'd like you to tell me whether,
     in the past 5 years, your CURRENT spouse/partner has done any of the following to you.  Your
     responses are important whether or not you have had any of these experiences.  Remember that
     all information provided is strictly confidential.**

     **During the past 5 years, has your current spouse/partner THREATENED to hit you with his/her
     fist or anything else that could have hurt you?**

          (1)          Yes
          (3)          No
          (r)          Refused

D2     **(During the past 5 years,)  has he/she THROWN anything at you that could have hurt you?**

          (1)          Yes
          (3)          No
          (r)          Refused

D3     **(During the past 5 years,) has he/she pushed, grabbed or shoved you in a way that could have hurt
     you?**

          (1)          Yes
          (3)          No
          (r)          Refused

D4     **(During the past 5 years,)  has he/she slapped you?**

          (1)          Yes
          (3)          No
          (r)          Refused

D5     **(During the past 5 years,)  has he/she kicked you, bit you, or hit you with his/her fist?**

          (1)          Yes
          (3)          No
          (r)          Refused

31

--- page 36 ---

GSS – Cycle 13 – Victimization                                                                                              Appendix B

D6     **(During the past 5 years,)  has he/she hit you with something that could have hurt you?**

         (Do not include hitting with fist)

         (1)       Yes
         (3)       No
         (r)       Refused

D7     **(During the past 5 years,)  has he/she beaten you?**

         (1)       Yes
         (3)       No
         (r)       Refused

D8     **(During the past 5 years,)  has he/she choked you?**

         (1)       Yes
         (3)       No
         (r)       Refused

D9     **(During the past 5 years,)  has he/she USED or THREATENED TO USE a gun or knife on you?**

         (1)       Yes
         (3)       No
         (r)       Refused

D10   **(During the past 5 years,) has he/she forced you into any unwanted sexual activity, by threatening you, holding you down, or hurting you in some way?**

         (1)       Yes
         (3)       No
         (r)       Refused

*CATI-D10e:   If any of D1 to D10 =(1) then SPABUSE = (1);  else SPABUSE = (0) and Go to E0.*

D11   **You said yes to at least one of the previous ten questions concerning violence.  During the past 5 years, has he/she been violent towards you on more than one occasion?**

         (1)       Yes
         (3)       No          *[Go to D14]*
         (r)       Refused     *[Go to D14]*

32

--- page 37 ---

GSS – Cycle 13 – Victimization                                                                                              Appendix B

D12    **How many different times did these things happen?**

         (2)       Two
         (3)       Three
         (4)       Four
         (5)       Five
         (6)       Six
         (7)       Seven
         (8)       Eight
         (9)       Nine
         (10)      Ten
         (11)      More than ten
         (x)       Don't know
         (r)       Refused


D13    **How many of these were in the past 12 months?**

         |__|__| *[CATI: 0-99]*
         (x)       Don't know
         (r)       Refused

*CATI-D13e - Hard edit.  If D12 NE (11) nor (x) nor (r) then D13 must be =< D12.  If not then:*

         *(1)       Correct D12*
         *(3)       Correct D13*

D14    **When did this happen (the most recent happen)?**

         Year
         |__|__|__|__| *[CATI: 1994-1999]*
         (x)       Don't know
         (r)       Refused

         Month
         |__|__| *[CATI: 1-12]*
         (x)       Don't know
         (r)       Refused

*CATI-D14e:  If C1 > 5 years then Go to D15B).*

D15A  **Did this (any of these) incident(s) in the past 5 years happen before you were married or living
         common-law?**

         (1)       Yes
         (3)       No
         (r)       Refused

33

--- page 38 ---

GSS – Cycle 13 – Victimization                                                                    Appendix B

*CATI-D15Ae:  If D11 = 3 and D15A = 1 Go to E0.*

D15B  **Did this (any of these) incident(s) in the past 5 years happen while you were married or living
         common-law?**

         (1)       Yes
         (3)       No
         (r)       Refused

*CATI-D15Be:  If D11 = 3 and D15B = 1 Go to E0.*

D15C  **Did this (any of these) incident(s) in the past 5 years happen  while you were temporarily
         separated?**

         (1)       Yes
         (3)       No
         (5)       No, never separated
         (r)       Refused

SECTION E: EMOTIONAL AND FINANCIAL ABUSE BY AN EX-PARTNER

*E0      Date / Time stamp*

*CATI-E0e: Verify respondent's current marital status from the household roster:
            If married or living common-law or same sex partner  - Go to E1;
            Else if widowed, divorced or separated – Go to E0AA;
            Else – Go to E0A.*

E0A   **Have you ever been married or in a common-law relationship?**

         (By common-law we mean partners living together as a couple without being legally married).

         (1)       Yes
         (3)       No          *[Go to G0]*
         (r)       Refused     *[Go to G0]*

E0AA  **In the past 5 years, have you had any contact with any previous partner?**

         (Contact includes receiving letters or telephone calls).

         (1)       Yes
         (3)       No          *[Go to G0]*
         (r)       Refused     *[Go to G0]*

34

--- page 39 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

E0B	**Now I'm going to ask you about some things that may have happened with your previous partner. I'm going to read a list of statements that some people have used to describe their partner. I'd like you to tell me whether or not each statement describes your ex-partner. (Please remember that all information provided is strictly confidential.)**

*[Go to E2]*

E1	**Have you ever been in any other marriage or common-law relationship with a person other than your current spouse/partner?**

         (1)     Yes
         (3)     No          *[Go to G0]*
         (r)     Refused     *[Go to G0]*

E1A	**In the past 5 years, have you had any contact with any previous partner?**

         (Contact includes receiving letters or telephone calls).

         (1)     Yes
         (3)     No          *[Go to G0]*
         (r)     Refused     *[Go to G0]*

E1B	**Now I'd like to read a list of statements that may apply to your PREVIOUS partner, and I'd like you to tell me whether each statement describes your ex-partner. (Please remember that all information provided is strictly confidential.)**

E2	**He/She tried to limit your contact with family or friends.**

         (1)     Yes
         (3)     No
         (r)     Refused

E3	**He/She put you down or called you names to make you feel bad.**

         (Does this statement describe your ex-partner?)

         (1)     Yes
         (3)     No
         (r)     Refused

E4	**He/She was jealous and didn't want you to talk to other men/women.**

         (Does this statement describe your ex-partner?)

         (1)     Yes
         (3)     No
         (r)     Refused

35

--- page 40 ---

GSS – Cycle 13 – Victimization                                                                                              Appendix B

E5     **He/She harmed, or threatened to harm, someone close to you.**

       (Does this statement describe your ex-partner?)

       (1)     Yes
       (3)     No
       (r)     Refused

E6     **He/She demanded to know who you were with and where you were at all times.**

       (Does this statement describe your ex-partner?)

       (1)     Yes
       (3)     No
       (r)     Refused

E7     **He/She damaged or destroyed your possessions or property.**

       (Does this statement describe your ex-partner?)

       (1)     Yes
       (3)     No
       (r)     Refused

E8     **He/She prevented you from knowing about or having access to the family income, even if you
       asked.**

       (Does this statement describe your ex-partner?)

       (1)     Yes
       (3)     No
       (r)     Refused

36

--- page 41 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

SECTION F: PHYSICAL AND SEXUAL VIOLENCE BY AN EX-PARTNER

F0     Date / Time stamp

CATI-F0e.: Verify respondent's current marital status from the household roster.  If married or living common-
          law or same sex partner - Go to F0B.

F0A   **It is important to hear from people themselves if we are to understand the serious problem of
      violence in the home.  I'm going to ask you ten short questions and I'd like you to tell me if in the
      past 5 years, your PREVIOUS partner did any of the following to you.  Your responses are
      important whether or not you have had any of these experiences. Please remember that all
      information provided is strictly confidential.**

 *[Go to F1]*

F0B   **The following ten short questions refer to your PREVIOUS partner.  I'd like you to tell me if in
      the past 5 years, your PREVIOUS partner did any of the following to you.  Again, your responses
      are important whether or not you have had any of these experiences. Please remember that all
      information provided is strictly confidential.**

F1     **During the past 5 years,  did your previous partner THREATEN to hit you with his/her fist or
       anything else that could have hurt you?**

       (1)     Yes
       (3)     No
       (r)     Refused

F2     **(During the past 5 years,)  did he/she THROW anything at you that could have hurt you?**

       (1)     Yes
       (3)     No
       (r)     Refused

F3     **(During the past 5 years,)  did he/she push, grab, or shove you in a way that could have hurt you?**

       (1)     Yes
       (3)     No
       (r)     Refused

F4     **(During the past 5 years,)  did he/she slap you?**

       (1)     Yes
       (3)     No
       (r)     Refused

37

--- page 42 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

F5     **(During the past 5 years,)  did he/she kick you, bite you, or hit you with his/her fist?**

         (1)       Yes
         (3)       No
         (r)       Refused

F6     **(During the past 5 years,)  did he/she hit you with something that could have hurt you?**

         (Do not include hitting with fist)

         (1)       Yes
         (3)       No
         (r)       Refused

F7     **(During the past 5 years,)  did he/she beat you?**

         (1)       Yes
         (3)       No
         (r)       Refused

F8     **(During the past 5 years,)  did he/she choke you?**

         (1)       Yes
         (3)       No
         (r)       Refused

F9     **(During the past 5 years,)  did he/she USE or THREATEN TO USE a gun or knife on you?**

         (1)       Yes
         (3)       No
         (r)       Refused

F10    **(During the past 5 years,)  did he/she force you into any unwanted sexual activity, by threatening you, holding you down, or hurting you in some way?**

         (1)       Yes
         (3)       No
         (r)       Refused

*CATI-F10e - If any of F1 to F10 =(1) then EXABUSE = (1);  else EXABUSE = (0) and Go to G0.*

F11    **You said yes to at least one of the previous ten questions concerning violence.  During the past 5 years, was he/she violent towards you on more than one occasion?**

         (1)       Yes
         (3)       No          *[Go to F14]*
         (r)       Refused     *[Go to F14]*

38

--- page 43 ---

GSS – Cycle 13 – Victimization                                                                                              Appendix B

F12    **How many different times did these things happen?**

        (2)     Two
        (3)     Three
        (4)     Four
        (5)     Five
        (6)     Six
        (7)     Seven
        (8)     Eight
        (9)     Nine
        (10)    Ten
        (11)    More than ten
        (x)     Don't know
        (r)     Refused

F13    **How many of these were in the past 12 months?**

        |__|__| *[CATI: 0-99]*
        (x)     Don't know
        (r)     Refused

*CATI-F13e - Hard edit.  If F12 NE (11) nor (x) nor (r) then F13must be  =< F12.  If not then:*
        *(1)     Correct F12*
        *(3)     Correct F13*

F14    **When did this happen (the most recent happen)?**

        Year
        |__|__|__|__|  *[CATI: 1994-1999]*
        (x)     Don't know
        (r)     Refused

        Month
        |__|__| *[CATI: 1-12]*
        (x)     Don't know
        (r)     Refused

F15    **Did the(any of the) violence happen while you were living together?**

        (1)     Yes
        (3)     No
        (x)     Don't know
        (r)     Refused

*CATI-F15e -   If F11 =(3) and F15 =(1) Go to G0.*

39

--- page 44 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

F16    **Did any of the violence happen after you split up?**

        (1)     Yes
        (3)     No
        (5)     Did not separate, partner died          *[Go to G0]*
        (x)     Don't know                              *[Go to G0]*
        (r)     Refused                                 *[Go to G0]*

*CATI-F16e:   If F15 = (1) and F16 = (1) Go to F17*
              *If F15 = (3) and F16 =(3) then CATI Error Screen; else Go to G0.*

*CATI Error Screen:*
        **You said that during the past 5 years your ex-partner was violent towards you. You
        said that it didn't happen while you were living together or after you split up. Is this correct?**

        *(1)     Correct F15*
        *(2)     Correct F16*
        *(3)     Accept as is     [Go to G0]*

F17    **Do you think it increased after you split up?**

        (1)     Yes
        (3)     No
        (x)     Don't know
        (r)     Refused

40

--- page 45 ---

GSS – Cycle 13 – Victimization                                                                    Appendix B

SECTION G: EMOTIONAL AND FINANCIAL ABUSE BY CHILDREN

*G0     Date / Time stamp*

*CATI-G0e: Verify household roster -  If respondent <65 Go to K15;
                                       If respondent is living with child(children), Go to G3.*

G1    **Have you ever had any children?  Include birth, step and adopted children.**

         (1)      Yes
         (3)      No                    *[Go to J0]*
         (r)      Refused               *[Go to J0]*

G2    **During the past 5 years, how often did you have contact with any of your children?**

         (Contact includes receiving letters or telephone calls).

                                        **INT:===READ LIST===**

         (1)      Daily
         (2)      At least once a week
         (3)      At least once a month
         (4)      Less than once a month
         (5)      Not at all            *[Go to J0]*

         (6)      All children deceased     *[Go to J0]*
         (r)      Refused               *[Go to J0]*

G3    **Now I'm going to ask you about some things that may have happened with your children.  I'm going to read a list of statements that some people have used to describe their children.  I'd like you to tell me whether or not each statement describes any of them.**

         **(Please remember that all information provided is strictly confidential.)**

         **They try to limit your contact with family or friends.**

         (1)      Yes
         (3)      No
         (r)      Refused

G4    **They put you down or call you names to make you feel bad.**

         (Does this statement describe any of your children?)

         (1)      Yes
         (3)      No
         (r)      Refused

41

--- page 46 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

G5     **They damage or destroy your possessions or property.**

       (Does this statement describe any of your children?)

       (1)       Yes
       (3)       No
       (r)       Refused

G6     **They harm, or threaten to harm, someone close to you.**

       (Does this statement describe any of your children?)

       (1)       Yes
       (3)       No
       (r)       Refused

G8     **They prevent you from knowing about or having access to your income, even if you ask.**

       (Does this statement describe any of your children?)

       (1)       Yes
       (3)       No
       (r)       Refused

G9     **They try to force you to relinquish control over your finances when you don't want to.**

       (Does this statement describe any of your children?)

       (1)       Yes
       (3)       No
       (r)       Refused

G10    **They try to force you to give up something of value when you don't want to.**

       (Does this statement describe any of your children?)

       (1)       Yes
       (3)       No
       (r)       Refused

42

--- page 47 ---

GSS – Cycle 13 – Victimization                                                                                              Appendix B

G11    **They try to force you to change your Last Will and Testament or try to obtain Power of Attorney
        over your finances when you don't want them to.**

       (Does this statement describe any of your children?)
       (By power of attorney we mean a legal document which gives someone control over your finances and
        permits that person to write cheques or withdraw money from your bank account.)

       (1)       Yes
       (3)       No
       (r)       Refused

*CATI-G11e:  If G3 to G11 all  NE (1) Go to H0.*

G12    **You said yes to one of the previous statements describing your child/children. Was it a son
        or a daughter that one of the previous statements describes?**

       (1)       Son(s)
       (2)       Daughter(s)
       (3)       Both
       (x)       Don't know
       (r)       Refused

43

--- page 48 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

SECTION H: PHYSICAL VIOLENCE BY CHILDREN

*H0   Date / Time stamp*

*CATI-H0e:  Verify respondent's current marital status from the household roster.  If married or living common
              -law or same-sex partner or E0AA = (1)  Go to H0A;  Else Go to H0B.*

H0A   **I''d like you to tell me whether, in the past 5 years, any of your children have done any of the
      following to you.  Again, your responses are important whether or not you have had any of these
      experiences and remember that all information provided is strictly confidential.**

*[Go to H1]*

H0B   **It is important to hear from people themselves if we are to understand the serious problem of
      violence in the home.  I'd like you to tell me whether, in the past 5 years, any of your children
      have done any of the following to you.  Your responses are important whether or not you have had
      any of these experiences.  Please remember that all information provided is strictly confidential.**

H1    **During the past 5 years, have any of your children THREATENED to hit you with their fist or
      anything else that could have hurt you?**

      (1)     Yes
      (3)     No
      (r)     Refused

H2    **(During the past 5 years,) have any of your children THROWN anything at you that could have
      hurt you?**

      (1)     Yes
      (3)     No
      (r)     Refused

H3    **(During the past 5 years,) have they pushed, grabbed, or shoved you in a way that could have
      hurt you?**

      (1)     Yes
      (3)     No
      (r)     Refused

H4    **(During the past 5 years,) have they slapped you?**

      (1)     Yes
      (3)     No
      (r)     Refused

44

--- page 49 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

H5     **(During the past 5 years,) have any of your children kicked you, bit you, or hit you with their fist?**

         (1)       Yes
         (3)       No
         (r)       Refused

H6     **(During the past 5 years,)  have they hit you with something that could have hurt you?**

         (Do not include hitting with fist)

         (1)       Yes
         (3)       No
         (r)       Refused

H7     **(During the past 5 years,) have they beaten you?**

         (1)       Yes
         (3)       No
         (r)       Refused

H8     **(During the past 5 years,) have any of your children choked you?**

         (1)       Yes
         (3)       No
         (r)       Refused

H9     **(During the past 5 years,) have they USED or THREATENED TO USE a gun or knife on you?**

         (1)       Yes
         (3)       No
         (r)       Refused

*CATI-H9e:     If any of H1 to H9 =(1) then SCABUSE = (1);  else SCABUSE = (0) and Go to J0.*

H10    **During the past 5 years, have any of your children been violent towards you on more than one
         occasion?**

         (1)       Yes
         (3)       No             *[Go to H13]*
         (r)       Refused        *[Go to H13]*

45

--- page 50 ---

GSS – Cycle 13 – Victimization                                                                                               Appendix B

H11    **How many different times did these things happen?**

         (2)      Two
         (3)      Three
         (4)      Four
         (5)      Five
         (6)      Six
         (7)      Seven
         (8)      Eight
         (9)      Nine
         (10)     Ten
         (11)     More than ten
         (x)      Don't know
         (r)      Refused

H12    **How many of these were in the past 12 months?**

         |__|__| *[CATI: 0-99]*
         (x)      Don't know
         (r)      Refused

*CATI-H12e - Hard edit.  If H11 NE (11) nor (x) nor (r) then H12 must be =< H11.  If not then*
         *(1)      Correct H11*
         *(3)      Correct H12*

H13    **When did this happen (the most recent happen)?**

         Year
         |__|__|__|__|__| *[CATI: 1994-1999]*
         (x)      Don't know
         (r)      Refused

         Month
         |__|__| *[CATI: 1-12]*
         (x)      Don't know
         (r)      Refused

46

--- page 51 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

SECTION J: EMOTIONAL AND FINANCIAL ABUSE BY A CAREGIVER

*J0     Date / Time stamp*

J1     **(Excluding your spouse/partner/ex-partner/children) in the past 5 years, has a caregiver come into
     your home to assist you with everyday activities or to provide care?  By this I mean anyone, either
     paid or unpaid, who provided you with assistance or healthcare in your home.  This includes meal
     preparation, personal care or medical assistance.**

          (1)     Yes
          (3)     No                    *[Go to K15]*
          (r)     Refused               *[Go to K15]*

J2     **Now I'm going to ask you about some things that may have happened with your caregiver.
     I'd like you to tell me whether or not each statement describes any of them.**

     **(Please remember that all information provided is strictly confidential.)**

     **They put you down or call you names to make you feel bad.**

          (1)     Yes
          (3)     No
          (r)     Refused

J3     **They damage or destroy your possessions or property.**

     (Does this statement describe your caregiver?)

          (1)     Yes
          (3)     No
          (r)     Refused

J4     **They harm, or threaten to harm, someone close to you.**

     (Does this statement describe your caregiver?)

          (1)     Yes
          (3)     No
          (r)     Refused

J6     **They try to force you to relinquish control over your finances when you don't want to.**

     (Does this statement describe your caregiver?)

          (1)     Yes
          (3)     No
          (r)     Refused

47

--- page 52 ---

GSS – Cycle 13 – Victimization                                                                                               Appendix B

J7     **They try to force you to give up something of value when you don't want to.**

         (Does this statement describe your caregiver?)

         (1)        Yes
         (3)        No
         (r)        Refused

J8     **They try to force you to change your Last Will and Testament or try to obtain Power of Attorney
         over your finances when you don't want them to.**

         (Does this statement describe your caregiver?)
         (By power of attorney we mean a legal document which gives someone control over your finances
         and permits that person to write cheques or withdraw money from your bank account.)

         (1)        Yes
         (3)        No
         (r)        Refused

--- page 53 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

SECTION K: PHYSICAL AND SEXUAL VIOLENCE BY CAREGIVER

*K0     Date / Time stamp*

*CATI-K0e:  Verify respondent's current marital status from the household roster.  If married or living common-law or same-sex partner or E0A = (1)  or (G3 NE ( ) and  G3 = 'On path') - Go to K0A;  Else Go to K0B.*

K0A   **I'd like you to tell me whether, in the past 5 years, any caregiver who has come into your home has done any of the following to you.  Again, your responses are important whether or not you have had any of these experiences.  Please remember that all information provided is strictly confidential.**

*[Go to K1]*

K0B   **It is important to hear from people themselves if we are to understand the serious problem of violence in the home.  I'd like you to tell me whether, in the past 5 years, any caregiver who has come into your home has done any of the following to you.  Your responses are important whether or not you have had any of these experiences.  Please remember that all information provided is strictly confidential.**

K1     **During the past 5 years, has any caregiver THREATENED to hit you with their fist or anything else that could have hurt you?**

         (1)     Yes
         (3)     No
         (r)     Refused

K2     **(During the past 5 years,) has any caregiver THROWN anything at you that could have hurt you?**

         (1)     Yes
         (3)     No
         (r)     Refused

K3     **(During the past 5 years,) has any caregiver pushed, grabbed, or shoved you in a way that could have hurt you?**

         (1)     Yes
         (3)     No
         (r)     Refused

K4     **(During the past 5 years,) has any caregiver slapped you?**

         (1)     Yes
         (3)     No
         (r)     Refused

49

--- page 54 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

K5     **(During the past 5 years,) has any caregiver kicked you, bit you, or hit you with their fist?**

         (1)     Yes
         (3)     No
         (r)     Refused

K6     **(During the past 5 years,) has any caregiver hit you with something that could have hurt you?**

         (Do not include hitting with fist)

         (1)     Yes
         (3)     No
         (r)     Refused

K7     **(During the past 5 years,) has any caregiver beaten you?**

         (1)     Yes
         (3)     No
         (r)     Refused

K8     **(During the past 5 years,) has any caregiver choked you?**

         (1)     Yes
         (3)     No
         (r)     Refused

K9     **(During the past 5 years,) has any caregiver USED or THREATENED TO USE a gun or knife on
you?**

         (1)     Yes
         (3)     No
         (r)     Refused

K10    **(During the past 5 years,) has any caregiver forced you into any unwanted sexual activity, by
threatening you, holding you down, or hurting you in some way?**

         (1)     Yes
         (3)     No
         (r)     Refused

*CATI-K10e:   If any of K1 to K10 = (1) then SGABUSE = (1) else SGABUSE = (0) and Go to K15.*

K11    **During the past 5 years, has any caregiver been violent towards you on more than one occasion?**

         (1)     Yes
         (3)     No          *[Go to K14]*
         (r)     Refused     *[Go to K14]*

50

--- page 55 ---

GSS – Cycle 13 – Victimization                                                                                              Appendix B

K12    **How many different times did these things happen?**

         (2)       Two
         (3)       Three
         (4)       Four
         (5)       Five
         (6)       Six
         (7)       Seven
         (8)       Eight
         (9)       Nine
         (10)      Ten
         (11)      More than ten
         (x)       Don't know
         (r)       Refused

K13    **How many of these were in the past 12 months?**

         |__|__| *[CATI: 0-99]*

         (x)       Don't know
         (r)       Refused

*CATI-K13e - Hard edit.  If K12 NE (11) nor (x) nor (r) then K13 must be =< K12.  If not then*
         *(1)       Correct K12*
         *(3)       Correct K13*

K14    **When did this happen (the most recent happen)?**

         Year
         |__|__|__|__| *[CATI: 1994-1999]*

         (x)       Don't know
         (r)       Refused

         Month
         |__|__| *[CATI: 1-12]*

         (x)       Don't know
         (r)       Refused

K15    **Has anything else happened to you in your lifetime that could be considered a crime? Please remember that crime includes vandalism, theft, fraud, break and enter, assault and sexual assault.**

         (1)       Yes
         (3)       No           *[Go to CATI-K16e]*
         (x)       Don't know   *[Go to CATI-K16e]*
         (r)       Refused      *[Go to CATI-K16e]*

51

--- page 56 ---

GSS – Cycle 13 – Victimization                                                                    Appendix B

K16   **What happened?** ….  (Did anything else happen to you?)

            **INT:===Mark all that apply.  Categorize if possible, or else list in "Other" category. ===**

K16A  **What was your approximate age when each  occurrence happened?**

            **INT:===If a respondent gives an age range instead of a specific age, record the**
                          **youngest age in the range. If age is < 1 year old, record age as 1.===**

                                                                        Age1      Age2      Age3      Age4

      (1)    Sexual assault (unwanted sexual touching,
               fondling, rape, and attempted rape)                       ___       ___       ___       ___

      (2)    Robbery/Attempted robbery (theft with a
               face-to-face threat, an assault or a
               weapon  If no threat, assault or weapon,
               classify elsewhere.)                                      ___       ___       ___       ___

      (3)    Assault (face-to-face threat or assault with
               or without a weapon but neither theft
               nor attempted theft of property)                          ___       ___       ___       ___

      (4)    Break and enter/Attempt (illegal entry or
               attempted illegal entry into your residence
               or any other building on your property)                   ___       ___       ___       ___

      (5)    Motor vehicle theft/Attempt (theft or
               attempted theft of motor vehicle or parts)                ___       ___       ___       ___

      (6)    Theft of personal property/Attempt
               (money or other personal property was
               taken or an attempt was made to take it)                  ___       ___       ___       ___

      (7)    Fraud                                                        ___       ___       ___       ___

      (8)    Theft of household property/Attempt                         ___       ___       ___       ___

      (9)    Vandalism (something  was damaged)                          ___       ___       ___       ___

      (10)   Other                    *[Go to K16S]*                     ___       ___       ___       ___

K16S  Specify
|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
*[CATI]: Length of field = 50*

52

--- page 57 ---

GSS – Cycle 13 – Victimization                                                                    Appendix B

CATI-K16e:   Hard edit: Verify age of respondent; all ages reported in K16A less than respondent's age.
Fill in an incident report for each incident mentioned in Section B except for the incidents other than the first in
a series report, i.e.:

DO for each of the [B variables] B1, B2, B3, B4A, B4B, B4C, B6A, B6B, B7, B8A, N8B, B9, B10, B11A,
        B11B, B12, B13 and B14 (with their corresponding BA variables B1A, B2A, …, B14A):
INCSKIP = 0;
        IF [B variable] = (1) then
                VSCRNO  = name of B variable;
                DO [BA variable]  times;
                If INCSKIP > 0 then
                        INCSKIP  = INCSKIP - 1;
                        Else
                                        Section V;
                        ENDIF;
                ENDDO;
        ENDIF;
ENDDO;

Notes:  - INCSKIP indicates the number of incidents for which no report is required.  It will be set
           during a previous incident report (Section V)  when a series report is indicated.

        - VSCRNO indicates the type of crime the incident report involves, e.g. A value of B1 indicates
           vandalism, B2 robbery, etc.

--- page 58 ---

GSS – Cycle 13 – Victimization                                                                    Appendix B

SECTION L:  SPOUSAL ABUSE REPORT

L0     *Date / Time stamp*

*CATI-L0e: If SPABUSE =(0), Go to M0.*

L1     **You said that during the past 5 years your spouse/partner was violent.**

L2     **During this (these) incident(s), were you (ever) physically injured in any way?**

          (1)     Yes
          (3)     No               *[Go to L6]*
          (r)     Refused          *[Go to L6]*

*CATI-L2e:  If D11 = (3) or (D13 = (0) or D13 = "Off path") or ((2) LE D12 LE (10) and D13 = D12
       and (D12 and D13 = "On path")), Go to L4.*

L3     **Did any of these incidents in which you were injured happen in the past 12 months?**

          (1)     Yes
          (3)     No
          (x)     Don't know
          (r)     Refused

L4     **During the past 5 years, did you ever receive any medical attention at a hospital as a result of
       the violence?**
       (Include treatment received at emergency or as an out-patient.)

          (1)     Yes
          (3)     No               *[Go to L5]*
          (r)     Refused          *[Go to L5]*

L4A   **Did you stay in hospital overnight?**

          (1)     Yes
          (3)     No               *[Go to L6]*
          (r)     Refused          *[Go to L6]*

L4B   **For how many nights?**

          |__|__|__| *[CATI: 0-999]*

          (r)     Refused

*[Go to L6]*

54

--- page 59 ---

GSS – Cycle 13 – Victimization                                                                                                          Appendix B

L5      **During the past 5 years, did you ever receive any medical attention from a doctor or a nurse
        for your injuries?**
        (Include medical attention received immediately after the attack as well
        as any medical attention received as a result of the injuries.)

        (1)     Yes
        (3)     No
        (r)     Refused

L6      **As a result of the violence (and excluding any time you spent in the hospital), did you, during the
        past 5 years, ever have to stay in bed for all or most of a day?**
        (Include time spent in bed for injuries as well as for stress reasons.)

        **INT:===Most of a day means at least 6 hours over and above the time the respondent normally
        spends sleeping.)===**

        (1)     Yes
        (3)     No          *[Go to L7]*
        (r)     Refused     *[Go to L7]*

L6A     **For how many days?**

        **INT:===Count each day the respondent spent at least 6 hours in bed over and above the time he/she
        normally spends sleeping===**

        |__|__|__| *[CATI: 0-999]*
        (x)     Don't know
        (r)     Refused

L7      **(Other than the time you spent in the hospital or at home in bed,)  during the past 5 years, did you
        ever have to take time off from your everyday activities because of what happened to you?**

        **INT:===Select (1) (yes) if the respondent's everyday activities were disrupted for at least 6 hours===**

        (1)     Yes
        (3)     No
        (x)     Don't know
        (r)     Refused

L8      **During (these) this incident(s) was your spouse/partner drinking?**

        **INT:===Select (1) (yes) if the respondent says usually or during more than half of the incidents===**

        (1)     Yes
        (3)     No
        (5)     Does not drink
        (x)     Don't know
        (r)     Refused

55

--- page 60 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

L12     **During the past 5 years, was anyone (else) ever harmed or threatened during (these) this incident(s)?**

        (1)     Yes
        (3)     No              *[Go to L14]*
        (x)     Don't know      *[Go to L14]*
        (r)     Refused         *[Go to L14]*

L12A  **How many persons?**

        |__|__| *[CATI: 0-99]*
        (x)     Don't know
        (r)     Refused

L13     **Were any of these people who were harmed or threatened under 15 years of age?**

        (1)     Yes
        (3)     No              *[Go to L14]*
        (x)     Don't know      *[Go to L14]*
        (r)     Refused         *[Go to L14]*

L13A  **How many persons?**

        |__|__| *[CATI: 0-99]*
        (x)     Don't know
        (r)     Refused

L14     **Did any of your children see or hear (any of these) this incident(s)?**

        (1)     Yes/think so
        (3)     No/don't think so
        (5)     No children at the time
        (x)     Don't know
        (r)     Refused

L15     **During the past 5 years, did you ever fear that your life was in danger because of your spouse's/partner's violent or threatening behaviour?**

        (1)     Yes
        (3)     No
        (r)     Refused

L16     **During the past 5 years, did you ever attempt to obtain compensation, through a civil or criminal court or a provincial compensation program, because of the violence?**

        (1)     Yes
        (3)     No              *[Go to L17]*
        (r)     Refused         *[Go to L17]*

56

--- page 61 ---

GSS – Cycle 13 – Victimization                                                                                              Appendix B

L16A  **Did you obtain any compensation?**

        (1)       Yes
        (3)       No
        (5)       Not yet resolved
        (r)       Refused

L17    **Did the police ever find out about the violence in any way?**

        **INT:=== If the respondent or the respondent's spouse/partner or a member of the household is
        a police officer, select (1) (yes) only if it was reported to the police===**

        (1)       Yes
        (3)       No                    *[Go to L25A]*
        (x)       Don't know            *[Go to L27]*
        (r)       Refused               *[Go to L27]*

*CATI-L17e:    If (D11 = (3) and (D14 is less than 12 months ago and D14 = "On path")) or (2 LE D12 LE
               10 and D12 = D13 and (D12 and D13 = "On path")), Go to L19.*

L18    **Did they find out about it in the past 12 months?**

        (1)       Yes
        (3)       No
        (x)       Don't know
        (r)       Refused

L19    **How did they learn about it? Was it from you or some other way?**

        **INT:===If respondent answers both himself/herself and some other way - enter (1)===**

        (1)       Respondent
        (3)       Some other way        *[Go to L21]*
        (x)       Don't know            *[Go to L27]*
        (r)       Refused               *[Go to L27]*

L20    **People have different reasons for reporting incidents to the police.  Did any of the following have
        anything to do with why you reported the violence?  Was it…**

                                          **INT: ===READ LIST===**

                                                                    Yes    No   Don't know   Refused
        a)        To stop the violence or receive protection?        (1)    (3)     (x)          (r)
        b)        To arrest and punish your spouse/partner?          (1)    (3)     (x)          (r)
        c)        Because you felt it was your duty to notify police? (1)   (3)     (x)          (r)
        d)        On the  recommendation of someone else?            (1)    (3)     (x)          (r)

57

--- page 62 ---

GSS – Cycle 13 – Victimization                                                                                               Appendix B

L21    **What action did the police take?**

                              **INT:===Mark all that apply.===**
         (n)     None                                          *[Go to L22]*
         (1)     Visited Scene
         (2)     Made a report/Conducted an investigation
         (3)     Gave warning to spouse/partner
         (4)     Took spouse/partner away
         (5)     Made arrest/Laid charges
         (6)     Put you in touch with community services
         (7)     Other                                         *[Go to L21S]*
         (r)     Refused                                       *[Go to L22]*
         (0)     No other; continue                            *[Go to L22]*

L21S   Specify
        |__|__|__|__|__|__|__|__|__|__|__|__|__|__|
        |__|__|__|__|__|__|__|__|__|__|__|__|__|__|
*CATI: Length of field = 28*

L22    **How satisfied were you with the actions that the police took? Were you …**

                              **INT: ===READ LIST===**
         (1)     Very satisfied?
         (2)     Somewhat satisfied?
         (3)     Somewhat dissatisfied?
         (4)     Very dissatisfied?

         (r)     Refused

L23    **Is there anything (else) they should have done to help you?**

                              **INT:===Mark all that apply.===**
         (n)     No/nothing                                    *[Go to CATI-L23e]*
         (1)     Take the person out of the house
         (2)     Charge/arrest the person
         (3)     Respond more quickly
         (4)     Refer/take you to a support service
         (5)     Relocate you
         (6)     Take you to hospital
         (7)     Be more supportive/sympathetic
         (8)     Other                                         *[Go to L23S]*
         (x)     Don't know                                    *[Go to CATI-L23e]*
         (r)     Refused                                       *[Go to CATI-L23e]*
         (0)     No other; continue                            *[Go to CATI-L23e]*

58

--- page 63 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

L23S   Specify
       |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
       |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
*[CATI]: Length of field = 50*
*CATI-L23e:   If D11 = 3, Go to L27*

L24    **After the police were involved, did your spouse's/partner's violent or threatening behaviour towards
       you…**

                                        INT: ===READ LIST===

         (1)          Increase?
         (2)          Decrease/stop?
         (3)          Stay the same?

         (x)          Don't know
         (r)          Refused

*[Go to L27]*

L25A   **I'm going to read a list of reasons why some people choose not to contact the police.  Please tell me
       which ones apply to your experience.  Was it…
       Because it was dealt with another way?**
       (e.g. left him/her, reported to another official, private matter that took care of myself, etc.)

         (1)          Yes
         (3)          No
         (r)          Refused

L25B   (**I'm going to read a list of reasons why some people choose not to contact the police.  Please tell me
       which ones apply to your experience.  Was it…)
       Because of fear of your spouse/partner?**

         (1)          Yes
         (3)          No
         (r)          Refused

L25C   **(I'm going to read a list of reasons why some people choose not to contact the police.  Please tell me
       which ones apply to your experience.  Was it…)
       Because the police couldn't do anything about it?**

         (1)          Yes
         (3)          No
         (r)          Refused

59

--- page 64 ---

GSS – Cycle 13 – Victimization                                                                                              Appendix B

L25D **(I'm going to read a list of reasons why some people choose not to contact the police.  Please tell me which ones apply to your experience.  Was it…)**
      **Because the police wouldn't help?**
      (e.g. wouldn't think it was important enough, wouldn't believe, wouldn't want to be bothered or get
      involved, police would be inefficient or ineffective, police would be  biased, would harass/insult
      respondent, offender was police officer)

      (1)     Yes
      (3)     No
      (r)     Refused

L25E **(I'm going to read a list of reasons why some people choose not to contact the police.  Please tell me which ones apply to your experience.  Was it…)**
      **Because you didn't want to get involved with police?**

      (1)     Yes
      (3)     No
      (r)     Refused

L25X **(I'm going to read a list of reasons why some people choose not to contact the police.  Please tell me which ones apply to your experience.  Was it…)**
      **Because you didn't want your spouse/partner arrested or jailed?**

      (1)     Yes
      (3)     No
      (r)     Refused

L25G **(I'm going to read a list of reasons why some people choose not to contact the police.  Please tell me which ones apply to your experience.  Was it…)**
      **Because the incident was a personal matter that didn't concern the police?**

      (1)     Yes
      (3)     No
      (r)     Refused

L25Y **(I'm going to read a list of reasons why some people choose not to contact the police.  Please tell me which ones apply to your experience.  Was it…)**
      **Because you didn't want anyone to find out about it?** (e.g. shame, embarrassment)

      (1)     Yes
      (3)     No
      (r)     Refused

60

--- page 65 ---

GSS – Cycle 13 – Victimization                                                                                              Appendix B

L25H  **(I'm going to read a list of reasons why some people choose not to contact the police.  Please tell me which ones apply to your experience.  Was it…)
         Because of fear of publicity/news coverage?**

         (1)          Yes
         (3)          No
         (r)          Refused

L25F  **(I'm going to read a list of reasons why some people choose not to contact the police.  Please tell me which ones apply to your experience.  Was it…)
         Because it was not important enough to you?** (e.g. minor crime, no intended harm, etc.)

         (1)          Yes
         (3)          No
         (r)          Refused

L25K  **(I'm going to read a list of reasons why some people choose not to contact the police.  Please tell me which ones apply to your experience.  Was it…)
         For some other reason, not already mentioned?**

         (1)          Yes
         (3)          No               *[Go to CATI-L25e]*
         (r)          Refused          *[Go to CATI-L25e]*

L25S  Specify
         |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
         |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
*[CATI]: Length of field = 50*

*CATI- L25e:   If the number of (1)'s in L25A to L25K <= 1 then        Go to L27.*

L26    **What was the main reason?**

         (1)          Dealt with another way
         (2)          Fear
         (3)          Police couldn't do anything
         (4)          Police wouldn't help
         (5)          Did not want to get involved with police
         (6)          Not important enough to respondent
         (7)          A personal matter that did not concern the police
         (8)          Fear of publicity/media coverage
         (11)         Didn't want spouse/partner arrested or jailed
         (12)         Didn't want anyone to find out about it
         (13)         Other
         (r)          Refused

61

--- page 66 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

L27    **(Other than to the police,) did you ever talk to anyone about (these) this incident(s), such as ...**

**INT: ===READ LIST===**

                                          Yes    No    Don't Know    Refused
   a)       Family?                       (1)    (3)       (x)          (r)
   b)       Friend or neighbour?          (1)    (3)       (x)          (r)
   c)       Co-worker?                    (1)    (3)       (x)          (r)
   d)       Doctor or nurse?              (1)    (3)       (x)          (r)
   e)       Lawyer?                       (1)    (3)       (x)          (r)
   f)       Minister, priest, clergy
            or another spiritual advisor? (1)    (3)       (x)          (r)

L28    **During the past 5 years, did you ever contact or use any of the following services for help because of the violence, such as …**
("Victim Assistance Units" operate within a specific police office, and help victims at the police end of the justice system.  "Victim Services" help victims as their cases proceed through the justice system (police, courts and corrections).  Services include providing general information about the justice system, referrals, assistance with court, help preparing victim impact statements, offering emotional support and providing information to help victims recover financial losses resulting from the crime.)

**INT: ===READ LIST===**

                                                              Yes    No    Don't know Refused
   a)       Crisis centre or crisis line?                     (1)    (3)       (x)       (r)
   b)       Another counsellor or psychologist?               (1)    (3)       (x)       (r)
   c)       Community centre or family centre?                (1)    (3)       (x)       (r)
   d)       Shelter or transition house?
            *[CATI: only if female respondent]*               (1)    (3)       (x)       (r)
   e)       Women's centre? *[CATI: only if female respondent]* (1)  (3)       (x)       (r)
   f)       Men's centre or men's support group?
            *[CATI: only if male respondent]*                 (1)    (3)       (x)       (r)
   g)       Seniors' centre? *[CATI: only if respondent is 65+]* (1) (3)       (x)       (r)
   h)       Police-based or court-based victim services?      (1)    (3)       (x)       (r)

*CATI-L28e:    (For each of L28a) to L28h):
               If answer = (1) then
                     If (D11 = (3) and (D14 is less than 12 months ago and D14 = "On path"))
                        or (2 LE D12 LE 10 and D12 = D13 and (D12 and D13 = "On path"))  then
                        Go to next question in L28;  Else
               Go to L28A and then return to next question in L28; Else
               Go to next question in L28"*

62

--- page 67 ---

GSS – Cycle 13 – Victimization                                                                                              Appendix B

L28A  **Was this in the past 12 months?**
a to h

         (1)       Yes
         (3)       No
         (r)       Refused

*CATI-L29e:   If not all L28a) to L28h) = (3), Go to L30*
L29    **Is there any reason why you didn't use any of these services?**

                                        **INT:=== Mark all that apply.===**

         (1)       Didn't know of any services
         (2)       None available
         (3)       Waiting list
         (4)       Too minor
         (5)       Shame/embarrassment
         (6)       Wouldn't be believed
         (7)       Offender prevented me
         (8)       Distance
         (9)       Fear of losing financial support
         (10)      Fear of losing the children
         (11)      Didn't want relationship to end
         (12)      Didn't want/need help
         (13)      Other                                          *[Go to L29S]*
         (x)       Don't know/no reason                          *[Go to L30]*
         (r)       Refused                                        *[Go to L30]*
         (0)       No other; continue                            *[Go to L30]*

L29S   Specify
        |__|__|__|__|__|__|__|__|__|__|__|__|__|__|
        |__|__|__|__|__|__|__|__|__|__|__|__|__|__|
*CATI: Length of field =28*

*CATI-L30e:  If this is the first time the following question is asked read conditional text 1;  else read
              conditional text 2.*

L30    **(There are a number of ways to deal with an offence outside the normal police-court process.  One way is a meeting between the victim and the offender to discuss an appropriate way the offender should be dealt with.  Thinking about your experience, how interested would you be (have been) in participating in such a program if one was available in your community?)
(Thinking about the incident(s), how interested would you be (have been) in participating in a program where the victim and the offender meet to discuss an appropriate way the offender should be dealt with?)
Would you be (have been)…**

                                        **INT: ===READ LIST===**

63

--- page 68 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

        (1)          Very interested?
        (2)          Somewhat interested?
        (3)          Slightly interested?
        (4)          Not at all interested?

        (r)          Refused

L31     At the time of the incident(s), how did this experience affect you?

                              INT:===Mark all that apply.===
                     INT:===Do not include physical injury, financial loss or medical treatment.===

        (1)          Afraid for children
        (2)          Angry
        (3)          Ashamed/guilty
        (4)          Depression/ anxiety attacks
        (5)          Fearful
        (6)          Hurt/disappointment
        (7)          Increased self-reliance
        (8)          Lowered self esteem
        (9)          More cautious/aware
        (10)         Not much
        (11)         Problems relating to men/women
        (12)         Shock/disbelief
        (13)         Sleeping problems
        (14)         Upset/confused/frustrated
        (15)         Other                                    [Go to L31S]
        (x)          Don't know                               [Go to L32]
        (r)          Refused                                  [Go to L32]
        (0)          No other; continue                       [Go to L32]

L31S  Specify
      |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
      |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
*[CATI]: Length of field = 50*

L32     From your experience, what advice, if any, would you give another person in a similar situation?

      |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
      |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
        (n)          No/Nothing
        (x)          Don't know
        (r)          Refused

*[CATI]: Length of field =50*

64

--- page 69 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

SECTION M:  EX-SPOUSAL ABUSE REPORT

M0     *Date / Time stamp*

*CATI-M0e:  If EXABUSE = (0),  Go to N0.*

M1     **You said that during the past 5 years your ex-partner was violent.**

M2     **During (these) this incident(s), were you (ever) physically injured in any way?**

          (1)     Yes
          (3)     No               *[Go to M6]*
          (r)     Refused          *[Go to M6]*

*CATI-M2e:     If F11 = (3) or (F13 = (0) or F13 = "Off path") or ((2) LE F12 LE (10) and F13 = F12
                    and(F12 and F13 = "On path")), Go to M4.*

M3     **Did any of these incidents in which you were injured happen in the past 12 months?**

          (1)     Yes
          (3)     No
          (x)     Don't know
          (r)     Refused

M4     **During the past 5 years, did you ever receive any medical attention at a hospital as a result of the
          violence?**
          (Include treatment received at emergency or as an out-patient.)

          (1)     Yes
          (3)     No               *[Go to M5]*
          (r)     Refused          *[Go to M5]*

M4A   **Did you stay in hospital overnight?**

          (1)     Yes
          (3)     No               *[Go to M6]*
          (r)     Refused          *[Go to M6]*

M4B   **For how many nights?**

          |__|__|__| *[CATI: 0-999]*
          (r)     Refused

*[Go to M6]*

65

--- page 70 ---

GSS – Cycle 13 – Victimization                                                                                          Appendix B

M5     **During the past 5 years, did you ever receive any medical attention from a doctor or a nurse
       for your injuries?**
       (Include medical attention received immediately after the attack as well as any medical attention
       received as a result of the injuries.)

       (1)     Yes
       (3)     No
       (r)     Refused

M6     **As a result of the violence (and excluding any time you spent in the hospital), did you, during the
       past 5 years, ever have to stay in bed for all or most of a day?**
       (Include time spent in bed for injuries as well as for stress reasons.)

       **INT:=== Most of a day means at least 6 hours over and above the time the respondent normally
       spends sleeping.===**

       (1)     Yes
       (3)     No          *[Go to M7]*
       (r)     Refused     *[Go to M7]*

M6A   **For how many days?**

       **INT:=== Count each day the respondent spent at least 6 hours in bed over and above the time he/she
       normally spends sleeping===**

       |_|_|_| *[CATI: 0-999]*
       (x)     Don't know
       (r)     Refused

M7     **(Other than the time you spent in the hospital or at home in bed,) during the past 5 years, did you
       ever have to take time off from your everyday activities because of what happened to you?**

       **INT:===Select (1) (yes) if the respondent's everyday activities were disrupted for at least 6 hours===**

       (1)     Yes
       (3)     No
       (x)     Don't know
       (r)     Refused

M8     **During (these) this incident(s) was your ex-partner drinking?**

       **INT:===Select (1) (yes) if the respondent says usually or during more than half of the incidents===**

       (1)     Yes
       (3)     No
       (5)     Does not drink
       (x)     Don't know
       (r)     Refused

66

--- page 71 ---

GSS – Cycle 13 – Victimization                                                                                              Appendix B

M12   **During the past 5 years, was anyone (else) ever harmed or threatened during (these) this incident(s)?**

        (1)     Yes
        (3)     No               *[Go to M14]*
        (x)     Don't know       *[Go to M14]*
        (r)     Refused          *[Go to M14]*

M12A  **How many persons?**

        |__|__| *[CATI: 0-99]*
        (x)     Don't know
        (r)     Refused

M13   **Were any of these people who were harmed or threatened under 15 years of age?**

        (1)     Yes
        (3)     No               *[Go to M14]*
        (x)     Don't know       *[Go to M14]*
        (r)     Refused          *[Go to M14]*

M13A  **How many persons?**

        |__|__| *[CATI: 0-99]*
        (x)     Don't know
        (r)     Refused

M14   **Did any of your children see or hear (any of these) this incident(s)?**

        (1)     Yes/think so
        (3)     No/don't think so
        (5)     No children at the time
        (x)     Don't know
        (r)     Refused

M15   **During the past 5 years, did you ever fear that your life was in danger because of your ex-partner's violent or threatening behaviour?**

        (1)     Yes
        (3)     No
        (r)     Refused

M16   **During the past 5 years, did you ever attempt to obtain compensation, through a civil or criminal court or a provincial compensation program, because of the violence?**

        (1)     Yes
        (3)     No               *[Go to M17]*
        (r)     Refused          *[Go to M17]*

67

--- page 72 ---

GSS – Cycle 13 – Victimization                                                                                              Appendix B

M16A  **Did you obtain any compensation?**

         (1)       Yes
         (3)       No
         (5)       Not yet resolved
         (r)       Refused

M17    **Did the police ever find out about the violence in any way?**

         **INT:===If the respondent or the respondent's ex-partner or a member of the household
         is a police officer, select (1) (yes) only if it was reported to the police===**

         (1)       Yes
         (3)       No                    *[Go to M25A]*
         (x)       Don't know            *[Go to M27]*
         (r)       Refused               *[Go to M27]*

*CATI-M17e:   If (F11= (3) and (F14 is less than 12 months ago and F14 = "On path)) or (2 LE F12 LE 10
                    and F12 =F13 and (F12 and F13 = "On path)), Go to M19.*

M18    **Did they find out about it in the past 12 months?**

         (1)       Yes
         (3)       No
         (x)       Don't know
         (r)       Refused

M19    **How did they learn about it? Was it from you or some other way?**

         **INT:=== If respondent answers both himself/herself and some other way - enter (1)===**

         (1)       Respondent
         (3)       Some other way        *[Go to M21]*
         (x)       Don't know            *[Go to M27]*
         (r)       Refused               *[Go to M27]*

M20    **People have different reasons for reporting incidents to the police.  Did any of the following have
         anything to do with why you reported the violence?  Was it…**

                                              **INT: ===READ LIST===**

                                                                          Yes    No   Don't know   Refused
         a)        To stop the violence or receive protection?            (1)    (3)     (x)          (r)
         b)        To arrest and punish your ex-partner?                  (1)    (3)     (x)          (r)
         c)        Because you felt it was your duty to notify police?    (1)    (3)     (x)          (r)
         d)        On the recommendation of someone else?                 (1)    (3)     (x)          (r)

68

--- page 73 ---

GSS – Cycle 13 – Victimization                                                                                               Appendix B

M21    **What action did the police take?**

                              **INT:===Mark all that apply.===**

          (n)     None                                          *[Go to M22]*
          (1)     Visited Scene
          (2)     Made a report/Conducted an investigation
          (3)     Gave warning to ex-partner
          (4)     Took ex-partner away
          (5)     Made arrest/Laid charges
          (6)     Put in touch with community services
          (7)     Other                                         *[Go to M21S]*
          (r)     Refused                                       *[Go to M22]*
          (0)     No other; continue                            *[Go to M22]*

M21S  Specify
          |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
          |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
*CATI: Length of field = 28*

M22    **How satisfied were you with the actions that the police took?  Were you …**

                              **INT:===READ LIST===**

          (1)     Very satisfied?
          (2)     Somewhat satisfied?
          (3)     Somewhat dissatisfied?
          (4)     Very dissatisfied?

          (r)     Refused

M23    **Is there anything (else) they should have done to help you?**

                              **INT:===Mark all that apply.===**

          (n)     No/nothing                                    *[Go to CATI-M23e]*
          (1)     Take the person out of the house
          (2)     Charge/arrest the person
          (3)     Respond more quickly
          (4)     Refer/take you to a support service
          (5)     Relocate you
          (6)     Take you to hospital
          (7)     Be more supportive/sympathetic
          (8)     Other                                         *[Go to M23S]*
          (x)     Don't know                                    *[Go to CATI-M23e]*
          (r)     Refused                                       *[Go to CATI-M23e]*
          (0)     No other; continue                            *[Go to CATI-M23e]*

69

--- page 74 ---

GSS – Cycle 13 – Victimization                                                                                                    Appendix B

M23S  Specify
      |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
      |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
*[CATI]: Length of field = 50*

*CATI-M23e:   If F11 = (3), Go to M27*

M24   **After the police were involved, did your ex-partner's violent or threatening behaviour towards
      you…**

                              **INT: ===READ LIST===**

      (1)        Increase?
      (2)        Decrease/stop?
      (3)        Stay the same?

      (x)        Don't know
      (r)        Refused

*[Go to M27]*

M25A  **I'm going to read a list of reasons why some people choose not to contact the police.  Please tell me
      which ones apply to your experience.  Was it…
      Because it was dealt with another way?**
      (e.g. left him/her, reported to another official, private matter that took care of myself, etc.)


      (1)        Yes
      (3)        No
      (r)        Refused

M25B  **(I'm going to read a list of reasons why some people choose not to contact the police.  Please tell me
      which ones apply to your experience.  Was it…)
      Because of fear of your ex-partner?**

      (1)        Yes
      (3)        No
      (r)        Refused

M25C  **(I'm going to read a list of reasons why some people choose not to contact the police.  Please tell me
      which ones apply to your experience.  Was it…)
      Because the police couldn't do anything about it?**

      (1)        Yes
      (3)        No
      (r)        Refused

70

--- page 75 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

M25D **(I'm going to read a list of reasons why some people choose not to contact the police. Please tell me which ones apply to your experience. Was it…)**
      **Because the police wouldn't help?**
      (e.g. wouldn't think it was important enough, wouldn't believe, wouldn't want to be bothered
      or get involved, police would be inefficient or ineffective, police would be biased, would
      harass/insult respondent, offender was police officer)

        (1)     Yes
        (3)     No
        (r)     Refused

M25E **(I'm going to read a list of reasons why some people choose not to contact the police. Please tell me which ones apply to your experience. Was it…)**
      **Because you didn't want to get involved with police?**

        (1)     Yes
        (3)     No
        (r)     Refused

M25X **(I'm going to read a list of reasons why some people choose not to contact the police. Please tell me which ones apply to your experience. Was it…)**
      **Because you didn't want your ex-partner arrested or jailed?**

        (1)     Yes
        (3)     No
        (r)     Refused

M25G **(I'm going to read a list of reasons why some people choose not to contact the police. Please tell me which ones apply to your experience. Was it…)**
      **Because the incident was a personal matter that didn't concern the police?**

        (1)     Yes
        (3)     No
        (r)     Refused

M25Y **(I'm going to read a list of reasons why some people choose not to contact the police. Please tell me which ones apply to your experience. Was it…)**
      **Because you didn't want anyone to find out about it?**        (e.g. shame, embarrassment)

        (1)     Yes
        (3)     No
        (r)     Refused

71

--- page 76 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

M25H **(I'm going to read a list of reasons why some people choose not to contact the police.  Please tell me which ones apply to your experience.  Was it…)
Because of fear of publicity/news coverage  ?**

        (1)          Yes
        (3)          No
        (r)          Refused

M25F **(I'm going to read a list of reasons why some people choose not to contact the police.  Please tell me which ones apply to your experience.  Was it…)
Because it was not important enough to you?**  (e.g. minor crime, no intended harm, etc.)

        (1)          Yes
        (3)          No
        (r)          Refused

M25K **(I'm going to read a list of reasons why some people choose not to contact the police.  Please tell me which ones apply to your experience.  Was it…)
For some other reason, not already mentioned?**

        (1)          Yes
        (3)          No          *[Go to CATI-M25e]*
        (r)          Refused     *[Go to CATI-M25e]*

M25S  Specify
   |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
   |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
*[CATI]: Length of field = 50*

*CATI- M25e:  If the number of (1)'s in M25A to M25K <= 1 then Go to M27.*

M26    **What was the main reason?**

        (1)          Dealt with another way
        (2)          Fear
        (3)          Police couldn't do anything
        (4)          Police wouldn't help
        (5)          Did not want to get involved with police
        (6)          Not important enough to respondent
        (7)          A personal matter that did not concern the police
        (8)          Fear of publicity/media coverage
        (11)         Didn't want ex-partner arrested or jailed
        (12)         Didn't want anyone to find out about it
        (13)         Other
        (r)          Refused

72

--- page 77 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

M27   **(Other than to the police,) did you ever talk to anyone about (these) this incident(s), such as ...**

                                    INT: ===READ LIST===

                                         Yes    No    Don't Know    Refused
   a)        Family?                     (1)    (3)       (x)          (r)
   b)        Friend or neighbour?        (1)    (3)       (x)          (r)
   c)        Co-worker?                  (1)    (3)       (x)          (r)
   d)        Doctor or nurse?            (1)    (3)       (x)          (r)
   e)        Lawyer?                     (1)    (3)       (x)          (r)
   f)        Minister, priest, clergy
                or another spiritual advisor?   (1)    (3)       (x)          (r)

M28   **During the past 5 years, did you ever contact or use any of the following services for help because of the violence, such as …**
      ("Victim Assistance Units" operate within a specific police office, and help victims at the
      police end of the justice system.  "Victim Services" help victims as their cases proceed through the justice
      system (police, courts and corrections).  Services include providing general information about the justice
      system, referrals, assistance with court, help preparing victim impact statements, offering emotional
      support and providing information to help victims recover financial losses resulting from the crime.)

                                    INT: ===READ LIST===

                                                        Yes    No    Don't know Refused
   a)        Crisis centre or crisis line?              (1)    (3)       (x)       (r)
   b)        Another counsellor or psychologist?        (1)    (3)       (x)       (r)
   c)        Community centre or family centre?         (1)    (3)       (x)       (r)
   d)        Shelter or transition house?
                *[CATI: only if female respondent]*     (1)    (3)       (x)       (r)
   e)        Women's centre? *[CATI: only if female respondent]*   (1)    (3)       (x)       (r)
   f)        Men's centre or men's support group?
                *[CATI: only if male respondent]*       (1)    (3)       (x)       (r)
   g)        Seniors' centre? *[CATI: only if respondent is 65+]*  (1)    (3)       (x)       (r)
   h)        Police-based or court-based victim services?          (1)    (3)       (x)       (r)

*CATI-M28e:   "For each of M28a) to M28h):
               If answer = (1) then
                     If (F11 = (3) and (F14 is less than 12 months ago and F14 = "On path"))
                        or (2 LE F12 LE 10 and F12 = F13 and (F12 and F13 = "On path"))  then
                        Go to next question in M28;   Else
               Go to M28A and then return to next question in M28; Else
               Go to next question in M28"*

--- page 78 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

M28A  **Was this in the past 12 months?**
a to h

         (1)       Yes
         (3)       No
         (r)       Refused

*CATI-M29e:   If not all M28a) to M28h) = (3), Go to M30*
M29    **Is there any reason why you didn't use any of these services?**

                                        **INT:===Mark all that apply.===**

         (1)       Didn't know of any services
         (2)       None available
         (3)       Waiting list
         (4)       Too minor
         (5)       Shame/embarrassment
         (6)       Wouldn't be believed
         (7)       Offender prevented me
         (8)       Distance
         (9)       Fear of losing financial support
         (10)      Fear of losing the children
         (11)      Didn't want relationship to end
         (12)      Didn't want/need help
         (13)      Other                                          *[Go to M29S]*
         (x)       Don't know/no reason                          *[Go to M30]*
         (r)       Refused                                        *[Go to M30]*
         (0)       No other; continue                            *[Go to M30]*

M29S  Specify
       |__|__|__|__|__|__|__|__|__|__|__|__|__|__|
       |__|__|__|__|__|__|__|__|__|__|__|__|__|__|
*CATI: Length of field =28*

*CATI-M30e:  If this is the first time the following question is asked read conditional text 1;  else read
             conditional text 2.*

--- page 79 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

M30    **(There are a number of ways to deal with an offence outside the normal police-court process.  One way is a meeting between the victim and the offender to discuss an appropriate way the offender should be dealt with.  Thinking about your experience, how interested would you have been (be) in participating in such a program if one was available in your community?)
(Thinking about the incident(s), how interested would you have been (be) in participating in a program where the victim and the offender meet to discuss an appropriate way the offender should be dealt with?)
Would you have been (be)…**

                                        INT: ===READ LIST===

         (1)          Very interested?
         (2)          Somewhat interested?
         (3)          Slightly interested?
         (4)          Not at all interested?

         (r)          Refused

M31    **At the time of the incident(s), how did this experience affect you?**

                                        INT:===Mark all that apply.===
                  INT:===Do not include physical injury, financial loss or medical treatment.===

         (1)          Afraid for children
         (2)          Angry
         (3)          Ashamed/guilty
         (4)          Depression/ anxiety attacks
         (5)          Fearful
         (6)          Hurt/disappointment
         (7)          Increased self-reliance
         (8)          Lowered self esteem
         (9)          More cautious/aware
         (10)         Not much
         (11)         Problems relating to men/women
         (12)         Shock/disbelief
         (13)         Sleeping problems
         (14)         Upset/confused/frustrated
         (15)         Other                                    *[Go to M31S]*
         (x)          Don't know                              *[Go to M32]*
         (r)          Refused                                  *[Go to M32]*
         (0)          No other; continue                       *[Go to M32]*

M31S  Specify
         |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
         |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
*[CATI]: Length of field = 50*

75

--- page 80 ---

GSS – Cycle 13 – Victimization                                                                                     Appendix B

M32   **From your experience, what advice, if any, would you give another person in a similar situation?**

        |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
        |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
        (n)     No/Nothing
        (x)     Don't know
        (r)     Refused
*[CATI]: Length of field =50*

--- page 81 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

SECTION N:  SENIOR ABUSE BY CHILDREN REPORT

N0     *Date / Time stamp*

*CATI-N0e: If SCABUSE = (0), Go to P0.*

N1     **You said that during the past 5 years, one of your children was violent.**

N1A   **Was it a son or daughter who did this to you?**

         (1)          Son(s)
         (2)          Daughter(s)
         (3)          Both
         (x)          Don't know
         (r)          Refused

N2     **At the time of the incident(s), did the child/children who did this to you live with you?**

         **INT:===If respondent answers "Yes"  then probe as to whether it was during the whole period or
         if it was during some of the time===**

         (1)          Yes, during the whole period of abuse
         (2)          Yes, during some of the time of abuse
         (3)          No
         (x)          Don't know
         (r)          Refused

N3     **During (these) this incident(s), were you (ever) physically injured in any way?**

         (1)          Yes
         (3)          No               *[Go to N7]*
         (r)          Refused          *[Go to N7]*

*CATI-N3e:   If H10 = (3) or H12 = (0) or H12 = "Off path" or ((2) LE H11 LE (10) and
                  H12 = H11) and (H11 and H12 = "On path")), Go to N5*

N4     **Did any of these incidents in which you were injured happen in the past 12 months?**

         (1)          Yes
         (3)          No
         (x)          Don't know
         (r)          Refused

--- page 82 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

N5     **During the past 5 years, did you ever receive any medical attention at a hospital as a result
       of the violence?**
       (Include treatment received at emergency or as an out-patient.)

       (1)     Yes
       (3)     No          *[Go to N6]*
       (r)     Refused     *[Go to N6]*

N5A    **Did you stay in hospital overnight?**

       (1)     Yes
       (3)     No          *[Go to N7]*
       (r)     Refused     *[Go to N7]*

N5B    **For how many nights?**

       |__|__|__| *[CATI: 0-999]*
       (r)     Refused

*[Go to N7]*

N6     **During the past 5 years, did you ever receive any medical attention from a doctor or a nurse
       for your injuries?**
       (Include medical attention received immediately after the attack as well as any medical attention
       received as a result of the injuries.)

       (1)     Yes
       (3)     No
       (r)     Refused

N7     **As a result of the violence (and excluding any time you spent in the hospital), did you, during the
       past 5 years, ever have to stay in bed for all or most of a day?**
       (Include time spent in bed for injuries as well as for stress reasons.)

       **INT:=Most of a day means at least 6 hours over and above the time the respondent normally
       spends sleeping.=**

       (1)     Yes
       (3)     No          *[Go to N8]*
       (r)     Refused     *[Go to N8]*

--- page 83 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

N7A   **For how many days?**

         **INT:=== Count each day the respondent spent at least 6 hours in bed over and above the time he/she
         normally spends sleeping===**

         |__|__|__| *[CATI: 0-999]*
         (x)      Don't know
         (r)      Refused

N8    **(Other than the time you spent in the hospital or at home in bed,) during the past 5 years, did you
         ever have to take time off from your everyday activities because of what happened to you?**

         **INT:===Select (1) (yes) if the respondent's everyday activities were disrupted for at least 6 hours===**

         (1)      Yes
         (3)      No
         (x)      Don't know
         (r)      Refused

N9    **During (these) this incident(s) was/were your child/children drinking?**

         **INT:===Select (1) (yes) if the respondent says usually or during more than half of the incidents.===**

         (1)      Yes
         (3)      No
         (5)      Does not drink
         (x)      Don't know
         (r)      Refused

N10   **During the past 5 years, was anyone (else) ever harmed or threatened during this  (these)
         incident(s)?**

         (1)      Yes
         (3)      No                    *[Go to N12]*
         (x)      Don't know            *[Go to N12]*
         (r)      Refused               *[Go to N12]*

N10A **How many persons?**

         |__|__| *[CATI: 0-99]*
         (x)      Don't know
         (r)      Refused

79

--- page 84 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

N11   **Were any of these people who were harmed or threatened under 15 years of age?**

         (1)     Yes
         (3)     No               *[Go to N12]*
         (x)     Don't know       *[Go to N12]*
         (r)     Refused          *[Go to N12]*

N11A  **How many persons?**

         |__|__| *[CATI: 0-99]*
         (x)     Don't know
         (r)     Refused

N12   **During the past 5 years, did you ever fear that your life was in danger because of your
         child's/children's violent or threatening behaviour?**

         (1)     Yes
         (3)     No
         (r)     Refused

N13   **During the past 5 years, did you ever attempt to obtain compensation, through a civil or criminal
         court or a provincial compensation program, because of the violence?**

         (1)     Yes
         (3)     No               *[Go to N14]*
         (r)     Refused          *[Go to N14]*

N13A  **Did you obtain any compensation?**

         (1)     Yes
         (3)     No
         (5)     Not yet resolved
         (r)     Refused

N14   **Did the police ever find out about the violence in any way?**

         **INT:=== If the respondent or the respondent's child or a member of the household is a police
         officer, select (1) (yes) only if it was reported to the police.===**

         (1)     Yes
         (3)     No               *[Go to N21A]*
         (x)     Don't know       *[Go to N23]*
         (r)     Refused          *[Go to N23]*

*CATI-N14e:   If (H10 = (3) and (H13 is less than 12 months ago and H13 = "On path")) or
                (2 LE H11 LE 10 and H11 = H12 and (H11 and H12 = "On path")),
                Go to N16.*

80

--- page 85 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

N15     **Did they find out about it in the past 12 months?**

        (1)     Yes
        (3)     No
        (x)     Don't know
        (r)     Refused

N16     **How did they learn about it?  Was it from you or some other way?**

        **INT:=== If respondent answers both himself/herself and some other way - select (1).===**

        (1)     Respondent
        (3)     Some other way                    *[Go to N18]*
        (x)     Don't know                        *[Go to N23]*
        (r)     Refused                           *[Go to N23]*

N17     **People have different reasons for reporting incidents to the police.  Did any of the following have anything to do with why you reported the violence? Was it…**

                                        **INT: ===READ LIST===**

                                                        Yes    No   Don't know   Refused

        a)      To stop the violence or receive protection?     (1)     (3)     (x)     (r)
        b)      To arrest and punish your child?                (1)     (3)     (x)     (r)
        c)      Because you felt it was your duty to notify police?  (1)  (3)  (x)     (r)
        d)      On the recommendation of someone else?          (1)     (3)     (x)     (r)

N18     **What action did the police take?**

                                **INT:===Mark all that apply.===**

        (n)     None                                      *[Go to N19]*
        (1)     Visited Scene
        (2)     Made a report/Conducted an investigation
        (3)     Gave warning to child/children
        (4)     Took child/children away
        (5)     Made arrest/Laid charges
        (6)     Put in touch with community services
        (7)     Other                                     *[Go to N18S]*
        (r)     Refused                                   *[Go to N19]*
        (0)     No other; continue                        *[Go to N19]*

N18S    Specify
        |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
        |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
*CATI: Length of field = 28*

81

--- page 86 ---

GSS – Cycle 13 – Victimization                                                                                               Appendix B

N19     **How satisfied were you with the actions that the police took?  Were you …**

                                          INT:===READ LIST===

          (1)          Very satisfied?
          (2)          Somewhat satisfied?
          (3)          Somewhat dissatisfied?
          (4)          Very dissatisfied?

          (r)          Refused

N20     **Is there anything (else) they should have done to help you?**

                                          INT:===Mark all that apply.===

          (n)          No/nothing                              *[Go to N23]*
          (1)          Take the person out of the house
          (2)          Charge/arrest the person
          (3)          Respond more quickly
          (4)          Refer/take you to a support service
          (5)          Relocate you
          (6)          Take you to hospital
          (7)          Be more supportive/sympathetic
          (8)          Other                                   *[Go to N20S]*
          (x)          Don't know                             *[Go to N23]*
          (r)          Refused                                *[Go to N23]*
          (0)          No other; continue                     *[Go to N23]*

N20S   Specify
          |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
          |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
*[CATI]: Length of field = 50*

*[Go to N23]*

N21A  **I'm going to read a list of reasons why some people choose not to contact the police.  Please tell me which ones apply to your experience.  Was it…
          Because it was dealt with another way?**
          (e.g. reported to another official, private matter that took care of myself, etc.)

          (1)          Yes
          (3)          No
          (r)          Refused

82

--- page 87 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

N21B  **(I'm going to read a list of reasons why some people choose not to contact the police.  Please tell me which ones apply to your experience.  Was it…)
         Because of fear of your child/children?**

         (1)          Yes
         (3)          No
         (r)          Refused

N21C  **(I'm going to read a list of reasons why some people choose not to contact the police.  Please tell me which ones apply to your experience.  Was it…)
         Because the police couldn't do anything about it?**

         (1)          Yes
         (3)          No
         (r)          Refused

N21D  **(I'm going to read a list of reasons why some people choose not to contact the police.  Please tell me which ones apply to your experience.  Was it…)
         Because the police wouldn't help?**
         (e.g. wouldn't think it was important enough, wouldn't believe, wouldn't want to be bothered or
         get involved, police would be inefficient or ineffective, police would be biased, would
         harass/insult respondent, offender was police officer)

         (1)          Yes
         (3)          No
         (r)          Refused

N21E  **(I'm going to read a list of reasons why some people choose not to contact the police.  Please tell me which ones apply to your experience.  Was it…)
         Because you didn't want to get involved with police?**

         (1)          Yes
         (3)          No
         (r)          Refused

N21X  **(I'm going to read a list of reasons why some people choose not to contact the police.  Please tell me which ones apply to your experience.  Was it…)
         Because you didn't want your child/children arrested or jailed?**

         (1)          Yes
         (3)          No
         (r)          Refused

83

--- page 88 ---

GSS – Cycle 13 – Victimization                                                                                              Appendix B

N21G **(I'm going to read a list of reasons why some people choose not to contact the police.  Please tell me which ones apply to your experience.  Was it…)
Because the incident was a personal matter that didn't concern the police?**

        (1)        Yes
        (3)        No
        (r)        Refused

N21Y **(I'm going to read a list of reasons why some people choose not to contact the police.  Please tell me which ones apply to your experience.  Was it…)
Because you didn't want anyone to find out about it?** (e.g. shame, embarrassment)

        (1)        Yes
        (3)        No
        (r)        Refused

N21H **(I'm going to read a list of reasons why some people choose not to contact the police.  Please tell me which ones apply to your experience.  Was it…)
Because of fear of publicity/news coverage ?**

        (1)        Yes
        (3)        No
        (r)        Refused

N21F **(I'm going to read a list of reasons why some people choose not to contact the police.
Please tell me which ones apply to your experience.  Was it…)
Because it was not important enough to you?** (e.g. minor crime, no intended harm, etc.)

        (1)        Yes
        (3)        No
        (r)        Refused

N21K **(I'm going to read a list of reasons why some people choose not to contact the police.  Please tell me which ones apply to your experience.  Was it…)
For some other reason, not already mentioned?**

        (1)        Yes
        (3)        No              *[Go to CATI-N21e]*
        (r)        Refused         *[Go to CATI-N21e]*

N21S   Specify
        |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
        |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
*[CATI]: Length of field = 50*

*CATI- N21e:   If the number of (1)'s in N21A to N21K <= 1 then Go to N23.*

84

--- page 89 ---

GSS – Cycle 13 – Victimization                                                                                               Appendix B

N22     **What was the main reason?**

        (1)     Dealt with another way
        (2)     Fear
        (3)     Police couldn't do anything
        (4)     Police wouldn't help
        (5)     Did not want to get involved with police
        (6)     Not important enough to respondent
        (7)     A personal matter that did not concern the police
        (8)     Fear of publicity/media coverage
        (11)    Didn't want child/children arrested or jailed
        (12)    Didn't want anyone to find out about it
        (13)    Other
        (r)     Refused

N23     **(Other than to the police,) did you ever talk to anyone about (these) this incident(s), such as ...**

                                        INT: ===READ LIST===

                                                Yes     No      Don't Know      Refused
        a)      Family?                         (1)     (3)         (x)           (r)
        b)      Friend or neighbour?            (1)     (3)         (x)           (r)
        c)      Co-worker?                      (1)     (3)         (x)           (r)
        d)      Doctor or nurse?                (1)     (3)         (x)           (r)
        e)      Lawyer?                         (1)     (3)         (x)           (r)
        f)      Minister, priest, clergy
                or another spiritual advisor?   (1)     (3)         (x)           (r)

85

--- page 90 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

N24     **During the past 5 years, did you ever contact or use any of the following services for help because of the violence, such as …**
        ( "Victim Assistance Units" operate within a specific police office, and help victims at the police end of the justice system.  "'Victim Services" help victims as their cases proceed through the justice system (police, courts and corrections).  Services include providing general information about the justice system, referrals, assistance with court, help preparing victim impact statements, offering emotional support and providing information to help victims recover financial losses resulting from the crime.)

                                        INT: ===READ LIST===

                                                          Yes     No    Don't know Refused
        a)      Crisis centre or crisis line?             (1)     (3)      (x)        (r)
        b)      Another counsellor or psychologist?       (1)     (3)      (x)        (r)
        c)      Community centre or family centre?        (1)     (3)      (x)        (r)
        d)      Shelter or transition house?
                *[CATI: only if female respondent]*       (1)     (3)      (x)        (r)
        e)      Women's centre? *[CATI: only if female respondent]*  (1)  (3)  (x)   (r)
        f)      Men's centre or men's support group?
                *[CATI: only if male respondent]*         (1)     (3)      (x)        (r)
        g)      Seniors' centre?                          (1)     (3)      (x)        (r)
        h)      Police-based or court-based victim services?  (1) (3)      (x)        (r)

*CATI-N24e:   "For each of N24a) to N24h):
              If answer = (1) then
                    If (H10 = (3) and H13 is less than 12 months ago and (H11, H12 and H13 = "On path"))
                    or (2 LE H11 LE 10 and H12 > H13 and (H11, H12 and H13 = "On path"))  then  Go
                    to next question in N24;  Else
              Go to N24A and then return to next question in N24; Else
              Go to next question in N24"*

N24A  **Was this in the past 12 months?**
a to h
        (1)     Yes
        (3)     No
        (r)     Refused

*CATI-N24Ae:  If not all N24a) to N24h) = (3), Go to N26.*

86

--- page 91 ---

GSS – Cycle 13 – Victimization                                                                                                               Appendix B

N25   **Is there any reason why you didn't use any of these services?**

                                          **INT:===Mark all that apply.===**

          (1)        Didn't know of any services
          (2)        None available
          (3)        Waiting list
          (4)        Too minor
          (5)        Shame/embarrassment
          (6)        Wouldn't be believed
          (7)        Offender prevented me
          (8)        Distance
          (9)        Fear of losing financial support
          (11)       Didn't want relationship with children to end
          (12)       Didn't want/need help
          (13)       Other                                    *[Go to N25S]*
          (x)        Don't know/no reason                    *[Go to N26]*
          (r)        Refused                                  *[Go to N26]*
          (0)        No other; continue                       *[Go to N26]*

N25S  Specify
          |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
          |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
*CATI: Length of field =28*

*CATI-N26e:  If this is the first time the following question is asked read conditional text 1;  else read
                    conditional text 2.*

N26   **(There are a number of ways to deal with an offence outside the normal police-court process.  One
      way is a meeting between the victim and the offender to discuss an appropriate way the offender
      should be dealt with.  Thinking about your experience, how interested would you be (have been)
      in participating in such a program if one was available in your community?)
      (Thinking about the incident(s), how interested would you be (have been) in participating in a
      program where the victim and the offender meet to discuss an appropriate way the offender
      should be dealt with?)
      Would you be (have been) …**

                                          **INT: ===READ LIST===**

          (1)        Very interested?
          (2)        Somewhat interested?
          (3)        Slightly interested?
          (4)        Not at all interested?

          (r)        Refused

87

--- page 92 ---

GSS – Cycle 13 – Victimization                                                                                                       Appendix B

N27   At the time of the incident(s), how did this experience affect you?

                        INT:===Mark all that apply.===
               INT:===Do not include physical injury, financial loss or medical treatment.===

          (2)      Angry
          (3)      Ashamed/guilty
          (4)      Depression/ anxiety attacks
          (5)      Fearful
          (6)      Hurt/disappointment
          (7)      Increased self-reliance
          (8)      Lowered self esteem
          (9)      More cautious/aware
          (10)     Not much
          (11)     Problems relating to your children
          (12)     Shock/disbelief
          (13)     Sleeping problems
          (14)     Upset/confused/frustrated
          (15)     Other                                    [Go to N27S]
          (x)      Don't know                               [Go to N28]
          (r)      Refused                                  [Go to N28]
          (0)      No other; continue                       [Go to N28]

N27S  Specify
          |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
          |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
[CATI]: Length of field = 50

N28   From your experience, what advice, if any, would you give another person in a similar situation?

          |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
          |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
          (n)      No/Nothing
          (x)      Don't know
          (r)      Refused
[CATI]: Length of field = 50

88

--- page 93 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

SECTION P:  SENIOR ABUSE BY CAREGIVER REPORT

P0     *Date / Time stamp*

*CATI-P0e: If SGABUSE = (0), Go to Q0.*

P1     **You said that during the past 5 years, your caregiver was violent.**

P2     **What is/was your caregiver's relationship to you?**

                                          INT:===Mark all that apply.===

          (1)     Son-in-law
          (2)     Daughter-in-law
          (3)     Brother
          (4)     Sister
          (5)     Caregiver from an agency/organization
          (6)     Healthcare worker
          (7)     Friend/acquaintance
          (8)     Neighbour
          (9)     Other                          *[Go to P2S]*
          (x)     Don't know                     *[Go to P3]*
          (r)     Refused                        *[Go to P3]*
          (0)     No other; continue             *[Go to P3]*

P2S   Specify
         |_|_|_|_|_|_|_|_|_|_|_|_|_|_|
         |_|_|_|_|_|_|_|_|_|_|_|_|_|_|
*CATI: Length of field = 28*

P3     **During (these) this incident(s), were you (ever) physically injured in any way?**

          (1)     Yes
          (3)     No                             *[Go to P7]*
          (r)     Refused                        *[Go to P7]*

*CATI-P3e:    If K11 = (3) or K13 = (0) or (K13 = "Off path")  or ((2) LE K12 LE (10) and K13 = K12    and (K12 and K13 = "On path")), Go to P5.*

P4     **Did any of these incidents in which you were injured happen in the past 12 months?**

          (1)     Yes
          (3)     No
          (x)     Don't know
          (r)     Refused

89

--- page 94 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

P5     **During the past 5 years, did you ever receive any medical attention at a hospital as a result of
       the violence?**
       (Include treatment received at emergency or as an out-patient.)

       (1)     Yes
       (3)     No          *[Go to P6]*
       (r)     Refused     *[Go to P6]*

P5A    **Did you stay in hospital overnight?**

       (1)     Yes
       (3)     No          *[Go to P7]*
       (r)     Refused     *[Go to P7]*

P5B    **For how many nights?**

       |__|__|__| *[CATI: 0-999]*
       (r)     Refused

*[Go to P7]*

P6     **During the past 5 years, did you ever receive any medical attention from a doctor or a
       nurse for your injuries?**
       (Include medical attention received immediately after the attack as well as any medical attention
       received as a result of the injuries.)

       (1)     Yes
       (3)     No
       (r)     Refused

P7     **As a result of the violence (and excluding any time you spent in the hospital), did you, during the
       past 5 years, ever have to stay in bed for all or most of a day?**
       (Include time spent in bed for injuries as well as for stress reasons.)

       **INT:=Most of a day means at least 6 hours over and above the time the respondent normally
       spends sleeping.=**

       (1)     Yes
       (3)     No          *[Go to P8]*
       (r)     Refused     *[Go to P8]*

--- page 95 ---

GSS – Cycle 13 – Victimization                                                                    Appendix B

P7A   **For how many days?**

      **INT:=== Count each day the respondent spent at least 6 hours in bed over and above the time he/she
      normally spends sleeping.===**

      |__|__|__| *[CATI: 0-999]*
      (x)      Don't know
      (r)      Refused

P8    **(Other than the time you spent in the hospital or at home in bed,) During the past 5 years, did you
      ever have to take time off from your everyday activities because of what happened to you?**

      **INT:=== Select (1) (yes) if the respondent's everyday activities were disrupted for at least 6
      hours.===**

      (1)      Yes
      (3)      No
      (x)      Don't know
      (r)      Refused

P9    **During (these) this incident(s) was your caregiver drinking?**

      **INT:=== Select (1) (yes) if the respondent says usually or during more than half of the incidents.===**

      (1)      Yes
      (3)      No
      (5)      Doesn't drink
      (x)      Don't know
      (r)      Refused

P10   **During the past 5 years, was anyone (else) ever harmed or threatened during (this) these
      incident(s)?**

      (1)      Yes
      (3)      No                    *[Go to P12]*
      (x)      Don't know            *[Go to P12]*
      (r)      Refused               *[Go to P12]*

P10A  **How many persons?**

      |__|__| *[CATI: 0-99]*
      (x)      Don't know
      (r)      Refused

91

--- page 96 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

P11     **Were any of these people who were harmed or threatened under 15 years of age?**

        (1)     Yes
        (3)     No                *[Go to P12]*
        (x)     Don't know        *[Go to P12]*
        (r)     Refused           *[Go to P12]*

P11A  **How many persons?**

        |__|__|  *[CATI: 0-99]*
        (x)     Don't know
        (r)     Refused

P12     **During the past 5 years, did you ever fear that your life was in danger because of your caregiver's violent or threatening behaviour?**

        (1)     Yes
        (3)     No
        (r)     Refused

P13     **During the past 5 years, did you ever attempt to obtain compensation, through a civil or criminal court or a provincial compensation program, because of the violence?**

        (1)     Yes
        (3)     No                *[Go to P14]*
        (r)     Refused           *[Go to P14]*

P13A  **Did you obtain any compensation?**

        (1)     Yes
        (3)     No
        (5)     Not yet resolved
        (r)     Refused

P14     **Did the police ever find out about the violence in any way?**

        **INT:===If the respondent or the respondent's caregiver or a member of the household is a police officer, select (1) (yes) only if it was reported to the police.===**

        (1)     Yes
        (3)     No                *[Go to P21A]*
        (x)     Don't know        *[Go to P23]*
        (r)     Refused           *[Go to P23]*

*CATI-P14e:   If ( K11 = (3) and (K14 is less than 12 months ago and K14 = "On path")) or ((2) LE K12 LE (10) and K13 = K12 and (K12 and K13 = "On path")), Go to P16.*

92

--- page 97 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

P15     **Did they find out about it in the past 12 months?**

        (1)     Yes
        (3)     No
        (x)     Don't know
        (r)     Refused

P16     **How did they learn about it?  Was it from you or some other way?**

        **INT:=== If respondent answers both himself/herself and some other way - select (1).===**

        (1)     Respondent
        (3)     Some other way          *[Go to P18]*
        (x)     Don't know              *[Go to P23]*
        (r)     Refused                 *[Go to P23]*

P17     **People have different reasons for reporting incidents to the police.  Did any of the following have anything to do with why you reported the violence?  Was it …**

                                        **INT: ===READ LIST===**

                                                          Yes    No   Don't know   Refused

        a)      To stop the violence or receive protection?      (1)    (3)    (x)          (r)
        b)      To arrest and punish your caregiver?             (1)    (3)    (x)          (r)
        c)      Because you felt it was your duty to notify police?  (1)  (3)  (x)         (r)
        d)      On the recommendation of someone else?           (1)    (3)    (x)          (r)

P18     **What action did the police take?**

                                **INT:===Mark all that apply.===**

        (n)     None                                    *[Go to P19]*
        (1)     Visited Scene
        (2)     Made a report/Conducted an investigation
        (3)     Gave warning to caregiver
        (4)     Took caregiver away
        (5)     Made arrest/Laid charges
        (6)     Put in touch with community services
        (7)     Other                                   *[Go to P18S]*
        (r)     Refused                                 *[Go to P19]*
        (0)     No other; continue                      *[Go to P19]*

P18S    Specify
        |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
        |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
*CATI: Length of field = 28*

93

--- page 98 ---

GSS – Cycle 13 – Victimization                                                                                                       Appendix B

P19     How satisfied were you with the actions that the police took?  Were you …

INT:===READ LIST===

          (1)          Very satisfied?
          (2)          Somewhat satisfied?
          (3)          Somewhat dissatisfied?
          (4)          Very dissatisfied?
          (r)          Refused

P20     Is there anything (else) they should have done to help you?

INT:===Mark all that apply.===

          (n)          No/nothing                          [Go to P23]
          (1)          Take the person out of the house
          (2)          Charge/arrest the person
          (3)          Respond more quickly
          (4)          Refer/take you to a support service
          (5)          Relocate you
          (6)          Take you to hospital
          (7)          Be more supportive/sympathetic
          (8)          Other                               [Go to P20S]
          (x)          Don't know                          [Go to P23]
          (r)          Refused                             [Go to P23]
          (0)          No other; continue                  [Go to P23]

P20S   Specify
|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
[CATI]: Length of field = 50

[Go to P23]

P21A  I'm going to read a list of reasons why some people choose not to contact the police.  Please tell me which ones apply to your experience.  Was it…
Because it was dealt with another way?
(e.g. reported to another official, private matter that took care of myself, etc.)

          (1)          Yes
          (3)          No
          (r)          Refused

94

--- page 99 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

P21B  **(I'm going to read a list of reasons why some people choose not to contact the police.  Please tell me which ones apply to your experience.  Was it…)
         Because of fear of your caregiver?**

         (1)          Yes
         (3)          No
         (r)          Refused

P21C  **(I'm going to read a list of reasons why some people choose not to contact the police.  Please tell me which ones apply to your experience.  Was it…)
         Because the police couldn't do anything about it?**

         (1)          Yes
         (3)          No
         (r)          Refused

P21D  **(I'm going to read a list of reasons why some people choose not to contact the police.  Please tell Me which ones apply to your experience.  Was it…)
         Because the police wouldn't help?**
         (e.g. wouldn't think it was important enough, wouldn't believe, wouldn't want to be bothered
         or get involved, police would be inefficient or ineffective, police would be    biased, would
         harass/insult respondent, offender was police officer)

         (1)          Yes
         (3)          No
         (r)          Refused

P21E  **(I'm going to read a list of reasons why some people choose not to contact the police.  Please tell me which ones apply to your experience.  Was it…)
         Because you didn't want to get involved with police?**

         (1)          Yes
         (3)          No
         (r)          Refused

P21X  **(I'm going to read a list of reasons why some people choose not to contact the police.  Please tell me which ones apply to your experience.  Was it…)
         Because you didn't want your caregiver arrested or jailed?**

         (1)          Yes
         (3)          No
         (r)          Refused

95

--- page 100 ---

GSS – Cycle 13 – Victimization                                                                                              Appendix B

P21G  **(I'm going to read a list of reasons why some people choose not to contact the police.  Please tell me which ones apply to your experience.  Was it…)
Because the incident was a personal matter that didn't concern the police?**

   (1)        Yes
   (3)        No
   (r)        Refused

P21Y  **(I'm going to read a list of reasons why some people choose not to contact the police.  Please tell me which ones apply to your experience.  Was it…)
Because you didn't want anyone to find out about it?**  (e.g. shame, embarrassment)

   (1)        Yes
   (3)        No
   (r)        Refused

P21H  **(I'm going to read a list of reasons why some people choose not to contact the police.  Please tell me which ones apply to your experience.  Was it…)
Because of fear of publicity/news coverage ?**

   (1)        Yes
   (3)        No
   (r)        Refused

P21F  **(I'm going to read a list of reasons why some people choose not to contact the police.  Please tell me which ones apply to your experience.  Was it…)
Because it was not important enough to you?**  (e.g. minor crime, no intended harm, etc.)

   (1)        Yes
   (3)        No
   (r)        Refused

P21K  **(I'm going to read a list of reasons why some people choose not to contact the police.  Please tell me which ones apply to your experience.  Was it…)
For some other reason, not already mentioned?**

   (1)        Yes
   (3)        No          *[Go to CATI-P21e]*
   (r)        Refused     *[Go to CATI-P21e]*

P21S  Specify
   |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
   |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
*[CATI]: Length of field = 50*

*CATI- P21e:   If the number of (1)'s in P21A to P21K <= 1 then     Go to P23.*

96

--- page 101 ---

GSS – Cycle 13 – Victimization                                                                                               Appendix B

P22     **What was the main reason?**

        (1)     Dealt with another way
        (2)     Fear
        (3)     Police couldn't do anything
        (4)     Police wouldn't help
        (5)     Did not want to get involved with police
        (6)     Not important enough to respondent
        (7)     A personal matter that did not concern the police
        (8)     Fear of publicity/media coverage
        (11)    Didn't want caregiver arrested or jailed
        (12)    Didn't want anyone to find out about it
        (13)    Other
        (r)     Refused

P23     **(Other than to the police,) did you ever talk to anyone about what happened, such as ...**

                                        INT: ===READ LIST===

                                                Yes       No        Don't Know     Refused
        a)      Family?                         (1)       (3)       (x)            (r)
        b)      Friend or neighbour?            (1)       (3)       (x)            (r)
        c)      Co-worker?                      (1)       (3)       (x)            (r)
        d)      Doctor or nurse?                (1)       (3)       (x)            (r)
        e)      Lawyer?                         (1)       (3)       (x)            (r)
        f)      Minister, priest, clergy
                or another spiritual advisor?   (1)       (3)       (x)            (r)

--- page 102 ---

GSS – Cycle 13 – Victimization                                                                                     Appendix B

P24     **During the past 5 years, did you ever contact or use any of the following services for help because of the violence, such as …**
("Victim Assistance Units" operate within a specific police office, and help victims at the police end of the justice system.  "Victim Services" help victims as their cases proceed through the justice system (police,  courts and corrections).   Services include providing general information about the justice system, referrals, assistance with court, help preparing victim impact statements, offering emotional support and providing information to help victims recover financial losses resulting from the crime.)

                                    **INT: ===READ LIST===**

                                                            Yes     No      Don't know Refused
        a)      Crisis centre or crisis line?               (1)     (3)        (x)         (r)
        b)      Another counsellor or psychologist?         (1)     (3)        (x)         (r)
        c)      Community centre or family centre?          (1)     (3)        (x)         (r)
        d)      Shelter or transition house?
                *[CATI: only if female respondent]*         (1)     (3)        (x)         (r)
        e)      Women's centre? *[CATI: only if female respondent]*  (1)  (3)  (x)         (r)
        f)      Men's centre or men's support group?
                *[CATI: only if male respondent]*           (1)     (3)        (x)         (r)
        g)      Seniors' centre?                            (1)     (3)        (x)         (r)
        h)      Police-based or court-based victim services?  (1)   (3)        (x)         (r)

*CATI-P24e:   "For each of P24a) to P24h):
              If answer = (1) then
                    If (K11 = (3) and K14 is less than 12 months ago and (K11, K12 and K13 = "On path"))
                    or (2 LE K12 LE 10 and K12 > K13 and (K12 and K13 = "On path"))  then
                       Go to next question in P24;   Else
              Go to P24A and then return to next question in P24; Else
              Go to next question in P24"*

P24A    **Was this in the past 12 months?**
a to h
        (1)     Yes
        (3)     No
        (r)     Refused

*CATI-P24Ae:  If not all P24a) to P24h) = (3), Go to P26*

98

--- page 103 ---

GSS – Cycle 13 – Victimization                                                                                                       Appendix B

P25     **Is there any reason why you didn't use any of these services?**

                                          **INT:===Mark all that apply.===**

          (1)       Didn't know of any services
          (2)       None available
          (3)       Waiting list
          (4)       Too minor
          (5)       Shame/embarrassment
          (6)       Wouldn't be believed
          (7)       Offender prevented me
          (8)       Distance
          (9)       Fear of losing financial support
          (11)      Didn't want relationship with caregiver to end
          (12)      Didn't want/need help
          (13)      Other                              *[Go to P25S]*
          (x)       Don't know/no reason               *[Go to P26]*
          (r)       Refused                            *[Go to P26]*
          (0)       No other; continue                 *[Go to P26]*

P25S  Specify
          |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
          |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
*CATI: Length of field =28*

*CATI-P26e:  If this is the first time the following question is asked read conditional text 1;  else read
                    conditional text 2.*

P26     **(There are a number of ways to deal with an offence outside the normal police-court process.  One
          way is a meeting between the victim and the offender to discuss an appropriate way the offender
          should be dealt with.  Thinking about your experience, how interested would you be (have been)
          in participating in such a program if one was available in your community?)
          (Thinking about the incident(s), how interested would you be (have been) in participating in a
          program where the victim and the offender meet to discuss an appropriate way the offender
          should be dealt with?)
          Would you be (have been) …**

                                          **INT: ===READ LIST===**

          (1)       Very interested?
          (2)       Somewhat interested?
          (3)       Slightly interested?
          (4)       Not at all interested?

          (r)       Refused

99

--- page 104 ---

GSS – Cycle 13 – Victimization                                                                                                       Appendix B

P27     At the time of the incident(s), how did this experience affect you?

                              INT:===Mark all that apply.===
                    INT:===Do not include physical injury, financial loss or medical treatment.===

          (2)       Angry
          (3)       Ashamed/guilty
          (4)       Depression/ anxiety attacks
          (5)       Fearful
          (6)       Hurt/disappointment
          (7)       Increased self-reliance
          (8)       Lowered self esteem
          (9)       More cautious/aware
          (10)      Not much
          (12)      Shock/disbelief
          (13)      Sleeping problems
          (14)      Upset/confused/frustrated
          (15)      Other                                    [Go to P27S]
          (x)       Don't know                               [Go to P28]
          (r)       Refused                                  [Go to P28]
          (0)       No other; continue                       [Go to P28]

P27S    Specify
          |_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|
          |_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|
[CATI]: Length of field = 50


P28     From your experience, is there any advice you would give another person in a similar situation?

          |_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|
          |_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|
          (n)       No/Nothing
          (x)       Don't know
          (r)       Refused

[CATI]: Length of field =50

100

--- page 105 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

SECTION Q:  CLASSIFICATION

Q0     *Date / Time stamp*

Q1     **Now, I'd like to ask you for some background information.
     In what type of dwelling are you now living?  Is it a . . .**

                              **INT: ===READ LIST===**
               **INT:===If respondent answers condominium or seniors' housing, ask whether the
                         building is a townhouse or high-rise or low-rise apartment===**

          (1)          Single detached house?
          (2)          Semi-detached or double (side by side)?
          (3)          Garden house, town-house or row house?
          (4)          Duplex (one above the other)?
          (5)          Low-rise apartment (less than 5 stories)?
          (6)          High-rise apartment (5 or more stories)**?**
          (7)          Mobile home or trailer?

          (8)          Other                    *[Go to Q1S]*
          (r)          Refused

*[Go to Q2]*

Q1S     Specify
          |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
          |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
     *[CATI]: Length of field = 28*

Q2     **Is this dwelling owned by a member of this household?**

          (1)          Yes
          (3)          No
          (x)          Don't know
          (r)          Refused

Q2A     **How long have you lived in this dwelling?**

          (1)          Less than six months
          (2)          6 months to less than 1 year
          (3)          1 year to less than 3 years
          (4)          3 years to less than 5 years
          (5)          5 years and over
          (x)          Don't know
          (r)          Refused

101

--- page 106 ---

GSS – Cycle 13 – Victimization                                                                                     Appendix B

Q3     **What is your postal code (for your current residence)?**
       (( We use postal codes to determine if the respondent lives in an urban or rural area. If the respondent lives
       in a rural area and receives his/her mail at a post office in a nearby town, obtain the postal code of his/her
       residence if possible, otherwise enter the postal code of the mailing address.)
       We require at least the first two digits of the postal code to determine if the residence is in an urban or
       rural area.)

       |_|_|_|_|  |_|_|_|_|
       (x)     Don't know
       (r)     Refused

Q4     **Canadians come from many cultural or racial backgrounds.  I'm going to read you a list.
       Are you...**

                            **INT:=== READ LIST - Maximum 4 answers.===**

       (1)     White?
       (2)     Chinese?
       (3)     Aboriginal, that is North American Indian, Métis, or Inuit?
       (4)     South Asian? (e.g., East Indian, Pakistani, Punjabi, Sri Lankan)
       (5)     Black ? (e.g., African, Haitian, Jamaican, Somali)
       (6)     Filipino?
       (7)     Latin American?
       (8)     Southeast Asian?  (e.g., Cambodian, Indonesian, Laotian, Vietnamese)
       (9)     Arab? (e.g., Egyptian, Lebanese, Moroccan)
       (10)    Central or West Asian? (e.g. Afghan, Iranian, Turk)
       (11)    Japanese?
       (12)    Korean?
       (13)    Other          *[Go to Q4S]*
       (x)     Don't know     *[Go to Q5]*
       (r)     Refused        *[Go to Q5]*
       (0)     No other, continue     *[Go to Q5]*

Q4S    Specify
       |_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|
       |_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|
*[CATI]: Length of field = 28*

Q5     **In what country were you born?**
       (Report place of birth according to current boundaries**)**

       (1)     Canada
       (3)     Country outside Canada     *[Go to Q6B]*
       (x)     Don't know                 *[Go to Q8]*
       (r)     Refused                    *[Go to Q8]*

102

--- page 107 ---

GSS – Cycle 13 – Victimization                                                                                               Appendix B

Q6A   **In which province or territory?**
      (Report place of birth according to current boundaries**)**)

      (1)      Newfoundland/Labrador
      (2)      Prince Edward Island
      (3)      Nova Scotia
      (4)      New Brunswick
      (5)      Quebec
      (6)      Ontario
      (7)      Manitoba
      (8)      Saskatchewan
      (9)      Alberta
      (10)     British Columbia
      (11)     Yukon Territory
      (12)     Northwest Territories
      (13)     Nunavut

*[Go to Q8]*

Q6B   **In which country?**
      (Report place of birth according to current boundaries**)**)

      (1)      China
      (2)      England
      (3)      France
      (4)      Germany
      (5)      Greece
      (6)      Guyana
      (7)      Hong Kong
      (8)      India
      (9)      Italy
      (10)     Jamaica
      (11)     Netherlands
      (12)     Philippines
      (13)     Poland
      (14)     Portugal
      (15)     Scotland
      (16)     United States
      (17)     Vietnam
      (18)     Other               *[Go to Q6S]*
      (x)      Don't know
      (r)      Refused

*[Go to Q7]*

Q6S  Specify
     |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
     |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|

103

--- page 108 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

*[CATI]: Length of field = 28*

Q7    **In what year did you first come to Canada to live permanently?**
         ( For respondents who first came to Canada as landed immigrants, report the year they
         obtained landed immigrant status.
         For respondents who lived in Canada as foreign students, foreign workers, or refugee claimants prior to
         obtaining landed immigrant status, report the year they first came to Canada to live permanently.
         If the respondent was born outside of Canada of Canadian parents and was registered as Canadian at
         birth, report as "Canadian citizen by birth".)

         |__|__|__|__| *[CATI: 1900-1999]*
         (1)      Canadian citizen by birth
         (x)      Don't know
         (r)      Refused

*CATI-Q7e : Hard edit : Year of birth of the respondent must be < than the year he/she first came to
         Canada to live permanently.*

Q8    **In what country was your mother born?**

         (0)      Canada
         (1)      China
         (2)      England
         (3)      France
         (4)      Germany
         (5)      Greece
         (6)      Guyana
         (7)      Hong Kong
         (8)      India
         (9)      Italy
         (10)     Jamaica
         (11)     Netherlands
         (12)     Philippines
         (13)     Poland
         (14)     Portugal
         (15)     Scotland
         (16)     United States
         (17)     Vietnam
         (18)     Other               *[Go to Q8S]*
         (x)      Don't know
         (r)      Refused

*[Go to Q9]*

--- page 109 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

Q8S  Specify
          |__|__|__|__|__|__|__|__|__|__|__|__|__|__|
          |__|__|__|__|__|__|__|__|__|__|__|__|__|__|
          (s)     Same country as respondent

*[CATI]: Length of field = 28*


Q9     **In what country was your father born?**

          (0)     Canada
          (1)     China
          (2)     England
          (3)     France
          (4)     Germany
          (5)     Greece
          (6)     Guyana
          (7)     Hong Kong
          (8)     India
          (9)     Italy
          (10)    Jamaica
          (11)    Netherlands
          (12)    Philippines
          (13)    Poland
          (14)    Portugal
          (15)    Scotland
          (16)    United States
          (17)    Vietnam
          (18)    Other                    *[Go to Q9S]*
          (x)     Don't know
          (r)     Refused

*[Go to Q9A]*

Q9S  Specify
          |__|__|__|__|__|__|__|__|__|__|__|__|__|__|
          |__|__|__|__|__|__|__|__|__|__|__|__|__|__|
          (s)     Same country as respondent

*[CATI]: Length of field = 28*

--- page 110 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

Q9A   **What is the highest level of education that your mother has attained?**

        (1)     Masters (M.A., M.Sc.,M.Ed.) or earned doctorate (Ph.D., D.Sc., D.Ed.)
        (2)     Degree in Medicine, Dentistry, Veterinary Medicine, or Optometry (M.D., D.D.S., D.M.D.,
                D.V.M., O.D.)
        (3)     Bachelor or undergraduate degree, or teacher's college (B.A., B.Sc., B.A.Sc., B.Ed.)
        (4)     Diploma or certificate from community college, CEGEP or nursing school
        (5)     Diploma or certificate from trade, technical or vocational school, or business college
        (6)     Some university
        (7)     Some community college, CEGEP or nursing school
        (8)     Some trade, technical or vocational school, or business college
        (9)     High School diploma
        (10)    Some High School
        (11)    Elementary School diploma
        (12)    Some Elementary
        (13)    No schooling
        (14)    Other                *[Go to Q9AS]*
        (x)     Don't know
        (r)     Refused

*[Go to Q9B]*

Q9AS  Specify
      |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
      |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
*[CATI]: Length of field = 28*

Q9B   **What is the highest level of education that your father has attained?**

        (1)     Masters (M.A., M.Sc., M.Ed.) or earned doctorate (Ph.D., D.Sc., D.Ed.)
        (2)     Degree in Medicine, Dentistry, Veterinary Medicine, or Optometry (M.D., D.D.S., D.M.D.,
                D.V.M., O.D.)
        (3)     Bachelor or undergraduate degree, or teacher's college (B.A., B.Sc., B.A.Sc., B.Ed.)
        (4)     Diploma or certificate from community college, CEGEP or nursing school
        (5)     Diploma or certificate from trade, technical or vocational school, or business college
        (6)     Some university
        (7)     Some community college, CEGEP or nursing school
        (8)     Some trade, technical or vocational school, or business college
        (9)     High School diploma
        (10)    Some High School
        (11)    Elementary School diploma
        (12)    Some Elementary
        (13)    No schooling
        (14)    Other                *[Go to Q9BS]*
        (x)     Don't know
        (r)     Refused

*[Go to CATI-Q9e]*

106

--- page 111 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

Q9BS  Specify
      |__|__|__|__|__|__|__|__|__|__|__|__|__|__|
      |__|__|__|__|__|__|__|__|__|__|__|__|__|__|
 [CATI]: Length of field = 28

CATI-Q9e - Verify household roster,  if respondent is not currently married, living common-law or same-sex
           partner, Go to Q21A.

Q10   **During the past 12 months, was your spouse's/partner's main activity working at a paid job or
      business, looking for paid work, going to school, caring for children, household work, retired or
      something else?**
      **INT:==== If sickness or short-term illness is reported, ask for usual major activity====**

        (1)    Working at a paid job or business     *[Go to Q13]*
        (2)    Looking for paid work
        (3)    Going to school                       *[Go to Q11]*
        (4)    Caring for children
        (5)    Household work
        (6)    Retired
        (7)    Maternity/paternity leave
        (8)    Long term illness
        (9)    Other, specify                        *[Go to Q10S]*
        (r)    Refused

*[Go to Q12]*

Q10S  Specify
      |__|__|__|__|__|__|__|__|__|__|__|__|__|__|
      |__|__|__|__|__|__|__|__|__|__|__|__|__|__|
 [CATI]: Length of field = 28

*[Go to Q12]*

Q11   **Was he/she studying full-time or part-time?**

        (1)    Full-time
        (3)    Part-time
        (x)    Don't know
        (r)    Refused

Q12   **Did he/she have a job or was he/she self-employed at any time during the past 12 months?**

        (1)    Yes
        (3)    No             *[Go to Q18]*
        (x)    Don't know     *[Go to Q18]*
        (r)    Refused        *[Go to Q18]*

107

--- page 112 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

Q13    **How many weeks did he/she work?**

        |__|__| *[CATI: 1-52]*
        (x)      Don't know
        (r)      Refused

Q14    **Was he/she working full-time or part-time?**

        (1)      Full-time
        (3)      Part-time
        (x)      Don't know
        (r)      Refused

*CATI-Q14e:  If Q13 = 52 weeks – Go to Q18.*

Q15    **During the past 12 months, was he/she ever without a job AND looking for work?**

        (1)      Yes
        (3)      No
        (r)      Refused

Q18    **What is the highest level of education that he/she has attained?**

        (1)      Masters (M.A., M.Sc.,M.Ed.) or earned doctorate (Ph.D., D.Sc., D.Ed.)
        (2)      Degree in Medicine, Dentistry, Veterinary Medicine, or Optometry (M.D., D.D.S., D.M.D.,
                 D.V.M., O.D.)
        (3)      Bachelor or undergraduate degree, or teacher's college (B.A., B.Sc., B.A.Sc., B.Ed.)
        (4)      Diploma or certificate from community college, CEGEP or nursing school
        (5)      Diploma or certificate from trade, technical or vocational school, or business college
        (6)      Some university
        (7)      Some community college, CEGEP or nursing school
        (8)      Some trade, technical or vocational school, or business college
        (9)      High School diploma
        (10)     Some High School
        (11)     Elementary School diploma
        (12)     Some Elementary
        (13)     No schooling
        (14)     Other               *[Go to Q18S]*
        (x)      Don't know
        (r)      Refused

*[Go to Q19]*

Q18S   Specify
        |__|__|__|__|__|__|__|__|__|__|__|__|__|__|
        |__|__|__|__|__|__|__|__|__|__|__|__|__|__|
        *[CATI]: Length of field = 28*

108

--- page 113 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

Q19   **In the past month, how often did your spouse/partner drink alcoholic beverages. Was it …**

      (Use of alcohol is a measure of a person's health)

                                    **INT: ===READ LIST===**

      (1)        Every day?
      (2)        4-6 times a week?
      (3)        2-3 times a week?
      (4)        Once a week?
      (5)        Once or twice in the past month?
      (6)        Never in the past month?                    *[Go to Q21A]*
      (7)        Never drinks?                               *[Go to Q21A]*
      (x)        Don't know                                  *[Go to Q21A]*
      (r)        Refused                                     *[Go to Q21A]*

Q20   **On how many occasions in the past month, has your spouse/partner had five or more drinks?**

      (Consider a drink to be one beer, one small glass of wine or 1½ oz. of liquor.)

      |__|__| *[CATI: 0-99]*
      (x)        Don't know
      (r)        Refused

Q21A  **Excluding kindergarten, how many years of elementary and high school education have you
      successfully completed?**

      (0)        No schooling                *[Go to Q24]*
      (1)        One to five years           *[Go to Q22]*
      (6)        Six years                   *[Go to Q22]*
      (7)        Seven years                 *[Go to Q22]*
      (8)        Eight years                 *[Go to Q22]*
      (9)        Nine years                  *[Go to Q22]*
      (10)       Ten years                   *[Go to Q22]*
      (11)       Eleven years
      (12)       Twelve years
      (13)       Thirteen years
      (x)        Don't know
      (r)        Refused

Q21B  **Have you graduated from high school?**

      (1)        Yes
      (3)        No
      (x)        Don't know
      (r)        Refused

109

--- page 114 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

Q22   **Have you had any further schooling beyond elementary/high school?**

        (1)     Yes
        (3)     No          *[Go to Q24]*
        (r)     Refused     *[Go to Q24]*

Q23   **What is the highest level of education that you have attained?**

        (1)     Masters (M.A., M.Sc.,M.Ed.) or earned doctorate (Ph.D., D.Sc., D.Ed.)
        (2)     Degree in Medicine, Dentistry, Veterinary Medicine, or Optometry (M.D., D.D.S., D.M.D.,
                D.V.M., O.D.)
        (3)     Bachelor or undergraduate degree, or teacher's college (B.A., B.Sc., B.A.Sc., B.Ed.)
        (4)     Diploma or certificate from community college, CEGEP or nursing school
        (5)     Diploma or certificate from trade, technical or vocational school, or business college
        (6)     Some university
        (7)     Some community college, CEGEP or nursing school
        (8)     Some trade, technical or vocational school, or business college
        (9)     Other               *[Go to Q23S]*
        (x)     Don't know
        (r)     Refused

*[Go to Q24]*

Q23S  Specify
        |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
        |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
        *[CATI]: Length of field = 28*

--- page 115 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

Q24   **What language did you first speak in childhood?**

      **INT:=== Accept multiple responses only if languages were learned at the same time.===**

                                    **INT:===Maximum 4 answers.===**

         (1)     English
         (2)     French
         (13)    Arabic
         (4)     Chinese
         (5)     German
         (11)    Greek
         (15)    Hungarian
         (3)     Italian
         (7)     Polish
         (6)     Portuguese
         (12)    Punjabi
         (9)     Spanish
         (14)    Tagalog (Philipino)
         (8)     Ukrainian
         (10)    Vietnamese
         (16)    Other               *[Go to Q24S]*
         (r)     Refused             *[Go to Q25]*
         (0)     No other; continue  *[Go to Q25]*

Q24S  Specify
      |_|_|_|_|_|_|_|_|_|_|_|_|_|_|
      |_|_|_|_|_|_|_|_|_|_|_|_|_|_|
      *[CATI]: Length of field = 28*

*CATI-Q24e:  For each answer in Q24 selected except English Go to Q24A;  Else if English select next
             answer in Q24.*

Q24A  **Do you still understand that language?**

         (1)     Yes
         (3)     No
         (r)     Refused

*CATI-Q24Ae:  If not 4th answer return to Q24.*

--- page 116 ---

GSS – Cycle 13 – Victimization                                                                                               Appendix B

Q25     **What language do you speak most often at home?**

        **INT:===Accept multiple responses only if  languages are spoken equally.===**

                                    **INT:===Maximum 4 answers.===**

        (1)     English
        (2)     French
        (12)    Arabic
        (3)     Chinese
        (13)    Cree
        (7)     German
        (10)    Greek
        (4)     Italian
        (8)     Polish
        (5)     Portuguese
        (9)     Punjabi
        (6)     Spanish
        (14)    Tagalog (Philipino)
        (15)    Ukrainian
        (11)    Vietnamese
        (16)    Other               *[Go to Q25S]*
        (r)     Refused             *[Go to Q26]*
        (0)     No other; continue  *[Go to Q26]*

Q25S  Specify
        |_|_|_|_|_|_|_|_|_|_|_|_|_|_|
        |_|_|_|_|_|_|_|_|_|_|_|_|_|_|
        *[CATI]: Length of field = 28*

--- page 117 ---

GSS – Cycle 13 – Victimization                                                                                              Appendix B

Q26    **What, if any, is your religion?**

         **INT:===If respondent answers "Protestant", determine which denomination===**

         (n)     No religion (Agnostic, Atheist)               *[Go to Q29A]*
         (4)     Anglican (Church of England, Episcopalian)
         (7)     Baptist
         (13)    Buddhist
         (9)     Eastern Orthodox
         (12)    Hindu
         (11)    Islam (Muslim)
         (15)    Jehovah's Witnesses
         (10)    Jewish
         (6)     Lutheran
         (8)     Pentecostal
         (5)     Presbyterian
         (1)     Roman Catholic
         (14)    Sikh
         (2)     Ukrainian Catholic
         (3)     United Church
         (16)    Other                          *[Go to Q26S]*
         (r)     Refused                        *[Go to Q29A]*

*[Go to Q27]*

Q26S  Specify
         |_|_|_|_|_|_|_|_|_|_|_|_|_|_|
         |_|_|_|_|_|_|_|_|_|_|_|_|_|_|
         *[CATI]: Length of field = 28*

Q27    **Other than on special occasions, (such as weddings, funerals or baptisms) how often did you attend religious services or meetings in the last 12 months? Was it ...**

                                        **INT: ===READ LIST===**

         (1)     At least once a week?
         (2)     At least once a month?
         (3)     A few times a year?
         (4)     At least once a year?
         (5)     Not at all?

         (x)     Don't know
         (r)     Refused

--- page 118 ---

GSS – Cycle 13 – Victimization                                                                    Appendix B

Q29A  **Do you have any difficulty hearing, seeing, communicating, walking, climbing stairs, bending,
         learning, or doing any similar activities?  Is it …**
         (Refers to long term health, i.e. a condition lasting or expected to last more than 6 months.)

      **INT:===If the  respondent suffers from a temporary injury, ask about his/her usual
                  condition.  If the respondent wears glasses or corrective lenses or a hearing aid,
                  which completely eliminate any seeing or hearing difficulty, no difficulty should be
                  indicated.)===**

                                          **INT: ===READ LIST===**

      (1)          Sometimes?
      (2)          Often?
      (3)          Never?

      (r)          Refused

Q29B  **Does a long term physical or mental condition or health problem reduce the amount or the kind of
         activity that you can do at home, at school, at work or in other activities?  Is it …**
         (  Refers to long term health, i.e. a condition lasting or expected to last more than 6 months.)

      **INT:===If the  respondent suffers from a temporary injury, ask about his/her usual
                  condition.)===**

                                          **INT: ===READ LIST===**

      (1)          Sometimes?
      (2)          Often?
      (3)          Never?          *[Go to Q30]*

      (r)          Refused          *[Go to Q30]*

Q29C  **What is the main condition or health problem that reduces your activities?**

      |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
      |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
      (r)     Refused
*[CATI]: Length of field = 50*

Q30    **Do you regularly have trouble going to sleep or staying asleep?**

      (1)          Yes
      (3)          No
      (r)          Refused

114

--- page 119 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

Q31    **During the past month, have you used medication or drugs, (prescription or over the
       counter) to…**

                              INT: ===READ LIST===

                                             Yes    No     Refused
       a)        Help you sleep?             (1)    (3)      (r)
       b)        Help you calm down?         (1)    (3)      (r)
       c)        Help you get out of depression?   (1)   (3)   (r)


Q31A  **Compared to other people your age, how would you describe your usual state of health?
       Would you say it is ...**
       (Refers to long term health, i.e. a condition lasting or expected to last more than 6 months.)

       **INT:===If the  respondent suffers from a temporary injury, ask about his/her usual
               condition.)===**

                              **INT: ===READ LIST===**

       (1)       Excellent?
       (2)       Very good?
       (3)       Good?
       (4)       Fair?
       (5)       Poor?

       (x)       Don't know
       (r)       Refused

Q32    **During the past 12 months, was your main activity working at a paid job or business,
       looking for paid work, going to school, caring  for children, household work, retired or
       something else?**

       (1)       Working at a paid job or business     *[Go to Q36]*
       (2)       Looking for paid work
       (3)       Going to school                       *[Go to Q33]*
       (4)       Caring for children
       (5)       Household work
       (6)       Retired
       (7)       Maternity / paternity leave
       (8)       Long term illness
       (9)       Other                                 *[Go to Q32S]*
       (r)       Refused

*[Go to Q34]*

115

--- page 120 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

Q32S  Specify
      |__|__|__|__|__|__|__|__|__|__|__|__|__|__|
      |__|__|__|__|__|__|__|__|__|__|__|__|__|__|
 [CATI]: Length of field = 28
[Go to Q34]

Q33   **Were you studying full-time or part-time?**

      (1)       Full time
      (3)       Part time
      (r)       Refused

Q34   **Did you have a job or were you self-employed at any time during the past 12 months?**

      (1)       Yes          [Go to Q36]
      (3)       No
      (r)       Refused      [Go to Q45]

Q35   **In what year did you last do any paid work?**

      |__|__|__|__|  [CATI: 1900-1998]
      (n)       Never worked at a paid job
      (r)       Refused

[Go to Q45]

Q36   **For how many weeks during the past 12 months were you employed?**
      (Include vacation, illness, strikes, lock-outs and maternity/paternity leave.)

      |__|__|  [CATI: 1-52]
      (r)       Refused

Q37   **How many hours a week did you usually work at all jobs**?

                    INT:===Round to the nearest whole hour===

      |__|__|__|  [CATI: 1-168]
      (r)       Refused

Q38   **Some people do all or some of their paid work at home.  Excluding overtime, do you usually work any of your scheduled hours at home?**

      **INT:===Exclude respondents who occasionally perform some overtime work in their homes.===**

      (1)       Yes
      (3)       No           [Go to Q40]
      (r)       Refused      [Go to Q40]

116

--- page 121 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

Q39   **How many paid hours per week do you usually work at home ?**

         **INT:=== Round to the nearest whole hour===**

         |__|__|__| *[CATI: 1-168]*
         (r)       Refused
Q40   **For whom did you work the longest time during the past 12 months?**
         (Name of business, government department or agency, or person)

         |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
         |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
         (r)       Refused
*[CATI]: Length of field = 50*

Q41   **What kind of business, industry or service was this?**
         (Give full description: e.g. federal government, canning industry, forestry services)

         |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
         |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
         (r)       Refused
*[CATI]: Length of field = 50*

Q42   **What kind of work were you doing?**
         (Give full description: e.g. office clerk, factory worker, forestry technician)

         |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
         |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
         (r)       Refused
*[CATI]: Length of field = 50*

Q43   **In that work, what were your most important activities or duties?**
         (Give full description: e.g. filing documents, drying vegetables, forestry examiner)

         |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
         |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
         (r)       Refused
*[CATI]: Length of field = 50*

117

--- page 122 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

Q44   **Which of the following best describes the hours you usually work at this job?**
         (For respondent's main job:  "On call" means no prearranged schedules, but called as need
         arises (for example, a substitute teacher). "Irregular schedule" is usually prearranged one week
         or more in advance (for example, pilots).

                                          **INT:===READ LIST===**

         (1)       A regular daytime schedule or shift
         (2)       A regular evening shift
         (3)       A regular night shift
         (4)       A rotating shift (one that changes periodically
                    from days to evenings or to nights)
         (5)       A split shift (one consisting of two or more
                   distinct periods each day)
         (6)       On call or casual
         (7)       An irregular schedule
         (8)       Other                    *[Go to Q44S]*

         (x)       Don't know
         (r)       Refused

*[Go to Q45]*

Q44S   Specify
         |__|__|__|__|__|__|__|__|__|__|__|__|__|__|
         |__|__|__|__|__|__|__|__|__|__|__|__|__|__|
*[CATI]: Length of field = 28*

--- page 123 ---

GSS – Cycle 13 – Victimization                                                                                          Appendix B

Q45   **Various measures of income are needed to study the relationship between an individual's overall economic situation and their safety. What was your main source of income during the past 12 months?**

                                          **INT:===Mark one only.===**

      (0)     No income          *[Go to CATI-Q46e]*
      (1)     Employment or self-employment (wages, salaries, commissions and tips)
      (2)     Employment insurance
      (3)     Worker's compensation
      (4)     Benefits from Canada or Quebec Pension Plan
      (5)     Retirement pensions, superannuation and annuities
      (6)     Basic Old Age Security
      (7)     Guaranteed Income Supplement or Spouse's Allowance
      (8)     Child Tax Benefit
      (9)     Provincial or municipal social assistance or welfare
      (10)    Child Support/Alimony
      (11)    Other Income (eg. Rental income, scholarships, other government income, dividends and interest
              on bonds, deposits and savings, stocks, mutual funds, etc.)
      (x)     Don't know
      (r)     Refused

Q46   **What is your best estimate of your total personal income, before deductions, FROM  ALL SOURCES during the past 12 months?**

      $ |__|__|__|__|__|
      (n)     No income or loss
      (x)     Don't know
      (r)     Refused

*CATI-Q46e:  Review household roster – if this is a "one person" household Go to  Q49.*

Q47   **Not including yourself, how many other household members received income from any source, during the past 12 months?**

      |__|  *[CATI 1-OTHM]  (OTHM = Number of household members minus 1)*
      (0)     No one else
      (r)     Refused

*CATI-Q47e:   If Q47 =  (0) or (r)  then [Go to  Q49];*
                    *Else If Q47 > 0 and (Q45 = (0) or Q46 = (n) or Q46 = (r) or Q46 = (x))*
                                    *then [Go to  Q48A];*
                    *Else If Q47 > 0 and (Q46 > 0 and Q46 < 20000) then [Go to  Q48A];*
                    *Else If Q47 > 0 and (Q46 > 19999 and Q46 < 40000) then [Go to  Q48E];*
                    *Else If Q47 > 0 and (Q46 > 39999 and Q46 < 60000) then [Go to  Q48H];*
                    *Else If Q47 > 0 and (Q46 > 59999 and Q46 < 80000) then [Go to  Q48J];*
                    *Else then [Go to Q48K].*

119

--- page 124 ---

GSS – Cycle 13 – Victimization                                                                                              Appendix B

Q48A  **What is your best estimate of the total income, before deductions, of all household members from all sources during the past 12 months? Was the total household income...**

                                          INT: ===READ LIST===

          (1)          Less than $20,000?     *[Go to Q48B]*
          (2)          $20,000 and more?      *[Go to Q48E]*

          (0)          No income or loss
          (x)          Don't know
          (r)          Refused

*[Go to Q49]*

Q48B  **What is your best estimate of the total income, before deductions, of all household members from all sources during the past 12 months? Was the total household income...**

                                          INT: ===READ LIST===

          (1)          Less than $10,000?     *[Go to Q48C]*
          (2)          $10,000 and more?      *[Go to Q48D]*

          (x)          Don't know
          (r)          Refused
*[Go to Q49]*

Q48C  **What is your best estimate of the total income, before deductions, of all household members from all sources during the past 12 months? Was the total household income...**

                                          INT: ===READ LIST===

          (1)          Less than $5,000?
          (2)          $5,000 and more?

          (x)          Don't know
          (r)          Refused

*[Go to Q49]*

--- page 125 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

Q48D  What is your best estimate of the total income, before deductions, of all household members from
      all sources during the past 12 months? Was the total household income...

                                    INT: ===READ LIST===

         (1)        Less than $15,000?
         (2)        $15,000 and more?

         (x)        Don't know
         (r)        Refused

[Go to Q49]

Q48E  What is your best estimate of the total income, before deductions, of all household members from
      all sources during the past 12 months? Was the total household income...

                                    INT: ===READ LIST===

         (1)        Less than $40,000?   [Go toQ48F]
         (2)        $40,000 and more?    [Go to Q48G]

         (x)        Don't know
         (r)        Refused

[Go to Q49]

Q48F  What is your best estimate of the total income, before deductions, of all household members from
      all sources during the past 12 months? Was the total household income...

                                    INT: ===READ LIST===

         (1)        Less than $30,000?
         (2)        $30,000 and more?

         (x)        Don't know
         (r)        Refused

[Go to Q49]

--- page 126 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

Q48G. **What is your best estimate of the total income, before deductions, of all household members from all sources during the past 12 months? Was the total household income...**

**INT: ===READ LIST===**

        (1)        Less than $50,000?
        (2)        $50,000 and more?    *[Go to Q48H]*

        (x)        Don't know
        (r)        Refused

*[Go to Q49]*

Q48H  **What is your best estimate of the total income, before deductions, of all household members from all sources during the past 12 months? Was the total household income...**

**INT: ===READ LIST===**

        (1)        Less than $60,000?
        (2)        $60,000 and more?    *[Go to Q48J]*

        (x)        Don't know
        (r)        Refused

*[Go to Q49]*

Q48J  **What is your best estimate of the total income, before deductions, of all household members from all sources during the past 12 months? Was the total household income...**

**INT: ===READ LIST===**

        (1)        Less than $80,000?
        (2)        $80,000 and more?    *[Go to Q48K]*

        (x)        Don't know
        (r)        Refused

*[Go to Q49*]

--- page 127 ---

GSS – Cycle 13 – Victimization                                                                                              Appendix B

Q48K  **What is your best estimate of the total income, before deductions, of all household members from all sources during the past 12 months? Was the total household income...**

                                        INT: ===READ LIST===

        (1)        Less than $100,000?
        (2)        $100,000 and more?

        (x)        Don't know
        (r)        Refused

Q49.   **I'd like to thank you very much for helping us out by completing this survey. It is only by hearing from Canadians themselves that we can better understand the extent of victimization in Canada. On behalf of Statistics Canada I would like to thank you for your cooperation and wish you a good day.**

*END   Date / Time Stamp*

123

--- page 128 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

124

--- page 129 ---

Appendix

Section V: Crime Incident Report

--- page 130 ---

<blank page>

--- page 131 ---

GSS – Cycle 13 – Victimization                                                                    Appendix B

SECTION V: CRIME INCIDENT REPORT

V0     *Date/Time stamp*

V1     **You said that during the past 12 months** . . . *[Filler1 to Filler13 - refers to appropriate screen question for description of incident].* **In what month did (this/the most recent/the next most recent) incident happen?**

       (n)    Not in the past 12 months     *[Go to V67]*
       (1)    January
       (2)    February
       (3)    March
       (4)    April
       (5)    May
       (6)    June
       (7)    July
       (8)    August
       (9)    September
       (10)   October
       (11)   November
       (12)   December
       (x)    Don't know                    *[Go to V1A]*
       (r)    Refused                       *[Go to V1A]*

*[Go to V2]*

V1A    **Did this happen in the past 12 months?**

       (1)    Yes (will continue with incident report)
       (3)    No                                              *[Go to V67]*
       (5)    Yes, but refuses to talk about incident *[Go to V67]*
       (x)    Don't know                                     *[Go to V67]*
       (r)    Refused                                        *[Go to V67]*

1

--- page 132 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B


V2     **Where did this incident take place?  For example, was it at home, on the street, at work or at school?**

                    **INT : ===If work, ask: Where was your place of work at the time?
                         For example, was it an office building, factory or school? ===**

       **Respondent's home and surrounding area:**
              (1)          Inside respondent's own home/apartment                    *[Go to V3]*
              (2)          Inside a vacation property (includes
                           surrounding areas)                                        *[Go to V5]*
              (3)          Inside garage or other building on
                           respondent's  property                                    *[Go to V5]*
              (4)          Outside respondent's home, apartment,
                           including yard, farm field, driveway, parking
                           lot or in shared areas related to home such
                           as apartment hallway or laundry room
       **Other private residences or farms:**
              (5)          Offender's home (in or around)
              (6)          Other Private Residence or Farm (in or around)
       **Commercial or Institutional:**
              (7)          In a restaurant or bar
              (8)          Inside school or on school grounds
              (9)          In a commercial or office building, a factory,
                            a store, or a shopping mall
              (10)         In a hospital, prison or rehabilitation centre
       **Street/Other Public Place:**
              (11)         On public transportation
              (12)         In a parking garage or parking lot other than
                           the respondent's
              (13)         On sidewalk/street/highway in respondent's
                           neighbourhood
              (14)         On any other sidewalk/street/highway
              (15)         In a rural area or park (include national, provincial
                           or local  park, or conservation area)
              (16)         Other                                                     *[Go to V2S]*
              (r)          Refused

*[Go to CATI-V8e]*

V2S    Specify
       |__|__|__|__|__|__|__|__|__|__|__|__|__|__|
       |__|__|__|__|__|__|__|__|__|__|__|__|__|__|
       *[CATI]:  Length of field = 28*

*[Go to CATI-V8e]*

2

--- page 133 ---

GSS – Cycle 13 – Victimization                                                                                               Appendix B

V3     **Was that the same dwelling that you are living in now?**

         (1)          Yes               *[Go to V5]*
         (3)          No
         (r)          Refused

V4     **What type of dwelling were you living in at the time of this incident?  Was it a . . .**

                                              INT: ===READ LIST===

         (1)          Single detached house?
         (2)          Semi-detached or double (side-by-side)?
         (3)          Garden house, town-house or row house?
         (4)          Duplex (one above the other)?
         (5)          Low-rise apartment (less than 5 stories)?
         (6)          High-rise apartment (5 or more stories)?
         (7)          Mobile home or trailer?

         (8)          Other?               *[Go to V4S]*
         (r)          Refused

*[Go to V5]*

V4S    Specify
         |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
         |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
*[CATI]:  Length of field = 28*

V5     **At the time of the incident, did the person(s) who committed the act live with you?**

         INT:===If more than one person and at least one lived with respondent select yes (1)===

         (1)          Yes          *[Go to CATI-V8e]*
         (3)          No
         (x)          Don't know   *[Go to CATI-V8e]*
         (r)          Refused      *[Go to CATI-V8e]*

V6     **Did someone let them in?**  (Example: guests, workmen)

         INT:=== If respondent advises you that the incident was a threat by telephone or
                      mail, select "No" at this item and option 5 at item V7.===

         (1)          Yes          *[Go to CATI-V8e]*
         (3)          No
         (x)          Don't know   *[Go to CATI-V8e]*
         (r)          Refused      *[Go to CATI-V8e]*

3

--- page 134 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

V7     **Did the person(s) who committed the act actually get in or just try to get in?**

       **INT:===For apartments and multi-unit structures, determine if there was an actual or attempted
       entry of the respondent's unit.  Do not include entry to other parts of the building, such as the
       lobby.===**

       (1)          Actually got in
       (3)          Tried to get in
       (5)          Threat received by telephone, mail, or e-mail          *[Go to V13]*
       (x)          Don't know
       (r)          Refused

V8     **Was there any evidence, such as a broken lock or window, that the person(s) forced/tried to force
       his/her way in?**

       (1)          Yes
       (3)          No             *[Go to CATI-V8e]*
       (x)          Don't know     *[Go to CATI-V8e]*
       (r)          Refused        *[Go to CATI-V8e]*

V8A    **What was the evidence?**

                                   **INT:===Mark all that apply.===**

       (1)          Broken lock or forced door
       (2)          Broken or forced window
       (3)          Other               *[Go to V8S]*
       (r)          Refused             *[Go to CATI-V8e]*
       (0)          No other; continue  *[Go to CATI-V8e]*

V8S    Specify
       |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
       |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
*[CATI]: Length of field = 50*

*CATI-V8e: If crime incident type refers to physical attack, sexual assault, or unwanted sexual touching, then go
       to V10, i.e.: If VSCRNO refers to 'B8A' or 'B9' or 'B10' or 'B11A' or 'B12' or 'B13'  Go to V10.*

V9     **Were you present at any time during the incident?**

       (1)          Yes          *[Go to V10]*
       (3)          No
       (r)          Refused      *[Go to V10]*

*CATI-V9e: If crime incident type refers to threats, then go to V13; else go to V12, i.e.: If VSCRNO refers to
       'B8B' or 'B11B'  Go to V13; else Go to V12.*

4

--- page 135 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

V10   **Did the person(s) who committed the act have a weapon, such as a gun or knife or something he/she was using as a weapon, such as a rock or bottle?**

        (1)     Yes
        (3)     No           *[Go to CATI-V10e]*
        (x)     Don't know   *[Go to CATI-V10e]*
        (r)     Refused      *[Go to CATI-V10e]*

V10A  **What type of weapon?**

                                    INT:===Mark all that apply.===

        (1)     Gun
        (2)     Knife
        (3)     Other              *[Go to V10S]*
        (x)     Don't know         *[Go to CATI-V10e]*
        (r)     Refused            *[Go to CATI-V10e]*
        (0)     No other; continue *[Go to CATI-V10e]*

V10S  Specify
       |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
       |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
 *[CATI]:  Length of field = 28*

*CATI-V10e:   If crime incident type refers to physical attack, then go to V15.  If crime incident type refers to sexual assault or unwanted sexual touching, then go to V16, i.e.: If VSCRNO refers to 'B8A' or 'B11A'  Go to V15; If VSCRNO refers to 'B9' or 'B10' or 'B12' or 'B13'   Go to V16.*

V11   **An assault can be anything from being hit, slapped, grabbed or knocked down, to being shot, or beaten.  This can also include forced sexual activity and unwanted sexual touching or grabbing.  In this incident, were you assaulted in any physical or sexual way?**

        **(INT : === Consider respondents as having been assaulted if something was thrown at them or if they were shot at but not hit. ===**

        (1)     Yes          *[Go to V15]*
        (3)     No
        (r)     Refused

V12   **Did the person(s) threaten you with physical harm in any way?**

        (1)     Yes          *[Go to V13]*
        (3)     No
        (r)     Refused

*CATI-V12e:  If V9 = 3 Go to V31; else Go to V19.*

5

--- page 136 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

V13   **How were you threatened?  Was it …**

                        **INT:=== READ LIST - Mark all that apply. ===**

         (1)      Face-to-face?
         (2)      By mail?
         (3)      By electronic mail?
         (4)      Over the telephone?

         (5)      Other               *[Go to V13S]*
         (r)      Refused             *[Go to V14]*
         (0)      No other; continue  *[Go to V14]*

V13S  Specify
 |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
 |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
 *[CATI]:  Length of field = 28*

V14   **Did you think the threat was going to be carried out?**

         (1)      Yes
         (3)      No
         (r)      Refused

*[Go to V19]*

V15   **How were you assaulted?  Again, remember that an assault can include any type of physical or sexual assault, such as being slapped, beaten or being forced into sexual activity or being touched or grabbed in a sexual way.**

                        **INT:=== Mark all that apply. - Probe for multiple answers.===**

         (n)      Not attacked/assaulted                          *[Go to CATI-V15e]*
         (1)      Forced or attempted forced sexual assault by being
                  threatened, held down or hurt in some way
         (2)      Unwanted sexual touching, grabbing, kissing or fondling
         (3)      Shot, knifed or hit with object held in hand
         (4)      Hit, kicked, slapped, knocked down
         (5)      Grabbed, held, tripped, jumped, pushed
         (6)      Other                                           *[Go to V15S]*
         (r)      Refused                                         *[Go to CATI-V16e]*
         (0)      No other; continue                              *[Go to CATI-V16e]*

V15S  Specify
 |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
 |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
 *[CATI]:  Length of field = 50*

6

--- page 137 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

*CATI-V15e:  Hard edit:  If V11 = (1) and V15 = (n) then interviewer ask:*
      **Earlier in the interview you said that you were attacked but you have not identified how you were attacked.  For which question should I correct your answer?**

   *(1)        Correct V11*
   *(3)        Correct V15*

   *Soft edit: If (V11 = < > or V11 = 'Off path') and V15 = (n) then interviewer ask:*
   **Earlier in the interview you said that you were attacked but you have not identified how you were attacked.  Could you please confirm this for me?**

   *(1)        Correct V15*
   *(3)        Accept             [Go to V12]*

*CATI-V16e:  If any of V15 = (3) then Go to V17.*

V16   **Were you physically injured in any way?**

      (1)        Yes
      (3)        No              *[Go to V19]*
      (r)        Refused         *[Go to V19]*

V17   **Did you receive any medical attention at a hospital as a result of this incident?**

      (Include treatment received at emergency or as an out-patient.)

      (1)        Yes
      (3)        No              *[Go to V18]*
      (r)        Refused         *[Go to V18]*

V17A  **Did you stay in hospital overnight?**

      (1)        Yes
      (3)        No              *[Go to V19]*
      (r)        Refused         *[Go to V19]*

V17B  **For how many nights?**

      |__|__|__|*[CATI: 1-500]*
      (r)        Refused

*[Go to V19]*

7

--- page 138 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

V18    **Did you receive any medical attention from a doctor or a nurse?**

         (Include medical attention received immediately after the attack as well as any follow-up medical
         attention received as a result of the injuries.)

         (1)       Yes
         (3)       No
         (x)       Don't know
         (r)       Refused

V19    **As a result of this incident (and excluding any time you spent in the hospital), did you have to stay in
         bed for all or most of a day?**

         (Include time spent in bed for injuries as well as for stress reasons. Six hours in bed equals one day.)

         (1)       Yes
         (3)       No             *[Go to V20A]*
         (r)       Refused        *[Go to V20A]*

V19A  **For how many days?**

                   **INT : === Consider one day to be 6 hours over and above the respondent's normal
                                        hours of sleeping ===**

         |__|__|__| *[CATI: 1-100]*
         (r)       Refused

V20A  **In your opinion, was this incident related to the  person's alcohol or drug use?**

         (1)       Yes
         (3)       No
         (x)       Don't know
         (r)       Refused

*CATI-V20Ae: If no incidence of violence, i.e.:  If (VSCRNO = B1, B3, B4A, B4B, B4C, B6A, B6B or B7) or
                   (VSCRNO = B8A or VSCRNO = B11A) and (V15 = n)] and [V12 = "on-path" and (V12 = (3) or
                   V12 = (r) or (V12 = (1) and (V13 NE (1) or V14 NE (1))))]
                   then go to V21.*

V20B  **(In your opinion, was this incident related to) your own alcohol or drug use?**

         (1)       Yes
         (3)       No
         (x)       Don't know
         (r)       Refused

8

--- page 139 ---

GSS – Cycle 13 – Victimization                                                                                              Appendix B

V21    **Was only one person involved in committing the act?**

               INT:=== Select (x) "don't know" if the respondent is unsure or guesses about the
                                          number of offenders.===

         (1)     Yes
         (3)     No           *[Go to V25]*
         (x)     Don't know   *[Go to V31]*
         (r)     Refused      *[Go to V31]*

V22    **Was the person male or female?**

         (1)     Male
         (2)     Female
         (x)     Don't know
         (r)     Refused

V23    **How old would you say the person was?**

         |__|__| *[CATI: 1-95]*
         (x)     Don't know
         (r)     Refused

V24    **What was the person's relationship to you?**

               INT:===Record relationship at time of incident (not necessarily current relationship).===

         (1)     Mother               (14)    Ex-spouse/ex-partner
         (2)     Father               (15)    Other family member
         (3)     Mother-in-law        (16)    Boyfriend/girlfriend
         (4)     Father-in-law        (17)    Ex-boyfriend/ex-girlfriend
         (5)     Step-mother          (18)    Neighbour
         (6)     Step-father          (19)    Friend/Casual acquaintance
         (7)     Son                  (20)    Co-worker
         (8)     Daughter             (21)    Known by sight only
         (9)     Son-in-law           (22)    Stranger
         (10)    Daughter-in-law      (23)    Other          *[Go to V24S]*
         (11)    Brother
         (12)    Sister               (r)     Refused
         (13)    Spouse/partner

*[Go to V31]*

9

--- page 140 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

V24S   Specify
        |__|__|__|__|__|__|__|__|__|__|__|__|__|__|
        |__|__|__|__|__|__|__|__|__|__|__|__|__|__|
 [CATI]:  Length of field = 28

[Go to V31]

V25    **How many people were involved?**

        |__|__|  [CATI: 1-95]
        (x)      Don't know
        (r)      Refused

V26    **Were they male or female?**

        (1)      All male                [Go to V28]
        (2)      All female              [Go to V28]
        (3)      Both male and female
        (x)      Don't know             [Go to V28]
        (r)      Refused                [Go to V28]

CATI-V26e:  If V25 = 2, Go to V28.

V27    **Were they mostly male or mostly female?**

        (1)      Mostly male
        (2)      Mostly female
        (3)      Evenly divided
        (x)      Don't know
        (r)      Refused

V28    **How old would you say the youngest was?**

        |__|__|  [CATI: 1-95]
        (x)      Don't know
        (r)      Refused

V29    **How old would you say the oldest was?**

        |__|__|  [CATI: 1-95]
        (x)      Don't know
        (r)      Refused

--- page 141 ---

GSS – Cycle 13 – Victimization                                                                                              Appendix B

V30    **What was their relationship to you?**

                                        **INT:===Mark all that apply.===**

          (1)       Mother                        (14)    Ex-spouse/ex-partner
          (2)       Father                        (15)    Other family member
          (3)       Mother-in-law                 (16)    Boyfriend/girlfriend
          (4)       Father-in-law                 (17)    Ex-boyfriend/ex-girlfriend
          (5)       Step-mother                   (18)    Neighbour
          (6)       Step-father                   (19)    Friend/Casual acquaintance
          (7)       Son                           (20)    Co-worker
          (8)       Daughter                      (21)    Known by sight only
          (9)       Son-in-law                    (22)    Stranger
          (10)      Daughter-in-law               (23)    Other                  *[Go to V30S]*
          (11)      Brother                       (r)     Refused                *[Go to V31]*
          (12)      Sister                        (0)     No other; continue     *[Go to V31]*
          (13)      Spouse/partner

V30S   Specify
        |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
        |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
        *[CATI]:  Length of field = 28*

*CATI-V31e:  If this is the first time the following question is asked read the complete question;  else read
                last sentence only.*

V31    (**There is a growing concern in Canada about hate crimes.  By this I mean crimes motivated by the
       offender's hatred of a person's sex, ethnicity, race, religion, sexual orientation, age, disability,
       culture or language.**)
       **Do you believe that this incident committed against you could be considered a hate crime?**

          (1)       Yes
          (3)       No          *[Go to V33]*
          (x)       Don't know  *[Go to V33]*
          (r)       Refused     *[Go to V33]*

11

--- page 142 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

V32    **Was this because of the person's hatred of your…**

                              INT:=== READ LIST===Mark all that apply.===

         (1)       Sex?
         (2)       Race/Ethnicity?
         (3)       Religion?
         (4)       Sexual Orientation?
         (5)       Age?
         (6)       Disability?
         (7)       Culture?
         (8)       Language?
         (9)       Other                    *[Go to V32S]*
         (x)       Don't know               *[Go to V33]*
         (r)       Refused                  *[Go to V33]*
         (0)       No other; continue       *[Go to V33]*

V32S  Specify
         |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
         |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
*[CATI]: Length of field = 50*

V33    **Was anyone (else) harmed or threatened during this incident?**

         (1)       Yes
         (3)       No            *[Go to CATI-V34e]*
         (x)       Don't know    *[Go to CATI-V34e]*
         (r)       Refused       *[Go to CATI-V34e]*

V33A  **How many people?**

         |__|__|   *[CATI 1-95]*
         (x)       Don't know
         (r)       Refused

V34    **Were any of these people under 15 years of age?**

         (1)       Yes
         (3)       No            *[Go to CATI-V34e]*
         (x)       Don't know    *[Go to CATI-V34e]*
         (r)       Refused       *[Go to CATI-V34e]*

12

--- page 143 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

V34A  **How many people?**

         |__|__| *[CATI 1-95]*
         (x)      Don't know
         (r)      Refused

*CATI-V34e: : If crime incident type refers to theft of property belonging to the respondent or to the respondent's household, then go to V36, i.e.: If VSCRNO refers to 'B4A' or 'B4B' or 'B4C'  Go to V36.*

V35    **Was anything that belonged to you or your household stolen during this incident?  Do not include property belonging to a business.**

         (1)      Yes
         (3)      No           *[Go to CATI-V38e]*
         (x)      Don't know   *[Go to CATI-V38e]*
         (r)      Refused      *[Go to CATI-V38e]*

V36    **What was stolen during the incident?  Anything else?**

                              **INT:===Mark all that apply.===**

              (n)      Nothing        *[Go to CATI-V36e]*
              (1)      Cash
         Personal Property:
                   (2)       Purse, wallet, credit cards, cheques, personal cards or papers
                   (3)       Clothing, jewellery
                   (4)       Other personal property

                   (5)       Personal property of someone else
         Motor vehicle:
                   (6)       Car
                   (7)       Truck or van
                   (8)       Motorcycle or moped
                   (9)       Other motor vehicle
                   (10)      Part of a motor vehicle
         Household property:
                   (11)      Food, drink, liquor
                   (12)      Electronic equipment, including T.V. stereo, video recorder, CD's
                   (13)      Household articles, including tools, appliances, furniture, carpets
                   (14)      Boat
                   (15)      Bicycle
                   (16)      Other household property

         (x)      Don't know          *[Go to CATI-V38e]*
         (r)      Refused             *[Go to CATI-V38e]*
         (0)      No other; continue  *[Go to V37]*

13

--- page 144 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

*CATI-V36e:  Hard edit:  If V35 = (1) and V36 = (n) then interviewer ask:*

**You said in the previous question that something was taken from you or your household but you have not identified what was taken.  For which question should I correct your answer?**

   *(1)        Correct V35*
   *(3)        Correct V36*

   *Soft edit:  If (V35 = ( ) or V35 = 'Off path') and V36 = (n) then interviewer ask:*
   **Earlier in the interview you said that something was stolen from you or your household but you have not identified what was taken.  Could you please clarify this for me?**

   *(1)        Correct V36*
   *(3)        Accept             [Go to V39]*

V37   **What is your estimate of the value of all property and cash stolen in this incident?**

      $|__|__|__|__|__|.00
      (0)     No value
      (x)     Don't know
      (r)     Refused

V38   **Was any of the stolen money and/or property recovered, not counting anything received from insurance?**

      (1)     Yes
      (3)     No             *[Go to CATI-V41e]*
      (x)     Don't know    *[Go to CATI-V41e]*
      (r)     Refused        *[Go to CATI-V41e]*

V38A  **Was it all recovered?**

      (1)     Yes
      (3)     No
      (x)     Don't know
      (r)     Refused

*[Go to CATI-V41e]*

*CATI-V38e: If crime incident type refers to attempted thefts of respondent's property, including attempted theft of a motor vehicle or part of a motor vehicle or anything else belonging to the respondent, then go to V40, i.e.:  If VSCRNO refers to 'B6A' or 'B7'  Go to V40.*

14

--- page 145 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

V39   **Did this person ATTEMPT to take anything that belonged to you or your household?  Do not include property belonging to a business.**

   (1)     Yes
   (3)     No          *[Go to CATI-V41e]*
   (x)     Don't know  *[Go to CATI-V41e]*
   (r)     Refused     *[Go to CATI-V41e]*

V40   **What did they attempt to steal during this incident?**

                              INT:===Mark all that apply.===

   (n)     Nothing          *[Go to CATI-V40e]*
   (1)     Cash
   (2)     Respondent's personal property
   (3)     Personal property of someone else
   (4)     Motor vehicle
   (5)     Part of a  motor vehicle
   (6)     Household property
   (x)     Don't know       *[Go to CATI-V41e]*
   (r)     Refused          *[Go to CATI-V41e]*
   (0)     No other; continue   *[Go to CATI-V41e]*

*CATI-V40e:   Hard edit:  If V39 = (1) and V40 = (n) then interviewer ask:*

   **You said in the previous question that there was an attempt to take something that belonged to you or your household but you have not identified what they attempted to steal.  For which question should I correct your answer?**

   *(1)     Correct V39*
   *(3)     Correct V40*

*Soft edit:  If (V39≠( ) or V39 = 'Off path') and V40 = (n) then interviewer ask:*
   **Earlier in the interview you said that someone attempted to take something from you or your household but you have not identified what the person attempted to take.  Could you please clarify this for me?**

   *(1)     Correct V40*
   *(3)     Accept*

*CATI-V41e:   If crime incident type refers to vandalism of the respondent's property, including deliberate damage to a motor vehicle or anything else belonging to the respondent, then go to V42, i.e.: If VSCRNO  refers to 'B1' or 'B6B'  Go to V42.*

15

--- page 146 ---

GSS – Cycle 13 – Victimization                                                                                          Appendix B

V41   **Was anything that belonged to you or a member of your household damaged but not taken in this incident?**
      (Include damage resulting from vandalism.)

      (1)     Yes
      (3)     No          *[Go to CATI-V45e]*
      (x)     Don't know  *[Go to CATI-V45e]*
      (r)     Refused     *[Go to CATI-V45e]*

V42   **What was damaged?**

                                    INT:===Mark all that apply.===

      (n)     Nothing             *[Go to CATI-V42e]*
      (1)     Respondent's personal property
      (2)     Personal property of someone else
      (3)     Motor vehicle or part of a motor vehicle
      (4)     Dwelling or other building  on property
      (5)     Household property
      (x)     Don't know          *[Go to CATI-V45e]*
      (r)     Refused             *[Go to CATI-V45e]*
      (0)     No other; continue  *[Go to V43]*

*CATI-V42e:  Hard edit:  If V41 = (1) and V42 = (n) then interviewer ask:*

      **You said in the previous question that something belonging to you or to someone in your household was damaged, but you have not identified what was damaged.  For which question should I correct your answer?**

      *(1)    Correct V41*
      *(3)    Correct V42*

*Soft edit:  (If V41≠( ) or V41 = 'Off path') and V42 = (n) then interviewer ask:* **Earlier in the interview you said that something belonging to you or to someone in your household was damaged, but you have not identified what was damaged.  Could you please clarify this for me?**

      *(1)    Correct V42*
      *(3)    Accept          [Go to CATI-V45e]*

V43   **What is your estimate of the value of all damage done in this incident?**

      $|__|__|__|__|__|__|.00
      (0)     No value
      (x)     Don't know
      (r)     Refused

--- page 147 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

V44    **Have any of the damaged items been repaired or replaced?**

         (1)       Yes               *[Go to CATI-V45e]*
         (3)       No
         (x)       Don't know
         (r)       Refused

V45    **Will they be repaired or replaced?**

         (1)       Yes
         (3)       No
         (x)       Don't know
         (r)       Refused
*CATI-V45e:  If crime incident type does not include any theft or damage of property, then go to V48,
                  i.e.: If (V36 = ( ) or V36 = (n) or V36 = "Off path" ) and (V42 =(() or V42 = (n)
                  or V42 = "Off path") Go to V48.*

V46    **At the time of the incident, did you have any insurance?**

         (1)       Yes
         (3)       No               *[Go to V48]*
         (x)       Don't know    *[Go to V48]*
         (r)       Refused         *[Go to V48]*

V47    **Did you attempt to obtain compensation for this incident through an insurance company?**

         (1)       Yes
         (3)       No               *[Go to V48]*
         (x)       Don't know    *[Go to V48]*
         (r)       Refused         *[Go to V48]*

V47A  **Did you obtain any compensation?**

         (1)       Yes
         (3)       No
         (5)       Not yet resolved
         (x)       Don't know
         (r)       Refused

V48    **Did you attempt to obtain compensation for this incident through a civil or criminal court or a provincial compensation program?**

         (1)       Yes
         (3)       No               *[Go to V49]*
         (x)       Don't know    *[Go to V49]*
         (r)       Refused         *[Go to V49]*

17

--- page 148 ---

GSS – Cycle 13 – Victimization                                                                                               Appendix B

V48A  **Did you obtain any compensation?**

         (1)       Yes
         (3)       No
         (5)       Not yet resolved
         (x)       Don't know
         (r)       Refused

V49    **For this incident, what is your estimate of your out-of-pocket expenses, that is, expenses for which you do not expect to be reimbursed?**

         $|__|__|__|__|__|__|.00
         (0)       No expenses
         (x)       Don't know
         (r)       Refused

V50    **Which of the following best describes your main activity during the week of the incident? Were you . . .**
         **INT:=== Accept one response only.  If respondent indicates more than one activity then probe for main activity.  If respondent insists on more than one then select (10) (Other) and specify.===**

                                           **INT:===READ LIST===**

         (1)       On holiday?
         (2)       Working at a paid job or business?
         (3)       Looking for work?
         (4)       A student?
         (5)       Caring for children?
         (6)       Household work?
         (7)       Retired?                    *[Go to V52]*

         (8)       Maternity/paternity leave   *[Go to V52]*
         (9)       Long term illness           *[Go to V52]*
         (10)      Other                       *[Go to V50S]*
         (r)       Refused

*[Go to V51]*

V50S   Specify
         |__|__|__|__|__|__|__|__|__|__|__|__|__|__|
         |__|__|__|__|__|__|__|__|__|__|__|__|__|__|
         *[CATI]:  Length of field = 28*

--- page 149 ---

GSS – Cycle 13 – Victimization                                                                                          Appendix B

V51   **As a result of this incident, did you find it difficult or impossible to carry out your main activity for all or most of a day?**  ( Reasons could range from requiring medical treatment to having to replace or repair property or visit insurance agents.
      **INT:===Select (1) (yes) if the respondent's main activity was disrupted for at least 6 hours during a day.===**

   (1)     Yes
   (3)     No            *[Go to V52]*
   (x)     Don't know    *[Go to V52]*
   (r)     Refused       *[Go to V52]*

V51A  **For how many days?**

   |__|__|__|*[CATI: 1-999]*
   (r)     Refused

V52   **Did the police find out about this incident in any way?**

      **INT:=== If the respondent or a member of the household is a police officer, select (1) (yes) only if it was reported to the police.===**

   (1)     Yes
   (3)     No            *[Go to V58A]*
   (x)     Don't know    *[Go to V60]*
   (r)     Refused       *[Go to V60]*

V53   **How did they learn about it?  Was it from you or some other way?**

      **INT:=== If respondent answers both himself/herself and some other way - enter (1).===**

   (1)     Respondent
   (3)     Some other way          *[Go to V55]*
   (x)     Don't know              *[Go to V60]*
   (r)     Refused                 *[Go to V60]*

--- page 150 ---

GSS – Cycle 13 – Victimization                                                                                              Appendix B

V54   **People have different reasons for reporting incidents to the police.  Did any of the following have anything to do with why you reported this incident?  Was it …**

                                    INT: ===READ LIST===

                                              Yes    No    Don't know    Refused

         a)       To stop the incident or receive
                    protection?                        (1)    (3)       (x)           (r)
         b)       To catch and punish the
                    offender?                          (1)    (3)       (x)           (r)
         c)       To file a report to claim
                    compensation or insurance?         (1)    (3)       (x)           (r)
         d)       Because you felt it was your duty
                    to notify police?                  (1)    (3)       (x)           (r)
         e)       On the  recommendation of
                    someone else?                      (1)    (3)       (x)           (r)

V55   **What action did the police take?**

                                    INT:===Mark all that apply.===

         (n)      None                    *[Go to V56]*
         (1)      Visited Scene
         (2)      Made a report/Conducted an investigation
         (3)      Gave warning to offender
         (4)      Took offender away
         (5)      Made Arrests/Laid Charges
         (6)      Put you in touch with community services
         (7)      Other                   *[Go to V55S]*
         (x)      Don't know              *[Go to V56]*
         (r)      Refused                 *[Go to V56]*
         (0)      No other; continue      *[Go to V56]*

V55S  Specify
      |__|__|__|__|__|__|__|__|__|__|__|__|__|__|
      |__|__|__|__|__|__|__|__|__|__|__|__|__|__|
      *[CATI]:  Length of field = 28*

--- page 151 ---

GSS – Cycle 13 – Victimization                                                                                              Appendix B

V56    **How satisfied were you with the actions that the police took? Were you …**

                                        **INT: ===READ LIST===**

         (1)          Very satisfied?
         (2)          Somewhat satisfied?
         (3)          Somewhat dissatisfied?
         (4)          Very dissatisfied?

         (x)          Don't know
         (r)          Refused

V57    **Is there anything (else) they should have done to help you?**

                                        **INT:====Mark all that apply.===**

         (n)          No/nothing               *[Go to V60]*
         (1)          Take the person out of the house
         (2)          Charge/arrest the person
         (3)          Respond more quickly
         (4)          Refer/take you to a support service
         (5)          Relocate you
         (6)          Take you to hospital
         (7)          Be more supportive/sympathetic
         (8)          Other                    *[Go to V57S]*
         (x)          Don't know               *[Go to V60]*
         (r)          Refused                  *[Go to V60]*
         (0)          No other; continue       *[Go to V60]*

V57S  Specify
      |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
      |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
*[CATI]: Length of field <= 50*

*[Go to V60]*

V58A  **I'm going to read a list of reasons why some people choose not to contact the police.  Please tell me which ones apply to this incident.  Was it …**
         **Because it was dealt with another way?**  (e.g. reported to another official, landlord, manager, school official,  or private matter that took care  of myself, etc.)

         (1)          Yes
         (3)          No
         (r)          Refused

21

--- page 152 ---

GSS – Cycle 13 – Victimization                                                                                              Appendix B

V58B  **(I'm going to read a list of reasons why some people choose not to contact the police.  Please tell me which ones apply to this incident.  Was it …)
         Because of fear of revenge by the offender?**

         (1)          Yes
         (3)          No
         (r)          Refused

V58C  **(I'm going to read a list of reasons why some people choose not to contact the police.  Please tell me which ones apply to this incident.  Was it …)
         Because the police couldn't do anything about it?**  (e.g. didn't find out until too late, couldn't recover or identify property, couldn't find or identify  offender, lack of proof ,etc.)

         (1)          Yes
         (3)          No
         (r)          Refused

V58D  **(I'm going to read a list of reasons why some people choose not to contact the police.  Please tell me which ones apply to this incident.  Was it …)
         Because the police wouldn't help?**  (e.g. wouldn't think it was important enough, wouldn't want to be bothered or get involved, police would be inefficient or ineffective,  police would be biased, would harass/insult respondent, offender was police officer)

         (1)          Yes
         (3)          No
         (r)          Refused

V58E  **(I'm going to read a list of reasons why some people choose not to contact the police.  Please tell me which ones apply to this incident.  Was it …)
         Because you did not want to get involved with police?**

         (1)          Yes
         (3)          No
         (r)          Refused

V58F  **(I'm going to read a list of reasons why some people choose not to contact the police.  Please tell me which ones apply to this incident.  Was it …)
         Because it was not important enough to you?**  (e.g. minor crime,  small loss, child offender, no intended harm, etc.)

         (1)          Yes
         (3)          No
         (r)          Refused

22

--- page 153 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

V58G  **(I'm going to read a list of reasons why some people choose not to contact the police.  Please tell me which ones apply to this incident.  Was it …)
         Because the incident was a personal matter and did not concern the police?**

         (1)          Yes
         (3)          No
         (r)          Refused

V58H  **(I'm going to read a list of reasons why some people choose not to contact the police.  Please tell me which ones apply to this incident.  Was it …)
         Because of fear of publicity/news coverage?**

         (1)          Yes
         (3)          No
         (r)          Refused

*CATI-V58He: If crime incident type does not include any theft or damage of property, or includes  a physical attack,  sexual assault or unwanted sexual touching, then go to V58K, i.e.:  If ((V36 = ( ) or V36 = (n) or V36 = 'Off path') and (V42 =( ) or V42 = (n) or V42 = 'Off path')) or (V15 NE ( ) and V15 NE (n) and V15 = 'On path') or VSCRNO refers to 'B9' or 'B10' or 'B12' or 'B13'  Go to V58K.*

V58I  **(I'm going to read a list of reasons why some people choose not to contact the police.  Please tell me which ones apply to this incident.  Was it …)
         Because your insurance wouldn't cover it?**  (e.g. no insurance, loss less than deductible, etc.)

         (1)          Yes
         (3)          No
         (r)          Refused

V58J  **(I'm going to read a list of reasons why some people choose not to contact the police.  Please tell me which ones apply to this incident.  Was it …)
         Because nothing was taken or the items were recovered?**

         (1)          Yes
         (3)          No
         (r)          Refused

V58K  **(I'm going to read a list of reasons why some people choose not to contact the police.  Please tell me which ones apply to this incident.  Was it …)
         For some other reason, not already mentioned?**

         (1)          Yes
         (3)          No               *[Go to CATI-V58e]*
         (r)          Refused          *[Go to CATI-V58e]*

23

--- page 154 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

V58S   Specify
       |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
       |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
*[CATI]: Length of field = 50*

*CATI-V58e:   If the number of (1)'s in V58A to V58K <= 1 then      Go to V60.*

V59    **What was the main reason?**

       (1)       Dealt with another way
       (2)       Fear of revenge by the offender
       (3)       Police couldn't do anything
       (4)       Police wouldn't help
       (5)       Did not want to get involved with police
       (6)       Not important enough to respondent
       (7)       Incident was a personal matter and did not concern the police
       (8)       Fear of publicity/news coverage
       (9)       Insurance wouldn't cover
       (10)      Nothing was taken or the items were  recovered
       (11)      Other
       (r)       Refused

*CATI-V59e: If crime incident type does not refer to robbery, attempted robbery, physical attack, threat, sexual
         assault or unwanted sexual touching, then Ask only V60a), V60b), V60c), and V60e);
         Else - Ask all V60a) to V60f).  i.e., If not [((V36 NE ( ) and V36 NE (n) and V36 = "On path")
         or (V40  NE ( ) and V40 NE (n) and V40 = "On path")) and ((V10 = (1) and V10 = "On path"
         or (V13 = 1 and V14 = (1) and V13 = "On path")  or (V15 NE ( ) and V15 NE (n) and V15 =
         "On path"))] and not((V15 NE( ) and V15 NE (n)  and V15 = "On path") and not (V13 = (1)
         and V14 = (1) and V13 = "On path") and not (VSCRNO  refers to 'B9' or 'B10' or 'B12' or
         'B13') – Ask only V60a), V60b), V60c), and V60e); Else - Ask all V60a) to V60f).*

V60    **(Other than to the police,) did you ever talk to anyone about what happened, such as ...**

                                        INT: ===READ LIST===

                                        Yes    No    Don't know    Refused

       a)        Family?                (1)    (3)       (x)          (r)
       b)        Friend or neighbour?   (1)    (3)       (x)          (r)
       c)        Co-worker?             (1)    (3)       (x)          (r)
       d)        Doctor or nurse?       (1)    (3)       (x)          (r)
       e)        Lawyer?                (1)    (3)       (x)          (r)
       f)        Minister, priest, clergy, or
                    another spiritual advisor?   (1)    (3)       (x)          (r)

24

--- page 155 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

*CATI-V60e: If crime incident type does not refer to robbery, attempted robbery, physical attack, threat, sexual
                assault or unwanted sexual touching, then go to V62, i.e.:  If not [((V36 NE ( ) and V36 NE
                (n) and V36 = "On path") or (V40  NE ( ) and V40 NE (n) and V40 = "On path")) and
                ((V10 = (1) and V10 = "On path" or (V13 = 1 and V14 = (1) and V13 = "On path")  or
                (V15 NE ( ) and V15 NE (n) and V15 = "On path"))] and not (V15 NE ( ) and V15 NE (n)
                 and V15 = "On path") and not (V13 = (1) and V14 = (1) and V13 = "On path") and not
                (VSCRNO  refers to 'B9' or 'B10' or 'B12' or 'B13') Go to V62.*

V61    **Did you ever contact or use any of the following services for help because of this incident,
       such as …**
                                          INT: ===READ LIST===

                                                        Yes    No    Don't know  Refused

       a)         Crisis centre or crisis line?          (1)    (3)      (x)        (r)
       b)         Another counsellor?                   (1)    (3)      (x)        (r)
       c)         Community centre/family centre        (1)    (3)      (x)        (r)
       e)         Women's centre?
                    *[CATI:  only if female respondent]*  (1)  (3)      (x)        (r)
       f)         Men's centre/men's support group?
                    *[CATI: only if male respondent]*   (1)    (3)      (x)        (r)
       g)         Senior's centre?
                    *[CATI: only if respondent is 65+]* (1)    (3)      (x)        (r)

V62    **Did you ever contact or use police-based or court-based victim services because of this incident?**
       ("Victim Assistance Units" operate within a specific police office, and help victims at the police end of
       the justice system.  "Victim Services" help victims as their cases proceed through the justice system
       (police, courts and corrections).  Services include providing general information about the justice
       system, referrals, assistance with court, help preparing victim impact statements, offering emotional
       support and providing information to help victims  recover financial losses resulting from the crime.)

       (1)        Yes
       (3)        No
       (x)        Don't know
       (r)        Refused

*CATI-V63e:  If this is the first time the following question is asked read conditional text 1;  else read
                conditional text 2.*

25

--- page 156 ---

GSS – Cycle 13 – Victimization                                                                                              Appendix B

V63     **(There are a number of ways to deal with an offence outside the normal police-court process.  One way is a meeting between the victim and the offender to discuss an appropriate way the offender should be dealt with.  Thinking about this incident, how interested would you have been (be) in participating in such a program if one was available in your community?)
(Thinking about this incident, how interested would  you have been (be) in participating in a program where the victim and the offender meet to discuss an appropriate way the offender should be dealt with?)
Would you have been (be) …**

                                          INT: ===READ LIST===

        (1)          Very interested?
        (2)          Somewhat interested?
        (3)          Slightly interested?
        (4)          Not at all interested?

        (r)          Refused

V64     **At the time of the incident, how did this experience affect you?**

                                    INT:===Mark all that apply.===
              INT:===Do not include physical injury, financial loss or medical treatment.===

        (1)          Afraid for children
        (2)          Angry
        (3)          Ashamed/guilty
        (4)          Depression/ anxiety attacks
        (5)          Fearful
        (6)          Hurt/disappointment
        (7)          Increased self-reliance
        (8)          Lowered self esteem
        (9)          More cautious/aware
        (10)         Not much
        (11)         Problems relating to men/women
        (12)         Shock/disbelief
        (13)         Sleeping problems
        (14)         Upset/confused/frustrated
        (15)         Other               *[Go to V64S]*
        (x)          Don't know          *[Go to CATI-V64ae]*
        (r)          Refused             *[Go to CATI-V64ae]*
        (0)          No other; continue  *[Go to CATI-V64ae]*

V64S  Specify
        |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
        |__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|__|
*[CATI]: Length of field = 50*

26

--- page 157 ---

GSS – Cycle 13 – Victimization                                                                                    Appendix B

*CATI-V64ae:  If there are less than 2 Incident Reports remaining to be completed for the type of crime referred
                      to by VSCRNO  - Go to V66.*

*CATI-V64be:*  **INT:=== Is this respondent having trouble distinguishing the details of this incident from
      other similar incidents?  (The respondent must be unable to recall details of the incident and not able
      to report it separately.  If the respondent remembers any important details that allow him/her to
      distinguish the incidents, the remaining incidents should be reported separately, regardless of how
      many crimes there were.)===**

            *(1)      Yes*
            *(3)      No       [Go to V66]*

V65   **Of the remaining** *(calculate the number of incidents remaining)* **incidents during the past 12 months,
      how many have details similar to this one?  Exclude incidents you have already told me about.**

      |___|___| *incidents (If none enter 0)*

 *CATI-V65e:    If V65 >=2 set INCSKIP to V65.*
                    *If "v" key used at any time in Section V – interviewer ask V66; else go to V67.*

V66   **INT:===Is there any information or additional information that you would like to add about
                  this incident?===**

___________________________________________________________________________

___________________________________________________________________________

___________________________________________________________________________

___________________________________________________________________________

___________________________________________________________________________

      (n) No/Nothing

V67   *If V1 = (n) or (V1 = (x) or V1 = (r)) and V1A NE (1) and V1A NE (5)) then set REP_STAT to (4) (Out of
      scope); Go to V68;*

      **INT:===If it has turned out that this incident is a duplicate or is out of scope (e.g. respondent is
      not the victim), please indicate this.===**

      (0)       Neither duplicate nor out of scope - continue
      (3)       Duplicate incident report
      (4)       Out of scope (respondent not victim)

      *If V67 = (1) then set REP_STAT to (3) (Duplicate);*
      *Else if V67 = (2) then set REP_STAT to (4) (Out of scope);*
      *Else if V65 >= 2  then set REP_STAT to (2) (Series);*
      *Else set REP_STAT to (1) (Single)*

27

--- page 158 ---

*GSS – Cycle 13 – Victimization*                                                                *Appendix B*

V68  **INT:===The status of this incident report is …===**
     *(Fill: Give status)*

     Press 0 to confirm and continue.

     (0) To continue

28
