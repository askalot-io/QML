    Guide to the Labour Force Survey




  Appendix B
Labour Force Survey questionnaire
The LFS application consists of several questionnaire components, each of which is summarized below. For
simplicity, as a result of the complexity of the logic within the application, not all possible questions and flows are
presented. This is especially the case within the Contact Component where the scope of possible questions and
flows is somewhat greater than that summarized below.

Selected dwellings are in the survey for six consecutive months. A birth interview corresponds to the first interview for
a new household, and is usually conducted in person. Some birth interviews are now also conducted by telephone
from centralized CATI work sites. Subsequent interviews are conducted in the following months, and are usually
done by telephone.


Contact component
The following information is collected at the start of each contact attempt.


II_R01A

Hello, I’m calling from Statistics Canada. My name is ….
If interview in person, go to IC_R01
If birth interview by telephone, go to AR_Q01
If subsequent interview by telephone, go to SR_Q01


SR_Q01

May I speak with … ?
If “Speaking”, go to IC_R01
If “Available”, go to II_R01B
If “Not available” or “No longer a household member”, go to AR_Q01
If “Wrong number”, go to TC_Q01


II_R01B

Hello, I’m calling from Statistics Canada. My name is ….
Go to IC_R01


TC_Q01

I would like to make sure I’ve dialled the right number. Is this … ?
If yes, go to AR_Q01
If no, thank person and end call




  48        Statistics Canada – Catalogue no. 71-543
                                                                                   Guide to the Labour Force Survey




AR_Q01

May I speak with an adult member of the household?
If “Speaking” and CATI birth interview, go to TFCC_Q01
If “Speaking” and not CATI birth interview, go to IC_R01
If “Available”, go to II_R01C
If “Not available” and birth interview, go to ARA_Q01
If “Not available” and subsequent interview and SR_Q01=“Not available”, go to SRA_Q01
If “Not available” and subsequent interview and SR_Q01=“No longer a household member” or “Wrong number”, go
to ARA_Q01


II_R01C

Hello, I’m calling from Statistics Canada. My name is … .
If CATI birth interview, go to TFCC_Q01
If not CATI birth interview, go to IC_R01


SRA_Q01

I would like to contact … . When would he/she be available?
If “Available”, make appointment and then thank person and end call
If “Not available”, go to ARA_Q01


ARA_Q01

When would an adult member of the household be available?
If “Available”, make appointment and then thank person and end call
If “Not available”, thank person and end call


TFCC_Q01

In order to make sure I’ve reached the correct household, I need to confirm your address. Is it … ?
If yes, go to IC_R01
If no, go to TFCC_Q02


TFCC_Q02

I would like to make sure I’ve dialled the right number. Is this … ?
Thank person and end call


IC_R01

I’m calling regarding the Labour Force Survey.


LP_Q01

Would you prefer to be interviewed in English or in French?
If CATI interview, go to MON_R01
If not CATI interview, go to Household Component



                                                                  Statistics Canada – Catalogue no. 71-543      49
  Guide to the Labour Force Survey




MON_R01

My supervisor may listen to this call for the purpose of quality control.


Household component
LA_N01

If CATI birth interview, go to MA_Q01
If subsequent interview in person, go to CMA_Q01
If subsequent interview by telephone, go to SD_Q01
Confirm the listing address.
Go to MA_Q01


SD_Q01

I would like to confirm your address. Are you still living at … ?
If yes and listing address is the same as mailing address, go to CHM_Q01
If yes and listing address is different from mailing address, go to CMA_Q01
If no, go to SD_Q02
If “Respondent never lived there”, go to SD_Q05


SD_Q02

Does anyone who was living with you at that address still live there?
If yes, go to SD_Q03
If no, thank person and end call


SD_Q03

Can you provide me with the current telephone number for that address?
If yes, go to SD_Q04
If no, thank person and end call


SD_Q04

What is that telephone number, including the area code?
Thank person and end call


SD_Q05

I would like to make sure I’ve dialled the right number. Is this … ?
Thank person and end call


CHM_Q01

Is this also your mailing address?
If yes, go to TN_Q01
If no, go to MA_Q01



  50        Statistics Canada – Catalogue no. 71-543
                                                                                       Guide to the Labour Force Survey




CMA_Q01

I would like to confirm your mailing address. Is it … ?
If yes, go to TN_Q01
If no, go to MA_Q01


MA_Q01

