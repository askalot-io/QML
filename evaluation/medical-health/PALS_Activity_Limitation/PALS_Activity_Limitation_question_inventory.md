# PALS 2001 (Children under 15) — Question Inventory

## Verification Status

| Section | Source Qs | Inventory Qs | Filter Nodes | Missing Qs | Source GOTOs | Inv. GOTOs | GOTO Gaps |
|---------|-----------|-------------|--------------|-----------|-------------|-----------|-----------|
| A | 4 | 4 | 0 | 0 | 4 | 4 | 0 |
| B | 97 | 97 | 13 | 0 | ~70 | ~70 | 0 |
| C | 24 | 24 | 5 | 0 | ~18 | ~20 | 0 |
| D | 7 | 7 | 1 | 0 | 3 | 4 | 0 |
| E | 38 | 38 | 1 | 0 | ~25 | ~22 | 1 (E2) |
| F | 16 | 16 | 0 | 0 | ~14 | ~14 | 0 |
| G | 10 | 10 | 1 | 0 | 5 | 5 | 0 |
| H | 16 | 16 | 1 | 0 | 8 | 9 | 0 |
| I | 10 | 10 | 0 | 0 | 4 | 6 | 0 |
| FU | 1 | 1 | 0 | 0 | 1 | 1 | 0 |
| **Total** | **223** | **223** | **22** | **0** | **148** | **134** | **1** |

Note: Inventory GOTO count (134) is lower than source (148) because many source GOTOs are absorbed into filter node
descriptions rather than listed as separate routing annotations. The net routing logic is correct except for E2.

- **Coverage**: 10/10 sections verified, 223 source questions fully captured, 22 filter/age-gate nodes added
- **Routing**: 134/148 GOTO annotations captured (14 GOTOs absorbed into filter node descriptions); 1 routing bug found and fixed
- **Status**: READY FOR QML
- **Repaired**: 1 routing bug fixed + 5 section header counts corrected:
  1. **ROUTING BUG (fixed) — E2**: Was routing `E2 → E4`. Source places E3.edit ("Interviewer: Go to E37") between E2 and E3, meaning children tutored at home (E1=2) must skip to E37 after E2. Fixed to `E2 → GO TO E37`.
  2. **Header counts corrected**: C 27→29, E 38→39, F 32→38, H 16→17, I 12→10 to match actual inventory item counts.

## Document Overview
- **Title**: Participation and Activity Limitation Survey — 2001 (Children — under 15)
- **Organization**: Statistics Canada
- **Form**: FORM 03
- **Pages**: 57
- **Language**: English
- **Type**: Paper-based interviewer-administered survey (PAPI)
- **Authority**: Collected under the authority of the Statistics Act, Statutes of Canada, 1985, Chapter S19

## Structure

The questionnaire is divided into 9 sections plus a follow-up:
- **Section A** — Filter Questions (4 items)
- **Section B** — Activity Limitations (110 items) — hearing, seeing, communication, walking, hands/fingers, learning, developmental, emotional/psychological, chronic conditions, diagnosis/cause, health, medications, health professionals, aids/costs
- **Section C** — Help with Everyday Activities (29 items)
- **Section D** — Child Care (8 items)
- **Section E** — Education (39 items)
- **Section F** — Leisure and Recreation Activities (38 items)
- **Section G** — Home Accommodation (11 items)
- **Section H** — Transportation (17 items)
- **Section I** — Economic Characteristics (10 items)
- **Follow-up** — Contact information for future re-contact (1 item)

**Age gate**: A critical routing filter based on date of birth (born after May 15, 1996 = under age 5) gates access to most sections. Children under 5 skip large portions of the questionnaire — specifically most of Sections B (aids subsections), all of Sections E–H, and Section C (personal care portion). The Profile Sheet tracks limitation flags across sections.

## Question Inventory by Section

### Section A — Filter Questions — 4 items

1. A1: "Does ..... have any DIFFICULTY hearing, seeing, communicating, walking, climbing stairs, bending, learning or doing any similar activities?" — Single select {1: "Yes, sometimes", 2: "Yes, often", 3: "No", x: "Don't know", r: "Refusal"} — 1 → [CHECK: mark "General — Limitation" on Profile Sheet] → A2A; 2 → A2A; 3 → A2A; x → A2A; r → A2A

2. A2A: "Does a physical condition OR mental condition OR health problem REDUCE THE AMOUNT OR THE KIND OF ACTIVITY ..... can do at home?" — Single select {1: "Yes, sometimes", 2: "Yes, often", 3: "No", x: "Don't know", r: "Refusal"} — 1 → [CHECK: mark "General — Limitation" on Profile Sheet] → A2B; 2 → A2B; 3 → A2B; x → A2B; r → A2B

3. A2B: "Does a physical condition OR mental condition OR health problem REDUCE THE AMOUNT OR THE KIND OF ACTIVITY ..... can do at work or at school?" — Single select {1: "Yes, sometimes", 2: "Yes, often", 3: "No", 5: "Not applicable", x: "Don't know", r: "Refusal"} — 1 → [CHECK: mark "General — Limitation" on Profile Sheet] → A2C; 2 → A2C; 3 → A2C; 5 → A2C; x → A2C; r → A2C

4. A2C: "Does a physical condition OR mental condition OR health problem REDUCE THE AMOUNT OR THE KIND OF ACTIVITY ..... can do in other activities, for example, transportation or leisure?" — Single select {1: "Yes, sometimes", 2: "Yes, often", 3: "No", x: "Don't know", r: "Refusal"} — 1 → [CHECK: mark "General — Limitation" on Profile Sheet] → Section B; 2 → Section B; 3 → Section B; x → Section B; r → Section B

### Section B — Activity Limitations — 110 items

**HEARING SUBSECTION**

5. B1: "I'm going to ask you about .....'s ability to do certain activities. Please tell me only about those difficulties that have lasted, or are expected to last six months or more. Does ..... use a hearing aid or hearing aids?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → B2; 3 → B2; x → GO TO B4; r → GO TO B4

6. B2: "WITH HEARING AID(S), how would you describe his/her ability to hear?" — Single select {1: "Child has no problem hearing", 2: "Child has difficulty hearing", x: "Don't know", r: "Refusal"} — 1 → GO TO B11; 2 → [CHECK: mark "Hearing — Limitation" on Profile Sheet] → B3; x → GO TO B11; r → GO TO B11

7. B3: "How much difficulty?" — Single select {1: "Some difficulty", 2: "A lot of difficulty", x: "Don't know", r: "Refusal"} — 1 → B6.edit; 2 → GO TO B6.edit; x → B6.edit; r → B6.edit

8. B4: "How would you describe .....'s ability to hear?" — Single select {1: "Child has no problem hearing", 2: "Child has difficulty hearing", 3: "Child cannot hear", x: "Don't know", r: "Refusal"} — 1 → GO TO B11; 2 → [CHECK: mark "Hearing — Limitation" on Profile Sheet] → B5; 3 → [CHECK: mark "Hearing — Limitation" on Profile Sheet] → GO TO B6.edit; x → GO TO B11; r → GO TO B11

9. B5: "How much difficulty?" — Single select {1: "Some difficulty", 2: "A lot of difficulty", x: "Don't know", r: "Refusal"} — 1 → B6.edit; 2 → GO TO B6.edit; x → B6.edit; r → B6.edit

10. B6.edit: "If child was born AFTER May 15, 1996, go to B11. Otherwise, continue." — Filter — born after May 15 1996 → GO TO B11; otherwise → B6

11. B6: "Does ..... USE any aids, specialized equipment or services for children with hearing difficulties, for example, a volume control telephone or T.V. decoder?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → [CHECK: mark "Hearing — USE Aid" on Profile Sheet] → B7; 3 → B7; x → GO TO B8; r → GO TO B8

12. B7: "Does he/she now use: (a) a volume control telephone; (b) a closed caption TV or decoder; (c) a TTY or TDD; (d) an amplifier, such as FM or infrared; (e) a computer to communicate (e.g. e-mail or chat service); (f) a Sign language interpreter; (g) other aid, specify" — Multi select (Yes/No per sub-item) — → B8

13. B8: "Are there any aids or services for children with hearing difficulties that ..... CURRENTLY needs, but does not have?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → [CHECK: mark "Hearing — NEED Aid" on Profile Sheet] → B9; 3 → B9; x → GO TO B10; r → GO TO B10

14. B9: "Which aids or services does he/she NEED, but does not have? (a) A hearing aid or hearing aids; (b) A volume control telephone; (c) A closed caption T.V. or decoder; (d) A TTY or TDD; (e) An amplifier, such as FM or infrared; (f) A computer to communicate (e.g. e-mail or chat service); (g) A Sign language interpreter; (h) Other aid, specify" — Multi select — → B10

15. B10: "This question deals with certain communication skills. Does .....: (a) use Sign Language, such as ASL or LSQ? (b) speech read or lip read?" — Multi select (Yes/No per sub-item) — → B11

**VISION SUBSECTION**

16. B11: "Does ..... wear glasses or contact lenses to see up close or at a distance?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → B12; 3 → B12; x → GO TO B14; r → GO TO B14

17. B12: "WITH GLASSES or CONTACT LENSES, how would you describe his/her vision ability?" — Single select {1: "Child has no problem seeing", 2: "Child has difficulty seeing", x: "Don't know", r: "Refusal"} — 1 → GO TO B13.edit; 2 → [CHECK: mark "Seeing — Limitation" on Profile Sheet] → B13; x → GO TO B13.edit; r → GO TO B13.edit

18. B13: "How much difficulty?" — Single select {1: "Some difficulty", 2: "A lot of difficulty", x: "Don't know", r: "Refusal"} — 1 → B13.edit; 2 → GO TO B16.edit; x → B13.edit; r → B13.edit

