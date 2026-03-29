qmlVersion: "1.0"
questionnaire:
  title: "NLSCY Children and Youth - Labour Force"
  codeInit: |
    # Variables READ from prior sections
    is_parent = 0       # 1=respondent is the parent, 0=otherwise

    # Variables PRODUCED by this section
    # has_gaps: 1=calendar has gaps > 6 days, 0=no gaps (models LFS-C17)
    has_gaps = 0

  blocks:
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
