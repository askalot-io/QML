                               Catalogue No. 94-10


           1994 PRELIMINARY INTERVIEW QUESTIONNAIRE




                                    June 1994




                     Alison Hale, Household Surveys Division
                    Debbie Lutz, Household Surveys Division
                     Mike Brule, Household Surveys Division




The SLID Research Paper Series is intended to document detailed studies and
important decisions for the Survey of Labour and Income Dynamics. These
research papers are available in English and French. To obtain a summary
description of available documents or to obtain a copy of any, please contact Philip
Giles, Manager, SLID Research Paper Series, by mail at 11-D8 Jean Talon
Building, Statistics Canada, Ottawa, Ontario, CANADA K1A 0T6, by
INTERNET (GILES@STATCAN.CA), by telephone (613) 951-2891, or by fax
(613) 951-3253.
                           EXECUTIVE SUMMARY




A Preliminary Interview is conducted for all respondents entering the SLID
sample. For the majority of respondents (the longitudinal respondents), this occurs
when a new panel of respondents is introduced. However, all persons living with a
longitudinal respondent are also interviewed for SLID. Thus, some Preliminary
Interviews are conducted while the annual labour and income interviews are
conducted.


The Preliminary Interview for longitudinal respondents in Panel 1 were conducted
using traditional "paper-and-pencil" collection. All subsequent Preliminary
Interviews are collected using computer-assisted interviewing (CAI), which
requires no "paper" questionnaire for collecting the data. The purpose of this
document is to present the questions, answers and question flow for the CAI
Preliminary Interview. These questions are identical to the "paper" questionnaire
used for the longitudinal respondents.
                    TABLE OF CONTENTS
                                        Page


1.   INTRODUCTION                         1


2.   HOW TO READ THIS DOCUMENT            3


3.   EMPPRE MODULE                        5


4.   EXPRE MODULE                        21


5.   DEMPRE MODULE                       26


6.   EDUPRE MODULE                       37


     APPENDIX 1: FLOWCHARTS              47
1.     INTRODUCTION


A Preliminary Interview is conducted for all respondents entering the SLID
sample. For the majority of respondents (the longitudinal respondents), this occurs
when a new panel of respondents is introduced. However, all persons living with a
longitudinal respondent are also interviewed for SLID. Thus, some Preliminary
Interviews are conducted concurrently with the annual labour and income
interviews.


The Preliminary Interview for longitudinal respondents in Panel 1 were conducted
using traditional "paper-and-pencil" collection. This questionnaire is discussed in
SLID Research Paper 92-07, Objectives and Content of the Preliminary
Interview. All subsequent Preliminary Interviews are collected using computer-
assisted interviewing (CAI), which requires no "paper" questionnaire for collecting
the data. The purpose of this document is to present the questions, answers and
question flow for the CAI Preliminary Interview. These questions are identical to
the "paper" questionnaire used for the longitudinal respondents. However, not all
the Preliminary Interview questions were necessary on the "paper" questionnaire.
This questionnaire was used as a supplement to the Labour Force Survey in
January 1993. Those questions on the SLID Preliminary Interview which were
also on the LFS questionnaire were not necessary on the "paper" questionnaire.


As mentioned, this document is a written approximation of the CAI interview, or
the questionnaire. The CAI process is as follows:
a) A question appearing on the computer screen is read aloud to the respondent.
b) The respondent's answer is directly entered by the interviewer.
c) Based on the answer given, and/or age or other flow criterion, the computer
determines the next question to be asked and displays it on the screen.
                                        -2-

The CAI Preliminary Interview has four main sections: EMPPRE, EXPRE,
DEMPRE, AND EDUPRE. The topic of each section is:
!      EMPPRE:        Current or recent work activity - Information on up to two
                      employers is collected
!      EXPRE:         Work experience
!      DEMPRE:        Basic demographics, marital history, birth history, mother
                      tongue, place of birth, ethnic origin, parents' level of
                      education
!      EDUPRE:        Educational attainment and current educational activity


Flowcharts presenting the flow of the questions are included as Appendix 1. The
following chart presents the overall flow of modules for the Preliminary Interview.
                                         -3-

2.     HOW TO READ THIS DOCUMENT


Question numbers: For each section, the question numbers generally refer to the
actual numbers used in the software and which appear on an interviewer's
computer screen. Text in capital letters is read, as worded, by the interviewer.
Those questions in lower case with "Interviewer:" at the beginning are questions to
be answered directly by the interviewer without asking the respondent. Those
questions with "Internal logic:" at the beginning are questions answered directly by
the computer. They are invisible to the interviewer, and are required to direct
question flow.


Pre-fill items: These are items specific to each respondent's interview. The
software adds the relevant information into the question, making it simply a matter
of reading for the interviewer. Prefill items (given in square brackets [ ]) include:
       [respondent] - This is the first and last name of the household member that
       the questions refer to. This is not necessarily the person who is talking to
       the interviewer.
       [current year] - This is the obvious, 1994 in the case of the first annual
       interviews.
       [reference year] - This is the year for which the information is collected,
       1993 in the case of the first annual interviews.


       [age] - This is the respondent's age, in years.
       [response given in ...] - These prefill items contain a question name from
       earlier in the Preliminary Interview. The response given to this previous
       question is used as part of the current question.
                                         -4-

Headers: For each question, important information is noted at the top of the
screen. In this document, this information is given at the beginning of each section
description.


Ranges: Hard ranges are specified for some of the questions. The hard range gives
the highest and lowest acceptable response values. The system will not accept a
number outside the range.
A soft range specifies an upper and lower limit which if exceeded will result in a
probe to confirm that the amount entered is correct. If it is correct, the entry is
allowed as long as it is not outside the hard range. No soft ranges exist for the
Preliminary Interview questions.


Dates: All dates are entered by number in boxes, using the DD/MM/YY format.
When a numeric value for month (1 to 12) is entered, the appropriate text flashes.
For example, if the interviewer enters a date 26/09/93, the screen shows: 26 09
September 1993.