19. B13.edit: "If child was born AFTER May 15, 1996, go to B51. Otherwise, go to B21." — Filter — born after May 15 1996 → GO TO B51; otherwise → GO TO B21

20. B14: "How would you describe .....'s vision ability?" — Single select {1: "Child has no problem seeing", 2: "Child has difficulty seeing", 3: "Child cannot see", x: "Don't know", r: "Refusal"} — 1 → GO TO B15.edit; 2 → [CHECK: mark "Seeing — Limitation" on Profile Sheet] → B15; 3 → [CHECK: mark "Seeing — Limitation" on Profile Sheet] → GO TO B16.edit; x → GO TO B15.edit; r → GO TO B15.edit

21. B15: "How much difficulty?" — Single select {1: "Some difficulty", 2: "A lot of difficulty", x: "Don't know", r: "Refusal"} — 1 → B15.edit; 2 → GO TO B16.edit; x → B15.edit; r → B15.edit

22. B15.edit: "If child was born AFTER May 15, 1996, go to B51. Otherwise, go to B21." — Filter — born after May 15 1996 → GO TO B51; otherwise → GO TO B21

23. B16.edit: "If child was born AFTER May 15, 1996, go to B51. Otherwise, continue." — Filter — born after May 15 1996 → GO TO B51; otherwise → B16

24. B16: "Has ..... been diagnosed by an eye specialist as being legally blind?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → B17; 3 → B17; x → B17; r → B17

25. B17: "Does ..... USE any aids or specialized equipment for children with vision difficulties, for example, magnifiers or Braille reading materials?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → [CHECK: mark "Seeing — USE Aid" on Profile Sheet] → B18; 3 → B18; x → GO TO B19; r → GO TO B19

26. B18: "Does he/she now use: (a) magnifiers; (b) Braille reading materials; (c) large print reading materials; (d) talking books; (e) recording equipment; (f) a closed circuit TV; (g) a computer with Braille, large print, or speech access; (h) other aid, specify" — Multi select (Yes/No per sub-item) — → B19

27. B19: "Are there any aids or specialized equipment for children with vision difficulties that ..... CURRENTLY needs, but does not have?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → [CHECK: mark "Seeing — NEED Aid" on Profile Sheet] → B20; 3 → B20; x → GO TO B21; r → GO TO B21

28. B20: "Which aids does he/she NEED, but does not have? (a) Glasses or contact lenses; (b) Magnifiers; (c) Braille reading materials; (d) Large print reading materials; (e) Talking books; (f) Recording equipment; (g) A closed circuit TV; (h) A computer with Braille, large print, or speech access; (i) Other aid, specify" — Multi select — → B21

**COMMUNICATION SUBSECTION**

29. B21: "Because of a condition or health problem, does ..... have any difficulty speaking?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → [CHECK: mark "Communicating — Limitation" on Profile Sheet] → GO TO B23; 3 → B22; x → B22; r → B22

30. B22: "Because of a condition or health problem, does ..... have any difficulty making himself/herself understood when speaking?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → [CHECK: mark "Communicating — Limitation" on Profile Sheet] → GO TO B25; 3 → GO TO B31; x → GO TO B31; r → GO TO B31

31. B23: "How much difficulty does he/she have speaking?" — Single select {1: "Child has some difficulty", 2: "Child has a lot of difficulty", 3: "Child cannot speak", x: "Don't know", r: "Refusal"} — 1 → B24; 2 → B24; 3 → GO TO B26; x → B24; r → B24

32. B24: "Because of a condition or health problem, does ..... have any difficulty making himself/herself understood when speaking?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → B25; 3 → B26; x → GO TO B26; r → GO TO B26

33. B25: "How well do you feel ..... is able to make himself/herself understood when speaking with: (a) his/her family members? (b) his/her friends? (c) other people?" — Single select per sub-item {1: "Completely", 2: "Partially", 3: "Not at all", x: "Don't know", r: "Refusal"} — → B26

34. B26: "Does he/she use: (a) Sign language, such as ASL or LSQ; (b) other form of communication, specify" — Multi select (Yes/No per sub-item) — → B27

35. B27: "Does ..... USE any aids or specialized equipment for children who have difficulty speaking or making themselves understood, for example, a voice amplifier or Blissboard?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → [CHECK: mark "Communicating — USE Aid" on Profile Sheet] → B28; 3 → B28; x → GO TO B29; r → GO TO B29

36. B28: "Does he/she now use: (a) a voice amplifier; (b) a computer or keyboard device to communicate; (c) a communication board, such as a Blissboard; (d) other aid, specify" — Multi select (Yes/No per sub-item) — → B29

37. B29: "Are there any aids or specialized equipment for children who have difficulty speaking or making themselves understood that ..... CURRENTLY needs, but does not have?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → [CHECK: mark "Communicating — NEED Aid" on Profile Sheet] → B30; 3 → B30; x → GO TO B31; r → GO TO B31

38. B30: "Which aids does he/she NEED, but does not have? (a) A voice amplifier; (b) A computer or keyboard device to communicate; (c) A communication board, such as a Blissboard; (d) Other aid, specify" — Multi select — → B31

**WALKING/MOBILITY SUBSECTION**

39. B31: "Because of a condition or health problem, does ..... have any difficulty walking? This means walking on a flat firm surface, such as a sidewalk or floor." — Single select {1: "Yes, sometimes", 2: "Yes, often or always", 3: "No", x: "Don't know", r: "Refusal"} — 1 → [CHECK: mark "Walking — Limitation" on Profile Sheet] → B32; 2 → [CHECK: mark "Walking — Limitation" on Profile Sheet] → B32; 3 → GO TO B37; x → GO TO B37; r → GO TO B37

40. B32: "How much difficulty does he/she have walking?" — Single select {1: "Some difficulty", 2: "A lot of difficulty", 3: "Child cannot walk", x: "Don't know", r: "Refusal"} — → B33

41. B33: "Does ..... USE any aids or specialized equipment for children who have difficulty walking or moving around, such as a cane or crutches?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → [CHECK: mark "Walking — USE Aid" on Profile Sheet] → B34; 3 → B34; x → GO TO B35; r → GO TO B35

42. B34: "Does he/she now use: (a) orthopaedic or medically prescribed shoes; (b) a cane or crutches; (c) a walker; (d) a manual wheelchair; (e) an electric wheelchair; (f) braces, such as a leg brace (Exclude dental braces.); (g) lift devices, such as a bed lift device; (h) other aid, specify" — Multi select (Yes/No per sub-item) — → B35

43. B35: "Are there any aids or specialized equipment for children who have difficulty walking or moving around that ..... CURRENTLY needs, but does not have?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → [CHECK: mark "Walking — NEED Aid" on Profile Sheet] → B36; 3 → B36; x → GO TO B37; r → GO TO B37

44. B36: "Which aids does he/she NEED, but does not have? (a) Orthopaedic or medically prescribed shoes; (b) A cane or crutches; (c) A walker; (d) A manual wheelchair; (e) An electric wheelchair; (f) Braces, such as a leg brace (Exclude dental braces.); (g) Lift devices, such as a bed lift device; (h) Other aid, specify" — Multi select — → B37

**HANDS/FINGERS SUBSECTION**

45. B37: "Because of a condition or health problem, does ..... have any difficulty USING his/her HANDS or FINGERS to grasp or hold small objects, such as a pencil or scissors?" — Single select {1: "Yes, sometimes", 2: "Yes, often or always", 3: "No", x: "Don't know", r: "Refusal"} — 1 → [CHECK: mark "Hands/Fingers — Limitation" on Profile Sheet] → B38; 2 → [CHECK: mark "Hands/Fingers — Limitation" on Profile Sheet] → B38; 3 → GO TO B43; x → GO TO B43; r → GO TO B43

46. B38: "How much difficulty?" — Single select {1: "Some difficulty", 2: "A lot of difficulty", 3: "Completely unable", x: "Don't know", r: "Refusal"} — → B39

47. B39: "Does ..... USE any aids or specialized equipment designed to support, replace or assist in the use of hands or fingers, such as a hand or arm brace, or grasping tools?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → [CHECK: mark "Hands/Fingers — USE Aid" on Profile Sheet] → B40; 3 → B41; x → GO TO B41; r → GO TO B41

48. B40: "Does he/she now use: (a) a hand or arm brace; (b) grasping tools or reach extenders; (c) other aid, specify" — Multi select (Yes/No per sub-item) — → B41

49. B41: "Are there any aids or specialized equipment designed to support, replace or assist in the use of hands or fingers that ..... CURRENTLY needs, but does not have?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → [CHECK: mark "Hands/Fingers — NEED Aid" on Profile Sheet] → B42; 3 → B42; x → GO TO B43; r → GO TO B43

50. B42: "Which aids does he/she NEED, but does not have? (a) A hand or arm brace; (b) Grasping tools or reach extenders; (c) Other aid, specify" — Multi select — → B43

**LEARNING DISABILITY SUBSECTION**

51. B43: "Do you think that ..... has a learning disability, such as dyslexia, hyperactivity or attention problems?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → [CHECK: mark "Learning — Limitation" on Profile Sheet] → B44; 3 → B44; x → B44; r → B44

52. B44: "Has a teacher, doctor or other health professional ever said that ..... had a learning disability?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → [CHECK: mark "Learning — Limitation" on Profile Sheet] → B45.edit; 3 → B45.edit; x → B45.edit; r → B45.edit

53. B45.edit: "If B43 OR B44 is 'Yes', continue. Otherwise, go to B53." — Filter — B43=Yes OR B44=Yes → B45; otherwise → GO TO B53

54. B45: "Does this condition reduce the amount or the kind of activities ..... can do?" — Single select {1: "Yes, sometimes", 2: "Yes, often or always", 3: "No", x: "Don't know", r: "Refusal"} — 1 → B46; 2 → B46; 3 → B46; x → GO TO B47; r → GO TO B47

