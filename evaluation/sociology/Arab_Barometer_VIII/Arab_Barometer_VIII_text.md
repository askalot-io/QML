# Arab_Barometer_VIII

- **source**: Arab_Barometer_VIII.pdf
- **model**: us.anthropic.claude-sonnet-4-6
- **dpi**: 150
- **pages**: 93

--- page 1 ---

Arab Barometer Wave VIII

Questionnaire

2023-2024

--- page 2 ---

Arab Barometer Wave VIII Source Questionnaire

September 2024


TABLE OF CONTENTS

 SAMPLING VARIABLES                                        4
  SECTION I        CORE DEMOGRAPHICS                       5
  SECTION II       STATE OF THE ECONOMY                    6
  SECTION III      TRUST & GOVERNMENT PERFORMANCE         11
  SECTION IV       ENGAGEMENT & GOVERNANCE PREFERENCES    17
  SECTION V        MIGRATION & IMMIGRATION                27
  SECTION VI       IDENTITY & RELIGIOUS PRACTICE          31
  SECTION VII      CLIMATE CHANGE & THE ENVIRONMENT       41
  SECTION VIII     GENDER NORMS & ATTITUDES               45
  SECTION IX       MEDIA                                  51
  SECTION X        INTERNATIONAL RELATIONS                54
  SECTION XI       COUNTRY-SPECIFIC QUESTIONS             65
  SECTION XII      DEMOGRAPHICS                           78
  APPENDIX 1       Q1 GOVERNORATE CODES AND NAMES         85
  APPENDIX 2       Q503A_1 POLITICAL PARTY LISTS          86

--- page 3 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**PROGRAMMER ASSIGN RESPONDENT TO COUNTRY ==**

**7 IF IRAQ
8 IF JORDAN
9 IF KUWAIT
10 IF LEBANON
12 IF MAURITANIA
13 IF MOROCCO
15 IF PALESTINE
21 IF TUNISIA**


**PROGRAMMER: RANDOMLY ASSIGN RESPONDENTS TO SPLIT A OR SPLIT B
 AND
PROGRAMMER: RANDOMLY ASSIGN RESPONDENTS TO SPLIT C OR SPLIT D**

www.arabbarometer.org

--- page 4 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**Arab Barometer Wave VIII**

Good morning/afternoon/evening,

My name is [INSERT FULL NAME] from [INSERT FIELD ORGANIZATION'S NAME].
We are conducting a survey on the opinions of citizens in [YOUR COUNTRY] on a
variety of important social and economic issues. The survey is conducted on behalf
of the Arab Barometer, a joint, academically driven initiative by universities across
the Arab world and the United States. You have been randomly selected to
participate, and your participation is of great importance for the success of this
project.

The survey interview takes approximately 45 minutes. Your answers will be
completely anonymous and will be kept absolutely confidential. The survey does not
involve any risks to you personally or to [your country]. All information collected in
this survey will be used for scientific research purposes.

Your participation is entirely voluntary. If at some point you are not comfortable with
the interview, or with the way it's going, you can ask us to stop the interview. If there
are any questions you are not comfortable with, you do not have to answer them.

The study team has taken all CDC-suggested safety measures to minimize exposure
to SARS-CoV-2 (the cause of COVID-19)

Do you have any questions for us?

[**NOTE TO INTERVIEWER:** If yes, answer the questions. If not, continue.]

Well, if any questions come up, please let us know during the interview or
afterwards.

3

www.arabbarometer.org

--- page 5 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**SAMPLING VARIABLES**

**ID**
Respondent ID number

**DATE**
YYYY-MM-DD

**PSU**
Enter PSU
**N_____[MIN 1, MAX 350]**

**Q1.** Governorate [1st Administrative Division]
        1. List varies by country

**Q1A_PAL [PROGRAMMER: COUNTRY==15]** Area
   1.   West Bank
   2.   Gaza

**Q13** Urban/Rural
**[PROGRAMMER: COUNTRY != 9]**
   1.   Urban
   2.   Rural
   3.   Camp  **[PROGRAMMER: COUNTRY == 8, 15]**

--- page 6 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**SECTION I: CORE DEMOGRAPHICS**

**Q1001** How old are you?  **[PROGRAMMER: MIN==18, MAX==120]**

________________
99999. Refused to answer [INTERVIEWER: DO NOT READ]

**Q1001YEAR [PROGRAMMER: IF Q1001==9999]** What year were you born?

________________
99999. Refused to answer [INTERVIEWER: DO NOT READ]

**Q1001APPROX [PROGRAMMER: Q1001YEAR == 99999; MIN==18, MAX==120]** Could you please tell me your approximate age?

________________
99999. Refused to answer [INTERVIEWER: DO NOT READ]

**Q1002** Gender [INTERVIEWER: DO NOT ASK, RECORD]

1.          Male
2.          Female

**Q1014C  [PROGRAMMER: ALLOW INTEGER VALUES ONLY]** Including yourself, what is the total number of family members who live in this household on a permanent basis?  [**INTERVIEWER:** If asked, this count excludes domestic workers or visiting family members]

___ number of people
   99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q1014D  [PROGRAMMER: ALLOW INTEGER VALUES ONLY. MAX = ANSWER TO Q1014C]** Of the total number of people who live in this household, how many are age **18 and over**?

___ number of **adults**
   99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q1014E  [PROGRAMMER: ALLOW INTEGER VALUES ONLY. MAX = ANSWER TO Q1014C]** Of the total number of people who live in this household, how many are **under the age of 18**?

___ number of **children**
   99. Refused to answer [INTERVIEWER: DO NOT READ]

5

www.arabbarometer.org

--- page 7 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**SECTION II: STATE OF THE ECONOMY**

**Q2061A**
**[PROGRAMMER: COUNTRY!=9]**
What is the most important challenge facing **[YOUR COUNTRY]** today?
**[INTERVIEWER:** Read responses]
**[PROGRAMMER: RANDOMIZE ITEMS]**
        1. Economic situation [INTERVIEWER: IF ASKED, POVERTY, UNEMPLOYMENT,
        INFLATION]
        2. Financial and administrative corruption
        6. Internal instability and security
        7. Foreign interference
        12. Public services [INTERVIEWER: IF ASKED, HEALTH, EDUCATION, ETC.]
        64. Terrorism
        65. Settler terrorism **[PROGRAMMER: COUNTRY==15]**
        17. Climate change
        18.  Immigration to [YOUR COUNTRY]
90. Other- specify: [INTERVIEWER: DO NOT READ]
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q2061A_KUW**
**[PROGRAMMER: COUNTRY==9]**
What is the most important challenge facing **KUWAIT** today?
**[INTERVIEWER:** Read responses]
**[PROGRAMMER: RANDOMIZE ITEMS]**
        1. Economic situation [INTERVIEWER: IF ASKED, POVERTY, UNEMPLOYMENT,
        INFLATION]
        2. Financial and administrative corruption
        8. Granting of citizenship
        9. Foreign investment
        10. Laws and legislations
        12. Public services [INTERVIEWER: IF ASKED, HEALTH, EDUCATION, ETC.]
        17. Climate change
        18. Immigration to [YOUR COUNTRY]
90. Other- specify: [INTERVIEWER: DO NOT READ]
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

--- page 8 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**Q262** Which of the following economic issues do you think is the most serious one facing [YOUR COUNTRY]?
**[INTERVIEWER:** Read responses]
**[PROGRAMMER: RANDOMIZE ITEMS]**
   1.  Low wages, incomes, and salaries
   2.  Lack of jobs
   3.  Lack of affordable housing
   4.  Not having enough money to meet basic needs (poverty)
   5.  Prices and the cost of living are too high (inflation)
   6.  The gap between the rich and the poor (inequality)
   7.  Access to loans and credit
90. Other- specify: [INTERVIEWER: DO NOT READ]
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q101** How would you evaluate the current economic situation in [your country]?
   1.  Very good
   2.  Good
   3.  Bad
   4.  Very bad
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q102** In your opinion, what will be the economic situation in [your country] during the next few years (2-3 years) compared to the current situation?
   1.  Much better
   2.  Somewhat better
   3.  Almost the same
   4.  Somewhat worse
   5.  Much worse
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q114** Do you think the gap between the rich and the poor a year ago was wider, the same, or narrower than it is now?
   1.  Wider
   2.  Same
   3.  Narrower
97. The gap between the rich and the poor is not a problem [DO NOT READ]
98. Don't know [INTERVIEWER: DO NOT READ]
99. Decline to answer [INTERVIEWER: DO NOT READ]

--- page 9 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**Q127 [PROGRAMMER: COUNTRY !=9]** To what extent do you think each of the following currently is a problem in [your country]?
   1.  To a great extent
   2.  To a medium extent
   3.  To a small extent
   4.  Not a problem at all
98. Don't know [INTERVIEWER: DO NOT READ]
99. Decline to answer [INTERVIEWER: DO NOT READ]

      1A          Availability of food          1   2   3   4   98   99
   SPLIT A
      1B          Affordability of food         1   2   3   4   98   99
   SPLIT B
      2A          Availability of housing       1   2   3   4   98   99
   SPLIT A
      2B          Affordability of housing      1   2   3   4   98   99
   SPLIT B

**Q112** Please indicate whether the following statement was often, sometimes, or never true for you or your household over the past 30 days:
   1.  Often true
   2.  Sometimes true
   3.  Never true
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

   2    "The food that we bought did not last and we    1   2   3   98   99
        did not have money to get more"

**Q112B [PROGRAMMER: COUNTRY !=9]** Which of the following do you think is the biggest cause of food-related problems in [your country]? **[INTERVIEWER:** Read responses]
[PROGRAMMER: RANDOMIZE]
   1.  Climate change
   2.  War in Ukraine
   3.  Wealth gap between the rich and the poor
   4.  Inflation
   5.  Government mismanagement
   6.  Protracted conflict or violence **[PROGRAMMER: COUNTRY!=21]**
   7.  Externally imposed economic sanctions **[PROGRAMMER: COUNTRY!=21]**
90. Other- specify: [INTERVIEWER: DO NOT READ]
97. Food insecurity is not a problem in [my country] [INTERVIEWER: DO NOT READ]
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

8

www.arabbarometer.org

--- page 10 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**Q129A** In the past 7 days, how often did your household have to do any of the following?
   1.   Every day (7 days)
   2.   Most days (4-6 days)
   3.   Some days (1-3 days)
   4.   Never (0 days)
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]
**[PROGRAMMER: RANDOMIZE ITEMS]**

   1      Rely on less preferred and less           1   2   3   4   98   99
          expensive foods
   2      Limit portion size at mealtimes because   1   2   3   4   98   99
          of lack of money or availability of food

**Q130** Which, if any, of the following actions does your household take to purchase food?  [**PROGRAMMER & INTERVIEWER:** Select all that apply but 1 cannot be combined with any other option]
   1.   My household does not take any of these actions **[INTERVIEWER: DO NOT READ]**
   2.   Borrow money from family or friends to purchase food
   3.   Buy food on credit
   4.   Receive food donations or rely on support programs from the government
   5.   Receive food donations or rely on support programs from religious institutions or charitable organizations
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q118** In your opinion, which of the following are the first and second most important issues the government should be focusing on to improve the economic conditions in [your country]?
[**INTERVIEWER:** Please have respondents choose the two issues in order of importance] **[PROGRAMMER: Randomize. Please allow for two responses: Q118_1** FIRST MOST IMPORTANT ISSUE**, Q118_2** SECOND MOST IMPORTANT ISSUE**]**
   1.   Create more job opportunities
   2.   Raise wages for existing jobs
   3.   Lower the cost of living (limiting inflation)
   4.   Reform the education system
   5.   Encouraging foreign investment
   6.   Supporting small businesses or entrepreneurship
   7.   Limit smuggling
   8.   Political stability
90. Other- specify: [INTERVIEWER: DO NOT READ]
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

9

www.arabbarometer.org

--- page 11 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire


**Q123 [PROGRAMMER: SPLIT A . COUNTRY != 9]**
Among the following, which should be the top priority for government spending in the coming year? **[INTERVIEWER:** Read responses]
**[PROGRAMMER: RANDOMIZE]**
   1.  Education system
   2.  Healthcare system
   3.  Reduce environmental pollution
   4.  Improve roads and transportation
   5.  National security
   6.  Subsidies **[INTERVIEWER:** For example on bread, gas, oil, electricity etc.]
   7.  Fighting terrorism
90. Other- specify: [INTERVIEWER: DO NOT READ]
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q123B [PROGRAMMER: SPLIT B. COUNTRY != 9]**
Among the following, which should be the top priority for government spending in the coming year?
**[PROGRAMMER: RANDOMIZE]**
   1.  Education system
   2.  Healthcare system
   3.  Reduce environmental pollution
   4.  Improve roads and transportation
   5.  National security
   6.  Subsidies **[INTERVIEWER:** For example on bread, gas, oil, electricity etc.]
   7.  Fighting terrorism
   8.  Economic development
90. Other- specify: [INTERVIEWER: DO NOT READ]
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q123_KUW [PROGRAMMER: COUNTRY == 9]** Among the following, which should be the top priority for government spending in the coming year?
   1.  Education system
   2.  Healthcare system
   3.  Reduce environmental pollution
   4.  Improve roads and transportation
   5.  National security
   6.  Subsidies **[INTERVIEWER:** For example on bread, gas, oil, electricity etc.]
90. Other- specify: [INTERVIEWER: DO NOT READ]
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

--- page 12 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**SECTION III: TRUST & GOVERNMENT PERFORMANCE**

**Q103** Generally speaking, would you say that "Most people can be trusted" or "that you must be very careful in dealing with people"?
         1. Most people can be trusted
         2. One must be very careful in dealing with other people
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q201A [PROGRAMMER: COUNTRY != 9]**
I'm going to name a number of institutions. For each one, please tell me how much trust you have in them.
         1.  A great deal of trust
         2.  Quite a lot of trust
         3.  Not a lot of trust
         4.  No trust at all
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]
**[PROGRAMMER: RANDOMIZE ITEMS. SEE SPLITS & SPECIFIC NOTES]**

 1       Government (Council of Ministers)                                    1   2   3   4   98   99
 **2**       Courts and legal system                                              1   2   3   4   98   99
 **3**       **[PROGRAMMER: COUNTRY!= 15]**
            The elected council of representatives (the parliament).             1   2   3   4   98   99
 **5**       **[PROGRAMMER: COUNTRY!= 8]**
            Local government
            [**PROGRAMMER:**
            **IF COUNTRY==10 OR 13** Municipalities]                             1   2   3   4   98   99
 **41**      **[PROGRAMMER: COUNTRY!= 8, 10, 15 OR 21**
            Regional government ]
            [**PROGRAMMER: IF COUNTRY==13**,
            Prefecture/Regional councils]                                        1   2   3   4   98   99
 **41_WB**   **[PROGRAMMER: IF COUNTRY==15 &**
            Q1==150001, 150004, 150006, 150007, 150008,
            150010, 150011, 150013, 150014, 150015, 150016]
            Government in the West Bank                                          1   2   3   4   98   99
 **41_Gaza** **[PROGRAMMER: IF COUNTRY==15 &**
            Q1==150002, 150003, 150005, 150009, 150012]
            Hamas Authority                                                      1   2   3   4   98   99
 **7**       Civil society organizations                                         1   2   3   4   98   99
 **31B**     **[PROGRAMMER: COUNTRY== 7, 12, 15, 21]**
            President/Head of State                                              1   2   3   4   98   99
 **31C**     **[PROGRAMMER: COUNTRY==7, 8, 9, 10,12,13]**
            Prime Minister /Head of Government                                   1   2   3   4   98   99

11

www.arabbarometer.org

--- page 13 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**Q201B [PROGRAMMER: COUNTRY != 9]** And how much trust do you have in…
   1. A great deal of trust
   2. Quite a lot of trust
   3. Not a lot of trust
   4. No trust at all
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]
**[PROGRAMMER: RANDOMIZE ITEMS. SEE SPLITS & SPECIFIC NOTES]**

 6    The armed forces (the army)                          1   2   3   4   98   99
      [PROGRAMMER: IF COUNTRY==15]
      National Security Forces
 4    Police                                               1   2   3   4   98   99
13    Religious leaders                                    1   2   3   4   98   99
      [PROGRAMMER:
      IF COUNTRY==7, "Iraqi Islamic Party"
      IF COUNTRY==8, "Muslim Brotherhood"
      IF COUNTRY==10, "Muslim
12    Brotherhood/Islamic Group"                           1   2   3   4   98   99
      IF COUNTRY==12, Tewassoul
      IF COUNTRY==13, Justice and
      Development Party (PJD)
      IF COUNTRY==15, Hamas
      IF COUNTRY==21, Ennahda]
      [PROGRAMMER: COUNTRY== 7, 10;
14    IF COUNTRY==7, "Sadrist Movement/                    1   2   3   4   98   99
      Shiite Nationalist Movement"
      IF COUNTRY==10, "Hezbollah"]
15    [PROGRAMMER COUNTRY==7, 8 ]                          1   2   3   4   98   99
      Tribal leaders

