# BRFSS 2023 - Question Inventory

## Verification Status

| Section | Source Qs | Inventory Qs | Missing | Notes |
|---------|----------|-------------|---------|-------|
| Landline Introduction (LL01–LL10) | 10 | 10 | 0 | All 10 items present |
| Cell Phone Introduction (CP01–CP12) | 12 | 12 | 0 | All 12 items present |
| Core Section 1: Health Status (CHS) | 1 | 1 | 0 | |
| Core Section 2: Healthy Days (CHD) | 3 | 3 | 0 | +1 filter node (CHD.FILTER) |
| Core Section 3: Health Care Access (CHCA) | 4 | 4 | 0 | |
| Core Section 4: Exercise (CEXP) | 8 | 8 | 0 | |
| Core Section 5: Hypertension Awareness (CHYPA) | 2 | 2 | 0 | |
| Core Section 6: Cholesterol Awareness (CCHLA) | 3 | 3 | 0 | |
| Core Section 7: Chronic Health Conditions (CCHC) | 13 | 13 | 0 | |
| Core Section 8: Demographics (CDEM) | 18 | 18 | 0 | +2 filter nodes (CDEM.FILTER1, CDEM.FILTER2) |
| Core Section 9: Disability (CDIS) | 6 | 6 | 0 | |
| Core Section 10: Falls (CFAL) | 2 | 2 | 0 | +1 filter node (CFAL.FILTER) |
| Core Section 11: Tobacco Use (CTOB) | 4 | 4 | 0 | |
| Core Section 12: Alcohol Consumption (CALC) | 4 | 4 | 0 | +1 prologue read node (CALC.PROLOGUE) |
| Core Section 13: Immunization (CIMM) | 4 | 4 | 0 | |
| Core Section 14: H.I.V./AIDS (CHIV) | 2 | 2 | 0 | |
| Core Section 15: Seat Belt / Drinking & Driving (CSBD) | 2 | 2 | 0 | +1 filter node (CSBD.FILTER) |
| Emerging Core: Long-term COVID Effects (COVID) | 3 | 3 | 0 | |
| Closing Statement | 0 | 1 | 0 | CLOSE.01 is inventory-assigned ID for the closing read |
| Module 1: Prediabetes (MPDIAB) | 2 | 2 | 0 | |
| Module 2: Diabetes (MDIAB) | 7 | 7 | 0 | |
| Module 3: Arthritis (MARTH) | 5 | 5 | 0 | |
| Module 4: Lung Cancer Screening (MLCS) | 6 | 6 | 0 | +1 filter node (MLCS.FILTER) |
| Module 5: Breast & Cervical Cancer Screening (MBCCS) | 7 | 7 | 0 | +1 filter node (MBCCS.FILTER) |
| Module 6: Prostate Cancer Screening (MPCS) | 5 | 5 | 0 | |
| Module 7: Colorectal Cancer Screening (MCCS) | 13 | 13 | 0 | |
| Module 8: Cancer Survivorship: Type (MTOC) | 3 | 3 | 0 | |
| Module 9: Cancer Survivorship: Treatment (MCOT) | 8 | 8 | 0 | |
| Module 10: Cancer Survivorship: Pain (MCPM) | 2 | 2 | 0 | |
| Module 11: Indoor Tanning (MNTAN) | 1 | 1 | 0 | |
| Module 12: Excess Sun Exposure (MSUN) | 4 | 4 | 0 | |
| Module 13: Cognitive Decline (MCOG) | 5 | 5 | 0 | |
| Module 14: Caregiver (MCARE) | 9 | 9 | 0 | |
| Module 15: Tobacco Cessation (MTC) | 2 | 2 | 0 | +2 filter nodes (MTC.FILTER1, MTC.FILTER2) |
| Module 16: Other Tobacco Use (MOTU) | 3 | 3 | 0 | +2 filter nodes (MOTU.FILTER1, MOTU.FILTER2) |
| Module 17: Firearm Safety (MFS) | 3 | 3 | 0 | |
| Module 18: Industry and Occupation (MIO) | 2 | 2 | 0 | |
| Module 19: Heart Attack and Stroke (MHAS) | 13 | 13 | 0 | |
| Module 20: Aspirin for CVD Prevention (MASPRN) | 1 | 1 | 0 | |
| Module 21: Sex at Birth (MSAB) | 1 | 1 | 0 | |
| Module 22: Sexual Orientation & Gender Identity (MSOGI) | 3 | 3 | 0 | +1 filter node (MSOGI.FILTER1) |
| Module 23: Marijuana Use (MMU) | 7 | 7 | 0 | |
| Module 24: Adverse Childhood Experiences (MACE) | 13 | 13 | 0 | |
| Module 25: Place of Flu Vaccination (MFP) | 1 | 1 | 0 | |
| Module 26: HPV Vaccination (MHPV) | 2 | 2 | 0 | |
| Module 27: Tetanus Diphtheria / Tdap (MTDAP) | 1 | 1 | 0 | |
| Module 28: COVID Vaccination (MCOV) | 3 | 3 | 0 | |
| Module 29: Social Determinants & Health Equity (MSDHE) | 10 | 10 | 0 | |
| Module 30: Reactions to Race (MRTR) | 6 | 6 | 0 | |
| Module 31: Random Child Selection (MRCS) | 6 | 6 | 0 | |
| Module 32: Childhood Asthma Prevalence (MCAP) | 2 | 2 | 0 | |
| Asthma Call-Back Permission Script (CB01) | 3 | 3 | 0 | |
| **TOTAL** | **261** | **261** | **0** | |

- **Coverage**: 52/52 sections verified, 261 question IDs + 12 filter nodes + 2 read nodes = 275 total inventory items (274 numbered + CALC.PROLOGUE)
- **Routing**: 274 GO TO annotations + 14 TERMINATE + 5 SKIP = 293 routing annotations captured; source has ~103 routing lines (inventory expands per response option)
- **Status**: READY FOR QML
- **Missing**: none. Note: `CP.06` appears once in source as a cross-reference typo (MSAB.01 skip logic note) — this is a formatting artifact for `CP06`, which is captured as item 16 in the inventory. `CLOSE.01` is an inventory-assigned identifier for the closing statement (source uses no ID for it).

## Document Overview
- **Title**: 2023 Behavioral Risk Factor Surveillance System (BRFSS) Questionnaire
- **Organization**: Centers for Disease Control and Prevention (CDC)
- **Pages**: 127+
- **Language**: English
- **Type**: CATI (Computer-Assisted Telephone Interview), dual-frame (landline + cell phone)
- **OMB Number**: 0920-1061

## Structure

The questionnaire has 5 major parts:
1. **Introduction** — Landline (LL01–LL10) and Cell Phone (CP01–CP12) screening
2. **Core Sections 1–15** — Health status, chronic conditions, demographics, behavioral risks
3. **Emerging Core** — Long-term COVID effects
4. **Optional Modules 1–32** — State-selected topical modules
5. **Asthma Call-Back** — Permission script for follow-up

Each optional module is independently selected by states. Modules are self-contained with their own entry filters.

## Question Inventory by Section

### Landline Introduction - 10 items

1. LL01: "Is this [PHONE NUMBER]?" — Yes/No — 1 (Yes) → GO TO LL02; 2 (No) → TERMINATE

2. LL02: "Is this a private residence?" — Yes/No — 1 (Yes) → GO TO LL04; 2 (No) → GO TO LL03; 3 (No, this is a business) → TERMINATE

3. LL03: "Do you live in college housing?" — Yes/No — 1 (Yes) → GO TO LL04; 2 (No) → TERMINATE

4. LL04: "Do you currently live in [STATE]?" — Yes/No — 1 (Yes) → GO TO LL05; 2 (No) → TERMINATE

5. LL05: "Is this a cell phone?" — Yes/No — 1 (Yes, it is a cell phone) → TERMINATE; 2 (Not a cell phone) → GO TO LL06

6. LL06: "Are you 18 years of age or older?" — Yes/No — 1 (Yes) → IF LL03=Yes GO TO LL09; OTHERWISE GO TO LL07; 2 (No) → IF LL03=Yes TERMINATE; OTHERWISE GO TO LL07

7. LL07: "Excluding adults living away from home, such as students away at college, how many members of your household, including yourself, are 18 years of age or older?" — Numeric — 1 → GO TO LL09; 2–6 or more → GO TO LL08

8. LL08: "The person in your household that I need to speak with is the adult with the most recent birthday. Are you the adult with the most recent birthday?" — Yes/No — 1 (Yes) → GO TO LL09; 2 (No) → ask for correct respondent, re-ask LL08

9. LL09: "Are you?" — Single select {1: "Male", 2: "Female", 3: "Unspecified or another gender identity"} — 1 (Male) → GO TO Section 1; 2 (Female) → GO TO Section 1; 3 → GO TO LL10; 7 (DK) → GO TO LL10; 9 (R) → GO TO LL10

10. LL10: "What was your sex at birth? Was it male or female?" — Single select {1: "Male", 2: "Female"} — 1 (Male) → GO TO Section 1; 2 (Female) → GO TO Section 1; 7 (DK) → TERMINATE; 9 (R) → TERMINATE

### Cell Phone Introduction - 12 items

11. CP01: "Is this a safe time to talk with you?" — Yes/No — 1 (Yes) → GO TO CP02; 2 (No) → TERMINATE (set appointment if possible)

12. CP02: "Is this [PHONE NUMBER]?" — Yes/No — 1 (Yes) → GO TO CP03; 2 (No) → TERMINATE

13. CP03: "Is this a cell phone?" — Yes/No — 1 (Yes) → GO TO CP04; 2 (No) → TERMINATE

14. CP04: "Are you 18 years of age or older?" — Yes/No — 1 (Yes) → GO TO CP05; 2 (No) → TERMINATE

15. CP05: "Are you?" — Single select {1: "Male", 2: "Female", 3: "Unspecified or another gender identity"} — 1 (Male) → GO TO CP07; 2 (Female) → GO TO CP07; 3 → GO TO CP06; 7 (DK) → GO TO CP06; 9 (R) → GO TO CP06

16. CP06: "What was your sex at birth? Was it male or female?" — Single select {1: "Male", 2: "Female"} — 1 (Male) → GO TO CP07; 2 (Female) → GO TO CP07; 7 (DK) → TERMINATE; 9 (R) → TERMINATE

17. CP07: "Do you live in a private residence?" — Yes/No — 1 (Yes) → GO TO CP09; 2 (No) → GO TO CP08

18. CP08: "Do you live in college housing?" — Yes/No — 1 (Yes) → GO TO CP09; 2 (No) → TERMINATE