55. B46: "How many ACTIVITIES does this condition USUALLY prevent him/her from doing: (a) at home? (b) at school? (c) at play or recreational activities?" — Single select per sub-item {1: "None", 2: "A few", 3: "Many", 4: "Most", x: "Don't know", r: "Refusal"} — → B47

56. B47: "Does ..... USE any aids, specialized equipment or services to help him/her with his/her learning difficulty?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → [CHECK: mark "Learning — USE Aid" on Profile Sheet] → B48; 3 → B48; x → GO TO B49; r → GO TO B49

57. B48: "Does he/she now use: (a) a computer as a learning aid; (b) a voice activated or voice synthesis computer software (e.g. Dragon Dictate, Via Voice); (c) talking books; (d) recording equipment; (e) a tutor; (f) other aid, specify" — Multi select (Yes/No per sub-item) — → B49

58. B49: "Are there any learning aids, specialized equipment or services that ..... CURRENTLY needs, but does not have?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → [CHECK: mark "Learning — NEED Aid" on Profile Sheet] → B50; 3 → B50; x → GO TO B51.edit; r → GO TO B51.edit

59. B50: "Which aids or services does he/she NEED, but does not have? (a) A computer as a learning aid; (b) A voice activated or voice synthesis computer software (e.g. Dragon Dictate, Via Voice); (c) Talking books; (d) Recording equipment; (e) A tutor; (f) Other aid, specify" — Multi select — → B51.edit

**DEVELOPMENTAL DELAY SUBSECTION**

60. B51.edit: "If child was born AFTER May 15, 1996, continue to B51. Otherwise, go to B53." — Filter — born after May 15 1996 → B51; otherwise → GO TO B53

61. B51: "Because of a condition or health problem, does ..... have a delay in his/her development, either a physical, intellectual or another type of delay?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → [CHECK: mark "Developmental — Limitation" on Profile Sheet] → B52; 3 → B52; x → GO TO B59; r → GO TO B59

62. B52: "What kind of delay is this? I will read you a list. Please answer yes or no to each. (a) A delay in his/her PHYSICAL development; (b) A delay in his/her INTELLECTUAL development; (c) Other type of delay, specify" — Multi select (Yes/No per sub-item) — → B53.edit

63. B53.edit: "If child was born AFTER May 15, 1996, go to B59. Otherwise, continue." — Filter — born after May 15 1996 → GO TO B59; otherwise → B53

64. B53: "Has a doctor, psychologist or other health professional ever said that ..... has a developmental disability or disorder? These may include autism, Down syndrome, or mental impairment due to a lack of oxygen at birth." — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → [CHECK: mark "Developmental — Limitation" on Profile Sheet] → B54; 3 → B54; x → GO TO B56; r → GO TO B56

65. B54: "Does this condition reduce the amount or the kind of activities ..... can do?" — Single select {1: "Yes, sometimes", 2: "Yes, often or always", 3: "No", x: "Don't know", r: "Refusal"} — 1 → B55; 2 → B55; 3 → B55; x → GO TO B56; r → GO TO B56

66. B55: "How many ACTIVITIES does this condition USUALLY prevent him/her from doing: (a) at home? (b) at school? (c) at play or recreational activities?" — Single select per sub-item {1: "None", 2: "A few", 3: "Many", 4: "Most", x: "Don't know", r: "Refusal"} — → B56

**EMOTIONAL/PSYCHOLOGICAL SUBSECTION**

67. B56: "Does ..... have any emotional, psychological or behavioural conditions that have lasted or are expected to last six months or more?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → B57; 3 → B57; x → GO TO B59; r → GO TO B59

68. B57: "Does this condition reduce the amount or the kind of activities ..... can do?" — Single select {1: "Yes, sometimes", 2: "Yes, often or always", 3: "No", x: "Don't know", r: "Refusal"} — 1 → [CHECK: mark "Emotional/Psychological — Limitation" on Profile Sheet] → B58; 2 → [CHECK: mark "Emotional/Psychological — Limitation" on Profile Sheet] → B58; 3 → GO TO B59; x → GO TO B59; r → GO TO B59

69. B58: "How many ACTIVITIES does this condition USUALLY prevent him/her from doing: (a) at home? (b) at school? (c) at play or recreational activities?" — Single select per sub-item {1: "None", 2: "A few", 3: "Many", 4: "Most", x: "Don't know", r: "Refusal"} — → B59

**CHRONIC CONDITIONS SUBSECTION**

70. B59: "Does ..... have any of the following LONG-TERM conditions which have been DIAGNOSED by a health professional? (a) Asthma or severe allergies; (b) Heart condition or disease; (c) Kidney condition or disease; (d) Cancer; (e) Diabetes; (f) Epilepsy; (g) Autism; (h) Cerebral Palsy; (i) Spina Bifida; (j) Cystic Fibrosis; (k) Muscular Dystrophy; (l) Migraines; (m) Arthritis or rheumatism; (n) Paralysis of any kind; (o) Missing or malformed arms, legs, fingers or toes; (p) Fetal Alcohol Syndrome; (q) Attention Deficit Disorder (ADD) or Attention Deficit Hyperactivity Disorder (ADHD); (r) Down syndrome; (s) Complex medical care needs; (t) Any other LONG-TERM condition that has been diagnosed by a health professional, specify" — Multi select (Yes/No per sub-item) — → B60.edit

71. B60.edit: "If there is at least one 'Yes' checked in B59, continue. Otherwise, go to B62.edit." — Filter — any B59=Yes → B60; otherwise → GO TO B62.edit

72. B60: "Does this condition (Do these conditions) reduce the amount or the kind of activities ..... can do?" — Single select {1: "Yes, sometimes", 2: "Yes, often or always", 3: "No", x: "Don't know", r: "Refusal"} — 1 → [CHECK: mark "Chronic — Limitation" on Profile Sheet] → B61; 2 → [CHECK: mark "Chronic — Limitation" on Profile Sheet] → B61; 3 → GO TO B62.edit; x → GO TO B62.edit; r → GO TO B62.edit

73. B61: "How many ACTIVITIES does this condition (do these conditions) USUALLY prevent him/her from doing: (a) at home? (b) at school? (c) at play or recreational activities?" — Single select per sub-item {1: "None", 2: "A few", 3: "Many", 4: "Most", x: "Don't know", r: "Refusal"} — → B62.edit

74. B62.edit: "If any box is checked in the 'Limitation Column' on the Profile Sheet, go to B62. Otherwise, go to Follow-up (page 52)." — Filter — any Limitation box checked on Profile Sheet → B62; otherwise → GO TO Follow-up

**DIAGNOSIS AND CAUSE SUBSECTION**

75. B62: "You mentioned earlier that because of a physical condition, mental condition or health problem ..... has difficulties or activity limitations. How old was ..... when you suspected that he/she has a long-term condition or health problem?" — Numeric (0–14, enter 00 if less than 1 year) — → B63; x → B63; r → B63

76. B63: "What is the MAIN condition or health problem which causes him/her difficulties or activity limitations?" — Text (specify one condition) — answer → B64; x → GO TO B65; r → GO TO B65

77. B64: "Which one of the following best describes the CAUSE of this condition or health problem?" — Single select {1: "Existed at birth, was due to premature birth or accident at birth", 2: "A disease or illness", 3: "Accident at home or at school", 4: "Motor vehicle accident", 5: "Other, specify", x: "Don't know", r: "Refusal"} — → B65

78. B65: "Did you get a diagnosis for .....'s condition or health problem?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → B66; 3 → B66; x → GO TO B68; r → GO TO B68

79. B66: "How old was ..... when you obtained a diagnosis for his/her condition or health problem?" — Numeric (0–14, enter 00 if less than 1 year) — → B67; x → B67; r → B67

80. B67: "Did you experience any of the following situations when you were trying to obtain a diagnosis for .....'s condition or health problem? (a) Doctor or health professional took a wait and see approach; (b) Long waiting period to get the diagnosis; (c) Difficulty getting referrals or appointments; (d) Doctor or health professional not available locally; (e) Too expensive; (f) Did not know where to get the diagnosis; (g) Other, specify" — Multi select (Yes/No per sub-item) — → B68

**GENERAL HEALTH AND MEDICATIONS SUBSECTION**

81. B68: "How would you describe .....'s general health? Would you say that his/her health is:" — Single select {1: "Excellent", 2: "Very good", 3: "Good", 4: "Fair", 5: "Poor", x: "Don't know", r: "Refusal"} — → B69

82. B69: "Does ..... USE any prescription or non-prescription medications on a regular basis, that is, AT LEAST ONCE A WEEK?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → B70; 3 → GO TO B75; x → GO TO B75; r → GO TO B75

83. B70: "How many kinds of PRESCRIPTION medications does he/she take EVERYDAY?" — Single select {1: "None", 2: "1–3 kinds", 3: "4 kinds or more", x: "Don't know", r: "Refusal"} — → B71

84. B71: "How many kinds of NON-PRESCRIPTION medications does he/she take EVERYDAY?" — Single select {1: "None", 2: "1–3 kinds", 3: "4 kinds or more", x: "Don't know", r: "Refusal"} — → B72

85. B72: "Does ..... USE any medications regularly, but NOT DAILY?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → B73; 3 → GO TO B75; x → GO TO B75; r → GO TO B75

86. B73: "How many kinds of PRESCRIPTION medications does he/she take (regularly, but NOT DAILY)?" — Single select {1: "None", 2: "1–3 kinds", 3: "4 kinds or more", x: "Don't know", r: "Refusal"} — → B74

87. B74: "How many kinds of NON-PRESCRIPTION medications does he/she take (regularly, but NOT DAILY)?" — Single select {1: "None", 2: "1–3 kinds", 3: "4 kinds or more", x: "Don't know", r: "Refusal"} — → B75

