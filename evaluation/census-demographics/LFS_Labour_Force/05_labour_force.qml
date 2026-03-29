qmlVersion: "1.0"
questionnaire:
  title: "Labour Force Survey - Labour Force Information"

  codeInit: |
    # Extern variables from Demographics section
    respondent_age: range(15, 120)

    # Extern: subsequent interview flag (0=birth, 1=subsequent)
    is_subsequent: {0, 1}

    # Central routing variable — set progressively, exported to later sections
    # 1=employed at work, 2=employed absent, 3=temp layoff,
    # 4=job seeker, 5=future start, 6=NILF able, 7=NILF permanently unable
    #
    # DESIGN NOTE: Within this section, preconditions reference the source
    # item outcomes directly (e.g., q_100.outcome == 1 instead of path == 1)
    # to avoid dependency cycles through the shared path variable.
    # The path variable is only WRITTEN here (for export); downstream
    # sections read it as an extern.
    path = 0

    # Consolidation: usual hours from q_151 or q_152
    usual_hours = 0

    # Computation: actual hours worked at main job
    actual_hours = 0

    # Classification: whether last worked within past year (for item 105 routing)
    last_work_recent = 0

    # Classification: layoff type from q_130/q_136 chain
    # 0=not on layoff, 1=temp layoff with recall (PATH=3 equivalent)
    is_temp_layoff = 0

    # Classification: job search status from q_170
    # 0=not seeking, 1=seeking (PATH=4), 2=future start soon (PATH=5)
    search_status = 0

  blocks:
    # =========================================================================
    # BLOCK 1: JOB ATTACHMENT
    # =========================================================================
    # Q100: Worked last week? Sets PATH=1 (yes) or PATH=7 (permanently unable)
    # Q101: Had a job but absent? (only if Q100=No)
    # Q102: More than one job? (if worked or had job)
    # Q103: Changing employers? (if Q102=Yes)
    # Q104: Ever worked? (if Q100=No and Q101=No)
    # Q105: When last worked? (if Q104=Yes) — routing depends on recency
    # =========================================================================
    - id: b_job_attachment
      title: "Job Attachment"
      items:
        # Q100: Last week, did person work at a job or business?
        - id: q_100
          kind: Question
          title: "Last week, did ... work at a job or business? (Regardless of the number of hours.)"
          codeBlock: |
            if q_100.outcome == 1:
              path = 1
            if q_100.outcome == 3:
              path = 7
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Permanently unable to work"

        # Q101: Had a job from which absent?
        # Only if Q100=No (outcome 2)
        - id: q_101
          kind: Question
          title: "Last week, did ... have a job or business from which he/she was absent?"
          precondition:
            - predicate: q_100.outcome == 2
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q102: More than one job last week?
        # Reached if Q100=Yes or Q101=Yes
        - id: q_102
          kind: Question
          title: "Did he/she have more than one job or business last week?"
          precondition:
            - predicate: q_100.outcome == 1 or q_101.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q103: Was this a result of changing employers?
        # Only if Q102=Yes
        - id: q_103
          kind: Question
          title: "Was this a result of changing employers?"
          precondition:
            - predicate: q_100.outcome == 1 or q_101.outcome == 1
            - predicate: q_102.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q104: Has ever worked?
        # Only if Q100=No and Q101=No
        - id: q_104
          kind: Question
          title: "Has he/she ever worked at a job or business?"
          precondition:
            - predicate: q_100.outcome == 2
            - predicate: q_101.outcome == 0
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q105: When did last work?
        # Only if Q104=Yes. Modeled as months since last worked (0-600).
        # Routing: if within past year (<=12) and not permanently unable -> job description;
        #   if permanently unable (q_100.outcome==3) -> absence/separation;
        #   if not recent -> job search.
        - id: q_105
          kind: Question
          title: "When did he/she last work? (Enter months since last employment, 0-600.)"
          precondition:
            - predicate: q_100.outcome == 2
            - predicate: q_101.outcome == 0
            - predicate: q_104.outcome == 1
          codeBlock: |
            if q_105.outcome <= 12:
              last_work_recent = 1
            else:
              last_work_recent = 0
          input:
            control: Editbox
            min: 0
            max: 600
            left: "Months:"

    # =========================================================================
    # BLOCK 2: JOB DESCRIPTION
    # =========================================================================
    # Q110-Q118: Employer type, business details, job description, start date.
    # Reached from: Q100=Yes (PATH=1), Q101=Yes, or Q105 recent and not PATH=7.
    # =========================================================================
    - id: b_job_description
      title: "Job Description"
      precondition:
        - predicate: "q_100.outcome == 1 or q_101.outcome == 1 or (q_104.outcome == 1 and last_work_recent == 1 and q_100.outcome != 3)"
      items:
        # Q110: Employee or self-employed?
        - id: q_110
          kind: Question
          title: "Was he/she an employee or self-employed?"
          input:
            control: Radio
            labels:
              1: "Employee"
              2: "Self-employed"
              3: "Working in a family business without pay"

        # Q111: Incorporated business? (only if self-employed)
        - id: q_111
          kind: Question
          title: "Did he/she have an incorporated business?"
          precondition:
            - predicate: q_110.outcome == 2
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q112: Any employees? (only if self-employed)
        - id: q_112
          kind: Question
          title: "Did he/she have any employees?"
          precondition:
            - predicate: q_110.outcome == 2
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q113: Name of business (only if self-employed)
        - id: q_113
          kind: Question
          title: "What was the name of his/her business?"
          precondition:
            - predicate: q_110.outcome == 2
          input:
            control: Textarea
            placeholder: "Enter business name"

        # Q114: For whom did person work? (if employee or unpaid family)
        - id: q_114
          kind: Question
          title: "For whom did he/she work? (Enter employer name.)"
          precondition:
            - predicate: q_110.outcome != 2
          input:
            control: Textarea
            placeholder: "Enter employer name"

        # Q115: What kind of business/industry?
        - id: q_115
          kind: Question
          title: "What kind of business, industry or service was this?"
          input:
            control: Textarea
            placeholder: "Describe the business or industry"

        # Q116: What kind of work?
        - id: q_116
          kind: Question
          title: "What kind of work was he/she doing?"
          input:
            control: Textarea
            placeholder: "Describe the kind of work"

        # Q117: Most important activities or duties?
        - id: q_117
          kind: Question
          title: "What were his/her most important activities or duties?"
          input:
            control: Textarea
            placeholder: "Describe main duties"

        # Q118: When did person start working for this employer?
        # Modeled as months employed (0-600)
        - id: q_118
          kind: Question
          title: "When did he/she start working for this employer? (Enter months employed, 0-600.)"
          input:
            control: Editbox
            min: 0
            max: 600
            left: "Months:"

    # =========================================================================
    # BLOCK 3: ABSENCE — SEPARATION
    # =========================================================================
    # Q130: Main reason absent (employed but absent). Sets path=2 for non-layoff.
    # Q131: Main reason stopped working (PATH=7, recent work, from Q105)
    # Q132: More specific reason for job loss (Q131=7)
    # Q133: Expect to return? (Q132=6, not PATH=7 — actually NEVER reachable
    #        from Q131 path since Q131 requires PATH=7; included for completeness)
    # Q134: Employer given date to return? (Q130=8 temp layoff)
    # Q135: Indication of recall? (Q134=No)
    # Q136: Weeks on layoff (Q130=9 seasonal, or Q134/Q135 chain)
    #        Sets is_temp_layoff=1 when recall expected within 52 weeks.
    # Q137: Usually work >=30 or <30 hours?
    # =========================================================================
    - id: b_absence
      title: "Absence and Separation"
      items:
        # Q130: Main reason absent from work last week
        # Shown when: Q101=Yes (had job but absent, Q100=2)
        # PATH=1 workers skip directly to work hours block.
        - id: q_130
          kind: Question
          title: "What was the main reason ... was absent from work last week?"
          precondition:
            - predicate: q_100.outcome == 2 and q_101.outcome == 1
          codeBlock: |
            if q_130.outcome not in [8, 9, 10]:
              path = 2
          input:
            control: Dropdown
            labels:
              1: "Own illness or disability"
              2: "Caring for own children"
              3: "Caring for elder relative"
              4: "Maternity or parental leave"
              5: "Other personal or family responsibilities"
              6: "Vacation"
              7: "Labour dispute"
              8: "Temporary layoff due to business conditions"
              9: "Seasonal layoff"
              10: "Casual job, no work available"
              11: "Work schedule"
              12: "Self-employed, no work available"
              13: "Seasonal business"
              14: "Other"

        # Q131: Main reason stopped working
        # Reached from Q105 path: ever worked, recent, permanently unable (Q100=3).
        - id: q_131
          kind: Question
          title: "What was the main reason ... stopped working at that job or business?"
          precondition:
            - predicate: q_100.outcome == 3
            - predicate: q_104.outcome == 1
            - predicate: last_work_recent == 1
          input:
            control: Dropdown
            labels:
              1: "Own illness or disability"
              2: "Caring for own children"
              3: "Caring for elder relative"
              4: "Pregnancy"
              5: "Other personal or family responsibilities"
              6: "Going to school"
              7: "Lost job, laid off or job ended"
              8: "Business sold or closed down"
              9: "Changed residence"
              10: "Dissatisfied with job"
              11: "Retired"
              12: "Other"

        # Q132: More specific reason for job loss
        # Only if Q131=7 (lost job)
        - id: q_132
          kind: Question
          title: "Can you be more specific about the main reason for his/her job loss?"
          precondition:
            - predicate: q_100.outcome == 3
            - predicate: q_104.outcome == 1
            - predicate: last_work_recent == 1
            - predicate: q_131.outcome == 7
          input:
            control: Dropdown
            labels:
              1: "End of seasonal job"
              2: "End of temporary/term/contract job"
              3: "Casual job"
              4: "Company moved"
              5: "Company went out of business"
              6: "Business conditions"
              7: "Dismissal by employer"
              8: "Other"

        # Q133: Expect to return to job?
        # Per inventory: Q132=6 (business conditions) and PATH!=7 -> Q133.
        # But Q131/Q132 path requires Q100=3 (PATH=7), so Q133 is structurally
        # unreachable from the Q131 chain. It would only be reachable if there
        # were a non-PATH=7 route to Q132, which doesn't exist.
        # Included for completeness; Z3 will classify as NEVER reachable.
        - id: q_133
          kind: Question
          title: "Does he/she expect to return to that job?"
          precondition:
            - predicate: q_131.outcome == 7
            - predicate: q_132.outcome == 6
            - predicate: q_100.outcome != 3
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Not sure"

        # Q134: Employer given date to return?
        # Reached from Q130=8 (temporary layoff due to business conditions)
        - id: q_134
          kind: Question
          title: "Has ...'s employer given him/her a date to return?"
          precondition:
            - predicate: q_100.outcome == 2 and q_101.outcome == 1
            - predicate: q_130.outcome == 8
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q135: Any indication of recall within 6 months?
        # Only if Q134=No
        - id: q_135
          kind: Question
          title: "Has he/she been given any indication that he/she will be recalled within the next 6 months?"
          precondition:
            - predicate: q_100.outcome == 2 and q_101.outcome == 1
            - predicate: q_130.outcome == 8
            - predicate: q_134.outcome == 0
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q136: How many weeks on layoff?
        # Reached from: Q130=9 (seasonal), Q134=Yes, or Q135 (either answer)
        # After: sets is_temp_layoff=1 and path=3 when conditions met
        - id: q_136
          kind: Question
          title: "As of last week, how many weeks had ... been on layoff?"
          precondition:
            - predicate: q_100.outcome == 2 and q_101.outcome == 1
            - predicate: q_130.outcome == 8 or q_130.outcome == 9
          codeBlock: |
            if q_130.outcome != 9:
              if q_134.outcome == 1:
                if q_136.outcome <= 52:
                  is_temp_layoff = 1
                  path = 3
              elif q_135.outcome == 1:
                if q_136.outcome <= 52:
                  is_temp_layoff = 1
                  path = 3
          input:
            control: Editbox
            min: 0
            max: 520
            left: "Weeks:"

        # Q137: Usually work more or less than 30 hours?
        # Reached from various absence/separation paths:
        # - Q130=10 (casual, no work)
        # - Q131 chain (all Q131 outcomes except Q131=7 which goes to Q132 first,
        #   then Q132 leads back to Q137 for most outcomes)
        # - Q136 chain (after layoff weeks question)
        # If is_temp_layoff=1 -> Q190 (availability); otherwise -> Q170 (job search)
        - id: q_137
          kind: Question
          title: "Did he/she usually work more or less than 30 hours per week?"
          precondition:
            - predicate: "(q_100.outcome == 2 and q_101.outcome == 1 and q_130.outcome in [8, 9, 10]) or (q_100.outcome == 3 and q_104.outcome == 1 and last_work_recent == 1)"
          input:
            control: Radio
            labels:
              1: "30 or more hours per week"
              2: "Less than 30 hours per week"

    # =========================================================================
    # BLOCK 4: WORK HOURS — MAIN JOB
    # =========================================================================
    # Q150-Q163: Hours worked, overtime, absence from job, part-time reasons.
    # Reached when: Q100=1 (at work, PATH=1) or
    #   Q130 answered with non-layoff reason (PATH=2, i.e., q_130 not in [8,9,10])
    # =========================================================================
    - id: b_work_hours
      title: "Work Hours - Main Job"
      precondition:
        - predicate: "q_100.outcome == 1 or (q_100.outcome == 2 and q_101.outcome == 1 and q_130.outcome not in [8, 9, 10])"
      items:
        # Q150: Does the number of paid hours vary week to week?
        - id: q_150
          kind: Question
          title: "Does the number of paid hours ... works vary from week to week? (Excluding overtime for employees.)"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q151: How many paid hours per week? (if hours don't vary)
        - id: q_151
          kind: Question
          title: "Excluding overtime, how many paid hours does ... work per week?"
          precondition:
            - predicate: q_150.outcome == 0
          codeBlock: |
            usual_hours = q_151.outcome
          input:
            control: Editbox
            min: 0
            max: 99
            left: "Hours:"

        # Q152: Average paid hours per week? (if hours vary)
        - id: q_152
          kind: Question
          title: "Excluding overtime, on average, how many paid hours does ... usually work per week?"
          precondition:
            - predicate: q_150.outcome == 1
          codeBlock: |
            usual_hours = q_152.outcome
          input:
            control: Editbox
            min: 0
            max: 99
            left: "Hours:"

        # Q153: Hours away from job last week
        # Only for employees (Q110=1) and PATH=1 (at work)
        # PATH=2 means absent, skip employee absence details to Q158
        - id: q_153
          kind: Question
          title: "Last week, how many hours was he/she away from this job because of vacation, illness, or any other reason?"
          precondition:
            - predicate: q_110.outcome == 1
            - predicate: q_100.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 99
            left: "Hours:"

        # Q154: Main reason for absence
        # Only if Q153 > 0
        - id: q_154
          kind: Question
          title: "What was the main reason for that absence?"
          precondition:
            - predicate: q_110.outcome == 1
            - predicate: q_100.outcome == 1
            - predicate: q_153.outcome > 0
          input:
            control: Dropdown
            labels:
              1: "Own illness or disability"
              2: "Caring for own children"
              3: "Caring for elder relative"
              4: "Maternity or parental leave"
              5: "Other personal or family responsibilities"
              6: "Vacation"
              7: "Labour dispute"
              8: "Temporary layoff due to business conditions"
              9: "Holiday"
              10: "Weather"
              11: "Job started or ended during week"
              12: "Working short-time"
              13: "Other"

        # Q155: Paid overtime hours last week
        # Only for employees and PATH=1
        - id: q_155
          kind: Question
          title: "Last week, how many hours of paid overtime did he/she work at this job?"
          precondition:
            - predicate: q_110.outcome == 1
            - predicate: q_100.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 99
            left: "Hours:"

        # Q156: Extra unpaid hours last week
        # Only for employees and PATH=1
        # Computes actual_hours when Q150=No (fixed hours)
        - id: q_156
          kind: Question
          title: "Last week, how many extra hours without pay did he/she work at this job?"
          precondition:
            - predicate: q_110.outcome == 1
            - predicate: q_100.outcome == 1
          codeBlock: |
            if q_150.outcome == 0:
              actual_hours = q_151.outcome - q_153.outcome + q_155.outcome + q_156.outcome
          input:
            control: Editbox
            min: 0
            max: 99
            left: "Hours:"

        # Q157: Actual hours worked last week
        # Shown when: Q150=Yes (hours vary) or not employee (self-employed/family)
        # Not shown when PATH=2 (absent, those skip to Q158)
        - id: q_157
          kind: Question
          title: "Last week, how many hours did he/she actually work at this job or business?"
          precondition:
            - predicate: q_100.outcome == 1
            - predicate: q_150.outcome == 1 or q_110.outcome != 1
          codeBlock: |
            actual_hours = q_157.outcome
          input:
            control: Editbox
            min: 0
            max: 99
            left: "Hours:"

        # Q158: Want to work >=30 hours?
        # Filter: if usual_hours >= 30 and PATH=2 -> Q162 (weeks absent)
        # Filter: if usual_hours >= 30 and PATH=1 -> Q200 (earnings)
        # Only shown when usual_hours < 30
        - id: q_158
          kind: Question
          title: "Does he/she want to work 30 or more hours per week at a single job?"
          precondition:
            - predicate: usual_hours < 30
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q159: Reason not wanting >=30 hours
        # Only if Q158=No
        - id: q_159
          kind: Question
          title: "What is the main reason ... does not want to work 30 or more hours per week?"
          precondition:
            - predicate: usual_hours < 30
            - predicate: q_158.outcome == 0
          input:
            control: Dropdown
            labels:
              1: "Own illness or disability"
              2: "Caring for own children"
              3: "Caring for elder relative"
              4: "Other personal or family responsibilities"
              5: "Going to school"
              6: "Personal preference"
              7: "Other"

        # Q160: Reason working <30 hours
        # Only if Q158=Yes (wants >=30 but works <30)
        - id: q_160
          kind: Question
          title: "What is the main reason ... usually works less than 30 hours per week at his/her main job?"
          precondition:
            - predicate: usual_hours < 30
            - predicate: q_158.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Own illness or disability"
              2: "Caring for own children"
              3: "Caring for elder relative"
              4: "Other personal or family responsibilities"
              5: "Going to school"
              6: "Business conditions"
              7: "Could not find work with 30 or more hours"
              8: "Other"

        # Q161: Looked for full-time work?
        # Only if Q160=6 or Q160=7 (involuntary part-time)
        - id: q_161
          kind: Question
          title: "At any time in the 4 weeks ending last Saturday, did he/she look for full-time work?"
          precondition:
            - predicate: usual_hours < 30
            - predicate: q_158.outcome == 1
            - predicate: q_160.outcome == 6 or q_160.outcome == 7
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q162: Weeks continuously absent from work
        # Only if PATH=2 (employed, absent = Q101=Yes and Q130 non-layoff)
        - id: q_162
          kind: Question
          title: "As of last week, how many weeks had ... been continuously absent from work?"
          precondition:
            - predicate: q_100.outcome == 2 and q_101.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 520
            left: "Weeks:"

        # Q163: Getting wages for time off?
        # Only if PATH=2 and (employee or incorporated self-employed)
        - id: q_163
          kind: Question
          title: "Is he/she getting any wages or salary from his/her employer or business for any time off last week?"
          precondition:
            - predicate: q_100.outcome == 2 and q_101.outcome == 1
            - predicate: q_110.outcome == 1 or (q_110.outcome == 2 and q_111.outcome == 1)
          input:
            control: Switch
            off: "No"
            on: "Yes"

    # =========================================================================
    # BLOCK 5: JOB SEARCH — FUTURE START
    # =========================================================================
    # Reached when person has no current job:
    # - Q104=No (never worked) -> Q170
    # - Q137 answered and not temp layoff -> Q170
    # - Q105 not recent (last_work_recent=0) -> Q170
    # - Q100=3 and Q104=No -> Q170 (but Q100=3 PATH=7 filter skips to Q500)
    #
    # Q170: Did anything to find work?
    # Q171-Q173: Job search details
    # Q174-Q175: Future job start
    # Q176-Q178: Want a job, reason not looking
    # =========================================================================
    - id: b_job_search
      title: "Job Search and Future Start"
      items:
        # Q170: Did anything to find work in past 4 weeks?
        # Filter: if PATH=7 (q_100.outcome==3) -> skip to Q500
        # Reached from: Q104=No (never worked), Q137 (not temp layoff),
        #   Q105 (not recent work)
        - id: q_170
          kind: Question
          title: "In the 4 weeks ending last Saturday, did ... do anything to find work?"
          precondition:
            - predicate: q_100.outcome != 3
            - predicate: "(q_100.outcome == 2 and q_101.outcome == 0 and q_104.outcome == 0) or (q_100.outcome == 2 and q_101.outcome == 0 and q_104.outcome == 1 and last_work_recent == 0) or (q_137.outcome in [1, 2] and is_temp_layoff == 0)"
          codeBlock: |
            if q_170.outcome == 1:
              path = 4
              search_status = 1
            if q_170.outcome == 0 and respondent_age >= 65:
              path = 6
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q171: What did to find work? (multi-select, power-of-2 keys)
        # Only if Q170=Yes (seeking work)
        - id: q_171
          kind: Question
          title: "What did he/she do to find work in those 4 weeks? (Mark all that apply.)"
          precondition:
            - predicate: q_170.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "Public employment agency"
              2: "Private employment agency"
              4: "Union"
              8: "Employers directly"
              16: "Friends or relatives"
              32: "Placed or answered ads"
              64: "Looked at job ads"
              128: "Other"

        # Q172: Weeks looking for work
        # Only if Q170=Yes
        - id: q_172
          kind: Question
          title: "As of last week, how many weeks had he/she been looking for work?"
          precondition:
            - predicate: q_170.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 520
            left: "Weeks:"

        # Q173: Main activity before looking for work
        # Only if Q170=Yes
        - id: q_173
          kind: Question
          title: "What was his/her main activity before he/she started looking for work?"
          precondition:
            - predicate: q_170.outcome == 1
          input:
            control: Radio
            labels:
              1: "Working"
              2: "Managing a home"
              3: "Going to school"
              4: "Other"

        # Q174: Have a future job to start?
        # Only if Q170=No and age < 65
        - id: q_174
          kind: Question
          title: "Last week, did ... have a job to start at a definite date in the future?"
          precondition:
            - predicate: q_170.outcome == 0
            - predicate: respondent_age < 65
          codeBlock: |
            if q_174.outcome == 0:
              path = 6
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q175: Start before or after 4-week date?
        # Only if Q174=Yes
        - id: q_175
          kind: Question
          title: "Will he/she start that job before or after 4 weeks from now?"
          precondition:
            - predicate: q_170.outcome == 0
            - predicate: respondent_age < 65
            - predicate: q_174.outcome == 1
          codeBlock: |
            if q_175.outcome == 1:
              path = 5
              search_status = 2
            else:
              path = 6
          input:
            control: Radio
            labels:
              1: "Before (within 4 weeks)"
              2: "On or after (more than 4 weeks)"

        # Q176: Want a job last week?
        # Only if Q174=No (no future job, PATH=6)
        - id: q_176
          kind: Question
          title: "Did he/she want a job last week?"
          precondition:
            - predicate: q_170.outcome == 0
            - predicate: respondent_age < 65
            - predicate: q_174.outcome == 0
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q177: Want >=30 or <30 hours?
        # Reached from: Q173 (job seekers) or Q176=Yes (want a job)
        - id: q_177
          kind: Question
          title: "Did he/she want a job with 30 or more hours per week, or less than 30 hours?"
          precondition:
            - predicate: q_170.outcome == 1 or (q_174.outcome == 0 and q_176.outcome == 1)
          input:
            control: Radio
            labels:
              1: "30 or more hours per week"
              2: "Less than 30 hours per week"

        # Q178: Reason not looking for work
        # Reached from Q177 when not a job seeker (i.e., Q176=Yes path only)
        # Filter: if PATH=4 (Q170=Yes, job seeker) -> Q190 directly
        - id: q_178
          kind: Question
          title: "What was the main reason he/she did not look for work last week?"
          precondition:
            - predicate: q_170.outcome == 0
            - predicate: q_174.outcome == 0 and q_176.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Own illness or disability"
              2: "Caring for own children"
              3: "Caring for elder relative"
              4: "Other personal or family responsibilities"
              5: "Going to school"
              6: "Waiting for recall"
              7: "Waiting for replies from employers"
              8: "Believes no work available"
              9: "No reason given"
              10: "Other"

    # =========================================================================
    # BLOCK 6: AVAILABILITY
    # =========================================================================
    # Q190: Could have worked last week?
    # Q191: Reason not available
    #
    # Reached from: is_temp_layoff=1 (PATH=3 via Q137),
    #   search_status=1 (PATH=4, job seeker via Q170=Yes),
    #   search_status=2 (PATH=5, future start via Q175=1),
    #   Q178=8 (believes no work available, discouraged worker)
    # =========================================================================
    - id: b_availability
      title: "Availability"
      precondition:
        - predicate: "is_temp_layoff == 1 or search_status in [1, 2] or q_178.outcome == 8"
      items:
        # Q190: Could have worked last week?
        - id: q_190
          kind: Question
          title: "Could he/she have worked last week if recalled or if a suitable job had been offered?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q191: Reason not available
        # Only if Q190=No
        - id: q_191
          kind: Question
          title: "What was the main reason ... was not available to work last week?"
          precondition:
            - predicate: q_190.outcome == 0
          input:
            control: Dropdown
            labels:
              1: "Own illness or disability"
              2: "Caring for own children"
              3: "Caring for elder relative"
              4: "Other personal or family responsibilities"
              5: "Going to school"
              6: "Vacation"
              7: "Already has a job"
              8: "Other"

    # =========================================================================
    # BLOCK 7: EARNINGS — UNION — PERMANENCE
    # =========================================================================
    # Q200-Q262: Only for employees (Q110=1) on the employed path.
    # Reached from work hours block (PATH=1 or PATH=2).
    # =========================================================================
    - id: b_earnings
      title: "Earnings, Union, and Permanence"
      precondition:
        - predicate: "q_100.outcome == 1 or (q_100.outcome == 2 and q_101.outcome == 1 and q_130.outcome not in [8, 9, 10])"
        - predicate: q_110.outcome == 1
      items:
        # Q200: Paid by the hour?
        - id: q_200
          kind: Question
          title: "Is he/she paid by the hour?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q201: Receive tips or commissions?
        - id: q_201
          kind: Question
          title: "Does he/she usually receive tips or commissions?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q202: Hourly rate of pay
        # Only if Q200=Yes (paid by hour)
        - id: q_202
          kind: Question
          title: "Including tips and commissions, what is his/her hourly rate of pay?"
          precondition:
            - predicate: q_200.outcome == 1
          postcondition:
            - predicate: q_202.outcome >= 1
              hint: "Hourly rate must be at least $1."
          input:
            control: Editbox
            min: 0
            max: 999
            left: "$"
            right: "per hour"

        # Q204: Easiest way to report wage
        # Only if Q200=No (not paid by hour)
        - id: q_204
          kind: Question
          title: "What is the easiest way for you to tell us his/her wage or salary, including tips and commissions, before taxes and other deductions?"
          precondition:
            - predicate: q_200.outcome == 0
          input:
            control: Dropdown
            labels:
              1: "Yearly"
              2: "Monthly"
              3: "Semi-monthly"
              4: "Bi-weekly"
              5: "Weekly"
              6: "Other"

        # Q205: Weekly wage
        # Only if Q204=5 (weekly) or Q204=6 (other)
        - id: q_205
          kind: Question
          title: "Including tips and commissions, what is his/her weekly wage or salary, before taxes and other deductions?"
          precondition:
            - predicate: q_200.outcome == 0
            - predicate: q_204.outcome == 5 or q_204.outcome == 6
          input:
            control: Editbox
            min: 0
            max: 99999
            left: "$"
            right: "per week"

        # Q206: Bi-weekly wage
        # Only if Q204=4
        - id: q_206
          kind: Question
          title: "Including tips and commissions, what is his/her bi-weekly wage or salary, before taxes and other deductions?"
          precondition:
            - predicate: q_200.outcome == 0
            - predicate: q_204.outcome == 4
          input:
            control: Editbox
            min: 0
            max: 99999
            left: "$"
            right: "bi-weekly"

        # Q207: Semi-monthly wage
        # Only if Q204=3
        - id: q_207
          kind: Question
          title: "Including tips and commissions, what is his/her semi-monthly wage or salary, before taxes and other deductions?"
          precondition:
            - predicate: q_200.outcome == 0
            - predicate: q_204.outcome == 3
          input:
            control: Editbox
            min: 0
            max: 99999
            left: "$"
            right: "semi-monthly"

        # Q208: Monthly wage
        # Only if Q204=2
        - id: q_208
          kind: Question
          title: "Including tips and commissions, what is his/her monthly wage or salary, before taxes and other deductions?"
          precondition:
            - predicate: q_200.outcome == 0
            - predicate: q_204.outcome == 2
          input:
            control: Editbox
            min: 0
            max: 99999
            left: "$"
            right: "per month"

        # Q209: Yearly wage
        # Only if Q204=1
        - id: q_209
          kind: Question
          title: "Including tips and commissions, what is his/her yearly wage or salary, before taxes and other deductions?"
          precondition:
            - predicate: q_200.outcome == 0
            - predicate: q_204.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 9999999
            left: "$"
            right: "per year"

        # Q220: Union member?
        - id: q_220
          kind: Question
          title: "Is he/she a union member at this employer?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q221: Covered by union contract?
        # Only if Q220=No (not a member)
        - id: q_221
          kind: Question
          title: "Is he/she covered by a union contract or collective agreement?"
          precondition:
            - predicate: q_220.outcome == 0
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q240: Is job permanent?
        - id: q_240
          kind: Question
          title: "Is ...'s job at this employer permanent, or is there some way that it is not permanent?"
          input:
            control: Radio
            labels:
              1: "Permanent"
              2: "Not permanent"

        # Q241: How not permanent?
        # Only if Q240=2
        - id: q_241
          kind: Question
          title: "In what way is his/her job not permanent?"
          precondition:
            - predicate: q_240.outcome == 2
          input:
            control: Radio
            labels:
              1: "Seasonal job"
              2: "Temporary/term/contract job"
              3: "Casual job"
              5: "Other"

        # Q260: Persons at work location
        - id: q_260
          kind: Question
          title: "About how many persons are employed at the location where ... works? Would it be:"
          input:
            control: Radio
            labels:
              1: "Less than 20"
              2: "20 to 99"
              3: "100 to 500"
              4: "Over 500"

        # Q261: Employer has multiple locations?
        - id: q_261
          kind: Question
          title: "Does this employer operate at more than one location?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q262: Persons at all locations
        # Only if Q261=Yes and Q260 != 4 (not already >500)
        - id: q_262
          kind: Question
          title: "In total, about how many persons are employed at all locations?"
          precondition:
            - predicate: q_261.outcome == 1
            - predicate: q_260.outcome != 4
          input:
            control: Radio
            labels:
              1: "Less than 20"
              2: "20 to 99"
              3: "100 to 500"
              4: "Over 500"

    # =========================================================================
    # BLOCK 8: CLASS OF WORKER — OTHER JOB
    # =========================================================================
    # Q300-Q321: Details about other/second job.
    # Filter: Q102=No (only one job) -> skip to Q400/Q500
    # =========================================================================
    - id: b_other_job
      title: "Class of Worker - Other Job"
      precondition:
        - predicate: "q_100.outcome == 1 or (q_100.outcome == 2 and q_101.outcome == 1 and q_130.outcome not in [8, 9, 10])"
        - predicate: q_102.outcome == 1
      items:
        # Q300: Employee or self-employed (other job)?
        - id: q_300
          kind: Question
          title: "At his/her other job, was he/she an employee or self-employed?"
          input:
            control: Radio
            labels:
              1: "Employee"
              2: "Self-employed"
              3: "Working in a family business without pay"

        # Q301: Incorporated business (other)?
        # Only if Q300=2 (self-employed)
        - id: q_301
          kind: Question
          title: "Did he/she have an incorporated business at the other job?"
          precondition:
            - predicate: q_300.outcome == 2
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q302: Any employees (other)?
        # Only if Q300=2 (self-employed)
        - id: q_302
          kind: Question
          title: "Did he/she have any employees at the other job?"
          precondition:
            - predicate: q_300.outcome == 2
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q320: Usual hours at other job
        - id: q_320
          kind: Question
          title: "Excluding overtime, how many paid hours does ... usually work per week at this other job?"
          input:
            control: Editbox
            min: 0
            max: 99
            left: "Hours:"

        # Q321: Actual hours at other job last week
        # Not asked if PATH=2 (absent from work: Q100=2 and Q101=1)
        - id: q_321
          kind: Question
          title: "Last week, how many hours did ... actually work at this other job or business?"
          precondition:
            - predicate: q_100.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 99
            left: "Hours:"

    # =========================================================================
    # BLOCK 9: TEMPORARY LAYOFF JOB SEARCH
    # =========================================================================
    # Q400: Did person look for a job with a different employer?
    # Filter: Only if is_temp_layoff=1 (PATH=3 equivalent)
    # =========================================================================
    - id: b_layoff_search
      title: "Temporary Layoff Job Search"
      precondition:
        - predicate: is_temp_layoff == 1
      items:
        # Q400: Look for different employer job?
        - id: q_400
          kind: Question
          title: "In the 4 weeks ending last Saturday, did ... look for a job with a different employer?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

    # =========================================================================
    # BLOCK 10: SCHOOL ATTENDANCE
    # =========================================================================
    # Q500-Q521: School attendance and student status.
    # Filter: age >= 65 -> END (block precondition)
    # =========================================================================
    - id: b_school
      title: "School Attendance"
      precondition:
        - predicate: respondent_age < 65
      items:
        # Q500: Attending school, college, or university?
        - id: q_500
          kind: Question
          title: "Last week, was ... attending a school, college or university?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q501: Full-time or part-time?
        # Only if Q500=Yes
        - id: q_501
          kind: Question
          title: "Was he/she enrolled as a full-time or part-time student?"
          precondition:
            - predicate: q_500.outcome == 1
          input:
            control: Radio
            labels:
              1: "Full-time"
              2: "Part-time"

        # Q502: What kind of school?
        # Only if Q500=Yes
        - id: q_502
          kind: Question
          title: "What kind of school was this?"
          precondition:
            - predicate: q_500.outcome == 1
          input:
            control: Radio
            labels:
              1: "Elementary/junior high/high school"
              2: "Community college/CEGEP"
              3: "University"
              4: "Other"

        # Q520: Full-time student in March?
        # Filter: Only during May-August and age 15-24
        # Modeled with age constraint only (survey month is runtime metadata)
        - id: q_520
          kind: Question
          title: "Was ... a full-time student in March of this year? (Asked during May-August for ages 15-24 only.)"
          precondition:
            - predicate: respondent_age >= 15
            - predicate: respondent_age <= 24
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q521: Expect full-time student this fall?
        # Only if Q520=Yes
        - id: q_521
          kind: Question
          title: "Does ... expect to be a full-time student this fall?"
          precondition:
            - predicate: respondent_age >= 15
            - predicate: respondent_age <= 24
            - predicate: q_520.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Not sure"
