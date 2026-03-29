# SHS 2000 (Survey of Household Spending) - Question Inventory

## Verification Status

*Verified by independent judgement agent on 2026-03-29.*

| Section | Source Qs | Inventory Qs | Missing | Key Routing | Notes |
|---------|----------|-------------|---------|-------------|-------|
| A: Household Composition | 12 | 12 | 0 | 5 skips | Roster Q1-Q12 with conditional week logic |
| B: Dwelling Characteristics | 11 | 11 | 0 | 0 | Sequential Q1-Q11 |
| C: Facilities | 18 | 18 | 0 | 3 skips | Q1-Q17 + C_FILTER_Q04 |
| D: Tenure | 18 | 18 | 0 | 8 skips | Q1-Q7.4 + 3 filters + D_INSTRUCTIONS read |
| E: Owned Principal Residences | 12 | 12 | 0 | 3 skips | Q1-Q5.1.2 + E_CALC + E_NOTE |
| F: Purchase and Sale of Homes | 10 | 10 | 0 | 2 skips | Q1-Q4 + specify |
| G: Mortgages | 11 | 11 | 0 | 2 skips | Q1-Q4.1d |
| H: Renovations and Repairs | 3 | 3 | 0 | 0 | Roster Q1-Q3 |
| I: Rented Principal Residences | 14 | 14 | 0 | 3 skips | Q1-Q8.1.2 |
| J: Utilities and Accommodation | 8 | 8 | 0 | 0 | Q1.1-Q2.3 + J_NOTE read |
| K: Secondary Residences/Property | 24 | 24 | 0 | 6 skips | Q1-Q13.2 vacation + other property |
| L: Furnishings and Equipment | 51 | 51 | 0 | 0 | Q1-Q47 + L_TOTAL |
| M: Home Operation | 24 | 24 | 0 | 0 | Q1.1-Q20 incl. household supplies (Q1 has 5 sub-items) |
| N: Food and Alcohol | 13 | 13 | 0 | 0 | Q1-Q7.2 |
| O: Clothing | 18 | 18 | 0 | 0 | Per-person grids + gifts + services |
| P: Personal and Health Care | 19 | 19 | 0 | 0 | Q1-Q16 with sub-questions |
| Q: Automobiles and Trucks | 24 | 24 | 0 | 5 skips | Per-vehicle grid Q1-Q22 |
| R: Rec Vehicles/Transportation | 23 | 23 | 0 | 2 skips | Q1-Q17.1 |
| S: Recreation/Reading/Education | 32 | 32 | 0 | 0 | Q1-Q29 with sub-questions |
| T: Tobacco and Miscellaneous | 25 | 25 | 0 | 1 skip | Q1-Q12 with direct sales routing |
| U: Personal Income | 18 | 18 | 0 | 0 | Per-person Q1.1-Q16 |
| V: Taxes/Security/Gifts | 15 | 15 | 0 | 0 | Per-person Q1-Q13.2 |
| W: Change in Assets | 13 | 13 | 0 | 0 | Q1.1-Q3.3 |
| X: Unincorporated Business | 10 | 10 | 0 | 1 skip | Q1-Q2.2 |
| Y: Loans and Other Debts | 11 | 11 | 0 | 3 skips | Per-loan grid Q1-Q9 |

- **Coverage**: 25/25 sections verified, 437 items total
- **Routing**: All 11 key skip paths verified (E->I, G->H, I->J, K internal, Q internal, R->S, T internal, X->Y, Y internal)
- **Node types**: Questions (numbered items), Filters (C_FILTER_Q04, D_FILTER_SPOUSE, D_FILTER_YEAR, D_FILTER_Q6), Reads (D_INSTRUCTIONS, J_NOTE)
- **Status**: READY FOR QML
- **Missing**: None

## Document Overview
- **Title**: Survey of Household Spending 2000 (SHS)
- **Organization**: Statistics Canada
- **Form Number**: 8-5400-77.1 (2000-07-26)
- **Pages**: 62 pages (Sections A through Y, plus cover, instructions, and balancing worksheets)
- **Language**: English (French available by request)
- **Type**: Paper-based interviewer-administered household expenditure survey
- **Authority**: Statistics Act, Revised Statutes of Canada, 1985, Chapter S19

## Structure

The questionnaire has 25 sections organized into functional groups:

**Household & Dwelling (Sections A–D)**
1. Section A: Household Composition — Roster of up to 10 household members
2. Section B: Dwelling Characteristics — Type, age, repairs, rooms, heating
3. Section C: Facilities Associated with the Dwelling — Equipment counts and Yes/No
4. Section D: Tenure — Ownership/rental status, previous dwellings

**Housing Expenditures (Sections E–K)**
5. Section E: Owned Principal Residences — Property taxes, insurance, condo charges
6. Section F: Purchase and Sale of Homes — Home buying/selling costs
7. Section G: Mortgages on Owned Principal Residences — Mortgage payments
8. Section H: Renovations and Repairs — Additions, installations, repairs
9. Section I: Rented Principal Residences — Rent, deposits, tenant expenses
10. Section J: Utilities and Other Rented Accommodation — Water, fuel, electricity, travel accommodation
11. Section K: Owned Secondary Residences and Other Property — Vacation homes, other property

**Consumer Expenditures (Sections L–T)**
12. Section L: Household Furnishings and Equipment — 47 expenditure categories
13. Section M: Home Operation — Communications, child care, pets, supplies
14. Section N: Food and Alcohol — Groceries, restaurants, alcohol, board
15. Section O: Clothing — Per-person clothing grids by demographic group
16. Section P: Personal and Health Care — Personal care, insurance, medical costs
17. Section Q: Automobiles and Trucks — Vehicle ownership, purchase, operation
18. Section R: Recreational Vehicles and Transportation — Rec vehicles, transit, trips
19. Section S: Recreation, Reading Materials and Education — Sports, reading, courses
20. Section T: Tobacco and Miscellaneous — Tobacco, financial services, gambling, direct sales

**Income and Financial (Sections U–Y)**
21. Section U: Personal Income — Per-person income from 15 sources
22. Section V: Personal Taxes, Security and Money Gifts — Taxes, insurance, contributions
23. Section W: Change in Assets — Bank accounts, RRSPs, investments
24. Section X: Unincorporated Business — Business investments, assets, accounts
25. Section Y: Loans and Other Debts — Regular loans, credit cards, other debts

## Question Inventory by Section

### Section A: Household Composition — 12 questions

*Roster format: Questions 1–12 repeat for each household member (up to 10 persons). The household reference person is listed first (Person 01).*

1. A_Q01: "What are the first names of all members of your household? Include everyone who currently lives here and anyone who was part of your household at any time during 2000. List the household reference person first." — Roster (household members, up to 10) — GO TO A_Q02 for each person

2. A_Q02: "What is [name]'s relationship to the household reference person?" — Single select {1: "Reference Person", 2: "Spouse", 3: "Son/Daughter", 4: "Other relative", 5: "Not related"} — Person 01 pre-coded as 1. → GO TO A_Q03

3. A_Q03: "In what year was [name] born? (If born in 1900 or earlier, enter 1900)" — Numeric (1900–2001) — GO TO A_Q04

4. A_Q04: "Is [name] male or female?" — Single select {1: "Male", 2: "Female"} — GO TO A_Q05

5. A_Q05: "What was [name]'s marital status on December 31, 2000? Mark one circle." — Single select {1: "Married spouse of a household member", 2: "Common-law spouse of a household member", 3: "Never married (single)", 4: "Other (separated, divorced or widowed)"} — GO TO A_Q06

6. A_Q06: "Economic Family Code (at time of interview or last day the person was a member of the household)." — Text (code) — Enter a letter code. → GO TO A_Q07

7. A_Q07: "Was [name] a member of this household on December 31, 2000?" — Yes/No {1: "Yes", 2: "No"} — GO TO A_Q08

