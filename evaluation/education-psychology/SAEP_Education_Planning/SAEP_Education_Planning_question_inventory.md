# SAEP — Survey of Approaches to Educational Planning — Question Inventory

## Verification Status

| Section | Source Qs | Inventory Qs | Missing | Source GOTOs | Inv. GOTOs | Missing |
|---------|----------|-------------|---------|-------------|-----------|---------|
| A       | 3        | 3           | 0       | 6           | 6         | 0       |
| B       | 44 (70 w/ sub-items) | 70 | 0   | 23          | 23        | 0       |
| C       | 44 (70 w/ sub-items) | 70 | 0   | 23          | 23        | 0       |
| D       | 44 (70 w/ sub-items) | 70 | 0   | 23          | 23        | 0       |
| E       | 11 (19 w/ sub-items) | 19 | 0   | 5           | 5         | 0       |
| F       | 12 (20 w/ sub-items) | 20 | 0   | 4           | 4         | 0       |
| G       | 13       | 13          | 0       | 5           | 5         | 0       |
| **Total** | **171 (265 w/ sub-items)** | **265** | **0** | **89** | **89** | **0** |

- **Coverage**: PASS -- All 265 items (171 base questions with sub-items expanded) accounted for across 7 sections
- **Routing**: PASS -- All 89 explicit source GOTOs captured; inventory adds sequential routing for all 265 items (264 with GO TO + 2 with END INTERVIEW)
- **Node Types**: PASS -- 20 Interviewer Check Items correctly typed as Filter (A3, B4/B26/B30/B39/B44, C4/C26/C30/C39/C44, D4/D26/D30/D39/D44, E9, F10, G1, G12); 5 all-no constraint rules captured (B37d, C37d, D37d, E7d, F8d)
- **Status**: READY FOR QML
- **Missing**: none

## Document Overview
- **Title**: Survey of Approaches to Educational Planning (SAEP)
- **Organization**: Statistics Canada, Special Surveys Division (jointly with Human Resources Development Canada)
- **Pages**: 52
- **Language**: English (French version available)
- **Type**: CATI household survey
- **Year**: 1999
- **Form Number**: 8-5300-368.1

## Structure

The questionnaire collects information about children's school experiences and financial plans for post-secondary education. Up to 3 children per household are selected for detailed questioning, with a savings-only module for remaining children.

| Section | Topic | Questions | Target |
|---------|-------|-----------|--------|
| A | Introduction and Screening | A1–A3 | Household |
| B | Child 1 — General Questions & Savings | B1–B44 | Selected child 1 |
| C | Child 2 — General Questions & Savings | C1–C44 | Selected child 2 |
| D | Child 3 — General Questions & Savings | D1–D44 | Selected child 3 |
| E | Remaining Children — Savings | E1–E11 | Other children in household |
| F | Children Outside Household | F1–F12 | Children not living in household |
| G | General Information | G1–G13 | Household/respondent |

**Note**: Sections B, C, and D are structurally identical — the same question set applied to each of up to 3 selected children. Each section contains: general/relationship questions, school performance (age-gated), planning for post-secondary education, and savings details.

## Question Inventory by Section

### Section A — Introduction and Screening — 3 items

1. A1: "How many children 18 years of age or younger usually live at this dwelling? This includes children who usually live here but are now away at school, in the hospital or somewhere else." — Numeric (0–99) — 0 → GO TO Section F (page 47); 1+ → GO TO A2

2. A2: "I would like to speak to the person who is the most knowledgeable about these children and about any plans made for their post-secondary education. Would this person be you?" — Yes/No {1: "Yes", 2: "No"} — 1 (Yes) → GO TO A3; 2 (No) → Schedule interview with Person Most Knowledgeable

3. A3: "Interviewer Check Item" — Filter — If 01–03 children in A1 → fill in Child 1/2/3 info, GO TO Section B (Child 1); If 04+ children in A1 → use selection grid to choose 3 children, fill in info, GO TO Section B (Child 1)

### Section B — Child 1: General Questions — 70 items

**Child 1 Info Block**: First Name (Text), Sex {1: "Male", 2: "Female"}, Age in years (Numeric; if less than 1 year, enter 00)

4. B1: "Now I am going to ask you some questions about ... (name of CHILD 1). What is ...'s relationship to you?" — Single select {1: "Son/daughter (biological, adoptive, stepchild)", 2: "Foster child", 3: "Grandchild", 4: "Brother/sister", 5: "Other family member or relative", 6: "Unrelated"} — All → GO TO B2

5. B2: "Does ... have any long-term conditions or health problems which prevent or limit his/her participation in school, at play, or in any other activity for a child of his/her age?" — Single select {01: "Yes", 02: "No", 07: "Don't know", 08: "Refused"} — All → GO TO B3

6. B3: "How far do ...'s parents/guardians hope that he/she will go in school?" — Single select {1: "Primary school", 2: "Secondary or high school", 3: "Community college, technical college or CEGEP", 4: "University", 5: "Learn a trade", 7: "Don't know", 8: "Refused"} — All → GO TO B4

7. B4: "Interviewer Check Item: Check age of child." — Filter — Age 00–04 → GO TO B20; Age 05–08 → GO TO B6; Age 09+ → GO TO B5

8. B5: "How far do ...'s parents/guardians expect that he/she will go in school?" — Single select {1: "Primary school", 2: "Secondary or high school", 3: "Community college, technical college or CEGEP", 4: "University", 5: "Learn a trade", 7: "Don't know", 8: "Refused"} — All → GO TO B6

9. B6: "Did ... attend school last year? (include home schooling)" — Single select {01: "Yes", 02: "No", 07: "Don't know", 08: "Refused"} — 01 (Yes) → GO TO B9; 02 (No) → GO TO B7; 07 (DK) → GO TO B20; 08 (R) → GO TO B20

10. B7: "Why did ... not attend school last year?" — Single select {1: "Too young for school", 2: "Physical, mental, emotional or behavioral problem", 3: "Left school before graduating", 4: "Graduated from school", 5: "Other - Specify"} — 1 → GO TO B20; 2 → GO TO B20; 3 → GO TO B8; 4 → GO TO B8; 5 → GO TO B8

11. B8: "In what grade was ... last enrolled?" — Single select {01: "Junior kindergarten", 02: "Kindergarten", 03: "Grade 1", 04: "Grade 2", 05: "Grade 3", 06: "Grade 4", 07: "Grade 5", 08: "Grade 6", 09: "Grade 7 (Quebec = Sec 1)", 10: "Grade 8 (Quebec = Sec 2)", 11: "Grade 9 (Quebec = Sec 3)", 12: "Grade 10 (Quebec = Sec 4)", 13: "Grade 11 (Quebec = Sec 5)", 14: "Grade 12", 15: "OAC Grade 13 (Ontario)", 16: "Ungraded", 17: "CEGEP tech 1st yr", 18: "CEGEP tech 2nd yr", 19: "CEGEP tech 3rd yr", 20: "CEGEP acad 1st yr", 21: "CEGEP acad 2nd yr", 22: "CEGEP acad 3rd yr", 23: "University 1st yr", 24: "University 2nd yr", 25: "University 3rd yr", 26: "Apprenticeship 1st yr", 27: "Apprenticeship 2nd yr", 28: "Apprenticeship 3rd yr", 29: "Trades-tech 1st yr", 30: "Trades-tech 2nd yr", 31: "Trades-tech 3rd yr", 32: "Other", 33: "N/A", 97: "Don't know", 98: "Refused"} — All → GO TO B20

12. B9: "In what grade was he/she enrolled last year?" — Single select {34: "Junior kindergarten", 35: "Kindergarten", 36: "Grade 1", 37: "Grade 2", 38: "Grade 3", 39: "Grade 4", 40: "Grade 5", 41: "Grade 6", 42: "Grade 7 (Quebec = Sec 1)", 43: "Grade 8 (Quebec = Sec 2)", 44: "Grade 9 (Quebec = Sec 3)", 45: "Grade 10 (Quebec = Sec 4)", 46: "Grade 11 (Quebec = Sec 5)", 47: "Grade 12", 48: "OAC Grade 13 (Ontario)", 49: "Ungraded", 50: "CEGEP tech 1st yr", 51: "CEGEP tech 2nd yr", 52: "CEGEP tech 3rd yr", 53: "CEGEP acad 1st yr", 54: "CEGEP acad 2nd yr", 55: "CEGEP acad 3rd yr", 56: "University 1st yr", 57: "University 2nd yr", 58: "University 3rd yr", 59: "Apprenticeship 1st yr", 60: "Apprenticeship 2nd yr", 61: "Apprenticeship 3rd yr", 62: "Trades-tech 1st yr", 63: "Trades-tech 2nd yr", 64: "Trades-tech 3rd yr", 65: "Other", 66: "N/A", 97: "Don't know", 98: "Refused"} — 34–35 (Jr K, K) → GO TO B20; 36–49 (Grades 1–13, Ungraded) → GO TO B10; 50–64 (post-secondary) → GO TO B20; 65, 66, 97, 98 → GO TO B10

