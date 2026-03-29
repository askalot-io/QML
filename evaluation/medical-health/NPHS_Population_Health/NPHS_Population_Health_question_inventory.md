# National Population Health Survey (NPHS) - Question Inventory

## Verification Status

| Section | Source Qs | Inventory Qs | Missing | Source GOTOs | Inv. GOTOs | Notes |
|---------|----------|-------------|---------|-------------|-----------|-------|
| Household Record Variables | 17 | 17 | 0 | 4 | 4 | MATCH |
| Two-Week Disability | 6 | 7 | 0 | 9 | 9 | +1 explicit CHECK node for DK/R general rule |
| Health Care Utilization | 14+1 check | 15 | 0 | 14 | 14 | MATCH (UTIL-C2 check node captured) |
| Restriction of Activities | 8+1 check | 9 | 0 | 9 | 9 | MATCH (RESTR-C3 check node captured) |
| Chronic Conditions | 6 | 6 | 0 | 3 | 3 | MATCH |
| Socio-demographic Characteristics | 44 | 44 | 0 | 44 | 44 | MATCH (SOCIO 7, EDUC 8, LFS 26, INCOM 3) |
| Administration | 4 | 3 | 1 | 0 | 0 | MISSING: H05-P1/AM54_SRC (H05 proxy indicator, source line 196; source uses same ID H05-P1 for two different items) |
| General Health | 4 | 4 | 0 | 3 | 3 | MATCH |
| Height/Weight | 2 | 2 | 0 | 0 | 0 | MATCH |
| Preventive Health Practices | 7 | 7 | 0 | 5 | 5 | MATCH |
| Smoking | 10 | 10 | 0 | 7 | 7 | MATCH |
| Alcohol | 10+1 check | 11 | 0 | 8 | 8 | MATCH (ALCO-PROXY check node captured) |
| Physical Activities | 10 | 10 | 0 | 4 | 4 | MATCH |
| Injuries | 9 | 9 | 0 | 3 | 3 | MATCH |
| Stress | 44 | 44 | 0 | 36 | 36 | MATCH (CSTRESS 21, RECENT 15, TRAUM 8; marital/children checks captured) |
| Work Stress | 3 | 3 | 0 | 2 | 2 | MATCH |
| Self-Esteem and Mastery | 2+1 intro | 2 | 0 | 2 | 2 | ESTMAST-INT intro absorbed into ESTEEM-Q1 description |
| Sense of Coherence | 14 | 14 | 0 | 2 | 2 | MATCH |
| Health Status | 32 | 32 | 0 | 22 | 22 | Section header says "31" but content has 32 (HSTAT-INT + Q1-Q30 + Q7a); labeling error only |
| Drug Use | 7 | 7 | 0 | 3 | 3 | MATCH |
| Mental Health | 43 | 43 | 0 | 26 | 26 | MATCH (depression path + loss-of-interest path + check nodes) |
| Social Support | 9 | 9 | 0 | 3 | 3 | MATCH |
| Health Number | 2 | 2 | 0 | 2 | 2 | MATCH |
| Agreement to Share | 5 | 5 | 0 | 1 | 1 | MATCH |
| Manitoba Buy-in | 16 | 16 | 0 | 0 | 0 | MATCH |
| Alberta Buy-in | 5 | 5 | 0 | 0 | 0 | MATCH |
| Child General Health | 5 | 5 | 0 | 1 | 1 | MATCH |
| Child Health Care Utilization | 3 | 3 | 0 | 0 | 0 | MATCH |
| Child Chronic Conditions | 9 | 9 | 0 | 3 | 3 | MATCH |
| Child Health Status | 35 | 35 | 0 | 14 | 14 | MATCH |
| Child Injuries | 7 | 7 | 0 | 7 | 7 | MATCH |

- **Coverage**: 31/31 sections verified; 340 items total in inventory; 1 item missing from source (H05-P1/AM54_SRC, Administration section)
- **Routing**: Source has 260 routing lines (per-response-option level); inventory has 168 routing annotations (per-question consolidated level). Gap is presentational: source lists each response option's routing on its own line; inventory consolidates into single annotation per item. The general rule "DK and R allowed on every question" (H05 note) applies broadly and is not repeated per-item in the inventory. All named specific routing (DK/R to specific questions, age-based CINT filters, marital status checks, proxy checks) is captured.
- **Status**: READY FOR QML — one minor gap (H05-P1/AM54_SRC proxy indicator) and one labeling error in Health Status header count ("31" should be "32"); all routing logic captured
- **Missing**: H05-P1/AM54_SRC — General Component H05 proxy/information source indicator (source line 196, variable AM54_SRC). Note: the source document reuses the question ID "H05-P1" for two distinct items (AM54_SRC proxy indicator at line 196 and AM54_TEL telephone/in-person indicator at line 920); the inventory captured the latter but not the former.

## Document Overview
- **Title**: National Population Health Survey - Content For Main Survey
- **Organization**: Statistics Canada
- **Date**: May 1, 1994
- **Pages**: ~56 pages + Appendix A
- **Language**: English (with French bilingual support)
- **Type**: CATI household health survey

## Structure

The NPHS has three major components:

1. **Household Record Variables** — Collected from a knowledgeable household member for all household members
2. **General Component (Form H05)** — Completed for all household members
   - Two-Week Disability
   - Health Care Utilization (age >= 12)
   - Restriction of Activities (age >= 12)
   - Chronic Conditions (age >= 12)
   - Socio-demographic Characteristics (Country of Birth, Ethnicity, Language, Race, Education, Labour Force, Income)
   - Administration
3. **Health Component (Form H06)** — For selected respondent aged 12+
   - General Health, Height/Weight, Preventive Health Practices
   - Smoking, Alcohol, Physical Activities
   - Injuries, Stress (Ongoing/Recent/Childhood), Work Stress
   - Self-Esteem and Mastery, Sense of Coherence
   - Health Status (Vision, Hearing, Speech, Getting Around, Hands/Fingers, Feelings, Memory, Thinking, Pain)
   - Drug Use, Mental Health
   - Social Support, Health Number, Agreement to Share
   - Manitoba Buy-in, Alberta Buy-in (province-specific)
4. **Appendix A: Child Health Component (Form H06)** — For selected respondent aged 0-11
   - Child General Health, Child Health Care Utilization
   - Child Chronic Conditions, Child Health Status, Child Injuries

---

## Question Inventory by Section

---

### Household Record Variables - 17 questions

1. DEMO_INT: "The next few questions will provide important basic information on the people in your household." - Control: Interviewer introduction (no response collected)

2. DEMO_Q1: "What are the names of all persons now living or staying here who have no usual place of residence elsewhere?" - Control: Open text (first and last names)

3. DEMO_Q2 / DHC4_3A: "Are there any persons away from this household attending school, visiting, travelling or in hospital who usually live here?" - Control: Radio - Yes --> GO TO DEMO_Q1, No

4. DEMO_Q3 / DHC4_3B: "Does anyone else live at this dwelling such as young children, relatives, roomers, boarders or employees?" - Control: Radio - Yes --> GO TO DEMO_Q1, No

5. DEMO_Q4 / DHC4_DAT / DHC4_DOB / DHC4_MOB / DHC4_YOB / DHC4_AGE: "What is ...'s date of birth?" - Control: Date entry (DD/MM/YY); age is calculated and confirmed with respondent

6. DEMO_Q5 / DHC4_SEX: "Enter or ask ...'s sex." - Control: Radio - Male, Female

7. DEMO_Q6 / DHC4_MAR: "What is ... current marital status?" - Control: Radio; Note: if age < 15, marital status is automatically = Single - Now married, Common-law, Living with a partner, Single (never married), Widowed, Separated, Divorced

8. DEMO_Q7 / DHC4_FID: "Enter ...'s family Id code." - Control: Text entry (A to Z); Note: legal household check follows; selection criteria applied

9. DEMO_Q8: "Relationships of everyone to everyone else" - Control: Grid/Matrix - Birth Parent, Step Parent, Foster Parent, Birth Child, Step Child, Foster Child, Sister/brother, Grandparent, Grandchild, Common law partner, In-law, Other Related, Unrelated, Husband/Wife, Adopted Child, Adoptive Parent, Same-sex Partner

10. HHLD_Q1 / DHC4_OWN: "Now a few questions about your dwelling. Is this dwelling owned by a member of this household (even if being paid for)?" - Control: Radio - Yes, No

11. HHLD_Q3 / DHC4_BED: "How many bedrooms are there in this dwelling?" - Control: Numeric (2 digits); Note: if no separate, enclosed bedroom enter "00"

12. HHLD_Q4 / DH_4_P1: "Is there a pet in this household?" - Control: Radio - Yes, No --> GO TO HHLD_Q6

13. HHLD_Q5 / DH_4DP2: "What kind of pet?" - Control: Checkbox (do not read list, mark all that apply) - Dog, Cat, Other --> GO TO HHLD_Q6

14. HHLD_Q5a / DH_4_P3: "Does this pet or do any of these pets live mainly indoors?" - Control: Radio - Yes, No

15. HHLD_Q6 / DHC4_DWE: "Record type of dwelling (by interviewer observation)" - Control: Radio (interviewer-coded) - Single detached house, Semi-detached or double, Garden house/town-house/row house, Duplex, Low-rise apartment (<5 stories), High-rise apartment (5+ stories), Institution, Hotel/rooming/lodging house/camp/Hutterite Colony, Mobile home, Other (Specify)

16. HHLD_Q7 / AM34_SRC: "Information Source Indicator i.e. who is providing the information" - Control: Coded entry (interviewer-recorded)

17. HHLD_Q8 / AM34_LNG: "Record language of interview" - Control: Radio (interviewer-recorded) - English, French, Arabic, Chinese, Cree, German, Greek, Hungarian, Italian, Korean, Persian (Farsi), Polish, Portuguese, Punjabi, Spanish, Tagalog (Filipino), Ukrainian, Vietnamese, Other (Specify)

---

## General Component (Form H05)
*To be completed for all members of the household*

---

### Two-Week Disability - 7 questions

1. TWOWK-INT: "The first few questions ask about ...(r/'s) health during the past 14 days." - Control: Interviewer introduction (no response)

2. TWOWK-Q1 / TWC4_1: "It is important for you to refer to the 14-day period from %2WKSAGO% to %YESTERDAY%. During that period, did ... stay in bed at all because of illness or injury including any nights spent as a patient in a hospital?" - Control: Radio - Yes, No --> GO TO TWOWK-Q3, DK/R --> GO TO TWOWK-Q5

3. TWOWK-Q2 / TWC4_2: "How many days did ... stay in bed for all or most of the day?" - Control: Editbox (integer, days; enter 0 if less than a day) - If = 14 days --> GO TO TWOWK-Q5, DK/R --> GO TO TWOWK-Q5

4. TWOWK-Q3 / TWC4_3: "(Not counting days spent in bed) During those 14 days, were there any days that ... cut down on things you/he/she normally do/does because of illness or injury?" - Control: Radio - Yes, No --> GO TO TWOWK-Q5, DK/R --> GO TO TWOWK-Q5

5. TWOWK-Q4 / TWC4_4: "How many days did ... cut down on things for all or most of the day?" - Control: Editbox (integer, days; enter 0 if less than a day)

6. TWOWK-Q5 / TWC4_5: "Do(es) ... have a regular medical doctor?" - Control: Radio - Yes, No

7. CHECK TWOWK-END: Note: DK and R are allowed on every question throughout the General Component (Form H05).

---

### Health Care Utilization - 15 questions

1. UTIL-CINT: Check/Filter — "If age < 12, go to next section." - age < 12 --> GO TO next section

2. UTIL-INT: "Now I'd like to ask about ...(r/'s) contacts with health professionals during the past 12 months." - Control: Interviewer introduction (no response)

3. UTIL-Q1 / HCC4_1: "In the past 12 months, have/has ... been a patient overnight in a hospital, nursing home or convalescent home?" - Control: Radio - Yes, No --> GO TO UTIL-Q2, DK --> GO TO UTIL-Q2, R --> GO TO next section

4. UTIL-Q1a / HCC4_1A: "For how many nights in the past 12 months?" - Control: Editbox (integer, nights)

5. UTIL-Q2 / HCC4_2A-HCC4_2J: "(Not counting when ... were/was an overnight patient) In the past 12 months, how many times have/has ... seen or talked on the telephone with [fill category] about your/his/her physical, emotional or mental health:" - Control: Editbox (integer, times) for each sub-item:
   - a) HCC4_2A: General practitioner or family physician
   - b) HCC4_2B: Eye specialist (ophthalmologist or optometrist)
   - c) HCC4_2C: Other medical doctor (surgeon, allergist, gynaecologist, psychiatrist, etc.)
   - d) HCC4_2D: A nurse for care or advice
   - e) HCC4_2E: Dentist or orthodontist
   - f) HCC4_2F: Chiropractor
   - g) HCC4_2G: Physiotherapist
   - h) HCC4_2H: Social worker or counsellor
   - i) HCC4_2I: Psychologist
   - j) HCC4_2J: Speech, audiology or occupational therapist

6. CHECK UTIL-C2: "For each response > 0 in a), c), or d), ask UTIL-Q3." - Check/Filter — if UTIL-Q2a > 0 OR UTIL-Q2c > 0 OR UTIL-Q2d > 0 --> ask UTIL-Q3; otherwise skip

7. UTIL-Q3 / HCC4_3n: "Where did the most recent contact take place?" - Control: Radio (read list, mark one only) - Walk-in clinic, Outpatient clinic in hospital, Hospital emergency room, Health professional's office, Community health centre/CLSC, At home, Telephone consultation only, Other (Specify)