8. A_Q08: "Is [name] a member of this household today?" — Yes/No {3: "Yes", 4: "No"} — GO TO A_Q09

9. A_Q09: "For how many weeks in 2000 was [name] a member of this household?" — Numeric (0–52) — If one-person household → GO TO A_Q11; If A_Q09 = 52 → GO TO A_Q12; Otherwise → GO TO A_Q10

10. A_Q10: "For how many weeks in 2000 did [name] live apart from this household, either as a one-person household, or in another household that no longer exists elsewhere?" — Numeric (0–52) — If A_Q09 + A_Q10 = 52 → GO TO A_Q12; Otherwise → GO TO A_Q11

11. A_Q11: "Why is total weeks (Q.9 plus Q.10) less than 52?" — Single select {1: "Child born in 2000 or 2001", 2: "Immigrated in 2000 or 2001", 3: "Belonged to a household in existence elsewhere", 4: "Other - Explain in notes"} — GO TO A_Q12

12. A_Q12: "Use questions 8, 9 and 10 to determine the data collection code and the procedure to follow for each person." — Single select (derived) {1: "Report data for total weeks (Q.8=Yes, Q.9≠00)", 2: "Report data for weeks in this household only (Q.8=No, Q.9≠00)", 3: "Report data for weeks apart only (Q.8=Yes, Q.9=00, Q.10≠00)", 4: "End questions — member after 2000 (Q.8=Yes, Q.9=00, Q.10=00)", 5: "End questions — not a member (Q.8=No, Q.9=00, Q.10=00)"} — NEXT PERSON or GO TO Section B

### Section B: Dwelling Characteristics — 11 questions

*Report answers for the dwelling occupied on December 31, 2000.*

13. B_Q01: "What type of dwelling did your household live in on December 31, 2000? Mark one circle." — Single select {1: "Single detached", 2: "Double", 3: "Row or terrace", 4: "Duplex", 5: "Apartment <5 storeys", 6: "Apartment 5+ storeys", 7: "Hotel/rooming/lodging house/camp", 8: "Mobile home", 9: "Other (Specify)"} — If 9 → Specify text. GO TO B_Q02

14. B_Q02: "When was this dwelling originally built? Mark one circle." — Single select {1: "1920 or before", 2: "1921–1945", 3: "1946–1960", 4: "1961–1970", 5: "1971–1980", 6: "1981–1990", 7: "1991–1999", 8: "2000"} — GO TO B_Q03

15. B_Q03: "Was this dwelling in need of any repairs on December 31, 2000?" — Single select {1: "Yes, major repairs", 2: "Yes, minor repairs", 3: "No, only regular maintenance"} — GO TO B_Q04

16. B_Q04: "How many rooms were there in this dwelling?" — Numeric (1–99) — GO TO B_Q05

17. B_Q05: "How many bedrooms were there in this dwelling?" — Numeric (0–99) — If bachelor apartment, enter 00. GO TO B_Q06

18. B_Q06: "How many bathrooms with a bathtub or shower were there in this dwelling?" — Numeric (0–99) — GO TO B_Q07

19. B_Q07: "What was the principal heating equipment for this dwelling? Mark one circle." — Single select {1: "Steam/hot water furnace", 2: "Forced hot air furnace", 3: "Other hot air furnace", 4: "Heating stove (incl. wood)", 5: "Electric heating (incl. baseboard)", 6: "Cookstove", 7: "Other (Specify)"} — If 7 → Specify text. GO TO B_Q08

20. B_Q08: "How old was this heating equipment? Mark one circle." — Single select {1: "5 years or less (1995–2000)", 2: "6–10 years (1990–1994)", 3: "11–15 years (1985–1989)", 4: "16–20 years (1980–1984)", 5: "Over 20 years (before 1980)"} — GO TO B_Q09

21. B_Q09: "What was the principal fuel for this heating equipment? Mark one circle." — Single select {1: "Oil/liquid fuel", 2: "Piped gas (natural gas)", 3: "Bottled gas (propane)", 4: "Electricity", 5: "Wood", 6: "Other (Specify)"} — If 6 → Specify text. GO TO B_Q10

22. B_Q10: "What was the principal fuel for the hot water supply? Mark one circle." — Single select {1: "Oil/liquid fuel", 2: "Piped gas", 3: "Bottled gas", 4: "Electricity", 5: "Wood", 6: "Other (Specify)", 7: "No running hot water"} — If 6 → Specify text. GO TO B_Q11

23. B_Q11: "What was the main fuel used for cooking? Mark one circle." — Single select {1: "Oil/liquid fuel", 2: "Piped gas", 3: "Bottled gas", 4: "Electricity", 5: "Wood", 6: "Other (Specify)"} — If 6 → Specify text. GO TO Section C

### Section C: Facilities Associated with the Dwelling — 17 questions + 1 filter (18 items)

*Include items regardless of ownership, as long as they were in the dwelling on December 31, 2000.*

24. C_Q01: "How many refrigerators?" — Numeric (0–9) — GO TO C_Q02

25. C_Q02: "How many colour TV sets?" — Numeric (0–9) — GO TO C_Q03

26. C_Q03: "How many VCRs?" — Numeric (0–9) — GO TO C_Q04

27. C_Q04: "How many telephones? (Include business phones, exclude cellular)" — Numeric (0–9) — If 0 → specify reason, GO TO C_Q06; Otherwise → GO TO C_Q05

28. C_FILTER_Q04: Filter — If C_Q04 = 0 → specify reason, SKIP C_Q05, GO TO C_Q06

29. C_Q05: "How many telephone numbers for this dwelling?" — Numeric (0–9) — GO TO C_Q06

30. C_Q06: "Did you have a cellular phone for personal use?" — Yes/No {1: "Yes", 2: "No"} — GO TO C_Q07

31. C_Q07: "Did you have a microwave oven?" — Yes/No {1: "Yes", 2: "No"} — GO TO C_Q08

32. C_Q08: "Did you have a freezer separate from the refrigerator?" — Yes/No {1: "Yes", 2: "No"} — GO TO C_Q09

33. C_Q09: "Did you have cable TV?" — Yes/No {1: "Yes", 2: "No"} — GO TO C_Q10

34. C_Q10: "Did you have a CD player?" — Yes/No {1: "Yes", 2: "No"} — GO TO C_Q11

35. C_Q11: "Did you have a home computer? (Exclude business-only)" — Yes/No {1: "Yes", 2: "No"} — Yes → GO TO C_Q12; No → GO TO C_Q14

36. C_Q12: "Did you have a modem?" — Yes/No {1: "Yes", 2: "No"} — Yes → GO TO C_Q13; No → GO TO C_Q14

37. C_Q13: "Did you use the Internet from home?" — Yes/No {1: "Yes", 2: "No"} — GO TO C_Q14

38. C_Q14: "Did you have air conditioning? Mark one circle." — Single select {1: "Window-type", 2: "Central", 3: "None"} — GO TO C_Q15

39. C_Q15: "Did you have a dishwasher? Mark one circle." — Single select {1: "Built-in automatic", 2: "Portable automatic", 3: "None"} — GO TO C_Q16

40. C_Q16: "Did you have a washing machine (inside dwelling)? Mark one circle." — Single select {1: "Automatic", 2: "Other kind", 3: "None"} — GO TO C_Q17

41. C_Q17: "Did you have a clothes dryer (inside dwelling)? Mark one circle." — Single select {1: "Electric", 2: "Gas", 3: "None"} — GO TO Section D

### Section D: Tenure — 14 questions + 3 filters + 1 read (18 items)

42. D_Q01: "On December 31, 2000 was your dwelling:" — Single select {1: "Owned without mortgage", 2: "Owned with mortgage(s)", 3: "Rented", 4: "Occupied rent-free"} — GO TO D_Q02

43. D_Q02: "In what year did your household move to this dwelling?" — Numeric (year) — If before 1995 → GO TO Section E instructions; Otherwise → GO TO D_Q03

