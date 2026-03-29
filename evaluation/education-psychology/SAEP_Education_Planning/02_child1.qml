qmlVersion: "1.0"
questionnaire:
  title: "SAEP - Child 1"
  codeInit: |
    num_children: range(1, 20)
    has_savings_plan = 0

  blocks:
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