8. UTIL-Q4 / HCC4_4: "People may also use alternative health care services. In the past 12 months, have/has ... seen or talked to an alternative health care provider such as an acupuncturist, naturopath, homeopath or massage therapist about your/his/her physical, emotional or mental health?" - Control: Radio - Yes, No --> GO TO UTIL-Q6, DK/R --> GO TO UTIL-Q6

9. UTIL-Q5 / HCC4_5A-HCC4_5L, HCC4_4A: "Who did ... see or talk to?" - Control: Checkbox (do not read list, mark all that apply):
   - HCC4_5A: Massage therapist
   - HCC4_5B: Acupuncturist
   - HCC4_5C: Homeopath or naturopath
   - HCC4_5D: Feldenkrais or Alexander teacher
   - HCC4_5E: Relaxation therapist
   - HCC4_5F: Biofeedback teacher
   - HCC4_5G: Rolfer
   - HCC4_5H: Herbalist
   - HCC4_5I: Reflexologist
   - HCC4_5J: Spiritual healer
   - HCC4_5K: Religious healer
   - HCC4_4A: Self help group (AA, cancer therapy, etc.)
   - HCC4_5L: Other (Specify)

10. UTIL-Q6 / HCC4_6: "During the past 12 months, was there ever a time when you/he/she needed health care or advice but did not receive it?" - Control: Radio - Yes, No --> GO TO UTIL-C9, DK/R --> GO TO UTIL-C9

11. UTIL-Q7 / HCC4_7WC, HCC4G7: "Thinking of the most recent time, why did ... not get care?" - Control: Radio (open text + coded) - Difficulty getting access to health professional, Financial constraints, Felt health care provided inadequate, Chose not to see health professional, Other (open text)

12. UTIL-Q8 / HCC4_8A-HCC4_8E: "Again, thinking of the most recent time, what was the type of care that was needed?" - Control: Checkbox (do not read list, mark all that apply):
    - HCC4_8A: Treatment of a physical health problem
    - HCC4_8B: Treatment of an emotional or mental health problem
    - HCC4_8C: A regular check-up (or for regular pre-natal care)
    - HCC4_8D: Care of an injury
    - HCC4_8E: Any other reason (Specify)

13. UTIL-C9: Check/Filter — "IF age < 18 then go to next section." - age < 18 --> GO TO next section

14. UTIL-Q9 / HCC4_9: "Home care services are health care or homemaker services received at home, with the cost being entirely or partially covered by government. Examples are: nursing care; help with bathing; help around the home; physiotherapy; counselling; and meal delivery. Have/Has ... received any home care services in the past 12 months?" - Control: Radio - Yes, No --> GO TO next section, DK/R --> GO TO next section

15. UTIL-Q10 / HCC4_SC, HCC4_10A-HCC4_10H: "What type of services have/has ... received?" - Control: Checkbox (mark all that apply):
    - HCC4_SC: Specify (open text)
    - HCC4_10A: Nursing care
    - HCC4_10C: Personal care
    - HCC4_10D: Housework
    - HCC4_10E: Meal preparation
    - HCC4_10F: Shopping
    - HCC4_10H: Other

---

### Restriction of Activities - 9 questions

1. RESTR-CINT: Check/Filter — "If age < 12, go to next section." - age < 12 --> GO TO next section

2. RESTR-INT: "The next few questions deal with any health limitations which affect ...(r/'s) daily activities. In these questions, 'long-term conditions' refer to conditions that have lasted or are expected to last 6 months or more." - Control: Interviewer introduction (no response)

3. RESTR-Q1 / RAC4_1A-RAC4_1D: "Because of a long-term physical or mental condition or a health problem, are/is ... limited in the kind or amount of activity you/he/she can do:" - Control: Radio for each sub-item:
   - a) RAC4_1A: at home — Yes, No, R --> GO TO next section
   - b) RAC4_1B: at school — Yes, No, Not applicable, R --> GO TO next section
   - c) RAC4_1C: at work — Yes, No, Not applicable, R --> GO TO next section
   - d) RAC4_1D: in other activities such as transportation to or from work or leisure time activities — Yes, No, R --> GO TO next section

4. RESTR-Q2 / RAC4_2: "Do(es) ... have any long term disabilities or handicaps?" - Control: Radio - Yes, No, R --> GO TO next section

5. CHECK RESTR-C3: "If any Yes in RESTR-Q1(a)-(d), ask RESTR-Q3. If Yes in RESTR-Q2 only, ask RESTR-Q4. Otherwise go to RESTR-Q6." - Check/Filter routing gate

6. RESTR-Q3 / RAC4_3C: "What is the main condition or health problem causing ... to be limited in your/his/her activities?" - Control: Editbox (open text, 25 characters) --> GO TO RESTR-Q5

7. RESTR-Q4 / RAC4_3C: "What is the main condition or health problem causing ... to have a long term disability or handicap?" - Control: Editbox (open text, 25 characters)

8. RESTR-Q5 / RAC4_5: "Which one of the following is the best description of the cause of this condition?" - Control: Radio (read list, mark one only) - Injury - at home, Injury - sports or recreation, Injury - motor vehicle, Injury - work-related, Existed at birth, Work environment, Disease or illness, Natural aging process, Psychological or physical abuse, Other (Specify)

9. RESTR-Q6 / RAC4_6A-RAC4_6G: "The next question asks about help received. Because of any condition or health problem, do(es) ... need the help of another person in:" - Control: Checkbox (read list, mark all that apply):
   - RAC4_6A: Preparing meals?
   - RAC4_6B: Shopping for groceries or other necessities?
   - RAC4_6C: Doing normal everyday housework?
   - RAC4_6D: Doing heavy household chores such as washing walls, yard work, etc.?
   - RAC4_6E: Personal care such as washing, dressing or eating?
   - RAC4_6F: Moving about inside the house?
   - RAC4_6G: None of the above

---

### Chronic Conditions - 6 questions

1. CHRON-CINT: Check/Filter — "If age < 12 go to next section." - age < 12 --> GO TO next section

2. CHRON-INT: "Now I'd like to ask about any chronic health conditions ... may have. Again, 'long-term conditions' refer to conditions that have lasted or are expected to last 6 months or more." - Control: Interviewer introduction (no response)

3. CHRON-Q1 / CCC4_1A-CCC4_1V, CCC4_NON: "Do(es) ... have any of the following long-term conditions that have been diagnosed by a health professional: (Read list. Mark all that apply.)" - Control: Checkbox (multi-select)
   - (a) CCC4_1A: Food allergies?
   - (b) CCC4_1B: Other allergies?
   - (c) CCC4_1C: Asthma? --> If YES, ask CHRON-Q1cc1
   - (d) CCC4_1D: Arthritis or rheumatism?
   - (e) CCC4_1E: Back problems excluding arthritis?
   - (f) CCC4_1F: High blood pressure?
   - (g) CCC4_1G: Migraine headaches?
   - (h) CCC4_1H: Chronic bronchitis or emphysema?
   - (i) CCC4_1I: Sinusitis?
   - (j) CCC4_1J: Diabetes?
   - (k) CCC4_1K: Epilepsy?
   - (l) CCC4_1L: Heart disease?
   - (m) CCC4_1M: Cancer? --> If YES, ask CHRON-Q1mm
   - (n) CCC4_1N: Stomach or intestinal ulcers?
   - (o) CCC4_1O: Effects of stroke?
   - (p) CCC4_1P: Urinary incontinence?
   - (q) CCC4_1W: Acne requiring prescription medication? (Ask if age < 30 only)
   - [For persons aged < 18 years go to (u)]
   - (r) CCC4_1R: Alzheimer's disease or other dementia?
   - (s) CCC4_1S: Cataracts?
   - (t) CCC4_1T: Glaucoma?
   - (u) CCC4_1V: Any other long term condition? (Specify)
   - (v) CCC4_NON: None --> GO TO next section; DK/R --> GO TO next section

4. CHRON-Q1mm / CCC4_M1: "What type(s) of cancer is this? For example, skin, lung or colon cancer." - Control: Text open-ended (50 chars); DK/R --> GO TO next section

5. CHRON-Q1cc1 / CCC4_C7: "Have/Has ... had an attack of asthma in the past 12 months?" - Control: Radio - Yes, No

6. CHRON-Q1cc2 / CCC4_C8: "Have/Has ... had wheezing or whistling in the chest at any time in the past 12 months?" - Control: Radio - Yes, No

---

### Socio-demographic Characteristics - 44 questions

**Country of Birth / Year of Immigration**

1. SOCIO-INT: "Now I'd like to ask some general background questions about the characteristics of people in your household." - Control: Interviewer introduction (no response)

2. SOCIO-Q1 / SDC4_1: "In what country were/was ... born? (Do not read list. Mark one only.)" - Control: Dropdown (single select) - Canada --> GO TO SOCIO-Q4, China, France, Germany, Greece, Guyana, Hong Kong, Hungary, India, Italy, Jamaica, Netherlands, Philippines, Poland, Portugal, United Kingdom, United States, Viet Nam, Other (Specify), DK/R --> GO TO SOCIO-Q4

3. SOCIO-Q3 / SDC4_3: "In what year did ... first immigrate to Canada?" - Control: Editbox (4-digit year); Note: Enter <1999> if Canadian citizen by birth; DK/R --> GO TO SOCIO-Q4

**Ethnicity**

4. SOCIO-Q4 / SDC4_4A-SDC4_4S: "To which ethnic or cultural group(s) did your/his/her ancestors belong? (Do not read list. Mark all that apply.)" - Control: Checkbox (multi-select) - SDC4_4A: Canadian, SDC4_4B: French, SDC4_4C: English, SDC4_4D: German, SDC4_4E: Scottish, SDC4_4F: Irish, SDC4_4G: Italian, SDC4_4H: Ukrainian, SDC4_4I: Dutch (Netherlands), SDC4_4J: Chinese, SDC4_4K: Jewish, SDC4_4L: Polish, SDC4_4M: Portuguese, SDC4_4N: South Asian, SDC4_4O: Black, SDC4_4P: North American Indian, SDC4_4Q: Metis, SDC4_4R: Inuit/Eskimo, SDC4_4S: Other (Specify)

**Language**

5. SOCIO-Q5 / SDC4_5A-SDC4_5S: "In which languages can ... conduct a conversation? (Do not read list. Mark all that apply.)" - Control: Checkbox (multi-select) - SDC4_5A: English, SDC4_5B: French, SDC4_5C: Arabic, SDC4_5D: Chinese, SDC4_5E: Cree, SDC4_5F: German, SDC4_5G: Greek, SDC4_5H: Hungarian, SDC4_5I: Italian, SDC4_5J: Korean, SDC4_5K: Persian (Farsi), SDC4_5L: Polish, SDC4_5M: Portuguese, SDC4_5N: Punjabi, SDC4_5O: Spanish, SDC4_5P: Tagalog (Filipino), SDC4_5Q: Ukrainian, SDC4_5R: Vietnamese, SDC4_5S: Other (Specify)

6. SOCIO-Q6 / SDC4_6A-SDC4_6S: "What is the language that ... first learned at home in childhood and can still understand? (Do not read list. Mark all that apply.)" - Control: Checkbox (multi-select) - SDC4_6A: English, SDC4_6B: French, SDC4_6C: Arabic, SDC4_6D: Chinese, SDC4_6E: Cree, SDC4_6F: German, SDC4_6G: Greek, SDC4_6H: Hungarian, SDC4_6I: Italian, SDC4_6J: Korean, SDC4_6K: Persian (Farsi), SDC4_6L: Polish, SDC4_6M: Portuguese, SDC4_6N: Punjabi, SDC4_6O: Spanish, SDC4_6P: Tagalog (Filipino), SDC4_6Q: Ukrainian, SDC4_6R: Vietnamese, SDC4_6S: Other (Specify)

**Race**

7. SOCIO-Q7 / SDC4_7A-SDC4_7L: "How would you best describe ...(r/'s) race or colour? (Do not read list. Mark all that apply.)" - Control: Checkbox (multi-select) - SDC4_7A: White, SDC4_7D: Black, SDC4_7K: Korean, SDC4_7G: Filipino, SDC4_7J: Japanese, SDC4_7B: Chinese, SDC4_7E: Native/Aboriginal Peoples of North America, SDC4_7C: South Asian, SDC4_7H: South East Asian, SDC4_7F: West East Asian or North African, SDC4_7L: Other (Specify)

**Education**

8. EDUC-C1: Check/Filter — "If age < 12, go to next section." - age < 12 --> GO TO Labour Force section

9. EDUC-Q1 / EDC4_4: "Excluding kindergarten, how many years of elementary and high school have/has ... successfully completed? (Do not read list. Mark one only.)" - Control: Radio (single select) - No schooling --> GO TO Labour Force, One to five years, Six, Seven, Eight, Nine, Ten, Eleven, Twelve, Thirteen, DK/R --> GO TO Labour Force; Note: If age < 15 then go to Labour Force

10. EDUC-Q2 / EDC4_5: "Have/has ... graduated from high school?" - Control: Radio - Yes, No

11. EDUC-Q3 / EDC4_6: "Have/has ... ever attended any other kind of school such as university, community college, business school, trade or vocational school, CEGEP or other post-secondary institution?" - Control: Radio - Yes, No --> GO TO EDUC-C5, DK/R --> GO TO Labour Force

12. EDUC-Q4 / EDC4_7: "What is the highest level of education that ... have/has attained? (Do not read list. Mark one only.)" - Control: Radio (single select) - Some trade/technical/vocational school or business college, Some community college/CEGEP/nursing school, Some university, Diploma/certificate from trade/technical/vocational school/business college, Diploma/certificate from community college/CEGEP/nursing school, Bachelor's or undergraduate degree or teacher's college, Master's, Degree in medicine/dentistry/veterinary medicine/optometry, Earned doctorate, Other (Specify)

