qmlVersion: '2.7'
questionnaire:
  title: Survey of Household Spending 2000 (SHS 1)
  blocks:
  - id: b_s1_preamble
    title: Interview setup
    items:
    - id: ONE_PERSON_HOUSEHOLD
      kind: Question
      title: 'External input: whether this is a one-person household (derived from the list of household members in Section A)'
      external: true
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
  - id: b_s1_household_members
    title: Section A
    items:
    - id: A_1
      kind: Question
      title: In what year was__________ born? (If born in 1900 or earlier, enter 1900)
      input:
        control: Editbox
        min: 1900
        max: 2001
    - id: A_2
      kind: Question
      title: What is __________'s relationship to the household reference person?
      input:
        control: Radio
        labels:
          1: Reference Person
          2: Spouse
          3: Son/Daughter
          4: Other relative
          5: Not related
    - id: A_3
      kind: Question
      title: Is__________ male or female? Mark one circle.
      input:
        control: Radio
        labels:
          1: Male
          2: Female
    - id: A_4
      kind: Question
      title: 'What are the first names of all members of your household? Include in your household everyone who currently lives here and anyone who was part of your household at any time during 2000. List the household reference person first (see definition). Ask all questions in Section A for each member of the household that you have listed. (id 4 assigned from the printed numbering 1-6 on page 2: the numeral 4 sits beside the sex and first-name items and cannot be tied to a single item with certainty)'
      input:
        control: Textarea
    - id: A_5
      kind: Question
      title: What was___________'s marital status on December 31, 2000?
      input:
        control: Radio
        labels:
          1: Married spouse of a household member
          2: Common-law spouse of a household member
          3: Never married (single)
          4: Other (separated, divorced or widowed)
    - id: A_6
      kind: Question
      title: 'Economic Family Code (at time of interview or last day the person was a member of the household). Economic Family: Two or more persons who live in the same dwelling and are related to each other by blood, marriage, adoption or common-law. Unrelated roommates would have different codes. Enter Code:'
      input:
        control: Editbox
        min: 0
        max: 999
    - id: A_7
      kind: Question
      title: 'Was _____ a member of this household on December 31, 2000? (source_text: Q.7 per page 4 order; codes 3/4 as printed first on the page)'
      input:
        control: Radio
        labels:
          3: 'Yes'
          4: 'No'
    - id: A_8
      kind: Question
      title: Is _____ a member of this household today? (Q.8, printed last on page 4; the code table's 'Q.8 = Yes/No' tests this answer)
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: A_9
      kind: Question
      title: For how many weeks in 2000 was _____ a member of this household? If this is a one-person household, go to Q.11 after asking this question.
      input:
        control: Editbox
        min: 0
        max: 52
    - id: A_10
      kind: Question
      title: For how many weeks in 2000 did _____ live apart from this household, either as a one-person household, or in another household that no longer exists elsewhere?
      precondition:
      - predicate: A_9.outcome < 52 and ONE_PERSON_HOUSEHOLD.outcome == 2
        hint: Asked only when the weeks as a member (Q.9) are under 52 and this is not a one-person household
      - predicate: not (ONE_PERSON_HOUSEHOLD.outcome == 1)
        hint: Asked only when question ONE_PERSON_HOUSEHOLD is not "Yes".
      - predicate: not (A_9.outcome == 52)
        hint: Asked only when question A.9 is not 52.
      postcondition:
      - predicate: A_9.outcome + A_10.outcome <= 52
        hint: Weeks as a household member (Q.9) plus weeks lived apart (Q.10) cannot exceed 52.
        invented: true
      input:
        control: Editbox
        min: 0
        max: 52
    - id: A_11
      kind: Question
      title: Why is total weeks (Q.9 plus Q.10) less than 52?
      precondition:
      - predicate: A_9.outcome + A_10.outcome < 52
        hint: Asked only when total weeks (Q.9 plus Q.10) are under 52
      - predicate: not (A_9.outcome == 52)
        hint: Asked only when question A.9 is not 52.
      - predicate: not (A_9.outcome + A_10.outcome == 52)
        hint: Asked only when total weeks (Q.9 plus Q.10) are not 52
      input:
        control: Radio
        labels:
          1: Child born in 2000 or 2001
          2: Immigrated in 2000 or 2001
          3: Belonged to a household in existence elsewhere
          4: Other - Explain in notes
    - id: A_12
      kind: Question
      title: Data collection code. Use questions 8, 9 and 10 to determine the data collection code and the procedure to follow for each person.
      input:
        control: Radio
        labels:
          1: Q.8 = Yes and Q.9 is not equal to 00. Report data for total weeks (Q.9 plus Q.10).
          2: Q.8 = No and Q.9 is not equal to 00. Report data only for weeks a member of this household (Q.9).
          3: Q.8 = Yes, Q.9 = 00 and Q.10 is not equal to 00. Report data only for the weeks this person lived apart from this household (Q.10).
          4: Q.8 = Yes, Q.9 = 00 and Q.10 = 00. End questions for this person since they became a household member after 2000.
          5: Q.8 = No, Q.9 = 00 and Q.10 = 00. End questions for this person since not a household member.
  - id: b_s2_dwelling
    title: Section B (dwelling characteristics)
    items:
    - id: B_1
      kind: Question
      title: What type of dwelling did your household live in on December 31, 2000? Report answers for the dwelling that your household occupied on December 31, 2000. Mark one circle.
      input:
        control: Radio
        labels:
          1: 01 Single detached
          2: 02 Double
          3: 03 Row or terrace
          4: 04 Duplex
          5: 05 Apartment in a building that has less than five storeys
          6: 06 Apartment in a building that has five or more storeys
          7: 07 Hotel, rooming or lodging house, camp (e.g., logging, construction)
          8: 08 Mobile home
          9: 09 Other (Specify)
    - id: B_2
      kind: Question
      title: When was this dwelling originally built? Mark one circle.
      input:
        control: Radio
        labels:
          10: 10 1920 or before
          11: 11 1921-1945
          12: 12 1946-1960
          13: 13 1961-1970
          14: 14 1971-1980
          15: 15 1981-1990
          16: 16 1991-1999
          17: 17 2000
    - id: B_3
      kind: Question
      title: Was this dwelling in need of any repairs on December 31, 2000? Exclude remodelling and energy improvements.
      input:
        control: Radio
        labels:
          18: 18 Yes, major repairs were needed (e.g., corroded pipes, damaged electrical wiring, sagging floors, bulging walls, damp walls and ceilings, crumbling foundation, rotting porches and steps)
          19: 19 Yes, minor repairs were needed (e.g., small cracks in interior walls and ceilings, broken light fixtures and switches, leaking sinks, cracked or broken window panes, some missing shingles or siding, some peeling paint)
          20: 20 No, only regular maintenance was needed (e.g., painting, leaking faucets, clogged gutters or eavestroughs)
    - id: B_4
      kind: Question
      title: How many rooms were there in this dwelling? Include kitchen, bedrooms and finished rooms in the attic or basement. Exclude bathrooms, halls, vestibules and rooms used solely for business purposes.
      input:
        control: Editbox
        min: 0
        max: 50
    - id: B_5
      kind: Question
      title: How many bedrooms were there in this dwelling? Include all rooms designated as bedrooms even though the use may be occasional, as in the case of "spare" bedrooms. Exclude rooms designated as dining rooms, living rooms, etc. which may be used as bedrooms at night. If a bachelor apartment, enter "00" bedrooms
      postcondition:
      - predicate: B_5.outcome <= B_4.outcome
        hint: Bedrooms (Q.5) cannot exceed total rooms (Q.4), which include bedrooms.
        invented: true
      input:
        control: Editbox
        min: 0
        max: 50
    - id: B_6
      kind: Question
      title: How many bathrooms with a bathtub or shower were there in this dwelling?
      input:
        control: Editbox
        min: 0
        max: 20
  - id: b_s2_energy
    title: Heating, hot water and cooking
    items:
    - id: B_7
      kind: Question
      title: What was the principal heating equipment for this dwelling? Mark one circle.
      input:
        control: Radio
        labels:
          1: 01 Steam or hot water furnace
          2: 02 Forced hot air furnace
          3: 03 Other hot air furnace
          4: 04 Heating stove (include wood stove)
          5: 05 Electric heating (include electric baseboard heaters)
          6: 06 Cookstove
          7: 07 Other (Specify)
    - id: B_8
      kind: Question
      title: How old was this heating equipment? Mark one circle.
      input:
        control: Radio
        labels:
          8: 08 5 years or less (1995-2000)
          9: 09 6 to 10 years (1990-1994)
          10: 10 11 to 15 years (1985-1989)
          11: 11 16 to 20 years (1980-1984)
          12: 12 Over 20 years (Before 1980)
    - id: B_9
      kind: Question
      title: What was the principal fuel for this heating equipment? Mark one circle.
      input:
        control: Radio
        labels:
          13: 13 Oil or other liquid fuel
          14: 14 Piped gas (natural gas)
          15: 15 Bottled gas (propane)
          16: 16 Electricity
          17: 17 Wood
          18: 18 Other (Specify)
    - id: B_10
      kind: Question
      title: What was the principal fuel for the hot water supply? Mark one circle.
      input:
        control: Radio
        labels:
          19: 19 Oil or other liquid fuel
          20: 20 Piped gas (natural gas)
          21: 21 Bottled gas (propane)
          22: 22 Electricity
          23: 23 Wood
          24: 24 Other (Specify)
          25: 25 No running hot water
    - id: B_11
      kind: Question
      title: What was the main fuel used for cooking? Mark one circle.
      input:
        control: Radio
        labels:
          26: 26 Oil or other liquid fuel
          27: 27 Piped gas (natural gas)
          28: 28 Bottled gas (propane)
          29: 29 Electricity
          30: 30 Wood
          31: 31 Other (Specify)
  - id: b_s3_counts
    title: Section C (household equipment)
    items:
    - id: C_1
      kind: Question
      title: 'Refrigerators? (How many of the following did you have: If none, enter 0; if 10 or more, enter 9.)'
      input:
        control: Editbox
        min: 0
        max: 9
    - id: C_2
      kind: Question
      title: Colour TV sets?
      input:
        control: Editbox
        min: 0
        max: 9
    - id: C_3
      kind: Question
      title: VCRs?
      input:
        control: Editbox
        min: 0
        max: 9
    - id: C_4
      kind: Question
      title: Telephones? Include phones used for business. Exclude cellular phones. Exclude cordless phones. If Q.4 is zero, specify reason and go to Q.6; otherwise go to Q.5.
      input:
        control: Editbox
        min: 0
        max: 9
    - id: C_5
      kind: Question
      title: Telephone numbers for this dwelling? Include phone numbers used for business. Exclude cellular phone numbers.
      precondition:
      - predicate: C_4.outcome > 0
        hint: Asked only when question C.4 is greater than 0.
      - predicate: not (C_4.outcome == 0)
        hint: Asked only when question C.4 is not 0.
      input:
        control: Editbox
        min: 0
        max: 9
  - id: b_s3_yesno
    title: 'Household equipment: yes or no'
    items:
    - id: C_6
      kind: Question
      title: A cellular phone for personal use? (Did you have:)
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: C_7
      kind: Question
      title: A microwave oven?
      input:
        control: Radio
        labels:
          3: 'Yes'
          4: 'No'
    - id: C_8
      kind: Question
      title: A freezer separate from the refrigerator?
      input:
        control: Radio
        labels:
          5: 'Yes'
          6: 'No'
    - id: C_9
      kind: Question
      title: Cable TV?
      input:
        control: Radio
        labels:
          7: 'Yes'
          8: 'No'
    - id: C_10
      kind: Question
      title: A CD player?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: C_11
      kind: Question
      title: A home computer? Exclude computers used exclusively for business.
      input:
        control: Radio
        labels:
          3: 'Yes'
          4: 'No'
  - id: b_s3_computer
    title: Home computer follow-ups
    precondition:
    - predicate: not (C_11.outcome == 4)
      hint: Asked only when question C.11 is not "No".
    items:
    - id: C_12
      kind: Question
      title: A modem?
      input:
        control: Radio
        labels:
          5: 'Yes'
          6: 'No'
    - id: C_13
      kind: Question
      title: Did you use the Internet from home?
      precondition:
      - predicate: not (C_12.outcome == 6)
        hint: Asked only when question C.12 is not "No".
      input:
        control: Radio
        labels:
          7: 'Yes'
          8: 'No'
  - id: b_s3_appliances
    title: Household appliances
    items:
    - id: C_14
      kind: Question
      title: 'Did you have: Mark one circle.'
      input:
        control: Radio
        labels:
          1: Window-type air conditioning units?
          2: Central air conditioning?
          3: None
    - id: C_15
      kind: Question
      title: 'Did you have (inside your dwelling): Mark one circle.'
      input:
        control: Radio
        labels:
          4: A built-in automatic dishwasher?
          5: A portable automatic dishwasher?
          6: None
    - id: C_16
      kind: Question
      title: 'Did you have (inside your dwelling): Mark one circle.'
      input:
        control: Radio
        labels:
          7: An automatic washing machine?
          8: Any other kind of washing machine?
          9: None
    - id: C_17
      kind: Question
      title: 'Did you have: Mark one circle.'
      input:
        control: Radio
        labels:
          1: An electric clothes dryer?
          2: A gas clothes dryer?
          3: None
  - id: b_s4_preamble
    title: Interview setup
    items:
    - id: SPOUSE_OF_REFERENCE_PERSON
      kind: Question
      title: 'External input: whether the household reference person has a spouse (derived from Section A relationship to reference person)'
      external: true
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
  - id: b_s4_tenure
    title: Section D (tenure and previous dwellings)
    items:
    - id: D_1
      kind: Question
      title: 'On December 31, 2000 was your dwelling:'
      input:
        control: Radio
        labels:
          1: Owned without a mortgage by your household?
          2: Owned with (a) mortgage(s) by your household?
          3: Rented by your household?
          4: Occupied rent-free by your household (i.e. where no member owned the dwelling and no rent was charged)?
    - id: D_2
      kind: Question
      title: In what year did your household move to this dwelling? Year. If before 1995, go to instructions after Q.7.4 (page 12)
      input:
        control: Editbox
        min: 1900
        max: 2001
  - id: b_s4_previous
    title: Previous dwelling of reference person and spouse
    precondition:
    - predicate: not (D_2.outcome < 1995)
    items:
    - id: D_3
      kind: Question
      title: Did the reference person own or rent their previous dwelling? Mark one circle.
      input:
        control: Radio
        labels:
          1: Owned
          2: Rented
          3: Did not maintain their own dwelling
    - id: D_4
      kind: Question
      title: Did the spouse of the reference person own or rent their previous dwelling? Mark one circle. If no spouse, go to Q.5.
      precondition:
      - predicate: SPOUSE_OF_REFERENCE_PERSON.outcome == 1
        hint: Asked only when the reference person has a spouse.
      input:
        control: Radio
        labels:
          4: Owned
          5: Rented
          6: Did not maintain their own dwelling
  - id: b_s4_moved_2000
    title: Household moved in 2000
    precondition:
    - predicate: D_2.outcome == 2000
      hint: Asked only when question D.2 is 2000.
    items:
    - id: D_5
      kind: Question
      title: Did anyone in this household report TOTAL WEEKS equal to 52? (See Section A, Q.9 plus Q.10) (If this household moved in 2000 go to Q.5; otherwise go to the instructions after Q.7.4 (page 12).)
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: D_5_1
      kind: Question
      title: For the total weeks reported earlier (Section A, Q.9 plus Q.10), did anyone live in another dwelling?
      precondition:
      - predicate: D_5.outcome == 2
        hint: Asked only when question D.5 is "No".
      input:
        control: Radio
        labels:
          3: 'Yes'
          4: 'No'
  - id: b_s4_prev_occupied
    title: Dwellings previously occupied by your household in 2000
    precondition:
    - predicate: D_2.outcome == 2000
      hint: Asked only when question D.2 is 2000.
    - predicate: not (D_5_1.outcome == 4)
      hint: Asked only when question D.5.1 is not "No".
    items:
    - id: D_6_1
      kind: Question
      title: 'Instructions for the Expenditure Questions. 6. Dwellings Previously Occupied by Your Household in 2000. Were any of the dwellings previously occupied in 2000: Owned with (a) mortgage(s) by your household?'
      input:
        control: Radio
        labels:
          5: 'Yes'
          6: 'No'
    - id: D_6_2
      kind: Question
      title: Owned without a mortgage by your household?
      input:
        control: Radio
        labels:
          7: 'Yes'
          8: 'No'
    - id: D_6_3
      kind: Question
      title: Rented by your household?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: D_6_4
      kind: Question
      title: Occupied rent-free by your household (i.e. where no member owned the dwelling and no rent was charged)? If Q.6.1 and Q.6.2 are both "No", go to the instructions after Q.7.4.
      input:
        control: Radio
        labels:
          3: 'Yes'
          4: 'No'
  - id: b_s4_prev_owned
    title: Dwellings previously owned and occupied in 2000
    precondition:
    - predicate: D_2.outcome == 2000
      hint: Asked only when question D.2 is 2000.
    - predicate: not (D_5_1.outcome == 4)
      hint: Asked only when question D.5.1 is not "No".
    - predicate: not (D_6_1.outcome == 6 and D_6_2.outcome == 8)
      hint: Asked only when a previous dwelling was owned.
    items:
    - id: D_7_1
      kind: Question
      title: '7. Were any of the dwellings previously owned and occupied in 2000: Sold?'
      input:
        control: Radio
        labels:
          5: 'Yes'
          6: 'No'
    - id: D_7_2
      kind: Question
      title: Rented to others?
      input:
        control: Radio
        labels:
          7: 'Yes'
          8: 'No'
    - id: D_7_3
      kind: Question
      title: Left vacant?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: D_7_4
      kind: Question
      title: Other? Specify
      input:
        control: Radio
        labels:
          3: 'Yes'
          4: 'No'
  - id: b_s5_owned_count
    title: 'Section E: dwellings owned and occupied'
    items:
    - id: E_1
      kind: Question
      title: How many dwellings did members of your household own and occupy in 2000? Exclude vacation homes, secondary residences and dwellings owned but not occupied by any member of the household in 2000. If none, enter "00" and go to Section I (page 19)
      input:
        control: Editbox
        min: 0
        max: 20
  - id: b_s5_owned_expenses
    title: Expenses for owned and occupied dwellings
    precondition:
    - predicate: E_1.outcome > 0
      hint: Asked only when question E.1 is not 0.
    items:
    - id: E_2
      kind: Question
      title: For how many months in 2000 did your household own and occupy the dwelling(s)?
      input:
        control: Editbox
        min: 0
        max: 12
    - id: E_3_1
      kind: Question
      title: 'For dwelling(s) owned and occupied in 2000, how much was the: Total amount billed for property taxes in 2000? Include school taxes, special service charges and local improvements billed in 2000. If none, explain'
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
    - id: E_3_2
      kind: Question
      title: Total premiums paid in 2000 for homeowners' insurance covering fire, theft and other perils?
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
    - id: E_3_3
      kind: Question
      title: Amount paid for condominium charges? Include special levies.
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
    - id: E_4
      kind: Question
      title: Were any of the expenses just mentioned (in Q.3) charged against income from businesses owned by household members?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: No (Go to Q.5)
  - id: b_s5_business_share
    title: Portion charged to business income
    precondition:
    - predicate: E_1.outcome > 0
      hint: Asked only when question E.1 is not 0.
    - predicate: E_4.outcome == 1
      hint: Asked only when question E.4 is "Yes".
    items:
    - id: E_4_1
      kind: Question
      title: What amount or percentage of the total (Q.3.1 to Q.3.3) was charged against income from your businesses? Exclude rooms rented out (see Q.5). Amount ($)
      postcondition:
      - predicate: E_4_1.outcome <= E_3_1.outcome + E_3_2.outcome + E_3_3.outcome
        hint: The amount charged to business income (Q.4.1) cannot exceed the total of Q.3.1 to Q.3.3.
        invented: true
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
    - id: E_4_1_pct
      kind: Question
      title: 'OR % (percentage of the total (Q.3.1 to Q.3.3) charged against income from your businesses) (id assigned: source prints the percentage beside Q.4.1 without its own number)'
      input:
        control: Editbox
        min: 0
        max: 100
        right: '%'
  - id: b_s5_rental_screen
    title: Rooms rented out
    precondition:
    - predicate: E_1.outcome > 0
      hint: Asked only when question E.1 is not 0.
    items:
    - id: E_5
      kind: Question
      title: Were any of the expenses just mentioned (in Q.3) charged against income from rooms rented out?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: No (Go to Section F)
  - id: b_s5_rental_share
    title: Portion charged to rental income
    precondition:
    - predicate: E_1.outcome > 0
      hint: Asked only when question E.1 is not 0.
    - predicate: E_5.outcome == 1
      hint: Asked only when question E.5 is "Yes".
    items:
    - id: E_5_1_1
      kind: Question
      title: 'What amount or percentage of the total (Q.3.1 to Q.3.3) was charged against income from rooms rented to: Household member(s) excluding relatives? Amount ($)'
      postcondition:
      - predicate: E_5_1_1.outcome <= E_3_1.outcome + E_3_2.outcome + E_3_3.outcome
        hint: The amount for rooms rented to household members (Q.5.1.1) cannot exceed the total of Q.3.1 to Q.3.3.
        invented: true
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
    - id: E_5_1_1_pct
      kind: Question
      title: 'OR % (rooms rented to household member(s) excluding relatives) (id assigned: percentage beside Q.5.1.1)'
      input:
        control: Editbox
        min: 0
        max: 100
        right: '%'
    - id: E_5_1_2
      kind: Question
      title: Persons who were not members of your household, e.g., students who are members of an eligible household elsewhere? Amount ($)
      postcondition:
      - predicate: E_5_1_2.outcome <= E_3_1.outcome + E_3_2.outcome + E_3_3.outcome
        hint: The amount for rooms rented to non-members (Q.5.1.2) cannot exceed the total of Q.3.1 to Q.3.3.
        invented: true
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
    - id: E_5_1_2_pct
      kind: Question
      title: 'OR % (rooms rented to persons who were not members of your household) (id assigned: percentage beside Q.5.1.2)'
      input:
        control: Editbox
        min: 0
        max: 100
        right: '%'
  - id: b_s6_purchase
    title: Purchase of a home
    precondition:
    - predicate: not (E_1.outcome == 0)
      hint: Asked only when question E.1 is not 0.
    items:
    - id: F_1
      kind: Question
      title: Did your household purchase a home in 2000?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: No (Go to Q.2)
  - id: b_s6_purchase_details
    title: Home purchase details
    precondition:
    - predicate: not (E_1.outcome == 0)
      hint: Asked only when question E.1 is not 0.
    - predicate: F_1.outcome == 1
      hint: Asked only when question F.1 is "Yes".
    - predicate: not (F_1.outcome == 2)
      hint: Asked only when question F.1 is not "No (Go to Q.2)".
    items:
    - id: F_1_1
      kind: Question
      title: Was this purchase made by (a) person(s) who had never previously owned a dwelling which they occupied?
      input:
        control: Radio
        labels:
          3: 'Yes'
          4: 'No'
    - id: F_1_2
      kind: Question
      title: What was the purchase price of your home? Exclude adjustments to property taxes and fuel oil (see Sections E and J).
      input:
        control: Editbox
        min: 0
        max: 99999999
    - id: F_1_3
      kind: Question
      title: How much was paid for land transfer taxes and land registration fees?
      postcondition:
      - predicate: F_1_3.outcome <= F_1_2.outcome
        hint: Land transfer taxes and registration fees (Q.1.3) cannot exceed the purchase price (Q.1.2).
        invented: true
      input:
        control: Editbox
        min: 0
        max: 99999999
  - id: b_s6_sale
    title: Sale of a home
    precondition:
    - predicate: not (E_1.outcome == 0)
      hint: Asked only when question E.1 is not 0.
    items:
    - id: F_2
      kind: Question
      title: Did your household sell a home in 2000?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: No (Go to Q.3)
  - id: b_s6_sale_details
    title: Home sale details
    precondition:
    - predicate: not (E_1.outcome == 0)
      hint: Asked only when question E.1 is not 0.
    - predicate: F_2.outcome == 1
      hint: Asked only when question F.2 is "Yes".
    - predicate: not (F_2.outcome == 2)
      hint: Asked only when question F.2 is not "No (Go to Q.3)".
    items:
    - id: F_2_1
      kind: Question
      title: What was the selling price of your home?
      input:
        control: Editbox
        min: 0
        max: 99999999
    - id: F_2_2
      kind: Question
      title: How much was paid for real estate commissions?
      postcondition:
      - predicate: F_2_2.outcome <= F_2_1.outcome
        hint: Real estate commissions (Q.2.2) cannot exceed the selling price (Q.2.1).
        invented: true
      input:
        control: Editbox
        min: 0
        max: 99999999
  - id: b_s6_expenses
    title: Other dwelling-related expenses
    precondition:
    - predicate: not (E_1.outcome == 0)
      hint: Asked only when question E.1 is not 0.
    items:
    - id: F_3
      kind: Question
      title: 'In 2000, how much did your household spend on: Legal charges related to the dwelling(s), e.g., title searches and mortgage registration fees?'
      input:
        control: Editbox
        min: 0
        max: 99999999
    - id: F_4
      kind: Question
      title: Other expenses related to the dwelling(s), e.g., surveying, appraisals, renewal fees and early renewal or closing penalties associated with mortgage payments? Specify. Question 4 should exclude expenses which will be asked for in Sections G to K (mortgage costs, renovations, repairs, rent and utilities).
      input:
        control: Editbox
        min: 0
        max: 99999999
  - id: b_s7_screen
    title: Section G (mortgages)
    precondition:
    - predicate: not (E_1.outcome == 0)
      hint: Asked only when question E.1 is not 0.
    items:
    - id: G_1
      kind: Question
      title: In 2000, did your household have any mortgages on dwellings which it owned and occupied? Exclude mortgages on rental property, vacation homes, secondary residences and dwellings not occupied at any time in 2000.
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: No (Go to Section H)
  - id: b_s7_mortgages
    title: 'Section G (mortgages): payments, insurance and amounts added'
    precondition:
    - predicate: not (E_1.outcome == 0)
      hint: Asked only when question E.1 is not 0.
    - predicate: G_1.outcome == 1
      hint: Asked only when question G.1 is "Yes".
    - predicate: not (G_1.outcome == 2)
      hint: Asked only when question G.1 is not "No (Go to Section H)".
    items:
    - id: G_2_1
      kind: Question
      title: In 2000, what payments did your household make on its mortgages? Exclude amounts pertaining to business, e.g., part of a duplex. 2.1 Regular payments? Amount $
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
    - id: G_2_1_number
      kind: Question
      title: '2.1 Regular payments? Number (of payments) (id assigned: second column of Q.2.1)'
      input:
        control: Editbox
        min: 0
        max: 999
    - id: G_2_2
      kind: Question
      title: 2.2 Irregular and lump sum payments including payments made to close the mortgage? Amount $
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
    - id: G_2_2_number
      kind: Question
      title: '2.2 Irregular and lump sum payments ... Number (of payments) (id assigned: second column of Q.2.2)'
      input:
        control: Editbox
        min: 0
        max: 999
    - id: G_3_1
      kind: Question
      title: 'Did the mortgage payments just reported (in Q.2) include: 3.1 Property taxes?'
      input:
        control: Radio
        labels:
          3: 'Yes'
          4: 'No'
    - id: G_3_2
      kind: Question
      title: 3.2 Mortgage life and/or disability insurance?
      input:
        control: Radio
        labels:
          5: 'Yes'
          6: 'No'
    - id: G_3_3
      kind: Question
      title: 3.3 What was the total premium paid in 2000 for mortgage life and/or disability insurance?
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
    - id: G_4
      kind: Question
      title: Were any amounts added to your mortgage(s) in 2000? Exclude all other loans (see Sections X and Y). Include the amount borrowed if the mortgage started in 2000.
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: No (Go to Section H)
    - id: G_4_1
      kind: Question
      title: What amounts were added? Exclude amounts pertaining to business, e.g., part of a duplex.
      precondition:
      - predicate: G_4.outcome == 1
        hint: Asked only when question G.4 is "Yes".
      - predicate: not (G_4.outcome == 2)
        hint: Asked only when question G.4 is not "No (Go to Section H)".
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
  - id: b_s8_additions
    title: Section H (additions, renovations and installations)
    precondition:
    - predicate: not (E_1.outcome == 0)
      hint: Asked only when question E.1 is not 0.
    items:
    - id: H_1
      kind: Question
      title: In 2000, how much did your household spend on additions, renovations and other alterations? Total Cost $ (Specify:) Include in-ground pools, pre-fabricated sheds, landscaping and complete re-roofing. Include work done to upgrade the property to acceptable building or living standards, to rearrange the interior space, or to modernize the existing facilities without changing the type of occupancy. Include any finishing in new homes. Exclude expenses for vacation homes, secondary residences, rented principal residences and other properties. Exclude expenses charged against business and rental income.
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: Total Cost $
    - id: H_2_1
      kind: Question
      title: 'In 2000, how much did your household spend on installations of built-in equipment, appliances and fixtures? Replacement $ (the installation of equipment or fixtures to replace an existing unit, e.g., replacing an electric water-heater with a gas model). Exclude any installations already reported. (id assigned: source prints Q.2 with Replacement and New installation amounts)'
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: Replacement $
    - id: H_2_2
      kind: Question
      title: 'New installation $ (the installation of equipment or fixtures that did not previously exist on the property, or that were installed in addition to the equipment or fixtures on the property, e.g., installing a shower stall in a former half-bathroom). Specify:'
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: New installation $
  - id: b_s9_repairs
    title: 'Section H (continued): repairs and maintenance'
    precondition:
    - predicate: not (E_1.outcome == 0)
      hint: Asked only when question E.1 is not 0.
    items:
    - id: H_3
      kind: Question
      title: In 2000, how much did your household spend on repairs and maintenance? (Include expenditures made for an existing structure or piece of equipment to keep it in good working condition and to maintain its appearance. Include repairs done to broken, damaged or malfunctioning components. Include painting, equipment service contracts, cleaning of equipment, and work done on fences, patios and driveways. Exclude housekeeping costs such as rug cleaning, window washing, cleaning out of eavestroughs, groundskeeping, snow removal and garbage removal (see Sections L and M).) Total Cost $
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
  - id: b_s10_months
    title: Rented Principal Residences
    items:
    - id: I_1
      kind: Question
      title: For how many months in 2000 did your household occupy a rented dwelling? (If none, enter "00" and go to Section J (page 21))
      input:
        control: Editbox
        min: 0
        max: 12
  - id: b_s10_rent
    title: Rent and related costs
    precondition:
    - predicate: not (I_1.outcome == 0)
      hint: Asked only when question I.1 is not 0.
    items:
    - id: I_2
      kind: Question
      title: What monthly rental payments were made for the principal residences which your household occupied in 2000? (Include any part of the dwelling used for business or rented to others. Include amounts paid on behalf of your household, if known.) Enter total rent paid
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: I_3
      kind: Question
      title: In 2000, what additional amount was paid to the landlord that was not included in the payments just reported, e.g., security deposits?
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: I_4
      kind: Question
      title: In 2000, how much of the rent which you paid was returned to your household for any reason, e.g., rent overpayment and return of damage deposit? (Exclude provincial tax credits for rent paid and provincial or municipal rent allowances.)
      postcondition:
      - predicate: I_4.outcome <= I_2.outcome + I_3.outcome
        hint: El importe devuelto (I.4) no puede superar el alquiler total pagado (I.2) más los pagos adicionales (I.3)
        invented: true
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: I_5
      kind: Question
      title: 'Did your household pay reduced rent in 2000 for any of the following reasons: (1) Government subsidized housing? (Include federal, provincial and municipal programs.) (2) Other reasons, e.g., services to landlord and company housing? (3) No reduced rent?'
      input:
        control: Radio
        labels:
          1: Government subsidized housing?
          2: Other reasons, e.g., services to landlord and company housing?
          3: No reduced rent?
    - id: I_6_1
      kind: Question
      title: 'In 2000, how much did your household spend on: Additions, renovations, alterations, installations and replacements of equipment and fixtures, and repairs and maintenance for rented dwelling(s) occupied in 2000? (Exclude amounts reimbursed by the landlord.)'
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: I_6_2
      kind: Question
      title: Tenants' insurance?
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: I_6_3
      kind: Question
      title: Parking at your place of residence? (Exclude any amount that was included in previous answers on rent expenses.)
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: I_7
      kind: Question
      title: In 2000, was any part of the rent expense charged against income from businesses owned by the household members? (Exclude rooms rented out (see Q.8).)
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
  - id: b_s10_business
    title: Rent charged against business income
    precondition:
    - predicate: not (I_1.outcome == 0) and I_7.outcome == 1
      hint: Asked only when question I.1 is not 0 and question I.7 is "Yes".
    items:
    - id: I_7_1
      kind: Question
      title: What amount or percentage of the rent expense (Q.2 plus Q.3 plus Q.6 less Q.4) was charged against income from your businesses? $
      postcondition:
      - predicate: I_7_1.outcome <= I_2.outcome + I_3.outcome + I_6_1.outcome + I_6_2.outcome + I_6_3.outcome - I_4.outcome
        hint: El importe cargado al negocio (I.7.1) no puede superar el gasto de alquiler total (I.2 + I.3 + I.6 - I.4)
        invented: true
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: I_7_1_2
      kind: Question
      title: OR % of the rent expense charged against income from your businesses
      input:
        control: Editbox
        min: 0
        max: 100
  - id: b_s10_rooms
    title: Rent charged against income from rooms rented
    precondition:
    - predicate: not (I_1.outcome == 0)
      hint: Asked only when question I.1 is not 0.
    items:
    - id: I_8
      kind: Question
      title: In 2000, was any part of the rent expenses charged against income from rooms rented to others?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
  - id: b_s10_rooms_detail
    title: Rooms rented to others
    precondition:
    - predicate: not (I_1.outcome == 0) and I_8.outcome == 1
      hint: Asked only when question I.1 is not 0 and question I.8 is "Yes".
    items:
    - id: I_8_1_1
      kind: Question
      title: 'What amount or percentage of the rent expense (Q.2 plus Q.3 plus Q.6 less Q.4) was charged against income from rooms rented to: Household member(s) excluding relatives? $'
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: I_8_1_1_2
      kind: Question
      title: OR % charged against income from rooms rented to household member(s) excluding relatives
      input:
        control: Editbox
        min: 0
        max: 100
    - id: I_8_1_2
      kind: Question
      title: Persons who were not members of your household, e.g., students who are members of an eligible household elsewhere? $
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: I_8_1_2_2
      kind: Question
      title: OR % charged against income from rooms rented to persons who were not members of your household
      input:
        control: Editbox
        min: 0
        max: 100
  - id: b_s11_utilities
    title: Water, Fuel and Electricity for Principal Residences
    items:
    - id: J_1_1
      kind: Question
      title: 'In 2000, how much did your household spend on: Water and sewage charges (not included in property tax bill), e.g., pumping services? (Ask OWNERS and RENTERS these questions.)'
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
    - id: J_1_2
      kind: Question
      title: Electricity?
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
    - id: J_1_3
      kind: Question
      title: Other fuel for heating and cooking, e.g., oil, gas, propane and wood?
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
    - id: J_1_4
      kind: Question
      title: Rental of heating equipment?
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
  - id: b_s11_accommodation
    title: Other Rented Accommodation
    items:
    - id: J_2_1
      kind: Question
      title: 'In 2000, while away from home overnight or longer, how much did your household spend on: Hotels and motels?'
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
    - id: J_2_2
      kind: Question
      title: Other accommodation?
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
    - id: J_2_3
      kind: Question
      title: Of this amount (Q.2.1 plus Q.2.2), how much was spent in this province? %
      input:
        control: Editbox
        min: 0
        max: 100
        right: '%'
    - id: J_2_3_2
      kind: Question
      title: OR amount spent in this province (of Q.2.1 plus Q.2.2) $
      postcondition:
      - predicate: J_2_3_2.outcome <= J_2_1.outcome + J_2_2.outcome
        hint: El importe gastado en esta provincia (J.2.3) no puede superar el total de J.2.1 más J.2.2
        invented: true
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
  - id: b_s12_vacation_screen
    title: Owned Vacation Homes and Other Secondary Residences
    items:
    - id: K_1
      kind: Question
      title: In 2000, did any member of your household own a vacation home or other secondary residence? (Ask OWNERS and RENTERS these questions. Exclude mobile vacation homes (see Section R, Q.3, page 45). Exclude expenses charged against business income.)
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
  - id: b_s12_vacation_main
    title: Vacation Home Purchase and Financing
    precondition:
    - predicate: not (K_1.outcome == 2)
      hint: Asked only when question K.1 is not "No".
    items:
    - id: K_2
      kind: Question
      title: In 2000, did any member of your household purchase a vacation home or other secondary residence?
      input:
        control: Radio
        labels:
          3: 'Yes'
          4: 'No'
    - id: K_2_1
      kind: Question
      title: What was the purchase price?
      precondition:
      - predicate: K_2.outcome == 3
        hint: Asked only when question K.2 is "Yes".
      input:
        control: Editbox
        min: 0
        max: 99999999
    - id: K_3
      kind: Question
      title: How much money was borrowed in 2000 for expenses associated with the dwelling(s)? (Include purchase as well as mortgage and other financial obligations.)
      input:
        control: Editbox
        min: 0
        max: 99999999
    - id: K_4
      kind: Question
      title: How much were the mortgage payments in 2000? (Exclude payments made at time of sale.)
      input:
        control: Editbox
        min: 0
        max: 99999999
    - id: K_5
      kind: Question
      title: Was (were) the dwelling(s) sold in 2000?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
  - id: b_s12_vacation_sale
    title: Vacation Home Sale
    precondition:
    - predicate: not (K_1.outcome == 2) and K_5.outcome == 1
      hint: Asked only when question K.1 is not "No" and question K.5 is "Yes".
    items:
    - id: K_5_1
      kind: Question
      title: What was the selling price?
      input:
        control: Editbox
        min: 0
        max: 99999999
    - id: K_5_2
      kind: Question
      title: What was the net amount received from the sale (the selling price less the amount paid on the outstanding mortgage and the real estate commissions)?
      postcondition:
      - predicate: K_5_2.outcome <= K_5_1.outcome
        hint: El importe neto recibido (K.5.2) no puede superar el precio de venta (K.5.1)
        invented: true
      input:
        control: Editbox
        min: 0
        max: 99999999
  - id: b_s12_vacation_expenses
    title: Vacation Home Expenses
    precondition:
    - predicate: not (K_1.outcome == 2)
      hint: Asked only when question K.1 is not "No".
    items:
    - id: K_6_1
      kind: Question
      title: 'In 2000, how much did your household spend on: Additions, renovations and new installations?'
      input:
        control: Editbox
        min: 0
        max: 99999999
    - id: K_6_2
      kind: Question
      title: Repairs, maintenance and replacements?
      input:
        control: Editbox
        min: 0
        max: 99999999
    - id: K_6_3
      kind: Question
      title: Property taxes and sewage charges?
      input:
        control: Editbox
        min: 0
        max: 99999999
    - id: K_6_4
      kind: Question
      title: Insurance?
      input:
        control: Editbox
        min: 0
        max: 99999999
    - id: K_6_5
      kind: Question
      title: Electricity, water and fuel?
      input:
        control: Editbox
        min: 0
        max: 99999999
    - id: K_6_6
      kind: Question
      title: Other expenses associated with the property, e.g., condominium charges, survey costs, real estate commissions, legal fees and mortgage insurance premiums?
      input:
        control: Editbox
        min: 0
        max: 99999999
  - id: b_s12_other_screen
    title: Other Property
    items:
    - id: K_7
      kind: Question
      title: 'Other Property. In 2000, did any member of your household own any other property? (Exclude principal and secondary residences, rental or other business property, and farm property. NOTE: An owned dwelling which was not occupied during 2000 should be considered as "other property" for the time it was not occupied, unless it was a rental or business property.)'
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
  - id: b_s12_other_main
    title: Other Property Purchase, Financing and Expenses
    precondition:
    - predicate: not (K_7.outcome == 2)
      hint: Asked only when question K.7 is not "No".
    items:
    - id: K_8
      kind: Question
      title: In 2000, did any member of your household purchase any other property?
      input:
        control: Radio
        labels:
          3: 'Yes'
          4: 'No'
    - id: K_8_1
      kind: Question
      title: What was the purchase price?
      precondition:
      - predicate: K_8.outcome == 3
        hint: Asked only when question K.8 is "Yes".
      input:
        control: Editbox
        min: 0
        max: 99999999
    - id: K_9
      kind: Question
      title: How much money was borrowed in 2000 for expenses associated with the property (including purchase)?
      input:
        control: Editbox
        min: 0
        max: 99999999
    - id: K_10
      kind: Question
      title: How much were the mortgage payments in 2000? (Exclude payments made at time of sale.)
      input:
        control: Editbox
        min: 0
        max: 99999999
    - id: K_11
      kind: Question
      title: How much did your household spend on additions or major alterations to the property in 2000, e.g., servicing of land?
      input:
        control: Editbox
        min: 0
        max: 99999999
    - id: K_12
      kind: Question
      title: How much was spent in 2000 on other expenses associated with the property, e.g., property taxes, survey costs, appraisal fees and utilities?
      input:
        control: Editbox
        min: 0
        max: 99999999
    - id: K_13
      kind: Question
      title: Was any of the property sold in 2000?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
  - id: b_s12_other_sale
    title: Other Property Sale
    precondition:
    - predicate: not (K_7.outcome == 2) and K_13.outcome == 1
      hint: Asked only when question K.7 is not "No" and question K.13 is "Yes".
    items:
    - id: K_13_1
      kind: Question
      title: What was the selling price?
      input:
        control: Editbox
        min: 0
        max: 99999999
    - id: K_13_2
      kind: Question
      title: What was the net amount received from the sale (the selling price less the amount paid on the outstanding mortgage and real estate commissions)?
      postcondition:
      - predicate: K_13_2.outcome <= K_13_1.outcome
        hint: El importe neto recibido (K.13.2) no puede superar el precio de venta (K.13.1)
        invented: true
      input:
        control: Editbox
        min: 0
        max: 99999999
  - id: b_s13_furnishings
    title: Furnishings
    items:
    - id: L_1
      kind: Question
      title: 'In 2000, how much did your household spend on: Furniture for indoor or outdoor use? (Include indoor and outdoor furniture. Include the cost of home-made or home-finished furnishings. Include purchases for use in vacation homes or in other accommodations. Include all sales taxes. Include gifts purchased for persons who were not members of your household. Exclude rentals (see Q.47, page 31). Exclude expenses charged against business income.)'
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: L_2
      kind: Question
      title: Glass mirrors, and mirror and picture frames?
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: L_3
      kind: Question
      title: Lamps and lampshades? (Exclude light fixtures (see Section H).)
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: L_4
      kind: Question
      title: Rugs, mats and underpadding? (Exclude wall-to-wall carpeting (see Section H).)
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: L_5
      kind: Question
      title: Window coverings, and household textiles e.g., curtains, blinds, bedding, towels, tablecloths, cushions and bathroom accessories? (Include cloth material used to make household furnishings.)
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: L_6
      kind: Question
      title: Works of art, carvings and vases?
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: L_7
      kind: Question
      title: Antiques, e.g., furniture and jewellery that are at least 100 years old?
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: L_8
      kind: Question
      title: Maintenance and repair of furniture, carpeting and household textiles? (Include cleaning of carpets and furniture. Include re-upholstering of furniture. Include mattresses.)
      input:
        control: Editbox
        min: 0
        max: 999999
  - id: b_s13_entertainment
    title: Home entertainment and computers
    items:
    - id: L_9
      kind: Question
      title: Audio combinations, components and radios, e.g., tape recorder/players, CD players, receivers, amplifiers and speakers? (Include clock and telephone combinations and console systems. Exclude car radios (see Section Q, Q.11, page 43). Exclude accessories and attachments for vehicles (see Sections Q and R). Report net purchase price (the price after the trade-in allowance is deducted).) Net Purchase Price of Items Purchased in 2000
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: L_10
      kind: Question
      title: Televisions, VCRs, camcorders and other television/video components? (Include combinations, projection and monitor style TVs.)
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: L_11
      kind: Question
      title: Compact discs, pre-recorded audiotapes, videos and videodiscs?
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: L_12
      kind: Question
      title: Blank audio and video tapes?
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: L_13
      kind: Question
      title: Other home entertainment equipment, attachments, accessories and parts purchased separately, e.g., satellite dishes, headphones, microphones, cases, cleaners and coaxial cable?
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: L_14_1
      kind: Question
      title: 'Computer hardware, e.g., monitors, keyboards, disk drives, printers and mouses: Purchased new?'
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: L_14_2
      kind: Question
      title: Purchased used? (Exclude items that were traded-in.)
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: L_14_3
      kind: Question
      title: How much was received from the sale of computer hardware equipment?
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: L_15
      kind: Question
      title: Computer software, e.g., operating systems, word-processing, spreadsheet and utilities programs, and multimedia software?
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: L_16
      kind: Question
      title: Computer supplies and other equipment, e.g., diskettes, computer paper and diskette storage boxes?
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: L_17
      kind: Question
      title: Rental of videos and videodiscs? (Home Entertainment Services)
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: L_18
      kind: Question
      title: Maintenance and repair of home entertainment equipment? (Include service contracts.)
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: L_19
      kind: Question
      title: Rental of cablevision and satellite services in 2000? (Include pay TV.)
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: L_20
      kind: Question
      title: Rental of home entertainment equipment, and other services related to home entertainment equipment and supplies? (Include all types of audio, video and computer equipment and supplies mentioned earlier. Exclude rental of video games (see Section S, Q.13, page 49).) Specify
      input:
        control: Editbox
        min: 0
        max: 999999
  - id: b_s13_appliances
    title: Appliances
    items:
    - id: L_21
      kind: Question
      title: 'Major Household Appliances: Refrigerators and freezers? (Exclude purchases of built-in appliances (see Section H, page 17). Exclude rentals (see Q.47, page 31). Report net purchase price (the price after the trade-in allowance is deducted).) Net Purchase Price of Items Purchased in 2000'
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: L_22
      kind: Question
      title: Cooking stoves and ranges?
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: L_23
      kind: Question
      title: Microwave and convection ovens?
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: L_24
      kind: Question
      title: Washers and dryers?
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: L_25
      kind: Question
      title: Vacuum cleaners and other rug cleaning equipment? (Exclude central vacuum cleaner systems (see Section H, page 17).)
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: L_26
      kind: Question
      title: Sewing machines?
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: L_27
      kind: Question
      title: Portable dishwashers?
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: L_28
      kind: Question
      title: Gas barbecues? (Exclude electric and charcoal barbecues (see Q.32 and Q.45).)
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: L_29
      kind: Question
      title: Room air conditioners, portable humidifiers and dehumidifiers?
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: L_30_1
      kind: Question
      title: 'How much did your household spend on: Attachments and parts purchased separately for major household appliances? (Include vacuum cleaner bags.)'
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: L_30_2
      kind: Question
      title: Maintenance and repair of major household appliances? (Include service contracts.)
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: L_31
      kind: Question
      title: If your household sold any major household appliances, what was the total amount received in 2000? (Exclude appliances that were traded-in.)
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: L_32
      kind: Question
      title: 'Small Electrical Appliances: Electric food preparation appliances, e.g., toasters, coffee makers, kettles, processors, blenders, electric knives and barbecues? (Exclude gas and charcoal barbecues (see Q.28 and Q.45).)'
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: L_33
      kind: Question
      title: Electric hairstyling and personal care appliances, e.g., dryers, clippers, razors, vaporisers and heating pads? (Exclude butane and other non-electric hairstyling equipment (see Section P, Q.4, page 39).)
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: L_34
      kind: Question
      title: All other electric appliances and equipment, e.g., irons, floor polishers, fans, blankets, can openers, extension cords and portable electric space heaters?
      input:
        control: Editbox
        min: 0
        max: 999999
  - id: b_s13_tools_equipment
    title: Kitchen equipment, tools and other household equipment
    items:
    - id: L_35
      kind: Question
      title: 'Equipment for Serving and Preparing Food: Tableware, flatware and knives? (Exclude disposable tableware.)'
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: L_36
      kind: Question
      title: Non-electric kitchen and cooking equipment, e.g., pots and pans, mixing bowls, chopping boards, canisters, food keepers, spice racks, food choppers and measuring cups? (Exclude knives (see Q.35).)
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: L_37
      kind: Question
      title: 'Lawn, Garden and Snow Removal Tools, Equipment and Accessories (Exclude supplies (see Section M).): Power lawn and garden equipment, e.g., mowers, tractors, tillers and hedge trimmers?'
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: L_38
      kind: Question
      title: Snow blowers?
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: L_39
      kind: Question
      title: Other lawn, garden and snow removal tools and equipment, attachments, accessories and parts purchased separately? (Include non-power lawn mowers, hoses, sprinklers, clippers, shovels, flower pots, stakes, sprayers and spreaders.)
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: L_40
      kind: Question
      title: 'Workshop/Garage Tools and Equipment: Power tools and equipment, e.g., electric drills, circular saws, sanders, jigsaws, motors and pumps?'
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: L_41
      kind: Question
      title: Other tools, e.g., hammers, screwdrivers, measuring tools, tool chests, workbenches, hand saws, soldering irons, scissors, saw blades and drill bits?
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: L_42
      kind: Question
      title: 'Other Household Equipment: Non-electric cleaning equipment, e.g., brooms, mops, dish racks, paint rollers, pails and garbage cans?'
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: L_43
      kind: Question
      title: Luggage, e.g., suitcases, briefcases, trunks, baby carriers?
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: L_44
      kind: Question
      title: Home security equipment, e.g., portable smoke detectors, fire extinguishers, burglar alarms, padlocks, safes and security boxes, and escape ladders? (Exclude security services (see Q.47) and built-in devices (see Section H, page 17).)
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: L_45
      kind: Question
      title: 'Other household equipment, parts and accessories? (Include the following: Measuring equipment, e.g., clocks, timers and non-clinical thermometers. Non-electric laundry equipment, e.g., clothes lines, ironing board covers and laundry baskets. Other items, e.g., calculators, typewriters, drapery hardware, strollers, hangers, fireplace tools, house decorations, ladders, flashlights and charcoal barbecues.)'
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: L_46
      kind: Question
      title: 'Services Related to Household Equipment: Maintenance and repair of household equipment not previously reported? (Exclude major home appliances and home entertainment equipment.)'
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: L_47
      kind: Question
      title: 'Other services related to household furnishings and equipment? (Include the following items: Home security services (including installation). Making of keys and draperies. Installation of stoves, draperies and other non-fixture equipment. Rental of household furnishings, appliances and equipment (excluding home entertainment equipment).)'
      input:
        control: Editbox
        min: 0
        max: 999999
  - id: b_s14_communications
    title: Communications
    items:
    - id: M_1_1
      kind: Question
      title: 'In 2000 how much did your household spend on: Communications: Telephone services? (Include basic and enhanced service charges, long distance charges (net of discounts), equipment rentals, calls from hotels and pay phones, and phone cards.)'
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
    - id: M_1_2
      kind: Question
      title: Cellular services?
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
    - id: M_1_3
      kind: Question
      title: Purchase of equipment, e.g., telephone sets, cellular phones, fax machines and answering machines?
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
    - id: M_1_4
      kind: Question
      title: Internet services (including access and other charges related to the Internet)?
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
    - id: M_1_5
      kind: Question
      title: Other charges, e.g., wiring and installation fees, and repairs? (Include rental of communication equipment not reported elsewhere.)
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
    - id: M_2
      kind: Question
      title: Postage stamps and other postal and communications services? (Include registered mail, special delivery mail, post office boxes, telegrams, couriers, fax services and parcel delivery.)
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
  - id: b_s14_child_care
    title: Child Care Expenses
    items:
    - id: M_3
      kind: Question
      title: 'Child Care Expenses: Day care centres? (Exclude children''s camps, e.g., day camps and summer camps (see Section S, Q.19, page 49).)'
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
    - id: M_4
      kind: Question
      title: Other child care outside the home?
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
    - id: M_5
      kind: Question
      title: Child care in the home?
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
  - id: b_s14_home_garden
    title: Home and Garden Services, Flowers and Garden Supplies
    items:
    - id: M_6
      kind: Question
      title: 'Home and Garden Services: Expenses for domestic help, e.g., housekeepers, cleaners, paid companions and house-sitters? (Exclude child care (see Q.3 to Q.5).)'
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
    - id: M_7
      kind: Question
      title: Horticultural services, snow and garbage removal, e.g., groundskeeping, planting, pruning, tree removal, spraying, consulting services, soil and plant testing, and floral design services?
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
    - id: M_8
      kind: Question
      title: 'Flowers and Garden Supplies: Nursery and greenhouse stock, cut flowers, floral arrangements and decorative plants? (Include shrubs, trees, bulbs, seeds, sod, real Christmas trees, dried arrangements and funeral flowers.)'
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
    - id: M_9
      kind: Question
      title: Fertilizers, weed controls, herbicides, soils and soil conditioners?
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
    - id: M_10
      kind: Question
      title: Insecticides, pesticides and insect repellents?
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
  - id: b_s14_pets
    title: Pet Expenses
    items:
    - id: M_11
      kind: Question
      title: 'Pet Expenses: Pet food? (Include birdseed.)'
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
    - id: M_12
      kind: Question
      title: Pet purchase?
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
    - id: M_13
      kind: Question
      title: Pet related goods, e.g., leashes, litter, collars, aquariums, grooming equipment and doghouses?
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
    - id: M_14
      kind: Question
      title: Veterinarian services and kennels, grooming and other pet related services?
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
  - id: b_s14_cleaning
    title: Cleaning Services
    items:
    - id: M_15
      kind: Question
      title: 'Cleaning Services: Laundry and dry-cleaning services? (Include diaper service.)'
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
    - id: M_16
      kind: Question
      title: Coin-operated washers and dryers, and self-service dry-cleaning?
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
  - id: b_s14_supplies
    title: Household Supplies
    items:
    - id: M_17
      kind: Question
      title: 'Household Supplies: Household cleaning supplies? (Include detergent, cleaners, waxes, bleach, fabric softeners, drain cleaners, oven cleaners and water softener salt.)'
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
    - id: M_18
      kind: Question
      title: Stationery supplies, e.g., giftwrap, greeting cards, writing paper, pens, markers, binders and tape? (Exclude school supplies (see Section S, Q.26 and Q.27, page 50).)
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
    - id: M_19
      kind: Question
      title: Other paper and plastic supplies, e.g., facial tissue, paper towels, waxed paper, napkins, foil and plastic wraps, garbage bags and disposable cutlery?
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
    - id: M_20
      kind: Question
      title: Other household supplies, e.g., light bulbs, dry cell batteries, candles, ice, road salt, adhesives and string?
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
  - id: b_s15_groceries
    title: Food Purchased from Stores
    items:
    - id: N_1
      kind: Question
      title: 'In 2000, how much did your household spend on food and other groceries purchased from stores, farmer stalls and home delivery? (Exclude bulk purchases of food for canning, freezing, etc. (see Q.2.1). Exclude purchases made while away from home overnight or longer (see Q.2.3).) Total Cost $. Give average weekly or monthly expenditure (whichever is convenient) to estimate your annual cost: $ .00 x Number of weeks or months ='
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
    - id: N_1_1
      kind: Question
      title: Of this grocery expenditure, how much did your household spend on non-food items, e.g., paper products, cleaners, pet food, alcoholic beverages and cigarettes?
      postcondition:
      - predicate: N_1_1.outcome <= N_1.outcome
        hint: El gasto en artículos no alimentarios (N.1.1) no puede superar el gasto total en comestibles (N.1)
        invented: true
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
    - id: N_2_1
      kind: Question
      title: 'What additional amounts did your household spend on: Bulk food purchases, e.g., meat in excess of 25 kg (55 lb.) and bulk quantities of produce for freezing? (Include charges for cutting, wrapping and freezing.)'
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
    - id: N_2_2
      kind: Question
      title: Prepared food and non-alcoholic beverages for parties, weddings, etc. not already reported?
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
    - id: N_2_3
      kind: Question
      title: Food and non-alcoholic beverages purchased from stores while away from home overnight or longer?
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
  - id: b_s15_alcohol
    title: Alcohol Purchased from Stores
    items:
    - id: N_3
      kind: Question
      title: 'Alcohol Purchased from Stores: How much did your household spend on alcoholic beverages purchased from stores (e.g., liquor, beer, wine and grocery stores)? (Exclude non-alcoholic beer and wine (see Q.1).)'
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
    - id: N_4
      kind: Question
      title: How much did your household spend on supplies and fees for self-made beer, wine or liquor?
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
  - id: b_s15_restaurants
    title: Food Purchased from Restaurants, etc.
    items:
    - id: N_5
      kind: Question
      title: 'Food Purchased from Restaurants, etc.: How much did your household spend on meals and snacks? (Include purchases in restaurants, drive-ins, cafeterias, take-outs, canteens, etc., and catering in restaurants, hotels, etc. Include taxes, tips and meals bought for guests. Exclude alcoholic beverages (see Q.6).)'
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
    - id: N_5_1
      kind: Question
      title: Of this amount, how much did your household spend in this province? %
      input:
        control: Editbox
        min: 0
        max: 100
        right: '%'
    - id: N_5_1_2
      kind: Question
      title: OR amount spent in this province $
      postcondition:
      - predicate: N_5_1_2.outcome <= N_5.outcome
        hint: El importe gastado en esta provincia (N.5.1) no puede superar el gasto total en comidas y bocadillos (N.5)
        invented: true
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
  - id: b_s16_alcohol_board
    title: Alcoholic Beverages Purchased from Restaurants, etc. / Board (end of Section N)
    items:
    - id: N_6
      kind: Question
      title: How much did your household spend on alcoholic beverages purchased and consumed in bars, cocktail lounges, restaurants, etc.? • Include all taxes and tips. (field 011)
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: N_6_1
      kind: Question
      title: Of this amount, how much did your household spend in this province? (fields 012, 013)
      input:
        control: Editbox
        min: 0
        max: 999999
      postcondition:
      - predicate: N_6_1.outcome <= N_6.outcome
        hint: Spending in this province (Q.6.1) cannot exceed the total spent on alcoholic beverages in bars and restaurants (Q.6).
        invented: true
    - id: N_7_1
      kind: Question
      title: 'How much board did your household pay to other private households: For day board and children''s lunches? • Exclude board paid while away from home overnight or longer (see Q.7.2). • Exclude child care expenses already reported (in Section M). (field 014)'
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: N_7_2
      kind: Question
      title: 'How much board did your household pay to other private households: While away from home overnight or longer? (field 015)'
      input:
        control: Editbox
        min: 0
        max: 999999
  - id: b_s17_women
    title: 'O Clothing: Women and Girls'
    items:
    - id: O_1
      kind: Question
      title: 'In 2000, how much did your household spend on: Clothing, e.g., outerwear, suits, dresses, skirts, slacks, sweaters, sleepwear, sportswear, specialized clothing and hosiery? Exclude footwear and accessories. (Women and Girls 4 Years and Over on December 31, 2000, born before 1997; one column per person: Person 1-5, fields 002, 012, 022, 032, 042)'
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: O_2
      kind: Question
      title: Footwear? (Women and Girls 4 Years and Over; fields 003, 013, 023, 033, 043)
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: O_3
      kind: Question
      title: Accessories, e.g., gloves, hats, mitts, purses and umbrellas? (Women and Girls; fields 004, 014, 024, 034, 044)
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: O_4
      kind: Question
      title: Jewellery and watches? (Women and Girls; fields 005, 015, 025, 035, 045)
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: O_4_BU
      kind: Question
      title: Breakdown Unavailable (Women and Girls; fields 006, 016, 026, 036, 046; used where there is no subtotal of Q.1 to Q.4)
      input:
        control: Editbox
        min: 0
        max: 999999
  - id: b_s17_men
    title: 'O Clothing: Men and Boys'
    items:
    - id: O_5
      kind: Question
      title: Clothing, e.g., outerwear, suits, pants, shirts, sweaters, socks and sportswear? • Exclude footwear and accessories. (Men and Boys 4 Years and Over on December 31, 2000, born before 1997; Person 1-5, fields 052, 062, 072, 082, 092)
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: O_6
      kind: Question
      title: Footwear? (Men and Boys; fields 053, 063, 073, 083, 093)
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: O_7
      kind: Question
      title: Accessories, e.g., gloves, hats, ties, belts, wallets and umbrellas? (Men and Boys; fields 054, 064, 074, 084, 094)
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: O_8
      kind: Question
      title: Jewellery and watches? (Men and Boys; fields 055, 065, 075, 085, 095)
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: O_8_BU
      kind: Question
      title: Breakdown Unavailable (Men and Boys; fields 056, 066, 076, 086, 096; used where there is no subtotal of Q.5 to Q.8)
      input:
        control: Editbox
        min: 0
        max: 999999
  - id: b_s17_children
    title: 'O Clothing: Children Under 4'
    items:
    - id: O_9
      kind: Question
      title: Outerwear, daywear, sleepwear and cloth diapers? (Children Under 4 Years on December 31, 2000, born in 1997 or later; Child 1-4, fields 102, 112, 122, 132)
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: O_10
      kind: Question
      title: Disposable diapers? (Children under 4; fields 103, 113, 123, 133)
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: O_11
      kind: Question
      title: Footwear, e.g., shoes, sandals, boots and slippers? (Children under 4; fields 104, 114, 124, 134)
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: O_11_BU
      kind: Question
      title: Breakdown Unavailable (Children under 4; fields 105, 115, 125, 135; used where there is no subtotal of Q.9 to Q.11)
      input:
        control: Editbox
        min: 0
        max: 999999
  - id: b_s17_gifts_services
    title: 'O Clothing: Gifts, Materials and Services'
    items:
    - id: O_12_1
      kind: Question
      title: 'In 2000, how much did your household spend to purchase gifts of clothing for people who were not members of your household: For women and girls 4 years and over on December 31, 2000? (field 141)'
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: O_12_2
      kind: Question
      title: For men and boys 4 years and over on December 31, 2000? (field 142)
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: O_12_3
      kind: Question
      title: For children under 4 years on December 31, 2000? (field 143)
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: O_13
      kind: Question
      title: Clothing material? Exclude cloth for curtains, draperies and furnishings (see Section L, Q.5, page 26). (field 144)
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: O_14
      kind: Question
      title: Notions, e.g., patterns, buttons, zippers, sewing and knitting needles, and tape measures? (field 145)
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: O_15
      kind: Question
      title: Dressmaking, tailoring, clothing storage and other clothing services, e.g., rental of clothing and costumes, and engraving of jewellery? Exclude repairs and alterations (see Q.16). (field 146)
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: O_16
      kind: Question
      title: Maintenance, repair and alteration of clothing, footwear, watches and jewellery? Exclude laundry and dry-cleaning (see Section M, Q.15 and Q.16, page 33). (field 147)
      input:
        control: Editbox
        min: 0
        max: 999999
  - id: b_s18_personal_care
    title: Personal Care
    items:
    - id: P_1
      kind: Question
      title: 'In 2000, how much did your household spend on: Hair grooming services? • Include washing, cutting, styling, perming and colouring of hair. • Include tips. (field 001)'
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
    - id: P_2
      kind: Question
      title: Other personal services? • Include hair removal, manicures, facials and tanning salons. (field 002)
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
    - id: P_3
      kind: Question
      title: Personal care preparations, e.g., soap, shampoo, makeup, skin cream, perfume, shaving cream, sunscreen and nail polish? (field 003)
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
    - id: P_4
      kind: Question
      title: Personal care supplies and equipment, e.g., brushes, wigs, hair scissors, razors and razor blades? • Include butane hairstyling equipment. • Exclude electric equipment (see Section L, Q.33, page 29). (field 004)
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
  - id: b_s18_premiums
    title: Health Insurance Premiums
    items:
    - id: P_5_1
      kind: Question
      title: 'In 2000, how much did your household spend on premiums for: Provincially or Territorially administered hospital, medical and drug plans? (field 005)'
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
    - id: P_5_2
      kind: Question
      title: Private health insurance plans? • Include supplementary coverage to public hospital and medical plans (e.g., semi-private or private bed differential and drugs), extended health benefit packages, drug plans, out-of-country benefits and visitors' benefits. (field 006)
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
    - id: P_5_3
      kind: Question
      title: Dental plans (sold as separate policies)? (field 007)
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
    - id: P_5_4
      kind: Question
      title: Accident and disability insurance? (field 008)
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
  - id: b_s18_direct_costs
    title: Direct Costs for Health Care
    items:
    - id: P_6
      kind: Question
      title: 'In 2000, what were the direct costs to members of your household for: Eye Care: Prescription eye wear, e.g., contact lenses, eyeglasses and insurance on lenses? • Include direct costs incurred by household members for all personal health care received. • Include amounts not covered by insurance such as exclusions, deductibles and expenses over limits. • Exclude payments for which you have been or will be reimbursed. (field 009)'
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
    - id: P_7
      kind: Question
      title: Other eye care goods, e.g., non-prescription eye wear, eyeglass cases and supplies for contact lenses? (field 010)
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
    - id: P_8
      kind: Question
      title: Eye exams, eye surgery (e.g., laser surgery), and other eye care services? (field 011)
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
    - id: P_9
      kind: Question
      title: 'Dental Care: Dental services and orthodontic and periodontal procedures, e.g., examinations, cleanings, fillings, extractions, x-rays, root canals, and the prescription and fitting of dentures? (field 012)'
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
    - id: P_10
      kind: Question
      title: 'Other Medical and Health Care: Physicians'' care? • Include general practitioners and specialists. (field 013)'
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
    - id: P_11
      kind: Question
      title: Other health care practitioners, e.g., nurses, therapists, chiropractors, osteopaths and podiatrists? (field 014)
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
    - id: P_12
      kind: Question
      title: Hospital care (all direct pay charges included in hospital bill)? (field 015)
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
    - id: P_13
      kind: Question
      title: Weight control programs, quit-smoking programs and other medical services, e.g., ambulances, rental of medical equipment, laboratory services and nursing homes? (field 016)
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
    - id: P_14
      kind: Question
      title: Medicines, drugs and pharmaceutical products prescribed by a doctor? (field 017)
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
    - id: P_15
      kind: Question
      title: Other medicines, drugs and pharmaceutical products, e.g., headache or pain remedies, herbal and homeopathic remedies, and vitamins? (field 018)
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
    - id: P_16
      kind: Question
      title: Health care supplies and goods, e.g., first aid kits, bandages, hearing aids, thermometers, wheelchairs and other appliances, bathroom scales and elastic hosiery? (field 019)
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
  - id: b_s19_screen
    title: Q Automobiles and Trucks
    items:
    - id: Q_1
      kind: Question
      title: In 2000, did anyone in your household own, lease or operate a car, van or truck and use it completely or partially for private use? Exclude rented vehicles (see Q.20). (field 001)
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
  - id: b_s19_vehicle
    title: Vehicle ownership, purchase and status (Vehicle A-D)
    precondition:
    - predicate: Q_1.outcome == 1
      hint: Asked only when question Q-1 is "Yes".
    - predicate: not (Q_1.outcome == 2)
      hint: Asked only when question Q-1 is not "No".
    items:
    - id: Q_2
      kind: Question
      title: Which of the following best describes this vehicle? (Ask Q.2 to Q.9 for all vehicles before asking Q.10; Vehicle A-D, fields 012, 062, 112, 162)
      input:
        control: Radio
        labels:
          1: Car
          2: Van/mini-van
          3: Truck/sport utility vehicle
    - id: Q_3
      kind: Question
      title: When you bought or leased this vehicle, was it new or used? (Vehicle A-D, fields 013, 063, 113, 163)
      input:
        control: Radio
        labels:
          4: New
          5: Used
    - id: Q_4
      kind: Question
      title: Did you buy this vehicle in 2000? (Vehicle A-D, fields 014, 064, 114, 164)
      input:
        control: Radio
        labels:
          6: 'Yes'
          7: 'No'
    - id: Q_5
      kind: Question
      title: What was the purchase price after the trade-in allowance was deducted? • Include all sales taxes. (Vehicle A-D, fields 015, 065, 115, 165)
      precondition:
      - predicate: Q_1.outcome == 1 and Q_4.outcome == 6
      - predicate: not (Q_4.outcome == 7)
        hint: Asked only when question Q-4 is not "No".
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: Q_6
      kind: Question
      title: Was this vehicle leased in 2000? (Vehicle A-D, fields 016, 066, 116, 166)
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: Q_6_1
      kind: Question
      title: What was the total leasing cost paid in 2000? • Include down payment. • Exclude operating costs and any amount charged to business. (Vehicle A-D, fields 017, 067, 117, 167)
      precondition:
      - predicate: Q_1.outcome == 1 and Q_6.outcome == 1
      - predicate: not (Q_6.outcome == 2)
        hint: Asked only when question Q-6 is not "No".
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: Q_7
      kind: Question
      title: What was the status of this vehicle at December 31, 2000? (Vehicle A-D, fields 018, 068, 118, 168)
      input:
        control: Radio
        labels:
          1: Owned (Go to Q.10)
          2: Leased (Go to Q.10)
          3: Returned to lessor (Go to Q.10)
          4: Sold separately or traded-in on lease (Go to Q.8)
          5: Traded-in on purchase (Go to Q.9)
          6: Owned/leased by non-household member (Go to Q.10)
          7: Other
    - id: Q_7_specify
      kind: Question
      title: Other - Specify (Q.7 code 7; field 019, 069, 119, 169)
      precondition:
      - predicate: Q_7.outcome == 7
        hint: Asked only when question Q-7 is "Other".
      - predicate: not (Q_7.outcome in [1, 2, 3, 6])
        hint: Asked only when question Q-7 is none of "Owned (Go to Q.10)", "Leased (Go to Q.10)", "Returned to lessor (Go to Q.10)", "Owned/leased by non-household member (Go to Q.10)".
      - predicate: not (Q_7.outcome == 4)
        hint: Asked only when question Q-7 is not "Sold separately or traded-in on lease (Go to Q.8)".
      - predicate: not (Q_7.outcome == 5)
        hint: Asked only when question Q-7 is not "Traded-in on purchase (Go to Q.9)".
      input:
        control: Textarea
    - id: Q_8
      kind: Question
      title: If sold separately or traded-in on lease, what was the net amount received? • Exclude any amount paid to business. (Vehicle A-D, fields 020, 070, 120, 170)
      precondition:
      - predicate: Q_7.outcome == 4
        hint: Asked only when question Q-7 is "Sold separately or traded-in on lease (Go to Q.8)".
      - predicate: not (Q_7.outcome in [1, 2, 3, 6])
        hint: Asked only when question Q-7 is none of "Owned (Go to Q.10)", "Leased (Go to Q.10)", "Returned to lessor (Go to Q.10)", "Owned/leased by non-household member (Go to Q.10)".
      - predicate: not (Q_7.outcome == 5)
        hint: Asked only when question Q-7 is not "Traded-in on purchase (Go to Q.9)".
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: Q_9
      kind: Question
      title: If traded-in on purchase, what was the vehicle's trade-in value? (Vehicle A-D, fields 021, 071, 121, 171)
      precondition:
      - predicate: Q_7.outcome == 5
        hint: Asked only when question Q-7 is "Traded-in on purchase (Go to Q.9)".
      - predicate: not (Q_7.outcome in [1, 2, 3, 6])
        hint: Asked only when question Q-7 is none of "Owned (Go to Q.10)", "Leased (Go to Q.10)", "Returned to lessor (Go to Q.10)", "Owned/leased by non-household member (Go to Q.10)".
      input:
        control: Editbox
        min: 0
        max: 9999999
  - id: b_s19_operating
    title: Operating expenses (Vehicle A-D)
    precondition:
    - predicate: not (Q_1.outcome == 2)
      hint: Asked only when question Q-1 is not "No".
    items:
    - id: Q_10
      kind: Question
      title: 'In 2000, how much did your household spend on the following operating expenses (include family and business use; the respondent may combine expenses for two or more vehicles): Gas and other fuels, e.g., diesel fuel and propane? (Vehicle A-D, fields 022, 072, 122, 172)'
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: Q_11
      kind: Question
      title: Accessories and attachments, e.g., radios, CD players, block and other heaters, baby seats, car top carriers and seat covers? (fields 023, 073, 123, 173)
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: Q_12
      kind: Question
      title: Tires, batteries and other automotive parts and supplies purchased separately, e.g., mufflers, spark plugs, oil and antifreeze? (fields 024, 074, 124, 174)
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: Q_13
      kind: Question
      title: Other maintenance and repair expenses, e.g., oil changes, tune-ups, brakes and body work? • Include repairs to other parties' vehicles which were paid by household members. • Exclude amounts paid by insurance or by persons who were not members of your household. (fields 025, 075, 125, 175)
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: Q_14
      kind: Question
      title: Vehicle registration fees? • Include insurance that is paid with registration fees. (fields 026, 076, 126, 176)
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: Q_15
      kind: Question
      title: Vehicle insurance premiums? • Exclude insurance that is paid with registration fees (see Q.14). (fields 027, 077, 127, 177)
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: Q_16
      kind: Question
      title: Parking costs, e.g., at work, at school, park-ride and parking meters? • Exclude parking at place of residence (which should be reported elsewhere). (fields 028, 078, 128, 178)
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: Q_17
      kind: Question
      title: Other operation services, e.g., auto association fees, towing, and toll and bridge fees? (fields 029, 079, 129, 179)
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: Q_18
      kind: Question
      title: What amount or percentage of the total operating expenses (Q.10 to Q.17) was charged to business or reimbursed? Amount ($). • Exclude leasing fees charged to business (because they were not asked for in Q.10 to Q.17). (Vehicle A-D, fields 030, 080, 130, 180)
      postcondition:
      - predicate: Q_18.outcome <= Q_10.outcome + Q_11.outcome + Q_12.outcome + Q_13.outcome + Q_14.outcome + Q_15.outcome + Q_16.outcome + Q_17.outcome
        hint: The amount charged to business or reimbursed (Q.18) cannot exceed the total operating expenses (Q.10 to Q.17).
        invented: true
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: Q_18_pct
      kind: Question
      title: OR percentage (___ %) of the total operating expenses (Q.10 to Q.17) charged to business or reimbursed (alternative to the Q.18 amount; fields 031*, 081*, 131*, 181*)
      postcondition:
      - predicate: not (Q_18.outcome > 0 and Q_18_pct.outcome > 0)
        hint: Report either an amount (Q.18) or a percentage (Q.18 OR %), not both.
        invented: true
      input:
        control: Editbox
        min: 0
        max: 100
        right: '%'
    - id: Q_19
      kind: Question
      title: What was the value of repair jobs which were covered by insurance and not paid by this household? (If an insurance settlement was received in 2000 but no repairs were done, please see the manual.) (Vehicle A-D, fields 032, 082, 132, 182)
      input:
        control: Editbox
        min: 0
        max: 9999999
  - id: b_s19_rented
    title: Expenditures for Rented Vehicles
    items:
    - id: Q_20_1a
      kind: Question
      title: 'Expenditures for Rented Vehicles (exclude any expenses charged to business). In 2000, how much did your household spend on: 20.1 Rented cars? — Rental Fees (including mileage, insurance charges, taxes and drop-off fees) (field 201)'
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: Q_20_1b
      kind: Question
      title: 20.1 Rented cars? — Gas and Other Fuels (field 202)
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: Q_20_1c
      kind: Question
      title: 20.1 Rented cars? — Other Expenses, e.g., toll fees, parking, and repairs (field 203)
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: Q_20_2a
      kind: Question
      title: 20.2 Rented trucks or vans? — Rental Fees (including mileage, insurance charges, taxes and drop-off fees) (field 204)
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: Q_20_2b
      kind: Question
      title: 20.2 Rented trucks or vans? — Gas and Other Fuels (field 205)
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: Q_20_2c
      kind: Question
      title: 20.2 Rented trucks or vans? — Other Expenses, e.g., toll fees, parking, and repairs (field 206)
      input:
        control: Editbox
        min: 0
        max: 9999999
  - id: b_s19_misc
    title: Miscellaneous Vehicle Expenses
    items:
    - id: Q_21
      kind: Question
      title: 'Miscellaneous Vehicle Expenses. In 2000, how much did your household spend on: Drivers'' licences and tests? • Report government insurance if included. (field 301)'
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: Q_22
      kind: Question
      title: Driving lessons? (field 302)
      input:
        control: Editbox
        min: 0
        max: 9999999
  - id: b_s20_bicycles
    title: Bicycles and Recreational Vehicle Ownership
    items:
    - id: R_1
      kind: Question
      title: 'In 2000, how much did your household spend on: Purchase of bicycles, parts and accessories? • Exclude children''s bicycles with wheels under 14 inches (see Section S, Q.9, page 48). (field 001)'
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
    - id: R_2
      kind: Question
      title: Bicycle maintenance and repairs? (field 002)
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
    - id: R_3
      kind: Question
      title: In 2000, did anyone in your household own or operate any of the following (1 Motorcycle, 2 Snowmobile, 3 Tent trailer, 4 Travel trailer, 5 Truck camper, 6 Boat or canoe, 7 Outboard motor, personal water craft, 8 Motor home, 9 Other, e.g., utility trailer, aircraft and all-terrain vehicles) and use it completely or partially for private use? • Exclude rented or leased vehicles (see Q.14). (field 003)
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
  - id: b_s20_vehicles
    title: Owned Recreational Vehicles
    precondition:
    - predicate: R_3.outcome == 1
      hint: Asked only when question R-3 is "Yes".
    - predicate: not (R_3.outcome == 2)
      hint: Asked only when question R-3 is not "No".
    items:
    - id: R_4
      kind: Question
      title: Type of vehicle? (Enter code from Q.3; Vehicle A-D, fields 012, 032, 052, 072)
      input:
        control: Dropdown
        labels:
          1: Motorcycle
          2: Snowmobile
          3: Tent trailer
          4: Travel trailer
          5: Truck camper
          6: Boat or canoe
          7: Outboard motor, personal water craft
          8: Motor home
          9: Other, e.g., utility trailer, aircraft and all-terrain vehicles
    - id: R_4_1
      kind: Question
      title: 'If code 9, specify vehicle type: (fields 013, 033, 053, 073)'
      precondition:
      - predicate: R_4.outcome == 9
        hint: Asked only when the vehicle type is code 9 (Other).
      input:
        control: Textarea
    - id: R_5
      kind: Question
      title: If purchased in 2000, what was the price after the trade-in allowance was deducted? • Include all sales taxes. (Vehicle A-D, fields 014, 034, 054, 074)
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
    - id: R_6
      kind: Question
      title: 'In 2000, how much did your household spend on the following operating expenses (the respondent may combine expenses for two or more vehicles): Accessories, attachments, supplies and parts purchased separately for maintenance and repair? (fields 015, 035, 055, 075)'
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
    - id: R_7
      kind: Question
      title: Gasoline, diesel fuel, etc.? Exclude fuels for cooking, heating, etc. (see Section S, Q.12, page 49). (fields 016, 036, 056, 076)
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
    - id: R_8
      kind: Question
      title: Maintenance and repair jobs not covered by insurance? (fields 017, 037, 057, 077)
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
    - id: R_9
      kind: Question
      title: Vehicle insurance premiums paid for in 2000? (fields 018, 038, 058, 078)
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
    - id: R_10
      kind: Question
      title: Registration fees and licences paid for in 2000? (fields 019, 039, 059, 079)
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
    - id: R_11
      kind: Question
      title: Other expenses, e.g., parking, hangar and airport fees, mooring and boat storage, and harbour dues? (fields 020, 040, 060, 080)
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
    - id: R_12
      kind: Question
      title: What amount or percentage of the total operating expenses (Q.6 to Q.11) was charged to business? Amount ($). (Vehicle A-D, fields 021, 041, 061, 081)
      postcondition:
      - predicate: R_12.outcome <= R_6.outcome + R_7.outcome + R_8.outcome + R_9.outcome + R_10.outcome + R_11.outcome
        hint: The amount charged to business (Q.12) cannot exceed the total operating expenses (Q.6 to Q.11).
        invented: true
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
    - id: R_12_pct
      kind: Question
      title: OR percentage (___ %) of the total operating expenses (Q.6 to Q.11) charged to business (alternative to the Q.12 amount; fields 022*, 042*, 062*, 082*)
      postcondition:
      - predicate: not (R_12.outcome > 0 and R_12_pct.outcome > 0)
        hint: Report either an amount (Q.12) or a percentage (Q.12 OR %), not both.
        invented: true
      input:
        control: Editbox
        min: 0
        max: 100
        right: '%'
    - id: R_13
      kind: Question
      title: If sold separately (not traded-in) in 2000, what was the net amount received? (Vehicle A-D, fields 023, 043, 063, 083)
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
  - id: b_s20_transport
    title: Rentals, Transportation Services, Moving and Package Trips
    items:
    - id: R_14
      kind: Question
      title: In 2000, how much were your household's total expenses for rented or leased recreational vehicles? (field 091)
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
    - id: R_15_1
      kind: Question
      title: 'In 2000, how much did your household spend on transportation by: City or commuter bus, subway, streetcar or commuter train? • Exclude expenses charged to business. • Exclude deposits made in 2000 on package trips to be taken after 2000 (see Section W, Q.1.3, page 57). (field 092)'
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
    - id: R_15_2
      kind: Question
      title: Taxi (including tips)? (field 093)
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
    - id: R_15_3
      kind: Question
      title: Airplane? (field 094)
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
    - id: R_15_4
      kind: Question
      title: Train (including sleeping car)? (field 095)
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
    - id: R_15_5
      kind: Question
      title: Highway bus? (field 096)
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
    - id: R_15_6
      kind: Question
      title: Other passenger transportation, e.g., carpooling, airport bus or limousine service, ferry service, sightseeing tours and travel insurance? (field 097)
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
    - id: R_16
      kind: Question
      title: In 2000, how much did your household spend on household moving, storage services and delivery services? (field 098)
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
    - id: R_17
      kind: Question
      title: 'Package Trips: In 2000, did any member of your household take a trip that included a package? NOTE: The package must have been arranged in advance. The cost of two or more components of the trip must have been combined, e.g., transportation and accommodation, or accommodation with food and beverages. (field 099)'
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: R_17_1
      kind: Question
      title: What was the cost of the package trips taken by your household in 2000? • Exclude package trips (see Q.17). (field 100)
      precondition:
      - predicate: R_17.outcome == 1
        hint: Asked only when question R-17 is "Yes".
      - predicate: not (R_17.outcome == 2)
        hint: Asked only when question R-17 is not "No".
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
  - id: b_s21_recreation_equipment
    title: Recreation Equipment
    items:
    - id: S_1
      kind: Question
      title: 'In 2000, how much did your household spend on: Sports and athletic equipment? • Include equipment for golf, racquet sports, ice skating, skiing, fishing, home exercise and other sporting and athletic equipment and accessories. • Exclude athletic/running shoes (see Section O - Clothing). (field 001)'
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: S_2
      kind: Question
      title: Camping and picnic equipment and accessories, e.g., tents, backpacks, sleeping bags, camp stoves, lanterns, coolers, mattresses and utensils? • Include attachments and parts. • Exclude rentals (see Q.14, page 49). • Exclude gas, electric and charcoal barbecues (see Section L, Q.28, Q.32 and Q.45, pages 29 and 30). (field 002)
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: S_3
      kind: Question
      title: Cameras, camera parts, attachments, accessories and other photographic goods, e.g., lenses, tripods, projectors, albums and darkroom supplies? • Exclude purchases of VCRs, camcorders and videos (see Section L, Q.10 and Q.11, page 27). • Exclude rental of videos (see Section L, Q.17, page 28). (field 003)
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: S_4
      kind: Question
      title: Photographic film, processing, extra prints and enlargements? (field 004)
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: S_5
      kind: Question
      title: Photographers' services and other photographic services, e.g., passport photos and school pictures? (field 005)
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: S_6
      kind: Question
      title: Musical instruments, parts and accessories, e.g., pianos and guitars? (field 006)
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: S_7
      kind: Question
      title: Artists' materials and handicraft or hobbycraft kits and materials? • Exclude school supplies (see Q.26 and Q.27, page 50). (field 007)
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: S_8
      kind: Question
      title: Electronic games and parts, e.g., video game machines, plug-in cartridges and games on tape or disk? (field 008)
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: S_9
      kind: Question
      title: Toys and other games? • Include children's vehicles and bicycles with wheels under 14 inches. (field 009)
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: S_10
      kind: Question
      title: Playground equipment, above-ground swimming pools and accessories for swimming pools, e.g., swings, slides, pool covers, vacuum heads and wading pools? • Exclude pool chemicals (see Q.12). (field 011)
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: S_10_specify
      kind: Question
      title: Specify (text field 010 belonging to Q.10)
      input:
        control: Textarea
  - id: b_s22_admissions
    title: 'Recreation Services: Admissions'
    items:
    - id: S_15_1
      kind: Question
      title: 'In 2000, how much did your household spend on admissions to: Movie theatres?'
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
    - id: S_15_2
      kind: Question
      title: Live performing arts, e.g., plays, concerts, festivals and dance performances?
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
    - id: S_15_3
      kind: Question
      title: Heritage facilities and other activities and venues, e.g., museums, zoos, ice shows, craft shows, fairs and historic sites?
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
    - id: S_15_4
      kind: Question
      title: Live sports events?
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
  - id: b_s22_fees_services
    title: 'Recreation Services: Fees and Services'
    items:
    - id: S_16
      kind: Question
      title: 'In 2000, how much did your household spend on: Fees for coin-operated and carnival games, e.g., pinball and video games? • Exclude gambling machines (see Section T, Q.4.4, page 51).'
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
    - id: S_17
      kind: Question
      title: Membership fees and dues for sports activities, sports and recreation facilities, and health clubs?
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
    - id: S_18
      kind: Question
      title: Single usage fees for sports activities, sports and recreation facilities, and health clubs?
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
    - id: S_19
      kind: Question
      title: Children's camps, e.g., day camps and summer camps?
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
    - id: S_20
      kind: Question
      title: Other cultural and recreational services, e.g., fishing and hunting licenses and guide service, party planning and other rental of sports facilities?
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
  - id: b_s22_equipment
    title: 'Recreation Services: Collectors'' Items and Equipment'
    items:
    - id: S_11
      kind: Question
      title: Collectors' items, e.g., stamps and coins? • Exclude works of art and antiques (see Section L, Q.6 and Q.7, page 26).
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
    - id: S_12
      kind: Question
      title: Parts and supplies for recreation equipment, e.g., camp fuels, ski wax, pool chemicals, ammunition and bait?
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
    - id: S_13
      kind: Question
      title: Rental of video games, e.g., plug-in cartridges and games on disk?
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
    - id: S_14
      kind: Question
      title: Rental, maintenance and repair of recreation, sports and health equipment?
      input:
        control: Editbox
        min: 0
        max: 9999999
        left: $
  - id: b_s23_printed_matter
    title: Reading Materials and Other Printed Matter
    items:
    - id: S_21
      kind: Question
      title: Newspapers?
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: S_22
      kind: Question
      title: Magazines and periodicals?
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: S_23
      kind: Question
      title: Books and pamphlets? • Exclude school books (see Q.26 and Q.27).
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: S_24
      kind: Question
      title: Maps, sheet music and other printed matter, e.g., posters, globes and charts?
      input:
        control: Editbox
        min: 0
        max: 999999
    - id: S_25
      kind: Question
      title: Services, e.g., duplicating services, library charges, book rentals, bookbinding, advertisements and announcements?
      input:
        control: Editbox
        min: 0
        max: 999999
  - id: b_s24_education
    title: Education
    items:
    - id: c_s24_intro
      kind: Comment
      title: Household spending in 2000 on education (include special and private schools; exclude day care).
    - id: S_26_1
      kind: Question
      title: Kindergarten, nursery school, and elementary and secondary education? — Tuition Fees
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
    - id: S_26_2
      kind: Question
      title: Kindergarten, nursery school, and elementary and secondary education? — Books
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
    - id: S_26_3
      kind: Question
      title: Kindergarten, nursery school, and elementary and secondary education? — Supplies
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
    - id: S_27_1
      kind: Question
      title: Post-secondary education, e.g., university, trade and professional courses? — Tuition Fees
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
    - id: S_27_2
      kind: Question
      title: Post-secondary education, e.g., university, trade and professional courses? — Books
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
    - id: S_27_3
      kind: Question
      title: Post-secondary education, e.g., university, trade and professional courses? — Supplies
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
    - id: S_28
      kind: Question
      title: Other courses and lessons, e.g., music, dancing, sports and crafts? • Exclude driving lessons (see Section Q, Q. 22, page 44).
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
    - id: S_29
      kind: Question
      title: Other educational services, e.g., rental of school books and equipment?
      input:
        control: Editbox
        min: 0
        max: 999999
        left: $
    - id: S_29_specify
      kind: Question
      title: Specify (other educational services)
      input:
        control: Textarea
  - id: b_s25_misc_expenses
    title: Miscellaneous Expenses
    items:
    - id: T_1
      kind: Question
      title: 'In 2000, how much did your household spend on: Cigarettes, tobacco, cigars and similar products?'
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: T_2
      kind: Question
      title: Smokers' supplies, e.g., matches, pipes, lighters, ashtrays, cigarette papers and tubes?
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: T_3_1
      kind: Question
      title: 'In 2000, how much did your household spend on the following financial services: Service charges for banks and other financial institutions?'
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: T_3_2
      kind: Question
      title: Stock and bond commissions?
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: T_3_3
      kind: Question
      title: Administration fees for brokers and others?
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: T_3_4
      kind: Question
      title: Other financial services, e.g., financial planning, tax preparation and advice, accounting services and safety deposit box charges?
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: T_4_1
      kind: Question
      title: 'In 2000, how much were your household''s expenses and winnings from the following: Government-run lotteries? — Expenses'
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: T_4_1W
      kind: Question
      title: Government-run lotteries? — Winnings
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: T_4_2
      kind: Question
      title: Bingos? — Expenses
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: T_4_2W
      kind: Question
      title: Bingos? — Winnings
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: T_4_3
      kind: Question
      title: Non-government lotteries, raffle tickets and other games of chance? — Expenses
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: T_4_3W
      kind: Question
      title: Non-government lotteries, raffle tickets and other games of chance? — Winnings
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: T_4_4
      kind: Question
      title: Casinos, slot machines and video lottery terminals? — Expenses
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: T_4_4W
      kind: Question
      title: Casinos, slot machines and video lottery terminals? — Winnings
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: T_5
      kind: Question
      title: 'In 2000, what expenses did your household have for: Loss of deposits, fines, and money lost or stolen?'
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: T_6
      kind: Question
      title: Contributions and dues for social clubs, co-operatives, political and fraternal organizations and alumni associations? • Exclude charitable organizations (see Section V, Q.13, page 56).
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: T_7
      kind: Question
      title: Tools and equipment purchased for work (by wage or salaried workers)? • Exclude items reported previously.
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: T_8
      kind: Question
      title: Legal services not related to dwellings? • Exclude legal services related to house purchase, sale, etc. (see Section F, Q.3, page 15).
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: T_9
      kind: Question
      title: What other expenses did you have for goods?
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: T_9_specify
      kind: Question
      title: Specify (other expenses for goods). If an expense that belongs elsewhere is reported in question 9 or 10, please move it to the appropriate category when editing the questionnaire.
      input:
        control: Textarea
    - id: T_10
      kind: Question
      title: What other expenses did you have for services, e.g. passports, funeral services and rental of halls?
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: T_10_specify
      kind: Question
      title: Specify (other expenses for services)
      input:
        control: Textarea
    - id: T_11
      kind: Question
      title: In 2000, did your household purchase any goods through direct sales, e.g., door-to-door sales people, factory outlets, mail order companies, catalogue sales, book clubs and the Internet? (Tell the respondent that the following questions are asked to obtain details on how purchases were made by the household in 2000.)
      input:
        control: Radio
        labels:
          1: 01 Yes
          2: 02 No
  - id: s25_direct_sales
    title: Direct Sales Purchases
    precondition:
    - predicate: T_11.outcome == 1
      hint: Asked only when question T.11 is "01 Yes".
    - predicate: not (T_11.outcome == 2)
      hint: Asked only when question T.11 is not "02 No".
    items:
    - id: T_11_1_1
      kind: Question
      title: Did your household purchase the following goods through direct sales? Food and beverages
      input:
        control: Radio
        labels:
          1: 03 Yes
          2: 04 No
    - id: T_11_1_2
      kind: Question
      title: Books, newspapers and magazines
      input:
        control: Radio
        labels:
          1: 05 Yes
          2: 06 No
    - id: T_11_1_3
      kind: Question
      title: Clothing, cosmetics and jewellery
      input:
        control: Radio
        labels:
          1: 07 Yes
          2: 08 No
    - id: T_11_1_4
      kind: Question
      title: Home entertainment products, e.g., CD's, audio equipment and computers
      input:
        control: Radio
        labels:
          1: 09 Yes
          2: 10 No
    - id: T_11_1_5
      kind: Question
      title: Other products used inside the home, e.g., appliances, cleaners, toys and crafts
      input:
        control: Radio
        labels:
          1: 11 Yes
          2: 12 No
    - id: T_11_1_6
      kind: Question
      title: Other products used outside the home, e.g., greenhouse and nursery products
      input:
        control: Radio
        labels:
          1: 13 Yes
          2: 14 No
    - id: T_11_2
      kind: Question
      title: In 2000, how much did your household spend on goods purchased through direct sales?
      postcondition:
      - predicate: (T_11_1_1.outcome + T_11_1_2.outcome + T_11_1_3.outcome + T_11_1_4.outcome + T_11_1_5.outcome + T_11_1_6.outcome == 12) or T_11_2.outcome > 0
        hint: 'Si des achats par vente directe ont été déclarés en T.11.1.1 à T.11.1.6, indiquez le montant dépensé en T.11.2 (en anglais: if any direct-sales category in Q.11.1 is Yes, Q.11.2 must be greater than 0).'
        invented: true
      input:
        control: Editbox
        min: 0
        max: 9999999
  - id: s25_outside_canada
    title: Purchases Outside Canada
    items:
    - id: T_12
      kind: Question
      title: In 2000, how much did your household spend on goods and services purchased outside Canada?
      input:
        control: Editbox
        min: 0
        max: 9999999
  - id: b_s26_personal_income
    title: Personal Income
    items:
    - id: U_1_1
      kind: Question
      title: 'For how many weeks in 2000 did this member work: 1.1 full-time, including holidays with pay?'
      input:
        control: Editbox
        min: 0
        max: 52
    - id: U_1_2
      kind: Question
      title: 1.2 part-time, including holidays with pay?
      postcondition:
      - predicate: U_1_1.outcome + U_1_2.outcome <= 52
        hint: Les semaines à temps plein (U.1.1) plus les semaines à temps partiel (U.1.2) ne peuvent pas dépasser 52 (full-time plus part-time weeks cannot exceed 52).
        invented: true
      input:
        control: Editbox
        min: 0
        max: 52
    - id: U_2
      kind: Question
      title: Wages and Salaries before deductions, including bonuses, tips, commissions, and military pay and allowances
      input:
        control: Editbox
        min: -9999999
        max: 9999999
    - id: U_3
      kind: Question
      title: NET Income from Farm and Non-farm Self-employment
      input:
        control: Editbox
        min: -9999999
        max: 9999999
    - id: U_4_1
      kind: Question
      title: 'GROSS Income from Roomers and Boarders who were: 4.1 household members (non-relatives)'
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: U_4_2
      kind: Question
      title: 4.2 not members of your household
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: U_5
      kind: Question
      title: Dividends; Interest on bonds, accounts and GICs; and Other Investment Income, e.g., net rental income and interest received from loans or mortgages
      input:
        control: Editbox
        min: -9999999
        max: 9999999
    - id: U_6
      kind: Question
      title: Child Tax Benefit (including Quebec Family Allowance)
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: U_7
      kind: Question
      title: Old Age Security Pension, Guaranteed Income Supplement, Spouse's Allowance from federal government only • Exclude provincial supplements (see Q.12).
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: U_8
      kind: Question
      title: Canada or Quebec Pension Plan Benefits
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: U_9
      kind: Question
      title: Employment Insurance Benefits (before deductions)
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: U_10
      kind: Question
      title: Goods and Services Tax Credit (received in 2000)
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: U_11
      kind: Question
      title: Provincial Tax Credits, including Quebec Real Estate Tax Refund (claimed on 1999 income tax returns)
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: U_12
      kind: Question
      title: Social Assistance, Provincial Income Supplements, Workers' Compensation Benefits, Veterans' Pensions Civilian War Pensions and Allowances, and Other Income from Government Sources
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: U_12_specify
      kind: Question
      title: Specify (Q.12, code 251)
      input:
        control: Textarea
    - id: U_13
      kind: Question
      title: Retirement Pensions, Superannuation, Annuities and RRIF Withdrawals • Exclude RRSP withdrawals (see Section W, Q.2, page 57).
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: U_14
      kind: Question
      title: Personal Income Tax Refunds
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: U_15
      kind: Question
      title: Other Money Income, e.g., alimony, separation allowance, child support, retirement allowances, severance pay, income maintenance plan payments, scholarships, bursaries and income from outside Canada
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: U_15_specify
      kind: Question
      title: Specify (Q.15, code 252)
      input:
        control: Textarea
    - id: U_16
      kind: Question
      title: Other Money Receipts, e.g., money gifts received from persons outside your household, cash inheritances and life insurance settlements
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: U_16_specify
      kind: Question
      title: Specify (Q.16, code 253)
      input:
        control: Textarea
    - id: U_BU
      kind: Question
      title: Breakdown Unavailable (used where there is no subtotal; subtotal is Q.2 to Q.16, excluding Q.4.1 and Q.11)
      input:
        control: Editbox
        min: 0
        max: 9999999
  - id: b_s27_taxes_gifts
    title: Personal Taxes, Security and Money Gifts
    items:
    - id: V_1
      kind: Question
      title: 'In 2000, how much did each member pay for: Personal Taxes — 1. Income tax on 2000 income? • Exclude taxes paid in 2001 on 2000 income.'
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: V_2
      kind: Question
      title: Income tax on income for years prior to 2000? • Include taxes paid in 2000 on income earned in 1999 or earlier.
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: V_3
      kind: Question
      title: Other personal taxes, e.g., gift tax?
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: V_3_specify
      kind: Question
      title: Specify (Q.3, code 251)
      input:
        control: Textarea
    - id: V_4
      kind: Question
      title: 'Security and Employment-related Payments (Exclude RRSP contributions, see Section W, Q.2, page 57): Premiums on life, term and endowment insurance? • Include loan and group insurance. • Report premiums for persons 14 years or under (born after 1985) by the household member paying the premiums.'
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: V_5
      kind: Question
      title: Annuity contracts and transfers to RRIFs?
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: V_6
      kind: Question
      title: Employment insurance (deductions from pay)?
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: V_7
      kind: Question
      title: Government retirement or pension fund, including federal, provincial and municipal government funds?
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: V_8
      kind: Question
      title: Canada/Quebec pension plan?
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: V_9
      kind: Question
      title: Other retirement or pension funds?
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: V_10
      kind: Question
      title: Dues to unions and professional associations?
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: V_11
      kind: Question
      title: In 2000, how much did each member pay for support payments to a former spouse or partner? • Include alimony, separation allowance or child support.
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: V_12_1
      kind: Question
      title: 'In 2000, how much did each member spend on money gifts, contribution and other support payments to persons who were not household members (do not include amounts already reported in Q11): 12.1 Money given to persons living in Canada?'
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: V_12_2
      kind: Question
      title: 12.2 Money given to persons living outside Canada?
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: V_13_1
      kind: Question
      title: 'In 2000, how much did each member spend on charitable contributions to: 13.1 Religious organizations?'
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: V_13_2
      kind: Question
      title: 13.2 Other charitable organizations, e.g., the United Way, heart fund?
      input:
        control: Editbox
        min: 0
        max: 9999999
  - id: b_s28_assets
    title: 'Section W: Changes in Assets'
    items:
    - id: W_1_1a
      kind: Question
      title: 'In 2000, what was the NET CHANGE (increase or decrease) in the following household assets: 1.1 Cash held in accounts in banks and trust and loan companies, and cash on hand? Include GICs. Exclude RRSPs (see Q.2). — net increase'
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: W_1_1b
      kind: Question
      title: 1.1 Cash held in accounts ... — net decrease
      postcondition:
      - predicate: not (W_1_1a.outcome > 0 and W_1_1b.outcome > 0)
        hint: Indiquez soit une hausse nette (W.1.1a) soit une baisse nette (W.1.1b), pas les deux (report either a net increase or a net decrease).
        invented: true
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: W_1_2a
      kind: Question
      title: 1.2 Money owed to your household by persons outside your household? Report principal amounts or change in principal amounts. Exclude interest received (see Section U, Q.5, page 53). — net increase
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: W_1_2b
      kind: Question
      title: 1.2 Money owed to your household ... — net decrease
      postcondition:
      - predicate: not (W_1_2a.outcome > 0 and W_1_2b.outcome > 0)
        hint: Indiquez soit une hausse nette (W.1.2a) soit une baisse nette (W.1.2b), pas les deux (report either a net increase or a net decrease).
        invented: true
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: W_1_3a
      kind: Question
      title: 1.3 Money deposited as a pledge against future purchases of goods and services? — net increase
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: W_1_3b
      kind: Question
      title: 1.3 Money deposited as a pledge ... — net decrease
      postcondition:
      - predicate: not (W_1_3a.outcome > 0 and W_1_3b.outcome > 0)
        hint: Indiquez soit une hausse nette (W.1.3a) soit une baisse nette (W.1.3b), pas les deux (report either a net increase or a net decrease).
        invented: true
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: W_2a
      kind: Question
      title: 2. In 2000, how much did your household contribute to and withdraw from RRSPs? — Contributions
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: W_2b
      kind: Question
      title: 2. RRSPs — Withdrawals
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: W_3_1a
      kind: Question
      title: '3. In 2000, what was the value of your household''s purchases and sales of the following: 3.1 Savings bonds, and treasury bills? — Purchase'
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: W_3_1b
      kind: Question
      title: 3.1 Savings bonds, and treasury bills? — Sale
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: W_3_2a
      kind: Question
      title: 3.2 Publicly traded stocks, mutual funds and shares in investment clubs? — Purchase
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: W_3_2b
      kind: Question
      title: 3.2 Publicly traded stocks, mutual funds and shares in investment clubs? — Sale
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: W_3_3
      kind: Question
      title: 3.3 Sales of personal property not traded in on new items in 2000? Exclude sales of appliances and vehicles (see Sections L, Q and R). Exclude interest received on sales (see Section U, Q.5, page 53).
      input:
        control: Editbox
        min: 0
        max: 9999999
  - id: b_s29_screen
    title: 'Section X: Business and Farm Investments'
    items:
    - id: X_1
      kind: Question
      title: 1. In 2000, did any members of your household have investments in unincorporated businesses, professional practices, farms or rental property? Include major improvements (including land improvements). Report your household's share in the case of partnerships.
      input:
        control: Radio
        labels:
          1: 1 Yes
          2: 2 No
  - id: b_s29_flows
    title: Capital flows and net change in accounts
    precondition:
    - predicate: X_1.outcome == 1
      hint: Asked only when question X.1 is "1 Yes".
    - predicate: not (X_1.outcome == 2)
      hint: Asked only when question X.1 is not "2 No".
    items:
    - id: X_1_1
      kind: Question
      title: 'In 2000, how much did your household: 1.1 Repay on the principal of your mortgage(s) or loan(s)? Include all lump sum payments.'
      input:
        control: Editbox
        min: 0
        max: 99999999
    - id: X_1_2
      kind: Question
      title: 1.2 Pay to purchase assets? Include machinery, trucks, cars, buildings and other income-earning properties.
      input:
        control: Editbox
        min: 0
        max: 99999999
    - id: X_1_3
      kind: Question
      title: 1.3 Borrow for the business or farm? Include mortgages and loans.
      input:
        control: Editbox
        min: 0
        max: 99999999
    - id: X_1_4
      kind: Question
      title: 1.4 Receive (after commissions) from the sale of assets? Include machinery, trucks, cars, buildings and other income-earning properties.
      input:
        control: Editbox
        min: 0
        max: 99999999
    - id: X_1_5
      kind: Question
      title: 1.5 Estimate for capital cost allowance (depreciation) in the determination of net income from self-employment?
      input:
        control: Editbox
        min: 0
        max: 99999999
    - id: X_2_1a
      kind: Question
      title: '2. In 2000, what was the NET CHANGE (increase or decrease) in the following: 2.1 Accounts receivable? — net increase'
      input:
        control: Editbox
        min: 0
        max: 99999999
    - id: X_2_1b
      kind: Question
      title: 2.1 Accounts receivable? — net decrease
      postcondition:
      - predicate: not (X_2_1a.outcome > 0 and X_2_1b.outcome > 0)
        hint: Indiquez soit une hausse nette (X.2.1a) soit une baisse nette (X.2.1b), pas les deux (report either a net increase or a net decrease).
        invented: true
      input:
        control: Editbox
        min: 0
        max: 99999999
    - id: X_2_2a
      kind: Question
      title: '2.2 Accounts payable? — net increase (NOTE: In Q.2.2, the "C" and "D" are deliberately reversed.)'
      input:
        control: Editbox
        min: 0
        max: 99999999
    - id: X_2_2b
      kind: Question
      title: 2.2 Accounts payable? — net decrease
      postcondition:
      - predicate: not (X_2_2a.outcome > 0 and X_2_2b.outcome > 0)
        hint: Indiquez soit une hausse nette (X.2.2a) soit une baisse nette (X.2.2b), pas les deux (report either a net increase or a net decrease).
        invented: true
      input:
        control: Editbox
        min: 0
        max: 99999999
  - id: b_s30_screen
    title: Loans and Other Debts
    items:
    - id: Y_1
      kind: Question
      title: In 2000, did your household have any loans with regular payments? Include installment payment plans and student loans if repayment has begun. Exclude lines of credit, credit cards and accounts, and any outstanding bills (see Q.6 to Q.9).
      input:
        control: Radio
        labels:
          1: (1) Yes
          2: (2) No
  - id: b_s30_loans
    title: Loans with regular payments
    precondition:
    - predicate: Y_1.outcome == 1
      hint: Asked only when question Y.1 is "(1) Yes".
    - predicate: not (Y_1.outcome == 2)
      hint: Asked only when question Y.1 is not "(2) No".
    items:
    - id: Y_2
      kind: Question
      title: Description, e.g., car, boat. (for each loan A to E; ask Q.2 to Q.5.1 for all loans before asking Q.6)
      input:
        control: Textarea
    - id: Y_3
      kind: Question
      title: Was this loan taken out in 2000?
      input:
        control: Radio
        labels:
          1: (1) Yes
          2: (2) No
    - id: Y_3_1
      kind: Question
      title: What was the amount of the loan?
      precondition:
      - predicate: Y_3.outcome == 1
        hint: Asked only when question Y.3 is "(1) Yes".
      - predicate: not (Y_3.outcome == 2)
        hint: Asked only when question Y.3 is not "(2) No".
      input:
        control: Editbox
        min: 0
        max: 99999999
    - id: Y_4
      kind: Question
      title: How much were the total payments made on this loan in 2000? Include lump sum payments.
      input:
        control: Editbox
        min: 0
        max: 99999999
    - id: Y_5
      kind: Question
      title: Was there any additional amount borrowed in 2000 on this loan?
      input:
        control: Radio
        labels:
          1: (1) Yes
          2: (2) No
    - id: Y_5_1
      kind: Question
      title: What was the additional amount?
      precondition:
      - predicate: Y_5.outcome == 1
        hint: Asked only when question Y.5 is "(1) Yes".
      - predicate: not (Y_5.outcome == 2)
        hint: Asked only when question Y.5 is not "(2) No".
      input:
        control: Editbox
        min: 0
        max: 99999999
  - id: b_s30_debts_6
    title: Loans from financial institutions
    items:
    - id: Y_6_1
      kind: Question
      title: 6. Loans from financial institutions (Include lines of credit and student loans that are not yet being repaid.) — Amount Owed January 1, 2000
      input:
        control: Editbox
        min: 0
        max: 99999999
    - id: Y_6_2
      kind: Question
      title: 6. Loans from financial institutions — Amount Owed December 31, 2000
      input:
        control: Editbox
        min: 0
        max: 99999999
    - id: Y_6_3
      kind: Question
      title: 6. Loans from financial institutions — difference if January 1, 2000 amount is larger
      input:
        control: Editbox
        min: 0
        max: 99999999
    - id: Y_6_4
      kind: Question
      title: 6. Loans from financial institutions — difference if December 31, 2000 amount is larger
      postcondition:
      - predicate: Y_6_1.outcome - Y_6_2.outcome == Y_6_3.outcome - Y_6_4.outcome
        hint: La différence (Y.6.3 / Y.6.4) doit égaler l'écart entre le montant dû au 1er janvier (Y.6.1) et au 31 décembre (Y.6.2).
        invented: true
      input:
        control: Editbox
        min: 0
        max: 99999999
    - id: Y_6_5
      kind: Question
      title: 6. Loans from financial institutions — Amount of Interest Charges in 2000
      input:
        control: Editbox
        min: 0
        max: 99999999
  - id: b_s30_debts_7
    title: Credit cards from financial institutions
    items:
    - id: Y_7_1
      kind: Question
      title: 7. Credit cards from financial institutions — Amount Owed January 1, 2000
      input:
        control: Editbox
        min: 0
        max: 99999999
    - id: Y_7_2
      kind: Question
      title: 7. Credit cards from financial institutions — Amount Owed December 31, 2000
      input:
        control: Editbox
        min: 0
        max: 99999999
    - id: Y_7_3
      kind: Question
      title: 7. Credit cards from financial institutions — difference if January 1, 2000 amount is larger
      input:
        control: Editbox
        min: 0
        max: 99999999
    - id: Y_7_4
      kind: Question
      title: 7. Credit cards from financial institutions — difference if December 31, 2000 amount is larger
      postcondition:
      - predicate: Y_7_1.outcome - Y_7_2.outcome == Y_7_3.outcome - Y_7_4.outcome
        hint: La différence (Y.7.3 / Y.7.4) doit égaler l'écart entre le montant dû au 1er janvier (Y.7.1) et au 31 décembre (Y.7.2).
        invented: true
      input:
        control: Editbox
        min: 0
        max: 99999999
    - id: Y_7_5
      kind: Question
      title: 7. Credit cards from financial institutions — Amount of Interest Charges in 2000
      input:
        control: Editbox
        min: 0
        max: 99999999
  - id: b_s30_debts_8
    title: Store credit cards and other retail debts
    items:
    - id: Y_8_1
      kind: Question
      title: 8. Credit cards and other debts with stores, service stations and other retail establishments (Include all revolving budget accounts.) — Amount Owed January 1, 2000
      input:
        control: Editbox
        min: 0
        max: 99999999
    - id: Y_8_2
      kind: Question
      title: 8. Credit cards and other debts with stores ... — Amount Owed December 31, 2000
      input:
        control: Editbox
        min: 0
        max: 99999999
    - id: Y_8_3
      kind: Question
      title: 8. Credit cards and other debts with stores ... — difference if January 1, 2000 amount is larger
      input:
        control: Editbox
        min: 0
        max: 99999999
    - id: Y_8_4
      kind: Question
      title: 8. Credit cards and other debts with stores ... — difference if December 31, 2000 amount is larger
      postcondition:
      - predicate: Y_8_1.outcome - Y_8_2.outcome == Y_8_3.outcome - Y_8_4.outcome
        hint: La différence (Y.8.3 / Y.8.4) doit égaler l'écart entre le montant dû au 1er janvier (Y.8.1) et au 31 décembre (Y.8.2).
        invented: true
      input:
        control: Editbox
        min: 0
        max: 99999999
    - id: Y_8_5
      kind: Question
      title: 8. Credit cards and other debts with stores ... — Amount of Interest Charges in 2000
      input:
        control: Editbox
        min: 0
        max: 99999999
  - id: b_s30_debts_9
    title: Rents, taxes and other bills
    items:
    - id: Y_9_1
      kind: Question
      title: 9. Rents, taxes and other bills, e.g., hospital — Amount Owed January 1, 2000
      input:
        control: Editbox
        min: 0
        max: 99999999
    - id: Y_9_2
      kind: Question
      title: 9. Rents, taxes and other bills, e.g., hospital — Amount Owed December 31, 2000
      input:
        control: Editbox
        min: 0
        max: 99999999
    - id: Y_9_3
      kind: Question
      title: 9. Rents, taxes and other bills — difference if January 1, 2000 amount is larger
      input:
        control: Editbox
        min: 0
        max: 99999999
    - id: Y_9_4
      kind: Question
      title: 9. Rents, taxes and other bills — difference if December 31, 2000 amount is larger
      postcondition:
      - predicate: Y_9_1.outcome - Y_9_2.outcome == Y_9_3.outcome - Y_9_4.outcome
        hint: La différence (Y.9.3 / Y.9.4) doit égaler l'écart entre le montant dû au 1er janvier (Y.9.1) et au 31 décembre (Y.9.2).
        invented: true
      input:
        control: Editbox
        min: 0
        max: 99999999
    - id: Y_9_5
      kind: Question
      title: 9. Rents, taxes and other bills — Amount of Interest Charges in 2000
      input:
        control: Editbox
        min: 0
        max: 99999999
  - id: b_s31_visit1
    title: Record of Visits — Visit 1
    items:
    - id: V1_DATE
      kind: Question
      title: Record of Visits — Visit Number 1 — Date (the source prints no id; id follows the row position)
      input:
        control: Textarea
    - id: V1_TIME
      kind: Question
      title: Record of Visits — Visit Number 1 — Time
      input:
        control: Textarea
    - id: V1_COMMENTS
      kind: Question
      title: Record of Visits — Visit Number 1 — Comments
      input:
        control: Textarea
  - id: b_s31_visit2
    title: Record of Visits — Visit 2
    items:
    - id: V2_DATE
      kind: Question
      title: Record of Visits — Visit Number 2 — Date
      input:
        control: Textarea
    - id: V2_TIME
      kind: Question
      title: Record of Visits — Visit Number 2 — Time
      input:
        control: Textarea
    - id: V2_COMMENTS
      kind: Question
      title: Record of Visits — Visit Number 2 — Comments
      input:
        control: Textarea
  - id: b_s31_visit3
    title: Record of Visits — Visit 3
    items:
    - id: V3_DATE
      kind: Question
      title: Record of Visits — Visit Number 3 — Date
      input:
        control: Textarea
    - id: V3_TIME
      kind: Question
      title: Record of Visits — Visit Number 3 — Time
      input:
        control: Textarea
    - id: V3_COMMENTS
      kind: Question
      title: Record of Visits — Visit Number 3 — Comments
      input:
        control: Textarea
  - id: b_s31_visit4
    title: Record of Visits — Visit 4
    items:
    - id: V4_DATE
      kind: Question
      title: Record of Visits — Visit Number 4 — Date
      input:
        control: Textarea
    - id: V4_TIME
      kind: Question
      title: Record of Visits — Visit Number 4 — Time
      input:
        control: Textarea
    - id: V4_COMMENTS
      kind: Question
      title: Record of Visits — Visit Number 4 — Comments
      input:
        control: Textarea
  - id: b_s31_visit5
    title: Record of Visits — Visit 5
    items:
    - id: V5_DATE
      kind: Question
      title: Record of Visits — Visit Number 5 — Date
      input:
        control: Textarea
    - id: V5_TIME
      kind: Question
      title: Record of Visits — Visit Number 5 — Time
      input:
        control: Textarea
    - id: V5_COMMENTS
      kind: Question
      title: Record of Visits — Visit Number 5 — Comments
      input:
        control: Textarea
  - id: b_s31_visit6
    title: Record of Visits — Visit 6
    items:
    - id: V6_DATE
      kind: Question
      title: Record of Visits — Visit Number 6 — Date
      input:
        control: Textarea
    - id: V6_TIME
      kind: Question
      title: Record of Visits — Visit Number 6 — Time
      input:
        control: Textarea
    - id: V6_COMMENTS
      kind: Question
      title: Record of Visits — Visit Number 6 — Comments
      input:
        control: Textarea
  - id: b_s31_visit7
    title: Record of Visits — Visit 7
    items:
    - id: V7_DATE
      kind: Question
      title: Record of Visits — Visit Number 7 — Date
      input:
        control: Textarea
    - id: V7_TIME
      kind: Question
      title: Record of Visits — Visit Number 7 — Time
      input:
        control: Textarea
    - id: V7_COMMENTS
      kind: Question
      title: Record of Visits — Visit Number 7 — Comments
      input:
        control: Textarea
  - id: b_s31_visit8
    title: Record of Visits — Visit 8
    items:
    - id: V8_DATE
      kind: Question
      title: Record of Visits — Visit Number 8 — Date
      input:
        control: Textarea
    - id: V8_TIME
      kind: Question
      title: Record of Visits — Visit Number 8 — Time
      input:
        control: Textarea
    - id: V8_COMMENTS
      kind: Question
      title: Record of Visits — Visit Number 8 — Comments
      input:
        control: Textarea
  - id: b_s31_interview1
    title: Interview 1
    items:
    - id: Q001
      kind: Question
      title: Interview 1 — Date
      input:
        control: Textarea
    - id: Q002
      kind: Question
      title: Interview 1 — Month
      input:
        control: Editbox
        min: 1
        max: 12
    - id: Q003
      kind: Question
      title: Interview 1 — Began
      input:
        control: Textarea
    - id: Q004
      kind: Question
      title: Interview 1 — Ended
      input:
        control: Textarea
  - id: b_s31_interview2
    title: Interview 2
    items:
    - id: Q011
      kind: Question
      title: Interview 2 — Date
      input:
        control: Textarea
    - id: Q012
      kind: Question
      title: Interview 2 — Month
      input:
        control: Editbox
        min: 1
        max: 12
    - id: Q013
      kind: Question
      title: Interview 2 — Began
      input:
        control: Textarea
    - id: Q014
      kind: Question
      title: Interview 2 — Ended
      input:
        control: Textarea
  - id: b_s31_interview3
    title: Interview 3
    items:
    - id: Q021
      kind: Question
      title: Interview 3 — Date
      input:
        control: Textarea
    - id: Q022
      kind: Question
      title: Interview 3 — Month
      input:
        control: Editbox
        min: 1
        max: 12
    - id: Q023
      kind: Question
      title: Interview 3 — Began
      input:
        control: Textarea
    - id: Q024
      kind: Question
      title: Interview 3 — Ended
      input:
        control: Textarea
  - id: b_s31_interview4
    title: Interview 4
    items:
    - id: Q031
      kind: Question
      title: Interview 4 — Date
      input:
        control: Textarea
    - id: Q032
      kind: Question
      title: Interview 4 — Month
      input:
        control: Editbox
        min: 1
        max: 12
    - id: Q033
      kind: Question
      title: Interview 4 — Began
      input:
        control: Textarea
    - id: Q034
      kind: Question
      title: Interview 4 — Ended
      input:
        control: Textarea
  - id: b_s31_interviewer
    title: Interviewer identification
    items:
    - id: INTERVIEWER_NAME
      kind: Question
      title: Interviewer's Name (Please print) (the source prints no id)
      input:
        control: Textarea
    - id: INTERVIEWER_PHONE
      kind: Question
      title: Interviewer's Telephone Number (the source prints no id)
      input:
        control: Textarea
    - id: Q040
      kind: Question
      title: Interviewer No.
      input:
        control: Editbox
        min: 0
        max: 99999
  - id: b_s32_ws_e
    title: E. Owned Principal Residences (page 14)
    items:
    - id: WS_E_A
      kind: Question
      title: Balance Worksheet — E. Owned Principal Residences (page 14) — Expenses A
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: WS_E_B
      kind: Question
      title: Balance Worksheet — E. Owned Principal Residences (page 14) — Income B
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: WS_E_C
      kind: Question
      title: Balance Worksheet — E. Owned Principal Residences (page 14) — Credits C
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: WS_E_D
      kind: Question
      title: Balance Worksheet — E. Owned Principal Residences (page 14) — Debits D
      input:
        control: Editbox
        min: 0
        max: 9999999
  - id: b_s32_ws_f
    title: F. Purchase and Sale of Homes (page 15)
    items:
    - id: WS_F_A
      kind: Question
      title: Balance Worksheet — F. Purchase and Sale of Homes (page 15) — Expenses A
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: WS_F_B
      kind: Question
      title: Balance Worksheet — F. Purchase and Sale of Homes (page 15) — Income B
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: WS_F_C
      kind: Question
      title: Balance Worksheet — F. Purchase and Sale of Homes (page 15) — Credits C
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: WS_F_D
      kind: Question
      title: Balance Worksheet — F. Purchase and Sale of Homes (page 15) — Debits D
      input:
        control: Editbox
        min: 0
        max: 9999999
  - id: b_s32_ws_g
    title: G. Mortgages on Owned Principal Residences (page 16)
    items:
    - id: WS_G_A
      kind: Question
      title: Balance Worksheet — G. Mortgages on Owned Principal Residences (page 16) — Expenses A
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: WS_G_B
      kind: Question
      title: Balance Worksheet — G. Mortgages on Owned Principal Residences (page 16) — Income B
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: WS_G_C
      kind: Question
      title: Balance Worksheet — G. Mortgages on Owned Principal Residences (page 16) — Credits C
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: WS_G_D
      kind: Question
      title: Balance Worksheet — G. Mortgages on Owned Principal Residences (page 16) — Debits D
      input:
        control: Editbox
        min: 0
        max: 9999999
  - id: b_s32_ws_h
    title: H. Renovations and Repairs of Owned Principal Residences (page 18)
    items:
    - id: WS_H_A
      kind: Question
      title: Balance Worksheet — H. Renovations and Repairs of Owned Principal Residences (page 18) — Expenses A
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: WS_H_B
      kind: Question
      title: Balance Worksheet — H. Renovations and Repairs of Owned Principal Residences (page 18) — Income B
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: WS_H_C
      kind: Question
      title: Balance Worksheet — H. Renovations and Repairs of Owned Principal Residences (page 18) — Credits C
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: WS_H_D
      kind: Question
      title: Balance Worksheet — H. Renovations and Repairs of Owned Principal Residences (page 18) — Debits D
      input:
        control: Editbox
        min: 0
        max: 9999999
  - id: b_s32_ws_i
    title: I. Rented Principal Residences (page 20)
    items:
    - id: WS_I_A
      kind: Question
      title: Balance Worksheet — I. Rented Principal Residences (page 20) — Expenses A
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: WS_I_B
      kind: Question
      title: Balance Worksheet — I. Rented Principal Residences (page 20) — Income B
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: WS_I_C
      kind: Question
      title: Balance Worksheet — I. Rented Principal Residences (page 20) — Credits C
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: WS_I_D
      kind: Question
      title: Balance Worksheet — I. Rented Principal Residences (page 20) — Debits D
      input:
        control: Editbox
        min: 0
        max: 9999999
  - id: b_s32_ws_j
    title: J. Utilities and Other Rented Accommodation (page 21)
    items:
    - id: WS_J_A
      kind: Question
      title: Balance Worksheet — J. Utilities and Other Rented Accommodation (page 21) — Expenses A
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: WS_J_B
      kind: Question
      title: Balance Worksheet — J. Utilities and Other Rented Accommodation (page 21) — Income B
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: WS_J_C
      kind: Question
      title: Balance Worksheet — J. Utilities and Other Rented Accommodation (page 21) — Credits C
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: WS_J_D
      kind: Question
      title: Balance Worksheet — J. Utilities and Other Rented Accommodation (page 21) — Debits D
      input:
        control: Editbox
        min: 0
        max: 9999999
  - id: b_s32_ws_k
    title: K. Owned Secondary Residences and Other Property (page 25)
    items:
    - id: WS_K_A
      kind: Question
      title: Balance Worksheet — K. Owned Secondary Residences and Other Property (page 25) — Expenses A
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: WS_K_B
      kind: Question
      title: Balance Worksheet — K. Owned Secondary Residences and Other Property (page 25) — Income B
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: WS_K_C
      kind: Question
      title: Balance Worksheet — K. Owned Secondary Residences and Other Property (page 25) — Credits C
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: WS_K_D
      kind: Question
      title: Balance Worksheet — K. Owned Secondary Residences and Other Property (page 25) — Debits D
      input:
        control: Editbox
        min: 0
        max: 9999999
  - id: b_s32_ws_l
    title: L. Household Furnishings and Equipment (page 31)
    items:
    - id: WS_L_A
      kind: Question
      title: Balance Worksheet — L. Household Furnishings and Equipment (page 31) — Expenses A
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: WS_L_B
      kind: Question
      title: Balance Worksheet — L. Household Furnishings and Equipment (page 31) — Income B
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: WS_L_C
      kind: Question
      title: Balance Worksheet — L. Household Furnishings and Equipment (page 31) — Credits C
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: WS_L_D
      kind: Question
      title: Balance Worksheet — L. Household Furnishings and Equipment (page 31) — Debits D
      input:
        control: Editbox
        min: 0
        max: 9999999
  - id: b_s32_ws_m
    title: M. Home Operation (page 33)
    items:
    - id: WS_M_A
      kind: Question
      title: Balance Worksheet — M. Home Operation (page 33) — Expenses A
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: WS_M_B
      kind: Question
      title: Balance Worksheet — M. Home Operation (page 33) — Income B
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: WS_M_C
      kind: Question
      title: Balance Worksheet — M. Home Operation (page 33) — Credits C
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: WS_M_D
      kind: Question
      title: Balance Worksheet — M. Home Operation (page 33) — Debits D
      input:
        control: Editbox
        min: 0
        max: 9999999
  - id: b_s32_ws_n
    title: N. Food and Alcohol (page 35)
    items:
    - id: WS_N_A
      kind: Question
      title: Balance Worksheet — N. Food and Alcohol (page 35) — Expenses A
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: WS_N_B
      kind: Question
      title: Balance Worksheet — N. Food and Alcohol (page 35) — Income B
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: WS_N_C
      kind: Question
      title: Balance Worksheet — N. Food and Alcohol (page 35) — Credits C
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: WS_N_D
      kind: Question
      title: Balance Worksheet — N. Food and Alcohol (page 35) — Debits D
      input:
        control: Editbox
        min: 0
        max: 9999999
  - id: b_s32_ws_o
    title: O. Clothing (page 38)
    items:
    - id: WS_O_A
      kind: Question
      title: Balance Worksheet — O. Clothing (page 38) — Expenses A
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: WS_O_B
      kind: Question
      title: Balance Worksheet — O. Clothing (page 38) — Income B
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: WS_O_C
      kind: Question
      title: Balance Worksheet — O. Clothing (page 38) — Credits C
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: WS_O_D
      kind: Question
      title: Balance Worksheet — O. Clothing (page 38) — Debits D
      input:
        control: Editbox
        min: 0
        max: 9999999
  - id: b_s32_ws_p
    title: P. Personal and Health Care (page 40)
    items:
    - id: WS_P_A
      kind: Question
      title: Balance Worksheet — P. Personal and Health Care (page 40) — Expenses A
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: WS_P_B
      kind: Question
      title: Balance Worksheet — P. Personal and Health Care (page 40) — Income B
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: WS_P_C
      kind: Question
      title: Balance Worksheet — P. Personal and Health Care (page 40) — Credits C
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: WS_P_D
      kind: Question
      title: Balance Worksheet — P. Personal and Health Care (page 40) — Debits D
      input:
        control: Editbox
        min: 0
        max: 9999999
  - id: b_s32_ws_q
    title: Q. Automobiles and Trucks (page 44)
    items:
    - id: WS_Q_A
      kind: Question
      title: Balance Worksheet — Q. Automobiles and Trucks (page 44) — Expenses A
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: WS_Q_B
      kind: Question
      title: Balance Worksheet — Q. Automobiles and Trucks (page 44) — Income B
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: WS_Q_C
      kind: Question
      title: Balance Worksheet — Q. Automobiles and Trucks (page 44) — Credits C
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: WS_Q_D
      kind: Question
      title: Balance Worksheet — Q. Automobiles and Trucks (page 44) — Debits D
      input:
        control: Editbox
        min: 0
        max: 9999999
  - id: b_s32_ws_r
    title: R. Recreational Vehicles and Transportation Services (page 47)
    items:
    - id: WS_R_A
      kind: Question
      title: Balance Worksheet — R. Recreational Vehicles and Transportation Services (page 47) — Expenses A
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: WS_R_B
      kind: Question
      title: Balance Worksheet — R. Recreational Vehicles and Transportation Services (page 47) — Income B
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: WS_R_C
      kind: Question
      title: Balance Worksheet — R. Recreational Vehicles and Transportation Services (page 47) — Credits C
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: WS_R_D
      kind: Question
      title: Balance Worksheet — R. Recreational Vehicles and Transportation Services (page 47) — Debits D
      input:
        control: Editbox
        min: 0
        max: 9999999
  - id: b_s32_ws_s
    title: S. Recreation, Reading Materials and Education (page 50)
    items:
    - id: WS_S_A
      kind: Question
      title: Balance Worksheet — S. Recreation, Reading Materials and Education (page 50) — Expenses A
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: WS_S_B
      kind: Question
      title: Balance Worksheet — S. Recreation, Reading Materials and Education (page 50) — Income B
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: WS_S_C
      kind: Question
      title: Balance Worksheet — S. Recreation, Reading Materials and Education (page 50) — Credits C
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: WS_S_D
      kind: Question
      title: Balance Worksheet — S. Recreation, Reading Materials and Education (page 50) — Debits D
      input:
        control: Editbox
        min: 0
        max: 9999999
  - id: b_s32_ws_t
    title: T. Tobacco and Miscellaneous (page 52)
    items:
    - id: WS_T_A
      kind: Question
      title: Balance Worksheet — T. Tobacco and Miscellaneous (page 52) — Expenses A
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: WS_T_B
      kind: Question
      title: Balance Worksheet — T. Tobacco and Miscellaneous (page 52) — Income B
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: WS_T_C
      kind: Question
      title: Balance Worksheet — T. Tobacco and Miscellaneous (page 52) — Credits C
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: WS_T_D
      kind: Question
      title: Balance Worksheet — T. Tobacco and Miscellaneous (page 52) — Debits D
      input:
        control: Editbox
        min: 0
        max: 9999999
  - id: b_s32_ws_u
    title: U. Personal Income (page 54)
    items:
    - id: WS_U_A
      kind: Question
      title: Balance Worksheet — U. Personal Income (page 54) — Expenses A
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: WS_U_B
      kind: Question
      title: Balance Worksheet — U. Personal Income (page 54) — Income B
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: WS_U_C
      kind: Question
      title: Balance Worksheet — U. Personal Income (page 54) — Credits C
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: WS_U_D
      kind: Question
      title: Balance Worksheet — U. Personal Income (page 54) — Debits D
      input:
        control: Editbox
        min: 0
        max: 9999999
  - id: b_s32_ws_v
    title: V. Personal Taxes, Security and Money Gifts (page 56)
    items:
    - id: WS_V_A
      kind: Question
      title: Balance Worksheet — V. Personal Taxes, Security and Money Gifts (page 56) — Expenses A
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: WS_V_B
      kind: Question
      title: Balance Worksheet — V. Personal Taxes, Security and Money Gifts (page 56) — Income B
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: WS_V_C
      kind: Question
      title: Balance Worksheet — V. Personal Taxes, Security and Money Gifts (page 56) — Credits C
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: WS_V_D
      kind: Question
      title: Balance Worksheet — V. Personal Taxes, Security and Money Gifts (page 56) — Debits D
      input:
        control: Editbox
        min: 0
        max: 9999999
  - id: b_s32_ws_w
    title: W. Change in Assets (page 57)
    items:
    - id: WS_W_A
      kind: Question
      title: Balance Worksheet — W. Change in Assets (page 57) — Expenses A
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: WS_W_B
      kind: Question
      title: Balance Worksheet — W. Change in Assets (page 57) — Income B
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: WS_W_C
      kind: Question
      title: Balance Worksheet — W. Change in Assets (page 57) — Credits C
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: WS_W_D
      kind: Question
      title: Balance Worksheet — W. Change in Assets (page 57) — Debits D
      input:
        control: Editbox
        min: 0
        max: 9999999
  - id: b_s32_ws_x
    title: X. Unincorporated Business (page 58)
    items:
    - id: WS_X_A
      kind: Question
      title: Balance Worksheet — X. Unincorporated Business (page 58) — Expenses A
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: WS_X_B
      kind: Question
      title: Balance Worksheet — X. Unincorporated Business (page 58) — Income B
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: WS_X_C
      kind: Question
      title: Balance Worksheet — X. Unincorporated Business (page 58) — Credits C
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: WS_X_D
      kind: Question
      title: Balance Worksheet — X. Unincorporated Business (page 58) — Debits D
      input:
        control: Editbox
        min: 0
        max: 9999999
  - id: b_s32_ws_y
    title: Y. Loans and Other Debts (page 60)
    items:
    - id: WS_Y_A
      kind: Question
      title: Balance Worksheet — Y. Loans and Other Debts (page 60) — Expenses A
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: WS_Y_B
      kind: Question
      title: Balance Worksheet — Y. Loans and Other Debts (page 60) — Income B
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: WS_Y_C
      kind: Question
      title: Balance Worksheet — Y. Loans and Other Debts (page 60) — Credits C
      input:
        control: Editbox
        min: 0
        max: 9999999
    - id: WS_Y_D
      kind: Question
      title: Balance Worksheet — Y. Loans and Other Debts (page 60) — Debits D
      input:
        control: Editbox
        min: 0
        max: 9999999
  - id: b_s32_subtotals
    title: 1. Subtotals
    items:
    - id: Q1A
      kind: Question
      title: 1. Subtotals — Expenses A
      input:
        control: Editbox
        min: 0
        max: 999999999
      postcondition:
      - predicate: Q1A.outcome == WS_E_A.outcome + WS_F_A.outcome + WS_G_A.outcome + WS_H_A.outcome + WS_I_A.outcome + WS_J_A.outcome + WS_K_A.outcome + WS_L_A.outcome + WS_M_A.outcome + WS_N_A.outcome + WS_O_A.outcome + WS_P_A.outcome + WS_Q_A.outcome + WS_R_A.outcome + WS_S_A.outcome + WS_T_A.outcome + WS_U_A.outcome + WS_V_A.outcome + WS_W_A.outcome + WS_X_A.outcome + WS_Y_A.outcome
        hint: El subtotal de Expenses A (línea 1) debe ser la suma de la columna Expenses A de las secciones E a Y.
        invented: true
    - id: Q1B
      kind: Question
      title: 1. Subtotals — Income B
      input:
        control: Editbox
        min: 0
        max: 999999999
      postcondition:
      - predicate: Q1B.outcome == WS_E_B.outcome + WS_F_B.outcome + WS_G_B.outcome + WS_H_B.outcome + WS_I_B.outcome + WS_J_B.outcome + WS_K_B.outcome + WS_L_B.outcome + WS_M_B.outcome + WS_N_B.outcome + WS_O_B.outcome + WS_P_B.outcome + WS_Q_B.outcome + WS_R_B.outcome + WS_S_B.outcome + WS_T_B.outcome + WS_U_B.outcome + WS_V_B.outcome + WS_W_B.outcome + WS_X_B.outcome + WS_Y_B.outcome
        hint: The line 1 subtotal for Income B must equal the sum of the Income B column for sections E to Y.
        invented: true
    - id: Q1C
      kind: Question
      title: 1. Subtotals — Credits C
      input:
        control: Editbox
        min: 0
        max: 999999999
      postcondition:
      - predicate: Q1C.outcome == WS_E_C.outcome + WS_F_C.outcome + WS_G_C.outcome + WS_H_C.outcome + WS_I_C.outcome + WS_J_C.outcome + WS_K_C.outcome + WS_L_C.outcome + WS_M_C.outcome + WS_N_C.outcome + WS_O_C.outcome + WS_P_C.outcome + WS_Q_C.outcome + WS_R_C.outcome + WS_S_C.outcome + WS_T_C.outcome + WS_U_C.outcome + WS_V_C.outcome + WS_W_C.outcome + WS_X_C.outcome + WS_Y_C.outcome
        hint: The line 1 subtotal for Credits C must equal the sum of the Credits C column for sections E to Y.
        invented: true
    - id: Q1D
      kind: Question
      title: 1. Subtotals — Debits D
      input:
        control: Editbox
        min: 0
        max: 999999999
      postcondition:
      - predicate: Q1D.outcome == WS_E_D.outcome + WS_F_D.outcome + WS_G_D.outcome + WS_H_D.outcome + WS_I_D.outcome + WS_J_D.outcome + WS_K_D.outcome + WS_L_D.outcome + WS_M_D.outcome + WS_N_D.outcome + WS_O_D.outcome + WS_P_D.outcome + WS_Q_D.outcome + WS_R_D.outcome + WS_S_D.outcome + WS_T_D.outcome + WS_U_D.outcome + WS_V_D.outcome + WS_W_D.outcome + WS_X_D.outcome + WS_Y_D.outcome
        hint: The line 1 subtotal for Debits D must equal the sum of the Debits D column for sections E to Y.
        invented: true
    - id: Q2
      kind: Question
      title: 2. If Credits (C) are greater than Debits (D) enter difference (C - D)
      precondition:
      - predicate: Q1C.outcome > Q1D.outcome
        hint: Asked only when Credits C (line 1) exceed Debits D
      input:
        control: Editbox
        min: 0
        max: 999999999
    - id: Q3
      kind: Question
      title: 3. If Debits (D) are greater than Credits (C) enter difference (D - C)
      precondition:
      - predicate: Q1D.outcome > Q1C.outcome
        hint: Asked only when Debits D (line 1) exceed Credits C
      input:
        control: Editbox
        min: 0
        max: 999999999
  - id: b_s32_balance
    title: Balance check
    items:
    - id: Q4T1
      kind: Question
      title: 4. Totals (lines 1 + 2 + 3) — T1
      input:
        control: Editbox
        min: 0
        max: 999999999
    - id: Q4T2
      kind: Question
      title: 4. Totals (lines 1 + 2 + 3) — T2
      input:
        control: Editbox
        min: 0
        max: 999999999
    - id: Q5
      kind: Question
      title: 5. Difference (T1 - T2), if negative omit sign
      input:
        control: Editbox
        min: 0
        max: 999999999
    - id: Q6
      kind: Question
      title: 6. Allowable difference (10% of T1 or T2, whichever is larger)
      input:
        control: Editbox
        min: 0
        max: 999999999
    - id: Q7
      kind: Question
      title: 7. Amount over allowable difference (line 5 - line 6), if negative enter 0
      input:
        control: Editbox
        min: 0
        max: 999999999
    - id: Q8
      kind: Question
      title: 8. Is it balanced (is Q.7 = 0)?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
      postcondition:
      - predicate: (Q8.outcome == 1 and Q7.outcome == 0) or (Q8.outcome == 2 and Q7.outcome > 0)
        hint: Question 8 must be Yes only if the amount in line 7 is 0; check line 7 and question 8.
        invented: true
    - id: Q9
      kind: Question
      title: 9. Percentage out of balance (line 5 ÷ the larger of T1 or T2) X 100
      input:
        control: Editbox
        min: 0
        max: 999999999