44. D_Q03: "Did the reference person own or rent their previous dwelling?" — Single select {1: "Owned", 2: "Rented", 3: "Did not maintain their own dwelling"} — GO TO D_FILTER_SPOUSE

45. D_FILTER_SPOUSE: Filter — If no spouse → GO TO D_FILTER_YEAR; If spouse → GO TO D_Q04

46. D_Q04: "Did the spouse of the reference person own or rent their previous dwelling?" — Single select {1: "Owned", 2: "Rented", 3: "Did not maintain their own dwelling"} — GO TO D_FILTER_YEAR

47. D_FILTER_YEAR: Filter — If moved in 2000 → GO TO D_Q05; Otherwise → GO TO Section E instructions

48. D_Q05: "Did anyone in this household report TOTAL WEEKS equal to 52? (Section A, Q.9 plus Q.10)" — Yes/No {1: "Yes", 2: "No"} — Yes → GO TO D_Q06; No → GO TO D_Q05.1

49. D_Q05.1: "For the total weeks reported earlier, did anyone live in another dwelling?" — Yes/No {1: "Yes", 2: "No"} — Yes → GO TO D_Q06; No → GO TO Section E instructions

50. D_Q06.1: "Were any previously occupied dwellings in 2000: Owned with mortgage(s)?" — Yes/No — GO TO D_Q06.2

51. D_Q06.2: "Owned without a mortgage?" — Yes/No — GO TO D_Q06.3

52. D_Q06.3: "Rented?" — Yes/No — GO TO D_Q06.4

53. D_Q06.4: "Occupied rent-free?" — Yes/No — GO TO D_FILTER_Q6

54. D_FILTER_Q6: Filter — If D_Q06.1=No AND D_Q06.2=No → GO TO Section E instructions; Otherwise → GO TO D_Q07.1

55. D_Q07.1: "Were any previously owned dwellings in 2000: Sold?" — Yes/No — GO TO D_Q07.2

56. D_Q07.2: "Rented to others?" — Yes/No — GO TO D_Q07.3

57. D_Q07.3: "Left vacant?" — Yes/No — GO TO D_Q07.4

58. D_Q07.4: "Other?" — Yes/No — If Yes → Specify text. GO TO Section E instructions

59. D_INSTRUCTIONS: Read — "Instructions for the Expenditure Questions" covering part-year members, expenditure reporting rules, and insurance settlements. → GO TO Section E

### Section E: Owned Principal Residences — 12 questions

*Exclude vacation homes, secondary residences, and dwellings not occupied in 2000.*

60. E_Q01: "How many dwellings did members of your household own and occupy in 2000?" — Numeric (0–99) — If 00 → GO TO Section I; Otherwise → Continue

61. E_Q02: "For how many months in 2000 did your household own and occupy the dwelling(s)?" — Numeric (1–12) — Continue

62. E_Q03.1: "Total amount billed for property taxes in 2000?" — Numeric (dollars) — Continue

63. E_Q03.2: "Total premiums paid in 2000 for homeowners' insurance (fire, theft, perils)?" — Numeric (dollars) — Continue

64. E_Q03.3: "Amount paid for condominium charges? (Include special levies)" — Numeric (dollars) — Continue

65. E_Q04: "Were any of these expenses charged against income from businesses?" — Yes/No {1: "Yes", 2: "No"} — Yes → GO TO E_Q04.1; No → GO TO E_Q05

66. E_Q04.1: "What amount or percentage was charged against business income?" — Numeric (dollars OR percentage) — GO TO E_Q05

67. E_Q05: "Were any of these expenses charged against income from rooms rented out?" — Yes/No {1: "Yes", 2: "No"} — Yes → GO TO E_Q05.1; No → GO TO Section F

68. E_Q05.1.1: "Amount/percentage from rooms rented to household members (excl. relatives)?" — Numeric (dollars OR percentage) — Continue

69. E_Q05.1.2: "Amount/percentage from rooms rented to non-members?" — Numeric (dollars OR percentage) — GO TO Section F

70. E_CALC: "Calculate B total from business/rental deductions" — Filter (calculation) — Continue

71. E_NOTE: "If none, explain" — Text (for Q.3.1 if no property taxes) — Continue

### Section F: Purchase and Sale of Homes — 10 questions

72. F_Q01: "Did your household purchase a home in 2000?" — Yes/No {1: "Yes", 2: "No"} — Yes → Continue; No → GO TO F_Q02

73. F_Q01.1: "Was this purchase by person(s) who never previously owned an occupied dwelling?" — Yes/No {1: "Yes", 2: "No"} — Continue

74. F_Q01.2: "What was the purchase price?" — Numeric (dollars) — Continue

75. F_Q01.3: "How much for land transfer taxes and registration fees?" — Numeric (dollars) — Continue to F_Q02

76. F_Q02: "Did your household sell a home in 2000?" — Yes/No {1: "Yes", 2: "No"} — Yes → Continue; No → GO TO F_Q03

77. F_Q02.1: "What was the selling price?" — Numeric (dollars) — Continue

78. F_Q02.2: "How much for real estate commissions?" — Numeric (dollars) — Continue to F_Q03

79. F_Q03: "How much spent on legal charges related to dwelling(s)?" — Numeric (dollars) — Continue

80. F_Q04: "How much spent on other dwelling-related expenses (surveying, appraisals, mortgage fees)?" — Numeric (dollars) — Continue

81. F_Q04_specify: "Specify other expenses" — Text — GO TO Section G

### Section G: Mortgages on Owned Principal Residences — 11 questions

*Exclude mortgages on rental property, vacation homes, secondary residences.*

82. G_Q01: "In 2000, did your household have any mortgages on dwellings it owned and occupied?" — Yes/No {1: "Yes", 2: "No"} — Yes → Continue; No → GO TO Section H

83. G_Q02.1: "Regular mortgage payments in 2000? (Up to 3 mortgages: Amount × Number)" — Roster (up to 3: amount + count) — Continue

84. G_Q02.2: "Irregular and lump sum payments including payments to close mortgage?" — Roster (up to 3: amount + count) — Continue

85. G_Q03.1: "Did mortgage payments include property taxes?" — Yes/No — Continue

86. G_Q03.2: "Did mortgage payments include mortgage life/disability insurance?" — Yes/No — Continue

87. G_Q03.3: "Total premium paid for mortgage life/disability insurance in 2000?" — Numeric (dollars) — Continue

88. G_Q04: "Were any amounts added to your mortgage(s) in 2000?" — Yes/No {1: "Yes", 2: "No"} — Yes → Continue; No → GO TO Section H

89. G_Q04.1a: "Amount added (first)" — Numeric (dollars) — Continue
90. G_Q04.1b: "Amount added (second)" — Numeric (dollars) — Continue
91. G_Q04.1c: "Amount added (third)" — Numeric (dollars) — Continue
92. G_Q04.1d: "Amount added (fourth)" — Numeric (dollars) — GO TO Section H

### Section H: Renovations and Repairs of Owned Principal Residences — 3 questions (roster)

*Exclude vacation homes, secondary residences, rented residences. Exclude business/rental charges.*

93. H_Q01: "How much spent on additions, renovations and other alterations?" — Roster (up to 3: Specify + Total Cost) — Continue

94. H_Q02: "How much spent on installations of built-in equipment, appliances and fixtures?" — Roster (up to 3: Specify + Replacement cost + New installation cost) — Continue

95. H_Q03: "How much spent on repairs and maintenance?" — Roster (up to 3: Specify + Total Cost) — GO TO Section I

### Section I: Rented Principal Residences — 14 questions

*Include rent-free residences. Exclude rented vacation homes (Section J).*

96. I_Q01: "For how many months in 2000 did your household occupy a rented dwelling?" — Numeric (0–12) — If 00 → GO TO Section J; Otherwise → Continue

97. I_Q02: "Monthly rental payments for principal residences in 2000?" — Roster (12 months: January–December rent) — Continue