13. EDUC-C5: Check/Filter — "If age >= 65, go to next section." - age >= 65 --> GO TO Labour Force section

14. EDUC-Q5 / EDC4_1: "Are/Is ... currently attending a school, college or university?" - Control: Radio - Yes, No --> GO TO Labour Force, DK/R --> GO TO Labour Force

15. EDUC-Q6 / EDC4_2: "Are/Is ... enrolled as a full-time or part-time student?" - Control: Radio - Full-time, Part-time

**Labour Force**

16. LFS-C1: Check/Filter — "If age < 15 go to Income section." - age < 15 --> GO TO Income

17. LFS-Q1 / LFC4_1: "What do/does ... consider to be your/his/her current main activity? (Do not read list. Mark one only.)" - Control: Radio (single select) - Caring for family, Working for pay or profit, Caring for family and working for pay or profit, Going to school, Recovering from illness/on disability, Looking for work, Retired, Other (Specify)

18. LFS-I2: "The next section contains questions about jobs or employment which ... have/has had during the past 12 months." - Control: Interviewer introduction (no response)

19. LFS-C2: Check/Filter — "If LFS-Q1 = 2 or 3 --> GO TO LFS-Q3.1." - Working/Caring+Working --> GO TO LFS-Q3.1

20. LFS-Q2 / LFC4_2: "Have/has you/he/she worked for pay or profit at any time in the past 12 months?" - Control: Radio - Yes --> GO TO LFS-Q3.1, No, DK/R --> GO TO Income

21. LFS-C2A: Check/Filter — "If LFS-Q1 = 7 (retired) --> GO TO LFS-C18; otherwise --> GO TO LFS-Q17B." - routing gate

22. LFS-Q3.n / LFC4_EnC: [Roster, up to 6 jobs] "For whom/whom else have/has you/he/she worked for pay or profit in the past 12 months?" - Control: Text open-ended (50 chars)

23. LFS-Q4.n / LFC4_4n: "Did you/he/she have that job 1 year ago, that is, on %12MOSAGO% without a break in employment since then?" - Control: Radio - Yes --> GO TO LFS-Q6.n, No, DK/R --> GO TO Income

24. LFS-Q5.n / LFC4_5nM, LFC4_5nD, LFC4_5nY: "When did you/he/she start working at this job or business?" - Control: Date (MM/DD/YY); DK/R --> GO TO Income

25. LFS-Q6.n / LFC4_6n: "Do/Does you/he/she now have that job?" - Control: Radio - Yes --> GO TO LFS-Q8.n, No, DK/R --> GO TO Income

26. LFS-Q7.n / LFC4_7nM, LFC4_7nD, LFC4_7nY: "When did you/he/she stop working at this job or business?" - Control: Date (MM/DD/YY); DK/R --> GO TO Income

27. LFS-Q8.n / LFC4_8n: "About how many hours per week do/does/did you/he/she usually work at this job?" - Control: Editbox (numeric, 2 digits, hours)

28. LFS-Q9.n / LFC4_9n: "Which of the following best describes the hours you/he/she usually work/works/worked at this job? (Read list. Mark one only.)" - Control: Radio - Regular daytime schedule or shift, Regular evening shift, Regular night, Rotating shift, Split shift, On call, Irregular schedule, Other (Specify)

29. LFS-Q10.n / LFC4_10n: "Do/Does/Did you/he/she usually work on weekends at this job?" - Control: Radio - Yes, No

30. LFS-Q11.n / LFC4_11n: "Did you/he/she do any other work for pay or profit in the past 12 months?" - Control: Radio - Yes, No, DK/R --> GO TO LFS-Q12

31. LFS-C12: Check/Filter — "If LFS-Q11.1 = No --> GO TO LFS-Q13." - routing gate

32. LFS-Q12 / LFC4FMN: "Which was the main job?" - Control: Roster selection; Note: Definition of main job supplied in interviewers manual

33. LFS-Q13 / LFC4_13C: "Thinking about this/the main job, what kind of business, service or industry is this?" - Control: Text open-ended (50 chars)

34. LFS-Q14 / LFC4_14C: "Again, thinking about this/the main job, what kind of work was/were ... doing?" - Control: Text open-ended (50 chars)

35. LFS-Q15 / LFC4_15C: "In this work, what were your/his/her most important duties or activities?" - Control: Text open-ended (50 chars)

36. LFS-Q16 / LFC4_16: "Did you/he/she work mainly for others for wages or commission or in your/his/her own business, farm or practice? (Do not read list. Mark one only.)" - Control: Radio - For others for wages/salary/commission, In own business/farm/professional practice, Unpaid family worker

37. LFS-C17: Check/Filter — "Check the calendar for gaps > 6 days. If # gaps = 0 --> GO TO LFS-C18." - routing gate

38. LFS-C17A: Check/Filter — "If any LFS-Q6 = 1 (currently employed) --> GO TO LFS-Q17A; otherwise --> GO TO LFS-Q17B." - routing gate

39. LFS-Q17A / LFC4_17A: "What was the reason that ... were/was not working for pay or profit during the most recent period away from work in the past year? (Do not read list. Mark one only.)" - Control: Radio - Own illness or disability, Pregnancy, Caring for own children, Caring for elder relative(s), Other personal or family responsibilities, School or educational leave, Labour dispute, Temporary layoff due to seasonal conditions, Temporary layoff - non-seasonal, Permanent layoff, Unpaid or partially paid vacation, Other (Specify), No period not working --> GO TO LFS-C18

40. LFS-Q17B / LFC4_17B: "What is the reason that ... are/is currently not working for pay or profit? (Do not read list. Mark one only.)" - Control: Radio - Own illness or disability, Pregnancy, Caring for own children, Caring for elder relative(s), Other personal or family responsibilities, School or educational leave, Labour dispute, Temporary layoff due to seasonal conditions, Temporary layoff - non-seasonal, Permanent layoff, Unpaid or partially paid vacation, Other (Specify), No period not working

41. LFS-C18: Derived variable/constraint — "If LFS-Q1 = 2 or 3, OR any LFS-Q6.1-LFS-Q6.6 = 1 (currently working), then %LFS-WORK% = 1; otherwise %LFS-WORK% = 0." - Control: derived variable

**Income** (Ask from knowledgeable person only)

42. INCOM-Q1 / INC4_1A-INC4_1N: "Thinking about your total household income, from which of the following sources did your household receive any income in the past 12 months? (Read list. Mark all that apply.)" - Control: Checkbox (multi-select) - INC4_1A: Wages and salaries, INC4_1B: Income from self-employment, INC4_1C: Dividends and interest, INC4_1D: Unemployment insurance, INC4_1E: Worker's compensation, INC4_1F: Benefits from CPP/QPP, INC4_1G: Retirement pensions/superannuation/annuities, INC4_1H: Old Age Security and GIS, INC4_1I: Child Tax Benefit, INC4_1J: Provincial/municipal social assistance or welfare, INC4_1K: Child Support, INC4_1L: Alimony, INC4_1M: Other Income, INC4_1N: None --> GO TO next section, DK/R --> GO TO next section; Note: If more than one source --> ask INCOM-Q2; if only one source --> ask INCOM-Q3

43. INCOM-Q2 / INC4_2: "What was the main source of income? (Do not read list. Mark one only.)" - Control: Radio (single select) - same options as INCOM-Q1

44. INCOM-Q3 / INC4_3A-INC4_3G: "What is your best estimate of the total income before taxes and deductions of all household members from all sources in the past 12 months?" - Control: Branching income bracket (unfolding tree):
    - INC4_3A: Less than $20,000?
      - INC4_3B: Less than $10,000?
        - INC4_3C: Less than $5,000? / $5,000 and more?
      - INC4_3B: $10,000 and more?
        - INC4_3D: Less than $15,000? / $15,000 and more?
    - INC4_3A: $20,000 and more?
      - INC4_3E: Less than $40,000?
        - INC4_3F: Less than $30,000? / $30,000 and more?
      - INC4_3E: $40,000 and more?
        - INC4_3G: Less than $50,000? / $50,000 to $60,000? / $60,000 to $80,000? / $80,000 and more?
    - INC4_3A: No income --> GO TO next section
    - DK/R --> GO TO next section

---

### Administration - 3 questions

1. H05-P1 / AM54_TEL: "Was this interview conducted on the telephone or in person?" - Control: Radio - On telephone, In person, Both (Specify in comments)

2. H05-P2 / AM54_LNG: "Record language of interview" - Control: Radio - English, French, Arabic, Chinese, Cree, German, Greek, Hungarian, Italian, Korean, Persian (Farsi), Polish, Portuguese, Punjabi, Spanish, Tagalog (Filipino), Ukrainian, Vietnamese, Other (Specify)

3. H06-P1 / AM64_SRC: "Who is providing the information for this person's form?" - Control: Open text (verbatim record); Note: Form H06 is for selected respondent aged 12+; proxy permitted for those unable to answer

---

## Health Component (Form H06)
*To be completed for selected respondent only, age >= 12*

---

### General Health - 4 questions

1. GENHLT-Q1 / GHC4_1: "In general, would you say ...(r/'s) health is:" - Control: Radio (read list, mark one) - 1=Excellent, 2=Very good, 3=Good, 4=Fair, 5=Poor

2. GENHLT-C2: Check/Filter — "If sex = female AND age >= 15 AND age <= 49 --> ask GENHLT-Q2; Otherwise --> go to Height/Weight section"

3. GENHLT-Q2 / HWC4_1: "It is important to know when analyzing health whether or not the person is pregnant. Are/Is ... pregnant?" - Control: Radio - 1=Yes, 2=No --> GO TO Height/Weight, DK/R --> GO TO Height/Weight

4. GENHLT-Q3 / GHC4_3: "Are/Is you/she planning to use the services of a physician, midwife or both?" - Control: Radio (do not read list, mark one) - 1=Physician only, 2=Midwife only, 3=Both physician and midwife, 4=Neither

---

### Height/Weight - 2 questions

1. HTWT-Q1 / HWC4_2HT: "How tall are/is ... without shoes on?" - Control: Numeric entry - feet + inches OR centimetres

2. HTWT-Q2 / HWC4_3LB / HWC4_3KG: "How much do/does you/he/she weigh?" - Control: Numeric entry - pounds OR kilograms

---

### Preventive Health Practices - 7 questions

*Non-proxy only*

1. PHP-Q1 / BPC4_1: "When did you last have your blood pressure checked by a health professional?" - Control: Radio (do not read list, mark one) - 1=Less than 6 months ago, 2=6 months to less than a year ago, 3=1 year to less than 2 years ago, 4=2 years to less than 5 years ago, 5=5 years or more ago, 6=Never; R --> GO TO Smoking section

2. PHP-C2: Check/Filter — "If sex = female AND age >= 35 --> ask PHP-Q2; If sex = female AND age >= 18 AND age < 35 --> ask PHP-Q3; If sex = male OR female age <= 17 --> GO TO Smoking section"

3. PHP-Q2 / WHC4_30: "Have you ever had a mammogram, that is, a breast X-ray?" - Control: Radio - 1=Yes, 2=No --> GO TO PHP-Q3, DK --> GO TO PHP-Q3, R --> GO TO Smoking section

4. PHP-Q2a / WHC4_32: "When was the last time?" - Control: Radio (do not read list, mark one) - 1=Less than 6 months ago, 2=6 months to less than one year ago, 3=1 year to less than 2 years ago, 4=2 years or more ago

5. PHP-Q2b / WHC4_33: "Why did you have your last mammogram?" - Control: Radio (read list, mark one) - 1=Breast problem, 2=Check-up no particular problem, 3=Other (specify)

6. PHP-Q3 / WHC4_20: "Have you ever had a PAP smear test?" - Control: Radio - 1=Yes, 2=No --> GO TO Smoking section, DK/R --> GO TO Smoking section

7. PHP-Q3a / WHC4_22: "When was the last time?" - Control: Radio (do not read list, mark one) - 1=Less than 6 months ago, 2=6 months to less than one year ago, 3=1 year to less than 3 years ago, 4=3 years to less than 5 years ago, 5=5 years or more ago

---

### Smoking - 10 questions

1. SMOK-INT: "The next few questions are about smoking." - Control: Interviewer introduction (no response)

2. SMOK-Q1 / SMC4_1: "Does anyone in this household smoke regularly inside the house?" - Control: Radio - 1=Yes, 2=No

3. SMOK-Q2 / SMC4_2: "At the present time do/does ... smoke cigarettes daily, occasionally or not at all?" - Control: Radio - 1=Daily, 2=Occasionally --> GO TO SMOK-Q5, 3=Not at all --> GO TO SMOK-Q4a, DK/R --> GO TO Alcohol section

4. SMOK-Q3 / SMC4_3: "At what age did you/he/she begin to smoke cigarettes daily?" - Control: Editbox (age, integer)

5. SMOK-Q4 / SMC4_4: "How many cigarettes do/does you/he/she smoke each day now?" - Control: Editbox (number of cigarettes) --> GO TO Alcohol section

6. SMOK-Q4a / SMC4_4A: "Have/has you/he/she ever smoked cigarettes at all?" - Control: Radio - 1=Yes, 2=No --> GO TO Alcohol section, DK/R --> GO TO Alcohol section

7. SMOK-Q5 / SMC4_5: "Have/has you/he/she ever smoked cigarettes daily?" - Control: Radio - 1=Yes, 2=No --> GO TO Alcohol section, DK/R --> GO TO Alcohol section

