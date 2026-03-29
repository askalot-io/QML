# American Community Survey (ACS) 2025 - Question Inventory

## Verification Status

| Section | Source Items | Inventory Items | Missing | Source SKIPs | Inv. SKIPs | Missing |
|---------|------------|----------------|---------|-------------|-----------|---------|
| Cover & Household | 2 | 2 | 0 | 0 | 0 | 0 |
| Person Roster | 6 | 6 | 0 | 0 | 0 | 0 |
| Housing (incl. Filters A-E) | 52 | 52 | 0 | 13 | 13 | 0 |
| Education & Migration (incl. Filter F) | 8 | 8 | 0 | 3 | 3 | 0 |
| Language & Ancestry | 5 | 5 | 0 | 4 | 4 | 0 |
| Migration & Health Intro | 2 | 2 | 0 | 0 | 0 | 0 |
| Health Insurance (incl. Filter G) | 4 | 4 | 0 | 2 | 2 | 0 |
| Disability (incl. Filters H, I) | 6 | 6 | 0 | 2 | 2 | 0 |
| Marriage & Family (incl. Filter J) | 9 | 9 | 0 | 2 | 2 | 0 |
| Grandchildren & Military | 7 | 7 | 0 | 5 | 5 | 0 |
| Employment (incl. Filters K, L, M) | 30 | 30 | 0 | 14 | 14 | 0 |
| Income | 9 | 9 | 0 | 0 | 0 | 0 |

- **Coverage**: 12/12 sections verified, 140 items total (2 cover + 6 roster + 52 housing + 80 person detail)
- **Routing**: 45/45 SKIP routing decisions captured (13 housing + 32 person)
- **Filters**: 13/13 lettered filter boxes (A-E housing, F-M person) all present
- **Persons 6-12**: Abbreviated entries documented in roster notes (name, sex, age only)
- **Status**: READY FOR QML
- **Missing**: none

## Document Overview

- **Title**: American Community Survey
- **Organization**: U.S. Census Bureau
- **Pages**: 48 (content on pages 1-18; pages 19-47 repeat Person questions for Persons 2-5; page 48 mailing)
- **Language**: English
- **Type**: Self-administered paper questionnaire (mail-back form ACS-1(INFO)(2025))
- **OMB Numbers**: 0607-0810, 0607-0936
- **Estimated Completion Time**: 40 minutes per household

## Structure

The ACS 2025 is a household-level paper questionnaire with three main parts:

1. **Cover & Person Roster** (pages 1-7): Household count and basic demographics (name, relationship, sex, age/DOB, Hispanic origin, race) for up to 12 persons. Persons 1-5 get full pages; Persons 6-12 get abbreviated entries (name, sex, age only).

2. **Housing** (pages 8-11): 27 questions about the dwelling, utilities, costs, and tenure. Contains 5 lettered filter points (A-E) creating skip paths based on building type, tenure, and ownership.

3. **Person Detail** (pages 12-18 for Person 1; repeated identically for Persons 2-5): Questions 7-44 covering education, language, migration, health insurance, disability, marriage, family, military service, employment, and income. Contains 8 lettered filter points (F-M) creating age/sex/status-based skip paths.

**Note on repetition**: The Person Roster (Q1-6) repeats identically for Persons 1-5. The Person Detail section (Q7-44) repeats identically for Persons 2-5 ("The questions are the same as the questions for Person 1"). This inventory documents the template once; QML files will model a single-person flow.

## Question Inventory by Section

### Cover & Household — 2 questions

1. COVER_CONTACT: "Please print the name and telephone number of the person who is filling out this form." — Text (last name, first name, MI, area code + number) — GO TO COVER_COUNT

2. COVER_COUNT: "How many people, including yourself, live or stay at this address?" — Numeric (1–12) — GO TO Person Roster

---

### Person Roster (Person 1 template) — 6 questions

Questions 1-6 are asked for each person in the household. This documents the Person 1 version; Persons 2-5 are identical except Q2 has relationship options instead of "Person 1". Persons 6-12 collect only name, sex, and age.

3. P_Q1: "What is Person 1's name?" — Text (last name, first name, MI) — GO TO P_Q2

4. P_Q2: "How is this person related to Person 1?" — Single select {1: "Person 1"} — For Person 1, pre-filled as "Person 1". For Persons 2+: Single select {1: "Opposite-sex husband/wife/spouse", 2: "Opposite-sex unmarried partner", 3: "Same-sex husband/wife/spouse", 4: "Same-sex unmarried partner", 5: "Biological son or daughter", 6: "Adopted son or daughter", 7: "Stepson or stepdaughter", 8: "Brother or sister", 9: "Father or mother", 10: "Grandchild", 11: "Parent-in-law", 12: "Son-in-law or daughter-in-law", 13: "Other relative", 14: "Roommate or housemate", 15: "Foster child", 16: "Other nonrelative"} — GO TO P_Q3