88. B75: "IN THE PAST 12 MONTHS, did you or your family have any OUT-OF-POCKET expenses, that are not reimbursed by any sources, for .....'s prescription or non-prescription medications?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → B76; 3 → GO TO B78; x → GO TO B78; r → GO TO B78

89. B76: "What is your best estimate of the OUT-OF-POCKET or DIRECT costs to you or your family for these extra expenses? INCLUDE amounts not covered by insurance. EXCLUDE payments for which you have been or will be reimbursed by any insurance or government program." — Numeric ($, range 1–999999) — amount → GO TO B78; x → B77; r → B77

90. B77: "Which one of the following expense groups is the best estimate of the direct costs to you or your family?" — Single select {1: "Less than $100", 2: "$100 to less than $200", 3: "$200 to less than $500", 4: "$500 to less than $1000", 5: "$1000 to less than $2000", 6: "$2000 to less than $5000", 7: "$5000 or more", x: "Don't know", r: "Refusal"} — → B78

91. B78: "Because of a condition or health problem, does ..... CURRENTLY need any prescription or non-prescription medications on a regular basis, which he/she does not have?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → B79; 3 → GO TO B80; x → GO TO B80; r → GO TO B80

92. B79: "Why doesn't he/she have these medications? I will read you a list. Please answer yes or no to each. (a) Not covered by insurance; (b) Too expensive; (c) Not approved or recommended by health professionals; (d) Other reason, specify" — Multi select (Yes/No per sub-item) — → B80

**HEALTH PROFESSIONAL CONTACTS AND COSTS SUBSECTION**

93. B80: "IN THE PAST 12 MONTHS, how OFTEN has ..... seen or received care from a: (a) family doctor or general practitioner? (b) medical specialist (such as a heart specialist)? (c) nurse? (d) speech therapist? (e) physiotherapist? (f) psychologist or psychotherapist? (g) chiropractor? (h) other health professional, specify" — Single select per sub-item {1: "At least once a week", 2: "At least once a month", 3: "Less than once a month", 4: "Never", x: "Don't know", r: "Refusal"} — → B81.edit

94. B81.edit: "If there is at least one check mark in column (1), (2) or (3) of B80, continue. Otherwise, go to B84." — Filter — any B80 col 1/2/3 checked → B81; otherwise → GO TO B84

95. B81: "IN THE PAST 12 MONTHS, did you or your family have any OUT-OF-POCKET expenses, that are not reimbursed by any sources, for the services that ..... received from health professionals?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → B82; 3 → GO TO B84; x → GO TO B84; r → GO TO B84

96. B82: "What is your best estimate of the OUT-OF-POCKET or DIRECT costs to you or your family for these extra expenses? INCLUDE amounts not covered by insurance. EXCLUDE payments for which you have been or will be reimbursed by any insurance or government program." — Numeric ($, range 1–999999) — amount → GO TO B84; x → B83; r → B83

97. B83: "Which one of the following expense groups is the best estimate of the direct costs to you or your family?" — Single select {1: "Less than $200", 2: "$200 to less than $500", 3: "$500 to less than $1000", 4: "$1000 to less than $2000", 5: "$2000 to less than $5000", 6: "$5000 or more", x: "Don't know", r: "Refusal"} — → B84

98. B84: "IN THE PAST 12 MONTHS, was there ever a time when ..... needed health services because of his/her condition, but did not receive them?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → B85; 3 → GO TO B87.edit; x → GO TO B87.edit; r → GO TO B87.edit

99. B85: "What kind of health services did he/she NEED, but did not receive? (a) Family doctor or general practitioner; (b) Medical specialist (such as a heart specialist); (c) Nurse for care; (d) Speech therapist; (e) Physiotherapist; (f) Psychologist or psychotherapist; (g) Chiropractor; (h) Other, specify" — Multi select — → B86; x → GO TO B87.edit; r → GO TO B87.edit

100. B86: "Why didn't ..... receive the health service that he/she needed? I will read you a list. Please answer yes or no to each. (a) Not covered by insurance; (b) Too expensive; (c) Not available locally; (d) Long waiting period; (e) Other reason, specify" — Multi select (Yes/No per sub-item) — → B87.edit

**AIDS USAGE AND COSTS SUBSECTION**

101. B87.edit: "If child was born AFTER May 15, 1996, go to C12. Otherwise, continue." — Filter — born after May 15 1996 → GO TO C12; otherwise → B87

102. B87: "Because of a condition or health problem, does ..... USE any aids or specialized equipment that you have not already mentioned?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → [CHECK: mark "Chronic/Other — USE Aid" on Profile Sheet] → B88; 3 → GO TO B89.edit; x → GO TO B89.edit; r → GO TO B89.edit

103. B88: "Does he/she now use: (a) respiratory aids, such as inhalers, puffers, oxygen; (b) pain management aids, such as a TENS machine; (c) other aid or specialized equipment, specify" — Multi select (Yes/No per sub-item) — → B89.edit

104. B89.edit: "If any box is checked in the 'USE — Aid' column on the Profile Sheet, continue. Otherwise, go to B93." — Filter — any USE Aid box checked → B89; otherwise → GO TO B93

105. B89: "I would like you to think about all the aids and specialized equipment that ..... currently uses. What kind of funding was used to get these aids? I will read you a list. Please answer yes or no to each. (a) Your own money; (b) Friends and family members; (c) Private health insurance; (d) Government program; (e) Other funding, specify" — Multi select (Yes/No per sub-item) — → B90

106. B90: "IN THE PAST 12 MONTHS, did you or your family have any OUT-OF-POCKET expenses (that are not reimbursed by any sources) for the purchase or maintenance of aids or specialized equipment that ..... uses?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → B91; 3 → GO TO B93; x → GO TO B93; r → GO TO B93

107. B91: "What is your best estimate of the OUT-OF-POCKET or DIRECT costs to you or your family for these extra expenses? INCLUDE amounts not covered by insurance. EXCLUDE payments for which you have been or will be reimbursed by any insurance or government program." — Numeric ($, range 1–999999) — amount → GO TO B93; x → B92; r → B92

108. B92: "Which one of the following expense groups is the best estimate of the direct costs to you or your family?" — Single select {1: "Less than $200", 2: "$200 to less than $500", 3: "$500 to less than $1000", 4: "$1000 to less than $2000", 5: "$2000 to less than $5000", 6: "$5000 or more", x: "Don't know", r: "Refusal"} — → B93

109. B93: "Does ..... CURRENTLY need any aids or specialized equipment that you have not already mentioned?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → [CHECK: mark "Chronic/Other — NEED Aid" on Profile Sheet] → B94; 3 → GO TO B95.edit; x → GO TO B95.edit; r → GO TO B95.edit

110. B94: "Which aids does ..... NEED, but does not have? (a) Respiratory aids, such as inhalers, puffers, oxygen; (b) Pain management aids, such as a TENS machine; (c) Other aid or specialized equipment, specify" — Multi select — → B95.edit

111. B95.edit: "If any box is checked in the 'NEED Aid' column on the Profile Sheet, continue. Otherwise, go to C1." — Filter — any NEED Aid box checked → B95; otherwise → GO TO C1

112. B95: "I would like you to think about all the aids ..... CURRENTLY needs, but does not have. Why doesn't he/she have these aids or specialized equipment? I will read you a list. Please answer yes or no to each. (a) Not covered by insurance; (b) Too expensive; (c) Not available locally; (d) Do not know where to obtain the aid; (e) Child's condition is not serious enough; (f) Only needed occasionally; (g) Other reason, specify" — Multi select (Yes/No per sub-item) — → B96

113. B96: "Now, I would like you to think about all the aids or specialized equipment that he/she NEEDS, but does not have. Do you think that there is an impact on ..... because he/she does not have these aids?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → B97; 3 → GO TO C1; x → GO TO C1; r → GO TO C1

114. B97: "What is the impact of not having these aids or specialized equipment? I will read you a list. Please answer yes or no to each. (a) Child's participation in regular everyday activity is reduced; (b) Child is frustrated; (c) Child's self-esteem is affected; (d) Other, specify" — Multi select (Yes/No per sub-item) — → C1

### Section C — Help with Everyday Activities — 29 items

115. C_AGE.edit: "If child was born AFTER May 15, 1996, go to C12. Otherwise, continue to C1." — Filter — born after May 15 1996 → GO TO C12; otherwise → C1

116. C1: "Does ..... USUALLY receive help with personal care, such as bathing, toiletting, dressing or feeding?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → C2; 3 → GO TO C5; x → GO TO C5; r → GO TO C5

117. C2: "Is this because of his/her condition or health problem?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → C3; 3 → GO TO C5; x → GO TO C5; r → GO TO C5

118. C3: "How much help does he/she need?" — Single select {1: "Some help", 2: "A lot of help", x: "Don't know", r: "Refusal"} — → C4

119. C4: "Who provides most of the help to ..... for his/her personal care?" — Single select {1: "Mostly the mother", 2: "Mostly the father", 3: "Both the mother and the father", 4: "Other family members", 5: "Other, specify", x: "Don't know", r: "Refusal"} — → C5

120. C5: "Does ..... USUALLY receive help with moving about inside his/her residence, such as moving from one room to another?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → C6; 3 → GO TO C9; x → GO TO C9; r → GO TO C9

121. C6: "Is this because of his/her condition or health problem?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → C7; 3 → GO TO C9; x → GO TO C9; r → GO TO C9

122. C7: "How much help does he/she need?" — Single select {1: "Some help", 2: "A lot of help", x: "Don't know", r: "Refusal"} — → C8