What is your correct mailing address?
If birth interview in person, go to DW_N02
If birth interview by telephone, go to DW_Q01
If subsequent interview, go to TN_Q01


DW_Q01

What type of dwelling do you live in? Is it a:
Read categories to respondent.
Go to TN_Q01


DW_N02

Select the dwelling type.


TN_Q01

Is this dwelling owned by a member of this household?


RS_R01

The next few questions ask for important basic information about the people in your household.
If birth interview, go to USU_Q01
If subsequent interview, go to PV2_Q01


USU_Q01

What are the names of all persons who usually live here?
Begin with adults who have responsibility for the care or support of the family.


RS_Q02

Is anyone staying here temporarily?
If yes, go to TEM_Q01
If no, go to RS_Q04


TEM_Q01

What are the names of all persons who are staying here temporarily?
Add a person only if he/she has no other usual residence elsewhere.



                                                                      Statistics Canada – Catalogue no. 71-543      51
  Guide to the Labour Force Survey




RS_Q04

Are there any other persons who usually live here but are now away at school, in hospital, or somewhere
else?
If yes, go to OTH1_Q01
If no, go to Individual Demographics


OTH1_Q01

What are the names of the other people who live or stay here?
Add a person only if he/she has no other usual residence elsewhere.
Go to Individual Demographics


PV2_Q01

Do the following people still live or stay in this dwelling?
If yes, go to RS_Q05
If no, go to RES_Q02


RES_Q02

Is … no longer a member of the household or deceased?


RS_Q05

Does anyone else now live or stay here?
If yes, go to OTH2_Q01
If no, go to Individual Demographics


OTH2_Q01

What are the names of the other people who live or stay here?
Add a person only if he/she has no other usual residence elsewhere.


Individual demographics
The following demographic information is collected for each household member.


ANC_Q01

What is …’s date of birth?


ANC_Q02

So …’s age on [date of last day of reference week] was [calculated age]. Is that correct?
If yes, go to SEX_Q01
If no, go to ANC_Q03



  52        Statistics Canada – Catalogue no. 71-543
                                                                                      Guide to the Labour Force Survey




ANC_Q03

What is …’s age?


SEX_Q01

Enter …’s sex.


MSNC_Q01

If age<16, go to FI_N01
What is …’s marital status?Is he/she:
Read categories to respondent.


FI_N01

Enter …’s family identifier: A to Z.
Assign the same letter to all persons related by blood, marriage or adoption.


RR_N01

Determine a reference person for the family and select …’s relationship to that reference person.
The reference person should be an adult involved in the care or support of the family.


IMM_Q01

In what country was … born?
Specify country of birth according to current boundaries.
If 01-Canada, go to ABO_Q01


IMM_Q02

Is ... now, or has he/she ever been, a landed immigrant in Canada?
A landed immigrant (permanent resident) is a person who has been granted the right to live in Canada permanently
by immigration authorities.
If yes, go to IMM_Q03
If no, go to ABO_Q01


IMM_Q03

In what year did … first become a landed immigrant?
Year:


IMM_Q04

If IMM_Q03 is more than five years ago go to ABO_Q01
In what month?
Month:



                                                                     Statistics Canada – Catalogue no. 71-543      53
  Guide to the Labour Force Survey




ABO_Q01

If Country of Birth is not Canada, USA or Greenland go to ED_Q01
Is ... an Aboriginal person, that is, North American Indian, Métis or Inuit?
If yes, go to ABO_Q02
If no, go to ED_Q01


ABO_Q02

If respondent has already specified the Aboriginal group(s), select the group(s) from list below; if not, ask: Is ... a
North American Indian, Métis or Inuit?
Mark all that apply.


ED_Q01

If age<14, go to CAF_Q01
What is the highest grade of elementary or high school … ever completed?
If “Grade 8 or lower” or “Grade 9 – 10”, go to ED_Q03
If “Grade 11 – 13”, go to ED_Q02


ED_Q02

Did … graduate from high school (secondary school)?


ED_Q03

Has … received any other education that could be counted towards a degree, certificate or diploma from an
educational institution?
If yes, go to ED_Q04
If no, go to CAF_Q01


ED_Q04

What is the highest degree, certificate or diploma … has obtained?


CHE_Q01

If (Country of Birth is Canada) or (IMM_Q02 is No) or (respondent has not received a post-secondary degree,
certificate or diploma) go to CAF_Q01
In what country did … complete his/her highest degree, certificate or diploma?
Specify country of highest education according to current boundaries.


CAF_Q01

