# SLID 1994 Preliminary Interview - Question Inventory

## Verification Status

| Section | Source Qs | Inventory Qs | Missing | Source GOTOs | Inv. GOTOs | Missing |
|---------|----------|-------------|---------|-------------|-----------|---------|
| EMPPRE  | 57       | 57          | 0       | 64          | 62+       | 0       |
| EXPRE   | 17       | 17          | 0       | 18          | 17+       | 0       |
| DEMPRE  | 46       | 46          | 0       | 42          | 48+       | 0       |
| EDUPRE  | 30       | 30          | 0       | 25          | 23+       | 0       |

- **Coverage**: 4/4 sections verified, 150 items total, 0 missing
- **Routing**: 149/149 source GOTO targets captured; inventory adds 80 explicit GO TO annotations for implicit sequential flows (229 total routing annotations)
- **Node types**: 121 questions, 29 checks/filters (N-prefix, COMPARE, VERIFY, EVAL, INPATH, START), 15 constraint screens -- all present
- **Status**: READY FOR QML
- **Missing**: none
- **Notes**: Source EMPPRE-J2.Q7 routes non-paid workers to "EMPPRE-Q12" (line 643 of OCR) which appears to be a transcription error; inventory corrects this to EMPPRE-N12 consistent with parallel item EMPPRE-J1.Q6 and questionnaire logic. Source EXPRE-Q1 reference (from EMPPRE-N12) preserved as-is; actual EXPRE entry point is EXPRE-N1.

## Document Overview

- **Title**: 1994 Preliminary Interview Questionnaire
- **Organization**: Statistics Canada, Household Surveys Division
- **Catalogue**: No. 94-10
- **Date**: June 1994
- **Language**: English
- **Type**: CATI (Computer-Assisted Interviewing) questionnaire for the Survey of Labour and Income Dynamics (SLID)
- **Authors**: Alison Hale, Debbie Lutz, Mike Brule

## Structure

The questionnaire has four modules:

| Module | Topic | Items |
|--------|-------|-------|
| EMPPRE | Current or recent work activity (up to two employers) | 57 |
| EXPRE | Work experience (full-time history) | 17 |
| DEMPRE | Demographics, marital history, birth history, ethnicity | 46 |
| EDUPRE | Educational attainment and current educational activity | 30 |
| **Total** | | **150** |

**Overall flow**: START-EMPPRE age gate (15+) routes into EMPPRE; EMPPRE exits to EXPRE; EXPRE-N1 age gate (>69) may skip EXPRE; all paths converge at DEMPRE-Q1A; DEMPRE exits to EDUPRE-Q1; EDUPRE-Q18 is the final item.

**Pre-fill items**: [respondent], [current year], [reference year], [age], [response given in ...] are substituted by the CATI system.

