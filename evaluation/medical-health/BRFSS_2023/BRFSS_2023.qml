qmlVersion: '2.7'
questionnaire:
  title: 2023 BRFSS Questionnaire
  blocks:
  - id: b_s1_screen
    title: Landline Introduction
    items:
    - id: LL01
      kind: Question
      title: Is this [PHONE NUMBER]?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: LL02
      kind: Question
      title: 'Is this a private residence? (Read if necessary: By private residence we mean someplace like a house or apartment. Do not read: Private residence includes any home where the respondent spends at least 30 days including vacation homes, RVs or other locations in which the respondent lives for portions of the year.)'
      precondition:
      - predicate: not (LL01.outcome == 2)
        hint: Asked only when question LL01. is not "No".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: No, this is a business
    - id: LL03
      kind: Question
      title: 'Do you live in college housing? (Read if necessary: By college housing we mean dormitory, graduate student or visiting faculty housing, or other housing arrangement provided by a college or university.)'
      precondition:
      - predicate: LL02.outcome == 2
        hint: Asked only when question LL02. is "No".
      - predicate: not (LL01.outcome == 2)
        hint: Asked only when question LL01. is not "No".
      - predicate: not (LL02.outcome == 1)
        hint: Asked only when question LL02. is not "Yes".
      - predicate: not (LL02.outcome == 3)
        hint: Asked only when question LL02. is not "No, this is a business".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
  - id: b_s1_main
    title: Eligibility and Respondent Selection
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    items:
    - id: LL04
      kind: Question
      title: Do you currently live in__(state)____?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: LL05
      kind: Question
      title: 'Is this a cell phone? (Read if necessary: By cell phone we mean a telephone that is mobile and usable outside your neighborhood. Do not read: Telephone service over the internet counts as landline service (includes Vonage, Magic Jack and other home-based phone services).)'
      precondition:
      - predicate: not (LL04.outcome == 2)
        hint: Asked only when question LL04. is not "No".
      input:
        control: Radio
        labels:
          1: Yes, it is a cell phone
          2: Not a cell phone
    - id: LL06
      kind: Question
      title: Are you 18 years of age or older?
      precondition:
      - predicate: not (LL04.outcome == 2)
        hint: Asked only when question LL04. is not "No".
      - predicate: not (LL05.outcome == 1)
        hint: Asked only when question LL05. is not "Yes, it is a cell phone".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: LL07
      kind: Question
      title: I need to randomly select one adult who lives in your household to be interviewed. Excluding adults living away from home, such as students away at college, how many members of your household, including yourself, are 18 years of age or older?
      precondition:
      - predicate: not (LL04.outcome == 2)
        hint: Asked only when question LL04. is not "No".
      - predicate: not (LL05.outcome == 1)
        hint: Asked only when question LL05. is not "Yes, it is a cell phone".
      - predicate: not (LL06.outcome == 1 and LL03.outcome == 1)
        hint: Not asked for college housing residents.
      - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
        hint: Not asked for college housing residents.
      input:
        control: Editbox
        min: 1
        max: 99
    - id: LL08
      kind: Question
      title: The person in your household that I need to speak with is the adult with the most recent birthday. Are you the adult with the most recent birthday?
      precondition:
      - predicate: LL07.outcome is not None and (LL07.outcome >= 2)
        hint: Asked only when two or more adults live in the household.
      - predicate: not (LL04.outcome == 2)
        hint: Asked only when question LL04. is not "No".
      - predicate: not (LL05.outcome == 1)
        hint: Asked only when question LL05. is not "Yes, it is a cell phone".
      - predicate: not (LL06.outcome == 1 and LL03.outcome == 1)
        hint: Not asked for college housing residents.
      - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
        hint: Not asked for college housing residents.
      - predicate: not (LL07.outcome == 1)
        hint: Asked only when question LL07. is not 1.
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: No - Ask for correct respondent
    - id: LL09
      kind: Question
      title: 'Are you? (Read: 1 Male 2 Female 3 Unspecified or another gender identity. Do not read: 7 Don''t know/Not sure, 9 Refused)'
      precondition:
      - predicate: not (LL04.outcome == 2)
        hint: Asked only when question LL04. is not "No".
      - predicate: not (LL05.outcome == 1)
        hint: Asked only when question LL05. is not "Yes, it is a cell phone".
      - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
        hint: Not asked for college housing residents.
      input:
        control: Radio
        labels:
          1: Male
          2: Female
          3: Unspecified or another gender identity
          7: Don't know/Not sure
          9: Refused
    - id: LL10
      kind: Question
      title: 'What was your sex at birth? Was it male or female? (Read if necessary: "What sex were you assigned at birth on your original birth certificate?")'
      precondition:
      - predicate: LL09.outcome in [3, 7, 9]
        hint: Asked only when question LL09. is one of "Unspecified or another gender identity", "Don't know/Not sure", "Refused".
      - predicate: not (LL04.outcome == 2)
        hint: Asked only when question LL04. is not "No".
      - predicate: not (LL05.outcome == 1)
        hint: Asked only when question LL05. is not "Yes, it is a cell phone".
      - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
        hint: Not asked for college housing residents.
      - predicate: not (LL09.outcome in [1, 2])
        hint: Asked only when question LL09. is none of "Male", "Female".
      input:
        control: Radio
        labels:
          1: Male
          2: Female
          7: Don't know/Not sure
          9: Refused
  - id: b_s2_cp01
    title: Cell Phone Introduction
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when LL06 and LL03 do not route the respondent out.
    - predicate: not (LL09.outcome in [1, 2])
      hint: Asked only when question LL09. is none of "Male", "Female".
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (LL10.outcome in [1, 2])
      hint: Asked only when question LL10 is none of "Male", "Female".
    items:
    - id: CP01
      kind: Question
      title: Is this a safe time to talk with you?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
  - id: b_s2_cp02_cp04
    title: Cell Phone Eligibility
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when LL06 and LL03 do not route the respondent out.
    - predicate: not (LL09.outcome in [1, 2])
      hint: Asked only when question LL09. is none of "Male", "Female".
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (LL10.outcome in [1, 2])
      hint: Asked only when question LL10 is none of "Male", "Female".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    items:
    - id: CP02
      kind: Question
      title: Is this [PHONE NUMBER]?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: CP03
      kind: Question
      title: Is this a cell phone?
      precondition:
      - predicate: not (CP02.outcome == 2)
        hint: Asked only when question CP02. is not "No".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: CP04
      kind: Question
      title: Are you 18 years of age or older?
      precondition:
      - predicate: not (CP02.outcome == 2)
        hint: Asked only when question CP02. is not "No".
      - predicate: not (CP03.outcome == 2)
        hint: Asked only when question CP03. is not "No".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
  - id: b_s2_cp05_cp06
    title: Sex and Gender
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when LL06 and LL03 do not route the respondent out.
    - predicate: not (LL09.outcome in [1, 2])
      hint: Asked only when question LL09. is none of "Male", "Female".
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (LL10.outcome in [1, 2])
      hint: Asked only when question LL10 is none of "Male", "Female".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    items:
    - id: CP05
      kind: Question
      title: 'Are you ? (Please read: 1 Male 2 Female 3 Unspecified or another gender identity. Do not read: 7 Don''t know/Not sure, 9 Refused)'
      input:
        control: Radio
        labels:
          1: Male
          2: Female
          3: Unspecified or another gender identity
          7: Don't know/Not sure
          9: Refused
    - id: CP06
      kind: Question
      title: 'What was your sex at birth? Was it male or female? (Read if necessary: "What sex were you assigned at birth on your original birth certificate?")'
      precondition:
      - predicate: CP05.outcome in [3, 7, 9]
        hint: Asked only when question CP05. is one of "Unspecified or another gender identity", "Don't know/Not sure", "Refused".
      - predicate: not (CP05.outcome in [1, 2])
        hint: Asked only when question CP05. is none of "Male", "Female".
      input:
        control: Radio
        labels:
          1: Male
          2: Female
          7: Don't know/Not sure
          9: Refused
  - id: b_s2_cp07_cp08
    title: Residence Type
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when LL06 and LL03 do not route the respondent out.
    - predicate: not (LL09.outcome in [1, 2])
      hint: Asked only when question LL09. is none of "Male", "Female".
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (LL10.outcome in [1, 2])
      hint: Asked only when question LL10 is none of "Male", "Female".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    items:
    - id: CP07
      kind: Question
      title: 'Do you live in a private residence? (Read if necessary: By private residence we mean someplace like a house or apartment. Do not read: Private residence includes any home where the respondent spends at least 30 days including vacation homes, RVs or other locations in which the respondent lives for portions of the year.)'
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: CP08
      kind: Question
      title: 'Do you live in college housing? (Read if necessary: By college housing we mean dormitory, graduate student or visiting faculty housing, or other housing arrangement provided by a college or university.)'
      precondition:
      - predicate: CP07.outcome == 2
        hint: Asked only when question CP07. is "No".
      - predicate: not (CP07.outcome == 1)
        hint: Asked only when question CP07. is not "Yes".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
  - id: b_s2_cp09_cp12
    title: State of Residence and Household
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when LL06 and LL03 do not route the respondent out.
    - predicate: not (LL09.outcome in [1, 2])
      hint: Asked only when question LL09. is none of "Male", "Female".
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (LL10.outcome in [1, 2])
      hint: Asked only when question LL10 is none of "Male", "Female".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    items:
    - id: CP09
      kind: Question
      title: Do you currently live in___(state)____?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: CP10
      kind: Question
      title: In what state do you currently live?
      precondition:
      - predicate: CP09.outcome == 2
        hint: Asked only when question CP09. is "No".
      - predicate: not (CP09.outcome == 1)
        hint: Asked only when question CP09. is not "Yes".
      input:
        control: Dropdown
        labels:
          1: Alabama
          2: Alaska
          4: Arizona
          5: Arkansas
          6: California
          8: Colorado
          9: Connecticut
          10: Delaware
          11: District of Columbia
          12: Florida
          13: Georgia
          15: Hawaii
          16: Idaho
          17: Illinois
          18: Indiana
          19: Iowa
          20: Kansas
          21: Kentucky
          22: Louisiana
          23: Maine
          24: Maryland
          25: Massachusetts
          26: Michigan
          27: Minnesota
          28: Mississippi
          29: Missouri
          30: Montana
          31: Nebraska
          32: Nevada
          33: New Hampshire
          34: New Jersey
          35: New Mexico
          36: New York
          37: North Carolina
          38: North Dakota
          39: Ohio
          40: Oklahoma
          41: Oregon
          42: Pennsylvania
          44: Rhode Island
          45: South Carolina
          46: South Dakota
          47: Tennessee
          48: Texas
          49: Utah
          50: Vermont
          51: Virginia
          53: Washington
          54: West Virginia
          55: Wisconsin
          56: Wyoming
          66: Guam
          72: Puerto Rico
          78: Virgin Islands
          77: Live outside US and participating territories
          99: Refused
    - id: CP11
      kind: Question
      title: 'Do you also have a landline telephone in your home that is used to make and receive calls? (Read if necessary: By landline telephone, we mean a regular telephone in your home that is used for making or receiving calls. Please include landline phones used for both business and personal use.)'
      precondition:
      - predicate: not (CP10.outcome in [77, 99])
        hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know/ Not sure
          9: Refused
    - id: CP12
      kind: Question
      title: How many members of your household, including yourself, are 18 years of age or older? (77 Don't know/ Not sure, 99 Refused)
      precondition:
      - predicate: not (CP08.outcome == 1)
        hint: Asked only when question CP08. is not "Yes".
      - predicate: not (CP10.outcome in [77, 99])
        hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
      input:
        control: Editbox
        min: 1
        max: 99
  - id: b_s3_health_status
    title: 'Core Section 1: Health Status'
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when question LL06 is not "No" together with LL03 being "Yes".
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    items:
    - id: CHS_01
      kind: Question
      title: Would you say that in general your health is—
      input:
        control: Radio
        labels:
          1: Excellent
          2: Very Good
          3: Good
          4: Fair
          5: Poor
          7: Don't know/Not sure
          9: Refused
  - id: b_s4_healthy_days
    title: 'Core Section 2: Healthy Days'
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when LL06 is not "No" together with LL03 "Yes".
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    items:
    - id: CHD_01
      kind: Question
      title: Now thinking about your physical health, which includes physical illness and injury, for how many days during the past 30 days was your physical health not good? (88 may be coded if respondent says "never" or "none". It is not necessary to ask respondents to provide a number if they indicate that this never occurs.)
      input:
        control: Editbox
        min: 1
        max: 99
        right: days (1-30; 88 = None, 77 = Don't know/not sure, 99 = Refused)
    - id: CHD_02
      kind: Question
      title: Now thinking about your mental health, which includes stress, depression, and problems with emotions, for how many days during the past 30 days was your mental health not good? (88 may be coded if respondent says "never" or "none". It is not necessary to ask respondents to provide a number if they indicate that this never occurs.)
      input:
        control: Editbox
        min: 1
        max: 99
        right: days (1-30; 88 = None, 77 = Don't know/not sure, 99 = Refused)
    - id: CHD_03
      kind: Question
      title: During the past 30 days, for about how many days did poor physical or mental health keep you from doing your usual activities, such as self-care, work, or recreation? (88 may be coded if respondent says "never" or "none". It is not necessary to ask respondents to provide a number if they indicate that this never occurs.)
      precondition:
      - predicate: not (CHD_01.outcome == 88 and CHD_02.outcome == 88)
        hint: Asked unless both physical and mental health days (CHD_01, CHD_02) were None.
      input:
        control: Editbox
        min: 1
        max: 99
        right: days (1-30; 88 = None, 77 = Don't know/not sure, 99 = Refused)
  - id: b_s5_health_care_access
    title: 'Core Section 3: Health Care Access'
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Not asked when LL06. is 2 and LL03. is "Yes".
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    items:
    - id: CHCA_01
      kind: Question
      title: What is the current source of your primary health insurance? (If respondent has multiple sources of insurance, ask for the one used most often. If respondents give the name of a health plan rather than the type of coverage ask whether this is insurance purchased independently, through their employer, or whether it is through Medicaid or CHIP.)
      input:
        control: Dropdown
        labels:
          1: A plan purchased through an employer or union (including plans purchased through another person's employer)
          2: A private nongovernmental plan that you or another family member buys on your own
          3: Medicare
          4: Medigap
          5: Medicaid
          6: Children's Health Insurance Program (CHIP)
          7: 'Military related health care: TRICARE (CHAMPUS) / VA health care / CHAMP-VA'
          8: Indian Health Service
          9: State sponsored health plan
          10: Other government program
          88: No coverage of any type
          77: Don't Know/Not Sure
          99: Refused
    - id: CHCA_02
      kind: Question
      title: 'Do you have one person or a group of doctors that you think of as your personal health care provider? (If no, read: Is there more than one, or is there no person who you think of as your personal doctor or health care provider? NOTE: if the respondent had multiple doctor groups then it would be more than one—but if they had more than one doctor in the same group it would be one.)'
      input:
        control: Radio
        labels:
          1: Yes, only one
          2: More than one
          3: 'No'
          7: Don’t know / Not sure
          9: Refused
    - id: CHCA_03
      kind: Question
      title: Was there a time in the past 12 months when you needed to see a doctor but could not because you could not afford it?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don’t know / Not sure
          9: Refused
    - id: CHCA_04
      kind: Question
      title: 'About how long has it been since you last visited a doctor for a routine checkup? (Read if necessary: A routine checkup is a general physical exam, not an exam for a specific injury, illness, or condition.)'
      input:
        control: Radio
        labels:
          1: Within the past year (anytime less than 12 months ago)
          2: Within the past 2 years (1 year but less than 2 years ago)
          3: Within the past 5 years (2 years but less than 5 years ago)
          4: 5 or more years ago
          7: Don’t know / Not sure
          8: Never
          9: Refused
  - id: b_s6_exercise
    title: Exercise
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when LL06 is not "No" for a respondent who answered "Yes" to LL03.
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    items:
    - id: CEXP_01
      kind: Question
      title: During the past month, other than your regular job, did you participate in any physical activities or exercises such as running, calisthenics, golf, gardening, or walking for exercise? (If respondent does not have a regular job or is retired, they may count the physical activity or exercise they spend the most time doing in a regular month. Physical activity done at a work gym during the workday would count)
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know/Not Sure
          9: Refused
  - id: b_s6_activity_main
    title: Main Activity
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when LL06 is not "No" for a respondent who answered "Yes" to LL03.
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    - predicate: not (CEXP_01.outcome in [2, 7, 9])
      hint: Asked only when question CEXP.01 is none of "No", "Don't know/Not Sure", "Refused".
    items:
    - id: CEXP_02
      kind: Question
      title: What type of physical activity or exercise did you spend the most time doing during the past month? (See Physical Activity Coding List. If the respondent's activity is not included in the physical activity coding list, choose the option listed as "other".)
      input:
        control: Editbox
        min: 1
        max: 99
        right: Activity code (77 = Don't know/Not Sure, 99 = Refused)
  - id: b_s6_activity_detail
    title: Main Activity Frequency and Duration
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when LL06 is not "No" for a respondent who answered "Yes" to LL03.
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    - predicate: not (CEXP_01.outcome in [2, 7, 9])
      hint: Asked only when question CEXP.01 is none of "No", "Don't know/Not Sure", "Refused".
    - predicate: not (CEXP_02.outcome in [77, 99])
      hint: Asked only when question CEXP.02 is none of "Don't know/ Not Sure", "Refused".
    items:
    - id: CEXP_03
      kind: Question
      title: How many times per week or per month did you take part in this activity during the past month? (If respondent confused, probe by explaining 'this is not asking for days per week or per month, but times per week or per month.')
      input:
        control: Radio
        labels:
          1: 1_ _ Times per week
          2: 2_ _ Times per month
          777: Don't know / Not sure
          999: Refused
    - id: CEXP_04
      kind: Question
      title: And when you took part in this activity, for how many minutes or hours did you usually keep at it? (Hours and minutes)
      input:
        control: Editbox
        min: 1
        max: 999
        right: Hours and minutes (777 = Don't know / Not sure, 999 = Refused)
    - id: CEXP_05
      kind: Question
      title: What other type of physical activity gave you the next most exercise during the past month? (See Physical Activity Coding List. If the respondent’s activity is not included in the physical activity coding list, choose the option listed as “other”.)
      input:
        control: Editbox
        min: 1
        max: 99
        right: Activity code (88 = No other activity, 77 = Don’t know/ Not Sure, 99 = Refused)
  - id: b_s6_activity_second
    title: Second Activity Frequency and Duration
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when LL06 is not "No" for a respondent who answered "Yes" to LL03.
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    - predicate: not (CEXP_01.outcome in [2, 7, 9])
      hint: Asked only when question CEXP.01 is none of "No", "Don't know/Not Sure", "Refused".
    - predicate: not (CEXP_02.outcome in [77, 99])
      hint: Asked only when question CEXP.02 is none of "Don't know/ Not Sure", "Refused".
    - predicate: not (CEXP_05.outcome in [88, 77, 99])
      hint: Asked only when question CEXP.05 is none of "No other activity", "Don’t know/ Not Sure", "Refused".
    items:
    - id: CEXP_06
      kind: Question
      title: How many times per week or per month did you take part in this activity during the past month?
      input:
        control: Radio
        labels:
          1: 1_ _ Times per week
          2: 2_ _ Times per month
          777: Don’t know / Not sure
          999: Refused
    - id: CEXP_07
      kind: Question
      title: And when you took part in this activity, for how many minutes or hours did you usually keep at it? (Hours and minutes)
      input:
        control: Editbox
        min: 1
        max: 999
        right: Hours and minutes (777 = Don’t know / Not sure, 999 = Refused)
  - id: b_s6_strength
    title: Muscle Strengthening
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when LL06 is not "No" for a respondent who answered "Yes" to LL03.
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    items:
    - id: CEXP_08
      kind: Question
      title: During the past month, how many times per week or per month did you do physical activities or exercises to strengthen your muscles? (Do not count aerobic activities like walking, running, or bicycling. Count activities using your own body weight like yoga, sit-ups or push-ups and those using weight machines, free weights, or elastic bands.)
      input:
        control: Radio
        labels:
          1: 1_ _ Times per week
          2: 2_ _ Times per month
          888: Never
          777: Don’t know / Not sure
          999: Refused
  - id: b_s7_hypertension
    title: 'Core Section 5: Hypertension Awareness'
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when question LL06 is not "No" while LL03 is "Yes".
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    items:
    - id: CHYPA_01
      kind: Question
      title: 'Have you ever been told by a doctor, nurse, or other health professional that you have high blood pressure? (If "Yes" and respondent is female, ask: "Was this only when you were pregnant?" By other health professional we mean nurse practitioner, a physician assistant, or some other licensed health professional.)'
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: Yes, but female told only during pregnancy
          3: 'No'
          4: Told borderline high or pre-hypertensive or elevated blood pressure
          7: Don't know / Not sure
          9: Refused
    - id: CHYPA_02
      kind: Question
      title: Are you currently taking prescription medicine for your high blood pressure?
      precondition:
      - predicate: not (CHYPA_01.outcome in [2, 3, 4, 7, 9])
        hint: Asked only when question CHYPA.01 is none of "Yes, but female told only during pregnancy", "No", "Told borderline high or pre-hypertensive or elevated blood pressure", "Don't know / Not sure", "Refused".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know / Not sure
          9: Refused
  - id: b_s8_cholesterol_check
    title: 'Core Section 6: Cholesterol Awareness'
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when LL06 and LL03 do not both indicate this exclusion.
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    items:
    - id: CCHLA_01
      kind: Question
      title: Cholesterol is a fatty substance found in the blood. About how long has it been since you last had your cholesterol checked?
      input:
        control: Radio
        labels:
          1: Never
          2: Within the past year (anytime less than one year ago)
          3: Within the past 2 years (1 year but less than 2 years ago)
          4: Within the past 3 years (2 years but less than 3 years ago)
          5: Within the past 4 years (3 years but less than 4 years ago)
          6: Within the past 5 years (4 years but less than 5 years ago)
          8: 5 or more years ago
          7: Don't know/ Not sure
          9: Refused
  - id: b_s8_cholesterol_followup
    title: Cholesterol diagnosis and medication
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when LL06 and LL03 do not both indicate this exclusion.
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    - predicate: not (CCHLA_01.outcome in [1, 7, 9])
      hint: Asked only when question CCHLA.01 is none of "Never", "Don't know/ Not sure", "Refused".
    items:
    - id: CCHLA_02
      kind: Question
      title: Have you ever been told by a doctor, nurse or other health professional that your cholesterol is high? (By other health professional we mean nurse practitioner, a physician assistant, or some other licensed health professional.)
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don’t know / Not sure
          9: Refused
    - id: CCHLA_03
      kind: Question
      title: 'Are you currently taking medicine prescribed by your doctor or other health professional for your cholesterol? (If respondent questions why they might take drugs without having high cholesterol read: Doctors might prescribe statin for those without high cholesterol but with high atherosclerotic cardiovascular disease risk)'
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don’t know / Not sure
          9: Refused
  - id: b_s9_chronic_conditions
    title: 'Core Section 7: Chronic Health Conditions'
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when the LL06 and LL03 answers allow it.
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    items:
    - id: CCHC_01
      kind: Question
      title: Ever told you that you had a heart attack also called a myocardial infarction?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know / Not sure
          9: Refused
    - id: CCHC_02
      kind: Question
      title: (Ever told) (you had) angina or coronary heart disease?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know / Not sure
          9: Refused
    - id: CCHC_03
      kind: Question
      title: (Ever told) (you had) a stroke?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know / Not sure
          9: Refused
    - id: CCHC_04
      kind: Question
      title: (Ever told) (you had) asthma?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know / Not sure
          9: Refused
    - id: CCHC_05
      kind: Question
      title: Do you still have asthma?
      precondition:
      - predicate: not (CCHC_04.outcome in [2, 7, 9])
        hint: Asked only when question CCHC.04 is none of "No", "Don't know / Not sure", "Refused".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know / Not sure
          9: Refused
    - id: CCHC_06
      kind: Question
      title: (Ever told) (you had) skin cancer that is not melanoma?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don’t know / Not sure
          9: Refused
    - id: CCHC_07
      kind: Question
      title: (Ever told) (you had) melanoma or any other types of cancer?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don’t know / Not sure
          9: Refused
    - id: CCHC_08
      kind: Question
      title: (Ever told) (you had) C.O.P.D. (chronic obstructive pulmonary disease), emphysema or chronic bronchitis?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don’t know / Not sure
          9: Refused
    - id: CCHC_09
      kind: Question
      title: (Ever told) (you had) a depressive disorder (including depression, major depression, dysthymia, or minor depression)?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don’t know / Not sure
          9: Refused
    - id: CCHC_10
      kind: Question
      title: 'Not including kidney stones, bladder infection or incontinence, were you ever told you had kidney disease? (Read if necessary: Incontinence is not being able to control urine flow.)'
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don’t know / Not sure
          9: Refused
    - id: CCHC_11
      kind: Question
      title: '(Ever told) (you had) some form of arthritis, rheumatoid arthritis, gout, lupus, or fibromyalgia? (Do not read: Arthritis diagnoses include: rheumatism, polymyalgia rheumatic, osteoarthritis (not osteoporosis), tendonitis, bursitis, bunion, tennis elbow, carpal tunnel syndrome, tarsal tunnel syndrome, joint infection, Reiter’s syndrome, ankylosing spondylitis; spondylosis, rotator cuff syndrome, connective tissue disease, scleroderma, polymyositis, Raynaud’s syndrome, vasculitis, giant cell arteritis, Henoch-Schonlein purpura, Wegener’s granulomatosis, polyarteritis nodosa)'
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don’t know / Not sure
          9: Refused
    - id: CCHC_12
      kind: Question
      title: '(Ever told) (you had) diabetes? (If yes and respondent is female, ask: was this only when you were pregnant? If respondent says pre-diabetes or borderline diabetes, use response code 4.)'
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: Yes, but female told only during pregnancy
          3: 'No'
          4: No, pre-diabetes or borderline diabetes
          7: Don’t know / Not sure
          9: Refused
    - id: CCHC_13
      kind: Question
      title: How old were you when you were first told you had diabetes? (Code age in years [97 = 97 and older])
      precondition:
      - predicate: not (CCHC_12.outcome in [2, 3, 4, 7, 9])
        hint: Asked only when question CCHC.12 is none of "Yes, but female told only during pregnancy", "No", "No, pre-diabetes or borderline diabetes", "Don’t know / Not sure", "Refused".
      input:
        control: Editbox
        min: 1
        max: 99
        right: years (97 = 97 and older; 98 = Don‘t know / Not sure; 99 = Refused)
  - id: b_s10_demographics
    title: 'Core Section 8: Demographics'
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when LL06 is not "No" while LL03 is "Yes".
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    items:
    - id: CDEM_01
      kind: Question
      title: What is your age? (Code age in years)
      input:
        control: Editbox
        min: 0
        max: 99
        right: years (7 = Don't know / Not sure, 9 = Refused)
      postcondition:
      - predicate: CDEM_01.outcome in [7, 9] or CCHC_13.outcome in [98, 99] or CCHC_13.outcome <= CDEM_01.outcome
        hint: Age when first told you had diabetes (CCHC.13) cannot be greater than your current age (CDEM.01).
        invented: true
    - id: CDEM_02
      kind: Question
      title: 'Are you Hispanic, Latino/a, or Spanish origin? (If yes, read: Are you… One or more categories may be selected.)'
      input:
        control: Checkbox
        labels:
          1: 1 — Mexican, Mexican American, Chicano/a
          2: 2 — Puerto Rican
          4: 3 — Cuban
          8: 4 — Another Hispanic, Latino/a, or Spanish origin
          16: 5 — No (do not read)
          32: 7 — Don't know / Not sure (do not read)
          64: 9 — Refused (do not read)
    - id: CDEM_03
      kind: Question
      title: Which one or more of the following would you say is your race? (If 40 (Asian) or 50 (Pacific Islander) is selected read and code subcategories underneath major heading. One or more categories may be selected. If respondent indicates that they are Hispanic for race, please read the race choices.)
      input:
        control: Checkbox
        labels:
          1: 10 — White
          2: 20 — Black or African American
          4: 30 — American Indian or Alaska Native
          8: 40 — Asian
          16: 41 — Asian Indian
          32: 42 — Chinese
          64: 43 — Filipino
          128: 44 — Japanese
          256: 45 — Korean
          512: 46 — Vietnamese
          1024: 47 — Other Asian
          2048: 50 — Pacific Islander
          4096: 51 — Native Hawaiian
          8192: 52 — Guamanian or Chamorro
          16384: 53 — Samoan
          32768: 54 — Other Pacific Islander
          65536: 60 — Other (do not read)
          131072: 88 — No additional choices (do not read)
          262144: 77 — Don't know / Not sure (do not read)
          524288: 99 — Refused (do not read)
    - id: CDEM_04
      kind: Question
      title: Are you…
      input:
        control: Radio
        labels:
          1: Married
          2: Divorced
          3: Widowed
          4: Separated
          5: Never married
          6: A member of an unmarried couple
          9: Refused
    - id: CDEM_05
      kind: Question
      title: What is the highest grade or year of school you completed?
      input:
        control: Radio
        labels:
          1: Never attended school or only attended kindergarten
          2: Grades 1 through 8 (Elementary)
          3: Grades 9 through 11 (Some high school)
          4: Grade 12 or GED (High school graduate)
          5: College 1 year to 3 years (Some college or technical school)
          6: College 4 years or more (College graduate)
          9: Refused
    - id: CDEM_06
      kind: Question
      title: 'Do you own or rent your home? (Other arrangement may include group home, staying with friends or family without paying rent. Home is defined as the place where you live most of the time/the majority of the year. Read if necessary: We ask this question in order to compare health indicators among people with different housing situations.)'
      input:
        control: Radio
        labels:
          1: Own
          2: Rent
          3: Other arrangement
          7: Don't know / Not sure
          9: Refused
    - id: CDEM_07
      kind: Question
      title: In what county do you currently live? (ANSI County Code)
      input:
        control: Editbox
        min: 1
        max: 999
        right: (777 = Don’t know / Not sure, 888 = County from another state (cell phone data only), 999 = Refused)
    - id: CDEM_08
      kind: Question
      title: What is the ZIP Code where you currently live?
      input:
        control: Editbox
        min: 0
        max: 99999
        right: (77777 = Do not know, 99999 = Refused)
  - id: b_s10_landline
    title: Landline telephones
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when LL06 is not "No" while LL03 is "Yes".
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    - predicate: not (CELL_INTERVIEW.outcome == 1)
      hint: Asked only when question CELL_INTERVIEW is not "Cell phone interview".
    items:
    - id: CDEM_09
      kind: Question
      title: Not including cell phones or numbers used for computers, fax machines or security systems, do you have more than one landline telephone number in your household?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don’t know / Not sure
          9: Refused
    - id: CDEM_10
      kind: Question
      title: How many of these landline telephone numbers are residential numbers?
      precondition:
      - predicate: not (CDEM_09.outcome in [2, 7, 9])
        hint: Asked only when question CDEM.09 is none of "No", "Don’t know / Not sure", "Refused".
      input:
        control: Editbox
        min: 1
        max: 9
        right: (1-5; 6 = Six or more, 7 = Don’t know / Not sure, 8 = None, 9 = Refused)
  - id: b_s10_household
    title: Cell phones, service, work and income
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when LL06 is not "No" while LL03 is "Yes".
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    items:
    - id: CDEM_11
      kind: Question
      title: 'How many cell phones do you have for personal use? (Read if necessary: Include cell phones used for both business and personal use.) (Last question needed for partial complete.)'
      input:
        control: Editbox
        min: 1
        max: 9
        right: (1-5; 6 = Six or more, 7 = Don’t know / Not sure, 8 = None, 9 = Refused)
    - id: CDEM_12
      kind: Question
      title: 'Have you ever served on active duty in the United States Armed Forces, either in the regular military or in a National Guard or military reserve unit? (Read if necessary: Active duty does not include training for the Reserves or National Guard, but DOES include activation, for example, for the Persian Gulf War.)'
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know / Not sure
          9: Refused
    - id: CDEM_13
      kind: Question
      title: Are you currently…? (If more than one, say "select the category which best describes you".)
      input:
        control: Radio
        labels:
          1: Employed for wages
          2: Self-employed
          3: Out of work for 1 year or more
          4: Out of work for less than 1 year
          5: A Homemaker
          6: A Student
          7: Retired
          8: Unable to work
          9: Refused
    - id: CDEM_14
      kind: Question
      title: How many children less than 18 years of age live in your household?
      input:
        control: Editbox
        min: 1
        max: 99
        right: (88 = None, 99 = Refused)
    - id: CDEM_15
      kind: Question
      title: Is your annual household income from all sources— (If respondent refuses at ANY income level, code '99' (Refused). SEE CATI information of order of coding; Start with category 05 and move up or down categories.)
      input:
        control: Dropdown
        labels:
          1: Less than $10,000?
          2: Less than $15,000? ($10,000 to less than $15,000)
          3: Less than $20,000? ($15,000 to less than $20,000)
          4: Less than $25,000 ($20,000 to less than $25,000)
          5: Less than $35,000 ($25,000 to less than $35,000)
          6: Less than $50,000 ($35,000 to less than $50,000)
          7: Less than $75,000? ($50,000 to less than $75,000)
          8: Less than $100,000? ($75,000 to less than $100,000)
          9: Less than $150,000? ($100,000 to less than $150,000)?
          10: Less than $200,000? ($150,000 to less than $200,000)
          11: $200,000 or more
          77: Don’t know / Not sure
          99: Refused
  - id: b_s10_body
    title: Pregnancy, weight and height
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when LL06 is not "No" while LL03 is "Yes".
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    items:
    - id: CDEM_16
      kind: Question
      title: To your knowledge, are you now pregnant?
      precondition:
      - predicate: not (MSAB_01.outcome == 1 or CP05_2.outcome == 1 or LL09_2.outcome == 1 or CDEM_01.outcome > 49)
        hint: Asked only when MSAB.01, CP05.2 and LL09.2 are not "Yes" and age (CDEM.01) is 49 or under.
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don’t know / Not sure
          9: Refused
    - id: CDEM_17
      kind: Question
      title: About how much do you weigh without shoes? (Weight in pounds/kilograms. If respondent answers in metrics, put 9 in first column. Round fractions up)
      input:
        control: Editbox
        min: 1
        max: 9999
        right: (7777 = Don’t know / Not sure, 9999 = Refused)
    - id: CDEM_18
      kind: Question
      title: About how tall are you without shoes? (Height ft / inches/meters/centimeters. If respondent answers in metrics, put 9 in first column. Round fractions down)
      input:
        control: Textarea
        placeholder: Height (77/ 77 = Don’t know / Not sure, 99/ 99 = Refused)
        maxLength: 20
  - id: b_s11_disability
    title: 'Core Section 9: Disability'
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when LL06 is not "No" together with LL03 being "Yes".
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    items:
    - id: CDIS_01
      kind: Question
      title: Some people who are deaf or have serious difficulty hearing use assistive devices to communicate by phone. Are you deaf or do you have serious difficulty hearing?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know / Not sure
          9: Refused
    - id: CDIS_02
      kind: Question
      title: Are you blind or do you have serious difficulty seeing, even when wearing glasses?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know / Not sure
          9: Refused
    - id: CDIS_03
      kind: Question
      title: Because of a physical, mental, or emotional condition, do you have serious difficulty concentrating, remembering, or making decisions?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know / Not sure
          9: Refused
    - id: CDIS_04
      kind: Question
      title: Do you have serious difficulty walking or climbing stairs?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know / Not sure
          9: Refused
    - id: CDIS_05
      kind: Question
      title: Do you have difficulty dressing or bathing?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know / Not sure
          9: Refused
    - id: CDIS_06
      kind: Question
      title: Because of a physical, mental, or emotional condition, do you have difficulty doing errands alone such as visiting a doctor’s office or shopping?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don’t know / Not sure
          9: Refused
  - id: b_s12_falls
    title: 'Core Section 10: Falls'
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when LL06 is not "No" together with LL03 being "Yes".
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    - predicate: not (CDEM_01.outcome >= 18 and CDEM_01.outcome <= 44)
      hint: Asked only of respondents aged 45 or older.
    items:
    - id: CFAL_01
      kind: Question
      title: 'In the past 12 months, how many times have you fallen? (Read if necessary: By a fall, we mean when a person unintentionally comes to rest on the ground or another lower level.) [76 = 76 or more]'
      input:
        control: Editbox
        min: 1
        max: 99
        right: times (88 = None, 77 = Don't know / Not sure, 99 = Refused)
    - id: CFAL_02
      kind: Question
      title: 'How many of these falls caused an injury that limited your regular activities for at least a day or caused you to go to see a doctor? (Read if necessary: By an injury, we mean the fall caused you to limit your regular activities for at least a day or to go see a doctor.) [76 = 76 or more]'
      precondition:
      - predicate: not (CFAL_01.outcome in [88, 77, 99])
        hint: Asked only when question CFAL.01 is none of "None", "Don't know / Not sure", "Refused".
      postcondition:
      - predicate: CFAL_02.outcome in [77, 88, 99] or CFAL_01.outcome in [77, 88, 99] or CFAL_02.outcome <= CFAL_01.outcome
        hint: The number of falls that caused an injury (CFAL.02) cannot be greater than the total number of falls (CFAL.01).
        invented: true
      input:
        control: Editbox
        min: 1
        max: 99
        right: falls (88 = None, 77 = Don't know / Not sure, 99 = Refused)
  - id: b_s13_tobacco
    title: 'Core Section 11: Tobacco Use'
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when LL06 and LL03 do not both exclude this respondent.
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    items:
    - id: CTOB_01
      kind: Question
      title: 'Have you smoked at least 100 cigarettes in your entire life? (Do not include: electronic cigarettes (e-cigarettes, njoy, bluetip, JUUL), herbal cigarettes, cigars, cigarillos, little cigars, pipes, bidis, kreteks, water'
      input:
        control: Radio
        labels:
          1: 'Yes'
  - id: b_s14_external
    title: External inputs
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when LL06. is not "No" while LL03. is "Yes".
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    - predicate: not (CTOB_01.outcome in [2, 7, 9])
      hint: Asked only when question CTOB.01 is none of 2, 7, 9.
    items:
    - id: MSAB_01
      kind: Question
      title: 'External input: sex variable from another module, referenced in the CDEM.15 skip (Male coded 1)'
      external: true
      input:
        control: Radio
        labels:
          1: Male
    - id: CP05_2
      kind: Question
      title: 'External input: variable from another module referenced in the CDEM.15 skip (coded 1)'
      external: true
      input:
        control: Radio
        labels:
          1: '1'
    - id: LL09_2
      kind: Question
      title: 'External input: variable from another module referenced in the CDEM.15 skip (coded 1)'
      external: true
      input:
        control: Radio
        labels:
          1: '1'
    - id: CELL_INTERVIEW
      kind: Question
      title: 'External input: whether the interview is conducted on a cell phone (sample/call type), referenced as ''If cell interview go to CDEM11'''
      external: true
      input:
        control: Radio
        labels:
          1: Cell phone interview
          2: Landline interview
  - id: b_s15_tobacco
    title: Tobacco Use
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when LL06 and LL03 do not both indicate a skip.
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    items:
    - id: CTOB_02
      kind: Question
      title: Do you now smoke cigarettes every day, some days, or not at all?
      precondition:
      - predicate: not (CTOB_01.outcome in [2, 7, 9])
        hint: Asked only when question CTOB.01 is none of 2, 7, 9.
      input:
        control: Radio
        labels:
          1: Every day
          2: Some days
          3: Not at all
          7: Don’t know / Not sure
          9: Refused
    - id: CTOB_03
      kind: Question
      title: 'Do you currently use chewing tobacco, snuff, or snus every day, some days, or not at all? Read if necessary: Snus (Swedish for snuff) is a moist smokeless tobacco, usually sold in small pouches that are placed under the lip against the gum.'
      input:
        control: Radio
        labels:
          1: Every day
          2: Some days
          3: Not at all
          7: Don’t know / Not sure
          9: Refused
    - id: CTOB_04
      kind: Question
      title: 'Would you say you have never used e-cigarettes or other electronic vaping products in your entire life or now use them every day, use them some days, or used them in the past but do not currently use them at all? Interviewer note: These questions concern electronic vaping products for nicotine use. The use of electronic vaping products for marijuana use is not included in these questions. If respondent says “Not at all” ask that they do not mean “Never used e-cigs in your entire life”'
      input:
        control: Radio
        labels:
          1: Never used e-cigarettes in your entire life
          2: Use them every day
          3: Use them some days
          4: Not at all (right now)
          7: Don’t know / Not sure
          9: Refused
  - id: b_s16_frequency
    title: 'Core Section 12: Alcohol Consumption'
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when question LL06. is not "No" while LL03. is "Yes".
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    items:
    - id: CALC_01
      kind: Question
      title: 'During the past 30 days, how many days per week or per month did you have at least one drink of any alcoholic beverage? (1 _ _ Days per week; 2 _ _ Days in past 30 days) Read if necessary: A 40-ounce beer would count as 3 drinks, or a cocktail drink with 2 shots would count as 2 drinks.'
      input:
        control: Radio
        labels:
          1: Days per week
          2: Days in past 30 days
          888: No drinks in past 30 days
          777: Don’t know / Not sure
          999: Refused
    - id: CALC_01n
      kind: Question
      title: 'Number of days entered in the two-digit slot (_ _) of CALC.01, in the unit chosen there (days per week or days in past 30 days). Id and entry added by the inventory: the source prints the count slot inside CALC.01.'
      precondition:
      - predicate: CALC_01.outcome in [1, 2]
        hint: Asked only when question CALC.01 is one of "Days per week", "Days in past 30 days".
      - predicate: not (CALC_01.outcome in [888, 777, 999])
        hint: Asked only when question CALC.01 is none of "No drinks in past 30 days", "Don’t know / Not sure", "Refused".
      postcondition:
      - predicate: (CALC_01.outcome != 1 or CALC_01n.outcome <= 7) and (CALC_01.outcome != 2 or CALC_01n.outcome <= 30)
        hint: The number of days in CALC.01 cannot exceed 7 when reported per week or 30 when reported for the past 30 days; please correct the count.
        invented: true
      input:
        control: Editbox
        min: 0
        max: 30
  - id: b_s16_drinkers
    title: 'Alcohol Consumption: Drinking Days'
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when question LL06. is not "No" while LL03. is "Yes".
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    - predicate: not (CALC_01.outcome in [888, 777, 999])
      hint: Asked only when question CALC.01 is none of "No drinks in past 30 days", "Don’t know / Not sure", "Refused".
    items:
    - id: CALC_02
      kind: Question
      title: 'During the past 30 days, on the days when you drank, about how many drinks did you drink on the average? (_ _ Number of drinks) Read if necessary: A 40-ounce beer would count as 3 drinks, or a cocktail drink with 2 shots would count as 2 drinks. (88 = None, 77 = Don’t know / Not sure, 99 = Refused)'
      input:
        control: Editbox
        min: 0
        max: 99
    - id: CALC_03
      kind: Question
      title: Considering all types of alcoholic beverages, how many times during the past 30 days did you have X [CATI X = 5 for men, X = 4 for women] or more drinks on an occasion? (_ _ Number of times) (states may use sex at birth to determine sex if module is adopted) (88 = no days, 77 = Don’t know / Not sure, 99 = Refused)
      input:
        control: Editbox
        min: 0
        max: 99
    - id: CALC_04
      kind: Question
      title: During the past 30 days, what is the largest number of drinks you had on any occasion? (_ _ Number of drinks) (77 = Don’t know / Not sure, 99 = Refused)
      postcondition:
      - predicate: CALC_02.outcome >= 77 or CALC_04.outcome >= 77 or CALC_04.outcome >= CALC_02.outcome
        hint: The largest number of drinks on any occasion (CALC.04) cannot be less than the average number of drinks on drinking days (CALC.02).
        invented: true
      input:
        control: Editbox
        min: 0
        max: 99
  - id: b_s17_immunization
    title: 'Core Section 13: Immunization'
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when the landline and private residence screening answers allow it.
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    items:
    - id: CIMM_01
      kind: Question
      title: 'During the past 12 months, have you had either a flu vaccine that was sprayed in your nose or a flu shot injected into your arm? Read if necessary: A new flu shot came out in 2011 that injects vaccine into the skin with a very small needle. It is called Fluzone Intradermal vaccine. This is also considered a flu shot.'
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know / Not sure
          9: Refused
    - id: CIMM_02
      kind: Question
      title: During what month and year did you receive your most recent flu vaccine that was sprayed in your nose or flu shot injected into your arm? (__ / _ _ _ _ Month / Year)
      precondition:
      - predicate: not (CIMM_01.outcome in [2, 7, 9])
        hint: Asked only when question CIMM.01 is none of "No", "Don't know / Not sure", "Refused".
      input:
        control: Textarea
        placeholder: MM / YYYY (77 / 7777 Don't know / Not sure; 09 / 9999 Refused)
    - id: CIMM_03
      kind: Question
      title: 'Have you ever had a pneumonia shot also known as a pneumococcal vaccine? Read if necessary: There are two types of pneumonia shots: polysaccharide, also known as Pneumovax, and conjugate, also known as Prevnar.'
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know / Not sure
          9: Refused
    - id: CIMM_04
      kind: Question
      title: 'Have you ever had the shingles or zoster vaccine? Shingles is an illness that results in a rash or blisters on the skin, and is usually painful. There are two vaccines now available for shingles: Zostavax, which requires 1 shot and Shingrix which requires 2 shots.'
      precondition:
      - predicate: not (CDEM_01.outcome < 50)
        hint: Asked only of respondents aged 50 or older.
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know / Not sure
          9: Refused
  - id: b_s18_hiv
    title: 'Core Section 14: H.I.V./AIDS'
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Not asked when LL06. is 2 and LL03. is 1.
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    items:
    - id: CHIV_01
      kind: Question
      title: Including fluid testing from your mouth, but not including tests you may have had for blood donation, have you ever been tested for H.I.V? Please remember that your answers are strictly confidential and that you don't have to answer every question if you do not want to. Although we will ask you about testing, we will not ask you about the results of any test you may have had.
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know/ not sure
          9: Refused
    - id: CHIV_02
      kind: Question
      title: 'Not including blood donations, in what month and year was your last H.I.V. test? (__ /_ _ _ _ Code month and year) If response is before January 1985, code "777777". INTERVIEWER NOTE: If the respondent remembers the year but cannot remember the month, code the first two digits 77 and the last four digits for the year. (777777 = 77/ 7777 Don''t know / Not sure; 999999 = 99/ 9999 Refused)'
      precondition:
      - predicate: not (CHIV_01.outcome in [2, 7, 9])
        hint: Asked only when question CHIV.01 is none of "No", "Don't know/ not sure", "Refused".
      input:
        control: Textarea
  - id: b_s19_seatbelt_drinking
    title: 'Core Section 15: Seat Belt Use / Drinking and Driving'
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when LL06 is not "2" while LL03 is "1".
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    items:
    - id: CSBD_01
      kind: Question
      title: How often do you use seat belts when you drive or ride in a car? Would you say—
      input:
        control: Radio
        labels:
          1: Always
          2: Nearly always
          3: Sometimes
          4: Seldom
          5: Never
          7: Don't know / Not sure
          8: Never drive or ride in a car
          9: Refused
    - id: CSBD_02_note
      kind: Comment
      title: Enter the number of times. Code 88 for None, 77 for Don't know / Not sure, 99 for Refused.
      precondition:
      - predicate: not (CSBD_01.outcome == 8) and not (CALC_01.outcome == 888)
        hint: Shown only when the respondent drives and had drinks in the past 30 days.
    - id: CSBD_02
      kind: Question
      title: During the past 30 days, how many times have you driven when you've had perhaps too much to drink? (_ _ Number of times)
      precondition:
      - predicate: not (CSBD_01.outcome == 8)
        hint: Asked only when question CSBD.01 is not "Never drive or ride in a car".
      - predicate: not (CALC_01.outcome == 888)
        hint: Asked only when question CALC.01 is not "No drinks in past 30 days".
      input:
        control: Editbox
        min: 0
        max: 99
        right: times
  - id: b_s20_covid_history
    title: 'Emerging Core: Long-term COVID Effects'
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when LL06 is not "No" while LL03 is "Yes".
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    items:
    - id: COVID_01
      kind: Question
      title: Have you ever tested positive for COVID-19 (using a rapid point-of-care test, self-test, or laboratory test) or been told by a doctor or other health care provider that you have or had COVID-19? Positive tests include antibody or blood testing as well as other forms of testing for COVID, such a nasal swabbing or throat swabbing including home tests.
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know / Not sure
          9: Refused
  - id: b_s20_long_covid
    title: Long-term COVID Symptoms
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when LL06 is not "No" while LL03 is "Yes".
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    - predicate: not (COVID_01.outcome in [2, 7, 9])
      hint: Asked only when question COVID.01 is none of "No", "Don't know / Not sure", "Refused".
    items:
    - id: COVID_02
      kind: Question
      title: 'Do you currently have symptoms lasting 3 months or longer that you did not have prior to having coronavirus or COVID-19? Long term conditions may be an indirect effect of COVID 19. Read if necessary: - Tiredness or fatigue - Difficulty thinking or concentrating or forgetfulness/ memory problems (sometimes referred to as "brain fog") - Difficulty breathing or shortness of breath - Joint or muscle pain - Fast-beating or pounding heart (also known as heart palpitations) or chest pain - Dizziness on standing -menstrual changes - Symptoms that get worse after physical or mental activities -Loss of taste or smell'
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know / Not sure
          9: Refused
    - id: COVID_03
      kind: Question
      title: Do these long-term symptoms reduce your ability to carry out day-to-day activities compared with the time before you COVID-19? (Please read)
      precondition:
      - predicate: not (COVID_02.outcome in [2, 7, 9])
        hint: Asked only when question COVID.02 is none of "No", "Don't know / Not sure", "Refused".
      input:
        control: Radio
        labels:
          1: Yes, a lot
          2: Yes, a little
          3: Not at all
          7: Don’t know / Not sure
          9: Refused
  - id: b_s21_prediabetes
    title: 'Module 1: Prediabetes'
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Not asked when LL06 is 2 and LL03 is Yes.
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    - predicate: not (COVID_01.outcome in [2, 7, 9])
      hint: Asked only when question COVID.01 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (COVID_02.outcome in [2, 7, 9])
      hint: Asked only when question COVID.02 is none of "No", "Don't know / Not sure", "Refused".
    items:
    - id: MPDIAB_01
      kind: Question
      title: When was the last time you had a blood test for high blood sugar or diabetes by a doctor, nurse, or other health professional?
      precondition:
      - predicate: CCHC_12.outcome != 1
        hint: Asked only when question CCHC.12 is not "Yes".
      input:
        control: Radio
        labels:
          1: Within the past year (anytime less than 12 months ago)
          2: Within the last 2 years (1 year but less than 2 years ago)
          3: Within the last 3 years (2 years but less than 3 years ago)
          4: Within the last 5 years (3 to 4 years but less than 5 years ago)
          5: Within the last 10 years (5 to 9 years but less than 10 years ago)
          6: 10 years ago or more
          7: Don’t know / Not sure
          8: Never
          9: Refused
    - id: MPDIAB_02
      kind: Question
      title: 'Has a doctor or other health professional ever told you that you had prediabetes or borderline diabetes? If Yes and respondent is female, ask: Was this only when you were pregnant? (If CCHC.12 is coded 4, automatically code MPDIAB.02 equal to 1 (yes))'
      precondition:
      - predicate: CCHC_12.outcome != 1 and CCHC_12.outcome != 4
        hint: Asked only when question CCHC.12 is neither "Yes" nor coded 4.
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: Yes, during pregnancy
          3: 'No'
          7: Don’t know / Not sure
          9: Refused
  - id: b_s22_diabetes
    title: 'Module 2: Diabetes'
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Not asked when LL06. is "No" and LL03. is "Yes".
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    - predicate: not (COVID_01.outcome in [2, 7, 9])
      hint: Asked only when question COVID.01 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (COVID_02.outcome in [2, 7, 9])
      hint: Asked only when question COVID.02 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: CCHC_12.outcome == 1
      hint: Asked only when question CCHC.12 is "Yes".
    items:
    - id: MDIAB_01
      kind: Question
      title: According to your doctor or other health professional, what type of diabetes do you have?
      input:
        control: Radio
        labels:
          1: Type 1
          2: Type 2
          7: Don't know/ Not sure
          9: Refused
    - id: MDIAB_02
      kind: Question
      title: Insulin can be taken by shot or pump. Are you now taking insulin?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know/ not sure
          9: Refused
    - id: MDIAB_03
      kind: Question
      title: 'About how many times in the past 12 months has a doctor, nurse, or other health professional checked you for A-one-C? (_ _ Number of times [76 = 76 or more]) Read if necessary: A test for A-one-C measures the average level of blood sugar over the past three months. (88 = None, 98 = Never heard of A-one-C test, 77 = Don''t know / Not sure, 99 = Refused)'
      input:
        control: Editbox
        min: 0
        max: 99
    - id: MDIAB_04
      kind: Question
      title: When was the last time you had an eye exam in which the pupils were dilated, making you temporarily sensitive to bright light?
      input:
        control: Radio
        labels:
          1: Within the past month (anytime less than 1 month ago)
          2: Within the past year (1 month but less than 12 months ago)
          3: Within the past 2 years (1 year but less than 2 years ago)
          4: 2 or more years ago
          7: Don't know / Not sure
          8: Never
          9: Refused
    - id: MDIAB_05
      kind: Question
      title: When was the last time a doctor, nurse or other health professional took a photo of the back of your eye with a specialized camera?
      input:
        control: Radio
        labels:
          1: Within the past month (anytime less than 1 month ago)
          2: Within the past year (1 month but less than 12 months ago)
          3: Within the past 2 years (1 year but less than 2 years ago)
          4: 2 or more years ago
          7: Don't know / Not sure
          8: Never
          9: Refused
    - id: MDIAB_06
      kind: Question
      title: When was the last time you took a course or class in how to manage your diabetes yourself?
      input:
        control: Dropdown
        labels:
          1: Within the past year (anytime less than 12 months ago)
          2: Within the last 2 years (1 year but less than 2 years ago)
          3: Within the last 3 years (2 years but less than 3 years ago)
          4: Within the last 5 years (3 to 4 years but less than 5 years ago)
          5: Within the last 10 years (5 to 9 years but less than 10 years ago)
          6: 10 years ago or more
          7: Don’t know / Not sure
          8: Never
          9: Refused
    - id: MDIAB_07
      kind: Question
      title: Have you ever had any sores or irritations on your feet that took more than four weeks to heal?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don’t know / Not sure
          9: Refused
  - id: b_s23_arthritis
    title: 'Module 3 : Arthritis'
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when LL06. is not "No" while LL03. is "Yes".
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    - predicate: not (COVID_01.outcome in [2, 7, 9])
      hint: Asked only when question COVID.01 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (COVID_02.outcome in [2, 7, 9])
      hint: Asked only when question COVID.02 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: CCHC_11.outcome == 1
      hint: Asked only when question CCHC.11 is "Yes".
    items:
    - id: MARTH_01
      kind: Question
      title: Has a doctor or other health professional ever suggested physical activity or exercise to help your arthritis or joint symptoms? If the respondent is unclear about whether this means increase or decrease in physical activity, this means increase.
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know / Not sure
          9: Refused
    - id: MARTH_02
      kind: Question
      title: Have you ever taken an educational course or class to teach you how to manage problems related to your arthritis or joint symptoms?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know / Not sure
          9: Refused
    - id: MARTH_03
      kind: Question
      title: 'Are you now limited in any way in any of your usual activities because of arthritis or joint symptoms? If a respondent question arises about medication, then the interviewer should reply: "Please answer the question based on your current experience, regardless of whether you are taking any medication or treatment"'
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know / Not sure
          9: Refused
    - id: MARTH_04
      kind: Question
      title: 'In the next question, we are referring to work for pay. Do arthritis or joint symptoms now affect whether you work, the type of work you do or the amount of work you do? If respondent gives an answer to each issue (whether works, type of work, or amount of work), then if any issue is "yes" mark the overall response as "yes." If a question arises about medications or treatment, then the interviewer should say: "Please answer the question based on your current experience, regardless of whether you are taking any medication or treatment."'
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don’t know / Not sure
          9: Refused
    - id: MARTH_05
      kind: Question
      title: Please think about the past 30 days, keeping in mind all of your joint pain or aching and whether or not you have taken medication. During the past 30 days, how bad was your joint pain on average on a scale of 0 to 10 where 0 is no pain and 10 is pain or aching as bad as it can be? (__ __ Enter number [00-10]) Enter 77 for Don’t know/ Not sure, 99 for Refused.
      input:
        control: Editbox
        min: 0
        max: 99
  - id: b_s24_smoking_history
    title: 'Module 4: Lung Cancer Screening - Smoking History'
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when the LL06 and LL03 answers do not exclude this section.
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    - predicate: not (COVID_01.outcome in [2, 7, 9])
      hint: Asked only when question COVID.01 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (COVID_02.outcome in [2, 7, 9])
      hint: Asked only when question COVID.02 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (not (CTOB_01.outcome == 1 and CTOB_02.outcome in [1, 2, 3]))
      hint: Asked only of respondents who have smoked in the past or currently smoke.
    items:
    - id: MLCS_01
      kind: Question
      title: You've told us that you have smoked in the past or are currently smoking. The next questions are about screening for lung cancer. How old were you when you first started to smoke cigarettes regularly? (_ _ _ Age in Years (001 – 100)) Regularly is at least one cigarette or more on days that a respondent smokes (either every day or some days) or smoked (not at all). If respondent indicates age inconsistent with previously entered age, verify that this is the correct answer and change the age of the respondent regularly smoking or make a note to correct the age of the respondent.
      input:
        control: Editbox
        min: 1
        max: 999
        right: Age in years (001 - 100); 777 = Don't know/Not sure, 888 = Never smoked cigarettes regularly, 999 = Refused
    - id: MLCS_02
      kind: Question
      title: How old were you when you last smoked cigarettes regularly? (_ _ _ Age in Years (001 – 100))
      precondition:
      - predicate: not (MLCS_01.outcome == 888)
        hint: Asked only when question MLCS.01 is not "Never smoked cigarettes regularly".
      - predicate: not (CTOB_01.outcome == 1 and CTOB_02.outcome == 1 and MLCS_01.outcome != 888)
        hint: Not asked of current every-day smokers who started smoking regularly.
      postcondition:
      - predicate: MLCS_01.outcome >= 777 or MLCS_02.outcome >= 777 or MLCS_02.outcome >= MLCS_01.outcome
        hint: The age at which you last smoked regularly (MLCS.02) cannot be lower than the age at which you first started smoking regularly (MLCS.01).
        invented: true
      input:
        control: Editbox
        min: 1
        max: 999
        right: Age in years (001 - 100); 777 = Don't know/Not sure, 999 = Refused
    - id: MLCS_03
      kind: Question
      title: 'On average, when you [smoke/ smoked] regularly, about how many cigarettes {do/did} you usually smoke each day? (_ _ _ Number of cigarettes) Regularly is at least one cigarette or more on days that a respondent smokes (either every day or some days) or smoked (not at all). Respondents may answer in packs instead of number of cigarettes. Below is a conversion table: 0.5 pack = 10 cigarettes/ 1.75 pack = 35 cigarettes/ 0.75 pack = 15 cigarettes/ 2 packs = 40 cigarettes/ 1 pack = 20 cigarettes/ 2.5 packs= 50 cigarettes/ 1.25 pack = 25 cigarettes/ 3 packs= 60 cigarettes/ 1.5 pack = 30 cigarettes'
      precondition:
      - predicate: not (MLCS_01.outcome == 888)
        hint: Asked only when question MLCS.01 is not "Never smoked cigarettes regularly".
      input:
        control: Editbox
        min: 0
        max: 999
        right: Number of cigarettes; 777 = Don't know/Not sure, 999 = Refused
  - id: b_s24_ct_scan
    title: 'Module 4: Lung Cancer Screening - Chest CT Scan'
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when the LL06 and LL03 answers do not exclude this section.
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    - predicate: not (COVID_01.outcome in [2, 7, 9])
      hint: Asked only when question COVID.01 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (COVID_02.outcome in [2, 7, 9])
      hint: Asked only when question COVID.02 is none of "No", "Don't know / Not sure", "Refused".
    items:
    - id: MLCS_04
      kind: Question
      title: The next question is about CT or CAT scans. During this test, you lie flat on your back on a table. While you hold your breath, the table moves through a donut shaped x-ray machine while the scan is done. Have you ever had a CT or CAT scan of your chest area?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: No (Go to next module)
          7: Don't know/not sure (Go to next module)
          9: Refused (Go to next module)
  - id: b_s24_ct_followup
    title: 'Module 4: Lung Cancer Screening - Screening Scan Details'
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when the LL06 and LL03 answers do not exclude this section.
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    - predicate: not (COVID_01.outcome in [2, 7, 9])
      hint: Asked only when question COVID.01 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (COVID_02.outcome in [2, 7, 9])
      hint: Asked only when question COVID.02 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (MLCS_04.outcome in [2, 7, 9])
      hint: Asked only when question MLCS.04 is none of "No (Go to next module)", "Don't know/not sure (Go to next module)", "Refused (Go to next module)".
    items:
    - id: MLCS_05
      kind: Question
      title: Were any of the CT or CAT scans of your chest area done mainly to check or screen for lung cancer?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: No (Go to Next module)
          7: Don't know/not sure (Go to Next module)
          9: Refused (Go to Next module)
    - id: MLCS_06
      kind: Question
      title: When did you have your most recent CT or CAT scan of your chest area mainly to check or screen for lung cancer?
      precondition:
      - predicate: not (MLCS_05.outcome in [2, 7, 9])
        hint: Asked only when question MLCS.05 is none of "No (Go to Next module)", "Don't know/not sure (Go to Next module)", "Refused (Go to Next module)".
      input:
        control: Radio
        labels:
          1: Within the past year (anytime less than 12 months ago)
          2: Within the past 2 years (1 year but less than 2 years)
          3: Within the past 3 years (2 years but less than 3 years)
          4: Within the past 5 years (3 years but less than 5 years)
          5: Within the past 10 years (5 years but less than 10 years ago)
          6: 10 or more years ago
          7: Don’t know / Not sure
          9: Refused
  - id: b_s25_mammogram_cervical
    title: 'Module 5: Breast and Cervical Cancer Screening'
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when LL06 and LL03 do not both rule out this interview.
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    - predicate: not (COVID_01.outcome in [2, 7, 9])
      hint: Asked only when question COVID.01 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (COVID_02.outcome in [2, 7, 9])
      hint: Asked only when question COVID.02 is none of "No", "Don't know / Not sure", "Refused".
    items:
    - id: MBCCS_01
      kind: Question
      title: (The next questions are about breast and cervical cancer.) Have you ever had a mammogram? A mammogram is an x-ray of each breast to look for breast cancer.
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know/ not sure
          9: Refused
    - id: MBCCS_02
      kind: Question
      title: How long has it been since you had your last mammogram?
      precondition:
      - predicate: not (SEX.outcome == 1)
        hint: Asked only when question SEX is not "Male".
      - predicate: not (MBCCS_01.outcome in [2, 7, 9])
        hint: Asked only when question MBCCS.01 is none of "No", "Don't know/ not sure", "Refused".
      input:
        control: Radio
        labels:
          1: Within the past year (anytime less than 12 months ago)
          2: Within the past 2 years (1 year but less than 2 years ago)
          3: Within the past 3 years (2 years but less than 3 years ago)
          4: Within the past 5 years (3 years but less than 5 years ago)
          5: 5 or more years ago
          7: Don't know / Not sure
          9: Refused
    - id: MBCCS_03
      kind: Question
      title: Have you ever had a cervical cancer screening test?
      precondition:
      - predicate: not (SEX.outcome == 1)
        hint: Asked only when question SEX is not "Male".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know/ not sure
          9: Refused
  - id: b_s25_cervical_detail
    title: Cervical cancer screening details
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when LL06 and LL03 do not both rule out this interview.
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    - predicate: not (COVID_01.outcome in [2, 7, 9])
      hint: Asked only when question COVID.01 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (COVID_02.outcome in [2, 7, 9])
      hint: Asked only when question COVID.02 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (SEX.outcome == 1)
      hint: Asked only when question SEX is not "Male".
    - predicate: not (MBCCS_03.outcome in [2, 7, 9] and CDEM_16.outcome != 1)
      hint: Asked only when a cervical screening test was reported or applicable.
    - predicate: not (MBCCS_03.outcome in [2, 7, 9] and CDEM_16.outcome == 1)
      hint: Asked only when a cervical screening test was reported or applicable.
    items:
    - id: MBCCS_04
      kind: Question
      title: How long has it been since you had your last cervical cancer screening test?
      input:
        control: Radio
        labels:
          1: Within the past year (anytime less than 12 months ago)
          2: Within the past 2 years (1 year but less than 2 years ago)
          3: Within the past 3 years (2 years but less than 3 years ago)
          4: Within the past 5 years (3 years but less than 5 years ago)
          5: 5 or more years ago
          7: Don't know / Not sure
          9: Refused
    - id: MBCCS_05
      kind: Question
      title: At your most recent cervical cancer screening, did you have a Pap test?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know / Not sure
          9: Refused
    - id: MBCCS_06
      kind: Question
      title: At your most recent cervical cancer screening, did you have an H.P.V. test? H.P.V. stands for Human papillomarvirus (pap-uh-loh-muh virus)
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know / Not sure
          9: Refused
  - id: b_s25_hysterectomy
    title: Hysterectomy
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when LL06 and LL03 do not both rule out this interview.
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    - predicate: not (COVID_01.outcome in [2, 7, 9])
      hint: Asked only when question COVID.01 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (COVID_02.outcome in [2, 7, 9])
      hint: Asked only when question COVID.02 is none of "No", "Don't know / Not sure", "Refused".
    items:
    - id: MBCCS_07
      kind: Question
      title: 'Have you had a hysterectomy? Read if necessary: A hysterectomy is an operation to remove the uterus (womb).'
      precondition:
      - predicate: not (SEX.outcome == 1)
        hint: Asked only when question SEX is not "Male".
      - predicate: not (MBCCS_03.outcome in [2, 7, 9] and CDEM_16.outcome == 1)
        hint: Asked only when the cervical screening answer and CDEM.16 do not rule it out.
      - predicate: not (CDEM_16.outcome == 1)
        hint: Asked only when question CDEM.16 is not "Yes".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don’t know / Not sure
          9: Refused
  - id: b_s26_psa_history
    title: 'Module 6: Prostate Cancer Screening'
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when LL06 is not "No" together with LL03 being "Yes".
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    - predicate: not (COVID_01.outcome in [2, 7, 9])
      hint: Asked only when question COVID.01 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (COVID_02.outcome in [2, 7, 9])
      hint: Asked only when question COVID.02 is none of "No", "Don't know / Not sure", "Refused".
    items:
    - id: MPCS_01
      kind: Question
      title: Have you ever had a P.S.A. test? A P.S.A. test is a blood test to detect prostate cancer. It is also called a prostate-specific antigen test.
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know / Not sure
          9: Refused
  - id: b_s26_psa_details
    title: P.S.A. test details
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when LL06 is not "No" together with LL03 being "Yes".
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    - predicate: not (COVID_01.outcome in [2, 7, 9])
      hint: Asked only when question COVID.01 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (COVID_02.outcome in [2, 7, 9])
      hint: Asked only when question COVID.02 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (MPCS_01.outcome in [2, 7, 9])
      hint: Asked only when question MPCS.01 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (CDEM_01.outcome < 39 or SEX.outcome == 2)
      hint: Asked only of men aged 39 or older.
    items:
    - id: MPCS_02
      kind: Question
      title: About how long has it been since your most recent P.S.A. test? A P.S.A. test is a blood test to detect prostate cancer. It is also called a prostate-specific antigen test.
      input:
        control: Radio
        labels:
          1: Within the past year (anytime less than 12 months ago)
          2: Within the past 2 years (1 year but less than 2 years ago)
          3: Within the past 3 years (2 years but less than 3 years ago)
          4: Within the past 5 years (3 years but less than 5 years ago)
          5: 5 or more years ago
          7: Don’t know / Not sure
          9: Refused
    - id: MPCS_03
      kind: Question
      title: What was the main reason you had this P.S.A. test – was it …? A P.S.A. test is a blood test to detect prostate cancer. It is also called a prostate-specific antigen test.
      input:
        control: Radio
        labels:
          1: Part of a routine exam
          2: Because of a problem
          3: Other reason
          7: Don’t know / Not sure
          9: Refused
    - id: MPCS_04
      kind: Question
      title: 'Who first suggested this P.S.A. test: you, your doctor, or someone else?'
      input:
        control: Radio
        labels:
          1: Self
          2: Doctor, nurse, health care professional
          3: Someone else
          7: Don’t Know / Not sure
          9: Refused
  - id: b_s27_external
    title: External inputs
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when LL06 is not "No" while LL03 is "Yes".
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    - predicate: not (COVID_01.outcome in [2, 7, 9])
      hint: Asked only when question COVID.01 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (COVID_02.outcome in [2, 7, 9])
      hint: Asked only when question COVID.02 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (MPCS_01.outcome in [2, 7, 9])
      hint: Asked only when question MPCS.01 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (CDEM_01.outcome < 39 or SEX.outcome == 2)
      hint: Asked only when the respondent is aged 39 or over and is not female.
    items:
    - id: SEX
      kind: Question
      title: Respondent's sex (from the Core demographics section, collected in another part, or sex at birth if the state adopts it); the source routing says 'if male' / 'or is female' without naming the question.
      external: true
      input:
        control: Radio
        labels:
          1: Male
          2: Female
  - id: b_s28_psa_discussion
    title: Prostate Cancer Screening (continuation from previous part)
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Not asked when LL06 is 2 and LL03 is 1.
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    - predicate: not (COVID_01.outcome in [2, 7, 9])
      hint: Asked only when question COVID.01 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (COVID_02.outcome in [2, 7, 9])
      hint: Asked only when question COVID.02 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (CDEM_01.outcome < 39 or SEX.outcome == 2)
      hint: Not asked when CDEM.01 is under 39 or the respondent's sex is 2.
    items:
    - id: MPCS_05
      kind: Question
      title: 'When you met with a doctor, nurse, or other health professional, did they EVER talk about the advantages, the disadvantages, or both advantages and disadvantages of the prostate-specific antigen or P.S.A. test? (Interviewer note: A P.S.A. test is a blood test to detect prostate cancer. It is also called a prostate-specific antigen test.)'
      input:
        control: Radio
        labels:
          1: Advantages
          2: Disadvantages
          3: Both Advantages and disadvantages
          4: Neither (DO NOT READ)
          7: Don't know/ not sure
          9: Refused
  - id: b_s29_screen
    title: 'Module 7: Colorectal Cancer Screening'
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when the landline and cell phone routing allows it.
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    - predicate: not (COVID_01.outcome in [2, 7, 9])
      hint: Asked only when question COVID.01 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (COVID_02.outcome in [2, 7, 9])
      hint: Asked only when question COVID.02 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (CDEM_01.outcome < 39 or SEX.outcome == 2)
      hint: Asked only of respondents who are not under 39 and not female.
    items:
    - id: MCCS_01
      kind: Question
      title: Colonoscopy and sigmoidoscopy are exams to check for colon cancer. Have you ever had either of these exams? (A sigmoidoscopy checks part of the colon and you are fully awake. A colonoscopy checks the entire colon. You are usually given medication through a needle in your arm to make you sleepy and told to have someone else drive you home after the test.)
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know/ not sure
          9: Refused
  - id: b_s29_age45
    title: Colorectal Cancer Screening Tests
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when the landline and cell phone routing allows it.
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    - predicate: not (COVID_01.outcome in [2, 7, 9])
      hint: Asked only when question COVID.01 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (COVID_02.outcome in [2, 7, 9])
      hint: Asked only when question COVID.02 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (CDEM_01.outcome < 39 or SEX.outcome == 2)
      hint: Asked only of respondents who are not under 39 and not female.
    - predicate: not (CDEM_01.outcome < 45)
      hint: Asked only of respondents aged 45 or older.
    items:
    - id: MCCS_02
      kind: Question
      title: Have you had a colonoscopy, a sigmoidoscopy, or both?
      precondition:
      - predicate: not (MCCS_01.outcome in [2, 7, 9])
        hint: Asked only when question MCCS.01 is none of "No", "Don't know/ not sure", "Refused".
      input:
        control: Radio
        labels:
          1: Colonoscopy
          2: Sigmoidoscopy
          3: Both
          7: Don't know/Not sure
          9: Refused
    - id: MCCS_03
      kind: Question
      title: How long has it been since your most recent colonoscopy? (Read if necessary)
      precondition:
      - predicate: not (MCCS_01.outcome in [2, 7, 9])
        hint: Asked only when question MCCS.01 is none of "No", "Don't know/ not sure", "Refused".
      - predicate: not (MCCS_02.outcome == 2)
        hint: Asked only when question MCCS.02 is not "Sigmoidoscopy".
      - predicate: not (MCCS_02.outcome == 7)
        hint: Asked only when question MCCS.02 is not "Don't know/Not sure".
      - predicate: not (MCCS_02.outcome == 9)
        hint: Asked only when question MCCS.02 is not "Refused".
      input:
        control: Radio
        labels:
          1: Within the past year (anytime less than 12 months ago)
          2: Within the past 2 years (1 year but less than 2 years ago)
          3: Within the past 5 years (2 years but less than 5 years ago)
          4: Within the past 10 years (5 years but less than 10 years ago)
          5: 10 or more years ago
          7: Don't know / Not sure (Do not read)
          9: Refused (Do not read)
    - id: MCCS_04
      kind: Question
      title: How long has it been since your most recent sigmoidoscopy? (Read if necessary)
      precondition:
      - predicate: not (MCCS_01.outcome in [2, 7, 9])
        hint: Asked only when question MCCS.01 is none of "No", "Don't know/ not sure", "Refused".
      - predicate: not (MCCS_02.outcome == 7)
        hint: Asked only when question MCCS.02 is not "Don't know/Not sure".
      - predicate: not (MCCS_02.outcome == 9)
        hint: Asked only when question MCCS.02 is not "Refused".
      - predicate: not (MCCS_02.outcome != 3)
        hint: Asked only when question MCCS.02 is "Both".
      input:
        control: Radio
        labels:
          1: Within the past year (anytime less than 12 months ago)
          2: Within the past 2 years (1 year but less than 2 years ago)
          3: Within the past 5 years (2 years but less than 5 years ago)
          4: Within the past 10 years (5 years but less than 10 years ago)
          5: 10 or more years ago
          7: Don't know / Not sure (Do not read)
          9: Refused (Do not read)
    - id: MCCS_05
      kind: Question
      title: How long has it been since your most recent colonoscopy or sigmoidoscopy? (Read if necessary)
      precondition:
      - predicate: not (MCCS_01.outcome in [2, 7, 9])
        hint: Asked only when question MCCS.01 is none of "No", "Don't know/ not sure", "Refused".
      - predicate: not (MCCS_02.outcome == 9)
        hint: Asked only when question MCCS.02 is not "Refused".
      - predicate: not (MCCS_02.outcome != 3)
        hint: Asked only when question MCCS.02 is "Both".
      - predicate: not (MCCS_04.outcome in [1, 2, 3, 4, 5, 7, 9])
        hint: Asked only when question MCCS.04 has not been answered.
      input:
        control: Radio
        labels:
          1: Within the past year (anytime less than 12 months ago)
          2: Within the past 2 years (1 year but less than 2 years ago)
          3: Within the past 5 years (2 years but less than 5 years ago)
          4: Within the past 10 years (5 years but less than 10 years ago)
          5: 10 or more years ago
          7: Don't know / Not sure (Do not read)
          9: Refused (Do not read)
    - id: MCCS_06
      kind: Question
      title: Have you ever had any other kind of test for colorectal cancer, such as virtual colonoscopy, CT colonography, blood stool test, FIT DNA, or Cologuard test?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't Know/Not sure
          9: Refused
    - id: MCCS_07
      kind: Question
      title: 'A virtual colonoscopy uses a series of X-rays to take pictures of inside the colon. Have you ever had a virtual colonoscopy? (Interviewer note: CT colonography, sometimes called virtual colonoscopy, is a new type of test that looks for cancer in the colon. Unlike regular colonoscopies, you do not need medication to make you sleepy during the test. In this new test, your colon is filled with air and you are moved through a donut-shaped X-ray machine as you lie on your back and then your stomach.)'
      precondition:
      - predicate: not (MCCS_06.outcome in [2, 7, 9])
        hint: Asked only when question MCCS.06 is none of "No", "Don't Know/Not sure", "Refused".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't Know/Not sure
          9: Refused
    - id: MCCS_08
      kind: Question
      title: When was your most recent CT colonography or virtual colonoscopy? (Read if necessary)
      precondition:
      - predicate: not (MCCS_06.outcome in [2, 7, 9])
        hint: Asked only when question MCCS.06 is none of "No", "Don't Know/Not sure", "Refused".
      - predicate: not (MCCS_07.outcome in [2, 7, 9])
        hint: Asked only when question MCCS.07 is none of "No", "Don't Know/Not sure", "Refused".
      input:
        control: Radio
        labels:
          1: Within the past year (anytime less than 12 months ago)
          2: Within the past 2 years (1 year but less than 2 years ago)
          3: Within the past 5 years (2 years but less than 5 years ago)
          4: Within the past 10 years (5 years but less than 10 years ago)
          5: 10 or more years ago
          7: Don't know / Not sure (Do not read)
          9: Refused (Do not read)
    - id: MCCS_09
      kind: Question
      title: 'One stool test uses a special kit to obtain a small amount of stool at home and returns the kit to the doctor or the lab. Have you ever had this test? (Interviewer note: The blood stool or occult blood test, fecal immunochemical or FIT test determine whether you have blood in your stool or bowel movement and can be done at home using a kit. You use a stick or brush to obtain a small amount of stool at home and send it back to the doctor or lab.)'
      precondition:
      - predicate: not (MCCS_06.outcome in [2, 7, 9])
        hint: Asked only when question MCCS.06 is none of "No", "Don't Know/Not sure", "Refused".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know/ not sure
          9: Refused
    - id: MCCS_10
      kind: Question
      title: How long has it been since you had this test? (Read if necessary)
      precondition:
      - predicate: not (MCCS_06.outcome in [2, 7, 9])
        hint: Asked only when question MCCS.06 is none of "No", "Don't Know/Not sure", "Refused".
      - predicate: not (MCCS_09.outcome in [2, 7, 9])
        hint: Asked only when question MCCS.09 is none of "No", "Don't know/ not sure", "Refused".
      input:
        control: Radio
        labels:
          1: Within the past year (anytime less than 12 months ago)
          2: Within the past 2 years (1 year but less than 2 years ago)
          3: Within the past 3 years (2 years but less than 3 years ago)
          4: Within the past 5 years (3 years but less than 5 years ago)
          5: 5 or more years ago
          7: Don't know / Not sure (Do not read)
          9: Refused (Do not read)
    - id: MCCS_11
      kind: Question
      title: 'Another stool test uses a special kit to obtain an entire bowel movement at home and returns the kit to a lab. Have you ever had this test? (Interviewer note: Cologuard is a new type of stool test for colon cancer. Unlike other stool tests, Cologuard looks for changes in DNA in addition to checking for blood in your stool. The Cologuard test is shipped to your home in a box that includes a container for your stool sample.)'
      precondition:
      - predicate: not (MCCS_06.outcome in [2, 7, 9])
        hint: Asked only when question MCCS.06 is none of "No", "Don't Know/Not sure", "Refused".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't Know/Not sure
          9: Refused
    - id: MCCS_12
      kind: Question
      title: Was the blood stool or FIT (you reported earlier) conducted as part of a Cologuard test?
      precondition:
      - predicate: not (MCCS_06.outcome in [2, 7, 9])
        hint: Asked only when question MCCS.06 is none of "No", "Don't Know/Not sure", "Refused".
      - predicate: not (MCCS_11.outcome in [2, 7, 9])
        hint: Asked only when question MCCS.11 is none of "No", "Don't Know/Not sure", "Refused".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't Know/Not sure
          9: Refused
    - id: MCCS_13
      kind: Question
      title: How long has it been since you had this test? (Read if necessary)
      precondition:
      - predicate: not (MCCS_06.outcome in [2, 7, 9])
        hint: Asked only when question MCCS.06 is none of "No", "Don't Know/Not sure", "Refused".
      - predicate: not (MCCS_11.outcome in [2, 7, 9])
        hint: Asked only when question MCCS.11 is none of "No", "Don't Know/Not sure", "Refused".
      input:
        control: Radio
        labels:
          1: Within the past year (anytime less than 12 months ago)
          2: Within the past 2 years (1 year but less than 2 years ago)
          3: Within the past 3 years (2 years but less than 3 years ago)
          4: Within the past 5 years (3 years but less than 5 years ago)
          5: 5 or more years ago
          7: Don't know / Not sure (Do not read)
          9: Refused (Do not read)
  - id: b_s30_count
    title: 'Module 8: Cancer Survivorship: Number of Cancers'
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when LL06 and LL03 do not both exclude this respondent.
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    - predicate: not (COVID_01.outcome in [2, 7, 9])
      hint: Asked only when question COVID.01 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (COVID_02.outcome in [2, 7, 9])
      hint: Asked only when question COVID.02 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (CDEM_01.outcome < 39 or SEX.outcome == 2)
      hint: Asked only when the respondent is not under 39 or female.
    items:
    - id: MTOC_01
      kind: Question
      title: You've told us that you have had cancer. I would like to ask you a few more questions about your cancer. How many different types of cancer have you had?
      precondition:
      - predicate: CCHC_06.outcome == 1 or CCHC_07.outcome == 1
        hint: Asked only of respondents who reported having had cancer.
      input:
        control: Radio
        labels:
          1: Only one
          2: Two
          3: Three or more
          7: Don't know / Not sure
          9: Refused
  - id: b_s30_details
    title: 'Module 8: Cancer Survivorship: Age at Diagnosis and Type of Cancer'
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when LL06 and LL03 do not both exclude this respondent.
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    - predicate: not (COVID_01.outcome in [2, 7, 9])
      hint: Asked only when question COVID.01 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (COVID_02.outcome in [2, 7, 9])
      hint: Asked only when question COVID.02 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (CDEM_01.outcome < 39 or SEX.outcome == 2)
      hint: Asked only when the respondent is not under 39 or female.
    - predicate: not (not (CCHC_06.outcome == 1 or CCHC_07.outcome == 1))
      hint: Asked only of respondents who reported having had cancer.
    - predicate: not (MTOC_01.outcome in [7, 9])
      hint: Asked only when question MTOC.01 is none of "Don't know / Not sure", "Refused".
    items:
    - id: MTOC_02
      kind: Question
      title: 'At what age were you told that you had cancer? (Age in Years, 97 = 97 and older) (Interviewer note: If MTOC.01= 2 (Two) or 3 (Three or more), ask: At what age were you first diagnosed with cancer? Read if necessary: This question refers to the first time they were told about their first cancer.)'
      postcondition:
      - predicate: MTOC_02.outcome >= 98 or MTOC_02.outcome <= CDEM_01.outcome
        hint: La edad al diagnóstico de cáncer (MTOC.02) no puede ser mayor que su edad actual (CDEM.01). / Age told you had cancer (MTOC.02) cannot exceed your current age (CDEM.01).
        invented: true
      input:
        control: Editbox
        min: 0
        max: 99
        right: years (98 = Don't know/Not sure, 99 = Refused)
    - id: MTOC_03
      kind: Question
      title: 'What type of cancer was it? (Read if respondent needs prompting for cancer type) (Interviewer note: If MTOC.01 = 2 (Two) or 3 (Three or more), ask: With your most recent diagnoses of cancer, what type of cancer was it?)'
      input:
        control: Dropdown
        labels:
          1: 01 Bladder
          2: 02 Blood
          3: 03 Bone
          4: 04 Brain
          5: 05 Breast
          6: 06 Cervix/Cervical
          7: 07 Colon
          8: 08 Esophagus/Esophageal
          9: 09 Gallbladder
          10: 10 Kidney
          11: 11 Larynx-trachea
          12: 12 Leukemia
          13: 13 Liver
          14: 14 Lung
          15: 15 Lymphoma
          16: 16 Melanoma
          17: 17 Mouth/tongue/lip
          18: 18 Ovary/Ovarian
          19: 19 Pancreas/Pancreatic
          20: 20 Prostate
          21: 21 Rectum/Rectal
          22: 22 Skin (non-melanoma)
          23: 23 Skin (don't know what kind)
          24: 24 Soft tissue (muscle or fat)
          25: 25 Stomach
          26: 26 Testis/Testicular
          27: 27 Throat - pharynx
          28: 28 Thyroid
          29: 29 Uterus/Uterine
          30: 30 Other
          77: Don't know / Not sure (Do not read)
          99: Refused (Do not read)
  - id: b_s31_status
    title: 'Module 9: Cancer Survivorship: Course of Treatment'
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when question LL06 is not "No" together with LL03 "Yes".
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    - predicate: not (COVID_01.outcome in [2, 7, 9])
      hint: Asked only when question COVID.01 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (COVID_02.outcome in [2, 7, 9])
      hint: Asked only when question COVID.02 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (CDEM_01.outcome < 39 or SEX.outcome == 2)
      hint: Asked only when the respondent is aged 39 or older and not female.
    items:
    - id: MCOT_01
      kind: Question
      title: 'Are you currently receiving treatment for cancer? (Read if necessary: By treatment, we mean surgery, radiation therapy, chemotherapy, or chemotherapy pills.)'
      precondition:
      - predicate: CCHC_06.outcome == 1 or CCHC_07.outcome == 1
        hint: Asked only when CCHC.06 or CCHC.07 is Yes.
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: No, I've completed treatment
          3: No, I've refused treatment
          4: No, I haven't started treatment
          5: Treatment was not necessary
          7: Don't know / Not sure
          9: Refused
  - id: b_s31_followup
    title: 'Cancer Treatment: Care and Follow-up'
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when question LL06 is not "No" together with LL03 "Yes".
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    - predicate: not (COVID_01.outcome in [2, 7, 9])
      hint: Asked only when question COVID.01 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (COVID_02.outcome in [2, 7, 9])
      hint: Asked only when question COVID.02 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (CDEM_01.outcome < 39 or SEX.outcome == 2)
      hint: Asked only when the respondent is aged 39 or older and not female.
    - predicate: not (not (CCHC_06.outcome == 1 or CCHC_07.outcome == 1))
      hint: Asked only when CCHC.06 or CCHC.07 is Yes.
    - predicate: not (MCOT_01.outcome in [1, 3, 4, 5, 7, 9])
      hint: Asked only when question MCOT.01 is none of "Yes", "No, I've refused treatment", "No, I haven't started treatment", "Treatment was not necessary", "Don't know / Not sure", "Refused".
    items:
    - id: MCOT_02
      kind: Question
      title: 'What type of doctor provides the majority of your health care? Is it a…. (Read) (If the respondent requests clarification of this question, say: We want to know which type of doctor you see most often for illness or regular health care (Examples: annual exams and/or physicals, treatment of colds, etc.). Read if necessary: An oncologist is a medical doctor who manages a person''s care and treatment after a cancer diagnosis.)'
      input:
        control: Dropdown
        labels:
          1: 01 Cancer Surgeon
          2: 02 Family Practitioner
          3: 03 General Surgeon
          4: 04 Gynecologic Oncologist
          5: 05 General Practitioner, Internist
          6: 06 Plastic Surgeon, Reconstructive Surgeon
          7: 07 Medical Oncologist
          8: 08 Radiation Oncologist
          9: 09 Urologist
          10: 10 Other
          77: Don't know / Not sure (Do not read)
          99: Refused (Do not read)
    - id: MCOT_03
      kind: Question
      title: 'Did any doctor, nurse, or other health professional ever give you a written summary of all the cancer treatments that you received? (Read if necessary: By ''other healthcare professional'', we mean a nurse practitioner, a physician''s assistant, social worker, or some other licensed professional.)'
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know/ not sure
          9: Refused
    - id: MCOT_04
      kind: Question
      title: Have you ever received instructions from a doctor, nurse, or other health professional about where you should return or who you should see for routine cancer check-ups after completing your treatment for cancer?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know/ not sure
          9: Refused
    - id: MCOT_05
      kind: Question
      title: Were these instructions written down or printed on paper for you?
      precondition:
      - predicate: not (MCOT_04.outcome in [2, 7, 9])
        hint: Asked only when question MCOT.04 is none of "No", "Don't know/ not sure", "Refused".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know/ not sure
          9: Refused
    - id: MCOT_06
      kind: Question
      title: 'With your most recent diagnosis of cancer, did you have health insurance that paid for all or part of your cancer treatment? (Read if necessary: Health insurance also includes Medicare, Medicaid, or other types of state health programs.)'
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know/ not sure
          9: Refused
    - id: MCOT_07
      kind: Question
      title: Were you ever denied health insurance or life insurance coverage because of your cancer?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know/ not sure
          9: Refused
    - id: MCOT_08
      kind: Question
      title: Did you participate in a clinical trial as part of your cancer treatment?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know/ not sure
          9: Refused
  - id: b_s32_pain_management
    title: 'Module 10: Cancer Survivorship: Pain Management'
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when LL06 is not "No" together with LL03 "Yes".
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    - predicate: not (COVID_01.outcome in [2, 7, 9])
      hint: Asked only when question COVID.01 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (COVID_02.outcome in [2, 7, 9])
      hint: Asked only when question COVID.02 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (CDEM_01.outcome < 39 or SEX.outcome == 2)
      hint: Asked only when CDEM.01 is 39 or older and the respondent is not female.
    items:
    - id: MCPM_01
      kind: Question
      title: Do you currently have physical pain caused by your cancer or cancer treatment?
      precondition:
      - predicate: CCHC_06.outcome == 1 or CCHC_07.outcome == 1
        hint: Asked only when CCHC.06 or CCHC.07 is "Yes".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know/ not sure
          9: Refused
    - id: MCPM_02
      kind: Question
      title: Would you say your pain is currently under control…? (Read)
      precondition:
      - predicate: not (not (CCHC_06.outcome == 1 or CCHC_07.outcome == 1))
        hint: Asked only when CCHC.06 or CCHC.07 is "Yes".
      - predicate: not (MCPM_01.outcome in [2, 7, 9])
        hint: Asked only when question MCPM.01 is none of "No", "Don't know/ not sure", "Refused".
      input:
        control: Radio
        labels:
          1: With medication (or treatment)
          2: Without medication (or treatment)
          3: Not under control, with medication (or treatment)
          4: Not under control, without medication (or treatment)
          7: Don't know / Not sure (Do not read)
          9: Refused (Do not read)
  - id: b_s33_indoor_tanning
    title: 'Module 11: Indoor Tanning'
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Not asked when LL06. is 2 and LL03. is 1.
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    - predicate: not (COVID_01.outcome in [2, 7, 9])
      hint: Asked only when question COVID.01 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (COVID_02.outcome in [2, 7, 9])
      hint: Asked only when question COVID.02 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (CDEM_01.outcome < 39 or SEX.outcome == 2)
      hint: Not asked when CDEM.01 is under 39 or SEX is 2.
    items:
    - id: MNTAN_01
      kind: Question
      title: Not including spray-on tans, during the past 12 months, how many times have you used an indoor tanning device such as a sunlamp, tanning bed, or booth? (Number 0-365)
      input:
        control: Editbox
        min: 0
        max: 999
  - id: b_s34_excess_sun
    title: 'Module 12: Excess Sun Exposure'
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when LL06 is not "No" while LL03 is "Yes".
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    - predicate: not (COVID_01.outcome in [2, 7, 9])
      hint: Asked only when question COVID.01 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (COVID_02.outcome in [2, 7, 9])
      hint: Asked only when question COVID.02 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (CDEM_01.outcome < 39 or SEX.outcome == 2)
      hint: Asked only when CDEM.01 is 39 or more and the respondent is not female.
    items:
    - id: MSUN_01
      kind: Question
      title: During the past 12 months, how many times have you had a sunburn? (Number 0-365) (777 = Don't know/ Not sure, 999 = Refused)
      input:
        control: Editbox
        min: 0
        max: 999
    - id: MSUN_02
      kind: Question
      title: When you go outside on a warm sunny day for more than one hour, how often do you protect yourself from the sun? Is that…. (Read) (Protection from the sun may include using sunscreen, wearing a wide-brimmed hat, or wearing a long-sleeved shirt.)
      input:
        control: Radio
        labels:
          1: Always
          2: Most of the time
          3: Sometimes
          4: Rarely
          5: Never
          6: Don't stay outside for more than one hour on warm sunny days (Do not read)
          8: Don't go outside at all on warm sunny days (Do not read)
          7: Don't know/ Not sure (Do not read)
          9: Refused (Do not read)
    - id: MSUN_03
      kind: Question
      title: On weekdays, in the summer, how long are you outside per day between 10am and 4pm? (Friday is a weekday. If respondent says never, code 01.)
      input:
        control: Dropdown
        labels:
          1: 01 Less than half an hour
          2: 02 (More than half an hour) up to 1 hour
          3: 03 (More than 1 hour) up to 2 hours
          4: 04 (More than 2 hours) up to 3 hours
          5: 05 (More than 3 hours) up to 4 hours
          6: 06 (More than 4 hours) up to 5 hours
          7: 07 (More than 5) up to 6 hours
          77: Don't know/ Not sure
          99: Refused
    - id: MSUN_04
      kind: Question
      title: On weekends in the summer, how long are you outside each day between 10am and 4pm? (Friday is a weekday. If respondent says never, code 01.)
      input:
        control: Dropdown
        labels:
          1: 01 Less than half an hour
          2: 02 (More than half an hour) up to 1 hour
          3: 03 (More than 1 hour) up to 2 hours
          4: 04 (More than 2 hours) up to 3 hours
          5: 05 (More than 3 hours) up to 4 hours
          6: 06 (More than 4 hours) up to 5 hours
          7: 07 (More than 5) up to 6 hours
          77: Don't know/ Not sure
          99: Refused
  - id: b_s35_mcog_screen
    title: 'Module 13: Cognitive Decline'
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    - predicate: not (COVID_01.outcome in [2, 7, 9])
      hint: Asked only when question COVID.01 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (COVID_02.outcome in [2, 7, 9])
      hint: Asked only when question COVID.02 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (CDEM_01.outcome < 39 or SEX.outcome == 2)
    items:
    - id: MCOG_01
      kind: Question
      title: The next few questions ask about difficulties in thinking or memory that can make a big difference in everyday activities. We want to know how these difficulties may have impacted you. During the past 12 months, have you experienced difficulties with thinking or memory that are happening more often or are getting worse?
      precondition:
      - predicate: CDEM_01.outcome >= 45
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know/ not sure
          9: Refused
  - id: b_s35_mcog_followup
    title: 'Cognitive Decline: Follow-up'
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    - predicate: not (COVID_01.outcome in [2, 7, 9])
      hint: Asked only when question COVID.01 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (COVID_02.outcome in [2, 7, 9])
      hint: Asked only when question COVID.02 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (CDEM_01.outcome < 39 or SEX.outcome == 2)
    - predicate: not (CDEM_01.outcome < 45)
    - predicate: not (MCOG_01.outcome in [2, 7, 9])
      hint: Asked only when question MCOG.01 is none of "No", "Don't know/ not sure", "Refused".
    items:
    - id: MCOG_02
      kind: Question
      title: Are you worried about these difficulties with thinking or memory?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know/ not sure
          9: Refused
    - id: MCOG_03
      kind: Question
      title: Have you or anyone else discussed your difficulties with thinking or memory with a health care provider?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know/ not sure
          9: Refused
    - id: MCOG_04
      kind: Question
      title: During the past 12 months, have your difficulties with thinking or memory interfered with day-to-day activities, such as managing medications, paying bills, or keeping track of appointments?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know/ not sure
          9: Refused
    - id: MCOG_05
      kind: Question
      title: During the past 12 months, have your difficulties with thinking or memory interfered with your ability to work or volunteer?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know/ not sure
          9: Refused
  - id: b_s36_screen
    title: 'Module 14: Caregiver'
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when LL06 is not "No" while LL03 is "Yes".
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    - predicate: not (COVID_01.outcome in [2, 7, 9])
      hint: Asked only when question COVID.01 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (COVID_02.outcome in [2, 7, 9])
      hint: Asked only when question COVID.02 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (CDEM_01.outcome < 39 or SEX.outcome == 2)
      hint: Asked only when the respondent is aged 39 or older and not coded as SEX 2.
    items:
    - id: MCARE_01
      kind: Question
      title: 'During the past 30 days, did you provide regular care or assistance to a friend or family member who has a health problem or disability? (If caregiving recipient has died in the past 30 days, code 8 and say: I''m so sorry to hear of your loss)'
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know/Not sure
          8: Caregiving recipient died in past 30 days
          9: Refused
  - id: b_s36_caregiving
    title: Caregiving details
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when LL06 is not "No" while LL03 is "Yes".
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    - predicate: not (COVID_01.outcome in [2, 7, 9])
      hint: Asked only when question COVID.01 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (COVID_02.outcome in [2, 7, 9])
      hint: Asked only when question COVID.02 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (CDEM_01.outcome < 39 or SEX.outcome == 2)
      hint: Asked only when the respondent is aged 39 or older and not coded as SEX 2.
    - predicate: not (MCARE_01.outcome in [2, 7, 9])
      hint: Asked only when question MCARE.01 is none of "No", "Don't know/Not sure", "Refused".
    - predicate: not (MCARE_01.outcome == 8)
      hint: Asked only when question MCARE.01 is not "Caregiving recipient died in past 30 days".
    items:
    - id: MCARE_02
      kind: Question
      title: 'What is his or her relationship to you? (If more than one person, say: Please refer to the person to whom you are giving the most care.)'
      input:
        control: Dropdown
        labels:
          1: 01 Mother
          2: 02 Father
          3: 03 Mother-in-law
          4: 04 Father-in-law
          5: 05 Child
          6: 06 Husband
          7: 07 Wife
          8: 08 Live-in partner
          9: 09 Brother or brother-in-law
          10: 10 Sister or sister-in-law
          11: 11 Grandmother
          12: 12 Grandfather
          13: 13 Grandchild
          14: 14 Other relative
          15: 15 Non-relative/ Family friend
          77: Don't know/Not sure
          99: Refused
    - id: MCARE_03
      kind: Question
      title: For how long have you provided care for that person? (Read if necessary)
      input:
        control: Radio
        labels:
          1: Less than 30 days
          2: 1 month to less than 6 months
          3: 6 months to less than 2 years
          4: 2 years to less than 5 years
          5: More than 5 years
          7: Don't Know/ Not Sure (Do not read)
          9: Refused (Do not read)
    - id: MCARE_04
      kind: Question
      title: In an average week, how many hours do you provide care or assistance? (Read if necessary)
      input:
        control: Radio
        labels:
          1: Up to 8 hours per week
          2: 9 to 19 hours per week
          3: 20 to 39 hours per week
          4: 40 hours or more
          7: Don't know/Not sure (Do not read)
          9: Refused (Do not read)
    - id: MCARE_05
      kind: Question
      title: What is the main health problem, long-term illness, or disability that the person you care for has?
      input:
        control: Dropdown
        labels:
          1: 01 Arthritis/ rheumatism
          2: 02 Asthma
          3: 03 Cancer
          4: 04 Chronic respiratory conditions such as emphysema or COPD
          5: 05 Alzheimer's disease, dementia or other cognitive impairment disorder
          6: 06 Developmental disabilities such as autism, Down's Syndrome, and spina bifida
          7: 07 Diabetes
          8: 08 Heart disease, hypertension, stroke
          9: 09 Human Immunodeficiency Virus Infection (H.I.V.)
          10: 10 Mental illnesses, such as anxiety, depression, or schizophrenia
          11: 11 Other organ failure or diseases such as kidney or liver problems
          12: 12 Substance abuse or addiction disorders
          13: 13 Injuries, including broken bones
          14: 14 Old age/ infirmity/frailty
          15: 15 Other
          77: Don't know/Not sure
          99: Refused
    - id: MCARE_06
      kind: Question
      title: Does the person you care for also have Alzheimer's disease, dementia or other cognitive impairment disorder?
      precondition:
      - predicate: not (MCARE_05.outcome == 5)
        hint: Asked only when question MCARE.05 is not "05 Alzheimer's disease, dementia or other cognitive impairment disorder".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know/ Not sure
          9: Refused
    - id: MCARE_07
      kind: Question
      title: In the past 30 days, did you provide care for this person by managing personal care such as giving medications, feeding, dressing, or bathing?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know/ not sure
          9: Refused
    - id: MCARE_08
      kind: Question
      title: In the past 30 days, did you provide care for this person by managing household tasks such as cleaning, managing money, or preparing meals?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know/ not sure
          9: Refused
  - id: b_s36_future
    title: Expected caregiving
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when LL06 is not "No" while LL03 is "Yes".
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    - predicate: not (COVID_01.outcome in [2, 7, 9])
      hint: Asked only when question COVID.01 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (COVID_02.outcome in [2, 7, 9])
      hint: Asked only when question COVID.02 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (CDEM_01.outcome < 39 or SEX.outcome == 2)
      hint: Asked only when the respondent is aged 39 or older and not coded as SEX 2.
    items:
    - id: MCARE_09
      kind: Question
      title: In the next 2 years, do you expect to provide care or assistance to a friend or family member who has a health problem or disability?
      precondition:
      - predicate: not (MCARE_01.outcome == 8)
        hint: Asked only when question MCARE.01 is not "Caregiving recipient died in past 30 days".
      - predicate: not (MCARE_01.outcome in [1, 8])
        hint: Asked only when question MCARE.01 is none of "Yes", "Caregiving recipient died in past 30 days".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know/ not sure
          9: Refused
  - id: b_s37_tobacco_cessation
    title: 'Module 15: Tobacco Cessation'
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when LL06 is not "No" together with LL03 "Yes".
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    - predicate: not (COVID_01.outcome in [2, 7, 9])
      hint: Asked only when question COVID.01 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (COVID_02.outcome in [2, 7, 9])
      hint: Asked only when question COVID.02 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (CDEM_01.outcome < 39 or SEX.outcome == 2)
      hint: Asked only when the respondent is aged 39 or older and not female.
    items:
    - id: MTC_01
      kind: Question
      title: How long has it been since you last smoked a cigarette, even one or two puffs? (Read if necessary)
      precondition:
      - predicate: CTOB_01.outcome == 1 and CTOB_02.outcome == 3
        hint: Asked only of respondents who have smoked and who do not smoke at all now.
      input:
        control: Dropdown
        labels:
          1: 01 Within the past month (less than 1 month ago)
          2: 02 Within the past 3 months (1 month but less than 3 months ago)
          3: 03 Within the past 6 months (3 months but less than 6 months ago)
          4: 04 Within the past year (6 months but less than 1 year ago)
          5: 05 Within the past 5 years (1 year but less than 5 years ago)
          6: 06 Within the past 10 years (5 years but less than 10 years ago)
          7: 07 10 years or more
          8: 08 Never smoked regularly
          77: Don't know / Not sure
          99: Refused
    - id: MTC_02
      kind: Question
      title: During the past 12 months, have you stopped smoking for one day or longer because you were trying to quit smoking?
      precondition:
      - predicate: CTOB_02.outcome in [1, 2]
        hint: Asked only when question CTOB.02 is one of "Every day", "Some days".
      - predicate: not (MTC_01.outcome in [1, 2, 3, 4, 5, 6, 7, 8, 77, 99])
        hint: Asked only when question MTC.01 was not answered.
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know / Not sure
          9: Refused
  - id: b_s38_other_tobacco
    title: 'Module 16: Other Tobacco Use'
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when the landline and household screening answers allow it.
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    - predicate: not (COVID_01.outcome in [2, 7, 9])
      hint: Asked only when question COVID.01 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (COVID_02.outcome in [2, 7, 9])
      hint: Asked only when question COVID.02 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (CDEM_01.outcome < 39 or SEX.outcome == 2)
      hint: Asked only when the respondent's age and sex answers allow it.
    items:
    - id: MOTU_01
      kind: Question
      title: Currently, when you smoke cigarettes, do you usually smoke menthol cigarettes?
      precondition:
      - predicate: CTOB_02.outcome in [1, 2]
        hint: Asked only when question CTOB.02 is one of "Every day", "Some days".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know / Not sure
          9: Refused
    - id: MOTU_02
      kind: Question
      title: Currently, when you use e-cigarettes, do you usually use menthol e-cigarettes?
      precondition:
      - predicate: CTOB_04.outcome in [2, 3]
        hint: Asked only when question CTOB.04 is one of "Use them every day", "Use them some days".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know / Not sure
          9: Refused
    - id: MOTU_03
      kind: Question
      title: Before today, have you heard of heated tobacco products?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know / Not sure
          9: Refused
  - id: b_s39_firearms
    title: Firearms (Prologue and MFS)
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when LL06 and LL03 do not both route out of this section.
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    - predicate: not (COVID_01.outcome in [2, 7, 9])
      hint: Asked only when question COVID.01 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (COVID_02.outcome in [2, 7, 9])
      hint: Asked only when question COVID.02 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (CDEM_01.outcome < 39 or SEX.outcome == 2)
      hint: Asked only when the respondent is not under 39 and not female.
    items:
    - id: MFS_01
      kind: Question
      title: Are any firearms now kept in or around your home? (Do not include guns that cannot fire; include those kept in cars, or outdoor storage.)
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know/ not sure
          9: Refused
  - id: b_s39_loaded
    title: 'Firearms: loaded and unlocked'
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when LL06 and LL03 do not both route out of this section.
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    - predicate: not (COVID_01.outcome in [2, 7, 9])
      hint: Asked only when question COVID.01 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (COVID_02.outcome in [2, 7, 9])
      hint: Asked only when question COVID.02 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (CDEM_01.outcome < 39 or SEX.outcome == 2)
      hint: Asked only when the respondent is not under 39 and not female.
    - predicate: not (MFS_01.outcome in [2, 7, 9])
      hint: Asked only when question MFS.01 is none of "No", "Don't know/ not sure", "Refused".
    items:
    - id: MFS_02
      kind: Question
      title: Are any of these firearms now loaded?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know/ not sure
          9: Refused
    - id: MFS_03
      kind: Question
      title: Are any of these loaded firearms also unlocked? (By unlocked, we mean you do not need a key or a combination or a hand/fingerprint to get the gun or to fire it. Don't count the safety as a lock.)
      precondition:
      - predicate: not (MFS_02.outcome in [2, 7, 9])
        hint: Asked only when question MFS.02 is none of "No", "Don't know/ not sure", "Refused".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know/ not sure
          9: Refused
  - id: b_s40_industry_occupation
    title: 'Module 18: Industry and Occupation'
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when LL06 and LL03 do not both route out of this module.
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    - predicate: not (COVID_01.outcome in [2, 7, 9])
      hint: Asked only when question COVID.01 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (COVID_02.outcome in [2, 7, 9])
      hint: Asked only when question COVID.02 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (CDEM_01.outcome < 39 or SEX.outcome == 2)
      hint: Asked only when the respondent's age and sex do not route out of this module.
    - predicate: CDEM_13.outcome in [1, 2, 4]
      hint: Asked only when question CDEM.13 is one of "Employed for wages", "Self-employed", "Out of work for less than 1 year".
    items:
    - id: MIO_01
      kind: Question
      title: 'What kind of work do you do? For example, registered nurse, janitor, cashier, auto mechanic. (If CDEM.13 = 4 ask: "What kind of work did you do?") If respondent is unclear, ask: What is your job title? If respondent has more than one job ask: What is your main job?'
      input:
        control: Textarea
    - id: MIO_02
      kind: Question
      title: 'What kind of business or industry do you work in? For example, hospital, elementary school, clothing manufacturing, restaurant (If Core CDEM.13 = 4 ask: "What kind of business or industry did you work in?")'
      precondition:
      - predicate: not (not (CDEM_13.outcome in [1, 2, 4]))
        hint: Asked only when question CDEM.13 is one of "Employed for wages", "Self-employed", "Out of work for less than 1 year".
      input:
        control: Textarea
  - id: b_s41_heart_attack_stroke
    title: 'Module 19: Heart Attack and Stroke'
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when LL06 is not "No" while LL03 is "Yes".
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    - predicate: not (COVID_01.outcome in [2, 7, 9])
      hint: Asked only when question COVID.01 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (COVID_02.outcome in [2, 7, 9])
      hint: Asked only when question COVID.02 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (CDEM_01.outcome < 39 or SEX.outcome == 2)
      hint: Asked only when CDEM.01 is 39 or more and the respondent's sex is not 2.
    items:
    - id: MHAS_01
      kind: Question
      title: Which of the following do you think is a symptom of a heart attack? For each, tell me 'Yes', "No" or you're "Not sure". (Do you think) pain or discomfort in the jaw, neck, or back (are symptoms of a heart attack?)
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don’t know / Not sure
          9: Refused
    - id: MHAS_02
      kind: Question
      title: (Do you think) feeling weak, lightheaded, or faint (are symptoms of a heart attack?)
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don’t know / Not sure
          9: Refused
    - id: MHAS_03
      kind: Question
      title: (Do you think) chest pain or discomfort (are symptoms of a heart attack?)
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don’t know / Not sure
          9: Refused
    - id: MHAS_04
      kind: Question
      title: (Do you think) sudden trouble seeing in one or both eyes (are symptoms of a heart attack?)
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don’t know / Not sure
          9: Refused
    - id: MHAS_05
      kind: Question
      title: (Do you think) pain or discomfort in the arms or shoulder (are symptoms of a heart attack?)
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don’t know / Not sure
          9: Refused
    - id: MHAS_06
      kind: Question
      title: (Do you think) shortness of breath (are symptoms of a heart attack?)
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don’t know / Not sure
          9: Refused
    - id: MHAS_07
      kind: Question
      title: Which of the following do you think is a symptom of a stroke? For each, tell me 'Yes', "No" or you're "Not sure". (Do you think) sudden confusion or trouble speaking (are symptoms of a stroke?)
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don’t know / Not sure
          9: Refused
    - id: MHAS_08
      kind: Question
      title: (Do you think) sudden numbness or weakness of face, arm, or leg, especially on one side, (are symptoms of a stroke?)
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don’t know / Not sure
          9: Refused
    - id: MHAS_09
      kind: Question
      title: (Do you think) sudden trouble seeing in one or both eyes (is a symptom of a stroke?)
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don’t know / Not sure
          9: Refused
    - id: MHAS_10
      kind: Question
      title: (Do you think) sudden chest pain or discomfort (are symptoms of a stroke?)
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don’t know / Not sure
          9: Refused
    - id: MHAS_11
      kind: Question
      title: (Do you think) sudden trouble walking, dizziness, or loss of balance (is a symptom of a stroke?)
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don’t know / Not sure
          9: Refused
    - id: MHAS_12
      kind: Question
      title: (Do you think) severe headache with no known cause (are symptoms of a stroke?)
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don’t know / Not sure
          9: Refused
    - id: MHAS_13
      kind: Question
      title: 'If you thought someone was having a heart attack or a stroke, what is the first thing you would do? Please read: 1 Take them to the hospital, 2 Tell them to call their doctor, 3 Call 911, 4 Call their spouse or a family member, Or 5 Do something else. Do not read: 7, 9'
      input:
        control: Radio
        labels:
          1: Take them to the hospital
          2: Tell them to call their doctor
          3: Call 911
          4: Call their spouse or a family member
          5: Do something else
          7: Don’t know / Not sure
          9: Refused
  - id: b_s42_aspirin
    title: 'Module 20: Aspirin for CVD Prevention'
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when LL06 is not 2 with LL03 equal to 1.
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    - predicate: not (COVID_01.outcome in [2, 7, 9])
      hint: Asked only when question COVID.01 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (COVID_02.outcome in [2, 7, 9])
      hint: Asked only when question COVID.02 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (CDEM_01.outcome < 39 or SEX.outcome == 2)
      hint: Asked only of respondents aged 39 or older who are not female.
    items:
    - id: MASPRN_01
      kind: Question
      title: How often do you take an aspirin to prevent or control heart disease, heart attacks or stroke? Would you say….
      input:
        control: Radio
        labels:
          1: Daily
          2: Some days
          3: Used to take it but had to stop due to side effects, or
          4: Do not take it
          7: Don’t know / Not sure
          9: Refused
  - id: b_s43_msab
    title: 'Module 21: Sex at Birth'
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when question LL06 is not "No" together with LL03 being "Yes".
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    - predicate: not (COVID_01.outcome in [2, 7, 9])
      hint: Asked only when question COVID.01 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (COVID_02.outcome in [2, 7, 9])
      hint: Asked only when question COVID.02 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (CDEM_01.outcome < 39 or SEX.outcome == 2)
      hint: Asked only when the respondent is not under 39 and SEX is not 2.
    items:
    - id: MSAB_01_2
      kind: Question
      title: What was your sex at birth? Was it male or female? (This question refers to the original birth certificate of the respondent. It does not refer to amended birth certificates.)
      precondition:
      - predicate: not (LL10.outcome in [1, 2] or CP06.outcome in [1, 2])
        hint: Asked only when sex at birth is not already known from LL10 or CP06.
      input:
        control: Radio
        labels:
          1: Male
          2: Female
          7: Don't know/Not sure
          9: Refused
  - id: b_s44_sogi
    title: 'Module 22: Sexual Orientation and Gender Identity (SOGI)'
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when LL06 is not "No" together with LL03 "Yes".
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    - predicate: not (COVID_01.outcome in [2, 7, 9])
      hint: Asked only when question COVID.01 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (COVID_02.outcome in [2, 7, 9])
      hint: Asked only when question COVID.02 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (CDEM_01.outcome < 39 or SEX.outcome == 2)
      hint: Asked only when the respondent is aged 39 or older (CDEM.01) or SEX is not 2.
    items:
    - id: MSOGI_01
      kind: Question
      title: 'Which of the following best represents how you think of yourself? (male version) Read if necessary: We ask this question in order to better understand the health and health care needs of people with different sexual orientations. Please say the number before the text response. Respondent can answer with either the number or the text/word.'
      precondition:
      - predicate: LL10.outcome == 1 or CP06.outcome == 1
        hint: Asked when the respondent is male (LL10 or CP06 is 1).
      input:
        control: Radio
        labels:
          1: Gay
          2: Straight, that is, not gay
          3: Bisexual
          4: Something else
          7: I don't know the answer
          9: Refused
    - id: MSOGI_02
      kind: Question
      title: 'Which of the following best represents how you think of yourself? (female version) Read if necessary: We ask this question in order to better understand the health and health care needs of people with different sexual orientations. Please say the number before the text response. Respondent can answer with either the number or the text/word.'
      precondition:
      - predicate: LL10.outcome == 2 or CP06.outcome == 2
        hint: Asked when the respondent is female (LL10 or CP06 is 2).
      - predicate: not (LL10.outcome == 1 or CP06.outcome == 1)
        hint: Not asked when the male version applies.
      input:
        control: Radio
        labels:
          1: Lesbian or Gay
          2: Straight, that is, not gay
          3: Bisexual
          4: Something else
          7: I don't know the answer
          9: Refused
    - id: MSOGI_03
      kind: Question
      title: 'Do you consider yourself to be transgender? (Read if necessary: Some people describe themselves as transgender when they experience a different gender identity from their sex at birth... If yes, ask Do you consider yourself to be 1. male-to-female, 2. female-to-male, or 3. gender non-conforming? Please say the number before the text response.)'
      input:
        control: Radio
        labels:
          1: Yes, Transgender, male-to-female
          2: Yes, Transgender, female to male
          3: Yes, Transgender, gender nonconforming
          4: 'No'
          7: Don't know/not sure
          9: Refused
  - id: b_s45_days
    title: 'Module 23: Marijuana Use'
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when the LL06 and LL03 routing allows it.
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    - predicate: not (COVID_01.outcome in [2, 7, 9])
      hint: Asked only when question COVID.01 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (COVID_02.outcome in [2, 7, 9])
      hint: Asked only when question COVID.02 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (CDEM_01.outcome < 39 or SEX.outcome == 2)
      hint: Asked only when the CDEM.01 and SEX routing allows it.
    items:
    - id: MMU_01
      kind: Question
      title: During the past 30 days, on how many days did you use marijuana or cannabis? (Do not include hemp-based CBD-only products.) Enter 1-30 days; 88 = None, 77 = Don't know/not sure, 99 = Refused.
      input:
        control: Editbox
        min: 1
        max: 99
  - id: b_s45_methods
    title: Methods of marijuana use
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when the LL06 and LL03 routing allows it.
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    - predicate: not (COVID_01.outcome in [2, 7, 9])
      hint: Asked only when question COVID.01 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (COVID_02.outcome in [2, 7, 9])
      hint: Asked only when question COVID.02 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (CDEM_01.outcome < 39 or SEX.outcome == 2)
      hint: Asked only when the CDEM.01 and SEX routing allows it.
    - predicate: not (MMU_01.outcome == 88)
      hint: Asked only when question MMU.01 is not "None".
    items:
    - id: MMU_02
      kind: Question
      title: During the past 30 days, did you smoke it (for example, in a joint, bong, pipe, or blunt)?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't Know/Not Sure
          9: Refused
    - id: MMU_03
      kind: Question
      title: …eat it or drink it (for example, in brownies, cakes, cookies, or candy, or in tea, cola, or alcohol)?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't Know/Not Sure
          9: Refused
    - id: MMU_04
      kind: Question
      title: …vaporize it (for example, in an e-cigarette-like vaporizer or another vaporizing device)
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't Know/Not Sure
          9: Refused
    - id: MMU_05
      kind: Question
      title: '***NEW*** …dab it (for example, using a dabbing rig, knife, or dab pen)?'
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don’t Know/Not Sure
          9: Refused
    - id: MMU_06
      kind: Question
      title: '***NEW*** …use it in some other way?'
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don’t Know/Not Sure
          9: Refused
  - id: b_s45_main_method
    title: Most frequent method of marijuana use
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when the LL06 and LL03 routing allows it.
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    - predicate: not (COVID_01.outcome in [2, 7, 9])
      hint: Asked only when question COVID.01 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (COVID_02.outcome in [2, 7, 9])
      hint: Asked only when question COVID.02 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (CDEM_01.outcome < 39 or SEX.outcome == 2)
      hint: Asked only when the CDEM.01 and SEX routing allows it.
    items:
    - id: MMU_07
      kind: Question
      title: 'During the past 30 days, which one of the following ways did you use marijuana the most often? Did you usually… (Select one. If respondent provides more than one say: Which way did you use it most often? Create CATI to only show the options of use that the respondent chose in MMU.02-MMU.06.)'
      precondition:
      - predicate: (MMU_02.outcome == 1) + (MMU_03.outcome == 1) + (MMU_04.outcome == 1) + (MMU_05.outcome == 1) + (MMU_06.outcome == 1) >= 2
        hint: Asked only when two or more ways of use were answered Yes in MMU.02 to MMU.06.
      - predicate: not (MMU_01.outcome == 88)
        hint: Asked only when question MMU.01 is not "None".
      - predicate: not ((MMU_02.outcome == 1) + (MMU_03.outcome == 1) + (MMU_04.outcome == 1) + (MMU_05.outcome == 1) + (MMU_06.outcome == 1) <= 1)
        hint: Asked only when more than one way of use was answered Yes in MMU.02 to MMU.06.
      postcondition:
      - predicate: (MMU_07.outcome != 1 or MMU_02.outcome == 1) and (MMU_07.outcome != 2 or MMU_03.outcome == 1) and (MMU_07.outcome != 3 or MMU_04.outcome == 1) and (MMU_07.outcome != 4 or MMU_05.outcome == 1) and (MMU_07.outcome != 5 or MMU_06.outcome == 1)
        hint: The way of use most often in MMU.07 must be one you answered Yes to in MMU.02 to MMU.06.
        invented: true
      input:
        control: Radio
        labels:
          1: Smoke it (for example, in a joint, bong, pipe, or blunt).
          2: Eat it or drink it (for example, in brownies, cakes, cookies, or candy or in tea, cola or alcohol)
          3: Vaporize it (for example, in an e-cigarette-like vaporizer or another vaporizing device)
          4: Dab it (for example, using a dabbing rig, knife, or dab pen), or
          5: Use it some other way.
          7: Don’t know/not sure
          9: Refused
  - id: b_s46_mace
    title: 'Module 24: Adverse Childhood Experiences'
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when LL06 is not "No" while LL03 is "Yes".
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    - predicate: not (COVID_01.outcome in [2, 7, 9])
      hint: Asked only when question COVID.01 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (COVID_02.outcome in [2, 7, 9])
      hint: Asked only when question COVID.02 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (CDEM_01.outcome < 39 or SEX.outcome == 2)
      hint: Asked only when the respondent is not under 39 (CDEM.01) and not female (SEX).
    items:
    - id: MACE_01
      kind: Question
      title: Now, looking back before you were 18 years of age---. 1) Did you live with anyone who was depressed, mentally ill, or suicidal?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't Know/Not Sure
          9: Refused
    - id: MACE_02
      kind: Question
      title: Did you live with anyone who was a problem drinker or alcoholic?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't Know/Not Sure
          9: Refused
    - id: MACE_03
      kind: Question
      title: Did you live with anyone who used illegal street drugs or who abused prescription medications?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't Know/Not Sure
          9: Refused
    - id: MACE_04
      kind: Question
      title: Did you live with anyone who served time or was sentenced to serve time in a prison, jail, or other correctional facility?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don’t Know/Not Sure
          9: Refused
    - id: MACE_05
      kind: Question
      title: Were your parents separated or divorced?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          8: Parents not married
          7: Don’t Know/Not Sure
          9: Refused
    - id: MACE_06
      kind: Question
      title: How often did your parents or adults in your home ever slap, hit, kick, punch or beat each other up? Was it…
      input:
        control: Radio
        labels:
          1: Never
          2: Once
          3: More than once
          7: Don’t know/Not Sure
          9: Refused
    - id: MACE_07
      kind: Question
      title: Not including spanking, (before age 18), how often did a parent or adult in your home ever hit, beat, kick, or physically hurt you in any way? Was it—
      input:
        control: Radio
        labels:
          1: Never
          2: Once
          3: More than once
          7: Don’t know/Not Sure
          9: Refused
    - id: MACE_08
      kind: Question
      title: How often did a parent or adult in your home ever swear at you, insult you, or put you down? Was it…
      input:
        control: Radio
        labels:
          1: Never
          2: Once
          3: More than once
          7: Don’t know/Not Sure
          9: Refused
    - id: MACE_09
      kind: Question
      title: How often did anyone at least 5 years older than you or an adult, ever touch you sexually? Was it…
      input:
        control: Radio
        labels:
          1: Never
          2: Once
          3: More than once
          7: Don’t know/Not Sure
          9: Refused
    - id: MACE_10
      kind: Question
      title: How often did anyone at least 5 years older than you or an adult, try to make you touch them sexually? Was it…
      input:
        control: Radio
        labels:
          1: Never
          2: Once
          3: More than once
          7: Don’t know/Not Sure
          9: Refused
    - id: MACE_11
      kind: Question
      title: How often did anyone at least 5 years older than you or an adult, force you to have sex? Was it…
      input:
        control: Radio
        labels:
          1: Never
          2: Once
          3: More than once
          7: Don’t know/Not Sure
          9: Refused
    - id: MACE_12
      kind: Question
      title: For how much of your childhood was there an adult in your household who made you feel safe and protected? Would you say never, a little of the time, some of the time, most of the time, or all of the time?
      input:
        control: Radio
        labels:
          1: Never
          2: A little of the time
          3: Some of the time
          4: Most of the time
          5: All of the time
          7: Don’t Know/Not sure
          9: Refused
    - id: MACE_13
      kind: Question
      title: For how much of your childhood was there an adult in your household who tried hard to make sure your basic needs were met? Would you say never, a little of the time, some of the time, most of the time, or all of the time?
      input:
        control: Radio
        labels:
          1: Never
          2: A little of the time
          3: Some of the time
          4: Most of the time
          5: All of the time
          7: Don’t Know/Not sure
          9: Refused
  - id: b_s47_flu_vaccination_place
    title: 'Module 25: Place of Flu Vaccination'
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when the landline and cell phone screening answers allow it.
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    - predicate: not (COVID_01.outcome in [2, 7, 9])
      hint: Asked only when question COVID.01 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (COVID_02.outcome in [2, 7, 9])
      hint: Asked only when question COVID.02 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (CDEM_01.outcome < 39 or SEX.outcome == 2)
      hint: Asked only when the age and sex screening answers allow it.
    items:
    - id: MFP_01
      kind: Question
      title: 'At what kind of place did you get your last flu shot or vaccine? (Read if necessary: How would you describe the place where you went to get your most recent flu vaccine?)'
      precondition:
      - predicate: CIMM.outcome == 1
        hint: Asked only when question CIMM is "Yes".
      input:
        control: Dropdown
        labels:
          1: 01 A doctor's office or health maintenance organization (HMO)
          2: 02 A health department
          3: 03 Another type of clinic or health center (a community health center)
          4: 04 A senior, recreation, or community center
          5: 05 A store (supermarket, drug store)
          6: 06 A hospital (inpatient or outpatient)
          7: 07 An emergency room
          8: 08 Workplace
          9: 09 Some other kind of place
          10: 10 Received vaccination in Canada/Mexico
          11: 11 A school
          77: Don’t know / Not sure
          99: Refused
  - id: b_s48_hpv_vaccination
    title: 'Module 26: HPV - Vaccination'
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when the landline and household screening answers allow it.
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    - predicate: not (COVID_01.outcome in [2, 7, 9])
      hint: Asked only when question COVID.01 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (COVID_02.outcome in [2, 7, 9])
      hint: Asked only when question COVID.02 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (CDEM_01.outcome < 39 or SEX.outcome == 2)
      hint: Asked only when the respondent's age and sex allow this module.
    items:
    - id: MHPV_01
      kind: Question
      title: 'Have you ever had an H.P.V. vaccination? (Read if necessary: A vaccine to prevent the human papillomavirus or H.P.V. infection is available and is called the cervical cancer or genital warts vaccine, H.P.V. shot, [Fill: if female GARDASIL or CERVARIX; if male: GARDASIL].)'
      precondition:
      - predicate: MRCS_01.outcome >= 18 and MRCS_01.outcome <= 49
        hint: Asked only of adults aged 18 to 49.
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Doctor refused when asked
          7: Don't know / Not sure
          9: Refused
    - id: MHPV_02
      kind: Question
      title: How many HPV shots did you receive?
      precondition:
      - predicate: MRCS_01.outcome >= 18 and MRCS_01.outcome <= 49 and MHPV_01.outcome == 1
        hint: Asked only of adults aged 18 to 49 who have had an HPV vaccination.
      - predicate: not (MRCS_01.outcome < 18 or MRCS_01.outcome > 49)
        hint: Asked only of adults aged 18 to 49.
      - predicate: not (MHPV_01.outcome in [2, 3, 7, 9])
        hint: Asked only when question MHPV.01 is none of "No", "Doctor refused when asked", "Don't know / Not sure", "Refused".
      input:
        control: Editbox
        min: 1
        max: 99
        right: shots (3 = All shots, 77 = Don't know / Not sure, 99 = Refused)
  - id: b_s49_tdap
    title: 'Module 27: Tetanus Diphtheria (Tdap) (Adults)'
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when LL06 and LL03 do not both indicate a screen-out.
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    - predicate: not (COVID_01.outcome in [2, 7, 9])
      hint: Asked only when question COVID.01 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (COVID_02.outcome in [2, 7, 9])
      hint: Asked only when question COVID.02 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (CDEM_01.outcome < 39 or SEX.outcome == 2)
      hint: Asked only when the respondent is aged 39 or older and not female.
    items:
    - id: MTDAP_01
      kind: Question
      title: 'Have you received a tetanus shot in the past 10 years? (If yes, ask: Was this Tdap, the tetanus shot that also has pertussis or whooping cough vaccine?)'
      input:
        control: Radio
        labels:
          1: Yes, received Tdap
          2: Yes, received tetanus shot, but not Tdap
          3: Yes, received tetanus shot but not sure what type
          4: No, did not receive any tetanus shot in the past 10 years
          7: Don't know/Not sure
          9: Refused
  - id: b_s50_covid_vaccination
    title: 'Module 28: COVID Vaccination'
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when LL06 is not "No" while LL03 is "Yes".
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    - predicate: not (COVID_01.outcome in [2, 7, 9])
      hint: Asked only when question COVID.01 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (COVID_02.outcome in [2, 7, 9])
      hint: Asked only when question COVID.02 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (CDEM_01.outcome < 39 or SEX.outcome == 2)
      hint: Asked only when CDEM.01 is 39 or more and the respondent is not female.
    items:
    - id: MCOV_01
      kind: Question
      title: Have you received at least one dose of a COVID-19 vaccination?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don’t know / Not sure
          9: Refused
    - id: MCOV_02
      kind: Question
      title: Would you say you will definitely get a vaccine, will probably get a vaccine, will probably not get a vaccine, will definitely not get a vaccine, or are you not sure?
      precondition:
      - predicate: not (MCOV_01.outcome == 1)
        hint: Asked only when question MCOV.01 is not "Yes".
      - predicate: not (MCOV_01.outcome in [7, 9])
        hint: Asked only when question MCOV.01 is none of "Don’t know / Not sure", "Refused".
      input:
        control: Radio
        labels:
          1: Will definitely get a vaccine
          2: Will probably get a vaccine
          3: Will probably not get a vaccine
          4: Will definitely not get a vaccine
          7: Don’t know/Not sure
          9: Refused
    - id: MCOV_03
      kind: Question
      title: How many COVID-19 vaccinations have you received?
      precondition:
      - predicate: not (MCOV_01.outcome in [7, 9])
        hint: Asked only when question MCOV.01 is none of "Don’t know / Not sure", "Refused".
      - predicate: not (MCOV_02.outcome in [1, 2, 3, 4, 7, 9])
        hint: Asked only when question MCOV.02 is none of "Will definitely get a vaccine", "Will probably get a vaccine", "Will probably not get a vaccine", "Will definitely not get a vaccine", "Don’t know/Not sure", "Refused".
      input:
        control: Dropdown
        labels:
          1: One
          2: Two
          3: Three
          4: Four
          5: Five or more
          7: Don’t know / Not sure
          9: Refused
  - id: b_s51_social_determinants
    title: 'Module 29: Social Determinants and Health Equity'
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when LL06 is not "No" while LL03 is "Yes".
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    - predicate: not (COVID_01.outcome in [2, 7, 9])
      hint: Asked only when question COVID.01 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (COVID_02.outcome in [2, 7, 9])
      hint: Asked only when question COVID.02 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (CDEM_01.outcome < 39 or SEX.outcome == 2)
      hint: Asked only when CDEM.01 is 39 or older and the respondent's sex is not 2.
    items:
    - id: MSDHE_01
      kind: Question
      title: In general, how satisfied are you with your life? Are you..
      input:
        control: Radio
        labels:
          1: Very satisfied
          2: Satisfied
          3: Dissatisfied
          4: Very dissatisfied
          7: Don't know/not sure
          9: Refused
    - id: MSDHE_02
      kind: Question
      title: How often do you get the social and emotional support that you need? Is that…
      input:
        control: Radio
        labels:
          1: Always
          2: Usually
          3: Sometimes
          4: Rarely
          5: Never
          7: Don't know/not sure
          9: Refused
    - id: MSDHE_03
      kind: Question
      title: How often do you feel lonely? Is it…
      input:
        control: Radio
        labels:
          1: Always
          2: Usually
          3: Sometimes
          4: Rarely
          5: Never
          7: Don't know/not sure
          9: Refused
    - id: MSDHE_04
      kind: Question
      title: In the past 12 months have you lost employment or had hours reduced?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't Know/ Not sure
          9: Refused
    - id: MSDHE_05
      kind: Question
      title: During the past 12 months, have you received food stamps, also called SNAP, the Supplemental Nutrition Assistance Program on an EBT card?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don’t Know/ Not sure
          9: Refused
    - id: MSDHE_06
      kind: Question
      title: During the past 12 months how often did the food that you bought not last, and you didn’t have money to get more? Was that…
      input:
        control: Radio
        labels:
          1: Always
          2: Usually
          3: Sometimes
          4: Rarely
          5: Never
          7: Don’t know/not sure
          9: Refused
    - id: MSDHE_07
      kind: Question
      title: During the last 12 months, was there a time when you were not able to pay your mortgage, rent or utility bills?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don’t Know/ Not sure
          9: Refused
    - id: MSDHE_08
      kind: Question
      title: During the last 12 months was there a time when an electric, gas, oil, or water company threatened to shut off services?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don’t Know/ Not sure
          9: Refused
    - id: MSDHE_09
      kind: Question
      title: During the past 12 months has a lack of reliable transportation kept you from medical appointments, meetings, work, or from getting things needed for daily living?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don’t Know/ Not sure
          9: Refused
    - id: MSDHE_10
      kind: Question
      title: Stress means a situation in which a person feels tense, restless, nervous or anxious or is unable to sleep at night because their mind is troubled all the time. Within the last 30 days, how often have you felt this kind of stress? Was it…
      input:
        control: Radio
        labels:
          1: Always
          2: Usually
          3: Sometimes
          4: Rarely
          5: Never
          7: Don’t know/not sure
          9: Refused
  - id: b_s52_external
    title: External inputs
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when LL06 is not "No" together with LL03 "Yes".
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    - predicate: not (COVID_01.outcome in [2, 7, 9])
      hint: Asked only when question COVID.01 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (COVID_02.outcome in [2, 7, 9])
      hint: Asked only when question COVID.02 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (CDEM_01.outcome < 39 or SEX.outcome == 2)
      hint: Asked only when CDEM.01 is 39 or older and sex is not Female.
    items:
    - id: CDEM_13_2
      kind: Question
      title: 'Employment status, from the core questionnaire (referenced by MIO.01/MIO.02): 1 Employed for wages, 2 Self-employed, 4 Out of work for less than 1 year'
      external: true
      input:
        control: Radio
        labels:
          1: Employed for wages
          2: Self-employed
          4: Out of work for less than 1 year
    - id: LL10_2
      kind: Question
      title: 'Sex of respondent from the landline core (referenced by MSAB.01 and MSOGI): coded 1 or 2'
      external: true
      input:
        control: Radio
        labels:
          1: Male
          2: Female
    - id: CP06_2
      kind: Question
      title: 'Sex of respondent from the cell phone core (referenced by MSAB.01 and MSOGI): coded 1 or 2'
      external: true
      input:
        control: Radio
        labels:
          1: Male
          2: Female
    - id: CP05_3
      kind: Question
      title: Cell phone core variable used with LL10, CP06 and LL09 to determine sex (referenced by MSOGI.01/MSOGI.02); coding not given in this part
      external: true
      input:
        control: Radio
        labels:
          1: Value as coded in core
    - id: LL09_3
      kind: Question
      title: Landline core variable used with LL10, CP06 and CP05 to determine sex (referenced by MSOGI.01/MSOGI.02); coding not given in this part
      external: true
      input:
        control: Radio
        labels:
          1: Value as coded in core
    - id: CIMM
      kind: Question
      title: 'Core immunization variable (flu shot received), referenced by MFP.01: 1 = yes'
      external: true
      input:
        control: Radio
        labels:
          1: 'Yes'
    - id: MRCS_01
      kind: Question
      title: Age of respondent, from the core (MRCS.01), used to restrict MHPV.01 to ages 18-49
      external: true
      input:
        control: Editbox
        min: 0
        max: 120
  - id: b_s53_reactions_to_race
    title: 'Module 30: Reactions to Race'
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when LL06 and LL03 are not both at their screening-out answers.
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    - predicate: not (COVID_01.outcome in [2, 7, 9])
      hint: Asked only when question COVID.01 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (COVID_02.outcome in [2, 7, 9])
      hint: Asked only when question COVID.02 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (CDEM_01.outcome < 39 or SEX.outcome == 2)
      hint: Asked only when the respondent is aged 39 or older and SEX is not 2.
    items:
    - id: MRTR_01
      kind: Question
      title: 'Earlier I asked you to self-identify your race. Now I will ask you how other people identify you and treat you. How do other people usually classify you in this country? Would you say: White, Black or African American, Hispanic or Latino, Asian, Native Hawaiian or Other Pacific Islander, American Indian or Alaska Native, or some other group? [Interviewer note: If the respondent requests clarification of this question, say: “We want to know how OTHER people usually classify you in this country, which might be different from how you classify yourself.” Interviewer note: do not offer “mixed race” as a category but use as a code if respondent offers it.]'
      input:
        control: Dropdown
        labels:
          1: White
          2: Black or African American
          3: Hispanic or Latino
          4: Asian
          5: Native Hawaiian or Other Pacific Islander
          6: American Indian or Alaska Native
          7: Mixed Race
          8: Some other group
          77: Don't know / Not sure
          99: Refused
    - id: MRTR_02
      kind: Question
      title: 'How often do you think about your race? Would you say never, once a year, once a month, once a week, once a day, once an hour, or constantly? [Interviewer note: The responses can be interpreted as meaning "at least" the indicated time frequency. If a respondent cannot decide between two categories, check the response for the lower frequency. For example, if a respondent says that they think about their race between once a week and once a month, check "once a month" as the response.]'
      input:
        control: Radio
        labels:
          1: Never
          2: Once a year
          3: Once a month
          4: Once a week
          5: Once a day
          6: Once an hour
          8: Constantly
          7: Don't know / Not sure
          9: Refused
    - id: MRTR_03
      kind: Question
      title: 'Within the past 12 months, do you feel that in general you were treated worse than, the same as, or better than people of other races? (Read if necessary: responses)'
      input:
        control: Radio
        labels:
          1: Worse than other races
          2: The same as other races
          3: Better than other races
          4: Worse than some races, better than others
          5: Only encountered people of the same race
          7: Don't know / Not sure
          9: Refused
    - id: MRTR_04
      kind: Question
      title: Within the past 12 months at work, do you feel you were treated worse than, the same as, or better than people of other races?
      precondition:
      - predicate: CDEM_13_2.outcome in [1, 2, 4]
        hint: Asked only when question CDEM.13 is one of "Employed for wages", "Self-employed", "Out of work for less than 1 year".
      input:
        control: Radio
        labels:
          1: Worse than other races
          2: The same as other races
          3: Better than other races
          4: Worse than some races, better than others
          5: Only encountered people of the same race
          7: Don’t know / Not sure
          9: Refused
    - id: MRTR_05
      kind: Question
      title: 'Within the past 12 months, when seeking health care, do you feel your experiences were worse than, the same as, or better than for people of other races? [Interviewer note: If the respondent indicates that they do not know about other people’s experiences when seeking health care, say: “This question is asking about your perceptions when seeking health care. It does not require specific knowledge about other people’s experiences”]'
      input:
        control: Radio
        labels:
          1: Worse than other races
          2: The same as other races
          3: Better than other races
          4: Worse than some races, better than others
          5: Only encountered people of the same race
          7: Don’t know / Not sure
          9: Refused
    - id: MRTR_06
      kind: Question
      title: Within the past 30 days, have you experienced any physical symptoms, for example, a headache, an upset stomach, tensing of your muscles, or a pounding heart, as a result of how you were treated based on your race?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don’t know / Not sure
          9: Refused
  - id: b_s54_random_child
    title: 'Module 31: Random Child Selection'
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when LL06 is not "No" while LL03 is "Yes".
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    - predicate: not (COVID_01.outcome in [2, 7, 9])
      hint: Asked only when question COVID.01 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (COVID_02.outcome in [2, 7, 9])
      hint: Asked only when question COVID.02 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (CDEM_01.outcome < 39 or SEX.outcome == 2)
      hint: Asked only when CDEM.01 is 39 or older and the respondent's sex is not 2.
    - predicate: not (CDEM_14.outcome in [88, 99])
      hint: Asked only when question CDEM.14 is none of "None", "Refused".
    items:
    - id: MRCS_01_2
      kind: Question
      title: What is the birth month and year of the [Xth] child? (__/____ Code month and year)
      input:
        control: Textarea
        placeholder: MM/YYYY (77/7777 Don't know / Not sure; 99/9999 Refused)
    - id: MRCS_02
      kind: Question
      title: Is the child a boy or a girl?
      input:
        control: Radio
        labels:
          1: Boy
          2: Girl
          3: Nonbinary/other
          9: Refused
    - id: MRCS_03
      kind: Question
      title: What was the child’s sex on their original birth certificate?
      precondition:
      - predicate: not (MRCS_02.outcome in [1, 2])
        hint: Asked only when question MRCS.02 is none of "Boy", "Girl".
      input:
        control: Radio
        labels:
          1: Boy
          2: Girl
          9: Refused
    - id: MRCS_04
      kind: Question
      title: 'Is the child Hispanic, Latino/a, or Spanish origin? [Interviewer note: If yes, ask: Are they… ] (Options 1-4: Read if response is yes; options 5, 7, 9: Do not read)'
      input:
        control: Radio
        labels:
          1: Mexican, Mexican American, Chicano/a (read if response is yes)
          2: Puerto Rican (read if response is yes)
          3: Cuban (read if response is yes)
          4: Another Hispanic, Latino/a, or Spanish origin (read if response is yes)
          5: No (do not read)
          7: Don’t know / Not sure (do not read)
          9: Refused (do not read)
    - id: MRCS_05
      kind: Question
      title: Which one or more of the following would you say is the race of the child? [Select all that apply. If 40 (Asian) or 50 (Pacific Islander) is selected read and code subcategories underneath major heading.]
      input:
        control: Checkbox
        labels:
          1: 10 — White
          2: 20 — Black or African American
          4: 30 — American Indian or Alaska Native
          8: 40 — Asian
          16: 41 — Asian Indian
          32: 42 — Chinese
          64: 43 — Filipino
          128: 44 — Japanese
          256: 45 — Korean
          512: 46 — Vietnamese
          1024: 47 — Other Asian
          2048: 50 — Pacific Islander
          4096: 51 — Native Hawaiian
          8192: 52 — Guamanian or Chamorro
          16384: 53 — Samoan
          32768: 54 — Other Pacific Islander
          65536: 60 — Other (Do not read)
          131072: 88 — No additional choices
          262144: 77 — Don’t know / Not sure
          524288: 99 — Refused
    - id: MRCS_06
      kind: Question
      title: How are you related to the child? Are you a-- (Please read options 1-6; do not read 7 and 9)
      input:
        control: Radio
        labels:
          1: Parent (include biologic, step, or adoptive parent)
          2: Grandparent
          3: Foster parent or guardian
          4: Sibling (include biologic, step, and adoptive sibling)
          5: Other relative
          6: Not related in any way
          7: Don’t know / Not sure
          9: Refused
  - id: b_s55_childhood_asthma
    title: 'Module 32: Childhood Asthma Prevalence'
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when LL06 is not "No" together with LL03 "Yes".
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    - predicate: not (COVID_01.outcome in [2, 7, 9])
      hint: Asked only when question COVID.01 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (COVID_02.outcome in [2, 7, 9])
      hint: Asked only when question COVID.02 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (CDEM_01.outcome < 39 or SEX.outcome == 2)
      hint: Asked only when CDEM.01 is 39 or more and the respondent is not female.
    - predicate: not (CDEM_14.outcome in [88, 99])
      hint: Asked only when question CDEM.14 is none of "None", "Refused".
    items:
    - id: MCAP_01
      kind: Question
      title: The next two questions are about the Xth child. [Fill in correct [Xth] number.] Has a doctor, nurse or other health professional EVER said that the child has asthma?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know/ not sure
          9: Refused
    - id: MCAP_02
      kind: Question
      title: Does the child still have asthma?
      precondition:
      - predicate: not (MCAP_01.outcome in [2, 7, 9])
        hint: Asked only when question MCAP.01 is none of "No", "Don't know/ not sure", "Refused".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          7: Don't know/ not sure
          9: Refused
  - id: b_s56_asthma_callback
    title: Asthma Call-Back Permission Script
    precondition:
    - predicate: not (LL01.outcome == 2)
      hint: Asked only when question LL01. is not "No".
    - predicate: not (LL02.outcome == 3)
      hint: Asked only when question LL02. is not "No, this is a business".
    - predicate: not (LL03.outcome == 2)
      hint: Asked only when question LL03. is not "No".
    - predicate: not (LL04.outcome == 2)
      hint: Asked only when question LL04. is not "No".
    - predicate: not (LL05.outcome == 1)
      hint: Asked only when question LL05. is not "Yes, it is a cell phone".
    - predicate: not (LL06.outcome == 2 and LL03.outcome == 1)
      hint: Asked only when LL06. is not "No" while LL03. is "Yes".
    - predicate: not (LL10.outcome in [7, 9])
      hint: Asked only when question LL10 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP01.outcome == 2)
      hint: Asked only when question CP01. is not "No".
    - predicate: not (CP02.outcome == 2)
      hint: Asked only when question CP02. is not "No".
    - predicate: not (CP03.outcome == 2)
      hint: Asked only when question CP03. is not "No".
    - predicate: not (CP04.outcome == 2)
      hint: Asked only when question CP04. is not "No".
    - predicate: not (CP06.outcome in [7, 9])
      hint: Asked only when question CP06 is none of "Don't know/Not sure", "Refused".
    - predicate: not (CP08.outcome == 2)
      hint: Asked only when question CP08. is not "No".
    - predicate: not (CP10.outcome in [77, 99])
      hint: Asked only when question CP10. is none of "Live outside US and participating territories", "Refused".
    - predicate: not (COVID_01.outcome in [2, 7, 9])
      hint: Asked only when question COVID.01 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (COVID_02.outcome in [2, 7, 9])
      hint: Asked only when question COVID.02 is none of "No", "Don't know / Not sure", "Refused".
    - predicate: not (CDEM_01.outcome < 39 or SEX.outcome == 2)
      hint: Asked only when CDEM.01 is 39 or older and sex is not 2.
    items:
    - id: CB01_01
      kind: Question
      title: Would it be okay if we called you back to ask additional asthma-related questions at a later time?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: CB01_02
      kind: Question
      title: Which person in the household was selected as the focus of the asthma call-back?
      input:
        control: Radio
        labels:
          1: Adult
          2: Child
    - id: CB01_03
      kind: Question
      title: Can I please have either (your/your child’s) first name or initials, so we will know who to ask for when we call back? Enter first name or initials.
      input:
        control: Textarea
