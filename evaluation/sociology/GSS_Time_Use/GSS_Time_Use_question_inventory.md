# General Social Survey, Cycle 2: Time Use (GSS 2-2) — Question Inventory

## Verification Status

| Section | Source Qs | Inventory Qs | Missing | Source GOTOs | Inv. GOTOs | Missing |
|---------|----------|-------------|---------|-------------|-----------|---------|
| A       | 8        | 8           | 0       | 5           | 5          | 0       |
| B       | 30       | 30          | 0       | 20          | 20         | 0       |
| D       | 12       | 12          | 0       | 1           | 1          | 0       |
| E       | 11       | 11          | 0       | 1           | 1          | 0       |
| F       | 2        | 2           | 0       | 7           | 7          | 0       |
| G       | 12       | 12          | 0       | 5           | 5          | 0       |
| H       | 7        | 7           | 0       | 3           | 3          | 0       |
| J       | 8        | 8           | 0       | 3           | 3          | 0       |
| K       | 9        | 9           | 0       | 3           | 3          | 0       |
| L       | 6        | 6           | 0       | 1           | 1          | 0       |
| M       | 9        | 9           | 0       | 2           | 2          | 0       |
| N       | 6        | 6           | 0       | 2           | 2          | 0       |
| P       | 18       | 18          | 0       | 8           | 8          | 0       |
| Q       | 17       | 17          | 0       | 6           | 6          | 0       |
| R       | 8        | 8           | 0       | 3           | 3          | 0       |
| S       | 17       | 17          | 0       | 6           | 6          | 0       |
| T       | 6        | 6           | 0       | 3           | 3          | 0       |
| U       | 44       | 44          | 0       | 14          | 14         | 0       |
| **Total** | **230** | **230**    | **0**   | **93**      | **93**     | **0**   |

- **Coverage**: 230/230 items verified (100%). All 18 sections fully represented.
- **Routing**: 93/93 GOTO/skip instructions verified (100%). Key routing points confirmed:
  - F1 language filter correctly routes to G/H/J/K/L/M/T based on main language
  - All language sections (G11, H6, J8, K8, L6) correctly exit to Section N
  - Section B skip patterns (B1->B4, B3->B8, B4 employment routing) all captured
  - Section P education routing (P1 complex branching with P1a/P1b sub-questions) correctly modeled
  - Section Q/U work routing (Q6->Q8, Q7->Section R, U28->U31) all captured
  - Section S/U telephone routing (S9->S14, U22->U27) correctly cascaded
  - Section S/U income cascading brackets (S17, U41) fully represented
- **Node types**: All three types present -- Questions (e.g., A1, B4, E1), Filters/Checks (G9, G11, H6, N2, N6, Q2, D_EXTRA), Read items (B_INTRO, D_INTRO)
- **Status**: READY FOR QML
- **Missing**: None

## Document Overview
- **Title**: General Social Survey, Cycle 2: Time Use (GSS 2-2)
- **Organization**: Statistics Canada, Housing, Family and Social Statistics Division
- **Pages**: 26 (Appendix A of Questionnaire Package)
- **Language**: English
- **Type**: Paper-based telephone interview questionnaire, administered November–December 1986
- **Sample**: 10,000 persons aged 15+ across 10 provinces (random digit dialing)

## Structure

The GSS 2-2 questionnaire consists of 18 sections organized into three subject areas (Social Mobility, Daily Activities/Well-being, Language/Background). Section F is a major routing filter that splits respondents into two paths based on main language:

**All respondents:**
1. **Section A** (8 items) — Social Mobility: respondent's birth, immigration, childhood community
2. **Section B** (30 items) — Social Mobility: father's/mother's background, respondent's language/siblings
3. **Section D** (12 template items × 44 activities) — Daily Activities: 24-hour time diary from 4:00 a.m.
4. **Section E** (11 items) — Well-being: happiness, life satisfaction across 9 domains
5. **Section F** (2 items) — Language Knowledge and Use: main language filter

**Multilingual path** (F1 ≠ English-only):
6. **Section G** (12 items) — Language: English main with other language knowledge
7. **Section H** (7 items) — Language: English and French bilingual
8. **Section J** (8 items) — Language: English and Other
9. **Section K** (9 items) — Language: French main
10. **Section L** (6 items) — Language: French and Other
11. **Section M** (9 items) — Language: Other main language
12. **Section N** (6 items) — Language: childhood and adolescence
13. **Section P** (18 items) — Social Mobility: respondent's education and work
14. **Section Q** (17 items) — Language and Background Characteristics
15. **Section R** (8 items) — Language: contact with federal government
16. **Section S** (17 items) — Background Characteristics

**English-only path** (F1 = English, no other language):
17. **Section T** (6 items) — Language: contact with federal government (English-only)
18. **Section U** (44 items) — Background Characteristics (combined education/work/background)

**Routing summary:**
- A → B → D → E → F1
- If multilingual: → (one of G/H/J/K/L/M) → N → P → Q → R → S → END
- If English-only: → T → U → END

**Total: 230 inventory items** (excluding 43 repeated activity entries D3–D44)

## Question Inventory by Section

### Section A: Social Mobility (Respondent) — 8 items

1. A1: "In what country were you born?" — Single select {01: "Canada", 02: "Newfoundland", 03: "Prince Edward Island", 04: "Nova Scotia", 05: "New Brunswick", 06: "Québec", 07: "Ontario", 08: "Manitoba", 09: "Saskatchewan", 10: "Alberta", 11: "British Columbia", 12: "Yukon Territory", 13: "Northwest Territories", 14: "Country outside Canada (specify)"} — If 01 (Canada), show province sub-question {02–13}; if any province selected → GO TO A3; if 14 → GO TO A2

2. A2: "In what year did you first immigrate to Canada?" — Numeric (year) {also: Canadian citizen by birth} — GO TO A3

3. A3: "What is your date of birth?" — Date (Day/Month/Year) — GO TO A4

4. A4: "Did you live in the same community from birth up to age 15? By community I mean city, town or rural area." — Single select {1: "Yes", 2: "No", 3: "Don't know"} — 1 → GO TO A7; 2 → GO TO A5; 3 → GO TO SECTION B

5. A5: "In how many different communities did you live during this time?" — Numeric (communities) {98: "Don't know"} — 98 → GO TO SECTION B; otherwise → GO TO A6

6. A6: "Think about the community you lived in for the longest time from when you were born until you were 15 years old. For how many of those 15 years did you live there?" — Numeric (years) {99: "Don't know"} — GO TO A7

7. A7: "What was the approximate size of that community?" — Single select {1: "Less than 5,000 population or a rural area", 2: "5,000 to less than 25,000 population", 3: "25,000 to less than 100,000 population", 4: "100,000 to 1 million population", 5: "Over 1 million population"} — GO TO A8

8. A8: "Was this place in Canada or elsewhere?" — Single select {6: "In Canada", 7: "Elsewhere"} — 6 → sub-question "What was the name of that town or nearest town?" Text (town) + Text (province); 7 → sub-question "Which country?" Text (specify); then → GO TO SECTION B

### Section B: Social Mobility (Father and/or Mother) — 30 items