**Q105A** How would you rate the safety of your neighborhood?
   1. Very safe
   2. Somewhat safe
   3. Somewhat unsafe
   4. Very unsafe
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refuse to answer [INTERVIEWER: DO NOT READ]

--- page 14 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**Q277** Do the following happen frequently, sometimes, rarely, or never in your neighborhood?
        1.   Frequently
        2.   Sometimes
        3.   Rarely
        4.   Never
98.Don't know [INTERVIEWER: DO NOT READ]
99.Refused to answer [INTERVIEWER: DO NOT READ]
**[PROGRAMMER: RANDOMIZE]**
   **1**      Robberies                        1   2   3   4   98   99
   **2**      Street violence and fights       1   2   3   4   98   99

**Q204A** How satisfied are you with the following?
   1.   Completely satisfied
   2.   Satisfied
   3.   Dissatisfied
   4.   Completely dissatisfied
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]
**[PROGRAMMER: RANDOMIZE ITEMS BUT ALWAYS KEEP ITEM 3 FIRST]**
   **3**      The government's performance overall in our country          1   2   3   4   98   99
   **1**      The educational system in our country                        1   2   3   4   98   99
   **2**      The healthcare system in our country                         1   2   3   4   98   99
   **4**      The quality of the streets in our country                    1   2   3   4   98   99
   **5**      Trash collection in our country                              1   2   3   4   98   99
   **6**      Provision of electricity in [your country]                   1   2   3   4   98   99
   **7**      Water supply in [your country]                               1   2   3   4   98   99
   **8**      Access to internet services in [your country]                1   2   3   4   98   99
   **9**      Civil defense in [your country]                              1   2   3   4   98   99
   **10**     **[PROGRAMMER: COUNTRY ==9]** Housing policy in Kuwait       1   2   3   4   98   99

--- page 15 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**Q204** I am going to ask a number of questions related to the current government's performance in specific areas. How would you evaluate the current government's performance on:
        1. Very good
        2.  Good
        3.  Bad
        4.  Very bad
97. This is not the government's responsibility [INTERVIEWER: DO NOT READ]
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]
**[PROGRAMMER: RANDOMIZE ITEMS]**
   2      Creating employment opportunities              1  2  3  4  97  98  99
   3      Narrowing the gap between rich and poor        1  2  3  4  97  98  99
  11      [PROGRAMMER: COUNTRY!=9]                       1  2  3  4  97  98  99
           Providing security and order
  20      Keeping prices down                            1  2  3  4  97  98  99

**Q273C [PROGRAMMER: SPLIT A.]**  Which of the following actions would you think is most effective to influence a national government decision?
**[PROGRAMMER: RANDOMIZE]**
   1.   Contacting government officials on social media
   2.   Work through connections [wasta] with government officials
   3.   Contact members of the radio, TV, or print media
   4.   Get people interested in the problem and form a group
   5.   Work through a political party
   6.   Participate in an in-person protest, demonstration, strike, or boycott
   7.   Start or engage with a social media campaign
97. Not applicable - nothing is effective [INTERVIEWER: DO NOT READ]
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q273D [PROGRAMMER: SPLIT B.]**  Which of the following actions would you think is least effective to influence a national government decision?
**[PROGRAMMER: RANDOMIZE]**
   1.   Contacting government officials on social media
   2.   Work through connections [wasta] with government officials
   3.   Contact members of the radio, TV, or print media
   4.   Get people interested in the problem and form a group
   5.   Work through a political party
   6.   Participate in an in-person protest, demonstration, strike, or boycott
   7.   Start or engage with a social media campaign
97. Not applicable – nothing is effective [INTERVIEWER: DO NOT READ]
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

14

www.arabbarometer.org

--- page 16 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**Q273C_KUW [PROGRAMMER: SPLIT A. COUNTRY==9]** Which of the following actions would you think is most effective to influence a national government decision? **[PROGRAMMER: RANDOMIZE]**
   1.   Contacting government officials on social media
   2.   Work through connections [wasta] with government officials
   3.   Contact members of the radio, TV, or print media
   4.   Get people interested in the problem and form a group
   5.   Work through a political movement
7.   Start or engage with a social media campaign
8.   Working through the National Assembly
97. Not applicable - nothing is effective [INTERVIEWER: DO NOT READ]
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q273D_KUW [PROGRAMMER: SPLIT B. COUNTRY==9]** Which of the following actions would you think is least effective to influence a national government decision?**[PROGRAMMER: RANDOMIZE]**
   1.   Contacting government officials on social media
   2.   Work through connections [wasta] with government officials
   3.   Contact members of the radio, TV, or print media
   4.   Get people interested in the problem and form a group
   5.   Work through a political movement
7.   Start or engage with a social media campaign
8.   Working through the National Assembly
97. Not applicable – nothing is effective [INTERVIEWER: DO NOT READ]
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q210** To what extent do you think that there is corruption within the national state agencies and institutions in [your country]?
   1.   To a large extent
   2.   To a medium extent
   3.   To a small extent
   4.   Not at all
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q211_2 [PROGRAMMER: IF Q210 == 1, 2 OR 3]** In your opinion, to what extent is the national government working to crackdown on corruption in [YOUR COUNTRY]?
   1.   To a large extent
   2.   To a medium extent
   3.   To a small extent
   4.   Not at all
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

--- page 17 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**Q211B [SPLIT A. PROGRAMMER: COUNTRY != 9]**
How widespread do you think corruption is in local government/your
municipality/your local council? Would you say …?
   1.   Hardly anyone is involved
   2.   Not a lot of officials are corrupt
   3.   Most officials are corrupt
   4.   Almost everyone is corrupt
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q211C [SPLIT B. PROGRAMMER: COUNTRY != 9]**
To what extent do you think that there is corruption within the local/municipal
agencies and institutions in [your country]?
   1.   To a large extent
   2.   To a medium extent
   3.   To a small extent
   4.   Not at all
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q270 [PROGRAMMER: SPLIT A]** How often do you think it is necessary for citizens in
[your country] to use **wasta/piston** to:
   1.   Frequently
   2.   Sometimes
   3.   Rarely
   4.   Never
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]
**[PROGRAMMER: RANDOMIZE ITEMS]**
   1        Get a job                                    1   2   3   4   98   99
   2        Get legal documents from public institutions 1   2   3   4   98   99

**Q271 [PROGRAMMER: SPLIT B]** How often do you think it is necessary for citizens in
[your country] to use **rashwa** to:
   1.   Frequently
   2.   Sometimes
   3.   Rarely
   4.   Never
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]
**[PROGRAMMER: RANDOMIZE ITEMS]**
   1        Get a job                                    1   2   3   4   98   99
   2        Get legal documents from public institutions 1   2   3   4   98   99

16

www.arabbarometer.org

--- page 18 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**Q276** How well do you think the government responds to what people want?
   1.   Very responsive
   2.   Largely responsive
   3.   Not very responsive
   4.   Not responsive at all
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

--- page 19 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**SECTION IV:  ENGAGEMENT & GOVERNANCE PREFERENCES**

**Q404** In general, to what extent are you interested in politics?
   1.  Very interested
   2.  Interested
   3.  Uninterested
   4.  Very uninterested
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q501D** In a typical month, do you volunteer your time to do unpaid work for or
support a cause that you care about?
   1.  Yes
   2.  No
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q501E** [**PROGRAMMER: IF Q501D==1**] In a few words can you describe this cause?
**[INTERVIEWERS:** *Do not read. Please write the respondent's answer verbatim in
Modern Standard Arabic and then select the category that best describes the cause
from the following list*.] **[PROGRAMMER: Please allow for two answers. Q501E_1**
OPEN RESPONSE **+ Q501E_2** POST CODE**]**
   1.  Art, music, drama
   2.  Building and construction
   3.  Charity
   4.  Children and youth
   5.  Economic development
   6.  Education
   7.  Environment
   8.  Health
   9.  Political development
   10. Religious activity
   11. Sports
   12. Women's empowerment
90. Other- specify: [INTERVIEWER: DO NOT READ]
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q266** In a typical month, do you donate money to a charity or those in need?
   1.  Yes
   2.  No
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

18

www.arabbarometer.org

--- page 20 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**Q552** In the past year, did you do any of the following?
         1.    Yes
         2.    No
98.Don't know [INTERVIEWER: DO NOT READ]
99.Refused to answer [INTERVIEWER: DO NOT READ]
**[PROGRAMMER: RANDOMIZE]**

   1A          Made a political statement through art, writing, or    1   2   98   99
   SPLIT A     music
   1B          Participated in an in-person protest,                  1   2   98   99
   SPLIT B     demonstration, strike, or boycott
   2A          Contacted government officials or institutions via     1   2   98   99
   SPLIT A     social media
   2B          Contacted government officials or institutions         1   2   98   99
   SPLIT B     using wasta
   3A          Boycotted a brand                                      1   2   98   99
   SPLIT A
   3B          Signed a petition asking for action from the          1   2   98   99
   SPLIT B     government

**Q521** To what extent do you think that the following is guaranteed in [your country]?
      1.    Guaranteed to a great extent
      2.    Guaranteed to a medium extent
      3.    Guaranteed to a limited extent
      4.    Not guaranteed at all
98. Don't know [INTERVIEWER: DO NOT READ]
99. Decline to answer [INTERVIEWER: DO NOT READ]
**[PROGRAMMER: RANDOMIZE ITEMS AND SEE SPLITS]**

   1           Freedom to express opinions.                          1   2   3   4   98   99
   4           [PROGRAMMER: COUNTRY!=9]                              1   2   3   4   98   99
               Freedom to participate in peaceful
               protests and demonstrations.
   2A          Freedom of the media to criticize the                 1   2   3   4   98   99
   SPLIT A     things government does.
   2B          Freedom of the press                                  1   2   3   4   98   99
   SPLIT B
   6           [PROGRAMMER: COUNTRY!=9]                              1   2   3   4   98   99
               Freedom of religion

--- page 21 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**Q514A** There is talk about political reform in [our country]. Do you think we should introduce reforms little by little, all at once, or should there be no reforms at all?
   1.   Little by little
   2.   All at once
   3.   No reforms at all
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q516A [PROGRAMMER: COUNTRY!=9]** Which of these three statements is closest to your own opinion:  **[INTERVIEWER:** READ RESPONSE OPTIONS AND ONLY CHOOSE ONE**]**
   1.   For people like me, it doesn't matter what kind of government we have
   2.   Under some circumstances, a non-democratic government can be preferable
   3.   Democracy is always preferable to any other kind of government
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q550A [PROGRAMMER: SPLIT A]** Many things may be desirable, but not all of them are essential pillars of human dignity. Please let me know if you believe each is a very essential, somewhat essential, not very essential or not at all essential pillar of **human dignity**.
      1. Very essential
      2. Somewhat essential
      3. Not very essential
      4. Not essential at all
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ
**[PROGRAMMER: RANDOMIZE]**
   1        Equality under the law                                                                          1   2   3   4   98   99
   2        There is no corruption                                                                          1   2   3   4   98   99
   3        Basic necessities, like clean food and water, clothes, and shelter, are available for all.      1   2   3   4   98   99
   4        Ability to freely choose political leaders in elections                                         1   2   3   4   98   99
   5        Feeling safe from physical danger                                                               1   2   3   4   98   99
   6        Basic civil rights are guaranteed [**INTERVIEWER:** If asked, examples include freedom of speech, freedom to protest, freedom of religion]      1   2   3   4   98   99

--- page 22 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**Q550B [PROGRAMMER: SPLIT B]** Many things may be desirable, but not all of them are essential pillars of democracy. Please let me know if you believe each is a very essential, somewhat essential, not very essential or not at all essential pillar of **democracy**.
        1. Very essential
        2. Somewhat essential
        3. Not very essential
        4. Not essential at all
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ
**[PROGRAMMER: RANDOMIZE]**
   **1**      Equality under the law                              1   2   3   4   98   99
   **2**      There is no corruption                             1   2   3   4   98   99
   **3**      Basic necessities, like clean food and water, clothes, and shelter, are available for all.     1   2   3   4   98   99
   **4**      Ability to freely choose political leaders in elections     1   2   3   4   98   99
   **5**      Feeling safe from physical danger                  1   2   3   4   98   99
   **6**      Basic civil rights are guaranteed [**INTERVIEWER:** If asked, examples include freedom of speech, freedom to protest, freedom of religion]     1   2   3   4   98   99

**Q551A [PROGRAMMER: SPLIT A]** Among the following, which is the main pillar of **human dignity? [PROGRAMMER: RANDOMIZE]**
   1.  Equality under the law
   2.  Absence of corruption
   3.  Basic necessities, like clean food and water, clothes, and shelter, are available for all.
   4.  Ability to freely choose political leaders in elections
   5.  Feeling safe from physical danger
   6.  Basic civil rights are guaranteed
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q551B [PROGRAMMER: SPLIT B]** Among the following, which is the main pillar of **democracy? [PROGRAMMER: RANDOMIZE]**
   1.  Equality under the law
   2.  Absence of corruption
   3.  Basic necessities, like clean food and water, clothes, and shelter, are available for all.
   4.  Ability to freely choose political leaders in elections
   5.  Feeling safe from physical danger
   6.  Basic civil rights are guaranteed
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ

21

www.arabbarometer.org

--- page 23 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**Q516 [PROGRAMMER: SPLIT A]** To what extent do you agree or disagree with the following statements? **[INTERVIEWER:** READ STATEMENTS**]**
         1. I strongly agree
         2. I agree
         3. I disagree
         4. I strongly disagree
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ
**[PROGRAMMER: RANDOMIZE ITEMS AND SEE SPLITS]**
     1          Under a democratic system, the country's          1   2   3   4   98   99
  **SPLIT A**   economic performance is weak.
     2          Democratic regimes are indecisive and             1   2   3   4   98   99
  **SPLIT A**   full of problems.
     3          Democratic systems are not effective at           1   2   3   4   98   99
  **SPLIT A**   maintaining order and stability.
     4          Democratic systems may have problems,             1   2   3   4   98   99
  **SPLIT A**   yet they are better than other systems.

**Q516B [PROGRAMMER: SPLIT B]** To what extent do you agree or disagree with the following statements? **[INTERVIEWER:** READ STATEMENTS**]**
         1. I strongly agree
         2. I agree
         3. I disagree
         4. I strongly disagree
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ
**[PROGRAMMER: RANDOMIZE ITEMS AND SEE SPLITS]**
     1          Under a non-democratic system, the                1   2   3   4   98   99
  **SPLIT A**   country's economic performance is weak.
     2          Non-democratic regimes are indecisive             1   2   3   4   98   99
  **SPLIT A**   and full of problems.
     3          Non-democratic systems are not effective          1   2   3   4   98   99
  **SPLIT A**   at maintaining order and stability.
     4          Non-democratic systems may have                   1   2   3   4   98   99
  **SPLIT A**   problems, yet they are better than other
               systems.

--- page 24 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**Q518** I will mention some of the political systems currently in place in various Middle Eastern and North African countries. I would like to know to what extent you think these systems would be appropriate for [your country].
   1.  Very suitable
   2.  Suitable
   3.  Somewhat suitable
   4.  Not suitable at all
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ

   1    A parliamentary system in which nationalist,
        left wing, right wing, and Islamist parties    1   2   3   4   98   99
        compete in parliamentary elections.
   3    A political system governed by a strong
        authority which makes decisions without
        considering electoral results or the opinions of    1   2   3   4   98   99
        the opposition.
   4    A system governed by Islamic law in which
        there are no political parties or elections.    1   2   3   4   98   99
   6    A government that provides for the needs of its
        citizens without giving them the right to    1   2   3   4   98   99
        participate in the political process


**INTERVIEWER:** Suppose there was a scale measuring the level of democracy
between 0 and 10, where 0 indicates no democracy whatsoever and 10 means that
the state is democratic to the greatest extent possible.
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ
**[PROGRAMMER: RANDOMIZE. KEEP Q511 LAST]**

   Q508    In your opinion, to what
           extent is the **United**
           **States of America** a    O   1   2   3   4   5   6   7   8   9   10   98   99
           democratic country?
   Q509    In your opinion, to what
           extent is **China** a    O   1   2   3   4   5   6   7   8   9   10   98   99
           democratic country?
   Q508B   In your opinion, to what
           extent is **Germany** a    O   1   2   3   4   5   6   7   8   9   10   98   99
           democratic country?
   Q511    In your opinion, to what
           extent is **[YOUR**
           **COUNTRY]** a    O   1   2   3   4   5   6   7   8   9   10   98   99
           democratic country?

23

www.arabbarometer.org

--- page 25 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**Q512** Suppose there was a scale from 0 to 10 measuring the extent to which democracy is suitable for [your country], with 0 meaning that democracy is absolutely inappropriate for [your country] and 10 meaning that democracy is completely appropriate for [your country]. To what extent do you think democracy is appropriate for [YOUR COUNTRY]?

0   1   2   3   4   5   6   7   8   9   10   98   99

**Q537A [PROGRAMMER: COUNTRY !=9]** How would you rate the state of democracy in [YOUR COUNTRY] now compared with before the Arab Spring protests of 2010-2011?
   1.   Much more democratic
   2.   Somewhat more democratic
   3.   The same as before
   4.   Somewhat less democratic
   5.   Much less democratic
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ

**Q533 [PROGRAMMER: COUNTRY != 8 OR 9]** There are many ways to govern a country. Would you disapprove or approve of the following alternatives? For each statement, would you say you strongly agree, somewhat agree, somewhat disagree, or strongly disagree?
   1.   Strongly agree
   2.   Somewhat agree
   3.   Somewhat disagree
   4.   Strongly disagree
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]
**[PROGRAMMER: RANDOMIZE ITEMS]**
4   This country needs a leader who can bend the rules if necessary to get things done.   1   2   3   4   98   99

**Q301A [PROGRAMMER: COUNTRY!= 15]** Did you vote in the last parliamentary elections that were held on **[INSERT DATE OF LAST PARLIAMENTARY ELECTION*]**
**[*PROGRAMMER:**
**IF COUNTRY==7,** 10 October 2021
**IF COUNTRY==8,** 10 November 2020
**IF COUNTRY==9,** 5 December 2020
**IF COUNTRY==10,** 15 May 2022
**IF COUNTRY==12,** 15 September 2018
**IF COUNTRY==13,** 8 September 2021
**IF COUNTRY==21,** 17 December 2022**]**
   1.   Yes
   2.   No
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

24

www.arabbarometer.org

--- page 26 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**Q301B [PROGRAMMER: COUNTRY == 7 AND 12]** Do you intend to vote in the parliamentary elections that will be held on _______________
**[PROGRAMMER:
IF COUNTRY==7, October 2025
IF COUNTRY==12, 22 June 2024]**
   1. Yes
   2. No
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q303A [PROGRAMMER: COUNTRY != 9 OR 15]** In general, how would you evaluate the last parliamentary elections? Was it… [**INTERVIEWER:** IF ASKED, THE LAST PARLIAMENTARY ELECTION HELD ON [INSERT DATE]]
   1. Free and fair
   2. Free and fair with minor problems
   3. Not free or fair
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q303B [PROGRAMMER: IF COUNTRY== 7,8, 10,13, 21]** In your opinion, do the following occur during the elections in [YOUR COUNTRY] ?
   1. Frequently
   2. Sometimes
   3. Rarely
   4. Never
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

   **1**     Votes are counted fairly                          1   2   3   98   99
   **2**     Voters are bribed                                 1   2   3   98   99
   **3**     Voters are offered a genuine choice in elections  1   2   3   98   99

**Q301C [PROGRAMMER: COUNTRY==7, 12, AND 21]** Did you vote in the last local elections that were held on [INSERT DATE OF LAST LOCAL ELECTION]
   1. Yes
   2. No
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q503A_2 [PROGRAMMER:COUNTRY != 9]** Which party, if any, do you feel closest to?

0. No party [INTERVIEWER: DO NOT READ]
Party list [INTERVIEWER: DO NOT READ]

90. Other- specify: [INTERVIEWER: DO NOT READ]
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

25

www.arabbarometer.org

--- page 27 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**SECTION V: MIGRATION & IMMIGRATION**

**Q104** Some people decide to leave their countries to live somewhere else. Have you ever thought about emigrating from [your country]?
   1.  Yes
   2.  No
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q104B_TUN [PROGRAMMER: COUNTRY==21, IF Q104==1]** And are you preparing to emigrate?
   1.  Yes
   2.  No
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q104A [PROGRAMMER: IF Q104 == 1]** People want to emigrate for different reasons. Why have you thought about emigrating? **[INTERVIEWER:** *Do not read. Please record the respondent's answer **verbatim** in Modern Standard Arabic and then select all the relevant categories from the list.*]
**[PROGRAMMER: Please allow for two answers:**
**Q104A_1** OPEN RESPONSE, **Q104A_2** POST-CODE**. SELECT ALL THAT APPLY]**
   1.  For economic reasons [**INTERVIEWER:** inflation, unemployment]
   2.  For political reasons
   3.  Religious reasons
   4.  Security reasons
   5.  Education opportunities (for self or family members)
   6.  Reunite with family
   7.  Corruption
90. Other- specify: [INTERVIEWER: DO NOT READ]
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

--- page 28 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**Q104B [PROGRAMMER: IF Q104 == 1]** Which country are you thinking of emigrating to? **[INTERVIEWER:** Please do not read the response categories. Check all that apply.]
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]
   1    Saudi Arabia                        14   The United States
   2    The United Arab Emirates            15   Canada
   3    Qatar                               16   The United Kingdom
   4    Bahrain                             17   Eastern Europe
   5    Kuwait                              18   France
   6    Oman                                19   Germany
   7    Egypt                               20   Spain
   8    Jordan                              21   Italy
   9    Lebanon                             22   Other Western European countries
   10   Morocco                             23   Sub-Saharan Africa
   11   Algeria                             24   China
   12   Tunisia                             25   Australia
   13   Turkey                              90   Other - specify: [**INTERVIEWER**: DO NOT READ]

**Q104C [PROGRAMMER: IF Q104A == 1]** Would you consider leaving [YOUR COUNTRY] even if you didn't have the required papers?
   1.   Yes
   2.   No
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q1017 [PROGRAMMER:  COUNTRY != 9]** Does your family receive remittances from any immediate or extended family member living abroad?
   1.   Yes, monthly
   2.   Yes, a few times a year
   3.   Yes, once a year
   4.   We do not receive anything
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

27

www.arabbarometer.org

--- page 29 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**Q907 [PROGRAMMER:  COUNTRY != 15]** To what extent do you think migrants from other Arab countries are discriminated against in [your country]?
   1.  To a great extent
   2.  To a medium extent
   3.  To a small extent
   4.  Not at all
97. I am unaware of migrants from other Arab countries to [your country]
[INTERVIEWER: DO NOT READ]
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q905 [PROGRAMMER: SPLIT A. COUNTRY != 15]** To what extent do you think migrants from Sub Saharan Africa are discriminated against in [your country]?
   1.  To a great extent
   2.  To a medium extent
   3.  To a small extent
   4.  Not at all
97. I am unaware of migrants from Sub Saharan Africa to [your country]
[INTERVIEWER: DO NOT READ]
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q906 [PROGRAMMER: SPLIT B. COUNTRY != 12, 15]** To what extent do you think migrants from South Asia and Southeast Asia are discriminated against in [your country]? [**INTERVIEWER:** If asked, country examples include Pakistan, Nepal, Sri Lanka, Indonesia, and the Philippines]
   1.  To a great extent
   2.  To a medium extent
   3.  To a small extent
   4.  Not at all
97. I am unaware of migrants from South Asia and Southeast Asia to [your country]
[INTERVIEWER: DO NOT READ]
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

--- page 30 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**Q916** To what extent would you support or oppose each of the following laws that would guarantee the right of foreign domestic workers in [YOUR COUNTRY]
   1. Strongly support
   2. Somewhat support
   3. Somewhat oppose
   4. Strongly oppose
98. Don't know [INTERVIEWER: DO NOT READ]
99. Decline to answer [INTERVIEWER: DO NOT READ]

 1    To always have possession of their passports?          1   2   3   4   98   99
 2    To have one day off per week guaranteed?               1   2   3   4   98   99
 3    To have a bank account where they can receive their salaries?   1   2   3   4   98   99

**Q869F [PROGRAMMER: COUNTRY!=15. IF COUNTRY ==7,8,10, SPLIT A ONLY]** What do you think the chances are these days that you or anyone in your family will not get a job while an equally or less qualified **migrant** receives one instead? Is this:
   1. Very likely
   2. Somewhat likely
   3. Somewhat unlikely
   4. Very unlikely
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q869G [PROGRAMMER: ONLY IF COUNTRY ==7,8,10 and ONLY SPLIT B]** What do you think the chances are these days that you or anyone in your family will not get a job while an equally or less qualified **refugee** receives one instead? Is this:
   1. Very likely
   2. Somewhat likely
   3. Somewhat unlikely
   4. Very unlikely
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

--- page 31 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**SECTION VI: IDENTITY & RELIGIOUS PRACTICE**

**INTERVIEWER:** Let's move now to another topic and speak about personal identity
and religious practices.

**Q1012.  [PROGRAMMER: COUNTRY!=12]**
What is your religion?
   1.   Muslim
   2.   Christian
   4. No religion [INTERVIEWER: DO NOT READ]
90. Other- specify: _______
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q1012A_MUSLIM [PROGRAMMER: IF Q1012==1. COUNTRY !=9 OR  12]**
What is your religious denomination? [**INTERVIEWER**: DO NOT READ, LOG
ANSWER]
   1.   Just a Muslim
   2.   Sunni
   3.   Shia
   4.   Hanbali
   5.   Shafi'i
   6.   Ja'fari
   7.   Druze
   8.   Ahmadiyya
   9.   Alawi
   10.  Ibadi
   11.  Malki
