# ESS12-source-questionnaire

- **source**: ESS12-source-questionnaire.pdf
- **model**: us.anthropic.claude-sonnet-4-6
- **dpi**: 150
- **pages**: 105

--- page 1 ---

ESS DOCUMENT DATE: 06.02.2025

ALERTS TAKEN ON BOARD: 01 (13.12.2024), 02 (06.02.2025)

SOURCE
QUESTIONNAIRE

Round 12

2025-2026

--- page 2 ---

Q#          Topics

Self-
completion      S1-S6       Self-completion cover page; Next-birthday verification; age
introduction                check

Core            A1 – A89b   Media use; Internet use; social trust; politics, including:
                            political interest, trust, electoral and other forms of
                            participation, party allegiance, socio-political orientations,
                            authoritarianism, immigration; subjective wellbeing, social
                            exclusion, crime, religion, perceived discrimination, national
                            and ethnic identity, climate change, vote intention in EU
                            referendum.

Core            B1 – B60    Socio-demographic profile, including: household composition,
                            sex, age, marital status, type of area, education & occupation
                            of respondent, partner, parents, union membership, income
                            and ancestry.

Rotating
module          C1 – C30    Wellbeing

Rotating
module          D1 – D30d   Immigration

Core            E1 – E20    Human values scale

Survey
experience      F1-F6       Self-completion survey experience questions.
questions

Recontact
questions       G1-G6       Recontact questions

Closing
questions       H1-H3       Administrative questions for paper self-completion and
                            incentives

Interviewer
questionnaire   Section J   Interviewer self-completion questions

--- page 3 ---

NOTE

The Round 12 source questionnaire has been adapted for use in face-to-face interviews as well as web and paper self-completion. This document should be used as the basis of programming for all modes. A separate document for face-to-face programming only will be provided separately.

Question numbering has been changed compared to previous rounds, adopting the convention used for self-completion paper questionnaires in Round 10. Section A now comprises the bulk of the ESS core questionnaire (previously Sections A, B, C in the Round 11 questionnaire). Section B now comprises of questions concerning socio-demographic profile (previously Section F). Sections C and D comprise of Round 12's rotating modules. Section E comprises of the Human Values Scale (previously Section H). New sections of self-completion survey experience questions (Section F) and self-completion closing questions (Section H) have been added. Recontact questions are now Section G (previously Section R). The interviewer questionnaire (Section J) has been retained for face-to-face.

The Human Values Scale (now Section E) has been changed for Round 12. It now includes 20 rather than 21 items. The wording of all items has been changed from Round 11, meaning that new translations are needed. The response options remain unchanged and existing translations for these should be used. This is also now a single gender-neutral version of the questions rather than having separate versions for male and female respondents.

Section S is a new section for Round 12 comprising of introductory text and questions for self-completion web and paper. Many elements of Section S are country specific such as the name of the survey, whether conditional incentives are used, questions to include if the next-birthday method is being used, and the age threshold for parental permission. Be sure to adapt this section to each country-specific context.

Response options are displayed concurrently for self-completion and face-to-face (F2F) modes in a table format. The column 'all modes' denotes response options common to all modes, whereas the F2F column denotes response options only used in F2F. The Round 12 questionnaire incorporates new symbols to distinguish certain instructions across modes. National CAPI programmers should use the table below as a reference throughout the document.

Bracket Type                    Meaning
         Square brackets [ ]    Texts that need to be adapted to national contexts
          Round brackets ( )    Unprompted response options in F2F interviewing
          Curly brackets { }    Elements that need to be tailored based on previous
                                responses in CAWI and CAPI scripting.
        Greater than arrow >    Denotes that text to be displayed in web self-completion
                                should appear alone on one screen.
           **Validation text    Denotes validation text for web self-completion. These should
                                be programmed for CAPI also. Does not allow a respondent
                                to proceed with the text that has been provided.
    *Soft check validation text  Denotes soft check validation text for web self-completion
                                only. Soft-checks prompt the respondent once to answer but
                                then allow them to proceed with no answer.

Unprompted response options to be used in F2F interviewing – codes that allow for answers respondents might give but should not be read out or offered and must never appear on the showcard – are denoted in round brackets (). Unprompted F2F response options should be programmed in the CAPI script with round brackets. Rare instances where a response option in self-completion should be unprompted in F2F is denoted using round brackets around the entire response option in the 'all modes' column. In these instances,

2

--- page 4 ---

round brackets should be programmed in the CAPI script, but round brackets must not be visible to respondents in self-completion web and paper.

'Refusal' and 'Don't know' responses are unprompted in F2F and are not used in self-completion web and paper, aside from questions A85, A86, A87, A88, B42, B53, B54, B55, B56, B57, and B58 which have the response option of 'Prefer not to answer' (equivalent to 'Refusal') for both self-completion modes. **For questions A85, A86, A87, A88, B42, B53, B54, B55, B56, B57, and B58, the usual (Refusal) option must not be programmed in CAPI. '(Prefer not to answer)' must take the place of '(Refusal)' as an unprompted response option for these questions. '(Prefer not to answer)' should use the same code number that would usually be assigned to '(Refusal)'.**

'Refusal' and 'Don't know' response options are otherwise present in every question in F2F except for B3, HHname (sex of respondent, name of household members), and Section G. Section J includes 'Don't know' response options but not 'Refusal' options. A respondent is allowed to skip questions in self-completion which yields a response of 'No answer'.

Please take note of the font face used throughout the questionnaire. Text should be translated and programmed in the same font face as it is presented. Question text is shown throughout the questionnaire in **bold**. **Bold** question text should either be displayed in **bold** on screen in web self-completion, the CAPI script, or in bold on the paper questionnaire in paper self-completion. Some bold text is **underlined** for emphasis, this should also be translated and programmed as such. Text shown throughout the questionnaire in *italics* is not to either be displayed in self-completion questionnaires or revealed to respondents. Showcard numbers (e.g. *CARD 1*) are in italics and should be programmed in the CAPI script only.

Where applicable, question routing is shown in a third column. **These routing instructions are applicable to all modes, but should only be displayed, verbatim, in paper self-completion.** Where routing instructions should be applied to face-to-face and web self-completion, but not displayed in paper self-completion, this column is labelled F2F & SC WEB routing.

Compared to previous rounds, the phrase 'using this card' has been removed from all questions.

Throughout the questionnaire, annotations (footnotes) are provided to aid translation and questionnaire implementation. In some cases, these aim to avoid ambiguity by providing definitions and clarification about the concept behind questions, especially where the words themselves are unlikely to have direct equivalents in other languages. In other cases, the annotations provide operational instructions. Annotations should NOT be translated. **Under no circumstances should they appear in the questionnaires given to interviewers or displayed to respondents in self-completion.**

Questions where face-to-face wording has been changed from Round 11 are also denoted by footnotes. **In Section B many questions have been slightly adapted so please take care to ensure translations are not copied verbatim from previous rounds.**

Other questions are to be adapted – in part or in their entirety – to the national context (e.g. [country] should be replaced with the country name such as Britain or the UK, and [country nationality] replaced with adjective for nationality such as British, values should be in the local currency, etc.), or require tailoring/filtering based on answers given to previous questions. These elements are highlighted in grey or placed within a grey box, both in the source questionnaire and in the source showcards. Text highlighted in grey and between [square brackets] must be adapted to national contexts and in some cases is optional to include. Text highlighted in grey and between {curly brackets} identifies elements that need to be tailored based on previous responses in CAWI and CAPI scripting only. Take appropriate action regarding text highlighted in grey so that the correct wordings are introduced into the CAPI programme and shading is removed from any showcards after adaptation to the national context.

Additional programming instructions, including routing instructions for the CAPI and CAWI scripts, are in **bolded blue font**. **These instructions should not be presented to respondents by interviewers, nor should they appear in the paper or web questionnaire.** These instructions should be translated by country teams that will produce their own CAPI scripts for programming purposes by national teams or agencies.

3

--- page 5 ---

**Question numbers should only be displayed to the respondent in paper self-completion and CAPI. Section titles should only be displayed in paper-self completion (but not CAPI or CAWI) and should be translated.** Question numbers in bolded blue font should not be displayed in any mode. Variable names for separate text snippets that are not questions, such as introductory text at the beginning of the questionnaire or transition screens in web self-completion, are in **bolded light blue font** and should not be displayed in any mode nor translated. Further programming instructions specifically for Centerdata's use in central programming of the self-completion platform are in **bolded light blue font** and should not be displayed in any mode nor translated.

Instructions for validation text, which is only used in web self-completion, are also presented in bolded blue font. Validation text that does not allow the respondent to proceed with the text that has been entered should be programmed in **bolded red font**, with the acceptable field range denoted by **. Soft check validation text that is only shown, one time, if the respondent hasn't answered should be programmed in **bolded green font**. All validation text should be translated.

All questions and response options must be displayed in the order they are presented in this questionnaire. **For web self-completion and CAPI scripts, all questions should be displayed with vertical scales,** whereas the presented scale orientation in the source questionnaire should be retained for paper self-completion and face-to-face showcards. Corresponding code numbers for each response option should generally not be displayed in web self-completion except for questions where only endpoints are labelled, such as all 11-point scales. Question and response list order should **not** be randomised unless this is specified in the questionnaire.

For web self-completion, start/end dates and times should be recorded for each section automatically by the system where possible.

In many questions, "they/them/their" is not meant in the sense of plural, but in the sense of a gender-neutral pronoun. This exists in English, but does not exist in many other languages. If this option does not exist in your language, please translate by using the most gender-neutral way of expression. This may be using, e.g., "this person", "he/she", or only the pronoun corresponding to the grammatical gender of "person" in the respective languages, or another solution depending on target language.

--- page 6 ---

SECTION S
Text and questions presented before Section A only apply to SC WEB AND PAPER.

CoverIntroText (SC PAPER COVER PAGE)

   **[NAME OF SURVEY]**

   We are asking for your help. Each year a carefully selected sample of [households/individuals] is
   asked to complete a survey about life in [country]. This year we ask for your views on topics such as
   the area where you live, how well the government is doing its job, and about the environment.

   [The survey should be completed by the person in your household aged 15 or over who has the
   NEXT birthday.]

   Not everyone will need to answer all the questions in this booklet and if you prefer you can answer the
   survey online (the letter sent with this questionnaire explains how to do that).

   Thank you for taking part in the survey.

CoverContactInfo

   **Any Questions?**

   If you have any questions about this questionnaire, or about the [NAME OF SURVEY], please contact
   us using the details below.
   Tel: **[Telephone No.]**
   e-mail: **[e-mail address]**
   or visit **[www.europeansocialsurvey.org]**

   All responses will be treated in the strictest confidence and in accordance with the General Data
   Protection Regulation (GDPR).

**\*\*Validation text if someone's IP address has been blocked:
You are currently blocked from starting the survey. Please contact [Name, Telephone No., email
address] if you require assistance.**

SC WEB LOG IN PAGE

Please log in.

Enter your access code here

Start questionnaire

**\*\*Validation text: if access code does not exist for this survey
Incorrect access code. Please check that you have entered the code correctly as it appears on the
letter you received from us. Please contact [Name, Telephone No., email address] if you require
assistance.**

WebIntroText (SC WEB WELCOME PAGE)

**Welcome to [NAME OF SURVEY].**

Thank you for taking part in the survey.

[As a token of appreciation, we will send you a [specify incentive] when we receive your completed
questionnaire.]

5

--- page 7 ---

- You may decline to answer questions by pressing the **Next** button

   - You can return to questions you've answered already by pressing Previous

   - If you exit the survey and re-enter with your access code, you will return to where you left off


To start the survey, press the **Next** button

Intro_Paper (SC PAPER INTRODUCTION)

**We are very grateful that you are taking the time to complete our questionnaire.**

**Please complete the questionnaire using BLACK or BLUE INK.**

**If you do not know the answer to a question or would prefer not to give an answer, you may leave the question blank.**

**If you make a mistake or change your mind, please completely fill the box or circle [image] to show the mistake and then tick the correct answer.**

**ANSWER THESE QUESTIONS FIRST:**

ASK S1-S4 IF USING ADDRESS-BASED SAMPLE
ASK ALL SC WEB AND PAPER
 *SC WEB INSTRUCTIONS:*
The survey is to be completed by the person aged 15 or over in your household who has the next birthday.

**SC WEB AND PAPER ONLY**
S1     **Are you the person aged 15 or over in your household who has the NEXT birthday?**

SC WEB AND PAPER          Routing for SC WEB only
              Yes  1    Go to S5
              No   2    Go to S2

*SC PAPER INSTRUCTIONS:*
     **IF 'NO'**: Please ask the person aged 15 or over who has the next birthday to complete the survey. When they start, they should change the answer above to 'Yes'.

**SC WEB ONLY. IF S1=2**
**S2**
As stated in the letter you received, we need the person with the **NEXT** birthday to complete the survey.

Please pass the invitation letter to the person (aged 15 or over) in your household with the **NEXT** birthday and ask them to complete the survey instead.

You can either pass this device to the person with the next birthday and let them complete the survey or you can simply close the browser and ask them to complete the survey at a time that suits them, using the same login details in the invitation letter.

**SC WEB ONLY. IF S1=2**
**S3**
**Welcome to [NAME OF SURVEY].**

--- page 8 ---

Thank you for taking part in the survey.

[As a token of appreciation, we will send you a [specify incentive] when we receive your completed questionnaire].

   • You may decline to answer questions by pressing the **Next** button

   • You can return to questions you've answered already by pressing Previous

   • If you exit the survey and re-enter with your access code, you will return to where you left off

To start the survey, press the **Next** button

SC WEB ONLY. IF S1=2
The survey is to be completed by the person aged 15 or over in your household who has the next birthday.

S4     **Are you the person aged 15 or over in your household who has the NEXT birthday?**

                              SC WEB
                         Yes   1
                         No    2

ASK ALL SC WEB AND PAPER
S5     **Are you…?**

SC WEB AND PAPER          Routing for SC WEB     Routing labels for SC PAPER
Aged [18] or over   1     Go to A1               **Now go to section A**
Aged under [18]     2     Go to S6               **Please answer the question below**

**\*\*Validation text: if respondent leaves S5 blank**
**Please indicate whether you are aged [18] or older. If you are under [18], you'll need to obtain permission from a parent/guardian to continue.**

ASK SC WEB AND PAPER IF AGED UNDER [18] AT S5 (S5=2)
S6     **IF AGED UNDER [18]:** You are required to obtain permission from a parent/guardian in order to complete this survey. Please complete below.

                                        SC WEB AND PAPER        Routing for SC WEB
          I confirm I have permission from a parent/guardian to   1   Go to A1
                                        complete this survey

**\*\*Validation text: if respondent leaves S6 blank**
**Please obtain permission from a parent/guardian in order to complete this survey. Once you have permission, update your answer to proceed with the survey.**

*SC PAPER INSTRUCTIONS:*
**Once you have permission, go to section A**

**NOTE ON ADMINISTRATION OF S5 and S6**
These questions only need to be asked if a country requires that people under a certain age require parental consent to participate in the survey.

7

--- page 9 ---

[START DATE AND TIME FOR ALL COUNTRIES]

**SECTION A**

In this first section we will ask you about a variety of different topics, starting with your local area1.

Please think of the area within 15-20 minutes walking distance from your home.