If age<16 or age>65, go to ANC_Q01 for next household member
Is … a full-time member of the regular Canadian Armed Forces?

For each person aged 15 or over who is not a full-time member of the regular armed forces complete the
Labour force information component.



  54        Statistics Canada – Catalogue no. 71-543
                                                                                    Guide to the Labour Force Survey




Rent component
The Rent Component is generated only for cases where the answer to TN_Q01 (“Is this dwelling owned by a member
of this household?”) in the Household Component is “No”, and province/territory is not Yukon Territory, Northwest
Territories or Nunavut.

RRF_R01

The next few questions are about your rent. The information collected is used to calculate the rent portion
of the Consumer Price Index.

RM_Q01

If rent information exists from the previous month, go to RM_Q04
If dwelling type is not “Low-rise apartment” and not “High-rise apartment”, go to RM_Q02
On which floor do you live?

RM_Q02

To the best of your knowledge, how old is your building?

RM_Q03

How many bedrooms are there in your dwelling?

RM_Q04

This month, is the rent for your dwelling subsidized by government or an employer, or a relative?
If yes, go to RM_Q04A
If no, go to RM_Q05

RM_Q04A

In what manner is the rent for your dwelling subsidized?

RM_Q05

This month, is the rent for your dwelling applied to both living and business accommodation?
If yes, go to RM_Q05A
If no, go to RM_Q06

RM_Q05A

Does the business affect the amount of rent paid?

RM_Q06

How much is the total monthly rent for your dwelling?
If $0, go to RM_Q07
If >$0, go to RM_Q08



                                                                   Statistics Canada – Catalogue no. 71-543      55
  Guide to the Labour Force Survey




RM_Q07

What is the reason that the rent is $0?
If RM_Q04=yes, go to end of Rent Component


RM_Q08

If rent information does not exist from the previous month, go to RM_Q09B
If there has been a complete change in household membership, go to RM_Q09B
If RM_Q04=yes, go to RM_Q09B
Since last month, have there been any changes in the amount of rent paid?
If yes, go to RM_Q08A
If no, go to RM_Q09B


RM_Q08A

What is the reason for the change in rent since last month?
Mark all that apply.


RM_Q09B

If dwelling type is not “Low-rise apartment” and not “High-rise apartment”, go to RM_Q14
If rent information exists from the previous month and there has not been a complete change in household
membership, go to RM_Q09S
Does this month’s rent include parking facilities?
If yes, go to RM_Q10
If no, go to RM_Q14


RM_Q09S

Since last month, have there been any changes in the parking facilities?
If yes, go to RM_Q10
If no, go to RM_Q14


RM_Q10

What types of parking facilities are included in your rent?
Mark all that apply.


RM_Q11

If “Closed garage or indoor parking” is not marked in RM_Q10, go to RM_Q12
How many closed garage or indoor parking spaces are included in your rent?


RM_Q12

If “Outside parking with plug-in” is not marked in RM_Q10, go to RM_Q13
How many outside parking spaces with plug-in are included in your rent?



  56        Statistics Canada – Catalogue no. 71-543
                                                                                    Guide to the Labour Force Survey




RM_Q13

If “Outside parking without plug-in” is not marked in RM_Q10, go to RM_Q14
How many outside parking spaces without plug-in are included in your rent?


RM_Q14

If rent information does not exist from the previous month, go to RM_Q15
If there has been a complete change in household membership, go to RM_Q15
If “Change in utilities, services, appliances, or furnishings” is marked in RM_Q08A, go to RM_Q15
Since last month, have there been any changes in the utilities, services, appliances, or furnishings included
in the rent?
If yes, go to RM_Q15
If no, go to end of Rent Component


RM_Q15

Which of the following utilities, services, appliances, or furnishings are included as part of the monthly rent?
Read list to respondent. Mark all that apply.


Labour force information
In this component, a path is assigned according to the answers provided. This path is used to control
the flow through the component. For paths 1, 2, 6, and 7 the path determines the labour force status, but
for paths 3, 4 and 5 other conditions (for example, availability for work) must be considered to distinguish
between those who are unemployed and those who are not in the labour force.


PATHS

1             Employed, at work
2             Employed, absent from work
3             Temporary layoff
4             Job seeker
5             Future start
6             Not in labour force, able to work
7             Not in labour force, permanently unable to work




                                                                   Statistics Canada – Catalogue no. 71-543      57
  Guide to the Labour Force Survey




Job attachment

100

