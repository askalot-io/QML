# Labour Force Survey (LFS) — Question Inventory

## Verification Status

| Section | Source Qs | Inventory Qs | Missing | Source GOTOs | Inv. GOTOs | Missing |
|---------|----------|-------------|---------|-------------|-----------|---------|
| Contact | 13 | 13 | 0 | 21 | 24 | 0 |
| Household | 22 | 22 | 0 | 29 | 35 | 0 |
| Individual Demographics | 19 | 19 | 0 | 17 | 32 | 0 |
| Rent | 20 | 20 | 0 | 28 | 41 | 0 |
| Labour Force Information | 75 | 75 | 0 | 100 | 144 | 0 |
| Exit | 14 | 14 | 0 | 16 | 25 | 0 |

- **Coverage**: 6/6 sections verified, 163 items total (exact match)
- **Routing**: 211/211 source GOTO instructions captured; inventory adds 90 explicit fall-through annotations (301 total)
- **Node types**: 13 Read items, 28 Filter/Check items, 122 Question items (Single/Multi select, Yes/No, Numeric, Text, Date, Roster)
- **Derived variables**: PATH assignments (all 7 values documented), actual hours calculation (Q156) captured
- **Terminal routing**: 9/9 "thank person and end call" exits captured
- **Status**: READY FOR QML
- **Missing**: none

## Document Overview
- **Title**: Labour Force Survey (LFS) Questionnaire
- **Organization**: Statistics Canada
- **Pages**: 30 (Appendix B, pages 48–77)
- **Language**: English
- **Type**: CATI household survey (monthly, 6-month rotation)

## Structure

The LFS questionnaire consists of 6 components, administered sequentially:

1. **Contact Component** (13 items) — Call introduction, respondent identification, language preference
2. **Household Component** (22 items) — Address confirmation, dwelling type, household roster
3. **Individual Demographics** (19 items) — Per-person: age, sex, marital status, immigration, aboriginal identity, education, armed forces
4. **Rent Component** (20 items) — Conditional on renting; rent amount, subsidies, utilities, parking
5. **Labour Force Information** (75 items) — Job attachment, job description, absence, hours, job search, availability, earnings, union, permanence, firm size, school attendance
6. **Exit Component** (14 items) — Future contact, telephone confirmation, thank respondent

**Total: 163 items**

## Question Inventory by Section

### Contact Component — 13 items

1. II_R01A: "Hello, I'm calling from Statistics Canada. My name is …." — Read — If interview in person → GO TO IC_R01; If birth interview by telephone → GO TO AR_Q01; If subsequent interview by telephone → GO TO SR_Q01

2. SR_Q01: "May I speak with …?" — Single select {1: "Yes, speaking to respondent", 2: "Yes, respondent available", 3: "No, respondent not available", 4: "No, respondent no longer a household member", 5: "Wrong number"} — 1 → GO TO IC_R01; 2 → GO TO II_R01B; 3,4 → GO TO AR_Q01; 5 → GO TO TC_Q01

3. II_R01B: "Hello, I'm calling from Statistics Canada. My name is …." — Read — GO TO IC_R01

4. TC_Q01: "I would like to make sure I've dialled the right number. Is this …?" — Yes/No — Yes → GO TO AR_Q01; No → Thank person and end call

5. AR_Q01: "May I speak with an adult member of the household?" — Single select {1: "Yes, speaking to an adult member", 2: "Yes, an adult member is available", 3: "No, an adult member is not available"} — 1 and CATI birth interview → GO TO TFCC_Q01; 1 and not CATI birth interview → GO TO IC_R01; 2 → GO TO II_R01C; 3 and birth interview → GO TO ARA_Q01; 3 and subsequent interview and SR_Q01=3 → GO TO SRA_Q01; 3 and subsequent interview and (SR_Q01=4 or SR_Q01=5) → GO TO ARA_Q01

6. II_R01C: "Hello, I'm calling from Statistics Canada. My name is …." — Read — If CATI birth interview → GO TO TFCC_Q01; If not CATI birth interview → GO TO IC_R01

7. SRA_Q01: "I would like to contact …. When would he/she be available?" — Single select {1: "Hard appointment", 2: "Soft appointment", 3: "Not available"} — 1,2 → Make appointment, thank person and end call; 3 → GO TO ARA_Q01

8. ARA_Q01: "When would an adult member of the household be available?" — Single select {1: "Hard appointment", 2: "Soft appointment", 3: "Not available"} — 1,2 → Make appointment, thank person and end call; 3 → Thank person and end call

9. TFCC_Q01: "In order to make sure I've reached the correct household, I need to confirm your address. Is it …?" — Yes/No — Yes → GO TO IC_R01; No → GO TO TFCC_Q02

10. TFCC_Q02: "I would like to make sure I've dialled the right number. Is this …?" — Yes/No — Thank person and end call