Function Keys: Interviewers have a number of keys on the computer (function
keys) which are available to provide them with the following options.


       Comment - gives the interviewer the opportunity to add additional
       information in a note that will be attached to the data for that question.
       These comments are often useful during data processing.
       Don't know: to indicate if the respondent doesn't know the answer to the
       question. This answer is shown in this paper as DK.
       Refusal - to indicate if the respondent refuses to answer the question. This
       response is shown in the paper as R.
                                       -5-

       Options - gives the interviewer access to some optional functions or
       information rosters. The choices available are: Household list - name, age,
       sex, marital status of each household member.


3.     EMPPRE MODULE


HEADER: Employer Name (when appropriate: Questions ending in J1 refer to
1st employer; those ending in J2 refer to 2nd employer))


* START-EMPPRE Internal logic: [age] = 15 or more?
                      Yes                           Go to EMPPRE-Q1
                      No                            Go to EXPRE-Q1A


EMPPRE-Q1             DID [respondent] WORK AT A JOB OR BUSINESS
                      AT THE BEGINNING OF JANUARY OF THIS
                      YEAR?
                      Interviewer: Enter a job regardless of the number of
                      hours worked.
                      Yes                           Go to EMPPRE-J1.Q1
                      No                            Go to EMPPRE-Q2
                      Permanently
                      unable to work                Go to EMPPRE-Q5
                      DK/R                          Go to EMPPRE-N12


EMPPRE-Q2             DID [respondent] HAVE A JOB OR BUSINESS AT
                      WHICH HE/SHE DID NOT WORK AT THE
                      BEGINNING OF JANUARY?


                      Yes                           Go to EMPPRE-Q3
                      No/DK/R                       Go to EMPPRE-Q5
                                -6-

EMPPRE-Q3     WHY WAS [respondent] ABSENT FROM WORK AT
              THE BEGINNING OF JANUARY?


              Own illness or disability
              Pregnancy
              Caring for own children
              Caring for elder relatives
              Other personal or family responsibilities
              School or educational leave
              Labour dispute
              Temporary layoff due to seasonal conditions
              Temporary layoff - non seasonal
              Unpaid or partially paid vacation
              Other (Specify)


              If answered "School or educational leave" go to EMPPRE-
              Q5. Otherwise, go to EMPPRE-Q4.


EMPPRE-Q4     DID [respondent] RECEIVE ANY PAY FROM
              HIS/HER EMPLOYER FOR THIS ABSENCE?


              Yes/No/DK/R


* EMPPRE-N4   Internal logic: EMPPRE-Q3=Temporary Layoff
              Yes    Go to EMPPRE-Q8
              Otherwise go to EMPPRE-J1.Q1
                                -7-

EMPPRE-Q5     DID [respondent] EVER WORK AT A JOB OR
              BUSINESS?


              Yes/DK/R        Go to EMPPRE-Q6
              No              Go to EMPPRE-N7


EMPPRE-Q6     WHEN DID [respondent] LAST WORK AT A JOB OR
              BUSINESS?


              Hard Range:
                      Maximum: current year
                      Minimum: current year-(age-10)


* EMPPRE-N6   Internal logic: Date in EMPPRE-Q6 is before January
              [current year] minus 5 and EMPPRE-Q1=permanently
              unable to work?


              Yes             Go to EMPPRE-N12
              Otherwise       Go to EMPPRE-Q7.


EMPPRE-Q7     WHAT WAS [respondent]'S MAIN REASON FOR
              LEAVING THIS JOB?
              Own illness, disability
              Caring for own children
              Caring for elder relatives
              Other personal or family responsibilities
              Going to school
              Quit job for no specific reason
              Lost job or laid off job - Paid workers only
                                 -8-

              Changed residence
              Dissatisfied with job
              Retired
              Other - Specify


* EMPPRE-N7   Internal logic: EMPPRE-Q1= permanently unable to
              work?


              Yes               Go to EMPPRE-N12
              Otherwise         Go to EMPPRE-Q8.


EMPPRE-Q8     DID [respondent] LOOK FOR WORK IN JANUARY
              OF THIS YEAR?


              Yes                           Go to EMPPRE-Q9
              No/DK/R                       Go to EMPPRE-Q10


EMPPRE-Q9     WHAT DID [respondent] DO TO FIND WORK?


              Contacted employer directly
              Friend or relative
              Placed or answered newspaper ad
              Employment agency
              Referral from another employer
              Other - specify
                                  -9-

* EMPPRE-N11A   Internal logic: EMPPRE-Q5=no (never worked at a job
                or business) or dates last worked (EMPPRE-Q6) is
                before January [reference year]?


                Yes             Go to EMPPRE-N12
                Otherwise       Go to EMPPRE-J1.Q1A.


EMPPRE-Q10      DID [respondent] LOOK FOR WORK AT ANY TIME
                IN THE 6 MONTHS BEFORE THAT?


                Yes/DK/R                  Go to EMPPRE-Q11
                No                        Go to EMPPRE-N11A


EMPPRE-Q11      WHAT WERE THE REASONS [respondent] DID NOT
                LOOK FOR WORK IN JANUARY OF THIS YEAR?
                Interviewer: If only answered Own illness or Personal
                responsibilities, probe for other reasons.


                Own illness, disability
                Caring for own children
                Caring for elder relatives
                Other personal or family responsibilities
                Going to school
                No longer interested in finding work
                Waiting for recall (to former job)
                Has found new job
                Waiting for replies from employers
                                 - 10 -

               Believes no work available (in area, or suited to skills)
               No reason given
               Other - Specify


               Go to EMPPRE-N11A


* EMPPRE-N12   Internal logic: [age] is greater than 64 years?


               Yes            Go to EXPRE-Q1
               Otherwise      Go to EMPPRE-Q12.


EMPPRE-Q12     IN JANUARY OF THIS YEAR, WAS [respondent]
               ATTENDING A SCHOOL, COLLEGE OR
               UNIVERSITY?


               Yes                        Go to EMPPRE-Q13
               No/DK/R                    Go to EXPRE-Q1A


EMPPRE-Q13     WAS [respondent] ENROLLED AS A FULL-TIME OR
               PART-TIME STUDENT?


               Full-time student
               Part-time student
               Some of each


               Go to EXPRE-Q1A
                                 - 11 -