5. P_Q3: "What is Person 1's sex?" — Single select {1: "Male", 2: "Female"} — GO TO P_Q4

6. P_Q4: "What is Person 1's age and what is Person 1's date of birth?" — Numeric (age 0–120) + Date (month/day/year of birth) — GO TO P_Q5

7. P_Q5: "Is Person 1 of Hispanic, Latino, or Spanish origin?" — Single select {0: "No, not of Hispanic, Latino, or Spanish origin", 1: "Yes, Mexican, Mexican Am., Chicano", 2: "Yes, Puerto Rican", 3: "Yes, Cuban", 4: "Yes, another Hispanic, Latino, or Spanish origin"} — Option 4 includes write-in for specific origin — GO TO P_Q6

8. P_Q6: "What is Person 1's race? Mark one or more boxes AND print origins." — Multi select {1: "White", 2: "Black or African Am.", 3: "American Indian or Alaska Native", 4: "Chinese", 5: "Filipino", 6: "Asian Indian", 7: "Other Asian", 8: "Vietnamese", 9: "Korean", 10: "Japanese", 11: "Native Hawaiian", 12: "Samoan", 13: "Chamorro", 14: "Other Pacific Islander", 15: "Some other race"} — Each option includes write-in for specific origin/tribe — GO TO next person or Housing section

---

### Housing — 52 items (47 questions + 5 filters)

Housing questions use their own numbering (1-27 with sub-parts). Lettered filter boxes (A-E) control skip patterns based on building type, tenure, and ownership.

9. H_Q1: "Which best describes this building? Include all apartments, flats, etc., even if vacant." — Single select {1: "A mobile home", 2: "A one-family house detached from any other house", 3: "A one-family house attached to one or more houses", 4: "A building with 2 apartments", 5: "A building with 3 or 4 apartments", 6: "A building with 5 to 9 apartments", 7: "A building with 10 to 19 apartments", 8: "A building with 20 to 49 apartments", 9: "A building with 50 or more apartments", 10: "Boat, RV, van, etc."} — GO TO H_Q2

10. H_Q2: "About when was this building first built?" — Single select {1: "2020 or later (specify year)", 2: "2010 to 2019", 3: "2000 to 2009", 4: "1990 to 1999", 5: "1980 to 1989", 6: "1970 to 1979", 7: "1960 to 1969", 8: "1950 to 1959", 9: "1940 to 1949", 10: "1939 or earlier"} — GO TO H_Q3

11. H_Q3: "When did PERSON 1 move into this house, apartment, or mobile home?" — Date (month/year) — GO TO Filter A

12. FILTER_A: "Answer questions 4-5 if this is a HOUSE OR A MOBILE HOME; otherwise, SKIP to question 6a." — Filter — If H_Q1 in {1, 2, 3} (mobile home or one-family house) → GO TO H_Q4; else → SKIP TO H_Q6a

13. H_Q4: "How many acres is this house or mobile home on?" — Single select {1: "Less than 1 acre", 2: "1 to 9.9 acres", 3: "10 or more acres"} — 1 → SKIP TO H_Q6a; 2,3 → GO TO H_Q5

14. H_Q5: "IN THE PAST 12 MONTHS, what were the actual sales of all agricultural products from this property?" — Single select {0: "None", 1: "$1 to $999", 2: "$1,000 to $2,499", 3: "$2,500 to $4,999", 4: "$5,000 to $9,999", 5: "$10,000 or more"} — GO TO H_Q6a

15. H_Q6a: "How many separate rooms are in this house, apartment, or mobile home?" — Numeric (1–30) — GO TO H_Q6b

16. H_Q6b: "How many of these rooms are bedrooms?" — Numeric (0–30) — GO TO H_Q7a

17. H_Q7a: "Does this house, apartment, or mobile home have hot and cold running water?" — Yes/No — GO TO H_Q7b

18. H_Q7b: "Does this house, apartment, or mobile home have a bathtub or shower?" — Yes/No — GO TO H_Q7c

19. H_Q7c: "Does this house, apartment, or mobile home have a sink with a faucet?" — Yes/No — GO TO H_Q7d

