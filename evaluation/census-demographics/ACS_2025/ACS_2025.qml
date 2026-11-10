qmlVersion: '2.7'
questionnaire:
  title: American Community Survey
  blocks:
  - id: b_s1_start_here
    title: Start Here
    items:
    - id: RESP_NAME
      kind: Question
      title: Please print the name and telephone number of the person who is filling out this form. Last Name / First Name / MI
      input:
        control: Textarea
        maxLength: 200
    - id: RESP_PHONE
      kind: Question
      title: Area Code + Number
      input:
        control: Textarea
        maxLength: 30
    - id: HH_COUNT
      kind: Question
      title: How many people, including yourself, live or stay at this address? INCLUDE... anyone not related to you, like roommates and other families. babies and children, related or unrelated, including grandchildren and foster children. everyone staying here now who has no other place to stay. DO NOT INCLUDE anyone living somewhere else, such as... a college student living away. someone in the Armed Forces on deployment. Number of people
      input:
        control: Editbox
        min: 1
        max: 99
        right: people
  - id: b_s2_person1
    title: Person 1
    items:
    - id: TODAY_DATE
      kind: Question
      title: Please print today’s date. Month Day Year
      input:
        control: Textarea
        maxLength: 20
    - id: P1_1
      kind: Question
      title: 1 What is Person 1’s name? Last Name (Please print) First Name MI
      input:
        control: Textarea
        maxLength: 200
    - id: P1_3
      kind: Question
      title: 3 What is Person 1’s sex? Mark (X) ONE box.
      input:
        control: Radio
        labels:
          1: Male
          2: Female
    - id: P1_4
      kind: Question
      title: 4 What is Person 1’s age and what is Person 1’s date of birth? For babies less than 1 year old, do not write the age in months. Write 0 as the age. Print numbers in boxes. Age (in years)
      input:
        control: Editbox
        min: 0
        max: 120
    - id: P1_4DOB
      kind: Question
      title: 4 ... Person 1’s date of birth? Print numbers in boxes. Month Day Year of birth (printed without a separate id; second field of question 4)
      input:
        control: Textarea
        maxLength: 20
    - id: P1_5
      kind: Question
      title: 'NOTE: Please answer BOTH Question 5 about Hispanic origin and Question 6 about race. For this survey, Hispanic origins are not races. 5 Is Person 1 of Hispanic, Latino, or Spanish origin?'
      input:
        control: Radio
        labels:
          1: No, not of Hispanic, Latino, or Spanish origin
          2: Yes, Mexican, Mexican Am., Chicano
          3: Yes, Puerto Rican
          4: Yes, Cuban
          5: Yes, another Hispanic, Latino, or Spanish origin – Print, for example, Salvadoran, Dominican, Colombian, Guatemalan, Spaniard, Ecuadorian, etc.
    - id: P1_6
      kind: Question
      title: 6 What is Person 1’s race? Mark (X) one or more boxes AND print origins.
      input:
        control: Checkbox
        labels:
          1: White – Print, for example, German, Irish, English, Italian, Lebanese, Egyptian, etc.
          2: Black or African Am. – Print, for example, African American, Jamaican, Haitian, Nigerian, Ethiopian, Somali, etc.
          4: American Indian or Alaska Native – Print name of enrolled or principal tribe(s), for example, Navajo Nation, Blackfeet Tribe, Mayan, Aztec, Native Village of Barrow Inupiat Traditional Government, Nome Eskimo Community, etc.
          8: Chinese
          16: Vietnamese
          32: Native Hawaiian
          64: Filipino
          128: Korean
          256: Samoan
          512: Asian Indian
          1024: Japanese
          2048: Chamorro
          4096: Other Asian – Print, for example, Pakistani, Cambodian, Hmong, etc.
          8192: Other Pacific Islander – Print, for example, Tongan, Fijian, Marshallese, etc.
          16384: Some other race – Print race or origin.
  - id: b_s3_person2
    title: Person 2
    items:
    - id: P2_1
      kind: Question
      title: 1 What is Person 2’s name? Last Name (Please print) First Name MI
      input:
        control: Textarea
    - id: P2_2
      kind: Question
      title: 2 How is this person related to Person 1? Mark (X) ONE box.
      input:
        control: Dropdown
        labels:
          1: Opposite-sex husband/wife/spouse
          2: Opposite-sex unmarried partner
          3: Same-sex husband/wife/spouse
          4: Same-sex unmarried partner
          5: Biological son or daughter
          6: Adopted son or daughter
          7: Stepson or stepdaughter
          8: Brother or sister
          9: Father or mother
          10: Grandchild
          11: Parent-in-law
          12: Son-in-law or daughter-in-law
          13: Other relative
          14: Roommate or housemate
          15: Foster child
          16: Other nonrelative
    - id: P2_3
      kind: Question
      title: 3 What is Person 2’s sex? Mark (X) ONE box.
      input:
        control: Radio
        labels:
          1: Male
          2: Female
    - id: P2_4
      kind: Question
      title: 4 What is Person 2’s age and what is Person 2’s date of birth? For babies less than 1 year old, do not write the age in months. Write 0 as the age. Print numbers in boxes. Age (in years)
      input:
        control: Editbox
        min: 0
        max: 120
    - id: P2_4DOB
      kind: Question
      title: 4 ... Person 2’s date of birth? Print numbers in boxes. Month Day Year of birth (printed without a separate id; second field of question 4)
      input:
        control: Textarea
    - id: P2_5
      kind: Question
      title: 'NOTE: Please answer BOTH Question 5 about Hispanic origin and Question 6 about race. For this survey, Hispanic origins are not races. 5 Is Person 2 of Hispanic, Latino, or Spanish origin?'
      input:
        control: Radio
        labels:
          1: No, not of Hispanic, Latino, or Spanish origin
          2: Yes, Mexican, Mexican Am., Chicano
          3: Yes, Puerto Rican
          4: Yes, Cuban
          5: Yes, another Hispanic, Latino, or Spanish origin – Print, for example, Salvadoran, Dominican, Colombian, Guatemalan, Spaniard, Ecuadorian, etc.
    - id: P2_6
      kind: Question
      title: 6 What is Person 2’s race? Mark (X) one or more boxes AND print origins.
      input:
        control: Checkbox
        labels:
          1: White – Print, for example, German, Irish, English, Italian, Lebanese, Egyptian, etc.
          2: Black or African Am. – Print, for example, African American, Jamaican, Haitian, Nigerian, Ethiopian, Somali, etc.
          4: American Indian or Alaska Native – Print name of enrolled or principal tribe(s), for example, Navajo Nation, Blackfeet Tribe, Mayan, Aztec, Native Village of Barrow Inupiat Traditional Government, Nome Eskimo Community, etc.
          8: Chinese
          16: Vietnamese
          32: Native Hawaiian
          64: Filipino
          128: Korean
          256: Samoan
          512: Asian Indian
          1024: Japanese
          2048: Chamorro
          4096: Other Asian – Print, for example, Pakistani, Cambodian, Hmong, etc.
          8192: Other Pacific Islander – Print, for example, Tongan, Fijian, Marshallese, etc.
          16384: Some other race – Print race or origin.
  - id: b_s4_person3
    title: Person 3
    items:
    - id: P3_1
      kind: Question
      title: 1 What is Person 3’s name? Last Name (Please print) First Name MI
      input:
        control: Textarea
    - id: P3_2
      kind: Question
      title: 2 How is this person related to Person 1? Mark (X) ONE box.
      input:
        control: Dropdown
        labels:
          1: Opposite-sex husband/wife/spouse
          2: Opposite-sex unmarried partner
          3: Same-sex husband/wife/spouse
          4: Same-sex unmarried partner
          5: Biological son or daughter
          6: Adopted son or daughter
          7: Stepson or stepdaughter
          8: Brother or sister
          9: Father or mother
          10: Grandchild
          11: Parent-in-law
          12: Son-in-law or daughter-in-law
          13: Other relative
          14: Roommate or housemate
          15: Foster child
          16: Other nonrelative
    - id: P3_3
      kind: Question
      title: 3 What is Person 3’s sex? Mark (X) ONE box.
      input:
        control: Radio
        labels:
          1: Male
          2: Female
    - id: P3_4
      kind: Question
      title: 4 What is Person 3’s age and what is Person 3’s date of birth? For babies less than 1 year old, do not write the age in months. Write 0 as the age. Print numbers in boxes. Age (in years)
      input:
        control: Editbox
        min: 0
        max: 120
    - id: P3_4DOB
      kind: Question
      title: 4 ... Person 3’s date of birth? Print numbers in boxes. Month Day Year of birth (printed without a separate id; second field of question 4)
      input:
        control: Textarea
    - id: P3_5
      kind: Question
      title: 'NOTE: Please answer BOTH Question 5 about Hispanic origin and Question 6 about race. For this survey, Hispanic origins are not races. 5 Is Person 3 of Hispanic, Latino, or Spanish origin?'
      input:
        control: Radio
        labels:
          1: No, not of Hispanic, Latino, or Spanish origin
          2: Yes, Mexican, Mexican Am., Chicano
          3: Yes, Puerto Rican
          4: Yes, Cuban
          5: Yes, another Hispanic, Latino, or Spanish origin – Print, for example, Salvadoran, Dominican, Colombian, Guatemalan, Spaniard, Ecuadorian, etc.
    - id: P3_6
      kind: Question
      title: 6 What is Person 3’s race? Mark (X) one or more boxes AND print origins.
      input:
        control: Checkbox
        labels:
          1: White – Print, for example, German, Irish, English, Italian, Lebanese, Egyptian, etc.
          2: Black or African Am. – Print, for example, African American, Jamaican, Haitian, Nigerian, Ethiopian, Somali, etc.
          4: American Indian or Alaska Native – Print name of enrolled or principal tribe(s), for example, Navajo Nation, Blackfeet Tribe, Mayan, Aztec, Native Village of Barrow Inupiat Traditional Government, Nome Eskimo Community, etc.
          8: Chinese
          16: Vietnamese
          32: Native Hawaiian
          64: Filipino
          128: Korean
          256: Samoan
          512: Asian Indian
          1024: Japanese
          2048: Chamorro
          4096: Other Asian – Print, for example, Pakistani, Cambodian, Hmong, etc.
          8192: Other Pacific Islander – Print, for example, Tongan, Fijian, Marshallese, etc.
          16384: Some other race – Print race or origin.
  - id: b_s5_person4
    title: Person 4
    items:
    - id: P4_1
      kind: Question
      title: 1 What is Person 4’s name? Last Name (Please print) First Name MI
      input:
        control: Textarea
    - id: P4_2
      kind: Question
      title: 2 How is this person related to Person 1? Mark (X) ONE box.
      input:
        control: Dropdown
        labels:
          1: Opposite-sex husband/wife/spouse
          2: Opposite-sex unmarried partner
          3: Same-sex husband/wife/spouse
          4: Same-sex unmarried partner
          5: Biological son or daughter
          6: Adopted son or daughter
          7: Stepson or stepdaughter
          8: Brother or sister
          9: Father or mother
          10: Grandchild
          11: Parent-in-law
          12: Son-in-law or daughter-in-law
          13: Other relative
          14: Roommate or housemate
          15: Foster child
          16: Other nonrelative
    - id: P4_3
      kind: Question
      title: 3 What is Person 4’s sex? Mark (X) ONE box.
      input:
        control: Radio
        labels:
          1: Male
          2: Female
    - id: P4_4
      kind: Question
      title: 4 What is Person 4’s age and what is Person 4’s date of birth? For babies less than 1 year old, do not write the age in months. Write 0 as the age. Print numbers in boxes. Age (in years)
      input:
        control: Editbox
        min: 0
        max: 120
    - id: P4_4DOB
      kind: Question
      title: 4 ... Person 4’s date of birth? Print numbers in boxes. Month Day Year of birth (printed without a separate id; second field of question 4)
      input:
        control: Textarea
    - id: P4_5
      kind: Question
      title: 'NOTE: Please answer BOTH Question 5 about Hispanic origin and Question 6 about race. For this survey, Hispanic origins are not races. 5 Is Person 4 of Hispanic, Latino, or Spanish origin?'
      input:
        control: Radio
        labels:
          1: No, not of Hispanic, Latino, or Spanish origin
          2: Yes, Mexican, Mexican Am., Chicano
          3: Yes, Puerto Rican
          4: Yes, Cuban
          5: Yes, another Hispanic, Latino, or Spanish origin – Print, for example, Salvadoran, Dominican, Colombian, Guatemalan, Spaniard, Ecuadorian, etc.
    - id: P4_6
      kind: Question
      title: 6 What is Person 4’s race? Mark (X) one or more boxes AND print origins.
      input:
        control: Checkbox
        labels:
          1: White – Print, for example, German, Irish, English, Italian, Lebanese, Egyptian, etc.
          2: Black or African Am. – Print, for example, African American, Jamaican, Haitian, Nigerian, Ethiopian, Somali, etc.
          4: American Indian or Alaska Native – Print name of enrolled or principal tribe(s), for example, Navajo Nation, Blackfeet Tribe, Mayan, Aztec, Native Village of Barrow Inupiat Traditional Government, Nome Eskimo Community, etc.
          8: Chinese
          16: Vietnamese
          32: Native Hawaiian
          64: Filipino
          128: Korean
          256: Samoan
          512: Asian Indian
          1024: Japanese
          2048: Chamorro
          4096: Other Asian – Print, for example, Pakistani, Cambodian, Hmong, etc.
          8192: Other Pacific Islander – Print, for example, Tongan, Fijian, Marshallese, etc.
          16384: Some other race – Print race or origin.
  - id: b_s6_person5
    title: Person 5
    items:
    - id: P5_1
      kind: Question
      title: 1 What is Person 5's name? Last Name (Please print) First Name MI
      input:
        control: Textarea
    - id: P5_2
      kind: Question
      title: 2 How is this person related to Person 1? Mark (X) ONE box.
      input:
        control: Dropdown
        labels:
          1: Opposite-sex husband/wife/spouse
          2: Opposite-sex unmarried partner
          3: Same-sex husband/wife/spouse
          4: Same-sex unmarried partner
          5: Biological son or daughter
          6: Adopted son or daughter
          7: Stepson or stepdaughter
          8: Brother or sister
          9: Father or mother
          10: Grandchild
          11: Parent-in-law
          12: Son-in-law or daughter-in-law
          13: Other relative
          14: Roommate or housemate
          15: Foster child
          16: Other nonrelative
    - id: P5_3
      kind: Question
      title: 3 What is Person 5's sex? Mark (X) ONE box.
      input:
        control: Radio
        labels:
          1: Male
          2: Female
    - id: P5_4
      kind: Question
      title: 4 What is Person 5's age and what is Person 5's date of birth? For babies less than 1 year old, do not write the age in months. Write 0 as the age. Print numbers in boxes. Age (in years)
      input:
        control: Editbox
        min: 0
        max: 120
    - id: P5_4DOB
      kind: Question
      title: 4 ... Person 5's date of birth? Print numbers in boxes. Month Day Year of birth (printed without a separate id; second field of question 4)
      input:
        control: Textarea
    - id: P5_5
      kind: Question
      title: 'NOTE: Please answer BOTH Question 5 about Hispanic origin and Question 6 about race. For this survey, Hispanic origins are not races. 5 Is Person 5 of Hispanic, Latino, or Spanish origin?'
      input:
        control: Radio
        labels:
          1: No, not of Hispanic, Latino, or Spanish origin
          2: Yes, Mexican, Mexican Am., Chicano
          3: Yes, Puerto Rican
          4: Yes, Cuban
          5: Yes, another Hispanic, Latino, or Spanish origin – Print, for example, Salvadoran, Dominican, Colombian, Guatemalan, Spaniard, Ecuadorian, etc.
    - id: P5_6
      kind: Question
      title: 6 What is Person 5's race? Mark (X) one or more boxes AND print origins.
      input:
        control: Checkbox
        labels:
          1: White – Print, for example, German, Irish, English, Italian, Lebanese, Egyptian, etc.
          2: Black or African Am. – Print, for example, African American, Jamaican, Haitian, Nigerian, Ethiopian, Somali, etc.
          4: American Indian or Alaska Native – Print name of enrolled or principal tribe(s), for example, Navajo Nation, Blackfeet Tribe, Mayan, Aztec, Native Village of Barrow Inupiat Traditional Government, Nome Eskimo Community, etc.
          8: Chinese
          16: Vietnamese
          32: Native Hawaiian
          64: Filipino
          128: Korean
          256: Samoan
          512: Asian Indian
          1024: Japanese
          2048: Chamorro
          4096: Other Asian – Print, for example, Pakistani, Cambodian, Hmong, etc.
          8192: Other Pacific Islander – Print, for example, Tongan, Fijian, Marshallese, etc.
          16384: Some other race – Print race or origin.
  - id: b_s7_person6
    title: Person 6
    precondition:
    - predicate: HH_COUNT.outcome >= 6
      hint: Asked only when the household has six or more people
    items:
    - id: P6_NAME
      kind: Question
      title: Person 6 Last Name (Please print) First Name MI
      input:
        control: Textarea
    - id: P6_SEX
      kind: Question
      title: Person 6 Sex Male Female
      input:
        control: Radio
        labels:
          1: Male
          2: Female
    - id: P6_AGE
      kind: Question
      title: Person 6 Age (in years)
      input:
        control: Editbox
        min: 0
        max: 120
  - id: b_s7_person7
    title: Person 7
    precondition:
    - predicate: HH_COUNT.outcome >= 7
      hint: Asked only when the household has seven or more people
    items:
    - id: P7_NAME
      kind: Question
      title: Person 7 Last Name (Please print) First Name MI
      input:
        control: Textarea
    - id: P7_SEX
      kind: Question
      title: Person 7 Sex Male Female
      input:
        control: Radio
        labels:
          1: Male
          2: Female
    - id: P7_AGE
      kind: Question
      title: Person 7 Age (in years)
      input:
        control: Editbox
        min: 0
        max: 120
  - id: b_s7_person8
    title: Person 8
    precondition:
    - predicate: HH_COUNT.outcome >= 8
      hint: Asked only when the household has eight or more people
    items:
    - id: P8_NAME
      kind: Question
      title: Person 8 Last Name (Please print) First Name MI
      input:
        control: Textarea
    - id: P8_SEX
      kind: Question
      title: Person 8 Sex Male Female
      input:
        control: Radio
        labels:
          1: Male
          2: Female
    - id: P8_AGE
      kind: Question
      title: Person 8 Age (in years)
      input:
        control: Editbox
        min: 0
        max: 120
  - id: b_s7_person9
    title: Person 9
    precondition:
    - predicate: HH_COUNT.outcome >= 9
      hint: Asked only when the household has nine or more people
    items:
    - id: P9_NAME
      kind: Question
      title: Person 9 Last Name (Please print) First Name MI
      input:
        control: Textarea
    - id: P9_SEX
      kind: Question
      title: Person 9 Sex Male Female
      input:
        control: Radio
        labels:
          1: Male
          2: Female
    - id: P9_AGE
      kind: Question
      title: Person 9 Age (in years)
      input:
        control: Editbox
        min: 0
        max: 120
  - id: b_s7_person10
    title: Person 10
    precondition:
    - predicate: HH_COUNT.outcome >= 10
      hint: Asked only when the household has ten or more people
    items:
    - id: P10_NAME
      kind: Question
      title: Person 10 Last Name (Please print) First Name MI
      input:
        control: Textarea
    - id: P10_SEX
      kind: Question
      title: Person 10 Sex Male Female
      input:
        control: Radio
        labels:
          1: Male
          2: Female
    - id: P10_AGE
      kind: Question
      title: Person 10 Age (in years)
      input:
        control: Editbox
        min: 0
        max: 120
  - id: b_s7_person11
    title: Person 11
    precondition:
    - predicate: HH_COUNT.outcome >= 11
      hint: Asked only when the household has eleven or more people
    items:
    - id: P11_NAME
      kind: Question
      title: Person 11 Last Name (Please print) First Name MI
      input:
        control: Textarea
    - id: P11_SEX
      kind: Question
      title: Person 11 Sex Male Female
      input:
        control: Radio
        labels:
          1: Male
          2: Female
    - id: P11_AGE
      kind: Question
      title: Person 11 Age (in years)
      input:
        control: Editbox
        min: 0
        max: 120
  - id: b_s7_person12
    title: Person 12
    precondition:
    - predicate: HH_COUNT.outcome >= 12
      hint: Asked only when the household has twelve people
    items:
    - id: P12_NAME
      kind: Question
      title: Person 12 Last Name (Please print) First Name MI
      input:
        control: Textarea
    - id: P12_SEX
      kind: Question
      title: Person 12 Sex Male Female
      input:
        control: Radio
        labels:
          1: Male
          2: Female
    - id: P12_AGE
      kind: Question
      title: Person 12 Age (in years)
      input:
        control: Editbox
        min: 0
        max: 120
  - id: b_s8_building
    title: 'Housing: the building'
    items:
    - id: Q1
      kind: Question
      title: 1 Which best describes this building? Include all apartments, flats, etc., even if vacant.
      input:
        control: Dropdown
        labels:
          1: A mobile home
          2: A one-family house detached from any other house
          3: A one-family house attached to one or more houses
          4: A building with 2 apartments
          5: A building with 3 or 4 apartments
          6: A building with 5 to 9 apartments
          7: A building with 10 to 19 apartments
          8: A building with 20 to 49 apartments
          9: A building with 50 or more apartments
          10: Boat, RV, van, etc.
    - id: Q2
      kind: Question
      title: 2 About when was this building first built?
      input:
        control: Dropdown
        labels:
          1: 2020 or later – Specify year
          2: 2010 to 2019
          3: 2000 to 2009
          4: 1990 to 1999
          5: 1980 to 1989
          6: 1970 to 1979
          7: 1960 to 1969
          8: 1950 to 1959
          9: 1940 to 1949
          10: 1939 or earlier
    - id: Q2_YEAR
      kind: Question
      title: 2020 or later – Specify year (write-in field of question 2; id added)
      precondition:
      - predicate: Q2.outcome == 1
        hint: Asked only when question 2 is "2020 or later – Specify year".
      input:
        control: Editbox
        min: 2020
        max: 2030
    - id: Q3
      kind: Question
      title: 3 When did PERSON 1 (listed on page 2) move into this house, apartment, or mobile home? Month
      input:
        control: Editbox
        min: 1
        max: 12
    - id: Q3_Year
      kind: Question
      title: 3 When did PERSON 1 (listed on page 2) move into this house, apartment, or mobile home? Year (second field of question 3; id added)
      input:
        control: Editbox
        min: 1900
        max: 2030
  - id: b_s8_land
    title: 'Housing: land and agriculture'
    precondition:
    - predicate: not (Q1.outcome not in [1, 2, 3])
      hint: Asked only when question 1 is one of "A mobile home", "A one-family house detached from any other house", "A one-family house attached to one or more houses".
    items:
    - id: Q4
      kind: Question
      title: A Answer questions 4 – 5 if this is a HOUSE OR A MOBILE HOME; otherwise, SKIP to question 6a. 4 How many acres is this house or mobile home on?
      input:
        control: Radio
        labels:
          1: Less than 1 acre SKIP to question 6a
          2: 1 to 9.9 acres
          3: 10 or more acres
    - id: Q5
      kind: Question
      title: 5 IN THE PAST 12 MONTHS, what were the actual sales of all agricultural products from this property?
      precondition:
      - predicate: not (Q4.outcome == 1)
        hint: Asked only when question 4 is not "Less than 1 acre SKIP to question 6a".
      input:
        control: Radio
        labels:
          1: None
          2: $1 to $999
          3: $1,000 to $2,499
          4: $2,500 to $4,999
          5: $5,000 to $9,999
          6: $10,000 or more
  - id: b_s8_facilities
    title: 'Housing: rooms, facilities and connectivity'
    items:
    - id: Q6a
      kind: Question
      title: 6 a. How many separate rooms are in this house, apartment, or mobile home? Rooms must be separated by built-in archways or walls that extend out at least 6 inches and go from floor to ceiling. INCLUDE bedrooms, kitchens, etc. EXCLUDE bathrooms, porches, balconies, foyers, halls, or unfinished basements. Number of rooms
      input:
        control: Editbox
        min: 0
        max: 99
    - id: Q6b
      kind: Question
      title: b. How many of these rooms are bedrooms? Count as bedrooms those rooms you would list if this house, apartment, or mobile home were for sale or rent. If this is an efficiency/studio apartment, print "0". Number of bedrooms
      postcondition:
      - predicate: Q6b.outcome <= Q6a.outcome
        hint: The number of bedrooms (6b) cannot be greater than the number of rooms (6a).
        invented: true
      input:
        control: Editbox
        min: 0
        max: 99
    - id: Q7a
      kind: Question
      title: 7 Does this house, apartment, or mobile home have – a. hot and cold running water?
      input:
        control: Switch
        'on': 'Yes'
        'off': 'No'
    - id: Q7b
      kind: Question
      title: b. a bathtub or shower?
      input:
        control: Switch
        'on': 'Yes'
        'off': 'No'
    - id: Q7c
      kind: Question
      title: c. a sink with a faucet?
      input:
        control: Switch
        'on': 'Yes'
        'off': 'No'
    - id: Q7d
      kind: Question
      title: d. a stove or range?
      input:
        control: Switch
        'on': 'Yes'
        'off': 'No'
    - id: Q7e
      kind: Question
      title: e. a refrigerator?
      input:
        control: Switch
        'on': 'Yes'
        'off': 'No'
    - id: Q8
      kind: Question
      title: 8 Is this house, apartment, or mobile home connected to a public sewer?
      input:
        control: Radio
        labels:
          1: Yes, connected to public sewer
          2: No, connected to septic tank
          3: No, use other type of system
    - id: Q9
      kind: Question
      title: 9 Can you or any member of this household both make and receive phone calls when at this house, apartment, or mobile home? Include calls using cell phones, land lines, or other phone devices.
      input:
        control: Switch
        'on': 'Yes'
        'off': 'No'
    - id: Q10a
      kind: Question
      title: 10 At this house, apartment, or mobile home – do you or any member of this household own or use any of the following types of computers? a. Desktop or laptop
      input:
        control: Switch
        'on': 'Yes'
        'off': 'No'
    - id: Q10b
      kind: Question
      title: b. Smartphone
      input:
        control: Switch
        'on': 'Yes'
        'off': 'No'
    - id: Q10c
      kind: Question
      title: c. Tablet or other portable wireless computer
      input:
        control: Switch
        'on': 'Yes'
        'off': 'No'
    - id: Q10d
      kind: Question
      title: d. Some other type of computer
      input:
        control: Switch
        'on': 'Yes'
        'off': 'No'
    - id: Q10d_SPEC
      kind: Question
      title: d. Some other type of computer Specify (write-in field; id added)
      precondition:
      - predicate: Q10d.outcome == 1
        hint: Asked only when question 10d is "Yes".
      input:
        control: Textarea
    - id: Q11
      kind: Question
      title: 11 At this house, apartment, or mobile home – do you or any member of this household have access to the Internet?
      input:
        control: Radio
        labels:
          1: Yes, by paying a cell phone company or Internet service provider
          2: Yes, without paying a cell phone company or Internet service provider SKIP to question 13
          3: No access to the Internet at this house, apartment, or mobile home SKIP to question 13
  - id: b_s8_internet_types
    title: 'Housing: Internet service types'
    precondition:
    - predicate: not (Q11.outcome in [2, 3])
      hint: Asked only when question 11 is none of "Yes, without paying a cell phone company or Internet service provider SKIP to question 13", "No access to the Internet at this house, apartment, or mobile home SKIP to question 13".
    items:
    - id: Q12a
      kind: Question
      title: 12 Do you or any member of this household have access to the Internet using a – a. cellular data plan for a smartphone or other mobile device?
      input:
        control: Switch
        'on': 'Yes'
        'off': 'No'
    - id: Q12b
      kind: Question
      title: b. broadband (high speed) Internet service such as cable, fiber optic, or DSL service installed in this household?
      input:
        control: Switch
        'on': 'Yes'
        'off': 'No'
    - id: Q12c
      kind: Question
      title: c. satellite Internet service installed in this household?
      input:
        control: Switch
        'on': 'Yes'
        'off': 'No'
    - id: Q12d
      kind: Question
      title: d. dial-up Internet service installed in this household?
      input:
        control: Switch
        'on': 'Yes'
        'off': 'No'
    - id: Q12e
      kind: Question
      title: e. some other service?
      input:
        control: Switch
        'on': 'Yes'
        'off': 'No'
    - id: Q12e_SPEC
      kind: Question
      title: e. some other service? Specify service (write-in field; id added)
      precondition:
      - predicate: Q12e.outcome == 1
        hint: Asked only when question 12e is "Yes".
      input:
        control: Textarea
  - id: b_s8_vehicles_energy
    title: 'Housing: vehicles, heating and utilities'
    items:
    - id: Q13
      kind: Question
      title: 13 How many automobiles, vans, and trucks of one-ton capacity or less are kept at home for use by members of this household?
      input:
        control: Radio
        labels:
          0: None SKIP to question 15
          1: '1'
          2: '2'
          3: '3'
          4: '4'
          5: '5'
          6: 6 or more
    - id: Q14
      kind: Question
      title: 14 Do you or any member of this household own or lease an electric vehicle? Include both all-electric and plug-in hybrid electric vehicles.
      precondition:
      - predicate: not (Q13.outcome == 0)
        hint: Asked only when question 13 is not "None SKIP to question 15".
      input:
        control: Switch
        'on': 'Yes'
        'off': 'No'
    - id: Q15
      kind: Question
      title: 15 Which FUEL is used MOST for heating this house, apartment, or mobile home? Mark (X) one box for the fuel used most.
      input:
        control: Radio
        labels:
          1: 'Gas: Natural gas from underground pipes serving the neighborhood'
          2: 'Gas: Bottled or tank (propane, butane, etc.)'
          3: Electricity
          4: Fuel oil, kerosene, etc.
          5: Coal or coke
          6: Wood
          7: Solar energy
          8: Other fuel
          9: No fuel used
    - id: Q16
      kind: Question
      title: 16 Does this house, apartment, or mobile home use solar panels that generate electricity?
      input:
        control: Switch
        'on': 'Yes'
        'off': 'No'
    - id: Q17a
      kind: Question
      title: 17 a. LAST MONTH, what was the cost of electricity for this house, apartment, or mobile home? Last month’s cost – Dollars
      input:
        control: Editbox
        min: 0
        max: 99999
    - id: Q17a_OR
      kind: Question
      title: 17a OR (alternative to dollar amount; id added)
      input:
        control: Radio
        labels:
          1: Included in rent or condominium fee
          2: No charge or electricity not used
    - id: Q17b
      kind: Question
      title: b. LAST MONTH, what was the cost of gas for this house, apartment, or mobile home? Last month’s cost – Dollars
      input:
        control: Editbox
        min: 0
        max: 99999
    - id: Q17b_OR
      kind: Question
      title: 17b OR (alternative to dollar amount; id added)
      input:
        control: Radio
        labels:
          1: Included in rent or condominium fee
          2: Included in electricity payment entered above
          3: No charge or gas not used
    - id: Q17c
      kind: Question
      title: c. IN THE PAST 12 MONTHS, what was the cost of water and sewer for this house, apartment, or mobile home? If you have lived here less than 12 months, estimate the cost. Past 12 months’ cost – Dollars
      input:
        control: Editbox
        min: 0
        max: 99999
    - id: Q17c_OR
      kind: Question
      title: 17c OR (alternative to dollar amount; id added)
      input:
        control: Radio
        labels:
          1: Included in rent or condominium fee
          2: No charge
    - id: Q17d
      kind: Question
      title: d. IN THE PAST 12 MONTHS, what was the cost of oil, coal, kerosene, wood, etc., for this house, apartment, or mobile home? If you have lived here less than 12 months, estimate the cost. Past 12 months’ cost – Dollars
      input:
        control: Editbox
        min: 0
        max: 99999
    - id: Q17d_OR
      kind: Question
      title: 17d OR (alternative to dollar amount; id added)
      input:
        control: Radio
        labels:
          1: Included in rent or condominium fee
          2: No charge or these fuels not used
    - id: Q18
      kind: Question
      title: 18 IN THE PAST 12 MONTHS, did you or any member of this household receive benefits from the Food Stamp Program or SNAP (the Supplemental Nutrition Assistance Program)? Do NOT include WIC, the School Lunch Program, or assistance from food banks.
      input:
        control: Switch
        'on': 'Yes'
        'off': 'No'
    - id: Q19
      kind: Question
      title: 19 Is this house, apartment, or mobile home part of a homeowners association or condominium?
      input:
        control: Switch
        'on': 'Yes'
        'off': 'No'
  - id: b_s8_association_fee
    title: 'Housing: association fee'
    precondition:
    - predicate: Q19.outcome == 1
      hint: Asked only when question 19 is "Yes".
    items:
    - id: Q19_FEE
      kind: Question
      title: Yes What is the required monthly homeowners association fee and/or condominium fee? For renters, answer only if you pay the fee in addition to your rent; otherwise, mark the "None" box. Monthly amount – Dollars (id added)
      input:
        control: Editbox
        min: 0
        max: 99999
    - id: Q19_NONE
      kind: Question
      title: OR None (id added)
      input:
        control: Radio
        labels:
          1: None
  - id: b_s8_tenure
    title: 'Housing: tenure'
    items:
    - id: Q20
      kind: Question
      title: 20 Is this house, apartment, or mobile home – Mark (X) ONE box.
      input:
        control: Radio
        labels:
          1: Owned by you or someone in this household with a mortgage or loan? Include home equity loans.
          2: Owned by you or someone in this household free and clear (without a mortgage or loan)?
          3: Rented?
          4: Occupied without payment of rent? SKIP to on the next page
  - id: b_s8_rent
    title: 'Housing: rent'
    precondition:
    - predicate: Q20.outcome == 3
      hint: Asked only when question 20 is "Rented?".
    items:
    - id: Q21a
      kind: Question
      title: B Answer questions 21a and b if this house, apartment, or mobile home is RENTED. Otherwise, SKIP to question 22. 21 a. What is the monthly rent for this house, apartment, or mobile home? Monthly amount – Dollars
      input:
        control: Editbox
        min: 0
        max: 99999
    - id: Q21b
      kind: Question
      title: b. Does the monthly rent include any meals?
      input:
        control: Switch
        'on': 'Yes'
        'off': 'No'
  - id: b_s9_preamble
    title: External inputs
    items:
    - id: OWNS_OR_BUYING
      kind: Question
      title: 'Housing tenure from the earlier Housing questions: does you or any member of this household OWN or IS BUYING this house, apartment, or mobile home? (gate for questions 22-26)'
      external: true
      input:
        control: Radio
        labels:
          1: Owns or is buying
          2: Otherwise (rents, occupied without rent)
  - id: b_s9_owner_inputs
    title: External inputs read when the household owns or is buying
    precondition:
    - predicate: not (OWNS_OR_BUYING.outcome == 2)
      hint: Asked only when question OWNS_OR_BUYING is not "Otherwise (rents, occupied without rent)".
    items:
    - id: MOBILE_HOME
      kind: Question
      title: 'Housing type from the earlier Housing questions: is this a MOBILE HOME? (gate for question 27)'
      external: true
      input:
        control: Radio
        labels:
          1: Mobile home
          2: Not a mobile home
    - id: PERSON1_LISTED
      kind: Question
      title: Whether anyone is listed as PERSON 1 on page 2 (household roster)
      external: true
      input:
        control: Radio
        labels:
          1: Listed
          2: Not listed
    - id: PERSON2_LISTED
      kind: Question
      title: Whether anyone is listed as Person 2 on page 3 (household roster)
      external: true
      input:
        control: Radio
        labels:
          1: Listed
          2: Not listed
    - id: P1_AGE
      kind: Question
      title: Age of Person 1, from the household roster (pages 2-3)
      external: true
      input:
        control: Editbox
        min: 0
        max: 120
    - id: P1_SEX
      kind: Question
      title: Sex of Person 1, from the household roster (pages 2-3)
      external: true
      input:
        control: Radio
        labels:
          1: Male
          2: Female
  - id: b_s10_owned
    title: Housing (continued)
    precondition:
    - predicate: OWNS_OR_BUYING.outcome == 1
      hint: Asked only when question OWNS_OR_BUYING is "Owns or is buying".
    - predicate: not (OWNS_OR_BUYING.outcome == 2)
      hint: Asked only when question OWNS_OR_BUYING is not "Otherwise (rents, occupied without rent)".
    items:
    - id: H22
      kind: Question
      title: 22 About how much do you think this house and lot, apartment, or mobile home (and lot, if owned) would sell for if it were for sale? Amount – Dollars
      input:
        control: Editbox
        min: 0
        max: 99999999
    - id: H23
      kind: Question
      title: 23 What are the annual real estate taxes on THIS property? Annual amount – Dollars OR None
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: H24
      kind: Question
      title: 24 What is the annual payment for fire, hazard, and flood insurance on THIS property? Annual amount – Dollars OR None
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: H25a
      kind: Question
      title: 25 a. Do you or any member of this household have a mortgage, deed of trust, contract to purchase, or similar debt on THIS property?
      input:
        control: Radio
        labels:
          1: Yes, mortgage, deed of trust, or similar debt
          2: Yes, contract to purchase
          3: No SKIP to question 26a
  - id: b_s10_mortgage
    title: Mortgage payment
    precondition:
    - predicate: H25a.outcome in [1, 2]
      hint: Asked only when question H25a is one of "Yes, mortgage, deed of trust, or similar debt", "Yes, contract to purchase".
    - predicate: not (OWNS_OR_BUYING.outcome == 2)
      hint: Asked only when question OWNS_OR_BUYING is not "Otherwise (rents, occupied without rent)".
    - predicate: not (H25a.outcome == 3)
      hint: Asked only when question H25a is not "No SKIP to question 26a".
    items:
    - id: H25b
      kind: Question
      title: b. How much is the regular monthly mortgage payment on THIS property? Include payment only on FIRST mortgage or contract to purchase. Monthly amount – Dollars OR No regular payment required SKIP to question 26a
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: H25c
      kind: Question
      title: c. Does the regular monthly mortgage payment include payments for real estate taxes on THIS property?
      precondition:
      - predicate: H25a.outcome in [1, 2] and H25b.outcome > 0
      - predicate: not (H25b.outcome == 0)
        hint: Asked only when question H25b is not 0.
      input:
        control: Radio
        labels:
          1: Yes, taxes included in mortgage payment
          2: No, taxes paid separately or taxes not required
    - id: H25d
      kind: Question
      title: d. Does the regular monthly mortgage payment include payments for fire, hazard, or flood insurance on THIS property?
      precondition:
      - predicate: H25a.outcome in [1, 2] and H25b.outcome > 0
      - predicate: not (H25b.outcome == 0)
        hint: Asked only when question H25b is not 0.
      input:
        control: Radio
        labels:
          1: Yes, insurance included in mortgage payment
          2: No, insurance paid separately or no insurance
  - id: b_s10_second
    title: Second mortgage or home equity loan
    precondition:
    - predicate: OWNS_OR_BUYING.outcome == 1
      hint: Asked only when question OWNS_OR_BUYING is "Owns or is buying".
    - predicate: not (OWNS_OR_BUYING.outcome == 2)
      hint: Asked only when question OWNS_OR_BUYING is not "Otherwise (rents, occupied without rent)".
    items:
    - id: H26a
      kind: Question
      title: 26 a. Do you or any member of this household have a second mortgage or a home equity loan on THIS property?
      input:
        control: Radio
        labels:
          1: Yes, home equity loan
          2: Yes, second mortgage
          3: Yes, second mortgage and home equity loan
          4: No SKIP to
  - id: b_s10_second_payment
    title: Second mortgage payment
    precondition:
    - predicate: H26a.outcome in [1, 2, 3]
      hint: Asked only when question H26a is one of "Yes, home equity loan", "Yes, second mortgage", "Yes, second mortgage and home equity loan".
    - predicate: not (OWNS_OR_BUYING.outcome == 2)
      hint: Asked only when question OWNS_OR_BUYING is not "Otherwise (rents, occupied without rent)".
    - predicate: not (H26a.outcome == 4)
      hint: Asked only when question H26a is not "No SKIP to".
    items:
    - id: H26b
      kind: Question
      title: b. How much is the regular monthly payment on all second or junior mortgages and all home equity loans on THIS property? Monthly amount – Dollars OR No regular payment required
      input:
        control: Editbox
        min: 0
        max: 999999
  - id: b_s10_mobile
    title: Mobile home costs
    items:
    - id: H27
      kind: Question
      title: D Answer question 27 if this is a MOBILE HOME. 27 What are the total annual costs for personal property taxes, site rent, registration fees, and license fees on THIS mobile home and its site? Exclude real estate taxes. Annual costs – Dollars
      precondition:
      - predicate: MOBILE_HOME.outcome == 1
        hint: Asked only when question MOBILE_HOME is "Mobile home".
      - predicate: not (MOBILE_HOME.outcome == 2 and PERSON1_LISTED.outcome == 1)
      - predicate: not (MOBILE_HOME.outcome == 2 and PERSON1_LISTED.outcome == 2)
      input:
        control: Editbox
        min: 0
        max: 9999999
  - id: b_s11_name
    title: Person 1
    precondition:
    - predicate: not (MOBILE_HOME.outcome == 2 and PERSON1_LISTED.outcome == 2)
    - predicate: not (PERSON1_LISTED.outcome == 2)
      hint: Asked only when question PERSON1_LISTED is not "Not listed".
    items:
    - id: Name
      kind: Question
      title: Please copy the name of Person 1 from page 2, then continue answering questions below. Last Name / First Name / MI
      precondition:
      - predicate: PERSON1_LISTED.outcome == 1
        hint: Asked only when question PERSON1_LISTED is "Listed".
      - predicate: not (MOBILE_HOME.outcome == 2 and PERSON1_LISTED.outcome == 1)
      input:
        control: Textarea
  - id: b_s11_birth_edu
    title: Birthplace, citizenship and education
    precondition:
    - predicate: not (MOBILE_HOME.outcome == 2 and PERSON1_LISTED.outcome == 2)
    - predicate: not (PERSON1_LISTED.outcome == 2)
      hint: Asked only when question PERSON1_LISTED is not "Not listed".
    items:
    - id: Q7
      kind: Question
      title: 7 Where was this person born?
      input:
        control: Radio
        labels:
          1: In the United States – Print name of state.
          2: Outside the United States – Print name of foreign country, or Puerto Rico, Guam, etc.
    - id: Q8_2
      kind: Question
      title: 8 Is this person a citizen of the United States?
      input:
        control: Radio
        labels:
          1: Yes, born in the United States SKIP to question 10a
          2: Yes, born in Puerto Rico, Guam, the U.S. Virgin Islands, or Northern Marianas
          3: Yes, born abroad of U.S. citizen parent or parents
          4: Yes, U.S. citizen by naturalization – Print year of naturalization
          5: No, not a U.S. citizen
    - id: Q9_2
      kind: Question
      title: 9 When did this person come to live in the United States? If this person came to live in the United States more than once, print latest year. Year
      precondition:
      - predicate: Q8_2.outcome != 1
        hint: Asked only when question 8 is not "Yes, born in the United States SKIP to question 10a".
      - predicate: not (Q8_2.outcome == 1)
        hint: Asked only when question 8 is not "Yes, born in the United States SKIP to question 10a".
      input:
        control: Editbox
        min: 1900
        max: 2026
    - id: Q10a_2
      kind: Question
      title: 10 a. At any time IN THE LAST 3 MONTHS, has this person attended school or college? Include only nursery or preschool, kindergarten, elementary school, home school, and schooling which leads to a high school diploma or a college degree.
      input:
        control: Radio
        labels:
          1: No, has not attended in the last 3 months SKIP to question 11
          2: Yes, public school, public college
          3: Yes, private school, private college, home school
    - id: Q10b_2
      kind: Question
      title: b. What grade or level was this person attending? Mark (X) ONE box.
      precondition:
      - predicate: Q10a_2.outcome in [2, 3]
        hint: Asked only when question 10a is one of "Yes, public school, public college", "Yes, private school, private college, home school".
      - predicate: not (Q10a_2.outcome == 1)
        hint: Asked only when question 10a is not "No, has not attended in the last 3 months SKIP to question 11".
      input:
        control: Radio
        labels:
          1: Nursery school, preschool
          2: Kindergarten
          3: Grade 1 through 12 – Specify grade 1 – 12
          4: College undergraduate years (freshman to senior)
          5: 'Graduate or professional school beyond a bachelor’s degree (for example: MA or PhD program, or medical or law school)'
    - id: Q11_2
      kind: Question
      title: 11 What is the highest grade of school or degree this person has COMPLETED? Mark (X) ONE box. If currently enrolled, select the previous grade or highest degree received.
      input:
        control: Dropdown
        labels:
          1: Less than grade 1
          2: Grade 1 through 11 – Specify grade 1 – 11
          3: 12th grade – NO DIPLOMA
          4: Regular high school diploma
          5: GED or alternative credential
          6: Some college credit, but less than 1 year of college credit
          7: 1 or more years of college credit, no degree
          8: 'Associate’s degree (for example: AA, AS)'
          9: 'Bachelor’s degree (for example: BA, BS)'
          10: 'Master’s degree (for example: MA, MS, MEng, MEd, MSW, MBA)'
          11: 'Professional degree beyond a bachelor’s degree (for example: MD, DDS, DVM, LLB, JD)'
          12: 'Doctorate degree (for example: PhD, EdD)'
    - id: Q12
      kind: Question
      title: 'F Answer question 12 if this person has a bachelor’s degree or higher. Otherwise, SKIP to question 13. 12 This question focuses on this person’s BACHELOR’S DEGREE. Please print below the specific major(s) of any BACHELOR’S DEGREES this person has received. (For example: chemical engineering, elementary teacher education, organizational psychology)'
      precondition:
      - predicate: Q11_2.outcome in [9, 10, 11, 12]
        hint: Asked only when question 11 is a bachelor’s degree or higher.
      - predicate: not (Q11_2.outcome not in [9, 10, 11, 12])
        hint: Asked only when question 11 is a bachelor’s degree or higher.
      input:
        control: Textarea
    - id: Q13_2
      kind: Question
      title: '13 What is this person’s ancestry or ethnic origin? (For example: Italian, Jamaican, African Am., Cambodian, Cape Verdean, Norwegian, Dominican, French Canadian, Haitian, Korean, Lebanese, Polish, Nigerian, Mexican, Taiwanese, Ukrainian, and so on.)'
      input:
        control: Textarea
  - id: b_s11_language_move
    title: Language and residence
    precondition:
    - predicate: not (MOBILE_HOME.outcome == 2 and PERSON1_LISTED.outcome == 2)
    - predicate: not (PERSON1_LISTED.outcome == 2)
      hint: Asked only when question PERSON1_LISTED is not "Not listed".
    items:
    - id: Q14a
      kind: Question
      title: 14 a. Does this person speak a language other than English at home?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: No SKIP to question 15a
    - id: Q14b
      kind: Question
      title: 'b. What is this language? For example: Korean, Italian, Spanish, Vietnamese'
      precondition:
      - predicate: Q14a.outcome == 1
        hint: Asked only when question 14a is "Yes".
      - predicate: not (Q14a.outcome == 2)
        hint: Asked only when question 14a is not "No SKIP to question 15a".
      input:
        control: Textarea
    - id: Q14c
      kind: Question
      title: c. How well does this person speak English?
      precondition:
      - predicate: Q14a.outcome == 1
        hint: Asked only when question 14a is "Yes".
      - predicate: not (Q14a.outcome == 2)
        hint: Asked only when question 14a is not "No SKIP to question 15a".
      input:
        control: Radio
        labels:
          1: Very well
          2: Well
          3: Not well
          4: Not at all
    - id: Q15a
      kind: Question
      title: 15 a. Did this person live in this house or apartment 1 year ago?
      input:
        control: Radio
        labels:
          1: Person is under 1 year old SKIP to question 16
          2: Yes, this house SKIP to question 16
          3: No, outside the United States and Puerto Rico – Print name of foreign country, or U.S. Virgin Islands, Guam, etc., below; then SKIP to question 16
          4: No, different house in the United States or Puerto Rico
    - id: Q15b
      kind: Question
      title: b. Where did this person live 1 year ago? Address (Number and street name); Name of city, town, or post office; Name of U.S. county or municipio in Puerto Rico; Name of U.S. state or Puerto Rico; ZIP Code
      precondition:
      - predicate: Q15a.outcome == 4
        hint: Asked only when question 15a is "No, different house in the United States or Puerto Rico".
      - predicate: not (Q15a.outcome in [1, 2, 3])
        hint: Asked only when question 15a is "No, different house in the United States or Puerto Rico".
      input:
        control: Textarea
  - id: b_s11_health
    title: Health insurance and sensory difficulties
    precondition:
    - predicate: not (MOBILE_HOME.outcome == 2 and PERSON1_LISTED.outcome == 2)
    - predicate: not (PERSON1_LISTED.outcome == 2)
      hint: Asked only when question PERSON1_LISTED is not "Not listed".
    items:
    - id: Q16_2
      kind: Question
      title: 16 Is this person CURRENTLY covered by any of the following types of health insurance or health coverage plans? Do NOT include plans that cover only one type of service, such as dental, drug, or vision plans. Mark (X) for all that apply.
      postcondition:
      - predicate: not (Q16_2.outcome & 256 > 0 and Q16_2.outcome & 255 > 0)
        hint: 'Question 16: ''No health insurance'' cannot be marked together with any type of coverage; unmark one.'
        invented: true
      input:
        control: Checkbox
        labels:
          1: YES, INSURED – Insurance through a current or former employer, union, or professional association (of this person or another family member)
          2: Medicare, for people 65 and older, or people with certain disabilities
          4: Medicaid, Children’s Health Insurance Program (CHIP), or any kind of government-assistance plan for those with low incomes or a disability
          8: Insurance purchased directly from an insurance company, a broker, or a State or Federal Marketplace, such as HealthCare.gov
          16: Veteran’s health care (enrolled for VA)
          32: TRICARE or other military health care
          64: Indian Health Service
          128: Any other type of health insurance or health coverage plan – Specify
          256: NO, UNINSURED – No health insurance or health coverage plan
    - id: Q17a_2
      kind: Question
      title: G Answer question 17a if this person is covered by health insurance. Otherwise, SKIP to question 18a. 17 a. Is there a premium for this plan? A premium is a fixed amount of money paid on a regular basis for health coverage. It does not include copays, deductibles, or other expenses such as prescription costs.
      precondition:
      - predicate: Q16_2.outcome % 256 > 0
      - predicate: not (Q16_2.outcome % 256 == 0)
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: No SKIP to question 18a
    - id: Q17b_2
      kind: Question
      title: b. Does this person or another family member receive a tax credit or subsidy based on family income to help pay the premium?
      precondition:
      - predicate: Q17a_2.outcome == 1
        hint: Asked only when question 17a is "Yes".
      - predicate: not (Q16_2.outcome % 256 == 0)
      - predicate: not (Q17a_2.outcome == 2)
        hint: Asked only when question 17a is not "No SKIP to question 18a".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: Q18a
      kind: Question
      title: 18 a. Is this person deaf or does he/she have serious difficulty hearing?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: Q18b
      kind: Question
      title: b. Is this person blind or does he/she have serious difficulty seeing even when wearing glasses?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
  - id: b_s11_difficulty
    title: Difficulties (age 5 and over)
    precondition:
    - predicate: not (MOBILE_HOME.outcome == 2 and PERSON1_LISTED.outcome == 2)
    - predicate: not (PERSON1_LISTED.outcome == 2)
      hint: Asked only when question PERSON1_LISTED is not "Not listed".
    - predicate: P1_AGE.outcome >= 5
    items:
    - id: Q19a
      kind: Question
      title: 19 a. Because of a physical, mental, or emotional condition, does this person have serious difficulty concentrating, remembering, or making decisions?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: Q19b
      kind: Question
      title: b. Does this person have serious difficulty walking or climbing stairs?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: Q19c
      kind: Question
      title: c. Does this person have difficulty dressing or bathing?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
  - id: b_s11_adult
    title: Errands and marital status (age 15 and over)
    precondition:
    - predicate: not (MOBILE_HOME.outcome == 2 and PERSON1_LISTED.outcome == 2)
    - predicate: not (PERSON1_LISTED.outcome == 2)
      hint: Asked only when question PERSON1_LISTED is not "Not listed".
    - predicate: P1_AGE.outcome >= 15
    items:
    - id: Q20_2
      kind: Question
      title: I Answer question 20 if this person is 15 years old or over. 20 Because of a physical, mental, or emotional condition, does this person have difficulty doing errands alone such as visiting a doctor’s office or shopping?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: Q21
      kind: Question
      title: 21 What is this person’s marital status?
      input:
        control: Radio
        labels:
          1: Now married
          2: Widowed
          3: Divorced
          4: Separated
          5: Never married SKIP to [J] on the next page
  - id: b_s11_marriage
    title: Marriage history
    precondition:
    - predicate: not (MOBILE_HOME.outcome == 2 and PERSON1_LISTED.outcome == 2)
    - predicate: not (PERSON1_LISTED.outcome == 2)
      hint: Asked only when question PERSON1_LISTED is not "Not listed".
    - predicate: Q21.outcome in [1, 2, 3, 4]
      hint: Asked only when question 21 is not "Never married".
    - predicate: not (Q21.outcome == 5)
      hint: Asked only when question 21 is not "Never married SKIP to [J] on the next page".
    items:
    - id: Q22a
      kind: Question
      title: 22 In the PAST 12 MONTHS did this person get – a. Married?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: Q22b
      kind: Question
      title: b. Widowed?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: Q22c
      kind: Question
      title: c. Divorced?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: Q23
      kind: Question
      title: 23 How many times has this person been married?
      input:
        control: Radio
        labels:
          1: Once
          2: Two times
          3: Three or more times
    - id: Q24
      kind: Question
      title: 24 In what year did this person last get married? Year
      input:
        control: Editbox
        min: 1900
        max: 2026
  - id: b_s11_family
    title: Births and grandchildren
    precondition:
    - predicate: not (MOBILE_HOME.outcome == 2 and PERSON1_LISTED.outcome == 2)
    - predicate: not (PERSON1_LISTED.outcome == 2)
      hint: Asked only when question PERSON1_LISTED is not "Not listed".
    items:
    - id: Q25
      kind: Question
      title: J Answer question 25 if this person is female and 15 – 50 years old. Otherwise, SKIP to question 26a. 25 In the PAST 12 MONTHS, has this person given birth to any children?
      precondition:
      - predicate: P1_SEX.outcome == 2 and P1_AGE.outcome >= 15 and P1_AGE.outcome <= 50
      - predicate: not (not (P1_SEX.outcome == 2 and P1_AGE.outcome >= 15 and P1_AGE.outcome <= 50))
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: Q26a
      kind: Question
      title: 26 a. Does this person have any of his/her own grandchildren under the age of 18 living in this house or apartment?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: No SKIP to question 27
    - id: Q26b
      kind: Question
      title: b. Is this grandparent currently responsible for most of the basic needs of any grandchildren under the age of 18 who live in this house or apartment?
      precondition:
      - predicate: Q26a.outcome == 1
        hint: Asked only when question 26a is "Yes".
      - predicate: not (Q26a.outcome == 2)
        hint: Asked only when question 26a is not "No SKIP to question 27".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: No SKIP to question 27
    - id: Q26c
      kind: Question
      title: c. How long has this grandparent been responsible for these grandchildren? If the grandparent is financially responsible for more than one grandchild, answer the question for the grandchild for whom the grandparent has been responsible for the longest period of time.
      precondition:
      - predicate: Q26a.outcome == 1 and Q26b.outcome == 1
      - predicate: not (Q26a.outcome == 2)
        hint: Asked only when question 26a is not "No SKIP to question 27".
      - predicate: not (Q26b.outcome == 2)
        hint: Asked only when question 26b is not "No SKIP to question 27".
      input:
        control: Radio
        labels:
          1: Less than 6 months
          2: 6 to 11 months
          3: 1 or 2 years
          4: 3 or 4 years
          5: 5 or more years
  - id: b_s11_military
    title: Military service
    precondition:
    - predicate: not (MOBILE_HOME.outcome == 2 and PERSON1_LISTED.outcome == 2)
    - predicate: not (PERSON1_LISTED.outcome == 2)
      hint: Asked only when question PERSON1_LISTED is not "Not listed".
    items:
    - id: Q27
      kind: Question
      title: 27 Has this person ever served on active duty in the U.S. Armed Forces, Reserves, or National Guard? Mark (X) ONE box.
      input:
        control: Radio
        labels:
          1: Never served in the military SKIP to question 30a
          2: Only on active duty for training in the Reserves or National Guard SKIP to question 29a
          3: Now on active duty
          4: On active duty in the past, but not now
    - id: Q28
      kind: Question
      title: 28 When did this person serve on active duty in the U.S. Armed Forces? Mark (X) a box for EACH period in which this person served, even if just for part of the period.
      precondition:
      - predicate: Q27.outcome in [3, 4]
        hint: Asked only when question 27 is "Now on active duty" or "On active duty in the past, but not now".
      - predicate: not (Q27.outcome == 1)
        hint: Asked only when question 27 is not "Never served in the military SKIP to question 30a".
      - predicate: not (Q27.outcome == 2)
        hint: Asked only when question 27 is not "Only on active duty for training in the Reserves or National Guard SKIP to question 29a".
      input:
        control: Checkbox
        labels:
          1: September 2001 or later (Post 9/11)
          2: August 1990 through August 2001 (including the Persian Gulf War)
          4: June 1975 through July 1990
          8: August 1964 through May 1975 (including the Vietnam War)
          16: February 1955 through July 1964
          32: June 1950 through January 1955 (including the Korean War)
          64: January 1947 through May 1950
          128: December 1941 through December 1946 (including World War II)
          256: November 1941 or earlier
    - id: Q29a
      kind: Question
      title: 29 a. Does this person have a VA service-connected disability rating?
      precondition:
      - predicate: Q27.outcome in [2, 3, 4]
        hint: Asked only when question 27 is not "Never served in the military".
      - predicate: not (Q27.outcome == 1)
        hint: Asked only when question 27 is not "Never served in the military SKIP to question 30a".
      input:
        control: Radio
        labels:
          1: Yes (such as 0%, 10%, 20%, ... , 100%)
          2: No SKIP to question 30a
    - id: Q29b
      kind: Question
      title: b. What is this person’s service-connected disability rating?
      precondition:
      - predicate: Q29a.outcome == 1
        hint: Asked only when question 29a is "Yes (such as 0%, 10%, 20%, ... , 100%)".
      - predicate: not (Q27.outcome == 1)
        hint: Asked only when question 27 is not "Never served in the military SKIP to question 30a".
      - predicate: not (Q29a.outcome == 2)
        hint: Asked only when question 29a is not "No SKIP to question 30a".
      input:
        control: Radio
        labels:
          1: 0 percent
          2: 10 or 20 percent
          3: 30 or 40 percent
          4: 50 or 60 percent
          5: 70 percent or higher
  - id: b_s11_work_last_week
    title: Work last week
    precondition:
    - predicate: not (MOBILE_HOME.outcome == 2 and PERSON1_LISTED.outcome == 2)
    - predicate: not (PERSON1_LISTED.outcome == 2)
      hint: Asked only when question PERSON1_LISTED is not "Not listed".
    items:
    - id: Q30a
      kind: Question
      title: 30 a. LAST WEEK, did this person work for pay at a job (or business)?
      input:
        control: Radio
        labels:
          1: Yes ➔ SKIP to question 31
          2: No – Did not work (or retired)
    - id: Q30b
      kind: Question
      title: b. LAST WEEK, did this person do ANY work for pay, even for as little as one hour?
      precondition:
      - predicate: Q30a.outcome == 2
        hint: Asked only when question 30a is "No – Did not work (or retired)".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: No ➔ SKIP to question 36a
  - id: b_s11_workplace
    title: Work location and transportation
    precondition:
    - predicate: not (MOBILE_HOME.outcome == 2 and PERSON1_LISTED.outcome == 2)
    - predicate: not (PERSON1_LISTED.outcome == 2)
      hint: Asked only when question PERSON1_LISTED is not "Not listed".
    - predicate: Q30a.outcome == 1 or Q30b.outcome == 1
    - predicate: not (Q30b.outcome == 2)
      hint: Asked only when question 30b is not "No ➔ SKIP to question 36a".
    items:
    - id: Q31a
      kind: Question
      title: 31 At what location did this person work LAST WEEK? If this person worked at more than one location, print where he or she worked most last week. a. Address (Number and street name). If the exact address is not known, give a description of the location such as the building name or the nearest street or intersection.
      input:
        control: Textarea
    - id: Q31b
      kind: Question
      title: b. Name of city, town, or post office
      input:
        control: Textarea
    - id: Q31c
      kind: Question
      title: c. Is the work location inside the limits of that city or town?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: No, outside the city/town limits
    - id: Q31d
      kind: Question
      title: d. Name of county
      input:
        control: Textarea
    - id: Q31e
      kind: Question
      title: e. Name of U.S. state or foreign country
      input:
        control: Textarea
    - id: Q31f
      kind: Question
      title: f. ZIP Code
      input:
        control: Textarea
    - id: Q32
      kind: Question
      title: 32 How did this person usually get to work LAST WEEK? Mark (X) ONE box for the method of transportation used for most of the distance.
      input:
        control: Dropdown
        labels:
          1: Car, truck, or van
          2: Bus
          3: Subway or elevated rail
          4: Long-distance train or commuter rail
          5: Light rail, streetcar, or trolley
          6: Ferryboat
          7: Taxi or ride-hailing services
          8: Motorcycle
          9: Bicycle
          10: Walked
          11: Worked from home ➔ SKIP to question 40a
          12: Other method
  - id: b_s11_commute_car
    title: Carpool
    precondition:
    - predicate: not (MOBILE_HOME.outcome == 2 and PERSON1_LISTED.outcome == 2)
    - predicate: not (PERSON1_LISTED.outcome == 2)
      hint: Asked only when question PERSON1_LISTED is not "Not listed".
    items:
    - id: Q33
      kind: Question
      title: K Answer question 33 if you marked "Car, truck, or van" in question 32. Otherwise, SKIP to question 34. 33 How many people, including this person, usually rode to work in the car, truck, or van LAST WEEK? Person(s)
      precondition:
      - predicate: Q32.outcome == 1
        hint: Asked only when question 32 is "Car, truck, or van".
      - predicate: not (Q30b.outcome == 2)
        hint: Asked only when question 30b is not "No ➔ SKIP to question 36a".
      - predicate: not (Q32.outcome == 11)
        hint: Asked only when question 32 is not "Worked from home ➔ SKIP to question 40a".
      - predicate: not (Q32.outcome in [2, 3, 4, 5, 6, 7, 8, 9, 10, 12])
        hint: Asked only when question 32 is "Car, truck, or van".
      input:
        control: Editbox
        min: 1
        max: 20
  - id: b_s11_commute_trip
    title: Trip to work
    precondition:
    - predicate: not (MOBILE_HOME.outcome == 2 and PERSON1_LISTED.outcome == 2)
    - predicate: not (PERSON1_LISTED.outcome == 2)
      hint: Asked only when question PERSON1_LISTED is not "Not listed".
    - predicate: Q32.outcome != 11 and (Q30a.outcome == 1 or Q30b.outcome == 1)
    - predicate: not (Q30b.outcome == 2)
      hint: Asked only when question 30b is not "No ➔ SKIP to question 36a".
    - predicate: not (Q32.outcome == 11)
      hint: Asked only when question 32 is not "Worked from home ➔ SKIP to question 40a".
    items:
    - id: Q34
      kind: Question
      title: '34 LAST WEEK, what time did this person''s trip to work usually begin? Hour : Minute, a.m. / p.m.'
      input:
        control: Textarea
    - id: Q35
      kind: Question
      title: 35 How many minutes did it usually take this person to get from home to work LAST WEEK? Minutes
      input:
        control: Editbox
        min: 0
        max: 600
  - id: b_s11_nonwork
    title: Persons who did not work last week
    precondition:
    - predicate: not (MOBILE_HOME.outcome == 2 and PERSON1_LISTED.outcome == 2)
    - predicate: not (PERSON1_LISTED.outcome == 2)
      hint: Asked only when question PERSON1_LISTED is not "Not listed".
    items:
    - id: Q36a
      kind: Question
      title: L Answer questions 36 – 39 if this person did NOT work last week. Otherwise, SKIP to question 40a. 36 a. LAST WEEK, was this person on layoff from a job?
      precondition:
      - predicate: Q30a.outcome == 2 and Q30b.outcome == 2
      - predicate: not (Q32.outcome == 11)
        hint: Asked only when question 32 is not "Worked from home ➔ SKIP to question 40a".
      - predicate: Q35.outcome is None
      input:
        control: Radio
        labels:
          1: Yes ➔ SKIP to question 36c
          2: 'No'
    - id: Q36b
      kind: Question
      title: b. LAST WEEK, was this person TEMPORARILY absent from a job or business?
      precondition:
      - predicate: Q36a.outcome == 2
        hint: Asked only when question 36a is "No".
      - predicate: not (Q32.outcome == 11)
        hint: Asked only when question 32 is not "Worked from home ➔ SKIP to question 40a".
      - predicate: Q35.outcome is None
      - predicate: not (Q36a.outcome == 1)
        hint: Asked only when question 36a is not "Yes ➔ SKIP to question 36c".
      input:
        control: Radio
        labels:
          1: Yes, on vacation, temporary illness, maternity leave, other family/personal reasons, bad weather, etc. ➔ SKIP to question 39
          2: No ➔ SKIP to question 37
    - id: Q36c
      kind: Question
      title: c. Has this person been informed that he or she will be recalled to work within the next 6 months OR been given a date to return to work?
      precondition:
      - predicate: Q36a.outcome == 1
        hint: Asked only when question 36a is "Yes ➔ SKIP to question 36c".
      - predicate: not (Q32.outcome == 11)
        hint: Asked only when question 32 is not "Worked from home ➔ SKIP to question 40a".
      - predicate: Q35.outcome is None
      - predicate: not (Q36b.outcome == 1)
        hint: Asked only when question 36b is not "Yes, ... ➔ SKIP to question 39".
      - predicate: not (Q36b.outcome == 2)
        hint: Asked only when question 36b is not "No ➔ SKIP to question 37".
      input:
        control: Radio
        labels:
          1: Yes ➔ SKIP to question 38
          2: 'No'
    - id: Q37
      kind: Question
      title: 37 During the LAST 4 WEEKS, has this person been ACTIVELY looking for work?
      precondition:
      - predicate: Q36b.outcome == 2 or Q36c.outcome == 2
      - predicate: not (Q32.outcome == 11)
        hint: Asked only when question 32 is not "Worked from home ➔ SKIP to question 40a".
      - predicate: Q35.outcome is None
      - predicate: not (Q36b.outcome == 1)
        hint: Asked only when question 36b is not "Yes, ... ➔ SKIP to question 39".
      - predicate: not (Q36c.outcome == 1)
        hint: Asked only when question 36c is not "Yes ➔ SKIP to question 38".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: No SKIP to question 39
    - id: Q38
      kind: Question
      title: 38 LAST WEEK, could this person have started a job if offered one, or returned to work if recalled?
      precondition:
      - predicate: Q36c.outcome == 1 or Q37.outcome == 1
      - predicate: not (Q32.outcome == 11)
        hint: Asked only when question 32 is not "Worked from home ➔ SKIP to question 40a".
      - predicate: Q35.outcome is None
      - predicate: not (Q36b.outcome == 1)
        hint: Asked only when question 36b is not "Yes, ... ➔ SKIP to question 39".
      - predicate: not (Q37.outcome == 2)
        hint: Asked only when question 37 is not "No SKIP to question 39".
      input:
        control: Radio
        labels:
          1: Yes, could have gone to work
          2: No, because of own temporary illness
          3: No, because of all other reasons (in school, etc.)
    - id: Q39
      kind: Question
      title: 39 When did this person last work for pay, even for a few days?
      precondition:
      - predicate: Q30a.outcome == 2 and Q30b.outcome == 2
      - predicate: not (Q32.outcome == 11)
        hint: Asked only when question 32 is not "Worked from home ➔ SKIP to question 40a".
      - predicate: Q35.outcome is None
      input:
        control: Radio
        labels:
          1: Within the past 12 months
          2: 1 to 5 years ago SKIP to [destination blank in source]
          3: Over 5 years ago or never worked SKIP to question 43
  - id: b_s11_pastyear
    title: Work in the past 12 months
    precondition:
    - predicate: not (MOBILE_HOME.outcome == 2 and PERSON1_LISTED.outcome == 2)
    - predicate: not (PERSON1_LISTED.outcome == 2)
      hint: Asked only when question PERSON1_LISTED is not "Not listed".
    - predicate: not (Q39.outcome == 2)
      hint: Asked only when question 39 is not "1 to 5 years ago SKIP to [destination blank in source]".
    - predicate: not (Q39.outcome == 3)
      hint: Asked only when question 39 is not "Over 5 years ago or never worked SKIP to question 43".
    items:
    - id: Q40a
      kind: Question
      title: 40 a. During the PAST 12 MONTHS (52 weeks), did this person work EVERY week? Count paid vacation, paid sick leave, and military service as work. Include all jobs for pay.
      input:
        control: Radio
        labels:
          1: Yes SKIP to question 41
          2: 'No'
    - id: Q40b
      kind: Question
      title: b. During the PAST 12 MONTHS (52 weeks), how many WEEKS did this person work for at least one day? Include weeks when this person only worked for a few hours. Include all jobs for pay. Count paid vacation, paid sick leave, and military service as work. Weeks
      precondition:
      - predicate: Q40a.outcome == 2
        hint: Asked only when question 40a is "No".
      - predicate: not (Q40a.outcome == 1)
        hint: Asked only when question 40a is not "Yes SKIP to question 41".
      input:
        control: Editbox
        min: 0
        max: 52
    - id: Q41
      kind: Question
      title: 41 During the PAST 12 MONTHS, for the weeks worked, how many HOURS did this person usually work each WEEK? Include all jobs for pay and military service. Usual hours worked each WEEK
      input:
        control: Editbox
        min: 0
        max: 168
  - id: b_s11_job
    title: Description of employment
    precondition:
    - predicate: not (MOBILE_HOME.outcome == 2 and PERSON1_LISTED.outcome == 2)
    - predicate: not (PERSON1_LISTED.outcome == 2)
      hint: Asked only when question PERSON1_LISTED is not "Not listed".
    - predicate: Q30a.outcome == 1 or Q30b.outcome == 1 or Q39.outcome in [1, 2]
    - predicate: not (Q39.outcome == 3)
      hint: Asked only when question 39 is not "Over 5 years ago or never worked SKIP to question 43".
    - predicate: not (Q30a.outcome == 2 and Q30b.outcome == 2 and Q39.outcome == 3)
    items:
    - id: Q42a
      kind: Question
      title: M Answer questions 42a – f if this person worked in the past 5 years. Otherwise, SKIP to question 43. 42 DESCRIPTION OF EMPLOYMENT ... a. Which one of the following best describes this person’s employment last week or the most recent employment in the past 5 years? Mark (X) ONE box.
      input:
        control: Dropdown
        labels:
          1: PRIVATE SECTOR EMPLOYEE – For-profit company or organization
          2: Non-profit organization (including tax-exempt and charitable organizations)
          3: 'GOVERNMENT EMPLOYEE – Local government (for example: city or county school district)'
          4: State government (including state colleges/universities)
          5: Active duty U.S. Armed Forces or Commissioned Corps
          6: Federal government civilian employee
          7: SELF-EMPLOYED OR OTHER – Owner of non-incorporated business, professional practice, or farm
          8: Owner of incorporated business, professional practice, or farm
          9: Worked without pay in a for-profit family business or farm for 15 hours or more per week
    - id: Q42b
      kind: Question
      title: b. What was the name of this person’s employer, business, agency, or branch of the Armed Forces?
      input:
        control: Textarea
    - id: Q42c
      kind: Question
      title: 'c. What kind of business or industry was this? Include the main activity, product, or service provided at the location where employed. (For example: elementary school, residential construction)'
      input:
        control: Textarea
    - id: Q42d
      kind: Question
      title: d. Was this mainly – Mark (X) ONE box.
      input:
        control: Radio
        labels:
          1: manufacturing?
          2: wholesale trade?
          3: retail trade?
          4: other (agriculture, construction, service, government, etc.)?
    - id: Q42e
      kind: Question
      title: 'e. What was this person’s main occupation? (For example: 4th grade teacher, entry-level plumber)'
      input:
        control: Textarea
    - id: Q42f
      kind: Question
      title: 'f. Describe this person’s most important activities or duties. (For example: instruct and evaluate students and create lesson plans, assemble and install pipe sections and review building plans for work details)'
      input:
        control: Textarea
  - id: b_s11_income
    title: Income in the past 12 months
    precondition:
    - predicate: not (MOBILE_HOME.outcome == 2 and PERSON1_LISTED.outcome == 2)
    - predicate: not (PERSON1_LISTED.outcome == 2)
      hint: Asked only when question PERSON1_LISTED is not "Not listed".
    items:
    - id: Q43a
      kind: Question
      title: 43 INCOME IN THE PAST 12 MONTHS. Mark (X) the "Yes" box for each type of income this person received, and give your best estimate of the TOTAL AMOUNT during the PAST 12 MONTHS. Mark (X) the "No" box to show types of income NOT received. a. Wages, salary, commissions, bonuses, or tips from all jobs. Report amount before deductions for taxes, bonds, dues, or other items. (Yes/No box recorded as amount; No = 0)
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
    - id: Q43b
      kind: Question
      title: 'b. Self-employment income from own nonfarm businesses or farm businesses, including proprietorships and partnerships. Report NET income after business expenses. (Yes/No box; "Loss" box: a loss is entered as a negative amount; No = 0)'
      input:
        control: Editbox
        min: -9999999
        max: 9999999
        left: $
    - id: Q43c
      kind: Question
      title: 'c. Interest, dividends, net rental income, royalty income, or income from estates and trusts. Report even small amounts credited to an account. (Yes/No box; "Loss" box: a loss is entered as a negative amount; No = 0)'
      input:
        control: Editbox
        min: -9999999
        max: 9999999
        left: $
    - id: Q43d
      kind: Question
      title: d. Social Security or Railroad Retirement. (Yes/No box; No = 0)
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
    - id: Q43e
      kind: Question
      title: e. Supplemental Security Income (SSI). (Yes/No box; No = 0)
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
    - id: Q43f
      kind: Question
      title: f. Any public assistance or welfare payments from the state or local welfare office. (Yes/No box; No = 0)
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
    - id: Q43g
      kind: Question
      title: g. Retirement income, pensions, survivor or disability income. Include income from a previous employer or union, or any regular withdrawals or distributions from IRA, Roth IRA, 401(k), 403(b), or other accounts specifically designed for retirement. Do not include Social Security. (Yes/No box; No = 0)
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
    - id: Q43h
      kind: Question
      title: h. Any other sources of income received regularly such as Veterans’ (VA) payments, unemployment compensation, child support or alimony. Do NOT include lump sum payments such as money from an inheritance or the sale of a home. (Yes/No box; No = 0)
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
    - id: Q44
      kind: Question
      title: 44 What was this person’s total income during the PAST 12 MONTHS? Add entries in questions 43a to 43h; subtract any losses. If net income was a loss, enter the amount and mark (X) the "Loss" box next to the dollar amount. None OR TOTAL AMOUNT for past 12 months (loss entered as negative; None = 0)
      postcondition:
      - predicate: Q44.outcome == Q43a.outcome + Q43b.outcome + Q43c.outcome + Q43d.outcome + Q43e.outcome + Q43f.outcome + Q43g.outcome + Q43h.outcome
        hint: Question 44 total income must equal the sum of the amounts in questions 43a to 43h, with losses subtracted.
        invented: true
      input:
        control: Editbox
        min: -20000000
        max: 80000000
        left: $