EMPPRE-J1.Q1      I WOULD LIKE TO ASK A FEW QUESTIONS
                  ABOUT [respondent]'S MAIN JOB OR BUSINESS IN
                  EARLY JANUARY. FOR WHOM DID [respondent]
                  WORK? (name of business, government department, or
                  agency, or person)


                  Go to EMPPRE-J1.Q2


EMPPRE-J1.Q1A     I WOULD LIKE TO ASK A FEW QUESTIONS
                  ABOUT THE LAST JOB OR BUSINESS HELD BY
                  [respondent] IN [reference year]. FOR WHOM DID
                  [respondent] WORK? (name of business, government
                  department, or agency, or person)


EMPPRE-J1.Q2      WHEN WAS THE FIRST TIME [respondent]
                  STARTED WORKING FOR THIS EMPLOYER?


                  Hard range:
                         Maximum: [current year]
                         Minimum: [current year]-[age]-10


* EMPPRE-J1.N2 Internal logic: Date first started working (EMPPRE-
                  J1.Q2) is before date last worked (EMPPRE-Q6)?


                  Yes           Go to EMPPRE-J1.Q3
                  No            Go to EMPPRE-J1.Q2A
                  Otherwise     Go to EMPPRE-J1.Q3
                                 - 12 -

EMPPRE-J1.Q2A   Interviewer: Date first started working for this
                employer (EMPPRE-J1.Q2) is after the date last
                worked (EMPPRE-Q6). Go back to EMPPRE-Q6
                and/or EMPPRE-J1.Q2 to correct inconsistencies, or
                press <Enter> to continue.


EMPPRE-J1.Q3    WHAT KIND OF BUSINESS, INDUSTRY OR
                SERVICE WAS THIS? (e.g., federal government, canning
                industry, forestry service)


EMPPRE-J1.Q4    WHAT KIND OF WORK WAS [respondent] DOING?
                (e.g., office clerk, factory worker, forestry technician)


EMPPRE-J1.Q5    WHAT WERE [respondent]'S MOST IMPORTANT
                ACTIVITIES OR DUTIES? (e.g., filing documents,
                drying vegetables, forest examiner)


EMPPRE-J1.Q6    IN THIS JOB, WAS [respondent] A PAID WORKER,
                SELF-EMPLOYED OR AN UNPAID FAMILY
                WORKER?


                Paid worker
                Unpaid family worker
                Self-employed Incorporated - With paid help
                Self-employed Incorporated - No paid help
                Self-employed Unincorporated - With paid help
                Self-employed Unincorporated - No paid help

                If paid worker or DK/R         Go to EMPPRE-J1.Q7A.
                Otherwise                      Go to EMPPRE-N12
                                 - 13 -

EMPPRE-J1.Q7A   IN WHICH MONTHS OF [reference year] DID
                [respondent] WORK AT THIS JOB?


                All months/DK/R                Go to EMPPRE-J1.Q8
                Started in [current year]      Go to EMPPRE-N12
                Specify months                 Go to EMPPRE-J1.Q7B
                Last worked                    Go to EMPPRE-J1-Q7B
                before [reference year]


EMPPRE-J1.Q7B   Interviewer: Specify months [respondent] worked in
                [reference year]


                January
                February
                March
                April
                May
                June
                July
                August
                September
                October
                November
                December


EMPPRE-J1.Q8    AT THIS JOB, DID [respondent] USUALLY WORK
                EVERY WEEK OF THE MONTH?


                Yes/DK/R                  Go to EMPPRE-J1.Q10
                No                        Go to EMPPRE-J1.Q9
                                  - 14 -

EMPPRE-J1.Q9       HOW MANY WEEKS DID [respondent] USUALLY
                   WORK EACH MONTH?


                   Hard range:
                            Maximum: 3
                            Minimum: 1


EMPPRE-J1.Q10      HOW MANY HOURS PER WEEK DID [respondent]
                   USUALLY GET PAID?


                   Hard range:
                            Maximum: 99.9
                            Minimum: 1.0


EMPPRE-J1.Q11A AT THIS JOB, WHAT WAS [respondent]'S WAGE
                   OR SALARY BEFORE TAXES AND DEDUCTIONS?
                   (As of January of this year or when they last worked for
                   this employer in [reference year]).


                   Hard range:
                            Maximum: 999999.99
                            Minimum:       0.01


EMPPRE-J1.Q11B Interviewer: Select the appropriate category for
                   reported wage or salary


                   Hourly
                   Weekly
                   Every two weeks/twice a month
                                  - 15 -

                Monthly
                Yearly
                Other (specify)


                If answered Other(specify) go to EMPPRE-J1.Q12,
                otherwise go to EMPPRE-J1.Q13.


EMPPRE-J1.Q12   WHAT WERE [respondent]'S TOTAL EARNINGS
                FROM THIS JOB IN [reference year]?


                Hard range:
                         Maximum: 999999.99
                         Minimum:          0.01


EMPPRE-J1.Q13   DID [respondent] RECEIVE ANY COMMISSIONS,
                TIPS, BONUSES OR PAID OVERTIME FROM THIS
                JOB IN [reference year]?


                Yes                        Go to EMPPRE-J1.Q14
                No/DK/R                    Go to EMPPRE-J2.Q1


EMPPRE-J1.Q14   WERE THESE COMMISSIONS, TIPS, BONUSES OR
                PAID OVERTIME INCLUDED IN THE AMOUNT
                JUST REPORTED?


                Yes/DK/R                   Go to EMPPRE-J2.Q1
                No                         Go to EMPPRE-J1.Q15
                               - 16 -

EMPPRE-J1.Q15   WHAT WERE [respondent]'S TOTAL EARNINGS IN
                [reference year] FROM THESE COMMISSIONS,
                TIPS, BONUSES, OR PAID OVERTIME?


                Hard range:
                       Maximum: 999999.99
                       Minimum:           0.01


                Go to EMPPRE-N12


EMPPRE-J2.Q1    DID [respondent] HAVE MORE THAN ONE JOB OR
                BUSINESS IN JANUARY OF THIS YEAR?


                Yes                     Go to EMPPRE-J2.Q2
                No/DK/R                 Go to EMPPRE-N12


