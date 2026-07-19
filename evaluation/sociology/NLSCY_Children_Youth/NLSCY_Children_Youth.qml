qmlVersion: "2.0"
questionnaire:
  title: "National Longitudinal Survey of Children and Youth"
  codeInit: |
    # =====================================================================
    # Cross-section variables. With a single codeInit scope and one
    # dependency graph, variables written by an earlier block are visible
    # to every later block without any extern declaration.
    # =====================================================================
    # Age, biology, PMK role, parent/sibling status are asked directly and
    # referenced via their question outcomes (q_respondent_age, q_child_age,
    # q_child_age_months, q_bio_relationship, q_pickresp, q_is_parent,
    # q_has_siblings), so no cross-section aliases are declared for them.
    marital_status = 0      # 1=Married, 2=Common-law, 3=Partner, 4=Single, 5=Widowed, 6=Separated, 7=Divorced
    has_gaps = 0
    has_income = 0              # 1=household has any income source, 0=none
    source_count = 0            # count of income sources selected
    multiple_sources = 0        # 1=more than one source selected
    household_income_known = 0  # bracket estimation fallback
    personal_income_known = 0
    cesd_score = 0                # CES-D Depression Scale score
    relationship_to_child = 0   # 1=Birth parent .. 9=Unrelated, used in Parenting/Custody
    in_school = 0       # 0=not in school, 1=in school
    school_grade = 0    # consolidated grade value (0=not in school, 16=ungraded)
    parents_separated = 0
    parent_died = 0
    parents_were_married = 0
    mother_new_union = 0
    father_new_union = 0
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
      kind: Group
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
      kind: Group
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
          input:
            control: Editbox
            min: 0
            max: 11
            right: "years"

        # DEMO-Q4 (months): Child's age in months, derived from date of birth.
        # The source collects date of birth (DEMO-Q4); the young-child modules
        # (temperament, motor/social development, prenatal/birth) route on the
        # child's age in months. Modeled as a separate admin Editbox because QML
        # has no date input from which to derive months.
        - id: q_child_age_months
          kind: Question
          title: "What is the age of the selected child, in months?"
          input:
            control: Editbox
            min: 0
            max: 143
            right: "months"

        # DEMO-Q5: Sex of respondent
        - id: q_demo_q5
          kind: Question
          title: "Enter or confirm the respondent's sex."
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
      kind: Group
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
      kind: Group
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

        # Respondent-child relationship flags. The source derives these from the
        # household roster (DEMO-Q7/Q8, collected externally) together with the
        # date of birth. Modeled here as explicit admin questions so the
        # downstream parenting/biology/sibling routing has a producer.
        - id: q_is_parent
          kind: Question
          title: "Is the respondent a parent of the selected child?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: q_bio_relationship
          kind: Question
          title: "What is the respondent's biological relationship to the selected child?"
          input:
            control: Radio
            labels:
              1: "Biological mother"
              2: "Biological father"
              3: "Neither / other"

        - id: q_has_siblings
          kind: Question
          title: "Does the selected child have any brothers or sisters living in the household?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

    # =========================================================================
    # BLOCK 5: ADMINISTRATION
    # =========================================================================
    # H05-P1: Interview mode
    # H05-P2: Language of interview
    # =========================================================================
    - id: b_administration
      kind: Group
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
    # Modeled as block-level precondition: q_respondent_age.outcome >= 12
    # =========================================================================
    - id: b_restriction
      kind: Group
      title: "Restriction of Activities"
      precondition:
        - predicate: q_respondent_age.outcome >= 12
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
    # Modeled as block-level precondition: q_respondent_age.outcome >= 12 AND q_is_parent.outcome == 1
    # =========================================================================
    - id: b_chronic
      kind: Group
      title: "Chronic Conditions"
      precondition:
        - predicate: q_respondent_age.outcome >= 12
        - predicate: q_is_parent.outcome == 1
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
      kind: Group
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
      kind: Group
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
      kind: Group
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
      kind: Group
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
      kind: Group
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
      kind: Group
      title: "Education"
      precondition:
        - predicate: q_respondent_age.outcome >= 12
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
            - predicate: q_respondent_age.outcome >= 15
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
            - predicate: q_respondent_age.outcome >= 15
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
            - predicate: q_respondent_age.outcome >= 15
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
            - predicate: q_respondent_age.outcome >= 15
            - predicate: q_respondent_age.outcome < 65
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
            - predicate: q_respondent_age.outcome >= 15
            - predicate: q_respondent_age.outcome < 65
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
    # Entire section is gated by q_is_parent.outcome == 1.
    #
    # LFS-Q1: Main activity classification
    # LFS-I2: Employment intro
    # LFS-C2: IF Q1=Working or Caring+Working -> GO TO Q3 (skip Q2)
    # LFS-Q2: Worked for pay in past 12 months?
    # LFS-C2A: IF Q1=RETIRED -> exit section; ELSE -> Q17B
    # =========================================================================
    - id: b_main_activity
      kind: Group
      title: "Main Activity"
      precondition:
        - predicate: q_is_parent.outcome == 1
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
      kind: Group
      title: "Employment Details"
      precondition:
        - predicate: q_is_parent.outcome == 1
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
      kind: Group
      title: "Wage Details"
      precondition:
        - predicate: q_is_parent.outcome == 1
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
      kind: Group
      title: "Employment Gaps"
      precondition:
        - predicate: q_is_parent.outcome == 1
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
      kind: Group
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
      kind: Group
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
      kind: Group
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
      kind: Group
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
      kind: Group
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
    # Modeled as block precondition: biological mother of a child under 2.
    # =========================================================================
    - id: b_maternal
      kind: Group
      title: "Maternal History"
      precondition:
        - predicate: q_bio_relationship.outcome == 1
        - predicate: q_child_age_months.outcome < 24
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
    # Modeled as block precondition: q_pickresp.outcome == 1
    # =========================================================================
    - id: b_cesd
      kind: Group
      title: "CES-D Depression Scale"
      precondition:
        - predicate: q_pickresp.outcome == 1
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
      kind: Group
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
      kind: Group
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
      kind: Group
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
      kind: Group
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
      kind: Group
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
            - predicate: q_child_age.outcome >= 2
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
      kind: Group
      title: "Vision"
      precondition:
        - predicate: q_child_age.outcome >= 4
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
            - predicate: q_child_age.outcome >= 6
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
            - predicate: q_child_age.outcome >= 4 and q_child_age.outcome <= 5
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
            - predicate: q_child_age.outcome >= 6
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
            - predicate: q_child_age.outcome >= 4 and q_child_age.outcome <= 5
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
            - predicate: (q_child_age.outcome >= 6 and q_hlt_q7.outcome in [2, 3, 8]) or (q_child_age.outcome >= 4 and q_child_age.outcome <= 5 and q_hlt_q7a.outcome in [2, 3, 8])
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
            - predicate: (q_child_age.outcome >= 6 and (q_hlt_q6.outcome == 1 or q_hlt_q7.outcome == 1)) or (q_child_age.outcome >= 4 and q_child_age.outcome <= 5 and (q_hlt_q6a.outcome == 1 or q_hlt_q7a.outcome == 1)) or q_hlt_q8.outcome == 1
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
      kind: Group
      title: "Hearing"
      precondition:
        - predicate: q_child_age.outcome >= 4
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
      kind: Group
      title: "Speech"
      precondition:
        - predicate: q_child_age.outcome >= 4
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
      kind: Group
      title: "Getting Around"
      precondition:
        - predicate: q_child_age.outcome >= 4
      items:
        # HLT-Q20: Walk around neighbourhood (age 6+)
        # YES(1)->Q27, NO(2)->Q21, DK(8)->Q21, REF(9)->Q27
        - id: q_hlt_q20
          kind: Question
          title: "Is the child usually able to walk around the neighbourhood without difficulty and without mechanical support such as braces, a cane or crutches?"
          precondition:
            - predicate: q_child_age.outcome >= 6
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
            - predicate: q_child_age.outcome >= 4 and q_child_age.outcome <= 5
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
            - predicate: (q_child_age.outcome >= 6 and q_hlt_q20.outcome in [2, 8]) or (q_child_age.outcome >= 4 and q_child_age.outcome <= 5 and q_hlt_q20a.outcome in [2, 8])
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
            - predicate: q_child_age.outcome >= 6
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
            - predicate: q_child_age.outcome >= 4 and q_child_age.outcome <= 5
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
            - predicate: (q_child_age.outcome >= 6 and q_hlt_q22.outcome in [1, 2, 8]) or (q_child_age.outcome >= 4 and q_child_age.outcome <= 5 and q_hlt_q22a.outcome in [1, 2, 8])
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
      kind: Group
      title: "Hands and Fingers"
      precondition:
        - predicate: q_child_age.outcome >= 4
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
      kind: Group
      title: "Cognition and Feelings"
      precondition:
        - predicate: q_child_age.outcome >= 4
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
      kind: Group
      title: "Pain and Discomfort"
      precondition:
        - predicate: q_child_age.outcome >= 4
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
      kind: Group
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
      kind: Group
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
      kind: Group
      title: "Long-term Conditions"
      items:
        # HLT-Q45: Long-term conditions (age 0-5)
        - id: q_hlt_q45
          kind: Question
          title: "In the following questions long-term conditions refer to conditions that have lasted or are expected to last 6 months or more. Does the child have any of the following long-term conditions that have been diagnosed by a health professional?"
          precondition:
            - predicate: q_child_age.outcome <= 5
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
            - predicate: q_child_age.outcome >= 6
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
      kind: Group
      title: "Infections"
      precondition:
        - predicate: q_child_age.outcome <= 3
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
      kind: Group
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
      kind: Group
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
      kind: Group
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
      kind: Group
      title: "Stressful Events"
      precondition:
        - predicate: q_child_age.outcome >= 4
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
      kind: Group
      title: "Prenatal Conditions and Care"
      precondition:
        - predicate: q_child_age.outcome <= 3
        - predicate: q_bio_relationship.outcome == 1
        - predicate: q_child_age_months.outcome <= 23
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
      kind: Group
      title: "Birth Details"
      precondition:
        - predicate: q_child_age.outcome <= 3
        - predicate: q_bio_relationship.outcome == 1 or q_bio_relationship.outcome == 2
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
      kind: Group
      title: "Delivery Details"
      precondition:
        - predicate: q_child_age.outcome <= 3
        - predicate: q_bio_relationship.outcome == 1 or q_bio_relationship.outcome == 2
        - predicate: q_child_age_months.outcome <= 11
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
      kind: Group
      title: "Neonatal Care"
      precondition:
        - predicate: q_child_age.outcome <= 3
        - predicate: q_bio_relationship.outcome == 1 or q_bio_relationship.outcome == 2
        - predicate: q_child_age_months.outcome <= 23
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
      kind: Group
      title: "Postnatal Complications"
      precondition:
        - predicate: q_child_age.outcome <= 3
        - predicate: q_bio_relationship.outcome == 1
        - predicate: q_child_age_months.outcome <= 11
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
      kind: Group
      title: "Breastfeeding"
      precondition:
        - predicate: q_child_age.outcome <= 3
        - predicate: q_bio_relationship.outcome == 1 or q_bio_relationship.outcome == 2
        - predicate: q_child_age_months.outcome <= 23
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
      kind: Group
      title: "Temperament"
      precondition:
        - predicate: q_child_age_months.outcome >= 3
        - predicate: q_child_age_months.outcome <= 47
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
      kind: Group
      title: "Predictability and Routines"
      precondition:
        - predicate: q_child_age_months.outcome >= 3
        - predicate: q_child_age_months.outcome <= 47
      items:
        # TMP-Q2: Sleep predictability (age < 12 months)
        - id: q_tmp_q2
          kind: Question
          title: "How easy or difficult is it for you to predict when he/she will go to sleep and wake up?"
          precondition:
            - predicate: q_child_age_months.outcome < 12
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
            - predicate: q_child_age_months.outcome >= 12
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
            - predicate: q_child_age_months.outcome < 12
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
            - predicate: q_child_age_months.outcome >= 12
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
      kind: Group
      title: "Fussiness and Crying"
      precondition:
        - predicate: q_child_age_months.outcome >= 3
        - predicate: q_child_age_months.outcome <= 47
      items:
        # TMP-Q4: Knowing what's bothering (age < 36 months)
        - id: q_tmp_q4
          kind: Question
          title: "How easy or difficult is it for you to know what's bothering him/her when he/she cries or fusses?"
          precondition:
            - predicate: q_child_age_months.outcome < 36
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
            - predicate: q_child_age_months.outcome >= 36
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
            - predicate: q_child_age_months.outcome < 36
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
            - predicate: q_child_age_months.outcome >= 36
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
            - predicate: q_child_age_months.outcome < 36
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
            - predicate: q_child_age_months.outcome >= 36
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
            - predicate: q_child_age_months.outcome < 12
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
            - predicate: q_child_age_months.outcome >= 12
            - predicate: q_child_age_months.outcome <= 35
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
            - predicate: q_child_age_months.outcome >= 36
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
      kind: Group
      title: "Daily Care Reactions"
      precondition:
        - predicate: q_child_age_months.outcome >= 3
        - predicate: q_child_age_months.outcome <= 47
      items:
        # TMP-Q9: Reaction to dressing (age < 12 months)
        - id: q_tmp_q9
          kind: Question
          title: "How does he/she react when you are dressing him/her?"
          precondition:
            - predicate: q_child_age_months.outcome < 12
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
            - predicate: q_child_age_months.outcome >= 12
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
      kind: Group
      title: "Mood and Sociability"
      precondition:
        - predicate: q_child_age_months.outcome >= 3
        - predicate: q_child_age_months.outcome <= 47
      items:
        # TMP-Q11: Smiling and happy sounds (age < 36 months)
        - id: q_tmp_q11
          kind: Question
          title: "How much does he/she smile and make happy sounds?"
          precondition:
            - predicate: q_child_age_months.outcome < 36
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
            - predicate: q_child_age_months.outcome >= 36
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
            - predicate: q_child_age_months.outcome >= 6
            - predicate: q_child_age_months.outcome <= 11
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
            - predicate: q_child_age_months.outcome >= 12
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
            - predicate: q_child_age_months.outcome < 36
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
            - predicate: q_child_age_months.outcome >= 36
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
      kind: Group
      title: "Predictability and Mood Changes"
      precondition:
        - predicate: q_child_age_months.outcome >= 3
        - predicate: q_child_age_months.outcome <= 47
      items:
        # TMP-Q16: Diaper prediction (age 3-11 months only)
        - id: q_tmp_q16
          kind: Question
          title: "How easy is it for you to predict when he/she will need a diaper change?"
          precondition:
            - predicate: q_child_age_months.outcome < 12
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
            - predicate: q_child_age_months.outcome >= 12
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
            - predicate: q_child_age_months.outcome < 36
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
            - predicate: q_child_age_months.outcome >= 36
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
      kind: Group
      title: "Confinement and Cuddling"
      precondition:
        - predicate: q_child_age_months.outcome >= 3
        - predicate: q_child_age_months.outcome <= 47
      items:
        # TMP-Q21: Confinement reaction (age 12-23 months)
        - id: q_tmp_q21
          kind: Question
          title: "How does he/she react to being confined (as in a carseat, infant seat, playpen, etc.)?"
          precondition:
            - predicate: q_child_age_months.outcome >= 12
            - predicate: q_child_age_months.outcome <= 23
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
            - predicate: q_child_age_months.outcome >= 24
            - predicate: q_child_age_months.outcome <= 35
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
            - predicate: q_child_age_months.outcome >= 36
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
            - predicate: q_child_age_months.outcome < 12
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
            - predicate: q_child_age_months.outcome >= 12
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
      kind: Group
      title: "Novelty Responses"
      precondition:
        - predicate: q_child_age_months.outcome >= 3
        - predicate: q_child_age_months.outcome <= 47
      items:
        # TMP-Q23: First bath response (age 3-11 months)
        - id: q_tmp_q23
          kind: Question
          title: "How did he/she respond to his/her first bath?"
          precondition:
            - predicate: q_child_age_months.outcome < 12
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
            - predicate: q_child_age_months.outcome >= 12
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
            - predicate: q_child_age_months.outcome >= 6
            - predicate: q_child_age_months.outcome <= 11
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
            - predicate: q_child_age_months.outcome >= 12
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
            - predicate: q_child_age_months.outcome < 12
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
            - predicate: q_child_age_months.outcome >= 12
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
      kind: Group
      title: "Persistence and Compliance"
      precondition:
        - predicate: q_child_age_months.outcome >= 12
        - predicate: q_child_age_months.outcome <= 47
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
            - predicate: q_child_age_months.outcome < 36
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
            - predicate: q_child_age_months.outcome >= 36
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
      kind: Group
      title: "Overall Difficulty"
      precondition:
        - predicate: q_child_age_months.outcome >= 3
        - predicate: q_child_age_months.outcome <= 47
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
      kind: Group
      title: "School Grade and Attendance"
      precondition:
        - predicate: q_child_age.outcome >= 4
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
      kind: Group
      title: "Grade Skipping and Repeating"
      precondition:
        - predicate: q_child_age.outcome >= 4
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
      kind: Group
      title: "School Type and Changes"
      precondition:
        - predicate: q_child_age.outcome >= 4
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
      kind: Group
      title: "Language and Absences"
      precondition:
        - predicate: q_child_age.outcome >= 4
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
            - predicate: q_child_age.outcome <= 5
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
      kind: Group
      title: "Academic Performance"
      precondition:
        - predicate: q_child_age.outcome >= 4
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
      kind: Group
      title: "Tutoring"
      precondition:
        - predicate: q_child_age.outcome >= 4
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
      kind: Group
      title: "School Attitudes and Expectations"
      precondition:
        - predicate: q_child_age.outcome >= 4
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
            - predicate: q_child_age.outcome >= 8
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
      kind: Group
      title: "School Descriptors"
      precondition:
        - predicate: q_child_age.outcome >= 4
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
      kind: Group
      title: "Special Education"
      precondition:
        - predicate: q_child_age.outcome >= 4
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
      kind: Group
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
      kind: Group
      title: "Infant Reading"
      precondition:
        - predicate: q_child_age_months.outcome <= 23
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
      kind: Group
      title: "Early Childhood Reading Habits"
      precondition:
        - predicate: q_child_age.outcome >= 2
        - predicate: q_child_age.outcome <= 4
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
      kind: Group
      title: "Reading Aloud History"
      precondition:
        - predicate: q_child_age.outcome >= 2
        - predicate: q_child_age.outcome <= 5
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
      kind: Group
      title: "Current Reading Frequency"
      precondition:
        - predicate: q_child_age.outcome >= 2
      items:
        # LIT-Q7: Reading frequency (age 2-4, Q6A=YES)
        # From C7A: age < 5 -> Q7 (only reached if Q6A was answered YES)
        - id: q_lit_q7
          kind: Question
          title: "Currently, how often do you or another adult read to him/her? (Also include if he/she reads or pretends to read to adult.)"
          precondition:
            - predicate: q_child_age.outcome >= 2 and q_child_age.outcome <= 4
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
            - predicate: q_child_age.outcome >= 5 and q_child_age.outcome <= 7
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
            - predicate: q_child_age.outcome >= 8 and q_child_age.outcome <= 11
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
      kind: Group
      title: "Writing Help"
      precondition:
        - predicate: q_child_age.outcome >= 2
        - predicate: q_child_age.outcome <= 5
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
      kind: Group
      title: "Homework"
      precondition:
        - predicate: q_child_age.outcome >= 6
        - predicate: q_child_age.outcome <= 11
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
      kind: Group
      title: "Independent Reading and Library Use"
      precondition:
        - predicate: q_child_age.outcome >= 5
        - predicate: q_child_age.outcome <= 11
      items:
        # LIT-Q12: Independent reading (age 5-6)
        # Younger phrasing for children who may not yet read independently
        - id: q_lit_q12
          kind: Question
          title: "How often does the child look at books or try to read on his/her own?"
          precondition:
            - predicate: q_child_age.outcome >= 5 and q_child_age.outcome <= 6
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
            - predicate: q_child_age.outcome >= 7 and q_child_age.outcome <= 11
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
    # ACT-C1: IF AGE > 5 → skip to Q3A. Modeled as precondition q_child_age.outcome <= 5
    # ACT-Q1: Early childhood programs (age 0-5 only)
    # ACT-Q2A/Q2B: Program details (only if Q1 = YES)
    # =========================================================================
    - id: b_act_early
      kind: Group
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
            - predicate: q_child_age.outcome <= 5
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # ACT-Q2A: Program types (only if Q1 = YES)
        - id: q_act_q2a
          kind: Question
          title: "What type(s) of programs or activities? (Mark all that apply.)"
          precondition:
            - predicate: q_child_age.outcome <= 5
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
            - predicate: q_child_age.outcome <= 5
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
    #         precondition q_child_age.outcome >= 4 on this block.
    # ACT-Q3A-Q3C: Activity frequency questions (age 4+)
    # ACT-C3D: Age-variant club question (Q3D1/Q3D2/Q3D3)
    # ACT-Q3E: Computer/video games (age 4+)
    # =========================================================================
    - id: b_act_frequency
      kind: Group
      title: "Activities - Activity Frequency"
      precondition:
        - predicate: q_child_age.outcome >= 4
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
            - predicate: q_child_age.outcome >= 4 and q_child_age.outcome <= 5
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
            - predicate: q_child_age.outcome >= 6 and q_child_age.outcome <= 9
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
            - predicate: q_child_age.outcome >= 10 and q_child_age.outcome <= 11
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
      kind: Group
      title: "Activities - TV and Play"
      precondition:
        - predicate: q_child_age.outcome >= 4
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
      kind: Group
      title: "Activities - Chores"
      precondition:
        - predicate: q_child_age.outcome >= 10
        - predicate: q_child_age.outcome <= 11
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
      kind: Group
      title: "Activities - Camps"
      precondition:
        - predicate: q_child_age.outcome >= 6
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
      kind: Group
      title: "Sleep Patterns"
      precondition:
        - predicate: q_child_age.outcome <= 3
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
      kind: Group
      title: "Infant Feeding Reactions"
      precondition:
        - predicate: q_child_age.outcome >= 1 and q_child_age.outcome <= 3
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
      kind: Group
      title: "Infant Feeding Difficulty"
      precondition:
        - predicate: q_child_age.outcome == 0
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
    # BEH-I6A: Intro. Precondition: q_child_age.outcome >= 4
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
      kind: Group
      title: "Child Behaviour Assessment (Age 4-11)"
      precondition:
        - predicate: q_child_age.outcome >= 4
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
      kind: Group
      title: "Delinquent Behaviours (Age 10-11)"
      precondition:
        - predicate: q_child_age.outcome >= 10
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
    # BEH-I8A: Intro. Precondition: q_child_age.outcome >= 2 and q_child_age.outcome <= 3
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
      kind: Group
      title: "Toddler Behaviour Assessment (Age 2-3)"
      precondition:
        - predicate: q_child_age.outcome >= 2 and q_child_age.outcome <= 3
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
    # Age-band routing via preconditions on q_child_age_months.outcome:
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
      kind: Group
      title: "Motor and Social Development"
      precondition:
        - predicate: q_child_age.outcome <= 3
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
            - predicate: q_child_age_months.outcome >= 4
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q9
        - id: q_msd_q9
          kind: Question
          title: "Has he/she ever laughed out loud without being tickled or touched?"
          precondition:
            - predicate: q_child_age_months.outcome >= 4
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q10
        - id: q_msd_q10
          kind: Question
          title: "Has he/she ever held in one hand a moderate size object such as a block or a rattle?"
          precondition:
            - predicate: q_child_age_months.outcome >= 4
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q11
        - id: q_msd_q11
          kind: Question
          title: "Has he/she ever rolled over on his/her own on purpose?"
          precondition:
            - predicate: q_child_age_months.outcome >= 4
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
            - predicate: q_child_age_months.outcome >= 7
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q13
        - id: q_msd_q13
          kind: Question
          title: "Has he/she ever been pulled from a sitting to a standing position and supported his/her own weight with legs stretched out?"
          precondition:
            - predicate: q_child_age_months.outcome >= 7
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q14
        - id: q_msd_q14
          kind: Question
          title: "Has he/she ever looked around with his/her eyes for a toy which was lost or not nearby?"
          precondition:
            - predicate: q_child_age_months.outcome >= 7
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q15
        - id: q_msd_q15
          kind: Question
          title: "Has he/she ever sat alone with no help except for leaning forward on his/her hands or with just a little help from someone else?"
          precondition:
            - predicate: q_child_age_months.outcome >= 7
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -----------------------------------------------------------------
        # MSD-C16: IF AGE 0-3 MONTHS → exit to Relationships
        # Modeled as: Q16+ requires q_child_age_months.outcome >= 4
        # -----------------------------------------------------------------

        # MSD-Q16
        - id: q_msd_q16
          kind: Question
          title: "Has he/she ever sat for 10 minutes without any support at all?"
          precondition:
            - predicate: q_child_age_months.outcome >= 4
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q17
        - id: q_msd_q17
          kind: Question
          title: "Has he/she ever pulled him/herself to a standing position without help from another person?"
          precondition:
            - predicate: q_child_age_months.outcome >= 4
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
            - predicate: q_child_age_months.outcome >= 10
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q19
        - id: q_msd_q19
          kind: Question
          title: "Has he/she ever said any recognizable words such as \"mama\" or \"dada\"?"
          precondition:
            - predicate: q_child_age_months.outcome >= 10
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q20
        - id: q_msd_q20
          kind: Question
          title: "Has he/she ever picked up small objects such as raisins or cookie crumbs, using only his/her thumb and first finger?"
          precondition:
            - predicate: q_child_age_months.outcome >= 10
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q21
        - id: q_msd_q21
          kind: Question
          title: "Has he/she ever walked at least 2 steps with one hand held or holding on to something?"
          precondition:
            - predicate: q_child_age_months.outcome >= 10
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -----------------------------------------------------------------
        # Q22: First appears in 13-15m band → minimum age 13 months
        # But Q22 also appears in 4-6m band (Q8-Q22). Let me re-check:
        #   4-6m: Q8-Q22 → Q22 first appears at 4m
        # So Q22 minimum is 4 months, not 13. Q22 spans bands 4-6m through
        # 13-15m. Already covered by C16 gate (q_child_age_months.outcome >= 4).
        # -----------------------------------------------------------------

        # MSD-Q22
        - id: q_msd_q22
          kind: Question
          title: "Has this child ever waved good-bye without help from another person?"
          precondition:
            - predicate: q_child_age_months.outcome >= 4
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -----------------------------------------------------------------
        # MSD-C23: IF AGE 4-6 MONTHS → exit to Relationships
        # Modeled as: Q23+ requires q_child_age_months.outcome >= 7
        # -----------------------------------------------------------------

        # MSD-Q23
        - id: q_msd_q23
          kind: Question
          title: "Has he/she ever shown by his/her behavior that he/she knows the names of common objects when somebody else names them out loud?"
          precondition:
            - predicate: q_child_age_months.outcome >= 7
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q24
        - id: q_msd_q24
          kind: Question
          title: "Has he/she ever shown that he/she wanted something by pointing, pulling, or making pleasant sounds rather than crying or whining?"
          precondition:
            - predicate: q_child_age_months.outcome >= 7
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q25
        - id: q_msd_q25
          kind: Question
          title: "Has he/she ever stood alone on his/her feet for 10 seconds or more without holding on to anything or another person?"
          precondition:
            - predicate: q_child_age_months.outcome >= 7
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q26
        - id: q_msd_q26
          kind: Question
          title: "Has this child ever walked at least 2 steps without holding on to anything or another person?"
          precondition:
            - predicate: q_child_age_months.outcome >= 7
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -----------------------------------------------------------------
        # MSD-C27: IF AGE 7-9 MONTHS → exit to Relationships
        # Modeled as: Q27+ requires q_child_age_months.outcome >= 10
        # -----------------------------------------------------------------

        # MSD-Q27
        - id: q_msd_q27
          kind: Question
          title: "Has he/she ever crawled up at least 2 stairs or steps?"
          precondition:
            - predicate: q_child_age_months.outcome >= 10
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q28
        - id: q_msd_q28
          kind: Question
          title: "Has he/she said 2 recognizable words besides \"mama\" or \"dada\"?"
          precondition:
            - predicate: q_child_age_months.outcome >= 10
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
            - predicate: q_child_age_months.outcome >= 10
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q30
        - id: q_msd_q30
          kind: Question
          title: "Has he/she ever said the name of a familiar object, such as a ball?"
          precondition:
            - predicate: q_child_age_months.outcome >= 10
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q31
        - id: q_msd_q31
          kind: Question
          title: "Has he/she ever made a line with a crayon or pencil?"
          precondition:
            - predicate: q_child_age_months.outcome >= 10
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q32
        - id: q_msd_q32
          kind: Question
          title: "Did he/she ever walk up at least 2 stairs with one hand held or holding the railing?"
          precondition:
            - predicate: q_child_age_months.outcome >= 10
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -----------------------------------------------------------------
        # MSD-C33: IF AGE 10-12 MONTHS → exit to Relationships
        # Modeled as: Q33+ requires q_child_age_months.outcome >= 13
        # -----------------------------------------------------------------

        # MSD-Q33
        - id: q_msd_q33
          kind: Question
          title: "Has he/she ever fed him/herself with a spoon or fork without spilling much?"
          precondition:
            - predicate: q_child_age_months.outcome >= 13
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
            - predicate: q_child_age_months.outcome >= 13
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q35
        - id: q_msd_q35
          kind: Question
          title: "Has he/she ever spoken a partial sentence of 3 words or more?"
          precondition:
            - predicate: q_child_age_months.outcome >= 13
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q36
        - id: q_msd_q36
          kind: Question
          title: "Has he/she ever walked up stairs by him/herself without holding on to a rail?"
          precondition:
            - predicate: q_child_age_months.outcome >= 13
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -----------------------------------------------------------------
        # MSD-C37: IF AGE 13-15 MONTHS → exit to Relationships
        # Modeled as: Q37+ requires q_child_age_months.outcome >= 16
        # -----------------------------------------------------------------

        # MSD-Q37
        - id: q_msd_q37
          kind: Question
          title: "Has he/she ever washed and dried his/her hands without any help except for turning the water on and off?"
          precondition:
            - predicate: q_child_age_months.outcome >= 16
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q38
        - id: q_msd_q38
          kind: Question
          title: "Has he/she ever counted 3 objects correctly?"
          precondition:
            - predicate: q_child_age_months.outcome >= 16
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q39
        - id: q_msd_q39
          kind: Question
          title: "Has he/she ever gone to the toilet alone?"
          precondition:
            - predicate: q_child_age_months.outcome >= 16
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q40
        - id: q_msd_q40
          kind: Question
          title: "Has he/she ever walked upstairs by him/herself with no help, stepping on each step with only one foot?"
          precondition:
            - predicate: q_child_age_months.outcome >= 16
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -----------------------------------------------------------------
        # MSD-C41: IF AGE 16-18 MONTHS → exit to Relationships
        # Modeled as: Q41+ requires q_child_age_months.outcome >= 19
        # -----------------------------------------------------------------

        # MSD-Q41
        - id: q_msd_q41
          kind: Question
          title: "Does he/she know his/her own age and sex?"
          precondition:
            - predicate: q_child_age_months.outcome >= 19
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q42
        - id: q_msd_q42
          kind: Question
          title: "Has he/she ever said the names of at least 4 colors?"
          precondition:
            - predicate: q_child_age_months.outcome >= 19
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q43
        - id: q_msd_q43
          kind: Question
          title: "Has he/she ever pedaled a tricycle at least 10 feet?"
          precondition:
            - predicate: q_child_age_months.outcome >= 19
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -----------------------------------------------------------------
        # MSD-C44: IF AGE 19-21 MONTHS → exit to Relationships
        # Modeled as: Q44+ requires q_child_age_months.outcome >= 22
        # -----------------------------------------------------------------

        # MSD-Q44
        - id: q_msd_q44
          kind: Question
          title: "Has he/she ever done a somersault without help from anybody?"
          precondition:
            - predicate: q_child_age_months.outcome >= 22
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q45
        - id: q_msd_q45
          kind: Question
          title: "Has he/she ever dressed him/herself without any help except for tying shoes and buttoning the backs of dresses?"
          precondition:
            - predicate: q_child_age_months.outcome >= 22
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q46
        - id: q_msd_q46
          kind: Question
          title: "Has he/she ever said his/her first and last name together without someone's help? (Nickname may be used for first name.)"
          precondition:
            - predicate: q_child_age_months.outcome >= 22
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q47
        - id: q_msd_q47
          kind: Question
          title: "Has he/she ever counted out loud up to 10?"
          precondition:
            - predicate: q_child_age_months.outcome >= 22
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MSD-Q48
        - id: q_msd_q48
          kind: Question
          title: "Has he/she ever drawn a picture of a man or woman with at least 2 parts of the body besides a head?"
          precondition:
            - predicate: q_child_age_months.outcome >= 22
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
    #         precondition q_child_age.outcome >= 4.
    # REL-I1: Introduction (all age 4+)
    # REL-Q1: Days with friends (all age 4+)
    # REL-C2: IF AGE < 6 → skip to Q6. Q2 has precondition q_child_age.outcome >= 6.
    # REL-Q2: Close friends count. If NONE → skip Q3-Q5.
    # REL-C3/C4: IF AGE < 8 → skip to Q6. Q3-Q5 have precondition q_child_age.outcome >= 8.
    # REL-Q3: Friends known by name
    # REL-Q4: Making new friends
    # REL-Q5: Friends in trouble
    # =========================================================================
    - id: b_rel_friendships
      kind: Group
      title: "Relationships - Friendships"
      precondition:
        - predicate: q_child_age.outcome >= 4
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
            - predicate: q_child_age.outcome >= 6
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
            - predicate: q_child_age.outcome >= 8
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
            - predicate: q_child_age.outcome >= 8
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
            - predicate: q_child_age.outcome >= 8
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
    # REL-C9: IF no siblings → skip Q9. Modeled with q_has_siblings.outcome == 1.
    # REL-Q9: Getting along with siblings (same scale, conditional)
    # =========================================================================
    - id: b_rel_getting_along
      kind: Group
      title: "Relationships - Getting Along"
      precondition:
        - predicate: q_child_age.outcome >= 4
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
            - predicate: q_has_siblings.outcome == 1
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
    # Modeled as block precondition: PMK or PMK spouse/partner (not foster).
    # PAR-I1: Intro
    # PAR-Q1-Q6: 6 positive interaction items (5-point frequency)
    # PAR-C7: IF age < 3 → Q7A; ELSE → Q7. Mutually exclusive variants.
    # =========================================================================
    - id: b_par_positive
      kind: Group
      title: "Parenting - Positive Interaction"
      precondition:
        - predicate: q_pickresp.outcome in [1, 2]
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
            - predicate: q_child_age.outcome >= 3
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
            - predicate: q_child_age.outcome < 3
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
    #         precondition q_child_age.outcome >= 2.
    # PAR-I8A: Intro
    # PAR-Q8-Q18: 11 discipline items (5-point proportion scale)
    # =========================================================================
    - id: b_par_discipline
      kind: Group
      title: "Parenting - Discipline Effectiveness"
      precondition:
        - predicate: q_pickresp.outcome in [1, 2]
        - predicate: relationship_to_child != 4
        - predicate: q_child_age.outcome >= 2
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
      kind: Group
      title: "Parenting - Reactions to Rule-Breaking"
      precondition:
        - predicate: q_pickresp.outcome in [1, 2]
        - predicate: relationship_to_child != 4
        - predicate: q_child_age.outcome >= 2
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
      kind: Group
      title: "Parenting - Food Security and Exposure"
      precondition:
        - predicate: q_pickresp.outcome in [1, 2]
        - predicate: relationship_to_child != 4
        - predicate: q_child_age.outcome >= 2
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
      kind: Group
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
      kind: Group
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
      kind: Group
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
      kind: Group
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
      kind: Group
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
      kind: Group
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
      kind: Group
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
      kind: Group
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
      kind: Group
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
      kind: Group
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
      kind: Group
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
      kind: Group
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
      kind: Group
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
      kind: Group
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
      kind: Group
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
            - predicate: q_child_age.outcome >= 4
          input:
            control: Switch
            off: "No"
            on: "Yes"

        - id: q_car_q1h1
          kind: Question
          title: "For about how many hours per week is that? (Before/after school program)"
          precondition:
            - predicate: q_child_age.outcome >= 4
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
            - predicate: q_child_age.outcome >= 6
          input:
            control: Switch
            off: "No"
            on: "Yes"

        - id: q_car_q1i1
          kind: Question
          title: "For about how many hours per week is that? (Self-care)"
          precondition:
            - predicate: q_child_age.outcome >= 6
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
      kind: Group
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
            - predicate: q_child_age.outcome <= 5
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
      kind: Group
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
      kind: Group
      title: "Previous Child Care"
      precondition:
        - predicate: q_car_q1a.outcome == 0
        - predicate: q_child_age.outcome >= 1
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
      kind: Group
      title: "Overall Child Care Changes"
      precondition:
        - predicate: (q_car_q1a.outcome == 1 and q_child_age.outcome >= 1) or (q_car_q1a.outcome == 0 and q_child_age.outcome >= 1 and q_car_q6.outcome == 1)
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
            - predicate: q_child_age.outcome >= 6
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

    # =========================================================================
    # APPENDICES (source pp. 161-244) — converted 2026-07-19.
    # Appendix B (Informed Consent Form, pp. 185-187) is procedural: its
    # consent OUTCOME enters as q_adm_consent_selfreport below.
    # =========================================================================
    # =========================================================================
    # APPENDIX ADMINISTRATION (external inputs for Appendices A, C, D, E, F)
    # =========================================================================
    # The appendix instruments depend on values the main interview does not
    # collect: the selected child's sex (household roster), the informed-consent
    # outcome (Appendix B form), whether the teacher/principal mail-back forms
    # were administered and returned, and the data-collection period that gates
    # the NPHS integration (Appendix E; KCON-Q1A vs Q1B on p.235).
    # Modeled as admin questions per the External-input convention (Pattern 10)
    # until first-class external inputs exist (askalot-io/askalot#171).
    # =========================================================================
    - id: b_appendix_admin
      kind: Group
      title: "Appendix Administration (administrative)"
      items:
        # EXTERNAL — child's sex from the household roster (App. A Section F gates)
        - id: q_adm_child_sex
          kind: Question
          title: "ADMIN: Sex of the selected child (from household roster)."
          input:
            control: Radio
            labels:
              1: "Male"
              2: "Female"

        # EXTERNAL — Appendix B informed-consent outcome (gates the App. A booklet)
        - id: q_adm_consent_selfreport
          kind: Question
          title: "ADMIN: Was informed consent (Appendix B) given for the 10-11 year old self-report booklet?"
          precondition:
            - predicate: q_child_age.outcome >= 10
          input:
            control: Switch
            "off": "No"
            "on": "Yes"

        # EXTERNAL — Teacher's Questionnaire administered and returned (App. C)
        - id: q_adm_teacher_form
          kind: Question
          title: "ADMIN: Was the Teacher's Questionnaire (Appendix C) administered and returned?"
          precondition:
            - predicate: q_edu_q1.outcome >= 2
          input:
            control: Switch
            "off": "No"
            "on": "Yes"

        # EXTERNAL — Principal's Questionnaire administered and returned (App. D)
        - id: q_adm_principal_form
          kind: Question
          title: "ADMIN: Was the Principal's Questionnaire (Appendix D) administered and returned?"
          precondition:
            - predicate: q_edu_q1.outcome >= 2
          input:
            control: Switch
            "off": "No"
            "on": "Yes"

        # EXTERNAL — data-collection period (source p.230/p.235: integrated
        # NLSC+NPHS in Nov 1994 / Mar 1995; NLSC-only in Dec 1994 / Feb 1995).
        # Gates Appendix E entirely and selects KCON-Q1A vs KCON-Q1B.
        - id: q_adm_collection_period
          kind: Question
          title: "ADMIN: Which data-collection period is this interview in?"
          input:
            control: Radio
            labels:
              1: "Integrated NLSC + NPHS collection (Nov 1994 / Mar 1995)"
              2: "NLSC-only collection (Dec 1994 / Feb 1995)"

    # =========================================================================
    # APPENDIX A — Questionnaire for 10-11 Year Olds (self-report booklet)
    # Source: NLSCY inventory Appendix A, pages 162-184, 135 items.
    # Self-administered by the selected child; almost all items are Likert/scale
    # batteries with no skip routing. Every block is gated by the hoisted
    # eligibility+consent gate (child aged 10-11 AND Appendix B consent given).
    # External inputs (not asked in this booklet): q_child_age (roster),
    # q_adm_child_sex (roster, Section F gates), q_adm_consent_selfreport (App. B).
    # =========================================================================

    # =========================================================================
    # SECTION A — Friends and Family (p.164-166) — 12 items
    # A.01-A.04 share a 5-point False->True scale but are numbered individually
    # in the source, so kept as standalone Questions (not a QuestionGroup).
    # Skip: A.07=Yes -> A.08 (relationships); A.09 asked of all per source.
    # =========================================================================
    - id: b_sr_friends
      kind: Group
      title: "About My Friends and Family"
      precondition:
        - predicate: q_child_age.outcome >= 10
        - predicate: q_adm_consent_selfreport.outcome == 1
      items:
        # A.01
        - id: q_sr_a01
          kind: Question
          title: "I have a lot of friends."
          input:
            control: Radio
            labels:
              1: "False"
              2: "Mostly false"
              3: "Sometimes false / Sometimes true"
              4: "Mostly true"
              5: "True"

        # A.02
        - id: q_sr_a02
          kind: Question
          title: "I get along with kids easily."
          input:
            control: Radio
            labels:
              1: "False"
              2: "Mostly false"
              3: "Sometimes false / Sometimes true"
              4: "Mostly true"
              5: "True"

        # A.03
        - id: q_sr_a03
          kind: Question
          title: "Other kids want me to be their friend."
          input:
            control: Radio
            labels:
              1: "False"
              2: "Mostly false"
              3: "Sometimes false / Sometimes true"
              4: "Mostly true"
              5: "True"

        # A.04
        - id: q_sr_a04
          kind: Question
          title: "Most other kids like me."
          input:
            control: Radio
            labels:
              1: "False"
              2: "Mostly false"
              3: "Sometimes false / Sometimes true"
              4: "Mostly true"
              5: "True"

        # A.05 — 6 options -> Dropdown
        - id: q_sr_a05
          kind: Question
          title: "About how many days a week do you do things with friends outside of school hours?"
          input:
            control: Dropdown
            labels:
              0: "Never"
              1: "Less than once a week"
              2: "1 day a week"
              3: "2-3 days a week"
              4: "4-5 days a week"
              5: "6-7 days a week"

        # A.06 — 2-digit count; "If none write 00"
        - id: q_sr_a06
          kind: Question
          title: "How many close friends do you have?"
          input:
            control: Editbox
            min: 0
            max: 99
            right: "close friends"

        # A.07 — Yes/No screener for A.08
        - id: q_sr_a07
          kind: Question
          title: "Other than your friends, do you have anyone else in particular you can talk to about yourself or your problems?"
          input:
            control: Switch
            "off": "No"
            "on": "Yes"

        # A.08 — multi-select; asked only if A.07 = Yes (Switch on -> outcome 1)
        - id: q_sr_a08
          kind: Question
          title: "What is their relationship to you? (Mark everyone you feel you can talk to about yourself or your problems)"
          precondition:
            - predicate: q_sr_a07.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "Mother"
              2: "Father"
              4: "Stepmother"
              8: "Stepfather"
              16: "Brother"
              32: "Sister"
              64: "Grandparents"
              128: "Other relatives"
              256: "A friend of the family"
              512: "Sitter or babysitter"
              1024: "Parent's boyfriend/girlfriend"
              2048: "Teacher"
              4096: "Coach or leader (e.g. scout or church leader)"
              8192: "Other"

        # A.09 — asked of all (ungated per source)
        - id: q_sr_a09
          kind: Question
          title: "During the past 6 months, how well have you gotten along with other children such as friends or classmates?"
          input:
            control: Radio
            labels:
              1: "Very well, no problems"
              2: "Quite well, hardly any problems"
              3: "Pretty well, occasional problems"
              4: "Not too well, frequent problems"
              5: "Not well at all, constant problems"

        # A.10 — 6 options -> Dropdown
        - id: q_sr_a10
          kind: Question
          title: "During the past 6 months, how well have you gotten along with your mother?"
          input:
            control: Dropdown
            labels:
              1: "Very well, no problems"
              2: "Quite well, hardly any problems"
              3: "Pretty well, occasional problems"
              4: "Not too well, frequent problems"
              5: "Not well at all, constant problems"
              6: "Don't have a mother or am not in touch with her"

        # A.11 — 6 options -> Dropdown
        - id: q_sr_a11
          kind: Question
          title: "During the past 6 months, how well have you gotten along with your father?"
          input:
            control: Dropdown
            labels:
              1: "Very well, no problems"
              2: "Quite well, hardly any problems"
              3: "Pretty well, occasional problems"
              4: "Not too well, frequent problems"
              5: "Not well at all, constant problems"
              6: "Don't have a father or am not in touch with him"

        # A.12 — 6 options -> Dropdown
        - id: q_sr_a12
          kind: Question
          title: "During the past 6 months, how well have you gotten along with your brothers and sisters?"
          input:
            control: Dropdown
            labels:
              1: "Very well, no problems"
              2: "Quite well, hardly any problems"
              3: "Pretty well, occasional problems"
              4: "Not too well, frequent problems"
              5: "Not well at all, constant problems"
              6: "Don't have brothers and sisters or am not in touch with them"

    # =========================================================================
    # SECTION B — School (p.167-170) — 17 items
    # B.04-B.10 and B.14-B.17 share scales but are individually numbered in the
    # source; kept as standalone Questions per the item-id scheme. No skips.
    # =========================================================================
    - id: b_sr_school
      kind: Group
      title: "About My School and Me"
      precondition:
        - predicate: q_child_age.outcome >= 10
        - predicate: q_adm_consent_selfreport.outcome == 1
      items:
        # B.01
        - id: q_sr_b01
          kind: Question
          title: "How do you feel about school?"
          input:
            control: Radio
            labels:
              1: "I like school very much"
              2: "I like school quite a bit"
              3: "I like school a bit"
              4: "I don't like school very much"
              5: "I hate school"

        # B.02
        - id: q_sr_b02
          kind: Question
          title: "How well do you think you are doing in your school work?"
          input:
            control: Radio
            labels:
              1: "Very well"
              2: "Well"
              3: "Average"
              4: "Poorly"
              5: "Very poorly"

        # B.03
        - id: q_sr_b03
          kind: Question
          title: "How important is it to you to have good grades in school?"
          input:
            control: Radio
            labels:
              1: "Very important"
              2: "Important"
              3: "Somewhat important"
              4: "Not very important"
              5: "Not important at all"

        # B.04 — False->True 5-point
        - id: q_sr_b04
          kind: Question
          title: "I like mathematics."
          input:
            control: Radio
            labels:
              1: "False"
              2: "Mostly false"
              3: "Sometimes false / Sometimes true"
              4: "Mostly true"
              5: "True"

        # B.05 — All the time->Never frequency
        - id: q_sr_b05
          kind: Question
          title: "I feel safe at school."
          input:
            control: Radio
            labels:
              1: "All the time"
              2: "Most of the time"
              3: "Some of the time"
              4: "Rarely"
              5: "Never"

        # B.06
        - id: q_sr_b06
          kind: Question
          title: "I feel safe on my way to and from school."
          input:
            control: Radio
            labels:
              1: "All the time"
              2: "Most of the time"
              3: "Some of the time"
              4: "Rarely"
              5: "Never"

        # B.07
        - id: q_sr_b07
          kind: Question
          title: "Children say nasty and unpleasant things to me at school."
          input:
            control: Radio
            labels:
              1: "All the time"
              2: "Most of the time"
              3: "Some of the time"
              4: "Rarely"
              5: "Never"

        # B.08
        - id: q_sr_b08
          kind: Question
          title: "I am bullied in school."
          input:
            control: Radio
            labels:
              1: "All the time"
              2: "Most of the time"
              3: "Some of the time"
              4: "Rarely"
              5: "Never"

        # B.09
        - id: q_sr_b09
          kind: Question
          title: "I am bullied on my way to and from school."
          input:
            control: Radio
            labels:
              1: "All the time"
              2: "Most of the time"
              3: "Some of the time"
              4: "Rarely"
              5: "Never"

        # B.10
        - id: q_sr_b10
          kind: Question
          title: "I feel like an outsider (or left out of things) at my school."
          input:
            control: Radio
            labels:
              1: "All the time"
              2: "Most of the time"
              3: "Some of the time"
              4: "Rarely"
              5: "Never"

        # B.11 — 6 options -> Dropdown (adds "Don't need extra help")
        - id: q_sr_b11
          kind: Question
          title: "When I need extra help, my teacher gives it to me."
          input:
            control: Dropdown
            labels:
              1: "All the time"
              2: "Most of the time"
              3: "Some of the time"
              4: "Rarely"
              5: "Never"
              6: "Don't need extra help"

        # B.12
        - id: q_sr_b12
          kind: Question
          title: "My teacher treats me fairly."
          input:
            control: Radio
            labels:
              1: "All the time"
              2: "Most of the time"
              3: "Some of the time"
              4: "Rarely"
              5: "Never"

        # B.13 — 6 options -> Dropdown (adds "Don't have problems at school")
        - id: q_sr_b13
          kind: Question
          title: "If I have problems at school, my parents are ready to help."
          input:
            control: Dropdown
            labels:
              1: "All the time"
              2: "Most of the time"
              3: "Some of the time"
              4: "Rarely"
              5: "Never"
              6: "Don't have problems at school"

        # B.14
        - id: q_sr_b14
          kind: Question
          title: "My parents encourage me to do well at school."
          input:
            control: Radio
            labels:
              1: "All the time"
              2: "Most of the time"
              3: "Some of the time"
              4: "Rarely"
              5: "Never"

        # B.15
        - id: q_sr_b15
          kind: Question
          title: "My parents expect too much of me at school."
          input:
            control: Radio
            labels:
              1: "All the time"
              2: "Most of the time"
              3: "Some of the time"
              4: "Rarely"
              5: "Never"

        # B.16
        - id: q_sr_b16
          kind: Question
          title: "I have a place at home to do homework or study."
          input:
            control: Radio
            labels:
              1: "All the time"
              2: "Most of the time"
              3: "Some of the time"
              4: "Rarely"
              5: "Never"

        # B.17
        - id: q_sr_b17
          kind: Question
          title: "When my teacher gives me homework, I do it."
          input:
            control: Radio
            labels:
              1: "All the time"
              2: "Most of the time"
              3: "Some of the time"
              4: "Rarely"
              5: "Never"

    # =========================================================================
    # SECTION C — About Me (p.171) — 8 items
    # C.01 a-h is an explicit grid battery -> single QuestionGroup, shared
    # 5-point False->True Radio scale.
    # =========================================================================
    - id: b_sr_aboutme
      kind: Group
      title: "About Me"
      precondition:
        - predicate: q_child_age.outcome >= 10
        - predicate: q_adm_consent_selfreport.outcome == 1
      items:
        - id: qg_sr_c01
          kind: QuestionGroup
          title: "Read the following statements and choose the answer that best describes how you feel."
          questions:
            - "In general, I like the way I am."
            - "Overall I have a lot to be proud of."
            - "A lot of things about me are good."
            - "When I do something, I do it well."
            - "I am good looking."
            - "I have a pleasant looking face."
            - "Other kids think I am good looking."
            - "I have a good looking body."
          input:
            control: Radio
            labels:
              1: "False"
              2: "Mostly false"
              3: "Sometimes false / Sometimes true"
              4: "Mostly true"
              5: "True"

    # =========================================================================
    # SECTION D — Feelings and Behaviours (p.172-176) — 54 items
    # D.01 a-uu (47) -> QuestionGroup, shared 3-point scale.
    # D.02 a-f (6) -> QuestionGroup, shared 4-point scale ("In the past year...").
    # D.03 -> standalone Yes/No Question.
    # =========================================================================
    - id: b_sr_feelings
      kind: Group
      title: "Feelings and Behaviours"
      precondition:
        - predicate: q_child_age.outcome >= 10
        - predicate: q_adm_consent_selfreport.outcome == 1
      items:
        # D.01 a-uu (47 sub-items)
        - id: qg_sr_d01
          kind: QuestionGroup
          title: "Read the following statements and choose the answer that best describes you."
          questions:
            - "I show sympathy to (feel sorry for) someone who has made a mistake"
            - "I can't sit still, am restless or hyperactive"
            - "I destroy my own things"
            - "I will try to help someone who has been hurt"
            - "I steal at home"
            - "I am unhappy, sad or depressed"
            - "I get into many fights"
            - "I volunteer to help clear up a mess someone else has made"
            - "I am distractible, have trouble sticking to any activity"
            - "I try when I am mad at someone, to get others to dislike him/her"
            - "I am not as happy as other children"
            - "I destroy things belonging to my family or other children"
            - "I will try, if there is an argument, to stop it"
            - "I fidget"
            - "I am disobedient at school"
            - "I can't concentrate, can't pay attention"
            - "I am too fearful or anxious"
            - "When I am mad at someone, I become friends with another as revenge"
            - "I am impulsive, act without thinking"
            - "I tell lies or cheat"
            - "I offer to help other children (friend, brother or sister) who are having difficulty with a task"
            - "I am worried"
            - "I have difficulty awaiting my turn in games or groups"
            - "I assume, when another child accidentally hurts me (such as bumping into me), that the other child meant to do it, and then react with anger and fighting"
            - "I tend to do things on my own - am rather solitary"
            - "When mad at someone, I say bad things behind the other's back"
            - "I physically attack people"
            - "I comfort a child (friend, brother or sister) who is crying or upset"
            - "I cry a lot"
            - "I vandalize"
            - "I give up easily"
            - "I threaten people"
            - "I help to pick up objects which another child has dropped (e.g. pencils, books.)"
            - "I cannot settle to anything for more than a few moments"
            - "I feel miserable, unhappy, tearful, or distressed"
            - "I am cruel, bully or am mean to others"
            - "I stare into space"
            - "When mad at someone, I say to others: let's not be with him/her"
            - "I am nervous, highstrung or tense"
            - "I kick, bite, hit other children"
            - "I will invite bystanders to join in a game"
            - "I steal outside the home"
            - "I am inattentive, have difficulty paying attention to someone"
            - "I have trouble enjoying myself"
            - "I help other children (friends, brother or sister) who are feeling sick"
            - "When mad at someone, I tell the other one's secrets to a third person"
            - "I take the opportunity to show support for the work of children who can't do things as well as me"
          input:
            control: Radio
            labels:
              1: "Never or not true"
              2: "Sometimes or somewhat true"
              3: "Often or very true"

        # D.02 a-f (6 sub-items)
        - id: qg_sr_d02
          kind: QuestionGroup
          title: "In the past year, about how many times..."
          questions:
            - "...did you stay out later than your parents said you should?"
            - "...did you stay out all night without permission?"
            - "...did you skip a day of school without permission?"
            - "...did you get drunk?"
            - "...were you questioned by the police about anything you might have done such as stealing, damaging property or anything else?"
            - "...did you run away from home?"
          input:
            control: Radio
            labels:
              1: "Never"
              2: "Once"
              3: "Twice"
              4: "More than twice"

        # D.03 — standalone Yes/No
        - id: q_sr_d03
          kind: Question
          title: "In the past year were you part of a group that did bad things?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

    # =========================================================================
    # SECTION E — My Parent(s) and Me (p.177-178) — 17 items
    # E.01 a-q -> single QuestionGroup, shared 4-point scale. Stem carried in
    # the group title.
    # =========================================================================
    - id: b_sr_parents
      kind: Group
      title: "My Parent(s) and Me"
      precondition:
        - predicate: q_child_age.outcome >= 10
        - predicate: q_adm_consent_selfreport.outcome == 1
      items:
        - id: qg_sr_e01
          kind: QuestionGroup
          title: "My parents (or step parents or foster parents)..."
          questions:
            - "...smile at me"
            - "...want to know exactly where I am and what I am doing"
            - "...soon forget a rule they have made"
            - "...praise me"
            - "...let me go out any evening I want"
            - "...do tell me what time to be home when I go out"
            - "...nag me about little things"
            - "...tell me what I can watch on TV"
            - "...make sure I do my homework"
            - "...only keep rules when it suits them"
            - "...make sure I know I am appreciated"
            - "...threaten punishment more often than they use it"
            - "...speak of the good things I do"
            - "...find out about my misbehaviour"
            - "...enforce a rule or do not enforce a rule depending upon their mood"
            - "...hit me or threaten to do so"
            - "...seem proud of the things I do"
          input:
            control: Radio
            labels:
              1: "Never"
              2: "Sometimes"
              3: "Often"
              4: "Very often"

    # =========================================================================
    # SECTION F — Puberty (p.178-179) — 5 items
    # Routes on child's sex (external input q_adm_child_sex: 1=Male, 2=Female).
    # F.01 asked of all; F.02/F.03 girls-only (sex==2); F.04/F.05 boys-only
    # (sex==1). Item preconditions carry the sex residual on top of the block gate.
    # =========================================================================
    - id: b_sr_puberty
      kind: Group
      title: "Puberty"
      precondition:
        - predicate: q_child_age.outcome >= 10
        - predicate: q_adm_consent_selfreport.outcome == 1
      items:
        # F.01 — all children
        - id: q_sr_f01
          kind: Question
          title: "Would you say that your body hair (\"body hair\" means underarm and pubic hair):"
          input:
            control: Radio
            labels:
              1: "has not yet started growing"
              2: "has barely started growing"
              3: "growth of body hair is definitely underway"
              4: "growth of body hair seems completed"

        # F.02 — girls only
        - id: q_sr_f02
          kind: Question
          title: "Have your breasts begun to grow?"
          precondition:
            - predicate: q_adm_child_sex.outcome == 2
          input:
            control: Radio
            labels:
              1: "Not yet started growing"
              2: "Have barely started growing"
              3: "Breast growth is definitely underway"
              4: "Breast growth seems completed"

        # F.03 — girls only
        - id: q_sr_f03
          kind: Question
          title: "Have you begun to menstruate (your monthly periods)?"
          precondition:
            - predicate: q_adm_child_sex.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # F.04 — boys only
        - id: q_sr_f04
          kind: Question
          title: "Have you noticed a deepening of your voice?"
          precondition:
            - predicate: q_adm_child_sex.outcome == 1
          input:
            control: Radio
            labels:
              1: "Not yet started changing"
              2: "Has barely started changing"
              3: "Voice is definitely changing"
              4: "Voice change seems completed"

        # F.05 — boys only
        - id: q_sr_f05
          kind: Question
          title: "Have you begun to grow hair on your face?"
          precondition:
            - predicate: q_adm_child_sex.outcome == 1
          input:
            control: Radio
            labels:
              1: "Not yet started growing"
              2: "Has barely started growing"
              3: "Facial hair growth is definitely underway"
              4: "Facial hair growth seems completed"

    # =========================================================================
    # SECTION G — Smoking, Drinking and Drugs (p.180-183) — 13 items + 1 embedded
    # Skips: G.01=No -> answer embedded "reasons never tried" checkbox (q_sr_g01a);
    # G.02 in {1,2,3,4} -> G.03/G.04 (0 or 5 skip to G.05);
    # G.06=No -> skip G.07/G.08; G.10=No -> skip G.11/G.12.
    # Mined postcondition: screener-consistency between G.01 (ever tried) and
    # G.02 (how often). Age-first-X items (G.03/G.07/G.12) are write-ins with
    # sentinel escapes -> modeled as Editbox age; escape sentinels omitted per
    # skill ("do not transcribe CATI sentinel edits"); no temporal postcondition
    # (see summary).
    # =========================================================================
    - id: b_sr_substances
      kind: Group
      title: "Smoking, Drinking and Drugs"
      precondition:
        - predicate: q_child_age.outcome >= 10
        - predicate: q_adm_consent_selfreport.outcome == 1
      items:
        # G.01
        - id: q_sr_g01
          kind: Question
          title: "Have you ever tried cigarette smoking, even just a few puffs?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # G.01 embedded filter — asked only if G.01 = No
        - id: q_sr_g01a
          kind: Question
          title: "If No, which of the following are the most important reasons why you have never tried smoking?"
          precondition:
            - predicate: q_sr_g01.outcome == 2
          input:
            control: Checkbox
            labels:
              1: "Most of my friends do not smoke"
              2: "My parents do not smoke"
              4: "I think it might be bad for my health"
              8: "I think I might not be able to stop"
              16: "It is against the law for me to smoke"
              32: "I would get into trouble with my parents or teachers"
              64: "I would get into trouble with the police"
              128: "I cannot get cigarettes or afford them"
              256: "I have other things I enjoy doing"
              512: "Some other reason"

        # G.02 — asked of all; 6 options -> Dropdown
        # Screener-consistency: never tried (G.01=No) => must not smoke (code 0).
        - id: q_sr_g02
          kind: Question
          title: "If you do smoke, how often do you smoke cigarettes?"
          postcondition:
            - predicate: q_sr_g01.outcome == 1 or q_sr_g02.outcome == 0
              hint: "You said you have never tried cigarette smoking, so how often you smoke must be 'I do not smoke, or only tried once or twice'."
          input:
            control: Dropdown
            labels:
              0: "I do not smoke, or only tried once or twice"
              1: "Every day"
              2: "At least once or twice a week but not every day"
              3: "At least once or twice a month but not every week"
              4: "A few times a year"
              5: "Once or twice a year"

        # G.03 — regular smokers only (G.02 in 1-4). Age write-in; escape 98 omitted.
        - id: q_sr_g03
          kind: Question
          title: "If you have smoked one or more cigarettes every day for at least 7 days in a row, how old were you when you first did so?"
          precondition:
            - predicate: q_sr_g02.outcome >= 1
            - predicate: q_sr_g02.outcome <= 4
          input:
            control: Editbox
            min: 0
            max: 11
            right: "years old"

        # G.04 — regular smokers only. Count write-in; escape 99 omitted.
        - id: q_sr_g04
          kind: Question
          title: "On the days that you smoke, about how many cigarettes do you usually smoke?"
          precondition:
            - predicate: q_sr_g02.outcome >= 1
            - predicate: q_sr_g02.outcome <= 4
          input:
            control: Editbox
            min: 0
            max: 99
            right: "cigarettes"

        # G.05 — asked of all; 2-digit count, "If none write 00"
        - id: q_sr_g05
          kind: Question
          title: "How many of your friends smoke?"
          input:
            control: Editbox
            min: 0
            max: 99
            right: "friends who smoke"

        # G.06
        - id: q_sr_g06
          kind: Question
          title: "Have you ever drunk alcohol?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # G.07 — drinkers only (G.06=Yes). Age write-in; escapes 98/99 omitted.
        - id: q_sr_g07
          kind: Question
          title: "If you have ever drunk more alcohol than the amount allowed by your parents, how old were you when you first did this?"
          precondition:
            - predicate: q_sr_g06.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 11
            right: "years old"

        # G.08 — drinkers only; 6 options -> Dropdown
        - id: q_sr_g08
          kind: Question
          title: "If you drink anything alcoholic such as wine, liquor or beer, how often do you do so?"
          precondition:
            - predicate: q_sr_g06.outcome == 1
          input:
            control: Dropdown
            labels:
              0: "I do not drink alcohol, or only tried once or twice"
              1: "Every day"
              2: "At least once or twice a week but not every day"
              3: "At least once or twice a month but not every week"
              4: "A few times a year"
              5: "Once or twice a year"

        # G.09 — asked of all; 2-digit count, "If none write 00"
        - id: q_sr_g09
          kind: Question
          title: "How many of your friends drink alcohol?"
          input:
            control: Editbox
            min: 0
            max: 99
            right: "friends who drink alcohol"

        # G.10
        - id: q_sr_g10
          kind: Question
          title: "Have you ever tried drugs or sniffed glue or solvents?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # G.11 — three-part frequency battery -> QuestionGroup (G.10=Yes only).
        # Source prints a per-substance first option ("I do not use marijuana...",
        # "I do not sniff glue...", "I do not use other drugs..."); generalized to
        # one shared scale label with the substance carried in each question text.
        - id: qg_sr_g11
          kind: QuestionGroup
          title: "If you use the following substances, how often do you..."
          precondition:
            - predicate: q_sr_g10.outcome == 1
          questions:
            - "...use marijuana (\"pot\", \"grass\" or \"hash\")?"
            - "...sniff glue or solvents?"
            - "...use other drugs like cocaine, crack, speed, LSD/acid?"
          input:
            control: Radio
            labels:
              1: "I do not use it, or only tried once or twice"
              2: "Every day"
              3: "At least once or twice a week but not every day"
              4: "At least once or twice a month but not every week"
              5: "A few times a year"
              6: "Once or twice a year"

        # G.12 — drug users only (G.10=Yes). Age write-in; escape 99 omitted.
        - id: q_sr_g12
          kind: Question
          title: "If you have used drugs (such as marijuana, glue, solvents or cocaine, etc.) how old were you when you first did so?"
          precondition:
            - predicate: q_sr_g10.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 11
            right: "years old"

        # G.13 — asked of all; 2-digit count, "If none write 00"
        - id: q_sr_g13
          kind: Question
          title: "How many of your friends have tried drugs or sniffed glue or solvents?"
          input:
            control: Editbox
            min: 0
            max: 99
            right: "friends"

    # =========================================================================
    # SECTION H — Activities (p.183-184) — 9 items
    # H.01 a-g -> QuestionGroup, shared 4-point frequency scale.
    # H.02 (5 opts) and H.03 (6 opts -> Dropdown) standalone.
    # =========================================================================
    - id: b_sr_activities
      kind: Group
      title: "Activities"
      precondition:
        - predicate: q_child_age.outcome >= 10
        - predicate: q_adm_consent_selfreport.outcome == 1
      items:
        # H.01 a-g
        - id: qg_sr_h01
          kind: QuestionGroup
          title: "How often do you take part in each of the following?"
          questions:
            - "Outside of school hours, I take part in sports with a coach or an instructor"
            - "Outside of school, I play sports or do physical activities WITHOUT a coach or instructor."
            - "Outside of school hours, I take part in Art, Dance or Music Groups or Lessons"
            - "I take part in Clubs or groups such as Girl Guides or Boy Scouts"
            - "I have a job (a paper route, baby sitting, etc.)"
            - "I play computer or video games"
            - "I watch TV"
          input:
            control: Radio
            labels:
              1: "Never"
              2: "Less than once a week"
              3: "1 to 3 times a week"
              4: "4 or more times a week"

        # H.02 — 5 options
        - id: q_sr_h02
          kind: Question
          title: "On average, about how many hours a day do you watch TV?"
          input:
            control: Radio
            labels:
              1: "0 - 1 hour a day"
              2: "1 - 2 hours a day"
              3: "3 - 4 hours a day"
              4: "5 - 6 hours a day"
              5: "7 or more hours a day"

        # H.03 — 6 options -> Dropdown
        - id: q_sr_h03
          kind: Question
          title: "How often do you read for fun (not just for school)?"
          input:
            control: Dropdown
            labels:
              1: "Every day"
              2: "A few times a week"
              3: "Once a week"
              4: "A few times a month"
              5: "Less than once a month"
              6: "Almost never"

    # =========================================================================
    # APPENDIX C — TEACHER'S QUESTIONNAIRE (source pp.188-212, 58 questions)
    # =========================================================================
    # Mail-back paper instrument answered by the selected child's classroom
    # teacher (a distinct respondent from the household PMK). Every block is
    # hoisted onto the shared gate q_adm_teacher_form.outcome == 1 (the admin
    # item in b_appendix_admin, itself gated on the child being in school via
    # q_edu_q1.outcome >= 2, so the school-enrolment gate is NOT re-added here).
    #
    # Single-select questions preserve the source response codes as label keys
    # (the inventory records them exactly and the printed skip filters branch on
    # them), so every routing precondition below matches the inventory codes
    # verbatim. Rating batteries are modeled as QuestionGroups sharing one Radio
    # scale: the per-row cell codes printed in the source (01/02/03/04/05,
    # 06-10, ...) collapse to the shared 1..N position codes — the answer
    # semantics are preserved, the per-row field codes are not. Multi-select
    # questions are re-encoded to power-of-2 bitmasks (source sequential codes
    # not preserved, per QML Checkbox rules).
    # =========================================================================

    # -------------------------------------------------------------------------
    # SECTION 1 — This Student's Education (source pp.189-195, Q1-Q23)
    # Filter: Q1 == 1 (kindergarten) skips Q2-Q16, resumes at Q17 -> Q2-Q16
    #         carry residual q_tq_q1.outcome == 2.
    # -------------------------------------------------------------------------
    - id: b_tq_s1_education
      kind: Group
      title: "Teacher's Questionnaire — Section 1: This Student's Education"
      precondition:
        - predicate: q_adm_teacher_form.outcome == 1
      items:
        - id: q_tq_intro
          kind: Comment
          title: "The following sections relate to the educational development of a specific student in your class. Please answer all questions by marking the appropriate circle corresponding with your answer in each section. These first few questions ask about this student's grade and educational history."

        - id: q_tq_q1
          kind: Question
          title: "Is this student currently in kindergarten or a similar pre-grade one programme (i.e.: Junior Kindergarten, Primary (Nova Scotia), Nursery (Manitoba), Early Childhood Services (Alberta), or First Year of Primary (British Columbia))?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # Q1 == 1 -> GO TO Q17. Q2-Q16 gated on q_tq_q1.outcome == 2.
        - id: q_tq_q2
          kind: Question
          title: "Is this student assigned to a grade?"
          precondition:
            - predicate: q_tq_q1.outcome == 2
          input:
            control: Radio
            labels:
              3: "Yes"
              4: "No, this student is not assigned to a grade"

        # Follow-up numeric to Q2 (source: "In what grade is this student?", 2-digit)
        - id: q_tq_q2_grade
          kind: Question
          title: "In what grade is this student?"
          precondition:
            - predicate: q_tq_q1.outcome == 2
            - predicate: q_tq_q2.outcome == 3
          input:
            control: Editbox
            min: 0
            max: 99

        - id: q_tq_q3
          kind: Question
          title: "Is this student in a split or multi-grade class?"
          precondition:
            - predicate: q_tq_q1.outcome == 2
          input:
            control: Radio
            labels:
              5: "Yes"
              6: "No, the class contains a single grade"
              7: "No, the class is ungraded"

        # Follow-up range to Q3 (source: "What grades are contained in this class?"
        # grade |_|_| to grade |_|_|). Split into low/high; MINED temporal-ordering
        # constraint: high grade >= low grade (postcondition on the later item).
        - id: q_tq_q3_grade_low
          kind: Question
          title: "What is the lowest grade contained in this class?"
          precondition:
            - predicate: q_tq_q1.outcome == 2
            - predicate: q_tq_q3.outcome == 5
          input:
            control: Editbox
            min: 0
            max: 99

        - id: q_tq_q3_grade_high
          kind: Question
          title: "What is the highest grade contained in this class?"
          precondition:
            - predicate: q_tq_q1.outcome == 2
            - predicate: q_tq_q3.outcome == 5
          postcondition:
            - predicate: q_tq_q3_grade_high.outcome >= q_tq_q3_grade_low.outcome
              hint: "The highest grade in the class cannot be lower than the lowest grade."
          input:
            control: Editbox
            min: 0
            max: 99

        - id: q_tq_q4
          kind: Question
          title: "Has this student ever skipped a grade?"
          precondition:
            - predicate: q_tq_q1.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Don't know"

        - id: q_tq_q5
          kind: Question
          title: "Is this student currently repeating his or her grade?"
          precondition:
            - predicate: q_tq_q1.outcome == 2
          input:
            control: Radio
            labels:
              4: "Yes"
              5: "No"

        - id: q_tq_q6
          kind: Question
          title: "Has this student previously repeated a grade(s), been retained, or not been promoted to a new grade for any reason?"
          precondition:
            - predicate: q_tq_q1.outcome == 2
          input:
            control: Radio
            labels:
              6: "Yes"
              7: "No"
              8: "Don't know"

        - id: q_tq_q7
          kind: Question
          title: "How would you rate this student's current academic achievement in reading?"
          precondition:
            - predicate: q_tq_q1.outcome == 2
          input:
            control: Dropdown
            labels:
              1: "I do not teach reading"
              2: "Near the top of the class"
              3: "Above the middle of the class, but not at the top"
              4: "In the middle of the class"
              5: "Below the middle of the class, but above the bottom"
              6: "Near the bottom of the class"

        - id: q_tq_q8
          kind: Question
          title: "How would you rate this student's current academic achievement in mathematics?"
          precondition:
            - predicate: q_tq_q1.outcome == 2
          input:
            control: Dropdown
            labels:
              7: "I do not teach mathematics"
              8: "Near the top of the class"
              9: "Above the middle of the class, but not at the top"
              10: "In the middle of the class"
              11: "Below the middle of the class, but above the bottom"
              12: "Near the bottom of the class"

        - id: q_tq_q9
          kind: Question
          title: "How would you rate this student's current academic achievement in written work (e.g., spelling and composition)?"
          precondition:
            - predicate: q_tq_q1.outcome == 2
          input:
            control: Dropdown
            labels:
              1: "I do not teach spelling or composition"
              2: "Near the top of the class"
              3: "Above the middle of the class, but not at the top"
              4: "In the middle of the class"
              5: "Below the middle of the class, but above the bottom"
              6: "Near the bottom of the class"

        - id: q_tq_q10
          kind: Question
          title: "How would you rate this student's current academic achievement across all areas of instruction?"
          precondition:
            - predicate: q_tq_q1.outcome == 2
          input:
            control: Radio
            labels:
              7: "Near the top of the class"
              8: "Above the middle of the class, but not at the top"
              9: "In the middle of the class"
              10: "Below the middle of the class, but above the bottom"
              11: "Near the bottom of the class"

        - id: q_tq_q11
          kind: Question
          title: "Looking ahead, how far do you expect this student will go in school? Will he/she..."
          precondition:
            - predicate: q_tq_q1.outcome == 2
          input:
            control: Dropdown
            labels:
              1: "Complete primary/elementary school?"
              2: "Complete some secondary or high school?"
              3: "Graduate from secondary or high school?"
              4: "Obtain a community college, technical college, vocational college, business school, or CEGEP certificate or diploma?"
              5: "Obtain a university degree?"
              6: "Don't know"

        - id: q_tq_q12
          kind: Question
          title: "Overall, how long is one cycle of instruction in this student's homeroom class? (Specify the number of days.)"
          precondition:
            - predicate: q_tq_q1.outcome == 2
          input:
            control: Editbox
            min: 1
            max: 99
            right: "days"

        - id: q_tq_q13
          kind: Question
          title: "How long is the normal school year for this school? (Specify the number of days.)"
          precondition:
            - predicate: q_tq_q1.outcome == 2
          input:
            control: Editbox
            min: 1
            max: 366
            right: "days"

        # Q14: numeric battery, minutes/cycle per instructional area (00000 if none).
        - id: qg_tq_q14
          kind: QuestionGroup
          title: "For the most recent full cycle of instruction, please estimate how much class time this student spent on each of the following. (Number of minutes per cycle; record 00000 if none.)"
          precondition:
            - predicate: q_tq_q1.outcome == 2
          questions:
            - "Reading and other language arts (e.g. spelling, grammar, composition)"
            - "Second language education"
            - "Mathematics"
            - "Science"
            - "Social Studies"
            - "Environmental Studies"
            - "Music"
            - "Art"
            - "Physical Education"
            - "Learning how to use computers"
            - "Other topics"
          input:
            control: Editbox
            min: 0
            max: 99999
            right: "minutes/cycle"

        - id: q_tq_q15
          kind: Question
          title: "How much class time per cycle does this student spend using a computer? (Specify the number of minutes per cycle.)"
          precondition:
            - predicate: q_tq_q1.outcome == 2
          input:
            control: Editbox
            min: 0
            max: 99999
            right: "minutes/cycle"

        - id: q_tq_q16
          kind: Question
          title: "Thinking about the most recent full instructional cycle, what is the main language of instruction in this student's class?"
          precondition:
            - predicate: q_tq_q1.outcome == 2
          input:
            control: Radio
            labels:
              1: "French"
              2: "English"
              3: "An equal combination of French and English"
              4: "Other"

        # Q17: entry point for kindergarten students (Q1 == 1) — no residual.
        - id: qg_tq_q17
          kind: QuestionGroup
          title: "Listed below are a number of different social and personal skills which may be demonstrated in your class. Please indicate how often this student demonstrates each of the following."
          questions:
            - "Works cooperatively with other students"
            - "Plays cooperatively with other students"
            - "Follows rules"
            - "Follows instructions"
            - "Respects the property of others"
            - "Demonstrates self-control"
            - "Shows self-confidence"
            - "Demonstrates respect for adults"
            - "Demonstrates respect for other children"
            - "Accepts responsibility for actions"
          input:
            control: Radio
            labels:
              1: "Never"
              2: "Rarely"
              3: "Sometimes"
              4: "Usually"
              5: "Always"

        - id: qg_tq_q18
          kind: QuestionGroup
          title: "These statements describe the work habits of students. Please indicate how often this student demonstrates each of these work habits."
          questions:
            - "Listens attentively"
            - "Follows directions"
            - "Completes work on time"
            - "Works independently"
            - "Takes care of materials"
            - "Works neatly and carefully"
          input:
            control: Radio
            labels:
              1: "Never"
              2: "Rarely"
              3: "Sometimes"
              4: "Usually"
              5: "Always"

        - id: q_tq_q19
          kind: Question
          title: "Does this student receive enhanced or extra instruction at school because of his/her exceptionally advanced intellectual or artistic abilities?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # Q19 == 2 -> GO TO Q21. Q20 gated on q_tq_q19.outcome == 1.
        - id: q_tq_q20
          kind: Question
          title: "Where does this student receive this enhanced or extra instruction?"
          precondition:
            - predicate: q_tq_q19.outcome == 1
          input:
            control: Dropdown
            labels:
              3: "Exclusively within a regular classroom"
              4: "Primarily within a regular classroom but with some time spent in a special education class or resource room"
              5: "Primarily within a special education class or resource room but with some integration into a regular classroom"
              6: "Exclusively within a special education class or resource room within a regular school"
              7: "Exclusively within a special school in the school district"
              8: "Exclusively within a special residential school"
              9: "Other"

        - id: q_tq_q21
          kind: Question
          title: "Does this student receive special education because a physical, emotional, behavioural, or some other problem limits the kind or amount of school work he/she can do?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # Q21 == 2 -> GO TO Q24. Q22-Q23 gated on q_tq_q21.outcome == 1.
        # Q22: multi-select re-encoded to power-of-2 bitmask (source codes 01-10).
        - id: q_tq_q22
          kind: Question
          title: "What type of problem limits this student's ability to do school work in a regular classroom? (Mark as many as applicable.)"
          precondition:
            - predicate: q_tq_q21.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "A physical disability"
              2: "A visual impairment"
              4: "A hearing impairment"
              8: "A speech impairment"
              16: "A learning disability"
              32: "An emotional or behavioural problem"
              64: "A mental disability or limitation"
              128: "Home environment/problems at home"
              256: "He/she does not understand the language spoken at school"
              512: "Some other type of problem"

        - id: q_tq_q23
          kind: Question
          title: "Where does this student receive this special education?"
          precondition:
            - predicate: q_tq_q21.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Exclusively within a regular classroom"
              2: "Primarily within a regular classroom but with some time spent in a special education class or resource room"
              3: "Primarily within a special education class or resource room but with some integration into a regular classroom"
              4: "Exclusively within a special education class or resource room within a regular school"
              5: "Exclusively within a special school in the school district"
              6: "Exclusively within a special residential school"
              7: "Other"

    # -------------------------------------------------------------------------
    # SECTION 2 — This Student's Behaviour and Absenteeism (source pp.196-199, Q24-Q27)
    # No skip filters in this section.
    # -------------------------------------------------------------------------
    - id: b_tq_s2_behaviour
      kind: Group
      title: "Teacher's Questionnaire — Section 2: This Student's Behaviour and Absenteeism"
      precondition:
        - predicate: q_adm_teacher_form.outcome == 1
      items:
        - id: q_tq_q24
          kind: Question
          title: "About how many regular school days has this student been absent since the beginning of school in the fall? (Specify the number of days absent.)"
          input:
            control: Editbox
            min: 0
            max: 999
            right: "days"

        - id: q_tq_q25
          kind: Question
          title: "Since the beginning of school in the fall about how many times has this student skipped a day of school without permission?"
          input:
            control: Radio
            labels:
              0: "Never"
              1: "Once"
              2: "Twice"
              3: "More than twice"
              4: "Don't know"

        - id: qg_tq_q26
          kind: QuestionGroup
          title: "Since the start of school in the fall, how often has this student arrived..."
          questions:
            - "Without the materials (e.g., notebooks, paper) needed to do his/her schoolwork"
            - "Inadequately clothed to participate in school related activities (e.g., gym, sports, field trips, recess)"
            - "Inadequately dressed for the weather conditions (e.g., canvas running shoes in winter)"
            - "Too tired to do school work"
            - "Without his/her homework completed"
            - "Late for school"
          input:
            control: Radio
            labels:
              1: "Never"
              2: "Rarely"
              3: "Sometimes"
              4: "Usually"
              5: "Always"

        # Q27: 46-item behaviour battery (a-tt), shared 3-point scale.
        - id: qg_tq_q27
          kind: QuestionGroup
          title: "Using the answers never or not true, sometimes or somewhat true and often or very true, how often would you say that this student:"
          questions:
            - "Shows sympathy to someone who has made a mistake"
            - "Can't sit still, is restless or hyperactive"
            - "Destroys his/her own things"
            - "Will try to help someone who has been hurt"
            - "Steals"
            - "Seems to be unhappy, sad or depressed"
            - "Gets into many fights"
            - "Volunteers to help clear up a mess someone else has made"
            - "Is distractible, has trouble sticking to any activity"
            - "When mad at someone tries to get others to dislike her/him"
            - "Is not as happy as other children"
            - "Destroys things belonging to others"
            - "If there is a quarrel or dispute will try to stop it"
            - "Fidgets"
            - "Is disobedient at school"
            - "Can't concentrate, can't pay attention for long"
            - "Is too fearful or anxious"
            - "When mad at someone, becomes friends with another as revenge"
            - "Is impulsive, acts without thinking"
            - "Tells lies or cheats"
            - "Offers to help other children (friend, brother, or sister) who are having difficulty with a task"
            - "Is worried"
            - "Has difficulty awaiting turn in games or groups"
            - "When another child accidentally hurts her/him (such as by bumping into her or him), assumes that the other child meant to do it and then reacts with anger and fighting"
            - "Tends to do things on his/her own - is rather solitary"
            - "When mad at someone, says bad things behind the other's back"
            - "Physically attacks people"
            - "Comforts a child (friend, brother, or sister) who is crying or upset"
            - "Cries a lot"
            - "Vandalizes"
            - "Gives up easily"
            - "Threatens people"
            - "Spontaneously helps to pick up objects which another child has dropped (e.g., pencils, books)"
            - "Cannot settle to anything for more than a few moments"
            - "Appears miserable, unhappy, tearful or distressed"
            - "Is cruel, bullies or is mean to others"
            - "Stares into space"
            - "When mad at someone, says to others: let's not be with her/him"
            - "Is nervous, high-strung, or tense"
            - "Kicks, bites, hits other children"
            - "Will invite bystanders to join in a game"
            - "Is inattentive"
            - "Has trouble enjoying self"
            - "Helps other children (friends, brother or sister) who are feeling sick"
            - "When mad at someone, tells the other one's secrets to a third person"
            - "Takes the opportunity to praise the work of less able children"
          input:
            control: Radio
            labels:
              1: "Never or not true"
              2: "Sometimes or somewhat true"
              3: "Often or very true"

    # -------------------------------------------------------------------------
    # SECTION 3 — Parent's/Guardian's Involvement (source pp.199-200, Q28-Q32)
    # Q32 gates Section 4: only code 5 ("not applicable") falls through to Q33;
    # any actual frequency (codes 6-9) skips Q33-Q46 straight to Q47.
    # -------------------------------------------------------------------------
    - id: b_tq_s3_parents
      kind: Group
      title: "Teacher's Questionnaire — Section 3: Parent's/Guardian's Involvement"
      precondition:
        - predicate: q_adm_teacher_form.outcome == 1
      items:
        - id: qg_tq_q28
          kind: QuestionGroup
          title: "Since the beginning of school last fall did a parent/guardian of this student..."
          questions:
            - "Participate in regularly scheduled parent-teacher conferences (either in person or on the telephone)"
            - "Contact you to discuss this student's academic performance or behaviour"
            - "Return your call to talk about this student's academic performance or behaviour"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Not Applicable"

        - id: q_tq_q29
          kind: Question
          title: "In your opinion, how involved is/are the parent(s)/guardian(s) in this student's education?"
          input:
            control: Radio
            labels:
              1: "Very Involved"
              2: "Somewhat involved"
              3: "Not involved"
              4: "Don't know the parent(s)/guardian(s) well enough"

        - id: q_tq_q30
          kind: Question
          title: "In your opinion, how important is school considered to be to this student's parent(s)/guardian(s)?"
          input:
            control: Radio
            labels:
              5: "Very important"
              6: "Somewhat important"
              7: "Little importance"
              8: "Don't know the parent(s)/guardian(s) well enough"

        - id: q_tq_q31
          kind: Question
          title: "In your opinion, to what extent do the parent(s)/guardian(s) of this student support your teaching efforts?"
          input:
            control: Radio
            labels:
              1: "Strongly support"
              2: "Somewhat support"
              3: "Do not support"
              4: "Don't know the parent(s)/guardian(s) well enough"

        - id: q_tq_q32
          kind: Question
          title: "How often during the past month has a parent/guardian of this child volunteered in your kindergarten class?"
          input:
            control: Radio
            labels:
              5: "Not applicable because the child is not in kindergarten"
              6: "Never"
              7: "Once"
              8: "Twice"
              9: "More than twice"

    # -------------------------------------------------------------------------
    # SECTION 4 — Your Class and Teaching Practices (source pp.201-207, Q33-Q49)
    # Q33-Q46 are gated on q_tq_q32.outcome == 5 (only "not applicable" reaches
    # them; codes 6-9 skip to Q47). Q47-Q49 are the resume point and are NOT
    # gated on Q32 (only the shared block gate). Nested residuals:
    #   Q38 <- Q37==6, Q40 <- Q39==1, Q42 <- Q41==1, Q45/Q46 <- Q44!=5.
    # -------------------------------------------------------------------------
    - id: b_tq_s4_class
      kind: Group
      title: "Teacher's Questionnaire — Section 4: Your Class and Teaching Practices"
      precondition:
        - predicate: q_adm_teacher_form.outcome == 1
      items:
        - id: q_tq_q33
          kind: Question
          title: "Currently, how many students are enrolled in your class? (Specify the number of students.)"
          precondition:
            - predicate: q_tq_q32.outcome == 5
          input:
            control: Editbox
            min: 1
            max: 999
            right: "students"

        # Q34: MINED counts-vs-capacity — each category count cannot exceed the
        # class enrolment (Q33). Modeled as scalar Questions (not a QuestionGroup)
        # so the postconditions stay in this validator's statically-verified
        # subset: it rejects subscript/comprehension postconditions over
        # QuestionGroup outcomes (falls back to runtime-only). "Some children may
        # belong to more than one category," so the counts are NOT summed against
        # Q33 — only each individual count <= Q33.
        - id: q_tq_q34a
          kind: Question
          title: "Including those who have not been officially identified, how many students in your class have a speech, hearing, vision, mobility or other health impairment that affects their learning?"
          precondition:
            - predicate: q_tq_q32.outcome == 5
          postcondition:
            - predicate: q_tq_q34a.outcome <= q_tq_q33.outcome
              hint: "The number of students with a health impairment cannot exceed the number enrolled in your class (Q33)."
          input:
            control: Editbox
            min: 0
            max: 999
            right: "students"

        - id: q_tq_q34b
          kind: Question
          title: "Including those who have not been officially identified, how many students in your class have an emotional, or behavioural problem?"
          precondition:
            - predicate: q_tq_q32.outcome == 5
          postcondition:
            - predicate: q_tq_q34b.outcome <= q_tq_q33.outcome
              hint: "The number of students with an emotional/behavioural problem cannot exceed the number enrolled in your class (Q33)."
          input:
            control: Editbox
            min: 0
            max: 999
            right: "students"

        - id: q_tq_q34c
          kind: Question
          title: "Including those who have not been officially identified, how many students in your class have a learning problem? (e.g.: a problem with attention, memory, reasoning, reading, writing, spelling, or calculation which interferes with learning)"
          precondition:
            - predicate: q_tq_q32.outcome == 5
          postcondition:
            - predicate: q_tq_q34c.outcome <= q_tq_q33.outcome
              hint: "The number of students with a learning problem cannot exceed the number enrolled in your class (Q33)."
          input:
            control: Editbox
            min: 0
            max: 999
            right: "students"

        # Q35: MINED counts-vs-capacity — each count <= class enrolment (Q33).
        # Scalar Questions, same rationale as Q34.
        - id: q_tq_q35a
          kind: Question
          title: "How many students in your class have a first language other than English or French?"
          precondition:
            - predicate: q_tq_q32.outcome == 5
          postcondition:
            - predicate: q_tq_q35a.outcome <= q_tq_q33.outcome
              hint: "The number of students with another first language cannot exceed the number enrolled in your class (Q33)."
          input:
            control: Editbox
            min: 0
            max: 999
            right: "students"

        - id: q_tq_q35b
          kind: Question
          title: "How many students in your class have immigrated to Canada within the last year?"
          precondition:
            - predicate: q_tq_q32.outcome == 5
          postcondition:
            - predicate: q_tq_q35b.outcome <= q_tq_q33.outcome
              hint: "The number of students who immigrated within the last year cannot exceed the number enrolled in your class (Q33)."
          input:
            control: Editbox
            min: 0
            max: 999
            right: "students"

        - id: q_tq_q36
          kind: Question
          title: "Compared with other teachers in your school who are teaching the same grade(s), do you feel that your class has..."
          precondition:
            - predicate: q_tq_q32.outcome == 5
          input:
            control: Radio
            labels:
              1: "Lower overall academic ability than their classes"
              2: "Similar overall academic ability to their classes"
              3: "Higher overall academic ability than their classes"
              4: "A greater diversity of academic abilities than their classes"
              5: "There are no other classes at the same grade(s)"

        - id: q_tq_q37
          kind: Question
          title: "Do you teach reading to your class?"
          precondition:
            - predicate: q_tq_q32.outcome == 5
          input:
            control: Radio
            labels:
              6: "Yes"
              7: "No"

        # Q37 == 7 -> GO TO Q39. Q38 gated on Q37 == 6 (in addition to Q32 == 5).
        - id: qg_tq_q38
          kind: QuestionGroup
          title: "How often do you use each of the following strategies to teach reading to your class?"
          precondition:
            - predicate: q_tq_q32.outcome == 5
            - predicate: q_tq_q37.outcome == 6
          questions:
            - "Teach reading to the class as a whole"
            - "Divide the class into groups having similar reading abilities"
            - "Divide the class into groups having a mixture of reading abilities"
            - "Allow students to form their own reading groups"
            - "Use individualized instruction plans to teach reading"
            - "Other"
          input:
            control: Radio
            labels:
              1: "Never"
              2: "Rarely"
              3: "Sometimes"
              4: "Usually"
              5: "Always"

        - id: q_tq_q39
          kind: Question
          title: "Do you teach writing (composition) to your class?"
          precondition:
            - predicate: q_tq_q32.outcome == 5
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # Q39 == 2 -> GO TO Q41. Q40 gated on Q39 == 1.
        - id: qg_tq_q40
          kind: QuestionGroup
          title: "How often do you use each of the following strategies to teach writing (composition) to your class?"
          precondition:
            - predicate: q_tq_q32.outcome == 5
            - predicate: q_tq_q39.outcome == 1
          questions:
            - "Teach writing to the class as a whole"
            - "Divide the class into groups having similar writing abilities"
            - "Divide the class into groups having a mixture of writing abilities"
            - "Allow students to form their own writing groups"
            - "Use individualized instruction plans to teach writing"
            - "Other"
          input:
            control: Radio
            labels:
              1: "Never"
              2: "Rarely"
              3: "Sometimes"
              4: "Usually"
              5: "Always"

        - id: q_tq_q41
          kind: Question
          title: "Do you teach mathematics to your class?"
          precondition:
            - predicate: q_tq_q32.outcome == 5
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # Q41 == 2 -> GO TO Q43. Q42 gated on Q41 == 1.
        - id: qg_tq_q42
          kind: QuestionGroup
          title: "How often do you use each of the following strategies to teach mathematics to your class?"
          precondition:
            - predicate: q_tq_q32.outcome == 5
            - predicate: q_tq_q41.outcome == 1
          questions:
            - "Teach mathematics to the class as a whole"
            - "Divide the class into groups having similar mathematical abilities"
            - "Divide the class into groups having a mixture of mathematical abilities"
            - "Allow students to form their own mathematics groups"
            - "Use individualized instruction plans to teach mathematics"
            - "Other"
          input:
            control: Radio
            labels:
              1: "Never"
              2: "Rarely"
              3: "Sometimes"
              4: "Usually"
              5: "Always"

        # Q43: numeric battery, minutes/cycle on non-instructional activities.
        - id: qg_tq_q43
          kind: QuestionGroup
          title: "For the most recent full cycle of instruction, please indicate the number of minutes you spent on the following non-instructional activities."
          precondition:
            - predicate: q_tq_q32.outcome == 5
          questions:
            - "Maintaining order and discipline"
            - "Performing routine tasks (e.g., taking attendance, filling out forms)"
            - "Professional discussions with colleagues"
            - "Supervising children at noon/recess"
            - "Assisting/directing extra-curricular activities"
            - "In discussions with students' parents/guardians"
          input:
            control: Editbox
            min: 0
            max: 9999
            right: "minutes/cycle"

        - id: q_tq_q44
          kind: Question
          title: "How often do you assign your class homework? (Do not include students' uncompleted classroom work.)"
          precondition:
            - predicate: q_tq_q32.outcome == 5
          input:
            control: Radio
            labels:
              1: "Always"
              2: "Usually"
              3: "Sometimes"
              4: "Rarely"
              5: "Never"

        # Q44 == 5 (Never) -> GO TO Q47. Q45/Q46 gated on Q44 != 5.
        - id: q_tq_q45
          kind: Question
          title: "Approximately how much homework do you assign each day? (Specify the number of minutes per day.)"
          precondition:
            - predicate: q_tq_q32.outcome == 5
            - predicate: q_tq_q44.outcome != 5
          input:
            control: Editbox
            min: 0
            max: 999
            right: "minutes/day"

        - id: qg_tq_q46
          kind: QuestionGroup
          title: "How often do you monitor homework in the following ways?"
          precondition:
            - predicate: q_tq_q32.outcome == 5
            - predicate: q_tq_q44.outcome != 5
          questions:
            - "By keeping a record of who turned in assignments"
            - "By returning assignments with corrections or grades"
            - "By discussing homework in class"
            - "By having parent(s)/guardian(s) sign a homework book/note"
            - "By student's own or their peer's evaluations"
          input:
            control: Radio
            labels:
              1: "Never"
              2: "Rarely"
              3: "Sometimes"
              4: "Usually"
              5: "Always"

        # Q47: resume point for respondents routed from Q32 codes 6-9 and Q44
        # code 5 — NOT gated on Q32 (block gate only).
        - id: qg_tq_q47
          kind: QuestionGroup
          title: "The following statements describe various attributes about yourself and the students in your classroom. Please indicate the extent to which you agree or disagree with each statement."
          questions:
            - "Many of the students I teach are not capable of mastering the curriculum at their grade"
            - "The emphasis in my classroom is on the development of academic skills"
            - "I have a strong effect on the academic achievement of the students I teach"
            - "I feel competent in dealing with student's behavioural problems"
            - "I feel students' success at school is determined mainly by their home environment"
            - "I have high expectations for the academic success of my students"
            - "I push students to achieve their full academic potential"
          input:
            control: Radio
            labels:
              1: "Strongly disagree"
              2: "Disagree"
              3: "Neither agree nor disagree"
              4: "Agree"
              5: "Strongly agree"

        - id: qg_tq_q48
          kind: QuestionGroup
          title: "Overall, with the exception of a few individual students, the class as a whole..."
          questions:
            - "Moves smoothly from one classroom activity to another"
            - "Is easily distracted by the disruptive behaviour of a few"
            - "Works well together on group activities"
            - "Misbehaves when I am called to the door or must attend to other interruptions"
          input:
            control: Radio
            labels:
              1: "Never"
              2: "Rarely"
              3: "Sometimes"
              4: "Usually"
              5: "Always"

        - id: qg_tq_q49
          kind: QuestionGroup
          title: "Please rate the extent to which each of the following meets the needs of your class."
          questions:
            - "Instructional resources (e.g., curriculum documents, books)"
            - "School supplies (e.g. paper, pencils)"
            - "Space within the classroom"
            - "Computers for course instruction"
            - "Computer software for course instruction"
            - "Audio-visual resources (e.g. VCR's, film projector)"
            - "Science equipment"
            - "Equipment for mathematics instruction"
            - "Special equipment for handicapped students"
            - "Library or teacher-librarian"
            - "Other"
          input:
            control: Radio
            labels:
              1: "Does not meet my needs"
              2: "Partially meets my needs"
              3: "Adequately meets my needs"
              4: "Completely meets my needs"
              5: "Not applicable"

    # -------------------------------------------------------------------------
    # SECTION 5 — Perceptions of Your School (source pp.208-210, Q50-Q51)
    # No skip filters.
    # -------------------------------------------------------------------------
    - id: b_tq_s5_school
      kind: Group
      title: "Teacher's Questionnaire — Section 5: Perceptions of Your School"
      precondition:
        - predicate: q_adm_teacher_form.outcome == 1
      items:
        - id: qg_tq_q50
          kind: QuestionGroup
          title: "Below are a number of statements which describe the social climate of your school. Please indicate how strongly you agree or disagree that each statement is descriptive of your school."
          questions:
            - "The administrative, support, and teaching staff work together as a team"
            - "All staff are involved in decision-making at this school"
            - "School staff know what is expected of them in terms of their roles and responsibilities"
            - "Staff clearly understand school policies and procedures"
            - "Teachers in this school have considerable influence on school policies"
            - "Teachers have a strong influence on how resources (e.g. money, staff, instructional materials) are allocated at this school"
            - "Students clearly understand school rules"
            - "The principal provides support to teachers"
            - "Teachers receive positive feed-back from the principal"
            - "The principal gets around the school to talk to staff"
            - "The principal spends time getting to know students"
            - "The school provides a positive working environment for teachers"
            - "The school provides a positive working environment for students"
          input:
            control: Radio
            labels:
              1: "Strongly disagree"
              2: "Disagree"
              3: "Neither agree nor disagree"
              4: "Agree"
              5: "Strongly agree"

        - id: qg_tq_q51
          kind: QuestionGroup
          title: "Please indicate the extent to which you agree with each of these statements regarding the disciplinary policies of your school."
          questions:
            - "Teachers in this school have reached a consensus about ways to discipline children who break rules"
            - "All children who break rules in this school face the same consequences"
            - "Teachers in this school rarely overlook physical aggression among students"
            - "Teachers in this school rarely overlook verbal aggression among students"
            - "Teachers feel there is insufficient support within the school for managing disciplinary problems"
          input:
            control: Radio
            labels:
              1: "Strongly disagree"
              2: "Disagree"
              3: "Neither agree nor disagree"
              4: "Agree"
              5: "Strongly agree"

    # -------------------------------------------------------------------------
    # SECTION 6 — Personal Information (source pp.210-212, Q52-Q58)
    # No skip filters.
    # -------------------------------------------------------------------------
    - id: b_tq_s6_personal
      kind: Group
      title: "Teacher's Questionnaire — Section 6: Personal Information"
      precondition:
        - predicate: q_adm_teacher_form.outcome == 1
      items:
        - id: q_tq_q52
          kind: Question
          title: "Are you..."
          input:
            control: Radio
            labels:
              1: "Female?"
              2: "Male?"

        - id: q_tq_q53
          kind: Question
          title: "To which age category do you belong?"
          input:
            control: Radio
            labels:
              3: "20 to 29 years"
              4: "30 to 39 years"
              5: "40 to 49 years"
              6: "50 to 59 years"
              7: "60 years or older"

        # Q54: years/months of experience for three roles. Modeled as scalar
        # Questions (not a QuestionGroup) so the ordering postconditions stay
        # statically verified (this validator rejects subscript postconditions).
        # MINED temporal-ordering — experience at this grade and at this school
        # cannot exceed total teaching experience (compared in total months =
        # years*12 + months). Total-teacher fields (ty, tm) are ordered first so
        # they are available to the consumer postconditions on the later items.
        - id: q_tq_q54_ty
          kind: Question
          title: "How much experience do you have as a teacher? (Number of years.)"
          input:
            control: Editbox
            min: 0
            max: 99
            right: "years"

        - id: q_tq_q54_tm
          kind: Question
          title: "How much experience do you have as a teacher? (Additional number of months.)"
          input:
            control: Editbox
            min: 0
            max: 99
            right: "months"

        - id: q_tq_q54_gy
          kind: Question
          title: "How much experience do you have as a teacher at this grade? (Number of years.)"
          input:
            control: Editbox
            min: 0
            max: 99
            right: "years"

        - id: q_tq_q54_gm
          kind: Question
          title: "How much experience do you have as a teacher at this grade? (Additional number of months.)"
          postcondition:
            - predicate: q_tq_q54_gy.outcome * 12 + q_tq_q54_gm.outcome <= q_tq_q54_ty.outcome * 12 + q_tq_q54_tm.outcome
              hint: "Experience teaching at this grade cannot exceed your total teaching experience."
          input:
            control: Editbox
            min: 0
            max: 99
            right: "months"

        - id: q_tq_q54_sy
          kind: Question
          title: "How much experience do you have as a teacher at this school? (Number of years.)"
          input:
            control: Editbox
            min: 0
            max: 99
            right: "years"

        - id: q_tq_q54_sm
          kind: Question
          title: "How much experience do you have as a teacher at this school? (Additional number of months.)"
          postcondition:
            - predicate: q_tq_q54_sy.outcome * 12 + q_tq_q54_sm.outcome <= q_tq_q54_ty.outcome * 12 + q_tq_q54_tm.outcome
              hint: "Experience teaching at this school cannot exceed your total teaching experience."
          input:
            control: Editbox
            min: 0
            max: 99
            right: "months"

        # Q55: multi-select re-encoded to power-of-2 bitmask (source codes 1-11).
        - id: q_tq_q55
          kind: Question
          title: "Please specify the levels of education you have attained? (Mark all that apply.)"
          input:
            control: Checkbox
            labels:
              1: "Some coursework towards a Bachelor's degree"
              2: "A teaching certificate, diploma or licence"
              4: "A Bachelor's degree"
              8: "A Bachelor of Education degree"
              16: "Some post-baccalaureate coursework"
              32: "A post-baccalaureate diploma or certificate"
              64: "Some coursework towards a Master's degree"
              128: "A Master's degree"
              256: "Some coursework towards a Doctorate"
              512: "A Doctorate"
              1024: "Other"

        # Q56: multi-select bitmask (source codes 12-16). MINED none-exclusivity
        # ("None of the above" bit 8 cannot combine with a substantive option)
        # is OMITTED: this validator models a Checkbox outcome as a single
        # selected key rather than a bitmask sum, so the constraint is vacuous
        # in-model (classifies TAUTOLOGICAL) and cannot be statically verified.
        # Enforcement is deferred to post-collection cleaning.
        - id: q_tq_q56
          kind: Question
          title: "Have you obtained any of the following advanced qualifications in special education? (Mark all that apply.)"
          input:
            control: Checkbox
            labels:
              1: "One class in, or part of a special education programme"
              2: "A special education certificate"
              4: "A graduate degree in special education"
              8: "None of the above"
              16: "Other"

        # Q57: multi-select bitmask (source codes 17-21). MINED none-exclusivity
        # OMITTED for the same reason as Q56 (Checkbox modeled single-select).
        - id: q_tq_q57
          kind: Question
          title: "Have you obtained any of the following advanced qualifications in second language education? (Mark all that apply.)"
          input:
            control: Checkbox
            labels:
              1: "One class in, or part of a second language programme"
              2: "A certificate in second language education"
              4: "A graduate degree in second language education"
              8: "None of the above"
              16: "Other"

        - id: q_tq_q58
          kind: Question
          title: "Statistics Canada is conducting this survey jointly with another federal department, Human Resources Development Canada. The information collected will be kept confidential and used only for statistical purposes. Do you agree to share the information collected with Human Resources Development Canada?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # Closing open-comment box (source p.212). Textarea outcome is a string,
        # ignored by Z3 and never referenced in any predicate.
        - id: q_tq_comments
          kind: Question
          title: "THANK YOU FOR COMPLETING THIS QUESTIONNAIRE. Do you have any comments about this survey? If so, please use the space below."
          input:
            control: Textarea
            placeholder: "Comments (optional)..."
            maxLength: 2000

    # =========================================================================
    # APPENDIX D — PRINCIPAL'S QUESTIONNAIRE (source pp.213-228, Q1-Q34)
    # =========================================================================
    # Self-administered mail-back form completed by the selected child's school
    # PRINCIPAL. All routing in the source is printed "GO TO" text (no CATI
    # engine); converted here to preconditions/postconditions.
    #
    # Hoisted gate: the Principal's Questionnaire is only present when the
    # mail-back form was administered and returned, so every block below carries
    # the block-level precondition `q_adm_principal_form.outcome == 1`
    # (q_adm_principal_form lives in the shared b_appendix_admin block).
    #
    # Cover external identifiers — represented as NOTHING in the QML:
    #   D-PRINLANG (Principal's Language, cover field) and D-OPNUM (8-digit
    #   Operation Number) are administrative/linkage identifiers on the cover
    #   sheet, referenced by no routing. Per the External-input convention they
    #   are omitted entirely (no items, no variables); recorded in the inventory
    #   Cover/Administrative section as external identifiers.
    # =========================================================================

    # =========================================================================
    # SECTION 1 — THE STUDENTS IN YOUR SCHOOL (source pp.214-219)
    # Q1-Q15. Classroom-assignment screeners (Q1-Q6), enrolment/composition
    # counts (Q7-Q12), attendance (Q13-Q14), discipline battery (Q15).
    # =========================================================================
    - id: b_pq_s1_students
      kind: Group
      title: "Principal's Questionnaire — The Students in Your School"
      precondition:
        - predicate: q_adm_principal_form.outcome == 1
      items:
        # D-COVER: voluntary-participation / mail-back instruction (Read)
        - id: q_pq_cover
          kind: Comment
          title: "The purpose of this survey is to gather information on various school factors which may influence the development and education of children. Under the Statistics Act the information collected will be kept confidential. Completion of the questionnaire is completely voluntary. When you finish, please place the completed questionnaire in the business reply envelope and mail it to us today. THANK YOU FOR YOUR COOPERATION."

        # D-S1-INT: section instruction (Read) — carries a real "how to answer" instruction
        - id: q_pq_s1_int
          kind: Comment
          title: "The following questions relate to various aspects of your school, its policies, and the students attending your school. Please answer all questions by marking the appropriate circle corresponding with your answer in each section. This section gathers information about students and how they are assigned to classrooms."

        # Q1: any students enrolled in grade 3 or under?
        - id: q_pq_q1
          kind: Question
          title: "Are there students in your school who are enrolled in grade 3 or under? (Please include students enrolled in kindergarten/pre-grade one: junior kindergarten, primary, nursery, early childhood services, or first year of primary.)"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # Q2: enough grade-3-and-under students for more than one class per grade?
        # Source: Q1==No -> GO TO Q4 (skips Q2, Q3). Gate Q2 on Q1==Yes.
        - id: q_pq_q2
          kind: Question
          title: "Does your school contain sufficient students enrolled in grade 3 or under to form more than one class per grade? (Please include kindergarten/pre-grade one classes: junior kindergarten, primary, nursery, early childhood services, or first year of primary.)"
          precondition:
            - predicate: q_pq_q1.outcome == 1
          input:
            control: Radio
            labels:
              3: "Yes"
              4: "No"

        # Q3: grade-3-and-under classroom-assignment battery (8 rows, shared scale)
        # Source: Q2==No -> GO TO Q4 (skips Q3). Gate Q3 on Q1==Yes AND Q2==Yes.
        - id: qg_pq_q3
          kind: QuestionGroup
          title: "In general, how often do you use the following ways to assign students to classrooms for grade 3 and under? (Please include kindergarten/pre-grade 1 classes.)"
          precondition:
            - predicate: q_pq_q1.outcome == 1
            - predicate: q_pq_q2.outcome == 3
          questions:
            - "(a) Students are grouped together more or less at random"
            - "(b) Students are grouped according to similar ability levels"
            - "(c) Students are grouped so that classes contain a mixture of ability levels"
            - "(d) Students are assigned according to the special expertise of teachers"
            - "(e) Assign students to classes composed of students of similar ages"
            - "(f) Groupings are based on social considerations (e.g., friendships, siblings, rivalries)"
            - "(g) Parents'/guardians' requests are considered when grouping students"
            - "(h) Consider teachers' input when grouping students"
          input:
            control: Radio
            labels:
              1: "Never"
              2: "Rarely"
              3: "Sometimes"
              4: "Usually"
              5: "Always"

        # Q4: any students in grade 4 and higher?
        - id: q_pq_q4
          kind: Question
          title: "Are there students in your school who are enrolled in the middle and later elementary grades (grade 4 and higher)?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # Q5: enough grade-4-and-higher students for more than one class per grade?
        # Source: Q4==No -> GO TO Q7 (skips Q5, Q6). Gate Q5 on Q4==Yes.
        - id: q_pq_q5
          kind: Question
          title: "Does your school contain sufficient students in the middle and later elementary grades (grade 4 and higher) to form more than one class per grade?"
          precondition:
            - predicate: q_pq_q4.outcome == 1
          input:
            control: Radio
            labels:
              3: "Yes"
              4: "No"

        # Q6: grade-4-and-higher classroom-assignment battery (8 rows, shared scale)
        # Source: Q5==No -> GO TO Q7 (skips Q6). Gate Q6 on Q4==Yes AND Q5==Yes.
        - id: qg_pq_q6
          kind: QuestionGroup
          title: "In general, how often do you use the following ways to assign students to classrooms for the middle and later elementary grades (grade 4 and higher)?"
          precondition:
            - predicate: q_pq_q4.outcome == 1
            - predicate: q_pq_q5.outcome == 3
          questions:
            - "(a) Students are grouped together more or less at random"
            - "(b) Students are grouped according to similar ability levels"
            - "(c) Students are grouped so that classes contain a mixture of ability levels"
            - "(d) Students are assigned according to the special expertise of teachers"
            - "(e) Assign students to classes composed of students of similar ages"
            - "(f) Groupings are based on social considerations (e.g., friendships, siblings, rivalries)"
            - "(g) Parents'/guardians' requests are considered when grouping students"
            - "(h) Consider teachers' input when grouping students"
          input:
            control: Radio
            labels:
              1: "Never"
              2: "Rarely"
              3: "Sometimes"
              4: "Usually"
              5: "Always"

        # Q7: economic-background percentages — MINED physical-budget constraint:
        #     the three income-band percentages must sum to 100.
        # Q7 modeled as three scalar Questions (not a QuestionGroup): the static
        # builder does not lower QuestionGroup outcome subscripts, so the mined
        # sum-to-100 physical-budget constraint would be runtime-only. Scalars
        # keep it inside the verified envelope (classifies CONSTRAINING).
        - id: q_pq_q7a
          kind: Question
          title: "Economic background of students — (a) High income (family income above $60,000 per year): percentage of families."
          input:
            control: Editbox
            min: 0
            max: 100
            right: "%"
        - id: q_pq_q7b
          kind: Question
          title: "Economic background of students — (b) Middle income (family income between $40,000 and $60,000 per year): percentage of families."
          input:
            control: Editbox
            min: 0
            max: 100
            right: "%"
        - id: q_pq_q7c
          kind: Question
          title: "Economic background of students — (c) Low income (family income below $40,000 per year): percentage of families."
          postcondition:
            - predicate: q_pq_q7a.outcome + q_pq_q7b.outcome + q_pq_q7c.outcome == 100
              hint: "The three economic-background percentages (high, middle, low income) must add up to exactly 100%."
          input:
            control: Editbox
            min: 0
            max: 100
            right: "%"

        # Q8: total enrollment as of first school day, January 1995
        - id: q_pq_q8
          kind: Question
          title: "As of the first day of school in January 1995, what was the total enrollment of your school? (Specify the number of students.)"
          input:
            control: Editbox
            min: 0
            max: 9999
            right: "students"

        # Q9: students with long-term problems — MINED counts-vs-capacity:
        #     each category count cannot exceed total enrollment (Q8).
        #     ("Some students may belong to more than one category", so the three
        #     counts may overlap and are NOT required to sum to anything.)
        # Q9/Q10 modeled as scalar Questions (not QuestionGroups): the static
        # builder does not lower QuestionGroup outcome subscripts, so the mined
        # counts-vs-capacity constraints (each count <= Q8 total enrollment)
        # would be runtime-only. Scalars keep them statically CONSTRAINING.
        # ("Some students may belong to more than one category", so the counts
        # may overlap and are NOT required to sum to anything.)
        - id: q_pq_q9a
          kind: Question
          title: "Including those not officially identified, how many students attending your school have (a) a speech, hearing, vision, mobility or other health impairment that affects their learning?"
          postcondition:
            - predicate: q_pq_q9a.outcome <= q_pq_q8.outcome
              hint: "The count of students with a health impairment cannot exceed the school's total enrollment (Q8)."
          input:
            control: Editbox
            min: 0
            max: 999
            right: "students"
        - id: q_pq_q9b
          kind: Question
          title: "Including those not officially identified, how many students attending your school have (b) an emotional, or behavioural problem?"
          postcondition:
            - predicate: q_pq_q9b.outcome <= q_pq_q8.outcome
              hint: "The count of students with an emotional or behavioural problem cannot exceed the school's total enrollment (Q8)."
          input:
            control: Editbox
            min: 0
            max: 999
            right: "students"
        - id: q_pq_q9c
          kind: Question
          title: "Including those not officially identified, how many students attending your school have (c) a learning problem (a problem with attention, memory, reasoning, reading, writing, spelling, or calculation which interferes with learning)?"
          postcondition:
            - predicate: q_pq_q9c.outcome <= q_pq_q8.outcome
              hint: "The count of students with a learning problem cannot exceed the school's total enrollment (Q8)."
          input:
            control: Editbox
            min: 0
            max: 999
            right: "students"

        # Q10: students by background — MINED counts-vs-capacity: each <= Q8.
        - id: q_pq_q10a
          kind: Question
          title: "How many students attending your school (a) have a first language other than English or French?"
          postcondition:
            - predicate: q_pq_q10a.outcome <= q_pq_q8.outcome
              hint: "The count of students by first language cannot exceed the school's total enrollment (Q8)."
          input:
            control: Editbox
            min: 0
            max: 999
            right: "students"
        - id: q_pq_q10b
          kind: Question
          title: "How many students attending your school (b) have immigrated to Canada within the last year?"
          postcondition:
            - predicate: q_pq_q10b.outcome <= q_pq_q8.outcome
              hint: "The count of recently immigrated students cannot exceed the school's total enrollment (Q8)."
          input:
            control: Editbox
            min: 0
            max: 999
            right: "students"
        - id: q_pq_q10c
          kind: Question
          title: "How many students attending your school (c) are from a rural or farm setting?"
          postcondition:
            - predicate: q_pq_q10c.outcome <= q_pq_q8.outcome
              hint: "The count of students from a rural or farm setting cannot exceed the school's total enrollment (Q8)."
          input:
            control: Editbox
            min: 0
            max: 999
            right: "students"

        # Q11: new students registered mid-year
        # No cross-item constraint: mid-year registrations are a flow, not
        # bounded by the January enrollment snapshot (Q8).
        - id: q_pq_q11
          kind: Question
          title: "Excluding students registering for the first time at the start of your school year, how many students have registered as new students during the course of the school year? (Specify the number of students.)"
          input:
            control: Editbox
            min: 0
            max: 9999
            right: "students"

        # Q12: students who left mid-year (flow; not bounded by Q8 snapshot)
        - id: q_pq_q12
          kind: Question
          title: "Excluding students who must leave your school to attend a higher grade, how many students have left this school during the course of the school year? (Specify the number of students.)"
          input:
            control: Editbox
            min: 0
            max: 9999
            right: "students"

        # Q13: average absenteeism rate (7 options -> Dropdown; source codes 01-07)
        - id: q_pq_q13
          kind: Question
          title: "What is the average absenteeism rate at your school this year? Please only include students that are absent for a full school day."
          input:
            control: Dropdown
            labels:
              1: "Less than 1 %"
              2: "1 to 5 %"
              3: "6 to 10 %"
              4: "11 to 15 %"
              5: "16 to 20 %"
              6: "More than 20 %"
              7: "Don't know"

        # Q14: chronic lateness (7 options -> Dropdown; source codes 08-14)
        - id: q_pq_q14
          kind: Question
          title: "Approximately, what percentage of students are chronically late for school? By chronically late we mean that a student is late for the start of school two or more times each week."
          input:
            control: Dropdown
            labels:
              8: "Less than 1 %"
              9: "1 to 5 %"
              10: "6 to 10 %"
              11: "11 to 15 %"
              12: "16 to 20 %"
              13: "More than 20 %"
              14: "Don't know"

        # Q15: disciplinary-problem frequency battery (12 rows, shared scale)
        - id: qg_pq_q15
          kind: QuestionGroup
          title: "Listed below are a number of different disciplinary problems that may occur in a school. How often do you have to discipline students because of ..."
          questions:
            - "(a) Verbal conflicts among students"
            - "(b) Physical conflicts among students"
            - "(c) Vandalism of school property"
            - "(d) Theft of student belongings"
            - "(e) Theft of staff belongings"
            - "(f) Smoking on school property"
            - "(g) Use of drugs on school property"
            - "(h) Verbal abuse of a staff member"
            - "(i) Physical assault of a staff member"
            - "(j) Harassment of certain students by groups of students"
            - "(k) Conflicts among students of differing racial or ethnic backgrounds"
            - "(l) Students possessing weapons (e.g., pocket knife, gun)"
          input:
            control: Radio
            labels:
              1: "Never"
              2: "Rarely"
              3: "Sometimes"
              4: "Usually"
              5: "Always"

    # =========================================================================
    # SECTION 2 — PARENTS'/GUARDIANS' INVOLVEMENT IN YOUR SCHOOL (source pp.220-221)
    # Q16-Q19. (Section intro "These next questions ask about parents'/guardians'
    # involvement in your school" is a topic label, not an instruction — carried
    # in this header comment rather than as a Comment item.)
    # =========================================================================
    - id: b_pq_s2_parents
      kind: Group
      title: "Principal's Questionnaire — Parents'/Guardians' Involvement in Your School"
      precondition:
        - predicate: q_adm_principal_form.outcome == 1
      items:
        # Q16: parent/guardian volunteering battery (6 rows, shared proportion scale)
        - id: qg_pq_q16
          kind: QuestionGroup
          title: "What proportion of parents/guardians volunteer to help with ..."
          questions:
            - "(a) School events (e.g., sports, plays)"
            - "(b) Fund raising activities"
            - "(c) Field trips"
            - "(d) Classroom activities"
            - "(e) Supervising children (i.e., at recess or lunch time)"
            - "(f) The parent-school association/home and school liaison committee/parent advisory committee"
          input:
            control: Radio
            labels:
              1: "1 to 5 %"
              2: "6 to 10 %"
              3: "11 to 15 %"
              4: "16 to 20 %"
              5: "21 % or more"
              6: "Not applicable"

        # Q17: perceived parent/guardian support (6 options -> Dropdown; codes 01-06)
        - id: q_pq_q17
          kind: Question
          title: "In your opinion, how strongly do parents/guardians support the efforts of the school's staff?"
          input:
            control: Dropdown
            labels:
              1: "Strongly support the efforts of the school's staff"
              2: "Support the efforts of the school's staff"
              3: "Support some of the efforts of the school's staff"
              4: "Oppose the efforts of the school's staff"
              5: "Strongly oppose the efforts of the school's staff"
              6: "I don't know the parents/guardians well enough"

        # Q18: activity of the parent-school association (6 options -> Dropdown;
        #      source codes 07-12; code 12 = "there is no association").
        - id: q_pq_q18
          kind: Question
          title: "How active is the parent-school association, home and school liaison committee, or parent advisory committee in your school?"
          input:
            control: Dropdown
            labels:
              7: "Very active"
              8: "Active"
              9: "Somewhat active"
              10: "Not very active"
              11: "Not at all active"
              12: "There is no parent-school association/home and school liaison committee/parent advisory committee"

        # Q19: influence of the association
        # Source: Q18 code 12 (no association) -> GO TO SECTION 3 (skips Q19).
        # Gate Q19 on Q18 != 12 (source code 12 preserved verbatim above).
        - id: q_pq_q19
          kind: Question
          title: "How much influence does the parent-school association, home and school liaison committee, or parent advisory committee have on school policies or practices?"
          precondition:
            - predicate: q_pq_q18.outcome != 12
          input:
            control: Radio
            labels:
              13: "A strong influence"
              14: "A considerable influence"
              15: "Some influence"
              16: "A little influence"
              17: "No influence"

    # =========================================================================
    # SECTION 3 — CHARACTERISTICS OF YOUR SCHOOL (source pp.221-225)
    # Q20-Q28. Grade range, staffing (FTE + headcounts), support-service
    # availability + usage battery (Q27), resource-adequacy battery (Q28).
    # =========================================================================
    - id: b_pq_s3_school
      kind: Group
      title: "Principal's Questionnaire — Characteristics of Your School"
      precondition:
        - predicate: q_adm_principal_form.outcome == 1
      items:
        # Q20: range of grades taught (free text: "grade __ to grade __")
        - id: q_pq_q20
          kind: Question
          title: "What is the range of grades taught in your school (e.g., Junior kindergarten to grade 8)? Use \"JK\" for junior kindergarten and \"KN\" for kindergarten/pre-grade one. Specify the grades, e.g. grade ___ to grade ___."
          input:
            control: Textarea
            placeholder: "e.g. grade JK to grade 8"
            maxLength: 100

        # Q21: staffing in full-time-equivalent units (9 positions).
        # NOTE: source records FTE with two decimals (e.g. 1.50); QML Editbox is
        # integer, so fractional FTE precision is not represented (bounds 0-99).
        - id: qg_pq_q21
          kind: QuestionGroup
          title: "How many of the following positions are staffed in your school? (Specify in full-time equivalent units, e.g. 1.0 or 1.5. Use 00.00 to indicate the position is not staffed.)"
          questions:
            - "(a) Principal"
            - "(b) Vice-principals/assistant principals"
            - "(c) Classroom teachers"
            - "(d) Teaching assistants/student assistants/teacher's aides"
            - "(e) Librarians"
            - "(f) Resource teachers (e.g. special education teachers, educational therapists, music teachers)"
            - "(g) Physical educators for special needs students"
            - "(h) Guidance counsellors"
            - "(i) Secretaries, custodians, and other non-certified, non-teaching staff"
          input:
            control: Editbox
            min: 0
            max: 99
            right: "FTE"

        # Q22: total number of teachers on January 1, 1995 (headcount)
        - id: q_pq_q22
          kind: Question
          title: "Including special education, physical education, and itinerant/part-time teachers, how many teachers did you have in your school on January 1, 1995? (Specify the total number of teachers.)"
          input:
            control: Editbox
            min: 0
            max: 999
            right: "teachers"

        # Q23: teachers without a homeroom — MINED part-whole: a subset of the
        #      total teacher headcount, so it cannot exceed Q22.
        - id: q_pq_q23
          kind: Question
          title: "How many teachers in your school are not assigned a specific homeroom class (e.g., librarians, music teachers, physical education teachers)? (Specify the number of teachers.)"
          postcondition:
            - predicate: q_pq_q23.outcome <= q_pq_q22.outcome
              hint: "Teachers without a homeroom (Q23) cannot exceed your total number of teachers (Q22)."
          input:
            control: Editbox
            min: 0
            max: 999
            right: "teachers"

        # Q24: other paid instructional-assistance staff (distinct population)
        - id: q_pq_q24
          kind: Question
          title: "Excluding teachers, how many other paid staff (e.g., teacher's aides/student assistants/teaching assistants) provide direct instructional assistance in students' classrooms? (Use 000 for none.)"
          input:
            control: Editbox
            min: 0
            max: 999
            right: "staff"

        # Q25: volunteers working directly with students
        - id: q_pq_q25
          kind: Question
          title: "How many volunteers (e.g., co-op students, parents/guardians) are working directly with students on a regular basis? (If none, write 00.)"
          input:
            control: Editbox
            min: 0
            max: 99
            right: "volunteers"

        # Q26: staff characteristics (2 counts).
        # No cross-item bound: the population is teachers AND teaching assistants,
        # which is not the same as Q22 (teachers only), so neither count is
        # cleanly bounded by any single earlier item.
        - id: qg_pq_q26
          kind: QuestionGroup
          title: "How many of the teachers and teaching assistants/student assistants/teacher's aides at your school have: (Some may belong to more than one category. If none, write 0.)"
          questions:
            - "(a) A first language other than English or French?"
            - "(b) A speech, hearing, visual, mobility or other health impairment?"
          input:
            control: Editbox
            min: 0
            max: 99
            right: "staff"

        # Q27: support services — availability + typical-week usage.
        # The source is a per-row battery: each service has an availability
        # Yes/No, and ONLY IF available a "full-time days/week" figure is filled.
        # A QuestionGroup precondition gates the whole group, not individual
        # rows, so per-row conditional display is not expressible. Modeled as two
        # paired 12-row batteries (availability + days), with the per-row
        # conditional recovered as a MINED screener-consistency postcondition:
        # if a service is not available, its days figure must be 0.
        # NOTE: source days are fractional (e.g. 1.50 days/week); integer Editbox
        # (0-7) loses the fractional part. Row (l) "Other (Specify)" free text is
        # not separately modeled.
        - id: qg_pq_q27_avail
          kind: QuestionGroup
          title: "Listed below are several types of support services available to some schools. Please indicate whether each service is available to your school."
          questions:
            - "(a) School psychologist"
            - "(b) Psychiatrist"
            - "(c) Speech and language therapist"
            - "(d) Audiologist"
            - "(e) Occupational therapist"
            - "(f) Physical therapist"
            - "(g) Social worker"
            - "(h) Community health nurse"
            - "(i) Instructor in Aboriginal Peoples' culture"
            - "(j) Instructor in culture awareness"
            - "(k) Police officer"
            - "(l) Other (Specify)"
          input:
            control: Radio
            labels:
              1: "No"
              2: "Yes"

        # KNOWN RESIDUAL WARNING (documented): the screener-consistency
        # postcondition below uses QuestionGroup outcome subscripts, which the
        # static builder does not lower — it classifies TAUTOLOGICAL (statically
        # skipped) but IS enforced at runtime. Kept as a QuestionGroup because
        # scalarizing 12 availability + 12 usage rows would cost 24 items for
        # one constraint. Revisit when QG subscript lowering lands upstream
        # (askalot-io/askalot#165).
        - id: qg_pq_q27_days
          kind: QuestionGroup
          title: "For each service that is available, how often has it been used in your school during a typical week? (e.g., one full day + one half day = 1.50 full-time days/week. Leave 0 for services not available to your school.)"
          questions:
            - "(a) School psychologist"
            - "(b) Psychiatrist"
            - "(c) Speech and language therapist"
            - "(d) Audiologist"
            - "(e) Occupational therapist"
            - "(f) Physical therapist"
            - "(g) Social worker"
            - "(h) Community health nurse"
            - "(i) Instructor in Aboriginal Peoples' culture"
            - "(j) Instructor in culture awareness"
            - "(k) Police officer"
            - "(l) Other (Specify)"
          postcondition:
            - predicate: all([qg_pq_q27_avail.outcome[i] == 2 or qg_pq_q27_days.outcome[i] == 0 for i in range(12)])
              hint: "A support service that is not available (answered No in the availability list) must have 0 days/week of use."
          input:
            control: Editbox
            min: 0
            max: 7
            right: "days/week"

        # Q28: resource-adequacy rating battery (18 rows, shared scale).
        # Row (r) "Other (Specify)" free text is not separately modeled.
        - id: qg_pq_q28
          kind: QuestionGroup
          title: "Below are a number of different resources which may be available to your school. Please rate the extent to which each attribute currently meets the needs of your school."
          questions:
            - "(a) Instructional resources (e.g., curriculum documents, books)"
            - "(b) School supplies (e.g., paper, pencils)"
            - "(c) Instructional space (e.g., classroom size)"
            - "(d) Computers for course instruction"
            - "(e) Computer software for course instruction"
            - "(f) Library materials"
            - "(g) Audio-visual resources (e.g., VCRs, film projector)"
            - "(h) School buildings"
            - "(i) School grounds"
            - "(j) Heating and lighting"
            - "(k) Science equipment"
            - "(l) Equipment for mathematics instruction (e.g., counting blocks, calculators)"
            - "(m) Budget for consumables"
            - "(n) Special equipment for handicapped students"
            - "(o) Gymnasium"
            - "(p) Gym equipment (e.g., mats, balls)"
            - "(q) Outdoor play equipment"
            - "(r) Other (Specify)"
          input:
            control: Radio
            labels:
              1: "Does not meet my school's needs"
              2: "Partially meets my school's needs"
              3: "Adequately meets my school's needs"
              4: "Completely meets my school's needs"
              5: "Not applicable"

    # =========================================================================
    # SECTION 4 — PERCEPTIONS OF YOUR SCHOOL (source pp.225-226)
    # Q29. Purely subjective agree/disagree battery — no objective cross-item
    # constraints (attitudes have no "correct" relationship).
    # =========================================================================
    - id: b_pq_s4_perceptions
      kind: Group
      title: "Principal's Questionnaire — Perceptions of Your School"
      precondition:
        - predicate: q_adm_principal_form.outcome == 1
      items:
        # Q29: agreement battery (10 rows, shared 5-point agree/disagree scale)
        - id: qg_pq_q29
          kind: QuestionGroup
          title: "Below are a number of statements which describe different aspects of schooling. Please indicate how strongly you agree or disagree with each of the following statements."
          questions:
            - "(a) I find my professional role satisfying"
            - "(b) If I had to do it again, I would remain a teacher rather than become a principal"
            - "(c) I feel good about continuing my career in this school district"
            - "(d) I feel competent to deal with students' behavioural problems"
            - "(e) I have a considerable influence on my school's policies"
            - "(f) I have little influence on how money is allocated for school resources"
            - "(g) The emphasis in my school is on the development of academic skills"
            - "(h) I have high expectations for the academic success of students attending this school"
            - "(i) I try to ensure that students are pushed to achieve their full academic potential"
            - "(j) I feel students' success at school is determined mainly by their home environments"
          input:
            control: Radio
            labels:
              1: "Strongly disagree"
              2: "Disagree"
              3: "Neither agree nor disagree"
              4: "Agree"
              5: "Strongly agree"

    # =========================================================================
    # SECTION 5 — PERSONAL INFORMATION (source pp.227-228)
    # Q30-Q34. Principal demographics, experience, education, data-sharing consent.
    # =========================================================================
    - id: b_pq_s5_personal
      kind: Group
      title: "Principal's Questionnaire — Personal Information"
      precondition:
        - predicate: q_adm_principal_form.outcome == 1
      items:
        # Q30: sex
        - id: q_pq_q30
          kind: Question
          title: "Are you..."
          input:
            control: Radio
            labels:
              1: "Female"
              2: "Male"

        # Q31: age category (5 options; source codes 3-7)
        - id: q_pq_q31
          kind: Question
          title: "To which age category do you belong?"
          input:
            control: Radio
            labels:
              3: "20 to 29 years"
              4: "30 to 39 years"
              5: "40 to 49 years"
              6: "50 to 59 years"
              7: "60 years or older"

        # Q32: experience in years + months across 6 role/location pairs.
        # Modeled as two paired 6-row batteries (years, months). MINED
        # max/part-whole: experience "at this school" in a role cannot exceed
        # total experience in that same role. Compared in total months
        # (years*12 + months) on the last-produced item (the months battery):
        #   (b) principal-at-this-school <= (a) principal
        #   (d) vice-principal-at-this-school <= (c) vice-principal
        #   (f) teacher-at-this-school <= (e) teacher
        # Q32 modeled as scalar year/month pairs per role (not QuestionGroups):
        # the static builder does not lower QuestionGroup outcome subscripts,
        # so the mined at-this-school <= total-experience constraints would be
        # runtime-only. Scalars keep them statically CONSTRAINING (same
        # treatment as Teacher's Questionnaire Q54). "Specify 00 if you have
        # no experience in a particular position."
        - id: q_pq_q32a_y
          kind: Question
          title: "Experience as a principal — years."
          input: { control: Editbox, min: 0, max: 60, right: "years" }
        - id: q_pq_q32a_m
          kind: Question
          title: "Experience as a principal — months."
          input: { control: Editbox, min: 0, max: 11, right: "months" }
        - id: q_pq_q32b_y
          kind: Question
          title: "Experience as a principal at this school — years."
          input: { control: Editbox, min: 0, max: 60, right: "years" }
        - id: q_pq_q32b_m
          kind: Question
          title: "Experience as a principal at this school — months."
          postcondition:
            - predicate: q_pq_q32b_y.outcome * 12 + q_pq_q32b_m.outcome <= q_pq_q32a_y.outcome * 12 + q_pq_q32a_m.outcome
              hint: "Experience as a principal at this school cannot exceed your total experience as a principal."
          input: { control: Editbox, min: 0, max: 11, right: "months" }
        - id: q_pq_q32c_y
          kind: Question
          title: "Experience as a vice-principal — years."
          input: { control: Editbox, min: 0, max: 60, right: "years" }
        - id: q_pq_q32c_m
          kind: Question
          title: "Experience as a vice-principal — months."
          input: { control: Editbox, min: 0, max: 11, right: "months" }
        - id: q_pq_q32d_y
          kind: Question
          title: "Experience as a vice-principal at this school — years."
          input: { control: Editbox, min: 0, max: 60, right: "years" }
        - id: q_pq_q32d_m
          kind: Question
          title: "Experience as a vice-principal at this school — months."
          postcondition:
            - predicate: q_pq_q32d_y.outcome * 12 + q_pq_q32d_m.outcome <= q_pq_q32c_y.outcome * 12 + q_pq_q32c_m.outcome
              hint: "Experience as a vice-principal at this school cannot exceed your total experience as a vice-principal."
          input: { control: Editbox, min: 0, max: 11, right: "months" }
        - id: q_pq_q32e_y
          kind: Question
          title: "Experience as a teacher — years."
          input: { control: Editbox, min: 0, max: 60, right: "years" }
        - id: q_pq_q32e_m
          kind: Question
          title: "Experience as a teacher — months."
          input: { control: Editbox, min: 0, max: 11, right: "months" }
        - id: q_pq_q32f_y
          kind: Question
          title: "Experience as a teacher at this school — years."
          input: { control: Editbox, min: 0, max: 60, right: "years" }
        - id: q_pq_q32f_m
          kind: Question
          title: "Experience as a teacher at this school — months."
          postcondition:
            - predicate: q_pq_q32f_y.outcome * 12 + q_pq_q32f_m.outcome <= q_pq_q32e_y.outcome * 12 + q_pq_q32e_m.outcome
              hint: "Experience as a teacher at this school cannot exceed your total experience as a teacher."
          input: { control: Editbox, min: 0, max: 11, right: "months" }

        # Q33: levels of education attained (Mark all that apply -> Checkbox,
        #      power-of-2 keys). Option 11 "Other (Specify)" free text not modeled.
        - id: q_pq_q33
          kind: Question
          title: "Please specify the levels of education you have attained. (Mark all that apply.)"
          input:
            control: Checkbox
            labels:
              1: "Some coursework towards a Bachelor's degree"
              2: "A teaching certificate, diploma or licence"
              4: "A Bachelor's degree"
              8: "A Bachelor of Education degree"
              16: "Some post-baccalaureate coursework"
              32: "A post-baccalaureate diploma or certificate"
              64: "Some coursework towards a Master's degree"
              128: "A Master's degree"
              256: "Some coursework towards a Doctorate"
              512: "A Doctorate"
              1024: "Other (Specify)"

        # Q34: HRDC data-sharing consent (end of questionnaire)
        - id: q_pq_q34
          kind: Question
          title: "Statistics Canada is conducting this survey jointly with Human Resources Development Canada. The information collected will be kept confidential and used only for statistical purposes. Do you agree to share the information collected with Human Resources Development Canada?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

    # =========================================================================
    # APPENDIX E — NPHS QUESTIONS (TWOWK / UTIL) — source pages 229-233
    # =========================================================================
    # These are additional National Population Health Survey items asked ONLY
    # during the integrated NLSC/NPHS collection (Nov 1994 / Mar 1995). The
    # whole appendix is gated by the data-collection-period flag, modeled as the
    # admin item q_adm_collection_period (1 = integrated NLSC+NPHS period). That
    # gate is HOISTED to every Appendix E block precondition; items keep only
    # their item-specific routing residuals. All items are asked by the PMK
    # about the selected child (proxy phrasing).
    # =========================================================================

    # -------------------------------------------------------------------------
    # BLOCK E1: NPHS HOUSEHOLD RECORD VARIABLES (HHLD-Q4/Q5/Q5a) — p.230
    # Item ids prefixed q_nphs_hhld_* to avoid collision with the main-body
    # Household Record Variables section.
    # -------------------------------------------------------------------------
    - id: b_nphs_hhld
      kind: Group
      title: "NPHS Household Record Variables"
      precondition:
        - predicate: q_adm_collection_period.outcome == 1
          hint: "Asked only during the integrated NLSC/NPHS collection period."
      items:
        # HHLD-Q4: Pet in household? NO ---> GO TO HHLD-Q6 (skips Q5/Q5a).
        - id: q_nphs_hhld_q4
          kind: Question
          title: "Is there a pet in this household?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # HHLD-Q5: Kind of pet (mark all that apply). Shown only if Q4=Yes.
        # Source appends "---> GO TO HHLD-Q6" to this item; treated as the
        # continuation after the pet sub-questions (HHLD-Q6 lives in the main
        # body and is NOT created here).
        - id: q_nphs_hhld_q5
          kind: Question
          title: "What kind of pet? (Do not read list. Mark all that apply.)"
          precondition:
            - predicate: q_nphs_hhld_q4.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "Dog"
              2: "Cat"
              4: "Other"

        # HHLD-Q5a: Pet(s) live mainly indoors? Shown only if Q4=Yes.
        - id: q_nphs_hhld_q5a
          kind: Question
          title: "Does this pet or do any of these pets live mainly indoors?"
          precondition:
            - predicate: q_nphs_hhld_q4.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # END OF PET PATH: HHLD-Q6 (dwelling / household continuation) is a GOTO
        # target in the MAIN-BODY Household Record Variables section — not
        # created in this appendix. All paths (Q4=No, or after Q5/Q5a) resume there.
        - id: q_nphs_hhld_end
          kind: Comment
          title: "(Routing note: after these NPHS pet items, the interview resumes at HHLD-Q6 in the main Household Record Variables section.)"

    # -------------------------------------------------------------------------
    # BLOCK E2: TWO-WEEK DISABILITY (TWOWK-INT, Q1-Q5) — p.230-231
    # 14-day recall window. GOTO conversions:
    #   Q1 No ---> Q3            => Q2 gated on Q1=Yes
    #   Q2 = 14 ---> Q5          => Q3/Q4 gated on NOT(Q1=Yes AND Q2=14)
    #   Q3 No ---> Q5            => Q4 gated on Q3=Yes
    #   Q5 reached by all paths  => Q5 unconditional (block gate only)
    # -------------------------------------------------------------------------
    - id: b_nphs_twowk
      kind: Group
      title: "NPHS Two-Week Disability"
      precondition:
        - predicate: q_adm_collection_period.outcome == 1
          hint: "Asked only during the integrated NLSC/NPHS collection period."
      items:
        # TWOWK-INT
        - id: q_twowk_int
          kind: Comment
          title: "The first few questions ask about the child's health during the past 14 days. Please refer to the 14-day period from two weeks ago to yesterday."

        # TWOWK-Q1: stayed in bed at all? NO ---> GO TO TWOWK-Q3.
        - id: q_twowk_q1
          kind: Question
          title: "During that 14-day period, did the child stay in bed at all because of illness or injury, including any nights spent as a patient in a hospital?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # TWOWK-Q2: days in bed (0 = less than a day). Shown only if Q1=Yes.
        # IF = 14 DAYS ---> GO TO TWOWK-Q5 (handled by Q3/Q4 preconditions).
        - id: q_twowk_q2
          kind: Question
          title: "How many days did the child stay in bed for all or most of the day? (Enter 0 if less than a day.)"
          precondition:
            - predicate: q_twowk_q1.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 14
            right: "days"

        # TWOWK-Q3: any cut-down days (NOT counting bed days)? NO ---> GO TO Q5.
        # Reached when: Q1=No (skip-in from Q1), OR Q1=Yes AND Q2<14 (Q2=14 skips to Q5).
        - id: q_twowk_q3
          kind: Question
          title: "Not counting days spent in bed, during those 14 days were there any days that the child cut down on things they normally do because of illness or injury?"
          precondition:
            - predicate: q_twowk_q1.outcome == 2 or (q_twowk_q1.outcome == 1 and q_twowk_q2.outcome < 14)
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # TWOWK-Q4: cut-down days (0 = less than a day). Shown only if Q3=Yes.
        # POSTCONDITION (part-whole): bed days (Q2) and cut-down days (Q4) are
        # mutually exclusive subsets of the same 14-day window (Q3 asks
        # explicitly "Not counting days spent in bed"), so their sum cannot
        # exceed 14. When Q1=No, Q2 is unanswered (0) and this reduces to the
        # Editbox domain — no false violation.
        - id: q_twowk_q4
          kind: Question
          title: "How many days did the child cut down on things for all or most of the day? (Enter 0 if less than a day.)"
          precondition:
            - predicate: q_twowk_q3.outcome == 1
          postcondition:
            - predicate: q_twowk_q2.outcome + q_twowk_q4.outcome <= 14
              hint: "Bed days plus cut-down days cannot exceed the 14-day window (they are separate days)."
          input:
            control: Editbox
            min: 0
            max: 14
            right: "days"

        # TWOWK-Q5: regular medical doctor? Reached by every path (block gate only).
        - id: q_twowk_q5
          kind: Question
          title: "Does the child have a regular medical doctor?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

    # -------------------------------------------------------------------------
    # BLOCK E3: HEALTH CARE UTILIZATION (UTIL-INT, Q1-Q10) — p.231-233
    # GOTO conversions:
    #   Q1 No ---> Q2                        => Q1a gated on Q1=Yes
    #   UTIL-C2: response >0 in a), c) or d) => Q3 gated on those counts
    #   Q4 No ---> Q6                        => Q5 gated on Q4=Yes
    #   Q6 No ---> UTIL-C9                    => Q7/Q8 gated on Q6=Yes
    #   UTIL-C9: IF AGE < 18 ---> NEXT SEC.  => see note on q_util_q9
    #   Q9 No ---> NEXT SECTION              => Q10 gated on Q9=Yes
    # -------------------------------------------------------------------------
    - id: b_nphs_util
      kind: Group
      title: "NPHS Health Care Utilization"
      precondition:
        - predicate: q_adm_collection_period.outcome == 1
          hint: "Asked only during the integrated NLSC/NPHS collection period."
      items:
        # UTIL-INT
        - id: q_util_int
          kind: Comment
          title: "Now I'd like to ask about the child's contacts with health professionals during the past 12 months."

        # UTIL-Q1: overnight patient in past 12 months? NO ---> GO TO UTIL-Q2.
        - id: q_util_q1
          kind: Question
          title: "In the past 12 months, has the child been a patient overnight in a hospital, nursing home or convalescent home?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # UTIL-Q1a: number of nights. Shown only if Q1=Yes.
        # Screener consistency (Q1=Yes => at least one night) is enforced
        # structurally by this precondition plus min: 1 — no separate
        # postcondition (it would be tautological).
        - id: q_util_q1a
          kind: Question
          title: "For how many nights in the past 12 months?"
          precondition:
            - predicate: q_util_q1.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 365
            right: "nights"

        # UTIL-Q2: contact counts by professional category (a-j). Asked of all
        # (UTIL-Q1 No routes here too). Indices: a=0, b=1, c=2, d=3, e=4, f=5,
        # g=6, h=7, i=8, j=9.
        - id: qg_util_q2
          kind: QuestionGroup
          title: "Not counting overnight-patient stays, in the past 12 months how many times has the child seen or talked on the telephone with each of the following about their physical, emotional or mental health?"
          questions:
            - "(a) General practitioner or family physician"
            - "(b) Eye specialist (ophthalmologist or optometrist)"
            - "(c) Other medical doctor (surgeon, allergist, gynaecologist, psychiatrist, etc.)"
            - "(d) A nurse for care or advice"
            - "(e) Dentist or orthodontist"
            - "(f) Chiropractor"
            - "(g) Physiotherapist"
            - "(h) Social worker or counsellor"
            - "(i) Psychologist"
            - "(j) Speech, audiology or occupational therapist"
          input:
            control: Editbox
            min: 0
            max: 365
            right: "contacts"

        # UTIL-Q3: location of most recent contact. UTIL-C2 routing: asked only
        # if there was >0 contact in category a), c) or d).
        - id: q_util_q3
          kind: Question
          title: "Where did the most recent contact take place? (Read list. Mark one only.)"
          precondition:
            - predicate: qg_util_q2.outcome[0] > 0 or qg_util_q2.outcome[2] > 0 or qg_util_q2.outcome[3] > 0
          input:
            control: Dropdown
            labels:
              1: "Walk-in clinic"
              2: "Outpatient clinic in hospital"
              3: "Hospital emergency room"
              4: "Health professional's office"
              5: "Community health centre / CLSC"
              6: "At home"
              7: "Telephone consultation only"
              8: "Other"

        # UTIL-Q4: used alternative health care? NO ---> GO TO UTIL-Q6.
        - id: q_util_q4
          kind: Question
          title: "In the past 12 months, has the child seen or talked to an alternative health care provider such as an acupuncturist, naturopath, homeopath or massage therapist about their physical, emotional or mental health?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # UTIL-Q5: which alternative providers (mark all that apply). If Q4=Yes.
        - id: q_util_q5
          kind: Question
          title: "Who did the child see or talk to? (Do not read list. Mark all that apply.)"
          precondition:
            - predicate: q_util_q4.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "Massage therapist"
              2: "Acupuncturist"
              4: "Homeopath or naturopath"
              8: "Feldenkrais or Alexander teacher"
              16: "Relaxation therapist"
              32: "Biofeedback teacher"
              64: "Rolfer"
              128: "Herbalist"
              256: "Reflexologist"
              512: "Spiritual healer"
              1024: "Religious healer"
              2048: "Self-help group (such as AA, cancer therapy, etc.)"
              4096: "Other"

        # UTIL-Q6: needed care but did not receive it? NO ---> GO TO UTIL-C9.
        # Reached by all paths (Q4 No routes to Q6; Q5 path continues to Q6).
        - id: q_util_q6
          kind: Question
          title: "During the past 12 months, was there ever a time when the child needed health care or advice but did not receive it?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # UTIL-Q7: why not received (open-ended). Shown only if Q6=Yes.
        - id: q_util_q7
          kind: Question
          title: "Thinking of the most recent time, why did the child not get care?"
          precondition:
            - predicate: q_util_q6.outcome == 1
          input:
            control: Textarea

        # UTIL-Q8: type of care needed (mark all that apply). Shown only if Q6=Yes.
        - id: q_util_q8
          kind: Question
          title: "Again, thinking of the most recent time, what was the type of care that was needed? (Do not read list. Mark all that apply.)"
          precondition:
            - predicate: q_util_q6.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "Treatment of a physical health problem"
              2: "Treatment of an emotional or mental health problem"
              4: "A regular check-up (or regular pre-natal care)"
              8: "Care of an injury"
              16: "Any other reason"

        # UTIL-C9 / UTIL-Q9-Q10: the NPHS adult home-care module — NOT MODELED.
        # UTIL-C9 routes "IF AGE < 18 THEN GO TO NEXT SECTION." The "..." in
        # UTIL-Q9/Q10 refers to the SELECTED CHILD, whose age domain in this
        # instrument is 0-11 (q_child_age, Editbox min 0 max 11). The child's
        # age is therefore ALWAYS < 18: UTIL-C9 always routes past the module
        # and UTIL-Q9/Q10 (home-care receipt + service types) can never be
        # administered in the child questionnaire. Including them would create
        # provably-unreachable items (gate q_child_age.outcome >= 18 is
        # unsatisfiable over [0,11]), so they are omitted here; the analysis
        # report records the finding that the NPHS adult home-care module is
        # inapplicable dead routing in the child context (source p.232-233).

    # =========================================================================
    # APPENDIX F — ADMINISTRATIVE INFORMATION (KCON / TCH / OBS / PPVT) — p.234-244
    # =========================================================================
    # End-of-interview administrative modules. DK/REFUSAL code values differ by
    # module (preserved from source): KCON and OBS use 8=DK / 9=REFUSAL; TCH and
    # PPVT use 7=DK / 8=REFUSAL.
    # =========================================================================

    # -------------------------------------------------------------------------
    # BLOCK F1: DATA-SHARING AGREEMENT — KCON (p.235-236)
    # No block gate (asked of all). KCON-Q1A vs KCON-Q1B selected by the
    # data-collection period (q_adm_collection_period: 1 = joint NPHS+NLSC ->
    # Q1A; 2 = NLSC-only -> Q1B).
    # DK/REFUSAL ---> NEXT SECTION routing on the contact-tracing text items
    # (Q2A-Q3C) is NOT modeled as preconditions: QML Textarea controls carry no
    # DK/REF code, and the main-body house convention (see SAF-Q2/Q3) treats
    # such refusal-to-continue as a CATI administration concern, leaving
    # downstream contact fields ungated in straightforward sequential flow.
    # -------------------------------------------------------------------------
    - id: b_kcon
      kind: Group
      title: "Data-Sharing Agreement (KCON)"
      items:
        # KCON-Q1A: asked only in the joint NPHS+NLSC period.
        - id: q_kcon_q1a
          kind: Question
          title: "To avoid duplication, Statistics Canada intends to share the information from this survey with provincial ministries of health, Health Canada and Human Resources Development Canada, who will keep it confidential and use it only for statistical purposes. Do you agree to share the information you have provided, including any provided by your child(ren)?"
          precondition:
            - predicate: q_adm_collection_period.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

        # KCON-Q1B: asked only in the NLSC-only period.
        - id: q_kcon_q1b
          kind: Question
          title: "Statistics Canada is conducting this survey jointly with Human Resources Development Canada. The information collected will be kept confidential and used only for statistical purposes. Do you agree to share the information collected, including any provided by your child(ren), with Human Resources Development Canada?"
          precondition:
            - predicate: q_adm_collection_period.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

        # KCON-I2
        - id: q_kcon_i2
          kind: Comment
          title: "In case you move or change telephone numbers, it would be helpful if you could provide the name, address and telephone number of someone, such as a friend or relative, who could help us to contact you."

        # KCON-Q2A: first contact — name.
        - id: q_kcon_q2a
          kind: Question
          title: "Statistics Canada will contact this person only if you move, and then only to obtain your new address or telephone number. Enter the first and last name of the contact."
          input:
            control: Textarea

        # KCON-Q2B: first contact — address.
        - id: q_kcon_q2b
          kind: Question
          title: "Enter the address of the contact."
          input:
            control: Textarea

        # KCON-Q2C: first contact — phone number.
        - id: q_kcon_q2c
          kind: Question
          title: "Enter the phone number of the contact (area code, prefix and suffix)."
          input:
            control: Textarea

        # KCON-Q3A: second contact — name.
        - id: q_kcon_q3a
          kind: Question
          title: "In case we can't reach that person, please provide the name, address and telephone number of another person we could contact. Enter the first and last name of the contact."
          input:
            control: Textarea

        # KCON-Q3B: second contact — address.
        - id: q_kcon_q3b
          kind: Question
          title: "Enter the address of the contact."
          input:
            control: Textarea

        # KCON-Q3C: second contact — phone number.
        - id: q_kcon_q3c
          kind: Question
          title: "Enter the phone number of the contact (area code, prefix and suffix)."
          input:
            control: Textarea

    # -------------------------------------------------------------------------
    # BLOCK F2: TEACHER CONSENT — TCH (p.237-238)
    # TCH-C1: done only for a child who attended school -> block precondition
    #   q_edu_q1.outcome >= 2 (q_edu_q1: 1 = "Not in school"; >=2 = in school).
    # TCH-Q1 consent: 1=YES continues; 2=NO / 7=DK / 8=REFUSAL ---> NEXT SECTION
    #   => Q2 and I3 gated on Q1=Yes.
    # TCH-C2 grade mapping (verified q_edu_q1 labels):
    #   1=Not in school, 2=Junior Kindergarten, 3=Kindergarten/Primary,
    #   4=Grade 1, 5=Grade 2, 6=Grade 3, ... 15=Grade 12, 16=OAC/Grade 13,
    #   17=Ungraded.
    #   "IN GRADE 2 OR OVER" ---> GO TO I3 (skip Q2)  => outcomes 5..16.
    #   OTHERWISE ---> ask Q2                          => outcomes 2,3,4 (below
    #   Grade 2) plus 17 (Ungraded, which has no numeric grade — routed to the
    #   "otherwise/ask Q2" branch, flagged below).
    # -------------------------------------------------------------------------
    - id: b_tch_consent
      kind: Group
      title: "Teacher Consent (TCH)"
      precondition:
        - predicate: q_edu_q1.outcome >= 2
          hint: "Asked only for a selected child who attended school in the past 12 months."
      items:
        # TCH-Q1: teacher-contact consent.
        - id: q_tch_q1
          kind: Question
          title: "Do you agree that the child's teacher may be contacted and asked to complete a questionnaire regarding the child?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refusal"

        # TCH-Q2: math-test consent. Asked only if consent given (Q1=Yes) AND the
        # child is BELOW Grade 2 (outcomes 2,3,4) OR Ungraded (17); Grade 2+
        # children (5..16) skip to TCH-I3.
        - id: q_tch_q2
          kind: Question
          title: "Do you agree that the child's teacher may give the child a brief test of math skills?"
          precondition:
            - predicate: q_tch_q1.outcome == 1
            - predicate: q_edu_q1.outcome <= 4 or q_edu_q1.outcome == 17
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refusal"

        # TCH-I3: interviewer fill-in on the consent form. Reached by both grade
        # branches once consent is given (Q1=Yes).
        - id: q_tch_i3
          kind: Comment
          title: "Interviewer: fill in the following items on the teacher consent form and complete all other requested information — sample ID, person number, first name, last name."
          precondition:
            - predicate: q_tch_q1.outcome == 1

    # -------------------------------------------------------------------------
    # BLOCK F3: NEIGHBOURHOOD OBSERVATION — OBS (p.239-240)
    # Completed by the interviewer, not asked of the respondent. Unconditional.
    # Source has no OBS-Q3 (skips Q2 -> Q4); the gap is preserved. OBS uses
    # 8=DK / 9=REFUSAL (Q7 uses 98/99), preserved as interviewer codes.
    # -------------------------------------------------------------------------
    - id: b_obs
      kind: Group
      title: "Neighbourhood Observation (OBS)"
      items:
        # OBS-Q1
        - id: q_obs_q1
          kind: Question
          title: "How would you rate the volume of traffic on the street or road?"
          input:
            control: Dropdown
            labels:
              1: "Very light"
              2: "Light"
              3: "Moderate"
              4: "Heavy"
              5: "Very heavy"
              8: "Don't know"
              9: "Refusal"

        # OBS-Q2
        - id: q_obs_q2
          kind: Question
          title: "Is there garbage, litter, or broken glass in the street or road, on the sidewalks, or in yards?"
          input:
            control: Dropdown
            labels:
              1: "Almost none"
              2: "Yes, but not a lot"
              3: "Yes, quite a bit"
              4: "Yes, almost everywhere"
              8: "Don't know"
              9: "Refusal"

        # OBS-Q4 (no OBS-Q3 in source — gap preserved).
        - id: q_obs_q4
          kind: Question
          title: "Are people loitering, congregating or hanging out?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

        # OBS-Q5
        - id: q_obs_q5
          kind: Question
          title: "Are any persons arguing, shouting, fighting or otherwise behaving in hostile or threatening ways?"
          input:
            control: Radio
            labels:
              1: "No persons observed"
              2: "No, none behaving in hostile or threatening ways"
              3: "Yes, some observed"
              8: "Don't know"
              9: "Refusal"

        # OBS-Q6
        - id: q_obs_q6
          kind: Question
          title: "Are drunken or otherwise intoxicated persons visible?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"
              9: "Refusal"

        # OBS-Q7 (land use; source codes 01-11, 98=DK, 99=REFUSAL).
        - id: q_obs_q7
          kind: Question
          title: "Based on street-level frontage, how would you characterize land use on this block/road?"
          input:
            control: Dropdown
            labels:
              1: "Primarily residential"
              2: "Primarily commercial"
              3: "Mixed residential and commercial use"
              4: "Primarily industrial, warehouse, manufacturing"
              5: "Primarily vacant houses"
              6: "Primarily vacant lots or open space"
              7: "Primarily services or institutional (schools, churches, hospitals)"
              8: "Primarily park, playground"
              9: "Primarily rural, residential"
              10: "Primarily rural, farm"
              11: "Other"
              98: "Don't know"
              99: "Refusal"

        # OBS-Q8
        - id: q_obs_q8
          kind: Question
          title: "How would you rate the general condition of most of the buildings on the block or within 100 yards of the respondent's house?"
          input:
            control: Dropdown
            labels:
              1: "Badly deteriorated"
              2: "Poor condition, peeling paint and in need of repair"
              3: "Fair condition"
              4: "Well kept, good repair and exterior surface"
              8: "Don't know"
              9: "Refusal"

        # OBS-Q9
        - id: q_obs_q9
          kind: Question
          title: "Did you first contact this dwelling by phone or in person?"
          input:
            control: Radio
            labels:
              1: "By phone"
              2: "In person"
              8: "Don't know"
              9: "Refusal"

    # -------------------------------------------------------------------------
    # BLOCK F4: PEABODY (PPVT) TEST-ADMINISTRATION RATINGS (p.241-244)
    # Interviewer's ratings of how the Peabody (PPVT-R) vocabulary test went.
    # AGE GATE: the inventory PPVT note does NOT state an administration age;
    # the PPVT-R in NLSCY Cycle 1 is administered to 4-5 year olds (contract +
    # known NLSCY Cycle 1 design; 4-5 is a distinct age tier throughout the main
    # body). Gated on q_child_age.outcome in [4,5]. FLAGGED as an assumption
    # because the inventory itself carries no explicit age routing here.
    # DK/REFUSAL codes (7/8) on the 1-5 rating scales cannot be represented on a
    # Slider and are OMITTED per the main-body convention for rating batteries
    # (see b_social_support); the interviewer must choose 1-5. On the Yes/No
    # problem items (Q6/Q7/Q8) the 7=DK / 8=REFUSAL codes are retained.
    # Skip conversions: Q6 No->Q7, Q7 No->Q8, Q8 No->Q9 => the specify items
    # Q6A/Q7A/Q8A are gated on their parent = Yes.
    # -------------------------------------------------------------------------
    - id: b_ppvt
      kind: Group
      title: "Peabody (PPVT) Administration Ratings"
      precondition:
        - predicate: q_child_age.outcome >= 4 and q_child_age.outcome <= 5
          hint: "The Peabody vocabulary test is administered to 4-5 year olds."
      items:
        # PPVT-I1
        - id: q_ppvt_i1
          kind: Comment
          title: "This is the Peabody Assessment for the child."

        # PPVT-Q1: attitude (1=Poor ... 5=Excellent)
        - id: q_ppvt_q1
          kind: Question
          title: "During the Peabody, how was the child's attitude towards being tested?"
          input:
            control: Slider
            min: 1
            max: 5
            left: "1 = Poor"
            right: "5 = Excellent"

        # PPVT-Q2: rapport
        - id: q_ppvt_q2
          kind: Question
          title: "During the Peabody, how was the child's rapport with you?"
          input:
            control: Slider
            min: 1
            max: 5
            left: "1 = Poor"
            right: "5 = Excellent"

        # PPVT-Q3: perseverance/persistence
        - id: q_ppvt_q3
          kind: Question
          title: "During the Peabody, how was the child's perseverance/persistence?"
          input:
            control: Slider
            min: 1
            max: 5
            left: "1 = Poor"
            right: "5 = Excellent"

        # PPVT-Q4: cooperation
        - id: q_ppvt_q4
          kind: Question
          title: "During the Peabody, how was the child's cooperation?"
          input:
            control: Slider
            min: 1
            max: 5
            left: "1 = Poor"
            right: "5 = Excellent"

        # PPVT-Q5: motivation/interest
        - id: q_ppvt_q5
          kind: Question
          title: "During the Peabody, how was the child's motivation/interest?"
          input:
            control: Slider
            min: 1
            max: 5
            left: "1 = Poor"
            right: "5 = Excellent"

        # PPVT-Q6: problems with visual sharpness? NO ---> GO TO Q7.
        - id: q_ppvt_q6
          kind: Question
          title: "During the Peabody, were there any problems with the child's visual sharpness?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refusal"

        # PPVT-Q6A: specify (only if Q6=Yes).
        - id: q_ppvt_q6a
          kind: Question
          title: "Specify the problems with the child's visual sharpness."
          precondition:
            - predicate: q_ppvt_q6.outcome == 1
          input:
            control: Textarea

        # PPVT-Q7: problems with hearing? NO ---> GO TO Q8.
        - id: q_ppvt_q7
          kind: Question
          title: "During the Peabody, were there any problems with the child's hearing?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refusal"

        # PPVT-Q7A: specify (only if Q7=Yes).
        - id: q_ppvt_q7a
          kind: Question
          title: "Specify the problems with the child's hearing."
          precondition:
            - predicate: q_ppvt_q7.outcome == 1
          input:
            control: Textarea

        # PPVT-Q8: problems with state of health? NO ---> GO TO Q9.
        - id: q_ppvt_q8
          kind: Question
          title: "During the Peabody, were there any problems with the child's state of health?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refusal"

        # PPVT-Q8A: specify (only if Q8=Yes).
        - id: q_ppvt_q8a
          kind: Question
          title: "Specify the problems with the child's state of health."
          precondition:
            - predicate: q_ppvt_q8.outcome == 1
          input:
            control: Textarea

        # PPVT-Q9: shyness/anxiety at end (different anchors).
        - id: q_ppvt_q9
          kind: Question
          title: "How shy or anxious was the child at the end of the Peabody?"
          input:
            control: Slider
            min: 1
            max: 5
            left: "1 = Not at all shy/anxious (sociable and friendly)"
            right: "5 = Extremely shy/quiet/withdrawn"

        # PPVT-Q10: noise level interference
        - id: q_ppvt_q10
          kind: Question
          title: "During the Peabody, was the noise level an interference?"
          input:
            control: Slider
            min: 1
            max: 5
            left: "1 = Interfering"
            right: "5 = Not interfering"

        # PPVT-Q11: interruptions
        - id: q_ppvt_q11
          kind: Question
          title: "During the Peabody, were interruptions an interference?"
          input:
            control: Slider
            min: 1
            max: 5
            left: "1 = Interfering"
            right: "5 = Not interfering"

        # PPVT-Q12: distractions
        - id: q_ppvt_q12
          kind: Question
          title: "During the Peabody, were distractions an interference?"
          input:
            control: Slider
            min: 1
            max: 5
            left: "1 = Interfering"
            right: "5 = Not interfering"

        # PPVT-Q13: light
        - id: q_ppvt_q13
          kind: Question
          title: "During the Peabody, was light an interference?"
          input:
            control: Slider
            min: 1
            max: 5
            left: "1 = Interfering"
            right: "5 = Not interfering"

        # PPVT-Q14: temperature
        - id: q_ppvt_q14
          kind: Question
          title: "During the Peabody, was temperature an interference?"
          input:
            control: Slider
            min: 1
            max: 5
            left: "1 = Interfering"
            right: "5 = Not interfering"

        # PPVT-Q15: presence of others
        - id: q_ppvt_q15
          kind: Question
          title: "During the Peabody, was the presence of others an interference?"
          input:
            control: Slider
            min: 1
            max: 5
            left: "1 = Interfering"
            right: "5 = Not interfering"

        # PPVT-Q16: general comments.
        - id: q_ppvt_q16
          kind: Question
          title: "Please enter any general comments not covered above for the Peabody with the child."
          input:
            control: Textarea
