qmlVersion: "1.0"
questionnaire:
  title: "Survey of Labour and Income Dynamics"
  codeInit: |
    # =====================================================================
    # Cross-section variables. With a single codeInit scope and one
    # dependency graph, variables written by an earlier block are visible
    # to every later block without any extern declaration.
    # =====================================================================
    has_employer_j1 = 0
    temp_layoff = 0
    no_recent_work = 0
    current_marriage_year = 0

  blocks:

    # ===================================================================
    # SECTION: employment_status
    # ===================================================================
    # =========================================================================
    # BLOCK 1: MAIN EMPLOYMENT STATUS
    # =========================================================================
    # Items 1-19 from inventory (Q1 through Q13) plus J1.Q1 and J1.Q1A
    # (the two mutually exclusive entry points into employer details).
    #
    # Routing overview:
    #   Q1=1 (Yes, worked) -> J1.Q1 (employer details)
    #   Q1=2 (No) -> Q2 (absent job check)
    #   Q1=3 (Permanently unable) -> Q5 (ever worked)
    #   Q1=DK/R -> N12 age check (modeled by falling through)
    #
    # Block precondition: age >= 15 (START-EMPPRE gate)
    # =========================================================================
    - id: b_emppre_main
      title: "Current or Recent Work Activity"
      precondition:
        - predicate: age >= 15
      items:
        # Q1: Did respondent work at a job or business in early January?
        - id: q_employment_status_q1
          kind: Question
          title: "Did the respondent work at a job or business at the beginning of January of this year? (Enter a job regardless of the number of hours worked.)"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Permanently unable to work"

        # Q2: Had a job but absent? (only if Q1=No)
        - id: q_employment_status_q2
          kind: Question
          title: "Did the respondent have a job or business at which he/she did not work at the beginning of January?"
          precondition:
            - predicate: q_employment_status_q1.outcome == 2
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q3: Why absent from work? (only if Q2=Yes)
        - id: q_employment_status_q3
          kind: Question
          title: "Why was the respondent absent from work at the beginning of January?"
          precondition:
            - predicate: q_employment_status_q1.outcome == 2
            - predicate: q_employment_status_q2.outcome == 1
          codeBlock: |
            if q_employment_status_q3.outcome == 8 or q_employment_status_q3.outcome == 9:
              temp_layoff = 1
          input:
            control: Dropdown
            labels:
              1: "Own illness or disability"
              2: "Pregnancy"
              3: "Caring for own children"
              4: "Caring for elder relatives"
              5: "Other personal or family responsibilities"
              6: "School or educational leave"
              7: "Labour dispute"
              8: "Temporary layoff due to seasonal conditions"
              9: "Temporary layoff - non seasonal"
              10: "Unpaid or partially paid vacation"
              11: "Other (Specify)"

        # Q3 Other specify
        - id: q_q3_other
          kind: Question
          title: "Please specify the reason for absence from work:"
          precondition:
            - predicate: q_employment_status_q1.outcome == 2
            - predicate: q_employment_status_q2.outcome == 1
            - predicate: q_employment_status_q3.outcome == 11
          input:
            control: Textarea
            placeholder: "Specify reason..."
            maxLength: 200

        # Q4: Did respondent receive pay during absence?
        # Reached when Q2=Yes and Q3 is NOT school (6)
        # (If Q3=6 -> goes to Q5 instead)
        - id: q_employment_status_q4
          kind: Question
          title: "Did the respondent receive any pay from his/her employer for this absence?"
          precondition:
            - predicate: q_employment_status_q1.outcome == 2
            - predicate: q_employment_status_q2.outcome == 1
            - predicate: q_employment_status_q3.outcome != 6
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # --- N4 filter: if Q3=temp layoff (8 or 9) -> Q8; else -> J1.Q1 ---
        # J1.Q1 entry is handled below; Q8 routing uses temp_layoff variable.

        # J1.Q1: Main employer name (entry point when Q1=Yes or Q2=Yes+not-layoff)
        # Reached when:
        #   - Q1=1 (Yes, worked) directly
        #   - Q2=Yes AND Q3 is NOT school(6) AND NOT temp layoff(8,9)
        - id: q_j1_q1
          kind: Question
          title: "I would like to ask a few questions about the respondent's main job or business in early January. For whom did the respondent work? (Name of business, government department, or agency, or person.)"
          precondition:
            - predicate: q_employment_status_q1.outcome == 1 or (q_employment_status_q1.outcome == 2 and q_employment_status_q2.outcome == 1 and q_employment_status_q3.outcome not in [6, 8, 9])
          codeBlock: |
            has_employer_j1 = 1
          input:
            control: Textarea
            placeholder: "Enter employer name..."
            maxLength: 500

        # Q5: Did respondent ever work?
        # Reached from:
        #   - Q1=3 (permanently unable) directly
        #   - Q2=No (Q1=2 and Q2=0)
        #   - Q3=6 (school/educational leave, Q1=2 and Q2=1)
        - id: q_employment_status_q5
          kind: Question
          title: "Did the respondent ever work at a job or business?"
          precondition:
            - predicate: q_employment_status_q1.outcome == 3 or (q_employment_status_q1.outcome == 2 and q_employment_status_q2.outcome == 0) or (q_employment_status_q1.outcome == 2 and q_employment_status_q2.outcome == 1 and q_employment_status_q3.outcome == 6)
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q6: When did respondent last work? (year only, if Q5=Yes)
        - id: q_employment_status_q6
          kind: Question
          title: "When did the respondent last work at a job or business? (Enter the year.)"
          precondition:
            - predicate: q_employment_status_q1.outcome == 3 or (q_employment_status_q1.outcome == 2 and q_employment_status_q2.outcome == 0) or (q_employment_status_q1.outcome == 2 and q_employment_status_q2.outcome == 1 and q_employment_status_q3.outcome == 6)
            - predicate: q_employment_status_q5.outcome == 1
          input:
            control: Editbox
            min: 1900
            max: 2100
            right: "year"

        # --- N6 filter: If Q6 before (current_year - 5) AND Q1=3 -> N12 (exit) ---
        # Otherwise -> Q7
        # We cannot do arithmetic in preconditions, so we model this as:
        # Q7 is shown UNLESS Q1=3 AND Q6 is old (handled by codeBlock on Q6 to
        # set a variable). Actually, we CAN use arithmetic in predicates since
        # they are Python expressions. Let's use: q_employment_status_q6.outcome < current_year - 5
        # combined with q_employment_status_q1.outcome == 3 to skip Q7.

        # Q7: Main reason for leaving last job (if Q5=Yes and not filtered by N6)
        # N6 filter: skip to N12 when Q6 < (current_year - 5) AND Q1=3
        # So Q7 shown when Q5=Yes and NOT (Q6 old AND Q1=permanently unable)
        - id: q_employment_status_q7
          kind: Question
          title: "What was the respondent's main reason for leaving this job?"
          precondition:
            - predicate: q_employment_status_q1.outcome == 3 or (q_employment_status_q1.outcome == 2 and q_employment_status_q2.outcome == 0) or (q_employment_status_q1.outcome == 2 and q_employment_status_q2.outcome == 1 and q_employment_status_q3.outcome == 6)
            - predicate: q_employment_status_q5.outcome == 1
            - predicate: not (q_employment_status_q1.outcome == 3 and q_employment_status_q6.outcome < current_year - 5)
          input:
            control: Dropdown
            labels:
              1: "Own illness, disability"
              2: "Caring for own children"
              3: "Caring for elder relatives"
              4: "Other personal or family responsibilities"
              5: "Going to school"
              6: "Quit job for no specific reason"
              7: "Lost job or laid off (paid workers only)"
              8: "Changed residence"
              9: "Dissatisfied with job"
              10: "Retired"
              11: "Other (Specify)"

        # Q7 Other specify
        - id: q_q7_other
          kind: Question
          title: "Please specify the reason for leaving the job:"
          precondition:
            - predicate: q_employment_status_q1.outcome == 3 or (q_employment_status_q1.outcome == 2 and q_employment_status_q2.outcome == 0) or (q_employment_status_q1.outcome == 2 and q_employment_status_q2.outcome == 1 and q_employment_status_q3.outcome == 6)
            - predicate: q_employment_status_q5.outcome == 1
            - predicate: not (q_employment_status_q1.outcome == 3 and q_employment_status_q6.outcome < current_year - 5)
            - predicate: q_employment_status_q7.outcome == 11
          input:
            control: Textarea
            placeholder: "Specify reason..."
            maxLength: 200

        # --- N7 filter: If Q1=3 (permanently unable) -> N12 (exit) ---
        # Otherwise -> Q8
        # So Q8 is shown when respondent is NOT permanently unable AND
        # is on one of the paths that reach N7.
        #
        # Q8 is reached from:
        #   - N4: temp layoff (Q1=2, Q2=1, Q3 in [8,9]) -> Q8
        #   - N7: Q5=No path when Q1 != 3  -> Q8
        #   - N7: Q7 completed and Q1 != 3 -> Q8

        # Q8: Did respondent look for work in January?
        # Reached from temp_layoff path OR non-permanently-unable Q5/Q7 path
        - id: q_employment_status_q8
          kind: Question
          title: "Did the respondent look for work in January of this year?"
          precondition:
            - predicate: q_employment_status_q1.outcome != 1
            - predicate: q_employment_status_q1.outcome != 3
            - predicate: temp_layoff == 1 or q_employment_status_q5.outcome == 0 or q_employment_status_q5.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q9: Methods of job search (multi select, if Q8=Yes)
        - id: q_employment_status_q9
          kind: Question
          title: "What did the respondent do to find work?"
          precondition:
            - predicate: q_employment_status_q1.outcome != 1
            - predicate: q_employment_status_q1.outcome != 3
            - predicate: temp_layoff == 1 or q_employment_status_q5.outcome == 0 or q_employment_status_q5.outcome == 1
            - predicate: q_employment_status_q8.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "Contacted employer directly"
              2: "Friend or relative"
              4: "Placed or answered newspaper ad"
              8: "Employment agency"
              16: "Referral from another employer"
              32: "Other (specify)"

        # Q9 Other specify
        - id: q_q9_other
          kind: Question
          title: "Please specify the other method of job search:"
          precondition:
            - predicate: q_employment_status_q1.outcome != 1
            - predicate: q_employment_status_q1.outcome != 3
            - predicate: temp_layoff == 1 or q_employment_status_q5.outcome == 0 or q_employment_status_q5.outcome == 1
            - predicate: q_employment_status_q8.outcome == 1
            - predicate: q_employment_status_q9.outcome % 64 >= 32
          input:
            control: Textarea
            placeholder: "Specify method..."
            maxLength: 200

        # Q10: Looked for work in prior 6 months? (if Q8=No)
        - id: q_employment_status_q10
          kind: Question
          title: "Did the respondent look for work at any time in the 6 months before that?"
          precondition:
            - predicate: q_employment_status_q1.outcome != 1
            - predicate: q_employment_status_q1.outcome != 3
            - predicate: temp_layoff == 1 or q_employment_status_q5.outcome == 0 or q_employment_status_q5.outcome == 1
            - predicate: q_employment_status_q8.outcome == 0
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q11: Reasons for not looking (multi select, if Q10=Yes)
        - id: q_employment_status_q11
          kind: Question
          title: "What were the reasons the respondent did not look for work in January of this year? (If only answered own illness or personal responsibilities, probe for other reasons.)"
          precondition:
            - predicate: q_employment_status_q1.outcome != 1
            - predicate: q_employment_status_q1.outcome != 3
            - predicate: temp_layoff == 1 or q_employment_status_q5.outcome == 0 or q_employment_status_q5.outcome == 1
            - predicate: q_employment_status_q8.outcome == 0
            - predicate: q_employment_status_q10.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "Own illness, disability"
              2: "Caring for own children"
              4: "Caring for elder relatives"
              8: "Other personal or family responsibilities"
              16: "Going to school"
              32: "No longer interested in finding work"
              64: "Waiting for recall (to former job)"
              128: "Has found new job"
              256: "Waiting for replies from employers"
              512: "Believes no work available (in area, or suited to skills)"
              1024: "No reason given"
              2048: "Other (Specify)"

        # Q11 Other specify
        - id: q_q11_other
          kind: Question
          title: "Please specify the other reason for not looking for work:"
          precondition:
            - predicate: q_employment_status_q1.outcome != 1
            - predicate: q_employment_status_q1.outcome != 3
            - predicate: temp_layoff == 1 or q_employment_status_q5.outcome == 0 or q_employment_status_q5.outcome == 1
            - predicate: q_employment_status_q8.outcome == 0
            - predicate: q_employment_status_q10.outcome == 1
            - predicate: q_employment_status_q11.outcome % 4096 >= 2048
          input:
            control: Textarea
            placeholder: "Specify reason..."
            maxLength: 200

        # --- N11A filter: If Q5=No (never worked) OR Q6 < reference_year -> N12 ---
        # Otherwise -> J1.Q1A
        # We set no_recent_work in codeBlocks above; instead use outcome refs.

        # J1.Q1A: Last employer name (entry from N11A when Q5=Yes and Q6 >= reference_year)
        # Reached through the Q8-Q11 search path, then N11A passes.
        # N11A passes (goes to J1.Q1A) when:
        #   - Q5=Yes (outcome 1) AND Q6 >= reference_year (January of ref year)
        # N11A fails (goes to N12) when:
        #   - Q5=No (outcome 0) OR Q6 < reference_year
        - id: q_j1_q1a
          kind: Question
          title: "I would like to ask a few questions about the last job or business held by the respondent in the reference year. For whom did the respondent work? (Name of business, government department, or agency, or person.)"
          precondition:
            - predicate: q_employment_status_q1.outcome != 1
            - predicate: q_employment_status_q1.outcome != 3
            - predicate: q_employment_status_q5.outcome == 1
            - predicate: q_employment_status_q6.outcome >= reference_year
          codeBlock: |
            has_employer_j1 = 1
          input:
            control: Textarea
            placeholder: "Enter employer name..."
            maxLength: 500

        # --- N12 filter: age > 64 -> end of file; else -> Q12 ---

        # Q12: Attending school in January? (if age <= 64)
        # N12 is reached from many paths. Rather than enumerate them all,
        # Q12 applies to anyone age <= 64 who did NOT enter the J1 employer
        # path via J1.Q1 (those go through J1 block first, then may come
        # back to N12 which leads here too). We model N12 as: Q12 is shown
        # when age <= 64 and the respondent has passed through to this point.
        #
        # The key insight: Q12 is reached by everyone who hits N12 and age <= 64.
        # N12 is the convergence point. Everyone eventually reaches N12 (except
        # those who exit via J1.Q6 unpaid worker or J1.Q7A started-this-year).
        # For simplicity, we use age <= 64 and exclude Q1=1 path (they go
        # through J1 first and J1 items route to N12 themselves).
        # Actually, Q12 should be shown to anyone who reaches N12 with age<=64.
        # Since J2 block also exits to N12, Q12 needs to be reachable from all
        # those paths. We place it here in main block since it logically belongs
        # to the main flow, and it doesn't need has_employer_j1 gating.
        #
        # Precondition: age <= 64 (anyone over 64 exits to EXPRE).
        # No other gating needed — if none of the J1/J2 paths are taken,
        # respondent falls through to here; if they ARE taken, J1/J2 blocks
        # complete first and then Q12 is evaluated.
        - id: q_employment_status_q12
          kind: Question
          title: "In January of this year, was the respondent attending a school, college or university?"
          precondition:
            - predicate: age <= 64
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q13: Full-time or part-time student? (if Q12=Yes)
        - id: q_employment_status_q13
          kind: Question
          title: "Was the respondent enrolled as a full-time or part-time student?"
          precondition:
            - predicate: age <= 64
            - predicate: q_employment_status_q12.outcome == 1
          input:
            control: Radio
            labels:
              1: "Full-time student"
              2: "Part-time student"
              3: "Some of each"

    # =========================================================================
    # BLOCK 2: FIRST EMPLOYER DETAILS (J1)
    # =========================================================================
    # Items J1.Q2 through J1.Q15 (inventory items 22-39).
    # Entered when has_employer_j1 == 1 (set by J1.Q1 or J1.Q1A).
    # =========================================================================
    - id: b_emppre_job1
      title: "First Employer Details"
      precondition:
        - predicate: age >= 15
        - predicate: has_employer_j1 == 1
      items:
        # J1.Q2: When first started working for this employer (year)
        - id: q_j1_q2
          kind: Question
          title: "When was the first time the respondent started working for this employer? (Enter the year.)"
          input:
            control: Editbox
            min: 1900
            max: 2100
            right: "year"

        # J1.N2 filter / J1.Q2A consistency check
        # N2: if Q2 date is before Q6 date -> OK (Q3); if after -> Q2A warning
        # We model Q2A as a Comment (interviewer note) shown when dates are inconsistent.
        - id: q_j1_q2a
          kind: Comment
          title: "Interviewer: Date first started working for this employer is after the date last worked. Go back to correct inconsistencies, or continue."
          precondition:
            - predicate: q_employment_status_q5.outcome == 1
            - predicate: q_j1_q2.outcome > q_employment_status_q6.outcome

        # J1.Q3: Industry/business type
        - id: q_j1_q3
          kind: Question
          title: "What kind of business, industry or service was this? (e.g., federal government, canning industry, forestry service)"
          input:
            control: Textarea
            placeholder: "Enter industry or business type..."
            maxLength: 500

        # J1.Q4: Occupation/kind of work
        - id: q_j1_q4
          kind: Question
          title: "What kind of work was the respondent doing? (e.g., office clerk, factory worker, forestry technician)"
          input:
            control: Textarea
            placeholder: "Enter occupation..."
            maxLength: 500

        # J1.Q5: Main duties
        - id: q_j1_q5
          kind: Question
          title: "What were the respondent's most important activities or duties? (e.g., filing documents, drying vegetables, forest examiner)"
          input:
            control: Textarea
            placeholder: "Enter main duties..."
            maxLength: 500

        # J1.Q6: Class of worker
        # Paid worker or DK/R -> J1.Q7A; Otherwise (unpaid/self-employed) -> N12
        - id: q_j1_q6
          kind: Question
          title: "In this job, was the respondent a paid worker, self-employed or an unpaid family worker?"
          input:
            control: Radio
            labels:
              1: "Paid worker"
              2: "Unpaid family worker"
              3: "Self-employed Incorporated - With paid help"
              4: "Self-employed Incorporated - No paid help"
              5: "Self-employed Unincorporated - With paid help"
              6: "Self-employed Unincorporated - No paid help"

        # J1.Q7A: Months worked in reference year
        # Only for paid workers (Q6=1)
        - id: q_j1_q7a
          kind: Question
          title: "In which months of the reference year did the respondent work at this job?"
          precondition:
            - predicate: q_j1_q6.outcome == 1
          input:
            control: Radio
            labels:
              1: "All months"
              2: "Started in current year"
              3: "Specify months"
              4: "Last worked before reference year"

        # J1.Q7B: Specify months (if Q7A=3 or Q7A=4)
        - id: q_j1_q7b
          kind: Question
          title: "Specify the months the respondent worked in the reference year:"
          precondition:
            - predicate: q_j1_q6.outcome == 1
            - predicate: q_j1_q7a.outcome == 3 or q_j1_q7a.outcome == 4
          input:
            control: Checkbox
            labels:
              1: "January"
              2: "February"
              4: "March"
              8: "April"
              16: "May"
              32: "June"
              64: "July"
              128: "August"
              256: "September"
              512: "October"
              1024: "November"
              2048: "December"

        # J1.Q8: Worked every week of the month?
        # Reached when Q7A=1 (all months) or after Q7B
        # Not reached when Q7A=2 (started current year -> N12 exit)
        - id: q_j1_q8
          kind: Question
          title: "At this job, did the respondent usually work every week of the month?"
          precondition:
            - predicate: q_j1_q6.outcome == 1
            - predicate: q_j1_q7a.outcome != 2
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # J1.Q9: Weeks per month (if Q8=No)
        - id: q_j1_q9
          kind: Question
          title: "How many weeks did the respondent usually work each month?"
          precondition:
            - predicate: q_j1_q6.outcome == 1
            - predicate: q_j1_q7a.outcome != 2
            - predicate: q_j1_q8.outcome == 0
          input:
            control: Editbox
            min: 1
            max: 3
            right: "weeks"

        # J1.Q10: Hours per week usually paid
        - id: q_j1_q10
          kind: Question
          title: "How many hours per week did the respondent usually get paid?"
          precondition:
            - predicate: q_j1_q6.outcome == 1
            - predicate: q_j1_q7a.outcome != 2
          input:
            control: Editbox
            min: 1
            max: 99
            right: "hours"

        # J1.Q11A: Wage or salary before deductions
        - id: q_j1_q11a
          kind: Question
          title: "At this job, what was the respondent's wage or salary before taxes and deductions? (As of January or when they last worked for this employer in the reference year.)"
          precondition:
            - predicate: q_j1_q6.outcome == 1
            - predicate: q_j1_q7a.outcome != 2
          input:
            control: Editbox
            min: 1
            max: 999999
            right: "dollars"

        # J1.Q11B: Pay frequency
        - id: q_j1_q11b
          kind: Question
          title: "Select the appropriate category for the reported wage or salary:"
          precondition:
            - predicate: q_j1_q6.outcome == 1
            - predicate: q_j1_q7a.outcome != 2
          input:
            control: Radio
            labels:
              1: "Hourly"
              2: "Weekly"
              3: "Every two weeks / twice a month"
              4: "Monthly"
              5: "Yearly"
              6: "Other (specify)"

        # J1.Q12: Total earnings (if Q11B=6, Other)
        - id: q_j1_q12
          kind: Question
          title: "What were the respondent's total earnings from this job in the reference year?"
          precondition:
            - predicate: q_j1_q6.outcome == 1
            - predicate: q_j1_q7a.outcome != 2
            - predicate: q_j1_q11b.outcome == 6
          input:
            control: Editbox
            min: 1
            max: 999999
            right: "dollars"

        # J1.Q13: Received commissions, tips, bonuses, or paid overtime?
        - id: q_j1_q13
          kind: Question
          title: "Did the respondent receive any commissions, tips, bonuses or paid overtime from this job in the reference year?"
          precondition:
            - predicate: q_j1_q6.outcome == 1
            - predicate: q_j1_q7a.outcome != 2
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # J1.Q14: Were commissions/tips included in amount reported?
        # Only if Q13=Yes
        - id: q_j1_q14
          kind: Question
          title: "Were these commissions, tips, bonuses or paid overtime included in the amount just reported?"
          precondition:
            - predicate: q_j1_q6.outcome == 1
            - predicate: q_j1_q7a.outcome != 2
            - predicate: q_j1_q13.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # J1.Q15: Total commissions/tips/bonuses amount (if Q14=No)
        - id: q_j1_q15
          kind: Question
          title: "What were the respondent's total earnings in the reference year from these commissions, tips, bonuses, or paid overtime?"
          precondition:
            - predicate: q_j1_q6.outcome == 1
            - predicate: q_j1_q7a.outcome != 2
            - predicate: q_j1_q13.outcome == 1
            - predicate: q_j1_q14.outcome == 0
          input:
            control: Editbox
            min: 1
            max: 999999
            right: "dollars"

    # =========================================================================
    # BLOCK 3: SECOND EMPLOYER DETAILS (J2)
    # =========================================================================
    # Items J2.Q1 through J2.Q16 (inventory items 40-57).
    # J2.Q1 has its own gate (asked after J1.Q13/Q14 for paid workers).
    # No block precondition — J2.Q1 handles entry gating.
    # =========================================================================
    - id: b_emppre_job2
      title: "Second Employer Details"
      precondition:
        - predicate: age >= 15
      items:
        # J2.Q1: Did respondent have more than one job?
        # Reached from J1.Q13 (No) or J1.Q14 (Yes) — i.e., after J1 wage questions.
        # Only asked when J1 was completed through wage section (paid worker path).
        - id: q_j2_q1
          kind: Question
          title: "Did the respondent have more than one job or business in January of this year?"
          precondition:
            - predicate: has_employer_j1 == 1
            - predicate: q_j1_q6.outcome == 1
            - predicate: q_j1_q7a.outcome != 2
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # J2.Q2: Second employer name (if J2.Q1=Yes)
        - id: q_j2_q2
          kind: Question
          title: "I would like to ask a few questions about the respondent's other job or business in January of this year. For whom did the respondent work? (Name of business, government department, or agency, or person.)"
          precondition:
            - predicate: has_employer_j1 == 1
            - predicate: q_j1_q6.outcome == 1
            - predicate: q_j1_q7a.outcome != 2
            - predicate: q_j2_q1.outcome == 1
          input:
            control: Textarea
            placeholder: "Enter employer name..."
            maxLength: 500

        # J2.Q3: When first started (year)
        - id: q_j2_q3
          kind: Question
          title: "When did the respondent first start working for this employer? (Enter the year.)"
          precondition:
            - predicate: has_employer_j1 == 1
            - predicate: q_j1_q6.outcome == 1
            - predicate: q_j1_q7a.outcome != 2
            - predicate: q_j2_q1.outcome == 1
          input:
            control: Editbox
            min: 1900
            max: 2100
            right: "year"

        # J2.Q4: Industry/business type
        - id: q_j2_q4
          kind: Question
          title: "What kind of business, industry or service was this? (e.g., federal government, canning industry, forestry services)"
          precondition:
            - predicate: has_employer_j1 == 1
            - predicate: q_j1_q6.outcome == 1
            - predicate: q_j1_q7a.outcome != 2
            - predicate: q_j2_q1.outcome == 1
          input:
            control: Textarea
            placeholder: "Enter industry or business type..."
            maxLength: 500

        # J2.Q5: Occupation/kind of work
        - id: q_j2_q5
          kind: Question
          title: "What kind of work was the respondent doing? (e.g., office clerk, factory worker, forestry technician)"
          precondition:
            - predicate: has_employer_j1 == 1
            - predicate: q_j1_q6.outcome == 1
            - predicate: q_j1_q7a.outcome != 2
            - predicate: q_j2_q1.outcome == 1
          input:
            control: Textarea
            placeholder: "Enter occupation..."
            maxLength: 500

        # J2.Q6: Main duties
        - id: q_j2_q6
          kind: Question
          title: "What were the respondent's most important activities or duties? (e.g., filing documents, drying vegetables, forest examiner)"
          precondition:
            - predicate: has_employer_j1 == 1
            - predicate: q_j1_q6.outcome == 1
            - predicate: q_j1_q7a.outcome != 2
            - predicate: q_j2_q1.outcome == 1
          input:
            control: Textarea
            placeholder: "Enter main duties..."
            maxLength: 500

        # J2.Q7: Class of worker
        - id: q_j2_q7
          kind: Question
          title: "In this job, was the respondent a paid worker, self-employed or an unpaid family worker?"
          precondition:
            - predicate: has_employer_j1 == 1
            - predicate: q_j1_q6.outcome == 1
            - predicate: q_j1_q7a.outcome != 2
            - predicate: q_j2_q1.outcome == 1
          input:
            control: Radio
            labels:
              1: "Paid worker"
              2: "Unpaid family worker"
              3: "Self-employed Incorporated - With paid help"
              4: "Self-employed Incorporated - No paid help"
              5: "Self-employed Unincorporated - With paid help"
              6: "Self-employed Unincorporated - No paid help"

        # J2.Q8A: Months worked in reference year (paid workers only)
        - id: q_j2_q8a
          kind: Question
          title: "In which months of the reference year did the respondent work at this job?"
          precondition:
            - predicate: has_employer_j1 == 1
            - predicate: q_j1_q6.outcome == 1
            - predicate: q_j1_q7a.outcome != 2
            - predicate: q_j2_q1.outcome == 1
            - predicate: q_j2_q7.outcome == 1
          input:
            control: Radio
            labels:
              1: "All months"
              2: "Started in current year"
              3: "Specify months"
              4: "Last worked before reference year"

        # J2.Q8B: Specify months (if Q8A=3 or Q8A=4)
        - id: q_j2_q8b
          kind: Question
          title: "Specify the months the respondent worked in the reference year:"
          precondition:
            - predicate: has_employer_j1 == 1
            - predicate: q_j1_q6.outcome == 1
            - predicate: q_j1_q7a.outcome != 2
            - predicate: q_j2_q1.outcome == 1
            - predicate: q_j2_q7.outcome == 1
            - predicate: q_j2_q8a.outcome == 3 or q_j2_q8a.outcome == 4
          input:
            control: Checkbox
            labels:
              1: "January"
              2: "February"
              4: "March"
              8: "April"
              16: "May"
              32: "June"
              64: "July"
              128: "August"
              256: "September"
              512: "October"
              1024: "November"
              2048: "December"

        # J2.Q9: Worked every week of the month?
        - id: q_j2_q9
          kind: Question
          title: "At this job, did the respondent usually work every week of the month?"
          precondition:
            - predicate: has_employer_j1 == 1
            - predicate: q_j1_q6.outcome == 1
            - predicate: q_j1_q7a.outcome != 2
            - predicate: q_j2_q1.outcome == 1
            - predicate: q_j2_q7.outcome == 1
            - predicate: q_j2_q8a.outcome != 2
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # J2.Q10: Weeks per month (if Q9=No)
        - id: q_j2_q10
          kind: Question
          title: "How many weeks did the respondent usually work each month?"
          precondition:
            - predicate: has_employer_j1 == 1
            - predicate: q_j1_q6.outcome == 1
            - predicate: q_j1_q7a.outcome != 2
            - predicate: q_j2_q1.outcome == 1
            - predicate: q_j2_q7.outcome == 1
            - predicate: q_j2_q8a.outcome != 2
            - predicate: q_j2_q9.outcome == 0
          input:
            control: Editbox
            min: 1
            max: 3
            right: "weeks"

        # J2.Q11: Hours per week usually paid
        - id: q_j2_q11
          kind: Question
          title: "How many hours per week did the respondent usually get paid?"
          precondition:
            - predicate: has_employer_j1 == 1
            - predicate: q_j1_q6.outcome == 1
            - predicate: q_j1_q7a.outcome != 2
            - predicate: q_j2_q1.outcome == 1
            - predicate: q_j2_q7.outcome == 1
            - predicate: q_j2_q8a.outcome != 2
          input:
            control: Editbox
            min: 1
            max: 99
            right: "hours"

        # J2.Q12A: Wage or salary before deductions
        - id: q_j2_q12a
          kind: Question
          title: "At this job, what was the respondent's wage or salary before taxes and deductions?"
          precondition:
            - predicate: has_employer_j1 == 1
            - predicate: q_j1_q6.outcome == 1
            - predicate: q_j1_q7a.outcome != 2
            - predicate: q_j2_q1.outcome == 1
            - predicate: q_j2_q7.outcome == 1
            - predicate: q_j2_q8a.outcome != 2
          input:
            control: Editbox
            min: 1
            max: 999999
            right: "dollars"

        # J2.Q12B: Pay frequency
        - id: q_j2_q12b
          kind: Question
          title: "Select the appropriate category for the reported wage or salary:"
          precondition:
            - predicate: has_employer_j1 == 1
            - predicate: q_j1_q6.outcome == 1
            - predicate: q_j1_q7a.outcome != 2
            - predicate: q_j2_q1.outcome == 1
            - predicate: q_j2_q7.outcome == 1
            - predicate: q_j2_q8a.outcome != 2
          input:
            control: Radio
            labels:
              1: "Hourly"
              2: "Weekly"
              3: "Every two weeks / twice a month"
              4: "Monthly"
              5: "Yearly"
              6: "Other (specify)"

        # J2.Q13: Total earnings (if Q12B=6, Other)
        - id: q_j2_q13
          kind: Question
          title: "What were the respondent's total earnings from this job in the reference year?"
          precondition:
            - predicate: has_employer_j1 == 1
            - predicate: q_j1_q6.outcome == 1
            - predicate: q_j1_q7a.outcome != 2
            - predicate: q_j2_q1.outcome == 1
            - predicate: q_j2_q7.outcome == 1
            - predicate: q_j2_q8a.outcome != 2
            - predicate: q_j2_q12b.outcome == 6
          input:
            control: Editbox
            min: 1
            max: 999999
            right: "dollars"

        # J2.Q14: Received commissions, tips, bonuses, or paid overtime?
        - id: q_j2_q14
          kind: Question
          title: "Did the respondent receive any commissions, tips, bonuses or paid overtime from this job in the reference year?"
          precondition:
            - predicate: has_employer_j1 == 1
            - predicate: q_j1_q6.outcome == 1
            - predicate: q_j1_q7a.outcome != 2
            - predicate: q_j2_q1.outcome == 1
            - predicate: q_j2_q7.outcome == 1
            - predicate: q_j2_q8a.outcome != 2
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # J2.Q15: Were commissions/tips included? (if Q14=Yes)
        - id: q_j2_q15
          kind: Question
          title: "Were these commissions, tips, bonuses or paid overtime included in the amount just reported?"
          precondition:
            - predicate: has_employer_j1 == 1
            - predicate: q_j1_q6.outcome == 1
            - predicate: q_j1_q7a.outcome != 2
            - predicate: q_j2_q1.outcome == 1
            - predicate: q_j2_q7.outcome == 1
            - predicate: q_j2_q8a.outcome != 2
            - predicate: q_j2_q14.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # J2.Q16: Total commissions/tips/bonuses amount (if Q15=No)
        - id: q_j2_q16
          kind: Question
          title: "What were the respondent's total earnings in the reference year from these commissions, tips, bonuses, or paid overtime?"
          precondition:
            - predicate: has_employer_j1 == 1
            - predicate: q_j1_q6.outcome == 1
            - predicate: q_j1_q7a.outcome != 2
            - predicate: q_j2_q1.outcome == 1
            - predicate: q_j2_q7.outcome == 1
            - predicate: q_j2_q8a.outcome != 2
            - predicate: q_j2_q14.outcome == 1
            - predicate: q_j2_q15.outcome == 0
          input:
            control: Editbox
            min: 1
            max: 999999
            right: "dollars"

    # ===================================================================
    # SECTION: work_experience
    # ===================================================================
    # =========================================================================
    # BLOCK: EXPRE — Work Experience History
    # =========================================================================
    # N1 filter: age > 69 skips the entire module → block precondition age <= 69
    #
    # Q1A: Ever worked full-time?  Yes → Q1B; Otherwise → end
    # Q1B: Years ago first started full-time. 0/DK → end; 1 → Q3; 2+ → Q2A
    # Q2A: Any years not working?  Yes → Q2B → Q5A path; No → Q3
    # Q3: Worked 6+ months every year?  Yes → Q4 series; No → Q5A
    # Q4A/Q4B/Q4C: Full-time / part-time / mixed years (sum must = Q1B)
    # Q4D: Sum-check warning (Comment) if Q4A+Q4B+Q4C != Q1B
    # Q5A: Years working 6+ months. 0 → end; Otherwise → Q6 series
    # Q6A/Q6B/Q6C: Full-time / part-time / mixed years (sum must = Q5A)
    # Q6D: Sum-check warning (Comment) if Q6A+Q6B+Q6C != Q5A
    # =========================================================================
    - id: b_expre
      title: "Work Experience"
      precondition:
        - predicate: age <= 69
      items:
        # Q1A: Did respondent ever work full-time?
        - id: q_work_experience_q1a
          kind: Question
          title: "The next few questions are about work experience, thinking back to when first started working at a job or business. Did the respondent ever work full-time? (Exclude summer jobs while in school)"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No, never worked full-time"
              3: "No, only worked full-time at summer jobs while in school"

        # Q1B: How many years ago did respondent first start working full-time?
        # Shown only if Q1A = Yes (1)
        # Routes: 0 → end section; 1 → Q3 (skip Q2A/Q2B); 2+ → Q2A
        - id: q_q1b
          kind: Question
          title: "How many years ago did the respondent first start working full-time? (Exclude summer jobs while in school. Enter 00 if less than one year.)"
          precondition:
            - predicate: q_work_experience_q1a.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 60
            right: "years"

        # Q2A: Were there any years when respondent did not work?
        # Shown only if Q1B >= 2
        - id: q_q2a
          kind: Question
          title: "In those years, were there any years when the respondent did not work at a job or business?"
          precondition:
            - predicate: q_work_experience_q1a.outcome == 1
            - predicate: q_q1b.outcome >= 2
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q2B: How many years did respondent not work?
        # Shown only if Q2A = Yes (1)
        # After Q2B → skip to Q5A (Q3/Q4 series not reached)
        - id: q_work_experience_q2b
          kind: Question
          title: "How many years did the respondent not work at a job or business?"
          precondition:
            - predicate: q_work_experience_q1a.outcome == 1
            - predicate: q_q1b.outcome >= 2
            - predicate: q_q2a.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 60
            right: "years"

        # Q3: Worked at least 6 months each and every year?
        # Reached when Q1B = 1 (skip Q2A/Q2B) OR Q1B >= 2 and Q2A = No (0)
        # Yes → Q4A series; No → Q5A
        - id: q_work_experience_q3
          kind: Question
          title: "In those years, did the respondent work at least 6 months each and every year?"
          precondition:
            - predicate: q_work_experience_q1a.outcome == 1
            - predicate: q_q1b.outcome >= 1
            - predicate: q_q1b.outcome == 1 or q_q2a.outcome == 0
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q4A: How many years worked only full-time?
        # Shown if Q3 = Yes (1)
        - id: q_q4a
          kind: Question
          title: "How many years did the respondent work only full-time? (By full-time I mean 30 or more hours per week. If none, enter 00.)"
          precondition:
            - predicate: q_work_experience_q1a.outcome == 1
            - predicate: q_q1b.outcome >= 1
            - predicate: q_q1b.outcome == 1 or q_q2a.outcome == 0
            - predicate: q_work_experience_q3.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 60
            right: "years"

        # Q4B: How many years worked only part-time?
        - id: q_q4b
          kind: Question
          title: "How many years did the respondent work only part-time? (If none, enter 00.)"
          precondition:
            - predicate: q_work_experience_q1a.outcome == 1
            - predicate: q_q1b.outcome >= 1
            - predicate: q_q1b.outcome == 1 or q_q2a.outcome == 0
            - predicate: q_work_experience_q3.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 60
            right: "years"

        # Q4C: How many years worked some of each?
        - id: q_q4c
          kind: Question
          title: "How many years did the respondent work some of each (full-time and part-time)? (If none, enter 00.)"
          precondition:
            - predicate: q_work_experience_q1a.outcome == 1
            - predicate: q_q1b.outcome >= 1
            - predicate: q_q1b.outcome == 1 or q_q2a.outcome == 0
            - predicate: q_work_experience_q3.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 60
            right: "years"

        # Q4D: Sum-check warning (N4 filter → Q4D comment)
        # Shown when Q4A + Q4B + Q4C does not equal Q1B
        - id: q_q4d
          kind: Comment
          title: "The years of full-time, part-time, and mixed work do not sum to the total years working full-time. Please verify and correct if necessary."
          precondition:
            - predicate: q_work_experience_q1a.outcome == 1
            - predicate: q_q1b.outcome >= 1
            - predicate: q_q1b.outcome == 1 or q_q2a.outcome == 0
            - predicate: q_work_experience_q3.outcome == 1
            - predicate: q_q4a.outcome + q_q4b.outcome + q_q4c.outcome != q_q1b.outcome

        # Q5A: How many years did respondent work at least 6 months of the year?
        # Reached via two paths:
        #   1. Q2B answered (Q2A = Yes) → skip Q3/Q4, go to Q5A
        #   2. Q3 = No (0) → go to Q5A
        # Routes: 0 → end section; Otherwise → Q6 series
        - id: q_q5a
          kind: Question
          title: "Since the respondent first started working, how many years did he/she work at least 6 months of the year? (If none, enter 00.)"
          precondition:
            - predicate: q_work_experience_q1a.outcome == 1
            - predicate: q_q1b.outcome >= 1
            - predicate: q_q2a.outcome == 1 or q_work_experience_q3.outcome == 0
          input:
            control: Editbox
            min: 0
            max: 60
            right: "years"

        # Q6A: In those years, how many worked only full-time?
        # Shown if Q5A >= 1
        - id: q_q6a
          kind: Question
          title: "In those years, how many did the respondent work only full-time? (By full-time I mean 30 or more hours per week. If none, enter 00.)"
          precondition:
            - predicate: q_work_experience_q1a.outcome == 1
            - predicate: q_q1b.outcome >= 1
            - predicate: q_q2a.outcome == 1 or q_work_experience_q3.outcome == 0
            - predicate: q_q5a.outcome >= 1
          input:
            control: Editbox
            min: 0
            max: 60
            right: "years"

        # Q6B: In those years, how many worked only part-time?
        - id: q_q6b
          kind: Question
          title: "In those years, how many did the respondent work only part-time? (If none, enter 00.)"
          precondition:
            - predicate: q_work_experience_q1a.outcome == 1
            - predicate: q_q1b.outcome >= 1
            - predicate: q_q2a.outcome == 1 or q_work_experience_q3.outcome == 0
            - predicate: q_q5a.outcome >= 1
          input:
            control: Editbox
            min: 0
            max: 60
            right: "years"

        # Q6C: In those years, how many worked some of each?
        - id: q_q6c
          kind: Question
          title: "In those years, how many did the respondent work some of each (full-time and part-time)? (If none, enter 00.)"
          precondition:
            - predicate: q_work_experience_q1a.outcome == 1
            - predicate: q_q1b.outcome >= 1
            - predicate: q_q2a.outcome == 1 or q_work_experience_q3.outcome == 0
            - predicate: q_q5a.outcome >= 1
          input:
            control: Editbox
            min: 0
            max: 60
            right: "years"

        # Q6D: Sum-check warning (N6 filter → Q6D comment)
        # Shown when Q6A + Q6B + Q6C does not equal Q5A
        - id: q_q6d
          kind: Comment
          title: "The years of full-time, part-time, and mixed work do not sum to the total years working 6 or more months. Please verify and correct if necessary."
          precondition:
            - predicate: q_work_experience_q1a.outcome == 1
            - predicate: q_q1b.outcome >= 1
            - predicate: q_q2a.outcome == 1 or q_work_experience_q3.outcome == 0
            - predicate: q_q5a.outcome >= 1
            - predicate: q_q6a.outcome + q_q6b.outcome + q_q6c.outcome != q_q5a.outcome

    # ===================================================================
    # SECTION: demographics
    # ===================================================================
    - id: b_marital_history
      title: Marital History
      items:
      - id: q_demographics_q1a
        kind: Comment
        title: The next few questions are about the respondent's family background and are based on the date of birth and marital status reported earlier in the interview.

      # --- Separated/Divorced path (marital_status 3 or 4) ---
      - id: q_demographics_q1
        kind: Question
        title: What was the date of the respondent's separation? (Not the date of divorce, year only)
        precondition:
        - predicate: marital_status in [3, 4]
        input:
          control: Editbox
          min: 1870
          max: 2100
          right: year

      - id: q_demographics_q2
        kind: Question
        title: What was the date of this marriage? (Year only)
        precondition:
        - predicate: marital_status in [3, 4]
        postcondition:
        - predicate: q_demographics_q2.outcome <= q_demographics_q1.outcome
          hint: Date of marriage should be before date of separation.
        codeBlock: |
          current_marriage_year = q_demographics_q2.outcome
        input:
          control: Editbox
          min: 1870
          max: 2100
          right: year

      # --- Married path (marital_status 1) ---
      - id: q_demographics_q2b
        kind: Question
        title: What was the date of the respondent's marriage? (Year only)
        precondition:
        - predicate: marital_status == 1
        codeBlock: |
          current_marriage_year = q_demographics_q2b.outcome
        input:
          control: Editbox
          min: 1870
          max: 2100
          right: year

      # --- Q3: Convergence for married + separated/divorced ---
      - id: q_demographics_q3
        kind: Question
        title: Was this the respondent's first marriage?
        precondition:
        - predicate: marital_status in [1, 3, 4]
        input:
          control: Radio
          labels:
            1: "Yes"
            2: "No"

      - id: q_demographics_q4
        kind: Question
        title: What was the date of the respondent's first marriage? (Year only)
        precondition:
        - predicate: marital_status in [1, 3, 4]
        - predicate: q_demographics_q3.outcome == 2
        postcondition:
        - predicate: q_demographics_q4.outcome <= current_marriage_year
          hint: Date of first marriage should be before date of current/most recent marriage.
        input:
          control: Editbox
          min: 1870
          max: 2100
          right: year

      # --- Common-law path (marital_status 2) ---
      - id: q_demographics_q5
        kind: Question
        title: When did the respondent and his/her partner begin to live together? (Year only)
        precondition:
        - predicate: marital_status == 2
        input:
          control: Editbox
          min: 1870
          max: 2100
          right: year

      - id: q_demographics_q6
        kind: Question
        title: Has the respondent ever been married?
        precondition:
        - predicate: marital_status == 2
        input:
          control: Radio
          labels:
            1: "Yes"
            2: "No"

      # --- Widowed path (marital_status 5) ---
      - id: q_demographics_q7
        kind: Question
        title: When was the respondent widowed? (Year only)
        precondition:
        - predicate: marital_status == 5
        input:
          control: Editbox
          min: 1870
          max: 2100
          right: year

      # --- Q8: Convergence for common-law (ever married) + widowed ---
      - id: q_demographics_q8
        kind: Question
        title: Was this the respondent's first marriage?
        precondition:
        - predicate: (marital_status == 2 and q_demographics_q6.outcome == 1) or marital_status == 5
        input:
          control: Radio
          labels:
            1: "Yes"
            2: "No"

      # --- Q9: First marriage date (for first-marriage path from Q8) ---
      # Reached when Q8=Yes (first marriage) from common-law or widowed
      - id: q_demographics_q9
        kind: Question
        title: What was the date of the respondent's marriage? (Year only)
        precondition:
        - predicate: (marital_status == 2 and q_demographics_q6.outcome == 1) or marital_status == 5
        - predicate: q_demographics_q8.outcome == 1
        postcondition:
        - predicate: marital_status != 5 or q_demographics_q9.outcome <= q_demographics_q7.outcome
          hint: Date of marriage should be before date widowed.
        - predicate: marital_status != 2 or q_demographics_q9.outcome <= q_demographics_q5.outcome
          hint: Date of marriage should be before date started living together.
        input:
          control: Editbox
          min: 1870
          max: 2100
          right: year

      # --- Q10: First marriage date (for not-first-marriage path from Q8) ---
      - id: q_demographics_q10
        kind: Question
        title: What was the date of the respondent's first marriage? (Year only)
        precondition:
        - predicate: (marital_status == 2 and q_demographics_q6.outcome == 1) or marital_status == 5
        - predicate: q_demographics_q8.outcome == 2
        postcondition:
        - predicate: marital_status != 2 or q_demographics_q10.outcome <= q_demographics_q5.outcome
          hint: Date of first marriage should be before date started living together.
        - predicate: marital_status != 5 or q_demographics_q10.outcome <= q_demographics_q7.outcome
          hint: Date of first marriage should be before date widowed.
        input:
          control: Editbox
          min: 1870
          max: 2100
          right: year

    - id: b_birth_history
      title: Birth History
      precondition:
      - predicate: sex == 2
      - predicate: age >= 18
      items:
      - id: q_demographics_q11
        kind: Question
        title: Has the respondent had any children?
        input:
          control: Radio
          labels:
            1: "Yes"
            2: "No"
            8: "Don't know"

      - id: q_demographics_q12
        kind: Question
        title: How many children were ever born to the respondent?
        precondition:
        - predicate: q_demographics_q11.outcome == 1
        input:
          control: Editbox
          min: 0
          max: 20
          right: children

      - id: q_demographics_q13
        kind: Question
        title: In what year did the respondent give birth to her first child?
        precondition:
        - predicate: q_demographics_q11.outcome == 1
        - predicate: q_demographics_q12.outcome >= 1
        input:
          control: Editbox
          min: 1870
          max: 2100
          right: year

      - id: q_demographics_q14
        kind: Question
        title: (Other than children the respondent has given birth to) Has the respondent adopted or raised any children?
        precondition:
        - predicate: q_demographics_q11.outcome in [1, 2]
        postcondition:
        - predicate: q_demographics_q11.outcome != 1 or q_demographics_q14.outcome != 2 or q_demographics_q12.outcome >= 1
          hint: Respondent stated she had children but none were born to her; she should have adopted or raised children.
        input:
          control: Radio
          labels:
            1: "Yes"
            2: "No"

      - id: q_demographics_q15
        kind: Question
        title: How many (other) children has the respondent adopted or raised?
        precondition:
        - predicate: q_demographics_q14.outcome == 1
        input:
          control: Editbox
          min: 1
          max: 20
          right: children

    - id: b_background
      title: Background
      items:
      - id: q_demographics_q16
        kind: Question
        title: What is the language that the respondent first learned at home in childhood and still understands?
        input:
          control: Radio
          labels:
            1: "English"
            2: "French"
            3: "Other"

      - id: q_q16_other
        kind: Question
        title: Please specify the language.
        precondition:
        - predicate: q_demographics_q16.outcome == 3
        input:
          control: Textarea
          placeholder: Specify language...
          maxLength: 200

      - id: q_demographics_q17
        kind: Question
        title: In what country was the respondent born?
        input:
          control: Dropdown
          labels:
            1: "Canada"
            2: "United Kingdom"
            3: "Italy"
            4: "U.S.A."
            5: "Germany"
            6: "Poland"
            7: "Other"

      - id: q_q17_other
        kind: Question
        title: Please specify the country.
        precondition:
        - predicate: q_demographics_q17.outcome == 7
        input:
          control: Textarea
          placeholder: Specify country...
          maxLength: 200

      - id: q_demographics_q18
        kind: Question
        title: Did the respondent immigrate to Canada?
        precondition:
        - predicate: q_demographics_q17.outcome != 1
        input:
          control: Radio
          labels:
            1: "Yes"
            2: "No (never immigrated - Canadian citizen by birth)"

      - id: q_q18b
        kind: Question
        title: In what year was that?
        precondition:
        - predicate: q_demographics_q17.outcome != 1
        - predicate: q_demographics_q18.outcome == 1
        input:
          control: Editbox
          min: 1870
          max: 2100
          right: year

      - id: q_q19
        kind: Question
        title: Is the respondent a Registered Indian as defined by the Indian Act of Canada?
        input:
          control: Radio
          labels:
            1: "Yes, Registered Indian"
            2: "No"

      - id: q_q20
        kind: Question
        title: "Canadians come from many ethnic, cultural and racial backgrounds. For example, English, French, North American Indian, Chinese, Black, Filipino or Lebanese. What is the respondent's background? (Mark all that apply)"
        input:
          control: Checkbox
          labels:
            1: "English"
            2: "French"
            4: "German"
            8: "Scottish"
            16: "Italian"
            32: "Irish"
            64: "Ukrainian"
            128: "Chinese"
            256: "Canadian"
            512: "Dutch (Netherlands)"
            1024: "Jewish"
            2048: "Polish"
            4096: "Black"
            8192: "Metis"
            16384: "Inuit/Eskimo"
            32768: "North American Indian"
            65536: "East Indian"
            131072: "Other"

      - id: q_q20a
        kind: Question
        title: Please specify other ethnic background not already given.
        precondition:
        - predicate: q_q20.outcome % 262144 >= 131072
        input:
          control: Textarea
          placeholder: Specify ethnic background...
          maxLength: 200

    # ===================================================================
    # SECTION: education
    # ===================================================================
    # =========================================================================
    # BLOCK: EDUCATION (EDUPRE)
    # =========================================================================
    # Q1-Q3: Elementary/high school
    # Q4-Q11: Non-university education (college, trade, CEGEP)
    # Q12-Q16: University education
    # Q17-Q18: Parents' education level
    # =========================================================================
    - id: b_edupre
      title: "Educational Attainment"
      items:
        # Q1: Years of elementary and high school
        - id: q_education_q1
          kind: Question
          title: "How many years of elementary and high school did the respondent complete?"
          postcondition:
            - predicate: q_education_q1.outcome <= age - 5
              hint: "Years of schooling should not exceed age minus 5. Please verify."
          input:
            control: Editbox
            min: 0
            max: 15
            right: "years"

        # Q2: Province of education
        # Reached if Q1 >= 1 (Q1=0 skips to Q17)
        - id: q_education_q2
          kind: Question
          title: "In which province or territory did the respondent get most of his/her elementary and high school education?"
          precondition:
            - predicate: q_education_q1.outcome >= 1
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
              11: "Yukon"
              12: "Northwest Territories"
              13: "Outside Canada"

        # Q3: Completed high school?
        # Only asked if Q1 >= 10 (EVAL-Q1: Q1=1-9 skips to Q4)
        - id: q_education_q3
          kind: Question
          title: "Did the respondent complete high school?"
          precondition:
            - predicate: q_education_q1.outcome >= 10
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q4: Ever enrolled in non-university school?
        # Reached if Q1 >= 1 (either from Q3 or from EVAL-Q1 skip)
        - id: q_education_q4
          kind: Question
          title: "Excluding university, has the respondent ever been enrolled in any other kind of school, for example, a community college, business school, trade or vocational school, or CEGEP?"
          precondition:
            - predicate: q_education_q1.outcome >= 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q5: Received certificates or diplomas?
        # Only if Q4 = Yes
        - id: q_education_q5
          kind: Question
          title: "Has the respondent received any certificates or diplomas as a result of this education?"
          precondition:
            - predicate: q_education_q4.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q6: Type of school for most recent certificate
        # Only if Q5 = Yes
        - id: q_education_q6
          kind: Question
          title: "Thinking of the most recent certificate or diploma (excluding university), what type of school or college did the respondent attend?"
          precondition:
            - predicate: q_education_q5.outcome == 1
          input:
            control: Radio
            labels:
              1: "Community college or institute of applied arts and technology"
              2: "Business or commercial school"
              3: "Trade or vocational school"
              4: "CEGEP"
              5: "Some other type (specify)"

        # Q6 follow-up: Specify other type of school
        - id: q_q6_other
          kind: Question
          title: "Please specify the type of school:"
          precondition:
            - predicate: q_education_q6.outcome == 5
          input:
            control: Textarea
            placeholder: "Type of school..."
            maxLength: 200

        # Q7: How long to complete program — months or years?
        # Only if Q5 = Yes (same gate as Q6)
        - id: q_education_q7
          kind: Question
          title: "How long did it take the respondent to complete this program?"
          precondition:
            - predicate: q_education_q5.outcome == 1
          input:
            control: Radio
            labels:
              1: "Answer given in months"
              2: "Answer given in years"

        # Q7A: Number of months
        # Only if Q7 = Months
        - id: q_q7a
          kind: Question
          title: "Enter the number of months it took to complete this program:"
          precondition:
            - predicate: q_education_q7.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 99
            right: "months"

        # Q7B: Number of years
        # Only if Q7 = Years
        - id: q_q7b
          kind: Question
          title: "Enter the number of years it took to complete this program:"
          precondition:
            - predicate: q_education_q7.outcome == 2
          input:
            control: Editbox
            min: 1
            max: 9
            right: "years"

        # Q8: Full-time, part-time, or some of each?
        # Only if Q5 = Yes (same gate as Q6)
        - id: q_education_q8
          kind: Question
          title: "Was this full-time, part-time, or some of each?"
          precondition:
            - predicate: q_education_q5.outcome == 1
          input:
            control: Radio
            labels:
              1: "Full-time"
              2: "Part-time"
              3: "Some of each"

        # Q9: Year received diploma
        # Only if Q5 = Yes
        - id: q_education_q9
          kind: Question
          title: "In what year did the respondent receive his/her certificate or diploma?"
          precondition:
            - predicate: q_education_q5.outcome == 1
          postcondition:
            - predicate: q_education_q9.outcome >= current_year - age + 14
              hint: "Year of diploma seems too early given the respondent's age. Please verify."
          input:
            control: Editbox
            min: 1900
            max: 2100
            left: "Year:"

        # Q10: Major field of study (non-university)
        # Only if Q5 = Yes
        - id: q_education_q10
          kind: Question
          title: "What was the major subject or field of study?"
          precondition:
            - predicate: q_education_q5.outcome == 1
          input:
            control: Textarea
            placeholder: "Major field of study..."
            maxLength: 300

        # Q11: Total years of non-university schooling
        # Reached if Q4 = Yes (enrolled in non-university school)
        - id: q_education_q11
          kind: Question
          title: "In total, how many years of schooling did the respondent complete at a community college, technical institute, trade or vocational school, or CEGEP? (Enter 0 if less than one year)"
          precondition:
            - predicate: q_education_q4.outcome == 1
          postcondition:
            - predicate: q_education_q11.outcome <= age - 14
              hint: "Years of non-university schooling cannot exceed age minus 14. Please verify."
          input:
            control: Editbox
            min: 0
            max: 20
            right: "years"

        # Q12: Ever enrolled in university?
        # Reached if Q1 >= 1 (everyone with schooling)
        # Entry paths: Q4=No, or after Q11 (Q4=Yes path)
        - id: q_education_q12
          kind: Question
          title: "Has the respondent ever been enrolled in a university?"
          precondition:
            - predicate: q_education_q1.outcome >= 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q13: Years of university
        # Only if Q12 = Yes
        - id: q_education_q13
          kind: Question
          title: "How many years of university has the respondent completed? (Enter 0 if attended university but didn't complete the year)"
          precondition:
            - predicate: q_education_q12.outcome == 1
          postcondition:
            - predicate: q_education_q13.outcome <= age - 14
              hint: "Years of university cannot exceed age minus 14. Please verify."
          input:
            control: Editbox
            min: 0
            max: 20
            right: "years"

        # Q14: University degrees received?
        # Only if Q12 = Yes
        - id: q_education_q14
          kind: Question
          title: "What degrees, certificates, or diplomas has the respondent received from a university?"
          precondition:
            - predicate: q_education_q12.outcome == 1
          input:
            control: Radio
            labels:
              1: "None"
              2: "Specify degrees"
              3: "Don't know / Refused"

        # Q14A: Specify degrees (multi-select)
        # Only if Q14 = Specify degrees
        # Checkbox keys must be powers of 2
        - id: q_q14a
          kind: Question
          title: "Specify degrees, certificates, or diplomas the respondent has received from a university. Mark all that apply."
          precondition:
            - predicate: q_education_q14.outcome == 2
          input:
            control: Checkbox
            labels:
              1: "University certificate/diploma below Bachelor level"
              2: "Bachelor's degree(s)"
              4: "University certificate/diploma above Bachelor level"
              8: "Master's degree(s)"
              16: "Degree in medicine, dentistry, veterinary medicine, or optometry"
              32: "Doctorate (PhD)"

        # Q15: Year received highest degree
        # Reached from Q14A (Specify Degrees path) or Q14=DK/R directly
        - id: q_education_q15
          kind: Question
          title: "What year did the respondent receive his/her highest degree?"
          precondition:
            - predicate: q_education_q14.outcome >= 2
          input:
            control: Editbox
            min: 1900
            max: 2100
            left: "Year:"

        # Q16: Major field of study (university)
        # Only if Q14 = Specify degrees
        - id: q_education_q16
          kind: Question
          title: "What was the major field of study?"
          precondition:
            - predicate: q_education_q14.outcome == 2
          input:
            control: Textarea
            placeholder: "Major field of study..."
            maxLength: 300

        # Q17: Mother's highest education level
        # Reached by everyone (all paths converge here)
        - id: q_education_q17
          kind: Question
          title: "What was the highest level of education completed by the respondent's mother?"
          input:
            control: Dropdown
            labels:
              1: "Elementary school (includes no schooling)"
              2: "Some high school"
              3: "Completed high school"
              4: "Trade/vocational school"
              5: "Post-secondary certificate or diploma"
              6: "University degree"

        # Q18: Father's highest education level
        # Always shown — final item in questionnaire
        - id: q_education_q18
          kind: Question
          title: "What was the highest level of education completed by the respondent's father?"
          input:
            control: Dropdown
            labels:
              1: "Elementary school (includes no schooling)"
              2: "Some high school"
              3: "Completed high school"
              4: "Trade/vocational school"
              5: "Post-secondary certificate or diploma"
              6: "University degree"