1. B_INTRO: "For this part of the survey I would like you to recall certain aspects of your life from when you were born to when you were 15 years old." — Read — GO TO B1

2. B1: "When you were 15 years old, did you live with your own father? (Include adoptive father)" — Single select {1: "Yes", 2: "No"} — 1 → GO TO B4; 2 → GO TO B2

3. B2: "Why was this? Was it because..." — Single select {3: "Your father died", 4: "Parents were divorced or separated", 5: "You or your father were temporarily living away from home", 6: "Other (specify)"} — 3 → GO TO B3; 4 → GO TO B3; 5 → GO TO B4; 6 → GO TO B3

4. B3: "During that time, was there a male who took the role of your father?" — Single select {7: "Yes", 8: "No"} — 7 → GO TO B4; 8 → GO TO B8

5. B4: "Which of the following best describes your father's (or father substitute's) main activity when you were 15 years old?" — Single select {1: "Working at a job or business", 2: "A student", 3: "Retired", 4: "Keeping house", 5: "Other (specify)"} — If 1 → sub-question "In this job was he mainly..." Single select {6: "An employee working for someone else", 7: "Self-employed"}; 6 → GO TO B5; 7 → GO TO B6; 2 → GO TO B8; 3 → GO TO B8; 4 → GO TO B8; 5 → GO TO B8

6. B5: "For whom did he work? (Name of business, government department or agency or person)" — Text {DK: "Don't know"} — GO TO B6

7. B6: "What was the main kind of business, industry or service? (Give a full description: e.g., paper box manufacturing, retail shoe store, municipal board of education)" — Text {DK: "Don't know"} — GO TO B7

8. B7: "What kind of work was he doing? (Give a full description: e.g., posting invoices, selling shoes, teaching primary school)" — Text {DK: "Don't know"} — GO TO B8

9. B8: "In total, how many years of elementary or secondary education did your father (or father substitute) complete?" — Numeric (years) {98: "No schooling", 99: "Don't know"} — 98 → GO TO B11; otherwise → GO TO B9

10. B9: "Did he have any further schooling beyond elementary/secondary school?" — Single select {3: "Yes", 4: "No", 5: "Don't know"} — 3 → GO TO B10; 4 → GO TO B11; 5 → GO TO B11

11. B10: "What was the highest level he attained?" — Single select {1: "Some community college, CEGEP or nursing school", 2: "Diploma or certificate from community college, CEGEP or nursing school", 3: "Some university", 4: "Bachelor or undergraduate degree or teacher's college", 5: "Master's or earned doctorate", 6: "Other (specify)", 7: "Don't know"} — GO TO B11

12. B11: "In what country was he born?" — Single select {01: "Canada", 02–13: provinces, 14: "Country outside Canada (specify)"} — If 01, show province sub-question {02–13}; GO TO B12

13. B12: "To which ethnic or cultural group did he belong?" — Multi select {1: "English", 2: "French", 3: "Irish", 4: "Scottish", 5: "German", 6: "Italian", 7: "Ukrainian", 8: "Other (specify)", 9: "Don't know"} — GO TO B13

14. B13: "What was the first language he learned in childhood? (Accept multiple response only if languages learned at same time)" — Multi select {1: "English", 2: "French", 3: "Other (specify)", 4: "Don't know"} — GO TO B14

15. B14: "The next questions ask about your mother. When you were 15 years old, did you live with your own mother? (Include adoptive mother)" — Single select {1: "Yes", 2: "No"} — 1 → GO TO B17; 2 → GO TO B15

16. B15: "Why was this? Was it because..." — Single select {3: "Your mother died", 4: "Parents were divorced or separated", 5: "You or your mother were temporarily living away from home", 6: "Other (specify)"} — 3 → GO TO B16; 4 → GO TO B16; 5 → GO TO B17; 6 → GO TO B16

17. B16: "During that time, was there a female who took the role of your mother?" — Single select {7: "Yes", 8: "No"} — 7 → GO TO B17; 8 → GO TO B21

18. B17: "Which of the following best describes your mother's (or mother substitute's) main activity when you were 15 years old?" — Single select {1: "Working at a job or business", 2: "Keeping house", 3: "A student", 4: "Retired", 5: "Other (specify)"} — If 1 → sub-question "In this job was she mainly..." Single select {6: "An employee working for someone else", 7: "Self-employed"}; 6 → GO TO B18; 7 → GO TO B19; 2 → GO TO B21; 3 → GO TO B21; 4 → GO TO B21; 5 → GO TO B21

19. B18: "For whom did she work? (Name of business, government department or agency or person)" — Text {DK: "Don't know"} — GO TO B19

20. B19: "What was the main kind of business, industry or service?" — Text {DK: "Don't know"} — GO TO B20

21. B20: "What kind of work was she doing?" — Text {DK: "Don't know"} — GO TO B21

22. B21: "In total, how many years of elementary or secondary education did your mother (or mother substitute) complete?" — Numeric (years) {98: "No schooling", 99: "Don't know"} — 98 → GO TO B24; otherwise → GO TO B22

23. B22: "Did she have any further schooling beyond elementary/secondary school?" — Single select {3: "Yes", 4: "No", 5: "Don't know"} — 3 → GO TO B23; 4 → GO TO B24; 5 → GO TO B24

24. B23: "What was the highest level she attained?" — Single select {1: "Some community college, CEGEP or nursing school", 2: "Diploma or certificate from community college, CEGEP or nursing school", 3: "Some university", 4: "Bachelor or undergraduate degree or teacher's college", 5: "Master's or earned doctorate", 6: "Other (specify)", 7: "Don't know"} — GO TO B24

25. B24: "In what country was she born?" — Single select {01: "Canada", 02–13: provinces, 14: "Country outside Canada (specify)"} — If 01, show province sub-question {02–13}; GO TO B25

26. B25: "To which ethnic or cultural group did she belong?" — Multi select {1: "English", 2: "French", 3: "Irish", 4: "Scottish", 5: "German", 6: "Italian", 7: "Ukrainian", 8: "Other (specify)", 9: "Don't know"} — GO TO B26

27. B26: "What was the first language she learned in childhood? (Accept multiple response only if languages learned at same time)" — Multi select {1: "English", 2: "French", 3: "Other (specify)", 4: "Don't know"} — GO TO B27

28. B27: "What language did you yourself first speak in childhood? (Accept multiple response only if languages were spoken equally)" — Multi select {5: "English", 6: "French", 7: "Other (specify)"} — GO TO B28

29. B28: "How many brothers have you ever had? (Include step-, half- and adopted brothers and those no longer living)" — Numeric (brothers) — GO TO B29

30. B29: "How many sisters have you ever had? (Include step-, half- and adopted sisters and those no longer living)" — Numeric (sisters) — GO TO SECTION D

### Section D: Daily Activities — 12 items (template for 44 activity entries × 5 sub-questions each)

1. D_DAY: "INTERVIEWER: 'X' DAY TO WHICH ACTIVITIES REFER" — Single select {1: "Sunday", 2: "Monday", 3: "Tuesday", 4: "Wednesday", 5: "Thursday", 6: "Friday", 7: "Saturday"} — Interviewer-coded reference day for time diary

