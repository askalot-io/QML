# ESS Round 12 (2025-2026) — Question Inventory

## Verification Status

| Section | Source Qs | Inventory Qs | Missing | Source GOTOs | Inv. GOTOs | Missing |
|---------|-----------|-------------|---------|-------------|-----------|---------|
| S: Self-completion intro | 6 | 6 | 0 | 7 | 7 | 0 |
| A: Core | 90 | 90 | 0 | 26 | 26 | 0 |
| B: Socio-demographics | 61 | 61 | 0 | 27 | 27 | 0 |
| C: Wellbeing | 30 | 30 | 0 | 0 | 0 | 0 |
| D: Immigration | 33 | 33 | 0 | 3 | 3 | 0 |
| E: Human Values | 20 | 20 | 0 | 0 | 0 | 0 |
| F: Survey Experience | 6 | 6 | 0 | 2 | 2 | 0 |
| G: Recontact | 7 | 7 | 0 | 5 | 5 | 0 |
| H: Closing | 3 | 3 | 0 | 0 | 0 | 0 |
| J: Interviewer | 10 | 10 | 0 | 2 | 2 | 0 |

- **Coverage**: 266 substantive items total, 0 missing
- **Routing**: 72 GOTO directives verified, 0 missing. All 27 key routing chains confirmed (see verification notes below)
- **Status**: READY FOR QML
- **Missing**: None

### Verification Notes (judgement agent, 2026-03-29)

**Question count corrections**: The original header claimed A=92, B=63, D=31 but actual counts are A=90 (A1-A88 + A89a + A89b), B=61 (B1-B60 + HHName; pairs B14a/b, B44a/b, B53a/b, B56a/b each counted as 1 combined entry), D=33 (D1-D29 + D30a-D30d). All inventory line items match the source exactly; only the header summary numbers were incorrect and are now corrected.

**Routing chains verified** (27 chains, all confirmed present in inventory):
- S1→S2/S5, S4→S5/terminate, S5→A1/S6, S6→A1
- A5→A6/A8 (including DK/R→A6), A9→A10/A11
- A26→A27/A28, A36→A37/A39
- A70→A71/A72, A71→A74, A72→A73/A74, A73→A74
- A77→A78/A79, A80→A81/A83, A85→A86/A87, A87→A88/A89
- B8→B9/B10, B16→B17/B18, B18→B19/B21, B19→B20/B37
- B21→B22/B23, B25→B26/B27, B37→B38/B40
- B42filter→B42a/B42b/B42c, B45→B46/B47, B47→B48/B53
- B54→B55/B56, B57→B58/B59
- D19 conditional on A80=1, D22→D23/D24, D30a-D30d sample split (25% each)
- F3→F4/F6, G1→G2/H1, G6→H1/H2/end, J6→J7/J8

**Node type coverage**: Questions (all captured), Filters (ASK IF conditions captured for all conditional items), Constraints (validation texts noted for S5, S6, A8, A10, A82, A86, A88, B1, B2, B4, B6, D18, G3, G5). No missing node types.

**Minor note**: A9 routing in inventory omits explicit DK/R→A11 (source shows R/DK go to A11), but this is implied by the "1,2,3 → GO TO A11" notation covering all non-skip paths. Not a structural gap.

## Document Overview

- **Title**: European Social Survey Round 12 Source Questionnaire
- **Organization**: ESS ERIC (European Research Infrastructure Consortium)
- **Document date**: 06.02.2025
- **Pages**: ~100
- **Language**: English (source questionnaire for translation)
- **Type**: Multi-mode (SC WEB, SC PAPER, F2F interview) — designed for both self-completion and interviewer-administered modes
- **Scope**: Cross-national comparative social survey across ~30 European countries

## Structure

The ESS12 consists of 10 sections:

| Section | Content | Questions | Mode |
|---------|---------|-----------|------|
| S | Self-completion introduction | S1–S6 | SC WEB + PAPER only |
| A | Core: local area, climate, media, trust, politics, attitudes, identity | A1–A89b (90 items) | All modes |
| B | Socio-demographic profile | B1–B60 + HHName (61 items) | All modes |
| C | Rotating module: Wellbeing | C1–C30 | All modes |
| D | Rotating module: Immigration | D1–D30d (33 items) | All modes |
| E | Human Values Scale | E1–E20 | All modes |
| F | Survey experience | F1–F6 | SC WEB + PAPER only |
| G | Recontact | G1–G6 | All modes |
| H | Closing questions | H1–H3 | SC WEB + PAPER only |
| J | Interviewer questionnaire | J1–J10 | F2F only |