11. IC_R01: "I'm calling regarding the Labour Force Survey." — Read — GO TO LP_Q01

12. LP_Q01: "Would you prefer to be interviewed in English or in French?" — Single select {1: "English", 2: "French", 3: "Other"} — If CATI interview → GO TO MON_R01; If not CATI interview → GO TO Household Component

13. MON_R01: "My supervisor may listen to this call for the purpose of quality control." — Read — GO TO Household Component

### Household Component — 22 items

1. LA_N01: "Confirm the listing address." — Filter — If CATI birth interview → GO TO MA_Q01; If subsequent interview in person → GO TO CMA_Q01; If subsequent interview by telephone → GO TO SD_Q01; Otherwise → GO TO MA_Q01

2. SD_Q01: "I would like to confirm your address. Are you still living at …?" — Single select {1: "Yes", 2: "No", 3: "Respondent never lived there"} — 1 and listing address = mailing address → GO TO CHM_Q01; 1 and listing address ≠ mailing address → GO TO CMA_Q01; 2 → GO TO SD_Q02; 3 → GO TO SD_Q05

3. SD_Q02: "Does anyone who was living with you at that address still live there?" — Yes/No — Yes → GO TO SD_Q03; No → Thank person and end call

4. SD_Q03: "Can you provide me with the current telephone number for that address?" — Yes/No — Yes → GO TO SD_Q04; No → Thank person and end call

5. SD_Q04: "What is that telephone number, including the area code?" — Text — Thank person and end call

6. SD_Q05: "I would like to make sure I've dialled the right number. Is this …?" — Yes/No — Thank person and end call

7. CHM_Q01: "Is this also your mailing address?" — Yes/No — Yes → GO TO TN_Q01; No → GO TO MA_Q01

8. CMA_Q01: "I would like to confirm your mailing address. Is it …?" — Yes/No — Yes → GO TO TN_Q01; No → GO TO MA_Q01

9. MA_Q01: "What is your correct mailing address?" — Text — If birth interview in person → GO TO DW_N02; If birth interview by telephone → GO TO DW_Q01; If subsequent interview → GO TO TN_Q01

10. DW_Q01: "What type of dwelling do you live in? Is it a:" — Single select {1: "Single detached", 2: "Double", 3: "Row or terrace", 4: "Duplex", 5: "Low-rise apartment", 6: "High-rise apartment", 7: "Institution", 8: "Hotel/rooming/lodging house/camp", 9: "Mobile home", 10: "Other"} — GO TO TN_Q01

11. DW_N02: "Select the dwelling type." — Single select {1: "Single detached", 2: "Double", 3: "Row or terrace", 4: "Duplex", 5: "Low-rise apartment", 6: "High-rise apartment", 7: "Institution", 8: "Hotel/rooming/lodging house/camp", 9: "Mobile home", 10: "Other"} — GO TO TN_Q01

12. TN_Q01: "Is this dwelling owned by a member of this household?" — Yes/No — GO TO RS_R01

13. RS_R01: "The next few questions ask for important basic information about the people in your household." — Read — If birth interview → GO TO USU_Q01; If subsequent interview → GO TO PV2_Q01

14. USU_Q01: "What are the names of all persons who usually live here? Begin with adults who have responsibility for the care or support of the family." — Roster (household members) — GO TO RS_Q02

15. RS_Q02: "Is anyone staying here temporarily?" — Yes/No — Yes → GO TO TEM_Q01; No → GO TO RS_Q04

16. TEM_Q01: "What are the names of all persons who are staying here temporarily? Add a person only if he/she has no other usual residence elsewhere." — Roster (temporary residents) — GO TO RS_Q04

17. RS_Q04: "Are there any other persons who usually live here but are now away at school, in hospital, or somewhere else?" — Yes/No — Yes → GO TO OTH1_Q01; No → GO TO Individual Demographics

18. OTH1_Q01: "What are the names of the other people who live or stay here? Add a person only if he/she has no other usual residence elsewhere." — Roster (absent members) — GO TO Individual Demographics

19. PV2_Q01: "Do the following people still live or stay in this dwelling?" — Yes/No — Yes → GO TO RS_Q05; No → GO TO RES_Q02

20. RES_Q02: "Is … no longer a member of the household or deceased?" — Single select {1: "No longer a member", 2: "Deceased"} — GO TO PV2_Q01 (loop for next person)

21. RS_Q05: "Does anyone else now live or stay here?" — Yes/No — Yes → GO TO OTH2_Q01; No → GO TO Individual Demographics

22. OTH2_Q01: "What are the names of the other people who live or stay here? Add a person only if he/she has no other usual residence elsewhere." — Roster (new members) — GO TO Individual Demographics

### Individual Demographics — 19 items

*The following demographic information is collected for each household member.*