8. SMOK-Q6 / SMC4_6: "At what age did you/he/she begin to smoke (cigarettes) daily?" - Control: Editbox (age, integer)

9. SMOK-Q7 / SMC4_7: "How many cigarettes did you/he/she usually smoke each day?" - Control: Editbox (number of cigarettes)

10. SMOK-Q8 / SMC4_8: "At what age did you/he/she stop smoking (cigarettes) daily?" - Control: Editbox (age, integer)

---

### Alcohol - 11 questions

1. ALCO-INT: "Now, some questions about ...(r/'s) alcohol consumption. When we use the word drink it means: one bottle or can of beer or a glass of draft / one glass of wine or a wine cooler / one straight or mixed drink with one and a half ounces of hard liquor." - Control: Interviewer introduction (no response)

2. ALCO-Q1 / ALC4_1: "During the past 12 months, have/has ... had a drink of beer, wine, liquor or any other alcoholic beverage?" - Control: Radio - 1=Yes, 2=No --> GO TO ALCO-Q5B, DK/R --> GO TO Physical Activities section

3. ALCO-Q2 / ALC4_2: "During the past 12 months, how often did you/he/she drink alcoholic beverages?" - Control: Radio (do not read list, mark one only) - 1=Every day, 2=4-6 times a week, 3=2-3 times a week, 4=Once a week, 5=2-3 times a month, 6=Once a month, 7=Less than once a month

4. ALCO-Q3 / ALC4_3: "How many times in the past 12 months have/has you/he/she had 5 or more drinks on one occasion?" - Control: Editbox (number of times)

5. CHECK ALCO-PROXY: "If PROXY=yes then go to ALCO-Q5." - Check/Filter — proxy respondent --> skip ALCO-Q4

6. ALCO-Q4 / ALC4_4: "In the past 12 months, what is the highest number of drinks you had on one occasion?" - Control: Editbox (number of drinks); Note: Non-proxy only

7. ALCO-Q5 / ALC4_5: "Thinking back over the past week, that is, from %1WKAGO% to yesterday, did ... have a drink of beer, wine, liquor or any other alcoholic beverage?" - Control: Radio - 1=Yes, 2=No --> GO TO Physical Activities section, DK/R --> GO TO Physical Activities section

8. ALCO-Q5A / ALC4_5A1-ALC4_5A7: "Starting with yesterday, how many drinks did ... have on: Monday? / Tuesday? / Wednesday? / Thursday? / Friday? / Saturday? / Sunday?" - Control: Editbox (one per day, 7 variables) - Number of drinks per day; R on first day --> GO TO Physical Activities section --> GO TO Physical Activities section after Sunday

9. ALCO-Q5B / ALC4_5B: "Did you/he/she ever have a drink?" - Control: Radio - 1=Yes, 2=No --> GO TO Physical Activities section, DK/R --> GO TO Physical Activities section

10. ALCO-Q6 / ALC4_6: "Did you/he/she ever regularly drink more than 12 drinks a week?" - Control: Radio - 1=Yes, 2=No --> GO TO Physical Activities section, DK/R --> GO TO Physical Activities section

11. ALCO-Q7 / ALC4_7A-ALC4_7M: "Why did you/he/she reduce or quit drinking altogether?" - Control: Checkbox (do not read list, mark all that apply) - ALC4_7A=Dieting, ALC4_7B=Athletic training, ALC4_7C=Pregnancy, ALC4_7D=Getting older, ALC4_7E=Drinking too much/drinking problem, ALC4_7F=Affected work/studies/employment, ALC4_7G=Interfered with family/home life, ALC4_7H=Affected physical health, ALC4_7I=Affected friendships/social relationships, ALC4_7J=Affected financial position, ALC4_7K=Affected outlook on life/happiness, ALC4_7L=Influence of family/friends, ALC4_7M=Other (specify)

---

### Physical Activities - 10 questions

*Non-proxy only*

1. PHYS-INTa: "Now I'd like to ask you about some of your physical activities. To begin with, I'll be dealing with physical activities not related to work, that is, leisure time activities." - Control: Interviewer introduction (no response)

2. PHYS-Q1 / PAC4_1A-PAC4_1X, PAC4_1V: "Have you done any of the following in the past 3 months?" - Control: Checkbox (read list, mark all that apply) - PAC4_1A=Walking for exercise, PAC4_1B=Gardening/yard work, PAC4_1C=Swimming, PAC4_1D=Bicycling, PAC4_1E=Popular or social dance, PAC4_1F=Home exercises, PAC4_1G=Ice hockey, PAC4_1H=Skating, PAC4_1I=Downhill skiing, PAC4_1J=Jogging/running, PAC4_1K=Golfing, PAC4_1L=Exercise class/aerobics, PAC4_1M=Cross-country skiing, PAC4_1N=Bowling, PAC4_1O=Baseball/softball, PAC4_1P=Tennis, PAC4_1Q=Weight-training, PAC4_1R=Fishing, PAC4_1S=Volleyball, PAC4_1Z=Yoga/tai-chi, PAC4_1U/PAC4_1W/PAC4_1X=Other (specify), PAC4_1V=None --> GO TO PHYS-INTb, DK/R --> GO TO Injuries section; Note: For each activity selected, ask PHYS-Q2 and PHYS-Q3

3. PHYS-Q2 / PAC4_2n: "In the past 3 months, how many times did you participate in %ACTIVITY%?" - Control: Editbox (number of times); DK/R --> GO TO next activity

4. PHYS-Q3 / PAC4_3n: "About how much time did you usually spend on each occasion?" - Control: Radio (do not read list, mark one only) - 1=1 to 15 minutes, 2=16 to 30 minutes, 3=31 to 60 minutes, 4=More than one hour; Note: Repeat for each selected activity

5. PHYS-INTb: "Next, some questions about the amount of time you spent in the past 3 months on physical activity at work or while doing daily chores around the house, but not leisure time activity." - Control: Interviewer transition (no response)

6. PHYS-Q4a / PAC4_4A: "In a typical week in the past 3 months, how many hours did you usually spend walking to work or to school or while doing errands?" - Control: Radio (do not read list, mark one only) - 1=None, 2=Less than 1 hour, 3=From 1 to 5 hours, 4=From 6 to 10 hours, 5=From 11 to 20 hours, 6=More than 20 hours

7. PHYS-Q4b / PAC4_4B: "In a typical week, how much time did you usually spend bicycling to work or to school or while doing errands?" - Control: Radio (do not read list, mark one only) - 1=None, 2=Less than 1 hour, 3=From 1 to 5 hours, 4=From 6 to 10 hours, 5=From 11 to 20 hours, 6=More than 20 hours

8. PHYS-C1: Check/Filter — "If Bicycling was indicated in PHYS-Q1 or PHYS-Q4b != None --> ask PHYS-Q5; else --> GO TO PHYS-Q6"

9. PHYS-Q5 / PAC4_5: "When riding a bicycle how often did you wear a helmet?" - Control: Radio (read list, mark one only) - 1=Always, 2=Most of the time, 3=Rarely, 4=Never

10. PHYS-Q6 / PAC4_6: "Thinking back over the past 3 months, which of the following best describes your usual daily activities or work habits?" - Control: Radio (read list, mark one only) - 1=Usually sit during day and do not walk about very much, 2=Stand or walk about quite a lot but do not carry or lift things often, 3=Usually lift or carry light loads or climb stairs/hills often, 4=Do heavy work or carry very heavy loads

---

### Injuries - 9 questions

1. INJ-INT: "Now some questions about any injuries, which occurred in the past 12 months, that were serious enough to limit ...(r/'s) normal activities. For example, a broken bone, a bad cut or burn, a sore back or sprained ankle, or a poisoning." - Control: Interviewer introduction (no response)

2. INJ-Q1 / IJC4_1: "In the past 12 months, did ... have any injuries that were serious enough to limit your/his/her normal activities?" - Control: Radio - Yes, No --> GO TO Stress section, DK/R --> GO TO Stress section

3. INJ-Q2 / IJC4_2: "How many times were/was you/he/she injured?" - Control: Editbox (numeric count); DK/R --> GO TO Stress section

4. INJ-Q3 / IJC4_3: "Thinking about the most serious injury, what type of injury did you/he/she have?" - Control: Radio (do not read list, mark one only) - Multiple injuries, Broken or fractured bones, Burn or scald, Dislocation, Sprain or strain, Cut or scrape, Bruise or abrasion, Concussion, Poisoning by substance or liquid, Internal injury, Other (specify)

5. INJ-Q4 / IJC4_4: "What part of your/his/her body was injured?" - Control: Radio (do not read list, mark one only) - Multiple sites, Eyes, Head (excluding eyes), Neck, Shoulder, Arms or hands, Hip, Legs or feet, Back or spine, Trunk (excluding back or spine)

6. INJ-Q5 / IJC4_5: "Where did the injury happen?" - Control: Radio (do not read list, mark one only) - Home and surrounding area, Farm, Place for recreation or sport, Street or highway, Building used by general public, Residential institution, Mine, Industrial place or premise, Other (specify)

7. INJ-Q6 / IJC4_6: "What happened? For example, was the injury the result of a fall, motor vehicle accident, a physical assault etc.?" - Control: Radio (do not read list, mark one only) - Motor vehicle accident, Accidental fall, Fire/flames/resulting fumes, Accidentally struck by object/person, Physical assault, Suicide attempt, Accidental injury caused by explosion, Accidental injury caused by natural/environmental factors, Accidental drowning or submersion, Accidental suffocation, Hot or corrosive liquids/foods/substances, Accident caused by machinery, Accident caused by cutting/piercing instruments, Accidental poisoning, Other (specify)

8. INJ-Q7 / IJC4_7: "Was this a work-related injury?" - Control: Radio - Yes, No

9. INJ-Q8 / IJC4_8A-IJC4_8G: "What precautions are/is you/he/she taking to prevent this kind of injury from happening again?" - Control: Checkbox (do not read list, mark all that apply) - IJC4_8A: Gave up the activity, IJC4_8B: Being more careful, IJC4_8C: Took safety training, IJC4_8H: Increased supervision of child, IJC4_8D: Using protective gear/safety equipment, IJC4_8E: Changing physical situation, IJC4_8F: Other (specify), IJC4_8G: No precautions

---

### Stress - 44 questions

*Age >= 18 and non-proxy only*

**Ongoing Problems**

1. STRESS-INT: "The next portion of the questionnaire deals with different kinds of stress. Although the questions may seem repetitive, they are related to various aspects of a person's physical, emotional and mental health." - Control: Interviewer introduction (no response)

2. CSTRESS-INT: "I'll start by describing situations that sometimes come up in people's lives. I'd like you to tell me if these things are true for you at this time by answering 'true' if it applies to you now or 'false' if it does not." - Control: Interviewer introduction (no response)

3. CSTRESS-Q1 / ST_4_C1: "You are trying to take on too many things at once." - Control: Radio - True, False; R --> GO TO next section

4. CSTRESS-Q2 / ST_4_C2: "There is too much pressure on you to be like other people." - Control: Radio - True, False

5. CSTRESS-Q3 / ST_4_C3: "Too much is expected of you by others." - Control: Radio - True, False

6. CSTRESS-Q4 / ST_4_C4: "You don't have enough money to buy the things you need." - Control: Radio - True, False

7. CHECK CSTRESS-MARITAL: Check/Filter — "If marital status = married/living with partner/common-law --> GO TO CSTRESS-Q5. If single/widowed/separated/divorced --> GO TO CSTRESS-Q8. If unknown --> GO TO CSTRESS-Q9."

8. CSTRESS-Q5 / ST_4_C5: "Your partner doesn't understand you." - Control: Radio - True, False

9. CSTRESS-Q6 / ST_4_C6: "Your partner doesn't show enough affection." - Control: Radio - True, False

10. CSTRESS-Q7 / ST_4_C7: "Your partner is not committed enough to your relationship." - Control: Radio - True, False --> GO TO CSTRESS-Q9

11. CSTRESS-Q8 / ST_4_C8: "You find it is very difficult to find someone compatible with you." - Control: Radio - True, False

12. CSTRESS-Q9 / ST_4_C9: "Do you have any children?" - Control: Radio - Yes, No --> GO TO CSTRESS-Q12, DK/R --> GO TO CSTRESS-Q12

13. CSTRESS-Q10 / ST_4_C10: "One of your children seems very unhappy." - Control: Radio - True, False

14. CSTRESS-Q11 / ST_4_C11: "A child's behaviour is a source of serious concern to you." - Control: Radio - True, False

15. CSTRESS-Q12 / ST_4_C12: "Your work around the home is not appreciated." - Control: Radio - True, False

16. CSTRESS-Q13 / ST_4_C13: "Your friends are a bad influence." - Control: Radio - True, False

17. CSTRESS-Q14 / ST_4_C14: "You would like to move but you cannot." - Control: Radio - True, False

18. CSTRESS-Q15 / ST_4_C15: "Your neighbourhood or community is too noisy or too polluted." - Control: Radio - True, False

19. CSTRESS-Q16 / ST_4_C16: "You have a parent, a child or partner who is in very bad health and may die." - Control: Radio - True, False

20. CSTRESS-Q17 / ST_4_C17: "Someone in your family has an alcohol or drug problem." - Control: Radio - True, False

21. CSTRESS-Q18 / ST_4_C18: "People are too critical of you or what you do." - Control: Radio - True, False

**Recent Life Events**

22. RECENT-INTa: "Now I'd like to ask you about some things that may have happened in the past 12 months. First, I'd like to ask about yourself or anyone close to you (spouse/partner, children, relatives or close friends)." - Control: Interviewer introduction (no response)