20. H_Q7d: "Does this house, apartment, or mobile home have a stove or range?" — Yes/No — GO TO H_Q7e

21. H_Q7e: "Does this house, apartment, or mobile home have a refrigerator?" — Yes/No — GO TO H_Q8

22. H_Q8: "Is this house, apartment, or mobile home connected to a public sewer?" — Single select {1: "Yes, connected to public sewer", 2: "No, connected to septic tank", 3: "No, use other type of system"} — GO TO H_Q9

23. H_Q9: "Can you or any member of this household both make and receive phone calls when at this house, apartment, or mobile home?" — Yes/No — GO TO H_Q10a

24. H_Q10a: "At this house, apartment, or mobile home — do you or any member of this household own or use a desktop or laptop?" — Yes/No — GO TO H_Q10b

25. H_Q10b: "...own or use a smartphone?" — Yes/No — GO TO H_Q10c

26. H_Q10c: "...own or use a tablet or other portable wireless computer?" — Yes/No — GO TO H_Q10d

27. H_Q10d: "...own or use some other type of computer?" — Yes/No + Text (specify) — GO TO H_Q11

28. H_Q11: "At this house, apartment, or mobile home — do you or any member of this household have access to the Internet?" — Single select {1: "Yes, by paying a cell phone company or Internet service provider", 2: "Yes, without paying a cell phone company or Internet service provider", 3: "No access to the Internet at this house, apartment, or mobile home"} — 1 → GO TO H_Q12a; 2 → SKIP TO H_Q13; 3 → SKIP TO H_Q13

29. H_Q12a: "Do you or any member of this household have access to the Internet using a cellular data plan for a smartphone or other mobile device?" — Yes/No — GO TO H_Q12b

30. H_Q12b: "...broadband (high speed) Internet service such as cable, fiber optic, or DSL service installed in this household?" — Yes/No — GO TO H_Q12c

31. H_Q12c: "...satellite Internet service installed in this household?" — Yes/No — GO TO H_Q12d

32. H_Q12d: "...dial-up Internet service installed in this household?" — Yes/No — GO TO H_Q12e

33. H_Q12e: "...some other service?" — Yes/No + Text (specify service) — GO TO H_Q13

34. H_Q13: "How many automobiles, vans, and trucks of one-ton capacity or less are kept at home for use by members of this household?" — Single select {0: "None", 1: "1", 2: "2", 3: "3", 4: "4", 5: "5", 6: "6 or more"} — 0 → SKIP TO H_Q15; 1-6 → GO TO H_Q14

35. H_Q14: "Do you or any member of this household own or lease an electric vehicle? Include both all-electric and plug-in hybrid electric vehicles." — Yes/No — GO TO H_Q15

36. H_Q15: "Which FUEL is used MOST for heating this house, apartment, or mobile home?" — Single select {1: "Gas: Natural gas from underground pipes", 2: "Gas: Bottled or tank (propane, butane, etc.)", 3: "Electricity", 4: "Fuel oil, kerosene, etc.", 5: "Coal or coke", 6: "Wood", 7: "Solar energy", 8: "Other fuel", 9: "No fuel used"} — GO TO H_Q16

37. H_Q16: "Does this house, apartment, or mobile home use solar panels that generate electricity?" — Yes/No — GO TO H_Q17a

38. H_Q17a: "LAST MONTH, what was the cost of electricity for this house, apartment, or mobile home?" — Numeric (dollars) OR Single select {97: "Included in rent or condominium fee", 98: "No charge or electricity not used"} — GO TO H_Q17b

39. H_Q17b: "LAST MONTH, what was the cost of gas for this house, apartment, or mobile home?" — Numeric (dollars) OR Single select {97: "Included in rent or condominium fee", 98: "Included in electricity payment entered above", 99: "No charge or gas not used"} — GO TO H_Q17c

40. H_Q17c: "IN THE PAST 12 MONTHS, what was the cost of water and sewer for this house, apartment, or mobile home?" — Numeric (dollars) OR Single select {97: "Included in rent or condominium fee", 98: "No charge"} — GO TO H_Q17d

41. H_Q17d: "IN THE PAST 12 MONTHS, what was the cost of oil, coal, kerosene, wood, etc., for this house, apartment, or mobile home?" — Numeric (dollars) OR Single select {97: "Included in rent or condominium fee", 98: "No charge or these fuels not used"} — GO TO H_Q18

42. H_Q18: "IN THE PAST 12 MONTHS, did you or any member of this household receive benefits from the Food Stamp Program or SNAP?" — Yes/No — GO TO H_Q19