98. I_Q02_total: "Enter total rent paid" — Numeric (dollars) — Continue

99. I_Q03: "Additional amount paid to landlord not included in rent (e.g., security deposits)?" — Numeric (dollars) — Continue

100. I_Q04: "How much rent was returned to your household (e.g., overpayment, damage deposit)?" — Numeric (dollars) — Continue

101. I_Q05: "Did your household pay reduced rent?" — Single select {1: "Government subsidized housing", 2: "Other reasons (services to landlord, company housing)", 3: "No reduced rent"} — Continue

102. I_Q06.1: "Additions, renovations, repairs for rented dwelling(s)?" — Numeric (dollars) — Continue

103. I_Q06.2: "Tenants' insurance?" — Numeric (dollars) — Continue

104. I_Q06.3: "Parking at place of residence?" — Numeric (dollars) — Continue

105. I_Q07: "Was any part of rent charged against business income?" — Yes/No {1: "Yes", 2: "No"} — Yes → Continue; No → GO TO I_Q08

106. I_Q07.1: "Amount or percentage charged against business income?" — Numeric (dollars OR percentage) — GO TO I_Q08

107. I_Q08: "Was any part of rent charged against income from rooms rented to others?" — Yes/No {1: "Yes", 2: "No"} — Yes → Continue; No → GO TO Section J

108. I_Q08.1.1: "Amount/percentage from rooms rented to household members (excl. relatives)?" — Numeric (dollars OR percentage) — Continue

109. I_Q08.1.2: "Amount/percentage from rooms rented to non-members?" — Numeric (dollars OR percentage) — GO TO Section J

### Section J: Utilities and Other Rented Accommodation — 7 questions + 1 read (8 items)

*Ask OWNERS and RENTERS. Exclude vacation home/secondary residence expenses (Section K).*

110. J_Q01.1: "Water and sewage charges (not in property tax bill)?" — Numeric (dollars) — Continue

111. J_Q01.2: "Electricity?" — Numeric (dollars) — Continue

112. J_Q01.3: "Other fuel for heating and cooking (oil, gas, propane, wood)?" — Numeric (dollars) — Continue

113. J_Q01.4: "Rental of heating equipment?" — Numeric (dollars) — Continue

114. J_Q02.1: "Hotels and motels (while away overnight or longer)?" — Numeric (dollars) — Continue

115. J_Q02.2: "Other accommodation?" — Numeric (dollars) — Continue

116. J_Q02.3: "Of this amount, how much spent in this province?" — Numeric (dollars OR percentage) — Continue

117. J_NOTE: Read — Instructions for expenses on dwellings not owned by household members — GO TO Section K

### Section K: Owned Secondary Residences and Other Property — 24 questions

**Vacation Homes and Secondary Residences**

118. K_Q01: "In 2000, did any member own a vacation home or other secondary residence?" — Yes/No {1: "Yes", 2: "No"} — Yes → Continue; No → GO TO K_Q07

119. K_Q02: "Did any member purchase a vacation home or secondary residence in 2000?" — Yes/No {1: "Yes", 2: "No"} — Yes → Continue; No → GO TO K_Q03

120. K_Q02.1: "What was the purchase price?" — Numeric (dollars) — GO TO K_Q03

121. K_Q03: "How much money was borrowed in 2000 for expenses associated with the dwelling(s)?" — Numeric (dollars) — Continue

122. K_Q04: "How much were the mortgage payments in 2000?" — Numeric (dollars) — Continue

123. K_Q05: "Was the dwelling sold in 2000?" — Yes/No {1: "Yes", 2: "No"} — Yes → Continue; No → GO TO K_Q06

124. K_Q05.1: "What was the selling price?" — Numeric (dollars) — Continue

125. K_Q05.2: "What was the net amount received from the sale?" — Numeric (dollars) — GO TO K_Q06

126. K_Q06.1: "Additions, renovations and new installations?" — Numeric (dollars) — Continue
127. K_Q06.2: "Repairs, maintenance and replacements?" — Numeric (dollars) — Continue
128. K_Q06.3: "Property taxes and sewage charges?" — Numeric (dollars) — Continue
129. K_Q06.4: "Insurance?" — Numeric (dollars) — Continue
130. K_Q06.5: "Electricity, water and fuel?" — Numeric (dollars) — Continue
131. K_Q06.6: "Other expenses (condo charges, survey costs, legal fees, mortgage insurance)?" — Numeric (dollars) — GO TO K_Q07

**Other Property**

132. K_Q07: "In 2000, did any member own any other property?" — Yes/No {1: "Yes", 2: "No"} — Yes → Continue; No → GO TO Section L

133. K_Q08: "Did any member purchase any other property in 2000?" — Yes/No {1: "Yes", 2: "No"} — Yes → Continue; No → GO TO K_Q09

134. K_Q08.1: "What was the purchase price?" — Numeric (dollars) — GO TO K_Q09

135. K_Q09: "How much money was borrowed for the property?" — Numeric (dollars) — Continue

136. K_Q10: "How much were the mortgage payments in 2000?" — Numeric (dollars) — Continue

137. K_Q11: "Additions or major alterations (e.g., servicing of land)?" — Numeric (dollars) — Continue

138. K_Q12: "Other expenses (property taxes, survey costs, appraisal fees, utilities)?" — Numeric (dollars) — Continue

139. K_Q13: "Was any property sold in 2000?" — Yes/No {1: "Yes", 2: "No"} — Yes → Continue; No → GO TO Section L

140. K_Q13.1: "What was the selling price?" — Numeric (dollars) — Continue

141. K_Q13.2: "What was the net amount received from the sale?" — Numeric (dollars) — GO TO Section L

### Section L: Household Furnishings and Equipment — 51 questions

*Include purchases for vacation homes. Include sales taxes. Exclude business expenses.*

**Furnishings, Art and Antiques**

142. L_Q01: "Furniture for indoor or outdoor use? (Include mattresses)" — Numeric (dollars)
143. L_Q02: "Glass mirrors, and mirror and picture frames?" — Numeric (dollars)
144. L_Q03: "Lamps and lampshades?" — Numeric (dollars)
145. L_Q04: "Rugs, mats and underpadding?" — Numeric (dollars)
146. L_Q05: "Window coverings and household textiles (curtains, blinds, bedding, towels)?" — Numeric (dollars)
147. L_Q06: "Works of art, carvings and vases?" — Numeric (dollars)
148. L_Q07: "Antiques (100+ years old)?" — Numeric (dollars)
149. L_Q08: "Maintenance and repair of furniture, carpeting and textiles?" — Numeric (dollars)

**Home Entertainment Equipment** (net purchase price after trade-in)

150. L_Q09: "Audio equipment (tape players, CD players, receivers, speakers)?" — Numeric (dollars)
151. L_Q10: "TVs, VCRs, camcorders and video components?" — Numeric (dollars)
152. L_Q11: "CDs, pre-recorded audiotapes, videos and videodiscs?" — Numeric (dollars)
153. L_Q12: "Blank audio and video tapes?" — Numeric (dollars)
154. L_Q13: "Other home entertainment equipment (satellite dishes, headphones, etc.)?" — Numeric (dollars)

**Computer Equipment**

155. L_Q14.1: "Computer hardware purchased new?" — Numeric (dollars)
156. L_Q14.2: "Computer hardware purchased used?" — Numeric (dollars)
157. L_Q14.3: "Amount received from sale of computer hardware? (Category B)" — Numeric (dollars)
158. L_Q15: "Computer software?" — Numeric (dollars)
159. L_Q16: "Computer supplies and other equipment?" — Numeric (dollars)

**Home Entertainment Services**

160. L_Q17: "Rental of videos and videodiscs?" — Numeric (dollars)
161. L_Q18: "Maintenance and repair of home entertainment equipment?" — Numeric (dollars)
162. L_Q19: "Rental of cablevision and satellite services?" — Numeric (dollars)
163. L_Q20: "Rental of home entertainment equipment and other services?" — Numeric (dollars)