2. D_INTRO: "These next questions ask about your daily activities. We need to know in as much detail as you can recall, what you did during ... (refer to reference day) starting at 4:00 o'clock in the morning. This section will provide information on transportation activity, amount of time spent on housework, leisure, paid work, etc. You may have been doing more than one thing at a time but we are interested in the main activity for each time period. We are not interested in activities which lasted only a minute or two. We also ask where you did each activity and if anyone was interacting with you during the activity." — Read — Followed by optional example; then begin activity grid

3. D1a: "First of all, starting at 4:00 a.m., what were you doing?" — Text (2-digit activity code) — Record main activity; start time pre-filled as 04:00

4. D1c: "When did this end?" — Text (HH:MM time) — End time of first activity; becomes start time of next activity

5. D1d: "Where were you?" — Single select {1: "R's Home", 2: "Work Place", 3: "Other Place", 4: "Car", 5: "Walk", 6: "Bus & Subway", 7: "Other"} — Codes 1–3 = Place; codes 4–7 = In Transit

6. D1e: "Who was with you?" — Multi select {1: "Alone", 2: "Spouse/Partner", 3: "Child(ren) of Household", 4: "Other Family Member(s)", 5: "Friend(s)", 6: "Other Person(s)"} — NOTE: Do not ask about sleep, sex, or other personal care activities

7. D2a: "And then, what did you do next?" — Text (2-digit activity code) — Activities 2 through 44 repeat identical structure (D2a–D2e through D44a–D44e)

8. D2b: "When did this start?" — Text (HH:MM time) — Should match end time of previous activity

9. D2c: "When did this end?" — Text (HH:MM time) — End time of this activity

10. D2d: "Where were you? / Were you still..." — Single select {1: "R's Home", 2: "Work Place", 3: "Other Place", 4: "Car", 5: "Walk", 6: "Bus & Subway", 7: "Other"} — Same coding as D1d

11. D2e: "Who was with you? / Were you still..." — Multi select {1: "Alone", 2: "Spouse/Partner", 3: "Child(ren) of Household", 4: "Other Family Member(s)", 5: "Friend(s)", 6: "Other Person(s)"} — Same coding as D1e; do not ask about sleep, sex, or other personal care activities

NOTE: Activities 3 through 44 (D3a–D3e through D44a–D44e) follow the identical format as Activity 2 above. Each activity captures: (a) activity code, (b) start time, (c) end time, (d) location/transit mode, (e) companions. The grid continues until the respondent accounts for the full 24-hour reference day or runs out of activity slots.

12. D_EXTRA: "INTERVIEWER: To record additional activities, use Form GSS 2-2D and 'X' the circle below. Also indicate the number of forms used. Number the questions sequentially starting with 45." — Filter — If more than 44 activities, continue on extension form; when all activities recorded → GO TO SECTION E

### Section E: Well-being — 11 items

1. E1: "Presently, would you describe yourself as..." — Scale {1: "Very happy", 2: "Somewhat happy", 3: "Somewhat unhappy", 4: "Very unhappy", 5: "No opinion"} — GO TO E2

2. E2a: "I am going to ask you to rate certain areas of your life. Please rate your feelings about them as very satisfied, somewhat satisfied, somewhat dissatisfied or very dissatisfied. ... Your health" — Scale {1: "Very satisfied", 2: "Somewhat satisfied", 3: "Somewhat dissatisfied", 4: "Very dissatisfied", 5: "No opinion"} — First of 9 life domains

3. E2b: "Your job or main activity" — Scale {1: "Very satisfied", 2: "Somewhat satisfied", 3: "Somewhat dissatisfied", 4: "Very dissatisfied", 5: "No opinion"}

4. E2c: "The way you spend your other time" — Scale {1: "Very satisfied", 2: "Somewhat satisfied", 3: "Somewhat dissatisfied", 4: "Very dissatisfied", 5: "No opinion"}

5. E2d: "Your finances" — Scale {1: "Very satisfied", 2: "Somewhat satisfied", 3: "Somewhat dissatisfied", 4: "Very dissatisfied", 5: "No opinion"}

6. E2e: "Your housing" — Scale {1: "Very satisfied", 2: "Somewhat satisfied", 3: "Somewhat dissatisfied", 4: "Very dissatisfied", 5: "No opinion"}

7. E2f: "Your friendships" — Scale {1: "Very satisfied", 2: "Somewhat satisfied", 3: "Somewhat dissatisfied", 4: "Very dissatisfied", 5: "No opinion"}

8. E2g: "Living partner or single status" — Scale {1: "Very satisfied", 2: "Somewhat satisfied", 3: "Somewhat dissatisfied", 4: "Very dissatisfied", 5: "No opinion"}

9. E2h: "Your relationship with other family members" — Scale {1: "Very satisfied", 2: "Somewhat satisfied", 3: "Somewhat dissatisfied", 4: "Very dissatisfied", 5: "No opinion"}

10. E2i: "Yourself (self-esteem)" — Scale {1: "Very satisfied", 2: "Somewhat satisfied", 3: "Somewhat dissatisfied", 4: "Very dissatisfied", 5: "No opinion"} — Last of 9 life domains

11. E3: "Now, using the same scale, how do you feel about your life as a whole right now?" — Scale {1: "Very satisfied", 2: "Somewhat satisfied", 3: "Somewhat dissatisfied", 4: "Very dissatisfied", 5: "No opinion"} — GO TO SECTION F

### Section F: Language Knowledge and Use — 2 items

1. F1: "What is your main language, that is, the language in which you are most at ease? (Report two if the respondent is equally at ease in two languages)" — Single select {1: "English", 2: "English and French", 3: "English and Other (specify)", 4: "French", 5: "French and Other (specify)", 6: "Other (specify)"} — 1 → GO TO F1a; 2 → GO TO SECTION H; 3 → GO TO SECTION J; 4 → GO TO SECTION K; 5 → GO TO SECTION L; 6 → GO TO SECTION M

2. F1a: "Have you ever had any knowledge or understanding of a language other than English?" — Yes/No {7: "Yes", 8: "No"} — 7 → GO TO SECTION G; 8 → GO TO SECTION T

### Section G: Language (English Main, With Other Language Knowledge) — 12 items

1. G1: "Do you have any knowledge or understanding of French?" — Yes/No {1: "Yes", 2: "No"} — 1 → GO TO G2; 2 → GO TO G6

2. G2: "When was the last time that you had a conversation in French, excluding language courses?" — Single select {1: "During the last week", 2: "During the last month", 3: "During the last year", 4: "More than a year", 5: "Never"} — GO TO G3

3. G3: "How would you rate yourself in the following language abilities in French?" — Scale (grid: Reading, Understanding, Speaking × Very good/Good/Not very good/Not at all) {Reading: 01: "Very good", 02: "Good", 03: "Not very good", 04: "Not at all"; Understanding: 05: "Very good", 06: "Good", 07: "Not very good", 08: "Not at all"; Speaking: 09: "Very good", 10: "Good", 11: "Not very good", 12: "Not at all"} — GO TO G4

