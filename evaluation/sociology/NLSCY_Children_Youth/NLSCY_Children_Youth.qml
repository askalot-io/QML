qmlVersion: "1.0"
questionnaire:
  title: "National Longitudinal Survey of Children and Youth"
  codeInit: |
    # =====================================================================
    # Cross-section variables. With a single codeInit scope and one
    # dependency graph, variables written by an earlier block are visible
    # to every later block without any extern declaration.
    # =====================================================================
    child_age = 0           # age of the selected child (0-11)
    respondent_sex = 0      # 1=Male, 2=Female
    marital_status = 0      # 1=Married, 2=Common-law, 3=Partner, 4=Single, 5=Widowed, 6=Separated, 7=Divorced
    respondent_age = 0  # respondent's age from demographics section
    is_parent = 0       # 1=respondent is the parent, 0=otherwise
    has_gaps = 0
    has_income = 0              # 1=household has any income source, 0=none
    source_count = 0            # count of income sources selected
    multiple_sources = 0        # 1=more than one source selected
    household_income_known = 0  # bracket estimation fallback
    personal_income_known = 0
    is_pmk = 0                    # 1=Person Most Knowledgeable about child
    is_bio_mother_young_child = 0 # 1=biological mother of child under 2
    cesd_score = 0                # CES-D Depression Scale score
    relationship_to_child = 0   # 1=Birth parent .. 9=Unrelated, used in Parenting/Custody
    child_age_months = 0    # age of child in months (0-143)
    is_bio_mother = 0       # 1=respondent is biological mother
    is_bio_father = 0       # 1=respondent is biological father
    province = 0        # from Contact/Household: province code
    in_school = 0       # 0=not in school, 1=in school
    school_grade = 0    # consolidated grade value (0=not in school, 16=ungraded)
    has_siblings = 0    # 1 if child has brothers/sisters in household
    is_pmk_or_spouse = 0       # 1=PMK or PMK's spouse/partner, 0=other
    parents_together = 0
    parents_separated = 0
    parent_died = 0
    parents_were_married = 0
    mother_new_union = 0
    father_new_union = 0
    child_lived_with_respondent = 0
    custody_type = 0
    parents_lived_together_ever = 0

  blocks:

    # ===================================================================
    # SECTION: contact_household
    # ===================================================================
    # =========================================================================
    # BLOCK 1: CONTACT INTRODUCTION
    # =========================================================================
    # CONT-Q1A, CONT-Q2, CONT-Q3A, CONT-Q4A, CONT-Q7
    # Introductory scripts and language preference.
    # =========================================================================
    - id: b_contact
      title: "Contact Introduction"
      items:
        # CONT-Q1A: Interviewer introduction
        - id: q_cont_q1a
          kind: Comment
          title: "Hello, I'm calling from Statistics Canada. I am contacting you about the National Longitudinal Survey of Children."

        # CONT-Q2: Language preference
        - id: q_cont_q2
          kind: Question
          title: "Would you prefer to be interviewed in English or French?"
          input:
            control: Radio
            labels:
              1: "English"
              2: "French"
              3: "Either"

        # CONT-Q3A: Survey purpose
        - id: q_cont_q3a
          kind: Comment
          title: "We are conducting this survey to collect information on children, their development, family and school experiences."

        # CONT-Q4A: Confidentiality notice
        - id: q_cont_q4a
          kind: Comment
          title: "Your answers will be kept strictly confidential and used only for statistical purposes. While participation is voluntary, your assistance is essential if the results are to be accurate."

        # CONT-Q7: Transition to household questions
        - id: q_cont_q7
          kind: Comment
          title: "The next few questions will provide important basic information on the people in your household."

    # =========================================================================
    # BLOCK 2: DEMOGRAPHICS
    # =========================================================================
    # DEMO-Q1 through DEMO-Q3 are household roster questions involving
    # dynamic looping over household members (add names, ask if anyone else
    # is away/living here, loop back). QML cannot model dynamic rosters.
    #
    # DEMO-Q7 (family ID code) and DEMO-Q8 (relationships of everyone to
    # everyone else) are also roster/internal items that cannot be modeled.
    #
    # Modeled items:
    #   DEMO-Q4: Date of birth (modeled as respondent age + child age)
    #   DEMO-Q5: Sex
    #   DEMO-Q6: Marital status
    # =========================================================================
    - id: b_demographics
      title: "Demographics"
      items:
        # Roster omission notice
        - id: q_roster_notice
          kind: Comment
          title: "Household roster collection (DEMO-Q1 through Q3: names, persons away, others living here) is conducted externally via roster management. DEMO-Q7 (family ID) and DEMO-Q8 (inter-person relationships) are also collected through the roster system."

        # DEMO-Q4: Date of birth
        # The original asks for date of birth. Since QML does not support date
        # inputs, we model the respondent's age and the selected child's age
        # as separate Editbox items.
        - id: q_respondent_age
          kind: Question
          title: "What is the respondent's age?"
          input:
            control: Editbox
            min: 0
            max: 120
            right: "years"

        - id: q_child_age
          kind: Question
          title: "What is the age of the selected child?"
          postcondition:
            - predicate: q_child_age.outcome <= 11
              hint: "The NLSCY covers children aged 0 to 11."
          codeBlock: |
            child_age = q_child_age.outcome
          input:
            control: Editbox
            min: 0
            max: 11
            right: "years"

        # DEMO-Q5: Sex of respondent
        - id: q_demo_q5
          kind: Question
          title: "Enter or confirm the respondent's sex."
          codeBlock: |
            respondent_sex = q_demo_q5.outcome
          input:
            control: Radio
            labels:
              1: "Male"
              2: "Female"

        # DEMO-Q6: Marital status
        - id: q_demo_q6
          kind: Question
          title: "What is the respondent's marital status?"
          codeBlock: |
            marital_status = q_demo_q6.outcome
          input:
            control: Dropdown
            labels:
              1: "Now married"
              2: "Common-law"
              3: "Living with a partner"
              4: "Single (never married)"
              5: "Widowed"
              6: "Separated"
              7: "Divorced"

    # =========================================================================
    # BLOCK 3: HOUSEHOLD DWELLING
    # =========================================================================
    # HHLD-Q1: Dwelling owned?
    # HHLD-C1A routing: if owned (HHLD-Q1=Yes), skip HHLD-Q2
    # HHLD-Q2: Subsidized housing? (only if NOT owned)
    # HHLD-Q2B: Dwelling repairs needed?
    # HHLD-Q3: Number of bedrooms
    # HHLD-Q6: Dwelling type (interviewer observation) - modeled as Dropdown
    # HHLD-Q7: Information source indicator - omitted (procedural)
    # HHLD-Q8: Language of interview - omitted (procedural, duplicates CONT-Q2)
    # =========================================================================
    - id: b_dwelling
      title: "Household Dwelling"
      items:
        # HHLD-Q1: Dwelling owned?
        - id: q_hhld_q1
          kind: Question
          title: "Now a few questions about your dwelling. Is this dwelling owned by a member of this household (even if being paid for)?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # HHLD-Q2: Subsidized housing?
        # HHLD-C1A routing: if HHLD-Q1=Yes (owned), skip this question
        - id: q_hhld_q2
          kind: Question
          title: "Is this dwelling subsidized by the government for any reason? (e.g., low income housing project, co-operative housing project, public housing)"
          precondition:
            - predicate: q_hhld_q1.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # HHLD-Q2B: Dwelling repairs needed?
        - id: q_hhld_q2b
          kind: Question
          title: "Is this dwelling in need of any repairs?"
          input:
            control: Radio
            labels:
              1: "Yes, minor repairs (missing or loose floor tiles, bricks or shingles, defective steps, railing or siding, etc.)"
              2: "Yes, major repairs (defective plumbing or electrical wiring, structural repairs to walls, floors or ceilings, etc.)"
              3: "No, only regular maintenance is needed (painting, furnace cleaning, etc.)"

        # HHLD-Q3: Number of bedrooms
        - id: q_hhld_q3
          kind: Question
          title: "How many bedrooms are there in this dwelling? (If no separate enclosed bedroom, enter 0.)"
          input:
            control: Editbox
            min: 0
            max: 20

        # HHLD-Q6: Dwelling type (interviewer observation)
        - id: q_hhld_q6
          kind: Question
          title: "Record type of dwelling (by interviewer observation)."
          input:
            control: Dropdown
            labels:
              1: "Single detached house"
              2: "Semi-detached or double (side-by-side)"
              3: "Garden home, town-house or row house"
              4: "Duplex (one above the other)"
              5: "Low-rise apartment (less than 5 stories)"
              6: "High-rise apartment (5 or more stories)"
              7: "Institution"
              8: "Hotel, rooming or lodging house, logging or construction camp, Hutterite colony"
              9: "Mobile home"
              10: "Other"

    # =========================================================================
    # BLOCK 4: CHILD SELECTION AND RESPONDENT IDENTIFICATION
    # =========================================================================
    # CAID-INT-1 and PICKRESP: Identify who is most knowledgeable about
    # the selected child (PMK) and who is providing information.
    # Modeled as Comment + Dropdown for respondent type.
    # =========================================================================
    - id: b_child_selection
      title: "Child Selection and Respondent Identification"
      items:
        # CAID-INT-1: PMK identification intro
        - id: q_caid_int1
          kind: Comment
          title: "Who is the person most knowledgeable (PMK) about the selected child?"

        # PICKRESP: Who is providing information?
        - id: q_pickresp
          kind: Question
          title: "Who is providing the information for this child's form?"
          input:
            control: Radio
            labels:
              1: "PMK (person most knowledgeable)"
              2: "Spouse/partner of PMK"
              3: "Other household member"

    # =========================================================================
    # BLOCK 5: ADMINISTRATION
    # =========================================================================
    # H05-P1: Interview mode
    # H05-P2: Language of interview
    # =========================================================================
    - id: b_administration
      title: "Administration"
      items:
        # H05-P1: Interview mode
        - id: q_h05_p1
          kind: Question
          title: "Was this interview conducted on the telephone or in person?"
          input:
            control: Radio
            labels:
              1: "On telephone"
              2: "In person"
              3: "Both"

        # H05-P2: Language of interview
        - id: q_h05_p2
          kind: Question
          title: "Record the language of interview."
          input:
            control: Dropdown
            labels:
              1: "English"
              2: "French"
              3: "Arabic"
              4: "Chinese"
              5: "Cree"
              6: "German"
              7: "Greek"
              8: "Hungarian"
              9: "Italian"
              10: "Korean"
              11: "Persian (Farsi)"
              12: "Polish"
              13: "Portuguese"
              14: "Punjabi"
              15: "Spanish"
              16: "Tagalog (Filipino)"
              17: "Ukrainian"
              18: "Vietnamese"
              19: "Other"

    # ===================================================================
    # SECTION: general_health
    # ===================================================================
    # =========================================================================
    # BLOCK 1: RESTRICTION OF ACTIVITIES (RESTR)
    # =========================================================================
    # RESTR-CINT: IF AGE<12, GO TO NEXT SECTION
    # "AGE" refers to the respondent's age (General Questionnaire for HH members 12+)
    # Modeled as block-level precondition: respondent_age >= 12
    # =========================================================================
    - id: b_restriction
      title: "Restriction of Activities"
      precondition:
        - predicate: respondent_age >= 12
      items:
        # RESTR-INT: Introduction
        - id: q_restr_int
          kind: Comment
          title: "The next few questions deal with any health limitations which affect daily activities. In these questions, \"long-term conditions\" refer to conditions that have lasted or are expected to last 6 months or more."

        # RESTR-Q1: Activity limitations (a through e)
        # Sub-parts share Radio with Yes/No/Not Applicable.
        # Items (a) At home and (d) Other activities use only Yes/No,
        # but the 3-option scale accommodates all sub-parts uniformly.
        - id: qg_restr_q1
          kind: QuestionGroup
          title: "Because of a long-term physical or mental condition or a health problem, is the child limited in the kind or amount of activity they can do:"
          questions:
            - "(a) At home?"
            - "(b) At school?"
            - "(c) At work?"
            - "(d) In other activities such as transportation to or from work or leisure time activities?"
            - "(e) In caring for children?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Not applicable"

    # =========================================================================
    # BLOCK 2: CHRONIC CONDITIONS (CHRON)
    # =========================================================================
    # CHRON-CINT: IF AGE<12 OR RESPONDENT IS NOT THE PARENT,
    #             GO TO NEXT SECTION
    # Modeled as block-level precondition: respondent_age >= 12 AND is_parent == 1
    # =========================================================================
    - id: b_chronic
      title: "Chronic Conditions"
      precondition:
        - predicate: respondent_age >= 12
        - predicate: is_parent == 1
      items:
        # CHRON-INT: Introduction
        - id: q_chron_int
          kind: Comment
          title: "Now I'd like to ask about any chronic health conditions the child may have. Again, \"long-term conditions\" refer to conditions that have lasted or are expected to last 6 months or more."

        # CHRON-Q1: Long-term conditions checklist
        # Modeled as QuestionGroup with Switch (Yes/No per condition)
        # rather than Checkbox, because 18+ options make power-of-2
        # encoding impractical.
        # Index mapping:
        #   [0] Food allergies    [1] Other allergies     [2] Asthma
        #   [3] Arthritis         [4] Back problems       [5] High blood pressure
        #   [6] Migraine          [7] Bronchitis/emphysema [8] Sinusitis
        #   [9] Diabetes          [10] Epilepsy           [11] Heart disease
        #   [12] Cancer           [13] Stomach ulcers     [14] Effects of stroke
        #   [15] Urinary incont.  [16] Alzheimer's/dementia [17] Cataracts
        - id: qg_chron_q1
          kind: QuestionGroup
          title: "Does the child have any of the following long-term conditions that have been diagnosed by a health professional:"
          questions:
            - "(a) Food allergies?"
            - "(b) Other allergies?"
            - "(c) Asthma?"
            - "(d) Arthritis or rheumatism?"
            - "(e) Back problems excluding arthritis?"
            - "(f) High blood pressure?"
            - "(g) Migraine headaches?"
            - "(h) Chronic bronchitis or emphysema?"
            - "(i) Sinusitis?"
            - "(j) Diabetes?"
            - "(k) Epilepsy?"
            - "(l) Heart disease?"
            - "(m) Cancer?"
            - "(n) Stomach or intestinal ulcers?"
            - "(o) Effects of stroke?"
            - "(p) Urinary incontinence?"
            - "(r) Alzheimer's disease or other dementia?"
            - "(s) Cataracts?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # CHRON-Q1mm: Cancer type specification (open text)
        # Precondition: cancer [index 12] was selected in CHRON-Q1
        - id: q_chron_q1mm
          kind: Question
          title: "What type(s) of cancer is this? For example, skin, lung or colon cancer."
          precondition:
            - predicate: qg_chron_q1.outcome[12] == 1
          input:
            control: Textarea
            placeholder: "Specify type of cancer..."
            maxLength: 500

        # CHRON-Q1cc1: Asthma attack in past 12 months
        # Precondition: asthma [index 2] was selected in CHRON-Q1
        - id: q_chron_q1cc1
          kind: Question
          title: "Has the child had an attack of asthma in the past 12 months?"
          precondition:
            - predicate: qg_chron_q1.outcome[2] == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # CHRON-Q1cc2: Wheezing in past 12 months
        # Precondition: asthma [index 2] was selected in CHRON-Q1
        - id: q_chron_q1cc2
          kind: Question
          title: "Has the child had wheezing or whistling in the chest at any time in the past 12 months?"
          precondition:
            - predicate: qg_chron_q1.outcome[2] == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

    # ===================================================================
    # SECTION: socio_demographics
    # ===================================================================
    # =========================================================================
    # INTRODUCTION
    # =========================================================================
    - id: b_socio_intro
      title: "Socio-demographic Characteristics"
      items:
        # SOCIO-INT: Section introduction
        - id: q_socio_int
          kind: Comment
          title: "Now I'd like to ask some general background questions."

    # =========================================================================
    # COUNTRY OF BIRTH AND IMMIGRATION
    # =========================================================================
    # Q1 -> (if not Canada) Q2a -> (if not citizen by birth) Q2b -> (if Yes) Q3
    # =========================================================================
    - id: b_socio_birth
      title: "Country of Birth and Immigration"
      items:
        # SOCIO-Q1: Country of birth
        # If CANADA (1) -> GO TO NEXT SECTION (skip all remaining socio questions)
        - id: q_socio_q1
          kind: Question
          title: "In what country were/was ... born?"
          input:
            control: Dropdown
            labels:
              1: "Canada"
              2: "China"
              3: "France"
              4: "Germany"
              5: "Greece"
              6: "Guyana"
              7: "Hong Kong"
              8: "Hungary"
              9: "India"
              10: "Italy"
              11: "Jamaica"
              12: "Netherlands"
              13: "Philippines"
              14: "Poland"
              15: "Portugal"
              16: "United Kingdom"
              17: "United States"
              18: "Viet Nam"
              19: "Other (specify)"

        # SOCIO-Q1 Other specify
        - id: q_socio_q1_other
          kind: Question
          title: "Please specify the country of birth."
          precondition:
            - predicate: q_socio_q1.outcome == 19
          input:
            control: Textarea
            placeholder: "Specify country..."

        # SOCIO-Q2a: Citizenship
        # If CANADA, CITIZEN BY BIRTH (1) -> GO TO NEXT SECTION
        - id: q_socio_q2a
          kind: Question
          title: "Of what country are/is ... a citizen?"
          precondition:
            - predicate: q_socio_q1.outcome != 1
          input:
            control: Checkbox
            labels:
              1: "Canada, citizen by birth"
              2: "Canada, by naturalization"
              4: "Same as country of birth"
              8: "Other country"

        # SOCIO-Q2b: Landed immigrant status
        # Asked only if not born in Canada AND not citizen by birth
        # Citizen by birth = bit 0 (value 1) selected -> q_socio_q2a.outcome % 2 == 1
        - id: q_socio_q2b
          kind: Question
          title: "Are/Is ... now, or have/has ... ever been a landed immigrant?"
          precondition:
            - predicate: q_socio_q1.outcome != 1
            - predicate: q_socio_q2a.outcome % 2 == 0
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # SOCIO-Q3: Immigration year
        # Asked only if landed immigrant (Q2b = Yes)
        - id: q_socio_q3
          kind: Question
          title: "In what year did ... first immigrate to Canada?"
          precondition:
            - predicate: q_socio_q1.outcome != 1
            - predicate: q_socio_q2a.outcome % 2 == 0
            - predicate: q_socio_q2b.outcome == 1
          input:
            control: Editbox
            min: 1900
            max: 2026

    # =========================================================================
    # ETHNICITY
    # =========================================================================
    # Q4: Mark all that apply (19 groups + Other specify)
    # No skip logic — always asked regardless of Q1
    # =========================================================================
    - id: b_socio_ethnicity
      title: "Ethnicity"
      items:
        # SOCIO-Q4: Ethnic/cultural groups
        - id: qg_socio_q4
          kind: QuestionGroup
          title: "To which ethnic or cultural group(s) did your/...'s ancestors belong? (For example: French, British, Chinese)"
          questions:
            - "Canadian"
            - "French"
            - "English"
            - "German"
            - "Scottish"
            - "Irish"
            - "Italian"
            - "Ukrainian"
            - "Dutch (Netherlands)"
            - "Chinese"
            - "Jewish"
            - "Polish"
            - "Portuguese"
            - "South Asian"
            - "Black"
            - "North American Indian"
            - "Metis"
            - "Inuit/Eskimo"
            - "Other"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # SOCIO-Q4 Other specify
        - id: q_socio_q4_other
          kind: Question
          title: "Please specify the other ethnic or cultural group."
          precondition:
            - predicate: qg_socio_q4.outcome[18] == 1
          input:
            control: Textarea
            placeholder: "Specify ethnic or cultural group..."

    # =========================================================================
    # LANGUAGES
    # =========================================================================
    # Q5: Languages for conversation (mark all)
    # Q6: Mother tongue (mark all)
    # =========================================================================
    - id: b_socio_languages
      title: "Languages"
      items:
        # SOCIO-Q5: Languages for conversation
        - id: qg_socio_q5
          kind: QuestionGroup
          title: "In what language(s) can ... conduct a conversation?"
          questions:
            - "English"
            - "French"
            - "Arabic"
            - "Chinese"
            - "Cree"
            - "German"
            - "Greek"
            - "Hungarian"
            - "Italian"
            - "Korean"
            - "Persian (Farsi)"
            - "Polish"
            - "Portuguese"
            - "Punjabi"
            - "Spanish"
            - "Tagalog (Filipino)"
            - "Ukrainian"
            - "Vietnamese"
            - "Other"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # SOCIO-Q5 Other specify
        - id: q_socio_q5_other
          kind: Question
          title: "Please specify the other language(s) for conversation."
          precondition:
            - predicate: qg_socio_q5.outcome[18] == 1
          input:
            control: Textarea
            placeholder: "Specify language..."

        # SOCIO-Q6: Mother tongue
        - id: qg_socio_q6
          kind: QuestionGroup
          title: "What is the language that ... first learned at home in childhood and can still understand? (If ... can no longer understand the first language learned, choose the second language learned.)"
          questions:
            - "English"
            - "French"
            - "Arabic"
            - "Chinese"
            - "Cree"
            - "German"
            - "Greek"
            - "Hungarian"
            - "Italian"
            - "Korean"
            - "Persian (Farsi)"
            - "Polish"
            - "Portuguese"
            - "Punjabi"
            - "Spanish"
            - "Tagalog (Filipino)"
            - "Ukrainian"
            - "Vietnamese"
            - "Other"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # SOCIO-Q6 Other specify
        - id: q_socio_q6_other
          kind: Question
          title: "Please specify the other mother tongue language."
          precondition:
            - predicate: qg_socio_q6.outcome[18] == 1
          input:
            control: Textarea
            placeholder: "Specify language..."

    # =========================================================================
    # RELIGION
    # =========================================================================
    # Q8: Religion. If NO RELIGION (1) -> GO TO NEXT SECTION (skip Q9)
    # Q9: Religious attendance — only if has a religion
    # =========================================================================
    - id: b_socio_religion
      title: "Religion"
      items:
        # SOCIO-Q8: Religion
        - id: q_socio_q8
          kind: Question
          title: "What, if any, is your/...'s religion?"
          input:
            control: Dropdown
            labels:
              1: "No religion"
              2: "Roman Catholic"
              3: "United Church"
              4: "Anglican"
              5: "Presbyterian"
              6: "Lutheran"
              7: "Baptist"
              8: "Eastern Orthodox"
              9: "Jewish"
              10: "Islam (Muslim)"
              11: "Buddhist"
              12: "Hindu"
              13: "Sikh"
              14: "Jehovah's Witness"
              15: "Other (specify)"

        # SOCIO-Q8 Other specify
        - id: q_socio_q8_other
          kind: Question
          title: "Please specify the religion."
          precondition:
            - predicate: q_socio_q8.outcome == 15
          input:
            control: Textarea
            placeholder: "Specify religion..."

        # SOCIO-Q9: Religious attendance
        # Skipped if NO RELIGION (Q8 = 1)
        - id: q_socio_q9
          kind: Question
          title: "Other than on special occasions (such as weddings, funerals or baptisms), how often did ... attend religious services or meetings in the past 12 months?"
          precondition:
            - predicate: q_socio_q8.outcome != 1
          input:
            control: Radio
            labels:
              1: "At least once a week"
              2: "At least once a month"
              3: "At least 3 or 4 times a year"
              4: "At least once a year"
              5: "Not at all"

    # ===================================================================
    # SECTION: education_adult
    # ===================================================================
    # =========================================================================
    # EDUCATION (ADULT)
    # =========================================================================
    # EDUC-C1: IF AGE < 12, skip entire section.
    # EDUC-Q1 -> EDUC-Q2 -> EDUC-Q3 -> EDUC-Q4 -> EDUC-Q5 -> EDUC-Q6
    #
    # Q1: Years of schooling. If 0 (no schooling) -> skip rest of section.
    # Q3: Post-secondary attendance. If NO -> skip Q4, go to C5/Q5.
    # C5: IF AGE >= 65 -> skip Q5 and Q6.
    # Q5: Currently attending school. If NO -> skip Q6.
    # Q6: Full-time or part-time (only if currently attending).
    # =========================================================================
    - id: b_education_adult
      title: "Education"
      precondition:
        - predicate: respondent_age >= 12
      items:
        # EDUC-Q1: Years of elementary and high school completed
        - id: q_educ_q1
          kind: Question
          title: "Excluding kindergarten, how many years of elementary and high school have you successfully completed?"
          input:
            control: Dropdown
            labels:
              0: "No schooling"
              1: "1-5 years"
              2: "6 years"
              3: "7 years"
              4: "8 years"
              5: "9 years"
              6: "10 years"
              7: "11 years"
              8: "12 years"
              9: "13 years"

        # EDUC-Q2: High school graduation
        # Skipped if no schooling (Q1 == 0 -> GO TO NEXT SECTION)
        # EDUC-C1A: IF AGE < 15 -> GO TO NEXT SECTION (only Q1 asked for ages 12-14)
        - id: q_educ_q2
          kind: Question
          title: "Have you graduated from high school?"
          precondition:
            - predicate: q_educ_q1.outcome != 0
            - predicate: respondent_age >= 15
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # EDUC-Q3: Post-secondary attendance
        # Skipped if no schooling or age < 15
        - id: q_educ_q3
          kind: Question
          title: "Have you ever attended any other kind of school such as a university, community college, business school, trade or vocational school, CEGEP or other post-secondary institution?"
          precondition:
            - predicate: q_educ_q1.outcome != 0
            - predicate: respondent_age >= 15
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # EDUC-Q4: Highest level of education attained
        # Only if attended post-secondary (Q3 == YES)
        - id: q_educ_q4
          kind: Question
          title: "What is the highest level of education that you have attained?"
          precondition:
            - predicate: q_educ_q1.outcome != 0
            - predicate: respondent_age >= 15
            - predicate: q_educ_q3.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Some trade, technical or vocational school, or business college"
              2: "Some community college, CEGEP, or nursing school"
              3: "Some university"
              4: "Diploma or certificate from trade, technical or vocational school, or business college"
              5: "Diploma or certificate from community college, CEGEP or nursing school"
              6: "Bachelor or undergraduate degree, or teacher's college (e.g. B.A., B.Sc., LL.B.)"
              7: "Master's (e.g. M.A., M.Sc., M.Ed.)"
              8: "Degree in medicine, dentistry, veterinary medicine, law, optometry, or divinity"
              9: "Earned doctorate"

        # EDUC-Q5: Currently attending school
        # EDUC-C1A: IF AGE < 15, skip to next section
        # EDUC-C5: IF AGE >= 65, skip to next section
        # Also skipped if no schooling
        - id: q_educ_q5
          kind: Question
          title: "Are you currently attending a school, college or university?"
          precondition:
            - predicate: q_educ_q1.outcome != 0
            - predicate: respondent_age >= 15
            - predicate: respondent_age < 65
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # EDUC-Q6: Full-time or part-time
        # Only if currently attending school (Q5 == YES)
        - id: q_educ_q6
          kind: Question
          title: "Are you enrolled as a full-time or part-time student?"
          precondition:
            - predicate: q_educ_q1.outcome != 0
            - predicate: respondent_age >= 15
            - predicate: respondent_age < 65
            - predicate: q_educ_q5.outcome == 1
          input:
            control: Radio
            labels:
              1: "Full-time"
              2: "Part-time"

    # ===================================================================
    # SECTION: labour_force
    # ===================================================================
    # =========================================================================
    # BLOCK 1: MAIN ACTIVITY AND EMPLOYMENT GATE
    # =========================================================================
    # LFS-C1: IF NOT PARENT, GO TO NEXT SECTION
    # Entire section is gated by is_parent == 1.
    #
    # LFS-Q1: Main activity classification
    # LFS-I2: Employment intro
    # LFS-C2: IF Q1=Working or Caring+Working -> GO TO Q3 (skip Q2)
    # LFS-Q2: Worked for pay in past 12 months?
    # LFS-C2A: IF Q1=RETIRED -> exit section; ELSE -> Q17B
    # =========================================================================
    - id: b_main_activity
      title: "Main Activity"
      precondition:
        - predicate: is_parent == 1
      items:
        # LFS-Q1: Current main activity
        - id: q_lfs_q1
          kind: Question
          title: "What do/does ... consider to be your/his/her current main activity? (For example, working for pay, caring for family.)"
          input:
            control: Dropdown
            labels:
              1: "Caring for family"
              2: "Working for pay or profit"
              3: "Caring for family and working for pay or profit"
              4: "Going to school"
              5: "Recovering from illness / on disability"
              6: "Looking for work"
              7: "Retired"
              8: "Other"

        # LFS-I2: Employment intro
        - id: q_lfs_i2
          kind: Comment
          title: "The next section contains questions about jobs or employment which ... have/has had during the past 12 months, that is, from 12 months ago to today. Please include such employment as part-time jobs, contract work, baby sitting and any other paid work."

        # LFS-Q2: Worked for pay in past 12 months?
        # LFS-C2: IF Q1=2 (Working) or Q1=3 (Caring+Working) -> skip to Q3
        # So Q2 is only shown when Q1 is NOT 2 or 3.
        - id: q_lfs_q2
          kind: Question
          title: "Have/has you/he/she worked for pay or profit at any time in the past 12 months?"
          precondition:
            - predicate: q_lfs_q1.outcome not in [2, 3]
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

    # =========================================================================
    # BLOCK 2: EMPLOYMENT DETAILS (Q3-Q16E)
    # =========================================================================
    # Reached when:
    #   - Q1=2 or Q1=3 (currently working -> jumped to Q3), OR
    #   - Q2=1 (worked for pay in past 12 months)
    # NOT reached when Q2=2 (no work) -- those go to Q17B or exit.
    #
    # LFS-Q3: Employer name (open text)
    # LFS-Q4: Had job 1 year ago? Y=GO TO Q6, N=Q5
    # LFS-Q5: Start date (date -> modeled as year editbox)
    # LFS-Q6: Currently have that job? Y=GO TO Q8, N=Q7
    # LFS-Q7: Stop date (date -> modeled as year editbox)
    # LFS-Q8: Hours per week
    # LFS-Q9: Work schedule
    # LFS-Q10: Weekends?
    # LFS-Q11: Other jobs? Y=Q12, N=GO TO Q13
    # LFS-Q12: Which was main job? (roster selection -> modeled as Radio)
    # LFS-Q13-Q15: Industry/occupation/duties (open text)
    # LFS-Q16: Class of worker
    # =========================================================================
    - id: b_employment_details
      title: "Employment Details"
      precondition:
        - predicate: is_parent == 1
        - predicate: q_lfs_q1.outcome in [2, 3] or q_lfs_q2.outcome == 1
      items:
        # LFS-Q3: Employer name
        - id: q_lfs_q3
          kind: Question
          title: "For whom/whom else have/has you/he/she worked for pay or profit in the past 12 months?"
          input:
            control: Textarea
            placeholder: "Enter employer name"

        # LFS-Q4: Had job 1 year ago?
        - id: q_lfs_q4
          kind: Question
          title: "Did you/he/she have that job 1 year ago, that is, on (date 12 months ago) without a break in employment since then?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # LFS-Q5: When started? (only if Q4=No)
        # LFS-Q4: YES -> GO TO Q6 (skip Q5)
        - id: q_lfs_q5
          kind: Question
          title: "When did you/he/she start working at this job or business? (Enter year)"
          precondition:
            - predicate: q_lfs_q4.outcome == 2
          input:
            control: Editbox
            min: 1950
            max: 2030
            right: "year"

        # LFS-Q6: Currently have that job?
        - id: q_lfs_q6
          kind: Question
          title: "Do/Does you/he/she now have that job?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # LFS-Q7: When stopped? (only if Q6=No)
        # LFS-Q6: YES -> GO TO Q8 (skip Q7)
        - id: q_lfs_q7
          kind: Question
          title: "When did you/he/she stop working at this job or business? (Enter year)"
          precondition:
            - predicate: q_lfs_q6.outcome == 2
          input:
            control: Editbox
            min: 1950
            max: 2030
            right: "year"

        # LFS-Q8: Hours per week
        - id: q_lfs_q8
          kind: Question
          title: "About how many hours per week do/does/did you/he/she usually work at this job? (If irregular working schedule, enter the average per week for the last 4 weeks worked.)"
          input:
            control: Editbox
            min: 0
            max: 168
            right: "hours/week"

        # LFS-Q9: Work schedule
        - id: q_lfs_q9
          kind: Question
          title: "Which of the following best describes the hours you/he/she usually work/works/worked at this job?"
          input:
            control: Dropdown
            labels:
              1: "Regular daytime schedule or shift"
              2: "Regular evening shift"
              3: "Regular night shift"
              4: "Rotating shift (change from days to evenings to nights)"
              5: "Split shift"
              6: "On call"
              7: "Irregular schedule"
              8: "Other"

        # LFS-Q10: Weekend work?
        - id: q_lfs_q10
          kind: Question
          title: "Do/Does/Did you/he/she usually work on weekends at this job?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # LFS-Q11: Other jobs?
        - id: q_lfs_q11
          kind: Question
          title: "Did you/he/she do any other work for pay or profit in the past 12 months?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # LFS-Q12: Which was main job?
        # LFS-C12: IF Q11=NO -> GO TO Q13 (skip Q12)
        - id: q_lfs_q12
          kind: Question
          title: "Which was the main job?"
          precondition:
            - predicate: q_lfs_q11.outcome == 1
          input:
            control: Radio
            labels:
              1: "First job mentioned"
              2: "Second job mentioned"
              3: "Third job mentioned"

        # LFS-Q13: Industry (open text)
        - id: q_lfs_q13
          kind: Question
          title: "Thinking about this/the main job, what kind of business, service or industry is this? (For example, wheat farm, trapping, road maintenance, retail shoe store, secondary school.)"
          input:
            control: Textarea
            placeholder: "Enter industry description"

        # LFS-Q14: Occupation (open text)
        - id: q_lfs_q14
          kind: Question
          title: "Again, thinking about this/the main job, what kind of work was/were ... doing? (For example, medical lab technician, accounting clerk, secondary school teacher, supervisor of data entry unit, food processing labourer.)"
          input:
            control: Textarea
            placeholder: "Enter occupation description"

        # LFS-Q15: Duties (open text)
        - id: q_lfs_q15
          kind: Question
          title: "In this work, what were your/his/her most important duties or activities? (For example, analysis of blood samples, verifying invoices, teaching mathematics, organizing work schedules, cleaning vegetables.)"
          input:
            control: Textarea
            placeholder: "Enter duties description"

        # LFS-Q16: Class of worker
        # Routes: 1=wages -> Q16A; 2=own business -> C17; 3=unpaid -> C17
        - id: q_lfs_q16
          kind: Question
          title: "Did you/he/she work mainly for others for wages, salary or commission, or in your/his/her own business, farm or professional practice?"
          input:
            control: Radio
            labels:
              1: "For others for wages, salary or commission"
              2: "In own business, farm or professional practice"
              3: "Unpaid family worker"

    # =========================================================================
    # BLOCK 3: WAGE DETAILS (Q16A-Q16E)
    # =========================================================================
    # Only for employees (Q16=1 -- wages, salary or commission).
    # Own business (Q16=2) and unpaid (Q16=3) skip to C17.
    #
    # LFS-Q16A: Paid hours per week (CATI: DK->Q16B, R->C17)
    # LFS-Q16B: Tips/commissions? YES->Q16C, NO->Q16CC, DK->Q16CC, REF->C17
    # LFS-Q16C: Wage including tips (CATI: answer->Q16D, DK/R->C17)
    # LFS-Q16CC: Wage without tips (CATI: DK/R->C17)
    # LFS-Q16D: Pay period. 09=OTHER->Q16E; all others->C17
    # LFS-Q16E: Total earnings (CATI: DK/R->C17)
    #
    # NOTE: CATI DK/Refusal codes on numeric items (Q16A, Q16C, Q16CC, Q16E)
    # allowed interviewers to skip wage sub-flow on non-response. In
    # self-administered QML, Editbox controls require a numeric answer;
    # the DK/R skip paths are a CATI administration concern, not
    # questionnaire logic. The core routing (Q16B gates C vs CC, Q16D
    # gates Q16E) is fully modeled.
    # =========================================================================
    - id: b_wage_details
      title: "Wage Details"
      precondition:
        - predicate: is_parent == 1
        - predicate: q_lfs_q1.outcome in [2, 3] or q_lfs_q2.outcome == 1
        - predicate: q_lfs_q16.outcome == 1
      items:
        # LFS-Q16A: Paid hours per week
        - id: q_lfs_q16a
          kind: Question
          title: "At this job, about how many hours per week were/was you/he/she paid for?"
          input:
            control: Editbox
            min: 0
            max: 168
            right: "hours/week"

        # LFS-Q16B: Tips/commissions/bonuses?
        # 1=YES -> Q16C; 2=NO -> Q16CC; 8=DK -> Q16CC; 9=REFUSAL -> skip to C17
        - id: q_lfs_q16b
          kind: Question
          title: "At this job, did you/he/she receive any tips, commissions, bonuses, or paid overtime?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

        # LFS-Q16C: Wage including tips (only if Q16B=YES)
        - id: q_lfs_q16c
          kind: Question
          title: "At this job, including tips, commissions, bonuses, or paid overtime, what was your/his/her usual wage or salary before taxes and other deductions from the employer?"
          precondition:
            - predicate: q_lfs_q16b.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 999999
            right: "dollars"

        # LFS-Q16CC: Wage without tips (only if Q16B=NO or DK)
        - id: q_lfs_q16cc
          kind: Question
          title: "At this job, what was your/his/her usual wage or salary before taxes and other deductions from the employer?"
          precondition:
            - predicate: q_lfs_q16b.outcome in [2, 8]
          input:
            control: Editbox
            min: 0
            max: 999999
            right: "dollars"

        # LFS-Q16D: Pay period
        # All options except 9 (OTHER) -> GO TO C17. Only 9=OTHER continues to Q16E.
        - id: q_lfs_q16d
          kind: Question
          title: "Was this ..."
          precondition:
            - predicate: q_lfs_q16b.outcome != 9
          input:
            control: Dropdown
            labels:
              1: "Per hour"
              2: "Per day"
              3: "Per week"
              4: "Every two weeks"
              5: "Twice a month"
              6: "Per month"
              7: "Per year"
              8: "Since starting at this job this year"
              9: "Other"
              98: "Don't know"
              99: "Refusal"

        # LFS-Q16E: Total earnings (only if Q16D=OTHER)
        - id: q_lfs_q16e
          kind: Question
          title: "At this job, what was your/his/her total earnings?"
          precondition:
            - predicate: q_lfs_q16b.outcome != 9
            - predicate: q_lfs_q16d.outcome == 9
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "dollars"

    # =========================================================================
    # BLOCK 4: EMPLOYMENT GAPS (C17, C17A, Q17A, Q17B)
    # =========================================================================
    # LFS-C17: CHECK CALENDAR FOR GAPS > 6 DAYS. IF NO GAPS -> NEXT SECTION.
    #   Modeled as a question: "Were there any gaps > 6 days in employment?"
    #   has_gaps variable tracks this.
    #
    # LFS-C17A: IF Q6=1 (currently employed) -> Q17A; ELSE -> Q17B
    # LFS-Q17A: Reason not working (for currently employed, about most recent gap)
    # LFS-Q17B: Reason not working (for not currently employed)
    #
    # Q17B is also reached from C2A when Q2=NO and Q1 != 7 (not retired).
    # =========================================================================
    - id: b_employment_gaps
      title: "Employment Gaps"
      precondition:
        - predicate: is_parent == 1
      items:
        # LFS-C17: Calendar gap check
        # Modeled as a question since the original check references external
        # calendar data. Only shown to those who had employment details.
        - id: q_lfs_c17
          kind: Question
          title: "Were there any gaps of more than 6 days in employment during the past 12 months?"
          precondition:
            - predicate: q_lfs_q1.outcome in [2, 3] or q_lfs_q2.outcome == 1
          codeBlock: |
            has_gaps = q_lfs_c17.outcome
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # LFS-Q17A: Reason not working — currently employed with gaps
        # LFS-C17A: IF Q6=1 (currently employed) -> Q17A
        - id: q_lfs_q17a
          kind: Question
          title: "What was the reason that ... were/was not working for pay or profit during the most recent period away from work in the past year?"
          precondition:
            - predicate: q_lfs_q1.outcome in [2, 3] or q_lfs_q2.outcome == 1
            - predicate: has_gaps == 1
            - predicate: q_lfs_q6.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Own illness or disability"
              2: "Pregnancy"
              3: "Caring for own children"
              4: "Caring for elder relative(s)"
              5: "Other personal or family responsibilities"
              6: "School or educational leave"
              7: "Labour dispute"
              8: "Temporary layoff due to seasonal conditions"
              9: "Temporary layoff - non-seasonal"
              10: "Permanent layoff"
              11: "Unpaid or partially paid leave"
              12: "Other"
              13: "No period not working for pay or profit in the past year"

        # LFS-Q17B: Reason currently not working
        # Reached from two paths:
        #   Path A: Had employment details + gaps + Q6 != 1 (not currently employed)
        #   Path B: Q2=NO and Q1 != 7 (not retired, no work in past 12 months)
        - id: q_lfs_q17b
          kind: Question
          title: "What is the reason that ... are/is currently not working for pay or profit?"
          precondition:
            - predicate: (q_lfs_q1.outcome not in [2, 3] and q_lfs_q2.outcome == 2 and q_lfs_q1.outcome != 7) or (has_gaps == 1 and q_lfs_q6.outcome == 2)
          input:
            control: Dropdown
            labels:
              1: "Own illness or disability"
              2: "Pregnancy"
              3: "Caring for own children"
              4: "Caring for elder relative(s)"
              5: "Other personal or family responsibilities"
              6: "School or educational leave"
              7: "Labour dispute"
              8: "Temporary layoff due to seasonal conditions"
              9: "Temporary layoff - non-seasonal"
              10: "Permanent layoff"
              11: "Unpaid or partially paid leave"
              12: "Other"
              13: "No period not working for pay or profit in the past year"

    # ===================================================================
    # SECTION: income
    # ===================================================================
    # =========================================================================
    # BLOCK 1: HOUSEHOLD INCOME SOURCES
    # =========================================================================
    # INCOM-Q1: Sources of household income (mark all that apply)
    #   Option 14=None → GO TO NEXT SECTION (modeled as gate question)
    # INCOM-C1A: IF more than one source → ask Q2; otherwise skip Q2
    # INCOM-Q2: Main source of income (only when multiple sources)
    # =========================================================================
    - id: b_income_sources
      title: "Household Income Sources"
      items:
        # INCOM-Q1 gate: option 14=None (GO TO NEXT SECTION)
        # Modeled as a switch since "None" is exclusive with all other options
        - id: q_incom_has_income
          kind: Question
          title: "Did your household receive income from any source in the past 12 months?"
          codeBlock: |
            has_income = q_incom_has_income.outcome
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # INCOM-Q1: Income sources (mark all that apply)
        # Only shown when household has income
        - id: q_incom_q1
          kind: Question
          title: "From which of the following sources did your household receive income in the past 12 months? (Mark all that apply.)"
          precondition:
            - predicate: has_income == 1
          codeBlock: |
            # INCOM-C1A: check if multiple sources selected
            # With power-of-2 encoding, a single source is always a power of 2.
            # If outcome is not a power of 2, multiple sources were selected.
            # Check: n > 0 and (n & (n-1)) != 0 → multiple sources.
            # Since bitwise ops aren't available, count set bits via explicit checks.
            source_count = 0
            if q_incom_q1.outcome >= 4096: source_count = source_count + 1
            if q_incom_q1.outcome % 4096 >= 2048: source_count = source_count + 1
            if q_incom_q1.outcome % 2048 >= 1024: source_count = source_count + 1
            if q_incom_q1.outcome % 1024 >= 512: source_count = source_count + 1
            if q_incom_q1.outcome % 512 >= 256: source_count = source_count + 1
            if q_incom_q1.outcome % 256 >= 128: source_count = source_count + 1
            if q_incom_q1.outcome % 128 >= 64: source_count = source_count + 1
            if q_incom_q1.outcome % 64 >= 32: source_count = source_count + 1
            if q_incom_q1.outcome % 32 >= 16: source_count = source_count + 1
            if q_incom_q1.outcome % 16 >= 8: source_count = source_count + 1
            if q_incom_q1.outcome % 8 >= 4: source_count = source_count + 1
            if q_incom_q1.outcome % 4 >= 2: source_count = source_count + 1
            if q_incom_q1.outcome % 2 >= 1: source_count = source_count + 1
            if source_count > 1:
                multiple_sources = 1
          input:
            control: Checkbox
            labels:
              1: "Wages and salaries"
              2: "Income from self-employment"
              4: "Dividends and interest (e.g., on bonds, deposits, etc.)"
              8: "Unemployment insurance"
              16: "Worker's compensation"
              32: "Benefits from Canada or Quebec Pension Plan"
              64: "Retirement pensions, superannuation and annuities"
              128: "Old Age Security and Guaranteed Income Supplement"
              256: "Child Tax Benefit"
              512: "Provincial or municipal social assistance or welfare"
              1024: "Child support"
              2048: "Alimony"
              4096: "Other (e.g., other government, rental income, scholarships)"

        # INCOM-Q2: Main source of income
        # INCOM-C1A: only asked when multiple sources indicated
        - id: q_incom_q2
          kind: Question
          title: "What was the main source of income for your household?"
          precondition:
            - predicate: has_income == 1
            - predicate: multiple_sources == 1
          input:
            control: Dropdown
            labels:
              1: "Wages and salaries"
              2: "Income from self-employment"
              3: "Dividends and interest (e.g., on bonds, deposits, etc.)"
              4: "Unemployment insurance"
              5: "Worker's compensation"
              6: "Benefits from Canada or Quebec Pension Plan"
              7: "Retirement pensions, superannuation and annuities"
              8: "Old Age Security and Guaranteed Income Supplement"
              9: "Child Tax Benefit"
              10: "Provincial or municipal social assistance or welfare"
              11: "Child support"
              12: "Alimony"
              13: "Other (e.g., other government, rental income, scholarships)"

    # =========================================================================
    # BLOCK 2: HOUSEHOLD INCOME AMOUNT
    # =========================================================================
    # INCOM-Q3: Exact household income
    # INCOM-Q3_GATE: Can respondent estimate exact amount?
    # INCOM-Q3B: Household income bracket (fallback when exact unknown)
    # =========================================================================
    - id: b_household_income
      title: "Household Income"
      precondition:
        - predicate: has_income == 1
      items:
        # Gate question: Can the respondent estimate exact household income?
        - id: q_incom_q3_gate
          kind: Question
          title: "Can you estimate the exact total household income before taxes and deductions from all sources in the past 12 months?"
          codeBlock: |
            household_income_known = q_incom_q3_gate.outcome
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # INCOM-Q3: Exact household income (shown when respondent can estimate)
        - id: q_incom_q3
          kind: Question
          title: "What is your best estimate of the total income before taxes and deductions of all household members from all sources in the past 12 months?"
          precondition:
            - predicate: household_income_known == 1
          input:
            control: Editbox
            min: 0
            max: 999999
            left: "$"

        # INCOM-Q3B: Household income bracket (shown when exact amount unknown)
        # Original uses a cascading binary search tree; modeled here as a
        # single Dropdown with the final bracket options.
        - id: q_incom_q3b
          kind: Question
          title: "Can you estimate in which of the following groups your household income falls?"
          precondition:
            - predicate: household_income_known == 0
          input:
            control: Dropdown
            labels:
              1: "Less than $5,000"
              2: "$5,000 to less than $10,000"
              3: "$10,000 to less than $15,000"
              4: "$15,000 to less than $20,000"
              5: "$20,000 to less than $30,000"
              6: "$30,000 to less than $40,000"
              7: "$40,000 to less than $50,000"
              8: "$50,000 to less than $60,000"
              9: "$60,000 to less than $80,000"
              10: "$80,000 or more"

    # =========================================================================
    # BLOCK 3: PERSONAL INCOME AMOUNT
    # =========================================================================
    # INCOM-Q4: Exact personal income
    # INCOM-Q4_GATE: Can respondent estimate exact amount?
    # INCOM-Q4B: Personal income bracket (fallback when exact unknown)
    # =========================================================================
    - id: b_personal_income
      title: "Personal Income"
      precondition:
        - predicate: has_income == 1
      items:
        # Gate question: Can the respondent estimate exact personal income?
        - id: q_incom_q4_gate
          kind: Question
          title: "Can you estimate the exact total personal income before taxes and deductions from all sources in the past 12 months?"
          codeBlock: |
            personal_income_known = q_incom_q4_gate.outcome
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # INCOM-Q4: Exact personal income (shown when respondent can estimate)
        - id: q_incom_q4
          kind: Question
          title: "What is your best estimate of your total personal income before taxes and deductions from all sources in the past 12 months?"
          precondition:
            - predicate: personal_income_known == 1
          input:
            control: Editbox
            min: 0
            max: 999999
            left: "$"

        # INCOM-Q4B: Personal income bracket (shown when exact amount unknown)
        # Same cascading-to-Dropdown simplification as INCOM-Q3B.
        - id: q_incom_q4b
          kind: Question
          title: "Can you estimate in which of the following groups your personal income falls?"
          precondition:
            - predicate: personal_income_known == 0
          input:
            control: Dropdown
            labels:
              1: "Less than $5,000"
              2: "$5,000 to less than $10,000"
              3: "$10,000 to less than $15,000"
              4: "$15,000 to less than $20,000"
              5: "$20,000 to less than $30,000"
              6: "$30,000 to less than $40,000"
              7: "$40,000 to less than $50,000"
              8: "$50,000 to less than $60,000"
              9: "$60,000 to less than $80,000"
              10: "$80,000 or more"

    # ===================================================================
    # SECTION: adult_health
    # ===================================================================
    # =========================================================================
    # BLOCK 1: GENERAL HEALTH AND SMOKING (CHLT-Q1 to CHLT-Q3)
    # =========================================================================
    - id: b_general_health
      title: "General Health and Smoking"
      items:
        # CHLT-Q1: General health rating
        - id: q_chlt_q1
          kind: Question
          title: "In general, would you say your health is:"
          input:
            control: Radio
            labels:
              1: "Excellent"
              2: "Very good"
              3: "Good"
              4: "Fair"
              5: "Poor"

        # CHLT-Q2: Smoking frequency
        - id: q_chlt_q2
          kind: Question
          title: "At the present time, do you smoke cigarettes daily, occasionally, or not at all?"
          input:
            control: Radio
            labels:
              1: "Daily"
              2: "Occasionally"
              3: "Not at all"

        # CHLT-Q3: Cigarettes per day
        # Precondition: daily smoker only (Q2 == 1)
        # If occasionally or not at all → skip to alcohol section
        - id: q_chlt_q3
          kind: Question
          title: "How many cigarettes do you smoke each day now?"
          precondition:
            - predicate: q_chlt_q2.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 100
            right: "cigarettes"

    # =========================================================================
    # BLOCK 2: ALCOHOL CONSUMPTION (CHLT-I4 to CHLT-Q7)
    # =========================================================================
    - id: b_alcohol
      title: "Alcohol Consumption"
      items:
        # CHLT-I4: Introduction to alcohol questions
        - id: q_chlt_i4
          kind: Comment
          title: "Now, some questions about alcohol consumption."

        # CHLT-Q4: Drank in past 12 months
        - id: q_chlt_q4
          kind: Question
          title: "During the past 12 months, have you had a drink of beer, wine, liquor, or any other alcoholic beverage?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # CHLT-Q5: Drinking frequency
        # Precondition: drank in past 12 months (Q4 == 1)
        - id: q_chlt_q5
          kind: Question
          title: "During the past 12 months, how often did you drink alcoholic beverages?"
          precondition:
            - predicate: q_chlt_q4.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Every day"
              2: "4 to 6 times a week"
              3: "2 to 3 times a week"
              4: "Once a week"
              5: "2 to 3 times a month"
              6: "Once a month"
              7: "Less than once a month"

        # CHLT-Q6: Binge drinking occasions
        # Precondition: drank in past 12 months (Q4 == 1)
        - id: q_chlt_q6
          kind: Question
          title: "How many times in the past 12 months have you had 5 or more drinks on one occasion?"
          precondition:
            - predicate: q_chlt_q4.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 365
            right: "times"

        # CHLT-Q7: Highest number of drinks on one occasion
        # Precondition: drank in past 12 months (Q4 == 1)
        # NOTE: IF Q6 == 0 (no binge occasions) → GO TO CHLT-C8 (skip Q7)
        - id: q_chlt_q7
          kind: Question
          title: "In the past 12 months, what is the highest number of drinks you had on one occasion?"
          precondition:
            - predicate: q_chlt_q4.outcome == 1
            - predicate: q_chlt_q6.outcome != 0
          input:
            control: Editbox
            min: 1
            max: 50
            right: "drinks"

    # =========================================================================
    # BLOCK 3: MATERNAL HISTORY (CHLT-Q8 to CHLT-Q11)
    # =========================================================================
    # CHLT-C8: IF biological mother of child under 2, AND non-proxy
    #          → maternal questions; OTHERWISE → CES-D
    # Modeled as block precondition: is_bio_mother_young_child == 1
    # =========================================================================
    - id: b_maternal
      title: "Maternal History"
      precondition:
        - predicate: is_bio_mother_young_child == 1
      items:
        # CHLT-Q8: Number of pregnancies
        - id: q_chlt_q8
          kind: Question
          title: "How many times throughout your life have you been pregnant, including any pregnancies which did not go full term?"
          input:
            control: Editbox
            min: 1
            max: 30
            right: "pregnancies"

        # CHLT-Q9: Number of babies
        - id: q_chlt_q9
          kind: Question
          title: "How many babies have you had?"
          input:
            control: Editbox
            min: 1
            max: 20
            right: "babies"
          postcondition:
            - predicate: q_chlt_q9.outcome <= q_chlt_q8.outcome
              hint: "Number of babies cannot exceed number of pregnancies."

        # CHLT-Q11: Age at first baby
        - id: q_chlt_q11
          kind: Question
          title: "At what age did you have your first baby?"
          input:
            control: Editbox
            min: 10
            max: 55
            right: "years old"

    # =========================================================================
    # BLOCK 4: CES-D DEPRESSION SCALE (CHLT-Q12A to CHLT-Q12L)
    # =========================================================================
    # CHLT-C12: IF respondent is PMK → CES-D; OTHERWISE → next section
    # Modeled as block precondition: is_pmk == 1
    # =========================================================================
    - id: b_cesd
      title: "CES-D Depression Scale"
      precondition:
        - predicate: is_pmk == 1
      items:
        # CHLT-I12: Introduction
        - id: q_chlt_i12
          kind: Comment
          title: "The next set of statements describe feelings or behaviours. For each one, please tell me how often you felt or behaved this way during the past week."

        # CHLT-Q12A through Q12L: 12 CES-D items
        # Items F (index 5), H (index 7), J (index 9) are reverse-scored
        # (positive affect items scored inversely).
        # Scale: 1=Rarely, 2=Some of the time, 3=Occasionally, 4=Most of the time
        - id: qg_cesd
          kind: QuestionGroup
          title: "How often have you felt or behaved this way during the past week:"
          questions:
            - "(A) I did not feel like eating; my appetite was poor."
            - "(B) I felt that I could not shake off the blues even with help from my family or friends."
            - "(C) I had trouble keeping my mind on what I was doing."
            - "(D) I felt depressed."
            - "(E) I felt that everything I did was an effort."
            - "(F) I felt hopeful about the future."
            - "(G) My sleep was restless."
            - "(H) I was happy."
            - "(I) I felt lonely."
            - "(J) I enjoyed life."
            - "(K) I had crying spells."
            - "(L) I felt that people disliked me."
          input:
            control: Radio
            labels:
              1: "Rarely or none of the time (less than 1 day)"
              2: "Some or a little of the time (1-2 days)"
              3: "Occasionally or a moderate amount of time (3-4 days)"
              4: "Most or all of the time (5-7 days)"
          codeBlock: |
            # CES-D scoring: items are scored 0-3 (subtract 1 from each response)
            # Items F (index 5), H (index 7), J (index 9) are reverse-scored:
            #   reverse = 4 - response  (so 1→3, 2→2, 3→1, 4→0)
            # Regular items: score = response - 1  (so 1→0, 2→1, 3→2, 4→3)
            #
            # Regular items: A(0), B(1), C(2), D(3), E(4), G(6), I(8), K(10), L(11)
            cesd_score = (qg_cesd.outcome[0] - 1) + (qg_cesd.outcome[1] - 1) + (qg_cesd.outcome[2] - 1) + (qg_cesd.outcome[3] - 1) + (qg_cesd.outcome[4] - 1) + (qg_cesd.outcome[6] - 1) + (qg_cesd.outcome[8] - 1) + (qg_cesd.outcome[10] - 1) + (qg_cesd.outcome[11] - 1)
            # Reverse-scored items: F(5), H(7), J(9)
            cesd_score = cesd_score + (4 - qg_cesd.outcome[5]) + (4 - qg_cesd.outcome[7]) + (4 - qg_cesd.outcome[9])

    # ===================================================================
    # SECTION: family_functioning
    # ===================================================================
    # =========================================================================
    # BLOCK 1: FAMILY FUNCTIONING (FNC)
    # =========================================================================
    # FNC-C1: "IF THIS SECTION HAS BEEN COMPLETED FOR ANOTHER HOUSEHOLD
    #          MEMBER -> SKIP". This is a system-level check that cannot be
    #          expressed in QML; modeled as always shown.
    # =========================================================================
    - id: b_family_functioning
      title: "Family Functioning"
      items:
        # FNC-I1: Intro text
        - id: q_fnc_intro
          kind: Comment
          title: "The following statements are about families and family relationships. For each one, please indicate which response best describes your family: strongly agree, agree, disagree or strongly disagree."

        # FNC-Q1A through FNC-Q1M: 13 family functioning statements
        # All share a 4-point agree/disagree scale.
        # Index mapping:
        #   [0]  Q1A - Planning activities / misunderstand
        #   [1]  Q1B - Crisis support
        #   [2]  Q1C - Cannot talk about sadness
        #   [3]  Q1D - Accepted for what they are
        #   [4]  Q1E - Avoid discussing fears
        #   [5]  Q1F - Express feelings
        #   [6]  Q1G - Bad feelings in family
        #   [7]  Q1H - Feel accepted
        #   [8]  Q1I - Decisions are a problem
        #   [9]  Q1J - Able to solve problems
        #   [10] Q1K - Don't get along well
        #   [11] Q1L - Confide in each other
        #   [12] Q1M - Drinking is source of tension
        - id: qg_fnc
          kind: QuestionGroup
          title: "Please indicate how much you agree or disagree with each of the following statements about your family:"
          questions:
            - "(a) Planning family activities is difficult because we misunderstand each other."
            - "(b) In times of crisis we can turn to each other for support."
            - "(c) We cannot talk to each other about sadness we feel."
            - "(d) Individuals in the family are accepted for what they are."
            - "(e) We avoid discussing our fears or concerns."
            - "(f) We express feelings to each other."
            - "(g) There are lots of bad feelings in our family."
            - "(h) We feel accepted for what we are."
            - "(i) Making decisions is a problem for our family."
            - "(j) We are able to make decisions about how to solve problems."
            - "(k) We don't get along well together."
            - "(l) We confide in each other."
            - "(m) Drinking is a source of tension or disagreement in our family."
          input:
            control: Radio
            labels:
              1: "Strongly agree"
              2: "Agree"
              3: "Disagree"
              4: "Strongly disagree"

        # FNC-C2: IF married/common-law/partner -> Q2; OTHERWISE -> next section
        # FNC-Q2: Marital satisfaction on 1-11 scale
        - id: q_fnc_satisfaction
          kind: Question
          title: "All things considered, how satisfied or dissatisfied are you with your marriage or relationship with your partner? Choose the number that comes closest to how you feel, where 1 is completely dissatisfied and 11 is completely satisfied."
          precondition:
            - predicate: marital_status in [1, 2, 3]
          input:
            control: Slider
            min: 1
            max: 11
            labels:
              1: "Completely dissatisfied"
              6: "Neutral"
              11: "Completely satisfied"

    # ===================================================================
    # SECTION: neighbourhood
    # ===================================================================
    # =========================================================================
    # BLOCK 1: NEIGHBOURHOOD SAFETY (SAF)
    # =========================================================================
    # SAF-C1: "IF THIS SECTION HAS BEEN COMPLETED FOR ANOTHER HOUSEHOLD
    #          MEMBER → SKIP" — system-level check; modeled as always shown.
    # SAF-Q2 option 9 (REFUSAL) and SAF-Q3 option 9 (REFUSAL) trigger
    # GO TO NEXT SECTION in the original CATI. Modeled by excluding DK/REF
    # options: respondents who refuse simply don't continue, and downstream
    # items have no precondition gating (straightforward sequential flow).
    # =========================================================================
    - id: b_neighbourhood
      title: "Neighbourhood Safety"
      items:
        # SAF-C1: System-level check — modeled as introductory comment
        - id: q_saf_c1
          kind: Comment
          title: "This section asks questions about your neighbourhood."

        # SAF-Q1: Years at current address
        - id: q_saf_q1
          kind: Question
          title: "How many years have you lived at this address? (Enter 0 if less than 1 year.)"
          input:
            control: Editbox
            min: 0
            max: 99
            right: "years"

        # SAF-Q2: Neighbourhood as place for children
        - id: q_saf_q2
          kind: Question
          title: "How do you feel about your neighbourhood as a place to bring up children? Is it..."
          input:
            control: Radio
            labels:
              1: "Excellent"
              2: "Good"
              3: "Average"
              4: "Poor"
              5: "Very poor"

        # SAF-Q3: Involvement in voluntary organizations
        - id: q_saf_q3
          kind: Question
          title: "Are you involved in any local voluntary organizations such as school groups, church groups, community or ethnic associations?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # SAF-I5A / Q5A-Q5C: Safety perceptions (4-point agree/disagree)
        - id: qg_saf_q5
          kind: QuestionGroup
          title: "Please tell me whether you strongly agree, agree, disagree, or strongly disagree with these statements about your neighbourhood."
          questions:
            - "(a) It is safe to walk alone in this neighbourhood after dark."
            - "(b) It is safe for children to play outside during the day."
            - "(c) There are good parks, playgrounds and play spaces in this neighbourhood."
          input:
            control: Radio
            labels:
              1: "Strongly agree"
              2: "Agree"
              3: "Disagree"
              4: "Strongly disagree"

        # SAF-I6A / Q6A-Q6E: Social cohesion (4-point agree/disagree)
        - id: qg_saf_q6
          kind: QuestionGroup
          title: "The following statements are about people in your neighbourhood. Please tell me whether you strongly agree, agree, disagree, or strongly disagree."
          questions:
            - "(a) If there is a problem around here, the neighbours get together to deal with it."
            - "(b) There are adults in the neighbourhood that children can look up to."
            - "(c) People around here are willing to help their neighbours."
            - "(d) You can count on adults in this neighbourhood to watch out that children are safe and don't get in trouble."
            - "(e) When I'm away from home, I know that my neighbours will keep their eyes open for possible trouble."
          input:
            control: Radio
            labels:
              1: "Strongly agree"
              2: "Agree"
              3: "Disagree"
              4: "Strongly disagree"

        # SAF-I7A / Q7A-Q7F: Neighbourhood problems (3-point scale)
        - id: qg_saf_q7
          kind: QuestionGroup
          title: "How much of a problem is each of the following in this neighbourhood?"
          questions:
            - "(a) Litter, broken glass or garbage in the street or road, on the sidewalk, or in yards."
            - "(b) Selling or using drugs."
            - "(c) Alcoholics and excessive drinking in public."
            - "(d) Groups of young people who cause trouble."
            - "(e) Burglary of homes and apartments."
            - "(f) Unrest due to ethnic or religious differences."
          input:
            control: Radio
            labels:
              1: "A big problem"
              2: "Somewhat of a problem"
              3: "No problem"

    # ===================================================================
    # SECTION: social_support
    # ===================================================================
    # =========================================================================
    # BLOCK 1: SOCIAL SUPPORT (SUP)
    # =========================================================================
    # SUP-C1: "IF THIS SECTION HAS BEEN COMPLETED FOR ANOTHER HOUSEHOLD
    #          MEMBER → SKIP TO NEXT SECTION" — system-level check that
    #          cannot be modeled declaratively. Always show this section.
    # =========================================================================
    - id: b_social_support
      title: "Social Support"
      items:
        # SUP-I1: Introduction
        - id: q_sup_i1
          kind: Comment
          title: "The following statements are about relationships and the support which you get from others. For each of the following, please tell me whether you strongly disagree, disagree, agree, or strongly agree."

        # SUP-Q1A through SUP-Q1F: Six relationship support statements
        # 4-point agreement scale (1=Strongly Disagree to 4=Strongly Agree)
        # DON'T KNOW (8) and REFUSAL (9) are interviewer codes, omitted in
        # the declarative model — the respondent must choose 1-4.
        - id: qg_sup_q1
          kind: QuestionGroup
          title: "Please tell me whether you strongly disagree, disagree, agree, or strongly agree with each of the following statements:"
          questions:
            - "(a) If something went wrong, no one would help me."
            - "(b) I have family and friends who help me feel safe, secure and happy."
            - "(c) There is someone I trust whom I would turn to for advice if I were having problems."
            - "(d) There is no one I feel comfortable talking about problems with."
            - "(e) I lack a feeling of closeness with another person."
            - "(f) There are people I can count on in an emergency."
          input:
            control: Radio
            labels:
              1: "Strongly disagree"
              2: "Disagree"
              3: "Agree"
              4: "Strongly agree"

        # SUP-Q2A through SUP-Q2D: Help sources in past 12 months (Yes/No)
        - id: qg_sup_q2
          kind: QuestionGroup
          title: "Besides your friends and family, did any of the following help with your personal problems during the past 12 months?"
          questions:
            - "(a) Community or social service professionals?"
            - "(b) Health professionals?"
            - "(c) Religious or spiritual leaders or communities?"
            - "(d) Books or magazines?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

    # ===================================================================
    # SECTION: child_demographics
    # ===================================================================
    # =========================================================================
    # BLOCK 1: CHILD DEMOGRAPHICS (DVS)
    # =========================================================================
    # DVS-INT, DVS-Q1, DVS-Q2
    # Start of the Children's Questionnaire. Confirms respondent's
    # relationship to the selected child and sibling relationship.
    # =========================================================================
    - id: b_dvs
      title: "Child Demographics"
      items:
        # DVS-INT: Introduction to children's questionnaire
        - id: q_dvs_int
          kind: Comment
          title: "I need to confirm some of the information that we collected earlier, since it is important in determining which questions we need to ask you about the child."

        # DVS-Q1: Relationship of respondent to child
        - id: q_dvs_q1
          kind: Question
          title: "What is your relationship to the child?"
          input:
            control: Dropdown
            labels:
              1: "Birth parent"
              2: "Step parent (including common-law parent)"
              3: "Adoptive parent"
              4: "Foster parent"
              5: "Sister/Brother"
              6: "Grandparent"
              7: "In-law"
              8: "Other related"
              9: "Unrelated"
          codeBlock: |
            relationship_to_child = q_dvs_q1.outcome

        # DVS-Q2: Relationship of selected child to first child
        # Only asked when there are multiple selected children in the household
        - id: q_dvs_q2
          kind: Question
          title: "What is this child's relationship to the first selected child?"
          input:
            control: Radio
            labels:
              1: "Full sister/brother by birth"
              2: "Sister/brother - half, step, adopted, foster (including common-law siblings)"
              3: "Other related"
              4: "Unrelated"

    # ===================================================================
    # SECTION: child_health
    # ===================================================================
    # =========================================================================
    # BLOCK 1: GENERAL HEALTH (HLT-Q1 to HLT-Q5)
    # =========================================================================
    # All ages: Q1-Q4. Q5 for age 2+.
    # Q1: General health rating
    # Q2: Frequency in good health (skip if Q1=DK/REF)
    # Q3: Height
    # Q4: Weight
    # Q5: Physical activity (age 2+)
    # =========================================================================
    - id: b_child_health_general_health
      title: "General Health"
      items:
        # HLT-Q1: General health rating
        - id: q_hlt_q1
          kind: Question
          title: "In general, would you say the child's health is:"
          input:
            control: Radio
            labels:
              1: "Excellent"
              2: "Very good"
              3: "Good"
              4: "Fair"
              5: "Poor"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q2: Frequency in good health
        # GOTO: Q1=8(DK) or Q1=9(REF) -> skip to Q3
        - id: q_hlt_q2
          kind: Question
          title: "Over the past few months, how often has he/she been in good health?"
          precondition:
            - predicate: q_hlt_q1.outcome <= 5
          input:
            control: Radio
            labels:
              1: "Almost all the time"
              2: "Often"
              3: "About half of the time"
              4: "Sometimes"
              5: "Almost never"
              8: "Don't know"

        # HLT-Q3: Height
        - id: q_hlt_q3
          kind: Question
          title: "What is his/her height in feet and inches or in metres/centimetres (without shoes on)?"
          input:
            control: Editbox
            min: 0
            max: 200
            right: "cm"

        # HLT-Q4: Weight
        - id: q_hlt_q4
          kind: Question
          title: "What is his/her weight in kilograms (and grams) or in pounds (and ounces)?"
          input:
            control: Editbox
            min: 0
            max: 200
            right: "kg"

        # HLT-Q5: Physical activity (age 2+)
        # C5: IF AGE < 2 -> skip to I37
        - id: q_hlt_q5
          kind: Question
          title: "In your opinion, how physically active is the child compared to other children the same age and sex?"
          precondition:
            - predicate: child_age >= 2
          input:
            control: Radio
            labels:
              1: "Much more active"
              2: "Moderately more active"
              3: "Equally active"
              4: "Moderately less active"
              5: "Much less active"

    # =========================================================================
    # BLOCK 2: VISION (HLT-Q6 to HLT-Q10)
    # =========================================================================
    # Age 0-3: skip entire block (routed to I37 by C6)
    # Age 4-5: Q6A -> Q7A -> Q8 -> Q9 -> Q10
    # Age 6-11: Q6 -> Q7 -> Q8 -> Q9 -> Q10
    # Chain dependencies with various skip patterns based on answers.
    # =========================================================================
    - id: b_vision
      title: "Vision"
      precondition:
        - predicate: child_age >= 4
      items:
        # HLT-I6: Introduction to day-to-day health questions
        - id: q_hlt_i6
          kind: Comment
          title: "The next set of questions ask about the child's day to day health. The questions are not about illnesses like colds that affect people for short periods of time. They are concerned with his/her abilities relative to other children the same age. You may feel that some of these questions do not apply to him/her, but it is important that we ask the same questions of everyone."

        # HLT-Q6: Vision (newsprint) - age 6+
        # YES(1) -> Q9, NO(2) -> Q7, DK(8) -> Q7, REF(9) -> Q11
        - id: q_hlt_q6
          kind: Question
          title: "Is he/she usually able to see well enough to read ordinary newsprint without glasses or contact lenses?"
          precondition:
            - predicate: child_age >= 6
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q6A: Vision (storybook) - age 4-5
        # YES(1) -> Q9, NO(2) -> Q7A, DK(8) -> Q7A, REF(9) -> Q11
        - id: q_hlt_q6a
          kind: Question
          title: "Is he/she usually able to see clearly, and without distortion, the words in a story book without glasses or contact lenses?"
          precondition:
            - predicate: child_age >= 4 and child_age <= 5
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q7: Vision with correction (newsprint) - age 6+
        # Shown when Q6 answered NO(2) or DK(8)
        # YES(1)->Q9, NO(2)->Q8, DOESN'T WEAR(3)->Q8, DK(8)->Q8, REF(9)->Q11
        - id: q_hlt_q7
          kind: Question
          title: "Is he/she usually able to see well enough to read ordinary newsprint with glasses or contact lenses?"
          precondition:
            - predicate: child_age >= 6
            - predicate: q_hlt_q6.outcome == 2 or q_hlt_q6.outcome == 8
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Doesn't wear glasses or contact lenses"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q7A: Vision with correction (storybook) - age 4-5
        # Shown when Q6A answered NO(2) or DK(8)
        # YES(1)->Q9, NO(2)->Q8, DOESN'T WEAR(3)->Q8, DK(8)->Q8, REF(9)->Q11
        - id: q_hlt_q7a
          kind: Question
          title: "Is he/she usually able to see clearly, and without distortion, the words in a story book with glasses or contact lenses?"
          precondition:
            - predicate: child_age >= 4 and child_age <= 5
            - predicate: q_hlt_q6a.outcome == 2 or q_hlt_q6a.outcome == 8
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Doesn't wear glasses or contact lenses"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q8: Can see at all?
        # Reached when Q7=NO/DOESN'T WEAR/DK or Q7A=NO/DOESN'T WEAR/DK
        # YES(1)->Q9, NO(2)->Q11, DK(8)->Q11, REF(9)->Q11
        - id: q_hlt_q8
          kind: Question
          title: "Is he/she able to see at all?"
          precondition:
            - predicate: (child_age >= 6 and q_hlt_q7.outcome in [2, 3, 8]) or (child_age >= 4 and child_age <= 5 and q_hlt_q7a.outcome in [2, 3, 8])
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q9: Distance vision without correction
        # Reached from Q6=YES, Q6A=YES, Q7=YES, Q7A=YES, or Q8=YES
        # YES(1)->Q11, NO(2)->Q10, DK(8)->Q10, REF(9)->Q11
        - id: q_hlt_q9
          kind: Question
          title: "Is he/she able to see well enough to recognize a friend on the other side of the street without glasses or contact lenses?"
          precondition:
            - predicate: (child_age >= 6 and (q_hlt_q6.outcome == 1 or q_hlt_q7.outcome == 1)) or (child_age >= 4 and child_age <= 5 and (q_hlt_q6a.outcome == 1 or q_hlt_q7a.outcome == 1)) or q_hlt_q8.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q10: Distance vision with correction
        # Reached when Q9=NO(2) or Q9=DK(8)
        - id: q_hlt_q10
          kind: Question
          title: "Is he/she usually able to see well enough to recognize a friend on the other side of the street with glasses or contact lenses?"
          precondition:
            - predicate: q_hlt_q9.outcome == 2 or q_hlt_q9.outcome == 8
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Doesn't wear glasses or contacts"
              8: "Don't know"
              9: "Refusal"

    # =========================================================================
    # BLOCK 3: HEARING (HLT-Q11 to HLT-Q15)
    # =========================================================================
    # Age 0-3: skip (block inherits from vision block age gate, but hearing
    #   is also age 4+ per the routing table)
    # Q11: Hear in group without aid
    # Chain: Q11->Q12->Q13, Q12->Q14->Q15
    # =========================================================================
    - id: b_hearing
      title: "Hearing"
      precondition:
        - predicate: child_age >= 4
      items:
        # HLT-Q11: Hearing in group without aid
        # YES(1)->Q16, NO(2)->Q12, DK(8)->Q12, REF(9)->Q16
        - id: q_hlt_q11
          kind: Question
          title: "Is the child usually able to hear what is said in a group conversation with at least three other people without a hearing aid?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q12: Hearing in group with aid
        # YES(1)->Q14, NO(2)->Q13, DOESN'T WEAR(3)->Q13, DK(8)->Q13, REF(9)->Q16
        - id: q_hlt_q12
          kind: Question
          title: "Is he/she usually able to hear what is said in a group conversation with at least three other people with a hearing aid?"
          precondition:
            - predicate: q_hlt_q11.outcome == 2 or q_hlt_q11.outcome == 8
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Doesn't wear a hearing aid"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q13: Can hear at all?
        # YES(1)->Q14, NO(2)->Q16, DK(8)->Q16, REF(9)->Q16
        - id: q_hlt_q13
          kind: Question
          title: "Is he/she able to hear at all?"
          precondition:
            - predicate: q_hlt_q12.outcome in [2, 3, 8]
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q14: Hearing one-on-one without aid
        # Reached from Q12=YES(1) or Q13=YES(1)
        # YES(1)->Q16, NO(2)->Q15, DK(8)->Q15, REF(9)->Q16
        - id: q_hlt_q14
          kind: Question
          title: "Is he/she usually able to hear what is said in a conversation with one other person in a quiet room without a hearing aid?"
          precondition:
            - predicate: q_hlt_q12.outcome == 1 or q_hlt_q13.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q15: Hearing one-on-one with aid
        # Reached when Q14=NO(2) or Q14=DK(8)
        - id: q_hlt_q15
          kind: Question
          title: "Is he/she usually able to hear what is said in a conversation with one other person in a quiet room with a hearing aid?"
          precondition:
            - predicate: q_hlt_q14.outcome == 2 or q_hlt_q14.outcome == 8
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Doesn't wear a hearing aid"
              8: "Don't know"
              9: "Refusal"

    # =========================================================================
    # BLOCK 4: SPEECH (HLT-Q16 to HLT-Q19)
    # =========================================================================
    # Age 4+ only.
    # Q16: Understood by strangers
    # Chain: Q16->Q17->Q18->Q19
    # =========================================================================
    - id: b_speech
      title: "Speech"
      precondition:
        - predicate: child_age >= 4
      items:
        # HLT-Q16: Understood by strangers
        # YES(1)->C20(mobility), NO(2)->Q17, DK(8)->Q18, REF(9)->C20
        - id: q_hlt_q16
          kind: Question
          title: "Is the child usually able to be understood completely when speaking with strangers in his/her own language?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q17: Partially understood by strangers
        # Reached when Q16=NO(2)
        # YES(1)->C20, NO(2)->Q18, DK(8)->Q18, REF(9)->C20
        - id: q_hlt_q17
          kind: Question
          title: "Is he/she able to be understood partially when speaking with strangers in his/her own language?"
          precondition:
            - predicate: q_hlt_q16.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q18: Understood by familiar people
        # Reached when Q16=DK(8), Q17=NO(2), or Q17=DK(8)
        # YES(1)->C20, NO(2)->Q19, DK(8)->C20, REF(9)->C20
        - id: q_hlt_q18
          kind: Question
          title: "Is he/she able to be understood completely when speaking with those who know him/her well?"
          precondition:
            - predicate: q_hlt_q16.outcome == 8 or q_hlt_q17.outcome == 2 or q_hlt_q17.outcome == 8
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q19: Partially understood by familiar people
        # Reached when Q18=NO(2)
        - id: q_hlt_q19
          kind: Question
          title: "Is he/she able to be understood partially when speaking with those who know him/her well?"
          precondition:
            - predicate: q_hlt_q18.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

    # =========================================================================
    # BLOCK 5: MOBILITY / GETTING AROUND (HLT-Q20 to HLT-Q26)
    # =========================================================================
    # Age 4+ only.
    # Age 4-5: Q20A variant, Q22A variant
    # Age 6-11: Q20 variant, Q22 variant
    # Complex chain with wheelchair sub-path.
    # =========================================================================
    - id: b_mobility
      title: "Getting Around"
      precondition:
        - predicate: child_age >= 4
      items:
        # HLT-Q20: Walk around neighbourhood (age 6+)
        # YES(1)->Q27, NO(2)->Q21, DK(8)->Q21, REF(9)->Q27
        - id: q_hlt_q20
          kind: Question
          title: "Is the child usually able to walk around the neighbourhood without difficulty and without mechanical support such as braces, a cane or crutches?"
          precondition:
            - predicate: child_age >= 6
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q20A: Walk without difficulty (age 4-5)
        # YES(1)->Q27, NO(2)->Q21, DK(8)->Q21, REF(9)->Q27
        - id: q_hlt_q20a
          kind: Question
          title: "Is he/she usually able to walk without difficulty and without mechanical support such as braces, a cane or crutches?"
          precondition:
            - predicate: child_age >= 4 and child_age <= 5
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q21: Can walk at all?
        # Reached when Q20=NO/DK or Q20A=NO/DK
        # YES(1)->Q22/Q22A, NO(2)->Q24, DK(8)->Q24, REF(9)->Q27
        - id: q_hlt_q21
          kind: Question
          title: "Is he/she able to walk at all?"
          precondition:
            - predicate: (child_age >= 6 and q_hlt_q20.outcome in [2, 8]) or (child_age >= 4 and child_age <= 5 and q_hlt_q20a.outcome in [2, 8])
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q22: Requires mechanical support - neighbourhood (age 6+)
        # Reached when Q21=YES(1) and age 6+
        # All answers -> Q23 except REF(9)->Q27
        - id: q_hlt_q22
          kind: Question
          title: "Does he/she require mechanical support such as braces, a cane or crutches to be able to walk around the neighbourhood?"
          precondition:
            - predicate: child_age >= 6
            - predicate: q_hlt_q21.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q22A: Requires mechanical support - walk (age 4-5)
        # Reached when Q21=YES(1) and age 4-5
        # YES/NO/DK -> Q23, REF(9)->Q27
        - id: q_hlt_q22a
          kind: Question
          title: "Does he/she require mechanical support such as braces, a cane or crutches to be able to walk?"
          precondition:
            - predicate: child_age >= 4 and child_age <= 5
            - predicate: q_hlt_q21.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q23: Requires help of another person to walk
        # Reached from Q22 (not REF) or Q22A (not REF)
        # All answers go to Q27 except we just continue
        - id: q_hlt_q23
          kind: Question
          title: "Does he/she require the help of another person to be able to walk?"
          precondition:
            - predicate: (child_age >= 6 and q_hlt_q22.outcome in [1, 2, 8]) or (child_age >= 4 and child_age <= 5 and q_hlt_q22a.outcome in [1, 2, 8])
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q24: Wheelchair required
        # Reached when Q21=NO(2) or Q21=DK(8)
        # YES(1)->Q25, NO(2)->Q27, DK(8)->Q27, REF(9)->Q27
        - id: q_hlt_q24
          kind: Question
          title: "Does he/she require a wheelchair to get around?"
          precondition:
            - predicate: q_hlt_q21.outcome == 2 or q_hlt_q21.outcome == 8
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q25: How often uses wheelchair
        # Reached when Q24=YES(1)
        # All answers -> Q26 except REF(9)->Q27
        - id: q_hlt_q25
          kind: Question
          title: "How often does he/she use a wheelchair?"
          precondition:
            - predicate: q_hlt_q24.outcome == 1
          input:
            control: Radio
            labels:
              1: "Always"
              2: "Often"
              3: "Sometimes"
              4: "Never"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q26: Needs help in wheelchair
        # Reached when Q25 answered (not REF)
        - id: q_hlt_q26
          kind: Question
          title: "Does he/she need the help of another person to get around in the wheelchair?"
          precondition:
            - predicate: q_hlt_q25.outcome in [1, 2, 3, 4, 8]
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

    # =========================================================================
    # BLOCK 6: DEXTERITY / HANDS AND FINGERS (HLT-Q27 to HLT-Q30)
    # =========================================================================
    # Age 4+ only.
    # Q27: Grasp small objects
    # Chain: Q27->Q28->Q29, Q28->Q30
    # =========================================================================
    - id: b_dexterity
      title: "Hands and Fingers"
      precondition:
        - predicate: child_age >= 4
      items:
        # HLT-Q27: Grasp and handle small objects
        # YES(1)->Q31, NO(2)->Q28, DK(8)->Q31, REF(9)->Q31
        - id: q_hlt_q27
          kind: Question
          title: "Is the child usually able to grasp and handle small objects such as a pencil or scissors?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q28: Requires help due to hand/finger limitations
        # Reached when Q27=NO(2)
        # YES(1)->Q29, NO(2)->Q30, DK(8)->Q30, REF(9)->Q31
        - id: q_hlt_q28
          kind: Question
          title: "Does he/she require the help of another person because of limitations in the use of hands or fingers?"
          precondition:
            - predicate: q_hlt_q27.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q29: Level of help needed
        # Reached when Q28=YES(1)
        - id: q_hlt_q29
          kind: Question
          title: "Does he/she require the help of another person with:"
          precondition:
            - predicate: q_hlt_q28.outcome == 1
          input:
            control: Radio
            labels:
              1: "Some tasks"
              2: "Most tasks"
              3: "Almost all tasks"
              4: "All tasks"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q30: Requires special equipment
        # Reached when Q28=NO(2) or Q28=DK(8)
        - id: q_hlt_q30
          kind: Question
          title: "Does he/she require special equipment, for example, devices to assist in dressing because of limitations in the use of hands or fingers?"
          precondition:
            - predicate: q_hlt_q28.outcome == 2 or q_hlt_q28.outcome == 8
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

    # =========================================================================
    # BLOCK 7: COGNITION / FEELINGS (HLT-Q31 to HLT-Q33)
    # =========================================================================
    # Age 4+ only. Sequential, no skip patterns.
    # =========================================================================
    - id: b_cognition
      title: "Cognition and Feelings"
      precondition:
        - predicate: child_age >= 4
      items:
        # HLT-Q31: Happiness / interest in life
        - id: q_hlt_q31
          kind: Question
          title: "Would you describe the child as being usually:"
          input:
            control: Radio
            labels:
              1: "Happy and interested in life"
              2: "Somewhat happy"
              3: "Somewhat unhappy"
              4: "Unhappy with little interest in life"
              5: "So unhappy that life is not worthwhile"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q32: Memory ability
        - id: q_hlt_q32
          kind: Question
          title: "How would you describe his/her usual ability to remember things? Is he/she:"
          input:
            control: Radio
            labels:
              1: "Able to remember most things"
              2: "Somewhat forgetful"
              3: "Very forgetful"
              4: "Unable to remember anything at all"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q33: Thinking / problem solving
        - id: q_hlt_q33
          kind: Question
          title: "How would you describe his/her usual ability to think and solve day-to-day problems? Is he/she:"
          input:
            control: Radio
            labels:
              1: "Able to think clearly and solve problems"
              2: "Having a little difficulty"
              3: "Having some difficulty"
              4: "Having a great deal of difficulty"
              5: "Unable to think or solve problems"
              8: "Don't know"
              9: "Refusal"

    # =========================================================================
    # BLOCK 8: PAIN AND DISCOMFORT (HLT-Q34 to HLT-Q36)
    # =========================================================================
    # Age 4+ only.
    # Q34: Free of pain? YES->I37, NO->Q35->Q36
    # =========================================================================
    - id: b_pain
      title: "Pain and Discomfort"
      precondition:
        - predicate: child_age >= 4
      items:
        # HLT-Q34: Usually free of pain?
        # YES(1)->I37, NO(2)->Q35, DK(8)->I37, REF(9)->I37
        - id: q_hlt_q34
          kind: Question
          title: "Is the child usually free of pain or discomfort?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q35: Pain intensity
        # Reached when Q34=NO(2)
        # All answers -> Q36 except REF(9)->I37
        - id: q_hlt_q35
          kind: Question
          title: "How would you describe the usual intensity of his/her pain or discomfort:"
          precondition:
            - predicate: q_hlt_q34.outcome == 2
          input:
            control: Radio
            labels:
              1: "Mild"
              2: "Moderate"
              3: "Severe"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q36: Activities prevented by pain
        # Reached when Q35 answered (not REF)
        - id: q_hlt_q36
          kind: Question
          title: "How many activities does his/her pain or discomfort prevent?"
          precondition:
            - predicate: q_hlt_q35.outcome in [1, 2, 3, 8]
          input:
            control: Radio
            labels:
              1: "None"
              2: "A few"
              3: "Some"
              4: "Most"
              8: "Don't know"
              9: "Refusal"

    # =========================================================================
    # BLOCK 9: INJURIES (HLT-I37 to HLT-Q42)
    # =========================================================================
    # All ages. Q37 gates Q38-Q42.
    # Q39 is a checkbox for injury type, Q40 for body part (if Q39 in 1-5).
    # Q41: cause of injury, Q42: location of injury.
    # =========================================================================
    - id: b_injuries
      title: "Injuries"
      items:
        # HLT-I37: Intro about injuries
        - id: q_hlt_i37
          kind: Comment
          title: "The following questions refer to injuries, such as a broken bone, bad cut or burn, head injury, poisoning, or a sprained ankle, which occurred in the past 12 months, and were serious enough to require medical attention by a doctor, nurse, or dentist."

        # HLT-Q37: Was child injured in past 12 months?
        # YES(1)->Q38, NO(2)->Q43A, DK(8)->Q43A, REF(9)->Q43A
        - id: q_hlt_q37
          kind: Question
          title: "In the past 12 months was the child injured?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q38: How many times injured
        # Reached when Q37=YES(1)
        - id: q_hlt_q38
          kind: Question
          title: "How many times was he/she injured?"
          precondition:
            - predicate: q_hlt_q37.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 99

        # HLT-Q39: Type of most serious injury
        # Reached when Q37=YES(1)
        # Uses Checkbox for multiple injury types; REF(99)->Q43A
        - id: q_hlt_q39
          kind: Question
          title: "For the most serious injury, what type of injury did he/she have?"
          precondition:
            - predicate: q_hlt_q37.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Broken or fractured bones"
              2: "Burn or scald"
              3: "Dislocation"
              4: "Sprain or strain"
              5: "Cut, scrape, or bruise"
              6: "Concussion"
              7: "Poisoning by substance or liquid"
              8: "Internal injury"
              9: "Dental injury"
              10: "Other"
              11: "Multiple injuries"
              98: "Don't know"
              99: "Refusal"

        # HLT-Q40: Body part injured
        # C40: IF Q39 in 1-5 -> Q40, otherwise -> Q41
        # Reached when Q39 answered with codes 1-5 (bone/burn/dislocation/sprain/cut)
        - id: q_hlt_q40
          kind: Question
          title: "What part of his/her body was injured?"
          precondition:
            - predicate: q_hlt_q39.outcome >= 1 and q_hlt_q39.outcome <= 5
          input:
            control: Dropdown
            labels:
              1: "Eyes"
              2: "Face or scalp (excluding eyes)"
              3: "Head or neck (excluding eyes and face or scalp)"
              4: "Arms or hands"
              5: "Legs or feet"
              6: "Back or spine"
              7: "Trunk (excluding back or spine)"
              8: "Shoulder"
              9: "Hip"
              10: "Multiple sites"
              98: "Don't know"
              99: "Refusal"

        # HLT-Q41: Cause of injury
        # Reached when Q37=YES and Q39 not REF(99)
        - id: q_hlt_q41
          kind: Question
          title: "What happened, for example, was the injury the result of a fall, motor vehicle collision, a physical assault, etc.?"
          precondition:
            - predicate: q_hlt_q37.outcome == 1
            - predicate: q_hlt_q39.outcome != 99
          input:
            control: Dropdown
            labels:
              1: "Motor vehicle collision - passenger"
              2: "Motor vehicle collision - pedestrian"
              3: "Motor vehicle collision - riding bicycle"
              4: "Other bicycle accident"
              5: "Fall (excluding bicycle or sports)"
              6: "Sports (excluding bicycle)"
              7: "Physical assault"
              8: "Scalded by hot liquids or food"
              9: "Accidental poisoning"
              10: "Self-inflicted poisoning"
              11: "Other intentionally self-inflicted injuries"
              12: "Natural/environmental factors"
              13: "Fire/flames or resulting fumes"
              14: "Near drowning"
              15: "Other"
              98: "Don't know"
              99: "Refusal"

        # HLT-Q42: Location where injury happened
        # Reached when Q37=YES and Q39 not REF(99)
        - id: q_hlt_q42
          kind: Question
          title: "Where did the injury happen, for example at home, on the street, in a playground, at school, etc.?"
          precondition:
            - predicate: q_hlt_q37.outcome == 1
            - predicate: q_hlt_q39.outcome != 99
          input:
            control: Dropdown
            labels:
              1: "Inside respondent's own home/apartment"
              2: "Outside respondent's home including yard, driveway, parking lot"
              3: "In or around other private residence"
              4: "Inside school/daycare centre or on school/centre grounds"
              5: "At an indoor or outdoor sports facility (other than school)"
              6: "Other building used by general public"
              7: "On sidewalk/street/highway in respondent's neighbourhood"
              8: "On any other sidewalk/street/highway"
              9: "Other"
              98: "Don't know"
              99: "Refusal"

    # =========================================================================
    # BLOCK 10: ASTHMA (HLT-Q43A to HLT-Q44)
    # =========================================================================
    # All ages. Q43A gates Q43B/Q43C.
    # Q44: wheezing (asked if Q43A=NO or after Q43C)
    # =========================================================================
    - id: b_asthma
      title: "Asthma"
      items:
        # HLT-Q43A: Ever had asthma diagnosed?
        # YES(1)->Q43B, NO(2)->Q44, DK(8)->Q43B, REF(9)->C45
        - id: q_hlt_q43a
          kind: Question
          title: "The following questions are about asthma. Has the child ever had asthma that was diagnosed by a health professional?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q43B: Does asthma limit participation?
        # Reached when Q43A=YES(1) or Q43A=DK(8)
        - id: q_hlt_q43b
          kind: Question
          title: "Does this condition or health problem prevent or limit his/her participation in school, at play or any other activity normal for a child his/her age?"
          precondition:
            - predicate: q_hlt_q43a.outcome == 1 or q_hlt_q43a.outcome == 8
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q43C: Asthma attack in last 12 months?
        # Reached when Q43A=YES(1) or Q43A=DK(8)
        - id: q_hlt_q43c
          kind: Question
          title: "Has he/she had an attack of asthma in the last 12 months?"
          precondition:
            - predicate: q_hlt_q43a.outcome == 1 or q_hlt_q43a.outcome == 8
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q44: Wheezing in last 12 months?
        # Asked when Q43A=NO(2) or after Q43C (i.e., Q43A=YES/DK path completed)
        # REF on Q43A(9) skips to C45, so exclude that
        - id: q_hlt_q44
          kind: Question
          title: "Has he/she had wheezing or whistling in the chest at any time in the last 12 months?"
          precondition:
            - predicate: q_hlt_q43a.outcome != 9
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

    # =========================================================================
    # BLOCK 11: LONG-TERM CONDITIONS (HLT-Q45, Q45A, Q45B)
    # =========================================================================
    # C45: Age < 6 -> Q45, Age 6+ -> Q45A
    # Q45: conditions list (age 0-5)
    # Q45A: conditions list (age 6-11, includes learning disability etc.)
    # Q45B: conditions limiting participation (all ages)
    # =========================================================================
    - id: b_longterm
      title: "Long-term Conditions"
      items:
        # HLT-Q45: Long-term conditions (age 0-5)
        - id: q_hlt_q45
          kind: Question
          title: "In the following questions long-term conditions refer to conditions that have lasted or are expected to last 6 months or more. Does the child have any of the following long-term conditions that have been diagnosed by a health professional?"
          precondition:
            - predicate: child_age <= 5
          input:
            control: Checkbox
            labels:
              1: "Allergies"
              2: "Bronchitis"
              4: "Heart condition or disease"
              8: "Epilepsy"
              16: "Cerebral Palsy"
              32: "Kidney condition or disease"
              64: "Mental handicap"
              128: "Any other long term condition"
              256: "None"

        # HLT-Q45A: Long-term conditions (age 6-11)
        - id: q_hlt_q45a
          kind: Question
          title: "In the following questions long-term conditions refer to conditions that have lasted or are expected to last 6 months or more. Does the child have any of the following long-term conditions that have been diagnosed by a health professional?"
          precondition:
            - predicate: child_age >= 6
          input:
            control: Checkbox
            labels:
              1: "Allergies"
              2: "Bronchitis"
              4: "Heart condition or disease"
              8: "Epilepsy"
              16: "Cerebral Palsy"
              32: "Kidney condition or disease"
              64: "Mental handicap"
              128: "Learning disability"
              256: "Emotional, psychological or nervous difficulties"
              512: "Any other long term condition"
              1024: "None"

        # HLT-Q45B: Conditions limiting participation
        - id: q_hlt_q45b
          kind: Question
          title: "Does the child have any long term conditions or health problems which prevent or limit his/her participation in school, at play, or in any other activity for a child of his/her age?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

    # =========================================================================
    # BLOCK 12: INFECTIONS (HLT-Q46 to HLT-Q47B)
    # =========================================================================
    # C46: IF AGE > 3 -> skip to I48. Only age 0-3.
    # Q46: Nose/throat infections
    # Q47A: Ear infection -> Q47B (if YES)
    # =========================================================================
    - id: b_infections
      title: "Infections"
      precondition:
        - predicate: child_age <= 3
      items:
        # HLT-Q46: Nose/throat infections frequency
        - id: q_hlt_q46
          kind: Question
          title: "How often does the child have nose or throat infections?"
          input:
            control: Radio
            labels:
              1: "Almost all the time"
              2: "Often"
              3: "From time to time"
              4: "Rarely"
              5: "Never"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q47A: Ever had ear infection?
        # YES(1)->Q47B, NO(2)->I48, DK(8)->I48, REF(9)->I48
        - id: q_hlt_q47a
          kind: Question
          title: "Since his/her birth, has he/she had an ear infection (otitis)?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q47B: How many times ear infection
        # Reached when Q47A=YES(1)
        - id: q_hlt_q47b
          kind: Question
          title: "How many times?"
          precondition:
            - predicate: q_hlt_q47a.outcome == 1
          input:
            control: Radio
            labels:
              1: "Once"
              2: "2 times"
              3: "3 times"
              4: "4 or more times"
              8: "Don't know"
              9: "Refusal"

    # =========================================================================
    # BLOCK 13: HEALTH PROFESSIONALS (HLT-I48 to HLT-Q48I)
    # =========================================================================
    # All ages (age 4+ per routing: age 0-3 come here after infections block,
    # age 4+ come here after long-term conditions block).
    # QuestionGroup with Editbox for visit counts.
    # =========================================================================
    - id: b_health_professionals
      title: "Health Professionals"
      items:
        # HLT-I48: Intro
        - id: q_hlt_i48
          kind: Comment
          title: "In the past year, how many times have you seen or talked on the telephone with any of the following about the child's physical or mental health? (Exclude at time of birth for babies.)"

        # HLT-Q48A through Q48I: Health professional visit counts
        # NOTE: CATI source has REFUSAL on Q48A → GO TO HLT-Q49 (skip Q48B-I).
        # In QML, QuestionGroup presents all sub-questions together, so per-item
        # refusal routing cannot be modeled. The respondent answers all visit
        # counts or none.
        - id: qg_hlt_q48
          kind: QuestionGroup
          title: "Number of visits to health professionals in the past year:"
          questions:
            - "A general practitioner, family physician"
            - "A pediatrician"
            - "Another medical doctor (such as an orthopedist, or eye specialist)"
            - "A public health nurse or nurse practitioner"
            - "A dentist or orthodontist"
            - "A psychiatrist or psychologist"
            - "Child welfare worker or children's aid worker"
            - "Any other person trained to provide treatment or counsel (e.g., speech therapist, social worker)"
          input:
            control: Editbox
            min: 0
            max: 99

    # =========================================================================
    # BLOCK 14: HOSPITALIZATION (HLT-Q49 to HLT-Q50)
    # =========================================================================
    # All ages. Q49 gates Q50.
    # =========================================================================
    - id: b_hospitalization
      title: "Hospitalization"
      items:
        # HLT-Q49: Overnight hospital patient?
        # YES(1)->Q50, NO(2)->Q51A, DK(8)->Q51A
        - id: q_hlt_q49
          kind: Question
          title: "In the past 12 months, was the child ever an overnight patient in a hospital?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        # HLT-Q50: Reason for hospitalization
        # Reached when Q49=YES(1)
        - id: q_hlt_q50
          kind: Question
          title: "For what reason?"
          precondition:
            - predicate: q_hlt_q49.outcome == 1
          input:
            control: Radio
            labels:
              1: "Respiratory illness or disease"
              2: "Gastrointestinal illness or disease"
              3: "Injuries"
              4: "Other"
              8: "Don't know"
              9: "Refusal"

    # =========================================================================
    # BLOCK 15: MEDICATION (HLT-Q51A to HLT-Q51E)
    # =========================================================================
    # All ages. QuestionGroup with Switch for prescribed medications.
    # =========================================================================
    - id: b_medication
      title: "Medication"
      items:
        # HLT-Q51A through Q51E: Prescribed medications
        - id: qg_hlt_q51
          kind: QuestionGroup
          title: "Does the child take any of the following prescribed medication on a regular basis?"
          questions:
            - "Ventolin or other inhalants"
            - "Ritalin"
            - "Tranquilizers or nerve pills"
            - "Anti-convulsants or anti-epileptic pills"
            - "Other"
          input:
            control: Switch
            off: "No"
            on: "Yes"

    # =========================================================================
    # BLOCK 16: STRESSFUL EVENTS (HLT-Q52A to HLT-Q52B)
    # =========================================================================
    # C52: IF AGE < 4 -> next section; age 4+ only.
    # Q52A gates Q52B.
    # =========================================================================
    - id: b_stressful_events
      title: "Stressful Events"
      precondition:
        - predicate: child_age >= 4
      items:
        # HLT-Q52A: Experienced stressful event?
        # YES(1)->Q52B, NO(2)->next section
        - id: q_hlt_q52a
          kind: Question
          title: "Has the child ever experienced any event or situation that has caused him/her a great amount of worry or unhappiness?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

        # HLT-Q52B: What was the stressful event?
        # Reached when Q52A=YES(1)
        - id: q_hlt_q52b
          kind: Question
          title: "What was this?"
          precondition:
            - predicate: q_hlt_q52a.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "Death of parents"
              2: "Death in family (other than parents)"
              4: "Divorce/separation of parents"
              8: "Move"
              16: "Stay in hospital"
              32: "Stay in foster home"
              64: "Other separation from parents"
              128: "Illness/injury of child"
              256: "Illness/injury of a family member"
              512: "Abuse/fear of abuse"
              1024: "Change in household members"
              2048: "Alcoholism or mental health disorder in family"
              4096: "Conflict between parents"
              8192: "Other"

    # ===================================================================
    # SECTION: medical_biological
    # ===================================================================
    # =========================================================================
    # BLOCK 1: PRENATAL CONDITIONS AND CARE
    # =========================================================================
    # MED-C1: IF AGE > 3 → skip section
    # MED-C1A: IF biological mother → prenatal; father → birth; else → skip
    # MED-C1C: IF AGE IN MONTHS > 23 → skip to birth questions
    # Q1A-Q10B: Pregnancy complications, prenatal care, smoking, alcohol, meds
    # =========================================================================
    - id: b_prenatal
      title: "Prenatal Conditions and Care"
      precondition:
        - predicate: child_age <= 3
        - predicate: is_bio_mother == 1
        - predicate: child_age_months <= 23
      items:
        # MED-Q1A/Q1B/Q1C: Pregnancy complications
        - id: qg_med_q1
          kind: QuestionGroup
          title: "The following are prenatal questions concerning your child. During the pregnancy, did you suffer from any of the following:"
          questions:
            - "(a) Pregnancy diabetes?"
            - "(b) High blood pressure?"
            - "(c) Other physical problems?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MED-Q2: Prenatal care provider
        - id: q_med_q2
          kind: Question
          title: "From whom did you receive pre-natal care?"
          input:
            control: Radio
            labels:
              1: "A doctor"
              2: "A nurse"
              3: "A midwife"
              4: "Other"
              5: "Nobody"

        # MED-Q3: Smoking during pregnancy
        - id: q_med_q3
          kind: Question
          title: "Did you smoke during your pregnancy with this child?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MED-Q4: Cigarettes per day (only if smoked)
        - id: q_med_q4
          kind: Question
          title: "How many cigarettes per day did you smoke during your pregnancy?"
          precondition:
            - predicate: q_med_q3.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 100
            right: "cigarettes per day"

        # MED-Q5: Stage of pregnancy when smoking
        - id: q_med_q5
          kind: Question
          title: "At what stage in your pregnancy did you smoke this amount?"
          precondition:
            - predicate: q_med_q3.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "During the first three months"
              2: "During the second three months"
              4: "During the third three months"
              8: "Throughout"

        # MED-Q6: Alcohol frequency during pregnancy
        - id: q_med_q6
          kind: Question
          title: "How frequently did you consume alcohol during your pregnancy (e.g. beer, wine, liquor)?"
          input:
            control: Radio
            labels:
              1: "Never"
              2: "Less than once a month"
              3: "1-3 times a month"
              4: "Once a week"
              5: "2-3 times a week"
              6: "4-6 times a week"
              7: "Everyday"

        # MED-Q7: Drinks per occasion (only if drank)
        - id: q_med_q7
          kind: Question
          title: "On the days when you drank, how many drinks did you usually have?"
          precondition:
            - predicate: q_med_q6.outcome >= 2
          input:
            control: Radio
            labels:
              1: "1 to 2"
              2: "3 to 4"
              3: "5 or more"

        # MED-Q8: Stage of pregnancy when drinking
        - id: q_med_q8
          kind: Question
          title: "At what stage in your pregnancy did you consume this quantity?"
          precondition:
            - predicate: q_med_q6.outcome >= 2
          input:
            control: Checkbox
            labels:
              1: "During the first three months"
              2: "During the second three months"
              4: "During the third three months"
              8: "Throughout"

        # MED-Q9A: Prescription medications during pregnancy
        - id: q_med_q9a
          kind: Question
          title: "Did you take any prescription medications during your pregnancy?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MED-Q9B: Stage of pregnancy for prescription meds
        - id: q_med_q9b
          kind: Question
          title: "At what stage in your pregnancy did you take these prescription medications?"
          precondition:
            - predicate: q_med_q9a.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "During the first three months"
              2: "During the second three months"
              4: "During the third three months"
              8: "Throughout"

        # MED-Q10A: Over-the-counter drugs during pregnancy
        - id: q_med_q10a
          kind: Question
          title: "Did you take any over-the-counter drugs during your pregnancy?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MED-Q10B: Stage of pregnancy for OTC drugs
        - id: q_med_q10b
          kind: Question
          title: "At what stage in your pregnancy did you take these over-the-counter drugs?"
          precondition:
            - predicate: q_med_q10a.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "During the first three months"
              2: "During the second three months"
              4: "During the third three months"
              8: "Throughout"

    # =========================================================================
    # BLOCK 2: BIRTH DETAILS
    # =========================================================================
    # MED-Q12A through Q15: Due date, weight, length, single/multiple birth
    # All respondents (bio mother or bio father) with child age 0-3
    # =========================================================================
    - id: b_birth
      title: "Birth Details"
      precondition:
        - predicate: child_age <= 3
        - predicate: is_bio_mother == 1 or is_bio_father == 1
      items:
        # MED-Q12A: Born before or after due date
        - id: q_med_q12a
          kind: Question
          title: "The following are questions concerning your child's birth. Was he/she born before or after the due date?"
          input:
            control: Radio
            labels:
              1: "Before"
              2: "After"
              3: "On due date"

        # MED-Q12B: Days/weeks early or late (skip if on due date)
        - id: q_med_q12b
          kind: Question
          title: "How many days before or after the due date was he/she born?"
          precondition:
            - predicate: q_med_q12a.outcome == 1 or q_med_q12a.outcome == 2
          input:
            control: Editbox
            min: 1
            max: 120
            right: "days"

        # MED-Q13A: Birth weight in grams
        - id: q_med_q13a
          kind: Question
          title: "What was his/her birth weight?"
          input:
            control: Editbox
            min: 500
            max: 6000
            right: "grams"

        # MED-Q14A: Length at birth in centimetres
        - id: q_med_q14a
          kind: Question
          title: "What was his/her length at birth?"
          input:
            control: Editbox
            min: 25
            max: 65
            right: "cm"

        # MED-Q15: Single or multiple birth
        - id: q_med_q15
          kind: Question
          title: "Was this a single birth or twins, or triplets?"
          input:
            control: Radio
            labels:
              1: "Single birth"
              2: "Twins"
              3: "Triplets"
              4: "More than triplets"

    # =========================================================================
    # BLOCK 3: DELIVERY DETAILS
    # =========================================================================
    # MED-C16: IF AGE IN MONTHS >= 12 → skip to neonatal care
    # Q16-Q18: Delivery method, presentation, birthing aids
    # Only for children age 0-11 months
    # =========================================================================
    - id: b_delivery
      title: "Delivery Details"
      precondition:
        - predicate: child_age <= 3
        - predicate: is_bio_mother == 1 or is_bio_father == 1
        - predicate: child_age_months <= 11
      items:
        # MED-Q16: Delivery method
        - id: q_med_q16
          kind: Question
          title: "Was the delivery vaginal or caesarian?"
          input:
            control: Radio
            labels:
              1: "Vaginal"
              2: "Caesarian"

        # MED-Q17: Born head first (only if vaginal)
        - id: q_med_q17
          kind: Question
          title: "Was the child born head first?"
          precondition:
            - predicate: q_med_q16.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MED-Q18: Birthing aids (only if vaginal)
        - id: q_med_q18
          kind: Question
          title: "Were birthing aids used?"
          precondition:
            - predicate: q_med_q16.outcome == 1
          input:
            control: Radio
            labels:
              1: "None"
              2: "Forceps"
              3: "Cupping glass (suction cup)"

    # =========================================================================
    # BLOCK 4: NEONATAL CARE
    # =========================================================================
    # MED-Q21A through Q22: Special medical care after birth, health at birth
    # Asked for ages 0-23 months (bio mother or bio father)
    # =========================================================================
    - id: b_neonatal
      title: "Neonatal Care"
      precondition:
        - predicate: child_age <= 3
        - predicate: is_bio_mother == 1 or is_bio_father == 1
        - predicate: child_age_months <= 23
      items:
        # MED-Q21A: Special medical care after birth
        - id: q_med_q21a
          kind: Question
          title: "Did your child receive special medical care following his/her birth?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MED-Q21B: Type of special medical care (only if yes)
        - id: q_med_q21b
          kind: Question
          title: "What type of special medical care was received?"
          precondition:
            - predicate: q_med_q21a.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "Intensive care"
              2: "Ventilation/oxygen"
              4: "Transfer to a specialized hospital"
              8: "Other"

        # MED-Q21C: Duration of special care (only if received care)
        - id: q_med_q21c
          kind: Question
          title: "For how many days, in total, was this care received?"
          precondition:
            - predicate: q_med_q21a.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 365
            right: "days"

        # MED-Q22: Health at birth compared to other babies
        - id: q_med_q22
          kind: Question
          title: "Compared to other babies in general, would you say that your child's health at birth was:"
          input:
            control: Radio
            labels:
              1: "Excellent"
              2: "Very good"
              3: "Good"
              4: "Fair"
              5: "Poor"

    # =========================================================================
    # BLOCK 5: POSTNATAL COMPLICATIONS
    # =========================================================================
    # MED-C23A: IF AGE IN MONTHS >= 12 → skip to breastfeeding
    # Q23A-Q24B: Postnatal complications for the mother
    # Only for children age 0-11 months, bio mother respondent
    # =========================================================================
    - id: b_postnatal
      title: "Postnatal Complications"
      precondition:
        - predicate: child_age <= 3
        - predicate: is_bio_mother == 1
        - predicate: child_age_months <= 11
      items:
        # MED-Q23A: Postpartum haemorrhage
        - id: q_med_q23a
          kind: Question
          title: "After the delivery, did you suffer from postpartum haemorrhage?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MED-Q23B: Postpartum infection
        - id: q_med_q23b
          kind: Question
          title: "Did you suffer from postpartum infection?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MED-Q23C1: Postpartum depression
        - id: q_med_q23c1
          kind: Question
          title: "Did you suffer from postpartum depression?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MED-Q23C2: Duration of postpartum depression (only if yes)
        - id: q_med_q23c2
          kind: Question
          title: "For how long did the postpartum depression last?"
          precondition:
            - predicate: q_med_q23c1.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 365
            right: "days"

        # MED-Q23D: Postpartum hypertension
        - id: q_med_q23d
          kind: Question
          title: "Did you suffer from postpartum hypertension?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MED-Q24A: Mother hospitalized after birth
        - id: q_med_q24a
          kind: Question
          title: "Were you hospitalized for special medical care for any period immediately following the birth?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MED-Q24B: Duration of hospitalization (only if yes)
        - id: q_med_q24b
          kind: Question
          title: "For how many days were you hospitalized?"
          precondition:
            - predicate: q_med_q24a.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 365
            right: "days"

    # =========================================================================
    # BLOCK 6: BREASTFEEDING
    # =========================================================================
    # MED-Q25 through Q28: Current and past breastfeeding
    # Asked for ages 0-23 months (bio mother or bio father)
    # =========================================================================
    - id: b_breastfeeding
      title: "Breastfeeding"
      precondition:
        - predicate: child_age <= 3
        - predicate: is_bio_mother == 1 or is_bio_father == 1
        - predicate: child_age_months <= 23
      items:
        # MED-Q25: Currently breast-feeding
        - id: q_med_q25
          kind: Question
          title: "Are you currently breast-feeding your child?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MED-Q26: Ever breast-fed (only if not currently)
        - id: q_med_q26
          kind: Question
          title: "Did you breast-feed him/her even if only for a short time?"
          precondition:
            - predicate: q_med_q25.outcome == 0
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MED-Q27: Duration of breastfeeding (only if ever breast-fed)
        - id: q_med_q27
          kind: Question
          title: "For how long did you breast-feed?"
          precondition:
            - predicate: q_med_q25.outcome == 0
            - predicate: q_med_q26.outcome == 1
          input:
            control: Radio
            labels:
              1: "Less than 1 week"
              2: "1-4 weeks"
              3: "5-8 weeks"
              4: "9-12 weeks"
              5: "3-6 months"
              6: "7-9 months"
              7: "10-12 months"
              8: "13-16 months"
              9: "More than 16 months"

        # MED-Q28: Reason for stopping breastfeeding
        - id: q_med_q28
          kind: Question
          title: "What was the main reason you stopped breast-feeding?"
          precondition:
            - predicate: q_med_q25.outcome == 0
            - predicate: q_med_q26.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "Not enough milk/hungry baby"
              2: "Inconvenienced/fatigue"
              4: "Difficulty with breastfeeding techniques"
              8: "Sore nipples/engorged breast"
              16: "Mother's illness"
              32: "Planned to stop at this time"
              64: "Baby weaned himself/herself"
              128: "Physician told me to stop"
              256: "Returned to work/school"
              512: "Partner/father wanted me to stop"
              1024: "Formula feeding preferable"
              2048: "Wanted to drink alcohol"
              4096: "Other"

    # ===================================================================
    # SECTION: temperament
    # ===================================================================
    # =========================================================================
    # BLOCK 1: TEMPERAMENT INTRODUCTION
    # =========================================================================
    # TMP-C1 gate: only children aged 3-47 months
    # TMP-I1 introduction text, TMP-Q1 general soothing difficulty
    # =========================================================================
    - id: b_tmp_intro
      title: "Temperament"
      precondition:
        - predicate: child_age_months >= 3
        - predicate: child_age_months <= 47
      items:
        # TMP-I1: Introduction
        - id: q_tmp_i1
          kind: Comment
          title: "The following questions are about how your child behaves. Please answer them in comparison to others. 'About average' means how you think the typical child would be scored."

        # TMP-Q1: Soothing difficulty
        - id: q_tmp_q1
          kind: Question
          title: "How easy or difficult is it for you to calm or soothe your child when he/she is upset?"
          input:
            control: Slider
            min: 1
            max: 7
            left: "Very easy"
            right: "Difficult"

    # =========================================================================
    # BLOCK 2: PREDICTABILITY AND ROUTINES
    # =========================================================================
    # Q2/Q2A (sleep), Q3/Q3A (eating) - age-variant pairs at 12 months
    # =========================================================================
    - id: b_tmp_predictability
      title: "Predictability and Routines"
      precondition:
        - predicate: child_age_months >= 3
        - predicate: child_age_months <= 47
      items:
        # TMP-Q2: Sleep predictability (age < 12 months)
        - id: q_tmp_q2
          kind: Question
          title: "How easy or difficult is it for you to predict when he/she will go to sleep and wake up?"
          precondition:
            - predicate: child_age_months < 12
          input:
            control: Slider
            min: 1
            max: 7
            left: "Very easy"
            right: "Difficult"

        # TMP-Q2A: Sleep routine consistency (age >= 12 months)
        - id: q_tmp_q2a
          kind: Question
          title: "How consistent is he/she in sticking with his/her sleeping routine?"
          precondition:
            - predicate: child_age_months >= 12
          input:
            control: Slider
            min: 1
            max: 7
            left: "Very consistent; little or no variability"
            right: "Very inconsistent; highly variable"

        # TMP-Q3: Eating predictability (age < 12 months)
        - id: q_tmp_q3
          kind: Question
          title: "How easy or difficult is it for you to predict when he/she will become hungry?"
          precondition:
            - predicate: child_age_months < 12
          input:
            control: Slider
            min: 1
            max: 7
            left: "Very easy"
            right: "Difficult"

        # TMP-Q3A: Eating routine consistency (age >= 12 months)
        - id: q_tmp_q3a
          kind: Question
          title: "How consistent is he/she in sticking with his/her eating routine?"
          precondition:
            - predicate: child_age_months >= 12
          input:
            control: Slider
            min: 1
            max: 7
            left: "Very consistent; little or no variability"
            right: "Very inconsistent; highly variable"

    # =========================================================================
    # BLOCK 3: FUSSINESS AND CRYING
    # =========================================================================
    # Q4/Q4A (knowing what's wrong), Q5/Q5A (fussiness frequency),
    # Q6/Q6A (crying amount), Q7 (upset ease), Q8/Q8A/Q8B (upset intensity)
    # Age splits: Q4/Q5/Q6 at 36 months, Q8 three-way at 12/36 months
    # =========================================================================
    - id: b_tmp_fussiness
      title: "Fussiness and Crying"
      precondition:
        - predicate: child_age_months >= 3
        - predicate: child_age_months <= 47
      items:
        # TMP-Q4: Knowing what's bothering (age < 36 months)
        - id: q_tmp_q4
          kind: Question
          title: "How easy or difficult is it for you to know what's bothering him/her when he/she cries or fusses?"
          precondition:
            - predicate: child_age_months < 36
          input:
            control: Slider
            min: 1
            max: 7
            left: "Very easy"
            right: "Very difficult"

        # TMP-Q4A: Knowing what's bothering (age >= 36 months)
        - id: q_tmp_q4a
          kind: Question
          title: "How easy or difficult is it for you to know what's bothering him/her when he/she is irritable?"
          precondition:
            - predicate: child_age_months >= 36
          input:
            control: Slider
            min: 1
            max: 7
            left: "Very easy"
            right: "Very difficult"

        # TMP-Q5: Fussiness frequency (age < 36 months)
        - id: q_tmp_q5
          kind: Question
          title: "How many times per day, on average, does your child get fussy and irritable - for either short or long periods of time?"
          precondition:
            - predicate: child_age_months < 36
          input:
            control: Dropdown
            labels:
              1: "Never"
              2: "1-2 times per day"
              3: "3-4 times per day"
              4: "5-6 times per day"
              5: "7-9 times per day"
              6: "10-14 times per day"
              7: "15 times per day or more"

        # TMP-Q5A: Crankiness frequency (age >= 36 months)
        - id: q_tmp_q5a
          kind: Question
          title: "How many times per day on average does your child get cranky and irritable - for either short or long periods of time?"
          precondition:
            - predicate: child_age_months >= 36
          input:
            control: Dropdown
            labels:
              1: "Never"
              2: "1-2 times per day"
              3: "3-4 times per day"
              4: "5-6 times per day"
              5: "7-9 times per day"
              6: "10-14 times per day"
              7: "15 times per day or more"

        # TMP-Q6: Crying amount (age < 36 months)
        - id: q_tmp_q6
          kind: Question
          title: "How much does he/she cry and fuss in general?"
          precondition:
            - predicate: child_age_months < 36
          input:
            control: Slider
            min: 1
            max: 7
            left: "Very little; much less than the average baby/child"
            right: "A lot; much more than the average baby/child"

        # TMP-Q6A: Crying/fussing/whining amount (age >= 36 months)
        - id: q_tmp_q6a
          kind: Question
          title: "How much does he/she cry, fuss or whine in general?"
          precondition:
            - predicate: child_age_months >= 36
          input:
            control: Slider
            min: 1
            max: 7
            left: "Very little; much less than the average child"
            right: "A lot; much more than the average child"

        # TMP-Q7: How easily upset (all ages)
        - id: q_tmp_q7
          kind: Question
          title: "How easily does he/she get upset?"
          input:
            control: Slider
            min: 1
            max: 7
            left: "Very hard to upset"
            right: "Very easily upset by things that wouldn't bother most babies/children"

        # TMP-Q8: Upset intensity (age < 12 months)
        - id: q_tmp_q8
          kind: Question
          title: "When he/she gets upset (e.g., before feeding, during diapering, etc.), how vigorously or loudly does he/she cry and fuss?"
          precondition:
            - predicate: child_age_months < 12
          input:
            control: Slider
            min: 1
            max: 7
            left: "Very mild intensity or loudness"
            right: "Very loud or intense, really cuts loose"

        # TMP-Q8A: Upset intensity (age 12-35 months)
        - id: q_tmp_q8a
          kind: Question
          title: "When he/she gets upset, how vigorously or loudly does he/she cry and fuss?"
          precondition:
            - predicate: child_age_months >= 12
            - predicate: child_age_months <= 35
          input:
            control: Slider
            min: 1
            max: 7
            left: "Very mild intensity or loudness"
            right: "Very loud or intense, really cuts loose"

        # TMP-Q8B: Upset intensity (age >= 36 months)
        - id: q_tmp_q8b
          kind: Question
          title: "When he/she gets upset, how vigorously or loudly does he/she cry and whine?"
          precondition:
            - predicate: child_age_months >= 36
          input:
            control: Slider
            min: 1
            max: 7
            left: "Very mild intensity or loudness"
            right: "Very loud or intense, really cuts loose"

    # =========================================================================
    # BLOCK 4: DAILY CARE REACTIONS
    # =========================================================================
    # Q9/Q9A (dressing/hairwashing), Q10 (activity level)
    # Age split at 12 months for Q9
    # =========================================================================
    - id: b_tmp_daily_care
      title: "Daily Care Reactions"
      precondition:
        - predicate: child_age_months >= 3
        - predicate: child_age_months <= 47
      items:
        # TMP-Q9: Reaction to dressing (age < 12 months)
        - id: q_tmp_q9
          kind: Question
          title: "How does he/she react when you are dressing him/her?"
          precondition:
            - predicate: child_age_months < 12
          input:
            control: Slider
            min: 1
            max: 7
            left: "Very well -- likes it"
            right: "Doesn't like it at all"

        # TMP-Q9A: Reaction to hairwashing (age >= 12 months)
        - id: q_tmp_q9a
          kind: Question
          title: "How does he/she react during hairwashing?"
          precondition:
            - predicate: child_age_months >= 12
          input:
            control: Slider
            min: 1
            max: 7
            left: "Very well -- likes it"
            right: "Doesn't like it at all"

        # TMP-Q10: Activity level (all ages)
        - id: q_tmp_q10
          kind: Question
          title: "How active is your child in general?"
          input:
            control: Slider
            min: 1
            max: 7
            left: "Very calm and quiet"
            right: "Very active and vigorous"

    # =========================================================================
    # BLOCK 5: MOOD AND SOCIABILITY
    # =========================================================================
    # Q11/Q11A (smiling), Q12 (mood), Q13/Q13A (playing enjoyment),
    # Q14/Q14A (wanting to be held/cuddled), Q15 (routine disruptions)
    # =========================================================================
    - id: b_tmp_mood
      title: "Mood and Sociability"
      precondition:
        - predicate: child_age_months >= 3
        - predicate: child_age_months <= 47
      items:
        # TMP-Q11: Smiling and happy sounds (age < 36 months)
        - id: q_tmp_q11
          kind: Question
          title: "How much does he/she smile and make happy sounds?"
          precondition:
            - predicate: child_age_months < 36
          input:
            control: Slider
            min: 1
            max: 7
            left: "A great deal, much more than most infants/children"
            right: "Very little, much less than most infants/children"

        # TMP-Q11A: Smiling and laughing (age >= 36 months)
        - id: q_tmp_q11a
          kind: Question
          title: "How much does he/she smile and laugh?"
          precondition:
            - predicate: child_age_months >= 36
          input:
            control: Slider
            min: 1
            max: 7
            left: "A great deal, much more than most children"
            right: "Very little, much less than most children"

        # TMP-Q12: General mood (all ages)
        - id: q_tmp_q12
          kind: Question
          title: "What kind of mood is he/she generally in?"
          input:
            control: Slider
            min: 1
            max: 7
            left: "Very happy and cheerful"
            right: "Serious"

        # TMP-Q13: Playing games enjoyment (age 6-11 months only)
        - id: q_tmp_q13
          kind: Question
          title: "How much does he/she enjoy playing little games with you?"
          precondition:
            - predicate: child_age_months >= 6
            - predicate: child_age_months <= 11
          input:
            control: Slider
            min: 1
            max: 7
            left: "A great deal -- really loves it"
            right: "Very little -- doesn't like it very much"

        # TMP-Q13A: Playing enjoyment (age >= 12 months)
        - id: q_tmp_q13a
          kind: Question
          title: "How much does he/she enjoy playing with you?"
          precondition:
            - predicate: child_age_months >= 12
          input:
            control: Slider
            min: 1
            max: 7
            left: "A great deal -- really loves it"
            right: "Very little -- doesn't like it very much"

        # TMP-Q14: Wanting to be held (age < 36 months)
        - id: q_tmp_q14
          kind: Question
          title: "How much does he/she want to be held?"
          precondition:
            - predicate: child_age_months < 36
          input:
            control: Slider
            min: 1
            max: 7
            left: "Wants to be free most of the time"
            right: "A great deal -- wants to be held almost all the time"

        # TMP-Q14A: Wanting to be cuddled (age >= 36 months)
        - id: q_tmp_q14a
          kind: Question
          title: "How much does he/she want to be cuddled?"
          precondition:
            - predicate: child_age_months >= 36
          input:
            control: Slider
            min: 1
            max: 7
            left: "Wants to be free most of the time"
            right: "A great deal -- wants to be cuddled almost all the time"

        # TMP-Q15: Response to routine disruptions (all ages)
        - id: q_tmp_q15
          kind: Question
          title: "How does he/she respond to disruptions and changes in everyday routine, such as when you go to church, a meeting, on trips, etc.?"
          input:
            control: Slider
            min: 1
            max: 7
            left: "Very favourably, doesn't get upset"
            right: "Very unfavourably, gets quite upset"

    # =========================================================================
    # BLOCK 6: PREDICTABILITY AND MOOD CHANGE
    # =========================================================================
    # Q16 (diaper prediction, age < 12m only), Q17 (mood changeability, age >= 12m),
    # Q18 (excitement with people), Q19/Q19A (attention needs),
    # Q20 (playing alone)
    # =========================================================================
    - id: b_tmp_predict_mood
      title: "Predictability and Mood Changes"
      precondition:
        - predicate: child_age_months >= 3
        - predicate: child_age_months <= 47
      items:
        # TMP-Q16: Diaper prediction (age 3-11 months only)
        - id: q_tmp_q16
          kind: Question
          title: "How easy is it for you to predict when he/she will need a diaper change?"
          precondition:
            - predicate: child_age_months < 12
          input:
            control: Slider
            min: 1
            max: 7
            left: "Very easy"
            right: "Very difficult"

        # TMP-Q17: Mood changeability (age >= 12 months)
        - id: q_tmp_q17
          kind: Question
          title: "How changeable is your child's mood?"
          precondition:
            - predicate: child_age_months >= 12
          input:
            control: Slider
            min: 1
            max: 7
            left: "Changes seldom and changes slowly when he/she does change"
            right: "Changes often and rapidly"

        # TMP-Q18: Excitement with people (all ages)
        - id: q_tmp_q18
          kind: Question
          title: "How excited does he/she become when people play with or talk to him/her?"
          input:
            control: Slider
            min: 1
            max: 7
            left: "Very excited"
            right: "Not at all"

        # TMP-Q19: Attention needs (age < 36 months)
        - id: q_tmp_q19
          kind: Question
          title: "On the average, how much attention does he/she require, other than for caregiving (feeding, bathing, diaper changes, etc.)?"
          precondition:
            - predicate: child_age_months < 36
          input:
            control: Slider
            min: 1
            max: 7
            left: "Very little -- much less than the average baby/child"
            right: "A lot -- much more than the average baby/child"

        # TMP-Q19A: Attention needs (age >= 36 months)
        - id: q_tmp_q19a
          kind: Question
          title: "On the average, how much attention does he/she require, other than for caregiving (bathing, eating, etc.)?"
          precondition:
            - predicate: child_age_months >= 36
          input:
            control: Slider
            min: 1
            max: 7
            left: "Very little -- much less than the average child"
            right: "A lot -- much more than the average child"

        # TMP-Q20: Playing alone (all ages)
        - id: q_tmp_q20
          kind: Question
          title: "When left alone, he/she plays well by him/herself?"
          input:
            control: Slider
            min: 1
            max: 7
            left: "Almost always"
            right: "Almost never -- won't play by self"

    # =========================================================================
    # BLOCK 7: CONFINEMENT AND CUDDLING
    # =========================================================================
    # Q21/Q21A/Q21B (confinement reaction, three-way age split),
    # Q22/Q22A (cuddling)
    # Age 3-11m skip Q21 entirely; Q21 12-23m, Q21A 24-35m, Q21B 36-47m
    # =========================================================================
    - id: b_tmp_confinement
      title: "Confinement and Cuddling"
      precondition:
        - predicate: child_age_months >= 3
        - predicate: child_age_months <= 47
      items:
        # TMP-Q21: Confinement reaction (age 12-23 months)
        - id: q_tmp_q21
          kind: Question
          title: "How does he/she react to being confined (as in a carseat, infant seat, playpen, etc.)?"
          precondition:
            - predicate: child_age_months >= 12
            - predicate: child_age_months <= 23
          input:
            control: Slider
            min: 1
            max: 7
            left: "Very well -- likes it"
            right: "Doesn't like it at all"

        # TMP-Q21A: Confinement reaction (age 24-35 months)
        - id: q_tmp_q21a
          kind: Question
          title: "How does he/she react to being confined (as in a carseat, bedroom, crib, etc.)?"
          precondition:
            - predicate: child_age_months >= 24
            - predicate: child_age_months <= 35
          input:
            control: Slider
            min: 1
            max: 7
            left: "Very well -- likes it"
            right: "Doesn't like it at all"

        # TMP-Q21B: Confinement reaction (age 36-47 months)
        - id: q_tmp_q21b
          kind: Question
          title: "How does he/she react to being confined (as in a boosterseat, seatbelt, bedroom, bed, etc.)?"
          precondition:
            - predicate: child_age_months >= 36
          input:
            control: Slider
            min: 1
            max: 7
            left: "Very well -- likes it"
            right: "Doesn't like it at all"

        # TMP-Q22: Cuddling when held (age < 12 months)
        - id: q_tmp_q22
          kind: Question
          title: "How much does he/she cuddle and snuggle when held?"
          precondition:
            - predicate: child_age_months < 12
          input:
            control: Slider
            min: 1
            max: 7
            left: "A great deal -- almost every time"
            right: "Very little -- seldom cuddles"

        # TMP-Q22A: Cuddling when close (age >= 12 months)
        - id: q_tmp_q22a
          kind: Question
          title: "How much does he/she cuddle and snuggle when close to you?"
          precondition:
            - predicate: child_age_months >= 12
          input:
            control: Slider
            min: 1
            max: 7
            left: "A great deal -- almost every time"
            right: "Very little -- seldom cuddles"

    # =========================================================================
    # BLOCK 8: NOVELTY RESPONSES
    # =========================================================================
    # Q23 (first bath, age 3-11m only), Q23A (new playthings, age >= 12m),
    # Q24 (first solid food, age 6-11m), Q24A (new foods, age >= 12m),
    # Q25 (new person), Q26 (new place), Q27/Q27A (adaptation)
    # Note: age 3-5m skip from Q23 directly to Q33 in original;
    # here we handle via preconditions on Q24 (requires 6-11m).
    # =========================================================================
    - id: b_tmp_novelty
      title: "Novelty Responses"
      precondition:
        - predicate: child_age_months >= 3
        - predicate: child_age_months <= 47
      items:
        # TMP-Q23: First bath response (age 3-11 months)
        - id: q_tmp_q23
          kind: Question
          title: "How did he/she respond to his/her first bath?"
          precondition:
            - predicate: child_age_months < 12
          input:
            control: Slider
            min: 1
            max: 7
            left: "Very well -- baby loved it"
            right: "Terribly -- didn't like it"

        # TMP-Q23A: New playthings response (age >= 12 months)
        - id: q_tmp_q23a
          kind: Question
          title: "How does he/she typically respond to new playthings?"
          precondition:
            - predicate: child_age_months >= 12
          input:
            control: Slider
            min: 1
            max: 7
            left: "Always responds favourably"
            right: "Always responds negatively or fearfully"

        # TMP-Q24: First solid food response (age 6-11 months)
        - id: q_tmp_q24
          kind: Question
          title: "How did he/she respond to his/her first solid food?"
          precondition:
            - predicate: child_age_months >= 6
            - predicate: child_age_months <= 11
          input:
            control: Slider
            min: 1
            max: 7
            left: "Very favourably -- liked it immediately"
            right: "Very negatively -- did not like it at all"

        # TMP-Q24A: New food response (age >= 12 months)
        - id: q_tmp_q24a
          kind: Question
          title: "How does he/she typically respond to new foods?"
          precondition:
            - predicate: child_age_months >= 12
          input:
            control: Slider
            min: 1
            max: 7
            left: "Always responds favourably"
            right: "Very negatively -- does not like it at all"

        # TMP-Q25: New person response (all ages)
        - id: q_tmp_q25
          kind: Question
          title: "How does he/she typically respond to a new person?"
          input:
            control: Slider
            min: 1
            max: 7
            left: "Almost always responds favourably"
            right: "Almost always responds negatively at first"

        # TMP-Q26: New place response (all ages)
        - id: q_tmp_q26
          kind: Question
          title: "How does he/she typically respond to being in a new place?"
          input:
            control: Slider
            min: 1
            max: 7
            left: "Almost always responds favourably"
            right: "Almost always responds negatively at first"

        # TMP-Q27: Adaptation (age < 12 months)
        - id: q_tmp_q27
          kind: Question
          title: "How well does he/she adapt to things (such as baths, new people and new places) eventually?"
          precondition:
            - predicate: child_age_months < 12
          input:
            control: Slider
            min: 1
            max: 7
            left: "Very well -- always likes it eventually"
            right: "Almost always dislikes it in the end"

        # TMP-Q27A: Adaptation to new experiences (age >= 12 months)
        - id: q_tmp_q27a
          kind: Question
          title: "How well does he/she adapt to new experiences (such as new playthings, new foods, new persons, etc.) eventually?"
          precondition:
            - predicate: child_age_months >= 12
          input:
            control: Slider
            min: 1
            max: 7
            left: "Very well -- always likes it eventually"
            right: "Almost always dislikes it in the end"

    # =========================================================================
    # BLOCK 9: PERSISTENCE AND COMPLIANCE
    # =========================================================================
    # Q28 (taking places, age >= 12m), Q29 (object persistence, age >= 12m),
    # Q30/Q30A (disobedience persistence), Q31 (removal upset, age >= 12m),
    # Q32 (attention persistence, age >= 12m)
    # =========================================================================
    - id: b_tmp_persistence
      title: "Persistence and Compliance"
      precondition:
        - predicate: child_age_months >= 12
        - predicate: child_age_months <= 47
      items:
        # TMP-Q28: Ease of taking places (age >= 12 months)
        - id: q_tmp_q28
          kind: Question
          title: "How easy or difficult is it to take him/her places?"
          input:
            control: Slider
            min: 1
            max: 7
            left: "Easy; fun to take baby/child with me"
            right: "Difficult; baby/child is usually disruptive"

        # TMP-Q29: Object persistence (age >= 12 months)
        - id: q_tmp_q29
          kind: Question
          title: "Does he/she persist in playing with objects when he/she is told to leave them alone?"
          input:
            control: Slider
            min: 1
            max: 7
            left: "Rarely or never persists"
            right: "Almost always persists"

        # TMP-Q30: Disobedience persistence (age 12-35 months)
        - id: q_tmp_q30
          kind: Question
          title: "Does he/she continue to go someplace even when you told him/her something like 'stop', 'come here', or 'no-no'?"
          precondition:
            - predicate: child_age_months < 36
          input:
            control: Slider
            min: 1
            max: 7
            left: "Rarely or never"
            right: "Almost always"

        # TMP-Q30A: Disobedience persistence (age >= 36 months)
        - id: q_tmp_q30a
          kind: Question
          title: "Does he/she continue to go someplace even when you told him/her something like 'stop', 'come here', or 'please don't'?"
          precondition:
            - predicate: child_age_months >= 36
          input:
            control: Slider
            min: 1
            max: 7
            left: "Rarely or never"
            right: "Almost always"

        # TMP-Q31: Upset when removed from interest (age >= 12 months)
        - id: q_tmp_q31
          kind: Question
          title: "When removed from something he/she is interested in but should not be getting into, he/she gets upset."
          input:
            control: Slider
            min: 1
            max: 7
            left: "Never"
            right: "Always gets very upset"

        # TMP-Q32: Persistence in getting attention (age >= 12 months)
        - id: q_tmp_q32
          kind: Question
          title: "How persistent is he/she in trying to get your attention when you are busy?"
          input:
            control: Slider
            min: 1
            max: 7
            left: "Doesn't persist at all"
            right: "Very persistent -- will do anything to get attention"

    # =========================================================================
    # BLOCK 10: OVERALL DIFFICULTY RATING
    # =========================================================================
    # Q33: Overall difficulty rating (all ages 3-47 months)
    # =========================================================================
    - id: b_tmp_overall
      title: "Overall Difficulty"
      precondition:
        - predicate: child_age_months >= 3
        - predicate: child_age_months <= 47
      items:
        # TMP-Q33: Overall difficulty rating
        - id: q_tmp_q33
          kind: Question
          title: "Please rate the overall degree of difficulty your child would present for the average parent."
          input:
            control: Slider
            min: 1
            max: 7
            left: "Very easy"
            right: "Highly difficult to deal with"

    # ===================================================================
    # SECTION: education_child
    # ===================================================================
    # =========================================================================
    # BLOCK 1: SCHOOL GRADE AND ATTENDANCE
    # =========================================================================
    # EDU-C1: IF AGE < 4 -> skip entire section (to Literacy)
    # EDU-Q1/Q1A-Q1E: Province-specific grade question — modeled as ONE
    #   generic Dropdown covering all province grade labels.
    # EDU-Q2: Junior kindergarten attendance
    # EDU-Q3: Kindergarten attendance (if not currently in kindergarten)
    # =========================================================================
    - id: b_edu_grade
      title: "School Grade and Attendance"
      precondition:
        - predicate: child_age >= 4
      items:
        # EDU-I1: Introduction
        - id: q_edu_intro
          kind: Comment
          title: "The next section is about the child's experiences at school."

        # EDU-Q1 (unified): What school grade is the child in?
        # Consolidates Q1, Q1A-Q1E (6 province variants) into one generic
        # Dropdown. All provinces map to the same ordinal grade structure;
        # province-specific labels (e.g. "Grade 7 Elementary", "Secondary I")
        # are minor naming differences, not distinct data.
        - id: q_edu_q1
          kind: Question
          title: "What school grade is the child in?"
          input:
            control: Dropdown
            labels:
              1: "Not in school"
              2: "Junior Kindergarten"
              3: "Kindergarten / Primary"
              4: "Grade 1"
              5: "Grade 2"
              6: "Grade 3"
              7: "Grade 4"
              8: "Grade 5"
              9: "Grade 6"
              10: "Grade 7"
              11: "Grade 8"
              12: "Grade 9"
              13: "Grade 10"
              14: "Grade 11"
              15: "Grade 12"
              16: "OAC / Grade 13"
              17: "Ungraded"
          codeBlock: |
            if q_edu_q1.outcome == 1:
                in_school = 0
                school_grade = 0
            else:
                in_school = 1
                school_grade = q_edu_q1.outcome
            if q_edu_q1.outcome == 17:
                school_grade = 17

        # EDU-Q2: Junior kindergarten attendance
        # Shown only if child is in school and NOT "Not in school"
        - id: q_edu_q2
          kind: Question
          title: "Did the child attend junior kindergarten?"
          precondition:
            - predicate: in_school == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # EDU-Q3: Kindergarten attendance
        # Skip if currently in kindergarten/primary (grade 3) or junior kindergarten (grade 2)
        - id: q_edu_q3
          kind: Question
          title: "Did the child attend kindergarten or primary?"
          precondition:
            - predicate: in_school == 1
            - predicate: q_edu_q1.outcome != 2
            - predicate: q_edu_q1.outcome != 3
            - predicate: q_edu_q1.outcome != 17
          input:
            control: Switch
            off: "No"
            on: "Yes"

    # =========================================================================
    # BLOCK 2: GRADE SKIPPING AND REPEATING
    # =========================================================================
    # EDU-Q4: Ever skipped a grade -> if YES -> Q5 (which grade)
    # EDU-Q6: Ever repeated a grade -> if YES -> Q7 (which grade)
    # Q5 and Q7 use unified grade Dropdowns (consolidating province variants).
    # =========================================================================
    - id: b_edu_skip_repeat
      title: "Grade Skipping and Repeating"
      precondition:
        - predicate: child_age >= 4
        - predicate: in_school == 1
        - predicate: q_edu_q1.outcome != 17
      items:
        # EDU-Q4: Ever skipped a grade
        - id: q_edu_q4
          kind: Question
          title: "Has the child ever skipped a grade at school? (Include kindergarten)"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # EDU-Q5 (unified): Which grade was skipped
        # Consolidates Q5, Q5A-Q5E into one generic Dropdown
        - id: q_edu_q5
          kind: Question
          title: "What grade has the child skipped? (If more than one, mark the most recent.)"
          precondition:
            - predicate: q_edu_q4.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Kindergarten"
              2: "Grade 1"
              3: "Grade 2"
              4: "Grade 3"
              5: "Grade 4"
              6: "Grade 5"
              7: "Grade 6"
              8: "Grade 7"
              9: "Grade 8"
              10: "Grade 9"
              11: "Grade 10"
              12: "Grade 11"
              13: "Grade 12"
              14: "OAC / Grade 13"

        # EDU-Q6: Ever repeated a grade
        - id: q_edu_q6
          kind: Question
          title: "Has the child ever repeated a grade at school? (Include kindergarten)"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # EDU-Q7 (unified): Which grade was repeated
        # Consolidates Q7, Q7A-Q7E into one generic Dropdown
        - id: q_edu_q7
          kind: Question
          title: "What grade has the child repeated? (If more than one, mark the most recent.)"
          precondition:
            - predicate: q_edu_q6.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Kindergarten"
              2: "Grade 1"
              3: "Grade 2"
              4: "Grade 3"
              5: "Grade 4"
              6: "Grade 5"
              7: "Grade 6"
              8: "Grade 7"
              9: "Grade 8"
              10: "Grade 9"
              11: "Grade 10"
              12: "Grade 11"
              13: "Grade 12"
              14: "OAC / Grade 13"

    # =========================================================================
    # BLOCK 3: SCHOOL TYPE AND CHANGES
    # =========================================================================
    # EDU-Q8: School type (public, catholic, private, other)
    # EDU-Q9A: Ever changed schools (non-natural progression)
    # EDU-Q9B: How many times changed (if yes)
    # EDU-Q10: Reason for most recent change (if yes)
    # EDU-Q11: Number of residential moves
    # =========================================================================
    - id: b_edu_school_type
      title: "School Type and Changes"
      precondition:
        - predicate: child_age >= 4
        - predicate: in_school == 1
      items:
        # EDU-Q8: School type
        # Shown to all in-school children (including ungraded)
        - id: q_edu_q8
          kind: Question
          title: "What type of school is the child currently in?"
          input:
            control: Radio
            labels:
              1: "Public school"
              2: "Catholic school, publicly funded"
              3: "Private school"
              4: "Other"

        # EDU-Q9A: Ever changed schools
        - id: q_edu_q9a
          kind: Question
          title: "Other than natural progression through the school system in your area, has the child ever changed schools?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Not applicable"

        # EDU-Q9B: Number of school changes
        - id: q_edu_q9b
          kind: Question
          title: "How many times has the child changed schools?"
          precondition:
            - predicate: q_edu_q9a.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 20
            right: "times"

        # EDU-Q10: Reason for most recent school change
        - id: q_edu_q10
          kind: Question
          title: "For the most recent change in schools, what was the reason for changing?"
          precondition:
            - predicate: q_edu_q9a.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Family or child moved"
              2: "Child not progressing well academically"
              3: "Child not progressing well in language of instruction"
              4: "Child not getting along well with others at school"
              5: "Concerns about school's academic standards or quality"
              6: "Concerns about school safety or discipline"
              7: "Concerns about school facilities or resources"
              8: "Other"

        # EDU-Q11: Number of residential moves
        - id: q_edu_q11
          kind: Question
          title: "Aside from school changes, how many times in the child's life has he/she moved, that is, changed his/her usual place of residence?"
          input:
            control: Editbox
            min: 0
            max: 50
            right: "times"

    # =========================================================================
    # BLOCK 4: LANGUAGE AND ABSENCES
    # =========================================================================
    # EDU-Q12A: Language of instruction
    # EDU-Q12B: Language at home (age 4-5 only)
    # EDU-Q13: Days absent since school started
    # =========================================================================
    - id: b_edu_language
      title: "Language and Absences"
      precondition:
        - predicate: child_age >= 4
        - predicate: in_school == 1
      items:
        # EDU-Q12A: Language of instruction
        - id: q_edu_q12a
          kind: Question
          title: "In what language is the child mainly taught?"
          input:
            control: Radio
            labels:
              1: "English"
              2: "French"
              3: "Both English and French"
              4: "Other"

        # EDU-Q12B: Language spoken at home
        # EDU-C12B: Only for age 4-5 (IF AGE > 5 -> skip to Q13)
        - id: q_edu_q12b
          kind: Question
          title: "What language does the child speak most often at home? (Mark all that apply.)"
          precondition:
            - predicate: child_age <= 5
          input:
            control: Checkbox
            labels:
              1: "English"
              2: "French"
              4: "Other"

        # EDU-Q13: Days absent from school
        - id: q_edu_q13
          kind: Question
          title: "Since the child started school in the fall, about how many days has he/she been away from school for any reason?"
          input:
            control: Editbox
            min: 0
            max: 200
            right: "days"

    # =========================================================================
    # BLOCK 5: ACADEMIC PERFORMANCE
    # =========================================================================
    # EDU-C14A: Skip if in kindergarten/primary/junior kindergarten/ungraded
    # Shown only for children in grade 1 or higher (school_grade >= 4 means
    # grade 1+, since 2=JK, 3=K/Primary, 17=ungraded are excluded).
    # EDU-Q14A-D: Performance in reading, math, writing, overall
    # =========================================================================
    - id: b_edu_performance
      title: "Academic Performance"
      precondition:
        - predicate: child_age >= 4
        - predicate: in_school == 1
        - predicate: school_grade >= 4
        - predicate: school_grade <= 16
      items:
        # EDU-Q14A-D: Academic performance ratings
        - id: qg_edu_q14
          kind: QuestionGroup
          title: "Based on your knowledge of the child's school work, including report cards, how is the child doing in the following areas at school this year?"
          questions:
            - "Reading"
            - "Mathematics"
            - "Written work such as composition"
            - "Overall"
          input:
            control: Radio
            labels:
              1: "Very well"
              2: "Well"
              3: "Average"
              4: "Poorly"
              5: "Very poorly"

    # =========================================================================
    # BLOCK 6: TUTORING
    # =========================================================================
    # EDU-Q15A: Received tutoring outside school?
    # EDU-Q15B: How often? (only if YES)
    # =========================================================================
    - id: b_edu_tutoring
      title: "Tutoring"
      precondition:
        - predicate: child_age >= 4
        - predicate: in_school == 1
      items:
        # EDU-Q15A: Received tutoring
        - id: q_edu_q15a
          kind: Question
          title: "Since the child started school in the fall, has he/she received any help or tutoring outside of school?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # EDU-Q15B: Tutoring frequency
        - id: q_edu_q15b
          kind: Question
          title: "How often does the child receive tutoring?"
          precondition:
            - predicate: q_edu_q15a.outcome == 1
          input:
            control: Radio
            labels:
              1: "Once a week or less often"
              2: "Twice a week"
              3: "More than twice a week"

    # =========================================================================
    # BLOCK 7: SCHOOL ATTITUDES AND EXPECTATIONS
    # =========================================================================
    # EDU-Q16: School contact about behaviour
    # EDU-Q17: Looks forward to school
    # EDU-C18: IF AGE < 8 -> Q18B; OTHERWISE -> Q18A
    # EDU-Q18A: Importance of good grades (age 8+)
    # EDU-Q18B: Educational hopes (all ages)
    # =========================================================================
    - id: b_edu_attitudes
      title: "School Attitudes and Expectations"
      precondition:
        - predicate: child_age >= 4
        - predicate: in_school == 1
      items:
        # EDU-Q16: School contact about behaviour
        - id: q_edu_q16
          kind: Question
          title: "Since the child started school in the fall, how many times have you been contacted by his/her school regarding his/her behaviour at school?"
          input:
            control: Radio
            labels:
              1: "None or once"
              2: "Two or three times"
              3: "Four or more times"

        # EDU-Q17: Looks forward to school
        - id: q_edu_q17
          kind: Question
          title: "With regard to how the child feels about school, how often does he/she look forward to going to school?"
          input:
            control: Radio
            labels:
              1: "Almost never"
              2: "Rarely"
              3: "Sometimes"
              4: "Often"
              5: "Almost always"

        # EDU-Q18A: Importance of good grades (age 8+)
        # EDU-C18: IF AGE < 8 -> skip to Q18B
        - id: q_edu_q18a
          kind: Question
          title: "How important is it to you that the child have good grades in school?"
          precondition:
            - predicate: child_age >= 8
          input:
            control: Radio
            labels:
              1: "Very important"
              2: "Important"
              3: "Somewhat important"
              4: "Not important at all"

        # EDU-Q18B: Educational hopes
        - id: q_edu_q18b
          kind: Question
          title: "How far do you hope the child will go in school?"
          input:
            control: Dropdown
            labels:
              1: "Primary school"
              2: "Secondary or high school"
              3: "Community college, technical college, or CEGEP"
              4: "University"
              5: "Learn a trade"
              6: "Other"

    # =========================================================================
    # BLOCK 8: SCHOOL DESCRIPTORS
    # =========================================================================
    # EDU-C19A: Skip if in kindergarten/primary/junior kindergarten/ungraded
    #   (same condition as academic performance block)
    # EDU-I19A: Introduction
    # EDU-Q19A-D: School descriptor ratings
    # =========================================================================
    - id: b_edu_descriptors
      title: "School Descriptors"
      precondition:
        - predicate: child_age >= 4
        - predicate: in_school == 1
        - predicate: school_grade >= 4
        - predicate: school_grade <= 16
      items:
        # EDU-I19A: Introduction to school descriptors
        - id: q_edu_i19a
          kind: Comment
          title: "The following are possible descriptions of the child's present school. For each, please indicate whether you strongly agree, agree, disagree, or strongly disagree."

        # EDU-Q19A-D: School descriptors
        - id: qg_edu_q19
          kind: QuestionGroup
          title: "Please rate the following descriptions of the child's school:"
          questions:
            - "Academic progress is very important at this school"
            - "Most children in this school enjoy being there"
            - "Parents are made to feel welcome in this school"
            - "School spirit is very high"
          input:
            control: Radio
            labels:
              1: "Strongly agree"
              2: "Agree"
              3: "Disagree"
              4: "Strongly disagree"

    # =========================================================================
    # BLOCK 9: SPECIAL EDUCATION
    # =========================================================================
    # EDU-Q20: Special education
    # =========================================================================
    - id: b_edu_special
      title: "Special Education"
      precondition:
        - predicate: child_age >= 4
        - predicate: in_school == 1
      items:
        # EDU-Q20: Special education
        - id: q_edu_q20
          kind: Question
          title: "Does the child receive special education because a physical, emotional, behavioural, or some other problem limits the kind or amount of school work he/she can do?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

    # ===================================================================
    # SECTION: literacy
    # ===================================================================
    # =========================================================================
    # BLOCK 1: LITERACY INTRODUCTION
    # =========================================================================
    - id: b_lit_intro
      title: "Literacy"
      items:
        # LIT-I1: Introduction
        - id: q_lit_i1
          kind: Comment
          title: "Children can show their interest in reading or sharing books in different ways. The following are some questions about books and reading."

    # =========================================================================
    # BLOCK 2: INFANT READING (AGE 0-23 MONTHS)
    # =========================================================================
    # LIT-C1: IF AGE IN MONTHS > 23 -> skip to C4 routing
    # Q1-Q3 only for infants aged 0-23 months
    # =========================================================================
    - id: b_lit_infant
      title: "Infant Reading"
      precondition:
        - predicate: child_age_months <= 23
      items:
        # LIT-Q1: Read/show books to baby
        # NO/DK/Refusal -> skip to Activities section (exit this section)
        - id: q_lit_q1
          kind: Question
          title: "Do you or another adult ever read to the child, or show him/her pictures or wordless baby books?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # LIT-Q2: How often read to baby
        # Precondition: Q1 = YES
        - id: q_lit_q2
          kind: Question
          title: "How often do you do this?"
          precondition:
            - predicate: q_lit_q1.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Rarely"
              2: "Less than once a month"
              3: "Once a month"
              4: "A few times a month"
              5: "Once a week"
              6: "A few times a week"
              7: "Daily"
              8: "Many times each day"

        # LIT-Q3: Age when started reading to baby (months)
        # Precondition: Q1 = YES
        - id: q_lit_q3
          kind: Question
          title: "How old was he/she when you started to do this (to the nearest month)?"
          precondition:
            - predicate: q_lit_q1.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 23
            right: "months"

    # =========================================================================
    # BLOCK 3: EARLY CHILDHOOD READING (AGE 2-4)
    # =========================================================================
    # LIT-C4: age 2-4 -> Q4
    # Q4 and Q5 are for children aged 2-4 only
    # =========================================================================
    - id: b_lit_early_childhood
      title: "Early Childhood Reading Habits"
      precondition:
        - predicate: child_age >= 2
        - predicate: child_age <= 4
      items:
        # LIT-Q4: Looking at books on own (age 2-4)
        - id: q_lit_q4
          kind: Question
          title: "How often does the child look at books, magazines, comics, etc. on his/her own? (Think about what he/she does at home only, do not include day care or school.)"
          input:
            control: Dropdown
            labels:
              1: "Never or rarely"
              2: "Less than once a month"
              3: "Once a month"
              4: "A few times a month"
              5: "Once a week"
              6: "A few times a week"
              7: "Daily"
              8: "Many times each day"

        # LIT-Q5: Pretend writing (age 2-4)
        - id: q_lit_q5
          kind: Question
          title: "How often does he/she play with pencils or markers doing real or pretend writing?"
          input:
            control: Dropdown
            labels:
              1: "Never or rarely"
              2: "Less than once a month"
              3: "Once a month"
              4: "A few times a month"
              5: "Once a week"
              6: "A few times a week"
              7: "Daily"
              8: "Many times each day"

    # =========================================================================
    # BLOCK 4: READ ALOUD HISTORY (AGE 2-5)
    # =========================================================================
    # Q6A is reached by ages 2-4 (sequentially after Q5) and age 5 (from C4).
    # Q6B1 follows if Q6A = YES.
    # =========================================================================
    - id: b_lit_read_aloud
      title: "Reading Aloud History"
      precondition:
        - predicate: child_age >= 2
        - predicate: child_age <= 5
      items:
        # LIT-Q6A: Ever read aloud regularly (age 2-5)
        # NO -> skip to Q8; DK -> skip to C9 routing
        - id: q_lit_q6a
          kind: Question
          title: "Have you or another adult ever read aloud to the child on a regular basis?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # LIT-Q6B1: Age when started reading aloud (months)
        # Precondition: Q6A = YES
        - id: q_lit_q6b1
          kind: Question
          title: "How old was he/she when you started (to the nearest month of age)?"
          precondition:
            - predicate: q_lit_q6a.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 71
            right: "months"

    # =========================================================================
    # BLOCK 5: CURRENT READING FREQUENCY (AGE-VARIANT ITEMS)
    # =========================================================================
    # LIT-C7A: age < 5 -> Q7; age >= 5 -> Q7A
    # LIT-Q7: age 2-4, must have answered Q6A=YES
    # LIT-Q7A: age 5-7
    # LIT-Q7B: age 8-11
    # These are mutually exclusive age-variant items measuring the same
    # construct (current adult-child reading frequency).
    # =========================================================================
    - id: b_lit_reading_freq
      title: "Current Reading Frequency"
      precondition:
        - predicate: child_age >= 2
      items:
        # LIT-Q7: Reading frequency (age 2-4, Q6A=YES)
        # From C7A: age < 5 -> Q7 (only reached if Q6A was answered YES)
        - id: q_lit_q7
          kind: Question
          title: "Currently, how often do you or another adult read to him/her? (Also include if he/she reads or pretends to read to adult.)"
          precondition:
            - predicate: child_age >= 2 and child_age <= 4
            - predicate: q_lit_q6a.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Never or rarely"
              2: "Less than once a month"
              3: "Once a month"
              4: "A few times a month"
              5: "Once a week"
              6: "A few times a week"
              7: "Daily"
              8: "Many times each day"

        # LIT-Q7A: Reading frequency (age 5-7)
        # Age 5 arrives from C7A (after Q6B1); ages 6-7 arrive from C4.
        - id: q_lit_q7a
          kind: Question
          title: "Currently, how often do you or another adult read aloud to him/her or listen to him/her read or attempt to read aloud?"
          precondition:
            - predicate: child_age >= 5 and child_age <= 7
          input:
            control: Dropdown
            labels:
              1: "Never or rarely"
              2: "Less than once a month"
              3: "Once a month"
              4: "A few times a month"
              5: "Once a week"
              6: "A few times a week"
              7: "Daily"
              8: "Many times each day"

        # LIT-Q7B: Reading frequency (age 8-11)
        # Arrives directly from C4.
        - id: q_lit_q7b
          kind: Question
          title: "Currently, how often do you or another adult read aloud to him/her or listen to him/her read?"
          precondition:
            - predicate: child_age >= 8 and child_age <= 11
          input:
            control: Dropdown
            labels:
              1: "Never or rarely"
              2: "Less than once a month"
              3: "Once a month"
              4: "A few times a month"
              5: "Once a week"
              6: "A few times a week"
              7: "Daily"
              8: "Many times each day"

    # =========================================================================
    # BLOCK 6: WRITING HELP (AGE 2-5)
    # =========================================================================
    # LIT-C8: IF AGE > 5 -> Q9; OTHERWISE -> Q8
    # Q8 is for age <= 5 only.
    # Also skipped if Q6A = NO (NO -> Q8 per inventory, but only for age 5;
    # ages 2-4 with Q6A=NO also reach Q8 via sequential flow).
    # Q8 requires age 2-5; Q6A=NO skips Q6B1/Q7 but still reaches Q8.
    # =========================================================================
    - id: b_lit_writing_help
      title: "Writing Help"
      precondition:
        - predicate: child_age >= 2
        - predicate: child_age <= 5
      items:
        # LIT-Q8: Help/encourage writing (age 2-5)
        - id: q_lit_q8
          kind: Question
          title: "How often do you help or encourage him/her to write or pretend to write?"
          input:
            control: Dropdown
            labels:
              1: "Never or rarely"
              2: "Less than once a month"
              3: "Once a month"
              4: "A few times a month"
              5: "Once a week"
              6: "A few times a week"
              7: "Daily"
              8: "Many times each day"

    # =========================================================================
    # BLOCK 7: HOMEWORK (AGE 6-11)
    # =========================================================================
    # LIT-C8: IF AGE > 5 -> Q9
    # LIT-C9: IF AGE = 2-4 -> Activities section; age 5 -> Q12
    # So Q9-Q11 are only for ages 6-11.
    # =========================================================================
    - id: b_lit_homework
      title: "Homework"
      precondition:
        - predicate: child_age >= 6
        - predicate: child_age <= 11
      items:
        # LIT-Q9: Homework frequency (age 6-11)
        # NEVER/DK -> skip Q10A-Q11, go to C12A
        - id: q_lit_q9
          kind: Question
          title: "How often is the child assigned homework?"
          input:
            control: Dropdown
            labels:
              1: "Never"
              2: "Less than once a month"
              3: "Once a month"
              4: "A few times a month"
              5: "Once a week"
              6: "A few times a week"
              7: "Daily"

        # LIT-Q10A: Homework time (age 6-11)
        # Only if homework is assigned (Q9 > 1)
        - id: q_lit_q10a
          kind: Question
          title: "On days when he/she is assigned homework, how much time does he/she usually spend doing homework?"
          precondition:
            - predicate: q_lit_q9.outcome >= 2
          input:
            control: Editbox
            min: 1
            max: 480
            right: "minutes"

        # LIT-Q11: Help with homework frequency (age 6-11)
        # Only if homework is assigned (Q9 > 1)
        - id: q_lit_q11
          kind: Question
          title: "How often do you check his/her homework or provide help with homework?"
          precondition:
            - predicate: q_lit_q9.outcome >= 2
          input:
            control: Dropdown
            labels:
              1: "Never or rarely"
              2: "Less than once a month"
              3: "Once a month"
              4: "A few times a month"
              5: "Once a week"
              6: "A few times a week"
              7: "Daily"

    # =========================================================================
    # BLOCK 8: INDEPENDENT READING & LIBRARY (AGE 5-11)
    # =========================================================================
    # LIT-C9: age 2-4 -> Activities (exit); age 5 -> Q12
    # LIT-C12A: age 6 -> Q12; age 7+ -> Q12A
    # Q12: age 5-6 (younger phrasing: "look at books or try to read")
    # Q12A: age 7-11 (older phrasing: "read for pleasure")
    # Q13-Q14: age 5-11 (all who reach this block)
    # =========================================================================
    - id: b_lit_independent_reading
      title: "Independent Reading and Library Use"
      precondition:
        - predicate: child_age >= 5
        - predicate: child_age <= 11
      items:
        # LIT-Q12: Independent reading (age 5-6)
        # Younger phrasing for children who may not yet read independently
        - id: q_lit_q12
          kind: Question
          title: "How often does the child look at books or try to read on his/her own?"
          precondition:
            - predicate: child_age >= 5 and child_age <= 6
          input:
            control: Dropdown
            labels:
              1: "Never or rarely"
              2: "Less than once a month"
              3: "Once a month"
              4: "A few times a month"
              5: "Once a week"
              6: "A few times a week"
              7: "Daily"
              8: "Many times each day"

        # LIT-Q12A: Reading for pleasure (age 7-11)
        # Older phrasing assumes literacy
        - id: q_lit_q12a
          kind: Question
          title: "How often does the child read for pleasure?"
          precondition:
            - predicate: child_age >= 7 and child_age <= 11
          input:
            control: Dropdown
            labels:
              1: "Never or rarely"
              2: "Less than once a month"
              3: "Once a month"
              4: "A few times a month"
              5: "Once a week"
              6: "A few times a week"
              7: "Daily"
              8: "Many times each day"

        # LIT-Q13: Discuss books (age 5-11)
        - id: q_lit_q13
          kind: Question
          title: "How often does he/she talk about a book with family or friends?"
          input:
            control: Dropdown
            labels:
              1: "Never or rarely"
              2: "Less than once a month"
              3: "Once a month"
              4: "A few times a month"
              5: "Once a week"
              6: "A few times a week"
              7: "Daily"
              8: "Many times each day"

        # LIT-Q14: Library visits (age 5-11)
        - id: q_lit_q14
          kind: Question
          title: "How often does he/she go to the library, including the school library?"
          input:
            control: Dropdown
            labels:
              1: "Never or rarely"
              2: "Less than once a month"
              3: "Once a month"
              4: "A few times a month"
              5: "Once a week"
              6: "A few times a week"
              7: "Daily"
              8: "Many times each day"

    # ===================================================================
    # SECTION: activities
    # ===================================================================
    # =========================================================================
    # BLOCK 1: EARLY CHILDHOOD PROGRAMS (ACT-I1, ACT-Q1, ACT-Q2A, ACT-Q2B)
    # =========================================================================
    # ACT-I1: Intro for all ages
    # ACT-C1: IF AGE > 5 → skip to Q3A. Modeled as precondition child_age <= 5
    # ACT-Q1: Early childhood programs (age 0-5 only)
    # ACT-Q2A/Q2B: Program details (only if Q1 = YES)
    # =========================================================================
    - id: b_act_early
      title: "Activities - Early Childhood Programs"
      items:
        # ACT-I1: Introduction
        - id: q_act_intro
          kind: Comment
          title: "The next few questions are about this child's interests and activities."

        # ACT-Q1: Early childhood programs (age 0-5 only)
        # ACT-C1 routing: IF AGE > 5 → skip to Q3A
        - id: q_act_q1
          kind: Question
          title: "Does he/she currently attend any nursery school, play group or other early childhood program or activity? (Please do not include child care programs or time spent in elementary school.)"
          precondition:
            - predicate: child_age <= 5
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # ACT-Q2A: Program types (only if Q1 = YES)
        - id: q_act_q2a
          kind: Question
          title: "What type(s) of programs or activities? (Mark all that apply.)"
          precondition:
            - predicate: child_age <= 5
            - predicate: q_act_q1.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "Nursery school, preschool or kindergarten"
              2: "Play group"
              4: "Drop-in centre"
              8: "Toy library"
              16: "Infant stimulation program"
              32: "Mom and tot program"
              64: "Other"

        # ACT-Q2B: Hours per week in programs
        - id: q_act_q2b
          kind: Question
          title: "For about how many hours a week does he/she attend these in total?"
          precondition:
            - predicate: child_age <= 5
            - predicate: q_act_q1.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 60
            right: "hours per week"

    # =========================================================================
    # BLOCK 2: ACTIVITY FREQUENCY (ACT-Q3A through ACT-Q3E)
    # =========================================================================
    # ACT-C3: IF AGE < 4 → skip to behaviour section. Modeled as
    #         precondition child_age >= 4 on this block.
    # ACT-Q3A-Q3C: Activity frequency questions (age 4+)
    # ACT-C3D: Age-variant club question (Q3D1/Q3D2/Q3D3)
    # ACT-Q3E: Computer/video games (age 4+)
    # =========================================================================
    - id: b_act_frequency
      title: "Activities - Activity Frequency"
      precondition:
        - predicate: child_age >= 4
      items:
        # ACT-Q3A: Sports with coaching/instruction
        - id: q_act_q3a
          kind: Question
          title: "In the last 12 months, outside of school hours, how often has the child taken part in any sports which involved coaching or instruction?"
          input:
            control: Radio
            labels:
              1: "Most days"
              2: "A few times a week"
              3: "About once a week"
              4: "About once a month"
              5: "Almost never"

        # ACT-Q3B: Unorganized sports/physical activities
        - id: q_act_q3b
          kind: Question
          title: "How often has the child taken part in unorganized sports or physical activities?"
          input:
            control: Radio
            labels:
              1: "Most days"
              2: "A few times a week"
              3: "About once a week"
              4: "About once a month"
              5: "Almost never"

        # ACT-Q3C: Lessons in music, dance, art, etc.
        - id: q_act_q3c
          kind: Question
          title: "How often has the child taken lessons or instruction in music, dance, art or other non-sport activities?"
          input:
            control: Radio
            labels:
              1: "Most days"
              2: "A few times a week"
              3: "About once a week"
              4: "About once a month"
              5: "Almost never"

        # ACT-Q3D1: Clubs/groups — age 4-5 variant
        # ACT-C3D routing: mutually exclusive by age band
        - id: q_act_q3d1
          kind: Question
          title: "How often has the child taken part in any clubs, groups or community programs with leadership, such as Beavers, Sparks or church groups?"
          precondition:
            - predicate: child_age >= 4 and child_age <= 5
          input:
            control: Radio
            labels:
              1: "Most days"
              2: "A few times a week"
              3: "About once a week"
              4: "About once a month"
              5: "Almost never"

        # ACT-Q3D2: Clubs/groups — age 6-9 variant
        - id: q_act_q3d2
          kind: Question
          title: "How often has the child taken part in any clubs, groups or community programs with leadership, such as Brownies, Cubs or church groups?"
          precondition:
            - predicate: child_age >= 6 and child_age <= 9
          input:
            control: Radio
            labels:
              1: "Most days"
              2: "A few times a week"
              3: "About once a week"
              4: "About once a month"
              5: "Almost never"

        # ACT-Q3D3: Clubs/groups — age 10-11 variant
        - id: q_act_q3d3
          kind: Question
          title: "How often has the child taken part in any clubs, groups or community programs with leadership, such as Boys and Girls Clubs, Scouts, Guides or church groups?"
          precondition:
            - predicate: child_age >= 10 and child_age <= 11
          input:
            control: Radio
            labels:
              1: "Most days"
              2: "A few times a week"
              3: "About once a week"
              4: "About once a month"
              5: "Almost never"

        # ACT-Q3E: Computer/video games
        - id: q_act_q3e
          kind: Question
          title: "How often has the child played computer or video games?"
          input:
            control: Radio
            labels:
              1: "Most days"
              2: "A few times a week"
              3: "About once a week"
              4: "About once a month"
              5: "Almost never"

    # =========================================================================
    # BLOCK 3: TV AND PLAY (ACT-Q4A, ACT-Q4B, ACT-Q5)
    # =========================================================================
    # Age 4+ (inherits from same routing as block 2)
    # ACT-Q4A: TV days per week; if 0 → skip Q4B
    # ACT-Q4B: TV hours per day (only if Q4A > 0)
    # ACT-Q5: Play alone frequency
    # =========================================================================
    - id: b_act_tv_play
      title: "Activities - TV and Play"
      precondition:
        - predicate: child_age >= 4
      items:
        # ACT-Q4A: TV days per week
        - id: q_act_q4a
          kind: Question
          title: "About how many days a week on average does the child watch T.V. or videos at home?"
          input:
            control: Editbox
            min: 0
            max: 7
            right: "days per week"

        # ACT-Q4B: TV hours per day (only if watches some TV)
        - id: q_act_q4b
          kind: Question
          title: "On those days, how many hours on average does he/she spend watching T.V. or videos?"
          precondition:
            - predicate: q_act_q4a.outcome >= 1
          input:
            control: Editbox
            min: 1
            max: 16
            right: "hours per day"

        # ACT-Q5: Play alone frequency
        - id: q_act_q5
          kind: Question
          title: "How often does he/she play alone (e.g., riding a bike, doing a craft or hobby, playing ball)?"
          input:
            control: Radio
            labels:
              1: "Often"
              2: "Sometimes"
              3: "Seldom"
              4: "Never"

    # =========================================================================
    # BLOCK 4: CHORES (ACT-Q6A through ACT-Q6F)
    # =========================================================================
    # ACT-C6: IF AGE < 6 → skip to behaviour; IF AGE 6-9 → skip to Q7A
    # Chores block is for age 10-11 only.
    # =========================================================================
    - id: b_act_chores
      title: "Activities - Chores"
      precondition:
        - predicate: child_age >= 10
        - predicate: child_age <= 11
      items:
        # ACT-Q6A-Q6F: Chores frequency (6 sub-questions, same scale)
        - id: qg_act_q6
          kind: QuestionGroup
          title: "I would like to ask you some questions about his/her responsibilities at home. How often does he/she:"
          questions:
            - "(a) Make his/her own bed?"
            - "(b) Clean his/her own room?"
            - "(c) Pick up after him/herself?"
            - "(d) Help keep shared living areas clean and straight?"
            - "(e) Do routine chores such as mow the lawn, help with dinner, wash dishes, etc.?"
            - "(f) Help manage his/her own time (get up on time, be ready for school, etc.)?"
          input:
            control: Radio
            labels:
              1: "Often"
              2: "Sometimes"
              3: "Seldom"
              4: "Never"

    # =========================================================================
    # BLOCK 5: CAMPS (ACT-Q7A, ACT-Q7B, ACT-Q8A, ACT-Q8B)
    # =========================================================================
    # ACT-C6 routing: age 6-9 → Q7A; age 10-11 → Q6A (above) then Q7A
    # Camp questions are for age 6+ only.
    # ACT-Q7A: Overnight camp; if NO → skip to Q8A
    # ACT-Q7B: Camp days (only if Q7A = YES)
    # ACT-Q8A: Day camp; if NO → end
    # ACT-Q8B: Day camp days (only if Q8A = YES)
    # =========================================================================
    - id: b_act_camps
      title: "Activities - Camps"
      precondition:
        - predicate: child_age >= 6
      items:
        # ACT-Q7A: Overnight camp
        - id: q_act_q7a
          kind: Question
          title: "Did the child attend an overnight camp last summer?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # ACT-Q7B: Overnight camp days (only if Q7A = YES)
        - id: q_act_q7b
          kind: Question
          title: "For how many days?"
          precondition:
            - predicate: q_act_q7a.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 90
            right: "days"

        # ACT-Q8A: Day camp
        - id: q_act_q8a
          kind: Question
          title: "Last summer, did the child attend a day camp or recreational or skill-building activity that ran for half days or full days (e.g., music program, reading program, athletic program)?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # ACT-Q8B: Day camp days (only if Q8A = YES)
        - id: q_act_q8b
          kind: Question
          title: "For how many days?"
          precondition:
            - predicate: q_act_q8a.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 90
            right: "days"

    # ===================================================================
    # SECTION: behaviour
    # ===================================================================
    # =========================================================================
    # BLOCK 1: SLEEP PATTERNS (Age 0-3)
    # =========================================================================
    # BEH-C1: IF AGE > 3 -> skip to Q6A block
    # BEH-Q1 through BEH-Q4: Sleep pattern questions on 5-point frequency scale
    # =========================================================================
    - id: b_beh_sleep
      title: "Sleep Patterns"
      precondition:
        - predicate: child_age <= 3
      items:
        # BEH-Q1: Trouble falling asleep
        - id: q_beh_q1
          kind: Question
          title: "The following questions relate to the child's sleep patterns. When you put him/her to bed, how often does he/she have trouble falling asleep?"
          input:
            control: Radio
            labels:
              1: "Almost every time"
              2: "Often"
              3: "About half of the time"
              4: "Sometimes"
              5: "Almost never"

        # BEH-Q2: Long bedtime routine
        - id: q_beh_q2
          kind: Question
          title: "Does he/she have a particular and long routine (more than 30 minutes) to go to bed (rocking, songs, nursery rhymes, etc.) that he/she cannot go to sleep without?"
          input:
            control: Radio
            labels:
              1: "Almost every time"
              2: "Often"
              3: "About half of the time"
              4: "Sometimes"
              5: "Almost never"

        # BEH-Q3: Wakes up several times
        - id: q_beh_q3
          kind: Question
          title: "Does the child wake up several times during his/her sleep?"
          input:
            control: Radio
            labels:
              1: "Almost every time"
              2: "Often"
              3: "About half of the time"
              4: "Sometimes"
              5: "Almost never"

        # BEH-Q4: Restless sleep
        - id: q_beh_q4
          kind: Question
          title: "Does he/she have a restless sleep?"
          input:
            control: Radio
            labels:
              1: "Almost every time"
              2: "Often"
              3: "About half of the time"
              4: "Sometimes"
              5: "Almost never"

    # =========================================================================
    # BLOCK 2: INFANT FEEDING — Q5 (Age 1-3)
    # =========================================================================
    # BEH-C5: IF AGE < 1 -> Q5A; OTHERWISE -> Q5
    # BEH-Q5: Reaction to new foods (age 1-3)
    # =========================================================================
    - id: b_beh_feeding
      title: "Infant Feeding Reactions"
      precondition:
        - predicate: child_age >= 1 and child_age <= 3
      items:
        # BEH-Q5: Reaction to new foods
        - id: q_beh_q5
          kind: Question
          title: "The following are a few examples of how infants react to new foods (orange juice, apple puree, porridge, vegetables, etc.). Which of the following is the best approximation of how the child reacts?"
          input:
            control: Radio
            labels:
              1: "He/she swallows everything without complaining"
              2: "The first time he/she made faces or spit out the food, but after a few tries, he/she got used to it"
              3: "The same reaction after several attempts, he/she continued to refuse most of the new foods"

    # =========================================================================
    # BLOCK 3: INFANT FEEDING — Q5A (Age 0-11 months)
    # =========================================================================
    # BEH-Q5A: Feeding difficulty (age 0-11 months only)
    # =========================================================================
    - id: b_beh_feeding_infant
      title: "Infant Feeding Difficulty"
      precondition:
        - predicate: child_age == 0
      items:
        # BEH-Q5A: How often difficult to feed
        - id: q_beh_q5a
          kind: Question
          title: "How often do you find him/her difficult to feed?"
          input:
            control: Radio
            labels:
              1: "Almost every time"
              2: "Often"
              3: "About half of the time"
              4: "Sometimes"
              5: "Almost never"

    # =========================================================================
    # BLOCK 4: CHILD BEHAVIOUR AGE 4-11 (Q6A-Q6UU)
    # =========================================================================
    # BEH-I6A: Intro. Precondition: child_age >= 4
    # BEH-Q6A through BEH-Q6UU: 47 behaviour items on 3-point scale
    # All items share the same scale so modeled as one QuestionGroup.
    # Index mapping:
    #   [0]  Q6A  - Shows sympathy to someone who made a mistake
    #   [1]  Q6B  - Can't sit still, restless, hyperactive
    #   [2]  Q6C  - Destroys own things
    #   [3]  Q6D  - Will try to help someone who has been hurt
    #   [4]  Q6E  - Steals at home
    #   [5]  Q6F  - Seems unhappy, sad, or depressed
    #   [6]  Q6G  - Gets into many fights
    #   [7]  Q6H  - Volunteers to help clear up a mess
    #   [8]  Q6I  - Distractible, trouble sticking to activity
    #   [9]  Q6J  - When mad, tries to get others to dislike that person
    #   [10] Q6K  - Not as happy as other children
    #   [11] Q6L  - Destroys things belonging to family/others
    #   [12] Q6M  - Tries to stop quarrel or dispute
    #   [13] Q6N  - Fidgets
    #   [14] Q6O  - Disobedient at school
    #   [15] Q6P  - Can't concentrate, can't pay attention for long
    #   [16] Q6Q  - Too fearful or anxious
    #   [17] Q6R  - When mad, becomes friends with another as revenge
    #   [18] Q6S  - Impulsive, acts without thinking
    #   [19] Q6T  - Tells lies or cheats
    #   [20] Q6U  - Offers to help other children with a task
    #   [21] Q6V  - Is worried
    #   [22] Q6W  - Has difficulty awaiting turn
    #   [23] Q6X  - Assumes accidental hurt was intentional, reacts with anger
    #   [24] Q6Y  - Tends to do things alone, rather solitary
    #   [25] Q6Z  - When mad, says bad things behind the other's back
    #   [26] Q6AA - Physically attacks people
    #   [27] Q6BB - Comforts a child who is crying or upset
    #   [28] Q6CC - Cries a lot
    #   [29] Q6DD - Vandalizes
    #   [30] Q6EE - Gives up easily
    #   [31] Q6FF - Threatens people
    #   [32] Q6GG - Helps pick up objects another child dropped
    #   [33] Q6HH - Cannot settle to anything for more than a few moments
    #   [34] Q6II - Appears miserable, unhappy, tearful, distressed
    #   [35] Q6JJ - Cruel, bullies or is mean to others
    #   [36] Q6KK - Stares into space
    #   [37] Q6LL - When mad, says let's not be with him/her
    #   [38] Q6MM - Nervous, highstrung or tense
    #   [39] Q6NN - Kicks, bites, hits other children
    #   [40] Q6OO - Will invite bystanders to join in a game
    #   [41] Q6PP - Steals outside the home
    #   [42] Q6QQ - Is inattentive
    #   [43] Q6RR - Has trouble enjoying him/herself
    #   [44] Q6SS - Helps other children who are feeling sick
    #   [45] Q6TT - When mad, tells secrets to a third person
    #   [46] Q6UU - Praises the work of less able children
    # =========================================================================
    - id: b_beh_child_4_11
      title: "Child Behaviour Assessment (Age 4-11)"
      precondition:
        - predicate: child_age >= 4
      items:
        # BEH-I6A: Intro
        - id: q_beh_i6a
          kind: Comment
          title: "Now I'd like to ask you questions about how the child seems to feel or act."

        # BEH-Q6A through BEH-Q6UU: 47 behaviour items
        - id: qg_beh_4_11
          kind: QuestionGroup
          title: "Using the answers never or not true, sometimes or somewhat true, or often or very true, how often would you say that the child:"
          questions:
            - "(Q6A) Shows sympathy to someone who has made a mistake?"
            - "(Q6B) Can't sit still, is restless, or hyperactive?"
            - "(Q6C) Destroys his/her own things?"
            - "(Q6D) Will try to help someone who has been hurt?"
            - "(Q6E) Steals at home?"
            - "(Q6F) Seems to be unhappy, sad, or depressed?"
            - "(Q6G) Gets into many fights?"
            - "(Q6H) Volunteers to help clear up a mess someone else has made?"
            - "(Q6I) Is distractible, has trouble sticking to any activity?"
            - "(Q6J) When mad at someone, tries to get others to dislike that person?"
            - "(Q6K) Is not as happy as other children?"
            - "(Q6L) Destroys things belonging to his/her family, or other children?"
            - "(Q6M) If there is a quarrel or dispute, will try to stop it?"
            - "(Q6N) Fidgets?"
            - "(Q6O) Is disobedient at school?"
            - "(Q6P) Can't concentrate, can't pay attention for long?"
            - "(Q6Q) Is too fearful or anxious?"
            - "(Q6R) When mad at someone, becomes friends with another as revenge?"
            - "(Q6S) Is impulsive, acts without thinking?"
            - "(Q6T) Tells lies or cheats?"
            - "(Q6U) Offers to help other children (friend, brother or sister) who are having difficulty with a task?"
            - "(Q6V) Is worried?"
            - "(Q6W) Has difficulty awaiting turn in games or groups?"
            - "(Q6X) When another child accidentally hurts him/her, assumes that the other child meant to do it, and then reacts with anger and fighting?"
            - "(Q6Y) Tends to do things on his/her own - is rather solitary?"
            - "(Q6Z) When mad at someone, says bad things behind the other's back?"
            - "(Q6AA) Physically attacks people?"
            - "(Q6BB) Comforts a child (friend, brother, or sister) who is crying or upset?"
            - "(Q6CC) Cries a lot?"
            - "(Q6DD) Vandalizes?"
            - "(Q6EE) Gives up easily?"
            - "(Q6FF) Threatens people?"
            - "(Q6GG) Spontaneously helps to pick up objects which another child has dropped (e.g. pencils, books, etc.)?"
            - "(Q6HH) Cannot settle to anything for more than a few moments?"
            - "(Q6II) Appears miserable, unhappy, tearful, or distressed?"
            - "(Q6JJ) Is cruel, bullies or is mean to others?"
            - "(Q6KK) Stares into space?"
            - "(Q6LL) When mad at someone, says to others: let's not be with him/her?"
            - "(Q6MM) Is nervous, highstrung or tense?"
            - "(Q6NN) Kicks, bites, hits other children?"
            - "(Q6OO) Will invite bystanders to join in a game?"
            - "(Q6PP) Steals outside the home?"
            - "(Q6QQ) Is inattentive?"
            - "(Q6RR) Has trouble enjoying him/herself?"
            - "(Q6SS) Helps other children (friends, brother or sister) who are feeling sick?"
            - "(Q6TT) When mad at someone, tells the other one's secrets to a third person?"
            - "(Q6UU) Takes the opportunity to praise the work of less able children?"
          input:
            control: Radio
            labels:
              1: "Never or not true"
              2: "Sometimes or somewhat true"
              3: "Often or very true"

    # =========================================================================
    # BLOCK 5: DELINQUENT BEHAVIOURS (Age 10-11)
    # =========================================================================
    # BEH-C7A: IF AGE < 10 -> skip
    # BEH-I7A: Intro
    # BEH-Q7A through BEH-Q7E: 5 items on 4-point frequency scale
    # BEH-Q7F: Run away from home (Yes/No)
    # =========================================================================
    - id: b_beh_delinquent
      title: "Delinquent Behaviours (Age 10-11)"
      precondition:
        - predicate: child_age >= 10
      items:
        # BEH-I7A: Intro
        - id: q_beh_i7a
          kind: Comment
          title: "Now I'd like to ask you some questions about certain difficult behaviours which some children may show at this age. These may or may not apply to the child."

        # BEH-Q7A through BEH-Q7E: Delinquent behaviours on 4-point scale
        # Index mapping:
        #   [0] Q7A - Stayed out later than allowed
        #   [1] Q7B - Stayed out all night without permission
        #   [2] Q7C - Skipped a day of school without permission
        #   [3] Q7D - Gotten drunk
        #   [4] Q7E - Questioned by police
        - id: qg_beh_delinquent
          kind: QuestionGroup
          title: "In the past year, about how many times has the child:"
          questions:
            - "(Q7A) Stayed out later than you said he/she should?"
            - "(Q7B) Stayed out all night without permission?"
            - "(Q7C) Skipped a day of school without permission?"
            - "(Q7D) Gotten drunk?"
            - "(Q7E) Been questioned by the police about anything he/she might have done such as stealing, damaging property, or something else?"
          input:
            control: Radio
            labels:
              1: "Never"
              2: "Once"
              3: "Twice"
              4: "More than twice"

        # BEH-Q7F: Run away from home
        - id: q_beh_q7f
          kind: Question
          title: "Has he/she ever run away from home?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # =========================================================================
    # BLOCK 6: TODDLER BEHAVIOUR (Age 2-3)
    # =========================================================================
    # BEH-I8A: Intro. Precondition: child_age >= 2 and child_age <= 3
    # BEH-Q8B through BEH-Q8UU: 33 items on 3-point scale
    # Index mapping:
    #   [0]  Q8B   - Can't sit still, restless, hyperactive
    #   [1]  Q8D   - Will try to help someone who has been hurt
    #   [2]  Q8E1  - Is defiant
    #   [3]  Q8F   - Seems unhappy, sad, or depressed
    #   [4]  Q8G   - Gets into many fights
    #   [5]  Q8I   - Distractible, trouble sticking to activity
    #   [6]  Q8J1  - Doesn't seem to feel guilty after misbehaving
    #   [7]  Q8K   - Not as happy as other children
    #   [8]  Q8N   - Fidgets
    #   [9]  Q8P   - Can't concentrate, can't pay attention for long
    #   [10] Q8Q   - Too fearful or anxious
    #   [11] Q8R1  - Punishment doesn't change behaviour
    #   [12] Q8S   - Impulsive, acts without thinking
    #   [13] Q8T1  - Has temper tantrums or hot temper
    #   [14] Q8U   - Offers to help other children with a task
    #   [15] Q8V   - Is worried
    #   [16] Q8W   - Has difficulty awaiting turn
    #   [17] Q8X   - Assumes accidental hurt was intentional
    #   [18] Q8Z1  - Has angry moods
    #   [19] Q8BB  - Comforts a child who is crying or upset
    #   [20] Q8CC  - Cries a lot
    #   [21] Q8DD1 - Clings to adults or too dependent
    #   [22] Q8EE  - Gives up easily
    #   [23] Q8HH  - Cannot settle to anything
    #   [24] Q8KK  - Stares into space
    #   [25] Q8LL1 - Constantly seeks help
    #   [26] Q8MM  - Nervous, highstrung or tense
    #   [27] Q8NN  - Kicks, bites, hits other children
    #   [28] Q8PP1 - Doesn't want to sleep alone
    #   [29] Q8QQ  - Is inattentive
    #   [30] Q8RR  - Has trouble enjoying him/herself
    #   [31] Q8SS  - Helps other children who are feeling sick
    #   [32] Q8TT  - Gets too upset when separated from parents
    #   [33] Q8UU  - Praises the work of less able children
    # =========================================================================
    - id: b_beh_toddler
      title: "Toddler Behaviour Assessment (Age 2-3)"
      precondition:
        - predicate: child_age >= 2 and child_age <= 3
      items:
        # BEH-I8A: Intro
        - id: q_beh_i8a
          kind: Comment
          title: "Now I'd like to ask you questions about how the child seems to feel or act."

        # BEH-Q8B through BEH-Q8UU: 34 toddler behaviour items
        - id: qg_beh_toddler
          kind: QuestionGroup
          title: "Using the answers never or not true, sometimes or somewhat true, or often or very true, how often would you say that the child:"
          questions:
            - "(Q8B) Can't sit still, is restless, or hyperactive?"
            - "(Q8D) Will try to help someone who has been hurt?"
            - "(Q8E1) Is defiant?"
            - "(Q8F) Seems to be unhappy, sad, or depressed?"
            - "(Q8G) Gets into many fights?"
            - "(Q8I) Is distractible, has trouble sticking to any activity?"
            - "(Q8J1) Doesn't seem to feel guilty after misbehaving?"
            - "(Q8K) Is not as happy as other children?"
            - "(Q8N) Fidgets?"
            - "(Q8P) Can't concentrate, can't pay attention for long?"
            - "(Q8Q) Is too fearful or anxious?"
            - "(Q8R1) Punishment doesn't change his/her behaviour?"
            - "(Q8S) Is impulsive, acts without thinking?"
            - "(Q8T1) Has temper tantrums or hot temper?"
            - "(Q8U) Offers to help other children (friend, brother or sister) who are having difficulty with a task?"
            - "(Q8V) Is worried?"
            - "(Q8W) Has difficulty awaiting turn in games or groups?"
            - "(Q8X) When another child accidentally hurts him/her, assumes that the other child meant to do it, and then reacts with anger and fighting?"
            - "(Q8Z1) Has angry moods?"
            - "(Q8BB) Comforts a child (friend, brother, or sister) who is crying or upset?"
            - "(Q8CC) Cries a lot?"
            - "(Q8DD1) Clings to adults or is too dependent?"
            - "(Q8EE) Gives up easily?"
            - "(Q8HH) Cannot settle to anything for more than a few moments?"
            - "(Q8KK) Stares into space?"
            - "(Q8LL1) Constantly seeks help?"
            - "(Q8MM) Is nervous, highstrung or tense?"
            - "(Q8NN) Kicks, bites, hits other children?"
            - "(Q8PP1) Doesn't want to sleep alone?"
            - "(Q8QQ) Is inattentive?"
            - "(Q8RR) Has trouble enjoying him/herself?"
            - "(Q8SS) Helps other children (friends, brother or sister) who are feeling sick?"
            - "(Q8TT) Gets too upset when separated from parents?"
            - "(Q8UU) Takes the opportunity to praise the work of less able children?"
          input:
            control: Radio
            labels:
              1: "Never or not true"
              2: "Sometimes or somewhat true"
              3: "Often or very true"

    # ===================================================================
    # SECTION: motor_social_development
    # ===================================================================
    # =========================================================================
    # BLOCK 1: MOTOR AND SOCIAL DEVELOPMENT
    # =========================================================================
    # MSD-C1: IF AGE > 3 YEARS → skip entire section
    # MSD-I1: Introduction
    # MSD-Q1 through Q48: Developmental milestone questions
    # Age-band routing via preconditions on child_age_months:
    #   0-3m:  Q1-Q15    → exit at C16
    #   4-6m:  Q8-Q22    → exit at C23
    #   7-9m:  Q12-Q26   → exit at C27
    #   10-12m: Q18-Q32  → exit at C33
    #   13-15m: Q22-Q36  → exit at C37
    #   16-18m: Q26-Q40  → exit at C41
    #   19-21m: Q29-Q43  → exit at C44
    #   22-47m: Q34-Q48
    # =========================================================================
    - id: b_msd
      title: "Motor and Social Development"
      precondition:
        - predicate: child_age <= 3
      items:
        # MSD-I1: Introduction
        - id: q_msd_intro
          kind: Comment
          title: "The following questions are about this child's motor and social development."

        # -----------------------------------------------------------------
        # Q1-Q7: First appears in 0-3m band (no lower age gate needed)
        # Upper bound: Q1-Q7 last appear in 4-6m band → exit at C16 for
        # children 0-3m, but Q1-Q7 are also in 4-6m band.
        # Actually Q1-Q15 are in 0-3m; Q8-Q22 are in 4-6m.
        # So Q1-Q7 appear ONLY in 0-3m and 4-6m bands.
        # Children 7m+ exit via C23 at Q22, never reach Q1-Q7 anyway
        # because Q1-Q7 have no lower gate. But the age-band exit checks
        # (C16, C23, etc.) act as upper bounds on later questions.
        # For Q1-Q7: no minimum age needed; maximum handled by exit checks.
        # -----------------------------------------------------------------

        # MSD-Q1
        - id: q_msd_q1
          kind: Question
          title: "When lying on his/her stomach, has this child ever turned his/her head from side to side?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q2
        - id: q_msd_q2
          kind: Question
          title: "Have his/her eyes ever followed a moving object?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q3
        - id: q_msd_q3
          kind: Question
          title: "When lying on his/her stomach on a flat surface, has he/she ever lifted his/her head off the surface for a moment?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q4
        - id: q_msd_q4
          kind: Question
          title: "Have his/her eyes ever followed a moving object all the way from one side to the other?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q5
        - id: q_msd_q5
          kind: Question
          title: "Has he/she ever smiled at someone when that person talked to or smiled at (but did not touch) him/her?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q6
        - id: q_msd_q6
          kind: Question
          title: "When lying on his/her stomach, has he/she ever raised his/her head and chest from the surface while resting his/her weight on his/her lower arms or hands?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q7
        - id: q_msd_q7
          kind: Question
          title: "Has he/she ever turned his/her head around to look at something?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -----------------------------------------------------------------
        # Q8-Q11: First appears in 4-6m band → minimum age 4 months
        # -----------------------------------------------------------------

        # MSD-Q8
        - id: q_msd_q8
          kind: Question
          title: "When lying on his/her back and being pulled up to a sitting position, did this child ever hold his/her head stiffly so that it did not hang back as he/she was pulled up?"
          precondition:
            - predicate: child_age_months >= 4
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q9
        - id: q_msd_q9
          kind: Question
          title: "Has he/she ever laughed out loud without being tickled or touched?"
          precondition:
            - predicate: child_age_months >= 4
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q10
        - id: q_msd_q10
          kind: Question
          title: "Has he/she ever held in one hand a moderate size object such as a block or a rattle?"
          precondition:
            - predicate: child_age_months >= 4
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q11
        - id: q_msd_q11
          kind: Question
          title: "Has he/she ever rolled over on his/her own on purpose?"
          precondition:
            - predicate: child_age_months >= 4
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -----------------------------------------------------------------
        # Q12-Q15: First appears in 7-9m band → minimum age 7 months
        # -----------------------------------------------------------------

        # MSD-Q12
        - id: q_msd_q12
          kind: Question
          title: "Has this child ever seemed to enjoy looking in the mirror at him/herself?"
          precondition:
            - predicate: child_age_months >= 7
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q13
        - id: q_msd_q13
          kind: Question
          title: "Has he/she ever been pulled from a sitting to a standing position and supported his/her own weight with legs stretched out?"
          precondition:
            - predicate: child_age_months >= 7
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q14
        - id: q_msd_q14
          kind: Question
          title: "Has he/she ever looked around with his/her eyes for a toy which was lost or not nearby?"
          precondition:
            - predicate: child_age_months >= 7
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q15
        - id: q_msd_q15
          kind: Question
          title: "Has he/she ever sat alone with no help except for leaning forward on his/her hands or with just a little help from someone else?"
          precondition:
            - predicate: child_age_months >= 7
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -----------------------------------------------------------------
        # MSD-C16: IF AGE 0-3 MONTHS → exit to Relationships
        # Modeled as: Q16+ requires child_age_months >= 4
        # -----------------------------------------------------------------

        # MSD-Q16
        - id: q_msd_q16
          kind: Question
          title: "Has he/she ever sat for 10 minutes without any support at all?"
          precondition:
            - predicate: child_age_months >= 4
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q17
        - id: q_msd_q17
          kind: Question
          title: "Has he/she ever pulled him/herself to a standing position without help from another person?"
          precondition:
            - predicate: child_age_months >= 4
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -----------------------------------------------------------------
        # Q18-Q21: First appears in 10-12m band → minimum age 10 months
        # -----------------------------------------------------------------

        # MSD-Q18
        - id: q_msd_q18
          kind: Question
          title: "Has this child ever crawled when left lying on his/her stomach?"
          precondition:
            - predicate: child_age_months >= 10
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q19
        - id: q_msd_q19
          kind: Question
          title: "Has he/she ever said any recognizable words such as \"mama\" or \"dada\"?"
          precondition:
            - predicate: child_age_months >= 10
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q20
        - id: q_msd_q20
          kind: Question
          title: "Has he/she ever picked up small objects such as raisins or cookie crumbs, using only his/her thumb and first finger?"
          precondition:
            - predicate: child_age_months >= 10
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q21
        - id: q_msd_q21
          kind: Question
          title: "Has he/she ever walked at least 2 steps with one hand held or holding on to something?"
          precondition:
            - predicate: child_age_months >= 10
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -----------------------------------------------------------------
        # Q22: First appears in 13-15m band → minimum age 13 months
        # But Q22 also appears in 4-6m band (Q8-Q22). Let me re-check:
        #   4-6m: Q8-Q22 → Q22 first appears at 4m
        # So Q22 minimum is 4 months, not 13. Q22 spans bands 4-6m through
        # 13-15m. Already covered by C16 gate (child_age_months >= 4).
        # -----------------------------------------------------------------

        # MSD-Q22
        - id: q_msd_q22
          kind: Question
          title: "Has this child ever waved good-bye without help from another person?"
          precondition:
            - predicate: child_age_months >= 4
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -----------------------------------------------------------------
        # MSD-C23: IF AGE 4-6 MONTHS → exit to Relationships
        # Modeled as: Q23+ requires child_age_months >= 7
        # -----------------------------------------------------------------

        # MSD-Q23
        - id: q_msd_q23
          kind: Question
          title: "Has he/she ever shown by his/her behavior that he/she knows the names of common objects when somebody else names them out loud?"
          precondition:
            - predicate: child_age_months >= 7
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q24
        - id: q_msd_q24
          kind: Question
          title: "Has he/she ever shown that he/she wanted something by pointing, pulling, or making pleasant sounds rather than crying or whining?"
          precondition:
            - predicate: child_age_months >= 7
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q25
        - id: q_msd_q25
          kind: Question
          title: "Has he/she ever stood alone on his/her feet for 10 seconds or more without holding on to anything or another person?"
          precondition:
            - predicate: child_age_months >= 7
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q26
        - id: q_msd_q26
          kind: Question
          title: "Has this child ever walked at least 2 steps without holding on to anything or another person?"
          precondition:
            - predicate: child_age_months >= 7
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -----------------------------------------------------------------
        # MSD-C27: IF AGE 7-9 MONTHS → exit to Relationships
        # Modeled as: Q27+ requires child_age_months >= 10
        # -----------------------------------------------------------------

        # MSD-Q27
        - id: q_msd_q27
          kind: Question
          title: "Has he/she ever crawled up at least 2 stairs or steps?"
          precondition:
            - predicate: child_age_months >= 10
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q28
        - id: q_msd_q28
          kind: Question
          title: "Has he/she said 2 recognizable words besides \"mama\" or \"dada\"?"
          precondition:
            - predicate: child_age_months >= 10
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -----------------------------------------------------------------
        # Q29-Q32: First appears in 19-21m band → minimum age 19 months
        # But Q29 also in 19-21m (Q29-Q43). Let me check all bands:
        #   13-15m: Q22-Q36 → Q29 is in this band (min 13m)
        #   19-21m: Q29-Q43 → Q29 is in this band
        # So Q29 first appears in 13-15m band. But C33 gates at 10-12m,
        # meaning children 10-12m exit before Q33. C27 gates at 7-9m.
        # Q29 is in bands: 13-15m, 16-18m, 19-21m, 22-47m.
        # The exit check that controls access to Q29 is C27 (7-9m exit).
        # After C27, children 10m+ continue. Q29 appears starting in
        # 13-15m band (Q22-Q36). But Q27-Q28 are already gated at 10m+.
        # Q29 should be gated at 13m+ based on the 13-15m band being
        # the earliest containing it.
        # Wait: 10-12m band is Q18-Q32, so Q29 IS in the 10-12m band.
        # So Q29 first appears at 10m. Already gated by C27 (>= 10m).
        # -----------------------------------------------------------------

        # MSD-Q29
        - id: q_msd_q29
          kind: Question
          title: "Has this child ever run?"
          precondition:
            - predicate: child_age_months >= 10
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q30
        - id: q_msd_q30
          kind: Question
          title: "Has he/she ever said the name of a familiar object, such as a ball?"
          precondition:
            - predicate: child_age_months >= 10
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q31
        - id: q_msd_q31
          kind: Question
          title: "Has he/she ever made a line with a crayon or pencil?"
          precondition:
            - predicate: child_age_months >= 10
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q32
        - id: q_msd_q32
          kind: Question
          title: "Did he/she ever walk up at least 2 stairs with one hand held or holding the railing?"
          precondition:
            - predicate: child_age_months >= 10
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -----------------------------------------------------------------
        # MSD-C33: IF AGE 10-12 MONTHS → exit to Relationships
        # Modeled as: Q33+ requires child_age_months >= 13
        # -----------------------------------------------------------------

        # MSD-Q33
        - id: q_msd_q33
          kind: Question
          title: "Has he/she ever fed him/herself with a spoon or fork without spilling much?"
          precondition:
            - predicate: child_age_months >= 13
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -----------------------------------------------------------------
        # Q34-Q36: First appears in 22-47m band → minimum age 22 months
        # But check: 13-15m band is Q22-Q36, so Q34 is in 13-15m band.
        # Q34 first appears at 13m. Already gated by C33 (>= 13m).
        # -----------------------------------------------------------------

        # MSD-Q34
        - id: q_msd_q34
          kind: Question
          title: "Has this child ever let someone know, without crying, that wearing wet or soiled pants or diapers bothered him/her?"
          precondition:
            - predicate: child_age_months >= 13
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q35
        - id: q_msd_q35
          kind: Question
          title: "Has he/she ever spoken a partial sentence of 3 words or more?"
          precondition:
            - predicate: child_age_months >= 13
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q36
        - id: q_msd_q36
          kind: Question
          title: "Has he/she ever walked up stairs by him/herself without holding on to a rail?"
          precondition:
            - predicate: child_age_months >= 13
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -----------------------------------------------------------------
        # MSD-C37: IF AGE 13-15 MONTHS → exit to Relationships
        # Modeled as: Q37+ requires child_age_months >= 16
        # -----------------------------------------------------------------

        # MSD-Q37
        - id: q_msd_q37
          kind: Question
          title: "Has he/she ever washed and dried his/her hands without any help except for turning the water on and off?"
          precondition:
            - predicate: child_age_months >= 16
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q38
        - id: q_msd_q38
          kind: Question
          title: "Has he/she ever counted 3 objects correctly?"
          precondition:
            - predicate: child_age_months >= 16
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q39
        - id: q_msd_q39
          kind: Question
          title: "Has he/she ever gone to the toilet alone?"
          precondition:
            - predicate: child_age_months >= 16
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q40
        - id: q_msd_q40
          kind: Question
          title: "Has he/she ever walked upstairs by him/herself with no help, stepping on each step with only one foot?"
          precondition:
            - predicate: child_age_months >= 16
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -----------------------------------------------------------------
        # MSD-C41: IF AGE 16-18 MONTHS → exit to Relationships
        # Modeled as: Q41+ requires child_age_months >= 19
        # -----------------------------------------------------------------

        # MSD-Q41
        - id: q_msd_q41
          kind: Question
          title: "Does he/she know his/her own age and sex?"
          precondition:
            - predicate: child_age_months >= 19
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q42
        - id: q_msd_q42
          kind: Question
          title: "Has he/she ever said the names of at least 4 colors?"
          precondition:
            - predicate: child_age_months >= 19
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q43
        - id: q_msd_q43
          kind: Question
          title: "Has he/she ever pedaled a tricycle at least 10 feet?"
          precondition:
            - predicate: child_age_months >= 19
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -----------------------------------------------------------------
        # MSD-C44: IF AGE 19-21 MONTHS → exit to Relationships
        # Modeled as: Q44+ requires child_age_months >= 22
        # -----------------------------------------------------------------

        # MSD-Q44
        - id: q_msd_q44
          kind: Question
          title: "Has he/she ever done a somersault without help from anybody?"
          precondition:
            - predicate: child_age_months >= 22
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q45
        - id: q_msd_q45
          kind: Question
          title: "Has he/she ever dressed him/herself without any help except for tying shoes and buttoning the backs of dresses?"
          precondition:
            - predicate: child_age_months >= 22
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q46
        - id: q_msd_q46
          kind: Question
          title: "Has he/she ever said his/her first and last name together without someone's help? (Nickname may be used for first name.)"
          precondition:
            - predicate: child_age_months >= 22
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q47
        - id: q_msd_q47
          kind: Question
          title: "Has he/she ever counted out loud up to 10?"
          precondition:
            - predicate: child_age_months >= 22
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q48
        - id: q_msd_q48
          kind: Question
          title: "Has he/she ever drawn a picture of a man or woman with at least 2 parts of the body besides a head?"
          precondition:
            - predicate: child_age_months >= 22
          input:
            control: Switch
            off: "No"
            on: "Yes"

    # ===================================================================
    # SECTION: relationships
    # ===================================================================
    # =========================================================================
    # BLOCK 1: FRIENDSHIPS (REL-I1, REL-Q1 through REL-Q5)
    # =========================================================================
    # REL-C1: IF AGE < 4 → skip entire section. Modeled as block-level
    #         precondition child_age >= 4.
    # REL-I1: Introduction (all age 4+)
    # REL-Q1: Days with friends (all age 4+)
    # REL-C2: IF AGE < 6 → skip to Q6. Q2 has precondition child_age >= 6.
    # REL-Q2: Close friends count. If NONE → skip Q3-Q5.
    # REL-C3/C4: IF AGE < 8 → skip to Q6. Q3-Q5 have precondition child_age >= 8.
    # REL-Q3: Friends known by name
    # REL-Q4: Making new friends
    # REL-Q5: Friends in trouble
    # =========================================================================
    - id: b_rel_friendships
      title: "Relationships - Friendships"
      precondition:
        - predicate: child_age >= 4
      items:
        # REL-I1: Introduction
        - id: q_rel_intro
          kind: Comment
          title: "The next few questions are about this child's relationships with friends, family and others."

        # REL-Q1: Days with friends (all age 4+)
        - id: q_rel_q1
          kind: Question
          title: "About how many days a week does he/she do things with friends?"
          input:
            control: Radio
            labels:
              1: "Never"
              2: "1 day a week"
              3: "2-3 days a week"
              4: "4-5 days a week"
              5: "6-7 days a week"

        # REL-Q2: Close friends (age 6+ only)
        # REL-C2 routing: IF AGE < 6 → skip to Q6
        # If NONE (outcome == 1) → skip Q3-Q5
        - id: q_rel_q2
          kind: Question
          title: "About how many close friends does he/she have?"
          precondition:
            - predicate: child_age >= 6
          input:
            control: Radio
            labels:
              1: "None"
              2: "1"
              3: "2 or 3"
              4: "4 or 5"
              5: "6 or more"

        # REL-Q3: Friends known by name (age 8+ and Q2 not NONE)
        # REL-C3 routing: IF AGE < 8 → skip to Q6
        - id: q_rel_q3
          kind: Question
          title: "How many of his/her close friends do you know by sight and by first and last name?"
          precondition:
            - predicate: child_age >= 8
            - predicate: q_rel_q2.outcome != 1
          input:
            control: Radio
            labels:
              1: "All"
              2: "Most"
              3: "About half"
              4: "Only a few"
              5: "None"

        # REL-Q4: Making new friends (age 8+ and Q2 not NONE)
        # REL-C4 routing: IF AGE < 8 → skip to Q6
        - id: q_rel_q4
          kind: Question
          title: "When it comes to meeting new children and making new friends, is he/she:"
          precondition:
            - predicate: child_age >= 8
            - predicate: q_rel_q2.outcome != 1
          input:
            control: Radio
            labels:
              1: "Somewhat shy"
              2: "About average"
              3: "Very outgoing - makes friends easily"

        # REL-Q5: Friends in trouble (age 8+ and Q2 not NONE)
        - id: q_rel_q5
          kind: Question
          title: "How often does he/she hang around with kids you think are frequently in trouble?"
          precondition:
            - predicate: child_age >= 8
            - predicate: q_rel_q2.outcome != 1
          input:
            control: Radio
            labels:
              1: "Often"
              2: "Sometimes"
              3: "Seldom"
              4: "Never"

    # =========================================================================
    # BLOCK 2: GETTING ALONG (REL-Q6 through REL-Q9)
    # =========================================================================
    # Q6-Q8: Getting along with others (all age 4+, same 5-point scale)
    # REL-C9: IF no siblings → skip Q9. Modeled with has_siblings == 1.
    # REL-Q9: Getting along with siblings (same scale, conditional)
    # =========================================================================
    - id: b_rel_getting_along
      title: "Relationships - Getting Along"
      precondition:
        - predicate: child_age >= 4
      items:
        # REL-Q6, Q7, Q8: Getting along with peers, teachers, parents
        - id: qg_rel_getting_along
          kind: QuestionGroup
          title: "During the past 6 months, how well has the child gotten along with the following:"
          questions:
            - "Other kids, such as friends or classmates (excluding brothers or sisters)?"
            - "His/her teacher(s) at school?"
            - "His/her parent(s)?"
          input:
            control: Radio
            labels:
              1: "Very well, no problems"
              2: "Quite well, hardly any problems"
              3: "Pretty well, occasional problems"
              4: "Not too well, frequent problems"
              5: "Not well at all, constant problems"
              6: "Not applicable"

        # REL-Q9: Getting along with siblings (only if has siblings)
        # REL-C9 routing: IF no siblings → skip
        - id: q_rel_q9
          kind: Question
          title: "During the past 6 months, how well has the child gotten along with his/her brother(s)/sister(s)?"
          precondition:
            - predicate: has_siblings == 1
          input:
            control: Radio
            labels:
              1: "Very well, no problems"
              2: "Quite well, hardly any problems"
              3: "Pretty well, occasional problems"
              4: "Not too well, frequent problems"
              5: "Not well at all, constant problems"
              6: "Not applicable"

    # ===================================================================
    # SECTION: parenting
    # ===================================================================
    # =========================================================================
    # BLOCK 1: POSITIVE INTERACTION (PAR-Q1 through PAR-Q7/Q7A)
    # =========================================================================
    # PAR-C1: IF foster parent → skip entire section.
    #         IF PMK or PMK's spouse → show; OTHERWISE → skip.
    # Modeled as block precondition on is_pmk_or_spouse and not foster.
    # PAR-I1: Intro
    # PAR-Q1-Q6: 6 positive interaction items (5-point frequency)
    # PAR-C7: IF age < 3 → Q7A; ELSE → Q7. Mutually exclusive variants.
    # =========================================================================
    - id: b_par_positive
      title: "Parenting - Positive Interaction"
      precondition:
        - predicate: is_pmk_or_spouse == 1
        - predicate: relationship_to_child != 4
      items:
        # PAR-I1: Intro
        - id: q_par_intro
          kind: Comment
          title: "The following questions have to do with things that the child does and ways that you react to him/her."

        # PAR-Q1 through PAR-Q6: Positive interaction frequency
        # Index mapping:
        #   [0] Q1 - Praise
        #   [1] Q2 - Talk/play together
        #   [2] Q3 - Laugh together
        #   [3] Q4 - Get annoyed
        #   [4] Q5 - Tell bad/not as good
        #   [5] Q6 - Do something special
        - id: qg_par_positive
          kind: QuestionGroup
          title: "How often do you do each of the following with the child?"
          questions:
            - "(1) Praise him/her, by saying something like \"Good for you!\" or \"What a nice thing you did!\" or \"That's good going!\"?"
            - "(2) Talk or play with each other, focusing attention on each other for five minutes or more, just for fun?"
            - "(3) Laugh together?"
            - "(4) Get annoyed with him/her for saying or doing something he/she is not supposed to?"
            - "(5) Tell him/her that he/she is bad or not as good as others?"
            - "(6) Do something special with him/her that he/she enjoys?"
          input:
            control: Radio
            labels:
              1: "Never"
              2: "About once a week or less"
              3: "A few times a week"
              4: "One or two times a day"
              5: "Many times each day"

        # PAR-Q7: Play sports/hobbies (age 3+)
        # PAR-C7: IF age < 3 → Q7A; ELSE → Q7
        - id: q_par_q7
          kind: Question
          title: "How often do you play sports, hobbies or games with him/her?"
          precondition:
            - predicate: child_age >= 3
          input:
            control: Radio
            labels:
              1: "Never"
              2: "About once a week or less"
              3: "A few times a week"
              4: "One or two times a day"
              5: "Many times each day"

        # PAR-Q7A: Play games (age 0-2)
        - id: q_par_q7a
          kind: Question
          title: "How often do you play games with him/her?"
          precondition:
            - predicate: child_age < 3
          input:
            control: Radio
            labels:
              1: "Never"
              2: "About once a week or less"
              3: "A few times a week"
              4: "One or two times a day"
              5: "Many times each day"

    # =========================================================================
    # BLOCK 2: DISCIPLINE EFFECTIVENESS (PAR-Q8 through PAR-Q18)
    # =========================================================================
    # PAR-C8: IF age < 2 → skip to custody section. Modeled as block
    #         precondition child_age >= 2.
    # PAR-I8A: Intro
    # PAR-Q8-Q18: 11 discipline items (5-point proportion scale)
    # =========================================================================
    - id: b_par_discipline
      title: "Parenting - Discipline Effectiveness"
      precondition:
        - predicate: is_pmk_or_spouse == 1
        - predicate: relationship_to_child != 4
        - predicate: child_age >= 2
      items:
        # PAR-I8A: Intro
        - id: q_par_discipline_intro
          kind: Comment
          title: "Now, we know that when parents spend time together with their children, some of the time things go well and some of the time they don't go well. For the following questions, I would like you to tell me what proportion of the time things turn out in different ways."

        # PAR-Q8 through PAR-Q18: Discipline proportion items
        # Index mapping:
        #   [0]  Q8  - Proportion of talk that is praise
        #   [1]  Q9  - Proportion of talk that is disapproval
        #   [2]  Q10 - Make sure commands are followed
        #   [3]  Q11 - Follow through on punishment threats
        #   [4]  Q12 - Gets away with things deserving punishment
        #   [5]  Q13 - Get angry when punishing
        #   [6]  Q14 - Punishment depends on mood
        #   [7]  Q15 - Problems managing in general
        #   [8]  Q16 - Able to get out of punishment
        #   [9]  Q17 - Ignores punishment
        #   [10] Q18 - Discipline repeatedly for same thing
        - id: qg_par_discipline
          kind: QuestionGroup
          title: "For each of the following, please indicate what proportion of the time this happens:"
          questions:
            - "(8) Of all the times that you talk to him/her about his/her behaviour, what proportion is praise?"
            - "(9) Of all the times that you talk to him/her about his/her behaviour, what proportion is disapproval?"
            - "(10) When you give him/her a command or order to do something, what proportion of the time do you make sure that he/she does it?"
            - "(11) If you tell him/her he/she will get punished if he/she doesn't stop doing something, and he/she keeps doing it, how often will you punish him/her?"
            - "(12) How often does he/she get away with things that you feel should have been punished?"
            - "(13) How often do you get angry when you punish him/her?"
            - "(14) How often do you think that the kind of punishment you give him/her depends on your mood?"
            - "(15) How often do you feel you are having problems managing him/her in general?"
            - "(16) How often is he/she able to get out of a punishment when he/she really sets his/her mind to it?"
            - "(17) How often when you discipline him/her, does he/she ignore the punishment?"
            - "(18) How often do you have to discipline him/her repeatedly for the same thing?"
          input:
            control: Radio
            labels:
              1: "Never"
              2: "Less than half the time"
              3: "About half the time"
              4: "More than half the time"
              5: "All the time"

    # =========================================================================
    # BLOCK 3: REACTIONS TO RULE-BREAKING (PAR-Q19 through PAR-Q25)
    # =========================================================================
    # PAR-I19A: Intro
    # PAR-Q19-Q25: 7 reaction items (5-point frequency, Always to Never)
    # Same age >= 2 gate as block 2.
    # =========================================================================
    - id: b_par_reactions
      title: "Parenting - Reactions to Rule-Breaking"
      precondition:
        - predicate: is_pmk_or_spouse == 1
        - predicate: relationship_to_child != 4
        - predicate: child_age >= 2
      items:
        # PAR-I19A: Intro
        - id: q_par_reactions_intro
          kind: Comment
          title: "Just about all children break the rules or do things that they are not supposed to. Also, parents react in different ways. Please tell me how often you do each of the following when the child breaks the rules or does things that he/she is not supposed to."

        # PAR-Q19 through PAR-Q25: Reaction items
        # Index mapping:
        #   [0] Q19 - Tell to stop
        #   [1] Q20 - Ignore / do nothing
        #   [2] Q21 - Raise voice / scold / yell
        #   [3] Q22 - Calmly discuss
        #   [4] Q23 - Use physical punishment
        #   [5] Q24 - Describe acceptable alternatives
        #   [6] Q25 - Take away privileges / put in room
        - id: qg_par_reactions
          kind: QuestionGroup
          title: "How often do you do each of the following when the child breaks the rules or does things that he/she is not supposed to?"
          questions:
            - "(19) Tell him/her to stop?"
            - "(20) Ignore it, do nothing?"
            - "(21) Raise your voice, scold or yell at him/her?"
            - "(22) Calmly discuss the problem?"
            - "(23) Use physical punishment?"
            - "(24) Describe alternative ways of behaving that are acceptable?"
            - "(25) Take away privileges or put in room?"
          input:
            control: Radio
            labels:
              1: "Always"
              2: "Often"
              3: "Sometimes"
              4: "Rarely"
              5: "Never"

    # =========================================================================
    # BLOCK 4: FOOD SECURITY AND EXPOSURE (PAR-Q26A through PAR-Q28)
    # =========================================================================
    # PAR-I26A: Intro
    # PAR-Q26A: Food insecurity (Switch)
    # PAR-Q26B: Frequency (only if Q26A = YES)
    # PAR-Q26C: Coping strategies (Checkbox, only if Q26A = YES)
    # PAR-Q27: TV violence exposure
    # PAR-Q28: Household physical fighting
    # Same age >= 2 gate as blocks 2-3.
    # =========================================================================
    - id: b_par_food_exposure
      title: "Parenting - Food Security and Exposure"
      precondition:
        - predicate: is_pmk_or_spouse == 1
        - predicate: relationship_to_child != 4
        - predicate: child_age >= 2
      items:
        # PAR-I26A: Intro
        - id: q_par_food_intro
          kind: Comment
          title: "Sometimes different situations or circumstances arise which may affect family life. The next few questions are about some of these possible situations."

        # PAR-Q26A: Food insecurity
        - id: q_par_q26a
          kind: Question
          title: "Has he/she ever experienced being hungry because the family has run out of food or money to buy food?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # PAR-Q26B: How often hungry (only if Q26A = YES)
        - id: q_par_q26b
          kind: Question
          title: "How often?"
          precondition:
            - predicate: q_par_q26a.outcome == 1
          input:
            control: Radio
            labels:
              1: "Regularly, end of the month"
              2: "More often than end of each month"
              3: "Every few months"
              4: "Occasionally, not a regular occurrence"

        # PAR-Q26C: Coping strategies (only if Q26A = YES)
        - id: q_par_q26c
          kind: Question
          title: "How do you cope with feeding him/her when this happens? (Mark all that apply.)"
          precondition:
            - predicate: q_par_q26a.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "Parent/guardian skips meals or eats less"
              2: "Children skip meals or eat less"
              4: "Cut down on variety of food family usually eats"
              8: "Seek help from relatives"
              16: "Seek help from friends"
              32: "Seek help from social worker/government office"
              64: "Seek help from food bank (emergency food program)"
              128: "Use school meal program"
              256: "Other"

        # PAR-Q27: TV violence exposure
        - id: q_par_q27
          kind: Question
          title: "How often does he/she see television shows or movies that have a lot of violence in them?"
          input:
            control: Radio
            labels:
              1: "Often"
              2: "Sometimes"
              3: "Seldom"
              4: "Never"

        # PAR-Q28: Household physical fighting
        - id: q_par_q28
          kind: Question
          title: "How often does he/she see adults or teenagers in your house physically fighting, hitting or otherwise trying to hurt others?"
          input:
            control: Radio
            labels:
              1: "Often"
              2: "Sometimes"
              3: "Seldom"
              4: "Never"

    # ===================================================================
    # SECTION: custody
    # ===================================================================
    # =========================================================================
    # BLOCK 1: SECTION GATE AND LIVING ARRANGEMENT AT BIRTH
    # =========================================================================
    # CUS-C1: Foster parents skip entire section; PMK/spouse continue.
    # CUS-I1: Intro
    # CUS-Q1A: Did child live with you at birth?
    # CUS-Q1B: Age child started living with you
    # CUS-Q1B2: Age in months (if < 1 year)
    # CUS-Q1C: Reason child didn't live with you from birth
    # CUS-Q1D: Siblings not in household?
    # CUS-Q1E: How many siblings outside household?
    # CUS-Q1F: Age of youngest sibling
    # CUS-Q1G: Age of oldest sibling (if >1 sibling)
    # =========================================================================
    - id: b_living_arrangement
      title: "Living Arrangement at Birth"
      precondition:
        - predicate: relationship_to_child != 4
      items:
        # CUS-I1: Section intro
        - id: q_cus_i1
          kind: Comment
          title: "I would now like to ask you some questions about the family history of the child."

        # CUS-Q1A: Did child live with you at birth?
        - id: q_cus_q1a
          kind: Question
          title: "Did the child live with you when he/she was born?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
          codeBlock: |
            if q_cus_q1a.outcome == 1:
                child_lived_with_respondent = 1

        # CUS-Q1B: Age started living with respondent
        # Shown only when child did NOT live with respondent at birth
        - id: q_cus_q1b
          kind: Question
          title: "At what age did the child start living with you?"
          precondition:
            - predicate: q_cus_q1a.outcome == 2
          input:
            control: Dropdown
            labels:
              1: "Less than one year old"
              2: "One year old"
              3: "Two years old"
              4: "Three years old"
              5: "Four years old"
              6: "Five years old"
              7: "Six years old"
              8: "Seven years old"
              9: "Eight years old"
              10: "Nine years old"
              11: "Ten years old"
              12: "Eleven years old"

        # CUS-Q1B2: Age in months if less than one year
        - id: q_cus_q1b2
          kind: Question
          title: "Enter the age in months."
          precondition:
            - predicate: q_cus_q1a.outcome == 2
            - predicate: q_cus_q1b.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 11
            right: "months"

        # CUS-Q1C: Reason child didn't live with respondent from birth
        - id: q_cus_q1c
          kind: Question
          title: "What was the reason the child did not live with you right from birth?"
          precondition:
            - predicate: q_cus_q1a.outcome == 2
          input:
            control: Dropdown
            labels:
              1: "You have adopted him/her"
              2: "He/she is a stepchild"
              3: "He/she was put in your care by a child welfare agency (foster care)"
              4: "He/she was put in your care by another type of agency"
              5: "He/she was sick and had to remain in a hospital or other institution"
              6: "You had to leave him/her in the care of someone else for a while"
              7: "Child was in care of a child welfare agency (foster care) for a time"
              8: "Other"

        # CUS-Q1D: Siblings not regularly in household?
        - id: q_cus_q1d
          kind: Question
          title: "Does the child have any brothers or sisters who do not regularly live in this household, excluding step and half brothers and sisters?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # CUS-Q1E: How many siblings outside household
        - id: q_cus_q1e
          kind: Question
          title: "How many?"
          precondition:
            - predicate: q_cus_q1d.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 20

        # CUS-Q1F: Age of youngest sibling
        - id: q_cus_q1f
          kind: Question
          title: "What is the age of the youngest one? (Enter age in years. If less than one year, enter 0.)"
          precondition:
            - predicate: q_cus_q1d.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 30
            right: "years"

        # CUS-Q1G: Age of oldest sibling (if more than one)
        - id: q_cus_q1g
          kind: Question
          title: "What is the age of the oldest one? (Enter age in years. If less than one year, enter 0.)"
          precondition:
            - predicate: q_cus_q1d.outcome == 1
            - predicate: q_cus_q1e.outcome >= 2
          input:
            control: Editbox
            min: 0
            max: 30
            right: "years"

    # =========================================================================
    # BLOCK 2: PARENTS' UNION DETAILS (Q2-Q3D)
    # =========================================================================
    # CUS-I2: Interviewer note about adoption wording
    # CUS-Q2: Were parents living together at birth?
    # CUS-Q3A: Type of union (married, common-law, etc.)
    # CUS-Q3B: Were they living together before marriage?
    # CUS-Q3C: Date of marriage
    # CUS-Q3D: Since when living together?
    # =========================================================================
    - id: b_parents_union
      title: "Parents' Union at Birth"
      precondition:
        - predicate: relationship_to_child != 4
      items:
        # CUS-I2: Interviewer instruction about adoption wording
        - id: q_cus_i2
          kind: Comment
          title: "If adopted, consider adoptive parents as mother and father for the rest of this section. In questions referring to the time of birth, substitute time of adoption."

        # CUS-Q2: Were parents living together at birth?
        - id: q_cus_q2
          kind: Question
          title: "When the child was born/adopted, were his/her parents (biological/adoptive) living together?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
          codeBlock: |
            if q_cus_q2.outcome == 1:
                parents_together = 1

        # CUS-Q3A: Type of union at birth
        # Only if parents WERE together
        - id: q_cus_q3a
          kind: Question
          title: "When the child was born/adopted, were his/her parents married, were they living together in a common-law relationship, or were they living together and eventually got married?"
          precondition:
            - predicate: q_cus_q2.outcome == 1
          input:
            control: Radio
            labels:
              1: "Married"
              2: "Common-law"
              3: "Common-law but married later"
          codeBlock: |
            if q_cus_q3a.outcome in [1, 3]:
                parents_were_married = 1

        # CUS-Q3B: Had they been living together before getting married?
        # Only if married (Q3A=1)
        - id: q_cus_q3b
          kind: Question
          title: "Had they been living together before getting married?"
          precondition:
            - predicate: q_cus_q2.outcome == 1
            - predicate: q_cus_q3a.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # CUS-Q3C: Date of marriage
        # Shown if common-law but married later (Q3A=3)
        - id: q_cus_q3c
          kind: Question
          title: "What year were they married?"
          precondition:
            - predicate: q_cus_q2.outcome == 1
            - predicate: q_cus_q3a.outcome == 3
          input:
            control: Editbox
            min: 1950
            max: 2010
            right: "year"

        # CUS-Q3D: Since when living together?
        # Shown if common-law (Q3A=2), or common-law married later (Q3A=3),
        # or married but lived together first (Q3A=1, Q3B=1)
        - id: q_cus_q3d
          kind: Question
          title: "Approximately since when had they been living together? (Enter year.)"
          precondition:
            - predicate: q_cus_q2.outcome == 1
            - predicate: q_cus_q3a.outcome == 2 or q_cus_q3a.outcome == 3 or (q_cus_q3a.outcome == 1 and q_cus_q3b.outcome == 1)
          input:
            control: Editbox
            min: 1950
            max: 2010
            right: "year"

    # =========================================================================
    # BLOCK 3: PARENTS NOT TOGETHER PATH (Q4-Q5F)
    # =========================================================================
    # CUS-Q4: Who did child live with?
    # CUS-Q5A: Have parents ever lived together?
    # CUS-Q5B: Before or after birth?
    # CUS-Q5C: Were parents ever married?
    # CUS-Q5D: When did they marry?
    # CUS-Q5E: Since when had parents stopped living together at birth?
    # CUS-Q5F: Steady relationship at birth?
    # =========================================================================
    - id: b_parents_not_together
      title: "Parents Not Living Together"
      precondition:
        - predicate: relationship_to_child != 4
        - predicate: q_cus_q2.outcome == 2
      items:
        # CUS-Q4: Who did child live with?
        - id: q_cus_q4
          kind: Question
          title: "Did the child live with his/her:"
          input:
            control: Radio
            labels:
              1: "Mother alone"
              2: "Father alone"
              3: "Mother and other"
              4: "Father and other"
              5: "Other"

        # CUS-Q5A: Have parents ever lived together?
        - id: q_cus_q5a
          kind: Question
          title: "Have the child's parents ever lived together as a couple?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
          codeBlock: |
            if q_cus_q5a.outcome == 1:
                parents_lived_together_ever = 1

        # CUS-Q5B: Before or after birth?
        - id: q_cus_q5b
          kind: Question
          title: "Was that before or after his/her birth?"
          precondition:
            - predicate: q_cus_q5a.outcome == 1
          input:
            control: Radio
            labels:
              1: "Before"
              2: "After"
              3: "Both before and after"

        # CUS-Q5C: Were parents ever married?
        - id: q_cus_q5c
          kind: Question
          title: "Were the child's parents ever married?"
          precondition:
            - predicate: q_cus_q5a.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
          codeBlock: |
            if q_cus_q5c.outcome == 1:
                parents_were_married = 1

        # CUS-Q5D: When did they marry?
        - id: q_cus_q5d
          kind: Question
          title: "When did they marry? (Enter year.)"
          precondition:
            - predicate: q_cus_q5a.outcome == 1
            - predicate: q_cus_q5c.outcome == 1
          input:
            control: Editbox
            min: 1950
            max: 2010
            right: "year"

        # CUS-Q5E: Since when had parents stopped living together?
        # Shown if parents lived together BEFORE birth (Q5B=1 or Q5B=3)
        # CUS-C5E: IF "AFTER" (Q5B=2) -> skip to Q5F
        - id: q_cus_q5e
          kind: Question
          title: "At the time the child was born, since when had his/her parents stopped living together? (Enter year.)"
          precondition:
            - predicate: q_cus_q5a.outcome == 1
            - predicate: q_cus_q5b.outcome in [1, 3]
          input:
            control: Editbox
            min: 1950
            max: 2010
            right: "year"

        # CUS-Q5F: Steady relationship at time of birth?
        - id: q_cus_q5f
          kind: Question
          title: "Without living together, did the child's parents have a steady relationship at the time of his/her birth?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

    # =========================================================================
    # BLOCK 4: MOTHER'S PRIOR RELATIONSHIPS (Q6A-Q6I)
    # =========================================================================
    # Reached from:
    #   - Parents together path (after Q3D) -> Q6A
    #   - Parents not together, but lived together before (Q5A=1) -> Q6A via routing
    #
    # CUS-Q6A: Mother's prior unions before father?
    # CUS-Q6B: How many prior unions?
    # CUS-Q6C: Prior unions before child's birth?
    # CUS-Q6D: How many prior unions before birth?
    # CUS-Q6E: Mother's prior children before father?
    # CUS-Q6F: How many prior children?
    # CUS-Q6G: Did prior children live in household?
    # CUS-Q6H: How many children did mother have before this child?
    # CUS-Q6I: Did those children live in household?
    # =========================================================================
    - id: b_mother_prior
      title: "Mother's Prior Relationships"
      precondition:
        - predicate: relationship_to_child != 4
        - predicate: q_cus_q2.outcome == 1 or (q_cus_q2.outcome == 2 and q_cus_q5a.outcome == 1)
      items:
        # CUS-Q6A: Mother's prior unions
        - id: q_cus_q6a
          kind: Question
          title: "Had the child's mother been in any common-law relationships or been married before the union with the child's father? (Select all that apply.)"
          input:
            control: Checkbox
            labels:
              1: "Yes, common-law"
              2: "Yes, marriage"
              4: "Yes, common-law which resulted in marriage"
              8: "No"

        # CUS-Q6B: How many prior unions?
        # Shown if mother had prior unions (not "No")
        - id: q_cus_q6b
          kind: Question
          title: "How many times?"
          precondition:
            - predicate: q_cus_q6a.outcome % 8 >= 1
          input:
            control: Editbox
            min: 1
            max: 10

        # CUS-Q6C: Prior unions before child's birth?
        - id: q_cus_q6c
          kind: Question
          title: "Before the child's birth, had his/her mother been in any common-law relationships or been married to a person other than the child's father? (Select all that apply.)"
          precondition:
            - predicate: q_cus_q6a.outcome % 8 >= 1
          input:
            control: Checkbox
            labels:
              1: "Yes, common-law"
              2: "Yes, marriage"
              4: "Yes, common-law which resulted in marriage"
              8: "No"

        # CUS-Q6D: How many prior unions before birth?
        - id: q_cus_q6d
          kind: Question
          title: "How many times?"
          precondition:
            - predicate: q_cus_q6a.outcome % 8 >= 1
            - predicate: q_cus_q6c.outcome % 8 >= 1
          input:
            control: Editbox
            min: 1
            max: 10

        # CUS-Q6E: Mother's prior children before father?
        # Shown if mother had NO prior unions (Q6A has "No" bit set => Q6A % 16 >= 8)
        # OR always shown after Q6D path completes
        - id: q_cus_q6e
          kind: Question
          title: "Did the child's mother have any children before entering into union with the child's father?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # CUS-Q6F: How many prior children?
        - id: q_cus_q6f
          kind: Question
          title: "How many?"
          precondition:
            - predicate: q_cus_q6e.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 20

        # CUS-Q6G: Did prior children live in household?
        - id: q_cus_q6g
          kind: Question
          title: "Did that child/any of those children live at least part time in the household when the child was born?"
          precondition:
            - predicate: q_cus_q6e.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes, all of them full-time"
              2: "Yes, all of them part-time"
              3: "Yes, some of them full-time"
              4: "Yes, some of them part-time"
              5: "No, none of them"

        # CUS-Q6H: How many children did mother have before this child?
        # Shown if mother had prior unions before birth (Q6C has selections)
        - id: q_cus_q6h
          kind: Question
          title: "How many children did the child's mother have before the child?"
          precondition:
            - predicate: q_cus_q6a.outcome % 8 >= 1
            - predicate: q_cus_q6c.outcome % 8 >= 1
          input:
            control: Editbox
            min: 0
            max: 20

        # CUS-Q6I: Did those children live in household?
        # CUS-C6I: IF Q6H=0 AND Q5A=YES -> go to Q7C; IF Q6H=0 AND Q5A=NO -> go to Q8A
        # So Q6I shown only if Q6H > 0
        - id: q_cus_q6i
          kind: Question
          title: "Did that child/any of those children live at least part time in the household when the child was born?"
          precondition:
            - predicate: q_cus_q6a.outcome % 8 >= 1
            - predicate: q_cus_q6c.outcome % 8 >= 1
            - predicate: q_cus_q6h.outcome >= 1
          input:
            control: Radio
            labels:
              1: "Yes, all of them full-time"
              2: "Yes, all of them part-time"
              3: "Yes, some of them full-time"
              4: "Yes, some of them part-time"
              5: "No, none of them"

    # =========================================================================
    # BLOCK 5: FATHER'S PRIOR RELATIONSHIPS (Q7A-Q7I)
    # =========================================================================
    # CUS-C7A: IF Q5A=YES -> Q7C (skip Q7A/Q7B). IF Q5A=NO -> Q8A.
    # When parents were together (Q2=1): Q7A is always shown.
    # When parents not together but lived together (Q5A=1): skip to Q7C.
    # When parents never lived together (Q5A=2): skip entire block -> Q8A.
    # =========================================================================
    - id: b_father_prior
      title: "Father's Prior Relationships"
      precondition:
        - predicate: relationship_to_child != 4
        - predicate: q_cus_q2.outcome == 1 or (q_cus_q2.outcome == 2 and q_cus_q5a.outcome == 1)
      items:
        # CUS-Q7A: Father's prior unions
        # Only shown when parents were together at birth (Q2=1)
        # When Q2=2 and Q5A=1, routing skips to Q7C
        - id: q_cus_q7a
          kind: Question
          title: "Had the child's father been in any common-law relationships or been married before the union with the child's mother? (Select all that apply.)"
          precondition:
            - predicate: q_cus_q2.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "Yes, common-law"
              2: "Yes, marriage"
              4: "Yes, common-law which resulted in marriage"
              8: "No"

        # CUS-Q7B: How many prior unions?
        - id: q_cus_q7b
          kind: Question
          title: "How many times?"
          precondition:
            - predicate: q_cus_q2.outcome == 1
            - predicate: q_cus_q7a.outcome % 8 >= 1
          input:
            control: Editbox
            min: 1
            max: 10

        # CUS-Q7C: Father's prior unions before child's birth
        # Shown from either:
        #   - Parents together (Q2=1) after Q7A/Q7B path
        #   - Parents not together but lived together (Q2=2, Q5A=1) -> jump here
        - id: q_cus_q7c
          kind: Question
          title: "Before the child's birth, had his/her father been in any common-law relationships or been married to a person other than the child's mother? (Select all that apply.)"
          input:
            control: Checkbox
            labels:
              1: "Yes, common-law"
              2: "Yes, marriage"
              4: "Yes, common-law which resulted in marriage"
              8: "No"

        # CUS-Q7D: How many prior unions before birth?
        - id: q_cus_q7d
          kind: Question
          title: "How many times?"
          precondition:
            - predicate: q_cus_q7c.outcome % 8 >= 1
          input:
            control: Editbox
            min: 1
            max: 10

        # CUS-Q7E: Father's prior children before mother?
        # Only shown when parents together (Q2=1); when Q2=2 routing already handled
        - id: q_cus_q7e
          kind: Question
          title: "Did the child's father have any children before entering into union with the child's mother?"
          precondition:
            - predicate: q_cus_q2.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # CUS-Q7F: How many prior children?
        - id: q_cus_q7f
          kind: Question
          title: "How many?"
          precondition:
            - predicate: q_cus_q2.outcome == 1
            - predicate: q_cus_q7e.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 20

        # CUS-Q7G: Did prior children live in household?
        - id: q_cus_q7g
          kind: Question
          title: "Did that child/any of those children live at least part time in the household when the child was born?"
          precondition:
            - predicate: q_cus_q2.outcome == 1
            - predicate: q_cus_q7e.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes, all of them full-time"
              2: "Yes, all of them part-time"
              3: "Yes, some of them full-time"
              4: "Yes, some of them part-time"
              5: "No, none of them"

        # CUS-Q7H: How many children did father have before this child?
        - id: q_cus_q7h
          kind: Question
          title: "How many children did the child's father have before the child?"
          precondition:
            - predicate: q_cus_q7c.outcome % 8 >= 1
          input:
            control: Editbox
            min: 0
            max: 20

        # CUS-Q7I: Did those children live in household?
        # CUS-C7I: IF Q7H=0 -> Q8A. Otherwise Q7I.
        - id: q_cus_q7i
          kind: Question
          title: "Did that child/any of those children live at least part time in the household when the child was born?"
          precondition:
            - predicate: q_cus_q7c.outcome % 8 >= 1
            - predicate: q_cus_q7h.outcome >= 1
          input:
            control: Radio
            labels:
              1: "Yes, all of them full-time"
              2: "Yes, all of them part-time"
              3: "Yes, some of them full-time"
              4: "Yes, some of them part-time"
              5: "No, none of them"

    # =========================================================================
    # BLOCK 6: NON-RESIDENT PARENT CONTACT (Q8A-Q8E)
    # =========================================================================
    # Reached when parents were NOT together at birth (Q2=2).
    # CUS-Q8A: Father on birth certificate?
    # CUS-Q8B: Initial contact type with other parent
    # CUS-Q8C: How many times has contact changed?
    # CUS-Q8D: Age at last change
    # CUS-Q8E: Current contact type
    # =========================================================================
    - id: b_nonresident_contact
      title: "Non-Resident Parent Contact"
      precondition:
        - predicate: relationship_to_child != 4
        - predicate: q_cus_q2.outcome == 2
      items:
        # CUS-Q8A: Father on birth certificate?
        - id: q_cus_q8a
          kind: Question
          title: "Was the child's father declared on his/her birth certificate?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # CUS-Q8B: Initial contact type with other parent
        - id: q_cus_q8b
          kind: Question
          title: "What kind of contact did the child first have with his/her other parent?"
          input:
            control: Dropdown
            labels:
              1: "Sharing living arrangements on an equal time basis"
              2: "Sharing living arrangements with most time with mother"
              3: "Sharing living arrangements with most time with father"
              4: "Regular visiting"
              5: "Irregular visiting"
              6: "Telephone or letter contact only"
              7: "No contact at all"
              8: "Other"

        # CUS-Q8C: How many times has contact changed?
        - id: q_cus_q8c
          kind: Question
          title: "How many times would you say this situation has changed over time?"
          input:
            control: Radio
            labels:
              1: "None"
              2: "Once"
              3: "Twice"
              4: "Three times"
              5: "Four or more times"

        # CUS-Q8D: Age at last change
        - id: q_cus_q8d
          kind: Question
          title: "How old was the child when the last change happened? (Enter age in years. If less than one year, enter 0.)"
          precondition:
            - predicate: q_cus_q8c.outcome >= 2
          input:
            control: Editbox
            min: 0
            max: 18
            right: "years"

        # CUS-Q8E: Current contact type
        # Shown if contact changed (Q8C >= 2) or if Q8B was DK (modeled: always after Q8D path)
        - id: q_cus_q8e
          kind: Question
          title: "What type of contact does the child now have with his/her other parent?"
          precondition:
            - predicate: q_cus_q8c.outcome >= 2 or q_cus_q8c.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Sharing living arrangements on an equal time basis"
              2: "Sharing living arrangements with most time with mother"
              3: "Sharing living arrangements with most time with father"
              4: "Regular visiting"
              5: "Irregular visiting"
              6: "Telephone or letter contact only"
              7: "Both parents now living with the child"
              8: "No contact at all"
              9: "Other"

    # =========================================================================
    # BLOCK 7: PARENT DEATH (Q9A-Q9D)
    # =========================================================================
    # CUS-Q9A: Has a parent died? (for parents-together path)
    # CUS-Q9B: Has a parent died? (for parents-not-together path)
    # CUS-Q9C: When did it happen?
    # CUS-Q9D: With whom did child live?
    # =========================================================================
    - id: b_parent_death
      title: "Parent Death"
      precondition:
        - predicate: relationship_to_child != 4
      items:
        # CUS-Q9A: Has a parent died? (parents together at birth)
        # Reached from parents-together path (Q2=1) via mother/father prior blocks
        - id: q_cus_q9a
          kind: Question
          title: "Between the child's birth and now, has one of his/her parents died?"
          precondition:
            - predicate: q_cus_q2.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes, mother"
              2: "Yes, father"
              3: "Yes, both"
              4: "No"
          codeBlock: |
            if q_cus_q9a.outcome in [1, 2, 3]:
                parent_died = q_cus_q9a.outcome
            elif q_cus_q9a.outcome == 4:
                parent_died = 4

        # CUS-Q9B: Has a parent died? (parents not together, after non-resident contact)
        - id: q_cus_q9b
          kind: Question
          title: "Has one of the child's parents died?"
          precondition:
            - predicate: q_cus_q2.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes, mother"
              2: "Yes, father"
              3: "Yes, both"
              4: "No"
          codeBlock: |
            if q_cus_q9b.outcome in [1, 2, 3]:
                parent_died = q_cus_q9b.outcome
            elif q_cus_q9b.outcome == 4:
                parent_died = 4

        # CUS-Q9C: When did it happen?
        - id: q_cus_q9c
          kind: Question
          title: "When did it happen? (If both, enter date of first death. Enter year.)"
          precondition:
            - predicate: parent_died in [1, 2, 3]
          input:
            control: Editbox
            min: 1950
            max: 2010
            right: "year"

        # CUS-Q9D: With whom did child live?
        - id: q_cus_q9d
          kind: Question
          title: "With whom did the child go on living at the time it happened?"
          precondition:
            - predicate: parent_died in [1, 2, 3]
          input:
            control: Radio
            labels:
              1: "Mother"
              2: "Father"
              3: "Other"

    # =========================================================================
    # BLOCK 8: SEPARATION DETAILS (Q10A-Q11H)
    # =========================================================================
    # CUS-C10 routing (simplified):
    #   - Both parents died -> exit section
    #   - Parents not together (Q2=2) and never lived together (Q5A=2) -> skip to new unions
    #   - One parent died and parents had lived together -> Q10A
    #   - Otherwise -> Q10B
    #
    # CUS-Q10A: Prior to death, did parents break up?
    # CUS-Q10B: Since birth, did parents break up?
    # CUS-Q11A-Q11H: Separation/divorce details, custody orders, support
    # =========================================================================
    - id: b_separation
      title: "Separation Details"
      precondition:
        - predicate: relationship_to_child != 4
        - predicate: parent_died != 3
      items:
        # CUS-Q10A: Prior to death, did parents break up?
        # Shown when one parent died and parents had lived together
        - id: q_cus_q10a
          kind: Question
          title: "Prior to the death of the child's parent, did his/her parents break up and stop living together?"
          precondition:
            - predicate: parent_died in [1, 2]
            - predicate: q_cus_q2.outcome == 1 or parents_lived_together_ever == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # CUS-Q10B: Since birth, did parents break up?
        # Shown when no parent died (parent_died=4) and parents were together (Q2=1)
        - id: q_cus_q10b
          kind: Question
          title: "Since the child's birth, did his/her parents break up and stop living together?"
          precondition:
            - predicate: parent_died == 4
            - predicate: q_cus_q2.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
          codeBlock: |
            if q_cus_q10b.outcome == 1:
                parents_separated = 1

        # CUS-Q11A: When did the separation happen?
        # Shown if parents separated (Q10A=1 or Q10B=1)
        - id: q_cus_q11a
          kind: Question
          title: "When did the separation happen? (Enter year.)"
          precondition:
            - predicate: q_cus_q10a.outcome == 1 or q_cus_q10b.outcome == 1
          input:
            control: Editbox
            min: 1950
            max: 2010
            right: "year"

        # CUS-Q11B: Did parents eventually divorce?
        # CUS-C11B: Shown if parents were married
        - id: q_cus_q11b
          kind: Question
          title: "Did the child's parents eventually divorce?"
          precondition:
            - predicate: q_cus_q10a.outcome == 1 or q_cus_q10b.outcome == 1
            - predicate: parents_were_married == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # CUS-Q11C: When was the divorce pronounced?
        - id: q_cus_q11c
          kind: Question
          title: "When was the divorce pronounced? (Enter year.)"
          precondition:
            - predicate: q_cus_q10a.outcome == 1 or q_cus_q10b.outcome == 1
            - predicate: parents_were_married == 1
            - predicate: q_cus_q11b.outcome == 1
          input:
            control: Editbox
            min: 1950
            max: 2010
            right: "year"

        # CUS-Q11D: Court order concerning custody?
        - id: q_cus_q11d
          kind: Question
          title: "Was there a court order concerning the child's custody when his/her parents separated or divorced?"
          precondition:
            - predicate: q_cus_q10a.outcome == 1 or q_cus_q10b.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "Yes, in progress"
              3: "No"

        # CUS-Q11E: What did the court order?
        - id: q_cus_q11e
          kind: Question
          title: "Did the court order him/her to be put into:"
          precondition:
            - predicate: q_cus_q10a.outcome == 1 or q_cus_q10b.outcome == 1
            - predicate: q_cus_q11d.outcome == 1
          input:
            control: Radio
            labels:
              1: "Sole custody of mother"
              2: "Sole custody of father"
              3: "Shared physical custody of both parents"
              4: "Other"
          codeBlock: |
            if q_cus_q11e.outcome == 1:
                custody_type = 1
            elif q_cus_q11e.outcome == 2:
                custody_type = 2
            elif q_cus_q11e.outcome == 3:
                custody_type = 3

        # CUS-Q11F: Support/maintenance agreement type
        - id: q_cus_q11f
          kind: Question
          title: "What type of agreement was made regarding support/maintenance payments when the child's parents separated or divorced?"
          precondition:
            - predicate: q_cus_q10a.outcome == 1 or q_cus_q10b.outcome == 1
          input:
            control: Radio
            labels:
              1: "None"
              2: "Private agreement between spouses"
              3: "Court-ordered agreement in progress"
              4: "Court-ordered agreement"

        # CUS-Q11G: For child support, spousal support, or both?
        - id: q_cus_q11g
          kind: Question
          title: "Was this:"
          precondition:
            - predicate: q_cus_q10a.outcome == 1 or q_cus_q10b.outcome == 1
            - predicate: q_cus_q11f.outcome == 4
          input:
            control: Radio
            labels:
              1: "For child support only"
              2: "For spousal support only"
              3: "For both"

        # CUS-Q11H: How regular have payments been?
        - id: q_cus_q11h
          kind: Question
          title: "How regular have the maintenance support payments been?"
          precondition:
            - predicate: q_cus_q10a.outcome == 1 or q_cus_q10b.outcome == 1
            - predicate: q_cus_q11f.outcome == 4
          input:
            control: Dropdown
            labels:
              1: "Regular and on time"
              2: "Regular but late sometimes"
              3: "Irregular"
              4: "No payments for the last 6 months"
              5: "No payments for the last year"
              6: "No payments for the last few years"
              7: "Payments never been received"
              8: "Payments stopped due to a change in circumstances"

    # =========================================================================
    # BLOCK 9: POST-SEPARATION CUSTODY AND LIVING ARRANGEMENTS (Q12-Q18B)
    # =========================================================================
    # CUS-C12: IF Q11E=1 or 2 (sole custody) -> Q13. Otherwise -> Q12.
    # CUS-Q12: With whom did child live at separation?
    # CUS-Q13: Contact type with other parent
    # CUS-Q14: Times contact changed
    # CUS-Q15A: Current contact type
    # CUS-Q15B: Time at other parent's home
    # CUS-Q16: Time at other parent's home (shared custody)
    # CUS-Q17: Times living arrangements changed
    # CUS-Q18A: Current living arrangement
    # CUS-Q18B: Current contact type (if visits only)
    # =========================================================================
    - id: b_post_separation_custody
      title: "Post-Separation Custody"
      precondition:
        - predicate: relationship_to_child != 4
        - predicate: q_cus_q10a.outcome == 1 or q_cus_q10b.outcome == 1
      items:
        # CUS-Q12: With whom did child live at separation?
        # CUS-C12: Shown only if NOT sole custody (Q11E != 1 and Q11E != 2)
        # or if no court order (Q11D != 1)
        - id: q_cus_q12
          kind: Question
          title: "With whom did the child go on living at the time of the separation?"
          precondition:
            - predicate: custody_type != 1 and custody_type != 2
          input:
            control: Radio
            labels:
              1: "Mother only"
              2: "Father only"
              3: "Shared time basis, mostly mother"
              4: "Shared time basis, mostly father"
              5: "Equally shared time mother and father"
              6: "Other"

        # CUS-Q13: Initial contact type with other parent
        # Shown when child in sole custody (Q12=1 or 2, or Q11E=1 or 2)
        - id: q_cus_q13
          kind: Question
          title: "At that time, what type of contact did the child have with his/her other parent?"
          precondition:
            - predicate: custody_type in [1, 2] or q_cus_q12.outcome in [1, 2]
          input:
            control: Dropdown
            labels:
              1: "Regular visiting every week"
              2: "Regular visiting every two weeks"
              3: "Regular visiting monthly"
              4: "Irregular visiting on holidays only"
              5: "Irregular visiting without set pattern"
              6: "Telephone or letter contact only"
              7: "No contact at all"
              8: "Other"

        # CUS-Q14: Times contact has changed
        - id: q_cus_q14
          kind: Question
          title: "Since then, how many times has the type of contact changed?"
          precondition:
            - predicate: custody_type in [1, 2] or q_cus_q12.outcome in [1, 2]
          input:
            control: Radio
            labels:
              1: "None"
              2: "Once"
              3: "Twice"
              4: "Three times"
              5: "Four or more times"

        # CUS-Q15A: Current contact type with other parent
        # CUS-C15A: If a parent died -> skip to Q19A. Otherwise show.
        # Shown if contact changed (Q14 >= 2) and no parent died
        - id: q_cus_q15a
          kind: Question
          title: "What type of contact does the child now have with his/her other parent?"
          precondition:
            - predicate: custody_type in [1, 2] or q_cus_q12.outcome in [1, 2]
            - predicate: q_cus_q14.outcome >= 2
            - predicate: parent_died == 4
          input:
            control: Dropdown
            labels:
              1: "Regular visiting every week"
              2: "Regular visiting every two weeks"
              3: "Regular visiting monthly"
              4: "Irregular visiting on holidays only"
              5: "Irregular visiting without set pattern"
              6: "Telephone or letter contact only"
              7: "Lost contact completely"
              8: "Child now shares living arrangements with other parent"
              9: "Parents now living together again"
              10: "Child now lives solely with other parent"

        # CUS-Q15B: Time at other parent's home
        # Shown if Q15A=8 (shares living arrangements with other parent)
        - id: q_cus_q15b
          kind: Question
          title: "How much time does the child live at his/her other parent's home?"
          precondition:
            - predicate: custody_type in [1, 2] or q_cus_q12.outcome in [1, 2]
            - predicate: q_cus_q14.outcome >= 2
            - predicate: parent_died == 4
            - predicate: q_cus_q15a.outcome == 8
          input:
            control: Dropdown
            labels:
              1: "On weekdays, not weekends"
              2: "Every other night"
              3: "One week out of two"
              4: "Two weeks alternately"
              5: "Every weekend"
              6: "One weekend out of two"
              7: "Less than two days every month"
              8: "Some holidays"
              9: "Never"
              10: "All the time"
              11: "Other"

        # CUS-Q16: Time at other parent's home (shared custody path)
        # Shown if shared custody arrangement (Q12=3, 4, or 5)
        - id: q_cus_q16
          kind: Question
          title: "At that time, how much time did the child live at his/her other parent's home?"
          precondition:
            - predicate: q_cus_q12.outcome in [3, 4, 5]
          input:
            control: Dropdown
            labels:
              1: "On weekdays, not weekends"
              2: "Every other night"
              3: "One week out of two"
              4: "Two weeks alternately"
              5: "Every weekend"
              6: "One weekend out of two"
              7: "Less than two days every month"
              8: "Some holidays"
              9: "Other"

        # CUS-Q17: Times living arrangements have changed
        # Shown if child was in "other" arrangement (Q12=6)
        - id: q_cus_q17
          kind: Question
          title: "How many times would you say these living arrangements have changed over time?"
          precondition:
            - predicate: q_cus_q12.outcome == 6 or q_cus_q12.outcome in [3, 4, 5]
          input:
            control: Radio
            labels:
              1: "None"
              2: "Once"
              3: "Twice"
              4: "Three times"
              5: "Four or more times"

        # CUS-Q18A: Current living arrangement
        # CUS-C18A: If parent died -> skip to Q19A. Otherwise show.
        # Shown if arrangements changed (Q17 >= 2) and no parent died
        - id: q_cus_q18a
          kind: Question
          title: "Currently, how much time does the child live at his/her other parent's home?"
          precondition:
            - predicate: q_cus_q12.outcome in [3, 4, 5, 6]
            - predicate: q_cus_q17.outcome >= 2
            - predicate: parent_died == 4
          input:
            control: Dropdown
            labels:
              1: "On weekdays, not weekends"
              2: "Every other night"
              3: "One week out of two"
              4: "Two weeks alternately"
              5: "Every weekend"
              6: "One weekend out of two"
              7: "Less than two days every month"
              8: "Some holidays"
              9: "Visits or letter or telephone calls only"
              10: "No contact"
              11: "All the time"
              12: "Parents now living together again"
              13: "Other"

        # CUS-Q18B: Current contact type (if visits/calls only)
        # CUS-C18B: IF Q18A=12 -> Q19C. IF Q18A=9 -> Q18B. Otherwise -> Q19A.
        - id: q_cus_q18b
          kind: Question
          title: "Which type of contact does the child now have with his/her other parent?"
          precondition:
            - predicate: q_cus_q12.outcome in [3, 4, 5, 6]
            - predicate: q_cus_q17.outcome >= 2
            - predicate: parent_died == 4
            - predicate: q_cus_q18a.outcome == 9
          input:
            control: Dropdown
            labels:
              1: "Regular visiting every week"
              2: "Regular visiting every two weeks"
              3: "Regular visiting monthly"
              4: "Irregular visiting on holidays only"
              5: "Irregular visiting without set pattern"
              6: "Telephone or letter contact only"
              7: "Other"

    # =========================================================================
    # BLOCK 10: CUSTODY MODIFICATIONS (Q19A-Q19C)
    # =========================================================================
    # CUS-Q19A: Court order modified custody?
    # CUS-Q19B: Current custody arrangement
    # CUS-Q19C: Tension over living arrangements
    # =========================================================================
    - id: b_custody_modifications
      title: "Custody Modifications"
      precondition:
        - predicate: relationship_to_child != 4
        - predicate: q_cus_q10a.outcome == 1 or q_cus_q10b.outcome == 1
      items:
        # CUS-Q19A: Has a court order modified custody?
        - id: q_cus_q19a
          kind: Question
          title: "Has a court order modified the custody of the child since his/her parents separated (or divorced)?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # CUS-Q19B: Current custody
        - id: q_cus_q19b
          kind: Question
          title: "Is he/she now in:"
          precondition:
            - predicate: q_cus_q19a.outcome == 1
          input:
            control: Radio
            labels:
              1: "Sole custody of mother"
              2: "Sole custody of father"
              3: "Shared physical custody of both parents"
              4: "Other"

        # CUS-Q19C: Tension over living arrangements
        - id: q_cus_q19c
          kind: Question
          title: "Between the child's parents, has the question of living arrangements or visiting rights been:"
          input:
            control: Radio
            labels:
              1: "A great source of tension"
              2: "Some source of tension"
              3: "Very little source of tension"
              4: "No source of tension at all"

    # =========================================================================
    # BLOCK 11: MOTHER'S NEW RELATIONSHIP (Q20A-Q20I)
    # =========================================================================
    # CUS-C20B routing (simplified):
    #   - Mother died -> skip to father's block (C21)
    #   - Parents together, no death, no separation -> skip to end
    #   - Otherwise -> Q20A
    #
    # CUS-Q20A: Mother entered new union?
    # CUS-Q20B: When did mother start living with new partner?
    # CUS-Q20C: When did marriage take place?
    # CUS-Q20D: Did child live in household with mother's new partner?
    # CUS-Q20E: Did new partner have children?
    # CUS-Q20F: How many?
    # CUS-Q20G: Did they live in household?
    # CUS-Q20H: Did mother have children with new partner?
    # CUS-Q20I: How many?
    # =========================================================================
    - id: b_mother_new_union
      title: "Mother's New Relationship"
      precondition:
        - predicate: relationship_to_child != 4
        - predicate: parent_died != 3
        - predicate: parent_died != 1
        # Show when parents separated, or parents not together, or a parent died
        - predicate: parents_separated == 1 or q_cus_q2.outcome == 2 or q_cus_q10a.outcome == 1
      items:
        # CUS-Q20A: Mother entered new union?
        - id: q_cus_q20a
          kind: Question
          title: "Has the child's mother entered into another marriage, common-law relationship, or common-law relationship that resulted in marriage? (Select all that apply.)"
          input:
            control: Checkbox
            labels:
              1: "Yes, a marriage"
              2: "Yes, a common-law relationship"
              4: "Yes, a common-law relationship that resulted in marriage"
              8: "No"
          codeBlock: |
            if q_cus_q20a.outcome % 8 >= 1:
                mother_new_union = 1

        # CUS-Q20B: When did mother start living with new partner?
        # Shown if common-law or common-law->marriage (Q20A has bit 2 or 4 set)
        - id: q_cus_q20b
          kind: Question
          title: "When did the child's mother start living with her new partner? (Enter year.)"
          precondition:
            - predicate: q_cus_q20a.outcome % 8 >= 2 or q_cus_q20a.outcome % 8 >= 4
          input:
            control: Editbox
            min: 1950
            max: 2010
            right: "year"

        # CUS-Q20C: When did marriage take place?
        # Shown if marriage (Q20A has bit 1 set) or common-law->marriage (bit 4)
        - id: q_cus_q20c
          kind: Question
          title: "When did the marriage take place? (Enter year.)"
          precondition:
            - predicate: q_cus_q20a.outcome % 2 == 1 or q_cus_q20a.outcome % 8 >= 4
          input:
            control: Editbox
            min: 1950
            max: 2010
            right: "year"

        # CUS-Q20D: Did child live with mother's new partner?
        - id: q_cus_q20d
          kind: Question
          title: "When they started living together, did the child live in the household with his/her mother's new partner?"
          precondition:
            - predicate: mother_new_union == 1
          input:
            control: Radio
            labels:
              1: "Yes, full-time"
              2: "Yes, part-time"
              3: "No"

        # CUS-Q20E: Did new partner have children?
        - id: q_cus_q20e
          kind: Question
          title: "Did the mother's new partner have any children of his own?"
          precondition:
            - predicate: mother_new_union == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # CUS-Q20F: How many?
        - id: q_cus_q20f
          kind: Question
          title: "How many?"
          precondition:
            - predicate: mother_new_union == 1
            - predicate: q_cus_q20e.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 20

        # CUS-Q20G: Did they live in household?
        - id: q_cus_q20g
          kind: Question
          title: "Did he/she/they live in the household with their father?"
          precondition:
            - predicate: mother_new_union == 1
            - predicate: q_cus_q20e.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes, all of them full-time"
              2: "Yes, all of them part-time"
              3: "Yes, some of them full-time"
              4: "Yes, some of them part-time"
              5: "No, none of them"

        # CUS-Q20H: Did mother have children with new partner?
        - id: q_cus_q20h
          kind: Question
          title: "Did the child's mother have any children with this new spouse/partner?"
          precondition:
            - predicate: mother_new_union == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # CUS-Q20I: How many children with new partner?
        - id: q_cus_q20i
          kind: Question
          title: "How many?"
          precondition:
            - predicate: mother_new_union == 1
            - predicate: q_cus_q20h.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 20

    # =========================================================================
    # BLOCK 12: FATHER'S NEW RELATIONSHIP (Q21A-Q21I)
    # =========================================================================
    # CUS-C21 routing (simplified):
    #   - Father died -> skip to Q22A (subsequent union breakup)
    #   - Father dead and mother has new union -> Q22A
    #   - Father dead and mother has no new union -> end
    #   - Otherwise -> Q21A
    # =========================================================================
    - id: b_father_new_union
      title: "Father's New Relationship"
      precondition:
        - predicate: relationship_to_child != 4
        - predicate: parent_died != 3
        - predicate: parent_died != 2
        - predicate: parents_separated == 1 or q_cus_q2.outcome == 2 or q_cus_q10a.outcome == 1
      items:
        # CUS-Q21A: Father entered new union?
        - id: q_cus_q21a
          kind: Question
          title: "Has the child's father entered into another marriage, common-law relationship, or common-law relationship that resulted in marriage? (Select all that apply.)"
          input:
            control: Checkbox
            labels:
              1: "Yes, a marriage"
              2: "Yes, a common-law relationship"
              4: "Yes, a common-law relationship that resulted in marriage"
              8: "No"
          codeBlock: |
            if q_cus_q21a.outcome % 8 >= 1:
                father_new_union = 1

        # CUS-Q21B: When did father start living with new partner?
        - id: q_cus_q21b
          kind: Question
          title: "When did the child's father start living with his new partner? (Enter year.)"
          precondition:
            - predicate: q_cus_q21a.outcome % 8 >= 2 or q_cus_q21a.outcome % 8 >= 4
          input:
            control: Editbox
            min: 1950
            max: 2010
            right: "year"

        # CUS-Q21C: When did marriage take place?
        - id: q_cus_q21c
          kind: Question
          title: "When did the marriage take place? (Enter year.)"
          precondition:
            - predicate: q_cus_q21a.outcome % 2 == 1 or q_cus_q21a.outcome % 8 >= 4
          input:
            control: Editbox
            min: 1950
            max: 2010
            right: "year"

        # CUS-Q21D: Did child live with father's new partner?
        - id: q_cus_q21d
          kind: Question
          title: "When they started living together, did the child live in the household with his/her father's new partner?"
          precondition:
            - predicate: father_new_union == 1
          input:
            control: Radio
            labels:
              1: "Yes, full-time"
              2: "Yes, part-time"
              3: "No"

        # CUS-Q21E: Did new partner have children?
        - id: q_cus_q21e
          kind: Question
          title: "Did the father's new partner have any children of her own?"
          precondition:
            - predicate: father_new_union == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # CUS-Q21F: How many?
        - id: q_cus_q21f
          kind: Question
          title: "How many?"
          precondition:
            - predicate: father_new_union == 1
            - predicate: q_cus_q21e.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 20

        # CUS-Q21G: Did they live in household?
        - id: q_cus_q21g
          kind: Question
          title: "Did he/she/they live in the household with their mother?"
          precondition:
            - predicate: father_new_union == 1
            - predicate: q_cus_q21e.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes, all of them full-time"
              2: "Yes, all of them part-time"
              3: "Yes, some of them full-time"
              4: "Yes, some of them part-time"
              5: "No, none of them"

        # CUS-Q21H: Did father have children with new partner?
        - id: q_cus_q21h
          kind: Question
          title: "Did the child's father have any children with this new spouse/partner?"
          precondition:
            - predicate: father_new_union == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # CUS-Q21I: How many children with new partner?
        - id: q_cus_q21i
          kind: Question
          title: "How many?"
          precondition:
            - predicate: father_new_union == 1
            - predicate: q_cus_q21h.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 20

    # =========================================================================
    # BLOCK 13: SUBSEQUENT UNION BREAKUP (Q22A-Q23)
    # =========================================================================
    # CUS-C22: IF mother or father entered new relationship -> Q22A
    # Otherwise -> end of section
    # =========================================================================
    - id: b_subsequent_breakup
      title: "Subsequent Union Breakup"
      precondition:
        - predicate: relationship_to_child != 4
        - predicate: parent_died != 3
        - predicate: mother_new_union == 1 or father_new_union == 1
      items:
        # CUS-Q22A: Has this other union broken up?
        - id: q_cus_q22a
          kind: Question
          title: "Has this other union of the child's mother or father broken up?"
          input:
            control: Radio
            labels:
              1: "Yes, mother's union"
              2: "Yes, father's union"
              3: "Yes, both unions"
              4: "No"

        # CUS-Q22B: When did that happen?
        - id: q_cus_q22b
          kind: Question
          title: "When did that happen? (If both unions have broken up, use date of first event. Enter year.)"
          precondition:
            - predicate: q_cus_q22a.outcome in [1, 2, 3]
          input:
            control: Editbox
            min: 1950
            max: 2010
            right: "year"

        # CUS-Q22C: With whom did child live after?
        - id: q_cus_q22c
          kind: Question
          title: "With whom did the child go on living after it happened?"
          precondition:
            - predicate: q_cus_q22a.outcome in [1, 2, 3]
          input:
            control: Radio
            labels:
              1: "Mother full-time"
              2: "Father full-time"
              3: "Part-time mother and father"

        # CUS-Q23: Any other family reconstitution?
        - id: q_cus_q23
          kind: Question
          title: "Did the child live through any other family reconstitution between then and now?"
          precondition:
            - predicate: q_cus_q22a.outcome in [1, 2, 3]
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

    # ===================================================================
    # SECTION: child_care
    # ===================================================================
    # =========================================================================
    # BLOCK 1: CHILD CARE USAGE (CAR-I1, CAR-Q1A)
    # =========================================================================
    # Determines whether the family currently uses child care.
    # Q1A=NO skips to the "ever used" block (Q6).
    # =========================================================================
    - id: b_car_usage
      title: "Child Care Usage"
      items:
        # CAR-I1: Introduction
        - id: q_car_intro
          kind: Comment
          title: "Now I'd like to ask you some questions regarding your child care arrangements for this child."

        # CAR-Q1A: Currently use child care
        - id: q_car_q1a
          kind: Question
          title: "Do you currently use child care such as daycare or babysitting while you (and your spouse/partner) are at work or studying?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

    # =========================================================================
    # BLOCK 2: CARE TYPES (CAR-Q1B through CAR-Q1J)
    # =========================================================================
    # Each care type: Y/N switch, then conditional hours and licensing.
    # Block-level precondition: only shown when currently using care.
    # CAR-C1H: Before/after school (Q1H) requires age >= 4.
    # CAR-C1I: Self-care (Q1I) requires age >= 6.
    # =========================================================================
    - id: b_car_types
      title: "Types of Child Care"
      precondition:
        - predicate: q_car_q1a.outcome == 1
      items:
        # --- Q1B: Non-relative in their home ---
        - id: q_car_q1b
          kind: Question
          title: "Which of the following methods of child care do you currently use? Care provided in someone else's home by a non-relative?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        - id: q_car_q1b1
          kind: Question
          title: "For about how many hours per week is that? (Non-relative in their home)"
          precondition:
            - predicate: q_car_q1b.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 168
            right: "hours per week"

        - id: q_car_q1b2
          kind: Question
          title: "Is the person providing this care licensed by the government or approved by a family daycare agency?"
          precondition:
            - predicate: q_car_q1b.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # --- Q1C: Relative in their home ---
        - id: q_car_q1c
          kind: Question
          title: "Care in someone else's home by a relative?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        - id: q_car_q1c1
          kind: Question
          title: "For about how many hours per week is that? (Relative in their home)"
          precondition:
            - predicate: q_car_q1c.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 168
            right: "hours per week"

        - id: q_car_q1c2
          kind: Question
          title: "Is the person providing this care licensed by the government or approved by a family daycare agency?"
          precondition:
            - predicate: q_car_q1c.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # --- Q1D: Sibling in own home ---
        - id: q_car_q1d
          kind: Question
          title: "Care in own home by brother or sister of the child?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        - id: q_car_q1d1
          kind: Question
          title: "For about how many hours per week is that? (Sibling in own home)"
          precondition:
            - predicate: q_car_q1d.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 168
            right: "hours per week"

        # --- Q1E: Other relative in own home ---
        - id: q_car_q1e
          kind: Question
          title: "Care in own home by a relative other than a sister or brother of the child?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        - id: q_car_q1e1
          kind: Question
          title: "For about how many hours per week is that? (Other relative in own home)"
          precondition:
            - predicate: q_car_q1e.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 168
            right: "hours per week"

        # --- Q1F: Non-relative in own home ---
        - id: q_car_q1f
          kind: Question
          title: "Care in own home by a non-relative?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        - id: q_car_q1f1
          kind: Question
          title: "For about how many hours per week is that? (Non-relative in own home)"
          precondition:
            - predicate: q_car_q1f.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 168
            right: "hours per week"

        # --- Q1G: Daycare centre ---
        - id: q_car_q1g
          kind: Question
          title: "Care in a daycare centre (including at workplace)?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        - id: q_car_q1g1
          kind: Question
          title: "For about how many hours per week is that? (Daycare centre)"
          precondition:
            - predicate: q_car_q1g.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 168
            right: "hours per week"

        - id: q_car_q1g2
          kind: Question
          title: "Is the child care program or daycare centre operated on a profit or non-profit basis (include government sponsored care)?"
          precondition:
            - predicate: q_car_q1g.outcome == 1
          input:
            control: Radio
            labels:
              1: "Profit"
              2: "Non-profit"

        # --- Q1H: Before/after school program (age 4+) ---
        # CAR-C1H: IF AGE < 4 → skip Q1H
        - id: q_car_q1h
          kind: Question
          title: "Care in a before or after school program?"
          precondition:
            - predicate: child_age >= 4
          input:
            control: Switch
            off: "No"
            on: "Yes"

        - id: q_car_q1h1
          kind: Question
          title: "For about how many hours per week is that? (Before/after school program)"
          precondition:
            - predicate: child_age >= 4
            - predicate: q_car_q1h.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 168
            right: "hours per week"

        # --- Q1I: Self-care (age 6+) ---
        # CAR-C1I: IF AGE 4-5 → skip Q1I
        - id: q_car_q1i
          kind: Question
          title: "Is the child in his/her own care (e.g. before/after school)?"
          precondition:
            - predicate: child_age >= 6
          input:
            control: Switch
            off: "No"
            on: "Yes"

        - id: q_car_q1i1
          kind: Question
          title: "For about how many hours per week is that? (Self-care)"
          precondition:
            - predicate: child_age >= 6
            - predicate: q_car_q1i.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 168
            right: "hours per week"

        # --- Q1J: Other arrangements ---
        - id: q_car_q1j
          kind: Question
          title: "Do you currently use other child care arrangements?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        - id: q_car_q1j1
          kind: Question
          title: "For about how many hours per week is that? (Other arrangements)"
          precondition:
            - predicate: q_car_q1j.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 168
            right: "hours per week"

    # =========================================================================
    # BLOCK 3: MAIN ARRANGEMENT DETAILS (CAR-I2, CAR-Q2, CAR-Q3, CAR-Q4)
    # =========================================================================
    # Asked of all current care users.
    # I2: Intro about main arrangement
    # Q2: When started arrangement (year)
    # CAR-C3: IF AGE > 5 → skip Q3
    # Q3: How well child gets along with caregiver (age 0-5 only)
    # Q4: Number of changes in past 12 months
    # =========================================================================
    - id: b_car_main
      title: "Main Child Care Arrangement"
      precondition:
        - predicate: q_car_q1a.outcome == 1
      items:
        # CAR-I2: Introduction about main arrangement
        - id: q_car_i2
          kind: Comment
          title: "In the following questions we will be asking about your main child care arrangement, that is, the one used for the most hours."

        # CAR-Q2: When started arrangement
        - id: q_car_q2
          kind: Question
          title: "When did you start using this child care arrangement? (Enter year)"
          input:
            control: Editbox
            min: 1980
            max: 2000
            right: "year"

        # CAR-Q3: How well child gets along with caregiver (age 0-5)
        # CAR-C3: IF AGE > 5 → skip Q3
        - id: q_car_q3
          kind: Question
          title: "During the past 6 months, how well has he/she gotten along with his/her main child care provider?"
          precondition:
            - predicate: child_age <= 5
          input:
            control: Radio
            labels:
              1: "Very well, no problems"
              2: "Quite well, hardly any problems"
              3: "Pretty well, occasional problems"
              4: "Not too well, frequent problems"
              5: "Not well at all, constant problems"

        # CAR-Q4: Changes in past 12 months
        - id: q_car_q4
          kind: Question
          title: "In the past 12 months, how many times have you changed your main child care arrangement and/or caregiver, excluding periods of care by yourself (or spouse/partner)?"
          input:
            control: Radio
            labels:
              1: "None"
              2: "1"
              3: "2"
              4: "3 or 4"
              5: "5 or more"

    # =========================================================================
    # BLOCK 4: REASONS FOR CHANGING (CAR-Q5)
    # =========================================================================
    # CAR-C5: IF Q4=NONE(1) AND AGE<1 → END. IF Q4=NONE(1) AND AGE>=1 → Q7.
    #         OTHERWISE → Q5.
    # Q5 only asked when there were changes (Q4 != NONE).
    # =========================================================================
    - id: b_car_changes
      title: "Reasons for Changing Care"
      precondition:
        - predicate: q_car_q1a.outcome == 1
        - predicate: q_car_q4.outcome != 1
      items:
        # CAR-Q5: Reasons for changing
        - id: q_car_q5
          kind: Question
          title: "What were the reasons for changing? (Mark all that apply.)"
          input:
            control: Checkbox
            labels:
              1: "Dissatisfaction with caregiver/program"
              2: "Caregiver/program no longer available"
              4: "Family or child moved, parental work status or custody arrangement changed"
              8: "Changes in child or child's needs (e.g. special care, child's age)"
              16: "A preferred arrangement became available (e.g. subsidized space)"
              32: "Cost"
              64: "Other"

    # =========================================================================
    # BLOCK 5: EVER USED CARE (CAR-Q6)
    # =========================================================================
    # CAR-C6: Only asked when Q1A=NO (not currently using care) AND age >= 1.
    # If age < 1 and not using care → end of section.
    # Q6=NO → end of section.
    # Q6=YES → continues to Q7.
    # =========================================================================
    - id: b_car_ever
      title: "Previous Child Care"
      precondition:
        - predicate: q_car_q1a.outcome == 0
        - predicate: child_age >= 1
      items:
        # CAR-Q6: Ever used child care
        - id: q_car_q6
          kind: Question
          title: "Have you ever used child care for this child while you (and your spouse/partner) were at work or studying?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

    # =========================================================================
    # BLOCK 6: TOTAL CHANGES AND SUMMER CARE (CAR-Q7, CAR-Q8)
    # =========================================================================
    # Q7 reached from two paths:
    #   Path A: Currently using care (Q1A=YES) AND age >= 1
    #           (via C5 when Q4=NONE, or via E5 after Q5)
    #   Path B: Not using care (Q1A=NO) AND Q6=YES (ever used)
    # Q8: Summer care, only age 6+ (CAR-C8)
    # =========================================================================
    - id: b_car_total
      title: "Overall Child Care Changes"
      precondition:
        - predicate: (q_car_q1a.outcome == 1 and child_age >= 1) or (q_car_q1a.outcome == 0 and child_age >= 1 and q_car_q6.outcome == 1)
      items:
        # CAR-Q7: Total changes overall
        - id: q_car_q7
          kind: Question
          title: "Overall, how many changes in child care arrangements has this child experienced since you began using child care, excluding periods of care by yourself (or spouse/partner)?"
          input:
            control: Editbox
            min: 0
            max: 99

        # CAR-Q8: Summer care arrangements (age 6+)
        # CAR-C8: IF AGE < 6 → END
        - id: q_car_q8
          kind: Question
          title: "Last summer while this child was not in school, what type of child care arrangement did you use while you (and your spouse/partner) were at work/studying? (Mark all that apply.)"
          precondition:
            - predicate: child_age >= 6
          input:
            control: Checkbox
            labels:
              1: "Day care centre"
              2: "Care in someone else's home by a non-relative"
              4: "Care in someone else's home by a relative"
              8: "Care in own home by a non-relative"
              16: "Care in own home by brother/sister"
              32: "Care in own home by other relative"
              64: "Child in own care"
              128: "Structured summer program"
              256: "Other"