**ASK ALL**
**A12**   *CARD 1* **Overall, how satisfied or dissatisfied are you with your local area1 as a place to live?**

                                All modes        F2F only
                          Very satisfied  1
                        Fairly satisfied  2
    Neither satisfied nor dissatisfied  3
                       Fairly dissatisfied  4
                         Very dissatisfied  5
                                              7   (Refusal)
                                              8   (Don't Know)


**A22**   *CARD 2* **Over the past two years, has the local area1 where you live got better, worse, or not changed much?**

                                              All modes        F2F only
                                    Got better  1
                                     Got worse  2
    Not changed much (has not got better or worse)3  3
              I have not lived here long enough to say  4
                                                    7   (Refusal)
                                                    8   (Don't Know)


**A32**   *CARD 3* **How much do you feel you belong4 to your local area1?**

SC WEB AND F2F INSTRUCTIONS:                    SC PAPER INSTRUCTIONS:
Please answer using this scale, where 0         Please tick any circle ✓ from 0 to 6, where
means not at all and 6 means a great deal.      0 means not at all and 6 means a great deal.

                All modes                                F2F only

    Not at                          A great   (Refusal)   (Don't
    all                             deal                  know)


1 'local area': respondent's local area or neighbourhood
2 **NEW ITEM**.
3 The use of round brackets here does not denote unprompted response options in face-to-face. They should be displayed in all modes.
4 'Belong': feeling connected to or a part of

8

--- page 10 ---

0        1        2        3        4        5        6        7        8

**A4⁵**    *CARD 4* **How often do you chat to your neighbours, more than to just say
         hello⁶?**

                              All modes        F2F only
                           On most days  01
                    Once or twice a week  02
                   Once or twice a month  03
                  Less than once a month  04
                                  Never  05
               I don't have any neighbours  06
                                          77  (Refusal)
                                          88  (Don't Know)

Now some questions on different topics.

**A5**     *CARD 5* **Do you think that climate change is caused by natural processes,
         human activity, or both?**

                              All modes        F2F only    Routing
                  Entirely by natural processes  01
                  Mainly by natural processes  02
         About equally by natural processes and human  03
                                    activity                          **Go to A6**
                    Mainly by human activity  04
                    Entirely by human activity  05
         (I don't think climate change is happening)⁷  55              **Go to A8**
                                          77  (Refusal)
                                          88  (Don't              **Go to A6**
                                              know)

**ASK IF NOT CODE 55 AT A5 (IF A5 = 01, 02, 03, 04, 05, 77, 88, 99)**
**A6**     *CARD 6* **To what extent do you feel a personal responsibility to try to
         reduce climate change?**

                         All modes                              F2F only

Not at                                              A great  (Refusal)  (Don't
all                                                    deal              know)

⁵ **NEW ITEM**
⁶ 'say hello': can be translated as "greet"
⁷ The use of round brackets in the 'All modes' column here denotes unprompted response options in face-to-face

                                                                                    9

--- page 11 ---

00   01   02   03   04   05   06   07   08   09   10   77   88

**A7**   *CARD 7* **How worried are you about climate change?**

                              All modes        F2F only
                    Not at all worried   1
                       Not very worried   2
                      Somewhat worried   3
                           Very worried   4
                      Extremely worried   5
                                          7   (Refusal)
                                          8   (Don't know)


**ASK ALL**
**A8**   **On a typical day, about how much time do you spend in hours and minutes watching, reading or listening to news about politics and current affairs⁸?**

   *INSTRUCTIONS for all modes:* Please give your answer in hours (0-24) and minutes (0-59).

 SC PAPER INSTRUCTIONS:              SC WEB                  Note to F2F
                                     INSTRUCTIONS:           INTERVIEWER:
 For example, for one hour and       If you spend no time,   IF RESPONDENT
 twenty minutes, you would write:    please enter 0 hours    SPENDS NO TIME,
                                     and 0 minutes. For      ENTER 0 HOURS 0
  0   1   2   0                      answers less than 10,   MINUTES.
                                     only enter one digit (e.g.
 If you spend no time, please write  type 5 instead of 05).
 0 hours and 0 minutes.

                              All modes

                                   Hours              Minutes

                              F2F only

                              (Refusal)          7777
                              (Don't know)       8888

**\*\*Validation text: if hours are >24**
**We are asking about a typical day, so the maximum number of hours is 24.**
**\*\*Validation text: if minutes are >60**
**If you spend more than 60 minutes a day, please split this into hours and minutes. For example, if you spend 90 minutes, you would enter 1 in the hour box and 30 in the minutes box.**
**\*\*Validation text: if hours=24 and minutes>0**
**We are asking about a typical day, so please enter a total amount of time that is less than or equal to one day.**

⁸ 'about politics and current affairs': about issues to do with governance and public policy, and with the people connected with these affairs.

10

--- page 12 ---

**Validation text: if minutes are <0 or hours are <0
Please enter a positive number.

**A9**   *CARD 8* **People can use the internet on different devices such as computers, tablets and smartphones. How often do you use the internet on these or any other devices, whether for work or personal use?**

                    All modes        F2F only        Routing

                        Never  1
             Only occasionally  2                   **Go to A11**
            A few times a week  3
                    Most days  4                    **Go to A10**
                    Every day  5

                               7    (Refusal)       **Go to A11**
                               8    (Don't know)


**ASK IF MOST DAYS OR EVERY DAY AT A9 (IF A9 = 4, 5)**
**A10   On a typical day, about how much time in hours and minutes do you spend using the internet on a computer, tablet, smartphone or other device, whether for work or personal use?**

         *INSTRUCTIONS for all modes:* Please give your answer in hours (0-24) and minutes (0-59).

 *SC WEB INSTRUCTIONS:*
 For answers less than 10, only enter one digit (e.g. type 5 instead of 05).

                              All modes

                              **Hours**                **Minutes**

                              F2F only

                              (Refusal)          7777
                              (Don't know)       8888

**\*\*Validation text: if hours are >24**
**We are asking about a typical day, so the maximum number of hours is 24.**
**\*\*Validation text: if minutes are >60**
**If you spend more than 60 minutes a day, please split this into hours and minutes. For example, if you spend 90 minutes, you would enter 1 in the hour box and 30 in the minutes box.**
**\*\*Validation text: if hours=24 and minutes>0**
**We are asking about a typical day, so please enter a total amount of time that is less than or equal to one day.**
**\*\*Validation text: if minutes are <0 or hours are <0**
**Please enter a positive number.**

--- page 13 ---

ASK ALL
The next few questions are about your views of other people.⁹

**A11**   *CARD 9* **Generally speaking, would you say that most people can be trusted, or that you can't be too careful¹⁰ in dealing with people?**

F2F INTERVIEWER:
Please tell me on a score of 0 to 10, where 0 means you can't be too careful and 10 means that most people can be trusted.

                        All modes                                        F2F only
You can't                                              Most
be too                                                 people
careful                                                can be        (Refusal)     (Don't
                                                       trusted                      know)

00    01    02    03    04    05    06    07    08    09    10          77            88

**A12**   *CARD 10* **Do you think that most people would try to take advantage¹¹ of you if they got the chance, or would they try to be fair¹²?**

                        All modes                                        F2F only

Most people would try                                  Most people
to take advantage of                                   would try to be   (Refusal)   (Don't
me                                                     fair                           know)

00    01    02    03    04    05    06    07    08    09    10          77            88

**A13**   *CARD 11* **Would you say that most of the time people try to be helpful or that they are mostly looking out for themselves? ¹³**

                        All modes                                        F2F only
People                                                 People
mostly look                                            mostly try to
out for                                                be helpful     (Refusal)     (Don't
themselves                                                                            know)

00    01    02    03    04    05    06    07    08    09    10          77            88

Now some questions about politics and government.⁹

**A14**   **How interested would you say you are in politics?¹⁴**

         *Note to F2F INTERVIEWER:*
         READ OUT…

                                    All modes          F2F only

⁹ New Intro text for Round 12
¹⁰ 'Can't be too careful': need to be wary or always somewhat suspicious.
¹¹ 'Take advantage': exploit or cheat.
¹² 'Fair': in the sense of treat appropriately and straightforwardly.
¹³ The intended contrast is between self-interest and altruistic helpfulness.
¹⁴ Question wording and response options have been changed from Round 11 face-to-face for Round 12

                                                                                      12

--- page 14 ---

Very interested  | 1
Quite interested  | 2
Hardly interested  | 3
Not at all interested | 4
                  | 7 | (Refusal)
                  | 8 | (Don't know)

**A15**   *CARD 12* **How much would you say the political system in [country] allows people like you to have a say in what the government does?**

                  All modes |   | F2F only
                  Not at all | 1 |
                 Very little | 2 |
                        Some | 3 |
                       A lot | 4 |
                A great deal | 5 |
                             | 7 | (Refusal)
                             | 8 | (Don't know)

**A16**   *CARD 13* **How able do you think you are to take an active role in a group involved with political issues?**

                  All modes |   | F2F only
             Not at all able | 1 |
               A little able | 2 |
                 Quite able  | 3 |
                  Very able  | 4 |
             Completely able | 5 |
                             | 7 | (Refusal)
                             | 8 | (Don't know)

**A17**   *CARD 14* **How much would you say the political system in [country] allows people like you to have an influence on politics?¹⁵**

                  All modes |   | F2F only
                  Not at all | 1 |
                 Very little | 2 |
                        Some | 3 |
                       A lot | 4 |
                A great deal | 5 |

¹⁵ Question wording has been changed for Round 12 (the word 'And' was removed from the start of the question).

13

--- page 15 ---

7  (Refusal)
8  (Don't know)

**A18**   *CARD 15* **How confident are you in your own ability to participate in politics?¹⁶**

                    All modes        F2F only
Not at all confident¹⁷    1
A little confident        2
Quite confident           3
Very confident            4
Completely confident      5
                          7    (Refusal)
                          8    (Don't know)

**A19-A25**

**A19_intro**
> The next questions ask how much you personally trust different institutions. 0 means you do not trust an institution at all, and 10 means you have complete trust.

**A19¹⁸**   *CARD 16* **How much do you personally trust [country]'s parliament?**

                    All modes                          F2F only
No trust at                              Complete
all                                      trust     (Refusal)    (Don't
                                                                know)
00   01   02   03   04   05   06   07   08   09   10     77       88

**ASK ALL**
**A20**¹⁸   *STILL CARD 16* **How much do you personally trust the legal system?**

                    All modes                          F2F only
No trust at                              Complete
all                                      trust     (Refusal)    (Don't
                                                                know)
00   01   02   03   04   05   06   07   08   09   10     77       88

**A21**¹⁸   *STILL CARD 16* **How much do you personally trust the police?**

                    All modes                          F2F only
No trust at                              Complete
all                                      trust     (Refusal)    (Don't
                                                                know)

¹⁶ Question wording has been changed for Round 12 (the word 'And' was removed).
¹⁷ 'Not at all confident' in the sense of 'having no confidence at all in your own ability'.
¹⁸ Questions A19-A25 have been updated for Round 12 to present the full question stem for each item.

14

--- page 16 ---

00    01      02      03      04      05      06      07      08      09      10        77              88

**A22¹⁹**   *STILL CARD 16* **How much do you personally trust politicians?**

                        All modes                                                    F2F only
No trust at                                                           Complete
all                                                                        trust    (Refusal)       (Don't
                                                                                                    know)

00    01      02      03      04      05      06      07      08      09      10        77              88

**A23**¹⁹   *STILL CARD 16* **How much do you personally trust political parties?**

                        All modes                                                    F2F only
No trust at                                                           Complete
all                                                                        trust    (Refusal)       (Don't
                                                                                                    know)

00    01      02      03      04      05      06      07      08      09      10        77              88

**A24**¹⁹   *STILL CARD 16* **How much do you personally trust the European
            Parliament?**

                        All modes                                                    F2F only
No trust at                                                           Complete
all                                                                        trust    (Refusal)       (Don't
                                                                                                    know)

00    01      02      03      04      05      06      07      08      09      10        77              88

**A25**¹⁹   *STILL CARD 16* **How much do you personally trust the United Nations?**

                        All modes                                                    F2F only
No trust at                                                           Complete
all                                                                        trust    (Refusal)       (Don't
                                                                                                    know)

00    01      02      03      04      05      06      07      08      09      10        77              88

**ASK ALL**
**A26      Some people don't vote nowadays for one reason or another. Did you vote in the last
          [country nationality]²⁰ national election²¹ in [month/year]?**

                        All modes          F2F only          Routing

                              Yes    1                       **Go to A27**

                               No    2                       **Go to A28-A35**
             Not eligible to vote    3
                                     7     (Refusal)

¹⁹ Questions A19-A25 have been updated for Round 12 to present the full question stem for each item.
²⁰ [country nationality] updated from [country]
²¹ 'last national election': last election of a country's primary legislative assembly.

15

--- page 17 ---

8  (Don't know)

ASK IF YES AT A26 (A26 = 1)

A27²²  Which party did you vote for in the last [country nationality] national election²³ in
        [month/year]?²⁴
        PROGRAMMING NOTE: a maximum of 20 response options not including
        the 'Other' category will be allowed.

                              All modes        F2F only

                               Option 1   01
                               Option 2   02
                               Option 3   03
                               Option 4   04
                               Option 5   05
                               Option 6   06
                               Option 7   07
                               Option 8   08
                               Option 9   09
                              Option 10   10
                              Option 11   11
                              Option 12   12
                              Option 13   13
                              Option 14   14
                              Option 15   15
                              Option 16   16
                              Option 17   17
                              Option 18   18
                              Option 19   19
                              Option 20   20
                 Other: please write in   21
                                          77   (Refusal)
                                          88   (Don't know)

ASK ALL
A28-A35

There are different ways of trying to improve things in [country] or help prevent things
from going wrong.²⁵²⁶

A28²⁷  During the last 12 months, have you contacted a politician, government or
        local government official?

²² Question text has been changed from Round 11 face-to-face for Round 12
²³ 'last national election': last election of a country's primary legislative assembly.
²⁴ Question A27 is country-specific for question wording and response options. The maximum allowed number of response options is 20.
²⁵ 'Help prevent things from going wrong' in the sense of help prevent serious problems arising.
²⁶ This intro text should appear on the same screen as A28. The label 'A28-A35' above should not be displayed in CAPI.
²⁷ Questions A28-A35 have been updated for Round 12 to present the full question stem for each item.

16

--- page 18 ---

All modes     F2F only
          Yes   1
           No   2
                7   (Refusal)
                8   (Don't know)

A29²⁸  During the last 12 months, have you donated to or participated in a
        political party or pressure group²⁹?

               All modes     F2F only
                     Yes   1
                      No   2
                           7   (Refusal)
                           8   (Don't know)

A30²⁸  During the last 12 months, have you worn or displayed a campaign
        badge/sticker?

               All modes     F2F only
                     Yes   1
                      No   2
                           7   (Refusal)
                           8   (Don't know)

A31²⁸  During the last 12 months, have you signed a petition?

               All modes     F2F only
                     Yes   1
                      No   2
                           7   (Refusal)
                           8   (Don't know)

A32²⁸  During the last 12 months, have you taken part in a public demonstration?

               All modes     F2F only
                     Yes   1
                      No   2
                           7   (Refusal)
                           8   (Don't know)

²⁸ Questions A28-A35 have been updated for Round 12 to present the full question stem for each item.
²⁹ 'Pressure group': a group of people who work together to try to influence what other people or the government think about a particular subject, in order to achieve the things they want. The same translation as for 'action group' in ESS1- ESS9 should be used, if this reflects the definition of pressure group given here.
                                                                                                                            17

--- page 19 ---

A33³⁰  During the last 12 months, have you boycotted certain products?

                    All modes        F2F only

                          Yes   1
                           No   2
                                7   (Refusal)
                                8   (Don't know)


A34³⁰³¹          During the last 12 months, have you posted or shared anything about politics
          online, for example on blogs, via email or on social media such as Facebook,
          Instagram, TikTok, or X (formerly known as Twitter)³²?

                    All modes        F2F only

                          Yes   1
                           No   2
                                7   (Refusal)
                                8   (Don't know)


A35³⁰  During the last 12 months, have you volunteered for a not-for-profit or charitable
         organisation?

                    All modes        F2F only

                          Yes   1
                           No   2
                                7   (Refusal)
                                8   (Don't know)


A36    Is there a particular political party you feel closer to³³ than all the other parties?

                    All modes        F2F only          Routing

                          Yes   1                      Go to A37
                           No   2
                                7   (Refusal)          Go to A39
                                8   (Don't know)


³⁰ Questions A28-A35 have been updated for Round 12 to present the full question stem for each item.
³¹ Question text has been changed from Round 11 face-to-face for Round 12
³² The examples given in the source question should be used where possible. However, if in your country there are other social media platforms which would be more appropriate to include instead of or as well as Facebook, Instagram, TikTok, or X, please discuss with the Translation team ess_translate@gesis.org.
³³ 'Feel closer to': in the sense of the party one most identifies or sympathises with or is most attached to, regardless of how one votes.

18

--- page 20 ---

ASK IF YES AT A36 (A36 = 1)

A37³⁴³⁵          Which political party do you feel closest to?
PROGRAMMING NOTE: A maximum of 20 response options not including the 'Other' category will be allowed.

                        All modes        F2F only

                         Option 1   01
                         Option 2   02
                         Option 3   03
                         Option 4   04
                         Option 5   05
                         Option 6   06
                         Option 7   07
                         Option 8   08
                         Option 9   09
                        Option 10   10
                        Option 11   11
                        Option 12   12
                        Option 13   13
                        Option 14   14
                        Option 15   15
                        Option 16   16
                        Option 17   17
                        Option 18   18
                        Option 19   19
                        Option 20   20
               Other: please write in   21
                                        77   (Refusal)
                                        88   (Don't know)


ASK IF PARTY GIVEN AT A37
A38³⁵  How close do you feel to this party?

        Note to F2F INTERVIEWER:
        READ OUT…

                        All modes        F2F only

                       Very close   1
                      Quite close   2
                        Not close   3
                 Not at all close   4
                                    7   (Refusal)
                                    8   (Don't know)


ASK ALL

³⁴ Question A37 is country-specific for response options. The maximum allowed number of response options is 20.
³⁵ Question text has been changed from Round 11 face-to-face for Round 12.

19

--- page 21 ---

A39   *CARD 17* **In politics people sometimes talk of "left" and "right". Where would you place yourself on this scale, where 0 means the left and 10 means the right?**

                        All modes                                          F2F only

Left                                                          Right   (Refusal)      (Don't
                                                                                      know)

00      01      02      03      04      05      06      07      08      09      10        77            88


A40   *CARD 18* **All things considered, how satisfied are you with your life as a whole nowadays?**

         *F2F INTERVIEWER INSTRUCTIONS:*
         Please answer using this card, where 0 means extremely dissatisfied and 10 means
         extremely satisfied.

                        All modes                                          F2F only

Extremely³⁶                                                   Extremely   (Refusal)      (Don't
dissatisfied                                                  satisfied                   know)

00      01      02      03      04      05      06      07      08      09      10        77            88


A41   *STILL CARD 18* **On the whole, how satisfied are you with the present state of the economy in [country]?**

                        All modes                                          F2F only

Extremely                                                     Extremely   (Refusal)      (Don't
dissatisfied                                                  satisfied                   know)

00      01      02      03      04      05      06      07      08      09      10        77            88


A42   *STILL CARD 18* **Now thinking about the [country nationality] government³⁷, how satisfied are you with the way it is doing its job?**

                        All modes                                          F2F only

Extremely                                                     Extremely   (Refusal)      (Don't
dissatisfied                                                  satisfied                   know)

00      01      02      03      04      05      06      07      08      09      10        77            88


A43   *STILL CARD 18* **And on the whole, how satisfied are you with the way democracy works in [country]?³⁸**

³⁶ 'extremely': for CORE and rotating modules' items using 'extremely' or 'completely', the same translation should be used as in previous rounds. This applies throughout sections A, B, C, and D. If translators are unsure, contact ess_translate@gesis.org.
³⁷ 'government': The people now governing, the present regime.
³⁸ 'the way democracy works in [country]': the democratic system 'in practice' is meant, as opposed to how democracy 'ought' to work.

20

--- page 22 ---

All modes                                          F2F only

Extremely                                    Extremely  (Refusal)    (Don't
dissatisfied                                 satisfied               know)

00      01      02      03      04      05      06      07      08      09      10        77          88

**A44³⁹**  *CARD 19* **What do you think overall about the state of education⁴⁰ in [country] nowadays?**

                              All modes                                          F2F only

Extremely                                                   Extremely  (Refusal)    (Don't
bad                                                              good               know)

00      01      02      03      04      05      06      07      08      09      10        77          88

**A45**³⁹  *STILL CARD 19* **What do you think overall about the state of health services⁴¹ in [country]
         nowadays?**

                              All modes                                          F2F only

Extremely                                                   Extremely  (Refusal)    (Don't
bad                                                              good               know)

00      01      02      03      04      05      06      07      08      09      10        77          88

**A46-A49** To what extent do you agree or disagree with each of the following statements?⁴²

**A46**   *CARD 20* **The government should take measures to reduce differences in income levels.**

                                        All modes          F2F only

                             Agree strongly   1
                                      Agree   2
                     Neither agree nor disagree   3
                                   Disagree   4
                          Disagree strongly   5
                                             7   (Refusal)
                                             8   (Don't know)


**A47**   *STILL CARD 20* **Gay men and lesbians should be free to live their own life as they wish⁴³.**

                                        All modes          F2F only

³⁹ Question text has been changed from Round 11 face-to-face for Round 12.
⁴⁰ 'state of education': covers issues of quality, access and effectiveness/efficiency.
⁴¹ 'state of health services': covers issues of quality, access and effectiveness/efficiency.
⁴² Intro text has been changed from Round 11 face-to-face for Round 12.
⁴³ Freedom of lifestyle is meant, 'free/entitled to live as gays and lesbians'.

21

--- page 23 ---

Agree strongly  | 1
                        Agree  | 2
Neither agree nor disagree  | 3
                     Disagree  | 4
           Disagree strongly  | 5
                               | 7  | (Refusal)
                               | 8  | (Don't know)

**A48**   *STILL CARD 20* **If a close family member was a gay man or a lesbian, I would feel ashamed.**

                    All modes  |    | F2F only
           Agree strongly  | 1
                        Agree  | 2
Neither agree nor disagree  | 3
                     Disagree  | 4
           Disagree strongly  | 5
                               | 7  | (Refusal)
                               | 8  | (Don't know)

**A49**   *STILL CARD 20* **Gay male and lesbian couples should have the same rights to adopt children as straight couples⁴⁴.**

                    All modes  |    | F2F only
           Agree strongly  | 1
                        Agree  | 2
Neither agree nor disagree  | 3
                     Disagree  | 4
           Disagree strongly  | 5
                               | 7  | (Refusal)
                               | 8  | (Don't know)

**A50⁴⁵**   *CARD 21* **Now thinking about the European Union, some say European unification⁴⁶ should go further. Others say it has already gone too far. Which number on this scale best describes your position?**

                    All modes                                          F2F only

⁴⁴ 'Straight couples': 'straight' is a colloquial term for 'heterosexual' in British English. Some suggestions that can be used are 'heterosexual couples' or 'couples consisting of a man and a woman'. However, 'normal couples' or 'other couples' should not be used.
⁴⁵ Question text has been changed from Round 11 face-to-face for Round 12.
⁴⁶ 'Unification' refers to further integration rather than further enlargement.

22

--- page 24 ---

Unification
has already
gone too far
                              Unification
                              should go   (Refusal)     (Don't
                              further                    know)

00      01      02      03      04      05      06      07      08      09      10          77          88

To what extent do you agree or disagree with each of the following statements?⁴⁷

**A51**   *CARD 22* **Obedience and respect for authority are the most important values children should learn.**

                                        All modes        F2F only
                               Agree strongly   1
                                        Agree   2
                       Neither agree nor disagree   3
                                     Disagree   4
                               Disagree strongly   5
                                                 7   (Refusal)
                                                 8   (Don't know)


**A52**   *STILL CARD 22* **What [country] needs most is loyalty towards its leaders⁴⁸.**

                                        All modes        F2F only
                               Agree strongly   1
                                        Agree   2
                       Neither agree nor disagree   3
                                     Disagree   4
                               Disagree strongly   5
                                                 7   (Refusal)
                                                 8   (Don't know)


Now some questions about people from other countries coming to live in [country].

**A53**⁴⁹   *CARD 23* **To what extent do you think [country] should⁵⁰ allow people of the same race or ethnic group⁵¹ as most [country nationality]⁵² people to come and live here⁵³?**

                                        All modes        F2F only
                    Allow many to come and live here   1


⁴⁷ Intro text has been changed from Round 11 face-to-face for Round 12.
⁴⁸ 'Leaders' refers to political leaders in government, but not necessarily to the current government.
⁴⁹ Question text has been changed from Round 11 face-to-face for Round 12.
⁵⁰ 'Should' in the sense of 'ought to'; not in the sense of 'must'.
⁵¹ 'Race or ethnic group': countries may choose to refer only to race or only to ethnic group rather than to 'race or ethnic group'
⁵² This has been changed to [country nationality]. In Round 11 this phrase read 'most [country]'s people'.
⁵³ 'Here': refers to [country]

23

--- page 25 ---

Allow some  |  2
Allow a few  |  3
Allow none   |  4
             |  7  (Refusal)
             |  8  (Don't know)

**A54**⁵⁴  *STILL CARD 23* **To what extent do you think [country] should⁵⁵ allow people of a different race or ethnic group⁵⁶ from most [country nationality]⁵⁷ people to come and live here⁵⁸?**

                          All modes  |     F2F only
Allow many to come and live here  |  1
                        Allow some  |  2
                       Allow a few  |  3
                        Allow none  |  4
                                    |  7  (Refusal)
                                    |  8  (Don't know)


**A55**⁵⁴  *STILL CARD 23* **To what extent do you think [country] should**⁵⁵ **allow people from poorer countries outside Europe to come and live here**⁵⁸**?**

                          All modes  |     F2F only
Allow many to come and live here  |  1
                        Allow some  |  2
                       Allow a few  |  3
                        Allow none  |  4
                                    |  7  (Refusal)
                                    |  8  (Don't know)


**A56⁵⁹**  *STILL CARD 23* **To what extent do you think [country] should**⁵⁵ **allow people who are forced to leave their country because of armed conflict or persecution⁶⁰ to come and live here**⁵⁸**?**

                          All modes  |     F2F only
Allow many to come and live here  |  1
                        Allow some  |  2
                       Allow a few  |  3
                        Allow none  |  4

⁵⁴ Question text has been changed from Round 11 face-to-face for Round 12.
⁵⁵ 'Should' in the sense of 'ought to'; not in the sense of 'must'.
⁵⁶ 'Race or ethnic group': countries may choose to refer only to race or only to ethnic group rather than to 'race or ethnic group'
⁵⁷ This has been changed to [country nationality]. In Round 11 this phrase read 'most [country]'s people'.
⁵⁸ ''Here': refers to [country]
⁵⁹ Part of the Round 12 rotating module on Immigration
⁶⁰ When translating 'armed conflict' and 'persecution', national teams should check the translated terms in the UN definition of refugees: https://www.unhcr.org/uk/about-unhcr/who-we-protect/refugees

24

--- page 26 ---

7    (Refusal)
8    (Don't know)

**A57**    *CARD 24* **Would you say it is generally bad or good for [country]'s economy that people come to live here from other countries?**

                              All modes                                              F2F only

Bad for the                                                    Good for the    (Refusal)      (Don't
economy                                                           economy                        know)

00      01      02      03      04      05      06      07      08      09      10      77          88


**A58**    *CARD 25* **Would you say that [country]'s cultural life is generally undermined or enriched by people coming to live here from other countries?**

                              All modes                                              F2F only

Cultural life                                                    Cultural life    (Refusal)      (Don't
undermined                                                         enriched                       know)

00      01      02      03      04      05      06      07      08      09      10      77          88


**A59**    *CARD 26* **Is [country] made a worse or a better place to live by people coming to live here from other countries?**

                              All modes                                              F2F only

Worse place                                                    Better place    (Refusal)      (Don't
to live                                                              to live                       know)

00      01      02      03      04      05      06      07      08      09      10      77          88


Now a few questions about you and your life.

**A60**    *CARD 27* **Taking all things together, how happy would you say you are?**

                              All modes                                              F2F only

Extremely                                                        Extremely    (Refusal)      (Don't
unhappy                                                              happy                       know)

00      01      02      03      04      05      06      07      08      09      10      77          88


**A61**    *CARD 28* **How often do you meet socially⁶¹ with friends, relatives or work colleagues?**

                              All modes              F2F only
                                  Never      01

⁶¹ 'Meet socially' implies meet by choice rather than for reasons of either work or pure duty.

25

--- page 27 ---

Less than once a month  | 02
             Once a month  | 03
    Several times a month  | 04
              Once a week  | 05
      Several times a week | 06
                 Every day | 07
                           | 77 | (Refusal)
                           | 88 | (Don't know)

**A62**   *CARD 29* **How many people, if any, are there with whom you can discuss intimate⁶² and personal⁶³ matters?**

                All modes  |    | F2F only
                     None  | 00 |
                        1  | 01 |
                        2  | 02 |
                        3  | 03 |
                      4-6  | 04 |
                      7-9  | 05 |
               10 or more  | 06 |
                           | 77 | (Refusal)
                           | 88 | (Don't know)

**A63**   *CARD 30* **Compared to other people of your age, how often would you say you take part in social activities⁶⁴?**

                All modes  |   | F2F only
         Much less than most | 1 |
            Less than most | 2 |
            About the same | 3 |
            More than most | 4 |
       Much more than most | 5 |
                           | 7 | (Refusal)
                           | 8 | (Don't know)

**A64**   **Have you or a member of your household been the victim of a burglary or assault⁶⁵ in the last 5 years?**

⁶² 'Intimate' implies things like sex or family matters.
⁶³ 'Personal' could include work or occupational issues as well.
⁶⁴ 'Social activities': events/encounters with other people, by choice and for enjoyment rather than for reasons of work or duty.
⁶⁵ 'Assault': physical assault.

--- page 28 ---

All modes          F2F only
              Yes   1
               No   2
                    7   (Refusal)
                    8   (Don't know)


**A65⁶⁶  How safe do you – or would you – feel walking alone in the area⁶⁷ you live after dark?**

        *Note to F2F INTERVIEWER:*
        READ OUT…

                   All modes          F2F only
               Very safe   1
                    Safe   2
                  Unsafe   3
             Very unsafe   4
                           7   (Refusal)
                           8   (Don't know)

⁶⁸

**A66**⁶⁶  **How is your health⁶⁹ in general?**

        *Note to F2F INTERVIEWER:*
        READ OUT…

                   All modes          F2F only
               Very good   1
                    Good   2
                    Fair   3
                     Bad   4
                Very bad   5
                           7   (Refusal)
                           8   (Don't know)


**A67    Are you hampered⁷⁰ in your daily activities in any way by any longstanding illness, or
        disability, infirmity or mental health problem?**

        *Note to F2F INTERVIEWER:*
        IF YES, is that a lot or to some extent?

                        All modes          F2F only
                       Yes, a lot   1
              Yes, to some extent   2

⁶⁶ Question text has been changed from Round 11 face-to-face for Round 12.
⁶⁷ 'Area': respondent's local area or neighbourhood.
⁶⁸ Intro text from Round 11 face-to-face ('The next set of questions are about yourself') has been removed.
⁶⁹'Health': physical and mental health.
⁷⁰ 'Hampered': limited, restricted in your daily activities.

--- page 29 ---

No   3
          7  (Refusal)
          8  (Don't know)

People might feel different levels of attachment to the country where they live and to Europe⁷¹.

**A68**   *CARD 31* **How emotionally attached⁷² do you feel to [country]?**

*F2F INTERVIEWER INSTRUCTIONS:*
Please choose a number from 0 to 10, where 0 means not at all
emotionally attached and 10 means very emotionally attached.

                    All modes                                        F2F only

Not at all                                          Very
emotionally                                    emotionally   (Refusal)    (Don't
attached                                          attached                  know)

00      01      02      03      04      05      06      07      08      09      10        77          88

**A69**   *STILL CARD 31* **And how emotionally attached**⁷² **do you feel to Europe?**⁷¹

                    All modes                                        F2F only

Not at all                                          Very
emotionally                                    emotionally   (Refusal)    (Don't
attached                                          attached                  know)

00      01      02      03      04      05      06      07      08      09      10        77          88

**A70**   **Do you consider yourself as belonging to⁷³ any particular religion or denomination?**

                    All modes        F2F only       Routing

                          Yes   1                   **Go to A71**

                          No    2
                                7    (Refusal)      **Go to A72**
                                8    (Don't know)

⁷¹ 'Europe': Europe in general, not specifically European Union.
⁷² 'Emotionally attached' in the sense of 'identifying with AND feeling close to'.
⁷³ 'Belonging to': Identification is meant, not official membership.

--- page 30 ---

ASK IF YES AT A70 (IF A70 = 1)

A71⁷⁴   OPTIONAL CARD Which religion or denomination do you belong to?

                        All modes        F2F only        Routing
                         Option 1   01                  Go to A74
                         Option 2   02
                         Option 3   03
                         Option 4   04
                         Option 5   05
                         Option 6   06
                         Option 7   07
                         Option 8   08
                         Option 9   09
                        Option 10   10
                        Option 11   11
                        Option 12   12
                        Option 13   13
                        Option 14   14
                        Option 15   15
               Other: please write in   16
                                    77   (Refusal)
                                    88   (Don't know)

NOTE ON ADMINISTRATION OF A71
The set of country-specific categories that are listed in the Consultation outcomes for religion on the ESS12 NC Intranet should be used in all modes. A maximum of 15 response options not including 'Other: please write in' are allowed. Only one 'Other: please write in' category is permitted and can only be included after substantive responses as shown above. Use of a showcard at A71 is optional.

ASK IF NO RELIGION / DENOMINATION OR DON'T KNOW/REFUSAL/NO ANSWER AT A70 (IF A70 = 2, 7, 8, OR 9)
SC WEB AND PAPER:
You just indicated that you do not currently consider yourself belonging to any religion or denomination.

A72   Have you ever considered yourself as belonging to any particular religion or denomination?

                All modes        F2F only        Routing
                      Yes   1                   Go to A73
                       No   2
                            7    (Refusal)      Go to A74
                            8    (Don't know)

⁷⁴ Question text has been changed from Round 11 face-to-face for Round 12.

29

--- page 31 ---

ASK IF YES AT A72 (IF A72 = 1)

A73⁷⁵        OPTIONAL CARD Which religion or denomination did you belong to in the past?

                              All modes        F2F only
                               Option 1   01
                               Option 2   02
                               Option 3   03
                               Option 4   04
                               Option 5   05
                               Option 6   06
                               Option 7   07
                               Option 8   08
                               Option 9   09
                              Option 10   10
                              Option 11   11
                              Option 12   12
                              Option 13   13
                              Option 14   14
                              Option 15   15
                 Other: please write in   16
                                          77   (Refusal)
                                          88   (Don't know)

NOTE ON ADMINISTRATION OF A73
The set of country-specific categories that are listed in the Consultation outcomes for religion on the ESS12 NC Intranet should be used in all modes. A maximum of 15 response options not including 'Other: please write in' are allowed. Only one 'Other: please write in' category is permitted and can only be included after substantive responses as shown above.

ASK ALL
A74    CARD 32 Regardless of whether you belong to a particular religion, how religious would you say you are?

                              All modes                                        F2F only

Not at all                                                        Very        (Refusal)    (Don't
religious                                                      religious                   know)

00       01      02      03      04      05      06      07      08      09      10         77          88

A75    CARD 33 Apart from special occasions such as weddings and funerals, about how often do you attend religious services nowadays?

                              All modes        F2F only
                           Every day   01

⁷⁵ Question text has been changed from Round 11 face-to-face for Round 12.

30

--- page 32 ---

More than once a week | 02
                    Once a week | 03
          At least once a month | 04
      Only on special holy days | 05
                     Less often | 06
                          Never | 07
                                | 77 | (Refusal)
                                | 88 | (Don't know)

**A76**   *STILL CARD 33* **Apart from when you are at religious services, how often, if at all, do you pray?**

                    All modes |    | F2F only
                   Every day | 01 |
       More than once a week | 02 |
                 Once a week | 03 |
       At least once a month | 04 |
   Only on special holy days | 05 |
                  Less often | 06 |
                       Never | 07 |
                             | 77 | (Refusal)
                             | 88 | (Don't know)

**A77   Would you describe yourself as being a member of a group that is discriminated against in this country?**

    All modes |   | F2F only | Routing
          Yes | 1 |          | **Go to A78**
           No | 2 |          |
              | 7 | (Refusal) | **Go to A79**
              | 8 | (Don't know) |

**ASK IF YES AT A77 (IF A77=1)**
**A78   On what grounds is your group discriminated against?**

 SC WEB and PAPER INSTRUCTIONS: | F2F INTERVIEWER:
 Select all that apply.          | PROBE: What other grounds?
                                 |
                                 | CODE ALL THAT APPLY

                    All modes |    | F2F only
               Colour or race | 01 |

31

--- page 33 ---

Nationality  02
          Religion  03
          Language  04
      Ethnic group  05
               Age  06
            Gender  07
         Sexuality  08
        Disability  09
Other: please write in  10
                    77  (Refusal)
                    88  (Don't know)


ASK ALL
A79   Are you a citizen of [country]?

          All modes        F2F only
                Yes  1
                 No  2
                      7  (Refusal)
                      8  (Don't know)


A80   Were you born in [country]?

          All modes        F2F only     Routing
                Yes  1                 Go to A83
                 No  2                 Go to A81
                      7  (Refusal)     Go to A83
                      8  (Don't know)


ASK IF NO AT A80 (IF A80 = 2)
A81⁷⁶  In which country were you born?
        SC PAPER INSTRUCTIONS:
        Please write in:

               All modes              F2F only

______________________________         (Refusal)     7777
______________________________         (Don't know)  8888




⁷⁶ To be coded into pre-specified ISO 3166-1 (2 character)

32

--- page 34 ---

ASK IF NO AT A80 (IF A80 = 2)
A82    What year did you first come to live in [country]?

SC WEB AND PAPER INSTRUCTIONS:
Please enter all four digits.

               All modes                          F2F only

  Year  |   |   |   |   |                (Refusal)     7777
                                          (Don't know)  8888

**Validation text: if year entered is prior to 1900 or after current year
Please enter a valid year in full (4 digits).


ASK ALL
A83⁷⁷  What language or languages do you speak most often at home?

SC WEB AND PAPER INSTRUCTIONS:                    F2F INSTRUCTIONS:
Write in a maximum of 2 languages. [Include       TYPE IN UP TO 2 LANGUAGES
[country's main language] if this is spoken at home.]⁷⁸

               All modes                          F2F only

Language 1_________________________________       (Refusal)     7777
Language 2_________________________________       (Don't know)  8888


A84    Do you feel you are part of the same race or ethnic group⁷⁹ as most people in [country]?

               All modes        F2F only
                    Yes    1
                     No    2
                           7    (Refusal)
                           8    (Don't know)


A85    Was your father born in [country]?

               All modes        F2F only          Routing
                    Yes    1                      Go to A87
                     No    2                      Go to A86
(Prefer not to answer)⁸⁰   7                      Go to A87
                           8    (Don't know)


⁷⁷ To be coded into ISO 639-2 (3 character)
⁷⁸ The inclusion of the second sentence "Include [country's main language]…" is optional. It is advised to use when a country has only one main language.
⁷⁹ 'Same race or ethnic group': the same translation as at item A53 should be used.
⁸⁰ The use of round brackets in the 'All modes' column denotes unprompted response options in F2F. In F2F, '(Prefer not to answer)' takes the place of '(Refusal)' at this question.

33

--- page 35 ---

ASK IF NO AT A85 (IF A85 = 2)
A86⁸¹  In which country was your father born?

   SC PAPER INSTRUCTIONS:
   Please write in:

                              All modes          F2F only

                    (Prefer not to answer)⁸²  777
                                               888   (Don't know)

**Validation text: if text is entered and 'Prefer not to answer' is selected
Please either deselect 'Prefer not to answer' or remove what you have typed in the box below before clicking Next


ASK ALL
A87    Was your mother born in [country]?

                              All modes          F2F only          Routing
                         Yes  1                                    Go to A89
                          No  2                                    Go to A88
          (Prefer not to answer)⁸²  7                             Go to A89
                               8   (Don't know)


ASK IF NO AT A87 (IF A87 = 2)
A88⁸³  In which country was your mother born?

   SC PAPER INSTRUCTIONS:
   Please write in:

                              All modes          F2F only

                    (Prefer not to answer)⁸²  777
                                               888   (Don't know)

Validation text: if text is entered and 'Prefer not to answer' is selected
Please either deselect 'Prefer not to answer' or remove what you have typed in the box below before clicking Next

⁸¹ To be coded into pre-specified ISO 3166-1 (2 character)
⁸² The use of round brackets in the 'All modes' column denotes unprompted response options in F2F. In F2F, '(Prefer not to answer)' takes the place of '(Refusal)' at this question.
⁸³ To be coded into pre-specified ISO 3166-1 (2 character)

34

--- page 36 ---

ASK ALL
PROGRAMING NOTE: Countries ask A89a or A89b depending on EU membership. EU members ask A89a and non-EU countries ask A89b. On SC PAPER, display either question as A89.

A89a  Now a question on a different topic.⁸⁴

      **Imagine there were a referendum in [country] tomorrow about membership of the European Union. Would you vote for [country] to remain a member of the European Union or to leave the European Union?**

                                    All modes        F2F only

      Remain a member of the European Union    01
               Leave the European Union    02
      (Would submit a blank ballot paper)⁸⁵    33
         (Would spoil⁸⁶ the ballot paper) ⁸⁵    44
                    (Would not vote) ⁸⁵    55
               (Not eligible to vote) ⁸⁵    65
                                             77    (Refusal)
                                             88    (Don't know)

A89b  Now a question on a different topic.⁸⁴

      **Imagine there were a referendum in [country] tomorrow about membership of the European Union. Would you vote for [country] to become a member of the European Union or to remain outside the European Union?**

                                    All modes        F2F only

      Become a member of the European Union    01
           Remain outside the European Union    02
      (Would submit a blank ballot paper)⁸⁵    33
         (Would spoil⁸⁶ the ballot paper) ⁸⁵    44
                    (Would not vote) ⁸⁵    55
               (Not eligible to vote) ⁸⁵    65
                                             77    (Refusal)
                                             88    (Don't know)

⁸⁴ Intro text has been moved to be a part of items A89a and A89b
⁸⁵ The use of round brackets in the 'All modes' column denotes unprompted response options in F2F.
⁸⁶ 'Spoil' in the sense of marking the ballot paper so as to make it null or invalid.

35

--- page 37 ---

SECTION B

ASK ALL
Thank you for your answers so far. The following questions are about yourself and others who live with you in your household. By this we mean anyone whose main residence is your home and who shares your living areas with you.

B1⁸⁷     Including yourself and any children, how many people live here regularly as members of your household?

         Note to F2F INTERVIEWER:
         TYPE IN NUMBER...

              All modes               F2F only

                                      (Refusal)     77
                                      (Don't know)  88

*Soft check validation text: if left blank, show this once
This question is important to ensure you get asked the relevant questions later in the survey. If you are not sure, please give your best estimate.
**Validation text: if B1>99 or <1
Please enter a number between 1 and 99

B2⁸⁸     And how many of the people in your household are aged 15 or older, including yourself?

         Note to F2F INTERVIEWER:
         TYPE IN NUMBER...

              All modes               F2F only

                                      (Refusal)     77
                                      (Don't know)  88

*Soft check validation text: if left blank, show this once
This question is important, please answer if you can.
**Validation text: if B2>B1
The number of household members who are aged 15 or older should be less than
or equal to the answer you gave in the previous question.
**Validation text: if B2<1
Your answer should be greater than zero and less than or equal to the answer you gave in the previous question.

Note to F2F INTERVIEWER:
COLLECT DETAILS OF RESPONDENT

B3
SC WEB AND PAPER QUESTION WORDING:    Note to F2F INTERVIEWER:
What is your sex?                      CODE SEX⁸⁹

                                      All modes

⁸⁷ Question text has been changed from Round 11 face-to-face for Round 12.
⁸⁸ NEW ITEM
⁸⁹ This has been retained from Round 11 face-to-face. There is no question wording provided to the interviewer in face-to-face for this question, just text that says 'CODE SEX'.

36

--- page 38 ---

Male   1
Female   2

**B4⁹⁰   In which month and year were you born?**

 SC WEB AND PAPER INSTRUCTIONS:                    Note to F2F INTERVIEWER:
 Please answer using two digits for the month (e.g. 01   TYPE IN AS TWO DIGITS FOR MONTH
 for January) and four digits for the year.              (E.G. 01 FOR JANUARY) AND FOUR
                                                         DIGITS FOR YEAR.

              All modes          F2F only

       Month                     (Refusal)     7777
                                 (Don't know)  8888
       Year


**\*Soft check validation text: if Year is left blank, show this once**
**This question is important, as we know experiences and opinions can differ between age**
**groups. Please provide an answer if you can. You can only provide the year (and not the month)**
**if you prefer.**
**\*\*Validation text: if month of birth is not between 1 and 12 inclusive**
**Please enter a valid month of birth (01-12).**
**\*\*Validation text: if year of birth is prior to 1900 or after 2020**
**Please enter a valid year of birth in full (4 digits).**


**ASK IF LIVING WITH OTHER PEOPLE (IF B1 > 1)**
**HHintro**

 SC PAPER INSTRUCTIONS:              SC WEB INSTRUCTIONS:           Note to F2F INTERVIEWER:
 **B5 – B7** Please fill in the following   Please fill in the following    ENTER DETAILS OF OTHER
 questions on pages [xx-xx] for **up**   questions about **other**          HOUSEHOLD MEMBERS.
 **to 8 other people living in your**   **people living in your**          FOR EASE, IT MAY BE
 **household**, starting with your       **household,** starting with       USEFUL TO ADD THE
 direct relatives before adding in      your direct relatives before       NAMES OR INITIALS OF
 other household members.              adding in other household          EACH HOUSEHOLD
                                        members.                           MEMBER WHERE
 If you are the only person in your                                        INDICATED.
 household **go to B9 on page [xx].**


**Program SC WEB and F2F so that questions B5 – B7, including the optional question for a household member's first name or initial, are repeated for each additional member of the household according to the answer at B1. The respondent should be asked about a maximum of 8 other people in the household.**
Program SC PAPER so that questions B5 – B7, including the optional question for a household member's first name or initial, are asked for 8 people.

**HHName**
**Person XX⁹¹**
**First name or initial (optional)**

⁹⁰ Question text has been changed from Round 11 face-to-face for Round 12. Previously the month of birth was not requested in face-to-face.
⁹¹ Replace XX with ordinal numbers for each additional household member. For SC Paper, this means that Person 1, Person 2, Person 3, … Person 8 will be programmed.

37

--- page 39 ---

If a first name or initial is provided above, they should be displayed in SC WEB and F2F in B5 - B7

**B5**92

 SC WEB and F2F QUESTION WORDING:                SC PAPER QUESTION WORDING:
 What is {Person XX93/Person XX's name or         What is Person XX93's sex?
 initial}94's sex?


                              All modes        F2F only

                                   Male   1
                                 Female   2
                                          7    (Refusal)
                                          8    (Don't know)


**B6**92

 SC WEB and F2F QUESTION WORDING:                SC PAPER QUESTION WORDING:
 In which month and year was {Person             In which month and year was Person XX93
 XX93/Person XX's name or initial}94 born?       born?


           All modes                  F2F only

           Month                      (Refusal)      7777
                                      (Don't know)   8888
           Year


**\*\*Validation text: if month of birth is not between 1 and 12 inclusive
Please enter a valid month of birth (01-12).
\*\*Validation text: if year of birth is prior to 1900 or after current year
Please enter a valid year of birth in full (4 digits).**


**B7**92

 SC WEB and F2F QUESTION WORDING:                SC PAPER QUESTION WORDING:
 CARD 34 What is {Person XX93/Person XX's        This person is your…
 name or initial}94's relationship to you? This
 person is your…


92 Question text has been changed from Round 11 face-to-face for Round 12.
93 Replace XX with ordinal numbers for each additional household member. For SC Paper, this means that Person 1, Person 2, Person 3, … Person 8 will be programmed.
94 This fill should be translated so that when a name has been provided it is used in B5-B7 as best applicable in the relevant language. When no name was provided, 'Person X' should be used in B5-B7 as best applicable in the relevant language.

38

--- page 40 ---

All modes     F2F only

                                              Husband, wife, or partner  01
Son or daughter (including step, adopted, foster, or child of partner)⁹⁵  02
                    Parent, parent-in-law, partner's parent, or step parent  03
                    Brother or sister (including step, adopted, or foster)⁹⁵  04
                                                          Other relative  05
                                                      Other non-relative  06
                                                                           77   (Refusal)
                                                                           88   (Don't know)


SC PAPER INSTRUCTIONS:
If you do live with a husband, wife, or partner, please answer question B8.
If you do not live with a husband, wife, or partner, go to B9.

ASK IF LIVING WITH HUSBAND/WIFE/PARTNER AT B7 (IF 01 AT B7)
B8
SC WEB AND PAPER QUESTION WORDING:          F2F QUESTION WORDING:
Which one of the descriptions from the      CARD 35 You just told me that you live with
following list describes your relationship to   your husband / wife / partner. Which one of
your husband, wife, or partner?             the descriptions on this card describes your
                                            relationship to them?

                                    All modes        F2F only       F2F & SC WEB
                                                                    routing
                              Legally married   01
                  In a legally registered civil union   02          Go to B9
Living with my partner (cohabiting)⁹⁵ - not legally   03
                                    recognised                      Go to B10
Living with my partner (cohabiting)⁹⁵ - legally recognised   04
                              Legally separated   05
           Legally divorced or civil union dissolved   06
                                       Option 7   07
                                       Option 8   08               Go to B9
                                                  77   (Refusal)
                                                  88   (Don't know)

NOTE ON CATEGORIES FOR B8 (CARD 35)
The set of country-specific categories that are applicable to B8 and are listed in the Consultation outcomes for marital status on the ESS12 NC Intranet should be made available to interviewers. Option 7 and Option 8 are to be used by countries that include more than 6 categories.

⁹⁵ The use of round brackets here does not denote unprompted response options in face-to-face. They should be displayed in all modes.
                                                                                                    39

--- page 41 ---

ASK IF NOT LIVING WITH HUSBAND/WIFE/PARTNER AT B7 OR NOT COHABITING WITH PARTNER AT B8 (IF NOT 01 AT B7, OR IF B8 = 01, 02, 05, 06, 07, 08, 77, 88, 99)
**B9⁹⁶    Have you ever lived with a partner without being married to them [or in a civil union]⁹⁷?**

                   All modes  |     | F2F only
                          Yes |  1  |
                           No |  2  |
                              |  7  | (Refusal)
                              |  8  | (Don't know)

**ASK ALL**
**B10**⁹⁶  **Have you ever been divorced [or had a civil union dissolved]**⁹⁷**?**

                   All modes  |     | F2F only
                          Yes |  1  |
                           No |  2  |
                              |  7  | (Refusal)
                              |  8  | (Don't know)

**ASK IF NOT LIVING WITH HUSBAND/WIFE/PARTNER AT B7 OR ARE COHABITATING AT B8 (IF NOT 01 AT B7, OR IF B8= 03, 04)**
**B11**⁹⁶  *CARD 36* **This question is about your legal marital status not about who you may or may not be living with. Which one of the descriptions from the following list describes your legal marital status now?**

 *Note to F2F INTERVIEWER:*
 CODE ONE ONLY: PRIORITY CODE

                                                          All modes  |     | F2F only
                                               Legally married  | 01  |
                                  In a legally registered civil union  | 02  |
                                               Legally separated  | 03  |
                          Legally divorced or civil union dissolved  | 04  |
                                    Widowed or civil partner died  | 05  |
 None of these (NEVER married or in legally registered civil union)⁹⁸  | 06  |
                                                          Option 7  | 07  |
                                                          Option 8  | 08  |
                                                                    | 77  | (Refusal)
                                                                    | 88  | (Don't know)

**NOTE ON CATEGORIES FOR B11 (CARD 36)**
The set of country-specific categories that are applicable to B11 and are listed in the Consultation outcomes for marital status on the ESS12 NC Intranet should be made available to interviewers. Option 7 and Option 8 are to be used by countries that include more than 6 categories.

⁹⁶ Question text has been changed from Round 11 face-to-face for Round 12.
⁹⁷ Countries should include the highlighted text only if civil unions are included at B8. Where these are included the country-specific names should be added here. Legally recognised forms of cohabitation should NOT be included or inferred.
⁹⁸ The use of round brackets here does not denote unprompted response options in face-to-face. They should be displayed in all modes.

40

--- page 42 ---

ASK IF NOT LIVING WITH CHILDREN AT HOME AT B7 (IF NOT 02 at B7)
**B12    Have you ever had any children of your own, step-children, adopted children, foster children
        or a partner's children living in your household?**

                          All modes  |    F2F only
                               Yes   | 1  |
                                No   | 2  |
                                     | 7  | (Refusal)
                                     | 8  | (Don't know)


**ASK ALL**
**B13**⁹⁹  *CARD 37* **Which of the following phrases best describes the area where you live?**

                          All modes  |    F2F only
                       A big city    | 1  |
The suburbs or outskirts of a big city | 2 |
            A town or a small city   | 3  |
                  A country village  | 4  |
     A farm or home in the countryside | 5 |
                                     | 7  | (Refusal)
                                     | 8  | (Don't know)

⁹⁹ Question text has been changed from Round 11 face-to-face for Round 12.

41

--- page 43 ---

B14a/B14b to be asked as country-specific question(s). Refer to education consultation for wording in all modes. To be recoded into the ESS Education Detailed ISCED Coding Frame. Countries opt whether to use one or two questions and modify question wording accordingly. For countries that use one question, SC PAPER should display B14.

PROGRAMMING NOTE: allow country-specific routing for whether one or two questions are asked.

B14a¹⁰⁰ CARD 38a¹⁰¹ [Country-specific text for respondent's highest education question here]
B14b CARD 38b [Country-specific text for respondent's highest education question here]

INSTRUCTIONS for all modes:
[If you are currently in education, select what corresponds to the highest level completed so far.
If you completed your education abroad, select the most similar [country] education level.]

                                    All Modes        F2F only
                                     Option 1  01
                                     Option 2  02
                                     Option 3  03
                                     Option 4  04
                                     Option 5  05
                                     Option 6  06
                                     Option 7  07
                                     Option 8  08
                                     Option 9  09
                                    Option 10  10
                                    Option 11  11
                                    Option 12  12
                                    Option 13  13
                                    Option 14  14
                                    Option 15  15
                                    Option 16  16
                                    Option 17  17
                                    Option 18  18
                                    Option 19  19
                                    Option 20  20
                                    Option 21  21
                                    Option 22  22
                                    Option 23  23
                                    Option 24  24
                           Other: please write in  25
                                                   7777  (Refusal)
                                                   8888  (Don't know)

ASK ALL
B15   About how many years of education have you completed, whether full-time or
      part-time?

      INSTRUCTIONS for all modes:

¹⁰⁰ Question text has been changed from Round 11 face-to-face for Round 12.
¹⁰¹ If country decides to use two education question, two showcards should be used with the same division of response options as in SC WEB and SC PAPER.

42

--- page 44 ---

Please report these in full-time equivalents and include compulsory years of schooling. If you don't know the exact figure, please give an estimate. Round your answer up or down to the nearest whole year.

Full-time equivalents: if you completed a part-time course, please count the number of years it would have taken you to complete the same course full-time.<sup>102</sup>

                    All modes          F2F only

Years of education  |   |   |          (Refusal)     77
                                       (Don't know)  88

*Soft check validation text: if entered number is >30, show this once
Please check whether you have entered an accurate number of completed years of education before pressing Next.
**Validation text: if the entered number is over 99 years or negative
Please provide an answer between 0 and 99 years.


ASK ALL
B16103 CARD 39 Which of the following descriptions applies to what you have been doing for the last 7 days?

   INSTRUCTIONS for all modes: Please select all that apply.

   F2F INTERVIEWER:
   PROBE: Which others?
   CODE ALL THAT APPLY

                                                                        All modes     F2F only
              in paid work (or away temporarily) (employee, self-employed,  01
                                        working for your family business)104
          in education, (not paid for by employer) even if on vacation104  02
                                  unemployed and actively looking for a job  03
              unemployed, wanting a job but not actively looking for a job  04
                                          permanently sick or disabled  05
                                                               retired  06
                                    in community or military service105  07
                  doing housework, looking after children or other persons  08
                                                              (Other)  09
                                                                        77  (Refusal)
                                                                        88  (Don't know)

*Soft check validation text: if no answers are selected, show this once

102 This text (Full-time equivalents...) has been added for face-to-face in Round 12.
103 Question text has been changed from Round 11 face-to-face for Round 12.
104 The use of round brackets here does not denote unprompted response options in face-to-face. They should be displayed in all modes.
105 This code does not apply to jobs in the military but to compulsory military and community service only. The category should be removed in countries where there is no compulsory military service (or equivalent compulsory community service served as an alternative to compulsory military service).

43

--- page 45 ---

It's important to know whether you are currently working or doing something else. This will ensure you get asked the correct questions later in the survey. Please provide an answer if you can.

*SC PAPER INSTRUCTIONS:*
If you selected more than one answer at B16, please **answer question B17.**
If you selected only one answer at B16, then **go to B18.**

**ASK IF MORE THAN ONE CODED AT B16**
**B17**    *STILL CARD 39* **And which of these descriptions best describes your situation in the last 7 days?**

INSTRUCTIONS for all modes: Please select only one.

**PROGRAMMING NOTE FOR F2F and SC WEB: Response options 1-9 should be filtered to only display options that were selected at B16**

                                                                                          All modes     F2F only
               in paid work (or away temporarily) (employee, self-employed, | 01
                                          working for your family business)¹⁰⁶
          in education, (not paid for by employer) even if on vacation¹⁰⁶ | 02
                                    unemployed and actively looking for a job | 03
               unemployed, wanting a job but not actively looking for a job | 04
                                              permanently sick or disabled | 05
                                                                          retired | 06
                                    in community or military service¹⁰⁷ | 07
          doing housework, looking after children or other persons | 08
                                                                        (Other) | 09
                                                                                    77    (Refusal)
                                                                                    88    (Don't know)

**\*Soft check validation text: if left blank, show this once**
**This question is important, please answer if you can.**

**ASK IF NOT IN PAID WORK AT B16 (IF NOT 01 at B16)**
**B18¹⁰⁸ Just to check, did you do any paid work of an hour or more in the last 7 days?**

           All modes          F2F only     Routing
                  Yes | 1 |               **Go to B21-B35**
                   No | 2 |               **Go to B19**
                       | 7 | (Refusal)
                       | 8 | (Don't know)

¹⁰⁶ The use of round brackets here does not denote unprompted response options in face-to-face. They should be displayed in all modes.
¹⁰⁷ This code does not apply to jobs in the military but to compulsory military and community service only. The category should be removed in countries where there is no compulsory military service (or equivalent compulsory community service served as an alternative to compulsory military service).
¹⁰⁸ Question text has been changed from Round 11 face-to-face for Round 12.

44

--- page 46 ---

ASK IF NO OR DON'T KNOW/REFUSAL/NO RESPONSE AT B18 (IF B18 = 2, 7, 8, 9)
**B19   Have you ever had a paid job?**

                    All modes        F2F only         Routing

                          Yes    1                    **Go to B20**

                           No    2                    **Go to B37 on page**
                                                      **[xx]**

                                 7   (Refusal)
                                 8   (Don't know)


**ASK IF YES AT B19 (IF B19 = 1)**
**B20   In what year were you last in a paid job?**

               All modes          F2F only

         Year                     (Refusal)     7777
                                  (Don't know)  8888

**\*\*Validation text: if year is before 1900 or in the future**
**Please provide a four-digit answer between 1900 and current year.**


*SC PAPER INSTRUCTIONS:*
**B21 – B35**

If you have never had a paid job, **go to B37 on page [xx].**


**ASK IF IN PAID WORK AT B16 OR B18, OR NOT IN PAID WORK BUT HAD A JOB IN THE PAST AT B19 (IF 01 AT B16 OR B18 = 1 OR B19 = 1)**
**B21_B35**
> *SC WEB and PAPER INSTRUCTIONS:*
**The next questions are about your job. If you are not currently working, please think about your last job when answering.**

If you currently have more than one job, please answer about the one for which you work the most hours. If you work the same number of hours for each job, please answer about the one for which you are most highly paid.


**PROGRAMMING NOTE FOR F2F AND SC WEB: If respondent currently in work (code 01 at B16 or code 01 at B18), programme B21 to B35 to use present tense and refer to current job; if not in paid work but had a job in the past (code 1 at B19), programme B21 to B35 to use past tense and refer to last job.**

*Note to F2F INTERVIEWER*:
IF RESPONDENT CURRENTLY IN WORK, B21 TO B35 REFER TO THEIR CURRENT JOB; IF NOT IN PAID WORK BUT HAD A JOB IN THE PAST, B21 TO B35 REFER TO THEIR LAST JOB.

IF THE RESPONDENT HAS MORE THAN ONE JOB, THEY SHOULD ANSWER ABOUT THE ONE WHICH OCCUPIES THEM FOR THE MOST HOURS PER WEEK. IF THEY HAVE TWO JOBS THAT ARE EXACTLY EQUAL, THEY SHOULD ANSWER ABOUT THE MORE HIGHLY PAID OF THE TWO.


**B21**

45

--- page 47 ---

SC WEB and F2F QUESTION WORDING:        SC PAPER QUESTION WORDING:
In your main job {are/were} you…          In your main job are you, or were you…

Note to F2F INTERVIEWER:
READ OUT

                                    All modes¹⁰⁹        F2F only          Routing

                                    an employee   1                        Go to B23

                                    self-employed  2                       Go to B22

              working for your own family's business  3                    Go to B23

                                                   7   (Refusal)

                                                   8   (Don't know)


ASK IF SELF-EMPLOYED AT B21 (IF B21 = 2)
B22¹¹⁰
SC WEB and F2F QUESTION WORDING:          SC PAPER QUESTION WORDING:
How many employees {do/did} you have?     How many employees do you, or did you, have?

SC WEB and PAPER INSTRUCTIONS:            Note to F2F INTERVIEWER:
If you are unsure, please provide an estimate. If you   TYPE IN NUMBER OF
have no employees, enter 0.               EMPLOYEES

          All modes                       F2F only

                                          (Refusal)      77777
                                          (Don't know)   88888


ASK IF IN PAID WORK AT B16 OR B18, OR NOT IN PAID WORK BUT HAD A JOB IN THE PAST AT B19 (IF 01 AT B16 OR B18 = 1 OR B19 = 1)¹¹¹
B23
SC WEB and F2F QUESTION WORDING:          SC PAPER QUESTION WORDING:
{Do/did} you have a work contract of…     Do you, or did you, have a work contract of...

Note to F2F INTERVIEWER:
READ OUT…

                                    All modes¹¹²        F2F only

                                    Unlimited duration  1

                                    Limited duration    2


¹⁰⁹ Response options have been changed from Round 11 face-to-face for Round 12.
¹¹⁰ Question text has been changed from Round 11 face-to-face for Round 12.
¹¹¹ This is a routing change for Round 12. Previously, question B23 was not asked to self-employed people, but to simplify routing they will be asked B23 in Round 12.
¹¹² Response options have changed from Round 11 face-to-face for Round 12

                                                                                          46

--- page 48 ---

No contract at all   3
                        7   (Refusal)
                        8   (Don't know)

**B24**
 SC WEB and F2F QUESTION WORDING:          SC PAPER QUESTION WORDING:
 Including yourself, about how many people  Including yourself, about how many people
 {are/were} employed at the place where you are, or were, employed at your place of work?
 usually {work/worked}?

 Note to F2F INTERVIEWER:
 READ OUT…

                All modes       F2F only
                under 10    1
                10 to 24    2
                25 to 99    3
               100 to 499   4
          500 or more¹¹³    5
                            7   (Refusal)
                            8   (Don't know)

**B25**
 SC WEB and F2F QUESTION WORDING:          SC PAPER QUESTION WORDING:
 In your main job, {do/did} you have any    In your main job, do you, or did you, have any
 responsibility for supervising¹¹⁴ the work of  responsibility for supervising the work of
 other employees?                           other employees?

           All modes       F2F only        Routing
                Yes    1                   Go to B26
                 No    2                   Go to B27
                        7   (Refusal)
                        8   (Don't know)

ASK IF YES AT B25 (IF B25 = 1)
**B26**
 SC WEB and F2F QUESTION WORDING:          SC PAPER QUESTION WORDING:
 How many people {are/were} you             How many people are you, or were you,
 responsible for?                           responsible for?

¹¹³ 'or' has been removed from the beginning of this response option for Round 12
¹¹⁴ 'Supervising': intended in the sense of both monitoring and being responsible for the work of others.

47

--- page 49 ---

*Note to F2F INTERVIEWER*:
TYPE IN NUMBER

   All modes                    F2F only

                                (Refusal)     77777
                                (Don't know)  88888


ASK IF IN PAID WORK AT B16 OR B18, OR NOT IN PAID WORK BUT HAD A JOB IN THE PAST AT B19 (IF 01 AT B16 OR B18 = 1 OR B19 = 1)
B27¹¹⁵

 SC WEB and F2F QUESTION WORDING:          SC PAPER QUESTION WORDING:
 CARD 40 How much {does/did} the           How much does, or did, the management at
 management at your work allow you to      your work allow you to decide how your own
 decide how your own daily work {is/was}   daily work is, or was, organised?
 organised?

PROGRAMMING NOTE: Response option labels differ in B27 and B28 for SC PAPER compared to SC WEB and F2F

                        SC WEB & F2F                                    F2F only

 I {have/had} no                                          I {have/had}  (Refusal)   (Don't
 influence                                                  complete                 know)
                                                             control
 00          01    02    03    04    05    06    07    08    09          10    77      88


                                          SC PAPER

 I have or                                                                    I have or had
 had no                                                                          complete
 influence                                                                        control

 00          01    02    03    04         05    06    07    08    09              10


B28¹¹⁵

 SC WEB and F2F QUESTION WORDING:          SC PAPER QUESTION WORDING:
 STILL CARD 40 How much {does/did} the     How much does, or did, the management at
 management at your work allow you to      your work allow you to influence policy
 influence policy decisions about the      decisions about the activities of the
 activities of the organisation?           organisation?

PROGRAMMING NOTE: Response option labels differ in B27 and B28 for SC PAPER compared to SC WEB and F2F

                        SC WEB & F2F                                    F2F only

 I {have/had} no                                          I {have/had}  (Refusal)   (Don't
 influence                                                  complete                 know)
                                                             control
 00          01    02    03    04    05    06    07    08    09          10    77      88


¹¹⁵ Question text has been changed from Round 11 face-to-face for Round 12. Questions B27 and B28 have been updated to present the full question stem for each item.

48

--- page 50 ---

SC PAPER

 I have or                                                                                              I have or had
 had no                                                                                                      complete
 influence                                                                                                     control

  00          01      02      03      04      05      06      07      08      09                              10


**B29116**
 SC WEB and F2F QUESTION WORDING:              SC PAPER QUESTION WORDING:
 What {are/were} your total 'basic' or         What are, or were, your total 'basic' or
 contracted hours each week in your main       contracted hours each week in your main job?
 job?

 INSTRUCTIONS for all modes:
 Please exclude any paid and unpaid overtime. Round up or down to whole hours.

PROGRAMMING NOTE: Respondents on SC web should be allowed to type in a number and answer 'Do not have set 'basic' or contracted number of hours'. In this case the number typed in should be retained in data processing and the tick box answer disregarded.

 Note to F2F INTERVIEWER:
 ACCEPTABLE RANGE OF RESPONSES IS BETWEEN 0 AND 168 HOURS.
 TYPE IN HOURS


                                          All modes              F2F only



          (No set 'basic' or contracted number of hours)   555
                                                           777   (Refusal)
                                                           888   (Don't know)


**\*Soft check validation text: if number entered is >80 & <169, show this once**
**Please check whether you have entered an accurate number of weekly contracted working hours before pressing Next.**
**\*\*Validation text: if number is entered is >168**
**We are asking about your contracted working hours each week. Please provide an answer that is less than the total number of hours in a week, which is 168.**
**\*\*Validation text: if number entered is <0**
**Please enter a positive number.**


**B30**
 SC WEB and F2F QUESTION WORDING:              SC PAPER QUESTION WORDING:
 Regardless of your basic or contracted        Regardless of your basic or contracted hours,
 hours, how many hours {do/did} you            how many hours do you, or did you, normally
 normally work a week in your main job,        work a week in your main job, including any
 including any paid or unpaid overtime?        paid or unpaid overtime?

 SC WEB and PAPER INSTRUCTIONS:

116 Question text has been changed from Round 11 face-to-face for Round 12.

49

--- page 51 ---

This may be the same as your 'basic' or contracted hours or different. If your hours vary week-to-week, please give your best estimate. Round up or down to whole hours.
*Note to F2F INTERVIEWER:*
ACCEPTABLE RANGE OF RESPONSES IS BETWEEN 0
AND 168 HOURS.
TYPE IN HOURS

                              All modes          F2F only

                                             777   (Refusal)
                                             888   (Don't know)

**Soft check validation text: if number entered is >80 & <169, show this once**
**Please check whether you have entered an accurate number of your normal working hours per week before pressing Next.**
****Validation text: if number is entered is >168**
**We are asking about your working hours each week. Please provide an answer that is less than the total number of hours in a week, which is 168.**
****Validation text: if number entered is <0**
**Please enter a positive number.**

**B31**
 SC WEB and F2F QUESTION WORDING:          SC PAPER QUESTION WORDING:
 **What {does/did} the firm or organisation you   What does, or did, the firm or organisation you**
 **{work/worked} for mainly make or do?**         **work for, or used to work for, mainly make or**
                                                  **do?**
 SC WEB and PAPER INSTRUCTIONS:
 Please give as much detail as you can. But if you can only provide basic information, this would still
 be helpful.
 *Note to F2F INTERVIEWER:*
 TYPE IN

                    All modes                              F2F only

 _______________________________________________      (Refusal)    77777
 _______________________________________________      (Don't know) 88888

**B32¹¹⁷**
 SC WEB and F2F QUESTION WORDING:          SC PAPER QUESTION WORDING:
 *CARD 41* **Which of the following types of        Which of the following types of organisation**
 **organisation {do/did} you work for?**            **do you, or did you, work for?**
 *Note to F2F INTERVIEWER:*                SC PAPER INSTRUCTIONS:
 CODE ONE ANSWER ONLY                      Select one answer only.

                              All modes          F2F only
              Central or local government    01

¹¹⁷ Question text has been changed from Round 11 face-to-face for Round 12.

50

--- page 52 ---

Other public sector (such as education and health)¹¹⁸  | 02 |
                                  A state-owned enterprise | 03 |
                                           A private firm | 04 |
                                          Self-employed | 05 |
                                                  Other | 06 |
                                                        | 77 | (Refusal)
                                                        | 88 | (Don't know)


**B33**¹¹⁹
 SC WEB and F2F QUESTION WORDING:          SC PAPER QUESTION WORDING:
 What {is/was} your main job?              What is, or was, your main job?

 SC WEB and PAPER INSTRUCTIONS:

 Please be as specific as possible, e.g. 'Primary school teacher' rather than 'Teacher'¹²⁰.


 Note to F2F INTERVIEWER:
 TYPE IN

                    All modes                            F2F only

 _______________________________________________
                                                         (Refusal)     77777
 _______________________________________________          (Don't know)  88888

**\*\*Soft check validation text: if left blank, show this once**
**Please type in an answer here if you can. This will help categorise people working in different**
**types of jobs and allow us to understand how this relates to their experiences and opinions.**


**B34**¹¹⁹
 SC WEB and F2F QUESTION WORDING:          SC PAPER QUESTION WORDING:
 What {do/did} you mainly do in this job?  What do you, or did you, mainly do in this
                                           job?

 Note to F2F INTERVIEWER:
 TYPE IN

                    All modes                            F2F only

 _______________________________________________
                                                         (Refusal)     77777
 _______________________________________________          (Don't know)  88888


**B35**¹¹⁹
 SC WEB and F2F QUESTION WORDING:          SC PAPER QUESTION WORDING:

¹¹⁸ The use of round brackets here does not denote unprompted response options in face-to-face. They should be displayed in all modes.
¹¹⁹ Question text has been changed from Round 11 face-to-face for Round 12.
¹²⁰ This example can be country specific. NC teams should consider common occupation titles that are easy to understand by respondents, and where additional detail could help in post coding.

51

--- page 53 ---

What training or qualifications {are/were} needed for this job?   What training or qualifications are or were needed for this job?

*SC WEB AND PAPER INSTRUCTIONS:*

We are interested in what qualifications are normally required for this job. This may be different to your highest qualification. If no specific training or qualifications are needed, please write 'None'.

*Note to F2F INTERVIEWER:*
TYPE IN

           All modes                                          F2F only

_______________________________________________
_______________________________________________                    (Refusal)    77777
_______________________________________________                    (Don't know) 88888

**B36   In the last 10 years have you done any paid work in another country for a period of 6 months or more?**

                    All modes        F2F only
                          Yes   1
                           No   2
                                7   (Refusal)
                                8   (Don't know)

**ASK ALL**
*SC WEB AND PAPER:*
We'd now like to know about whether there was a time when you haven't had a job but were looking for one.

**B37   Have you ever been unemployed and seeking work for a period of more than 3 months?**

                    All modes        F2F only        Routing
                          Yes   1                    **Go to B38**
                           No   2                    **Go to B40**
                                7   (Refusal)
                                8   (Don't know)

**ASK IF YES AT B37 (IF B37 = 1)**
**B38¹²¹ Have any of these periods of unemployment lasted for 12 months or more?**

                    All modes        F2F only
                          Yes   1
                           No   2
                                7   (Refusal)
                                8   (Don't know)

¹²¹ Question text has been changed from Round 11 face-to-face for Round 12.

52

--- page 54 ---

B39¹²² Have any of these periods of unemployment, that lasted more than 3 months, been within the
         past 5 years?

                        All modes |     | F2F only
                              Yes | 1   |
                               No | 2   |
                                  | 7   | (Refusal)
                                  | 8   | (Don't know)


ASK ALL
B40    Are you or have you ever been a member of a trade union or similar organisation?

        Note to F2F INTERVIEWER:
        IF YES, is that currently or previously?

                        All modes |     | F2F only
                   Yes, currently | 1   |
                  Yes, previously | 2   |
                               No | 3   |
                                  | 7   | (Refusal)
                                  | 8   | (Don't know)


B41¹²³ CARD 42 Please consider the income of all household members and any income which may
       be received by the household as a whole. What is the main source of income in your
       household?
        SC PAPER INSTRUCTIONS
        Select one answer only.

                                                All modes |     | F2F only
                                    Wages or salaries | 01  |
         Income from self-employment (excluding farming)¹²⁴ | 02  |
                                      Income from farming | 03  |
                                                 Pensions | 04  |
                              Unemployment/redundancy benefit | 05  |
                              Any other social benefits or grants | 06  |
         Income from investment, savings, insurance or property | 07  |
                                    Income from other sources | 08  |
                                                              | 77  | (Refusal)
                                                              | 88  | (Don't know)

¹²² This question has been modified for Round 12 face-to-face, incorporating a probe into the question wording.
¹²³ Question text has been changed from Round 11 face-to-face for Round 12.
¹²⁴ The use of round brackets here does not denote unprompted response options in face-to-face. They should be displayed in all modes.

53

--- page 55 ---

PROGRAMMING NOTE: B42 is to be programmed differently for SC WEB, SC PAPER, and F2F. For SC WEB, a filter question (B42filter) initially asks respondents if they would prefer to see weekly, monthly or annual income deciles, leading the respondent to one of three B42 versions - B42a for weekly figures, B42b for monthly figures, or B42c for annual figures. Note that country teams may choose which income periods to offer to respondents at B42filter or choose to only display one type of figure and not ask B42filter at all.

**B42filter** [*SC WEB only]*
*SC WEB QUESTION WORDING:*
The next question refers to your household's total income (after tax and compulsory deductions).

**Please indicate whether you would prefer to provide your income in weekly, monthly, or annual figures.125**

*SC WEB RESPONSE OPTIONS:*
                    SC WEB only  |       | Routing for SC WEB only
                         Weekly  |  1  | Go to B42a
                        Monthly  |  2  | Go to B42b
                         Annual  |  3  | Go to B42c

**B42a, B42b, B42c** [*SC WEB only]*
ASK IF 01 AT B42filter (IF B42filter = 1)
*B42a SC WEB QUESTION WORDING*
**What is your household's total weekly income, after tax and compulsory deductions, from all sources?**  |  ASK IF 02 AT B42filter (IF B42filter = 2)
*B42b SC WEB QUESTION WORDING*
**What is your household's total monthly income, after tax and compulsory deductions, from all sources?**  |  ASK IF 03 AT B42filter (IF B42filter = 3)
*B42c SC WEB QUESTION WORDING*
**What is your household's total annual income, after tax and compulsory deductions, from all sources?**

*SC WEB INSTRUCTIONS*
If you don't know the exact figure, please give an estimate.

**PROGRAMMING NOTE FOR SC WEB: Program SC WEB so that response options for B42a reflect weekly income deciles, B42b reflect monthly income deciles, and B42c reflect annual income deciles. Countries may decide to use all three, two, or just one of these classifications**

                    SC WEB only  |
                       Option 1  |  01
                       Option 2  |  02
                       Option 3  |  03
                       Option 4  |  04
                       Option 5  |  05
                       Option 6  |  06

¹²⁵ Countries decide whether to ask B42filter, which asks the respondent if they would like to see weekly, monthly, or annual deciles. Countries may rather decide to only show one set of income deciles in which case the respondent is routed directly to B42 and B42filter is not asked.
Countries that ask B42filter may decide to only display two out of the three types of deciles. If displaying only two, translators must hide one response option and modify the question text accordingly. For example, if you decide to only offer monthly and annual categories, you would hide the 'Weekly' response option at B42filter and update the question text at B42filter to 'Please indicate whether you would prefer to provide your income in monthly or annual figures'.
In all cases, three columns of income deciles for each period are exported to the paper questionnaire. Countries that decide to display one or two types of income deciles need to manually remove the extra columns from their inDesign paper template.

54

--- page 56 ---

Option 7  |  07
         Option 8  |  08
         Option 9  |  09
        Option 10  |  10
Prefer not to answer  |  77


**B42126** [*SC PAPER and F2F only]*

*SC PAPER QUESTION WORDING*                *F2F QUESTION WORDING*
**What is your household's total           *CARD 43* **Using this card, please tell me which letter
income, after tax and compulsory           describes your household's total income, after tax and
deductions, from all sources?**            compulsory deductions, from all sources? If you don't
                                           know the exact figure, please give an estimate.**

                                           **Use the part of the card that you know best: weekly,
                                           monthly or annual income127.**

*SC PAPER INSTRUCTIONS:*
If you don't know the exact figure, please use an estimate.
Select one answer only.

**PROGRAMMING NOTE for SC PAPER: country teams can decide whether to display weekly, monthly, and/or annual income deciles on their paper questionnaire.**

SC PAPER RESPONSE OPTIONS          F2F RESPONSE OPTIONS

              Option 1  |  01  |  J
              Option 2  |  02  |  R
              Option 3  |  03  |  C
              Option 4  |  04  |  M
              Option 5  |  05  |  F
              Option 6  |  06  |  S
              Option 7  |  07  |  K
              Option 8  |  08  |  P
              Option 9  |  09  |  D
             Option 10  |  10  |  H
   Prefer not to answer  |  77  |  (Refusal)
                         |  88  |  (Don't know)

**NOTE ON FRAMING DECILE INCOME QUESTION, CATEGORIES AND CARD IN F2F**
Income response options should be devised with approximate **weekly, monthly and annual amounts**. You should use **ten income range categories, each corresponding broadly to DECILES OF THE ACTUAL HOUSEHOLD INCOME RANGE in your country.** Please see the ESS12 Data Protocol for guidance on data sources to refer to and further instructions on the construction of categories.

Please note that the full list of response categories must **always** be used at this question. The ten rows should display the income ranges selected. Each country can choose whether to include weekly, monthly or annual amounts on the showcard or include more than one of these as appropriate. The text in the last sentence of B42 (above) should be rephrased to match the solution selected.

126 In the CAPI questionnaire, this question number is displayed as B42e.
127 The actual amounts must NOT appear in the face-to-face questionnaire. Only the letters and the corresponding numeric codes.

55

--- page 57 ---

ASK ALL
B43¹²⁸ *CARD 44* **Which of the following descriptions comes closest to how you feel¹²⁹ about your household's income nowadays?**

                                             All modes  |    F2F only

                  Living comfortably on present income  | 1 |
                            Coping on present income  | 2 |
                  Finding it difficult on present income  | 3 |
          Finding it very difficult on present income  | 4 |
                                                         | 7 | (Refusal)
                                                         | 8 | (Don't know)

**B44_intro**
*SC PAPER INSTRUCTIONS:*
**[B44a/B44]¹³⁰-B52**

If you do live with a husband, wife, or partner, please **answer question [B44a/B44]**¹³⁰.

If you do not live with a husband, wife, or partner, **go to [B53a/B53]¹³¹ on page [xx].**

¹²⁸ Question text has been changed from Round 11 face-to-face for Round 12.
¹²⁹ 'Feel': 'describe', 'view' or 'see'.
¹³⁰ If country decides to use two education questions, B44a should be displayed in SC PAPER. If a country decides to use one education question, B44 should be displayed in SC PAPER.
¹³¹ If country decides to use two education questions, B53a should be displayed in SC PAPER. If a country decides to use one education question, B53 should be displayed in SC PAPER.

56

--- page 58 ---

ASK IF LIVING WITH HUSBAND/WIFE/PARTNER AT B7 (IF 01 AT B7)

B44a/B44b to be asked as country-specific question(s). Refer to education consultation for wording in all modes. To be recoded into the ESS Education Detailed ISCED Coding Frame. Countries opt whether to use one or two questions and modify question wording accordingly. For countries that use one question, SC PAPER should display B44. Response options to be the same as B14.

PROGRAMMING NOTE: allow country-specific routing for whether one or two questions are asked.

B44a¹³² CARD 45a¹³³ [Country-specific text for partner's highest education question here]
B44b CARD 45b [Country-specific text for partner's highest education question here]

INSTRUCTIONS for all modes:
[If they are currently in education, select what corresponds to the highest level they have completed so far. If they completed their education abroad, select the most similar [country] education level.]

                                         All Modes        F2F only
                                          Option 1  01
                                          Option 2  02
                                          Option 3  03
                                          Option 4  04
                                          Option 5  05
                                          Option 6  06
                                          Option 7  07
                                          Option 8  08
                                          Option 9  09
                                         Option 10  10
                                         Option 11  11
                                         Option 12  12
                                         Option 13  13
                                         Option 14  14
                                         Option 15  15
                                         Option 16  16
                                         Option 17  17
                                         Option 18  18
                                         Option 19  19
                                         Option 20  20
                                         Option 21  21
                                         Option 22  22
                                         Option 23  23
                                         Option 24  24
                                Other: please write in  25
                                                        7777  (Refusal)
                                                        8888  (Don't know)

B45¹³² CARD 46 Which of the following descriptions applies to what your husband, wife, or partner has been doing for the last 7 days?

   INSTRUCTIONS for all modes: Please select all that apply.

¹³² Question text has been changed from Round 11 face-to-face for Round 12.
¹³³ If country decides to use two education questions, two showcards should be used with the same division of response options as in SC WEB and SC PAPER.

57

--- page 59 ---

*F2F INTERVIEWER*:
PROBE: Which others?
CODE ALL THAT APPLY

                                                                          All modes      F2F only
          in paid work (or away temporarily) (employee, self-employed,  01
                                     working for your family business)¹³⁴
          in education, (not paid for by employer) even if on vacation¹³⁴  02
                                unemployed and actively looking for a job  03
               unemployed, wanting a job but not actively looking for a job  04
                                              permanently sick or disabled  05
                                                                   retired  06
                                        in community or military service¹³⁵  07
                    doing housework, looking after children or other persons  08
                                                                   (Other)  09
                                                                             77   (Refusal)
                                                                             88   (Don't know)

*SC PAPER INSTRUCTIONS:*
If you selected more than one answer at B45, please **answer question B46.**

If you selected only one answer at B45, then **go to B47.**


**ASK IF MORE THAN ONE CODED AT B45**
**B46**     *STILL CARD 46* **And which of these descriptions best describes your husband, wife, or partner's situation in the last 7 days?**
         *INSTRUCTIONS for all modes:* Please select only one.

      **PROGRAMMING NOTE FOR F2F and SC WEB: Response options 1-9 should be filtered to only display options that were selected at B45.**

                                                                          All modes      F2F only
          in paid work (or away temporarily) (employee, self-employed,  01
                                     working for your family business)¹³⁴
          in education, (not paid for by employer) even if on vacation¹³⁴  02
                                unemployed and actively looking for a job  03
               unemployed, wanting a job but not actively looking for a job  04
                                              permanently sick or disabled  05
                                                                   retired  06

¹³⁴ The use of round brackets here does not denote unprompted response options in face-to-face. They should be displayed in all modes.
¹³⁵ This code does not apply to jobs in the military but to compulsory military and community service only. The category should be removed in countries where there is no compulsory military service (or equivalent compulsory community service served as an alternative to compulsory military service).

58

--- page 60 ---

in community or military service¹³⁶ 07
                    doing housework, looking after children or other persons 08
                                                              (Other) 09
                                                                    77  (Refusal)
                                                                    88  (Don't know)


ASK IF PARTNER NOT IN PAID WORK AT B45 (IF NOT 01 at B45)
B47¹³⁷ Just to check, did your husband, wife, or partner do any paid work of an hour or more in the
    last 7 days?

              All modes        F2F only        Routing

              Yes    1                         Go to B48

              No     2                         Go to [B53a/B53]¹³⁸
                     7    (Refusal)
                     8    (Don't know)


ASK IF PARTNER IN PAID WORK AT B45 OR B47 (IF B45=1 OR B47 = 1)
B48¹³⁷ What is your husband, wife, or partner's main job?

   Note to F2F INTERVIEWER:
   TYPE IN

                   All modes                             F2F only

   ___________________________________________           (Refusal)    77777
   ___________________________________________           (Don't know) 88888
   ___________________________________________


B49¹³⁷ What does your husband, wife, or partner mainly do in their job?

   Note to F2F INTERVIEWER:
   TYPE IN

                   All modes                             F2F only

   ___________________________________________           (Refusal)    77777
   ___________________________________________           (Don't know) 88888


B50¹³⁷ What training or qualifications are needed for your husband, wife, or partner's job?

 SC WEB AND PAPER INSTRUCTIONS:                    Note to F2F INTERVIEWER:

 If no specific training or qualifications are needed, please  TYPE IN
 write 'None'.

¹³⁶ This code does not apply to jobs in the military but to compulsory military and community service only. The category should be removed in countries where there is no compulsory military service (or equivalent compulsory community service served as an alternative to compulsory military service).
¹³⁷ Question text has been changed from Round 11 face-to-face for Round 12.
¹³⁸ If a country chooses to have one question at B53 instead of two, B53a should be changed to B53.

59

--- page 61 ---

All modes                          F2F only

___________________________________________
___________________________________________        (Refusal)    77777
___________________________________________        (Don't know) 88888


**B51¹³⁹  In your husband, wife, or partner's main job are they…**

   *Note to F2F INTERVIEWER:*
   READ OUT


                              All modes        F2F only

                           an employee  1
                         self-employed  2
   working for your own family's business  3
                                         7  (Refusal)
                                         8  (Don't know)


**B52**¹³⁹ **How many hours does your husband, wife, or partner normally work a week in their main job?**
   *INSTRUCTIONS for all modes*: Please include any paid or unpaid overtime.

   SC WEB AND PAPER INSTRUCTIONS:          Note to F2F INTERVIEWER:
   If his/her hours vary week-to-week, please    ACCEPTABLE RANGE OF RESPONSES IS
   give your best estimate. Round up or down to  BETWEEN 0 AND 168 HOURS.
   whole hours.                                  TYPE IN HOURS


                              All modes        F2F only

                          [          ]
                                         777  (Refusal)
                                         888  (Don't know)

**\*Soft check validation text: if number entered is >80 & <169, show this once**
**Please check whether you have entered an accurate number of normal working hours per week for your husband, wife, or partner before pressing Next.**
**\*\*Validation text: if number is entered is >168**
**We are asking about your husband, wife, or partner's working hours each week. Please provide an answer that is less than the total number of hours in a week, which is 168.**
**\*\*Validation text: if number entered is <0**
**Please enter a positive number.**


**ASK ALL**
**B53_intro**

>The following questions are about your parents' education and employment.

¹³⁹ Question text has been changed from Round 11 face-to-face for Round 12.

60

--- page 62 ---

B53a/B53b to be asked as country-specific question(s). Refer to education consultation for wording in all modes. To be recoded into the ESS Education Detailed ISCED Coding Frame. Countries opt whether to use one or two questions and modify question wording accordingly. For countries that use one question, SC PAPER should display B53. Response options to be the same as B14.

PROGRAMMING NOTE: allow country-specific routing for whether one or two questions are asked.

**B53a¹⁴⁰** *CARD 47a¹⁴¹* **[Country-specific text for father's highest education question here]
B53b** *CARD 47b* **[Country-specific text for father's highest education question here]**

INSTRUCTIONS for all modes:
[If he is currently in education, select what corresponds to the highest level he has completed so far. If he completed his education abroad, select the most similar [country] education level.]

                                        All Modes        F2F only
                               Option 1  01
                               Option 2  02
                               Option 3  03
                               Option 4  04
                               Option 5  05
                               Option 6  06
                               Option 7  07
                               Option 8  08
                               Option 9  09
                              Option 10  10
                              Option 11  11
                              Option 12  12
                              Option 13  13
                              Option 14  14
                              Option 15  15
                              Option 16  16
                              Option 17  17
                              Option 18  18
                              Option 19  19
                              Option 20  20
                              Option 21  21
                              Option 22  22
                              Option 23  23
                              Option 24  24
                  Other: please write in  25
          (Prefer not to answer)¹⁴²  7777
                                         8888  (Don't know)

**B54     When you were 14, did your father work as an employee, was he self-employed, or was he not working then?**

                              All modes         F2F only         Routing

¹⁴⁰ Question text has been changed from Round 11 face-to-face for Round 12.
¹⁴¹ If country decides to use two education questions, two showcards should be used with the same division of response options as in SC WEB and SC PAPER.
¹⁴² The use of round brackets in the 'All modes' column denotes unprompted response options in F2F. In F2F, '(Prefer not to answer)' takes the place of '(Refusal)' at this question.

61

--- page 63 ---

Employee  1
                                                                                                    Go to B55
                                        Self-employed  2

                                          Not working  3
                                                                                                    Go to
(Father deceased or absent¹⁴⁴ when I was 14)¹⁴⁵¹⁴⁶  4
                                                                                                    [B56a/B56]¹⁴³
                              (Prefer not to answer)¹⁴⁷  7

                                                         8  (Don't know)  Go to B55


ASK IF FATHER WORKING OR DON'T KNOW OR NO RESPONSE AT B54 (IF B54 = 1, 2, 8, 9)
B55¹⁴⁸ CARD 48 Which one of the descriptions from the following list¹⁴⁹ best describes the sort of
     work your father did when you were 14?

 SC WEB AND PAPER INSTRUCTIONS:          Note to F2F INTERVIEWER:
 There is no right or wrong answer. Just  CODE ONE ANSWER ONLY
 choose the category you think fits best.  RESPONDENTS MUST CHOOSE A CATEGORY
                                          THEMSELVES. IF NECESSARY ADD:
 Please select one answer only.
                                          'There is no right or wrong answer. Just choose the
                                          category you think fits best'.

                                                        All modes       F2F only

        Professional and technical occupations
                                                                   01
        such as: doctor, teacher, engineer, artist, accountant
        Higher administrator occupations
        such as: banker, executive in big business, high government official,  02
        union official
        Clerical occupations
                                                                   03
        such as: secretary, clerk, office manager, book keeper
        Sales occupations
                                                                   04
        such as: sales manager, shop owner, shop assistant, insurance agent
        Service occupations
        such as: restaurant owner, police officer, waiter, caretaker, barber,  05
        armed forces
        Skilled worker
        such as: foreman, motor mechanic, printer, tool and die maker,  06
        electrician
        Semi-skilled worker
        such as: bricklayer, bus driver, cannery worker, carpenter, sheet metal  07
        worker, baker
        Unskilled worker
                                                                   08
        such as: labourer, porter, unskilled factory worker
        Farm worker
                                                                   09
        such as: farmer, farm labourer, tractor driver, fisherman
        (Prefer not to answer)¹⁴⁷                                  77

                                                                   88  (Don't know)


¹⁴³ If a country chooses to have one question at B56 instead of two, B56a should be changed to B56.
¹⁴⁴ 'Absent': not living in same household.
¹⁴⁵ Response option has been modified from Round 11 face-to-face for Round 12.
¹⁴⁶ The use of round brackets in the 'All modes' column denotes unprompted response options in F2F.
¹⁴⁷ The use of round brackets in the 'All modes' column denotes unprompted response options in F2F. In F2F, '(Prefer not to answer)' takes the place of '(Refusal)' at this question.
¹⁴⁸ Question text has been changed from Round 11 face-to-face for Round 12.
¹⁴⁹ The occupations here have not been annotated. If translators are unable to identify the intended occupation, contact ess_translate@gesis.org.

62

--- page 64 ---

ASK ALL
Now thinking about your **mother's** education

**B56a/B56b to be asked as country-specific question(s). Refer to education consultation for wording in all modes. To be recoded into the ESS Education Detailed ISCED Coding Frame. Countries opt whether to use one or two questions and modify question wording accordingly. For countries that use one question, SC PAPER should display B56. Response options to be the same as B14. PROGRAMMING NOTE: allow country-specific routing for whether one or two questions are asked.**

**B56a**¹⁵⁰ *CARD 49a¹⁵¹* **[Country-specific text for mother's highest education question here]
B56b** *CARD 49b* **[Country-specific text for mother's highest education question here]**

INSTRUCTIONS for all modes:
[If she is currently in education, select what corresponds to the highest level she has completed so far. If she completed her education abroad, select the most similar [country] education level.]

                                    All Modes        F2F only
                         Option 1  01
                         Option 2  02
                         Option 3  03
                         Option 4  04
                         Option 5  05
                         Option 6  06
                         Option 7  07
                         Option 8  08
                         Option 9  09
                        Option 10  10
                        Option 11  11
                        Option 12  12
                        Option 13  13
                        Option 14  14
                        Option 15  15
                        Option 16  16
                        Option 17  17
                        Option 18  18
                        Option 19  19
                        Option 20  20
                        Option 21  21
                        Option 22  22
                        Option 23  23
                        Option 24  24
              Other: please write in  25
       (Prefer not to answer)¹⁵²  7777
                                   8888  (Don't know)

**B57    When you were 14, did your mother work as an employee, was she self-employed, or was she not working then?**

                    All modes        F2F only        Routing

¹⁵⁰ Question text has been changed from Round 11 face-to-face for Round 12.
¹⁵¹ If country decides to use two education questions, two showcards should be used with the same division of response options as in SC WEB and SC PAPER.
¹⁵² The use of round brackets in the 'All modes' column denotes unprompted response options in F2F. In F2F, '(Prefer not to answer)' takes the place of '(Refusal)' at this question.

63

--- page 65 ---

Employee | 1 |              | Go to B58
               Self-employed | 2 |              |
                 Not working | 3 |              |
(Mother deceased or absent¹⁵³ when I was 14)¹⁵⁴¹⁵⁵ | 4 |   | Go to B59
        (Prefer not to answer)¹⁵⁶ | 7 |        |
                              | 8 | (Don't know) | Go to B58


ASK IF MOTHER WORKING OR DON'T KNOW OR NO RESPONSE AT B57 (IF B57 = 1, 2, 8, 9)
B58¹⁵⁷ CARD 50 Which one of the descriptions from the following list¹⁵⁸ best describes the sort of work your mother did when you were 14?

 SC WEB AND PAPER INSTRUCTIONS:          Note to F2F INTERVIEWER:
 There is no right or wrong answer. Just CODE ONE ANSWER ONLY
 choose the category you think fits best.
                                         RESPONDENTS MUST CHOOSE A CATEGORY
 Please select one answer only.          THEMSELVES. IF NECESSARY ADD:
                                         'There is no right or wrong answer. Just choose the
                                         category you think fits best'.

                                                          All modes      F2F only

   **Professional and technical occupations**
   *such as:* doctor, teacher, engineer, artist, accountant               01
   **Higher administrator occupations**
   *such as*: banker, executive in big business, high government official, 02
   union official
   **Clerical occupations**
   *such as:* secretary, clerk, office manager, book keeper               03
   **Sales occupations**
   *such as:* sales manager, shop owner, shop assistant, insurance agent  04
   **Service occupations**
   *such as:* restaurant owner, police officer, waiter, caretaker, barber, 05
   armed forces
   **Skilled worker**
   *such as:* foreman, motor mechanic, printer, tool and die maker,       06
   electrician
   **Semi-skilled worker**
   *such as:* bricklayer, bus driver, cannery worker, carpenter, sheet metal 07
   worker, baker
   **Unskilled worker**
   *such as:* labourer, porter, unskilled factory worker                  08
   **Farm worker**
   *such as:* farmer, farm labourer, tractor driver, fisherman            09
   (Prefer not to answer)¹⁵⁶                                             77
                                                                          88    (Don't know)

¹⁵³ 'Absent': not living in same household.
¹⁵⁴ Response option has been modified from Round 11 face-to-face for Round 12.
¹⁵⁵ The use of round brackets in the 'All modes' column denotes unprompted response options in F2F.
¹⁵⁶ The use of round brackets in the 'All modes' column denotes unprompted response options in F2F. In F2F, '(Prefer not to answer)' takes the place of '(Refusal)' at this question.
¹⁵⁷ Question text has been changed from Round 11 face-to-face for Round 12.
¹⁵⁸ The occupations here have not been annotated. If translators are unable to identify the intended occupation, contact ess_translate@gesis.org.

64

--- page 66 ---

ASK ALL
 *SC WEB AND PAPER INSTRUCTIONS:*
The next few questions are about you.

**B59   During the last twelve months, have you taken any course or attended any lecture or
         conference to improve your knowledge or skills for work?**

                        All modes        F2F only

                              Yes    1
                               No    2
                                      7    (Refusal)
                                      8    (Don't know)

**B60**   *CARD 51* **How would you describe your ancestry159?**

 *F2F INTERVIEWER          SC WEB INSTRUCTIONS:             SC PAPER INSTRUCTIONS:*
 *INSTRUCTIONS:*

 Please use this card to choose    Using the two drop-down          Please choose up to two
 up to two ancestries that best    menus below, please choose       ancestries that best apply to
 apply to you.                     up to two ancestries that best   you. If you only have one
                                   apply to you. If you only have   ancestry, please leave the
 CODE MAXIMUM OF TWO               one ancestry, please select      second column blank.
 ANCESTRIES IN TOTAL.              'No second ancestry' from the
                                   second drop-down menu.
 IF MORE THAN TWO ARE
 MENTIONED, ASK
 RESPONDENT TO SELECT
 TWO.

 IF RESPONDENT IS UNABLE
 TO DO THIS, CODE FIRST
 TWO ANCESTRIES
 MENTIONED.

 IF RESPONDENT ONLY
 SAYS ONE ANCESTRY,
 PROBE ONCE: Which other?

**Program SC WEB and F2F so that country-specific ancestry items appear in drop down menus labelled Ancestry 1 and Ancestry 2. The second drop-down menu should begin with the option 'No second ancestry'.**

**PROGRAMMING NOTE: a maximum of 20 response options not including the 'Other' category will be allowed.**

                        Ancestry 1              Ancestry 2

             Option 1   01                      01
             Option 2   02                      02

159 'Ancestry' in the sense of 'descent' or 'family origins'.

                                                                                                    65

--- page 67 ---

Option 3   03                    03
Option 4   04                    04
Option 5   05                    05
Option 6   06                    06
Option 7   07                    07
Option 8   08                    08
Option 9   09                    09
Option 10  10                    10
Option 11  11                    11
Option 12  12                    12
Option 13  13                    13
Option 14  14                    14
Option 15  15                    15
Option 16  16                    16
Option 17  17                    17
Option 18  18                    18
Option 19  19                    19
Option 20  20                    20
Other [Note to F2F  ________________     ________________
INTERVIEWER: IF OTHER
SELECTED, TYPE THEIR
ANCESTRY HERE]
                                          All modes
(No second ancestry)¹⁶⁰               555555
                    F2F only             F2F only
(Refusal)           777777               777777
(Don't know)        888888               888888

SC PAPER INSTRUCTIONS and RESPONSE        SC WEB INSTRUCTIONS and RESPONSE
OPTIONS:                                  OPTIONS:

Please write in your ancestry if you selected    Programming note: Place after Ancestry 1 drop-
'Other' above:                                   down menu

                                                 Please type in your ancestry if you selected 'Other'
                                                 above:
Ancestry 1:

_______________________________________          Ancestry 1

¹⁶⁰ In SC PAPER, this option is not shown in the questionnaire. It is only coded in SC PAPER if Ancestry 1 has been provided. In SC WEB, this option should be the first response option in the second drop-down menu.

66

--- page 68 ---

Ancestry 2:

______________________________________

___________________________________________

Programming note: Place after Ancestry 2 drop-down menu

Please type in your ancestry if you selected 'Other' above:

Ancestry 2

___________________________________________

**NOTE ON ADMINISTRATION OF B60:** Country-specific question. Translation of the source question wording should be carried out as normal in all countries. Country-specific answer categories and showcards will be developed in consultation with ESS ERIC HQ (ess@city.ac.uk). A maximum of 20 categories is allowed. Responses to be recoded into the 'European Standard Classification of Cultural and Ethnic Groups' available on the ESS12 NC Intranet.

--- page 69 ---

SECTION C
ASK ALL
Now some questions on different topics.

C1¹⁶¹   CARD 52 To what extent do you agree or disagree with the following statement?

   I'm always optimistic about my future¹⁶².

                              All modes        F2F only
                       Agree strongly  1
                              Agree  2
              Neither agree nor disagree  3
                           Disagree  4
                    Disagree strongly  5
                                       7    (Refusal)
                                       8    (Don't Know)


The following questions are about the ways you might have felt or behaved during the past week.

C2¹⁶³¹⁶⁴        CARD 53 How much of the time during the past week did you feel depressed?

                              All modes        F2F only
         None or almost none of the time  1
                       Some of the time  2
                       Most of the time  3
              All or almost all of the time  4
                                            7    (Refusal)
                                            8    (Don't Know)


C3¹⁶⁵   STILL CARD 53 How much of the time during the past week was your sleep restless?

                              All modes        F2F only
         None or almost none of the time  1
                       Some of the time  2
                       Most of the time  3
              All or almost all of the time  4
                                            7    (Refusal)
                                            8    (Don't Know)

¹⁶¹ AMENDED ITEM D2 in ESS6 source questionnaire. Question text has been updated to include the full question stem.
¹⁶² 'my future' must refer to the respondent's personal future and not the future in general.
¹⁶³ AMENDED ITEM D5 in ESS6 source questionnaire. Question text has been updated to include the full question stem.
¹⁶⁴ Questions C2-C11 have been updated to present the full question stem for each item. Some of these items have been changed from present to past tense.
¹⁶⁵ AMENDED ITEM D7 in ESS6 source questionnaire. Question text has been updated to include the full question stem.

68

--- page 70 ---

**C4166**   *STILL CARD 53* **How much of the time during the past week were you happy?**

                         All modes        F2F only
   None or almost none of the time  1
                  Some of the time  2
                  Most of the time  3
         All or almost all of the time  4
                                     7    (Refusal)
                                     8    (Don't Know)


**C5167**   *STILL CARD 53* **How much of the time during the past week did you feel lonely?**

                         All modes        F2F only
   None or almost none of the time  1
                  Some of the time  2
                  Most of the time  3
         All or almost all of the time  4
                                     7    (Refusal)
                                     8    (Don't Know)


**C6168**   *STILL CARD 53* **How much of the time during the past week did you enjoy life?**

                         All modes        F2F only
   None or almost none of the time  1
                  Some of the time  2
                  Most of the time  3
         All or almost all of the time  4
                                     7    (Refusal)
                                     8    (Don't Know)


**C7169**   *STILL CARD 53* **How much of the time during the past week did you feel sad?**

                         All modes        F2F only
   None or almost none of the time  1
                  Some of the time  2
                  Most of the time  3
         All or almost all of the time  4
                                     7    (Refusal)
                                     8    (Don't Know)

166 **AMENDED ITEM** D8 in ESS6 source questionnaire. Question text has been updated to include the full question stem.
167 **AMENDED ITEM** D9 in ESS6 source questionnaire. Question text has been updated to include the full question stem.
168 **AMENDED ITEM** D10 in ESS6 source questionnaire. Question text has been updated to include the full question stem.
169 **AMENDED ITEM** D11 in ESS6 source questionnaire. Question text has been updated to include the full question stem.

--- page 71 ---

**C8¹⁷⁰**   *STILL CARD 53* **How much of the time during the past week could you not get going?¹⁷¹**

                    All modes        F2F only
 None or almost none of the time  1
                Some of the time  2
                Most of the time  3
       All or almost all of the time  4
                                   7  (Refusal)
                                   8  (Don't Know)


**C9¹⁷²**   *STILL CARD 53* **How much of the time during the past week did you have a lot of energy?**

                    All modes        F2F only
 None or almost none of the time  1
                Some of the time  2
                Most of the time  3
       All or almost all of the time  4
                                   7  (Refusal)
                                   8  (Don't Know)


**C10¹⁷³**  *STILL CARD 53* **How much of the time during the past week did you feel anxious?**

                    All modes        F2F only
 None or almost none of the time  1
                Some of the time  2
                Most of the time  3
       All or almost all of the time  4
                                   7  (Refusal)
                                   8  (Don't Know)


**C11¹⁷⁴**  *STILL CARD 53* **How much of the time during the past week did you feel calm and peaceful?**

                    All modes        F2F only
 None or almost none of the time  1
                Some of the time  2
                Most of the time  3
       All or almost all of the time  4
                                   7  (Refusal)
                                   8  (Don't Know)

¹⁷⁰ **AMENDED ITEM** D12 in ESS6 source questionnaire. Question text has been updated to include the full question stem.
¹⁷¹ 'Could not get going' in the sense of 'felt lethargic and lacked motivation'.
¹⁷² **AMENDED ITEM** D13 in ESS6 source questionnaire. Question text has been updated to include the full question stem.
¹⁷³ **AMENDED ITEM** D14 in ESS6 source questionnaire. Question text has been updated to include the full question stem.
¹⁷⁴ **AMENDED ITEM** D15 in ESS6 source questionnaire. Question text has been updated to include the full question stem.

70

--- page 72 ---

C12-C13
To what extent do you agree or disagree with each of the following statements?¹⁷⁵

**C12¹⁷⁶** *CARD 54* **In my daily life I get very little chance to show how capable I am.**

                        All modes        F2F only
              Agree strongly   1
                       Agree   2
  Neither agree nor disagree   3
                    Disagree   4
           Disagree strongly   5
                               7   (Refusal)
                               8   (Don't Know)


**C13¹⁷⁷** *STILL CARD 54* **I generally feel that what I do in my life is valuable and worthwhile¹⁷⁸.**

                        All modes        F2F only
              Agree strongly   1
                       Agree   2
  Neither agree nor disagree   3
                    Disagree   4
           Disagree strongly   5
                               7   (Refusal)
                               8   (Don't Know)


**C14¹⁷⁹** *CARD 55* **In your opinion, to what extent is there harmony¹⁸⁰  among the people who live in [country]?**

 F2F INTERVIEWER INSTRUCTIONS:
 Please use this card where 0 is not at all and 6 is a great deal.

              All modes                          F2F only
Not at                          A great   (Refusal)   (Don't
all                             deal¹⁸¹               know)

0        1      2      3      4      5      6      7      8

¹⁷⁵ Intro text has been changed from Round 6 face-to-face for Round 12.
¹⁷⁶ **REPEAT ITEM** D17 in ESS6 source questionnaire.
¹⁷⁷ **AMENDED ITEM** D23 in ESS6 source questionnaire. The only change from ESS6 is the translation note on 'worthwhile' (see below). This may impact on how this term is translated.
¹⁷⁸ 'worthwhile': Updated footnote for a Round 6 item being repeated in Round 12 'worthwhile' must be translated in the sense of 'meaningful and worth doing' and not in the sense of 'beneficial to others'.
¹⁷⁹ **NEW ITEM**
¹⁸⁰ 'harmony': in the sense of social harmony; mutual understanding and acceptance among the people who live in [country]. It should not be translated in the sense of consensus or agreement.
¹⁸¹ 'A great deal' means 'a large amount' and 'very much'.

71

--- page 73 ---

C15¹⁸²*STILL CARD 55* **To what extent do you feel that people in your local area¹⁸³ help one another?**

                        All modes                              F2F only

   Not at                                          A great   (Refusal)   (Don't
   all                                             deal                   know)

     0          1        2        3        4    5     6          7           8


**C16¹⁸⁴** *STILL CARD 55* **To what extent do you feel that people treat you with respect?**

                        All modes                              F2F only

   Not at                                          A great   (Refusal)   (Don't
   all                                             deal                   know)

     0          1        2        3        4    5     6          7           8


**C17¹⁸⁵** *CARD 56* **On a typical day, how often do you take notice of¹⁸⁶ and appreciate¹⁸⁷¹⁸⁸ your surroundings¹⁸⁹?**

   *F2F INTERVIEWER INSTRUCTIONS:*
   Please use this card where 0 is never and 10 is always.

                             All modes                                        F2F only

   Never                                                         Always   (Refusal)     (Don't know)

   00      01      02      03      04      05      06      07      08      09      10      77              88


**C18¹⁹⁰** *CARD 57* **To what extent do you feel that you have a sense of direction¹⁹¹ in your life?**

   *F2F INTERVIEWER INSTRUCTIONS:*
   Please use this card where 0 is not at all and 10 is completely.

                             All modes                                        F2F only

   Not at all                                                  Completely¹⁹²   (Refusal)     (Don't know)

   00      01      02      03      04      05      06      07      08      09      10      77              88

¹⁸² **AMENDED ITEM** D21 in ESS6 source questionnaire. Question text has been updated to include the full question stem.
¹⁸³ 'Local area': respondent's local area or neighbourhood
¹⁸⁴ **AMENDED ITEM** D22 in ESS6 source questionnaire. Question text has been updated to include the full question stem.
¹⁸⁵ **REPEAT ITEM** D34 in ESS6 source questionnaire.
¹⁸⁶ 'take notice of' in the sense of 'become aware of'
¹⁸⁷ 'take notice of' and 'appreciate': both verbs MUST be translated, that is, please use two verbs in your language.
¹⁸⁸ 'appreciate' in the sense of 'value'
¹⁸⁹ 'surroundings' whether physical or social
¹⁹⁰ **REPEAT ITEM** D35 in ESS6 source questionnaire.
¹⁹¹ 'sense of direction': a feeling or an idea of how someone would like their life to be in the future
¹⁹² 'completely' in the sense of 'an ending point on the scale where nothing can go beyond it. This might be represented also by 'extremely', 'fully', 'absolutely', 'totally', etc

72

--- page 74 ---

C19¹⁹³ *CARD 58* **To what extent do you receive help and support¹⁹⁴ from people you are close to¹⁹⁵ when you need it?**

*F2F INTERVIEWER INSTRUCTIONS:*
Please use this card where 0 is not at all and 6 is completely.

                    All modes                              F2F only

Not at                              Completely¹⁹⁶   (Refusal)   (Don't
all                                                              know)

   0        1       2       3       4       5       6        7          8


**C20¹⁹⁷** *STILL CARD 58* **And to what extent do you provide help and support**¹⁹⁴ **to people you are close to**¹⁹⁵ **when they need it?**

                    All modes                              F2F only

Not at                              Completely   (Refusal)   (Don't
all                                                          know)

   0        1       2       3       4       5       6        7          8


**C21¹⁹⁸** *STILL CARD 58* **To what extent are you doing the things you really want and value in your life?**

                    All modes                              F2F only

Not at                              Completely   (Refusal)   (Don't
all                                                          know)

   0        1       2       3       4       5       6        7          8


**C22**¹⁹⁸ *STILL CARD 58* **To what extent are you able to¹⁹⁹ achieve your goals?**

                    All modes                              F2F only

Not at                              Completely   (Refusal)   (Don't
all                                                          know)

   0        1       2       3       4       5       6        7          8


¹⁹³ **REPEAT ITEM** D36 in ESS6 source questionnaire.
¹⁹⁴ 'help and support' whether emotional or material.
¹⁹⁵ 'close to' in the sense of 'emotionally close' rather than 'physically close'.
¹⁹⁶ 'completely' in the sense of 'an ending point on the scale where nothing can go beyond it. This might be represented also by 'extremely', 'fully', 'absolutely', 'totally', etc
¹⁹⁷ **REPEAT ITEM** D37 in ESS6 source questionnaire.
¹⁹⁸ **NEW ITEM**
¹⁹⁹ 'able to': to be translated in a broad sense, covering both internal capability and external circumstances.

73

--- page 75 ---

C23²⁰⁰ *STILL CARD 58* **To what extent do you feel safe and secure²⁰¹ in your life nowadays?**

                    All modes                          F2F only

Not at                              Completely   (Refusal)   (Don't
all                                                           know)

   0        1       2       3       4       5       6            7          8


C24²⁰⁰ *CARD 59* **Generally speaking, how close and connected²⁰² do you feel to other people²⁰³?**

                    All modes                          F2F only

Not at                              Extremely    (Refusal)   (Don't
all                                                           know)

   0        1       2       3       4       5       6            7          8


C25²⁰⁰ *STILL CARD 59* **How close and connected**²⁰² **do you feel to the people in your local area?**

                    All modes                          F2F only

Not at                              Extremely    (Refusal)   (Don't
all                                                           know)

   0        1       2       3       4       5       6            7          8


C26²⁰⁰ *CARD 60* **To what extent do you agree or disagree with the following statement?**

      **In difficult periods of my life, I can usually find something good²⁰⁴ that helps me change for
      the better²⁰⁵.**

                              All modes          F2F only
                       Agree strongly   1
                                Agree   2
           Neither agree nor disagree   3
                             Disagree   4
                    Disagree strongly   5
                                         7    (Refusal)
                                         8    (Don't Know)

²⁰⁰ **NEW ITEM**
²⁰¹ 'Safe and secure' can be translated by one single adjective if this is most idiomatic.
²⁰² 'close and connected' in the sense of 'identify with, feel attached, feeling a connection'; 'close' should not be translated in a sense that conveys only physical proximity. 'Close and connected' can be translated using one or two terms, depending on what is more natural in target language.
²⁰³ 'Other people' to be translated in a broad sense, covering other people generally/all other people.
²⁰⁴ 'Find something good' in the sense of 'see something positive' or 'see the positive side'.
²⁰⁵ 'change for the better': meant in the sense of thriving forward, developing/growing as a person, getting better, becoming stronger. Synonyms may be 'come out of it stronger' / 'help me grow'. In the sense of 'what doesn't kill me, makes me stronger'. It should not be translated in the sense of 'coping with / overcoming' a problem, because this would mean back to normal, but exclude the personal growth.

74

--- page 76 ---

C27²⁰⁶ *CARD 61* **When you hear about an acquaintance²⁰⁷ going through a difficult time, how much compassion²⁰⁸ do you usually feel for them?**

                    All modes                              F2F only

None                                          A great   (Refusal)   (Don't
at all                                        deal²⁰⁹               know)

   0        1        2        3        4        5        6        7        8


C28²⁰⁶ *CARD 62* **When you are going through a difficult time, to what extent do you give yourself the care and kindness²¹⁰ you need?**

                    All modes                              F2F only

Not at                                        A great   (Refusal)   (Don't
all                                           deal                  know)

   0        1        2        3        4        5        6        7        8


C29²⁰⁶ *STILL CARD 62* **To what extent do you feel there is harmony²¹¹ in your life, that is, you feel balanced and at peace with yourself?**

                    All modes                              F2F only

Not at                                        A great   (Refusal)   (Don't
all                                           deal                  know)

   0        1        2        3        4        5        6        7        8


C30²⁰⁶   *CARD 63* **In difficult situations, how often do you manage to take a pause²¹² without immediately reacting?**

                    All modes                              F2F only

Never                                         Always   (Refusal)   (Don't
                                                                   know)

   0        1        2        3        4        5        6        7        8


²⁰⁶ **NEW ITEM**
²⁰⁷ 'Acquaintance' in the sense of 'someone you know less well than a friend'.
²⁰⁸ 'compassion': in the sense of empathising with them and caring about their plight. The second part is particularly important. Translations should not have a religious aspect and should not refer to pity.
²⁰⁹ 'A great deal' means 'a large amount' and 'very much'.
²¹⁰ 'kindness' in the sense of self-kindness, e.g. forgiving yourself, being patient with yourself.
²¹¹ 'Harmony' in the sense of inner harmony; self-acceptance and self-understanding. This may be translated using a different term to harmony at C14.
²¹² 'take a pause': in the sense of containing yourself (in a positive sense) and not in the sense of hesitation or showing inactivity. May be translated in the sense of 'step back' or 'stop for a moment'.

75

--- page 77 ---

SECTION D

Now some questions on a different topic.

ASK ALL
D1²¹³   CARD 64 How important do you think it is that people in countries which are better off should help those in poorer countries who are unable to provide for their basic needs?

                              All modes        F2F only
               Very important   1
                    Important   2
          Not very important    3
         Not at all important   4
                                7   (Refusal)
                                8   (Don't know)



D2²¹³   CARD 65 How acceptable do you think it is that people ONLY help those who genuinely deserve²¹⁴ assistance?

                              All modes        F2F only
             Very acceptable   1
                  Acceptable   2
          Not very acceptable  3
       Not at all acceptable   4
                                7   (Refusal)
                                8   (Don't know)

D3²¹³   CARD 66 Would you say that the world would be a better or a worse place if people from other countries were more like the [country nationality] people?

                                        All modes        F2F only
         World would be a much better place   1
               World would be a better place  2
    Would not make it a better or worse place  3
               World would be a worse place   4
         World would be a much worse place    5
                                               7   (Refusal)
                                               8   (Don't know)



²¹³ NEW ITEM
²¹⁴ 'Deserve' in the sense of merit, earn. It should NOT be translated in the sense of 'necessitate / need' and NOT in the sense of 'entitled to'.

76

--- page 78 ---

D4²¹⁵   *CARD 67* **How often should [country] be ruthless²¹⁶ in asserting its national interests against other countries?**

                              All modes        F2F only
                       Always | 1
                        Often | 2
                    Sometimes | 3
                 Hardly ever  | 4
                        Never | 5
                              | 7 | (Refusal)
                              | 8 | (Don't know)


**D5 – D8²¹⁷**
**D5_intro**
> People come to live in **[country]** from other countries for different reasons. Some have ancestral ties. Others come to work here, or to join their families. Others come because they're under threat. Here are some questions about this issue²¹⁸.

How important do you think each of these things should be in deciding whether someone born, brought up and living outside **[country]** should be able to come and live here?

 *F2F INTERVIEWER INSTRUCTIONS:*
 Please answer using the scale, where 0 means 'Extremely unimportant' and
 10 means 'Extremely important'.

**D5²¹⁹**

        *CARD 68* **Firstly, how important should it be for them to have good educational qualifications?**

                              All modes                              F2F only
   Extremely                                          Extremely
   unimportant                                        important | (Refusal)   (Don't know)

   00    01    02    03    04    05    06    07    08    09    10 |    77           88

**D6²²⁰**

        *STILL CARD 68* **How important should it be for them to be able to speak [country's official language(s)]?²²¹**

                              All modes                              F2F only
   Extremely                                          Extremely
   unimportant                                        important | (Refusal)   (Don't know)

   00    01    02    03    04    05    06    07    08    09    10 |    77           88

²¹⁵ **NEW ITEM**
²¹⁶ 'Ruthless' in the sense of merciless, not thinking of others, having no compassion. This should be translated in a rather strong or hard tone. Please choose a translation that is rather too hard than not hard enough
²¹⁷ Questions D5-D8 have been updated from ESS7 to present the full question stem for each item.
²¹⁸ The same translation for this introduction should be used as in ESS1 and in ESS7.
²¹⁹ **AMENDED ITEM:** D1 in ESS7 source questionnaire.
²²⁰ **AMENDED ITEM:** D2 in ESS7 source questionnaire.
²²¹ Where countries have more than one official language, the question should ask whether someone should "be able" to speak at least one of them (e.g. Switzerland 'be able to speak German, French or Italian').

77

--- page 79 ---

D7²²² *STILL CARD 68* **How important should it be for them to come from a Christian²²³ background?**

                        All modes                                          F2F only
Extremely                                              Extremely
unimportant                                            important  (Refusal)    (Don't know)
  00      01    02    03    04    05    06    07    08    09    10       77           88


D8²²⁴ *STILL CARD 68* **How important should it be for them to be white?**

                        All modes                                          F2F only
Extremely                                              Extremely
unimportant                                            important  (Refusal)    (Don't know)
  00      01    02    03    04    05    06    07    08    09    10       77           88


D9²²⁵ *CARD 69* **Would you say that people who come to live here generally take jobs away from workers in [country], or generally help to create new jobs?**

                        All modes                                          F2F only
Take jobs                                              Create new
away                                                        jobs  (Refusal)    (Don't know)
  00      01    02    03    04    05    06    07    08    09    10       77           88


D10²²⁶ *CARD 70* **Most people who come to live here work and pay taxes. They also use health and welfare services. On balance, do you think people who come here take out more than they put in or put in more than they take out?**

                        All Modes                                          F2F only

Generally take                                         Generally put  (Refusal)    (Don't
out more                                                     in more               know)
  00      01    02    03    04    05    06    07    08    09    10       77           88


D11²²⁷ *CARD 71* **Are [country]'s crime problems made worse or better by people coming to live here from other countries?**

                        All Modes                                          F2F only

Crime problems                                         Crime problems  (Refusal)    (Don't
made worse                                               made better               know)
  00      01    02    03    04    05    06    07    08    09    10       77           88

²²² **AMENDED ITEM:** D3 in ESS7 source questionnaire.
²²³ Israel changes 'Christian' in this item.
²²⁴ **AMENDED ITEM:** D4 in ESS7 source questionnaire.
²²⁵ **AMENDED ITEM:** D7 in ESS7 source questionnaire
²²⁶ **AMENDED ITEM:** D8 in ESS7 source questionnaire
²²⁷ **AMENDED ITEM:** D9 in ESS7 source questionnaire
                                                                                          78

--- page 80 ---

D12-D13
Now, thinking of people who have come to live in [country] from another country who are of a different race or ethnic group²²⁸ from most [country nationality] people.

D12²²⁹²³⁰*CARD 72* **How much would you mind or not mind if someone like this was appointed as your boss?**

                              All Modes                                          F2F only

Not mind at                                                           Mind a lot   (Refusal)   (Don't
all                                                                                              know)

  00       01       02       03       04       05       06       07       08       09       10        77          88


D13²³⁰²³¹
   *SC WEB INSTRUCTIONS*
   *Still* thinking of people who have come to live in [country] from another country who are of a
   different race or ethnic group²²⁸ from most [country nationality] people.

        *STILL CARD 72* **How much would you mind or not mind if someone like this married a close relative of yours?**

                              All Modes                                          F2F only

Not mind at                                                           Mind a lot   (Refusal)   (Don't
all                                                                                              know)

  00       01       02       03       04       05       06       07       08       09       10        77          88


D14-D17
Some people come to this country and apply for refugee status on the grounds²³² that they fear persecution in their own country. Please indicate how much you agree or disagree with the following statements.

D14²³³*CARD 73* **[country] has more than its fair share²³⁴ of people applying for refugee status.**

                                        All modes          F2F only
                         Agree strongly   1
                                  Agree   2
             Neither agree nor disagree   3
                               Disagree   4
                      Disagree strongly   5
                                         7   (Refusal)
                                         8   (Don't know)

²²⁸ 'race or ethnic group': in all the items in module D please use the same translation as in the core items A53 and A54
²²⁹ **AMENDED ITEM:** D10 in ESS7 source questionnaire
²³⁰ Questions D12 and D13 have been updated from ESS7 to present the full question stem for each item.
²³¹ **AMENDED ITEM:** D11 in ESS7 source questionnaire
²³² 'On the grounds ' in the sense of both 'because' and 'stating that'
²³³ **REPEATED ITEM:** D49 in ESS1 source questionnaire
²³⁴ 'Fair share' in the sense of 'the appropriate proportion', as opposed to 'more than their fair share'.

79

--- page 81 ---

D15²³⁵  *STILL CARD 73* **While their applications for refugee status are being considered, people
      should be allowed to work²³⁶ in [country].**

                                          All modes        F2F only
                             Agree strongly | 1
                                      Agree | 2
                         Neither agree nor disagree | 3
                                   Disagree | 4
                          Disagree strongly | 5
                                            | 7            (Refusal)
                                            | 8            (Don't know)


Please indicate how much you agree or disagree with the following statements.

D16²³⁷  *STILL CARD 73* **The government should be generous²³⁸ in judging people's applications for
refugee status.**

                                          All modes        F2F only
                             Agree strongly | 1
                                      Agree | 2
                         Neither agree nor disagree | 3
                                   Disagree | 4
                          Disagree strongly | 5
                                            | 7            (Refusal)
                                            | 8            (Don't know)


D17²³⁹  *STILL CARD 73* **While their cases are being considered, applicants should²⁴⁰ be kept in
      detention centres²⁴¹.**

                                          All modes        F2F only
                             Agree strongly | 1
                                      Agree | 2
                         Neither agree nor disagree | 3
                                   Disagree | 4
                          Disagree strongly | 5
                                            | 7            (Refusal)
                                            | 8            (Don't know)

²³⁵ **REPEATED ITEM:** D50 in ESS1 source questionnaire
²³⁶ 'Allowed to' in the sense of 'be given permission to' work.
²³⁷ **AMENDED ITEM:** D15 in ESS7 source questionnaire
²³⁸ 'Generous': 'liberal'.
²³⁹ **REPEATED ITEM:** D53 in ESS1 source questionnaire
²⁴⁰ 'Should ' in the sense of 'must'
²⁴¹ 'Detention centres': in the sense of secure accommodation

--- page 82 ---

D18²⁴² Out of every 100 people living in [country], how many do you think were born outside [country]?

 SC WEB AND PAPER QUESTION          F2F INTERVIEWER INSTRUCTIONS:
 INSTRUCTIONS:
 Please write an answer between 0 and 100 in the   IF RESPONDENT SAYS 'DON'T KNOW';
 box below.                                         SAY: Please give your best estimate.

 If you are unsure, please give your best estimate.   TYPE IN NUMBER

            All modes            F2F only

                                 (Refusal)     777
                                 (Don't know)  888

**Validation text: if a negative number or a number greater than 100 is entered
Please enter a number between 0 and 100.

 SC PAPER INSTRUCTIONS:
 If you were born in [country], please answer question D19.
 If you were not born in [country], please go to D20.

ASK IF 1 AT A80 (IF A80=1)
D19²⁴³ CARD 74 Compared to people like yourself who were born in [country], how do you think the
       government treats those who have recently come to live here from other countries?

                              All modes        F2F only

                             Much better   1
                           A little better  2
                               The same   3
                            A little worse  4
                             Much worse   5
                                           7   (Refusal)
                                           8   (Don't know)


ASK ALL
D20²⁴⁴ CARD 75 Do you think the religious beliefs and practices in [country] are generally
       undermined or enriched²⁴⁵ by people coming to live here from other countries?

                              All Modes                                          F2F only

 Religious beliefs                              Religious beliefs   (Refusal)   (Don't
 and practices                                  and practices                   know)
 undermined                                     enriched

  00    01    02    03    04    05    06    07    08    09    10       77         88

²⁴² REPEATED ITEM: D16 in ESS7 source questionnaire
²⁴³ AMENDED ITEM: D17b in ESS7 source questionnaire
²⁴⁴ AMENDED ITEM: D18 in ESS7 source questionnaire
²⁴⁵ 'undermined or enriched' should be translated in the same way as in core item A58.

                                                                                          81

--- page 83 ---

D21²⁴⁶ **Do you have any close friends who are of a different race or ethnic group from most [country nationality] people?**

   *F2F INTERVIEWER INSTRUCTIONS:*
   IF YES, is that several or a few?

                    All modes  |    F2F only
             Yes, several | 1
               Yes, a few | 2
         No, none at all  | 3
                          | 7 | (Refusal)
                          | 8 | (Don't know)


D22²⁴⁷ *CARD 76* **How often do you have any contact with people who are of a different race or ethnic group from most [country nationality] people when you are out and about²⁴⁸? This could be on public transport, in the street, in shops or in the neighbourhood²⁴⁹.**

   *INSTRUCTIONS FOR ALL MODES:* Any contact should be included, whether verbal or non-verbal.

                    All modes  |      | F2F only | Routing
                    Never²⁵⁰   | 01   |          | **Go to D24**
   Less than once a month      | 02   |          |
            Once a month       | 03   |          |
   Several times a month       | 04   |          | **Go to D23**
            Once a week        | 05   |          |
   Several times a week        | 06   |          |
              Every day        | 07   |          |
                               | 77   | (Refusal)    | **Go to D24**
                               | 88   | (Don't know) |


**ASK IF CODE 02, 03, 04, 05, 06, 07 AT D22**
D23²⁵¹ *CARD 77* **Thinking about this contact, in general how bad or good is it?**

*SC WEB INSTRUCTIONS:*
'This contact' refers to contact with people who are of a different race or ethnic group from most [country nationality] people when you are out and about.

                         All Modes                                        F2F only

Extremely                                              Extremely  (Refusal)  (Don't
bad                                                         good             know)

00      01      02      03      04      05      06      07      08      09      10      77      88

²⁴⁶ **REPEATED ITEM:** D19 in ESS7 source questionnaire
²⁴⁷ **AMENDED ITEM:** D20 in ESS7 source questionnaire.
²⁴⁸ 'Out and about' in the sense of 'when in public and not at home'.
²⁴⁹ 'Neighbourhood' in the sense of 'local area'.
²⁵⁰ The scale should be translated in the same way as in core item A61.
²⁵¹ **AMENDED ITEM:** D21 in ESS7 source questionnaire

82

--- page 84 ---

ASK ALL
D24²⁵² *CARD 78* **Do you think some races or ethnic groups²⁵³ are born less intelligent than others?**

                    All modes      F2F only
          Yes, definitely  1
            Yes, probably  2
         No, probably not  3
       No, definitely not  4
                           7  (Refusal)
                           8  (Don't know)


**D25²⁵⁴** *STILL CARD 78* **Do you think some races or ethnic groups are born harder working than others?**

                    All modes      F2F only
          Yes, definitely  1
            Yes, probably  2
         No, probably not  3
       No, definitely not  4
                           7  (Refusal)
                           8  (Don't know)


**D26²⁵⁵** *STILL CARD 78* **Thinking about the world today, would you say that some cultures are much better than others?**

                    All modes      F2F only
          Yes, definitely  1
            Yes, probably  2
         No, probably not  3
       No, definitely not  4
                           7  (Refusal)
                           8  (Don't know)

²⁵² **NEW ITEM:** New scale added to D23 in ESS7 source questionnaire. If available, the existing translation should be referred to for the main part of the question (without showcard reference) but not the answer categories.
²⁵³ 'Some races or ethnic groups': it is important that the translation refers to groups rather than to individuals. If at all possible, the word 'people' should not be used.
²⁵⁴ **NEW ITEM:** New scale added to D24 in ESS7 source questionnaire. If available, the existing translation should be referred to for the main part of the question (without showcard reference) but not the answer categories.
²⁵⁵ **NEW ITEM**

83

--- page 85 ---

D27²⁵⁶  *STILL CARD 78* **Do you think that we should protect [country nationality] culture from the influence of other cultures?**

                        All modes        F2F only
              Yes, definitely  1
               Yes, probably   2
            No, probably not   3
          No, definitely not   4
                               7   (Refusal)
                               8   (Don't know)


**D28-D30**

You will now be asked about different groups of people who might come to live in [country] from other countries.

**D28²⁵⁷²⁵⁸***CARD 79* **To what extent do you think [country] should²⁵⁹ allow Jewish people from other countries to come and live here²⁶⁰?**

                        All modes        F2F only
   Allow many to come and live here  1
                       Allow some   2
                       Allow a few  3
                       Allow none   4
                                    7   (Refusal)
                                    8   (Don't know)


**D29**²⁵⁸**²⁶¹**        *STILL CARD 79* **To what extent do you think [country] should**²⁵⁹ **allow Muslims²⁶² from other countries to come and live here?**

                        All modes        F2F only
   Allow many to come and live here  1
                       Allow some   2
                       Allow a few  3
                       Allow none   4
                                    7   (Refusal)
                                    8   (Don't know)


²⁵⁶ **NEW ITEM**
²⁵⁷ **AMENDED ITEM:** D26 in ESS7 source questionnaire
²⁵⁸ Questions D28 and D29 have been updated from ESS7 to present the full question stem for each item.
²⁵⁹ 'Should' in the sense of 'ought to'; not in the sense of 'must'.
²⁶⁰ 'Here' = country throughout these questions.
²⁶¹ **AMENDED ITEM:** D27 in ESS7 source questionnaire
²⁶² 'Muslims': people who hold the Muslim faith.

84

--- page 86 ---

PROGRAMMING NOTE: D30a, D30b, D30c, D30d are four separate question versions which are to be randomly allocated to 25% of the total sample each in advance of fieldwork. Each respondent will only be asked one question. Data for each question should be stored in separate variables.

PROGRAMMING NOTE FOR SC PAPER: Four versions of the paper questionnaire will be produced with only one of D30a, D30b, D30c or D30d appearing in each version. D30a, D30b, D30c, D30d all to be displayed as 'D30'.


ASK SAMPLE A
D30a²⁶³STILL CARD 79
         In recent years, people from European countries like Ukraine have left their country
         because of war.

         Imagine a situation where Christians from a European country outside the EU²⁶⁴ have to
         leave their country because war makes their homes unsafe.

         To what extent do you think [country] should allow them to come and live here?

                              All modes        F2F only
         Allow many to come and live here  1
                              Allow some  2
                              Allow a few  3
                              Allow none  4
                                           7   (Refusal)
                                           8   (Don't know)


ASK SAMPLE B
D30b²⁶³ STILL CARD 79
         In recent years, people from European countries like Ukraine have left their country due to
         the lack of work.

         Imagine a situation where Christians from a European country outside the EU²⁶⁴ have to
         leave their country because they are unemployed due to a lack of work.

         To what extent do you think [country] should allow them to come and live here?

                              All modes        F2F only
         Allow many to come and live here  1
                              Allow some  2
                              Allow a few  3
                              Allow none  4
                                           7   (Refusal)
                                           8   (Don't know)


²⁶³ NEW ITEM
²⁶⁴ 'EU': In EEA countries it is acceptable to refer to EU / European Economic Area

                                                                                              85

--- page 87 ---

ASK SAMPLE C
D30c265 *STILL CARD 79*
      In recent years, people from Middle Eastern countries like Syria have left their country
      because of war.

      Imagine a situation where  Muslims266 from a Middle Eastern country have to leave their
      country because war makes their homes unsafe.

      To what extent do you think [country] should allow them to come and live here?

                                    All modes        F2F only
                  Allow many to come and live here  1
                                    Allow some  2
                                    Allow a few  3
                                    Allow none  4
                                                 7   (Refusal)
                                                 8   (Don't know)


ASK SAMPLE D
D30d265 *STILL CARD 79*
      In recent years, people from Middle Eastern countries like Syria have left their country due
      to the lack of work.

      Imagine a situation where Muslims266 from a Middle Eastern country have to leave their
      country because they are unemployed due to a lack of work.

      To what extent do you think [country] should allow them to come and live here?

                                    All modes        F2F only
                  Allow many to come and live here  1
                                    Allow some  2
                                    Allow a few  3
                                    Allow none  4
                                                 7   (Refusal)
                                                 8   (Don't know)

265 **NEW ITEM**
266 'Muslims': please use the same translation as in D29.

86

--- page 88 ---

SECTION E267268

ASK ALL
The following statements describe some people. Please indicate how much each person is or is not like you now.

E1     CARD 80 It is important to this person to develop269 their270 own opinions271.

                    All modes        F2F only
         Very much like me   1
                   Like me   2
          Somewhat like me   3
          A little like me   4
               Not like me   5
        Not like me at all   6
                             7   (Refusal)
                             8   (Don't know)


E2     STILL CARD 80 It is important to this person that the state272 is strong and can defend its citizens.

                    All modes        F2F only
         Very much like me   1
                   Like me   2
          Somewhat like me   3
          A little like me   4
               Not like me   5
        Not like me at all   6
                             7   (Refusal)
                             8   (Don't know)




267 The Human Values Scale has been changed for Round 12. It now includes 20 rather than 21 items. The wording of all items has been changed from Round 11, meaning that new translations are needed. The response options remain unchanged and existing translations for these should be used. This is also now a single gender-neutral version of the questions rather than having separate versions for male and female respondents.
268For items E1-E20 (where relevant), "they/them/their" is not meant in the sense of plural, but in the sense of a gender-neutral pronoun. This exists in English, but does not exist in many other languages. If this option does not exist in your language, please translate by using the most gender-neutral way of expression. This may be using, e.g., "this person", "he/she", or only the pronoun corresponding to the grammatical gender of "person" in the respective languages, or another solution depending on target language.
269 'Develop': in the sense of independently building up (their own opinions).
270 "their" is not meant in the sense of plural, but in the sense of a gender-neutral pronoun. If this option does not exist in your language, please translate using the most gender-neutral way of expression.
271 'opinions': in the sense of "views".
272 'the state':the state of the country in which the respondent lives.

87

--- page 89 ---

**E3**   *STILL CARD 80* **It is important to this person to enjoy life's pleasures²⁷³.**

                    All modes        F2F only
         Very much like me  1
                   Like me  2
          Somewhat like me  3
          A little like me  4
               Not like me  5
        Not like me at all  6
                            7  (Refusal)
                            8  (Don't know)


**E4**   *STILL CARD 80* **It is important to this person never to make other people angry²⁷⁴.**

                    All modes        F2F only
         Very much like me  1
                   Like me  2
          Somewhat like me  3
          A little like me  4
               Not like me  5
        Not like me at all  6
                            7  (Refusal)
                            8  (Don't know)


**E5**   *STILL CARD 80* **It is important to this person to be very successful.**

                    All modes        F2F only
         Very much like me  1
                   Like me  2
          Somewhat like me  3
          A little like me  4
               Not like me  5
        Not like me at all  6
                            7  (Refusal)
                            8  (Don't know)

²⁷³ 'Life's pleasures': This relates to the concept of hedonism. It is meant in a broad sense, covering things such as wanting to have fun and enjoying material things or luxuries.
²⁷⁴ 'angry':any sense of anger, whether strong or weak.

--- page 90 ---

**E6**     *STILL CARD 80* **It is important to this person that everyone be treated justly, even people they²⁷⁵ don't know.**

                   All modes  |    | F2F only
       Very much like me  | 1 |
                   Like me  | 2 |
         Somewhat like me  | 3 |
           A little like me  | 4 |
               Not like me  | 5 |
       Not like me at all  | 6 |
                              | 7 | (Refusal)
                              | 8 | (Don't know)


**E7**     *STILL CARD 80* **It is important to this person to have the power to make others comply with what they²⁷⁶ want.**

                   All modes  |    | F2F only
       Very much like me  | 1 |
                   Like me  | 2 |
         Somewhat like me  | 3 |
           A little like me  | 4 |
               Not like me  | 5 |
       Not like me at all  | 6 |
                              | 7 | (Refusal)
                              | 8 | (Don't know)


**E8**     *STILL CARD 80* **It is important to this person to be humble²⁷⁷.**

                   All modes  |    | F2F only
       Very much like me  | 1 |
                   Like me  | 2 |
         Somewhat like me  | 3 |
           A little like me  | 4 |
               Not like me  | 5 |
       Not like me at all  | 6 |
                              | 7 | (Refusal)
                              | 8 | (Don't know)

²⁷⁵ "they" is not meant in the sense of plural, but in the sense of a gender-neutral pronoun. If this option does not exist in your language, please translate using the most gender-neutral way of expression.
²⁷⁶ "they" is not meant in the sense of plural, but in the sense of a gender-neutral pronoun. If this option does not exist in your language, please translate using the most gender-neutral way of expression.
²⁷⁷ 'be humble': in the sense of being modest. It should not be translated in the sense of being submissive. Humble people do not want to think that they deserve more status, prestige, fame, or praise, than other people do, because they do not view themselves as more important or better than others or as more morally worthy.

89

--- page 91 ---

**E9**   *STILL CARD 80* **It is important to this person to protect the natural environment²⁷⁸ from pollution or destruction.**

                    All modes        F2F only
         Very much like me  1
                   Like me  2
          Somewhat like me  3
          A little like me  4
               Not like me  5
        Not like me at all  6
                            7  (Refusal)
                            8  (Don't know)


**E10**   *STILL CARD 80* **It is important to this person never to be humiliated.**

                    All modes        F2F only
         Very much like me  1
                   Like me  2
          Somewhat like me  3
          A little like me  4
               Not like me  5
        Not like me at all  6
                            7  (Refusal)
                            8  (Don't know)


**E11**   *STILL CARD 80* **It is important to this person to have all sorts of new experiences²⁷⁹.**

                    All modes        F2F only
         Very much like me  1
                   Like me  2
          Somewhat like me  3
          A little like me  4
               Not like me  5
        Not like me at all  6
                            7  (Refusal)
                            8  (Don't know)


²⁷⁸ 'natural environment': this can be translated as either "nature" or "environment" in languages where "natural environment" is not commonly used and where these terms are equivalent.
²⁷⁹ ' all sorts of new experiences': in the sense of many and different types of experiences.

--- page 92 ---

**E12**   *STILL CARD 80* **It is important to this person to help the people close to²⁸⁰ them²⁸¹.**

                        All modes        F2F only
             Very much like me  1
                       Like me  2
              Somewhat like me  3
              A little like me  4
                    Not like me  5
            Not like me at all  6
                                7  (Refusal)
                                8  (Don't know)


**E13**   *STILL CARD 80* **It is important to this person to be wealthy.**

                        All modes        F2F only
             Very much like me  1
                       Like me  2
              Somewhat like me  3
              A little like me  4
                    Not like me  5
            Not like me at all  6
                                7  (Refusal)
                                8  (Don't know)


**E14**   *STILL CARD 80* **It is important to this person to be personally²⁸² safe and secure²⁸³²⁸⁴.**

                        All modes        F2F only
             Very much like me  1
                       Like me  2
              Somewhat like me  3
              A little like me  4
                    Not like me  5
            Not like me at all  6
                                7  (Refusal)
                                8  (Don't know)

²⁸⁰ 'close to' in the sense of 'emotionally close' rather than 'physically close'.
²⁸¹ "them" is not meant in the sense of plural, but in the sense of a gender-neutral pronoun. If this option does not exist in your language, please translate using the most gender-neutral way of expression.
²⁸² 'Personally' is intended to emphasize that this refers to security for self and in one's immediate environment.
²⁸³ 'Safe and secure' can be translated by one single adjective if this is most idiomatic.
²⁸⁴ The intended meaning of this item is about wanting to be safe and secure rather than asking if they feel safe and secure.

91

--- page 93 ---

**E15**   *STILL CARD 80* **It is important to this person to be tolerant towards all kinds of people and groups²⁸⁵.**

                    All modes        F2F only
         Very much like me   1
                   Like me   2
          Somewhat like me   3
          A little like me   4
               Not like me   5
        Not like me at all   6
                             7   (Refusal)
                             8   (Don't know)


**E16**   *STILL CARD 80* **It is important to this person never to violate rules or regulations²⁸⁶.**

                    All modes        F2F only
         Very much like me   1
                   Like me   2
          Somewhat like me   3
          A little like me   4
               Not like me   5
        Not like me at all   6
                             7   (Refusal)
                             8   (Don't know)


**E17**   *STILL CARD 80* **It is important to this person to make their²⁸⁷ own decisions about their life.**

                    All modes        F2F only
         Very much like me   1
                   Like me   2
          Somewhat like me   3
          A little like me   4
               Not like me   5
        Not like me at all   6
                             7   (Refusal)
                             8   (Don't know)

²⁸⁵ 'all kinds of people and groups' : if a direct translation of "all kinds of people and groups" is not appropriate in your language, translate in a way that expresses "many different types of people and groups".
²⁸⁶ 'rules and regulations': both terms should be used in languages where these exist. If the same translation would be used for both words, a single term is acceptable.
²⁸⁷ "their" is not meant in the sense of plural, but in the sense of a gender-neutral pronoun. If this option does not exist in your language, please translate using the most gender-neutral way of expression. This also relates to the second mention of "their" at this item.

92

--- page 94 ---

E18    *STILL CARD 80* **It is important to this person to follow traditions. These might be cultural, family or religious traditions.**

                    All modes        F2F only
       Very much like me   1
                  Like me   2
         Somewhat like me   3
           A little like me   4
               Not like me   5
        Not like me at all   6
                             7   (Refusal)
                             8   (Don't know)


E19    *STILL CARD 80* **It is important to this person that the people they know have full confidence in them288289.**

                    All modes        F2F only
       Very much like me   1
                  Like me   2
         Somewhat like me   3
           A little like me   4
               Not like me   5
        Not like me at all   6
                             7   (Refusal)
                             8   (Don't know)


E20    *STILL CARD 80* **It is important to this person that their290 achievements are recognised291 by other people292.**

                    All modes        F2F only
       Very much like me   1
                  Like me   2
         Somewhat like me   3
           A little like me   4
               Not like me   5
        Not like me at all   6
                             7   (Refusal)
                             8   (Don't know)

                                                          **[END DATE AND TIME FOR ALL COUNTRIES]**

288 "they" and "them" are not meant in the sense of plural, but in the sense of gender-neutral pronouns. If this option does not exist in your language, please translate using the most gender-neutral ways of expression.
289 "to have full confidence in them" is meant in the sense that other people have full trust or belief in this person.
290 "their" is not meant in the sense of plural, but in the sense of a gender-neutral pronoun. If this option does not exist in your language, please translate using the most gender-neutral way of expression.
291 'recognised': in the sense of "appreciated". This is stronger than "noticed" but weaker than "celebrated" or "honoured".
292 This question does not need to be translated using passive voice but could also be translated as "that other people recognize his/her/this person's achievements" (if this works better in your language).

--- page 95 ---

**SECTION F²⁹³**

**ASK ALL SC WEB AND PAPER ONLY**
   SC WEB AND PAPER INSTRUCTIONS:
   Now we'd like to ask some questions about your experience in taking this survey [before we
   collect some details from you in order to send a gift of [€X] to thank you for taking part].

**F1**

   *SC WEB AND PAPER QUESTION WORDING*
   **Overall, how well did you feel you understood the questions?**

                          SC WEB AND PAPER ONLY
         Understood only a few of the questions   1
              Understood some of the questions   2
              Understood most of the questions   3
   Understood all or nearly all of the questions   4

**F2**

   *SC WEB AND PAPER QUESTION WORDING*
   **Did you feel reluctant to answer any questions?**

                    SC WEB AND PAPER ONLY
                    None of the questions   1
                   A few of the questions   2
                  Some of the questions   3
                  Most of the questions   4
         All or nearly all of the questions   5

**F3**

   *SC WEB AND PAPER QUESTION WORDING*
   **Did anyone else assist you in completing this questionnaire?**

   SC WEB AND PAPER ONLY        SC WEB AND PAPER routing
                    Yes   1   **Go to F4**
                     No   2   **Go to F6**

²⁹³ New section for Round 12.

--- page 96 ---

ASK IF ASSISTED WITH THE QUESTIONNAIRE AT F3 (IF F3 = 1)
F4

*SC WEB AND PAPER QUESTION WORDING*
**Who assisted you in completing the questionnaire?**

*SC WEB AND PAPER INSTRUCTIONS*
Please choose all that apply.

SC WEB AND PAPER ONLY

                                         Husband, wife, or partner | 1
                                                  Son or daughter | 2
         Parent, parent-in-law, step-parent, or partner's parent | 3
                                                  Other relative | 4
                                              Other non-relative | 5
                           The person who delivered the questionnaire | 6


F5

*SC WEB AND PAPER QUESTION WORDING*
**What kind of assistance was given to you in completing the questionnaire?**

*SC WEB AND PAPER INSTRUCTIONS*
Please choose all that apply.

SC WEB AND PAPER ONLY

                 Understanding the invitation letter and getting started | 1
                                          Accessing the online survey | 2
                                     Reading the questions aloud to me | 3
         Providing information for questions about relatives or household | 4
                                                              members |
                              Helping me decide answers to other questions | 5
                                  Returning my completed paper questionnaire | 6
                                                  Other: please write in | 7

ASK ALL SC WEB AND PAPER ONLY
F6

*SC WEB AND PAPER QUESTION WORDING*
**Do you have any further comments on this survey or its questions?**

SC WEB and PAPER ONLY
___________________________________________________________

___________________________________________________________

--- page 97 ---

**SECTION G**²⁹⁴

**ASK ALL**
**G1**   Thank you for giving your time to complete this survey today.

   [NAME OF SURVEY] may want to contact you again to invite you to take part in further research on
   similar topics to those covered by the questions that you have answered here. This would involve
   contacting you by email, text message, telephone or post and inviting you to take part in a follow-up
   study. As a token of our appreciation, we would send you [a voucher of at least €X²⁹⁵] with an
   invitation to take part.

   **Would it be okay if we contact you again, to invite you to take part in a follow-up study?**

   *Note to F2F INTERVIEWER:*
   FURTHER DETAILS ON THIS ARE INCLUDED IN THE PARTICIPANT INFORMATION
   LEAFLET GIVEN TO THE RESPONDENT BEFORE TAKING PART IN THIS INTERVIEW.
   PLEASE REFER THEM TO THIS.

                  All modes        Routing          Routing for F2F only

      Yes                     1    Go to G2         **Go to G2**

      No                      2    Go to H1         **Go to G6_outro**


**ASK IF AGREE TO BE RECONTACTED AT G1 (G1= 1)**
**G2**

   SC WEB AND PAPER QUESTION WORDING:              F2F QUESTION WORDING:
   We are very grateful for your willingness to be contacted    I will now ask you for some
   again. **To be able to reach you, we need your name,**       contact information to allow us
   **email address, physical address, and/or a mobile**         to contact you regarding any
   **phone number**. We will only use this information to       further research.
   contact you about the follow-up study and we will not give   *Note to F2F INTERVIEWER:*
   it to anyone outside the study.
                                                                ENTER/CONFIRM NAME OF
   **Please enter your first name and surname below.**          RESPONDENT

                              All modes

      First name:

      Surname:


**G3**²⁹⁶

   SC WEB AND PAPER QUESTION WORDING:              *Note to F2F INTERVIEWER:*
   **Please enter your email address in the boxes**    ENTER EMAIL ADDRESS OF
   **below.**                                          RESPONDENT
   Please check your email address carefully before
   moving to the next question. If you do not have

²⁹⁴ Section R has been redesigned for Round 12 to accommodate all modes.
²⁹⁵ It is recommended that this amount be €5 or equivalent.
²⁹⁶ This question should be programmed such that interviewers can skip it if respondents decline to provide information.

96

--- page 98 ---

an email address, please leave this question blank.	READ EMAIL ADDRESS BACK TO RESPONDENT TO CONFIRM THIS HAS BEEN ENTERED CORRECTLY

SKIP QUESTION IF EMAIL ADDRESS NOT GIVEN BY RESPONDENT

All modes

                                                    1

SC WEB and PAPER INSTRUCTIONS:          Note to F2F INTERVIEWER:
Please re-enter your email address:     RE-ENTER RESPONDENT'S EMAIL ADDRESS

                                                    2

**Validation text: if box 1 does not equal box 2
Your email addresses do not match. Please re-enter them in the boxes provided

--- page 99 ---

ASK G4a IF COUNTRY DECIDES TO INCLUDE G4a INSTEAD OF G4b
G4a  Do you agree that we may retain your physical address that we used to contact you for this survey?
     In order to invite you to take part in a follow up study, we will need to send you a letter in the mail.

                    All modes

     Yes                          1

     No                           2


ASK G4b IF COUNTRY DECIDES TO INCLUDE G4b INSTEAD OF G4a
G4b297

 SC WEB and PAPER QUESTION WORDING:          Note to F2F INTERVIEWER:
 Please enter your address in the boxes      ENTER/CONFIRM POSTAL ADDRESS OF
 below.                                      RESPONDENT
 In order to invite you to take part in a follow up
 study, we will need to send you a letter in the    READ ADDRESS BACK TO RESPONDENT TO
 mail.                                       CONFIRM THIS HAS BEEN ENTERED
                                             CORRECTLY

                    All modes298

          Name of property:

          Number:

          Address 1:

          Address 2:

          City:

          County:

          Post Code:


NOTE ON ADMINISTRATION OF G4a AND G4b
Countries will be asked to confirm whether they will include G4a or G4b during the development stage for ESS Round 12.


ASK IF AGREE TO BE RECONTACTED AT G1 (G1= 1)
G5297

   SC WEB AND PAPER QUESTION WORDING:          Note to F2F INTERVIEWER:
   Please enter your mobile telephone number in   ENTER MOBILE TELEPHONE
   the boxes below.                            NUMBER OF RESPONDENT

   We may invite you to participate in a future study   READ MOBILE PHONE NUMBER
   by sending you a text message. If you have an   BACK TO RESPONDENT TO
   international phone number, please include the

297 This question should be programmed such that interviewers can skip it if respondents decline to provide information.
298 Each text box should be optional for countries to include

98

--- page 100 ---

country code. If you do not have a mobile phone number, please leave this question blank.   CONFIRM THIS HAS BEEN ENTERED CORRECTLY

SKIP QUESTION IF MOBILE NUMBER NOT GIVEN BY RESPONDENT

All modes

                                                    1

SC WEB and PAPER INSTRUCTIONS:          Note to F2F INTERVIEWER:
Please re-enter your mobile telephone   RE-ENTER RESPONDENT'S MOBILE
number:                                 TELEPHONE NUMBER

                                                    2

**Validation text: if box 1 does not equal box 2
Your phone numbers do not match. Please re-enter them in the boxes provided


G5_outro
>Thank you for providing your contact information and agreeing to be contacted again.

NOTE ON ADMINISTRATION OF G6
Countries will be asked to confirm whether they will include G6 during the development stage for ESS Round 12.

SC WEB AND PAPER ONLY
ASK IF COUNTRY DECIDES TO INCLUDE G6

G6   As a thank you for taking part in this survey we will [send you] [a voucher for] [€xx]. May we
     use the contact details you've already provided to ensure it reaches you?

          SC WEB AND PAPER ONLY        Routing for SC    Routing for SC
                                       PAPER             WEB

                             Yes   1
                                       Go to H2          Go to
          No, I don't want to receive this  2             FinalOutro_web
          No, I'd like to provide other details  3   Go to H1    Go to H1


G6_outro
F2F ONLY
ASK ALL

Note to F2F INTERVIEWER:
THANK RESPONDENT AND END INTERVIEW.

PROCEED TO THE INTERVIEWER QUESTIONNAIRE

PROGRAMMING NOTE: F2F QUESTIONNAIRE NOW GOES TO J1

--- page 101 ---

SECTION H²⁹⁹

SC WEB AND PAPER ONLY
ASK IF NOT 1 OR 2 AT G6 (G1=2,9 OR G6= 3, 9 OR G6 NOT ASKED)

PROGRAMMING NOTE: The text of this question and its response options should be adapted to the country-specific protocol for delivering incentives. Each of the following response options should be programmed so countries can choose which response options to deploy. Countries may decide to use more than one of these response options or none of them. In some cases, additional information may not be needed and this screen can just thank the respondent for participating and notify them that an incentive will be delivered to them in due time.

H1     Thank you for taking part in this survey today – we really appreciate you giving your time.

[As a thank you for taking part we will [send you] [a voucher for] [€X]. Please enter your [name/email address/phone number/address] below to ensure it reaches you. This will only be used to send you this gift and will be securely deleted at the end of the project (no later than December 2027).]

First name:

Surname:

Email address:

Mobile phone number:

Name of property:
Number:
Address 1:
Address 2:
City:
County:
Post Code:

SC WEB ONLY - ON THE SAME PAGE AS ABOVE TEXT
Please click Save to complete the survey

Save

²⁹⁹ New section for Round 12.To be fielded in SC WEB and PAPER only

--- page 102 ---

ASK ALL SC PAPER ONLY
H2

   SC PAPER QUESTION WORDING
   Please record the date when you finished completing this questionnaire.

   Day       Month       Year


DATA ENTRY QUESTIONNAIRE ONLY – ID NUMBER FOR DATA ENTRY CODER
H3
   DATA ENTRY QUESTIONNAIRE QUESTION WORDING
   Please enter your data entry coder ID number




SC WEB ONLY - ON THE NEXT PAGE AFTER NEXT BUTTON IS SELECTED AT H1
FinalOutro_web
Thank you, this is the end of the questionnaire. You can now close this page.

If you have any queries please contact us on:
Tel: [Telephone No.]
e-mail: [e-mail address]


SC PAPER ONLY – FINAL OUTRO TEXT
FinalOutro_paper

Before sending back the questionnaire, it would be helpful if you can check you have answered all of the questions that are relevant for you. If you have ever had a paid job, it is particularly important to answer questions B31 to B35 on page [xx], so please check that this has been done.

HOW TO RETURN THE QUESTIONNAIRE
When you have completed the questionnaire, please send it back to [Address] in the freepost envelope provided. Your answers will be treated in the strictest confidence.

THANK YOU FOR TAKING THE TIME TO ANSWER THESE QUESTIONS.

If you have any queries please contact us on:
Tel: [Telephone No.]
e-mail: [e-mail address]

This page has been left blank for printing purposes

END OF QUESTIONNAIRE

--- page 103 ---

**SECTION J
F2F ONLY
THESE QUESTIONS ARE FOR THE F2F INTERVIEWER TO ANSWER**

**QUESTIONS ON THE INTERVIEW AS A WHOLE**

**J1** Please select how the interview was conducted from the list below.

 In person inside respondent's home    1
 In person outside of respondent's home    2
 By video    3

**J2** Did the respondent ask for clarification on any questions?

 Never    1
 Almost never    2
 Now and then    3
 Often    4
 Very often    5

 Don't know    8

**J3** Did you feel that the respondent was reluctant to answer
 any questions?

 Never    1
 Almost never    2
 Now and then    3
 Often    4
 Very often    5

 Don't know    8

**J4** Did you feel that the respondent tried to answer
 the questions to the best of his or her ability?

 Never    1
 Almost never    2
 Now and then    3
 Often    4
 Very often    5

 Don't know    8

--- page 104 ---

**J5** Overall, did you feel that the respondent understood
        the questions?

                                          Never   1
                                   Almost never   2
                                   Now and then   3
                                          Often   4
                                     Very often   5

                                     Don't know   8

**J6**    Was anyone else present, who interfered with the interview?

                                            Yes   1     **ASK J7**
                                             No   2     **GO TO J8**

**ASK IF ANYONE INTERFERED WITH THE INTERVIEW AT J6 (IF J6 = 1)**

**J7**    Who was this?  **CODE ALL THAT APPLY**

                                Husband/wife/partner   1
     Son/daughter (inc. step, adopted, foster, child of partner)   2
             Parent/parent-in-law/step-parent/partner's parent   3
                                         Other relative   4
                                     Other non-relative   5

                                         Don't know   8

**J8**   In which language was the interview conducted?

         **[use pre-specified ISO 639-2 codes for all languages that questionnaire is translated into]**

         [First language that questionnaire translated into]     [appropriate ISO 639-2 code]
         [Second language questionnaire translated into]         [appropriate ISO 639-2 code]
         etc

**J9**    Interviewer ID.___________________________

**NOTE: THIS NUMBER MUST BE EXCLUSIVE TO INDIVIDUAL INTERVIEWERS AND MUST NOT BE SHARED**

**J10**   **If you have any additional comments on the interview, please type them in the space below.**

___________________________________________________________________________________________

___________________________________________________________________________________________

--- page 105 ---

THANK YOU FOR TAKING THE TIME TO ANSWER THESE QUESTIONS.

END OF INTERVIEWER QUESTIONNAIRE