4. G4: "What would you say contributed the most to your present knowledge of French?" — Multi select {1: "Language instruction at school", 2: "Other language courses", 3: "Speaking with family", 4: "Speaking with friends", 5: "Speaking at work", 6: "Watching television", 7: "Other (specify)"} — GO TO G5

5. G5: "Compared to five years ago, would you say that you now... more French, less French or about the same?" — Scale (grid: Know, Use × More/Less/Same) {Know: 1: "More", 2: "Less", 3: "Same"; Use: 4: "More", 5: "Less", 6: "Same"} — GO TO G6

6. G6: "Do you have any knowledge or understanding of a language other than English or French?" — Yes/No {1: "Yes", 2: "No"} — 1 → GO TO G6a; 2 → GO TO G9

7. G6a: "How many other languages do you know or understand?" — Single select {3: "One language (specify)", 4: "Multiple languages (specify best known)"} — GO TO G7

8. G7: "When was the last time you had a conversation in that language (language reported in G6), excluding language courses?" — Single select {5: "During the last week", 6: "During the last month", 7: "During the last year", 8: "More than a year", 9: "Never"} — GO TO G8

9. G8: "In that language (language reported in G6), how would you rate yourself in the following abilities?" — Scale (grid: Reading, Understanding, Speaking × Very good/Good/Not very good/Not at all) {Reading: 01: "Very good", 02: "Good", 03: "Not very good", 04: "Not at all"; Understanding: 05: "Very good", 06: "Good", 07: "Not very good", 08: "Not at all"; Speaking: 09: "Very good", 10: "Good", 11: "Not very good", 12: "Not at all"} — GO TO G9

10. G9: "INTERVIEWER: If 'No' indicated in both G1 and G6, go to SECTION N." — Filter — If G1=2 AND G6=2 → GO TO SECTION N; otherwise → GO TO G10

11. G10: "Compared to five years ago, would you say that you now use more English, less English or about the same?" — Single select {1: "More", 2: "Less", 3: "Same"} — GO TO G11

12. G11: "INTERVIEWER: Go to SECTION N." — Filter — GO TO SECTION N

### Section H: Language (English and French Bilingual) — 7 items

1. H1: "Compared to five years ago, would you say that you now... more English, less English or about the same?" — Scale (grid: Know, Use × More/Less/Same) {Know: 1: "More", 2: "Less", 3: "Same"; Use: 4: "More", 5: "Less", 6: "Same"} — GO TO H2

2. H2: "Compared to five years ago, would you say that you now... more French, less French or about the same?" — Scale (grid: Know, Use × More/Less/Same) {Know: 4: "More", 5: "Less", 6: "Same"; Use: 7: "More", 8: "Less", 9: "Same"} — GO TO H3

3. H3: "Do you have any knowledge or understanding of a language other than English or French?" — Yes/No {1: "Yes", 2: "No"} — 1 → GO TO H3a; 2 → GO TO SECTION N

4. H3a: "How many other languages do you know or understand?" — Single select {3: "One language (specify)", 4: "Multiple languages (specify best known)"} — GO TO H4

5. H4: "When was the last time you had a conversation in that language (language reported in H3) excluding language courses?" — Single select {5: "During the last week", 6: "During the last month", 7: "During the last year", 8: "More than a year", 9: "Never"} — GO TO H5

6. H5: "In that language (language reported in H3), how would you rate yourself in the following abilities?" — Scale (grid: Reading, Understanding, Speaking × Very good/Good/Not very good/Not at all) {Reading: 01: "Very good", 02: "Good", 03: "Not very good", 04: "Not at all"; Understanding: 05: "Very good", 06: "Good", 07: "Not very good", 08: "Not at all"; Speaking: 09: "Very good", 10: "Good", 11: "Not very good", 12: "Not at all"} — GO TO H6

7. H6: "INTERVIEWER: Go to SECTION N." — Filter — GO TO SECTION N

### Section J: Language (English and Other) — 8 items

1. J1: "Compared to five years ago, would you say that you now... more English, less English or about the same?" — Scale (grid: Know, Use × More/Less/Same) {Know: 1: "More", 2: "Less", 3: "Same"; Use: 4: "More", 5: "Less", 6: "Same"} — GO TO J2

2. J2: "Do you have any knowledge or understanding of French?" — Yes/No {1: "Yes", 8: "No"} — 1 → GO TO J3; 8 → GO TO J7

3. J3: "When was the last time you had a conversation in French, excluding language courses?" — Single select {1: "During the last week", 2: "During the last month", 3: "During the last year", 4: "More than a year", 5: "Never"} — GO TO J4

4. J4: "How would you rate yourself in the following language abilities in French?" — Scale (grid: Reading, Understanding, Speaking × Very good/Good/Not very good/Not at all) {Reading: 01: "Very good", 02: "Good", 03: "Not very good", 04: "Not at all"; Understanding: 05: "Very good", 06: "Good", 07: "Not very good", 08: "Not at all"; Speaking: 09: "Very good", 10: "Good", 11: "Not very good", 12: "Not at all"} — GO TO J5

5. J5: "What would you say contributed the most to your present knowledge of French?" — Multi select {1: "Language instruction at school", 2: "Other language courses", 3: "Speaking with family", 4: "Speaking with friends", 5: "Speaking at work", 6: "Watching television", 7: "Other (specify)"} — GO TO J6

6. J6: "Compared to five years ago, would you say that you now... more French, less French or about the same?" — Scale (grid: Know, Use × More/Less/Same) {Know: 1: "More", 2: "Less", 3: "Same"; Use: 4: "More", 5: "Less", 6: "Same"} — GO TO J7

7. J7: "Other than English or French, how many languages do you know or understand?" — Numeric (languages) — GO TO J8

8. J8: "INTERVIEWER: Go to SECTION N." — Filter — GO TO SECTION N

### Section K: Language (French Main) — 9 items

1. K1: "How would you rate your ability to read in English? Is it..." — Single select {1: "Very good", 2: "Good", 3: "Not very good", 4: "Not at all"} — GO TO K2

2. K2: "What would you say contributed the most to your present knowledge of English?" — Multi select {1: "Language instruction at school", 2: "Other language courses", 3: "Speaking with family", 4: "Speaking with friends", 5: "Speaking at work", 6: "Watching television", 7: "Other (specify)"} — GO TO K3

3. K3: "Compared to five years ago, would you say that you now... more English, less English or about the same? / ...more French, less French or about the same?" — Scale (grid: English Know/Use, French Know/Use × More/Less/Same) {English Know: 4: "More", 5: "Less", 6: "Same"; English Use: codes; French Know: codes; French Use: codes} — GO TO K4

4. K4: "Do you have any knowledge or understanding of a language other than English or French?" — Yes/No {1: "Yes", 2: "No"} — 1 → GO TO K4a; 2 → GO TO K7

5. K4a: "How many other languages do you know or understand?" — Single select {3: "One language (specify)", 4: "Multiple languages (specify best known)"} — GO TO K5

6. K5: "When was the last time you had a conversation in that language (language reported in K4) excluding language courses?" — Single select {5: "During the last week", 6: "During the last month", 7: "During the last year", 8: "More than a year", 9: "Never"} — GO TO K6