1. ANC_Q01: "What is …'s date of birth?" — Date — GO TO ANC_Q02

2. ANC_Q02: "So …'s age on [date of last day of reference week] was [calculated age]. Is that correct?" — Yes/No — Yes → GO TO SEX_Q01; No → GO TO ANC_Q03

3. ANC_Q03: "What is …'s age?" — Numeric — GO TO SEX_Q01

4. SEX_Q01: "Enter …'s sex." — Single select {1: "Male", 2: "Female"} — GO TO MSNC_Q01

5. MSNC_Q01: "What is …'s marital status? Is he/she:" — Single select {1: "Married", 2: "Living common-law", 3: "Widowed", 4: "Separated", 5: "Divorced", 6: "Single, never married"} — Filter: If age < 16 → GO TO FI_N01; Otherwise ask question → GO TO FI_N01

6. FI_N01: "Enter …'s family identifier: A to Z. Assign the same letter to all persons related by blood, marriage or adoption." — Text — GO TO RR_N01

7. RR_N01: "Determine a reference person for the family and select …'s relationship to that reference person." — Single select {1: "Reference person", 2: "Spouse", 3: "Son or daughter", 4: "Grandchild", 5: "Son-in-law or daughter-in-law", 6: "Foster child (<18)", 7: "Parent", 8: "Parent-in-law", 9: "Brother or sister", 10: "Other relative"} — GO TO IMM_Q01

8. IMM_Q01: "In what country was … born? Specify country of birth according to current boundaries." — Single select {1: "Canada", 2: "United States", 3: "United Kingdom", 4: "Germany", 5: "Italy", 6: "Poland", 7: "Portugal", 8: "China", 9: "Hong Kong", 10: "India", 11: "Philippines", 12: "Vietnam", 13: "Other"} — If 1 (Canada) → GO TO ABO_Q01; If 2–13 → GO TO IMM_Q02

9. IMM_Q02: "Is … now, or has he/she ever been, a landed immigrant in Canada?" — Yes/No — Yes → GO TO IMM_Q03; No → GO TO ABO_Q01

10. IMM_Q03: "In what year did … first become a landed immigrant?" — Numeric (year) — GO TO IMM_Q04

11. IMM_Q04: "In what month?" — Numeric (month) — Filter: If IMM_Q03 is more than five years ago → GO TO ABO_Q01; Otherwise ask question → GO TO ABO_Q01

12. ABO_Q01: "Is … an Aboriginal person, that is, North American Indian, Métis or Inuit?" — Yes/No — Filter: If Country of Birth is not Canada, USA, or Greenland → GO TO ED_Q01; Otherwise: Yes → GO TO ABO_Q02; No → GO TO ED_Q01

13. ABO_Q02: "Is … a North American Indian, Métis or Inuit? Mark all that apply." — Multi select {1: "North American Indian", 2: "Métis", 3: "Inuit"} — GO TO ED_Q01

14. ED_Q01: "What is the highest grade of elementary or high school … ever completed?" — Single select {1: "Grade 8 or lower", 2: "Grade 9–10", 3: "Grade 11–13"} — Filter: If age < 14 → GO TO CAF_Q01; If 1 or 2 → GO TO ED_Q03; If 3 → GO TO ED_Q02

15. ED_Q02: "Did … graduate from high school (secondary school)?" — Yes/No — GO TO ED_Q03

16. ED_Q03: "Has … received any other education that could be counted towards a degree, certificate or diploma from an educational institution?" — Yes/No — Yes → GO TO ED_Q04; No → GO TO CAF_Q01

17. ED_Q04: "What is the highest degree, certificate or diploma … has obtained?" — Single select {1: "No postsecondary degree", 2: "Trade certificate", 3: "Non-university certificate", 4: "University certificate below bachelor's", 5: "Bachelor's degree", 6: "University degree above bachelor's"} — GO TO CHE_Q01

18. CHE_Q01: "In what country did … complete his/her highest degree, certificate or diploma?" — Single select {1: "Canada", 2: "United States", 3: "United Kingdom", 4: "Germany", 5: "Italy", 6: "Poland", 7: "Portugal", 8: "China", 9: "Hong Kong", 10: "India", 11: "Philippines", 12: "Vietnam", 13: "Other"} — Filter: If (Country of Birth is Canada) or (IMM_Q02 = No) or (no post-secondary degree/certificate/diploma) → GO TO CAF_Q01; Otherwise ask question → GO TO CAF_Q01

19. CAF_Q01: "Is … a full-time member of the regular Canadian Armed Forces?" — Yes/No — Filter: If age < 16 or age > 65 → GO TO ANC_Q01 for next household member; If Yes → GO TO ANC_Q01 for next person; If No → GO TO Labour Force Information

### Rent Component — 20 items