19. CP09: "Do you currently live in [STATE]?" — Yes/No — 1 (Yes) → GO TO CP11; 2 (No) → GO TO CP10

20. CP10: "In what state do you currently live?" — Single select {1–56/66/72/78: "US states and territories"} — valid state → GO TO CP11; 77 (Live outside US) → TERMINATE; 99 (R) → TERMINATE

21. CP11: "Do you also have a landline telephone in your home that is used to make and receive calls?" — Single select {1: "Yes", 2: "No"} — all responses → GO TO CP12; 7 (DK) → GO TO CP12; 9 (R) → GO TO CP12

22. CP12: "How many members of your household, including yourself, are 18 years of age or older?" — Numeric — number entered → GO TO Section 1; IF CP08=Yes then adults automatically=1; 77 (DK) → GO TO Section 1; 99 (R) → GO TO Section 1

### Core Section 1: Health Status - 1 item

23. CHS.01: "Would you say that in general your health is—" — Single select {1: "Excellent", 2: "Very good", 3: "Good", 4: "Fair", 5: "Poor"} — GO TO next; 7 (DK) → GO TO next; 9 (R) → GO TO next

### Core Section 2: Healthy Days - 4 items

24. CHD.01: "Now thinking about your physical health, which includes physical illness and injury, for how many days during the past 30 days was your physical health not good?" — Numeric (01–30, 88=None) — GO TO CHD.02; 77 (DK) → GO TO CHD.02; 99 (R) → GO TO CHD.02

25. CHD.02: "Now thinking about your mental health, which includes stress, depression, and problems with emotions, for how many days during the past 30 days was your mental health not good?" — Numeric (01–30, 88=None) — GO TO filter; 77 (DK) → GO TO filter; 99 (R) → GO TO filter

26. CHD.FILTER: Filter — If CHD.01=88 AND CHD.02=88 → SKIP CHD.03, GO TO next section; otherwise → GO TO CHD.03

27. CHD.03: "During the past 30 days, for about how many days did poor physical or mental health keep you from doing your usual activities, such as self-care, work, or recreation?" — Numeric (01–30, 88=None) — GO TO next section; 77 (DK) → GO TO next section; 99 (R) → GO TO next section

### Core Section 3: Health Care Access - 4 items

28. CHCA.01: "What is the current source of your primary health insurance?" — Single select {01: "Employer/union plan", 02: "Private nongovernmental plan", 03: "Medicare", 04: "Medigap", 05: "Medicaid", 06: "CHIP", 07: "Military/TRICARE/VA/CHAMP-VA", 08: "Indian Health Service", 09: "State sponsored health plan", 10: "Other government program", 88: "No coverage of any type"} — GO TO next; 77 (DK) → GO TO next; 99 (R) → GO TO next

29. CHCA.02: "Do you have one person or a group of doctors that you think of as your personal health care provider?" — Single select {1: "Yes, only one", 2: "More than one", 3: "No"} — GO TO next; 7 (DK) → GO TO next; 9 (R) → GO TO next

30. CHCA.03: "Was there a time in the past 12 months when you needed to see a doctor but could not because you could not afford it?" — Yes/No — GO TO next; 7 (DK) → GO TO next; 9 (R) → GO TO next

31. CHCA.04: "About how long has it been since you last visited a doctor for a routine checkup?" — Single select {1: "Within past year", 2: "Within past 2 years", 3: "Within past 5 years", 4: "5 or more years ago", 8: "Never"} — GO TO next; 7 (DK) → GO TO next; 9 (R) → GO TO next

### Core Section 4: Exercise (Physical Activity) - 8 items

32. CEXP.01: "During the past month, other than your regular job, did you participate in any physical activities or exercises such as running, calisthenics, golf, gardening, or walking for exercise?" — Yes/No — 1 (Yes) → GO TO CEXP.02; 2 (No) → GO TO CEXP.08; 7 (DK) → GO TO CEXP.08; 9 (R) → GO TO CEXP.08

33. CEXP.02: "What type of physical activity or exercise did you spend the most time doing during the past month?" — Single select {code from Physical Activity Coding List} — GO TO CEXP.03; 77 (DK) → GO TO CEXP.08; 99 (R) → GO TO CEXP.08

34. CEXP.03: "How many times per week or per month did you take part in this activity during the past month?" — Numeric (1XX=per week, 2XX=per month) — GO TO CEXP.04; 777 (DK) → GO TO CEXP.04; 999 (R) → GO TO CEXP.04

35. CEXP.04: "And when you took part in this activity, for how many minutes or hours did you usually keep at it?" — Numeric (H:MM) — GO TO CEXP.05; 777 (DK) → GO TO CEXP.05; 999 (R) → GO TO CEXP.05

36. CEXP.05: "What other type of physical activity gave you the next most exercise during the past month?" — Single select {code from list, 88: "No other activity"} — valid activity → GO TO CEXP.06; 88 (No other) → GO TO CEXP.08; 77 (DK) → GO TO CEXP.08; 99 (R) → GO TO CEXP.08

37. CEXP.06: "How many times per week or per month did you take part in this activity during the past month?" — Numeric (1XX=per week, 2XX=per month) — GO TO CEXP.07; 777 (DK) → GO TO CEXP.07; 999 (R) → GO TO CEXP.07

38. CEXP.07: "And when you took part in this activity, for how many minutes or hours did you usually keep at it?" — Numeric (H:MM) — GO TO CEXP.08; 777 (DK) → GO TO CEXP.08; 999 (R) → GO TO CEXP.08

39. CEXP.08: "During the past month, how many times per week or per month did you do physical activities or exercises to strengthen your muscles?" — Numeric (1XX=per week, 2XX=per month, 888=Never) — GO TO next section; 777 (DK) → GO TO next section; 999 (R) → GO TO next section

### Core Section 5: Hypertension Awareness - 2 items

40. CHYPA.01: "Have you ever been told by a doctor, nurse, or other health professional that you have high blood pressure?" — Single select {1: "Yes", 2: "Yes, but female told only during pregnancy", 3: "No", 4: "Told borderline high or pre-hypertensive"} — 1 (Yes) → GO TO CHYPA.02; 2 → GO TO next section; 3 (No) → GO TO next section; 4 → GO TO CHYPA.02; 7 (DK) → GO TO next section; 9 (R) → GO TO next section

41. CHYPA.02: "Are you currently taking prescription medicine for your high blood pressure?" — Yes/No — GO TO next section; 7 (DK) → GO TO next section; 9 (R) → GO TO next section

### Core Section 6: Cholesterol Awareness - 3 items

42. CCHLA.01: "Cholesterol is a fatty substance found in the blood. About how long has it been since you last had your cholesterol checked?" — Single select {1: "Never", 2: "Within past year", 3: "Within past 2 years", 4: "Within past 3 years", 5: "Within past 4 years", 6: "Within past 5 years", 8: "5 or more years ago"} — 1 (Never) → GO TO next section; 2–6,8 → GO TO CCHLA.02; 7 (DK) → GO TO next section; 9 (R) → GO TO CCHLA.02

43. CCHLA.02: "Have you ever been told by a doctor, nurse or other health professional that your blood cholesterol is high?" — Yes/No — GO TO CCHLA.03; 7 (DK) → GO TO CCHLA.03; 9 (R) → GO TO CCHLA.03

44. CCHLA.03: "Are you currently taking medicine prescribed by your doctor or other health professional for your cholesterol?" — Yes/No — GO TO next section; 7 (DK) → GO TO next section; 9 (R) → GO TO next section

### Core Section 7: Chronic Health Conditions - 13 items

45. CCHC.01: "(Ever told) you had a heart attack also called a myocardial infarction?" — Yes/No — GO TO CCHC.02; 7 (DK) → GO TO CCHC.02; 9 (R) → GO TO CCHC.02

46. CCHC.02: "(Ever told) (you had) angina or coronary heart disease?" — Yes/No — GO TO CCHC.03; 7 (DK) → GO TO CCHC.03; 9 (R) → GO TO CCHC.03

47. CCHC.03: "(Ever told) (you had) a stroke?" — Yes/No — GO TO CCHC.04; 7 (DK) → GO TO CCHC.04; 9 (R) → GO TO CCHC.04

48. CCHC.04: "(Ever told) (you had) asthma?" — Yes/No — 1 (Yes) → GO TO CCHC.05; 2 (No) → GO TO CCHC.06; 7 (DK) → GO TO CCHC.06; 9 (R) → GO TO CCHC.06

49. CCHC.05: "Do you still have asthma?" — Yes/No — GO TO CCHC.06; 7 (DK) → GO TO CCHC.06; 9 (R) → GO TO CCHC.06

50. CCHC.06: "(Ever told) (you had) skin cancer that is not melanoma?" — Yes/No — GO TO CCHC.07; 7 (DK) → GO TO CCHC.07; 9 (R) → GO TO CCHC.07

51. CCHC.07: "(Ever told) (you had) any melanoma or any other types of cancer?" — Yes/No — GO TO CCHC.08; 7 (DK) → GO TO CCHC.08; 9 (R) → GO TO CCHC.08

52. CCHC.08: "(Ever told) (you had) C.O.P.D., emphysema or chronic bronchitis?" — Yes/No — GO TO CCHC.09; 7 (DK) → GO TO CCHC.09; 9 (R) → GO TO CCHC.09

53. CCHC.09: "(Ever told) (you had) a depressive disorder (including depression, major depression, dysthymia, or minor depression)?" — Yes/No — GO TO CCHC.10; 7 (DK) → GO TO CCHC.10; 9 (R) → GO TO CCHC.10

54. CCHC.10: "Not including kidney stones, bladder infection or incontinence, were you ever told you had kidney disease?" — Yes/No — GO TO CCHC.11; 7 (DK) → GO TO CCHC.11; 9 (R) → GO TO CCHC.11

55. CCHC.11: "(Ever told) (you had) some form of arthritis, rheumatoid arthritis, gout, lupus, or fibromyalgia?" — Yes/No — GO TO CCHC.12; 7 (DK) → GO TO CCHC.12; 9 (R) → GO TO CCHC.12

56. CCHC.12: "(Ever told) (you had) diabetes?" — Single select {1: "Yes", 2: "Yes, but female told only during pregnancy", 3: "No", 4: "No, pre-diabetes or borderline diabetes"} — 1 (Yes) → GO TO CCHC.13; 2,3,4 → GO TO Pre-Diabetes Module (if used) or next section; 7 (DK) → GO TO Pre-Diabetes Module (if used) or next section; 9 (R) → GO TO Pre-Diabetes Module (if used) or next section