13. B10: "The next questions refer to ...'s last school year. Based on your knowledge of ...'s schoolwork, including report cards, how did he/she do overall in school? (READ LIST.)" — Single select {01: "Above average", 02: "Average", 03: "Below average", 07: "Don't know", 08: "Refused"} — All → GO TO B11

14. B11: "How did ... feel about his/her schoolwork? (READ LIST.)" — Single select {1: "Liked it very much", 2: "Liked it", 3: "Neither liked nor disliked it", 4: "Disliked it", 5: "Disliked it very much", 7: "Don't know", 8: "Refused"} — All → GO TO B12

15. B12: "Overall, did ...'s close friends do well in their schoolwork?" — Single select {01: "Yes", 02: "No", 07: "Don't know", 08: "Refused"} — All → GO TO B13

16. B13: "How often were ...'s parents/guardians in contact with his/her teachers to discuss his/her academic performance or behaviour? (READ LIST.)" — Single select {1: "Often", 2: "A few times", 3: "Once", 4: "Never", 7: "Don't know", 8: "Refused"} — All → GO TO B14

17. B14: "Did ...'s parents/guardians set aside a place in the home for him/her to use for studying or doing homework?" — Single select {01: "Yes", 02: "No", 07: "Don't know", 08: "Refused"} — All → GO TO B15a

18. B15a: "In a typical week during the last school year, how often did ... participate in organized activities that were not run by the school such as: a) Sports or physical activities like Little League, swim club or hockey league? (READ LIST.)" — Single select {1: "More than once a week", 2: "About once a week", 3: "Less than once a week", 4: "Never", 7: "Don't know", 8: "Refused"} — All → GO TO B15b

19. B15b: "b) Social club activities like scouts, girl guides, boys and girls clubs or church groups? (READ LIST.)" — Single select {01: "More than once a week", 02: "About once a week", 03: "Less than once a week", 04: "Never", 07: "Don't know", 08: "Refused"} — All → GO TO B15c

20. B15c: "c) Cultural activities like music lessons, art lessons, dance lessons or drama lessons? (READ LIST.)" — Single select {1: "More than once a week", 2: "About once a week", 3: "Less than once a week", 4: "Never", 7: "Don't know", 8: "Refused"} — All → GO TO B16

21. B16: "In a typical week during the last school year, how often did ... participate in organized activities that were run by the school outside of school hours? This includes any activity such as sports teams, social clubs, music, band or school plays run by the school. (READ LIST.)" — Single select {01: "More than once a week", 02: "About once a week", 03: "Less than once a week", 04: "Never", 07: "Don't know", 08: "Refused"} — All → GO TO B17a

22. B17a: "Using the categories very often, often, sometimes and never, how often did ...'s parents/guardians ... a) Praise ... if he/she did well in school? (READ LIST.)" — Single select {1: "Very often", 2: "Often", 3: "Sometimes", 4: "Never", 7: "Don't know", 8: "Refused"} — All → GO TO B17b

23. B17b: "b) Praise ... for trying in school, even if he/she did not succeed? (READ LIST.)" — Single select {01: "Very often", 02: "Often", 03: "Sometimes", 04: "Never", 07: "Don't know", 08: "Refused"} — All → GO TO B17c

24. B17c: "c) Help ... with homework when he/she did not understand? (READ LIST.)" — Single select {1: "Very often", 2: "Often", 3: "Sometimes", 4: "Never", 7: "Don't know", 8: "Refused"} — All → GO TO B17d

25. B17d: "d) Remind ... to begin or complete homework? (READ LIST.)" — Single select {01: "Very often", 02: "Often", 03: "Sometimes", 04: "Never", 07: "Don't know", 08: "Refused"} — All → GO TO B17e

26. B17e: "e) Help ... plan his/her time for getting homework done? (READ LIST.)" — Single select {1: "Very often", 2: "Often", 3: "Sometimes", 4: "Never", 7: "Don't know", 8: "Refused"} — All → GO TO B17f

27. B17f: "f) Decide how much television ... could watch on school days? (READ LIST.)" — Single select {01: "Very often", 02: "Often", 03: "Sometimes", 04: "Never", 07: "Don't know", 08: "Refused"} — All → GO TO B17g

28. B17g: "g) Tell or remind ... that he/she was not working to his/her full potential or ability? (READ LIST.)" — Single select {1: "Very often", 2: "Often", 3: "Sometimes", 4: "Never", 7: "Don't know", 8: "Refused"} — All → GO TO B18

29. B18: "In general, how much time did ... spend doing homework? (READ LIST.)" — Single select {01: "A lot", 02: "A fair amount", 03: "Very little", 04: "None at all", 07: "Don't know", 08: "Refused"} — All → GO TO B19

30. B19: "How much leisure time did ...'s parents/guardians usually spend with him/her in a week? Leisure time means doing things together like playing a game, going shopping together, or other activities. (READ LIST.)" — Single select {1: "A lot", 2: "A fair amount", 3: "Very little", 4: "None at all", 7: "Don't know", 8: "Refused"} — All → GO TO B20

31. B20: "Now I'd like to ask you some questions about saving for ...'s post-secondary education. Post-secondary education includes college and university as well as apprenticeships, trade-vocational programs, CEGEPs or any other type of formal education after high school. Have you or anyone else living in your household ever saved money for ...'s post-secondary education?" — Single select {1: "Yes", 2: "No", 3: "Don't know", 4: "Refused"} — 1 (Yes) → GO TO B22; 2 (No) → GO TO B21; 3 (DK) → GO TO B21; 4 (R) → GO TO B21

32. B21: "Are you or anyone else living in your household planning to save or pay for ...'s post-secondary education?" — Single select {5: "Yes", 6: "No", 7: "Don't know", 8: "Refused"} — 5 (Yes) → GO TO B22; 6 (No) → GO TO B42; 7 (DK) → GO TO B42; 8 (R) → GO TO B42

33. B22: "If ... were to go on to post-secondary education, do his/her parents/guardians expect that he/she will live away from home?" — Single select {01: "Yes", 02: "No", 07: "Don't know", 08: "Refused"} — 01 (Yes) → GO TO B23; 02 (No) → GO TO B24; 07 (DK) → GO TO B24; 08 (R) → GO TO B24

34. B23: "Assuming that ... lives away from home, how much do his/her parents/guardians expect that the total cost of his/her education and living expenses would be?" — Numeric (dollar amount) — Amount/DK/R → GO TO B25

35. B24: "Assuming that ... lives at home, how much do his/her parents/guardians expect that the total cost of his/her education would be?" — Numeric (dollar amount) — Amount/DK/R → GO TO B25

36. B25a: "Do ...'s parents/guardians expect that he/she will pay for any part of his/her education costs himself/herself in the following ways: a) He/she will work before starting his/her post-secondary studies? This includes part-time jobs while in high school." — Single select {01: "Yes", 02: "No", 03: "Don't know", 04: "Refused"} — All → GO TO B25b

37. B25b: "b) He/she will work during his/her post-secondary studies? This includes part-time jobs, summer jobs or co-op work programs." — Single select {05: "Yes", 06: "No", 07: "Don't know", 08: "Refused"} — All → GO TO B25c

38. B25c: "c) He/she will interrupt his/her studies to work?" — Single select {09: "Yes", 10: "No", 11: "Don't know", 12: "Refused"} — All → GO TO B25d

39. B25d: "d) He/she will take out loans that will be repaid after his/her studies are finished?" — Single select {13: "Yes", 14: "No", 15: "Don't know", 16: "Refused"} — All → GO TO B26

40. B26: "Interviewer Check Item: Check B25d response." — Filter — B25d = Yes (13) → GO TO B27a; Otherwise → GO TO B28a

41. B27a: "Are the loans expected to be: a) Government student loans (federal or provincial)?" — Single select {01: "Yes", 02: "No", 03: "Don't know", 04: "Refused"} — All → GO TO B27b

42. B27b: "b) Non-student loans from a financial institution (e.g. bank, trust company, credit union)?" — Single select {05: "Yes", 06: "No", 07: "Don't know", 08: "Refused"} — All → GO TO B27c

43. B27c: "c) Loans from family or friends?" — Single select {09: "Yes", 10: "No", 11: "Don't know", 12: "Refused"} — All → GO TO B27d

44. B27d: "d) Other?" — Single select {13: "Yes", 14: "No", 15: "Don't know", 16: "Refused"} — All → GO TO B28a

45. B28a: "Do ...'s parents/guardians expect that they will pay for any part of his/her education costs in the following ways: a) Savings or investments they make before ... starts post-secondary studies?" — Single select {17: "Yes", 18: "No", 19: "Don't know", 20: "Refused"} — All → GO TO B28b

46. B28b: "b) Income they earn while ... is attending post-secondary?" — Single select {21: "Yes", 22: "No", 23: "Don't know", 24: "Refused"} — All → GO TO B28c