**Major Household Appliances** (net purchase price)

164. L_Q21: "Refrigerators and freezers?" — Numeric (dollars)
165. L_Q22: "Cooking stoves and ranges?" — Numeric (dollars)
166. L_Q23: "Microwave and convection ovens?" — Numeric (dollars)
167. L_Q24: "Washers and dryers?" — Numeric (dollars)
168. L_Q25: "Vacuum cleaners and rug cleaning equipment?" — Numeric (dollars)
169. L_Q26: "Sewing machines?" — Numeric (dollars)
170. L_Q27: "Portable dishwashers?" — Numeric (dollars)
171. L_Q28: "Gas barbecues?" — Numeric (dollars)
172. L_Q29: "Room air conditioners, humidifiers and dehumidifiers?" — Numeric (dollars)
173. L_Q30.1: "Attachments and parts for major appliances?" — Numeric (dollars)
174. L_Q30.2: "Maintenance and repair of major appliances?" — Numeric (dollars)
175. L_Q31: "Amount received from sale of major appliances? (Category B)" — Numeric (dollars)

**Small Electrical Appliances**

176. L_Q32: "Electric food preparation appliances?" — Numeric (dollars)
177. L_Q33: "Electric hairstyling and personal care appliances?" — Numeric (dollars)
178. L_Q34: "All other electric appliances and equipment?" — Numeric (dollars)

**Food Equipment**

179. L_Q35: "Tableware, flatware and knives?" — Numeric (dollars)
180. L_Q36: "Non-electric kitchen and cooking equipment?" — Numeric (dollars)

**Lawn, Garden and Snow Removal**

181. L_Q37: "Power lawn and garden equipment?" — Numeric (dollars)
182. L_Q38: "Snow blowers?" — Numeric (dollars)
183. L_Q39: "Other lawn, garden and snow removal tools?" — Numeric (dollars)

**Workshop/Garage Tools**

184. L_Q40: "Power tools and equipment?" — Numeric (dollars)
185. L_Q41: "Other tools?" — Numeric (dollars)

**Other Household Equipment**

186. L_Q42: "Non-electric cleaning equipment?" — Numeric (dollars)
187. L_Q43: "Luggage?" — Numeric (dollars)
188. L_Q44: "Home security equipment?" — Numeric (dollars)
189. L_Q45: "Other household equipment, parts and accessories?" — Numeric (dollars)

**Services**

190. L_Q46: "Maintenance and repair of household equipment (not previously reported)?" — Numeric (dollars)
191. L_Q47: "Other services related to furnishings and equipment (security services, key-making, installations, rentals)?" — Numeric (dollars)

192. L_TOTAL: "Section L Totals: A (all items excl. Q.14.3 and Q.31), B (Q.14.3 and Q.31 only)" — Computed

### Section M: Home Operation — 24 questions

**Communications**

193. M_Q01.1: "Telephone services?" — Numeric (dollars)
194. M_Q01.2: "Cellular services?" — Numeric (dollars)
195. M_Q01.3: "Purchase of equipment (phones, fax, answering machines)?" — Numeric (dollars)
196. M_Q01.4: "Internet services?" — Numeric (dollars)
197. M_Q01.5: "Other charges (wiring, installation, repairs)?" — Numeric (dollars)
198. M_Q02: "Postage stamps and postal services?" — Numeric (dollars)

**Child Care**

199. M_Q03: "Day care centres?" — Numeric (dollars)
200. M_Q04: "Other child care outside the home?" — Numeric (dollars)
201. M_Q05: "Child care in the home?" — Numeric (dollars)

**Home and Garden Services**

202. M_Q06: "Domestic help (housekeepers, cleaners, companions)?" — Numeric (dollars)
203. M_Q07: "Horticultural services, snow and garbage removal?" — Numeric (dollars)

**Flowers and Garden Supplies**

204. M_Q08: "Nursery stock, cut flowers, floral arrangements, decorative plants?" — Numeric (dollars)
205. M_Q09: "Fertilizers, weed controls, herbicides, soils?" — Numeric (dollars)
206. M_Q10: "Insecticides, pesticides and insect repellents?" — Numeric (dollars)

**Pet Expenses**

207. M_Q11: "Pet food?" — Numeric (dollars)
208. M_Q12: "Pet purchase?" — Numeric (dollars)
209. M_Q13: "Pet related goods?" — Numeric (dollars)
210. M_Q14: "Veterinarian services and kennels?" — Numeric (dollars)

**Cleaning Services**

211. M_Q15: "Laundry and dry-cleaning services?" — Numeric (dollars)
212. M_Q16: "Coin-operated washers/dryers, self-service dry-cleaning?" — Numeric (dollars)

**Household Supplies**

213. M_Q17: "Household cleaning supplies (detergent, cleaners, waxes, bleach, fabric softeners, drain cleaners)?" — Numeric (dollars)
214. M_Q18: "Stationery supplies (giftwrap, greeting cards, writing paper, pens, markers, binders, tape)?" — Numeric (dollars)
215. M_Q19: "Other paper and plastic supplies (facial tissue, paper towels, waxed paper, napkins, foil, plastic wraps, garbage bags, disposable cutlery)?" — Numeric (dollars)
216. M_Q20: "Other household supplies (light bulbs, dry cell batteries, candles, ice, road salt, adhesives, string)?" — Numeric (dollars)

### Section N: Food and Alcohol — 13 questions

**Food from Stores**

217. N_Q01: "Food and groceries from stores (average weekly/monthly × periods)?" — Numeric (dollars)
218. N_Q01.1: "Of this, how much on non-food items? (Deducted from A total)" — Numeric (dollars)
219. N_Q02.1: "Additional bulk food purchases?" — Numeric (dollars)
220. N_Q02.2: "Prepared food for parties, weddings, etc.?" — Numeric (dollars)
221. N_Q02.3: "Food purchased from stores while away overnight or longer?" — Numeric (dollars)

**Alcohol from Stores**

222. N_Q03: "Alcoholic beverages from stores?" — Numeric (dollars)
223. N_Q04: "Supplies and fees for self-made beer, wine or liquor?" — Numeric (dollars)

**Food from Restaurants**

224. N_Q05: "Meals and snacks from restaurants?" — Numeric (dollars)
225. N_Q05.1: "Of this, how much spent in this province?" — Numeric (dollars OR percentage)

**Alcohol from Restaurants**

226. N_Q06: "Alcoholic beverages from bars/restaurants?" — Numeric (dollars)
227. N_Q06.1: "Of this, how much spent in this province?" — Numeric (dollars OR percentage)

**Board**

228. N_Q07.1: "Board paid for day board and children's lunches?" — Numeric (dollars)
229. N_Q07.2: "Board while away from home overnight or longer?" — Numeric (dollars)

### Section O: Clothing — 18 questions

*Per-person clothing grids by demographic group, plus gifts and services.*

**Women and Girls 4+ (per person, up to 5)**

230. O_Q01: "Clothing (outerwear, suits, dresses, skirts, slacks, sweaters, hosiery)?" — Numeric (dollars) per person
231. O_Q02: "Footwear?" — Numeric (dollars) per person
232. O_Q03: "Accessories (gloves, hats, purses, umbrellas)?" — Numeric (dollars) per person
233. O_Q04: "Jewellery and watches?" — Numeric (dollars) per person

**Men and Boys 4+ (per person, up to 5)**

234. O_Q05: "Clothing (outerwear, suits, pants, shirts, sweaters, socks)?" — Numeric (dollars) per person
235. O_Q06: "Footwear?" — Numeric (dollars) per person
236. O_Q07: "Accessories (gloves, hats, ties, belts, wallets)?" — Numeric (dollars) per person
237. O_Q08: "Jewellery and watches?" — Numeric (dollars) per person

**Children Under 4 (per person, up to 4)**