90. Other- specify: [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q1012A_CHRISTIAN [PROGRAMMER: IF Q1012==2. COUNTRY !=9 OR 12]** What is
your religious denomination? [**INTERVIEWER**: DO NOT READ, LOG ANSWER]
   1.   Just a Christian
   2.   Maronite
   3.   Orthodox
   4.   Catholic
   5.   Armenian
   6.   Coptic
   7.   Protestant
   8.   Sabean Mandean
90. Other- specify: [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

--- page 32 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**Q1020JO2 [PROGRAMMER: COUNTRY == 8]** Do you consider yourself…
   1.  Jordanian
   2.  Palestinian
   3.  Both Jordanian and Palestinian
90. Other- specify: [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q1012B2 [PROGRAMMER: COUNTRY!=12]** Do you consider yourself…?
[**PROGRAMMER**: The list is country-specific but with set codes as follows:]
   1.  Arab **[PROGRAMMER: ALL COUNTRIES]**
   2.  Kurd **[PROGRAMMER: COUNTRY==7]**
   3.  Amazigh [Berber] [**PROGRAMMER: COUNTRY==13, 21]**
   4.  Turkmen [**PROGRAMMER: COUNTRY==7, 8]**
   5.  Tourag [**PROGRAMMER: COUNTRY==13, 21]**
   8.  Yazidi **[PROGRAMMER: COUNTRY==7]**
   9.  Assyrian **[PROGRAMMER:  COUNTRY==7]**
   10. Armenian **[PROGRAMMER: COUNTRY==10, 15]**
   11. Circassian **[PROGRAMMER: COUNTRY==8]**
90. Other- specify: **[PROGRAMMER: ALL] [INTERVIEWER: DO NOT READ]**
98. Don't know **[PROGRAMMER: ALL] [INTERVIEWER: DO NOT READ]**
99. Refused to answer **[PROGRAMMER: ALL] [INTERVIEWER: DO NOT READ]**

**Q1012C_MOR  [PROGRAMMER: COUNTRY== 13]** Do you speak a language other than Arabic? **[INTERVIEWER:** *Do not read. Select all responses that apply from the list below based on the respondent's answer*.]
   1.  One or more of the Amazigh languages (Tarifit, Taqbaylit, Central Atlas
       Tamazight, Tasusit, etc.)
   2.  Hassaniya Arabic
   3.  French
   4.  Spanish
90. Other- specify: [INTERVIEWER: DO NOT READ]
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q609 [PROGRAMMER: COUNTRY!=9]** In general, would you describe yourself as religious, somewhat religious, or not religious?
   1.  Religious
   2.  Somewhat religious
   3.  Not religious
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

31

www.arabbarometer.org

--- page 33 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**Q610 [PROGRAMMER: COUNTRY != 9]** Do you always, most of the time, sometimes, rarely, or never **[INSERT ITEM]**?
   1.   Always
   2.   Most of the time
   3.   Sometimes
   4.   Rarely
   5.   Never
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]
**[PROGRAMMER: RANDOMIZE ITEMS. ITEM 1 MUST ALWAYS COME BEFORE 8.]**

1    Pray daily                                                          1   2   3   4   5   98   99

8    [PROGRAMMER: FOR ALL COUNTRY!=12, Q1012== 1 AND Q610_1!= 5. IF COUNTRY==12, ALL if Q610_1!=5] Pray fajr on time.     1   2   3   4   5   98   99

6A   [PROGRAMMER: IF Q1012 == 1. IF COUNTRY==12, ALL. ] Listen to or read the Quran daily?     1   2   3   4   5   98   99

6B   [PROGRAMMER: IF Q1012 == 2. COUNTRY!=12.] Listen to or read the Bible daily?     1   2   3   4   5   98   99

--- page 34 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**Q606 [PROGRAMMER: COUNTRY !=  9]** How much do you agree or disagree with each of the following statements?
         1.   I strongly agree
         2.   I agree
         3.   I disagree
         4.   I strongly disagree
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]
**[PROGRAMMER: RANDOMIZE ITEMS]**

 2          [Your country] is better off if religious people          1   2   3   4   98   99
            hold public positions in the state.
 3*         Religious clerics **have** influence over the             1   2   3   4   98   99
 SPLIT A    decisions of government.
 3B         Religious clerics **should have** influence over          1   2   3   4   98   99
 SPLIT B    the decisions of government.
 NT_3       **The religious *ulama*** **should have** influence       1   2   3   4   98   99
 SPLIT C    over the decisions of government.
 NT_3B      **The religious *ulama*** **have** influence over the     1   2   3   4   98   99
 SPLIT D    decisions of government.
 4          Religious practice is a private matter and                1   2   3   4   98   99
            should be separated from socio-economic life.
 8          Today, religious leaders are as likely to be              1   2   3   4   98   99
            corrupt as non-religious leaders.

*Note to users: The English-language translation of this item has been updated in this Arab Barometer Wave 8 Questionnaire to better match the Arabic, which is the official question. The Arabic language version has remained unchanged since first asked in Arab Barometer Wave 2.
** Muslim scholars with specialized knowledge of Islamic law and theology

**Q605  [PROGRAMMER: IF Q1012 == 1. COUNTRY!=9]** From your point of view, should the laws of our country…
     1.   …entirely be based on the sharia;
     2.   …mostly be based on the sharia;
     3.   …equally be based on sharia and the will of the people;
     4.   …mostly be based on the will of the people; or
     5.   …entirely be based on the will of the people?
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

--- page 35 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**Q867A** Do you believe that the quality of your life is better, the same as, or worse than the quality of your parents' lives?
   1.   Better
   2.   Same
   3.   Worse
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q867B** Do you believe that the quality of your children's lives will be better, the same as, or worse than the quality of your life?
   1.   Better
   2.   Same
   3.   Worse
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q872C_PAL [PROGRAMER: IF COUNTRY==15]** To what extent do you believe racial discrimination by Israelis against Palestinians is a serious problem in the West Bank and Gaza?
   1.   To a great extent
   2.   To a medium extent
   3.   To a small extent
   4.   Not at all
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q872A [PROGRAMMER: SPLIT A]** To what extent do you believe **racial discrimination*** is a serious problem in [your country]? **[IF COUNTRY==15**, add this introductory clause to the ODK before the question: "Other than discrimination by Israel in the West Bank and Gaza"]
   1.   To a great extent
   2.   To a medium extent
   3.   To a small extent
   4.   Not at all
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]
*Note to English-language users: The adjective "racial" is not in the Arabic-language term for "racial discrimination."*

34

www.arabbarometer.org

--- page 36 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**Q872B [PROGRAMMER: SPLIT B]** Do you believe **discrimination on the basis of race or ethnicity** is a serious problem in [your country]? [**INTERVIEWER:** If asked what "race" or "ethnicity" are, please explain: "Race and ethnicity describe categories of individuals based on physical characteristics and cultural differences, like language and heritage and customs."] **[IF COUNTRY==15**, add this introductory clause to the ODK before the question: "Other than discrimination by Israel in the West Bank and Gaza"]
   1. To a great extent
   2. To a medium extent
   3. To a small extent
   4. Not at all
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q872C [PROGRAMMER: SPLIT B] INTERVIEWER THIS QUESTION IS FOR YOU:** Did the respondent ask you to explain what "race" was in Q872B?
   1. Yes
   2. No

**NOTE TO PROGRAMMER:** Randomize **Section A** and **Section B**

**PROGRAMMER: BEGIN DISCRIMINATION SECTION A**

**Q873** In your opinion, do people in [your country] face discrimination because of...
**[INTERVIEWER:** Read one response category at a time and wait for the respondent to say yes or no to it. If the respondent says no to all, select item 13. None of these (reasons). **[PROGRAMMER: SELECT ALL THAT APPLY. OPTION 13 CANNOT BE COMBINED WITH ANY OTHER]**
   1. Socioeconomic class
   2. The region you are from [**INTERVIEWER:** If asked, say, "where people are from in the country"]
   3. Skin color
   4. Race or ethnicity
   5. Nationality
   6. Religion
   7. Gender
   8. Tribe **[PROGRAMMER: COUNTRY==7,8,9 ONLY]**
   9. Age
   10. Sexual orientation **[PROGRAMMER: COUNTRY==10, 21 ONLY]**
   11. Disability status
   12. Migration status [**INTERVIEWER:** If asked, say, "If people are refugees, migrants, or IDPs."]
   13. None of these [**INTERVIEWER:** DO NOT READ. Select only if respondent says no to all other options.**]**
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

35

www.arabbarometer.org

--- page 37 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**Q879 [PROGRAMMER: IF Q873 !=13, 98,99. ]** You said people in [your country] face discrimination because of [**PROGRAMMER: PIPE IN ANSWERS FROM Q873**]. Which of these is the most widespread form of discrimination in [your country]? Is it …
[**PROGRAMMER: ONLY SHOW RESPONSE CATEGORIES RESPONDENT SELECTED IN Q873.]**
   1.  Socioeconomic class
   2.  The region you are from
   3.  Skin color
   4.  Race or ethnicity
   5.  Nationality
   6.  Religion
   7.  Gender
   8.  Tribe **[PROGRAMMER: COUNTRY==7,8,9 ONLY]**
   9.  Age
   10. Sexual orientation **[PROGRAMMER: COUNTRY==10, 21 ONLY]**
   11.  Disability status
   12.  Migration status
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q881A [PROGRAMMER: IF Q873 !=13, 98,99; IF Q879!= 98,99]** Thinking about people who face discrimination because of [**PROGRAMMER: PIPE IN ANSWER FROM Q879],** in which of the following circumstances do you think they have faced discrimination?  Please tell me all that apply from the following list.
**[INTERVIEWER:** Read one response category at a time and wait for respondent to say yes or no to it. If the respondent says no to all, select item 8. None of these.]
**[PROGRAMMER:** SELECT ALL THAT APPLY. OPTION 8 CANNOT BE COMBINED WITH ANY OTHER OPTION**]**
   1.  Finding employment
   2.  Finding housing
   3.  Accessing public education
   4.  Accessing healthcare
   5.  Using public transportation
   6.  Dining in a restaurant
   7.  Using banks or financial services
   8.  None of these [**INTERVIEWER:** DO NOT READ. Select only if respondent says
       no to all other options]
90. Other- specify: [INTERVIEWER: DO NOT READ]
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

36

www.arabbarometer.org

--- page 38 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**Q881B [PROGRAMMER: IF Q873 !=13, 98,99; IF Q879!= 98,99]** And thinking about people who face discrimination because of [**PROGRAMMER: PIPE IN ANSWER FROM Q879],** do you think they...?
**[INTERVIEWER:** Read one response category at a time and wait for respondent to say yes or no to it. If the respondent says no to all, select item 8. None of these.]
**[PROGRAMMER:** SELECT ALL THAT APPLY. OPTION 8 CANNOT BE COMBINED WITH ANY OTHER OPTION**]**
   1.   Are subjected to verbal insults or hate speech
   2.   Are subjected to offensive jokes
   3.   Are assumed to be untrustworthy or dishonest
   4.   Are assumed to be less smart
   5.   Have others dismiss or devalue their contributions
   6.   Have others deny that they face more hardships
   7.   Are treated as if they are inferior
   8.   None of these [**INTERVIEWER:** DO NOT READ. Select only if respondent says no to all other options]
90. Other- specify: [INTERVIEWER: DO NOT READ]
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**PROGRAMMER: END DISCRIMINATION SECTION A**

**PROGRAMMER: BEGIN DISCRIMINATION SECTION B**

**Q882** In the past year, have you personally faced discrimination?
   1.   Yes, frequently
   2.   Yes, sometimes
   3.   Yes, but rarely
   4.   No, never
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

--- page 39 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**Q883 [PROGRAMMER: IF Q882 !=4, 98, 99] In your opinion,** what is the **main reason** for being discriminated against? Was it because of your....
   1.  Socioeconomic class
   2.  The region you are from [**INTERVIEWER:** If asked, say, "where you are from in
       the country"]
   3.  Skin color
   4.  Race or ethnicity
   5.  Nationality
   6.  Religion
   7.  Gender
   8.  Tribe **[PROGRAMMER: COUNTRY==7,8,9 ONLY]**
   9.  Age
   10. Sexual orientation **[PROGRAMMER: COUNTRY==10, 21 ONLY]**
   11. Disability status
   12. Migration status [**INTERVIEWER:** If asked, say, "If you are an IDP or consider
       yourself a migrant"]
90. Other- specify: [INTERVIEWER: DO NOT READ]
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q884A [PROGRAMMER: IF Q882 !=4, 98, 99 AND IF Q883!=98, 99]** In which of the following circumstances have you faced discrimination because of [**PROGRAMMER: PIPE IN ANSWER FROM Q883]?** Please tell me all that apply from the following list.
**[INTERVIEWER:** Read one response category at a time and wait for respondent to say yes or no to it. If the respondent says no to all, select item 8. None of these]
**[PROGRAMMER:** SELECT ALL THAT APPLY. OPTION 8 CANNOT BE COMBINED WITH ANY OTHER OPTION**]**
   1.  Finding employment
   2.  Finding housing
   3.  Accessing public education
   4.  Accessing healthcare
   5.  Using public transportation
   6.  Dining in a restaurant
   7.  Using banks or financial services
   8.  None of these [**INTERVIEWER:** DO NOT READ. Select only if respondent says
       no to all other options]
90. Other- specify: [INTERVIEWER: DO NOT READ]
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

--- page 40 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**Q884B [PROGRAMMER: IF Q882 !=4, 98, 99 AND IF Q883!=98, 99]** And thinking about discrimination you faced because of [**PROGRAMMER: PIPE IN ANSWER FROM Q883],** have you... ? **[INTERVIEWER:** Read one response category at a time and wait for respondent to say yes or no to it. If the respondent says no to all, select item 8. None of these.]
**[PROGRAMMER:** SELECT ALL THAT APPLY. OPTION 8 CANNOT BE COMBINED WITH ANY OTHER OPTION**]**
   1.   Been subjected to verbal insults or hate speech
   2.   Been subjected to offensive jokes
   3.   Been assumed to be untrustworthy or dishonest
   4.   Been assumed to be less smart
   5.   Had others dismiss or devalue your contributions
   6.   Had others deny that you face more hardships
   7.   Been treated as if you are inferior
   8.   None of these [**INTERVIEWER:** DO NOT READ. Select only if respondent says no to all other options]
90. Other- specify: [INTERVIEWER: DO NOT READ]
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**PROGRAMMER: END DISCRIMINATION SECTION B**

**Q885** Do you think our national government should do more, less, or about the same amount as it is doing right now to deal with discrimination in [our country]?
   1.   More
   2.   Less
   3.   About the same
97. Discrimination is not a problem in our country [INTERVIEWER: DO NOT READ]
98. Don't know [INTERVIEWER: DO NOT READ]
99. Decline to answer [INTERVIEWER: DO NOT READ]

--- page 41 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**Q886** When citizens from [your country] travel outside the Middle East and North Africa, on what basis, if any, do you think they are likely to face discrimination?
   1.  Socioeconomic class
   2.  NULL
   3.  Skin color
   4.  Race or ethnicity
   5.  Nationality
   6.  Religion
   7.  Gender
   8.  Age
   9.  Sexual orientation **[PROGRAMMER: COUNTRY==10, 21 ONLY]**
   10. Disability status
   11. They will not face discrimination. [**INTERVIEWER: DO NOT READ.** Select only
         if respondent says no to all other options**]**
90. Other- specify: [INTERVIEWER: DO NOT READ]
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

--- page 42 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**SECTION VII: CLIMATE CHANGE & THE ENVIRONMENT**

**Q540** Which of the following are the first and second biggest environmental
challenges facing [your country]?
**[PROGRAMMER: Please allow for two answers:**
**Q540_1** FIRST BIGGEST CHALLENGE, **Q540_2** SECOND BIGGEST CHALLENGE
   1.   Air quality
   2.   Pollution of drinking water
   3.   Pollution of seas, beaches, rivers, and lakes
   4.   Lack of water resources
   5.   Trash/ waste management
   6.   Pesticide, fertilizer, and food contamination
   7.   Industry and hazardous waste contamination
   8.   Inefficient use of energy (electricity, fuel)
   9.   Climate change [**INTERVIEWER**: If asked, in general]
96. All of these are challenges [INTERVIEWER: DO NOT READ]
97. None of these are challenges [INTERVIEWER: DO NOT READ]
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q540B** To what extent do you feel each of the following impacts your everyday life?
      1.   To a great extent
      2.   To a medium extent
      3.   To a small extent
      4.   Not at all
98. Don't know [INTERVIEWER: DO NOT READ]
99. Decline to answer [INTERVIEWER: DO NOT READ]

 **1**   Extreme weather temperatures   1   2   3   4   98   99
 **2**   Air pollution                  1   2   3   4   98   99
 **3**   Water scarcity                 1   2   3   4   98   99

**Q274A [PROGRAMMER: COUNTRY !=9]** In the past 12 months, have you experienced
any electricity outages:
   1.   Daily
   2.   Weekly
   3.   Monthly
   4.   Only a few times a year
   5.   Never
97. I don't have electricity [INTERVIEWER: DO NOT READ]
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

41

www.arabbarometer.org

--- page 43 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**Q274B [PROGRAMMER: COUNTRY !=9]** In the past 12 months, have you experienced water outages:
   1.  Daily
   2.  Weekly
   3.  Monthly
   4.  Only a few times a year
   5.  Never
97. I don't have water
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q548_2** When you hear the term "climate change," what comes to mind?
**[INTERVIEWER:** *Do not read. Please select the category from the list that best summarizes the respondent's answer.*]
   1.  Agricultural production or food availability
   2.  Weather (extreme or unseasonable temperatures)
   3.  Natural disasters (earthquakes, floods, fires, droughts)
   4.  Pollution
   5.  Migration
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refuse to answer [INTERVIEWER: DO NOT READ]

**Q549** How concerned are you about the impact of **climate change** on:
   1.  To a great extent
   2.  To a medium extent
   3.  To a small extent
   4.  Not concerned at all
98. Don't know [INTERVIEWER: DO NOT READ]
99. Decline to answer [INTERVIEWER: DO NOT READ]

 1A         Your physical health                              1   2   3   4   98   99
 SPLIT A
 1B         Your mental health                               1   2   3   4   98   99
 SPLIT B
 2          Your personal safety                             1   2   3   4   98   99
 3          Your job or your household's livelihood          1   2   3   4   98   99
            [INTERVIEWER: If the respondent is
            unemployed, please indicate the main
            source of income for the household]

42

www.arabbarometer.org

--- page 44 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**Q553A**  To what extent do you believe the actions of each of the following contribute to climate change?
   1.   To a great extent
   2.   To a medium extent
   3.   To a small extent
   4.   Not at all
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refuse to answer [INTERVIEWER: DO NOT READ]

     1          Citizens in [your country]                1   2   3   4   98   99
  **SPLIT A**
     2          Citizens in Western countries             1   2   3   4   98   99
  **SPLIT B**
     3          The government of [your country]          1   2   3   4   98   99
  **SPLIT A**
     4          The governments of Western countries      1   2   3   4   98   99
  **SPLIT B**
     5          Private businesses or corporations in [your   1   2   3   4   98   99
  **SPLIT A**   country]
     6          Private businesses or corporations in     1   2   3   4   98   99
  **SPLIT B**   Western countries

**Q553B** And to what extent do you think each of the following should be responsible for taking steps to address climate change?
   1.   To a great extent
   2.   To a medium extent
   3.   To a small extent
   4.   Not at all
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refuse to answer [INTERVIEWER: DO NOT READ]

     1          Citizens in [your country]                1   2   3   4   98   99
  **SPLIT A**
     2          Citizens in Western countries             1   2   3   4   98   99
  **SPLIT B**
     3          The government of [your country]          1   2   3   4   98   99
  **SPLIT A**
     4          The governments of Western countries      1   2   3   4   98   99
  **SPLIT B**
     5          Private businesses or corporations in [your   1   2   3   4   98   99
  **SPLIT A**   country]
     6          Private businesses or corporations in     1   2   3   4   98   99
  **SPLIT B**   Western countries

43

www.arabbarometer.org

--- page 45 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**Q546** Do you think our national government should do more, less, or about the same amount as it is doing right now to deal with climate change?
   1.   More
   2.   Less
   3.   About the same
98. Don't know [INTERVIEWER: DO NOT READ]
99. Decline to answer [INTERVIEWER: DO NOT READ]

**Q547** To what extent do you favor or oppose adopting each of the following measures?
   2.   Strongly favor
   3.   Somewhat favor
   4.   Somewhat oppose
   5.   Strongly oppose
98. Don't know [INTERVIEWER: DO NOT READ]
99. Decline to answer [INTERVIEWER: DO NOT READ]

   1          Have our government prioritize alternative energy development, like solar or wind power in [your country]                                                                                    1   2   3   4   98   99
   2          Phase out use of fossil fuels, like gas and oil in [your                                                                                                                                   1   2   3   4   98   99
   SPLIT A    country]
   3          [PROGRAMMER: IF COUNTRY==7,9,10,13,21]                                                                                                                                                    1   2   3   4   98   99
   SPLIT B    Phase out production fossil fuels, like gas and oil in [your country]
   4          Set a common target date to phase out polluting cars and vehicles in [your country]                                                                                                        1   2   3   4   98   99
   TUN2       [PROGRAMMER: IF COUNTRY==21]                                                                                                                                                              1   2   3   4   98   99
              For the government to mandate financial punishment for those who litter in public spaces
   TUN3       [PROGRAMMER: IF COUNTRY==21]                                                                                                                                                              1   2   3   4   98   99
              To specify a larger portion of the budget to address pollution and manage trash, even if it means imposing more laws on citizens
   TUN4       [PROGRAMMER: IF COUNTRY==21]                                                                                                                                                              1   2   3   4   98   99
              For the government to raise the cost of water significantly for each family that consumes more than the regular necessities for household consumption of water

**Q554** How concerned or unconcerned are you about natural disasters in [your country]?
   1.   Very concerned
   2.   Somewhat concerned
   3.   Somewhat unconcerned
   4.   Not at all concerned
98. Don't know [INTERVIEWER: DO NOT READ]
99. Decline to answer [INTERVIEWER: DO NOT READ]

44

www.arabbarometer.org

--- page 46 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**SECTION VIII: GENDER NORMS & ATTITUDES**

**INTERVIEWER:** This next set of questions the roles of men and women in our
society.

**Q601** For each of the statements listed below, please indicate whether you agree
strongly, agree, disagree, or disagree strongly with it.
   1.    Strongly agree
   2.    Agree
   3.    Disagree
   4.    Strongly disagree
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**[PROGRAMMER: RANDOMIZE ITEMS AND SEE SPLITS]**

 3              In general, men are better at political          1   2   3   4   98   99
                leadership than women.
                University education for males is more
 4              important than university education for          1   2   3   4   98   99
                females.
 5              Men and women should have equal work             1   2   3   4   98   99
                opportunities.
 13             A woman can reject a marriage that her           1   2   3   4   98   99
 SPLIT A        family chose for her without her consent
 13B            Men and women should both have equal             1   2   3   4   98   99
 SPLIT B        say in deciding who they marry
 18             A man should have final say in all decisions     1   2   3   4   98   99
 SPLIT A        concerning the family.
 18B            A man and a woman should have equal say          1   2   3   4   98   99
 SPLIT B        in decisions concerning the family.
                There **should be** a minimum number of
                seats in parliament reserved for women
 21A            **[INTERVIEWERS IN MOROCCO AND IRAQ:**           1   2   3   4   98   99
 SPLIT A        There are already quota laws in place. This
                question asks respondents to give their
                opinions on whether these laws should or
                should not exist.]
 21B            There should be a minimum number of              1   2   3   4   98   99
 SPLIT B        cabinet positions reserved for women
                **[PROGRAMMER: COUNTRY==9]**
 KUW1           It is acceptable for male and female             1   2   3   4   98   99
                university students to attend classes
                together

45

www.arabbarometer.org

--- page 47 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**Q622C [SPLIT A]** In your opinion, which of the following poses the most challenging barrier to entry into the workplace **for women** in [YOUR COUNTRY]?
**[PROGRAMMER: RANDOMIZE]**
   1.   Lack of available jobs
   2.   Low wages
   3.   Lack of legal right/protection
   4.   Lack of flexibility in working hours
   5.   Lack of childcare options
   6.   Lack of means of transportation
   7.   Lack of skills or relevant education
   8.   Bias against women in hiring
   9.   It is considered socially unacceptable
97. None of these are challenges [INTERVIEWER: DO NOT READ]
98. Don't know [INTERVIEWER: DO NOT READ]
99 Refused to answer [INTERVIEWER: DO NOT READ]

**Q622E [SPLIT B]** In your opinion, which of the following poses the most challenging barrier to entry into the workplace **for men** in Iraq?
**[PROGRAMMER: RANDOMIZE]**
   1.   Lack of available jobs
   2.   Low wages
   3.   Lack of legal right/protection
   4.   Lack of flexibility in working hours
   5.   Lack of childcare options
   6.   Lack of means of transportation
   7.   Lack of skills or relevant education
   8.   Bias against men in hiring
   9.   It is considered socially unacceptable
97. None of these are challenges [INTERVIEWER: DO NOT READ]
98. Don't know [INTERVIEWER: DO NOT READ]
99 Refused to answer [INTERVIEWER: DO NOT READ]

**Q622C_IRQ [COUNTRY==7. SPLIT A]** In your opinion, which of the following poses the most challenging barrier to entry into the workplace **for women** in Iraq?
**[PROGRAMMER: RANDOMIZE. SELECT ALL THAT APPLY]**
   1.   Lack of available jobs
   2.   Low wages
   3.   Lack of legal right/protection
   4.   Lack of flexibility in working hours
   5.   Lack of childcare options
   6.   Lack of means of transportation
   7.   Lack of skills or relevant education
   8.   Bias against women in hiring
   9.   It is considered socially unacceptable
97. None of these are challenges [INTERVIEWER: DO NOT READ]
98. Don't know [INTERVIEWER: DO NOT READ]
99 Refused to answer [INTERVIEWER: DO NOT READ]

46

www.arabbarometer.org

--- page 48 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**Q622E_IRQ [PROGRAMMER: COUNTRY==7. SPLIT B]** In your opinion, which of the following poses the most challenging barrier to entry into the workplace **for men** in [YOUR COUNTRY]? **[PROGRAMMER: RANDOMIZE. SELECT ALL THAT APPLY]**
   1.   Lack of available jobs
   2.   Low wages
   3.   Lack of legal right/protection
   4.   Lack of flexibility in working hours
   5.   Lack of childcare options
   6.   Lack of means of transportation
   7.   Lack of skills or relevant education
   8.   Bias against women in hiring
   9.   It is considered socially unacceptable
97. None of these are challenges [INTERVIEWER: DO NOT READ]
98. Don't know [INTERVIEWER: DO NOT READ]
99 Refused to answer [INTERVIEWER: DO NOT READ]

**Q869D [PROGRAMMER: SPLIT A]** What do you think the chances are these days that you or anyone in your family will not get a job while an equally or less qualified **male** employee receives one instead? Is this:
   1.   Very likely
   2.   Somewhat likely
   3.   Somewhat unlikely
   4.   Very unlikely
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q869E [PROGRAMMER: SPLIT B]** What do you think the chances are these days that you or anyone in your family will not get a job while an equally or less qualified **female** employee receives one instead? Is this:
   1.   Very likely
   2.   Somewhat likely
   3.   Somewhat unlikely
   4.   Very unlikely
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q626** Thinking of childcare options in [your country], which of the following is the biggest problem?
   1.   It not widely available
   2.   It is not affordable
   3.   It is poor quality
   4.   It is socially unacceptable to use it
98. Don't know [INTERVIEWER: DO NOT READ]
99 Refused to answer [INTERVIEWER: DO NOT READ]

47

www.arabbarometer.org

--- page 49 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**Q624** In your opinion, and regardless of who *actually* completes these tasks in your household, who should be primarily responsible for each of the following tasks around the house?
   1.  The female head of the household
   2.  The male head of the household
   3.  The household heads are equally responsible
   4.  Others are responsible
98. Don't know [INTERVIEWER: DO NOT READ]
99 Refused to answer [INTERVIEWER: DO NOT READ]

  5A
SPLIT A    Deciding how much to spend on food    1   2   3   4   97   98   99

  5B
SPLIT B    Deciding what types of food to buy    1   2   3   4   97   98   99


**Q628** Thinking about each of the following personal choices people can make, who do you think has more freedom of choice?
   1.  Men more than women
   2.  Women more than men
   3.  Men and women have equal freedom
   4.  Neither men nor women have freedom
97. Not applicable
98. Don't know [INTERVIEWER: DO NOT READ]
99 Refused to answer [INTERVIEWER: DO NOT READ]
**[PROGRAMMER: RANDOMIZE ITEMS AND SEE SPLITS]**

  2A
SPLIT A    To pursue higher education                  1   2   3   4   97   98   99

  2B
SPLIT B    To choose what to study in higher
           education                                   1   2   3   4   97   98   99

  3A
SPLIT A    To get a job                                1   2   3   4   97   98   99

  3B
SPLIT B    To choose what type of job they want        1   2   3   4   97   98   99

  4A
SPLIT A    To choose to get married                    1   2   3   4   97   98   99

  4B
SPLIT B    To choose who to marry                      1   2   3   4   97   98   99

--- page 50 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**Q604A_NT  [PROGRAMMER: SPLIT A. COUNTRY !=9 OR 12]** To what degree would each of the following factors be an obstacle to accepting the marriage of a close female relative?

**[NOTE TO USERS: The Arabic language version of this question, which is the official version, changed in wave 8. The English has remained the same, but given the change in Arabic, it should no longer be compared with previous iterations of this question.]**

   1.   Constitute an obstacle to a large degree
   2.   Constitute an obstacle to a moderate degree
   3.   Constitute an obstacle to a small degree
   4.   Constitute no obstacle at all
98. Don't know [INTERVIEWER: DO NOT READ]
99 Refused to answer [INTERVIEWER: DO NOT READ]

  1       One who does not pray                    1   2   3   4   97   98   99
  3       One who comes from a family with a       1   2   3   4   97   98   99
          lower social status


**Q604B_NT  [PROGRAMMER: SPLIT B. COUNTRY !=9 OR 12]** To what degree would each of the following factors be an obstacle to accepting the marriage of a close male relative?

**[NOTE TO USERS: The Arabic language version of this question, which is the official version, changed in wave 8. The English has remained the same, but given the change in Arabic, it should no longer be compared with previous iterations of this question.]**

   1.   Constitute an obstacle to a large degree
   2.   Constitute an obstacle to a moderate degree
   3.   Constitute an obstacle to a small degree
   4.   Constitute no obstacle at all
98. Don't know [INTERVIEWER: DO NOT READ]
99 Refused to answer [INTERVIEWER: DO NOT READ]

  1       One who does not pray                    1   2   3   4   97   98   99
  3       One who comes from a family with a       1   2   3   4   97   98   99
          lower social status

--- page 51 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**Q627** In your opinion, is it very widespread, fairly widespread, fairly rare, or very rare for women in [YOUR COUNTRY] to face harassment
   1.   Very widespread
   2.   Fairly widespread
   3.   Fairly rare
   4.   Very rare
97. Women do not face harassment in [our country] [INTERVIEWER: DO NOT READ]
98. Don't know [INTERVIEWER: DO NOT READ]
99 Refused to answer [INTERVIEWER: DO NOT READ]

 1    In the workplace              1   2   3   4   97   98   99
 2    On the street by strangers    1   2   3   4   97   98   99
 3    In the home by family members 1   2   3   4   97   98   99


**Q625 [PROGRAMMER: COUNTRY!=9]** In the past 12 months, has abuse of or violence against women in the community increased, stayed the same, decreased, or was it never a problem?
   1.   Increased
   2.   Stayed the same
   3.   Decreased
   4.   It was never a problem [INTERVIEWERS: **READ**]
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q629 [PROGRAMMER: COUNTRY!=9; if Q625 ==1,2 or 3]** In your opinion, if a woman faces abuse or violence in the community, from which of the following actors is she likely to be able to receive assistance? Please tell me all that apply. **[PROGRAMMER: SELECT ALL THAT APPLY. CANNOT COMBINE 1 WITH ANY OTHER ANSWER]**
   1.   She will not be able to receive assistance [INTERVIEWER: **READ]**
   2.   A female member of the family
   3.   A male member of the family
   4.   The local police
   5.   A clinic or hospital
   6.   A local organization
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q631** To what extent do you believe that having women in political leadership roles advances the women's rights agenda in [YOUR COUNTRY]?
   1.   To a great extent
   2.   To a medium extent
   3.   To a small extent
   4.   Not at all
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

50

www.arabbarometer.org

--- page 52 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**Q630** Regardless of your personal opinion, what percent of other citizens in [YOUR COUNTRY] do you think agrees that, "In general, men are better at political leadership than women"?
   1.  0-20%
   2.  21-40%
   3.  41-60%
   4.  61-80%
   5.  81-100%
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

--- page 53 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**SECTION IX:  MEDIA**

**Q409** On average, how often do you use the Internet? [INTERVIEWER: THIS INCLUDES INTERNET USED ON SMARTPHONES AND TABLETS]
      1.   Throughout the day
      2.   At least once daily
      3.   Several times a week
      4.   Once a week
      5.   Less than once a week
      6.   I do not use the Internet
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q424 [PROGRAMMER: IF Q409 == 1, 2, 3, 4, 5]**  How many hours on a typical day do you spend on social media platforms? **[INTERVIEWER:** IF ASKED SPECIFY SUCH AS FACEBOOK, TWITTER, OR WHATSAPP**]**
      1. Not at all
      2. 0-2 hours
      3. 3-5 hours
      4. 6-9 hours
      5. 10 hours or more
98. Don't know [INTERVIEWER: DO NOT READ]
99. Decline to answer [INTERVIEWER: DO NOT READ]

**Q412A [PROGRAMMER: IF Q409 == 1, 2, 3, 4 OR 5]**  Which social media and text messaging services do you actively use? [**INTERVIEWER:** CHECK ALL THAT APPLY]
**[PROGRAMMER: ORDER RESPONSE CATEGORIES ALPHABETICALLY AND FIX "OTHER"-CATEGORY AT THE VERY BOTTOM OF THE LIST]**
      1.   Facebook
      2.   Twitter
      3.   Instagram
      4.   YouTube
      5.   WhatsApp
      6.   Telegram
      7.   Snapchat
      8.   Viber
      9.   Clubhouse
      10.  Signal
      11.  TikTok
      12.  Reddit
      13.  Mastodon
      14.  BeReal.
90. Other- specify: [INTERVIEWER: DO NOT READ]
98. Don't know [INTERVIEWER: DO NOT READ]
99. Decline to answer [INTERVIEWER: DO NOT READ]

--- page 54 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**Q432 [PROGRAMMER: IF Q409==1,2,3,4 OR 5]** If you follow social media influencers, do you do the following? **[INTERVIEWER & PROGRAMMER: SELECT ALL THAT APPLY]**
   1.  Clicking like on or sharing their updates
   2.  Subscribe to their accounts/channels
   3.  Comment or ask questions about their posts
   4.  Try products/services they recommend
   5.  Adopt their political, religious, or cultural views
97. I do not interact with social media influencers [INTERVIEWER: DO NOT READ]
98. Don't know [INTERVIEWER: DO NOT READ]
99. Decline to answer [INTERVIEWER: DO NOT READ]

**Q432B [PROGRAMMER: IF Q409==1,2,3,4 OR 5 AND IF Q432 !=97, 98, OR 99]** What is the main topic that social media influencers you follow talk about most of the time?
   1.  Art and culture
   2.  Beauty and fashion
   3.  Education
   4.  Food and cooking
   5.  Health and healthcare
   6.  Politics and reform
   7.  Religion
   8.  Sports and recreation
   9.  Technology
90. Other- specify: [INTERVIEWER: DO NOT READ]
98. Don't know [INTERVIEWER: DO NOT READ]
99. Decline to answer [INTERVIEWER: DO NOT READ]

**Q534** When you have private information that you would like to share with another trusted person, how secure do you feel...
      1. Very secure
      2. Somewhat secure
      3. Not very secure
      4. Not at all secure
97. I do not use this form of communication [INTERVIEWER: DO NOT READ]
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

 **1**   Using a landline telephone                                    1   2   3   4   97   98   99
 **2**   Using a mobile phone (to talk)                               1   2   3   4   97   98   99
 **3**   Sending text messages on a mobile phone                      1   2   3   4   97   98   99
 **4**   Using an online chatting or messenger service (like WhatsApp or Facebook Messenger)   1   2   3   4   97   98   99
 **5**   Sending an email                                             1   2   3   4   97   98   99

53

www.arabbarometer.org

--- page 55 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**Q431 [PROGRAMMER: IF Q409==1,2,3,4 OR 5]**
Thinking of your use of social media, to what extent are you concerned about...
   1.  To a great extent
   2.  To a limited extent
   3.  To a small extent
   4.  Not at all
98.Don't know [INTERVIEWER: DO NOT READ]
99.Refused to answer [INTERVIEWER: DO NOT READ]

   1A          Your government monitoring your online    1   2   3   4   98   99
   SPLIT A     activity
   1B          A foreign government monitoring your      1   2   3   4   98   99
   SPLIT B     online activity
   2           Social media platforms themselves         1   2   3   4   98   99
               censoring your online activity

**Q421**  What is your primary source of information to follow the **breaking news** as events unfold? **[INTERVIEWER: If asked about breaking news, a major political event, a natural disaster, a crisis, etc. READ OPTIONS]**
   1.  Face-to-face conversations
   2.  Telephone conversations
   3.  Newspapers
   4.  Radio
   5.  Television
   6.  Social media **[PROGRAMMER: IF Q409 == 1 OR 2 OR 3 OR 4 OR 5 ONLY]**
90. Other- specify: [INTERVIEWER: DO NOT READ]
98. Don't know [INTERVIEWER: DO NOT READ]
99. Decline to answer [INTERVIEWER: DO NOT READ]

--- page 56 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**SECTION X: INTERNATIONAL RELATIONS**

**Q700B** Now I would like to ask you questions about the Arab world and international relations. Please tell me if you have a very favorable, somewhat favorable, somewhat unfavorable, or very unfavorable opinion of the following country...
   1.   Very favorable
   2.   Somewhat favorable
   3.   Somewhat unfavorable
   4.   Very unfavorable
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]
**[PROGRAMMER: RANDOMIZE ITEMS AND SEE SPLITS]**

 1
 SPLIT B    The United States                        1   2   3   4   98   99

 2
 SPLIT B    [PROGRAMMER: COUNTRY!= 9]
            Saudi Arabia                             1   2   3   4   98   99

 8
 SPLIT B    Russia                                   1   2   3   4   98   99

 4
 SPLIT B    Turkey                                   1   2   3   4   98   99

 3
 SPLIT B    [PROGRAMMER: COUNTRY==
            7,8,9,10,15]
            Iran                                     1   2   3   4   98   99

 13
 SPLIT B    China                                    1   2   3   4   98   99

 7
 SPLIT B    [PROGRAMMER: COUNTRY!= 9]
            Qatar                                    1   2   3   4   98   99

 5
 SPLIT B    [PROGRAMMER: COUNTRY==
            10,12,13,21]
            France                                   1   2   3   4   98   99

 6
 SPLIT B    [PROGRAMMER: COUNTRY==21]
            Israel                                   1   2   3   4   98   99

 12
 SPLIT B    [PROGRAMMER: COUNTRY== 7, 8,
            9, 15]
            United Kingdom                           1   2   3   4   98   99

55

www.arabbarometer.org

--- page 57 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**Q700A [PROGRAMMER: COUNTRY != 9]** Now I would like to ask you questions about the Arab world and international relations. Do you prefer that future economic relations between [your country] and **…**
   1.    Become stronger than they were in previous years
   2.    Remain the same as they were in previous years
   3.    Become weaker than they were in the previous years
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]
**[PROGRAMMER: RANDOMIZE ITEMS AND SEE SPLITS]**

1
SPLIT A        The United States        1   2   3   98   99

2
SPLIT A        Saudi Arabia             1   2   3   98   99

8
SPLIT A        Russia                   1   2   3   98   99

4
SPLIT A        Turkey                   1   2   3   98   99

3
SPLIT A        **[PROGRAMMER: COUNTRY== 7,8,10,15]**
               Iran                     1   2   3   98   99

13
SPLIT A        China                    1   2   3   98   99

7
SPLIT A        Qatar                    1   2   3   98   99

5
SPLIT A        **[PROGRAMMER: COUNTRY== 10,12,13,21]**
               France                   1   2   3   98   99

**12**
**SPLIT A**    **[PROGRAMMER: COUNTRY== 7, 8, 15]**
               United Kingdom           1   2   3   98   99

**Q730B [PROGRAMMER: COUNTRY!=9]** To which of the following areas would you **most** prefer foreign aid to [your country] be dedicated?
**[PROGRAMMER: RANDOMIZE]**
   1.    Women's rights
   2.    Environmental protection and combating climate change
   3.    Civil society development
   4.    Building infrastructure
   5.    Improving education and vocational training
   6.    Promoting civil liberties/ freedoms
   7.    Economic development
90. Other- specify: [INTERVIEWER: DO NOT READ]
97. I do not want foreign aid [INTERVIEWER: DO NOT READ]
98. Don't know [INTERVIEWER: DO NOT READ]
99. Decline to answer [INTERVIEWER: DO NOT READ]

56

www.arabbarometer.org

--- page 58 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**Q729 [PROGRAMMER: COUNTRY != 9 OR 15]**
To what extent do you believe that US foreign aid to [your country]:
   1.   To a great extent
   2.   To a limited extent
   3.   To a small extent
   4.   Not at all
98.Don't know [INTERVIEWER: DO NOT READ]
99.Refused to answer [INTERVIEWER: DO NOT READ]

   3
SPLIT A    Strengthens education initiatives    1    2    3    4    98    99

   5
SPLIT A    Advances women's rights              1    2    3    4    98    99

   6
SPLIT A    Strengthens civil society            1    2    3    4    98    99

**Q729B [PROGRAMMER: COUNTRY != 9 OR 15]**
To what extent do you believe that China's foreign aid to [your country]:
   1.   To a great extent
   2.   To a limited extent
   3.   To a small extent
   4.   Not at all
98.Don't know [INTERVIEWER: DO NOT READ]
99.Refused to answer [INTERVIEWER: DO NOT READ]

   3
SPLIT B    Strengthens education initiatives    1    2    3    4    98    99

   5
SPLIT B    Advances women's rights              1    2    3    4    98    99

   6
SPLIT B    Strengthens civil society            1    2    3    4    98    99


**[PROGRAMMER: RANDOMIZE ORDER OF Q701H_1 AND Q701H_2]**

**Q701H_1 [PROGRAMMER: COUNTRY !=9 OR 15. RANDOMIZE.]**
Which of these do you think is the **main motivation of the United States** for giving foreign aid to [your country]?
   1.   Economic development in [your country]
   2.   Internal stability in [your country]
   3.   Empower civil society organizations in [your country]
   4.   Improve life of ordinary citizens in [your country]
   5.   Gaining influence in [your country]
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

57

www.arabbarometer.org

--- page 59 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**Q701H_2 [PROGRAMMER: COUNTRY !=9 OR 15. RANDOMIZE.]** Which of these do you think is the **main motivation of China** for giving foreign aid to [your country]?
   1.   Economic development in [your country]
   2.   Internal stability in [your country]
   3.   Empower civil society organizations in [your country]
   4.   Improve life of ordinary citizens in [your country]
   5.   Gaining influence in [your country]
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q731** For each of the following issues, please tell me if you think Chinese policy is better, American policy is better, Chinese and American policies are equally good, or Chinese and American policies are equally bad.
   1.   American policy is better
   2.   Chinese policy is better
   3.   Chinese and American policies are equally good
   4.   Chinese and American policies are equally bad
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]
**[PROGRAMMER: RANDOMIZE]**

1
SPLIT A    Protecting freedoms and rights              1  2  3  4  5  98  99

2
SPLIT B    Promoting economic development              1  2  3  4  5  98  99

3
SPLIT A    Tackling climate change                     1  2  3  4  5  98  99

4
SPLIT B    Maintaining regional security               1  2  3  4  5  98  99

5          Addressing the Israeli-Palestinian conflict 1  2  3  4  5  98  99

--- page 60 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**Q725** Do you think the foreign policies of **[INSERT LEADER]** have been very good, good, bad, or very bad for the Arab region?
   1.   Very good
   2.   Good
   3.   Neither good nor bad [INTERVIEWER: DO NOT READ]
   4.   Bad
   5.   Very bad
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]
**[PROGRAMMER RANDOMIZE ITEMS; SEE SPLITS]**

   1      United States President Joseph Biden          1   2   3   4   5   98   99
   **2**      Russian President Vladimir Putin              1   2   3   4   5   98   99
   **3**      Turkish President Recep Tayyip Erdoğan       1   2   3   4   5   98   99
   **4**      Chinese President Xi Jinping                 1   2   3   4   5   98   99
   **5**      Iranian Supreme Leader Ali Khamenei          1   2   3   4   5   98   99
   **6**      Saudi Crown Prince Mohammed bin Salman       1   2   3   4   5   98   99
   **7**      Syrian President Bashar al Assad             1   2   3   4   5   98   99
   **8**      Emirati President Mohammed bin Zayed         1   2   3   4   5   98   99

**Q736B [PROGRAMMER: COUNTRY != 9]** What do you think should be the Biden administration's number one priority in the Middle East and North Africa?
   1.   Education
   2.   Economic development
   3.   Human rights
   4.   Infrastructure
   5.   The Palestinian question
   6.   Stability and security
   7.   Fighting terrorism
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q734C [PROGRAMMER: COUNTRY!=9]** To what extent do you favor or oppose the normalization of relations between Arab states and Israel?
   1.   Strongly favor
   2.   Favor
   3.   Oppose
   4.   Strongly oppose
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

59

www.arabbarometer.org

--- page 61 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**Q738** Which solution from among the following do you prefer to put an end to the Palestinian-Israeli conflict?
**[PROGRAMMER: RANDOMIZE]**
   1.   Two states, Palestine next to Israel based on the 1967 borders
   2.   One state for Jews and Arabs
   3.   A Palestinian-Israeli confederation **[INTERVIEWER:** If asked, a "confederation" is an association of independent sovereign states which by prior agreement delegates certain powers to a common body to coordinate its policies.]
90. Other- specify: [INTERVIEWER: DO NOT READ]
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q833B [PROGRAMMER: COUNTRY ==7 AND 10]** How concerned are you that sectarian division is growing in [your country]?
   1.   Concerned to a great extent
   2.   Concerned to a medium extent
   3.   Concerned to a small extent
   4.   Not concerned at all
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q733** To what extent do you approve or disapprove of Russia's invasion of Ukraine?
   1.   Strongly approve
   2.   Somewhat approve
   3.   Somewhat oppose
   4.   Strongly oppose
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

60

www.arabbarometer.org

--- page 62 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**Q727 [PROGRAMMER: COUNTRY!= 9]** International companies were competing to get a contract from your government to build infrastructure in [your country]. These countries are:
   1.  The United States
   2.  Germany
   3.  China
   4.  Turkey
   5.  France **[PROGRAMMER: COUNTRY==10, 12, 13, 21]**
   7. UK **[PROGRAMMER: COUNTRY==7, 8, 15]**
97. None of these countries [INTERVIEWER: DO NOT READ]
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]
**[PROGRAMMER: RANDOMIZE ITEMS AND SEE SPLITS]**

 5C     Which country would you prefer to get       1   2   3   4   5/7   98   99
        the contract?
 1A     Which country would build the highest       1   2   3   4   5/7   98   99
        quality?
 2A     [PROGRAMMER: COUNTRY != 15]                 1   2   3   4   5/7   98   99
        Which country would build it for the
        least amount of money?
 4B     [PROGRAMMER: COUNTRY != 15]                 1   2   3   4   5/7   98   99
        Which country would treat the local
        workforce the best?

**Q728** To what extent do you see each of the following as a threat to the national security interests? Please tell me if you think the threat is critical, important but not critical, or not important.
   1.  Critical
   2.  Important but not critical
   3.  Not important
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]
**[PROGRAMMER: RANDOMIZE ITEMS AND SEE SPLITS]**

 1B          The development of China's economic        1   2   3   98   99
 SPLIT A     power
 2B          The development of American                1   2   3   98   99
 SPLIT B     economic power
 4A          Iran's political influence in the region   1   2   3   98   99
 SPLIT A
 4B          Saudi Arabia's political influence in the  1   2   3   98   99
 SPLIT B     region
 5A          Israeli occupation of the Palestinian      1   2   3   98   99
 SPLIT A     territories
 5B          Iran's nuclear program                     1   2   3   98   99
 SPLIT B
 7           Climate change                             1   2   3   98   99