47. B28c: "c) Loans they take out and pay back after ... finishes post-secondary studies? This does not include loans taken out by ... such as a student loan." — Single select {25: "Yes", 26: "No", 27: "Don't know", 28: "Refused"} — All → GO TO B29a

48. B29a: "Do ...'s parents/guardians expect that any part of his/her post-secondary education will be paid for by the following sources? a) Scholarships or awards based on academic performance" — Single select {01: "Yes", 02: "No", 03: "Don't know", 04: "Refused"} — All → GO TO B29b

49. B29b: "b) Grants or bursaries based on financial need" — Single select {05: "Yes", 06: "No", 07: "Don't know", 08: "Refused"} — All → GO TO B29c

50. B29c: "c) Gifts or inheritances" — Single select {09: "Yes", 10: "No", 11: "Don't know", 12: "Refused"} — All → GO TO B30

51. B30: "Interviewer Check Item: Check B20 response." — Filter — B20 = Yes (1) → GO TO B31; Otherwise → GO TO B42

52. B31: "The following questions refer to savings that have been made for ...'s post-secondary education by anyone living in your household, including .... Do not include savings put aside by someone outside your household. How old was ... when these savings were first started?" — Numeric (0–18, years; if less than 1, enter 00) — DK/R available — All → GO TO B32

53. B32: "How much money was saved for ...'s post-secondary education in 1998? Do not include any earnings or interest." — Numeric (dollar amount) — DK/R available — All → GO TO B33

54. B33: "How much money has been saved for ...'s post-secondary education so far in 1999? Do not include any earnings or interest." — Numeric (dollar amount) — DK/R available — All → GO TO B34

55. B34: "How much money will be saved for ... in the rest of 1999?" — Numeric (dollar amount) — DK/R available — All → GO TO B35

56. B35: "Since starting to save for ..., how much in total has been saved for his/her post-secondary education? Do not include any earnings or interest." — Numeric (dollar amount) — DK/R available — All → GO TO B36

57. B36: "How much do you expect to have saved for ...'s education by the time he/she starts post-secondary studies? Include all earnings and interest." — Numeric (dollar amount) — DK/R available — All → GO TO B37a

58. B37a: "What types of savings plans are being used to save for ...'s post-secondary education? a) RESPs (Registered Education Savings Plans)" — Single select {01: "Yes", 02: "No", 03: "Don't know", 04: "Refused"} — All → GO TO B37b

59. B37b: "b) RRSPs (Registered Retirement Savings Plans)" — Single select {05: "Yes", 06: "No", 07: "Don't know", 08: "Refused"} — All → GO TO B37c

60. B37c: "c) 'In-trust for' accounts" — Single select {09: "Yes", 10: "No", 11: "Don't know", 12: "Refused"} — All → GO TO B37d

61. B37d: "d) Other" — Single select {13: "Yes", 14: "No", 15: "Don't know", 16: "Refused"} — If B37a,b,c,d ALL = No/DK/R → GO TO B42; Otherwise → GO TO B38a

62. B38a: "Within these plans, how are the savings invested? a) Mutual funds" — Single select {17: "Yes", 18: "No", 19: "Don't know", 20: "Refused"} — All → GO TO B38b

63. B38b: "b) Shares of corporations" — Single select {21: "Yes", 22: "No", 23: "Don't know", 24: "Refused"} — All → GO TO B38c

64. B38c: "c) Savings or chequing accounts" — Single select {25: "Yes", 26: "No", 27: "Don't know", 28: "Refused"} — All → GO TO B38d

65. B38d: "d) Savings bonds" — Single select {29: "Yes", 30: "No", 31: "Don't know", 32: "Refused"} — All → GO TO B38e

66. B38e: "e) Other" — Single select {33: "Yes", 34: "No", 35: "Don't know", 36: "Refused"} — All → GO TO B39

67. B39: "Interviewer Check Item: Check B37a response." — Filter — B37a = Yes (01) → GO TO B40; Otherwise → GO TO B42

68. B40: "For the RESP only, how much money in total has been contributed to RESPs for ... by people living in your household?" — Numeric (dollar amount) — DK/R available — All → GO TO B41a

69. B41a: "Which types of RESPs are being used? a) Individual plan (includes individual non-family and family RESPs)" — Single select {01: "Yes", 02: "No", 03: "Don't know", 04: "Refused"} — All → GO TO B41b

70. B41b: "b) Group plan (education scholarship trust or foundation)" — Single select {05: "Yes", 06: "No", 07: "Don't know", 08: "Refused"} — All → GO TO B42

71. B42: "Does anyone who does not live in your household have savings put aside for ...'s post-secondary education?" — Single select {1: "Yes", 2: "No", 7: "Don't know", 8: "Refused"} — 1 (Yes) → GO TO B43; 2 (No) → GO TO B44; 7 (DK) → GO TO B44; 8 (R) → GO TO B44

72. B43: "How much money in total have the people who don't live in your household put aside for ...'s post-secondary education?" — Numeric (dollar amount) — DK/R available — All → GO TO B44

73. B44: "Interviewer Check Item: Check number of children in household." — Filter — More than 1 child → GO TO Section C (Child 2); Otherwise → GO TO Section F

### Section C — Child 2: General Questions — 70 items

*Section C is structurally identical to Section B, applied to the second selected child. All routing targets use C-prefixes. Terminal routing: C44 sends to Section D if >2 children, otherwise to Section F.*

**Child 2 Info Block**: First Name (Text), Sex {1: "Male", 2: "Female"}, Age in years (Numeric; if less than 1 year, enter 00)

74. C1: "Now I am going to ask you some questions about ... (name of CHILD 2). What is ...'s relationship to you?" — Single select {1: "Son/daughter (biological, adoptive, stepchild)", 2: "Foster child", 3: "Grandchild", 4: "Brother/sister", 5: "Other family member or relative", 6: "Unrelated"} — All → GO TO C2

75. C2: "Does ... have any long-term conditions or health problems which prevent or limit his/her participation in school, at play, or in any other activity for a child of his/her age?" — Single select {01: "Yes", 02: "No", 07: "Don't know", 08: "Refused"} — All → GO TO C3

76. C3: "How far do ...'s parents/guardians hope that he/she will go in school?" — Single select {1: "Primary school", 2: "Secondary or high school", 3: "Community college, technical college or CEGEP", 4: "University", 5: "Learn a trade", 7: "Don't know", 8: "Refused"} — All → GO TO C4

77. C4: "Interviewer Check Item: Check age of child." — Filter — Age 00–04 → GO TO C20; Age 05–08 → GO TO C6; Age 09+ → GO TO C5

78. C5: "How far do ...'s parents/guardians expect that he/she will go in school?" — Single select {1: "Primary school", 2: "Secondary or high school", 3: "Community college, technical college or CEGEP", 4: "University", 5: "Learn a trade", 7: "Don't know", 8: "Refused"} — All → GO TO C6

79. C6: "Did ... attend school last year? (include home schooling)" — Single select {01: "Yes", 02: "No", 07: "Don't know", 08: "Refused"} — 01 (Yes) → GO TO C9; 02 (No) → GO TO C7; 07 (DK) → GO TO C20; 08 (R) → GO TO C20

80. C7: "Why did ... not attend school last year?" — Single select {1: "Too young for school", 2: "Physical, mental, emotional or behavioral problem", 3: "Left school before graduating", 4: "Graduated from school", 5: "Other - Specify"} — 1 → GO TO C20; 2 → GO TO C20; 3 → GO TO C8; 4 → GO TO C8; 5 → GO TO C8

81. C8: "In what grade was ... last enrolled?" — Single select {01: "Junior kindergarten", 02: "Kindergarten", 03: "Grade 1", 04: "Grade 2", 05: "Grade 3", 06: "Grade 4", 07: "Grade 5", 08: "Grade 6", 09: "Grade 7 (Quebec = Sec 1)", 10: "Grade 8 (Quebec = Sec 2)", 11: "Grade 9 (Quebec = Sec 3)", 12: "Grade 10 (Quebec = Sec 4)", 13: "Grade 11 (Quebec = Sec 5)", 14: "Grade 12", 15: "OAC Grade 13 (Ontario)", 16: "Ungraded", 17: "CEGEP tech 1st yr", 18: "CEGEP tech 2nd yr", 19: "CEGEP tech 3rd yr", 20: "CEGEP acad 1st yr", 21: "CEGEP acad 2nd yr", 22: "CEGEP acad 3rd yr", 23: "University 1st yr", 24: "University 2nd yr", 25: "University 3rd yr", 26: "Apprenticeship 1st yr", 27: "Apprenticeship 2nd yr", 28: "Apprenticeship 3rd yr", 29: "Trades-tech 1st yr", 30: "Trades-tech 2nd yr", 31: "Trades-tech 3rd yr", 32: "Other", 33: "N/A", 97: "Don't know", 98: "Refused"} — All → GO TO C20