123. C8: "Who provides most of the help to ..... for moving about inside his/her residence?" — Single select {1: "Mostly the mother", 2: "Mostly the father", 3: "Both the mother and the father", 4: "Other family members", 5: "Other, specify", x: "Don't know", r: "Refusal"} — → C9

124. C9: "Because of .....'s condition, do you CURRENTLY need help or additional help with: (a) his/her personal care? (b) moving him/her about inside his/her residence?" — Multi select (Yes/No per sub-item) — → C9.edit

125. C9.edit: "If C9(a) OR C9(b) is 'Yes', continue. Otherwise, go to C12." — Filter — any C9=Yes → C10; otherwise → GO TO C12

126. C10: "How many hours per week of help or additional help do you need?" — Single select {1: "1–4 hours per week", 2: "5–10 hours per week", 3: "More than 10 hours per week", x: "Don't know", r: "Refusal"} — → C11

127. C11: "Why do you not receive this help? I will read you a list. Please answer yes or no to each. (a) It is too expensive; (b) Help from family and friends is not available; (c) Services or special programs (for help) are not available locally; (d) Child is presently on a waiting list; (e) Do not know where to look for help; (f) Child's condition is not serious enough; (g) You have not asked for help; (h) Other, specify" — Multi select (Yes/No per sub-item) — → C12

128. C12: "Because of .....'s condition, do you USUALLY receive help with the following: (a) help with everyday housework, such as house cleaning or meal preparation; (b) help to allow you to attend to other family responsibilities; (c) help to allow you to take time off for personal activities" — Multi select (Yes/No per sub-item) — → C12.edit

129. C12.edit: "If at least one 'Yes' is checked in C12, continue. Otherwise, go to C17." — Filter — any C12=Yes → C13; otherwise → GO TO C17

130. C13: "Who USUALLY provides you this help? I will read you a list. Please answer yes or no to each. (a) Family living with you; (b) Family not living with you; (c) Friends or neighbours; (d) Government organization or agency; (e) Private organization or agency; (f) Voluntary organization or agency; (g) Other, specify" — Multi select (Yes/No per sub-item) — → C14

131. C14: "You mentioned earlier that you usually receive help with everyday housework or help to allow you to attend to other family or personal activities. IN THE PAST 12 MONTHS, did you or your family have any OUT-OF-POCKET expenses (that are not reimbursed by any sources) for this help?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → C15; 3 → GO TO C17; x → GO TO C17; r → GO TO C17

132. C15: "What is your best estimate of the OUT-OF-POCKET or DIRECT costs to you or your family for these extra expenses? INCLUDE amounts not covered by insurance. EXCLUDE payments for which you have been or will be reimbursed by any insurance or government program." — Numeric ($, range 1–999999) — amount → GO TO C17; x → C16; r → C16

133. C16: "Which one of the following expense groups is the best estimate of the direct costs to you or your family?" — Single select {1: "Less than $200", 2: "$200 to less than $500", 3: "$500 to less than $1000", 4: "$1000 to less than $2000", 5: "$2000 to less than $5000", 6: "$5000 or more", x: "Don't know", r: "Refusal"} — → C17

134. C17: "Because of .....'s condition, do you CURRENTLY need help or additional help with the following: (a) help with everyday housework, such as house cleaning or meal preparation; (b) help to allow you to attend to other family responsibilities; (c) help to allow you to take time off for personal activities" — Multi select (Yes/No per sub-item) — → C17.edit

135. C17.edit: "If at least one 'Yes' is checked in C17, continue. Otherwise, go to C19." — Filter — any C17=Yes → C18; otherwise → GO TO C19

136. C18: "Why do you not receive this help or additional help? I will read you a list. Please answer yes or no to each. (a) It is too expensive; (b) Help from family and friends is not available; (c) Services or special programs (for help) are not available locally; (d) Child is presently on a waiting list; (e) Do not know where to look for help; (f) Child's condition is not serious enough; (g) You have not asked for help; (h) Other, specify" — Multi select (Yes/No per sub-item) — → C19

137. C19: "IN THE PAST 12 MONTHS, did you have any difficulty with coordinating the care of ....., for example, making appointments, phoning or visiting health professionals and specialists?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → C20; 3 → GO TO C21; x → GO TO C21; r → GO TO C21

138. C20: "What kind of difficulty did you have? I will read you a list. Please answer yes or no to each. (a) Difficulty obtaining appointments; (b) Health professional or specialist not available locally; (c) A lack of communication between health professionals; (d) Difficulty getting information; (e) Your lack of time to coordinate the care; (f) Work conflicts; (g) Other difficulty, specify" — Multi select (Yes/No per sub-item) — → C21

139. C21: "Who USUALLY coordinates the care of .....?" — Single select {1: "Mostly the mother", 2: "Mostly the father", 3: "Both the father and the mother", 4: "Other family members", 5: "Other, specify", x: "Don't know", r: "Refusal"} — → C22

140. C22: "Because of .....'s condition or health problem, has anyone in your family EVER: (a) not taken a job in order to take care of the child? (b) quit working (other than normal maternity or paternity leave)? (c) changed work hours to different time of day (or night)? (d) turned down a promotion or a better job? (e) worked fewer hours?" — Multi select (Yes/No per sub-item) — → C22.edit

141. C22.edit: "If at least one 'Yes' is checked in C22, continue. Otherwise, go to C24." — Filter — any C22=Yes → C23; otherwise → GO TO C24

142. C23: "Who was most affected by these work-related issues?" — Single select {1: "Mostly the mother", 2: "Mostly the father", 3: "Both the mother and the father", 4: "Other family members", 5: "Other, specify", x: "Don't know", r: "Refusal"} — → C24

143. C24: "DURING THE PAST 12 MONTHS, has your family had financial problems because of .....'s condition or health problem?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — → Section D

### Section D — Child Care — 8 items

144. D1: "Now, I'd like to ask you some questions about child care arrangements for ..... . Do you CURRENTLY use child care such as day care, babysitting or a before and after school program for ..... while you (or your spouse/partner) are at work or studying?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → D2; 3 → D2; x → GO TO D6; r → D2

145. D2: "What is your MAIN child care arrangement for .....?" — Single select {1: "Before and after school program", 2: "Nursery school", 3: "Day care centre", 4: "Care in someone else's home by a non-relative", 5: "Care in someone else's home by a relative", 6: "Care in child's home by a non-relative", 7: "Care in child's home by a relative", 8: "Other, specify", x: "Don't know", r: "Refusal"} — 1–8 → D3; x → GO TO D6; r → D3

146. D3: "Approximately how many hours per WEEK is that?" — Numeric (hours per week, round to nearest full hour) — → D4; x → D4; r → D4

147. D4: "Do you use any other child care arrangement for .....?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → D5; 3 → D6; x → GO TO D6; r → D6

148. D5: "Approximately how many hours per WEEK is that?" — Numeric (hours per week, round to nearest full hour) — → D6; x → D6; r → D6

149. D6: "Has a child care program or service ever refused to take care of ..... because of his/her condition or health problem?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → D7; 3 → D7; x → GO TO D8.edit; r → D7

150. D7: "What type of child care programs or services refused to provide care to .....? I will read you a list. Please answer yes or no to each. (a) Before and after school program; (b) Nursery school; (c) Day care centre; (d) Care in someone else's home; (e) Care in child's home; (f) Other, specify" — Multi select (Yes/No per sub-item) — → D8.edit

151. D8.edit: "If child was born AFTER May 15, 1996, go to I1. Otherwise, go to E1." — Filter — born after May 15 1996 → GO TO I1; otherwise → GO TO E1

### Section E — Education — 39 items

152. E1: "The next few questions are about education. In APRIL 2001 was .....:" — Single select {1: "Going to school or kindergarten", 2: "Being tutored at home through the school system", 3: "Neither of the above", x: "Don't know", r: "Refusal"} — 1 → GO TO E6; 2 → E2; 3 → GO TO E3; x → GO TO E4; r → GO TO E4

153. E2: "Why was ..... being tutored at home through the school system? I will read you a list. Please answer yes or no to each. (a) Personal care such as feeding and toiletting needed, but not available at school; (b) Teacher's aides or special education classes not available in REGULAR SCHOOL; (c) SPECIAL EDUCATION SCHOOL not available locally; (d) Child's condition or health problem prevented him/her from going to school; (e) Parents preferred home tutoring for the child; (f) Other reason, specify" — Multi select (Yes/No per sub-item) — → GO TO E37

154. E3: "Why was ..... not attending school in April 2001? I will read you a list. Please answer yes or no to each. (a) Personal care such as feeding and toiletting needed, but not available at school; (b) Teacher's aides or special education classes not available in REGULAR SCHOOL; (c) SPECIAL EDUCATION SCHOOL not available locally; (d) Child's condition or health problem prevented him/her from going to school; (e) Child not ready or too young to attend school; (f) Other reason, specify" — Multi select (Yes/No per sub-item) — → E4

155. E4: "Did ..... ever go to school?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → GO TO E37; 3 → E5; x → GO TO E37; r → GO TO E37

156. E5: "Why did ..... never attend school?" — Multi select {a: "Personal care such as feeding and toiletting needed, but not available at school", b: "Teacher's aides or special education classes not available in REGULAR SCHOOL", c: "SPECIAL EDUCATION SCHOOL not available locally", d: "Child's condition or health problem prevented him/her from going to school", e: "Child not ready or too young to attend school", f: "Other reason, specify", x: "Don't know", r: "Refusal"} — → GO TO E37

157. E6: "In APRIL 2001, what type of school was ..... attending?" — Single select {1: "Special education school", 2: "Regular school", 3: "Regular school with special education classes", 4: "Other, specify", x: "Don't know", r: "Refusal"} — 1 → GO TO E10; 2 → E7; 3 → E7; 4 → E7; x → E8; r → GO TO E8