Many of the following questions concern ...’s activities last week. By last week, I mean the week beginning
on Sunday, [date of first day of reference week], and ending last Saturday [date of last day of reference
week].
Last week, did ... work at a job or business?
(regardless of the number of hours)
If yes, then PATH = 1 and go to 102
If no, go to 101
If “Permanently unable to work”, then PATH = 7 and go to 104


101

Last week, did ... have a job or business from which he/she was absent?
If no, go to 104


102

Did he/she have more than one job or business last week?
If no, go to 110


103

Was this a result of changing employers?
Go to 110


Past job attachment

104

Has he/she ever worked at a job or business?
If no, go to 170


105

When did he/she last work?
If subsequent interview and no change in 105 and last month’s PATH = 3, go to 131
Else if subsequent interview and no change in 105 and last month’s PATH = 4 to 7, go to 170
Else if not within past year, go to 170
Else if PATH = 7, go to 131
Else if PATH not 7, go to 110




  58        Statistics Canada – Catalogue no. 71-543
                                                                                Guide to the Labour Force Survey




Job description

110

If 103 = yes, I am now going to ask some questions about …’s new job or business. Was he/she an employee
or self-employed?
If 103 = no, I am now going to ask some questions about the job or business at which he/she usually works
the most hours. Was he/she an employee or self-employed?
Otherwise, Was he/she an employee or self-employed?
If not “Self-employed”, go to 114


111

Did he/she have an incorporated business?


112

Did he/she have any employees?


113

What was the name of his/her business?
Go to 115


114

For whom did he/she work?


115

What kind of business, industry or service was this?


116

What kind of work was he/she doing?


117

What were his/her most important activities or duties?


118

When did he/she start working for [name of employer]?




                                                               Statistics Canada – Catalogue no. 71-543      59
  Guide to the Labour Force Survey




Absence – Separation

130

If PATH = 1, go to 150
If 101 = no, go to 131
What was the main reason ... was absent from work last week?
If “Temporary layoff due to business conditions”, go to 134
If “Seasonal layoff”, go to 136
If “Casual job, no work available”, go to 137
Otherwise PATH = 2 and go to 150


131

What was the main reason ... stopped working at that [job/business]?
If not “Lost job, laid off or job ended”, go to 137


132

Can you be more specific about the main reason for his/her job loss?
If PATH = 7, go to 137
Else if “Business conditions”, go to 133
Otherwise go to 137


133

Does he/she expect to return to that job?
If no or “Not sure”, go to 137


134

Has ...’s employer given him/her a date to return?
If yes, go to 136


135

Has he/she been given any indication that he/she will be recalled within the next 6 months?


136

As of last week, how many weeks had ... been on layoff?
If 130 = “Seasonal layoff”, go to 137
Else if 134 = no and 135 = no, go to 137
Else if on layoff more than 52 weeks, go to 137
Otherwise PATH = 3 and go to 137




  60        Statistics Canada – Catalogue no. 71-543
                                                                                Guide to the Labour Force Survey




137

Did he/she usually work more or less than 30 hours per week?
If PATH = 3, go to 190
Otherwise go to 170


Work hours (Main job)

150

The following questions refer to ...’s work hours at his/her [new] [job/business] [at name of employer].
If 110 = “Employee”, Excluding overtime, does the number of paid hours ... works vary from week to week?
Otherwise, Does the number of hours ... works vary from week to week?
If yes, go to 152


151

If 110 = “Employee”, Excluding overtime, how many paid hours does ...work per week?
Otherwise How many hours does ... work per week?
If PATH = 2, go to 158
If 110 = “Employee”, go to 153
Otherwise, go to 157


152

If 110 = “Employee”, Excluding overtime, on average, how many paid hours does ... usually work per week?
Otherwise On average, how many hours does ... usually work per week?
If PATH = 2, go to 158
If 110 = “Employee”, go to 153
Otherwise, go to 157


153

Last week, how many hours was he/she away from this job because of vacation, illness, or any other reason?
If 0 hours, go to 155


154

What was the main reason for that absence?


155

Last week, how many hours of paid overtime did he/she work at this job?


156

Last week, how many extra hours without pay did he/she work at this job?
If 150 = no, then actual hours = 151 - 153 + 155 + 156 and go to 158



                                                               Statistics Canada – Catalogue no. 71-543      61
  Guide to the Labour Force Survey




157

Last week, how many hours did he/she actually work at his/her [new] [job/business] [at name of employer]?


158