*Component-level precondition: TN_Q01 = "No" AND province is not Yukon, Northwest Territories, or Nunavut.*

1. RRF_R01: "The next few questions are about your rent. The information collected is used to calculate the rent portion of the Consumer Price Index." — Read — GO TO RM_Q01

2. RM_Q01: "On which floor do you live?" — Numeric — Filter: If rent information exists from previous month → GO TO RM_Q04; If dwelling type is not "Low-rise apartment" and not "High-rise apartment" → GO TO RM_Q02; Otherwise ask question → GO TO RM_Q02

3. RM_Q02: "To the best of your knowledge, how old is your building?" — Single select {1: "No more than 5 years old", 2: "More than 5 but ≤ 10", 3: "More than 10 but ≤ 20", 4: "More than 20 but ≤ 40", 5: "More than 40 years old"} — GO TO RM_Q03

4. RM_Q03: "How many bedrooms are there in your dwelling?" — Numeric — GO TO RM_Q04

5. RM_Q04: "This month, is the rent for your dwelling subsidized by government or an employer, or a relative?" — Yes/No — Yes → GO TO RM_Q04A; No → GO TO RM_Q05

6. RM_Q04A: "In what manner is the rent for your dwelling subsidized?" — Single select {1: "Income-related/Government", 2: "Employer", 3: "Owned by a relative", 4: "Other"} — GO TO RM_Q05

7. RM_Q05: "This month, is the rent for your dwelling applied to both living and business accommodation?" — Yes/No — Yes → GO TO RM_Q05A; No → GO TO RM_Q06

8. RM_Q05A: "Does the business affect the amount of rent paid?" — Yes/No — GO TO RM_Q06

9. RM_Q06: "How much is the total monthly rent for your dwelling?" — Numeric — If $0 → GO TO RM_Q07; If >$0 → GO TO RM_Q08

10. RM_Q07: "What is the reason that the rent is $0?" — Text — If RM_Q04 = Yes → GO TO end of Rent Component; Otherwise → GO TO RM_Q08

11. RM_Q08: "Since last month, have there been any changes in the amount of rent paid?" — Yes/No — Filter: If no rent information from previous month → GO TO RM_Q09B; If complete change in household membership → GO TO RM_Q09B; If RM_Q04 = Yes → GO TO RM_Q09B; Otherwise: Yes → GO TO RM_Q08A; No → GO TO RM_Q09B

12. RM_Q08A: "What is the reason for the change in rent since last month? Mark all that apply." — Multi select {1: "Change in utilities/services/appliances/furnishings", 2: "Change in parking facilities", 3: "New Lease", 4: "Other"} — GO TO RM_Q09B

13. RM_Q09B: "Does this month's rent include parking facilities?" — Yes/No — Filter: If dwelling type is not "Low-rise apartment" and not "High-rise apartment" → GO TO RM_Q14; If rent info exists from previous month and no complete change in household membership → GO TO RM_Q09S; Otherwise: Yes → GO TO RM_Q10; No → GO TO RM_Q14

14. RM_Q09S: "Since last month, have there been any changes in the parking facilities?" — Yes/No — Yes → GO TO RM_Q10; No → GO TO RM_Q14

15. RM_Q10: "What types of parking facilities are included in your rent? Mark all that apply." — Multi select {1: "Closed garage or indoor parking", 2: "Outside parking with plug-in", 3: "Outside parking without plug-in"} — GO TO RM_Q11

16. RM_Q11: "How many closed garage or indoor parking spaces are included in your rent?" — Numeric — Filter: If RM_Q10 does not include 1 → GO TO RM_Q12; Otherwise ask question → GO TO RM_Q12

17. RM_Q12: "How many outside parking spaces with plug-in are included in your rent?" — Numeric — Filter: If RM_Q10 does not include 2 → GO TO RM_Q13; Otherwise ask question → GO TO RM_Q13

18. RM_Q13: "How many outside parking spaces without plug-in are included in your rent?" — Numeric — Filter: If RM_Q10 does not include 3 → GO TO RM_Q14; Otherwise ask question → GO TO RM_Q14

19. RM_Q14: "Since last month, have there been any changes in the utilities, services, appliances, or furnishings included in the rent?" — Yes/No — Filter: If no rent info from previous month → GO TO RM_Q15; If complete change in household membership → GO TO RM_Q15; If RM_Q08A includes 1 → GO TO RM_Q15; Otherwise: Yes → GO TO RM_Q15; No → GO TO end of Rent Component

20. RM_Q15: "Which of the following utilities, services, appliances, or furnishings are included as part of the monthly rent? Read list to respondent. Mark all that apply." — Multi select {1: "Heat - Electric", 2: "Heat - Natural Gas", 3: "Heat - Other", 4: "Electricity", 5: "Cablevision", 6: "Refrigerator", 7: "Range", 8: "Washer", 9: "Dryer", 10: "Other major appliance", 11: "Furniture", 12: "None of the above"} — GO TO end of Rent Component