57. CCHC.13: "How old were you when you were first told you had diabetes?" — Numeric (age in years, 97=97+) — GO TO Diabetes Module (if used) or next section; 98 (DK) → GO TO Diabetes Module (if used) or next section; 99 (R) → GO TO Diabetes Module (if used) or next section

### Core Section 8: Demographics - 20 items

58. CDEM.01: "What is your age?" — Numeric (age in years) — GO TO CDEM.02; 07 (DK) → GO TO CDEM.02; 09 (R) → GO TO CDEM.02

59. CDEM.02: "Are you Hispanic, Latino/a, or Spanish origin?" — Multi select {1: "Mexican/Mexican American/Chicano/a", 2: "Puerto Rican", 3: "Cuban", 4: "Another Hispanic/Latino/a/Spanish origin", 5: "No"} — GO TO CDEM.03; 7 (DK) → GO TO CDEM.03; 9 (R) → GO TO CDEM.03

60. CDEM.03: "Which one or more of the following would you say is your race?" — Multi select {10: "White", 20: "Black or African American", 30: "American Indian or Alaska Native", 40: "Asian" (41–47 subcategories), 50: "Pacific Islander" (51–54 subcategories), 60: "Other"} — GO TO CDEM.04; 77 (DK) → GO TO CDEM.04; 99 (R) → GO TO CDEM.04

61. CDEM.04: "Are you…?" — Single select {1: "Married", 2: "Divorced", 3: "Widowed", 4: "Separated", 5: "Never married", 6: "Member of an unmarried couple"} — GO TO CDEM.05; 9 (R) → GO TO CDEM.05

62. CDEM.05: "What is the highest grade or year of school you completed?" — Single select {1: "Never attended/kindergarten only", 2: "Grades 1–8", 3: "Grades 9–11", 4: "Grade 12 or GED", 5: "College 1–3 years", 6: "College 4+ years"} — GO TO CDEM.06; 9 (R) → GO TO CDEM.06

63. CDEM.06: "Do you own or rent your home?" — Single select {1: "Own", 2: "Rent", 3: "Other arrangement"} — GO TO CDEM.07; 7 (DK) → GO TO CDEM.07; 9 (R) → GO TO CDEM.07

64. CDEM.07: "In what county do you currently live?" — Numeric (ANSI county code) — GO TO CDEM.08; 777 (DK) → GO TO CDEM.08; 999 (R) → GO TO CDEM.08

65. CDEM.08: "What is the ZIP Code where you currently live?" — Numeric (5-digit ZIP) — GO TO CDEM.FILTER1; 77777 (DK) → GO TO CDEM.FILTER1; 99999 (R) → GO TO CDEM.FILTER1

66. CDEM.FILTER1: Filter — If cell phone interview → GO TO CDEM.11; otherwise → GO TO CDEM.09

67. CDEM.09: "Not including cell phones or numbers used for computers, fax machines or security systems, do you have more than one landline telephone number in your household?" — Yes/No — 1 (Yes) → GO TO CDEM.10; 2 (No) → GO TO CDEM.11; 7 (DK) → GO TO CDEM.11; 9 (R) → GO TO CDEM.11

68. CDEM.10: "How many of these landline telephone numbers are residential numbers?" — Numeric (1–5, 6=6+) — GO TO CDEM.11; 7 (DK) → GO TO CDEM.11; 8 (None) → GO TO CDEM.11; 9 (R) → GO TO CDEM.11

69. CDEM.11: "How many cell phones do you have for personal use?" — Numeric (1–5, 6=6+) — GO TO CDEM.12; 7 (DK) → GO TO CDEM.12; 8 (None) → GO TO CDEM.12; 9 (R) → GO TO CDEM.12

70. CDEM.12: "Have you ever served on active duty in the United States Armed Forces, either in the regular military or in a National Guard or military reserve unit?" — Yes/No — GO TO CDEM.13; 7 (DK) → GO TO CDEM.13; 9 (R) → GO TO CDEM.13

71. CDEM.13: "Are you currently…?" — Single select {1: "Employed for wages", 2: "Self-employed", 3: "Out of work 1+ year", 4: "Out of work <1 year", 5: "Homemaker", 6: "Student", 7: "Retired", 8: "Unable to work"} — GO TO CDEM.14; 9 (R) → GO TO CDEM.14

72. CDEM.14: "How many children less than 18 years of age live in your household?" — Numeric — GO TO CDEM.15; 88 (None) → GO TO CDEM.15; 99 (R) → GO TO CDEM.15

73. CDEM.15: "Is your annual household income from all sources—?" — Single select {01: "<$10K", 02: "$10K–<$15K", 03: "$15K–<$20K", 04: "$20K–<$25K", 05: "$25K–<$35K", 06: "$35K–<$50K", 07: "$50K–<$75K", 08: "$75K–<$100K", 09: "$100K–<$150K", 10: "$150K–<$200K", 11: "$200K+"} — GO TO CDEM.FILTER2; 77 (DK) → GO TO CDEM.FILTER2; 99 (R) → GO TO CDEM.17

74. CDEM.FILTER2: Filter — If male (MSAB.01=1 or CP05=1 or LL09=1) → GO TO CDEM.17; If age>49 → GO TO CDEM.17; otherwise → GO TO CDEM.16

75. CDEM.16: "To your knowledge, are you now pregnant?" — Yes/No — GO TO CDEM.17; 7 (DK) → GO TO CDEM.17; 9 (R) → GO TO CDEM.17

76. CDEM.17: "About how much do you weigh without shoes?" — Numeric (pounds or kg) — GO TO CDEM.18; 7777 (DK) → GO TO CDEM.18; 9999 (R) → GO TO CDEM.18

77. CDEM.18: "About how tall are you without shoes?" — Numeric (ft/in or m/cm) — GO TO next section; 77/77 (DK) → GO TO next section; 99/99 (R) → GO TO next section

### Core Section 9: Disability - 6 items

78. CDIS.01: "Are you deaf or do you have serious difficulty hearing?" — Yes/No — GO TO CDIS.02; 7 (DK) → GO TO CDIS.02; 9 (R) → GO TO CDIS.02

79. CDIS.02: "Are you blind or do you have serious difficulty seeing, even when wearing glasses?" — Yes/No — GO TO CDIS.03; 7 (DK) → GO TO CDIS.03; 9 (R) → GO TO CDIS.03

80. CDIS.03: "Because of a physical, mental, or emotional condition, do you have serious difficulty concentrating, remembering, or making decisions?" — Yes/No — GO TO CDIS.04; 7 (DK) → GO TO CDIS.04; 9 (R) → GO TO CDIS.04

81. CDIS.04: "Do you have serious difficulty walking or climbing stairs?" — Yes/No — GO TO CDIS.05; 7 (DK) → GO TO CDIS.05; 9 (R) → GO TO CDIS.05

82. CDIS.05: "Do you have difficulty dressing or bathing?" — Yes/No — GO TO CDIS.06; 7 (DK) → GO TO CDIS.06; 9 (R) → GO TO CDIS.06

83. CDIS.06: "Because of a physical, mental, or emotional condition, do you have difficulty doing errands alone such as visiting a doctor's office or shopping?" — Yes/No — GO TO next section; 7 (DK) → GO TO next section; 9 (R) → GO TO next section

### Core Section 10: Falls - 3 items

84. CFAL.FILTER: Filter — If CDEM.01 (age) 18–44 → SKIP entire section, GO TO next section; otherwise → GO TO CFAL.01

85. CFAL.01: "In the past 12 months, how many times have you fallen?" — Numeric (76=76+) — number → GO TO CFAL.02; 88 (None) → GO TO next section; 77 (DK) → GO TO CFAL.02; 99 (R) → GO TO CFAL.02

86. CFAL.02: "How many of these falls caused an injury that limited your regular activities for at least a day or caused you to go to see a doctor?" — Numeric (76=76+) — GO TO next section; 88 (None) → GO TO next section; 77 (DK) → GO TO next section; 99 (R) → GO TO next section

### Core Section 11: Tobacco Use - 4 items

87. CTOB.01: "Have you smoked at least 100 cigarettes in your entire life?" — Yes/No — 1 (Yes) → GO TO CTOB.02; 2 (No) → GO TO CTOB.03; 7 (DK) → GO TO CTOB.03; 9 (R) → GO TO CTOB.03

88. CTOB.02: "Do you now smoke cigarettes every day, some days, or not at all?" — Single select {1: "Every day", 2: "Some days", 3: "Not at all"} — GO TO CTOB.03; 7 (DK) → GO TO CTOB.03; 9 (R) → GO TO CTOB.03

89. CTOB.03: "Do you currently use chewing tobacco, snuff, or snus every day, some days, or not at all?" — Single select {1: "Every day", 2: "Some days", 3: "Not at all"} — GO TO CTOB.04; 7 (DK) → GO TO CTOB.04; 9 (R) → GO TO CTOB.04

90. CTOB.04: "Would you say you have never used e-cigarettes or other electronic vaping products in your entire life, or now use them every day, use them some days, or used them in the past but do not currently use them at all?" — Single select {1: "Never used", 2: "Use every day", 3: "Use some days", 4: "Not at all right now"} — GO TO next section; 7 (DK) → GO TO next section; 9 (R) → GO TO next section

### Core Section 12: Alcohol Consumption - 5 items

91. CALC.PROLOGUE: "The next questions concern alcohol consumption. One drink of alcohol is equivalent to a 12-ounce beer, a 5-ounce glass of wine, or a drink with one shot of liquor." — Read — GO TO CALC.01

92. CALC.01: "During the past 30 days, how many days per week or per month did you have at least one drink of any alcoholic beverage?" — Numeric (1XX=per week, 2XX=per month) — number → GO TO CALC.02; 888 (No drinks in past 30 days) → GO TO next section; 777 (DK) → GO TO CALC.02; 999 (R) → GO TO CALC.02

93. CALC.02: "During the past 30 days, on the days when you drank, about how many drinks did you drink on the average?" — Numeric — GO TO CALC.03; 77 (DK) → GO TO CALC.03; 99 (R) → GO TO CALC.03

94. CALC.03: "Considering all types of alcoholic beverages, how many times during the past 30 days did you have [5 for men / 4 for women] or more drinks on an occasion?" — Numeric — GO TO CALC.04; 88 (No days) → GO TO CALC.04; 77 (DK) → GO TO CALC.04; 99 (R) → GO TO CALC.04