82. C9: "In what grade was he/she enrolled last year?" — Single select {34: "Junior kindergarten", 35: "Kindergarten", 36: "Grade 1", 37: "Grade 2", 38: "Grade 3", 39: "Grade 4", 40: "Grade 5", 41: "Grade 6", 42: "Grade 7 (Quebec = Sec 1)", 43: "Grade 8 (Quebec = Sec 2)", 44: "Grade 9 (Quebec = Sec 3)", 45: "Grade 10 (Quebec = Sec 4)", 46: "Grade 11 (Quebec = Sec 5)", 47: "Grade 12", 48: "OAC Grade 13 (Ontario)", 49: "Ungraded", 50: "CEGEP tech 1st yr", 51: "CEGEP tech 2nd yr", 52: "CEGEP tech 3rd yr", 53: "CEGEP acad 1st yr", 54: "CEGEP acad 2nd yr", 55: "CEGEP acad 3rd yr", 56: "University 1st yr", 57: "University 2nd yr", 58: "University 3rd yr", 59: "Apprenticeship 1st yr", 60: "Apprenticeship 2nd yr", 61: "Apprenticeship 3rd yr", 62: "Trades-tech 1st yr", 63: "Trades-tech 2nd yr", 64: "Trades-tech 3rd yr", 65: "Other", 66: "N/A", 97: "Don't know", 98: "Refused"} — 34–35 (Jr K, K) → GO TO C20; 36–49 (Grades 1–13, Ungraded) → GO TO C10; 50–64 (post-secondary) → GO TO C20; 65, 66, 97, 98 → GO TO C10

83. C10: "Based on your knowledge of ...'s schoolwork, including report cards, how did he/she do overall in school? (READ LIST.)" — Single select {01: "Above average", 02: "Average", 03: "Below average", 07: "Don't know", 08: "Refused"} — All → GO TO C11

84. C11: "How did ... feel about his/her schoolwork? (READ LIST.)" — Single select {1: "Liked it very much", 2: "Liked it", 3: "Neither liked nor disliked it", 4: "Disliked it", 5: "Disliked it very much", 7: "Don't know", 8: "Refused"} — All → GO TO C12

85. C12: "Overall, did ...'s close friends do well in their schoolwork?" — Single select {01: "Yes", 02: "No", 07: "Don't know", 08: "Refused"} — All → GO TO C13

86. C13: "How often were ...'s parents/guardians in contact with his/her teachers to discuss his/her academic performance or behaviour? (READ LIST.)" — Single select {1: "Often", 2: "A few times", 3: "Once", 4: "Never", 7: "Don't know", 8: "Refused"} — All → GO TO C14

87. C14: "Did ...'s parents/guardians set aside a place in the home for him/her to use for studying or doing homework?" — Single select {01: "Yes", 02: "No", 07: "Don't know", 08: "Refused"} — All → GO TO C15a

88. C15a: "a) Sports or physical activities like Little League, swim club or hockey league? (READ LIST.)" — Single select {1: "More than once a week", 2: "About once a week", 3: "Less than once a week", 4: "Never", 7: "Don't know", 8: "Refused"} — All → GO TO C15b

89. C15b: "b) Social club activities like scouts, girl guides, boys and girls clubs or church groups? (READ LIST.)" — Single select {01: "More than once a week", 02: "About once a week", 03: "Less than once a week", 04: "Never", 07: "Don't know", 08: "Refused"} — All → GO TO C15c

90. C15c: "c) Cultural activities like music lessons, art lessons, dance lessons or drama lessons? (READ LIST.)" — Single select {1: "More than once a week", 2: "About once a week", 3: "Less than once a week", 4: "Never", 7: "Don't know", 8: "Refused"} — All → GO TO C16

91. C16: "How often did ... participate in organized activities run by the school outside of school hours? (READ LIST.)" — Single select {01: "More than once a week", 02: "About once a week", 03: "Less than once a week", 04: "Never", 07: "Don't know", 08: "Refused"} — All → GO TO C17a

92. C17a: "a) Praise ... if he/she did well in school? (READ LIST.)" — Single select {1: "Very often", 2: "Often", 3: "Sometimes", 4: "Never", 7: "Don't know", 8: "Refused"} — All → GO TO C17b

93. C17b: "b) Praise ... for trying in school, even if he/she did not succeed? (READ LIST.)" — Single select {01: "Very often", 02: "Often", 03: "Sometimes", 04: "Never", 07: "Don't know", 08: "Refused"} — All → GO TO C17c

94. C17c: "c) Help ... with homework when he/she did not understand? (READ LIST.)" — Single select {1: "Very often", 2: "Often", 3: "Sometimes", 4: "Never", 7: "Don't know", 8: "Refused"} — All → GO TO C17d

95. C17d: "d) Remind ... to begin or complete homework? (READ LIST.)" — Single select {01: "Very often", 02: "Often", 03: "Sometimes", 04: "Never", 07: "Don't know", 08: "Refused"} — All → GO TO C17e

96. C17e: "e) Help ... plan his/her time for getting homework done? (READ LIST.)" — Single select {1: "Very often", 2: "Often", 3: "Sometimes", 4: "Never", 7: "Don't know", 8: "Refused"} — All → GO TO C17f

97. C17f: "f) Decide how much television ... could watch on school days? (READ LIST.)" — Single select {01: "Very often", 02: "Often", 03: "Sometimes", 04: "Never", 07: "Don't know", 08: "Refused"} — All → GO TO C17g

98. C17g: "g) Tell or remind ... that he/she was not working to his/her full potential or ability? (READ LIST.)" — Single select {1: "Very often", 2: "Often", 3: "Sometimes", 4: "Never", 7: "Don't know", 8: "Refused"} — All → GO TO C18

99. C18: "In general, how much time did ... spend doing homework? (READ LIST.)" — Single select {01: "A lot", 02: "A fair amount", 03: "Very little", 04: "None at all", 07: "Don't know", 08: "Refused"} — All → GO TO C19

100. C19: "How much leisure time did ...'s parents/guardians usually spend with him/her in a week? (READ LIST.)" — Single select {1: "A lot", 2: "A fair amount", 3: "Very little", 4: "None at all", 7: "Don't know", 8: "Refused"} — All → GO TO C20

101. C20: "Have you or anyone else living in your household ever saved money for ...'s post-secondary education?" — Single select {1: "Yes", 2: "No", 3: "Don't know", 4: "Refused"} — 1 (Yes) → GO TO C22; 2 (No) → GO TO C21; 3 (DK) → GO TO C21; 4 (R) → GO TO C21

102. C21: "Are you or anyone else living in your household planning to save or pay for ...'s post-secondary education?" — Single select {5: "Yes", 6: "No", 7: "Don't know", 8: "Refused"} — 5 (Yes) → GO TO C22; 6 (No) → GO TO C42; 7 (DK) → GO TO C42; 8 (R) → GO TO C42

103. C22: "If ... were to go on to post-secondary education, do his/her parents/guardians expect that he/she will live away from home?" — Single select {01: "Yes", 02: "No", 07: "Don't know", 08: "Refused"} — 01 (Yes) → GO TO C23; 02 (No) → GO TO C24; 07 (DK) → GO TO C24; 08 (R) → GO TO C24

104. C23: "Assuming that ... lives away from home, how much do his/her parents/guardians expect that the total cost of his/her education and living expenses would be?" — Numeric (dollar amount) — Amount/DK/R → GO TO C25a

105. C24: "Assuming that ... lives at home, how much do his/her parents/guardians expect that the total cost of his/her education would be?" — Numeric (dollar amount) — Amount/DK/R → GO TO C25a

106. C25a: "a) He/she will work before starting his/her post-secondary studies?" — Single select {01: "Yes", 02: "No", 03: "Don't know", 04: "Refused"} — All → GO TO C25b

107. C25b: "b) He/she will work during his/her post-secondary studies?" — Single select {05: "Yes", 06: "No", 07: "Don't know", 08: "Refused"} — All → GO TO C25c

108. C25c: "c) He/she will interrupt his/her studies to work?" — Single select {09: "Yes", 10: "No", 11: "Don't know", 12: "Refused"} — All → GO TO C25d

109. C25d: "d) He/she will take out loans that will be repaid after his/her studies are finished?" — Single select {13: "Yes", 14: "No", 15: "Don't know", 16: "Refused"} — All → GO TO C26

110. C26: "Interviewer Check Item: Check C25d response." — Filter — C25d = Yes (13) → GO TO C27a; Otherwise → GO TO C28a

111. C27a: "a) Government student loans (federal or provincial)?" — Single select {01: "Yes", 02: "No", 03: "Don't know", 04: "Refused"} — All → GO TO C27b

112. C27b: "b) Non-student loans from a financial institution?" — Single select {05: "Yes", 06: "No", 07: "Don't know", 08: "Refused"} — All → GO TO C27c

113. C27c: "c) Loans from family or friends?" — Single select {09: "Yes", 10: "No", 11: "Don't know", 12: "Refused"} — All → GO TO C27d

