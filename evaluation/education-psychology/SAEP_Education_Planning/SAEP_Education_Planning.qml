qmlVersion: '2.7'
questionnaire:
  title: Survey of Approaches to Educational Planning
  blocks:
  - id: b_s1_preamble
    title: Interview setup
    items:
    - id: Final_Status
      kind: Question
      title: Final Status of Interview
      external: true
      input:
        control: Radio
        labels:
          1: Fully completed
          2: Unable to contact
          3: Partially completed
          4: Other non-response
          5: Refused
    - id: Language
      kind: Question
      title: Language
      external: true
      input:
        control: Radio
        labels:
          1: 01 — English
  - id: b_s1_intro
    title: INTRODUCTION / Section A
    items:
    - id: A1
      kind: Question
      title: How many children 18 years of age or younger usually live at this dwelling? This includes children who usually live here but are now away at school, in the hospital or somewhere else.
      input:
        control: Editbox
        min: 0
        max: 99
    - id: A2
      kind: Question
      title: I would like to speak to the person who is the most knowledgeable about these children and about any plans made for their post-secondary education. Would this person be you?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
  - id: b_s1_pmk
    title: Person Most Knowledgeable
    precondition:
    - predicate: A2.outcome == 2
      hint: Asked only when question A2 is "No".
    - predicate: not (A2.outcome == 1)
      hint: Asked only when question A2 is not "Yes".
    items:
    - id: PMK_First_Name
      kind: Question
      title: Person Most Knowledgeable - First Name (Ask who would be the right person, fill in the fields below and schedule an interview with this person.)
      input:
        control: Textarea
    - id: PMK_Last_Name
      kind: Question
      title: Person Most Knowledgeable - Last Name
      input:
        control: Textarea
    - id: PMK_Age
      kind: Question
      title: Person Most Knowledgeable - Age
      input:
        control: Editbox
        min: 0
        max: 120
    - id: PMK_Sex
      kind: Question
      title: Person Most Knowledgeable - Sex
      input:
        control: Radio
        labels:
          1: Male
          2: Female
  - id: b_s1_check
    title: Interviewer check
    items:
    - id: A3
      kind: Question
      title: 'Interviewer Check Item: 1) If there are 01-03 children in A1, go to CHILD 1, CHILD 2 and CHILD 3 and fill in appropriate name, age and sex. Then go to SECTION B (CHILD 1) and start interview. 2) If there are 04 or more children in A1: fill in name, sex and age of each child 18 years of age or younger and use selection grid on label to choose 3 children; mark the 3 selected children with an X; go to CHILD 1, CHILD 2 and CHILD 3 and fill in appropriate name, age and sex for each selected child. Then go to SECTION B (CHILD 1) and start interview.'
      precondition:
      - predicate: not (A2.outcome == 2)
        hint: Asked only when question A2 is not "No".
      input:
        control: Radio
        labels:
          1: 01-03 children in A1
          2: 04 or more children in A1
  - id: b_s1_sel_1_4
    title: Children's information for selection (1-4)
    precondition:
    - predicate: A1.outcome >= 4
      hint: Asked only when there are 4 or more children.
    - predicate: not (A2.outcome == 2)
      hint: Asked only when question A2 is not "No".
    - predicate: not (A1.outcome >= 1 and A1.outcome <= 3)
      hint: Asked only when there are not 1 to 3 children.
    items:
    - id: Selection_1_Selected
      kind: Question
      title: 'CHILDREN''S INFORMATION FOR SELECTION, # 1 - Selected = X'
      input:
        control: Radio
        labels:
          1: X — Selected
    - id: Selection_1_First_Name
      kind: Question
      title: 'CHILDREN''S INFORMATION FOR SELECTION, # 1 - First Name'
      input:
        control: Textarea
    - id: Selection_1_Sex
      kind: Question
      title: 'CHILDREN''S INFORMATION FOR SELECTION, # 1 - Sex'
      input:
        control: Radio
        labels:
          1: Male
          2: Female
    - id: Selection_1_Age
      kind: Question
      title: 'CHILDREN''S INFORMATION FOR SELECTION, # 1 - Age'
      input:
        control: Editbox
        min: 0
        max: 18
    - id: Selection_2_Selected
      kind: Question
      title: 'CHILDREN''S INFORMATION FOR SELECTION, # 2 - Selected = X'
      input:
        control: Radio
        labels:
          1: X — Selected
    - id: Selection_2_First_Name
      kind: Question
      title: 'CHILDREN''S INFORMATION FOR SELECTION, # 2 - First Name'
      input:
        control: Textarea
    - id: Selection_2_Sex
      kind: Question
      title: 'CHILDREN''S INFORMATION FOR SELECTION, # 2 - Sex'
      input:
        control: Radio
        labels:
          1: Male
          2: Female
    - id: Selection_2_Age
      kind: Question
      title: 'CHILDREN''S INFORMATION FOR SELECTION, # 2 - Age'
      input:
        control: Editbox
        min: 0
        max: 18
    - id: Selection_3_Selected
      kind: Question
      title: 'CHILDREN''S INFORMATION FOR SELECTION, # 3 - Selected = X'
      input:
        control: Radio
        labels:
          1: X — Selected
    - id: Selection_3_First_Name
      kind: Question
      title: 'CHILDREN''S INFORMATION FOR SELECTION, # 3 - First Name'
      input:
        control: Textarea
    - id: Selection_3_Sex
      kind: Question
      title: 'CHILDREN''S INFORMATION FOR SELECTION, # 3 - Sex'
      input:
        control: Radio
        labels:
          1: Male
          2: Female
    - id: Selection_3_Age
      kind: Question
      title: 'CHILDREN''S INFORMATION FOR SELECTION, # 3 - Age'
      input:
        control: Editbox
        min: 0
        max: 18
    - id: Selection_4_Selected
      kind: Question
      title: 'CHILDREN''S INFORMATION FOR SELECTION, # 4 - Selected = X'
      input:
        control: Radio
        labels:
          1: X — Selected
    - id: Selection_4_First_Name
      kind: Question
      title: 'CHILDREN''S INFORMATION FOR SELECTION, # 4 - First Name'
      input:
        control: Textarea
    - id: Selection_4_Sex
      kind: Question
      title: 'CHILDREN''S INFORMATION FOR SELECTION, # 4 - Sex'
      input:
        control: Radio
        labels:
          1: Male
          2: Female
    - id: Selection_4_Age
      kind: Question
      title: 'CHILDREN''S INFORMATION FOR SELECTION, # 4 - Age'
      input:
        control: Editbox
        min: 0
        max: 18
  - id: b_s1_sel_5
    title: Children's information for selection (5)
    precondition:
    - predicate: A1.outcome >= 5
      hint: Asked only when there are 5 or more children.
    - predicate: not (A2.outcome == 2)
      hint: Asked only when question A2 is not "No".
    - predicate: not (A1.outcome >= 1 and A1.outcome <= 3)
      hint: Asked only when there are not 1 to 3 children.
    items:
    - id: Selection_5_Selected
      kind: Question
      title: 'CHILDREN''S INFORMATION FOR SELECTION, # 5 - Selected = X'
      input:
        control: Radio
        labels:
          1: X — Selected
    - id: Selection_5_First_Name
      kind: Question
      title: 'CHILDREN''S INFORMATION FOR SELECTION, # 5 - First Name'
      input:
        control: Textarea
    - id: Selection_5_Sex
      kind: Question
      title: 'CHILDREN''S INFORMATION FOR SELECTION, # 5 - Sex'
      input:
        control: Radio
        labels:
          1: Male
          2: Female
    - id: Selection_5_Age
      kind: Question
      title: 'CHILDREN''S INFORMATION FOR SELECTION, # 5 - Age'
      input:
        control: Editbox
        min: 0
        max: 18
  - id: b_s1_sel_6
    title: Children's information for selection (6)
    precondition:
    - predicate: A1.outcome >= 6
      hint: Asked only when there are 6 or more children.
    - predicate: not (A2.outcome == 2)
      hint: Asked only when question A2 is not "No".
    - predicate: not (A1.outcome >= 1 and A1.outcome <= 3)
      hint: Asked only when there are not 1 to 3 children.
    items:
    - id: Selection_6_Selected
      kind: Question
      title: 'CHILDREN''S INFORMATION FOR SELECTION, # 6 - Selected = X'
      input:
        control: Radio
        labels:
          1: X — Selected
    - id: Selection_6_First_Name
      kind: Question
      title: 'CHILDREN''S INFORMATION FOR SELECTION, # 6 - First Name'
      input:
        control: Textarea
    - id: Selection_6_Sex
      kind: Question
      title: 'CHILDREN''S INFORMATION FOR SELECTION, # 6 - Sex'
      input:
        control: Radio
        labels:
          1: Male
          2: Female
    - id: Selection_6_Age
      kind: Question
      title: 'CHILDREN''S INFORMATION FOR SELECTION, # 6 - Age'
      input:
        control: Editbox
        min: 0
        max: 18
  - id: b_s1_sel_7
    title: Children's information for selection (7)
    precondition:
    - predicate: A1.outcome >= 7
      hint: Asked only when there are 7 or more children.
    - predicate: not (A2.outcome == 2)
      hint: Asked only when question A2 is not "No".
    - predicate: not (A1.outcome >= 1 and A1.outcome <= 3)
      hint: Asked only when there are not 1 to 3 children.
    items:
    - id: Selection_7_Selected
      kind: Question
      title: 'CHILDREN''S INFORMATION FOR SELECTION, # 7 - Selected = X'
      input:
        control: Radio
        labels:
          1: X — Selected
    - id: Selection_7_First_Name
      kind: Question
      title: 'CHILDREN''S INFORMATION FOR SELECTION, # 7 - First Name'
      input:
        control: Textarea
    - id: Selection_7_Sex
      kind: Question
      title: 'CHILDREN''S INFORMATION FOR SELECTION, # 7 - Sex'
      input:
        control: Radio
        labels:
          1: Male
          2: Female
    - id: Selection_7_Age
      kind: Question
      title: 'CHILDREN''S INFORMATION FOR SELECTION, # 7 - Age'
      input:
        control: Editbox
        min: 0
        max: 18
  - id: b_s1_sel_8
    title: Children's information for selection (8)
    precondition:
    - predicate: A1.outcome >= 8
      hint: Asked only when there are 8 or more children.
    - predicate: not (A2.outcome == 2)
      hint: Asked only when question A2 is not "No".
    - predicate: not (A1.outcome >= 1 and A1.outcome <= 3)
      hint: Asked only when there are not 1 to 3 children.
    items:
    - id: Selection_8_Selected
      kind: Question
      title: 'CHILDREN''S INFORMATION FOR SELECTION, # 8 - Selected = X'
      input:
        control: Radio
        labels:
          1: X — Selected
    - id: Selection_8_First_Name
      kind: Question
      title: 'CHILDREN''S INFORMATION FOR SELECTION, # 8 - First Name'
      input:
        control: Textarea
    - id: Selection_8_Sex
      kind: Question
      title: 'CHILDREN''S INFORMATION FOR SELECTION, # 8 - Sex'
      input:
        control: Radio
        labels:
          1: Male
          2: Female
    - id: Selection_8_Age
      kind: Question
      title: 'CHILDREN''S INFORMATION FOR SELECTION, # 8 - Age'
      input:
        control: Editbox
        min: 0
        max: 18
  - id: b_s1_sel_9
    title: Children's information for selection (9)
    precondition:
    - predicate: A1.outcome >= 9
      hint: Asked only when there are 9 or more children.
    - predicate: not (A2.outcome == 2)
      hint: Asked only when question A2 is not "No".
    - predicate: not (A1.outcome >= 1 and A1.outcome <= 3)
      hint: Asked only when there are not 1 to 3 children.
    items:
    - id: Selection_9_Selected
      kind: Question
      title: 'CHILDREN''S INFORMATION FOR SELECTION, # 9 - Selected = X'
      input:
        control: Radio
        labels:
          1: X — Selected
    - id: Selection_9_First_Name
      kind: Question
      title: 'CHILDREN''S INFORMATION FOR SELECTION, # 9 - First Name'
      input:
        control: Textarea
    - id: Selection_9_Sex
      kind: Question
      title: 'CHILDREN''S INFORMATION FOR SELECTION, # 9 - Sex'
      input:
        control: Radio
        labels:
          1: Male
          2: Female
    - id: Selection_9_Age
      kind: Question
      title: 'CHILDREN''S INFORMATION FOR SELECTION, # 9 - Age'
      input:
        control: Editbox
        min: 0
        max: 18
  - id: b_s2_p1_child
    title: SECTION B - Child 1
    precondition:
    - predicate: not (A2.outcome == 2)
      hint: Asked only when question A2 is not "No".
    items:
    - id: CHILD_1_First_Name
      kind: Question
      title: CHILD 1 First Name
      input:
        control: Textarea
    - id: CHILD_1_Sex
      kind: Question
      title: CHILD 1 Sex
      input:
        control: Radio
        labels:
          1: Male
          2: Female
    - id: CHILD_1_Age
      kind: Question
      title: CHILD 1 Age (in years) If age is less than 1 year, enter 00.
      input:
        control: Editbox
        min: 0
        max: 18
    - id: B1
      kind: Question
      title: Now I am going to ask you some questions about ... (name of CHILD 1). What is …’s relationship to you?
      input:
        control: Radio
        labels:
          1: Son/daughter (biological, adoptive, stepchild)
          2: Foster child
          3: Grandchild
          4: Brother/sister
          5: Other family member or relative
          6: Unrelated
    - id: B2
      kind: Question
      title: Does … have any long-term conditions or health problems which prevent or limit his/her participation in school, at play, or in any other activity for a child of his/her age?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
    - id: B3
      kind: Question
      title: How far do ... ‘s parents/guardians hope that he/she will go in school?
      input:
        control: Radio
        labels:
          1: Primary school
          2: Secondary or high school
          3: Community college, technical college or CEGEP
          4: University
          5: Learn a trade
          7: Don’t know
          8: Refused
    - id: B4
      kind: Question
      title: 'Interviewer Check Item: 1 If age is 00-04, go to B20 (page 11); 2 If age is 05-08, go to B6; 3 If age is 09 or more, go to B5'
      input:
        control: Radio
        labels:
          1: Age is 00-04
          2: Age is 05-08
          3: Age is 09 or more
  - id: b_s2_p1_b5
    title: Parental expectations
    precondition:
    - predicate: not (A2.outcome == 2)
      hint: Asked only when question A2 is not "No".
    items:
    - id: B5
      kind: Question
      title: How far do ... ‘s parents/guardians expect that he/she will go in school?
      precondition:
      - predicate: CHILD_1_Age.outcome >= 9
        hint: Asked only for children aged 9 or more.
      - predicate: not (CHILD_1_Age.outcome <= 4)
        hint: Not asked for ages 00-04.
      - predicate: not (CHILD_1_Age.outcome >= 5 and CHILD_1_Age.outcome <= 8)
        hint: Not asked for ages 05-08.
      input:
        control: Radio
        labels:
          1: Primary school
          2: Secondary or high school
          3: Community college, technical college or CEGEP
          4: University
          5: Learn a trade
          7: Don’t know
          8: Refused
  - id: b_s2_p1_b6
    title: School attendance last year
    precondition:
    - predicate: not (A2.outcome == 2)
      hint: Asked only when question A2 is not "No".
    items:
    - id: B6
      kind: Question
      title: Did … attend school last year? (include home schooling)
      precondition:
      - predicate: CHILD_1_Age.outcome >= 5
        hint: Asked only for children aged 5 or more.
      - predicate: not (CHILD_1_Age.outcome <= 4)
        hint: Not asked for ages 00-04.
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
  - id: b_s2_p1_b7
    title: Reason for not attending
    precondition:
    - predicate: not (A2.outcome == 2)
      hint: Asked only when question A2 is not "No".
    items:
    - id: B7
      kind: Question
      title: Why did … not attend school last year?
      precondition:
      - predicate: B6.outcome in [2, 7, 8]
        hint: Asked only when question B6 is one of "No", "Don't know", "Refused".
      - predicate: not (CHILD_1_Age.outcome <= 4)
        hint: Not asked for ages 00-04.
      - predicate: not (B6.outcome == 1)
        hint: Asked only when question B6 is not "Yes".
      input:
        control: Radio
        labels:
          1: Too young for school
          2: Physical, mental, emotional or behavioral problem
          3: Left school before graduating
          4: Graduated from school
          5: 'Other - Specify:'
  - id: b_s2_p1_b8
    title: Last grade enrolled
    precondition:
    - predicate: not (A2.outcome == 2)
      hint: Asked only when question A2 is not "No".
    items:
    - id: B8
      kind: Question
      title: In what grade was … last enrolled?
      precondition:
      - predicate: B6.outcome in [2, 7, 8] and B7.outcome in [3, 4, 5]
        hint: Asked only when B6 is not "Yes" and B7 is a school-leaving or other reason.
      - predicate: not (CHILD_1_Age.outcome <= 4)
        hint: Not asked for ages 00-04.
      - predicate: not (B6.outcome == 1)
        hint: Asked only when question B6 is not "Yes".
      - predicate: not (B7.outcome in [1, 2])
        hint: Asked only when question B7 is none of "Too young for school", "Physical, mental, emotional or behavioral problem".
      input:
        control: Dropdown
        labels:
          1: Junior kindergarten
          2: Kindergarten
          3: Grade 1
          4: Grade 2
          5: Grade 3
          6: Grade 4
          7: Grade 5
          8: Grade 6
          9: Grade 7 (in Quebec = Secondary 1)
          10: Grade 8 (in Quebec = Secondary 2)
          11: Grade 9 (in Quebec = Secondary 3)
          12: Grade 10 (in Quebec = Secondary 4)
          13: Grade 11 (in Quebec = Secondary 5)
          14: Grade 12
          15: OAC Grade 13 (in Ontario)
          16: Ungraded
          17: CEGEP technical program 1st year
          18: CEGEP technical program 2nd year
          19: CEGEP technical program 3rd year
          20: CEGEP academic program (pre-university) 1st year
          21: CEGEP academic program (pre-university) 2nd year
          22: CEGEP academic program (pre-university) 3rd year
          23: University, college 1st year
          24: University, college 2nd year
          25: University, college 3rd year
          26: Apprenticeship 1st year
          27: Apprenticeship 2nd year
          28: Apprenticeship 3rd year
          29: Trades-technology training 1st year
          30: Trades-technology training 2nd year
          31: Trades-technology training 3rd year
          32: Other
          33: N/A
          97: Don't know
          98: Refused
  - id: b_s2_p1_b9
    title: Grade enrolled last year
    precondition:
    - predicate: not (A2.outcome == 2)
      hint: Asked only when question A2 is not "No".
    items:
    - id: B9
      kind: Question
      title: In what grade was he/she enrolled last year?
      precondition:
      - predicate: B6.outcome == 1
        hint: Asked only when question B6 is "Yes".
      - predicate: not (CHILD_1_Age.outcome <= 4)
        hint: Not asked for ages 00-04.
      - predicate: not (B7.outcome in [1, 2])
        hint: Asked only when question B7 is none of "Too young for school", "Physical, mental, emotional or behavioral problem".
      - predicate: not (B8.outcome is not None and B8.outcome >= 1)
        hint: Asked only when question B8 was not answered.
      input:
        control: Dropdown
        labels:
          34: Junior kindergarten
          35: Kindergarten
          36: Grade 1
          37: Grade 2
          38: Grade 3
          39: Grade 4
          40: Grade 5
          41: Grade 6
          42: Grade 7 (in Quebec = Secondary 1)
          43: Grade 8 (in Quebec = Secondary 2)
          44: Grade 9 (in Quebec = Secondary 3)
          45: Grade 10 (in Quebec = Secondary 4)
          46: Grade 11 (in Quebec = Secondary 5)
          47: Grade 12
          48: OAC Grade 13 (in Ontario)
          49: Ungraded
          50: CEGEP technical program 1st year
          51: CEGEP technical program 2nd year
          52: CEGEP technical program 3rd year
          53: CEGEP academic program (pre-university) 1st year
          54: CEGEP academic program (pre-university) 2nd year
          55: CEGEP academic program (pre-university) 3rd year
          56: University, college 1st year
          57: University, college 2nd year
          58: University, college 3rd year
          59: Apprenticeship 1st year
          60: Apprenticeship 2nd year
          61: Apprenticeship 3rd year
          62: Trades-technology training 1st year
          63: Trades-technology training 2nd year
          64: Trades-technology training 3rd year
          65: Other
          66: N/A
          97: Don't know
          98: Refused
  - id: b_s2_p1_school_year
    title: Last school year
    precondition:
    - predicate: not (A2.outcome == 2)
      hint: Asked only when question A2 is not "No".
    - predicate: not (CHILD_1_Age.outcome <= 4)
      hint: Not asked for ages 00-04.
    - predicate: not (B7.outcome in [1, 2])
      hint: Asked only when question B7 is none of "Too young for school", "Physical, mental, emotional or behavioral problem".
    - predicate: not (B8.outcome is not None and B8.outcome >= 1)
      hint: Asked only when question B8 was not answered.
    - predicate: not (B9.outcome is not None and B9.outcome >= 34)
      hint: Asked only when question B9 was not answered.
    items:
    - id: B10
      kind: Question
      title: The next questions refer to …’s last school year. Based on your knowledge of …’s schoolwork, including report cards, how did he/she do overall in school? (READ LIST.)
      input:
        control: Radio
        labels:
          1: Above average
          2: Average
          3: Below average
          7: Don't know
          8: Refused
    - id: B11
      kind: Question
      title: How did ... feel about his/her schoolwork? (READ LIST.)
      input:
        control: Radio
        labels:
          1: Liked it very much
          2: Liked it
          3: Neither liked nor disliked it
          4: Disliked it
          5: Disliked it very much
          7: Don't know
          8: Refused
    - id: B12
      kind: Question
      title: Overall, did ...’s close friends do well in their schoolwork?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
    - id: B13
      kind: Question
      title: How often were …’s parents/guardians in contact with his/her teachers to discuss his/her academic performance or behaviour? (READ LIST.)
      input:
        control: Radio
        labels:
          1: Often
          2: A few times
          3: Once
          4: Never
          7: Don't know
          8: Refused
    - id: B14
      kind: Question
      title: Did …’s parents/guardians set aside a place in the home for him/her to use for studying or doing homework?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
    - id: B15a
      kind: Question
      title: 'In a typical week during the last school year, how often did ... participate in organized activities that were not run by the school such as: a) Sports or physical activities like Little League, swim club or hockey league? (READ LIST.)'
      input:
        control: Radio
        labels:
          1: More than once a week
          2: About once a week
          3: Less than once a week
          4: Never
          7: Don't know
          8: Refused
    - id: B15b
      kind: Question
      title: 'In a typical week during the last school year, how often did ... participate in organized activities that were not run by the school such as: b) Social club activities like scouts, girl guides, boys and girls clubs or church groups? (READ LIST.)'
      input:
        control: Radio
        labels:
          1: More than once a week
          2: About once a week
          3: Less than once a week
          4: Never
          7: Don't know
          8: Refused
    - id: B15c
      kind: Question
      title: 'In a typical week during the last school year, how often did ... participate in organized activities that were not run by the school such as: c) Cultural activities like music lessons, art lessons, dance lessons or drama lessons? (READ LIST.)'
      input:
        control: Radio
        labels:
          1: More than once a week
          2: About once a week
          3: Less than once a week
          4: Never
          7: Don't know
          8: Refused
    - id: B16
      kind: Question
      title: In a typical week during the last school year, how often did ... participate in organized activities that were run by the school outside of school hours? This includes any activity such as sports teams, social clubs, music, band or school plays run by the school. (READ LIST.)
      input:
        control: Radio
        labels:
          1: More than once a week
          2: About once a week
          3: Less than once a week
          4: Never
          7: Don't know
          8: Refused
    - id: B17a
      kind: Question
      title: Using the categories very often, often, sometimes and never, how often did ...’s parents/guardians .... a) Praise … if he/she did well in school? (READ LIST.)
      input:
        control: Radio
        labels:
          1: Very often
          2: Often
          3: Sometimes
          4: Never
          7: Don't know
          8: Refused
    - id: B17b
      kind: Question
      title: Using the categories very often, often, sometimes and never, how often did ...’s parents/guardians .... b) Praise ... for trying in school, even if he/she did not succeed? (READ LIST.)
      input:
        control: Radio
        labels:
          1: Very often
          2: Often
          3: Sometimes
          4: Never
          7: Don't know
          8: Refused
    - id: B17c
      kind: Question
      title: Using the categories very often, often, sometimes and never, how often did ...’s parents/guardians .... c) Help … with homework when he/she did not understand? (READ LIST.)
      input:
        control: Radio
        labels:
          1: Very often
          2: Often
          3: Sometimes
          4: Never
          7: Don't know
          8: Refused
    - id: B17d
      kind: Question
      title: Using the categories very often, often, sometimes and never, how often did ...’s parents/guardians .... d) Remind … to begin or complete homework? (READ LIST.)
      input:
        control: Radio
        labels:
          1: Very often
          2: Often
          3: Sometimes
          4: Never
          7: Don't know
          8: Refused
    - id: B17e
      kind: Question
      title: Using the categories very often, often, sometimes and never, how often did ...’s parents/guardians .... e) Help ... plan his/her time for getting homework done? (READ LIST.)
      input:
        control: Radio
        labels:
          1: Very often
          2: Often
          3: Sometimes
          4: Never
          7: Don't know
          8: Refused
    - id: B17f
      kind: Question
      title: Using the categories very often, often, sometimes and never, how often did ...’s parents/guardians .... f) Decide how much television … could watch on school days? (READ LIST.)
      input:
        control: Radio
        labels:
          1: Very often
          2: Often
          3: Sometimes
          4: Never
          7: Don't know
          8: Refused
    - id: B17g
      kind: Question
      title: Using the categories very often, often, sometimes and never, how often did ...’s parents/guardians .... g) Tell or remind ... that he/she was not working to his/her full potential or ability? (READ LIST.)
      input:
        control: Radio
        labels:
          1: Very often
          2: Often
          3: Sometimes
          4: Never
          7: Don't know
          8: Refused
    - id: B18
      kind: Question
      title: In general, how much time did … spend doing homework? (READ LIST.)
      input:
        control: Radio
        labels:
          1: A lot
          2: A fair amount
          3: Very little
          4: None at all
          7: Don't know
          8: Refused
    - id: B19
      kind: Question
      title: How much leisure time did …’s parents/guardians usually spend with him/her in a week? Leisure time means doing things together like playing a game, going shopping together, or other activities. (READ LIST.)
      input:
        control: Radio
        labels:
          1: A lot
          2: A fair amount
          3: Very little
          4: None at all
          7: Don't know
          8: Refused
  - id: b_s2_p1_planning
    title: Planning for post-secondary education
    precondition:
    - predicate: not (A2.outcome == 2)
      hint: Asked only when question A2 is not "No".
    items:
    - id: B20
      kind: Question
      title: PLANNING FOR POST-SECONDARY EDUCATION. Now I'd like to ask you some questions about saving for ...'s post-secondary education. Post-secondary education includes college and university as well as apprenticeships, trade-vocational programs, CEGEPs or any other type of formal education after high school. Have you or anyone else living in your household ever saved money for ...'s post-secondary education?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Don't know
          4: Refused
    - id: B21
      kind: Question
      title: Are you or anyone else living in your household planning to save or pay for ...'s post-secondary education?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Don't know
          4: Refused
    - id: B22
      kind: Question
      title: If ... were to go on to post-secondary education, do his/her parents/guardians expect that he/she will live away from home?
      precondition:
      - predicate: B21.outcome == 1
        hint: Asked only when question B21 is "Yes".
      - predicate: not (B21.outcome in [2, 3, 4])
        hint: Asked only when question B21 is none of "No", "Don't know", "Refused".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Don't know
          4: Refused
    - id: B23
      kind: Question
      title: Assuming that … lives at home, how much do his/her parents/guardians expect that the total cost of his/her education would be? $
      precondition:
      - predicate: B22.outcome in [2, 3, 4]
        hint: Asked only when question B22 is one of "No", "Don't know", "Refused".
      - predicate: not (B21.outcome in [2, 3, 4])
        hint: Asked only when question B21 is none of "No", "Don't know", "Refused".
      - predicate: not (B22.outcome == 1)
        hint: Asked only when question B22 is not "Yes".
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
    - id: B24
      kind: Question
      title: Assuming that … lives away from home, how much do his/her parents/guardians expect that the total cost of his/her education and living expenses would be? $
      precondition:
      - predicate: B22.outcome == 1
        hint: Asked only when question B22 is "Yes".
      - predicate: not (B21.outcome in [2, 3, 4])
        hint: Asked only when question B21 is none of "No", "Don't know", "Refused".
      - predicate: not (B23.outcome is not None and B23.outcome >= 0)
        hint: Asked only when question B23 was not answered.
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
  - id: b_s2_p1_expected_payment
    title: Expected payment of education costs
    precondition:
    - predicate: not (A2.outcome == 2)
      hint: Asked only when question A2 is not "No".
    - predicate: not (B21.outcome in [2, 3, 4])
      hint: Asked only when question B21 is none of "No", "Don't know", "Refused".
    items:
    - id: B25a
      kind: Question
      title: 'Do ...’s parents/guardians expect that he/she will pay for any part of his/her education costs himself/herself in the following ways: a) He/she will work before starting his/her post-secondary studies? This includes part-time jobs while in high school.'
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Don't know
          4: Refused
    - id: B25b
      kind: Question
      title: 'Do ...’s parents/guardians expect that he/she will pay for any part of his/her education costs himself/herself in the following ways: b) He/she will work during his/her post-secondary studies? This includes part-time jobs, summer jobs or co-op work programs.'
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Don't know
          4: Refused
    - id: B25c
      kind: Question
      title: 'Do ...’s parents/guardians expect that he/she will pay for any part of his/her education costs himself/herself in the following ways: c) He/she will interrupt his/her studies to work?'
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Don't know
          4: Refused
    - id: B25d
      kind: Question
      title: 'Do ...’s parents/guardians expect that he/she will pay for any part of his/her education costs himself/herself in the following ways: d) He/she will take out loans that will be repaid after his/her studies are finished?'
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Don't know
          4: Refused
    - id: B26
      kind: Question
      title: 'Interviewer Check Item: 1 If B25d = "Yes", go to B27; 2 Otherwise, go to B28'
      input:
        control: Radio
        labels:
          1: B25d = Yes
          2: Otherwise
  - id: b_s2_p1_loans
    title: Expected loans
    precondition:
    - predicate: not (A2.outcome == 2)
      hint: Asked only when question A2 is not "No".
    - predicate: B25d.outcome == 1
      hint: Asked only when question B25d is "Yes".
    - predicate: not (B21.outcome in [2, 3, 4])
      hint: Asked only when question B21 is none of "No", "Don't know", "Refused".
    - predicate: not (B25d.outcome in [2, 3, 4])
      hint: Asked only when question B25d is none of "No", "Don't know", "Refused".
    items:
    - id: B27a
      kind: Question
      title: 'Are the loans expected to be: a) Government student loans (federal or provincial)?'
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Don't know
          4: Refused
    - id: B27b
      kind: Question
      title: 'Are the loans expected to be: b) Non-student loans from a financial institution (e.g. bank, trust company, credit union)?'
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Don't know
          4: Refused
    - id: B27c
      kind: Question
      title: 'Are the loans expected to be: c) Loans from family or friends?'
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Don't know
          4: Refused
  - id: b_s2_p1_parent_payment
    title: Parents' expected contribution and other sources
    precondition:
    - predicate: not (A2.outcome == 2)
      hint: Asked only when question A2 is not "No".
    - predicate: not (B21.outcome in [2, 3, 4])
      hint: Asked only when question B21 is none of "No", "Don't know", "Refused".
    items:
    - id: B28a
      kind: Question
      title: 'Do ...’s parents/guardians expect that they will pay for any part of his/her education costs in the following ways: a) Savings or investments they make before … starts post-secondary studies?'
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Don't know
          4: Refused
    - id: B28b
      kind: Question
      title: 'Do ...’s parents/guardians expect that they will pay for any part of his/her education costs in the following ways: b) Income they earn while … is attending post-secondary?'
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Don't know
          4: Refused
    - id: B28c
      kind: Question
      title: 'Do ...’s parents/guardians expect that they will pay for any part of his/her education costs in the following ways: c) Loans they take out and pay back after … finishes post-secondary studies? This does not include loans taken out by … such as a student loan.'
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Don't know
          4: Refused
    - id: B28d
      kind: Question
      title: 'Do ...’s parents/guardians expect that they will pay for any part of his/her education costs in the following ways: d) Other?'
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Don't know
          4: Refused
    - id: B29a
      kind: Question
      title: Do ...’s parents/guardians expect that any part of his/her post-secondary education will be paid for by the following sources? a) Scholarships or awards based on academic performance
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Don't know
          4: Refused
    - id: B29b
      kind: Question
      title: Do ...’s parents/guardians expect that any part of his/her post-secondary education will be paid for by the following sources? b) Grants or bursaries based on financial need
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Don't know
          4: Refused
    - id: B29c
      kind: Question
      title: Do ...’s parents/guardians expect that any part of his/her post-secondary education will be paid for by the following sources? c) Gifts or inheritances
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Don't know
          4: Refused
    - id: B30
      kind: Question
      title: 'Interviewer Check Item: 1 If B20 = "Yes", go to B31; 2 Otherwise, go to B42 (page 15)'
      input:
        control: Radio
        labels:
          1: B20 = Yes
          2: Otherwise
  - id: b_s2_p1_savings_start
    title: Savings for post-secondary education
    precondition:
    - predicate: not (A2.outcome == 2)
      hint: Asked only when question A2 is not "No".
    - predicate: not (B21.outcome in [2, 3, 4])
      hint: Asked only when question B21 is none of "No", "Don't know", "Refused".
    items:
    - id: B31
      kind: Question
      title: SAVINGS FOR POST-SECONDARY EDUCATION. The following questions refer to savings that have been made for …’s post-secondary education by anyone living in your household, including … . Do not include savings that have been put aside by someone who does not live in your household. How old was … when these savings were first started? ___ years old (If less than 1 year, enter 00)
      precondition:
      - predicate: B20.outcome == 1
        hint: Asked only when question B20 is "Yes".
      - predicate: not (B20.outcome in [2, 3, 4])
        hint: Asked only when question B20 is none of "No", "Don't know", "Refused".
      postcondition:
      - predicate: B31.outcome in [1, 2] or B31.outcome <= CHILD_1_Age.outcome
        hint: La edad al empezar a ahorrar (B31) no puede ser mayor que la edad actual del niño (CHILD 1 Age).
        invented: true
      input:
        control: Editbox
        min: 0
        max: 18
        right: years old
  - id: b_s2_p1_savings
    title: Amounts saved and savings plans
    precondition:
    - predicate: not (A2.outcome == 2)
      hint: Asked only when question A2 is not "No".
    - predicate: not (B21.outcome in [2, 3, 4])
      hint: Asked only when question B21 is none of "No", "Don't know", "Refused".
    - predicate: not (B20.outcome in [2, 3, 4])
      hint: Asked only when question B20 is none of "No", "Don't know", "Refused".
    items:
    - id: B32
      kind: Question
      title: How much money was saved for …’s post-secondary education in 1998? Do not include any earnings or interest. $
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
    - id: B33
      kind: Question
      title: How much money has been saved for …’s post-secondary education so far in 1999? Do not include any earnings or interest. $
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
    - id: B34
      kind: Question
      title: How much money will be saved for… in the rest of 1999? $
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
    - id: B35
      kind: Question
      title: Since starting to save for … , how much in total has been saved for his/her post-secondary education? Do not include any earnings or interest. $
      postcondition:
      - predicate: B35.outcome in [5, 6] or B32.outcome in [3, 4] or B32.outcome <= B35.outcome
        hint: The amount saved in 1998 (B32) cannot exceed the total saved since starting to save (B35).
        invented: true
      - predicate: B35.outcome in [5, 6] or B33.outcome in [5, 6] or B33.outcome <= B35.outcome
        hint: The amount saved so far in 1999 (B33) cannot exceed the total saved since starting to save (B35).
        invented: true
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
    - id: B36
      kind: Question
      title: How much do you expect to have saved for …’s education by the time he/she starts post-secondary studies? Include all earnings and interest. $
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
    - id: B37a
      kind: Question
      title: What types of savings plans are being used to save for …’s post secondary education? a) RESPs (Registered Education Savings Plans)
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Don't know
          4: Refused
    - id: B37b
      kind: Question
      title: What types of savings plans are being used to save for …’s post secondary education? b) RRSPs (Registered Retirement Savings Plans)
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Don't know
          4: Refused
    - id: B37c
      kind: Question
      title: What types of savings plans are being used to save for …’s post secondary education? c) “In-trust for” accounts
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Don't know
          4: Refused
  - id: b_s2_p2_savings_other
    title: 'Savings plans: other'
    precondition:
    - predicate: not (A2.outcome == 2)
      hint: Asked only when question A2 is not "No".
    items:
    - id: B37d
      kind: Question
      title: What types of savings plans are being used to save for …’s post secondary education? d) Other
      precondition:
      - predicate: not (B21.outcome in [2, 3, 4])
        hint: Asked only when question B21 is none of "No", "Don't know", "Refused".
      - predicate: not (B20.outcome in [2, 3, 4])
        hint: Asked only when question B20 is none of "No", "Don't know", "Refused".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Don't know
          4: Refused
  - id: b_s2_p2_investments
    title: How the savings are invested
    precondition:
    - predicate: not (A2.outcome == 2)
      hint: Asked only when question A2 is not "No".
    - predicate: not (B21.outcome in [2, 3, 4])
      hint: Asked only when question B21 is none of "No", "Don't know", "Refused".
    - predicate: not (B20.outcome in [2, 3, 4])
      hint: Asked only when question B20 is none of "No", "Don't know", "Refused".
    - predicate: not (B37a.outcome in [2, 3, 4] and B37b.outcome in [2, 3, 4] and B37c.outcome in [2, 3, 4] and B37d.outcome in [2, 3, 4])
      hint: Asked only when at least one savings plan type was reported in B37a to B37d.
    items:
    - id: B38a
      kind: Question
      title: Within these plans, how are the savings invested? a) Mutual funds
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Don't know
          4: Refused
    - id: B38b
      kind: Question
      title: Within these plans, how are the savings invested? b) Shares of corporations
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Don't know
          4: Refused
    - id: B38c
      kind: Question
      title: Within these plans, how are the savings invested? c) Savings or chequing accounts
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Don't know
          4: Refused
    - id: B38d
      kind: Question
      title: Within these plans, how are the savings invested? d) Savings bonds
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Don't know
          4: Refused
    - id: B38e
      kind: Question
      title: Within these plans, how are the savings invested? e) Other
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Don't know
          4: Refused
    - id: B39
      kind: Question
      title: 'Interviewer Check Item: 1 If B37a = "Yes", go to B40; 2 Otherwise, go to B42'
      input:
        control: Radio
        labels:
          1: B37a = Yes
          2: Otherwise
  - id: b_s2_p2_resp
    title: RESP contributions and types
    precondition:
    - predicate: not (A2.outcome == 2)
      hint: Asked only when question A2 is not "No".
    - predicate: B37a.outcome == 1
      hint: Asked only when question B37a is "Yes".
    - predicate: not (B21.outcome in [2, 3, 4])
      hint: Asked only when question B21 is none of "No", "Don't know", "Refused".
    - predicate: not (B20.outcome in [2, 3, 4])
      hint: Asked only when question B20 is none of "No", "Don't know", "Refused".
    - predicate: not (B37a.outcome in [2, 3, 4] and B37b.outcome in [2, 3, 4] and B37c.outcome in [2, 3, 4] and B37d.outcome in [2, 3, 4])
      hint: Asked only when at least one savings plan type was reported in B37a to B37d.
    - predicate: not (B37a.outcome in [2, 3, 4])
      hint: Asked only when question B37a is none of "No", "Don't know", "Refused".
    items:
    - id: B40
      kind: Question
      title: For the RESP only, how much money in total has been contributed to RESPs for … by people living in your household? $
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
    - id: B41a
      kind: Question
      title: Which types of RESPs are being used? a) Individual plan (includes individual non-family and family RESPs)
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Don't know
          4: Refused
    - id: B41b
      kind: Question
      title: Which types of RESPs are being used? b) Group plan (education scholarship trust or foundation)
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Don't know
          4: Refused
  - id: b_s2_p2_outside_savings
    title: Savings held outside the household
    precondition:
    - predicate: not (A2.outcome == 2)
      hint: Asked only when question A2 is not "No".
    items:
    - id: B42
      kind: Question
      title: Does anyone who does not live in your household have savings put aside for …’s post-secondary education?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
    - id: B43
      kind: Question
      title: How much money in total have the people who don’t live in your household put aside for …’s post-secondary education? $
      precondition:
      - predicate: B42.outcome == 1
        hint: Asked only when question B42 is "Yes".
      - predicate: not (B42.outcome in [2, 7, 8])
        hint: Asked only when question B42 is none of "No", "Don't know", "Refused".
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
    - id: B44
      kind: Question
      title: 'Interviewer Check Item: 1 If there is more than one child in the household, go to SECTION C – CHILD 2; 2 Otherwise, go to SECTION F (page 47)'
      input:
        control: Radio
        labels:
          1: More than one child in the household
          2: Otherwise
  - id: b_s3_child2_profile
    title: 'SECTION C - General Questions: Child 2'
    precondition:
    - predicate: not (A2.outcome == 2)
      hint: Asked only when question A2 is not "No".
    items:
    - id: CHILD_2_First_Name
      kind: Question
      title: CHILD 2 First Name
      input:
        control: Textarea
    - id: CHILD_2_Sex
      kind: Question
      title: CHILD 2 Sex
      input:
        control: Radio
        labels:
          1: Male
          2: Female
    - id: CHILD_2_Age
      kind: Question
      title: CHILD 2 Age (in years) If age is less than 1 year, enter 00.
      input:
        control: Editbox
        min: 0
        max: 18
    - id: C1
      kind: Question
      title: Now I am going to ask you some questions about ... (name of CHILD 2). What is …’s relationship to you?
      input:
        control: Radio
        labels:
          1: Son/daughter (biological, adoptive, stepchild)
          2: Foster child
          3: Grandchild
          4: Brother/sister
          5: Other family member or relative
          6: Unrelated
    - id: C2
      kind: Question
      title: Does … have any long-term conditions or health problems which prevent or limit his/her participation in school, at play, or in any other activity for a child of his/her age?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
    - id: C3
      kind: Question
      title: How far do ... ‘s parents/guardians hope that he/she will go in school?
      input:
        control: Radio
        labels:
          1: Primary school
          2: Secondary or high school
          3: Community college, technical college or CEGEP
          4: University
          5: Learn a trade
          7: Don’t know
          8: Refused
    - id: C4
      kind: Question
      title: 'Interviewer Check Item: 1 If age is 00-04, go to C20 (page 25); 2 If age is 05-08, go to C6; 3 If age is 09 or more, go to C5'
      input:
        control: Radio
        labels:
          1: Age is 00-04
          2: Age is 05-08
          3: Age is 09 or more
  - id: b_s3_child2_school
    title: 'Child 2: school attendance and expectations'
    precondition:
    - predicate: not (A2.outcome == 2)
      hint: Asked only when question A2 is not "No".
    items:
    - id: C5
      kind: Question
      title: How far do ... ‘s parents/guardians expect that he/she will go in school?
      precondition:
      - predicate: CHILD_2_Age.outcome >= 9
        hint: Asked only when the child is aged 9 or more.
      - predicate: not (CHILD_2_Age.outcome <= 4)
        hint: Not asked when the child is aged 4 or less.
      - predicate: not (CHILD_2_Age.outcome >= 5 and CHILD_2_Age.outcome <= 8)
        hint: Not asked when the child is aged 5 to 8.
      input:
        control: Radio
        labels:
          1: Primary school
          2: Secondary or high school
          3: Community college, technical college or CEGEP
          4: University
          5: Learn a trade
          7: Don’t know
          8: Refused
    - id: C6
      kind: Question
      title: Did … attend school last year? (include home schooling)
      precondition:
      - predicate: CHILD_2_Age.outcome >= 5
        hint: Asked only when the child is aged 5 or more.
      - predicate: not (CHILD_2_Age.outcome <= 4)
        hint: Not asked when the child is aged 4 or less.
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
    - id: C7
      kind: Question
      title: Why did … not attend school last year?
      precondition:
      - predicate: C6.outcome in [2, 7, 8]
        hint: Asked only when question C6 is one of "No", "Don't know", "Refused".
      - predicate: not (CHILD_2_Age.outcome <= 4)
        hint: Not asked when the child is aged 4 or less.
      - predicate: not (C6.outcome == 1)
        hint: Asked only when question C6 is not "Yes".
      input:
        control: Radio
        labels:
          1: Too young for school
          2: Physical, mental, emotional or behavioral problem
          3: Left school before graduating
          4: Graduated from school
          5: 'Other - Specify:'
    - id: C8
      kind: Question
      title: In what grade was … last enrolled?
      precondition:
      - predicate: C6.outcome in [2, 7, 8] and C7.outcome in [3, 4, 5]
        hint: Asked only when the child did not attend school last year for a reason other than being too young or a health problem.
      - predicate: not (CHILD_2_Age.outcome <= 4)
        hint: Not asked when the child is aged 4 or less.
      - predicate: not (C6.outcome == 1)
        hint: Asked only when question C6 is not "Yes".
      - predicate: not (C7.outcome in [1, 2])
        hint: Asked only when question C7 is none of "Too young for school", "Physical, mental, emotional or behavioral problem".
      input:
        control: Dropdown
        labels:
          1: Junior kindergarten
          2: Kindergarten
          3: Grade 1
          4: Grade 2
          5: Grade 3
          6: Grade 4
          7: Grade 5
          8: Grade 6
          9: Grade 7 (in Quebec = Secondary 1)
          10: Grade 8 (in Quebec = Secondary 2)
          11: Grade 9 (in Quebec = Secondary 3)
          12: Grade 10 (in Quebec = Secondary 4)
          13: Grade 11 (in Quebec = Secondary 5)
          14: Grade 12
          15: OAC Grade 13 (in Ontario)
          16: Ungraded
          17: CEGEP technical program 1st year
          18: CEGEP technical program 2nd year
          19: CEGEP technical program 3rd year
          20: CEGEP academic program (pre-university) 1st year
          21: CEGEP academic program (pre-university) 2nd year
          22: CEGEP academic program (pre-university) 3rd year
          23: University, college 1st year
          24: University, college 2nd year
          25: University, college 3rd year
          26: Apprenticeship 1st year
          27: Apprenticeship 2nd year
          28: Apprenticeship 3rd year
          29: Trades-technology training 1st year
          30: Trades-technology training 2nd year
          31: Trades-technology training 3rd year
          32: Other
          33: N/A
          97: Don't know
          98: Refused
  - id: b_s4_enrollment
    title: Section C (continued) - School experience
    precondition:
    - predicate: not (A2.outcome == 2)
      hint: Asked only when question A2 is not "No".
    - predicate: CHILD_2_Age.outcome is None or CHILD_2_Age.outcome > 4
      hint: Not asked when the child is 4 years old or younger.
    - predicate: not (C7.outcome in [1, 2])
      hint: Asked only when question C7 is none of "Too young for school", "Physical, mental, emotional or behavioral problem".
    - predicate: C8.outcome is None or C8.outcome < 1
      hint: Not asked when question C8 has a recorded answer of 1 or more.
    items:
    - id: C9
      kind: Question
      title: In what grade was he/she enrolled last year?
      input:
        control: Dropdown
        labels:
          34: Junior kindergarten
          35: Kindergarten
          36: Grade 1
          37: Grade 2
          38: Grade 3
          39: Grade 4
          40: Grade 5
          41: Grade 6
          42: Grade 7 (in Quebec = Secondary 1)
          43: Grade 8 (in Quebec = Secondary 2)
          44: Grade 9 (in Quebec = Secondary 3)
          45: Grade 10 (in Quebec = Secondary 4)
          46: Grade 11 (in Quebec = Secondary 5)
          47: Grade 12
          48: OAC Grade 13 (in Ontario)
          49: Ungraded
          50: CEGEP technical program - 1st year
          51: CEGEP technical program - 2nd year
          52: CEGEP technical program - 3rd year
          53: CEGEP academic program (pre-university) - 1st year
          54: CEGEP academic program (pre-university) - 2nd year
          55: CEGEP academic program (pre-university) - 3rd year
          56: University, college - 1st year
          57: University, college - 2nd year
          58: University, college - 3rd year
          59: Apprenticeship - 1st year
          60: Apprenticeship - 2nd year
          61: Apprenticeship - 3rd year
          62: Trades-technology training - 1st year
          63: Trades-technology training - 2nd year
          64: Trades-technology training - 3rd year
          65: Other
          66: N/A
          97: Don't know
          98: Refused
  - id: b_s4_school_year
    title: Last school year
    precondition:
    - predicate: not (A2.outcome == 2)
      hint: Asked only when question A2 is not "No".
    - predicate: CHILD_2_Age.outcome is None or CHILD_2_Age.outcome > 4
      hint: Not asked when the child is 4 years old or younger.
    - predicate: not (C7.outcome in [1, 2])
      hint: Asked only when question C7 is none of "Too young for school", "Physical, mental, emotional or behavioral problem".
    - predicate: C8.outcome is None or C8.outcome < 1
      hint: Not asked when question C8 has a recorded answer of 1 or more.
    - predicate: not (C9.outcome in [66, 97, 98])
      hint: Asked only when question C9 is none of "N/A", "Don't know", "Refused".
    items:
    - id: C10
      kind: Question
      title: The next questions refer to …'s last school year. Based on your knowledge of …'s schoolwork, including report cards, how did he/she do overall in school? (READ LIST.)
      input:
        control: Radio
        labels:
          1: Above average
          2: Average
          3: Below average
          7: Don't know
          8: Refused
    - id: C11
      kind: Question
      title: How did ... feel about his/her schoolwork? (READ LIST.)
      input:
        control: Radio
        labels:
          1: Liked it very much
          2: Liked it
          3: Neither liked nor disliked it
          4: Disliked it
          5: Disliked it very much
          7: Don't know
          8: Refused
    - id: C12
      kind: Question
      title: Overall, did ...'s close friends do well in their schoolwork?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
    - id: C13
      kind: Question
      title: How often were …'s parents/guardians in contact with his/her teachers to discuss his/her academic performance or behaviour? (READ LIST.)
      input:
        control: Radio
        labels:
          1: Often
          2: A few times
          3: Once
          4: Never
          7: Don't know
          8: Refused
    - id: C14
      kind: Question
      title: Did …'s parents/guardians set aside a place in the home for him/her to use for studying or doing homework?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
    - id: C15a
      kind: Question
      title: 'In a typical week during the last school year, how often did ... participate in organized activities that were not run by the school such as: a) Sports or physical activities like Little League, swim club or hockey league? (READ LIST.)'
      input:
        control: Radio
        labels:
          1: More than once a week
          2: About once a week
          3: Less than once a week
          4: Never
          7: Don't know
          8: Refused
    - id: C15b
      kind: Question
      title: b) Social club activities like scouts, girl guides, boys and girls clubs or church groups? (READ LIST.)
      input:
        control: Radio
        labels:
          1: More than once a week
          2: About once a week
          3: Less than once a week
          4: Never
          7: Don't know
          8: Refused
    - id: C15c
      kind: Question
      title: c) Cultural activities like music lessons, art lessons, dance lessons or drama lessons? (READ LIST.)
      input:
        control: Radio
        labels:
          1: More than once a week
          2: About once a week
          3: Less than once a week
          4: Never
          7: Don't know
          8: Refused
    - id: C16
      kind: Question
      title: In a typical week during the last school year, how often did ... participate in organized activities that were run by the school outside of school hours? This includes any activity such as sports teams, social clubs, music, band or school plays run by the school. (READ LIST.)
      input:
        control: Radio
        labels:
          1: More than once a week
          2: About once a week
          3: Less than once a week
          4: Never
          7: Don't know
          8: Refused
    - id: C17a
      kind: Question
      title: Using the categories very often, often, sometimes and never, how often did …'s parents/guardians .... a) Praise … if he/she did well in school? (READ LIST.)
      input:
        control: Radio
        labels:
          1: Very often
          2: Often
          3: Sometimes
          4: Never
          7: Don't know
          8: Refused
    - id: C17b
      kind: Question
      title: b) Praise ... for trying in school, even if he/she did not succeed? (READ LIST.)
      input:
        control: Radio
        labels:
          1: Very often
          2: Often
          3: Sometimes
          4: Never
          7: Don't know
          8: Refused
    - id: C17c
      kind: Question
      title: c) Help … with homework when he/she did not understand? (READ LIST.)
      input:
        control: Radio
        labels:
          1: Very often
          2: Often
          3: Sometimes
          4: Never
          7: Don't know
          8: Refused
    - id: C17d
      kind: Question
      title: d) Remind … to begin or complete homework? (READ LIST.)
      input:
        control: Radio
        labels:
          1: Very often
          2: Often
          3: Sometimes
          4: Never
          7: Don't know
          8: Refused
    - id: C17e
      kind: Question
      title: e) Help ... plan his/her time for getting homework done? (READ LIST.)
      input:
        control: Radio
        labels:
          1: Very often
          2: Often
          3: Sometimes
          4: Never
          7: Don't know
          8: Refused
    - id: C17f
      kind: Question
      title: f) Decide how much television … could watch on school days? (READ LIST.)
      input:
        control: Radio
        labels:
          1: Very often
          2: Often
          3: Sometimes
          4: Never
          7: Don't know
          8: Refused
    - id: C17g
      kind: Question
      title: g) Tell or remind ... that he/she was not working to his/her full potential or ability? (READ LIST.)
      input:
        control: Radio
        labels:
          1: Very often
          2: Often
          3: Sometimes
          4: Never
          7: Don't know
          8: Refused
    - id: C18
      kind: Question
      title: In general, how much time did … spend doing homework? (READ LIST.)
      input:
        control: Radio
        labels:
          1: A lot
          2: A fair amount
          3: Very little
          4: None at all
          7: Don't know
          8: Refused
    - id: C19
      kind: Question
      title: How much leisure time did …'s parents/guardians usually spend with him/her in a week? Leisure time means doing things together like playing a game, going shopping together, or other activities. (READ LIST.)
      input:
        control: Radio
        labels:
          1: A lot
          2: A fair amount
          3: Very little
          4: None at all
          7: Don't know
          8: Refused
  - id: b_s5_saving
    title: Planning for post-secondary education
    precondition:
    - predicate: not (A2.outcome == 2)
      hint: Asked only when question A2 is not "No".
    items:
    - id: C20
      kind: Question
      title: Have you or anyone else living in your household ever saved money for …'s post-secondary education?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
    - id: C21
      kind: Question
      title: Are you or anyone else living in your household planning to save or pay for …'s post-secondary education?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
  - id: b_s5_costs
    title: Expected costs and own contributions
    precondition:
    - predicate: not (A2.outcome == 2)
      hint: Asked only when question A2 is not "No".
    - predicate: not (C21.outcome == 2)
      hint: Asked only when question C21 is not "No".
    items:
    - id: C22
      kind: Question
      title: If … were to go on to post-secondary education, do his/her parents/guardians expect that he/she will live away from home?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
    - id: C23
      kind: Question
      title: Assuming that … lives at home, how much do his/her parents/guardians expect that the total cost of his/her education would be? ($; Don't know / Refused)
      precondition:
      - predicate: not (C22.outcome == 1)
        hint: Asked only when question C22 is not "Yes".
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
    - id: C24
      kind: Question
      title: Assuming that … lives away from home, how much do his/her parents/guardians expect that the total cost of his/her education and living expenses would be? ($; Don't know / Refused)
      precondition:
      - predicate: C23.outcome is None or not (C23.outcome >= 0)
        hint: Asked only when question C23 was not answered with an amount.
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
    - id: C25a
      kind: Question
      title: 'Do ...''s parents/guardians expect that he/she will pay for any part of his/her education costs himself/herself in the following ways: a) He/she will work before starting his/her post-secondary studies? This includes part-time jobs while in high school.'
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Don't know
          4: Refused
    - id: C25b
      kind: Question
      title: b) He/she will work during his/her post-secondary studies? This includes part-time jobs, summer jobs or co-op work programs.
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Don't know
          4: Refused
    - id: C25c
      kind: Question
      title: c) He/she will interrupt his/her studies to work?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Don't know
          4: Refused
    - id: C25d
      kind: Question
      title: d) He/she will take out loans that will be repaid after his/her studies are finished?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Don't know
          4: Refused
  - id: b_s5_loans
    title: Expected loans
    precondition:
    - predicate: not (A2.outcome == 2)
      hint: Asked only when question A2 is not "No".
    - predicate: not (C21.outcome == 2)
      hint: Asked only when question C21 is not "No".
    - predicate: not (C25d.outcome != 1)
      hint: Asked only when question C25d is "Yes".
    items:
    - id: C27a
      kind: Question
      title: 'Are the loans expected to be: a) Government student loans (federal or provincial)?'
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Don't know
          4: Refused
    - id: C27b
      kind: Question
      title: b) Non-student loans from a financial institution (e.g. bank, trust company, credit union)?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Don't know
          4: Refused
    - id: C27c
      kind: Question
      title: c) Loans from family or friends?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Don't know
          4: Refused
  - id: b_s5_sources
    title: Expected sources of payment
    precondition:
    - predicate: not (A2.outcome == 2)
      hint: Asked only when question A2 is not "No".
    - predicate: not (C21.outcome == 2)
      hint: Asked only when question C21 is not "No".
    items:
    - id: C28a
      kind: Question
      title: 'Do ...''s parents/guardians expect that they will pay for any part of his/her education costs in the following ways: a) Savings or investments they make before … starts post-secondary studies?'
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Don't know
          4: Refused
    - id: C28b
      kind: Question
      title: b) Income they earn while … is attending post-secondary?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Don't know
          4: Refused
    - id: C28c
      kind: Question
      title: c) Loans they take out and pay back after … finishes post-secondary studies? This does not include loans taken out by … such as a student loan.
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Don't know
          4: Refused
    - id: C28d
      kind: Question
      title: d) Other?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Don't know
          4: Refused
    - id: C29a
      kind: Question
      title: Do ...'s parents/guardians expect that any part of his/her post-secondary education will be paid for by the following sources? a) Scholarships or awards based on academic performance
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Don't know
          4: Refused
    - id: C29b
      kind: Question
      title: b) Grants or bursaries based on financial need
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Don't know
          4: Refused
    - id: C29c
      kind: Question
      title: c) Gifts or inheritances
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Don't know
          4: Refused
  - id: b_s6_preamble
    title: Interview setup
    precondition:
    - predicate: not (A2.outcome == 2)
      hint: Asked only when question A2 is not "No".
    items:
    - id: NUM_CHILDREN_HH
      kind: Question
      title: 'External input: number of children in the household (used by Interviewer Check Item C44: "If there are more than two children in the household, go to SECTION D - CHILD 3")'
      external: true
      input:
        control: Editbox
        min: 0
        max: 99
  - id: b_s6_savings
    title: Savings amounts and plan types
    precondition:
    - predicate: not (A2.outcome == 2)
      hint: Asked only when question A2 is not "No".
    - predicate: not (C21.outcome == 2)
      hint: Asked only when question C21 is not "No".
    - predicate: not (C20.outcome != 1)
      hint: Asked only when question C20 is "Yes".
    items:
    - id: C31
      kind: Question
      title: How old was … when these savings were first started? ___ years old (If less than 1 year, enter 00)
      input:
        control: Editbox
        min: 0
        max: 99
        right: years old
    - id: C32
      kind: Question
      title: How much money was saved for …'s post-secondary education in 1998? Do not include any earnings or interest. ($; Don't know / Refused)
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
    - id: C33
      kind: Question
      title: How much money has been saved for …'s post-secondary education so far in 1999? Do not include any earnings or interest. ($; Don't know / Refused)
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
    - id: C34
      kind: Question
      title: How much money will be saved for… in the rest of 1999? ($; Don't know / Refused)
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
    - id: C35
      kind: Question
      title: How much do you expect to have saved for …'s education by the time he/she starts post-secondary studies? Include all earnings and interest. ($; Don't know / Refused)
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
    - id: C36
      kind: Question
      title: Since starting to save for … , how much in total has been saved for his/her post-secondary education? Do not include any earnings or interest. ($; Don't know / Refused)
      postcondition:
      - predicate: C32.outcome + C33.outcome <= C36.outcome
        hint: The total saved since starting (C36) cannot be less than the sum of the amount saved in 1998 (C32) and so far in 1999 (C33).
        invented: true
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
    - id: C37a
      kind: Question
      title: What types of savings plans are being used to save for …'s post secondary education? a) RESPs (Registered Education Savings Plans)
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Don't know
          4: Refused
    - id: C37b
      kind: Question
      title: b) RRSPs (Registered Retirement Savings Plans)
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Don't know
          4: Refused
    - id: C37c
      kind: Question
      title: c) "In-trust for" accounts
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Don't know
          4: Refused
    - id: C37d
      kind: Question
      title: d) Other
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Don't know
          4: Refused
  - id: b_s6_investments
    title: Investment of savings
    precondition:
    - predicate: not (A2.outcome == 2)
      hint: Asked only when question A2 is not "No".
    - predicate: not (C21.outcome == 2)
      hint: Asked only when question C21 is not "No".
    - predicate: not (C20.outcome != 1)
      hint: Asked only when question C20 is "Yes".
    - predicate: not (C37a.outcome != 1 and C37b.outcome != 1 and C37c.outcome != 1 and C37d.outcome != 1)
      hint: Asked only when at least one savings plan type (C37a to C37d) is "Yes".
    items:
    - id: C38a
      kind: Question
      title: Within these plans, how are the savings invested? a) Mutual funds
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Don't know
          4: Refused
    - id: C38b
      kind: Question
      title: b) Shares of corporations
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Don't know
          4: Refused
    - id: C38c
      kind: Question
      title: c) Savings or chequing accounts
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Don't know
          4: Refused
    - id: C38d
      kind: Question
      title: d) Savings bonds
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Don't know
          4: Refused
    - id: C38e
      kind: Question
      title: e) Other
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Don't know
          4: Refused
  - id: b_s6_resp
    title: RESP contributions and types
    precondition:
    - predicate: not (A2.outcome == 2)
      hint: Asked only when question A2 is not "No".
    - predicate: not (C21.outcome == 2)
      hint: Asked only when question C21 is not "No".
    - predicate: not (C20.outcome != 1)
      hint: Asked only when question C20 is "Yes".
    - predicate: not (C37a.outcome != 1 and C37b.outcome != 1 and C37c.outcome != 1 and C37d.outcome != 1)
      hint: Asked only when at least one savings plan type (C37a to C37d) is "Yes".
    - predicate: not (C37a.outcome != 1)
      hint: Asked only when question C37a is "Yes".
    items:
    - id: C40
      kind: Question
      title: For the RESP only, how much money in total has been contributed to RESPs for … by people living in your household? ($; Don't know / Refused)
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
    - id: C41a
      kind: Question
      title: C41. Which types of RESPs are being used? a) Individual plan (includes individual non-family and family RESPs)
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Don't know
          4: Refused
    - id: C41b
      kind: Question
      title: b) Group plan (education scholarship trust or foundation)
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Don't know
          4: Refused
  - id: b_s6_outside_household
    title: Savings by people outside the household
    precondition:
    - predicate: not (A2.outcome == 2)
      hint: Asked only when question A2 is not "No".
    items:
    - id: C42
      kind: Question
      title: Does anyone who does not live in your household have savings put aside for …'s post-secondary education?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
    - id: C43
      kind: Question
      title: How much money in total have the people who don't live in your household put aside for …'s post-secondary education? ($; Don't know / Refused)
      precondition:
      - predicate: not (C42.outcome != 1 and NUM_CHILDREN_HH.outcome > 2)
        hint: Asked only when C42 is "Yes" or the household has no more than two children.
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
  - id: b_s7_core
    title: SECTION D - General Questions (CHILD 3)
    precondition:
    - predicate: not (A2.outcome == 2)
      hint: Asked only when question A2 is not "No".
    items:
    - id: D1a
      kind: Question
      title: 'D1. Now I am going to ask you some questions about ... (name of CHILD 3). First Name (id D1a: the source prints one D1 for name, age, sex and relationship)'
      input:
        control: Textarea
    - id: D1b
      kind: Question
      title: Age (in years) If age is less than 1 year, enter 00.
      input:
        control: Editbox
        min: 0
        max: 99
    - id: D1c
      kind: Question
      title: Sex
      input:
        control: Radio
        labels:
          1: Male
          2: Female
    - id: D1d
      kind: Question
      title: What is …'s relationship to you? (printed without an id, within D1)
      input:
        control: Dropdown
        labels:
          1: Son/daughter (biological, adoptive, stepchild)
          2: Foster child
          3: Grandchild
          4: Brother/sister
          5: Other family member or relative
          6: Unrelated
    - id: D2
      kind: Question
      title: Does … have any long-term conditions or health problems which prevent or limit his/her participation in school, at play, or in any other activity for a child of his/her age?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
    - id: D3
      kind: Question
      title: How far do ... 's parents/guardians hope that he/she will go in school?
      input:
        control: Radio
        labels:
          1: Primary school
          2: Secondary or high school
          3: Community college, technical college or CEGEP
          4: University
          5: Learn a trade
          7: Don't know
          8: Refused
  - id: b_s7_school
    title: Schooling
    precondition:
    - predicate: not (A2.outcome == 2)
      hint: Asked only when question A2 is not "No".
    - predicate: not (D1b.outcome <= 4)
      hint: Asked only for children older than 4.
    items:
    - id: D5
      kind: Question
      title: How far do ... 's parents/guardians expect that he/she will go in school?
      precondition:
      - predicate: not (D1b.outcome >= 5 and D1b.outcome <= 8)
        hint: Not asked for children aged 5 to 8.
      input:
        control: Radio
        labels:
          1: Primary school
          2: Secondary or high school
          3: Community college, technical college or CEGEP
          4: University
          5: Learn a trade
          7: Don't know
          8: Refused
    - id: D6
      kind: Question
      title: Did … attend school last year? (include home schooling)
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
    - id: D7
      kind: Question
      title: Why did … not attend school last year?
      precondition:
      - predicate: not (D6.outcome == 1)
        hint: Asked only when question D6 is not "Yes".
      input:
        control: Radio
        labels:
          1: Too young for school
          2: Physical, mental, emotional or behavioral problem
          3: Left school before graduating
          4: Graduated from school
          5: 'Other - Specify:'
    - id: D8
      kind: Question
      title: In what grade was … last enrolled?
      precondition:
      - predicate: not (D6.outcome == 1)
        hint: Asked only when question D6 is not "Yes".
      - predicate: not (D7.outcome in [1, 2, 3, 4, 5])
        hint: Asked only when question D7 is none of "Too young for school", "Physical, mental, emotional or behavioral problem", "Left school before graduating", "Graduated from school", "Other - Specify:".
      input:
        control: Dropdown
        labels:
          1: Junior kindergarten
          2: Kindergarten
          3: Grade 1
          4: Grade 2
          5: Grade 3
          6: Grade 4
          7: Grade 5
          8: Grade 6
          9: Grade 7 (in Quebec = Secondary 1)
          10: Grade 8 (in Quebec = Secondary 2)
          11: Grade 9 (in Quebec = Secondary 3)
          12: Grade 10 (in Quebec = Secondary 4)
          13: Grade 11 (in Quebec = Secondary 5)
          14: Grade 12
          15: OAC Grade 13 (in Ontario)
          16: Ungraded
          17: CEGEP technical program - 1st year
          18: CEGEP technical program - 2nd year
          19: CEGEP technical program - 3rd year
          20: CEGEP academic program (pre-university) - 1st year
          21: CEGEP academic program (pre-university) - 2nd year
          22: CEGEP academic program (pre-university) - 3rd year
          23: University, college - 1st year
          24: University, college - 2nd year
          25: University, college - 3rd year
          26: Apprenticeship - 1st year
          27: Apprenticeship - 2nd year
          28: Apprenticeship - 3rd year
          29: Trades-technology training - 1st year
          30: Trades-technology training - 2nd year
          31: Trades-technology training - 3rd year
          32: Other
          33: N/A
          97: Don't know
          98: Refused
  - id: b_s7_grade
    title: Grade last year
    precondition:
    - predicate: not (A2.outcome == 2)
      hint: Asked only when question A2 is not "No".
    - predicate: not (D1b.outcome <= 4)
      hint: Asked only for children older than 4.
    - predicate: not (D7.outcome in [1, 2, 3, 4, 5])
      hint: Asked only when question D7 is none of "Too young for school", "Physical, mental, emotional or behavioral problem", "Left school before graduating", "Graduated from school", "Other - Specify:".
    - predicate: D8.outcome is None or not (D8.outcome >= 1)
      hint: Asked only when question D8 was not answered.
    items:
    - id: D9
      kind: Question
      title: In what grade was he/she enrolled last year?
      input:
        control: Dropdown
        labels:
          34: Junior kindergarten
          35: Kindergarten
          36: Grade 1
          37: Grade 2
          38: Grade 3
          39: Grade 4
          40: Grade 5
          41: Grade 6
          42: Grade 7 (in Quebec = Secondary 1)
          43: Grade 8 (in Quebec = Secondary 2)
          44: Grade 9 (in Quebec = Secondary 3)
          45: Grade 10 (in Quebec = Secondary 4)
          46: Grade 11 (in Quebec = Secondary 5)
          47: Grade 12
          48: OAC Grade 13 (in Ontario)
          49: Ungraded
          50: CEGEP technical program - 1st year
          51: CEGEP technical program - 2nd year
          52: CEGEP technical program - 3rd year
          53: CEGEP academic program (pre-university) - 1st year
          54: CEGEP academic program (pre-university) - 2nd year
          55: CEGEP academic program (pre-university) - 3rd year
          56: University, college - 1st year
          57: University, college - 2nd year
          58: University, college - 3rd year
          59: Apprenticeship - 1st year
          60: Apprenticeship - 2nd year
          61: Apprenticeship - 3rd year
          62: Trades-technology training - 1st year
          63: Trades-technology training - 2nd year
          64: Trades-technology training - 3rd year
          65: Other
          66: N/A
          97: Don't know
          98: Refused
  - id: b_s7_lastyear
    title: Last school year
    precondition:
    - predicate: not (A2.outcome == 2)
      hint: Asked only when question A2 is not "No".
    - predicate: not (D1b.outcome <= 4)
      hint: Asked only for children older than 4.
    - predicate: not (D7.outcome in [1, 2, 3, 4, 5])
      hint: Asked only when question D7 is none of "Too young for school", "Physical, mental, emotional or behavioral problem", "Left school before graduating", "Graduated from school", "Other - Specify:".
    - predicate: D8.outcome is None or not (D8.outcome >= 1)
      hint: Asked only when question D8 was not answered.
    - predicate: not (D9.outcome in [66, 97, 98])
      hint: Asked only when question D9 is none of "N/A", "Don't know", "Refused".
    items:
    - id: D10
      kind: Question
      title: The next questions refer to …'s last school year. Based on your knowledge of …'s schoolwork, including report cards, how did he/she do overall in school? (READ LIST.)
      input:
        control: Radio
        labels:
          1: Above average
          2: Average
          3: Below average
          7: Don't know
          8: Refused
    - id: D11
      kind: Question
      title: How did ... feel about his/her schoolwork? (READ LIST.)
      input:
        control: Radio
        labels:
          1: Liked it very much
          2: Liked it
          3: Neither liked nor disliked it
          4: Disliked it
          5: Disliked it very much
          7: Don't know
          8: Refused
    - id: D12
      kind: Question
      title: Overall, did ...'s close friends do well in their schoolwork?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
    - id: D13
      kind: Question
      title: How often were …'s parents/guardians in contact with his/her teachers to discuss his/her academic performance or behaviour? (READ LIST.)
      input:
        control: Radio
        labels:
          1: Often
          2: A few times
          3: Once
          4: Never
          7: Don't know
          8: Refused
    - id: D14
      kind: Question
      title: Did …'s parents/guardians set aside a place in the home for him/her to use for studying or doing homework?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
    - id: D15a
      kind: Question
      title: 'In a typical week during the last school year, how often did ... participate in organized activities that were not run by the school such as: a) Sports or physical activities like Little League, swim club or hockey league? (READ LIST.)'
      input:
        control: Radio
        labels:
          1: More than once a week
          2: About once a week
          3: Less than once a week
          4: Never
          7: Don't know
          8: Refused
    - id: D15b
      kind: Question
      title: b) Social club activities like scouts, girl guides, boys and girls clubs or church groups? (READ LIST.)
      input:
        control: Radio
        labels:
          1: More than once a week
          2: About once a week
          3: Less than once a week
          4: Never
          7: Don't know
          8: Refused
    - id: D15c
      kind: Question
      title: c) Cultural activities like music lessons, art lessons, dance lessons or drama lessons? (READ LIST.)
      input:
        control: Radio
        labels:
          1: More than once a week
          2: About once a week
          3: Less than once a week
          4: Never
          7: Don't know
          8: Refused
    - id: D16
      kind: Question
      title: In a typical week during the last school year, how often did ... participate in organized activities that were run by the school outside of school hours? This includes any activity such as sports teams, social clubs, music, band or school plays run by the school. (READ LIST.)
      input:
        control: Radio
        labels:
          1: More than once a week
          2: About once a week
          3: Less than once a week
          4: Never
          7: Don't know
          8: Refused
    - id: D17a
      kind: Question
      title: Using the categories very often, often, sometimes and never, how often did ...'s parents/guardians .... a) Praise … if he/she did well in school? (READ LIST.)
      input:
        control: Radio
        labels:
          1: Very often
          2: Often
          3: Sometimes
          4: Never
          7: Don't know
          8: Refused
    - id: D17b
      kind: Question
      title: b) Praise ... for trying in school, even if he/she did not succeed? (READ LIST.)
      input:
        control: Radio
        labels:
          1: Very often
          2: Often
          3: Sometimes
          4: Never
          7: Don't know
          8: Refused
    - id: D17c
      kind: Question
      title: c) Help … with homework when he/she did not understand? (READ LIST.)
      input:
        control: Radio
        labels:
          1: Very often
          2: Often
          3: Sometimes
          4: Never
          7: Don't know
          8: Refused
    - id: D17d
      kind: Question
      title: d) Remind … to begin or complete homework? (READ LIST.)
      input:
        control: Radio
        labels:
          1: Very often
          2: Often
          3: Sometimes
          4: Never
          7: Don't know
          8: Refused
    - id: D17e
      kind: Question
      title: e) Help ... plan his/her time for getting homework done? (READ LIST.)
      input:
        control: Radio
        labels:
          1: Very often
          2: Often
          3: Sometimes
          4: Never
          7: Don't know
          8: Refused
    - id: D17f
      kind: Question
      title: f) Decide how much television … could watch on school days? (READ LIST.)
      input:
        control: Radio
        labels:
          1: Very often
          2: Often
          3: Sometimes
          4: Never
          7: Don't know
          8: Refused
    - id: D17g
      kind: Question
      title: g) Tell or remind ... that he/she was not working to his/her full potential or ability? (READ LIST.)
      input:
        control: Radio
        labels:
          1: Very often
          2: Often
          3: Sometimes
          4: Never
          7: Don't know
          8: Refused
    - id: D18
      kind: Question
      title: In general, how much time did … spend doing homework? (READ LIST.)
      input:
        control: Radio
        labels:
          1: A lot
          2: A fair amount
          3: Very little
          4: None at all
          7: Don't know
          8: Refused
    - id: D19
      kind: Question
      title: How much leisure time did …'s parents/guardians usually spend with him/her in a week? Leisure time means doing things together like playing a game, going shopping together, or other activities. (READ LIST.)
      input:
        control: Radio
        labels:
          1: A lot
          2: A fair amount
          3: Very little
          4: None at all
          7: Don't know
          8: Refused
  - id: b_s7_savings
    title: Post-secondary planning
    precondition:
    - predicate: not (A2.outcome == 2)
      hint: Asked only when question A2 is not "No".
    items:
    - id: D20
      kind: Question
      title: Have you or anyone else living in your household ever saved money for …'s post-secondary education?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
    - id: D21
      kind: Question
      title: Assuming that … lives at home, how much do his/her parents/guardians expect that the total cost of his/her education would be?
      input:
        control: Editbox
        min: 0
        max: 9999999
  - id: b_s8_external_inputs
    title: External inputs used by the routing of this part
    precondition:
    - predicate: not (A2.outcome == 2)
      hint: Asked only when question A2 is not "No".
    items:
    - id: D20_2
      kind: Question
      title: Whether the household has saved for the child's post-secondary education (D20 is asked in an earlier part; the D30 check item reads it)
      external: true
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: CHILDREN_0_18
      kind: Question
      title: Number of children 0-18 years old in the household (from the household roster; no question in this part collects it; read by checks D44, G1, G12)
      external: true
      input:
        control: Editbox
        min: 0
        max: 30
    - id: ALL_CHILDREN_0_4
      kind: Question
      title: Ages of ALL children in household are 00 - 04 (from the household roster; read by check G1)
      external: true
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
  - id: b_s9_plan
    title: Savings for post-secondary education
    precondition:
    - predicate: not (A2.outcome == 2)
      hint: Asked only when question A2 is not "No".
    items:
    - id: D21_2
      kind: Question
      title: Are you or anyone else living in your household planning to save or pay for …'s post-secondary education?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
  - id: b_s9_expect
    title: Expected costs and ways of paying
    precondition:
    - predicate: not (A2.outcome == 2)
      hint: Asked only when question A2 is not "No".
    - predicate: not (D21_2.outcome != 1)
      hint: Asked only when question D21 is "Yes".
    items:
    - id: D22
      kind: Question
      title: If … were to go on to post-secondary education, do his/her parents/guardians expect that he/she will live away from home?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
    - id: D23
      kind: Question
      title: Assuming that … lives away from home, how much do his/her parents/guardians expect that the total cost of his/her education and living expenses would be? ($ amount; Don't know; Refused)
      precondition:
      - predicate: not (D22.outcome != 1)
        hint: Asked only when question D22 is "Yes".
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: D24
      kind: Question
      title: 'UNREADABLE: D24 is printed on page 37 but its wording is not in the text layer. The page shows a second ''$'' amount box with Don''t know / Refused boxes, so it is probably a dollar amount, but this is not confirmed. Needs manual transcription from the page image.'
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: D25a
      kind: Question
      title: 'Do ...''s parents/guardians expect that he/she will pay for any part of his/her education costs himself/herself in the following ways: a) He/she will work before starting his/her post-secondary studies? This includes part-time jobs while in high school.'
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
    - id: D25b
      kind: Question
      title: b) He/she will work during his/her post-secondary studies? This includes part-time jobs, summer jobs or co-op work programs.
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
    - id: D25c
      kind: Question
      title: c) He/she will interrupt his/her studies to work?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
    - id: D25d
      kind: Question
      title: d) He/she will take out loans that will be repaid after his/her studies are finished?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
  - id: b_s9_loans
    title: Expected types of loans
    precondition:
    - predicate: not (A2.outcome == 2)
      hint: Asked only when question A2 is not "No".
    - predicate: not (D21_2.outcome != 1)
      hint: Asked only when question D21 is "Yes".
    - predicate: not (D25d.outcome != 1)
      hint: Asked only when question D25d is "Yes".
    items:
    - id: D27a
      kind: Question
      title: 'Are the loans expected to be: a) Government student loans (federal or provincial)?'
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
    - id: D27b
      kind: Question
      title: b) Non-student loans from a financial institution (e.g. bank, trust company, credit union)?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
    - id: D27c
      kind: Question
      title: c) Loans from family or friends?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
  - id: b_s9_sources
    title: Expected parental contributions and other sources
    precondition:
    - predicate: not (A2.outcome == 2)
      hint: Asked only when question A2 is not "No".
    - predicate: not (D21_2.outcome != 1)
      hint: Asked only when question D21 is "Yes".
    items:
    - id: D28a
      kind: Question
      title: 'Do ...''s parents/guardians expect that they will pay for any part of his/her education costs in the following ways: a) Savings or investments they make before … starts post-secondary studies?'
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
    - id: D28b
      kind: Question
      title: b) Income they earn while … is attending post-secondary?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
    - id: D28c
      kind: Question
      title: c) Loans they take out and pay back after … finishes post-secondary studies? This does not include loans taken out by … such as a student loan.
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
    - id: D28d
      kind: Question
      title: d) Other?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
    - id: D29a
      kind: Question
      title: Do ...'s parents/guardians expect that any part of his/her post-secondary education will be paid for by the following sources? a) Scholarships or awards based on academic performance
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
    - id: D29b
      kind: Question
      title: b) Grants or bursaries based on financial need
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
    - id: D29c
      kind: Question
      title: c) Gifts or inheritances
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
  - id: b_s9_savings
    title: Savings made for post-secondary education
    precondition:
    - predicate: not (A2.outcome == 2)
      hint: Asked only when question A2 is not "No".
    - predicate: not (D21_2.outcome != 1)
      hint: Asked only when question D21 is "Yes".
    - predicate: not (D20_2.outcome != 1)
      hint: Asked only when question D20 is "Yes".
    items:
    - id: D31
      kind: Question
      title: SAVINGS FOR POST-SECONDARY EDUCATION. The following questions refer to savings that have been made for …'s post-secondary education by anyone living in your household, including … . Do not include savings that have been put aside by someone who does not live in your household. How old was … when these savings were first started? ___ years old (If less than 1 year, enter 00)
      input:
        control: Editbox
        min: 0
        max: 99
        right: years old
    - id: D32
      kind: Question
      title: How much money was saved for …'s post-secondary education in 1998? Do not include any earnings or interest. ($; Don't know; Refused)
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: D33
      kind: Question
      title: How much money has been saved for …'s post-secondary education so far in 1999? Do not include any earnings or interest. ($; Don't know; Refused)
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: D34
      kind: Question
      title: How much money will be saved for… in the rest of 1999? ($; Don't know; Refused)
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: D35
      kind: Question
      title: Since starting to save for … , how much in total has been saved for his/her post-secondary education? Do not include any earnings or interest. ($; Don't know; Refused)
      postcondition:
      - predicate: D35.outcome >= D32.outcome
        hint: The total saved since starting (D35) cannot be less than the amount saved in 1998 (D32).
        invented: true
      - predicate: D35.outcome >= D33.outcome
        hint: The total saved since starting (D35) cannot be less than the amount saved so far in 1999 (D33).
        invented: true
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: D36
      kind: Question
      title: How much do you expect to have saved for …'s education by the time he/she starts post-secondary studies? Include all earnings and interest. ($; Don't know; Refused)
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: D37a
      kind: Question
      title: What types of savings plans are being used to save for …'s post secondary education? a) RESPs (Registered Education Savings Plans)
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
    - id: D37b
      kind: Question
      title: b) RRSPs (Registered Retirement Savings Plans)
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
    - id: D37c
      kind: Question
      title: c) “In-trust for” accounts
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
    - id: D37d
      kind: Question
      title: d) Other
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
  - id: b_s9_invest
    title: How the savings are invested
    precondition:
    - predicate: not (A2.outcome == 2)
      hint: Asked only when question A2 is not "No".
    - predicate: not (D21_2.outcome != 1)
      hint: Asked only when question D21 is "Yes".
    - predicate: not (D20_2.outcome != 1)
      hint: Asked only when question D20 is "Yes".
    - predicate: not (D37a.outcome != 1 and D37b.outcome != 1 and D37c.outcome != 1 and D37d.outcome != 1)
      hint: Asked only when at least one savings plan type (D37a to D37d) is "Yes".
    items:
    - id: D38a
      kind: Question
      title: Within these plans, how are the savings invested? a) Mutual funds
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
    - id: D38b
      kind: Question
      title: b) Shares of corporations
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
    - id: D38c
      kind: Question
      title: c) Savings or chequing accounts
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
    - id: D38d
      kind: Question
      title: d) Savings bonds
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
    - id: D38e
      kind: Question
      title: e) Other
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
  - id: b_s9_resp
    title: RESP details
    precondition:
    - predicate: not (A2.outcome == 2)
      hint: Asked only when question A2 is not "No".
    - predicate: not (D21_2.outcome != 1)
      hint: Asked only when question D21 is "Yes".
    - predicate: not (D20_2.outcome != 1)
      hint: Asked only when question D20 is "Yes".
    - predicate: not (D37a.outcome != 1 and D37b.outcome != 1 and D37c.outcome != 1 and D37d.outcome != 1)
      hint: Asked only when at least one savings plan type (D37a to D37d) is "Yes".
    - predicate: not (D37a.outcome != 1)
      hint: Asked only when question D37a is "Yes".
    items:
    - id: D40
      kind: Question
      title: For the RESP only, how much money in total has been contributed to RESPs for … by people living in your household? ($; Don't know; Refused)
      postcondition:
      - predicate: D40.outcome <= D35.outcome
        hint: The RESP contributions (D40) cannot exceed the total saved since starting (D35).
        invented: true
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: D41a
      kind: Question
      title: D41. Which types of RESPs are being used? a) Individual plan (includes individual non-family and family RESPs)
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
    - id: D41b
      kind: Question
      title: b) Group plan (education scholarship trust or foundation)
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
  - id: b_s9_outside
    title: Savings by people outside the household
    precondition:
    - predicate: not (A2.outcome == 2)
      hint: Asked only when question A2 is not "No".
    items:
    - id: D42
      kind: Question
      title: Does anyone who does not live in your household have savings put aside for …'s post-secondary education?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
    - id: D43
      kind: Question
      title: How much money in total have the people who don’t live in your household put aside for …’s post-secondary education? ($; Don't know; Refused)
      input:
        control: Editbox
        min: 0
        max: 9999999
  - id: b_s10_gate
    title: 'Savings for other children: screening'
    precondition:
    - predicate: not (A2.outcome == 2)
      hint: Asked only when question A2 is not "No".
    items:
    - id: E1
      kind: Question
      title: Now I'd like to ask you some questions about saving for the post-secondary education of the other children in your household who are 18 years of age or younger. Have you or anyone else living in your household ever saved money for the post-secondary education of these children?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
  - id: b_s10_count
    title: 'Savings for other children: number of children'
    precondition:
    - predicate: not (A2.outcome == 2)
      hint: Asked only when question A2 is not "No".
    items:
    - id: E2
      kind: Question
      title: For how many of these children is money being saved? (If 00, go to Section F)
      precondition:
      - predicate: not (E1.outcome == 2)
        hint: Asked only when question E1 is not "No".
      input:
        control: Editbox
        min: 0
        max: 20
  - id: b_s10_amounts
    title: 'Savings for other children: amounts and plan types'
    precondition:
    - predicate: not (A2.outcome == 2)
      hint: Asked only when question A2 is not "No".
    - predicate: not (E1.outcome == 2)
      hint: Asked only when question E1 is not "No".
    - predicate: not (E2.outcome == 0)
      hint: Asked only when question E2 is not 0.
    items:
    - id: E3
      kind: Question
      title: How much money was saved for these children's post-secondary education in 1998? Do not include any earnings or interest. ($; Don't know; Refused)
      input:
        control: Editbox
        min: 0
        max: 10000000
        left: $
    - id: E4
      kind: Question
      title: How much money has been saved for these children's post-secondary education so far in 1999? Do not include any earnings or interest. ($; Don't know; Refused)
      input:
        control: Editbox
        min: 0
        max: 10000000
        left: $
    - id: E5
      kind: Question
      title: How much money will be saved for these children in the rest of 1999? ($; Don't know; Refused)
      input:
        control: Editbox
        min: 0
        max: 10000000
        left: $
    - id: E6
      kind: Question
      title: Since starting to save for these children, how much in total has been saved for their post-secondary education? Do not include any earnings or interest. ($; Don't know; Refused)
      postcondition:
      - predicate: E6.outcome >= E3.outcome
        hint: The total saved since starting (E6) cannot be less than the amount saved in 1998 (E3).
        invented: true
      - predicate: E6.outcome >= E4.outcome
        hint: The total saved since starting (E6) cannot be less than the amount saved so far in 1999 (E4).
        invented: true
      input:
        control: Editbox
        min: 0
        max: 10000000
        left: $
    - id: E7a
      kind: Question
      title: What types of savings plans are being used to save for these children's post secondary education? a) RESPs (Registered Education Savings Plans)
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
    - id: E7b
      kind: Question
      title: b) RRSPs (Registered Retirement Savings Plans)
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
    - id: E7c
      kind: Question
      title: c) "In-trust for" accounts
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
    - id: E7d
      kind: Question
      title: d) Other
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
  - id: b_s10_invest
    title: 'Savings for other children: investments'
    precondition:
    - predicate: not (A2.outcome == 2)
      hint: Asked only when question A2 is not "No".
    - predicate: not (E1.outcome == 2)
      hint: Asked only when question E1 is not "No".
    - predicate: not (E2.outcome == 0)
      hint: Asked only when question E2 is not 0.
    - predicate: not (E7a.outcome != 1 and E7b.outcome != 1 and E7c.outcome != 1 and E7d.outcome != 1)
      hint: Asked only when at least one savings plan type is used.
    items:
    - id: E8a
      kind: Question
      title: Within these plans, how are the savings invested? a) Mutual funds
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
    - id: E8b
      kind: Question
      title: b) Shares of corporations
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
    - id: E8c
      kind: Question
      title: c) Savings or chequing accounts
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
    - id: E8d
      kind: Question
      title: d) Savings bonds
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
    - id: E8e
      kind: Question
      title: e) Other
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
  - id: b_s10_resp
    title: 'Savings for other children: RESPs'
    precondition:
    - predicate: not (A2.outcome == 2)
      hint: Asked only when question A2 is not "No".
    - predicate: not (E1.outcome == 2)
      hint: Asked only when question E1 is not "No".
    - predicate: not (E2.outcome == 0)
      hint: Asked only when question E2 is not 0.
    - predicate: not (E7a.outcome != 1 and E7b.outcome != 1 and E7c.outcome != 1 and E7d.outcome != 1)
      hint: Asked only when at least one savings plan type is used.
    - predicate: not (E7a.outcome != 1)
      hint: Asked only when question E7a is "Yes".
    items:
    - id: E10
      kind: Question
      title: For the RESP only, how much money in total has been contributed to RESPs for these children by people living in your household? ($; Don't know; Refused)
      postcondition:
      - predicate: E10.outcome <= E6.outcome
        hint: The RESP contributions (E10) cannot exceed the total saved since starting (E6).
        invented: true
      input:
        control: Editbox
        min: 0
        max: 10000000
        left: $
    - id: E11a
      kind: Question
      title: E11. Which types of RESPs are being used? a) Individual plan (includes individual non-family and family RESPs)
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
    - id: E11b
      kind: Question
      title: b) Group plan (education scholarship trust or foundation)
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
  - id: b_s11_children_outside
    title: SECTION F - Children outside the household
    precondition:
    - predicate: not (A2.outcome == 2)
      hint: Asked only when question A2 is not "No".
    items:
    - id: F1
      kind: Question
      title: Are you or anyone else living in your household saving for the post-secondary education of any children 18 years of age or younger who do not live in your household?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: F2
      kind: Question
      title: For how many children is money being saved?
      input:
        control: Editbox
        min: 1
        max: 30
    - id: F3
      kind: Question
      title: What is the relationship of these children to the people saving money for them? (MARK ALL THAT APPLY)
      input:
        control: Checkbox
        labels:
          1: 01 — Son
          2: 02 — Daughter
          4: 03 — Grandson
          8: 04 — Granddaughter
          16: 05 — Brother
          32: 06 — Sister
          64: 07 — Niece
          128: 08 — Nephew
          256: 09 — Other family member or relative
          512: 10 — Unrelated
    - id: F4
      kind: Question
      title: How much money was saved for these children's education in 1998 by you or anyone else living in your household? Do not include any earnings or interest. ($; Don't know; Refused)
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
    - id: F5
      kind: Question
      title: How much money was saved for these children's education so far in 1999 by you or anyone else living in your household? Do not include any earnings or interest. ($; Don't know; Refused)
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
    - id: F6
      kind: Question
      title: How much money will you or anyone else in your household save for these children in the rest of 1999? ($; Don't know; Refused)
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
    - id: F7
      kind: Question
      title: Since starting to save for these children, how much money in total has been saved by you or anyone else in living in your household for their education? Do not include any earnings or interest. ($; Don't know; Refused)
      postcondition:
      - predicate: F7.outcome >= F4.outcome
        hint: The total saved since starting (F7) cannot be less than the amount saved in 1998 (F4).
        invented: true
      - predicate: F7.outcome >= F5.outcome
        hint: The total saved since starting (F7) cannot be less than the amount saved so far in 1999 (F5).
        invented: true
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
    - id: F8a
      kind: Question
      title: What types of savings plans are being used by people in your household to save for these children's post-secondary education? a) RESPs (Registered Education Savings Plans)
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
    - id: F8b
      kind: Question
      title: b) RRSPs (Registered Retirement Savings Plans)
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
    - id: F8c
      kind: Question
      title: c) "In-trust for" accounts
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
    - id: F8d
      kind: Question
      title: d) Other
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
    - id: F9a
      kind: Question
      title: Within these plans, how are the savings invested? a) Mutual funds
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
    - id: F9b
      kind: Question
      title: b) Shares of corporations
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
    - id: F9c
      kind: Question
      title: c) Savings or chequing accounts
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
    - id: F9d
      kind: Question
      title: d) Savings bonds
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
    - id: F9e
      kind: Question
      title: e) Other
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
    - id: F11
      kind: Question
      title: For the RESPs only, how much money in total has been contributed to RESPs for these children by people living in your household? ($; Don't know; Refused)
      postcondition:
      - predicate: F11.outcome <= F7.outcome
        hint: The RESP contributions (F11) cannot exceed the total saved since starting (F7).
        invented: true
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
    - id: F12a
      kind: Question
      title: F12. Which types of RESPs are being used? a) Individual plan (includes individual non-family and family RESPs)
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
    - id: F12b
      kind: Question
      title: b) Group plan (education scholarship trust or foundation)
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
  - id: b_s12_general
    title: SECTION G - General information
    precondition:
    - predicate: not (A2.outcome == 2)
      hint: Asked only when question A2 is not "No".
    items:
    - id: G2
      kind: Question
      title: Now I'd like to ask you some general questions about your household. Is there a computer available in your household that the children can use to do their school work or assignments?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
    - id: G3
      kind: Question
      title: Are there books or other reading materials in the home for the children to use to do school work or assignments? (e.g. encyclopaedias, reference books, CD ROMs)
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
    - id: G4
      kind: Question
      title: Thinking of the children in your household, to which ethnic or cultural group(s) do the ancestors of their mother belong? (MARK ALL THAT APPLY.)
      input:
        control: Checkbox
        labels:
          1: 01 — Canadian
          2: 02 — Chinese
          4: 03 — Dutch (Netherlands)
          8: 04 — English
          16: 05 — French
          32: 06 — German
          64: 07 — Inuit/Eskimo
          128: 08 — Irish
          256: 09 — Italian
          512: 10 — Jewish
          1024: 11 — Métis
          2048: 12 — North American Indian
          4096: 13 — Polish
          8192: 14 — Scottish
          16384: 15 — South Asian
          32768: 16 — Ukrainian
          65536: '17 — Other - Specify:'
          131072: 97 — Don't know
          262144: 98 — Refused
    - id: G5
      kind: Question
      title: Thinking of the children in your household, to which ethnic or cultural group(s) do the ancestors of their father belong? (MARK ALL THAT APPLY.)
      input:
        control: Checkbox
        labels:
          1: 18 — Canadian
          2: 19 — Chinese
          4: 20 — Dutch (Netherlands)
          8: 21 — English
          16: 22 — French
          32: 23 — German
          64: 24 — Inuit/Eskimo
          128: 25 — Irish
          256: 26 — Italian
          512: 27 — Jewish
          1024: 28 — Métis
          2048: 29 — North American Indian
          4096: 30 — Polish
          8192: 31 — Scottish
          16384: 32 — South Asian
          32768: 33 — Ukrainian
          65536: '34 — Other - Specify:'
          131072: 97 — Don't know
          262144: 98 — Refused
    - id: G6
      kind: Question
      title: What is the language spoken most often in your household? (ACCEPT MULTIPLE RESPONSES ONLY IF LANGUAGES ARE SPOKEN EQUALLY.)
      input:
        control: Checkbox
        labels:
          1: 01 — English
          2: 02 — French
          4: 03 — Arabic
          8: 04 — Chinese
          16: 05 — German
          32: 06 — Italian
          64: 07 — Polish
          128: 08 — Portuguese
          256: 09 — Punjabi
          512: 10 — Spanish
          1024: 11 — Tagalog (Filipino)
          2048: 12 — Vietnamese
          4096: '13 — Other language - Specify:'
          8192: 97 — Don't know
          16384: 98 — Refused
    - id: G7
      kind: Question
      title: What other languages are spoken in your household? (MARK ALL THAT APPLY.)
      input:
        control: Checkbox
        labels:
          1: 14 — English
          2: 15 — French
          4: 16 — Arabic
          8: 17 — Chinese
          16: 18 — German
          32: 19 — Italian
          64: 20 — Polish
          128: 21 — Portuguese
          256: 22 — Punjabi
          512: 23 — Spanish
          1024: 24 — Tagalog (Filipino)
          2048: 25 — Vietnamese
          4096: '27 — Other language - Specify:'
          8192: 26 — No other languages spoken
          16384: 97 — Don't know
          32768: 98 — Refused
    - id: G8
      kind: Question
      title: From the following list, what is your household's highest financial priority? (READ LIST.)
      input:
        control: Radio
        labels:
          1: Everyday budget
          2: Savings for post-secondary education
          3: Retirement savings
          4: Other savings
          7: Don't know
          8: Refused
    - id: G9
      kind: Question
      title: Thinking about your total household income, from which of the following sources did your household receive any income in the past 12 months? (READ LIST. MARK ALL THAT APPLY.)
      input:
        control: Checkbox
        labels:
          1: 01 — Wages and salaries
          2: 02 — Income from self-employment
          4: 03 — Dividends and interest (e.g. on bonds, deposits, etc.)
          8: 04 — Employment insurance
          16: 05 — Workers' compensation
          32: 06 — Benefits from Canada or Quebec Pension Plan
          64: 07 — Retirement pensions, superannuation and annuities
          128: 08 — Old Age Security and Guaranteed Income Supplement
          256: 09 — Child Tax Benefit
          512: 10 — Provincial or municipal social assistance or welfare
          1024: 11 — Child support
          2048: 12 — Alimony
          4096: 13 — Other
          8192: 14 — None
    - id: G10
      kind: Question
      title: What is your best estimate of the total income before taxes and deductions of all household members from all sources in the past 12 months? Was the total household income …
      input:
        control: Dropdown
        labels:
          1: Less than $20,000
          2: $20,000 or more
          3: No income
          4: Less than $10,000
          5: $10,000 or more
          6: Less than $40,000
          7: $40,000 or more
          8: Less than $5,000
          9: $5,000 or more
          10: Less than $15,000
          11: $15,000 or more
          12: Less than $30,000
          13: $30,000 or more
          14: Less than $50,000
          15: $50,000 to less than $60,000
          16: $60,000 to less than $80,000
          17: $80,000 or more
          97: Don't know
          98: Refused
    - id: G11
      kind: Question
      title: To avoid duplication, Statistics Canada has entered into a data sharing agreement under Section 12 of the Statistics Act with Human Resources Development Canada. Human Resources Development Canada will not be given your name or other identifiers and they have undertaken to keep the information confidential and to use it only for statistical puposes. Do you agree to let Statistics Canada share your information?
      input:
        control: Radio
        labels:
          4: 'Yes'
          5: 'No'
          7: Don't know
          8: Refused
    - id: G13
      kind: Question
      title: As part of a related statistical study, the information you provide during this interview, in future, may be combined with post-secondary school records about the children in your household. These records would be obtained by Statistics Canada from ministries of education or educational institutions. When combined with the information you have given us today, these records would be used to produce statistics on children's educational outcomes. Only aggregate statistics that do not identify you or the children would be released from this study. Do you agree to let Statistics Canada combine this information?
      precondition:
      - predicate: not (CHILDREN_0_18.outcome == 0)
        hint: Asked only when question CHILDREN_0_18 is not 0.
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know
          8: Refused