95. CALC.04: "During the past 30 days, what is the largest number of drinks you had on any occasion?" — Numeric — GO TO next section; 77 (DK) → GO TO next section; 99 (R) → GO TO next section

### Core Section 13: Immunization - 4 items

96. CIMM.01: "During the past 12 months, have you had either a flu vaccine that was sprayed in your nose or a flu shot injected into your arm?" — Yes/No — 1 (Yes) → GO TO CIMM.02; 2 (No) → GO TO CIMM.03; 7 (DK) → GO TO CIMM.03; 9 (R) → GO TO CIMM.03

97. CIMM.02: "During what month and year did you receive your most recent flu vaccine?" — Date (MM/YYYY) — GO TO CIMM.03; 77/7777 (DK) → GO TO CIMM.03; 99/9999 (R) → GO TO CIMM.03

98. CIMM.03: "Have you ever had a pneumonia shot also known as a pneumococcal vaccine?" — Yes/No — If CDEM.01 (age) ≥ 50 → GO TO CIMM.04; If age < 50 → GO TO next section; 7 (DK) → same routing; 9 (R) → same routing

99. CIMM.04: "Have you ever had the shingles or zoster vaccine?" — Yes/No — GO TO next section; 7 (DK) → GO TO next section; 9 (R) → GO TO next section

### Core Section 14: H.I.V./AIDS - 2 items

100. CHIV.01: "Including fluid testing from your mouth, but not including tests you may have had for blood donation, have you ever been tested for H.I.V?" — Yes/No — 1 (Yes) → GO TO CHIV.02; 2 (No) → GO TO next section; 7 (DK) → GO TO next section; 9 (R) → GO TO next section

101. CHIV.02: "Not including blood donations, in what month and year was your last H.I.V. test?" — Date (MM/YYYY) — GO TO next section; 77/7777 (DK) → GO TO next section; 99/9999 (R) → GO TO next section

### Core Section 15: Seat Belt Use / Drinking and Driving - 3 items

102. CSBD.01: "How often do you use seat belts when you drive or ride in a car? Would you say—" — Single select {1: "Always", 2: "Nearly always", 3: "Sometimes", 4: "Seldom", 5: "Never", 8: "Never drive or ride in a car"} — 8 → GO TO next section; other responses → GO TO CSBD.FILTER; 7 (DK) → GO TO CSBD.FILTER; 9 (R) → GO TO CSBD.FILTER

103. CSBD.FILTER: Filter — If CALC.01=888 (no drinks in past 30 days) → GO TO next section; otherwise → GO TO CSBD.02

104. CSBD.02: "During the past 30 days, how many times have you driven when you've had perhaps too much to drink?" — Numeric — GO TO next section; 88 (None) → GO TO next section; 77 (DK) → GO TO next section; 99 (R) → GO TO next section

### Emerging Core: Long-term COVID Effects - 3 items

105. COVID.01: "Have you ever tested positive for COVID-19 or been told by a doctor or other health care provider that you have or had COVID-19?" — Yes/No — 1 (Yes) → GO TO COVID.02; 2 (No) → GO TO closing/modules; 7 (DK) → GO TO closing/modules; 9 (R) → GO TO closing/modules

106. COVID.02: "Do you currently have symptoms lasting 3 months or longer that you did not have prior to having coronavirus or COVID-19?" — Yes/No — 1 (Yes) → GO TO COVID.03; 2 (No) → GO TO closing/modules; 7 (DK) → GO TO closing/modules; 9 (R) → GO TO closing/modules

107. COVID.03: "Do these long-term symptoms reduce your ability to carry out day-to-day activities compared with the time before you had COVID-19?" — Single select {1: "Yes, a lot", 2: "Yes, a little", 3: "Not at all"} — GO TO closing/modules; 7 (DK) → GO TO closing/modules; 9 (R) → GO TO closing/modules

### Closing Statement / Transition to Modules - 1 item

108. CLOSE.01: "That was my last question. Everyone's answers will be combined to help us provide information about the health practices of people in this state. Thank you very much for your time and cooperation." — Read — If no optional modules → END; otherwise → GO TO first module

### Module 1: Prediabetes - 2 items

Module filter: Skip if CCHC.12=1 (already has diabetes). If CCHC.12=4, auto-code MPDIAB.02=1.

109. MPDIAB.01: "When was the last time you had a blood test for high blood sugar or diabetes by a doctor, nurse, or other health professional?" — Single select {1: "Within past year", 2: "Within past 2 years", 3: "Within past 3 years", 4: "Within past 5 years", 5: "Within past 10 years", 6: "10+ years ago", 8: "Never"} — GO TO MPDIAB.02; 7 (DK) → GO TO MPDIAB.02; 9 (R) → GO TO MPDIAB.02

110. MPDIAB.02: "Has a doctor or other health professional ever told you that you had prediabetes or borderline diabetes?" — Single select {1: "Yes", 2: "Yes, during pregnancy", 3: "No"} — GO TO next module; 7 (DK) → GO TO next module; 9 (R) → GO TO next module

### Module 2: Diabetes - 7 items

Module filter: Ask only if CCHC.12=1 (has diabetes).

111. MDIAB.01: "According to your doctor or other health professional, what type of diabetes do you have?" — Single select {1: "Type 1", 2: "Type 2"} — GO TO next; 7 (DK) → GO TO next; 9 (R) → GO TO next

112. MDIAB.02: "Insulin can be taken by shot or pump. Are you now taking insulin?" — Yes/No — GO TO next; 7 (DK) → GO TO next; 9 (R) → GO TO next

113. MDIAB.03: "About how many times in the past 12 months has a doctor, nurse, or other health professional checked you for A-one-C?" — Numeric (0–76, 88=None, 98=Never heard of test) — GO TO next; 77 (DK) → GO TO next; 99 (R) → GO TO next

114. MDIAB.04: "When was the last time you had an eye exam in which the pupils were dilated?" — Single select {1: "Within past month", 2: "Within past year", 3: "Within past 2 years", 4: "2+ years ago", 8: "Never"} — GO TO next; 7 (DK) → GO TO next; 9 (R) → GO TO next

115. MDIAB.05: "When was the last time a doctor, nurse or other health professional took a photo of the back of your eye with a specialized camera?" — Single select {1: "Within past month", 2: "Within past year", 3: "Within past 2 years", 4: "2+ years ago", 8: "Never"} — GO TO next; 7 (DK) → GO TO next; 9 (R) → GO TO next

116. MDIAB.06: "When was the last time you took a course or class in how to manage your diabetes yourself?" — Single select {1: "Within past year", 2: "Within past 2 years", 3: "Within past 3 years", 4: "Within past 5 years", 5: "Within past 10 years", 6: "10+ years ago", 8: "Never"} — GO TO next; 7 (DK) → GO TO next; 9 (R) → GO TO next

117. MDIAB.07: "Have you ever had any sores or irritations on your feet that took more than four weeks to heal?" — Yes/No — GO TO next module; 7 (DK) → GO TO next module; 9 (R) → GO TO next module

### Module 3: Arthritis - 5 items

Module filter: Ask only if CCHC.11=1 (has arthritis).

118. MARTH.01: "Has a doctor or other health professional ever suggested physical activity or exercise to help your arthritis or joint symptoms?" — Yes/No — GO TO next; 7 (DK) → GO TO next; 9 (R) → GO TO next

119. MARTH.02: "Have you ever taken an educational course or class to teach you how to manage problems related to your arthritis or joint symptoms?" — Yes/No — GO TO next; 7 (DK) → GO TO next; 9 (R) → GO TO next

120. MARTH.03: "Are you now limited in any way in any of your usual activities because of arthritis or joint symptoms?" — Yes/No — GO TO next; 7 (DK) → GO TO next; 9 (R) → GO TO next

121. MARTH.04: "Do arthritis or joint symptoms now affect whether you work, the type of work you do or the amount of work you do?" — Yes/No — GO TO next; 7 (DK) → GO TO next; 9 (R) → GO TO next

122. MARTH.05: "During the past 30 days, how bad was your joint pain on average on a scale of 0 to 10 where 0 is no pain and 10 is pain as bad as it can be?" — Scale (0–10) — GO TO next module; 77 (DK) → GO TO next module; 99 (R) → GO TO next module

### Module 4: Lung Cancer Screening - 7 items

Module filter: If CTOB.01=1 (smoked 100+ cigarettes) AND CTOB.02=1,2,or 3 → ask MLCS.01; else → GO TO MLCS.04.

123. MLCS.01: "How old were you when you first started to smoke cigarettes regularly?" — Numeric (age) — valid age → GO TO filter; 888 (Never smoked regularly) → GO TO MLCS.04; 777 (DK) → GO TO MLCS.04; 999 (R) → GO TO MLCS.04

124. MLCS.FILTER: Filter — If current everyday smoker (CTOB.02=1) → SKIP MLCS.02, GO TO MLCS.03; otherwise → GO TO MLCS.02

125. MLCS.02: "How old were you when you last smoked cigarettes regularly?" — Numeric (age) — GO TO MLCS.03; 777 (DK) → GO TO MLCS.03; 999 (R) → GO TO MLCS.03

126. MLCS.03: "On average, when you {smoke/smoked} regularly, about how many cigarettes {do/did} you usually smoke each day?" — Numeric — GO TO MLCS.04; 777 (DK) → GO TO MLCS.04; 999 (R) → GO TO MLCS.04

127. MLCS.04: "Have you ever had a CT or CAT scan of your chest area?" — Yes/No — 1 (Yes) → GO TO MLCS.05; 2 (No) → GO TO next module; 7 (DK) → GO TO next module; 9 (R) → GO TO next module

128. MLCS.05: "Were any of the CT or CAT scans of your chest area done mainly to check or screen for lung cancer?" — Yes/No — 1 (Yes) → GO TO MLCS.06; 2 (No) → GO TO next module; 7 (DK) → GO TO next module; 9 (R) → GO TO next module

129. MLCS.06: "When did you have your most recent CT or CAT scan of your chest area mainly to check or screen for lung cancer?" — Single select {1: "Within past year", 2: "Within past 2 years", 3: "Within past 3 years", 4: "Within past 5 years", 5: "Within past 10 years", 6: "10+ years ago"} — GO TO next module; 7 (DK) → GO TO next module; 9 (R) → GO TO next module

### Module 5: Breast and Cervical Cancer Screening - 8 items

Module filter: Skip entire module if male.

130. MBCCS.01: "Have you ever had a mammogram?" — Yes/No — 1 (Yes) → GO TO MBCCS.02; 2 (No) → GO TO MBCCS.03; 7 (DK) → GO TO MBCCS.03; 9 (R) → GO TO MBCCS.03