114. C27d: "d) Other?" — Single select {13: "Yes", 14: "No", 15: "Don't know", 16: "Refused"} — All → GO TO C28a

115. C28a: "a) Savings or investments they make before ... starts post-secondary studies?" — Single select {17: "Yes", 18: "No", 19: "Don't know", 20: "Refused"} — All → GO TO C28b

116. C28b: "b) Income they earn while ... is attending post-secondary?" — Single select {21: "Yes", 22: "No", 23: "Don't know", 24: "Refused"} — All → GO TO C28c

117. C28c: "c) Loans they take out and pay back after ... finishes post-secondary studies?" — Single select {25: "Yes", 26: "No", 27: "Don't know", 28: "Refused"} — All → GO TO C29a

118. C29a: "a) Scholarships or awards based on academic performance" — Single select {01: "Yes", 02: "No", 03: "Don't know", 04: "Refused"} — All → GO TO C29b

119. C29b: "b) Grants or bursaries based on financial need" — Single select {05: "Yes", 06: "No", 07: "Don't know", 08: "Refused"} — All → GO TO C29c

120. C29c: "c) Gifts or inheritances" — Single select {09: "Yes", 10: "No", 11: "Don't know", 12: "Refused"} — All → GO TO C30

121. C30: "Interviewer Check Item: Check C20 response." — Filter — C20 = Yes (1) → GO TO C31; Otherwise → GO TO C42

122. C31: "How old was ... when these savings were first started?" — Numeric (0–18, years) — DK/R available — All → GO TO C32

123. C32: "How much money was saved for ...'s post-secondary education in 1998?" — Numeric (dollar amount) — DK/R available — All → GO TO C33

124. C33: "How much money has been saved for ...'s post-secondary education so far in 1999?" — Numeric (dollar amount) — DK/R available — All → GO TO C34

125. C34: "How much money will be saved for ... in the rest of 1999?" — Numeric (dollar amount) — DK/R available — All → GO TO C35

126. C35: "Since starting to save for ..., how much in total has been saved for his/her post-secondary education?" — Numeric (dollar amount) — DK/R available — All → GO TO C36

127. C36: "How much do you expect to have saved for ...'s education by the time he/she starts post-secondary studies?" — Numeric (dollar amount) — DK/R available — All → GO TO C37a

128. C37a: "a) RESPs (Registered Education Savings Plans)" — Single select {01: "Yes", 02: "No", 03: "Don't know", 04: "Refused"} — All → GO TO C37b

129. C37b: "b) RRSPs (Registered Retirement Savings Plans)" — Single select {05: "Yes", 06: "No", 07: "Don't know", 08: "Refused"} — All → GO TO C37c

130. C37c: "c) 'In-trust for' accounts" — Single select {09: "Yes", 10: "No", 11: "Don't know", 12: "Refused"} — All → GO TO C37d

131. C37d: "d) Other" — Single select {13: "Yes", 14: "No", 15: "Don't know", 16: "Refused"} — If C37a,b,c,d ALL = No/DK/R → GO TO C42; Otherwise → GO TO C38a

132. C38a: "a) Mutual funds" — Single select {17: "Yes", 18: "No", 19: "Don't know", 20: "Refused"} — All → GO TO C38b

133. C38b: "b) Shares of corporations" — Single select {21: "Yes", 22: "No", 23: "Don't know", 24: "Refused"} — All → GO TO C38c

134. C38c: "c) Savings or chequing accounts" — Single select {25: "Yes", 26: "No", 27: "Don't know", 28: "Refused"} — All → GO TO C38d

135. C38d: "d) Savings bonds" — Single select {29: "Yes", 30: "No", 31: "Don't know", 32: "Refused"} — All → GO TO C38e

136. C38e: "e) Other" — Single select {33: "Yes", 34: "No", 35: "Don't know", 36: "Refused"} — All → GO TO C39

137. C39: "Interviewer Check Item: Check C37a response." — Filter — C37a = Yes (01) → GO TO C40; Otherwise → GO TO C42

138. C40: "For the RESP only, how much money in total has been contributed to RESPs for ... by people living in your household?" — Numeric (dollar amount) — DK/R available — All → GO TO C41a

139. C41a: "a) Individual plan (includes individual non-family and family RESPs)" — Single select {01: "Yes", 02: "No", 03: "Don't know", 04: "Refused"} — All → GO TO C41b

140. C41b: "b) Group plan (education scholarship trust or foundation)" — Single select {05: "Yes", 06: "No", 07: "Don't know", 08: "Refused"} — All → GO TO C42

141. C42: "Does anyone who does not live in your household have savings put aside for ...'s post-secondary education?" — Single select {1: "Yes", 2: "No", 7: "Don't know", 8: "Refused"} — 1 (Yes) → GO TO C43; 2 (No) → GO TO C44; 7 (DK) → GO TO C44; 8 (R) → GO TO C44

142. C43: "How much money in total have the people who don't live in your household put aside for ...'s post-secondary education?" — Numeric (dollar amount) — DK/R available — All → GO TO C44

143. C44: "Interviewer Check Item: Check number of children in household." — Filter — More than 2 children → GO TO Section D (Child 3); Otherwise → GO TO Section F

### Section D — Child 3: General Questions — 70 items

*Section D is structurally identical to Sections B and C, applied to the third selected child. All routing targets use D-prefixes. Terminal routing: D44 sends to Section E if >3 children, otherwise to Section F.*

**Child 3 Info Block**: First Name (Text), Sex {1: "Male", 2: "Female"}, Age in years (Numeric; if less than 1 year, enter 00)

144. D1: "Now I am going to ask you some questions about ... (name of CHILD 3). What is ...'s relationship to you?" — Single select {1: "Son/daughter (biological, adoptive, stepchild)", 2: "Foster child", 3: "Grandchild", 4: "Brother/sister", 5: "Other family member or relative", 6: "Unrelated"} — All → GO TO D2

145. D2: "Does ... have any long-term conditions or health problems which prevent or limit his/her participation in school, at play, or in any other activity for a child of his/her age?" — Single select {01: "Yes", 02: "No", 07: "Don't know", 08: "Refused"} — All → GO TO D3

146. D3: "How far do ...'s parents/guardians hope that he/she will go in school?" — Single select {1: "Primary school", 2: "Secondary or high school", 3: "Community college, technical college or CEGEP", 4: "University", 5: "Learn a trade", 7: "Don't know", 8: "Refused"} — All → GO TO D4

147. D4: "Interviewer Check Item: Check age of child." — Filter — Age 00–04 → GO TO D20; Age 05–08 → GO TO D6; Age 09+ → GO TO D5

148. D5: "How far do ...'s parents/guardians expect that he/she will go in school?" — Single select {1: "Primary school", 2: "Secondary or high school", 3: "Community college, technical college or CEGEP", 4: "University", 5: "Learn a trade", 7: "Don't know", 8: "Refused"} — All → GO TO D6

149. D6: "Did ... attend school last year? (include home schooling)" — Single select {01: "Yes", 02: "No", 07: "Don't know", 08: "Refused"} — 01 (Yes) → GO TO D9; 02 (No) → GO TO D7; 07 (DK) → GO TO D20; 08 (R) → GO TO D20

150. D7: "Why did ... not attend school last year?" — Single select {1: "Too young for school", 2: "Physical, mental, emotional or behavioral problem", 3: "Left school before graduating", 4: "Graduated from school", 5: "Other - Specify"} — 1 → GO TO D20; 2 → GO TO D20; 3 → GO TO D8; 4 → GO TO D8; 5 → GO TO D8

151. D8: "In what grade was ... last enrolled?" — Single select {01: "Junior kindergarten", 02: "Kindergarten", 03: "Grade 1", 04: "Grade 2", 05: "Grade 3", 06: "Grade 4", 07: "Grade 5", 08: "Grade 6", 09: "Grade 7 (Quebec = Sec 1)", 10: "Grade 8 (Quebec = Sec 2)", 11: "Grade 9 (Quebec = Sec 3)", 12: "Grade 10 (Quebec = Sec 4)", 13: "Grade 11 (Quebec = Sec 5)", 14: "Grade 12", 15: "OAC Grade 13 (Ontario)", 16: "Ungraded", 17: "CEGEP tech 1st yr", 18: "CEGEP tech 2nd yr", 19: "CEGEP tech 3rd yr", 20: "CEGEP acad 1st yr", 21: "CEGEP acad 2nd yr", 22: "CEGEP acad 3rd yr", 23: "University 1st yr", 24: "University 2nd yr", 25: "University 3rd yr", 26: "Apprenticeship 1st yr", 27: "Apprenticeship 2nd yr", 28: "Apprenticeship 3rd yr", 29: "Trades-tech 1st yr", 30: "Trades-tech 2nd yr", 31: "Trades-tech 3rd yr", 32: "Other", 33: "N/A", 97: "Don't know", 98: "Refused"} — All → GO TO D20