61

www.arabbarometer.org

--- page 63 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**INTERVIEWER:** I would now like to ask you a few questions on the most recent events in Gaza and Israel.

**QGAZA1** From the following list of actions, which would you describe as an "act of terrorism"? Please select all the actions that apply. **[INTERVIEWER:** Read one response category at a time and wait for the respondent to say yes or no to it.]
[**PROGRAMMER**: **RANDOMIZE OPTIONS. SELECT ALL THAT APPLY.]**
        1.   Israel's blockade of Gaza since 2007
        2.   Hamas's launching of rockets into Israel, killing civilians
        3.   Israel's bombing of Gaza, killing civilians
        4.   Hamas's attacks on and killing of civilians in Israeli towns bordering Gaza
        5.   Israel's demand that more than a million Gazan civilians leave the northern
        cities in the Gaza Strip
        6.   Hamas's kidnapping and taking hostage more than 200 Israeli civilians
        7.   Israel's cutting off the electricity and water supply and assault on civilian
        infrastructure in Gaza
        8.   Hezbollah's attacks in Northern Israel
        9.   Israel's strikes in Syria targeting Iran and its regional proxies
        10. Iran's sending weapons to Hezbollah and Hamas
        11. Israel's strikes in Lebanon **[PROGRAMMER: COUNTRY==9]**
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**QGAZA2** In your opinion, which of the following terms do you think best describes the latest events in Gaza?
[**PROGRAMMER**: **RANDOMIZE]**
        1.   War
        2.   Mass killing
        3.   Conflict
        4.   Ethnic cleansing
        5.   Hostilities
        6.   Massacre
        7.   Genocide