238. O_Q09: "Outerwear, daywear, sleepwear and cloth diapers?" — Numeric (dollars) per person
239. O_Q10: "Disposable diapers?" — Numeric (dollars) per person
240. O_Q11: "Footwear?" — Numeric (dollars) per person

**Gifts and Services**

241. O_Q12.1: "Gifts of clothing for women/girls 4+ (non-members)?" — Numeric (dollars)
242. O_Q12.2: "Gifts of clothing for men/boys 4+ (non-members)?" — Numeric (dollars)
243. O_Q12.3: "Gifts of clothing for children under 4 (non-members)?" — Numeric (dollars)
244. O_Q13: "Clothing material?" — Numeric (dollars)
245. O_Q14: "Notions (patterns, buttons, zippers, needles)?" — Numeric (dollars)
246. O_Q15: "Dressmaking, tailoring, clothing storage and services?" — Numeric (dollars)
247. O_Q16: "Maintenance, repair and alteration of clothing/footwear/watches?" — Numeric (dollars)

### Section P: Personal and Health Care — 19 questions

**Personal Care**

248. P_Q01: "Hair grooming services?" — Numeric (dollars)
249. P_Q02: "Other personal services (hair removal, manicures, facials)?" — Numeric (dollars)
250. P_Q03: "Personal care preparations (soap, shampoo, makeup, sunscreen)?" — Numeric (dollars)
251. P_Q04: "Personal care supplies and equipment (brushes, wigs, razors)?" — Numeric (dollars)

**Health Insurance Premiums**

252. P_Q05.1: "Provincial/territorial hospital, medical and drug plans?" — Numeric (dollars)
253. P_Q05.2: "Private health insurance plans?" — Numeric (dollars)
254. P_Q05.3: "Dental plans (separate policies)?" — Numeric (dollars)
255. P_Q05.4: "Accident and disability insurance?" — Numeric (dollars)

**Direct Health Costs**

256. P_Q06: "Prescription eye wear?" — Numeric (dollars)
257. P_Q07: "Other eye care goods?" — Numeric (dollars)
258. P_Q08: "Eye exams, eye surgery and other eye care services?" — Numeric (dollars)
259. P_Q09: "Dental services and orthodontic/periodontal procedures?" — Numeric (dollars)
260. P_Q10: "Physicians' care?" — Numeric (dollars)
261. P_Q11: "Other health care practitioners?" — Numeric (dollars)
262. P_Q12: "Hospital care?" — Numeric (dollars)
263. P_Q13: "Weight control, quit-smoking, other medical services?" — Numeric (dollars)
264. P_Q14: "Prescribed medicines, drugs and pharmaceuticals?" — Numeric (dollars)
265. P_Q15: "Other medicines, drugs and pharmaceuticals (OTC, vitamins)?" — Numeric (dollars)
266. P_Q16: "Health care supplies and goods (first aid, hearing aids, wheelchairs)?" — Numeric (dollars)

### Section Q: Automobiles and Trucks — 24 questions

267. Q_Q01: "In 2000, did anyone own, lease or operate a car, van or truck for private use?" — Yes/No {1: "Yes", 2: "No"} — No → GO TO Q_Q20

**Per-Vehicle Grid (Vehicle A–D)** — Ask Q.2–Q.9 for all vehicles before Q.10

268. Q_Q02: "Which best describes this vehicle?" — Single select {1: "Car", 2: "Van/mini-van", 3: "Truck/SUV"} — Per vehicle

269. Q_Q03: "When bought or leased, was it new or used?" — Single select {1: "New", 2: "Used"} — Per vehicle

270. Q_Q04: "Did you buy this vehicle in 2000?" — Yes/No {1: "Yes", 2: "No"} — Per vehicle. No → GO TO Q_Q06

271. Q_Q05: "Purchase price after trade-in allowance?" — Numeric (dollars) — Per vehicle

272. Q_Q06: "Was this vehicle leased in 2000?" — Yes/No {1: "Yes", 2: "No"} — Per vehicle. No → GO TO Q_Q07

273. Q_Q06.1: "Total leasing cost paid in 2000?" — Numeric (dollars) — Per vehicle

274. Q_Q07: "Status of this vehicle at December 31, 2000?" — Single select {1: "Owned", 2: "Leased", 3: "Returned to lessor", 4: "Sold/traded-in on lease", 5: "Traded-in on purchase", 6: "Owned by non-member", 7: "Other (Specify)"} — 1,2,6 → GO TO Q_Q10; 4 → GO TO Q_Q08; 5 → GO TO Q_Q09; 3,7 → Continue

275. Q_Q08: "If sold or traded-in on lease, net amount received?" — Numeric (dollars) — Per vehicle. GO TO Q_Q10

276. Q_Q09: "If traded-in on purchase, trade-in value?" — Numeric (dollars) — Per vehicle. GO TO Q_Q10

**Operating Expenses (per vehicle)**

277. Q_Q10: "Gas and other fuels?" — Numeric (dollars) — Per vehicle
278. Q_Q11: "Accessories and attachments (radios, heaters, baby seats)?" — Numeric (dollars) — Per vehicle
279. Q_Q12: "Tires, batteries and other parts/supplies?" — Numeric (dollars) — Per vehicle
280. Q_Q13: "Other maintenance and repair?" — Numeric (dollars) — Per vehicle
281. Q_Q14: "Vehicle registration fees?" — Numeric (dollars) — Per vehicle
282. Q_Q15: "Vehicle insurance premiums?" — Numeric (dollars) — Per vehicle
283. Q_Q16: "Parking costs (work, school, park-ride, meters)?" — Numeric (dollars) — Per vehicle
284. Q_Q17: "Other operation services (auto association, towing, tolls)?" — Numeric (dollars) — Per vehicle
285. Q_Q18: "Amount or percentage of operating expenses charged to business?" — Numeric (dollars OR percentage) — Per vehicle
286. Q_Q19: "Value of repair jobs covered by insurance?" — Numeric (dollars) — Per vehicle

**Rented Vehicles**

287. Q_Q20.1: "Rented cars: rental fees / gas / other expenses?" — Numeric (dollars) — 3 sub-columns
288. Q_Q20.2: "Rented trucks or vans: rental fees / gas / other expenses?" — Numeric (dollars) — 3 sub-columns

**Miscellaneous**

289. Q_Q21: "Drivers' licences and tests?" — Numeric (dollars)
290. Q_Q22: "Driving lessons?" — Numeric (dollars)

### Section R: Recreational Vehicles and Transportation — 23 questions

**Bicycles**

291. R_Q01: "Purchase of bicycles, parts and accessories?" — Numeric (dollars)
292. R_Q02: "Bicycle maintenance and repairs?" — Numeric (dollars)

**Recreational Vehicles**

293. R_Q03: "In 2000, did anyone own or operate a recreational vehicle for private use? (Motorcycle, snowmobile, tent/travel trailer, truck camper, boat/canoe, outboard motor, motor home, other)" — Yes/No {1: "Yes", 2: "No"} — No → GO TO R_Q14

**Per Rec Vehicle Grid (A–D)**

294. R_Q04: "Type of vehicle (enter code from Q.3)?" — Single select {1–9} — Per vehicle
295. R_Q05: "If purchased in 2000, price after trade-in?" — Numeric (dollars) — Per vehicle
296. R_Q06: "Accessories, parts for maintenance/repair?" — Numeric (dollars) — Per vehicle
297. R_Q07: "Gasoline, diesel fuel?" — Numeric (dollars) — Per vehicle
298. R_Q08: "Maintenance and repair not covered by insurance?" — Numeric (dollars) — Per vehicle
299. R_Q09: "Vehicle insurance premiums?" — Numeric (dollars) — Per vehicle
300. R_Q10: "Registration fees and licences?" — Numeric (dollars) — Per vehicle
301. R_Q11: "Other expenses (parking, hangar, mooring, storage)?" — Numeric (dollars) — Per vehicle
302. R_Q12: "Amount or percentage of operating expenses charged to business?" — Numeric (dollars OR percentage) — Per vehicle
303. R_Q13: "If sold separately in 2000, net amount received?" — Numeric (dollars) — Per vehicle