23. RECENT-Q1 / ST_4_R1: "In the past 12 months, was any one of you beaten up or physically attacked?" - Control: Radio - Yes, No; R --> GO TO next section

24. RECENT-INTb: "Now I'd like you to think just about your family (yourself and your spouse/partner or children, if any)." - Control: Interviewer instruction (no response)

25. RECENT-Q2 / ST_4_R2: "In the past 12 months, did you or someone in your family have an unwanted pregnancy?" - Control: Radio - Yes, No

26. RECENT-Q3 / ST_4_R3: "In the past 12 months, did you or someone in your family have an abortion or miscarriage?" - Control: Radio - Yes, No

27. RECENT-Q4 / ST_4_R4: "In the past 12 months, did you or someone in your family have a major financial crisis?" - Control: Radio - Yes, No

28. RECENT-Q5 / ST_4_R5: "In the past 12 months, did you or someone in your family fail school or a training program?" - Control: Radio - Yes, No

29. RECENT-INTc: "Now I'd like you to think just about yourself and your spouse or partner." - Control: Interviewer instruction (no response)

30. RECENT-Q6 / ST_4_R6: "In the past 12 months, did you (or your partner) experience a change of job for a worse one?" - Control: Radio - Yes, No

31. RECENT-Q7 / ST_4_R7: "In the past 12 months, were you (or your partner) demoted at work or did you/either of you take a cut in pay?" - Control: Radio - Yes, No

32. CHECK RECENT-MARITAL: Check/Filter — "If marital status = married/living together/common-law --> ask RECENT-Q8; Otherwise --> GO TO RECENT-Q9"

33. RECENT-Q8 / ST_4_R8: "In the past 12 months, did you have increased arguments with your partner?" - Control: Radio - Yes, No

34. RECENT-Q9 / ST_4_R9: "Now, just you personally, in the past 12 months, did you go on Welfare?" - Control: Radio - Yes, No

35. CHECK RECENT-CHILDREN: Check/Filter — "If CSTRESS-Q9 = Yes (have children) --> ask RECENT-Q10; Otherwise --> GO TO Childhood Stressors"

36. RECENT-Q10 / ST_4_R10: "In the past 12 months, did you have a child move back into the house?" - Control: Radio - Yes, No

**Childhood and Adult Stressors ("traumas")**

37. TRAUM-INTa: "The next few questions ask about some things that may have happened to you while you were a child or a teenager, before you moved out of the house." - Control: Interviewer introduction (no response)

38. TRAUM-Q1 / ST_4_T1: "Did you spend 2 weeks or more in the hospital?" - Control: Radio - Yes, No; R --> GO TO Work Stress section

39. TRAUM-Q2 / ST_4_T2: "Did your parents get a divorce?" - Control: Radio - Yes, No

40. TRAUM-Q3 / ST_4_T3: "Did your father or mother not have a job for a long time when they wanted to be working?" - Control: Radio - Yes, No

41. TRAUM-Q4 / ST_4_T4: "Did something happen that scared you so much you thought about it for years after?" - Control: Radio - Yes, No

42. TRAUM-Q5 / ST_4_T5: "Were you sent away from home because you did something wrong?" - Control: Radio - Yes, No

43. TRAUM-Q6 / ST_4_T6: "Did either of your parents drink or use drugs so often that it caused problems for the family?" - Control: Radio - Yes, No

44. TRAUM-Q7 / ST_4_T7: "Were you ever physically abused by someone close to you?" - Control: Radio - Yes, No

---

### Work Stress - 3 questions

*Age >= 15, non-proxy only; ask only of those currently employed; if more than one job, ask for the main job*

1. CHECK WSTRESS-EMPLOYED: Check/Filter — "Ask only of those currently employed. If more than one job, ask for the main job."

2. WSTRESS-Q1 / ST_4_W1A-ST_4_W1L: "Now I'm going to read you a series of statements that might describe your job situation. Please tell me if you STRONGLY AGREE, AGREE, NEITHER AGREE NOR DISAGREE, DISAGREE, or STRONGLY DISAGREE with each of the following:" - Control: Radio scale (5-point Likert) for each sub-item:
   - a) ST_4_W1A: Your job requires that you learn new things — R on first item --> GO TO Self-Esteem section
   - b) ST_4_W1B: Your job requires a high level of skill
   - c) ST_4_W1C: Your job allows you freedom to decide how you do your job
   - d) ST_4_W1D: Your job requires that you do things over and over
   - e) ST_4_W1E: Your job is very hectic
   - f) ST_4_W1F: You are free from conflicting demands that others make
   - g) ST_4_W1G: Your job security is good
   - h) ST_4_W1H: Your job requires a lot of physical effort
   - i) ST_4_W1I: You have a lot to say about what happens in your job
   - j) ST_4_W1J: You are exposed to hostility or conflict from the people you work with
   - k) ST_4_W1K: Your supervisor is helpful in getting the job done
   - l) ST_4_W1L: The people you work with are helpful in getting the job done

3. WSTRESS-Q2 / ST_4_W2: "How satisfied are you with your job?" - Control: Radio (read list, mark one only) - Very satisfied, Somewhat satisfied, Not too satisfied, Not at all satisfied

---

### Self-Esteem and Mastery - 2 questions

*Age >= 12 and non-proxy only*

1. ESTEEM-Q1 / PY_4_E1A-PY_4_E1F: "Now, I am going to read you a series of statements that people might use to describe themselves. Please tell me if you STRONGLY AGREE, AGREE, NEITHER AGREE NOR DISAGREE, DISAGREE or STRONGLY DISAGREE with each of the following:" - Control: Radio scale (5-point Likert) for each sub-item:
   - a) PY_4_E1A: You feel that you have a number of good qualities — R on first item --> GO TO Sense of Coherence section
   - b) PY_4_E1B: You feel that you're a person of worth at least equal to others
   - c) PY_4_E1C: You are able to do things as well as most other people
   - d) PY_4_E1D: You take a positive attitude toward yourself
   - e) PY_4_E1E: On the whole you are satisfied with yourself
   - f) PY_4_E1F: All in all, you're inclined to feel you're a failure

2. MAST-Q1 / PY_4_M1A-PY_4_M1G: "Please tell me if you STRONGLY AGREE, AGREE, NEITHER AGREE NOR DISAGREE, DISAGREE or STRONGLY DISAGREE:" - Control: Radio scale (5-point Likert) for each sub-item:
   - a) PY_4_M1A: You have little control over the things that happen to you — R on first item --> GO TO Sense of Coherence section
   - b) PY_4_M1B: There is really no way you can solve some of the problems you have
   - c) PY_4_M1C: There is little you can do to change many of the important things in your life
   - d) PY_4_M1D: You often feel helpless in dealing with problems of life
   - e) PY_4_M1E: Sometimes you feel that you are being pushed around in life
   - f) PY_4_M1F: What happens to you in the future mostly depends on you
   - g) PY_4_M1G: You can do just about anything you really set your mind to

---

### Sense of Coherence - 14 questions

*Age >= 18 and non-proxy only*

1. SCOH-INT: "Next is a series of questions relating to various aspects of people's lives. For each question please answer with a number between 1 and 7." - Control: Interviewer instruction (no response)

2. SCOH-Q1 / PY_4_H1: "How often do you have the feeling that you don't really care about what goes on around you?" - Control: Radio (7-point scale) - 1=Very seldom or never, 7=Very often; DK/R --> GO TO Health Status section

3. SCOH-Q2 / PY_4_H2: "How often in the past were you surprised by the behaviour of people whom you thought you knew well?" - Control: Radio (7-point scale) - 1=Never happened, 7=Always happened

4. SCOH-Q3 / PY_4_H3: "How often have people you counted on disappointed you?" - Control: Radio (7-point scale) - 1=Never happened, 7=Always happened

5. SCOH-Q4 / PY_4_H4: "How often do you have the feeling you're being treated unfairly?" - Control: Radio (7-point scale) - 1=Very often, 7=Very seldom or never

6. SCOH-Q5 / PY_4_H5: "How often do you have the feeling you are in an unfamiliar situation and don't know what to do?" - Control: Radio (7-point scale) - 1=Very often, 7=Very seldom or never

7. SCOH-Q6 / PY_4_H6: "How often do you have very mixed-up feelings and ideas?" - Control: Radio (7-point scale) - 1=Very often, 7=Very seldom or never

8. SCOH-Q7 / PY_4_H7: "How often do you have feelings inside that you would rather not feel?" - Control: Radio (7-point scale) - 1=Very often, 7=Very seldom or never

9. SCOH-Q8 / PY_4_H8: "Many people -- even those with a strong character -- sometimes feel like sad sacks (losers) in certain situations. How often have you felt this way in the past?" - Control: Radio (7-point scale) - 1=Very seldom or never, 7=Very often

10. SCOH-Q9 / PY_4_H9: "How often do you have the feeling that there's little meaning in the things you do in your daily life?" - Control: Radio (7-point scale) - 1=Very often, 7=Very seldom or never

11. SCOH-Q10 / PY_4_H10: "How often do you have feelings that you're not sure you can keep under control?" - Control: Radio (7-point scale) - 1=Very often, 7=Very seldom or never

12. SCOH-Q11 / PY_4_H11: "Until now your life has had no clear goals or purpose or has it had very clear goals and purpose?" - Control: Radio (7-point scale) - 1=No clear goals or no purpose at all, 7=Very clear goals and purpose

13. SCOH-Q12 / PY_4_H12: "When something happens, you generally find that you overestimate or underestimate its importance or you see things in the right proportion?" - Control: Radio (7-point scale) - 1=Overestimate or underestimate, 7=See things in the right proportion

14. SCOH-Q13 / PY_4_H13: "Is doing the things you do every day a source of great pleasure and satisfaction or a source of pain and boredom?" - Control: Radio (7-point scale) - 1=A great deal of pleasure and satisfaction, 7=A source of pain and boredom

---

### Health Status - 31 questions

1. HSTAT-INT: "The next set of questions ask about ...(r/'s) day to day health. The questions are not about illnesses like colds that affect people for short periods of time. They are concerned with a person's usual abilities." - Control: Interviewer instruction (no response)

**Vision**

2. HSTAT-Q1 / HSC4_1: "Are/Is ... usually able to see well enough to read ordinary newsprint without glasses or contact lenses?" - Control: Radio - Yes --> GO TO HSTAT-Q4, No, DK/R --> GO TO HSTAT-Q6

3. HSTAT-Q2 / HSC4_2: "Are/Is you/he/she usually able to see well enough to read ordinary newsprint with glasses or contact lenses?" - Control: Radio - Yes --> GO TO HSTAT-Q4, No

4. HSTAT-Q3 / HSC4_3: "Are/Is you/he/she able to see at all?" - Control: Radio - Yes, No --> GO TO HSTAT-Q6, DK/R --> GO TO HSTAT-Q6

5. HSTAT-Q4 / HSC4_4: "Are/Is you/he/she able to see well enough to recognize a friend on the other side of the street without glasses or contact lenses?" - Control: Radio - Yes --> GO TO HSTAT-Q6, No, DK/R --> GO TO HSTAT-Q6

6. HSTAT-Q5 / HSC4_5: "Are/Is you/he/she usually able to see well enough to recognize a friend on the other side of the street with glasses or contact lenses?" - Control: Radio - Yes, No

**Hearing**

7. HSTAT-Q6 / HSC4_6: "Are/Is ... usually able to hear what is said in a group conversation with at least three other people without a hearing aid?" - Control: Radio - Yes --> GO TO HSTAT-Q10, No, DK/R --> GO TO HSTAT-Q10

8. HSTAT-Q7 / HSC4_7: "Are/Is you/he/she usually able to hear what is said in a group conversation with at least three other people with a hearing aid?" - Control: Radio - Yes --> GO TO HSTAT-Q8, No

9. HSTAT-Q7a / HSC4_7A: "Are/Is you/he/she able to hear at all?" - Control: Radio - Yes, No --> GO TO HSTAT-Q10, DK/R --> GO TO HSTAT-Q10

10. HSTAT-Q8 / HSC4_8: "Are/Is you/he/she usually able to hear what is said in a conversation with one other person in a quiet room without a hearing aid?" - Control: Radio - Yes --> GO TO HSTAT-Q10, No, R --> GO TO HSTAT-Q10

11. HSTAT-Q9 / HSC4_9: "Are/Is you/he/she usually able to hear what is said in a conversation with one other person in a quiet room with a hearing aid?" - Control: Radio - Yes, No

**Speech**

12. HSTAT-Q10 / HSC4_10: "Are/Is ... usually able to be understood completely when speaking with strangers in your own language?" - Control: Radio - Yes --> GO TO HSTAT-Q14, No, R --> GO TO HSTAT-Q14

13. HSTAT-Q11 / HSC4_11: "Are/Is you/he/she able to be understood partially when speaking with strangers?" - Control: Radio - Yes, No

14. HSTAT-Q12 / HSC4_12: "Are/Is you/he/she able to be understood completely when speaking with those who know you/him/her well?" - Control: Radio - Yes --> GO TO HSTAT-Q14, No, R --> GO TO HSTAT-Q14

15. HSTAT-Q13 / HSC4_13: "Are/Is you/he/she able to be understood partially when speaking with those who know you/him/her well?" - Control: Radio - Yes, No

**Getting Around**

16. HSTAT-Q14 / HSC4_14: "Are/Is ... usually able to walk around the neighbourhood without difficulty and without mechanical support?" - Control: Radio - Yes --> GO TO HSTAT-Q21, No, DK/R --> GO TO HSTAT-Q21

17. HSTAT-Q15 / HSC4_15: "Are/Is you/he/she able to walk at all?" - Control: Radio - Yes, No --> GO TO HSTAT-Q18, DK/R --> GO TO HSTAT-Q18