If 151 >= 29.5 or 152 >= 29.5, and PATH = 2, go to 162
If 151 >= 29.5 or 152 >= 29.5, and PATH = 1, go to 200
Does he/she want to work 30 or more hours per week [at a single job]?
If yes, go to 160


159

What is the main reason ... does not want to work 30 or more hours per week [at a single job]?
If PATH = 2, go to 162
Otherwise go to 200


160

What is the main reason ... usually works less than 30 hours per week [at his/her main job]?
If not (“Business conditions” or “Could not find work with 30 or more hours per week”) and PATH = 2, go to 162
If not (“Business conditions” or “Could not find work with 30 or more hours per week”) and PATH = 1, go to 200


161

At any time in the 4 weeks ending last Saturday, [date of last day of reference week], did he/she look for
full-time work?
If PATH = 2, go to 162
Otherwise go to 200


Absence

162

As of last week, how many weeks had ... been continuously absent from work?
If (110 is “Employee”) or (110 is “Self-employed” and 111 is yes), go to 163
Otherwise go to 200


163

Is he/she getting any wages or salary from his/her [employer/business] for any time off last week?
Go to 200




  62        Statistics Canada – Catalogue no. 71-543
                                                                                     Guide to the Labour Force Survey




Job search - Future start

170

If PATH = 7, go to 500
In the 4 weeks ending last Saturday, [date of last day of reference week], did ... do anything to find work?
If no and age >= 65, then PATH = 6 and go to 500
If no and age <= 64, go to 174
If yes, then PATH = 4 and go to 171


171

What did he/she do to find work in those 4 weeks?
Did he/she do anything else to find work?


172

As of last week, how many weeks had he/she been looking for work? (since the date last worked)


173

What was his/her main activity before he/she started looking for work?
Go to 177


174

Last week, did ... have a job to start at a definite date in the future?
If no, then PATH = 6 and go to 176


175

Will he/she start that job before or after Sunday, [date of the first day after four weeks from the last day of
reference week]?
If “Before the date above”, then PATH = 5 and go to 190
If “On or after the date above”, then PATH = 6 and go to 500


176

Did he/she want a job last week?
If no, go to 500


177

Did he/she want a job with more or less than 30 hours per week?




                                                                    Statistics Canada – Catalogue no. 71-543      63
  Guide to the Labour Force Survey




178

If PATH = 4, go to 190
What was the main reason he/she did not look for work last week?
If “Believes no work available”, go to 190
Otherwise go to 500


Availability

190

Could he/she have worked last week [if he/she had been recalled/if a suitable job had been offered]?
If yes, go to 400


191

What was the main reason ... was not available to work last week?
Go to 400


Earnings – Union – Permanence

200

If 110 is not “Employee”, go to 300
If subsequent interview and no change in 110, 114, 115, 116, 117, 118, go to 300
Now I’d like to ask a few short questions about ...’s earnings from his/her [new] job [at name of employer].
Is he/she paid by the hour?


201

Does he/she usually receive tips or commissions?
If 200 = no, go to 204


202

[Including tips and commissions,] what is his/her hourly rate of pay?
Go to 220


204

What is the easiest way for you to tell us his/her wage or salary, [including tips and commissions,] before
taxes and other deductions?
Would it be yearly, monthly, weekly, or on some other basis?
If “Yearly”, go to 209
If “Monthly”, go to 208
If “Semi-monthly”, go to 207
If “Bi-weekly”, go to 206
If “Weekly” or “Other”, go to 205



  64        Statistics Canada – Catalogue no. 71-543
                                                                                  Guide to the Labour Force Survey




205

[Including tips and commissions,] what is his/her weekly wage or salary, before taxes and other deductions?
Go to 220


206

[Including tips and commissions,] what is his/her bi-weekly wage or salary, before taxes and other
deductions?
Go to 220


207

[Including tips and commissions,] what is his/her semi-monthly wage or salary, before taxes and other
deductions?
Go to 220


208

[Including tips and commissions,] what is his/her monthly wage or salary, before taxes and other
deductions?
Go to 220


209

[Including tips and commissions,] what is his/her yearly wage or salary, before taxes and other deductions?
Go to 220


220

Is he/she a union member at [name of employer]?
If yes, go to 240


221

Is he/she covered by a union contract or collective agreement?


240

Is ...’s [new] job [at name of employer] permanent, or is there some way that it is not permanent? (for
example, seasonal, temporary, term or casual)
If “Permanent”, go to 260