304. R_Q14: "Total expenses for rented or leased recreational vehicles?" — Numeric (dollars)

**Transportation Services**

305. R_Q15.1: "City bus, subway, streetcar, commuter train?" — Numeric (dollars)
306. R_Q15.2: "Taxi?" — Numeric (dollars)
307. R_Q15.3: "Airplane?" — Numeric (dollars)
308. R_Q15.4: "Train?" — Numeric (dollars)
309. R_Q15.5: "Highway bus?" — Numeric (dollars)
310. R_Q15.6: "Other passenger transportation (ferry, sightseeing, travel insurance)?" — Numeric (dollars)
311. R_Q16: "Household moving, storage and delivery services?" — Numeric (dollars)

**Package Trips**

312. R_Q17: "Did any member take a package trip in 2000?" — Yes/No {1: "Yes", 2: "No"} — No → GO TO Section S

313. R_Q17.1: "Cost of package trips?" — Numeric (dollars)

### Section S: Recreation, Reading Materials and Education — 32 questions

**Sports, Camping Equipment**

314. S_Q01: "Sports and athletic equipment?" — Numeric (dollars)
315. S_Q02: "Camping and picnic equipment?" — Numeric (dollars)

**Photographic**

316. S_Q03: "Cameras, parts, accessories and photographic goods?" — Numeric (dollars)
317. S_Q04: "Film, processing, prints and enlargements?" — Numeric (dollars)
318. S_Q05: "Photographers' services?" — Numeric (dollars)

**Musical**

319. S_Q06: "Musical instruments, parts and accessories?" — Numeric (dollars)

**Other Recreation Equipment**

320. S_Q07: "Artists' materials, handicraft/hobbycraft supplies?" — Numeric (dollars)
321. S_Q08: "Electronic games and parts?" — Numeric (dollars)
322. S_Q09: "Toys and other games?" — Numeric (dollars)
323. S_Q10: "Playground equipment and swimming pool accessories?" — Numeric (dollars)
324. S_Q11: "Collectors' items (stamps, coins)?" — Numeric (dollars)
325. S_Q12: "Parts and supplies for recreation equipment (camp fuels, pool chemicals, ammo)?" — Numeric (dollars)
326. S_Q13: "Rental of video games?" — Numeric (dollars)
327. S_Q14: "Rental, maintenance and repair of recreation/sports equipment?" — Numeric (dollars)

**Admissions**

328. S_Q15.1: "Movie theatres?" — Numeric (dollars)
329. S_Q15.2: "Live performing arts (plays, concerts, festivals)?" — Numeric (dollars)
330. S_Q15.3: "Heritage facilities (museums, zoos, fairs, historic sites)?" — Numeric (dollars)
331. S_Q15.4: "Live sports events?" — Numeric (dollars)

**Recreation Services**

332. S_Q16: "Coin-operated and carnival games?" — Numeric (dollars)
333. S_Q17: "Membership fees for sports/recreation/health clubs?" — Numeric (dollars)
334. S_Q18: "Single usage fees for sports/recreation/health clubs?" — Numeric (dollars)
335. S_Q19: "Children's camps (day camps, summer camps)?" — Numeric (dollars)
336. S_Q20: "Other cultural/recreational services (fishing/hunting licences, party planning)?" — Numeric (dollars)

**Reading Materials**

337. S_Q21: "Newspapers?" — Numeric (dollars)
338. S_Q22: "Magazines and periodicals?" — Numeric (dollars)
339. S_Q23: "Books and pamphlets?" — Numeric (dollars)
340. S_Q24: "Maps, sheet music and other printed matter?" — Numeric (dollars)
341. S_Q25: "Services (duplicating, library charges, book rentals, bookbinding)?" — Numeric (dollars)

**Education**

342. S_Q26: "Elementary/secondary education — Tuition / Books / Supplies?" — Numeric (dollars) — 3 sub-columns
343. S_Q27: "Post-secondary education — Tuition / Books / Supplies?" — Numeric (dollars) — 3 sub-columns
344. S_Q28: "Other courses and lessons (music, dancing, sports, crafts)?" — Numeric (dollars)
345. S_Q29: "Other educational services (rental of school books/equipment)?" — Numeric (dollars)

### Section T: Tobacco and Miscellaneous — 25 questions

**Tobacco**

346. T_Q01: "Cigarettes, tobacco, cigars and similar products?" — Numeric (dollars)
347. T_Q02: "Smokers' supplies (matches, pipes, lighters, ashtrays)?" — Numeric (dollars)

**Financial Services**

348. T_Q03.1: "Service charges for banks and financial institutions?" — Numeric (dollars)
349. T_Q03.2: "Stock and bond commissions?" — Numeric (dollars)
350. T_Q03.3: "Administration fees for brokers?" — Numeric (dollars)
351. T_Q03.4: "Other financial services (planning, tax preparation, accounting)?" — Numeric (dollars)

**Gambling (Expenses and Winnings)**

352. T_Q04.1: "Government-run lotteries — expenses / winnings?" — Numeric (dollars) — 2 sub-columns
353. T_Q04.2: "Bingos — expenses / winnings?" — Numeric (dollars) — 2 sub-columns
354. T_Q04.3: "Non-government lotteries and games of chance — expenses / winnings?" — Numeric (dollars) — 2 sub-columns
355. T_Q04.4: "Casinos, slot machines and VLTs — expenses / winnings?" — Numeric (dollars) — 2 sub-columns

**Miscellaneous**

356. T_Q05: "Loss of deposits, fines, money lost or stolen?" — Numeric (dollars)
357. T_Q06: "Contributions and dues for social clubs, co-operatives, political organizations?" — Numeric (dollars)
358. T_Q07: "Tools and equipment purchased for work (wage/salaried workers)?" — Numeric (dollars)
359. T_Q08: "Legal services not related to dwellings?" — Numeric (dollars)
360. T_Q09: "Other expenses for goods? (Specify)" — Numeric (dollars) + Text
361. T_Q10: "Other expenses for services (passports, funerals, hall rentals)? (Specify)" — Numeric (dollars) + Text

**Direct Sales**

362. T_Q11: "Did your household purchase goods through direct sales (door-to-door, mail order, catalogue, Internet)?" — Yes/No {1: "Yes", 2: "No"} — No → GO TO T_Q12

363. T_Q11.1.1: "Food and beverages through direct sales?" — Yes/No
364. T_Q11.1.2: "Books, newspapers and magazines?" — Yes/No
365. T_Q11.1.3: "Clothing, cosmetics and jewellery?" — Yes/No
366. T_Q11.1.4: "Home entertainment products?" — Yes/No
367. T_Q11.1.5: "Other products used inside the home?" — Yes/No
368. T_Q11.1.6: "Other products used outside the home?" — Yes/No
369. T_Q11.2: "How much spent on goods through direct sales?" — Numeric (dollars)

**Purchases Outside Canada**

370. T_Q12: "How much spent on goods and services purchased outside Canada?" — Numeric (dollars)

### Section U: Personal Income — 18 questions

*Per person, 15 years or over on December 31, 2000 (up to 5 persons).*