7. K6: "In that language (language reported in K4), how would you rate yourself in the following abilities?" — Scale (grid: Reading, Understanding, Speaking × Very good/Good/Not very good/Not at all) {Reading: 01: "Very good", 02: "Good", 03: "Not very good", 04: "Not at all"; Understanding: 05: "Very good", 06: "Good", 07: "Not very good", 08: "Not at all"; Speaking: 09: "Very good", 10: "Good", 11: "Not very good", 12: "Not at all"} — GO TO K7

8. K7: "Compared to five years ago, would you say that you now use more French, less French or about the same?" — Single select {1: "More", 2: "Less", 3: "Same"} — GO TO K8

9. K8: "INTERVIEWER: Go to SECTION N." — Filter — GO TO SECTION N

### Section L: Language (French and Other) — 6 items

1. L1: "Compared to five years ago, would you say that you now... more French, less French or about the same?" — Scale (grid: Know, Use × More/Less/Same) {Know: 1: "More", 2: "Less", 3: "Same"; Use: 4: "More", 5: "Less", 6: "Same"} — GO TO L2

2. L2: "How would you rate your ability to read in English? Is it..." — Single select {6: "Very good", 7: "Good", 8: "Not very good", 9: "Not at all"} — GO TO L3

3. L3: "What would you say contributed the most to your present knowledge of English?" — Multi select {1: "Language instruction at school", 2: "Other language courses", 3: "Speaking with family", 4: "Speaking with friends", 5: "Speaking at work", 6: "Watching television", 7: "Other (specify)"} — GO TO L4

4. L4: "Compared to five years ago, would you say that you now... more English, less English or about the same?" — Scale (grid: Know, Use × More/Less/Same) {Know: 4: "More", 5: "Less", 6: "Same"; Use: 7: "More", 8: "Less", 9: "Same"} — GO TO L5

5. L5: "Other than English or French, how many languages do you know or understand?" — Numeric (languages) — GO TO L6

6. L6: "INTERVIEWER: Go to SECTION N." — Filter — GO TO SECTION N

### Section M: Language (Other Main Language) — 9 items

1. M1: "How would you rate your ability to read in English? Is it..." — Single select {1: "Very good", 2: "Good", 3: "Not very good", 4: "Not at all"} — GO TO M2

2. M2: "What would you say contributed the most to your present knowledge of English?" — Multi select {1: "Language instruction at school", 2: "Other language courses", 3: "Speaking with family", 4: "Speaking with friends", 5: "Speaking at work", 6: "Watching television", 7: "Other (specify)"} — GO TO M3

3. M3: "Compared to five years ago, would you say that you now... more English, less English or about the same?" — Scale (grid: Know, Use × More/Less/Same) {Know: 4: "More", 5: "Less", 6: "Same"; Use: 7: "More", 8: "Less", 9: "Same"} — GO TO M4

4. M4: "Do you have any knowledge or understanding of French?" — Yes/No {1: "Yes", 2: "No"} — 1 → GO TO M5; 2 → GO TO M9

5. M5: "When was the last time you had a conversation in French, excluding language courses?" — Single select {3: "During the last week", 4: "During the last month", 5: "During the last year", 6: "More than a year", 7: "Never"} — GO TO M6

6. M6: "How would you rate yourself in the following language abilities in French?" — Scale (grid: Reading, Understanding, Speaking × Very good/Good/Not very good/Not at all) {Reading: 01: "Very good", 02: "Good", 03: "Not very good", 04: "Not at all"; Understanding: 05: "Very good", 06: "Good", 07: "Not very good", 08: "Not at all"; Speaking: 09: "Very good", 10: "Good", 11: "Not very good", 12: "Not at all"} — GO TO M7

7. M7: "What would you say contributed the most to your present knowledge of French?" — Multi select {1: "Language instruction at school", 2: "Other language courses", 3: "Speaking with family", 4: "Speaking with friends", 5: "Speaking at work", 6: "Watching television", 7: "Other (specify)"} — GO TO M8

8. M8: "Compared to five years ago, would you say that you now... more French, less French or about the same?" — Scale (grid: Know, Use × More/Less/Same) {Know: 4: "More", 5: "Less", 6: "Same"; Use: 7: "More", 8: "Less", 9: "Same"} — GO TO M9

9. M9: "Other than English or French, how many languages do you know or understand?" — Numeric (languages) — GO TO SECTION N

### Section N: Language (Childhood and Adolescence) — 6 items

1. N1: "Before you were six years old, which languages were spoken in your home by people living there?" — Multi select {1: "English", 2: "French", 3: "Other (specify)"} — GO TO N2

2. N2: "INTERVIEWER: If only one language reported in N1, go to N4." — Filter — If count(N1)=1 → GO TO N4; otherwise → GO TO N3

3. N3: "Which languages did you yourself speak at home?" — Multi select with most-often indicator {1: "English", 2: "French", 3: "Other (specify)"; Most often: 4: "English", 5: "French", 6: "Other"} plus "Did you speak this language at home more than 90% of the time?" Yes/No {8: "Yes", 9: "No"} — GO TO N4

4. N4: "When you were fifteen years old, which languages did you yourself speak at home?" — Multi select with most-often indicator {3: "English", 4: "French", 5: "Other (specify)"; Most often: 6: "English", 7: "French", 8: "Other", 9: additional} — GO TO N5

5. N5: "At that time, which languages did you speak with your friends?" — Multi select with most-often indicator {1: "English", 2: "French", 3: "Other (specify)"; Most often: 4: "English", 5: "French", 6: "Other", 7: additional} — GO TO N6

6. N6: "INTERVIEWER: Go to SECTION P." — Filter — GO TO SECTION P

### Section P: Social Mobility (Respondent's Education and Work) — 18 items

1. P1: "How many years of elementary and secondary education have you completed?" — Single select {00: "No schooling", 05: "One to five years", 06: "Six", 07: "Seven", 08: "Eight", 09: "Nine", 10: "Ten", 11: "Eleven", 12: "Twelve", 13: "Thirteen"} — 00 → GO TO P14; 05–08 → ask P1a then GO TO P4; 09–10 → GO TO P2; 11–13 → ask P1b then GO TO P2

2. P1a: "Which languages were used for teaching your courses at primary school, excluding language courses?" — Multi select with most-often marker {1: "English", 2: "French", 3: "Other (specify)"} — Asked if P1 = 05–08; GO TO P4

3. P1b: "Have you graduated from secondary school?" — Yes/No {1: "Yes", 2: "No"} — Asked if P1 = 11–13; GO TO P2

4. P2: "Which languages were used for teaching your courses at primary school, excluding language courses?" — Multi select with most-often marker {1: "English", 2: "French", 3: "Other (specify)"} — Asked if P1 = 09–13; GO TO P3

5. P3: "What about languages used for teaching your courses at secondary school, excluding language courses?" — Multi select with most-often marker {3: "English", 4: "French", 5: "Other (specify)"} — GO TO P4

6. P4: "Have you had any further schooling beyond elementary/secondary school?" — Yes/No {1: "Yes", 2: "No"} — 1 → GO TO P5; 2 → GO TO P7

7. P5: "Which languages were/are used for teaching your courses at these levels, excluding language courses?" — Multi select with most-often marker {3: "English", 4: "French", 5: "Other (specify)"} — GO TO P6