241

In what way is his/her job not permanent?
Go to 260



                                                                 Statistics Canada – Catalogue no. 71-543      65
  Guide to the Labour Force Survey




Firm size

260

About how many persons are employed at the location where ... works for [name of employer]?
Would it be… [Less than 20, 20 to 99, 100 to 500, or over 500]?


261

Does [name of employer] operate at more than one location?
If no, or 260 = “Over 500”, go to 300


262

In total, about how many persons are employed at all locations?
Would it be… [Less than 20, 20 to 99, 100 to 500, or over 500]?
Go to 300


Class of worker – Hours at other job

300

If 102 = no, go to 400
Now I have a couple of questions about ...’s [other/old] job or business. Was he/she an employee or
self-employed?
If not “Self-employed”, go to 320


301

Did he/she have an incorporated business?


302

Did he/she have any employees?


320

If 300 = “Employee”, Excluding overtime, how many paid hours [does/did] ... usually work per week at this
job?
Otherwise, How many hours [does/did] ... usually work per week at this [business/family business]?
If PATH = 2, go to 400


321

Last week, how many hours did ... actually work at this [job/business/family business]?
Go to 400




  66        Statistics Canada – Catalogue no. 71-543
                                                                                       Guide to the Labour Force Survey




Temporary layoff job search

400

If PATH not 3, go to 500
In the 4 weeks ending last Saturday, [date of last day of reference week], did ... look for a job with a different
employer?
Go to 500

School attendance

500

If age >= 65, go to END
Last week, was ... attending a school, college or university?
If no, go to 520

501

Was he/she enrolled as a full-time or part-time student?

502

What kind of school was this?
Go to 520

Returning students

520

If survey month not May through August, go to END
Else if age not 15 to 24, go to END
Else if subsequent interview and 520 in previous month was “no”, go to END
Else if subsequent interview and 520 in previous month was “yes”, go to 521
Was ... a full-time student in March of this year?
If no, go to END

521

Does ... expect to be a full-time student this fall?


Exit component
The following information is collected at the end of the LFS interview each month to gather information for
future contacts and to thank respondents for their participation. In many cases, this information will be
pre-filled for confirmation in subsequent interviews.

EI_R01

If rotate-out (for example, last month for interview), go to TY_R02
Before we finish, I would like to ask you a few other questions.



                                                                      Statistics Canada – Catalogue no. 71-543      67
  Guide to the Labour Force Survey




FC_R01

As part of the Labour Force Survey, we will contact your household next month during the week of [date of
first day of next month survey week].
After this month, this dwelling has [calculated number of remaining interviews] LFS interview(s) left.


HC_Q01

Who would be the best person to contact?


TEL_Q01

If no telephone number exists, go to TEL_Q02
I would like to confirm your telephone number. Is it … ?
If yes, go to PC_Q01
If no, go to TEL_Q02


TEL_Q02

What is your telephone number, including the area code?


PC_Q01

If CATI interview, go to PTC_Q01
May we conduct the next interview by telephone?
If yes, go to PTC_Q01
If no, go to PV_R01


PV_R01

In this case we will make a personal visit next month during the week of [date of first day of next month survey
week].


PTC_Q01

If preferred time to call information does not exist from the previous month, go to PTC_Q02
I would like to confirm the time of day you would prefer that we call. Is it [preferred time to call] ?
If yes, go to PTC_N03
If no, go to PTC_Q02


PTC_Q02

What time of day would you prefer that we call? Would it be the morning, the afternoon, the evening, or ANY
TIME?
Mark all that apply.


PTC_N03

Enter any other information about the preferred time to call.



  68        Statistics Canada – Catalogue no. 71-543
                                                                                     Guide to the Labour Force Survey




LQ_Q01

If CATI interview, go to TY_R01
If subsequent interview, go to TY_R01
If dwelling type is not“Single detached” and not“Double” and not“Row or terrace” and not“Duplex”, go to TY_R01
Is there another set of living quarters within this structure?
If yes, go to LQ_N02
If no, go to TY_R01


LQ_N02

Remember to verify the cluster list and add one or more multiples if necessary.


TY_R01

Thank you for your participation in the Labour Force Survey.
Go to END


TY_R02

Thank you for your participation in the Labour Force Survey. Although your six months in the Labour Force
Survey are over, your household may be contacted by Statistics Canada some time in the future for another
survey.


End
Codes for Contact component

SR_Q01