152. D9: "In what grade was he/she enrolled last year?" — Single select {34: "Junior kindergarten", 35: "Kindergarten", 36: "Grade 1", 37: "Grade 2", 38: "Grade 3", 39: "Grade 4", 40: "Grade 5", 41: "Grade 6", 42: "Grade 7 (Quebec = Sec 1)", 43: "Grade 8 (Quebec = Sec 2)", 44: "Grade 9 (Quebec = Sec 3)", 45: "Grade 10 (Quebec = Sec 4)", 46: "Grade 11 (Quebec = Sec 5)", 47: "Grade 12", 48: "OAC Grade 13 (Ontario)", 49: "Ungraded", 50: "CEGEP tech 1st yr", 51: "CEGEP tech 2nd yr", 52: "CEGEP tech 3rd yr", 53: "CEGEP acad 1st yr", 54: "CEGEP acad 2nd yr", 55: "CEGEP acad 3rd yr", 56: "University 1st yr", 57: "University 2nd yr", 58: "University 3rd yr", 59: "Apprenticeship 1st yr", 60: "Apprenticeship 2nd yr", 61: "Apprenticeship 3rd yr", 62: "Trades-tech 1st yr", 63: "Trades-tech 2nd yr", 64: "Trades-tech 3rd yr", 65: "Other", 66: "N/A", 97: "Don't know", 98: "Refused"} — 34–35 (Jr K, K) → GO TO D20; 36–49 (Grades 1–13, Ungraded) → GO TO D10; 50–64 (post-secondary) → GO TO D20; 65, 66, 97, 98 → GO TO D10

153. D10: "Based on your knowledge of ...'s schoolwork, including report cards, how did he/she do overall in school? (READ LIST.)" — Single select {01: "Above average", 02: "Average", 03: "Below average", 07: "Don't know", 08: "Refused"} — All → GO TO D11

154. D11: "How did ... feel about his/her schoolwork? (READ LIST.)" — Single select {1: "Liked it very much", 2: "Liked it", 3: "Neither liked nor disliked it", 4: "Disliked it", 5: "Disliked it very much", 7: "Don't know", 8: "Refused"} — All → GO TO D12

155. D12: "Overall, did ...'s close friends do well in their schoolwork?" — Single select {01: "Yes", 02: "No", 07: "Don't know", 08: "Refused"} — All → GO TO D13

156. D13: "How often were ...'s parents/guardians in contact with his/her teachers? (READ LIST.)" — Single select {1: "Often", 2: "A few times", 3: "Once", 4: "Never", 7: "Don't know", 8: "Refused"} — All → GO TO D14

157. D14: "Did ...'s parents/guardians set aside a place in the home for studying or doing homework?" — Single select {01: "Yes", 02: "No", 07: "Don't know", 08: "Refused"} — All → GO TO D15a

158. D15a: "a) Sports or physical activities? (READ LIST.)" — Single select {1: "More than once a week", 2: "About once a week", 3: "Less than once a week", 4: "Never", 7: "Don't know", 8: "Refused"} — All → GO TO D15b

159. D15b: "b) Social club activities? (READ LIST.)" — Single select {01: "More than once a week", 02: "About once a week", 03: "Less than once a week", 04: "Never", 07: "Don't know", 08: "Refused"} — All → GO TO D15c

160. D15c: "c) Cultural activities? (READ LIST.)" — Single select {1: "More than once a week", 2: "About once a week", 3: "Less than once a week", 4: "Never", 7: "Don't know", 8: "Refused"} — All → GO TO D16

161. D16: "How often did ... participate in organized school-run activities outside of school hours? (READ LIST.)" — Single select {01: "More than once a week", 02: "About once a week", 03: "Less than once a week", 04: "Never", 07: "Don't know", 08: "Refused"} — All → GO TO D17a

162. D17a: "a) Praise ... if he/she did well in school? (READ LIST.)" — Single select {1: "Very often", 2: "Often", 3: "Sometimes", 4: "Never", 7: "Don't know", 8: "Refused"} — All → GO TO D17b

163. D17b: "b) Praise ... for trying in school? (READ LIST.)" — Single select {01: "Very often", 02: "Often", 03: "Sometimes", 04: "Never", 07: "Don't know", 08: "Refused"} — All → GO TO D17c

164. D17c: "c) Help ... with homework? (READ LIST.)" — Single select {1: "Very often", 2: "Often", 3: "Sometimes", 4: "Never", 7: "Don't know", 8: "Refused"} — All → GO TO D17d

165. D17d: "d) Remind ... to begin or complete homework? (READ LIST.)" — Single select {01: "Very often", 02: "Often", 03: "Sometimes", 04: "Never", 07: "Don't know", 08: "Refused"} — All → GO TO D17e

166. D17e: "e) Help ... plan his/her time for homework? (READ LIST.)" — Single select {1: "Very often", 2: "Often", 3: "Sometimes", 4: "Never", 7: "Don't know", 8: "Refused"} — All → GO TO D17f

167. D17f: "f) Decide how much television ... could watch on school days? (READ LIST.)" — Single select {01: "Very often", 02: "Often", 03: "Sometimes", 04: "Never", 07: "Don't know", 08: "Refused"} — All → GO TO D17g

168. D17g: "g) Tell or remind ... that he/she was not working to full potential? (READ LIST.)" — Single select {1: "Very often", 2: "Often", 3: "Sometimes", 4: "Never", 7: "Don't know", 8: "Refused"} — All → GO TO D18

169. D18: "In general, how much time did ... spend doing homework? (READ LIST.)" — Single select {01: "A lot", 02: "A fair amount", 03: "Very little", 04: "None at all", 07: "Don't know", 08: "Refused"} — All → GO TO D19

170. D19: "How much leisure time did ...'s parents/guardians usually spend with him/her in a week? (READ LIST.)" — Single select {1: "A lot", 2: "A fair amount", 3: "Very little", 4: "None at all", 7: "Don't know", 8: "Refused"} — All → GO TO D20

171. D20: "Have you or anyone else living in your household ever saved money for ...'s post-secondary education?" — Single select {1: "Yes", 2: "No", 3: "Don't know", 4: "Refused"} — 1 (Yes) → GO TO D22; 2 (No) → GO TO D21; 3 (DK) → GO TO D21; 4 (R) → GO TO D21

172. D21: "Are you or anyone else living in your household planning to save or pay for ...'s post-secondary education?" — Single select {5: "Yes", 6: "No", 7: "Don't know", 8: "Refused"} — 5 (Yes) → GO TO D22; 6 (No) → GO TO D42; 7 (DK) → GO TO D42; 8 (R) → GO TO D42

173. D22: "Do his/her parents/guardians expect that he/she will live away from home?" — Single select {01: "Yes", 02: "No", 07: "Don't know", 08: "Refused"} — 01 (Yes) → GO TO D23; 02 (No) → GO TO D24; 07 (DK) → GO TO D24; 08 (R) → GO TO D24

174. D23: "Assuming ... lives away from home, how much do parents/guardians expect the total cost of education and living expenses would be?" — Numeric (dollar amount) — Amount/DK/R → GO TO D25a

175. D24: "Assuming ... lives at home, how much do parents/guardians expect the total cost of education would be?" — Numeric (dollar amount) — Amount/DK/R → GO TO D25a

176. D25a: "a) He/she will work before starting post-secondary studies?" — Single select {01: "Yes", 02: "No", 03: "Don't know", 04: "Refused"} — All → GO TO D25b

177. D25b: "b) He/she will work during post-secondary studies?" — Single select {05: "Yes", 06: "No", 07: "Don't know", 08: "Refused"} — All → GO TO D25c

178. D25c: "c) He/she will interrupt studies to work?" — Single select {09: "Yes", 10: "No", 11: "Don't know", 12: "Refused"} — All → GO TO D25d

179. D25d: "d) He/she will take out loans?" — Single select {13: "Yes", 14: "No", 15: "Don't know", 16: "Refused"} — All → GO TO D26

180. D26: "Interviewer Check Item: Check D25d response." — Filter — D25d = Yes (13) → GO TO D27a; Otherwise → GO TO D28a

181. D27a: "a) Government student loans?" — Single select {01: "Yes", 02: "No", 03: "Don't know", 04: "Refused"} — All → GO TO D27b

182. D27b: "b) Non-student loans from a financial institution?" — Single select {05: "Yes", 06: "No", 07: "Don't know", 08: "Refused"} — All → GO TO D27c

183. D27c: "c) Loans from family or friends?" — Single select {09: "Yes", 10: "No", 11: "Don't know", 12: "Refused"} — All → GO TO D27d

184. D27d: "d) Other?" — Single select {13: "Yes", 14: "No", 15: "Don't know", 16: "Refused"} — All → GO TO D28a

185. D28a: "a) Savings or investments before ... starts post-secondary?" — Single select {17: "Yes", 18: "No", 19: "Don't know", 20: "Refused"} — All → GO TO D28b