90. Other SPECIFY [INTERVIEWER: DO NOT READ]
97. All of these terms [INTERVIEWER: DO NOT READ]
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**QGAZA3A [PROGRAMMER: SPLIT A]** In your opinion, to what extent do you believe that the **Israeli government** is committed to a two-state solution that equally preserves the rights and security of both Israelis and Palestinians?
        1.   To a great extent
        2.   To a medium extent
        3.   To a small extent
        4.   Not at all
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

62

www.arabbarometer.org

--- page 64 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**QGAZA3B [PROGRAMMER: SPLIT B]** In your opinion, to what extent do you believe that the **Israeli public** is committed to a two-state solution that equally preserves the rights and security of both Israelis and Palestinians?
         1.   To a great extent
         2.   To a medium extent
         3.   To a small extent
         4.   Not at all
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**QGAZA4A [PROGRAMMER: SPLIT A]** In your opinion, to what extent do you believe that **Palestinian leadership** is committed to a two-state solution that equally preserves the rights and security of both Israelis and Palestinians?
         1.   To a great extent
         2.   To a medium extent
         3.   To a small extent
         4.   Not at all
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**QGAZA4B [PROGRAMMER: SPLIT B]** In your opinion, to what extent do you believe that **Palestinian public** is committed to a two-state solution that equally preserves the rights and security of both Israelis and Palestinians?
         1.   To a great extent
         2.   To a medium extent
         3.   To a small extent
         4.   Not at all
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

--- page 65 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**QGAZA5A** Among the following parties, who do you believe is committed to defending **Palestinian rights**? Please select all that apply. **[PROGRAMMER: SELECT ALL THAT APPLY. RANDOMIZE RESPONSE CATEGORIES.]**
        1.   United States
        2.   China
        3.   Russia
        4.   Saudi Arabia
        5.   Qatar
        6.   United Arab Emirates
        7.   Turkey
        8.   European Union
        9.   United Nations
        10.  Jordan
        11.  Egypt
        12.  [YOUR COUNTRY.] **[PROGRAMMER: COUNTRY!=8]**
91. None of these parties [**INTERVIEWER:** READ THIS RESPONSE]
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**QGAZA5A2 [PROGRAMMER: IF COUNTRY==7]** And then among the following parties, who do you believe is committed to defending **Palestinian rights**? Please select all that apply. **[PROGRAMMER: SELECT ALL THAT APPLY. RANDOMIZE RESPONSE CATEGORIES.]**
    1.   Iran
    2.   South Africa
    3.   Germany
    4.   France
    5.   None of these parties [**INTERVIEWER:** READ THIS RESPONSE]
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

--- page 66 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**QGAZA5B** Among the following parties, who do you believe is committed to defending **Israeli rights**? Please select all that apply. **[PROGRAMMER: SELECT ALL THAT APPLY. RANDOMIZE RESPONSE CATEGORIES]**
   1.   United States
   2.   China
   3.   Russia
   4.   Saudi Arabia
   5.   Qatar
   6.   United Arab Emirates
   7.   Turkey
   8.   European Union
   9.   United Nations
   10.  Jordan
   11.  Egypt
   12.  [YOUR COUNTRY.] **[PROGRAMMER: COUNTRY!=8]**
91. None of these parties [**INTERVIEWER:** READ THIS RESPONSE]
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**QGAZA5C** Finally, who among the following parties do you believe is suited to broker a political solution that would be fair to both Palestinians and Israelis? Please select all that apply. **[PROGRAMMER: SELECT ALL THAT APPLY. RANDOMIZE RESPONSE CATEGORIES]**
   1.   United States
   2.   China
   3.   Russia
   4.   Saudi Arabia
   5.   Qatar
   6.   United Arab Emirates
   7.   Turkey
   8.   European Union
   9.   United Nations
   10.  Jordan
   11.  Egypt
   12.  [YOUR COUNTRY.] **[PROGRAMMER: COUNTRY!=8]**
   13.  Iran **[PROGRAMMER: IF COUNTRY==7]**
91. None of these parties [**INTERVIEWER:** READ THIS RESPONSE]
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

--- page 67 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**QGAZA6 [COUNTRY!=9]** In your opinion, to what extent do you believe the government of [YOUR COUNTRY] uses the Palestinian-Israeli conflict as a justification for the lack of reform?
         1.  To a great extent
         2.  To a medium extent
         3.  To a small extent
         4.  Not at all
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

--- page 68 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**SECTION XI: COUNTRY-SPECIFIC QUESTIONS**

**INTERVIEWER:** I would now like to ask you a few questions on events in [YOUR COUNTRY]

**IRAQ**

**QIRQ1 [PROGRAMMER: IF COUNTRY==7]** In recent years, there have been discussions about the law that allows rapists to marry their rape victims to avoid punishment. To what extent do you support or oppose repealing this law?
         1.   Strongly support repealing the law
         2.   Somewhat support repealing the law
         3.   Somewhat oppose repealing the law
         4.   Strongly oppose repealing the law
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**QIRQ2A [PROGRAMMER: SPLIT A. IF COUNTRY==7]** Of the following parties, who do you believe should have priority in deciding whether Iraqi IDPs  **who are living in camps** return to their governorates of origin?
**[PROGRAMMER: RANDOMIZE]**
         1.   IDPs themselves
         2.   Citizens from the local host community
         3.   The local government
         4.   The national government
         5.   International humanitarian organizations
90. Other_SPECIFY [INTERVIEWER: DO NOT READ]
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**QIRQ2B [PROGRAMMER: SPLIT B. IF COUNRY==7]** Of the following parties, who do you believe should have priority in deciding whether Iraqi IDPs  **who are not living in camps** return to their governorates of origin?
**[PROGRAMMER: RANDOMIZE]**
         1.   IDPs themselves
         2.   Citizens from the local host community
         3.   The local government
         4.   The national government
         5.   International humanitarian organizations
90. Other_SPECIFY [INTERVIEWER: DO NOT READ]
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

67

www.arabbarometer.org

--- page 69 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**QIRQ3 [PROGRAMMER: IF COUNTRY==7]** For each of the following rights, please tell me if you think children born to ISIS family members, with at least one parent being Iraqi should be granted rights, should be granted rights only if they have undergone a reintegration program, or should not be granted rights.
         1.   Should be granted rights
         2.   Should be granted right only if they have undergone a reintegration
         program
         3.   Should not be granted rights
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

   1        Citizenship                              1    2    3    98    99
   2        Education                               1    2    3    98    99

 **QIRQ4A [PROGRAMMER: SPLIT A. COUNTRY ==7]** Which of the following countries do you believe has the most positive impact on the domestic policies of Iraq?
**[PROGRAMMER: RANDOMIZE]**
   1.   United States
   2.   China
   3.   Iran
   4.   Saudi Arabia
   5.   Turkey
96. None of these countries has a positive impact [INTERVIEWER: DO NOT READ]
97. All of these countries have a positive impact [INTERVIEWER: DO NOT READ]
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**QIRQ4B [PROGRAMMER: SPLIT B. COUNTRY ==7]** Which of the following countries do you believe has the most negative impact on the domestic policies of Iraq?
**[PROGRAMMER: RANDOMIZE]**
   1.   United States
   2.   China
   3.   Iran
   4.   Saudi Arabia
   5.   Turkey
96. None of these countries has a negative impact [INTERVIEWER: DO NOT READ]
97. All of these countries have a negative impact [INTERVIEWER: DO NOT READ]
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

--- page 70 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**JORDAN**

**QJOR5 [PROGRAMMER: IF COUNTRY==8]** Have you heard about the cybercrime law approved by the House of Representatives?
        1.  Yes
        2.  No
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**QJOR6 [PROGRAMMER: IF COUNTRY==8. IF QJOR5==1]** What will the main effect of the cybercrime law? Do you believe it will...
        1.   Address issues, such as fraud, electronic fraud, online slander and
             humiliation, and electronic bullying
        2.   Limit freedom of expression and opinion
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**KUWAIT**

**QKUW26 [PROGRAMMER: COUNTRY==9]** In your opinion, when did the Bidoon problem start?
    1.  Since the passage of the citizenship law of 1959
    2.  Since 1985
    3.  After the liberation of Kuwait in 1991
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**QKUW27 [PROGRAMMER: COUNTRY==9]** To what extent does the problem of the Bidoon endanger national security in Kuwait?
    1.  To a great extent
    2.  To a medium extent
    3.  To a small extent
    4.  Not at all
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

--- page 71 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**QKUW28 [PROGRAMMER: COUNTRY==9]** Please tell me to what extent each of the following is an appropriate solution to the problem of the Bidoon in Kuwait.
   1.   To a great extent
   2.   To a medium extent
   3.   To a small extent
   4.   Not at all
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]
**[PROGRAMMER: RANDOMIZE]**

   1      Naturalize them all                                              1   2   3   4   98   99

   2      Naturalize only those proven to have been born in                1   2   3   4   98   99
          Kuwait

   3      Naturalize the eligible ones and deport the rest                 1   2   3   4   98   99

   4      Naturalize the eligible ones and grant the rest                  1   2   3   4   98   99
          permanent residency.

   5      Grant them all permanent residency and close the                 1   2   3   4   98   99
          file.

   6      Deport them all from the country                                 1   2   3   4   98   99

   7      Keep the situation as is                                         1   2   3   4   98   99

