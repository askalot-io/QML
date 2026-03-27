# Canadian Community Health Survey (CCHS) Cycle 3.1 - Question Inventory

## Document Overview
- **Title**: Canadian Community Health Survey - Cycle 3.1
- **Organization**: Statistics Canada
- **Date**: June 2005 (Final Questionnaire)
- **Language**: English
- **Type**: Computer-Assisted Telephone Interview (CATI) questionnaire
- **Total Sections**: 72

## Structure
The questionnaire is organized into **common content** (all respondents) and **optional content** (subsample) modules. CATI fill variables (^YOU1, ^YOU2, ^FNAME) adapt for proxy/non-proxy. Each module has entry/exit routing (XXX_BEG/XXX_END). Check items (C-prefixed) control routing. GOTO annotations show branching targets.

## Notation
- **[Go to XXX_YYY]**: GOTO routing target
- **C-items**: Check/routing conditions
- **R-items**: Read/interviewer instructions
- **DK, R**: Don't Know, Refused

## Question Inventory by Section

---

### AGE OF SELECTED RESPONDENT (ANC) - 5 questions

- **ANC_C01A**: If (do ANC block = 1), go to ANC_R01. Otherwise, go to ANC_END.

- *ANC_R01*: For some of the questions I’ll be asking, I need to know ^YOUR2 exact date of birth. INTERVIEWER: Press <Enter> to continue. Date Block

1. **ANC_Q01**: INTERVIEWER: Enter the day. If necessary, ask (What is the day?) |_|_| - DK,R

2. **ANC_Q01**: INTERVIEWER: Enter the month. If necessary, ask (What is the month?) - 1=January                  7       July; 2=February                 8       August; 3=March                    9       September; 4=April                    10      October; 5=May                      11      November; 6=June                     12      December; DK,R

3. **ANC_Q01**: INTERVIEWER: Enter a four-digit year. If necessary, ask (What is the year?) |_|_|_|_| - DK,R

- **ANC_C02**: Calculate age based on the entered date of birth.

4. **ANC_Q02**: So ^YOUR1 age is [calculated age]. Is that correct? - 1=Yes [Go to ANC_C03]; 2=No, return and correct date of birth [Go to ANC_Q01]; 3=No, collect age [Go to ANC_Q03]; (DK,R not allowed)

- **ANC_C03**: If [calculated age] < 12 years go to ANC_R04. Otherwise go to ANC_END.

5. **ANC_Q03**: What is ^YOUR1 age? |_|_|_| Age in years - (DK,R not allowed)

- **ANC_C04**: If age < 12 years, go to ANC_R04. Otherwise, go to ANC_END.

- *ANC_R04*: Because ^YOU1 ^ARE less than 12 years old, ^YOU1 ^ARE not eligible to INTERVIEWER: Press <Enter> to continue. NOTE: Auto code as 90 Unusual/Special circumstances and call the exit block. ANC_END

---

### GENERAL HEALTH (GEN) - 8 questions

- **GEN_C01**: If (do GEN = 1), go to GEN_R01. Otherwise, go to GEN_END.

- *GEN_R01*: This survey deals with various aspects of ^YOUR2 health. I’ll be asking about such things as physical activity, social relationships and health status. By health, we mean not only the absence of disease or injury but ...

1. **GEN_Q01**: To start, in general, would you say ^YOUR1 health is:  - 1=… excellent?; 2=… very good?; 3=… good?; 4=… fair?; 5=… poor?; DK,R

2. **GEN_Q02**: Compared to one year ago, how would you say ^YOUR1 health is now? Is it:  - 1=… much better now than 1 year ago?; 2=… somewhat better now (than 1 year ago)?; 3=… about the same as 1 year ago?; 4=… somewhat worse now (than 1 year ago)?; 5=… much worse now (than 1 year ago)?; DK,R

- **GEN_C02A**: If proxy interview, go to GEN_C07. Otherwise, go to GEN_Q02A.

3. **GEN_Q02A**: How satisfied are you with your life in general?  - 1=Very satisfied; 2=Satisfied; 3=Neither satisfied nor dissatisfied; 4=Dissatisfied; 5=Very dissatisfied; DK,R

4. **GEN_Q02B**: In general, would you say your mental health is:  - 1=… excellent?; 2=… very good?; 3=… good?; 4=… fair?; 5=… poor?; DK,R

- **GEN_C07**: If age < 15, go to GEN_C08A. Otherwise, go to GEN_Q07.

5. **GEN_Q07**: Thinking about the amount of stress in ^YOUR1 life, would you say that most days are:  - 1=… not at all stressful?; 2=… not very stressful?; 3=… a bit stressful?; 4=… quite a bit stressful?; 5=… extremely stressful?; DK,R

- **GEN_C08A**: If proxy interview, go to GEN_END. Otherwise, go to GEN_C08B.

- **GEN_C08B**: If age < 15 or age > 75, go to GEN_Q10. Otherwise, go to GEN_Q08.

6. **GEN_Q08**: Have you worked at a job or business at any time in the past 12 months? - 1=Yes; 2=No [Go to GEN_Q10]; DK,R [Go to GEN_Q10]

7. **GEN_Q09**: The next question is about your main job or business in the past 12 months. Would you say that most days at work were:  - 1=… not at all stressful?; 2=… not very stressful?; 3=… a bit stressful?; 4=… quite a bit stressful?; 5=… extremely stressful?; DK,R

8. **GEN_Q10**: How would you describe your sense of belonging to your local community? Would you say it is: GEN_END - 1=… very strong?; 2=… somewhat strong?; 3=… somewhat weak?; 4=… very weak?; DK,R

---

### VOLUNTARY ORGANIZATIONS (ORG) - 2 questions

*[Optional content]*

- **ORG_C1A**: If (ORG block = 1), go to ORG_C1B.

- **ORG_C1B**: If proxy interview, go to ORG_END. Otherwise, go to ORG_Q1.

1. **ORG_Q1**: Are you a member of any voluntary organizations or associations such as school groups, church social groups, community centres, ethnic associations or social, civic or fraternal clubs? - 1=Yes; 2=No [Go to ORG_END]; DK,R [Go to ORG_END]

2. **ORG_Q2**: How often did you participate in meetings or activities of these groups in the past ORG_END - 12=months? If you belong to many, just think of the ones in which you are most; 1=At least once a week; 2=At least once a month; 3=At least 3 or 4 times a year; 4=At least once a year; 5=Not at all; DK,R

---

### SLEEP (SLP) - 4 questions

*[Optional content]*

- **SLP_C1**: If (SLP block = 1), go to SLP_C2.

- **SLP_C2**: If proxy interview, go to SLP_END. Otherwise, go to SLP_Q01.

1. **SLP_Q01**: Now a few questions about sleep. How long do you usually spend sleeping each night? INTERVIEWER: Do not include time spent resting. - 1=Under 2 hours; 2=2 hours to less than 3 hours; 3=3 hours to less than 4 hours; 4=4 hours to less than 5 hours; 5=5 hours to less than 6 hours; 6=6 hours to less than 7 hours; 7=7 hours to less than 8 hours; 8=8 hours to less than 9 hours; 9=9 hours to less than 10 hours; 10=10 hours to less than 11 hours; 11=11 hours to less than 12 hours; 12=12 hours or more; DK; R [Go to SLP_END]

2. **SLP_Q02**: How often do you have trouble going to sleep or staying asleep?  - 1=None of the time; 2=A little of the time; 3=Some of the time; 4=Most of the time; 5=All of the time; DK,R

3. **SLP_Q03**: How often do you find your sleep refreshing? - 1=None of the time; 2=A little of the time; 3=Some of the time; 4=Most of the time; 5=All of the time; DK,R

4. **SLP_Q04**: How often do you find it difficult to stay awake when you want to? SLP_END - 1=None of the time; 2=A little of the time; 3=Some of the time; 4=Most of the time; 5=All of the time; DK,R

---

### CHANGES MADE TO IMPROVE HEALTH (CIH) - 12 questions

*[Optional content]*

- **CIH_C1A**: If (do CIH block = 1), go to CIH_C1B.

- **CIH_C1B**: If proxy interview, go to CIH_END. Otherwise, go to CIH_Q1.

1. **CIH_Q1**: Next, some questions about changes made to improve health. In the past 12 months, did you do anything to improve your health? (For example, lost weight, quit smoking, increased exercise) - 1=Yes; 2=No [Go to CIH_Q3]; DK,R [Go to CIH_END]

2. **CIH_Q2**: What is the single most important change you have made? - 1=Increased exercise, sports / physical activity; 2=Lost weight; 3=Changed diet / improved eating habits; 4=Quit smoking / reduced amount smoked; 5=Drank less alcohol; 6=Reduced stress level; 7=Received medical treatment; 8=Took vitamins; 9=Other – Specify; DK,R

- **CIH_C2S**: If CIH_Q2 = 9, go to CIH_Q2S. Otherwise, go to CIH_Q3.

3. **CIH_Q2S**: INTERVIEWER: Specify. _________________________ (80 spaces) - DK,R

4. **CIH_Q3**: Do you think there is [anything else/anything] you should do to improve your physical health? - 1=Yes; 2=No [Go to CIH_END]; DK,R [Go to CIH_END]

5. **CIH_Q4**: What is the most important thing? - 1=Start / Increase exercise, sports / physical activity; 2=Lose weight; 3=Change diet / improve eating habits; 4=Quit smoking / reduce amount smoked; 5=Drink less alcohol; 6=Reduce stress level; 7=Receive medical treatment; 8=Take vitamins; 9=Other – Specify; DK,R

- **CIH_C4S**: If CIH_Q4 = 9, go to CIH_Q4S. Otherwise, go to CIH_Q5.

6. **CIH_Q4S**: INTERVIEWER: Specify. _________________________ (80 spaces) - DK,R

7. **CIH_Q5**: Is there anything stopping you from making this improvement? - 1=Yes; 2=No [Go to CIH_Q7]; DK,R [Go to CIH_Q7]

8. **CIH_Q6**: What is that?  - 1=Lack of will power / self-discipline; 2=Family responsibilities; 3=Work schedule; 4=Addiction to drugs / alcohol; 5=Physical condition; 6=Disability / health problem; 7=Too stressed; 8=Too costly / financial constraints; 9=Not available - in area; 10=Transportation problems; 11=Weather problems; 12=Other - Specify; DK,R

- **CIH_C6S**: If CIH_Q6 = 12, go to CIH_Q6S. Otherwise, go to CIH_Q7.

9. **CIH_Q6S**: INTERVIEWER: Specify. _________________________ (80 spaces) - DK,R

10. **CIH_Q7**: Is there anything you intend to do to improve your physical health in the next year? - 1=Yes; 2=No [Go to CIH_END]; DK,R [Go to CIH_END]

11. **CIH_Q8**: What is that? INTERVIEWER : Mark all that apply. - 1=Start / Increase exercise, sports / physical activity; 2=Lose weight; 3=Change diet / improve eating habits; 4=Quit smoking / reduce amount smoked; 5=Drink less alcohol; 6=Reduce stress level; 7=Receive medical treatment; 8=Take vitamins; 9=Other – Specify; DK,R

- **CIH_C8S**: If CIH_Q8 = 9, go to CIH_Q8S. Otherwise, go to CIH_END.

12. **CIH_Q8S**: INTERVIEWER: Specify. _________________________ (80 spaces) CIH_END - DK,R

---

### HEALTH CARE SYSTEM SATISFACTION (HCS) - 4 questions

*[Optional content]*

- **HCS_C1A**: If (do HCS block = 1), go to HCS_ C1B.

- **HCS_C1B**: If proxy interview or if age < 15, go to HCS_END. Otherwise, go to HCS_C1C.

- **HCS_C1C**: If province = 10, [province] = [Newfoundland and Labrador] If province = 11, [province] = [Prince Edward Island] If province = 12, [province] = [Nova Scotia] If province = 13, [province] = [New Brunswick] If province = 24, [province] = [Quebec] If province = 35, [province] = [...

1. **HCS_Q1**: Now, a few questions about health care services in [province]. Overall, how would you rate the availability of health care services in [province]? Would you say it is:  - 1=... excellent?; 2=... good?; 3=... fair?; 4=... poor?; DK,R [Go to HCS_END]

2. **HCS_Q2**: Overall, how would you rate the quality of the health care services that are available in [province]?  - 1=Excellent; 2=Good; 3=Fair; 4=Poor; DK,R

3. **HCS_Q3**: Overall, how would you rate the availability of health care services in your community? - 1=Excellent; 2=Good; 3=Fair; 4=Poor; DK,R

4. **HCS_Q4**: Overall, how would you rate the quality of the health care services that are available in your community? HCS_END - 1=Excellent; 2=Good; 3=Fair; 4=Poor; DK,R

---

### HEIGHT AND WEIGHT (HWT) - 12 questions

- **HWT_C1**: If (do HWT block = 1), go to HWT_Q2. Otherwise, go to HWT_END.

1. **HWT_Q2**: The next questions are about height and weight. How tall ^ARE ^YOU2 without shoes on? - 0=Less than 1’ / 12” (less than 29.2 cm.); 1=1’0” to 1’11” / 12” to 23” (29.2 to 59.6 cm.); 2=2’0” to 2’11” / 24” to 35” (59.7 to 90.1 cm.); 3=3’0” to 3’11” / 36” to 47” (90.2 to 120.6 cm.) [Go to HWT_N2C]; 4=4’0” to 4’11” / 48” to 59” (120.7 to 151.0 cm.) [Go to HWT_N2D]; 5=5’0” to 5’11” (151.1 to 181.5 cm.) [Go to HWT_N2E]; 6=6’0” to 6’11” (181.6 to 212.0 cm.) [Go to HWT_N2F]; 7=7’0” and over...

2. **HWT_N2A**: INTERVIEWER: Select the exact height. - 0=1’0” / 12” (29.2 to 31.7 cm.); 1=1’1” / 13” (31.8 to 34.2 cm.); 2=1’2” / 14” (34.3 to 36.7 cm.); 3=1’3” / 15” (36.8 to 39.3 cm.); 4=1’4” / 16” (39.4 to 41.8 cm.); 5=1’5” / 17” (41.9 to 44.4 cm.); 6=1’6” / 18” (44.5 to 46.9 cm.); 7=1’7” / 19” (47.0 to 49.4 cm.); 8=1’8” / 20” (49.5 to 52.0 cm.); 9=1’9” / 21” (52.1 to 54.5 cm.); 10=1’10” / 22” (54.6 to 57.1 cm.); 11=1’11” / 23” (57.2 to 59.6 cm....

3. **HWT_N2B**: INTERVIEWER: Select the exact height. - 0=2’0” / 24” (59.7 to 62.1 cm.); 1=2’1” / 25” (62.2 to 64.7 cm.); 2=2’2” / 26” (64.8 to 67.2 cm.); 3=2’3” / 27” (67.3 to 69.8 cm.); 4=2’4” / 28” (69.9 to 72.3 cm.); 5=2’5” / 29” (72.4 to 74.8 cm.); 6=2’6” / 30” (74.9 to 77.4 cm.); 7=2’7” / 31” (77.5 to 79.9 cm.); 8=2’8” / 32” (80.0 to 82.5 cm.); 9=2’9” / 33” (82.6 to 85.0 cm.); 10=2’10” / 34” (85.1 to 87.5 cm.); 11=2’11” / 35” (87.6 to 90.1 cm....

4. **HWT_N2C**: INTERVIEWER: Select the exact height. - 0=3’0” / 36” (90.2 to 92.6 cm.); 1=3’1” / 37” (92.7 to 95.2 cm.); 2=3’2” / 38” (95.3 to 97.7 cm.); 3=3’3” / 39” (97.8 to 100.2 cm.); 4=3’4” / 40” (100.3 to 102.8 cm.); 5=3’5” / 41” (102.9 to 105.3 cm.); 6=3’6” / 42” (105.4 to 107.9 cm.); 7=3’7” / 43” (108.0 to 110.4 cm.); 8=3’8” / 44” (110.5 to 112.9 cm.); 9=3’9” / 45” (113.0 to 115.5 cm.); 10=3’10” / 46” (115.6 to 118.0 cm.); 11=3’11” / 47” (1...

5. **HWT_N2D**: INTERVIEWER: Select the exact height. - 0=4’0” / 48” (120.7 to 123.1 cm.); 1=4’1” / 49” (123.2 to 125.6 cm.); 2=4’2” / 50” (125.7 to 128.2 cm.); 3=4’3” / 51” (128.3 to 130.7 cm.); 4=4’4” / 52” (130.8 to 133.3 cm.); 5=4’5” / 53” (133.4 to 135.8 cm.); 6=4’6” / 54” (135.9 to 138.3 cm.); 7=4’7” / 55” (138.4 to 140.9 cm.); 8=4’8” / 56” (141.0 to 143.4 cm.); 9=4’9” / 57” (143.5 to 146.0 cm.); 10=4’10” / 58” (146.1 to 148.5 cm.); 11=4’11” /...

6. **HWT_N2E**: INTERVIEWER: Select the exact height. - 0=5’0” (151.1 to 153.6 cm.); 1=5’1” (153.7 to 156.1 cm.); 2=5’2” (156.2 to 158.7 cm.); 3=5’3” (158.8 to 161.2 cm.); 4=5’4” (161.3 to 163.7 cm.); 5=5’5” (163.8 to 166.3 cm.); 6=5’6” (166.4 to 168.8 cm.); 7=5’7” (168.9 to 171.4 cm.); 8=5’8” (171.5 to 173.9 cm.); 9=5’9” (174.0 to 176.4 cm.); 10=5’10” (176.5 to 179.0 cm.); 11=5’11” (179.1 to 181.5 cm.); DK,R; [Then go to HWT_Q3]

7. **HWT_N2F**: INTERVIEWER: Select the exact height. - 0=6’0” (181.6 to 184.1 cm.); 1=6’1” (184.2 to 186.6 cm.); 2=6’2” (186.7 to 189.1 cm.); 3=6’3” (189.2 to 191.7 cm.); 4=6’4” (191.8 to 194.2 cm.); 5=6’5” (194.3 to 196.8 cm.); 6=6’6” (196.9 to 199.3 cm.); 7=6’7” (199.4 to 201.8 cm.); 8=6’8” (201.9 to 204.4 cm.); 9=6’9” (204.5 to 206.9 cm.); 10=6’10” (207.0 to 209.5 cm.); 11=6’11” (209.6 to 212.0 cm.); DK,R

8. **HWT_Q3**: How much ^DOVERB ^YOU2 weigh? INTERVIEWER: Enter amount only. |_|_|_| Weight - DK,R [Go to HWT_END]

9. **HWT_N4**: INTERVIEWER: Was that in pounds or kilograms?

10. **HWTE_N4**:  - 1=Pounds; 2=Kilograms; (DK,R not allowed)

11. **HWT_N4**: = 2) or (HWT_Q3 < 60 and HWT_N4 = 1 or HWT_Q3 < 27 and HWT_N4 = 2).

- **HWT_C4**: If proxy interview, go to HWT_END. Otherwise, go to HWT_Q4.

12. **HWT_Q4**: Do you consider yourself: HWT_END - 1=… overweight?; 2=… underweight?; 3=… just about right?; DK,R

---

### CHRONIC CONDITIONS (CCC) - 54 questions

- **CCC_C011**: If (do CCC block = 1), go to CCC_R011. Otherwise, go to CCC_END.

- *CCC_R011*: Now I’d like to ask about certain chronic health conditions which ^YOU2 may have. We are interested in “long-term conditions” which are expected to last or have already lasted 6 months or more and that have been diagn...

1. **CCC_Q011**: ^DOVERB_C ^YOU2 have: ... food allergies? - 1=Yes; 2=No; DK; R [Go to CCC_END]

2. **CCC_Q021**: (^DOVERB_C ^YOU2 have:) ... any other allergies? - 1=Yes; 2=No; DK,R

3. **CCC_Q031**: (^DOVERB_C ^YOU2 have:) ... asthma? - 1=Yes; 2=No [Go to CCC_Q041]; DK,R [Go to CCC_Q041]

4. **CCC_Q035**: ^HAVE_C ^YOU2 had any asthma symptoms or asthma attacks in the past - 12=months?; 1=Yes; 2=No; DK,R

5. **CCC_Q036**: In the past 12 months, ^HAVE ^YOU1 taken any medicine for asthma such as inhalers, nebulizers, pills, liquids or injections? - 1=Yes; 2=No; DK,R

6. **CCC_Q041**: ^DOVERB_C ^YOU2 have fibromyalgia? - 1=Yes; 2=No; DK,R

7. **CCC_Q051**: Remember, we’re interested in conditions diagnosed by a health professional. ^DOVERB_C ^YOU2 have arthritis or rheumatism, excluding fibromyalgia? - 1=Yes; 2=No [Go to CCC_Q061]; DK,R [Go to CCC_Q061]

8. **CCC_Q05A**: What kind of arthritis ^DOVERB ^YOU1 have? - 1=Rheumatoid arthritis; 2=Osteoarthritis; 3=Rheumatism; 4=Other - Specify; DK,R

- **CCC_C05AS**: If CCC_Q05A = 4, go to CCC_Q05AS. Otherwise, go to CCC_Q061.

9. **CCC_Q05AS**: INTERVIEWER: Specify. ________________________ (80 spaces) - DK,R

10. **CCC_Q061**: (Remember, we’re interested in conditions diagnosed by a health professional.) ^DOVERB_C ^YOU2 have back problems, excluding fibromyalgia and arthritis? - 1=Yes; 2=No; DK,R

11. **CCC_Q071**: ^DOVERB_C ^YOU2 have high blood pressure? - 1=Yes [Go to CCC_Q073]; 2=No; DK; R [Go to CCC_Q081]

12. **CCC_Q072**: ^HAVE_C ^YOU1 ever been diagnosed with high blood pressure? - 1=Yes; 2=No [Go to CCC_Q081]; DK,R [Go to CCC_Q081]

13. **CCC_Q073**: In the past month, ^HAVE ^YOU1 taken any medicine for high blood pressure? - 1=Yes; 2=No; DK,R

14. **CCC_Q074**: In the past month, did ^YOU1 do anything else, recommended by a health professional, to reduce or control ^YOUR1 blood pressure? - 1=Yes; 2=No [Go to CCC_Q081]; DK,R [Go to CCC_Q081]

15. **CCC_Q075**: What did ^YOU1 do?  - 1=Changed diet (e.g., reduced salt intake); 2=Exercised more; 3=Reduced alcohol intake; 4=Other; DK,R

16. **CCC_Q081**: Remember, we’re interested in conditions diagnosed by a health professional. ^DOVERB_C ^YOU2 have migraine headaches? - 1=Yes; 2=No; DK,R

17. **CCC_Q091A**: (Remember, we’re interested in conditions diagnosed by a health professional.) (^DOVERB_C ^YOU2 have:) ... chronic bronchitis? - 1=Yes; 2=No; DK,R

- **CCC_C091E**: If age < 30, go to CCC_Q101. Otherwise, go to CCC_Q091E.

18. **CCC_Q091E**: (^DOVERB_C ^YOU2 have:) ... emphysema? - 1=Yes; 2=No; DK,R

19. **CCC_Q091F**: (^DOVERB_C ^YOU2 have:) ... chronic obstructive pulmonary disease (COPD)? - 1=Yes; 2=No; DK,R

20. **CCC_Q101**: (^DOVERB_C ^YOU2 have:) ... diabetes? - 1=Yes; 2=No [Go to CCC_Q111]; DK,R [Go to CCC_Q111]

21. **CCC_Q102**: How old ^WERE ^YOU1 when this was first diagnosed? INTERVIEWER: Maximum is [current age]. |_|_|_| Age in years - DK,R

- **CCC_C10A**: If age < 15 or sex = male or CCC_Q102 < 15 or CCC_Q102 > 49, go to

22. **CCC_Q10C**: . Otherwise, go to CCC_Q10A.

23. **CCC_Q10A**: ^WERE ^YOU1 pregnant when ^YOU1 ^WERE first diagnosed with diabetes? - 1=Yes; 2=No [Go to CCC_Q10C]; DK,R [Go to CCC_Q10C]

24. **CCC_Q10B**: Other than during pregnancy, has a health professional ever told ^YOU1 that ^YOU1 ^HAVE diabetes? - 1=Yes; 2=No [Go to CCC_Q111]; DK,R [Go to CCC_Q111]

25. **CCC_Q10C**: When ^YOU1 ^WERE first diagnosed with diabetes, how long was it before ^YOU1 ^WERE started on insulin? - 1=Less than 1 month; 2=1 month to less than 2 months; 3=2 months to less than 6 months; 4=6 months to less than 1 year; 5=1 year or more; 6=Never [Go to CCC_Q106]; DK,R

26. **CCC_Q105**: ^DOVERB_C ^YOU2 currently take insulin for ^YOUR1 diabetes? - 1=Yes; 2=No; DK,R

27. **CCC_Q106**: In the past month, did ^YOU2 take pills to control ^YOUR1 blood sugar? - 1=Yes; 2=No; DK,R

28. **CCC_Q111**: (Remember, we’re interested in conditions diagnosed by a health professional.) ^DOVERB_C ^YOU2 have epilepsy? - 1=Yes; 2=No; DK,R

29. **CCC_Q121**: (^DOVERB_C ^YOU2 have:) … heart disease? - 1=Yes; 2=No; DK,R

30. **CCC_Q131**: (^DOVERB_C ^YOU2 have:) ... cancer? - 1=Yes [Go to CCC_C133]; 2=No; DK; R [Go to CCC_Q141]

31. **CCC_Q132**: ^HAVE ^YOU1 ever been diagnosed with cancer? - 1=Yes; 2=No [Go to CCC_Q141]; DK,R [Go to CCC_Q141]

- **CCC_C133**: If sex = male, go to CCC_Q133B. Otherwise, go to CCC_Q133A. Note: In processing, responses from CCC_Q133A and CCC_Q133B are combined.

32. **CCC_Q133A**: What type of cancer ^DoDid ^YOU1 have?  - 1=Breast; 2=Colorectal; 3=Skin - Melanoma; 4=Skin - Non-melanoma; 5=Other; DK,R; [Then go to CCC_D133]

33. **CCC_Q133B**: What type of cancer ^DoDid ^YOU1 have?  - 1=Prostate; 2=Colorectal; 3=Skin - Melanoma; 4=Skin - Non-melanoma; 5=Other; DK,R

34. **CCC_Q141**: (Remember, we’re interested in conditions diagnosed by a health professional.) ^DOVERB ^YOU2 have intestinal or stomach ulcers? - 1=Yes; 2=No; DK,R

35. **CCC_Q151**: ^DOVERB ^YOU2 suffer from the effects of a stroke? - 1=Yes; 2=No; DK,R

36. **CCC_Q161**: (^DOVERB ^YOU2 suffer:) ... from urinary incontinence? - 1=Yes; 2=No; DK,R

37. **CCC_Q171**: ^DOVERB_C ^YOU2 suffer from a bowel disorder such as Crohn’s Disease, ulcerative colitis, Irritable Bowel Syndrome or bowel incontinence? - 1=Yes; 2=No [Go to CCC_C181]; DK,R [Go to CCC_C181]

38. **CCC_Q171A**: What kind of bowel disease ^DOVERB ^YOU1 have? - 1=Crohn’s Disease; 2=Ulcerative colitis; 3=Irritable Bowel Syndrome; 4=Bowel incontinence; 5=Other; DK,R

- **CCC_C181**: If age < 18, go to CCC_Q211. Otherwise, go to CCC_Q181.

39. **CCC_Q181**: (Remember, we’re interested in conditions diagnosed by a health professional.) (^DOVERB_C ^YOU2 have:) ... Alzheimer’s Disease or any other dementia? - 1=Yes; 2=No; DK,R

40. **CCC_Q191**: (^DOVERB_C ^YOU2 have:) ... cataracts? - 1=Yes; 2=No; DK,R

41. **CCC_Q201**: (^DOVERB_C ^YOU2 have:) ... glaucoma? - 1=Yes; 2=No; DK,R

42. **CCC_Q211**: (^DOVERB_C ^YOU2 have:) ... a thyroid condition? - 1=Yes; 2=No; DK,R

43. **CCC_Q251**: (Remember, we’re interested in conditions diagnosed by a health professional.) ^DOVERB_C ^YOU2 have chronic fatigue syndrome? - 1=Yes; 2=No; DK,R

44. **CCC_Q261**: ^DOVERB_C ^YOU2 suffer from multiple chemical sensitivities? - 1=Yes; 2=No; DK,R

45. **CCC_Q271**: ^DOVERB_C ^YOU2 have schizophrenia? - 1=Yes; 2=No; DK,R

46. **CCC_Q280**: Remember, we’re interested in conditions diagnosed by a health professional. ^DOVERB_C ^YOU2 have a mood disorder such as depression, bipolar disorder, mania or dysthymia? INTERVIEWER: Include manic depression. - 1=Yes; 2=No; DK,R

47. **CCC_Q290**: (Remember, we’re interested in conditions diagnosed by a health professional.) ^DOVERB_C ^YOU2 have an anxiety disorder such as a phobia, obsessive- compulsive disorder or a panic disorder? - 1=Yes; 2=No; DK,R

48. **CCC_Q321**: ^DOVERB_C ^YOU2 have autism or any other developmental disorder such as Down’s syndrome, Asperger’s syndrome or Rett syndrome? - 1=Yes; 2=No; DK,R

49. **CCC_Q331**: (Remember, we’re interested in conditions diagnosed by a health professional.) ^DOVERB_C ^YOU2 have a learning disability? - 1=Yes; 2=No [Go to CCC_Q341]; DK,R [Go to CCC_Q341]

50. **CCC_Q331A**: What kind of learning disability ^DOVERB ^YOU2 have?  - 1=Attention Deficit Disorder, no hyperactivity (ADD); 2=Attention Deficit Hyperactivity Disorder (ADHD); 3=Dyslexia; 4=Other - Specify; DK,R

- **CCC_C331AS**: If CCC_Q331A = 4, go to CCC_Q331AS. Otherwise, go to CCC_Q341.

51. **CCC_Q331AS**: INTERVIEWER: Specify. ________________________ (80 spaces) - DK,R

52. **CCC_Q341**: ^DOVERB_C ^YOU2 have an eating disorder such as anorexia or bulimia? - 1=Yes; 2=No; DK,R

53. **CCC_Q901**: ^DOVERB_C ^YOU2 have any other long-term physical or mental health condition that has been diagnosed by a health professional? - 1=Yes; 2=No [Go to CCC_END]; DK,R [Go to CCC_END]

- **CCC_C901S**: If CCC_Q901 = 1, go to CCC_Q901S. Otherwise, go to CCC_END.

54. **CCC_Q901S**: INTERVIEWER: Specify. ________________________ (80 spaces) CCC_END - DK,R

---

### DIABETES CARE (DIA) - 27 questions

*[Optional content]*

- **DIA_C01A**: If (do DIA block = 1), go to DIA_C01B.

- **DIA_C01B**: If (CCC_Q101 = 1), go to DIA_C01C. Otherwise, go to DIA_END.

- **DIA_C01C**: If (CCC_Q10A = 1), go to DIA_END. Otherwise, go to DIA_R01.

- *DIA_R01*: It was reported earlier that ^YOU2 ^HAVE diabetes. The following questions are about diabetes care. INTERVIEWER: Press <Enter> to continue.

1. **DIA_Q01**: In the past 12 months, has a health care professional tested ^YOU2 for haemoglobin “A-one-C”? (An “A-one-C” haemoglobin test measures the average level of blood sugar over a 3-month period.) - 1=Yes; 2=No [Go to DIA_Q03]; DK [Go to DIA_Q03]; R [Go to DIA_END]

2. **DIA_Q02**: How many times? (In the past 12 months, has a health care professional tested ^YOU2 for haemoglobin “A-one-C”?) |_|_| Times - DK,R

3. **DIA_Q03**: In the past 12 months, has a health care professional checked ^YOUR1 feet for any sores or irritations? - 1=Yes; 2=No [Go to DIA_Q05]; 3=No feet [Go to DIA_Q05]; DK,R [Go to DIA_Q05]

4. **DIA_Q04**: How many times? (In the past 12 months, has a health care professional checked ^YOUR1 feet for any sores or irritations?) |_|_| Times - DK,R

5. **DIA_Q05**: In the past 12 months, has a health care professional tested ^YOUR1 urine for protein (i.e., Microalbumin)? - 1=Yes; 2=No; DK,R

6. **DIA_Q06**: ^HAVE_C ^YOU2 ever had an eye exam where the pupils of ^YOUR1 eyes were dilated? (This procedure would have made ^HIMHER temporarily sensitive to light.) - 1=Yes; 2=No [Go to DIA_R08]; DK,R [Go to DIA_R08]

7. **DIA_Q07**: When was the last time?  - 1=Less than one month ago; 2=1 month to less than 1 year ago; 3=1 year to less than 2 years ago; 4=2 or more years ago; DK,R

- *DIA_R08*: Now some questions about diabetes care not provided by a health care professional. INTERVIEWER: Press <Enter> to continue.

8. **DIA_Q08**: How often ^DOVERB ^YOU2 usually have ^YOUR1 blood checked for glucose or sugar by ^YOURSELF or by a family member or friend? INTERVIEWER: Select the reporting period here and enter the number in the next screen. - 1=Per day; 2=Per week [Go to DIA_N08C]; 3=Per month [Go to DIA_N08D]; 4=Per year [Go to DIA_N08E]; 5=Never [Go to DIA_C09]; DK,R [Go to DIA_C09]

9. **DIA_N08B**: INTERVIEWER: Enter number of times per day.

10. **DIAE_N8B**: l_l_l Times - DK,R; [Then go to DIA_C09]

11. **DIA_N08C**: INTERVIEWER: Enter number of times per week.

12. **DIAE_N8C**: l_l_l Times - DK,R; [Then go to DIA_C09]

13. **DIA_N08D**: INTERVIEWER: Enter number of times per month.

14. **DIAE_N8D**: l_l_l Times - DK,R; [Then go to DIA_C09]

15. **DIA_N08E**: INTERVIEWER: Enter number of times per year.

16. **DIAE_N8E**: l_l_l Times - DK,R

- **DIA_C09**: If DIA_Q03 = 3 (no feet), go to DIA_C10. Otherwise, go to DIA_Q09.

17. **DIA_Q09**: How often ^DOVERB ^YOU2 usually have ^YOUR1 feet checked for any sores or irritations by ^YOURSELF or by a family member or friend? INTERVIEWER: Select the reporting period here and enter the number in the next screen. - 1=Per day; 2=Per week [Go to DIA_N09C]; 3=Per month [Go to DIA_N09D]; 4=Per year [Go to DIA_N09E]; 5=Never [Go to DIA_C10]; DK,R [Go to DIA_C10]

18. **DIA_N09B**: INTERVIEWER: Enter number of times per day.

19. **DIAE_N9B**: l_l_l Times - DK,R; [Then go to DIA_C10]

20. **DIA_N09C**: INTERVIEWER: Enter number of times per week.

21. **DIAE_N9C**: l_l_l Times - DK,R; [Then go to DIA_C10]

22. **DIA_N09D**: INTERVIEWER: Enter number of times per month.

23. **DIAE_N9D**: l_l_l Times - DK,R; [Then go to DIA_C10]

24. **DIA_N09E**: INTERVIEWER: Enter number of times per year.

25. **DIAE_N9E**: l_l_l Times - DK,R

- **DIA_C10**: If age >= 35, go to DIA_R10. Otherwise, go to DIA_END.

- *DIA_R10*: Now a few questions about medication. INTERVIEWER: Press <Enter> to continue

26. **DIA_Q10**: In the past month, did ^YOU2 take aspirin or other ASA (acetylsalicylic acid) medication every day or every second day? - 1=Yes; 2=No; DK,R

27. **DIA_Q11**: In the past month, did ^YOU1 take prescription medications such as Lipitor or Zocor to control ^YOUR1 blood cholesterol levels? DIA_END - 1=Yes; 2=No; DK,R

---

### MEDICATION USE (MED) - 22 questions

- **MED_C1**: If (do MED block = 1), go to MED_R1.

- *MED_R1*: Now I’d like to ask a few questions about ^YOUR2 use of medications, both prescription and over-the-counter. INTERVIEWER: Press <Enter> to continue.

1. **MED_Q1A**: In the past month, that is, from [date one month ago] to yesterday, did ^YOU2 take: ... pain relievers such as aspirin or Tylenol (including arthritis medicine and anti-inflammatories)? - 1=Yes; 2=No; DK; R [Go to MED_END]

2. **MED_Q1B**: In the past month, that is, from [date one month ago] to yesterday, did ^YOU2 take: ... tranquilizers such as Valium or Ativan? - 1=Yes; 2=No; DK,R

3. **MED_Q1C**: (In the past month, that is, from [date one month ago] to yesterday, did ^YOU2 take:) ... diet pills such Dexatrim, Ponderal or Fastin? - 1=Yes; 2=No; DK,R

4. **MED_Q1D**: (In the past month, that is, from [date one month ago] to yesterday, did In the past month, that is, from [date one month ago] to yesterday, did ^YOU2 take:) ... anti-depressants such as Prozac, Paxil or Effexor? - 1=Yes; 2=No; DK,R

5. **MED_Q1E**: (In the past month, that is, from [date one month ago] to yesterday, did ^YOU2 take:) ... codeine, Demerol or morphine? - 1=Yes; 2=No; DK,R

6. **MED_Q1F**: (In the past month, that is, from [date one month ago] to yesterday, did ^YOU2 take:) ... allergy medicine such as Reactine or Allegra? - 1=Yes; 2=No; DK,R

7. **MED_Q1G**: (In the past month, that is, from [date one month ago] to yesterday, did ^YOU2 take:) ... asthma medications such as inhalers or nebulizers? - 1=Yes; 2=No; DK,R

8. **MED_Q1H**: (In the past month, that is, from [date one month ago] to yesterday, did ^YOU2 take:) ... cough or cold remedies? - 1=Yes; 2=No; DK,R

9. **MED_Q1I**: (In the past month, that is, from [date one month ago] to yesterday, did ^YOU2 take:) ... penicillin or other antibiotics? - 1=Yes; 2=No; DK,R

10. **MED_Q1J**: (In the past month, that is, from [date one month ago] to yesterday, did ^YOU2 take:) ... medicine for the heart? - 1=Yes; 2=No; DK,R

11. **MED_Q1L**: In the past month, that is, from [date one month ago] to yesterday, did ^YOU2 take: ... diuretics or water pills? - 1=Yes; 2=No; DK,R

12. **MED_Q1M**: (In the past month, that is, from [date one month ago] to yesterday, did ^YOU2 take:) ... steroids? - 1=Yes; 2=No; DK,R

13. **MED_Q1P**: (In the past month, that is, from [date one month ago] to yesterday, did ^YOU2 take:) ... sleeping pills such as Imovane, Nytol or Starnoc? - 1=Yes; 2=No; DK,R

14. **MED_Q1Q**: (In the past month, that is, from [date one month ago] to yesterday, did ^YOU2 take:) ... stomach remedies? - 1=Yes; 2=No; DK,R

15. **MED_Q1R**: (In the past month, that is, from [date one month ago] to yesterday, did ^YOU2 take:) ... laxatives? - 1=Yes; 2=No; DK,R

- **MED_C1S**: If sex = female and age <= 49, go to MED_Q1S. Otherwise, go to MED_C1TA.

16. **MED_Q1S**: (In the past month, that is, from [date one month ago] to yesterday, did ^YOU2 take:) ... birth control pills? - 1=Yes; 2=No; DK,R

- **MED_C1TA**: If (do HRT block = 1), go to MED_Q1U. Otherwise, go to MED_C1T.

- **MED_C1T**: If sex is female and age >= 30, go to MED_Q1T. Otherwise, go to MED_Q1U.

17. **MED_Q1T**: (In the past month, that is, from [date one month ago] to yesterday, did ^YOU2 take:) ... hormones for menopause or ageing symptoms? - 1=Yes; 2=No [Go to MED_Q1U]; DK,R [Go to MED_Q1U]

18. **MED_Q1T1**: What type of hormones ^ARE ^YOU1 taking?  - 1=Estrogen only; 2=Progesterone only; 3=Both; 4=Neither; DK,R

19. **MED_Q1T2**: When did ^YOU1 start this hormone therapy? INTERVIEWER: Enter the year (minimum is [year of birth + 30]; maximum is [current year]). |_|_|_|_| Year - DK,R

20. **MED_Q1U**: In the past month, that is, from [date one month ago] to yesterday, did ^YOU2 take: ... thyroid medication such as Synthroid or Levothyroxine? - 1=Yes; 2=No; DK,R

21. **MED_Q1V**: (In the past month, that is, from [date one month ago] to yesterday, did ^YOU2 take:) ... any other medication? - 1=Yes; 2=No; DK,R

- **MED_C1V**: If MED_Q1V = 1, go to MED_Q1VS. Otherwise, go to MED_END.

22. **MED_Q1VS**: INTERVIEWER: Specify. _______________________________ (80 spaces) MED_END - DK,R

---

### HEALTH CARE UTILIZATION (HCU) - 33 questions

- **HCU_C01**: If (HCU block = 1), go to HCU_R01. Otherwise, go to HCU_END.

- *HCU_R01*: Now I’d like to ask about ^YOUR2 contacts with various health professionals during the past 12 months, that is, from [date one year ago] to yesterday. INTERVIEWER: Press <Enter> to continue.

1. **HCU_Q01AA**: ^DOVERB ^YOU2 have a regular medical doctor? - 1=Yes [Go to HCU_Q01AC]; 2=No; DK,R [Go to HCU_Q01BA]

2. **HCU_Q01AB**: Why ^DOVERB ^YOU2 not have a regular medical doctor?  - 1=No medical doctors available in the area; 2=Medical doctors in the area are not taking new patients; 3=Have not tried to contact one; 4=Had a medical doctor who left or retired; 5=Other - Specify; DK,R

- **HCU_C01ABS**: If HCU_Q01AB = 5, go to HCU_Q01ABS. Otherwise, go to HCU_Q01BA.

3. **HCU_Q01ABS**: INTERVIEWER: Specify. ______________________ (80 spaces) - DK,R

4. **HCU_Q01AC**: ^DOVERB_C ^YOU2 and this doctor usually speak in English, in French, or in another language? - 1=English                 13       Portuguese; 2=French                  14       Punjabi; 3=Arabic                  15       Spanish; 4=Chinese                 16       Tagalog (Pilipino); 5=Cree                    17       Ukrainian; 6=German                  18       Vietnamese; 7=Greek                   19       Dutch; 8=Hungarian               20       Hindi; 9=Italian                 21  ...

- **HCU_C01ACS**: If HCU_Q01AC = 23, go to HCU_Q01ACS. Otherwise, go to HCU_Q01BA.

5. **HCU_Q01ACS**: INTERVIEWER: Specify. ________________________ (80 spaces) - DK,R

6. **HCU_Q01BA**: In the past 12 months, ^HAVE ^YOU2 been a patient overnight in a hospital, nursing home or convalescent home? - 1=Yes; 2=No [Go to HCU_Q02A]; DK [Go to HCU_Q02A]; R [Go to HCU_END]

7. **HCU_Q01BB**: For how many nights in the past 12 months? |_|_|_| Nights - DK,R

8. **HCU_Q02A**: [Not counting when ^YOU2 ^WERE an overnight patient, in the past |_|_|_| Times - 12=months/In the past 12 months], how many times ^HAVE ^YOU2 seen,; DK,R

9. **HCU_Q02B**: ([Not counting when ^YOU2 ^WERE an overnight patient, in the past |_|_|_| Times - 12=months/In the past 12 months], how many times ^HAVE ^YOU2 seen,; DK,R

10. **HCU_Q02C**: ([Not counting when ^YOU2 ^WERE an overnight patient, in the past |_|_|_| Times - 12=months/In the past 12 months], how many times ^HAVE ^YOU2 seen,; DK,R

11. **HCU_Q02D**: [Not counting when ^YOU2 ^WERE an overnight patient, in the past |_|_|_| Times - 12=months/In the past 12 months], how many times ^HAVE ^YOU2 seen,; DK,R

12. **HCU_Q02E**: ([Not counting when ^YOU2 ^WERE an overnight patient, in the past |_|_|_| Times - 12=months/In the past 12 months], how many times ^HAVE ^YOU2 seen,; DK,R

13. **HCU_Q02F**: ([Not counting when ^YOU2 ^WERE an overnight patient, in the past |_|_|_| Times - 12=months/In the past 12 months], how many times ^HAVE ^YOU2 seen,; DK,R

14. **HCU_Q02G**: [Not counting when ^YOU2 ^WERE an overnight patient, in the past |_|_|_| Times - 12=months/In the past 12 months], how many times ^HAVE ^YOU2 seen,; DK,R

15. **HCU_Q02H**: ([Not counting when ^YOU2 ^WERE an overnight patient, in the past |_|_|_| Times - 12=months/In the past 12 months], how many times ^HAVE ^YOU2 seen,; DK,R

16. **HCU_Q02I**: ([Not counting when ^YOU2 ^WERE an overnight patient, in the past |_|_|_| Times - 12=months/In the past 12 months], how many times ^HAVE ^YOU2 seen,; DK,R

17. **HCU_Q02J**: [Not counting when ^YOU2 ^WERE an overnight patient, in the past |_|_|_| Times - 12=months/In the past 12 months], how many times ^HAVE ^YOU2 seen,; DK,R

- **HCU_C03**: If HCU_Q02A or HCU_Q02C or HCU_Q02D > 0, go to HCU_Q03. Otherwise, go to HCU_Q04A.

18. **HCU_Q03**: Where did the most recent contact take place? INTERVIEWER: If respondent says “hospital”, probe for details. - 1=Doctor’s office; 2=Hospital emergency room; 3=Hospital outpatient clinic (e.g. day surgery, cancer); 4=Walk-in clinic; 5=Appointment clinic; 6=Community health centre / CLSC; 7=At work; 8=At school; 9=At home; 10=Telephone consultation only; 11=Other - Specify; DK,R

- **HCU_C03S**: If HCU_Q03 = 11, go to HCU_Q03S. Otherwise, go to HCU_C031.

19. **HCU_Q03S**: INTERVIEWER: Specify. _____________________ (80 spaces) - DK,R

- **HCU_C031**: If HCU_Q03 = 3 (Hospital outpatient clinic), or 5 (Appointment clinic) or 6 (Community health centre), go to HCU_Q03_1. Otherwise, go to HCU_Q04A.

20. **HCU_Q03_1**: Did this most recent contact occur:  - 1=… in-person (face-to-face)?; 2=… through a videoconference?; 3=… through another method?; DK,R

21. **HCU_Q04A**: In the past 12 months, ^HAVE ^YOU1 attended a meeting of a self- help group such as AA or a cancer support group? - 1=Yes; 2=No; DK,R

22. **HCU_Q04**: People may also use alternative or complementary medicine. In the past 12 months, ^HAVE ^YOU2 seen or talked to an alternative health care provider such as an acupuncturist, homeopath or massage therapist about ^YOUR1... - 1=Yes; 2=No [Go to HCU_C06]; DK,R [Go to HCU_C06]

23. **HCU_Q05**: Who did ^YOU2 see or talk to?  - 1=Massage therapist; 2=Acupuncturist; 3=Homeopath or naturopath; 4=Feldenkrais or Alexander teacher; 5=Relaxation therapist; 6=Biofeedback teacher; 7=Rolfer; 8=Herbalist; 9=Reflexologist; 10=Spiritual healer; 11=Religious healer; 12=Other - Specify; DK,R

- **HCU_C05S**: If HCU_Q05 = 12, go to HCU_Q05S. Otherwise, go to HCU_C06.

24. **HCU_Q05S**: INTERVIEWER: Specify. _____________________ (80 spaces) - DK,R

- **HCU_C06**: If non-proxy interview, ask “During the past 12 months, was there ever a time when you felt that you needed health care but you didn’t receive it?” in HCU_Q06. If proxy interview and age < 18, ask “During the past 12 months, was there ever a time when you felt that FNAME neede...

25. **HCU_Q06**: . If proxy interview and age >= 18, ask “During the past 12 months, was there ever a time when FNAME felt that [he/she] needed health care but [he/she] didn’t receive it?” in

26. **HCU_Q06**: .

27. **HCU_Q06**: During the past 12 months, was there ever a time when ^YOU2 felt that [you/FNAME/he/she] needed health care but ^YOU1 didn’t receive it? - 1=Yes; 2=No [Go to HCU_END]; DK,R [Go to HCU_END]

28. **HCU_Q07**: Thinking of the most recent time, why didn’t ^YOU1 get care?  - 1=Not available - in the area; 2=Not available - at time required (e.g. doctor on holidays, inconvenient; 3=Waiting time too long; 4=Felt would be inadequate; 5=Cost; 6=Too busy; 7=Didn’t get around to it / didn’t bother; 8=Didn’t know where to go; 9=Transportation problems; 10=Language problems; 11=Personal or family responsibilities; 12=Dislikes doctors / afraid; 13=Decided not to seek care; ...

- **HCU_C07S**: If HCU_Q07 = 16, go to HCU_Q07S. Otherwise, go to HCU_Q08.

29. **HCU_Q07S**: INTERVIEWER: Specify. _____________________ (80 spaces) - DK,R

30. **HCU_Q08**: Again, thinking of the most recent time, what was the type of care that was needed?  - 1=Treatment of - a physical health problem; 2=Treatment of - an emotional or mental health problem; 3=A regular check-up (including regular pre-natal care); 4=Care of an injury; 5=Other - Specify; DK,R

- **HCU_C08S**: If HCU_Q08 = 5, go to HCU_Q08S. Otherwise, go to HCU_Q09.

31. **HCU_Q08S**: INTERVIEWER: Specify. _____________________ (80 spaces) - DK,R

32. **HCU_Q09**: Where did ^YOU1 try to get the service ^YOU1 ^WERE seeking?  - 1=Doctor’s office; 2=Hospital - emergency room; 3=Hospital - overnight patient; 4=Hospital - outpatient clinic (e.g., day surgery, cancer); 5=Walk-in clinic; 6=Appointment clinic; 7=Community health centre / CLSC; 8=Other - Specify; DK,R

- **HCU_C09S**: If HCU_Q09 = 8, go to HCU_Q09S. Otherwise, go to HCU_END.

33. **HCU_Q09S**: INTERVIEWER: Specify. _____________________ (80 spaces) HCU_END - DK,R

---

### HOME CARE SERVICES (HMC) - 15 questions

*[Optional content]*

- **HMC_C09A**: If (do HMC block = 1), go to HMC_C09B. Otherwise, go to HMC_END.

- **HMC_C09B**: If age < 18, go to HMC_END. Otherwise, go to HMC_R09.

- *HMC_R09*: Now some questions on home care services. These are health care, home maker or other support services received at home. People may receive home care due to a health problem or condition that affects their daily activi...

1. **HMC_Q09**: ^HAVE_C ^YOU2 received any home care services in the past 12 months, with the cost being entirely or partially covered by government? - 1=Yes; 2=No [Go to HMC_Q11]; DK [Go to HMC_Q11]; R [Go to HMC_END]

2. **HMC_Q10**: What type of services ^HAVE ^YOU1 received? Mark all that apply. Cost must be entirely or partially covered by government. - 1=Nursing care (e.g., dressing changes, preparing medications,; 2=Other health care services (e.g., physiotherapy, occupational or; 3=Medical equipment or supplies; 4=Personal care (e.g., bathing, foot care); 5=Housework (e.g., cleaning, laundry); 6=Meal preparation or delivery; 7=Shopping; 8=Respite care (i.e., caregiver relief); 9=Other - Specify; DK,R

- **HMC_C10S**: If HMC_Q10 = 9, go to HMC_Q10S. Otherwise, go to HMC_Q11.

3. **HMC_Q10S**: INTERVIEWER: Specify. ______________________________ (80 spaces) - DK,R

4. **HMC_Q11**: ^HAVE ^YOU2 received any [other] home care services in the past 12 months, with the cost not covered by government (for example: care provided by a private agency or by a spouse or friends)? INTERVIEWER: Include only ... - 1=Yes; 2=No [Go to HMC_Q14]; DK,R [Go to HMC_Q14]

5. **HMC_Q12**: Who provided these [other] home care services? Mark all that apply. - 1=Nurse from a private agency; 2=Homemaker or other support services from a private agency; 3=Physiotherapist or other therapist from a private agency; 4=Neighbour or friend; 5=Family member or spouse; 6=Volunteer; 7=Other - Specify; DK,R

- **HMC_C12S**: If HMC_Q12 = 7, go to HMC_Q12S. Otherwise, go to HMC_C13.

6. **HMC_Q12S**: INTERVIEWER: Specify. _________________________ (80 spaces) - DK,R

- **HMC_C13**: For each person identified in HMC_Q12, ask HMC_Q13n up to 7 times, n = where A, B, C, D, E, F, G.

7. **HMC_Q13n**: What type of services ^HAVE ^YOU1 received from [person identified in

8. **HMC_Q12**: ]? Mark all that apply. - 1=Nursing care (e.g., dressing changes, preparing medications,; 2=Other health care services (e.g., physiotherapy, occupational or; 3=Medical equipment or supplies; 4=Personal care (e.g., bathing, foot care); 5=Housework (e.g., cleaning, laundry); 6=Meal preparation or delivery; 7=Shopping; 8=Respite care (i.e., caregiver relief); 9=Other - Specify; DK,R

- **HMC_C13S**: If HMC_Q13 = 9, go to HMC_Q13S. Otherwise, go to HMC_Q14.

9. **HMC_Q13S**: INTERVIEWER: Specify. _________________________ (80 spaces) - DK,R

10. **HMC_Q14**: During the past 12 months, was there ever a time when ^YOU2 felt that ^YOU1 needed home care services but ^YOU1 didn’t receive them? - 1=Yes; 2=No [Go to HMC_END]; DK,R [Go to HMC_END]

11. **HMC_Q15**: Thinking of the most recent time, why didn’t ^YOU1 get these services?  - 1=Not available - in the area; 2=Not available - at time required (e.g., inconvenient hours); 3=Waiting time too long; 4=Felt would be inadequate; 5=Cost; 6=Too busy; 7=Didn’t get around to it / didn’t bother; 8=Didn’t know where to go / call; 9=Language problems; 10=Personal or family responsibilities; 11=Decided not to seek services; 12=Doctor - did not think it was necessary; 13=Did not qual...

- **HMC_C15S**: If HMC_Q15 = 15, go to HMC_Q15S. Otherwise, go to HMC_Q16.

12. **HMC_Q15S**: INTERVIEWER: Specify. _________________________ (80 spaces) - DK,R

13. **HMC_Q16**: Again, thinking of the most recent time, what type of home care was needed?  - 1=Nursing care (e.g., dressing changes, preparing medications,; 2=Other health care services (e.g., physiotherapy, occupational or; 3=Medical equipment or supplies; 4=Personal care (e.g., bathing, foot care); 5=Housework (e.g., cleaning, laundry); 6=Meal preparation or delivery; 7=Shopping; 8=Respite care (i.e., caregiver relief); 9=Other - Specify; DK,R

- **HMC_C16S**: If HMC_Q16 = 9, go to HMC_Q16S. Otherwise, go to HMC_Q17.

14. **HMC_Q16S**: INTERVIEWER: Specify. _______________________ (80 spaces) - DK,R

15. **HMC_Q17**: Where did ^YOU2 try to get this home care service? HMC_END - 1=A government sponsored program; 2=A private agency; 3=A family member, friend or neighbour; 4=A volunteer organization; 5=Other; DK,R

---

### PATIENT SATISFACTION (PAS) - 16 questions

*[Optional content]*

- **PAS_C11A**: If (do block = 1), go to PAS_C11B. Otherwise, go to PAS_END.

- **PAS_C11B**: If proxy interview or if age < 15, go to PAS_END. Otherwise, go to PAS_R1.

- *PAS_R1*: Earlier, I asked about your use of health care services in the past 12 months. Now I’d like to get your opinion on the quality of the care you received. INTERVIEWER: Press <Enter> to continue.

- **PAS_C11D**: If HCU_Q01BA = 1 or at least one of HCU_Q02A to HCU_Q02J > 0, go to PAS_Q12. Otherwise, go to PAS_Q11. Note: In processing, if a respondent answered HCU_Q01BA = 1 or at least one of HCU_Q02A to HCU_Q02J > 0, set PAS_Q11 = 1.

1. **PAS_Q11**: In the past 12 months, have you received any health care services? - 1=Yes; 2=No [Go to PAS_Q51]; DK,R [Go to PAS_Q51]

2. **PAS_Q12**: Overall, how would you rate the quality of the health care you received? Would you say it was:  - 1=… excellent?; 2=… good?; 3=… fair?; 4=… poor?; DK,R

3. **PAS_Q13**: Overall, how satisfied were you with the way health care services were provided? Were you:  - 1=… very satisfied?; 2=… somewhat satisfied?; 3=… neither satisfied nor dissatisfied?; 4=… somewhat dissatisfied?; 5=… very dissatisfied?; DK,R

4. **PAS_Q21A**: In the past 12 months, have you received any health care services at a hospital, for any diagnostic or day surgery service, overnight stay, or as an emergency room patient? - 1=Yes; 2=No [Go to PAS_Q31A]; DK,R [Go to PAS_Q31A]

5. **PAS_Q21B**: Thinking of your most recent hospital visit, were you:  - 1=… admitted overnight or longer (an inpatient)?; 2=… a patient at a diagnostic or day surgery clinic (an outpatient)?; 3=… an emergency room patient?; DK,R [Go to PAS_Q31A]

6. **PAS_Q22**: (Thinking of this most recent hospital visit:) … how would you rate the quality of the care you received? Would you say it was:  - 1=… excellent?; 2=… good?; 3=… fair?; 4=… poor?; DK,R

7. **PAS_Q23**: (Thinking of this most recent hospital visit:) … how satisfied were you with the way hospital services were provided? Were you:  - 1=… very satisfied?; 2=… somewhat satisfied?; 3=… neither satisfied nor dissatisfied?; 4=… somewhat dissatisfied?; 5=… very dissatisfied?; DK,R

8. **PAS_Q31A**: In the past 12 months, not counting hospital visits, have you received any health care services from a family doctor or other physician? - 1=Yes; 2=No [Go to PAS_R2]; DK,R [Go to PAS_R2]

9. **PAS_Q31B**: Thinking of the most recent time, was care provided by:  - 1=… a family doctor (general practitioner)?; 2=… a medical specialist?; DK,R [Go to PAS_R2]

10. **PAS_Q32**: (Thinking of this most recent care from a physician:) … how would you rate the quality of the care you received? Would you say it was:  - 1=… excellent?; 2=… good?; 3=… fair?; 4=… poor?; DK,R

11. **PAS_Q33**: (Thinking of this most recent care from a physician:) … how satisfied were you with the way physician care was provided? Were you:  - 1=… very satisfied?; 2=… somewhat satisfied?; 3=… neither satisfied nor dissatisfied?; 4=… somewhat dissatisfied?; 5=… very dissatisfied?; DK,R

- *PAS_R2*: The next questions are about community-based health care which includes any health care received outside of a hospital or doctor’s office. Examples are: home nursing care, home-based counselling or therapy, personal c...

12. **PAS_Q41**: In the past 12 months, have you received any community-based care? - 1=Yes; 2=No [Go to PAS_Q51]; DK,R [Go to PAS_Q51]

13. **PAS_Q42**: Overall, how would you rate the quality of the community-based care you received? Would you say it was:  - 1=… excellent?; 2=… good?; 3=… fair?; 4=… poor?; DK,R

14. **PAS_Q43**: Overall, how satisfied were you with the way community-based care was provided? Were you:  - 1=… very satisfied?; 2=… somewhat satisfied?; 3=… neither satisfied nor dissatisfied?; 4=… somewhat dissatisfied?; 5=… very dissatisfied?; DK,R

15. **PAS_Q51**: In the past 12 months, have you used a telephone health line or telehealth service? - 1=Yes; 2=No [Go to PAS_END]; DK,R [Go to PAS_END]

16. **PAS_Q52**: Overall, how would you rate the quality of the service you received? Would you say it was: PAS_END - 1=… excellent?; 2=… good?; 3=… fair?; 4=… poor?; DK,R

---

### RESTRICTION OF ACTIVITIES (RAC) - 21 questions

- **RAC_C1**: If (do RAC block = 1), go to RAC_R1. Otherwise, go to RAC_END.

- *RAC_R1*: The next few questions deal with any current limitations in ^YOUR2 daily activities caused by a long-term health condition or problem. In these questions, a “long-term condition” refers to a condition that is expected...

1. **RAC_Q1**: ^DOVERB ^YOU1 have any difficulty hearing, seeing, communicating, walking, climbing stairs, bending, learning or doing any similar activities?  - 1=Sometimes; 2=Often; 3=Never; DK; R [Go to RAC_END]

2. **RAC_Q2A**: Does a long-term physical condition or mental condition or health problem, reduce the amount or the kind of activity ^YOU1 can do: … at home?  - 1=Sometimes; 2=Often; 3=Never; DK; R [Go to RAC_END]

3. **RAC_Q2B_1**: (Does a long-term physical condition or mental condition or health problem, reduce the amount or the kind of activity ^YOU1 can do:) … at school? - 1=Sometimes; 2=Often; 3=Never; 4=Does not attend school; DK; R [Go to RAC_END]

4. **RAC_Q2B_2**: (Does a long-term physical condition or mental condition or health problem, reduce the amount or the kind of activity ^YOU1 can do:) … at work? - 1=Sometimes; 2=Often; 3=Never; 4=Does not work at a job; DK; R [Go to RAC_END]

5. **RAC_Q2C**: (Does a long-term physical condition or mental condition or health problem, reduce the amount or the kind of activity ^YOU1 can do:) … in other activities, for example, transportation or leisure? - 1=Sometimes; 2=Often; 3=Never; DK; R [Go to RAC_END]

- **RAC_C5**: If respondent has difficulty or is limited in activities (RAC_Q1 = 1 or 2) or (RAC_Q2A-C = 1 or 2), go to RAC_C5A. Otherwise, go to RAC_Q6A.

- **RAC_C5A**: If (RAC_Q2A to RAC_Q2C = 3 or 4) and RAC_Q1 < 3 go to RAC_R5. Otherwise, go to RAC_Q5.

- *RAC_R5*: You reported that ^YOU2 ^HAVE difficulty hearing, seeing, communicating, walking, climbing stairs, bending, learning or doing any similar activities.

6. **RAC_Q5**: Which one of the following is the best description of the cause of this condition?  - 1=Accident at home; 2=Motor vehicle accident; 3=Accident at work; 4=Other type of accident; 5=Existed from birth or genetic; 6=Work conditions; 7=Disease or illness; 8=Ageing; 9=Emotional or mental health problem or condition; 10=Use of alcohol or drugs; 11=Other - Specify; DK,R

- **RAC_C5S**: If RAC_Q5 = 11, go to RAC_Q5S. Otherwise, go to RAC_Q5B_1.

7. **RAC_Q5S**: INTERVIEWER: Specify. ________________________ (80 spaces) - DK,R

8. **RAC_Q5B_1**: Because of ^YOUR1 condition or health problem, ^HAVE ^YOU1 ever experienced discrimination or unfair treatment? - 1=Yes; 2=No [Go to RAC_Q6A]; DK,R [Go to RAC_Q6A]

9. **RAC_Q5B_2**: In the past 12 months, how much discrimination or unfair treatment did ^YOU1 experience? - 1=A lot; 2=Some; 3=A little; 4=None at all; DK,R

10. **RAC_Q6A**: The next few questions may not apply to ^YOU2, but we need to ask the same questions of everyone. Because of any physical condition or mental condition or health problem, ^DOVERB ^YOU1 need the help of another person:... - 1=Yes; 2=No; DK,R

11. **RAC_Q6B_1**: (Because of any physical condition or mental condition or health problem, ^DOVERB ^YOU1 need the help of another person:) … with getting to appointments and running errands such as shopping for groceries? - 1=Yes; 2=No; DK,R

12. **RAC_Q6C**: (Because of any physical condition or mental condition or health problem, ^DOVERB ^YOU1 need the help of another person:) ... with doing everyday housework? - 1=Yes; 2=No; DK,R

13. **RAC_Q6D**: (Because of any physical condition or mental condition or health problem, ^DOVERB ^YOU1 need the help of another person:) ... with doing heavy household chores such as spring cleaning or yard work? - 1=Yes; 2=No; DK,R

14. **RAC_Q6E**: (Because of any physical condition or mental condition or health problem, ^DOVERB ^YOU1 need the help of another person:) ... with personal care such as washing, dressing, eating or taking medication? - 1=Yes; 2=No; DK,R

15. **RAC_Q6F**: (Because of any physical condition or mental condition or health problem, ^DOVERB ^YOU1 need the help of another person:) ... with moving about inside the house? - 1=Yes; 2=No; DK,R

16. **RAC_Q6G**: (Because of any physical condition or mental condition or health problem, ^DOVERB ^YOU1 need the help of another person:) ... with looking after ^YOUR1 personal finances such as making bank transactions or paying bills? - 1=Yes; 2=No; DK,R

17. **RAC_Q7A**: Because of any physical condition or mental condition or health problem, ^DOVERB ^YOU1 have difficulty: … making new friends or maintaining friendships? - 1=Yes; 2=No; DK,R

18. **RAC_Q7B**: (Because of any physical condition or mental condition or health problem, ^DOVERB ^YOU1 have difficulty:) … dealing with people ^YOU1 ^DOVERB not know well? - 1=Yes; 2=No; DK,R

19. **RAC_Q7C**: (Because of any physical condition or mental condition or health problem, ^DOVERB ^YOU1 have difficulty:) … starting and maintaining a conversation? - 1=Yes; 2=No; DK,R

- **RAC_C8**: If any of RAC_Q6A to RAC_Q6G or RAC_Q7A to RAC_Q7C = 1, go to RAC_Q8. Otherwise, go to RAC_END.

20. **RAC_Q8**: Are these difficulties due to YOUR1 physical health, to YOUR1 emotional or mental health, to YOUR1 use of alcohol or drugs, or to another reason?  - 1=Physical health; 2=Emotional or mental health; 3=Use of alcohol or drugs; 4=Another reason – Specify; DK,R

- **RAC_C8S**: If RAC_Q8 = 4, go to RAC_Q8S. Otherwise, go to RAC_END.

21. **RAC_Q8S**: INTERVIEWER: Specify. ___________________ (80 spaces) RAC_END - DK,R

---

### TWO-WEEK DISABILITY (TWD) - 12 questions

- **TWD_C1**: If (do TWD block = 1), go to TWD_QINT. Otherwise, go to TWD_END.

- *TWD_QINT*: The next few questions ask about ^YOUR2 health during the past 14 days. It is important for you to refer to the 14-day period from [date two weeks ago] to [date yesterday]. INTERVIEWER: Press <Enter> to continue.

1. **TWD_Q1**: During that period, did ^YOU2 stay in bed at all because of illness or injury, including any nights spent as a patient in a hospital? - 1=Yes; 2=No [Go to TWD_Q3]; DK,R [Go to TWD_END]

2. **TWD_Q2**: How many days did ^YOU1 stay in bed for all or most of the day? INTERVIEWER: Enter 0 if less than a day. |_|_| Days - DK,R [Go to TWD_END]

- **TWD_C2A**: If TWD_Q2 > 1, go to TWD_Q2B.

3. **TWD_Q2A**: Was that due to ^YOUR1 emotional or mental health or ^YOUR1 use of alcohol or drugs? - 1=Yes; 2=No; DK,R; [Then go to TWD_C3]

4. **TWD_Q2B**: How many of these [TWD_Q2] days were due to ^YOUR1 emotional or mental health or ^YOUR1 use of alcohol or drugs? INTERVIEWER: Minimum is 0; maximum is [TWD_Q2]. |_|_| Days - DK,R

- **TWD_C3**: If TWD_Q2 = 14 days, go to TWD_END.

5. **TWD_Q3**: [Not counting days spent in bed, during those 14 days,/During those 14 days,] were there any days that ^YOU2 cut down on things ^YOU1 normally ^DOVERB because of illness or injury? - 1=Yes; 2=No [Go to TWD_Q5]; DK,R [Go to TWD_Q5]

6. **TWD_Q4**: How many days did ^YOU2 cut down on things for all or most of the day? INTERVIEWER: Enter 0 if less than a day. Maximum is [14 - TWD_Q2]. |_|_| Days - DK,R [Go to TWD_Q5]

- **TWD_C4A**: If TWD_Q4 > 1, go to TWD_Q4B.

7. **TWD_Q4A**: Was that due to ^YOUR1 emotional or mental health or ^YOUR1 use of alcohol or drugs? - 1=Yes; 2=No; DK,R; [Then go to TWD_Q5]

8. **TWD_Q4B**: How many of these [TWD_Q4] days were due to ^YOUR1 emotional or mental health or YOUR1 use of alcohol or drugs? INTERVIEWER: Minimum is 0; maximum is [TWD_Q4]. |_|_| Days - DK,R

9. **TWD_Q5**: [Not counting days spent in bed, during those 14 days,/During those 14 days,] were there any days when it took extra effort to perform up to ^YOUR1 usual level at work or at ^YOUR1 other daily activities, because of i... - 1=Yes; 2=No [Go to TWD_END]; DK,R [Go to TWD_END]

10. **TWD_Q6**: How many days required extra effort? INTERVIEWER: Enter 0 if less than a day. Maximum is [14 - TWD_Q2]. |_|_| Days - DK,R [Go to TWD_END]

- **TWD_C6A**: If TWD_Q6 > 1, go to TWD_Q6B. Otherwise, go to TWD_Q6A.

11. **TWD_Q6A**: Was that due to ^YOUR1 emotional or mental health or ^YOUR1 use of alcohol or drugs? - 1=Yes; 2=No; DK,R; [Then go to TWD_END]

12. **TWD_Q6B**: How many of these [TWD_Q6] days were due to ^YOUR1 emotional or mental health or YOUR1 use of alcohol or drugs? INTERVIEWER: Minimum is 0; maximum is [TWD_Q6]. |_|_| Days TWD_END - DK,R

---

### FLU SHOTS (FLU) - 4 questions

- **FLU_C1**: If (do FLU block = 1), then go to FLU_C160. Otherwise, go to FLU_END.

- **FLU_C160**: If proxy interview, go to FLU_END. Otherwise, go to FLU_Q160.

1. **FLU_Q160**: Now a few questions about your use of various health care services. Have you ever had a flu shot? - 1=Yes; 2=No [Go to FLU_Q166]; DK,R [Go to FLU_END]

2. **FLU_Q162**: When did you have your last flu shot?  - 1=Less than 1 year ago [Go to FLU_END]; 2=1 year to less than 2 years ago; 3=2 years ago or more; DK,R [Go to FLU_END]

3. **FLU_Q166**: What are the reasons that you have not had a flu shot in the past year?  - 1=Have not gotten around to it; 2=Respondent - did not think it was necessary; 3=Doctor - did not think it was necessary; 4=Personal or family responsibilities; 5=Not available - at time required; 6=Not available - at all in the area; 7=Waiting time was too long; 8=Transportation - problems; 9=Language - problem; 10=Cost; 11=Did not know where to go / uninformed; 12=Fear (e.g., painful, embarra...

- **FLU_C166S**: If FLU_Q166 = 15, go to FLU_Q166S. Otherwise, go to FLU_END.

4. **FLU_Q166S**: INTERVIEWER: Specify. _________________________ (80 spaces) FLU_END - DK,R

---

### BLOOD PRESSURE CHECK (BPC) - 4 questions

- **BPC_C01**: If (do BPC block = 2) or proxy interview, go to BPC_END.

1. **BPC_Q010**: (Now blood pressure) Have you ever had your blood pressure taken? - 1=Yes; 2=No [Go to BPC_C016]; DK,R [Go to BPC_END]

2. **BPC_Q012**: When was the last time? - 1=Less than 6 months ago [Go to BPC_END]; 2=6 months to less than 1 year ago [Go to BPC_END]; 3=1 year to less than 2 years ago [Go to BPC_END]; 4=2 years to less than 5 years ago; 5=5 or more years ago; DK,R [Go to BPC_END]

- **BPC_C016**: If age < 25, go to BPC_END. Otherwise, go to BPC_Q016.

3. **BPC_Q016**: What are the reasons that you have not had your blood pressure taken in the past - 2=years?; 1=Have not gotten around to it; 2=Respondent - did not think it was necessary; 3=Doctor - did not think it was necessary; 4=Personal or family responsibilities; 5=Not available - at time required; 6=Not available - at all in the area; 7=Waiting time was too long; 8=Transportation - problems; 9=Language - problem; 10=Cost; 11=Did not know where to go / uninformed; 12=Fear (e.g., painfu...

- **BPC_C016S**: If BPC_Q016 = 14, go to BPC_Q016S. Otherwise, go to BPC_END.

4. **BPC_Q016S**: INTERVIEWER: Specify. _________________________ (80 spaces) BPC_END - DK,R

---

### PAP SMEAR TEST (PAP) - 4 questions

- **PAP_C1**: If (do PAP block = 1), go to PAP_C020. Otherwise, go to PAP_END.

- **PAP_C020**: If proxy interview or male or age < 18, go to PAP_END. Otherwise, go to PAP_Q020.

1. **PAP_Q020**: (Now PAP tests) Have you ever had a PAP smear test? - 1=Yes; 2=No [Go to PAP_Q026]; DK,R [Go to PAP_END]

2. **PAP_Q022**: When was the last time? - 1=Less than 6 months ago [Go to PAP_END]; 2=6 months to less than 1 year ago [Go to PAP_END]; 3=1 year to less than 3 years ago [Go to PAP_END]; 4=3 years to less than 5 years ago; 5=5 or more years ago; DK,R [Go to PAP_END]

3. **PAP_Q026**: What are the reasons that you have not had a PAP smear test in the past 3 years?  - 1=Have not gotten around to it; 2=Respondent - did not think it was necessary; 3=Doctor - did not think it was necessary; 4=Personal or family responsibilities; 5=Not available - at time required; 6=Not available - at all in the area; 7=Waiting time was too long; 8=Transportation - problems; 9=Language - problem; 10=Cost; 11=Did not know where to go / uninformed; 12=Fear (e.g., painful, embarra...

- **PAP_C026S**: If PAP_Q026 = 16, go to PAP_Q026S. Otherwise, go to PAP_END.

4. **PAP_Q026S**: INTERVIEWER: Specify. ____________________________ (80 spaces) PAP_END - DK,R

---

### MAMMOGRAPHY (MAM) - 8 questions

- **MAM_C1**: If (do MAM block = 1), go to MAM_C030. Otherwise, go to MAM_END.

- **MAM_C030**: If proxy interview or male, go to MAM_END. Otherwise, go to MAM_C030A.

- **MAM_C030A**: If (female and age < 35), go to MAM_C037. Otherwise, go to MAM_Q030.

1. **MAM_Q030**: (Now Mammography) Have you ever had a mammogram, that is, a breast x-ray? - 1=Yes; 2=No [Go to MAM_C036]; DK,R [Go to MAM_END]

2. **MAM_Q031**: Why did you have it? If respondent says “doctor recommended it”, probe for reason. - 1=Family history of breast cancer; 2=Part of regular check-up / routine screening; 3=Age; 4=Previously detected lump; 5=Follow-up of breast cancer treatment; 6=On hormone replacement therapy; 7=Breast problem; 8=Other - Specify; DK,R

- **MAM_C031S**: If MAM_Q031 = 8, go to MAM_Q031S. Otherwise, go to MAM_Q032.

3. **MAM_Q031S**: INTERVIEWER: Specify. _______________________________ (80 spaces) - DK,R

4. **MAM_Q032**: When was the last time? - 1=Less than 6 months ago [Go to MAM_C037]; 2=6 months to less than 1 year ago [Go to MAM_C037]; 3=1 year to less than 2 years ago [Go to MAM_C037]; 4=2 years to less than 5 years ago; 5=5 or more years ago; DK,R [Go to MAM_C037]

- **MAM_C036**: If age < 50 or age > 69, go to MAM_C037. Otherwise, go to MAM_Q036.

5. **MAM_Q036**: What are the reasons you have not had one in the past 2 years?  - 1=Have not gotten around to it; 2=Respondent - did not think it was necessary; 3=Doctor - did not think it was necessary; 4=Personal or family responsibilities; 5=Not available - at time required; 6=Not available - at all in the area; 7=Waiting time was too long; 8=Transportation - problems; 9=Language - problem; 10=Cost; 11=Did not know where to go / uninformed; 12=Fear (e.g., painful, embarra...

- **MAM_C036S**: If MAM_Q036 = 15, go to MAM_Q036S. Otherwise, go to MAM_C037.

6. **MAM_Q036S**: INTERVIEWER: Specify. _______________________________ (80 spaces) - DK,R

- **MAM_C037**: If (age < 15 or age > 49), go to MAM_C038. Otherwise, go to MAM_Q037.

7. **MAM_Q037**: It is important to know when analyzing health whether or not the person is pregnant. Are you pregnant? - 1=Yes [Go to MAM_END]; 2=No; DK,R

- **MAM_C038**: If age < 18, go to MAM_END. Otherwise, go to MAM_C038A.

- **MAM_C038A**: If PAP_Q026 = 13, go to MAM_END. Otherwise, go to MAM_Q038.

8. **MAM_Q038**: Have you had a hysterectomy? (in other words, has your uterus been removed)? MAM_END - 1=Yes; 2=No; DK,R

---

### BREAST EXAMINATIONS (BRX) - 4 questions

- **BRX_C1**: If (do BRX block = 1), go to BRX_C110.

- **BRX_C110**: If proxy interview or sex = male or age < 18, go to BRX_END. Otherwise, go to BRX_Q110.

1. **BRX_Q110**: (Now breast examinations) Other than a mammogram, have you ever had your breasts examined for lumps (tumours, cysts) by a doctor or other health professional? - 1=Yes; 2=No [Go to BRX_Q116]; DK,R [Go to BRX_END]

2. **BRX_Q112**: When was the last time? - 1=Less than 6 months ago [Go to BRX_END]; 2=6 months to less than 1 year ago [Go to BRX_END]; 3=1 year to less than 2 years ago [Go to BRX_END]; 4=2 years to less than 5 years ago; 5=5 or more years ago; DK,R [Go to BRX_END]

3. **BRX_Q116**: What are the reasons that you have not had a breast exam in the past 2 years?  - 1=Have not gotten around to it; 2=Respondent - did not think it was necessary; 3=Doctor - did not think it was necessary; 4=Personal or family responsibilities; 5=Not available - at time required; 6=Not available - at all in the area; 7=Waiting time was too long; 8=Transportation - problems; 9=Language - problem; 10=Cost; 11=Did not know where to go / uninformed; 12=Fear (e.g., painful, embarra...

- **BRX_C116S**: If BRX_Q116 = 15, go to BRX_Q116S. Otherwise, go to BRX_END.

4. **BRX_Q116S**: INTERVIEWER: Specify. _________________________ (80 spaces) BRX_END - DK,R

---

### BREAST SELF-EXAMINATIONS (BSX) - 4 questions

- **BSX_C120A**: If (do BSX block = 1), go to BSX_C120B. BSXEOPT Otherwise, go to BSX_END.

- **BSX_C120B**: If proxy interview, go to BSX_END. Otherwise, go to BSX_C120C.

- **BSX_C120C**: If male or age < 18, go to BSX_END. Otherwise, go to BSX_Q120.

1. **BSX_Q120**: (Now breast self examinations) Have you ever examined your breasts for lumps (tumours, cysts)? - 1=Yes; 2=No [Go to BSX_END]; DK,R [Go to BSX_END]

2. **BSX_Q121**: How often? - 1=At least once a month; 2=Once every 2 to 3 months; 3=Less often than every 2 to 3 months; DK,R

3. **BSX_Q122**: How did you learn to do this?  - 1=Doctor; 2=Nurse; 3=Book / magazine / pamphlet; 4=TV / video / film; 5=Family member (e.g., mother, sister, cousin); 6=Other - Specify; DK,R

- **BSX_C122S**: If BSX_Q122 = 6, go to BSX_ Q122S. Otherwise, go to BSX_END.

4. **BSX_Q122S**: INTERVIEWER: Specify. _________________________ (80 spaces) BSX_END - DK,R

---

### EYE EXAMINATIONS (EYX) - 4 questions

- **EYX_C140A**: If (EYX block = 2) or proxy interview, go to EYX_END.

- **EYX_C140B**: If HCU_Q02B = 0, DK or R (not seen or talked to eye doctor), go to EYX_Q142. Otherwise, go to EYX_Q140.

1. **EYX_Q140**: (Now eye examinations) It was reported earlier that you have “seen” or “talked to” an optometrist or ophthalmologist in the past 12 months. Did you actually visit one? - 1=Yes; 2=No; DK,R [Go to EYX_END]

2. **EYX_Q142**: When did you last have an eye examination? - 1=Less than 1 year ago [Go to EYX_END]; 2=1 year to less than 2 years ago [Go to EYX_END]; 3=2 years to less than 3 years ago; 4=3 or more years ago; 5=Never; DK,R [Go to EYX_END]

3. **EYX_Q146**: What are the reasons that you have not had an eye examination in the past - 2=years?; 1=Have not gotten around to it; 2=Respondent - did not think it was necessary; 3=Doctor - did not think it was necessary; 4=Personal or family responsibilities; 5=Not available - at time required; 6=Not available - at all in the area; 7=Waiting time was too long; 8=Transportation - problems; 9=Language - problem; 10=Cost; 11=Did not know where to go / uninformed; 12=Fear (e.g., painfu...

- **EYX_C146S**: If EYX_Q146 = 14, go to EYX_Q146S. Otherwise, go to EYX_END.

4. **EYX_Q146S**: INTERVIEWER: Specify. _________________________ (80 spaces) EYX_END - DK,R

---

### PHYSICAL CHECK-UP (PCU) - 5 questions

- **PCU_C1**: If (PCU block = 1), go to PCU_C150.

- **PCU_C150**: If proxy interview, go to PCU_END. Otherwise, go to PCU_Q150.

1. **PCU_Q150**: (Now physical check-ups) Have you ever had a physical check-up without having a specific health problem? - 1=Yes [Go to PCU_Q152]; 2=No; DK,R [Go to PCU_END]

2. **PCU_Q151**: Have you ever had one during a visit for a health problem? - 1=Yes; 2=No [Go to PCU_Q156]; DK,R [Go to PCU_END]

3. **PCU_Q152**: When was the last time? - 1=Less than 1 year ago [Go to PCU_END]; 2=1 year to less than 2 years ago [Go to PCU_END]; 3=2 years to less than 3 years ago [Go to PCU_END]; 4=3 years to less than 4 years ago; 5=4 years to less than 5 years ago; 6=5 or more years ago; DK,R [Go to PCU_END]

4. **PCU_Q156**: What are the reasons that you have not had a check-up in the past 3 years?  - 1=Have not gotten around to it; 2=Respondent - did not think it was necessary; 3=Doctor - did not think it was necessary; 4=Personal or family responsibilities; 5=Not available - at time required; 6=Not available - at all in the area; 7=Waiting time was too long; 8=Transportation - problems; 9=Language - problem; 10=Cost; 11=Did not know where to go / uninformed; 12=Fear (e.g., painful, embarra...

- **PCU_C156S**: If PCU_Q156 = 14, go to PCU_Q156S. Otherwise, go to PCU_END.

5. **PCU_Q156S**: INTERVIEWER: Specify. _______________________________ (80 spaces) PCU_END - DK,R

---

### PROSTATE CANCER SCREENING (PSA) - 6 questions

*[Optional content]*

- **PSA_C1**: If (do PSA block = 1), go to PSA_C170.

- **PSA_C170**: If proxy interview, go to PSA_END. Otherwise, go to PSA_C170A.

- **PSA_C170A**: If female or age < 35, go to PSA_END. Otherwise, go to PSA_Q170.

1. **PSA_Q170**: (Now Prostate tests) Have you ever had a prostate specific antigen test for prostate cancer, that is, a PSA blood test? - 1=Yes; 2=No [Go to PSA_Q174]; DK [Go to PSA_Q174]; R [Go to PSA_END]

2. **PSA_Q172**: When was the last time? - 1=Less than 1 year ago; 2=1 year to less than 2 years ago; 3=2 years to less than 3 years ago; 4=3 years to less than 5 years ago; 5=5 or more years ago; DK,R

3. **PSA_Q173**: Why did you have it? If respondent says ‘Doctor recommended it’ or ‘I requested it’, probe for reason. - 1=Family history of prostate cancer; 2=Part of regular check-up / routine screening; 3=Age; 4=Race; 5=Follow-up of problem; 6=Follow-up of prostate cancer treatment; 7=Other - Specify; DK,R

- **PSA_C173S**: If PSA_Q173 = 7, go to PSA_Q173S. Otherwise, go to PSA_Q174.

4. **PSA_Q173S**: INTERVIEWER: Specify. ________________________ (80 spaces) - DK,R

5. **PSA_Q174**: A Digital Rectal Exam is an exam in which a gloved finger is inserted into the rectum in order to feel the prostate gland. Have you ever had this exam? - 1=Yes; 2=No [Go to PSA_END]; DK,R [Go to PSA_END]

6. **PSA_Q175**: When was the last time? PSA_END - 1=Less than 1 year ago; 2=1 year to less than 2 years ago; 3=2 years to less than 3 years ago; 4=3 years to less than 5 years ago; 5=5 or more years ago; DK,R

---

### COLORECTAL CANCER SCREENING (CCS) - 9 questions

*[Optional content]*

- **CCS_C1**: If (do CCS block = 1), go to CCS_C180.

- **CCS_C180**: If proxy interview or age < 35, go to CCS_END. Otherwise, go to CCS_Q180.

1. **CCS_Q180**: Now a few questions about various colorectal exams. An FOBT is a test to check for blood in your stool, where you have a bowel movement and use a stick to smear a small sample on a special card. Have you ever had this... - 1=Yes; 2=No [Go to CCS_Q184]; DK [Go to CCS_Q184]; R [Go to CCS_END]

2. **CCS_Q182**: When was the last time? - 1=Less than 1 year ago; 2=1 year to less than 2 years ago; 3=2 years to less than 3 years ago; 4=3 years to less than 5 years ago; 5=5 years to less than 10 years ago; 6=10 or more years ago; DK,R

3. **CCS_Q183**: Why did you have it? If respondent says ‘Doctor recommended it’ or ‘I requested it’, probe for reason. - 1=Family history of colorectal cancer; 2=Part of regular check-up / routine screening; 3=Age; 4=Race; 5=Follow-up of problem; 6=Follow-up of colorectal cancer treatment; 7=Other - Specify; DK,R

- **CCS_C183S**: If CCS_Q183 = 7, go to CCS_Q183S. Otherwise, go to CCS_Q184.

4. **CCS_Q183S**: INTERVIEWER: Specify. ________________________ (80 spaces) - DK,R

5. **CCS_Q184**: A colonoscopy or sigmoidoscopy is when a tube is inserted into the rectum to view the bowel for early signs of cancer and other health problems. Have you ever had either of these exams? - 1=Yes; 2=No [Go to CCS_END]; DK,R [Go to CCS_END]

6. **CCS_Q185**: When was the last time? - 1=Less than 1 year ago; 2=1 year to less than 2 years ago; 3=2 years to less than 3 years ago; 4=3 years to less than 5 years ago; 5=5 years to less than 10 years ago; 6=10 or more years ago; DK,R

7. **CCS_Q186**: Why did you have it? If respondent says “Doctor recommended it” or “I requested it”, probe for reason. - 1=Family history of colorectal cancer; 2=Part of regular check-up / routine screening; 3=Age; 4=Race; 5=Follow-up of problem; 6=Follow-up of colorectal cancer treatment; 7=Other - Specify; DK,R

- **CCS_C186S**: If CCS_Q186 = 7, go to CCS_Q186S. Otherwise, go to CCS_C187.

8. **CCS_Q186S**: INTERVIEWER: Specify. ________________________ (80 spaces) - DK,R

- **CCS_C187**: If CCS_Q180 = 1 (had a FOBT), go to CCS_Q187. Otherwise, go to CCS_END.

9. **CCS_Q187**: Was the colonoscopy or sigmoidoscopy a follow-up of the results of an FOBT? CCS_END - 1=Yes; 2=No; DK,R

---

### DENTAL VISITS (DEN) - 4 questions

*[Optional content]*

- **DEN_C130A**: If (do DEN block = 1), go to DEN_C130B.

- **DEN_C130B**: If proxy interview, go to DEN_END. Otherwise, go to DEN_C130C.

- **DEN_C130C**: If HCU_Q02E = 0, DK or R, go to DEN_C132. Otherwise, go to DEN_Q130.

1. **DEN_Q130**: Now dental visits It was reported earlier that you have “seen” or “talked to” a dentist in the past - 12=months. Did you actually visit one?; 1=Yes [Go to DEN_END]; 2=No; DK,R [Go to DEN_END]

- **DEN_C132**: If HCU_Q02E = 0, DK, R, go to DEN_R132. Otherwise, go to DEN_Q132.

2. **DEN_Q132**: When was the last time that you went to a dentist? - 1=Less than 1 year ago; 2=1 year to less than 2 years ago [Go to DEN_END]; 3=2 years to less than 3 years ago [Go to DEN_END]; 4=3 years to less than 4 years ago [Go to DEN_Q136]; 5=4 years to less than 5 years ago [Go to DEN_Q136]; 6=5 or more years ago [Go to DEN_Q136]; 7=Never [Go to DEN_Q136]; DK,R [Go to DEN_END]

3. **DEN_Q136**: What are the reasons that you have not been to a dentist in the past 3 years?  - 1=Have not gotten around to it; 2=Respondent - did not think it was necessary; 3=Dentist - did not think it was necessary; 4=Personal or family responsibilities; 5=Not available - at time required; 6=Not available - at all in the area; 7=Waiting time was too long; 8=Transportation - problems; 9=Language - problem; 10=Cost; 11=Did not know where to go / uninformed; 12=Fear (e.g., painful, embarr...

- **DEN_C136S**: If DEN_Q136 = 15, go to DEN_Q136S. Otherwise, go to DEN_END.

4. **DEN_Q136S**: INTERVIEWER: Specify. ________________________ (80 spaces) DEN_END - DK,R

---

### ORAL HEALTH 2 (OH2) - 18 questions

*[Optional content]*

- **OH2_C10A**: If (do OH2 block = 1), go to OH2_C10B. OH2EFOPT Otherwise, go to OH2_END.

- **OH2_C10B**: If proxy interview, go to OH2_END. Otherwise, go to OH2_C10C.

- **OH2_C10C**: If DEN_Q132 = 7 (never goes to dentist), go to OH2_Q11. Otherwise, go to OH2_Q10.

1. **OH2_Q10**: Do you usually visit the dentist: OH2E_10  - 1=… more than once a year for check-ups?; 2=… about once a year for check-ups?; 3=… less than once a year for check-ups?; 4=… only for emergency care?; DK,R [Go to OH2_END]

2. **OH2_Q11**: Do you have insurance that covers all or part of your dental expenses? - 1=Yes; 2=No [Go to OH2_C12]; DK,R [Go to OH2_C12]

3. **OH2_Q11A**: Is it: Mark all that apply. OH2E_11A 1 … a government-sponsored plan? OH2E_11B 2 … an employer-sponsored plan? OH2E_11C 3 … a private plan? - DK,R

- **OH2_C12**: If DEN_Q130 = 1 or DEN_Q132 = 1, go to OH2_Q12. Otherwise, go to OH2_Q20.

4. **OH2_Q12**: In the past 12 months, have you had any teeth removed by a dentist? - 1=Yes; 2=No [Go to OH2_Q20]; DK,R [Go to OH2_Q20]

5. **OH2_Q13**: (In the past 12 months,) were any teeth removed because of decay or gum OH2E_13 disease? - 1=Yes; 2=No; DK,R

6. **OH2_Q20**: Do you have one or more of your own teeth? - 1=Yes; 2=No; DK,R

- **OH2_C21**: If DEN_Q136 = 13, go to OH2_Q22. Otherwise, go to OH2_Q21.

7. **OH2_Q21**: Do you wear dentures or false teeth? - 1=Yes; 2=No; DK,R

- *OH2_R22*: Now we have some additional questions about oral health, that is the health of your teeth and mouth. INTERVIEWER: Press <Enter> to continue.

8. **OH2_Q22**: Because of the condition of your [teeth, mouth or dentures/teeth or mouth], do you OH2E_22 have difficulty pronouncing any words or speaking clearly? - 1=Yes; 2=No; DK,R

9. **OH2_Q23**: In the past 12 months, how often have you avoided: ... conversation or contact with other people, because of the condition of your [teeth, mouth or dentures/teeth or mouth]?  - 1=Often; 2=Sometimes; 3=Rarely; 4=Never; DK,R

10. **OH2_Q24**: (In the past 12 months, how often have you avoided:) ... laughing or smiling, because of the condition of your [teeth, mouth or dentures/teeth or mouth]? - 1=Often; 2=Sometimes; 3=Rarely; 4=Never; DK,R

- *OH2_R25*: Now some questions about the health of your teeth and mouth during the past month. INTERVIEWER: Press <Enter> to continue.

11. **OH2_Q25A**: In the past month, have you had: … a toothache? - 1=Yes; 2=No; DK,R

12. **OH2_Q25B**: In the past month, were your teeth: … sensitive to hot or cold food or drinks? - 1=Yes; 2=No; DK,R

13. **OH2_Q25C**: In the past month, have you had: … pain in or around the jaw joints? - 1=Yes; 2=No; DK,R

14. **OH2_Q25D**: (In the past month, have you had:) … other pain in the mouth or face? - 1=Yes; 2=No; DK,R

15. **OH2_Q25E**: (In the past month, have you had:) … bleeding gums? - 1=Yes; 2=No; DK,R

16. **OH2_Q25F**: (In the past month, have you had:) … dry mouth? INTERVIEWER: Do not include thirst caused by exercise. - 1=Yes; 2=No; DK,R

17. **OH2_Q25G**: (In the past month, have you had:) … bad breath? - 1=Yes; 2=No; DK,R

- **OH2_C30**: If OH2_Q20 = 1, go to OH2_Q30. Otherwise, go to OH2_END.

18. **OH2_Q30**: How often do you brush your teeth? OH2_END - 1=More than twice a day; 2=Twice a day; 3=Once a day; 4=Less than once a day but more than once a week; 5=Once a week; 6=Less than once a week; DK,R

---

### FOOD CHOICES (FDC) - 12 questions

*[Optional content]*

- **FDC_C1A**: If (do FDC block = 1), go to FDC_C1B.

- **FDC_C1B**: If proxy interview, go to FDC_END. Otherwise, go to FDC_QINT.

- *FDC_QINT*: Now, some questions about the foods you eat. INTERVIEWER: Press <Enter> to continue.

1. **FDC_Q1A**: Do you choose certain foods or avoid others: … because you are concerned about your body weight? - 1=Yes (or sometimes); 2=No; DK,R [Go to FDC_END]

2. **FDC_Q1B**: (Do you choose certain foods or avoid others:) … because you are concerned about heart disease? - 1=Yes (or sometimes); 2=No; DK,R

3. **FDC_Q1C**: (Do you choose certain foods or avoid others:) … because you are concerned about cancer? - 1=Yes (or sometimes); 2=No; DK,R

4. **FDC_Q1D**: (Do you choose certain foods or avoid others:) … because you are concerned about osteoporosis (brittle bones)? - 1=Yes (or sometimes); 2=No; DK,R

5. **FDC_Q2A**: Do you choose certain foods because of: … the lower fat content? - 1=Yes (or sometimes); 2=No; DK,R

6. **FDC_Q2B**: (Do you choose certain foods because of:) … the fibre content? - 1=Yes (or sometimes); 2=No; DK,R

7. **FDC_Q2C**: (Do you choose certain foods because of:) … the calcium content? - 1=Yes (or sometimes); 2=No; DK,R

8. **FDC_Q3A**: Do you avoid certain foods because of: … the fat content? - 1=Yes (or sometimes); 2=No; DK,R

9. **FDC_Q3B**: (Do you avoid certain foods because of:) … the type of fat they contain? - 1=Yes (or sometimes); 2=No; DK,R

10. **FDC_Q3C**: (Do you avoid certain foods because of:) … the salt content? - 1=Yes (or sometimes); 2=No; DK,R

11. **FDC_Q3D**: (Do you avoid certain foods because of:) … the cholesterol content? - 1=Yes (or sometimes); 2=No; DK,R

12. **FDC_Q3E**: (Do you avoid certain foods because of:) … the calorie content? FDC_END - 1=Yes (or sometimes); 2=No; DK,R

---

### FRUIT AND VEGETABLE CONSUMPTION (FVC) - 30 questions

*[Optional content]*

- **FVC_C1A**: If (do FVC block = 2) or proxy interview, go to FVC_END.

- *FVC_QINT*: The next questions are about the foods you usually eat or drink. Think about all the foods you eat, both meals and snacks, at home and away from home. INTERVIEWER: Press <Enter> to continue.

1. **FVC_Q1A**: How often do you usually drink fruit juices such as orange, grapefruit or tomato? (For example: once a day, three times a week, twice a month) INTERVIEWER: Select the reporting period here and enter the number in the ... - 1=Per day; 2=Per week [Go to FVC_N1C]; 3=Per month [Go to FVC_N1D]; 4=Per year [Go to FVC_N1E]; 5=Never [Go to FVC_Q2A]; DK,R [Go to FVC_END]

2. **FVC_N1B**: INTERVIEWER: Enter number of times per day. l_l_l Times - DK,R; [Then go to FVC_Q2A]

3. **FVC_N1C**: INTERVIEWER: Enter number of times per week. l_l_l Times - DK,R; [Then go to FVC_Q2A]

4. **FVC_N1D**: INTERVIEWER: Enter number of times per month. l_l_l_l Times - DK,R; [Then go to FVC_Q2A]

5. **FVC_N1E**: INTERVIEWER: Enter number of times per year. l_l_l_l Times - DK,R

6. **FVC_Q2A**: Not counting juice, how often do you usually eat fruit? INTERVIEWER: Select the reporting period here and enter the number in the next screen. - 1=Per day; 2=Per week [Go to FVC_N2C]; 3=Per month [Go to FVC_N2D]; 4=Per year [Go to FVC_N2E]; 5=Never [Go to FVC_Q3A]; DK,R [Go to FVC_Q3A]

7. **FVC_N2B**: INTERVIEWER: Enter number of times per day. l_l_l Times - DK,R; [Then go to FVC_Q3A]

8. **FVC_N2C**: INTERVIEWER: Enter number of times per week. l_l_l Times - DK,R; [Then go to FVC_Q3A]

9. **FVC_N2D**: INTERVIEWER: Enter number of times per month. l_l_l_l Times - DK,R; [Then go to FVC_Q3A]

10. **FVC_N2E**: INTERVIEWER: Enter number of times per year. l_l_l_l Times - DK,R

11. **FVC_Q3A**: How often do you (usually) eat green salad? INTERVIEWER: Select the reporting period here and enter the number in the next screen. - 1=Per day; 2=Per week [Go to FVC_N3C]; 3=Per month [Go to FVC_N3D]; 4=Per year [Go to FVC_N3E]; 5=Never [Go to FVC_Q4A]; DK,R [Go to FVC_Q4A]

12. **FVC_N3B**: INTERVIEWER: Enter number of times per day. l_l_l Times - DK,R; [Then go to FVC_Q4A]

13. **FVC_N3C**: INTERVIEWER: Enter number of times per week. l_l_l Times - DK,R; [Then go to FVC_Q4A]

14. **FVC_N3D**: INTERVIEWER: Enter number of times per month. l_l_l_l Times - DK,R; [Then go to FVC_Q4A]

15. **FVC_N3E**: INTERVIEWER: Enter number of times per year. l_l_l_l Times - DK,R

16. **FVC_Q4A**: How often do you usually eat potatoes, not including french fries, fried potatoes, or potato chips? INTERVIEWER: Select the reporting period here and enter the number in the next screen. - 1=Per day; 2=Per week [Go to FVC_N4C]; 3=Per month [Go to FVC_N4D]; 4=Per year [Go to FVC_N4E]; 5=Never [Go to FVC_Q5A]; DK,R [Go to FVC_Q5A]

17. **FVC_N4B**: INTERVIEWER: Enter number of times per day. l_l_l Times - DK,R; [Then go to FVC_Q5A]

18. **FVC_N4C**: INTERVIEWER: Enter number of times per week. l_l_l Times - DK,R; [Then go to FVC_Q5A]

19. **FVC_N4D**: INTERVIEWER: Enter number of times per month. l_l_l_l Times - DK,R; [Then go to FVC_Q5A]

20. **FVC_N4E**: INTERVIEWER: Enter number of times per year. l_l_l_l Times - DK,R

21. **FVC_Q5A**: How often do you (usually) eat carrots? INTERVIEWER: Select the reporting period here and enter the number in the next screen. - 1=Per day; 2=Per week [Go to FVC_N5C]; 3=Per month [Go to FVC_N5D]; 4=Per year [Go to FVC_N5E]; 5=Never [Go to FVC_Q6A]; DK,R [Go to FVC_Q6A]

22. **FVC_N5B**: INTERVIEWER: Enter number of times per day. l_l_l Times - DK,R; [Then go to FVC_Q6A]

23. **FVC_N5C**: INTERVIEWER: Enter number of times per week. l_l_l Times - DK,R; [Then go to FVC_Q6A]

24. **FVC_N5D**: INTERVIEWER: Enter number of times per month. l_l_l_l Times - DK,R; [Then go to FVC_Q6A]

25. **FVC_N5E**: INTERVIEWER: Enter number of times per year. l_l_l_l Times - DK,R

26. **FVC_Q6A**: Not counting carrots, potatoes, or salad, how many servings of other vegetables do you usually eat? INTERVIEWER: Select the reporting period here and enter the number in the next screen. - 1=Per day; 2=Per week [Go to FVC_N6C]; 3=Per month [Go to FVC_N6D]; 4=Per year [Go to FVC_N6E]; 5=Never [Go to FVC_END]; DK,R [Go to FVC_END]

27. **FVC_N6B**: INTERVIEWER: Enter number of servings per day. l_l_l Servings - DK,R; [Then go to FVC_END]

28. **FVC_N6C**: INTERVIEWER: Enter number of servings per week. l_l_l Servings - DK,R; [Then go to FVC_END]

29. **FVC_N6D**: INTERVIEWER: Enter number of servings per month. l_l_l_l Servings - DK,R; [Then go to FVC_END]

30. **FVC_N6E**: INTERVIEWER: Enter number of servings per year. l_l_l_l Servings FVC_END - DK,R

---

### PHYSICAL ACTIVITY (PAC) - 11 questions

- **PAC_C1**: If (do PAC block = 1), go to PAC_C2. Otherwise, go to PAC_END.

- **PAC_C2**: If proxy interview, go to PAC_END.

- *PAC_R1*: Now I’d like to ask you about some of your physical activities. To begin with, I’ll be dealing with physical activities not related to work, that is, leisure time activities. INTERVIEWER: Press <Enter> to continue.

1. **PAC_Q1**: Have you done any of the following in the past 3 months, that is, from [date three months ago] to yesterday? Mark all that apply. - 1=Walking for exercise    PACE_1M         13      Downhill skiing or; 2=Gardening or; 3=Swimming                PACE_1O         15      Baseball or softball; 4=Bicycling               PACE_1P         16      Tennis; 5=Popular or; 6=Home exercises          PACE_1R         18      Fishing; 7=Ice hockey              PACE_1S         19      Volleyball; 8=Ice skating             PACE_1T         20  ...

- **PAC_C1VS**: If “Any other” is chosen as a response, go to PAC_Q1VS. Otherwise, go to PAC_Q2.

2. **PAC_Q1VS**: What was this activity? INTERVIEWER: Enter one activity only. ________________________ (80 spaces) - DK,R [Go to PAC_Q2]

3. **PAC_Q1X**: In the past 3 months, did you do any other physical activity for leisure? - 1=Yes; 2=No [Go to PAC_Q2]; DK,R [Go to PAC_Q2]

4. **PAC_Q1XS**: What was this activity? INTERVIEWER: Enter one activity only. ________________________ (80 spaces) - DK,R [Go to PAC_Q2]

5. **PAC_Q1Y**: In the past 3 months, did you do any other physical activity for leisure? - 1=Yes; 2=No [Go to PAC_Q2]; DK,R [Go to PAC_Q2]

6. **PAC_Q1YS**: What was this activity? INTERVIEWER: Enter one activity only. ________________________ (80 spaces) - DK,R [Go to PAC_Q2]

7. **PAC_Q2n**: In the past 3 months, how many times did you [participate in identified activity]? |_|_|_| Times Walking: MAX = 270 Bicycling: MAX = 200 Other activities: MAX = 200) - DK,R

8. **PAC_Q3n**: About how much time did you spend on each occasion? - 1=1 to 15 minutes; 2=16 to 30 minutes; 3=31 to 60 minutes; 4=More than one hour; DK,R

- *PAC_R2*: Next, some questions about the amount of time you spent in the past 3 months on physical activity at work or while doing daily chores around the house, but not leisure time activity. INTERVIEWER: Press <Enter> to cont...

9. **PAC_Q4A**: In a typical week in the past 3 months, how many hours did you usually spend walking to work or to school or while doing errands? - 1=None; 2=Less than 1 hour; 3=From 1 to 5 hours; 4=From 6 to 10 hours; 5=From 11 to 20 hours; 6=More than 20 hours; DK,R

10. **PAC_Q4B**: (In a typical week in the past 3 months,) how many hours did you usually spend bicycling to work or to school or while doing errands? - 1=None; 2=Less than 1 hour; 3=From 1 to 5 hours; 4=From 6 to 10 hours; 5=From 11 to 20 hours; 6=More than 20 hours; DK,R

11. **PAC_Q6**: Thinking back over the past 3 months, which of the following best describes your usual daily activities or work habits? PAC_END - 1=Usually sit during the day and don’t walk around very much; 2=Stand or walk quite a lot during the day but don’t have to carry or lift; 3=Usually lift or carry light loads, or have to climb stairs or hills often; 4=Do heavy work or carry very heavy loads; DK,R

---

### SEDENTARY ACTIVITIES (SAC) - 4 questions

*[Optional content]*

- **SAC_C1**: If (do SAC block = 1), go to SAC_CINT.

- **SAC_CINT**: If proxy interview, go to SAC_END. Otherwise, go to SAC_R1.

- *SAC_R1*: Now, a few additional questions about activities you do in your leisure time, that is, activities not at work or at school. INTERVIEWER: Press <Enter> to continue.

1. **SAC_Q1**: In a typical week in the past 3 months, how much time did you usually spend: ... on a computer, including playing computer games and using the Internet? INTERVIEWER: Do not include time spent at work or at school. - 1=None; 2=Less than 1 hour; 3=From 1 to 2 hours; 4=From 3 to 5 hours; 5=From 6 to 10 hours; 6=From 11 to 14 hours; 7=From 15 to 20 hours; 8=More than 20 hours; DK,R [Go to SAC_END]

- **SAC_C2**: If age > 19, go to SAC_Q3.

2. **SAC_Q2**: (In a typical week, in the past 3 months, how much time did you usually spend:) ... playing video games, such as XBOX, Nintendo and Playstation? - 1=None; 2=Less than 1 hour; 3=From 1 to 2 hours; 4=From 3 to 5 hours; 5=From 6 to 10 hours; 6=From 11 to 14 hours; 7=From 15 to 20 hours; 8=More than 20 hours; DK,R

3. **SAC_Q3**: (In a typical week in the past 3 months, how much time did you usually spend:) ... watching television or videos? - 1=None; 2=Less than 1 hour; 3=From 1 to 2 hours; 4=From 3 to 5 hours; 5=From 6 to 10 hours; 6=From 11 to 14 hours; 7=From 15 to 20 hours; 8=More than 20 hours; DK,R

4. **SAC_Q4**: (In a typical week, in the past 3 months, how much time did you usually spend:) ... reading, not counting at work or at school? INTERVIEWER: Include books, magazines, newspapers, homework. SAC_END - 1=None; 2=Less than 1 hour; 3=From 1 to 2 hours; 4=From 3 to 5 hours; 5=From 6 to 10 hours; 6=From 11 to 14 hours; 7=From 15 to 20 hours; 8=More than 20 hours; DK,R

---

### USE OF PROTECTIVE EQUIPMENT (UPE) - 14 questions

*[Optional content]*

- **UPE_C1A**: If (do UPE block = 1), go to UPE_C1B.

- **UPE_C1B**: If proxy interview, go to UPE_END. Otherwise, go to UPE_CINT.

- **UPE_CINT**: If PAC_Q1 = 4 (bicycling for leisure) or PAC_Q1 = 9 (in-line skating or rollerblading) or

1. **PAC_Q1**: = 13 (downhill skiing or snowboarding), or PAC_Q4B > 1 and PAC_Q4B < 7 (bicycling to work), go to UPE_QINT. Otherwise, go to UPE_C3A.

- *UPE_QINT*: Now a few questions about precautions you take while participating in physical activities. INTERVIEWER: Press <Enter> to continue.

- **UPE_C1C**: If PAC_Q1 = 4 (bicycling for leisure) or PAC_Q4B > 1 and PAC_Q4B < 7 (bicycling to work), go to UPE_Q1. Otherwise, go to UPE_C2A.

2. **UPE_Q1**: When riding a bicycle, how often do you wear a helmet?  - 1=Always; 2=Most of the time; 3=Rarely; 4=Never; DK,R

- **UPE_C2A**: If PAC_Q1 = 9 (in-line skating or rollerblading), go to UPE_Q2A. Otherwise, go to UPE_C3A.

3. **UPE_Q2A**: When in-line skating or rollerblading, how often do you wear a helmet? - 1=Always; 2=Most of the time; 3=Rarely; 4=Never; DK,R

4. **UPE_Q2B**: How often do you wear wrist guards or wrist protectors? - 1=Always; 2=Most of the time; 3=Rarely; 4=Never; DK,R

5. **UPE_Q2C**: How often do you wear elbow pads? - 1=Always; 2=Most of the time; 3=Rarely; 4=Never; DK,R

- **UPE_C3A**: If PAC_Q1 = 13 (downhill skiing or snowboarding), go to UPE_Q3A. Otherwise, go to UPE_Q3B.

6. **UPE_Q3A**: Earlier, you mentioned going downhill skiing or snowboarding in the past - 3=months. Was that:; 1=… downhill skiing only? [Go to UPE_Q4A]; 2=… snowboarding only? [Go to UPE_C5A]; 3=… both? [Go to UPE_Q4A]; DK,R [Go to UPE_C6]

7. **UPE_Q3B**: In the past 12 months, did you do any downhill skiing or snowboarding?  - 1=Downhill skiing only [Go to UPE_Q4A]; 2=Snowboarding only [Go to UPE_C5A]; 3=Both [Go to UPE_Q4A]; 4=Neither [Go to UPE_C6]; DK,R [Go to UPE_C6]

8. **UPE_Q4A**: When downhill skiing, how often do you wear a helmet?  - 1=Always; 2=Most of the time; 3=Rarely; 4=Never; DK,R

- **UPE_C5A**: If UPE_Q3A = 2 or 3 (snowboarding or both) or UPE_Q3B = 2 or 3, go to UPE_Q5A. Otherwise, go to UPE_C6.

9. **UPE_Q5A**: When snowboarding, how often do you wear a helmet? - 1=Always; 2=Most of the time; 3=Rarely; 4=Never; DK,R

10. **UPE_Q5B**: How often do you wear wrist guards or wrist protectors? - 1=Always; 2=Most of the time; 3=Rarely; 4=Never; DK,R

- **UPE_C6**: If age >= 12 or <=19, go to UPE_Q6. Otherwise, go to UPE_END.

11. **UPE_Q6**: In the past 12 months, have you done any skateboarding? - 1=Yes; 2=No [Go to UPE_END]; DK,R [Go to UPE_END]

12. **UPE_Q6A**: How often do you wear a helmet?  - 1=Always; 2=Most of the time; 3=Rarely; 4=Never; DK,R

13. **UPE_Q6B**: How often do you wear wrist guards or wrist protectors? - 1=Always; 2=Most of the time; 3=Rarely; 4=Never; DK,R

14. **UPE_Q6C**: How often do you wear elbow pads? UPE_END - 1=Always; 2=Most of the time; 3=Rarely; 4=Never; DK,R

---

### SUN SAFETY (SSB) - 11 questions

*[Optional content]*

- **SSB_C1**: If (do SSB block = 1), go to SSB_C2.

- **SSB_C2**: If proxy interview, go to SSB_END. Otherwise, go to SSB_R01.

- *SSB_R01*: The next few questions are about exposure to the sun and sunburns. Sunburn is defined as any reddening or discomfort of the skin, that lasts longer than 12 hours after exposure to the sun or other UV sources, such as ...

1. **SSB_Q01**: In the past 12 months, has any part of your body been sunburnt? - 1=Yes; 2=No [Go to SSB_R06]; DK,R [Go to SSB_END]

2. **SSB_Q02**: Did any of your sunburns involve blistering? - 1=Yes; 2=No; DK,R

3. **SSB_Q03**: Did any of your sunburns involve pain or discomfort that lasted for more than - 1=day?; 1=Yes; 2=No; DK,R

- *SSB_R06*: For the next questions, think about a typical weekend, or day off from work or school in the summer months. INTERVIEWER: Press <Enter> to continue.

4. **SSB_Q06**: About how much time each day do you spend in the sun between 11 am and 4 pm? - 1=None [Go to SSB_END]; 2=Less than 30 minutes [Go to SSB_END]; 3=30 to 59 minutes; 4=1 hour to less than 2 hours; 5=2 hours to less than 3 hours; 6=3 hours to less than 4 hours; 7=4 hours to less than 5 hours; 8=5 hours; DK,R [Go to SSB_END]

5. **SSB_Q07**: In the summer months, on a typical weekend or day off, when you are in the sun for 30 minutes or more, how often do you: … seek shade?  - 1=Always; 2=Often; 3=Sometimes; 4=Rarely; 5=Never; DK,R

6. **SSB_Q08**: (In the summer months, on a typical weekend or day off, when you are in the sun for 30 minutes or more, how often do you:) … wear a hat that shades your face, ears and neck? - 1=Always; 2=Often; 3=Sometimes; 4=Rarely; 5=Never; DK,R

7. **SSB_Q09A**: (In the summer months, on a typical weekend or day off, when you are in the sun for 30 minutes or more, how often do you:) … wear long pants or a long skirt to protect your skin from the sun? - 1=Always; 2=Often; 3=Sometimes; 4=Rarely; 5=Never; DK,R

8. **SSB_Q09B**: (In the summer months, on a typical weekend or day off, when you are in the sun for 30 minutes or more, how often do you:) … use sunscreen on your face? - 1=Always; 2=Often; 3=Sometimes; 4=Rarely [Go to SSB_Q11]; 5=Never [Go to SSB_Q11]; DK,R [Go to SSB_Q11]

9. **SSB_Q10**: What Sun Protection factor (SPF) do you usually use? - 1=Less than 15; 2=15 to 25; 3=More than 25; DK,R

10. **SSB_Q11**: In the summer months, on a typical weekend or day off, when you are in the sun for 30 minutes or more, how often do you: … use sunscreen on your body? - 1=Always; 2=Often; 3=Sometimes; 4=Rarely [Go to SSB_END]; 5=Never [Go to SSB_END]; DK,R [Go to SSB_END]

11. **SSB_Q12**: What Sun Protection factor (SPF) do you usually use? SSB_END - 1=Less than 15; 2=15 to 25; 3=More than 25; DK,R

---

### SMOKING (SMK) - 21 questions

- **SMK_C1**: If (do SMK block = 1), go to SMK_QINT. Otherwise, go to SMK_END.

- *SMK_QINT*: The next questions are about smoking. INTERVIEWER: Press <Enter> to continue.

1. **SMK_Q201A**: In ^YOUR1 lifetime, ^HAVE ^YOU2 smoked a total of 100 or more cigarettes (about 4 packs)? - 1=Yes [Go to SMK_Q201C]; 2=No; DK,R

2. **SMK_Q201B**: ^HAVE_C ^YOU1 ever smoked a whole cigarette? - 1=Yes [Go to SMK_Q201C]; 2=No [Go to SMK_Q202]; DK [Go to SMK_Q202]; R

- **SMK_C201C**: If SMK_Q201A = R and SMK_Q201B = R, go to SMK_END. Otherwise, go to SMK_Q202.

3. **SMK_Q201C**: At what age did ^YOU1 smoke ^YOUR1 first whole cigarette? INTERVIEWER: Minimum is 5; maximum is [current age]. |_|_|_| Age in years - DK,R [Go to SMK_Q202]

4. **SMK_Q202**: At the present time, ^DOVERB ^YOU2 smoke cigarettes daily, occasionally or not at all? Daily smoker (current) - 1=Daily; 2=Occasionally [Go to SMK_Q205B]; 3=Not at all [Go to SMK_C205D]; DK,R [Go to SMK_END]

5. **SMK_Q203**: At what age did ^YOU1 begin to smoke cigarettes daily? INTERVIEWER: Minimum is 5; maximum is [current age]. |_|_|_| Age in years - DK,R [Go to SMK_Q204]

6. **SMK_Q204**: How many cigarettes ^DOVERB ^YOU1 smoke each day now? |_|_| Cigarettes Occasional smoker (current) - DK,R; [Then go to SMK_END]

7. **SMK_Q205B**: On the days that ^YOU2 ^DOVERB smoke, how many cigarettes ^DOVERB ^YOU1 usually smoke? |_|_| Cigarettes - DK,R

8. **SMK_Q205C**: In the past month, on how many days ^HAVE ^YOU1 smoked 1 or more cigarettes? |_|_| Days - DK,R

- **SMK_C205D**: If SMK_Q201A = 2 (has not smoked 100 or more cigarettes lifetime), DK or R, go to SMK_END. Occasional smoker or non-smoker (current)

9. **SMK_Q205D**: ^HAVE ^YOU1 ever smoked cigarettes daily? - 1=Yes [Go to SMK_Q207]; 2=No; DK,R [Go to SMK_END]

- **SMK_C206A**: If SMK_Q202 = 2 (current occasional smoker), go to SMK_END. Otherwise, go to SMK_Q206A. Non-smoker (current)

10. **SMK_Q206A**: When did ^YOU1 stop smoking? Was it:  - 1=… less than one year ago?; 2=… 1 year to less than 2 years ago? [Go to SMK_END]; 3=… 2 years to less than 3 years ago? [Go to SMK_END]; 4=… 3 or more years ago? [Go to SMK_Q206C]; DK,R [Go to SMK_END]

11. **SMK_Q206B**: In what month did ^YOU1 stop? - 1=January                        7       July; 2=February                       8       August; 3=March                          9       September; 4=April                          10      October; 5=May                            11      November; 6=June                           12      December; DK,R; [Then go to SMK_END]

12. **SMK_Q206C**: How many years ago was it? INTERVIEWER: Minimum is 3; maximum is [current age] - 5. |_|_|_| Years - DK,R [Go to SMK_END]

13. **SMK_Q207**: At what age did ^YOU1 begin to smoke (cigarettes) daily? INTERVIEWER: Minimum is 5; maximum is [current age]. |_|_|_| Age in years - DK,R [Go to SMK_Q208]

14. **SMK_Q208**: How many cigarettes did ^YOU1 usually smoke each day? |_|_| Cigarettes - DK,R

15. **SMK_Q209A**: When did ^YOU1 stop smoking daily? Was it:  - 1=… less than one year ago?; 2=… 1 year to less than 2 years ago? [Go to SMK_C210]; 3=… 2 years to less than 3 years ago? [Go to SMK_C210]; 4=… 3 or more years ago? [Go to SMK_Q209C]; DK,R [Go to SMK_END]

16. **SMK_Q209B**: In what month did ^YOU1 stop? - 1=January                   7       July; 2=February                  8       August; 3=March                     9       September; 4=April                     10      October; 5=May                       11      November; 6=June                      12      December; DK,R; [Then go to SMK_C210]

17. **SMK_Q209C**: How many years ago was it? INTERVIEWER: Minimum is 3; maximum is [current age] - 5. |_|_|_| Years - DK,R [Go to SMK_C210]

- **SMK_C210**: If SMK_Q202 = 2 (current occasional smoker), go to SMK_END. Otherwise, go to SMK_Q210. Non-smoker (current)

18. **SMK_Q210**: Was that when ^YOU1 completely quit smoking? - 1=Yes [Go to SMK_END]; 2=No; DK,R [Go to SMK_END]

19. **SMK_Q210A**: When did ^YOU1 stop smoking completely? Was it:  - 1=… less than one year ago?; 2=… 1 year to less than 2 years ago? [Go to SMK_END]; 3=… 2 years to less than 3 years ago? [Go to SMK_END]; 4=… 3 or more years ago? [Go to SMK_Q210C]; DK,R [Go to SMK_END]

20. **SMK_Q210B**: In what month did ^YOU1 stop? - 1=January                    7    July; 2=February                   8    August; 3=March                      9    September; 4=April                      10   October; 5=May                        11   November; 6=June                       12   December; DK,R; [Then go to SMK_END]

21. **SMK_Q210C**: How many years ago was it? INTERVIEWER: Minimum is 3; maximum is [current age] - 5. |_|_|_| Years - DK,R [Go to SMK_END]

---

### SMOKING - STAGES OF CHANGE (SCH) - 4 questions

*[Optional content]*

- **SCH_C1**: If (do SCH block = 1), go to SCH_C2.

- **SCH_C2**: If SMK_Q202 = 1 or 2 (current daily or occasional smokers), go to SCH_C3. Otherwise, go to SCH_END.

- **SCH_C3**: If proxy interview, go to SCH_END. Otherwise, go to SCH_Q1.

1. **SCH_Q1**: Are you seriously considering quitting smoking within the next 6 months? - 1=Yes; 2=No [Go to SCH_Q3]; DK,R [Go to SCH_Q3]

2. **SCH_Q2**: Are you seriously considering quitting within the next 30 days? - 1=Yes; 2=No; DK,R

3. **SCH_Q3**: In the past 12 months, did you stop smoking for at least 24 hours because you were trying to quit? - 1=Yes; 2=No [Go to SCH_END]; DK,R [Go to SCH_END]

4. **SCH_Q4**: How many times? (in the past 12 months, did you stop smoking for at least |_|_| Times SCH_END - 24=hours because you were trying to quit); DK,R

---

### NICOTINE DEPENDENCE (NDE) - 5 questions

*[Optional content]*

- **NDE_C1**: If (do NDE block = 1), go to NDE_C2.

- **NDE_C2**: If SMK_Q202 = 1 (current daily smokers), go to NDE_C3. Otherwise, go to NDE_END.

- **NDE_C3**: If proxy interview, go to NDE_END. Otherwise, go to NDE_Q1.

1. **NDE_Q1**: How soon after you wake up do you smoke your first cigarette? - 1=Within 5 minutes; 2=6 - 30 minutes after waking; 3=31 - 60 minutes after waking; 4=More than 60 minutes after waking; DK,R [Go to NDE_END]

2. **NDE_Q2**: Do you find it difficult to refrain from smoking in places where it is forbidden? - 1=Yes; 2=No; DK,R

3. **NDE_Q3**: Which cigarette would you most hate to give up?  - 1=The first one of the day; 2=Another one; DK,R

4. **NDE_Q4**: Do you smoke more frequently during the first hours after waking, compared with the rest of the day? - 1=Yes; 2=No; DK,R

5. **NDE_Q5**: Do you smoke even if you are so ill that you are in bed most of the day? NDE_END - 1=Yes; 2=No; DK,R

---

### SMOKING CESSATION AIDS (SCA) - 10 questions

*[Optional content]*

- **SCA_C1**: If (do SCA block = 1), go to SCA_C10A.

- **SCA_C10A**: If proxy interview, go to SCA_END. Otherwise, go to SCA_C10B.

- **SCA_C10B**: If SMK_Q202 = 1 or 2 (current daily or occasional smoker), go to SCA_C50. Otherwise, go to SCA_C10C.

- **SCA_C10C**: If SMK_Q206A = 1 or SMK_Q209A = 1 (former smoker who quit less than 1 year ago), go to SCA_Q10. Otherwise, go to SCA_END.

1. **SCA_Q10**: In the past 12 months, did you try a nicotine patch to quit smoking? - 1=Yes; 2=No [Go to SCA_Q11]; DK,R [Go to SCA_END]

2. **SCA_Q10A**: How useful was that in helping you quit? - 1=Very useful; 2=Somewhat useful; 3=Not very useful; 4=Not useful at all; DK,R

3. **SCA_Q11**: Did you try Nicorettes or other nicotine gum or candy to quit smoking? (In the past 12 months) - 1=Yes; 2=No [Go to SCA_Q12]; DK,R [Go to SCA_Q12]

4. **SCA_Q11A**: How useful was that in helping you quit? - 1=Very useful; 2=Somewhat useful; 3=Not very useful; 4=Not useful at all; DK,R

5. **SCA_Q12**: In the past 12 months, did you try medication such as Zyban, Prolev or Wellbutrin to quit smoking? - 1=Yes; 2=No [Go to SCA_END]; DK,R [Go to SCA_END]

6. **SCA_Q12A**: How useful was that in helping you quit? - 1=Very useful; 2=Somewhat useful; 3=Not very useful; 4=Not useful at all; DK,R; [Then go to SCA_END]

- **SCA_C50**: If (do SCH block = 2), go to SCA_Q50. Otherwise, go to SCA_C50A.

- **SCA_C50A**: If SCH_Q3 = 1, go to SCA_Q60. Otherwise, go to SCA_END.

7. **SCA_Q50**: In the past 12 months, did you stop smoking for at least 24 hours because you were trying to quit? - 1=Yes; 2=No [Go to SCA_END]; DK,R [Go to SCA_END]

8. **SCA_Q60**: In the past 12 months, did you try any of the following to quit smoking: … a nicotine patch? - 1=Yes; 2=No; DK,R

9. **SCA_Q61**: (In the past 12 months, did you try any of the following to quit smoking:) … Nicorettes or other nicotine gum or candy? - 1=Yes; 2=No; DK,R

10. **SCA_Q62**: (In the past 12 months, did you try any of the following to quit smoking:) … medication such as Zyban, Prolev or Wellbutrin? SCA_END - 1=Yes; 2=No; DK,R

---

### SMOKING - PHYSICIAN COUNSELLING (SPC) - 9 questions

*[Optional content]*

- **SPC_C1**: If (do SPC block = 1), go to SPC_C2.

- **SPC_C2**: If proxy interview, go to SPC_END. Otherwise, go to SPC_C3.

- **SPC_C3**: If SMK_Q202 = 1 or 2 or SMK_Q206A = 1 or SMK_Q209A = 1, go to SPC_C4. Otherwise, go to SPC_END.

- **SPC_C4**: If (do HCU block = 1) and (HCU_Q01AA = 1) (i.e. has a regular medical doctor), go to

1. **SPC_Q10**: . Otherwise, go to SPC_C20A.

2. **SPC_Q10**: Earlier, you mentioned having a regular medical doctor. In the past 12 months, did you go see this doctor? - 1=Yes; 2=No [Go to SPC_C20A]; DK,R [Go to SPC_C20A]

3. **SPC_Q11**: Does your doctor know that you [smoke/smoked] cigarettes? - 1=Yes; 2=No [Go to SPC_C20A]; DK,R [Go to SPC_C20A]

4. **SPC_Q12**: In the past 12 months, did your doctor advise you to quit smoking? - 1=Yes; 2=No; DK,R [Go to SPC_C20A]

5. **SPC_Q13**: (In the past 12 months,) did your doctor give you any specific help or information to quit smoking? - 1=Yes; 2=No [Go to SPC_C20A]; DK,R [Go to SPC_C20A]

6. **SPC_Q14**: What type of help did the doctor give?  - 1=Referral to a one-on-one cessation program; 2=Referral to a group cessation program; 3=Recommended use of nicotine patch or nicotine gum; 4=Recommended Zyban or other medication; 5=Provided self-help information (e.g., pamphlet, referral to website); 6=Own doctor offered counselling; 7=Other; DK,R

- **SPC_C20A**: If (do DEN block = 1) and (DEN_Q130 = 1 or DEN_Q132 = 1) (visited dentist in past 12 months), go to SPC_Q21. If (do DEN block = 1) and (DEN_Q130 = 2, DK or R) (did not visit dentist in past 12 months), go to SPC_END. Otherwise, go to SPC_C20.

- **SPC_C20**: If (do HCU block = 1) and (HCU_Q02E > 0 and HCU_Q02E < 998) (saw or talked to dentist in past 12 months), go to SPC_Q20. Otherwise, go to SPC_END.

7. **SPC_Q20**: Earlier, you mentioned having “seen or talked to” a dentist in the past 12 months. Did you actually go to the dentist? - 1=Yes; 2=No [Go to SPC_END]; DK,R [Go to SPC_END]

8. **SPC_Q21**: Does your dentist or dental hygienist know that you [smoke/smoked] cigarettes? - 1=Yes; 2=No [Go to SPC_END]; DK,R [Go to SPC_END]

9. **SPC_Q22**: In the past 12 months, did the dentist or hygienist advise you to quit smoking? SPC_END - 1=Yes; 2=No; DK,R

---

### YOUTH SMOKING (YSM) - 6 questions

*[Optional content]*

- **YSM_C1**: If (do YSM block = 1), go to YSM_C1A. Otherwise, go to YSM_END.

- **YSM_C1A**: If proxy interview or age > 19, go to YSM_END. Otherwise, go to YSM_C1B.

- **YSM_C1B**: If SMK_Q202 = 1 or 2 (current daily or occasional smoker), go to YSM_Q1. Otherwise, go to YSM_END.

1. **YSM_Q1**: Where do you usually get your cigarettes? - 1=Buy from - Vending machine; 2=Buy from - Small grocery / corner store; 3=Buy from - Supermarket; 4=Buy from - Drug store; 5=Buy from - Gas station; 6=Buy from - Other store; 7=Buy from - Friend or someone else; 8=Given them by - Brother or sister; 9=Given them by - Mother or father; 10=Given them by - Friend or someone else; 11=Take them from - Mother, father or sibling; 12=Other - Specify; D...

- **YSM_C1S**: If YSM_Q1 = 12, go to YSM_Q1S. Otherwise, go to YSM_C2.

2. **YSM_Q1S**: INTERVIEWER: Specify. ___________________________ (80 spaces) - DK,R

- **YSM_C2**: If YSM_Q1 = 1, 2, 3, 4, 5, 6 or 7, go to YSM_Q3. Otherwise, go to YSM_Q2.

3. **YSM_Q2**: In the past 12 months, have you bought cigarettes for yourself or for someone else? - 1=Yes; 2=No [Go to YSM_Q5]; DK,R [Go to YSM_Q5]

4. **YSM_Q3**: In the past 12 months, have you been asked your age when buying cigarettes in a store? - 1=Yes; 2=No; DK,R

5. **YSM_Q4**: In the past 12 months, has anyone in a store refused to sell you cigarettes? - 1=Yes; 2=No; DK,R

6. **YSM_Q5**: In the past 12 months, have you asked a stranger to buy you cigarettes? YSM_END - 1=Yes; 2=No; DK,R

---

### EXPOSURE TO SECOND-HAND SMOKE (ETS) - 6 questions

- **ETS_C1**: If (do ETS block = 1), go to ETS_QINT. Otherwise, go to ETS_END.

- *ETS_QINT*: The next questions are about exposure to second-hand smoke. INTERVIEWER: Press <Enter> to continue.

- **ETS_C10**: If the number of household members = 1 and (SMK_Q202 = 1 or 2), go to ETS_Q30. Otherwise, go to ETS_Q10.

1. **ETS_Q10**: Including both household members and regular visitors, does anyone smoke inside your home, every day or almost every day? INTERVIEWER: Include cigarettes, cigars and pipes. - 1=Yes; 2=No [Go to ETS_C20]; DK,R [Go to ETS_END]

2. **ETS_Q11**: How many people smoke inside your home every day or almost every day? INTERVIEWER: Include household members and regular visitors. I_I_I Number of people - DK,R

- **ETS_C20**: If SMK_Q202 = 1 or 2 (current daily or occasional smoker), go to ETS_Q30. Otherwise, go to ETS_Q20.

3. **ETS_Q20**: In the past month, ^WERE ^YOU2 exposed to second-hand smoke, every day or almost every day, in a car or other private vehicle? - 1=Yes; 2=No; DK,R

4. **ETS_Q20B**: (In the past month,) ^WERE ^YOU1 exposed to second-hand smoke, every day or almost every day, in public places (such as bars, restaurants, shopping malls, arenas, bingo halls, bowling alleys)? - 1=Yes; 2=No; DK,R

5. **ETS_Q30**: Are there any restrictions against smoking cigarettes in your home? - 1=Yes; 2=No [Go to ETS_END]; DK,R [Go to ETS_END]

6. **ETS_Q31**: How is smoking restricted in your home? Mark all that apply. ETS_END - 1=Smokers are asked to refrain from smoking in the house; 2=Smoking is allowed in certain rooms only; 3=Smoking is restricted in the presence of young children; 4=Other restriction; DK,R

---

### ALCOHOL USE (ALC) - 10 questions

- **ALC_C1A**: If (do ALC block = 1), go to ALC_R1. Otherwise, go to ALC_END.

- *ALC_R1*: Now, some questions about ^YOUR2 alcohol consumption. When we use the word ‘drink’ it means: - one bottle or can of beer or a glass of draft - one glass of wine or a wine cooler - one drink or cocktail with 1 and a 1/...

1. **ALC_Q1**: During the past 12 months, that is, from [date one year ago] to yesterday, ^HAVE ^YOU2 had a drink of beer, wine, liquor or any other alcoholic beverage? - 1=Yes; 2=No [Go to ALC_Q5B]; DK,R [Go to ALC_END]

2. **ALC_Q2**: During the past 12 months, how often did ^YOU1 drink alcoholic beverages? - 1=Less than once a month; 2=Once a month; 3=2 to 3 times a month; 4=Once a week; 5=2 to 3 times a week; 6=4 to 6 times a week; 7=Every day; DK,R

3. **ALC_Q3**: How often in the past 12 months ^HAVE ^YOU1 had 5 or more drinks on one occasion? - 1=Never; 2=Less than once a month; 3=Once a month; 4=2 to 3 times a month; 5=Once a week; 6=More than once a week; DK,R

4. **ALC_Q5**: Thinking back over the past week, that is, from [date last week] to yesterday, did ^YOU2 have a drink of beer, wine, liquor or any other alcoholic beverage? - 1=Yes; 2=No [Go to ALC_C8]; DK,R [Go to ALC_C8]

5. **ALC_Q5A**: Starting with yesterday, that is [day name], how many drinks did ^YOU2 have: - 1=Sunday?; 2=Monday?; 3=Tuesday?; 4=Wednesday?; 5=Thursday?; 6=Friday?; 7=Saturday?; DK,R; [Then go to ALC_C8]

6. **ALC_Q5B**: ^HAVE_C ^YOU2 ever had a drink? - 1=Yes; 2=No [Go to ALC_END]; DK,R [Go to ALC_END]

7. **ALC_Q6**: Did ^YOU1 ever regularly drink more than 12 drinks a week? - 1=Yes; 2=No [Go to ALC_C8]; DK,R [Go to ALC_C8]

8. **ALC_Q7**: Why did ^YOU1 reduce or quit drinking altogether?  - 1=Dieting; 2=Athletic training; 3=Pregnancy; 4=Getting older; 5=Drinking too much / drinking problem; 6=Affected - work, studies, employment opportunities; 7=Interfered with family or home life; 8=Affected - physical health; 9=Affected - friendships or social relationships; 10=Affected - financial position; 11=Affected - outlook on life, happiness; 12=Influence of family or friends; 13=Life cha...

- **ALC_C7S**: If ALC_Q7 = 14, go to ALC_Q7S. Otherwise, go to ALC_C8.

9. **ALC_Q7S**: INTERVIEWER: Specify. _________________________ (80 spaces) - DK,R

- **ALC_C8**: If age > 19, go to ALC_END.

10. **ALC_Q8**: Not counting small sips, how old ^WERE ^YOU1 when ^YOU1 started drinking alcoholic beverages? INTERVIEWER: Drinking does not include having a few sips of wine for religious purposes. Minimum is 5; maximum is [current ... - DK,R

---

### MATERNAL EXPERIENCES (MEX) - 26 questions

*[Optional content]*

- **MEX_C01A**: If (do MEX block = 1), go to MEX_C01B. Otherwise, go to MEX_END.

- **MEX_C01B**: If proxy interview or sex = male or age < 15 or > 55, go to MEX_END. Otherwise, go to MEX_Q01.

1. **MEX_Q01**: The next questions are for recent mothers. Have you given birth in the past 5 years? INTERVIEWER: Do not include stillbirths. - 1=Yes; 2=No [Go to MEX_END]; DK,R [Go to MEX_END]

2. **MEX_Q01A**: In what year? INTERVIEWER: Enter year of birth of last baby. Minimum is [current year - 5]; maximum is [current year]. l_l_l_l_l Year - DK,R

3. **MEX_Q02**: Did you take a vitamin supplement containing folic acid before your (last) pregnancy, that is, before you found out that you were pregnant? - 1=Yes; 2=No; DK,R

4. **MEX_Q03**: (For your last baby,) did you breastfeed or try to breastfeed your baby, even if only for a short time? - 1=Yes [Go to MEX_Q05]; 2=No; DK,R [Go to MEX_C20]

5. **MEX_Q04**: What is the main reason that you did not breastfeed? - 1=Bottle feeding easier; 2=Formula as good as breast milk; 3=Breastfeeding is unappealing / disgusting; 4=Father / partner didn’t want me to; 5=Returned to work / school early; 6=C-Section; 7=Medical condition - mother; 8=Medical condition - baby; 9=Premature birth; 10=Multiple births (e.g. twins); 11=Wanted to drink alcohol; 12=Wanted to smoke; 13=Other - Specify; DK,R

- **MEX_C04S**: If MEX_Q04 = 13, go to MEX_Q04S. Otherwise, go to MEX_C20.

6. **MEX_Q04S**: INTERVIEWER: Specify. _________________________ (80 spaces) - DK,R; [Then go to MEX_C20]

7. **MEX_Q05**: Are you still breastfeeding? - 1=Yes [Go to MEX_Q07]; 2=No; DK,R [Go to MEX_C20]

8. **MEX_Q06**: How long did you breastfeed (your last baby)? - 1=Less than 1 week; 2=1 to 2 weeks; 3=3 to 4 weeks; 4=5 to 8 weeks; 5=9 weeks to less than 12 weeks; 6=3 months (12 weeks to less than 16 weeks); 7=4 months (16 weeks to less than 20 weeks); 8=5 months (20 weeks to less than 24 weeks); 9=6 months (24 weeks to less than 28 weeks); 10=7 to 9 months; 11=10 to 12 months; 12=More than 1 year; DK,R [Go to MEX_C20]

9. **MEX_Q07**: How old was your (last) baby when you first added any other liquids (e.g. milk, formula, water, teas, herbal mixtures) or solid foods to the baby’s feeds? INTERVIEWER: If exact age not known, obtain best estimate. - 1=Less than 1 week; 2=1 to 2 weeks; 3=3 to 4 weeks; 4=5 to 8 weeks; 5=9 weeks to less than 12 weeks; 6=3 months (12 weeks to less than 16 weeks); 7=4 months (16 weeks to less than 20 weeks); 8=5 months (20 weeks to less than 24 weeks); 9=6 months (24 weeks to less than 28 weeks); 10=7 to 9 months; 11=10 to 12 months; 12=More than 1 year; 13=Have not added liquids or solids [Go to MEX_Q09]; DK,R...

10. **MEX_Q08**: What is the main reason that you first added other liquids or solid foods? - 1=Not enough breast milk; 2=Baby was ready for solid foods; 3=Inconvenience / fatigue due to breastfeeding; 4=Difficulty with BF techniques (e.g., sore nipples, engorged breasts,; 5=Medical condition - mother; 6=Medical condition - baby; 7=Advice of doctor / health professional; 8=Returned to work / school; 9=Advice of partner / family / friends; 10=Formula equally healthy for baby; 11=Wanted t...

- **MEX_C08S**: If MEX_Q08 = 13, go to MEX_Q08S. Otherwise, go to MEX_C09.

11. **MEX_Q08S**: INTERVIEWER: Specify. _________________________ (80 spaces) - DK,R

- **MEX_C09**: If MEX_Q07 = 1 (baby less than 1 week), go to MEX_C10. Otherwise, go to MEX_Q09.

12. **MEX_Q09**: During the time when your (last) baby was only fed breast milk, did you give the baby a vitamin supplement containing Vitamin D? - 1=Yes; 2=No; DK,R

- **MEX_C10**: If MEX_Q05 = 1 (still breastfeeding), go to MEX_C20. Otherwise, go to MEX_Q10.

13. **MEX_Q10**: What is the main reason that you stopped breastfeeding? - 1=Not enough breast milk; 2=Baby was ready for solid foods; 3=Inconvenience / fatigue due to breastfeeding; 4=Difficulty with BF techniques (e.g., sore nipples, engorged breasts,; 5=Medical condition - mother; 6=Medical condition - baby; 7=Planned to stop at this time; 8=Child weaned him / herself (e.g., baby biting, refusing breast); 9=Advice of doctor / health professional; 10=Returned to wor...

- **MEX_C10S**: If MEX_Q10 = 15, go to MEX_Q10S. Otherwise, go to MEX_C20.

14. **MEX_Q10S**: INTERVIEWER: Specify. _________________________ (80 spaces) - DK,R

- **MEX_C20**: If SMK_Q202 = 1 or 2 or SMK_Q201A = 1 or SMK_Q201B = 1(current or former smoker), go to MEX_Q20. Otherwise, go to MEX_Q26.

15. **MEX_Q20**: During your last pregnancy, did you smoke daily, occasionally or not at all? Daily Smokers only - 1=Daily; 2=Occasionally [Go to MEX_Q22]; 3=Not at all [Go to MEX_C23]; DK,R [Go to MEX_Q26]

16. **MEX_Q21**: How many cigarettes did you usually smoke each day? l_l_l Number of cigarettes Occasional Smokers only - DK,R; [Then go to MEX_C23]

17. **MEX_Q22**: On the days that you smoked, how many cigarettes did you usually smoke? l_l_l Number of cigarettes - DK,R

- **MEX_C23**: If MEX_Q03 = 1 (breastfed last baby), go to MEX_Q23. Otherwise, go to MEX_Q26.

18. **MEX_Q23**: When you were breastfeeding (your last baby), did you smoke daily, occasionally or not at all? Daily smokers only - 1=Daily; 2=Occasionally [Go to MEX_Q25]; 3=Not at all [Go to MEX_Q26]; DK,R [Go to MEX_Q26]

19. **MEX_Q24**: How many cigarettes did you usually smoke each day? l_l_l Number of cigarettes Occasional smokers only - DK,R; [Then go to MEX_Q26]

20. **MEX_Q25**: On the days that you smoked, how many cigarettes did you usually smoke? l_l_l Number of cigarettes - DK,R

21. **MEX_Q26**: Did anyone regularly smoke in your presence during or after the pregnancy (about 6 months after)? - 1=Yes; 2=No; DK,R

- **MEX_C30**: If ALC_Q1 = 1 or ALC_Q5B = 1 (drank in past 12 months or ever drank), go to

22. **MEX_Q30**: . Otherwise, go to MEX_END.

23. **MEX_Q30**: Did you drink any alcohol during your last pregnancy? - 1=Yes; 2=No [Go to MEX_C32]; DK,R [Go to MEX_END]

24. **MEX_Q31**: How often did you drink? - 1=Less than once a month; 2=Once a month; 3=2 to 3 times a month; 4=Once a week; 5=2 to 3 times a week; 6=4 to 6 times a week; 7=Every day; DK,R

- **MEX_C32**: If MEX_Q03 = 2 (did not breastfeed last baby), go to MEX_END. Otherwise, go to MEX_Q32.

25. **MEX_Q32**: Did you drink any alcohol while you were breastfeeding (your last baby)? - 1=Yes; 2=No [Go to MEX_END]; DK,R [Go to MEX_END]

26. **MEX_Q33**: How often did you drink? MEX_END - 1=Less than once a month; 2=Once a month; 3=2 to 3 times a month; 4=Once a week; 5=2 to 3 times a week; 6=4 to 6 times a week; 7=Every day; DK,R

---

### ILLICIT DRUGS (DRG) - 39 questions

*[Optional content]*

- **DRG_C1**: If (do DRG block = 1), go to DRG_C2.

- **DRG_C2**: If proxy interview, go to DRG_END. Otherwise, go to DRG_R1.

- *DRG_R1*: I am going to ask some questions about drug use. Again, I would like to remind you that everything you say will remain strictly confidential. INTERVIEWER: Press <Enter> to continue.

1. **DRG_Q01**: Have you ever used or tried marijuana, cannabis or hashish?  - 1=Yes, just once; 2=Yes, more than once; 3=No [Go to DRG_Q04]; DK,R [Go to DRG_END]

2. **DRG_Q02**: Have you used it in the past 12 months? - 1=Yes; 2=No [Go to DRG_Q04]; DK,R [Go to DRG_Q04]

- **DRG_C03**: If DRG_Q01 = 1, go to DRG_Q04.

3. **DRG_Q03**: How often (did you use marijuana, cannabis or hashish in the past 12 months)?  - 1=Less than once a month; 2=1 to 3 times a month; 3=Once a week; 4=More than once a week; 5=Every day; DK,R

4. **DRG_Q04**: Have you ever used or tried cocaine or crack? - 1=Yes, just once; 2=Yes, more than once; 3=No [Go to DRG_Q07]; DK,R [Go to DRG_Q07]

5. **DRG_Q05**: Have you used it in the past 12 months? - 1=Yes; 2=No [Go to DRG_Q07]; DK,R [Go to DRG_Q07]

- **DRG_C06**: If DRG_Q04 = 1, go to DRG_Q07.

6. **DRG_Q06**: How often (did you use cocaine or crack in the past 12 months)?  - 1=Less than once a month; 2=1 to 3 times a month; 3=Once a week; 4=More than once a week; 5=Every day; DK,R

7. **DRG_Q07**: Have you ever used or tried speed (amphetamines)? - 1=Yes, just once; 2=Yes, more than once; 3=No [Go to DRG_Q10]; DK,R [Go to DRG_Q10]

8. **DRG_Q08**: Have you used it in the past 12 months? - 1=Yes; 2=No [Go to DRG_Q10]; DK,R [Go to DRG_Q10]

- **DRG_C09**: If DRG_Q07 = 1, go to DRG_Q10.

9. **DRG_Q09**: How often (did you use speed (amphetamines) in the past 12 months)?  - 1=Less than once a month; 2=1 to 3 times a month; 3=Once a week; 4=More than once a week; 5=Every day; DK,R

10. **DRG_Q10**: Have you ever used or tried ecstasy (MDMA) or other similar drugs? - 1=Yes, just once; 2=Yes, more than once; 3=No [Go to DRG_Q13]; DK,R [Go to DRG_Q13]

11. **DRG_Q11**: Have you used it in the past 12 months? - 1=Yes; 2=No [Go to DRG_Q13]; DK,R [Go to DRG_Q13]

- **DRG_C12**: If DRG_Q10 = 1, go to DRG_Q13.

12. **DRG_Q12**: How often (did you use ecstasy or other similar drugs in the past 12 months)?  - 1=Less than once a month; 2=1 to 3 times a month; 3=Once a week; 4=More than once a week; 5=Every day; DK,R

13. **DRG_Q13**: Have you ever used or tried hallucinogens, PCP or LSD (acid)? - 1=Yes, just once; 2=Yes, more than once; 3=No [Go to DRG_Q16]; DK,R [Go to DRG_Q16]

14. **DRG_Q14**: Have you used it in the past 12 months? - 1=Yes; 2=No [Go to DRG_Q16]; DK,R [Go to DRG_Q16]

- **DRG_C15**: If DRG_Q13 = 1, go to DRG_Q16.

15. **DRG_Q15**: How often (did you use hallucinogens, PCP or LSD in the past 12 months)?  - 1=Less than once a month; 2=1 to 3 times a month; 3=Once a week; 4=More than once a week; 5=Every day; DK,R

16. **DRG_Q16**: Did you ever sniff glue, gasoline or other solvents? - 1=Yes, just once; 2=Yes, more than once; 3=No [Go to DRG_Q19]; DK,R [Go to DRG_Q19]

17. **DRG_Q17**: Did you sniff some in the past 12 months? - 1=Yes; 2=No [Go to DRG_Q19]; DK,R [Go to DRG_Q19]

- **DRG_C18**: If DRG_Q16 = 1, go to DRG_Q19.

18. **DRG_Q18**: How often (did you sniff glue, gasoline or other solvents in the past 12 months)?  - 1=Less than once a month; 2=1 to 3 times a month; 3=Once a week; 4=More than once a week; 5=Every day; DK,R

19. **DRG_Q19**: Have you ever used or tried heroin? - 1=Yes, just once; 2=Yes, more than once; 3=No [Go to DRG_Q22]; DK,R [Go to DRG_Q22]

20. **DRG_Q20**: Have you used it in the past 12 months? - 1=Yes; 2=No [Go to DRG_Q22]; DK,R [Go to DRG_Q22]

- **DRG_C21**: If DRG_Q19 = 1, go to DRG_Q22.

21. **DRG_Q21**: How often (did you use heroin in the past 12 months)?  - 1=Less than once a month; 2=1 to 3 times a month; 3=Once a week; 4=More than once a week; 5=Every day; DK,R

22. **DRG_Q22**: Have you ever used or tried steroids, such as testosterone, dianabol or growth hormones, to increase your performance in a sport or activity or to change your physical appearance? - 1=Yes, just once; 2=Yes, more than once; 3=No [Go to DRG_C25A1]; DK,R [Go to DRG_C25A1]

23. **DRG_Q23**: Have you used it in the past 12 months? - 1=Yes; 2=No [Go to DRG_C25A1]; DK,R [Go to DRG_C25A1]

- **DRG_C24**: If DRG_Q22 = 1, go to DRG_C25A1.

24. **DRG_Q24**: How often (did you use steroids in the past 12 months)?  - 1=Less than once a month; 2=1 to 3 times a month; 3=Once a week; 4=More than once a week; 5=Every day; DK,R

- **DRG_C25A_1**: DRG_C25A1 = Count of instances where DRG_Q01, DRG_Q04, DRG_Q07, DRG_Q10,

25. **DRG_Q13**: , DRG_Q16 and DRG_Q19 = 3, DK or R. If DRG_C25A1 = 7, go to DRG_END.

- **DRG_C25A_2**: DRG_C25A2 = Count of instances where DRG_Q03, DRG_Q06, DRG_Q09, DRG_Q12,

26. **DRG_Q15**: , DRG_Q18 and DRG_Q21 >= 2. If DRG_C25A_2 >= 1, go to DRG_Q25A. Otherwise, go to DRG_END.

27. **DRG_Q25A**: During the past 12 months, did you ever need to use more drugs than usual in order to get high, or did you ever find that you could no longer get high on the amount you usually took? - 1=Yes; 2=No; DK,R

- *DRG_R25B*: People who cut down their substance use or stop using drugs altogether may not feel well if they have been using steadily for some time. These feelings are more intense and can last longer than the usual hangover. INT...

28. **DRG_Q25B**: During the past 12 months, did you ever have times when you stopped, cut down or went without drugs and then experienced symptoms like fatigue, headaches, diarrhoea, the shakes or emotional problems? - 1=Yes; 2=No; DK,R

29. **DRG_Q25C**: (During the past 12 months,) did you ever have times when you used drugs to keep from having such symptoms? - 1=Yes; 2=No; DK,R

30. **DRG_Q25D**: (During the past 12 months,) did you ever have times when you used drugs even though you promised yourself you wouldn’t, or times when you used a lot more drugs than you intended? - 1=Yes; 2=No; DK,R

31. **DRG_Q25E**: (During the past 12 months,) were there ever times when you used drugs more frequently, or for more days in a row than you intended? - 1=Yes; 2=No; DK,R

32. **DRG_Q25F**: (During the past 12 months,) did you ever have periods of several days or more when you spent so much time using drugs or recovering from the effects of using drugs that you had little time for anything else? - 1=Yes; 2=No; DK,R

33. **DRG_Q25G**: (During the past 12 months,) did you ever have periods of a month or longer when you gave up or greatly reduced important activities because of your use of drugs? - 1=Yes; 2=No; DK,R

34. **DRG_Q25H**: (During the past 12 months,) did you ever continue to use drugs when you knew you had a serious physical or emotional problem that might have been caused by or made worse by your use? - 1=Yes; 2=No; DK,R

- *DRG_R26*: Please tell me what number best describes how much your use of drugs interfered with each of the following activities during the past 12 months. For each activity, answer with a number between 0 and 10; 0 means “no in...

35. **DRG_Q26A**: How much did your use of drugs interfere with: ... your home responsibilities, like cleaning, shopping and taking care of the house or apartment? |_|_| Number - 0=No interference; 1=I; 2=I; 3=I; 4=I; 5=I; 6=I; 7=I; 8=I; 9=V; 10=Very severe interference; DK,R

36. **DRG_Q26B_1**: (How much did your use interfere with:) ... your ability to attend school? INTERVIEWER: If necessary, enter “11” to indicate “Not applicable”. |_|_| Number - 0=No interference; 1=I; 2=I; 3=I; 4=I; 5=I; 6=I; 7=I; 8=I; 9=V; 10=Very severe interference; DK,R

37. **DRG_Q26B_2**: (How much did your use interfere with:) ... your ability to work at a regular job? INTERVIEWER: If necessary, enter “11” to indicate “Not applicable”. |_|_| Number - 0=No interference; 1=I; 2=I; 3=I; 4=I; 5=I; 6=I; 7=I; 8=I; 9=V; 10=Very severe interference; DK,R

38. **DRG_Q26C**: (During the past 12 months,) how much did your use of drugs interfere with your ability to form and maintain close relationships with other people? Remember that 0 means “no interference” and 10 means “very severe int... - 0=No interference; 1=I; 2=I; 3=I; 4=I; 5=I; 6=I; 7=I; 8=I; 9=V; 10=Very severe interference; DK,R

39. **DRG_Q26D**: How much did your use of drugs interfere with your social life? |_|_| Number DRG_END - 0=No interference; 1=I; 2=I; 3=I; 4=I; 5=I; 6=I; 7=I; 8=I; 9=V; 10=Very severe interference; DK,R

---

### PROBLEM GAMBLING INDEX (CPG) - 36 questions

*[Optional content]*

- **CPG_C1**: If (do CPG block = 1), go to CPG_C2.

- **CPG_C2**: If proxy interview, go to CPG_END. Otherwise, go to CPG_C3.

- **CPG_C3**: Count instances where CPG_Q01B to CPG_Q01M = 7, 8, DK or R.

- *CPG_R01*: People have different definitions of gambling. They may bet money and gamble on many different things, including buying lottery tickets, playing bingo or playing card games with their family or friends. The next quest...

1. **CPG_Q01A**: In the past 12 months, how often have you bet or spent money on instant win/scratch tickets or daily lottery tickets (Keno, Pick 3, Encore, Banco, Extra)? Exclude all other kinds of lottery tickets such as 6/49, Super... - 1=Daily; 2=Between 2 to 6 times a week; 3=About once a week; 4=Between 2 to 3 times a month; 5=About once a month; 6=Between 6 to 11 times a year; 7=Between 1 to 5 times a year; 8=Never; DK,R

- **CPG_C01A**: If CPG_Q01A = R, go to CPG_END Otherwise, go to CPG_Q01B.

2. **CPG_Q01B**: (In the past 12 months,) how often have you bet or spent money on lottery tickets such as 6/49 and Super 7, raffles or fund-raising tickets? - 1=Daily; 2=Between 2 to 6 times a week; 3=About once a week; 4=Between 2 to 3 times a month; 5=About once a month; 6=Between 6 to 11 times a year; 7=Between 1 to 5 times a year; 8=Never; DK,R

3. **CPG_Q01C**: (In the past 12 months,) how often have you bet or spent money on Bingo? - 1=Daily; 2=Between 2 to 6 times a week; 3=About once a week; 4=Between 2 to 3 times a month; 5=About once a month; 6=Between 6 to 11 times a year; 7=Between 1 to 5 times a year; 8=Never; DK,R

4. **CPG_Q01D**: (In the past 12 months,) how often have you bet or spent money playing cards or board games with family or friends? - 1=Daily; 2=Between 2 to 6 times a week; 3=About once a week; 4=Between 2 to 3 times a month; 5=About once a month; 6=Between 6 to 11 times a year; 7=Between 1 to 5 times a year; 8=Never; DK,R

5. **CPG_Q01E**: (In the past 12 months,) how often have you bet or spent money on video lottery terminals (VLTs) outside of casinos? - 1=Daily; 2=Between 2 to 6 times a week; 3=About once a week; 4=Between 2 to 3 times a month; 5=About once a month; 6=Between 6 to 11 times a year; 7=Between 1 to 5 times a year; 8=Never; DK,R

6. **CPG_Q01F**: (In the past 12 months,) how often have you bet or spent money on coin slots or VLTs at a casino? - 1=Daily; 2=Between 2 to 6 times a week; 3=About once a week; 4=Between 2 to 3 times a month; 5=About once a month; 6=Between 6 to 11 times a year; 7=Between 1 to 5 times a year; 8=Never; DK,R

7. **CPG_Q01G**: (In the past 12 months,) how often have you bet or spent money on casino games other than coin slots or VLTs (for example, poker, roulette, blackjack, Keno)? - 1=Daily; 2=Between 2 to 6 times a week; 3=About once a week; 4=Between 2 to 3 times a month; 5=About once a month; 6=Between 6 to 11 times a year; 7=Between 1 to 5 times a year; 8=Never; DK,R

8. **CPG_Q01H**: (In the past 12 months,) how often have you bet or spent money on Internet or arcade gambling? - 1=Daily; 2=Between 2 to 6 times a week; 3=About once a week; 4=Between 2 to 3 times a month; 5=About once a month; 6=Between 6 to 11 times a year; 7=Between 1 to 5 times a year; 8=Never; DK,R

9. **CPG_Q01I**: In the past 12 months, how often have you bet or spent money on live horse racing at the track or off track? - 1=Daily; 2=Between 2 to 6 times a week; 3=About once a week; 4=Between 2 to 3 times a month; 5=About once a month; 6=Between 6 to 11 times a year; 7=Between 1 to 5 times a year; 8=Never; DK,R

10. **CPG_Q01J**: (In the past 12 months,) how often have you bet or spent money on sports such as sports lotteries (Sport Select, Pro-Line, Mise-au-jeu, Total), sports pool or sporting events? - 1=Daily; 2=Between 2 to 6 times a week; 3=About once a week; 4=Between 2 to 3 times a month; 5=About once a month; 6=Between 6 to 11 times a year; 7=Between 1 to 5 times a year; 8=Never; DK,R

11. **CPG_Q01K**: (In the past 12 months,) how often have you bet or spent money on speculative investments such as stocks, options or commodities? INTERVIEWER: Speculative investments refers to buying high-risk stocks, but does not in... - 1=Daily; 2=Between 2 to 6 times a week; 3=About once a week; 4=Between 2 to 3 times a month; 5=About once a month; 6=Between 6 to 11 times a year; 7=Between 1 to 5 times a year; 8=Never; DK,R

12. **CPG_Q01L**: In the past 12 months, how often have you bet or spent money on games of skill such as pool, golf, bowling or darts? - 1=Daily; 2=Between 2 to 6 times a week; 3=About once a week; 4=Between 2 to 3 times a month; 5=About once a month; 6=Between 6 to 11 times a year; 7=Between 1 to 5 times a year; 8=Never; DK,R

13. **CPG_Q01M**: (In the past 12 months,) how often have you bet or spent money on any other forms of gambling such as dog races, gambling at casino nights/country fairs, bet on sports with a bookie or gambling pools at work? - 1=Daily; 2=Between 2 to 6 times a week; 3=About once a week; 4=Between 2 to 3 times a month; 5=About once a month; 6=Between 6 to 11 times a year; 7=Between 1 to 5 times a year; 8=Never; DK,R

- **CPG_C01N**: If CPG_C03 = 12 and CPG_Q01A = 7, 8 or DK, go to CPG_END. Otherwise, go to CPG_Q01N.

14. **CPG_Q01N**: In the past 12 months, how much money, not including winnings, did you spend on all of your gambling activities?  - 1=Between 1 dollar and 50 dollars; 2=Between 51 dollars and 100 dollars; 3=Between 101 dollars and 250 dollars; 4=Between 251 dollars and 500 dollars; 5=Between 501 dollars and 1000 dollars; 6=More than 1000 dollars; DK,R

- *CPG_QINT2*: The next questions are about gambling attitudes and experiences. Again, all the questions will refer to the past 12 months. INTERVIEWER: Press <Enter> to continue.

15. **CPG_Q02**: In the past 12 months, how often have you bet or spent more money than you wanted to on gambling?  - 1=Never; 2=Sometimes; 3=Most of the time; 4=Almost always; 5=I am not a gambler [Go to CPG_END]; DK; R [Go to CPG_END]

16. **CPG_Q03**: (In the past 12 months,) how often have you needed to gamble with larger amounts of money to get the same feeling of excitement? - 1=Never; 2=Sometimes; 3=Most of the time; 4=Almost always; DK,R

17. **CPG_Q04**: (In the past 12 months,) when you gambled, how often did you go back another day to try to win back the money you lost? - 1=Never; 2=Sometimes; 3=Most of the time; 4=Almost always; DK,R

18. **CPG_Q05**: In the past 12 months, how often have you borrowed money or sold anything to get money to gamble? - 1=Never; 2=Sometimes; 3=Most of the time; 4=Almost always; DK,R

19. **CPG_Q06**: (In the past 12 months,) how often have you felt that you might have a problem with gambling? - 1=Never; 2=Sometimes; 3=Most of the time; 4=Almost always; DK,R

20. **CPG_Q07**: (In the past 12 months,) how often has gambling caused you any health problems, including stress or anxiety? - 1=Never; 2=Sometimes; 3=Most of the time; 4=Almost always; DK,R

21. **CPG_Q08**: (In the past 12 months,) how often have people criticized your betting or told you that you had a gambling problem, regardless of whether or not you thought it was true? - 1=Never; 2=Sometimes; 3=Most of the time; 4=Almost always; DK,R

22. **CPG_Q09**: (In the past 12 months,) how often has your gambling caused financial problems for you or your family? - 1=Never; 2=Sometimes; 3=Most of the time; 4=Almost always; DK,R

23. **CPG_Q10**: In the past 12 months, how often have you felt guilty about the way you gamble or what happens when you gamble? - 1=Never; 2=Sometimes; 3=Most of the time; 4=Almost always; DK,R

24. **CPG_Q11**: (In the past 12 months,) how often have you lied to family members or others to hide your gambling? - 1=Never; 2=Sometimes; 3=Most of the time; 4=Almost always; DK,R

25. **CPG_Q12**: (In the past 12 months,) how often have you wanted to stop betting money or gambling, but didn’t think you could? - 1=Never; 2=Sometimes; 3=Most of the time; 4=Almost always; DK,R

26. **CPG_Q13**: In the past 12 months, how often have you bet more than you could really afford to lose? - 1=Never; 2=Sometimes; 3=Most of the time; 4=Almost always; DK,R

27. **CPG_Q14**: (In the past 12 months,) have you tried to quit or cut down on your gambling but were unable to do it? - 1=Never; 2=Sometimes; 3=Most of the time; 4=Almost always; DK,R

28. **CPG_Q15**: (In the past 12 months,) have you gambled as a way of forgetting problems or to feel better when you were depressed? - 1=Never; 2=Sometimes; 3=Most of the time; 4=Almost always; DK,R

29. **CPG_Q16**: (In the past 12 months,) has your gambling caused any problems with your relationship with any of your family members or friends? - 1=Never; 2=Sometimes; 3=Most of the time; 4=Almost always; DK,R

- **CPG_C17**: For CPG_Q03 through CPG_Q10 and CPG_Q13, recode 1=0, 2=1, 3=2 and 4=3 into

- **CPG_C17A**: through CPG_C17I.

- **CPG_C17J**: = Sum CPG_C17A through CPG_C17I. If CPG_C17J <= 2, go to CPG_END. Otherwise, go to CPG_Q17.

30. **CPG_Q17**: Has anyone in your family ever had a gambling problem? - 1=Yes; 2=No; DK,R

31. **CPG_Q18**: In the past 12 months, have you used alcohol or drugs while gambling? - 1=Yes; 2=No; DK,R

- *CPG_QINT19*: Please tell me what number best describes how much your gambling activities interfered with each of the following activities during the past 12 months. For each activity, answer with a number between 0 and 10; 0 means...

32. **CPG_Q19A**: During the past 12 months, how much did your gambling activities interfere with your home responsibilities, like cleaning, shopping and taking care of the house or apartment? |_|_| Number - 0=No interference; 1=I; 2=I; 3=I; 4=I; 5=I; 6=I; 7=I; 8=I; 9=V; 10=Very severe interference; DK,R

33. **CPG_Q19B_1**: How much did these activities interfere with your ability to attend school? INTERVIEWER: If necessary, enter “11” to indicate “Not applicable”. |_|_| Number - 0=No interference; 1=I; 2=I; 3=I; 4=I; 5=I; 6=I; 7=I; 8=I; 9=V; 10=Very severe interference; DK,R

34. **CPG_Q19B_2**: How much did they interfere with your ability to work at a job? INTERVIEWER: If necessary, enter “11” to indicate “Not applicable”. |_|_| Number - 0=No interference; 1=I; 2=I; 3=I; 4=I; 5=I; 6=I; 7=I; 8=I; 9=V; 10=Very severe interference; DK,R

35. **CPG_Q19C**: (During the past 12 months,) how much did your gambling activities interfere with your ability to form and maintain close relationships with other people? (Remember that 0 means “no interference” and 10 means “very se... - 0=No interference; 1=I; 2=I; 3=I; 4=I; 5=I; 6=I; 7=I; 8=I; 9=V; 10=Very severe interference; DK,R

36. **CPG_Q19D**: How much did they interfere with your social life? |_|_| Number CPG_END - 0=No interference; 1=I; 2=I; 3=I; 4=I; 5=I; 6=I; 7=I; 8=I; 9=V; 10=Very severe interference; DK,R

---

### SATISFACTION WITH LIFE (SWL) - 9 questions

*[Optional content]*

- **SWL_C1**: If (do SWL block = 1), go to SWL_C2.

- **SWL_C2**: If proxy interview, go to SWL_END. Otherwise, go to SWL_QINT.

- *SWL_QINT*: Now I’d like to ask about your satisfaction with various aspects of your life. For each question, please tell me whether you are very satisfied, satisfied, neither satisfied nor dissatisfied, dissatisfied, or very dis...

1. **SWL_Q02**: How satisfied are you with your job or main activity? - 1=Very satisfied; 2=Satisfied; 3=Neither satisfied nor dissatisfied; 4=Dissatisfied; 5=Very dissatisfied; DK; R [Go to SWL_END]

2. **SWL_Q03**: How satisfied are you with your leisure activities? - 1=Very satisfied; 2=Satisfied; 3=Neither satisfied nor dissatisfied; 4=Dissatisfied; 5=Very dissatisfied; DK,R

3. **SWL_Q04**: (How satisfied are you) with your financial situation? - 1=Very satisfied; 2=Satisfied; 3=Neither satisfied nor dissatisfied; 4=Dissatisfied; 5=Very dissatisfied; DK,R

4. **SWL_Q05**: How satisfied are you with yourself? - 1=Very satisfied; 2=Satisfied; 3=Neither satisfied nor dissatisfied; 4=Dissatisfied; 5=Very dissatisfied; DK,R

5. **SWL_Q06**: How satisfied are you with the way your body looks? - 1=Very satisfied; 2=Satisfied; 3=Neither satisfied nor dissatisfied; 4=Dissatisfied; 5=Very dissatisfied; DK,R

6. **SWL_Q07**: How satisfied are you with your relationships with other family members? - 1=Very satisfied; 2=Satisfied; 3=Neither satisfied nor dissatisfied; 4=Dissatisfied; 5=Very dissatisfied; DK,R

7. **SWL_Q08**: (How satisfied are you) with your relationships with friends? - 1=Very satisfied; 2=Satisfied; 3=Neither satisfied nor dissatisfied; 4=Dissatisfied; 5=Very dissatisfied; DK,R

8. **SWL_Q09**: (How satisfied are you) with your housing? - 1=Very satisfied; 2=Satisfied; 3=Neither satisfied nor dissatisfied; 4=Dissatisfied; 5=Very dissatisfied; DK,R

9. **SWL_Q10**: (How satisfied are you) with your neighbourhood? SWL_END - 1=Very satisfied; 2=Satisfied; 3=Neither satisfied nor dissatisfied; 4=Dissatisfied; 5=Very dissatisfied; DK,R

---

### STRESS - SOURCES (STS) - 4 questions

*[Optional content]*

- **STS_C1**: If (do STS block = 1), go to STS_C2.

- **STS_C2**: If proxy interview, go to STS_END. Otherwise, go to STS_R1.

- *STS_R1*: Now a few questions about the stress in your life. INTERVIEWER: Press <Enter> to continue.

1. **STS_Q1**: In general, how would you rate your ability to handle unexpected and difficult problems, for example, a family or personal crisis? Would you say your ability is:  - 1=… excellent?; 2=… very good?; 3=… good?; 4=… fair?; 5=… poor?; DK,R [Go to STS_END]

2. **STS_Q2**: In general, how would you rate your ability to handle the day-to-day demands in your life, for example, handling work, family and volunteer responsibilities? Would you say your ability is:  - 1=… excellent?; 2=… very good?; 3=… good?; 4=… fair?; 5=… poor?; DK,R

3. **STS_Q3**: Thinking about stress in your day-to-day life, what would you say is the most important thing contributing to feelings of stress you may have? INTERVIEWER: Do not probe. - 1=Time pressures / not enough time; 2=Own physical health problem or condition; 3=Own emotional or mental health problem or condition; 4=Financial situation (e.g., not enough money, debt); 5=Own work situation (e.g., hours of work, working conditions); 6=School; 7=Employment status (e.g., unemployment); 8=Caring for - own children; 9=Caring for - others; 10=Other personal or family responsibili...

- **STS_C3S**: If STS_Q3 = 16, go to STS_Q3S. Otherwise, go to STS_END.

4. **STS_Q3S**: INTERVIEWER: Specify. ________________________ (80 spaces) STS_END - DK,R

---

### STRESS - COPING (STC) - 14 questions

*[Optional content]*

- **STC_C1**: If (do STC block = 1), go to STC_C2.

- **STC_C2**: If proxy interview, go to STC_END. Otherwise, go to STC_R1.

- *STC_R1*: Now a few questions about coping with stress. INTERVIEWER: Press <Enter> to continue.

1. **STC_Q1_1**: People have different ways of dealing with stress. Thinking about the ways you deal with stress, please tell me how often you do each of the following. How often do you try to solve the problem?  - 1=Often; 2=Sometimes; 3=Rarely; 4=Never; DK,R [Go to STC_END]

2. **STC_Q1_2**: To deal with stress, how often do you talk to others? - 1=Often; 2=Sometimes; 3=Rarely; 4=Never; DK,R

3. **STC_Q1_3**: (When dealing with stress,) how often do you avoid being with people? - 1=Often; 2=Sometimes; 3=Rarely; 4=Never; DK,R

4. **STC_Q1_4**: How often do you sleep more than usual to deal with stress? - 1=Often; 2=Sometimes; 3=Rarely; 4=Never; DK,R

5. **STC_Q1_5A**: When dealing with stress, how often do you try to feel better by eating more, or less, than usual? - 1=Often; 2=Sometimes; 3=Rarely; 4=Never; DK,R

6. **STC_Q1_5B**: (When dealing with stress,) how often do you try to feel better by smoking more cigarettes than usual? - 1=Often; 2=Sometimes; 3=Rarely; 4=Never; 5=Do not smoke; DK,R

7. **STC_Q1_5C**: When dealing with stress, how often do you try to feel better by drinking alcohol? - 1=Often; 2=Sometimes; 3=Rarely; 4=Never; DK,R

8. **STC_Q1_5D**: (When dealing with stress,) how often do you try to feel better by using drugs or medication? - 1=Often; 2=Sometimes; 3=Rarely; 4=Never; DK,R

9. **STC_Q1_6**: How often do you jog or do other exercise to deal with stress? - 1=Often; 2=Sometimes; 3=Rarely; 4=Never; DK,R

10. **STC_Q1_7**: How often do you pray or seek spiritual help to deal with stress? - 1=Often; 2=Sometimes; 3=Rarely; 4=Never; DK,R

11. **STC_Q1_8**: (To deal with stress,) how often do you try to relax by doing something enjoyable? - 1=Often; 2=Sometimes; 3=Rarely; 4=Never; DK,R

12. **STC_Q1_9**: (To deal with stress,) how often do you try to look on the bright side of things? - 1=Often; 2=Sometimes; 3=Rarely; 4=Never; DK,R

13. **STC_Q1_10**: How often do you blame yourself? - 1=Often; 2=Sometimes; 3=Rarely; 4=Never; DK,R

14. **STC_Q1_11**: To deal with stress, how often do you wish the situation would go away or somehow be finished? STC_END - 1=Often; 2=Sometimes; 3=Rarely; 4=Never; DK,R

---

### CHILDHOOD AND ADULT STRESSORS (CST) - 7 questions

*[Optional content]*

- **CST_C1**: If (do CST block = 1) go to CST_C2.

- **CST_C2**: If proxy interview or age < 18, go to CST_END. Otherwise, go to CST_R1.

- *CST_R1*: The next few questions ask about some things that may have happened to you while you were a child or a teenager, before you moved out of the house. Please tell me if any of these things have happened to you. INTERVIEW...

1. **CST_Q1**: Did you spend 2 weeks or more in the hospital? - 1=Yes; 2=No; DK; R [Go to CST_END]

2. **CST_Q2**: Did your parents get a divorce? - 1=Yes; 2=No; DK,R

3. **CST_Q3**: Did your father or mother not have a job for a long time when they wanted to be working? - 1=Yes; 2=No; DK,R

4. **CST_Q4**: Did something happen that scared you so much you thought about it for years after? - 1=Yes; 2=No; DK,R

5. **CST_Q5**: Were you sent away from home because you did something wrong? - 1=Yes; 2=No; DK,R

6. **CST_Q6**: Did either of your parents drink or use drugs so often that it caused problems for the family? - 1=Yes; 2=No; DK,R

7. **CST_Q7**: Were you ever physically abused by someone close to you? CST_END - 1=Yes; 2=No; DK,R

---

### WORK STRESS (WST) - 14 questions

*[Optional content]*

- **WST_C1**: If (do WST block) = 1, go to WST_C2.

- **WST_C2**: If proxy interview, go to WST_END. Otherwise, go to WST_C3.

- **WST_C3**: If age < 15 or > 75, or GEN_Q08 = 2, go to WST_END. Otherwise, go to WST_R4.

- *WST_R4*: The next few questions are about your main job or business in the past 12 months. I’m going to read you a series of statements that might describe your job situation. Please tell me if you strongly agree, agree, neith...

1. **WST_Q401**: Your job required that you learn new things. - 1=Strongly agree; 2=Agree; 3=Neither agree nor disagree; 4=Disagree; 5=Strongly disagree; DK; R [Go to WST_END]

2. **WST_Q402**: Your job required a high level of skill. - 1=Strongly agree; 2=Agree; 3=Neither agree nor disagree; 4=Disagree; 5=Strongly disagree; DK,R

3. **WST_Q403**: Your job allowed you freedom to decide how you did your job. - 1=Strongly agree; 2=Agree; 3=Neither agree nor disagree; 4=Disagree; 5=Strongly disagree; DK,R

4. **WST_Q404**: Your job required that you do things over and over. - 1=Strongly agree; 2=Agree; 3=Neither agree nor disagree; 4=Disagree; 5=Strongly disagree; DK,R

5. **WST_Q405**: Your job was very hectic. - 1=Strongly agree; 2=Agree; 3=Neither agree nor disagree; 4=Disagree; 5=Strongly disagree; DK,R

6. **WST_Q406**: You were free from conflicting demands that others made. - 1=Strongly agree; 2=Agree; 3=Neither agree nor disagree; 4=Disagree; 5=Strongly disagree; DK,R

7. **WST_Q407**: Your job security was good. - 1=Strongly agree; 2=Agree; 3=Neither agree nor disagree; 4=Disagree; 5=Strongly disagree; DK,R

8. **WST_Q408**: Your job required a lot of physical effort. - 1=Strongly agree; 2=Agree; 3=Neither agree nor disagree; 4=Disagree; 5=Strongly disagree; DK,R

9. **WST_Q409**: You had a lot to say about what happened in your job. - 1=Strongly agree; 2=Agree; 3=Neither agree nor disagree; 4=Disagree; 5=Strongly disagree; DK,R

10. **WST_Q410**: You were exposed to hostility or conflict from the people you worked with. - 1=Strongly agree; 2=Agree; 3=Neither agree nor disagree; 4=Disagree; 5=Strongly disagree; DK,R

11. **WST_Q411**: Your supervisor was helpful in getting the job done. - 1=Strongly agree; 2=Agree; 3=Neither agree nor disagree; 4=Disagree; 5=Strongly disagree; DK,R

12. **WST_Q412**: The people you worked with were helpful in getting the job done. - 1=Strongly agree; 2=Agree; 3=Neither agree nor disagree; 4=Disagree; 5=Strongly disagree; DK,R

13. **WST_Q412A**: You had the materials and equipment you needed to do your job. - 1=Strongly agree; 2=Agree; 3=Neither agree nor disagree; 4=Disagree; 5=Strongly disagree; DK,R

14. **WST_Q413**: How satisfied were you with your job? WST_END - 1=Very satisfied; 2=Somewhat satisfied; 3=Not too satisfied; 4=Not at all satisfied; DK,R

---

### SELF-ESTEEM (SFE) - 6 questions

*[Optional content]*

- **SFE_C500A**: If (do SFE block = 1), go to SFE_C500B.

- **SFE_C500B**: If proxy interview, go to SFE_END. Otherwise, go to SFE_R5.

- *SFE_R5*: Now a series of statements that people might use to describe themselves. Please tell me if you strongly agree, agree, neither agree nor disagree, disagree, or strongly disagree. INTERVIEWER: Press <Enter> to continue.

1. **SFE_Q501**: You feel that you have a number of good qualities. - 1=Strongly agree; 2=Agree; 3=Neither agree nor disagree; 4=Disagree; 5=Strongly disagree; DK; R [Go to SFE_END]

2. **SFE_Q502**: You feel that you’re a person of worth at least equal to others. - 1=Strongly agree; 2=Agree; 3=Neither agree nor disagree; 4=Disagree; 5=Strongly disagree; DK,R

3. **SFE_Q503**: You are able to do things as well as most other people. - 1=Strongly agree; 2=Agree; 3=Neither agree nor disagree; 4=Disagree; 5=Strongly disagree; DK,R

4. **SFE_Q504**: You take a positive attitude toward yourself. - 1=Strongly agree; 2=Agree; 3=Neither agree nor disagree; 4=Disagree; 5=Strongly disagree; DK,R

5. **SFE_Q505**: On the whole you are satisfied with yourself. - 1=Strongly agree; 2=Agree; 3=Neither agree nor disagree; 4=Disagree; 5=Strongly disagree; DK,R

6. **SFE_Q506**: All in all, you’re inclined to feel you’re a failure. SFE_END - 1=Strongly agree; 2=Agree; 3=Neither agree nor disagree; 4=Disagree; 5=Strongly disagree; DK,R

---

### SOCIAL SUPPORT - AVAILABILITY (SSA) - 20 questions

*[Optional content]*

- **SSA_C1**: If (do SSA block = 1), go to SSA_C2.

- **SSA_C2**: If proxy interview, go to SSA_END. Otherwise, go to SSA_R1.

- *SSA_R1*: Next are some questions about the support that is available to you. INTERVIEWER : Press <Enter> to continue.

1. **SSA_Q01**: Starting with a question on friendship, about how many close friends and close relatives do you have, that is, people you feel at ease with and can talk to about what is on your mind? |_|_| Close friends - DK,R [Go to SSA_END]

- *SSA_R2*: People sometimes look to others for companionship, assistance or other types of support. INTERVIEWER: Press <Enter> to continue.

2. **SSA_Q02**: How often is each of the following kinds of support available to you if you need it: … someone to help you if you were confined to bed?  - 1=None of the time; 2=A little of the time; 3=Some of the time; 4=Most of the time; 5=All of the time; DK,R [Go to SSA_END]

- **SSA_C02**: If SSA_Q02 = 2, 3, 4 or 5 then KEY_PHRASES21A = “to help you if you were confined to bed”.

3. **SSA_Q03**: (How often is each of the following kinds of support available to you if you need it:) … someone you can count on to listen to you when you need to talk? - 1=None of the time; 2=A little of the time; 3=Some of the time; 4=Most of the time; 5=All of the time; DK,R

- **SSA_C03**: If SSA_Q03 = 2, 3, 4 or 5 then KEY_PHRASES24A = “to listen to you”.

4. **SSA_Q04**: (How often is each of the following kinds of support available to you if you need it:) … someone to give you advice about a crisis? - 1=None of the time; 2=A little of the time; 3=Some of the time; 4=Most of the time; 5=All of the time; DK,R

- **SSA_C04**: If SSA_Q04 = 2, 3, 4 or 5 then KEY_PHRASES24A = “to give you advice”.

5. **SSA_Q05**: (How often is each of the following kinds of support available to you if you need it:) … someone to take you to the doctor if you needed it? - 1=None of the time; 2=A little of the time; 3=Some of the time; 4=Most of the time; 5=All of the time; DK,R

- **SSA_C05**: If SSA_Q05 = 2, 3, 4 or 5 then KEY_PHRASES21A = “to take you to the doctor”.

6. **SSA_Q06**: (How often is each of the following kinds of support available to you if you need it:) … someone who shows you love and affection? - 1=None of the time; 2=A little of the time; 3=Some of the time; 4=Most of the time; 5=All of the time; DK,R

- **SSA_C06**: If SSA_Q06 = 2, 3, 4 or 5 then KEY_PHRASES22A = “to show you affection”.

7. **SSA_Q07**: Again, how often is each of the following kinds of support available to you if you need it:) … someone to have a good time with? - 1=None of the time; 2=A little of the time; 3=Some of the time; 4=Most of the time; 5=All of the time; DK,R

- **SSA_C07**: If SSA_Q07 = 2, 3, 4 or 5 then KEY_PHRASES23A = “to have a good time with”.

8. **SSA_Q08**: (How often is each of the following kinds of support available to you if you need it:) … someone to give you information in order to help you understand a situation? - 1=None of the time; 2=A little of the time; 3=Some of the time; 4=Most of the time; 5=All of the time; DK,R

- **SSA_C08**: If SSA_Q08 = 2, 3, 4 or 5 then KEY_PHRASES24A = “to give you information”.

9. **SSA_Q09**: (How often is each of the following kinds of support available to you if you need it:) … someone to confide in or talk to about yourself or your problems? - 1=None of the time; 2=A little of the time; 3=Some of the time; 4=Most of the time; 5=All of the time; DK,R

- **SSA_C09**: If SSA_Q09 = 2, 3, 4 or 5 then KEY_PHRASES24A =“to confide in”.

10. **SSA_Q10**: (How often is each of the following kinds of support available to you if you need it:) … someone who hugs you? - 1=None of the time; 2=A little of the time; 3=Some of the time; 4=Most of the time; 5=All of the time; DK,R

- **SSA_C10**: If SSA_Q10 = 2, 3, 4 or 5 then KEY_PHRASES22A = “to hug you”.

11. **SSA_Q11**: (How often is each of the following kinds of support available to you if you need it:) … someone to get together with for relaxation? - 1=None of the time; 2=A little of the time; 3=Some of the time; 4=Most of the time; 5=All of the time; DK,R

- **SSA_C11**: If SSA_Q11 = 2, 3, 4 or 5 then KEY_PHRASE23A = “to relax with”.

12. **SSA_Q12**: (How often is each of the following kinds of support available to you if you need it:) … someone to prepare your meals if you were unable to do it yourself? - 1=None of the time; 2=A little of the time; 3=Some of the time; 4=Most of the time; 5=All of the time; DK,R

- **SSA_C12**: If SSA_Q12 = 2, 3, 4 or 5 then KEY_PHRASES21A = “to prepare your meals”.

13. **SSA_Q13**: (How often is each of the following kinds of support available to you if you need it:) … someone whose advice you really want? - 1=None of the time; 2=A little of the time; 3=Some of the time; 4=Most of the time; 5=All of the time; DK,R

- **SSA_C13**: If SSA_Q13 = 2, 3, 4 or 5 then KEY_PHRASES24A = “to advise you”.

14. **SSA_Q14**: Again, how often is each of the following kinds of support available to you if you need it:) … someone to do things with to help you get your mind off things? - 1=None of the time; 2=A little of the time; 3=Some of the time; 4=Most of the time; 5=All of the time; DK,R

- **SSA_C14**: If SSA_Q14 = 2, 3, 4 or 5 then KEY_PHRASES23A = “to do things with”.

15. **SSA_Q15**: (How often is each of the following kinds of support available to you if you need it:) … someone to help with daily chores if you were sick? - 1=None of the time; 2=A little of the time; 3=Some of the time; 4=Most of the time; 5=All of the time; DK,R

- **SSA_C15**: If SSA_Q15 = 2, 3, 4 or 5 then KEY_PHRASES21A = “to help with daily chores”.

16. **SSA_Q16**: (How often is each of the following kinds of support available to you if you need it:) … someone to share your most private worries and fears with? - 1=None of the time; 2=A little of the time; 3=Some of the time; 4=Most of the time; 5=All of the time; DK,R

- **SSA_C16**: If SSA_Q16 = 2, 3, 4 or 5 then KEY_PHRASES24A = “to share your worries and fears with”.

17. **SSA_Q17**: (How often is each of the following kinds of support available to you if you need it:) … someone to turn to for suggestions about how to deal with a personal problem? - 1=None of the time; 2=A little of the time; 3=Some of the time; 4=Most of the time; 5=All of the time; DK,R

- **SSA_C17**: If SSA_Q17 = 2, 3, 4 or 5 then KEY_PHRASES24A = “to turn to for suggestions”.

18. **SSA_Q18**: (How often is each of the following kinds of support available to you if you need it:) … someone to do something enjoyable with? - 1=None of the time; 2=A little of the time; 3=Some of the time; 4=Most of the time; 5=All of the time; DK,R

- **SSA_C18**: If SSA_Q18 = 2, 3, 4 or 5 then KEY_PHRASES23A = “to do something enjoyable with”.

19. **SSA_Q19**: (How often is each of the following kinds of support available to you if you need it:) … someone who understands your problems? - 1=None of the time; 2=A little of the time; 3=Some of the time; 4=Most of the time; 5=All of the time; DK,R

- **SSA_C19**: If SSA_Q19 = 2, 3, 4 or 5 then KEY_PHRASES24A = “to understand your problems”.

20. **SSA_Q20**: (How often is each of the following kinds of support available to you if you need it:) … someone to love you and make you feel wanted? - 1=None of the time; 2=A little of the time; 3=Some of the time; 4=Most of the time; 5=All of the time; DK,R

- **SSA_C20**: If SSA_Q20 = 2, 3, 4 or 5 then KEY_PHRASES22A = “to love you and make you feel wanted”. SSA_END

---

### SOCIAL SUPPORT - UTILIZATION (SSU) - 15 questions

*[Optional content]*

- **SSU_C1**: If (do SSU block = 1), go to SSU_C2.

- **SSU_C2**: If proxy interview, go to SSU_END. Otherwise, go to SSU_C3.

- **SSU_C3**: If any responses of 2, 3, 4 or 5 in SSA_Q02 to SSA_Q20, go to SSU_R1. Otherwise, go to SSU_END.

- *SSU_R1*: You have just mentioned that if you needed support, someone would be available for you. The next questions are about the support or help you actually received in the past 12 months. INTERVIEWER: Press <Enter> to conti...

- **SSU_C21**: If any responses of 2, 3, 4 or 5 in SSA_Q02 or SSA_Q05 or SSA_Q12 or SSA_Q15, then

- **SSU_C21**: = 1 (Yes) and go to SSU_Q21A. Otherwise, SSU_C21=2 (No) and go to SSU_C22.

1. **SSU_Q21A**: In the past 12 months, did you receive the following support: someone ^KEY_PHRASES21A? - 1=Yes; 2=No [Go to SSU_C22]; DK,R [Go to SSU_C22]

2. **SSA_Q05**: , SSA_Q12, SSA_Q15) If SSA_Q02 = 2, 3, 4 or 5 show ^PHRASE from

- **SSA_C02**: always in the 1st place. If 1 PHRASE, show 1st ^PHRASE in lowercase: ^PHRASE1. If 2 PHRASES, show 1st two ^PHRASES in lowercase: ^PHRASE1 and ^PHRASE2. If 3 or more PHRASES, show in lowercase: ^PHRASE1, ^PHRASE2 and ^PHRASE3). If SSA_Q02 = 2, 3, 4, 5 use “to help you if you we...

3. **SSU_Q21B**: When you needed it, how often did you receive this kind of support (in the past - 12=months)?; 1=Almost always; 2=Frequently; 3=Half the time; 4=Rarely; 5=Never; DK,R

- **SSU_C22**: If any responses of 2, 3, 4 or 5 in SSA_Q06 or SSA_Q10 or SSA_Q20 then SSU_C22= 1 (Yes) and go to SSU_Q22A. Otherwise, SSU_C22=2 (No) and go to SSU_C23.

4. **SSU_Q22A**: (In the past 12 months, did you receive the following support:) someone ^KEY_PHRASES22A? - 1=Yes; 2=No [Go to SSU_C23]; DK,R [Go to SSU_C23]

5. **SSA_Q10**: , SSA_Q20). If 1 PHRASE, show 1st ^PHRASE in lowercase: ^PHRASE1;If 2 PHRASES, show 1st two ^PHRASES in lowercase: ^PHRASE1 and ^PHRASE2; If 3 PHRASES, show in lowercase: ^PHRASE1, ^PHRASE2 and ^PHRASE3). If SSA_Q06 =...

6. **SSU_Q22B**: When you needed it, how often did you receive this kind of support (in the past - 12=months)?; 1=Almost always; 2=Frequently; 3=Half the time; 4=Rarely; 5=Never; DK,R

- **SSU_C23**: If any responses of 2, 3, 4 or 5 in SSA_Q07 or SSA_Q11 or SSA_Q14 or SSA_Q18, then

- **SSU_C23**: =1 (Yes) and go to SSU_Q23A. Otherwise, SSU_C23=2 (No) and go to SSU_C24.

7. **SSU_Q23A**: (In the past 12 months, did you receive the following support:) someone ^KEY_PHRASES23A? - 1=Yes; 2=No [Go to SSU_C24]; DK,R [Go to SSU_C24]

8. **SSA_Q11**: , SSA_Q14, SSA_Q18). If 1 PHRASE, show 1st ^PHRASE in lowercase: ^PHRASE1. If 2 PHRASES, show 1st two ^PHRASES in lowercase: ^PHRASE1 and ^PHRASE2. If 3 or more PHRASES, show in lowercase: ^PHRASE1, ^PHRASE2 and ^PHRA...

9. **SSU_Q23B**: When you needed it, how often did you receive this kind of support (in the past - 12=months)?; 1=Almost always; 2=Frequently; 3=Half the time; 4=Rarely; 5=Never; DK,R

- **SSU_C24**: If any responses of 2, 3, 4 or 5 in SSA_Q03 or SSA_Q04 or SSA_Q08 or SSA_Q09,

10. **SSA_Q13**: , SSA_Q16, SSA_Q17 or SSA_Q19, then SSU_C24 =1 (Yes) and go to

11. **SSU_Q24A**: . Otherwise, SSU_C24=2 (No) and go to SSU_END.

12. **SSU_Q24A**: (In the past 12 months, did you receive the following support:) someone ^KEY_PHRASES24A? - 1=Yes; 2=No [Go to SSU_END]; DK,R [Go to SSU_END]

13. **SSA_Q04**: , SSA_Q08, SSA_Q09, SSA_Q13, SSA_Q16, SSA_Q17or SSA_Q19;). If

14. **SSA_Q04**: and SSA_Q13 = 2, 3, 4 or 5 use only ^KEY_PHRASE SSA_C04, If 1 PHRASE, show 1st ^PHRASE in lowercase: ^PHRASE1. If 2 PHRASES, show 1st two ^PHRASES in lowercase: ^PHRASE1 and ^PHRASE2. If 3 or more PHRASES, show in low...

15. **SSU_Q24B**: When you needed it, how often did you receive this kind of support (in the past 12 months)? SSU_END - 1=Almost always; 2=Frequently; 3=Half the time; 4=Rarely; 5=Never; DK,R

---

### CONTACTS WITH MENTAL HEALTH PROFESSIONALS (CMH) - 4 questions

*[Optional content]*

- **CMH_C01A**: If (CMH block = 1), go to CMH_C01B.

- **CMH_C01B**: If proxy interview, go to CMH_END. Otherwise, go to CMH_R01K.

- *CMH_R1K*: Now some questions about mental and emotional well-being. INTERVIEWER: Press <Enter> to continue.

1. **CMH_Q01K**: In the past 12 months, that is, from [date one year ago] to yesterday, have you seen, or talked on the telephone, to a health professional about your emotional or mental health? - 1=Yes; 2=No [Go to CMH_END]; DK,R [Go to CMH_END]

2. **CMH_Q01L**: How many times (in the past 12 months)? l_l_l_l Times - DK,R

3. **CMH_Q01M**: Whom did you see or talk to? Mark all that apply. - 1=Family doctor or general practitioner; 2=Psychiatrist; 3=Psychologist; 4=Nurse; 5=Social worker or counselor; 6=Other - Specify

- **CMH_C01MS**: If CMH_Q01M = 6, go to CMH_Q01MS. Otherwise, go to CMH_END.

4. **CMH_Q01MS**: INTERVIEWER: Specify. ______________________ (80 spaces) - DK,R

---

### DISTRESS (DIS) - 17 questions

*[Optional content]*

- **DIS_C1**: If (do DIS block = 1), go to DIS_C2.

- **DIS_C2**: If proxy interview, go to DIS_END. Otherwise, go to DIS_R01.

- *DIS_R01*: The following questions deal with feelings you may have had during the past month. INTERVIEWER: Press <Enter> to continue.

1. **DIS_Q01A**: During the past month, that is, from [date one month ago] to yesterday, about how often did you feel: ... tired out for no good reason?  - 1=All of the time; 2=Most of the time; 3=Some of the time; 4=A little of the time; 5=None of the time; DK,R [Go to DIS_END]

2. **DIS_Q01B**: During the past month, that is, from [date one month ago] to yesterday, about how often did you feel: … nervous? - 1=All of the time; 2=Most of the time; 3=Some of the time; 4=A little of the time; 5=None of the time [Go to DIS_Q01D]; DK,R [Go to DIS_Q01D]

3. **DIS_Q01C**: (During the past month, that is, from [date one month ago] to yesterday, about how often did you feel:) ... so nervous that nothing could calm you down? - 1=All of the time; 2=Most of the time; 3=Some of the time; 4=A little of the time; 5=None of the time; DK,R

4. **DIS_Q01C**: will be given the value of 5 (none of the time).

5. **DIS_Q01D**: (During the past month, that is, from [date one month ago] to yesterday, about how often did you feel:) ... hopeless? - 1=All of the time; 2=Most of the time; 3=Some of the time; 4=A little of the time; 5=None of the time; DK,R

6. **DIS_Q01E**: During the past month, that is, from [date one month ago] to yesterday, about how often did you feel: ... restless or fidgety? - 1=All of the time; 2=Most of the time; 3=Some of the time; 4=A little of the time; 5=None of the time [Go to DIS_Q01G]; DK,R [Go to DIS_Q01G]

7. **DIS_Q01F**: (During the past month, that is, from [date one month ago] to yesterday, about how often did you feel:) … so restless you could not sit still? - 1=All of the time; 2=Most of the time; 3=Some of the time; 4=A little of the time; 5=None of the time; DK,R

8. **DIS_Q01F**: will be given the value of 5 (none of the time).

9. **DIS_Q01G**: (During the past month, that is, from [date one month ago] to yesterday, about how often did you feel:) …sad or depressed? - 1=All of the time; 2=Most of the time; 3=Some of the time; 4=A little of the time; 5=None of the time [Go to DIS_Q01I]; DK,R [Go to DIS_Q01I]

10. **DIS_Q01H**: (During the past month, that is, from [date one month ago] to yesterday, about how often did you feel:) …so depressed that nothing could cheer you up? - 1=All of the time; 2=Most of the time; 3=Some of the time; 4=A little of the time; 5=None of the time; DK,R

11. **DIS_Q01H**: will be given the value of 5 (none of the time).

12. **DIS_Q01I**: (During the past month, that is, from [date one month ago] to yesterday, about how often did you feel:) …that everything was an effort? - 1=All of the time; 2=Most of the time; 3=Some of the time; 4=A little of the time; 5=None of the time; DK,R

13. **DIS_Q01J**: (During the past month, that is, from [date one month ago] to yesterday, about how often did you feel:) …worthless? - 1=All of the time; 2=Most of the time; 3=Some of the time; 4=A little of the time; 5=None of the time; DK,R

14. **DIS_Q01K**: We just talked about feelings that occurred to different degrees during the past month. Taking them altogether, did these feelings occur more often in the past month than is usual for you, less often than usual or abo... - 1=More often; 2=Less often [Go to DIS_Q01M]; 3=About the same [Go to DIS_Q01N]; 4=Never have had any [Go to DIS_END]; DK,R [Go to DIS_END]

15. **DIS_Q01L**: Is that a lot more, somewhat more or only a little more often than usual? - 1=A lot; 2=Somewhat; 3=A little; DK,R; [Then go to DIS_Q01N]

16. **DIS_Q01M**: Is that a lot less, somewhat less or only a little less often than usual? - 1=A lot; 2=Somewhat; 3=A little; DK,R

17. **DIS_Q01N**: During the past month, how much did these feelings usually interfere with your life or activities? DIS_END - 1=A lot; 2=Some; 3=A little; 4=Not at all; DK,R

---

### DEPRESSION (DEP) - 31 questions

*[Optional content]*

- **DEP_C01**: If (do DEP block = 1), go to DEP_C02.

- **DEP_C02**: If proxy interview, go to DEP_END. Otherwise, go to DEP_Q02.

1. **DEP_Q02**: During the past 12 months, was there ever a time when you felt sad, blue, or depressed for 2 weeks or more in a row? - 1=Yes; 2=No [Go to DEP_Q16]; DK,R [Go to DEP_END]

2. **DEP_Q03**: For the next few questions, please think of the 2-week period during the past - 12=months when these feelings were the worst. During that time, how long did; 1=All day long; 2=Most of the day; 3=About half of the day [Go to DEP_Q16]; 4=Less than half of a day [Go to DEP_Q16]; DK,R [Go to DEP_END]

3. **DEP_Q04**: How often did you feel this way during those 2 weeks?  - 1=Every day; 2=Almost every day; 3=Less often [Go to DEP_Q16]; DK,R [Go to DEP_END]

4. **DEP_Q05**: During those 2 weeks did you lose interest in most things? - 1=Yes             (KEY PHRASE = Losing interest); 2=No; DK,R [Go to DEP_END]

5. **DEP_Q06**: Did you feel tired out or low on energy all of the time? - 1=Yes             (KEY PHRASE = Feeling tired); 2=No; DK,R [Go to DEP_END]

6. **DEP_Q07**: Did you gain weight, lose weight or stay about the same? - 1=Gained weight                   (KEY PHRASE = Gaining weight); 2=Lost weight                     (KEY PHRASE = Losing weight); 3=Stayed about the same [Go to DEP_Q09]; 4=Was on a diet [Go to DEP_Q09]; DK,R [Go to DEP_END]

7. **DEP_Q08A**: About how much did you [gain/lose]? INTERVIEWER: Enter amount only. |_|_| Weight - DK,R [Go to DEP_Q09]

8. **DEP_Q08B**: INTERVIEWER: Was that in pounds or in kilograms? - 1=Pounds; 2=Kilograms; (DK,R not allowed)

9. **DEP_Q09**: Did you have more trouble falling asleep than you usually do? - 1=Yes             (KEY PHRASE = Trouble falling asleep); 2=No [Go to DEP_Q11]; DK,R [Go to DEP_END]

10. **DEP_Q10**: How often did that happen?  - 1=Every night; 2=Nearly every night; 3=Less often; DK,R [Go to DEP_END]

11. **DEP_Q11**: Did you have a lot more trouble concentrating than usual? - 1=Yes             (KEY PHRASE = Trouble concentrating); 2=No; DK,R [Go to DEP_END]

12. **DEP_Q12**: At these times, people sometimes feel down on themselves, no good or worthless. Did you feel this way? - 1=Yes             (KEY PHRASE = Feeling down on yourself); 2=No; DK,R [Go to DEP_END]

13. **DEP_Q13**: Did you think a lot about death - either your own, someone else’s or death in general? - 1=Yes             (KEY PHRASE =Thoughts about death); 2=No; DK,R [Go to DEP_END]

- **DEP_C14**: If “Yes” in DEP_Q5, DEP_Q6, DEP_Q9, DEP_Q11, DEP_Q12 or DEP_Q13, or DEP_Q7 is “gain” or “lose”, go to DEP_Q14C. Otherwise, go to DEP_END.

14. **DEP_Q14C**: Reviewing what you just told me, you had 2 weeks in a row during the past 12 months when you were sad, blue or depressed and also had some other things like (KEY PHRASES). 

15. **DEP_Q14**: About how many weeks altogether did you feel this way during the past 12 months? |_|_| Weeks - DK,R [Go to DEP_END]

16. **DEP_Q15**: Think about the last time you felt this way for 2 weeks or more in a row. In what month was that? - 1=January                         7       July; 2=February                        8       August; 3=March                           9       September; 4=April                           10      October; 5=May                             11      November; 6=June                            12      December; DK,R; [Then go to DEP_END]

17. **DEP_Q16**: During the past 12 months, was there ever a time lasting 2 weeks or more when you lost interest in most things like hobbies, work or activities that usually give you pleasure? - 1=Yes; 2=No [Go to DEP_END]; DK,R [Go to DEP_END]

18. **DEP_Q17**: For the next few questions, please think of the 2-week period during the past - 12=months when you had the most complete loss of interest in things. During that; 1=All day long; 2=Most of the day; 3=About half of the day [Go to DEP_END]; 4=Less than half of a day [Go to DEP_END]; DK,R [Go to DEP_END]

19. **DEP_Q18**: How often did you feel this way during those 2 weeks?  - 1=Every day; 2=Almost every day; 3=Less often [Go to DEP_END]; DK,R [Go to DEP_END]

20. **DEP_Q19**: During those 2 weeks did you feel tired out or low on energy all the time? - 1=Yes               (KEY PHRASE = Feeling tired); 2=No; DK,R [Go to DEP_END]

21. **DEP_Q20**: Did you gain weight, lose weight, or stay about the same? - 1=Gained weight                   (KEY PHRASE = Gaining weight); 2=Lost weight                     (KEY PHRASE = Losing weight); 3=Stayed about the same [Go to DEP_Q22]; 4=Was on a diet [Go to DEP_Q22]; DK,R [Go to DEP_END]

22. **DEP_Q21A**: About how much did you [gain/lose]? INTERVIEWER: Enter amount only. |_|_| Weight - DK,R [Go to DEP_Q22]

23. **DEP_Q21B**: INTERVIEWER: Was that in pounds or in kilograms? - 1=Pounds; 2=Kilograms; (DK,R not allowed)

24. **DEP_Q22**: Did you have more trouble falling asleep than you usually do? - 1=Yes             (KEY PHRASE = Trouble falling asleep); 2=No [Go to DEP_Q24]; DK,R [Go to DEP_END]

25. **DEP_Q23**: How often did that happen?  - 1=Every night; 2=Nearly every night; 3=Less often; DK,R [Go to DEP_END]

26. **DEP_Q24**: Did you have a lot more trouble concentrating than usual? - 1=Yes             (KEY PHRASE = Trouble concentrating); 2=No; DK,R [Go to DEP_END]

27. **DEP_Q25**: At these times, people sometimes feel down on themselves, no good, or worthless. Did you feel this way? - 1=Yes             (KEY PHRASE = Feeling down on yourself); 2=No; DK,R [Go to DEP_END]

28. **DEP_Q26**: Did you think a lot about death - either your own, someone else’s, or death in general? - 1=Yes             (KEY PHRASE =Thoughts about death); 2=No; DK,R [Go to DEP_END]

- **DEP_C27**: If any “Yes” in DEP_Q19, DEP_Q22, DEP_Q24, DEP_Q25 or DEP_Q26, or DEP_Q20 is “gain” or “lose”, go to DEP_Q27C. Otherwise, go to DEP_END.

29. **DEP_Q27C**: Reviewing what you just told me, you had 2 weeks in a row during the past 12 months when you lost interest in most things and also had some other things like (KEY PHRASES). 

30. **DEP_Q27**: About how many weeks did you feel this way during the past 12 months? |_|_| Weeks - DK,R [Go to DEP_END]

31. **DEP_Q28**: Think about the last time you had 2 weeks in a row when you felt this way. In what month was that? DEP_END - 1=January                       7       July; 2=February                      8       August; 3=March                         9       September; 4=April                         10      October; 5=May                           11      November; 6=June                          12      December; DK,R

---

### SUICIDAL THOUGHTS AND ATTEMPTS (SUI) - 6 questions

*[Optional content]*

- **SUI_C1A**: If (do SUI block = 1), go to SUI_C1B.

- **SUI_C1B**: If proxy interview or if age < 15, go to SUI_END. Otherwise, go to SUI_QINT.

- *SUI_QINT*: The following questions relate to the sensitive issue of suicide. INTERVIEWER: Press <Enter> to continue.

1. **SUI_Q1**: Have you ever seriously considered committing suicide or taking your own life? - 1=Yes; 2=No [Go to SUI_END]; DK,R [Go to SUI_END]

2. **SUI_Q2**: Has this happened in the past 12 months? - 1=Yes; 2=No [Go to SUI_END]; DK,R [Go to SUI_END]

3. **SUI_Q3**: Have you ever attempted to commit suicide or tried taking your own life? - 1=Yes; 2=No [Go to SUI_END]; DK,R [Go to SUI_END]

4. **SUI_Q4**: Did this happen in the past 12 months? - 1=Yes; 2=No [Go to SUI_END]; DK,R [Go to SUI_END]

5. **SUI_Q5**: Did you see, or talk on the telephone, to a health professional following your attempt to commit suicide? - 1=Yes; 2=No [Go to SUI_END]; DK,R [Go to SUI_END]

6. **SUI_Q6**: Whom did you see or talk to? Mark all that apply. SUI_END - 1=Family doctor or general practitioner; 2=Psychiatrist; 3=Psychologist; 4=Nurse; 5=Social worker or counsellor; 6=Religious or spiritual advisor such as a priest, chaplain or rabbi; 7=Teacher or guidance counsellor; 8=Other; DK,R

---

### INJURIES (INJ) - 28 questions

- **INJ_C1**: If (do INJ block = 1), go to REP_R1. Otherwise, go to INJ_END. Repetitive strain

- *REP_R1*: This next section deals with repetitive strain injuries. By this we mean injuries caused by overuse or by repeating the same movement frequently. (For example, carpal tunnel syndrome, tennis elbow or tendonitis.) INTE...

1. **REP_Q1**: In the past 12 months, that is, from [date one year ago] to yesterday, did ^YOU2 have any injuries due to repetitive strain which were serious enough to limit ^YOUR1 normal activities? - 1=Yes; 2=No [Go to INJ_R1]; DK,R [Go to INJ_R1]

2. **REP_Q3**: Thinking about the most serious repetitive strain, what part of the body was affected? - 1=Head; 2=Neck; 3=Shoulder, upper arm; 4=Elbow, lower arm; 5=Wrist; 6=Hand; 7=Hip; 8=Thigh; 9=Knee, lower leg; 10=Ankle, foot; 11=Upper back or upper spine (excluding neck); 12=Lower back or lower spine; 13=Chest (excluding back and spine); 14=Abdomen or pelvis (excluding back and spine); DK,R

3. **REP_Q4**: What type of activity ^WERE ^YOU1 doing when ^YOU1 got this repetitive strain?  - 1=Sports or physical exercise (include school activities); 2=Leisure or hobby (include volunteering); 3=Working at a job or business (exclude travel to or from work); 4=Travel to or from work; 5=Household chores, other unpaid work or education; 6=Sleeping, eating, personal care; 7=Other - Specify; DK,R

- **REP_C4S**: If REP_Q4 = 7, go to INJ_Q4S. Otherwise, go to REP_R1.

4. **REP_Q4S**: INTERVIEWER: Specify. _________________________ (80 spaces) Number of injuries and details of most serious injury - DK,R

- *INJ_R1*: Now some questions about [other] injuries which occurred in the past 12 months, and were serious enough to limit ^YOUR2 normal activities. For example, a broken bone, a bad cut or burn, a sprain, or a poisoning. INTER...

5. **INJ_Q01**: [Not counting repetitive strain injuries, in the past 12 months,/In the past 12 months,] that is, from [date one year ago] to yesterday, ^WERE ^YOU2 injured? - 1=Yes; 2=No [Go to INJ_Q16]; DK,R [Go to INJ_END]

6. **INJ_Q02**: How many times ^WERE ^YOU1 injured? |_|_| Times - DK,R [Go to INJ_END]

7. **INJ_Q03**: [Thinking about the most serious injury, in which month/In which month] did it happen? - 1=January                                 7       July; 2=February                                8       August; 3=March                                   9       September; 4=April                                   10      October; 5=May                                     11      November; 6=June                                    12      December; DK,R [Go to INJ_Q05]

- **INJ_C04**: If INJ_Q03 = [current month], go to INJ_Q04. Otherwise, go to INJ_Q05.

8. **INJ_Q04**: Was that this year or last year? - 1=This year; 2=Last year; DK,R

9. **INJ_Q05**: What type of injury did ^YOU1 have? For example, a broken bone or burn. - 1=Multiple injuries; 2=Broken or fractured bones; 3=Burn, scald, chemical burn; 4=Dislocation; 5=Sprain or strain; 6=Cut, puncture, animal or human bite (open wound); 7=Scrape, bruise, blister; 8=Concussion or other brain injury [Go to INJ_Q08]; 9=Poisoning [Go to INJ_Q08]; 10=Injury to internal organs [Go to INJ_Q07]; 11=Other - Specify; DK,R

- **INJ_C05S**: If INJ_Q05 = 11, go to INJ_Q05S. Otherwise, go to INJ_Q06.

10. **INJ_Q05S**: INTERVIEWER: Specify. _________________________ (80 spaces) - DK,R

11. **INJ_Q06**: What part of the body was injured? - 1=Multiple sites; 2=Eyes; 3=Head (excluding eyes); 4=Neck; 5=Shoulder, upper arm; 6=Elbow, lower arm; 7=Wrist; 8=Hand; 9=Hip; 10=Thigh; 11=Knee, lower leg; 12=Ankle, foot; 13=Upper back or upper spine (excluding neck); 14=Lower back or lower spine; 15=Chest (excluding back and spine); 16=Abdomen or pelvis (excluding back and spine); DK,R; [Then go to INJ_Q08]

12. **INJ_Q07**: What part of the body was injured? - 1=Chest (within rib cage); 2=Abdomen or pelvis (below ribs); 3=Other - Specify; DK,R

- **INJ_C07S**: If INJ_Q07 = 3, go to INJ_Q07S. Otherwise, go to INJ_Q08.

13. **INJ_Q07S**: INTERVIEWER: Specify. _________________________ (80 spaces) - DK,R

14. **INJ_Q08**: Where did the injury happen? INTERVIEWER: If respondent says ‘At work’, probe for type of workplace. - 1=In a home or its surrounding area; 2=Residential institution; 3=School, college, university (exclude sports areas); 4=Sports or athletics area of school, college, university; 5=Other sports or athletics area (exclude school sports areas); 6=Other institution (e.g., church, hospital, theatre, civic building); 7=Street, highway, sidewalk; 8=Commercial area (e.g., store, restaurant, office build...

- **INJ_C08S**: If INJ_Q08 = 12, go to INJ_Q08S. Otherwise, go to INJ_Q09.

15. **INJ_Q08S**: INTERVIEWER: Specify. _________________________ (80 spaces) - DK,R

16. **INJ_Q09**: What type of activity ^WERE ^YOU1 doing when ^YOU1 ^WERE injured? - 1=Sports or physical exercise (include school activities); 2=Leisure or hobby (include volunteering); 3=Working at a job or business (exclude travel to or from work); 4=Travel to or from work; 5=Household chores, other unpaid work or education; 6=Sleeping, eating, personal care; 7=Other - Specify; DK,R

- **INJ_C09S**: If INJ_Q09 = 7, go to INJ_Q09S. Otherwise, go to INJ_Q10.

17. **INJ_Q09S**: INTERVIEWER: Specify. _________________________ (80 spaces) - DK,R

18. **INJ_Q10**: Was the injury the result of a fall? INTERVIEWER: Select “No” for transportation accidents. - 1=Yes; 2=No [Go to INJ_Q12]; DK,R [Go to INJ_Q12]

19. **INJ_Q11**: How did ^YOU1 fall? - 1=While skating, skiing, snowboarding, in-line skating or skateboarding; 2=Going up or down stairs / steps (icy or not); 3=Slip, trip or stumble on ice or snow; 4=Slip, trip or stumble on any other surface; 5=From furniture (e.g., bed, chair); 6=From elevated position (e.g., ladder, tree); 7=Other - Specify; DK,R

- **INJ_C11S**: If INJ_Q11 = 7, go to INJ_Q11S. Otherwise, go to INJ_Q13.

20. **INJ_Q11S**: INTERVIEWER: Specify. _________________________ (80 spaces) - DK,R; [Then go to INJ_Q13]

21. **INJ_Q12**: What caused the injury? - 1=Transportation accident; 2=Accidentally bumped, pushed, bitten, etc. by person or animal; 3=Accidentally struck or crushed by object(s); 4=Accidental contact with sharp object, tool or machine; 5=Smoke, fire, flames; 6=Accidental contact with hot object, liquid or gas; 7=Extreme weather or natural disaster; 8=Overexertion or strenuous movement; 9=Physical assault; 10=Other - Specify; DK,R

- **INJ_C12S**: If INJ_Q12 = 10, go to INJ_Q12S. Otherwise, go to INJ_Q13.

22. **INJ_Q12S**: INTERVIEWER: Specify. _________________________ (80 spaces) - DK,R

23. **INJ_Q13**: Did ^YOU2 receive any medical attention for the injury from a health professional in the 48 hours following the injury? - 1=Yes; 2=No [Go to INJ_Q16]; DK,R [Go to INJ_Q16]

24. **INJ_Q14**: Where did ^YOU1 receive treatment?  - 1=Doctor’s office; 2=Hospital emergency room; 3=Hospital outpatient clinic (e.g. day surgery, cancer); 4=Walk-in clinic; 5=Appointment clinic; 6=Community health centre / CLSC; 7=At work; 8=At school; 9=At home; 10=Telephone consultation only; 11=Other - Specify; DK,R

- **INJ_C14S**: If INJ_Q14 = 11, go to INJ_Q14S. Otherwise, go to INJ_Q15.

25. **INJ_Q14S**: INTERVIEWER: Specify. _________________________ (80 spaces) - DK,R

26. **INJ_Q15**: ^WERE ^YOU1 admitted to a hospital overnight? - 1=Yes; 2=No; DK,R

27. **INJ_Q16**: Did ^YOU2 have any other injuries in the past 12 months that were treated by a health professional, but did not limit ^YOUR1 normal activities? - 1=Yes; 2=No [Go to INJ_END]; DK,R [Go to INJ_END]

28. **INJ_Q17**: How many injuries? |_|_| Injuries INJ_END - DK,R

---

### HEALTH UTILITY INDEX (HUI) - 31 questions

*[Optional content]*

- **HUI_C1**: If (do HUI block = 1), go to HUI_QINT1.

- *HUI_QINT1*: The next set of questions asks about ^YOUR2 day-to-day health. The questions are not about illnesses like colds that affect people for short periods of time. They are concerned with a person’s usual abilities. You may...

1. **HUI_Q01**: ^ARE_C ^YOU1 usually able to see well enough to read ordinary newsprint without glasses or contact lenses? - 1=Yes [Go to HUI_Q04]; 2=No; DK,R [Go to HUI_END]

2. **HUI_Q02**: ^ARE_C ^YOU1 usually able to see well enough to read ordinary newsprint with glasses or contact lenses? - 1=Yes [Go to HUI_Q04]; 2=No; DK,R

3. **HUI_Q03**: ^ARE_C ^YOU1 able to see at all? - 1=Yes; 2=No [Go to HUI_Q06]; DK,R [Go to HUI_Q06]

4. **HUI_Q04**: ^ARE_C ^YOU1 able to see well enough to recognize a friend on the other side of the street without glasses or contact lenses? - 1=Yes [Go to HUI_Q06]; 2=No; DK,R [Go to HUI_Q06]

5. **HUI_Q05**: ^ARE_C ^YOU1 usually able to see well enough to recognize a friend on the other side of the street with glasses or contact lenses? Hearing - 1=Yes; 2=No; DK,R

6. **HUI_Q06**: ^ARE_C ^YOU2 usually able to hear what is said in a group conversation with at least 3 other people without a hearing aid? - 1=Yes [Go to HUI_Q10]; 2=No; DK,R [Go to HUI_Q10]

7. **HUI_Q07**: ^ARE_C ^YOU1 usually able to hear what is said in a group conversation with at least 3 other people with a hearing aid? - 1=Yes [Go to HUI_Q08]; 2=No; DK,R

8. **HUI_Q07A**: ^ARE_C ^YOU1 able to hear at all? - 1=Yes; 2=No [Go to HUI_Q10]; DK,R [Go to HUI_Q10]

9. **HUI_Q08**: ^ARE_C ^YOU1 usually able to hear what is said in a conversation with one other person in a quiet room without a hearing aid ? - 1=Yes [Go to HUI_Q10]; 2=No; DK; R [Go to HUI_Q10]

10. **HUI_Q09**: ^ARE_C ^YOU1 usually able to hear what is said in a conversation with one other person in a quiet room with a hearing aid? Speech - 1=Yes; 2=No; DK,R

11. **HUI_Q10**: ^ARE_C ^YOU2 usually able to be understood completely when speaking with strangers in ^YOUR1 own language? - 1=Yes [Go to HUI_Q14]; 2=No; DK; R [Go to HUI_Q14]

12. **HUI_Q11**: ^ARE_C ^YOU1 able to be understood partially when speaking with strangers? - 1=Yes; 2=No; DK,R

13. **HUI_Q12**: ^ARE_C ^YOU1 able to be understood completely when speaking with those who know ^HIMHER well? - 1=Yes [Go to HUI_Q14]; 2=No; DK; R [Go to HUI_Q14]

14. **HUI_Q13**: ^ARE_C ^YOU1 able to be understood partially when speaking with those who know ^HIMHER well? Getting Around - 1=Yes; 2=No; DK,R

15. **HUI_Q14**: ^ARE_C ^YOU2 usually able to walk around the neighbourhood without difficulty and without mechanical support such as braces, a cane or crutches? - 1=Yes [Go to HUI_Q21]; 2=No; DK,R [Go to HUI_Q21]

16. **HUI_Q15**: ^ARE_C ^YOU1 able to walk at all? - 1=Yes; 2=No [Go to HUI_Q18]; DK,R [Go to HUI_Q18]

17. **HUI_Q16**: ^DOVERB_C ^YOU1 require mechanical support such as braces, a cane or crutches to be able to walk around the neighbourhood? - 1=Yes; 2=No; DK,R

18. **HUI_Q17**: ^DOVERB_C ^YOU1 require the help of another person to be able to walk? - 1=Yes; 2=No; DK,R

19. **HUI_Q18**: ^DOVERB_C ^YOU1 require a wheelchair to get around? - 1=Yes; 2=No [Go to HUI_Q21]; DK,R [Go to HUI_Q21]

20. **HUI_Q19**: How often ^DOVERB ^YOU1 use a wheelchair?  - 1=Always; 2=Often; 3=Sometimes; 4=Never; DK,R

21. **HUI_Q20**: ^DOVERB_C ^YOU1 need the help of another person to get around in the wheelchair? Hands and Fingers - 1=Yes; 2=No; DK,R

22. **HUI_Q21**: ^ARE_C ^YOU2 usually able to grasp and handle small objects such as a pencil or scissors? - 1=Yes [Go to HUI_Q25]; 2=No; DK,R [Go to HUI_Q25]

23. **HUI_Q22**: ^DOVERB_C ^YOU1 require the help of another person because of limitations in the use of hands or fingers? - 1=Yes; 2=No [Go to HUI_Q24]; DK,R [Go to HUI_Q24]

24. **HUI_Q23**: ^DOVERB_C ^YOU1 require the help of another person with:  - 1=… some tasks?; 2=… most tasks?; 3=… almost all tasks?; 4=… all tasks?; DK,R

25. **HUI_Q24**: ^DOVERB_C ^YOU1 require special equipment, for example, devices to assist in dressing, because of limitations in the use of hands or fingers? Feelings - 1=Yes; 2=No; DK,R

26. **HUI_Q25**: Would you describe [yourself/FNAME] as being usually: Memory - 1=… happy and interested in life?; 2=… somewhat happy?; 3=… somewhat unhappy?; 4=… unhappy with little interest in life?; 5=… so unhappy that life is not worthwhile?; DK,R

27. **HUI_Q26**: How would you describe ^YOUR1 usual ability to remember things? Thinking - 1=Able to remember most things; 2=Somewhat forgetful; 3=Very forgetful; 4=Unable to remember anything at all; DK,R

28. **HUI_Q27**: How would you describe ^YOUR1 usual ability to think and solve day-to-day problems? Pain and Discomfort - 1=Able to think clearly and solve problems; 2=Having a little difficulty; 3=Having some difficulty; 4=Having a great deal of difficulty; 5=Unable to think or solve problems; DK,R

29. **HUI_Q28**: ^ARE ^YOU2 usually free of pain or discomfort? - 1=Yes [Go to HUI_END]; 2=No; DK,R [Go to HUI_END]

30. **HUI_Q29**: How would you describe the usual intensity of ^YOUR1 pain or discomfort?  - 1=Mild; 2=Moderate; 3=Severe; DK,R

31. **HUI_Q30**: How many activities does ^YOUR1 pain or discomfort prevent? HUI_END - 1=None; 2=A few; 3=Some; 4=Most; DK,R

---

### HEALTH STATUS - SF-36 (SFR) - 34 questions

*[Optional content]*

- **SFR_C03**: If (do SFR block = 1), go to SFR_R03A.

- *SFR_R03A*: Although some of the following questions may seem repetitive, the next section deals with another way of measuring health status. INTERVIEWER: Press <Enter> to continue.

- *SFR_R03B*: The questions are about how ^YOU2 [feel/feels] and how well ^YOU1 ^ARE able to do ^YOUR1 usual activities. INTERVIEWER: Press <Enter> to continue. Note: If interview is non-proxy, use “feel”. Otherwise, use “feels”.

1. **SFR_Q03**: I’ll start with a few questions concerning activities ^YOU2 might do during a typical day. Does ^YOUR1 health limit ^HIMHER in any of the following activities: … in vigorous activities, such as running, lifting heavy ... - 1=Limited a lot; 2=Limited a little; 3=Not at all limited; DK,R [Go to SFR_END]

2. **SFR_Q04**: (Does ^YOUR1 health limit ^HIMHER:) … in moderate activities, such as moving a table, pushing a vacuum cleaner, bowling, or playing golf?  - 1=Limited a lot; 2=Limited a little; 3=Not at all limited; DK,R

3. **SFR_Q05**: (Does ^YOUR1 health limit ^HIMHER:) … in lifting or carrying groceries? - 1=Limited a lot; 2=Limited a little; 3=Not at all limited; DK,R

4. **SFR_Q06**: (Does ^YOUR1 health limit ^HIMHER:) … in climbing several flights of stairs? - 1=Limited a lot; 2=Limited a little; 3=Not at all limited; DK,R

5. **SFR_Q07**: (Does ^YOUR1 health limit ^HIMHER:) … in climbing one flight of stairs? - 1=Limited a lot; 2=Limited a little; 3=Not at all limited; DK,R

6. **SFR_Q08**: (Does ^YOUR1 health limit ^HIMHER:) … in bending, kneeling, or stooping? - 1=Limited a lot; 2=Limited a little; 3=Not at all limited; DK,R

7. **SFR_Q09**: (Does ^YOUR1 health limit ^HIMHER:) … in walking more than one kilometre? - 1=Limited a lot; 2=Limited a little; 3=Not at all limited; DK,R

8. **SFR_Q10**: (Does ^YOUR1 health limit ^HIMHER:) … in walking several blocks? - 1=Limited a lot; 2=Limited a little; 3=Not at all limited; DK,R

9. **SFR_Q11**: (Does ^YOUR1 health limit ^HIMHER:) … in walking one block? - 1=Limited a lot; 2=Limited a little; 3=Not at all limited; DK,R

10. **SFR_Q12**: (Does ^YOUR1 health limit ^HIMHER:) … in bathing and dressing ^YOURSELF? - 1=Limited a lot; 2=Limited a little; 3=Not at all limited; DK,R

11. **SFR_Q13**: Now a few questions about problems with ^YOUR2 work or with other regular daily activities. Because of ^YOUR1 physical health, during the past - 4=weeks, did ^YOU2:; 1=Yes; 2=No; DK,R

12. **SFR_Q14**: Because of ^YOUR1 physical health, during the past 4 weeks, did ^YOU2: … accomplish less than ^YOU1 would like? - 1=Yes; 2=No; DK,R

13. **SFR_Q15**: (Because of ^YOUR1 physical health, during the past 4 weeks,) ^WERE ^YOU2: … limited in the kind of work or other activities? - 1=Yes; 2=No; DK,R

14. **SFR_Q16**: (Because of ^YOUR1 physical health, during the past 4 weeks,) did ^YOU2: … have difficulty performing the work or other activities (for example, it took extra effort)? - 1=Yes; 2=No; DK,R

15. **SFR_Q17**: Next a few questions about problems with ^YOUR2 work or with other regular daily activities due to emotional problems (such as feeling depressed or anxious). Because of emotional problems, during the past 4 weeks, did... - 1=Yes; 2=No; DK,R; R [Go to SFR_END]

16. **SFR_Q18**: Because of emotional problems, during the past 4 weeks, did ^YOU2: … accomplish less than ^YOU1 would like? - 1=Yes; 2=No; DK,R

17. **SFR_Q19**: (Because of emotional problems, during the past 4 weeks,) did ^YOU2: … not do work or other activities as carefully as usual? - 1=Yes; 2=No; DK,R

18. **SFR_Q20**: During the past 4 weeks, how much has ^YOUR1 physical health or emotional problems interfered with ^YOUR1 normal social activities with family, friends, neighbours, or groups?  - 1=Not at all; 2=A little bit; 3=Moderately; 4=Quite a bit; 5=Extremely; DK,R

19. **SFR_Q21**: During the past 4 weeks, how much bodily pain ^HAVE ^YOU1 had?  - 1=None; 2=Very mild; 3=Mild; 4=Moderate; 5=Severe; 6=Very severe; DK,R

20. **SFR_Q22**: During the past 4 weeks, how much did pain interfere with ^YOUR1 normal work (including work both outside the home and housework)?  - 1=Not at all; 2=A little bit; 3=Moderately; 4=Quite a bit; 5=Extremely; DK,R

- *SFR_R23*: The next questions are about how ^YOU2 felt and how things have been with ^HIMHER during the past 4 weeks. For each question, please indicate the answer that comes closest to the way ^YOU2 ^HAVE been feeling. INTERVIE...

21. **SFR_Q23**: During the past 4 weeks, how much of the time: … did ^YOU2 feel full of pep?  - 1=All of the time; 2=Most of the time; 3=A good bit of the time; 4=Some of the time; 5=A little of the time; 6=None of the time; DK,R

22. **SFR_Q24**: (During the past 4 weeks, how much of the time:) … ^HAVE ^YOU2 been a very nervous person?  - 1=All of the time; 2=Most of the time; 3=A good bit of the time; 4=Some of the time; 5=A little of the time; 6=None of the time; DK,R

23. **SFR_Q25**: (During the past 4 weeks, how much of the time:) … ^HAVE ^YOU1 felt so down in the dumps that nothing could cheer ^HIMHER up? - 1=All of the time; 2=Most of the time; 3=A good bit of the time; 4=Some of the time; 5=A little of the time; 6=None of the time; DK,R

24. **SFR_Q26**: (During the past 4 weeks, how much of the time:) … ^HAVE ^YOU1 felt calm and peaceful? - 1=All of the time; 2=Most of the time; 3=A good bit of the time; 4=Some of the time; 5=A little of the time; 6=None of the time; DK,R

25. **SFR_Q27**: (During the past 4 weeks, how much of the time:) … did ^YOU1 have a lot of energy? - 1=All of the time; 2=Most of the time; 3=A good bit of the time; 4=Some of the time; 5=A little of the time; 6=None of the time; DK,R

26. **SFR_Q28**: During the past 4 weeks, how much of the time: … ^HAVE ^YOU1 felt downhearted and blue? - 1=All of the time; 2=Most of the time; 3=A good bit of the time; 4=Some of the time; 5=A little of the time; 6=None of the time; DK,R

27. **SFR_Q29**: (During the past 4 weeks, how much of the time:) … did ^YOU1 feel worn out? - 1=All of the time; 2=Most of the time; 3=A good bit of the time; 4=Some of the time; 5=A little of the time; 6=None of the time; DK,R

28. **SFR_Q30**: (During the past 4 weeks, how much of the time:) … ^HAVE ^YOU1 been a happy person? - 1=All of the time; 2=Most of the time; 3=A good bit of the time; 4=Some of the time; 5=A little of the time; 6=None of the time; DK,R

29. **SFR_Q31**: (During the past 4 weeks, how much of the time:) … did ^YOU1 feel tired? - 1=All of the time; 2=Most of the time; 3=A good bit of the time; 4=Some of the time; 5=A little of the time; 6=None of the time; DK,R

30. **SFR_Q32**: During the past 4 weeks, how much of the time has ^YOUR1 health limited ^YOUR1 social activities (such as visiting with friends or close relatives)? - 1=All of the time; 2=Most of the time; 3=A good bit of the time; 4=Some of the time; 5=A little of the time; 6=None of the time; DK,R

31. **SFR_Q33**: Now please tell me the answer that best describes how true or false each of the following statements is for ^YOU2. [I/FNAME] [seem/seems] to get sick a little easier than other people.  - 1=Definitely true; 2=Mostly true; 3=Not sure; 4=Mostly false; 5=Definitely false; DK,R

32. **SFR_Q34**: (Please tell me the answer that best describes how true or false each of the following statements is for ^YOU2.) [I/FNAME] [am/is] as healthy as anybody [I/he/she] [know/knows].  - 1=Definitely true; 2=Mostly true; 3=Not sure; 4=Mostly false; 5=Definitely false; DK,R

33. **SFR_Q35**: (Please tell me the answer that best describes how true or false each of the following statements is for ^YOU2.) [I/FNAME] [expect/expects] [my/his/her] health to get worse. - 1=Definitely true; 2=Mostly true; 3=Not sure; 4=Mostly false; 5=Definitely false; DK,R

34. **SFR_Q36**: (Please tell me the answer that best describes how true or false each of the following statements is for ^YOU2.) [My/FNAME’s] health is excellent. SFR_END - 1=Definitely true; 2=Mostly true; 3=Not sure; 4=Mostly false; 5=Definitely false; DK,R

---

### SEXUAL BEHAVIOURS (SXB) - 13 questions

*[Optional content]*

- **SXB_C01A**: If (do SXB block = 1), go to SXB_C01B. Otherwise, go to SXB_END.

- **SXB_C01B**: If proxy interview or age < 15 or > 49, go to SXB_END. Otherwise, go to SXB_R01.

- *SXB_R01*: I would like to ask you a few questions about sexual behaviour. We ask these questions because sexual behaviours can have very important and long-lasting effects on personal health. You can be assured that anything yo...

1. **SXB_Q01**: Have you ever had sexual intercourse? - 1=Yes; 2=No [Go to SXB_END]; DK,R [Go to SXB_END]

2. **SXB_Q02**: How old were you the first time? INTERVIEWER: Maximum is [current age]. |_|_| Age in years - DK,R [Go to SXB_END]

3. **SXB_Q03**: In the past 12 months, have you had sexual intercourse? - 1=Yes; 2=No [Go to SXB_Q07]; DK,R [Go to SXB_END]

4. **SXB_Q04**: With how many different partners? - 1=1 partner; 2=2 partners; 3=3 partners; 4=4 or more partners; DK; R [Go to SXB_END]

5. **SXB_Q07**: Have you ever been diagnosed with a sexually transmitted disease? - 1=Yes; 2=No; DK,R

- **SXB_C08A**: If SXB_Q03 = 1 (had intercourse in last 12 months), go to SXB_C08C. Otherwise, go to SXB_END.

- **SXB_C08C**: If marital status = 1 (married) or 2 (common-law) and SXB_Q04 = 1 (one partner), go to

- **SXB_C09B**: Otherwise, go to SXB_Q08.

6. **SXB_Q08**: Did you use a condom the last time you had sexual intercourse? - 1=Yes; 2=No; DK,R

- **SXB_C09B**: If age > 24, go to SXB_END. Otherwise, go to SXB_R9A.

- *SXB_R9A*: Now a few questions about birth control. INTERVIEWER: Press <Enter> to continue.

- **SXB_C09C**: If sex = female, go to SXB_C09D. Otherwise, go to SXB_R10.

- **SXB_C09D**: If MAM_Q037 = 1 (currently pregnant), go to SXB_Q11. Otherwise, go to SXB_R9B.

- *SXB_R9B*: I’m going to read you a statement about pregnancy. Please tell me if you strongly agree, agree, neither agree nor disagree, disagree, or strongly disagree. INTERVIEWER: Press <Enter> to continue.

7. **SXB_Q09**: It is important to me to avoid getting pregnant right now. - 1=Strongly agree [Go to SXB_Q11]; 2=Agree [Go to SXB_Q11]; 3=Neither agree nor disagree [Go to SXB_Q11]; 4=Disagree [Go to SXB_Q11]; 5=Strongly disagree [Go to SXB_Q11]; DK [Go to SXB_Q11]; R [Go to SXB_END]

- *SXB_R10*: I’m going to read you a statement about pregnancy. Please tell me if you strongly agree, agree, neither agree nor disagree, disagree, or strongly disagree. INTERVIEWER: Press <Enter> to continue.

8. **SXB_Q10**: It is important to me to avoid getting my partner pregnant right now. - 1=Strongly agree; 2=Agree; 3=Neither agree nor disagree; 4=Disagree; 5=Strongly disagree; 6=Doesn’t have a partner right now; DK; R [Go to SXB_END]

9. **SXB_Q11**: In the past 12 months, did you and your partner usually use birth control? - 1=Yes [Go to SXB_Q12]; 2=No [Go to SXB_END]; DK,R [Go to SXB_END]

10. **SXB_Q12**: What kind of birth control did you and your partner usually use?  - 1=Condom (male or female condom); 2=Birth control pill; 3=Diaphragm; 4=Spermicide (e.g., foam, jelly, film); 5=Birth control injection (Deprovera); 6=Other - Specify; DK,R [Go to SXB_END]

- **SXB_C12S**: If SXB_Q12 = 6, go to SXB_Q12S. Otherwise, go to SXB_C13.

11. **SXB_Q12S**: INTERVIEWER: Specify. ________________________ (80 spaces) - DK,R

- **SXB_C13**: If MAM_Q037 = 1 (currently pregnant), go to SXB_END. Otherwise, go to SXB_Q13.

12. **SXB_Q13**: What kind of birth control did you and your partner use the last time you had sex?  - 1=Condom (male or female condom); 2=Birth control pill; 3=Diaphragm; 4=Spermicide (e.g., foam, jelly, film); 5=Birth control injection (Deprovera); 6=Nothing; 7=Other - Specify; DK,R [Go to SXB_END]

- **SXB_C13S**: If SXB_Q13 = 7, go to SXB_Q13S. Otherwise, go to SXB_END.

13. **SXB_Q13S**: INTERVIEWER: Specify. ________________________ (80 spaces) SXB_END - DK,R

---

### ACCESS TO HEALTH CARE SERVICES (ACC) - 45 questions

*[Optional content]*

- **ACC_C1**: If (do ACC block = 1), go to ACC_C2.

- **ACC_C2**: If proxy interview or if age < 15, go to ACC_END. Otherwise, go to ACC_QINT10.

- *ACC_QINT10*: The next questions are about the use of various health care services. I will start by asking about your experiences getting health care from a medical specialist such as a cardiologist, allergist, gynaecologist or psy...

1. **ACC_Q10**: In the past 12 months, did you require a visit to a medical specialist for a diagnosis or a consultation? - 1=Yes; 2=No [Go to ACC_QINT20]; DK,R [Go to ACC_QINT20]

2. **ACC_Q11**: In the past 12 months, did you ever experience any difficulties getting the specialist care you needed for a diagnosis or consultation? - 1=Yes; 2=No [Go to ACC_QINT20]; DK,R [Go to ACC_QINT20]

3. **ACC_Q12**: What type of difficulties did you experience?  - 1=Difficulty getting a referral; 2=Difficulty getting an appointment; 3=No specialists in the area; 4=Waited too long - between booking appointment and visit; 5=Waited too long - to see the doctor (i.e. in-office waiting); 6=Transportation - problems; 7=Language - problem; 8=Cost; 9=Personal or family responsibilities; 10=General deterioration of health; 11=Appointment cancelled or deferred by ...

- **ACC_C12S**: If ACC_Q12 = 14 , go to ACC_Q12S. Otherwise, go to ACC_QINT20.

4. **ACC_Q12S**: INTERVIEWER: Specify. ___________________________ (80 spaces) - DK,R

- *ACC_QINT20*: The following questions are about any surgery not provided in an emergency that you may have required, such as cardiac surgery, joint surgery, caesarean sections and cataract surgery, excluding laser eye surgery. INTE...

5. **ACC_Q20**: In the past 12 months, did you require any non-emergency surgery? - 1=Yes; 2=No [Go to ACC_QINT30]; DK,R [Go to ACC_QINT30]

6. **ACC_Q21**: In the past 12 months, did you ever experience any difficulties getting the surgery you needed? - 1=Yes; 2=No [Go to ACC_QINT30]; DK,R [Go to ACC_QINT30]

7. **ACC_Q22**: What type of difficulties did you experience?  - 1=Difficulty getting an appointment with a surgeon; 2=Difficulty getting a diagnosis; 3=Waited too long - for a diagnostic test; 4=Waited too long - for a hospital bed to become available; 5=Waited too long - for surgery; 6=Service not available - in the area; 7=Transportation - problems; 8=Language - problem; 9=Cost; 10=Personal or family responsibilities; 11=General deterioration of health; 1...

- **ACC_C22S**: If ACC_Q22 = 15, go to ACC_Q22S. Otherwise, go to ACC_QINT30.

8. **ACC_Q22S**: INTERVIEWER: Specify. ___________________________ (80 spaces) - DK,R

- *ACC_QINT30*: Now some questions about MRIs, CAT Scans and angiographies provided in a non-emergency situation. INTERVIEWER: Press <Enter> to continue.

9. **ACC_Q30**: In the past 12 months, did you require one of these tests? - 1=Yes; 2=No [Go to ACC_QINT40]; DK,R [Go to ACC_QINT40]

10. **ACC_Q31**: In the past 12 months, did you ever experience any difficulties getting the tests you needed? - 1=Yes; 2=No [Go to ACC_QINT40]; DK,R [Go to ACC_QINT40]

11. **ACC_Q32**: What type of difficulties did you experience?  - 1=Difficulty getting a referral; 2=Difficulty getting an appointment; 3=Waited too long - to get an appointment; 4=Waited too long - to get test (i.e. in-office waiting); 5=Service not available - at time required; 6=Service not available - in the area; 7=Transportation - problems; 8=Language - problem; 9=Cost; 10=General deterioration of health; 11=Did not know where to go (i.e. information pr...

- **ACC_C32S**: If ACC_Q32 = 14, go to ACC_ Q32S. Otherwise, go to ACC_QINT40.

12. **ACC_Q32S**: INTERVIEWER: Specify. ___________________________ (80 spaces) - DK,R

- *ACC_QINT40*: Now I’d like you to think about yourself and family members living in your dwelling. The next questions are about your experiences getting health information or advice when you needed them for yourself or a family mem...

13. **ACC_Q40**: In the past 12 months, have you required health information or advice for yourself or a family member? - 1=Yes; 2=No [Go to ACC_QINT50]; DK,R [Go to ACC_QINT50]

14. **ACC_Q40A**: Who did you contact when you needed health information or advice for yourself or a family member? Mark all that apply. - 1=Doctor’s office; 2=Community health centre / CLSC; 3=Walk-in clinic; 4=Telephone health line (e.g., HealthLinks, Telehealth Ontario,; 5=Hospital emergency room; 6=Other hospital service; 7=Other - Specify

- **ACC_C40AS**: If ACC_Q40A = 7, go to ACC_Q40AS. Otherwise, go to ACC_Q41.

15. **ACC_Q40AS**: INTERVIEWER: Specify. ___________________________ (80 spaces) - DK,R

16. **ACC_Q41**: In the past 12 months, did you ever experience any difficulties getting the health information or advice you needed for yourself or a family member? - 1=Yes; 2=No [Go to ACC_QINT50]; DK,R [Go to ACC_QINT50]

17. **ACC_Q42**: Did you experience difficulties during “regular” office hours (that is, 9:00 am to 5:00 pm, Monday to Friday)? INTERVIEWER: It is important to make a distinction between “No” (Did not experience problems) and “Did not... - 1=Yes; 2=No [Go to ACC_Q44]; 3=Not required at this time [Go to ACC_Q44]; DK,R [Go to ACC_Q44]

18. **ACC_Q43**: What type of difficulties did you experience?  - 1=Difficulty contacting a physician or nurse; 2=Did not have a phone number; 3=Could not get through (i.e. no answer); 4=Waited too long to speak to someone; 5=Did not get adequate info or advice; 6=Language - problem; 7=Did not know where to go / call / uninformed; 8=Unable to leave the house because of a health problem; 9=Other - Specify; DK,R

- **ACC_C43S**: If ACC_Q43 = 9, go to ACC_Q43S. Otherwise, go to ACC_Q44.

19. **ACC_Q43S**: INTERVIEWER: Specify. ___________________________ (80 spaces) - DK,R

20. **ACC_Q44**: Did you experience difficulties getting health information or advice during evenings and weekends (that is, 5:00 to 9:00 pm Monday to Friday, or 9:00 am to 5:00 pm, Saturdays and Sundays)? INTERVIEWER: It is important... - 1=Yes; 2=No [Go to ACC_Q46]; 3=Not required at this time [Go to ACC_Q46]; DK,R [Go to ACC_Q46]

21. **ACC_Q45**: What type of difficulties did you experience?  - 1=Difficulty contacting a physician or nurse; 2=Did not have a phone number; 3=Could not get through (i.e. no answer); 4=Waited too long to speak to someone; 5=Did not get adequate info or advice; 6=Language - problem; 7=Did not know where to go / call / uninformed; 8=Unable to leave the house because of a health problem; 9=Other - Specify; DK,R

- **ACC_C45S**: If ACC_Q45 = 9, go to ACC_Q45S. Otherwise, go to ACC_Q46.

22. **ACC_Q45S**: INTERVIEWER: Specify. ___________________________ (80 spaces) - DK,R

23. **ACC_Q46**: Did you experience difficulties getting health information or advice during the middle of the night? INTERVIEWER: It is important to make a distinction between “No” (Did not experience problems) and “Did not require a... - 1=Yes; 2=No [Go to ACC_QINT50]; 3=Not required at this time [Go to ACC_QINT50]; DK,R [Go to ACC_QINT50]

24. **ACC_Q47**: What type of difficulties did you experience?  - 1=Difficulty contacting a physician or nurse; 2=Did not have a phone number; 3=Could not get through (i.e. no answer); 4=Waited too long to speak to someone; 5=Did not get adequate info or advice; 6=Language - problem; 7=Did not know where to go / call / uninformed; 8=Unable to leave the house because of a health problem; 9=Other - Specify; DK,R

- **ACC_C47S**: If ACC_Q47 = 9, go to ACC_Q47S. Otherwise, go to ACC_QINT50.

25. **ACC_Q47S**: INTERVIEWER: Specify. ___________________________ (80 spaces) - DK,R

- *ACC_QINT50*: Now some questions about your experiences when you needed health care services for routine or on-going care such as a medical exam or follow-up for yourself or a family member living in your dwelling. INTERVIEWER: Pre...

26. **ACC_Q50A**: Do you have a regular family doctor? - 1=Yes; 2=No; DK,R

27. **ACC_Q50**: In the past 12 months, did you require any routine or on-going care for yourself or a family member? - 1=Yes; 2=No [Go to ACC_QINT60]; DK,R [Go to ACC_QINT60]

28. **ACC_Q51**: In the past 12 months, did you ever experience any difficulties getting the routine or on-going care you or a family member needed? - 1=Yes; 2=No [Go to ACC_QINT60]; DK,R [Go to ACC_QINT60]

29. **ACC_Q52**: Did you experience difficulties getting such care during “regular” office hours (that is, 9:00 am to 5:00 pm, Monday to Friday)? INTERVIEWER: It is important to make a distinction between “No” (Did not experience prob... - 1=Yes; 2=No [Go to ACC_Q54]; 3=Not required at this time [Go to ACC_Q54]; DK,R [Go to ACC_Q54]

30. **ACC_Q53**: What type of difficulties did you experience?  - 1=Difficulty contacting a physician; 2=Difficulty getting an appointment; 3=Do not have personal / family physician; 4=Waited too long - to get an appointment; 5=Waited too long - to see the doctor (i.e. in-office waiting); 6=Service not available - at time required; 7=Service not available - in the area; 8=Transportation - problems; 9=Language - problem; 10=Cost; 11=Did not know where to go (i...

- **ACC_C53S**: If ACC_Q53 = 13, go to ACC_Q53S. Otherwise, go to ACC_Q54.

31. **ACC_Q53S**: INTERVIEWER: Specify. ___________________________ (80 spaces) - DK,R

32. **ACC_Q54**: Did you experience difficulties getting such care during evenings and weekends (that is, 5:00 to 9:00 pm, Monday to Friday or 9:00 am to 5:00 pm, Saturdays and Sundays)? INTERVIEWER: It is important to make a distinct... - 1=Yes; 2=No [Go to ACC_QINT60]; 3=Not required at this time [Go to ACC_QINT60]; DK,R [Go to ACC_QINT60]

33. **ACC_Q55**: What type of difficulties did you experience?  - 1=Difficulty contacting a physician; 2=Difficulty getting an appointment; 3=Do not have personal / family physician; 4=Waited too long - to get an appointment; 5=Waited too long - to see the doctor (i.e. in-office waiting); 6=Service not available - at time required; 7=Service not available - in the area; 8=Transportation - problems; 9=Language - problem; 10=Cost; 11=Did not know where to go (i...

- **ACC_C55S**: If ACC_Q55 = 13, go to ACC_Q55S. Otherwise, go to ACC_QINT60.

34. **ACC_Q55S**: INTERVIEWER: Specify. ___________________________ (80 spaces) - DK,R

- *ACC_QINT60*: The next questions are about situations when you or a family member have needed immediate care for a minor health problem such as fever, headache, a sprained ankle, vomiting or an unexplained rash. INTERVIEWER: Press ...

35. **ACC_Q60**: In the past 12 months, have you or a family member required immediate health care services for a minor health problem? - 1=Yes; 2=No [Go to ACC_END]; DK,R [Go to ACC_END]

36. **ACC_Q61**: In the past 12 months, did you ever experience any difficulties getting the immediate care needed for a minor health problem for yourself or a family member? - 1=Yes; 2=No [Go to ACC_END]; DK,R [Go to ACC_END]

37. **ACC_Q62**: Did you experience difficulties getting such care during “regular” office hours (that is, 9:00 am to 5:00 pm, Monday to Friday)? INTERVIEWER: It is important to make a distinction between “No” (Did not experience prob... - 1=Yes; 2=No [Go to ACC_Q64]; 3=Not required at this time [Go to ACC_Q64]; DK,R [Go to ACC_Q64]

38. **ACC_Q63**: What type of difficulties did you experience?  - 1=Difficulty contacting a physician; 2=Difficulty getting an appointment; 3=Do not have personal / family physician; 4=Waited too long - to get an appointment; 5=Waited too long - to see the doctor (i.e. in-office waiting); 6=Service not available - at time required; 7=Service not available - in the area; 8=Transportation - problems; 9=Language - problem; 10=Cost; 11=Did not know where to go (i...

- **ACC_C63S**: If ACC_Q63 = 13, go to ACC_Q63S. Otherwise, go to ACC_Q64.

39. **ACC_Q63S**: INTERVIEWER: Specify. ___________________________ (80 spaces) - DK,R

40. **ACC_Q64**: Did you experience difficulties getting such care during evenings and weekends (that is, 5:00 to 9:00 pm, Monday to Friday or 9:00 am to 5:00 pm, Saturdays and Sundays)? INTERVIEWER: It is important to make a distinct... - 1=Yes; 2=No [Go to ACC_Q66]; 3=Not required at this time [Go to ACC_Q66]; DK,R [Go to ACC_Q66]

41. **ACC_Q65**: What type of difficulties did you experience?  - 1=Difficulty contacting a physician; 2=Difficulty getting an appointment; 3=Do not have personal / family physician; 4=Waited too long - to get an appointment; 5=Waited too long - to see the doctor (i.e. in-office waiting); 6=Service not available - at time required; 7=Service not available - in the area; 8=Transportation - problems; 9=Language - problem; 10=Cost; 11=Did not know where to go (i...

- **ACC_C65S**: If ACC_Q65 = 13, go to ACC_Q65S. Otherwise, go to ACC_Q66.

42. **ACC_Q65S**: INTERVIEWER: Specify. ___________________________ (80 spaces) - DK,R

43. **ACC_Q66**: Did you experience difficulties getting such care during the middle of the night? INTERVIEWER: It is important to make a distinction between “No” (Did not experience problems) and “Did not require at this time”. - 1=Yes; 2=No [Go to ACC_END]; 3=Not required at this time [Go to ACC_END]; DK,R [Go to ACC_END]

44. **ACC_Q67**: What type of difficulties did you experience?  - 1=Difficulty contacting a physician; 2=Difficulty getting an appointment; 3=Do not have personal / family physician; 4=Waited too long - to get an appointment; 5=Waited too long - to see the doctor (i.e. in-office waiting); 6=Service not available - at time required; 7=Service not available - in the area; 8=Transportation - problems; 9=Language - problem; 10=Cost; 11=Did not know where to go (i...

- **ACC_C67S**: If ACC_Q67 = 13, go to ACC_Q67S. Otherwise, go to ACC_END.

45. **ACC_Q67S**: INTERVIEWER: Specify. ___________________________ (80 spaces) ACC_END - DK,R

---

### WAITING TIMES (WTM) - 78 questions

*[Optional content]*

- **WTM_C01**: If (do WTM block = 1), go to WTM_C02. Note: This module was collected as optional content and as part of a subsample.

- **WTM_C02**: If proxy interview or if age < 15, go to WTM_END. Otherwise, go to WTM_C03.

- **WTM_C03**: If ACC_Q10 = 2 (did not require a visit to a specialist) and

1. **ACC_Q20**: = 2 (did not require non emergency surgery) and

2. **ACC_Q30**: = 2 (did not require tests), go to WTM_END. Otherwise, go to WTM_QINT.

- *WTM_QINT*: Now some additional questions about your experiences waiting for health care services. INTERVIEWER: Press <Enter> to continue.

- **WTM_C04**: If ACC_Q10 = 2 (did not require a visit to a specialist), go to WTM_C16. Otherwise, go to WTM_Q01.

3. **WTM_Q01**: You mentioned that you required a visit to a medical specialist such as a cardiologist, allergist, gynaecologist or psychiatrist. In the past 12 months, did you require a visit to a medical specialist for a diagnosis ... - 1=Yes; 2=No [Go to WTM_C16]; DK,R [Go to WTM_C16]

4. **WTM_Q02**: For what type of condition? If you have had more than one such visit, please answer for the most recent visit.  - 1=Heart condition or stroke; 2=Cancer; 3=Asthma or other breathing conditions; 4=Arthritis or rheumatism; 5=Cataract or other eye conditions; 6=Mental health disorder; 7=Skin conditions; 8=[Gynaecological problems/blank]; 9=Other – Specify; DK,R

- **WTM_C02S**: If WTM_Q02 = 9, go to WTM_Q02S. Otherwise, go to WTM_Q03.

5. **WTM_Q02S**: INTERVIEWER: Specify. ________________________ (80 spaces) - DK,R

6. **WTM_Q03**: Were you referred by:  - 1=… a family doctor?; 2=… another specialist?; 3=… another health care provider?; 4=Did not require a referral; DK,R

7. **WTM_Q04**: Have you already visited the medical specialist? - 1=Yes; 2=No [Go to WTM_Q08A]; DK,R [Go to WTM_Q08A]

8. **WTM_Q05**: Thinking about this visit, did you experience any difficulties seeing the specialist? - 1=Yes; 2=No [Go to WTM_Q07A]; DK,R [Go to WTM_Q07A]

9. **WTM_Q06**: What type of difficulties did you experience? Question ACC_Q12 previously asked about any difficulties getting specialist care. This question (WTM_Q06) deals with difficulties experienced for the most recent visit for... - 1=Difficulty getting a referral; 2=Difficulty getting an appointment; 3=No specialists in the area; 4=Waited too long - between booking appointment and visit; 5=Waited too long - to see the doctor (i.e. in-office waiting); 6=Transportation – problems; 7=Language – problem; 8=Cost; 9=Personal or family responsibilities; 10=General deterioration of health; 11=Appointment cancelled or deferred by ...

- **WTM_C06S**: If WTM_Q06 = 13, go to WTM_Q06S. Otherwise, go to WTM_Q07A.

10. **WTM_Q06S**: INTERVIEWER: Specify. ________________________ (80 spaces) - DK,R

11. **WTM_Q07A**: How long did you have to wait between when [you and your doctor decided that you should see a specialist/you and your health care provider decided that you should see a specialist/the appointment was initially schedul... - DK,R [Go to WTM_Q10]

12. **WTM_N07B**: INTERVIEWER: Enter unit of time. - 1=Days; 2=Weeks; 3=Months; (DK,R not allowed)

13. **WTM_N07B**: = 2) or (WTM_Q07A > 18 and WTM_N07B=3). - [Then go to WTM_Q10]

14. **WTM_Q08A**: How long have you been waiting since [you and your doctor decided that you should see a specialist/you and your health care provider decided that you should see a specialist/the appointment was initially scheduled]? I... - DK,R [Go to WTM_Q10]

15. **WTM_N08B**: INTERVIEWER: Enter unit of time. - 1=Days; 2=Weeks; 3=Months; (DK,R not allowed)

16. **WTM_N08B**: = 2), or (WTM_Q08A > 18 and WTM_N08B = 3).

17. **WTM_Q10**: In your view, [was the waiting time / has the waiting time been]: It is important to make a distinction between “No view” and “Don’t Know”. - 1=… acceptable? [Go to WTM_Q12]; 2=… not acceptable?; 3=No view; DK,R

18. **WTM_Q11A**: In this particular case, what do you think is an acceptable waiting time? |_|_|_| (3 spaces) - DK,R [Go to WTM_Q12]

19. **WTM_N11B**: INTERVIEWER: Enter unit of time. - 1=Days; 2=Weeks; 3=Months; (DK,R not allowed)

20. **WTM_N11B**: = 2) or (WTM_Q11A > 18 and WTM_N11B=3).

21. **WTM_Q12**: Was your visit cancelled or postponed at any time? - 1=Yes; 2=No [Go to WTM_Q14]; DK,R [Go to WTM_Q14]

22. **WTM_Q13**: Was it cancelled or postponed by: Mark all that apply. - 1=… yourself?; 2=… the specialist?; 3=Other - Specify; DK,R

- **WTM_C13S**: If WTM_Q13 = 3, go to WTM_Q13S. Otherwise, go to WTM_Q14.

23. **WTM_Q13S**: INTERVIEWER: Specify. ________________________ (80 spaces) - DK,R

24. **WTM_Q14**: Do you think that your health, or other aspects of your life, have been affected in any way because you had to wait for this visit? - 1=Yes; 2=No [Go to WTM_C16]; DK,R [Go to WTM_C16]

25. **WTM_Q15**: How was your life affected as a result of waiting for this visit?  - 1=Worry, anxiety, stress; 2=Worry or stress for family or friends; 3=Pain; 4=Problems with activities of daily living (e.g., dressing, driving); 5=Loss of work; 6=Loss of income; 7=Increased dependence on relatives/friends; 8=Increased use of over-the-counter drugs; 9=Overall health deteriorated, condition got worse; 10=Health problem improved; 11=Personal relationships suffered; 12=Other - Spe...

- **WTM_C15S**: If WTM_Q15 = 12, go to WTM_Q15S. Otherwise, go to WTM_C16.

26. **WTM_Q15S**: INTERVIEWER: Specify. ________________________ (80 spaces) - DK,R

- **WTM_C16**: If ACC_Q20 = 2 (did not require non-emergency surgery), go to WTM_C30. Otherwise, go to WTM_Q16.

27. **WTM_Q16**: You mentioned that in the past 12 months you required non emergency surgery. What type of surgery did you require? If you have had more than one in the past - 12=months, please answer for the most recent surgery.; 1=Cardiac surgery; 2=Cancer related surgery; 3=Hip or knee replacement surgery; 4=Cataract or other eye surgery; 5=Hysterectomy (Removal of uterus) / blank]; 6=Removal of gall bladder; 7=Other - Specify; DK,R

- **WTM_C16S**: If WTM_Q16 = 7, go to WTM_Q16S. Otherwise, go to WTM_Q17.

28. **WTM_Q16S**: INTERVIEWER: Specify. ________________________ (80 spaces) - DK,R

29. **WTM_Q17**: Did you already have this surgery? - 1=Yes; 2=No [Go to WTM_Q22]; DK,R [Go to WTM_Q22]

30. **WTM_Q18**: Did the surgery require an overnight hospital stay? - 1=Yes; 2=No; DK,R

31. **WTM_Q19**: Did you experience any difficulties getting this surgery? - 1=Yes; 2=No [Go to WTM_Q21A]; DK,R [Go to WTM_Q21A]

32. **WTM_Q20**: What type of difficulties did you experience? ACC_Q22 asked previously about any difficulties experienced getting the surgery you needed. This question (WTM_Q20) refers to difficulties experienced for the most recent ... - 1=Difficulty getting an appointment with a surgeon; 2=Difficulty getting a diagnosis; 3=Waited too long - for a diagnostic test; 4=Waited too long - for a hospital bed to become available; 5=Waited too long - for surgery; 6=Service not available - in the area; 7=Transportation - problems; 8=Language - problem; 9=Cost; 10=Personal or family responsibilities; 11=General deterioration of health; 1...

- **WTM_C20S**: If WTM_Q20 = 14. go to WTM_Q20S. Otherwise, go to WTM_Q21A.

33. **WTM_Q20S**: INTERVIEWER: Specify. ________________________ (80 spaces) - DK,R

34. **WTM_Q21A**: How long did you have to wait between when you and the surgeon decided to go ahead with surgery and the day of surgery? INTERVIEWER: Probe to get the most precise answer possible. |_|_|_| (3 spaces) - DK,R [Go to WTM_Q24]

35. **WTM_N21B**: INTERVIEWER: Enter unit of time. - 1=Days; 2=Weeks; 3=Months; (DK,R not allowed)

36. **WTM_N21B**: = 2) or (WTM_Q21A > 18 and WTM_N21B=3). - [Then go to WTM_C24]

37. **WTM_Q22**: Will the surgery require an overnight hospital stay? - 1=Yes; 2=No; DK,R

38. **WTM_Q23A**: How long have you been waiting since you and the surgeon decided to go ahead with the surgery? INTERVIEWER: Probe to get the most precise answer possible. |_|_|_| (3 spaces) - DK,R [Go to WTM_Q24]

39. **WTM_N23B**: INTERVIEWER: Enter unit of time. - 1=Days; 2=Weeks; 3=Months; (DK,R not allowed)

40. **WTM_N23B**: = 2) or (WTM_Q23A > 18 and WTM_N23B = 3).

41. **WTM_Q24**: In your view, [was the waiting time / has the waiting time been]: It is important to make a distinction between “No view” and “Don’t Know”. - 1=… acceptable? [Go to WTM_Q26]; 2=… not acceptable?; 3=No view; DK,R

42. **WTM_Q25A**: In this particular case, what do you think is an acceptable waiting time? |_|_|_| (3 spaces) - DK,R [Go to WTM_Q26]

43. **WTM_N25B**: INTERVIEWER: Enter unit of time. - 1=Days; 2=Weeks; 3=Months; (DK,R not allowed)

44. **WTM_N25B**: = 2) or (WTM_Q25A > 18 and WTM_N25B=3).

45. **WTM_Q26**: Was your surgery cancelled or postponed at any time? - 1=Yes; 2=No [Go to WTM_Q28]; DK,R [Go to WTM_Q28]

46. **WTM_Q27**: Was it cancelled or postponed by: Mark all that apply. - 1=… yourself?; 2=… the surgeon?; 3=… the hospital?; 4=Other - Specify; DK,R

- **WTM_C27S**: If WTM_Q27 = 4, go to WTM_Q27S. Otherwise, go to WTM_Q28.

47. **WTM_Q27S**: INTERVIEWER: Specify. ________________________ (80 spaces) - DK,R

48. **WTM_Q28**: Do you think that your health, or other aspects of your life, have been affected in any way due to waiting for this surgery? - 1=Yes; 2=No [Go to WTM_C30]; DK,R [Go to WTM_C30]

49. **WTM_Q29**: How was your life affected as a result of waiting for surgery?  - 1=Worry, anxiety, stress; 2=Worry or stress for family or friends; 3=Pain; 4=Problems with activities of daily living (e.g., dressing, driving); 5=Loss of work; 6=Loss of income; 7=Increased dependence on relatives/friends; 8=Increased use of over-the-counter drugs; 9=Overall health deteriorated, condition got worse; 10=Health problem improved; 11=Personal relationships suffered; 12=Other - Spe...

- **WTM_C29S**: If WTM_Q29 = 12 go to WTM_Q29S. Otherwise, go to WTM_C30.

50. **WTM_Q29S**: INTERVIEWER: Specify. ________________________ (80 spaces) - DK,R

- **WTM_C30**: If ACC_Q30 = 2 (did not require tests), go to WTM_END. Otherwise, go to WTM_Q30.

51. **WTM_Q30**: Now for MRIs, CAT Scans and angiographies provided in a non emergency situation. You mentioned that in the past 12 months you required one of these tests. What type of test did you require? If you have had more than o... - 1=MRI; 2=CAT Scan; 3=Angiography; DK,R

52. **WTM_Q31**: For what type of condition?  - 1=Heart disease or stroke; 2=Cancer; 3=Joints or fractures; 4=Neurological or brain disorders (e.g., for MS, migraine or headaches); 5=Other - Specify; DK,R

- **WTM_C31S**: If WTM_Q31 = 5, go to WTM_Q31S. Otherwise, go to WTM_Q32.

53. **WTM_Q31S**: INTERVIEWER: Specify. ________________________ (80 spaces) - DK,R

54. **WTM_Q32**: Did you already have this test? - 1=Yes; 2=No [Go to WTM_Q39A]; DK,R [Go to WTM_Q39A]

55. **WTM_Q33**: Where was the test done?  - 1=Hospital [Go to WTM_Q35]; 2=Public clinic [Go to WTM_Q35]; 3=Private clinic [Go to WTM_Q34]; 4=Other - Specify [Go to WTM_C33S]; DK,R [Go to WTM_Q36]

- **WTM_C33S**: If WTM_Q33 = 4, go to WTM_Q33S. Otherwise, go to WTM_Q34.

56. **WTM_Q33S**: INTERVIEWER: Specify. ________________________ (80 spaces) - DK,R; [Then go to WTM_Q35]

57. **WTM_Q34**: Was the clinic located:  - 1=… in your province?; 2=… in another province?; 3=Other – Specify; DK,R

- **WTM_C34S**: If WTM_Q34 = 3, go to WTM_Q34S. Otherwise, go to WTM_Q35.

58. **WTM_Q34S**: INTERVIEWER: Specify. ________________________ (80 spaces) - DK,R

59. **WTM_Q35**: Were you a patient in a hospital at the time of the test? - 1=Yes; 2=No; DK,R

60. **WTM_Q36**: Did you experience any difficulties getting this test? - 1=Yes; 2=No [Go to WTM_Q38A]; DK,R [Go to WTM_Q38A]

61. **WTM_Q37**: What type of difficulties did you experience? ACC_Q32 asked previously about any difficulties experienced getting the tests you needed. This question (WTM_Q37) refers to difficulties experienced for the most recent di... - 1=Difficulty getting a referral; 2=Difficulty getting an appointment; 3=Waited too long - to get an appointment; 4=Waited too long - to get test (i.e. in-office waiting); 5=Service not available - at time required; 6=Service not available - in the area; 7=Transportation - problems; 8=Language - problem; 9=Cost; 10=General deterioration of health; 11=Did not know where to go (i.e. information pr...

- **WTM_C37S**: If WTM_Q37 = 13, go to WTM_Q37S. Otherwise, go to WTM_Q38A.

62. **WTM_Q37S**: INTERVIEWER: Specify. ________________________ (80 spaces) - DK,R

63. **WTM_Q38A**: How long did you have to wait between when you and your doctor decided to go ahead with the test and the day of the test? INTERVIEWER: Probe to get the most precise answer possible. |_|_|_| (3 spaces) - DK,R [Go to WTM_C40]

64. **WTM_N38B**: INTERVIEWER: Enter unit of time. - 1=Days; 2=Weeks; 3=Months; (DK,R not allowed)

65. **WTM_N38B**: = 2) or (WTM_Q38A > 18 and WTM_N38B=3). - [Then go to WTM_C40]

66. **WTM_Q39A**: How long have you been waiting for the test since you and your doctor decided to go ahead with the test? INTERVIEWER: Probe to get the most precise answer possible. |_|_|_| (3 spaces) - DK,R [Go to WTM_C40]

67. **WTM_N39B**: INTERVIEWER: Enter unit of time. - 1=Days; 2=Weeks; 3=Months; (DK,R not allowed)

68. **WTM_N39**: = 2) or (WTM_Q39A > 18 and WTM_N39B= 3).

69. **WTM_Q40**: In your view, [was the waiting time / has the waiting time been]: It is important to make a distinction between “No view” and “Don’t Know”. - 1=… acceptable? [Go to WTM_Q42]; 2=… not acceptable?; 3=No view; DK,R

70. **WTM_Q41A**: In this particular case, what do you think is an acceptable waiting time? |_|_|_| (3 spaces) - DK,R [Go to WTM_Q42]

71. **WTM_N41B**: INTERVIEWER: Enter unit of time. - 1=Days; 2=Weeks; 3=Months; (DK,R not allowed)

72. **WTM_N41B**: = 2) or (WTM_Q41A > 18 and WTM_N41B=3).

73. **WTM_Q42**: Was your test cancelled or postponed at any time? - 1=Yes; 2=No [Go to WTM_Q44]; DK,R [Go to WTM_Q44]

74. **WTM_Q43**: Was it cancelled or postponed by:  - 1=… yourself?; 2=… the specialist?; 3=… the hospital?; 4=… the clinic?; 5=Other - Specify; DK,R

- **WTM_C43S**: If WTM_Q43 = 5, go to WTM_Q43S. Otherwise, go to WTM_Q44.

75. **WTM_Q43S**: INTERVIEWER: Specify. _____________________ (80 spaces) - DK,R

76. **WTM_Q44**: Do you think that your health, or other aspects of your life, have been affected in any way due to waiting for this test? - 1=Yes; 2=No [Go to WTM_END]; DK,R [Go to WTM_END]

77. **WTM_Q45**: How was your life affected as a result of waiting for this test?  - 1=Worry, anxiety, stress; 2=Worry or stress for family or friends; 3=Pain; 4=Problems with activities of daily living (e.g., dressing, driving); 5=Loss of work; 6=Loss of income; 7=Increased dependence on relatives/friends; 8=Increased use of over-the-counter drugs; 9=Overall health deteriorated, condition got worse; 10=Health problem improved; 11=Personal relationships suffered; 12=Other - Spe...

- **WTM_C45S**: If WTM_Q45 = 12, go to WTM_Q45S. Otherwise, go to WTM_END.

78. **WTM_Q45S**: INTERVIEWER: Specify. _________________________ (80 spaces) WTM_END - DK,R

---

### MEASURED HEIGHT AND WEIGHT (MHW) - 40 questions

*[Optional content]*

- **MHW_C01A**: If (do MHW block =1), go to MHW_C01B. Otherwise, go to MHW_END.

- **MHW_C01B**: If proxy interview, go to MHW_END. Otherwise, go to MHW_C01C.

- **MHW_C01C**: If area frame, go to MHW_N1A. Otherwise, go to MHW_END.

1. **MHW_N1A**: INTERVIEWER: Are there any reasons that make it impossible to measure the

2. **MHWZ_N1**: respondent’s weight? - 1=Yes; 2=No [Go to MHW_R2]; (DK,R not allowed)

3. **MHW_N1B**: INTERVIEWER: Select reasons why it is impossible to measure the respondent’s weight. Mark all that apply.

4. **MHWZ_N1A**: 1 Unable to stand unassisted (go to MHW_END)

5. **MHWZ_N1B**: 2 In a wheel chair (go to MHW_END)

6. **MHWZ_N1C**: 3 Bedridden (go to MHW_END)

7. **MHWZ_N1D**: 4 Interview setting (e.g., interview outdoors or in a public place)

8. **MHWZ_N1E**: 5 Safety concerns

9. **MHWZ_N1F**: 6 Has already refused to be measured

10. **MHWZ_N1G**: 7 Other – Specify - (DK,R not allowed)

- **MHW_C1C**: If MHW_N1B = 7, go to MHW_S1B. Otherwise, go to MHW_N5A.

- *MHW_R2*: A person’s size is important in understanding health. Because of this, I would like to measure your height and weight. The measurements taken will not require any touching. INTERVIEWER: Press <Enter> to continue.

11. **MHW_Q2A**: Do I have your permission to measure your weight? - 1=Yes; 2=No [Go to MHW_N5A]; (DK,R not allowed)

12. **MHW_N2A**: INTERVIEWER: Record weight to the nearest 0.01 kg. If the scale does not work, or if for

13. **MHWZ_N2A**: some other reason you cannot weigh the respondent, enter DK. |_|_|_|.|_|_| kilograms - DK [Go to MSW_N4]

14. **MHW_N3A**: INTERVIEWER: Were there any articles of clothing or physical characteristics which

15. **MHWZ_N3**: affected the accuracy of this measurement? - 1=Yes; 2=No [Go to MHW_N5A]; (DK,R not allowed)

16. **MHW_N3B**: INTERVIEWER: Select reasons affecting accuracy. Mark all that apply.

17. **MHWZ_N3A**: 1 Shoes or boots

18. **MHWZ_N3B**: 2 Heavy sweater or jacket

19. **MHWZ_N3C**: 3 Jewellery

20. **MHWZ_N3D**: 4 Other - Specify - (DK,R not allowed)

- **MHW_C3B**: If MHW_N3B = 4, go to MHW_S3B. Otherwise, go to MHW_N5A.

21. **MHW_N4**: INTERVIEWER: Select the reason for not weighing the respondent.

22. **MHWZ_N4**:  - 1=Scale not functioning properly; 2=Other – Specify; (DK,R not allowed)

- **MHW_C4**: If MHW_N4 = 2, go to MHW_S4. Otherwise, go to MHW_N5A.

23. **MHW_N5A**: INTERVIEWER: Are there any reasons that make it impossible to measure the

24. **MHWZ_N5**: respondent’s height? - 1=Yes; 2=No [Go to MHW_C6]; (DK,R not allowed)

25. **MHW_N5B**: INTERVIEWER: Select reasons why it is impossible to measure the respondent’s height. Mark all that apply.

26. **MHWZ_N5A**: 1 Too tall

27. **MHWZ_N5B**: 2 Interview setting (e.g., interview outdoors or in a public place)

28. **MHWZ_N5C**: 3 Safety concerns

29. **MHWZ_N5D**: 4 Has already refused to be measured

30. **MHWZ_N5E**: 5 Other – Specify - (DK,R not allowed)

- **MHW_C5B**: If MHW_N5B = 5, go to MHW_S5B. Otherwise, go to MHW_ END.

- **MHW_C6**: If MHW_N1A = 2, go to MHW_Q6A. Otherwise, go to MHW_R6.

- *MHW_R6*: A person’s size is important in understanding health. Because of this, I would like to measure your height. The measurement will not require any touching. INTERVIEWER: Press <Enter> to continue.

31. **MHW_Q6A**: Do I have your permission to measure your height? - 1=Yes; 2=No [Go to MHW_END]; (DK,R not allowed)

32. **MHW_N6B**: INTERVIEWER: Enter height to nearest 0.5 cm.

33. **MHWZ_N6**: |_|_|_|.|_| - DK,R

34. **MHW_N7A**: INTERVIEWER: Were there any articles of clothing or physical characteristics

35. **MHWZ_N7**: which affected the accuracy of this measurement? - 1=Yes; 2=No [Go to MHW_END]; (DK,R not allowed)

36. **MHW_N7B**: INTERVIEWER: Select reasons affecting accuracy. Mark all that apply.

37. **MHWZ_N7A**: 1 Shoes or boots

38. **MHWZ_N7B**: 2 Hairstyle

39. **MHWZ_N7C**: 3 Hat

40. **MHWZ_N7D**: 4 Other - Specify - (DK,R not allowed)

- **MHW_C7B**: If MHW_N7B = 4, go to MHW_S7B. Otherwise, go to MHW_END.

---

### LABOUR FORCE (LBF) - 42 questions

*[Optional content]*

- **LBF_C01**: If (do LBF block = 1), go to LBF_C02. Otherwise, go to LBF_END.

- **LBF_C02**: If age < 15 or age > 75, go to LBF_END. Otherwise, go to LBF_QINT.

- *LBF_QINT*: The next few questions concern ^YOUR2 activities in the last 7 days. By the last 7 days, I mean beginning [date one week ago], and ending [date yesterday]. INTERVIEWER: Press <Enter> to continue. Job Attachment

1. **LBF_Q01**: Last week, did ^YOU2 work at a job or a business? Please include part-time jobs, seasonal work, contract work, self-employment, baby-sitting and any other paid work, regardless of the number of hours worked. - 1=Yes [Go to LBF_Q03]; 2=No; 3=Permanently unable to work [Go to LBF_QINT2]; DK,R [Go to LBF_END]

2. **LBF_Q02**: Last week, did ^YOU2 have a job or business from which ^YOU1 ^WERE absent? - 1=Yes; 2=No [Go to LBF_Q11]; DK,R [Go to LBF_END]

3. **LBF_Q03**: Did ^YOU1 have more than one job or business last week? Job Search – Last 4 Weeks - 1=Yes; 2=No; DK,R; [Then go to LBF_C31]

4. **LBF_Q11**: In the past 4 weeks, did ^YOU2 do anything to find work? - 1=Yes [Go to LBF_QINT2]; 2=No; DK,R [Go to LBF_QINT2]

5. **LBF_Q13**: What is the main reason that ^YOU1 ^ARE not currently working at a job or business? - 1=Own illness or disability; 2=Caring for - own children; 3=Caring for - elder relatives; 4=Pregnancy (Females only); 5=Other personal or family responsibilities; 6=Vacation; 7=School or educational leave; 8=Retired; 9=Believes no work available (in area or suited to skills); 10=Other - Specify; DK,R

- **LBF_C13S**: If LBF_Q13 = 10, go to LBF_Q13S. Otherwise, go to LBF_C13.

6. **LBF_Q13S**: INTERVIEWER: Specify. ________________________ (80 spaces) - DK,R

- **LBF_C13A**: If LBF_Q13 = 1 (Own illness or disability), go to LBF_Q13A. Otherwise, go to LBF_QINT2.

7. **LBF_Q13A**: Is this due to ^YOUR1 physical health, to ^YOUR1 emotional or mental health, to ^YOUR1 use of alcohol or drugs, or to another reason? Past Job Attachment - 1=Physical health; 2=Emotional or mental health (including stress); 3=Use of alcohol or drugs; 4=Another reason; DK,R

- *LBF_QINT2*: Now some questions about jobs or employment which ^YOU2 ^HAVE had during the past 12 months, that is, from [date one year ago] to yesterday. INTERVIEWER: Press <Enter> to continue.

8. **LBF_Q21**: Did ^YOU1 work at a job or a business at any time in the past 12 months? Please include part-time jobs, seasonal work, contract work, self-employment, baby-sitting and any other paid work, regardless of the number of ... - 1=Yes [Go to LBF_Q23]; 2=No; DK,R

9. **LBF_Q21**: = 2).

- **LBF_C22**: If LBF_Q11 = 1, go to LBF_Q71. Otherwise, go to LBF_Q22.

10. **LBF_Q22**: During the past 12 months, did ^YOU1 do anything to find work? - 1=Yes [Go to LBF_Q71]; 2=No [Go to LBF_END]; DK,R [Go to LBF_END]

11. **LBF_Q23**: During that 12 months, did ^YOU1 work at more than one job or business at the same time? Occupation, Smoking Restrictions at Work - 1=Yes; 2=No; DK,R

- *LBF_QINT3*: The next questions are about ^YOUR2 [current/most recent] job or business. (If person currently holds more than one job or if the last time he/she worked it was at more than one job: [INTERVIEWER: Report on the job fo...

12. **LBF_Q31**: [Are/Were/Is/Was] ^YOU1 an employee or self-employed? - 1=Employee [Go to LBF_Q33]; 2=Self-employed; 3=Working in a family business without pay [Go to LBF_Q33]; DK,R [Go to LBF_Q33]

13. **LBF_Q31A**: [Do/Does/Did] ^YOU1 have any employees? - 1=Yes; 2=No; DK,R

14. **LBF_Q32**: What [is/was] the name of ^YOUR1 business? LBFZF32 ________________ (50 spaces) - DK,R; [Then go to LBF_Q34]

15. **LBF_Q33**: For whom [do/does/did] ^YOU1 [currently/last] work? (For example: name of business, government department or agency, or person) LBFZF33 ________________________ (50 spaces) - DK,R

16. **LBF_Q34**: What kind of business, industry or service [is/was] this? (For example: cardboard box manufacturing, road maintenance, retail shoe store, secondary school, dairy farm, municipal government) LBFZF34 ___________________... - DK,R

17. **LBF_Q35**: What kind of work [is/was] ^YOU1 doing? (For example: babysitting in own home, factory worker, forestry technician) LBFZF35 _______________________ (50 spaces) - DK,R

- **LBF_C35**: If LBF_D35 = 1 OR LBF_D35 = 2 (OtherSpec), go to LBF_S35. Otherwise, go to LBF_Q36.

18. **LBF_Q36**: What [are/were] ^YOUR1 most important activities or duties? (For example: caring for children, stamp press machine operator, forest examiner) LBFZF36 ________________________ (50 spaces) - DK,R

19. **LBF_Q36A**: [Is/Was] ^YOUR1 job permanent, or is there some way that it [is/was] not permanent? (e.g., seasonal, temporary, term, casual) - 1=Permanent [Go to LBF_Q37]; 2=Not permanent; DK,R [Go to LBF_Q37]

20. **LBF_Q36B**: In what way [is/was] ^YOUR1 job not permanent? - 1=Seasonal; 2=Temporary, term or contract; 3=Casual job; 4=Work done through a temporary help agency; 5=Other; DK,R

21. **LBF_Q37**: At ^YOUR1 place of work, what [are/were] the restrictions on smoking? Absence / Hours - 1=Restricted completely; 2=Allowed in designated areas; 3=Restricted only in certain places; 4=Not restricted at all; DK,R

- **LBF_C41**: If LBF_Q02 = 1, go to LBF_Q41. Otherwise, go to LBF_Q42.

22. **LBF_Q41**: What was the main reason ^YOU2 ^WERE absent from work last week? - 1=Own illness or disability; 2=Caring for - own children; 3=Caring for - elder relatives; 4=Maternity leave (Females only); 5=Other personal or family responsibilities; 6=Vacation; 7=Labour dispute (strike or lockout); 8=Temporary layoff due to business conditions (Employees only); 9=Seasonal layoff (Employees only); 10=Casual job, no work available (Employees only); 11=Work schedule (e.g., shi...

- **LBF_C41S**: If LBF_Q41 = 15, go to LBF_Q41S. Otherwise, go to LBF_C41A_1.

23. **LBF_Q41S**: INTERVIEWER: Specify. ________________________ (80 spaces) - DK,R

- **LBF_C41A_1**: If LBF_Q41 = 1 (Own illness or disability), go to LBF_Q41A. Otherwise, go to LBF_Q42.

24. **LBF_Q41A**: Was that due to ^YOUR1 physical health, to ^YOUR1 emotional or mental health, to ^YOUR1 use of alcohol or drugs, or to another reason? - 1=Physical health; 2=Emotional or mental health (including stress); 3=Use of alcohol or drugs; 4=Another reason; DK,R

25. **LBF_Q42**: About how many hours a week [do/does/did] ^YOU2 usually work at ^YOUR1 [job/business]? If ^YOU2 usually [work/works/worked] extra hours, paid or unpaid, please include these hours. |_|_|_| Hours - DK,R

26. **LBF_Q44**: Which of the following best describes the hours ^YOU2 usually [work/works/worked] at ^YOUR1 [job/business]?  - 1=Regular - daytime schedule or shift [Go to LBF_Q46]; 2=Regular - evening shift; 3=Regular - night shift; 4=Rotating shift (change from days to evenings to nights); 5=Split shift; 6=On call; 7=Irregular schedule; 8=Other - Specify; DK,R [Go to LBF_Q46]

- **LBF_C44S**: If LBF_Q44 = 8, go to LBF_Q44S. Otherwise, go to LBF_Q45.

27. **LBF_Q44S**: INTERVIEWER: Specify. ________________________ (80 spaces) - DK,R

28. **LBF_Q45**: What is the main reason that ^YOU [work/works/worked] this schedule? - 1=Requirement of job / no choice; 2=Going to school; 3=Caring for - own children; 4=Caring for - other relatives; 5=To earn more money; 6=Likes to work this schedule; 7=Other - Specify; DK,R

- **LBF_C45S**: If LBF_Q45 = 7, go to LBF_Q45S. Otherwise, go to LBF_Q46.

29. **LBF_Q45S**: INTERVIEWER: Specify. ________________________ (80 spaces) - DK,R

30. **LBF_Q46**: [Do/Does/Did] ^YOU1 usually work on weekends at this [job/business]? Other Job - 1=Yes; 2=No; DK,R

- **LBF_C51**: If LBF_Q03 = 1 or LBF_Q23=1, go to LBF_Q51. Otherwise, go to LBF_Q61.

31. **LBF_Q51**: You indicated that ^YOU2 [have/has/had] had more than one job. For how many weeks in a row [have/has/had] ^YOU1 [job/business] at more than one job [(in the past 12 months)]? INTERVIEWER: Obtain best estimate. |_|_| W... - DK,R

32. **LBF_Q52**: What is the main reason that ^YOU1 [job/business] at more than one job? - 1=To meet regular household expenses; 2=To pay off debts; 3=To buy something special; 4=To save for the future; 5=To gain experience; 6=To build up a business; 7=Enjoys the work of the second job; 8=Other - Specify; DK,R

- **LBF_C52S**: If LBF_Q52 = 8, go to LBF_Q52S. Otherwise, go to LBF_Q53.

33. **LBF_Q52S**: INTERVIEWER: Specify. ________________________ (80 spaces) - DK,R

34. **LBF_Q53**: About how many hours a week [do/does/did] ^YOU1 usually work at ^YOUR1 other job(s)? If ^YOU1 usually [work/works/worked] extra hours, paid or unpaid, please include these hours. INTERVIEWER: Minimum is 1; maximum is ... - DK,R

35. **LBF_Q54**: [Do/Does/Did] ^YOU1 usually work on weekends at ^YOUR1 other job(s)? Weeks Worked - 1=Yes; 2=No; DK,R

36. **LBF_Q61**: During the past 52 weeks, how many weeks did ^YOU2 do any work at a job or a business? (Include paid vacation leave, paid maternity leave, and paid sick leave.) |_|_| Weeks Looking For Work - DK,R

- **LBF_C71**: If LBF_Q61 = 52, go to LBF_END. If LBF_Q61 = 51, go to LBF_Q71A.

37. **LBF_Q71**: During the past 52 weeks, how many weeks ^WERE ^YOU1 looking for work? That leaves [52 - LBF_Q61] weeks. During those [52 - LBF_Q61] weeks, how many weeks ^WERE ^YOU1 looking for work? INTERVIEWER: Minimum is 0; maxim... - DK,R; [Then go to LBF_C72]

38. **LBF_Q71A**: That leaves 1 week. During that week, did ^YOU1 look for work? - 1=Yes   (make LBF_Q71 = 1); 2=No    (make LBF_Q71 = 0); DK,R

- **LBF_C72**: If either LBF_Q61 or LBF_Q71 are non-response, go to LBF_END. If the total number of weeks reported in LBF_Q61 and LBF_Q71 = 52, go to LBF_END. If LBF_Q61 and LBF_Q71 were answered, [WEEKS] = [52 - (LBF_Q61 + LBF_Q71)]. If LBF_Q61 was not answered, [WEEKS] = (52 - LBF_Q71).

39. **LBF_Q72**: That leaves [WEEKS] week[s] during which ^YOU1 ^WERE neither working nor looking for work. Is that correct? - 1=Yes [Go to LBF_C73]; 2=No; DK,R [Go to LBF_C73]

- **LBF_C73**: If (LBF_Q01 = 1 or LBF_Q02 = 1 or LBF_Q11 = 1), go to LBF_Q73. Otherwise, go to LBF_END.

40. **LBF_Q73**: What is the main reason that ^YOU1 ^WERE not looking for work? INTERVIEWER: If more than one reason, choose the one that explains the most number of weeks. - 1=Own illness or disability; 2=Caring for - own children; 3=Caring for - elder relatives; 4=Pregnancy (Females only); 5=Other personal or family responsibilities; 6=Vacation; 7=Labour dispute (strike or lockout); 8=Temporary layoff due to business conditions; 9=Seasonal layoff; 10=Casual job, no work available; 11=Work schedule (e.g., shift work); 12=School or educational leave; 13=Retired; 14=...

- **LBF_C73S**: If LBF_Q73 = 15, go to LBF_Q73S. Otherwise, go to LBF_C73A.

41. **LBF_Q73S**: INTERVIEWER: Specify. ________________________ (80 spaces) - DK,R

- **LBF_C73B**: If LBF_Q73 = 1 (own illness or disability), go to LBF_Q73A. Otherwise, go to LBF_END.

42. **LBF_Q73A**: Was that due to ^YOUR1 physical health, to ^YOUR1 emotional or mental health, to ^YOUR1 use of alcohol or drugs, or to another reason? LBF_END LABOUR FORCE – Common Portion (LF2) LABOUR FORCE (SectLabel) - 1=Physical health; 2=Emotional or mental health (including stress); 3=Use of alcohol or drugs; 4=Another reason; DK,R

---

### LABOUR FORCE - COMMON PORTION (LF2) - 8 questions

- **LF2_C1**: If (do LBF block = 1) or (m79 = 1), go to LF2_ END. (LBF module included in sub-sample) Otherwise, go to LF2_ C2.

- **LF2_C2**: If age < 15 or age > 75, go to LF2_END. Otherwise, go to LF2_R1.

- *LF2_R1*: The next questions concern ^YOUR2 activities in the last 7 days. By the last 7 days, I mean beginning [date one week ago], and ending [date yesterday]. INTERVIEWER: Press <Enter> to continue.

1. **LF2_Q1**: Last week, did ^YOU2 work at a job or a business? Please include part-time jobs, seasonal work, contract work, self-employment, baby-sitting and any other paid work, regardless of the number of hours worked. - 1=Yes                                (Go to LF2_ Q3); 2=No; 3=Permanently unable to work [Go to LF2_END]; DK,R [Go to LF2_END]

2. **LF2_Q2**: Last week, did ^YOU2 have a job or business from which ^YOU1 ^WERE absent? - 1=Yes; 2=No [Go to LF2_Q4]; DK,R [Go to LF2_END]

3. **LF2_Q3**: Did ^YOU1 have more than one job or business last week? - 1=Yes; 2=No; DK,R; [Then go to LF2_R5]

4. **LF2_Q4**: In the past 4 weeks, did ^YOU2 do anything to find work? - 1=Yes; 2=No; DK,R; [Then go to LF2_END]

- *LF2_R5*: The next questions are about ^YOUR1 current job or business. INTERVIEWER: If person currently holds more than one job, report on the job for which the number of hours worked per week is the greatest. Press <Enter> to ...

5. **LF2_Q5**: About how many hours a week ^DOVERB ^YOU1 usually work at ^YOUR1 job or business? If ^YOU2 usually [work/works] extra hours, paid or unpaid, please include these hours. |_|_|_| Hours - DK,R

6. **LF2_Q6**: At ^YOUR1 place of work, what are the restrictions on smoking?  - 1=Restricted completely; 2=Allowed in designated areas; 3=Restricted only in certain places; 4=Not restricted at all; DK,R

7. **LBF_Q37**: is for the current job or the most recent job, (i.e. those who do not currently have a job but who had a job in the past 12 months are not included here but they are in the universe of LBF_Q37). (ETS) in the data dict...

- **LF2_C7**: If LF2_Q3=1, go to LF2_Q7. Otherwise, go to LF2_END.

8. **LF2_Q7**: You indicated that ^YOU2 ^HAVE more than one job. About how many hours a week ^DOVERB ^YOU1 usually work at ^YOUR1 other job(s)? If ^YOU2 usually [work/works] extra hours, paid or unpaid, please include these hours. I... - DK,R

---

### SOCIO-DEMOGRAPHIC CHARACTERISTICS (SDC) - 23 questions

- **SDC_C1**: If (do SDC block = 1), go to SDC_R1. Otherwise, go to SDC_END.

- *SDC_R1*: Now some general background questions which will help us compare the health of people in Canada. INTERVIEWER: Press <Enter> to continue.

1. **SDC_Q1**: In what country ^WERE ^YOU1 born? - 1=Canada         11     Jamaica [Go to SDC_Q4]; 2=China                                12     Netherlands / Holland; 3=France                               13     Philippines; 4=Germany                              14     Poland; 5=Greece                               15     Portugal; 6=Guyana                               16     United Kingdom; 7=Hong Kong                            17     Uni...

- **SDC_C1S**: If SDC_Q1 = 20, go to SDC_Q1S. Otherwise, go to SDC_Q2.

2. **SDC_Q1S**: INTERVIEWER: Specify. ________________________ (80 spaces) - DK,R

3. **SDC_Q2**: ^WERE_C ^YOU1 born a Canadian citizen? - 1=Yes [Go to SDC_Q4]; 2=No; DK,R [Go to SDC_Q4]

4. **SDC_Q3**: In what year did ^YOU1 first come to Canada to live? INTERVIEWER: Minimum is [year of birth]; maximum is [current year]. |_|_|_|_| Year - DK,R

5. **SDC_Q4**: To which ethnic or cultural group(s) did ^YOUR2 ancestors belong? (For example: French, Scottish, Chinese, East Indian) If “Canadian” is the only response, probe. If the respondent hesitates, do not suggest Canadian. - 1=Canadian                SDCE_4L          12      Polish; 2=French                  SDCE_4M          13      Portuguese; 3=English                 SDCE_4N          14      South Asian (e.g. East; 4=German                                           Indian, Pakistani, Sri; 5=Scottish                SDCE_4T          15      Norwegian; 6=Irish                   SDCE_4U          16      Welsh; 7=Ita...

- **SDC_C4S**: If SDC_Q4 = 21, go to SDC_Q4S. Otherwise, go to SDC_Q5.

6. **SDC_Q4S**: INTERVIEWER: Specify. ________________________ (80 spaces) - DK,R

7. **SDC_Q4**: To which ethnic or cultural groups did ^YOUR2 ancestors belong? (For example: French, Scottish, Chinese, East Indian). If “Canadian” is the only response, probe. If the respondent hesitates, do not suggest Canadian. I... - 1=Canadian        SDCE_4L      12     Polish; 2=French          SDCE_4M      13     Portuguese; 3=English         SDCE_4N      14     South Asian (e.g. East; 4=German                              Indian, Pakistani, Sri Lankan); 5=Scottish        SDCE_4T      15     Norwegian; 6=Irish           SDCE_4U      16     Welsh; 7=Italian         SDCE_4V      17     Swedish; 8=Ukrainian       SDCE_4P   ...

- **SDC_C4S**: If SDC_Q4 = 21, go to SDC_Q4S. Otherwise, go to SDC_Q4_1. Note: The otherwise part of condition SDC_C4S, now flows to SDC_Q4_1, starting with June 2005 collection

8. **SDC_Q4S**: INTERVIEWER: Specify. ________________________ (80 spaces) questions SDC_Q4 and SDC_Q5, three revised questions have been added to identify Aboriginal people. - DK,R

9. **SDC_Q4_1**: ^ARE_C ^YOU1 an Aboriginal person, that is, North American Indian, Métis or Inuit? - 1=Yes; 2=No [Go to SDC_Q4_3]; DK,R [Go to SDE_Q5]

10. **SDC_Q4_2**: ^ARE_C ^YOU1: Mark all that apply. If respondent answers “Eskimo”, enter “3”. - 1=… North American Indian?; 2=… Métis?; 3=… Inuit?; DK,R; [Then go to SDC_Q5]

11. **SDC_Q4_3**: People living in Canada come from many different cultural and racial Backgrounds. ^ARE_C ^YOU1: Mark all that apply. - 1=… White?; 2=… Chinese?; 3=… South Asian (e.g., East Indian, Pakistani, Sri Lankan)?; 4=… Black?; 5=… Filipino?; 6=… Latin American?; 7=… Southeast Asian (e.g., Cambodian, Indonesian, Laotian,; 8=… Arab?; 9=… West Asian (e.g., Afghan, Iranian)?; 10=… Japanese?; 11=… Korean?; 12=Other - Specify; DK,R

- **SDC_C4_3S**: If SDC_Q4_3 = 12, go to SDC_Q4_3S. Otherwise, go to SDC_Q5.

12. **SDC_Q4_3S**: INTERVIEWER: Specify. ________________________ (80 spaces) - DK,R

13. **SDC_Q5**: In what languages can ^YOU1 conduct a conversation?  - 1=English             SDCE_5M       13      Portuguese; 2=French              SDCE_5N       14      Punjabi; 3=Arabic              SDCE_5O       15      Spanish; 4=Chinese             SDCE_5P       16      Tagalog (Pilipino); 5=Cree                SDCE_5Q       17      Ukrainian; 6=German              SDCE_5R       18      Vietnamese; 7=Greek               SDCE_5T       19      Dutch; 8=Hungari...

- **SDC_C5S**: If SDC_Q5 = 23, go to SDC_Q5S. Otherwise, go to SDC_Q5A.

14. **SDC_Q5S**: INTERVIEWER: Specify. ________________________ (80 spaces) - DK,R

15. **SDC_Q5A**: What language ^DOVERB ^YOU1 speak most often at home? - 1=English                     13    Portuguese; 2=French                      14    Punjabi; 3=Arabic                      15    Spanish; 4=Chinese                     16    Tagalog (Pilipino); 5=Cree                        17    Ukrainian; 6=German                      18    Vietnamese; 7=Greek                       19    Dutch; 8=Hungarian                   20    Hindi; 9=Italian             ...

- **SDC_C5AS**: If SDC_Q5A = 23, go to SDC_Q5AS. Otherwise, go to SDC_Q6.

16. **SDC_Q5AS**: INTERVIEWER: Specify. ________________________ (80 spaces) - DK,R

17. **SDC_Q6**: What is the language that ^YOU2 first learned at home in childhood and can still understand? If person can no longer understand the first language learned, mark the second. - 1=English                 SDCE_6M         13      Portuguese; 2=French                  SDCE_6N         14      Punjabi; 3=Arabic                  SDCE_6O         15      Spanish; 4=Chinese                 SDCE_6P         16      Tagalog (Pilipino); 5=Cree                    SDCE_6Q         17      Ukrainian; 6=German                  SDCE_6R         18      Vietnamese; 7=Greek                 ...

- **SDC_C6S**: If SDC_Q6 = 23, go to SDC_Q6S. Otherwise, go to SDC_Q7.

18. **SDC_Q6S**: INTERVIEWER: Specify. ________________________ (80 spaces) - DK,R

19. **SDC_Q7**: People living in Canada come from many different cultural and racial backgrounds. ^ARE_C ^YOU1: Mark all that apply. - 1=…White?; 2=…Chinese?; 3=…South Asian (e.g., East Indian, Pakistani, Sri Lankan)?; 4=…Black?; 5=…Filipino?; 6=…Latin American?; 7=…Southeast Asian (e.g., Cambodian, Indonesian, Laotian,; 8=…Arab?; 9=…West Asian (e.g., Afghan, Iranian)?; 10=…Japanese?; 11=…Korean?; 12=…Aboriginal (North American Indian, Métis or Inuit)?; 13=Other - Specify; DK,R

- **SDC_C7S**: If SDC_Q7 = 13, go to SDC_Q7S. Otherwise, go to SDC_C7B.

20. **SDC_Q7S**: INTERVIEWER: Specify. ________________________ (80 spaces) - DK,R

- **SDC_C7B**: If SDC_Q7 = 12, go to SDC_Q7B. Otherwise, go to SDC_C7A.

21. **SDC_Q7B**: ^ARE_C ^YOU1:  - 1=… North American Indian?; 2=… Métis?; 3=… Inuit?; 4=Other - Specify; DK,R

- **SDC_C7BS**: If SDC_Q7B = 4, go to SDC_Q7BS. Otherwise, go to SDC_C7A.

22. **SDC_Q7BS**: INTERVIEWER: Specify. ________________________ (80 spaces) - DK,R

- **SDC_C7A**: If proxy interview or age < 18 or age > 59, go to SDC_END. Otherwise, go to SDC_Q7A.

23. **SDC_Q7A**: Do you consider yourself to be: SDC_END EDUCATION (EDU) - 1=… heterosexual? (sexual relations with people of the opposite sex); 2=… homosexual, that is lesbian or gay? (sexual relations with people of your; 3=… bisexual? (sexual relations with people of both sexes); DK,R

---

### EDUCATION (EDU) - 10 questions

- **EDU_C01A**: If (do EDU block = 1), go to EDU_C01B. Otherwise, go to EDU_END.

- **EDU_C01B**: If age of selected respondent < 14, go to EDU_C07A. Otherwise, go to EDU_B01. EDU_B01 Call Education Sub Block 1 (EDU1)

- **EDU_C07A**: If there is at least one household member who is >= 14 years of age other than the selected respondent, go to EDU_R07A. Otherwise, go to EDU_END.

- *EDU_R07A*: Now I’d like you to think about the rest of your household. INTERVIEWER: Press <Enter> to continue. EDU_B02 Call Education Sub Block 2 (EDU2) Note: Ask this block for each household member aged 14 and older other than...

- *EDU_R01*: Next, education. INTERVIEWER: Press <Enter> to continue.

1. **EDU_Q01**: What is the highest grade of elementary or high school ^YOU2 ^HAVE ever completed? - 1=Grade 8 or lower; 2=Grade 9 – 10; 3=Grade 11 – 13; DK,R [Go to EDU_Q03]

2. **EDU_Q02**: Did ^YOU1 graduate from high school (secondary school)? - 1=Yes; 2=No; DK,R

3. **EDU_Q03**: ^HAVE_C ^YOU1 received any other education that could be counted towards a degree, certificate or diploma from an educational institution? - 1=Yes; 2=No [Go to EDU_Q05]; DK,R [Go to EDU_Q05]

4. **EDU_Q04**: What is the highest degree, certificate or diploma ^YOU1 ^HAVE obtained? - 1=No post-secondary degree, certificate or diploma; 2=Trade certificate or diploma from a vocational school or apprenticeship training; 3=Non-university certificate or diploma from a community college, CEGEP, school; 4=University certificate below bachelor’s level; 5=Bachelor’s degree; 6=University degree or certificate above bachelor’s degree; DK,R

5. **EDU_Q05**: ^ARE_C ^YOU1 currently attending a school, college or university? - 1=Yes; 2=No [Go to EDU1_END]; DK,R [Go to EDU1_END]

6. **EDU_Q06**: ^ARE_C ^YOU1 enrolled as a full-time student or a part-time student? EDU1_END Education Sub Block 2 (EDU2) EDU2_BEG - 1=Full-time; 2=Part-time; DK,R

7. **EDU_Q07**: What is the highest grade of elementary or high school [you/FNAME] ever completed? - 1=Grade 8 or lower; 2=Grade 9 – 10 (Québec: Secondary III or IV,; 3=Grade 11 – 13 (Québec: Secondary V, Newfoundland; DK,R [Go to EDU_Q09]

8. **EDU_Q08**: Did [you/he/she] graduate from high school (secondary school)? - 1=Yes; 2=No; DK,R

9. **EDU_Q09**: [Have/Has] [you/he/she] received any other education that could be counted towards a degree, certificate or diploma from an educational institution? - 1=Yes; 2=No                       (Go to next family member or EDU_END); DK,R

10. **EDU_Q10**: What is the highest degree, certificate or diploma [you/he/she] [have/has] obtained? EDU2_END INSURANCE COVERAGE (INS) - 1=No post-secondary degree, certificate or diploma; 2=Trade certificate or diploma from a vocational school or apprenticeship training; 3=Non-university certificate or diploma from a community college, CEGEP, school; 4=University certificate below bachelor’s level; 5=Bachelor’s degree; 6=University degree or certificate above bachelor’s degree; DK,R

---

### INSURANCE COVERAGE (INS) - 8 questions

- **INS_C1A**: If (do INS block = 1), go to INS_QINT.

- *INS_QINT*: Now, turning to ^YOUR2 insurance coverage. Please include any private, government or employer-paid plans. INTERVIEWER: Press <Enter> to continue.

1. **INS_Q1**: ^DOVERB_C ^YOU2 have insurance that covers all or part of the cost of YOUR1 prescription medications? - 1=Yes; 2=No [Go to INS_Q2]; DK [Go to INS_Q2]; R [Go to INS_END]

2. **INS_Q1A**: Is it: Mark all that apply. - 1=… a government-sponsored plan?; 2=… an employer-sponsored plan?; 3=… a private plan?; DK,R

3. **INS_Q2**: (^DOVERB_C ^YOU2 have insurance that covers all or part of:) … ^YOUR1 dental expenses? - 1=Yes; 2=No [Go to INS_Q3]; DK,R [Go to INS_Q3]

4. **INS_Q2A**: Is it: Mark all that apply. - 1=… a government-sponsored plan?; 2=… an employer-sponsored plan?; 3=… a private plan?; DK,R

5. **INS_Q3**: (^DOVERB_C ^YOU2 have insurance that covers all or part of:) … the costs of eye glasses or contact lenses? - 1=Yes; 2=No [Go to INS_Q4]; DK,R [Go to INS_Q4]

6. **INS_Q3A**: Is it: Mark all that apply. - 1=… a government-sponsored plan?; 2=… an employer-sponsored plan?; 3=… a private plan?; DK,R

7. **INS_Q4**: (^DOVERB_C ^YOU2 have insurance that covers all or part of:) … hospital charges for a private or semi-private room? - 1=Yes; 2=No [Go to INS_END]; DK,R [Go to INS_END]

8. **INS_Q4A**: Is it: Mark all that apply. INS_END INCOME (INC) - 1=… a government-sponsored plan?; 2=… an employer-sponsored plan?; 3=… a private plan?; DK,R

---

### INCOME (INC) - 19 questions

- **INC_C1**: If (do INC block = 1), go to INC_QINT. Otherwise, go to INC_END.

- *INC_QINT*: Although many health expenses are covered by health insurance, there is still a relationship between health and income. Please be assured that, like all other information you have provided, these answers will be kept ...

1. **INC_Q1**: Thinking about the total income for all household members, from which of the following sources did your household receive any income in the past 12 months? Mark all that apply. - 1=Wages and salaries; 2=Income from self-employment; 3=Dividends and interest (e.g., on bonds, savings); 4=Employment insurance; 5=Worker’s compensation; 6=Benefits from Canada or Quebec Pension Plan; 7=Retirement pensions, superannuation and annuities; 8=Old Age Security and Guaranteed Income Supplement; 9=Child Tax Benefit; 10=Provincial or municipal social assistance or welfare; 11=Child sup...

2. **LBF_Q21**: = 1).

- **INC_C2**: If more than one source of income is indicated, go to INC_Q2. Otherwise, go to INC_Q3. Note: In processing, if the respondent reported only one source of income in INC_Q1, the variable INC_Q2 is given its value.

3. **INC_Q2**: What was the main source of income? - 1=Wages and salaries; 2=Income from self-employment; 3=Dividends and interest (e.g., on bonds, savings); 4=Employment insurance; 5=Worker’s compensation; 6=Benefits from Canada or Quebec Pension; 7=Retirement pensions, superannuation and annuities; 8=Old Age Security and Guaranteed Income Supplement; 9=Child Tax Benefit; 10=Provincial or municipal social assistance or welfare; 11=Child support;...

4. **INC_Q3**: What is your best estimate of the total income, before taxes and deductions, of all household members from all sources in the past 12 months? |_|_|_|_|_|_| Income (Go to INC_C4) - 0= [Go to INC_END]; DK,R [Go to INC_Q3A]

5. **INC_Q3A**: Can you estimate in which of the following groups your household income falls? Was the total household income less than $20,000 or $20,000 or more? - 1=Less than $20,000; 2=$20,000 or more [Go to INC_Q3E]; 3=No income [Go to INC_END]; DK,R [Go to INC_END]

6. **INC_Q3B**: Was the total household income from all sources less than $10,000 or $10,000 or more? - 1=Less than $10,000; 2=$10,000 or more [Go to INC_Q3D]; DK,R [Go to INC_C4]

7. **INC_Q3C**: Was the total household income from all sources less than $5,000 or $5,000 or more? - 1=Less than $5,000; 2=$5,000 or more; DK,R; [Then go to INC_C4]

8. **INC_Q3D**: Was the total household income from all sources less than $15,000 or $15,000 or more? - 1=Less than $15,000; 2=$15,000 or more; DK,R; [Then go to INC_C4]

9. **INC_Q3E**: Was the total household income from all sources less than $40,000 or $40,000 or more? - 1=Less than $40,000; 2=$40,000 or more [Go to INC_Q3G]; DK,R [Go to INC_C4]

10. **INC_Q3F**: Was the total household income from all sources less than $30,000 or $30,000 or more? - 1=Less than $30,000; 2=$30,000 or more; DK,R; [Then go to INC_C4]

11. **INC_Q3G**: Was the total household income from all sources:  - 1=… less than $50,000?; 2=… $50,000 to less than $60,000?; 3=… $60,000 to less than $80,000?; 4=… $80,000 to less than $100,000?; 5=… $100,000 or more?; DK,R

- **INC_C4**: If age >= 15, go to INC_Q4. Otherwise, go to INC_END.

12. **INC_Q4**: What is your best estimate of ^YOUR2 total personal income, before taxes and other deductions, from all sources in the past 12 months? |_|_|_|_|_|_| Income (Go to INC_END) - 0= [Go to INC_END]; DK,R [Go to INC_Q4A]

13. **INC_Q4A**: Can you estimate in which of the following groups ^YOUR2 personal income falls? Was ^YOUR1 total personal income less than $20,000 or $20,000 or more? - 1=Less than $20,000; 2=$20,000 or more [Go to INC_Q4E]; 3=No income [Go to INC_END]; DK,R [Go to INC_END]

14. **INC_Q4B**: Was ^YOUR1 total personal income less than $10,000 or $10,000 or more? - 1=Less than $10,000; 2=$10,000 or more [Go to INC_Q4D]; DK,R [Go to INC_END]

15. **INC_Q4C**: Was ^YOUR1 total personal income less than $5,000 or $5,000 or more? - 1=Less than $5,000; 2=$5,000 or more; DK,R; [Then go to INC_END]

16. **INC_Q4D**: Was ^YOUR1 total personal income less than $15,000 or $15,000 or more? - 1=Less than $15,000; 2=$15,000 or more; DK,R; [Then go to INC_END]

17. **INC_Q4E**: Was ^YOUR1 total personal income less than $40,000 or $40,000 or more? - 1=Less than $40,000; 2=$40,000 or more [Go to INC_Q4G]; DK,R [Go to INC_END]

18. **INC_Q4F**: Was ^YOUR1 total personal income less than $30,000 or $30,000 or more? - 1=Less than $30,000; 2=$30,000 or more; DK,R; [Then go to INC_END]

19. **INC_Q4G**: Was ^YOUR1 total personal income: INC_END - 1=… less than $50,000?; 2=… $50,000 to less than $60,000?; 3=… $60,000 to less than $80,000?; 4=… $80,000 to less than $100,000?; 5=… $100,000 or more?; DK,R

---

### FOOD SECURITY (FSC) - 19 questions

*[Optional content]*

- **FSC_C01**: If (do FSC block = 1), then go to FSC_D010.

- *FSC_R010*: The following questions are about the food situation for your household in the past 12 months. INTERVIEWER: Press <Enter> to continue.

1. **FSC_Q010**: Which of the following statements best describes the food eaten in your household in the past 12 months, that is, since [current month] of last year?  - 1=^YouAndOthers_C always had enough of the kinds of food you wanted to; 2=^YouAndOthers_C had enough to eat, but not always the kinds of food you; 3=Sometimes ^YouAndOthers did not have enough to eat.; 4=Often ^YouAndOthers didn’t have enough to eat.; DK,R [Go to FSC_END]

- *FSC_R020*: Now I’m going to read you several statements that may be used to describe the food situation for a household. Please tell me if the statement was often true, sometimes true, or never true for ^YouAndOthers in the past...

2. **FSC_Q020**: The first statement is: …^YouAndOthers_C worried that food would run out before you got money to buy more. Was that often true, sometimes true, or never true in the past 12 months? - 1=Often true; 2=Sometimes true; 3=Never true; DK,R

3. **FSC_Q030**: The food that ^YouAndOthers bought just didn’t last, and there wasn’t any money to get more. Was that often true, sometimes true, or never true in the past 12 months? - 1=Often true; 2=Sometimes true; 3=Never true; DK,R

4. **FSC_Q040**: ^YouAndOthers_C couldn’t afford to eat balanced meals. In the past 12 months was that often true, sometimes true, or never true? - 1=Often true; 2=Sometimes true; 3=Never true; DK,R

- **FSC_C050**: If (OlderKids + YoungKids > 0), go to FSC_R050. Otherwise, go to FSC_C070.

- *FSC_R050*: Now I’m going to read a few statements that may describe the food situation for households with children. INTERVIEWER: Press <Enter> to continue.

5. **FSC_Q050**: ^YouOtherAdults_C relied on only a few kinds of low-cost food to feed ^ChildFName because you were running out of money to buy food. Was that often true, sometimes true, or never true in the past 12 months? - 1=Often true; 2=Sometimes true; 3=Never true; DK,R

6. **FSC_Q060**: ^YouOtherAdults_C couldn’t feed ^ChildFName a balanced meal, because you couldn’t afford it. Was that often true, sometimes true, or never true in the past - 12=months?; 1=Often true; 2=Sometimes true; 3=Never true; DK,R

- **FSC_C070**: If (FSC_Q020 or FSC_Q030 or FSC_Q040 or FSC_Q050 or FSC_Q060 <= 2) or (FSC_Q010 = 3 or 4) and (OlderKids + YoungKids > 0), go to FSC_Q070. Else if (FSC_Q020 or FSC_Q030 or FSC_Q040 or FSC_Q050 or FSC_Q060 <= 2) or (FSC_Q010 = 3 or 4), go to FSC_R080. Otherwise, go to FSC_END.

7. **FSC_Q070**: ^ChildWas not eating enough because ^YouOtherAdults just couldn't afford enough food. Was that often, sometimes, or never true in the past 12 months? - 1=Often true; 2=Sometimes true; 3=Never true; DK,R

- *FSC_R080*: The following few questions are about the food situation in the past 12 months for you or any other adults in your household. INTERVIEWER: Press <Enter> to continue.

8. **FSC_Q080**: In the past 12 months, since last [current month] did ^YouOtherAdults ever cut the size of your meals or skip meals because there wasn’t enough money for food? - 1=Yes; 2=No [Go to FSC_Q090]; DK,R [Go to FSC_Q090]

9. **FSC_Q081**: How often did this happen---almost every month, some months but not every month, or in only 1 or 2 months? - 1=Almost every month; 2=Some months but not every month; 3=Only 1 or 2 months; DK,R

10. **FSC_Q090**: In the past 12 months, did you (personally) ever eat less than you felt you should because there wasn't enough money to buy food? - 1=Yes; 2=No; DK,R

11. **FSC_Q100**: In the past 12 months, were you (personally) ever hungry but didn't eat because you couldn't afford enough food? - 1=Yes; 2=No; DK,R

12. **FSC_Q110**: In the past 12 months, did you (personally) lose weight because you didn't have enough money for food? - 1=Yes; 2=No; DK,R

- **FSC_C120**: If (FSC_Q070 = 1 or 2) or (FSC_Q080 or FSC_Q090 or FSC_Q100 or FSC_Q110 = 1), go to FSC_Q120. Otherwise, go to FSC_END.

13. **FSC_Q120**: In the past 12 months, did ^YouOtherAdults ever not eat for a whole day because there wasn't enough money for food? - 1=Yes; 2=No [Go to FSC_C130]; DK,R [Go to FSC_C130]

14. **FSC_Q121**: How often did this happen---almost every month, some months but not every month, or in only 1 or 2 months? - 1=Almost every month; 2=Some months but not every month; 3=Only 1 or 2 months; DK,R

- **FSC_C130**: If (OlderKids + YoungKids <> 0) go to FSC_R130. Otherwise, go to FSC_END.

- *FSC_R130*: Now, a few questions on the food experiences for children in your household. INTERVIEWER: Press <Enter> to continue.

15. **FSC_Q130**: In the past 12 months, did ^YouOtherAdults ever cut the size of ^AnyChilds meals because there wasn't enough money for food? - 1=Yes; 2=No; DK,R

16. **FSC_Q140**: In the past 12 months, did ^AnyChild ever skip meals because there wasn't enough money for food? - 1=Yes; 2=No [Go to FSC_Q150]; DK,R [Go to FSC_Q150]

17. **FSC_Q141**: How often did this happen---almost every month, some months but not every month, or in only 1 or 2 months? - 1=Almost every month; 2=Some months but not every month; 3=Only 1 or 2 months; DK,R

18. **FSC_Q150**: In the past 12 months, ^WasAnyChild ever hungry but you just couldn't afford more food? - 1=Yes; 2=No; DK,R

19. **FSC_Q160**: In the past 12 months, did ^AnyChild ever not eat for a whole day because there wasn't enough money for food? FSC_END - 1=Yes; 2=No; DK,R

---

### DWELLING CHARACTERISTICS (DWL) - 4 questions

- **DWL_C01**: If (do block DWL = 1), go to DWL_R01. Otherwise, go to DWL_END.

- *DWL_R01*: Now a few questions about your dwelling. INTERVIEWER: Press <Enter> to continue.

- **DWL_C01B**: If area frame, go to DWL_Q02. Otherwise, go to DWL_Q01.

1. **DWL_Q01**: What type of dwelling ^DOVERB ^YOU2 live in? Is it a: DHHEDDWE  - 1=… single detached?; 2=… double?; 3=… row or terrace?; 4=… duplex?; 5=… low-rise apartment of fewer than 5 stories or a flat?; 6=… high-rise apartment of 5 stories or more?; 7=… institution?; 8=… hotel; rooming/lodging house; camp?; 9=… mobile home?; 10=… other – Specify; DK,R

- **DWL_C01S**: If DWL_Q01 = 10, go to DW_Q01S. Otherwise, go to DWL_Q02.

2. **DWL_Q01S**: INTERVIEWER: Specify. ________________________ (80 spaces) - DK,R

3. **DWL_Q02**: How many bedrooms are there in this dwelling? DHHE_BED INTERVIEWER: Enter “0” if no separate, enclosed bedroom. |_|_| Number of bedrooms - DK,R

4. **DWL_Q03**: Is this dwelling owned by a member of this household? DHHE_OWN DWL_END ADMINISTRATION (ADM) - 1=Yes; 2=No; DK,R

---

### ADMINISTRATION (ADM) - 29 questions

- **ADM_C01**: If (do ADM block = 1), go to ADM_Q01A. Otherwise, go to ADM_END. Health Number

1. **ADM_Q01A**: Statistics Canada and your [provincial/territorial] ministry of health would like your permission to link information collected during this interview. This includes linking your survey information to your past and con...

2. **ADM_Q01B**: This linked information will be kept confidential and used only for statistical SAMEDLNK purposes. Do we have your permission? - 1=Yes; 2=No [Go to ADM_Q04A]; DK,R [Go to ADM_Q04A]

- **ADM_C3A**: If province = 10, [province] = [Newfoundland and Labrador] If province = 11, [province] = [Prince Edward Island] If province = 12, [province] = [Nova Scotia] If province = 13, [province] = [New Brunswick] If province = 24, [province] = [Quebec] If province = 35, [province] = [...

3. **ADM_Q03A**: (Having a [provincial/territorial] health number will assist us in linking to this other information.) ^DOVERB_C ^YOU1 have a(n) [province] health number? - 1=Yes [Go to HN]; 2=No; DK,R [Go to ADM_Q04A]

4. **ADM_Q03B**: For which [province/territory] is ^YOUR2 health number? LNKE_HNP HN What is ^YOUR2 health number? Data Sharing – All Provinces (excluding Québec and the territories) - 10=Newfoundland and Labrador; 11=Prince Edward Island; 12=Nova Scotia; 13=New Brunswick; 24=Quebec; 35=Ontario; 46=Manitoba; 47=Saskatchewan; 48=Alberta; 59=British Columbia; 60=Yukon; 61=Northwest Territories; 62=Nunavut; 88=Do not have a [provincial/territorial] health number [Go to ADM_Q04A]; DK,R [Go to ADM_Q04A]; DK,R

5. **ADM_Q04A**: Statistics Canada would like your permission to share the information collected in this survey with provincial and territorial ministries of health[,Health Canada and the Public Health Agency of Canada / and Health Ca...

6. **ADM_Q04A**: Statistics Canada would like your permission to share the information collected in this survey with [Health Canada, the Public Health Agency of Canada / Health Canada] and provincial and territorial ministries of heal...

7. **ADM_Q04A**: Statistics Canada would like your permission to share the information collected in this survey with provincial and territorial ministries of health, the « l’Institut de la Statistique du Québec »[, Health Canada and t...

8. **ADM_Q04B**: All information will be kept confidential and used only for statistical purposes. SAMEDSHR Do you agree to share the information provided? Frame Evaluation - 1=Yes; 2=No; DK,R

- **FRE_C1**: If RDD or FREFLAG = 1 (i.e. the frame evaluation questions have been done for the household), go to ADM_N05.

- *FRE_QINT*: And finally, a few questions to evaluate the way households were selected for this survey. INTERVIEWER: Press <Enter> to continue.

9. **FRE_Q1**: How many different telephone numbers are there for your household, not counting ADME_FE1 cellular phone numbers and phone numbers used strictly for business purposes? - 1=1; 2=2; 3=3 or more; 4=None [Go to FRE_Q4]; DK,R [Go to ADM_N05]

10. **FRE_Q2**: What is [your/your main] phone number, including the area code? INTERVIEWER: Do not include cellular or business phone numbers. Telephone number: [telnum]. Otherwise, use “your main”. Code INTERVIEWER: Enter the area ... - [Then go to FRE_C3]; DK [Go to ADM_N05]; R [Go to FRE_Q2A]

11. **FRE_Q2A**: Could you tell me the area code and the first 5 digits of your phone number? Even that will help evaluate the way households were selected. I_I_I_I_I_I_I_I_I - DK,R [Go to ADM_N05]

- **FRE_C3**: If FRE_Q1 = 1 (1 phone), go to ADM_N05.

12. **FRE_Q3**: What is [your other phone number/another of your phone numbers], including the area code? INTERVIEWER: Do not include cellular or business phone numbers. Otherwise, use “another of your phone numbers”. CODE2 INTERVIEW... - [Then go to ADM_N05]; DK [Go to ADM_N05]; R [Go to FRE_Q3A]

13. **FRE_Q3A**: Could you tell me the area code and the first 5 digits of [your other phone number/another of your phone numbers]? (Even that will help evaluate the way households were selected.) I_I_I_I_I_I_I_I_I - DK,R; [Then go to ADM_N05]

14. **FRE_Q4**: ^DOVERB_C ^YOU2 have a working cellular phone that can place and receive ADME_F4 calls? Administration - 1=Yes; 2=No; DK,R

15. **ADM_N05**: INTERVIEWER: Is this a fictitious name for the respondent?

16. **ADME_N05**:  - 1=Yes; 2=No [Go to ADM_C09]; DK,R [Go to ADM_C09]

17. **ADM_N06**: INTERVIEWER: Remind respondent about the importance of getting correct names.

18. **ADME_N06**: Do you want to make corrections to: - 1=… first name only?; 2=… last name only? [Go to ADM_N08]; 3=… both names?; 4=… no corrections? [Go to ADM_C09]; DK,R [Go to ADM_C09]

19. **ADM_N07**: INTERVIEWER: Enter the first name only. ________________________ (25 spaces) - DK,R

- **ADM_C08**: If ADM_N06 <> “both names”, go to ADM_C09.

20. **ADM_N08**: INTERVIEWER: Enter the last name only. ________________________ (25 spaces) - DK,R

- **ADM_C09**: If RDD, go to ADM_N10.

21. **ADM_N09**: INTERVIEWER: Was this interview conducted on the telephone or in person?

22. **ADME_N09**:  - 1=On telephone; 2=In person; 3=Both; DK,R

23. **ADM_N10**: INTERVIEWER: Was the respondent alone when you asked this health questionnaire?

24. **ADME_N10**:  - 1=Yes [Go to ADM_N12]; 2=No; DK,R [Go to ADM_N12]

25. **ADM_N11**: INTERVIEWER: Do you think that the answers of the respondent were affected by

26. **ADME_N11**: someone else being there? - 1=Yes; 2=No; DK,R

27. **ADM_N12**: INTERVIEWER: Record language of interview

28. **ADME_N12**:  - 1=English                        14     Tamil; 2=French                         15     Cree; 3=Chinese                        16     Afghan; 4=Italian                        17     Cantonese; 5=Punjabi                        18     Hindi; 6=Spanish                        19     Mandarin; 7=Portuguese                     20     Persian; 8=Polish                         21     Russian; 9=German  ...

- **ADM_C12S**: If ADM_N12 = 90, go to ADM_N12S. Otherwise, go to ADM_END.

29. **ADM_N12S**: INTERVIEWER: Specify ________________________ (80 spaces) ADM_END Module Name Page Number Access to health care services (acc) 220 Administration (adm) 292 Age of selected respondent (anc) 1 Alcohol use (alc) 126 Bloo... - DK,R


---

## Summary of Modules and Question Counts

| # | Module | Code | Type | Questions |
|---|--------|------|------|-----------|
| 1 | AGE OF SELECTED RESPONDENT | ANC | Common | 5 |
| 2 | GENERAL HEALTH | GEN | Common | 8 |
| 3 | VOLUNTARY ORGANIZATIONS | ORG | Optional | 2 |
| 4 | SLEEP | SLP | Optional | 4 |
| 5 | CHANGES MADE TO IMPROVE HEALTH | CIH | Optional | 12 |
| 6 | HEALTH CARE SYSTEM SATISFACTION | HCS | Optional | 4 |
| 7 | HEIGHT AND WEIGHT | HWT | Common | 12 |
| 8 | CHRONIC CONDITIONS | CCC | Common | 54 |
| 9 | DIABETES CARE | DIA | Optional | 27 |
| 10 | MEDICATION USE | MED | Common | 22 |
| 11 | HEALTH CARE UTILIZATION | HCU | Common | 33 |
| 12 | HOME CARE SERVICES | HMC | Optional | 15 |
| 13 | PATIENT SATISFACTION | PAS | Optional | 16 |
| 14 | RESTRICTION OF ACTIVITIES | RAC | Common | 21 |
| 15 | TWO-WEEK DISABILITY | TWD | Common | 12 |
| 16 | FLU SHOTS | FLU | Common | 4 |
| 17 | BLOOD PRESSURE CHECK | BPC | Common | 4 |
| 18 | PAP SMEAR TEST | PAP | Common | 4 |
| 19 | MAMMOGRAPHY | MAM | Common | 8 |
| 20 | BREAST EXAMINATIONS | BRX | Common | 4 |
| 21 | BREAST SELF-EXAMINATIONS | BSX | Common | 4 |
| 22 | EYE EXAMINATIONS | EYX | Common | 4 |
| 23 | PHYSICAL CHECK-UP | PCU | Common | 5 |
| 24 | PROSTATE CANCER SCREENING | PSA | Optional | 6 |
| 25 | COLORECTAL CANCER SCREENING | CCS | Optional | 9 |
| 26 | DENTAL VISITS | DEN | Optional | 4 |
| 27 | ORAL HEALTH 2 | OH2 | Optional | 18 |
| 28 | FOOD CHOICES | FDC | Optional | 12 |
| 29 | FRUIT AND VEGETABLE CONSUMPTION | FVC | Optional | 30 |
| 30 | PHYSICAL ACTIVITY | PAC | Common | 11 |
| 31 | SEDENTARY ACTIVITIES | SAC | Optional | 4 |
| 32 | USE OF PROTECTIVE EQUIPMENT | UPE | Optional | 14 |
| 33 | SUN SAFETY | SSB | Optional | 11 |
| 34 | SMOKING | SMK | Common | 21 |
| 35 | SMOKING - STAGES OF CHANGE | SCH | Optional | 4 |
| 36 | NICOTINE DEPENDENCE | NDE | Optional | 5 |
| 37 | SMOKING CESSATION AIDS | SCA | Optional | 10 |
| 38 | SMOKING - PHYSICIAN COUNSELLING | SPC | Optional | 9 |
| 39 | YOUTH SMOKING | YSM | Optional | 6 |
| 40 | EXPOSURE TO SECOND-HAND SMOKE | ETS | Common | 6 |
| 41 | ALCOHOL USE | ALC | Common | 10 |
| 42 | MATERNAL EXPERIENCES | MEX | Optional | 26 |
| 43 | ILLICIT DRUGS | DRG | Optional | 39 |
| 44 | PROBLEM GAMBLING INDEX | CPG | Optional | 36 |
| 45 | SATISFACTION WITH LIFE | SWL | Optional | 9 |
| 46 | STRESS - SOURCES | STS | Optional | 4 |
| 47 | STRESS - COPING | STC | Optional | 14 |
| 48 | CHILDHOOD AND ADULT STRESSORS | CST | Optional | 7 |
| 49 | WORK STRESS | WST | Optional | 14 |
| 50 | SELF-ESTEEM | SFE | Optional | 6 |
| 51 | SOCIAL SUPPORT - AVAILABILITY | SSA | Optional | 20 |
| 52 | SOCIAL SUPPORT - UTILIZATION | SSU | Optional | 15 |
| 53 | CONTACTS WITH MENTAL HEALTH PROFESSIONALS | CMH | Optional | 4 |
| 54 | DISTRESS | DIS | Optional | 17 |
| 55 | DEPRESSION | DEP | Optional | 31 |
| 56 | SUICIDAL THOUGHTS AND ATTEMPTS | SUI | Optional | 6 |
| 57 | INJURIES | INJ | Common | 28 |
| 58 | HEALTH UTILITY INDEX | HUI | Optional | 31 |
| 59 | HEALTH STATUS - SF-36 | SFR | Optional | 34 |
| 60 | SEXUAL BEHAVIOURS | SXB | Optional | 13 |
| 61 | ACCESS TO HEALTH CARE SERVICES | ACC | Optional | 45 |
| 62 | WAITING TIMES | WTM | Optional | 78 |
| 63 | MEASURED HEIGHT AND WEIGHT | MHW | Optional | 40 |
| 64 | LABOUR FORCE | LBF | Optional | 42 |
| 65 | LABOUR FORCE - COMMON PORTION | LF2 | Common | 8 |
| 66 | SOCIO-DEMOGRAPHIC CHARACTERISTICS | SDC | Common | 23 |
| 67 | EDUCATION | EDU | Common | 10 |
| 68 | INSURANCE COVERAGE | INS | Common | 8 |
| 69 | INCOME | INC | Common | 19 |
| 70 | FOOD SECURITY | FSC | Optional | 19 |
| 71 | DWELLING CHARACTERISTICS | DWL | Common | 4 |
| 72 | ADMINISTRATION | ADM | Common | 29 |

**TOTAL SECTIONS**: 72
**TOTAL UNIQUE QUESTION NODES**: ~1153
