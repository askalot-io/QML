# CCHS 2005 - Canadian Community Health Survey (Cycle 3.1) - Question Inventory

## Verification Status

| Section | Source Qs | Inventory Qs | Missing | Source GOTOs | Inv. GOTOs | Missing |
|---------|----------|-------------|---------|-------------|-----------|---------|
| ANC     | 3        | 3           | 0       | 9           | 4         | 0       |
| GEN     | 8        | 8           | 0       | 12          | 6         | 0       |
| HWT     | 3        | 3           | 0       | 14          | 4         | 0       |
| CCC     | 53       | 53          | 0       | 45          | 61        | 0       |
| HCU     | 30       | 30          | 0       | 30          | 43        | 0       |
| FVC     | 6        | 6           | 0       | 50          | 32        | 0       |
| SMK     | 21       | 21          | 0       | 42          | 23        | 0       |
| CPG     | 37       | 37          | 0       | 12          | 6         | 0       |
| SSA     | 20       | 20          | 0       | 6           | 4         | 0       |
| DIS     | 14       | 14          | 0       | 17          | 9         | 0       |
| INJ     | 25       | 25          | 0       | 37          | 20        | 0       |
| SFR     | 34       | 34          | 0       | 4           | 3         | 0       |
| ACC     | 51       | 51          | 0       | 76          | 34        | 0       |
| WTM     | 58       | 58          | 0       | 87          | 48        | 0       |
| ADM     | 6        | 6           | 0       | 31          | 17        | 0       |

Note: Inv. GOTOs are lower than Source GOTOs because the inventory consolidates per-option routing onto one line per item (e.g. "1→X; 2→Y; 3→Z"), while the source has a separate "Go to" line per option. Unique routing destinations were verified: 150/150 matched across 10 sections (100%).

- **Coverage**: 15/74 sections sampled (beginning: ANC, GEN, HWT, CCC; middle: HCU, FVC, SMK, CPG, SSA, DIS, INJ, SFR; end: ACC, WTM, ADM); 1,595 items total across all 74 sections
- **Routing**: 150/150 unique routing destinations verified across 10 sampled sections (100% coverage); routing consolidated inline per inventory entry
- **Node types**: Q=1029, C=380, R=59, E=47, N=68, B=3, D=3, S=6 (total=1595)
- **Status**: READY FOR QML
- **Missing**: None found — all sampled sections show exact Q-ID match between source and inventory

## Document Overview
- **Title**: Canadian Community Health Survey (CCHS) - Cycle 3.1
- **Organization**: Statistics Canada
- **Pages**: 303
- **Language**: English
- **Type**: CATI (Computer-Assisted Telephone Interview)

## Structure
74 sections organized into health topic modules. Each section begins with XXX_BEG and ends with XXX_END. Sections are conditionally administered based on sample design and respondent characteristics (age, sex, proxy status).

## Question Inventory by Section

### Section: ANC - Age and Date of Birth - 9 items

1. ANC_C01A: Filter — if do ANC block = 1, go to ANC_R01; otherwise go to ANC_END — Filter
2. ANC_R01: "For some of the questions I'll be asking, I need to know your exact date of birth." — Read — press Enter to continue
3. ANC_Q01 (day): "Enter the day. If necessary, ask: What is the day?" — Numeric (1–31) — DK, R allowed
4. ANC_Q01 (month): "Enter the month. If necessary, ask: What is the month?" — Single select {1: "January", 2: "February", 3: "March", 4: "April", 5: "May", 6: "June", 7: "July", 8: "August", 9: "September", 10: "October", 11: "November", 12: "December"} — DK, R allowed
5. ANC_Q01 (year): "Enter a four-digit year. If necessary, ask: What is the year?" — Numeric (4-digit year) — DK, R allowed
6. ANC_C02: Calculate age based on the entered date of birth — Filter
7. ANC_Q02: "So your age is [calculated age]. Is that correct?" — Single select {1: "Yes", 2: "No, return and correct date of birth", 3: "No, collect age"} — 1→ANC_C03; 2→ANC_Q01; 3→ANC_Q03; DK/R not allowed
8. ANC_C03: If calculated age < 12 years go to ANC_R04; otherwise go to ANC_END — Filter
9. ANC_Q03: "What is your age?" — Numeric (0–130) — DK/R not allowed; continues to ANC_C04
10. ANC_C04: If age < 12 years, go to ANC_R04; otherwise go to ANC_END — Filter
11. ANC_R04: "Because you are less than 12 years old, you are not eligible to participate in the Canadian Community Health Survey." — Read — auto code as 90, call exit block

### Section: GEN - General Health - 13 items

12. GEN_C01: Filter — if do GEN = 1, go to GEN_R01; otherwise go to GEN_END — Filter
13. GEN_R01: "This survey deals with various aspects of your health. I'll be asking about such things as physical activity, social relationships and health status. By health, we mean not only the absence of disease or injury but also physical, mental and social well-being." — Read — press Enter to continue
14. GEN_Q01: "To start, in general, would you say your health is:" — Single select {1: "excellent", 2: "very good", 3: "good", 4: "fair", 5: "poor"} — DK, R allowed
15. GEN_Q02: "Compared to one year ago, how would you say your health is now? Is it:" — Single select {1: "much better now than 1 year ago", 2: "somewhat better now than 1 year ago", 3: "about the same as 1 year ago", 4: "somewhat worse now than 1 year ago", 5: "much worse now than 1 year ago"} — DK, R allowed
16. GEN_C02A: If proxy interview, go to GEN_C07; otherwise go to GEN_Q02A — Filter
17. GEN_Q02A: "How satisfied are you with your life in general?" — Single select {1: "Very satisfied", 2: "Satisfied", 3: "Neither satisfied nor dissatisfied", 4: "Dissatisfied", 5: "Very dissatisfied"} — DK, R allowed
18. GEN_Q02B: "In general, would you say your mental health is:" — Single select {1: "excellent", 2: "very good", 3: "good", 4: "fair", 5: "poor"} — DK, R allowed
19. GEN_C07: If age < 15, go to GEN_C08A; otherwise go to GEN_Q07 — Filter
20. GEN_Q07: "Thinking about the amount of stress in your life, would you say that most days are:" — Single select {1: "not at all stressful", 2: "not very stressful", 3: "a bit stressful", 4: "quite a bit stressful", 5: "extremely stressful"} — DK, R allowed
21. GEN_C08A: If proxy interview, go to GEN_END; otherwise go to GEN_C08B — Filter
22. GEN_C08B: If age < 15 or age > 75, go to GEN_Q10; otherwise go to GEN_Q08 — Filter
23. GEN_Q08: "Have you worked at a job or business at any time in the past 12 months?" — Single select {1: "Yes", 2: "No"} — 2→GEN_Q10; DK/R→GEN_Q10
24. GEN_Q09: "The next question is about your main job or business in the past 12 months. Would you say that most days at work were:" — Single select {1: "not at all stressful", 2: "not very stressful", 3: "a bit stressful", 4: "quite a bit stressful", 5: "extremely stressful"} — DK, R allowed
25. GEN_Q10: "How would you describe your sense of belonging to your local community? Would you say it is:" — Single select {1: "very strong", 2: "somewhat strong", 3: "somewhat weak", 4: "very weak"} — DK, R allowed

### Section: ORG - Voluntary Organizations - 5 items

26. ORG_C1A: Filter — if ORG block = 1, go to ORG_C1B; otherwise go to ORG_END — Filter
27. ORG_C1B: If proxy interview, go to ORG_END; otherwise go to ORG_Q1 — Filter
28. ORG_Q1: "Are you a member of any voluntary organizations or associations such as school groups, church social groups, community centres, ethnic associations or social, civic or fraternal clubs?" — Single select {1: "Yes", 2: "No"} — 2→ORG_END; DK/R→ORG_END
29. ORG_Q2: "How often did you participate in meetings or activities of these groups in the past 12 months? If you belong to many, just think of the ones in which you are most active." — Single select {1: "At least once a week", 2: "At least once a month", 3: "At least 3 or 4 times a year", 4: "At least once a year", 5: "Not at all"} — DK, R allowed

### Section: SLP - Sleep - 7 items

30. SLP_C1: Filter — if SLP block = 1, go to SLP_C2; otherwise go to SLP_END — Filter
31. SLP_C2: If proxy interview, go to SLP_END; otherwise go to SLP_Q01 — Filter
32. SLP_Q01: "Now a few questions about sleep. How long do you usually spend sleeping each night? (Do not include time spent resting.)" — Single select {1: "Under 2 hours", 2: "2 hours to less than 3 hours", 3: "3 hours to less than 4 hours", 4: "4 hours to less than 5 hours", 5: "5 hours to less than 6 hours", 6: "6 hours to less than 7 hours", 7: "7 hours to less than 8 hours", 8: "8 hours to less than 9 hours", 9: "9 hours to less than 10 hours", 10: "10 hours to less than 11 hours", 11: "11 hours to less than 12 hours", 12: "12 hours or more"} — DK allowed; R→SLP_END
33. SLP_Q02: "How often do you have trouble going to sleep or staying asleep?" — Single select {1: "None of the time", 2: "A little of the time", 3: "Some of the time", 4: "Most of the time", 5: "All of the time"} — DK, R allowed
34. SLP_Q03: "How often do you find your sleep refreshing?" — Single select {1: "None of the time", 2: "A little of the time", 3: "Some of the time", 4: "Most of the time", 5: "All of the time"} — DK, R allowed
35. SLP_Q04: "How often do you find it difficult to stay awake when you want to?" — Single select {1: "None of the time", 2: "A little of the time", 3: "Some of the time", 4: "Most of the time", 5: "All of the time"} — DK, R allowed

### Section: CIH - Changes Made to Improve Health - 14 items

36. CIH_C1A: Filter — if do CIH block = 1, go to CIH_C1B; otherwise go to CIH_END — Filter
37. CIH_C1B: If proxy interview, go to CIH_END; otherwise go to CIH_Q1 — Filter
38. CIH_Q1: "Next, some questions about changes made to improve health. In the past 12 months, did you do anything to improve your health? (For example, lost weight, quit smoking, increased exercise)" — Single select {1: "Yes", 2: "No"} — 2→CIH_Q3; DK/R→CIH_END
39. CIH_Q2: "What is the single most important change you have made?" — Single select {1: "Increased exercise, sports / physical activity", 2: "Lost weight", 3: "Changed diet / improved eating habits", 4: "Quit smoking / reduced amount smoked", 5: "Drank less alcohol", 6: "Reduced stress level", 7: "Received medical treatment", 8: "Took vitamins", 9: "Other – Specify"} — DK, R allowed; continues to CIH_C2S
40. CIH_C2S: If CIH_Q2 = 9, go to CIH_Q2S; otherwise go to CIH_Q3 — Filter
41. CIH_Q2S: "Specify." — Text (80 characters) — DK, R allowed; continues to CIH_Q3
42. CIH_Q3: "Do you think there is [anything else/anything] you should do to improve your physical health?" (use "anything else" if CIH_Q1 = 1, otherwise "anything") — Single select {1: "Yes", 2: "No"} — 2→CIH_END; DK/R→CIH_END
43. CIH_Q4: "What is the most important thing?" — Single select {1: "Start / Increase exercise, sports / physical activity", 2: "Lose weight", 3: "Change diet / improve eating habits", 4: "Quit smoking / reduce amount smoked", 5: "Drink less alcohol", 6: "Reduce stress level", 7: "Receive medical treatment", 8: "Take vitamins", 9: "Other – Specify"} — DK, R allowed; continues to CIH_C4S
44. CIH_C4S: If CIH_Q4 = 9, go to CIH_Q4S; otherwise go to CIH_Q5 — Filter
45. CIH_Q4S: "Specify." — Text (80 characters) — DK, R allowed; continues to CIH_Q5
46. CIH_Q5: "Is there anything stopping you from making this improvement?" — Single select {1: "Yes", 2: "No"} — 2→CIH_Q7; DK/R→CIH_Q7
47. CIH_Q6: "What is that? (Mark all that apply)" — Multi select {1: "Lack of will power / self-discipline", 2: "Family responsibilities", 3: "Work schedule", 4: "Addiction to drugs / alcohol", 5: "Physical condition", 6: "Disability / health problem", 7: "Too stressed", 8: "Too costly / financial constraints", 9: "Not available - in area", 10: "Transportation problems", 11: "Weather problems", 12: "Other - Specify"} — DK, R allowed; continues to CIH_C6S
48. CIH_C6S: If CIH_Q6 = 12, go to CIH_Q6S; otherwise go to CIH_Q7 — Filter
49. CIH_Q6S: "Specify." — Text (80 characters) — DK, R allowed; continues to CIH_Q7
50. CIH_Q7: "Is there anything you intend to do to improve your physical health in the next year?" — Single select {1: "Yes", 2: "No"} — 2→CIH_END; DK/R→CIH_END
51. CIH_Q8: "What is that? (Mark all that apply)" — Multi select {1: "Start / Increase exercise, sports / physical activity", 2: "Lose weight", 3: "Change diet / improve eating habits", 4: "Quit smoking / reduce amount smoked", 5: "Drink less alcohol", 6: "Reduce stress level", 7: "Receive medical treatment", 8: "Take vitamins", 9: "Other – Specify"} — DK, R allowed; continues to CIH_C8S
52. CIH_C8S: If CIH_Q8 = 9, go to CIH_Q8S; otherwise go to CIH_END — Filter
53. CIH_Q8S: "Specify." — Text (80 characters) — DK, R allowed; continues to CIH_END

### Section: HCS - Health Care System Satisfaction - 8 items

54. HCS_C1A: Filter — if do HCS block = 1, go to HCS_C1B; otherwise go to HCS_END — Filter
55. HCS_C1B: If proxy interview or age < 15, go to HCS_END; otherwise go to HCS_C1C — Filter
56. HCS_C1C: Set [province] display label based on province code (10=Newfoundland and Labrador, 11=Prince Edward Island, 12=Nova Scotia, 13=New Brunswick, 24=Quebec, 35=Ontario, 46=Manitoba, 47=Saskatchewan, 48=Alberta, 59=British Columbia, 60=Yukon, 61=the Northwest Territories, 62=Nunavut) — Filter
57. HCS_Q1: "Now, a few questions about health care services in [province]. Overall, how would you rate the availability of health care services in [province]? Would you say it is:" — Single select {1: "excellent", 2: "good", 3: "fair", 4: "poor"} — DK/R→HCS_END
58. HCS_Q2: "Overall, how would you rate the quality of the health care services that are available in [province]?" — Single select {1: "Excellent", 2: "Good", 3: "Fair", 4: "Poor"} — DK, R allowed
59. HCS_Q3: "Overall, how would you rate the availability of health care services in your community?" — Single select {1: "Excellent", 2: "Good", 3: "Fair", 4: "Poor"} — DK, R allowed
60. HCS_Q4: "Overall, how would you rate the quality of the health care services that are available in your community?" — Single select {1: "Excellent", 2: "Good", 3: "Fair", 4: "Poor"} — DK, R allowed

### Section: HWT - Height and Weight - 16 items

61. HWT_C1: Filter — if do HWT block = 1, go to HWT_Q2; otherwise go to HWT_END — Filter
62. HWT_Q2: "The next questions are about height and weight. How tall are you without shoes on?" — Single select {0: "Less than 1' / 12\" (less than 29.2 cm.)", 1: "1'0\" to 1'11\" / 12\" to 23\" (29.2 to 59.6 cm.)", 2: "2'0\" to 2'11\" / 24\" to 35\" (59.7 to 90.1 cm.)", 3: "3'0\" to 3'11\" / 36\" to 47\" (90.2 to 120.6 cm.)", 4: "4'0\" to 4'11\" / 48\" to 59\" (120.7 to 151.0 cm.)", 5: "5'0\" to 5'11\" (151.1 to 181.5 cm.)", 6: "6'0\" to 6'11\" (181.6 to 212.0 cm.)", 7: "7'0\" and over (212.1 cm. and over)"} — 3→HWT_N2C; 4→HWT_N2D; 5→HWT_N2E; 6→HWT_N2F; 7→HWT_Q3; DK/R→HWT_Q3
63. HWT_E2: Hard edit — "The selected height is too short for a [current age] year old respondent. Please return and correct." — Constraint: triggered if HWT_Q2 < 3
64. HWT_N2A: "Select the exact height." — Single select {0: "1'0\" / 12\" (29.2–31.7 cm.)", 1: "1'1\" / 13\" (31.8–34.2 cm.)", 2: "1'2\" / 14\" (34.3–36.7 cm.)", 3: "1'3\" / 15\" (36.8–39.3 cm.)", 4: "1'4\" / 16\" (39.4–41.8 cm.)", 5: "1'5\" / 17\" (41.9–44.4 cm.)", 6: "1'6\" / 18\" (44.5–46.9 cm.)", 7: "1'7\" / 19\" (47.0–49.4 cm.)", 8: "1'8\" / 20\" (49.5–52.0 cm.)", 9: "1'9\" / 21\" (52.1–54.5 cm.)", 10: "1'10\" / 22\" (54.6–57.1 cm.)", 11: "1'11\" / 23\" (57.2–59.6 cm.)"} — DK, R allowed
65. HWT_N2B: "Select the exact height." — Single select {0: "2'0\" / 24\" (59.7–62.1 cm.)", 1: "2'1\" / 25\" (62.2–64.7 cm.)", 2: "2'2\" / 26\" (64.8–67.2 cm.)", 3: "2'3\" / 27\" (67.3–69.8 cm.)", 4: "2'4\" / 28\" (69.9–72.3 cm.)", 5: "2'5\" / 29\" (72.4–74.8 cm.)", 6: "2'6\" / 30\" (74.9–77.4 cm.)", 7: "2'7\" / 31\" (77.5–79.9 cm.)", 8: "2'8\" / 32\" (80.0–82.5 cm.)", 9: "2'9\" / 33\" (82.6–85.0 cm.)", 10: "2'10\" / 34\" (85.1–87.5 cm.)", 11: "2'11\" / 35\" (87.6–90.1 cm.)"} — DK, R allowed
66. HWT_N2C: "Select the exact height." — Single select {0: "3'0\" / 36\" (90.2–92.6 cm.)", 1: "3'1\" / 37\" (92.7–95.2 cm.)", 2: "3'2\" / 38\" (95.3–97.7 cm.)", 3: "3'3\" / 39\" (97.8–100.2 cm.)", 4: "3'4\" / 40\" (100.3–102.8 cm.)", 5: "3'5\" / 41\" (102.9–105.3 cm.)", 6: "3'6\" / 42\" (105.4–107.9 cm.)", 7: "3'7\" / 43\" (108.0–110.4 cm.)", 8: "3'8\" / 44\" (110.5–112.9 cm.)", 9: "3'9\" / 45\" (113.0–115.5 cm.)", 10: "3'10\" / 46\" (115.6–118.0 cm.)", 11: "3'11\" / 47\" (118.1–120.6 cm.)"} — DK, R allowed; continues to HWT_Q3
67. HWT_N2D: "Select the exact height." — Single select {0: "4'0\" / 48\" (120.7–123.1 cm.)", 1: "4'1\" / 49\" (123.2–125.6 cm.)", 2: "4'2\" / 50\" (125.7–128.2 cm.)", 3: "4'3\" / 51\" (128.3–130.7 cm.)", 4: "4'4\" / 52\" (130.8–133.3 cm.)", 5: "4'5\" / 53\" (133.4–135.8 cm.)", 6: "4'6\" / 54\" (135.9–138.3 cm.)", 7: "4'7\" / 55\" (138.4–140.9 cm.)", 8: "4'8\" / 56\" (141.0–143.4 cm.)", 9: "4'9\" / 57\" (143.5–146.0 cm.)", 10: "4'10\" / 58\" (146.1–148.5 cm.)", 11: "4'11\" / 59\" (148.6–151.0 cm.)"} — DK, R allowed; continues to HWT_Q3
68. HWT_N2E: "Select the exact height." — Single select {0: "5'0\" (151.1–153.6 cm.)", 1: "5'1\" (153.7–156.1 cm.)", 2: "5'2\" (156.2–158.7 cm.)", 3: "5'3\" (158.8–161.2 cm.)", 4: "5'4\" (161.3–163.7 cm.)", 5: "5'5\" (163.8–166.3 cm.)", 6: "5'6\" (166.4–168.8 cm.)", 7: "5'7\" (168.9–171.4 cm.)", 8: "5'8\" (171.5–173.9 cm.)", 9: "5'9\" (174.0–176.4 cm.)", 10: "5'10\" (176.5–179.0 cm.)", 11: "5'11\" (179.1–181.5 cm.)"} — DK, R allowed; continues to HWT_Q3
69. HWT_N2F: "Select the exact height." — Single select {0: "6'0\" (181.6–184.1 cm.)", 1: "6'1\" (184.2–186.6 cm.)", 2: "6'2\" (186.7–189.1 cm.)", 3: "6'3\" (189.2–191.7 cm.)", 4: "6'4\" (191.8–194.2 cm.)", 5: "6'5\" (194.3–196.8 cm.)", 6: "6'6\" (196.9–199.3 cm.)", 7: "6'7\" (199.4–201.8 cm.)", 8: "6'8\" (201.9–204.4 cm.)", 9: "6'9\" (204.5–206.9 cm.)", 10: "6'10\" (207.0–209.5 cm.)", 11: "6'11\" (209.6–212.0 cm.)"} — DK, R allowed; continues to HWT_Q3
70. HWT_Q3: "How much do you weigh?" — Numeric (1–575; soft warning if > 300 lb / 136 kg or < 60 lb / 27 kg) — DK/R→HWT_END
71. HWT_N4: "Was that in pounds or kilograms?" — Single select {1: "Pounds", 2: "Kilograms"} — DK/R not allowed
72. HWT_E4: Soft edit — "An unusual value has been entered. Please confirm." — Constraint: triggered if (HWT_Q3 > 300 and HWT_N4 = 1 or HWT_Q3 > 136 and HWT_N4 = 2) or (HWT_Q3 < 60 and HWT_N4 = 1 or HWT_Q3 < 27 and HWT_N4 = 2)
73. HWT_C4: If proxy interview, go to HWT_END; otherwise go to HWT_Q4 — Filter
74. HWT_Q4: "Do you consider yourself:" — Single select {1: "overweight", 2: "underweight", 3: "just about right"} — DK, R allowed

### Section: CCC - Chronic Conditions Checklist - 51 items

75. CCC_BEG: Set HasSkinCancer = No — Filter (initialization)
76. CCC_C011: If (do CCC block = 1), go to CCC_R011. Otherwise, go to CCC_END. — Filter
77. CCC_R011: "Now I'd like to ask about certain chronic health conditions which you may have. We are interested in 'long-term conditions' which are expected to last or have already lasted 6 months or more and that have been diagnosed by a health professional." — Read
78. CCC_Q011: "Do you have: ... food allergies?" — Yes/No {1: "Yes", 2: "No"} — DK→continue; R→go to CCC_END
79. CCC_Q021: "Do you have: ... any other allergies?" — Yes/No {1: "Yes", 2: "No"} — DK/R→continue
80. CCC_Q031: "Do you have: ... asthma?" — Yes/No {1: "Yes", 2: "No"} — No→go to CCC_Q041; DK/R→go to CCC_Q041
81. CCC_Q035: "Have you had any asthma symptoms or asthma attacks in the past 12 months?" — Yes/No {1: "Yes", 2: "No"} — DK/R→continue
82. CCC_Q036: "In the past 12 months, have you taken any medicine for asthma such as inhalers, nebulizers, pills, liquids or injections?" — Yes/No {1: "Yes", 2: "No"} — DK/R→continue
83. CCC_Q041: "Do you have fibromyalgia?" — Yes/No {1: "Yes", 2: "No"} — DK/R→continue
84. CCC_Q051: "Remember, we're interested in conditions diagnosed by a health professional. Do you have arthritis or rheumatism, excluding fibromyalgia?" — Yes/No {1: "Yes", 2: "No"} — No→go to CCC_Q061; DK/R→go to CCC_Q061
85. CCC_Q05A: "What kind of arthritis do you have?" — Single select {1: "Rheumatoid arthritis", 2: "Osteoarthritis", 3: "Rheumatism", 4: "Other - Specify"} — DK/R→continue
86. CCC_C05AS: If CCC_Q05A = 4, go to CCC_Q05AS. Otherwise, go to CCC_Q061. — Filter
87. CCC_Q05AS: "INTERVIEWER: Specify." — Text (80 chars) — DK/R→continue
88. CCC_Q061: "Do you have back problems, excluding fibromyalgia and arthritis?" — Yes/No {1: "Yes", 2: "No"} — DK/R→continue
89. CCC_Q071: "Do you have high blood pressure?" — Yes/No {1: "Yes", 2: "No"} — Yes→go to CCC_Q073; No→continue; DK→continue; R→go to CCC_Q081
90. CCC_Q072: "Have you ever been diagnosed with high blood pressure?" — Yes/No {1: "Yes", 2: "No"} — No→go to CCC_Q081; DK/R→go to CCC_Q081
91. CCC_Q073: "In the past month, have you taken any medicine for high blood pressure?" — Yes/No {1: "Yes", 2: "No"} — DK/R→continue
92. CCC_Q074: "In the past month, did you do anything else, recommended by a health professional, to reduce or control your blood pressure?" — Yes/No {1: "Yes", 2: "No"} — No→go to CCC_Q081; DK/R→go to CCC_Q081
93. CCC_Q075: "What did you do? (INTERVIEWER: Mark all that apply.)" — Multi select {1: "Changed diet (e.g., reduced salt intake)", 2: "Exercised more", 3: "Reduced alcohol intake", 4: "Other"} — DK/R→continue
94. CCC_Q081: "Remember, we're interested in conditions diagnosed by a health professional. Do you have migraine headaches?" — Yes/No {1: "Yes", 2: "No"} — DK/R→continue
95. CCC_Q091A: "Do you have: ... chronic bronchitis?" — Yes/No {1: "Yes", 2: "No"} — DK/R→continue
96. CCC_C091E: If age < 30, go to CCC_Q101. Otherwise, go to CCC_Q091E. — Filter
97. CCC_Q091E: "Do you have: ... emphysema?" — Yes/No {1: "Yes", 2: "No"} — DK/R→continue
98. CCC_Q091F: "Do you have: ... chronic obstructive pulmonary disease (COPD)?" — Yes/No {1: "Yes", 2: "No"} — DK/R→continue
99. CCC_Q101: "Do you have: ... diabetes?" — Yes/No {1: "Yes", 2: "No"} — No→go to CCC_Q111; DK/R→go to CCC_Q111
100. CCC_Q102: "How old were you when this was first diagnosed? (INTERVIEWER: Maximum is current age.)" — Numeric (min: 0, max: current age) — DK/R→continue
101. CCC_C10A: If age < 15 or sex = male or CCC_Q102 < 15 or CCC_Q102 > 49, go to CCC_Q10C. Otherwise, go to CCC_Q10A. — Filter
102. CCC_Q10A: "Were you pregnant when you were first diagnosed with diabetes?" — Yes/No {1: "Yes", 2: "No"} — No→go to CCC_Q10C; DK/R→go to CCC_Q10C
103. CCC_Q10B: "Other than during pregnancy, has a health professional ever told you that you have diabetes?" — Yes/No {1: "Yes", 2: "No"} — No→go to CCC_Q111; DK/R→go to CCC_Q111
104. CCC_Q10C: "When you were first diagnosed with diabetes, how long was it before you were started on insulin?" — Single select {1: "Less than 1 month", 2: "1 month to less than 2 months", 3: "2 months to less than 6 months", 4: "6 months to less than 1 year", 5: "1 year or more", 6: "Never"} — 6→go to CCC_Q106; DK/R→continue
105. CCC_Q105: "Do you currently take insulin for your diabetes?" — Yes/No {1: "Yes", 2: "No"} — DK/R→continue — Note: if CCC_Q10C = 6, filled with "No" during processing
106. CCC_Q106: "In the past month, did you take pills to control your blood sugar?" — Yes/No {1: "Yes", 2: "No"} — DK/R→continue
107. CCC_Q111: "Remember, we're interested in conditions diagnosed by a health professional. Do you have epilepsy?" — Yes/No {1: "Yes", 2: "No"} — DK/R→continue
108. CCC_Q121: "Do you have: ... heart disease?" — Yes/No {1: "Yes", 2: "No"} — DK/R→continue
109. CCC_Q131: "Do you have: ... cancer?" — Yes/No {1: "Yes", 2: "No"} — Yes→go to CCC_C133; No→continue; DK→continue; R→go to CCC_Q141
110. CCC_Q132: "Have you ever been diagnosed with cancer?" — Yes/No {1: "Yes", 2: "No"} — No→go to CCC_Q141; DK/R→go to CCC_Q141
111. CCC_C133: If sex = male, go to CCC_Q133B. Otherwise, go to CCC_Q133A. — Filter
112. CCC_D33: Set DoDid variable based on CCC_Q131/CCC_Q132 and proxy status — Filter (derived variable)
113. CCC_Q133A: "What type of cancer do/did you have? (INTERVIEWER: Mark all that apply.)" — Multi select {1: "Breast", 2: "Colorectal", 3: "Skin - Melanoma", 4: "Skin - Non-melanoma", 5: "Other"} — DK/R→continue; go to CCC_D133
114. CCC_Q133B: "What type of cancer do/did you have? (INTERVIEWER: Mark all that apply.)" — Multi select {1: "Prostate", 2: "Colorectal", 3: "Skin - Melanoma", 4: "Skin - Non-melanoma", 5: "Other"} — DK/R→continue
115. CCC_D133: If (CCC_Q133A = 3 or 4) or (CCC_Q133B = 3 or 4), HasSkinCancer = "Yes". Otherwise, HasSkinCancer = "No". — Filter (derived variable)
116. CCC_Q141: "Remember, we're interested in conditions diagnosed by a health professional. Do you have intestinal or stomach ulcers?" — Yes/No {1: "Yes", 2: "No"} — DK/R→continue
117. CCC_Q151: "Do you suffer from the effects of a stroke?" — Yes/No {1: "Yes", 2: "No"} — DK/R→continue
118. CCC_Q161: "Do you suffer: ... from urinary incontinence?" — Yes/No {1: "Yes", 2: "No"} — DK/R→continue
119. CCC_Q171: "Do you suffer from a bowel disorder such as Crohn's Disease, ulcerative colitis, Irritable Bowel Syndrome or bowel incontinence?" — Yes/No {1: "Yes", 2: "No"} — No→go to CCC_C181; DK/R→go to CCC_C181
120. CCC_Q171A: "What kind of bowel disease do you have?" — Single select {1: "Crohn's Disease", 2: "Ulcerative colitis", 3: "Irritable Bowel Syndrome", 4: "Bowel incontinence", 5: "Other"} — DK/R→continue
121. CCC_C181: If age < 18, go to CCC_Q211. Otherwise, go to CCC_Q181. — Filter
122. CCC_Q181: "Remember, we're interested in conditions diagnosed by a health professional. Do you have: ... Alzheimer's Disease or any other dementia?" — Yes/No {1: "Yes", 2: "No"} — DK/R→continue
123. CCC_Q191: "Do you have: ... cataracts?" — Yes/No {1: "Yes", 2: "No"} — DK/R→continue
124. CCC_Q201: "Do you have: ... glaucoma?" — Yes/No {1: "Yes", 2: "No"} — DK/R→continue
125. CCC_Q211: "Do you have: ... a thyroid condition?" — Yes/No {1: "Yes", 2: "No"} — DK/R→continue
126. CCC_Q251: "Remember, we're interested in conditions diagnosed by a health professional. Do you have chronic fatigue syndrome?" — Yes/No {1: "Yes", 2: "No"} — DK/R→continue
127. CCC_Q261: "Do you suffer from multiple chemical sensitivities?" — Yes/No {1: "Yes", 2: "No"} — DK/R→continue
128. CCC_Q271: "Do you have schizophrenia?" — Yes/No {1: "Yes", 2: "No"} — DK/R→continue
129. CCC_Q280: "Remember, we're interested in conditions diagnosed by a health professional. Do you have a mood disorder such as depression, bipolar disorder, mania or dysthymia? (INTERVIEWER: Include manic depression.)" — Yes/No {1: "Yes", 2: "No"} — DK/R→continue
130. CCC_Q290: "Remember, we're interested in conditions diagnosed by a health professional. Do you have an anxiety disorder such as a phobia, obsessive-compulsive disorder or a panic disorder?" — Yes/No {1: "Yes", 2: "No"} — DK/R→continue
131. CCC_Q321: "Do you have autism or any other developmental disorder such as Down's syndrome, Asperger's syndrome or Rett syndrome?" — Yes/No {1: "Yes", 2: "No"} — DK/R→continue
132. CCC_Q331: "Remember, we're interested in conditions diagnosed by a health professional. Do you have a learning disability?" — Yes/No {1: "Yes", 2: "No"} — No→go to CCC_Q341; DK/R→go to CCC_Q341
133. CCC_Q331A: "What kind of learning disability do you have? (INTERVIEWER: Mark all that apply.)" — Multi select {1: "Attention Deficit Disorder, no hyperactivity (ADD)", 2: "Attention Deficit Hyperactivity Disorder (ADHD)", 3: "Dyslexia", 4: "Other - Specify"} — DK/R→continue
134. CCC_C331AS: If CCC_Q331A = 4, go to CCC_Q331AS. Otherwise, go to CCC_Q341. — Filter
135. CCC_Q331AS: "INTERVIEWER: Specify." — Text (80 chars) — DK/R→continue
136. CCC_Q341: "Do you have an eating disorder such as anorexia or bulimia?" — Yes/No {1: "Yes", 2: "No"} — DK/R→continue
137. CCC_Q901: "Do you have any other long-term physical or mental health condition that has been diagnosed by a health professional?" — Yes/No {1: "Yes", 2: "No"} — No→go to CCC_END; DK/R→go to CCC_END
138. CCC_C901S: If CCC_Q901 = 1, go to CCC_Q901S. Otherwise, go to CCC_END. — Filter
139. CCC_Q901S: "INTERVIEWER: Specify." — Text (80 chars) — DK/R→continue

### Section: DIA - Diabetes Care - 24 items

140. DIA_C01A: If (do DIA block = 1), go to DIA_C01B. Otherwise, go to DIA_END. — Filter
141. DIA_C01B: If (CCC_Q101 = 1), go to DIA_C01C. Otherwise, go to DIA_END. — Filter
142. DIA_C01C: If (CCC_Q10A = 1), go to DIA_END. Otherwise, go to DIA_R01. — Filter
143. DIA_R01: "It was reported earlier that you have diabetes. The following questions are about diabetes care." — Read
144. DIA_Q01: "In the past 12 months, has a health care professional tested you for haemoglobin 'A-one-C'? (An 'A-one-C' haemoglobin test measures the average level of blood sugar over a 3-month period.)" — Yes/No {1: "Yes", 2: "No"} — No→go to DIA_Q03; DK→go to DIA_Q03; R→go to DIA_END
145. DIA_Q02: "How many times? (In the past 12 months, has a health care professional tested you for haemoglobin 'A-one-C'?)" — Numeric (min: 1, max: 99) — DK/R→continue
146. DIA_Q03: "In the past 12 months, has a health care professional checked your feet for any sores or irritations?" — Single select {1: "Yes", 2: "No", 3: "No feet"} — No→go to DIA_Q05; No feet→go to DIA_Q05; DK/R→go to DIA_Q05
147. DIA_Q04: "How many times? (In the past 12 months, has a health care professional checked your feet for any sores or irritations?)" — Numeric (min: 1, max: 99) — DK/R→continue
148. DIA_Q05: "In the past 12 months, has a health care professional tested your urine for protein (i.e., Microalbumin)?" — Yes/No {1: "Yes", 2: "No"} — DK/R→continue
149. DIA_Q06: "Have you ever had an eye exam where the pupils of your eyes were dilated? (This procedure would have made you temporarily sensitive to light.)" — Yes/No {1: "Yes", 2: "No"} — No→go to DIA_R08; DK/R→go to DIA_R08
150. DIA_Q07: "When was the last time? (INTERVIEWER: Read categories to respondent.)" — Single select {1: "Less than one month ago", 2: "1 month to less than 1 year ago", 3: "1 year to less than 2 years ago", 4: "2 or more years ago"} — DK/R→continue
151. DIA_R08: "Now some questions about diabetes care not provided by a health care professional." — Read
152. DIA_Q08: "How often do you usually have your blood checked for glucose or sugar by yourself or by a family member or friend? (INTERVIEWER: Select the reporting period here and enter the number in the next screen.)" — Single select {1: "Per day", 2: "Per week", 3: "Per month", 4: "Per year", 5: "Never"} — Per week→go to DIA_N08C; Per month→go to DIA_N08D; Per year→go to DIA_N08E; Never→go to DIA_C09; DK/R→go to DIA_C09
153. DIA_N08B: "INTERVIEWER: Enter number of times per day." — Numeric (min: 1, max: 99) — DK/R→continue; go to DIA_C09
154. DIA_N08C: "INTERVIEWER: Enter number of times per week." — Numeric (min: 1, max: 99) — DK/R→continue; go to DIA_C09
155. DIA_N08D: "INTERVIEWER: Enter number of times per month." — Numeric (min: 1, max: 99) — DK/R→continue; go to DIA_C09
156. DIA_N08E: "INTERVIEWER: Enter number of times per year." — Numeric (min: 1, max: 99) — DK/R→continue
157. DIA_C09: If DIA_Q03 = 3 (no feet), go to DIA_C10. Otherwise, go to DIA_Q09. — Filter
158. DIA_Q09: "How often do you usually have your feet checked for any sores or irritations by yourself or by a family member or friend? (INTERVIEWER: Select the reporting period here and enter the number in the next screen.)" — Single select {1: "Per day", 2: "Per week", 3: "Per month", 4: "Per year", 5: "Never"} — Per week→go to DIA_N09C; Per month→go to DIA_N09D; Per year→go to DIA_N09E; Never→go to DIA_C10; DK/R→go to DIA_C10
159. DIA_N09B: "INTERVIEWER: Enter number of times per day." — Numeric (min: 1, max: 99) — DK/R→continue; go to DIA_C10
160. DIA_N09C: "INTERVIEWER: Enter number of times per week." — Numeric (min: 1, max: 99) — DK/R→continue; go to DIA_C10
161. DIA_N09D: "INTERVIEWER: Enter number of times per month." — Numeric (min: 1, max: 99) — DK/R→continue; go to DIA_C10
162. DIA_N09E: "INTERVIEWER: Enter number of times per year." — Numeric (min: 1, max: 99) — DK/R→continue
163. DIA_C10: If age >= 35, go to DIA_R10. Otherwise, go to DIA_END. — Filter
164. DIA_R10: "Now a few questions about medication." — Read
165. DIA_Q10: "In the past month, did you take aspirin or other ASA (acetylsalicylic acid) medication every day or every second day?" — Yes/No {1: "Yes", 2: "No"} — DK/R→continue
166. DIA_Q11: "In the past month, did you take prescription medications such as Lipitor or Zocor to control your blood cholesterol levels?" — Yes/No {1: "Yes", 2: "No"} — DK/R→continue

### Section: MED - Medication Use - 27 items

167. MED_C1: If (do MED block = 1), go to MED_R1. Otherwise, go to MED_END. — Filter
168. MED_R1: "Now I'd like to ask a few questions about your use of medications, both prescription and over-the-counter." — Read
169. MED_Q1A: "In the past month, that is, from [date one month ago] to yesterday, did you take: ... pain relievers such as aspirin or Tylenol (including arthritis medicine and anti-inflammatories)?" — Yes/No {1: "Yes", 2: "No"} — DK→continue; R→go to MED_END
170. MED_Q1B: "In the past month, that is, from [date one month ago] to yesterday, did you take: ... tranquilizers such as Valium or Ativan?" — Yes/No {1: "Yes", 2: "No"} — DK/R→continue
171. MED_Q1C: "In the past month, that is, from [date one month ago] to yesterday, did you take: ... diet pills such as Dexatrim, Ponderal or Fastin?" — Yes/No {1: "Yes", 2: "No"} — DK/R→continue
172. MED_Q1D: "In the past month, that is, from [date one month ago] to yesterday, did you take: ... anti-depressants such as Prozac, Paxil or Effexor?" — Yes/No {1: "Yes", 2: "No"} — DK/R→continue
173. MED_Q1E: "In the past month, that is, from [date one month ago] to yesterday, did you take: ... codeine, Demerol or morphine?" — Yes/No {1: "Yes", 2: "No"} — DK/R→continue
174. MED_Q1F: "In the past month, that is, from [date one month ago] to yesterday, did you take: ... allergy medicine such as Reactine or Allegra?" — Yes/No {1: "Yes", 2: "No"} — DK/R→continue
175. MED_Q1G: "In the past month, that is, from [date one month ago] to yesterday, did you take: ... asthma medications such as inhalers or nebulizers?" — Yes/No {1: "Yes", 2: "No"} — DK/R→continue
176. MED_E1G: Soft edit — if MED_Q1G = 1 and CCC_Q036 = 2, flag inconsistency: respondent took asthma medicine but previously reported not taking asthma medicine. — Constraint (soft edit/postcondition)
177. MED_Q1H: "In the past month, that is, from [date one month ago] to yesterday, did you take: ... cough or cold remedies?" — Yes/No {1: "Yes", 2: "No"} — DK/R→continue
178. MED_Q1I: "In the past month, that is, from [date one month ago] to yesterday, did you take: ... penicillin or other antibiotics?" — Yes/No {1: "Yes", 2: "No"} — DK/R→continue
179. MED_Q1J: "In the past month, that is, from [date one month ago] to yesterday, did you take: ... medicine for the heart?" — Yes/No {1: "Yes", 2: "No"} — DK/R→continue
180. MED_Q1L: "In the past month, that is, from [date one month ago] to yesterday, did you take: ... diuretics or water pills?" — Yes/No {1: "Yes", 2: "No"} — DK/R→continue
181. MED_Q1M: "In the past month, that is, from [date one month ago] to yesterday, did you take: ... steroids?" — Yes/No {1: "Yes", 2: "No"} — DK/R→continue
182. MED_Q1P: "In the past month, that is, from [date one month ago] to yesterday, did you take: ... sleeping pills such as Imovane, Nytol or Starnoc?" — Yes/No {1: "Yes", 2: "No"} — DK/R→continue
183. MED_Q1Q: "In the past month, that is, from [date one month ago] to yesterday, did you take: ... stomach remedies?" — Yes/No {1: "Yes", 2: "No"} — DK/R→continue
184. MED_Q1R: "In the past month, that is, from [date one month ago] to yesterday, did you take: ... laxatives?" — Yes/No {1: "Yes", 2: "No"} — DK/R→continue
185. MED_C1S: If sex = female and age <= 49, go to MED_Q1S. Otherwise, go to MED_C1TA. — Filter
186. MED_Q1S: "In the past month, that is, from [date one month ago] to yesterday, did you take: ... birth control pills?" — Yes/No {1: "Yes", 2: "No"} — DK/R→continue
187. MED_C1TA: If (do HRT block = 1), go to MED_Q1U. Otherwise, go to MED_C1T. — Filter
188. MED_C1T: If sex is female and age >= 30, go to MED_Q1T. Otherwise, go to MED_Q1U. — Filter
189. MED_Q1T: "In the past month, that is, from [date one month ago] to yesterday, did you take: ... hormones for menopause or ageing symptoms?" — Yes/No {1: "Yes", 2: "No"} — No→go to MED_Q1U; DK/R→go to MED_Q1U
190. MED_Q1T1: "What type of hormones are you taking? (INTERVIEWER: Read categories to respondent.)" — Single select {1: "Estrogen only", 2: "Progesterone only", 3: "Both", 4: "Neither"} — DK/R→continue
191. MED_Q1T2: "When did you start this hormone therapy? (INTERVIEWER: Enter the year; minimum is year of birth + 30; maximum is current year.)" — Numeric (min: year of birth + 30, max: current year) — DK/R→continue
192. MED_E1T2: Hard edit — year must be between (year of birth + 30) and current year; trigger hard edit if outside these ranges. — Constraint (hard edit/postcondition)
193. MED_Q1U: "In the past month, that is, from [date one month ago] to yesterday, did you take: ... thyroid medication such as Synthroid or Levothyroxine?" — Yes/No {1: "Yes", 2: "No"} — DK/R→continue
194. MED_Q1V: "In the past month, that is, from [date one month ago] to yesterday, did you take: ... any other medication?" — Yes/No {1: "Yes", 2: "No"} — DK/R→continue
195. MED_C1V: If MED_Q1V = 1, go to MED_Q1VS. Otherwise, go to MED_END. — Filter
196. MED_Q1VS: "INTERVIEWER: Specify." — Text (80 chars) — DK/R→continue

### Section: HCU - Health Care Utilization - 38 items

197. HCU_C01: Filter — If HCU block = 1, go to HCU_R01; otherwise go to HCU_END
198. HCU_R01: "Now I'd like to ask about your contacts with various health professionals during the past 12 months, that is, from [date one year ago] to yesterday." — Read — go to HCU_Q01AA
199. HCU_Q01AA: "Do you have a regular medical doctor?" — Yes/No {1: "Yes" → HCU_Q01AC, 2: "No" → HCU_Q01BA, DK/R → HCU_Q01BA}
200. HCU_Q01AB: "Why do you not have a regular medical doctor? (Mark all that apply)" — Multi select {1: "No medical doctors available in the area", 2: "Medical doctors in the area are not taking new patients", 3: "Have not tried to contact one", 4: "Had a medical doctor who left or retired", 5: "Other - Specify", DK/R} — go to HCU_C01ABS
201. HCU_C01ABS: Filter — If HCU_Q01AB = 5, go to HCU_Q01ABS; otherwise go to HCU_Q01BA
202. HCU_Q01ABS: "Specify (reason for no regular doctor)." — Text (80 chars) — go to HCU_Q01BA
203. HCU_Q01AC: "Do you and this doctor usually speak in English, in French, or in another language?" — Single select {1: "English", 2: "French", 3: "Arabic", 4: "Chinese", 5: "Cree", 6: "German", 7: "Greek", 8: "Hungarian", 9: "Italian", 10: "Korean", 11: "Persian (Farsi)", 12: "Polish", 13: "Portuguese", 14: "Punjabi", 15: "Spanish", 16: "Tagalog (Pilipino)", 17: "Ukrainian", 18: "Vietnamese", 19: "Dutch", 20: "Hindi", 21: "Russian", 22: "Tamil", 23: "Other - Specify", DK/R} — go to HCU_C01ACS
204. HCU_C01ACS: Filter — If HCU_Q01AC = 23, go to HCU_Q01ACS; otherwise go to HCU_Q01BA
205. HCU_Q01ACS: "Specify (language)." — Text (80 chars) — go to HCU_Q01BA
206. HCU_Q01BA: "In the past 12 months, have you been a patient overnight in a hospital, nursing home or convalescent home?" — Yes/No {1: "Yes" → HCU_Q01BB, 2: "No" → HCU_Q02A, DK → HCU_Q02A, R → HCU_END}
207. HCU_Q01BB: "For how many nights in the past 12 months?" — Numeric (1–366; warning after 100) — go to HCU_Q02A
208. HCU_Q02A: "[Not counting when you were an overnight patient, in the past 12 months/In the past 12 months], how many times have you seen, or talked on the telephone, about your physical, emotional or mental health with: … a family doctor, pediatrician or general practitioner?" — Numeric (0–366; warning after 12) — go to HCU_Q02B
209. HCU_Q02B: "… an eye specialist (such as an ophthalmologist or optometrist)?" — Numeric (0–75; warning after 3) — go to HCU_Q02C
210. HCU_Q02C: "… any other medical doctor (such as a surgeon, allergist, orthopedist, gynaecologist or psychiatrist)?" — Numeric (0–300; warning after 7) — go to HCU_Q02D
211. HCU_Q02D: "… a nurse for care or advice?" — Numeric (0–366; warning after 15) — go to HCU_Q02E
212. HCU_Q02E: "… a dentist or orthodontist?" — Numeric (0–99; warning after 4) — go to HCU_Q02F
213. HCU_Q02F: "… a chiropractor?" — Numeric (0–366; warning after 20) — go to HCU_Q02G
214. HCU_Q02G: "… a physiotherapist?" — Numeric (0–366; warning after 30) — go to HCU_Q02H
215. HCU_Q02H: "… a social worker or counsellor?" — Numeric (0–366; warning after 20) — go to HCU_Q02I
216. HCU_Q02I: "… a psychologist?" — Numeric (0–366; warning after 25) — go to HCU_Q02J
217. HCU_Q02J: "… a speech, audiology or occupational therapist?" — Numeric (0–200; warning after 12) — go to HCU_C03
218. HCU_C03: Filter — If HCU_Q02A or HCU_Q02C or HCU_Q02D > 0, go to HCU_Q03; otherwise go to HCU_Q04A
219. HCU_Q03: "Where did the most recent contact take place?" — Single select {1: "Doctor's office", 2: "Hospital emergency room", 3: "Hospital outpatient clinic", 4: "Walk-in clinic", 5: "Appointment clinic", 6: "Community health centre / CLSC", 7: "At work", 8: "At school", 9: "At home", 10: "Telephone consultation only", 11: "Other - Specify", DK/R} — go to HCU_C03S
220. HCU_C03S: Filter — If HCU_Q03 = 11, go to HCU_Q03S; otherwise go to HCU_C031
221. HCU_Q03S: "Specify (location of most recent contact)." — Text (80 chars) — go to HCU_C031
222. HCU_C031: Filter — If HCU_Q03 = 3 or 5 or 6, go to HCU_Q03_1; otherwise go to HCU_Q04A
223. HCU_Q03_1: "Did this most recent contact occur: … in-person (face-to-face)? … through a videoconference? … through another method?" — Single select {1: "In-person (face-to-face)", 2: "Through a videoconference", 3: "Through another method", DK/R} — go to HCU_Q04A
224. HCU_Q04A: "In the past 12 months, have you attended a meeting of a self-help group such as AA or a cancer support group?" — Yes/No {1: "Yes", 2: "No", DK/R} — go to HCU_Q04
225. HCU_Q04: "In the past 12 months, have you seen or talked to an alternative health care provider such as an acupuncturist, homeopath or massage therapist about your physical, emotional or mental health?" — Yes/No {1: "Yes" → HCU_Q05, 2: "No" → HCU_C06, DK/R → HCU_C06}
226. HCU_Q05: "Who did you see or talk to? (Mark all that apply)" — Multi select {1: "Massage therapist", 2: "Acupuncturist", 3: "Homeopath or naturopath", 4: "Feldenkrais or Alexander teacher", 5: "Relaxation therapist", 6: "Biofeedback teacher", 7: "Rolfer", 8: "Herbalist", 9: "Reflexologist", 10: "Spiritual healer", 11: "Religious healer", 12: "Other - Specify", DK/R} — go to HCU_C05S
227. HCU_C05S: Filter — If HCU_Q05 = 12, go to HCU_Q05S; otherwise go to HCU_C06
228. HCU_Q05S: "Specify (alternative health care provider)." — Text (80 chars) — go to HCU_C06
229. HCU_C06: Filter — Proxy/non-proxy and age routing for HCU_Q06 wording — go to HCU_Q06
230. HCU_Q06: "During the past 12 months, was there ever a time when you felt that you needed health care but you didn't receive it?" — Yes/No {1: "Yes" → HCU_Q07, 2: "No" → HCU_END, DK/R → HCU_END}
231. HCU_Q07: "Thinking of the most recent time, why didn't you get care? (Mark all that apply)" — Multi select {1: "Not available - in the area", 2: "Not available - at time required", 3: "Waiting time too long", 4: "Felt would be inadequate", 5: "Cost", 6: "Too busy", 7: "Didn't get around to it / didn't bother", 8: "Didn't know where to go", 9: "Transportation problems", 10: "Language problems", 11: "Personal or family responsibilities", 12: "Dislikes doctors / afraid", 13: "Decided not to seek care", 14: "Doctor - didn't think it was necessary", 15: "Unable to leave the house because of a health problem", 16: "Other - Specify", DK/R} — go to HCU_C07S
232. HCU_C07S: Filter — If HCU_Q07 = 16, go to HCU_Q07S; otherwise go to HCU_Q08
233. HCU_Q07S: "Specify (reason for not getting care)." — Text (80 chars) — go to HCU_Q08
234. HCU_Q08: "Again, thinking of the most recent time, what was the type of care that was needed? (Mark all that apply)" — Multi select {1: "Treatment of - a physical health problem", 2: "Treatment of - an emotional or mental health problem", 3: "A regular check-up (including regular pre-natal care)", 4: "Care of an injury", 5: "Other - Specify", DK/R} — go to HCU_C08S
235. HCU_C08S: Filter — If HCU_Q08 = 5, go to HCU_Q08S; otherwise go to HCU_Q09
236. HCU_Q08S: "Specify (type of care needed)." — Text (80 chars) — go to HCU_Q09
237. HCU_Q09: "Where did you try to get the service you were seeking? (Mark all that apply)" — Multi select {1: "Doctor's office", 2: "Hospital - emergency room", 3: "Hospital - overnight patient", 4: "Hospital - outpatient clinic", 5: "Walk-in clinic", 6: "Appointment clinic", 7: "Community health centre / CLSC", 8: "Other - Specify", DK/R} — go to HCU_C09S
238. HCU_C09S: Filter — If HCU_Q09 = 8, go to HCU_Q09S; otherwise go to HCU_END
239. HCU_Q09S: "Specify (location sought for care)." — Text (80 chars) — go to HCU_END

---

### Section: HMC - Home Care Services - 26 items

240. HMC_C09A: Filter — If do HMC block = 1, go to HMC_C09B; otherwise go to HMC_END
241. HMC_C09B: Filter — If age < 18, go to HMC_END; otherwise go to HMC_R09
242. HMC_R09: "Now some questions on home care services. These are health care, home maker or other support services received at home..." — Read — go to HMC_Q09
243. HMC_Q09: "Have you received any home care services in the past 12 months, with the cost being entirely or partially covered by government?" — Yes/No {1: "Yes" → HMC_Q10, 2: "No" → HMC_Q11, DK → HMC_Q11, R → HMC_END}
244. HMC_Q10: "What type of services have you received? (Read categories. Mark all that apply. Cost must be entirely or partially covered by government.)" — Multi select {1: "Nursing care", 2: "Other health care services", 3: "Medical equipment or supplies", 4: "Personal care", 5: "Housework", 6: "Meal preparation or delivery", 7: "Shopping", 8: "Respite care", 9: "Other - Specify", DK/R} — go to HMC_C10S
245. HMC_C10S: Filter — If HMC_Q10 = 9, go to HMC_Q10S; otherwise go to HMC_Q11
246. HMC_Q10S: "Specify (type of government-covered home care service)." — Text (80 chars) — go to HMC_Q11
247. HMC_Q11: "Have you received any [other] home care services in the past 12 months, with the cost not covered by government (for example: care provided by a private agency or by a spouse or friends)?" — Yes/No {1: "Yes" → HMC_Q12, 2: "No" → HMC_Q14, DK/R → HMC_Q14}
248. HMC_Q12: "Who provided these [other] home care services? (Read categories. Mark all that apply.)" — Multi select {1: "Nurse from a private agency", 2: "Homemaker or other support services from a private agency", 3: "Physiotherapist or other therapist from a private agency", 4: "Neighbour or friend", 5: "Family member or spouse", 6: "Volunteer", 7: "Other - Specify", DK/R} — go to HMC_C12S
249. HMC_C12S: Filter — If HMC_Q12 = 7, go to HMC_Q12S; otherwise go to HMC_C13
250. HMC_Q12S: "Specify (other provider of home care)." — Text (80 chars) — go to HMC_C13
251. HMC_C13: Filter — For each person identified in HMC_Q12, ask HMC_Q13n (up to 7 iterations, n = A–G)
252. HMC_Q13n: "What type of services have you received from [person identified in HMC_Q12]? (Read categories. Mark all that apply.)" — Multi select {1: "Nursing care", 2: "Other health care services", 3: "Medical equipment or supplies", 4: "Personal care", 5: "Housework", 6: "Meal preparation or delivery", 7: "Shopping", 8: "Respite care", 9: "Other - Specify", DK/R} — go to HMC_C13S
253. HMC_C13S: Filter — If HMC_Q13 = 9, go to HMC_Q13S; otherwise go to HMC_Q14
254. HMC_Q13S: "Specify (other type of service from private provider)." — Text (80 chars) — go to HMC_Q14
255. HMC_Q14: "During the past 12 months, was there ever a time when you felt that you needed home care services but you didn't receive them?" — Yes/No {1: "Yes" → HMC_Q15, 2: "No" → HMC_END, DK/R → HMC_END}
256. HMC_Q15: "Thinking of the most recent time, why didn't you get these services? (Mark all that apply.)" — Multi select {1: "Not available - in the area", 2: "Not available - at time required", 3: "Waiting time too long", 4: "Felt would be inadequate", 5: "Cost", 6: "Too busy", 7: "Didn't get around to it / didn't bother", 8: "Didn't know where to go / call", 9: "Language problems", 10: "Personal or family responsibilities", 11: "Decided not to seek services", 12: "Doctor - did not think it was necessary", 13: "Did not qualify / not eligible for homecare", 14: "Still waiting for homecare", 15: "Other - Specify", DK/R} — go to HMC_C15S
257. HMC_C15S: Filter — If HMC_Q15 = 15, go to HMC_Q15S; otherwise go to HMC_Q16
258. HMC_Q15S: "Specify (reason for not getting home care)." — Text (80 chars) — go to HMC_Q16
259. HMC_Q16: "Again, thinking of the most recent time, what type of home care was needed? (Mark all that apply.)" — Multi select {1: "Nursing care", 2: "Other health care services", 3: "Medical equipment or supplies", 4: "Personal care", 5: "Housework", 6: "Meal preparation or delivery", 7: "Shopping", 8: "Respite care", 9: "Other - Specify", DK/R} — go to HMC_C16S
260. HMC_C16S: Filter — If HMC_Q16 = 9, go to HMC_Q16S; otherwise go to HMC_Q17
261. HMC_Q16S: "Specify (type of home care needed)." — Text (80 chars) — go to HMC_Q17
262. HMC_Q17: "Where did you try to get this home care service? (Mark all that apply.)" — Multi select {1: "A government sponsored program", 2: "A private agency", 3: "A family member, friend or neighbour", 4: "A volunteer organization", 5: "Other", DK/R} — go to HMC_END

---

### Section: PAS - Patient Satisfaction - 21 items

263. PAS_C11A: Filter — If do block = 1, go to PAS_C11B; otherwise go to PAS_END
264. PAS_C11B: Filter — If proxy interview or age < 15, go to PAS_END; otherwise go to PAS_R1
265. PAS_R1: "Earlier, I asked about your use of health care services in the past 12 months. Now I'd like to get your opinion on the quality of the care you received." — Read — go to PAS_C11D
266. PAS_C11D: Filter — If HCU_Q01BA = 1 or at least one of HCU_Q02A to HCU_Q02J > 0, go to PAS_Q12; otherwise go to PAS_Q11
267. PAS_Q11: "In the past 12 months, have you received any health care services?" — Yes/No {1: "Yes" → PAS_Q12, 2: "No" → PAS_Q51, DK/R → PAS_Q51}
268. PAS_Q12: "Overall, how would you rate the quality of the health care you received? Would you say it was: … excellent? … good? … fair? … poor?" — Single select {1: "Excellent", 2: "Good", 3: "Fair", 4: "Poor", DK/R} — go to PAS_Q13
269. PAS_Q13: "Overall, how satisfied were you with the way health care services were provided? Were you: … very satisfied? … somewhat satisfied? … neither satisfied nor dissatisfied? … somewhat dissatisfied? … very dissatisfied?" — Single select {1: "Very satisfied", 2: "Somewhat satisfied", 3: "Neither satisfied nor dissatisfied", 4: "Somewhat dissatisfied", 5: "Very dissatisfied", DK/R} — go to PAS_Q21A
270. PAS_Q21A: "In the past 12 months, have you received any health care services at a hospital, for any diagnostic or day surgery service, overnight stay, or as an emergency room patient?" — Yes/No {1: "Yes" → PAS_Q21B, 2: "No" → PAS_Q31A, DK/R → PAS_Q31A}
271. PAS_Q21B: "Thinking of your most recent hospital visit, were you: … admitted overnight or longer (an inpatient)? … a patient at a diagnostic or day surgery clinic (an outpatient)? … an emergency room patient?" — Single select {1: "Admitted overnight or longer (inpatient)", 2: "Patient at a diagnostic or day surgery clinic (outpatient)", 3: "Emergency room patient", DK/R → PAS_Q31A} — go to PAS_Q22
272. PAS_Q22: "Thinking of this most recent hospital visit: … how would you rate the quality of the care you received? Would you say it was: … excellent? … good? … fair? … poor?" — Single select {1: "Excellent", 2: "Good", 3: "Fair", 4: "Poor", DK/R} — go to PAS_Q23
273. PAS_Q23: "Thinking of this most recent hospital visit: … how satisfied were you with the way hospital services were provided? Were you: … very satisfied? … somewhat satisfied? … neither satisfied nor dissatisfied? … somewhat dissatisfied? … very dissatisfied?" — Single select {1: "Very satisfied", 2: "Somewhat satisfied", 3: "Neither satisfied nor dissatisfied", 4: "Somewhat dissatisfied", 5: "Very dissatisfied", DK/R} — go to PAS_Q31A
274. PAS_Q31A: "In the past 12 months, not counting hospital visits, have you received any health care services from a family doctor or other physician?" — Yes/No {1: "Yes" → PAS_Q31B, 2: "No" → PAS_R2, DK/R → PAS_R2}
275. PAS_Q31B: "Thinking of the most recent time, was care provided by: … a family doctor (general practitioner)? … a medical specialist?" — Single select {1: "A family doctor (general practitioner)", 2: "A medical specialist", DK/R → PAS_R2} — go to PAS_Q32
276. PAS_Q32: "Thinking of this most recent care from a physician: … how would you rate the quality of the care you received? Would you say it was: … excellent? … good? … fair? … poor?" — Single select {1: "Excellent", 2: "Good", 3: "Fair", 4: "Poor", DK/R} — go to PAS_Q33
277. PAS_Q33: "Thinking of this most recent care from a physician: … how satisfied were you with the way physician care was provided? Were you: … very satisfied? … somewhat satisfied? … neither satisfied nor dissatisfied? … somewhat dissatisfied? … very dissatisfied?" — Single select {1: "Very satisfied", 2: "Somewhat satisfied", 3: "Neither satisfied nor dissatisfied", 4: "Somewhat dissatisfied", 5: "Very dissatisfied", DK/R} — go to PAS_R2
278. PAS_R2: "The next questions are about community-based health care which includes any health care received outside of a hospital or doctor's office. Examples are: home nursing care, home-based counselling or therapy, personal care and community walk-in clinics." — Read — go to PAS_Q41
279. PAS_Q41: "In the past 12 months, have you received any community-based care?" — Yes/No {1: "Yes" → PAS_Q42, 2: "No" → PAS_Q51, DK/R → PAS_Q51}
280. PAS_Q42: "Overall, how would you rate the quality of the community-based care you received? Would you say it was: … excellent? … good? … fair? … poor?" — Single select {1: "Excellent", 2: "Good", 3: "Fair", 4: "Poor", DK/R} — go to PAS_Q43
281. PAS_Q43: "Overall, how satisfied were you with the way community-based care was provided? Were you: … very satisfied? … somewhat satisfied? … neither satisfied nor dissatisfied? … somewhat dissatisfied? … very dissatisfied?" — Single select {1: "Very satisfied", 2: "Somewhat satisfied", 3: "Neither satisfied nor dissatisfied", 4: "Somewhat dissatisfied", 5: "Very dissatisfied", DK/R} — go to PAS_Q51
282. PAS_Q51: "In the past 12 months, have you used a telephone health line or telehealth service?" — Yes/No {1: "Yes" → PAS_Q52, 2: "No" → PAS_END, DK/R → PAS_END}
283. PAS_Q52: "Overall, how would you rate the quality of the service you received? Would you say it was: … excellent? … good? … fair? … poor?" — Single select {1: "Excellent", 2: "Good", 3: "Fair", 4: "Poor", DK/R} — go to PAS_END

---

### Section: RAC - Restriction of Activities - 28 items

284. RAC_C1: Filter — If do RAC block = 1, go to RAC_R1; otherwise go to RAC_END
285. RAC_R1: "The next few questions deal with any current limitations in your daily activities caused by a long-term health condition or problem. In these questions, a 'long-term condition' refers to a condition that is expected to last or has already lasted 6 months or more." — Read — go to RAC_Q1
286. RAC_Q1: "Do you have any difficulty hearing, seeing, communicating, walking, climbing stairs, bending, learning or doing any similar activities?" — Single select {1: "Sometimes", 2: "Often", 3: "Never", DK, R → RAC_END} — go to RAC_Q2A
287. RAC_Q2A: "Does a long-term physical condition or mental condition or health problem, reduce the amount or the kind of activity you can do: … at home?" — Single select {1: "Sometimes", 2: "Often", 3: "Never", DK, R → RAC_END} — go to RAC_Q2B_1
288. RAC_Q2B_1: "Does a long-term physical condition or mental condition or health problem, reduce the amount or the kind of activity you can do: … at school?" — Single select {1: "Sometimes", 2: "Often", 3: "Never", 4: "Does not attend school", DK, R → RAC_END} — go to RAC_Q2B_2
289. RAC_Q2B_2: "Does a long-term physical condition or mental condition or health problem, reduce the amount or the kind of activity you can do: … at work?" — Single select {1: "Sometimes", 2: "Often", 3: "Never", 4: "Does not work at a job", DK, R → RAC_END} — go to RAC_Q2C
290. RAC_Q2C: "Does a long-term physical condition or mental condition or health problem, reduce the amount or the kind of activity you can do: … in other activities, for example, transportation or leisure?" — Single select {1: "Sometimes", 2: "Often", 3: "Never", DK, R → RAC_END} — go to RAC_C5
291. RAC_C5: Filter — If RAC_Q1 = 1 or 2, or RAC_Q2A–C = 1 or 2, go to RAC_C5A; otherwise go to RAC_Q6A
292. RAC_C5A: Filter — If (RAC_Q2A to RAC_Q2C = 3 or 4) and RAC_Q1 < 3, go to RAC_R5; otherwise go to RAC_Q5
293. RAC_R5: "You reported that you have difficulty hearing, seeing, communicating, walking, climbing stairs, bending, learning or doing any similar activities." — Read — go to RAC_Q5
294. RAC_Q5: "Which one of the following is the best description of the cause of this condition?" — Single select {1: "Accident at home", 2: "Motor vehicle accident", 3: "Accident at work", 4: "Other type of accident", 5: "Existed from birth or genetic", 6: "Work conditions", 7: "Disease or illness", 8: "Ageing", 9: "Emotional or mental health problem or condition", 10: "Use of alcohol or drugs", 11: "Other - Specify", DK/R} — go to RAC_C5S
295. RAC_C5S: Filter — If RAC_Q5 = 11, go to RAC_Q5S; otherwise go to RAC_Q5B_1
296. RAC_Q5S: "Specify (cause of condition)." — Text (80 chars) — go to RAC_Q5B_1
297. RAC_Q5B_1: "Because of your condition or health problem, have you ever experienced discrimination or unfair treatment?" — Yes/No {1: "Yes" → RAC_Q5B_2, 2: "No" → RAC_Q6A, DK/R → RAC_Q6A}
298. RAC_Q5B_2: "In the past 12 months, how much discrimination or unfair treatment did you experience?" — Single select {1: "A lot", 2: "Some", 3: "A little", 4: "None at all", DK/R} — go to RAC_Q6A
299. RAC_Q6A: "Because of any physical condition or mental condition or health problem, do you need the help of another person: … with preparing meals?" — Yes/No {1: "Yes", 2: "No", DK/R} — go to RAC_Q6B_1
300. RAC_Q6B_1: "Because of any physical condition or mental condition or health problem, do you need the help of another person: … with getting to appointments and running errands such as shopping for groceries?" — Yes/No {1: "Yes", 2: "No", DK/R} — go to RAC_Q6C
301. RAC_Q6C: "Because of any physical condition or mental condition or health problem, do you need the help of another person: … with doing everyday housework?" — Yes/No {1: "Yes", 2: "No", DK/R} — go to RAC_Q6D
302. RAC_Q6D: "Because of any physical condition or mental condition or health problem, do you need the help of another person: … with doing heavy household chores such as spring cleaning or yard work?" — Yes/No {1: "Yes", 2: "No", DK/R} — go to RAC_Q6E
303. RAC_Q6E: "Because of any physical condition or mental condition or health problem, do you need the help of another person: … with personal care such as washing, dressing, eating or taking medication?" — Yes/No {1: "Yes", 2: "No", DK/R} — go to RAC_Q6F
304. RAC_Q6F: "Because of any physical condition or mental condition or health problem, do you need the help of another person: … with moving about inside the house?" — Yes/No {1: "Yes", 2: "No", DK/R} — go to RAC_Q6G
305. RAC_Q6G: "Because of any physical condition or mental condition or health problem, do you need the help of another person: … with looking after your personal finances such as making bank transactions or paying bills?" — Yes/No {1: "Yes", 2: "No", DK/R} — go to RAC_Q7A
306. RAC_Q7A: "Because of any physical condition or mental condition or health problem, do you have difficulty: … making new friends or maintaining friendships?" — Yes/No {1: "Yes", 2: "No", DK/R} — go to RAC_Q7B
307. RAC_Q7B: "Because of any physical condition or mental condition or health problem, do you have difficulty: … dealing with people you do not know well?" — Yes/No {1: "Yes", 2: "No", DK/R} — go to RAC_Q7C
308. RAC_Q7C: "Because of any physical condition or mental condition or health problem, do you have difficulty: … starting and maintaining a conversation?" — Yes/No {1: "Yes", 2: "No", DK/R} — go to RAC_C8
309. RAC_C8: Filter — If any of RAC_Q6A to RAC_Q6G or RAC_Q7A to RAC_Q7C = 1, go to RAC_Q8; otherwise go to RAC_END
310. RAC_Q8: "Are these difficulties due to your physical health, to your emotional or mental health, to your use of alcohol or drugs, or to another reason? (Mark all that apply.)" — Multi select {1: "Physical health", 2: "Emotional or mental health", 3: "Use of alcohol or drugs", 4: "Another reason - Specify", DK/R} — go to RAC_C8S
311. RAC_C8S: Filter — If RAC_Q8 = 4, go to RAC_Q8S; otherwise go to RAC_END
312. RAC_Q8S: "Specify (other reason for difficulty)." — Text (80 chars) — go to RAC_END

---

### Section: TWD - Two-Week Disability - 20 items

313. TWD_C1: Filter — If do TWD block = 1, go to TWD_QINT; otherwise go to TWD_END
314. TWD_QINT: "The next few questions ask about your health during the past 14 days. It is important for you to refer to the 14-day period from [date two weeks ago] to [date yesterday]." — Read — go to TWD_Q1
315. TWD_Q1: "During that period, did you stay in bed at all because of illness or injury, including any nights spent as a patient in a hospital?" — Yes/No {1: "Yes" → TWD_Q2, 2: "No" → TWD_Q3, DK/R → TWD_END}
316. TWD_Q2: "How many days did you stay in bed for all or most of the day?" — Numeric (0–14) — DK/R → TWD_END; go to TWD_C2A
317. TWD_C2A: Filter — If TWD_Q2 > 1, go to TWD_Q2B; otherwise go to TWD_Q2A
318. TWD_Q2A: "Was that due to your emotional or mental health or your use of alcohol or drugs?" — Yes/No {1: "Yes", 2: "No", DK/R} — go to TWD_C3
319. TWD_Q2B: "How many of these [TWD_Q2] days were due to your emotional or mental health or your use of alcohol or drugs?" — Numeric (0–TWD_Q2) — DK/R — go to TWD_C3
320. TWD_C3: Filter — If TWD_Q2 = 14 days, go to TWD_END; otherwise go to TWD_Q3
321. TWD_Q3: "[Not counting days spent in bed, during those 14 days,/During those 14 days,] were there any days that you cut down on things you normally do because of illness or injury?" — Yes/No {1: "Yes" → TWD_Q4, 2: "No" → TWD_Q5, DK/R → TWD_Q5}
322. TWD_Q4: "How many days did you cut down on things for all or most of the day?" — Numeric (0–(14 minus TWD_Q2)) — DK/R → TWD_Q5; go to TWD_C4A
323. TWD_C4A: Filter — If TWD_Q4 > 1, go to TWD_Q4B; otherwise go to TWD_Q4A
324. TWD_Q4A: "Was that due to your emotional or mental health or your use of alcohol or drugs?" — Yes/No {1: "Yes", 2: "No", DK/R} — go to TWD_Q5
325. TWD_Q4B: "How many of these [TWD_Q4] days were due to your emotional or mental health or your use of alcohol or drugs?" — Numeric (0–TWD_Q4) — DK/R — go to TWD_Q5
326. TWD_Q5: "[Not counting days spent in bed, during those 14 days,/During those 14 days,] were there any days when it took extra effort to perform up to your usual level at work or at your other daily activities, because of illness or injury?" — Yes/No {1: "Yes" → TWD_Q6, 2: "No" → TWD_END, DK/R → TWD_END}
327. TWD_Q6: "How many days required extra effort?" — Numeric (0–(14 minus TWD_Q2)) — DK/R → TWD_END; go to TWD_C6A
328. TWD_C6A: Filter — If TWD_Q6 > 1, go to TWD_Q6B; otherwise go to TWD_Q6A
329. TWD_Q6A: "Was that due to your emotional or mental health or your use of alcohol or drugs?" — Yes/No {1: "Yes", 2: "No", DK/R} — go to TWD_END
330. TWD_Q6B: "How many of these [TWD_Q6] days were due to your emotional or mental health or your use of alcohol or drugs?" — Numeric (0–TWD_Q6) — DK/R — go to TWD_END

### Section: FLU - Flu Shots - 10 items

331. FLU_C1: If (do FLU block = 1), then go to FLU_C160; otherwise go to FLU_END — Filter
332. FLU_C160: If proxy interview, go to FLU_END; otherwise go to FLU_Q160 — Filter
333. FLU_Q160 / FLUE_160: "Now a few questions about your use of various health care services. Have you ever had a flu shot?" — Yes/No {1: "Yes" → continue, 2: "No" → Go to FLU_Q166, DK/R → Go to FLU_END}
334. FLU_Q162 / FLUE_162: "When did you have your last flu shot?" — Single select {1: "Less than 1 year ago" → Go to FLU_END, 2: "1 year to less than 2 years ago", 3: "2 years ago or more", DK/R → Go to FLU_END} — Read categories to respondent
335. FLU_Q166: "What are the reasons that you have not had a flu shot in the past year?" — Multi select {FLUE_66A 1: "Have not gotten around to it", FLUE_66B 2: "Respondent - did not think it was necessary", FLUE_66C 3: "Doctor - did not think it was necessary", FLUE_66D 4: "Personal or family responsibilities", FLUE_66E 5: "Not available - at time required", FLUE_66F 6: "Not available - at all in the area", FLUE_66G 7: "Waiting time was too long", FLUE_66H 8: "Transportation - problems", FLUE_66I 9: "Language - problem", FLUE_66J 10: "Cost", FLUE_66K 11: "Did not know where to go / uninformed", FLUE_66L 12: "Fear (e.g., painful, embarrassing, find something wrong)", FLUE_66M 13: "Bad reaction to previous shot", FLUE_66O 14: "Unable to leave the house because of a health problem", FLUE_66N 15: "Other - Specify", DK/R}
336. FLU_C166S: If FLU_Q166 = 15, go to FLU_Q166S; otherwise go to FLU_END — Filter
337. FLU_Q166S: "INTERVIEWER: Specify." — Text (80 spaces); DK/R

### Section: BPC - Blood Pressure Check - 9 items

338. BPC_C01: If (do BPC block = 2) or proxy interview, go to BPC_END; otherwise go to BPC_Q010 — Filter
339. BPC_Q010 / BPCE_010: "(Now blood pressure) Have you ever had your blood pressure taken?" — Yes/No {1: "Yes" → continue, 2: "No" → Go to BPC_C016, DK/R → Go to BPC_END}
340. BPC_Q012 / BPCE_012: "When was the last time?" — Single select {1: "Less than 6 months ago" → Go to BPC_END, 2: "6 months to less than 1 year ago" → Go to BPC_END, 3: "1 year to less than 2 years ago" → Go to BPC_END, 4: "2 years to less than 5 years ago", 5: "5 or more years ago", DK/R → Go to BPC_END}
341. BPC_C016: If age < 25, go to BPC_END; otherwise go to BPC_Q016 — Filter
342. BPC_Q016: "What are the reasons that you have not had your blood pressure taken in the past 2 years?" — Multi select {BPCE_16A 1: "Have not gotten around to it", BPCE_16B 2: "Respondent - did not think it was necessary", BPCE_16C 3: "Doctor - did not think it was necessary", BPCE_16D 4: "Personal or family responsibilities", BPCE_16E 5: "Not available - at time required", BPCE_16F 6: "Not available - at all in the area", BPCE_16G 7: "Waiting time was too long", BPCE_16H 8: "Transportation - problems", BPCE_16I 9: "Language - problem", BPCE_16J 10: "Cost", BPCE_16K 11: "Did not know where to go / uninformed", BPCE_16L 12: "Fear (e.g., painful, embarrassing, find something wrong)", BPCE_16N 13: "Unable to leave the house because of a health problem", BPCE_16M 14: "Other - Specify", DK/R}
343. BPC_C016S: If BPC_Q016 = 14, go to BPC_Q016S; otherwise go to BPC_END — Filter
344. BPC_Q016S: "INTERVIEWER: Specify." — Text (80 spaces); DK/R

### Section: PAP - Pap Smear - 9 items

345. PAP_C1: If (do PAP block = 1), go to PAP_C020; otherwise go to PAP_END — Filter
346. PAP_C020: If proxy interview or male or age < 18, go to PAP_END; otherwise go to PAP_Q020 — Filter
347. PAP_Q020 / PAPE_020: "(Now PAP tests) Have you ever had a PAP smear test?" — Yes/No {1: "Yes" → continue, 2: "No" → Go to PAP_Q026, DK/R → Go to PAP_END}
348. PAP_Q022 / PAPE_022: "When was the last time?" — Single select {1: "Less than 6 months ago" → Go to PAP_END, 2: "6 months to less than 1 year ago" → Go to PAP_END, 3: "1 year to less than 3 years ago" → Go to PAP_END, 4: "3 years to less than 5 years ago", 5: "5 or more years ago", DK/R → Go to PAP_END}
349. PAP_Q026: "What are the reasons that you have not had a PAP smear test in the past 3 years?" — Multi select {PAPE_26A 1: "Have not gotten around to it", PAPE_26B 2: "Respondent - did not think it was necessary", PAPE_26C 3: "Doctor - did not think it was necessary", PAPE_26D 4: "Personal or family responsibilities", PAPE_26E 5: "Not available - at time required", PAPE_26F 6: "Not available - at all in the area", PAPE_26G 7: "Waiting time was too long", PAPE_26H 8: "Transportation - problems", PAPE_26I 9: "Language - problem", PAPE_26J 10: "Cost", PAPE_26K 11: "Did not know where to go / uninformed", PAPE_26L 12: "Fear (e.g., painful, embarrassing, find something wrong)", PAPE_26M 13: "Have had a hysterectomy", PAPE_26N 14: "Hate / dislike having one done", PAPE_26P 15: "Unable to leave the house because of a health problem", PAPE_26O 16: "Other - Specify", DK/R}
350. PAP_C026S: If PAP_Q026 = 16, go to PAP_Q026S; otherwise go to PAP_END — Filter
351. PAP_Q026S: "INTERVIEWER: Specify." — Text (80 spaces); DK/R

### Section: MAM - Mammography - 18 items

352. MAM_C1: If (do MAM block = 1), go to MAM_C030; otherwise go to MAM_END — Filter
353. MAM_C030: If proxy interview or male, go to MAM_END; otherwise go to MAM_C030A — Filter
354. MAM_C030A: If (female and age < 35), go to MAM_C037; otherwise go to MAM_Q030 — Filter
355. MAM_Q030 / MAME_030: "(Now Mammography) Have you ever had a mammogram, that is, a breast x-ray?" — Yes/No {1: "Yes" → continue, 2: "No" → Go to MAM_C036, DK/R → Go to MAM_END}
356. MAM_Q031: "Why did you have it?" — Multi select {MAME_31A 1: "Family history of breast cancer", MAME_31B 2: "Part of regular check-up / routine screening", MAME_31C 3: "Age", MAME_31D 4: "Previously detected lump", MAME_31E 5: "Follow-up of breast cancer treatment", MAME_31F 6: "On hormone replacement therapy", MAME_31G 7: "Breast problem", MAME_31H 8: "Other - Specify", DK/R} — INTERVIEWER: Mark all that apply; if respondent says "doctor recommended it", probe for reason
357. MAM_C031S: If MAM_Q031 = 8, go to MAM_Q031S; otherwise go to MAM_Q032 — Filter
358. MAM_Q031S: "INTERVIEWER: Specify." — Text (80 spaces); DK/R
359. MAM_Q032 / MAME_032: "When was the last time?" — Single select {1: "Less than 6 months ago" → Go to MAM_C037, 2: "6 months to less than 1 year ago" → Go to MAM_C037, 3: "1 year to less than 2 years ago" → Go to MAM_C037, 4: "2 years to less than 5 years ago", 5: "5 or more years ago", DK/R → Go to MAM_C037}
360. MAM_C036: If age < 50 or age > 69, go to MAM_C037; otherwise go to MAM_Q036 — Filter
361. MAM_Q036: "What are the reasons you have not had one in the past 2 years?" — Multi select {MAME_36A 1: "Have not gotten around to it", MAME_36B 2: "Respondent - did not think it was necessary", MAME_36C 3: "Doctor - did not think it was necessary", MAME_36D 4: "Personal or family responsibilities", MAME_36E 5: "Not available - at time required", MAME_36F 6: "Not available - at all in the area", MAME_36G 7: "Waiting time was too long", MAME_36H 8: "Transportation - problems", MAME_36I 9: "Language - problem", MAME_36J 10: "Cost", MAME_36K 11: "Did not know where to go / uninformed", MAME_36L 12: "Fear (e.g., painful, embarrassing, find something wrong)", MAME_36N 13: "Unable to leave the house because of a health problem", MAME_36O 14: "Breasts removed / Mastectomy", MAME_36M 15: "Other - Specify", DK/R}
362. MAM_C036S: If MAM_Q036 = 15, go to MAM_Q036S; otherwise go to MAM_C037 — Filter
363. MAM_Q036S: "INTERVIEWER: Specify." — Text (80 spaces); DK/R
364. MAM_C037: If (age < 15 or age > 49), go to MAM_C038; otherwise go to MAM_Q037 — Filter
365. MAM_Q037 / MAME_037: "It is important to know when analyzing health whether or not the person is pregnant. Are you pregnant?" — Yes/No {1: "Yes" → Go to MAM_END, 2: "No" → continue, DK/R → continue}
366. MAM_C038: If age < 18, go to MAM_END; otherwise go to MAM_C038A — Filter
367. MAM_C038A: If PAP_Q026 = 13, go to MAM_END; otherwise go to MAM_Q038 — Filter
368. MAM_Q038 / MAME_038: "Have you had a hysterectomy? (in other words, has your uterus been removed)?" — Yes/No {1: "Yes", 2: "No", DK/R}

### Section: BRX - Breast Examinations - 9 items

369. BRX_C1: If (do BRX block = 1), go to BRX_C110; otherwise go to BRX_END — Filter
370. BRX_C110: If proxy interview or sex = male or age < 18, go to BRX_END; otherwise go to BRX_Q110 — Filter
371. BRX_Q110 / BRXE_110: "(Now breast examinations) Other than a mammogram, have you ever had your breasts examined for lumps (tumours, cysts) by a doctor or other health professional?" — Yes/No {1: "Yes" → continue, 2: "No" → Go to BRX_Q116, DK/R → Go to BRX_END}
372. BRX_Q112 / BRXE_112: "When was the last time?" — Single select {1: "Less than 6 months ago" → Go to BRX_END, 2: "6 months to less than 1 year ago" → Go to BRX_END, 3: "1 year to less than 2 years ago" → Go to BRX_END, 4: "2 years to less than 5 years ago", 5: "5 or more years ago", DK/R → Go to BRX_END}
373. BRX_Q116: "What are the reasons that you have not had a breast exam in the past 2 years?" — Multi select {BRXE_16A 1: "Have not gotten around to it", BRXE_16B 2: "Respondent - did not think it was necessary", BRXE_16C 3: "Doctor - did not think it was necessary", BRXE_16D 4: "Personal or family responsibilities", BRXE_16E 5: "Not available - at time required", BRXE_16F 6: "Not available - at all in the area", BRXE_16G 7: "Waiting time was too long", BRXE_16H 8: "Transportation - problems", BRXE_16I 9: "Language - problem", BRXE_16J 10: "Cost", BRXE_16K 11: "Did not know where to go / uninformed", BRXE_16L 12: "Fear (e.g., painful, embarrassing, find something wrong)", BRXE_16N 13: "Unable to leave the house because of a health problem", BRXE_16O 14: "Breasts removed / mastectomy", BRXE_16M 15: "Other - Specify", DK/R}
374. BRX_C116S: If BRX_Q116 = 15, go to BRX_Q116S; otherwise go to BRX_END — Filter
375. BRX_Q116S: "INTERVIEWER: Specify." — Text (80 spaces); DK/R

### Section: BSX - Breast Self-Examinations - 10 items

376. BSX_C120A: If (do BSX block = 1), go to BSX_C120B; otherwise go to BSX_END — Filter
377. BSX_C120B: If proxy interview, go to BSX_END; otherwise go to BSX_C120C — Filter
378. BSX_C120C: If male or age < 18, go to BSX_END; otherwise go to BSX_Q120 — Filter
379. BSX_Q120 / BSXE_120: "(Now breast self examinations) Have you ever examined your breasts for lumps (tumours, cysts)?" — Yes/No {1: "Yes" → continue, 2: "No" → Go to BSX_END, DK/R → Go to BSX_END}
380. BSX_Q121 / BSXE_121: "How often?" — Single select {1: "At least once a month", 2: "Once every 2 to 3 months", 3: "Less often than every 2 to 3 months", DK/R}
381. BSX_Q122: "How did you learn to do this?" — Multi select {BSXE_22A 1: "Doctor", BSXE_22B 2: "Nurse", BSXE_22C 3: "Book / magazine / pamphlet", BSXE_22D 4: "TV / video / film", BSXE_22H 5: "Family member (e.g., mother, sister, cousin)", BSXE_22G 6: "Other - Specify", DK/R}
382. BSX_C122S: If BSX_Q122 = 6, go to BSX_Q122S; otherwise go to BSX_END — Filter
383. BSX_Q122S: "INTERVIEWER: Specify." — Text (80 spaces); DK/R

### Section: EYX - Eye Examinations - 10 items

384. EYX_C140A: If (EYX block = 2) or proxy interview, go to EYX_END; otherwise go to EYX_C140B — Filter
385. EYX_C140B: If HCU_Q02B = 0, DK or R (not seen or talked to eye doctor), go to EYX_Q142; otherwise go to EYX_Q140 — Filter
386. EYX_Q140 / EYXE_140: "(Now eye examinations) It was reported earlier that you have 'seen' or 'talked to' an optometrist or ophthalmologist in the past 12 months. Did you actually visit one?" — Yes/No {1: "Yes" → continue, 2: "No" → continue, DK/R → Go to EYX_END}
387. EYX_Q142 / EYXE_142: "When did you last have an eye examination?" — Single select {1: "Less than 1 year ago" → Go to EYX_END, 2: "1 year to less than 2 years ago" → Go to EYX_END, 3: "2 years to less than 3 years ago", 4: "3 or more years ago", 5: "Never", DK/R → Go to EYX_END}
388. EYX_Q146: "What are the reasons that you have not had an eye examination in the past 2 years?" — Multi select {EYXE_46A 1: "Have not gotten around to it", EYXE_46B 2: "Respondent - did not think it was necessary", EYXE_46C 3: "Doctor - did not think it was necessary", EYXE_46D 4: "Personal or family responsibilities", EYXE_46E 5: "Not available - at time required", EYXE_46F 6: "Not available - at all in the area", EYXE_46G 7: "Waiting time was too long", EYXE_46H 8: "Transportation - problems", EYXE_46I 9: "Language - problem", EYXE_46J 10: "Cost", EYXE_46K 11: "Did not know where to go / uninformed", EYXE_46L 12: "Fear (e.g., painful, embarrassing, find something wrong)", EYXE_46N 13: "Unable to leave the house because of a health problem", EYXE_46M 14: "Other - Specify", DK/R}
389. EYX_C146S: If EYX_Q146 = 14, go to EYX_Q146S; otherwise go to EYX_END — Filter
390. EYX_Q146S: "INTERVIEWER: Specify." — Text (80 spaces); DK/R

### Section: PCU - Physical Check-Up - 11 items

391. PCU_C1: If (PCU block = 1), go to PCU_C150; otherwise go to PCU_END — Filter
392. PCU_C150: If proxy interview, go to PCU_END; otherwise go to PCU_Q150 — Filter
393. PCU_Q150 / PCUE_150: "(Now physical check-ups) Have you ever had a physical check-up without having a specific health problem?" — Yes/No {1: "Yes" → Go to PCU_Q152, 2: "No" → continue, DK/R → Go to PCU_END}
394. PCU_Q151 / PCUE_151: "Have you ever had one during a visit for a health problem?" — Yes/No {1: "Yes" → continue, 2: "No" → Go to PCU_Q156, DK/R → Go to PCU_END}
395. PCU_Q152 / PCUE_152: "When was the last time?" — Single select {1: "Less than 1 year ago" → Go to PCU_END, 2: "1 year to less than 2 years ago" → Go to PCU_END, 3: "2 years to less than 3 years ago" → Go to PCU_END, 4: "3 years to less than 4 years ago", 5: "4 years to less than 5 years ago", 6: "5 or more years ago", DK/R → Go to PCU_END}
396. PCU_Q156: "What are the reasons that you have not had a check-up in the past 3 years?" — Multi select {PCUE_56A 1: "Have not gotten around to it", PCUE_56B 2: "Respondent - did not think it was necessary", PCUE_56C 3: "Doctor - did not think it was necessary", PCUE_56D 4: "Personal or family responsibilities", PCUE_56E 5: "Not available - at time required", PCUE_56F 6: "Not available - at all in the area", PCUE_56G 7: "Waiting time was too long", PCUE_56H 8: "Transportation - problems", PCUE_56I 9: "Language - problem", PCUE_56J 10: "Cost", PCUE_56K 11: "Did not know where to go / uninformed", PCUE_56L 12: "Fear (e.g., painful, embarrassing, find something wrong)", PCUE_56N 13: "Unable to leave the house because of a health problem", PCUE_56M 14: "Other - Specify", DK/R}
397. PCU_C156S: If PCU_Q156 = 14, go to PCU_Q156S; otherwise go to PCU_END — Filter
398. PCU_Q156S: "INTERVIEWER: Specify." — Text (80 spaces); DK/R

### Section: PSA - Prostate Cancer Screening - 15 items

399. PSA_C1: If (do PSA block = 1), go to PSA_C170; otherwise go to PSA_END — Filter
400. PSA_C170: If proxy interview, go to PSA_END; otherwise go to PSA_C170A — Filter
401. PSA_C170A: If female or age < 35, go to PSA_END; otherwise go to PSA_Q170 — Filter
402. PSA_Q170 / PSAE_170: "(Now Prostate tests) Have you ever had a prostate specific antigen test for prostate cancer, that is, a PSA blood test?" — Yes/No {1: "Yes" → continue, 2: "No" → Go to PSA_Q174, DK → Go to PSA_Q174, R → Go to PSA_END}
403. PSA_Q172 / PSAE_172: "When was the last time?" — Single select {1: "Less than 1 year ago", 2: "1 year to less than 2 years ago", 3: "2 years to less than 3 years ago", 4: "3 years to less than 5 years ago", 5: "5 or more years ago", DK/R}
404. PSA_Q173: "Why did you have it?" — Multi select {PSAE_73A 1: "Family history of prostate cancer", PSAE_73B 2: "Part of regular check-up / routine screening", PSAE_73C 3: "Age", PSAE_73G 4: "Race", PSAE_73D 5: "Follow-up of problem", PSAE_73E 6: "Follow-up of prostate cancer treatment", PSAE_73F 7: "Other - Specify", DK/R} — INTERVIEWER: Mark all that apply; if respondent says "Doctor recommended it" or "I requested it", probe for reason
405. PSA_C173S: If PSA_Q173 = 7, go to PSA_Q173S; otherwise go to PSA_Q174 — Filter
406. PSA_Q173S: "INTERVIEWER: Specify." — Text (80 spaces); DK/R
407. PSA_Q174 / PSAE_174: "A Digital Rectal Exam is an exam in which a gloved finger is inserted into the rectum in order to feel the prostate gland. Have you ever had this exam?" — Yes/No {1: "Yes" → continue, 2: "No" → Go to PSA_END, DK/R → Go to PSA_END}
408. PSA_Q175 / PSAE_175: "When was the last time?" — Single select {1: "Less than 1 year ago", 2: "1 year to less than 2 years ago", 3: "2 years to less than 3 years ago", 4: "3 years to less than 5 years ago", 5: "5 or more years ago", DK/R}

### Section: CCS - Colorectal Cancer Screening - 16 items

409. CCS_C1: If (do CCS block = 1), go to CCS_C180; otherwise go to CCS_END — Filter
410. CCS_C180: If proxy interview or age < 35, go to CCS_END; otherwise go to CCS_Q180 — Filter
411. CCS_Q180 / CCSE_180: "Now a few questions about various colorectal exams. An FOBT is a test to check for blood in your stool, where you have a bowel movement and use a stick to smear a small sample on a special card. Have you ever had this test?" — Yes/No {1: "Yes" → continue, 2: "No" → Go to CCS_Q184, DK → Go to CCS_Q184, R → Go to CCS_END}
412. CCS_Q182 / CCSE_182: "When was the last time?" — Single select {1: "Less than 1 year ago", 2: "1 year to less than 2 years ago", 3: "2 years to less than 3 years ago", 4: "3 years to less than 5 years ago", 5: "5 years to less than 10 years ago", 6: "10 or more years ago", DK/R}
413. CCS_Q183: "Why did you have it?" — Multi select {CCSE_83A 1: "Family history of colorectal cancer", CCSE_83B 2: "Part of regular check-up / routine screening", CCSE_83C 3: "Age", CCSE_83G 4: "Race", CCSE_83D 5: "Follow-up of problem", CCSE_83E 6: "Follow-up of colorectal cancer treatment", CCSE_83F 7: "Other - Specify", DK/R} — INTERVIEWER: Mark all that apply; if respondent says "Doctor recommended it" or "I requested it", probe for reason
414. CCS_C183S: If CCS_Q183 = 7, go to CCS_Q183S; otherwise go to CCS_Q184 — Filter
415. CCS_Q183S: "INTERVIEWER: Specify." — Text (80 spaces); DK/R
416. CCS_Q184 / CCSE_184: "A colonoscopy or sigmoidoscopy is when a tube is inserted into the rectum to view the bowel for early signs of cancer and other health problems. Have you ever had either of these exams?" — Yes/No {1: "Yes" → continue, 2: "No" → Go to CCS_END, DK/R → Go to CCS_END}
417. CCS_Q185 / CCSE_185: "When was the last time?" — Single select {1: "Less than 1 year ago", 2: "1 year to less than 2 years ago", 3: "2 years to less than 3 years ago", 4: "3 years to less than 5 years ago", 5: "5 years to less than 10 years ago", 6: "10 or more years ago", DK/R}
418. CCS_Q186: "Why did you have it?" — Multi select {CCSE_86A 1: "Family history of colorectal cancer", CCSE_86B 2: "Part of regular check-up / routine screening", CCSE_86C 3: "Age", CCSE_86G 4: "Race", CCSE_86D 5: "Follow-up of problem", CCSE_86E 6: "Follow-up of colorectal cancer treatment", CCSE_86F 7: "Other - Specify", DK/R} — INTERVIEWER: Mark all that apply; if respondent says "Doctor recommended it" or "I requested it", probe for reason
419. CCS_C186S: If CCS_Q186 = 7, go to CCS_Q186S; otherwise go to CCS_C187 — Filter
420. CCS_Q186S: "INTERVIEWER: Specify." — Text (80 spaces); DK/R
421. CCS_C187: If CCS_Q180 = 1 (had a FOBT), go to CCS_Q187; otherwise go to CCS_END — Filter
422. CCS_Q187 / CCSE_187: "Was the colonoscopy or sigmoidoscopy a follow-up of the results of an FOBT?" — Yes/No {1: "Yes", 2: "No", DK/R}

### Section: DEN - Dental Visits - 13 items

423. DEN_C130A: If (do DEN block = 1), go to DEN_C130B; otherwise go to DEN_END — Filter
424. DEN_C130B: If proxy interview, go to DEN_END; otherwise go to DEN_C130C — Filter
425. DEN_C130C: If HCU_Q02E = 0, DK or R, go to DEN_C132; otherwise go to DEN_Q130 — Filter
426. DEN_Q130 / DENE_130: "Now dental visits. It was reported earlier that you have 'seen' or 'talked to' a dentist in the past 12 months. Did you actually visit one?" — Yes/No {1: "Yes" → Go to DEN_END, 2: "No" → continue, DK/R → Go to DEN_END}
427. DEN_C132: If HCU_Q02E = 0, DK, R, go to DEN_R132; otherwise go to DEN_Q132 — Filter
428. DEN_R132: "Now dental visits" — Read
429. DEN_Q132 / DENE_132: "When was the last time that you went to a dentist?" — Single select {1: "Less than 1 year ago" → continue (to edit check), 2: "1 year to less than 2 years ago" → Go to DEN_END, 3: "2 years to less than 3 years ago" → Go to DEN_END, 4: "3 years to less than 4 years ago" → Go to DEN_Q136, 5: "4 years to less than 5 years ago" → Go to DEN_Q136, 6: "5 or more years ago" → Go to DEN_Q136, 7: "Never" → Go to DEN_Q136, DK/R → Go to DEN_END}
430. DEN_E132: Soft edit — if DEN_Q132 = 1 and HCU_Q02E = 0, flag inconsistency ("Inconsistent answers: respondent went to a dentist less than 1 year ago but previously reported had not seen/talked to a dentist in the past 12 months"); if DEN_Q132 = 1, go to DEN_END — Constraint
431. DEN_Q136: "What are the reasons that you have not been to a dentist in the past 3 years?" — Multi select {DENE_36A 1: "Have not gotten around to it", DENE_36B 2: "Respondent - did not think it was necessary", DENE_36C 3: "Dentist - did not think it was necessary", DENE_36D 4: "Personal or family responsibilities", DENE_36E 5: "Not available - at time required", DENE_36F 6: "Not available - at all in the area", DENE_36G 7: "Waiting time was too long", DENE_36H 8: "Transportation - problems", DENE_36I 9: "Language - problem", DENE_36J 10: "Cost", DENE_36K 11: "Did not know where to go / uninformed", DENE_36L 12: "Fear (e.g., painful, embarrassing, find something wrong)", DENE_36M 13: "Wears dentures", DENE_36O 14: "Unable to leave the house because of a health problem", DENE_36N 15: "Other - Specify", DK/R}
432. DEN_C136S: If DEN_Q136 = 15, go to DEN_Q136S; otherwise go to DEN_END — Filter
433. DEN_Q136S: "INTERVIEWER: Specify." — Text (80 spaces); DK/R

### Section: OH2 - Oral Health - 28 items

434. OH2_C10A: Filter — if do OH2 block = 1, continue; otherwise go to OH2_END — Filter
435. OH2_C10B: Filter — if proxy interview, go to OH2_END; otherwise continue — Filter
436. OH2_C10C: Filter — if DEN_Q132 = 7 (never goes to dentist), go to OH2_Q11; otherwise go to OH2_Q10 — Filter
437. OH2_Q10: "Do you usually visit the dentist:" — Single select {1: "More than once a year for check-ups", 2: "About once a year for check-ups", 3: "Less than once a year for check-ups", 4: "Only for emergency care"} — DK/R → OH2_END; all responses → OH2_Q11 (fall through)
438. OH2_Q11: "Do you have insurance that covers all or part of your dental expenses?" — Single select {1: "Yes", 2: "No"} — 1 → OH2_Q11A; 2 → OH2_C12; DK/R → OH2_C12
439. OH2_Q11A: "Is it:" — Multi select {1: "A government-sponsored plan", 2: "An employer-sponsored plan", 3: "A private plan"} — DK/R → OH2_C12; fall through → OH2_C12
440. OH2_C12: Filter — if DEN_Q130 = 1 or DEN_Q132 = 1, go to OH2_Q12; otherwise go to OH2_Q20 — Filter
441. OH2_Q12: "In the past 12 months, have you had any teeth removed by a dentist?" — Single select {1: "Yes", 2: "No"} — 1 → OH2_Q13; 2 → OH2_Q20; DK/R → OH2_Q20
442. OH2_Q13: "(In the past 12 months,) were any teeth removed because of decay or gum disease?" — Single select {1: "Yes", 2: "No"} — DK/R → OH2_Q20; fall through → OH2_Q20
443. OH2_Q20: "Do you have one or more of your own teeth?" — Single select {1: "Yes", 2: "No"} — DK/R → OH2_C21; fall through → OH2_C21
444. OH2_C21: Filter — if DEN_Q136 = 13, go to OH2_Q22; otherwise go to OH2_Q21 — Filter
445. OH2_Q21: "Do you wear dentures or false teeth?" — Single select {1: "Yes", 2: "No"} — DK/R → OH2_R22; fall through → OH2_R22
446. OH2_R22: "Now we have some additional questions about oral health, that is the health of your teeth and mouth." — Read — → OH2_Q22
447. OH2_Q22: "Because of the condition of your [teeth, mouth or dentures/teeth or mouth], do you have difficulty pronouncing any words or speaking clearly?" — Single select {1: "Yes", 2: "No"} — DK/R → OH2_Q23; fall through → OH2_Q23
448. OH2_Q23: "In the past 12 months, how often have you avoided conversation or contact with other people, because of the condition of your [teeth, mouth or dentures/teeth or mouth]?" — Single select {1: "Often", 2: "Sometimes", 3: "Rarely", 4: "Never"} — DK/R → OH2_Q24; fall through → OH2_Q24
449. OH2_Q24: "(In the past 12 months, how often have you avoided:) laughing or smiling, because of the condition of your [teeth, mouth or dentures/teeth or mouth]?" — Single select {1: "Often", 2: "Sometimes", 3: "Rarely", 4: "Never"} — DK/R → OH2_R25; fall through → OH2_R25
450. OH2_R25: "Now some questions about the health of your teeth and mouth during the past month." — Read — → OH2_Q25A
451. OH2_Q25A: "In the past month, have you had a toothache?" — Single select {1: "Yes", 2: "No"} — DK/R → OH2_Q25B; fall through → OH2_Q25B
452. OH2_Q25B: "In the past month, were your teeth sensitive to hot or cold food or drinks?" — Single select {1: "Yes", 2: "No"} — DK/R → OH2_Q25C; fall through → OH2_Q25C
453. OH2_Q25C: "In the past month, have you had pain in or around the jaw joints?" — Single select {1: "Yes", 2: "No"} — DK/R → OH2_Q25D; fall through → OH2_Q25D
454. OH2_Q25D: "(In the past month, have you had:) other pain in the mouth or face?" — Single select {1: "Yes", 2: "No"} — DK/R → OH2_Q25E; fall through → OH2_Q25E
455. OH2_Q25E: "(In the past month, have you had:) bleeding gums?" — Single select {1: "Yes", 2: "No"} — DK/R → OH2_Q25F; fall through → OH2_Q25F
456. OH2_Q25F: "(In the past month, have you had:) dry mouth?" — Single select {1: "Yes", 2: "No"} — DK/R → OH2_Q25G; fall through → OH2_Q25G
457. OH2_Q25G: "(In the past month, have you had:) bad breath?" — Single select {1: "Yes", 2: "No"} — DK/R → OH2_C30; fall through → OH2_C30
458. OH2_C30: Filter — if OH2_Q20 = 1, go to OH2_Q30; otherwise go to OH2_END — Filter
459. OH2_Q30: "How often do you brush your teeth?" — Single select {1: "More than twice a day", 2: "Twice a day", 3: "Once a day", 4: "Less than once a day but more than once a week", 5: "Once a week", 6: "Less than once a week"} — DK/R → OH2_END; fall through → OH2_END

### Section: FDC - Food/Dietary Changes - 18 items

460. FDC_C1A: Filter — if do FDC block = 1, continue; otherwise go to FDC_END — Filter
461. FDC_C1B: Filter — if proxy interview, go to FDC_END; otherwise continue — Filter
462. FDC_QINT: "Now, some questions about the foods you eat." — Read — → FDC_Q1A
463. FDC_Q1A: "Do you choose certain foods or avoid others because you are concerned about your body weight?" — Single select {1: "Yes (or sometimes)", 2: "No"} — 2 → FDC_Q1B; DK/R → FDC_END; 1 → FDC_Q1B
464. FDC_Q1B: "(Do you choose certain foods or avoid others:) because you are concerned about heart disease?" — Single select {1: "Yes (or sometimes)", 2: "No"} — DK/R → FDC_Q1C; fall through → FDC_Q1C
465. FDC_Q1C: "(Do you choose certain foods or avoid others:) because you are concerned about cancer?" — Single select {1: "Yes (or sometimes)", 2: "No"} — DK/R → FDC_Q1D; fall through → FDC_Q1D
466. FDC_Q1D: "(Do you choose certain foods or avoid others:) because you are concerned about osteoporosis (brittle bones)?" — Single select {1: "Yes (or sometimes)", 2: "No"} — DK/R → FDC_Q2A; fall through → FDC_Q2A
467. FDC_Q2A: "Do you choose certain foods because of the lower fat content?" — Single select {1: "Yes (or sometimes)", 2: "No"} — DK/R → FDC_Q2B; fall through → FDC_Q2B
468. FDC_Q2B: "(Do you choose certain foods because of:) the fibre content?" — Single select {1: "Yes (or sometimes)", 2: "No"} — DK/R → FDC_Q2C; fall through → FDC_Q2C
469. FDC_Q2C: "(Do you choose certain foods because of:) the calcium content?" — Single select {1: "Yes (or sometimes)", 2: "No"} — DK/R → FDC_Q3A; fall through → FDC_Q3A
470. FDC_Q3A: "Do you avoid certain foods because of the fat content?" — Single select {1: "Yes (or sometimes)", 2: "No"} — DK/R → FDC_Q3B; fall through → FDC_Q3B
471. FDC_Q3B: "(Do you avoid certain foods because of:) the type of fat they contain?" — Single select {1: "Yes (or sometimes)", 2: "No"} — DK/R → FDC_Q3C; fall through → FDC_Q3C
472. FDC_Q3C: "(Do you avoid certain foods because of:) the salt content?" — Single select {1: "Yes (or sometimes)", 2: "No"} — DK/R → FDC_Q3D; fall through → FDC_Q3D
473. FDC_Q3D: "(Do you avoid certain foods because of:) the cholesterol content?" — Single select {1: "Yes (or sometimes)", 2: "No"} — DK/R → FDC_Q3E; fall through → FDC_Q3E
474. FDC_Q3E: "(Do you avoid certain foods because of:) the calorie content?" — Single select {1: "Yes (or sometimes)", 2: "No"} — DK/R → FDC_END; fall through → FDC_END

### Section: FVC - Fruit and Vegetable Consumption - 37 items

475. FVC_C1A: Filter — if do FVC block = 2 or proxy interview, go to FVC_END; otherwise continue — Filter
476. FVC_QINT: "The next questions are about the foods you usually eat or drink. Think about all the foods you eat, both meals and snacks, at home and away from home." — Read — → FVC_Q1A
477. FVC_Q1A: "How often do you usually drink fruit juices such as orange, grapefruit or tomato?" — Single select {1: "Per day", 2: "Per week", 3: "Per month", 4: "Per year", 5: "Never"} — 1 → FVC_N1B; 2 → FVC_N1C; 3 → FVC_N1D; 4 → FVC_N1E; 5 → FVC_Q2A; DK/R → FVC_END
478. FVC_N1B: "Enter number of times per day [fruit juice]." — Numeric (1–20) — DK/R → FVC_Q2A; fall through → FVC_Q2A
479. FVC_N1C: "Enter number of times per week [fruit juice]." — Numeric (1–90) — DK/R → FVC_Q2A; fall through → FVC_Q2A
480. FVC_N1D: "Enter number of times per month [fruit juice]." — Numeric (1–200) — DK/R → FVC_Q2A; fall through → FVC_Q2A
481. FVC_N1E: "Enter number of times per year [fruit juice]." — Numeric (1–500) — DK/R → FVC_Q2A; fall through → FVC_Q2A
482. FVC_Q2A: "Not counting juice, how often do you usually eat fruit?" — Single select {1: "Per day", 2: "Per week", 3: "Per month", 4: "Per year", 5: "Never"} — 1 → FVC_N2B; 2 → FVC_N2C; 3 → FVC_N2D; 4 → FVC_N2E; 5 → FVC_Q3A; DK/R → FVC_Q3A
483. FVC_N2B: "Enter number of times per day [fruit]." — Numeric (1–20) — DK/R → FVC_Q3A; fall through → FVC_Q3A
484. FVC_N2C: "Enter number of times per week [fruit]." — Numeric (1–90) — DK/R → FVC_Q3A; fall through → FVC_Q3A
485. FVC_N2D: "Enter number of times per month [fruit]." — Numeric (1–200) — DK/R → FVC_Q3A; fall through → FVC_Q3A
486. FVC_N2E: "Enter number of times per year [fruit]." — Numeric (1–500) — DK/R → FVC_Q3A; fall through → FVC_Q3A
487. FVC_Q3A: "How often do you (usually) eat green salad?" — Single select {1: "Per day", 2: "Per week", 3: "Per month", 4: "Per year", 5: "Never"} — 1 → FVC_N3B; 2 → FVC_N3C; 3 → FVC_N3D; 4 → FVC_N3E; 5 → FVC_Q4A; DK/R → FVC_Q4A
488. FVC_N3B: "Enter number of times per day [green salad]." — Numeric (1–20) — DK/R → FVC_Q4A; fall through → FVC_Q4A
489. FVC_N3C: "Enter number of times per week [green salad]." — Numeric (1–90) — DK/R → FVC_Q4A; fall through → FVC_Q4A
490. FVC_N3D: "Enter number of times per month [green salad]." — Numeric (1–200) — DK/R → FVC_Q4A; fall through → FVC_Q4A
491. FVC_N3E: "Enter number of times per year [green salad]." — Numeric (1–500) — DK/R → FVC_Q4A; fall through → FVC_Q4A
492. FVC_Q4A: "How often do you usually eat potatoes, not including french fries, fried potatoes, or potato chips?" — Single select {1: "Per day", 2: "Per week", 3: "Per month", 4: "Per year", 5: "Never"} — 1 → FVC_N4B; 2 → FVC_N4C; 3 → FVC_N4D; 4 → FVC_N4E; 5 → FVC_Q5A; DK/R → FVC_Q5A
493. FVC_N4B: "Enter number of times per day [potatoes]." — Numeric (1–20) — DK/R → FVC_Q5A; fall through → FVC_Q5A
494. FVC_N4C: "Enter number of times per week [potatoes]." — Numeric (1–90) — DK/R → FVC_Q5A; fall through → FVC_Q5A
495. FVC_N4D: "Enter number of times per month [potatoes]." — Numeric (1–200) — DK/R → FVC_Q5A; fall through → FVC_Q5A
496. FVC_N4E: "Enter number of times per year [potatoes]." — Numeric (1–500) — DK/R → FVC_Q5A; fall through → FVC_Q5A
497. FVC_Q5A: "How often do you (usually) eat carrots?" — Single select {1: "Per day", 2: "Per week", 3: "Per month", 4: "Per year", 5: "Never"} — 1 → FVC_N5B; 2 → FVC_N5C; 3 → FVC_N5D; 4 → FVC_N5E; 5 → FVC_Q6A; DK/R → FVC_Q6A
498. FVC_N5B: "Enter number of times per day [carrots]." — Numeric (1–20) — DK/R → FVC_Q6A; fall through → FVC_Q6A
499. FVC_N5C: "Enter number of times per week [carrots]." — Numeric (1–90) — DK/R → FVC_Q6A; fall through → FVC_Q6A
500. FVC_N5D: "Enter number of times per month [carrots]." — Numeric (1–200) — DK/R → FVC_Q6A; fall through → FVC_Q6A
501. FVC_N5E: "Enter number of times per year [carrots]." — Numeric (1–500) — DK/R → FVC_Q6A; fall through → FVC_Q6A
502. FVC_Q6A: "Not counting carrots, potatoes, or salad, how many servings of other vegetables do you usually eat?" — Single select {1: "Per day", 2: "Per week", 3: "Per month", 4: "Per year", 5: "Never"} — 1 → FVC_N6B; 2 → FVC_N6C; 3 → FVC_N6D; 4 → FVC_N6E; 5 → FVC_END; DK/R → FVC_END
503. FVC_N6B: "Enter number of servings per day [other vegetables]." — Numeric (1–20) — DK/R → FVC_END; fall through → FVC_END
504. FVC_N6C: "Enter number of servings per week [other vegetables]." — Numeric (1–90) — DK/R → FVC_END; fall through → FVC_END
505. FVC_N6D: "Enter number of servings per month [other vegetables]." — Numeric (1–200) — DK/R → FVC_END; fall through → FVC_END
506. FVC_N6E: "Enter number of servings per year [other vegetables]." — Numeric (1–500) — DK/R → FVC_END; fall through → FVC_END

### Section: PAC - Physical Activity - 17 items

507. PAC_C1: Filter — if do PAC block = 1, go to PAC_C2; otherwise go to PAC_END — Filter
508. PAC_C2: Filter — if proxy interview, go to PAC_END; otherwise continue — Filter
509. PAC_R1: "Now I'd like to ask you about some of your physical activities. To begin with, I'll be dealing with physical activities not related to work, that is, leisure time activities." — Read — → PAC_Q1
510. PAC_Q1: "Have you done any of the following in the past 3 months?" — Multi select {1: "Walking for exercise", 2: "Gardening or yard work", 3: "Swimming", 4: "Bicycling", 5: "Popular or social dance", 6: "Home exercises", 7: "Ice hockey", 8: "Ice skating", 9: "In-line skating or rollerblading", 10: "Jogging or running", 11: "Golfing", 12: "Exercise class or aerobics", 13: "Downhill skiing or snowboarding", 14: "Bowling", 15: "Baseball or softball", 16: "Tennis", 17: "Weight-training", 18: "Fishing", 19: "Volleyball", 20: "Basketball", 21: "Soccer", 22: "Any other", 23: "No physical activity"} — 23 → PAC_R2; DK/R → PAC_END; 22 → PAC_Q1VS (via PAC_C1VS); others → PAC_Q2n (fall through)
511. PAC_C1VS: Filter — if "Any other" (22) chosen, go to PAC_Q1VS; otherwise go to PAC_Q2 — Filter
512. PAC_Q1VS: "What was this activity?" — Text (80 chars) — DK/R → PAC_Q2; fall through → PAC_Q1X
513. PAC_Q1X: "In the past 3 months, did you do any other physical activity for leisure?" — Single select {1: "Yes", 2: "No"} — 1 → PAC_Q1XS; 2 → PAC_Q2; DK/R → PAC_Q2
514. PAC_Q1XS: "What was this activity?" — Text (80 chars) — DK/R → PAC_Q2; fall through → PAC_Q1Y
515. PAC_Q1Y: "In the past 3 months, did you do any other physical activity for leisure?" — Single select {1: "Yes", 2: "No"} — 1 → PAC_Q1YS; 2 → PAC_Q2; DK/R → PAC_Q2
516. PAC_Q1YS: "What was this activity?" — Text (80 chars) — DK/R → PAC_Q2; fall through → PAC_Q2
517. PAC_E1: Constraint — "You cannot select 'No physical activity' and another category." — hard edit if PAC_Q1 = 23 with any other response — Postcondition
518. PAC_Q2n: "In the past 3 months, how many times did you [participate in identified activity]?" — Numeric (1–99; Walking: 1–270; Bicycling/Other: 1–200) — DK/R → next activity; fall through → PAC_Q3n (per identified activity)
519. PAC_Q3n: "About how much time did you spend on each occasion?" — Single select {1: "1 to 15 minutes", 2: "16 to 30 minutes", 3: "31 to 60 minutes", 4: "More than one hour"} — DK/R → next activity; fall through → next activity (per identified activity)
520. PAC_R2: "Next, some questions about the amount of time you spent in the past 3 months on physical activity at work or while doing daily chores around the house, but not leisure time activity." — Read — → PAC_Q4A
521. PAC_Q4A: "In a typical week in the past 3 months, how many hours did you usually spend walking to work or to school or while doing errands?" — Single select {1: "None", 2: "Less than 1 hour", 3: "From 1 to 5 hours", 4: "From 6 to 10 hours", 5: "From 11 to 20 hours", 6: "More than 20 hours"} — DK/R → PAC_Q4B; fall through → PAC_Q4B
522. PAC_Q4B: "(In a typical week in the past 3 months,) how many hours did you usually spend bicycling to work or to school or while doing errands?" — Single select {1: "None", 2: "Less than 1 hour", 3: "From 1 to 5 hours", 4: "From 6 to 10 hours", 5: "From 11 to 20 hours", 6: "More than 20 hours"} — DK/R → PAC_Q6; fall through → PAC_Q6
523. PAC_Q6: "Thinking back over the past 3 months, which of the following best describes your usual daily activities or work habits?" — Single select {1: "Usually sit during the day and don't walk around very much", 2: "Stand or walk quite a lot during the day but don't have to carry or lift things very often", 3: "Usually lift or carry light loads, or have to climb stairs or hills often", 4: "Do heavy work or carry very heavy loads"} — DK/R → PAC_END; fall through → PAC_END

### Section: SAC - Sedentary Activities - 8 items

524. SAC_C1: Filter — if do SAC block = 1, go to SAC_CINT; otherwise go to SAC_END — Filter
525. SAC_CINT: Filter — if proxy interview, go to SAC_END; otherwise go to SAC_R1 — Filter
526. SAC_R1: "Now, a few additional questions about activities you do in your leisure time, that is, activities not at work or at school." — Read — → SAC_Q1
527. SAC_Q1: "In a typical week in the past 3 months, how much time did you usually spend on a computer, including playing computer games and using the Internet?" — Single select {1: "None", 2: "Less than 1 hour", 3: "From 1 to 2 hours", 4: "From 3 to 5 hours", 5: "From 6 to 10 hours", 6: "From 11 to 14 hours", 7: "From 15 to 20 hours", 8: "More than 20 hours"} — DK/R → SAC_END; fall through → SAC_C2
528. SAC_C2: Filter — if age > 19, go to SAC_Q3; otherwise continue to SAC_Q2 — Filter
529. SAC_Q2: "(In a typical week in the past 3 months, how much time did you usually spend:) playing video games, such as XBOX, Nintendo and Playstation?" — Single select {1: "None", 2: "Less than 1 hour", 3: "From 1 to 2 hours", 4: "From 3 to 5 hours", 5: "From 6 to 10 hours", 6: "From 11 to 14 hours", 7: "From 15 to 20 hours", 8: "More than 20 hours"} — DK/R → SAC_Q3; fall through → SAC_Q3
530. SAC_Q3: "(In a typical week in the past 3 months, how much time did you usually spend:) watching television or videos?" — Single select {1: "None", 2: "Less than 1 hour", 3: "From 1 to 2 hours", 4: "From 3 to 5 hours", 5: "From 6 to 10 hours", 6: "From 11 to 14 hours", 7: "From 15 to 20 hours", 8: "More than 20 hours"} — DK/R → SAC_Q4; fall through → SAC_Q4
531. SAC_Q4: "(In a typical week in the past 3 months, how much time did you usually spend:) reading, not counting at work or at school?" — Single select {1: "None", 2: "Less than 1 hour", 3: "From 1 to 2 hours", 4: "From 3 to 5 hours", 5: "From 6 to 10 hours", 6: "From 11 to 14 hours", 7: "From 15 to 20 hours", 8: "More than 20 hours"} — DK/R → SAC_END; fall through → SAC_END

### Section: UPE - Use of Protective Equipment - 22 items

532. UPE_C1A: Filter — if do UPE block = 1, go to UPE_C1B; otherwise go to UPE_END — Filter
533. UPE_C1B: Filter — if proxy interview, go to UPE_END; otherwise go to UPE_CINT — Filter
534. UPE_CINT: Filter — if PAC_Q1 = 4 or PAC_Q1 = 9 or PAC_Q1 = 13 or PAC_Q4B > 1 and < 7, go to UPE_QINT; otherwise go to UPE_C3A — Filter
535. UPE_QINT: "Now a few questions about precautions you take while participating in physical activities." — Read — → UPE_C1C
536. UPE_C1C: Filter — if PAC_Q1 = 4 or PAC_Q4B > 1 and < 7, go to UPE_Q1; otherwise go to UPE_C2A — Filter
537. UPE_Q1: "When riding a bicycle, how often do you wear a helmet?" — Single select {1: "Always", 2: "Most of the time", 3: "Rarely", 4: "Never"} — DK/R → UPE_C2A; fall through → UPE_C2A
538. UPE_C2A: Filter — if PAC_Q1 = 9, go to UPE_Q2A; otherwise go to UPE_C3A — Filter
539. UPE_Q2A: "When in-line skating or rollerblading, how often do you wear a helmet?" — Single select {1: "Always", 2: "Most of the time", 3: "Rarely", 4: "Never"} — DK/R → UPE_Q2B; fall through → UPE_Q2B
540. UPE_Q2B: "How often do you wear wrist guards or wrist protectors?" — Single select {1: "Always", 2: "Most of the time", 3: "Rarely", 4: "Never"} — DK/R → UPE_Q2C; fall through → UPE_Q2C
541. UPE_Q2C: "How often do you wear elbow pads?" — Single select {1: "Always", 2: "Most of the time", 3: "Rarely", 4: "Never"} — DK/R → UPE_C3A; fall through → UPE_C3A
542. UPE_C3A: Filter — if PAC_Q1 = 13, go to UPE_Q3A; otherwise go to UPE_Q3B — Filter
543. UPE_Q3A: "Earlier, you mentioned going downhill skiing or snowboarding in the past 3 months. Was that:" — Single select {1: "Downhill skiing only", 2: "Snowboarding only", 3: "Both"} — 1 → UPE_Q4A; 2 → UPE_C5A; 3 → UPE_Q4A; DK/R → UPE_C6
544. UPE_Q3B: "In the past 12 months, did you do any downhill skiing or snowboarding?" — Single select {1: "Downhill skiing only", 2: "Snowboarding only", 3: "Both", 4: "Neither"} — 1 → UPE_Q4A; 2 → UPE_C5A; 3 → UPE_Q4A; 4 → UPE_C6; DK/R → UPE_C6
545. UPE_Q4A: "When downhill skiing, how often do you wear a helmet?" — Single select {1: "Always", 2: "Most of the time", 3: "Rarely", 4: "Never"} — DK/R → UPE_C5A; fall through → UPE_C5A
546. UPE_C5A: Filter — if UPE_Q3A = 2 or 3 or UPE_Q3B = 2 or 3, go to UPE_Q5A; otherwise go to UPE_C6 — Filter
547. UPE_Q5A: "When snowboarding, how often do you wear a helmet?" — Single select {1: "Always", 2: "Most of the time", 3: "Rarely", 4: "Never"} — DK/R → UPE_Q5B; fall through → UPE_Q5B
548. UPE_Q5B: "How often do you wear wrist guards or wrist protectors?" — Single select {1: "Always", 2: "Most of the time", 3: "Rarely", 4: "Never"} — DK/R → UPE_C6; fall through → UPE_C6
549. UPE_C6: Filter — if age >= 12 and <= 19, go to UPE_Q6; otherwise go to UPE_END — Filter
550. UPE_Q6: "In the past 12 months, have you done any skateboarding?" — Single select {1: "Yes", 2: "No"} — 1 → UPE_Q6A; 2 → UPE_END; DK/R → UPE_END
551. UPE_Q6A: "How often do you wear a helmet?" — Single select {1: "Always", 2: "Most of the time", 3: "Rarely", 4: "Never"} — DK/R → UPE_Q6B; fall through → UPE_Q6B
552. UPE_Q6B: "How often do you wear wrist guards or wrist protectors?" — Single select {1: "Always", 2: "Most of the time", 3: "Rarely", 4: "Never"} — DK/R → UPE_Q6C; fall through → UPE_Q6C
553. UPE_Q6C: "How often do you wear elbow pads?" — Single select {1: "Always", 2: "Most of the time", 3: "Rarely", 4: "Never"} — DK/R → UPE_END; fall through → UPE_END

### Section: SSB - Sun Safety Behaviours - 15 items

554. SSB_C1: Filter — If (do SSB block = 1) go to SSB_C2; otherwise go to SSB_END — Filter
555. SSB_C2: Filter — If proxy interview go to SSB_END; otherwise go to SSB_R01 — Filter
556. SSB_R01: "The next few questions are about exposure to the sun and sunburns. Sunburn is defined as any reddening or discomfort of the skin, that lasts longer than 12 hours after exposure to the sun or other UV sources, such as tanning beds or sun lamps." — Read — press Enter to continue
557. SSB_Q01: "In the past 12 months, has any part of your body been sunburnt?" — Yes/No {1: "Yes", 2: "No → SSB_R06", DK/R → SSB_END}
558. SSB_Q02: "Did any of your sunburns involve blistering?" — Yes/No {1: "Yes", 2: "No", DK/R}
559. SSB_Q03: "Did any of your sunburns involve pain or discomfort that lasted for more than 1 day?" — Yes/No {1: "Yes", 2: "No", DK/R}
560. SSB_R06: "For the next questions, think about a typical weekend, or day off from work or school in the summer months." — Read — press Enter to continue
561. SSB_Q06: "About how much time each day do you spend in the sun between 11 am and 4 pm?" — Single select {1: "None → SSB_END", 2: "Less than 30 minutes → SSB_END", 3: "30 to 59 minutes", 4: "1 hour to less than 2 hours", 5: "2 hours to less than 3 hours", 6: "3 hours to less than 4 hours", 7: "4 hours to less than 5 hours", 8: "5 hours", DK/R → SSB_END}
562. SSB_Q07: "In the summer months, on a typical weekend or day off, when you are in the sun for 30 minutes or more, how often do you … seek shade?" — Scale {1: "Always", 2: "Often", 3: "Sometimes", 4: "Rarely", 5: "Never", DK/R}
563. SSB_Q08: "… wear a hat that shades your face, ears and neck?" — Scale {1: "Always", 2: "Often", 3: "Sometimes", 4: "Rarely", 5: "Never", DK/R}
564. SSB_Q09A: "… wear long pants or a long skirt to protect your skin from the sun?" — Scale {1: "Always", 2: "Often", 3: "Sometimes", 4: "Rarely", 5: "Never", DK/R}
565. SSB_Q09B: "… use sunscreen on your face?" — Scale {1: "Always", 2: "Often", 3: "Sometimes", 4: "Rarely → SSB_Q11", 5: "Never → SSB_Q11", DK/R → SSB_Q11}
566. SSB_Q10: "What Sun Protection Factor (SPF) do you usually use?" — Single select {1: "Less than 15", 2: "15 to 25", 3: "More than 25", DK/R}
567. SSB_Q11: "… use sunscreen on your body?" — Scale {1: "Always", 2: "Often", 3: "Sometimes", 4: "Rarely → SSB_END", 5: "Never → SSB_END", DK/R → SSB_END}
568. SSB_Q12: "What Sun Protection Factor (SPF) do you usually use?" — Single select {1: "Less than 15", 2: "15 to 25", 3: "More than 25", DK/R}

### Section: SMK - Smoking - 33 items

569. SMK_C1: Filter — If (do SMK block = 1) go to SMK_QINT; otherwise go to SMK_END — Filter
570. SMK_QINT: "The next questions are about smoking." — Read — press Enter to continue
571. SMK_Q201A: "In your lifetime, have you smoked a total of 100 or more cigarettes (about 4 packs)?" — Yes/No {1: "Yes → SMK_Q201C", 2: "No", DK/R}
572. SMK_Q201B: "Have you ever smoked a whole cigarette?" — Yes/No {1: "Yes → SMK_Q201C", 2: "No → SMK_Q202", DK → SMK_Q202", R}
573. SMK_C201C: Filter — If SMK_Q201A = R and SMK_Q201B = R go to SMK_END; otherwise go to SMK_Q202 — Filter
574. SMK_Q201C: "At what age did you smoke your first whole cigarette?" — Numeric (min: 5, max: current age) {DK/R → SMK_Q202}
575. SMK_E201C: Constraint — Trigger hard edit if SMK_Q201C < 5 or SMK_Q201C > current age — Postcondition
576. SMK_Q202: "At the present time, do you smoke cigarettes daily, occasionally or not at all?" — Single select {1: "Daily", 2: "Occasionally → SMK_Q205B", 3: "Not at all → SMK_C205D", DK/R → SMK_END}
577. SMK_Q203: "At what age did you begin to smoke cigarettes daily?" — Numeric (min: 5, max: current age) {DK/R → SMK_Q204}
578. SMK_E203: Constraint — Trigger hard edit if SMK_Q203 < 5 or SMK_Q203 > current age — Postcondition
579. SMK_Q204: "How many cigarettes do you smoke each day now?" — Numeric (min: 1, max: 99; warning after 60) {DK/R; Go to SMK_END}
580. SMK_Q205B: "On the days that you do smoke, how many cigarettes do you usually smoke?" — Numeric (min: 1, max: 99; warning after 60) {DK/R}
581. SMK_Q205C: "In the past month, on how many days have you smoked 1 or more cigarettes?" — Numeric (min: 0, max: 30) {DK/R}
582. SMK_C205D: Filter — If SMK_Q201A = 2, DK or R go to SMK_END — Filter
583. SMK_Q205D: "Have you ever smoked cigarettes daily?" — Yes/No {1: "Yes → SMK_Q207", 2: "No", DK/R → SMK_END}
584. SMK_C206A: Filter — If SMK_Q202 = 2 go to SMK_END; otherwise go to SMK_Q206A — Filter
585. SMK_Q206A: "When did you stop smoking? Was it:" — Single select {1: "… less than one year ago?", 2: "… 1 year to less than 2 years ago? → SMK_END", 3: "… 2 years to less than 3 years ago? → SMK_END", 4: "… 3 or more years ago? → SMK_Q206C", DK/R → SMK_END}
586. SMK_Q206B: "In what month did you stop?" — Single select {1: "January", 2: "February", 3: "March", 4: "April", 5: "May", 6: "June", 7: "July", 8: "August", 9: "September", 10: "October", 11: "November", 12: "December", DK/R; Go to SMK_END}
587. SMK_Q206C: "How many years ago was it?" — Numeric (min: 3, max: current age - 5) {DK/R → SMK_END}
588. SMK_E206C: Constraint — Trigger hard edit if SMK_Q206C < 3 or SMK_Q206C > current age - 5 — Postcondition
589. SMK_Q207: "At what age did you begin to smoke (cigarettes) daily?" — Numeric (min: 5, max: current age) {DK/R → SMK_Q208}
590. SMK_E207: Constraint — Trigger hard edit if SMK_Q207 < 5 or SMK_Q207 > current age — Postcondition
591. SMK_Q208: "How many cigarettes did you usually smoke each day?" — Numeric (min: 1, max: 99; warning after 60) {DK/R}
592. SMK_Q209A: "When did you stop smoking daily? Was it:" — Single select {1: "… less than one year ago?", 2: "… 1 year to less than 2 years ago? → SMK_C210", 3: "… 2 years to less than 3 years ago? → SMK_C210", 4: "… 3 or more years ago? → SMK_Q209C", DK/R → SMK_END}
593. SMK_Q209B: "In what month did you stop?" — Single select {1: "January", 2: "February", 3: "March", 4: "April", 5: "May", 6: "June", 7: "July", 8: "August", 9: "September", 10: "October", 11: "November", 12: "December", DK/R; Go to SMK_C210}
594. SMK_Q209C: "How many years ago was it?" — Numeric (min: 3, max: current age - 5) {DK/R → SMK_C210}
595. SMK_E209C: Constraint — Trigger hard edit if SMK_Q209C < 3 or SMK_Q209C > current age - 5 — Postcondition
596. SMK_C210: Filter — If SMK_Q202 = 2 go to SMK_END; otherwise go to SMK_Q210 — Filter
597. SMK_Q210: "Was that when you completely quit smoking?" — Yes/No {1: "Yes → SMK_END", 2: "No", DK/R → SMK_END}
598. SMK_Q210A: "When did you stop smoking completely? Was it:" — Single select {1: "… less than one year ago?", 2: "… 1 year to less than 2 years ago? → SMK_END", 3: "… 2 years to less than 3 years ago? → SMK_END", 4: "… 3 or more years ago? → SMK_Q210C", DK/R → SMK_END}
599. SMK_Q210B: "In what month did you stop?" — Single select {1: "January", 2: "February", 3: "March", 4: "April", 5: "May", 6: "June", 7: "July", 8: "August", 9: "September", 10: "October", 11: "November", 12: "December", DK/R; Go to SMK_END}
600. SMK_Q210C: "How many years ago was it?" — Numeric (min: 3, max: current age - 5) {DK/R → SMK_END}
601. SMK_E210C: Constraint — Trigger hard edit if SMK_Q210C < 3 or SMK_Q210C > current age - 5 — Postcondition

### Section: SCH - Smoking - Stages of Change - 7 items

602. SCH_C1: Filter — If (do SCH block = 1) go to SCH_C2; otherwise go to SCH_END — Filter
603. SCH_C2: Filter — If SMK_Q202 = 1 or 2 go to SCH_C3; otherwise go to SCH_END — Filter
604. SCH_C3: Filter — If proxy interview go to SCH_END; otherwise go to SCH_Q1 — Filter
605. SCH_Q1: "Are you seriously considering quitting smoking within the next 6 months?" — Yes/No {1: "Yes", 2: "No → SCH_Q3", DK/R → SCH_Q3}
606. SCH_Q2: "Are you seriously considering quitting within the next 30 days?" — Yes/No {1: "Yes", 2: "No", DK/R}
607. SCH_Q3: "In the past 12 months, did you stop smoking for at least 24 hours because you were trying to quit?" — Yes/No {1: "Yes", 2: "No → SCH_END", DK/R → SCH_END}
608. SCH_Q4: "How many times? (in the past 12 months, did you stop smoking for at least 24 hours because you were trying to quit)" — Numeric (min: 1, max: 95; warning after 48) {DK/R}

### Section: NDE - Nicotine Dependence - 8 items

609. NDE_C1: Filter — If (do NDE block = 1) go to NDE_C2; otherwise go to NDE_END — Filter
610. NDE_C2: Filter — If SMK_Q202 = 1 go to NDE_C3; otherwise go to NDE_END — Filter
611. NDE_C3: Filter — If proxy interview go to NDE_END; otherwise go to NDE_Q1 — Filter
612. NDE_Q1: "How soon after you wake up do you smoke your first cigarette?" — Single select {1: "Within 5 minutes", 2: "6 - 30 minutes after waking", 3: "31 - 60 minutes after waking", 4: "More than 60 minutes after waking", DK/R → NDE_END}
613. NDE_Q2: "Do you find it difficult to refrain from smoking in places where it is forbidden?" — Yes/No {1: "Yes", 2: "No", DK/R}
614. NDE_Q3: "Which cigarette would you most hate to give up?" — Single select {1: "The first one of the day", 2: "Another one", DK/R}
615. NDE_Q4: "Do you smoke more frequently during the first hours after waking, compared with the rest of the day?" — Yes/No {1: "Yes", 2: "No", DK/R}
616. NDE_Q5: "Do you smoke even if you are so ill that you are in bed most of the day?" — Yes/No {1: "Yes", 2: "No", DK/R}

### Section: SCA - Smoking Cessation Aids - 16 items

617. SCA_C1: Filter — If (do SCA block = 1) go to SCA_C10A; otherwise go to SCA_END — Filter
618. SCA_C10A: Filter — If proxy interview go to SCA_END; otherwise go to SCA_C10B — Filter
619. SCA_C10B: Filter — If SMK_Q202 = 1 or 2 go to SCA_C50; otherwise go to SCA_C10C — Filter
620. SCA_C10C: Filter — If SMK_Q206A = 1 or SMK_Q209A = 1 go to SCA_Q10; otherwise go to SCA_END — Filter
621. SCA_Q10: "In the past 12 months, did you try a nicotine patch to quit smoking?" — Yes/No {1: "Yes", 2: "No → SCA_Q11", DK/R → SCA_END}
622. SCA_Q10A: "How useful was that in helping you quit?" — Single select {1: "Very useful", 2: "Somewhat useful", 3: "Not very useful", 4: "Not useful at all", DK/R}
623. SCA_Q11: "Did you try Nicorettes or other nicotine gum or candy to quit smoking? (In the past 12 months)" — Yes/No {1: "Yes", 2: "No → SCA_Q12", DK/R → SCA_Q12}
624. SCA_Q11A: "How useful was that in helping you quit?" — Single select {1: "Very useful", 2: "Somewhat useful", 3: "Not very useful", 4: "Not useful at all", DK/R}
625. SCA_Q12: "In the past 12 months, did you try medication such as Zyban, Prolev or Wellbutrin to quit smoking?" — Yes/No {1: "Yes", 2: "No → SCA_END", DK/R → SCA_END}
626. SCA_Q12A: "How useful was that in helping you quit?" — Single select {1: "Very useful", 2: "Somewhat useful", 3: "Not very useful", 4: "Not useful at all", DK/R; Go to SCA_END}
627. SCA_C50: Filter — If (do SCH block = 2) go to SCA_Q50; otherwise go to SCA_C50A — Filter
628. SCA_C50A: Filter — If SCH_Q3 = 1 go to SCA_Q60; otherwise go to SCA_END — Filter
629. SCA_Q50: "In the past 12 months, did you stop smoking for at least 24 hours because you were trying to quit?" — Yes/No {1: "Yes", 2: "No → SCA_END", DK/R → SCA_END}
630. SCA_Q60: "In the past 12 months, did you try any of the following to quit smoking: … a nicotine patch?" — Yes/No {1: "Yes", 2: "No", DK/R}
631. SCA_Q61: "… Nicorettes or other nicotine gum or candy?" — Yes/No {1: "Yes", 2: "No", DK/R}
632. SCA_Q62: "… medication such as Zyban, Prolev or Wellbutrin?" — Yes/No {1: "Yes", 2: "No", DK/R}

### Section: SPC - Smoking - Physician Counselling - 14 items

633. SPC_C1: Filter — If (do SPC block = 1) go to SPC_C2; otherwise go to SPC_END — Filter
634. SPC_C2: Filter — If proxy interview go to SPC_END; otherwise go to SPC_C3 — Filter
635. SPC_C3: Filter — If SMK_Q202 = 1 or 2 or SMK_Q206A = 1 or SMK_Q209A = 1 go to SPC_C4; otherwise go to SPC_END — Filter
636. SPC_C4: Filter — If (do HCU block = 1) and HCU_Q01AA = 1 go to SPC_Q10; otherwise go to SPC_C20A — Filter
637. SPC_Q10: "Earlier, you mentioned having a regular medical doctor. In the past 12 months, did you go see this doctor?" — Yes/No {1: "Yes", 2: "No → SPC_C20A", DK/R → SPC_C20A}
638. SPC_Q11: "Does your doctor know that you [smoke/smoked] cigarettes?" — Yes/No {1: "Yes", 2: "No → SPC_C20A", DK/R → SPC_C20A}
639. SPC_Q12: "In the past 12 months, did your doctor advise you to quit smoking?" — Yes/No {1: "Yes", 2: "No", DK/R → SPC_C20A}
640. SPC_Q13: "Did your doctor give you any specific help or information to quit smoking?" — Yes/No {1: "Yes", 2: "No → SPC_C20A", DK/R → SPC_C20A}
641. SPC_Q14: "What type of help did the doctor give?" — Multi select {1 (SPCE_14A): "Referral to a one-on-one cessation program", 2 (SPCE_14B): "Referral to a group cessation program", 3 (SPCE_14C): "Recommended use of nicotine patch or nicotine gum", 4 (SPCE_14D): "Recommended Zyban or other medication", 5 (SPCE_14E): "Provided self-help information", 6 (SPCE_14F): "Own doctor offered counselling", 7 (SPCE_14G): "Other", DK/R}
642. SPC_C20A: Filter — If (do DEN block = 1) and DEN_Q130 = 1 or DEN_Q132 = 1 go to SPC_Q21; if (do DEN block = 1) and DEN_Q130 = 2, DK or R go to SPC_END; otherwise go to SPC_C20 — Filter
643. SPC_C20: Filter — If (do HCU block = 1) and HCU_Q02E > 0 and < 998 go to SPC_Q20; otherwise go to SPC_END — Filter
644. SPC_Q20: "Earlier, you mentioned having 'seen or talked to' a dentist in the past 12 months. Did you actually go to the dentist?" — Yes/No {1: "Yes", 2: "No → SPC_END", DK/R → SPC_END}
645. SPC_Q21: "Does your dentist or dental hygienist know that you [smoke/smoked] cigarettes?" — Yes/No {1: "Yes", 2: "No → SPC_END", DK/R → SPC_END}
646. SPC_Q22: "In the past 12 months, did the dentist or hygienist advise you to quit smoking?" — Yes/No {1: "Yes", 2: "No", DK/R}

### Section: YSM - Youth Smoking - 10 items

647. YSM_C1: Filter — If (do YSM block = 1) go to YSM_C1A; otherwise go to YSM_END — Filter
648. YSM_C1A: Filter — If proxy interview or age > 19 go to YSM_END; otherwise go to YSM_C1B — Filter
649. YSM_C1B: Filter — If SMK_Q202 = 1 or 2 go to YSM_Q1; otherwise go to YSM_END — Filter
650. YSM_Q1: "Where do you usually get your cigarettes?" — Single select {1: "Buy from - Vending machine", 2: "Buy from - Small grocery / corner store", 3: "Buy from - Supermarket", 4: "Buy from - Drug store", 5: "Buy from - Gas station", 6: "Buy from - Other store", 7: "Buy from - Friend or someone else", 8: "Given them by - Brother or sister", 9: "Given them by - Mother or father", 10: "Given them by - Friend or someone else", 11: "Take them from - Mother, father or sibling", 12: "Other - Specify", DK/R → YSM_END}
651. YSM_C1S: Filter — If YSM_Q1 = 12 go to YSM_Q1S; otherwise go to YSM_C2 — Filter
652. YSM_Q1S: "INTERVIEWER: Specify." — Text (80 spaces) {DK/R}
653. YSM_C2: Filter — If YSM_Q1 = 1, 2, 3, 4, 5, 6 or 7 go to YSM_Q3; otherwise go to YSM_Q2 — Filter
654. YSM_Q2: "In the past 12 months, have you bought cigarettes for yourself or for someone else?" — Yes/No {1: "Yes", 2: "No → YSM_Q5", DK/R → YSM_Q5}
655. YSM_Q3: "In the past 12 months, have you been asked your age when buying cigarettes in a store?" — Yes/No {1: "Yes", 2: "No", DK/R}
656. YSM_Q4: "In the past 12 months, has anyone in a store refused to sell you cigarettes?" — Yes/No {1: "Yes", 2: "No", DK/R}
657. YSM_Q5: "In the past 12 months, have you asked a stranger to buy you cigarettes?" — Yes/No {1: "Yes", 2: "No", DK/R}

### Section: ETS - Exposure to Second-Hand Smoke - 11 items

658. ETS_C1: Filter — If (do ETS block = 1) go to ETS_QINT; otherwise go to ETS_END — Filter
659. ETS_QINT: "The next questions are about exposure to second-hand smoke." — Read — press Enter to continue
660. ETS_C10: Filter — If number of household members = 1 and SMK_Q202 = 1 or 2 go to ETS_Q30; otherwise go to ETS_Q10 — Filter
661. ETS_Q10: "Including both household members and regular visitors, does anyone smoke inside your home, every day or almost every day?" — Yes/No {1: "Yes", 2: "No → ETS_C20", DK/R → ETS_END}
662. ETS_Q11: "How many people smoke inside your home every day or almost every day?" — Numeric (min: 1, max: 15) {DK/R}
663. ETS_C20: Filter — If SMK_Q202 = 1 or 2 go to ETS_Q30; otherwise go to ETS_Q20 — Filter
664. ETS_Q20: "In the past month, were you exposed to second-hand smoke, every day or almost every day, in a car or other private vehicle?" — Yes/No {1: "Yes", 2: "No", DK/R}
665. ETS_Q20B: "In the past month, were you exposed to second-hand smoke, every day or almost every day, in public places (such as bars, restaurants, shopping malls, arenas, bingo halls, bowling alleys)?" — Yes/No {1: "Yes", 2: "No", DK/R}
666. ETS_Q30: "Are there any restrictions against smoking cigarettes in your home?" — Yes/No {1: "Yes", 2: "No → ETS_END", DK/R → ETS_END}
667. ETS_Q31: "How is smoking restricted in your home?" — Multi select {1 (ETSE_6A): "Smokers are asked to refrain from smoking in the house", 2 (ETSE_6B): "Smoking is allowed in certain rooms only", 3 (ETSE_6C): "Smoking is restricted in the presence of young children", 4 (ETSE_6D): "Other restriction", DK/R}

### Section: ALC - Alcohol Use - 14 items

668. ALC_C1A: Filter — If (do ALC block = 1) go to ALC_R1; otherwise go to ALC_END — Filter
669. ALC_R1: "Now, some questions about your alcohol consumption. When we use the word 'drink' it means: one bottle or can of beer or a glass of draft; one glass of wine or a wine cooler; one drink or cocktail with 1 and a 1/2 ounces of liquor." — Read — press Enter to continue
670. ALC_Q1: "During the past 12 months, have you had a drink of beer, wine, liquor or any other alcoholic beverage?" — Yes/No {1: "Yes", 2: "No → ALC_Q5B", DK/R → ALC_END}
671. ALC_Q2: "During the past 12 months, how often did you drink alcoholic beverages?" — Single select {1: "Less than once a month", 2: "Once a month", 3: "2 to 3 times a month", 4: "Once a week", 5: "2 to 3 times a week", 6: "4 to 6 times a week", 7: "Every day", DK/R}
672. ALC_Q3: "How often in the past 12 months have you had 5 or more drinks on one occasion?" — Single select {1: "Never", 2: "Less than once a month", 3: "Once a month", 4: "2 to 3 times a month", 5: "Once a week", 6: "More than once a week", DK/R}
673. ALC_Q5: "Thinking back over the past week, did you have a drink of beer, wine, liquor or any other alcoholic beverage?" — Yes/No {1: "Yes", 2: "No → ALC_C8", DK/R → ALC_C8}
674. ALC_Q5A: "Starting with yesterday, how many drinks did you have: Sunday? Monday? Tuesday? Wednesday? Thursday? Friday? Saturday?" — Numeric per day (min: 0, max: 99; warning after 12 per day) {DK/R; If R on first day → ALC_C8; Go to ALC_C8}
675. ALC_E5A: Constraint — Trigger hard edit if ALC_Q3 = 1 and ALC_Q5A >= 5 — Postcondition
676. ALC_Q5B: "Have you ever had a drink?" — Yes/No {1: "Yes", 2: "No → ALC_END", DK/R → ALC_END}
677. ALC_Q6: "Did you ever regularly drink more than 12 drinks a week?" — Yes/No {1: "Yes", 2: "No → ALC_C8", DK/R → ALC_C8}
678. ALC_Q7: "Why did you reduce or quit drinking altogether?" — Multi select {1 (ALCE_7A): "Dieting", 2 (ALCE_7B): "Athletic training", 3 (ALCE_7C): "Pregnancy", 4 (ALCE_7D): "Getting older", 5 (ALCE_7E): "Drinking too much / drinking problem", 6 (ALCE_7F): "Affected - work, studies, employment opportunities", 7 (ALCE_7G): "Interfered with family or home life", 8 (ALCE_7H): "Affected - physical health", 9 (ALCE_7I): "Affected - friendships or social relationships", 10 (ALCE_7J): "Affected - financial position", 11 (ALCE_7K): "Affected - outlook on life, happiness", 12 (ALCE_7L): "Influence of family or friends", 13 (ALCE_7N): "Life change", 14 (ALCE_7M): "Other - Specify", DK/R}
679. ALC_C7S: Filter — If ALC_Q7 = 14 go to ALC_Q7S; otherwise go to ALC_C8 — Filter
680. ALC_Q7S: "INTERVIEWER: Specify." — Text (80 spaces) {DK/R}
681. ALC_C8: Filter — If age > 19 go to ALC_END — Filter
682. ALC_Q8: "Not counting small sips, how old were you when you started drinking alcoholic beverages?" — Numeric (min: 5, max: current age) {DK/R}
683. ALC_E8: Constraint — Trigger hard edit if ALC_Q8 < 5 or ALC_Q8 > current age — Postcondition

### Section: MEX - Medication Exposure - 32 items

684. MEX_C01A: Filter — If do MEX block = 1, continue to MEX_C01B; otherwise go to MEX_END — Filter
685. MEX_C01B: Filter — If proxy interview or sex = male or age < 15 or > 55, go to MEX_END; otherwise go to MEX_Q01 — Filter
686. MEX_Q01: "Have you given birth in the past 5 years?" — Yes/No {1: "Yes", 2: "No → MEX_END", DK/R → MEX_END}
687. MEX_Q01A: "In what year? [Year of birth of last baby]" — Numeric (MIN: 2000, MAX: current year) — no explicit routing; DK/R accepted
688. MEX_Q02: "Did you take a vitamin supplement containing folic acid before your (last) pregnancy, that is, before you found out that you were pregnant?" — Yes/No {1: "Yes", 2: "No", DK/R}
689. MEX_Q03: "For your last baby, did you breastfeed or try to breastfeed your baby, even if only for a short time?" — Yes/No {1: "Yes → MEX_Q05", 2: "No", DK/R → MEX_C20}
690. MEX_Q04: "What is the main reason that you did not breastfeed?" — Single select {1: "Bottle feeding easier", 2: "Formula as good as breast milk", 3: "Breastfeeding is unappealing/disgusting", 4: "Father/partner didn't want me to", 5: "Returned to work/school early", 6: "C-Section", 7: "Medical condition - mother", 8: "Medical condition - baby", 9: "Premature birth", 10: "Multiple births", 11: "Wanted to drink alcohol", 12: "Wanted to smoke", 13: "Other - Specify", DK/R} — routing to MEX_C04S
691. MEX_C04S: Filter — If MEX_Q04 = 13, go to MEX_Q04S; otherwise go to MEX_C20 — Filter
692. MEX_Q04S: "INTERVIEWER: Specify." — Text (80 chars) — Go to MEX_C20; DK/R
693. MEX_Q05: "Are you still breastfeeding?" — Yes/No {1: "Yes → MEX_Q07", 2: "No", DK/R → MEX_C20}
694. MEX_Q06: "How long did you breastfeed (your last baby)?" — Single select {1: "Less than 1 week", 2: "1 to 2 weeks", 3: "3 to 4 weeks", 4: "5 to 8 weeks", 5: "9 weeks to less than 12 weeks", 6: "3 months", 7: "4 months", 8: "5 months", 9: "6 months", 10: "7 to 9 months", 11: "10 to 12 months", 12: "More than 1 year", DK/R → MEX_C20}
695. MEX_Q07: "How old was your (last) baby when you first added any other liquids or solid foods to the baby's feeds?" — Single select {1: "Less than 1 week", 2: "1 to 2 weeks", 3: "3 to 4 weeks", 4: "5 to 8 weeks", 5: "9 weeks to less than 12 weeks", 6: "3 months", 7: "4 months", 8: "5 months", 9: "6 months", 10: "7 to 9 months", 11: "10 to 12 months", 12: "More than 1 year", 13: "Have not added liquids or solids → MEX_Q09", DK/R → MEX_C20}
696. MEX_Q08: "What is the main reason that you first added other liquids or solid foods?" — Single select {1: "Not enough breast milk", 2: "Baby was ready for solid foods", 3: "Inconvenience/fatigue", 4: "Difficulty with BF techniques", 5: "Medical condition - mother", 6: "Medical condition - baby", 7: "Advice of doctor/health professional", 8: "Returned to work/school", 9: "Advice of partner/family/friends", 10: "Formula equally healthy", 11: "Wanted to drink alcohol", 12: "Wanted to smoke", 13: "Other - Specify", DK/R} — routing to MEX_C08S
697. MEX_C08S: Filter — If MEX_Q08 = 13, go to MEX_Q08S; otherwise go to MEX_C09 — Filter
698. MEX_Q08S: "INTERVIEWER: Specify." — Text (80 chars) — DK/R
699. MEX_C09: Filter — If MEX_Q07 = 1 (baby less than 1 week), go to MEX_C10; otherwise go to MEX_Q09 — Filter
700. MEX_Q09: "During the time when your (last) baby was only fed breast milk, did you give the baby a vitamin supplement containing Vitamin D?" — Yes/No {1: "Yes", 2: "No", DK/R}
701. MEX_C10: Filter — If MEX_Q05 = 1 (still breastfeeding), go to MEX_C20; otherwise go to MEX_Q10 — Filter
702. MEX_Q10: "What is the main reason that you stopped breastfeeding?" — Single select {1: "Not enough breast milk", 2: "Baby was ready for solid foods", 3: "Inconvenience/fatigue", 4: "Difficulty with BF techniques", 5: "Medical condition - mother", 6: "Medical condition - baby", 7: "Planned to stop at this time", 8: "Child weaned him/herself", 9: "Advice of doctor/health professional", 10: "Returned to work/school", 11: "Advice of partner", 12: "Formula equally healthy", 13: "Wanted to drink alcohol", 14: "Wanted to smoke", 15: "Other - Specify", DK/R} — routing to MEX_C10S
703. MEX_C10S: Filter — If MEX_Q10 = 15, go to MEX_Q10S; otherwise go to MEX_C20 — Filter
704. MEX_Q10S: "INTERVIEWER: Specify." — Text (80 chars) — DK/R; go to MEX_C20
705. MEX_C20: Filter — If SMK_Q202 = 1 or 2 or SMK_Q201A = 1 or SMK_Q201B = 1 (current or former smoker), go to MEX_Q20; otherwise go to MEX_Q26 — Filter
706. MEX_Q20: "During your last pregnancy, did you smoke daily, occasionally or not at all?" — Single select {1: "Daily", 2: "Occasionally → MEX_Q22", 3: "Not at all → MEX_C23", DK/R → MEX_Q26}
707. MEX_Q21: "How many cigarettes did you usually smoke each day?" — Numeric (MIN: 1, MAX: 99; warning after 60) — Go to MEX_C23; DK/R
708. MEX_Q22: "On the days that you smoked, how many cigarettes did you usually smoke?" — Numeric (MIN: 1, MAX: 99; warning after 60) — DK/R
709. MEX_C23: Filter — If MEX_Q03 = 1 (breastfed last baby), go to MEX_Q23; otherwise go to MEX_Q26 — Filter
710. MEX_Q23: "When you were breastfeeding (your last baby), did you smoke daily, occasionally or not at all?" — Single select {1: "Daily", 2: "Occasionally → MEX_Q25", 3: "Not at all → MEX_Q26", DK/R → MEX_Q26}
711. MEX_Q24: "How many cigarettes did you usually smoke each day?" — Numeric (MIN: 1, MAX: 99; warning after 60) — Go to MEX_Q26; DK/R
712. MEX_Q25: "On the days that you smoked, how many cigarettes did you usually smoke?" — Numeric (MIN: 1, MAX: 99; warning after 60) — DK/R
713. MEX_Q26: "Did anyone regularly smoke in your presence during or after the pregnancy (about 6 months after)?" — Yes/No {1: "Yes", 2: "No", DK/R}
714. MEX_C30: Filter — If ALC_Q1 = 1 or ALC_Q5B = 1 (drank in past 12 months or ever drank), go to MEX_Q30; otherwise go to MEX_END — Filter
715. MEX_Q30: "Did you drink any alcohol during your last pregnancy?" — Yes/No {1: "Yes", 2: "No → MEX_C32", DK/R → MEX_END}
716. MEX_Q31: "How often did you drink?" — Single select {1: "Less than once a month", 2: "Once a month", 3: "2 to 3 times a month", 4: "Once a week", 5: "2 to 3 times a week", 6: "4 to 6 times a week", 7: "Every day", DK/R}
717. MEX_C32: Filter — If MEX_Q03 = 2 (did not breastfeed last baby), go to MEX_END; otherwise go to MEX_Q32 — Filter
718. MEX_Q32: "Did you drink any alcohol while you were breastfeeding (your last baby)?" — Yes/No {1: "Yes", 2: "No → MEX_END", DK/R → MEX_END}
719. MEX_Q33: "How often did you drink?" — Single select {1: "Less than once a month", 2: "Once a month", 3: "2 to 3 times a month", 4: "Once a week", 5: "2 to 3 times a week", 6: "4 to 6 times a week", 7: "Every day", DK/R}

---

### Section: DRG - Drug Use (Illicit Drugs / IDG) - 39 items

720. DRG_C1: Filter — If do DRG block = 1, go to DRG_C2; otherwise go to DRG_END — Filter
721. DRG_C2: Filter — If proxy interview, go to DRG_END; otherwise go to DRG_R1 — Filter
722. DRG_R1: "I am going to ask some questions about drug use. Again, I would like to remind you that everything you say will remain strictly confidential." — Read (press Enter to continue)
723. DRG_Q01: "Have you ever used or tried marijuana, cannabis or hashish?" — Single select {1: "Yes, just once", 2: "Yes, more than once", 3: "No → DRG_Q04", DK/R → DRG_END}
724. DRG_Q02: "Have you used it in the past 12 months?" — Yes/No {1: "Yes", 2: "No → DRG_Q04", DK/R → DRG_Q04}
725. DRG_C03: Filter — If DRG_Q01 = 1, go to DRG_Q04 — Filter
726. DRG_Q03: "How often did you use marijuana, cannabis or hashish in the past 12 months?" — Single select {1: "Less than once a month", 2: "1 to 3 times a month", 3: "Once a week", 4: "More than once a week", 5: "Every day", DK/R}
727. DRG_Q04: "Have you ever used or tried cocaine or crack?" — Single select {1: "Yes, just once", 2: "Yes, more than once", 3: "No → DRG_Q07", DK/R → DRG_Q07}
728. DRG_Q05: "Have you used it in the past 12 months?" — Yes/No {1: "Yes", 2: "No → DRG_Q07", DK/R → DRG_Q07}
729. DRG_C06: Filter — If DRG_Q04 = 1, go to DRG_Q07 — Filter
730. DRG_Q06: "How often did you use cocaine or crack in the past 12 months?" — Single select {1: "Less than once a month", 2: "1 to 3 times a month", 3: "Once a week", 4: "More than once a week", 5: "Every day", DK/R}
731. DRG_Q07: "Have you ever used or tried speed (amphetamines)?" — Single select {1: "Yes, just once", 2: "Yes, more than once", 3: "No → DRG_Q10", DK/R → DRG_Q10}
732. DRG_Q08: "Have you used it in the past 12 months?" — Yes/No {1: "Yes", 2: "No → DRG_Q10", DK/R → DRG_Q10}
733. DRG_C09: Filter — If DRG_Q07 = 1, go to DRG_Q10 — Filter
734. DRG_Q09: "How often did you use speed (amphetamines) in the past 12 months?" — Single select {1: "Less than once a month", 2: "1 to 3 times a month", 3: "Once a week", 4: "More than once a week", 5: "Every day", DK/R}
735. DRG_Q10: "Have you ever used or tried ecstasy (MDMA) or other similar drugs?" — Single select {1: "Yes, just once", 2: "Yes, more than once", 3: "No → DRG_Q13", DK/R → DRG_Q13}
736. DRG_Q11: "Have you used it in the past 12 months?" — Yes/No {1: "Yes", 2: "No → DRG_Q13", DK/R → DRG_Q13}
737. DRG_C12: Filter — If DRG_Q10 = 1, go to DRG_Q13 — Filter
738. DRG_Q12: "How often did you use ecstasy or other similar drugs in the past 12 months?" — Single select {1: "Less than once a month", 2: "1 to 3 times a month", 3: "Once a week", 4: "More than once a week", 5: "Every day", DK/R}
739. DRG_Q13: "Have you ever used or tried hallucinogens, PCP or LSD (acid)?" — Single select {1: "Yes, just once", 2: "Yes, more than once", 3: "No → DRG_Q16", DK/R → DRG_Q16}
740. DRG_Q14: "Have you used it in the past 12 months?" — Yes/No {1: "Yes", 2: "No → DRG_Q16", DK/R → DRG_Q16}
741. DRG_C15: Filter — If DRG_Q13 = 1, go to DRG_Q16 — Filter
742. DRG_Q15: "How often did you use hallucinogens, PCP or LSD in the past 12 months?" — Single select {1: "Less than once a month", 2: "1 to 3 times a month", 3: "Once a week", 4: "More than once a week", 5: "Every day", DK/R}
743. DRG_Q16: "Did you ever sniff glue, gasoline or other solvents?" — Single select {1: "Yes, just once", 2: "Yes, more than once", 3: "No → DRG_Q19", DK/R → DRG_Q19}
744. DRG_Q17: "Did you sniff some in the past 12 months?" — Yes/No {1: "Yes", 2: "No → DRG_Q19", DK/R → DRG_Q19}
745. DRG_C18: Filter — If DRG_Q16 = 1, go to DRG_Q19 — Filter
746. DRG_Q18: "How often did you sniff glue, gasoline or other solvents in the past 12 months?" — Single select {1: "Less than once a month", 2: "1 to 3 times a month", 3: "Once a week", 4: "More than once a week", 5: "Every day", DK/R}
747. DRG_Q19: "Have you ever used or tried heroin?" — Single select {1: "Yes, just once", 2: "Yes, more than once", 3: "No → DRG_Q22", DK/R → DRG_Q22}
748. DRG_Q20: "Have you used it in the past 12 months?" — Yes/No {1: "Yes", 2: "No → DRG_Q22", DK/R → DRG_Q22}
749. DRG_C21: Filter — If DRG_Q19 = 1, go to DRG_Q22 — Filter
750. DRG_Q21: "How often did you use heroin in the past 12 months?" — Single select {1: "Less than once a month", 2: "1 to 3 times a month", 3: "Once a week", 4: "More than once a week", 5: "Every day", DK/R}
751. DRG_Q22: "Have you ever used or tried steroids, such as testosterone, dianabol or growth hormones, to increase your performance in a sport or activity or to change your physical appearance?" — Single select {1: "Yes, just once", 2: "Yes, more than once", 3: "No → DRG_C25A1", DK/R → DRG_C25A1}
752. DRG_Q23: "Have you used it in the past 12 months?" — Yes/No {1: "Yes", 2: "No → DRG_C25A1", DK/R → DRG_C25A1}
753. DRG_C24: Filter — If DRG_Q22 = 1, go to DRG_C25A1 — Filter
754. DRG_Q24: "How often did you use steroids in the past 12 months?" — Single select {1: "Less than once a month", 2: "1 to 3 times a month", 3: "Once a week", 4: "More than once a week", 5: "Every day", DK/R}
755. DRG_C25A_1: Filter — Count instances where DRG_Q01, DRG_Q04, DRG_Q07, DRG_Q10, DRG_Q13, DRG_Q16, DRG_Q19 = 3, DK or R; if count = 7 go to DRG_END — Filter
756. DRG_C25A_2: Filter — Count instances where DRG_Q03, DRG_Q06, DRG_Q09, DRG_Q12, DRG_Q15, DRG_Q18, DRG_Q21 >= 2; if count >= 1 go to DRG_Q25A; otherwise go to DRG_END — Filter
757. DRG_Q25A: "During the past 12 months, did you ever need to use more drugs than usual in order to get high, or did you ever find that you could no longer get high on the amount you usually took?" — Yes/No {1: "Yes", 2: "No", DK/R}
758. DRG_R25B: "People who cut down their substance use or stop using drugs altogether may not feel well if they have been using steadily for some time..." — Read (press Enter to continue)
759. DRG_Q25B: "During the past 12 months, did you ever have times when you stopped, cut down or went without drugs and then experienced symptoms like fatigue, headaches, diarrhoea, the shakes or emotional problems?" — Yes/No {1: "Yes", 2: "No", DK/R}
760. DRG_Q25C: "During the past 12 months, did you ever have times when you used drugs to keep from having such symptoms?" — Yes/No {1: "Yes", 2: "No", DK/R}
761. DRG_Q25D: "During the past 12 months, did you ever have times when you used drugs even though you promised yourself you wouldn't, or times when you used a lot more drugs than you intended?" — Yes/No {1: "Yes", 2: "No", DK/R}
762. DRG_Q25E: "During the past 12 months, were there ever times when you used drugs more frequently, or for more days in a row than you intended?" — Yes/No {1: "Yes", 2: "No", DK/R}
763. DRG_Q25F: "During the past 12 months, did you ever have periods of several days or more when you spent so much time using drugs or recovering from the effects of using drugs that you had little time for anything else?" — Yes/No {1: "Yes", 2: "No", DK/R}
764. DRG_Q25G: "During the past 12 months, did you ever have periods of a month or longer when you gave up or greatly reduced important activities because of your use of drugs?" — Yes/No {1: "Yes", 2: "No", DK/R}
765. DRG_Q25H: "During the past 12 months, did you ever continue to use drugs when you knew you had a serious physical or emotional problem that might have been caused by or made worse by your use?" — Yes/No {1: "Yes", 2: "No", DK/R}
766. DRG_R26: "Please tell me what number best describes how much your use of drugs interfered with each of the following activities during the past 12 months. 0 = no interference, 10 = very severe interference." — Read (press Enter to continue)
767. DRG_Q26A: "How much did your use of drugs interfere with your home responsibilities, like cleaning, shopping and taking care of the house or apartment?" — Scale (MIN: 0, MAX: 10) — DK/R
768. DRG_Q26B_1: "How much did your use interfere with your ability to attend school?" — Scale (MIN: 0, MAX: 11; 11 = Not applicable) — DK/R
769. DRG_Q26B_2: "How much did your use interfere with your ability to work at a regular job?" — Scale (MIN: 0, MAX: 11; 11 = Not applicable) — DK/R
770. DRG_Q26C: "During the past 12 months, how much did your use of drugs interfere with your ability to form and maintain close relationships with other people?" — Scale (MIN: 0, MAX: 10) — DK/R
771. DRG_Q26D: "How much did your use of drugs interfere with your social life?" — Scale (MIN: 0, MAX: 10) — DK/R

---

### Section: CPG - Canadian Problem Gambling Index - 36 items

772. CPG_C1: Filter — If do CPG block = 1, go to CPG_C2; otherwise go to CPG_END — Filter
773. CPG_C2: Filter — If proxy interview, go to CPG_END; otherwise go to CPG_C3 — Filter
774. CPG_C3: Computed — Count instances where CPG_Q01B to CPG_Q01M = 7, 8, DK or R — Filter
775. CPG_R01: "People have different definitions of gambling... The next questions are about gambling activities and experiences." — Read (press Enter to continue)
776. CPG_Q01A: "In the past 12 months, how often have you bet or spent money on instant win/scratch tickets or daily lottery tickets (Keno, Pick 3, Encore, Banco, Extra)?" — Single select {1: "Daily", 2: "Between 2 to 6 times a week", 3: "About once a week", 4: "Between 2 to 3 times a month", 5: "About once a month", 6: "Between 6 to 11 times a year", 7: "Between 1 to 5 times a year", 8: "Never", DK/R}
777. CPG_C01A: Filter — If CPG_Q01A = R, go to CPG_END; otherwise go to CPG_Q01B — Filter
778. CPG_Q01B: "In the past 12 months, how often have you bet or spent money on lottery tickets such as 6/49 and Super 7, raffles or fund-raising tickets?" — Single select {1: "Daily", 2: "Between 2 to 6 times a week", 3: "About once a week", 4: "Between 2 to 3 times a month", 5: "About once a month", 6: "Between 6 to 11 times a year", 7: "Between 1 to 5 times a year", 8: "Never", DK/R}
779. CPG_Q01C: "In the past 12 months, how often have you bet or spent money on Bingo?" — Single select {1: "Daily", 2: "Between 2 to 6 times a week", 3: "About once a week", 4: "Between 2 to 3 times a month", 5: "About once a month", 6: "Between 6 to 11 times a year", 7: "Between 1 to 5 times a year", 8: "Never", DK/R}
780. CPG_Q01D: "In the past 12 months, how often have you bet or spent money playing cards or board games with family or friends?" — Single select {1: "Daily", 2: "Between 2 to 6 times a week", 3: "About once a week", 4: "Between 2 to 3 times a month", 5: "About once a month", 6: "Between 6 to 11 times a year", 7: "Between 1 to 5 times a year", 8: "Never", DK/R}
781. CPG_Q01E: "In the past 12 months, how often have you bet or spent money on video lottery terminals (VLTs) outside of casinos?" — Single select {1: "Daily", 2: "Between 2 to 6 times a week", 3: "About once a week", 4: "Between 2 to 3 times a month", 5: "About once a month", 6: "Between 6 to 11 times a year", 7: "Between 1 to 5 times a year", 8: "Never", DK/R}
782. CPG_Q01F: "In the past 12 months, how often have you bet or spent money on coin slots or VLTs at a casino?" — Single select {1: "Daily", 2: "Between 2 to 6 times a week", 3: "About once a week", 4: "Between 2 to 3 times a month", 5: "About once a month", 6: "Between 6 to 11 times a year", 7: "Between 1 to 5 times a year", 8: "Never", DK/R}
783. CPG_Q01G: "In the past 12 months, how often have you bet or spent money on casino games other than coin slots or VLTs (for example, poker, roulette, blackjack, Keno)?" — Single select {1: "Daily", 2: "Between 2 to 6 times a week", 3: "About once a week", 4: "Between 2 to 3 times a month", 5: "About once a month", 6: "Between 6 to 11 times a year", 7: "Between 1 to 5 times a year", 8: "Never", DK/R}
784. CPG_Q01H: "In the past 12 months, how often have you bet or spent money on Internet or arcade gambling?" — Single select {1: "Daily", 2: "Between 2 to 6 times a week", 3: "About once a week", 4: "Between 2 to 3 times a month", 5: "About once a month", 6: "Between 6 to 11 times a year", 7: "Between 1 to 5 times a year", 8: "Never", DK/R}
785. CPG_Q01I: "In the past 12 months, how often have you bet or spent money on live horse racing at the track or off track?" — Single select {1: "Daily", 2: "Between 2 to 6 times a week", 3: "About once a week", 4: "Between 2 to 3 times a month", 5: "About once a month", 6: "Between 6 to 11 times a year", 7: "Between 1 to 5 times a year", 8: "Never", DK/R}
786. CPG_Q01J: "In the past 12 months, how often have you bet or spent money on sports such as sports lotteries (Sport Select, Pro-Line, Mise-au-jeu, Total), sports pool or sporting events?" — Single select {1: "Daily", 2: "Between 2 to 6 times a week", 3: "About once a week", 4: "Between 2 to 3 times a month", 5: "About once a month", 6: "Between 6 to 11 times a year", 7: "Between 1 to 5 times a year", 8: "Never", DK/R}
787. CPG_Q01K: "In the past 12 months, how often have you bet or spent money on speculative investments such as stocks, options or commodities?" — Single select {1: "Daily", 2: "Between 2 to 6 times a week", 3: "About once a week", 4: "Between 2 to 3 times a month", 5: "About once a month", 6: "Between 6 to 11 times a year", 7: "Between 1 to 5 times a year", 8: "Never", DK/R}
788. CPG_Q01L: "In the past 12 months, how often have you bet or spent money on games of skill such as pool, golf, bowling or darts?" — Single select {1: "Daily", 2: "Between 2 to 6 times a week", 3: "About once a week", 4: "Between 2 to 3 times a month", 5: "About once a month", 6: "Between 6 to 11 times a year", 7: "Between 1 to 5 times a year", 8: "Never", DK/R}
789. CPG_Q01M: "In the past 12 months, how often have you bet or spent money on any other forms of gambling such as dog races, gambling at casino nights/country fairs, bet on sports with a bookie or gambling pools at work?" — Single select {1: "Daily", 2: "Between 2 to 6 times a week", 3: "About once a week", 4: "Between 2 to 3 times a month", 5: "About once a month", 6: "Between 6 to 11 times a year", 7: "Between 1 to 5 times a year", 8: "Never", DK/R}
790. CPG_C01N: Filter — If CPG_C03 = 12 and CPG_Q01A = 7, 8 or DK, go to CPG_END; otherwise go to CPG_Q01N — Filter
791. CPG_Q01N: "In the past 12 months, how much money, not including winnings, did you spend on all of your gambling activities?" — Single select {1: "Between $1 and $50", 2: "Between $51 and $100", 3: "Between $101 and $250", 4: "Between $251 and $500", 5: "Between $501 and $1000", 6: "More than $1000", DK/R}
792. CPG_QINT2: "The next questions are about gambling attitudes and experiences. All the questions will refer to the past 12 months." — Read (press Enter to continue)
793. CPG_Q02: "In the past 12 months, how often have you bet or spent more money than you wanted to on gambling?" — Single select {1: "Never", 2: "Sometimes", 3: "Most of the time", 4: "Almost always", 5: "I am not a gambler → CPG_END", DK, R → CPG_END}
794. CPG_Q03: "In the past 12 months, how often have you needed to gamble with larger amounts of money to get the same feeling of excitement?" — Single select {1: "Never", 2: "Sometimes", 3: "Most of the time", 4: "Almost always", DK/R}
795. CPG_Q04: "In the past 12 months, when you gambled, how often did you go back another day to try to win back the money you lost?" — Single select {1: "Never", 2: "Sometimes", 3: "Most of the time", 4: "Almost always", DK/R}
796. CPG_Q05: "In the past 12 months, how often have you borrowed money or sold anything to get money to gamble?" — Single select {1: "Never", 2: "Sometimes", 3: "Most of the time", 4: "Almost always", DK/R}
797. CPG_Q06: "In the past 12 months, how often have you felt that you might have a problem with gambling?" — Single select {1: "Never", 2: "Sometimes", 3: "Most of the time", 4: "Almost always", DK/R}
798. CPG_Q07: "In the past 12 months, how often has gambling caused you any health problems, including stress or anxiety?" — Single select {1: "Never", 2: "Sometimes", 3: "Most of the time", 4: "Almost always", DK/R}
799. CPG_Q08: "In the past 12 months, how often have people criticized your betting or told you that you had a gambling problem, regardless of whether or not you thought it was true?" — Single select {1: "Never", 2: "Sometimes", 3: "Most of the time", 4: "Almost always", DK/R}
800. CPG_Q09: "In the past 12 months, how often has your gambling caused financial problems for you or your family?" — Single select {1: "Never", 2: "Sometimes", 3: "Most of the time", 4: "Almost always", DK/R}
801. CPG_Q10: "In the past 12 months, how often have you felt guilty about the way you gamble or what happens when you gamble?" — Single select {1: "Never", 2: "Sometimes", 3: "Most of the time", 4: "Almost always", DK/R}
802. CPG_Q11: "In the past 12 months, how often have you lied to family members or others to hide your gambling?" — Single select {1: "Never", 2: "Sometimes", 3: "Most of the time", 4: "Almost always", DK/R}
803. CPG_Q12: "In the past 12 months, how often have you wanted to stop betting money or gambling, but didn't think you could?" — Single select {1: "Never", 2: "Sometimes", 3: "Most of the time", 4: "Almost always", DK/R}
804. CPG_Q13: "In the past 12 months, how often have you bet more than you could really afford to lose?" — Single select {1: "Never", 2: "Sometimes", 3: "Most of the time", 4: "Almost always", DK/R}
805. CPG_Q14: "In the past 12 months, have you tried to quit or cut down on your gambling but were unable to do it?" — Single select {1: "Never", 2: "Sometimes", 3: "Most of the time", 4: "Almost always", DK/R}
806. CPG_Q15: "In the past 12 months, have you gambled as a way of forgetting problems or to feel better when you were depressed?" — Single select {1: "Never", 2: "Sometimes", 3: "Most of the time", 4: "Almost always", DK/R}
807. CPG_Q16: "In the past 12 months, has your gambling caused any problems with your relationship with any of your family members or friends?" — Single select {1: "Never", 2: "Sometimes", 3: "Most of the time", 4: "Almost always", DK/R}
808. CPG_C17: Filter/Computed — Recode CPG_Q03 through CPG_Q10 and CPG_Q13 (1=0, 2=1, 3=2, 4=3); sum recoded values; if sum <= 2, go to CPG_END; otherwise go to CPG_Q17 — Filter
809. CPG_Q17: "Has anyone in your family ever had a gambling problem?" — Yes/No {1: "Yes", 2: "No", DK/R}
810. CPG_Q18: "In the past 12 months, have you used alcohol or drugs while gambling?" — Yes/No {1: "Yes", 2: "No", DK/R}
811. CPG_QINT19: "Please tell me what number best describes how much your gambling activities interfered with each of the following activities during the past 12 months. 0 = no interference, 10 = very severe interference." — Read (press Enter to continue)
812. CPG_Q19A: "During the past 12 months, how much did your gambling activities interfere with your home responsibilities, like cleaning, shopping and taking care of the house or apartment?" — Scale (MIN: 0, MAX: 10) — DK/R
813. CPG_Q19B_1: "How much did these activities interfere with your ability to attend school?" — Scale (MIN: 0, MAX: 11; 11 = Not applicable) — DK/R
814. CPG_Q19B_2: "How much did they interfere with your ability to work at a job?" — Scale (MIN: 0, MAX: 11; 11 = Not applicable) — DK/R
815. CPG_Q19C: "During the past 12 months, how much did your gambling activities interfere with your ability to form and maintain close relationships with other people?" — Scale (MIN: 0, MAX: 10) — DK/R
816. CPG_Q19D: "How much did they interfere with your social life?" — Scale (MIN: 0, MAX: 10) — DK/R

---

### Section: SWL - Satisfaction with Life - 12 items

817. SWL_C1: Filter — If do SWL block = 1, go to SWL_C2; otherwise go to SWL_END — Filter
818. SWL_C2: Filter — If proxy interview, go to SWL_END; otherwise go to SWL_QINT — Filter
819. SWL_QINT: "Now I'd like to ask about your satisfaction with various aspects of your life. Please tell me whether you are very satisfied, satisfied, neither satisfied nor dissatisfied, dissatisfied, or very dissatisfied." — Read (press Enter to continue)
820. SWL_Q02: "How satisfied are you with your job or main activity?" — Single select {1: "Very satisfied", 2: "Satisfied", 3: "Neither satisfied nor dissatisfied", 4: "Dissatisfied", 5: "Very dissatisfied", DK, R → SWL_END}
821. SWL_Q03: "How satisfied are you with your leisure activities?" — Single select {1: "Very satisfied", 2: "Satisfied", 3: "Neither satisfied nor dissatisfied", 4: "Dissatisfied", 5: "Very dissatisfied", DK/R}
822. SWL_Q04: "How satisfied are you with your financial situation?" — Single select {1: "Very satisfied", 2: "Satisfied", 3: "Neither satisfied nor dissatisfied", 4: "Dissatisfied", 5: "Very dissatisfied", DK/R}
823. SWL_Q05: "How satisfied are you with yourself?" — Single select {1: "Very satisfied", 2: "Satisfied", 3: "Neither satisfied nor dissatisfied", 4: "Dissatisfied", 5: "Very dissatisfied", DK/R}
824. SWL_Q06: "How satisfied are you with the way your body looks?" — Single select {1: "Very satisfied", 2: "Satisfied", 3: "Neither satisfied nor dissatisfied", 4: "Dissatisfied", 5: "Very dissatisfied", DK/R}
825. SWL_Q07: "How satisfied are you with your relationships with other family members?" — Single select {1: "Very satisfied", 2: "Satisfied", 3: "Neither satisfied nor dissatisfied", 4: "Dissatisfied", 5: "Very dissatisfied", DK/R}
826. SWL_Q08: "How satisfied are you with your relationships with friends?" — Single select {1: "Very satisfied", 2: "Satisfied", 3: "Neither satisfied nor dissatisfied", 4: "Dissatisfied", 5: "Very dissatisfied", DK/R}
827. SWL_Q09: "How satisfied are you with your housing?" — Single select {1: "Very satisfied", 2: "Satisfied", 3: "Neither satisfied nor dissatisfied", 4: "Dissatisfied", 5: "Very dissatisfied", DK/R}
828. SWL_Q10: "How satisfied are you with your neighbourhood?" — Single select {1: "Very satisfied", 2: "Satisfied", 3: "Neither satisfied nor dissatisfied", 4: "Dissatisfied", 5: "Very dissatisfied", DK/R}

---

### Section: STS - Stress Sources - 9 items

829. STS_C1: Filter — If do STS block = 1, go to STS_C2; otherwise go to STS_END — Filter
830. STS_C2: Filter — If proxy interview, go to STS_END; otherwise go to STS_R1 — Filter
831. STS_R1: "Now a few questions about the stress in your life." — Read (press Enter to continue)
832. STS_Q1: "In general, how would you rate your ability to handle unexpected and difficult problems, for example, a family or personal crisis? Would you say your ability is:" — Single select {1: "Excellent", 2: "Very good", 3: "Good", 4: "Fair", 5: "Poor", DK/R → STS_END}
833. STS_Q2: "In general, how would you rate your ability to handle the day-to-day demands in your life, for example, handling work, family and volunteer responsibilities? Would you say your ability is:" — Single select {1: "Excellent", 2: "Very good", 3: "Good", 4: "Fair", 5: "Poor", DK/R}
834. STS_Q3: "Thinking about stress in your day-to-day life, what would you say is the most important thing contributing to feelings of stress you may have?" — Single select {1: "Time pressures/not enough time", 2: "Own physical health problem or condition", 3: "Own emotional or mental health problem or condition", 4: "Financial situation", 5: "Own work situation", 6: "School", 7: "Employment status", 8: "Caring for - own children", 9: "Caring for - others", 10: "Other personal or family responsibilities", 11: "Personal relationships", 12: "Discrimination", 13: "Personal and family's safety", 14: "Health of family members", 15: "Other - Specify", 16: "Nothing → STS_END", DK/R → STS_END}
835. STS_C3S: Filter — If STS_Q3 = 16, go to STS_Q3S; otherwise go to STS_END — Filter
836. STS_Q3S: "INTERVIEWER: Specify." — Text (80 chars) — DK/R

---

### Section: STC - Stress - Coping (Childhood/Coping) - 16 items

837. STC_C1: Filter — If do STC block = 1, go to STC_C2; otherwise go to STR_END — Filter
838. STC_C2: Filter — If proxy interview, go to STC_END; otherwise go to STC_R1 — Filter
839. STC_R1: "Now a few questions about coping with stress." — Read (press Enter to continue)
840. STC_Q1_1: "How often do you try to solve the problem?" — Single select {1: "Often", 2: "Sometimes", 3: "Rarely", 4: "Never", DK/R → STC_END}
841. STC_Q1_2: "To deal with stress, how often do you talk to others?" — Single select {1: "Often", 2: "Sometimes", 3: "Rarely", 4: "Never", DK/R}
842. STC_Q1_3: "When dealing with stress, how often do you avoid being with people?" — Single select {1: "Often", 2: "Sometimes", 3: "Rarely", 4: "Never", DK/R}
843. STC_Q1_4: "How often do you sleep more than usual to deal with stress?" — Single select {1: "Often", 2: "Sometimes", 3: "Rarely", 4: "Never", DK/R}
844. STC_Q1_5A: "When dealing with stress, how often do you try to feel better by eating more, or less, than usual?" — Single select {1: "Often", 2: "Sometimes", 3: "Rarely", 4: "Never", DK/R}
845. STC_Q1_5B: "When dealing with stress, how often do you try to feel better by smoking more cigarettes than usual?" — Single select {1: "Often", 2: "Sometimes", 3: "Rarely", 4: "Never", 5: "Do not smoke", DK/R}
846. STC_Q1_5C: "When dealing with stress, how often do you try to feel better by drinking alcohol?" — Single select {1: "Often", 2: "Sometimes", 3: "Rarely", 4: "Never", DK/R}
847. STC_Q1_5D: "When dealing with stress, how often do you try to feel better by using drugs or medication?" — Single select {1: "Often", 2: "Sometimes", 3: "Rarely", 4: "Never", DK/R}
848. STC_Q1_6: "How often do you jog or do other exercise to deal with stress?" — Single select {1: "Often", 2: "Sometimes", 3: "Rarely", 4: "Never", DK/R}
849. STC_Q1_7: "How often do you pray or seek spiritual help to deal with stress?" — Single select {1: "Often", 2: "Sometimes", 3: "Rarely", 4: "Never", DK/R}
850. STC_Q1_8: "To deal with stress, how often do you try to relax by doing something enjoyable?" — Single select {1: "Often", 2: "Sometimes", 3: "Rarely", 4: "Never", DK/R}
851. STC_Q1_9: "To deal with stress, how often do you try to look on the bright side of things?" — Single select {1: "Often", 2: "Sometimes", 3: "Rarely", 4: "Never", DK/R}
852. STC_Q1_10: "How often do you blame yourself?" — Single select {1: "Often", 2: "Sometimes", 3: "Rarely", 4: "Never", DK/R}
853. STC_Q1_11: "To deal with stress, how often do you wish the situation would go away or somehow be finished?" — Single select {1: "Often", 2: "Sometimes", 3: "Rarely", 4: "Never", DK/R}

---

### Section: CST - Childhood and Adult Stressors - 11 items

854. CST_C1: Filter — If do CST block = 1, go to CST_C2; otherwise go to CST_END — Filter
855. CST_C2: Filter — If proxy interview or age < 18, go to CST_END; otherwise go to CST_R1 — Filter
856. CST_R1: "The next few questions ask about some things that may have happened to you while you were a child or a teenager, before you moved out of the house. Please tell me if any of these things have happened to you." — Read (press Enter to continue)
857. CST_Q1: "Did you spend 2 weeks or more in the hospital?" — Yes/No {1: "Yes", 2: "No", DK, R → CST_END}
858. CST_Q2: "Did your parents get a divorce?" — Yes/No {1: "Yes", 2: "No", DK/R}
859. CST_Q3: "Did your father or mother not have a job for a long time when they wanted to be working?" — Yes/No {1: "Yes", 2: "No", DK/R}
860. CST_Q4: "Did something happen that scared you so much you thought about it for years after?" — Yes/No {1: "Yes", 2: "No", DK/R}
861. CST_Q5: "Were you sent away from home because you did something wrong?" — Yes/No {1: "Yes", 2: "No", DK/R}
862. CST_Q6: "Did either of your parents drink or use drugs so often that it caused problems for the family?" — Yes/No {1: "Yes", 2: "No", DK/R}
863. CST_Q7: "Were you ever physically abused by someone close to you?" — Yes/No {1: "Yes", 2: "No", DK/R}

---

### Section: WST - Work Stress - 17 items

864. WST_C1: Filter — If do WST block = 1, go to WST_C2; otherwise go to WST_END — Filter
865. WST_C2: Filter — If proxy interview, go to WST_END; otherwise go to WST_C3 — Filter
866. WST_C3: Filter — If age < 15 or > 75, or GEN_Q08 = 2, go to WST_END; otherwise go to WST_R4 — Filter
867. WST_R4: "The next few questions are about your main job or business in the past 12 months. I'm going to read you a series of statements that might describe your job situation. Please tell me if you strongly agree, agree, neither agree nor disagree, disagree, or strongly disagree." — Read (press Enter to continue)
868. WST_Q401: "Your job required that you learn new things." — Single select {1: "Strongly agree", 2: "Agree", 3: "Neither agree nor disagree", 4: "Disagree", 5: "Strongly disagree", DK, R → WST_END}
869. WST_Q402: "Your job required a high level of skill." — Single select {1: "Strongly agree", 2: "Agree", 3: "Neither agree nor disagree", 4: "Disagree", 5: "Strongly disagree", DK/R}
870. WST_Q403: "Your job allowed you freedom to decide how you did your job." — Single select {1: "Strongly agree", 2: "Agree", 3: "Neither agree nor disagree", 4: "Disagree", 5: "Strongly disagree", DK/R}
871. WST_Q404: "Your job required that you do things over and over." — Single select {1: "Strongly agree", 2: "Agree", 3: "Neither agree nor disagree", 4: "Disagree", 5: "Strongly disagree", DK/R}
872. WST_Q405: "Your job was very hectic." — Single select {1: "Strongly agree", 2: "Agree", 3: "Neither agree nor disagree", 4: "Disagree", 5: "Strongly disagree", DK/R}
873. WST_Q406: "You were free from conflicting demands that others made." — Single select {1: "Strongly agree", 2: "Agree", 3: "Neither agree nor disagree", 4: "Disagree", 5: "Strongly disagree", DK/R}
874. WST_Q407: "Your job security was good." — Single select {1: "Strongly agree", 2: "Agree", 3: "Neither agree nor disagree", 4: "Disagree", 5: "Strongly disagree", DK/R}
875. WST_Q408: "Your job required a lot of physical effort." — Single select {1: "Strongly agree", 2: "Agree", 3: "Neither agree nor disagree", 4: "Disagree", 5: "Strongly disagree", DK/R}
876. WST_Q409: "You had a lot to say about what happened in your job." — Single select {1: "Strongly agree", 2: "Agree", 3: "Neither agree nor disagree", 4: "Disagree", 5: "Strongly disagree", DK/R}
877. WST_Q410: "You were exposed to hostility or conflict from the people you worked with." — Single select {1: "Strongly agree", 2: "Agree", 3: "Neither agree nor disagree", 4: "Disagree", 5: "Strongly disagree", DK/R}
878. WST_Q411: "Your supervisor was helpful in getting the job done." — Single select {1: "Strongly agree", 2: "Agree", 3: "Neither agree nor disagree", 4: "Disagree", 5: "Strongly disagree", DK/R}
879. WST_Q412: "The people you worked with were helpful in getting the job done." — Single select {1: "Strongly agree", 2: "Agree", 3: "Neither agree nor disagree", 4: "Disagree", 5: "Strongly disagree", DK/R}
880. WST_Q412A: "You had the materials and equipment you needed to do your job." — Single select {1: "Strongly agree", 2: "Agree", 3: "Neither agree nor disagree", 4: "Disagree", 5: "Strongly disagree", DK/R}
881. WST_Q413: "How satisfied were you with your job?" — Single select {1: "Very satisfied", 2: "Somewhat satisfied", 3: "Not too satisfied", 4: "Not at all satisfied", DK/R}

---

### Section: SFE - Self-Esteem - 10 items

882. SFE_C500A: Filter — If do SFE block = 1, go to SFE_C500B; otherwise go to SFE_END — Filter
883. SFE_C500B: Filter — If proxy interview, go to SFE_END; otherwise go to SFE_R5 — Filter
884. SFE_R5: "Now a series of statements that people might use to describe themselves. Please tell me if you strongly agree, agree, neither agree nor disagree, disagree, or strongly disagree." — Read (press Enter to continue)
885. SFE_Q501: "You feel that you have a number of good qualities." — Single select {1: "Strongly agree", 2: "Agree", 3: "Neither agree nor disagree", 4: "Disagree", 5: "Strongly disagree", DK, R → SFE_END}
886. SFE_Q502: "You feel that you're a person of worth at least equal to others." — Single select {1: "Strongly agree", 2: "Agree", 3: "Neither agree nor disagree", 4: "Disagree", 5: "Strongly disagree", DK/R}
887. SFE_Q503: "You are able to do things as well as most other people." — Single select {1: "Strongly agree", 2: "Agree", 3: "Neither agree nor disagree", 4: "Disagree", 5: "Strongly disagree", DK/R}
888. SFE_Q504: "You take a positive attitude toward yourself." — Single select {1: "Strongly agree", 2: "Agree", 3: "Neither agree nor disagree", 4: "Disagree", 5: "Strongly disagree", DK/R}
889. SFE_Q505: "On the whole you are satisfied with yourself." — Single select {1: "Strongly agree", 2: "Agree", 3: "Neither agree nor disagree", 4: "Disagree", 5: "Strongly disagree", DK/R}
890. SFE_Q506: "All in all, you're inclined to feel you're a failure." — Single select {1: "Strongly agree", 2: "Agree", 3: "Neither agree nor disagree", 4: "Disagree", 5: "Strongly disagree", DK/R}

### Section: SSA - Social Support Availability - 43 items

891. SSA_C1: Filter — If do SSA block = 1, go to SSA_C2; otherwise go to SSA_END — Filter
892. SSA_C2: Filter — If proxy interview, go to SSA_END; otherwise go to SSA_R1 — Filter
893. SSA_R1: "Next are some questions about the support that is available to you." — Read
894. SSA_Q01: "About how many close friends and close relatives do you have, that is, people you feel at ease with and can talk to about what is on your mind?" — Numeric (0–99; warning after 20) — DK/R → SSA_END
895. SSA_R2: "People sometimes look to others for companionship, assistance or other types of support." — Read
896. SSA_Q02: "How often is each of the following kinds of support available to you if you need it: … someone to help you if you were confined to bed?" — Scale {1: "None of the time", 2: "A little of the time", 3: "Some of the time", 4: "Most of the time", 5: "All of the time"} — DK/R → SSA_END
897. SSA_C02: Filter — If SSA_Q02 = 2, 3, 4 or 5, KEY_PHRASES21A = "to help you if you were confined to bed" — Filter
898. SSA_Q03: "(How often is each of the following kinds of support available to you if you need it:) … someone you can count on to listen to you when you need to talk?" — Scale {1: "None of the time", 2: "A little of the time", 3: "Some of the time", 4: "Most of the time", 5: "All of the time"} — DK/R continues
899. SSA_C03: Filter — If SSA_Q03 = 2, 3, 4 or 5, KEY_PHRASES24A = "to listen to you" — Filter
900. SSA_Q04: "(How often is each of the following kinds of support available to you if you need it:) … someone to give you advice about a crisis?" — Scale {1: "None of the time", 2: "A little of the time", 3: "Some of the time", 4: "Most of the time", 5: "All of the time"} — DK/R continues
901. SSA_C04: Filter — If SSA_Q04 = 2, 3, 4 or 5, KEY_PHRASES24A = "to give you advice" — Filter
902. SSA_Q05: "(How often is each of the following kinds of support available to you if you need it:) … someone to take you to the doctor if you needed it?" — Scale {1: "None of the time", 2: "A little of the time", 3: "Some of the time", 4: "Most of the time", 5: "All of the time"} — DK/R continues
903. SSA_C05: Filter — If SSA_Q05 = 2, 3, 4 or 5, KEY_PHRASES21A = "to take you to the doctor" — Filter
904. SSA_Q06: "(How often is each of the following kinds of support available to you if you need it:) … someone who shows you love and affection?" — Scale {1: "None of the time", 2: "A little of the time", 3: "Some of the time", 4: "Most of the time", 5: "All of the time"} — DK/R continues
905. SSA_C06: Filter — If SSA_Q06 = 2, 3, 4 or 5, KEY_PHRASES22A = "to show you affection" — Filter
906. SSA_Q07: "(How often is each of the following kinds of support available to you if you need it:) … someone to have a good time with?" — Scale {1: "None of the time", 2: "A little of the time", 3: "Some of the time", 4: "Most of the time", 5: "All of the time"} — DK/R continues
907. SSA_C07: Filter — If SSA_Q07 = 2, 3, 4 or 5, KEY_PHRASES23A = "to have a good time with" — Filter
908. SSA_Q08: "(How often is each of the following kinds of support available to you if you need it:) … someone to give you information in order to help you understand a situation?" — Scale {1: "None of the time", 2: "A little of the time", 3: "Some of the time", 4: "Most of the time", 5: "All of the time"} — DK/R continues
909. SSA_C08: Filter — If SSA_Q08 = 2, 3, 4 or 5, KEY_PHRASES24A = "to give you information" — Filter
910. SSA_Q09: "(How often is each of the following kinds of support available to you if you need it:) … someone to confide in or talk to about yourself or your problems?" — Scale {1: "None of the time", 2: "A little of the time", 3: "Some of the time", 4: "Most of the time", 5: "All of the time"} — DK/R continues
911. SSA_C09: Filter — If SSA_Q09 = 2, 3, 4 or 5, KEY_PHRASES24A = "to confide in" — Filter
912. SSA_Q10: "(How often is each of the following kinds of support available to you if you need it:) … someone who hugs you?" — Scale {1: "None of the time", 2: "A little of the time", 3: "Some of the time", 4: "Most of the time", 5: "All of the time"} — DK/R continues
913. SSA_C10: Filter — If SSA_Q10 = 2, 3, 4 or 5, KEY_PHRASES22A = "to hug you" — Filter
914. SSA_Q11: "(How often is each of the following kinds of support available to you if you need it:) … someone to get together with for relaxation?" — Scale {1: "None of the time", 2: "A little of the time", 3: "Some of the time", 4: "Most of the time", 5: "All of the time"} — DK/R continues
915. SSA_C11: Filter — If SSA_Q11 = 2, 3, 4 or 5, KEY_PHRASE23A = "to relax with" — Filter
916. SSA_Q12: "(How often is each of the following kinds of support available to you if you need it:) … someone to prepare your meals if you were unable to do it yourself?" — Scale {1: "None of the time", 2: "A little of the time", 3: "Some of the time", 4: "Most of the time", 5: "All of the time"} — DK/R continues
917. SSA_C12: Filter — If SSA_Q12 = 2, 3, 4 or 5, KEY_PHRASES21A = "to prepare your meals" — Filter
918. SSA_Q13: "(How often is each of the following kinds of support available to you if you need it:) … someone whose advice you really want?" — Scale {1: "None of the time", 2: "A little of the time", 3: "Some of the time", 4: "Most of the time", 5: "All of the time"} — DK/R continues
919. SSA_C13: Filter — If SSA_Q13 = 2, 3, 4 or 5, KEY_PHRASES24A = "to advise you" — Filter
920. SSA_Q14: "(How often is each of the following kinds of support available to you if you need it:) … someone to do things with to help you get your mind off things?" — Scale {1: "None of the time", 2: "A little of the time", 3: "Some of the time", 4: "Most of the time", 5: "All of the time"} — DK/R continues
921. SSA_C14: Filter — If SSA_Q14 = 2, 3, 4 or 5, KEY_PHRASES23A = "to do things with" — Filter
922. SSA_Q15: "(How often is each of the following kinds of support available to you if you need it:) … someone to help with daily chores if you were sick?" — Scale {1: "None of the time", 2: "A little of the time", 3: "Some of the time", 4: "Most of the time", 5: "All of the time"} — DK/R continues
923. SSA_C15: Filter — If SSA_Q15 = 2, 3, 4 or 5, KEY_PHRASES21A = "to help with daily chores" — Filter
924. SSA_Q16: "(How often is each of the following kinds of support available to you if you need it:) … someone to share your most private worries and fears with?" — Scale {1: "None of the time", 2: "A little of the time", 3: "Some of the time", 4: "Most of the time", 5: "All of the time"} — DK/R continues
925. SSA_C16: Filter — If SSA_Q16 = 2, 3, 4 or 5, KEY_PHRASES24A = "to share your worries and fears with" — Filter
926. SSA_Q17: "(How often is each of the following kinds of support available to you if you need it:) … someone to turn to for suggestions about how to deal with a personal problem?" — Scale {1: "None of the time", 2: "A little of the time", 3: "Some of the time", 4: "Most of the time", 5: "All of the time"} — DK/R continues
927. SSA_C17: Filter — If SSA_Q17 = 2, 3, 4 or 5, KEY_PHRASES24A = "to turn to for suggestions" — Filter
928. SSA_Q18: "(How often is each of the following kinds of support available to you if you need it:) … someone to do something enjoyable with?" — Scale {1: "None of the time", 2: "A little of the time", 3: "Some of the time", 4: "Most of the time", 5: "All of the time"} — DK/R continues
929. SSA_C18: Filter — If SSA_Q18 = 2, 3, 4 or 5, KEY_PHRASES23A = "to do something enjoyable with" — Filter
930. SSA_Q19: "(How often is each of the following kinds of support available to you if you need it:) … someone who understands your problems?" — Scale {1: "None of the time", 2: "A little of the time", 3: "Some of the time", 4: "Most of the time", 5: "All of the time"} — DK/R continues
931. SSA_C19: Filter — If SSA_Q19 = 2, 3, 4 or 5, KEY_PHRASES24A = "to understand your problems" — Filter
932. SSA_Q20: "(How often is each of the following kinds of support available to you if you need it:) … someone to love you and make you feel wanted?" — Scale {1: "None of the time", 2: "A little of the time", 3: "Some of the time", 4: "Most of the time", 5: "All of the time"} — DK/R continues
933. SSA_C20: Filter — If SSA_Q20 = 2, 3, 4 or 5, KEY_PHRASES22A = "to love you and make you feel wanted" — Filter

### Section: SSU - Social Support Utilization - 19 items

934. SSU_C1: Filter — If do SSU block = 1, go to SSU_C2; otherwise go to SSU_END — Filter
935. SSU_C2: Filter — If proxy interview, go to SSU_END; otherwise go to SSU_C3 — Filter
936. SSU_C3: Filter — If any responses of 2, 3, 4 or 5 in SSA_Q02 to SSA_Q20, go to SSU_R1; otherwise go to SSU_END — Filter
937. SSU_R1: "You have just mentioned that if you needed support, someone would be available for you. The next questions are about the support or help you actually received in the past 12 months." — Read
938. SSU_C21: Filter — If any responses of 2, 3, 4 or 5 in SSA_Q02, SSA_Q05, SSA_Q12, or SSA_Q15, go to SSU_Q21A; otherwise go to SSU_C22 — Filter
939. SSU_Q21A: "In the past 12 months, did you receive the following support: someone ^KEY_PHRASES21A?" — Single select {1: "Yes", 2: "No"} — 2 → SSU_C22; DK/R → SSU_C22
940. SSU_Q21B: "When you needed it, how often did you receive this kind of support (in the past 12 months)?" — Scale {1: "Almost always", 2: "Frequently", 3: "Half the time", 4: "Rarely", 5: "Never"} — DK/R continues
941. SSU_C22: Filter — If any responses of 2, 3, 4 or 5 in SSA_Q06, SSA_Q10, or SSA_Q20, go to SSU_Q22A; otherwise go to SSU_C23 — Filter
942. SSU_Q22A: "(In the past 12 months, did you receive the following support:) someone ^KEY_PHRASES22A?" — Single select {1: "Yes", 2: "No"} — 2 → SSU_C23; DK/R → SSU_C23
943. SSU_Q22B: "When you needed it, how often did you receive this kind of support (in the past 12 months)?" — Scale {1: "Almost always", 2: "Frequently", 3: "Half the time", 4: "Rarely", 5: "Never"} — DK/R continues
944. SSU_C23: Filter — If any responses of 2, 3, 4 or 5 in SSA_Q07, SSA_Q11, SSA_Q14, or SSA_Q18, go to SSU_Q23A; otherwise go to SSU_C24 — Filter
945. SSU_Q23A: "(In the past 12 months, did you receive the following support:) someone ^KEY_PHRASES23A?" — Single select {1: "Yes", 2: "No"} — 2 → SSU_C24; DK/R → SSU_C24
946. SSU_Q23B: "When you needed it, how often did you receive this kind of support (in the past 12 months)?" — Scale {1: "Almost always", 2: "Frequently", 3: "Half the time", 4: "Rarely", 5: "Never"} — DK/R continues
947. SSU_C24: Filter — If any responses of 2, 3, 4 or 5 in SSA_Q03, SSA_Q04, SSA_Q08, SSA_Q09, SSA_Q13, SSA_Q16, SSA_Q17, or SSA_Q19, go to SSU_Q24A; otherwise go to SSU_END — Filter
948. SSU_Q24A: "(In the past 12 months, did you receive the following support:) someone ^KEY_PHRASES24A?" — Single select {1: "Yes", 2: "No"} — 2 → SSU_END; DK/R → SSU_END
949. SSU_Q24B: "When you needed it, how often did you receive this kind of support (in the past 12 months)?" — Scale {1: "Almost always", 2: "Frequently", 3: "Half the time", 4: "Rarely", 5: "Never"} — DK/R continues

### Section: CMH - Contacts with Mental Health Professionals - 13 items

950. CMH_C01A: Filter — If CMH block = 1, go to CMH_C01B; otherwise go to CMH_END — Filter
951. CMH_C01B: Filter — If proxy interview, go to CMH_END; otherwise go to CMH_R1K — Filter
952. CMH_R1K: "Now some questions about mental and emotional well-being." — Read
953. CMH_Q01K: "In the past 12 months, that is, from [date one year ago] to yesterday, have you seen, or talked on the telephone, to a health professional about your emotional or mental health?" — Single select {1: "Yes", 2: "No"} — 2 → CMH_END; DK/R → CMH_END
954. CMH_Q01L: "How many times (in the past 12 months)?" — Numeric (1–366; warning after 25) — DK/R continues
955. CMH_Q01M: "Whom did you see or talk to?" — Multi select {1: "Family doctor or general practitioner", 2: "Psychiatrist", 3: "Psychologist", 4: "Nurse", 5: "Social worker or counselor", 6: "Other - Specify"}
956. CMH_C01MS: Filter — If CMH_Q01M = 6, go to CMH_Q01MS; otherwise go to CMH_END — Filter
957. CMH_Q01MS: "INTERVIEWER: Specify." — Text (80 characters) — DK/R continues
958. CMH_E01M[1]: Constraint — Soft edit: if CMH_Q01M = 1 and HCU_Q02A = 0, flag inconsistency (saw family doctor but previously reported did not) — Constraint
959. CMH_E01M[2]: Constraint — Soft edit: if CMH_Q01M = 2 and HCU_Q02C = 0, flag inconsistency (saw psychiatrist but previously reported did not) — Constraint
960. CMH_E01M[3]: Constraint — Soft edit: if CMH_Q01M = 3 and HCU_Q02I = 0, flag inconsistency (saw psychologist but previously reported did not) — Constraint
961. CMH_E01M[4]: Constraint — Soft edit: if CMH_Q01M = 4 and HCU_Q02D = 0, flag inconsistency (saw nurse but previously reported did not) — Constraint
962. CMH_E01M[5]: Constraint — Soft edit: if CMH_Q01M = 5 and HCU_Q02H = 0, flag inconsistency (saw social worker/counsellor but previously reported did not) — Constraint

### Section: DIS - Distress - 19 items

963. DIS_C1: Filter — If do DIS block = 1, go to DIS_C2; otherwise go to DIS_END — Filter
964. DIS_C2: Filter — If proxy interview, go to DIS_END; otherwise go to DIS_R01 — Filter
965. DIS_R01: "The following questions deal with feelings you may have had during the past month." — Read
966. DIS_Q01A: "During the past month, that is, from [date one month ago] to yesterday, about how often did you feel: ... tired out for no good reason?" — Scale {1: "All of the time", 2: "Most of the time", 3: "Some of the time", 4: "A little of the time", 5: "None of the time"} — DK/R → DIS_END
967. DIS_Q01B: "(About how often did you feel:) … nervous?" — Scale {1: "All of the time", 2: "Most of the time", 3: "Some of the time", 4: "A little of the time", 5: "None of the time"} — 5 → DIS_Q01D; DK/R → DIS_Q01D
968. DIS_Q01C: "(About how often did you feel:) ... so nervous that nothing could calm you down?" — Scale {1: "All of the time", 2: "Most of the time", 3: "Some of the time", 4: "A little of the time", 5: "None of the time"} — DK/R continues; Note: if DIS_Q01B = 5, DIS_Q01C set to 5 in processing
969. DIS_Q01D: "(About how often did you feel:) ... hopeless?" — Scale {1: "All of the time", 2: "Most of the time", 3: "Some of the time", 4: "A little of the time", 5: "None of the time"} — DK/R continues
970. DIS_Q01E: "(About how often did you feel:) ... restless or fidgety?" — Scale {1: "All of the time", 2: "Most of the time", 3: "Some of the time", 4: "A little of the time", 5: "None of the time"} — 5 → DIS_Q01G; DK/R → DIS_Q01G
971. DIS_Q01F: "(About how often did you feel:) … so restless you could not sit still?" — Scale {1: "All of the time", 2: "Most of the time", 3: "Some of the time", 4: "A little of the time", 5: "None of the time"} — DK/R continues; Note: if DIS_Q01E = 5, DIS_Q01F set to 5 in processing
972. DIS_Q01G: "(About how often did you feel:) …sad or depressed?" — Scale {1: "All of the time", 2: "Most of the time", 3: "Some of the time", 4: "A little of the time", 5: "None of the time"} — 5 → DIS_Q01I; DK/R → DIS_Q01I
973. DIS_Q01H: "(About how often did you feel:) …so depressed that nothing could cheer you up?" — Scale {1: "All of the time", 2: "Most of the time", 3: "Some of the time", 4: "A little of the time", 5: "None of the time"} — DK/R continues; Note: if DIS_Q01G = 5, DIS_Q01H set to 5 in processing
974. DIS_Q01I: "(About how often did you feel:) …that everything was an effort?" — Scale {1: "All of the time", 2: "Most of the time", 3: "Some of the time", 4: "A little of the time", 5: "None of the time"} — DK/R continues
975. DIS_Q01J: "(About how often did you feel:) …worthless?" — Scale {1: "All of the time", 2: "Most of the time", 3: "Some of the time", 4: "A little of the time", 5: "None of the time"} — DK/R continues; Note: if DIS_Q01B to DIS_Q01J are DK/R → DIS_END
976. DIS_Q01K: "Taking them altogether, did these feelings occur more often in the past month than is usual for you, less often than usual or about the same as usual?" — Single select {1: "More often", 2: "Less often", 3: "About the same", 4: "Never have had any"} — 2 → DIS_Q01M; 3 → DIS_Q01N; 4 → DIS_END; DK/R → DIS_END
977. DIS_Q01L: "Is that a lot more, somewhat more or only a little more often than usual?" — Single select {1: "A lot", 2: "Somewhat", 3: "A little"} — DK/R continues; → DIS_Q01N
978. DIS_Q01M: "Is that a lot less, somewhat less or only a little less often than usual?" — Single select {1: "A lot", 2: "Somewhat", 3: "A little"} — DK/R continues
979. DIS_Q01N: "During the past month, how much did these feelings usually interfere with your life or activities?" — Single select {1: "A lot", 2: "Some", 3: "A little", 4: "Not at all"} — DK/R continues

### Section: DEP - Depression - 32 items

980. DEP_C01: Filter — If do DEP block = 1, go to DEP_C02; otherwise go to DEP_END — Filter
981. DEP_C02: Filter — If proxy interview, go to DEP_END; otherwise go to DEP_Q02 — Filter
982. DEP_Q02: "During the past 12 months, was there ever a time when you felt sad, blue, or depressed for 2 weeks or more in a row?" — Single select {1: "Yes", 2: "No"} — 2 → DEP_Q16; DK/R → DEP_END
983. DEP_Q03: "For the next few questions, please think of the 2-week period during the past 12 months when these feelings were the worst. During that time, how long did these feelings usually last?" — Single select {1: "All day long", 2: "Most of the day", 3: "About half of the day", 4: "Less than half of a day"} — 3 → DEP_Q16; 4 → DEP_Q16; DK/R → DEP_END
984. DEP_Q04: "How often did you feel this way during those 2 weeks?" — Single select {1: "Every day", 2: "Almost every day", 3: "Less often"} — 3 → DEP_Q16; DK/R → DEP_END
985. DEP_Q05: "During those 2 weeks did you lose interest in most things?" — Single select {1: "Yes (KEY PHRASE = Losing interest)", 2: "No"} — DK/R → DEP_END
986. DEP_Q06: "Did you feel tired out or low on energy all of the time?" — Single select {1: "Yes (KEY PHRASE = Feeling tired)", 2: "No"} — DK/R → DEP_END
987. DEP_Q07: "Did you gain weight, lose weight or stay about the same?" — Single select {1: "Gained weight (KEY PHRASE = Gaining weight)", 2: "Lost weight (KEY PHRASE = Losing weight)", 3: "Stayed about the same", 4: "Was on a diet"} — 3 → DEP_Q09; 4 → DEP_Q09; DK/R → DEP_END
988. DEP_Q08A: "About how much did you [gain/lose]?" — Numeric (1–99; warning after 20 pounds/9 kg) — DK/R → DEP_Q09
989. DEP_Q08B: "INTERVIEWER: Was that in pounds or in kilograms?" — Single select {1: "Pounds", 2: "Kilograms"} — DK/R not allowed
990. DEP_Q09: "Did you have more trouble falling asleep than you usually do?" — Single select {1: "Yes (KEY PHRASE = Trouble falling asleep)", 2: "No"} — 2 → DEP_Q11; DK/R → DEP_END
991. DEP_Q10: "How often did that happen?" — Single select {1: "Every night", 2: "Nearly every night", 3: "Less often"} — DK/R → DEP_END
992. DEP_Q11: "Did you have a lot more trouble concentrating than usual?" — Single select {1: "Yes (KEY PHRASE = Trouble concentrating)", 2: "No"} — DK/R → DEP_END
993. DEP_Q12: "At these times, people sometimes feel down on themselves, no good or worthless. Did you feel this way?" — Single select {1: "Yes (KEY PHRASE = Feeling down on yourself)", 2: "No"} — DK/R → DEP_END
994. DEP_Q13: "Did you think a lot about death - either your own, someone else's or death in general?" — Single select {1: "Yes (KEY PHRASE = Thoughts about death)", 2: "No"} — DK/R → DEP_END
995. DEP_C14: Filter — If any Yes in DEP_Q05, DEP_Q06, DEP_Q09, DEP_Q11, DEP_Q12, DEP_Q13, or DEP_Q07 is gain/lose, go to DEP_Q14C; otherwise go to DEP_END — Filter
996. DEP_Q14C: "Reviewing what you just told me, you had 2 weeks in a row during the past 12 months when you were sad, blue or depressed and also had some other things like (KEY PHRASES)." — Read
997. DEP_Q14: "About how many weeks altogether did you feel this way during the past 12 months?" — Numeric (2–53) — >51 → DEP_END; DK/R → DEP_END
998. DEP_Q15: "Think about the last time you felt this way for 2 weeks or more in a row. In what month was that?" — Single select {1: "January", 2: "February", 3: "March", 4: "April", 5: "May", 6: "June", 7: "July", 8: "August", 9: "September", 10: "October", 11: "November", 12: "December"} — DK/R continues; → DEP_END
999. DEP_Q16: "During the past 12 months, was there ever a time lasting 2 weeks or more when you lost interest in most things like hobbies, work or activities that usually give you pleasure?" — Single select {1: "Yes", 2: "No"} — 2 → DEP_END; DK/R → DEP_END
1000. DEP_Q17: "For the next few questions, please think of the 2-week period during the past 12 months when you had the most complete loss of interest in things. During that 2-week period, how long did the loss of interest usually last?" — Single select {1: "All day long", 2: "Most of the day", 3: "About half of the day", 4: "Less than half of a day"} — 3 → DEP_END; 4 → DEP_END; DK/R → DEP_END
1001. DEP_Q18: "How often did you feel this way during those 2 weeks?" — Single select {1: "Every day", 2: "Almost every day", 3: "Less often"} — 3 → DEP_END; DK/R → DEP_END
1002. DEP_Q19: "During those 2 weeks did you feel tired out or low on energy all the time?" — Single select {1: "Yes (KEY PHRASE = Feeling tired)", 2: "No"} — DK/R → DEP_END
1003. DEP_Q20: "Did you gain weight, lose weight, or stay about the same?" — Single select {1: "Gained weight (KEY PHRASE = Gaining weight)", 2: "Lost weight (KEY PHRASE = Losing weight)", 3: "Stayed about the same", 4: "Was on a diet"} — 3 → DEP_Q22; 4 → DEP_Q22; DK/R → DEP_END
1004. DEP_Q21A: "About how much did you [gain/lose]?" — Numeric (1–99; warning after 20 pounds/9 kg) — DK/R → DEP_Q22
1005. DEP_Q21B: "INTERVIEWER: Was that in pounds or in kilograms?" — Single select {1: "Pounds", 2: "Kilograms"} — DK/R not allowed
1006. DEP_Q22: "Did you have more trouble falling asleep than you usually do?" — Single select {1: "Yes (KEY PHRASE = Trouble falling asleep)", 2: "No"} — 2 → DEP_Q24; DK/R → DEP_END
1007. DEP_Q23: "How often did that happen?" — Single select {1: "Every night", 2: "Nearly every night", 3: "Less often"} — DK/R → DEP_END
1008. DEP_Q24: "Did you have a lot more trouble concentrating than usual?" — Single select {1: "Yes (KEY PHRASE = Trouble concentrating)", 2: "No"} — DK/R → DEP_END
1009. DEP_Q25: "At these times, people sometimes feel down on themselves, no good, or worthless. Did you feel this way?" — Single select {1: "Yes (KEY PHRASE = Feeling down on yourself)", 2: "No"} — DK/R → DEP_END
1010. DEP_Q26: "Did you think a lot about death - either your own, someone else's, or death in general?" — Single select {1: "Yes (KEY PHRASE = Thoughts about death)", 2: "No"} — DK/R → DEP_END
1011. DEP_C27: Filter — If any Yes in DEP_Q19, DEP_Q22, DEP_Q24, DEP_Q25, DEP_Q26, or DEP_Q20 is gain/lose, go to DEP_Q27C; otherwise go to DEP_END — Filter
1012. DEP_Q27C: "Reviewing what you just told me, you had 2 weeks in a row during the past 12 months when you lost interest in most things and also had some other things like (KEY PHRASES)." — Read
1013. DEP_Q27: "About how many weeks did you feel this way during the past 12 months?" — Numeric (2–53) — >51 → DEP_END; DK/R → DEP_END
1014. DEP_Q28: "Think about the last time you had 2 weeks in a row when you felt this way. In what month was that?" — Single select {1: "January", 2: "February", 3: "March", 4: "April", 5: "May", 6: "June", 7: "July", 8: "August", 9: "September", 10: "October", 11: "November", 12: "December"} — DK/R continues

### Section: SUI - Suicidal Thoughts and Attempts - 10 items

1015. SUI_C1A: Filter — If do SUI block = 1, go to SUI_C1B; otherwise go to SUI_END — Filter
1016. SUI_C1B: Filter — If proxy interview or age < 15, go to SUI_END; otherwise go to SUI_QINT — Filter
1017. SUI_QINT: "The following questions relate to the sensitive issue of suicide." — Read
1018. SUI_Q1: "Have you ever seriously considered committing suicide or taking your own life?" — Single select {1: "Yes", 2: "No"} — 2 → SUI_END; DK/R → SUI_END
1019. SUI_Q2: "Has this happened in the past 12 months?" — Single select {1: "Yes", 2: "No"} — 2 → SUI_END; DK/R → SUI_END
1020. SUI_Q3: "Have you ever attempted to commit suicide or tried taking your own life?" — Single select {1: "Yes", 2: "No"} — 2 → SUI_END; DK/R → SUI_END
1021. SUI_Q4: "Did this happen in the past 12 months?" — Single select {1: "Yes", 2: "No"} — 2 → SUI_END; DK/R → SUI_END
1022. SUI_Q5: "Did you see, or talk on the telephone, to a health professional following your attempt to commit suicide?" — Single select {1: "Yes", 2: "No"} — 2 → SUI_END; DK/R → SUI_END
1023. SUI_Q6: "Whom did you see or talk to?" — Multi select {1: "Family doctor or general practitioner", 2: "Psychiatrist", 3: "Psychologist", 4: "Nurse", 5: "Social worker or counsellor", 6: "Religious or spiritual advisor such as a priest, chaplain or rabbi", 7: "Teacher or guidance counsellor", 8: "Other"} — DK/R continues

### Section: INJ - Injuries - 35 items

1024. INJ_C1: Filter — If do INJ block = 1, go to REP_R1; otherwise go to INJ_END — Filter
1025. REP_R1: "This next section deals with repetitive strain injuries. By this we mean injuries caused by overuse or by repeating the same movement frequently. (For example, carpal tunnel syndrome, tennis elbow or tendonitis.)" — Read
1026. REP_Q1: "In the past 12 months, that is, from [date one year ago] to yesterday, did ^YOU2 have any injuries due to repetitive strain which were serious enough to limit ^YOUR1 normal activities?" — Single select {1: "Yes", 2: "No"} — 2 → INJ_R1; DK/R → INJ_R1
1027. REP_Q3: "Thinking about the most serious repetitive strain, what part of the body was affected?" — Single select {1: "Head", 2: "Neck", 3: "Shoulder, upper arm", 4: "Elbow, lower arm", 5: "Wrist", 6: "Hand", 7: "Hip", 8: "Thigh", 9: "Knee, lower leg", 10: "Ankle, foot", 11: "Upper back or upper spine (excluding neck)", 12: "Lower back or lower spine", 13: "Chest (excluding back and spine)", 14: "Abdomen or pelvis (excluding back and spine)"} — DK/R continues
1028. REP_Q4: "What type of activity ^WERE ^YOU1 doing when ^YOU1 got this repetitive strain?" — Multi select {1: "Sports or physical exercise (include school activities)", 2: "Leisure or hobby (include volunteering)", 3: "Working at a job or business (exclude travel to or from work)", 4: "Travel to or from work", 5: "Household chores, other unpaid work or education", 6: "Sleeping, eating, personal care", 7: "Other - Specify"} — DK/R continues
1029. REP_C4S: Filter — If REP_Q4 = 7, go to INJ_Q4S; otherwise go to REP_R1 — Filter
1030. REP_Q4S: "INTERVIEWER: Specify." — Text (80 characters) — DK/R continues
1031. INJ_R1: "Now some questions about [other] injuries which occurred in the past 12 months, and were serious enough to limit ^YOUR2 normal activities. For example, a broken bone, a bad cut or burn, a sprain, or a poisoning." — Read
1032. INJ_Q01: "[Not counting repetitive strain injuries, in the past 12 months,/In the past 12 months,] that is, from [date one year ago] to yesterday, ^WERE ^YOU2 injured?" — Single select {1: "Yes", 2: "No"} — 2 → INJ_Q16; DK/R → INJ_END
1033. INJ_Q02: "How many times ^WERE ^YOU1 injured?" — Numeric (1–30; warning after 6) — DK/R → INJ_END
1034. INJ_Q03: "[Thinking about the most serious injury, in which month/In which month] did it happen?" — Single select {1: "January", 2: "February", 3: "March", 4: "April", 5: "May", 6: "June", 7: "July", 8: "August", 9: "September", 10: "October", 11: "November", 12: "December"} — DK/R → INJ_Q05
1035. INJ_C04: Filter — If INJ_Q03 = current month, go to INJ_Q04; otherwise go to INJ_Q05 — Filter
1036. INJ_Q04: "Was that this year or last year?" — Single select {1: "This year", 2: "Last year"} — DK/R continues
1037. INJ_Q05: "What type of injury did ^YOU1 have? For example, a broken bone or burn." — Single select {1: "Multiple injuries", 2: "Broken or fractured bones", 3: "Burn, scald, chemical burn", 4: "Dislocation", 5: "Sprain or strain", 6: "Cut, puncture, animal or human bite (open wound)", 7: "Scrape, bruise, blister", 8: "Concussion or other brain injury", 9: "Poisoning", 10: "Injury to internal organs", 11: "Other - Specify"} — 8 → INJ_Q08; 9 → INJ_Q08; 10 → INJ_Q07; DK/R continues
1038. INJ_C05S: Filter — If INJ_Q05 = 11, go to INJ_Q05S; otherwise go to INJ_Q06 — Filter
1039. INJ_Q05S: "INTERVIEWER: Specify." — Text (80 characters) — DK/R continues
1040. INJ_Q06: "What part of the body was injured?" — Single select {1: "Multiple sites", 2: "Eyes", 3: "Head (excluding eyes)", 4: "Neck", 5: "Shoulder, upper arm", 6: "Elbow, lower arm", 7: "Wrist", 8: "Hand", 9: "Hip", 10: "Thigh", 11: "Knee, lower leg", 12: "Ankle, foot", 13: "Upper back or upper spine (excluding neck)", 14: "Lower back or lower spine", 15: "Chest (excluding back and spine)", 16: "Abdomen or pelvis (excluding back and spine)"} — DK/R continues; → INJ_Q08
1041. INJ_Q07: "What part of the body was injured?" — Single select {1: "Chest (within rib cage)", 2: "Abdomen or pelvis (below ribs)", 3: "Other - Specify"} — DK/R continues
1042. INJ_C07S: Filter — If INJ_Q07 = 3, go to INJ_Q07S; otherwise go to INJ_Q08 — Filter
1043. INJ_Q07S: "INTERVIEWER: Specify." — Text (80 characters) — DK/R continues
1044. INJ_Q08: "Where did the injury happen?" — Single select {1: "In a home or its surrounding area", 2: "Residential institution", 3: "School, college, university (exclude sports areas)", 4: "Sports or athletics area of school, college, university", 5: "Other sports or athletics area (exclude school sports areas)", 6: "Other institution (e.g., church, hospital, theatre, civic building)", 7: "Street, highway, sidewalk", 8: "Commercial area (e.g., store, restaurant, office building, transport terminal)", 9: "Industrial or construction area", 10: "Farm (exclude farmhouse and its surrounding area)", 11: "Countryside, forest, lake, ocean, mountains, prairie, etc.", 12: "Other - Specify"} — DK/R continues
1045. INJ_C08S: Filter — If INJ_Q08 = 12, go to INJ_Q08S; otherwise go to INJ_Q09 — Filter
1046. INJ_Q08S: "INTERVIEWER: Specify." — Text (80 characters) — DK/R continues
1047. INJ_Q09: "What type of activity ^WERE ^YOU1 doing when ^YOU1 ^WERE injured?" — Single select {1: "Sports or physical exercise (include school activities)", 2: "Leisure or hobby (include volunteering)", 3: "Working at a job or business (exclude travel to or from work)", 4: "Travel to or from work", 5: "Household chores, other unpaid work or education", 6: "Sleeping, eating, personal care", 7: "Other - Specify"} — DK/R continues
1048. INJ_C09S: Filter — If INJ_Q09 = 7, go to INJ_Q09S; otherwise go to INJ_Q10 — Filter
1049. INJ_Q09S: "INTERVIEWER: Specify." — Text (80 characters) — DK/R continues
1050. INJ_Q10: "Was the injury the result of a fall?" — Single select {1: "Yes", 2: "No"} — 2 → INJ_Q12; DK/R → INJ_Q12
1051. INJ_Q11: "How did ^YOU1 fall?" — Single select {1: "While skating, skiing, snowboarding, in-line skating or skateboarding", 2: "Going up or down stairs / steps (icy or not)", 3: "Slip, trip or stumble on ice or snow", 4: "Slip, trip or stumble on any other surface", 5: "From furniture (e.g., bed, chair)", 6: "From elevated position (e.g., ladder, tree)", 7: "Other - Specify"} — DK/R continues
1052. INJ_C11S: Filter — If INJ_Q11 = 7, go to INJ_Q11S; otherwise go to INJ_Q13 — Filter
1053. INJ_Q11S: "INTERVIEWER: Specify." — Text (80 characters) — DK/R continues; → INJ_Q13
1054. INJ_Q12: "What caused the injury?" — Single select {1: "Transportation accident", 2: "Accidentally bumped, pushed, bitten, etc. by person or animal", 3: "Accidentally struck or crushed by object(s)", 4: "Accidental contact with sharp object, tool or machine", 5: "Smoke, fire, flames", 6: "Accidental contact with hot object, liquid or gas", 7: "Extreme weather or natural disaster", 8: "Overexertion or strenuous movement", 9: "Physical assault", 10: "Other - Specify"} — DK/R continues
1055. INJ_C12S: Filter — If INJ_Q12 = 10, go to INJ_Q12S; otherwise go to INJ_Q13 — Filter
1056. INJ_Q12S: "INTERVIEWER: Specify." — Text (80 characters) — DK/R continues
1057. INJ_Q13: "Did ^YOU2 receive any medical attention for the injury from a health professional in the 48 hours following the injury?" — Single select {1: "Yes", 2: "No"} — 2 → INJ_Q16; DK/R → INJ_Q16
1058. INJ_Q14: "Where did ^YOU1 receive treatment?" — Multi select {1: "Doctor's office", 2: "Hospital emergency room", 3: "Hospital outpatient clinic (e.g. day surgery, cancer)", 4: "Walk-in clinic", 5: "Appointment clinic", 6: "Community health centre / CLSC", 7: "At work", 8: "At school", 9: "At home", 10: "Telephone consultation only", 11: "Other - Specify"} — DK/R continues
1059. INJ_C14S: Filter — If INJ_Q14 = 11, go to INJ_Q14S; otherwise go to INJ_Q15 — Filter
1060. INJ_Q14S: "INTERVIEWER: Specify." — Text (80 characters) — DK/R continues
1061. INJ_Q15: "^WERE ^YOU1 admitted to a hospital overnight?" — Single select {1: "Yes", 2: "No"} — DK/R continues
1062. INJ_E15: Constraint — Soft edit: if INJ_Q15 = 1 and HCU_Q01BA = 2, flag inconsistency (admitted overnight but previously reported did not) — Constraint
1063. INJ_Q16: "Did ^YOU2 have any other injuries in the past 12 months that were treated by a health professional, but did not limit ^YOUR1 normal activities?" — Single select {1: "Yes", 2: "No"} — 2 → INJ_END; DK/R → INJ_END
1064. INJ_Q17: "How many injuries?" — Numeric (1–30; warning after 6) — DK/R continues

### Section: HUI - Health Utilities Index - 34 items

1065. HUI_C1: Filter — if do HUI block = 1 go to HUI_QINT1, otherwise go to HUI_END — Filter
1066. HUI_QINT1: "The next set of questions asks about your day-to-day health..." — Read — interviewer presses Enter to continue
1067. HUI_Q01: "Are you usually able to see well enough to read ordinary newsprint without glasses or contact lenses?" — Yes/No {1: "Yes" → Go to HUI_Q04, 2: "No", DK/R → Go to HUI_END}
1068. HUI_Q02: "Are you usually able to see well enough to read ordinary newsprint with glasses or contact lenses?" — Yes/No {1: "Yes" → Go to HUI_Q04, 2: "No", DK/R: continue}
1069. HUI_Q03: "Are you able to see at all?" — Yes/No {1: "Yes", 2: "No" → Go to HUI_Q06, DK/R → Go to HUI_Q06}
1070. HUI_Q04: "Are you able to see well enough to recognize a friend on the other side of the street without glasses or contact lenses?" — Yes/No {1: "Yes" → Go to HUI_Q06, 2: "No", DK/R → Go to HUI_Q06}
1071. HUI_Q05: "Are you usually able to see well enough to recognize a friend on the other side of the street with glasses or contact lenses?" — Yes/No {1: "Yes", 2: "No", DK/R: continue}
1072. HUI_Q06: "Are you usually able to hear what is said in a group conversation with at least 3 other people without a hearing aid?" — Yes/No {1: "Yes" → Go to HUI_Q10, 2: "No", DK/R → Go to HUI_Q10}
1073. HUI_Q07: "Are you usually able to hear what is said in a group conversation with at least 3 other people with a hearing aid?" — Yes/No {1: "Yes" → Go to HUI_Q08, 2: "No", DK/R: continue}
1074. HUI_Q07A: "Are you able to hear at all?" — Yes/No {1: "Yes", 2: "No" → Go to HUI_Q10, DK/R → Go to HUI_Q10}
1075. HUI_Q08: "Are you usually able to hear what is said in a conversation with one other person in a quiet room without a hearing aid?" — Yes/No {1: "Yes" → Go to HUI_Q10, 2: "No", DK: continue, R → Go to HUI_Q10}
1076. HUI_Q09: "Are you usually able to hear what is said in a conversation with one other person in a quiet room with a hearing aid?" — Yes/No {1: "Yes", 2: "No", DK/R: continue}
1077. HUI_Q10: "Are you usually able to be understood completely when speaking with strangers in your own language?" — Yes/No {1: "Yes" → Go to HUI_Q14, 2: "No", DK: continue, R → Go to HUI_Q14}
1078. HUI_Q11: "Are you able to be understood partially when speaking with strangers?" — Yes/No {1: "Yes", 2: "No", DK/R: continue}
1079. HUI_Q12: "Are you able to be understood completely when speaking with those who know him/her well?" — Yes/No {1: "Yes" → Go to HUI_Q14, 2: "No", DK: continue, R → Go to HUI_Q14}
1080. HUI_Q13: "Are you able to be understood partially when speaking with those who know him/her well?" — Yes/No {1: "Yes", 2: "No", DK/R: continue}
1081. HUI_Q14: "Are you usually able to walk around the neighbourhood without difficulty and without mechanical support such as braces, a cane or crutches?" — Yes/No {1: "Yes" → Go to HUI_Q21, 2: "No", DK/R → Go to HUI_Q21}
1082. HUI_Q15: "Are you able to walk at all?" — Yes/No {1: "Yes", 2: "No" → Go to HUI_Q18, DK/R → Go to HUI_Q18}
1083. HUI_Q16: "Do you require mechanical support such as braces, a cane or crutches to be able to walk around the neighbourhood?" — Yes/No {1: "Yes", 2: "No", DK/R: continue}
1084. HUI_Q17: "Do you require the help of another person to be able to walk?" — Yes/No {1: "Yes", 2: "No", DK/R: continue}
1085. HUI_Q18: "Do you require a wheelchair to get around?" — Yes/No {1: "Yes", 2: "No" → Go to HUI_Q21, DK/R → Go to HUI_Q21}
1086. HUI_Q19: "How often do you use a wheelchair?" — Single select {1: "Always", 2: "Often", 3: "Sometimes", 4: "Never", DK/R: continue}
1087. HUI_Q20: "Do you need the help of another person to get around in the wheelchair?" — Yes/No {1: "Yes", 2: "No", DK/R: continue}
1088. HUI_Q21: "Are you usually able to grasp and handle small objects such as a pencil or scissors?" — Yes/No {1: "Yes" → Go to HUI_Q25, 2: "No", DK/R → Go to HUI_Q25}
1089. HUI_Q22: "Do you require the help of another person because of limitations in the use of hands or fingers?" — Yes/No {1: "Yes", 2: "No" → Go to HUI_Q24, DK/R → Go to HUI_Q24}
1090. HUI_Q23: "Do you require the help of another person with:" — Single select {1: "…some tasks?", 2: "…most tasks?", 3: "…almost all tasks?", 4: "…all tasks?", DK/R: continue}
1091. HUI_Q24: "Do you require special equipment, for example, devices to assist in dressing, because of limitations in the use of hands or fingers?" — Yes/No {1: "Yes", 2: "No", DK/R: continue}
1092. HUI_Q25: "Would you describe yourself as being usually:" — Single select {1: "…happy and interested in life?", 2: "…somewhat happy?", 3: "…somewhat unhappy?", 4: "…unhappy with little interest in life?", 5: "…so unhappy that life is not worthwhile?", DK/R: continue}
1093. HUI_Q26: "How would you describe your usual ability to remember things?" — Single select {1: "Able to remember most things", 2: "Somewhat forgetful", 3: "Very forgetful", 4: "Unable to remember anything at all", DK/R: continue}
1094. HUI_Q27: "How would you describe your usual ability to think and solve day-to-day problems?" — Single select {1: "Able to think clearly and solve problems", 2: "Having a little difficulty", 3: "Having some difficulty", 4: "Having a great deal of difficulty", 5: "Unable to think or solve problems", DK/R: continue}
1095. HUI_Q28: "Are you usually free of pain or discomfort?" — Yes/No {1: "Yes" → Go to HUI_END, 2: "No", DK/R → Go to HUI_END}
1096. HUI_Q29: "How would you describe the usual intensity of your pain or discomfort?" — Single select {1: "Mild", 2: "Moderate", 3: "Severe", DK/R: continue}
1097. HUI_Q30: "How many activities does your pain or discomfort prevent?" — Single select {1: "None", 2: "A few", 3: "Some", 4: "Most", DK/R: continue}

---

### Section: SFR - Health Status SF-36 - 38 items

1098. SFR_C03: Filter — if do SFR block = 1 go to SFR_R03A, otherwise go to SFR_END — Filter
1099. SFR_R03A: "Although some of the following questions may seem repetitive, the next section deals with another way of measuring health status." — Read — interviewer presses Enter to continue
1100. SFR_R03B: "The questions are about how you feel and how well you are able to do your usual activities." — Read — interviewer presses Enter to continue
1101. SFR_Q03: "Does your health limit you in vigorous activities, such as running, lifting heavy objects, or participating in strenuous sports?" — Single select {1: "Limited a lot", 2: "Limited a little", 3: "Not at all limited", DK/R → Go to SFR_END}
1102. SFR_Q04: "Does your health limit you in moderate activities, such as moving a table, pushing a vacuum cleaner, bowling, or playing golf?" — Single select {1: "Limited a lot", 2: "Limited a little", 3: "Not at all limited", DK/R: continue}
1103. SFR_Q05: "Does your health limit you in lifting or carrying groceries?" — Single select {1: "Limited a lot", 2: "Limited a little", 3: "Not at all limited", DK/R: continue}
1104. SFR_Q06: "Does your health limit you in climbing several flights of stairs?" — Single select {1: "Limited a lot", 2: "Limited a little", 3: "Not at all limited", DK/R: continue}
1105. SFR_Q07: "Does your health limit you in climbing one flight of stairs?" — Single select {1: "Limited a lot", 2: "Limited a little", 3: "Not at all limited", DK/R: continue}
1106. SFR_Q08: "Does your health limit you in bending, kneeling, or stooping?" — Single select {1: "Limited a lot", 2: "Limited a little", 3: "Not at all limited", DK/R: continue}
1107. SFR_Q09: "Does your health limit you in walking more than one kilometre?" — Single select {1: "Limited a lot", 2: "Limited a little", 3: "Not at all limited", DK/R: continue}
1108. SFR_Q10: "Does your health limit you in walking several blocks?" — Single select {1: "Limited a lot", 2: "Limited a little", 3: "Not at all limited", DK/R: continue}
1109. SFR_Q11: "Does your health limit you in walking one block?" — Single select {1: "Limited a lot", 2: "Limited a little", 3: "Not at all limited", DK/R: continue}
1110. SFR_Q12: "Does your health limit you in bathing and dressing yourself?" — Single select {1: "Limited a lot", 2: "Limited a little", 3: "Not at all limited", DK/R: continue}
1111. SFR_Q13: "Because of your physical health, during the past 4 weeks, did you cut down on the amount of time you spent on work or other activities?" — Yes/No {1: "Yes", 2: "No", DK/R: continue}
1112. SFR_Q14: "Because of your physical health, during the past 4 weeks, did you accomplish less than you would like?" — Yes/No {1: "Yes", 2: "No", DK/R: continue}
1113. SFR_Q15: "Because of your physical health, during the past 4 weeks, were you limited in the kind of work or other activities?" — Yes/No {1: "Yes", 2: "No", DK/R: continue}
1114. SFR_Q16: "Because of your physical health, during the past 4 weeks, did you have difficulty performing the work or other activities (for example, it took extra effort)?" — Yes/No {1: "Yes", 2: "No", DK/R: continue}
1115. SFR_Q17: "Because of emotional problems, during the past 4 weeks, did you cut down on the amount of time you spent on work or other activities?" — Yes/No {1: "Yes", 2: "No", DK/R: continue, R → Go to SFR_END}
1116. SFR_Q18: "Because of emotional problems, during the past 4 weeks, did you accomplish less than you would like?" — Yes/No {1: "Yes", 2: "No", DK/R: continue}
1117. SFR_Q19: "Because of emotional problems, during the past 4 weeks, did you not do work or other activities as carefully as usual?" — Yes/No {1: "Yes", 2: "No", DK/R: continue}
1118. SFR_Q20: "During the past 4 weeks, how much has your physical health or emotional problems interfered with your normal social activities with family, friends, neighbours, or groups?" — Single select {1: "Not at all", 2: "A little bit", 3: "Moderately", 4: "Quite a bit", 5: "Extremely", DK/R: continue}
1119. SFR_Q21: "During the past 4 weeks, how much bodily pain have you had?" — Single select {1: "None", 2: "Very mild", 3: "Mild", 4: "Moderate", 5: "Severe", 6: "Very severe", DK/R: continue}
1120. SFR_Q22: "During the past 4 weeks, how much did pain interfere with your normal work (including work both outside the home and housework)?" — Single select {1: "Not at all", 2: "A little bit", 3: "Moderately", 4: "Quite a bit", 5: "Extremely", DK/R: continue}
1121. SFR_R23: "The next questions are about how you felt and how things have been with you during the past 4 weeks." — Read — interviewer presses Enter to continue
1122. SFR_Q23: "During the past 4 weeks, how much of the time did you feel full of pep?" — Single select {1: "All of the time", 2: "Most of the time", 3: "A good bit of the time", 4: "Some of the time", 5: "A little of the time", 6: "None of the time", DK/R: continue}
1123. SFR_Q24: "During the past 4 weeks, how much of the time have you been a very nervous person?" — Single select {1: "All of the time", 2: "Most of the time", 3: "A good bit of the time", 4: "Some of the time", 5: "A little of the time", 6: "None of the time", DK/R: continue}
1124. SFR_Q25: "During the past 4 weeks, how much of the time have you felt so down in the dumps that nothing could cheer you up?" — Single select {1: "All of the time", 2: "Most of the time", 3: "A good bit of the time", 4: "Some of the time", 5: "A little of the time", 6: "None of the time", DK/R: continue}
1125. SFR_Q26: "During the past 4 weeks, how much of the time have you felt calm and peaceful?" — Single select {1: "All of the time", 2: "Most of the time", 3: "A good bit of the time", 4: "Some of the time", 5: "A little of the time", 6: "None of the time", DK/R: continue}
1126. SFR_Q27: "During the past 4 weeks, how much of the time did you have a lot of energy?" — Single select {1: "All of the time", 2: "Most of the time", 3: "A good bit of the time", 4: "Some of the time", 5: "A little of the time", 6: "None of the time", DK/R: continue}
1127. SFR_Q28: "During the past 4 weeks, how much of the time have you felt downhearted and blue?" — Single select {1: "All of the time", 2: "Most of the time", 3: "A good bit of the time", 4: "Some of the time", 5: "A little of the time", 6: "None of the time", DK/R: continue}
1128. SFR_Q29: "During the past 4 weeks, how much of the time did you feel worn out?" — Single select {1: "All of the time", 2: "Most of the time", 3: "A good bit of the time", 4: "Some of the time", 5: "A little of the time", 6: "None of the time", DK/R: continue}
1129. SFR_Q30: "During the past 4 weeks, how much of the time have you been a happy person?" — Single select {1: "All of the time", 2: "Most of the time", 3: "A good bit of the time", 4: "Some of the time", 5: "A little of the time", 6: "None of the time", DK/R: continue}
1130. SFR_Q31: "During the past 4 weeks, how much of the time did you feel tired?" — Single select {1: "All of the time", 2: "Most of the time", 3: "A good bit of the time", 4: "Some of the time", 5: "A little of the time", 6: "None of the time", DK/R: continue}
1131. SFR_Q32: "During the past 4 weeks, how much of the time has your health limited your social activities (such as visiting with friends or close relatives)?" — Single select {1: "All of the time", 2: "Most of the time", 3: "A good bit of the time", 4: "Some of the time", 5: "A little of the time", 6: "None of the time", DK/R: continue}
1132. SFR_Q33: "I/FNAME seem/seems to get sick a little easier than other people. How true or false is this for you?" — Single select {1: "Definitely true", 2: "Mostly true", 3: "Not sure", 4: "Mostly false", 5: "Definitely false", DK/R: continue}
1133. SFR_Q34: "I/FNAME am/is as healthy as anybody I/he/she know/knows. How true or false is this for you?" — Single select {1: "Definitely true", 2: "Mostly true", 3: "Not sure", 4: "Mostly false", 5: "Definitely false", DK/R: continue}
1134. SFR_Q35: "I/FNAME expect/expects my/his/her health to get worse. How true or false is this for you?" — Single select {1: "Definitely true", 2: "Mostly true", 3: "Not sure", 4: "Mostly false", 5: "Definitely false", DK/R: continue}
1135. SFR_Q36: "My/FNAME's health is excellent. How true or false is this for you?" — Single select {1: "Definitely true", 2: "Mostly true", 3: "Not sure", 4: "Mostly false", 5: "Definitely false", DK/R: continue}

---

### Section: SXB - Sexual Behaviours - 23 items

1136. SXB_C01A: Filter — if do SXB block = 1 go to SXB_C01B, otherwise go to SXB_END — Filter
1137. SXB_C01B: Filter — if proxy interview or age < 15 or > 49 go to SXB_END, otherwise go to SXB_R01 — Filter
1138. SXB_R01: "I would like to ask you a few questions about sexual behaviour…" — Read — interviewer presses Enter to continue
1139. SXB_Q01: "Have you ever had sexual intercourse?" — Yes/No {1: "Yes", 2: "No" → Go to SXB_END, DK/R → Go to SXB_END}
1140. SXB_Q02: "How old were you the first time?" — Numeric (min 1, max current age, warning below 12) — DK/R → Go to SXB_END
1141. SXB_E02: Constraint — hard edit: trigger if SXB_Q02 < 1 or SXB_Q02 > current age — postcondition
1142. SXB_Q03: "In the past 12 months, have you had sexual intercourse?" — Yes/No {1: "Yes", 2: "No" → Go to SXB_Q07, DK/R → Go to SXB_END}
1143. SXB_Q04: "With how many different partners?" — Single select {1: "1 partner", 2: "2 partners", 3: "3 partners", 4: "4 or more partners", DK: continue, R → Go to SXB_END}
1144. SXB_Q07: "Have you ever been diagnosed with a sexually transmitted disease?" — Yes/No {1: "Yes", 2: "No", DK/R: continue}
1145. SXB_C08A: Filter — if SXB_Q03 = 1 go to SXB_C08C, otherwise go to SXB_END — Filter
1146. SXB_C08C: Filter — if marital status = 1 (married) or 2 (common-law) and SXB_Q04 = 1 (one partner) go to SXB_C09B, otherwise go to SXB_Q08 — Filter
1147. SXB_Q08: "Did you use a condom the last time you had sexual intercourse?" — Yes/No {1: "Yes", 2: "No", DK/R: continue}
1148. SXB_C09B: Filter — if age > 24 go to SXB_END, otherwise go to SXB_R9A — Filter
1149. SXB_R9A: "Now a few questions about birth control." — Read — interviewer presses Enter to continue
1150. SXB_C09C: Filter — if sex = female go to SXB_C09D, otherwise go to SXB_R10 — Filter
1151. SXB_C09D: Filter — if MAM_Q037 = 1 (currently pregnant) go to SXB_Q11, otherwise go to SXB_R9B — Filter
1152. SXB_R9B: "I'm going to read you a statement about pregnancy. Please tell me if you strongly agree, agree, neither agree nor disagree, disagree, or strongly disagree." — Read — interviewer presses Enter to continue
1153. SXB_Q09: "It is important to me to avoid getting pregnant right now." — Single select {1: "Strongly agree" → Go to SXB_Q11, 2: "Agree" → Go to SXB_Q11, 3: "Neither agree nor disagree" → Go to SXB_Q11, 4: "Disagree" → Go to SXB_Q11, 5: "Strongly disagree" → Go to SXB_Q11, DK → Go to SXB_Q11, R → Go to SXB_END}
1154. SXB_R10: "I'm going to read you a statement about pregnancy. Please tell me if you strongly agree, agree, neither agree nor disagree, disagree, or strongly disagree." — Read — interviewer presses Enter to continue
1155. SXB_Q10: "It is important to me to avoid getting my partner pregnant right now." — Single select {1: "Strongly agree", 2: "Agree", 3: "Neither agree nor disagree", 4: "Disagree", 5: "Strongly disagree", 6: "Doesn't have a partner right now", DK: continue, R → Go to SXB_END}
1156. SXB_Q11: "In the past 12 months, did you and your partner usually use birth control?" — Yes/No {1: "Yes" → Go to SXB_Q12, 2: "No" → Go to SXB_END, DK/R → Go to SXB_END}
1157. SXB_Q12: "What kind of birth control did you and your partner usually use?" — Multi select {1: "Condom (male or female condom)" [SXBE_12A], 2: "Birth control pill" [SXBE_12B], 3: "Diaphragm" [SXBE_12C], 4: "Spermicide (e.g., foam, jelly, film)" [SXBE_12D], 5: "Birth control injection (Deprovera)" [SXBE_12F], 6: "Other - Specify" [SXBE_12E], DK/R → Go to SXB_END}
1158. SXB_C12S: Filter — if SXB_Q12 = 6 go to SXB_Q12S, otherwise go to SXB_C13 — Filter
1159. SXB_Q12S: "Specify other birth control method usually used." — Text (80 chars) — DK/R: continue
1160. SXB_C13: Filter — if MAM_Q037 = 1 (currently pregnant) go to SXB_END, otherwise go to SXB_Q13 — Filter
1161. SXB_Q13: "What kind of birth control did you and your partner use the last time you had sex?" — Multi select {1: "Condom (male or female condom)" [SXBE_13A], 2: "Birth control pill" [SXBE_13B], 3: "Diaphragm" [SXBE_13C], 4: "Spermicide (e.g., foam, jelly, film)" [SXBE_13D], 5: "Birth control injection (Deprovera)" [SXBE_13F], 6: "Nothing" [SXBE_13G], 7: "Other - Specify" [SXBE_13E], DK/R → Go to SXB_END}
1162. SXB_C13S: Filter — if SXB_Q13 = 7 go to SXB_Q13S, otherwise go to SXB_END — Filter
1163. SXB_Q13S: "Specify other birth control method used last time." — Text (80 chars) — DK/R: continue

---

### Section: ACC - Accessibility to Health Care - 68 items

1164. ACC_C1: Filter — if do ACC block = 1 go to ACC_C2, otherwise go to ACC_END — Filter
1165. ACC_C2: Filter — if proxy interview or age < 15 go to ACC_END, otherwise go to ACC_QINT10 — Filter
1166. ACC_QINT10: "The next questions are about the use of various health care services. I will start by asking about your experiences getting health care from a medical specialist…" — Read — interviewer presses Enter to continue
1167. ACC_Q10: "In the past 12 months, did you require a visit to a medical specialist for a diagnosis or a consultation?" — Yes/No {1: "Yes", 2: "No" → Go to ACC_QINT20, DK/R → Go to ACC_QINT20}
1168. ACC_Q11: "In the past 12 months, did you ever experience any difficulties getting the specialist care you needed for a diagnosis or consultation?" — Yes/No {1: "Yes", 2: "No" → Go to ACC_QINT20, DK/R → Go to ACC_QINT20}
1169. ACC_Q12: "What type of difficulties did you experience?" — Multi select {1: "Difficulty getting a referral" [ACCE_12A], 2: "Difficulty getting an appointment" [ACCE_12B], 3: "No specialists in the area" [ACCE_12C], 4: "Waited too long - between booking appointment and visit" [ACCE_12D], 5: "Waited too long - to see the doctor (i.e. in-office waiting)" [ACCE_12E], 6: "Transportation - problems" [ACCE_12F], 7: "Language - problem" [ACCE_12G], 8: "Cost" [ACCE_12H], 9: "Personal or family responsibilities" [ACCE_12I], 10: "General deterioration of health" [ACCE_12J], 11: "Appointment cancelled or deferred by specialist" [ACCE_12K], 12: "Still waiting for visit" [ACCE_12L], 13: "Unable to leave the house because of a health problem" [ACCE_12M], 14: "Other - Specify" [ACCE_12N], DK/R: continue}
1170. ACC_C12S: Filter — if ACC_Q12 = 14 go to ACC_Q12S, otherwise go to ACC_QINT20 — Filter
1171. ACC_Q12S: "Specify other difficulty getting specialist care." — Text (80 chars) — DK/R: continue
1172. ACC_QINT20: "The following questions are about any surgery not provided in an emergency…" — Read — interviewer presses Enter to continue
1173. ACC_Q20: "In the past 12 months, did you require any non-emergency surgery?" — Yes/No {1: "Yes", 2: "No" → Go to ACC_QINT30, DK/R → Go to ACC_QINT30}
1174. ACC_Q21: "In the past 12 months, did you ever experience any difficulties getting the surgery you needed?" — Yes/No {1: "Yes", 2: "No" → Go to ACC_QINT30, DK/R → Go to ACC_QINT30}
1175. ACC_Q22: "What type of difficulties did you experience?" — Multi select {1: "Difficulty getting an appointment with a surgeon" [ACCE_22A], 2: "Difficulty getting a diagnosis" [ACCE_22B], 3: "Waited too long - for a diagnostic test" [ACCE_22C], 4: "Waited too long - for a hospital bed to become available" [ACCE_22D], 5: "Waited too long - for surgery" [ACCE_22E], 6: "Service not available - in the area" [ACCE_22F], 7: "Transportation - problems" [ACCE_22G], 8: "Language - problem" [ACCE_22H], 9: "Cost" [ACCE_22I], 10: "Personal or family responsibilities" [ACCE_22J], 11: "General deterioration of health" [ACCE_22K], 12: "Appointment cancelled or deferred by surgeon or hospital" [ACCE_22L], 13: "Still waiting for surgery" [ACCE_22M], 14: "Unable to leave the house because of a health problem" [ACCE_22N], 15: "Other - Specify" [ACCE_22O], DK/R: continue}
1176. ACC_C22S: Filter — if ACC_Q22 = 15 go to ACC_Q22S, otherwise go to ACC_QINT30 — Filter
1177. ACC_Q22S: "Specify other difficulty getting surgery." — Text (80 chars) — DK/R: continue
1178. ACC_QINT30: "Now some questions about MRIs, CAT Scans and angiographies provided in a non-emergency situation." — Read — interviewer presses Enter to continue
1179. ACC_Q30: "In the past 12 months, did you require one of these tests?" — Yes/No {1: "Yes", 2: "No" → Go to ACC_QINT40, DK/R → Go to ACC_QINT40}
1180. ACC_Q31: "In the past 12 months, did you ever experience any difficulties getting the tests you needed?" — Yes/No {1: "Yes", 2: "No" → Go to ACC_QINT40, DK/R → Go to ACC_QINT40}
1181. ACC_Q32: "What type of difficulties did you experience?" — Multi select {1: "Difficulty getting a referral" [ACCE_32A], 2: "Difficulty getting an appointment" [ACCE_32B], 3: "Waited too long - to get an appointment" [ACCE_32C], 4: "Waited too long - to get test (i.e. in-office waiting)" [ACCE_32D], 5: "Service not available - at time required" [ACCE_32E], 6: "Service not available - in the area" [ACCE_32F], 7: "Transportation - problems" [ACCE_32G], 8: "Language - problem" [ACCE_32H], 9: "Cost" [ACCE_32I], 10: "General deterioration of health" [ACCE_32J], 11: "Did not know where to go (i.e. information problems)" [ACCE_32K], 12: "Still waiting for test" [ACCE_32L], 13: "Unable to leave the house because of a health problem" [ACCE_32M], 14: "Other - Specify" [ACCE_32N], DK/R: continue}
1182. ACC_C32S: Filter — if ACC_Q32 = 14 go to ACC_Q32S, otherwise go to ACC_QINT40 — Filter
1183. ACC_Q32S: "Specify other difficulty getting diagnostic test." — Text (80 chars) — DK/R: continue
1184. ACC_QINT40: "Now I'd like you to think about yourself and family members living in your dwelling. The next questions are about your experiences getting health information or advice…" — Read — interviewer presses Enter to continue
1185. ACC_Q40: "In the past 12 months, have you required health information or advice for yourself or a family member?" — Yes/No {1: "Yes", 2: "No" → Go to ACC_QINT50, DK/R → Go to ACC_QINT50}
1186. ACC_Q40A: "Who did you contact when you needed health information or advice for yourself or a family member?" — Multi select {1: "Doctor's office" [ACCE_40A], 2: "Community health centre / CLSC" [ACCE_40B], 3: "Walk-in clinic" [ACCE_40C], 4: "Telephone health line" [ACCE_40D], 5: "Hospital emergency room" [ACCE_40E], 6: "Other hospital service" [ACCE_40F], 7: "Other - Specify" [ACCE_40G]}
1187. ACC_C40AS: Filter — if ACC_Q40A = 7 go to ACC_Q40AS, otherwise go to ACC_Q41 — Filter
1188. ACC_Q40AS: "Specify other contact for health information or advice." — Text (80 chars) — DK/R: continue
1189. ACC_Q41: "In the past 12 months, did you ever experience any difficulties getting the health information or advice you needed for yourself or a family member?" — Yes/No {1: "Yes", 2: "No" → Go to ACC_QINT50, DK/R → Go to ACC_QINT50}
1190. ACC_Q42: "Did you experience difficulties during 'regular' office hours (that is, 9:00 am to 5:00 pm, Monday to Friday)?" — Single select {1: "Yes", 2: "No" → Go to ACC_Q44, 3: "Not required at this time" → Go to ACC_Q44, DK/R → Go to ACC_Q44}
1191. ACC_Q43: "What type of difficulties did you experience during regular office hours?" — Multi select {1: "Difficulty contacting a physician or nurse" [ACCE_43A], 2: "Did not have a phone number" [ACCE_43B], 3: "Could not get through (i.e. no answer)" [ACCE_43C], 4: "Waited too long to speak to someone" [ACCE_43D], 5: "Did not get adequate info or advice" [ACCE_43E], 6: "Language - problem" [ACCE_43F], 7: "Did not know where to go / call / uninformed" [ACCE_43G], 8: "Unable to leave the house because of a health problem" [ACCE_43H], 9: "Other - Specify" [ACCE_43I], DK/R: continue}
1192. ACC_C43S: Filter — if ACC_Q43 = 9 go to ACC_Q43S, otherwise go to ACC_Q44 — Filter
1193. ACC_Q43S: "Specify other difficulty during regular hours." — Text (80 chars) — DK/R: continue
1194. ACC_Q44: "Did you experience difficulties getting health information or advice during evenings and weekends (that is, 5:00 to 9:00 pm Monday to Friday, or 9:00 am to 5:00 pm, Saturdays and Sundays)?" — Single select {1: "Yes", 2: "No" → Go to ACC_Q46, 3: "Not required at this time" → Go to ACC_Q46, DK/R → Go to ACC_Q46}
1195. ACC_Q45: "What type of difficulties did you experience during evenings and weekends?" — Multi select {1: "Difficulty contacting a physician or nurse" [ACCE_45A], 2: "Did not have a phone number" [ACCE_45B], 3: "Could not get through (i.e. no answer)" [ACCE_45C], 4: "Waited too long to speak to someone" [ACCE_45D], 5: "Did not get adequate info or advice" [ACCE_45E], 6: "Language - problem" [ACCE_45F], 7: "Did not know where to go / call / uninformed" [ACCE_45G], 8: "Unable to leave the house because of a health problem" [ACCE_45H], 9: "Other - Specify" [ACCE_45I], DK/R: continue}
1196. ACC_C45S: Filter — if ACC_Q45 = 9 go to ACC_Q45S, otherwise go to ACC_Q46 — Filter
1197. ACC_Q45S: "Specify other difficulty during evenings and weekends." — Text (80 chars) — DK/R: continue
1198. ACC_Q46: "Did you experience difficulties getting health information or advice during the middle of the night?" — Single select {1: "Yes", 2: "No" → Go to ACC_QINT50, 3: "Not required at this time" → Go to ACC_QINT50, DK/R → Go to ACC_QINT50}
1199. ACC_Q47: "What type of difficulties did you experience during the middle of the night?" — Multi select {1: "Difficulty contacting a physician or nurse" [ACCE_47A], 2: "Did not have a phone number" [ACCE_47B], 3: "Could not get through (i.e. no answer)" [ACCE_47C], 4: "Waited too long to speak to someone" [ACCE_47D], 5: "Did not get adequate info or advice" [ACCE_47E], 6: "Language - problem" [ACCE_47F], 7: "Did not know where to go / call / uninformed" [ACCE_47G], 8: "Unable to leave the house because of a health problem" [ACCE_47H], 9: "Other - Specify" [ACCE_47I], DK/R: continue}
1200. ACC_C47S: Filter — if ACC_Q47 = 9 go to ACC_Q47S, otherwise go to ACC_QINT50 — Filter
1201. ACC_Q47S: "Specify other difficulty during the middle of the night (health info)." — Text (80 chars) — DK/R: continue
1202. ACC_QINT50: "Now some questions about your experiences when you needed health care services for routine or on-going care…" — Read — interviewer presses Enter to continue
1203. ACC_Q50A: "Do you have a regular family doctor?" — Yes/No {1: "Yes", 2: "No", DK/R: continue}
1204. ACC_Q50: "In the past 12 months, did you require any routine or on-going care for yourself or a family member?" — Yes/No {1: "Yes", 2: "No" → Go to ACC_QINT60, DK/R → Go to ACC_QINT60}
1205. ACC_Q51: "In the past 12 months, did you ever experience any difficulties getting the routine or on-going care you or a family member needed?" — Yes/No {1: "Yes", 2: "No" → Go to ACC_QINT60, DK/R → Go to ACC_QINT60}
1206. ACC_Q52: "Did you experience difficulties getting such care during 'regular' office hours (that is, 9:00 am to 5:00 pm, Monday to Friday)?" — Single select {1: "Yes", 2: "No" → Go to ACC_Q54, 3: "Not required at this time" → Go to ACC_Q54, DK/R → Go to ACC_Q54}
1207. ACC_Q53: "What type of difficulties did you experience during regular hours (routine/ongoing care)?" — Multi select {1: "Difficulty contacting a physician" [ACCE_53A], 2: "Difficulty getting an appointment" [ACCE_53B], 3: "Do not have personal / family physician" [ACCE_53C], 4: "Waited too long - to get an appointment" [ACCE_53D], 5: "Waited too long - to see the doctor (i.e. in-office waiting)" [ACCE_53E], 6: "Service not available - at time required" [ACCE_53F], 7: "Service not available - in the area" [ACCE_53G], 8: "Transportation - problems" [ACCE_53H], 9: "Language - problem" [ACCE_53I], 10: "Cost" [ACCE_53J], 11: "Did not know where to go (i.e. information problems)" [ACCE_53K], 12: "Unable to leave the house because of a health problem" [ACCE_53L], 13: "Other - Specify" [ACCE_53M], DK/R: continue}
1208. ACC_C53S: Filter — if ACC_Q53 = 13 go to ACC_Q53S, otherwise go to ACC_Q54 — Filter
1209. ACC_Q53S: "Specify other difficulty during regular hours (routine care)." — Text (80 chars) — DK/R: continue
1210. ACC_Q54: "Did you experience difficulties getting such care during evenings and weekends (that is, 5:00 to 9:00 pm, Monday to Friday or 9:00 am to 5:00 pm, Saturdays and Sundays)?" — Single select {1: "Yes", 2: "No" → Go to ACC_QINT60, 3: "Not required at this time" → Go to ACC_QINT60, DK/R → Go to ACC_QINT60}
1211. ACC_Q55: "What type of difficulties did you experience during evenings and weekends (routine/ongoing care)?" — Multi select {1: "Difficulty contacting a physician" [ACCE_55A], 2: "Difficulty getting an appointment" [ACCE_55B], 3: "Do not have personal / family physician" [ACCE_55C], 4: "Waited too long - to get an appointment" [ACCE_55D], 5: "Waited too long - to see the doctor (i.e. in-office waiting)" [ACCE_55E], 6: "Service not available - at time required" [ACCE_55F], 7: "Service not available - in the area" [ACCE_55G], 8: "Transportation - problems" [ACCE_55H], 9: "Language - problem" [ACCE_55I], 10: "Cost" [ACCE_55J], 11: "Did not know where to go (i.e. information problems)" [ACCE_55K], 12: "Unable to leave the house because of a health problem" [ACCE_55L], 13: "Other - Specify" [ACCE_55M], DK/R: continue}
1212. ACC_C55S: Filter — if ACC_Q55 = 13 go to ACC_Q55S, otherwise go to ACC_QINT60 — Filter
1213. ACC_Q55S: "Specify other difficulty during evenings and weekends (routine care)." — Text (80 chars) — DK/R: continue
1214. ACC_QINT60: "The next questions are about situations when you or a family member have needed immediate care for a minor health problem…" — Read — interviewer presses Enter to continue
1215. ACC_Q60: "In the past 12 months, have you or a family member required immediate health care services for a minor health problem?" — Yes/No {1: "Yes", 2: "No" → Go to ACC_END, DK/R → Go to ACC_END}
1216. ACC_Q61: "In the past 12 months, did you ever experience any difficulties getting the immediate care needed for a minor health problem for yourself or a family member?" — Yes/No {1: "Yes", 2: "No" → Go to ACC_END, DK/R → Go to ACC_END}
1217. ACC_Q62: "Did you experience difficulties getting such care during 'regular' office hours (that is, 9:00 am to 5:00 pm, Monday to Friday)?" — Single select {1: "Yes", 2: "No" → Go to ACC_Q64, 3: "Not required at this time" → Go to ACC_Q64, DK/R → Go to ACC_Q64}
1218. ACC_Q63: "What type of difficulties did you experience during regular hours (immediate/minor care)?" — Multi select {1: "Difficulty contacting a physician" [ACCE_63A], 2: "Difficulty getting an appointment" [ACCE_63B], 3: "Do not have personal / family physician" [ACCE_63C], 4: "Waited too long - to get an appointment" [ACCE_63D], 5: "Waited too long - to see the doctor (i.e. in-office waiting)" [ACCE_63E], 6: "Service not available - at time required" [ACCE_63F], 7: "Service not available - in the area" [ACCE_63G], 8: "Transportation - problems" [ACCE_63H], 9: "Language - problem" [ACCE_63I], 10: "Cost" [ACCE_63J], 11: "Did not know where to go (i.e. information problems)" [ACCE_63K], 12: "Unable to leave the house because of a health problem" [ACCE_63L], 13: "Other - Specify" [ACCE_63M], DK/R: continue}
1219. ACC_C63S: Filter — if ACC_Q63 = 13 go to ACC_Q63S, otherwise go to ACC_Q64 — Filter
1220. ACC_Q63S: "Specify other difficulty during regular hours (immediate care)." — Text (80 chars) — DK/R: continue
1221. ACC_Q64: "Did you experience difficulties getting such care during evenings and weekends (that is, 5:00 to 9:00 pm, Monday to Friday or 9:00 am to 5:00 pm, Saturdays and Sundays)?" — Single select {1: "Yes", 2: "No" → Go to ACC_Q66, 3: "Not required at this time" → Go to ACC_Q66, DK/R → Go to ACC_Q66}
1222. ACC_Q65: "What type of difficulties did you experience during evenings and weekends (immediate/minor care)?" — Multi select {1: "Difficulty contacting a physician" [ACCE_65A], 2: "Difficulty getting an appointment" [ACCE_65B], 3: "Do not have personal / family physician" [ACCE_65C], 4: "Waited too long - to get an appointment" [ACCE_65D], 5: "Waited too long - to see the doctor (i.e. in-office waiting)" [ACCE_65E], 6: "Service not available - at time required" [ACCE_65F], 7: "Service not available - in the area" [ACCE_65G], 8: "Transportation - problems" [ACCE_65H], 9: "Language - problem" [ACCE_65I], 10: "Cost" [ACCE_65J], 11: "Did not know where to go (i.e. information problems)" [ACCE_65K], 12: "Unable to leave the house because of a health problem" [ACCE_65L], 13: "Other - Specify" [ACCE_65M], DK/R: continue}
1223. ACC_C65S: Filter — if ACC_Q65 = 13 go to ACC_Q65S, otherwise go to ACC_Q66 — Filter
1224. ACC_Q65S: "Specify other difficulty during evenings and weekends (immediate care)." — Text (80 chars) — DK/R: continue
1225. ACC_Q66: "Did you experience difficulties getting such care during the middle of the night?" — Single select {1: "Yes", 2: "No" → Go to ACC_END, 3: "Not required at this time" → Go to ACC_END, DK/R → Go to ACC_END}
1226. ACC_Q67: "What type of difficulties did you experience during the middle of the night (immediate/minor care)?" — Multi select {1: "Difficulty contacting a physician" [ACCE_67A], 2: "Difficulty getting an appointment" [ACCE_67B], 3: "Do not have personal / family physician" [ACCE_67C], 4: "Waited too long - to get an appointment" [ACCE_67D], 5: "Waited too long - to see the doctor (i.e. in-office waiting)" [ACCE_67E], 6: "Service not available - at time required" [ACCE_67F], 7: "Service not available - in the area" [ACCE_67G], 8: "Transportation - problems" [ACCE_67H], 9: "Language - problem" [ACCE_67I], 10: "Cost" [ACCE_67J], 11: "Did not know where to go (i.e. information problems)" [ACCE_67K], 12: "Unable to leave the house because of a health problem" [ACCE_67L], 13: "Other - Specify" [ACCE_67M], DK/R: continue}
1227. ACC_C67S: Filter — if ACC_Q67 = 13 go to ACC_Q67S, otherwise go to ACC_END — Filter
1228. ACC_Q67S: "Specify other difficulty during the middle of the night (immediate care)." — Text (80 chars) — DK/R: continue

---

Note: The section at lines 9700–9995 uses the prefix **HUI** (Health Utilities Index), not "HIU". The user's label "HIU (Health Information Use)" does not match what is in this range of the file. The inventory above faithfully reflects what appears in the source document.

### Section: WTM - Waiting Times Module - 66 items

1229. WTM_C01: Filter — If (do WTM block = 1) → WTM_C02; otherwise → WTM_END — Filter
1230. WTM_C02: Filter — If proxy interview or age < 15 → WTM_END; otherwise → WTM_C03 — Filter
1231. WTM_C03: Filter — If ACC_Q10=2 AND ACC_Q20=2 AND ACC_Q30=2 → WTM_END; otherwise → WTM_QINT — Filter
1232. WTM_QINT: "Now some additional questions about your experiences waiting for health care services." — Read — interviewer press Enter to continue
1233. WTM_C04: Filter — If ACC_Q10=2 → WTM_C16; otherwise → WTM_Q01 — Filter
1234. WTM_Q01: "In the past 12 months, did you require a visit to a medical specialist for a diagnosis or a consultation for a new illness or condition?" — Yes/No {1: "Yes", 2: "No → WTM_C16", DK/R → WTM_C16}
1235. WTM_Q02: "For what type of condition?" — Single select {1: "Heart condition or stroke", 2: "Cancer", 3: "Asthma or other breathing conditions", 4: "Arthritis or rheumatism", 5: "Cataract or other eye conditions", 6: "Mental health disorder", 7: "Skin conditions", 8: "Gynaecological problems/blank", 9: "Other – Specify", DK/R}
1236. WTM_E02: Constraint — Hard edit if WTM_Q02=8 and sex=male — postcondition
1237. WTM_C02S: Filter — If WTM_Q02=9 → WTM_Q02S; otherwise → WTM_Q03 — Filter
1238. WTM_Q02S: "INTERVIEWER: Specify." — Text (80 chars) — specify for WTM_Q02=9
1239. WTM_Q03: "Were you referred by:" — Single select {1: "a family doctor", 2: "another specialist", 3: "another health care provider", 4: "Did not require a referral", DK/R}
1240. WTM_Q04: "Have you already visited the medical specialist?" — Yes/No {1: "Yes", 2: "No → WTM_Q08A", DK/R → WTM_Q08A}
1241. WTM_Q05: "Thinking about this visit, did you experience any difficulties seeing the specialist?" — Yes/No {1: "Yes", 2: "No → WTM_Q07A", DK/R → WTM_Q07A}
1242. WTM_Q06: "What type of difficulties did you experience?" — Multi select {1: "Difficulty getting a referral", 2: "Difficulty getting an appointment", 3: "No specialists in the area", 4: "Waited too long - between booking appointment and visit", 5: "Waited too long - to see the doctor (in-office waiting)", 6: "Transportation – problems", 7: "Language – problem", 8: "Cost", 9: "Personal or family responsibilities", 10: "General deterioration of health", 11: "Appointment cancelled or deferred by specialist", 12: "Unable to leave the house because of a health problem", 13: "Other – Specify", DK/R}
1243. WTM_C06S: Filter — If WTM_Q06=13 → WTM_Q06S; otherwise → WTM_Q07A — Filter
1244. WTM_Q06S: "INTERVIEWER: Specify." — Text (80 chars)
1245. WTM_Q07A: "How long did you have to wait between when [you and your doctor/health care provider decided you should see a specialist / the appointment was initially scheduled] and when you actually visited the specialist?" — Numeric (1–365) {DK/R → WTM_Q10}
1246. WTM_N07B: "INTERVIEWER: Enter unit of time." — Single select {1: "Days", 2: "Weeks", 3: "Months"} — DK/R not allowed; → WTM_Q10
1247. WTM_E07B: Constraint — Soft edit if (WTM_Q07A>31 and WTM_N07B=1) or (WTM_Q07A>12 and WTM_N07B=2) or (WTM_Q07A>18 and WTM_N07B=3) — postcondition
1248. WTM_Q08A: "How long have you been waiting since [you and your doctor/health care provider decided you should see a specialist / the appointment was initially scheduled]?" — Numeric (1–365) {DK/R → WTM_Q10}
1249. WTM_N08B: "INTERVIEWER: Enter unit of time." — Single select {1: "Days", 2: "Weeks", 3: "Months"} — DK/R not allowed
1250. WTM_E08B: Constraint — Soft edit if (WTM_Q08A>31 and WTM_N08B=1) or (WTM_Q08A>12 and WTM_N08B=2) or (WTM_Q08A>18 and WTM_N08B=3) — postcondition
1251. WTM_Q10: "In your view, [was the waiting time / has the waiting time been]:" — Single select {1: "acceptable → WTM_Q12", 2: "not acceptable", 3: "No view", DK/R}
1252. WTM_Q11A: "In this particular case, what do you think is an acceptable waiting time?" — Numeric (1–365) {DK/R → WTM_Q12}
1253. WTM_N11B: "INTERVIEWER: Enter unit of time." — Single select {1: "Days", 2: "Weeks", 3: "Months"} — DK/R not allowed
1254. WTM_E11B: Constraint — Soft edit if (WTM_Q11A>31 and WTM_N11B=1) or (WTM_Q11A>12 and WTM_N11B=2) or (WTM_Q11A>18 and WTM_N11B=3) — postcondition
1255. WTM_Q12: "Was your visit cancelled or postponed at any time?" — Yes/No {1: "Yes", 2: "No → WTM_Q14", DK/R → WTM_Q14}
1256. WTM_Q13: "Was it cancelled or postponed by:" — Multi select {1: "yourself", 2: "the specialist", 3: "Other - Specify", DK/R}
1257. WTM_C13S: Filter — If WTM_Q13=3 → WTM_Q13S; otherwise → WTM_Q14 — Filter
1258. WTM_Q13S: "INTERVIEWER: Specify." — Text (80 chars)
1259. WTM_Q14: "Do you think that your health, or other aspects of your life, have been affected in any way because you had to wait for this visit?" — Yes/No {1: "Yes", 2: "No → WTM_C16", DK/R → WTM_C16}
1260. WTM_Q15: "How was your life affected as a result of waiting for this visit?" — Multi select {1: "Worry, anxiety, stress", 2: "Worry or stress for family or friends", 3: "Pain", 4: "Problems with activities of daily living", 5: "Loss of work", 6: "Loss of income", 7: "Increased dependence on relatives/friends", 8: "Increased use of over-the-counter drugs", 9: "Overall health deteriorated, condition got worse", 10: "Health problem improved", 11: "Personal relationships suffered", 12: "Other - Specify", DK/R}
1261. WTM_C15S: Filter — If WTM_Q15=12 → WTM_Q15S; otherwise → WTM_C16 — Filter
1262. WTM_Q15S: "INTERVIEWER: Specify." — Text (80 chars)
1263. WTM_C16: Filter — If ACC_Q20=2 → WTM_C30; otherwise → WTM_Q16 — Filter
1264. WTM_Q16: "What type of surgery did you require?" — Single select {1: "Cardiac surgery", 2: "Cancer related surgery", 3: "Hip or knee replacement surgery", 4: "Cataract or other eye surgery", 5: "Hysterectomy/blank", 6: "Removal of gall bladder", 7: "Other - Specify", DK/R}
1265. WTM_E16: Constraint — Hard edit if WTM_Q16=5 and sex=male — postcondition
1266. WTM_C16S: Filter — If WTM_Q16=7 → WTM_Q16S; otherwise → WTM_Q17 — Filter
1267. WTM_Q16S: "INTERVIEWER: Specify." — Text (80 chars)
1268. WTM_Q17: "Did you already have this surgery?" — Yes/No {1: "Yes", 2: "No → WTM_Q22", DK/R → WTM_Q22}
1269. WTM_Q18: "Did the surgery require an overnight hospital stay?" — Yes/No {1: "Yes", 2: "No", DK/R}
1270. WTM_Q19: "Did you experience any difficulties getting this surgery?" — Yes/No {1: "Yes", 2: "No → WTM_Q21A", DK/R → WTM_Q21A}
1271. WTM_Q20: "What type of difficulties did you experience?" — Multi select {1: "Difficulty getting an appointment with a surgeon", 2: "Difficulty getting a diagnosis", 3: "Waited too long - for a diagnostic test", 4: "Waited too long - for a hospital bed to become available", 5: "Waited too long - for surgery", 6: "Service not available - in the area", 7: "Transportation - problems", 8: "Language - problem", 9: "Cost", 10: "Personal or family responsibilities", 11: "General deterioration of health", 12: "Appointment cancelled or deferred by surgeon or hospital", 13: "Unable to leave the house because of a health problem", 14: "Other - Specify", DK/R}
1272. WTM_C20S: Filter — If WTM_Q20=14 → WTM_Q20S; otherwise → WTM_Q21A — Filter
1273. WTM_Q20S: "INTERVIEWER: Specify." — Text (80 chars)
1274. WTM_Q21A: "How long did you have to wait between when you and the surgeon decided to go ahead with surgery and the day of surgery?" — Numeric (1–365) {DK/R → WTM_Q24}; → WTM_C24
1275. WTM_N21B: "INTERVIEWER: Enter unit of time." — Single select {1: "Days", 2: "Weeks", 3: "Months"} — DK/R not allowed
1276. WTM_E21B: Constraint — Soft edit if (WTM_Q21A>31 and WTM_N21B=1) or (WTM_Q21A>12 and WTM_N21B=2) or (WTM_Q21A>18 and WTM_N21B=3) — postcondition
1277. WTM_Q22: "Will the surgery require an overnight hospital stay?" — Yes/No {1: "Yes", 2: "No", DK/R}
1278. WTM_Q23A: "How long have you been waiting since you and the surgeon decided to go ahead with the surgery?" — Numeric (1–365) {DK/R → WTM_Q24}
1279. WTM_N23B: "INTERVIEWER: Enter unit of time." — Single select {1: "Days", 2: "Weeks", 3: "Months"} — DK/R not allowed
1280. WTM_E23B: Constraint — Soft edit if (WTM_Q23A>31 and WTM_N23B=1) or (WTM_Q23A>12 and WTM_N23B=2) or (WTM_Q23A>18 and WTM_N23B=3) — postcondition
1281. WTM_Q24: "In your view, [was the waiting time / has the waiting time been]:" — Single select {1: "acceptable → WTM_Q26", 2: "not acceptable", 3: "No view", DK/R}
1282. WTM_Q25A: "In this particular case, what do you think is an acceptable waiting time?" — Numeric (1–365) {DK/R → WTM_Q26}
1283. WTM_N25B: "INTERVIEWER: Enter unit of time." — Single select {1: "Days", 2: "Weeks", 3: "Months"} — DK/R not allowed
1284. WTM_E25B: Constraint — Soft edit if (WTM_Q25A>31 and WTM_N25B=1) or (WTM_Q25A>12 and WTM_N25B=2) or (WTM_Q25A>18 and WTM_N25B=3) — postcondition
1285. WTM_Q26: "Was your surgery cancelled or postponed at any time?" — Yes/No {1: "Yes", 2: "No → WTM_Q28", DK/R → WTM_Q28}
1286. WTM_Q27: "Was it cancelled or postponed by:" — Multi select {1: "yourself", 2: "the surgeon", 3: "the hospital", 4: "Other - Specify", DK/R}
1287. WTM_C27S: Filter — If WTM_Q27=4 → WTM_Q27S; otherwise → WTM_Q28 — Filter
1288. WTM_Q27S: "INTERVIEWER: Specify." — Text (80 chars)
1289. WTM_Q28: "Do you think that your health, or other aspects of your life, have been affected in any way due to waiting for this surgery?" — Yes/No {1: "Yes", 2: "No → WTM_C30", DK/R → WTM_C30}
1290. WTM_Q29: "How was your life affected as a result of waiting for surgery?" — Multi select {1: "Worry, anxiety, stress", 2: "Worry or stress for family or friends", 3: "Pain", 4: "Problems with activities of daily living", 5: "Loss of work", 6: "Loss of income", 7: "Increased dependence on relatives/friends", 8: "Increased use of over-the-counter drugs", 9: "Overall health deteriorated, condition got worse", 10: "Health problem improved", 11: "Personal relationships suffered", 12: "Other - Specify", DK/R}
1291. WTM_C29S: Filter — If WTM_Q29=12 → WTM_Q29S; otherwise → WTM_C30 — Filter
1292. WTM_Q29S: "INTERVIEWER: Specify." — Text (80 chars)
1293. WTM_C30: Filter — If ACC_Q30=2 → WTM_END; otherwise → WTM_Q30 — Filter
1294. WTM_Q30: "What type of test did you require?" — Single select {1: "MRI", 2: "CAT Scan", 3: "Angiography", DK/R}
1295. WTM_Q31: "For what type of condition?" — Single select {1: "Heart disease or stroke", 2: "Cancer", 3: "Joints or fractures", 4: "Neurological or brain disorders", 5: "Other - Specify", DK/R}
1296. WTM_C31S: Filter — If WTM_Q31=5 → WTM_Q31S; otherwise → WTM_Q32 — Filter
1297. WTM_Q31S: "INTERVIEWER: Specify." — Text (80 chars)
1298. WTM_Q32: "Did you already have this test?" — Yes/No {1: "Yes", 2: "No → WTM_Q39A", DK/R → WTM_Q39A}
1299. WTM_Q33: "Where was the test done?" — Single select {1: "Hospital → WTM_Q35", 2: "Public clinic → WTM_Q35", 3: "Private clinic → WTM_Q34", 4: "Other - Specify → WTM_C33S", DK/R → WTM_Q36}
1300. WTM_C33S: Filter — If WTM_Q33=4 → WTM_Q33S; otherwise → WTM_Q34 — Filter
1301. WTM_Q33S: "INTERVIEWER: Specify." — Text (80 chars); → WTM_Q35
1302. WTM_Q34: "Was the clinic located:" — Single select {1: "in your province", 2: "in another province", 3: "Other – Specify", DK/R}
1303. WTM_C34S: Filter — If WTM_Q34=3 → WTM_Q34S; otherwise → WTM_Q35 — Filter
1304. WTM_Q34S: "INTERVIEWER: Specify." — Text (80 chars)
1305. WTM_Q35: "Were you a patient in a hospital at the time of the test?" — Yes/No {1: "Yes", 2: "No", DK/R}
1306. WTM_Q36: "Did you experience any difficulties getting this test?" — Yes/No {1: "Yes", 2: "No → WTM_Q38A", DK/R → WTM_Q38A}
1307. WTM_Q37: "What type of difficulties did you experience?" — Multi select {1: "Difficulty getting a referral", 2: "Difficulty getting an appointment", 3: "Waited too long - to get an appointment", 4: "Waited too long - to get test (in-office waiting)", 5: "Service not available - at time required", 6: "Service not available - in the area", 7: "Transportation - problems", 8: "Language - problem", 9: "Cost", 10: "General deterioration of health", 11: "Did not know where to go", 12: "Unable to leave the house because of a health problem", 13: "Other - Specify", DK/R}
1308. WTM_C37S: Filter — If WTM_Q37=13 → WTM_Q37S; otherwise → WTM_Q38A — Filter
1309. WTM_Q37S: "INTERVIEWER: Specify." — Text (80 chars)
1310. WTM_Q38A: "How long did you have to wait between when you and your doctor decided to go ahead with the test and the day of the test?" — Numeric (1–365) {DK/R → WTM_C40}; → WTM_C40
1311. WTM_N38B: "INTERVIEWER: Enter unit of time." — Single select {1: "Days", 2: "Weeks", 3: "Months"} — DK/R not allowed
1312. WTM_E38B: Constraint — Soft edit if (WTM_Q38A>31 and WTM_N38B=1) or (WTM_Q38A>12 and WTM_N38B=2) or (WTM_Q38A>18 and WTM_N38B=3) — postcondition
1313. WTM_Q39A: "How long have you been waiting for the test since you and your doctor decided to go ahead with the test?" — Numeric (1–365) {DK/R → WTM_C40}
1314. WTM_N39B: "INTERVIEWER: Enter unit of time." — Single select {1: "Days", 2: "Weeks", 3: "Months"} — DK/R not allowed
1315. WTM_E39B: Constraint — Soft edit if (WTM_Q39A>31 and WTM_N39B=1) or (WTM_Q39A>12 and WTM_N39B=2) or (WTM_Q39A>18 and WTM_N39B=3) — postcondition
1316. WTM_Q40: "In your view, [was the waiting time / has the waiting time been]:" — Single select {1: "acceptable → WTM_Q42", 2: "not acceptable", 3: "No view", DK/R}
1317. WTM_Q41A: "In this particular case, what do you think is an acceptable waiting time?" — Numeric (1–365) {DK/R → WTM_Q42}
1318. WTM_N41B: "INTERVIEWER: Enter unit of time." — Single select {1: "Days", 2: "Weeks", 3: "Months"} — DK/R not allowed
1319. WTM_E41B: Constraint — Soft edit if (WTM_Q41A>31 and WTM_N41B=1) or (WTM_Q41A>12 and WTM_N41B=2) or (WTM_Q41A>18 and WTM_N41B=3) — postcondition
1320. WTM_Q42: "Was your test cancelled or postponed at any time?" — Yes/No {1: "Yes", 2: "No → WTM_Q44", DK/R → WTM_Q44}
1321. WTM_Q43: "Was it cancelled or postponed by:" — Single select {1: "yourself", 2: "the specialist", 3: "the hospital", 4: "the clinic", 5: "Other - Specify", DK/R}
1322. WTM_C43S: Filter — If WTM_Q43=5 → WTM_Q43S; otherwise → WTM_Q44 — Filter
1323. WTM_Q43S: "INTERVIEWER: Specify." — Text (80 chars)
1324. WTM_Q44: "Do you think that your health, or other aspects of your life, have been affected in any way due to waiting for this test?" — Yes/No {1: "Yes", 2: "No → WTM_END", DK/R → WTM_END}
1325. WTM_Q45: "How was your life affected as a result of waiting for this test?" — Multi select {1: "Worry, anxiety, stress", 2: "Worry or stress for family or friends", 3: "Pain", 4: "Problems with activities of daily living", 5: "Loss of work", 6: "Loss of income", 7: "Increased dependence on relatives/friends", 8: "Increased use of over-the-counter drugs", 9: "Overall health deteriorated, condition got worse", 10: "Health problem improved", 11: "Personal relationships suffered", 12: "Other - Specify", DK/R}
1326. WTM_C45S: Filter — If WTM_Q45=12 → WTM_Q45S; otherwise → WTM_END — Filter
1327. WTM_Q45S: "INTERVIEWER: Specify." — Text (80 chars)

---

### Section: MHW - Measured Height and Weight - 30 items

1328. MHW_C01A: Filter — If (do MHW block=1) → MHW_C01B; otherwise → MHW_END — Filter
1329. MHW_C01B: Filter — If proxy interview → MHW_END; otherwise → MHW_C01C — Filter
1330. MHW_C01C: Filter — If area frame → MHW_N1A; otherwise → MHW_END — Filter
1331. MHW_N1A: "INTERVIEWER: Are there any reasons that make it impossible to measure the respondent's weight?" — Yes/No {1: "Yes", 2: "No → MHW_R2"} — DK/R not allowed
1332. MHW_N1B: "INTERVIEWER: Select reasons why it is impossible to measure the respondent's weight." — Multi select {1: "Unable to stand unassisted → MHW_END", 2: "In a wheel chair → MHW_END", 3: "Bedridden → MHW_END", 4: "Interview setting", 5: "Safety concerns", 6: "Has already refused to be measured", 7: "Other – Specify"} — DK/R not allowed
1333. MHW_C1C: Filter — If MHW_N1B=7 → MHW_S1B; otherwise → MHW_N5A — Filter
1334. MHW_S1B: "INTERVIEWER: Specify." — Text (80 chars); → MHW_N5A — DK/R not allowed
1335. MHW_R2: "A person's size is important in understanding health. Because of this, I would like to measure your height and weight. The measurements taken will not require any touching." — Read — interviewer press Enter
1336. MHW_Q2A: "Do I have your permission to measure your weight?" — Yes/No {1: "Yes", 2: "No → MHW_N5A"} — DK/R not allowed
1337. MHW_N2A: "INTERVIEWER: Record weight to the nearest 0.01 kg." — Numeric (1.00–261.00 kg) {DK → MSW_N4} — R not allowed
1338. MHW_N3A: "INTERVIEWER: Were there any articles of clothing or physical characteristics which affected the accuracy of this measurement?" — Yes/No {1: "Yes", 2: "No → MHW_N5A"} — DK/R not allowed
1339. MHW_N3B: "INTERVIEWER: Select reasons affecting accuracy." — Multi select {1: "Shoes or boots", 2: "Heavy sweater or jacket", 3: "Jewellery", 4: "Other - Specify"} — DK/R not allowed
1340. MHW_C3B: Filter — If MHW_N3B=4 → MHW_S3B; otherwise → MHW_N5A — Filter
1341. MHW_S3B: "INTERVIEWER: Specify." — Text (80 chars); → MSW_N5A — DK/R not allowed
1342. MHW_N4: "INTERVIEWER: Select the reason for not weighing the respondent." — Single select {1: "Scale not functioning properly → MHW_N5A", 2: "Other – Specify"} — DK/R not allowed
1343. MHW_C4: Filter — If MHW_N4=2 → MHW_S4; otherwise → MHW_N5A — Filter
1344. MHW_S4: "INTERVIEWER: Specify." — Text (80 chars) — DK/R not allowed
1345. MHW_N5A: "INTERVIEWER: Are there any reasons that make it impossible to measure the respondent's height?" — Yes/No {1: "Yes", 2: "No → MHW_C6"} — DK/R not allowed
1346. MHW_N5B: "INTERVIEWER: Select reasons why it is impossible to measure the respondent's height." — Multi select {1: "Too tall", 2: "Interview setting", 3: "Safety concerns", 4: "Has already refused to be measured", 5: "Other – Specify"} — DK/R not allowed
1347. MHW_C5B: Filter — If MHW_N5B=5 → MHW_S5B; otherwise → MHW_END — Filter
1348. MHW_S5B: "INTERVIEWER: Specify." — Text (80 chars); → MHW_END — DK/R not allowed
1349. MHW_C6: Filter — If MHW_N1A=2 → MHW_Q6A; otherwise → MHW_R6 — Filter
1350. MHW_R6: "A person's size is important in understanding health. Because of this, I would like to measure your height. The measurement will not require any touching." — Read — interviewer press Enter
1351. MHW_Q6A: "Do I have your permission to measure your height?" — Yes/No {1: "Yes", 2: "No → MHW_END"} — DK/R not allowed
1352. MHW_N6B: "INTERVIEWER: Enter height to nearest 0.5 cm." — Numeric (90.0–250.0 cm) {DK/R → MHW_END}
1353. MHW_N7A: "INTERVIEWER: Were there any articles of clothing or physical characteristics which affected the accuracy of this measurement?" — Yes/No {1: "Yes", 2: "No → MHW_END"} — DK/R not allowed
1354. MHW_N7B: "INTERVIEWER: Select reasons affecting accuracy." — Multi select {1: "Shoes or boots", 2: "Hairstyle", 3: "Hat", 4: "Other - Specify"} — DK/R not allowed
1355. MHW_C7B: Filter — If MHW_N7B=4 → MHW_S7B; otherwise → MHW_END — Filter
1356. MHW_S7B: "INTERVIEWER: Specify." — Text (80 chars) — DK/R not allowed

---

### Section: LBF - Labour Force - 54 items

1357. LBF_C01: Filter — If (do LBF block=1) → LBF_C02; otherwise → LBF_END — Filter
1358. LBF_C02: Filter — If age < 15 or age > 75 → LBF_END; otherwise → LBF_QINT — Filter
1359. LBF_QINT: "The next few questions concern your activities in the last 7 days." — Read — interviewer press Enter
1360. LBF_Q01: "Last week, did you work at a job or a business?" — Single select {1: "Yes → LBF_Q03", 2: "No", 3: "Permanently unable to work → LBF_QINT2", DK/R → LBF_END}
1361. LBF_E01: Constraint — Soft edit if GEN_Q08=2 and LBF_Q01=1 — postcondition
1362. LBF_Q02: "Last week, did you have a job or business from which you were absent?" — Yes/No {1: "Yes", 2: "No → LBF_Q11", DK/R → LBF_END}
1363. LBF_Q03: "Did you have more than one job or business last week?" — Yes/No {1: "Yes", 2: "No", DK/R}; → LBF_C31
1364. LBF_Q11: "In the past 4 weeks, did you do anything to find work?" — Yes/No {1: "Yes → LBF_QINT2", 2: "No", DK/R → LBF_QINT2}
1365. LBF_Q13: "What is the main reason that you are not currently working at a job or business?" — Single select {1: "Own illness or disability", 2: "Caring for - own children", 3: "Caring for - elder relatives", 4: "Pregnancy (Females only)", 5: "Other personal or family responsibilities", 6: "Vacation", 7: "School or educational leave", 8: "Retired", 9: "Believes no work available", 10: "Other - Specify", DK/R}
1366. LBF_C13S: Filter — If LBF_Q13=10 → LBF_Q13S; otherwise → LBF_C13 — Filter
1367. LBF_Q13S: "INTERVIEWER: Specify." — Text (80 chars)
1368. LBF_E13: Constraint — Hard edit if sex=male and LBF_Q13=4 — postcondition
1369. LBF_C13A: Filter — If LBF_Q13=1 → LBF_Q13A; otherwise → LBF_QINT2 — Filter
1370. LBF_Q13A: "Is this due to your physical health, to your emotional or mental health, to your use of alcohol or drugs, or to another reason?" — Single select {1: "Physical health", 2: "Emotional or mental health (including stress)", 3: "Use of alcohol or drugs", 4: "Another reason", DK/R}
1371. LBF_QINT2: "Now some questions about jobs or employment which you have had during the past 12 months." — Read — interviewer press Enter
1372. LBF_Q21: "Did you work at a job or a business at any time in the past 12 months?" — Yes/No {1: "Yes → LBF_Q23", 2: "No", DK/R}
1373. LBF_E21: Constraint — Soft edit if (GEN_Q08=2 and LBF_Q21=1) or (GEN_Q08=1 and LBF_Q21=2) — postcondition
1374. LBF_C22: Filter — If LBF_Q11=1 → LBF_Q71; otherwise → LBF_Q22 — Filter
1375. LBF_Q22: "During the past 12 months, did you do anything to find work?" — Yes/No {1: "Yes → LBF_Q71", 2: "No → LBF_END", DK/R → LBF_END}
1376. LBF_Q23: "During that 12 months, did you work at more than one job or business at the same time?" — Yes/No {1: "Yes", 2: "No", DK/R}
1377. LBF_QINT3: "The next questions are about your [current/most recent] job or business." — Read — interviewer press Enter
1378. LBF_Q31: "[Are/Were/Is/Was] you an employee or self-employed?" — Single select {1: "Employee → LBF_Q33", 2: "Self-employed", 3: "Working in a family business without pay → LBF_Q33", DK/R → LBF_Q33}
1379. LBF_Q31A: "[Do/Does/Did] you have any employees?" — Yes/No {1: "Yes", 2: "No", DK/R}
1380. LBF_Q32: "What [is/was] the name of your business?" — Text (50 chars); → LBF_Q34
1381. LBF_Q33: "For whom [do/does/did] you [currently/last] work?" — Text (50 chars)
1382. LBF_Q34: "What kind of business, industry or service [is/was] this?" — Text (50 chars)
1383. LBF_Q35: "What kind of work [is/was] you doing?" — Text (50 chars)
1384. LBF_C35: Filter — If LBF_D35=1 or 2 → LBF_S35; otherwise → LBF_Q36 — Filter
1385. LBF_S35: "INTERVIEWER: Specify." — Text (50 chars)
1386. LBF_Q36: "What [are/were] your most important activities or duties?" — Text (50 chars)
1387. LBF_Q36A: "[Is/Was] your job permanent, or is there some way that it [is/was] not permanent?" — Single select {1: "Permanent → LBF_Q37", 2: "Not permanent", DK/R → LBF_Q37}
1388. LBF_Q36B: "In what way [is/was] your job not permanent?" — Single select {1: "Seasonal", 2: "Temporary, term or contract", 3: "Casual job", 4: "Work done through a temporary help agency", 5: "Other", DK/R}
1389. LBF_Q37: "At your place of work, what [are/were] the restrictions on smoking?" — Single select {1: "Restricted completely", 2: "Allowed in designated areas", 3: "Restricted only in certain places", 4: "Not restricted at all", DK/R}
1390. LBF_C41: Filter — If LBF_Q02=1 → LBF_Q41; otherwise → LBF_Q42 — Filter
1391. LBF_Q41: "What was the main reason you were absent from work last week?" — Single select {1: "Own illness or disability", 2: "Caring for - own children", 3: "Caring for - elder relatives", 4: "Maternity leave (Females only)", 5: "Other personal or family responsibilities", 6: "Vacation", 7: "Labour dispute", 8: "Temporary layoff due to business conditions (Employees only)", 9: "Seasonal layoff (Employees only)", 10: "Casual job, no work available (Employees only)", 11: "Work schedule (Employees only)", 12: "Self-employed, no work available (Self-employed only)", 13: "Seasonal business (Excluding employees)", 14: "School or educational leave", 15: "Other - Specify", DK/R}
1392. LBF_C41S: Filter — If LBF_Q41=15 → LBF_Q41S; otherwise → LBF_C41A_1 — Filter
1393. LBF_Q41S: "INTERVIEWER: Specify." — Text (80 chars)
1394. LBF_E41A: Constraint — Hard edit if sex=male and LBF_Q13=4 — postcondition
1395. LBF_E41B: Constraint — Hard edit if LBF_Q31=1 and LBF_Q41=12 or 13 — postcondition
1396. LBF_E41C: Constraint — Hard edit if LBF_Q31=2 and LBF_Q41=8, 9, 10 or 11 — postcondition
1397. LBF_E41D: Constraint — Hard edit if LBF_Q31=3 and LBF_Q41=8, 9, 10, 11 or 12 — postcondition
1398. LBF_C41A_1: Filter — If LBF_Q41=1 → LBF_Q41A; otherwise → LBF_Q42 — Filter
1399. LBF_Q41A: "Was that due to your physical health, to your emotional or mental health, to your use of alcohol or drugs, or to another reason?" — Single select {1: "Physical health", 2: "Emotional or mental health (including stress)", 3: "Use of alcohol or drugs", 4: "Another reason", DK/R}
1400. LBF_Q42: "About how many hours a week [do/does/did] you usually work at your [job/business]?" — Numeric (1–168; warning after 84) {DK/R}
1401. LBF_Q44: "Which of the following best describes the hours you usually [work/works/worked] at your [job/business]?" — Single select {1: "Regular - daytime schedule or shift → LBF_Q46", 2: "Regular - evening shift", 3: "Regular - night shift", 4: "Rotating shift", 5: "Split shift", 6: "On call", 7: "Irregular schedule", 8: "Other - Specify", DK/R → LBF_Q46}
1402. LBF_C44S: Filter — If LBF_Q44=8 → LBF_Q44S; otherwise → LBF_Q45 — Filter
1403. LBF_Q44S: "INTERVIEWER: Specify." — Text (80 chars)
1404. LBF_Q45: "What is the main reason that you [work/works/worked] this schedule?" — Single select {1: "Requirement of job / no choice", 2: "Going to school", 3: "Caring for - own children", 4: "Caring for - other relatives", 5: "To earn more money", 6: "Likes to work this schedule", 7: "Other - Specify", DK/R}
1405. LBF_C45S: Filter — If LBF_Q45=7 → LBF_Q45S; otherwise → LBF_Q46 — Filter
1406. LBF_Q45S: "INTERVIEWER: Specify." — Text (80 chars)
1407. LBF_Q46: "[Do/Does/Did] you usually work on weekends at this [job/business]?" — Yes/No {1: "Yes", 2: "No", DK/R}
1408. LBF_C51: Filter — If LBF_Q03=1 or LBF_Q23=1 → LBF_Q51; otherwise → LBF_Q61 — Filter
1409. LBF_Q51: "For how many weeks in a row [have/has/had] you [job/business] at more than one job?" — Numeric (1–52 weeks) {DK/R}
1410. LBF_Q52: "What is the main reason that you [job/business] at more than one job?" — Single select {1: "To meet regular household expenses", 2: "To pay off debts", 3: "To buy something special", 4: "To save for the future", 5: "To gain experience", 6: "To build up a business", 7: "Enjoys the work of the second job", 8: "Other - Specify", DK/R}
1411. LBF_C52S: Filter — If LBF_Q52=8 → LBF_Q52S; otherwise → LBF_Q53 — Filter
1412. LBF_Q52S: "INTERVIEWER: Specify." — Text (80 chars)
1413. LBF_Q53: "About how many hours a week [do/does/did] you usually work at your other job(s)?" — Numeric (1–[168-LBF_Q42]; warning after 30) {DK/R}
1414. LBF_Q54: "[Do/Does/Did] you usually work on weekends at your other job(s)?" — Yes/No {1: "Yes", 2: "No", DK/R}
1415. LBF_Q61: "During the past 52 weeks, how many weeks did you do any work at a job or a business?" — Numeric (1–52 weeks) {DK/R}
1416. LBF_C71: Filter — If LBF_Q61=52 → LBF_END; if LBF_Q61=51 → LBF_Q71A — Filter
1417. LBF_Q71: "During the past 52 weeks, how many weeks were you looking for work?" — Numeric (0–[52-LBF_Q61]) {DK/R}; → LBF_C72
1418. LBF_Q71A: "That leaves 1 week. During that week, did you look for work?" — Yes/No {1: "Yes (make LBF_Q71=1)", 2: "No (make LBF_Q71=0)", DK/R}
1419. LBF_C72: Filter — If LBF_Q61 or LBF_Q71 non-response → LBF_END; if total=52 → LBF_END; otherwise compute WEEKS — Filter
1420. LBF_Q72: "That leaves [WEEKS] weeks during which you were neither working nor looking for work. Is that correct?" — Yes/No {1: "Yes → LBF_C73", 2: "No", DK/R → LBF_C73}
1421. LBF_E72: Constraint — Hard edit if LBF_Q72=2 — postcondition
1422. LBF_C73: Filter — If (LBF_Q01=1 or LBF_Q02=1 or LBF_Q11=1) → LBF_Q73; otherwise → LBF_END — Filter
1423. LBF_Q73: "What is the main reason that you were not looking for work?" — Single select {1: "Own illness or disability", 2: "Caring for - own children", 3: "Caring for - elder relatives", 4: "Pregnancy (Females only)", 5: "Other personal or family responsibilities", 6: "Vacation", 7: "Labour dispute", 8: "Temporary layoff due to business conditions", 9: "Seasonal layoff", 10: "Casual job, no work available", 11: "Work schedule", 12: "School or educational leave", 13: "Retired", 14: "Believes no work available", 15: "Other - Specify"}
1424. LBF_C73S: Filter — If LBF_Q73=15 → LBF_Q73S; otherwise → LBF_C73A — Filter
1425. LBF_Q73S: "INTERVIEWER: Specify." — Text (80 chars)
1426. LBF_E73: Constraint — Hard edit if sex=male and LBF_Q13=4 — postcondition
1427. LBF_C73B: Filter — If LBF_Q73=1 → LBF_Q73A; otherwise → LBF_END — Filter
1428. LBF_Q73A: "Was that due to your physical health, to your emotional or mental health, to your use of alcohol or drugs, or to another reason?" — Single select {1: "Physical health", 2: "Emotional or mental health (including stress)", 3: "Use of alcohol or drugs", 4: "Another reason", DK/R}

---

### Section: LF2 - Labour Force Common Portion - 14 items

1429. LF2_C1: Filter — If (do LBF block=1) or (m79=1) → LF2_END; otherwise → LF2_C2 — Filter
1430. LF2_C2: Filter — If age < 15 or age > 75 → LF2_END; otherwise → LF2_R1 — Filter
1431. LF2_R1: "The next questions concern your activities in the last 7 days." — Read — interviewer press Enter
1432. LF2_Q1: "Last week, did you work at a job or a business?" — Single select {1: "Yes → LF2_Q3", 2: "No", 3: "Permanently unable to work → LF2_END", DK/R → LF2_END}
1433. LF2_E1: Constraint — Soft edit if GEN_Q08=2 and LF2_Q1=1 — postcondition
1434. LF2_Q2: "Last week, did you have a job or business from which you were absent?" — Yes/No {1: "Yes", 2: "No → LF2_Q4", DK/R → LF2_END}
1435. LF2_Q3: "Did you have more than one job or business last week?" — Yes/No {1: "Yes", 2: "No", DK/R}; → LF2_R5
1436. LF2_Q4: "In the past 4 weeks, did you do anything to find work?" — Yes/No {1: "Yes", 2: "No", DK/R}; → LF2_END
1437. LF2_R5: "The next questions are about your current job or business." — Read — interviewer press Enter
1438. LF2_Q5: "About how many hours a week do you usually work at your job or business?" — Numeric (1–168; warning after 84) {DK/R}
1439. LF2_Q6: "At your place of work, what are the restrictions on smoking?" — Single select {1: "Restricted completely", 2: "Allowed in designated areas", 3: "Restricted only in certain places", 4: "Not restricted at all", DK/R}
1440. LF2_C7: Filter — If LF2_Q3=1 → LF2_Q7; otherwise → LF2_END — Filter
1441. LF2_Q7: "About how many hours a week do you usually work at your other job(s)?" — Numeric (1–[168-LF2_Q5]; warning after 30) {DK/R}

---

### Section: SDC - Socio-Demographic Characteristics - 26 items

1442. SDC_C1: Filter — If (do SDC block=1) → SDC_R1; otherwise → SDC_END — Filter
1443. SDC_R1: "Now some general background questions which will help us compare the health of people in Canada." — Read — interviewer press Enter
1444. SDC_Q1: "In what country were you born?" — Single select {1: "Canada → SDC_Q4", 2: "China", 3: "France", 4: "Germany", 5: "Greece", 6: "Guyana", 7: "Hong Kong", 8: "Hungary", 9: "India", 10: "Italy", 11: "Jamaica", 12: "Netherlands / Holland", 13: "Philippines", 14: "Poland", 15: "Portugal", 16: "United Kingdom", 17: "United States", 18: "Viet Nam", 19: "Sri Lanka", 20: "Other - Specify", DK/R → SDC_Q4}
1445. SDC_C1S: Filter — If SDC_Q1=20 → SDC_Q1S; otherwise → SDC_Q2 — Filter
1446. SDC_Q1S: "INTERVIEWER: Specify." — Text (80 chars)
1447. SDC_Q2: "Were you born a Canadian citizen?" — Yes/No {1: "Yes → SDC_Q4", 2: "No", DK/R → SDC_Q4}
1448. SDC_Q3: "In what year did you first come to Canada to live?" — Numeric (year of birth–current year) {DK/R}
1449. SDC_E3: Constraint — Hard edit if SDC_Q3 < year of birth or SDC_Q3 > current year — postcondition
1450. SDC_Q4: "To which ethnic or cultural group(s) did your ancestors belong?" — Multi select {1: "Canadian", 2: "French", 3: "English", 4: "German", 5: "Scottish", 6: "Irish", 7: "Italian", 8: "Ukrainian", 9: "Dutch (Netherlands)", 10: "Chinese", 11: "Jewish", 12: "Polish", 13: "Portuguese", 14: "South Asian", 15: "Norwegian", 16: "Welsh", 17: "Swedish", 18: "North American Indian", 19: "Métis", 20: "Inuit", 21: "Other – Specify", DK/R}
1451. SDC_C4S: Filter — If SDC_Q4=21 → SDC_Q4S; otherwise → SDC_Q4_1 (or SDC_Q5 pre-June 2005) — Filter
1452. SDC_Q4S: "INTERVIEWER: Specify." — Text (80 chars)
1453. SDC_Q4_1: "Are you an Aboriginal person, that is, North American Indian, Métis or Inuit?" — Yes/No {1: "Yes", 2: "No → SDC_Q4_3", DK/R → SDC_Q5}
1454. SDC_Q4_2: "Are you: … North American Indian? … Métis? … Inuit?" — Multi select {1: "North American Indian", 2: "Métis", 3: "Inuit", DK/R}; → SDC_Q5
1455. SDC_Q4_3: "People living in Canada come from many different cultural and racial backgrounds. Are you:" — Multi select {1: "White", 2: "Chinese", 3: "South Asian", 4: "Black", 5: "Filipino", 6: "Latin American", 7: "Southeast Asian", 8: "Arab", 9: "West Asian", 10: "Japanese", 11: "Korean", 12: "Other - Specify", DK/R}
1456. SDC_C4_3S: Filter — If SDC_Q4_3=12 → SDC_Q4_3S; otherwise → SDC_Q5 — Filter
1457. SDC_Q4_3S: "INTERVIEWER: Specify." — Text (80 chars)
1458. SDC_Q5: "In what languages can you conduct a conversation?" — Multi select {1: "English", 2: "French", 3: "Arabic", 4: "Chinese", 5: "Cree", 6: "German", 7: "Greek", 8: "Hungarian", 9: "Italian", 10: "Korean", 11: "Persian (Farsi)", 12: "Polish", 13: "Portuguese", 14: "Punjabi", 15: "Spanish", 16: "Tagalog (Pilipino)", 17: "Ukrainian", 18: "Vietnamese", 19: "Dutch", 20: "Hindi", 21: "Russian", 22: "Tamil", 23: "Other – Specify", DK/R}
1459. SDC_C5S: Filter — If SDC_Q5=23 → SDC_Q5S; otherwise → SDC_Q5A — Filter
1460. SDC_Q5S: "INTERVIEWER: Specify." — Text (80 chars)
1461. SDC_Q5A: "What language do you speak most often at home?" — Single select {1: "English", 2: "French", 3–22: [same languages as SDC_Q5], 23: "Other – Specify", DK/R}
1462. SDC_C5AS: Filter — If SDC_Q5A=23 → SDC_Q5AS; otherwise → SDC_Q6 — Filter
1463. SDC_Q5AS: "INTERVIEWER: Specify." — Text (80 chars)
1464. SDC_Q6: "What is the language that you first learned at home in childhood and can still understand?" — Multi select {1–22: [same languages], 23: "Other - Specify", DK/R}
1465. SDC_C6S: Filter — If SDC_Q6=23 → SDC_Q6S; otherwise → SDC_Q7 — Filter
1466. SDC_Q6S: "INTERVIEWER: Specify." — Text (80 chars)
1467. SDC_Q7: "People living in Canada come from many different cultural and racial backgrounds. Are you:" — Multi select {1: "White", 2: "Chinese", 3: "South Asian", 4: "Black", 5: "Filipino", 6: "Latin American", 7: "Southeast Asian", 8: "Arab", 9: "West Asian", 10: "Japanese", 11: "Korean", 12: "Aboriginal (North American Indian, Métis or Inuit)", 13: "Other - Specify", DK/R} — collected Jan–May 2005 only
1468. SDC_C7S: Filter — If SDC_Q7=13 → SDC_Q7S; otherwise → SDC_C7B — Filter
1469. SDC_Q7S: "INTERVIEWER: Specify." — Text (80 chars)
1470. SDC_C7B: Filter — If SDC_Q7=12 → SDC_Q7B; otherwise → SDC_C7A — Filter
1471. SDC_Q7B: "Are you: … North American Indian? … Métis? … Inuit?" — Single select {1: "North American Indian", 2: "Métis", 3: "Inuit", 4: "Other - Specify", DK/R}
1472. SDC_C7BS: Filter — If SDC_Q7B=4 → SDC_Q7BS; otherwise → SDC_C7A — Filter
1473. SDC_Q7BS: "INTERVIEWER: Specify." — Text (80 chars)
1474. SDC_C7A: Filter — If proxy interview or age < 18 or age > 59 → SDC_END; otherwise → SDC_Q7A — Filter
1475. SDC_Q7A: "Do you consider yourself to be: … heterosexual? … homosexual, that is lesbian or gay? … bisexual?" — Single select {1: "heterosexual", 2: "homosexual (lesbian or gay)", 3: "bisexual", DK/R}

---

### Section: EDU - Education Router - 7 items

1476. EDU_C01A: Filter — If (do EDU block=1) → EDU_C01B; otherwise → EDU_END — Filter
1477. EDU_C01B: Filter — If age of selected respondent < 14 → EDU_C07A; otherwise → EDU_B01 — Filter
1478. EDU_B01: "Call Education Sub Block 1 (EDU1)" — Filter — calls EDU1 block
1479. EDU_C07A: Filter — If at least one household member >= 14 years other than selected respondent → EDU_R07A; otherwise → EDU_END — Filter
1480. EDU_R07A: "Now I'd like you to think about the rest of your household." — Read — interviewer press Enter
1481. EDU_B02: "Call Education Sub Block 2 (EDU2)" — Filter — calls EDU2 block for each household member aged 14+ other than selected respondent (max 19 times)

---

### Section: EDU1 - Education Sub Block 1 - 6 items

1482. EDU_R01: "Next, education." — Read — interviewer press Enter
1483. EDU_Q01: "What is the highest grade of elementary or high school you have ever completed?" — Single select {1: "Grade 8 or lower → EDU_Q03", 2: "Grade 9–10 → EDU_Q03", 3: "Grade 11–13", DK/R → EDU_Q03}
1484. EDU_Q02: "Did you graduate from high school (secondary school)?" — Yes/No {1: "Yes", 2: "No", DK/R}
1485. EDU_Q03: "Have you received any other education that could be counted towards a degree, certificate or diploma from an educational institution?" — Yes/No {1: "Yes", 2: "No → EDU_Q05", DK/R → EDU_Q05}
1486. EDU_Q04: "What is the highest degree, certificate or diploma you have obtained?" — Single select {1: "No post-secondary degree, certificate or diploma", 2: "Trade certificate or diploma", 3: "Non-university certificate or diploma from a community college, CEGEP, school of nursing, etc.", 4: "University certificate below bachelor's level", 5: "Bachelor's degree", 6: "University degree or certificate above bachelor's degree", DK/R}
1487. EDU_Q05: "Are you currently attending a school, college or university?" — Yes/No {1: "Yes", 2: "No → EDU1_END", DK/R → EDU1_END}
1488. EDU_Q06: "Are you enrolled as a full-time student or a part-time student?" — Single select {1: "Full-time", 2: "Part-time", DK/R}

---

### Section: EDU2 - Education Sub Block 2 - 4 items

1489. EDU_Q07: "What is the highest grade of elementary or high school [you/FNAME] ever completed?" — Single select {1: "Grade 8 or lower → EDU_Q09", 2: "Grade 9–10 → EDU_Q09", 3: "Grade 11–13", DK/R → EDU_Q09}
1490. EDU_Q08: "Did [you/he/she] graduate from high school (secondary school)?" — Yes/No {1: "Yes", 2: "No", DK/R}
1491. EDU_Q09: "[Have/Has] [you/he/she] received any other education that could be counted towards a degree, certificate or diploma from an educational institution?" — Yes/No {1: "Yes", 2: "No → next family member or EDU_END", DK/R → next family member or EDU_END}
1492. EDU_Q10: "What is the highest degree, certificate or diploma [you/he/she] [have/has] obtained?" — Single select {1: "No post-secondary degree, certificate or diploma", 2: "Trade certificate or diploma", 3: "Non-university certificate or diploma from a community college, CEGEP, school of nursing, etc.", 4: "University certificate below bachelor's level", 5: "Bachelor's degree", 6: "University degree or certificate above bachelor's degree", DK/R}

---

### Section: INS - Insurance Coverage - 10 items

1493. INS_C1A: Filter — If (do INS block=1) → INS_QINT; otherwise → INS_END — Filter
1494. INS_QINT: "Now, turning to your insurance coverage. Please include any private, government or employer-paid plans." — Read — interviewer press Enter
1495. INS_Q1: "Do you have insurance that covers all or part of the cost of your prescription medications?" — Yes/No {1: "Yes", 2: "No → INS_Q2", DK → INS_Q2", R → INS_END}
1496. INS_Q1A: "Is it:" — Multi select {1: "a government-sponsored plan", 2: "an employer-sponsored plan", 3: "a private plan", DK/R}
1497. INS_Q2: "Do you have insurance that covers all or part of your dental expenses?" — Yes/No {1: "Yes", 2: "No → INS_Q3", DK/R → INS_Q3}
1498. INS_Q2A: "Is it:" — Multi select {1: "a government-sponsored plan", 2: "an employer-sponsored plan", 3: "a private plan", DK/R}
1499. INS_Q3: "Do you have insurance that covers all or part of the costs of eye glasses or contact lenses?" — Yes/No {1: "Yes", 2: "No → INS_Q4", DK/R → INS_Q4}
1500. INS_Q3A: "Is it:" — Multi select {1: "a government-sponsored plan", 2: "an employer-sponsored plan", 3: "a private plan", DK/R}
1501. INS_Q4: "Do you have insurance that covers all or part of hospital charges for a private or semi-private room?" — Yes/No {1: "Yes", 2: "No → INS_END", DK/R → INS_END}
1502. INS_Q4A: "Is it:" — Multi select {1: "a government-sponsored plan", 2: "an employer-sponsored plan", 3: "a private plan", DK/R}

---

### Section: INC - Income - 22 items

1503. INC_C1: Filter — If (do INC block=1) → INC_QINT; otherwise → INC_END — Filter
1504. INC_QINT: "Although many health expenses are covered by health insurance, there is still a relationship between health and income..." — Read — interviewer press Enter
1505. INC_Q1: "Thinking about the total income for all household members, from which of the following sources did your household receive any income in the past 12 months?" — Multi select {1: "Wages and salaries", 2: "Income from self-employment", 3: "Dividends and interest", 4: "Employment insurance", 5: "Worker's compensation", 6: "Benefits from Canada or Quebec Pension Plan", 7: "Retirement pensions, superannuation and annuities", 8: "Old Age Security and Guaranteed Income Supplement", 9: "Child Tax Benefit", 10: "Provincial or municipal social assistance or welfare", 11: "Child support", 12: "Alimony", 13: "Other", 14: "None → INC_Q3", DK/R → INC_END}
1506. INC_E1: Constraint — Hard edit if INC_Q1=14 and any other response selected — postcondition
1507. INC_E2: Constraint — Soft edit if (INC_Q1 ≠ 1 or 2) and (LBF_Q01=1 or LBF_Q02=1 or LBF_Q21=1) — postcondition
1508. INC_C2: Filter — If more than one source indicated → INC_Q2; otherwise → INC_Q3 — Filter
1509. INC_Q2: "What was the main source of income?" — Single select {1–13: [same categories as INC_Q1], 14: "None (processing)", DK/R}
1510. INC_E3: Constraint — Hard edit if response in INC_Q2 was not selected in INC_Q1 — postcondition
1511. INC_Q3: "What is your best estimate of the total income, before taxes and deductions, of all household members from all sources in the past 12 months?" — Numeric (0–500,000; warning after 150,000) {0 → INC_END, DK/R → INC_Q3A}; → INC_C4
1512. INC_Q3A: "Can you estimate in which of the following groups your household income falls? Was the total household income less than $20,000 or $20,000 or more?" — Single select {1: "Less than $20,000", 2: "$20,000 or more → INC_Q3E", 3: "No income → INC_END", DK/R → INC_END}
1513. INC_Q3B: "Was the total household income from all sources less than $10,000 or $10,000 or more?" — Single select {1: "Less than $10,000", 2: "$10,000 or more → INC_Q3D", DK/R → INC_C4}
1514. INC_Q3C: "Was the total household income from all sources less than $5,000 or $5,000 or more?" — Single select {1: "Less than $5,000", 2: "$5,000 or more", DK/R}; → INC_C4
1515. INC_Q3D: "Was the total household income from all sources less than $15,000 or $15,000 or more?" — Single select {1: "Less than $15,000", 2: "$15,000 or more", DK/R}; → INC_C4
1516. INC_Q3E: "Was the total household income from all sources less than $40,000 or $40,000 or more?" — Single select {1: "Less than $40,000", 2: "$40,000 or more → INC_Q3G", DK/R → INC_C4}
1517. INC_Q3F: "Was the total household income from all sources less than $30,000 or $30,000 or more?" — Single select {1: "Less than $30,000", 2: "$30,000 or more", DK/R}; → INC_C4
1518. INC_Q3G: "Was the total household income from all sources:" — Single select {1: "less than $50,000", 2: "$50,000 to less than $60,000", 3: "$60,000 to less than $80,000", 4: "$80,000 to less than $100,000", 5: "$100,000 or more", DK/R}
1519. INC_C4: Filter — If age >= 15 → INC_Q4; otherwise → INC_END — Filter
1520. INC_Q4: "What is your best estimate of your total personal income, before taxes and other deductions, from all sources in the past 12 months?" — Numeric (0–500,000; warning after 150,000) {0 → INC_END, DK/R → INC_Q4A}; → INC_END
1521. INC_Q4A: "Can you estimate in which of the following groups your personal income falls? Was your total personal income less than $20,000 or $20,000 or more?" — Single select {1: "Less than $20,000", 2: "$20,000 or more → INC_Q4E", 3: "No income → INC_END", DK/R → INC_END}
1522. INC_Q4B: "Was your total personal income less than $10,000 or $10,000 or more?" — Single select {1: "Less than $10,000", 2: "$10,000 or more → INC_Q4D", DK/R → INC_END}
1523. INC_Q4C: "Was your total personal income less than $5,000 or $5,000 or more?" — Single select {1: "Less than $5,000", 2: "$5,000 or more", DK/R}; → INC_END
1524. INC_Q4D: "Was your total personal income less than $15,000 or $15,000 or more?" — Single select {1: "Less than $15,000", 2: "$15,000 or more", DK/R}; → INC_END
1525. INC_Q4E: "Was your total personal income less than $40,000 or $40,000 or more?" — Single select {1: "Less than $40,000", 2: "$40,000 or more → INC_Q4G", DK/R → INC_END}
1526. INC_Q4F: "Was your total personal income less than $30,000 or $30,000 or more?" — Single select {1: "Less than $30,000", 2: "$30,000 or more", DK/R}; → INC_END
1527. INC_Q4G: "Was your total personal income:" — Single select {1: "less than $50,000", 2: "$50,000 to less than $60,000", 3: "$60,000 to less than $80,000", 4: "$80,000 to less than $100,000", 5: "$100,000 or more", DK/R}

---

### Section: FSC - Food Security - 22 items

1528. FSC_C01: Filter — If (do FSC block=1) → FSC_D010; otherwise → FSC_END — Filter
1529. FSC_D010: Computed fills — Sets ^YouAndOthers, ^ChildFName, ^YouOtherAdults fill variables based on HhldSize and child counts — Filter
1530. FSC_R010: "The following questions are about the food situation for your household in the past 12 months." — Read — interviewer press Enter
1531. FSC_Q010: "Which of the following statements best describes the food eaten in your household in the past 12 months?" — Single select {1: "Always had enough of the kinds of food you wanted to eat", 2: "Had enough to eat, but not always the kinds of food you wanted", 3: "Sometimes did not have enough to eat", 4: "Often didn't have enough to eat", DK/R → FSC_END}
1532. FSC_R020: "Now I'm going to read you several statements that may be used to describe the food situation for a household..." — Read — interviewer press Enter
1533. FSC_Q020: "You worried that food would run out before you got money to buy more. Was that often true, sometimes true, or never true in the past 12 months?" — Single select {1: "Often true", 2: "Sometimes true", 3: "Never true", DK/R}
1534. FSC_Q030: "The food that you bought just didn't last, and there wasn't any money to get more. Was that often true, sometimes true, or never true in the past 12 months?" — Single select {1: "Often true", 2: "Sometimes true", 3: "Never true", DK/R}
1535. FSC_Q040: "You couldn't afford to eat balanced meals. In the past 12 months was that often true, sometimes true, or never true?" — Single select {1: "Often true", 2: "Sometimes true", 3: "Never true", DK/R}
1536. FSC_C050: Filter — If (OlderKids + YoungKids > 0) → FSC_R050; otherwise → FSC_C070 — Filter
1537. FSC_R050: "Now I'm going to read a few statements that may describe the food situation for households with children." — Read — interviewer press Enter
1538. FSC_Q050: "You relied on only a few kinds of low-cost food to feed [child/the children] because you were running out of money to buy food. Was that often true, sometimes true, or never true in the past 12 months?" — Single select {1: "Often true", 2: "Sometimes true", 3: "Never true", DK/R}
1539. FSC_Q060: "You couldn't feed [child/the children] a balanced meal, because you couldn't afford it. Was that often true, sometimes true, or never true in the past 12 months?" — Single select {1: "Often true", 2: "Sometimes true", 3: "Never true", DK/R}
1540. FSC_C070: Filter — Complex routing: if food insecurity indicators positive and children present → FSC_Q070; if food insecurity positive without children → FSC_R080; otherwise → FSC_END — Filter
1541. FSC_Q070: "[Child/The children] was not eating enough because you just couldn't afford enough food. Was that often, sometimes, or never true in the past 12 months?" — Single select {1: "Often true", 2: "Sometimes true", 3: "Never true", DK/R}
1542. FSC_R080: "The following few questions are about the food situation in the past 12 months for you or any other adults in your household." — Read — interviewer press Enter
1543. FSC_Q080: "In the past 12 months, did you ever cut the size of your meals or skip meals because there wasn't enough money for food?" — Yes/No {1: "Yes", 2: "No → FSC_Q090", DK/R → FSC_Q090}
1544. FSC_Q081: "How often did this happen---almost every month, some months but not every month, or in only 1 or 2 months?" — Single select {1: "Almost every month", 2: "Some months but not every month", 3: "Only 1 or 2 months", DK/R}
1545. FSC_Q090: "In the past 12 months, did you (personally) ever eat less than you felt you should because there wasn't enough money to buy food?" — Yes/No {1: "Yes", 2: "No", DK/R}
1546. FSC_Q100: "In the past 12 months, were you (personally) ever hungry but didn't eat because you couldn't afford enough food?" — Yes/No {1: "Yes", 2: "No", DK/R}
1547. FSC_Q110: "In the past 12 months, did you (personally) lose weight because you didn't have enough money for food?" — Yes/No {1: "Yes", 2: "No", DK/R}
1548. FSC_C120: Filter — If (FSC_Q070=1 or 2) or (FSC_Q080 or FSC_Q090 or FSC_Q100 or FSC_Q110=1) → FSC_Q120; otherwise → FSC_END — Filter
1549. FSC_Q120: "In the past 12 months, did you ever not eat for a whole day because there wasn't enough money for food?" — Yes/No {1: "Yes", 2: "No → FSC_C130", DK/R → FSC_C130}
1550. FSC_Q121: "How often did this happen---almost every month, some months but not every month, or in only 1 or 2 months?" — Single select {1: "Almost every month", 2: "Some months but not every month", 3: "Only 1 or 2 months", DK/R}
1551. FSC_C130: Filter — If (OlderKids + YoungKids ≠ 0) → FSC_R130; otherwise → FSC_END — Filter
1552. FSC_R130: "Now, a few questions on the food experiences for children in your household." — Read — interviewer press Enter
1553. FSC_Q130: "In the past 12 months, did you ever cut the size of [child's/any of the children's] meals because there wasn't enough money for food?" — Yes/No {1: "Yes", 2: "No", DK/R}
1554. FSC_Q140: "In the past 12 months, did [child/any of the children] ever skip meals because there wasn't enough money for food?" — Yes/No {1: "Yes", 2: "No → FSC_Q150", DK/R → FSC_Q150}
1555. FSC_Q141: "How often did this happen---almost every month, some months but not every month, or in only 1 or 2 months?" — Single select {1: "Almost every month", 2: "Some months but not every month", 3: "Only 1 or 2 months", DK/R}
1556. FSC_Q150: "In the past 12 months, was [child/any child] ever hungry but you just couldn't afford more food?" — Yes/No {1: "Yes", 2: "No", DK/R}
1557. FSC_Q160: "In the past 12 months, did [child/any of the children] ever not eat for a whole day because there wasn't enough money for food?" — Yes/No {1: "Yes", 2: "No", DK/R}

---

### Section: DWL - Dwelling Characteristics - 6 items

1558. DWL_C01: Filter — If (do block DWL=1) → DWL_R01; otherwise → DWL_END — Filter
1559. DWL_R01: "Now a few questions about your dwelling." — Read — interviewer press Enter
1560. DWL_C01B: Filter — If area frame → DWL_Q02; otherwise → DWL_Q01 — Filter
1561. DWL_Q01: "What type of dwelling do you live in? Is it a:" — Single select {1: "single detached", 2: "double", 3: "row or terrace", 4: "duplex", 5: "low-rise apartment of fewer than 5 stories or a flat", 6: "high-rise apartment of 5 stories or more", 7: "institution", 8: "hotel; rooming/lodging house; camp", 9: "mobile home", 10: "other – Specify", DK/R}
1562. DWL_C01S: Filter — If DWL_Q01=10 → DW_Q01S; otherwise → DWL_Q02 — Filter
1563. DWL_Q01S: "INTERVIEWER: Specify." — Text (80 chars)
1564. DWL_Q02: "How many bedrooms are there in this dwelling?" — Numeric (0–20) {DK/R}
1565. DWL_E02: Constraint — Soft edit if DWL_Q02 > 10 — postcondition
1566. DWL_Q03: "Is this dwelling owned by a member of this household?" — Yes/No {1: "Yes", 2: "No", DK/R}

---

### Section: ADM - Administration - 26 items

1567. ADM_C01: Filter — If (do ADM block=1) → ADM_Q01A; otherwise → ADM_END — Filter
1568. ADM_Q01A: "Statistics Canada and your [provincial/territorial] ministry of health would like your permission to link information collected during this interview..." — Read — interviewer press Enter
1569. ADM_Q01B: "This linked information will be kept confidential and used only for statistical purposes. Do we have your permission?" — Yes/No {1: "Yes", 2: "No → ADM_Q04A", DK/R → ADM_Q04A}
1570. ADM_C3A: Computed fill — Sets [province] fill text based on province code — Filter
1571. ADM_Q03A: "Do you have a(n) [province] health number?" — Yes/No {1: "Yes → HN", 2: "No", DK/R → ADM_Q04A}
1572. ADM_Q03B: "For which [province/territory] is your health number?" — Single select {10: "Newfoundland and Labrador", 11: "Prince Edward Island", 12: "Nova Scotia", 13: "New Brunswick", 24: "Quebec", 35: "Ontario", 46: "Manitoba", 47: "Saskatchewan", 48: "Alberta", 59: "British Columbia", 60: "Yukon", 61: "Northwest Territories", 62: "Nunavut", 88: "Do not have a health number → ADM_Q04A", DK/R → ADM_Q04A}
1573. HN: "What is your health number?" — Text (8–12 chars) {DK/R}
1574. ADM_Q04A: "Statistics Canada would like your permission to share the information collected in this survey with provincial and territorial ministries of health [and Health Canada / and the Public Health Agency of Canada]..." — Read — interviewer press Enter (province-specific variants)
1575. ADM_Q04B: "All information will be kept confidential and used only for statistical purposes. Do you agree to share the information provided?" — Yes/No {1: "Yes", 2: "No", DK/R}
1576. FRE_C1: Filter — If RDD or FREFLAG=1 → ADM_N05 — Filter
1577. FRE_QINT: "And finally, a few questions to evaluate the way households were selected for this survey." — Read — interviewer press Enter
1578. FRE_Q1: "How many different telephone numbers are there for your household, not counting cellular phone numbers and phone numbers used strictly for business purposes?" — Single select {1: "1", 2: "2", 3: "3 or more", 4: "None → FRE_Q4", DK/R → ADM_N05}
1579. FRE_Q2: "What is [your/your main] phone number, including the area code?" — Text (area code + telephone number) {DK → ADM_N05, R → FRE_Q2A}; → FRE_C3
1580. FRE_Q2A: "Could you tell me the area code and the first 5 digits of your phone number?" — Text {DK/R → ADM_N05}
1581. FRE_C3: Filter — If FRE_Q1=1 → ADM_N05 — Filter
1582. FRE_Q3: "What is [your other phone number/another of your phone numbers], including the area code?" — Text (area code + telephone number) {DK → ADM_N05, R → FRE_Q3A}; → ADM_N05
1583. FRE_Q3A: "Could you tell me the area code and the first 5 digits of [your other phone number/another of your phone numbers]?" — Text {DK/R}; → ADM_N05
1584. FRE_Q4: "Do you have a working cellular phone that can place and receive calls?" — Yes/No {1: "Yes", 2: "No", DK/R}
1585. ADM_N05: "INTERVIEWER: Is this a fictitious name for the respondent?" — Yes/No {1: "Yes", 2: "No → ADM_C09", DK/R → ADM_C09}
1586. ADM_N06: "INTERVIEWER: Remind respondent about the importance of getting correct names. Do you want to make corrections to:" — Single select {1: "first name only", 2: "last name only → ADM_N08", 3: "both names", 4: "no corrections → ADM_C09", DK/R → ADM_C09}
1587. ADM_N07: "INTERVIEWER: Enter the first name only." — Text (25 chars)
1588. ADM_C08: Filter — If ADM_N06 ≠ "both names" → ADM_C09 — Filter
1589. ADM_N08: "INTERVIEWER: Enter the last name only." — Text (25 chars)
1590. ADM_C09: Filter — If RDD → ADM_N10 — Filter
1591. ADM_N09: "INTERVIEWER: Was this interview conducted on the telephone or in person?" — Single select {1: "On telephone", 2: "In person", 3: "Both", DK/R}
1592. ADM_N10: "INTERVIEWER: Was the respondent alone when you asked this health questionnaire?" — Yes/No {1: "Yes → ADM_N12", 2: "No", DK/R → ADM_N12}
1593. ADM_N11: "INTERVIEWER: Do you think that the answers of the respondent were affected by someone else being there?" — Yes/No {1: "Yes", 2: "No", DK/R}
1594. ADM_N12: "INTERVIEWER: Record language of interview." — Single select {1: "English", 2: "French", 3: "Chinese", 4: "Italian", 5: "Punjabi", 6: "Spanish", 7: "Portuguese", 8: "Polish", 9: "German", 10: "Vietnamese", 11: "Arabic", 12: "Tagalog", 13: "Greek", 14: "Tamil", 15: "Cree", 16: "Afghan", 17: "Cantonese", 18: "Hindi", 19: "Mandarin", 20: "Persian", 21: "Russian", 22: "Ukrainian", 23: "Urdu", 24: "Inuktitut", 90: "Other – Specify", DK/R}
1595. ADM_C12S: Filter — If ADM_N12=90 → ADM_N12S; otherwise → ADM_END — Filter
1596. ADM_N12S: "INTERVIEWER: Specify." — Text (80 chars)