**Function keys**: DK (Don't Know) and R (Refusal) are available for virtually all questions.

## Question Inventory by Section

### EMPPRE - Current/Recent Work Activity — 57 items

**Header**: Employer Name (Questions ending in J1 refer to 1st employer; those ending in J2 refer to 2nd employer)

1. START-EMPPRE: "Internal logic: [age] = 15 or more?" — Filter — Yes → EMPPRE-Q1; No → EXPRE-Q1A

2. EMPPRE-Q1: "DID [respondent] WORK AT A JOB OR BUSINESS AT THE BEGINNING OF JANUARY OF THIS YEAR? Interviewer: Enter a job regardless of the number of hours worked." — Single select {1: "Yes", 2: "No", 3: "Permanently unable to work"} — Yes → EMPPRE-J1.Q1; No → EMPPRE-Q2; Permanently unable to work → EMPPRE-Q5; DK/R → EMPPRE-N12

3. EMPPRE-Q2: "DID [respondent] HAVE A JOB OR BUSINESS AT WHICH HE/SHE DID NOT WORK AT THE BEGINNING OF JANUARY?" — Yes/No — Yes → EMPPRE-Q3; No/DK/R → EMPPRE-Q5

4. EMPPRE-Q3: "WHY WAS [respondent] ABSENT FROM WORK AT THE BEGINNING OF JANUARY?" — Single select {1: "Own illness or disability", 2: "Pregnancy", 3: "Caring for own children", 4: "Caring for elder relatives", 5: "Other personal or family responsibilities", 6: "School or educational leave", 7: "Labour dispute", 8: "Temporary layoff due to seasonal conditions", 9: "Temporary layoff - non seasonal", 10: "Unpaid or partially paid vacation", 11: "Other (Specify)"} — 6 ("School or educational leave") → EMPPRE-Q5; Otherwise → EMPPRE-Q4

5. EMPPRE-Q4: "DID [respondent] RECEIVE ANY PAY FROM HIS/HER EMPLOYER FOR THIS ABSENCE?" — Yes/No — Yes/No/DK/R → EMPPRE-N4

6. EMPPRE-N4: "Internal logic: EMPPRE-Q3 = Temporary Layoff (seasonal or non-seasonal)?" — Filter — Yes → EMPPRE-Q8; Otherwise → EMPPRE-J1.Q1

7. EMPPRE-Q5: "DID [respondent] EVER WORK AT A JOB OR BUSINESS?" — Yes/No — Yes/DK/R → EMPPRE-Q6; No → EMPPRE-N7

8. EMPPRE-Q6: "WHEN DID [respondent] LAST WORK AT A JOB OR BUSINESS?" — Date — Hard range: Min = [current year] - ([age] - 10), Max = [current year] — GO TO EMPPRE-N6

9. EMPPRE-N6: "Internal logic: Date in EMPPRE-Q6 is before January [current year] minus 5 AND EMPPRE-Q1 = permanently unable to work?" — Filter — Yes → EMPPRE-N12; Otherwise → EMPPRE-Q7

10. EMPPRE-Q7: "WHAT WAS [respondent]'S MAIN REASON FOR LEAVING THIS JOB?" — Single select {1: "Own illness, disability", 2: "Caring for own children", 3: "Caring for elder relatives", 4: "Other personal or family responsibilities", 5: "Going to school", 6: "Quit job for no specific reason", 7: "Lost job or laid off job - Paid workers only", 8: "Changed residence", 9: "Dissatisfied with job", 10: "Retired", 11: "Other - Specify"} — GO TO EMPPRE-N7

11. EMPPRE-N7: "Internal logic: EMPPRE-Q1 = permanently unable to work?" — Filter — Yes → EMPPRE-N12; Otherwise → EMPPRE-Q8

12. EMPPRE-Q8: "DID [respondent] LOOK FOR WORK IN JANUARY OF THIS YEAR?" — Yes/No — Yes → EMPPRE-Q9; No/DK/R → EMPPRE-Q10

13. EMPPRE-Q9: "WHAT DID [respondent] DO TO FIND WORK?" — Multi select {1: "Contacted employer directly", 2: "Friend or relative", 3: "Placed or answered newspaper ad", 4: "Employment agency", 5: "Referral from another employer", 6: "Other - specify"} — GO TO EMPPRE-N11A

14. EMPPRE-Q10: "DID [respondent] LOOK FOR WORK AT ANY TIME IN THE 6 MONTHS BEFORE THAT?" — Yes/No — Yes/DK/R → EMPPRE-Q11; No → EMPPRE-N11A

15. EMPPRE-Q11: "WHAT WERE THE REASONS [respondent] DID NOT LOOK FOR WORK IN JANUARY OF THIS YEAR? Interviewer: If only answered Own illness or Personal responsibilities, probe for other reasons." — Multi select {1: "Own illness, disability", 2: "Caring for own children", 3: "Caring for elder relatives", 4: "Other personal or family responsibilities", 5: "Going to school", 6: "No longer interested in finding work", 7: "Waiting for recall (to former job)", 8: "Has found new job", 9: "Waiting for replies from employers", 10: "Believes no work available (in area, or suited to skills)", 11: "No reason given", 12: "Other - Specify"} — GO TO EMPPRE-N11A

16. EMPPRE-N11A: "Internal logic: EMPPRE-Q5 = no (never worked) OR date last worked (EMPPRE-Q6) is before January [reference year]?" — Filter — Yes → EMPPRE-N12; Otherwise → EMPPRE-J1.Q1A

17. EMPPRE-N12: "Internal logic: [age] is greater than 64 years?" — Filter — Yes → EXPRE-Q1; Otherwise → EMPPRE-Q12

18. EMPPRE-Q12: "IN JANUARY OF THIS YEAR, WAS [respondent] ATTENDING A SCHOOL, COLLEGE OR UNIVERSITY?" — Yes/No — Yes → EMPPRE-Q13; No/DK/R → EXPRE-Q1A

19. EMPPRE-Q13: "WAS [respondent] ENROLLED AS A FULL-TIME OR PART-TIME STUDENT?" — Single select {1: "Full-time student", 2: "Part-time student", 3: "Some of each"} — GO TO EXPRE-Q1A

#### J1 — 1st Employer Sub-section

20. EMPPRE-J1.Q1: "I WOULD LIKE TO ASK A FEW QUESTIONS ABOUT [respondent]'S MAIN JOB OR BUSINESS IN EARLY JANUARY. FOR WHOM DID [respondent] WORK? (name of business, government department, or agency, or person)" — Text — GO TO EMPPRE-J1.Q2

21. EMPPRE-J1.Q1A: "I WOULD LIKE TO ASK A FEW QUESTIONS ABOUT THE LAST JOB OR BUSINESS HELD BY [respondent] IN [reference year]. FOR WHOM DID [respondent] WORK? (name of business, government department, or agency, or person)" — Text — GO TO EMPPRE-J1.Q2

22. EMPPRE-J1.Q2: "WHEN WAS THE FIRST TIME [respondent] STARTED WORKING FOR THIS EMPLOYER?" — Date — Hard range: Min = [current year] - [age] - 10, Max = [current year] — GO TO EMPPRE-J1.N2

23. EMPPRE-J1.N2: "Internal logic: Date first started working (EMPPRE-J1.Q2) is before date last worked (EMPPRE-Q6)?" — Filter — Yes → EMPPRE-J1.Q3; No → EMPPRE-J1.Q2A; Otherwise (Q6 not answered) → EMPPRE-J1.Q3

24. EMPPRE-J1.Q2A: "Interviewer: Date first started working for this employer (EMPPRE-J1.Q2) is after the date last worked (EMPPRE-Q6). Go back to EMPPRE-Q6 and/or EMPPRE-J1.Q2 to correct inconsistencies, or press <Enter> to continue." — Read (constraint) — GO TO EMPPRE-J1.Q3

25. EMPPRE-J1.Q3: "WHAT KIND OF BUSINESS, INDUSTRY OR SERVICE WAS THIS? (e.g., federal government, canning industry, forestry service)" — Text — GO TO EMPPRE-J1.Q4

26. EMPPRE-J1.Q4: "WHAT KIND OF WORK WAS [respondent] DOING? (e.g., office clerk, factory worker, forestry technician)" — Text — GO TO EMPPRE-J1.Q5

27. EMPPRE-J1.Q5: "WHAT WERE [respondent]'S MOST IMPORTANT ACTIVITIES OR DUTIES? (e.g., filing documents, drying vegetables, forest examiner)" — Text — GO TO EMPPRE-J1.Q6

28. EMPPRE-J1.Q6: "IN THIS JOB, WAS [respondent] A PAID WORKER, SELF-EMPLOYED OR AN UNPAID FAMILY WORKER?" — Single select {1: "Paid worker", 2: "Unpaid family worker", 3: "Self-employed Incorporated - With paid help", 4: "Self-employed Incorporated - No paid help", 5: "Self-employed Unincorporated - With paid help", 6: "Self-employed Unincorporated - No paid help"} — Paid worker or DK/R → EMPPRE-J1.Q7A; Otherwise → EMPPRE-N12

29. EMPPRE-J1.Q7A: "IN WHICH MONTHS OF [reference year] DID [respondent] WORK AT THIS JOB?" — Single select {1: "All months", 2: "Started in [current year]", 3: "Specify months", 4: "Last worked before [reference year]"} — All months/DK/R → EMPPRE-J1.Q8; Started in [current year] → EMPPRE-N12; Specify months → EMPPRE-J1.Q7B; Last worked before [reference year] → EMPPRE-J1.Q7B

30. EMPPRE-J1.Q7B: "Interviewer: Specify months [respondent] worked in [reference year]" — Multi select {1: "January", 2: "February", 3: "March", 4: "April", 5: "May", 6: "June", 7: "July", 8: "August", 9: "September", 10: "October", 11: "November", 12: "December"} — GO TO EMPPRE-J1.Q8

31. EMPPRE-J1.Q8: "AT THIS JOB, DID [respondent] USUALLY WORK EVERY WEEK OF THE MONTH?" — Yes/No — Yes/DK/R → EMPPRE-J1.Q10; No → EMPPRE-J1.Q9

32. EMPPRE-J1.Q9: "HOW MANY WEEKS DID [respondent] USUALLY WORK EACH MONTH?" — Numeric (1–3) — GO TO EMPPRE-J1.Q10

33. EMPPRE-J1.Q10: "HOW MANY HOURS PER WEEK DID [respondent] USUALLY GET PAID?" — Numeric (1.0–99.9) — GO TO EMPPRE-J1.Q11A

34. EMPPRE-J1.Q11A: "AT THIS JOB, WHAT WAS [respondent]'S WAGE OR SALARY BEFORE TAXES AND DEDUCTIONS? (As of January of this year or when they last worked for this employer in [reference year])." — Numeric (0.01–999999.99) — GO TO EMPPRE-J1.Q11B

35. EMPPRE-J1.Q11B: "Interviewer: Select the appropriate category for reported wage or salary" — Single select {1: "Hourly", 2: "Weekly", 3: "Every two weeks/twice a month", 4: "Monthly", 5: "Yearly", 6: "Other (specify)"} — Other (specify) → EMPPRE-J1.Q12; Otherwise → EMPPRE-J1.Q13

36. EMPPRE-J1.Q12: "WHAT WERE [respondent]'S TOTAL EARNINGS FROM THIS JOB IN [reference year]?" — Numeric (0.01–999999.99) — GO TO EMPPRE-J1.Q13

37. EMPPRE-J1.Q13: "DID [respondent] RECEIVE ANY COMMISSIONS, TIPS, BONUSES OR PAID OVERTIME FROM THIS JOB IN [reference year]?" — Yes/No — Yes → EMPPRE-J1.Q14; No/DK/R → EMPPRE-J2.Q1

38. EMPPRE-J1.Q14: "WERE THESE COMMISSIONS, TIPS, BONUSES OR PAID OVERTIME INCLUDED IN THE AMOUNT JUST REPORTED?" — Yes/No — Yes/DK/R → EMPPRE-J2.Q1; No → EMPPRE-J1.Q15

39. EMPPRE-J1.Q15: "WHAT WERE [respondent]'S TOTAL EARNINGS IN [reference year] FROM THESE COMMISSIONS, TIPS, BONUSES, OR PAID OVERTIME?" — Numeric (0.01–999999.99) — GO TO EMPPRE-N12

#### J2 — 2nd Employer Sub-section

40. EMPPRE-J2.Q1: "DID [respondent] HAVE MORE THAN ONE JOB OR BUSINESS IN JANUARY OF THIS YEAR?" — Yes/No — Yes → EMPPRE-J2.Q2; No/DK/R → EMPPRE-N12

41. EMPPRE-J2.Q2: "I WOULD LIKE TO ASK A FEW QUESTIONS ABOUT [respondent]'S OTHER JOB OR BUSINESS IN JANUARY OF THIS YEAR. FOR WHOM DID [respondent] WORK? (name of business, government department, or agency, or person)" — Text — GO TO EMPPRE-J2.Q3

42. EMPPRE-J2.Q3: "WHEN DID [respondent] FIRST START WORKING FOR THIS EMPLOYER?" — Date — Hard range: Min = [current year] - [age] - 10, Max = [current year] — GO TO EMPPRE-J2.Q4

43. EMPPRE-J2.Q4: "WHAT KIND OF BUSINESS, INDUSTRY OR SERVICE WAS THIS? (e.g., federal government, canning industry, forestry services)" — Text — GO TO EMPPRE-J2.Q5

44. EMPPRE-J2.Q5: "WHAT KIND OF WORK WAS [respondent] DOING? (e.g., office clerk, factory worker, forestry technician)" — Text — GO TO EMPPRE-J2.Q6

45. EMPPRE-J2.Q6: "WHAT WERE [respondent]'S MOST IMPORTANT ACTIVITIES OR DUTIES? (e.g., filing documents, drying vegetables, forest examiner)" — Text — GO TO EMPPRE-J2.Q7

46. EMPPRE-J2.Q7: "IN THIS JOB, WAS [respondent] A PAID WORKER, SELF-EMPLOYED OR AN UNPAID FAMILY WORKER?" — Single select {1: "Paid worker", 2: "Unpaid family worker", 3: "Self-employed Incorporated - With paid help", 4: "Self-employed Incorporated - No paid help", 5: "Self-employed Unincorporated - With paid help", 6: "Self-employed Unincorporated - No paid help"} — Paid worker or DK/R → EMPPRE-J2.Q8A; Otherwise → EMPPRE-N12

47. EMPPRE-J2.Q8A: "IN WHICH MONTHS OF [reference year] DID [respondent] WORK AT THIS JOB?" — Single select {1: "All months", 2: "Started in [current year]", 3: "Specify months", 4: "Last worked before [reference year]"} — All months/DK/R → EMPPRE-J2.Q9; Started in [current year] → EMPPRE-N12; Specify months → EMPPRE-J2.Q8B; Last worked before [reference year] → EMPPRE-J2.Q8B

48. EMPPRE-J2.Q8B: "Interviewer: Specify months [respondent] worked in [reference year]?" — Multi select {1: "January", 2: "February", 3: "March", 4: "April", 5: "May", 6: "June", 7: "July", 8: "August", 9: "September", 10: "October", 11: "November", 12: "December"} — GO TO EMPPRE-J2.Q9

49. EMPPRE-J2.Q9: "AT THIS JOB, DID [respondent] USUALLY WORK EVERY WEEK OF THE MONTH?" — Yes/No — Yes/DK/R → EMPPRE-J2.Q11; No → EMPPRE-J2.Q10

50. EMPPRE-J2.Q10: "HOW MANY WEEKS DID [respondent] USUALLY WORK EACH MONTH?" — Numeric (1–3) — GO TO EMPPRE-J2.Q11

51. EMPPRE-J2.Q11: "HOW MANY HOURS PER WEEK DID [respondent] USUALLY GET PAID?" — Numeric (1.0–99.9) — GO TO EMPPRE-J2.Q12A

52. EMPPRE-J2.Q12A: "AT THIS JOB, WHAT WAS [respondent]'S WAGE OR SALARY BEFORE TAXES AND DEDUCTIONS?" — Numeric (0.01–999999.99) — GO TO EMPPRE-J2.Q12B

53. EMPPRE-J2.Q12B: "Interviewer: Select the appropriate category for reported wage or salary." — Single select {1: "Hourly", 2: "Weekly", 3: "Every two weeks/twice a month", 4: "Monthly", 5: "Yearly", 6: "Other (specify)"} — Other (specify) → EMPPRE-J2.Q13; Otherwise → EMPPRE-J2.Q14

54. EMPPRE-J2.Q13: "WHAT WERE [respondent]'S TOTAL EARNINGS FROM THIS JOB IN [reference year]?" — Numeric (0.01–999999.99) — GO TO EMPPRE-J2.Q14

55. EMPPRE-J2.Q14: "DID [respondent] RECEIVE ANY COMMISSIONS, TIPS, BONUSES OR PAID OVERTIME FROM THIS JOB IN [reference year]?" — Yes/No — Yes → EMPPRE-J2.Q15; No/DK/R → EMPPRE-N12

56. EMPPRE-J2.Q15: "WERE THESE COMMISSIONS, TIPS, BONUSES OR PAID OVERTIME INCLUDED IN THE AMOUNT JUST REPORTED?" — Yes/No — Yes/DK/R → EMPPRE-N12; No → EMPPRE-J2.Q16

57. EMPPRE-J2.Q16: "WHAT WERE [respondent]'S TOTAL EARNINGS IN [reference year] FROM THESE COMMISSIONS, TIPS, BONUSES, OR PAID OVERTIME?" — Numeric (0.01–999999.99) — GO TO EMPPRE-N12

### EXPRE - Work Experience — 17 items

58. EXPRE-N1: "Internal logic: [age] is greater than 69 years?" — Filter — Yes → DEMPRE-Q1A; Otherwise → EXPRE-Q1A

59. EXPRE-Q1A: "THE NEXT FEW QUESTIONS ARE ABOUT [respondent]'S WORK EXPERIENCE, THINKING BACK TO WHEN HE/SHE FIRST STARTED WORKING AT A JOB OR BUSINESS. DID [respondent] EVER WORK FULL-TIME? (Exclude summer jobs while in school)" — Single select {1: "Yes", 2: "No, never worked full-time", 3: "No, only worked full-time at summer jobs while in school"} — Yes → EXPRE-Q1B; Otherwise/DK/R → DEMPRE-Q1A

60. EXPRE-Q1B: "HOW MANY YEARS AGO DID [respondent] FIRST START WORKING FULL-TIME? (Exclude summer jobs while in school) Interviewer: Enter 00 if less than one year" — Numeric (0–[age]-10) — DK/R or 0 → DEMPRE-Q1A; 1 → EXPRE-Q3; Otherwise → EXPRE-Q2A

61. EXPRE-Q2A: "IN THOSE [response given in EXPRE-Q1B] YEARS, WERE THERE ANY YEARS WHEN [respondent] DID NOT WORK AT A JOB OR BUSINESS?" — Yes/No — Yes → EXPRE-Q2B; No/DK/R → EXPRE-Q3

62. EXPRE-Q2B: "HOW MANY YEARS DID [respondent] NOT WORK AT A JOB OR BUSINESS?" — Numeric (1–[EXPRE-Q1B]) — GO TO EXPRE-Q5A

63. EXPRE-Q3: "IN THOSE [response given in EXPRE-Q1B] YEARS, DID [respondent] WORK AT LEAST 6 MONTHS EACH AND EVERY YEAR?" — Yes/No — Yes/DK/R → EXPRE-Q4A; No → EXPRE-Q5A

64. EXPRE-Q4A: "HOW MANY YEARS DID HE/SHE WORK ONLY FULL-TIME? (by full-time I mean 30 or more hours per week) Interviewer: If none enter 00" — Numeric (0–[EXPRE-Q1B]) — GO TO EXPRE-Q4B

65. EXPRE-Q4B: "HOW MANY YEARS DID HE/SHE WORK ONLY PART-TIME? Interviewer: If none enter 00" — Numeric (0–[EXPRE-Q1B]) — GO TO EXPRE-Q4C

66. EXPRE-Q4C: "HOW MANY YEARS DID HE/SHE ONLY WORK SOME OF EACH (full-time and part-time)? Interviewer: If none enter 00" — Numeric (0–[EXPRE-Q1B]) — GO TO EXPRE-N4

67. EXPRE-N4: "Internal logic: Sum of Q4A + Q4B + Q4C = EXPRE-Q1B?" — Filter — Yes → DEMPRE-Q1A; Otherwise → EXPRE-Q4D

68. EXPRE-Q4D: "Interviewer: [respondent] has worked full-time for [answer in EXPRE-Q4A] years, part-time for [answer in EXPRE-Q4B] years, and some of each for [answer in EXPRE-Q4C] years. Conflict with when started working full-time [answer in EXPRE-Q1B] years ago. If incorrect go back to previous questions and make necessary changes. Otherwise press <Enter> to continue." — Read (constraint) — GO TO DEMPRE-Q1A

69. EXPRE-Q5A: "SINCE [respondent] FIRST STARTED WORKING, HOW MANY YEARS DID HE/SHE WORK AT LEAST 6 MONTHS OF THE YEAR? Interviewer: If none enter 00" — Numeric (0–[EXPRE-Q1B] minus [EXPRE-Q2B]; if Q2B not answered use Q1B as maximum) — 0/DK/R → DEMPRE-Q1A; Otherwise → EXPRE-Q6A

70. EXPRE-Q6A: "IN THOSE [response given in EXPRE-Q5A] YEARS, HOW MANY DID HE/SHE WORK ONLY FULL-TIME? (by full-time I mean 30 or more hours per week) Interviewer: If none enter 00" — Numeric (0–[EXPRE-Q5A]) — GO TO EXPRE-Q6B

71. EXPRE-Q6B: "IN THOSE [response given in EXPRE-Q5A] YEARS, HOW MANY DID HE/SHE WORK ONLY PART-TIME? Interviewer: If none enter 00" — Numeric (0–[EXPRE-Q5A]) — GO TO EXPRE-Q6C

72. EXPRE-Q6C: "IN THOSE [response given in EXPRE-Q5A] YEARS, HOW MANY DID HE/SHE ONLY WORK SOME OF EACH? (full-time and part-time) Interviewer: If none enter 00" — Numeric (0–[EXPRE-Q5A]) — GO TO EXPRE-N6

73. EXPRE-N6: "Internal logic: Sum of Q6A + Q6B + Q6C = EXPRE-Q5A?" — Filter — Yes → DEMPRE-Q1A; Otherwise → EXPRE-Q6D

74. EXPRE-Q6D: "Interviewer: [respondent] is shown working full-time for [answer in EXPRE-Q6A] years, part-time for [answer in EXPRE-Q6B] years, and some of each for [answer in EXPRE-Q6C] years. Conflicts with # of years they worked more than six months [answer in EXPRE-Q5A]. If incorrect go back to previous questions and make necessary changes. Otherwise press <Enter> to continue." — Read (constraint) — GO TO DEMPRE-Q1A

### DEMPRE - Demographics and Family Background — 46 items

75. DEMPRE-Q1A: "THE NEXT FEW QUESTIONS ARE ABOUT [respondent]'S FAMILY BACKGROUND AND ARE BASED ON THE DATE OF BIRTH AND MARITAL STATUS REPORTED EARLIER IN THE INTERVIEW." — Read — GO TO DEMPRE-N1

76. DEMPRE-N1: "Internal logic: Marital status = married?" — Filter — Yes → DEMPRE-Q2B; No → DEMPRE-N1A

77. DEMPRE-N1A: "Internal logic: Marital status = common-in-law?" — Filter — Yes → DEMPRE-Q5; No → DEMPRE-N1B

78. DEMPRE-N1B: "Internal logic: Marital status = separated?" — Filter — Yes → DEMPRE-Q1; No → DEMPRE-N1C

79. DEMPRE-N1C: "Internal logic: Marital status = divorced?" — Filter — Yes → DEMPRE-Q1; No → DEMPRE-N1D

80. DEMPRE-N1D: "Internal logic: Marital status = widowed?" — Filter — Yes → DEMPRE-Q7; No → DEMPRE-N1E

81. DEMPRE-N1E: "Internal logic: Marital status = single (never married)?" — Filter — Yes → DEMPRE-N11A; No → DEMPRE-N1F

82. DEMPRE-N1F: "Internal logic: Marital status = DK/R?" — Filter — Yes → DEMPRE-N11A

83. DEMPRE-Q1: "WHAT WAS THE DATE OF [respondent]'S SEPARATION? (Not the date of divorce)" — Date — Hard range: Min = [current year] - [age] - 14, Max = [current year] — GO TO DEMPRE-Q2

84. DEMPRE-Q2: "WHAT WAS THE DATE OF THIS MARRIAGE?" — Date — Hard range: Min = [current year] - [age] - 14, Max = [current year] — GO TO COMPARE-Q2

85. COMPARE-Q2: "Internal logic: Date of this marriage (DEMPRE-Q2) is before date of separation (DEMPRE-Q1)?" — Filter — No (inconsistent) → DEMPRE-Q2A; Otherwise (consistent) → DEMPRE-Q3

86. DEMPRE-Q2A: "Interviewer: Date of marriage [response in DEMPRE-Q2] is after date of separation [response in DEMPRE-Q1]. If information is incorrect go to previous questions to correct inconsistencies. Otherwise press <Enter> to continue." — Read (constraint) — GO TO DEMPRE-Q3

87. DEMPRE-Q2B: "WHAT WAS THE DATE OF [respondent]'S MARRIAGE?" — Date — Hard range: Min = [current year] - [age] - 14, Max = [current year] — GO TO DEMPRE-Q3

88. DEMPRE-Q3: "WAS THIS [respondent]'S FIRST MARRIAGE?" — Yes/No — Yes/DK/R → DEMPRE-N11A; No → DEMPRE-Q4

89. DEMPRE-Q4: "WHAT WAS THE DATE OF [respondent]'S FIRST MARRIAGE?" — Date — Hard range: Min = [current year] - [age] - 14, Max = [current year] — GO TO COMPARE-Q4

90. COMPARE-Q4: "Internal logic: Date of first marriage (DEMPRE-Q4) is before date of current marriage (DEMPRE-Q2/Q2B)?" — Filter — No (inconsistent) → DEMPRE-Q4A; Otherwise (consistent) → DEMPRE-N11A

91. DEMPRE-Q4A: "Interviewer: Date of marriage [response in DEMPRE-Q4] should be before date of current marriage [response in DEMPRE-Q2B]. If information is incorrect go to previous questions to correct inconsistencies. Otherwise press <Enter> to continue." — Read (constraint) — GO TO DEMPRE-N11A

92. DEMPRE-Q5: "WHEN DID [respondent] AND HIS/HER PARTNER BEGIN TO LIVE TOGETHER?" — Date — Hard range: Min = [current year] - [age] - 14, Max = [current year] — GO TO DEMPRE-Q6

93. DEMPRE-Q6: "HAS [respondent] EVER BEEN MARRIED?" — Yes/No — Yes → DEMPRE-Q8; No/DK/R → DEMPRE-N11A

94. DEMPRE-Q7: "WHEN WAS [respondent] WIDOWED?" — Date — Hard range: Min = [current year] - [age] - 14, Max = [current year] — GO TO DEMPRE-Q8

95. DEMPRE-Q8: "WAS THIS [respondent]'S FIRST MARRIAGE?" — Yes/No — Yes/DK/R → DEMPRE-Q9; No → DEMPRE-Q10

96. DEMPRE-Q9: "WHAT WAS THE DATE OF [respondent]'S MARRIAGE?" — Date — Hard range: Min = [current year] - [age] - 14, Max = [current year] — GO TO COMPARE9A

97. COMPARE9A: "Internal logic: Date of marriage (DEMPRE-Q9) is before date widowed (DEMPRE-Q7)?" — Filter — No (inconsistent) → DEMPRE-Q9A; Otherwise (consistent) → COMPARE9B

98. DEMPRE-Q9A: "Interviewer: Date of previous marriage [answer in DEMPRE-Q9] should be before date widowed [answer in DEMPRE-Q7]. If information is incorrect go to previous questions to correct inconsistencies. Otherwise press <Enter> to continue." — Read (constraint) — GO TO COMPARE9B

99. COMPARE9B: "Internal logic: Date of marriage (DEMPRE-Q9) is before date living together (DEMPRE-Q5)?" — Filter — No (inconsistent) → DEMPRE-Q9B; Otherwise (consistent) → DEMPRE-N11A

100. DEMPRE-Q9B: "Interviewer: Date of previous marriage [answer in DEMPRE-Q9] should be before date started living together [answer in DEMPRE-Q5]. If information is incorrect go to previous questions to correct inconsistencies. Otherwise press <Enter> to continue." — Read (constraint) — GO TO DEMPRE-N11A

101. DEMPRE-Q10: "WHAT WAS THE DATE OF [respondent]'S FIRST MARRIAGE?" — Date — Hard range: Min = [current year] - [age] - 14, Max = [current year] — GO TO COMPARE10A

102. COMPARE10A: "Internal logic: Date of first marriage (DEMPRE-Q10) is before date started living together (DEMPRE-Q5)?" — Filter — No (inconsistent) → DEMPRE-Q10A; Otherwise (consistent) → COMPARE10B

103. DEMPRE-Q10A: "Interviewer: Date of first marriage [answer in DEMPRE-Q10] should be before date started living together [answer in DEMPRE-Q5]. If information is incorrect go to previous questions to correct inconsistencies. Otherwise press <Enter> to continue." — Read (constraint) — GO TO COMPARE10B

104. COMPARE10B: "Internal logic: Date of first marriage (DEMPRE-Q10) is before date widowed (DEMPRE-Q7)?" — Filter — No (inconsistent) → DEMPRE-Q10B; Otherwise (consistent) → DEMPRE-N11A

105. DEMPRE-Q10B: "Interviewer: Date of first marriage [answer in DEMPRE-Q10] should be before date widowed [answer in DEMPRE-Q7]. If information is incorrect go to previous questions to correct inconsistencies. Otherwise press <Enter> to continue." — Read (constraint) — GO TO DEMPRE-N11A

106. DEMPRE-N11A: "Internal logic: Respondent is female 18 years of age and over?" — Filter — Yes → DEMPRE-Q11; Otherwise → DEMPRE-Q16

107. DEMPRE-Q11: "HAS [respondent] HAD ANY CHILDREN?" — Yes/No — Yes → DEMPRE-Q12; No → DEMPRE-Q14; DK/R → DEMPRE-Q16

108. DEMPRE-Q12: "HOW MANY CHILDREN WERE EVER BORN TO [respondent]? Interviewer: Enter 00 if none" — Numeric (0–20) — 0/DK/R → DEMPRE-Q14; Otherwise → DEMPRE-Q13

109. DEMPRE-Q13: "IN WHAT YEAR DID [respondent] GIVE BIRTH TO HER FIRST CHILD?" — Date (year only) — Hard range: Min = [current year] - [age] - 14, Max = [current year] — GO TO DEMPRE-Q14

110. DEMPRE-Q14: "(Other than children [respondent] has given birth to) HAS [respondent] ADOPTED OR RAISED ANY CHILDREN?" — Yes/No — Yes → INPATH-Q12; No/DK/R → DEMPRE-Q16

111. INPATH-Q12: "Internal logic: DEMPRE-Q11 = yes AND DEMPRE-Q14 = no AND DEMPRE-Q12 = 0?" — Filter — Yes (inconsistent) → DEMPRE-Q14A; Otherwise → DEMPRE-Q15

112. DEMPRE-Q14A: "Interviewer: In previous questions (DEMPRE-Q11 and Q12) respondent stated that she had children, but none were born to her, therefore she should have raised or adopted children (DEMPRE-Q14). If incorrect go to previous questions to correct inconsistencies. Otherwise press <Enter> to continue." — Read (constraint) — GO TO DEMPRE-Q15

113. DEMPRE-Q15: "HOW MANY (other) CHILDREN HAS [respondent] ADOPTED OR RAISED?" — Numeric (1–20) — GO TO DEMPRE-Q16

114. DEMPRE-Q16: "WHAT IS THE LANGUAGE THAT [respondent] FIRST LEARNED AT HOME IN CHILDHOOD AND STILL UNDERSTANDS?" — Single select {1: "English", 2: "French", 3: "Other (SPECIFY)"} — GO TO DEMPRE-Q17

115. DEMPRE-Q17: "IN WHAT COUNTRY WAS [respondent] BORN?" — Single select {1: "Canada", 2: "United Kingdom", 3: "Italy", 4: "U.S.A.", 5: "Germany", 6: "Poland", 7: "Other (SPECIFY)"} — Canada → DEMPRE-Q19; Otherwise → DEMPRE-Q18

116. DEMPRE-Q18: "DID [respondent] IMMIGRATE TO CANADA?" — Single select {1: "Yes", 2: "No (never immigrated - Canadian citizen by birth)"} — Yes → DEMPRE-Q18B; No/DK/R → DEMPRE-Q19

117. DEMPRE-Q18B: "IN WHAT YEAR WAS THAT?" — Date (year only) — Hard range: Min = [current year] - [age], Max = [current year] — GO TO DEMPRE-Q19

118. DEMPRE-Q19: "IS [respondent] A REGISTERED INDIAN AS DEFINED BY THE INDIAN ACT OF CANADA?" — Single select {1: "Yes, Registered Indian", 2: "No"} — GO TO DEMPRE-Q20

119. DEMPRE-Q20: "CANADIANS COME FROM MANY ETHNIC, CULTURAL AND RACIAL BACKGROUNDS. FOR EXAMPLE, ENGLISH, FRENCH, NORTH AMERICAN INDIAN, CHINESE, BLACK, FILIPINO OR LEBANESE. WHAT IS [respondent]'S BACKGROUND? Interviewer: if indian, probe for North American or East. Mark all that apply." — Multi select {1: "English", 2: "French", 3: "German", 4: "Scottish", 5: "Italian", 6: "Irish", 7: "Ukrainian", 8: "Chinese", 9: "Canadian (probe for any other background)", 10: "Dutch (Netherlands)", 11: "Jewish", 12: "Polish", 13: "Black", 14: "Metis", 15: "Inuit/Eskimo", 16: "North American Indian", 17: "East Indian", 18: "Other (specify)"} — "Other" selected → DEMPRE-Q20A; Otherwise → EDUPRE-Q1

120. DEMPRE-Q20A: "Interviewer: Enter other ethnic background not already given in previous question." — Text — GO TO EDUPRE-Q1

### EDUPRE - Educational Attainment — 30 items

121. EDUPRE-Q1: "HOW MANY YEARS OF ELEMENTARY AND HIGH SCHOOL DID [respondent] COMPLETE?" — Numeric (0–15) — GO TO VERIFY-Q1

122. VERIFY-Q1: "Internal logic: Years of schooling (EDUPRE-Q1) is greater than [age] minus 5?" — Filter — No (age inconsistency) → EDUPRE-Q1A; Otherwise: if EDUPRE-Q1 = 0 → EDUPRE-Q17; else → EDUPRE-Q2

123. EDUPRE-Q1A: "Interviewer: Years of education does not correspond with [respondent]'s age. Verify that this information is correct. If incorrect go back to previous question (EDUPRE-Q1) and make the necessary changes. Otherwise press <Enter> to continue." — Read (constraint) — GO TO EDUPRE-Q2

124. EDUPRE-Q2: "IN WHICH PROVINCE OR TERRITORY DID [respondent] GET MOST OF HIS/HER ELEMENTARY AND HIGH SCHOOL EDUCATION?" — Single select {1: "Newfoundland", 2: "Prince Edward Island", 3: "Nova Scotia", 4: "New Brunswick", 5: "Quebec", 6: "Ontario", 7: "Manitoba", 8: "Saskatchewan", 9: "Alberta", 10: "British Columbia", 11: "Yukon", 12: "Northwest Territories", 13: "Outside Canada"} — GO TO EVAL-Q1

125. EVAL-Q1: "Internal logic: EDUPRE-Q1 = 1 to 9?" — Filter — Yes → EDUPRE-Q4; Otherwise (10+) → EDUPRE-Q3

126. EDUPRE-Q3: "DID [respondent] COMPLETE HIGH SCHOOL?" — Yes/No — GO TO EDUPRE-Q4

127. EDUPRE-Q4: "EXCLUDING UNIVERSITY, HAS [respondent] EVER BEEN ENROLLED IN ANY OTHER KIND OF SCHOOL, FOR EXAMPLE, A COMMUNITY COLLEGE, BUSINESS SCHOOL, TRADE OR VOCATIONAL SCHOOL, OR CEGEP?" — Yes/No — Yes/DK/R → EDUPRE-Q5; No → EDUPRE-Q12

128. EDUPRE-Q5: "HAS [respondent] RECEIVED ANY CERTIFICATES OR DIPLOMAS AS A RESULT OF THIS EDUCATION?" — Yes/No — Yes/DK/R → EDUPRE-Q6; No → EDUPRE-Q11

129. EDUPRE-Q6: "THINKING OF THE MOST RECENT CERTIFICATE OR DIPLOMA (EXCLUDING UNIVERSITY) COULD YOU TELL ME WHAT TYPE OF SCHOOL OR COLLEGE [respondent] ATTENDED? WAS IT A..." — Single select {1: "COMMUNITY COLLEGE OR INSTITUTE OF APPLIED ARTS AND TECHNOLOGY", 2: "BUSINESS OR COMMERCIAL SCHOOL", 3: "TRADE OR VOCATIONAL SCHOOL", 4: "CEGEP", 5: "SOME OTHER TYPE (Specify)"} — GO TO EDUPRE-Q7

130. EDUPRE-Q7: "HOW LONG DID IT TAKE [respondent] TO COMPLETE THIS PROGRAM?" — Single select {1: "Answer given in months", 2: "Answer given in years"} — Months → EDUPRE-Q7A; Years → EDUPRE-Q7B; DK/R → EDUPRE-Q8

131. EDUPRE-Q7A: "Interviewer: Enter # of months it took [respondent] to complete this program." — Numeric (1–99) — GO TO EDUPRE-Q8

132. EDUPRE-Q7B: "Interviewer: Enter # of years it took [respondent] to complete this program." — Numeric (1–9) — GO TO EDUPRE-Q8

133. EDUPRE-Q8: "WAS THIS FULL-TIME, PART-TIME OR SOME OF EACH?" — Single select {1: "Full-time", 2: "Part-time", 3: "Some of each"} — GO TO EDUPRE-Q9

134. EDUPRE-Q9: "IN WHAT YEAR DID [respondent] RECEIVE HIS/HER CERTIFICATE OR DIPLOMA?" — Numeric — Hard range: Min = [current year] - [age] - 14, Max = [current year] — GO TO VERIFY-Q9

135. VERIFY-Q9: "Internal logic: Year received diploma is between current year minus age minus 14 and current year minus age minus 20? (age at graduation implausible)" — Filter — Yes → EDUPRE-Q9A; Otherwise → EDUPRE-Q10

136. EDUPRE-Q9A: "Interviewer: Year respondent received certificate or diploma indicates he/she was [calculated age] years old when they graduated. If year received certificate/diploma [answer in EDUPRE-Q9] is incorrect, go back to previous question (EDUPRE-Q9) and make necessary changes. Otherwise press <Enter> to continue." — Read (constraint) — GO TO EDUPRE-Q10

137. EDUPRE-Q10: "WHAT WAS THE MAJOR SUBJECT OR FIELD OF STUDY?" — Text — GO TO EDUPRE-Q11

138. EDUPRE-Q11: "IN TOTAL, HOW MANY YEARS OF SCHOOLING DID [respondent] COMPLETE AT A COMMUNITY COLLEGE, TECHNICAL INSTITUTE, TRADE OR VOCATIONAL SCHOOL, OR CEGEP? Interviewer: Enter 00 if less than one year" — Numeric (0–20) — GO TO VERIFY-Q11

139. VERIFY-Q11: "Internal logic: Years of schooling (EDUPRE-Q11) is greater than [age] minus 14?" — Filter — Yes → EDUPRE-Q11A; Otherwise → EDUPRE-Q12

140. EDUPRE-Q11A: "Interviewer: Years of schooling completed in a community college etc. [EDUPRE-Q11] does not correspond to [respondent]'s age [age]. Verify that this is correct. If incorrect, go back to previous question (EDUPRE-Q11) and make necessary changes. Otherwise press <Enter> to continue." — Read (constraint) — GO TO EDUPRE-Q12

141. EDUPRE-Q12: "HAS [respondent] EVER BEEN ENROLLED IN A UNIVERSITY?" — Yes/No — Yes/DK/R → EDUPRE-Q13; No → EDUPRE-Q17

142. EDUPRE-Q13: "HOW MANY YEARS OF UNIVERSITY HAS [respondent] COMPLETED? Interviewer: Enter 00 if attended university but didn't complete the year." — Numeric (0–20) — GO TO VERIFY-Q13

143. VERIFY-Q13: "Internal logic: Years of university is greater than [age] minus 14?" — Filter — Yes → EDUPRE-Q13A; Otherwise → EDUPRE-Q14

144. EDUPRE-Q13A: "Interviewer: Years of university [EDUPRE-Q13] does not correspond to [respondent]'s age [age]. Verify that this is correct. If incorrect, go back to previous question (EDUPRE-Q13) and make necessary changes. Otherwise press <Enter> to continue." — Read (constraint) — GO TO EDUPRE-Q14

145. EDUPRE-Q14: "WHAT DEGREES, CERTIFICATES OR DIPLOMAS HAS [respondent] RECEIVED FROM A UNIVERSITY?" — Single select {1: "None", 2: "Specify Degrees"} — None → EDUPRE-Q17; Specify Degrees → EDUPRE-Q14A; DK/R → EDUPRE-Q15

146. EDUPRE-Q14A: "Interviewer: Specify degrees, certificates or diplomas [respondent] has received from a university. Mark all that apply." — Multi select {1: "University certificate/diploma below Bachelor level", 2: "Bachelor's degree(s)", 3: "University certificate/diploma above Bachelor level", 4: "Master's degree(s)", 5: "Degree in medicine, dentistry, veterinary medicine or optometry", 6: "Doctorate (PhD)"} — GO TO EDUPRE-Q15

147. EDUPRE-Q15: "WHAT YEAR DID [respondent] RECEIVE HIS/HER [highest response category given in EDUPRE-Q14A]?" — Numeric — Hard range: Min = [current year] - [age] - 18, Max = [current year] — GO TO EDUPRE-Q16

148. EDUPRE-Q16: "WHAT WAS THE MAJOR FIELD OF STUDY?" — Text — GO TO EDUPRE-Q17

149. EDUPRE-Q17: "WHAT WAS THE HIGHEST LEVEL OF EDUCATION COMPLETED BY [respondent]'S MOTHER? WAS IT..." — Single select {1: "ELEMENTARY SCHOOL (includes no schooling)", 2: "SOME HIGH SCHOOL", 3: "COMPLETED HIGH SCHOOL", 4: "TRADE/VOCATIONAL SCHOOL", 5: "POST-SECONDARY CERTIFICATE OR DIPLOMA", 6: "UNIVERSITY DEGREE"} — GO TO EDUPRE-Q18

150. EDUPRE-Q18: "WHAT WAS THE HIGHEST LEVEL OF EDUCATION COMPLETED BY [respondent]'S FATHER? WAS IT..." — Single select {1: "ELEMENTARY SCHOOL (includes no schooling)", 2: "SOME HIGH SCHOOL", 3: "COMPLETED HIGH SCHOOL", 4: "TRADE/VOCATIONAL SCHOOL", 5: "POST-SECONDARY CERTIFICATE OR DIPLOMA", 6: "UNIVERSITY DEGREE"} — End of questionnaire