### Labour Force Information — 75 items

*For each person aged 15+ who is not a full-time member of the regular Canadian Armed Forces.*

**PATH variable**: Controls routing through the component. Values:
- PATH=1: Employed, at work
- PATH=2: Employed, absent from work
- PATH=3: Temporary layoff
- PATH=4: Job seeker
- PATH=5: Future start
- PATH=6: Not in labour force, able to work
- PATH=7: Not in labour force, permanently unable to work

#### Job Attachment

1. 100: "Last week, did … work at a job or business? (regardless of the number of hours)" — Single select {1: "Yes", 2: "No", 3: "Permanently unable to work"} — If 1: PATH=1 → GO TO 102; If 2 → GO TO 101; If 3: PATH=7 → GO TO 104

2. 101: "Last week, did … have a job or business from which he/she was absent?" — Yes/No — Yes → GO TO 102; No → GO TO 104

3. 102: "Did he/she have more than one job or business last week?" — Yes/No — Yes → GO TO 103; No → GO TO 110

4. 103: "Was this a result of changing employers?" — Yes/No — GO TO 110

5. 104: "Has he/she ever worked at a job or business?" — Yes/No — Yes → GO TO 105; No → GO TO 170

6. 105: "When did he/she last work?" — Date — If subsequent interview and no change in 105 and last month's PATH=3 → GO TO 131; Else if subsequent interview and no change in 105 and last month's PATH=4–7 → GO TO 170; Else if not within past year → GO TO 170; Else if PATH=7 → GO TO 131; Else → GO TO 110

#### Job Description

7. 110: "Was he/she an employee or self-employed?" — Single select {1: "Employee", 2: "Self-employed", 3: "Working in a family business without pay"} — If not 2 → GO TO 114; If 2 → GO TO 111. Context: If 103=Yes, asks about "new job or business"; if 103=No, asks about "job or business at which he/she usually works the most hours"

8. 111: "Did he/she have an incorporated business?" — Yes/No — GO TO 112

9. 112: "Did he/she have any employees?" — Yes/No — GO TO 113

10. 113: "What was the name of his/her business?" — Text — GO TO 115

11. 114: "For whom did he/she work?" — Text — GO TO 115

12. 115: "What kind of business, industry or service was this?" — Text — GO TO 116

13. 116: "What kind of work was he/she doing?" — Text — GO TO 117

14. 117: "What were his/her most important activities or duties?" — Text — GO TO 118

15. 118: "When did he/she start working for [name of employer]?" — Date — GO TO 130

#### Absence — Separation

16. 130: "What was the main reason … was absent from work last week?" — Single select {1: "Own illness or disability", 2: "Caring for own children", 3: "Caring for elder relative", 4: "Maternity or parental leave", 5: "Other personal or family responsibilities", 6: "Vacation", 7: "Labour dispute", 8: "Temporary layoff due to business conditions", 9: "Seasonal layoff", 10: "Casual job, no work available", 11: "Work schedule", 12: "Self-employed, no work available", 13: "Seasonal business", 14: "Other"} — Filter: If PATH=1 → GO TO 150; If 101=No → GO TO 131. If 8 → GO TO 134; If 9 → GO TO 136; If 10 → GO TO 137; Otherwise: PATH=2 → GO TO 150

17. 131: "What was the main reason … stopped working at that [job/business]?" — Single select {1: "Own illness or disability", 2: "Caring for own children", 3: "Caring for elder relative", 4: "Pregnancy", 5: "Other personal or family responsibilities", 6: "Going to school", 7: "Lost job, laid off or job ended", 8: "Business sold or closed down", 9: "Changed residence", 10: "Dissatisfied with job", 11: "Retired", 12: "Other"} — If not 7 → GO TO 137; If 7 → GO TO 132

18. 132: "Can you be more specific about the main reason for his/her job loss?" — Single select {1: "End of seasonal job", 2: "End of temporary/term/contract job", 3: "Casual job", 4: "Company moved", 5: "Company went out of business", 6: "Business conditions", 7: "Dismissal by employer", 8: "Other"} — If PATH=7 → GO TO 137; Else if 6 → GO TO 133; Otherwise → GO TO 137

19. 133: "Does he/she expect to return to that job?" — Single select {1: "Yes", 2: "No", 3: "Not sure"} — If 2 or 3 → GO TO 137; If 1 → GO TO 134

20. 134: "Has …'s employer given him/her a date to return?" — Yes/No — Yes → GO TO 136; No → GO TO 135

21. 135: "Has he/she been given any indication that he/she will be recalled within the next 6 months?" — Yes/No — GO TO 136