43. H_Q19: "Is this house, apartment, or mobile home part of a homeowners association or condominium?" — Single select {1: "Yes", 2: "No"} — 1 → includes follow-up for monthly HOA/condo fee (Numeric dollars, or "None"); all → GO TO H_Q20

44. H_Q20: "Is this house, apartment, or mobile home —" — Single select {1: "Owned by you or someone in this household with a mortgage or loan?", 2: "Owned by you or someone in this household free and clear (without a mortgage or loan)?", 3: "Rented?", 4: "Occupied without payment of rent?"} — 4 → SKIP TO FILTER_C; 3 → GO TO FILTER_B; 1,2 → GO TO FILTER_B

45. FILTER_B: "Answer questions 21a and b if this house, apartment, or mobile home is RENTED. Otherwise, SKIP to question 22." — Filter — If H_Q20 = 3 → GO TO H_Q21a; else → SKIP TO H_Q22

46. H_Q21a: "What is the monthly rent for this house, apartment, or mobile home?" — Numeric (dollars) — GO TO H_Q21b

47. H_Q21b: "Does the monthly rent include any meals?" — Yes/No — GO TO FILTER_C

48. FILTER_C: "Answer questions 22-26 if you or any member of this household OWNS or IS BUYING this house, apartment, or mobile home. Otherwise, SKIP to E." — Filter — If H_Q20 in {1, 2} → GO TO H_Q22; else → SKIP TO FILTER_E

49. H_Q22: "About how much do you think this house and lot, apartment, or mobile home would sell for if it were for sale?" — Numeric (dollars) — GO TO H_Q23

50. H_Q23: "What are the annual real estate taxes on THIS property?" — Numeric (dollars) OR "None" — GO TO H_Q24

51. H_Q24: "What is the annual payment for fire, hazard, and flood insurance on THIS property?" — Numeric (dollars) OR "None" — GO TO H_Q25a

52. H_Q25a: "Do you or any member of this household have a mortgage, deed of trust, contract to purchase, or similar debt on THIS property?" — Single select {1: "Yes, mortgage, deed of trust, or similar debt", 2: "Yes, contract to purchase", 3: "No"} — 3 → SKIP TO H_Q26a; 1,2 → GO TO H_Q25b

53. H_Q25b: "How much is the regular monthly mortgage payment on THIS property?" — Numeric (dollars) OR "No regular payment required" — "No regular payment" → SKIP TO H_Q26a; else → GO TO H_Q25c

54. H_Q25c: "Does the regular monthly mortgage payment include payments for real estate taxes on THIS property?" — Single select {1: "Yes, taxes included in mortgage payment", 2: "No, taxes paid separately or taxes not required"} — GO TO H_Q25d

55. H_Q25d: "Does the regular monthly mortgage payment include payments for fire, hazard, or flood insurance on THIS property?" — Single select {1: "Yes, insurance included in mortgage payment", 2: "No, insurance paid separately or no insurance"} — GO TO H_Q26a

56. H_Q26a: "Do you or any member of this household have a second mortgage or a home equity loan on THIS property?" — Single select {1: "Yes, home equity loan", 2: "Yes, second mortgage", 3: "Yes, second mortgage and home equity loan", 4: "No"} — 4 → SKIP TO FILTER_D; 1,2,3 → GO TO H_Q26b

57. H_Q26b: "How much is the regular monthly payment on all second or junior mortgages and all home equity loans on THIS property?" — Numeric (dollars) OR "No regular payment required" — GO TO FILTER_D

58. FILTER_D: "Answer question 27 if this is a MOBILE HOME. Otherwise, SKIP to E." — Filter — If H_Q1 = 1 → GO TO H_Q27; else → SKIP TO FILTER_E

59. H_Q27: "What are the total annual costs for personal property taxes, site rent, registration fees, and license fees on THIS mobile home and its site? Exclude real estate taxes." — Numeric (dollars) — GO TO FILTER_E

60. FILTER_E: "Answer questions about PERSON 1 on the next page. If no one is listed as PERSON 1 on page 2, SKIP to page 48 for mailing instructions." — Filter — If person_count >= 1 → GO TO P_Q7; else → END

---

### Education & Migration — 8 questions

Person detail questions begin at Q7. These are asked for Person 1 (and repeated identically for Persons 2-5).

61. P_Q7: "Where was this person born?" — Single select {1: "In the United States", 2: "Outside the United States"} — Option 1 includes write-in for state name; Option 2 includes write-in for foreign country — GO TO P_Q8

