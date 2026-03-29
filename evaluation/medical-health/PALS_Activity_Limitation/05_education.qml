qmlVersion: "1.0"
questionnaire:
  title: "PALS 2001 Children - Section E: Education"

  codeInit: |
    # Extern variable: child is under 5 — entire section skipped
    child_under_5: {0, 1}
    # Routing path variable
    # 1 = going to school (E1=1), 2 = tutored at home (E1=2), 3 = neither (E1=3), 0 = DK/R
    e1_path = 0
    # Whether child ever went to school (E4)
    e4_ever_school = 0
    # Whether child is at a special ed school (E6=1)
    e6_special_school = 0
    # Class type at school (E7 outcome; 0 = not asked)
    e7_class_type = 0
    # Whether child ever attended special ed school (E8)
    e8_ever_special = 0
    # Province of school (E13 outcome; 0 = not asked)
    e13_province = 0
    # Kindergarten flag set by grade questions E14-E19
    is_kindergarten = 0
    # Whether child used special building features (E25)
    e25_used_features = 0
    # Whether child needed special features not available (E27)
    e27_needed_features = 0
    # Whether there were unmet assistive aid needs (E30)
    e30_unmet_aids = 0
    # Whether professional assessment done (E37)
    e37_assessment = 0

  blocks:
    # =========================================================================
    # SECTION E — EDUCATION
    # Entire section skipped for children under 5 (child_under_5 == 1)
    #
    # E1 routing (3-way):
    #   1 (Going to school)     → E6
    #   2 (Tutored at home)     → E2 → GO TO E37
    #   3 (Neither)             → E3 → E4
    #   DK/R                   → E4
    #
    # E4: Did child ever go to school?
    #   1 Yes → GO TO E37
    #   3 No  → E5 → GO TO E37
    #   DK/R  → GO TO E37
    #
    # E6=1 (special ed school) → GO TO E10
    # E6=2/3/4/DK → E7 → E8
    #   E8=1 (Yes) → E9 → E10
    #   E8=3/DK/R  → E10.edit filter: E7==1 → E11; otherwise → E10
    #
    # E10 → E11 → E12(if E11=1) → E13 → province-specific grade
    # Grade questions E14-E19 set is_kindergarten; → E20 or E24
    # E20-E23 → E24 → E25 → E26(if E25=1) → E27 → E28(if E27=1) → E29
    # → E30 → E31(if E30=1) → E32 → E33 → E34 → E35 → E36 → E37
    # E37 → E38(if E37=1) → end
    # =========================================================================
    - id: b_education
      title: "Section E — Education"
      precondition:
        - predicate: child_under_5 == 0

      items:
        # -------------------------------------------------------------------
        # E1: School attendance status in April 2001
        # -------------------------------------------------------------------
        - id: q_e1
          kind: Question
          title: "The next few questions are about education. In APRIL 2001 was .....:"
          input:
            control: Radio
            labels:
              1: "Going to school or kindergarten"
              2: "Being tutored at home through the school system"
              3: "Neither of the above"
              8: "Don't know"
              9: "Refusal"
          codeBlock: |
            if q_e1.outcome == 1:
                e1_path = 1
            elif q_e1.outcome == 2:
                e1_path = 2
            elif q_e1.outcome == 3:
                e1_path = 3
            else:
                e1_path = 0

        # -------------------------------------------------------------------
        # E2: Reason for home tutoring (E1=2 only) → then GO TO E37
        # -------------------------------------------------------------------
        - id: qg_e2
          kind: QuestionGroup
          title: "Why was ..... being tutored at home through the school system? I will read you a list. Please answer yes or no to each."
          precondition:
            - predicate: e1_path == 2
          questions:
            - "(a) Personal care such as feeding and toiletting needed, but not available at school"
            - "(b) Teacher's aides or special education classes not available in REGULAR SCHOOL"
            - "(c) SPECIAL EDUCATION SCHOOL not available locally"
            - "(d) Child's condition or health problem prevented him/her from going to school"
            - "(e) Parents preferred home tutoring for the child"
            - "(f) Other reason, specify"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -------------------------------------------------------------------
        # E3: Reason for not attending school (E1=3 only) → then E4
        # -------------------------------------------------------------------
        - id: qg_e3
          kind: QuestionGroup
          title: "Why was ..... not attending school in April 2001? I will read you a list. Please answer yes or no to each."
          precondition:
            - predicate: e1_path == 3
          questions:
            - "(a) Personal care such as feeding and toiletting needed, but not available at school"
            - "(b) Teacher's aides or special education classes not available in REGULAR SCHOOL"
            - "(c) SPECIAL EDUCATION SCHOOL not available locally"
            - "(d) Child's condition or health problem prevented him/her from going to school"
            - "(e) Child not ready or too young to attend school"
            - "(f) Other reason, specify"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -------------------------------------------------------------------
        # E4: Did child ever go to school? (E1=3 or E1=DK/R)
        # -------------------------------------------------------------------
        - id: q_e4
          kind: Question
          title: "Did ..... ever go to school?"
          precondition:
            - predicate: e1_path == 3 or e1_path == 0
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"
          codeBlock: |
            if q_e4.outcome == 1 or q_e4.outcome == 8 or q_e4.outcome == 9:
                e4_ever_school = 1
            else:
                e4_ever_school = 0

        # -------------------------------------------------------------------
        # E5: Why never attended school (E4=3 No only) → then GO TO E37
        # -------------------------------------------------------------------
        - id: q_e5
          kind: Question
          title: "Why did ..... never attend school?"
          precondition:
            - predicate: e1_path == 3 or e1_path == 0
            - predicate: e4_ever_school == 0
          input:
            control: Checkbox
            labels:
              1: "(a) Personal care such as feeding and toiletting needed, but not available at school"
              2: "(b) Teacher's aides or special education classes not available in REGULAR SCHOOL"
              4: "(c) SPECIAL EDUCATION SCHOOL not available locally"
              8: "(d) Child's condition or health problem prevented him/her from going to school"
              16: "(e) Child not ready or too young to attend school"
              32: "(f) Other reason, specify"
              64: "Don't know"
              128: "Refusal"

        # -------------------------------------------------------------------
        # E6: Type of school attended in April 2001 (E1=1 only)
        # -------------------------------------------------------------------
        - id: q_e6
          kind: Question
          title: "In APRIL 2001, what type of school was ..... attending?"
          precondition:
            - predicate: e1_path == 1
          input:
            control: Radio
            labels:
              1: "Special education school"
              2: "Regular school"
              3: "Regular school with special education classes"
              4: "Other, specify"
              8: "Don't know"
              9: "Refusal"
          codeBlock: |
            if q_e6.outcome == 1:
                e6_special_school = 1
            else:
                e6_special_school = 0

        # -------------------------------------------------------------------
        # E7: Type of classes at school (E6=2/3/4/DK/R — not special ed school)
        # -------------------------------------------------------------------
        - id: q_e7
          kind: Question
          title: "At this school, what type of classes was ..... attending?"
          precondition:
            - predicate: e1_path == 1
            - predicate: e6_special_school == 0
          input:
            control: Radio
            labels:
              1: "Only regular classes"
              2: "Some regular classes and some special education classes"
              3: "Only special education classes"
              8: "Don't know"
              9: "Refusal"
          codeBlock: |
            e7_class_type = q_e7.outcome

        # -------------------------------------------------------------------
        # E8: Ever attended a special education school
        # Shown after E7 (E6 != 1) OR directly after E6=1 (special school)
        # i.e. shown when e1_path == 1
        # -------------------------------------------------------------------
        - id: q_e8
          kind: Question
          title: "Did ..... ever attend a special education school?"
          precondition:
            - predicate: e1_path == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"
          codeBlock: |
            if q_e8.outcome == 1:
                e8_ever_special = 1
            else:
                e8_ever_special = 0

        # -------------------------------------------------------------------
        # E9: Why not attending special ed school now (E8=1 Yes)
        # -------------------------------------------------------------------
        - id: q_e9
          kind: Question
          title: "Why didn't he/she attend a special education school in April 2001?"
          precondition:
            - predicate: e1_path == 1
            - predicate: e8_ever_special == 1
          input:
            control: Checkbox
            labels:
              1: "(a) Special education school no longer available locally"
              2: "(b) Child has moved into regular school"
              4: "(c) Other reason, specify"
              8: "Don't know"
              16: "Refusal"

        # -------------------------------------------------------------------
        # E10: Main condition requiring special education services
        # Shown when: came via special ed school (E6=1)
        #   OR came via E7 != 1 (not "only regular classes")
        # i.e. e6_special_school==1 OR (e1_path==1 AND e7_class_type != 1)
        # -------------------------------------------------------------------
        - id: qg_e10
          kind: QuestionGroup
          title: "What is the MAIN condition or health problem which required ..... to receive special education services? I will read you a list. Please answer yes or no to each."
          precondition:
            - predicate: e1_path == 1
            - predicate: e6_special_school == 1 or e7_class_type != 1
          questions:
            - "(a) Learning disabilities"
            - "(b) Developmental disability or disorder"
            - "(c) Speech or language difficulties"
            - "(d) Emotional, psychological or behavioural conditions"
            - "(e) Hearing difficulties, including deafness"
            - "(f) Vision difficulties, including blindness"
            - "(g) Difficulty with walking or moving around"
            - "(h) Other condition, specify"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -------------------------------------------------------------------
        # E11: Difficulty getting special education services (all going to school)
        # -------------------------------------------------------------------
        - id: q_e11
          kind: Question
          title: "Did you ever have any difficulty in trying to get special education services for .....?"
          precondition:
            - predicate: e1_path == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"

        # -------------------------------------------------------------------
        # E12: Kind of difficulty (E11=1 Yes)
        # -------------------------------------------------------------------
        - id: qg_e12
          kind: QuestionGroup
          title: "What kind of difficulty did you have? I will read you a list. Please answer yes or no to each."
          precondition:
            - predicate: e1_path == 1
            - predicate: q_e11.outcome == 1
          questions:
            - "(a) Special education services not available locally"
            - "(b) Insufficient level of staffing or special education services"
            - "(c) Communication problems with school"
            - "(d) Difficulty to have the child tested for special education services"
            - "(e) Other difficulty, specify"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -------------------------------------------------------------------
        # E13: Province or territory where child attended school
        # -------------------------------------------------------------------
        - id: q_e13
          kind: Question
          title: "In APRIL 2001, in which province or territory did ..... attend school?"
          precondition:
            - predicate: e1_path == 1
          input:
            control: Dropdown
            labels:
              1: "Newfoundland"
              2: "Prince Edward Island"
              3: "Nova Scotia"
              4: "New Brunswick"
              5: "Quebec"
              6: "Ontario"
              7: "Manitoba"
              8: "Saskatchewan"
              9: "Alberta"
              10: "British Columbia"
              11: "Northwest Territory"
              12: "Nunavut"
              13: "Yukon"
              14: "Other, specify"
              98: "Don't know"
              99: "Refusal"
          codeBlock: |
            e13_province = q_e13.outcome

        # -------------------------------------------------------------------
        # E14: Grade — Newfoundland (E13=1)
        # Kindergarten (01) → E24; others → E20
        # -------------------------------------------------------------------
        - id: q_e14
          kind: Question
          title: "In what grade was ..... enrolled in APRIL 2001? (Newfoundland)"
          precondition:
            - predicate: e1_path == 1
            - predicate: e13_province == 1
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
              11: "Level 1 Secondary"
              12: "Level 2 Secondary"
              13: "Level 3 Secondary"
              14: "Ungraded"
              98: "Don't know"
              99: "Refusal"
          codeBlock: |
            if q_e14.outcome == 1:
                is_kindergarten = 1
            else:
                is_kindergarten = 0

        # -------------------------------------------------------------------
        # E15: Grade — Prince Edward Island (E13=2)
        # No kindergarten option — always → E20
        # -------------------------------------------------------------------
        - id: q_e15
          kind: Question
          title: "In what grade was ..... enrolled in APRIL 2001? (Prince Edward Island)"
          precondition:
            - predicate: e1_path == 1
            - predicate: e13_province == 2
          input:
            control: Dropdown
            labels:
              1: "Grade 1"
              2: "Grade 2"
              3: "Grade 3"
              4: "Grade 4"
              5: "Grade 5"
              6: "Grade 6"
              7: "Grade 7"
              8: "Grade 8"
              9: "Grade 9"
              10: "Grade 10"
              11: "Grade 11"
              12: "Grade 12"
              13: "Ungraded"
              98: "Don't know"
              99: "Refusal"
          codeBlock: |
            is_kindergarten = 0

        # -------------------------------------------------------------------
        # E16: Grade — Nova Scotia (E13=3)
        # Primary (01) → E24; others → E20
        # -------------------------------------------------------------------
        - id: q_e16
          kind: Question
          title: "In what grade was ..... enrolled in APRIL 2001? (Nova Scotia)"
          precondition:
            - predicate: e1_path == 1
            - predicate: e13_province == 3
          input:
            control: Dropdown
            labels:
              1: "Primary"
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
              14: "Ungraded"
              98: "Don't know"
              99: "Refusal"
          codeBlock: |
            if q_e16.outcome == 1:
                is_kindergarten = 1
            else:
                is_kindergarten = 0

        # -------------------------------------------------------------------
        # E17: Grade — Quebec (E13=5)
        # Junior Kindergarten/Kindergarten (01-02) → E24; others → E20
        # -------------------------------------------------------------------
        - id: q_e17
          kind: Question
          title: "In what grade was ..... enrolled in APRIL 2001? (Quebec)"
          precondition:
            - predicate: e1_path == 1
            - predicate: e13_province == 5
          input:
            control: Dropdown
            labels:
              1: "Junior Kindergarten"
              2: "Kindergarten"
              3: "Grade 1 Elementary"
              4: "Grade 2 Elementary"
              5: "Grade 3 Elementary"
              6: "Grade 4 Elementary"
              7: "Grade 5 Elementary"
              8: "Grade 6 Elementary"
              9: "Secondary I"
              10: "Secondary II"
              11: "Secondary III"
              12: "Secondary IV"
              13: "Secondary V"
              14: "Ungraded"
              98: "Don't know"
              99: "Refusal"
          codeBlock: |
            if q_e17.outcome == 1 or q_e17.outcome == 2:
                is_kindergarten = 1
            else:
                is_kindergarten = 0

        # -------------------------------------------------------------------
        # E18: Grade — Ontario (E13=6)
        # Junior Kindergarten/Kindergarten (01-02) → E24; others → E20
        # -------------------------------------------------------------------
        - id: q_e18
          kind: Question
          title: "In what grade was ..... enrolled in APRIL 2001? (Ontario)"
          precondition:
            - predicate: e1_path == 1
            - predicate: e13_province == 6
          input:
            control: Dropdown
            labels:
              1: "Junior Kindergarten"
              2: "Kindergarten"
              3: "Grade 1"
              4: "Grade 2"
              5: "Grade 3"
              6: "Grade 4"
              7: "Grade 5"
              8: "Grade 6"
              9: "Grade 7"
              10: "Grade 8"
              11: "Grade 9"
              12: "Grade 10"
              13: "Grade 11"
              14: "Grade 12"
              15: "OAC"
              16: "Ungraded"
              98: "Don't know"
              99: "Refusal"
          codeBlock: |
            if q_e18.outcome == 1 or q_e18.outcome == 2:
                is_kindergarten = 1
            else:
                is_kindergarten = 0

        # -------------------------------------------------------------------
        # E19: Grade — All other provinces/territories (E13 not in 1,2,3,5,6)
        # Kindergarten (01) → E24; others → E20
        # -------------------------------------------------------------------
        - id: q_e19
          kind: Question
          title: "In what grade was ..... enrolled in APRIL 2001?"
          precondition:
            - predicate: e1_path == 1
            - predicate: e13_province not in [1, 2, 3, 5, 6]
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
              14: "Ungraded"
              98: "Don't know"
              99: "Refusal"
          codeBlock: |
            if q_e19.outcome == 1:
                is_kindergarten = 1
            else:
                is_kindergarten = 0

        # -------------------------------------------------------------------
        # E20: Type of education/training/therapy at school (non-kindergarten only)
        # -------------------------------------------------------------------
        - id: qg_e20
          kind: QuestionGroup
          title: "In APRIL 2001, what type of education, training or therapy was ..... receiving at school? I will read you a list. Please answer yes or no to each."
          precondition:
            - predicate: e1_path == 1
            - predicate: is_kindergarten == 0
          questions:
            - "(a) Academic subjects"
            - "(b) Life skills"
            - "(c) Speech and language therapy"
            - "(d) Mental health or counselling services"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -------------------------------------------------------------------
        # E21: Academic performance during last school year (non-kindergarten)
        # -------------------------------------------------------------------
        - id: q_e21
          kind: Question
          title: "Based on your knowledge of his/her school work, including his/her report cards, how did ..... do during the last school year?"
          precondition:
            - predicate: e1_path == 1
            - predicate: is_kindergarten == 0
          input:
            control: Radio
            labels:
              1: "Very well"
              2: "Well"
              3: "Average"
              4: "Poorly"
              5: "Very poorly"
              6: "Not applicable"
              8: "Don't know"
              9: "Refusal"

        # -------------------------------------------------------------------
        # E22: Homework help frequency (non-kindergarten)
        # -------------------------------------------------------------------
        - id: q_e22
          kind: Question
          title: "How often did you (or your spouse/partner) check .....''s homework or provide help with his/her homework during the last school year?"
          precondition:
            - predicate: e1_path == 1
            - predicate: is_kindergarten == 0
          input:
            control: Radio
            labels:
              1: "Never or rarely"
              2: "Less than once a month"
              3: "At least once a month"
              4: "At least once a week"
              5: "A few times a week"
              6: "Every day"
              8: "Don't know"
              9: "Refusal"

        # -------------------------------------------------------------------
        # E23: Education impacts (non-kindergarten)
        # -------------------------------------------------------------------
        - id: qg_e23
          kind: QuestionGroup
          title: "Because of a condition or health problem:"
          precondition:
            - predicate: e1_path == 1
            - predicate: is_kindergarten == 0
          questions:
            - "(a) Did ..... have to leave his/her community to attend school?"
            - "(b) Was his/her schooling interrupted for long periods of time?"
            - "(c) Did ..... take fewer courses or academic subjects at school?"
            - "(d) Did it take ..... longer to achieve his/her present level of education?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -------------------------------------------------------------------
        # E24: School activity limitations (all going to school, including kindergarten)
        # -------------------------------------------------------------------
        - id: qg_e24
          kind: QuestionGroup
          title: "Did a condition or health problem limit .....''s participation in any of the following SCHOOL ACTIVITIES during the last school year (which ended in June 2001)?"
          precondition:
            - predicate: e1_path == 1
          questions:
            - "(a) Taking part in physical education or organized games requiring physical activity"
            - "(b) Playing with others during recess or lunch hour"
            - "(c) Taking part in school outings, such as visits to a museum"
            - "(d) Classroom participation"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -------------------------------------------------------------------
        # E25: Use of special building features at school
        # -------------------------------------------------------------------
        - id: q_e25
          kind: Question
          title: "Because of a condition or health problem, did ..... USE any special building features or equipment, such as ramps or automatic door openers AT SCHOOL?"
          precondition:
            - predicate: e1_path == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"
          codeBlock: |
            if q_e25.outcome == 1:
                e25_used_features = 1
            else:
                e25_used_features = 0

        # -------------------------------------------------------------------
        # E26: Which special features used at school (E25=1)
        # -------------------------------------------------------------------
        - id: qg_e26
          kind: QuestionGroup
          title: "Which kind of special features did he/she USE at school? I will read you a list. Please answer yes or no to each."
          precondition:
            - predicate: e1_path == 1
            - predicate: e25_used_features == 1
          questions:
            - "(a) Ramps or street level entrances"
            - "(b) Widened doorways or hallways"
            - "(c) Automatic or easy to open doors"
            - "(d) An elevator or lift device"
            - "(e) Special railings in washrooms"
            - "(f) Other feature, specify"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -------------------------------------------------------------------
        # E27: Need for special features not available at school
        # -------------------------------------------------------------------
        - id: q_e27
          kind: Question
          title: "Because of a condition or a health problem, did ..... NEED any special features or equipment, such as ramps or automatic door openers AT SCHOOL, which were not available?"
          precondition:
            - predicate: e1_path == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"
          codeBlock: |
            if q_e27.outcome == 1:
                e27_needed_features = 1
            else:
                e27_needed_features = 0

        # -------------------------------------------------------------------
        # E28: What features needed but not available (E27=1)
        # -------------------------------------------------------------------
        - id: qg_e28
          kind: QuestionGroup
          title: "What kind of special features or equipment did he/she need AT SCHOOL, but did not have?"
          precondition:
            - predicate: e1_path == 1
            - predicate: e27_needed_features == 1
          questions:
            - "(a) Ramps or street level entrances"
            - "(b) Widened doorways or hallways"
            - "(c) Automatic or easy to open doors"
            - "(d) An elevator or lift device"
            - "(e) Special railings in washrooms"
            - "(f) Other feature, specify"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -------------------------------------------------------------------
        # E29: Assistive aids/devices/services used at school
        # -------------------------------------------------------------------
        - id: qg_e29
          kind: QuestionGroup
          title: "During the last school year, did ..... USE any assistive aids, devices or services AT SCHOOL? I will read you a list. Please answer yes or no to each."
          precondition:
            - predicate: e1_path == 1
          questions:
            - "(a) Tutors or teacher's aides"
            - "(b) Note takers or readers"
            - "(c) Sign language interpreters"
            - "(d) Attendant care services"
            - "(e) Amplifiers, such as FM or infrared"
            - "(f) Talking books"
            - "(g) Magnifiers"
            - "(h) Recording equipment"
            - "(i) A computer with Braille or speech access"
            - "(j) Other aid or service, specify"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -------------------------------------------------------------------
        # E30: Unmet assistive aid needs at school
        # -------------------------------------------------------------------
        - id: q_e30
          kind: Question
          title: "Were there any assistive aids, devices or services that ..... needed AT SCHOOL, but did not have?"
          precondition:
            - predicate: e1_path == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"
          codeBlock: |
            if q_e30.outcome == 1:
                e30_unmet_aids = 1
            else:
                e30_unmet_aids = 0

        # -------------------------------------------------------------------
        # E31: What aids needed but not available (E30=1)
        # -------------------------------------------------------------------
        - id: qg_e31
          kind: QuestionGroup
          title: "What kind of assistive aids or services did he/she need AT SCHOOL, but did not have?"
          precondition:
            - predicate: e1_path == 1
            - predicate: e30_unmet_aids == 1
          questions:
            - "(a) Tutors or teacher's aides"
            - "(b) Note takers or readers"
            - "(c) Sign language interpreters"
            - "(d) Attendant care services"
            - "(e) Amplifiers, such as FM or infrared"
            - "(f) Talking books"
            - "(g) Magnifiers"
            - "(h) Recording equipment"
            - "(i) A computer with Braille or speech access"
            - "(j) Other aid or service, specify"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -------------------------------------------------------------------
        # E32: Why aids not available (shown after E31)
        # -------------------------------------------------------------------
        - id: qg_e32
          kind: QuestionGroup
          title: "Why didn't ..... have these aids or services AT SCHOOL? I will read you a list. Please answer yes or no to each."
          precondition:
            - predicate: e1_path == 1
            - predicate: e30_unmet_aids == 1
          questions:
            - "(a) School funding cutbacks or lack of funding in the school system"
            - "(b) School did not think child needed assistive aids or services"
            - "(c) Child did not want to use assistive aids or services"
            - "(d) Other reason, specify"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -------------------------------------------------------------------
        # E33: Parental involvement activities during last school year
        # -------------------------------------------------------------------
        - id: qg_e33
          kind: QuestionGroup
          title: "During the last school year, have you (or your partner/spouse) done any of the following for .....? I will read you a list. Please answer yes or no to each."
          precondition:
            - predicate: e1_path == 1
          questions:
            - "(a) Spoken to, visited or corresponded with child's teacher"
            - "(b) Attended a school event in which child participated"
            - "(c) Volunteered in child's class or helped with a class trip"
            - "(d) Helped elsewhere in the school"
            - "(e) Attended a parent-school association meeting"
            - "(f) Fundraising for school"
            - "(g) Other activity, specify"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # -------------------------------------------------------------------
        # E34: Agreement with descriptions of school (3 sub-items, 4-point scale)
        # -------------------------------------------------------------------
        - id: qg_e34
          kind: QuestionGroup
          title: "Do you strongly agree, agree, disagree, or strongly disagree with the following descriptions of the school that ..... attended during the last school year?"
          precondition:
            - predicate: e1_path == 1
          questions:
            - "(a) The school offered parents many opportunities to be involved in the school activities"
            - "(b) Parents were made to feel welcome in the school"
            - "(c) Overall, the school accommodated the child's condition or health problem"
          input:
            control: Radio
            labels:
              1: "Strongly agree"
              2: "Agree"
              3: "Disagree"
              4: "Strongly disagree"
              8: "Don't know"
              9: "Refusal"

        # -------------------------------------------------------------------
        # E35: How often child looked forward to school
        # -------------------------------------------------------------------
        - id: q_e35
          kind: Question
          title: "With regard to how he/she feels about school, how often did ..... look forward to going to school during the last school year?"
          precondition:
            - predicate: e1_path == 1
          input:
            control: Radio
            labels:
              1: "Almost never"
              2: "Rarely"
              3: "Sometimes"
              4: "Often"
              5: "Almost always"
              8: "Don't know"
              9: "Refusal"

        # -------------------------------------------------------------------
        # E36: Transportation to school
        # -------------------------------------------------------------------
        - id: q_e36
          kind: Question
          title: "During the last school year, what was the method of transportation ..... used MOST OFTEN to get to school?"
          precondition:
            - predicate: e1_path == 1
          input:
            control: Radio
            labels:
              1: "Was driven to school by family motor vehicle"
              2: "School bus"
              3: "Regular city bus"
              4: "Specialized bus services for persons with disabilities"
              5: "Walked or biked to school"
              6: "Other, specify"
              8: "Don't know"
              9: "Refusal"

        # -------------------------------------------------------------------
        # E37: Professional assessment for educational needs
        # Convergence point — reached from all paths:
        #   e1_path==2 (after E2)
        #   e1_path==3 AND e4_ever_school==1 (E4=Yes/DK/R)
        #   e1_path==0 AND e4_ever_school==1 (E4=Yes/DK/R, came from DK/R on E1)
        #   e1_path==3 AND e4_ever_school==0 (after E5)
        #   e1_path==1 (after E36)
        # So: shown to everyone in the section
        # -------------------------------------------------------------------
        - id: q_e37
          kind: Question
          title: "Has a professional assessment ever been done to determine .....''s educational needs?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"
              9: "Refusal"
          codeBlock: |
            if q_e37.outcome == 1:
                e37_assessment = 1
            else:
                e37_assessment = 0

        # -------------------------------------------------------------------
        # E38: Who completed the professional assessment (E37=1)
        # -------------------------------------------------------------------
        - id: qg_e38
          kind: QuestionGroup
          title: "Who completed this assessment? I will read you a list. Please answer yes or no to each."
          precondition:
            - predicate: e37_assessment == 1
          questions:
            - "(a) Psychologist or psychiatrist"
            - "(b) Social worker"
            - "(c) Special education consultant"
            - "(d) Speech or language therapist"
            - "(e) Other professional or specialist, specify"
          input:
            control: Switch
            off: "No"
            on: "Yes"