EMPPRE-J2.Q2    I WOULD LIKE TO ASK A FEW QUESTIONS
                ABOUT [respondent]'S OTHER JOB OR BUSINESS
                IN JANUARY OF THIS YEAR. FOR WHOM DID
                [respondent] WORK? (name of business, government
                department, or agency, or person)


EMPPRE-J2.Q3    WHEN DID [respondent] FIRST START WORKING
                FOR THIS EMPLOYER?


                Hard range:
                       Maximum: [current year]
                       Minimum: [current year]-[age]-10
                                 - 17 -

EMPPRE-J2.Q4    WHAT KIND OF BUSINESS, INDUSTRY OR
                SERVICE WAS THIS? (e.g., federal government, canning
                industry, forestry services)


EMPPRE-J2.Q5    WHAT KIND OF WORK WAS [respondent] DOING?
                (e.g., office clerk, factory worker, forestry technician)


EMPPRE-J2.Q6    WHAT WERE [respondent]'S MOST IMPORTANT
                ACTIVITIES OR DUTIES? (e.g., filing documents,
                drying vegetables, forest examiner)


EMPPRE-J2.Q7    IN THIS JOB, WAS [respondent] A PAID WORKER,
                SELF-EMPLOYED OR AN UNPAID FAMILY
                WORKER?


                Paid worker
                Unpaid family worker
                Self-employed Incorporated - With paid help
                Self-employed Incorporated - No paid help
                Self-employed Unincorporated - With paid help
                Self-employed Unincorporated - No paid help


                If paid worker or DK/R         Go to EMPPRE-J2.Q8A
                Otherwise                      Go to EMPPRE-Q12.


EMPPRE-J2.Q8A   IN WHICH MONTHS OF [reference year] DID
                [respondent] WORK AT THIS JOB?


                All months/DK/R                Go to EMPPRE-J2.Q9
                                 - 18 -

                Started in [current year]      Go to EMPPRE-N12
                Specify months                 Go to EMPPRE-J2.Q8B
                Last worked                    Go to EMPPRE-J2.Q8B
                before [reference year]


EMPPRE-J2.Q8B   Interviewer: Specify months [respondent] worked in
                [reference year]?


                January
                February
                March
                April
                May
                June
                July
                August
                September
                October
                November
                December


EMPPRE-J2.Q9    AT THIS JOB, DID [respondent] USUALLY WORK
                EVERY WEEK OF THE MONTH?


                Yes/DK/R                  Go to EMPPRE-J2.Q11
                No                        Go to EMPPRE-J2.Q10
                                  - 19 -

EMPPRE-J2.Q10      HOW MANY WEEKS DID [respondent] USUALLY
                   WORK EACH MONTH?


                   Hard range:
                            Maximum: 3
                            Minimum: 1


EMPPRE-J2.Q11      HOW MANY HOURS PER WEEK DID [respondent]
                   USUALLY GET PAID?


                   Hard range:
                            Maximum: 99.9
                            Minimum: 1.0


EMPPRE-J2.Q12A AT THIS JOB, WHAT WAS [respondent]'S WAGE
                   OR SALARY BEFORE TAXES AND DEDUCTIONS?


                   Hard range:
                            Maximum: 999999.99
                            Minimum:       0.01


EMPPRE-J2.Q12B Interviewer: Select the appropriate category for
                   reported wage or salary.


                   Hourly
                   Weekly
                   Every two weeks/twice a month
                   Monthly
                                  - 20 -

                Yearly
                Other (specify)


                If Other - specify go to EMPPRE-J2.Q13, otherwise go to
                EMPPRE-J2.Q14.


EMPPRE-J2.Q13   WHAT WERE [respondent]'S TOTAL EARNINGS
                FROM THIS JOB IN [reference year]?


                Hard range:
                         Maximum: 999999.99
                         Minimum:          0.01


EMPPRE-J2.Q14   DID [respondent] RECEIVE ANY COMMISSIONS,
                TIPS, BONUSES OR PAID OVERTIME FROM THIS
                JOB IN [reference year]?


                Yes                        Go to EMPPRE-J2.Q15
                No/DK/R                    Go to EMPPRE-N12


EMPPRE-J2.Q15   WERE THESE COMMISSIONS, TIPS, BONUSES OR
                PAID OVERTIME INCLUDED IN THE AMOUNT
                JUST REPORTED?


                Yes/DK/R                   Go to EMPPRE-N12
                No                         Go to EMPPRE-J2.Q16
                                 - 21 -

EMPPRE-J2.Q16     WHAT WERE [respondent]'S TOTAL EARNINGS IN
                  [reference year] FROM THESE COMMISSIONS,
                  TIPS, BONUSES, OR PAID OVERTIME?


                  Hard range:
                         Maximum: 999999.99
                         Minimum:         0.01


                  Go to EMPPRE-N12


4.   EXPRE MODULE


HEADER: None


* EXPRE-N1        Internal logic: [age] is greater than 69 years?


                  Yes           Go to DEMPRE-Q1A
                  Otherwise     Go to EXPRE-Q1A.


EXPRE-Q1A THE NEXT FEW QUESTIONS ARE ABOUT [respondent]'S
             WORK EXPERIENCE, THINKING BACK TO WHEN
             HE/SHE FIRST STARTED WORKING AT A JOB OR
             BUSINESS.
                  DID [respondent] EVER WORK FULL-TIME?
                  (Exclude summer jobs while in school)


                  Yes
                  No, never worked full-time
                            - 22 -

            No, only worked full-time at summer jobs while in school
            DK/R


            If Yes go to EXPRE-Q1B.
            Otherwise go to DEMPRE-Q1A.


EXPRE-Q1B   HOW MANY YEARS AGO DID [respondent] FIRST
            START WORKING FULL-TIME? (Exclude summer
            jobs while in school)
            Interviewer: Enter 00 if less than one year


            Hard range:
                   Maximum: [age]-10
                   Minimum: 0


            If DK/R or 0             Go to DEMPRE-Q1A.
            If answered 1 year       Go to EXPRE-Q3
            Otherwise                Go to EXPRE-Q2A.


EXPRE-Q2A   IN THOSE [response given in EXPRE-Q1B] YEARS,
            WERE THERE ANY YEARS WHEN [respondent]
            DID NOT WORK AT A JOB OR BUSINESS?


            Yes                      Go to EXPRE-Q2B
            No/DK/R                  Go to EXPRE-Q3
                           - 23 -