62. P_Q8: "Is this person a citizen of the United States?" — Single select {1: "Yes, born in the United States", 2: "Yes, born in Puerto Rico, Guam, the U.S. Virgin Islands, or Northern Marianas", 3: "Yes, born abroad of U.S. citizen parent or parents", 4: "Yes, U.S. citizen by naturalization", 5: "No, not a U.S. citizen"} — 1 → SKIP TO P_Q10a; 4 → includes write-in for year of naturalization, GO TO P_Q8_YEAR; 2,3,5 → GO TO P_Q8_YEAR

63. P_Q8_YEAR: "When did this person come to live in the United States? If this person came to live in the United States more than once, print latest year." — Numeric (year) — GO TO P_Q10a

64. P_Q10a: "At any time IN THE LAST 3 MONTHS, has this person attended school or college?" — Single select {0: "No, has not attended in the last 3 months", 1: "Yes, public school, public college", 2: "Yes, private school, private college, home school"} — 0 → SKIP TO P_Q11; 1,2 → GO TO P_Q10b

65. P_Q10b: "What grade or level was this person attending?" — Single select {1: "Nursery school, preschool", 2: "Kindergarten", 3: "Grade 1 through 12 (specify grade)", 4: "College undergraduate years (freshman to senior)", 5: "Graduate or professional school beyond a bachelor's degree"} — GO TO P_Q11

66. P_Q11: "What is the highest grade of school or degree this person has COMPLETED?" — Single select {1: "Less than grade 1", 2: "Grade 1 through 11 (specify grade)", 3: "12th grade – NO DIPLOMA", 4: "Regular high school diploma", 5: "GED or alternative credential", 6: "Some college credit, but less than 1 year", 7: "1 or more years of college credit, no degree", 8: "Associate's degree (AA, AS)", 9: "Bachelor's degree (BA, BS)", 10: "Master's degree (MA, MS, MEng, MEd, MSW, MBA)", 11: "Professional degree beyond bachelor's (MD, DDS, DVM, LLB, JD)", 12: "Doctorate degree (PhD, EdD)"} — GO TO FILTER_F

67. FILTER_F: "Answer question 12 if this person has a bachelor's degree or higher. Otherwise, SKIP to question 13." — Filter — If P_Q11 in {9, 10, 11, 12} → GO TO P_Q12; else → SKIP TO P_Q13

68. P_Q12: "This question focuses on this person's BACHELOR'S DEGREE. Please print below the specific major(s) of any BACHELOR'S DEGREES this person has received." — Text (two fields for major) — GO TO P_Q13

---

### Language & Ancestry — 5 questions

69. P_Q13: "What is this person's ancestry or ethnic origin?" — Text (e.g., Italian, Jamaican, African Am., etc.) — GO TO P_Q14a

70. P_Q14a: "Does this person speak a language other than English at home?" — Yes/No — No → SKIP TO P_Q15a; Yes → GO TO P_Q14b

71. P_Q14b: "What is this language?" — Text (e.g., Korean, Italian, Spanish, Vietnamese) — GO TO P_Q14c

72. P_Q14c: "How well does this person speak English?" — Single select {1: "Very well", 2: "Well", 3: "Not well", 4: "Not at all"} — GO TO P_Q15a

73. P_Q15a: "Did this person live in this house or apartment 1 year ago?" — Single select {0: "Person is under 1 year old", 1: "Yes, this house", 2: "No, outside the United States and Puerto Rico", 3: "No, different house in the United States or Puerto Rico"} — 0 → SKIP TO P_Q16; 1 → SKIP TO P_Q16; 2 → includes write-in for foreign country, SKIP TO P_Q16; 3 → GO TO P_Q15b

---

### Migration — 2 questions

74. P_Q15b: "Where did this person live 1 year ago?" — Text (address, city, county, state, ZIP) — GO TO P_Q16

75. P_Q16: "Is this person CURRENTLY covered by any of the following types of health insurance or health coverage plans?" — Multi select {1: "Insurance through a current or former employer, union, or professional association", 2: "Medicare", 3: "Medicaid, CHIP, or government-assistance plan", 4: "Insurance purchased directly from an insurance company, broker, or Marketplace", 5: "Veteran's health care (enrolled for VA)", 6: "TRICARE or other military health care", 7: "Indian Health Service", 8: "Any other type of health insurance or health coverage plan", 0: "No health insurance or health coverage plan"} — Option 8 includes write-in to specify; GO TO FILTER_G

---

### Health Insurance — 4 questions