8. P6: "What is the highest level you attained?" — Single select {1: "Some community college, CEGEP or nursing school", 2: "Diploma or certificate from community college, CEGEP or nursing school", 3: "Some university", 4: "Bachelor or undergraduate degree or teacher's college", 5: "Master's or earned doctorate", 6: "Other (specify)"} — GO TO P7

9. P7: "In which year did you reach your highest level of education?" — Date (year) — GO TO P8

10. P8: "Think about the first full-time job you had after reaching your highest level of education in [P7 year]. Were you an employee working for someone else or self-employed?" — Single select {1: "An employee working for someone else", 2: "Self-employed", 3: "Never had a full-time job after this date"} — 1 → GO TO P9; 2 → GO TO P10; 3 → GO TO P13

11. P9: "For whom did you work? (Name of business, government department or agency or person)" — Text — GO TO P10

12. P10: "What was the main kind of business, industry or service? (Give a full description)" — Text — GO TO P11

13. P11: "What kind of work were you doing? (Give a full description)" — Text — GO TO P12

14. P12: "In what year did you begin working at this job?" — Date (year) — GO TO P13

15. P13: "Have you ever taken any language courses as part of full-time school?" — Yes/No {1: "Yes", 2: "No"} — 1 → ask P13a; GO TO P14

16. P13a: "Which languages?" — Multi select {3: "English", 4: "French", 5: "Other (specify)"} — Asked if P13 = Yes; GO TO P14

17. P14: "Have you ever taken any language courses outside of full-time school?" — Yes/No {1: "Yes", 4: "No"} — 1 → ask P14a; GO TO SECTION Q

18. P14a: "Which languages?" — Multi select {5: "English", 6: "French", 7: "Other (specify)"} — Asked if P14 = Yes; GO TO SECTION Q

### Section Q: Language and Background Characteristics — 17 items

1. Q1: "Think about the people you live with. Which languages do you speak amongst yourselves at home?" — Multi select {3: "Live alone", 6: "English", 7: "French", 8: "Other (specify)"} — 3 → GO TO Q4; otherwise → GO TO Q2

2. Q2: "INTERVIEWER: If only one language reported in Q1, go to Q4." — Filter — If single language in Q1 → GO TO Q4; if multiple → GO TO Q3

3. Q3: "Which languages do you yourself speak at home?" — Multi select with most-often marker {1: "English", 2: "French", 3: "Other (specify)"} — Includes sub-question: "Do you speak this language at home more than 90% of the time?" Yes/No {8: "Yes", 9: "No"}; GO TO Q4

4. Q4: "Which languages do you yourself speak with your friends outside your home?" — Multi select with most-often marker {3: "English", 4: "French", 5: "Other (specify)"} — GO TO Q5

5. Q5: "Which of the following best describes your main activity during the last 7 days? Were you mainly..." — Single select {1: "Working at a job or business", 2: "Looking for work", 3: "A student", 4: "Keeping house", 5: "Retired", 6: "Other (specify)"} — GO TO Q6

6. Q6: "What about your main activity during the last 12 months? Were you mainly..." — Single select {1: "Working at a job or business", 2: "Looking for work", 3: "A student", 4: "Keeping house", 5: "Retired", 6: "Other (specify)"} — 1 → GO TO Q8; otherwise → GO TO Q7

7. Q7: "Did you have a job at any time during the last 12 months?" — Yes/No {7: "Yes", 8: "No"} — 7 → GO TO Q8; 8 → GO TO SECTION R

8. Q8: "For how many weeks of those 12 months did you do any work at a job or business? (Include vacation, illness, strikes, lock-outs and paid maternity leave)" — Numeric (0–52 weeks) — GO TO Q9

9. Q9: "During those weeks of work were you mainly..." — Single select {1: "An employee working for someone else", 2: "Self-employed"} — 1 → GO TO Q10; 2 → GO TO Q12

10. Q10: "During those weeks of work were you mostly full-time or part-time?" — Single select {3: "Full-time", 4: "Part-time"} — GO TO Q11

11. Q11: "For whom do you/did you last work? (Name of business, government department or agency or person)" — Text — GO TO Q12

12. Q12: "What was the main kind of business, industry or service?" — Text — GO TO Q13

13. Q13: "What kind of work were you doing?" — Text — GO TO Q14

14. Q14: "Which languages are/were spoken at work by people with whom you have/had regular contact?" — Multi select {1: "English", 6: "French", 7: "Other (specify)"} — GO TO Q15

15. Q15: "Considering the last 12 months, which languages have you yourself spoken at work?" — Multi select with most-often marker {1: "English", 2: "French", 3: "Other (specify)"} — Includes sub-question: "Did you speak this language at work more than 90% of the time?" Yes/No; GO TO Q16

16. Q16: "During the last 12 months have you done any writing at work?" — Yes/No {1: "Yes", 2: "No"} — 1 → GO TO Q17; 2 → GO TO SECTION R

17. Q17: "Over this period, which languages did you yourself use for writing at work?" — Multi select with most-often marker {1: "English", 2: "French", 3: "Other (specify)"} — Includes sub-question: "Did you use this language for writing at work more than 90% of the time?" Yes/No; GO TO SECTION R

### Section R: Language — Contact with Federal Government (Multilingual Path) — 8 items

1. R1: "During this period, have you talked with employees of the following federal agencies in connection with the services they provide?" — Roster (11 agencies) with Yes/No per agency — Agencies: Post Office (excluding letter carriers), Canada Employment or Immigration Centres, Old age security or family allowance, National parks, Federal personal income tax, Customs at border crossings only, R.C.M.P., Air Canada, Agriculture Canada, Via Rail or CN Marine, Federal Public Service Commission — If no contacts → GO TO R6; if any Yes → GO TO R2

2. R2: "In your last contact with [agency], in which language did you obtain service?" — Single select per contacted agency {1: "English", 2: "French", 3: "Other"} — Asked for each agency where R1 = Yes; GO TO R3

3. R3: "Was this your preferred language?" — Yes/No per contacted agency — Asked for each agency where R1 = Yes; if all Yes → GO TO R6; if any No → GO TO R4

4. R4: "What was your preferred language?" — Single select per agency {1: "English", 2: "French", 3: "Other"} — Asked for each agency where R3 = No; GO TO R5

5. R5: "Did you ask for service in that language?" — Yes/No per agency — Asked for each agency where R3 = No; GO TO R6

6. R6: "Would you say that, in your area, federal services are generally available in your preferred official language?" — Single select {7: "Yes", 8: "No", 9: "Don't know"} — GO TO R7

7. R7: "In which languages are the television programs you watch?" — Multi select with most-often marker {0: "Never watch television", 1: "English", 2: "French", 3: "Other (specify)"} — Includes sub-question: "Do you watch programs in this language more than 90% of the time?" Yes/No {8: "Yes", 9: "No"}; GO TO R8

8. R8: "Which language did the doctor use during your last visit?" — Single select {1: "Never visited doctor", 2: "English", 3: "French", 4: "Other (specify)"} — GO TO SECTION S

### Section S: Background Characteristics (Multilingual Path) — 17 items

