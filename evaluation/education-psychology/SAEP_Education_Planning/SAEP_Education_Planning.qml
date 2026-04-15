qmlVersion: "1.0"
questionnaire:
  title: "Survey of Approaches to Educational Planning"
  codeInit: |
    # =====================================================================
    # Cross-section variables. With a single codeInit scope and one
    # dependency graph, variables written by an earlier block are visible
    # to every later block without any extern declaration.
    # =====================================================================
    num_children = 0
    has_savings_plan = 0
    has_remaining_plan = 0
    has_outside_plan = 0

  blocks:

    # ===================================================================
    # SECTION: screening
    # ===================================================================
    - id: b_screening
      title: "Introduction and Screening"
      items:
        - id: q_a1_num_children
          kind: Question
          title: "How many children 18 years of age or younger usually live at this dwelling? This includes children who usually live here but are now away at school, in the hospital or somewhere else."
          input:
            control: Editbox
            min: 0
            max: 20
          codeBlock: |
            num_children = q_a1_num_children.outcome

        - id: q_a2_pmk
          kind: Question
          title: "I would like to speak to the person who is the most knowledgeable about these children and about any plans made for their post-secondary education. Would this person be you?"
          precondition:
            - predicate: q_a1_num_children.outcome >= 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

    # ===================================================================
    # SECTION: child1
    # ===================================================================
    # =========================================================================
    # BLOCK 1: CHILD 1 DEMOGRAPHICS AND GENERAL QUESTIONS (B1-B3)
    # =========================================================================
    # Child info (sex, age), relationship, health, hopes for school.
    # Applies to all children regardless of age.
    # =========================================================================
    - id: b_child1_demographics
      title: "Child 1 - Demographics and General Questions"
      items:
        # Child 1 sex
        - id: q_b_child1_sex
          kind: Question
          title: "Sex of Child 1"
          input:
            control: Radio
            labels:
              1: "Male"
              2: "Female"

        # Child 1 age
        - id: q_b_child1_age
          kind: Question
          title: "Age of Child 1 (in years; if less than 1 year, enter 0)"
          input:
            control: Editbox
            min: 0
            max: 18

        # B1: Relationship to respondent
        - id: q_b1_relationship
          kind: Question
          title: "Now I am going to ask you some questions about Child 1. What is the child's relationship to you?"
          input:
            control: Radio
            labels:
              1: "Son/daughter (biological, adoptive, stepchild)"
              2: "Foster child"
              3: "Grandchild"
              4: "Brother/sister"
              5: "Other family member or relative"
              6: "Unrelated"

        # B2: Long-term health conditions
        - id: q_b2_health
          kind: Question
          title: "Does the child have any long-term conditions or health problems which prevent or limit his/her participation in school, at play, or in any other activity for a child of his/her age?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B3: Hopes for schooling
        - id: q_b3_hopes
          kind: Question
          title: "How far do the child's parents/guardians hope that he/she will go in school?"
          input:
            control: Radio
            labels:
              1: "Primary school"
              2: "Secondary or high school"
              3: "Community college, technical college or CEGEP"
              4: "University"
              5: "Learn a trade"
              7: "Don't know"
              8: "Refused"

    # =========================================================================
    # BLOCK 2: SCHOOL QUESTIONS (B5-B19)
    # =========================================================================
    # B4 filter: age 0-4 skip to B20; age 5-8 skip B5 go to B6; age 9+ get B5.
    # Block precondition: age >= 5 (children 0-4 skip entire block).
    # =========================================================================
    - id: b_child1_school
      title: "Child 1 - School Questions"
      precondition:
        - predicate: q_b_child1_age.outcome >= 5
      items:
        # B5: Expectations for schooling (age 9+ only)
        - id: q_b5_expect
          kind: Question
          title: "How far do the child's parents/guardians expect that he/she will go in school?"
          precondition:
            - predicate: q_b_child1_age.outcome >= 9
          input:
            control: Radio
            labels:
              1: "Primary school"
              2: "Secondary or high school"
              3: "Community college, technical college or CEGEP"
              4: "University"
              5: "Learn a trade"
              7: "Don't know"
              8: "Refused"

        # B6: Did child attend school last year?
        # DK/R route to B20 (skip rest of school block) - modeled via preconditions on downstream items
        - id: q_b6_attend
          kind: Question
          title: "Did the child attend school last year? (Include home schooling.)"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B7: Why not attend school? (only if B6=No)
        # Codes 1,2 -> B20; codes 3,4,5 -> B8
        - id: q_b7_why_not
          kind: Question
          title: "Why did the child not attend school last year?"
          precondition:
            - predicate: q_b6_attend.outcome == 2
          input:
            control: Radio
            labels:
              1: "Too young for school"
              2: "Physical, mental, emotional or behavioral problem"
              3: "Left school before graduating"
              4: "Graduated from school"
              5: "Other"

        # B7 specify: free text for "Other" (code 5)
        - id: q_b7_other_specify
          kind: Question
          title: "Please specify why the child did not attend school last year."
          precondition:
            - predicate: q_b7_why_not.outcome == 5
          input:
            control: Textarea

        # B8: Last grade enrolled (only if B7 = 3, 4, or 5)
        # All responses route to B20 (skip school performance questions)
        - id: q_b8_last_grade
          kind: Question
          title: "In what grade was the child last enrolled?"
          precondition:
            - predicate: q_b7_why_not.outcome in [3, 4, 5]
          input:
            control: Dropdown
            labels:
              1: "Junior kindergarten"
              2: "Kindergarten"
              3: "Grade 1"
              4: "Grade 2"
              5: "Grade 3"
              6: "Grade 4"
              7: "Grade 5"
              8: "Grade 6"
              9: "Grade 7 (Quebec = Secondary 1)"
              10: "Grade 8 (Quebec = Secondary 2)"
              11: "Grade 9 (Quebec = Secondary 3)"
              12: "Grade 10 (Quebec = Secondary 4)"
              13: "Grade 11 (Quebec = Secondary 5)"
              14: "Grade 12"
              15: "OAC Grade 13 (Ontario)"
              16: "Ungraded"
              17: "CEGEP technical 1st year"
              18: "CEGEP technical 2nd year"
              19: "CEGEP technical 3rd year"
              20: "CEGEP academic 1st year"
              21: "CEGEP academic 2nd year"
              22: "CEGEP academic 3rd year"
              23: "University 1st year"
              24: "University 2nd year"
              25: "University 3rd year"
              26: "Apprenticeship 1st year"
              27: "Apprenticeship 2nd year"
              28: "Apprenticeship 3rd year"
              29: "Trades-technology 1st year"
              30: "Trades-technology 2nd year"
              31: "Trades-technology 3rd year"
              32: "Other"
              33: "N/A"
              97: "Don't know"
              98: "Refused"

        # B9: Grade enrolled last year (only if B6=Yes, i.e. attended school)
        # Jr K (1), K (2) -> skip to B20; Grades 1-13+Ungraded (3-16) -> B10;
        # Post-secondary (17-31) -> skip to B20; Other/NA/DK/R (32,33,97,98) -> B10
        - id: q_b9_grade_enrolled
          kind: Question
          title: "In what grade was the child enrolled last year?"
          precondition:
            - predicate: q_b6_attend.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Junior kindergarten"
              2: "Kindergarten"
              3: "Grade 1"
              4: "Grade 2"
              5: "Grade 3"
              6: "Grade 4"
              7: "Grade 5"
              8: "Grade 6"
              9: "Grade 7 (Quebec = Secondary 1)"
              10: "Grade 8 (Quebec = Secondary 2)"
              11: "Grade 9 (Quebec = Secondary 3)"
              12: "Grade 10 (Quebec = Secondary 4)"
              13: "Grade 11 (Quebec = Secondary 5)"
              14: "Grade 12"
              15: "OAC Grade 13 (Ontario)"
              16: "Ungraded"
              17: "CEGEP technical 1st year"
              18: "CEGEP technical 2nd year"
              19: "CEGEP technical 3rd year"
              20: "CEGEP academic 1st year"
              21: "CEGEP academic 2nd year"
              22: "CEGEP academic 3rd year"
              23: "University 1st year"
              24: "University 2nd year"
              25: "University 3rd year"
              26: "Apprenticeship 1st year"
              27: "Apprenticeship 2nd year"
              28: "Apprenticeship 3rd year"
              29: "Trades-technology 1st year"
              30: "Trades-technology 2nd year"
              31: "Trades-technology 3rd year"
              32: "Other"
              33: "N/A"
              97: "Don't know"
              98: "Refused"

        # B10: Overall school performance
        # Precondition: attended school (B6=1) AND grade is in the range that continues
        # (not Jr K=1, not K=2, not post-secondary 17-31)
        - id: q_b10_performance
          kind: Question
          title: "The next questions refer to the child's last school year. Based on your knowledge of the child's schoolwork, including report cards, how did he/she do overall in school?"
          precondition:
            - predicate: q_b6_attend.outcome == 1 and q_b9_grade_enrolled.outcome not in [1, 2, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
          input:
            control: Radio
            labels:
              1: "Above average"
              2: "Average"
              3: "Below average"
              7: "Don't know"
              8: "Refused"

        # B11: Feelings about schoolwork
        - id: q_b11_feelings
          kind: Question
          title: "How did the child feel about his/her schoolwork?"
          precondition:
            - predicate: q_b6_attend.outcome == 1 and q_b9_grade_enrolled.outcome not in [1, 2, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
          input:
            control: Radio
            labels:
              1: "Liked it very much"
              2: "Liked it"
              3: "Neither liked nor disliked it"
              4: "Disliked it"
              5: "Disliked it very much"
              7: "Don't know"
              8: "Refused"

        # B12: Friends' schoolwork
        - id: q_b12_friends
          kind: Question
          title: "Overall, did the child's close friends do well in their schoolwork?"
          precondition:
            - predicate: q_b6_attend.outcome == 1 and q_b9_grade_enrolled.outcome not in [1, 2, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B13: Teacher contact frequency
        - id: q_b13_teacher_contact
          kind: Question
          title: "How often were the child's parents/guardians in contact with his/her teachers to discuss his/her academic performance or behaviour?"
          precondition:
            - predicate: q_b6_attend.outcome == 1 and q_b9_grade_enrolled.outcome not in [1, 2, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
          input:
            control: Radio
            labels:
              1: "Often"
              2: "A few times"
              3: "Once"
              4: "Never"
              7: "Don't know"
              8: "Refused"

        # B14: Study place at home
        - id: q_b14_study_place
          kind: Question
          title: "Did the child's parents/guardians set aside a place in the home for him/her to use for studying or doing homework?"
          precondition:
            - predicate: q_b6_attend.outcome == 1 and q_b9_grade_enrolled.outcome not in [1, 2, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B15a: Sports/physical activities outside school
        - id: q_b15a_sports
          kind: Question
          title: "In a typical week during the last school year, how often did the child participate in organized activities not run by the school such as: Sports or physical activities like Little League, swim club or hockey league?"
          precondition:
            - predicate: q_b6_attend.outcome == 1 and q_b9_grade_enrolled.outcome not in [1, 2, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
          input:
            control: Radio
            labels:
              1: "More than once a week"
              2: "About once a week"
              3: "Less than once a week"
              4: "Never"
              7: "Don't know"
              8: "Refused"

        # B15b: Social club activities
        - id: q_b15b_social
          kind: Question
          title: "Social club activities like scouts, girl guides, boys and girls clubs or church groups?"
          precondition:
            - predicate: q_b6_attend.outcome == 1 and q_b9_grade_enrolled.outcome not in [1, 2, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
          input:
            control: Radio
            labels:
              1: "More than once a week"
              2: "About once a week"
              3: "Less than once a week"
              4: "Never"
              7: "Don't know"
              8: "Refused"

        # B15c: Cultural activities
        - id: q_b15c_cultural
          kind: Question
          title: "Cultural activities like music lessons, art lessons, dance lessons or drama lessons?"
          precondition:
            - predicate: q_b6_attend.outcome == 1 and q_b9_grade_enrolled.outcome not in [1, 2, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
          input:
            control: Radio
            labels:
              1: "More than once a week"
              2: "About once a week"
              3: "Less than once a week"
              4: "Never"
              7: "Don't know"
              8: "Refused"

        # B16: School-run organized activities
        - id: q_b16_school_activities
          kind: Question
          title: "In a typical week during the last school year, how often did the child participate in organized activities that were run by the school outside of school hours? This includes any activity such as sports teams, social clubs, music, band or school plays run by the school."
          precondition:
            - predicate: q_b6_attend.outcome == 1 and q_b9_grade_enrolled.outcome not in [1, 2, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
          input:
            control: Radio
            labels:
              1: "More than once a week"
              2: "About once a week"
              3: "Less than once a week"
              4: "Never"
              7: "Don't know"
              8: "Refused"

        # B17a: Praise for doing well
        - id: q_b17a_praise_well
          kind: Question
          title: "Using the categories very often, often, sometimes and never, how often did the child's parents/guardians: Praise the child if he/she did well in school?"
          precondition:
            - predicate: q_b6_attend.outcome == 1 and q_b9_grade_enrolled.outcome not in [1, 2, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
          input:
            control: Radio
            labels:
              1: "Very often"
              2: "Often"
              3: "Sometimes"
              4: "Never"
              7: "Don't know"
              8: "Refused"

        # B17b: Praise for trying
        - id: q_b17b_praise_try
          kind: Question
          title: "Praise the child for trying in school, even if he/she did not succeed?"
          precondition:
            - predicate: q_b6_attend.outcome == 1 and q_b9_grade_enrolled.outcome not in [1, 2, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
          input:
            control: Radio
            labels:
              1: "Very often"
              2: "Often"
              3: "Sometimes"
              4: "Never"
              7: "Don't know"
              8: "Refused"

        # B17c: Help with homework
        - id: q_b17c_help_homework
          kind: Question
          title: "Help the child with homework when he/she did not understand?"
          precondition:
            - predicate: q_b6_attend.outcome == 1 and q_b9_grade_enrolled.outcome not in [1, 2, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
          input:
            control: Radio
            labels:
              1: "Very often"
              2: "Often"
              3: "Sometimes"
              4: "Never"
              7: "Don't know"
              8: "Refused"

        # B17d: Remind to complete homework
        - id: q_b17d_remind_homework
          kind: Question
          title: "Remind the child to begin or complete homework?"
          precondition:
            - predicate: q_b6_attend.outcome == 1 and q_b9_grade_enrolled.outcome not in [1, 2, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
          input:
            control: Radio
            labels:
              1: "Very often"
              2: "Often"
              3: "Sometimes"
              4: "Never"
              7: "Don't know"
              8: "Refused"

        # B17e: Help plan time for homework
        - id: q_b17e_plan_time
          kind: Question
          title: "Help the child plan his/her time for getting homework done?"
          precondition:
            - predicate: q_b6_attend.outcome == 1 and q_b9_grade_enrolled.outcome not in [1, 2, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
          input:
            control: Radio
            labels:
              1: "Very often"
              2: "Often"
              3: "Sometimes"
              4: "Never"
              7: "Don't know"
              8: "Refused"

        # B17f: TV watching decisions
        - id: q_b17f_tv
          kind: Question
          title: "Decide how much television the child could watch on school days?"
          precondition:
            - predicate: q_b6_attend.outcome == 1 and q_b9_grade_enrolled.outcome not in [1, 2, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
          input:
            control: Radio
            labels:
              1: "Very often"
              2: "Often"
              3: "Sometimes"
              4: "Never"
              7: "Don't know"
              8: "Refused"

        # B17g: Remind about potential
        - id: q_b17g_potential
          kind: Question
          title: "Tell or remind the child that he/she was not working to his/her full potential or ability?"
          precondition:
            - predicate: q_b6_attend.outcome == 1 and q_b9_grade_enrolled.outcome not in [1, 2, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
          input:
            control: Radio
            labels:
              1: "Very often"
              2: "Often"
              3: "Sometimes"
              4: "Never"
              7: "Don't know"
              8: "Refused"

        # B18: Time spent on homework
        - id: q_b18_homework_time
          kind: Question
          title: "In general, how much time did the child spend doing homework?"
          precondition:
            - predicate: q_b6_attend.outcome == 1 and q_b9_grade_enrolled.outcome not in [1, 2, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
          input:
            control: Radio
            labels:
              1: "A lot"
              2: "A fair amount"
              3: "Very little"
              4: "None at all"
              7: "Don't know"
              8: "Refused"

        # B19: Leisure time with parents
        - id: q_b19_leisure
          kind: Question
          title: "How much leisure time did the child's parents/guardians usually spend with him/her in a week? Leisure time means doing things together like playing a game, going shopping together, or other activities."
          precondition:
            - predicate: q_b6_attend.outcome == 1 and q_b9_grade_enrolled.outcome not in [1, 2, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
          input:
            control: Radio
            labels:
              1: "A lot"
              2: "A fair amount"
              3: "Very little"
              4: "None at all"
              7: "Don't know"
              8: "Refused"

    # =========================================================================
    # BLOCK 3: PSE PLANNING (B20-B29)
    # =========================================================================
    # Planning for post-secondary education. All children get B20.
    # B22-B29 gated on having saved (B20=1) or planning to save (B21=1).
    # =========================================================================
    - id: b_child1_pse_planning
      title: "Child 1 - Planning for Post-Secondary Education"
      items:
        # B20: Ever saved for PSE?
        - id: q_b20_saved
          kind: Question
          title: "Now I'd like to ask you some questions about saving for the child's post-secondary education. Post-secondary education includes college and university as well as apprenticeships, trade-vocational programs, CEGEPs or any other type of formal education after high school. Have you or anyone else living in your household ever saved money for the child's post-secondary education?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Don't know"
              4: "Refused"

        # B21: Planning to save? (only if B20 != Yes)
        # B21 original codes: 5=Yes, 6=No, 7=DK, 8=R -> normalized to 1-4
        - id: q_b21_plan_save
          kind: Question
          title: "Are you or anyone else living in your household planning to save or pay for the child's post-secondary education?"
          precondition:
            - predicate: q_b20_saved.outcome != 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Don't know"
              4: "Refused"

        # B22: Expect child to live away from home?
        # Gated on: saved (B20=1) OR planning to save (B21=1)
        - id: q_b22_live_away
          kind: Question
          title: "If the child were to go on to post-secondary education, do his/her parents/guardians expect that he/she will live away from home?"
          precondition:
            - predicate: q_b20_saved.outcome == 1 or q_b21_plan_save.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B23: Cost if living away (only if B22=Yes)
        - id: q_b23_cost_away
          kind: Question
          title: "Assuming that the child lives away from home, how much do his/her parents/guardians expect that the total cost of his/her education and living expenses would be?"
          precondition:
            - predicate: q_b22_live_away.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 999999

        # B24: Cost if living at home (only if B22 != Yes)
        - id: q_b24_cost_home
          kind: Question
          title: "Assuming that the child lives at home, how much do his/her parents/guardians expect that the total cost of his/her education would be?"
          precondition:
            - predicate: "(q_b20_saved.outcome == 1 or q_b21_plan_save.outcome == 1) and q_b22_live_away.outcome != 1"
          input:
            control: Editbox
            min: 0
            max: 999999

        # B25a: Child will work before PSE?
        - id: q_b25a_work_before
          kind: Question
          title: "Do the child's parents/guardians expect that he/she will pay for any part of his/her education costs himself/herself in the following ways: He/she will work before starting his/her post-secondary studies? This includes part-time jobs while in high school."
          precondition:
            - predicate: q_b20_saved.outcome == 1 or q_b21_plan_save.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B25b: Child will work during PSE?
        - id: q_b25b_work_during
          kind: Question
          title: "He/she will work during his/her post-secondary studies? This includes part-time jobs, summer jobs or co-op work programs."
          precondition:
            - predicate: q_b20_saved.outcome == 1 or q_b21_plan_save.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B25c: Child will interrupt studies to work?
        - id: q_b25c_interrupt
          kind: Question
          title: "He/she will interrupt his/her studies to work?"
          precondition:
            - predicate: q_b20_saved.outcome == 1 or q_b21_plan_save.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B25d: Child will take out loans?
        - id: q_b25d_loans
          kind: Question
          title: "He/she will take out loans that will be repaid after his/her studies are finished?"
          precondition:
            - predicate: q_b20_saved.outcome == 1 or q_b21_plan_save.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B27a: Government student loans? (only if B25d=Yes, i.e. expects loans)
        - id: q_b27a_govt_loans
          kind: Question
          title: "Are the loans expected to be: Government student loans (federal or provincial)?"
          precondition:
            - predicate: q_b25d_loans.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B27b: Non-student loans from financial institution?
        - id: q_b27b_bank_loans
          kind: Question
          title: "Non-student loans from a financial institution (e.g. bank, trust company, credit union)?"
          precondition:
            - predicate: q_b25d_loans.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B27c: Loans from family/friends?
        - id: q_b27c_family_loans
          kind: Question
          title: "Loans from family or friends?"
          precondition:
            - predicate: q_b25d_loans.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B27d: Other loans?
        - id: q_b27d_other_loans
          kind: Question
          title: "Other loans?"
          precondition:
            - predicate: q_b25d_loans.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B28a: Parents will save/invest before PSE?
        - id: q_b28a_parent_savings
          kind: Question
          title: "Do the child's parents/guardians expect that they will pay for any part of his/her education costs in the following ways: Savings or investments they make before the child starts post-secondary studies?"
          precondition:
            - predicate: q_b20_saved.outcome == 1 or q_b21_plan_save.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B28b: Parents will pay from income during PSE?
        - id: q_b28b_parent_income
          kind: Question
          title: "Income they earn while the child is attending post-secondary?"
          precondition:
            - predicate: q_b20_saved.outcome == 1 or q_b21_plan_save.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B28c: Parents will take out loans?
        - id: q_b28c_parent_loans
          kind: Question
          title: "Loans they take out and pay back after the child finishes post-secondary studies? This does not include loans taken out by the child such as a student loan."
          precondition:
            - predicate: q_b20_saved.outcome == 1 or q_b21_plan_save.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B29a: Scholarships/awards?
        - id: q_b29a_scholarships
          kind: Question
          title: "Do the child's parents/guardians expect that any part of his/her post-secondary education will be paid for by the following sources? Scholarships or awards based on academic performance."
          precondition:
            - predicate: q_b20_saved.outcome == 1 or q_b21_plan_save.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B29b: Grants/bursaries?
        - id: q_b29b_grants
          kind: Question
          title: "Grants or bursaries based on financial need."
          precondition:
            - predicate: q_b20_saved.outcome == 1 or q_b21_plan_save.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B29c: Gifts/inheritances?
        - id: q_b29c_gifts
          kind: Question
          title: "Gifts or inheritances."
          precondition:
            - predicate: q_b20_saved.outcome == 1 or q_b21_plan_save.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

    # =========================================================================
    # BLOCK 4: SAVINGS DETAILS (B31-B41b)
    # =========================================================================
    # B30 filter: only if B20=Yes (actually saved). Otherwise skip to B42.
    # =========================================================================
    - id: b_child1_savings_details
      title: "Child 1 - Savings for Post-Secondary Education"
      precondition:
        - predicate: q_b20_saved.outcome == 1
      items:
        # B31: Age when savings started
        - id: q_b31_savings_start_age
          kind: Question
          title: "The following questions refer to savings that have been made for the child's post-secondary education by anyone living in your household, including the child. Do not include savings put aside by someone outside your household. How old was the child when these savings were first started?"
          input:
            control: Editbox
            min: 0
            max: 18

        # B32: Amount saved in 1998
        - id: q_b32_saved_1998
          kind: Question
          title: "How much money was saved for the child's post-secondary education in 1998? Do not include any earnings or interest."
          input:
            control: Editbox
            min: 0
            max: 999999

        # B33: Amount saved so far in 1999
        - id: q_b33_saved_1999
          kind: Question
          title: "How much money has been saved for the child's post-secondary education so far in 1999? Do not include any earnings or interest."
          input:
            control: Editbox
            min: 0
            max: 999999

        # B34: Amount to be saved rest of 1999
        - id: q_b34_save_rest_1999
          kind: Question
          title: "How much money will be saved for the child in the rest of 1999?"
          input:
            control: Editbox
            min: 0
            max: 999999

        # B35: Total saved since starting
        - id: q_b35_total_saved
          kind: Question
          title: "Since starting to save for the child, how much in total has been saved for his/her post-secondary education? Do not include any earnings or interest."
          input:
            control: Editbox
            min: 0
            max: 999999

        # B36: Expected total by PSE start
        - id: q_b36_expected_total
          kind: Question
          title: "How much do you expect to have saved for the child's education by the time he/she starts post-secondary studies? Include all earnings and interest."
          input:
            control: Editbox
            min: 0
            max: 999999

        # B37a: RESP savings plan?
        - id: q_b37a_resp
          kind: Question
          title: "What types of savings plans are being used to save for the child's post-secondary education? RESPs (Registered Education Savings Plans)?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B37b: RRSP savings plan?
        - id: q_b37b_rrsp
          kind: Question
          title: "RRSPs (Registered Retirement Savings Plans)?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B37c: In-trust-for accounts?
        - id: q_b37c_trust
          kind: Question
          title: "'In-trust for' accounts?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B37d: Other savings plan?
        # If ALL of B37a-d are No/DK/R -> skip to B42.
        # codeBlock computes has_savings_plan for downstream gating.
        - id: q_b37d_other_plan
          kind: Question
          title: "Other savings plan?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"
          codeBlock: |
            has_savings_plan = 0
            if q_b37a_resp.outcome == 1 or q_b37b_rrsp.outcome == 1 or q_b37c_trust.outcome == 1 or q_b37d_other_plan.outcome == 1:
                has_savings_plan = 1

        # B38a: Mutual funds?
        - id: q_b38a_mutual_funds
          kind: Question
          title: "Within these plans, how are the savings invested? Mutual funds?"
          precondition:
            - predicate: has_savings_plan == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B38b: Shares of corporations?
        - id: q_b38b_shares
          kind: Question
          title: "Shares of corporations?"
          precondition:
            - predicate: has_savings_plan == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B38c: Savings/chequing accounts?
        - id: q_b38c_savings_acct
          kind: Question
          title: "Savings or chequing accounts?"
          precondition:
            - predicate: has_savings_plan == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B38d: Savings bonds?
        - id: q_b38d_bonds
          kind: Question
          title: "Savings bonds?"
          precondition:
            - predicate: has_savings_plan == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B38e: Other investments?
        - id: q_b38e_other_invest
          kind: Question
          title: "Other investments?"
          precondition:
            - predicate: has_savings_plan == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B40: Total RESP contributions (only if B37a=Yes, i.e. has RESP)
        - id: q_b40_resp_total
          kind: Question
          title: "For the RESP only, how much money in total has been contributed to RESPs for the child by people living in your household?"
          precondition:
            - predicate: q_b37a_resp.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 999999

        # B41a: Individual RESP plan?
        - id: q_b41a_resp_individual
          kind: Question
          title: "Which types of RESPs are being used? Individual plan (includes individual non-family and family RESPs)?"
          precondition:
            - predicate: q_b37a_resp.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B41b: Group RESP plan?
        - id: q_b41b_resp_group
          kind: Question
          title: "Group plan (education scholarship trust or foundation)?"
          precondition:
            - predicate: q_b37a_resp.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

    # =========================================================================
    # BLOCK 5: OUTSIDE SAVINGS (B42-B43)
    # =========================================================================
    # Always shown regardless of previous savings answers.
    # =========================================================================
    - id: b_child1_outside_savings
      title: "Child 1 - Outside Household Savings"
      items:
        # B42: Outside household savings?
        - id: q_b42_outside
          kind: Question
          title: "Does anyone who does not live in your household have savings put aside for the child's post-secondary education?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B43: Amount of outside savings (only if B42=Yes)
        - id: q_b43_outside_amount
          kind: Question
          title: "How much money in total have the people who don't live in your household put aside for the child's post-secondary education?"
          precondition:
            - predicate: q_b42_outside.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 999999

    # ===================================================================
    # SECTION: child2
    # ===================================================================
    # =========================================================================
    # BLOCK 1: CHILD 2 DEMOGRAPHICS AND GENERAL QUESTIONS (B1-B3)
    # =========================================================================
    # Child info (sex, age), relationship, health, hopes for school.
    # Applies to all children regardless of age.
    # =========================================================================
    - id: b_child2_demographics
      title: "Child 2 - Demographics and General Questions"
      items:
        # Child 2 sex
        - id: q_c_child2_sex
          kind: Question
          title: "Sex of Child 2"
          input:
            control: Radio
            labels:
              1: "Male"
              2: "Female"

        # Child 2 age
        - id: q_c_child2_age
          kind: Question
          title: "Age of Child 2 (in years; if less than 1 year, enter 0)"
          input:
            control: Editbox
            min: 0
            max: 18

        # B1: Relationship to respondent
        - id: q_c1_relationship
          kind: Question
          title: "Now I am going to ask you some questions about Child 2. What is the child's relationship to you?"
          input:
            control: Radio
            labels:
              1: "Son/daughter (biological, adoptive, stepchild)"
              2: "Foster child"
              3: "Grandchild"
              4: "Brother/sister"
              5: "Other family member or relative"
              6: "Unrelated"

        # B2: Long-term health conditions
        - id: q_c2_health
          kind: Question
          title: "Does the child have any long-term conditions or health problems which prevent or limit his/her participation in school, at play, or in any other activity for a child of his/her age?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B3: Hopes for schooling
        - id: q_c3_hopes
          kind: Question
          title: "How far do the child's parents/guardians hope that he/she will go in school?"
          input:
            control: Radio
            labels:
              1: "Primary school"
              2: "Secondary or high school"
              3: "Community college, technical college or CEGEP"
              4: "University"
              5: "Learn a trade"
              7: "Don't know"
              8: "Refused"

    # =========================================================================
    # BLOCK 2: SCHOOL QUESTIONS (B5-B19)
    # =========================================================================
    # B4 filter: age 0-4 skip to B20; age 5-8 skip B5 go to B6; age 9+ get B5.
    # Block precondition: age >= 5 (children 0-4 skip entire block).
    # =========================================================================
    - id: b_child2_school
      title: "Child 2 - School Questions"
      precondition:
        - predicate: q_c_child2_age.outcome >= 5
      items:
        # B5: Expectations for schooling (age 9+ only)
        - id: q_c5_expect
          kind: Question
          title: "How far do the child's parents/guardians expect that he/she will go in school?"
          precondition:
            - predicate: q_c_child2_age.outcome >= 9
          input:
            control: Radio
            labels:
              1: "Primary school"
              2: "Secondary or high school"
              3: "Community college, technical college or CEGEP"
              4: "University"
              5: "Learn a trade"
              7: "Don't know"
              8: "Refused"

        # B6: Did child attend school last year?
        # DK/R route to B20 (skip rest of school block) - modeled via preconditions on downstream items
        - id: q_c6_attend
          kind: Question
          title: "Did the child attend school last year? (Include home schooling.)"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B7: Why not attend school? (only if B6=No)
        # Codes 1,2 -> B20; codes 3,4,5 -> B8
        - id: q_c7_why_not
          kind: Question
          title: "Why did the child not attend school last year?"
          precondition:
            - predicate: q_c6_attend.outcome == 2
          input:
            control: Radio
            labels:
              1: "Too young for school"
              2: "Physical, mental, emotional or behavioral problem"
              3: "Left school before graduating"
              4: "Graduated from school"
              5: "Other"

        # B7 specify: free text for "Other" (code 5)
        - id: q_c7_other_specify
          kind: Question
          title: "Please specify why the child did not attend school last year."
          precondition:
            - predicate: q_c7_why_not.outcome == 5
          input:
            control: Textarea

        # B8: Last grade enrolled (only if B7 = 3, 4, or 5)
        # All responses route to B20 (skip school performance questions)
        - id: q_c8_last_grade
          kind: Question
          title: "In what grade was the child last enrolled?"
          precondition:
            - predicate: q_c7_why_not.outcome in [3, 4, 5]
          input:
            control: Dropdown
            labels:
              1: "Junior kindergarten"
              2: "Kindergarten"
              3: "Grade 1"
              4: "Grade 2"
              5: "Grade 3"
              6: "Grade 4"
              7: "Grade 5"
              8: "Grade 6"
              9: "Grade 7 (Quebec = Secondary 1)"
              10: "Grade 8 (Quebec = Secondary 2)"
              11: "Grade 9 (Quebec = Secondary 3)"
              12: "Grade 10 (Quebec = Secondary 4)"
              13: "Grade 11 (Quebec = Secondary 5)"
              14: "Grade 12"
              15: "OAC Grade 13 (Ontario)"
              16: "Ungraded"
              17: "CEGEP technical 1st year"
              18: "CEGEP technical 2nd year"
              19: "CEGEP technical 3rd year"
              20: "CEGEP academic 1st year"
              21: "CEGEP academic 2nd year"
              22: "CEGEP academic 3rd year"
              23: "University 1st year"
              24: "University 2nd year"
              25: "University 3rd year"
              26: "Apprenticeship 1st year"
              27: "Apprenticeship 2nd year"
              28: "Apprenticeship 3rd year"
              29: "Trades-technology 1st year"
              30: "Trades-technology 2nd year"
              31: "Trades-technology 3rd year"
              32: "Other"
              33: "N/A"
              97: "Don't know"
              98: "Refused"

        # B9: Grade enrolled last year (only if B6=Yes, i.e. attended school)
        # Jr K (1), K (2) -> skip to B20; Grades 1-13+Ungraded (3-16) -> B10;
        # Post-secondary (17-31) -> skip to B20; Other/NA/DK/R (32,33,97,98) -> B10
        - id: q_c9_grade_enrolled
          kind: Question
          title: "In what grade was the child enrolled last year?"
          precondition:
            - predicate: q_c6_attend.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Junior kindergarten"
              2: "Kindergarten"
              3: "Grade 1"
              4: "Grade 2"
              5: "Grade 3"
              6: "Grade 4"
              7: "Grade 5"
              8: "Grade 6"
              9: "Grade 7 (Quebec = Secondary 1)"
              10: "Grade 8 (Quebec = Secondary 2)"
              11: "Grade 9 (Quebec = Secondary 3)"
              12: "Grade 10 (Quebec = Secondary 4)"
              13: "Grade 11 (Quebec = Secondary 5)"
              14: "Grade 12"
              15: "OAC Grade 13 (Ontario)"
              16: "Ungraded"
              17: "CEGEP technical 1st year"
              18: "CEGEP technical 2nd year"
              19: "CEGEP technical 3rd year"
              20: "CEGEP academic 1st year"
              21: "CEGEP academic 2nd year"
              22: "CEGEP academic 3rd year"
              23: "University 1st year"
              24: "University 2nd year"
              25: "University 3rd year"
              26: "Apprenticeship 1st year"
              27: "Apprenticeship 2nd year"
              28: "Apprenticeship 3rd year"
              29: "Trades-technology 1st year"
              30: "Trades-technology 2nd year"
              31: "Trades-technology 3rd year"
              32: "Other"
              33: "N/A"
              97: "Don't know"
              98: "Refused"

        # B10: Overall school performance
        # Precondition: attended school (B6=1) AND grade is in the range that continues
        # (not Jr K=1, not K=2, not post-secondary 17-31)
        - id: q_c10_performance
          kind: Question
          title: "The next questions refer to the child's last school year. Based on your knowledge of the child's schoolwork, including report cards, how did he/she do overall in school?"
          precondition:
            - predicate: q_c6_attend.outcome == 1 and q_c9_grade_enrolled.outcome not in [1, 2, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
          input:
            control: Radio
            labels:
              1: "Above average"
              2: "Average"
              3: "Below average"
              7: "Don't know"
              8: "Refused"

        # B11: Feelings about schoolwork
        - id: q_c11_feelings
          kind: Question
          title: "How did the child feel about his/her schoolwork?"
          precondition:
            - predicate: q_c6_attend.outcome == 1 and q_c9_grade_enrolled.outcome not in [1, 2, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
          input:
            control: Radio
            labels:
              1: "Liked it very much"
              2: "Liked it"
              3: "Neither liked nor disliked it"
              4: "Disliked it"
              5: "Disliked it very much"
              7: "Don't know"
              8: "Refused"

        # B12: Friends' schoolwork
        - id: q_c12_friends
          kind: Question
          title: "Overall, did the child's close friends do well in their schoolwork?"
          precondition:
            - predicate: q_c6_attend.outcome == 1 and q_c9_grade_enrolled.outcome not in [1, 2, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B13: Teacher contact frequency
        - id: q_c13_teacher_contact
          kind: Question
          title: "How often were the child's parents/guardians in contact with his/her teachers to discuss his/her academic performance or behaviour?"
          precondition:
            - predicate: q_c6_attend.outcome == 1 and q_c9_grade_enrolled.outcome not in [1, 2, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
          input:
            control: Radio
            labels:
              1: "Often"
              2: "A few times"
              3: "Once"
              4: "Never"
              7: "Don't know"
              8: "Refused"

        # B14: Study place at home
        - id: q_c14_study_place
          kind: Question
          title: "Did the child's parents/guardians set aside a place in the home for him/her to use for studying or doing homework?"
          precondition:
            - predicate: q_c6_attend.outcome == 1 and q_c9_grade_enrolled.outcome not in [1, 2, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B15a: Sports/physical activities outside school
        - id: q_c15a_sports
          kind: Question
          title: "In a typical week during the last school year, how often did the child participate in organized activities not run by the school such as: Sports or physical activities like Little League, swim club or hockey league?"
          precondition:
            - predicate: q_c6_attend.outcome == 1 and q_c9_grade_enrolled.outcome not in [1, 2, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
          input:
            control: Radio
            labels:
              1: "More than once a week"
              2: "About once a week"
              3: "Less than once a week"
              4: "Never"
              7: "Don't know"
              8: "Refused"

        # B15b: Social club activities
        - id: q_c15b_social
          kind: Question
          title: "Social club activities like scouts, girl guides, boys and girls clubs or church groups?"
          precondition:
            - predicate: q_c6_attend.outcome == 1 and q_c9_grade_enrolled.outcome not in [1, 2, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
          input:
            control: Radio
            labels:
              1: "More than once a week"
              2: "About once a week"
              3: "Less than once a week"
              4: "Never"
              7: "Don't know"
              8: "Refused"

        # B15c: Cultural activities
        - id: q_c15c_cultural
          kind: Question
          title: "Cultural activities like music lessons, art lessons, dance lessons or drama lessons?"
          precondition:
            - predicate: q_c6_attend.outcome == 1 and q_c9_grade_enrolled.outcome not in [1, 2, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
          input:
            control: Radio
            labels:
              1: "More than once a week"
              2: "About once a week"
              3: "Less than once a week"
              4: "Never"
              7: "Don't know"
              8: "Refused"

        # B16: School-run organized activities
        - id: q_c16_school_activities
          kind: Question
          title: "In a typical week during the last school year, how often did the child participate in organized activities that were run by the school outside of school hours? This includes any activity such as sports teams, social clubs, music, band or school plays run by the school."
          precondition:
            - predicate: q_c6_attend.outcome == 1 and q_c9_grade_enrolled.outcome not in [1, 2, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
          input:
            control: Radio
            labels:
              1: "More than once a week"
              2: "About once a week"
              3: "Less than once a week"
              4: "Never"
              7: "Don't know"
              8: "Refused"

        # B17a: Praise for doing well
        - id: q_c17a_praise_well
          kind: Question
          title: "Using the categories very often, often, sometimes and never, how often did the child's parents/guardians: Praise the child if he/she did well in school?"
          precondition:
            - predicate: q_c6_attend.outcome == 1 and q_c9_grade_enrolled.outcome not in [1, 2, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
          input:
            control: Radio
            labels:
              1: "Very often"
              2: "Often"
              3: "Sometimes"
              4: "Never"
              7: "Don't know"
              8: "Refused"

        # B17b: Praise for trying
        - id: q_c17b_praise_try
          kind: Question
          title: "Praise the child for trying in school, even if he/she did not succeed?"
          precondition:
            - predicate: q_c6_attend.outcome == 1 and q_c9_grade_enrolled.outcome not in [1, 2, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
          input:
            control: Radio
            labels:
              1: "Very often"
              2: "Often"
              3: "Sometimes"
              4: "Never"
              7: "Don't know"
              8: "Refused"

        # B17c: Help with homework
        - id: q_c17c_help_homework
          kind: Question
          title: "Help the child with homework when he/she did not understand?"
          precondition:
            - predicate: q_c6_attend.outcome == 1 and q_c9_grade_enrolled.outcome not in [1, 2, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
          input:
            control: Radio
            labels:
              1: "Very often"
              2: "Often"
              3: "Sometimes"
              4: "Never"
              7: "Don't know"
              8: "Refused"

        # B17d: Remind to complete homework
        - id: q_c17d_remind_homework
          kind: Question
          title: "Remind the child to begin or complete homework?"
          precondition:
            - predicate: q_c6_attend.outcome == 1 and q_c9_grade_enrolled.outcome not in [1, 2, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
          input:
            control: Radio
            labels:
              1: "Very often"
              2: "Often"
              3: "Sometimes"
              4: "Never"
              7: "Don't know"
              8: "Refused"

        # B17e: Help plan time for homework
        - id: q_c17e_plan_time
          kind: Question
          title: "Help the child plan his/her time for getting homework done?"
          precondition:
            - predicate: q_c6_attend.outcome == 1 and q_c9_grade_enrolled.outcome not in [1, 2, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
          input:
            control: Radio
            labels:
              1: "Very often"
              2: "Often"
              3: "Sometimes"
              4: "Never"
              7: "Don't know"
              8: "Refused"

        # B17f: TV watching decisions
        - id: q_c17f_tv
          kind: Question
          title: "Decide how much television the child could watch on school days?"
          precondition:
            - predicate: q_c6_attend.outcome == 1 and q_c9_grade_enrolled.outcome not in [1, 2, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
          input:
            control: Radio
            labels:
              1: "Very often"
              2: "Often"
              3: "Sometimes"
              4: "Never"
              7: "Don't know"
              8: "Refused"

        # B17g: Remind about potential
        - id: q_c17g_potential
          kind: Question
          title: "Tell or remind the child that he/she was not working to his/her full potential or ability?"
          precondition:
            - predicate: q_c6_attend.outcome == 1 and q_c9_grade_enrolled.outcome not in [1, 2, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
          input:
            control: Radio
            labels:
              1: "Very often"
              2: "Often"
              3: "Sometimes"
              4: "Never"
              7: "Don't know"
              8: "Refused"

        # B18: Time spent on homework
        - id: q_c18_homework_time
          kind: Question
          title: "In general, how much time did the child spend doing homework?"
          precondition:
            - predicate: q_c6_attend.outcome == 1 and q_c9_grade_enrolled.outcome not in [1, 2, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
          input:
            control: Radio
            labels:
              1: "A lot"
              2: "A fair amount"
              3: "Very little"
              4: "None at all"
              7: "Don't know"
              8: "Refused"

        # B19: Leisure time with parents
        - id: q_c19_leisure
          kind: Question
          title: "How much leisure time did the child's parents/guardians usually spend with him/her in a week? Leisure time means doing things together like playing a game, going shopping together, or other activities."
          precondition:
            - predicate: q_c6_attend.outcome == 1 and q_c9_grade_enrolled.outcome not in [1, 2, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
          input:
            control: Radio
            labels:
              1: "A lot"
              2: "A fair amount"
              3: "Very little"
              4: "None at all"
              7: "Don't know"
              8: "Refused"

    # =========================================================================
    # BLOCK 3: PSE PLANNING (B20-B29)
    # =========================================================================
    # Planning for post-secondary education. All children get B20.
    # B22-B29 gated on having saved (B20=1) or planning to save (B21=1).
    # =========================================================================
    - id: b_child2_pse_planning
      title: "Child 2 - Planning for Post-Secondary Education"
      items:
        # B20: Ever saved for PSE?
        - id: q_c20_saved
          kind: Question
          title: "Now I'd like to ask you some questions about saving for the child's post-secondary education. Post-secondary education includes college and university as well as apprenticeships, trade-vocational programs, CEGEPs or any other type of formal education after high school. Have you or anyone else living in your household ever saved money for the child's post-secondary education?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Don't know"
              4: "Refused"

        # B21: Planning to save? (only if B20 != Yes)
        # B21 original codes: 5=Yes, 6=No, 7=DK, 8=R -> normalized to 1-4
        - id: q_c21_plan_save
          kind: Question
          title: "Are you or anyone else living in your household planning to save or pay for the child's post-secondary education?"
          precondition:
            - predicate: q_c20_saved.outcome != 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Don't know"
              4: "Refused"

        # B22: Expect child to live away from home?
        # Gated on: saved (B20=1) OR planning to save (B21=1)
        - id: q_c22_live_away
          kind: Question
          title: "If the child were to go on to post-secondary education, do his/her parents/guardians expect that he/she will live away from home?"
          precondition:
            - predicate: q_c20_saved.outcome == 1 or q_c21_plan_save.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B23: Cost if living away (only if B22=Yes)
        - id: q_c23_cost_away
          kind: Question
          title: "Assuming that the child lives away from home, how much do his/her parents/guardians expect that the total cost of his/her education and living expenses would be?"
          precondition:
            - predicate: q_c22_live_away.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 999999

        # B24: Cost if living at home (only if B22 != Yes)
        - id: q_c24_cost_home
          kind: Question
          title: "Assuming that the child lives at home, how much do his/her parents/guardians expect that the total cost of his/her education would be?"
          precondition:
            - predicate: "(q_c20_saved.outcome == 1 or q_c21_plan_save.outcome == 1) and q_c22_live_away.outcome != 1"
          input:
            control: Editbox
            min: 0
            max: 999999

        # B25a: Child will work before PSE?
        - id: q_c25a_work_before
          kind: Question
          title: "Do the child's parents/guardians expect that he/she will pay for any part of his/her education costs himself/herself in the following ways: He/she will work before starting his/her post-secondary studies? This includes part-time jobs while in high school."
          precondition:
            - predicate: q_c20_saved.outcome == 1 or q_c21_plan_save.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B25b: Child will work during PSE?
        - id: q_c25b_work_during
          kind: Question
          title: "He/she will work during his/her post-secondary studies? This includes part-time jobs, summer jobs or co-op work programs."
          precondition:
            - predicate: q_c20_saved.outcome == 1 or q_c21_plan_save.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B25c: Child will interrupt studies to work?
        - id: q_c25c_interrupt
          kind: Question
          title: "He/she will interrupt his/her studies to work?"
          precondition:
            - predicate: q_c20_saved.outcome == 1 or q_c21_plan_save.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B25d: Child will take out loans?
        - id: q_c25d_loans
          kind: Question
          title: "He/she will take out loans that will be repaid after his/her studies are finished?"
          precondition:
            - predicate: q_c20_saved.outcome == 1 or q_c21_plan_save.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B27a: Government student loans? (only if B25d=Yes, i.e. expects loans)
        - id: q_c27a_govt_loans
          kind: Question
          title: "Are the loans expected to be: Government student loans (federal or provincial)?"
          precondition:
            - predicate: q_c25d_loans.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B27b: Non-student loans from financial institution?
        - id: q_c27b_bank_loans
          kind: Question
          title: "Non-student loans from a financial institution (e.g. bank, trust company, credit union)?"
          precondition:
            - predicate: q_c25d_loans.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B27c: Loans from family/friends?
        - id: q_c27c_family_loans
          kind: Question
          title: "Loans from family or friends?"
          precondition:
            - predicate: q_c25d_loans.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B27d: Other loans?
        - id: q_c27d_other_loans
          kind: Question
          title: "Other loans?"
          precondition:
            - predicate: q_c25d_loans.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B28a: Parents will save/invest before PSE?
        - id: q_c28a_parent_savings
          kind: Question
          title: "Do the child's parents/guardians expect that they will pay for any part of his/her education costs in the following ways: Savings or investments they make before the child starts post-secondary studies?"
          precondition:
            - predicate: q_c20_saved.outcome == 1 or q_c21_plan_save.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B28b: Parents will pay from income during PSE?
        - id: q_c28b_parent_income
          kind: Question
          title: "Income they earn while the child is attending post-secondary?"
          precondition:
            - predicate: q_c20_saved.outcome == 1 or q_c21_plan_save.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B28c: Parents will take out loans?
        - id: q_c28c_parent_loans
          kind: Question
          title: "Loans they take out and pay back after the child finishes post-secondary studies? This does not include loans taken out by the child such as a student loan."
          precondition:
            - predicate: q_c20_saved.outcome == 1 or q_c21_plan_save.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B29a: Scholarships/awards?
        - id: q_c29a_scholarships
          kind: Question
          title: "Do the child's parents/guardians expect that any part of his/her post-secondary education will be paid for by the following sources? Scholarships or awards based on academic performance."
          precondition:
            - predicate: q_c20_saved.outcome == 1 or q_c21_plan_save.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B29b: Grants/bursaries?
        - id: q_c29b_grants
          kind: Question
          title: "Grants or bursaries based on financial need."
          precondition:
            - predicate: q_c20_saved.outcome == 1 or q_c21_plan_save.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B29c: Gifts/inheritances?
        - id: q_c29c_gifts
          kind: Question
          title: "Gifts or inheritances."
          precondition:
            - predicate: q_c20_saved.outcome == 1 or q_c21_plan_save.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

    # =========================================================================
    # BLOCK 4: SAVINGS DETAILS (B31-B41b)
    # =========================================================================
    # B30 filter: only if B20=Yes (actually saved). Otherwise skip to B42.
    # =========================================================================
    - id: b_child2_savings_details
      title: "Child 2 - Savings for Post-Secondary Education"
      precondition:
        - predicate: q_c20_saved.outcome == 1
      items:
        # B31: Age when savings started
        - id: q_c31_savings_start_age
          kind: Question
          title: "The following questions refer to savings that have been made for the child's post-secondary education by anyone living in your household, including the child. Do not include savings put aside by someone outside your household. How old was the child when these savings were first started?"
          input:
            control: Editbox
            min: 0
            max: 18

        # B32: Amount saved in 1998
        - id: q_c32_saved_1998
          kind: Question
          title: "How much money was saved for the child's post-secondary education in 1998? Do not include any earnings or interest."
          input:
            control: Editbox
            min: 0
            max: 999999

        # B33: Amount saved so far in 1999
        - id: q_c33_saved_1999
          kind: Question
          title: "How much money has been saved for the child's post-secondary education so far in 1999? Do not include any earnings or interest."
          input:
            control: Editbox
            min: 0
            max: 999999

        # B34: Amount to be saved rest of 1999
        - id: q_c34_save_rest_1999
          kind: Question
          title: "How much money will be saved for the child in the rest of 1999?"
          input:
            control: Editbox
            min: 0
            max: 999999

        # B35: Total saved since starting
        - id: q_c35_total_saved
          kind: Question
          title: "Since starting to save for the child, how much in total has been saved for his/her post-secondary education? Do not include any earnings or interest."
          input:
            control: Editbox
            min: 0
            max: 999999

        # B36: Expected total by PSE start
        - id: q_c36_expected_total
          kind: Question
          title: "How much do you expect to have saved for the child's education by the time he/she starts post-secondary studies? Include all earnings and interest."
          input:
            control: Editbox
            min: 0
            max: 999999

        # B37a: RESP savings plan?
        - id: q_c37a_resp
          kind: Question
          title: "What types of savings plans are being used to save for the child's post-secondary education? RESPs (Registered Education Savings Plans)?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B37b: RRSP savings plan?
        - id: q_c37b_rrsp
          kind: Question
          title: "RRSPs (Registered Retirement Savings Plans)?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B37c: In-trust-for accounts?
        - id: q_c37c_trust
          kind: Question
          title: "'In-trust for' accounts?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B37d: Other savings plan?
        # If ALL of B37a-d are No/DK/R -> skip to B42.
        # codeBlock computes has_savings_plan for downstream gating.
        - id: q_c37d_other_plan
          kind: Question
          title: "Other savings plan?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"
          codeBlock: |
            has_savings_plan = 0
            if q_c37a_resp.outcome == 1 or q_c37b_rrsp.outcome == 1 or q_c37c_trust.outcome == 1 or q_c37d_other_plan.outcome == 1:
                has_savings_plan = 1

        # B38a: Mutual funds?
        - id: q_c38a_mutual_funds
          kind: Question
          title: "Within these plans, how are the savings invested? Mutual funds?"
          precondition:
            - predicate: has_savings_plan == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B38b: Shares of corporations?
        - id: q_c38b_shares
          kind: Question
          title: "Shares of corporations?"
          precondition:
            - predicate: has_savings_plan == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B38c: Savings/chequing accounts?
        - id: q_c38c_savings_acct
          kind: Question
          title: "Savings or chequing accounts?"
          precondition:
            - predicate: has_savings_plan == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B38d: Savings bonds?
        - id: q_c38d_bonds
          kind: Question
          title: "Savings bonds?"
          precondition:
            - predicate: has_savings_plan == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B38e: Other investments?
        - id: q_c38e_other_invest
          kind: Question
          title: "Other investments?"
          precondition:
            - predicate: has_savings_plan == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B40: Total RESP contributions (only if B37a=Yes, i.e. has RESP)
        - id: q_c40_resp_total
          kind: Question
          title: "For the RESP only, how much money in total has been contributed to RESPs for the child by people living in your household?"
          precondition:
            - predicate: q_c37a_resp.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 999999

        # B41a: Individual RESP plan?
        - id: q_c41a_resp_individual
          kind: Question
          title: "Which types of RESPs are being used? Individual plan (includes individual non-family and family RESPs)?"
          precondition:
            - predicate: q_c37a_resp.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B41b: Group RESP plan?
        - id: q_c41b_resp_group
          kind: Question
          title: "Group plan (education scholarship trust or foundation)?"
          precondition:
            - predicate: q_c37a_resp.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

    # =========================================================================
    # BLOCK 5: OUTSIDE SAVINGS (B42-B43)
    # =========================================================================
    # Always shown regardless of previous savings answers.
    # =========================================================================
    - id: b_child2_outside_savings
      title: "Child 2 - Outside Household Savings"
      items:
        # B42: Outside household savings?
        - id: q_c42_outside
          kind: Question
          title: "Does anyone who does not live in your household have savings put aside for the child's post-secondary education?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B43: Amount of outside savings (only if B42=Yes)
        - id: q_c43_outside_amount
          kind: Question
          title: "How much money in total have the people who don't live in your household put aside for the child's post-secondary education?"
          precondition:
            - predicate: q_c42_outside.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 999999

    # ===================================================================
    # SECTION: child3
    # ===================================================================
    # =========================================================================
    # BLOCK 1: CHILD 3 DEMOGRAPHICS AND GENERAL QUESTIONS (B1-B3)
    # =========================================================================
    # Child info (sex, age), relationship, health, hopes for school.
    # Applies to all children regardless of age.
    # =========================================================================
    - id: b_child3_demographics
      title: "Child 3 - Demographics and General Questions"
      items:
        # Child 3 sex
        - id: q_d_child3_sex
          kind: Question
          title: "Sex of Child 3"
          input:
            control: Radio
            labels:
              1: "Male"
              2: "Female"

        # Child 3 age
        - id: q_d_child3_age
          kind: Question
          title: "Age of Child 3 (in years; if less than 1 year, enter 0)"
          input:
            control: Editbox
            min: 0
            max: 18

        # B1: Relationship to respondent
        - id: q_d1_relationship
          kind: Question
          title: "Now I am going to ask you some questions about Child 3. What is the child's relationship to you?"
          input:
            control: Radio
            labels:
              1: "Son/daughter (biological, adoptive, stepchild)"
              2: "Foster child"
              3: "Grandchild"
              4: "Brother/sister"
              5: "Other family member or relative"
              6: "Unrelated"

        # B2: Long-term health conditions
        - id: q_d2_health
          kind: Question
          title: "Does the child have any long-term conditions or health problems which prevent or limit his/her participation in school, at play, or in any other activity for a child of his/her age?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B3: Hopes for schooling
        - id: q_d3_hopes
          kind: Question
          title: "How far do the child's parents/guardians hope that he/she will go in school?"
          input:
            control: Radio
            labels:
              1: "Primary school"
              2: "Secondary or high school"
              3: "Community college, technical college or CEGEP"
              4: "University"
              5: "Learn a trade"
              7: "Don't know"
              8: "Refused"

    # =========================================================================
    # BLOCK 2: SCHOOL QUESTIONS (B5-B19)
    # =========================================================================
    # B4 filter: age 0-4 skip to B20; age 5-8 skip B5 go to B6; age 9+ get B5.
    # Block precondition: age >= 5 (children 0-4 skip entire block).
    # =========================================================================
    - id: b_child3_school
      title: "Child 3 - School Questions"
      precondition:
        - predicate: q_d_child3_age.outcome >= 5
      items:
        # B5: Expectations for schooling (age 9+ only)
        - id: q_d5_expect
          kind: Question
          title: "How far do the child's parents/guardians expect that he/she will go in school?"
          precondition:
            - predicate: q_d_child3_age.outcome >= 9
          input:
            control: Radio
            labels:
              1: "Primary school"
              2: "Secondary or high school"
              3: "Community college, technical college or CEGEP"
              4: "University"
              5: "Learn a trade"
              7: "Don't know"
              8: "Refused"

        # B6: Did child attend school last year?
        # DK/R route to B20 (skip rest of school block) - modeled via preconditions on downstream items
        - id: q_d6_attend
          kind: Question
          title: "Did the child attend school last year? (Include home schooling.)"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B7: Why not attend school? (only if B6=No)
        # Codes 1,2 -> B20; codes 3,4,5 -> B8
        - id: q_d7_why_not
          kind: Question
          title: "Why did the child not attend school last year?"
          precondition:
            - predicate: q_d6_attend.outcome == 2
          input:
            control: Radio
            labels:
              1: "Too young for school"
              2: "Physical, mental, emotional or behavioral problem"
              3: "Left school before graduating"
              4: "Graduated from school"
              5: "Other"

        # B7 specify: free text for "Other" (code 5)
        - id: q_d7_other_specify
          kind: Question
          title: "Please specify why the child did not attend school last year."
          precondition:
            - predicate: q_d7_why_not.outcome == 5
          input:
            control: Textarea

        # B8: Last grade enrolled (only if B7 = 3, 4, or 5)
        # All responses route to B20 (skip school performance questions)
        - id: q_d8_last_grade
          kind: Question
          title: "In what grade was the child last enrolled?"
          precondition:
            - predicate: q_d7_why_not.outcome in [3, 4, 5]
          input:
            control: Dropdown
            labels:
              1: "Junior kindergarten"
              2: "Kindergarten"
              3: "Grade 1"
              4: "Grade 2"
              5: "Grade 3"
              6: "Grade 4"
              7: "Grade 5"
              8: "Grade 6"
              9: "Grade 7 (Quebec = Secondary 1)"
              10: "Grade 8 (Quebec = Secondary 2)"
              11: "Grade 9 (Quebec = Secondary 3)"
              12: "Grade 10 (Quebec = Secondary 4)"
              13: "Grade 11 (Quebec = Secondary 5)"
              14: "Grade 12"
              15: "OAC Grade 13 (Ontario)"
              16: "Ungraded"
              17: "CEGEP technical 1st year"
              18: "CEGEP technical 2nd year"
              19: "CEGEP technical 3rd year"
              20: "CEGEP academic 1st year"
              21: "CEGEP academic 2nd year"
              22: "CEGEP academic 3rd year"
              23: "University 1st year"
              24: "University 2nd year"
              25: "University 3rd year"
              26: "Apprenticeship 1st year"
              27: "Apprenticeship 2nd year"
              28: "Apprenticeship 3rd year"
              29: "Trades-technology 1st year"
              30: "Trades-technology 2nd year"
              31: "Trades-technology 3rd year"
              32: "Other"
              33: "N/A"
              97: "Don't know"
              98: "Refused"

        # B9: Grade enrolled last year (only if B6=Yes, i.e. attended school)
        # Jr K (1), K (2) -> skip to B20; Grades 1-13+Ungraded (3-16) -> B10;
        # Post-secondary (17-31) -> skip to B20; Other/NA/DK/R (32,33,97,98) -> B10
        - id: q_d9_grade_enrolled
          kind: Question
          title: "In what grade was the child enrolled last year?"
          precondition:
            - predicate: q_d6_attend.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Junior kindergarten"
              2: "Kindergarten"
              3: "Grade 1"
              4: "Grade 2"
              5: "Grade 3"
              6: "Grade 4"
              7: "Grade 5"
              8: "Grade 6"
              9: "Grade 7 (Quebec = Secondary 1)"
              10: "Grade 8 (Quebec = Secondary 2)"
              11: "Grade 9 (Quebec = Secondary 3)"
              12: "Grade 10 (Quebec = Secondary 4)"
              13: "Grade 11 (Quebec = Secondary 5)"
              14: "Grade 12"
              15: "OAC Grade 13 (Ontario)"
              16: "Ungraded"
              17: "CEGEP technical 1st year"
              18: "CEGEP technical 2nd year"
              19: "CEGEP technical 3rd year"
              20: "CEGEP academic 1st year"
              21: "CEGEP academic 2nd year"
              22: "CEGEP academic 3rd year"
              23: "University 1st year"
              24: "University 2nd year"
              25: "University 3rd year"
              26: "Apprenticeship 1st year"
              27: "Apprenticeship 2nd year"
              28: "Apprenticeship 3rd year"
              29: "Trades-technology 1st year"
              30: "Trades-technology 2nd year"
              31: "Trades-technology 3rd year"
              32: "Other"
              33: "N/A"
              97: "Don't know"
              98: "Refused"

        # B10: Overall school performance
        # Precondition: attended school (B6=1) AND grade is in the range that continues
        # (not Jr K=1, not K=2, not post-secondary 17-31)
        - id: q_d10_performance
          kind: Question
          title: "The next questions refer to the child's last school year. Based on your knowledge of the child's schoolwork, including report cards, how did he/she do overall in school?"
          precondition:
            - predicate: q_d6_attend.outcome == 1 and q_d9_grade_enrolled.outcome not in [1, 2, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
          input:
            control: Radio
            labels:
              1: "Above average"
              2: "Average"
              3: "Below average"
              7: "Don't know"
              8: "Refused"

        # B11: Feelings about schoolwork
        - id: q_d11_feelings
          kind: Question
          title: "How did the child feel about his/her schoolwork?"
          precondition:
            - predicate: q_d6_attend.outcome == 1 and q_d9_grade_enrolled.outcome not in [1, 2, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
          input:
            control: Radio
            labels:
              1: "Liked it very much"
              2: "Liked it"
              3: "Neither liked nor disliked it"
              4: "Disliked it"
              5: "Disliked it very much"
              7: "Don't know"
              8: "Refused"

        # B12: Friends' schoolwork
        - id: q_d12_friends
          kind: Question
          title: "Overall, did the child's close friends do well in their schoolwork?"
          precondition:
            - predicate: q_d6_attend.outcome == 1 and q_d9_grade_enrolled.outcome not in [1, 2, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B13: Teacher contact frequency
        - id: q_d13_teacher_contact
          kind: Question
          title: "How often were the child's parents/guardians in contact with his/her teachers to discuss his/her academic performance or behaviour?"
          precondition:
            - predicate: q_d6_attend.outcome == 1 and q_d9_grade_enrolled.outcome not in [1, 2, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
          input:
            control: Radio
            labels:
              1: "Often"
              2: "A few times"
              3: "Once"
              4: "Never"
              7: "Don't know"
              8: "Refused"

        # B14: Study place at home
        - id: q_d14_study_place
          kind: Question
          title: "Did the child's parents/guardians set aside a place in the home for him/her to use for studying or doing homework?"
          precondition:
            - predicate: q_d6_attend.outcome == 1 and q_d9_grade_enrolled.outcome not in [1, 2, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B15a: Sports/physical activities outside school
        - id: q_d15a_sports
          kind: Question
          title: "In a typical week during the last school year, how often did the child participate in organized activities not run by the school such as: Sports or physical activities like Little League, swim club or hockey league?"
          precondition:
            - predicate: q_d6_attend.outcome == 1 and q_d9_grade_enrolled.outcome not in [1, 2, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
          input:
            control: Radio
            labels:
              1: "More than once a week"
              2: "About once a week"
              3: "Less than once a week"
              4: "Never"
              7: "Don't know"
              8: "Refused"

        # B15b: Social club activities
        - id: q_d15b_social
          kind: Question
          title: "Social club activities like scouts, girl guides, boys and girls clubs or church groups?"
          precondition:
            - predicate: q_d6_attend.outcome == 1 and q_d9_grade_enrolled.outcome not in [1, 2, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
          input:
            control: Radio
            labels:
              1: "More than once a week"
              2: "About once a week"
              3: "Less than once a week"
              4: "Never"
              7: "Don't know"
              8: "Refused"

        # B15c: Cultural activities
        - id: q_d15c_cultural
          kind: Question
          title: "Cultural activities like music lessons, art lessons, dance lessons or drama lessons?"
          precondition:
            - predicate: q_d6_attend.outcome == 1 and q_d9_grade_enrolled.outcome not in [1, 2, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
          input:
            control: Radio
            labels:
              1: "More than once a week"
              2: "About once a week"
              3: "Less than once a week"
              4: "Never"
              7: "Don't know"
              8: "Refused"

        # B16: School-run organized activities
        - id: q_d16_school_activities
          kind: Question
          title: "In a typical week during the last school year, how often did the child participate in organized activities that were run by the school outside of school hours? This includes any activity such as sports teams, social clubs, music, band or school plays run by the school."
          precondition:
            - predicate: q_d6_attend.outcome == 1 and q_d9_grade_enrolled.outcome not in [1, 2, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
          input:
            control: Radio
            labels:
              1: "More than once a week"
              2: "About once a week"
              3: "Less than once a week"
              4: "Never"
              7: "Don't know"
              8: "Refused"

        # B17a: Praise for doing well
        - id: q_d17a_praise_well
          kind: Question
          title: "Using the categories very often, often, sometimes and never, how often did the child's parents/guardians: Praise the child if he/she did well in school?"
          precondition:
            - predicate: q_d6_attend.outcome == 1 and q_d9_grade_enrolled.outcome not in [1, 2, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
          input:
            control: Radio
            labels:
              1: "Very often"
              2: "Often"
              3: "Sometimes"
              4: "Never"
              7: "Don't know"
              8: "Refused"

        # B17b: Praise for trying
        - id: q_d17b_praise_try
          kind: Question
          title: "Praise the child for trying in school, even if he/she did not succeed?"
          precondition:
            - predicate: q_d6_attend.outcome == 1 and q_d9_grade_enrolled.outcome not in [1, 2, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
          input:
            control: Radio
            labels:
              1: "Very often"
              2: "Often"
              3: "Sometimes"
              4: "Never"
              7: "Don't know"
              8: "Refused"

        # B17c: Help with homework
        - id: q_d17c_help_homework
          kind: Question
          title: "Help the child with homework when he/she did not understand?"
          precondition:
            - predicate: q_d6_attend.outcome == 1 and q_d9_grade_enrolled.outcome not in [1, 2, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
          input:
            control: Radio
            labels:
              1: "Very often"
              2: "Often"
              3: "Sometimes"
              4: "Never"
              7: "Don't know"
              8: "Refused"

        # B17d: Remind to complete homework
        - id: q_d17d_remind_homework
          kind: Question
          title: "Remind the child to begin or complete homework?"
          precondition:
            - predicate: q_d6_attend.outcome == 1 and q_d9_grade_enrolled.outcome not in [1, 2, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
          input:
            control: Radio
            labels:
              1: "Very often"
              2: "Often"
              3: "Sometimes"
              4: "Never"
              7: "Don't know"
              8: "Refused"

        # B17e: Help plan time for homework
        - id: q_d17e_plan_time
          kind: Question
          title: "Help the child plan his/her time for getting homework done?"
          precondition:
            - predicate: q_d6_attend.outcome == 1 and q_d9_grade_enrolled.outcome not in [1, 2, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
          input:
            control: Radio
            labels:
              1: "Very often"
              2: "Often"
              3: "Sometimes"
              4: "Never"
              7: "Don't know"
              8: "Refused"

        # B17f: TV watching decisions
        - id: q_d17f_tv
          kind: Question
          title: "Decide how much television the child could watch on school days?"
          precondition:
            - predicate: q_d6_attend.outcome == 1 and q_d9_grade_enrolled.outcome not in [1, 2, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
          input:
            control: Radio
            labels:
              1: "Very often"
              2: "Often"
              3: "Sometimes"
              4: "Never"
              7: "Don't know"
              8: "Refused"

        # B17g: Remind about potential
        - id: q_d17g_potential
          kind: Question
          title: "Tell or remind the child that he/she was not working to his/her full potential or ability?"
          precondition:
            - predicate: q_d6_attend.outcome == 1 and q_d9_grade_enrolled.outcome not in [1, 2, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
          input:
            control: Radio
            labels:
              1: "Very often"
              2: "Often"
              3: "Sometimes"
              4: "Never"
              7: "Don't know"
              8: "Refused"

        # B18: Time spent on homework
        - id: q_d18_homework_time
          kind: Question
          title: "In general, how much time did the child spend doing homework?"
          precondition:
            - predicate: q_d6_attend.outcome == 1 and q_d9_grade_enrolled.outcome not in [1, 2, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
          input:
            control: Radio
            labels:
              1: "A lot"
              2: "A fair amount"
              3: "Very little"
              4: "None at all"
              7: "Don't know"
              8: "Refused"

        # B19: Leisure time with parents
        - id: q_d19_leisure
          kind: Question
          title: "How much leisure time did the child's parents/guardians usually spend with him/her in a week? Leisure time means doing things together like playing a game, going shopping together, or other activities."
          precondition:
            - predicate: q_d6_attend.outcome == 1 and q_d9_grade_enrolled.outcome not in [1, 2, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
          input:
            control: Radio
            labels:
              1: "A lot"
              2: "A fair amount"
              3: "Very little"
              4: "None at all"
              7: "Don't know"
              8: "Refused"

    # =========================================================================
    # BLOCK 3: PSE PLANNING (B20-B29)
    # =========================================================================
    # Planning for post-secondary education. All children get B20.
    # B22-B29 gated on having saved (B20=1) or planning to save (B21=1).
    # =========================================================================
    - id: b_child3_pse_planning
      title: "Child 3 - Planning for Post-Secondary Education"
      items:
        # B20: Ever saved for PSE?
        - id: q_d20_saved
          kind: Question
          title: "Now I'd like to ask you some questions about saving for the child's post-secondary education. Post-secondary education includes college and university as well as apprenticeships, trade-vocational programs, CEGEPs or any other type of formal education after high school. Have you or anyone else living in your household ever saved money for the child's post-secondary education?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Don't know"
              4: "Refused"

        # B21: Planning to save? (only if B20 != Yes)
        # B21 original codes: 5=Yes, 6=No, 7=DK, 8=R -> normalized to 1-4
        - id: q_d21_plan_save
          kind: Question
          title: "Are you or anyone else living in your household planning to save or pay for the child's post-secondary education?"
          precondition:
            - predicate: q_d20_saved.outcome != 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Don't know"
              4: "Refused"

        # B22: Expect child to live away from home?
        # Gated on: saved (B20=1) OR planning to save (B21=1)
        - id: q_d22_live_away
          kind: Question
          title: "If the child were to go on to post-secondary education, do his/her parents/guardians expect that he/she will live away from home?"
          precondition:
            - predicate: q_d20_saved.outcome == 1 or q_d21_plan_save.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B23: Cost if living away (only if B22=Yes)
        - id: q_d23_cost_away
          kind: Question
          title: "Assuming that the child lives away from home, how much do his/her parents/guardians expect that the total cost of his/her education and living expenses would be?"
          precondition:
            - predicate: q_d22_live_away.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 999999

        # B24: Cost if living at home (only if B22 != Yes)
        - id: q_d24_cost_home
          kind: Question
          title: "Assuming that the child lives at home, how much do his/her parents/guardians expect that the total cost of his/her education would be?"
          precondition:
            - predicate: "(q_d20_saved.outcome == 1 or q_d21_plan_save.outcome == 1) and q_d22_live_away.outcome != 1"
          input:
            control: Editbox
            min: 0
            max: 999999

        # B25a: Child will work before PSE?
        - id: q_d25a_work_before
          kind: Question
          title: "Do the child's parents/guardians expect that he/she will pay for any part of his/her education costs himself/herself in the following ways: He/she will work before starting his/her post-secondary studies? This includes part-time jobs while in high school."
          precondition:
            - predicate: q_d20_saved.outcome == 1 or q_d21_plan_save.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B25b: Child will work during PSE?
        - id: q_d25b_work_during
          kind: Question
          title: "He/she will work during his/her post-secondary studies? This includes part-time jobs, summer jobs or co-op work programs."
          precondition:
            - predicate: q_d20_saved.outcome == 1 or q_d21_plan_save.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B25c: Child will interrupt studies to work?
        - id: q_d25c_interrupt
          kind: Question
          title: "He/she will interrupt his/her studies to work?"
          precondition:
            - predicate: q_d20_saved.outcome == 1 or q_d21_plan_save.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B25d: Child will take out loans?
        - id: q_d25d_loans
          kind: Question
          title: "He/she will take out loans that will be repaid after his/her studies are finished?"
          precondition:
            - predicate: q_d20_saved.outcome == 1 or q_d21_plan_save.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B27a: Government student loans? (only if B25d=Yes, i.e. expects loans)
        - id: q_d27a_govt_loans
          kind: Question
          title: "Are the loans expected to be: Government student loans (federal or provincial)?"
          precondition:
            - predicate: q_d25d_loans.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B27b: Non-student loans from financial institution?
        - id: q_d27b_bank_loans
          kind: Question
          title: "Non-student loans from a financial institution (e.g. bank, trust company, credit union)?"
          precondition:
            - predicate: q_d25d_loans.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B27c: Loans from family/friends?
        - id: q_d27c_family_loans
          kind: Question
          title: "Loans from family or friends?"
          precondition:
            - predicate: q_d25d_loans.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B27d: Other loans?
        - id: q_d27d_other_loans
          kind: Question
          title: "Other loans?"
          precondition:
            - predicate: q_d25d_loans.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B28a: Parents will save/invest before PSE?
        - id: q_d28a_parent_savings
          kind: Question
          title: "Do the child's parents/guardians expect that they will pay for any part of his/her education costs in the following ways: Savings or investments they make before the child starts post-secondary studies?"
          precondition:
            - predicate: q_d20_saved.outcome == 1 or q_d21_plan_save.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B28b: Parents will pay from income during PSE?
        - id: q_d28b_parent_income
          kind: Question
          title: "Income they earn while the child is attending post-secondary?"
          precondition:
            - predicate: q_d20_saved.outcome == 1 or q_d21_plan_save.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B28c: Parents will take out loans?
        - id: q_d28c_parent_loans
          kind: Question
          title: "Loans they take out and pay back after the child finishes post-secondary studies? This does not include loans taken out by the child such as a student loan."
          precondition:
            - predicate: q_d20_saved.outcome == 1 or q_d21_plan_save.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B29a: Scholarships/awards?
        - id: q_d29a_scholarships
          kind: Question
          title: "Do the child's parents/guardians expect that any part of his/her post-secondary education will be paid for by the following sources? Scholarships or awards based on academic performance."
          precondition:
            - predicate: q_d20_saved.outcome == 1 or q_d21_plan_save.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B29b: Grants/bursaries?
        - id: q_d29b_grants
          kind: Question
          title: "Grants or bursaries based on financial need."
          precondition:
            - predicate: q_d20_saved.outcome == 1 or q_d21_plan_save.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B29c: Gifts/inheritances?
        - id: q_d29c_gifts
          kind: Question
          title: "Gifts or inheritances."
          precondition:
            - predicate: q_d20_saved.outcome == 1 or q_d21_plan_save.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

    # =========================================================================
    # BLOCK 4: SAVINGS DETAILS (B31-B41b)
    # =========================================================================
    # B30 filter: only if B20=Yes (actually saved). Otherwise skip to B42.
    # =========================================================================
    - id: b_child3_savings_details
      title: "Child 3 - Savings for Post-Secondary Education"
      precondition:
        - predicate: q_d20_saved.outcome == 1
      items:
        # B31: Age when savings started
        - id: q_d31_savings_start_age
          kind: Question
          title: "The following questions refer to savings that have been made for the child's post-secondary education by anyone living in your household, including the child. Do not include savings put aside by someone outside your household. How old was the child when these savings were first started?"
          input:
            control: Editbox
            min: 0
            max: 18

        # B32: Amount saved in 1998
        - id: q_d32_saved_1998
          kind: Question
          title: "How much money was saved for the child's post-secondary education in 1998? Do not include any earnings or interest."
          input:
            control: Editbox
            min: 0
            max: 999999

        # B33: Amount saved so far in 1999
        - id: q_d33_saved_1999
          kind: Question
          title: "How much money has been saved for the child's post-secondary education so far in 1999? Do not include any earnings or interest."
          input:
            control: Editbox
            min: 0
            max: 999999

        # B34: Amount to be saved rest of 1999
        - id: q_d34_save_rest_1999
          kind: Question
          title: "How much money will be saved for the child in the rest of 1999?"
          input:
            control: Editbox
            min: 0
            max: 999999

        # B35: Total saved since starting
        - id: q_d35_total_saved
          kind: Question
          title: "Since starting to save for the child, how much in total has been saved for his/her post-secondary education? Do not include any earnings or interest."
          input:
            control: Editbox
            min: 0
            max: 999999

        # B36: Expected total by PSE start
        - id: q_d36_expected_total
          kind: Question
          title: "How much do you expect to have saved for the child's education by the time he/she starts post-secondary studies? Include all earnings and interest."
          input:
            control: Editbox
            min: 0
            max: 999999

        # B37a: RESP savings plan?
        - id: q_d37a_resp
          kind: Question
          title: "What types of savings plans are being used to save for the child's post-secondary education? RESPs (Registered Education Savings Plans)?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B37b: RRSP savings plan?
        - id: q_d37b_rrsp
          kind: Question
          title: "RRSPs (Registered Retirement Savings Plans)?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B37c: In-trust-for accounts?
        - id: q_d37c_trust
          kind: Question
          title: "'In-trust for' accounts?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B37d: Other savings plan?
        # If ALL of B37a-d are No/DK/R -> skip to B42.
        # codeBlock computes has_savings_plan for downstream gating.
        - id: q_d37d_other_plan
          kind: Question
          title: "Other savings plan?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"
          codeBlock: |
            has_savings_plan = 0
            if q_d37a_resp.outcome == 1 or q_d37b_rrsp.outcome == 1 or q_d37c_trust.outcome == 1 or q_d37d_other_plan.outcome == 1:
                has_savings_plan = 1

        # B38a: Mutual funds?
        - id: q_d38a_mutual_funds
          kind: Question
          title: "Within these plans, how are the savings invested? Mutual funds?"
          precondition:
            - predicate: has_savings_plan == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B38b: Shares of corporations?
        - id: q_d38b_shares
          kind: Question
          title: "Shares of corporations?"
          precondition:
            - predicate: has_savings_plan == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B38c: Savings/chequing accounts?
        - id: q_d38c_savings_acct
          kind: Question
          title: "Savings or chequing accounts?"
          precondition:
            - predicate: has_savings_plan == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B38d: Savings bonds?
        - id: q_d38d_bonds
          kind: Question
          title: "Savings bonds?"
          precondition:
            - predicate: has_savings_plan == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B38e: Other investments?
        - id: q_d38e_other_invest
          kind: Question
          title: "Other investments?"
          precondition:
            - predicate: has_savings_plan == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B40: Total RESP contributions (only if B37a=Yes, i.e. has RESP)
        - id: q_d40_resp_total
          kind: Question
          title: "For the RESP only, how much money in total has been contributed to RESPs for the child by people living in your household?"
          precondition:
            - predicate: q_d37a_resp.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 999999

        # B41a: Individual RESP plan?
        - id: q_d41a_resp_individual
          kind: Question
          title: "Which types of RESPs are being used? Individual plan (includes individual non-family and family RESPs)?"
          precondition:
            - predicate: q_d37a_resp.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B41b: Group RESP plan?
        - id: q_d41b_resp_group
          kind: Question
          title: "Group plan (education scholarship trust or foundation)?"
          precondition:
            - predicate: q_d37a_resp.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

    # =========================================================================
    # BLOCK 5: OUTSIDE SAVINGS (B42-B43)
    # =========================================================================
    # Always shown regardless of previous savings answers.
    # =========================================================================
    - id: b_child3_outside_savings
      title: "Child 3 - Outside Household Savings"
      items:
        # B42: Outside household savings?
        - id: q_d42_outside
          kind: Question
          title: "Does anyone who does not live in your household have savings put aside for the child's post-secondary education?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # B43: Amount of outside savings (only if B42=Yes)
        - id: q_d43_outside_amount
          kind: Question
          title: "How much money in total have the people who don't live in your household put aside for the child's post-secondary education?"
          precondition:
            - predicate: q_d42_outside.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 999999

    # ===================================================================
    # SECTION: remaining_children
    # ===================================================================
    # =========================================================================
    # SECTION E: REMAINING CHILDREN — SAVINGS FOR POST-SECONDARY EDUCATION
    # =========================================================================
    # This section applies to children 4+ (beyond the 3 selected for detailed
    # questioning in Sections B-D). It collects aggregate savings information
    # for all remaining children as a group.
    #
    # Routing:
    #   E1=Yes -> E2; E1=No/DK/R -> END
    #   E2=0 -> END; E2>=1 -> E3..E6 -> E7a..E7d
    #   E7d: if ALL E7a-d not Yes -> END; otherwise -> E8a..E8e -> E9
    #   E9 (filter): E7a=Yes -> E10..E11b; otherwise -> END
    # =========================================================================
    - id: b_remaining_savings
      title: "Savings for Remaining Children"
      items:
        # E1: Have you saved for remaining children's PSE?
        - id: q_e1_saved
          kind: Question
          title: "Now I'd like to ask you some questions about saving for the post-secondary education of the other children in your household who are 18 years of age or younger. Have you or anyone else living in your household ever saved money for the post-secondary education of these children?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # E2: For how many children is money being saved?
        - id: q_e2_how_many
          kind: Question
          title: "For how many of these children is money being saved?"
          precondition:
            - predicate: q_e1_saved.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 17

        # E3: Amount saved in 1998
        - id: q_e3_saved_1998
          kind: Question
          title: "How much money was saved for these children's post-secondary education in 1998? Do not include any earnings or interest."
          precondition:
            - predicate: q_e1_saved.outcome == 1 and q_e2_how_many.outcome >= 1
          input:
            control: Editbox
            min: 0
            max: 999999

        # E4: Amount saved so far in 1999
        - id: q_e4_saved_1999
          kind: Question
          title: "How much money has been saved for these children's post-secondary education so far in 1999?"
          precondition:
            - predicate: q_e1_saved.outcome == 1 and q_e2_how_many.outcome >= 1
          input:
            control: Editbox
            min: 0
            max: 999999

        # E5: Amount to be saved rest of 1999
        - id: q_e5_save_rest_1999
          kind: Question
          title: "How much money will be saved for these children in the rest of 1999?"
          precondition:
            - predicate: q_e1_saved.outcome == 1 and q_e2_how_many.outcome >= 1
          input:
            control: Editbox
            min: 0
            max: 999999

        # E6: Total saved since starting
        - id: q_e6_total_saved
          kind: Question
          title: "Since starting to save for these children, how much in total has been saved for their post-secondary education?"
          precondition:
            - predicate: q_e1_saved.outcome == 1 and q_e2_how_many.outcome >= 1
          input:
            control: Editbox
            min: 0
            max: 999999

        # E7a: Savings plan — RESPs
        - id: q_e7a_resp
          kind: Question
          title: "What types of savings plans are being used to save for these children's post-secondary education? a) RESPs (Registered Education Savings Plans)"
          precondition:
            - predicate: q_e1_saved.outcome == 1 and q_e2_how_many.outcome >= 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # E7b: Savings plan — RRSPs
        - id: q_e7b_rrsp
          kind: Question
          title: "b) RRSPs (Registered Retirement Savings Plans)"
          precondition:
            - predicate: q_e1_saved.outcome == 1 and q_e2_how_many.outcome >= 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # E7c: Savings plan — In-trust-for accounts
        - id: q_e7c_trust
          kind: Question
          title: "c) 'In-trust for' accounts"
          precondition:
            - predicate: q_e1_saved.outcome == 1 and q_e2_how_many.outcome >= 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # E7d: Savings plan — Other
        # After E7d: if ALL E7a-d are NOT Yes, skip investment details
        - id: q_e7d_other
          kind: Question
          title: "d) Other"
          precondition:
            - predicate: q_e1_saved.outcome == 1 and q_e2_how_many.outcome >= 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"
          codeBlock: |
            if q_e7a_resp.outcome == 1 or q_e7b_rrsp.outcome == 1 or q_e7c_trust.outcome == 1 or q_e7d_other.outcome == 1:
                has_remaining_plan = 1

        # E8a: Investment type — Mutual funds
        - id: q_e8a_mutual
          kind: Question
          title: "Within these plans, how are the savings invested? a) Mutual funds"
          precondition:
            - predicate: has_remaining_plan == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # E8b: Investment type — Shares of corporations
        - id: q_e8b_shares
          kind: Question
          title: "b) Shares of corporations"
          precondition:
            - predicate: has_remaining_plan == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # E8c: Investment type — Savings or chequing accounts
        - id: q_e8c_savings
          kind: Question
          title: "c) Savings or chequing accounts"
          precondition:
            - predicate: has_remaining_plan == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # E8d: Investment type — Savings bonds
        - id: q_e8d_bonds
          kind: Question
          title: "d) Savings bonds"
          precondition:
            - predicate: has_remaining_plan == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # E8e: Investment type — Other
        - id: q_e8e_other
          kind: Question
          title: "e) Other"
          precondition:
            - predicate: has_remaining_plan == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # E10: RESP total contributions
        # E9 (filter): if E7a=Yes -> E10; otherwise end
        - id: q_e10_resp_total
          kind: Question
          title: "For the RESP only, how much money in total has been contributed to RESPs for these children by people living in your household?"
          precondition:
            - predicate: q_e7a_resp.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 999999

        # E11a: RESP type — Individual plan
        - id: q_e11a_individual
          kind: Question
          title: "Which types of RESPs are being used? a) Individual plan (includes individual non-family and family RESPs)"
          precondition:
            - predicate: q_e7a_resp.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # E11b: RESP type — Group plan
        - id: q_e11b_group
          kind: Question
          title: "b) Group plan (education scholarship trust or foundation)"
          precondition:
            - predicate: q_e7a_resp.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

    # ===================================================================
    # SECTION: outside_children
    # ===================================================================
    # =========================================================================
    # SECTION F: CHILDREN OUTSIDE HOUSEHOLD — SAVINGS
    # =========================================================================
    # Collects savings information for children under 18 who do NOT live in
    # the respondent's household but for whom household members are saving.
    #
    # Routing:
    #   F1=Yes -> F2..F7 -> F8a..F8d
    #   F1=No -> END
    #   F8d: if ALL F8a-d not Yes -> END; otherwise -> F9a..F9e -> F10
    #   F10 (filter): F8a=Yes -> F11..F12b; otherwise -> END
    # =========================================================================
    - id: b_outside_savings
      title: "Savings for Children Outside Household"
      items:
        # F1: Are you saving for children outside household?
        - id: q_f1_saving
          kind: Question
          title: "Are you or anyone else living in your household saving for the post-secondary education of any children 18 years of age or younger who do not live in your household?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # F2: For how many children?
        - id: q_f2_how_many
          kind: Question
          title: "For how many children is money being saved?"
          precondition:
            - predicate: q_f1_saving.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 20

        # F3: Relationship of children to savers
        - id: q_f3_relationship
          kind: Question
          title: "What is the relationship of these children to the people saving money for them? (Mark all that apply)"
          precondition:
            - predicate: q_f1_saving.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "Son"
              2: "Daughter"
              4: "Grandson"
              8: "Granddaughter"
              16: "Brother"
              32: "Sister"
              64: "Niece"
              128: "Nephew"
              256: "Other family member or relative"
              512: "Unrelated"

        # F4: Amount saved in 1998
        - id: q_f4_saved_1998
          kind: Question
          title: "How much money was saved for these children's education in 1998 by you or anyone else living in your household? Do not include any earnings or interest."
          precondition:
            - predicate: q_f1_saving.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 999999

        # F5: Amount saved so far in 1999
        - id: q_f5_saved_1999
          kind: Question
          title: "How much money was saved for these children's education so far in 1999?"
          precondition:
            - predicate: q_f1_saving.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 999999

        # F6: Amount to be saved rest of 1999
        - id: q_f6_save_rest_1999
          kind: Question
          title: "How much money will you or anyone else in your household save for these children in the rest of 1999?"
          precondition:
            - predicate: q_f1_saving.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 999999

        # F7: Total saved since starting
        - id: q_f7_total_saved
          kind: Question
          title: "Since starting to save for these children, how much money in total has been saved by you or anyone else in your household for their education? Do not include any earnings or interest."
          precondition:
            - predicate: q_f1_saving.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 999999

        # F8a: Savings plan — RESPs
        - id: q_f8a_resp
          kind: Question
          title: "What types of savings plans are being used? a) RESPs (Registered Education Savings Plans)"
          precondition:
            - predicate: q_f1_saving.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # F8b: Savings plan — RRSPs
        - id: q_f8b_rrsp
          kind: Question
          title: "b) RRSPs (Registered Retirement Savings Plans)"
          precondition:
            - predicate: q_f1_saving.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # F8c: Savings plan — In-trust-for accounts
        - id: q_f8c_trust
          kind: Question
          title: "c) 'In-trust for' accounts"
          precondition:
            - predicate: q_f1_saving.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # F8d: Savings plan — Other
        # After F8d: if ALL F8a-d are NOT Yes, skip investment details
        - id: q_f8d_other
          kind: Question
          title: "d) Other"
          precondition:
            - predicate: q_f1_saving.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"
          codeBlock: |
            if q_f8a_resp.outcome == 1 or q_f8b_rrsp.outcome == 1 or q_f8c_trust.outcome == 1 or q_f8d_other.outcome == 1:
                has_outside_plan = 1

        # F9a: Investment type — Mutual funds
        - id: q_f9a_mutual
          kind: Question
          title: "Within these plans, how are the savings invested? a) Mutual funds"
          precondition:
            - predicate: has_outside_plan == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # F9b: Investment type — Shares of corporations
        - id: q_f9b_shares
          kind: Question
          title: "b) Shares of corporations"
          precondition:
            - predicate: has_outside_plan == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # F9c: Investment type — Savings or chequing accounts
        - id: q_f9c_savings
          kind: Question
          title: "c) Savings or chequing accounts"
          precondition:
            - predicate: has_outside_plan == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # F9d: Investment type — Savings bonds
        - id: q_f9d_bonds
          kind: Question
          title: "d) Savings bonds"
          precondition:
            - predicate: has_outside_plan == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # F9e: Investment type — Other
        - id: q_f9e_other
          kind: Question
          title: "e) Other"
          precondition:
            - predicate: has_outside_plan == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # F11: RESP total contributions
        # F10 (filter): if F8a=Yes -> F11; otherwise end
        - id: q_f11_resp_total
          kind: Question
          title: "For the RESPs only, how much money in total has been contributed to RESPs for these children by people living in your household?"
          precondition:
            - predicate: q_f8a_resp.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 999999

        # F12a: RESP type — Individual plan
        - id: q_f12a_individual
          kind: Question
          title: "Which types of RESPs are being used? a) Individual plan (includes individual non-family and family RESPs)"
          precondition:
            - predicate: q_f8a_resp.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # F12b: RESP type — Group plan
        - id: q_f12b_group
          kind: Question
          title: "b) Group plan (education scholarship trust or foundation)"
          precondition:
            - predicate: q_f8a_resp.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

    # ===================================================================
    # SECTION: general_information
    # ===================================================================
    # =========================================================================
    # SECTION G: GENERAL INFORMATION
    # =========================================================================
    # G1 is a complex filter:
    #   No children AND F1=No  -> G11
    #   No children AND F1=Yes -> G6
    #   All children 0-4       -> G4
    #   Otherwise              -> G2
    #
    # Modelled as four blocks with appropriate preconditions.
    # The "all children 0-4" edge case cannot be determined from num_children
    # alone across files, so G2-G3 gate on num_children >= 1 (the 0-4 case
    # is rare and the questions remain valid).
    # =========================================================================

    # ----- Block 1: Household Resources (G2-G3) -----
    # Shown when children are in the household (not all 0-4 in original,
    # simplified to num_children >= 1)
    - id: b_household_resources
      title: "Household Resources"
      precondition:
        - predicate: num_children >= 1
      items:
        # G2: Computer available for schoolwork
        - id: q_g2_computer
          kind: Question
          title: "Is there a computer available in your household that the children can use to do their school work or assignments?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # G3: Books or reading materials available
        - id: q_g3_books
          kind: Question
          title: "Are there books or other reading materials in the home for the children to use to do school work or assignments? (e.g. encyclopaedias, reference books, CD ROMs)"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

    # ----- Block 2: Ethnicity (G4-G5) -----
    # Shown when children are in the household
    - id: b_ethnicity
      title: "Ethnic and Cultural Background"
      precondition:
        - predicate: num_children >= 1
      items:
        # G4: Mother's ethnic/cultural ancestry
        - id: q_g4_mother_ethnicity
          kind: Question
          title: "Thinking of the children in your household, to which ethnic or cultural group(s) do the ancestors of their mother belong? (Mark all that apply)"
          input:
            control: Checkbox
            labels:
              1: "Canadian"
              2: "Chinese"
              4: "Dutch (Netherlands)"
              8: "English"
              16: "French"
              32: "German"
              64: "Inuit/Eskimo"
              128: "Irish"
              256: "Italian"
              512: "Jewish"
              1024: "Metis"
              2048: "North American Indian"
              4096: "Polish"
              8192: "Scottish"
              16384: "South Asian"
              32768: "Ukrainian"
              65536: "Other"

        # G5: Father's ethnic/cultural ancestry
        - id: q_g5_father_ethnicity
          kind: Question
          title: "Thinking of the children in your household, to which ethnic or cultural group(s) do the ancestors of their father belong? (Mark all that apply)"
          input:
            control: Checkbox
            labels:
              1: "Canadian"
              2: "Chinese"
              4: "Dutch (Netherlands)"
              8: "English"
              16: "French"
              32: "German"
              64: "Inuit/Eskimo"
              128: "Irish"
              256: "Italian"
              512: "Jewish"
              1024: "Metis"
              2048: "North American Indian"
              4096: "Polish"
              8192: "Scottish"
              16384: "South Asian"
              32768: "Ukrainian"
              65536: "Other"

    # ----- Block 3: Language, Finances, Income (G6-G10) -----
    # Always shown (G6 is reached by all paths through G1)
    - id: b_language_finances
      title: "Language and Financial Information"
      items:
        # G6: Language spoken most often in household
        - id: q_g6_language_main
          kind: Question
          title: "What is the language spoken most often in your household?"
          input:
            control: Checkbox
            labels:
              1: "English"
              2: "French"
              4: "Arabic"
              8: "Chinese"
              16: "German"
              32: "Italian"
              64: "Polish"
              128: "Portuguese"
              256: "Punjabi"
              512: "Spanish"
              1024: "Tagalog (Filipino)"
              2048: "Vietnamese"
              4096: "Other language"

        # G7: Other languages spoken in household
        - id: q_g7_language_other
          kind: Question
          title: "What other languages are spoken in your household? (Mark all that apply)"
          input:
            control: Checkbox
            labels:
              1: "No other languages spoken"
              2: "English"
              4: "French"
              8: "Arabic"
              16: "Chinese"
              32: "German"
              64: "Italian"
              128: "Polish"
              256: "Portuguese"
              512: "Punjabi"
              1024: "Spanish"
              2048: "Tagalog (Filipino)"
              4096: "Vietnamese"
              8192: "Other language"

        # G8: Highest financial priority
        - id: q_g8_financial_priority
          kind: Question
          title: "From the following list, what is your household's highest financial priority?"
          input:
            control: Radio
            labels:
              1: "Everyday budget"
              2: "Savings for post-secondary education"
              3: "Retirement savings"
              4: "Other savings"
              7: "Don't know"
              8: "Refused"

        # G9: Household income sources (past 12 months)
        - id: q_g9_income_sources
          kind: Question
          title: "Thinking about your total household income, from which of the following sources did your household receive any income in the past 12 months? (Mark all that apply)"
          input:
            control: Checkbox
            labels:
              1: "Wages and salaries"
              2: "Income from self-employment"
              4: "Dividends and interest"
              8: "Employment insurance"
              16: "Workers' compensation"
              32: "Benefits from Canada or Quebec Pension Plan"
              64: "Retirement pensions, superannuation and annuities"
              128: "Old Age Security and Guaranteed Income Supplement"
              256: "Child Tax Benefit"
              512: "Provincial or municipal social assistance or welfare"
              1024: "Child support"
              2048: "Alimony"
              4096: "Other"
              8192: "None"

        # G10: Total household income (flattened from hierarchical bisection)
        - id: q_g10_income
          kind: Question
          title: "What is your best estimate of the total income before taxes and deductions of all household members from all sources in the past 12 months?"
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
              8: "$40,000 to $49,999"
              9: "$50,000 to $59,999"
              10: "$60,000 to $79,999"
              11: "$80,000 or more"
              97: "Don't know"
              98: "Refused"

    # ----- Block 4: Consent (G11, G13) -----
    # Always shown; G13 has item-level precondition for children in household
    - id: b_consent
      title: "Data Sharing Consent"
      items:
        # G11: Statistics Canada data sharing consent
        - id: q_g11_data_sharing
          kind: Question
          title: "To avoid duplication, Statistics Canada has entered into a data sharing agreement under Section 12 of the Statistics Act with Human Resources Development Canada. Do you agree to let Statistics Canada share your information?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"

        # G13: Record linkage consent
        # G12 (filter): if no children -> END; otherwise -> G13
        - id: q_g13_record_linkage
          kind: Question
          title: "As part of a related statistical study, the information you provide during this interview, in future, may be combined with post-secondary school records about the children in your household. Do you agree to let Statistics Canada combine this information?"
          precondition:
            - predicate: num_children >= 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know"
              8: "Refused"