76. FILTER_G: "Answer question 17a if this person is covered by health insurance. Otherwise, SKIP to question 18a." — Filter — If P_Q16 has any option 1-8 selected → GO TO P_Q17a; else (P_Q16 = 0) → SKIP TO P_Q18a

77. P_Q17a: "Is there a premium for this plan?" — Yes/No — No → SKIP TO P_Q18a; Yes → GO TO P_Q17b

78. P_Q17b: "Does this person or another family member receive a tax credit or subsidy based on family income to help pay the premium?" — Yes/No — GO TO P_Q18a

79. P_Q18a: "Is this person deaf or does he/she have serious difficulty hearing?" — Yes/No — GO TO P_Q18b

---

### Disability — 6 questions

80. P_Q18b: "Is this person blind or does he/she have serious difficulty seeing even when wearing glasses?" — Yes/No — GO TO FILTER_H

81. FILTER_H: "Answer questions 19a-c if this person is 5 years old or over. Otherwise, SKIP to the questions for Person 2." — Filter — If P_Q4_age >= 5 → GO TO P_Q19a; else → SKIP TO next person (or END)

82. P_Q19a: "Because of a physical, mental, or emotional condition, does this person have serious difficulty concentrating, remembering, or making decisions?" — Yes/No — GO TO P_Q19b

83. P_Q19b: "Does this person have serious difficulty walking or climbing stairs?" — Yes/No — GO TO P_Q19c

84. P_Q19c: "Does this person have difficulty dressing or bathing?" — Yes/No — GO TO FILTER_I

85. FILTER_I: "Answer question 20 if this person is 15 years old or over. Otherwise, SKIP to the questions for Person 2." — Filter — If P_Q4_age >= 15 → GO TO P_Q20; else → SKIP TO next person (or END)

---

### Marriage & Family — 9 questions

86. P_Q20: "Because of a physical, mental, or emotional condition, does this person have difficulty doing errands alone such as visiting a doctor's office or shopping?" — Yes/No — GO TO P_Q21

87. P_Q21: "What is this person's marital status?" — Single select {1: "Now married", 2: "Widowed", 3: "Divorced", 4: "Separated", 5: "Never married"} — 5 → SKIP TO FILTER_J; 1,2,3,4 → GO TO P_Q22a

88. P_Q22a: "In the PAST 12 MONTHS did this person get married?" — Yes/No — GO TO P_Q22b

89. P_Q22b: "In the PAST 12 MONTHS did this person get widowed?" — Yes/No — GO TO P_Q22c

90. P_Q22c: "In the PAST 12 MONTHS did this person get divorced?" — Yes/No — GO TO P_Q23

91. P_Q23: "How many times has this person been married?" — Single select {1: "Once", 2: "Two times", 3: "Three or more times"} — GO TO P_Q24

92. P_Q24: "In what year did this person last get married?" — Numeric (year) — GO TO FILTER_J

93. FILTER_J: "Answer question 25 if this person is female and 15-50 years old. Otherwise, SKIP to question 26a." — Filter — If P_Q3 = 2 (Female) AND P_Q4_age >= 15 AND P_Q4_age <= 50 → GO TO P_Q25; else → SKIP TO P_Q26a

94. P_Q25: "In the PAST 12 MONTHS, has this person given birth to any children?" — Yes/No — GO TO P_Q26a

---

### Grandchildren & Military Service — 3+4 questions

95. P_Q26a: "Does this person have any of his/her own grandchildren under the age of 18 living in this house or apartment?" — Yes/No — No → SKIP TO P_Q27; Yes → GO TO P_Q26b

96. P_Q26b: "Is this grandparent currently responsible for most of the basic needs of any grandchildren under the age of 18 who live in this house or apartment?" — Yes/No — No → SKIP TO P_Q27; Yes → GO TO P_Q26c

97. P_Q26c: "How long has this grandparent been responsible for these grandchildren?" — Single select {1: "Less than 6 months", 2: "6 to 11 months", 3: "1 or 2 years", 4: "3 or 4 years", 5: "5 or more years"} — GO TO P_Q27

---

### Military Service — 4 questions

98. P_Q27: "Has this person ever served on active duty in the U.S. Armed Forces, Reserves, or National Guard?" — Single select {1: "Never served in the military", 2: "Only on active duty for training in the Reserves or National Guard", 3: "Now on active duty", 4: "On active duty in the past, but not now"} — 1 → SKIP TO P_Q30a; 2 → SKIP TO P_Q29a; 3,4 → GO TO P_Q28