186. D28b: "b) Income while ... is attending post-secondary?" — Single select {21: "Yes", 22: "No", 23: "Don't know", 24: "Refused"} — All → GO TO D28c

187. D28c: "c) Loans they take out and pay back after ... finishes?" — Single select {25: "Yes", 26: "No", 27: "Don't know", 28: "Refused"} — All → GO TO D29a

188. D29a: "a) Scholarships or awards based on academic performance" — Single select {01: "Yes", 02: "No", 03: "Don't know", 04: "Refused"} — All → GO TO D29b

189. D29b: "b) Grants or bursaries based on financial need" — Single select {05: "Yes", 06: "No", 07: "Don't know", 08: "Refused"} — All → GO TO D29c

190. D29c: "c) Gifts or inheritances" — Single select {09: "Yes", 10: "No", 11: "Don't know", 12: "Refused"} — All → GO TO D30

191. D30: "Interviewer Check Item: Check D20 response." — Filter — D20 = Yes (1) → GO TO D31; Otherwise → GO TO D42

192. D31: "How old was ... when these savings were first started?" — Numeric (0–18, years) — DK/R available — All → GO TO D32

193. D32: "How much money was saved for ...'s post-secondary education in 1998?" — Numeric (dollar amount) — DK/R available — All → GO TO D33

194. D33: "How much money has been saved so far in 1999?" — Numeric (dollar amount) — DK/R available — All → GO TO D34

195. D34: "How much money will be saved in the rest of 1999?" — Numeric (dollar amount) — DK/R available — All → GO TO D35

196. D35: "Since starting to save, how much in total has been saved?" — Numeric (dollar amount) — DK/R available — All → GO TO D36

197. D36: "How much do you expect to have saved by the time he/she starts post-secondary studies?" — Numeric (dollar amount) — DK/R available — All → GO TO D37a

198. D37a: "a) RESPs (Registered Education Savings Plans)" — Single select {01: "Yes", 02: "No", 03: "Don't know", 04: "Refused"} — All → GO TO D37b

199. D37b: "b) RRSPs (Registered Retirement Savings Plans)" — Single select {05: "Yes", 06: "No", 07: "Don't know", 08: "Refused"} — All → GO TO D37c

200. D37c: "c) 'In-trust for' accounts" — Single select {09: "Yes", 10: "No", 11: "Don't know", 12: "Refused"} — All → GO TO D37d

201. D37d: "d) Other" — Single select {13: "Yes", 14: "No", 15: "Don't know", 16: "Refused"} — If D37a,b,c,d ALL = No/DK/R → GO TO D42; Otherwise → GO TO D38a

202. D38a: "a) Mutual funds" — Single select {17: "Yes", 18: "No", 19: "Don't know", 20: "Refused"} — All → GO TO D38b

203. D38b: "b) Shares of corporations" — Single select {21: "Yes", 22: "No", 23: "Don't know", 24: "Refused"} — All → GO TO D38c

204. D38c: "c) Savings or chequing accounts" — Single select {25: "Yes", 26: "No", 27: "Don't know", 28: "Refused"} — All → GO TO D38d

205. D38d: "d) Savings bonds" — Single select {29: "Yes", 30: "No", 31: "Don't know", 32: "Refused"} — All → GO TO D38e

206. D38e: "e) Other" — Single select {33: "Yes", 34: "No", 35: "Don't know", 36: "Refused"} — All → GO TO D39

207. D39: "Interviewer Check Item: Check D37a response." — Filter — D37a = Yes (01) → GO TO D40; Otherwise → GO TO D42

208. D40: "For the RESP only, how much money in total has been contributed to RESPs for ...?" — Numeric (dollar amount) — DK/R available — All → GO TO D41a

209. D41a: "a) Individual plan (includes individual non-family and family RESPs)" — Single select {01: "Yes", 02: "No", 03: "Don't know", 04: "Refused"} — All → GO TO D41b

210. D41b: "b) Group plan (education scholarship trust or foundation)" — Single select {05: "Yes", 06: "No", 07: "Don't know", 08: "Refused"} — All → GO TO D42

211. D42: "Does anyone who does not live in your household have savings put aside for ...'s post-secondary education?" — Single select {1: "Yes", 2: "No", 7: "Don't know", 8: "Refused"} — 1 (Yes) → GO TO D43; 2 (No) → GO TO D44; 7 (DK) → GO TO D44; 8 (R) → GO TO D44

212. D43: "How much money in total have people outside your household put aside?" — Numeric (dollar amount) — DK/R available — All → GO TO D44

213. D44: "Interviewer Check Item: Check number of children in household." — Filter — More than 3 children → GO TO Section E; Otherwise → GO TO Section F

### Section E — Remaining Children: Savings for Post-Secondary Education — 19 items

214. E1: "Now I'd like to ask you some questions about saving for the post-secondary education of the other children in your household who are 18 years of age or younger. Have you or anyone else living in your household ever saved money for the post-secondary education of these children?" — Single select {1: "Yes", 2: "No", 7: "Don't know", 8: "Refused"} — 1 (Yes) → GO TO E2; 2 (No) → GO TO Section F; 7 (DK) → GO TO Section F; 8 (R) → GO TO Section F

215. E2: "For how many of these children is money being saved?" — Numeric — If 00 → GO TO Section F; Otherwise → GO TO E3

216. E3: "How much money was saved for these children's post-secondary education in 1998? Do not include any earnings or interest." — Numeric (dollar amount) — DK/R available — All → GO TO E4

217. E4: "How much money has been saved for these children's post-secondary education so far in 1999?" — Numeric (dollar amount) — DK/R available — All → GO TO E5

218. E5: "How much money will be saved for these children in the rest of 1999?" — Numeric (dollar amount) — DK/R available — All → GO TO E6

219. E6: "Since starting to save for these children, how much in total has been saved for their post-secondary education?" — Numeric (dollar amount) — DK/R available — All → GO TO E7a

220. E7a: "What types of savings plans are being used? a) RESPs (Registered Education Savings Plans)" — Single select {01: "Yes", 02: "No", 03: "Don't know", 04: "Refused"} — All → GO TO E7b

221. E7b: "b) RRSPs (Registered Retirement Savings Plans)" — Single select {05: "Yes", 06: "No", 07: "Don't know", 08: "Refused"} — All → GO TO E7c

222. E7c: "c) 'In-trust for' accounts" — Single select {09: "Yes", 10: "No", 11: "Don't know", 12: "Refused"} — All → GO TO E7d

223. E7d: "d) Other" — Single select {13: "Yes", 14: "No", 15: "Don't know", 16: "Refused"} — If E7a,b,c,d ALL = No/DK/R → GO TO Section F; Otherwise → GO TO E8a

224. E8a: "Within these plans, how are the savings invested? a) Mutual funds" — Single select {17: "Yes", 18: "No", 19: "Don't know", 20: "Refused"} — All → GO TO E8b

225. E8b: "b) Shares of corporations" — Single select {21: "Yes", 22: "No", 23: "Don't know", 24: "Refused"} — All → GO TO E8c

226. E8c: "c) Savings or chequing accounts" — Single select {25: "Yes", 26: "No", 27: "Don't know", 28: "Refused"} — All → GO TO E8d

227. E8d: "d) Savings bonds" — Single select {29: "Yes", 30: "No", 31: "Don't know", 32: "Refused"} — All → GO TO E8e

228. E8e: "e) Other" — Single select {33: "Yes", 34: "No", 35: "Don't know", 36: "Refused"} — All → GO TO E9

229. E9: "Interviewer Check Item: Check E7a response." — Filter — E7a = Yes (01) → GO TO E10; Otherwise → GO TO Section F

230. E10: "For the RESP only, how much money in total has been contributed to RESPs for these children by people living in your household?" — Numeric (dollar amount) — DK/R available — All → GO TO E11a

231. E11a: "Which types of RESPs are being used? a) Individual plan (includes individual non-family and family RESPs)" — Single select {01: "Yes", 02: "No", 03: "Don't know", 04: "Refused"} — All → GO TO E11b

232. E11b: "b) Group plan (education scholarship trust or foundation)" — Single select {05: "Yes", 06: "No", 07: "Don't know", 08: "Refused"} — All → GO TO Section F

### Section F — Children Outside Household — 20 items

233. F1: "Are you or anyone else living in your household saving for the post-secondary education of any children 18 years of age or younger who do not live in your household?" — Yes/No {1: "Yes", 2: "No"} — 1 (Yes) → GO TO F2; 2 (No) → GO TO Section G

234. F2: "For how many children is money being saved?" — Numeric — All → GO TO F3

235. F3: "What is the relationship of these children to the people saving money for them? (MARK ALL THAT APPLY)" — Multi select {01: "Son", 02: "Daughter", 03: "Grandson", 04: "Granddaughter", 05: "Brother", 06: "Sister", 07: "Niece", 08: "Nephew", 09: "Other family member or relative", 10: "Unrelated"} — All → GO TO F4