22. 136: "As of last week, how many weeks had … been on layoff?" — Numeric — If 130=9 (Seasonal layoff) → GO TO 137; Else if 134=No and 135=No → GO TO 137; Else if layoff > 52 weeks → GO TO 137; Otherwise: PATH=3 → GO TO 137

23. 137: "Did he/she usually work more or less than 30 hours per week?" — Single select {1: "30 or more hours per week", 2: "Less than 30 hours per week"} — If PATH=3 → GO TO 190; Otherwise → GO TO 170

#### Work Hours — Main Job

24. 150: "Does the number of [paid] hours … works vary from week to week?" — Yes/No — If 110=Employee: "Excluding overtime, does the number of paid hours…"; Otherwise: "Does the number of hours…". Yes → GO TO 152; No → GO TO 151

25. 151: "[Excluding overtime,] how many [paid] hours does … work per week?" — Numeric — If 110=Employee: asks about paid hours excluding overtime. If PATH=2 → GO TO 158; If 110=Employee → GO TO 153; Otherwise → GO TO 157

26. 152: "[Excluding overtime,] on average, how many [paid] hours does … usually work per week?" — Numeric — If 110=Employee: asks about paid hours excluding overtime. If PATH=2 → GO TO 158; If 110=Employee → GO TO 153; Otherwise → GO TO 157

27. 153: "Last week, how many hours was he/she away from this job because of vacation, illness, or any other reason?" — Numeric — If 0 hours → GO TO 155; Otherwise → GO TO 154

28. 154: "What was the main reason for that absence?" — Single select {1: "Own illness or disability", 2: "Caring for own children", 3: "Caring for elder relative", 4: "Maternity or parental leave", 5: "Other personal or family responsibilities", 6: "Vacation", 7: "Labour dispute", 8: "Temporary layoff due to business conditions", 9: "Holiday", 10: "Weather", 11: "Job started or ended during week", 12: "Working short-time", 13: "Other"} — GO TO 155

29. 155: "Last week, how many hours of paid overtime did he/she work at this job?" — Numeric — GO TO 156

30. 156: "Last week, how many extra hours without pay did he/she work at this job?" — Numeric — If 150=No: actual hours = 151 − 153 + 155 + 156 → GO TO 158; Otherwise → GO TO 157

31. 157: "Last week, how many hours did he/she actually work at his/her [new] [job/business] [at name of employer]?" — Numeric — GO TO 158

32. 158: "Does he/she want to work 30 or more hours per week [at a single job]?" — Yes/No — Filter: If (151≥29.5 or 152≥29.5) and PATH=2 → GO TO 162; If (151≥29.5 or 152≥29.5) and PATH=1 → GO TO 200. Yes → GO TO 160; No → GO TO 159

33. 159: "What is the main reason … does not want to work 30 or more hours per week [at a single job]?" — Single select {1: "Own illness or disability", 2: "Caring for own children", 3: "Caring for elder relative", 4: "Other personal or family responsibilities", 5: "Going to school", 6: "Personal preference", 7: "Other"} — If PATH=2 → GO TO 162; Otherwise → GO TO 200

34. 160: "What is the main reason … usually works less than 30 hours per week [at his/her main job]?" — Single select {1: "Own illness or disability", 2: "Caring for own children", 3: "Caring for elder relative", 4: "Other personal or family responsibilities", 5: "Going to school", 6: "Business conditions", 7: "Could not find work with 30 or more hours per week", 8: "Other"} — If not (6 or 7) and PATH=2 → GO TO 162; If not (6 or 7) and PATH=1 → GO TO 200; If 6 or 7 → GO TO 161

35. 161: "At any time in the 4 weeks ending last Saturday, did he/she look for full-time work?" — Yes/No — If PATH=2 → GO TO 162; Otherwise → GO TO 200

36. 162: "As of last week, how many weeks had … been continuously absent from work?" — Numeric — If (110=Employee) or (110=Self-employed and 111=Yes) → GO TO 163; Otherwise → GO TO 200

37. 163: "Is he/she getting any wages or salary from his/her [employer/business] for any time off last week?" — Yes/No — GO TO 200

#### Job Search — Future Start

38. 170: "In the 4 weeks ending last Saturday, did … do anything to find work?" — Yes/No — Filter: If PATH=7 → GO TO 500. If Yes: PATH=4 → GO TO 171; If No and age ≥ 65: PATH=6 → GO TO 500; If No and age ≤ 64 → GO TO 174

39. 171: "What did he/she do to find work in those 4 weeks? Did he/she do anything else to find work?" — Multi select {1: "Public employment agency", 2: "Private employment agency", 3: "Union", 4: "Employers directly", 5: "Friends or relatives", 6: "Placed or answered ads", 7: "Looked at job ads", 8: "Other"} — GO TO 172

40. 172: "As of last week, how many weeks had he/she been looking for work?" — Numeric — GO TO 173

