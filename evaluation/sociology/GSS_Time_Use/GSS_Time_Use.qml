qmlVersion: "1.0"
questionnaire:
  title: "General Social Survey Time Use"
  codeInit: |
    # =====================================================================
    # Cross-section variables. With a single codeInit scope and one
    # dependency graph, variables written by an earlier block are visible
    # to every later block without any extern declaration.
    # =====================================================================
    lang_path = 0
    n1_multiple = 0
    worked_12m = 0
    home_lang_count = 0
    any_federal_contact = 0
    any_federal_contact_t = 0
    worked_12m_u = 0

  blocks:

    # ===================================================================
    # SECTION: social_mobility_respondent
    # ===================================================================
    # =========================================================================
    # BLOCK: SOCIAL MOBILITY - RESPONDENT
    # =========================================================================
    # A1: Country of birth (Canada with province, or outside Canada)
    # A2: Immigration year (if born outside Canada)
    # A3: Date of birth (day, month, year as separate Editboxes)
    # A4: Same community from birth to age 15?
    # A5: Number of communities (if A4=No)
    # A6: Years in longest community (if A4=No)
    # A7: Community size (if A4=Yes or No, not DK)
    # A8: Community location (Canada or elsewhere)
    # =========================================================================
    - id: b_social_mobility_respondent
      title: "Social Mobility (Respondent)"
      items:
        # A1: Country of birth
        # Original: If Canada (01), show province sub-question {02-13};
        # if province selected -> GO TO A3; if 14 -> GO TO A2.
        # Modeled as single Dropdown with all provinces + outside Canada.
        # Selecting a province (2-13) implies born in Canada.
        # Selecting 1 = born in Canada (province unspecified).
        # Selecting 14 = born outside Canada -> A2 immigration year.
        - id: q_a1
          kind: Question
          title: "In what country were you born? (If born in Canada, select the province.)"
          input:
            control: Dropdown
            labels:
              1: "Canada (province not specified)"
              2: "Newfoundland"
              3: "Prince Edward Island"
              4: "Nova Scotia"
              5: "New Brunswick"
              6: "Quebec"
              7: "Ontario"
              8: "Manitoba"
              9: "Saskatchewan"
              10: "Alberta"
              11: "British Columbia"
              12: "Yukon Territory"
              13: "Northwest Territories"
              14: "Country outside Canada"

        # A1_SPECIFY: Specify country (if born outside Canada)
        - id: q_a1_specify
          kind: Question
          title: "Please specify the country."
          precondition:
            - predicate: q_a1.outcome == 14
          input:
            control: Textarea
            placeholder: "Enter country name..."

        # A2: Immigration year (if born outside Canada)
        # Original: Numeric year; also includes "Canadian citizen by birth" option.
        # Precondition: A1 == 14 (born outside Canada).
        - id: q_a2
          kind: Question
          title: "In what year did you first immigrate to Canada?"
          precondition:
            - predicate: q_a1.outcome == 14
          input:
            control: Editbox
            min: 1800
            max: 1986
            right: "year"

        # A3: Date of birth -- modeled as 3 separate Editboxes
        # A3_DAY
        - id: q_a3_day
          kind: Question
          title: "What is your date of birth? (Day)"
          input:
            control: Editbox
            min: 1
            max: 31
            left: "Day:"

        # A3_MONTH
        - id: q_a3_month
          kind: Question
          title: "What is your date of birth? (Month)"
          input:
            control: Editbox
            min: 1
            max: 12
            left: "Month:"

        # A3_YEAR
        - id: q_a3_year
          kind: Question
          title: "What is your date of birth? (Year)"
          input:
            control: Editbox
            min: 1900
            max: 1986
            right: "year"

        # A4: Same community from birth to age 15?
        # 1 (Yes) -> GO TO A7; 2 (No) -> GO TO A5; 3 (DK) -> GO TO SECTION B
        - id: q_a4
          kind: Question
          title: "Did you live in the same community from birth up to age 15? By community I mean city, town or rural area."
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Don't know"

        # A5: Number of communities lived in (if A4=No)
        # Original: 98 = Don't know -> GO TO SECTION B.
        # Modeled with range 1-98 (98 for DK).
        # Precondition: A4 == 2 (No)
        - id: q_a5
          kind: Question
          title: "In how many different communities did you live during this time?"
          precondition:
            - predicate: q_a4.outcome == 2
          input:
            control: Editbox
            min: 1
            max: 98
            left: "Communities:"
          postcondition:
            - predicate: q_a5.outcome >= 1
              hint: "Please enter the number of communities (1-97) or 98 for Don't know."

        # A6: Years in longest community (if A4=No and A5 is not DK)
        # Precondition: A4 == 2 and A5 != 98 (not DK)
        - id: q_a6
          kind: Question
          title: "Think about the community you lived in for the longest time from when you were born until you were 15 years old. For how many of those 15 years did you live there?"
          precondition:
            - predicate: q_a4.outcome == 2
            - predicate: q_a5.outcome != 98
          input:
            control: Editbox
            min: 0
            max: 15
            right: "years"

        # A7: Community size
        # Precondition: A4 in [1, 2] (Yes or No; not DK=3)
        - id: q_a7
          kind: Question
          title: "What was the approximate size of that community?"
          precondition:
            - predicate: q_a4.outcome in [1, 2]
          input:
            control: Dropdown
            labels:
              1: "Less than 5,000 population or a rural area"
              2: "5,000 to less than 25,000 population"
              3: "25,000 to less than 100,000 population"
              4: "100,000 to 1 million population"
              5: "Over 1 million population"

        # A8: Was community in Canada or elsewhere?
        # Precondition: same as A7
        - id: q_a8
          kind: Question
          title: "Was this place in Canada or elsewhere?"
          precondition:
            - predicate: q_a4.outcome in [1, 2]
          input:
            control: Radio
            labels:
              1: "In Canada"
              2: "Elsewhere"

        # A8_TOWN: Town name (if in Canada)
        - id: q_a8_town
          kind: Question
          title: "What was the name of that town or nearest town?"
          precondition:
            - predicate: q_a4.outcome in [1, 2]
            - predicate: q_a8.outcome == 1
          input:
            control: Textarea
            placeholder: "Enter town name..."

        # A8_PROVINCE: Province (if in Canada)
        - id: q_a8_province
          kind: Question
          title: "In which province?"
          precondition:
            - predicate: q_a4.outcome in [1, 2]
            - predicate: q_a8.outcome == 1
          input:
            control: Textarea
            placeholder: "Enter province..."

        # A8_COUNTRY: Country (if elsewhere)
        - id: q_a8_country
          kind: Question
          title: "Which country?"
          precondition:
            - predicate: q_a4.outcome in [1, 2]
            - predicate: q_a8.outcome == 2
          input:
            control: Textarea
            placeholder: "Enter country name..."

    # ===================================================================
    # SECTION: social_mobility_family
    # ===================================================================
    # =========================================================================
    # BLOCK 1: FATHER'S BACKGROUND (B1-B13)
    # =========================================================================
    # B_INTRO: Section introduction
    # B1: Lived with father? (Yes -> B4, No -> B2)
    # B2: Why not? (away from home -> B4, otherwise -> B3)
    # B3: Male substitute? (Yes -> B4, No -> B8)
    # B4: Father's main activity (Working -> employment sub-q, other -> B8)
    # B4a: Employee or self-employed? (Employee -> B5, Self-employed -> B6)
    # B5: Employer name (Employee only)
    # B6-B7: Work details (Working path)
    # B8-B10: Education
    # B11-B13: Origins (country, ethnicity, language)
    # =========================================================================
    - id: b_father
      title: "Father's Background"
      items:
        # B_INTRO: Section introduction
        - id: q_b_intro
          kind: Comment
          title: "For this part of the survey I would like you to recall certain aspects of your life from when you were born to when you were 15 years old."

        # B1: Lived with father at age 15?
        # Yes (1) -> GO TO B4; No (2) -> GO TO B2
        - id: q_b1
          kind: Question
          title: "When you were 15 years old, did you live with your own father? (Include adoptive father)"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # B2: Why not living with father?
        # Precondition: B1 == 0 (No / off)
        # 3 (died) -> B3; 4 (divorced/separated) -> B3;
        # 5 (away from home) -> B4; 6 (other) -> B3
        - id: q_b2
          kind: Question
          title: "Why was this? Was it because..."
          precondition:
            - predicate: q_b1.outcome == 0
          input:
            control: Radio
            labels:
              3: "Your father died"
              4: "Parents were divorced or separated"
              5: "You or your father were temporarily living away from home"
              6: "Other"

        # B2_SPECIFY: Other reason (if B2 == 6)
        - id: q_b2_specify
          kind: Question
          title: "Please specify the reason."
          precondition:
            - predicate: q_b1.outcome == 0
            - predicate: q_b2.outcome == 6
          input:
            control: Textarea
            placeholder: "Specify reason..."

        # B3: Male substitute?
        # Precondition: B1 == 0 and B2 != 5 (not away from home)
        # Yes (7) -> B4; No (8) -> B8
        - id: q_b3
          kind: Question
          title: "During that time, was there a male who took the role of your father?"
          precondition:
            - predicate: q_b1.outcome == 0
            - predicate: q_b2.outcome != 5
          input:
            control: Radio
            labels:
              7: "Yes"
              8: "No"

        # B4: Father's main activity at age 15
        # Precondition: B1 == 1 (lived with father)
        #   OR (B1 == 0 and B2 == 5 — away from home, still ask about father)
        #   OR (B1 == 0 and B2 != 5 and B3 == 7 — male substitute present)
        # Working (1) -> sub-question B4a; others (2-5) -> B8
        - id: q_b4
          kind: Question
          title: "Which of the following best describes your father's (or father substitute's) main activity when you were 15 years old?"
          precondition:
            - predicate: q_b1.outcome == 1 or (q_b1.outcome == 0 and q_b2.outcome == 5) or (q_b1.outcome == 0 and q_b2.outcome != 5 and q_b3.outcome == 7)
          input:
            control: Radio
            labels:
              1: "Working at a job or business"
              2: "A student"
              3: "Retired"
              4: "Keeping house"
              5: "Other"

        # B4_SPECIFY: Other activity (if B4 == 5)
        - id: q_b4_specify
          kind: Question
          title: "Please specify the activity."
          precondition:
            - predicate: q_b1.outcome == 1 or (q_b1.outcome == 0 and q_b2.outcome == 5) or (q_b1.outcome == 0 and q_b2.outcome != 5 and q_b3.outcome == 7)
            - predicate: q_b4.outcome == 5
          input:
            control: Textarea
            placeholder: "Specify activity..."

        # B4a: Employee or self-employed? (sub-question of B4)
        # Precondition: B4 == 1 (working)
        # Employee (6) -> B5; Self-employed (7) -> B6
        - id: q_b4a
          kind: Question
          title: "In this job was he mainly..."
          precondition:
            - predicate: q_b4.outcome == 1
          input:
            control: Radio
            labels:
              6: "An employee working for someone else"
              7: "Self-employed"

        # B5: Employer name (employee only)
        # Precondition: B4 == 1 and B4a == 6 (employee)
        - id: q_b5
          kind: Question
          title: "For whom did he work? (Name of business, government department or agency or person)"
          precondition:
            - predicate: q_b4.outcome == 1
            - predicate: q_b4a.outcome == 6
          input:
            control: Textarea
            placeholder: "Enter employer name (or Don't know)..."

        # B6: Kind of business/industry
        # Precondition: B4 == 1 (working — both employee and self-employed paths)
        - id: q_b6
          kind: Question
          title: "What was the main kind of business, industry or service? (Give a full description: e.g., paper box manufacturing, retail shoe store, municipal board of education)"
          precondition:
            - predicate: q_b4.outcome == 1
          input:
            control: Textarea
            placeholder: "Describe business/industry..."

        # B7: Kind of work
        # Precondition: B4 == 1 (working)
        - id: q_b7
          kind: Question
          title: "What kind of work was he doing? (Give a full description: e.g., posting invoices, selling shoes, teaching primary school)"
          precondition:
            - predicate: q_b4.outcome == 1
          input:
            control: Textarea
            placeholder: "Describe kind of work..."

        # B8: Years of education
        # Reached by: all paths (B4 non-working -> B8, B7 -> B8, B3=No -> B8)
        # No separate precondition needed; routing handles it:
        #   - B1=1 -> B4 -> (non-working -> B8 | working -> B5/B6/B7 -> B8)
        #   - B1=0 -> B2=5 -> B4 -> ... -> B8
        #   - B1=0 -> B2!=5 -> B3=7 -> B4 -> ... -> B8
        #   - B1=0 -> B2!=5 -> B3=8 -> B8 directly
        # Precondition: father/substitute exists OR B3==8 (no substitute, still ask)
        # Actually all paths through the section reach B8, so:
        # B8 is always reachable if father block is entered.
        # But we need to handle B3==8 (no substitute) path:
        # When B3==8, skip B4-B7 but still reach B8.
        # This is implicit: B4 has precondition, so if B3==8, B4 is skipped,
        # and B5-B7 depend on B4, so they are also skipped.
        # B8 has no precondition on B4, so it is always shown.
        - id: q_b8
          kind: Question
          title: "In total, how many years of elementary or secondary education did your father (or father substitute) complete? (Enter 0 for no schooling, 99 for Don't know)"
          input:
            control: Editbox
            min: 0
            max: 99
            right: "years"

        # B9: Further schooling beyond elementary/secondary?
        # Precondition: B8 != 0 (not "no schooling") and B8 != 99 (not DK)
        # Original: 98 = no schooling -> B11; otherwise -> B9
        # We use 0 for no schooling here.
        - id: q_b9
          kind: Question
          title: "Did he have any further schooling beyond elementary/secondary school?"
          precondition:
            - predicate: q_b8.outcome != 0
            - predicate: q_b8.outcome != 99
          input:
            control: Radio
            labels:
              3: "Yes"
              4: "No"
              5: "Don't know"

        # B10: Highest level attained
        # Precondition: B9 == 3 (Yes, had further schooling)
        - id: q_b10
          kind: Question
          title: "What was the highest level he attained?"
          precondition:
            - predicate: q_b9.outcome == 3
          input:
            control: Dropdown
            labels:
              1: "Some community college, CEGEP or nursing school"
              2: "Diploma or certificate from community college, CEGEP or nursing school"
              3: "Some university"
              4: "Bachelor or undergraduate degree or teacher's college"
              5: "Master's or earned doctorate"
              6: "Other"
              7: "Don't know"

        # B10_SPECIFY: Other level (if B10 == 6)
        - id: q_b10_specify
          kind: Question
          title: "Please specify the education level."
          precondition:
            - predicate: q_b9.outcome == 3
            - predicate: q_b10.outcome == 6
          input:
            control: Textarea
            placeholder: "Specify education level..."

        # B11: Country of birth (father)
        # Same structure as A1: Canada with province or outside Canada
        - id: q_b11
          kind: Question
          title: "In what country was he born? (If born in Canada, select the province.)"
          input:
            control: Dropdown
            labels:
              1: "Canada (province not specified)"
              2: "Newfoundland"
              3: "Prince Edward Island"
              4: "Nova Scotia"
              5: "New Brunswick"
              6: "Quebec"
              7: "Ontario"
              8: "Manitoba"
              9: "Saskatchewan"
              10: "Alberta"
              11: "British Columbia"
              12: "Yukon Territory"
              13: "Northwest Territories"
              14: "Country outside Canada"

        # B11_SPECIFY: Specify country (if outside Canada)
        - id: q_b11_specify
          kind: Question
          title: "Please specify the country."
          precondition:
            - predicate: q_b11.outcome == 14
          input:
            control: Textarea
            placeholder: "Enter country name..."

        # B12: Ethnic/cultural group (multi-select)
        # Power-of-2 keys for Checkbox
        - id: q_b12
          kind: Question
          title: "To which ethnic or cultural group did he belong? (Mark all that apply.)"
          input:
            control: Checkbox
            labels:
              1: "English"
              2: "French"
              4: "Irish"
              8: "Scottish"
              16: "German"
              32: "Italian"
              64: "Ukrainian"
              128: "Other"
              256: "Don't know"

        # B12_SPECIFY: Other ethnic group (if Other selected)
        # Check if bit 128 is set: outcome % 256 >= 128
        - id: q_b12_specify
          kind: Question
          title: "Please specify the ethnic or cultural group."
          precondition:
            - predicate: q_b12.outcome % 256 >= 128
          input:
            control: Textarea
            placeholder: "Specify ethnic group..."

        # B13: First language learned in childhood (multi-select)
        - id: q_b13
          kind: Question
          title: "What was the first language he learned in childhood? (Accept multiple response only if languages learned at same time.)"
          input:
            control: Checkbox
            labels:
              1: "English"
              2: "French"
              4: "Other"
              8: "Don't know"

        # B13_SPECIFY: Other language (if Other selected)
        # Check if bit 4 is set: outcome % 8 >= 4
        - id: q_b13_specify
          kind: Question
          title: "Please specify the language."
          precondition:
            - predicate: q_b13.outcome % 8 >= 4
          input:
            control: Textarea
            placeholder: "Specify language..."

    # =========================================================================
    # BLOCK 2: MOTHER'S BACKGROUND (B14-B26)
    # =========================================================================
    # Parallel structure to father's block.
    # B14: Lived with mother? (Yes -> B17, No -> B15)
    # B15: Why not? (away from home -> B17, otherwise -> B16)
    # B16: Female substitute? (Yes -> B17, No -> B21)
    # B17: Mother's main activity (Working -> sub-q, other -> B21)
    # B17a: Employee or self-employed?
    # B18: Employer (employee only)
    # B19-B20: Work details
    # B21-B23: Education
    # B24-B26: Origins
    # =========================================================================
    - id: b_mother
      title: "Mother's Background"
      items:
        # B14: Lived with mother at age 15?
        # Yes (1) -> B17; No (2) -> B15
        - id: q_b14
          kind: Question
          title: "The next questions ask about your mother. When you were 15 years old, did you live with your own mother? (Include adoptive mother)"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # B15: Why not living with mother?
        # Precondition: B14 == 0 (No)
        - id: q_b15
          kind: Question
          title: "Why was this? Was it because..."
          precondition:
            - predicate: q_b14.outcome == 0
          input:
            control: Radio
            labels:
              3: "Your mother died"
              4: "Parents were divorced or separated"
              5: "You or your mother were temporarily living away from home"
              6: "Other"

        # B15_SPECIFY: Other reason
        - id: q_b15_specify
          kind: Question
          title: "Please specify the reason."
          precondition:
            - predicate: q_b14.outcome == 0
            - predicate: q_b15.outcome == 6
          input:
            control: Textarea
            placeholder: "Specify reason..."

        # B16: Female substitute?
        # Precondition: B14 == 0 and B15 != 5 (not away from home)
        # Yes (7) -> B17; No (8) -> B21
        - id: q_b16
          kind: Question
          title: "During that time, was there a female who took the role of your mother?"
          precondition:
            - predicate: q_b14.outcome == 0
            - predicate: q_b15.outcome != 5
          input:
            control: Radio
            labels:
              7: "Yes"
              8: "No"

        # B17: Mother's main activity at age 15
        # Precondition: B14 == 1 (lived with mother)
        #   OR (B14 == 0 and B15 == 5 — away from home)
        #   OR (B14 == 0 and B15 != 5 and B16 == 7 — female substitute)
        - id: q_b17
          kind: Question
          title: "Which of the following best describes your mother's (or mother substitute's) main activity when you were 15 years old?"
          precondition:
            - predicate: q_b14.outcome == 1 or (q_b14.outcome == 0 and q_b15.outcome == 5) or (q_b14.outcome == 0 and q_b15.outcome != 5 and q_b16.outcome == 7)
          input:
            control: Radio
            labels:
              1: "Working at a job or business"
              2: "Keeping house"
              3: "A student"
              4: "Retired"
              5: "Other"

        # B17_SPECIFY: Other activity
        - id: q_b17_specify
          kind: Question
          title: "Please specify the activity."
          precondition:
            - predicate: q_b14.outcome == 1 or (q_b14.outcome == 0 and q_b15.outcome == 5) or (q_b14.outcome == 0 and q_b15.outcome != 5 and q_b16.outcome == 7)
            - predicate: q_b17.outcome == 5
          input:
            control: Textarea
            placeholder: "Specify activity..."

        # B17a: Employee or self-employed?
        # Precondition: B17 == 1 (working)
        - id: q_b17a
          kind: Question
          title: "In this job was she mainly..."
          precondition:
            - predicate: q_b17.outcome == 1
          input:
            control: Radio
            labels:
              6: "An employee working for someone else"
              7: "Self-employed"

        # B18: Employer name (employee only)
        # Precondition: B17 == 1 and B17a == 6
        - id: q_b18
          kind: Question
          title: "For whom did she work? (Name of business, government department or agency or person)"
          precondition:
            - predicate: q_b17.outcome == 1
            - predicate: q_b17a.outcome == 6
          input:
            control: Textarea
            placeholder: "Enter employer name (or Don't know)..."

        # B19: Kind of business/industry
        # Precondition: B17 == 1 (working — both employee and self-employed)
        - id: q_b19
          kind: Question
          title: "What was the main kind of business, industry or service?"
          precondition:
            - predicate: q_b17.outcome == 1
          input:
            control: Textarea
            placeholder: "Describe business/industry..."

        # B20: Kind of work
        # Precondition: B17 == 1
        - id: q_b20
          kind: Question
          title: "What kind of work was she doing?"
          precondition:
            - predicate: q_b17.outcome == 1
          input:
            control: Textarea
            placeholder: "Describe kind of work..."

        # B21: Years of education (mother)
        # All paths reach B21.
        - id: q_b21
          kind: Question
          title: "In total, how many years of elementary or secondary education did your mother (or mother substitute) complete? (Enter 0 for no schooling, 99 for Don't know)"
          input:
            control: Editbox
            min: 0
            max: 99
            right: "years"

        # B22: Further schooling?
        # Precondition: B21 != 0 (not no schooling) and B21 != 99 (not DK)
        - id: q_b22
          kind: Question
          title: "Did she have any further schooling beyond elementary/secondary school?"
          precondition:
            - predicate: q_b21.outcome != 0
            - predicate: q_b21.outcome != 99
          input:
            control: Radio
            labels:
              3: "Yes"
              4: "No"
              5: "Don't know"

        # B23: Highest level attained
        # Precondition: B22 == 3 (Yes)
        - id: q_b23
          kind: Question
          title: "What was the highest level she attained?"
          precondition:
            - predicate: q_b22.outcome == 3
          input:
            control: Dropdown
            labels:
              1: "Some community college, CEGEP or nursing school"
              2: "Diploma or certificate from community college, CEGEP or nursing school"
              3: "Some university"
              4: "Bachelor or undergraduate degree or teacher's college"
              5: "Master's or earned doctorate"
              6: "Other"
              7: "Don't know"

        # B23_SPECIFY: Other level
        - id: q_b23_specify
          kind: Question
          title: "Please specify the education level."
          precondition:
            - predicate: q_b22.outcome == 3
            - predicate: q_b23.outcome == 6
          input:
            control: Textarea
            placeholder: "Specify education level..."

        # B24: Country of birth (mother)
        - id: q_b24
          kind: Question
          title: "In what country was she born? (If born in Canada, select the province.)"
          input:
            control: Dropdown
            labels:
              1: "Canada (province not specified)"
              2: "Newfoundland"
              3: "Prince Edward Island"
              4: "Nova Scotia"
              5: "New Brunswick"
              6: "Quebec"
              7: "Ontario"
              8: "Manitoba"
              9: "Saskatchewan"
              10: "Alberta"
              11: "British Columbia"
              12: "Yukon Territory"
              13: "Northwest Territories"
              14: "Country outside Canada"

        # B24_SPECIFY: Specify country
        - id: q_b24_specify
          kind: Question
          title: "Please specify the country."
          precondition:
            - predicate: q_b24.outcome == 14
          input:
            control: Textarea
            placeholder: "Enter country name..."

        # B25: Ethnic/cultural group (mother)
        - id: q_b25
          kind: Question
          title: "To which ethnic or cultural group did she belong? (Mark all that apply.)"
          input:
            control: Checkbox
            labels:
              1: "English"
              2: "French"
              4: "Irish"
              8: "Scottish"
              16: "German"
              32: "Italian"
              64: "Ukrainian"
              128: "Other"
              256: "Don't know"

        # B25_SPECIFY: Other ethnic group
        - id: q_b25_specify
          kind: Question
          title: "Please specify the ethnic or cultural group."
          precondition:
            - predicate: q_b25.outcome % 256 >= 128
          input:
            control: Textarea
            placeholder: "Specify ethnic group..."

        # B26: First language (mother)
        - id: q_b26
          kind: Question
          title: "What was the first language she learned in childhood? (Accept multiple response only if languages learned at same time.)"
          input:
            control: Checkbox
            labels:
              1: "English"
              2: "French"
              4: "Other"
              8: "Don't know"

        # B26_SPECIFY: Other language
        - id: q_b26_specify
          kind: Question
          title: "Please specify the language."
          precondition:
            - predicate: q_b26.outcome % 8 >= 4
          input:
            control: Textarea
            placeholder: "Specify language..."

    # =========================================================================
    # BLOCK 3: RESPONDENT'S ORIGINS (B27-B29)
    # =========================================================================
    # B27: Respondent's first language
    # B28: Number of brothers
    # B29: Number of sisters
    # =========================================================================
    - id: b_respondent_origins
      title: "Respondent's Origins"
      items:
        # B27: Respondent's own first language
        - id: q_b27
          kind: Question
          title: "What language did you yourself first speak in childhood? (Accept multiple response only if languages were spoken equally.)"
          input:
            control: Checkbox
            labels:
              1: "English"
              2: "French"
              4: "Other"

        # B27_SPECIFY: Other language
        - id: q_b27_specify
          kind: Question
          title: "Please specify the language."
          precondition:
            - predicate: q_b27.outcome % 8 >= 4
          input:
            control: Textarea
            placeholder: "Specify language..."

        # B28: Number of brothers
        - id: q_b28
          kind: Question
          title: "How many brothers have you ever had? (Include step-, half- and adopted brothers and those no longer living.)"
          input:
            control: Editbox
            min: 0
            max: 50

        # B29: Number of sisters
        - id: q_b29
          kind: Question
          title: "How many sisters have you ever had? (Include step-, half- and adopted sisters and those no longer living.)"
          input:
            control: Editbox
            min: 0
            max: 50

    # ===================================================================
    # SECTION: daily_activities
    # ===================================================================
    # =========================================================================
    # BLOCK: DAILY ACTIVITIES — 24-HOUR TIME DIARY
    # =========================================================================
    # The original questionnaire records up to 44 sequential activities
    # covering a full 24-hour reference day (starting at 4:00 a.m.).
    # Each activity captures: activity code, end time, location, companions.
    #
    # JUSTIFIED OMISSION: Activities 4-44 follow an identical repeating
    # pattern to Activities 1-3 shown below. The original questionnaire
    # uses a dynamic roster loop where the same 4-5 sub-questions repeat
    # for each activity slot. QML cannot model dynamic roster loops, so
    # only 3 representative activities are included to demonstrate the
    # pattern. In a production implementation, the full 44 activity slots
    # would be generated programmatically.
    # =========================================================================
    - id: b_daily_activities
      title: "Daily Activities"
      items:
        # D_DAY: Reference day for time diary
        - id: q_d_day
          kind: Question
          title: "INTERVIEWER: 'X' DAY TO WHICH ACTIVITIES REFER"
          input:
            control: Radio
            labels:
              1: "Sunday"
              2: "Monday"
              3: "Tuesday"
              4: "Wednesday"
              5: "Thursday"
              6: "Friday"
              7: "Saturday"

        # D_INTRO: Section introduction read to respondent
        - id: q_d_intro
          kind: Comment
          title: "These next questions ask about your daily activities. We need to know in as much detail as you can recall, what you did during the reference day starting at 4:00 o'clock in the morning. This section will provide information on transportation activity, amount of time spent on housework, leisure, paid work, etc. You may have been doing more than one thing at a time but we are interested in the main activity for each time period. We are not interested in activities which lasted only a minute or two. We also ask where you did each activity and if anyone was interacting with you during the activity."

        # =================================================================
        # ACTIVITY 1 (starting at 4:00 a.m.)
        # =================================================================

        # D1a: Activity code for first activity
        - id: q_d1_activity
          kind: Question
          title: "First of all, starting at 4:00 a.m., what were you doing?"
          input:
            control: Editbox
            min: 0
            max: 99
            right: "(2-digit activity code)"

        # D1c: End time — hour component
        - id: q_d1_end_hour
          kind: Question
          title: "When did this end? (Hour)"
          input:
            control: Editbox
            min: 0
            max: 23
            right: "hour (0-23)"

        # D1c: End time — minute component
        - id: q_d1_end_min
          kind: Question
          title: "When did this end? (Minutes)"
          input:
            control: Editbox
            min: 0
            max: 59
            right: "minutes (0-59)"

        # D1d: Location/transit mode
        - id: q_d1_location
          kind: Question
          title: "Where were you?"
          input:
            control: Radio
            labels:
              1: "Home"
              2: "Work Place"
              3: "Other Place"
              4: "Car"
              5: "Walk"
              6: "Bus/Subway"
              7: "Other transit"

        # D1e: Companions (multi-select)
        - id: q_d1_companions
          kind: Question
          title: "Who was with you?"
          input:
            control: Checkbox
            labels:
              1: "Alone"
              2: "Spouse/Partner"
              4: "Children"
              8: "Other Family"
              16: "Friends"
              32: "Other Persons"

        # =================================================================
        # ACTIVITY 2 (continues from end of Activity 1)
        # =================================================================

        # D2a: Activity code
        - id: q_d2_activity
          kind: Question
          title: "And then, what did you do next?"
          input:
            control: Editbox
            min: 0
            max: 99
            right: "(2-digit activity code)"

        # D2b: Start time — hour
        # Continuity rule (inventory lines 181-182): each activity's start
        # time must equal the previous activity's end time, otherwise the
        # 24-hour day has a gap and the diary is inconsistent.
        - id: q_d2_start_hour
          kind: Question
          title: "When did this start? (Hour)"
          postcondition:
            - predicate: q_d2_start_hour.outcome == q_d1_end_hour.outcome
              hint: "The start time of this activity must match the end time of the previous one — the diary cannot have gaps."
          input:
            control: Editbox
            min: 0
            max: 23
            right: "hour (0-23)"

        # D2b: Start time — minutes
        - id: q_d2_start_min
          kind: Question
          title: "When did this start? (Minutes)"
          postcondition:
            - predicate: q_d2_start_min.outcome == q_d1_end_min.outcome
              hint: "The start minute of this activity must match the end minute of the previous one."
          input:
            control: Editbox
            min: 0
            max: 59
            right: "minutes (0-59)"

        # D2c: End time — hour
        - id: q_d2_end_hour
          kind: Question
          title: "When did this end? (Hour)"
          input:
            control: Editbox
            min: 0
            max: 23
            right: "hour (0-23)"

        # D2c: End time — minutes
        - id: q_d2_end_min
          kind: Question
          title: "When did this end? (Minutes)"
          input:
            control: Editbox
            min: 0
            max: 59
            right: "minutes (0-59)"

        # D2d: Location/transit mode
        - id: q_d2_location
          kind: Question
          title: "Where were you?"
          input:
            control: Radio
            labels:
              1: "Home"
              2: "Work Place"
              3: "Other Place"
              4: "Car"
              5: "Walk"
              6: "Bus/Subway"
              7: "Other transit"

        # D2e: Companions
        - id: q_d2_companions
          kind: Question
          title: "Who was with you?"
          input:
            control: Checkbox
            labels:
              1: "Alone"
              2: "Spouse/Partner"
              4: "Children"
              8: "Other Family"
              16: "Friends"
              32: "Other Persons"

        # =================================================================
        # ACTIVITY 3 (continues from end of Activity 2)
        # =================================================================

        # D3a: Activity code
        - id: q_d3_activity
          kind: Question
          title: "And then, what did you do next?"
          input:
            control: Editbox
            min: 0
            max: 99
            right: "(2-digit activity code)"

        # D3b: Start time — hour (continuity with end of Activity 2)
        - id: q_d3_start_hour
          kind: Question
          title: "When did this start? (Hour)"
          postcondition:
            - predicate: q_d3_start_hour.outcome == q_d2_end_hour.outcome
              hint: "The start time of this activity must match the end time of the previous one — the diary cannot have gaps."
          input:
            control: Editbox
            min: 0
            max: 23
            right: "hour (0-23)"

        # D3b: Start time — minutes
        - id: q_d3_start_min
          kind: Question
          title: "When did this start? (Minutes)"
          postcondition:
            - predicate: q_d3_start_min.outcome == q_d2_end_min.outcome
              hint: "The start minute of this activity must match the end minute of the previous one."
          input:
            control: Editbox
            min: 0
            max: 59
            right: "minutes (0-59)"

        # D3c: End time — hour
        - id: q_d3_end_hour
          kind: Question
          title: "When did this end? (Hour)"
          input:
            control: Editbox
            min: 0
            max: 23
            right: "hour (0-23)"

        # D3c: End time — minutes
        - id: q_d3_end_min
          kind: Question
          title: "When did this end? (Minutes)"
          input:
            control: Editbox
            min: 0
            max: 59
            right: "minutes (0-59)"

        # D3d: Location/transit mode
        - id: q_d3_location
          kind: Question
          title: "Where were you?"
          input:
            control: Radio
            labels:
              1: "Home"
              2: "Work Place"
              3: "Other Place"
              4: "Car"
              5: "Walk"
              6: "Bus/Subway"
              7: "Other transit"

        # D3e: Companions
        - id: q_d3_companions
          kind: Question
          title: "Who was with you?"
          input:
            control: Checkbox
            labels:
              1: "Alone"
              2: "Spouse/Partner"
              4: "Children"
              8: "Other Family"
              16: "Friends"
              32: "Other Persons"

        # =================================================================
        # ACTIVITIES 4-44: OMITTED (identical repeating pattern)
        # =================================================================
        # Activities 4 through 44 follow the exact same structure as
        # Activity 2-3 above: activity code, start time (hour/min),
        # end time (hour/min), location, and companions. The grid
        # continues until the respondent accounts for the full 24-hour
        # reference day or runs out of activity slots. If more than 44
        # activities are needed, extension form GSS 2-2D is used.
        # =================================================================
        - id: q_d_omitted_note
          kind: Comment
          title: "Activities 4 through 44 follow the identical pattern shown above (activity code, start time, end time, location, companions). Each activity captures the next sequential period of the 24-hour reference day. This roster is not fully expanded in the QML model due to the dynamic loop structure of the original questionnaire."

        # D1e interviewer rule (inventory line 177):
        # "Do not ask about sleep, sex, or other personal care activities"
        # when recording companions. Activity codes for these fall in the
        # personal-care range of the Statistics Canada activity code
        # table. Because the QML accepts any 2-digit numeric code, the
        # filter cannot be expressed as a precondition without enumerating
        # the code table; it is retained here as an interviewer note so
        # the rule is not lost in downstream review.
        - id: q_d_companion_rule_note
          kind: Comment
          title: "Interviewer: Do not ask who was with the respondent for activities that code as sleep, sex, or other personal care. Mark companions as 'Alone' or leave blank for these rows."

        # D_EXTRA: Extension-form tracking (inventory lines 191-192)
        # =================================================================
        - id: q_d_extra_used
          kind: Question
          title: "Were more than 44 activities recorded, requiring an extension form (GSS 2-2D)?"
          input:
            control: Radio
            labels:
              1: "No — fits on the main diary"
              2: "Yes — extension form(s) used"

        - id: q_d_extra_count
          kind: Question
          title: "How many extension forms were used?"
          precondition:
            - predicate: q_d_extra_used.outcome == 2
          input:
            control: Editbox
            min: 1
            max: 10
            right: "extension form(s)"

    # ===================================================================
    # SECTION: wellbeing
    # ===================================================================
    # =========================================================================
    # BLOCK: WELL-BEING
    # =========================================================================
    # E1: General happiness
    # E2a-E2i: Satisfaction across 9 life domains
    # E3: Overall life satisfaction
    # No routing/preconditions — all items shown to everyone.
    # =========================================================================
    - id: b_wellbeing
      title: "Well-being"
      items:
        # E1: General happiness
        - id: q_e1
          kind: Question
          title: "Presently, would you describe yourself as..."
          input:
            control: Radio
            labels:
              1: "Very happy"
              2: "Somewhat happy"
              3: "Somewhat unhappy"
              4: "Very unhappy"
              5: "No opinion"

        # E2a: Satisfaction — health
        - id: q_e2a
          kind: Question
          title: "I am going to ask you to rate certain areas of your life. Please rate your feelings about them as very satisfied, somewhat satisfied, somewhat dissatisfied or very dissatisfied. Your health:"
          input:
            control: Radio
            labels:
              1: "Very satisfied"
              2: "Somewhat satisfied"
              3: "Somewhat dissatisfied"
              4: "Very dissatisfied"
              5: "No opinion"

        # E2b: Satisfaction — job or main activity
        - id: q_e2b
          kind: Question
          title: "Your job or main activity:"
          input:
            control: Radio
            labels:
              1: "Very satisfied"
              2: "Somewhat satisfied"
              3: "Somewhat dissatisfied"
              4: "Very dissatisfied"
              5: "No opinion"

        # E2c: Satisfaction — spare time
        - id: q_e2c
          kind: Question
          title: "The way you spend your other time:"
          input:
            control: Radio
            labels:
              1: "Very satisfied"
              2: "Somewhat satisfied"
              3: "Somewhat dissatisfied"
              4: "Very dissatisfied"
              5: "No opinion"

        # E2d: Satisfaction — finances
        - id: q_e2d
          kind: Question
          title: "Your finances:"
          input:
            control: Radio
            labels:
              1: "Very satisfied"
              2: "Somewhat satisfied"
              3: "Somewhat dissatisfied"
              4: "Very dissatisfied"
              5: "No opinion"

        # E2e: Satisfaction — housing
        - id: q_e2e
          kind: Question
          title: "Your housing:"
          input:
            control: Radio
            labels:
              1: "Very satisfied"
              2: "Somewhat satisfied"
              3: "Somewhat dissatisfied"
              4: "Very dissatisfied"
              5: "No opinion"

        # E2f: Satisfaction — friendships
        - id: q_e2f
          kind: Question
          title: "Your friendships:"
          input:
            control: Radio
            labels:
              1: "Very satisfied"
              2: "Somewhat satisfied"
              3: "Somewhat dissatisfied"
              4: "Very dissatisfied"
              5: "No opinion"

        # E2g: Satisfaction — living partner or single status
        - id: q_e2g
          kind: Question
          title: "Living partner or single status:"
          input:
            control: Radio
            labels:
              1: "Very satisfied"
              2: "Somewhat satisfied"
              3: "Somewhat dissatisfied"
              4: "Very dissatisfied"
              5: "No opinion"

        # E2h: Satisfaction — family relationships
        - id: q_e2h
          kind: Question
          title: "Your relationship with other family members:"
          input:
            control: Radio
            labels:
              1: "Very satisfied"
              2: "Somewhat satisfied"
              3: "Somewhat dissatisfied"
              4: "Very dissatisfied"
              5: "No opinion"

        # E2i: Satisfaction — self-esteem
        - id: q_e2i
          kind: Question
          title: "Yourself (self-esteem):"
          input:
            control: Radio
            labels:
              1: "Very satisfied"
              2: "Somewhat satisfied"
              3: "Somewhat dissatisfied"
              4: "Very dissatisfied"
              5: "No opinion"

        # E3: Overall life satisfaction
        - id: q_e3
          kind: Question
          title: "Now, using the same scale, how do you feel about your life as a whole right now?"
          input:
            control: Radio
            labels:
              1: "Very satisfied"
              2: "Somewhat satisfied"
              3: "Somewhat dissatisfied"
              4: "Very dissatisfied"
              5: "No opinion"

    # ===================================================================
    # SECTION: language_filter
    # ===================================================================
    # =========================================================================
    # BLOCK: LANGUAGE FILTER
    # =========================================================================
    # F1:  Main language — major routing point for the entire questionnaire
    # F1a: Whether English-only respondent knows any other language
    #      (determines G vs T path)
    #
    # Routing summary from F1:
    #   1 (English)       -> F1a -> if Yes: lang_path=1 (->G)
    #                             -> if No:  lang_path=7 (->T)
    #   2 (Eng + Fr)      -> lang_path=2 (->H)
    #   3 (Eng + Other)   -> lang_path=3 (->J)
    #   4 (French)        -> lang_path=4 (->K)
    #   5 (Fr + Other)    -> lang_path=5 (->L)
    #   6 (Other)         -> lang_path=6 (->M)
    # =========================================================================
    - id: b_language_filter
      title: "Language Knowledge and Use"
      items:
        # F1: Main language
        # codeBlock sets lang_path for non-English responses (2-6).
        # English (1) is handled by F1a below.
        - id: q_f1
          kind: Question
          title: "What is your main language, that is, the language in which you are most at ease? (Report two if the respondent is equally at ease in two languages.)"
          codeBlock: |
            if q_f1.outcome == 2:
                lang_path = 2
            elif q_f1.outcome == 3:
                lang_path = 3
            elif q_f1.outcome == 4:
                lang_path = 4
            elif q_f1.outcome == 5:
                lang_path = 5
            elif q_f1.outcome == 6:
                lang_path = 6
          input:
            control: Radio
            labels:
              1: "English"
              2: "English and French"
              3: "English and Other"
              4: "French"
              5: "French and Other"
              6: "Other"

        # F1 specify: open text for "Other" responses
        - id: q_f1_specify
          kind: Question
          title: "Please specify the other language:"
          precondition:
            - predicate: q_f1.outcome in [3, 5, 6]
          input:
            control: Textarea
            placeholder: "Specify language..."

        # F1a: Knowledge of other languages (English-only respondents)
        # Original codes: 7=Yes, 8=No; modeled as Switch (0=No, 1=Yes)
        - id: q_f1a
          kind: Question
          title: "Have you ever had any knowledge or understanding of a language other than English?"
          precondition:
            - predicate: q_f1.outcome == 1
          codeBlock: |
            if q_f1a.outcome == 1:
                lang_path = 1
            else:
                lang_path = 7
          input:
            control: Switch
            off: "No"
            on: "Yes"

    # ===================================================================
    # SECTION: language_english_other
    # ===================================================================
    # =========================================================================
    # BLOCK: SECTION G — English main, other language knowledge
    # =========================================================================
    # Routing summary:
    #   G1 = Yes (1) → G2 → G3 → G4 → G5 → G6
    #   G1 = No  (0) → G6
    #   G6 = Yes (1) → G6a → G7 → G8 → G9 check
    #   G6 = No  (0) → G9 check
    #   G9: if G1=No AND G6=No → Section N (skips G10)
    #        otherwise → G10 → Section N
    #   G10: asked if respondent knows French or another language
    # =========================================================================
    - id: b_section_g
      title: "Language — English Main"
      precondition:
        - predicate: lang_path == 1
      items:
        # G1: French knowledge
        - id: q_g1
          kind: Question
          title: "Do you have any knowledge or understanding of French?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # G2: Last French conversation
        # Precondition: knows French (G1 = 1)
        - id: q_g2
          kind: Question
          title: "When was the last time that you had a conversation in French, excluding language courses?"
          precondition:
            - predicate: q_g1.outcome == 1
          input:
            control: Radio
            labels:
              1: "During the last week"
              2: "During the last month"
              3: "During the last year"
              4: "More than a year"
              5: "Never"

        # G3: French proficiency (Reading, Understanding, Speaking)
        # Precondition: knows French (G1 = 1)
        - id: qg_g3
          kind: QuestionGroup
          title: "How would you rate yourself in the following language abilities in French?"
          precondition:
            - predicate: q_g1.outcome == 1
          questions:
            - "Reading"
            - "Understanding"
            - "Speaking"
          input:
            control: Dropdown
            labels:
              1: "Very good"
              2: "Good"
              3: "Not very good"
              4: "Not at all"

        # G4: French knowledge sources
        # Precondition: knows French (G1 = 1)
        - id: q_g4
          kind: Question
          title: "What would you say contributed the most to your present knowledge of French?"
          precondition:
            - predicate: q_g1.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "Language instruction at school"
              2: "Other language courses"
              4: "Speaking with family"
              8: "Speaking with friends"
              16: "Speaking at work"
              32: "Watching television"
              64: "Other"

        # G4_other: Specify other source
        # Precondition: "Other" selected in G4 (bit 64)
        - id: q_g4_other
          kind: Question
          title: "Please specify the other source of French knowledge:"
          precondition:
            - predicate: q_g1.outcome == 1
            - predicate: q_g4.outcome % 128 >= 64
          input:
            control: Textarea
            placeholder: "Specify..."

        # G5: French change compared to 5 years ago (Know, Use)
        # Precondition: knows French (G1 = 1)
        - id: qg_g5
          kind: QuestionGroup
          title: "Compared to five years ago, would you say that you now know/use more French, less French, or about the same?"
          precondition:
            - predicate: q_g1.outcome == 1
          questions:
            - "Know"
            - "Use"
          input:
            control: Radio
            labels:
              1: "More"
              2: "Less"
              3: "About the same"

        # G6: Other language knowledge (besides English and French)
        - id: q_g6
          kind: Question
          title: "Do you have any knowledge or understanding of a language other than English or French?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # G6a: How many other languages
        # Precondition: knows other language (G6 = 1)
        - id: q_g6a
          kind: Question
          title: "How many other languages do you know or understand?"
          precondition:
            - predicate: q_g6.outcome == 1
          input:
            control: Radio
            labels:
              1: "One language"
              2: "Multiple languages (report best known)"

        # G6a_spec: Specify language(s)
        # Precondition: knows other language (G6 = 1)
        - id: q_g6a_spec
          kind: Question
          title: "Please specify the language(s):"
          precondition:
            - predicate: q_g6.outcome == 1
          input:
            control: Textarea
            placeholder: "Specify language..."

        # G7: Last conversation in other language
        # Precondition: knows other language (G6 = 1)
        - id: q_g7
          kind: Question
          title: "When was the last time you had a conversation in that language, excluding language courses?"
          precondition:
            - predicate: q_g6.outcome == 1
          input:
            control: Radio
            labels:
              1: "During the last week"
              2: "During the last month"
              3: "During the last year"
              4: "More than a year"
              5: "Never"

        # G8: Other language proficiency (Reading, Understanding, Speaking)
        # Precondition: knows other language (G6 = 1)
        - id: qg_g8
          kind: QuestionGroup
          title: "In that language, how would you rate yourself in the following abilities?"
          precondition:
            - predicate: q_g6.outcome == 1
          questions:
            - "Reading"
            - "Understanding"
            - "Speaking"
          input:
            control: Dropdown
            labels:
              1: "Very good"
              2: "Good"
              3: "Not very good"
              4: "Not at all"

        # G9 is a filter: if G1=No AND G6=No → skip to Section N (skip G10)
        # Modeled as precondition on G10: shown only if G1=Yes OR G6=Yes

        # G10: English use change
        # Precondition: respondent knows French or another language
        - id: q_g10
          kind: Question
          title: "Compared to five years ago, would you say that you now use more English, less English, or about the same?"
          precondition:
            - predicate: q_g1.outcome == 1 or q_g6.outcome == 1
          input:
            control: Radio
            labels:
              1: "More"
              2: "Less"
              3: "About the same"

        # G11 is routing only (GO TO SECTION N) — omitted

    # ===================================================================
    # SECTION: language_english_french
    # ===================================================================
    # =========================================================================
    # BLOCK: SECTION H — English and French bilingual
    # =========================================================================
    # Routing summary:
    #   H1 → H2 → H3
    #   H3 = Yes (1) → H3a → H4 → H5 → Section N
    #   H3 = No  (0) → Section N
    # =========================================================================
    - id: b_section_h
      title: "Language — English and French Bilingual"
      precondition:
        - predicate: lang_path == 2
      items:
        # H1: English change compared to 5 years ago (Know, Use)
        - id: qg_h1
          kind: QuestionGroup
          title: "Compared to five years ago, would you say that you now know/use more English, less English, or about the same?"
          questions:
            - "Know"
            - "Use"
          input:
            control: Radio
            labels:
              1: "More"
              2: "Less"
              3: "About the same"

        # H2: French change compared to 5 years ago (Know, Use)
        - id: qg_h2
          kind: QuestionGroup
          title: "Compared to five years ago, would you say that you now know/use more French, less French, or about the same?"
          questions:
            - "Know"
            - "Use"
          input:
            control: Radio
            labels:
              1: "More"
              2: "Less"
              3: "About the same"

        # H3: Other language knowledge (besides English and French)
        - id: q_h3
          kind: Question
          title: "Do you have any knowledge or understanding of a language other than English or French?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # H3a: How many other languages
        # Precondition: knows other language (H3 = 1)
        - id: q_h3a
          kind: Question
          title: "How many other languages do you know or understand?"
          precondition:
            - predicate: q_h3.outcome == 1
          input:
            control: Radio
            labels:
              1: "One language"
              2: "Multiple languages (report best known)"

        # H3a_spec: Specify language(s)
        # Precondition: knows other language (H3 = 1)
        - id: q_h3a_spec
          kind: Question
          title: "Please specify the language(s):"
          precondition:
            - predicate: q_h3.outcome == 1
          input:
            control: Textarea
            placeholder: "Specify language..."

        # H4: Last conversation in other language
        # Precondition: knows other language (H3 = 1)
        - id: q_h4
          kind: Question
          title: "When was the last time you had a conversation in that language, excluding language courses?"
          precondition:
            - predicate: q_h3.outcome == 1
          input:
            control: Radio
            labels:
              1: "During the last week"
              2: "During the last month"
              3: "During the last year"
              4: "More than a year"
              5: "Never"

        # H5: Other language proficiency (Reading, Understanding, Speaking)
        # Precondition: knows other language (H3 = 1)
        - id: qg_h5
          kind: QuestionGroup
          title: "In that language, how would you rate yourself in the following abilities?"
          precondition:
            - predicate: q_h3.outcome == 1
          questions:
            - "Reading"
            - "Understanding"
            - "Speaking"
          input:
            control: Dropdown
            labels:
              1: "Very good"
              2: "Good"
              3: "Not very good"
              4: "Not at all"

        # H6 is routing only (GO TO SECTION N) — omitted

    # ===================================================================
    # SECTION: language_english_other_lang
    # ===================================================================
    # =========================================================================
    # BLOCK: SECTION J — English and Other language
    # =========================================================================
    # Routing summary:
    #   J1 → J2
    #   J2 = Yes (1) → J3 → J4 → J5 → J6 → J7 → Section N
    #   J2 = No  (0) → J7 → Section N
    # =========================================================================
    - id: b_section_j
      title: "Language — English and Other"
      precondition:
        - predicate: lang_path == 3
      items:
        # J1: English change compared to 5 years ago (Know, Use)
        - id: qg_j1
          kind: QuestionGroup
          title: "Compared to five years ago, would you say that you now know/use more English, less English, or about the same?"
          questions:
            - "Know"
            - "Use"
          input:
            control: Radio
            labels:
              1: "More"
              2: "Less"
              3: "About the same"

        # J2: French knowledge
        - id: q_j2
          kind: Question
          title: "Do you have any knowledge or understanding of French?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # J3: Last French conversation
        # Precondition: knows French (J2 = 1)
        - id: q_j3
          kind: Question
          title: "When was the last time that you had a conversation in French, excluding language courses?"
          precondition:
            - predicate: q_j2.outcome == 1
          input:
            control: Radio
            labels:
              1: "During the last week"
              2: "During the last month"
              3: "During the last year"
              4: "More than a year"
              5: "Never"

        # J4: French proficiency (Reading, Understanding, Speaking)
        # Precondition: knows French (J2 = 1)
        - id: qg_j4
          kind: QuestionGroup
          title: "How would you rate yourself in the following language abilities in French?"
          precondition:
            - predicate: q_j2.outcome == 1
          questions:
            - "Reading"
            - "Understanding"
            - "Speaking"
          input:
            control: Dropdown
            labels:
              1: "Very good"
              2: "Good"
              3: "Not very good"
              4: "Not at all"

        # J5: French knowledge sources
        # Precondition: knows French (J2 = 1)
        - id: q_j5
          kind: Question
          title: "What would you say contributed the most to your present knowledge of French?"
          precondition:
            - predicate: q_j2.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "Language instruction at school"
              2: "Other language courses"
              4: "Speaking with family"
              8: "Speaking with friends"
              16: "Speaking at work"
              32: "Watching television"
              64: "Other"

        # J5_other: Specify other source
        # Precondition: knows French and "Other" selected in J5
        - id: q_j5_other
          kind: Question
          title: "Please specify the other source of French knowledge:"
          precondition:
            - predicate: q_j2.outcome == 1
            - predicate: q_j5.outcome % 128 >= 64
          input:
            control: Textarea
            placeholder: "Specify..."

        # J6: French change compared to 5 years ago (Know, Use)
        # Precondition: knows French (J2 = 1)
        - id: qg_j6
          kind: QuestionGroup
          title: "Compared to five years ago, would you say that you now know/use more French, less French, or about the same?"
          precondition:
            - predicate: q_j2.outcome == 1
          questions:
            - "Know"
            - "Use"
          input:
            control: Radio
            labels:
              1: "More"
              2: "Less"
              3: "About the same"

        # J7: Other languages count
        - id: q_j7
          kind: Question
          title: "Other than English or French, how many languages do you know or understand?"
          input:
            control: Editbox
            min: 1
            max: 20
            right: "language(s)"

        # J8 is routing only (GO TO SECTION N) — omitted

    # ===================================================================
    # SECTION: language_french
    # ===================================================================
    # =========================================================================
    # BLOCK: SECTION K — French main language
    # =========================================================================
    # Routing summary:
    #   K1 → K2 → K3 → K4
    #   K4 = Yes (1) → K4a → K5 → K6 → K7 → Section N
    #   K4 = No  (0) → K7 → Section N
    # =========================================================================
    - id: b_section_k
      title: "Language — French Main"
      precondition:
        - predicate: lang_path == 4
      items:
        # K1: English reading ability
        - id: q_k1
          kind: Question
          title: "How would you rate your ability to read in English? Is it..."
          input:
            control: Radio
            labels:
              1: "Very good"
              2: "Good"
              3: "Not very good"
              4: "Not at all"

        # K2: English knowledge sources
        - id: q_k2
          kind: Question
          title: "What would you say contributed the most to your present knowledge of English?"
          input:
            control: Checkbox
            labels:
              1: "Language instruction at school"
              2: "Other language courses"
              4: "Speaking with family"
              8: "Speaking with friends"
              16: "Speaking at work"
              32: "Watching television"
              64: "Other"

        # K2_other: Specify other source
        # Precondition: "Other" selected in K2
        - id: q_k2_other
          kind: Question
          title: "Please specify the other source of English knowledge:"
          precondition:
            - predicate: q_k2.outcome % 128 >= 64
          input:
            control: Textarea
            placeholder: "Specify..."

        # K3: English and French change compared to 5 years ago
        # 4 rows: English Know, English Use, French Know, French Use
        - id: qg_k3
          kind: QuestionGroup
          title: "Compared to five years ago, would you say that you now know/use more or less English and French, or about the same?"
          questions:
            - "Know English"
            - "Use English"
            - "Know French"
            - "Use French"
          input:
            control: Radio
            labels:
              1: "More"
              2: "Less"
              3: "About the same"

        # K4: Other language knowledge (besides English and French)
        - id: q_k4
          kind: Question
          title: "Do you have any knowledge or understanding of a language other than English or French?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # K4a: How many other languages
        # Precondition: knows other language (K4 = 1)
        - id: q_k4a
          kind: Question
          title: "How many other languages do you know or understand?"
          precondition:
            - predicate: q_k4.outcome == 1
          input:
            control: Radio
            labels:
              1: "One language"
              2: "Multiple languages (report best known)"

        # K4a_spec: Specify language(s)
        # Precondition: knows other language (K4 = 1)
        - id: q_k4a_spec
          kind: Question
          title: "Please specify the language(s):"
          precondition:
            - predicate: q_k4.outcome == 1
          input:
            control: Textarea
            placeholder: "Specify language..."

        # K5: Last conversation in other language
        # Precondition: knows other language (K4 = 1)
        - id: q_k5
          kind: Question
          title: "When was the last time you had a conversation in that language, excluding language courses?"
          precondition:
            - predicate: q_k4.outcome == 1
          input:
            control: Radio
            labels:
              1: "During the last week"
              2: "During the last month"
              3: "During the last year"
              4: "More than a year"
              5: "Never"

        # K6: Other language proficiency (Reading, Understanding, Speaking)
        # Precondition: knows other language (K4 = 1)
        - id: qg_k6
          kind: QuestionGroup
          title: "In that language, how would you rate yourself in the following abilities?"
          precondition:
            - predicate: q_k4.outcome == 1
          questions:
            - "Reading"
            - "Understanding"
            - "Speaking"
          input:
            control: Dropdown
            labels:
              1: "Very good"
              2: "Good"
              3: "Not very good"
              4: "Not at all"

        # K7: French use change
        - id: q_k7
          kind: Question
          title: "Compared to five years ago, would you say that you now use more French, less French, or about the same?"
          input:
            control: Radio
            labels:
              1: "More"
              2: "Less"
              3: "About the same"

        # K8 is routing only (GO TO SECTION N) — omitted

    # ===================================================================
    # SECTION: language_french_other
    # ===================================================================
    # =========================================================================
    # BLOCK: SECTION L — French and Other language
    # =========================================================================
    # Routing summary:
    #   L1 → L2 → L3 → L4 → L5 → Section N
    #   All items always asked (no conditional branching within section)
    # =========================================================================
    - id: b_section_l
      title: "Language — French and Other"
      precondition:
        - predicate: lang_path == 5
      items:
        # L1: French change compared to 5 years ago (Know, Use)
        - id: qg_l1
          kind: QuestionGroup
          title: "Compared to five years ago, would you say that you now know/use more French, less French, or about the same?"
          questions:
            - "Know"
            - "Use"
          input:
            control: Radio
            labels:
              1: "More"
              2: "Less"
              3: "About the same"

        # L2: English reading ability
        - id: q_l2
          kind: Question
          title: "How would you rate your ability to read in English? Is it..."
          input:
            control: Radio
            labels:
              1: "Very good"
              2: "Good"
              3: "Not very good"
              4: "Not at all"

        # L3: English knowledge sources
        - id: q_l3
          kind: Question
          title: "What would you say contributed the most to your present knowledge of English?"
          input:
            control: Checkbox
            labels:
              1: "Language instruction at school"
              2: "Other language courses"
              4: "Speaking with family"
              8: "Speaking with friends"
              16: "Speaking at work"
              32: "Watching television"
              64: "Other"

        # L3_other: Specify other source
        # Precondition: "Other" selected in L3
        - id: q_l3_other
          kind: Question
          title: "Please specify the other source of English knowledge:"
          precondition:
            - predicate: q_l3.outcome % 128 >= 64
          input:
            control: Textarea
            placeholder: "Specify..."

        # L4: English change compared to 5 years ago (Know, Use)
        - id: qg_l4
          kind: QuestionGroup
          title: "Compared to five years ago, would you say that you now know/use more English, less English, or about the same?"
          questions:
            - "Know"
            - "Use"
          input:
            control: Radio
            labels:
              1: "More"
              2: "Less"
              3: "About the same"

        # L5: Other languages count
        - id: q_l5
          kind: Question
          title: "Other than English or French, how many languages do you know or understand?"
          input:
            control: Editbox
            min: 1
            max: 20
            right: "language(s)"

        # L6 is routing only (GO TO SECTION N) — omitted

    # ===================================================================
    # SECTION: language_other_main
    # ===================================================================
    # =========================================================================
    # BLOCK: SECTION M — Other main language
    # =========================================================================
    # Routing summary:
    #   M1 → M2 → M3 → M4
    #   M4 = Yes (1) → M5 → M6 → M7 → M8 → M9 → Section N
    #   M4 = No  (0) → M9 → Section N
    # =========================================================================
    - id: b_section_m
      title: "Language — Other Main Language"
      precondition:
        - predicate: lang_path == 6
      items:
        # M1: English reading ability
        - id: q_m1
          kind: Question
          title: "How would you rate your ability to read in English? Is it..."
          input:
            control: Radio
            labels:
              1: "Very good"
              2: "Good"
              3: "Not very good"
              4: "Not at all"

        # M2: English knowledge sources
        - id: q_m2
          kind: Question
          title: "What would you say contributed the most to your present knowledge of English?"
          input:
            control: Checkbox
            labels:
              1: "Language instruction at school"
              2: "Other language courses"
              4: "Speaking with family"
              8: "Speaking with friends"
              16: "Speaking at work"
              32: "Watching television"
              64: "Other"

        # M2_other: Specify other source
        # Precondition: "Other" selected in M2
        - id: q_m2_other
          kind: Question
          title: "Please specify the other source of English knowledge:"
          precondition:
            - predicate: q_m2.outcome % 128 >= 64
          input:
            control: Textarea
            placeholder: "Specify..."

        # M3: English change compared to 5 years ago (Know, Use)
        - id: qg_m3
          kind: QuestionGroup
          title: "Compared to five years ago, would you say that you now know/use more English, less English, or about the same?"
          questions:
            - "Know"
            - "Use"
          input:
            control: Radio
            labels:
              1: "More"
              2: "Less"
              3: "About the same"

        # M4: French knowledge
        - id: q_m4
          kind: Question
          title: "Do you have any knowledge or understanding of French?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # M5: Last French conversation
        # Precondition: knows French (M4 = 1)
        - id: q_m5
          kind: Question
          title: "When was the last time you had a conversation in French, excluding language courses?"
          precondition:
            - predicate: q_m4.outcome == 1
          input:
            control: Radio
            labels:
              1: "During the last week"
              2: "During the last month"
              3: "During the last year"
              4: "More than a year"
              5: "Never"

        # M6: French proficiency (Reading, Understanding, Speaking)
        # Precondition: knows French (M4 = 1)
        - id: qg_m6
          kind: QuestionGroup
          title: "How would you rate yourself in the following language abilities in French?"
          precondition:
            - predicate: q_m4.outcome == 1
          questions:
            - "Reading"
            - "Understanding"
            - "Speaking"
          input:
            control: Dropdown
            labels:
              1: "Very good"
              2: "Good"
              3: "Not very good"
              4: "Not at all"

        # M7: French knowledge sources
        # Precondition: knows French (M4 = 1)
        - id: q_m7
          kind: Question
          title: "What would you say contributed the most to your present knowledge of French?"
          precondition:
            - predicate: q_m4.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "Language instruction at school"
              2: "Other language courses"
              4: "Speaking with family"
              8: "Speaking with friends"
              16: "Speaking at work"
              32: "Watching television"
              64: "Other"

        # M7_other: Specify other source
        # Precondition: knows French and "Other" selected in M7
        - id: q_m7_other
          kind: Question
          title: "Please specify the other source of French knowledge:"
          precondition:
            - predicate: q_m4.outcome == 1
            - predicate: q_m7.outcome % 128 >= 64
          input:
            control: Textarea
            placeholder: "Specify..."

        # M8: French change compared to 5 years ago (Know, Use)
        # Precondition: knows French (M4 = 1)
        - id: qg_m8
          kind: QuestionGroup
          title: "Compared to five years ago, would you say that you now know/use more French, less French, or about the same?"
          precondition:
            - predicate: q_m4.outcome == 1
          questions:
            - "Know"
            - "Use"
          input:
            control: Radio
            labels:
              1: "More"
              2: "Less"
              3: "About the same"

        # M9: Other languages count
        - id: q_m9
          kind: Question
          title: "Other than English or French, how many languages do you know or understand?"
          input:
            control: Editbox
            min: 1
            max: 20
            right: "language(s)"

    # ===================================================================
    # SECTION: language_childhood
    # ===================================================================
    # =========================================================================
    # BLOCK: SECTION N — Childhood and adolescence language
    # =========================================================================
    # Routing summary:
    #   N1 → N2 (filter)
    #   If only one language in N1 → N4
    #   If multiple languages in N1 → N3 → N4
    #   N4 → N5 → Section P
    #
    # Block precondition: all multilingual respondents (lang_path != 7)
    # lang_path == 7 means English-only, routed to Section T instead
    # =========================================================================
    - id: b_section_n
      title: "Language — Childhood and Adolescence"
      precondition:
        - predicate: lang_path != 7
      items:
        # N1: Languages spoken at home before age 6
        - id: q_n1
          kind: Question
          title: "Before you were six years old, which languages were spoken in your home by people living there?"
          codeBlock: |
            # Check if multiple languages selected (more than one bit set)
            val = q_n1.outcome
            count = 0
            if val % 2 >= 1:
                count = count + 1
            if val % 4 >= 2:
                count = count + 1
            if val % 8 >= 4:
                count = count + 1
            if count >= 2:
                n1_multiple = 1
            else:
                n1_multiple = 0
          input:
            control: Checkbox
            labels:
              1: "English"
              2: "French"
              4: "Other"

        # N1_other: Specify other language
        # Precondition: "Other" selected in N1
        - id: q_n1_other
          kind: Question
          title: "Please specify the other language(s) spoken at home:"
          precondition:
            - predicate: q_n1.outcome % 8 >= 4
          input:
            control: Textarea
            placeholder: "Specify language..."

        # N2 is a filter: if only one language in N1 → skip N3
        # Modeled as precondition on N3

        # N3: Which languages did you yourself speak at home (multiple from N1)
        # Precondition: multiple languages in N1
        - id: q_n3_spoke
          kind: Question
          title: "Which languages did you yourself speak at home?"
          precondition:
            - predicate: n1_multiple == 1
          input:
            control: Checkbox
            labels:
              1: "English"
              2: "French"
              4: "Other"

        # N3_most: Most often spoken language at home
        # Precondition: multiple languages in N1
        - id: q_n3_most
          kind: Question
          title: "Which of those languages did you speak most often at home?"
          precondition:
            - predicate: n1_multiple == 1
          input:
            control: Radio
            labels:
              1: "English"
              2: "French"
              3: "Other"

        # N3_90pct: Did you speak this language more than 90% of the time?
        # Precondition: multiple languages in N1
        - id: q_n3_90pct
          kind: Question
          title: "Did you speak this language at home more than 90% of the time?"
          precondition:
            - predicate: n1_multiple == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # N4: Languages spoken at home at age 15
        - id: q_n4
          kind: Question
          title: "When you were fifteen years old, which languages did you yourself speak at home?"
          input:
            control: Checkbox
            labels:
              1: "English"
              2: "French"
              4: "Other"

        # N4_other: Specify other language at 15
        # Precondition: "Other" selected in N4
        - id: q_n4_other
          kind: Question
          title: "Please specify the other language(s) spoken at home at age 15:"
          precondition:
            - predicate: q_n4.outcome % 8 >= 4
          input:
            control: Textarea
            placeholder: "Specify language..."

        # N4_most: Most often spoken language at home at 15
        - id: q_n4_most
          kind: Question
          title: "Which of those languages did you speak most often at home at age 15?"
          input:
            control: Radio
            labels:
              1: "English"
              2: "French"
              3: "Other"

        # N5: Languages spoken with friends at 15
        - id: q_n5
          kind: Question
          title: "At that time, which languages did you speak with your friends?"
          input:
            control: Checkbox
            labels:
              1: "English"
              2: "French"
              4: "Other"

        # N5_other: Specify other language with friends
        # Precondition: "Other" selected in N5
        - id: q_n5_other
          kind: Question
          title: "Please specify the other language(s) spoken with friends:"
          precondition:
            - predicate: q_n5.outcome % 8 >= 4
          input:
            control: Textarea
            placeholder: "Specify language..."

        # N5_most: Most often spoken language with friends
        - id: q_n5_most
          kind: Question
          title: "Which of those languages did you speak most often with your friends?"
          input:
            control: Radio
            labels:
              1: "English"
              2: "French"
              3: "Other"

        # N6 is routing only (GO TO SECTION P) — omitted

    # ===================================================================
    # SECTION: education_work
    # ===================================================================
    # =========================================================================
    # BLOCK: EDUCATION AND FIRST JOB
    # =========================================================================
    # Section P collects respondent's education history, first full-time job,
    # and language courses. Complex routing based on years of schooling (P1):
    #   P1=00          → GO TO P14 (no schooling, skip all education/work)
    #   P1=05-08       → ask P1a (primary languages), then GO TO P4
    #   P1=09-10       → GO TO P2 (primary languages for grade 9+)
    #   P1=11-13       → ask P1b (secondary graduation), then GO TO P2
    # =========================================================================
    - id: b_education_work
      title: "Education and Work"
      precondition:
        - predicate: lang_path in [1, 2, 3, 4, 5, 6]
      items:
        # P1: Years of elementary/secondary education
        - id: q_p1
          kind: Question
          title: "How many years of elementary and secondary education have you completed?"
          codeBlock: |
            if q_p1.outcome == 0:
              p1_no_school = 1
            else:
              p1_no_school = 0
          input:
            control: Radio
            labels:
              0: "No schooling"
              5: "One to five years"
              6: "Six"
              7: "Seven"
              8: "Eight"
              9: "Nine"
              10: "Ten"
              11: "Eleven"
              12: "Twelve"
              13: "Thirteen"

        # P1a: Primary school teaching languages (P1 = 5-8 only)
        - id: q_p1a
          kind: Question
          title: "Which languages were used for teaching your courses at primary school, excluding language courses?"
          precondition:
            - predicate: q_p1.outcome in [5, 6, 7, 8]
          input:
            control: Checkbox
            labels:
              1: "English"
              2: "French"
              4: "Other"

        # P1b: Secondary school graduation (P1 = 11-13 only)
        - id: q_p1b
          kind: Question
          title: "Have you graduated from secondary school?"
          precondition:
            - predicate: q_p1.outcome in [11, 12, 13]
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # P2: Primary school teaching languages (P1 = 9-13)
        # After P1a (P1=5-8) routing goes to P4, so P2 is only for P1=9+.
        - id: q_p2
          kind: Question
          title: "Which languages were used for teaching your courses at primary school, excluding language courses?"
          precondition:
            - predicate: q_p1.outcome in [9, 10, 11, 12, 13]
          input:
            control: Checkbox
            labels:
              1: "English"
              2: "French"
              4: "Other"

        # P3: Secondary school teaching languages (P1 = 9-13)
        - id: q_p3
          kind: Question
          title: "What about languages used for teaching your courses at secondary school, excluding language courses?"
          precondition:
            - predicate: q_p1.outcome in [9, 10, 11, 12, 13]
          input:
            control: Checkbox
            labels:
              1: "English"
              2: "French"
              4: "Other"

        # P4: Further schooling beyond elementary/secondary
        # Shown for anyone with some schooling (P1 != 0)
        - id: q_p4
          kind: Question
          title: "Have you had any further schooling beyond elementary/secondary school?"
          precondition:
            - predicate: p1_no_school == 0
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # P5: Post-secondary teaching languages (P4 = Yes)
        - id: q_p5
          kind: Question
          title: "Which languages were/are used for teaching your courses at these levels, excluding language courses?"
          precondition:
            - predicate: q_p4.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "English"
              2: "French"
              4: "Other"

        # P6: Highest level attained (P4 = Yes)
        - id: q_p6
          kind: Question
          title: "What is the highest level you attained?"
          precondition:
            - predicate: q_p4.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Some community college, CEGEP or nursing school"
              2: "Diploma or certificate from community college, CEGEP or nursing school"
              3: "Some university"
              4: "Bachelor or undergraduate degree or teacher's college"
              5: "Master's or earned doctorate"
              6: "Other"

        # P7: Year of highest level of education
        # Shown for anyone with some schooling
        - id: q_p7
          kind: Question
          title: "In which year did you reach your highest level of education?"
          precondition:
            - predicate: p1_no_school == 0
          input:
            control: Editbox
            min: 1900
            max: 1986
            right: "year"

        # P8: First full-time job type
        # Shown for anyone with some schooling
        - id: q_p8
          kind: Question
          title: "Think about the first full-time job you had after reaching your highest level of education. Were you an employee working for someone else or self-employed?"
          precondition:
            - predicate: p1_no_school == 0
          input:
            control: Radio
            labels:
              1: "An employee working for someone else"
              2: "Self-employed"
              3: "Never had a full-time job after this date"

        # P9: Employer name (P8 = 1, employee)
        - id: q_p9
          kind: Question
          title: "For whom did you work? (Name of business, government department or agency or person)"
          precondition:
            - predicate: q_p8.outcome == 1
          input:
            control: Textarea
            placeholder: "Enter employer name"

        # P10: Kind of business/industry (P8 = 1 or 2)
        - id: q_p10
          kind: Question
          title: "What was the main kind of business, industry or service? (Give a full description)"
          precondition:
            - predicate: q_p8.outcome in [1, 2]
          input:
            control: Textarea
            placeholder: "Enter business description"

        # P11: Kind of work (P8 = 1 or 2)
        - id: q_p11
          kind: Question
          title: "What kind of work were you doing? (Give a full description)"
          precondition:
            - predicate: q_p8.outcome in [1, 2]
          input:
            control: Textarea
            placeholder: "Enter work description"

        # P12: Year began working (P8 = 1 or 2)
        - id: q_p12
          kind: Question
          title: "In what year did you begin working at this job?"
          precondition:
            - predicate: q_p8.outcome in [1, 2]
          input:
            control: Editbox
            min: 1900
            max: 1986
            right: "year"

        # P13: Language courses in school
        # Shown for anyone with some schooling
        - id: q_p13
          kind: Question
          title: "Have you ever taken any language courses as part of full-time school?"
          precondition:
            - predicate: p1_no_school == 0
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # P13a: Which languages (P13 = Yes)
        - id: q_p13a
          kind: Question
          title: "Which languages?"
          precondition:
            - predicate: q_p13.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "English"
              2: "French"
              4: "Other"

        # P14: Language courses outside school
        # Asked of everyone (including those with no schooling)
        - id: q_p14
          kind: Question
          title: "Have you ever taken any language courses outside of full-time school?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # P14a: Which languages (P14 = Yes)
        - id: q_p14a
          kind: Question
          title: "Which languages?"
          precondition:
            - predicate: q_p14.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "English"
              2: "French"
              4: "Other"

    # ===================================================================
    # SECTION: language_background
    # ===================================================================
    # =========================================================================
    # BLOCK 1: HOME LANGUAGE USE
    # =========================================================================
    # Q1: Languages spoken at home (multi-select)
    #   If "Live alone" selected → skip to Q4
    #   Otherwise → Q2 (filter check)
    # Q2: Interviewer filter — if only one language → skip to Q4
    # Q3: Which languages do you yourself speak at home (if multiple)
    # Q4: Languages with friends
    # =========================================================================
    - id: b_home_language
      title: "Home Language Use"
      precondition:
        - predicate: lang_path in [1, 2, 3, 4, 5, 6]
      items:
        # Q1: Languages at home
        - id: q_q1
          kind: Question
          title: "Think about the people you live with. Which languages do you speak amongst yourselves at home?"
          codeBlock: |
            # Count languages selected (excluding "Live alone" bit 1)
            v = q_q1.outcome & 14
            count = 0
            if v % 4 >= 2:
              count = count + 1
            if v % 8 >= 4:
              count = count + 1
            if v % 16 >= 8:
              count = count + 1
            home_lang_count = count
          input:
            control: Checkbox
            labels:
              1: "Live alone"
              2: "English"
              4: "French"
              8: "Other"

        # Q3: Languages you yourself speak at home
        # Shown only when multiple languages reported AND not living alone
        - id: q_q3
          kind: Question
          title: "Which languages do you yourself speak at home?"
          precondition:
            - predicate: q_q1.outcome % 2 == 0
            - predicate: home_lang_count >= 2
          input:
            control: Checkbox
            labels:
              1: "English"
              2: "French"
              4: "Other"

        # Q3_most: Most often spoken at home
        - id: q_q3_most
          kind: Question
          title: "Which of these do you speak most often at home?"
          precondition:
            - predicate: q_q1.outcome % 2 == 0
            - predicate: home_lang_count >= 2
          input:
            control: Radio
            labels:
              1: "English"
              2: "French"
              3: "Other"

        # Q3_90: Speak most-often language more than 90% of the time?
        - id: q_q3_90
          kind: Question
          title: "Do you speak this language at home more than 90% of the time?"
          precondition:
            - predicate: q_q1.outcome % 2 == 0
            - predicate: home_lang_count >= 2
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q4: Languages with friends
        - id: q_q4
          kind: Question
          title: "Which languages do you yourself speak with your friends outside your home?"
          input:
            control: Checkbox
            labels:
              1: "English"
              2: "French"
              4: "Other"

        # Q4_most: Most often spoken with friends
        - id: q_q4_most
          kind: Question
          title: "Which of these do you speak most often with your friends?"
          input:
            control: Radio
            labels:
              1: "English"
              2: "French"
              3: "Other"

    # =========================================================================
    # BLOCK 2: MAIN ACTIVITY AND WORK STATUS
    # =========================================================================
    # Q5: Main activity last 7 days
    # Q6: Main activity last 12 months
    #   If Q6=1 (working) → set worked_12m=1, skip Q7, go to Q8
    # Q7: Had a job in last 12 months? (only if Q6 != 1)
    #   If Q7=1 → set worked_12m=1, go to Q8
    #   If Q7=0 → worked_12m stays 0, skip to Section R
    # =========================================================================
    - id: b_main_activity
      title: "Main Activity"
      precondition:
        - predicate: lang_path in [1, 2, 3, 4, 5, 6]
      items:
        # Q5: Main activity last 7 days
        - id: q_q5
          kind: Question
          title: "Which of the following best describes your main activity during the last 7 days? Were you mainly..."
          input:
            control: Radio
            labels:
              1: "Working at a job or business"
              2: "Looking for work"
              3: "A student"
              4: "Keeping house"
              5: "Retired"
              6: "Other"

        # Q6: Main activity last 12 months
        - id: q_q6
          kind: Question
          title: "What about your main activity during the last 12 months? Were you mainly..."
          codeBlock: |
            if q_q6.outcome == 1:
              worked_12m = 1
          input:
            control: Radio
            labels:
              1: "Working at a job or business"
              2: "Looking for work"
              3: "A student"
              4: "Keeping house"
              5: "Retired"
              6: "Other"

        # Q7: Had job in last 12 months (only if Q6 != 1)
        - id: q_q7
          kind: Question
          title: "Did you have a job at any time during the last 12 months?"
          precondition:
            - predicate: q_q6.outcome != 1
          codeBlock: |
            if q_q7.outcome == 1:
              worked_12m = 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

    # =========================================================================
    # BLOCK 3: EMPLOYMENT DETAILS
    # =========================================================================
    # Q8-Q13: Work details, all gated on worked_12m == 1
    # Q9: Employee vs self-employed
    # Q10: Full-time/part-time (only if Q9=1, employee)
    # Q11: Employer name (only if Q9=1, employee)
    # Q12-Q13: Business/work description
    # =========================================================================
    - id: b_employment_details
      title: "Employment Details"
      precondition:
        - predicate: lang_path in [1, 2, 3, 4, 5, 6]
        - predicate: worked_12m == 1
      items:
        # Q8: Weeks worked in last 12 months
        - id: q_q8
          kind: Question
          title: "For how many weeks of those 12 months did you do any work at a job or business? (Include vacation, illness, strikes, lock-outs and paid maternity leave)"
          input:
            control: Editbox
            min: 0
            max: 52
            right: "weeks"

        # Q9: Employee or self-employed
        - id: q_q9
          kind: Question
          title: "During those weeks of work were you mainly..."
          input:
            control: Radio
            labels:
              1: "An employee working for someone else"
              2: "Self-employed"

        # Q10: Full-time or part-time (employee only)
        - id: q_q10
          kind: Question
          title: "During those weeks of work were you mostly full-time or part-time?"
          precondition:
            - predicate: q_q9.outcome == 1
          input:
            control: Radio
            labels:
              1: "Full-time"
              2: "Part-time"

        # Q11: Employer name (employee only)
        - id: q_q11
          kind: Question
          title: "For whom do you/did you last work? (Name of business, government department or agency or person)"
          precondition:
            - predicate: q_q9.outcome == 1
          input:
            control: Textarea
            placeholder: "Enter employer name"

        # Q12: Kind of business
        - id: q_q12
          kind: Question
          title: "What was the main kind of business, industry or service?"
          input:
            control: Textarea
            placeholder: "Enter business description"

        # Q13: Kind of work
        - id: q_q13
          kind: Question
          title: "What kind of work were you doing?"
          input:
            control: Textarea
            placeholder: "Enter work description"

    # =========================================================================
    # BLOCK 4: LANGUAGE AT WORK
    # =========================================================================
    # Q14-Q17: Languages used at work, gated on worked_12m == 1
    # Q16: Writing at work? If No → skip Q17
    # Q17: Languages for writing (only if Q16=1)
    # =========================================================================
    - id: b_work_language
      title: "Language at Work"
      precondition:
        - predicate: lang_path in [1, 2, 3, 4, 5, 6]
        - predicate: worked_12m == 1
      items:
        # Q14: Languages spoken at work by contacts
        - id: q_q14
          kind: Question
          title: "Which languages are/were spoken at work by people with whom you have/had regular contact?"
          input:
            control: Checkbox
            labels:
              1: "English"
              2: "French"
              4: "Other"

        # Q15: Languages you yourself speak at work
        - id: q_q15
          kind: Question
          title: "Considering the last 12 months, which languages have you yourself spoken at work?"
          input:
            control: Checkbox
            labels:
              1: "English"
              2: "French"
              4: "Other"

        # Q15_most: Most often spoken at work
        - id: q_q15_most
          kind: Question
          title: "Which of these do you speak most often at work?"
          input:
            control: Radio
            labels:
              1: "English"
              2: "French"
              3: "Other"

        # Q15_90: Speak most-often language more than 90% of time at work?
        - id: q_q15_90
          kind: Question
          title: "Do you speak this language at work more than 90% of the time?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q16: Writing at work
        - id: q_q16
          kind: Question
          title: "During the last 12 months have you done any writing at work?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q17: Languages for writing at work (Q16 = Yes)
        - id: q_q17
          kind: Question
          title: "Over this period, which languages did you yourself use for writing at work?"
          precondition:
            - predicate: q_q16.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "English"
              2: "French"
              4: "Other"

        # Q17_most: Most often used for writing
        - id: q_q17_most
          kind: Question
          title: "Which of these did you use most often for writing at work?"
          precondition:
            - predicate: q_q16.outcome == 1
          input:
            control: Radio
            labels:
              1: "English"
              2: "French"
              3: "Other"

        # Q17_90: Use most-often language for writing more than 90%?
        - id: q_q17_90
          kind: Question
          title: "Did you use this language for writing at work more than 90% of the time?"
          precondition:
            - predicate: q_q16.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

    # ===================================================================
    # SECTION: federal_contacts
    # ===================================================================
    # =========================================================================
    # BLOCK 1: FEDERAL AGENCY CONTACT ROSTER
    # =========================================================================
    # R1: Have you talked with employees of 11 federal agencies?
    # Modeled as a QuestionGroup with 11 Switch sub-questions (Yes/No per
    # agency). A codeBlock counts how many agencies had contact.
    #
    # R2-R5: Per-agency follow-up (language of service, preferred language,
    # did you ask). The original instrument repeats R2-R5 for each agency
    # where R1=Yes. QML cannot dynamically show questions per roster row,
    # so R2-R5 are modeled as QuestionGroups covering all 11 agencies.
    # The respondent answers only for agencies they contacted; unused
    # rows default to the initial value.
    # =========================================================================
    - id: b_federal_contacts
      title: "Contact with Federal Government"
      precondition:
        - predicate: lang_path in [1, 2, 3, 4, 5, 6]
      items:
        # R1: Contact with each federal agency (11 agencies)
        - id: qg_r1
          kind: QuestionGroup
          title: "During this period, have you talked with employees of the following federal agencies in connection with the services they provide?"
          questions:
            - "Post Office (excluding letter carriers)"
            - "Canada Employment or Immigration Centres"
            - "Old age security or family allowance"
            - "National parks"
            - "Federal personal income tax"
            - "Customs at border crossings only"
            - "R.C.M.P."
            - "Air Canada"
            - "Agriculture Canada"
            - "Via Rail or CN Marine"
            - "Federal Public Service Commission"
          codeBlock: |
            any_federal_contact = 0
            for i in range(11):
              if qg_r1.outcome[i] == 1:
                any_federal_contact = any_federal_contact + 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # R2: Language of service (per agency contacted)
        # Asked only if at least one agency was contacted.
        - id: qg_r2
          kind: QuestionGroup
          title: "In your last contact with each agency, in which language did you obtain service?"
          precondition:
            - predicate: any_federal_contact > 0
          questions:
            - "Post Office"
            - "Canada Employment or Immigration"
            - "Old age security or family allowance"
            - "National parks"
            - "Federal personal income tax"
            - "Customs"
            - "R.C.M.P."
            - "Air Canada"
            - "Agriculture Canada"
            - "Via Rail or CN Marine"
            - "Federal Public Service Commission"
          input:
            control: Radio
            labels:
              1: "English"
              2: "French"
              3: "Other"

        # R3: Was this your preferred language? (per agency contacted)
        - id: qg_r3
          kind: QuestionGroup
          title: "Was this your preferred language?"
          precondition:
            - predicate: any_federal_contact > 0
          questions:
            - "Post Office"
            - "Canada Employment or Immigration"
            - "Old age security or family allowance"
            - "National parks"
            - "Federal personal income tax"
            - "Customs"
            - "R.C.M.P."
            - "Air Canada"
            - "Agriculture Canada"
            - "Via Rail or CN Marine"
            - "Federal Public Service Commission"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # R4: Preferred language (per agency where R3 = No)
        # NOTE: The original instrument asks R4 only for agencies where
        # R3=No. QML QuestionGroup shows all rows unconditionally. This
        # is a known simplification; the respondent should answer only
        # for agencies where they did not receive preferred language.
        - id: qg_r4
          kind: QuestionGroup
          title: "What was your preferred language? (Answer for each agency where service was not in your preferred language)"
          precondition:
            - predicate: any_federal_contact > 0
          questions:
            - "Post Office"
            - "Canada Employment or Immigration"
            - "Old age security or family allowance"
            - "National parks"
            - "Federal personal income tax"
            - "Customs"
            - "R.C.M.P."
            - "Air Canada"
            - "Agriculture Canada"
            - "Via Rail or CN Marine"
            - "Federal Public Service Commission"
          input:
            control: Radio
            labels:
              1: "English"
              2: "French"
              3: "Other"

        # R5: Did you ask for service in that language? (per agency where R3 = No)
        - id: qg_r5
          kind: QuestionGroup
          title: "Did you ask for service in that language? (Answer for each agency where service was not in your preferred language)"
          precondition:
            - predicate: any_federal_contact > 0
          questions:
            - "Post Office"
            - "Canada Employment or Immigration"
            - "Old age security or family allowance"
            - "National parks"
            - "Federal personal income tax"
            - "Customs"
            - "R.C.M.P."
            - "Air Canada"
            - "Agriculture Canada"
            - "Via Rail or CN Marine"
            - "Federal Public Service Commission"
          input:
            control: Switch
            off: "No"
            on: "Yes"

    # =========================================================================
    # BLOCK 2: GENERAL LANGUAGE QUESTIONS
    # =========================================================================
    # R6: Federal services availability in preferred official language
    # R7: TV watching languages (multi-select with most-often and 90%)
    # R8: Doctor language
    # =========================================================================
    - id: b_general_language
      title: "General Language Questions"
      precondition:
        - predicate: lang_path in [1, 2, 3, 4, 5, 6]
      items:
        # R6: Federal services available in preferred language
        - id: q_r6
          kind: Question
          title: "Would you say that, in your area, federal services are generally available in your preferred official language?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Don't know"

        # R7: TV watching languages
        - id: q_r7
          kind: Question
          title: "In which languages are the television programs you watch?"
          input:
            control: Checkbox
            labels:
              1: "Never watch television"
              2: "English"
              4: "French"
              8: "Other"

        # R7_most: Most often watched language
        - id: q_r7_most
          kind: Question
          title: "In which language do you watch television most often?"
          precondition:
            - predicate: q_r7.outcome % 2 == 0
          input:
            control: Radio
            labels:
              1: "English"
              2: "French"
              3: "Other"

        # R7_90: Watch most-often language more than 90%?
        - id: q_r7_90
          kind: Question
          title: "Do you watch programs in this language more than 90% of the time?"
          precondition:
            - predicate: q_r7.outcome % 2 == 0
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # R8: Doctor language
        - id: q_r8
          kind: Question
          title: "Which language did the doctor use during your last visit?"
          input:
            control: Radio
            labels:
              1: "Never visited doctor"
              2: "English"
              3: "French"
              4: "Other"

    # ===================================================================
    # SECTION: background
    # ===================================================================
    # =========================================================================
    # BLOCK 1: ETHNIC, RELIGIOUS, AND COMMUNITY BACKGROUND
    # =========================================================================
    # S1: Ethnic group (multi-select)
    # S2: Religion (dropdown). If "No religion" → skip S3
    # S3: Attendance (only if has religion)
    # S4: Community size
    # S5: Town name
    # S6: Postal code
    # S7: Dwelling type
    # S8: Owned/rented
    # =========================================================================
    - id: b_background
      title: "Background Characteristics"
      precondition:
        - predicate: lang_path in [1, 2, 3, 4, 5, 6]
      items:
        # S1: Ethnic or cultural group
        - id: q_s1
          kind: Question
          title: "To which ethnic or cultural group do you or did your ancestors belong?"
          input:
            control: Checkbox
            labels:
              1: "English"
              2: "French"
              4: "Irish"
              8: "Scottish"
              16: "German"
              32: "Italian"
              64: "Ukrainian"
              128: "Don't know"
              256: "Other"

        # S2: Religion
        - id: q_s2
          kind: Question
          title: "What, if any, is your religion?"
          input:
            control: Dropdown
            labels:
              0: "No religion"
              1: "Roman Catholic"
              2: "United Church"
              3: "Anglican"
              4: "Presbyterian"
              5: "Lutheran"
              6: "Baptist"
              7: "Eastern Orthodox"
              8: "Jewish"
              9: "Other"

        # S3: Religious attendance (only if has religion, S2 != 0)
        - id: q_s3
          kind: Question
          title: "Other than on special occasions, such as weddings, funerals or baptisms, how often do you attend services or meetings connected with your religion?"
          precondition:
            - predicate: q_s2.outcome != 0
          input:
            control: Radio
            labels:
              1: "At least once a week"
              2: "At least once a month"
              3: "At least once a year"
              4: "Less than once a year"
              5: "Never"

        # S4: Community size
        - id: q_s4
          kind: Question
          title: "What is the approximate size of the community in which you are now living? By community I mean city, town or rural area."
          input:
            control: Radio
            labels:
              1: "Less than 5,000 population or a rural area"
              2: "5,000 to less than 25,000 population"
              3: "25,000 to less than 100,000 population"
              4: "100,000 to 1 million population"
              5: "Over 1 million population"

        # S5: Town name
        - id: q_s5
          kind: Question
          title: "What is the name of that town or nearest town?"
          input:
            control: Textarea
            placeholder: "Enter town name and province"

        # S6: Postal code
        - id: q_s6
          kind: Question
          title: "What are the first three characters of your postal code?"
          input:
            control: Textarea
            placeholder: "Enter first 3 characters"
            maxLength: 3

        # S7: Dwelling type
        - id: q_s7
          kind: Question
          title: "What type of dwelling are you now living in? Is it..."
          input:
            control: Dropdown
            labels:
              1: "Single detached house"
              2: "Semi-detached or double (side-by-side)"
              3: "Garden house, town-house or row house"
              4: "Duplex (one above the other)"
              5: "Low-rise apartment (less than five stories)"
              6: "High-rise apartment (five or more stories)"
              7: "Other"

        # S8: Owned or rented
        - id: q_s8
          kind: Question
          title: "Is this dwelling owned or rented by a member of this household?"
          input:
            control: Radio
            labels:
              1: "Owned"
              2: "Rented"

    # =========================================================================
    # BLOCK 2: TELEPHONE DETAILS
    # =========================================================================
    # S9: Number of telephones. If 1 → skip to S14.
    # S10: Same number? If Yes → skip to S14.
    # S11: How many different numbers?
    # S12: Any business use only? If No → skip to S14.
    # S13: How many business only?
    # =========================================================================
    - id: b_telephone
      title: "Telephone Details"
      precondition:
        - predicate: lang_path in [1, 2, 3, 4, 5, 6]
      items:
        # S9: Number of telephones
        - id: q_s9
          kind: Question
          title: "How many telephones, counting extensions, are there in your dwelling?"
          input:
            control: Radio
            labels:
              1: "One"
              2: "Two or more"

        # S10: Same telephone number (only if S9 = 2, two or more)
        - id: q_s10
          kind: Question
          title: "Do all the telephones have the same number?"
          precondition:
            - predicate: q_s9.outcome == 2
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # S11: How many different numbers (only if S10 = 0, No)
        - id: q_s11
          kind: Question
          title: "How many different numbers are there?"
          precondition:
            - predicate: q_s9.outcome == 2
            - predicate: q_s10.outcome == 0
          input:
            control: Editbox
            min: 2
            max: 20
            right: "numbers"

        # S12: Any business use only (only if S10 = 0, No)
        - id: q_s12
          kind: Question
          title: "Are any of these numbers for business use only?"
          precondition:
            - predicate: q_s9.outcome == 2
            - predicate: q_s10.outcome == 0
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # S13: How many business only (only if S12 = 1, Yes)
        - id: q_s13
          kind: Question
          title: "How many are for business use only?"
          precondition:
            - predicate: q_s12.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 20
            right: "numbers"

    # =========================================================================
    # BLOCK 3: INCOME
    # =========================================================================
    # S14: Wages/salary/self-employment income
    # S15: Government income
    # S16: Investment/pension income
    # S17: Household income cascading brackets
    #
    # The original S14 and S16 have conditional numeric entry for amounts.
    # Since QML integer inputs cannot elegantly combine a category selector
    # with an open-ended dollar amount, these are modeled as Radio selectors
    # for the category, with separate Editbox items for amounts when applicable.
    # =========================================================================
    - id: b_income
      title: "Income"
      precondition:
        - predicate: lang_path in [1, 2, 3, 4, 5, 6]
      items:
        # S14: Wages/salary/self-employment income type
        - id: q_s14
          kind: Question
          title: "What was your income before taxes, from wages, salaries and self-employment during the last 12 months?"
          input:
            control: Radio
            labels:
              1: "Income (had earnings)"
              2: "Loss"
              3: "No income"
              4: "Don't know"

        # S14_amount: Dollar amount (if income or loss)
        - id: q_s14_amount
          kind: Question
          title: "What was the dollar amount?"
          precondition:
            - predicate: q_s14.outcome in [1, 2]
          input:
            control: Editbox
            min: 0
            max: 999999
            left: "$"

        # S15: Government income type
        - id: q_s15
          kind: Question
          title: "What was your income from government sources such as Family Allowance, U.I.C., Social Assistance, Canada or Quebec Pension Plan or Old Age Security?"
          input:
            control: Radio
            labels:
              1: "Income (had government income)"
              2: "No income from government"
              3: "Don't know"

        # S15_amount: Dollar amount (if government income)
        - id: q_s15_amount
          kind: Question
          title: "What was the dollar amount from government sources?"
          precondition:
            - predicate: q_s15.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 999999
            left: "$"

        # S16: Investment/pension income type
        - id: q_s16
          kind: Question
          title: "What was your income from investments or private pensions?"
          input:
            control: Radio
            labels:
              1: "Income (had investment income)"
              2: "Loss"
              3: "No income"
              4: "Don't know"

        # S16_amount: Dollar amount (if income or loss)
        - id: q_s16_amount
          kind: Question
          title: "What was the dollar amount from investments or private pensions?"
          precondition:
            - predicate: q_s16.outcome in [1, 2]
          input:
            control: Editbox
            min: 0
            max: 999999
            left: "$"

        # =================================================================
        # S17: HOUSEHOLD INCOME — CASCADING BRACKETS
        # =================================================================
        # The original instrument uses an unfolding binary tree:
        #   S17a: <$20K or $20K+?
        #     If <$20K → S17b: <$10K or $10K+?
        #       If <$10K → S17c: <$5K or $5K+?
        #       If $10K+ → S17d: <$15K or $15K+?
        #     If $20K+ → S17e: <$40K or $40K+?
        #       If <$40K → S17f: <$30K or $30K+?
        #       If $40K+ → S17g: <$60K or $60K+?
        # =================================================================

        # S17a: First bracket split
        - id: q_s17a
          kind: Question
          title: "What is your best estimate of the total income of all household members from all sources during the last 12 months? Was the total household income..."
          input:
            control: Radio
            labels:
              1: "Less than $20,000"
              2: "$20,000 and more"
              3: "No income"
              4: "Don't know"

        # S17b: Under $20K split (S17a = 1)
        - id: q_s17b
          kind: Question
          title: "Was it..."
          precondition:
            - predicate: q_s17a.outcome == 1
          input:
            control: Radio
            labels:
              1: "Less than $10,000"
              2: "$10,000 and more"

        # S17c: Under $10K split (S17b = 1)
        - id: q_s17c
          kind: Question
          title: "Was it..."
          precondition:
            - predicate: q_s17b.outcome == 1
          input:
            control: Radio
            labels:
              1: "Less than $5,000"
              2: "$5,000 and more"

        # S17d: $10K+ split (S17b = 2)
        - id: q_s17d
          kind: Question
          title: "Was it..."
          precondition:
            - predicate: q_s17b.outcome == 2
          input:
            control: Radio
            labels:
              1: "Less than $15,000"
              2: "$15,000 and more"

        # S17e: $20K+ split (S17a = 2)
        - id: q_s17e
          kind: Question
          title: "Was it..."
          precondition:
            - predicate: q_s17a.outcome == 2
          input:
            control: Radio
            labels:
              1: "Less than $40,000"
              2: "$40,000 and more"

        # S17f: Under $40K split (S17e = 1)
        - id: q_s17f
          kind: Question
          title: "Was it..."
          precondition:
            - predicate: q_s17e.outcome == 1
          input:
            control: Radio
            labels:
              1: "Less than $30,000"
              2: "$30,000 and more"

        # S17g: $40K+ split (S17e = 2)
        - id: q_s17g
          kind: Question
          title: "Was it..."
          precondition:
            - predicate: q_s17e.outcome == 2
          input:
            control: Radio
            labels:
              1: "Less than $60,000"
              2: "$60,000 and more"

    # ===================================================================
    # SECTION: federal_contacts_english
    # ===================================================================
    # =========================================================================
    # BLOCK: SECTION T — Federal Government Contacts (English-only path)
    # =========================================================================
    # Routing summary:
    #   T1: 11-agency contact roster (QuestionGroup Switch)
    #       codeBlock sets any_federal_contact_t = count of agencies contacted
    #   T2: Service in English for all contacts? (Switch)
    #       Pre: any_federal_contact_t > 0
    #       Yes (1) → skip T3 → T4
    #       No  (0) → T3
    #   T3: Asked for English service per agency? (QuestionGroup Switch)
    #       Pre: T2 == 0 (not all in English)
    #   T4: Federal services available in English? (Radio)
    #   T5: TV watching — languages, most often, 90%
    #       q_t5_watch: Switch (watch TV?)
    #       q_t5_languages: Checkbox (which languages)
    #       q_t5_most_often: Radio (most often language)
    #       q_t5_ninety_pct: Switch (>90% one language?)
    #   T6: Doctor visit language (Radio)
    # =========================================================================
    - id: b_section_t
      title: "Language — Contact with Federal Government"
      precondition:
        - predicate: lang_path == 7
      items:
        # T1: Contact with federal agencies
        - id: qg_t1
          kind: QuestionGroup
          title: "During this period, have you talked with employees of the following federal agencies in connection with the services they provide?"
          questions:
            - "Post Office (excluding letter carriers)"
            - "Canada Employment or Immigration Centres"
            - "Old age security or family allowance"
            - "National parks"
            - "Federal personal income tax"
            - "Customs at border crossings only"
            - "R.C.M.P."
            - "Air Canada"
            - "Agriculture Canada"
            - "Via Rail or CN Marine"
            - "Federal Public Service Commission"
          codeBlock: |
            any_federal_contact_t = 0
            for i in range(11):
              any_federal_contact_t = any_federal_contact_t + qg_t1.outcome[i]
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # T2: Service in English for all contacts?
        # Pre: at least one contact made
        # Yes (1) → skip T3, go to T4; No (0) → T3
        - id: q_t2
          kind: Question
          title: "Did you obtain service in English for all these contacts?"
          precondition:
            - predicate: any_federal_contact_t > 0
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # T3: Asked for English service per agency?
        # Pre: T2 == 0 (did NOT get English for all)
        # Only agencies where contact was made would be asked in the original;
        # modeled as full roster with block-level precondition from T2.
        - id: qg_t3
          kind: QuestionGroup
          title: "Did you ask for service in English at each of these agencies?"
          precondition:
            - predicate: any_federal_contact_t > 0
            - predicate: q_t2.outcome == 0
          questions:
            - "Post Office (excluding letter carriers)"
            - "Canada Employment or Immigration Centres"
            - "Old age security or family allowance"
            - "National parks"
            - "Federal personal income tax"
            - "Customs at border crossings only"
            - "R.C.M.P."
            - "Air Canada"
            - "Agriculture Canada"
            - "Via Rail or CN Marine"
            - "Federal Public Service Commission"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # T4: Federal services available in English?
        - id: q_t4
          kind: Question
          title: "Would you say that, in your area, federal services are generally available in English?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Don't know"

        # T5: Television watching languages
        # Decomposed into sub-questions:
        #   q_t5_watch: Do you watch television?
        #   q_t5_languages: In which languages?
        #   q_t5_most_often: Which language most often?
        #   q_t5_ninety_pct: More than 90% of the time?

        # T5a: Watch television?
        - id: q_t5_watch
          kind: Question
          title: "Do you watch television?"
          input:
            control: Switch
            off: "Never watch television"
            on: "Yes, I watch television"

        # T5b: Languages of television programs watched
        # Pre: watches TV
        - id: q_t5_languages
          kind: Question
          title: "In which languages are the television programs you watch?"
          precondition:
            - predicate: q_t5_watch.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "English"
              2: "French"
              4: "Other"

        # T5c: Most often language
        # Pre: watches TV
        - id: q_t5_most_often
          kind: Question
          title: "Which language do you watch most often?"
          precondition:
            - predicate: q_t5_watch.outcome == 1
          input:
            control: Radio
            labels:
              1: "English"
              2: "French"
              3: "Other"

        # T5d: Watch in that language more than 90% of the time?
        # Pre: watches TV
        - id: q_t5_ninety_pct
          kind: Question
          title: "Do you watch programs in that language more than 90% of the time?"
          precondition:
            - predicate: q_t5_watch.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # T6: Doctor visit language
        - id: q_t6
          kind: Question
          title: "Which language did the doctor use during your last visit?"
          input:
            control: Radio
            labels:
              1: "Never visited doctor"
              2: "English"
              3: "French"
              4: "Other"

    # ===================================================================
    # SECTION: background_english
    # ===================================================================
    # =========================================================================
    # BLOCK 1: EDUCATION (U1–U12a)
    # =========================================================================
    # Routing summary:
    #   U1: Years of education
    #       0 → skip to U12; 5-10 → skip to U3; 11-13 → U2
    #   U2: Graduated secondary? Pre: U1 in [11,12,13]
    #   U3: Further schooling? Pre: U1 != 0
    #       Yes (1) → U4; No (0) → U5
    #   U4: Highest level. Pre: U3 == 1
    #   U5: Year of highest education. Pre: U1 != 0
    #   U6: First job type. Pre: U1 != 0
    #       1 (employee) → U7; 2 (self-employed) → U8; 3 (never) → U11
    #   U7: Employer. Pre: U6 == 1
    #   U8: Business type. Pre: U6 in [1, 2]
    #   U9: Work description. Pre: U6 in [1, 2]
    #   U10: Year began. Pre: U6 in [1, 2]
    #   U11: Language courses in school. Pre: U1 != 0
    #   U11a: Which languages. Pre: U11 == 1
    #   U12: Language courses outside school (always asked)
    #   U12a: Which languages. Pre: U12 == 1
    # =========================================================================
    - id: b_u_education
      title: "Education and Language Training"
      precondition:
        - predicate: lang_path == 7
      items:
        # U1: Years of elementary and secondary education
        - id: q_u1
          kind: Question
          title: "How many years of elementary and secondary education have you completed?"
          input:
            control: Radio
            labels:
              0: "No schooling"
              5: "One to five years"
              6: "Six"
              7: "Seven"
              8: "Eight"
              9: "Nine"
              10: "Ten"
              11: "Eleven"
              12: "Twelve"
              13: "Thirteen"

        # U2: Graduated from secondary school?
        # Pre: U1 in [11, 12, 13]
        - id: q_u2
          kind: Question
          title: "Have you graduated from secondary school?"
          precondition:
            - predicate: q_u1.outcome in [11, 12, 13]
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # U3: Further schooling beyond elementary/secondary?
        # Pre: U1 != 0 (has some schooling)
        - id: q_u3
          kind: Question
          title: "Have you had any further schooling beyond elementary/secondary school?"
          precondition:
            - predicate: q_u1.outcome != 0
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # U4: Highest level of further education
        # Pre: U3 == 1 (Yes, further schooling)
        - id: q_u4
          kind: Question
          title: "What is the highest level you attained?"
          precondition:
            - predicate: q_u3.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Some community college, CEGEP or nursing school"
              2: "Diploma or certificate from community college, CEGEP or nursing school"
              3: "Some university"
              4: "Bachelor or undergraduate degree or teacher's college"
              5: "Master's or earned doctorate"
              6: "Other"

        # U5: Year of highest education
        # Pre: U1 != 0
        - id: q_u5
          kind: Question
          title: "In which year did you reach your highest level of education?"
          precondition:
            - predicate: q_u1.outcome != 0
          input:
            control: Editbox
            min: 1900
            max: 1986
            right: "year"

        # U6: First full-time job type after highest education
        # Pre: U1 != 0
        # 1 → U7; 2 → U8; 3 → U11
        - id: q_u6
          kind: Question
          title: "Think about the first full-time job you had after reaching your highest level of education. Were you an employee working for someone else or self-employed?"
          precondition:
            - predicate: q_u1.outcome != 0
          input:
            control: Radio
            labels:
              1: "An employee working for someone else"
              2: "Self-employed"
              3: "Never had a full-time job after this date"

        # U7: Employer name
        # Pre: U6 == 1 (employee)
        - id: q_u7
          kind: Question
          title: "For whom did you work? (Name of business, government department or agency or person)"
          precondition:
            - predicate: q_u6.outcome == 1
          input:
            control: Textarea
            placeholder: "Enter employer name..."

        # U8: Kind of business/industry
        # Pre: U6 in [1, 2] (employee or self-employed)
        - id: q_u8
          kind: Question
          title: "What was the main kind of business, industry or service?"
          precondition:
            - predicate: q_u6.outcome in [1, 2]
          input:
            control: Textarea
            placeholder: "Give a full description..."

        # U9: Kind of work
        # Pre: U6 in [1, 2]
        - id: q_u9
          kind: Question
          title: "What kind of work were you doing?"
          precondition:
            - predicate: q_u6.outcome in [1, 2]
          input:
            control: Textarea
            placeholder: "Give a full description..."

        # U10: Year began working at that job
        # Pre: U6 in [1, 2]
        - id: q_u10
          kind: Question
          title: "In what year did you begin working at this job?"
          precondition:
            - predicate: q_u6.outcome in [1, 2]
          input:
            control: Editbox
            min: 1900
            max: 1986
            right: "year"

        # U11: Language courses in full-time school?
        # Pre: U1 != 0
        - id: q_u11
          kind: Question
          title: "Have you ever taken any language courses as part of full-time school?"
          precondition:
            - predicate: q_u1.outcome != 0
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # U11a: Which languages (in school)?
        # Pre: U11 == 1
        - id: q_u11a
          kind: Question
          title: "Which languages did you study in school?"
          precondition:
            - predicate: q_u11.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "English"
              2: "French"
              4: "Other"

        # U12: Language courses outside school?
        # Always asked (even if U1 == 0, since the original routes here from U1=0)
        - id: q_u12
          kind: Question
          title: "Have you ever taken any language courses outside of full-time school?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # U12a: Which languages (outside school)?
        # Pre: U12 == 1
        - id: q_u12a
          kind: Question
          title: "Which languages did you study outside of school?"
          precondition:
            - predicate: q_u12.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "English"
              2: "French"
              4: "Other"

    # =========================================================================
    # BLOCK 2: DEMOGRAPHICS (U13–U21a)
    # =========================================================================
    # U13: Religion. 0 → skip U14
    # U14: Attendance. Pre: U13 != 0
    # U15: Ethnic group (Checkbox)
    # U16: Community size
    # U17: Town name (Textarea)
    # U18: Postal code (Textarea)
    # U19: Dwelling type
    # U20: Owned or rented
    # U21: Other language at home. 2 → U21a
    # U21a: Which languages. Pre: U21 == 2
    # =========================================================================
    - id: b_u_demographics
      title: "Demographics"
      precondition:
        - predicate: lang_path == 7
      items:
        # U13: Religion
        - id: q_u13
          kind: Question
          title: "What, if any, is your religion?"
          input:
            control: Dropdown
            labels:
              0: "No religion"
              1: "Roman Catholic"
              2: "United Church"
              3: "Anglican"
              4: "Presbyterian"
              5: "Lutheran"
              6: "Baptist"
              7: "Eastern Orthodox"
              8: "Jewish"
              9: "Other"

        # U14: Religious attendance
        # Pre: U13 != 0 (has a religion)
        - id: q_u14
          kind: Question
          title: "Other than on special occasions, such as weddings, funerals or baptisms, how often do you attend services or meetings connected with your religion?"
          precondition:
            - predicate: q_u13.outcome != 0
          input:
            control: Radio
            labels:
              1: "At least once a week"
              2: "At least once a month"
              3: "At least once a year"
              4: "Less than once a year"
              5: "Never"

        # U15: Ethnic or cultural group
        - id: q_u15
          kind: Question
          title: "To which ethnic or cultural group do you or did your ancestors belong?"
          input:
            control: Checkbox
            labels:
              1: "English"
              2: "French"
              4: "Irish"
              8: "Scottish"
              16: "German"
              32: "Italian"
              64: "Ukrainian"
              128: "Other"
              256: "Don't know"

        # U16: Community size
        - id: q_u16
          kind: Question
          title: "What is the approximate size of the community in which you are now living? By community I mean city, town or rural area."
          input:
            control: Radio
            labels:
              1: "Less than 5,000 or rural"
              2: "5,000 to 25,000"
              3: "25,000 to 100,000"
              4: "100,000 to 1 million"
              5: "Over 1 million"

        # U17: Town name
        - id: q_u17
          kind: Question
          title: "What is the name of that town or nearest town? (Include province.)"
          input:
            control: Textarea
            placeholder: "Town and province..."

        # U18: Postal code (first 3 characters)
        - id: q_u18
          kind: Question
          title: "What are the first three characters of your postal code?"
          input:
            control: Textarea
            placeholder: "e.g., K1A"

        # U19: Dwelling type
        - id: q_u19
          kind: Question
          title: "What type of dwelling are you now living in?"
          input:
            control: Dropdown
            labels:
              1: "Single detached house"
              2: "Semi-detached or double (side-by-side)"
              3: "Garden house, town-house or row house"
              4: "Duplex (one above the other)"
              5: "Low-rise apartment (less than five stories)"
              6: "High-rise apartment (five or more stories)"
              7: "Other"

        # U20: Owned or rented
        - id: q_u20
          kind: Question
          title: "Is this dwelling owned or rented by a member of this household?"
          input:
            control: Radio
            labels:
              1: "Owned"
              2: "Rented"

        # U21: Other language spoken at home
        # 2 (Yes) → U21a
        - id: q_u21
          kind: Question
          title: "Is there a language, other than English, spoken in your home by the people living there?"
          input:
            control: Radio
            labels:
              1: "Person lives alone"
              2: "Yes"
              3: "No"

        # U21a: Which other languages at home
        # Pre: U21 == 2
        - id: q_u21a
          kind: Question
          title: "Which languages are spoken at home besides English?"
          precondition:
            - predicate: q_u21.outcome == 2
          input:
            control: Checkbox
            labels:
              1: "French"
              2: "Other"

    # =========================================================================
    # BLOCK 3: TELEPHONES (U22–U26)
    # =========================================================================
    # U22: How many phones? 1 → skip to U27; 2 → U23
    # U23: Same number? Pre: U22 == 2. Yes (1) → skip to U27; No (0) → U24
    # U24: How many different numbers? Pre: U22 == 2 and U23 == 0
    # U25: Business use? Pre: U22 == 2 and U23 == 0. No (0) → skip to U27
    # U26: How many business? Pre: U25 == 1
    # =========================================================================
    - id: b_u_telephones
      title: "Telephone Details"
      precondition:
        - predicate: lang_path == 7
      items:
        # U22: Number of telephones
        - id: q_u22
          kind: Question
          title: "How many telephones, counting extensions, are there in your dwelling?"
          input:
            control: Radio
            labels:
              1: "One"
              2: "Two or more"

        # U23: Same number for all phones?
        # Pre: U22 == 2 (two or more phones)
        - id: q_u23
          kind: Question
          title: "Do all the telephones have the same number?"
          precondition:
            - predicate: q_u22.outcome == 2
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # U24: How many different numbers?
        # Pre: U22 == 2 and U23 == 0 (different numbers)
        - id: q_u24
          kind: Question
          title: "How many different numbers are there?"
          precondition:
            - predicate: q_u22.outcome == 2
            - predicate: q_u23.outcome == 0
          input:
            control: Editbox
            min: 2
            max: 20
            right: "numbers"

        # U25: Any numbers for business use only?
        # Pre: U22 == 2 and U23 == 0
        - id: q_u25
          kind: Question
          title: "Are any of these numbers for business use only?"
          precondition:
            - predicate: q_u22.outcome == 2
            - predicate: q_u23.outcome == 0
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # U26: How many for business use?
        # Pre: U25 == 1 (yes, some business)
        - id: q_u26
          kind: Question
          title: "How many are for business use only?"
          precondition:
            - predicate: q_u25.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 20
            right: "numbers"

    # =========================================================================
    # BLOCK 4: EMPLOYMENT AND INCOME (U27–U41)
    # =========================================================================
    # U27: Main activity last 7 days (Radio)
    # U28: Main activity last 12 months
    #       1 (working) → skip to U31; else → U29
    #       codeBlock: if U28==1, worked_12m_u = 1
    # U29: Job in last 12 months? Pre: U28 != 1
    #       Yes (1) → U31; No (0) → U30
    #       codeBlock: if U29==1, worked_12m_u = 1
    # U30: Income from wages? Pre: U29 == 0 (no job)
    # U30_amount: Dollar amount. Pre: U30 in [1, 2]
    #       Then skip to U39 (modeled via preconditions on U31-U38)
    # U31: Weeks worked. Pre: worked_12m_u == 1
    # U32: Employee or self-employed. Pre: worked_12m_u == 1
    # U33: Full/part-time. Pre: U32 == 1 (employee)
    # U34: Employer. Pre: U32 == 1
    # U35: Business type. Pre: worked_12m_u == 1
    # U36: Work description. Pre: worked_12m_u == 1
    # U37: Languages at work. Pre: worked_12m_u == 1
    # U38: Income from wages (workers). Pre: worked_12m_u == 1
    # U38_amount: Dollar amount. Pre: U38 in [1, 2]
    # U39: Government income (always asked)
    # U40: Investment income
    # U40_amount: Dollar amount. Pre: U40 in [1, 2]
    # U41: Household income bracket (cascading → single Dropdown)
    # =========================================================================
    - id: b_u_employment
      title: "Employment and Income"
      precondition:
        - predicate: lang_path == 7
      items:
        # U27: Main activity last 7 days
        - id: q_u27
          kind: Question
          title: "Which of the following best describes your main activity during the last 7 days? Were you mainly..."
          input:
            control: Dropdown
            labels:
              1: "Working at a job or business"
              2: "Looking for work"
              3: "A student"
              4: "Keeping house"
              5: "Retired"
              6: "Other"

        # U28: Main activity last 12 months
        # 1 → worked_12m_u = 1, skip to U31
        - id: q_u28
          kind: Question
          title: "What about your main activity during the last 12 months? Were you mainly..."
          codeBlock: |
            if q_u28.outcome == 1:
              worked_12m_u = 1
          input:
            control: Dropdown
            labels:
              1: "Working at a job or business"
              2: "Looking for work"
              3: "A student"
              4: "Keeping house"
              5: "Retired"
              6: "Other"

        # U29: Had a job in last 12 months?
        # Pre: U28 != 1 (not mainly working)
        - id: q_u29
          kind: Question
          title: "Did you have a job at any time during the last 12 months?"
          precondition:
            - predicate: q_u28.outcome != 1
          codeBlock: |
            if q_u29.outcome == 1:
              worked_12m_u = 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # U30: Income from wages (for those who did NOT work)
        # Pre: U28 != 1 and U29 == 0 (no job at all in 12 months)
        - id: q_u30
          kind: Question
          title: "Did you have any income from wages, salaries and self-employment during the last 12 months?"
          precondition:
            - predicate: q_u28.outcome != 1
            - predicate: q_u29.outcome == 0
          input:
            control: Radio
            labels:
              1: "Yes - Income"
              2: "Yes - Loss"
              3: "No income"
              4: "Don't know"

        # U30_amount: Dollar amount of income/loss (non-workers)
        # Pre: U30 in [1, 2]
        - id: q_u30_amount
          kind: Question
          title: "What was the amount?"
          precondition:
            - predicate: q_u30.outcome in [1, 2]
          input:
            control: Editbox
            min: 0
            max: 999999
            left: "$"

        # U31: Weeks worked in last 12 months
        # Pre: worked_12m_u == 1
        - id: q_u31
          kind: Question
          title: "For how many weeks of those 12 months did you do any work at a job or business? (Include vacation, illness, strikes, lock-outs and paid maternity leave.)"
          precondition:
            - predicate: worked_12m_u == 1
          input:
            control: Editbox
            min: 0
            max: 52
            right: "weeks"

        # U32: Employee or self-employed
        # Pre: worked_12m_u == 1
        - id: q_u32
          kind: Question
          title: "During those weeks of work were you mainly..."
          precondition:
            - predicate: worked_12m_u == 1
          input:
            control: Radio
            labels:
              1: "An employee working for someone else"
              2: "Self-employed"

        # U33: Full-time or part-time
        # Pre: U32 == 1 (employee)
        - id: q_u33
          kind: Question
          title: "During those weeks of work were you mostly full-time or part-time?"
          precondition:
            - predicate: q_u32.outcome == 1
          input:
            control: Radio
            labels:
              1: "Full-time"
              2: "Part-time"

        # U34: Employer name
        # Pre: U32 == 1 (employee)
        - id: q_u34
          kind: Question
          title: "For whom do you/did you last work? (Name of business, government department or agency or person)"
          precondition:
            - predicate: q_u32.outcome == 1
          input:
            control: Textarea
            placeholder: "Enter employer name..."

        # U35: Kind of business/industry
        # Pre: worked_12m_u == 1
        - id: q_u35
          kind: Question
          title: "What was the main kind of business, industry or service?"
          precondition:
            - predicate: worked_12m_u == 1
          input:
            control: Textarea
            placeholder: "Give a full description..."

        # U36: Kind of work
        # Pre: worked_12m_u == 1
        - id: q_u36
          kind: Question
          title: "What kind of work were you doing?"
          precondition:
            - predicate: worked_12m_u == 1
          input:
            control: Textarea
            placeholder: "Give a full description..."

        # U37: Languages spoken at work
        # Pre: worked_12m_u == 1
        - id: q_u37
          kind: Question
          title: "Which languages are/were spoken at work by people with whom you have/had regular contact?"
          precondition:
            - predicate: worked_12m_u == 1
          input:
            control: Checkbox
            labels:
              1: "English"
              2: "French"
              4: "Other"

        # U38: Income from wages (workers)
        # Pre: worked_12m_u == 1
        - id: q_u38
          kind: Question
          title: "What was your income before taxes, from wages, salaries and self-employment during the last 12 months?"
          precondition:
            - predicate: worked_12m_u == 1
          input:
            control: Radio
            labels:
              1: "Income"
              2: "Loss"
              3: "No income"
              4: "Don't know"

        # U38_amount: Dollar amount (workers with income/loss)
        # Pre: U38 in [1, 2]
        - id: q_u38_amount
          kind: Question
          title: "What was the dollar amount?"
          precondition:
            - predicate: q_u38.outcome in [1, 2]
          input:
            control: Editbox
            min: 0
            max: 999999
            left: "$"

        # U39: Government income
        # Radio for no income / don't know, Editbox for amount.
        # Modeled as Radio first, then conditional Editbox.
        - id: q_u39
          kind: Question
          title: "What was your income from government sources such as Family Allowance, U.I.C., Social Assistance, Canada or Quebec Pension Plan or Old Age Security?"
          input:
            control: Radio
            labels:
              1: "Had government income"
              2: "No income from government"
              3: "Don't know"

        # U39_amount: Dollar amount of government income
        # Pre: U39 == 1
        - id: q_u39_amount
          kind: Question
          title: "What was the dollar amount from government sources?"
          precondition:
            - predicate: q_u39.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 999999
            left: "$"

        # U40: Investment or private pension income
        - id: q_u40
          kind: Question
          title: "What was your income from investments or private pensions?"
          input:
            control: Radio
            labels:
              1: "Income"
              2: "Loss"
              3: "No income"
              4: "Don't know"

        # U40_amount: Dollar amount of investment income
        # Pre: U40 in [1, 2]
        - id: q_u40_amount
          kind: Question
          title: "What was the dollar amount from investments or private pensions?"
          precondition:
            - predicate: q_u40.outcome in [1, 2]
          input:
            control: Editbox
            min: 0
            max: 999999
            left: "$"

        # U41: Total household income bracket
        # Original uses cascading binary tree of yes/no sub-questions to arrive
        # at one of 11 final brackets. Simplified to a single Dropdown listing
        # all final brackets.
        - id: q_u41
          kind: Question
          title: "What is your best estimate of the total income of all household members from all sources during the last 12 months?"
          input:
            control: Dropdown
            labels:
              1: "No income"
              2: "Less than $5,000"
              3: "$5,000 to $9,999"
              4: "$10,000 to $14,999"
              5: "$15,000 to $19,999"
              6: "$20,000 to $29,999"
              7: "$30,000 to $39,999"
              8: "$40,000 to $59,999"
              9: "$60,000 or more"
              10: "Don't know"