236. F4: "How much money was saved for these children's education in 1998 by you or anyone else living in your household? Do not include any earnings or interest." — Numeric (dollar amount) — DK/R available — All → GO TO F5

237. F5: "How much money was saved for these children's education so far in 1999?" — Numeric (dollar amount) — DK/R available — All → GO TO F6

238. F6: "How much money will you or anyone else in your household save for these children in the rest of 1999?" — Numeric (dollar amount) — DK/R available — All → GO TO F7

239. F7: "Since starting to save for these children, how much money in total has been saved by you or anyone else in your household for their education? Do not include any earnings or interest." — Numeric (dollar amount) — DK/R available — All → GO TO F8a

240. F8a: "What types of savings plans are being used? a) RESPs (Registered Education Savings Plans)" — Single select {01: "Yes", 02: "No", 03: "Don't know", 04: "Refused"} — All → GO TO F8b

241. F8b: "b) RRSPs (Registered Retirement Savings Plans)" — Single select {05: "Yes", 06: "No", 07: "Don't know", 08: "Refused"} — All → GO TO F8c

242. F8c: "c) 'In-trust for' accounts" — Single select {09: "Yes", 10: "No", 11: "Don't know", 12: "Refused"} — All → GO TO F8d

243. F8d: "d) Other" — Single select {13: "Yes", 14: "No", 15: "Don't know", 16: "Refused"} — If F8a,b,c,d ALL = No/DK/R → GO TO Section G; Otherwise → GO TO F9a

244. F9a: "Within these plans, how are the savings invested? a) Mutual funds" — Single select {17: "Yes", 18: "No", 19: "Don't know", 20: "Refused"} — All → GO TO F9b

245. F9b: "b) Shares of corporations" — Single select {21: "Yes", 22: "No", 23: "Don't know", 24: "Refused"} — All → GO TO F9c

246. F9c: "c) Savings or chequing accounts" — Single select {25: "Yes", 26: "No", 27: "Don't know", 28: "Refused"} — All → GO TO F9d

247. F9d: "d) Savings bonds" — Single select {29: "Yes", 30: "No", 31: "Don't know", 32: "Refused"} — All → GO TO F9e

248. F9e: "e) Other" — Single select {33: "Yes", 34: "No", 35: "Don't know", 36: "Refused"} — All → GO TO F10

249. F10: "Interviewer Check Item: Check F8a response." — Filter — F8a = Yes (01) → GO TO F11; Otherwise → GO TO Section G

250. F11: "For the RESPs only, how much money in total has been contributed to RESPs for these children by people living in your household?" — Numeric (dollar amount) — DK/R available — All → GO TO F12a

251. F12a: "Which types of RESPs are being used? a) Individual plan (includes individual non-family and family RESPs)" — Single select {01: "Yes", 02: "No", 03: "Don't know", 04: "Refused"} — All → GO TO F12b

252. F12b: "b) Group plan (education scholarship trust or foundation)" — Single select {05: "Yes", 06: "No", 07: "Don't know", 08: "Refused"} — All → GO TO Section G

### Section G — General Information — 19 items

253. G1: "Interviewer Check Item" — Filter — No children 0–18 in household: F1=No → GO TO G11; F1=Yes → GO TO G6. Children 0–18 in household: ALL children aged 00–04 → GO TO G4; Otherwise → GO TO G2

254. G2: "Is there a computer available in your household that the children can use to do their school work or assignments?" — Single select {5: "Yes", 6: "No", 7: "Don't know", 8: "Refused"} — All → GO TO G3

255. G3: "Are there books or other reading materials in the home for the children to use to do school work or assignments? (e.g. encyclopaedias, reference books, CD ROMs)" — Single select {1: "Yes", 2: "No", 7: "Don't know", 8: "Refused"} — All → GO TO G4

256. G4: "Thinking of the children in your household, to which ethnic or cultural group(s) do the ancestors of their mother belong? (MARK ALL THAT APPLY.)" — Multi select {01: "Canadian", 02: "Chinese", 03: "Dutch (Netherlands)", 04: "English", 05: "French", 06: "German", 07: "Inuit/Eskimo", 08: "Irish", 09: "Italian", 10: "Jewish", 11: "Métis", 12: "North American Indian", 13: "Polish", 14: "Scottish", 15: "South Asian", 16: "Ukrainian", 17: "Other - Specify", 97: "Don't know", 98: "Refused"} — All → GO TO G5

257. G5: "Thinking of the children in your household, to which ethnic or cultural group(s) do the ancestors of their father belong? (MARK ALL THAT APPLY.)" — Multi select {18: "Canadian", 19: "Chinese", 20: "Dutch (Netherlands)", 21: "English", 22: "French", 23: "German", 24: "Inuit/Eskimo", 25: "Irish", 26: "Italian", 27: "Jewish", 28: "Métis", 29: "North American Indian", 30: "Polish", 31: "Scottish", 32: "South Asian", 33: "Ukrainian", 34: "Other - Specify", 97: "Don't know", 98: "Refused"} — All → GO TO G6

258. G6: "What is the language spoken most often in your household? (ACCEPT MULTIPLE RESPONSES ONLY IF LANGUAGES ARE SPOKEN EQUALLY.)" — Multi select {01: "English", 02: "French", 03: "Arabic", 04: "Chinese", 05: "German", 06: "Italian", 07: "Polish", 08: "Portuguese", 09: "Punjabi", 10: "Spanish", 11: "Tagalog (Filipino)", 12: "Vietnamese", 13: "Other language - Specify", 97: "Don't know", 98: "Refused"} — All → GO TO G7

259. G7: "What other languages are spoken in your household? (MARK ALL THAT APPLY.)" — Multi select {14: "No other languages spoken", 15: "English", 16: "French", 17: "Arabic", 18: "Chinese", 19: "German", 20: "Italian", 21: "Polish", 22: "Portuguese", 23: "Punjabi", 24: "Spanish", 25: "Tagalog (Filipino)", 26: "Vietnamese", 27: "Other language - Specify", 97: "Don't know", 98: "Refused"} — All → GO TO G8

260. G8: "From the following list, what is your household's highest financial priority? (READ LIST.)" — Single select {1: "Everyday budget", 2: "Savings for post-secondary education", 3: "Retirement savings", 4: "Other savings", 7: "Don't know", 8: "Refused"} — All → GO TO G9

261. G9: "Thinking about your total household income, from which of the following sources did your household receive any income in the past 12 months? (READ LIST. MARK ALL THAT APPLY.)" — Multi select {01: "Wages and salaries", 02: "Income from self-employment", 03: "Dividends and interest", 04: "Employment insurance", 05: "Workers' compensation", 06: "Benefits from Canada or Quebec Pension Plan", 07: "Retirement pensions, superannuation and annuities", 08: "Old Age Security and Guaranteed Income Supplement", 09: "Child Tax Benefit", 10: "Provincial or municipal social assistance or welfare", 11: "Child support", 12: "Alimony", 13: "Other", 14: "None"} — All → GO TO G10

262. G10: "What is your best estimate of the total income before taxes and deductions of all household members from all sources in the past 12 months?" — Single select (hierarchical bisection) — First level: {01: "Less than $20,000" → GO TO G10_sub1, 02: "$20,000 or more" → GO TO G10_sub2, 03: "No income" → GO TO G11, 97: "Don't know" → GO TO G11, 98: "Refused" → GO TO G11}. Sub-level 1 (if <$20K): {04: "Less than $10,000" → GO TO G10_sub3, 05: "$10,000 or more" → GO TO G10_sub4}. Sub-level 2 (if >=$20K): {06: "Less than $40,000" → GO TO G10_sub5, 07: "$40,000 or more" → GO TO G10_sub6}. Sub-level 3 (if <$10K): {08: "Less than $5,000", 09: "$5,000 or more"} → GO TO G11. Sub-level 4 (if $10K–$20K): {10: "Less than $15,000", 11: "$15,000 or more"} → GO TO G11. Sub-level 5 (if $20K–$40K): {12: "Less than $30,000", 13: "$30,000 or more"} → GO TO G11. Sub-level 6 (if >=$40K): {14: "Less than $50,000", 15: "$50,000 to less than $60,000", 16: "$60,000 to less than $80,000", 17: "$80,000 or more"} → GO TO G11

263. G11: "To avoid duplication, Statistics Canada has entered into a data sharing agreement under Section 12 of the Statistics Act with Human Resources Development Canada. Do you agree to let Statistics Canada share your information?" — Single select {4: "Yes", 5: "No", 7: "Don't know", 8: "Refused"} — All → GO TO G12

264. G12: "Interviewer Check Item" — Filter — No children 0–18 in household → END INTERVIEW; Otherwise → GO TO G13

265. G13: "As part of a related statistical study, the information you provide during this interview, in future, may be combined with post-secondary school records about the children in your household. Do you agree to let Statistics Canada combine this information?" — Single select {1: "Yes", 2: "No", 7: "Don't know", 8: "Refused"} — END INTERVIEW