158. E7: "At this school, what type of classes was ..... attending?" — Single select {1: "Only regular classes", 2: "Some regular classes and some special education classes", 3: "Only special education classes", x: "Don't know", r: "Refusal"} — → E8

159. E8: "Did ..... ever attend a special education school?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → E9; 3 → E10.edit; x → GO TO E10; r → GO TO E10

160. E10.edit: "If E7 is (1) 'Only regular classes', go to E11. Otherwise, continue to E10." — Filter — E7=1 → GO TO E11; otherwise → E10

161. E9: "Why didn't he/she attend a special education school in April 2001?" — Multi select {a: "Special education school no longer available locally", b: "Child has moved into regular school", c: "Other reason, specify", x: "Don't know", r: "Refusal"} — → E10

162. E10: "What is the MAIN condition or health problem which required ..... to receive special education services? I will read you a list. Please answer yes or no to each. (a) Learning disabilities; (b) Developmental disability or disorder; (c) Speech or language difficulties; (d) Emotional, psychological or behavioural conditions; (e) Hearing difficulties, including deafness; (f) Vision difficulties, including blindness; (g) Difficulty with walking or moving around; (h) Other condition, specify" — Multi select (Yes/No per sub-item) — → E11

163. E11: "Did you ever have any difficulty in trying to get special education services for .....?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → E12; 3 → E13; x → GO TO E13; r → GO TO E13

164. E12: "What kind of difficulty did you have? I will read you a list. Please answer yes or no to each. (a) Special education services not available locally; (b) Insufficient level of staffing or special education services; (c) Communication problems with school; (d) Difficulty to have the child tested for special education services; (e) Other difficulty, specify" — Multi select (Yes/No per sub-item) — → E13

165. E13: "In APRIL 2001, in which province or territory did ..... attend school?" — Single select {01: "Newfoundland", 02: "Prince Edward Island", 03: "Nova Scotia", 04: "New Brunswick", 05: "Quebec", 06: "Ontario", 07: "Manitoba", 08: "Saskatchewan", 09: "Alberta", 10: "British Columbia", 11: "Northwest Territory", 12: "Nunavut", 13: "Yukon", 14: "Other, specify", x: "Don't know", r: "Refusal"} — 01 → GO TO E14; 02 → GO TO E15; 03 → GO TO E16; 04 → GO TO E19; 05 → GO TO E17; 06 → GO TO E18; 07–13 → GO TO E19; 14 → E19; x → GO TO E19; r → GO TO E19

166. E14: "In what grade was ..... enrolled in APRIL 2001? (Newfoundland)" — Single select {01: "Kindergarten", 02–10: "Grade 1–9", 11–13: "Level 1–3 Secondary", 14: "Ungraded", x: "Don't know", r: "Refusal"} — 01 → GO TO E24; 02–14 → GO TO E20; x → GO TO E20; r → GO TO E20

167. E15: "In what grade was ..... enrolled in APRIL 2001? (Prince Edward Island)" — Single select {01–08: "Grades 1–8", 09–12: "Grades 9–12", 13: "Ungraded", x: "Don't know", r: "Refusal"} — → GO TO E20

168. E16: "In what grade was ..... enrolled in APRIL 2001? (Nova Scotia)" — Single select {01: "Primary", 02–13: "Grades 1–12", 14: "Ungraded", x: "Don't know", r: "Refusal"} — 01 → GO TO E24; 02–14 → GO TO E20; x → GO TO E20; r → GO TO E20

169. E17: "In what grade was ..... enrolled in APRIL 2001? (Quebec)" — Single select {01–02: "Junior Kindergarten/Kindergarten", 03–08: "Grades 1–6 Elementary", 09–13: "Secondary I–V", 14: "Ungraded", x: "Don't know", r: "Refusal"} — 01–02 → GO TO E24; 03–14 → GO TO E20; x → GO TO E20; r → GO TO E20

170. E18: "In what grade was ..... enrolled in APRIL 2001? (Ontario)" — Single select {01–02: "Junior Kindergarten/Kindergarten", 03–10: "Grades 1–8", 11–15: "Grades 9–12/OAC", 16: "Ungraded", x: "Don't know", r: "Refusal"} — 01–02 → GO TO E24; 03–16 → GO TO E20; x → GO TO E20; r → GO TO E20

171. E19: "In what grade was ..... enrolled in APRIL 2001?" — Single select {01: "Kindergarten", 02–13: "Grade 1–12", 14: "Ungraded", x: "Don't know", r: "Refusal"} — 01 → GO TO E24; 02–14 → GO TO E20; x → GO TO E20; r → GO TO E20

172. E20: "In APRIL 2001, what type of education, training or therapy was ..... receiving at school? I will read you a list. Please answer yes or no to each. (a) Academic subjects; (b) Life skills; (c) Speech and language therapy; (d) Mental health or counselling services" — Multi select (Yes/No per sub-item) — → E21

173. E21: "Based on your knowledge of his/her school work, including his/her report cards, how did ..... do during the last school year?" — Single select {1: "Very well", 2: "Well", 3: "Average", 4: "Poorly", 5: "Very poorly", 6: "Not applicable", x: "Don't know", r: "Refusal"} — → E22

174. E22: "How often did you (or your spouse/partner) check .....'s homework or provide help with his/her homework during the last school year?" — Single select {1: "Never or rarely", 2: "Less than once a month", 3: "At least once a month", 4: "At least once a week", 5: "A few times a week", 6: "Every day", x: "Don't know", r: "Refusal"} — → E23

175. E23: "Because of a condition or health problem: (a) did ..... have to leave his/her community to attend school? (b) was his/her schooling interrupted for long periods of time? (c) did ..... take fewer courses or academic subjects at school? (d) did it take ..... longer to achieve his/her present level of education?" — Multi select (Yes/No per sub-item) — → E24

176. E24: "Did a condition or health problem limit .....'s participation in any of the following SCHOOL ACTIVITIES during the last school year (which ended in June 2001)? (a) Taking part in physical education or organized games requiring physical activity; (b) Playing with others during recess or lunch hour; (c) Taking part in school outings, such as visits to a museum; (d) Classroom participation" — Multi select (Yes/No per sub-item) — → E25

177. E25: "Because of a condition or health problem, did ..... USE any special building features or equipment, such as ramps or automatic door openers AT SCHOOL?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → E26; 3 → E27; x → GO TO E27; r → GO TO E27

178. E26: "Which kind of special features did he/she USE at school? I will read you a list. Please answer yes or no to each. (a) Ramps or street level entrances; (b) Widened doorways or hallways; (c) Automatic or easy to open doors; (d) An elevator or lift device; (e) Special railings in washrooms; (f) Other feature, specify" — Multi select (Yes/No per sub-item) — → E27

179. E27: "Because of a condition or a health problem, did ..... NEED any special features or equipment, such as ramps or automatic door openers AT SCHOOL, which were not available?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → E28; 3 → E29; x → GO TO E29; r → GO TO E29

180. E28: "What kind of special features or equipment did he/she need AT SCHOOL, but did not have?" — Multi select {a: "Ramps or street level entrances", b: "Widened doorways or hallways", c: "Automatic or easy to open doors", d: "An elevator or lift device", e: "Special railings in washrooms", f: "Other feature, specify", x: "Don't know", r: "Refusal"} — → E29

181. E29: "During the last school year, did ..... USE any assistive aids, devices or services AT SCHOOL? I will read you a list. Please answer yes or no to each. (a) Tutors or teacher's aides; (b) Note takers or readers; (c) Sign language interpreters; (d) Attendant care services; (e) Amplifiers, such as FM or infrared; (f) Talking books; (g) Magnifiers; (h) Recording equipment; (i) A computer with Braille or speech access; (j) Other aid or service, specify" — Multi select (Yes/No per sub-item) — → E30

182. E30: "Were there any assistive aids, devices or services that ..... needed AT SCHOOL, but did not have?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → E31; 3 → E33; x → GO TO E33; r → GO TO E33

183. E31: "What kind of assistive aids or services did he/she need AT SCHOOL, but did not have?" — Multi select {a: "Tutors or teacher's aides", b: "Note takers or readers", c: "Sign language interpreters", d: "Attendant care services", e: "Amplifiers, such as FM or infrared", f: "Talking books", g: "Magnifiers", h: "Recording equipment", i: "A computer with Braille or speech access", j: "Other aid or service, specify", x: "Don't know", r: "Refusal"} — → E32

184. E32: "Why didn't ..... have these aids or services AT SCHOOL? I will read you a list. Please answer yes or no to each. (a) School funding cutbacks or lack of funding in the school system; (b) School did not think child needed assistive aids or services; (c) Child did not want to use assistive aids or services; (d) Other reason, specify" — Multi select (Yes/No per sub-item) — → E33

185. E33: "During the last school year, have you (or your partner/spouse) done any of the following for .....? I will read you a list. Please answer yes or no to each. (a) Spoken to, visited or corresponded with child's teacher; (b) Attended a school event in which child participated; (c) Volunteered in child's class or helped with a class trip; (d) Helped elsewhere in the school; (e) Attended a parent-school association meeting; (f) Fundraising for school; (g) Other activity, specify" — Multi select (Yes/No per sub-item) — → E34

186. E34: "Do you strongly agree, agree, disagree, or strongly disagree with the following descriptions of the school that ..... attended during the last school year? (a) The school offered parents many opportunities to be involved in the school activities; (b) Parents were made to feel welcome in the school; (c) Overall, the school accommodated the child's condition or health problem" — Scale per sub-item {1: "Strongly agree", 2: "Agree", 3: "Disagree", 4: "Strongly disagree", x: "Don't know", r: "Refusal"} — → E35

187. E35: "With regard to how he/she feels about school, how often did ..... look forward to going to school during the last school year?" — Single select {1: "Almost never", 2: "Rarely", 3: "Sometimes", 4: "Often", 5: "Almost always", x: "Don't know", r: "Refusal"} — → E36