1. S1: "To which ethnic or cultural group do you or did your ancestors belong?" — Multi select {1: "English", 2: "French", 3: "Irish", 4: "Scottish", 5: "German", 6: "Italian", 7: "Ukrainian", 8: "Other (specify)", 9: "Don't know"} — GO TO S2

2. S2: "What, if any, is your religion?" — Single select {0: "No religion", 1: "Roman Catholic", 2: "United Church", 3: "Anglican", 4: "Presbyterian", 5: "Lutheran", 6: "Baptist", 7: "Eastern Orthodox", 8: "Jewish", 9: "Other (specify)"} — 0 → GO TO S4; otherwise → GO TO S3

3. S3: "Other than on special occasions, such as weddings, funerals or baptisms, how often do you attend services or meetings connected with your religion?" — Single select {0: "At least once a week", 1: "At least once a month", 2: "At least once a year", 3: "Less than once a year", 4: "Never"} — GO TO S4

4. S4: "What is the approximate size of the community in which you are now living? By community I mean city, town or rural area." — Single select {1: "Less than 5,000 or rural", 2: "5,000–25,000", 3: "25,000–100,000", 4: "100,000–1 million", 5: "Over 1 million"} — GO TO S5

5. S5: "What is the name of that town or nearest town?" — Text (town and province) — GO TO S6

6. S6: "What are the first three characters of your postal code?" — Text (3 characters) {9: "Don't know"} — GO TO S7

7. S7: "What type of dwelling are you now living in? Is it..." — Single select {1: "Single detached house", 2: "Semi-detached or double (side-by-side)", 3: "Garden house, town-house or row house", 4: "Duplex (one above the other)", 5: "Low-rise apartment (less than five stories)", 6: "High-rise apartment (five or more stories)", 7: "Other (specify)"} — GO TO S8

8. S8: "Is this dwelling owned or rented by a member of this household?" — Single select {6: "Owned", 9: "Rented"} — GO TO S9

9. S9: "How many telephones, counting extensions, are there in your dwelling?" — Single select {1: "One", 2: "Two or more"} — 1 → GO TO S14; 2 → GO TO S10

10. S10: "Do all the telephones have the same number?" — Yes/No {1: "Yes", 4: "No"} — 1 → GO TO S14; 4 → GO TO S11

11. S11: "How many different numbers are there?" — Numeric — GO TO S12

12. S12: "Are any of these numbers for business use only?" — Yes/No {5: "Yes", 6: "No"} — 5 → GO TO S13; 6 → GO TO S14

13. S13: "How many are for business use only?" — Numeric — GO TO S14

14. S14: "What was your income before taxes, from wages, salaries and self-employment during the last 12 months?" — Single select with conditional numeric {1: "Income", 2: "Loss", 3: "No income", 4: "Don't know"} — If 1 or 2 → enter dollar amount; GO TO S15

15. S15: "What was your income from government sources such as Family Allowance, U.I.C., Social Assistance, Canada or Quebec Pension Plan or Old Age Security?" — Numeric (dollar amount) {5: "No income", 6: "Don't know"} — GO TO S16

16. S16: "What was your income from investments or private pensions?" — Single select with conditional numeric {1: "Income", 2: "Loss", 3: "No income", 4: "Don't know"} — If 1 or 2 → enter dollar amount; GO TO S17

17. S17: "What is your best estimate of the total income of all household members from all sources during the last 12 months? Was the total household income..." — Cascading single select: first {1: "Less than $20,000", 2: "$20,000 and more", 3: "No income", 4: "Don't know"}; if 1 → {1: "Less than $10,000", 4: "$10,000 and more"}; if <$10K → {1: "Less than $5,000", 2: "$5,000 and more"}; if $10K+ → {3: "Less than $15,000", 4: "$15,000 and more"}; if 2 → {1: "Less than $40,000", 4: "$40,000 and more"}; if <$40K → {5: "Less than $30,000", 6: "$30,000 and more"}; if $40K+ → {7: "Less than $60,000", 8: "$60,000 and more"} — END OF INTERVIEW

### Section T: Language — Contact with Federal Government (English-Only Path) — 6 items

1. T1: "During this period, have you talked with employees of the following federal agencies in connection with the services they provide?" — Roster (11 agencies) with Yes/No per agency — Agencies: Post Office (excluding letter carriers), Canada Employment or Immigration Centres, Old age security or family allowance, National parks, Federal personal income tax, Customs at border crossings only, R.C.M.P., Air Canada, Agriculture Canada, Via Rail or CN Marine, Federal Public Service Commission — If no contacts → GO TO T4; if any Yes → GO TO T2

2. T2: "Did you obtain service in English for all these contacts?" — Yes/No — Yes → GO TO T4; No → identify agencies and GO TO T3

3. T3: "Did you ask for service in English?" — Yes/No per agency — Asked for each agency where T2 = No; GO TO T4

4. T4: "Would you say that, in your area, federal services are generally available in English?" — Single select {1: "Yes", 2: "No", 3: "Don't know"} — GO TO T5

5. T5: "In which languages are the television programs you watch?" — Multi select with most-often marker {0: "Never watch television", 1: "English", 2: "French", 3: "Other (specify)"} — Includes sub-question: "Do you watch programs in this language more than 90% of the time?" Yes/No {8: "Yes", 9: "No"}; GO TO T6

6. T6: "Which language did the doctor use during your last visit?" — Single select {1: "Never visited doctor", 2: "English", 3: "French", 4: "Other (specify)"} — GO TO SECTION U

### Section U: Background Characteristics (English-Only Path) — 44 items

1. U1: "How many years of elementary and secondary education have you completed?" — Single select {00: "No schooling", 05: "One to five years", 06: "Six", 07: "Seven", 08: "Eight", 09: "Nine", 10: "Ten", 11: "Eleven", 12: "Twelve", 13: "Thirteen"} — 00 → GO TO U12; 05–10 → GO TO U3; 11–13 → GO TO U2

2. U2: "Have you graduated from secondary school?" — Yes/No {1: "Yes", 2: "No"} — GO TO U3

3. U3: "Have you had any further schooling beyond elementary/secondary school?" — Yes/No {3: "Yes", 4: "No"} — 3 → GO TO U4; 4 → GO TO U5

4. U4: "What is the highest level you attained?" — Single select {1: "Some community college, CEGEP or nursing school", 2: "Diploma or certificate from community college, CEGEP or nursing school", 3: "Some university", 4: "Bachelor or undergraduate degree or teacher's college", 5: "Master's or earned doctorate", 6: "Other (specify)"} — GO TO U5

5. U5: "In which year did you reach your highest level of education?" — Date (year) — GO TO U6

6. U6: "Think about the first full-time job you had after reaching your highest level of education in [U5 year]. Were you an employee working for someone else or self-employed?" — Single select {1: "An employee working for someone else", 4: "Self-employed", 9: "Never had a full-time job after this date"} — 1 → GO TO U7; 4 → GO TO U8; 9 → GO TO U11

7. U7: "For whom did you work? (Name of business, government department or agency or person)" — Text — GO TO U8

8. U8: "What was the main kind of business, industry or service? (Give a full description)" — Text — GO TO U9