EXPRE-Q2B   HOW MANY YEARS DID [respondent] NOT WORK
            AT A JOB OR BUSINESS?


            Hard range:
                    Maximum: [response given in EXPRE-Q1B]
                    Minimum: 1


            Go to EXPRE-Q5A


EXPRE-Q3    IN THOSE [response given in EXPRE-Q1B] YEARS,
            DID [respondent] WORK AT LEAST 6 MONTHS
            EACH AND EVERY YEAR?


            Yes/DK/R                   Go to EXPRE-Q4A
            No                         Go to EXPRE-Q5A


EXPRE-Q4A   HOW MANY YEARS DID HE/SHE WORK ONLY
            FULL-TIME? (by full-time I mean 30 or more hours per
            week)
            Interviewer: If none enter 00


            Hard range:
                    Maximum: [response given in EXPRE-Q1B]
                    Minimum: 0


EXPRE-Q4B   HOW MANY YEARS DID HE/SHE WORK ONLY
            PART-TIME?
            Interviewer: If none enter 00
                           - 24 -

             Hard range:
                   Maximum: [response given in EXPRE-Q1B]
                   Minimum: 0


EXPRE-Q4C    HOW MANY YEARS DID HE/SHE ONLY WORK
             SOME OF EACH (full-time and part-time)
             Interviewer: If none enter 00


             Hard range:
                   Maximum: [response given in EXPRE-Q1B]
                   Minimum: 0


* EXPRE-N4   Internal logic: Sum of Q4A/B/C = EXPRE-Q1B?


             Yes           Go to DEMPRE-Q1A
             Otherwise     Go to EXPRE-Q4D


EXPRE-Q4D    Interviewer: [respondent] has worked full-time for
             [answer in EXPRE-Q4A] years, part-time for [answer
             in EXPRE-Q4B] years, and some of each for [answer in
             EXPRE-Q4C] years. Conflict with when started
             working full-time[answer in EXPRE-Q1B] years ago. If
             incorrect go back to previous questions and make
             necessary changes. Otherwise press <Enter> to
             continue.
                           - 25 -

EXPRE-Q5A   SINCE [respondent] FIRST STARTED WORKING,
            HOW MANY YEARS DID HE/SHE WORK AT
            LEAST 6 MONTHS OF THE YEAR?
            Interviewer: If none enter 00


            Hard range:
                   Maximum: [response given in EXPRE-Q1B] minus
                   [response given in EXPRE-Q2B] (if 2B not
                   answered use Q1B as maximum).
                   Minimum: 0


            If 0/DK/R               Go to DEMPRE-Q1A
            Otherwise               Go to EXPRE-Q6A


EXPRE-Q6A   IN THOSE [response given in EXPRE-Q5A] YEARS,
            HOW MANY DID HE/SHE WORK ONLY FULL-
            TIME ? (by full-time I mean 30 or more hours per week)
            Interviewer: If none enter 00


            Hard range:
                   Maximum: [response given in EXPRE-Q5A]
                   Minimum: 0


EXPRE-Q6B   IN THOSE [response given in EXPRE-Q5A] YEARS,
            HOW MANY DID HE/SHE WORK ONLY PART-
            TIME?
            Interviewer: If none enter 00
            Hard range:
                   Maximum: [response given in EXPRE-Q5A]
                   Minimum: 0
                             - 26 -

EXPRE-Q6C      IN THOSE [response given in EXPRE-Q5A] YEARS,
               HOW MANY DID HE/SHE ONLY WORK SOME OF
               EACH? (full-time and part-time)
               Interviewer: If none enter 00


               Hard range:
                     Maximum: [response given in EXPRE-Q5A]
                     Minimum: 0


* EXPRE-N6     Internal logic: Sum of Q6A/B/C/ = EXPRE-Q5A?


               Yes           Go to DEMPRE-Q1A
               Otherwise     Go to EXPRE-Q6D


EXPRE-Q6D      Interviewer: [respondent] is shown working full-time
               for [answer in EXPRE-Q6A] years, part-time for
               [answer in EXPRE-Q6B] years, and some of each for
               [answer in EXPRE-Q6C] years. Conflicts with # of
               years they worked more than six months[answer in
               EXPRE-Q5A]. If incorrect go back to previous
               questions and make necessary changes. Otherwise press
               <Enter> to continue.


5.   DEMPRE MODULE


HEADER: None


DEMPRE-Q1A     THE NEXT FEW QUESTIONS ARE ABOUT
               [respondent]'S FAMILY BACKGROUND AND ARE
                              - 27 -

               BASED ON THE DATE OF BIRTH AND MARITAL
               STATUS REPORTED EARLIER IN THE
               INTERVIEW.


* DEMPRE-N1    Internal logic: Marital status = married?


               Yes           Go to DEMPRE-Q2B


* DEMPRE-N1A   Internal logic: Marital status = common-in-law?


               Yes           Go to DEMPRE-Q5


* DEMPRE-N1B   Internal logic: Marital status = separated?


               Yes           Go to DEMPRE-Q1


* DEMPRE-N1C   Internal logic: Marital status = divorced?


               Yes           Go to DEMPRE-Q1


* DEMPRE-N1D   Internal logic: Marital status = widowed?


               Yes           Go to DEMPRE-Q7


* DEMPRE-N1E   Internal logic: Marital status = single (never married)?


               Yes           Go to DEMPRE-N11A
                              - 28 -

* DEMPRE-N1F   Internal logic: Marital status = DK/R?


               Yes           Go to DEMPRE-N11A


DEMPRE-Q1      WHAT WAS THE DATE OF [respondent]'S
               SEPARATION? (Not the date of divorce)


               Hard range:
                      Maximum: [current year]
                      Minimum: [current year] minus [age] minus 14


DEMPRE-Q2      WHAT WAS THE DATE OF THIS MARRIAGE?


               Hard range:
                      Maximum: [current year]
                      Minimum: [current year] minus [age] minus 14
               Go to COMPARE-Q2


* COMPARE-Q2   Internal logic: Date of this marriage(DEMPRE-Q2) is
               before date of separation (DEMPRE-Q1).


               No            Go to DEMPRE-Q2A
               Otherwise     Go to DEMPRE-Q3