131. MBCCS.02: "How long has it been since you had your last mammogram?" — Single select {1: "Within past year", 2: "Within past 2 years", 3: "Within past 3 years", 4: "Within past 5 years", 5: "5+ years ago"} — GO TO MBCCS.03; 7 (DK) → GO TO MBCCS.03; 9 (R) → GO TO MBCCS.03

132. MBCCS.03: "Have you ever had a cervical cancer screening test?" — Yes/No — 1 (Yes) → GO TO MBCCS.04; 2 (No) → GO TO MBCCS.07; 7 (DK) → GO TO MBCCS.07; 9 (R) → GO TO MBCCS.07

133. MBCCS.04: "How long has it been since you had your last cervical cancer screening test?" — Single select {1: "Within past year", 2: "Within past 2 years", 3: "Within past 3 years", 4: "Within past 5 years", 5: "5+ years ago"} — GO TO MBCCS.05; 7 (DK) → GO TO MBCCS.05; 9 (R) → GO TO MBCCS.05

134. MBCCS.05: "At your most recent cervical cancer screening, did you have a Pap test?" — Yes/No — GO TO MBCCS.06; 7 (DK) → GO TO MBCCS.06; 9 (R) → GO TO MBCCS.06

135. MBCCS.06: "At your most recent cervical cancer screening, did you have an H.P.V. test?" — Yes/No — GO TO MBCCS.FILTER; 7 (DK) → GO TO MBCCS.FILTER; 9 (R) → GO TO MBCCS.FILTER

136. MBCCS.FILTER: Filter — If CDEM.16=1 (currently pregnant) → GO TO next module; otherwise → GO TO MBCCS.07

137. MBCCS.07: "Have you had a hysterectomy?" — Yes/No — GO TO next module; 7 (DK) → GO TO next module; 9 (R) → GO TO next module

### Module 6: Prostate Cancer Screening - 5 items

Module filter: Skip if female OR age < 39.

138. MPCS.01: "Have you ever had a P.S.A. test?" — Yes/No — 1 (Yes) → GO TO MPCS.02; 2 (No) → GO TO MPCS.05; 7 (DK) → GO TO MPCS.05; 9 (R) → GO TO MPCS.05

139. MPCS.02: "About how long has it been since your most recent P.S.A. test?" — Single select {1: "Within past year", 2: "Within past 2 years", 3: "Within past 3 years", 4: "Within past 5 years", 5: "5+ years ago"} — GO TO MPCS.03; 7 (DK) → GO TO MPCS.03; 9 (R) → GO TO MPCS.03

140. MPCS.03: "What was the main reason you had this P.S.A. test — was it…?" — Single select {1: "Part of routine exam", 2: "Because of a problem", 3: "Other reason"} — GO TO MPCS.04; 7 (DK) → GO TO MPCS.04; 9 (R) → GO TO MPCS.04

141. MPCS.04: "Who first suggested this P.S.A. test: you, your doctor, or someone else?" — Single select {1: "Self", 2: "Doctor/nurse/health professional", 3: "Someone else"} — GO TO MPCS.05; 7 (DK) → GO TO MPCS.05; 9 (R) → GO TO MPCS.05

142. MPCS.05: "Did a doctor, nurse, or other health professional EVER talk about the advantages, disadvantages, or both of the P.S.A. test?" — Single select {1: "Advantages", 2: "Disadvantages", 3: "Both", 4: "Neither"} — GO TO next module; 7 (DK) → GO TO next module; 9 (R) → GO TO next module

### Module 7: Colorectal Cancer Screening - 13 items

Module filter: Skip if CDEM.01 (age) < 45.

143. MCCS.01: "Have you ever had a colonoscopy or sigmoidoscopy?" — Yes/No — 1 (Yes) → GO TO MCCS.02; 2 (No) → GO TO MCCS.06; 7 (DK) → GO TO MCCS.06; 9 (R) → GO TO MCCS.06

144. MCCS.02: "Have you had a colonoscopy, a sigmoidoscopy, or both?" — Single select {1: "Colonoscopy", 2: "Sigmoidoscopy", 3: "Both"} — 1 → GO TO MCCS.03; 2 → GO TO MCCS.04; 3 → GO TO MCCS.03; 7 (DK) → GO TO MCCS.05; 9 (R) → GO TO MCCS.06

145. MCCS.03: "How long has it been since your most recent colonoscopy?" — Single select {1: "Within past year", 2: "Within past 2 years", 3: "Within past 5 years", 4: "Within past 10 years", 5: "10+ years ago"} — If MCCS.02=3 → GO TO MCCS.04; otherwise → GO TO MCCS.06; 7 (DK) → same routing; 9 (R) → same routing

146. MCCS.04: "How long has it been since your most recent sigmoidoscopy?" — Single select {1: "Within past year", 2: "Within past 2 years", 3: "Within past 5 years", 4: "Within past 10 years", 5: "10+ years ago"} — GO TO MCCS.06; 7 (DK) → GO TO MCCS.06; 9 (R) → GO TO MCCS.06

147. MCCS.05: "How long has it been since your most recent colonoscopy or sigmoidoscopy?" — Single select {1: "Within past year", 2: "Within past 2 years", 3: "Within past 5 years", 4: "Within past 10 years", 5: "10+ years ago"} — GO TO MCCS.06; 7 (DK) → GO TO MCCS.06; 9 (R) → GO TO MCCS.06

148. MCCS.06: "Have you ever had any other kind of test for colorectal cancer, such as virtual colonoscopy, CT colonography, blood stool test, FIT DNA, or Cologuard test?" — Yes/No — 1 (Yes) → GO TO MCCS.07; 2 (No) → GO TO next module; 7 (DK) → GO TO next module; 9 (R) → GO TO next module

149. MCCS.07: "Have you ever had a virtual colonoscopy?" — Yes/No — 1 (Yes) → GO TO MCCS.08; 2 (No) → GO TO MCCS.09; 7 (DK) → GO TO MCCS.09; 9 (R) → GO TO MCCS.09

150. MCCS.08: "When was your most recent CT colonography or virtual colonoscopy?" — Single select {1: "Within past year", 2: "Within past 2 years", 3: "Within past 5 years", 4: "Within past 10 years", 5: "10+ years ago"} — GO TO MCCS.09; 7 (DK) → GO TO MCCS.09; 9 (R) → GO TO MCCS.09

151. MCCS.09: "Have you ever had a blood stool test or FIT test using a special kit at home?" — Yes/No — 1 (Yes) → GO TO MCCS.10; 2 (No) → GO TO MCCS.11; 7 (DK) → GO TO MCCS.11; 9 (R) → GO TO MCCS.11

152. MCCS.10: "How long has it been since you had this test?" — Single select {1: "Within past year", 2: "Within past 2 years", 3: "Within past 3 years", 4: "Within past 5 years", 5: "5+ years ago"} — GO TO MCCS.11; 7 (DK) → GO TO MCCS.11; 9 (R) → GO TO MCCS.11

153. MCCS.11: "Have you ever had a Cologuard or FIT-DNA stool test using a special kit at home?" — Yes/No — 1 (Yes) → GO TO MCCS.12; 2 (No) → GO TO next module; 7 (DK) → GO TO next module; 9 (R) → GO TO next module

154. MCCS.12: "Was the blood stool or FIT you reported earlier conducted as part of a Cologuard test?" — Yes/No — GO TO MCCS.13; 7 (DK) → GO TO MCCS.13; 9 (R) → GO TO MCCS.13

155. MCCS.13: "How long has it been since you had this test?" — Single select {1: "Within past year", 2: "Within past 2 years", 3: "Within past 3 years", 4: "Within past 5 years", 5: "5+ years ago"} — GO TO next module; 7 (DK) → GO TO next module; 9 (R) → GO TO next module

### Module 8: Cancer Survivorship - Type of Cancer - 3 items

Module filter: Ask only if CCHC.06=1 OR CCHC.07=1 (ever told skin cancer or other cancer).

156. MTOC.01: "How many different types of cancer have you had?" — Single select {1: "Only one", 2: "Two", 3: "Three or more"} — 1,2,3 → GO TO MTOC.02; 7 (DK) → GO TO next module; 9 (R) → GO TO next module

157. MTOC.02: "At what age were you (first) told that you had cancer?" — Numeric (age, 97=97+) — GO TO MTOC.03; 98 (DK) → GO TO MTOC.03; 99 (R) → GO TO MTOC.03

158. MTOC.03: "What type of cancer was it?" — Single select {01: "Bladder", 02: "Blood", 03: "Bone", 04: "Brain", 05: "Breast", 06: "Cervix", 07: "Colon", 08: "Esophagus", 09: "Gallbladder", 10: "Kidney", 11: "Larynx-trachea", 12: "Leukemia", 13: "Liver", 14: "Lung", 15: "Lymphoma", 16: "Melanoma", 17: "Mouth/tongue/lip", 18: "Ovary", 19: "Pancreas", 20: "Prostate", 21: "Rectum", 22: "Skin (non-melanoma)", 23: "Skin (unknown type)", 24: "Soft tissue", 25: "Stomach", 26: "Testis", 27: "Throat-pharynx", 28: "Thyroid", 29: "Uterus", 30: "Other"} — GO TO next module; 77 (DK) → GO TO next module; 99 (R) → GO TO next module

### Module 9: Cancer Survivorship - Course of Treatment - 8 items

Module filter: Ask only if CCHC.06=1 OR CCHC.07=1.

159. MCOT.01: "Are you currently receiving treatment for cancer?" — Single select {1: "Yes, currently receiving treatment", 2: "No, completed treatment", 3: "No, refused treatment", 4: "No, haven't started treatment", 5: "Treatment not necessary"} — 3 → GO TO next module; all others → GO TO MCOT.02; 7 (DK) → GO TO MCOT.02; 9 (R) → GO TO MCOT.02

160. MCOT.02: "What type of doctor provides the majority of your health care?" — Single select {01: "Cancer Surgeon", 02: "Family Practitioner", 03: "General Surgeon", 04: "Gynecologic Oncologist", 05: "Internist", 06: "Plastic/Reconstructive Surgeon", 07: "Medical Oncologist", 08: "Radiation Oncologist", 09: "Urologist", 10: "Other"} — GO TO next; 77 (DK) → GO TO next; 99 (R) → GO TO next

161. MCOT.03: "Did any doctor, nurse, or other health professional ever give you a written summary of all the cancer treatments that you received?" — Yes/No — GO TO next; 7 (DK) → GO TO next; 9 (R) → GO TO next

