qmlVersion: '2.7'
questionnaire:
  title: Labour Force Survey questionnaire
  blocks:
  - id: b_s1_external
    title: External inputs
    items:
    - id: INTERVIEW_TYPE
      kind: Question
      title: 'Type of interview, from the survey control: birth interview in person, birth interview by telephone (CATI), subsequent interview in person, subsequent interview by telephone'
      external: true
      input:
        control: Radio
        labels:
          1: Birth interview in person
          2: Birth interview by telephone (CATI)
          3: Subsequent interview in person
          4: Subsequent interview by telephone
    - id: CATI_INTERVIEW
      kind: Question
      title: Whether the interview is conducted from a centralized CATI work site ("If CATI interview")
      external: true
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: LISTING_SAME_AS_MAILING
      kind: Question
      title: Listing address is the same as the mailing address (from the sample file)
      external: true
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: AGE
      kind: Question
      title: Age of the household member on the last day of the reference week (calculated from ANC_Q01/ANC_Q02 or entered in ANC_Q03)
      external: true
      input:
        control: Editbox
        min: 0
        max: 120
    - id: CURRENT_YEAR
      kind: Question
      title: Current year (system date)
      external: true
      input:
        control: Editbox
        min: 2000
        max: 2100
    - id: BIRTH_COUNTRY_NA
      kind: Question
      title: Country of birth (IMM_Q01) is Canada, USA or Greenland (derived from IMM_Q01)
      external: true
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: DWELLING_APARTMENT
      kind: Question
      title: Dwelling type (DW_Q01 or DW_N02) is “Low-rise apartment” or “High-rise apartment” (derived from the dwelling type answer)
      external: true
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: PROVINCE
      kind: Question
      title: Province/territory of the dwelling (from the sample file)
      external: true
      input:
        control: Radio
        labels:
          1: Yukon Territory
          2: Northwest Territories
          3: Nunavut
          4: Any other province
    - id: RENT_PREV
      kind: Question
      title: Rent information exists from the previous month (previous interview data)
      external: true
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: HH_CHANGE
      kind: Question
      title: There has been a complete change in household membership
      external: true
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: PATH
      kind: Question
      title: Path assigned within the Labour force information component
      external: true
      input:
        control: Dropdown
        labels:
          1: Employed, at work
          2: Employed, absent from work
          3: Temporary layoff
          4: Job seeker
          5: Future start
          6: Not in labour force, able to work
          7: Not in labour force, permanently unable to work
    - id: PREV_PATH
      kind: Question
      title: Last month's PATH (previous interview data)
      external: true
      input:
        control: Dropdown
        labels:
          1: Employed, at work
          2: Employed, absent from work
          3: Temporary layoff
          4: Job seeker
          5: Future start
          6: Not in labour force, able to work
          7: Not in labour force, permanently unable to work
    - id: NO_CHANGE_105
      kind: Question
      title: Subsequent interview and no change in the answer to 105
      external: true
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: LAST_WORK_OVER_YEAR
      kind: Question
      title: 'Derived from 105: last worked not within the past year'
      external: true
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: NO_CHANGE_200
      kind: Question
      title: Subsequent interview and no change in 110, 114, 115, 116, 117, 118
      external: true
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
  - id: b_s2_intro_a
    title: Contact component
    items:
    - id: II_R01A
      kind: Question
      title: Hello, I’m calling from Statistics Canada. My name is ….
      input:
        control: Radio
        labels:
          1: Introduction read
  - id: b_s2_cati_contact
    title: 'Contact component: selected respondent'
    precondition:
    - predicate: not (INTERVIEW_TYPE.outcome in [1, 3])
      hint: Asked only when question INTERVIEW_TYPE is none of "Birth interview in person", "Subsequent interview in person".
    - predicate: not (INTERVIEW_TYPE.outcome == 2)
      hint: Asked only when question INTERVIEW_TYPE is not "Birth interview by telephone (CATI)".
    items:
    - id: SR_Q01
      kind: Question
      title: May I speak with … ?
      input:
        control: Radio
        labels:
          1: Speaking
          2: Available
          3: Not available
          4: No longer a household member
          5: Wrong number
    - id: II_R01B
      kind: Question
      title: Hello, I’m calling from Statistics Canada. My name is ….
      precondition:
      - predicate: not (SR_Q01.outcome == 1)
        hint: Asked only when question SR_Q01 is not "Speaking".
      - predicate: not (SR_Q01.outcome in [3, 4])
        hint: Asked only when question SR_Q01 is none of "Not available", "No longer a household member".
      - predicate: not (SR_Q01.outcome == 5)
        hint: Asked only when question SR_Q01 is not "Wrong number".
      input:
        control: Radio
        labels:
          1: Introduction read
    - id: TC_Q01
      kind: Question
      title: I would like to make sure I’ve dialled the right number. Is this … ?
      precondition:
      - predicate: not (SR_Q01.outcome == 1)
        hint: Asked only when question SR_Q01 is not "Speaking".
      - predicate: not (SR_Q01.outcome in [3, 4])
        hint: Asked only when question SR_Q01 is none of "Not available", "No longer a household member".
      - predicate: not (II_R01B.outcome == 1)
        hint: Asked only when question II_R01B is not "Introduction read".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
  - id: b_s2_adult_contact
    title: 'Contact component: adult respondent and address confirmation'
    precondition:
    - predicate: not (INTERVIEW_TYPE.outcome in [1, 3])
      hint: Asked only when question INTERVIEW_TYPE is none of "Birth interview in person", "Subsequent interview in person".
    - predicate: not (SR_Q01.outcome == 1)
      hint: Asked only when question SR_Q01 is not "Speaking".
    - predicate: not (II_R01B.outcome == 1)
      hint: Asked only when question II_R01B is not "Introduction read".
    - predicate: not (TC_Q01.outcome == 2)
      hint: Asked only when question TC_Q01 is not "No".
    items:
    - id: AR_Q01
      kind: Question
      title: May I speak with an adult member of the household?
      input:
        control: Radio
        labels:
          1: Speaking
          2: Available
          3: Not available
    - id: II_R01C
      kind: Question
      title: Hello, I’m calling from Statistics Canada. My name is … .
      precondition:
      - predicate: not (AR_Q01.outcome == 1 and INTERVIEW_TYPE.outcome == 2)
        hint: Not asked when an adult is speaking and the interview is a birth interview by telephone (CATI).
      - predicate: not (AR_Q01.outcome == 1 and not (INTERVIEW_TYPE.outcome == 2))
        hint: Not asked when an adult is speaking and the interview is not a birth interview by telephone (CATI).
      - predicate: not (AR_Q01.outcome == 3 and INTERVIEW_TYPE.outcome in [1, 2])
        hint: Not asked when no adult is available and the interview is a birth interview.
      - predicate: not (AR_Q01.outcome == 3 and INTERVIEW_TYPE.outcome in [3, 4] and SR_Q01.outcome == 3)
        hint: Not asked when no adult is available and the selected respondent is not available.
      - predicate: not (AR_Q01.outcome == 3 and INTERVIEW_TYPE.outcome in [3, 4] and SR_Q01.outcome in [4, 5])
        hint: Not asked when no adult is available and the selected respondent is no longer a member or the number is wrong.
      input:
        control: Radio
        labels:
          1: Introduction read
    - id: SRA_Q01
      kind: Question
      title: I would like to contact … . When would he/she be available?
      precondition:
      - predicate: not (AR_Q01.outcome == 1 and INTERVIEW_TYPE.outcome == 2)
        hint: Not asked when an adult is speaking and the interview is a birth interview by telephone (CATI).
      - predicate: not (AR_Q01.outcome == 1 and not (INTERVIEW_TYPE.outcome == 2))
        hint: Not asked when an adult is speaking and the interview is not a birth interview by telephone (CATI).
      - predicate: not (AR_Q01.outcome == 3 and INTERVIEW_TYPE.outcome in [1, 2])
        hint: Not asked when no adult is available and the interview is a birth interview.
      - predicate: not (AR_Q01.outcome == 3 and INTERVIEW_TYPE.outcome in [3, 4] and SR_Q01.outcome in [4, 5])
        hint: Not asked when no adult is available and the selected respondent is no longer a member or the number is wrong.
      input:
        control: Radio
        labels:
          1: Available
          2: Not available
    - id: ARA_Q01
      kind: Question
      title: When would an adult member of the household be available?
      precondition:
      - predicate: not (AR_Q01.outcome == 1 and INTERVIEW_TYPE.outcome == 2)
        hint: Not asked when an adult is speaking and the interview is a birth interview by telephone (CATI).
      - predicate: not (AR_Q01.outcome == 1 and not (INTERVIEW_TYPE.outcome == 2))
        hint: Not asked when an adult is speaking and the interview is not a birth interview by telephone (CATI).
      - predicate: not (SRA_Q01.outcome == 1)
        hint: Asked only when question SRA_Q01 is not "Available".
      input:
        control: Radio
        labels:
          1: Available
          2: Not available
    - id: TFCC_Q01
      kind: Question
      title: In order to make sure I’ve reached the correct household, I need to confirm your address. Is it … ?
      precondition:
      - predicate: not (AR_Q01.outcome == 1 and not (INTERVIEW_TYPE.outcome == 2))
        hint: Not asked when an adult is speaking and the interview is not a birth interview by telephone (CATI).
      - predicate: not (not (INTERVIEW_TYPE.outcome == 2))
        hint: Asked only when question INTERVIEW_TYPE is "Birth interview by telephone (CATI)".
      - predicate: not (SRA_Q01.outcome == 1)
        hint: Asked only when question SRA_Q01 is not "Available".
      - predicate: not (ARA_Q01.outcome in [1, 2])
        hint: Asked only when question ARA_Q01 is none of "Available", "Not available".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: TFCC_Q02
      kind: Question
      title: I would like to make sure I’ve dialled the right number. Is this … ?
      precondition:
      - predicate: not (AR_Q01.outcome == 1 and not (INTERVIEW_TYPE.outcome == 2))
        hint: Not asked when an adult is speaking and the interview is not a birth interview by telephone (CATI).
      - predicate: not (not (INTERVIEW_TYPE.outcome == 2))
        hint: Asked only when question INTERVIEW_TYPE is "Birth interview by telephone (CATI)".
      - predicate: not (SRA_Q01.outcome == 1)
        hint: Asked only when question SRA_Q01 is not "Available".
      - predicate: not (ARA_Q01.outcome in [1, 2])
        hint: Asked only when question ARA_Q01 is none of "Available", "Not available".
      - predicate: not (TFCC_Q01.outcome == 1)
        hint: Asked only when question TFCC_Q01 is not "Yes".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
  - id: b_s2_introduction
    title: 'Contact component: survey introduction'
    precondition:
    - predicate: not (TC_Q01.outcome == 2)
      hint: Asked only when question TC_Q01 is not "No".
    - predicate: not (SRA_Q01.outcome == 1)
      hint: Asked only when question SRA_Q01 is not "Available".
    - predicate: not (ARA_Q01.outcome in [1, 2])
      hint: Asked only when question ARA_Q01 is none of "Available", "Not available".
    - predicate: not (TFCC_Q02.outcome in [1, 2])
      hint: Asked only when question TFCC_Q02 is none of "Yes", "No".
    items:
    - id: IC_R01
      kind: Question
      title: I’m calling regarding the Labour Force Survey.
      input:
        control: Radio
        labels:
          1: Introduction read
    - id: LP_Q01
      kind: Question
      title: Would you prefer to be interviewed in English or in French?
      input:
        control: Radio
        labels:
          1: English
          2: French
    - id: MON_R01
      kind: Question
      title: My supervisor may listen to this call for the purpose of quality control.
      precondition:
      - predicate: not (CATI_INTERVIEW.outcome == 2)
        hint: Asked only when question CATI_INTERVIEW is not "No".
      input:
        control: Radio
        labels:
          1: Statement read
  - id: b_s3_listing
    title: 'Household component: listing address'
    precondition:
    - predicate: not (TC_Q01.outcome == 2)
      hint: Asked only when question TC_Q01 is not "No".
    - predicate: not (SRA_Q01.outcome == 1)
      hint: Asked only when question SRA_Q01 is not "Available".
    - predicate: not (ARA_Q01.outcome in [1, 2])
      hint: Asked only when question ARA_Q01 is none of "Available", "Not available".
    - predicate: not (TFCC_Q02.outcome in [1, 2])
      hint: Asked only when question TFCC_Q02 is none of "Yes", "No".
    items:
    - id: LA_N01
      kind: Question
      title: Confirm the listing address.
      input:
        control: Textarea
  - id: b_s3_address
    title: 'Household component: address confirmation'
    precondition:
    - predicate: not (TC_Q01.outcome == 2)
      hint: Asked only when question TC_Q01 is not "No".
    - predicate: not (SRA_Q01.outcome == 1)
      hint: Asked only when question SRA_Q01 is not "Available".
    - predicate: not (ARA_Q01.outcome in [1, 2])
      hint: Asked only when question ARA_Q01 is none of "Available", "Not available".
    - predicate: not (TFCC_Q02.outcome in [1, 2])
      hint: Asked only when question TFCC_Q02 is none of "Yes", "No".
    - predicate: not (INTERVIEW_TYPE.outcome == 2)
      hint: Asked only when question INTERVIEW_TYPE is not "Birth interview by telephone (CATI)".
    - predicate: not (INTERVIEW_TYPE.outcome == 3)
      hint: Asked only when question INTERVIEW_TYPE is not "Subsequent interview in person".
    - predicate: not (INTERVIEW_TYPE.outcome == 1)
      hint: Asked only when question INTERVIEW_TYPE is not "Birth interview in person".
    items:
    - id: SD_Q01
      kind: Question
      title: I would like to confirm your address. Are you still living at … ?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Respondent never lived there
    - id: SD_Q02
      kind: Question
      title: Does anyone who was living with you at that address still live there?
      precondition:
      - predicate: not (SD_Q01.outcome == 1 and LISTING_SAME_AS_MAILING.outcome == 1)
        hint: Not asked when the respondent still lives at the listing address that is also the mailing address.
      - predicate: not (SD_Q01.outcome == 1 and LISTING_SAME_AS_MAILING.outcome == 2)
        hint: Not asked when the respondent still lives at the listing address and the mailing address differs.
      - predicate: not (SD_Q01.outcome == 3)
        hint: Asked only when question SD_Q01 is not "Respondent never lived there".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: SD_Q03
      kind: Question
      title: Can you provide me with the current telephone number for that address?
      precondition:
      - predicate: not (SD_Q01.outcome == 1 and LISTING_SAME_AS_MAILING.outcome == 1)
        hint: Not asked when the respondent still lives at the listing address that is also the mailing address.
      - predicate: not (SD_Q01.outcome == 1 and LISTING_SAME_AS_MAILING.outcome == 2)
        hint: Not asked when the respondent still lives at the listing address and the mailing address differs.
      - predicate: not (SD_Q01.outcome == 3)
        hint: Asked only when question SD_Q01 is not "Respondent never lived there".
      - predicate: not (SD_Q02.outcome == 2)
        hint: Asked only when question SD_Q02 is not "No".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: SD_Q04
      kind: Question
      title: What is that telephone number, including the area code?
      precondition:
      - predicate: not (SD_Q01.outcome == 1 and LISTING_SAME_AS_MAILING.outcome == 1)
        hint: Not asked when the respondent still lives at the listing address that is also the mailing address.
      - predicate: not (SD_Q01.outcome == 1 and LISTING_SAME_AS_MAILING.outcome == 2)
        hint: Not asked when the respondent still lives at the listing address and the mailing address differs.
      - predicate: not (SD_Q01.outcome == 3)
        hint: Asked only when question SD_Q01 is not "Respondent never lived there".
      - predicate: not (SD_Q02.outcome == 2)
        hint: Asked only when question SD_Q02 is not "No".
      - predicate: not (SD_Q03.outcome == 2)
        hint: Asked only when question SD_Q03 is not "No".
      input:
        control: Textarea
    - id: SD_Q05
      kind: Question
      title: I would like to make sure I’ve dialled the right number. Is this … ?
      precondition:
      - predicate: not (SD_Q01.outcome == 1 and LISTING_SAME_AS_MAILING.outcome == 1)
        hint: Not asked when the respondent still lives at the listing address that is also the mailing address.
      - predicate: not (SD_Q01.outcome == 1 and LISTING_SAME_AS_MAILING.outcome == 2)
        hint: Not asked when the respondent still lives at the listing address and the mailing address differs.
      - predicate: not (SD_Q02.outcome == 2)
        hint: Asked only when question SD_Q02 is not "No".
      - predicate: not (SD_Q03.outcome == 2)
        hint: Asked only when question SD_Q03 is not "No".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: CHM_Q01
      kind: Question
      title: Is this also your mailing address?
      precondition:
      - predicate: not (SD_Q01.outcome == 1 and LISTING_SAME_AS_MAILING.outcome == 2)
        hint: Not asked when the respondent still lives at the listing address and the mailing address differs.
      - predicate: not (SD_Q02.outcome == 2)
        hint: Asked only when question SD_Q02 is not "No".
      - predicate: not (SD_Q03.outcome == 2)
        hint: Asked only when question SD_Q03 is not "No".
      - predicate: not (SD_Q05.outcome in [1, 2])
        hint: Asked only when question SD_Q05 is none of "Yes", "No".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
  - id: b_s3_household
    title: 'Household component: mailing address, dwelling and members'
    precondition:
    - predicate: not (TC_Q01.outcome == 2)
      hint: Asked only when question TC_Q01 is not "No".
    - predicate: not (SRA_Q01.outcome == 1)
      hint: Asked only when question SRA_Q01 is not "Available".
    - predicate: not (ARA_Q01.outcome in [1, 2])
      hint: Asked only when question ARA_Q01 is none of "Available", "Not available".
    - predicate: not (TFCC_Q02.outcome in [1, 2])
      hint: Asked only when question TFCC_Q02 is none of "Yes", "No".
    - predicate: not (SD_Q02.outcome == 2)
      hint: Asked only when question SD_Q02 is not "No".
    - predicate: not (SD_Q03.outcome == 2)
      hint: Asked only when question SD_Q03 is not "No".
    - predicate: not (SD_Q05.outcome in [1, 2])
      hint: Asked only when question SD_Q05 is none of "Yes", "No".
    items:
    - id: CMA_Q01
      kind: Question
      title: I would like to confirm your mailing address. Is it … ?
      precondition:
      - predicate: not (INTERVIEW_TYPE.outcome == 2)
        hint: Asked only when question INTERVIEW_TYPE is not "Birth interview by telephone (CATI)".
      - predicate: not (INTERVIEW_TYPE.outcome == 1)
        hint: Asked only when question INTERVIEW_TYPE is not "Birth interview in person".
      - predicate: not (CHM_Q01.outcome == 1)
        hint: Asked only when question CHM_Q01 is not "Yes".
      - predicate: not (CHM_Q01.outcome == 2)
        hint: Asked only when question CHM_Q01 is not "No".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: MA_Q01
      kind: Question
      title: What is your correct mailing address?
      precondition:
      - predicate: not (CHM_Q01.outcome == 1)
        hint: Asked only when question CHM_Q01 is not "Yes".
      - predicate: not (CMA_Q01.outcome == 1)
        hint: Asked only when question CMA_Q01 is not "Yes".
      input:
        control: Textarea
    - id: DW_Q01
      kind: Question
      title: 'What type of dwelling do you live in? Is it a: Read categories to respondent.'
      precondition:
      - predicate: not (CHM_Q01.outcome == 1)
        hint: Asked only when question CHM_Q01 is not "Yes".
      - predicate: not (CMA_Q01.outcome == 1)
        hint: Asked only when question CMA_Q01 is not "Yes".
      - predicate: not (INTERVIEW_TYPE.outcome == 1)
        hint: Asked only when question INTERVIEW_TYPE is not "Birth interview in person".
      - predicate: not (INTERVIEW_TYPE.outcome in [3, 4])
        hint: Asked only when question INTERVIEW_TYPE is none of "Subsequent interview in person", "Subsequent interview by telephone".
      input:
        control: Dropdown
        labels:
          1: Dwelling type categories not given in the source
    - id: DW_N02
      kind: Question
      title: Select the dwelling type.
      precondition:
      - predicate: not (CHM_Q01.outcome == 1)
        hint: Asked only when question CHM_Q01 is not "Yes".
      - predicate: not (CMA_Q01.outcome == 1)
        hint: Asked only when question CMA_Q01 is not "Yes".
      - predicate: not (INTERVIEW_TYPE.outcome in [3, 4])
        hint: Asked only when question INTERVIEW_TYPE is none of "Subsequent interview in person", "Subsequent interview by telephone".
      input:
        control: Dropdown
        labels:
          1: Dwelling type categories not given in the source
    - id: TN_Q01
      kind: Question
      title: Is this dwelling owned by a member of this household?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: RS_R01
      kind: Question
      title: The next few questions ask for important basic information about the people in your household.
      input:
        control: Radio
        labels:
          1: Introduction read
    - id: USU_Q01
      kind: Question
      title: What are the names of all persons who usually live here? Begin with adults who have responsibility for the care or support of the family.
      precondition:
      - predicate: not (INTERVIEW_TYPE.outcome in [3, 4])
        hint: Asked only when question INTERVIEW_TYPE is none of "Subsequent interview in person", "Subsequent interview by telephone".
      input:
        control: Textarea
    - id: RS_Q02
      kind: Question
      title: Is anyone staying here temporarily?
      precondition:
      - predicate: not (INTERVIEW_TYPE.outcome in [3, 4])
        hint: Asked only when question INTERVIEW_TYPE is none of "Subsequent interview in person", "Subsequent interview by telephone".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: TEM_Q01
      kind: Question
      title: What are the names of all persons who are staying here temporarily? Add a person only if he/she has no other usual residence elsewhere.
      precondition:
      - predicate: not (INTERVIEW_TYPE.outcome in [3, 4])
        hint: Asked only when question INTERVIEW_TYPE is none of "Subsequent interview in person", "Subsequent interview by telephone".
      - predicate: not (RS_Q02.outcome == 2)
        hint: Asked only when question RS_Q02 is not "No".
      input:
        control: Textarea
    - id: RS_Q04
      kind: Question
      title: Are there any other persons who usually live here but are now away at school, in hospital, or somewhere else?
      precondition:
      - predicate: not (INTERVIEW_TYPE.outcome in [3, 4])
        hint: Asked only when question INTERVIEW_TYPE is none of "Subsequent interview in person", "Subsequent interview by telephone".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: OTH1_Q01
      kind: Question
      title: What are the names of the other people who live or stay here? Add a person only if he/she has no other usual residence elsewhere.
      precondition:
      - predicate: not (INTERVIEW_TYPE.outcome in [3, 4])
        hint: Asked only when question INTERVIEW_TYPE is none of "Subsequent interview in person", "Subsequent interview by telephone".
      - predicate: not (RS_Q04.outcome == 2)
        hint: Asked only when question RS_Q04 is not "No".
      input:
        control: Textarea
    - id: PV2_Q01
      kind: Question
      title: Do the following people still live or stay in this dwelling?
      precondition:
      - predicate: not (RS_Q04.outcome == 2)
        hint: Asked only when question RS_Q04 is not "No".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: RES_Q02
      kind: Question
      title: Is … no longer a member of the household or deceased?
      precondition:
      - predicate: not (RS_Q04.outcome == 2)
        hint: Asked only when question RS_Q04 is not "No".
      - predicate: not (PV2_Q01.outcome == 1)
        hint: Asked only when question PV2_Q01 is not "Yes".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: RS_Q05
      kind: Question
      title: Does anyone else now live or stay here?
      precondition:
      - predicate: not (RS_Q04.outcome == 2)
        hint: Asked only when question RS_Q04 is not "No".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: OTH2_Q01
      kind: Question
      title: What are the names of the other people who live or stay here? Add a person only if he/she has no other usual residence elsewhere.
      precondition:
      - predicate: not (RS_Q04.outcome == 2)
        hint: Asked only when question RS_Q04 is not "No".
      - predicate: not (RS_Q05.outcome == 2)
        hint: Asked only when question RS_Q05 is not "No".
      input:
        control: Textarea
  - id: b_s4_age
    title: 'Individual demographics: age'
    precondition:
    - predicate: not (TC_Q01.outcome == 2)
      hint: Asked only when question TC_Q01 is not "No".
    - predicate: not (SRA_Q01.outcome == 1)
      hint: Asked only when question SRA_Q01 is not "Available".
    - predicate: not (ARA_Q01.outcome in [1, 2])
      hint: Asked only when question ARA_Q01 is none of "Available", "Not available".
    - predicate: not (TFCC_Q02.outcome in [1, 2])
      hint: Asked only when question TFCC_Q02 is none of "Yes", "No".
    - predicate: not (SD_Q02.outcome == 2)
      hint: Asked only when question SD_Q02 is not "No".
    - predicate: not (SD_Q03.outcome == 2)
      hint: Asked only when question SD_Q03 is not "No".
    - predicate: not (SD_Q05.outcome in [1, 2])
      hint: Asked only when question SD_Q05 is none of "Yes", "No".
    items:
    - id: ANC_Q01
      kind: Question
      title: What is …’s date of birth?
      input:
        control: Textarea
    - id: ANC_Q02
      kind: Question
      title: So …’s age on [date of last day of reference week] was [calculated age]. Is that correct?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: ANC_Q03
      kind: Question
      title: What is …’s age?
      precondition:
      - predicate: not (ANC_Q02.outcome == 1)
        hint: Asked only when question ANC_Q02 is not "Yes".
      input:
        control: Editbox
        min: 0
        max: 120
  - id: b_s4_identity
    title: 'Individual demographics: sex, marital status, family, birthplace'
    precondition:
    - predicate: not (TC_Q01.outcome == 2)
      hint: Asked only when question TC_Q01 is not "No".
    - predicate: not (SRA_Q01.outcome == 1)
      hint: Asked only when question SRA_Q01 is not "Available".
    - predicate: not (ARA_Q01.outcome in [1, 2])
      hint: Asked only when question ARA_Q01 is none of "Available", "Not available".
    - predicate: not (TFCC_Q02.outcome in [1, 2])
      hint: Asked only when question TFCC_Q02 is none of "Yes", "No".
    - predicate: not (SD_Q02.outcome == 2)
      hint: Asked only when question SD_Q02 is not "No".
    - predicate: not (SD_Q03.outcome == 2)
      hint: Asked only when question SD_Q03 is not "No".
    - predicate: not (SD_Q05.outcome in [1, 2])
      hint: Asked only when question SD_Q05 is none of "Yes", "No".
    items:
    - id: SEX_Q01
      kind: Question
      title: Enter …’s sex.
      input:
        control: Editbox
        min: 1
        max: 99
        left: Code
    - id: MSNC_Q01
      kind: Question
      title: 'What is …’s marital status? Is he/she: Read categories to respondent.'
      input:
        control: Editbox
        min: 1
        max: 99
        left: Code
    - id: FI_N01
      kind: Question
      title: 'Enter …’s family identifier: A to Z. Assign the same letter to all persons related by blood, marriage or adoption.'
      input:
        control: Textarea
        maxLength: 1
    - id: RR_N01
      kind: Question
      title: Determine a reference person for the family and select …’s relationship to that reference person. The reference person should be an adult involved in the care or support of the family.
      input:
        control: Editbox
        min: 1
        max: 99
        left: Code
    - id: IMM_Q01
      kind: Question
      title: In what country was … born? Specify country of birth according to current boundaries.
      input:
        control: Editbox
        min: 1
        max: 999
        left: Country code (1 = 01-Canada)
  - id: b_s4_immigration
    title: 'Individual demographics: immigration'
    precondition:
    - predicate: not (TC_Q01.outcome == 2)
      hint: Asked only when question TC_Q01 is not "No".
    - predicate: not (SRA_Q01.outcome == 1)
      hint: Asked only when question SRA_Q01 is not "Available".
    - predicate: not (ARA_Q01.outcome in [1, 2])
      hint: Asked only when question ARA_Q01 is none of "Available", "Not available".
    - predicate: not (TFCC_Q02.outcome in [1, 2])
      hint: Asked only when question TFCC_Q02 is none of "Yes", "No".
    - predicate: not (SD_Q02.outcome == 2)
      hint: Asked only when question SD_Q02 is not "No".
    - predicate: not (SD_Q03.outcome == 2)
      hint: Asked only when question SD_Q03 is not "No".
    - predicate: not (SD_Q05.outcome in [1, 2])
      hint: Asked only when question SD_Q05 is none of "Yes", "No".
    - predicate: not (IMM_Q01.outcome == 1)
      hint: Asked only when question IMM_Q01 is not "01-Canada".
    items:
    - id: IMM_Q02
      kind: Question
      title: Is ... now, or has he/she ever been, a landed immigrant in Canada? A landed immigrant (permanent resident) is a person who has been granted the right to live in Canada permanently by immigration authorities.
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: IMM_Q03
      kind: Question
      title: 'In what year did … first become a landed immigrant? Year:'
      precondition:
      - predicate: not (IMM_Q02.outcome == 2)
        hint: Asked only when question IMM_Q02 is not "No".
      postcondition:
      - predicate: IMM_Q03.outcome <= CURRENT_YEAR.outcome
        hint: The year the person became a landed immigrant (IMM_Q03) cannot be later than the current year. Please correct the year.
        invented: true
      input:
        control: Editbox
        min: 1900
        max: 2100
    - id: IMM_Q04
      kind: Question
      title: 'In what month? Month:'
      precondition:
      - predicate: not (IMM_Q02.outcome == 2)
        hint: Asked only when question IMM_Q02 is not "No".
      input:
        control: Range
        min: 1
        max: 12
        step: 1
  - id: b_s4_aboriginal
    title: 'Individual demographics: Aboriginal identity'
    precondition:
    - predicate: not (TC_Q01.outcome == 2)
      hint: Asked only when question TC_Q01 is not "No".
    - predicate: not (SRA_Q01.outcome == 1)
      hint: Asked only when question SRA_Q01 is not "Available".
    - predicate: not (ARA_Q01.outcome in [1, 2])
      hint: Asked only when question ARA_Q01 is none of "Available", "Not available".
    - predicate: not (TFCC_Q02.outcome in [1, 2])
      hint: Asked only when question TFCC_Q02 is none of "Yes", "No".
    - predicate: not (SD_Q02.outcome == 2)
      hint: Asked only when question SD_Q02 is not "No".
    - predicate: not (SD_Q03.outcome == 2)
      hint: Asked only when question SD_Q03 is not "No".
    - predicate: not (SD_Q05.outcome in [1, 2])
      hint: Asked only when question SD_Q05 is none of "Yes", "No".
    items:
    - id: ABO_Q01
      kind: Question
      title: Is ... an Aboriginal person, that is, North American Indian, Métis or Inuit?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: ABO_Q02
      kind: Question
      title: 'If respondent has already specified the Aboriginal group(s), select the group(s) from list below; if not, ask: Is ... a North American Indian, Métis or Inuit? Mark all that apply.'
      precondition:
      - predicate: not (BIRTH_COUNTRY_NA.outcome == 2)
        hint: Asked only when question BIRTH_COUNTRY_NA is not "No".
      - predicate: not (ABO_Q01.outcome == 2)
        hint: Asked only when question ABO_Q01 is not "No".
      input:
        control: Checkbox
        labels:
          1: North American Indian
          2: Métis
          4: Inuit
  - id: b_s4_schooling
    title: 'Individual demographics: schooling'
    precondition:
    - predicate: not (TC_Q01.outcome == 2)
      hint: Asked only when question TC_Q01 is not "No".
    - predicate: not (SRA_Q01.outcome == 1)
      hint: Asked only when question SRA_Q01 is not "Available".
    - predicate: not (ARA_Q01.outcome in [1, 2])
      hint: Asked only when question ARA_Q01 is none of "Available", "Not available".
    - predicate: not (TFCC_Q02.outcome in [1, 2])
      hint: Asked only when question TFCC_Q02 is none of "Yes", "No".
    - predicate: not (SD_Q02.outcome == 2)
      hint: Asked only when question SD_Q02 is not "No".
    - predicate: not (SD_Q03.outcome == 2)
      hint: Asked only when question SD_Q03 is not "No".
    - predicate: not (SD_Q05.outcome in [1, 2])
      hint: Asked only when question SD_Q05 is none of "Yes", "No".
    items:
    - id: ED_Q01
      kind: Question
      title: What is the highest grade of elementary or high school … ever completed?
      input:
        control: Radio
        labels:
          1: Grade 8 or lower
          2: Grade 9 – 10
          3: Grade 11 – 13
  - id: b_s4_education_14plus
    title: 'Individual demographics: education (age 14 and over)'
    precondition:
    - predicate: not (TC_Q01.outcome == 2)
      hint: Asked only when question TC_Q01 is not "No".
    - predicate: not (SRA_Q01.outcome == 1)
      hint: Asked only when question SRA_Q01 is not "Available".
    - predicate: not (ARA_Q01.outcome in [1, 2])
      hint: Asked only when question ARA_Q01 is none of "Available", "Not available".
    - predicate: not (TFCC_Q02.outcome in [1, 2])
      hint: Asked only when question TFCC_Q02 is none of "Yes", "No".
    - predicate: not (SD_Q02.outcome == 2)
      hint: Asked only when question SD_Q02 is not "No".
    - predicate: not (SD_Q03.outcome == 2)
      hint: Asked only when question SD_Q03 is not "No".
    - predicate: not (SD_Q05.outcome in [1, 2])
      hint: Asked only when question SD_Q05 is none of "Yes", "No".
    - predicate: not (AGE.outcome < 14)
      hint: Asked only of persons aged 14 or older.
    items:
    - id: ED_Q02
      kind: Question
      title: Did … graduate from high school (secondary school)?
      precondition:
      - predicate: not (ED_Q01.outcome in [1, 2])
        hint: Asked only when question ED_Q01 is none of "Grade 8 or lower", "Grade 9 – 10".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: ED_Q03
      kind: Question
      title: Has … received any other education that could be counted towards a degree, certificate or diploma from an educational institution?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: ED_Q04
      kind: Question
      title: What is the highest degree, certificate or diploma … has obtained?
      precondition:
      - predicate: not (ED_Q03.outcome == 2)
        hint: Asked only when question ED_Q03 is not "No".
      input:
        control: Editbox
        min: 1
        max: 99
        left: Code
    - id: CHE_Q01
      kind: Question
      title: In what country did … complete his/her highest degree, certificate or diploma? Specify country of highest education according to current boundaries.
      precondition:
      - predicate: not (ED_Q03.outcome == 2)
        hint: Asked only when question ED_Q03 is not "No".
      input:
        control: Editbox
        min: 1
        max: 999
        left: Country code
  - id: b_s4_armed_forces
    title: 'Individual demographics: Armed Forces'
    precondition:
    - predicate: not (TC_Q01.outcome == 2)
      hint: Asked only when question TC_Q01 is not "No".
    - predicate: not (SRA_Q01.outcome == 1)
      hint: Asked only when question SRA_Q01 is not "Available".
    - predicate: not (ARA_Q01.outcome in [1, 2])
      hint: Asked only when question ARA_Q01 is none of "Available", "Not available".
    - predicate: not (TFCC_Q02.outcome in [1, 2])
      hint: Asked only when question TFCC_Q02 is none of "Yes", "No".
    - predicate: not (SD_Q02.outcome == 2)
      hint: Asked only when question SD_Q02 is not "No".
    - predicate: not (SD_Q03.outcome == 2)
      hint: Asked only when question SD_Q03 is not "No".
    - predicate: not (SD_Q05.outcome in [1, 2])
      hint: Asked only when question SD_Q05 is none of "Yes", "No".
    items:
    - id: CAF_Q01
      kind: Question
      title: Is … a full-time member of the regular Canadian Armed Forces?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
  - id: b_s5_rent_basic
    title: Rent component
    precondition:
    - predicate: not (TC_Q01.outcome == 2)
      hint: Asked only when question TC_Q01 is not "No".
    - predicate: not (SRA_Q01.outcome == 1)
      hint: Asked only when question SRA_Q01 is not "Available".
    - predicate: not (ARA_Q01.outcome in [1, 2])
      hint: Asked only when question ARA_Q01 is none of "Available", "Not available".
    - predicate: not (TFCC_Q02.outcome in [1, 2])
      hint: Asked only when question TFCC_Q02 is none of "Yes", "No".
    - predicate: not (SD_Q02.outcome == 2)
      hint: Asked only when question SD_Q02 is not "No".
    - predicate: not (SD_Q03.outcome == 2)
      hint: Asked only when question SD_Q03 is not "No".
    - predicate: not (SD_Q05.outcome in [1, 2])
      hint: Asked only when question SD_Q05 is none of "Yes", "No".
    - predicate: not (CAF_Q01.outcome == 2 and AGE.outcome >= 15)
      hint: Not asked when CAF_Q01 is "No" and AGE is 15 or older.
    - predicate: TN_Q01.outcome == 2 and not (PROVINCE.outcome in [1, 2, 3])
      hint: Asked only when TN_Q01 is 2 and PROVINCE is not one of 1, 2, 3.
    items:
    - id: RRF_R01
      kind: Question
      title: The next few questions are about your rent. The information collected is used to calculate the rent portion of the Consumer Price Index.
      input:
        control: Radio
        labels:
          1: Introduction read
    - id: RM_Q01
      kind: Question
      title: On which floor do you live?
      input:
        control: Editbox
        min: 0
        max: 150
    - id: RM_Q02
      kind: Question
      title: To the best of your knowledge, how old is your building?
      precondition:
      - predicate: not (RENT_PREV.outcome == 1)
        hint: Asked only when question RENT_PREV is not "Yes".
      input:
        control: Editbox
        min: 0
        max: 500
    - id: RM_Q03
      kind: Question
      title: How many bedrooms are there in your dwelling?
      precondition:
      - predicate: not (RENT_PREV.outcome == 1)
        hint: Asked only when question RENT_PREV is not "Yes".
      input:
        control: Editbox
        min: 0
        max: 30
    - id: RM_Q04
      kind: Question
      title: This month, is the rent for your dwelling subsidized by government or an employer, or a relative?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: RM_Q04A
      kind: Question
      title: In what manner is the rent for your dwelling subsidized?
      precondition:
      - predicate: not (RM_Q04.outcome == 2)
        hint: Asked only when question RM_Q04 is not "No".
      input:
        control: Textarea
    - id: RM_Q05
      kind: Question
      title: This month, is the rent for your dwelling applied to both living and business accommodation?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: RM_Q05A
      kind: Question
      title: Does the business affect the amount of rent paid?
      precondition:
      - predicate: not (RM_Q05.outcome == 2)
        hint: Asked only when question RM_Q05 is not "No".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: RM_Q06
      kind: Question
      title: How much is the total monthly rent for your dwelling?
      input:
        control: Editbox
        min: 0
        max: 99999
        left: $
    - id: RM_Q07
      kind: Question
      title: What is the reason that the rent is $0?
      precondition:
      - predicate: not (RM_Q06.outcome > 0)
        hint: Asked only when the monthly rent in RM_Q06 is $0.
      input:
        control: Textarea
  - id: b_s5_rent_unsubsidized
    title: Rent details (not subsidized)
    precondition:
    - predicate: not (TC_Q01.outcome == 2)
      hint: Asked only when question TC_Q01 is not "No".
    - predicate: not (SRA_Q01.outcome == 1)
      hint: Asked only when question SRA_Q01 is not "Available".
    - predicate: not (ARA_Q01.outcome in [1, 2])
      hint: Asked only when question ARA_Q01 is none of "Available", "Not available".
    - predicate: not (TFCC_Q02.outcome in [1, 2])
      hint: Asked only when question TFCC_Q02 is none of "Yes", "No".
    - predicate: not (SD_Q02.outcome == 2)
      hint: Asked only when question SD_Q02 is not "No".
    - predicate: not (SD_Q03.outcome == 2)
      hint: Asked only when question SD_Q03 is not "No".
    - predicate: not (SD_Q05.outcome in [1, 2])
      hint: Asked only when question SD_Q05 is none of "Yes", "No".
    - predicate: not (CAF_Q01.outcome == 2 and AGE.outcome >= 15)
      hint: Not asked when CAF_Q01 is "No" and AGE is 15 or older.
    - predicate: TN_Q01.outcome == 2 and not (PROVINCE.outcome in [1, 2, 3])
      hint: Asked only when TN_Q01 is 2 and PROVINCE is not one of 1, 2, 3.
    - predicate: not (RM_Q04.outcome == 1)
      hint: Asked only when question RM_Q04 is not "Yes".
    items:
    - id: RM_Q08
      kind: Question
      title: Since last month, have there been any changes in the amount of rent paid?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: RM_Q08A
      kind: Question
      title: What is the reason for the change in rent since last month? Mark all that apply.
      precondition:
      - predicate: not (RENT_PREV.outcome == 2)
        hint: Asked only when question RENT_PREV is not "No".
      - predicate: not (HH_CHANGE.outcome == 1)
        hint: Asked only when question HH_CHANGE is not "Yes".
      - predicate: not (RM_Q08.outcome == 2)
        hint: Asked only when question RM_Q08 is not "No".
      input:
        control: Checkbox
        labels:
          1: Change in utilities, services, appliances, or furnishings
    - id: RM_Q09B
      kind: Question
      title: Does this month’s rent include parking facilities?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: RM_Q09S
      kind: Question
      title: Since last month, have there been any changes in the parking facilities?
      precondition:
      - predicate: not (DWELLING_APARTMENT.outcome == 2)
        hint: Asked only when question DWELLING_APARTMENT is not "No".
      - predicate: not (RM_Q09B.outcome == 2)
        hint: Asked only when question RM_Q09B is not "No".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: RM_Q10
      kind: Question
      title: What types of parking facilities are included in your rent? Mark all that apply.
      precondition:
      - predicate: not (DWELLING_APARTMENT.outcome == 2)
        hint: Asked only when question DWELLING_APARTMENT is not "No".
      - predicate: not (RM_Q09B.outcome == 2)
        hint: Asked only when question RM_Q09B is not "No".
      - predicate: not (RM_Q09S.outcome == 2)
        hint: Asked only when question RM_Q09S is not "No".
      input:
        control: Checkbox
        labels:
          1: Closed garage or indoor parking
          2: Outside parking with plug-in
          4: Outside parking without plug-in
    - id: RM_Q11
      kind: Question
      title: How many closed garage or indoor parking spaces are included in your rent?
      precondition:
      - predicate: not (DWELLING_APARTMENT.outcome == 2)
        hint: Asked only when question DWELLING_APARTMENT is not "No".
      - predicate: not (RM_Q09B.outcome == 2)
        hint: Asked only when question RM_Q09B is not "No".
      - predicate: not (RM_Q09S.outcome == 2)
        hint: Asked only when question RM_Q09S is not "No".
      input:
        control: Editbox
        min: 0
        max: 50
    - id: RM_Q12
      kind: Question
      title: How many outside parking spaces with plug-in are included in your rent?
      precondition:
      - predicate: not (DWELLING_APARTMENT.outcome == 2)
        hint: Asked only when question DWELLING_APARTMENT is not "No".
      - predicate: not (RM_Q09B.outcome == 2)
        hint: Asked only when question RM_Q09B is not "No".
      - predicate: not (RM_Q09S.outcome == 2)
        hint: Asked only when question RM_Q09S is not "No".
      input:
        control: Editbox
        min: 0
        max: 50
    - id: RM_Q13
      kind: Question
      title: How many outside parking spaces without plug-in are included in your rent?
      precondition:
      - predicate: not (DWELLING_APARTMENT.outcome == 2)
        hint: Asked only when question DWELLING_APARTMENT is not "No".
      - predicate: not (RM_Q09B.outcome == 2)
        hint: Asked only when question RM_Q09B is not "No".
      - predicate: not (RM_Q09S.outcome == 2)
        hint: Asked only when question RM_Q09S is not "No".
      input:
        control: Editbox
        min: 0
        max: 50
    - id: RM_Q14
      kind: Question
      title: Since last month, have there been any changes in the utilities, services, appliances, or furnishings included in the rent?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: RM_Q15
      kind: Question
      title: Which of the following utilities, services, appliances, or furnishings are included as part of the monthly rent? Read list to respondent. Mark all that apply.
      precondition:
      - predicate: not (RM_Q14.outcome == 2)
        hint: Asked only when question RM_Q14 is not "No".
      input:
        control: Textarea
  - id: b_s6_work_last_week
    title: 'Job attachment: work last week'
    precondition:
    - predicate: not (TC_Q01.outcome == 2)
      hint: Asked only when question TC_Q01 is not "No".
    - predicate: not (SRA_Q01.outcome == 1)
      hint: Asked only when question SRA_Q01 is not "Available".
    - predicate: not (ARA_Q01.outcome in [1, 2])
      hint: Asked only when question ARA_Q01 is none of "Available", "Not available".
    - predicate: not (TFCC_Q02.outcome in [1, 2])
      hint: Asked only when question TFCC_Q02 is none of "Yes", "No".
    - predicate: not (SD_Q02.outcome == 2)
      hint: Asked only when question SD_Q02 is not "No".
    - predicate: not (SD_Q03.outcome == 2)
      hint: Asked only when question SD_Q03 is not "No".
    - predicate: not (SD_Q05.outcome in [1, 2])
      hint: Asked only when question SD_Q05 is none of "Yes", "No".
    items:
    - id: Q100
      kind: Question
      title: Many of the following questions concern ...’s activities last week. By last week, I mean the week beginning on Sunday, [date of first day of reference week], and ending last Saturday [date of last day of reference week]. Last week, did ... work at a job or business? (regardless of the number of hours)
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Permanently unable to work
  - id: b_s6_absence_multiple_jobs
    title: 'Job attachment: absence and multiple jobs'
    precondition:
    - predicate: not (TC_Q01.outcome == 2)
      hint: Asked only when question TC_Q01 is not "No".
    - predicate: not (SRA_Q01.outcome == 1)
      hint: Asked only when question SRA_Q01 is not "Available".
    - predicate: not (ARA_Q01.outcome in [1, 2])
      hint: Asked only when question ARA_Q01 is none of "Available", "Not available".
    - predicate: not (TFCC_Q02.outcome in [1, 2])
      hint: Asked only when question TFCC_Q02 is none of "Yes", "No".
    - predicate: not (SD_Q02.outcome == 2)
      hint: Asked only when question SD_Q02 is not "No".
    - predicate: not (SD_Q03.outcome == 2)
      hint: Asked only when question SD_Q03 is not "No".
    - predicate: not (SD_Q05.outcome in [1, 2])
      hint: Asked only when question SD_Q05 is none of "Yes", "No".
    - predicate: not (Q100.outcome == 3)
      hint: Asked only when question 100 is not "Permanently unable to work".
    items:
    - id: Q101
      kind: Question
      title: Last week, did ... have a job or business from which he/she was absent?
      precondition:
      - predicate: not (Q100.outcome == 1)
        hint: Asked only when question 100 is not "Yes".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: Q102
      kind: Question
      title: Did he/she have more than one job or business last week?
      precondition:
      - predicate: not (Q101.outcome == 2)
        hint: Asked only when question 101 is not "No".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: Q103
      kind: Question
      title: Was this a result of changing employers?
      precondition:
      - predicate: not (Q101.outcome == 2)
        hint: Asked only when question 101 is not "No".
      - predicate: not (Q102.outcome == 2)
        hint: Asked only when question 102 is not "No".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
  - id: b_s6_past_work
    title: 'Job attachment: past work'
    precondition:
    - predicate: not (TC_Q01.outcome == 2)
      hint: Asked only when question TC_Q01 is not "No".
    - predicate: not (SRA_Q01.outcome == 1)
      hint: Asked only when question SRA_Q01 is not "Available".
    - predicate: not (ARA_Q01.outcome in [1, 2])
      hint: Asked only when question ARA_Q01 is none of "Available", "Not available".
    - predicate: not (TFCC_Q02.outcome in [1, 2])
      hint: Asked only when question TFCC_Q02 is none of "Yes", "No".
    - predicate: not (SD_Q02.outcome == 2)
      hint: Asked only when question SD_Q02 is not "No".
    - predicate: not (SD_Q03.outcome == 2)
      hint: Asked only when question SD_Q03 is not "No".
    - predicate: not (SD_Q05.outcome in [1, 2])
      hint: Asked only when question SD_Q05 is none of "Yes", "No".
    - predicate: not (Q102.outcome == 2)
      hint: Asked only when question 102 is not "No".
    - predicate: not (Q103.outcome in [1, 2])
      hint: Asked only when question 103 is none of "Yes", "No".
    items:
    - id: Q104
      kind: Question
      title: Has he/she ever worked at a job or business?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: Q105
      kind: Question
      title: When did he/she last work?
      precondition:
      - predicate: not (Q104.outcome == 2)
        hint: Asked only when question 104 is not "No".
      input:
        control: Textarea
  - id: b_s7_class
    title: Job description
    precondition:
    - predicate: not (TC_Q01.outcome == 2)
      hint: Asked only when question TC_Q01 is not "No".
    - predicate: not (SRA_Q01.outcome == 1)
      hint: Asked only when question SRA_Q01 is not "Available".
    - predicate: not (ARA_Q01.outcome in [1, 2])
      hint: Asked only when question ARA_Q01 is none of "Available", "Not available".
    - predicate: not (TFCC_Q02.outcome in [1, 2])
      hint: Asked only when question TFCC_Q02 is none of "Yes", "No".
    - predicate: not (SD_Q02.outcome == 2)
      hint: Asked only when question SD_Q02 is not "No".
    - predicate: not (SD_Q03.outcome == 2)
      hint: Asked only when question SD_Q03 is not "No".
    - predicate: not (SD_Q05.outcome in [1, 2])
      hint: Asked only when question SD_Q05 is none of "Yes", "No".
    - predicate: not (Q104.outcome == 2)
      hint: Asked only when question 104 is not "No".
    - predicate: not (INTERVIEW_TYPE.outcome in [3, 4] and NO_CHANGE_105.outcome == 1 and PREV_PATH.outcome == 3)
      hint: Not asked when there is no change in the previous job and the previous path was 3.
    - predicate: not (INTERVIEW_TYPE.outcome in [3, 4] and NO_CHANGE_105.outcome == 1 and PREV_PATH.outcome in [4, 5, 6, 7])
      hint: Not asked when there is no change in the previous job and the previous path was 4 to 7.
    - predicate: not (LAST_WORK_OVER_YEAR.outcome == 1)
      hint: Asked only when question LAST_WORK_OVER_YEAR is not "Yes".
    - predicate: not (PATH.outcome == 7)
      hint: Asked only when question PATH is not "Not in labour force, permanently unable to work".
    items:
    - id: Q110
      kind: Question
      title: If 103=yes, I am now going to ask some questions about …’s new job or business. Was he/she an employee or self-employed? If 103 = no, I am now going to ask some questions about the job or business at which he/she usually works the most hours. Was he/she an employee or self-employed? Otherwise, Was he/she an employee or self-employed?
      input:
        control: Radio
        labels:
          1: Employee
          2: Self-employed
  - id: b_s7_self_employed
    title: Business of the self-employed
    precondition:
    - predicate: not (TC_Q01.outcome == 2)
      hint: Asked only when question TC_Q01 is not "No".
    - predicate: not (SRA_Q01.outcome == 1)
      hint: Asked only when question SRA_Q01 is not "Available".
    - predicate: not (ARA_Q01.outcome in [1, 2])
      hint: Asked only when question ARA_Q01 is none of "Available", "Not available".
    - predicate: not (TFCC_Q02.outcome in [1, 2])
      hint: Asked only when question TFCC_Q02 is none of "Yes", "No".
    - predicate: not (SD_Q02.outcome == 2)
      hint: Asked only when question SD_Q02 is not "No".
    - predicate: not (SD_Q03.outcome == 2)
      hint: Asked only when question SD_Q03 is not "No".
    - predicate: not (SD_Q05.outcome in [1, 2])
      hint: Asked only when question SD_Q05 is none of "Yes", "No".
    - predicate: not (Q104.outcome == 2)
      hint: Asked only when question 104 is not "No".
    - predicate: not (INTERVIEW_TYPE.outcome in [3, 4] and NO_CHANGE_105.outcome == 1 and PREV_PATH.outcome == 3)
      hint: Not asked when there is no change in the previous job and the previous path was 3.
    - predicate: not (INTERVIEW_TYPE.outcome in [3, 4] and NO_CHANGE_105.outcome == 1 and PREV_PATH.outcome in [4, 5, 6, 7])
      hint: Not asked when there is no change in the previous job and the previous path was 4 to 7.
    - predicate: not (LAST_WORK_OVER_YEAR.outcome == 1)
      hint: Asked only when question LAST_WORK_OVER_YEAR is not "Yes".
    - predicate: not (PATH.outcome == 7)
      hint: Asked only when question PATH is not "Not in labour force, permanently unable to work".
    - predicate: not (Q110.outcome == 1)
      hint: Asked only when question 110 is not "Employee".
    items:
    - id: Q111
      kind: Question
      title: Did he/she have an incorporated business?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: Q112
      kind: Question
      title: Did he/she have any employees?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: Q113
      kind: Question
      title: What was the name of his/her business?
      input:
        control: Textarea
  - id: b_s7_employer
    title: Employer
    precondition:
    - predicate: not (TC_Q01.outcome == 2)
      hint: Asked only when question TC_Q01 is not "No".
    - predicate: not (SRA_Q01.outcome == 1)
      hint: Asked only when question SRA_Q01 is not "Available".
    - predicate: not (ARA_Q01.outcome in [1, 2])
      hint: Asked only when question ARA_Q01 is none of "Available", "Not available".
    - predicate: not (TFCC_Q02.outcome in [1, 2])
      hint: Asked only when question TFCC_Q02 is none of "Yes", "No".
    - predicate: not (SD_Q02.outcome == 2)
      hint: Asked only when question SD_Q02 is not "No".
    - predicate: not (SD_Q03.outcome == 2)
      hint: Asked only when question SD_Q03 is not "No".
    - predicate: not (SD_Q05.outcome in [1, 2])
      hint: Asked only when question SD_Q05 is none of "Yes", "No".
    - predicate: not (Q104.outcome == 2)
      hint: Asked only when question 104 is not "No".
    - predicate: not (INTERVIEW_TYPE.outcome in [3, 4] and NO_CHANGE_105.outcome == 1 and PREV_PATH.outcome == 3)
      hint: Not asked when there is no change in the previous job and the previous path was 3.
    - predicate: not (INTERVIEW_TYPE.outcome in [3, 4] and NO_CHANGE_105.outcome == 1 and PREV_PATH.outcome in [4, 5, 6, 7])
      hint: Not asked when there is no change in the previous job and the previous path was 4 to 7.
    - predicate: not (LAST_WORK_OVER_YEAR.outcome == 1)
      hint: Asked only when question LAST_WORK_OVER_YEAR is not "Yes".
    - predicate: not (PATH.outcome == 7)
      hint: Asked only when question PATH is not "Not in labour force, permanently unable to work".
    items:
    - id: Q114
      kind: Question
      title: For whom did he/she work?
      precondition:
      - predicate: not (Q110.outcome == 2)
        hint: Asked only when question 110 is not "Self-employed".
      input:
        control: Textarea
  - id: b_s7_work
    title: Business and work done
    precondition:
    - predicate: not (TC_Q01.outcome == 2)
      hint: Asked only when question TC_Q01 is not "No".
    - predicate: not (SRA_Q01.outcome == 1)
      hint: Asked only when question SRA_Q01 is not "Available".
    - predicate: not (ARA_Q01.outcome in [1, 2])
      hint: Asked only when question ARA_Q01 is none of "Available", "Not available".
    - predicate: not (TFCC_Q02.outcome in [1, 2])
      hint: Asked only when question TFCC_Q02 is none of "Yes", "No".
    - predicate: not (SD_Q02.outcome == 2)
      hint: Asked only when question SD_Q02 is not "No".
    - predicate: not (SD_Q03.outcome == 2)
      hint: Asked only when question SD_Q03 is not "No".
    - predicate: not (SD_Q05.outcome in [1, 2])
      hint: Asked only when question SD_Q05 is none of "Yes", "No".
    - predicate: not (Q104.outcome == 2)
      hint: Asked only when question 104 is not "No".
    - predicate: not (INTERVIEW_TYPE.outcome in [3, 4] and NO_CHANGE_105.outcome == 1 and PREV_PATH.outcome == 3)
      hint: Not asked when there is no change in the previous job and the previous path was 3.
    - predicate: not (INTERVIEW_TYPE.outcome in [3, 4] and NO_CHANGE_105.outcome == 1 and PREV_PATH.outcome in [4, 5, 6, 7])
      hint: Not asked when there is no change in the previous job and the previous path was 4 to 7.
    - predicate: not (LAST_WORK_OVER_YEAR.outcome == 1)
      hint: Asked only when question LAST_WORK_OVER_YEAR is not "Yes".
    - predicate: not (PATH.outcome == 7)
      hint: Asked only when question PATH is not "Not in labour force, permanently unable to work".
    items:
    - id: Q115
      kind: Question
      title: What kind of business, industry or service was this?
      input:
        control: Textarea
    - id: Q116
      kind: Question
      title: What kind of work was he/she doing?
      input:
        control: Textarea
    - id: Q117
      kind: Question
      title: What were his/her most important activities or duties?
      input:
        control: Textarea
    - id: Q118
      kind: Question
      title: When did he/she start working for [name of employer]?
      input:
        control: Textarea
  - id: b_s8_absence
    title: 'Absence – Separation: reason for absence'
    precondition:
    - predicate: not (TC_Q01.outcome == 2)
      hint: Asked only when question TC_Q01 is not "No".
    - predicate: not (SRA_Q01.outcome == 1)
      hint: Asked only when question SRA_Q01 is not "Available".
    - predicate: not (ARA_Q01.outcome in [1, 2])
      hint: Asked only when question ARA_Q01 is none of "Available", "Not available".
    - predicate: not (TFCC_Q02.outcome in [1, 2])
      hint: Asked only when question TFCC_Q02 is none of "Yes", "No".
    - predicate: not (SD_Q02.outcome == 2)
      hint: Asked only when question SD_Q02 is not "No".
    - predicate: not (SD_Q03.outcome == 2)
      hint: Asked only when question SD_Q03 is not "No".
    - predicate: not (SD_Q05.outcome in [1, 2])
      hint: Asked only when question SD_Q05 is none of "Yes", "No".
    - predicate: not (Q104.outcome == 2)
      hint: Asked only when question 104 is not "No".
    - predicate: not (INTERVIEW_TYPE.outcome in [3, 4] and NO_CHANGE_105.outcome == 1 and PREV_PATH.outcome in [4, 5, 6, 7])
      hint: Section routing condition from the source.
    - predicate: not (LAST_WORK_OVER_YEAR.outcome == 1)
      hint: Asked only when question LAST_WORK_OVER_YEAR is not "Yes".
    items:
    - id: Q130
      kind: Question
      title: What was the main reason ... was absent from work last week?
      precondition:
      - predicate: not (INTERVIEW_TYPE.outcome in [3, 4] and NO_CHANGE_105.outcome == 1 and PREV_PATH.outcome == 3)
        hint: Not asked when the previous interview already established this and nothing changed.
      - predicate: not (PATH.outcome == 7)
        hint: Asked only when question PATH is not "Not in labour force, permanently unable to work".
      input:
        control: Radio
        labels:
          1: Temporary layoff due to business conditions
          2: Seasonal layoff
          3: Casual job, no work available
          4: Other reason
  - id: b_s8_separation
    title: 'Absence – Separation: reason for job loss'
    precondition:
    - predicate: not (TC_Q01.outcome == 2)
      hint: Asked only when question TC_Q01 is not "No".
    - predicate: not (SRA_Q01.outcome == 1)
      hint: Asked only when question SRA_Q01 is not "Available".
    - predicate: not (ARA_Q01.outcome in [1, 2])
      hint: Asked only when question ARA_Q01 is none of "Available", "Not available".
    - predicate: not (TFCC_Q02.outcome in [1, 2])
      hint: Asked only when question TFCC_Q02 is none of "Yes", "No".
    - predicate: not (SD_Q02.outcome == 2)
      hint: Asked only when question SD_Q02 is not "No".
    - predicate: not (SD_Q03.outcome == 2)
      hint: Asked only when question SD_Q03 is not "No".
    - predicate: not (SD_Q05.outcome in [1, 2])
      hint: Asked only when question SD_Q05 is none of "Yes", "No".
    - predicate: not (Q104.outcome == 2)
      hint: Asked only when question 104 is not "No".
    - predicate: not (INTERVIEW_TYPE.outcome in [3, 4] and NO_CHANGE_105.outcome == 1 and PREV_PATH.outcome in [4, 5, 6, 7])
      hint: Section routing condition from the source.
    - predicate: not (LAST_WORK_OVER_YEAR.outcome == 1)
      hint: Asked only when question LAST_WORK_OVER_YEAR is not "Yes".
    - predicate: not (PATH.outcome == 1)
      hint: Asked only when question PATH is not "Employed, at work".
    - predicate: not (Q130.outcome == 1)
      hint: Asked only when question 130 is not "Temporary layoff due to business conditions".
    - predicate: not (Q130.outcome == 2)
      hint: Asked only when question 130 is not "Seasonal layoff".
    - predicate: not (Q130.outcome == 3)
      hint: Asked only when question 130 is not "Casual job, no work available".
    items:
    - id: Q131
      kind: Question
      title: What was the main reason ... stopped working at that [job/business]?
      input:
        control: Radio
        labels:
          1: Lost job, laid off or job ended
    - id: Q132
      kind: Question
      title: Can you be more specific about the main reason for his/her job loss?
      precondition:
      - predicate: not (not (Q131.outcome == 1))
        hint: Asked only when question 131 is "Lost job, laid off or job ended".
      input:
        control: Radio
        labels:
          1: Business conditions
  - id: b_s8_return
    title: 'Absence – Separation: expected return and layoff'
    precondition:
    - predicate: not (TC_Q01.outcome == 2)
      hint: Asked only when question TC_Q01 is not "No".
    - predicate: not (SRA_Q01.outcome == 1)
      hint: Asked only when question SRA_Q01 is not "Available".
    - predicate: not (ARA_Q01.outcome in [1, 2])
      hint: Asked only when question ARA_Q01 is none of "Available", "Not available".
    - predicate: not (TFCC_Q02.outcome in [1, 2])
      hint: Asked only when question TFCC_Q02 is none of "Yes", "No".
    - predicate: not (SD_Q02.outcome == 2)
      hint: Asked only when question SD_Q02 is not "No".
    - predicate: not (SD_Q03.outcome == 2)
      hint: Asked only when question SD_Q03 is not "No".
    - predicate: not (SD_Q05.outcome in [1, 2])
      hint: Asked only when question SD_Q05 is none of "Yes", "No".
    - predicate: not (Q104.outcome == 2)
      hint: Asked only when question 104 is not "No".
    - predicate: not (INTERVIEW_TYPE.outcome in [3, 4] and NO_CHANGE_105.outcome == 1 and PREV_PATH.outcome in [4, 5, 6, 7])
      hint: Section routing condition from the source.
    - predicate: not (LAST_WORK_OVER_YEAR.outcome == 1)
      hint: Asked only when question LAST_WORK_OVER_YEAR is not "Yes".
    - predicate: not (PATH.outcome == 1)
      hint: Asked only when question PATH is not "Employed, at work".
    - predicate: not (Q130.outcome == 3)
      hint: Asked only when question 130 is not "Casual job, no work available".
    - predicate: not (not (Q131.outcome == 1))
      hint: Asked only when question 131 is "Lost job, laid off or job ended".
    - predicate: not (PATH.outcome == 7)
      hint: Asked only when question PATH is not "Not in labour force, permanently unable to work".
    - predicate: not (not (PATH.outcome == 7) and not (Q132.outcome == 1))
      hint: Section routing condition from the source.
    items:
    - id: Q133
      kind: Question
      title: Does he/she expect to return to that job?
      precondition:
      - predicate: not (Q130.outcome == 1)
        hint: Asked only when question 130 is not "Temporary layoff due to business conditions".
      - predicate: not (Q130.outcome == 2)
        hint: Asked only when question 130 is not "Seasonal layoff".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Not sure
    - id: Q134
      kind: Question
      title: Has ...’s employer given him/her a date to return?
      precondition:
      - predicate: not (Q130.outcome == 2)
        hint: Asked only when question 130 is not "Seasonal layoff".
      - predicate: not (Q133.outcome in [2, 3])
        hint: Asked only when question 133 is none of "No", "Not sure".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: Q135
      kind: Question
      title: Has he/she been given any indication that he/she will be recalled within the next 6 months?
      precondition:
      - predicate: not (Q130.outcome == 2)
        hint: Asked only when question 130 is not "Seasonal layoff".
      - predicate: not (Q133.outcome in [2, 3])
        hint: Asked only when question 133 is none of "No", "Not sure".
      - predicate: not (Q134.outcome == 1)
        hint: Asked only when question 134 is not "Yes".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: Q136
      kind: Question
      title: As of last week, how many weeks had ... been on layoff?
      precondition:
      - predicate: not (Q133.outcome in [2, 3])
        hint: Asked only when question 133 is none of "No", "Not sure".
      input:
        control: Editbox
        min: 0
        max: 999
        right: weeks
  - id: b_s8_hours
    title: 'Absence – Separation: usual hours'
    precondition:
    - predicate: not (TC_Q01.outcome == 2)
      hint: Asked only when question TC_Q01 is not "No".
    - predicate: not (SRA_Q01.outcome == 1)
      hint: Asked only when question SRA_Q01 is not "Available".
    - predicate: not (ARA_Q01.outcome in [1, 2])
      hint: Asked only when question ARA_Q01 is none of "Available", "Not available".
    - predicate: not (TFCC_Q02.outcome in [1, 2])
      hint: Asked only when question TFCC_Q02 is none of "Yes", "No".
    - predicate: not (SD_Q02.outcome == 2)
      hint: Asked only when question SD_Q02 is not "No".
    - predicate: not (SD_Q03.outcome == 2)
      hint: Asked only when question SD_Q03 is not "No".
    - predicate: not (SD_Q05.outcome in [1, 2])
      hint: Asked only when question SD_Q05 is none of "Yes", "No".
    - predicate: not (Q104.outcome == 2)
      hint: Asked only when question 104 is not "No".
    - predicate: not (INTERVIEW_TYPE.outcome in [3, 4] and NO_CHANGE_105.outcome == 1 and PREV_PATH.outcome in [4, 5, 6, 7])
      hint: Section routing condition from the source.
    - predicate: not (LAST_WORK_OVER_YEAR.outcome == 1)
      hint: Asked only when question LAST_WORK_OVER_YEAR is not "Yes".
    - predicate: not (PATH.outcome == 1)
      hint: Asked only when question PATH is not "Employed, at work".
    items:
    - id: Q137
      kind: Question
      title: Did he/she usually work more or less than 30 hours per week?
      input:
        control: Radio
        labels:
          1: Less than 30 hours per week
          2: 30 hours or more per week
  - id: b_s9_usual_hours
    title: 'Work hours (Main job): usual hours'
    precondition: &id001
    - predicate: not (TC_Q01.outcome == 2)
      hint: Asked only when question TC_Q01 is not "No".
    - predicate: not (SRA_Q01.outcome == 1)
      hint: Asked only when question SRA_Q01 is not "Available".
    - predicate: not (ARA_Q01.outcome in [1, 2])
      hint: Asked only when question ARA_Q01 is none of "Available", "Not available".
    - predicate: not (TFCC_Q02.outcome in [1, 2])
      hint: Asked only when question TFCC_Q02 is none of "Yes", "No".
    - predicate: not (SD_Q02.outcome == 2)
      hint: Asked only when question SD_Q02 is not "No".
    - predicate: not (SD_Q03.outcome == 2)
      hint: Asked only when question SD_Q03 is not "No".
    - predicate: not (SD_Q05.outcome in [1, 2])
      hint: Asked only when question SD_Q05 is none of "Yes", "No".
    - predicate: not (Q104.outcome == 2)
      hint: Asked only when question 104 is not "No".
    - predicate: not (INTERVIEW_TYPE.outcome in [3, 4] and NO_CHANGE_105.outcome == 1 and PREV_PATH.outcome in [4, 5, 6, 7])
      hint: Section guard carried over from the source inventory.
    - predicate: not (LAST_WORK_OVER_YEAR.outcome == 1)
      hint: Asked only when question LAST_WORK_OVER_YEAR is not "Yes".
    - predicate: not (PATH.outcome == 3)
      hint: Asked only when question PATH is not "Temporary layoff".
    items:
    - id: Q150
      kind: Question
      title: The following questions refer to ...’s work hours at his/her [new] [job/business] [at name of employer]. If 110 = “Employee”, Excluding overtime, does the number of paid hours ... works vary from week to week? Otherwise, Does the number of hours ... works vary from week to week?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: Q151
      kind: Question
      title: If 110 = “Employee”, Excluding overtime, how many paid hours does ...work per week? Otherwise How many hours does ... work per week?
      precondition:
      - predicate: not (Q150.outcome == 1)
        hint: Asked only when question 150 is not "Yes".
      input:
        control: Editbox
        min: 0
        max: 168
    - id: Q152
      kind: Question
      title: If 110 = “Employee”, Excluding overtime, on average, how many paid hours does ... usually work per week? Otherwise On average, how many hours does ... usually work per week?
      precondition:
      - predicate: not (PATH.outcome == 2)
        hint: Asked only when question PATH is not "Employed, absent from work".
      - predicate: not (Q110.outcome == 1)
        hint: Asked only when question 110 is not "Employee".
      - predicate: not (Q110.outcome == 2)
        hint: Asked only when question 110 is not "Self-employed".
      input:
        control: Editbox
        min: 0
        max: 168
  - id: b_s9_absence_overtime
    title: 'Work hours (Main job): absence and overtime'
    precondition: *id001
    items:
    - id: Q153
      kind: Question
      title: Last week, how many hours was he/she away from this job because of vacation, illness, or any other reason?
      precondition:
      - predicate: not (PATH.outcome == 2)
        hint: Asked only when question PATH is not "Employed, absent from work".
      - predicate: not (Q110.outcome == 2)
        hint: Asked only when question 110 is not "Self-employed".
      postcondition:
      - predicate: Q153.outcome <= 168
        hint: Hours away from work last week (153) cannot exceed the 168 hours in a week. Please correct the answer.
        invented: true
      input:
        control: Editbox
        min: 0
        max: 999
    - id: Q154
      kind: Question
      title: What was the main reason for that absence?
      precondition:
      - predicate: not (PATH.outcome == 2)
        hint: Asked only when question PATH is not "Employed, absent from work".
      - predicate: not (Q110.outcome == 2)
        hint: Asked only when question 110 is not "Self-employed".
      - predicate: not (Q153.outcome == 0)
        hint: Asked only when question 153 is not 0.
      input:
        control: Dropdown
        labels:
          1: Reason 1
          2: Reason 2
          3: Reason 3
    - id: Q155
      kind: Question
      title: Last week, how many hours of paid overtime did he/she work at this job?
      precondition:
      - predicate: not (PATH.outcome == 2)
        hint: Asked only when question PATH is not "Employed, absent from work".
      - predicate: not (Q110.outcome == 2)
        hint: Asked only when question 110 is not "Self-employed".
      input:
        control: Editbox
        min: 0
        max: 168
    - id: Q156
      kind: Question
      title: Last week, how many extra hours without pay did he/she work at this job?
      precondition:
      - predicate: not (PATH.outcome == 2)
        hint: Asked only when question PATH is not "Employed, absent from work".
      - predicate: not (Q110.outcome == 2)
        hint: Asked only when question 110 is not "Self-employed".
      input:
        control: Editbox
        min: 0
        max: 168
  - id: b_s9_actual_hours_reasons
    title: 'Work hours (Main job): actual hours, part-time reasons, absence'
    precondition: *id001
    items:
    - id: Q157
      kind: Question
      title: Last week, how many hours did he/she actually work at his/her [new] [job/business] [at name of employer]?
      precondition:
      - predicate: not (PATH.outcome == 2)
        hint: Asked only when question PATH is not "Employed, absent from work".
      - predicate: not (Q150.outcome == 2)
        hint: Asked only when question 150 is not "No".
      input:
        control: Editbox
        min: 0
        max: 168
    - id: Q158
      kind: Question
      title: Does he/she want to work 30 or more hours per week [at a single job]?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: Q159
      kind: Question
      title: What is the main reason ... does not want to work 30 or more hours per week [at a single job]?
      precondition:
      - predicate: not (((Q151.outcome is not None and Q151.outcome >= 30) or (Q152.outcome is not None and Q152.outcome >= 30)) and PATH.outcome == 2)
      - predicate: not (((Q151.outcome is not None and Q151.outcome >= 30) or (Q152.outcome is not None and Q152.outcome >= 30)) and PATH.outcome == 1)
      - predicate: not (Q158.outcome == 1)
        hint: Asked only when question 158 is not "Yes".
      input:
        control: Dropdown
        labels:
          1: Reason 1
          2: Reason 2
          3: Reason 3
    - id: Q160
      kind: Question
      title: What is the main reason ... usually works less than 30 hours per week [at his/her main job]?
      precondition:
      - predicate: not (((Q151.outcome is not None and Q151.outcome >= 30) or (Q152.outcome is not None and Q152.outcome >= 30)) and PATH.outcome == 2)
      - predicate: not (((Q151.outcome is not None and Q151.outcome >= 30) or (Q152.outcome is not None and Q152.outcome >= 30)) and PATH.outcome == 1)
      - predicate: not (PATH.outcome == 2)
        hint: Asked only when question PATH is not "Employed, absent from work".
      input:
        control: Radio
        labels:
          1: Business conditions
          2: Could not find work with 30 or more hours per week
    - id: Q161
      kind: Question
      title: At any time in the 4 weeks ending last Saturday, [date of last day of reference week], did he/she look for full-time work?
      precondition:
      - predicate: not (((Q151.outcome is not None and Q151.outcome >= 30) or (Q152.outcome is not None and Q152.outcome >= 30)) and PATH.outcome == 2)
      - predicate: not (((Q151.outcome is not None and Q151.outcome >= 30) or (Q152.outcome is not None and Q152.outcome >= 30)) and PATH.outcome == 1)
      - predicate: not (PATH.outcome == 2)
        hint: Asked only when question PATH is not "Employed, absent from work".
      - predicate: not (not (Q160.outcome in [1, 2]) and PATH.outcome == 2)
      - predicate: not (not (Q160.outcome in [1, 2]) and PATH.outcome == 1)
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: Q162
      kind: Question
      title: As of last week, how many weeks had ... been continuously absent from work?
      precondition:
      - predicate: not (((Q151.outcome is not None and Q151.outcome >= 30) or (Q152.outcome is not None and Q152.outcome >= 30)) and PATH.outcome == 1)
      - predicate: not (not (PATH.outcome == 2))
      - predicate: not (not (Q160.outcome in [1, 2]) and PATH.outcome == 1)
      input:
        control: Editbox
        min: 0
        max: 999
    - id: Q163
      kind: Question
      title: Is he/she getting any wages or salary from his/her [employer/business] for any time off last week?
      precondition:
      - predicate: not (((Q151.outcome is not None and Q151.outcome >= 30) or (Q152.outcome is not None and Q152.outcome >= 30)) and PATH.outcome == 1)
      - predicate: not (not (PATH.outcome == 2))
      - predicate: not (not (Q160.outcome in [1, 2]) and PATH.outcome == 1)
      - predicate: not (Q110.outcome == 2 and Q111.outcome == 2)
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
  - id: b_s10_search
    title: Job search - Future start
    precondition:
    - predicate: not (TC_Q01.outcome == 2)
      hint: Asked only when question TC_Q01 is not "No".
    - predicate: not (SRA_Q01.outcome == 1)
      hint: Asked only when question SRA_Q01 is not "Available".
    - predicate: not (ARA_Q01.outcome in [1, 2])
      hint: Asked only when question ARA_Q01 is none of "Available", "Not available".
    - predicate: not (TFCC_Q02.outcome in [1, 2])
      hint: Asked only when question TFCC_Q02 is none of "Yes", "No".
    - predicate: not (SD_Q02.outcome == 2)
      hint: Asked only when question SD_Q02 is not "No".
    - predicate: not (SD_Q03.outcome == 2)
      hint: Asked only when question SD_Q03 is not "No".
    - predicate: not (SD_Q05.outcome in [1, 2])
      hint: Asked only when question SD_Q05 is none of "Yes", "No".
    - predicate: not (PATH.outcome == 3)
      hint: Asked only when question PATH is not "Temporary layoff".
    - predicate: not ((Q151.outcome >= 30 or Q152.outcome >= 30) and PATH.outcome == 1)
      hint: Section routing condition carried over from the source.
    - predicate: not (not (PATH.outcome == 2))
      hint: Section routing condition carried over from the source.
    - predicate: not (not (Q160.outcome in [1, 2]) and PATH.outcome == 1)
      hint: Section routing condition carried over from the source.
    - predicate: not (Q110.outcome == 2 and Q111.outcome == 2)
      hint: Section routing condition carried over from the source.
    - predicate: not (Q163.outcome in [1, 2])
      hint: Asked only when question 163 is none of "Yes", "No".
    items:
    - id: Q170
      kind: Question
      title: In the 4 weeks ending last Saturday, [date of last day of reference week], did ... do anything to find work?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
  - id: b_s10_methods
    title: Job search - Methods and duration
    precondition:
    - predicate: not (TC_Q01.outcome == 2)
      hint: Asked only when question TC_Q01 is not "No".
    - predicate: not (SRA_Q01.outcome == 1)
      hint: Asked only when question SRA_Q01 is not "Available".
    - predicate: not (ARA_Q01.outcome in [1, 2])
      hint: Asked only when question ARA_Q01 is none of "Available", "Not available".
    - predicate: not (TFCC_Q02.outcome in [1, 2])
      hint: Asked only when question TFCC_Q02 is none of "Yes", "No".
    - predicate: not (SD_Q02.outcome == 2)
      hint: Asked only when question SD_Q02 is not "No".
    - predicate: not (SD_Q03.outcome == 2)
      hint: Asked only when question SD_Q03 is not "No".
    - predicate: not (SD_Q05.outcome in [1, 2])
      hint: Asked only when question SD_Q05 is none of "Yes", "No".
    - predicate: not (PATH.outcome == 3)
      hint: Asked only when question PATH is not "Temporary layoff".
    - predicate: not ((Q151.outcome >= 30 or Q152.outcome >= 30) and PATH.outcome == 1)
      hint: Section routing condition carried over from the source.
    - predicate: not (not (PATH.outcome == 2))
      hint: Section routing condition carried over from the source.
    - predicate: not (not (Q160.outcome in [1, 2]) and PATH.outcome == 1)
      hint: Section routing condition carried over from the source.
    - predicate: not (Q110.outcome == 2 and Q111.outcome == 2)
      hint: Section routing condition carried over from the source.
    - predicate: not (Q163.outcome in [1, 2])
      hint: Asked only when question 163 is none of "Yes", "No".
    - predicate: not (PATH.outcome == 7)
      hint: Asked only when question PATH is not "Not in labour force, permanently unable to work".
    - predicate: not (Q170.outcome == 2 and AGE.outcome >= 65)
      hint: Not asked of respondents aged 65 or over who did not look for work.
    - predicate: not (Q170.outcome == 2 and AGE.outcome <= 64)
      hint: Not asked of respondents aged 64 or under who did not look for work.
    items:
    - id: Q171
      kind: Question
      title: What did he/she do to find work in those 4 weeks? Did he/she do anything else to find work?
      input:
        control: Checkbox
        labels:
          1: Contacted employer directly
          2: Contacted public employment agency
          4: Contacted private employment agency
          8: Asked friends or relatives
          16: Placed or answered job ads
          32: Looked at job ads
          64: Other methods
    - id: Q172
      kind: Question
      title: As of last week, how many weeks had he/she been looking for work? (since the date last worked)
      input:
        control: Editbox
        min: 0
        max: 520
    - id: Q173
      kind: Question
      title: What was his/her main activity before he/she started looking for work?
      input:
        control: Radio
        labels:
          1: Working
          2: Keeping house
          3: Going to school
          4: Something else
  - id: b_s10_future_start
    title: Job search - Future start
    precondition:
    - predicate: not (TC_Q01.outcome == 2)
      hint: Asked only when question TC_Q01 is not "No".
    - predicate: not (SRA_Q01.outcome == 1)
      hint: Asked only when question SRA_Q01 is not "Available".
    - predicate: not (ARA_Q01.outcome in [1, 2])
      hint: Asked only when question ARA_Q01 is none of "Available", "Not available".
    - predicate: not (TFCC_Q02.outcome in [1, 2])
      hint: Asked only when question TFCC_Q02 is none of "Yes", "No".
    - predicate: not (SD_Q02.outcome == 2)
      hint: Asked only when question SD_Q02 is not "No".
    - predicate: not (SD_Q03.outcome == 2)
      hint: Asked only when question SD_Q03 is not "No".
    - predicate: not (SD_Q05.outcome in [1, 2])
      hint: Asked only when question SD_Q05 is none of "Yes", "No".
    - predicate: not (PATH.outcome == 3)
      hint: Asked only when question PATH is not "Temporary layoff".
    - predicate: not ((Q151.outcome >= 30 or Q152.outcome >= 30) and PATH.outcome == 1)
      hint: Section routing condition carried over from the source.
    - predicate: not (not (PATH.outcome == 2))
      hint: Section routing condition carried over from the source.
    - predicate: not (not (Q160.outcome in [1, 2]) and PATH.outcome == 1)
      hint: Section routing condition carried over from the source.
    - predicate: not (Q110.outcome == 2 and Q111.outcome == 2)
      hint: Section routing condition carried over from the source.
    - predicate: not (Q163.outcome in [1, 2])
      hint: Asked only when question 163 is none of "Yes", "No".
    - predicate: not (PATH.outcome == 7)
      hint: Asked only when question PATH is not "Not in labour force, permanently unable to work".
    - predicate: not (Q170.outcome == 2 and AGE.outcome >= 65)
      hint: Not asked of respondents aged 65 or over who did not look for work.
    items:
    - id: Q174
      kind: Question
      title: Last week, did ... have a job to start at a definite date in the future?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: Q175
      kind: Question
      title: Will he/she start that job before or after Sunday, [date of the first day after four weeks from the last day of reference week]?
      precondition:
      - predicate: not (Q174.outcome == 2)
        hint: Asked only when question 174 is not "No".
      input:
        control: Radio
        labels:
          1: Before the date above
          2: On or after the date above
  - id: b_s10_want_job
    title: Job search - Wanting a job
    precondition:
    - predicate: not (TC_Q01.outcome == 2)
      hint: Asked only when question TC_Q01 is not "No".
    - predicate: not (SRA_Q01.outcome == 1)
      hint: Asked only when question SRA_Q01 is not "Available".
    - predicate: not (ARA_Q01.outcome in [1, 2])
      hint: Asked only when question ARA_Q01 is none of "Available", "Not available".
    - predicate: not (TFCC_Q02.outcome in [1, 2])
      hint: Asked only when question TFCC_Q02 is none of "Yes", "No".
    - predicate: not (SD_Q02.outcome == 2)
      hint: Asked only when question SD_Q02 is not "No".
    - predicate: not (SD_Q03.outcome == 2)
      hint: Asked only when question SD_Q03 is not "No".
    - predicate: not (SD_Q05.outcome in [1, 2])
      hint: Asked only when question SD_Q05 is none of "Yes", "No".
    - predicate: not (PATH.outcome == 3)
      hint: Asked only when question PATH is not "Temporary layoff".
    - predicate: not ((Q151.outcome >= 30 or Q152.outcome >= 30) and PATH.outcome == 1)
      hint: Section routing condition carried over from the source.
    - predicate: not (not (PATH.outcome == 2))
      hint: Section routing condition carried over from the source.
    - predicate: not (not (Q160.outcome in [1, 2]) and PATH.outcome == 1)
      hint: Section routing condition carried over from the source.
    - predicate: not (Q110.outcome == 2 and Q111.outcome == 2)
      hint: Section routing condition carried over from the source.
    - predicate: not (Q163.outcome in [1, 2])
      hint: Asked only when question 163 is none of "Yes", "No".
    - predicate: not (PATH.outcome == 7)
      hint: Asked only when question PATH is not "Not in labour force, permanently unable to work".
    - predicate: not (Q170.outcome == 2 and AGE.outcome >= 65)
      hint: Not asked of respondents aged 65 or over who did not look for work.
    - predicate: not (Q175.outcome == 1)
      hint: Asked only when question 175 is not "Before the date above".
    - predicate: not (Q175.outcome == 2)
      hint: Asked only when question 175 is not "On or after the date above".
    items:
    - id: Q176
      kind: Question
      title: Did he/she want a job last week?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: Q177
      kind: Question
      title: Did he/she want a job with more or less than 30 hours per week?
      precondition:
      - predicate: not (Q176.outcome == 2)
        hint: Asked only when question 176 is not "No".
      input:
        control: Radio
        labels:
          1: 30 hours or more per week
          2: Less than 30 hours per week
    - id: Q178
      kind: Question
      title: What was the main reason he/she did not look for work last week?
      precondition:
      - predicate: not (Q176.outcome == 2)
        hint: Asked only when question 176 is not "No".
      input:
        control: Radio
        labels:
          1: Believes no work available
          2: Other reason
  - id: b_s11_availability
    title: Availability
    precondition:
    - predicate: not (TC_Q01.outcome == 2)
      hint: Asked only when question TC_Q01 is not "No".
    - predicate: not (SRA_Q01.outcome == 1)
      hint: Asked only when question SRA_Q01 is not "Available".
    - predicate: not (ARA_Q01.outcome in [1, 2])
      hint: Asked only when question ARA_Q01 is none of "Available", "Not available".
    - predicate: not (TFCC_Q02.outcome in [1, 2])
      hint: Asked only when question TFCC_Q02 is none of "Yes", "No".
    - predicate: not (SD_Q02.outcome == 2)
      hint: Asked only when question SD_Q02 is not "No".
    - predicate: not (SD_Q03.outcome == 2)
      hint: Asked only when question SD_Q03 is not "No".
    - predicate: not (SD_Q05.outcome in [1, 2])
      hint: Asked only when question SD_Q05 is none of "Yes", "No".
    - predicate: not ((Q151.outcome >= 30 or Q152.outcome >= 30) and PATH.outcome == 1)
      hint: Section routing condition from the source (Q151 or Q152 of 30 or more on PATH 1).
    - predicate: not (not (PATH.outcome == 2))
      hint: Asked only when PATH is 2.
    - predicate: not (not (Q160.outcome in [1, 2]) and PATH.outcome == 1)
      hint: Section routing condition from the source (Q160 and PATH).
    - predicate: not (Q110.outcome == 2 and Q111.outcome == 2)
      hint: Section routing condition from the source (Q110 and Q111).
    - predicate: not (Q163.outcome in [1, 2])
      hint: Asked only when question 163 is none of "Yes", "No".
    - predicate: not (PATH.outcome == 7)
      hint: Asked only when question PATH is not "Not in labour force, permanently unable to work".
    - predicate: not (Q170.outcome == 2 and AGE.outcome >= 65)
      hint: Section routing condition from the source (Q170 and AGE).
    - predicate: not (Q175.outcome == 2)
      hint: Asked only when question 175 is not "On or after the date above".
    - predicate: not (Q176.outcome == 2)
      hint: Asked only when question 176 is not "No".
    - predicate: not (not (Q178.outcome == 1))
      hint: Asked only when question 178 is "Yes".
    items:
    - id: Q190
      kind: Question
      title: Could he/she have worked last week [if he/she had been recalled/if a suitable job had been offered]?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: Q191
      kind: Question
      title: What was the main reason ... was not available to work last week?
      precondition:
      - predicate: not (Q190.outcome == 1)
        hint: Asked only when question 190 is not "Yes".
      input:
        control: Textarea
  - id: b_s12_hourly
    title: 'Earnings – Union – Permanence: hourly pay'
    precondition:
    - predicate: not (TC_Q01.outcome == 2)
      hint: Asked only when question TC_Q01 is not "No".
    - predicate: not (SRA_Q01.outcome == 1)
      hint: Asked only when question SRA_Q01 is not "Available".
    - predicate: not (ARA_Q01.outcome in [1, 2])
      hint: Asked only when question ARA_Q01 is none of "Available", "Not available".
    - predicate: not (TFCC_Q02.outcome in [1, 2])
      hint: Asked only when question TFCC_Q02 is none of "Yes", "No".
    - predicate: not (SD_Q02.outcome == 2)
      hint: Asked only when question SD_Q02 is not "No".
    - predicate: not (SD_Q03.outcome == 2)
      hint: Asked only when question SD_Q03 is not "No".
    - predicate: not (SD_Q05.outcome in [1, 2])
      hint: Asked only when question SD_Q05 is none of "Yes", "No".
    - predicate: not (PATH.outcome == 7)
      hint: Asked only when PATH is not "Not in labour force, permanently unable to work".
    - predicate: not (Q170.outcome == 2 and AGE.outcome is not None and AGE.outcome >= 65)
      hint: Not asked of respondents aged 65 or over who answered No to question 170.
    - predicate: not (Q175.outcome == 2)
      hint: Asked only when question 175 is not "On or after the date above".
    - predicate: not (Q176.outcome == 2)
      hint: Asked only when question 176 is not "No".
    - predicate: not (not (Q178.outcome == 1))
      hint: Asked only when question 178 is "Yes".
    - predicate: not (Q190.outcome == 1)
      hint: Asked only when question 190 is not "Yes".
    items:
    - id: Q200
      kind: Question
      title: Now I’d like to ask a few short questions about ...’s earnings from his/her [new] job [at name of employer]. Is he/she paid by the hour?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
  - id: b_s12_employee
    title: 'Earnings – Union – Permanence: employees'
    precondition:
    - predicate: not (TC_Q01.outcome == 2)
      hint: Asked only when question TC_Q01 is not "No".
    - predicate: not (SRA_Q01.outcome == 1)
      hint: Asked only when question SRA_Q01 is not "Available".
    - predicate: not (ARA_Q01.outcome in [1, 2])
      hint: Asked only when question ARA_Q01 is none of "Available", "Not available".
    - predicate: not (TFCC_Q02.outcome in [1, 2])
      hint: Asked only when question TFCC_Q02 is none of "Yes", "No".
    - predicate: not (SD_Q02.outcome == 2)
      hint: Asked only when question SD_Q02 is not "No".
    - predicate: not (SD_Q03.outcome == 2)
      hint: Asked only when question SD_Q03 is not "No".
    - predicate: not (SD_Q05.outcome in [1, 2])
      hint: Asked only when question SD_Q05 is none of "Yes", "No".
    - predicate: not (PATH.outcome == 7)
      hint: Asked only when PATH is not "Not in labour force, permanently unable to work".
    - predicate: not (Q170.outcome == 2 and AGE.outcome is not None and AGE.outcome >= 65)
      hint: Not asked of respondents aged 65 or over who answered No to question 170.
    - predicate: not (Q175.outcome == 2)
      hint: Asked only when question 175 is not "On or after the date above".
    - predicate: not (Q176.outcome == 2)
      hint: Asked only when question 176 is not "No".
    - predicate: not (not (Q178.outcome == 1))
      hint: Asked only when question 178 is "Yes".
    - predicate: not (Q190.outcome == 1)
      hint: Asked only when question 190 is not "Yes".
    - predicate: not (Q110.outcome == 2)
      hint: Asked only when question 110 is not "Self-employed".
    - predicate: not (INTERVIEW_TYPE.outcome in [3, 4] and NO_CHANGE_200.outcome == 1)
      hint: Not asked when the interview is a follow-up and nothing changed since question 200.
    items:
    - id: Q201
      kind: Question
      title: Does he/she usually receive tips or commissions?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: Q202
      kind: Question
      title: '[Including tips and commissions,] what is his/her hourly rate of pay?'
      precondition:
      - predicate: not (Q200.outcome == 2)
        hint: Asked only when question 200 is not "No".
      input:
        control: Editbox
        min: 0
        max: 1000
    - id: Q204
      kind: Question
      title: What is the easiest way for you to tell us his/her wage or salary, [including tips and commissions,] before taxes and other deductions? Would it be yearly, monthly, weekly, or on some other basis?
      input:
        control: Radio
        labels:
          1: Yearly
          2: Monthly
          3: Semi-monthly
          4: Bi-weekly
          5: Weekly
          6: Other
    - id: Q205
      kind: Question
      title: '[Including tips and commissions,] what is his/her weekly wage or salary, before taxes and other deductions?'
      precondition:
      - predicate: not (Q204.outcome in [1, 2, 3, 4])
        hint: Asked only when question 204 is none of "Yearly", "Monthly", "Semi-monthly", "Bi-weekly".
      input:
        control: Editbox
        min: 0
        max: 100000
    - id: Q206
      kind: Question
      title: '[Including tips and commissions,] what is his/her bi-weekly wage or salary, before taxes and other deductions?'
      precondition:
      - predicate: not (Q204.outcome in [1, 2, 3])
        hint: Asked only when question 204 is none of "Yearly", "Monthly", "Semi-monthly".
      input:
        control: Editbox
        min: 0
        max: 200000
    - id: Q207
      kind: Question
      title: '[Including tips and commissions,] what is his/her semi-monthly wage or salary, before taxes and other deductions?'
      precondition:
      - predicate: not (Q204.outcome in [1, 2])
        hint: Asked only when question 204 is none of "Yearly", "Monthly".
      input:
        control: Editbox
        min: 0
        max: 300000
    - id: Q208
      kind: Question
      title: '[Including tips and commissions,] what is his/her monthly wage or salary, before taxes and other deductions?'
      precondition:
      - predicate: not (Q204.outcome == 1)
        hint: Asked only when question 204 is not "Yearly".
      input:
        control: Editbox
        min: 0
        max: 500000
    - id: Q209
      kind: Question
      title: '[Including tips and commissions,] what is his/her yearly wage or salary, before taxes and other deductions?'
      input:
        control: Editbox
        min: 0
        max: 5000000
    - id: Q220
      kind: Question
      title: Is he/she a union member at [name of employer]?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: Q221
      kind: Question
      title: Is he/she covered by a union contract or collective agreement?
      precondition:
      - predicate: not (Q220.outcome == 1)
        hint: Asked only when question 220 is not "Yes".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: Q240
      kind: Question
      title: Is ...’s [new] job [at name of employer] permanent, or is there some way that it is not permanent? (for example, seasonal, temporary, term or casual)
      input:
        control: Radio
        labels:
          1: Permanent
          2: Not permanent
    - id: Q241
      kind: Question
      title: In what way is his/her job not permanent?
      precondition:
      - predicate: not (Q240.outcome == 1)
        hint: Asked only when question 240 is not "Permanent".
      input:
        control: Radio
        labels:
          1: Seasonal
          2: Temporary, term or contract
          3: Casual
          4: Other
  - id: b_s13_external
    title: External inputs
    precondition:
    - predicate: not (TC_Q01.outcome == 2)
      hint: Asked only when question TC_Q01 is not "No".
    - predicate: not (SRA_Q01.outcome == 1)
      hint: Asked only when question SRA_Q01 is not "Available".
    - predicate: not (ARA_Q01.outcome in [1, 2])
      hint: Asked only when question ARA_Q01 is none of "Available", "Not available".
    - predicate: not (TFCC_Q02.outcome in [1, 2])
      hint: Asked only when question TFCC_Q02 is none of "Yes", "No".
    - predicate: not (SD_Q02.outcome == 2)
      hint: Asked only when question SD_Q02 is not "No".
    - predicate: not (SD_Q03.outcome == 2)
      hint: Asked only when question SD_Q03 is not "No".
    - predicate: not (SD_Q05.outcome in [1, 2])
      hint: Asked only when question SD_Q05 is none of "Yes", "No".
    - predicate: not (PATH.outcome == 7)
      hint: Asked only when question PATH is not "Not in labour force, permanently unable to work".
    - predicate: not (Q170.outcome == 2 and AGE.outcome >= 65)
      hint: Not asked when question 170 is "No" and the respondent is aged 65 or over.
    - predicate: not (Q175.outcome == 2)
      hint: Asked only when question 175 is not "On or after the date above".
    - predicate: not (Q176.outcome == 2)
      hint: Asked only when question 176 is not "No".
    - predicate: not (not (Q178.outcome == 1))
      hint: Asked only when question 178 is "Yes".
    - predicate: not (Q190.outcome == 1)
      hint: Asked only when question 190 is not "Yes".
    - predicate: not (Q110.outcome == 2)
      hint: Asked only when question 110 is not "Self-employed".
    - predicate: not (INTERVIEW_TYPE.outcome in [3, 4] and NO_CHANGE_200.outcome == 1)
      hint: Not asked for a subsequent interview type with no change at question 200.
    - predicate: not (Q240.outcome == 1)
      hint: Asked only when question 240 is not "Permanent".
    items:
    - id: PATH_2
      kind: Question
      title: PATH (labour force path value derived earlier in the interview; routing reads PATH = 2 and PATH not 3)
      external: true
      input:
        control: Radio
        labels:
          1: PATH 1
          2: PATH 2
          3: PATH 3
    - id: age_2
      kind: Question
      title: age (respondent's age, from the demographics collected earlier)
      external: true
      input:
        control: Editbox
        min: 0
        max: 120
    - id: survey_month
      kind: Question
      title: survey month (calendar month of the interview, 1 = January … 12 = December)
      external: true
      input:
        control: Editbox
        min: 1
        max: 12
    - id: subsequent_interview
      kind: Question
      title: subsequent interview (whether this is a subsequent interview rather than the first)
      external: true
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: prev_520
      kind: Question
      title: 520 in previous month (answer given to 520 in the previous month's interview)
      external: true
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: rotate_out
      kind: Question
      title: rotate-out (for example, last month for interview)
      external: true
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: cati_interview_2
      kind: Question
      title: CATI interview (interview mode)
      external: true
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: phone_exists
      kind: Question
      title: telephone number exists (pre-filled from previous month)
      external: true
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: ptc_exists
      kind: Question
      title: preferred time to call information exists from the previous month
      external: true
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
  - id: b_s14_firm_size
    title: Firm size
    precondition:
    - predicate: not (TC_Q01.outcome == 2)
      hint: Asked only when question TC_Q01 is not "No".
    - predicate: not (SRA_Q01.outcome == 1)
      hint: Asked only when question SRA_Q01 is not "Available".
    - predicate: not (ARA_Q01.outcome in [1, 2])
      hint: Asked only when question ARA_Q01 is none of "Available", "Not available".
    - predicate: not (TFCC_Q02.outcome in [1, 2])
      hint: Asked only when question TFCC_Q02 is none of "Yes", "No".
    - predicate: not (SD_Q02.outcome == 2)
      hint: Asked only when question SD_Q02 is not "No".
    - predicate: not (SD_Q03.outcome == 2)
      hint: Asked only when question SD_Q03 is not "No".
    - predicate: not (SD_Q05.outcome in [1, 2])
      hint: Asked only when question SD_Q05 is none of "Yes", "No".
    - predicate: not (PATH.outcome == 7)
      hint: Asked only when question PATH is not "Not in labour force, permanently unable to work".
    - predicate: not (Q170.outcome == 2 and AGE.outcome >= 65)
      hint: Section routing condition from the source (Q170 and AGE).
    - predicate: not (Q175.outcome == 2)
      hint: Asked only when question 175 is not "On or after the date above".
    - predicate: not (Q176.outcome == 2)
      hint: Asked only when question 176 is not "No".
    - predicate: not (not (Q178.outcome == 1))
      hint: Section routing condition from the source (Q178).
    - predicate: not (Q190.outcome == 1)
      hint: Asked only when question 190 is not "Yes".
    - predicate: not (Q110.outcome == 2)
      hint: Asked only when question 110 is not "Self-employed".
    - predicate: not (INTERVIEW_TYPE.outcome in [3, 4] and NO_CHANGE_200.outcome == 1)
      hint: Section routing condition from the source (INTERVIEW_TYPE and NO_CHANGE_200).
    items:
    - id: Q260
      kind: Question
      title: About how many persons are employed at the location where ... works for [name of employer]? Would it be… [Less than 20, 20 to 99, 100 to 500, or over 500]?
      input:
        control: Radio
        labels:
          1: Less than 20
          2: 20 to 99
          3: 100 to 500
          4: Over 500
    - id: Q261
      kind: Question
      title: Does [name of employer] operate at more than one location?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: Q262
      kind: Question
      title: In total, about how many persons are employed at all locations? Would it be… [Less than 20, 20 to 99, 100 to 500, or over 500]?
      precondition:
      - predicate: not (Q261.outcome == 2 or Q260.outcome == 4)
        hint: Asked only when the employer has more than one location and the location size (260) is not over 500.
      postcondition:
      - predicate: Q262.outcome >= Q260.outcome
        hint: The firm total at all locations (262) cannot be smaller than the size at this location (260).
        invented: true
      input:
        control: Radio
        labels:
          1: Less than 20
          2: 20 to 99
          3: 100 to 500
          4: Over 500
  - id: b_s15_class
    title: Class of worker – other (or old) job or business
    precondition:
    - predicate: not (TC_Q01.outcome == 2)
      hint: Asked only when question TC_Q01 is not "No".
    - predicate: not (SRA_Q01.outcome == 1)
      hint: Asked only when question SRA_Q01 is not "Available".
    - predicate: not (ARA_Q01.outcome in [1, 2])
      hint: Asked only when question ARA_Q01 is none of "Available", "Not available".
    - predicate: not (TFCC_Q02.outcome in [1, 2])
      hint: Asked only when question TFCC_Q02 is none of "Yes", "No".
    - predicate: not (SD_Q02.outcome == 2)
      hint: Asked only when question SD_Q02 is not "No".
    - predicate: not (SD_Q03.outcome == 2)
      hint: Asked only when question SD_Q03 is not "No".
    - predicate: not (SD_Q05.outcome in [1, 2])
      hint: Asked only when question SD_Q05 is none of "Yes", "No".
    - predicate: not (PATH.outcome == 7)
      hint: Asked only when question PATH is not "Not in labour force, permanently unable to work".
    - predicate: not (Q170.outcome == 2 and AGE.outcome >= 65)
      hint: Section routing condition on questions 170 and AGE.
    - predicate: not (Q175.outcome == 2)
      hint: Asked only when question 175 is not "On or after the date above".
    - predicate: not (Q176.outcome == 2)
      hint: Asked only when question 176 is not "No".
    - predicate: not (not (Q178.outcome == 1))
      hint: Section routing condition on question 178.
    - predicate: not (Q190.outcome == 1)
      hint: Asked only when question 190 is not "Yes".
    items:
    - id: Q300
      kind: Question
      title: If 102 = no, go to 400. Now I have a couple of questions about ...’s [other/old] job or business. Was he/she an employee or self-employed?
      input:
        control: Radio
        labels:
          1: Employee
          2: Self-employed
          3: Working in a family business without pay
  - id: b_s15_business
    title: Other (or old) business details
    precondition:
    - predicate: not (TC_Q01.outcome == 2)
      hint: Asked only when question TC_Q01 is not "No".
    - predicate: not (SRA_Q01.outcome == 1)
      hint: Asked only when question SRA_Q01 is not "Available".
    - predicate: not (ARA_Q01.outcome in [1, 2])
      hint: Asked only when question ARA_Q01 is none of "Available", "Not available".
    - predicate: not (TFCC_Q02.outcome in [1, 2])
      hint: Asked only when question TFCC_Q02 is none of "Yes", "No".
    - predicate: not (SD_Q02.outcome == 2)
      hint: Asked only when question SD_Q02 is not "No".
    - predicate: not (SD_Q03.outcome == 2)
      hint: Asked only when question SD_Q03 is not "No".
    - predicate: not (SD_Q05.outcome in [1, 2])
      hint: Asked only when question SD_Q05 is none of "Yes", "No".
    - predicate: not (PATH.outcome == 7)
      hint: Asked only when question PATH is not "Not in labour force, permanently unable to work".
    - predicate: not (Q170.outcome == 2 and AGE.outcome >= 65)
      hint: Section routing condition on questions 170 and AGE.
    - predicate: not (Q175.outcome == 2)
      hint: Asked only when question 175 is not "On or after the date above".
    - predicate: not (Q176.outcome == 2)
      hint: Asked only when question 176 is not "No".
    - predicate: not (not (Q178.outcome == 1))
      hint: Section routing condition on question 178.
    - predicate: not (Q190.outcome == 1)
      hint: Asked only when question 190 is not "Yes".
    - predicate: not (Q102.outcome == 2)
      hint: Asked only when question 102 is not "No".
    - predicate: not (Q300.outcome in [1, 3])
      hint: Asked only when question 300 is none of "Employee", "Working in a family business without pay".
    items:
    - id: Q301
      kind: Question
      title: Did he/she have an incorporated business?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: Q302
      kind: Question
      title: Did he/she have any employees?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
  - id: b_s15_hours
    title: Hours at other (or old) job or business
    precondition:
    - predicate: not (TC_Q01.outcome == 2)
      hint: Asked only when question TC_Q01 is not "No".
    - predicate: not (SRA_Q01.outcome == 1)
      hint: Asked only when question SRA_Q01 is not "Available".
    - predicate: not (ARA_Q01.outcome in [1, 2])
      hint: Asked only when question ARA_Q01 is none of "Available", "Not available".
    - predicate: not (TFCC_Q02.outcome in [1, 2])
      hint: Asked only when question TFCC_Q02 is none of "Yes", "No".
    - predicate: not (SD_Q02.outcome == 2)
      hint: Asked only when question SD_Q02 is not "No".
    - predicate: not (SD_Q03.outcome == 2)
      hint: Asked only when question SD_Q03 is not "No".
    - predicate: not (SD_Q05.outcome in [1, 2])
      hint: Asked only when question SD_Q05 is none of "Yes", "No".
    - predicate: not (PATH.outcome == 7)
      hint: Asked only when question PATH is not "Not in labour force, permanently unable to work".
    - predicate: not (Q170.outcome == 2 and AGE.outcome >= 65)
      hint: Section routing condition on questions 170 and AGE.
    - predicate: not (Q175.outcome == 2)
      hint: Asked only when question 175 is not "On or after the date above".
    - predicate: not (Q176.outcome == 2)
      hint: Asked only when question 176 is not "No".
    - predicate: not (not (Q178.outcome == 1))
      hint: Section routing condition on question 178.
    - predicate: not (Q190.outcome == 1)
      hint: Asked only when question 190 is not "Yes".
    - predicate: not (Q102.outcome == 2)
      hint: Asked only when question 102 is not "No".
    items:
    - id: Q320
      kind: Question
      title: If 300 = “Employee”, Excluding overtime, how many paid hours [does/did] ... usually work per week at this job? Otherwise, How many hours [does/did] ... usually work per week at this [business/family business]?
      input:
        control: Editbox
        min: 0
        max: 168
    - id: Q321
      kind: Question
      title: Last week, how many hours did ... actually work at this [job/business/family business]?
      precondition:
      - predicate: not (PATH_2.outcome == 2)
        hint: Asked only when question PATH is not "PATH 2".
      input:
        control: Editbox
        min: 0
        max: 168
  - id: b_s16_layoff_search
    title: Temporary layoff job search
    precondition:
    - predicate: not (TC_Q01.outcome == 2)
      hint: Asked only when question TC_Q01 is not "No".
    - predicate: not (SRA_Q01.outcome == 1)
      hint: Asked only when question SRA_Q01 is not "Available".
    - predicate: not (ARA_Q01.outcome in [1, 2])
      hint: Asked only when question ARA_Q01 is none of "Available", "Not available".
    - predicate: not (TFCC_Q02.outcome in [1, 2])
      hint: Asked only when question TFCC_Q02 is none of "Yes", "No".
    - predicate: not (SD_Q02.outcome == 2)
      hint: Asked only when question SD_Q02 is not "No".
    - predicate: not (SD_Q03.outcome == 2)
      hint: Asked only when question SD_Q03 is not "No".
    - predicate: not (SD_Q05.outcome in [1, 2])
      hint: Asked only when question SD_Q05 is none of "Yes", "No".
    - predicate: not (PATH.outcome == 7)
      hint: Asked only when question PATH is not "Not in labour force, permanently unable to work".
    - predicate: not (Q170.outcome == 2 and AGE.outcome >= 65)
      hint: Section routing condition from the source questionnaire.
    - predicate: not (Q175.outcome == 2)
      hint: Asked only when question 175 is not "On or after the date above".
    - predicate: not (Q176.outcome == 2)
      hint: Asked only when question 176 is not "No".
    - predicate: not (not (Q178.outcome == 1))
      hint: Section routing condition from the source questionnaire.
    items:
    - id: Q400
      kind: Question
      title: If PATH not 3, go to 500. In the 4 weeks ending last Saturday, [date of last day of reference week], did ... look for a job with a different employer?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
  - id: b_s17_q500
    title: School attendance
    precondition:
    - predicate: not (TC_Q01.outcome == 2)
      hint: Asked only when question TC_Q01 is not "No".
    - predicate: not (SRA_Q01.outcome == 1)
      hint: Asked only when question SRA_Q01 is not "Available".
    - predicate: not (ARA_Q01.outcome in [1, 2])
      hint: Asked only when question ARA_Q01 is none of "Available", "Not available".
    - predicate: not (TFCC_Q02.outcome in [1, 2])
      hint: Asked only when question TFCC_Q02 is none of "Yes", "No".
    - predicate: not (SD_Q02.outcome == 2)
      hint: Asked only when question SD_Q02 is not "No".
    - predicate: not (SD_Q03.outcome == 2)
      hint: Asked only when question SD_Q03 is not "No".
    - predicate: not (SD_Q05.outcome in [1, 2])
      hint: Asked only when question SD_Q05 is none of "Yes", "No".
    items:
    - id: Q500
      kind: Question
      title: If age >= 65, go to END. Last week, was ... attending a school, college or university?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
  - id: b_s17_attending
    title: School type and enrolment
    precondition:
    - predicate: not (TC_Q01.outcome == 2)
      hint: Asked only when question TC_Q01 is not "No".
    - predicate: not (SRA_Q01.outcome == 1)
      hint: Asked only when question SRA_Q01 is not "Available".
    - predicate: not (ARA_Q01.outcome in [1, 2])
      hint: Asked only when question ARA_Q01 is none of "Available", "Not available".
    - predicate: not (TFCC_Q02.outcome in [1, 2])
      hint: Asked only when question TFCC_Q02 is none of "Yes", "No".
    - predicate: not (SD_Q02.outcome == 2)
      hint: Asked only when question SD_Q02 is not "No".
    - predicate: not (SD_Q03.outcome == 2)
      hint: Asked only when question SD_Q03 is not "No".
    - predicate: not (SD_Q05.outcome in [1, 2])
      hint: Asked only when question SD_Q05 is none of "Yes", "No".
    - predicate: not (age_2.outcome >= 65)
      hint: Not asked of respondents aged 65 or over.
    - predicate: not (Q500.outcome == 2)
      hint: Asked only when question 500 is not "No".
    items:
    - id: Q501
      kind: Question
      title: Was he/she enrolled as a full-time or part-time student?
      input:
        control: Radio
        labels:
          1: Full-time
          2: Part-time
    - id: Q502
      kind: Question
      title: What kind of school was this?
      input:
        control: Radio
        labels:
          1: Elementary, junior high school, high school or equivalent
          2: Community college, junior college, or CEGEP
          3: University
          4: Other - Specify
  - id: b_s17_fall
    title: Returning students
    precondition:
    - predicate: not (TC_Q01.outcome == 2)
      hint: Asked only when question TC_Q01 is not "No".
    - predicate: not (SRA_Q01.outcome == 1)
      hint: Asked only when question SRA_Q01 is not "Available".
    - predicate: not (ARA_Q01.outcome in [1, 2])
      hint: Asked only when question ARA_Q01 is none of "Available", "Not available".
    - predicate: not (TFCC_Q02.outcome in [1, 2])
      hint: Asked only when question TFCC_Q02 is none of "Yes", "No".
    - predicate: not (SD_Q02.outcome == 2)
      hint: Asked only when question SD_Q02 is not "No".
    - predicate: not (SD_Q03.outcome == 2)
      hint: Asked only when question SD_Q03 is not "No".
    - predicate: not (SD_Q05.outcome in [1, 2])
      hint: Asked only when question SD_Q05 is none of "Yes", "No".
    - predicate: not (age_2.outcome >= 65)
      hint: Not asked of respondents aged 65 or over.
    items:
    - id: Q520
      kind: Question
      title: Was ... a full-time student in March of this year? (asked only if survey month is May through August, age 15 to 24, and not a subsequent interview)
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: Q521
      kind: Question
      title: Does ... expect to be a full-time student this fall?
      precondition:
      - predicate: not (survey_month.outcome < 5 or survey_month.outcome > 8)
        hint: Asked only when the survey month is May through August.
      - predicate: not (age_2.outcome < 15 or age_2.outcome > 24)
        hint: Asked only for ages 15 to 24.
      - predicate: not (subsequent_interview.outcome == 1 and prev_520.outcome == 2)
        hint: Not asked in a subsequent interview when Q520 was previously answered No.
      - predicate: not (Q520.outcome == 2)
        hint: Asked only when question 520 is not "No".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Not sure
  - id: b_s18_exit
    title: Exit component
    precondition:
    - predicate: not (TC_Q01.outcome == 2)
      hint: Asked only when question TC_Q01 is not "No".
    - predicate: not (SRA_Q01.outcome == 1)
      hint: Asked only when question SRA_Q01 is not "Available".
    - predicate: not (ARA_Q01.outcome in [1, 2])
      hint: Asked only when question ARA_Q01 is none of "Available", "Not available".
    - predicate: not (TFCC_Q02.outcome in [1, 2])
      hint: Asked only when question TFCC_Q02 is none of "Yes", "No".
    - predicate: not (SD_Q02.outcome == 2)
      hint: Asked only when question SD_Q02 is not "No".
    - predicate: not (SD_Q03.outcome == 2)
      hint: Asked only when question SD_Q03 is not "No".
    - predicate: not (SD_Q05.outcome in [1, 2])
      hint: Asked only when question SD_Q05 is none of "Yes", "No".
    - predicate: not (age_2.outcome >= 65)
      hint: Asked only when age_2 is under 65.
    - predicate: not (survey_month.outcome < 5 or survey_month.outcome > 8)
      hint: Asked only when survey_month is between 5 and 8.
    - predicate: not (age_2.outcome < 15 or age_2.outcome > 24)
      hint: Asked only when age_2 is between 15 and 24.
    - predicate: not (subsequent_interview.outcome == 1 and prev_520.outcome == 2)
      hint: Not asked in a subsequent interview when prev_520 is No.
    - predicate: not (Q520.outcome == 2)
      hint: Asked only when question 520 is not "No".
    items:
    - id: HC_Q01
      kind: Question
      title: Who would be the best person to contact?
      input:
        control: Textarea
    - id: TEL_Q01
      kind: Question
      title: If no telephone number exists, go to TEL_Q02. I would like to confirm your telephone number. Is it … ?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: TEL_Q02
      kind: Question
      title: What is your telephone number, including the area code?
      precondition:
      - predicate: not (TEL_Q01.outcome == 1)
        hint: Asked only when question TEL_Q01 is not "Yes".
      input:
        control: Textarea
    - id: PC_Q01
      kind: Question
      title: If CATI interview, go to PTC_Q01. May we conduct the next interview by telephone?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: PTC_Q01
      kind: Question
      title: If preferred time to call information does not exist from the previous month, go to PTC_Q02. I would like to confirm the time of day you would prefer that we call. Is it [preferred time to call] ?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: PTC_Q02
      kind: Question
      title: What time of day would you prefer that we call? Would it be the morning, the afternoon, the evening, or ANY TIME? Mark all that apply.
      precondition:
      - predicate: not (PTC_Q01.outcome == 1)
        hint: Asked only when question PTC_Q01 is not "Yes".
      input:
        control: Checkbox
        labels:
          1: 1 — Any time
          2: 2 — Morning
          4: 3 — Afternoon
          8: 4 — Evening
          16: 5 — Not morning
          32: 6 — Not afternoon
          64: 7 — Not evening
    - id: PTC_N03
      kind: Question
      title: Enter any other information about the preferred time to call.
      input:
        control: Textarea
    - id: LQ_Q01
      kind: Question
      title: If CATI interview, go to TY_R01. If subsequent interview, go to TY_R01. If dwelling type is not “Single detached” and not “Double” and not “Row or terrace” and not “Duplex”, go to TY_R01. Is there another set of living quarters within this structure?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