DEMPRE-Q2A     Interviewer: Date of marriage [response in DEMPRE-
               Q2] is after date of separation [response in DEMPRE-
               Q1]. If information is incorrect go to previous questions
               to correct inconsistencies. Otherwise press <Enter> to
               continue.
                             - 29 -

DEMPRE-Q2B     WHAT WAS THE DATE OF [respondent]'S
               MARRIAGE?


               Hard range:
                     Maximum: [current year]
                     Minimum: [current year] minus [age] minus 14


DEMPRE-Q3      WAS THIS [respondent]'S FIRST MARRIAGE?


               Yes/DK/R               Go to DEMPRE-N11A
               No                     Go to DEMPRE-Q4


DEMPRE-Q4      WHAT WAS THE DATE OF [respondent]'S FIRST
               MARRIAGE?


               Hard range:
                     Maximum: [current year]
                     Minimum: [current year] minus [age] minus 14


* COMPARE-Q4   Internal logic: Date of first marriage(DEMPRE-Q4) is
               before date of current marriage(DEMPRE-Q2)?


               No                     Go to DEMPRE-Q4A
               Otherwise              Go to DEMPRE-N11A


DEMPRE-Q4A     Interviewer: Date of marriage [response in DEMPRE-
               Q4] should be before date of current marriage [response
               in DEMPRE-Q2B]. If information is incorrect go to
                          - 30 -

            previous questions to correct inconsistencies. Otherwise
            press <Enter> to continue.


DEMPRE-Q5   WHEN DID [respondent] AND HIS/HER PARTNER
            BEGIN TO LIVE TOGETHER?


            Hard range:
                   Maximum: [current year]
                   Minimum: [current year] minus [age] minus 14


DEMPRE-Q6   HAS [respondent] EVER BEEN MARRIED?


            Yes                    Go to DEMPRE-Q8
            No/DK/R                Go to DEMPRE-N11A


DEMPRE-Q7   WHEN WAS [respondent] WIDOWED?
            Hard range:
                   Maximum: [current year]
                   Minimum: [current year] minus [age] minus 14


DEMPRE-Q8   WAS THIS [respondent]'S FIRST MARRIAGE?


            Yes/DK/R               Go to DEMPRE-Q9
            No                     Go to DEMPRE-Q10


DEMPRE-Q9   WHAT WAS THE DATE OF [respondent]'S
            MARRIAGE?
            Hard range:
                  Maximum: [current year]
                  Minimum: [current year] minus [age] minus 14
                             - 31 -

* COMPARE9A   Internal logic: Date of marriage (DEMPRE-Q9) is
              before date widowed (DEMPRE-Q7)?


              No            Go to DEMPRE-Q9A
              Otherwise     Go to COMPARE9B


DEMPRE-Q9A    Interviewer: Date of previous marriage [answer in
              DEMPRE-Q9] should be before date widowed [answer
              in DEMPRE-Q7]. If information is incorrect go to
              previous questions to correct inconsistencies. Otherwise
              press <Enter> to continue.


* COMPARE9B   Internal logic: Date of marriage (DEMPRE-Q9) is
              before date living together (DEMPRE-Q5)?


              No            Go to DEMPRE-Q9B
              Otherwise     Go to DEMPRE-N11A


DEMPRE-Q9B    Interviewer: Date of previous marriage [answer in
              DEMPRE-Q9] should be before date started living
              together [answer in DEMPRE-Q5]. If information is
              incorrect go to previous questions to correct
              inconsistencies. Otherwise press <Enter> to continue.


DEMPRE-Q10    WHAT WAS THE DATE OF [respondent]'S FIRST
              MARRIAGE?
              Hard range:
                     Maximum: [current year]
                     Minimum: [current year] minus [age] minus 14
                                  - 32 -

* COMPARE10A       Internal logic: Date of first marriage (DEMPRE-Q10)
                   is before date started living together (DEMPRE-Q5)?


                   No            Go to DEMPRE-Q10A
                   Otherwise     Go to COMPARE10B


DEMPRE-Q10A        Interviewer: Date of first marriage [answer in
                   DEMPRE-Q10] should be before date started living
                   together [answer in DEMPRE-Q5]. If information is
                   incorrect go to previous questions to correct
                   inconsistencies. Otherwise press <Enter> to continue.


* COMPARE10B       Internal logic: Date of first marriage (DEMPRE-Q10)
                   is before date widowed (DEMPRE-Q7)?


                   No            Go to DEMPRE-Q10B
                   Otherwise     Go to DEMPRE-N11A


DEMPRE-Q10B        Interviewer: Date of first marriage [answer in
                   DEMPRE-Q10] should be before date widowed [answer
                   in DEMPRE-Q7]. If information is incorrect go to
                   previous questions to correct inconsistencies. Otherwise
                   press <Enter> to continue.


* DEMPRE-N11A Internal logic: Respondent is female 18 years of age and
                   over?


                   Yes           Go to DEMPRE-Q11
                   Otherwise     Go to DEMPRE-Q16.
                             - 33 -

DEMPRE-Q11   HAS [respondent] HAD ANY CHILDREN?


             Yes             Go to DEMPRE-Q12
             No              Go to DEMPRE-Q14
             DK/R            Go to DEMPRE-Q16


DEMPRE-Q12   HOW MANY CHILDREN WERE EVER BORN TO
             [respondent]?
             Interviewer: Enter 00 if none


             Hard range:
                    Maximum: 20
                    Minimum: 0


             If 0/DK/R go to DEMPRE-Q14, otherwise go to
             DEMPRE-Q13.


DEMPRE-Q13   IN WHAT YEAR DID [respondent] GIVE BIRTH TO
             HER FIRST CHILD?


             Hard range:
                    Maximum: [current year]
                    Minimum: [current year] minus [age] minus 14


DEMPRE-Q14   (Other than children [respondent] has given birth to)
             HAS [respondent] ADOPTED OR RAISED ANY
             CHILDREN?

             Yes             Go to INPATH-Q12
             No/DK/R         Go to DEMPRE-Q16
                               - 34 -