18. HSTAT-Q16 / HSC4_16: "Do/Does you/he/she require mechanical support such as braces, a cane or crutches to be able to walk around the neighbourhood?" - Control: Radio - Yes, No

19. HSTAT-Q17 / HSC4_17: "Do/Does you/he/she require the help of another person to be able to walk?" - Control: Radio - Yes, No

20. HSTAT-Q18 / HSC4_18: "Do/Does you/he/she require a wheelchair to get around?" - Control: Radio - Yes, No --> GO TO HSTAT-Q21, DK/R --> GO TO HSTAT-Q21

21. HSTAT-Q19 / HSC4_19: "How often do/does you/he/she use a wheelchair?" - Control: Radio (read list, mark one) - Always, Often, Sometimes, Never

22. HSTAT-Q20 / HSC4_20: "Do/Does you/he/she need the help of another person to get around in the wheelchair?" - Control: Radio - Yes, No

**Hands and Fingers**

23. HSTAT-Q21 / HSC4_21: "Are/Is ... usually able to grasp and handle small objects such as a pencil and scissors?" - Control: Radio - Yes --> GO TO HSTAT-Q25, No, DK/R --> GO TO HSTAT-Q25

24. HSTAT-Q22 / HSC4_22: "Do/Does you/he/she require the help of another person because of limitations in the use of hands or fingers?" - Control: Radio - Yes, No --> GO TO HSTAT-Q24, DK/R --> GO TO HSTAT-Q24

25. HSTAT-Q23 / HSC4_23: "Do/Does you/he/she require the help of another person with:" - Control: Radio (read list, mark one) - Some tasks, Most tasks, Almost all tasks, All tasks

26. HSTAT-Q24 / HSC4_24: "Do/Does you/he/she require special equipment because of limitations in the use of hands or fingers?" - Control: Radio - Yes, No

**Feelings**

27. HSTAT-Q25 / HSC4_25: "Would you describe yourself/... as being usually:" - Control: Radio (read list, mark one) - Happy and interested in life, Somewhat happy, Somewhat unhappy, Unhappy with little interest in life, So unhappy that life is not worthwhile

**Memory**

28. HSTAT-Q26 / HSC4_26: "How would you describe your/his/her usual ability to remember things?" - Control: Radio (read list, mark one) - Able to remember most things, Somewhat forgetful, Very forgetful, Unable to remember anything at all

**Thinking**

29. HSTAT-Q27 / HSC4_27: "How would you describe your/his/her usual ability to think and solve day to day problems?" - Control: Radio (read list, mark one) - Able to think clearly and solve problems, Having a little difficulty, Having some difficulty, Having a great deal of difficulty, Unable to think or solve problems

**Pain and Discomfort**

30. HSTAT-Q28 / HSC4_28: "Are/Is ... usually free of pain or discomfort?" - Control: Radio - Yes --> GO TO Drug Use section, No, DK/R --> GO TO Drug Use section

31. HSTAT-Q29 / HSC4_29: "How would you describe the usual intensity of your/his/her pain or discomfort?" - Control: Radio (read list, mark one) - Mild, Moderate, Severe

32. HSTAT-Q30 / HSC4_30: "How many activities does your/his/her pain or discomfort prevent?" - Control: Radio (read list, mark one) - None, A few, Some, Most

---

### Drug Use - 7 questions

1. DRUG-INT: "Now I'd like to ask a few questions about ...(r/'s) use of medications, both prescription and over-the-counter as well as other health products." - Control: Interviewer introduction (no response)

2. DRUG-Q1 / DGC4_1A-DGC4_1V, DGC4_NON: "In the past month, did ... take any of the following medications? (Read list. Mark all that apply.)" - Control: Checkbox (mark all that apply):
   - DGC4_1A: Pain relievers (aspirin, tylenol, anti-inflammatories)
   - DGC4_1B: Tranquilizers (valium)
   - DGC4_1C: Diet pills
   - DGC4_1D: Anti-depressants
   - DGC4_1E: Codeine, Demerol or Morphine
   - DGC4_1F: Allergy medicine (Sinutab)
   - DGC4_1G: Asthma medications
   - DGC4_1H: Cough or cold remedies
   - DGC4_1I: Penicillin or other antibiotic
   - DGC4_1J: Medicine for the heart
   - DGC4_1K: Medicine for blood pressure
   - DGC4_1L: Diuretics or water pills
   - DGC4_1M: Steroids
   - DGC4_1N: Insulin
   - DGC4_1O: Pills to control diabetes
   - DGC4_1P: Sleeping pills
   - DGC4_1Q: Stomach remedies
   - DGC4_1R: Laxatives
   - DGC4_1T: Hormones for menopause or aging symptoms (sex=female, age >= 30)
   - DGC4_1S: Birth control pills (sex=female, age >= 12 & age <= 49)
   - DGC4_1V: Any other medication (Specify)
   - DGC4_NON: None of the above

3. DRUG-C1: Check/Filter — "If any drug(s) specified in DRUG-Q1 go to DRUG-Q2. Otherwise go to DRUG-Q4."

4. DRUG-Q2 / DGC4_2: "Now, I am referring to yesterday and the day before yesterday. During those two days, how many different medications did you/he/she take?" - Control: Editbox (integer count); DK/R --> GO TO DRUG-Q4; If 0 --> GO TO DRUG-Q4; For each > 0 ask DRUG-Q3 (up to 12)

5. DRUG-Q3 / DGC4_3nC: "What is the exact name of the medication that ... took? (Ask the person to look at the bottle, tube or box.)" - Control: Open text (up to 12 iterations); DK/R to any --> GO TO Mental Health section

6. DRUG-Q4 / DGC4_4: "There are many other health products such as ointments, vitamins, herbs, minerals, teas or protein drinks which people use to prevent illness or to improve or maintain their health. Do/Does ... use any of these or other health products?" - Control: Radio - Yes, No --> GO TO Mental Health section, DK/R --> GO TO Mental Health section

7. DRUG-Q5 / DGC4_5nn: "What is the exact name of the health product that ... use(s)? (Ask the person to look at the bottle, tube or box.)" - Control: Open text (up to 12 products)

---

### Mental Health - 43 questions

*Non-proxy only*

1. MHLTH-INTa: "Now some questions about mental and emotional well-being. During the past month, about how often did you feel:" - Control: Interviewer introduction (no response)

2. MHLTH-Q1a / MHC4_1A: "... so sad that nothing could cheer you up?" - Control: Radio (read list, mark one) - 1=All of the time, 2=Most of the time, 3=Some of the time, 4=A little of the time, 5=None of the time; DK/R --> GO TO MHLTH-Q1k

3. MHLTH-Q1b / MHC4_1B: "... nervous?" - Control: Radio (read list, mark one) - 1=All of the time, 2=Most of the time, 3=Some of the time, 4=A little of the time, 5=None of the time; DK/R --> GO TO MHLTH-Q1k

4. MHLTH-Q1c / MHC4_1C: "... restless or fidgety?" - Control: Radio (read list, mark one) - 1=All of the time, 2=Most of the time, 3=Some of the time, 4=A little of the time, 5=None of the time; DK/R --> GO TO MHLTH-Q1k

5. MHLTH-Q1d / MHC4_1D: "... hopeless?" - Control: Radio (read list, mark one) - 1=All of the time, 2=Most of the time, 3=Some of the time, 4=A little of the time, 5=None of the time; DK/R --> GO TO MHLTH-Q1k

6. MHLTH-Q1e / MHC4_1E: "... worthless?" - Control: Radio (read list, mark one) - 1=All of the time, 2=Most of the time, 3=Some of the time, 4=A little of the time, 5=None of the time; DK/R --> GO TO MHLTH-Q1k

7. MHLTH-Q1f / MHC4_1F: "During the past month, about how often did you feel that everything was an effort?" - Control: Radio (read list, mark one) - 1=All of the time, 2=Most of the time, 3=Some of the time, 4=A little of the time, 5=None of the time; DK/R --> GO TO MHLTH-Q1k

8. MHLTH-C1g: Check/Filter — "IF MHLTH-Q1a to MHLTH-Q1f are all 'none' go to MHLTH-Q1k."

9. MHLTH-Q1g / MHC4_1G: "Taking them altogether, did these feelings occur more often in the past month than is usual for you, less often than usual, or about the same as usual?" - Control: Radio (do not read list, mark one) - 1=More often, 2=Less often --> GO TO MHLTH-Q1i, 3=About the same --> GO TO MHLTH-Q1j, 4=Never have had any --> GO TO MHLTH-Q1k, DK/R --> GO TO MHLTH-Q1k

10. MHLTH-Q1h / MHC4_1H: "Is that a lot more, somewhat or only a little more often than usual?" - Control: Radio (do not read list, mark one) - 1=A lot more, 2=Somewhat more, 3=A little more; DK/R --> GO TO MHLTH-Q1k; All --> GO TO MHLTH-Q1j

11. MHLTH-Q1i / MHC4_1I: "Is that a lot less, somewhat or only a little less often than usual?" - Control: Radio (do not read list, mark one) - 1=A lot less, 2=Somewhat less, 3=A little less; DK/R --> GO TO MHLTH-Q1k

12. MHLTH-Q1j / MHC4_1J: "How much do these experiences usually interfere with your life or activities?" - Control: Radio (read list, mark one) - 1=A lot, 2=Some, 3=A little, 4=Not at all

13. MHLTH-Q1k / MHC4_1K: "In the past 12 months, have you seen or talked on the telephone to a health professional about your emotional or mental health?" - Control: Radio - Yes, No --> GO TO MHLTH-Q2, DK/R --> GO TO MHLTH-Q2

14. MHLTH-Q1l / MHC4_1L: "How many times (in the past 12 months)?" - Control: Editbox (integer count)

**Depression pathway (sad/blue)**

15. MHLTH-Q2 / MHC4_2: "During the past 12 months, was there ever a time when you felt sad, blue, or depressed for 2 weeks or more in a row?" - Control: Radio - Yes, No --> GO TO MHLTH-Q16, DK/R --> GO TO Social Support section

16. MHLTH-Q3 / MHC4_3: "For the next few questions, please think of the 2-week period during the past 12 months when these feelings were worst. During that time how long did these feelings usually last?" - Control: Radio (read list, mark one) - 1=All day long, 2=Most of the day, 3=About half of the day --> GO TO MHLTH-Q16, 4=Less than half the day --> GO TO MHLTH-Q16; DK/R --> GO TO Social Support section

17. MHLTH-Q4 / MHC4_4: "How often did you feel this way during those 2 weeks?" - Control: Radio (read list, mark one) - 1=Every day, 2=Almost every day, 3=Less often --> GO TO MHLTH-Q16; DK/R --> GO TO Social Support section

18. MHLTH-Q5 / MHC4_5: "During those 2 weeks did you lose interest in most things?" - Control: Radio - Yes (KEY PHRASE = LOSING INTEREST), No; DK/R --> GO TO Social Support section

19. MHLTH-Q6 / MHC4_6: "Did you feel tired out or low on energy all of the time?" - Control: Radio - Yes (KEY PHRASE = FEELING TIRED), No; DK/R --> GO TO Social Support section

20. MHLTH-Q7 / MHC4_7: "Did you gain weight, lose weight or stay about the same?" - Control: Radio (do not read list, mark one) - 1=Gained weight (KEY PHRASE = GAINING WEIGHT), 2=Lost weight (KEY PHRASE = LOSING WEIGHT), 3=Stayed about the same --> GO TO MHLTH-Q9, 4=Was on a diet --> GO TO MHLTH-Q9; DK/R --> GO TO Social Support section

21. MHLTH-Q8 / MHC4_8LB / MHC4_8KG: "About how much did you (gain/lose)?" - Control: Editbox (pounds or kilograms)

22. MHLTH-Q9 / MHC4_9: "Did you have more trouble falling asleep than you usually do?" - Control: Radio - Yes (KEY PHRASE = TROUBLE FALLING ASLEEP), No --> GO TO MHLTH-Q11; DK/R --> GO TO Social Support section

23. MHLTH-Q10 / MHC4_10: "How often did that happen?" - Control: Radio (read list, mark one) - 1=Every night, 2=Nearly every night, 3=Less often; DK/R --> GO TO Social Support section

24. MHLTH-Q11 / MHC4_11: "Did you have a lot more trouble concentrating than usual?" - Control: Radio - Yes (KEY PHRASE = TROUBLE CONCENTRATING), No; DK/R --> GO TO Social Support section

25. MHLTH-Q12 / MHC4_12: "At these times, people sometimes feel down on themselves, no good, or worthless. Did you feel this way?" - Control: Radio - Yes (KEY PHRASE = FEELING DOWN ON YOURSELF), No; DK/R --> GO TO Social Support section

26. MHLTH-Q13 / MHC4_13: "Did you think a lot about death - either your own, someone else's, or death in general?" - Control: Radio - Yes (KEY PHRASE = THOUGHTS ABOUT DEATH), No; DK/R --> GO TO Social Support section

27. MHLTH-C14: Check/Filter — "If any 'yes' in Q5, Q6, Q9, Q11, Q12 or Q13, or Q7 is 'gain' or 'lose' then go to MHLTH-Q14. Otherwise go to Social Support section."

28. MHLTH-Q14 / MHC4_14: "Reviewing what you just told me, you had 2 weeks in a row during the past 12 months when you were sad, blue, or depressed and also had some other things like (KEY PHRASES). About how many weeks altogether did you feel this way during the past 12 months?" - Control: Editbox (integer, weeks); If > 51 weeks --> GO TO Social Support section; DK/R --> GO TO Social Support section