162. MCOT.04: "Have you ever received instructions about where you should return or who you should see for routine cancer check-ups after completing treatment?" — Yes/No — 1 (Yes) → GO TO MCOT.05; 2 (No) → GO TO MCOT.06; 7 (DK) → GO TO MCOT.06; 9 (R) → GO TO MCOT.06

163. MCOT.05: "Were these instructions written down or printed on paper for you?" — Yes/No — GO TO MCOT.06; 7 (DK) → GO TO MCOT.06; 9 (R) → GO TO MCOT.06

164. MCOT.06: "With your most recent diagnosis of cancer, did you have health insurance that paid for all or part of your cancer treatment?" — Yes/No — GO TO next; 7 (DK) → GO TO next; 9 (R) → GO TO next

165. MCOT.07: "Were you ever denied health insurance or life insurance coverage because of your cancer?" — Yes/No — GO TO next; 7 (DK) → GO TO next; 9 (R) → GO TO next

166. MCOT.08: "Did you participate in a clinical trial as part of your cancer treatment?" — Yes/No — GO TO next module; 7 (DK) → GO TO next module; 9 (R) → GO TO next module

### Module 10: Cancer Survivorship - Pain Management - 2 items

Module filter: Ask only if CCHC.06=1 OR CCHC.07=1.

167. MCPM.01: "Do you currently have physical pain caused by your cancer or cancer treatment?" — Yes/No — 1 (Yes) → GO TO MCPM.02; 2 (No) → GO TO next module; 7 (DK) → GO TO next module; 9 (R) → GO TO next module

168. MCPM.02: "Would you say your pain is currently under control…?" — Single select {1: "With medication", 2: "Without medication", 3: "Not under control, with medication", 4: "Not under control, without medication"} — GO TO next module; 7 (DK) → GO TO next module; 9 (R) → GO TO next module

### Module 11: Indoor Tanning - 1 item

169. MNTAN.01: "Not including spray-on tans, during the past 12 months, how many times have you used an indoor tanning device such as a sunlamp, tanning bed, or booth?" — Numeric (0–365) — GO TO next module; 777 (DK) → GO TO next module; 999 (R) → GO TO next module

### Module 12: Excess Sun Exposure - 4 items

170. MSUN.01: "During the past 12 months, how many times have you had a sunburn?" — Numeric (0–365) — GO TO next; 777 (DK) → GO TO next; 999 (R) → GO TO next

171. MSUN.02: "When you go outside on a warm sunny day for more than one hour, how often do you protect yourself from the sun?" — Single select {1: "Always", 2: "Most of the time", 3: "Sometimes", 4: "Rarely", 5: "Never", 6: "Don't stay outside 1+ hour", 8: "Don't go outside at all on warm sunny days"} — GO TO next; 7 (DK) → GO TO next; 9 (R) → GO TO next

172. MSUN.03: "On weekdays, in the summer, how long are you outside per day between 10am and 4pm?" — Single select {01: "<30 min", 02: "30 min–1 hr", 03: "1–2 hrs", 04: "2–3 hrs", 05: "3–4 hrs", 06: "4–5 hrs", 07: "5–6 hrs"} — GO TO next; 77 (DK) → GO TO next; 99 (R) → GO TO next

173. MSUN.04: "On weekends in the summer, how long are you outside each day between 10am and 4pm?" — Single select {01: "<30 min", 02: "30 min–1 hr", 03: "1–2 hrs", 04: "2–3 hrs", 05: "3–4 hrs", 06: "4–5 hrs", 07: "5–6 hrs"} — GO TO next module; 77 (DK) → GO TO next module; 99 (R) → GO TO next module

### Module 13: Cognitive Decline - 5 items

Module filter: Ask only if respondent age ≥ 45.

174. MCOG.01: "During the past 12 months, have you experienced difficulties with thinking or memory that are happening more often or are getting worse?" — Yes/No — 1 (Yes) → GO TO MCOG.02; 2 (No) → GO TO next module; 7 (DK) → GO TO next module; 9 (R) → GO TO next module

175. MCOG.02: "Are you worried about these difficulties with thinking or memory?" — Yes/No — GO TO next; 7 (DK) → GO TO next; 9 (R) → GO TO next

176. MCOG.03: "Have you or anyone else discussed your difficulties with thinking or memory with a health care provider?" — Yes/No — GO TO next; 7 (DK) → GO TO next; 9 (R) → GO TO next

177. MCOG.04: "During the past 12 months, have your difficulties with thinking or memory interfered with day-to-day activities?" — Yes/No — GO TO next; 7 (DK) → GO TO next; 9 (R) → GO TO next

178. MCOG.05: "During the past 12 months, have your difficulties with thinking or memory interfered with your ability to work or volunteer?" — Yes/No — GO TO next module; 7 (DK) → GO TO next module; 9 (R) → GO TO next module

### Module 14: Caregiver - 9 items

179. MCARE.01: "During the past 30 days, did you provide regular care or assistance to a friend or family member who has a health problem or disability?" — Single select {1: "Yes", 2: "No", 8: "Caregiving recipient died in past 30 days"} — 1 (Yes) → GO TO MCARE.02; 2 (No) → GO TO MCARE.09; 7 (DK) → GO TO MCARE.09; 8 → GO TO next module; 9 (R) → GO TO MCARE.09

180. MCARE.02: "What is his or her relationship to you?" — Single select {01: "Mother", 02: "Father", 03: "Mother-in-law", 04: "Father-in-law", 05: "Child", 06: "Husband", 07: "Wife", 08: "Live-in partner", 09: "Brother/brother-in-law", 10: "Sister/sister-in-law", 11: "Grandmother", 12: "Grandfather", 13: "Grandchild", 14: "Other relative", 15: "Non-relative/family friend"} — GO TO next; 77 (DK) → GO TO next; 99 (R) → GO TO next

181. MCARE.03: "For how long have you provided care for that person?" — Single select {1: "<30 days", 2: "1–<6 months", 3: "6 months–<2 years", 4: "2–<5 years", 5: "5+ years"} — GO TO next; 7 (DK) → GO TO next; 9 (R) → GO TO next

182. MCARE.04: "In an average week, how many hours do you provide care or assistance?" — Single select {1: "Up to 8 hrs/week", 2: "9–19 hrs/week", 3: "20–39 hrs/week", 4: "40+ hrs"} — GO TO next; 7 (DK) → GO TO next; 9 (R) → GO TO next

183. MCARE.05: "What is the main health problem, long-term illness, or disability that the person you care for has?" — Single select {01: "Arthritis", 02: "Asthma", 03: "Cancer", 04: "Chronic respiratory/COPD", 05: "Alzheimer's/dementia", 06: "Developmental disabilities", 07: "Diabetes", 08: "Heart disease/hypertension/stroke", 09: "HIV", 10: "Mental illness", 11: "Other organ failure", 12: "Substance abuse", 13: "Injuries", 14: "Old age/infirmity", 15: "Other"} — 05 → SKIP MCARE.06, GO TO MCARE.07; all others → GO TO MCARE.06; 77 (DK) → GO TO MCARE.06; 99 (R) → GO TO MCARE.06

184. MCARE.06: "Does the person you care for also have Alzheimer's disease, dementia or other cognitive impairment disorder?" — Yes/No — GO TO MCARE.07; 7 (DK) → GO TO MCARE.07; 9 (R) → GO TO MCARE.07

185. MCARE.07: "In the past 30 days, did you provide care by managing personal care such as giving medications, feeding, dressing, or bathing?" — Yes/No — GO TO MCARE.08; 7 (DK) → GO TO MCARE.08; 9 (R) → GO TO MCARE.08

186. MCARE.08: "In the past 30 days, did you provide care by managing household tasks such as cleaning, managing money, or preparing meals?" — Yes/No — GO TO next module (skip MCARE.09); 7 (DK) → GO TO next module; 9 (R) → GO TO next module

187. MCARE.09: "In the next 2 years, do you expect to provide care or assistance to a friend or family member who has a health problem or disability?" — Yes/No — GO TO next module; 7 (DK) → GO TO next module; 9 (R) → GO TO next module

### Module 15: Tobacco Cessation - 2 items

188. MTC.FILTER1: Filter — If CTOB.01=1 AND CTOB.02=3 (former smoker, now not smoking) → GO TO MTC.01; otherwise → check MTC.FILTER2

189. MTC.01: "How long has it been since you last smoked a cigarette, even one or two puffs?" — Single select {01: "Within past month", 02: "Within past 3 months", 03: "Within past 6 months", 04: "Within past year", 05: "Within past 5 years", 06: "Within past 10 years", 07: "10+ years", 08: "Never smoked regularly"} — GO TO next module; 77 (DK) → GO TO next module; 99 (R) → GO TO next module

190. MTC.FILTER2: Filter — If CTOB.02=1 OR CTOB.02=2 (current smoker) → GO TO MTC.02; otherwise → GO TO next module

191. MTC.02: "During the past 12 months, have you stopped smoking for one day or longer because you were trying to quit smoking?" — Yes/No — GO TO next module; 7 (DK) → GO TO next module; 9 (R) → GO TO next module

### Module 16: Other Tobacco Use - 3 items

192. MOTU.FILTER1: Filter — If CTOB.02=1 OR CTOB.02=2 (current smoker) → GO TO MOTU.01; otherwise → GO TO MOTU.FILTER2

193. MOTU.01: "Currently, when you smoke cigarettes, do you usually smoke menthol cigarettes?" — Yes/No — GO TO MOTU.FILTER2; 7 (DK) → GO TO MOTU.FILTER2; 9 (R) → GO TO MOTU.FILTER2

194. MOTU.FILTER2: Filter — If CTOB.04=2 OR CTOB.04=3 (current e-cigarette user) → GO TO MOTU.02; otherwise → GO TO MOTU.03

195. MOTU.02: "Currently, when you use e-cigarettes, do you usually use menthol e-cigarettes?" — Yes/No — GO TO MOTU.03; 7 (DK) → GO TO MOTU.03; 9 (R) → GO TO MOTU.03

196. MOTU.03: "Before today, have you heard of heated tobacco products?" — Yes/No — GO TO next module; 7 (DK) → GO TO next module; 9 (R) → GO TO next module

### Module 17: Firearm Safety - 3 items

197. MFS.01: "Are any firearms now kept in or around your home?" — Yes/No — 1 (Yes) → GO TO MFS.02; 2 (No) → GO TO next module; 7 (DK) → GO TO next module; 9 (R) → GO TO next module