99. P_Q28: "When did this person serve on active duty in the U.S. Armed Forces?" — Multi select {1: "September 2001 or later (Post 9/11)", 2: "August 1990 through August 2001 (including the Persian Gulf War)", 3: "June 1975 through July 1990", 4: "August 1964 through May 1975 (including the Vietnam War)", 5: "February 1955 through July 1964", 6: "June 1950 through January 1955 (including the Korean War)", 7: "January 1947 through May 1950", 8: "December 1941 through December 1946 (including World War II)", 9: "November 1941 or earlier"} — GO TO P_Q29a

100. P_Q29a: "Does this person have a VA service-connected disability rating?" — Single select {1: "Yes (such as 0%, 10%, 20%, ... , 100%)", 2: "No"} — 2 → SKIP TO P_Q30a; 1 → GO TO P_Q29b

101. P_Q29b: "What is this person's service-connected disability rating?" — Single select {1: "0 percent", 2: "10 or 20 percent", 3: "30 or 40 percent", 4: "50 or 60 percent", 5: "70 percent or higher"} — GO TO P_Q30a

---

### Employment — 30 items (27 questions + 3 filters)

102. P_Q30a: "LAST WEEK, did this person work for pay at a job (or business)?" — Single select {1: "Yes", 2: "No – Did not work (or retired)"} — 1 → SKIP TO P_Q31a; 2 → GO TO P_Q30b

103. P_Q30b: "LAST WEEK, did this person do ANY work for pay, even for as little as one hour?" — Yes/No — No → SKIP TO P_Q36a; Yes → GO TO P_Q31a

104. P_Q31a: "At what location did this person work LAST WEEK? Address (Number and street name)" — Text (address) — GO TO P_Q31b

105. P_Q31b: "Name of city, town, or post office" — Text — GO TO P_Q31c

106. P_Q31c: "Is the work location inside the limits of that city or town?" — Yes/No — GO TO P_Q31d

107. P_Q31d: "Name of county" — Text — GO TO P_Q31e

108. P_Q31e: "Name of U.S. state or foreign country" — Text — GO TO P_Q31f

109. P_Q31f: "ZIP Code" — Text — GO TO P_Q32

110. P_Q32: "How did this person usually get to work LAST WEEK?" — Single select {1: "Car, truck, or van", 2: "Bus", 3: "Subway or elevated rail", 4: "Long-distance train or commuter rail", 5: "Light rail, streetcar, or trolley", 6: "Ferryboat", 7: "Taxi or ride-hailing services", 8: "Motorcycle", 9: "Bicycle", 10: "Walked", 11: "Worked from home", 12: "Other method"} — 11 → SKIP TO P_Q40a; 1 → GO TO FILTER_K; 2-10,12 → GO TO P_Q34 (SKIP past Q33)

111. FILTER_K: "Answer question 33 if you marked 'Car, truck, or van' in question 32. Otherwise, SKIP to question 34." — Filter — If P_Q32 = 1 → GO TO P_Q33; else → SKIP TO P_Q34

112. P_Q33: "How many people, including this person, usually rode to work in the car, truck, or van LAST WEEK?" — Numeric (1–10) — GO TO P_Q34

113. P_Q34: "LAST WEEK, what time did this person's trip to work usually begin?" — Text (hour:minute, AM/PM) — GO TO P_Q35

114. P_Q35: "How many minutes did it usually take this person to get from home to work LAST WEEK?" — Numeric (minutes) — GO TO FILTER_L

115. FILTER_L: "Answer questions 36-39 if this person did NOT work last week. Otherwise, SKIP to question 40a." — Filter — If P_Q30a = 2 (did not work) → GO TO P_Q36a; else → SKIP TO P_Q40a

116. P_Q36a: "LAST WEEK, was this person on layoff from a job?" — Yes/No — Yes → SKIP TO P_Q36c; No → GO TO P_Q36b

117. P_Q36b: "LAST WEEK, was this person TEMPORARILY absent from a job or business?" — Single select {1: "Yes, on vacation, temporary illness, maternity leave, other family/personal reasons, bad weather, etc.", 2: "No"} — 1 → SKIP TO P_Q39; 2 → SKIP TO P_Q37

118. P_Q36c: "Has this person been informed that he or she will be recalled to work within the next 6 months OR been given a date to return to work?" — Yes/No — Yes → SKIP TO P_Q38; No → GO TO P_Q37

119. P_Q37: "During the LAST 4 WEEKS, has this person been ACTIVELY looking for work?" — Yes/No — No → SKIP TO P_Q39; Yes → GO TO P_Q38