**QKUW29 [PROGRAMMER: COUNTRY==9]** To what extent do you support or oppose each of the following policies?
   1.   Strongly support
   2.   Somewhat support
   3.   Somewhat oppose
   4.   Strongly oppose
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]
**[PROGRAMMER: RANDOMIZE]**

   1      Forbidding naturalized citizens from the right to                1   2   3   4   98   99
          vote

   2      Forbidding naturalized citizens from the right to                1   2   3   4   98   99
          submit candidature for elections

**QKUW30 [PROGRAMMER: COUNTRY==9]** In recent years, Kuwait has witnessed political instability, which has manifested in the formation of several governments in one year and in the organization of several parliamentary elections in three years. In your opinion, who is responsible for this situation?
   1.   Government
   2.   The National Assembly
   3.   They are both responsible
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

70

www.arabbarometer.org

--- page 72 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**QKUW31 [PROGRAMMER: COUNTRY==9]** To what extent do you think each of the following measures can contribute to correcting the course in Kuwait?
   1.   To a great extent
   2.   To a medium extent
   3.   To a small extent
   4.   Not at all
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]
[PROGRAMMER: RANDOMIZE]

 1    New parliamentary elections based on the current       1  2  3  4  98  99
      election law
 2    New parliamentary elections based on a new             1  2  3  4  98  99
      election law
 3    Forming a government headed by a person from           1  2  3  4  98  99
      outside the ruling family
 4    Emiri intervention to stop the implementation of       1  2  3  4  98  99
      government decisions


**QKUW32 [PROGRAMMER: COUNTRY==9]** To what extent do you support or oppose the dissolution of the current National Assembly?
   1.   Strongly support
   2.   Somewhat support
   3.   Somewhat oppose
   4.   Strongly oppose
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**QKUW33 [PROGRAMMER: COUNTRY==9]** To what extent do you support or oppose each of the following policies?
   1.   Strongly support
   2.   Somewhat support
   3.   Somewhat oppose
   4.   Strongly oppose
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]
**[PROGRAMMER: RANDOMIZE]**

 1    Pardoning all convicts and giving them an               1  2  3  4  98  99
      opportunity for a fresh start in the new era
 2    Restoring citizenship to all from whom it was           1  2  3  4  98  99
      withdrawn because they posed a security threat
 3    Pardoning convicts is turning the page in the new       1  2  3  4  98  99
      era.

71

www.arabbarometer.org

--- page 73 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**QKUW34 [PROGRAMMER: COUNTRY==9, SELECT ALL THAT APPLY]** With which banks do you deal with in Kuwait for your accounts? [INTERVIEWER: Select all that apply]
   1. National Bank of Kuwait
   2. Gulf Bank
   3. Commercial Bank of Kuwait
   4. Al Ahli Bank of Kuwait
   5. Ahli United Bank
   6. Kuwait International Bank
   7. Burgan Bank
   8. Kuwait Finance House
   9. Boubyan Bank
   10. Warba Bank
   11. Bank of Bahrain and Kuwait
90. Other - Please specify: [INTERVIEWER: DO NOT READ]
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**QKUW35 [PROGRAMMER: COUNTRY==9]** How many mobile lines do you use?
   1. One line
   2. Two lines
   3. Three lines
   4. Four lines
   5. More than four
97. I do not have a mobile line [INTERVIEWER: DO NOT READ]
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**QKUW36 [PROGRAMMER: COUNTRY==9]** Who is the mobile phone provider of your main mobile line?
   1. Zain
   2. VIVA
   3. Ooredoo/Wataniya
90. Other- Please specify
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**QKUW37 [PROGRAMMER: COUNTRY==9]** To what degree do you agree or disagree with this statement: "I trust Kuwaiti charitable work"
   1. Strongly agree
   2. Somewhat agree
   3. Somewhat disagree
   4. Strongly disagree
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

72

www.arabbarometer.org

--- page 74 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**QKUW38 [PROGRAMMER: COUNTRY==9. RANDOMIZE RESPONSE OPTIONS]**
Which daily Arabic-language Kuwaiti newspaper do you read most?
   *1.   Al Qabas*
   *2.   Al R'aee*
   *3.   Al Anba'*
   *4.   Al Jarida*
   *5.   Al Nahar*
   *6.   Al Siyasa*
   *7.   Al Shaid*
90. Other - Please specify: [INTERVIEWER: DO NOT READ]
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**QKUW39 [PROGRAMMER: COUNTRY==9]** How do you read _______ [PROGRAMMER: INSERT ANSWER FROM QKUW38]?
   1.   In print
   2.   The newspaper's website
   3.   The newspaper's mobile application
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**QKUW40 [PROGRAMMER: COUNTRY==9]** In which of the following ways, if any, have you stood in solidarity with Gaza? Please tell me all that apply.
**[PROGRAMMER:** SELECT ALL THAT APPLY**]**
   1.   Boycotted companies that support Israel
   2.   Continuously followed up on war-related news
   3.   Participated in public solidarity activities
   4.   Broadcasted messages of solidarity via social media
   5.   Monetary relief donations to the residents of Gaza
90. Other - Please specify: [INTERVIEWER: DO NOT READ]
97. I have not taken any of these actions [INTERVIEWER: DO NOT READ]
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**QKUW41 [PROGRAMMER: COUNTRY==9]** How would you evaluate the volume of external aid provided by Kuwait?
   1.   More than it should be
   2.   Less than it should be
   3.   Appropriate as is
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

73

www.arabbarometer.org

--- page 75 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**QKUW42 [PROGRAMMER: COUNTRY==9]** The Kuwait Fund for Development provided development aid to more than 100 countries, Arab and others. How do you evaluate the amount of loans provided by the Fund?
   1.   More than it should be
   2.   Less than it should be
   3.   Appropriate as is
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**LEBANON**

**QLEB6 [PROGRAMMER: COUNTRY==10]** In your opinion, is it preferable for the system of governance in Lebanon to be:
            1.   A sectarian system like it is now
            2.   A civil / secular system
            3.   A sectarian federal system administered by regions or provinces by
            local authorities
98. Don't know [INTERVIEWER: DO NOT READ]
**99. Refused to answer [INTERVIEWER: DO NOT READ]**

**QLEB7 [PROGRAMMER: COUNTRY==10]** Would you be comfortable with authority positions that have historically been occupied by members of your sect becoming available to all other sects?
            1.   Yes
            2.   No
            3.   Maybe [INTERVIEWER: DO NOT READ]
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q220LEB [PROGRAMMER: COUNTRY==10]** To what extent do you agree with the following statement: "It is good for the Arab region that Hezbollah is getting involved in regional politics."
   1.   Strongly agree
   2.   Agree
   3.   Disagree
   4.   Strongly disagree
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**QLEB9 [PROGRAMMER: COUNTRY==10]** To what extent have the increasing prices of essential goods impacted your household's purchasing power?
   1.   To a great extent
   2.   To a medium extent
   3.   To a small extent
   4.   Not at all
98. Don't know [INTERVIEWER: DO NOT READ]
99. Decline to answer [INTERVIEWER: DO NOT READ]

74

www.arabbarometer.org

--- page 76 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**QLEB10 [PROGRAMMER: COUNTRY==10]** With the absence of the State's electricity (EDL), what is your substitute source for electricity?
   1.   Private generator
   2.   Generator subscription
   3.  Solar panels
   4.  No substitute source of energy
90. Other- specify: [INTERVIEWER: DO NOT READ]
98. Don't know [INTERVIEWER: DO NOT READ]
99. Decline to answer [INTERVIEWER: DO NOT READ]

**QLEB11 [PROGRAMMER: COUNTRY==10]** To what extent do you support or oppose E-government (applying for official documents from the Lebanese government electronically)?
         1.   Strongly support
         2.   Somewhat support
         3.   Somewhat oppose
         4.   Strongly
98. Don't know [INTERVIEWER: DO NOT READ]
99. Decline to answer [INTERVIEWER: DO NOT READ]

**QLEB12 [PROGRAMMER: COUNTRY==10]** To what extent do you support or oppose the agreement between Lebanon and the International Monetary Fund?
         1.   Strongly support
         2.   Somewhat support
         3.   Somewhat oppose
         4.   Strongly oppose
98. Don't know [INTERVIEWER: DO NOT READ]
99. Decline to answer [INTERVIEWER: DO NOT READ]

**QLEB13 [PROGRAMMER: COUNTRY==10]** In your opinion, what is the likelihood that presidential elections will be held in the next 6 months?
         1.   Very likely
         2.   Somewhat likely
         3.   Somewhat unlikely
         4.   Not likely at all
98. Don't know [INTERVIEWER: DO NOT READ]
99. Decline to answer [INTERVIEWER: DO NOT READ]

--- page 77 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**MOROCCO**

**QMOR4 [PROGRAMMER: IF COUNTRY==13]** In your opinion, how effective or ineffective have the efforts of each of the following actors been in helping victims of the earthquake?
        1.  Very effective
        2.  Somewhat effective
        3.  Somewhat ineffective
        4.  Not effective at all
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

 1          The government                    1   2   3   4   98   99
 2          Individual citizens               1   2   3   4   98   99
 3          International humanitarian        1   2   3   4   98   99
 SPLIT A    organizations
 4          Moroccan civil society            1   2   3   4   98   99
 SPLIT B    organizations

**QMOR5 [PROGRAMMER: IF COUNTRY==13]** Overall, did the government's management of the earthquake crisis exceed, meet, or fail to meet your prior expectations?
        1.  Surpassed expectations
        2.  Met expectations
        3.  Failed to meet expectations
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**QMOR6 [PROGRAMMER: IF COUNTRY==13]** Do you think government services and infrastructure will improve, stay the same, or worsen in areas affected by the earthquake?
        1.  Improve
        2.  Stay the same
        3.  Worsen
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

--- page 78 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**QMOR7 [PROGRAMMER: IF COUNTRY==13]** Did you participate in any of the following efforts to support earthquake victims? Please tell me all that apply.
**[PROGRAMMER AND INTERVIEWER: SELECT ALL THAT APPLY]**
        1.   Did not participate [INTERVIEWER: DO NOT READ. Select only if
             respondent does not choose any other answer. PROGRAMMER: CANNOT BE
             COMBINED WITH ANY OTHER RESPONSE.]
        2.   Made a financial donation [INTERVIEWER: If asked, includes directly to
             someone affected or to a civic association or the government fund for the
             earthquake]
        3.   Contributed my effort and time to directly help those affected
        4.   Provided non-financial assistance (clothes/food/others)
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

 **QMOR8 [PROGRAMMER: IF COUNTRY==13]** To what extent would you support or
oppose each of the following policies:
        1.   Strongly support
        2.   Somewhat support
        3.   Somewhat oppose
        4.   Strongly oppose
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

        1        Allocating part of the national budget to providing earthquake victims with compensation for damaged property                                    1   2   3   4   98   99

        2        Passing a new law requiring earthquake-resistant building standards, even if it increased building time and costs                                1   2   3   4   98   99

        3A       The government's requesting foreign aid to address the effects of the earthquake                                                                1   2   3   4   98   99
        SPLIT A

        3B       The government's refusing foreign aid to address the effects of the earthquake                                                                  1   2   3   4   98   99
        SPLIT B

77

www.arabbarometer.org

--- page 79 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**PALESTINE**

**QPAL6 [PROGRAMMER: IF COUNTRY==15]** If new presidential elections were to take place today, and the competition was between Marwan Barghouti, Ismail Haniyeh, and Mahmoud Abbas, for whom would you vote?
   1. Marwan Barghouti
   2. Ismail Haniyeh
   3. Mahmud Abbas