29. MHLTH-Q15 / MHC4_15: "Think about the last time you felt this way for 2 weeks or more in a row. In what month was that?" - Control: Radio (month selection) - January through December --> GO TO Social Support section

**Loss of interest pathway**

30. MHLTH-Q16 / MHC4_16: "During the past 12 months, was there ever a time lasting 2 weeks or more when you lost interest in most things like hobbies, work, or activities that usually give you pleasure?" - Control: Radio - Yes, No --> GO TO Social Support section, DK/R --> GO TO Social Support section

31. MHLTH-Q17 / MHC4_17: "For the next few questions, please think of the 2-week period during the past 12 months when you had the most complete loss of interest in things. During that 2-week period, how long did the loss of interest usually last?" - Control: Radio (read list, mark one) - 1=All day long, 2=Most of the day, 3=About half of the day --> GO TO Social Support section, 4=Less than half the day --> GO TO Social Support section; DK/R --> GO TO Social Support section

32. MHLTH-Q18 / MHC4_18: "How often did you feel this way during those 2 weeks?" - Control: Radio (read list, mark one) - 1=Every day, 2=Almost every day, 3=Less often --> GO TO Social Support section; DK/R --> GO TO Social Support section

33. MHLTH-Q19 / MHC4_19: "During those 2 weeks did you feel tired out or low on energy all the time?" - Control: Radio - Yes (KEY PHRASE = FEELING TIRED), No; DK/R --> GO TO Social Support section

34. MHLTH-Q20 / MHC4_20: "Did you gain weight, lose weight, or stay about the same?" - Control: Radio (do not read list, mark one) - 1=Gained weight (KEY PHRASE = GAINING WEIGHT), 2=Lost weight (KEY PHRASE = LOSING WEIGHT), 3=Stayed about the same --> GO TO MHLTH-Q22, 4=Was on a diet --> GO TO MHLTH-Q22; DK/R --> GO TO Social Support section

35. MHLTH-Q21 / MHC4_21L / MHC4_21K: "About how much did you (gain/lose)?" - Control: Editbox (pounds or kilograms)

36. MHLTH-Q22 / MHC4_22: "Did you have more trouble falling asleep than you usually do?" - Control: Radio - Yes (KEY PHRASE = TROUBLE FALLING ASLEEP), No --> GO TO MHLTH-Q24; DK/R --> GO TO Social Support section

37. MHLTH-Q23 / MHC4_23: "How often did that happen during those 2 weeks?" - Control: Radio (read list, mark one) - 1=Every night, 2=Nearly every night, 3=Less often; DK/R --> GO TO Social Support section

38. MHLTH-Q24 / MHC4_24: "Did you have a lot more trouble concentrating than usual?" - Control: Radio - Yes (KEY PHRASE = TROUBLE CONCENTRATING), No; DK/R --> GO TO Social Support section

39. MHLTH-Q25 / MHC4_25: "At these times, people sometimes feel down on themselves, no good, or worthless. Did you feel this way?" - Control: Radio - Yes (KEY PHRASE = FEELING DOWN ON YOURSELF), No; DK/R --> GO TO Social Support section

40. MHLTH-Q26 / MHC4_26: "Did you think a lot about death - either your own, someone else's, or death in general?" - Control: Radio - Yes (KEY PHRASE = THOUGHTS ABOUT DEATH), No; DK/R --> GO TO Social Support section

41. MHLTH-C27: Check/Filter — "If any 'yes' in Q19, Q22, Q24, Q25 or Q26, or Q20 is 'gain' or 'lose' then go to MHLTH-Q27. Otherwise go to Social Support section."

42. MHLTH-Q27 / MHC4_27: "Reviewing what you just told me, you had 2 weeks in a row during the past 12 months when you lost interest in most things and also had some other things like (KEY PHRASES). About how many weeks did you feel this way during the past 12 months?" - Control: Editbox (integer, weeks); If > 51 weeks --> GO TO Social Support section; DK/R --> GO TO Social Support section

43. MHLTH-Q28 / MHC4_28: "Think about the last time you had 2 weeks in a row when you felt this way. In what month was that?" - Control: Radio (month selection) - January through December

---

### Social Support - 9 questions

*Non-proxy only*

1. SOCSUP-INT: "Now, a few questions about your contact with different groups and support from family and friends." - Control: Interviewer instruction (no response)

2. SOCSUP-Q1 / SSC4_1: "Are you a member of any voluntary organizations or associations such as school groups, church social groups, community centres, ethnic associations or social, civic or fraternal clubs?" - Control: Radio - Yes, No --> GO TO SOCSUP-Q2a, DK/R --> GO TO SOCSUP-Q2a

3. SOCSUP-Q2 / SSC4_2: "How often did you participate in meetings or activities sponsored by these groups in the past 12 months?" - Control: Radio (read list, mark one only) - 1=At least once a week, 2=At least once a month, 3=At least 3 or 4 times a year, 4=At least once a year, 5=Not at all

4. SOCSUP-Q2a / SSC4_2A: "Other than on special occasions (weddings, funerals, baptisms), how often did you attend religious services or religious meetings in the past 12 months?" - Control: Radio (read list, mark one only) - 1=At least once a week, 2=At least once a month, 3=At least 3 or 4 times a year, 4=At least once a year, 5=Not at all

5. SOCSUP-Q3 / SSC4_3: "Do you have someone you can confide in, or talk to about your private feelings or concerns?" - Control: Radio - Yes, No

6. SOCSUP-Q4 / SSC4_4: "Do you have someone you can really count on to help you out in a crisis situation?" - Control: Radio - Yes, No

7. SOCSUP-Q5 / SSC4_5: "Do you have someone you can really count on to give you advice when you are making important personal decisions?" - Control: Radio - Yes, No

8. SOCSUP-Q6 / SSC4_6: "Do you have someone that makes you feel loved and cared for?" - Control: Radio - Yes, No

9. SOCSUP-Q7 / SSC4_7A-7H: "The next few questions are about your contact in the past 12 months with persons who do not live with you. How often did you have contact with:" - Control: Grid/Radio (read list, mark one only) for each sub-item:
   - SSC4_7A: Your parents or parents-in-law
   - SSC4_7B: Your grandparents
   - SSC4_7C: Your daughters or daughters-in-law
   - SSC4_7D: Your sons or sons-in-law
   - SSC4_7E: Your brothers or sisters
   - SSC4_7F: Other relatives (including in-laws)
   - SSC4_7G: Your close friends
   - SSC4_7H: Your neighbours
   - Options: 1=Don't have any, 2=Every day, 3=At least once a week, 4=2 or 3 times a month, 5=Once a month, 6=A few times a year, 7=Once a year, 8=Never

---

### Health Number - 2 questions

1. H06-HLTH# / AM64_LNK: "We are seeking your permission to link information collected during this interview with provincial health information. Do we have your permission?" - Control: Radio - Yes, No --> GO TO Agreement to Share section, DK/R --> GO TO Agreement to Share section

2. H06-HLTH#1 / HNC4_nn: "What is your/his/her provincial health number?" - Control: Editbox (open text/number field)

---

### Agreement to Share - 5 questions

1. H06-SHARE / AM64_SHA: "To avoid duplication Statistics Canada intends to share the information from this survey with provincial ministries of health, Health Canada, and Employment and Immigration Canada. Do you agree to share the information you have provided?" - Control: Radio - Yes, No

2. H06-TEL / AM64_TEL: "Was this interview conducted on the telephone or in person?" - Control: Radio - On telephone, In person, Both (Specify reason)

3. H06-CTEXT / AM64_ALO: "Was the respondent alone when you asked this health questionnaire?" - Control: Radio - Yes --> GO TO H06-P2, No

4. H06-CTEXT1 / AM64_AFF: "Do you think that the answers of the respondent were affected by someone else being there?" - Control: Radio - Yes (Specify), No

5. H06-P2 / AM64_LNG: "Record language of interview" - Control: Radio - English, French, Arabic, Chinese, Cree, German, Greek, Hungarian, Italian, Korean, Persian (Farsi), Polish, Portuguese, Punjabi, Spanish, Tagalog (Filipino), Ukrainian, Vietnamese, Other (Specify)

---

### Manitoba Buy-in Questions - 16 questions

*Age >= 18 and non-proxy only*

1. SPR6-INTA: "The next questions are being asked for your provincial government. They deal with the day-to-day demands in your life." - Control: Interviewer introduction (no response)

2. SPR6-INTB: "When relating to people, some people rely heavily on their thinking, rational side. Others rely much more on their emotional side. Please answer either 'Yes' or 'No' to each question." - Control: Interviewer introduction (no response)

3. SPR6-Q1 / RTP4_1: "Do you always try to do what is reasonable and logical?" - Control: Radio - Yes, No

4. SPR6-Q2 / RTP4_2: "Do you always try to understand people and their behaviour, to avoid responding emotionally?" - Control: Radio - Yes, No

5. SPR6-Q3 / RTP4_3: "When dealing with other people do you always try to act rationally?" - Control: Radio - Yes, No

6. SPR6-Q4 / RTP4_4: "Do you try to overcome all conflicts with other people by intelligence and reason, trying hard not to show your emotions?" - Control: Radio - Yes, No

7. SPR6-Q5 / RTP4_5: "If someone deeply hurts your feelings, do you nevertheless try to treat him or her rationally and to understand his or her way of behaving?" - Control: Radio - Yes, No

8. SPR6-Q6 / RTP4_6: "Do you succeed in avoiding most conflicts with other people by relying on your reason and logic, even if this is not how you feel at the time?" - Control: Radio - Yes, No

9. SPR6-Q7 / RTP4_7: "If someone acts against your needs and desires, do you nevertheless try to understand that person?" - Control: Radio - Yes, No

10. SPR6-Q8 / RTP4_8: "Do you behave so rationally in most life situations that your behaviour is rarely influenced by only your emotions?" - Control: Radio - Yes, No

11. SPR6-Q9 / RTP4_9: "Do your emotions frequently influence your behaviour to such a degree that your behaviour might be considered harmful to yourself and others?" - Control: Radio - Yes, No

12. SPR6-Q10 / RTP4_10: "Do you try to understand others even if you don't like them?" - Control: Radio - Yes, No

13. SPR6-Q11 / RTP4_11: "Does your rationality prevent you from verbally attacking or criticizing others, even if there are sufficient reasons for doing so?" - Control: Radio - Yes, No

14. SPR6-INTQ12: "In the next few questions, you will be asked to imagine yourself in a particular situation." - Control: Interviewer introduction (no response)

15. SPR6-Q12 / RTP4_12A-12I: "Imagine you are afraid of the dentist and you have to get some dental work done. Which of the following things would you do to help you overcome your fears?" - Control: Checkbox (read list, mark all that apply) - RTP4_12A=Ask the dentist exactly what he is doing, RTP4_12B=Take a tranquilizer or have a drink before going, RTP4_12C=Try to think about other things, RTP4_12D=Have the dentist tell you when you would feel pain, RTP4_12E=Try to sleep, RTP4_12F=Watch all the dentist's movements and listen for the sound of the drill, RTP4_12G=Watch the flow of water from your mouth, RTP4_12H=Do mental puzzles in your mind, RTP4_12I=Other (Specify)

16. SPR6-Q13 / RTP4_13A-13I: "Imagine that you are a salesperson and get along well with your fellow workers. It has been rumoured that several people will be laid off. Which of the following would you do?" - Control: Checkbox (read list, mark all that apply) - RTP4_13A=Talk to fellow workers about supervisor's evaluation, RTP4_13B=Review list of duties, RTP4_13C=Watch TV/go to movies to distract, RTP4_13D=Try to remember disagreements with supervisor, RTP4_13E=Push all thoughts of being laid off out of mind, RTP4_13F=Rather not discuss chances of being laid off, RTP4_13G=Think which employees might be evaluated more poorly, RTP4_13H=Continue doing work as if nothing was happening, RTP4_13I=Other (Specify)

---

### Alberta Buy-in Questions - 5 questions

*Age >= 18 and non-proxy only*

1. SPR8-INT: "The next questions are being asked for your provincial government. They deal with the day-to-day demands in your life." - Control: Interviewer introduction (no response)

2. SPR8-Q1 / COP4_1: "How would you rate your ability to handle the day-to-day demands in your life, for example, work, family and volunteer responsibilities?" - Control: Radio (read list, mark one only) - 1=Excellent, 2=Very Good, 3=Good, 4=Fair, 5=Poor

3. SPR8-Q2 / COP4_2A-2I: "If the day-to-day demands in your life were causing you to feel under stress, which of the following would you do?" - Control: Checkbox (read list, mark all that apply) - COP4_2A=Try not to think about situation/keep busy, COP4_2B=See situation in different light, COP4_2C=Think about ways to change situation/solve problem, COP4_2D=Express emotions to reduce tension, COP4_2E=Admit stressful but do nothing, COP4_2F=Talk about it with others, COP4_2G=Do something enjoyable to relax, COP4_2H=Pray/seek comfort through faith, COP4_2I=Do something else (Specify)

4. SPR8-Q3 / COP4_3: "How would you rate your ability to handle unexpected and difficult problems, for example, family or personal crisis?" - Control: Radio (read list, mark one only) - 1=Excellent, 2=Very Good, 3=Good, 4=Fair, 5=Poor

5. SPR8-Q4 / COP4_4A-4I: "If an unexpected problem or situation was causing you to feel under stress, which of the following would you do?" - Control: Checkbox (read list, mark all that apply) - COP4_4A=Try not to think about situation/keep busy, COP4_4B=See situation in different light, COP4_4C=Think about ways to solve problem, COP4_4D=Express emotions to reduce tension, COP4_4E=Admit stressful but do nothing, COP4_4F=Talk about it with others, COP4_4G=Do something enjoyable to relax, COP4_4H=Pray/seek comfort through faith, COP4_4I=Do something else (Specify)