1             Yes, speaking to respondent
2             Yes, respondent available
3             No, respondent not available
4             No, respondent no longer a household member
5             Wrong number


AR_Q01

1             Yes, speaking to an adult member
2             Yes, an adult member is available
3             No, an adult member is not available


SRA_Q01 / ARA_Q01

1             Make hard appointment
2             Make soft appointment
3             Not available




                                                                    Statistics Canada – Catalogue no. 71-543      69
     Guide to the Labour Force Survey




LP_Q01

1                 English
2                 French
3                 Other


Codes for Household component

SD_Q01

1                 Yes
2                 No
3                 No, respondent never lived there


DW_Q01 / DW_N02

01                Single detached
02                Double
03                Row or terrace
04                Duplex
05                Low rise apartment (fewer than 5 stories) or flat
06                High rise apartment (5 stories or more)
07                Institution
08                Hotel; rooming/lodging house; camp
09                Mobile home
10                Other – Specify


RES_Q02

1                 No longer a member
2                 Deceased


Codes for Individual demographics

SEX_Q01

1                 Male
2                 Female


MSNC_Q01

1                 Married
2                 Living common-law
3                 Widowed
4                 Separated
5                 Divorced
6                 Single, never married




     70        Statistics Canada – Catalogue no. 71-543
                                                                               Guide to the Labour Force Survey




RR_N01

1              Reference person
2              Spouse
3              Son or daughter (birth, adopted or step)
4              Grandchild
5              Son-in-law or daughter-in-law
6              Foster child (less than 18 years of age)
7              Parent
8              Parent-in-law
9              Brother or sister
10             Other relative - Specify


IMM_Q01

Responses that do not correspond to one of the twelve countries explicitly listed are recorded as "Other
–Search" and invoke a country search file containing a list of all current countries.

01             Canada
02             United States
03             United Kingdom
04             Germany
05             Italy
06             Poland
07             Portugal
08             China (People’s Republic of)
09             Hong Kong
10             India
11             Philippines
12             Vietnam
13             Other – Search


IMM_Q02

1              Yes
2              No


ABO_Q01

1              Yes
2              No


ABO_Q02

Mark all that apply.

1              North American Indian
2              Métis
3              Inuit (Eskimo)




                                                              Statistics Canada – Catalogue no. 71-543      71
     Guide to the Labour Force Survey




ED_Q01

1                 Grade 8 or lower (Quebec: Secondary II or lower)
2                 Grade 9 - 10 (Quebec: Secondary III or IV, Newfoundland and Labrador: 1st year of secondary)
3                 Grade 11 - 13 (Quebec: Secondary V, Newfoundland and Labrador: 2nd to 4th year of secondary)


ED_Q04

1                 No postsecondary degree, certificate or diploma
2                 Trade certificate or diploma from a vocational school or apprenticeship training
3                 Non-university certificate or diploma from a community college, CEGEP, school of nursing, etc.
4                 University certificate below bachelor’s level
5                 Bachelor’s degree
6                 University degree or certificate above bachelor’s degree


CHE_Q01

Responses that do not correspond to one of the twelve countries explicitly listed are recorded as "Other
–Search" and invoke a country search file containing a list of all current countries.

01                Canada
02                United States
03                United Kingdom
04                Germany
05                Italy
06                Poland
07                Portugal
08                China (People’s Republic of)
09                Hong Kong
10                India
11                Philippines
12                Vietnam
13                Other – Search


Codes for Rent component

RM_Q02

1                 No more than 5 years old
2                 More than 5 but no more than 10 years old
3                 More than 10 but no more than 20 years old
4                 More than 20 but no more than 40 years old
5                 More than 40 years old


RM_Q04A

1                 Income-related/Government agencies
2                 Employer
3                 Owned by a relative
4                 Other - Specify



     72        Statistics Canada – Catalogue no. 71-543
                                                                                      Guide to the Labour Force Survey




RM_Q08A

1            Change in utilities, services, appliances, or furnishings
2            Change in parking facilities
3            New Lease
4            Other - Specify


RM_Q10

1            Closed garage or indoor parking
2            Outside parking with plug-in
3            Outside parking without plug-in


RM_Q15

1            Heat - Electric
2            Heat - Natural Gas
3            Heat - Other Specify
4            Electricity
5            Cablevision
6            Refrigerator
7            Range
8            Washer
9            Dryer
10           Other major appliance - Specify
11           Furniture
12           None of the above


Codes for Labour force information

100

1            Yes
2            No
3            Permanently unable to work