41. 173: "What was his/her main activity before he/she started looking for work?" — Single select {1: "Working", 2: "Managing a home", 3: "Going to school", 4: "Other"} — GO TO 177

42. 174: "Last week, did … have a job to start at a definite date in the future?" — Yes/No — Yes → GO TO 175; No: PATH=6 → GO TO 176

43. 175: "Will he/she start that job before or after Sunday, [date of the first day after four weeks from the last day of reference week]?" — Single select {1: "Before the date above", 2: "On or after the date above"} — If 1: PATH=5 → GO TO 190; If 2: PATH=6 → GO TO 500

44. 176: "Did he/she want a job last week?" — Yes/No — Yes → GO TO 177; No → GO TO 500

45. 177: "Did he/she want a job with more or less than 30 hours per week?" — Single select {1: "30 or more hours per week", 2: "Less than 30 hours per week"} — GO TO 178

46. 178: "What was the main reason he/she did not look for work last week?" — Single select {1: "Own illness or disability", 2: "Caring for own children", 3: "Caring for elder relative", 4: "Other personal or family responsibilities", 5: "Going to school", 6: "Waiting for recall", 7: "Waiting for replies from employers", 8: "Believes no work available", 9: "No reason given", 10: "Other"} — Filter: If PATH=4 → GO TO 190. If 8 → GO TO 190; Otherwise → GO TO 500

#### Availability

47. 190: "Could he/she have worked last week [if he/she had been recalled/if a suitable job had been offered]?" — Yes/No — Yes → GO TO 400; No → GO TO 191

48. 191: "What was the main reason … was not available to work last week?" — Single select {1: "Own illness or disability", 2: "Caring for own children", 3: "Caring for elder relative", 4: "Other personal or family responsibilities", 5: "Going to school", 6: "Vacation", 7: "Already has a job", 8: "Other"} — GO TO 400

#### Earnings — Union — Permanence

49. 200: "Is he/she paid by the hour?" — Yes/No — Filter: If 110 is not Employee → GO TO 300; If subsequent interview and no change in 110, 114, 115, 116, 117, 118 → GO TO 300. Otherwise ask question → GO TO 201

50. 201: "Does he/she usually receive tips or commissions?" — Yes/No — If 200=Yes → GO TO 202; If 200=No → GO TO 204

51. 202: "[Including tips and commissions,] what is his/her hourly rate of pay?" — Numeric — GO TO 220

52. 204: "What is the easiest way for you to tell us his/her wage or salary, [including tips and commissions,] before taxes and other deductions? Would it be yearly, monthly, weekly, or on some other basis?" — Single select {1: "Yearly", 2: "Monthly", 3: "Semi-monthly", 4: "Bi-weekly", 5: "Weekly", 6: "Other"} — If 1 → GO TO 209; If 2 → GO TO 208; If 3 → GO TO 207; If 4 → GO TO 206; If 5 or 6 → GO TO 205

53. 205: "[Including tips and commissions,] what is his/her weekly wage or salary, before taxes and other deductions?" — Numeric — GO TO 220

54. 206: "[Including tips and commissions,] what is his/her bi-weekly wage or salary, before taxes and other deductions?" — Numeric — GO TO 220

55. 207: "[Including tips and commissions,] what is his/her semi-monthly wage or salary, before taxes and other deductions?" — Numeric — GO TO 220

56. 208: "[Including tips and commissions,] what is his/her monthly wage or salary, before taxes and other deductions?" — Numeric — GO TO 220

57. 209: "[Including tips and commissions,] what is his/her yearly wage or salary, before taxes and other deductions?" — Numeric — GO TO 220

58. 220: "Is he/she a union member at [name of employer]?" — Yes/No — Yes → GO TO 240; No → GO TO 221

59. 221: "Is he/she covered by a union contract or collective agreement?" — Yes/No — GO TO 240

60. 240: "Is …'s [new] job [at name of employer] permanent, or is there some way that it is not permanent?" — Single select {1: "Permanent", 2: "Not permanent"} — If 1 → GO TO 260; If 2 → GO TO 241

61. 241: "In what way is his/her job not permanent?" — Single select {1: "Seasonal job", 2: "Temporary/term/contract job", 3: "Casual job", 5: "Other"} — GO TO 260

62. 260: "About how many persons are employed at the location where … works for [name of employer]? Would it be less than 20, 20 to 99, 100 to 500, or over 500?" — Single select {1: "Less than 20", 2: "20 to 99", 3: "100 to 500", 4: "Over 500"} — GO TO 261

63. 261: "Does [name of employer] operate at more than one location?" — Yes/No — If No or 260=4 → GO TO 300; If Yes → GO TO 262

64. 262: "In total, about how many persons are employed at all locations? Would it be less than 20, 20 to 99, 100 to 500, or over 500?" — Single select {1: "Less than 20", 2: "20 to 99", 3: "100 to 500", 4: "Over 500"} — GO TO 300