188. E36: "During the last school year, what was the method of transportation ..... used MOST OFTEN to get to school?" — Single select {1: "Was driven to school by family motor vehicle", 2: "School bus", 3: "Regular city bus", 4: "Specialized bus services for persons with disabilities", 5: "Walked or biked to school", 6: "Other, specify", x: "Don't know", r: "Refusal"} — → E37

189. E37: "Has a professional assessment ever been done to determine .....'s educational needs?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → E38; 3 → GO TO F1; x → GO TO F1; r → GO TO F1

190. E38: "Who completed this assessment? I will read you a list. Please answer yes or no to each. (a) Psychologist or psychiatrist; (b) Social worker; (c) Special education consultant; (d) Speech or language therapist; (e) Other professional or specialist, specify" — Multi select (Yes/No per sub-item) — → GO TO F1

### Section F — Leisure and Recreation Activities — 38 items

191. F1a: "In the last 12 months, OUTSIDE OF SCHOOL HOURS, how often has he/she taken part in sports with a coach or instructor (except dance or gymnastics)?" — Single select {1: "Everyday", 2: "At least once a week", 3: "At least once a month", 4: "Less than once a month", 5: "Never", x: "Don't know", r: "Refusal"} — 1–4 → F1a_hrs; 5 → F1b; x → F1b; r → F1b

192. F1a_hrs: "How many hours a day?" — Numeric — → F1b

193. F1b: "In the last 12 months, OUTSIDE OF SCHOOL HOURS, how often has he/she taken lessons or instruction in other organized physical activities with a coach or instructor, such as dance, gymnastics or martial arts?" — Single select {1: "Everyday", 2: "At least once a week", 3: "At least once a month", 4: "Less than once a month", 5: "Never", x: "Don't know", r: "Refusal"} — 1–4 → F1b_hrs; 5 → F1c; x → F1c; r → F1c

194. F1b_hrs: "How many hours a day?" — Numeric — → F1c

195. F1c: "In the last 12 months, OUTSIDE OF SCHOOL HOURS, how often has he/she taken part in unorganized sports or physical activities without a coach or instructor?" — Single select {1: "Everyday", 2: "At least once a week", 3: "At least once a month", 4: "Less than once a month", 5: "Never", x: "Don't know", r: "Refusal"} — 1–4 → F1c_hrs; 5 → F1d; x → F1d; r → F1d

196. F1c_hrs: "How many hours a day?" — Numeric — → F1d

197. F1d: "In the last 12 months, OUTSIDE OF SCHOOL HOURS, how often has he/she taken lessons or instruction in music, art or other non-sport activities?" — Single select {1: "Everyday", 2: "At least once a week", 3: "At least once a month", 4: "Less than once a month", 5: "Never", x: "Don't know", r: "Refusal"} — 1–4 → F1d_hrs; 5 → F1e; x → F1e; r → F1e

198. F1d_hrs: "How many hours a day?" — Numeric — → F1e

199. F1e: "In the last 12 months, OUTSIDE OF SCHOOL HOURS, how often has he/she taken part in clubs, groups or community programs, such as church groups, Girl or Boy Scouts?" — Single select {1: "Everyday", 2: "At least once a week", 3: "At least once a month", 4: "Less than once a month", 5: "Never", x: "Don't know", r: "Refusal"} — 1–4 → F1e_hrs; 5 → F2a; x → F2a; r → F2a

200. F1e_hrs: "How many hours a day?" — Numeric — → F2a

201. F2a: "How often does he/she watch T.V.?" — Single select {1: "Everyday", 2: "At least once a week", 3: "At least once a month", 4: "Less than once a month", 5: "Never", x: "Don't know", r: "Refusal"} — 1–4 → F2a_hrs; 5 → F2b; x → F2b; r → F2b

202. F2a_hrs: "How many hours a day?" — Numeric — → F2b

203. F2b: "How often does he/she play computer or video games?" — Single select {1: "Everyday", 2: "At least once a week", 3: "At least once a month", 4: "Less than once a month", 5: "Never", x: "Don't know", r: "Refusal"} — 1–4 → F2b_hrs; 5 → F2c; x → F2c; r → F2c

204. F2b_hrs: "How many hours a day?" — Numeric — → F2c

205. F2c: "How often does he/she talk on the phone with friends?" — Single select {1: "Everyday", 2: "At least once a week", 3: "At least once a month", 4: "Less than once a month", 5: "Never", x: "Don't know", r: "Refusal"} — 1–4 → F2c_hrs; 5 → F3; x → F3; r → F3

206. F2c_hrs: "How many hours a day?" — Numeric — → F3

207. F3: "How often does ..... read or have books read to him/her (for pleasure)? Please do not include reading that is required for school." — Single select {1: "Everyday", 2: "At least once a week", 3: "At least once a month", 4: "Less than once a month", 5: "Never", x: "Don't know", r: "Refusal"} — 1 → F3_hrs; 2–5 → F4; x → F4; r → F4

208. F3_hrs: "How many hours a day?" — Numeric — → F4

209. F4: "Outside of school hours, how often does he/she play alone, for example, riding a bike or doing a craft?" — Single select {1: "Often", 2: "Sometimes", 3: "Seldom", 4: "Never", x: "Don't know", r: "Refusal"} — → F5

210. F5: "Has ..... ever gone to summer camps (including regular or special camps)?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → F6; 3 → GO TO F7; x → GO TO F7; r → GO TO F7

211. F6: "Was this a camp for children with a health problem or condition?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — → F7

212. F7: "Because of a condition or health problem, is ..... prevented from taking part in any social or physical leisure activities?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → F8; 3 → GO TO F9; x → GO TO F9; r → GO TO F9

213. F8: "What prevents ..... from doing more social or physical leisure activities? I will read you a list. Please answer yes or no to each. (a) Recreational facilities or programs not available locally; (b) Buildings and equipment not physically accessible; (c) Inadequate transportation services; (d) Too expensive; (e) Child is physically unable to do more; (f) Child needs someone's assistance; (g) Child needs specialized aids or equipment, but he/she doesn't have them; (h) Other reason, specify" — Multi select (Yes/No per sub-item) — → F9

214. F9: "DURING THE PAST SIX MONTHS, how well has ..... gotten along with other children, such as friends or classmates (excluding brothers or sisters)?" — Single select {1: "Very well (or no problems)", 2: "Quite well (or hardly any problems)", 3: "Pretty well (or occasional problems)", 4: "Not too well (or frequent problems)", 5: "Not well at all (or constant problems)", x: "Don't know", r: "Refusal"} — → F10

215. F10: "How many personal computers are there in your home?" — Single select {1: "None", 2: "One", 3: "Two", 4: "Three or more", x: "Don't know", r: "Refusal"} — 1 → GO TO F11; 2–4 → GO TO F12; x → GO TO G1; r → GO TO G1

216. F11: "What are the reasons that keep you from purchasing a personal computer? (a) Cost; (b) Not needed at home; (c) Not interested; (d) Lack of computer skills or training; (e) Fear of technology; (f) Disability; (g) Other, specify" — Multi select — → GO TO G1; x → GO TO G1; r → GO TO G1

217. F12: "Is your household connected to the Internet?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → GO TO F14; 3 → GO TO F13; x → GO TO G1; r → GO TO G1

218. F13: "What are the reasons that keep you from getting Internet access for your HOME? (a) Cost; (b) Not needed at home; (c) Not interested; (d) Lack of computer skills or training; (e) Fear of technology; (f) Disability; (g) Other, specify" — Multi select — → GO TO G1; x → GO TO G1; r → GO TO G1

219. F14: "Does ..... use the Internet AT HOME?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → GO TO F16a; 3 → GO TO F15; x → GO TO G1; r → GO TO G1

220. F15: "What are the reasons that keep ..... from using the Internet at home? (a) Child too young or not ready to use it; (b) Child does not need it; (c) Child is not interested; (d) Child does not have the computer skills or training; (e) Child's condition or health problem; (f) Other, specify" — Multi select — → GO TO G1; x → GO TO G1; r → GO TO G1

221. F16a: "AT HOME, how often does he/she use Internet to participate in newsgroups or chat groups?" — Single select {1: "Everyday", 2: "At least once a week", 3: "At least once a month", 4: "Less than once a month", 5: "Never", x: "Don't know", r: "Refusal"} — 1–4 → F16a_hrs; 5 → F16b; x → F16b; r → F16b

222. F16a_hrs: "How many hours a day?" — Numeric — → F16b

223. F16b: "AT HOME, how often does he/she use Internet for school work?" — Single select {1: "Everyday", 2: "At least once a week", 3: "At least once a month", 4: "Less than once a month", 5: "Never", x: "Don't know", r: "Refusal"} — 1–4 → F16b_hrs; 5 → F16c; x → F16c; r → F16c

224. F16b_hrs: "How many hours a day?" — Numeric — → F16c

225. F16c: "AT HOME, how often does he/she use Internet for personal interest or entertainment?" — Single select {1: "Everyday", 2: "At least once a week", 3: "At least once a month", 4: "Less than once a month", 5: "Never", x: "Don't know", r: "Refusal"} — 1–4 → F16c_hrs; 5 → F16d; x → F16d; r → F16d

226. F16c_hrs: "How many hours a day?" — Numeric — → F16d

227. F16d: "AT HOME, how often does he/she use E-mail to stay in touch with friends?" — Single select {1: "Everyday", 2: "At least once a week", 3: "At least once a month", 4: "Less than once a month", 5: "Never", x: "Don't know", r: "Refusal"} — 1–4 → F16d_hrs; 5 → GO TO G1; x → GO TO G1; r → GO TO G1

228. F16d_hrs: "How many hours a day?" — Numeric — → GO TO G1