198. MFS.02: "Are any of these firearms now loaded?" — Yes/No — 1 (Yes) → GO TO MFS.03; 2 (No) → GO TO next module; 7 (DK) → GO TO next module; 9 (R) → GO TO next module

199. MFS.03: "Are any of these loaded firearms also unlocked?" — Yes/No — GO TO next module; 7 (DK) → GO TO next module; 9 (R) → GO TO next module

### Module 18: Industry and Occupation - 2 items

Module filter: Ask only if CDEM.13=1 (employed), 2 (self-employed), or 4 (out of work <1 year).

200. MIO.01: "What kind of work do you do?" — Text — GO TO MIO.02; 99 (R) → GO TO MIO.02

201. MIO.02: "What kind of business or industry do you work in?" — Text — GO TO next module; 99 (R) → GO TO next module

### Module 19: Heart Attack and Stroke - 13 items

202. MHAS.01: "(Do you think) pain or discomfort in the jaw, neck, or back (are symptoms of a heart attack?)" — Yes/No — GO TO next; 7 (DK) → GO TO next; 9 (R) → GO TO next

203. MHAS.02: "(Do you think) feeling weak, lightheaded, or faint (are symptoms of a heart attack?)" — Yes/No — GO TO next; 7 (DK) → GO TO next; 9 (R) → GO TO next

204. MHAS.03: "(Do you think) chest pain or discomfort (are symptoms of a heart attack?)" — Yes/No — GO TO next; 7 (DK) → GO TO next; 9 (R) → GO TO next

205. MHAS.04: "(Do you think) sudden trouble seeing in one or both eyes (are symptoms of a heart attack?)" — Yes/No — GO TO next; 7 (DK) → GO TO next; 9 (R) → GO TO next

206. MHAS.05: "(Do you think) pain or discomfort in the arms or shoulder (are symptoms of a heart attack?)" — Yes/No — GO TO next; 7 (DK) → GO TO next; 9 (R) → GO TO next

207. MHAS.06: "(Do you think) shortness of breath (are symptoms of a heart attack?)" — Yes/No — GO TO next; 7 (DK) → GO TO next; 9 (R) → GO TO next

208. MHAS.07: "(Do you think) sudden confusion or trouble speaking (are symptoms of a stroke?)" — Yes/No — GO TO next; 7 (DK) → GO TO next; 9 (R) → GO TO next

209. MHAS.08: "(Do you think) sudden numbness or weakness of face, arm, or leg, especially on one side (are symptoms of a stroke?)" — Yes/No — GO TO next; 7 (DK) → GO TO next; 9 (R) → GO TO next

210. MHAS.09: "(Do you think) sudden trouble seeing in one or both eyes (is a symptom of a stroke?)" — Yes/No — GO TO next; 7 (DK) → GO TO next; 9 (R) → GO TO next

211. MHAS.10: "(Do you think) sudden chest pain or discomfort (are symptoms of a stroke?)" — Yes/No — GO TO next; 7 (DK) → GO TO next; 9 (R) → GO TO next

212. MHAS.11: "(Do you think) sudden trouble walking, dizziness, or loss of balance (is a symptom of a stroke?)" — Yes/No — GO TO next; 7 (DK) → GO TO next; 9 (R) → GO TO next

213. MHAS.12: "(Do you think) severe headache with no known cause (are symptoms of a stroke?)" — Yes/No — GO TO next; 7 (DK) → GO TO next; 9 (R) → GO TO next

214. MHAS.13: "If you thought someone was having a heart attack or a stroke, what is the first thing you would do?" — Single select {1: "Take them to the hospital", 2: "Tell them to call their doctor", 3: "Call 911", 4: "Call their spouse or family member", 5: "Do something else"} — GO TO next module; 7 (DK) → GO TO next module; 9 (R) → GO TO next module

### Module 20: Aspirin for CVD Prevention - 1 item

215. MASPRN.01: "How often do you take an aspirin to prevent or control heart disease, heart attacks or stroke?" — Single select {1: "Daily", 2: "Some days", 3: "Used to take it but stopped due to side effects", 4: "Do not take it"} — GO TO next module; 7 (DK) → GO TO next module; 9 (R) → GO TO next module

### Module 21: Sex at Birth - 1 item

Module filter: If LL10 or CP06 already coded 1 or 2 → auto-code MSAB.01 to that value, SKIP question.

216. MSAB.01: "What was your sex at birth? Was it male or female?" — Single select {1: "Male", 2: "Female"} — GO TO next module; 7 (DK) → GO TO next module; 9 (R) → GO TO next module

### Module 22: Sexual Orientation and Gender Identity (SOGI) - 3 items

217. MSOGI.FILTER1: Filter — If sex=male (LL10/CP06/CP05/LL09=1) → GO TO MSOGI.01; If sex=female → GO TO MSOGI.02; otherwise → GO TO MSOGI.03