110 / 300

1            Employee
2            Self-employed
3            Working in a family business without pay




                                                                     Statistics Canada – Catalogue no. 71-543      73
     Guide to the Labour Force Survey




130

01                Own illness or disability
02                Caring for own children
03                Caring for elder relative (60 years of age or older)
04                Maternity or parental leave
05                Other personal or family responsibilities
06                Vacation
07                Labour dispute (strike or lockout) (Employees only)
08                Temporary layoff due to business conditions (Employees only)
09                Seasonal layoff (Employees only)
10                Casual job, no work available (Employees only)
11                Work schedule (for example, shift work) (Employees only)
12                Self-employed, no work available (Self-employed only)
13                Seasonal business (excluding employees)
14                Other - Specify


131

01                Own illness or disability
02                Caring for own children
03                Caring for elder relative (60 years of age or older)
04                Pregnancy (Females only)
05                Other personal or family responsibilities
06                Going to school
07                Lost job, laid off or job ended (Employees only)
08                Business sold or closed down (excluding employees)
09                Changed residence
10                Dissatisfied with job
11                Retired
12                Other - Specify


132

1                 End of seasonal job
2                 End of temporary, term or contract job (non-seasonal)
3                 Casual job
4                 Company moved
5                 Company went out of business
6                 Business conditions (for example, not enough work, drop in orders or retooling)
7                 Dismissal by employer (for example, fired)
8                 Other - Specify


133 / 521

1                 Yes
2                 No
3                 Not sure




     74        Statistics Canada – Catalogue no. 71-543
                                                                                    Guide to the Labour Force Survey




137 / 177

1           30 or more hours per week
2           Less than 30 hours per week


154

01          Own illness or disability
02          Caring for own children
03          Caring for elder relative (60 years of age or older)
04          Maternity or parental leave
05          Other personal or family responsibilities
06          Vacation
07          Labour dispute (strike or lockout)
08          Temporary layoff due to business conditions
09          Holiday (legal or religious)
10          Weather
11          Job started or ended during week
12          Working short-time (for example, due to material shortages, plant maintenance or repair)
13          Other - Specify


159

1           Own illness or disability
2           Caring for own children
3           Caring for elder relative (60 years of age or older)
4           Other personal or family responsibilities
5           Going to school
6           Personal preference
7           Other - Specify


160

1           Own illness or disability
2           Caring for own children
3           Caring for elder relative (60 years of age or older)
4           Other personal or family responsibilities
5           Going to school
6           Business conditions
7           Could not find work with 30 or more hours per week
8           Other - Specify




                                                                   Statistics Canada – Catalogue no. 71-543      75
     Guide to the Labour Force Survey




171

1                 Public employment agency
2                 Private employment agency
3                 Union
4                 Employers directly
5                 Friends or relatives
6                 Placed or answered ads
7                 Looked at job ads
8                 Other - Specify


173

1                 Working
2                 Managing a home
3                 Going to school
4                 Other - Specify


175

1                 Before the date above
2                 On or after the date above


178

1                 Own illness or disability
2                 Caring for own children
3                 Caring for elder relative (60 years of age or older)
4                 Other personal or family responsibilities
5                 Going to school
6                 Waiting for recall (to former employer)
7                 Waiting for replies from employers
8                 Believes no work available (in area, or suited to skills)
9                 No reason given
10                Other - Specify


191

1                 Own illness or disability
2                 Caring for own children
3                 Caring for elder relative (60 years of age or older)
4                 Other personal or family responsibilities
5                 Going to school
6                 Vacation
7                 Already has a job
8                 Other - Specify




     76        Statistics Canada – Catalogue no. 71-543
                                                                                   Guide to the Labour Force Survey




204

1           Yearly
2           Monthly
3           Semi-monthly
4           Bi-weekly
5           Weekly
6           Other - Specify


241

1           Seasonal job
2           Temporary, term or contract job (non-seasonal)
3           Casual job
5           Other - Specify


260 / 262

1           Less than 20
2           20 to 99
3           100 to 500
4           Over 500


501

1           Full-time
2           Part-time


502

1           Elementary, junior high school, high school or equivalent
2           Community college, junior college, or CEGEP
3           University
4           Other - Specify


Codes for Exit component

PTC_Q02

1           Any time
2           Morning
3           Afternoon
4           Evening
5           Not morning
6           Not afternoon
7           Not evening




                                                                  Statistics Canada – Catalogue no. 71-543      77