* INPATH-Q12   Internal logic: DEMPRE-Q11=yes and DEMPRE-
               Q14=no and DEMPRE-Q12 = 0?


               Yes            Go to DEMPRE-Q14A
               Otherwise      Go to DEMPRE-Q15


DEMPRE-Q14A    Interviewer: In previous questions (DEMPRE-Q11 and
               Q12) respondent stated that she had children, but none
               were born to her, therefore she should have raised or
               adopted children (DEMPRE-Q14). If incorrect go to
               previous questions to correct inconsistencies. Otherwise
               press <Enter> to continue.


DEMPRE-Q15     HOW MANY (other) CHILDREN HAS [respondent]
               ADOPTED OR RAISED?


               Hard range:
                         Maximum: 20
                         Minimum: 1


DEMPRE-Q16     WHAT IS THE LANGUAGE THAT [respondent]
               FIRST LEARNED AT HOME IN CHILDHOOD AND
               STILL UNDERSTANDS?


               English
               French
               Other (SPECIFY)
                                - 35 -

DEMPRE-Q17    IN WHAT COUNTRY WAS [respondent] BORN?


              Canada
              United Kingdom
              Italy
              U.S.A.
              Germany
              Poland
              Other (SPECIFY)


              If answered "Canada" go to DEMPRE-Q19. Otherwise, go
              to DEMPRE-Q18.


DEMPRE-Q18    DID [respondent] IMMIGRATE TO CANADA?


              Yes                           Go to DEMPRE-Q18B
              No(never immigrated - Canadian
                       citizen by birth)    Go to DEMPRE-Q19
              DK/R                          Go to DEMPRE-Q19


DEMPRE-Q18B   IN WHAT YEAR WAS THAT?


              Hard range:
                       Maximum: [current year]
                       Minimum: [current year] minus [age]
                               - 36 -

DEMPRE-Q19   IS [respondent] A REGISTERED INDIAN AS
             DEFINED BY THE INDIAN ACT OF CANADA?


             Yes, Registered Indian
             No/DK/R


DEMPRE-Q20   CANADIANS COME FROM MANY ETHNIC,
             CULTURAL AND RACIAL BACKGROUNDS. FOR
             EXAMPLE, ENGLISH, FRENCH, NORTH
             AMERICAN INDIAN, CHINESE, BLACK, FILIPINO
             OR LEBANESE. WHAT IS [respondent]'S
             BACKGROUND?
             Interviewer: if indian, probe for North American or
             East.
             Mark all that apply.


             English                    Dutch(netherlands)
             French                     Jewish
             German                     Polish
             Scottish                   Black
             Italian                    Métis
             Irish                      Inuit/eskimo
             Ukrainian                  North american indian
             Chinese                    East indian
             Canadian(probe for any other background)
             Other (specify)


             If answered "Other" go to DEMPRE-Q20A, otherwise go
             to EDUPRE-Q1.
                                    - 37 -

DEMPRE-Q20A          Interviewer: Enter other ethnic background not
                     already given in previous question.


                     Go to EDUPRE-Q1


6.     EDUPRE MODULE


HEADER: Two headers are displayed for different questions:
       !      Type of school response from EDUPRE-Q6 is displayed for
              EDUPRE-Q7 to EDUPRE-Q10
       !      Highest degree response from EDUPRE-Q14A is displayed for
              EDUPRE-Q16


EDUPRE-Q1 HOW MANY YEARS OF ELEMENTARY AND HIGH
              SCHOOL DID [respondent] COMPLETE?


                     Hard range:
                            Maximum: 15
                            Minimum: 0


* VERIFY-Q1          Internal logic: Years of schooling (EDUPRE-Q1) is
                     greater than [age] minus 5?


                     No                      Go to EDUPRE-Q1A
                     Otherwise: If answered "0" go to EDUPRE-Q17,
                     otherwise go to EDUPRE-Q2.


EDUPRE-Q1A           Interviewer: Years of education does not correspond
                     with [respondent]'s age. Verify that this information is
                                - 38 -

               correct. If incorrect go back to previous question
               (EDUPRE-Q1) and make the necessary changes.
               Otherwise press <Enter> to continue.


EDUPRE-Q2      IN WHICH PROVINCE OR TERRITORY DID
               [respondent] GET MOST OF HIS/HER
               ELEMENTARY AND HIGH SCHOOL EDUCATION?


               Newfoundland                       Manitoba
               Prince Edward Island               Saskatchewan
               Nova Scotia                        Alberta
               New Brunswick                      British Columbia
               Quebec                             Yukon
               Ontario                            Northwest Territories
               Outside Canada


* EVAL-Q1      Internal logic: EDUPRE-Q1 = 1 to 9?


               Yes            Go to EDUPRE-Q4
               Otherwise      Go to EDUPRE-Q3.


EDUPRE-Q3 DID [respondent] COMPLETE HIGH SCHOOL?


               Yes
               No


EDUPRE-Q4      EXCLUDING UNIVERSITY, HAS [respondent]
               EVER BEEN ENROLLED IN ANY OTHER KIND OF
               SCHOOL, FOR EXAMPLE, A COMMUNITY
                          - 39 -

            COLLEGE, BUSINESS SCHOOL, TRADE OR
            VOCATIONAL SCHOOL, OR CÉ GEP?


            Yes/DK/R                 Go to EDUPRE-Q5
            No                       Go to EDUPRE-Q12


EDUPRE-Q5   HAS [respondent] RECEIVED ANY CERTIFICATES
            OR DIPLOMAS AS A RESULT OF THIS
            EDUCATION?


            Yes/DK/R                 Go to EDUPRE-Q6
            No                       Go to EDUPRE-Q11


EDUPRE-Q6   THINKING OF THE MOST RECENT CERTIFICATE
            OR DIPLOMA (EXCLUDING UNIVERSITY) COULD
            YOU TELL ME WHAT TYPE OF SCHOOL OR
            COLLEGE [respondent] ATTENDED? WAS IT A . . .


            COMMUNITY COLLEGE OR INSTITUTE OF APPLIED
            ARTS AND TECHNOLOGY?
            BUSINESS OR COMMERCIAL SCHOOL?
            TRADE OR VOCATIONAL SCHOOL?
            CÉ GEP?
            SOME OTHER TYPE (Specify)