#### Class of Worker — Hours at Other Job

65. 300: "Was he/she an employee or self-employed?" — Single select {1: "Employee", 2: "Self-employed", 3: "Working in a family business without pay"} — Filter: If 102=No → GO TO 400. Context: asks about other/old job. If not 2 → GO TO 320; If 2 → GO TO 301

66. 301: "Did he/she have an incorporated business?" — Yes/No — GO TO 302

67. 302: "Did he/she have any employees?" — Yes/No — GO TO 320

68. 320: "[Excluding overtime,] how many [paid] hours [does/did] … usually work per week at this job?" — Numeric — If 300=Employee: asks about paid hours excluding overtime. If PATH=2 → GO TO 400; Otherwise → GO TO 321

69. 321: "Last week, how many hours did … actually work at this [job/business/family business]?" — Numeric — GO TO 400

#### Temporary Layoff Job Search

70. 400: "In the 4 weeks ending last Saturday, did … look for a job with a different employer?" — Yes/No — Filter: If PATH ≠ 3 → GO TO 500. Otherwise ask question → GO TO 500

#### School Attendance

71. 500: "Last week, was … attending a school, college or university?" — Yes/No — Filter: If age ≥ 65 → GO TO END. Yes → GO TO 501; No → GO TO 520

72. 501: "Was he/she enrolled as a full-time or part-time student?" — Single select {1: "Full-time", 2: "Part-time"} — GO TO 502

73. 502: "What kind of school was this?" — Single select {1: "Elementary/junior high/high school", 2: "Community college/CEGEP", 3: "University", 4: "Other"} — GO TO 520

74. 520: "Was … a full-time student in March of this year?" — Yes/No — Filter: If survey month not May–August → GO TO END; If age not 15–24 → GO TO END; If subsequent interview and previous 520=No → GO TO END; If subsequent interview and previous 520=Yes → GO TO 521. Yes → GO TO 521; No → GO TO END

75. 521: "Does … expect to be a full-time student this fall?" — Single select {1: "Yes", 2: "No", 3: "Not sure"} — GO TO END

### Exit Component — 14 items

1. EI_R01: "Before we finish, I would like to ask you a few other questions." — Read — Filter: If rotate-out (last month for interview) → GO TO TY_R02; Otherwise → GO TO FC_R01

2. FC_R01: "As part of the Labour Force Survey, we will contact your household next month during the week of [date]. After this month, this dwelling has [calculated number] LFS interview(s) left." — Read — GO TO HC_Q01

3. HC_Q01: "Who would be the best person to contact?" — Text — GO TO TEL_Q01

4. TEL_Q01: "I would like to confirm your telephone number. Is it …?" — Yes/No — Filter: If no telephone number exists → GO TO TEL_Q02; Yes → GO TO PC_Q01; No → GO TO TEL_Q02

5. TEL_Q02: "What is your telephone number, including the area code?" — Text — GO TO PC_Q01

6. PC_Q01: "May we conduct the next interview by telephone?" — Yes/No — Filter: If CATI interview → GO TO PTC_Q01; Yes → GO TO PTC_Q01; No → GO TO PV_R01

7. PV_R01: "In this case we will make a personal visit next month during the week of [date]." — Read — GO TO PTC_Q01

8. PTC_Q01: "I would like to confirm the time of day you would prefer that we call. Is it [preferred time to call]?" — Yes/No — Filter: If no preferred time info from previous month → GO TO PTC_Q02; Yes → GO TO PTC_N03; No → GO TO PTC_Q02

9. PTC_Q02: "What time of day would you prefer that we call? Would it be the morning, the afternoon, the evening, or ANY TIME?" — Multi select {1: "Any time", 2: "Morning", 3: "Afternoon", 4: "Evening", 5: "Not morning", 6: "Not afternoon", 7: "Not evening"} — GO TO PTC_N03

10. PTC_N03: "Enter any other information about the preferred time to call." — Text — GO TO LQ_Q01

11. LQ_Q01: "Is there another set of living quarters within this structure?" — Yes/No — Filter: If CATI interview → GO TO TY_R01; If subsequent interview → GO TO TY_R01; If dwelling type not "Single detached", "Double", "Row or terrace", or "Duplex" → GO TO TY_R01; Yes → GO TO LQ_N02; No → GO TO TY_R01

12. LQ_N02: "Remember to verify the cluster list and add one or more multiples if necessary." — Read — GO TO TY_R01

13. TY_R01: "Thank you for your participation in the Labour Force Survey." — Read — GO TO END

14. TY_R02: "Thank you for your participation in the Labour Force Survey. Although your six months in the Labour Force Survey are over, your household may be contacted by Statistics Canada some time in the future for another survey." — Read — GO TO END
