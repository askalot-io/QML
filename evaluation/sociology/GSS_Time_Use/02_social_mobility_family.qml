qmlVersion: "1.0"
questionnaire:
  title: "GSS Time Use - Section B: Social Mobility (Father and/or Mother)"
  codeInit: |
    # No cross-section variables needed for Section B

  blocks:
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