---

## Appendix A: Health Component for Respondents Aged 0 to 11 Years Old (Form H06)

---

### Child General Health - 5 questions

1. KGH-Q1 / GHC4_1: "In general, would you say [child's] health is:" - Control: Radio (read list, mark one only) - 1=Excellent, 2=Very good, 3=Good, 4=Fair, 5=Poor

2. KGH-Q3 / RAC4F1: "Does [child] have any long-term physical or mental condition or a health problem which prevents or limits [his/her] participation in school, at play, or in any other activity for a child [his/her] age?" - Control: Radio - Yes, No

3. KGH-Q4 / HWC4_HT: "How tall is [he/she] without shoes on?" - Control: Numeric entry (feet/inches or centimetres)

4. KGH-Q5: "How much does [he/she] weigh?" - Control: Numeric entry (pounds or kilograms); DK/R --> GO TO Child Health Care Utilization

5. KGH-C5: Check — "Was that in pounds or in kilograms?" - Control: Radio - 1=Pounds (HWC4_3LB), 2=Kilograms (HWC4_3KG)

---

### Child Health Care Utilization - 3 questions

1. KUT-INT: "Now I'd like to ask about [child's] contacts with health professionals during the past 12 months." - Control: Interviewer instruction (no response)

2. KUT-Q1 / HCC4_1: "In the past 12 months, has [child] been an overnight patient in a hospital?" - Control: Radio - Yes, No

3. KUT-Q3 / HCC4_2A/HCC4_2C/HCC4_2D/HCC4_2E/HCC4_2I/HCC4_2H/HCK4_2OT: "(Not counting when [child] was an overnight patient) In the past 12 months, how many times have you seen or talked on the telephone with a/an [fill category] about [his/her] physical, emotional or mental health?" - Control: Numeric grid (sub-items):
   - a) General practitioner/family physician
   - b) Pediatrician
   - c) Other medical doctor (orthopedist, eye specialist)
   - d) Public health nurse or nurse practitioner
   - e) Dentist or orthodontist
   - f) Psychiatrist or psychologist
   - g) Child welfare worker or children's aid worker
   - h) Any other trained person (speech therapist, social worker)

---

### Child Chronic Conditions - 9 questions

1. KCHR-C1: Check/Filter — "If age > 3, go to KCHR-Q4." - age > 3 --> GO TO KCHR-Q4

2. KCHR-Q1 / CCK4_1: "Thinking now about illnesses, how often does [child] have nose or throat infections?" - Control: Radio (read list, mark one only) - 1=Almost all the time, 2=Often, 3=From time to time, 4=Rarely, 5=Never

3. KCHR-Q2 / CCK4_2: "Since [his/her] birth, has [he/she] ever had an ear infection (otitis)?" - Control: Radio - Yes, No --> GO TO KCHR-Q4, DK/R --> GO TO KCHR-Q4

4. KCHR-Q3 / CCK4_3: "How many times?" - Control: Radio (do not read list, mark one only) - 1=Once, 2=2 times, 3=3 times, 4=4 or more times

5. KCHR-Q4 / CCC4_1C: "Has [child] ever had asthma that has been diagnosed by a health professional?" - Control: Radio - Yes, No --> GO TO KCHR1-INT, DK/R --> GO TO KCHR1-INT

6. KCHR-Q5 / CCC4_C5: "Has [he/she] had an attack of asthma in the past 12 months?" - Control: Radio - Yes, No

7. KCHR-Q6 / CCC4_C6: "Has [he/she] had wheezing or whistling in the chest at any time in the past 12 months?" - Control: Radio - Yes, No

8. KCHR1-INT: "In the following questions long-term conditions refer to conditions that have lasted or are expected to last 6 months or more." - Control: Interviewer instruction (no response)

9. KCHR1-Q1 / CCK4_1AB / CCC4_1H / CCC4_1K / CCC4_1L / CCC4_1V / CCC4_NON: "Does [child] have any of the following long-term conditions that have been diagnosed by a health professional?" - Control: Checkbox (multi-select):
   - a) Allergies
   - b) Bronchitis
   - c) Heart condition or disease
   - d) Epilepsy
   - e) Cerebral palsy
   - f) Kidney condition or disease
   - g) Mental handicap
   - h) A learning disability (ask only age >= 6)
   - i) An emotional, psychological or nervous condition (ask only age >= 6)
   - j) Any other long-term condition
   - k) None

---

### Child Health Status - 35 questions

1. KHS-C1: Check/Filter — "If age < 4, go to Child Injuries section." - age < 4 --> GO TO Child Injuries

2. KHS-INT: "The next set of questions asks about [child's] day-to-day health." - Control: Interviewer instruction (no response)

3. KHS-INTA: "You may feel that some of these questions do not apply to [child], but it is important that we ask the same questions of everyone." - Control: Interviewer instruction (no response)

**Vision**

4. KHS-Q1 / HSC4_1: "Is [he/she] usually able to see clearly, and without distortion, the words in a book without glasses or contact lenses?" - Control: Radio - Yes --> GO TO KHS-Q4, No

5. KHS-Q2 / HSC4_2: "Is [he/she] usually able to see clearly, and without distortion, the words in a book with glasses or contact lenses?" - Control: Radio - Yes --> GO TO KHS-Q4, No, Doesn't wear glasses/lenses

6. KHS-Q3 / HSC4_3: "Is [he/she] able to see at all?" - Control: Radio - Yes, No --> GO TO KHS-Q6

7. KHS-Q4 / HSC4_4: "Is [he/she] able to see well enough to recognize a friend on the other side of the street without glasses or contact lenses?" - Control: Radio - Yes --> GO TO KHS-Q6, No

8. KHS-Q5 / HSC4_5: "Is [he/she] usually able to see well enough to recognize a friend on the other side of the street with glasses or contact lenses?" - Control: Radio - Yes, No, Doesn't wear glasses/lenses

**Hearing**

9. KHS-Q6 / HSC4_6: "Is [he/she] usually able to hear what is said in a group conversation with at least 3 other people without a hearing aid?" - Control: Radio - Yes --> GO TO KHS-IN2, No

10. KHS-Q7 / HSC4_7: "Is [he/she] usually able to hear what is said in a group conversation with at least 3 other people with a hearing aid?" - Control: Radio - Yes --> GO TO KHS-Q8, No, Doesn't wear hearing aid

11. KHS-Q7A / HSC4_7A: "Is [he/she] able to hear at all?" - Control: Radio - Yes, No --> GO TO KHS-IN2

12. KHS-Q8 / HSC4_8: "Is [he/she] usually able to hear what is said in a conversation with one other person in a quiet room without a hearing aid?" - Control: Radio - Yes --> GO TO KHS-IN2, No

13. KHS-Q9 / HSC4_9: "Is [he/she] usually able to hear what is said in a conversation with one other person in a quiet room with a hearing aid?" - Control: Radio - Yes, No, Doesn't wear hearing aid

14. KHS-IN2: "The next few questions on day-to-day health are concerned with [child's] abilities relative to other children the same age." - Control: Interviewer instruction (no response)

**Speech**

15. KHS-Q10 / HSC4_10: "Is [he/she] usually able to be understood completely when speaking with strangers in [his/her] own language?" - Control: Radio - Yes --> GO TO KHS-Q14, No

16. KHS-Q11 / HSC4_11: "Is [he/she] able to be understood partially when speaking with strangers?" - Control: Radio - Yes, No

17. KHS-Q12 / HSC4_12: "Is [he/she] able to be understood completely when speaking with those who know [him/her] well?" - Control: Radio - Yes --> GO TO KHS-Q14, No

18. KHS-Q13 / HSC4_13: "Is [he/she] able to be understood partially when speaking with those who know [him/her] well?" - Control: Radio - Yes, No

**Getting Around**

19. KHS-Q14 / HSC4_14: "Is [child] usually able to walk around the neighbourhood without difficulty and without mechanical support?" - Control: Radio - Yes --> GO TO KHS-Q21, No

20. KHS-Q15 / HSC4_15: "Is [he/she] able to walk at all?" - Control: Radio - Yes, No --> GO TO KHS-Q18

21. KHS-Q16 / HSC4_16: "Does [he/she] require mechanical support such as braces, a cane or crutches to be able to walk?" - Control: Radio - Yes, No

22. KHS-Q17 / HSC4_17: "Does [he/she] require the help of another person to be able to walk?" - Control: Radio - Yes, No

23. KHS-Q18 / HSC4_18: "Does [he/she] require a wheelchair to get around?" - Control: Radio - Yes, No --> GO TO KHS-Q21

24. KHS-Q19 / HSC4_19: "How often does [he/she] use a wheelchair?" - Control: Radio (read list, mark one only) - Always, Often, Sometimes, Never

25. KHS-Q20 / HSC4_20: "Does [he/she] need the help of another person to get around in the wheelchair?" - Control: Radio - Yes, No

**Hands and Fingers**

26. KHS-Q21 / HSC4_21: "Is [child] usually able to grasp and handle small objects such as a pencil or scissors?" - Control: Radio - Yes --> GO TO KHS-Q25, No

27. KHS-Q22 / HSC4_22: "Does [he/she] require the help of another person because of limitations in the use of hands or fingers?" - Control: Radio - Yes, No --> GO TO KHS-Q24

28. KHS-Q23 / HSC4_23: "Does [he/she] require the help of another person with:" - Control: Radio (read list, mark one only) - Some tasks, Most tasks, Almost all tasks, All tasks

29. KHS-Q24 / HSC4_24: "Does [he/she] require special equipment because of limitations in the use of hands or fingers?" - Control: Radio - Yes, No

**Feelings**

30. KHS-Q25 / HSC4_25: "Would you describe [child] as being usually:" - Control: Radio (read list, mark one only) - Happy and interested in life, Somewhat happy, Somewhat unhappy, Unhappy with little interest in life, So unhappy that life is not worthwhile

**Memory**

31. KHS-Q26 / HSC4_26: "How would you describe [his/her] usual ability to remember things?" - Control: Radio (read list, mark one only) - Able to remember most things, Somewhat forgetful, Very forgetful, Unable to remember anything at all

**Thinking**

32. KHS-Q27 / HSC4_27: "How would you describe [his/her] usual ability to think and solve day-to-day problems?" - Control: Radio (read list, mark one only) - Able to think clearly and solve problems, Having a little difficulty, Having some difficulty, Having a great deal of difficulty, Unable to think or solve problems

**Pain and Discomfort**

33. KHS-Q28 / HSC4_28: "Is [child] usually free of pain or discomfort?" - Control: Radio - Yes --> GO TO Child Injuries, No

34. KHS-Q29 / HSC4_29: "How would you describe the usual intensity of [his/her] pain or discomfort?" - Control: Radio (read list, mark one only) - Mild, Moderate, Severe

35. KHS-Q30 / HSC4_30: "How many activities does [his/her] pain or discomfort prevent?" - Control: Radio (read list, mark one only) - None, A few, Some, Most

---

### Child Injuries - 7 questions

1. KIN-INT: "The following questions refer to injuries that occurred in the past 12 months and were serious enough to require medical attention." - Control: Interviewer instruction (no response)

2. KIN-Q1 / IJC4_1: "In the past 12 months, was [child] injured?" - Control: Radio - Yes, No --> GO TO end, DK/R --> GO TO end

3. KIN-Q2 / IJC4_2: "How many times was [he/she] injured?" - Control: Numeric entry (1-30); DK/R --> GO TO end

4. KIN-Q3 / IJC4_3: "(For the most serious injury,) what type of injury did [he/she] have?" - Control: Radio (do not read list, mark one only) - 1=Broken/fractured bones, 2=Burn/scald, 3=Dislocation, 4=Sprain/strain, 5=Cut/scrape/bruise, 6=Concussion --> GO TO KIN-Q5, 7=Poisoning --> GO TO KIN-Q5, 8=Internal injury --> GO TO KIN-Q5, 9=Dental injury --> GO TO KIN-Q5, 10=Other (specify), 11=Multiple injuries --> GO TO KIN-Q5; DK/R --> GO TO end

5. KIN-Q4 / IJC4_4: "What part of [his/her] body was injured?" - Control: Radio (do not read list, mark one only) - 1=Eyes, 2=Face/scalp, 3=Head/neck, 4=Arms/hands, 5=Legs/feet, 6=Back/spine, 7=Trunk, 8=Shoulder, 9=Hip/Multiple sites, 11=Systemic; DK/R --> GO TO end

6. KIN-Q5 / IJC4_5: "Where did the injury happen?" - Control: Radio (do not read list, mark one only) - 1=Inside own home/apartment, 2=Outside home including yard/driveway, 3=In/around other private residence, 4=Inside school/daycare/grounds, 5=Indoor/outdoor sports facility, 6=Other public building, 7=Sidewalk/street/highway in neighbourhood, 8=Other sidewalk/street/highway, 9=Playground/park, 10=Other (specify); DK/R --> GO TO end

7. KIN-Q6 / IJC4_6: "What happened?" - Control: Radio (do not read list, mark one only) - 1=Motor vehicle collision - passenger, 2=Motor vehicle collision - pedestrian, 3=Motor vehicle collision - riding bicycle, 4=Other bicycle accident, 5=Fall, 6=Sports, 7=Physical assault, 8=Scalded by hot liquids/food, 9=Accidental poisoning, 10=Self-inflicted poisoning, 11=Other self-inflicted injuries, 12=Natural/environmental factors, 13=Fire/flames/fumes, 14=Near drowning, 15=Other (specify)