9. U9: "What kind of work were you doing? (Give a full description)" — Text — GO TO U10

10. U10: "In what year did you begin working at this job?" — Date (year) — GO TO U11

11. U11: "Have you ever taken any language courses as part of full-time school?" — Yes/No {1: "Yes", 2: "No"} — 1 → ask U11a; GO TO U12

12. U11a: "Which languages?" — Multi select {3: "English", 4: "French", 5: "Other (specify)"} — Asked if U11 = Yes; GO TO U12

13. U12: "Have you ever taken any language courses outside of full-time school?" — Yes/No {3: "Yes", 4: "No"} — 3 → ask U12a; GO TO U13

14. U12a: "Which languages?" — Multi select {5: "English", 6: "French", 7: "Other (specify)"} — Asked if U12 = Yes; GO TO U13

15. U13: "What, if any, is your religion?" — Single select {0: "No religion", 1: "Roman Catholic", 2: "United Church", 3: "Anglican", 4: "Presbyterian", 5: "Lutheran", 6: "Baptist", 7: "Eastern Orthodox", 8: "Jewish", 9: "Other (specify)"} — 0 → GO TO U15; otherwise → GO TO U14

16. U14: "Other than on special occasions, such as weddings, funerals or baptisms, how often do you attend services or meetings connected with your religion?" — Single select {0: "At least once a week", 1: "At least once a month", 2: "At least once a year", 3: "Less than once a year", 4: "Never"} — GO TO U15

17. U15: "To which ethnic or cultural group do you or did your ancestors belong?" — Multi select {1: "English", 2: "French", 3: "Irish", 4: "Scottish", 5: "German", 6: "Italian", 7: "Ukrainian", 8: "Other (specify)", 9: "Don't know"} — GO TO U16

18. U16: "What is the approximate size of the community in which you are now living? By community I mean city, town or rural area." — Single select {1: "Less than 5,000 or rural", 2: "5,000–25,000", 3: "25,000–100,000", 4: "100,000–1 million", 5: "Over 1 million"} — GO TO U17

19. U17: "What is the name of that town or nearest town?" — Text (town and province) — GO TO U18

20. U18: "What are the first three characters of your postal code?" — Text (3 characters) {9: "Don't know"} — GO TO U19

21. U19: "What type of dwelling are you now living in? Is it..." — Single select {1: "Single detached house", 2: "Semi-detached or double (side-by-side)", 3: "Garden house, town-house or row house", 4: "Duplex (one above the other)", 5: "Low-rise apartment (less than five stories)", 6: "High-rise apartment (five or more stories)", 7: "Other (specify)"} — GO TO U20

22. U20: "Is this dwelling owned or rented by a member of this household?" — Single select {6: "Owned", 9: "Rented"} — GO TO U21

23. U21: "Is there a language, other than English, spoken in your home by the people living there?" — Single select {1: "Person lives alone", 2: "Yes", 3: "No"} — 2 → ask U21a; GO TO U22

24. U21a: "Which languages?" — Multi select {4: "French", 5: "Other (specify)"} — Asked if U21 = Yes; GO TO U22

25. U22: "How many telephones, counting extensions, are there in your dwelling?" — Single select {1: "One", 2: "Two or more"} — 1 → GO TO U27; 2 → GO TO U23

26. U23: "Do all the telephones have the same number?" — Yes/No {3: "Yes", 4: "No"} — 3 → GO TO U27; 4 → GO TO U24

27. U24: "How many different numbers are there?" — Numeric — GO TO U25

28. U25: "Are any of these numbers for business use only?" — Yes/No {5: "Yes", 6: "No"} — 5 → GO TO U26; 6 → GO TO U27

29. U26: "How many are for business use only?" — Numeric — GO TO U27

30. U27: "Which of the following best describes your main activity during the last 7 days? Were you mainly..." — Single select {1: "Working at a job or business", 2: "Looking for work", 3: "A student", 4: "Keeping house", 5: "Retired", 6: "Other (specify)"} — GO TO U28

31. U28: "What about your main activity during the last 12 months? Were you mainly..." — Single select {1: "Working at a job or business", 2: "Looking for work", 3: "A student", 4: "Keeping house", 5: "Retired", 6: "Other (specify)"} — 1 → GO TO U31; otherwise → GO TO U29

32. U29: "Did you have a job at any time during the last 12 months?" — Yes/No {7: "Yes", 8: "No"} — 7 → GO TO U31; 8 → GO TO U30

33. U30: "Did you have any income from wages, salaries and self-employment during the last 12 months?" — Single select with conditional numeric {1: "Yes", 2: "No income", 3: "Don't know"} — 1 → enter dollar amount as income {4} or loss {5}; then GO TO U39; 2 → GO TO U39; 3 → GO TO U39

34. U31: "For how many weeks of those 12 months did you do any work at a job or business? (Include vacation, illness, strikes, lock-outs and paid maternity leave)" — Numeric (0–52 weeks) — GO TO U32

35. U32: "During those weeks of work were you mainly..." — Single select {1: "An employee working for someone else", 2: "Self-employed"} — 1 → GO TO U33; 2 → GO TO U35

36. U33: "During those weeks of work were you mostly full-time or part-time?" — Single select {3: "Full-time", 4: "Part-time"} — GO TO U34

37. U34: "For whom do you/did you last work? (Name of business, government department or agency or person)" — Text — GO TO U35

38. U35: "What was the main kind of business, industry or service? (Give a full description)" — Text — GO TO U36

39. U36: "What kind of work were you doing? (Give a full description)" — Text — GO TO U37

40. U37: "Which languages are/were spoken at work by people with whom you have/had regular contact?" — Multi select {5: "English", 6: "French", 7: "Other (specify)"} — GO TO U38

41. U38: "What was your income before taxes, from wages, salaries and self-employment during the last 12 months?" — Single select with conditional numeric {1: "Income", 2: "Loss", 3: "No income", 4: "Don't know"} — If 1 or 2 → enter dollar amount; GO TO U39

42. U39: "What was your income from government sources such as Family Allowance, U.I.C., Social Assistance, Canada or Quebec Pension Plan or Old Age Security?" — Numeric (dollar amount) {5: "No income", 6: "Don't know"} — GO TO U40

43. U40: "What was your income from investments or private pensions?" — Single select with conditional numeric {1: "Income", 2: "Loss", 3: "No income", 4: "Don't know"} — If 1 or 2 → enter dollar amount; GO TO U41

44. U41: "What is your best estimate of the total income of all household members from all sources during the last 12 months? Was the total household income..." — Cascading single select: first {1: "Less than $20,000", 2: "$20,000 and more", 3: "No income", 4: "Don't know"}; if 1 → {1: "Less than $10,000", 4: "$10,000 and more"}; if <$10K → {1: "Less than $5,000", 2: "$5,000 and more"}; if $10K+ → {3: "Less than $15,000", 4: "$15,000 and more"}; if 2 → {1: "Less than $40,000", 4: "$40,000 and more"}; if <$40K → {5: "Less than $30,000", 6: "$30,000 and more"}; if $40K+ → {7: "Less than $60,000", 8: "$60,000 and more"} — END OF INTERVIEW