EDUPRE-Q7   HOW LONG DID IT TAKE [respondent] TO
            COMPLETE THIS PROGRAM?


            Answer given in months        Go to EDUPRE-Q7A
                            - 40 -

             Answer given in years              Go to EDUPRE-Q7B
             DK/R                               Go to EDUPRE-Q8


EDUPRE-Q7A   Interviewer: Enter # of months it took [respondent] to
             complete this program.


             Hard range:
                    Maximum: 99
                    Minimum: 1


             Go to EDUPRE-Q8


EDUPRE-Q7B   Interviewer: Enter # of years it took [respondent] to
             complete this program.


             Hard range:
                    Maximum: 9
                    Minimum: 1


             Go to EDUPRE-Q8


EDUPRE-Q8    WAS THIS FULL-TIME, PART-TIME OR SOME OF
             EACH?


             Full-time
             Part-time
             Some of each
                             - 41 -

EDUPRE-Q9     IN WHAT YEAR DID [respondent] RECEIVE
              HIS/HER CERTIFICATE OR DIPLOMA?


              Hard range:
                     Maximum: [current year]
                     Minimum: [current year] minus [age] minus 14


* VERIFY-Q9   Internal logic: Year received diploma is between
              current year minus age minus 14 and current year
              minus age minus 20?


              Yes            Go to EDUPRE-Q9A
              Otherwise      Go to EDUPRE-Q10


EDUPRE-Q9A    Interviewer: Year respondent received certificate or
              diploma indicates he/she was [age - current year -
              EDUPRE-Q9] years old when they graduated. If year
              received certificate/diploma [answer in EDUPRE-Q9] is
              incorrect, go back to previous question (EDUPRE-Q9)
              and make necessary changes. Otherwise press <Enter>
              to continue.


EDUPRE-Q10    WHAT WAS THE MAJOR SUBJECT OR FIELD OF
              STUDY?
                              - 42 -

EDUPRE-Q11     IN TOTAL, HOW MANY YEARS OF SCHOOLING
               DID [respondent] COMPLETE AT A COMMUNITY
               COLLEGE, TECHNICAL INSTITUTE, TRADE OR
               VOCATIONAL SCHOOL, OR CÉ GEP?
               Interviewer: Enter 00 if less than one year


               Hard range:
                      Maximum: 20
                      Minimum: 0


* VERIFY-Q11   Internal logic: Years of schooling (EDUPRE-Q11) is
               greater than [age] minus 14?


               Yes           Go to EDUPRE-Q11A
               Otherwise     Go to EDUPRE-Q12


EDUPRE-Q11A    Interviewer: Years of schooling completed in a
               community college etc. [EDUPRE-Q11] does not
               correspond to [respondent]'s age [age]. Verify that this
               is correct. If incorrect, go back to previous question
               (EDUPRE-Q11) and make necessary changes.
               Otherwise press <Enter> to continue.


EDUPRE-Q12     HAS [respondent] EVER BEEN ENROLLED IN A
               UNIVERSITY?


               Yes/DK/R                Go to EDUPRE-Q13
               No                      Go to EDUPRE-Q17
                              - 43 -

EDUPRE-Q13     HOW MANY YEARS OF UNIVERSITY HAS
               [respondent] COMPLETED?
               Interviewer: Enter 00 if attended university but didn't
               complete the year.


               Hard range:
                      Maximum: 20
                      Minimum: 0


* VERIFY-Q13   Internal logic: Years of university is greater than [age]
               minus 14?


               Yes           Go to EDUPRE-Q13A
               Otherwise     Go to EDUPRE-Q14


EDUPRE-Q13A    Interviewer: Years of university [EDUPRE-Q13] does
               not correspond to [respondent]'s age [age]. Verify that
               this is correct. If incorrect, go back to previous
               question (EDUPRE-Q13) and make necessary changes.
               Otherwise press <Enter> to continue.


EDUPRE-Q14     WHAT DEGREES, CERTIFICATES OR DIPLOMAS
               HAS [respondent] RECEIVED FROM A
               UNIVERSITY?


               None                    Go to EDUPRE-Q17
               Specify Degrees         Go to EDUPRE-Q14A
               DK/R                    Go to EDUPRE-Q15
                              - 44 -

EDUPRE-Q14A   Interviewer: Specify degrees, certificates or diplomas
              [respondent] has received from a university.
              Mark all that apply.


              University certificate/diploma below Bachelor level
              Bachelor's degree(s)
              University certificate/diploma above Bachelor level
              Master's degree(s)
              Degree in medicine, dentistry,veterinary medicine or
              optometry
              Doctorate (PhD)


EDUPRE-Q15    WHAT YEAR DID [respondent] RECEIVE HIS/HER
              [highest response category given in EDUPRE-Q14A]?


              Hard range: Maximum: [current year]
                             Minimum: [current year] minus [age] minus
                             18


EDUPRE-Q16    WHAT WAS THE MAJOR FIELD OF STUDY?


EDUPRE-Q17    WHAT WAS THE HIGHEST LEVEL OF
              EDUCATION COMPLETED BY [respondent]'S
              MOTHER? WAS IT ...


              ELEMENTARY SCHOOL (includes no schooling)?
              SOME HIGH SCHOOL?
              COMPLETED HIGH SCHOOL?
              TRADE/VOCATIONAL SCHOOL?
                                 - 45 -

             POST-SECONDARY CERTIFICATE OR DIPLOMA?
             (e.g., community college, Cégep, teachers' college, school
             of nursing, etc.)
             UNIVERSITY DEGREE?


EDUPRE-Q18   WHAT WAS THE HIGHEST LEVEL OF
             EDUCATION COMPLETED BY [respondent]'S
             FATHER? WAS IT ...


             ELEMENTARY SCHOOL (includes no schooling)?
             SOME HIGH SCHOOL?
             COMPLETED HIGH SCHOOL?
             TRADE/VOCATIONAL SCHOOL?
             POST-SECONDARY CERTIFICATE OR DIPLOMA?
             (e.g., community college, Cégep, teachers' college, school
             of nursing, etc.)
             UNIVERSITY DEGREE?
- 46 -
   - 47 -




APPENDIX 1




FLOWCHARTS