371. U_Q01.1: "Weeks worked full-time in 2000 (including holidays with pay)?" — Numeric (0–52) — Per person
372. U_Q01.2: "Weeks worked part-time in 2000?" — Numeric (0–52) — Per person
373. U_Q02: "Wages and salaries before deductions (incl. bonuses, tips, commissions)?" — Numeric (dollars) — Per person
374. U_Q03: "NET income from farm and non-farm self-employment?" — Numeric (dollars) — Per person
375. U_Q04.1: "GROSS income from roomers/boarders who were household members (non-relatives)?" — Numeric (dollars) — Per person
376. U_Q04.2: "GROSS income from roomers/boarders who were not household members?" — Numeric (dollars) — Per person
377. U_Q05: "Dividends, interest on bonds/accounts/GICs, other investment income?" — Numeric (dollars) — Per person
378. U_Q06: "Child Tax Benefit (including Quebec Family Allowance)?" — Numeric (dollars) — Per person
379. U_Q07: "Old Age Security Pension, GIS, Spouse's Allowance?" — Numeric (dollars) — Per person
380. U_Q08: "Canada or Quebec Pension Plan Benefits?" — Numeric (dollars) — Per person
381. U_Q09: "Employment Insurance Benefits (before deductions)?" — Numeric (dollars) — Per person
382. U_Q10: "Goods and Services Tax Credit (received in 2000)?" — Numeric (dollars) — Per person
383. U_Q11: "Provincial Tax Credits (claimed on 1999 returns)?" — Numeric (dollars) — Per person
384. U_Q12: "Social Assistance, Workers' Compensation, Veterans' Pensions, other government income?" — Numeric (dollars) — Per person
385. U_Q13: "Retirement Pensions, Superannuation, Annuities and RRIF Withdrawals?" — Numeric (dollars) — Per person
386. U_Q14: "Personal Income Tax Refunds?" — Numeric (dollars) — Per person
387. U_Q15: "Other Money Income (alimony, child support, scholarships, etc.)?" — Numeric (dollars) — Per person
388. U_Q16: "Other Money Receipts (gifts, inheritances, life insurance settlements)?" — Numeric (dollars) — Per person

### Section V: Personal Taxes, Security and Money Gifts — 15 questions

*Per person, 15 years or over (up to 5 persons).*

**Personal Taxes**

389. V_Q01: "Income tax on 2000 income?" — Numeric (dollars) — Per person
390. V_Q02: "Income tax on income for years prior to 2000?" — Numeric (dollars) — Per person
391. V_Q03: "Other personal taxes (e.g., gift tax)?" — Numeric (dollars) — Per person

**Security and Employment Payments**

392. V_Q04: "Premiums on life, term and endowment insurance?" — Numeric (dollars) — Per person
393. V_Q05: "Annuity contracts and transfers to RRIFs?" — Numeric (dollars) — Per person
394. V_Q06: "Employment insurance (deductions from pay)?" — Numeric (dollars) — Per person
395. V_Q07: "Government retirement or pension fund?" — Numeric (dollars) — Per person
396. V_Q08: "Canada/Quebec pension plan?" — Numeric (dollars) — Per person
397. V_Q09: "Other retirement or pension funds?" — Numeric (dollars) — Per person
398. V_Q10: "Dues to unions and professional associations?" — Numeric (dollars) — Per person

**Money Gifts, Contributions and Support**

399. V_Q11: "Support payments to former spouse or partner?" — Numeric (dollars) — Per person
400. V_Q12.1: "Money given to persons living in Canada?" — Numeric (dollars) — Per person
401. V_Q12.2: "Money given to persons living outside Canada?" — Numeric (dollars) — Per person
402. V_Q13.1: "Charitable contributions to religious organizations?" — Numeric (dollars) — Per person
403. V_Q13.2: "Charitable contributions to other organizations?" — Numeric (dollars) — Per person

### Section W: Change in Assets — 13 questions

*Report as household totals. Report changes, not levels.*

404. W_Q01.1_inc: "NET CHANGE (increase) in cash in banks, trust companies, cash on hand (incl. GICs, excl. RRSPs)?" — Numeric (dollars)
405. W_Q01.1_dec: "NET CHANGE (decrease) in same?" — Numeric (dollars)
406. W_Q01.2_inc: "NET CHANGE (increase) in money owed to household?" — Numeric (dollars)
407. W_Q01.2_dec: "NET CHANGE (decrease) in same?" — Numeric (dollars)
408. W_Q01.3_inc: "NET CHANGE (increase) in money deposited as pledge for future purchases?" — Numeric (dollars)
409. W_Q01.3_dec: "NET CHANGE (decrease) in same?" — Numeric (dollars)

**RRSPs**

410. W_Q02_contrib: "RRSP contributions in 2000?" — Numeric (dollars)
411. W_Q02_withdraw: "RRSP withdrawals in 2000?" — Numeric (dollars)

**Purchases and Sales**

412. W_Q03.1_purchase: "Savings bonds and treasury bills — purchases?" — Numeric (dollars)
413. W_Q03.1_sale: "Savings bonds and treasury bills — sales?" — Numeric (dollars)
414. W_Q03.2_purchase: "Publicly traded stocks, mutual funds, investment club shares — purchases?" — Numeric (dollars)
415. W_Q03.2_sale: "Same — sales?" — Numeric (dollars)
416. W_Q03.3_sale: "Sales of personal property not traded in on new items?" — Numeric (dollars)

### Section X: Unincorporated Business — 10 questions

417. X_Q01: "In 2000, did any member have investments in unincorporated businesses, farms or rental property?" — Yes/No {1: "Yes", 2: "No"} — No → GO TO Section Y

418. X_Q01.1: "Principal repayment on mortgage(s) or loan(s)?" — Numeric (dollars)
419. X_Q01.2: "Payment to purchase assets (machinery, trucks, buildings)?" — Numeric (dollars)
420. X_Q01.3: "Amount borrowed for business or farm?" — Numeric (dollars)
421. X_Q01.4: "Amount received from sale of assets?" — Numeric (dollars)
422. X_Q01.5: "Capital cost allowance (depreciation) estimate?" — Numeric (dollars)

**Accounts Receivable and Payable**

423. X_Q02.1_inc: "NET CHANGE (increase) in accounts receivable?" — Numeric (dollars)
424. X_Q02.1_dec: "NET CHANGE (decrease) in accounts receivable?" — Numeric (dollars)
425. X_Q02.2_inc: "NET CHANGE (increase) in accounts payable? (Note: C/D columns deliberately reversed)" — Numeric (dollars)
426. X_Q02.2_dec: "NET CHANGE (decrease) in accounts payable?" — Numeric (dollars)

### Section Y: Loans and Other Debts — 11 questions

427. Y_Q01: "In 2000, did your household have any loans with regular payments? (Include installment plans, student loans if repaying. Exclude lines of credit, credit cards.)" — Yes/No {1: "Yes", 2: "No"} — No → GO TO Y_Q06

**Per-Loan Grid (Loan A–E)** — Ask Q.2–Q.5.1 for all loans before Q.6

428. Y_Q02: "Description of loan (e.g., car, boat)" — Text — Per loan
429. Y_Q03: "Was this loan taken out in 2000?" — Yes/No {1: "Yes", 2: "No"} — Per loan. No → GO TO Y_Q04
430. Y_Q03.1: "Amount of the loan?" — Numeric (dollars) — Per loan
431. Y_Q04: "Total payments made on this loan in 2000 (incl. lump sum)?" — Numeric (dollars) — Per loan
432. Y_Q05: "Was there additional amount borrowed in 2000 on this loan?" — Yes/No {1: "Yes", 2: "No"} — Per loan. No → GO TO Y_Q06
433. Y_Q05.1: "What was the additional amount?" — Numeric (dollars) — Per loan

**Other Money Owed** (Jan 1 amount, Dec 31 amount, difference, interest)

434. Y_Q06: "Loans from financial institutions (incl. lines of credit, student loans not yet repaying)" — Numeric (dollars) — 5 sub-columns: Jan 1, Dec 31, diff-if-Jan-larger, diff-if-Dec-larger, interest
435. Y_Q07: "Credit cards from financial institutions" — Numeric (dollars) — 5 sub-columns
436. Y_Q08: "Credit cards and debts with stores, service stations, retail" — Numeric (dollars) — 5 sub-columns
437. Y_Q09: "Rents, taxes and other bills (e.g., hospital)" — Numeric (dollars) — 5 sub-columns