**Mode notes**: Most questions have both self-completion and F2F versions. F2F includes unprompted (Refusal) and (Don't Know) options at every question (typically coded 7/77 and 8/88 respectively). These codes are not displayed in self-completion. Questions A85–A88, B42, B53–B58 use "Prefer not to answer" instead of "Refusal."

## Question Inventory by Section

---

### Section S: Self-Completion Introduction — 6 questions

*Filter: ASK ALL SC WEB AND PAPER. S1-S4 asked only if using address-based sample.*

1. S1: "Are you the person aged 15 or over in your household who has the NEXT birthday?" — Yes/No {1: "Yes", 2: "No"} — 1 → GO TO S5; 2 → GO TO S2. SC PAPER: "IF 'NO': Please ask the person aged 15 or over who has the next birthday to complete the survey."

2. S2: "As stated in the letter you received, we need the person with the NEXT birthday to complete the survey. Please pass the invitation letter to the person (aged 15 or over) in your household with the NEXT birthday and ask them to complete the survey instead." — Read — Filter: SC WEB ONLY, IF S1=2. GO TO S3

3. S3: "Welcome to [NAME OF SURVEY]. Thank you for taking part in the survey." — Read — Filter: SC WEB ONLY, IF S1=2. GO TO S4

4. S4: "Are you the person aged 15 or over in your household who has the NEXT birthday?" — Yes/No {1: "Yes", 2: "No"} — Filter: SC WEB ONLY, IF S1=2. 1 → GO TO S5; 2 → survey terminates

5. S5: "Are you…?" — Single select {1: "Aged [18] or over", 2: "Aged under [18]"} — ASK ALL SC WEB AND PAPER. 1 → GO TO A1; 2 → GO TO S6. Validation: if blank, "Please indicate whether you are aged [18] or older."

6. S6: "You are required to obtain permission from a parent/guardian in order to complete this survey. Please complete below." — Single select {1: "I confirm I have permission from a parent/guardian to complete this survey"} — Filter: ASK IF S5=2. 1 → GO TO A1. Validation: if blank, "Please obtain permission from a parent/guardian." Note: S5/S6 only asked if country requires parental consent for under-[18].

---

### Section A: Core Module — 90 questions

**Local area and climate (A1–A7)**

7. A1: "Overall, how satisfied or dissatisfied are you with your local area as a place to live?" — Single select {1: "Very satisfied", 2: "Fairly satisfied", 3: "Neither satisfied nor dissatisfied", 4: "Fairly dissatisfied", 5: "Very dissatisfied"} — ASK ALL

8. A2: "Over the past two years, has the local area where you live got better, worse, or not changed much?" — Single select {1: "Got better", 2: "Got worse", 3: "Not changed much (has not got better or worse)", 4: "I have not lived here long enough to say"}

9. A3: "How much do you feel you belong to your local area?" — Scale (0–6): "Not at all" to "A great deal"

10. A4: "How often do you chat to your neighbours, more than to just say hello?" — Single select {1: "On most days", 2: "Once or twice a week", 3: "Once or twice a month", 4: "Less than once a month", 5: "Never", 6: "I don't have any neighbours"}

11. A5: "Do you think that climate change is caused by natural processes, human activity, or both?" — Single select {1: "Entirely by natural processes", 2: "Mainly by natural processes", 3: "About equally by natural processes and human activity", 4: "Mainly by human activity", 5: "Entirely by human activity", 55: "(I don't think climate change is happening)"} — Codes 1–5 → GO TO A6; Code 55 → GO TO A8; DK/R → GO TO A6

12. A6: "To what extent do you feel a personal responsibility to try to reduce climate change?" — Scale (0–10): "Not at all" to "A great deal" — Filter: ASK IF A5 ≠ 55

13. A7: "How worried are you about climate change?" — Single select {1: "Not at all worried", 2: "Not very worried", 3: "Somewhat worried", 4: "Very worried", 5: "Extremely worried"} — Filter: ASK IF A5 ≠ 55

**Media and internet use (A8–A10)**

14. A8: "On a typical day, about how much time do you spend in hours and minutes watching, reading or listening to news about politics and current affairs?" — Numeric (hours 0–24, minutes 0–59) — ASK ALL. Validation: hours ≤ 24, minutes ≤ 59, if hours=24 then minutes=0

15. A9: "How often do you use the internet on these or any other devices, whether for work or personal use?" — Single select {1: "Never", 2: "Only occasionally", 3: "A few times a week", 4: "Most days", 5: "Every day"} — 4,5 → GO TO A10; 1,2,3 → GO TO A11

16. A10: "On a typical day, about how much time in hours and minutes do you spend using the internet on a computer, tablet, smartphone or other device, whether for work or personal use?" — Numeric (hours 0–24, minutes 0–59) — Filter: ASK IF A9 = 4 or 5. Validation: same as A8

**Social trust (A11–A13)**

17. A11: "Generally speaking, would you say that most people can be trusted, or that you can't be too careful in dealing with people?" — Scale (0–10): "You can't be too careful" to "Most people can be trusted" — ASK ALL

18. A12: "Do you think that most people would try to take advantage of you if they got the chance, or would they try to be fair?" — Scale (0–10): "Most people would try to take advantage of me" to "Most people would try to be fair"

19. A13: "Would you say that most of the time people try to be helpful or that they are mostly looking out for themselves?" — Scale (0–10): "People mostly look out for themselves" to "People mostly try to be helpful"

**Political interest and efficacy (A14–A18)**

20. A14: "How interested would you say you are in politics?" — Single select {1: "Very interested", 2: "Quite interested", 3: "Hardly interested", 4: "Not at all interested"}

21. A15: "How much would you say the political system in [country] allows people like you to have a say in what the government does?" — Single select {1: "Not at all", 2: "Very little", 3: "Some", 4: "A lot", 5: "A great deal"}

22. A16: "How able do you think you are to take an active role in a group involved with political issues?" — Single select {1: "Not at all able", 2: "A little able", 3: "Quite able", 4: "Very able", 5: "Completely able"}

23. A17: "How much would you say the political system in [country] allows people like you to have an influence on politics?" — Single select {1: "Not at all", 2: "Very little", 3: "Some", 4: "A lot", 5: "A great deal"}

24. A18: "How confident are you in your own ability to participate in politics?" — Single select {1: "Not at all confident", 2: "A little confident", 3: "Quite confident", 4: "Very confident", 5: "Completely confident"}

**Institutional trust (A19–A25)**

25. A19: "How much do you personally trust [country]'s parliament?" — Scale (0–10): "No trust at all" to "Complete trust"

26. A20: "How much do you personally trust the legal system?" — Scale (0–10): "No trust at all" to "Complete trust"

27. A21: "How much do you personally trust the police?" — Scale (0–10): "No trust at all" to "Complete trust"

28. A22: "How much do you personally trust politicians?" — Scale (0–10): "No trust at all" to "Complete trust"

29. A23: "How much do you personally trust political parties?" — Scale (0–10): "No trust at all" to "Complete trust"

30. A24: "How much do you personally trust the European Parliament?" — Scale (0–10): "No trust at all" to "Complete trust"

31. A25: "How much do you personally trust the United Nations?" — Scale (0–10): "No trust at all" to "Complete trust"

**Voting and political participation (A26–A35)**

32. A26: "Some people don't vote nowadays for one reason or another. Did you vote in the last [country nationality] national election in [month/year]?" — Single select {1: "Yes", 2: "No", 3: "Not eligible to vote"} — 1 → GO TO A27; 2,3 → GO TO A28

33. A27: "Which party did you vote for in the last [country nationality] national election in [month/year]?" — Single select {1–20: country-specific party options, 21: "Other"} — Filter: ASK IF A26 = 1. Country-specific response list (max 20 parties + Other)

34. A28: "During the last 12 months, have you contacted a politician, government or local government official?" — Yes/No {1: "Yes", 2: "No"} — ASK ALL

35. A29: "During the last 12 months, have you donated to or participated in a political party or pressure group?" — Yes/No {1: "Yes", 2: "No"}

36. A30: "During the last 12 months, have you worn or displayed a campaign badge/sticker?" — Yes/No {1: "Yes", 2: "No"}

37. A31: "During the last 12 months, have you signed a petition?" — Yes/No {1: "Yes", 2: "No"}

38. A32: "During the last 12 months, have you taken part in a public demonstration?" — Yes/No {1: "Yes", 2: "No"}

39. A33: "During the last 12 months, have you boycotted certain products?" — Yes/No {1: "Yes", 2: "No"}

40. A34: "During the last 12 months, have you posted or shared anything about politics online, for example on blogs, via email or on social media such as Facebook, Instagram, TikTok, or X (formerly known as Twitter)?" — Yes/No {1: "Yes", 2: "No"}

41. A35: "During the last 12 months, have you volunteered for a not-for-profit or charitable organisation?" — Yes/No {1: "Yes", 2: "No"}

**Party allegiance (A36–A38)**

42. A36: "Is there a particular political party you feel closer to than all the other parties?" — Single select {1: "Yes", 2: "No"} — 1 → GO TO A37; 2 → GO TO A39

43. A37: "Which political party do you feel closest to?" — Single select {1–20: country-specific party options, 21: "Other"} — Filter: ASK IF A36 = 1. Country-specific response list

44. A38: "How close do you feel to this party?" — Single select {1: "Very close", 2: "Quite close", 3: "Not close", 4: "Not at all close"} — Filter: ASK IF A36 = 1

**Left-right placement (A39)**

45. A39: "In politics people sometimes talk of 'left' and 'right'. Where would you place yourself on this scale, where 0 means the left and 10 means the right?" — Scale (0–10): "Left" to "Right" — ASK ALL

**Satisfaction (A40–A43)**

46. A40: "All things considered, how satisfied are you with your life as a whole nowadays?" — Scale (0–10): "Extremely dissatisfied" to "Extremely satisfied"

47. A41: "On the whole, how satisfied are you with the present state of the economy in [country]?" — Scale (0–10): "Extremely dissatisfied" to "Extremely satisfied"

48. A42: "Now thinking about the [country nationality] government, how satisfied are you with the way it is doing its job?" — Scale (0–10): "Extremely dissatisfied" to "Extremely satisfied"

49. A43: "And on the whole, how satisfied are you with the way democracy works in [country]?" — Scale (0–10): "Extremely dissatisfied" to "Extremely satisfied"

**State of services (A44–A45)**

50. A44: "What do you think overall about the state of education in [country] nowadays?" — Scale (0–10): "Extremely bad" to "Extremely good"

51. A45: "What do you think overall about the state of health services in [country] nowadays?" — Scale (0–10): "Extremely bad" to "Extremely good"

**Socio-political attitudes (A46–A52)**

52. A46: "The government should take measures to reduce differences in income levels." — Single select {1: "Agree strongly", 2: "Agree", 3: "Neither agree nor disagree", 4: "Disagree", 5: "Disagree strongly"}

53. A47: "Gay men and lesbians should be free to live their own life as they wish." — Single select {1: "Agree strongly", 2: "Agree", 3: "Neither agree nor disagree", 4: "Disagree", 5: "Disagree strongly"}

54. A48: "If a close family member was a gay man or a lesbian, I would feel ashamed." — Single select {1: "Agree strongly", 2: "Agree", 3: "Neither agree nor disagree", 4: "Disagree", 5: "Disagree strongly"}

55. A49: "Gay male and lesbian couples should have the same rights to adopt children as straight couples." — Single select {1: "Agree strongly", 2: "Agree", 3: "Neither agree nor disagree", 4: "Disagree", 5: "Disagree strongly"}

56. A50: "Now thinking about the European Union, some say European unification should go further. Others say it has already gone too far. Which number on this scale best describes your position?" — Scale (0–10): "Unification has already gone too far" to "Unification should go further"

57. A51: "Obedience and respect for authority are the most important values children should learn." — Single select {1: "Agree strongly", 2: "Agree", 3: "Neither agree nor disagree", 4: "Disagree", 5: "Disagree strongly"}

58. A52: "What [country] needs most is loyalty towards its leaders." — Single select {1: "Agree strongly", 2: "Agree", 3: "Neither agree nor disagree", 4: "Disagree", 5: "Disagree strongly"}

**Immigration attitudes (A53–A59)**

59. A53: "To what extent do you think [country] should allow people of the same race or ethnic group as most [country nationality] people to come and live here?" — Single select {1: "Allow many to come and live here", 2: "Allow some", 3: "Allow a few", 4: "Allow none"}

60. A54: "To what extent do you think [country] should allow people of a different race or ethnic group from most [country nationality] people to come and live here?" — Single select {1: "Allow many to come and live here", 2: "Allow some", 3: "Allow a few", 4: "Allow none"}

61. A55: "To what extent do you think [country] should allow people from poorer countries outside Europe to come and live here?" — Single select {1: "Allow many to come and live here", 2: "Allow some", 3: "Allow a few", 4: "Allow none"}

62. A56: "To what extent do you think [country] should allow people who are forced to leave their country because of armed conflict or persecution to come and live here?" — Single select {1: "Allow many to come and live here", 2: "Allow some", 3: "Allow a few", 4: "Allow none"}

63. A57: "Would you say it is generally bad or good for [country]'s economy that people come to live here from other countries?" — Scale (0–10): "Bad for the economy" to "Good for the economy"

64. A58: "Would you say that [country]'s cultural life is generally undermined or enriched by people coming to live here from other countries?" — Scale (0–10): "Cultural life undermined" to "Cultural life enriched"

65. A59: "Is [country] made a worse or a better place to live by people coming to live here from other countries?" — Scale (0–10): "Worse place to live" to "Better place to live"

**Subjective wellbeing and social life (A60–A63)**

66. A60: "Taking all things together, how happy would you say you are?" — Scale (0–10): "Extremely unhappy" to "Extremely happy"

67. A61: "How often do you meet socially with friends, relatives or work colleagues?" — Single select {1: "Never", 2: "Less than once a month", 3: "Once a month", 4: "Several times a month", 5: "Once a week", 6: "Several times a week", 7: "Every day"}

68. A62: "How many people, if any, are there with whom you can discuss intimate and personal matters?" — Single select {0: "None", 1: "1", 2: "2", 3: "3", 4: "4-6", 5: "7-9", 6: "10 or more"}

69. A63: "Compared to other people of your age, how often would you say you take part in social activities?" — Single select {1: "Much less than most", 2: "Less than most", 3: "About the same", 4: "More than most", 5: "Much more than most"}

**Crime and health (A64–A67)**

70. A64: "Have you or a member of your household been the victim of a burglary or assault in the last 5 years?" — Yes/No {1: "Yes", 2: "No"}

71. A65: "How safe do you – or would you – feel walking alone in the area you live after dark?" — Single select {1: "Very safe", 2: "Safe", 3: "Unsafe", 4: "Very unsafe"}

72. A66: "How is your health in general?" — Single select {1: "Very good", 2: "Good", 3: "Fair", 4: "Bad", 5: "Very bad"}

73. A67: "Are you hampered in your daily activities in any way by any longstanding illness, or disability, infirmity or mental health problem?" — Single select {1: "Yes a lot", 2: "Yes to some extent", 3: "No"}

**National and European attachment (A68–A69)**

74. A68: "How emotionally attached do you feel to [country]?" — Scale (0–10): "Not at all emotionally attached" to "Very emotionally attached"

75. A69: "And how emotionally attached do you feel to Europe?" — Scale (0–10): "Not at all emotionally attached" to "Very emotionally attached"

**Religion (A70–A76)**

76. A70: "Do you consider yourself as belonging to any particular religion or denomination?" — Yes/No {1: "Yes", 2: "No"} — 1 → GO TO A71; 2 → GO TO A72

77. A71: "Which religion or denomination do you belong to?" — Single select {1–15: country-specific religion options, 16: "Other"} — Filter: ASK IF A70 = 1. All responses → GO TO A74

78. A72: "Have you ever considered yourself as belonging to any particular religion or denomination?" — Yes/No {1: "Yes", 2: "No"} — Filter: ASK IF A70 ≠ 1. 1 → GO TO A73; 2 → GO TO A74

79. A73: "Which religion or denomination did you belong to in the past?" — Single select {1–15: country-specific religion options, 16: "Other"} — Filter: ASK IF A72 = 1. GO TO A74

80. A74: "Regardless of whether you belong to a particular religion, how religious would you say you are?" — Scale (0–10): "Not at all religious" to "Very religious" — ASK ALL

81. A75: "Apart from special occasions such as weddings and funerals, about how often do you attend religious services nowadays?" — Single select {1: "Every day", 2: "More than once a week", 3: "Once a week", 4: "At least once a month", 5: "Only on special holy days", 6: "Less often", 7: "Never"}

82. A76: "Apart from when you are at religious services, how often, if at all, do you pray?" — Single select {1: "Every day", 2: "More than once a week", 3: "Once a week", 4: "At least once a month", 5: "Only on special holy days", 6: "Less often", 7: "Never"}

**Discrimination (A77–A78)**

83. A77: "Would you describe yourself as being a member of a group that is discriminated against in this country?" — Yes/No {1: "Yes", 2: "No"} — 1 → GO TO A78; 2 → GO TO A79

84. A78: "On what grounds is your group discriminated against?" — Multi select {1: "Colour or race", 2: "Nationality", 3: "Religion", 4: "Language", 5: "Ethnic group", 6: "Age", 7: "Gender", 8: "Sexuality", 9: "Disability", 10: "Other"} — Filter: ASK IF A77 = 1. CODE ALL THAT APPLY

**Citizenship and immigration background (A79–A84)**

85. A79: "Are you a citizen of [country]?" — Yes/No {1: "Yes", 2: "No"} — ASK ALL

86. A80: "Were you born in [country]?" — Yes/No {1: "Yes", 2: "No"} — 1 → GO TO A83; 2 → GO TO A81

87. A81: "In which country were you born?" — Text — Filter: ASK IF A80 = 2. Coded to ISO 3166-1

88. A82: "What year did you first come to live in [country]?" — Numeric (year, 1900–current) — Filter: ASK IF A80 = 2

89. A83: "What language or languages do you speak most often at home?" — Text (up to 2 languages) — ASK ALL. Coded to ISO 639-2

90. A84: "Do you feel you are part of the same race or ethnic group as most people in [country]?" — Yes/No {1: "Yes", 2: "No"} — ASK ALL

**Parents' birthplace (A85–A88)**

91. A85: "Was your father born in [country]?" — Yes/No {1: "Yes", 2: "No", 7: "Prefer not to answer"} — 1,7 → GO TO A87; 2 → GO TO A86

92. A86: "In which country was your father born?" — Text — Filter: ASK IF A85 = 2. Coded to ISO 3166-1

93. A87: "Was your mother born in [country]?" — Yes/No {1: "Yes", 2: "No", 7: "Prefer not to answer"} — ASK ALL. 1,7 → GO TO A89; 2 → GO TO A88

94. A88: "In which country was your mother born?" — Text — Filter: ASK IF A87 = 2. Coded to ISO 3166-1

**EU referendum (A89a–A89b)**

95. A89a: "Imagine there were a referendum in [country] tomorrow about membership of the European Union. Would you vote for [country] to remain a member of the European Union or to leave the European Union?" — Single select {1: "Remain a member of the European Union", 2: "Leave the European Union", 33: "(Would submit a blank ballot paper)", 44: "(Would spoil the ballot paper)", 55: "(Would not vote)", 65: "(Not eligible to vote)"} — Filter: ASK IF [country] is EU member

96. A89b: "Imagine there were a referendum in [country] tomorrow about membership of the European Union. Would you vote for [country] to become a member of the European Union or to remain outside the European Union?" — Single select {1: "Become a member of the European Union", 2: "Remain outside the European Union", 33: "(Would submit a blank ballot paper)", 44: "(Would spoil the ballot paper)", 55: "(Would not vote)", 65: "(Not eligible to vote)"} — Filter: ASK IF [country] is NOT EU member

**Section A routing notes**: Only A89a or A89b is asked per country (never both).

---

### Section B: Socio-Demographic Profile — 61 questions

**Household composition (B1–B7)**

97. B1: "Including yourself and any children, how many people live here regularly as members of your household?" — Numeric (1–99) — ASK ALL

98. B2: "And how many of the people in your household are aged 15 or older, including yourself?" — Numeric (1–99) — ASK ALL. Validation: B2 ≤ B1, B2 ≥ 1

99. B3: "What is your sex?" — Single select {1: "Male", 2: "Female"} — ASK ALL

100. B4: "In which month and year were you born?" — Date (month + year) — ASK ALL

101. HHName: "Person XX — First name or initial (optional)" — Text — Filter: ASK IF B1 > 1. Roster: repeat for each additional household member (max 8)

102. B5: "What is {Person XX/name}'s sex?" — Single select {1: "Male", 2: "Female"} — Filter: ASK IF B1 > 1. Roster: repeat for each additional household member (max 8)

103. B6: "In which month and year was {Person XX/name} born?" — Date (month + year) — Filter: ASK IF B1 > 1. Roster per household member

104. B7: "What is {Person XX/name}'s relationship to you? This person is your..." — Single select {1: "Husband/wife/partner", 2: "Son/daughter (including step/adopted/foster/partner's child)", 3: "Parent/parent-in-law/partner's parent/step parent", 4: "Brother/sister (including step/adopted/foster)", 5: "Other relative", 6: "Other non-relative"} — Filter: ASK IF B1 > 1. Roster per household member

**Marital status (B8–B12)**

105. B8: "Which one of the descriptions from the following list describes your relationship to your husband, wife, or partner?" — Single select {1: "Legally married", 2: "In a legally registered civil union", 3: "Living with partner (cohabiting) – not legally recognised", 4: "Living with partner (cohabiting) – legally recognised", 5: "Legally separated", 6: "Legally divorced or civil union dissolved"} — Filter: ASK IF B7=1 for any household member (living with partner). 1,2 → GO TO B9; 3,4 → GO TO B10; 5,6 → GO TO B9

106. B9: "Have you ever lived with a partner without being married to them or in a civil union?" — Yes/No {1: "Yes", 2: "No"} — Filter: ASK IF NOT living with partner (no B7=1), or B8=1,2,5,6

107. B10: "Have you ever been divorced or had a civil union dissolved?" — Yes/No {1: "Yes", 2: "No"} — ASK ALL

108. B11: "Which one of the descriptions from the following list describes your legal marital status now?" — Single select {1: "Legally married", 2: "In a legally registered civil union", 3: "Legally separated", 4: "Legally divorced or civil union dissolved", 5: "Widowed or civil partner died", 6: "None of these (NEVER married or in legally registered civil union)"} — Filter: ASK IF NOT living with partner, or B8=3,4

109. B12: "Have you ever had any children of your own, step-children, adopted children, foster children or a partner's children living in your household?" — Yes/No {1: "Yes", 2: "No"} — Filter: ASK IF no B7=2 for any household member (no children in household)

**Area and education (B13–B15)**

110. B13: "Which of the following phrases best describes the area where you live?" — Single select {1: "A big city", 2: "The suburbs or outskirts of a big city", 3: "A town or a small city", 4: "A country village", 5: "A farm or home in the countryside"} — ASK ALL

111. B14a/B14b: "[Country-specific text for respondent's highest education question]" — Single select {1–25: country-specific ISCED categories} — ASK ALL. One or two questions depending on country. Up to 25 options + "Other"

112. B15: "About how many years of education have you completed, whether full-time or part-time?" — Numeric (0–99) — ASK ALL. Report in full-time equivalents

**Activity status and employment (B16–B36)**

113. B16: "Which of the following descriptions applies to what you have been doing for the last 7 days?" — Multi select {1: "In paid work", 2: "In education", 3: "Unemployed actively looking", 4: "Unemployed wanting job but not looking", 5: "Permanently sick or disabled", 6: "Retired", 7: "In community or military service", 8: "Doing housework/looking after children or others", 9: "Other"} — ASK ALL. If more than one coded → GO TO B17; if only one coded → GO TO B18

114. B17: "And which of these descriptions best describes your situation in the last 7 days?" — Single select (filtered to options selected at B16) — Filter: ASK IF more than one coded at B16

115. B18: "Just to check, did you do any paid work of an hour or more in the last 7 days?" — Yes/No {1: "Yes", 2: "No"} — Filter: ASK IF B16 ≠ 1 (not in paid work). 1 → GO TO B21; 2 → GO TO B19

116. B19: "Have you ever had a paid job?" — Yes/No {1: "Yes", 2: "No"} — Filter: ASK IF B18 = 2. 1 → GO TO B20; 2 → GO TO B37

117. B20: "In what year were you last in a paid job?" — Numeric (year) — Filter: ASK IF B19 = 1

118. B21: "In your main job, are/were you..." — Single select {1: "An employee", 2: "Self-employed", 3: "Working for your own family's business"} — Filter: ASK IF B16=1, B18=1, or B19=1. 2 → GO TO B22; 1,3 → GO TO B23

119. B22: "How many employees do/did you have?" — Numeric (0–99999) — Filter: ASK IF B21 = 2

120. B23: "Do/did you have a work contract of..." — Single select {1: "Unlimited duration", 2: "Limited duration", 3: "No contract at all"} — Filter: ASK IF B16=1, B18=1, or B19=1

121. B24: "Including yourself, about how many people are/were employed at the place where you usually work/worked?" — Single select {1: "Under 10", 2: "10 to 24", 3: "25 to 99", 4: "100 to 499", 5: "500 or more"} — Filter: ASK IF B16=1, B18=1, or B19=1

122. B25: "In your main job, do/did you have any responsibility for supervising the work of other employees?" — Yes/No {1: "Yes", 2: "No"} — Filter: ASK IF B16=1, B18=1, or B19=1. 1 → GO TO B26; 2 → GO TO B27

123. B26: "How many people are/were you responsible for?" — Numeric (0–99999) — Filter: ASK IF B25 = 1

124. B27: "How much does/did the management at your work allow you to decide how your own daily work is/was organised?" — Scale (0–10): "I have/had no influence" to "I have/had complete control" — Filter: ASK IF B16=1, B18=1, or B19=1

125. B28: "How much does/did the management at your work allow you to influence policy decisions about the activities of the organisation?" — Scale (0–10): "I have/had no influence" to "I have/had complete control" — Filter: ASK IF B16=1, B18=1, or B19=1

126. B29: "What are/were your total 'basic' or contracted hours each week in your main job?" — Numeric (0–168, or 555="No set hours") — Filter: ASK IF B16=1, B18=1, or B19=1

127. B30: "Regardless of your basic or contracted hours, how many hours do/did you normally work a week in your main job, including any paid or unpaid overtime?" — Numeric (0–168) — Filter: ASK IF B16=1, B18=1, or B19=1

128. B31: "What does/did the firm or organisation you work/worked for mainly make or do?" — Text — Filter: ASK IF B16=1, B18=1, or B19=1

129. B32: "Which of the following types of organisation do/did you work for?" — Single select {1: "Central or local government", 2: "Other public sector (such as education and health)", 3: "A state-owned enterprise", 4: "A private firm", 5: "Self-employed", 6: "Other"} — Filter: ASK IF B16=1, B18=1, or B19=1

130. B33: "What is/was your main job?" — Text — Filter: ASK IF B16=1, B18=1, or B19=1

131. B34: "What do/did you mainly do in this job?" — Text — Filter: ASK IF B16=1, B18=1, or B19=1

132. B35: "What training or qualifications are/were needed for this job?" — Text — Filter: ASK IF B16=1, B18=1, or B19=1

133. B36: "In the last 10 years have you done any paid work in another country for a period of 6 months or more?" — Yes/No {1: "Yes", 2: "No"} — Filter: ASK IF B16=1, B18=1, or B19=1

**Unemployment (B37–B39)**

134. B37: "Have you ever been unemployed and seeking work for a period of more than 3 months?" — Yes/No {1: "Yes", 2: "No"} — ASK ALL. 1 → GO TO B38; 2 → GO TO B40

135. B38: "Have any of these periods of unemployment lasted for 12 months or more?" — Yes/No {1: "Yes", 2: "No"} — Filter: ASK IF B37 = 1

136. B39: "Have any of these periods of unemployment, that lasted more than 3 months, been within the past 5 years?" — Yes/No {1: "Yes", 2: "No"} — Filter: ASK IF B37 = 1

**Union and income (B40–B43)**

137. B40: "Are you or have you ever been a member of a trade union or similar organisation?" — Single select {1: "Yes, currently", 2: "Yes, previously", 3: "No"} — ASK ALL

138. B41: "Please consider the income of all household members and any income which may be received by the household as a whole. What is the main source of income in your household?" — Single select {1: "Wages or salaries", 2: "Income from self-employment (excluding farming)", 3: "Income from farming", 4: "Pensions", 5: "Unemployment/redundancy benefit", 6: "Any other social benefits or grants", 7: "Income from investment/savings/insurance/property", 8: "Income from other sources"} — ASK ALL

139. B42: "Using this card, please tell me which letter describes your household's total income, after tax and compulsory deductions, from all sources?" — Single select {1–10: country-specific income deciles} — ASK ALL. SC WEB has filter (B42filter) for weekly/monthly/annual preference, then B42a/B42b/B42c accordingly. F2F and SC PAPER use a single card with letter codes. "Prefer not to answer" option available.

140. B43: "Which of the following descriptions comes closest to how you feel about your household's income nowadays?" — Single select {1: "Living comfortably on present income", 2: "Coping on present income", 3: "Finding it difficult on present income", 4: "Finding it very difficult on present income"} — ASK ALL

**Partner details (B44–B52)**

141. B44a/B44b: "[Country-specific text for partner's highest education question]" — Single select {1–25: country-specific ISCED categories} — Filter: ASK IF B7=1 for any household member (living with partner)

142. B45: "Which of the following descriptions applies to what your husband, wife, or partner has been doing for the last 7 days?" — Multi select {1: "In paid work", 2: "In education", 3: "Unemployed actively looking", 4: "Unemployed wanting job but not looking", 5: "Permanently sick or disabled", 6: "Retired", 7: "In community or military service", 8: "Doing housework/looking after children or others", 9: "Other"} — Filter: ASK IF B7=1. If more than one → GO TO B46; if one → GO TO B47

143. B46: "And which of these descriptions best describes your husband, wife, or partner's situation in the last 7 days?" — Single select (filtered) — Filter: ASK IF more than one coded at B45

144. B47: "Just to check, did your husband, wife, or partner do any paid work of an hour or more in the last 7 days?" — Yes/No {1: "Yes", 2: "No"} — Filter: ASK IF B45 ≠ 1. 1 → GO TO B48; 2 → GO TO B53

145. B48: "What is your husband, wife, or partner's main job?" — Text — Filter: ASK IF B45=1 or B47=1

146. B49: "What does your husband, wife, or partner mainly do in their job?" — Text — Filter: ASK IF B45=1 or B47=1

147. B50: "What training or qualifications are needed for your husband, wife, or partner's job?" — Text — Filter: ASK IF B45=1 or B47=1

148. B51: "In your husband, wife, or partner's main job are they..." — Single select {1: "An employee", 2: "Self-employed", 3: "Working for your own family's business"} — Filter: ASK IF B45=1 or B47=1

149. B52: "How many hours does your husband, wife, or partner normally work a week in their main job?" — Numeric (0–168) — Filter: ASK IF B45=1 or B47=1

**Parents' background (B53–B58)**

150. B53a/B53b: "[Country-specific text for father's highest education question]" — Single select {1–25: country-specific ISCED categories, 77: "Prefer not to answer"} — ASK ALL

151. B54: "When you were 14, did your father work as an employee, was he self-employed, or was he not working then?" — Single select {1: "Employee", 2: "Self-employed", 3: "Not working", 4: "Father deceased or absent when I was 14", 7: "Prefer not to answer"} — ASK ALL. 1,2 → GO TO B55; 3,4 → GO TO B56

152. B55: "Which one of the descriptions from the following list best describes the sort of work your father did when you were 14?" — Single select {1: "Professional and technical", 2: "Higher administrator", 3: "Clerical", 4: "Sales", 5: "Service", 6: "Skilled worker", 7: "Semi-skilled worker", 8: "Unskilled worker", 9: "Farm worker", 77: "Prefer not to answer"} — Filter: ASK IF B54 = 1 or 2

153. B56a/B56b: "[Country-specific text for mother's highest education question]" — Single select {1–25: country-specific ISCED categories, 77: "Prefer not to answer"} — ASK ALL

154. B57: "When you were 14, did your mother work as an employee, was she self-employed, or was she not working then?" — Single select {1: "Employee", 2: "Self-employed", 3: "Not working", 4: "Mother deceased or absent when I was 14", 7: "Prefer not to answer"} — ASK ALL. 1,2 → GO TO B58; 3,4 → GO TO B59

155. B58: "Which one of the descriptions from the following list best describes the sort of work your mother did when you were 14?" — Single select {1–9: same as B55, 77: "Prefer not to answer"} — Filter: ASK IF B57 = 1 or 2

**Training and ancestry (B59–B60)**

156. B59: "During the last twelve months, have you taken any course or attended any lecture or conference to improve your knowledge or skills for work?" — Yes/No {1: "Yes", 2: "No"} — ASK ALL

157. B60: "How would you describe your ancestry?" — Multi select (max 2) {1–20: country-specific ancestry categories, 21: "Other"} — ASK ALL. Two drop-down menus (Ancestry 1, Ancestry 2)

---

### Section C: Rotating Module — Wellbeing — 30 questions

*ASK ALL*

**Optimism (C1)**

158. C1: "To what extent do you agree or disagree with the following statement? I'm always optimistic about my future." — Single select {1: "Agree strongly", 2: "Agree", 3: "Neither agree nor disagree", 4: "Disagree", 5: "Disagree strongly"}

**Past-week feelings (C2–C11)**

159. C2: "How much of the time during the past week did you feel depressed?" — Single select {1: "None or almost none of the time", 2: "Some of the time", 3: "Most of the time", 4: "All or almost all of the time"}

160. C3: "How much of the time during the past week was your sleep restless?" — Single select {1–4: same as C2}

161. C4: "How much of the time during the past week were you happy?" — Single select {1–4: same as C2}

162. C5: "How much of the time during the past week did you feel lonely?" — Single select {1–4: same as C2}

163. C6: "How much of the time during the past week did you enjoy life?" — Single select {1–4: same as C2}

164. C7: "How much of the time during the past week did you feel sad?" — Single select {1–4: same as C2}

165. C8: "How much of the time during the past week could you not get going?" — Single select {1–4: same as C2}

166. C9: "How much of the time during the past week did you have a lot of energy?" — Single select {1–4: same as C2}

167. C10: "How much of the time during the past week did you feel anxious?" — Single select {1–4: same as C2}

168. C11: "How much of the time during the past week did you feel calm and peaceful?" — Single select {1–4: same as C2}

**Competence and worth (C12–C13)**

169. C12: "In my daily life I get very little chance to show how capable I am." — Single select {1: "Agree strongly", 2: "Agree", 3: "Neither agree nor disagree", 4: "Disagree", 5: "Disagree strongly"}

170. C13: "I generally feel that what I do in my life is valuable and worthwhile." — Single select {1–5: same as C12}

**Social harmony and respect (C14–C16)**

171. C14: "In your opinion, to what extent is there harmony among the people who live in [country]?" — Scale (0–6): "Not at all" to "A great deal"

172. C15: "To what extent do you feel that people in your local area help one another?" — Scale (0–6): "Not at all" to "A great deal"

173. C16: "To what extent do you feel that people treat you with respect?" — Scale (0–6): "Not at all" to "A great deal"

**Awareness, purpose, support (C17–C23)**

174. C17: "On a typical day, how often do you take notice of and appreciate your surroundings?" — Scale (0–10): "Never" to "Always"

175. C18: "To what extent do you feel that you have a sense of direction in your life?" — Scale (0–10): "Not at all" to "Completely"

176. C19: "To what extent do you receive help and support from people you are close to when you need it?" — Scale (0–6): "Not at all" to "Completely"

177. C20: "And to what extent do you provide help and support to people you are close to when they need it?" — Scale (0–6): "Not at all" to "Completely"

178. C21: "To what extent are you doing the things you really want and value in your life?" — Scale (0–6): "Not at all" to "Completely"

179. C22: "To what extent are you able to achieve your goals?" — Scale (0–6): "Not at all" to "Completely"

180. C23: "To what extent do you feel safe and secure in your life nowadays?" — Scale (0–6): "Not at all" to "Completely"

**Connectedness (C24–C25)**

181. C24: "Generally speaking, how close and connected do you feel to other people?" — Scale (0–6): "Not at all" to "Extremely"

182. C25: "How close and connected do you feel to the people in your local area?" — Scale (0–6): "Not at all" to "Extremely"

**Resilience and compassion (C26–C30)**

183. C26: "To what extent do you agree or disagree with the following statement? In difficult periods of my life, I can usually find something good that helps me change for the better." — Single select {1–5: agree/disagree scale}

184. C27: "When you hear about an acquaintance going through a difficult time, how much compassion do you usually feel for them?" — Scale (0–6): "None at all" to "A great deal"

185. C28: "When you are going through a difficult time, to what extent do you give yourself the care and kindness you need?" — Scale (0–6): "Not at all" to "A great deal"

186. C29: "To what extent do you feel there is harmony in your life, that is, you feel balanced and at peace with yourself?" — Scale (0–6): "Not at all" to "A great deal"

187. C30: "In difficult situations, how often do you manage to take a pause without immediately reacting?" — Scale (0–6): "Never" to "Always"

---

### Section D: Rotating Module — Immigration — 33 questions

**Global solidarity (D1–D4)**

188. D1: "How important do you think it is that people in countries which are better off should help those in poorer countries who are unable to provide for their basic needs?" — Single select {1: "Very important", 2: "Important", 3: "Not very important", 4: "Not at all important"} — ASK ALL

189. D2: "How acceptable do you think it is that people ONLY help those who genuinely deserve assistance?" — Single select {1: "Very acceptable", 2: "Acceptable", 3: "Not very acceptable", 4: "Not at all acceptable"}

190. D3: "Would you say that the world would be a better or a worse place if people from other countries were more like the [country nationality] people?" — Single select {1: "World would be a much better place", 2: "World would be a better place", 3: "Would not make it a better or worse place", 4: "World would be a worse place", 5: "World would be a much worse place"}

191. D4: "How often should [country] be ruthless in asserting its national interests against other countries?" — Single select {1: "Always", 2: "Often", 3: "Sometimes", 4: "Hardly ever", 5: "Never"}

**Immigration criteria (D5–D8)**

192. D5: "How important should it be for them to have good educational qualifications?" — Scale (0–10): "Extremely unimportant" to "Extremely important"

193. D6: "How important should it be for them to be able to speak [country's official language(s)]?" — Scale (0–10): "Extremely unimportant" to "Extremely important"

194. D7: "How important should it be for them to come from a Christian background?" — Scale (0–10): "Extremely unimportant" to "Extremely important"

195. D8: "How important should it be for them to be white?" — Scale (0–10): "Extremely unimportant" to "Extremely important"

**Immigration impact (D9–D11)**

196. D9: "Would you say that people who come to live here generally take jobs away from workers in [country], or generally help to create new jobs?" — Scale (0–10): "Take jobs away" to "Create new jobs"

197. D10: "Most people who come to live here work and pay taxes. They also use health and welfare services. On balance, do you think people who come here take out more than they put in or put in more than they take out?" — Scale (0–10): "Generally take out more" to "Generally put in more"

198. D11: "Are [country]'s crime problems made worse or better by people coming to live here from other countries?" — Scale (0–10): "Crime problems made worse" to "Crime problems made better"

**Social distance (D12–D13)**

199. D12: "How much would you mind or not mind if someone like this was appointed as your boss?" — Scale (0–10): "Not mind at all" to "Mind a lot"

200. D13: "How much would you mind or not mind if someone like this married a close relative of yours?" — Scale (0–10): "Not mind at all" to "Mind a lot"

**Refugees (D14–D18)**

201. D14: "[Country] has more than its fair share of people applying for refugee status." — Single select {1: "Agree strongly", 2: "Agree", 3: "Neither agree nor disagree", 4: "Disagree", 5: "Disagree strongly"}

202. D15: "While their applications for refugee status are being considered, people should be allowed to work in [country]." — Single select {1–5: agree/disagree scale}

203. D16: "The government should be generous in judging people's applications for refugee status." — Single select {1–5: agree/disagree scale}

204. D17: "While their cases are being considered, applicants should be kept in detention centres." — Single select {1–5: agree/disagree scale}

205. D18: "Out of every 100 people living in [country], how many do you think were born outside [country]?" — Numeric (0–100) — ASK ALL

**Treatment and contact (D19–D23)**

206. D19: "Compared to people like yourself who were born in [country], how do you think the government treats those who have recently come to live here from other countries?" — Single select {1: "Much better", 2: "A little better", 3: "The same", 4: "A little worse", 5: "Much worse"} — Filter: ASK IF A80 = 1 (born in country)

207. D20: "Do you think the religious beliefs and practices in [country] are generally undermined or enriched by people coming to live here from other countries?" — Scale (0–10): "Religious beliefs and practices undermined" to "Religious beliefs and practices enriched" — ASK ALL

208. D21: "Do you have any close friends who are of a different race or ethnic group from most [country nationality] people?" — Single select {1: "Yes, several", 2: "Yes, a few", 3: "No, none at all"}

209. D22: "How often do you have any contact with people who are of a different race or ethnic group from most [country nationality] people when you are out and about?" — Single select {1: "Never", 2: "Less than once a month", 3: "Once a month", 4: "Several times a month", 5: "Once a week", 6: "Several times a week", 7: "Every day"} — 1 → GO TO D24; 2–7 → GO TO D23

210. D23: "Thinking about this contact, in general how bad or good is it?" — Scale (0–10): "Extremely bad" to "Extremely good" — Filter: ASK IF D22 ≠ 1 (not Never)

**Race, ethnicity, culture (D24–D27)**

211. D24: "Do you think some races or ethnic groups are born less intelligent than others?" — Single select {1: "Yes, definitely", 2: "Yes, probably", 3: "No, probably not", 4: "No, definitely not"} — ASK ALL

212. D25: "Do you think some races or ethnic groups are born harder working than others?" — Single select {1–4: same as D24}

213. D26: "Thinking about the world today, would you say that some cultures are much better than others?" — Single select {1–4: same as D24}

214. D27: "Do you think that we should protect [country nationality] culture from the influence of other cultures?" — Single select {1–4: same as D24}

**Group-specific attitudes — split-sample (D28–D30d)**

215. D28: "To what extent do you think [country] should allow Jewish people from other countries to come and live here?" — Single select {1: "Allow many to come and live here", 2: "Allow some", 3: "Allow a few", 4: "Allow none"} — ASK ALL

216. D29: "To what extent do you think [country] should allow Muslims from other countries to come and live here?" — Single select {1–4: same as D28} — ASK ALL

217. D30a: "Imagine a situation where Christians from a European country outside the EU have to leave their country because war makes their homes unsafe. To what extent do you think [country] should allow them to come and live here?" — Single select {1–4: same as D28} — Filter: ASK SAMPLE A (random 25%)

218. D30b: "Imagine a situation where Christians from a European country outside the EU have to leave their country because they are unemployed due to a lack of work. To what extent do you think [country] should allow them to come and live here?" — Single select {1–4: same as D28} — Filter: ASK SAMPLE B (random 25%)

219. D30c: "Imagine a situation where Muslims from a Middle Eastern country have to leave their country because war makes their homes unsafe. To what extent do you think [country] should allow them to come and live here?" — Single select {1–4: same as D28} — Filter: ASK SAMPLE C (random 25%)

220. D30d: "Imagine a situation where Muslims from a Middle Eastern country have to leave their country because they are unemployed due to a lack of work. To what extent do you think [country] should allow them to come and live here?" — Single select {1–4: same as D28} — Filter: ASK SAMPLE D (random 25%)

**Section D routing notes**: D30a–D30d are a 2×2 experimental design (Christian/Muslim × war/unemployment). Each respondent receives exactly one variant. D19 is conditional on being born in the country (A80=1).

---

### Section E: Human Values Scale — 20 questions

*ASK ALL. All items use the same 6-point scale: {1: "Very much like me", 2: "Like me", 3: "Somewhat like me", 4: "A little like me", 5: "Not like me", 6: "Not like me at all"}. Gender-neutral wording ("this person", "they/them"). No routing.*

221. E1: "It is important to this person to develop their own opinions." — Single select {1–6}
222. E2: "It is important to this person that the state is strong and can defend its citizens." — Single select {1–6}
223. E3: "It is important to this person to enjoy life's pleasures." — Single select {1–6}
224. E4: "It is important to this person never to make other people angry." — Single select {1–6}
225. E5: "It is important to this person to be very successful." — Single select {1–6}
226. E6: "It is important to this person that everyone be treated justly, even people they don't know." — Single select {1–6}
227. E7: "It is important to this person to have the power to make others comply with what they want." — Single select {1–6}
228. E8: "It is important to this person to be humble." — Single select {1–6}
229. E9: "It is important to this person to protect the natural environment from pollution or destruction." — Single select {1–6}
230. E10: "It is important to this person never to be humiliated." — Single select {1–6}
231. E11: "It is important to this person to have all sorts of new experiences." — Single select {1–6}
232. E12: "It is important to this person to help the people close to them." — Single select {1–6}
233. E13: "It is important to this person to be wealthy." — Single select {1–6}
234. E14: "It is important to this person to be personally safe and secure." — Single select {1–6}
235. E15: "It is important to this person to be tolerant towards all kinds of people and groups." — Single select {1–6}
236. E16: "It is important to this person never to violate rules or regulations." — Single select {1–6}
237. E17: "It is important to this person to make their own decisions about their life." — Single select {1–6}
238. E18: "It is important to this person to follow traditions. These might be cultural, family or religious traditions." — Single select {1–6}
239. E19: "It is important to this person that the people they know have full confidence in them." — Single select {1–6}
240. E20: "It is important to this person that their achievements are recognised by other people." — Single select {1–6}

---

### Section F: Survey Experience — 6 questions

*Filter: SC WEB AND PAPER ONLY*

241. F1: "Overall, how well did you feel you understood the questions?" — Single select {1: "Understood only a few of the questions", 2: "Understood some of the questions", 3: "Understood most of the questions", 4: "Understood all or nearly all of the questions"}

242. F2: "Did you feel reluctant to answer any questions?" — Single select {1: "None of the questions", 2: "A few of the questions", 3: "Some of the questions", 4: "Most of the questions", 5: "All or nearly all of the questions"}

243. F3: "Did anyone else assist you in completing this questionnaire?" — Yes/No {1: "Yes", 2: "No"} — 1 → GO TO F4; 2 → GO TO F6

244. F4: "Who assisted you in completing the questionnaire? Please choose all that apply." — Multi select {1: "Husband, wife, or partner", 2: "Son or daughter", 3: "Parent, parent-in-law, step-parent, or partner's parent", 4: "Other relative", 5: "Other non-relative", 6: "The person who delivered the questionnaire"} — Filter: ASK IF F3 = 1

245. F5: "What kind of assistance was given to you in completing the questionnaire? Please choose all that apply." — Multi select {1: "Understanding the invitation letter and getting started", 2: "Accessing the online survey", 3: "Reading the questions aloud to me", 4: "Providing information for questions about relatives or household members", 5: "Helping me decide answers to other questions", 6: "Returning my completed paper questionnaire", 7: "Other"} — Filter: ASK IF F3 = 1

246. F6: "Do you have any further comments on this survey or its questions?" — Text

---

### Section G: Recontact — 7 questions

247. G1: "Thank you for giving your time to complete this survey today. [NAME OF SURVEY] may want to contact you again to invite you to take part in further research on similar topics to those covered by the questions that you have answered here. Would it be okay if we contact you again, to invite you to take part in a follow-up study?" — Yes/No {1: "Yes", 2: "No"} — ASK ALL. 1 → GO TO G2; 2 → GO TO H1 (web/paper) or end of interview (F2F)

248. G2: "Please enter your first name and surname below." — Text — Filter: ASK IF G1 = 1

249. G3: "Please enter your email address in the boxes below." — Text (email, entered twice for verification) — Filter: ASK IF G1 = 1. Optional

250. G4a: "Do you agree that we may retain your physical address that we used to contact you for this survey?" — Yes/No {1: "Yes", 2: "No"} — Filter: ASK IF G1 = 1. Country chooses G4a or G4b

251. G4b: "Please enter your address in the boxes below." — Text (address fields) — Filter: ASK IF G1 = 1. Alternative to G4a (country decides)

252. G5: "Please enter your mobile telephone number in the boxes below." — Text (phone, entered twice for verification) — Filter: ASK IF G1 = 1. Optional

253. G6: "As a thank you for taking part in this survey we will [send you] [a voucher for] [€xx]. May we use the contact details you've already provided to ensure it reaches you?" — Single select {1: "Yes", 2: "No, I don't want to receive this", 3: "No, I'd like to provide other details"} — Filter: SC WEB AND PAPER ONLY, if country includes G6. 1 → GO TO end; 3 → GO TO H1

---

### Section H: Closing Questions — 3 questions

*Filter: SC WEB AND PAPER ONLY*

254. H1: "Thank you for taking part in this survey today – we really appreciate you giving your time. Please enter your details below to ensure it reaches you." — Text (name, email, phone, address fields) — Filter: ASK IF G1=2, or G6=3, or G6 not asked. For respondents who declined recontact but may receive incentive

255. H2: "Please record the date when you finished completing this questionnaire." — Date (day/month/year) — Filter: SC PAPER ONLY

256. H3: "Please enter your data entry coder ID number." — Numeric — Filter: DATA ENTRY only

---

### Section J: Interviewer Questionnaire — 10 questions

*Filter: F2F ONLY*

257. J1: "Please select how the interview was conducted from the list below." — Single select {1: "In person inside respondent's home", 2: "In person outside of respondent's home", 3: "By video"}

258. J2: "Did the respondent ask for clarification on any questions?" — Single select {1: "Never", 2: "Almost never", 3: "Now and then", 4: "Often", 5: "Very often"}

259. J3: "Did you feel that the respondent was reluctant to answer any questions?" — Single select {1: "Never", 2: "Almost never", 3: "Now and then", 4: "Often", 5: "Very often"}

260. J4: "Did you feel that the respondent tried to answer the questions to the best of his or her ability?" — Single select {1: "Never", 2: "Almost never", 3: "Now and then", 4: "Often", 5: "Very often"}

261. J5: "Overall, did you feel that the respondent understood the questions?" — Single select {1: "Never", 2: "Almost never", 3: "Now and then", 4: "Often", 5: "Very often"}

262. J6: "Was anyone else present, who interfered with the interview?" — Yes/No {1: "Yes", 2: "No"} — 1 → GO TO J7; 2 → GO TO J8

263. J7: "Who was this? CODE ALL THAT APPLY" — Multi select {1: "Husband/wife/partner", 2: "Son/daughter", 3: "Parent/parent-in-law/step-parent/partner's parent", 4: "Other relative", 5: "Other non-relative"} — Filter: ASK IF J6 = 1

264. J8: "In which language was the interview conducted?" — Single select (country-specific ISO 639-2 codes)

265. J9: "Interviewer ID." — Text

266. J10: "If you have any additional comments on the interview, please type them in the space below." — Text
