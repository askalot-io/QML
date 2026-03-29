qmlVersion: "1.0"
questionnaire:
  title: "NPHS Population Health Survey - Labour Force and Income"
  codeInit: |
    # Extern variable from household section
    age: range(0, 120)

    # Variables produced by this section
    lfs_work = 0
    income_multi = 0

  blocks:
    # =========================================================================
    # BLOCK 1: LABOUR FORCE — MAIN ACTIVITY GATE
    # =========================================================================
    # LFS-C1: If age < 15 → skip entire Labour Force section → Income
    # LFS-Q1: Main activity
    # LFS-I2: Employment intro (Comment)
    # LFS-C2: If Q1=2 or Q1=3 (working) → GO TO Q3 (skip Q2)
    # LFS-Q2: Worked for pay in past 12 months?
    # LFS-C2A: If Q1=7 (retired) → GO TO LFS-C18; else → GO TO Q17B
    # =========================================================================
    - id: b_main_activity
      title: "Labour Force — Main Activity"
      precondition:
        - predicate: age >= 15
      items:
        # LFS-Q1: Current main activity
        - id: q_lfs_q1
          kind: Question
          title: "What do/does ... consider to be your/his/her current main activity? (Do not read list. Mark one only.)"
          input:
            control: Radio
            labels:
              1: "Caring for family"
              2: "Working for pay or profit"
              3: "Caring for family and working for pay or profit"
              4: "Going to school"
              5: "Recovering from illness / on disability"
              6: "Looking for work"
              7: "Retired"
              8: "Other (Specify)"

        # LFS-I2: Employment section introduction
        - id: q_lfs_i2
          kind: Comment
          title: "The next section contains questions about jobs or employment which ... have/has had during the past 12 months, that is, from 12 months ago to today. Please include such employment as part-time jobs, contract work, baby sitting and any other paid work."

        # LFS-Q2: Worked for pay in past 12 months?
        # LFS-C2: IF Q1=2 (Working) or Q1=3 (Caring+Working) → skip to Q3
        # So Q2 is shown only when Q1 is NOT 2 or 3.
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
    # BLOCK 2: EMPLOYMENT DETAILS (Q3–Q16)
    # =========================================================================
    # Reached when:
    #   - Q1=2 or Q1=3 (currently working → jumped to Q3), OR
    #   - Q2=1 (worked for pay in past 12 months)
    #
    # NOTE: The original instrument uses a roster of up to 6 jobs (LFS-Q3.n
    # through Q11.n). QML cannot model dynamic rosters; only the MAIN (first)
    # job is captured here. The full employer roster is represented by a single
    # open-text question. The roster loop (n=1..6) and multi-job logic are
    # omitted by design.
    #
    # LFS-Q3: Employer name (open text; roster slot 1 only)
    # LFS-Q4: Had job 1 year ago? Y→Q6, N→Q5
    # LFS-Q5: Start date (modeled as year Editbox)
    # LFS-Q6: Currently have that job? Y→Q8, N→Q7
    # LFS-Q7: Stop date (modeled as year Editbox)
    # LFS-Q8: Hours per week
    # LFS-Q9: Work schedule
    # LFS-Q10: Weekend work?
    # LFS-Q11: Other jobs? (simplified — roster not supported)
    # LFS-C12: IF Q11=No → skip Q12
    # LFS-Q12: Which was main job? (modeled as Comment — roster not available)
    # LFS-Q13: Industry description
    # LFS-Q14: Occupation description
    # LFS-Q15: Duties description
    # LFS-Q16: Class of worker
    # =========================================================================
    - id: b_employment_details
      title: "Employment Details"
      precondition:
        - predicate: age >= 15
        - predicate: q_lfs_q1.outcome in [2, 3] or q_lfs_q2.outcome == 1
      items:
        # LFS-Q3: Employer name (main / first job only)
        - id: q_lfs_q3
          kind: Question
          title: "For whom have/has you/he/she worked for pay or profit in the past 12 months? (Enter employer name.)"
          input:
            control: Textarea
            placeholder: "Enter employer name"

        # LFS-Q4: Had that job 1 year ago?
        - id: q_lfs_q4
          kind: Question
          title: "Did you/he/she have that job 1 year ago, without a break in employment since then?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # LFS-Q5: When started? (only if Q4=No; Q4=Yes → GO TO Q6)
        - id: q_lfs_q5
          kind: Question
          title: "When did you/he/she start working at this job or business? (Enter year.)"
          precondition:
            - predicate: q_lfs_q4.outcome == 2
          input:
            control: Editbox
            min: 1900
            max: 2000
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

        # LFS-Q7: When stopped? (only if Q6=No; Q6=Yes → GO TO Q8)
        - id: q_lfs_q7
          kind: Question
          title: "When did you/he/she stop working at this job or business? (Enter year.)"
          precondition:
            - predicate: q_lfs_q6.outcome == 2
          input:
            control: Editbox
            min: 1900
            max: 2000
            right: "year"

        # LFS-Q8: Usual hours per week
        - id: q_lfs_q8
          kind: Question
          title: "About how many hours per week do/does/did you/he/she usually work at this job?"
          input:
            control: Editbox
            min: 0
            max: 168
            right: "hours/week"

        # LFS-Q9: Work schedule
        - id: q_lfs_q9
          kind: Question
          title: "Which of the following best describes the hours you/he/she usually work/works/worked at this job? (Read list. Mark one only.)"
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
              8: "Other (Specify)"

        # LFS-Q10: Weekend work?
        - id: q_lfs_q10
          kind: Question
          title: "Do/Does/Did you/he/she usually work on weekends at this job?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # LFS-Q11: Any other work for pay in past 12 months?
        # (Since only one job is modeled in this QML, this captures whether
        # additional jobs existed; Q12 roster selection is not fully supported.)
        - id: q_lfs_q11
          kind: Question
          title: "Did you/he/she do any other work for pay or profit in the past 12 months?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # LFS-C12 / LFS-Q12: Which was the main job?
        # LFS-C12: IF Q11=No → GO TO Q13 (skip Q12)
        # NOTE: Full roster selection unavailable in QML. Modeled as a Comment
        # acknowledging multiple jobs were reported; routing continues to Q13.
        - id: q_lfs_c12_note
          kind: Comment
          title: "(Interviewer note: Multiple jobs reported — main job selection per interviewer manual applies before proceeding to Q13.)"
          precondition:
            - predicate: q_lfs_q11.outcome == 1

        # LFS-Q13: Industry description (main job)
        - id: q_lfs_q13
          kind: Question
          title: "Thinking about this/the main job, what kind of business, service or industry is this? (For example: wheat farm, road maintenance, retail shoe store.)"
          input:
            control: Textarea
            placeholder: "Enter industry description"

        # LFS-Q14: Occupation description (main job)
        - id: q_lfs_q14
          kind: Question
          title: "Again, thinking about this/the main job, what kind of work was/were ... doing? (For example: medical lab technician, accounting clerk, secondary school teacher.)"
          input:
            control: Textarea
            placeholder: "Enter occupation description"

        # LFS-Q15: Duties description (main job)
        - id: q_lfs_q15
          kind: Question
          title: "In this work, what were your/his/her most important duties or activities? (For example: analysis of blood samples, verifying invoices, teaching mathematics.)"
          input:
            control: Textarea
            placeholder: "Enter duties description"

        # LFS-Q16: Class of worker
        - id: q_lfs_q16
          kind: Question
          title: "Did you/he/she work mainly for others for wages or commission or in your/his/her own business, farm or practice? (Do not read list. Mark one only.)"
          input:
            control: Radio
            labels:
              1: "For others for wages, salary or commission"
              2: "In own business, farm or professional practice"
              3: "Unpaid family worker"

    # =========================================================================
    # BLOCK 3: ABSENCE REASON — CURRENTLY EMPLOYED (Q17A)
    # =========================================================================
    # LFS-C17: Calendar gap check (> 6 days). If no gaps → GO TO LFS-C18.
    # LFS-C17A: If any Q6=1 (currently employed) → Q17A; else → Q17B.
    #
    # Routing: Q17A applies when the respondent IS currently employed (Q6=1)
    # but had a gap in work. In the simplified single-job model, Q6=1 means
    # the main job is still held.
    # =========================================================================
    - id: b_absence_reason_employed
      title: "Reason Not Working — Currently Employed"
      precondition:
        - predicate: age >= 15
        - predicate: q_lfs_q1.outcome in [2, 3] or q_lfs_q2.outcome == 1
        - predicate: q_lfs_q6.outcome == 1
      items:
        # LFS-Q17A: Reason for most recent period away from work (currently employed)
        - id: q_lfs_q17a
          kind: Question
          title: "What was the reason that ... were/was not working for pay or profit during the most recent period away from work in the past year? (Do not read list. Mark one only.)"
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
              9: "Temporary layoff — non-seasonal"
              10: "Permanent layoff"
              11: "Unpaid or partially paid vacation"
              12: "Other (Specify)"
              13: "No period not working"

    # =========================================================================
    # BLOCK 4: ABSENCE REASON — NOT CURRENTLY EMPLOYED (Q17B)
    # =========================================================================
    # LFS-C17A: If NOT currently employed → Q17B.
    # Also applies when Q2=No and Q1≠7 (not retired, not working).
    #
    # Routing: Q17B applies when:
    #   - Had employment in past 12 months (Q2=1 or Q1=2/3) AND Q6=2 (no longer has job)
    #   - OR had no employment (Q2=2) AND Q1≠7 (not retired)
    # =========================================================================
    - id: b_absence_reason_not_employed
      title: "Reason Not Currently Working"
      precondition:
        - predicate: age >= 15
        - predicate: q_lfs_q1.outcome not in [2, 3, 7] or (q_lfs_q1.outcome in [2, 3] and q_lfs_q6.outcome == 2)
        - predicate: q_lfs_q2.outcome in [1, 2]
      items:
        # LFS-Q17B: Reason currently not working for pay or profit
        - id: q_lfs_q17b
          kind: Question
          title: "What is the reason that ... are/is currently not working for pay or profit? (Do not read list. Mark one only.)"
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
              9: "Temporary layoff — non-seasonal"
              10: "Permanent layoff"
              11: "Unpaid or partially paid vacation"
              12: "Other (Specify)"
              13: "No period not working"

    # =========================================================================
    # BLOCK 5: LFS-C18 — DERIVED VARIABLE lfs_work
    # =========================================================================
    # LFS-C18: Set lfs_work = 1 if currently working, 0 otherwise.
    # Rule: Q1=2 or Q1=3 → working; OR Q6=1 → working; else → not working.
    # Modeled as a Comment with a codeBlock to set the lfs_work variable.
    # =========================================================================
    - id: b_lfs_derived
      title: "Labour Force Status (Derived)"
      precondition:
        - predicate: age >= 15
      items:
        - id: q_lfs_c18
          kind: Comment
          title: "(System: Labour force working status derived from responses above.)"
          codeBlock: |
            if q_lfs_q1.outcome in [2, 3] or q_lfs_q6.outcome == 1:
              lfs_work = 1
            else:
              lfs_work = 0

    # =========================================================================
    # BLOCK 6: INCOME SOURCES (INCOM-Q1)
    # =========================================================================
    # Asked from knowledgeable person only (no filter in QML; always shown
    # after Labour Force section for eligible respondents).
    #
    # INCOM-Q1: Household income sources (checkbox, multi-select)
    # If INCOM-Q1 = None (key 8192) or DK/R → skip rest
    # If only one source → skip INCOM-Q2, go to INCOM-Q3
    # If multiple sources → ask INCOM-Q2 first
    #
    # Checkbox key assignments (powers of 2):
    #   1   = Wages and salaries
    #   2   = Income from self-employment
    #   4   = Dividends and interest
    #   8   = Unemployment insurance
    #   16  = Worker's compensation
    #   32  = Benefits from CPP/QPP
    #   64  = Retirement pensions/superannuation/annuities
    #   128 = Old Age Security and GIS
    #   256 = Child Tax Benefit
    #   512 = Provincial/municipal social assistance or welfare
    #   1024 = Child Support
    #   2048 = Alimony
    #   4096 = Other Income
    #   8192 = None
    # =========================================================================
    - id: b_income_sources
      title: "Income Sources"
      items:
        # INCOM-Q1: Which income sources?
        - id: q_incom_q1
          kind: Question
          title: "Thinking about your total household income, from which of the following sources did your household receive any income in the past 12 months? (Read list. Mark all that apply.)"
          codeBlock: |
            # Count number of income sources selected (popcount of bitmask).
            # Excludes "None" bit (8192). income_multi=1 means >1 source selected.
            v = q_incom_q1.outcome & 4095  # mask out the None bit (8192) and Others
            count = bin(v).count('1')
            if count > 1:
              income_multi = 1
            else:
              income_multi = 0
          input:
            control: Checkbox
            labels:
              1: "Wages and salaries"
              2: "Income from self-employment"
              4: "Dividends and interest"
              8: "Unemployment insurance"
              16: "Worker's compensation"
              32: "Benefits from CPP/QPP"
              64: "Retirement pensions, superannuation or annuities"
              128: "Old Age Security and GIS"
              256: "Child Tax Benefit"
              512: "Provincial/municipal social assistance or welfare"
              1024: "Child Support"
              2048: "Alimony"
              4096: "Other income"
              8192: "None"

    # =========================================================================
    # BLOCK 7: MAIN INCOME SOURCE (INCOM-Q2)
    # =========================================================================
    # Only asked if more than one source was selected in INCOM-Q1.
    # income_multi is computed in q_incom_q1's codeBlock:
    #   income_multi = 1 if popcount(outcome & 4095) > 1, else 0.
    # =========================================================================
    - id: b_main_income_source
      title: "Main Income Source"
      precondition:
        - predicate: income_multi == 1
      items:
        # INCOM-Q2: What was the main source of income?
        - id: q_incom_q2
          kind: Question
          title: "What was the main source of income? (Do not read list. Mark one only.)"
          input:
            control: Dropdown
            labels:
              1: "Wages and salaries"
              2: "Income from self-employment"
              3: "Dividends and interest"
              4: "Unemployment insurance"
              5: "Worker's compensation"
              6: "Benefits from CPP/QPP"
              7: "Retirement pensions, superannuation or annuities"
              8: "Old Age Security and GIS"
              9: "Child Tax Benefit"
              10: "Provincial/municipal social assistance or welfare"
              11: "Child Support"
              12: "Alimony"
              13: "Other income"

    # =========================================================================
    # BLOCK 8: INCOME BRACKET (INCOM-Q3)
    # =========================================================================
    # Only asked if INCOM-Q1 is not None (8192).
    #
    # The original instrument uses an unfolding binary tree of 7 yes/no
    # questions (INC4_3A through INC4_3G) to arrive at one of 11 brackets.
    # This is simplified to a single Dropdown listing all final brackets,
    # per the QML conversion instruction.
    # =========================================================================
    - id: b_income_bracket
      title: "Income Bracket"
      precondition:
        - predicate: q_incom_q1.outcome != 8192
        - predicate: q_incom_q1.outcome != 0
      items:
        # INCOM-Q3: Total household income bracket
        - id: q_incom_q3
          kind: Question
          title: "What is your best estimate of the total income before taxes and deductions of all household members from all sources in the past 12 months?"
          input:
            control: Dropdown
            labels:
              1: "No income"
              2: "Under $5,000"
              3: "$5,000 to $9,999"
              4: "$10,000 to $14,999"
              5: "$15,000 to $19,999"
              6: "$20,000 to $29,999"
              7: "$30,000 to $39,999"
              8: "$40,000 to $49,999"
              9: "$50,000 to $59,999"
              10: "$60,000 to $79,999"
              11: "$80,000 or more"