97. I would not participate
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**QPAL9 [PROGRAMMER: COUNTRY==15]** To whom did you vote in the last parliamentary elections on 25 January 2006?
   1. Alternative list (Coalition between the Democratic Front for the Liberation of Palestine, the Palestinian People's Party, the Palestine Democratic Union (Fida), and independents)
   2. Independent Palestine
   3. Abu Ali Mustafa
   4. Abu al Abbas
   5. Freedom and social justice
   6. Change and reform
   7. National coalition for justice and democracy
   8. Third way, headed by Salam Fayyad
   9. Freedom and independence
   10. Palestinian justice
   11. Fateh
96. None of the above
97. I did not vote
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

--- page 80 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**QPAL10 [PROGRAMMER: COUNTRY==15]** If new elections agreed to by all factions are held today and the same lists that took part in the last PLC elections on 25 January 2006 were nominated, for whom would you vote?
   1.  Alternative list
   2.  Independent Palestine
   3.  Abu Ali Mustafa
   4.  Abu al Abbas
   5.  Freedom and social justice
   6.  Change and reform
   7.  National coalition for justice and democracy
   8.  Third way, headed by Salam Fayyad
   9.  Freedom and independence
   10. Palestinian justice
   11. Fateh
96.  None of the above
97.  I would not vote
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**QPAL11 [PROGRAMMER: IF COUNTRY==15]** From among the following vital national goals, which in your view should be the first most important one and which should be the second most important goal that the Palestinian people should strive to achieve? **[PROGRAMMER: Please allow for two answers:  QPAL11_1** First goal **, QPAL11_2** Second goal**]**
   1.  Israeli withdrawal to the 1967 borders and the establishment of a Palestinian state in the West Bank and the Gaza Strip with East Jerusalem as its capital
   2.  Obtain the right of return to refugees to their 1948 towns and villages
   3.  Establish a democratic political system that respects freedoms and rights of Palestinians
   4.  Build a pious or moral individual and a religious society, one that applies all Islamic teachings
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**QPAL18 [PROGRAMMER: IF COUNTRY==15]** Can West Bank and Gaza Strip Palestinians today elect their own leadership in parliamentary and presidential election?
   1.  Yes
   2.  No
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

79

www.arabbarometer.org

--- page 81 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**QPAL19 [PROGRAMMER: IF COUNTRY==15 AND IF QPAL18==2].** If the answer is no, from among the following possible reasons, which in your view is the most likely to actually cause this?
   1. The Split between West Bank and the Gaza Strip makes it difficult to hold elections simultaneously in the West Bank and the Gaza Strip
   2. Israel does not allow elections in East Jerusalem as required by the Oslo agreement
   3. The PA leadership in the West Bank is afraid of losing the elections
   4. Hamas leaders are afraid of losing control over the Gaza Strip
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**QPAL20 [PROGRAMMER: IF COUNTRY==15]** Some people say that the Palestinian Authority has become a burden on the Palestinian people while others say that it is an accomplishment for the Palestinian people. What do you think?
   1. The PA is an accomplishment for the Palestinian people
   2. The PA is a burden on the Palestinian people
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**QPAL21 [PROGRAMMER: IF COUNTRY==15]** If it were up to you, would you want to have Abbas resign or not resign?
   1. Certainly resign
   2. Resign
   3. Not resign
   4. Certainly not resign
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

--- page 82 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**SECTION XII: DEMOGRAPHICS**

**Q1001A** Which governorate are you from?
         1. **List varies by country**
94. I am not from [your country] specify country of birth: _________ [INTERVIEWER: DO NOT READ]
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q1003** What is your highest level of education?
      1.  No formal education
      2.  Elementary
      3.  Preparatory/Basic
      4.  Secondary
      5.  Mid-level diploma/professional or technical
      6.  BA
      7.  MA and above
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q1010** What is your current social status?
      1.  Single/ Bachelor
      2.  Living with a partner [INTERVIEWER: DO NOT READ; **PROGRAMMER**: **COUNTRY!=12**]
      3.  Engaged
      4.  Married
      5.  Divorced
      6.  Separated **[PROGRAMMER: COUNTRY!=12]**
      7.  Widowed
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q1010B1 [PROGRAMMER: IF Q1010==4,5,6,or 7]** Do you have children?
      1.  Yes
      2.  No
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q1001F** Are you the head of the household in your current place of residence?
      1.  Yes
      2.  No
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q1001G** Do you currently rent or own your current place of residence?
      1.  Rent
      2.  Own
99. Refused to answer [INTERVIEWER: DO NOT READ]

81

www.arabbarometer.org

--- page 83 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**Q1001H [PROGRAMMER: IF 1001G==2]** Do you currently have a mortgage or bank loan that you are paying off on your home?
   1.   Yes
   2.   No
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q1001E [PROGRAMMER: Q1001 <= 60 OR Q1010==4] Do the following individuals live in the same house as you do:**
   1.   Yes
   2.   No
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

      1      [PROGRAMMER: IF Q1001 <=60]       1   2   98   99
             Parents
      2      [PROGRAMMER: IF Q1010==4]         1   2   98   99
             In-laws
      3      [PROGRAMMER: IF Q1010B1==1]       1   2   98   99
             Your children

**Q1005**. Are you...
   1.   Employed
   2.   Self-Employed
   3.   Retired
   4.   A housewife
   5.   A student
   6.   Unemployed and/or looking for work [**INTERVIEWER:** If the respondent is
        currently employed and looking for work, please select response option 1]
90. Other- specify: [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q1005B [PROGRAMMER: IF Q1005==3]** You said you were retired. Do you receive a pension?
   1.   Yes
   2.   No
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [DO NOT READ]

**Q1006 [PROGRAMMER:  IF Q1005 == 1 OR 2]** Do you work full time or part time?
   1.   Full time
   2.   Part time
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [DO NOT READ]

82

www.arabbarometer.org

--- page 84 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**Q1006A [PROGRAMMER: IF Q1005 == 1 OR 2]** And what sector do you work in? Do you work in the…
   1.   …public sector
   2.   …private sector
90. Other- specify: [INTERVIEWER: DO NOT READ]
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q1006B_2 [PROGRAMMER: ALL COUNTRIES AND Q1005==1 OR 2]** In a few words, can you tell me what industry you work in? You can say things like construction, education, agriculture, restaurant/food services. **[INTERVIEWERS:** *Do not read. Please select the category from the list*.]
   1.   Agriculture, livestock rearing, fishing
   2.   Arts and entertainment
   3.   Beauty and salon services
   4.   Exploration and drilling
   5.   Industry
   6.   Electricity, gas and water
   7.   Construction work
   8.   Wholesale and retail sale, auto repair
   9.   Hotels, restaurants, tourism
   10.  Transportation and warehousing
   11.  Financial intermediation, brokerage
   12.  Real estate, leasing and business
   13.  Government, public administration, and defense
   14.  International organizations and agencies
   15.  Local nongovernmental or nonprofit work
   16.  Education and research
   17.  Health and social work
   18.  Information technology and communication
   19.  Media and journalism
90. Other- specify: [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q1021 [PROGRAMMER: IF Q1005==1 OR 2]**
Which of the following best describes your main source of monthly income?
   1.   A salary/ a fixed amount each month
   2.   Hourly income with hours that are mostly stable each month
   3.   Hourly income with hours that vary from month to month
   4.   Profits from sales that are mostly stable each month
   5.   Profits from sales that vary from month to month
   6.   Income from rent or other financial products
90. Other- specify: [INTERVIEWER: DO NOT READ]
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

83

www.arabbarometer.org

--- page 85 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**Q1005C [PROGRAMMER ALL COUNTRIES: IF Q1005==6]**
Are you looking for a job?
   1. Yes
   2. No
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q1005D [PROGRAMMER: IF Q1005C==2]**  Why are you not looking for a job?
**[PROGRAMMER: RANDOMIZE] [INTERVIEWER:** Read responses**]**
   1. No jobs available
   2. Salaries are too low
   3. No jobs for my specialization
   4. Family obligations prevent me
   5. I am not allowed
90. Other- specify: [INTERVIEWER: DO NOT READ]
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q1030  PROGRAMMER: IF Q1005==4, 5, or 6]**  Have you ever had a job in the past?
   1. Yes
   2. No
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q1034**  Who, if any, female members of your family ever worked for pay?
**[Interviewer: SELECT ALL THAT APPLY]**
   1. None worked
   2. Mother
   3. Grandmother
   4. Daughter
   5. Sister
   6. Aunt
   7. Cousin
   8. Mother-in-Law **[PROGRAMMER: IF Q1010==4]**
   9. Wife **[PROGRAMMER: IF Q1002==1]**
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q1035 [PROGRAMMER: IF Q1030==1]**  Do you intend to go back to work in the future?
   1. Yes
   2. No
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

--- page 86 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**Q1025** Do you have a bank account?
   1.   Yes
   2.   No
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q116** Do you have any savings?
[**INTERVIEWER:** If asked, this includes all types of gold or cash—whether or not it is in a bank]
   1.   Yes
   2.   No
98. Don't know (Do not read)
99. Refused to answer (Do not read)

**Q1014A** [**PROGRAMMER: MAX = ANSWER TO Q1014**].
How many adults aged 18 years and over are living in your household work?
[**INTERVIEWER**: IF ASKED, SPECIFY EITHER FULL-TIME OR PART-TIME]

____ number of working adults **[PROGRAMMER: INTEGER VALUES ONLY]**
99    . Refused to answer [INTERVIEWER: DO NOT READ]

**Q1014B [PROGRAMMER: ALL; ALLOW INTEGER VALUES ONLY]** How many youth under the age of 18 living in your household work? [**INTERVIEWER**: IF ASKED, SPECIFY EITHER FULL-TIME OR PART-TIME]

____ number of youth **[PROGRAMMER: INTEGER VALUES ONLY]**
97. There are no youth under the age of 18 in this household
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q1015**   Monthly household income in local currency
**N______________**
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

--- page 87 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**Q1015A [PROGRAMMER: IF Q1015== 98 or 99]** Is your net monthly household income less than or greater than **[MEDIAN INCOME IN LOCAL CURRENCY]**?
[**INTERVIEWER:** Please read the number value in the question text in place of the word "median" in the response categories]
**[PROGRAMMER:**
**IF COUNTRY==7,** IQD 1,200,000
**IF COUNTRY==8**, JD 650
**IF COUNTRY==9,** KWD 1,500
**IF COUNTRY==10,** LBP 3,500,000
**IF COUNTRY==12,** USD 150
**IF COUNTRY==13,** MAD 5,000
**IF COUNTRY==15,** USD 250
**IF COUNTRY==21,** TND 1,600**]**
   1.   Less than [median]
   2.   [Median] or more
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q1016** Which of these statements comes closest to describing your net household income?
   1.   Our net household income covers our expenses and we are able to save.
   2.   Our net household income covers our expenses without notable difficulties.
   3.   Our net household income does not cover our expenses; we face some difficulties.
   4.   Our net household income does not cover our expenses; we face significant difficulties.
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q1010C [PROGRAMMER: IF Q1012==1 & Q1010==2, 3, 4 & Q1002 == 1. COUNTRY != 9]**
Does your spouse wear the hijab?
   1.   Yes
   2.   No
   3.   Niqab [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

**Q1010D_1 [PROGRAMMER: IF Q1012==1 AND Q1002 == 2. COUNTRY!=9]**
**[INTERVIEWER:** Ask women who are wearing the hijab or niqab. If not applicable, select 97]. Do you always wear the hijab when you are out in public?
   1.   Yes
   2.   No
97. NA: Respondent is not wearing the hijab.
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

86

www.arabbarometer.org

--- page 88 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**Q1010D_2 [PROGRAMMER: IF Q1012==1 & Q1002 == 2. COUNTRY!=9]**
**[INTERVIEWER:** Ask women who are not wearing the hijab or niqab. If not applicable, select 97]. Have you ever worn the hijab?
   1.  Yes
   2.  No
   3.  Niqab [INTERVIEWER: DO NOT READ]
97. NA: Respondent is wearing the hijab.
98. Don't know [INTERVIEWER: DO NOT READ]
99. Refused to answer [INTERVIEWER: DO NOT READ]

www.arabbarometer.org

--- page 89 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

APPENDIX 1: Q1 GOVERNORATE CODES AND LABELS
         IRAQ                        LEBANON                      PALESTINE
70001    Baghdad              100001  Akar                 150001  Bethlehem
70002    Salahaddin           100002  Baalbek              150002  Deir al Balah
70003    Diyala               100003  Beirut               150003  Gaza
70004    Wasit                100004  Bekaa                150004  Hebron
70005    Maysan               100005  El Nabatiyeh         150005  Jabalia
70006    Basra                100006  Mount Lebanon        150006  Jerusalem
70007    Dhi Qar              100007  North                150007  Jenin
70008    Muthana              100008  South                150008  Jerico
70009    Qadisiyah                                         150009  Khan Yunis
70010    Babylon                       MAURITANIA          150010  Nabulus
70011    Karbala              120001  Adrar                150011  Qalqilya
70012    Najaf                120002  Assaba               150012  Rafah
70013    Anbar                120003  Brakna               150013  Ramallah
70014    Nineveh              120004  Dakhlet Nouadhibou   150014  Salfit
70015    Dohuk                120005  Gorgol               150015  Tubas
70016    Erbil                120006  Guidimaka            150016  Tulkarem
70017    Kirkuk               120007  Hodh Ech Chargui              TUNISIA
70018    Sulaymaniyah         120008  Hodh El Gharbi       210001  Tunis
                              120009  Inchiri              210002  Ariana
          JORDAN              120010  Nouakchott-Nord      210003  Ben Arous
80011    Amman                120011  Nouakchott-Ouest     210004  Manouba
80012    Al Balqa             120012  Nouakchott-Sud       210005  Nabeul
80013    Azurqa               120013  Tagant               210006  Zaghouan
80014    Madaba               120014  Tiris Zemmour        210007  Bizerte
80021    Irbid                120015  Trarza               210008  Beja
80022    Al Mafraq                                         210009  Jendouba
80023    Jerash                        MOROCCO             210010  Kef
80024    Ajioun               130001  Tanger-Tetouan-Al Hoceima  210011  Siliana
80031    Karak                130002  Oriental             210012  Sousse
80032    Tafila               130003  Fès-Meknès           210013  Monastir
80033    Ma'an                130004  Rabat-Salé-Kénitra   210014  Mahdia
80034    Aqaba                130005  Béni Mellal-Khénifra 210015  Sfax
                              130006  Grand Casablanca-Settat  210016  Kairouan
          KUWAIT              130007  Marrakech-Safi       210017  Kasserine
90001    Al Asimah            130008  Drâa-Tafilalet       210018  Sidi Bouzid
90002    Ahmadi               130009  Sousse-Massa         210019  Gabes
90003    Farwaniya            130010  Guelmim-Oued Noun    210020  Medenine
90004    Jahra                130011  Laayoune-Sakia El Hamra  210021  Tatouine
90005    Hawalli              130012  Eddakhla-Oued Eddahab  210022  Gafsa
90006    Mubarak Al-Kabeer                                 210023  Tozeur
                                                           210024  Kebili

88

www.arabbarometer.org

--- page 90 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

**APPENDIX 2: Q503A_1 POLITICAL PARTIES CODES AND LABELS**

                                    IRAQ
10703        Kurdistan Democratic Party الحزب الديمقراطي الكردستاني
10704        Al-Fatah Alliance تحالف الفتح
10709        Victory Alliance ائتلاف النصر
107010       State of Law Coalition ائتلاف دولة القانون
107011       Nation Wisdom Movement تيار الحكمة
107012       National Forces Aliance تحالف القوى الوطنية
107013       Iraqi Shi'a Islamic national movement التيار الصدري(التيار الوطني الشيعي)
107014       Rights Movement حركة حقوق
107015       Tishreen Movement تشرينون
107016       Islamic Virture Party حزب الفضيلة
107017       Awareness Movement حركة وعي
107018       Al-Takadum Movement تحالف تقدم
107019       Azem Alliance تحالف عزم
107020       Kadmon قادمون
107021       Patriotic Union of Kurdistan الاتحاد الكردستاني
107022       New Generation Movement حركة الجيل الجديد
107023       Kurdistan Islamic Union الاتحاد الاسلامي الكردستاني
107024       Kurdistan Justice Group جماعة العدل الكوردستانية
107025       Kurdistan Social Democratic Party الحزب الاشتراكي الديمقراطي الكردستاني
107026       Iraqi Turkmen Front الجبهة التركمانية العراقية
107027       Kurdistan Toilers' Party حزب كادحي كردستان
107028       Iraqi Harmony Party الوئام العراقي

                                    JORDAN
10801        Islamic Action Front (IAF) جبهة العمل الإسلامي
10802        Jordanian Communist Party الاردنى الحزب الشيوعى
10803        Al-Ba'ath Arab Socialist Party in Jordan (JASBP) حزب البعث العربي الاشتراكي الأردني
10804        The Jordanian People Democratic Party (HASHD) حزب الشعب الديمقراطي الأردني
10805        Jordanian Democratic Popular Unity Party حزب الوحدة الشعبية الديمقراطي الأردني
10806        Al-Mustaqbal (Future) Party حزب المستقبل
10807        Jordanian Progressive Party الحزب التقدمي الأردني
10808        National Current Party حزب التيار الوطني
10809        Freedom Party (Al-Ahrar) حزب أحرار الأردن
108010       National Congress Party (Zamzam) (زمزم) حزب المؤتمر الوطني

89

www.arabbarometer.org

--- page 91 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

LEBANON
101001        Amal Movement حركة أمل
101002        Free Patriotic Movement التيار الوطني الحر
101003        Future Movement تيار المستقبل
101004        Hezbollah حزب الله
101005        The Phalange (Kataeb Party) حزب الكتائب اللبنانية
101006        Lebanese Forces القوات اللبنانية
101007        Progressive Socialist Party الحزب التقدمي الاشتراكي
101008        Lebanese Democratic Party الحزب الديمقراطي اللبناني
101009        Popular Nasserist Organization (PNO) التنظيم الشعبي الناصري
1010010       Tashnag حزب الطاشناق- الإتحاد الثوري الأرمني

MAURITANIA
101201        Union for the Republic (UPR) الاتحاد من أجل الجمهورية
101202        National Rally for Reform and Development (RNRD) (التجمع الوطني للإصلاح و التنمية (تواصل
101203        Union for Democracy and Progress (UDP) الاتحاد من أجل الديمقراطية و التقدم
101204        Union of the Forces of Progress (UFP) اتحاد قوى التقدم
101205        Mauritanian Party of Union and Change (HATEM) (الاتحاد و التغيير الموريتاني (حاتم
101206        National Pact for Democracy and Development (ADIL) العهد الوطني من أجل الديمقراطية و التنمية ((عادل
101207        National Democratic Alliance (AND) التحالف الوطني الديمقراطي
101208        Dignity and Action Party (DPA) حزب الكرامة
101209        People's Progressive Alliance (APP) التحالف الشعبي التقدمي
1012010       El Wiam (PEDS) الوئام

MOROCCO
101301        Authenticity and Modernity Party (PAM) حزب الأصالة والمعاصرة
101302        Justice and Development Party (PJD) حزب العدالة والتنمية
101303        Istiqlal Party حزب الاستقلال
101304        National Rally of Independents (RNI) التجمع الوطني للأحرار
101305        Popular Movement (MP) الحركة الشعبية
101306        Constitutional Union (UC) الاتحاد الدستوري
101307        Socialist Union of Popular Forces (USFP) الاتحاد الاشتراكي للقوات الشعبية
101308        Party of Progress and Socialism (PPS) حزب التقدم والاشتراكية
101309        Democratic and Social Movement (MDS) الحركة الديمقراطية الاجتماعية
1013010       Unified Socialist Party (PSU) الحزب الإشتراكي الموحد

90

www.arabbarometer.org

--- page 92 ---

Arab Barometer Wave VIII (2023-2024)
Questionnaire

                              PALESTINE
101501              فتح | Fatah
101502              حماس | Hamas
101503   الجبهة الديموقراطية لتحرير فلسطين | Democratic Front for the Liberation of Palestine (DFLP)
101504         المبادرة الوطنية الفلسطينية | Palestinian National Initiative
101505      الجبهة الشعبية لتحرير فلسطين | Popular Front for the Liberation of Palestine (PFLP)
101506       الاتحاد الديمقراطي الفلسطيني | Palestinian Democratic Union (FIDA)
101507                  حزب التحرير | Hizb Ut-Tahrir
101508       جبهة النضال الشعبي الفلسطيني | Palestinian Popular Struggle Front (PPSF)
101509      حركة الجهاد الإسلامي في فلسطين | Islamic Jihad Movement in Palestine (PIJ)
1015010             حزب الشعب الفلسطيني | Palestinian People's Party (PPP)

                               TUNISIA
102101            حزب حركة النهضة | Ennahdha
102102                 أفاق تونس | Afek Tounes
102103              الحزب الجمهوري | Al Jomhouri
102104    حزب العمل الوطني الديمقراطي | Parti du travail patriotique et démocratique (PTT)
102105              حركة نداء تونس | Nidaa Tounes
102106         المسار الديمقراطي الاجتماعي | Voie démocratique et sociale (Al Massar) Social Democratic Path
102107      الجبهة الشعبية لتحقيق أهداف الثورة | Popular Front (ej-Jabha)
102108          المؤتمر من أجل الجمهورية | Congress for the Republic
102109   التكتل الديمقراطي من أجل العمل والحريات | Democratic Forum for Labour and Liberties (Ettakatol)
1021010           الاتحاد الوطني الحر | Free Patriotic Union (UPL)

91

www.arabbarometer.org

--- page 93 ---

ABOUT ARAB BAROMETER

Arab Barometer is a nonpartisan research network that provides
insight into the social, political, and economic attitudes and values of
ordinary citizens across the Arab world.

We have been conducting rigorous, and nationally representative
public opinion surveys on probability samples of the adult
populations across the Arab world since 2006 across 15 countries.

We are the longest-standing and the largest repository of publicly
available data on the views of men and women in the MENA region.
Our findings give a voice to the needs and concerns of Arab publics.

ARABBAROMETER.ORG          ARABBAROMETER          @ARABBAROMETER