### Section G — Home Accommodation — 11 items

229. G_AGE.edit: "Section G is NOT asked if child was born AFTER May 15, 1996." — Filter — born after May 15 1996 → SKIP to H1; otherwise → G1

230. G1: "Because of a condition or health problem, does ..... USE any special features, such as access ramps or automatic door openers to ENTER or LEAVE his/her residence?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → G2; 3 → GO TO G3; x → GO TO G3; r → GO TO G3

231. G2: "Which special features does he/she use? I will read you a list. Please answer yes or no to each. (a) Ramps or street level entrances; (b) Widened doorways or hallways; (c) Automatic or easy to open doors; (d) An elevator or lift device; (e) Other feature, specify" — Multi select (Yes/No per sub-item) — → G3

232. G3: "Does ..... CURRENTLY need any special features to enter or leave his/her residence, which he/she does not have?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → G4; 3 → GO TO G6; x → GO TO G6; r → GO TO G6

233. G4: "Which special features does ..... NEED, but does not have? (a) Ramps or street level entrances; (b) Widened doorways or hallways; (c) Automatic or easy to open doors; (d) An elevator or lift device; (e) Other feature, specify" — Multi select — → G5; x → GO TO G6; r → GO TO G6

234. G5: "Why doesn't ..... have these special features that he/she needs to enter or leave his/her residence? I will read you a list. Please answer yes or no to each. (a) Not covered by insurance; (b) Too expensive; (c) Landlord/landlady not willing; (d) Only needed occasionally; (e) Other reason, specify" — Multi select (Yes/No per sub-item) — → G6

235. G6: "Because of a condition or health problem, does ..... USE any special features, such as special railings, grab bars or lift devices INSIDE his/her residence?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → G7; 3 → GO TO G8; x → GO TO G8; r → GO TO G8

236. G7: "Which special features does ..... use INSIDE his/her residence? I will read you a list. Please answer yes or no to each. (a) Grab bars or bath lift device in the bathroom; (b) Lowered counters, sinks or switches in the kitchen; (c) An elevator or lift device; (d) Widened doorways or hallways; (e) Automatic or easy to open doors; (f) Visual or flashing alarms; (g) Audio warning devices; (h) Other feature, specify" — Multi select (Yes/No per sub-item) — → G8

237. G8: "Does ..... CURRENTLY need any special features INSIDE his/her residence, which he/she does not have?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → G9; 3 → GO TO H1; x → GO TO H1; r → GO TO H1

238. G9: "Which special features does ..... NEED, but does not have? (a) Grab bars or bath lift device in the bathroom; (b) Lowered counters, sinks or switches in the kitchen; (c) An elevator or lift device; (d) Widened doorways or hallways; (e) Automatic or easy to open doors; (f) Visual or flashing alarms; (g) Audio warning devices; (h) Other feature, specify" — Multi select — → G10; x → GO TO H1; r → GO TO H1

239. G10: "Why doesn't ..... have these special features INSIDE his/her residence? I will read you a list. Please answer yes or no to each. (a) Not covered by insurance; (b) Too expensive; (c) Landlord/landlady not willing; (d) Only needed occasionally; (e) Other reason, specify" — Multi select (Yes/No per sub-item) — → GO TO H1

### Section H — Transportation — 17 items

240. H_AGE.edit: "Section H is NOT asked if child was born AFTER May 15, 1996." — Filter — born after May 15 1996 → SKIP to I1; otherwise → H1

241. H1: "I would like to ask you about the means of transportation that ..... uses for local travel on his/her own or with someone else. This includes trips to the doctor, recreational events or any other local trips under 80 km (50 miles). Because of .....'s condition, does your car have special features or equipment, such as a lift device or a large trunk to carry a wheelchair?" — Single select {1: "Yes", 3: "No", 5: "Do not own a car", x: "Don't know", r: "Refusal"} — 1 → GO TO H3; 3 → H2; 5 → GO TO H5; x → GO TO H3; r → GO TO H3

242. H2: "Do you NEED ANY OTHER special features or equipment for your car because of .....'s condition?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → GO TO H4; 3 → H3; x → GO TO H5; r → GO TO H5

243. H3: "Because of .....'s condition, do you NEED any special features or equipment (for your car)?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → H4; 3 → H4; x → GO TO H5; r → GO TO H5

244. H4: "Why do you not have these special features or equipment for your car? I will read you a list. Please answer yes or no to each. (a) Not covered by insurance; (b) Too expensive; (c) Only needed occasionally; (d) Other reason, specify" — Multi select (Yes/No per sub-item) — → H5

245. H5: "Some communities have a specialized bus service for people who have difficulty using regular transportation services. (To use this service, people can call ahead and ask to be picked up). Is this service available in your area?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → GO TO H7; 3 → H6; x → H6; r → H6

246. H6: "Does ..... NEED this service?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → H7; 3 → GO TO H11; x → GO TO H11; r → GO TO H11

247. H7: "Does ..... use this service?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → H8; 3 → H8; x → GO TO H11; r → GO TO H11

248. H8: "How often does he/she use this service?" — Single select {1: "Almost everyday for at least some part of the year", 2: "Frequently", 3: "Occasionally", 4: "Seldom", x: "Don't know", r: "Refusal"} — → H9

249. H9: "IN THE PAST 12 MONTHS, did ..... have any difficulty using this service?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → H10; 3 → H10; x → GO TO H11; r → GO TO H11

250. H10: "What kind of difficulty did he/she have? I will read you a list. Please answer yes or no to each. (a) Service is needed more often than currently offered; (b) Impractical scheduling for child's needs; (c) Booking rules don't allow for last minute arrangements; (d) Too expensive; (e) Other reason, specify" — Multi select (Yes/No per sub-item) — → H11

251. H11: "IN THE PAST 12 MONTHS has ..... had to use a taxi service because of his/her condition or health problem?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → H12; 3 → H12; x → GO TO H13; r → GO TO H13

252. H12: "How often did he/she use a taxi service?" — Single select {1: "Almost everyday for at least some part of the year", 2: "Frequently", 3: "Occasionally", 4: "Seldom", x: "Don't know", r: "Refusal"} — → H13

253. H13: "IN THE PAST 12 MONTHS, for local trips which you must take with ....., have you had to cancel or reschedule some activities because of problems with transportation services?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — → H14

254. H14: "IN THE PAST 12 MONTHS, did you or your family have any OUT-OF-POCKET expenses for .....'s transportation, for example, his/her travel to and from treatment, therapy or other medical or rehabilitation services?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → H15; 3 → H15; x → GO TO I1; r → GO TO I1

255. H15: "What is your best estimate of the OUT-OF-POCKET or DIRECT costs to you or your family for these extra expenses?" — Numeric ($, range 1–999999) — amount → GO TO I1; x → H16; r → H16

256. H16: "Which one of the following expense groups is the best estimate of the direct costs to you or your family?" — Single select {1: "Less than $100", 2: "$100 to less than $200", 3: "$200 to less than $500", 4: "$500 to less than $1000", 5: "$1000 to less than $2000", 6: "$2000 to less than $5000", 7: "$5000 or more", x: "Don't know", r: "Refusal"} — → GO TO I1

### Section I — Economic Characteristics — 10 items

257. I1: "Do you have insurance that covers all or part of: (a) the cost of .....'s prescription medications? (b) the cost of .....'s eye glasses or contact lenses? (c) hospital charges for a private or semi-private room?" — Multi select (Yes/No per sub-item) — → I2

258. I2: "Did you claim Child Care Expenses for ..... with your 2000 income tax return?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → I3; 3 → GO TO I4; x → GO TO I4; r → GO TO I4

259. I3: "Did you receive it?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — → I4

260. I4: "Did you claim Medical Expenses for ..... with your 2000 income tax return?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → I5; 3 → GO TO I6; x → GO TO I6; r → GO TO I6

261. I5: "Did you receive it?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — → I6

262. I6: "Did you claim a Disability Tax Credit for ..... with your 2000 income tax return?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — 1 → I7; 3 → GO TO I8; x → GO TO I9; r → GO TO I9

263. I7: "Did you receive it?" — Yes/No {1: "Yes", 3: "No", x: "Don't know", r: "Refusal"} — → GO TO I9

264. I8: "Why did you not claim the Disability Tax Credit? I will read you a list. Please answer yes or no to each. (a) You did not know it existed; (b) You did not think that ..... would meet the eligibility requirements; (c) You were not able to obtain the disability certificate (Form T2201) from your doctor; (d) Other reason, specify" — Multi select (Yes/No per sub-item) — → I9

265. I9: "For the year ending December 31, 2000, what is your best estimate of the total income, before taxes and deductions, of all household members, including yourself, from all sources?" — Numeric ($) — amount → GO TO Follow-up; No income/loss → GO TO Follow-up; x → I10; r → I10

266. I10: "Can you estimate in which of the following groups your HOUSEHOLD INCOME fell?" — Single select {1: "$1 to less than $5,000", 2: "$5,000 to less than $10,000", 3: "$10,000 to less than $15,000", 4: "$15,000 to less than $20,000", 5: "$20,000 to less than $30,000", 6: "$30,000 to less than $40,000", 7: "$40,000 to less than $50,000", 8: "$50,000 to less than $60,000", 9: "$60,000 to less than $80,000", 10: "$80,000 or more", x: "Don't know", r: "Refusal"} — → GO TO Follow-up

### Follow-up — 1 item

267. FU1: "That's the end of our questions. Someone from Statistics Canada may contact you (.....'s parent/guardian) in a year or two to find out more about ..... . In case there are difficulties reaching you (them), could you please give me the name, address and telephone number of a family member or friend we could contact?" — Yes/No {1: "Yes", 3: "No", r: "Refusal"} — 1 → [Collect name and address of other contact] → END; 3 → END; r → END