218. MSOGI.01: "Which of the following best represents how you think of yourself?" (male version) — Single select {1: "Gay", 2: "Straight, that is, not gay", 3: "Bisexual", 4: "Something else"} — GO TO MSOGI.03; 7 (I don't know the answer) → GO TO MSOGI.03; 9 (R) → GO TO MSOGI.03

219. MSOGI.02: "Which of the following best represents how you think of yourself?" (female version) — Single select {1: "Lesbian or Gay", 2: "Straight, that is, not gay", 3: "Bisexual", 4: "Something else"} — GO TO MSOGI.03; 7 (I don't know the answer) → GO TO MSOGI.03; 9 (R) → GO TO MSOGI.03

220. MSOGI.03: "Do you consider yourself to be transgender?" — Single select {1: "Yes, male-to-female", 2: "Yes, female-to-male", 3: "Yes, gender nonconforming", 4: "No"} — GO TO next module; 7 (DK) → GO TO next module; 9 (R) → GO TO next module

### Module 23: Marijuana Use - 7 items

221. MMU.01: "During the past 30 days, on how many days did you use marijuana or cannabis?" — Numeric (01–30) — number → GO TO MMU.02; 88 (None) → GO TO next module; 77 (DK) → GO TO MMU.02; 99 (R) → GO TO MMU.02

222. MMU.02: "Did you smoke it (for example, in a joint, bong, pipe, or blunt)?" — Yes/No — GO TO MMU.03; 7 (DK) → GO TO MMU.03; 9 (R) → GO TO MMU.03

223. MMU.03: "…eat it or drink it (for example, in brownies, cakes, cookies, or candy, or in tea, cola, or alcohol)?" — Yes/No — GO TO MMU.04; 7 (DK) → GO TO MMU.04; 9 (R) → GO TO MMU.04

224. MMU.04: "…vaporize it (for example, in an e-cigarette-like vaporizer or another vaporizing device)?" — Yes/No — GO TO MMU.05; 7 (DK) → GO TO MMU.05; 9 (R) → GO TO MMU.05

225. MMU.05: "…dab it (for example, using a dabbing rig, knife, or dab pen)?" — Yes/No — GO TO MMU.06; 7 (DK) → GO TO MMU.06; 9 (R) → GO TO MMU.06

226. MMU.06: "…use it in some other way?" — Yes/No — If only 1 method answered Yes in MMU.02–06 → GO TO next module; If >1 method → GO TO MMU.07; 7 (DK) → same routing; 9 (R) → same routing

227. MMU.07: "During the past 30 days, which one of the following ways did you use marijuana the most often?" — Single select {1: "Smoke it", 2: "Eat/drink it", 3: "Vaporize it", 4: "Dab it", 5: "Use some other way"} — GO TO next module; 7 (DK) → GO TO next module; 9 (R) → GO TO next module

### Module 24: Adverse Childhood Experiences - 13 items

228. MACE.01: "Did you live with anyone who was depressed, mentally ill, or suicidal?" — Yes/No — GO TO next; 7 (DK) → GO TO next; 9 (R) → GO TO next

229. MACE.02: "Did you live with anyone who was a problem drinker or alcoholic?" — Yes/No — GO TO next; 7 (DK) → GO TO next; 9 (R) → GO TO next

230. MACE.03: "Did you live with anyone who used illegal street drugs or who abused prescription medications?" — Yes/No — GO TO next; 7 (DK) → GO TO next; 9 (R) → GO TO next

231. MACE.04: "Did you live with anyone who served time or was sentenced to serve time in a prison, jail, or other correctional facility?" — Yes/No — GO TO next; 7 (DK) → GO TO next; 9 (R) → GO TO next

232. MACE.05: "Were your parents separated or divorced?" — Single select {1: "Yes", 2: "No", 8: "Parents not married"} — GO TO next; 7 (DK) → GO TO next; 9 (R) → GO TO next

233. MACE.06: "How often did your parents or adults in your home ever slap, hit, kick, punch or beat each other up?" — Single select {1: "Never", 2: "Once", 3: "More than once"} — GO TO next; 7 (DK) → GO TO next; 9 (R) → GO TO next

234. MACE.07: "Not including spanking, how often did a parent or adult in your home ever hit, beat, kick, or physically hurt you in any way?" — Single select {1: "Never", 2: "Once", 3: "More than once"} — GO TO next; 7 (DK) → GO TO next; 9 (R) → GO TO next

235. MACE.08: "How often did a parent or adult in your home ever swear at you, insult you, or put you down?" — Single select {1: "Never", 2: "Once", 3: "More than once"} — GO TO next; 7 (DK) → GO TO next; 9 (R) → GO TO next

236. MACE.09: "How often did anyone at least 5 years older than you or an adult, ever touch you sexually?" — Single select {1: "Never", 2: "Once", 3: "More than once"} — GO TO next; 7 (DK) → GO TO next; 9 (R) → GO TO next

237. MACE.10: "How often did anyone at least 5 years older than you or an adult, try to make you touch them sexually?" — Single select {1: "Never", 2: "Once", 3: "More than once"} — GO TO next; 7 (DK) → GO TO next; 9 (R) → GO TO next

238. MACE.11: "How often did anyone at least 5 years older than you or an adult, force you to have sex?" — Single select {1: "Never", 2: "Once", 3: "More than once"} — GO TO next; 7 (DK) → GO TO next; 9 (R) → GO TO next

239. MACE.12: "For how much of your childhood was there an adult in your household who made you feel safe and protected?" — Single select {1: "Never", 2: "A little of the time", 3: "Some of the time", 4: "Most of the time", 5: "All of the time"} — GO TO next; 7 (DK) → GO TO next; 9 (R) → GO TO next

240. MACE.13: "For how much of your childhood was there an adult in your household who tried hard to make sure your basic needs were met?" — Single select {1: "Never", 2: "A little of the time", 3: "Some of the time", 4: "Most of the time", 5: "All of the time"} — GO TO next module; 7 (DK) → GO TO next module; 9 (R) → GO TO next module

### Module 25: Place of Flu Vaccination - 1 item

Module filter: Ask only if CIMM.01=1 (received flu vaccine). May be inserted after CIMM.02.

241. MFP.01: "At what kind of place did you get your last flu shot or vaccine?" — Single select {01: "Doctor's office/HMO", 02: "Health department", 03: "Clinic/health center", 04: "Senior/recreation/community center", 05: "Store (supermarket/drug store)", 06: "Hospital", 07: "Emergency room", 08: "Workplace", 09: "Some other kind of place", 11: "School", 10: "Received in Canada/Mexico"} — GO TO next module; 77 (DK) → GO TO next module; 99 (R) → GO TO next module

### Module 26: HPV Vaccination - 2 items

Module filter: Ask respondents aged 18–49 only.

242. MHPV.01: "Have you ever had an H.P.V. vaccination?" — Single select {1: "Yes", 2: "No", 3: "Doctor refused when asked"} — 1 (Yes) → GO TO MHPV.02; 2 (No) → GO TO next module; 3 → GO TO next module; 7 (DK) → GO TO next module; 9 (R) → GO TO next module

243. MHPV.02: "How many HPV shots did you receive?" — Numeric (1–2) or Single select {3: "All shots"} — GO TO next module; 77 (DK) → GO TO next module; 99 (R) → GO TO next module

### Module 27: Tetanus Diphtheria (Tdap) - 1 item

244. MTDAP.01: "Have you received a tetanus shot in the past 10 years?" — Single select {1: "Yes, received Tdap", 2: "Yes, tetanus shot but not Tdap", 3: "Yes, tetanus shot but not sure what type", 4: "No, did not receive any tetanus shot"} — GO TO next module; 7 (DK) → GO TO next module; 9 (R) → GO TO next module

### Module 28: COVID Vaccination - 3 items

245. MCOV.01: "Have you received at least one dose of a COVID-19 vaccination?" — Single select {1: "Yes", 2: "No"} — 1 (Yes) → GO TO MCOV.03; 2 (No) → GO TO MCOV.02; 7 (DK) → GO TO next module; 9 (R) → GO TO next module

246. MCOV.02: "Would you say you will definitely get a vaccine, will probably get a vaccine, will probably not get a vaccine, will definitely not get a vaccine, or are you not sure?" — Single select {1: "Will definitely get", 2: "Will probably get", 3: "Will probably not get", 4: "Will definitely not get"} — GO TO next module; 7 (DK) → GO TO next module; 9 (R) → GO TO next module

247. MCOV.03: "How many COVID-19 vaccinations have you received?" — Single select {1: "One", 2: "Two", 3: "Three", 4: "Four", 5: "Five or more"} — GO TO next module; 7 (DK) → GO TO next module; 9 (R) → GO TO next module

### Module 29: Social Determinants and Health Equity - 10 items

248. MSDHE.01: "In general, how satisfied are you with your life?" — Single select {1: "Very satisfied", 2: "Satisfied", 3: "Dissatisfied", 4: "Very dissatisfied"} — GO TO next; 7 (DK) → GO TO next; 9 (R) → GO TO next

249. MSDHE.02: "How often do you get the social and emotional support that you need?" — Single select {1: "Always", 2: "Usually", 3: "Sometimes", 4: "Rarely", 5: "Never"} — GO TO next; 7 (DK) → GO TO next; 9 (R) → GO TO next

250. MSDHE.03: "How often do you feel lonely?" — Single select {1: "Always", 2: "Usually", 3: "Sometimes", 4: "Rarely", 5: "Never"} — GO TO next; 7 (DK) → GO TO next; 9 (R) → GO TO next

251. MSDHE.04: "In the past 12 months have you lost employment or had hours reduced?" — Yes/No — GO TO next; 7 (DK) → GO TO next; 9 (R) → GO TO next

252. MSDHE.05: "During the past 12 months, have you received food stamps, also called SNAP?" — Yes/No — GO TO next; 7 (DK) → GO TO next; 9 (R) → GO TO next

253. MSDHE.06: "During the past 12 months how often did the food that you bought not last, and you didn't have money to get more?" — Single select {1: "Always", 2: "Usually", 3: "Sometimes", 4: "Rarely", 5: "Never"} — GO TO next; 7 (DK) → GO TO next; 9 (R) → GO TO next

254. MSDHE.07: "During the last 12 months, was there a time when you were not able to pay your mortgage, rent or utility bills?" — Yes/No — GO TO next; 7 (DK) → GO TO next; 9 (R) → GO TO next

255. MSDHE.08: "During the last 12 months was there a time when an electric, gas, oil, or water company threatened to shut off services?" — Yes/No — GO TO next; 7 (DK) → GO TO next; 9 (R) → GO TO next

256. MSDHE.09: "During the past 12 months has a lack of reliable transportation kept you from medical appointments, meetings, work, or from getting things needed for daily living?" — Yes/No — GO TO next; 7 (DK) → GO TO next; 9 (R) → GO TO next

257. MSDHE.10: "Within the last 30 days, how often have you felt stress?" — Single select {1: "Always", 2: "Usually", 3: "Sometimes", 4: "Rarely", 5: "Never"} — GO TO next module; 7 (DK) → GO TO next module; 9 (R) → GO TO next module

### Module 30: Reactions to Race - 6 items

258. MRTR.01: "How do other people usually classify you in this country?" — Single select {01: "White", 02: "Black or African American", 03: "Hispanic or Latino", 04: "Asian", 05: "Native Hawaiian or Other Pacific Islander", 06: "American Indian or Alaska Native", 07: "Mixed Race", 08: "Some other group"} — GO TO next; 77 (DK) → GO TO next; 99 (R) → GO TO next

259. MRTR.02: "How often do you think about your race?" — Single select {1: "Never", 2: "Once a year", 3: "Once a month", 4: "Once a week", 5: "Once a day", 6: "Once an hour", 8: "Constantly"} — GO TO next; 7 (DK) → GO TO next; 9 (R) → GO TO next

260. MRTR.03: "Within the past 12 months, do you feel that in general you were treated worse than, the same as, or better than people of other races?" — Single select {1: "Worse", 2: "The same", 3: "Better", 4: "Worse than some, better than others", 5: "Only encountered people of same race"} — GO TO next; 7 (DK) → GO TO next; 9 (R) → GO TO next

261. MRTR.04: "Within the past 12 months at work, do you feel you were treated worse than, the same as, or better than people of other races?" — Single select {1: "Worse", 2: "The same", 3: "Better", 4: "Worse than some, better than others", 5: "Only encountered people of same race"} — GO TO next; 7 (DK) → GO TO next; 9 (R) → GO TO next. Filter: Ask only if CDEM.13=1,2,or 4 (employed/self-employed/out of work <1 year)

262. MRTR.05: "Within the past 12 months, when seeking health care, do you feel your experiences were worse than, the same as, or better than for people of other races?" — Single select {1: "Worse", 2: "The same", 3: "Better", 4: "Worse than some, better than others", 5: "Only encountered people of same race"} — GO TO next; 7 (DK) → GO TO next; 9 (R) → GO TO next

263. MRTR.06: "Within the past 30 days, have you experienced any physical symptoms as a result of how you were treated based on your race?" — Yes/No — GO TO next module; 7 (DK) → GO TO next module; 9 (R) → GO TO next module

### Module 31: Random Child Selection - 6 items

Module filter: If CDEM.14=88 (no children <18) or 99 (Refused) → skip to next module. CATI selects random child by birth order.

264. MRCS.01: "What is the birth month and year of the [Xth] child?" — Date (MM/YYYY) — GO TO MRCS.02; 77/7777 (DK) → GO TO MRCS.02; 99/9999 (R) → GO TO MRCS.02

265. MRCS.02: "Is the child a boy or a girl?" — Single select {1: "Boy", 2: "Girl", 3: "Nonbinary/other"} — 1 (Boy) → GO TO MRCS.04; 2 (Girl) → GO TO MRCS.03; 3 → GO TO MRCS.03; 9 (R) → GO TO MRCS.03

266. MRCS.03: "What was the child's sex on their original birth certificate?" — Single select {1: "Boy", 2: "Girl"} — GO TO MRCS.04; 9 (R) → GO TO MRCS.04

267. MRCS.04: "Is the child Hispanic, Latino/a, or Spanish origin?" — Single select {1: "Mexican/Mexican American/Chicano/a", 2: "Puerto Rican", 3: "Cuban", 4: "Another Hispanic/Latino/a/Spanish origin", 5: "No"} — GO TO MRCS.05; 7 (DK) → GO TO MRCS.05; 9 (R) → GO TO MRCS.05

268. MRCS.05: "Which one or more of the following would you say is the race of the child?" — Multi select {10: "White", 20: "Black or African American", 30: "American Indian or Alaska Native", 40: "Asian" (41–47 subcategories), 50: "Pacific Islander" (51–54 subcategories), 60: "Other"} — GO TO MRCS.06; 77 (DK) → GO TO MRCS.06; 99 (R) → GO TO MRCS.06

269. MRCS.06: "How are you related to the child?" — Single select {1: "Parent", 2: "Grandparent", 3: "Foster parent/guardian", 4: "Sibling", 5: "Other relative", 6: "Not related"} — GO TO next module; 7 (DK) → GO TO next module; 9 (R) → GO TO next module

### Module 32: Childhood Asthma Prevalence - 2 items

Module filter: If CDEM.14=88 (None) or 99 (Refused) → skip.

270. MCAP.01: "Has a doctor, nurse or other health professional EVER said that the child has asthma?" — Yes/No — 1 (Yes) → GO TO MCAP.02; 2 (No) → GO TO next module; 7 (DK) → GO TO next module; 9 (R) → GO TO next module

271. MCAP.02: "Does the child still have asthma?" — Yes/No — GO TO Asthma Call-Back or next module; 7 (DK) → GO TO next module; 9 (R) → GO TO next module

### Asthma Call-Back Permission Script - 3 items

272. CB01.01: "Would it be okay if we called you back to ask additional asthma-related questions at a later time?" — Yes/No — 1 (Yes) → GO TO CB01.02; 2 (No) → END

273. CB01.02: "Which person in the household was selected as the focus of the asthma call-back?" — Single select {1: "Adult", 2: "Child"} — GO TO CB01.03

274. CB01.03: "Can I please have either (your/your child's) first name or initials, so we will know who to ask for when we call back?" — Text — END