120. P_Q38: "LAST WEEK, could this person have started a job if offered one, or returned to work if recalled?" — Single select {1: "Yes, could have gone to work", 2: "No, because of own temporary illness", 3: "No, because of all other reasons (in school, etc.)"} — GO TO P_Q39

121. P_Q39: "When did this person last work for pay, even for a few days?" — Single select {1: "Within the past 12 months", 2: "1 to 5 years ago", 3: "Over 5 years ago or never worked"} — 1 → GO TO P_Q40a; 2 → SKIP TO FILTER_M; 3 → SKIP TO P_Q43a

122. P_Q40a: "During the PAST 12 MONTHS (52 weeks), did this person work EVERY week?" — Yes/No — Yes → SKIP TO P_Q41; No → GO TO P_Q40b

123. P_Q40b: "During the PAST 12 MONTHS (52 weeks), how many WEEKS did this person work for at least one day?" — Numeric (0–52) — GO TO P_Q41

124. P_Q41: "During the PAST 12 MONTHS, for the weeks worked, how many HOURS did this person usually work each WEEK?" — Numeric (1–99) — GO TO FILTER_M

125. FILTER_M: "Answer questions 42a-f if this person worked in the past 5 years. Otherwise, SKIP to question 43." — Filter — If P_Q39 in {1, 2} OR (P_Q30a = 1 or P_Q30b = 1) → GO TO P_Q42a; else → SKIP TO P_Q43a

126. P_Q42a: "Which one of the following best describes this person's employment last week or the most recent employment in the past 5 years?" — Single select {1: "For-profit company or organization", 2: "Non-profit organization", 3: "Local government", 4: "State government", 5: "Active duty U.S. Armed Forces or Commissioned Corps", 6: "Federal government civilian employee", 7: "Owner of non-incorporated business, professional practice, or farm", 8: "Owner of incorporated business, professional practice, or farm", 9: "Worked without pay in a for-profit family business or farm for 15 hours or more per week"} — GO TO P_Q42b

127. P_Q42b: "What was the name of this person's employer, business, agency, or branch of the Armed Forces?" — Text — GO TO P_Q42c

128. P_Q42c: "What kind of business or industry was this?" — Text (main activity, product, or service) — GO TO P_Q42d

129. P_Q42d: "Was this mainly —" — Single select {1: "manufacturing?", 2: "wholesale trade?", 3: "retail trade?", 4: "other (agriculture, construction, service, government, etc.)?"} — GO TO P_Q42e

130. P_Q42e: "What was this person's main occupation?" — Text (e.g., 4th grade teacher, entry-level plumber) — GO TO P_Q42f

131. P_Q42f: "Describe this person's most important activities or duties." — Text (e.g., instruct and evaluate students) — GO TO P_Q43a

---

### Income — 9 questions

132. P_Q43a: "Wages, salary, commissions, bonuses, or tips from all jobs. Report amount before deductions." — Yes/No + Numeric (dollars, past 12 months) — GO TO P_Q43b

133. P_Q43b: "Self-employment income from own nonfarm businesses or farm businesses, including proprietorships and partnerships. Report NET income after business expenses." — Yes/No + Numeric (dollars, past 12 months) + Loss flag — GO TO P_Q43c

134. P_Q43c: "Interest, dividends, net rental income, royalty income, or income from estates and trusts." — Yes/No + Numeric (dollars, past 12 months) + Loss flag — GO TO P_Q43d

135. P_Q43d: "Social Security or Railroad Retirement." — Yes/No + Numeric (dollars, past 12 months) — GO TO P_Q43e

136. P_Q43e: "Supplemental Security Income (SSI)." — Yes/No + Numeric (dollars, past 12 months) — GO TO P_Q43f

137. P_Q43f: "Any public assistance or welfare payments from the state or local welfare office." — Yes/No + Numeric (dollars, past 12 months) — GO TO P_Q43g

138. P_Q43g: "Retirement income, pensions, survivor or disability income. Include income from a previous employer or union, or any regular withdrawals or distributions from IRA, Roth IRA, 401(k), 403(b)." — Yes/No + Numeric (dollars, past 12 months) — GO TO P_Q43h

139. P_Q43h: "Any other sources of income received regularly such as Veterans' (VA) payments, unemployment compensation, child support or alimony." — Yes/No + Numeric (dollars, past 12 months) — GO TO P_Q44

140. P_Q44: "What was this person's total income during the PAST 12 MONTHS? Add entries in questions 43a to 43h; subtract any losses." — Numeric (dollars) OR "None" + Loss flag — GO TO next person or END
