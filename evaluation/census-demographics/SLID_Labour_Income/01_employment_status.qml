qmlVersion: "1.0"
questionnaire:
  title: "SLID 1994 Preliminary Interview - Employment Status (EMPPRE)"

  codeInit: |
    # Extern variables (pre-filled by CATI system)
    age: range(0, 120)
    current_year: range(1990, 2100)
    reference_year: range(1989, 2099)

    # Consolidation: set to 1 when respondent reaches either J1.Q1 or J1.Q1A
    # (mutually exclusive entry points into the first-employer sub-section)
    has_employer_j1 = 0

    # Classification: set to 1 when Q3 answer is temporary layoff
    # (codes 8=seasonal or 9=non-seasonal), routes to Q8 instead of J1
    temp_layoff = 0

    # Classification: set to 1 when N11A determines respondent never worked
    # or last worked before reference year — skips J1.Q1A, goes to N12
    no_recent_work = 0

  blocks:
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
        - id: q_q1
          kind: Question
          title: "Did the respondent work at a job or business at the beginning of January of this year? (Enter a job regardless of the number of hours worked.)"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Permanently unable to work"

        # Q2: Had a job but absent? (only if Q1=No)
        - id: q_q2
          kind: Question
          title: "Did the respondent have a job or business at which he/she did not work at the beginning of January?"
          precondition:
            - predicate: q_q1.outcome == 2
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q3: Why absent from work? (only if Q2=Yes)
        - id: q_q3
          kind: Question
          title: "Why was the respondent absent from work at the beginning of January?"
          precondition:
            - predicate: q_q1.outcome == 2
            - predicate: q_q2.outcome == 1
          codeBlock: |
            if q_q3.outcome == 8 or q_q3.outcome == 9:
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
            - predicate: q_q1.outcome == 2
            - predicate: q_q2.outcome == 1
            - predicate: q_q3.outcome == 11
          input:
            control: Textarea
            placeholder: "Specify reason..."
            maxLength: 200

        # Q4: Did respondent receive pay during absence?
        # Reached when Q2=Yes and Q3 is NOT school (6)
        # (If Q3=6 -> goes to Q5 instead)
        - id: q_q4
          kind: Question
          title: "Did the respondent receive any pay from his/her employer for this absence?"
          precondition:
            - predicate: q_q1.outcome == 2
            - predicate: q_q2.outcome == 1
            - predicate: q_q3.outcome != 6
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
            - predicate: q_q1.outcome == 1 or (q_q1.outcome == 2 and q_q2.outcome == 1 and q_q3.outcome not in [6, 8, 9])
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
        - id: q_q5
          kind: Question
          title: "Did the respondent ever work at a job or business?"
          precondition:
            - predicate: q_q1.outcome == 3 or (q_q1.outcome == 2 and q_q2.outcome == 0) or (q_q1.outcome == 2 and q_q2.outcome == 1 and q_q3.outcome == 6)
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q6: When did respondent last work? (year only, if Q5=Yes)
        - id: q_q6
          kind: Question
          title: "When did the respondent last work at a job or business? (Enter the year.)"
          precondition:
            - predicate: q_q1.outcome == 3 or (q_q1.outcome == 2 and q_q2.outcome == 0) or (q_q1.outcome == 2 and q_q2.outcome == 1 and q_q3.outcome == 6)
            - predicate: q_q5.outcome == 1
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
        # they are Python expressions. Let's use: q_q6.outcome < current_year - 5
        # combined with q_q1.outcome == 3 to skip Q7.

        # Q7: Main reason for leaving last job (if Q5=Yes and not filtered by N6)
        # N6 filter: skip to N12 when Q6 < (current_year - 5) AND Q1=3
        # So Q7 shown when Q5=Yes and NOT (Q6 old AND Q1=permanently unable)
        - id: q_q7
          kind: Question
          title: "What was the respondent's main reason for leaving this job?"
          precondition:
            - predicate: q_q1.outcome == 3 or (q_q1.outcome == 2 and q_q2.outcome == 0) or (q_q1.outcome == 2 and q_q2.outcome == 1 and q_q3.outcome == 6)
            - predicate: q_q5.outcome == 1
            - predicate: not (q_q1.outcome == 3 and q_q6.outcome < current_year - 5)
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
            - predicate: q_q1.outcome == 3 or (q_q1.outcome == 2 and q_q2.outcome == 0) or (q_q1.outcome == 2 and q_q2.outcome == 1 and q_q3.outcome == 6)
            - predicate: q_q5.outcome == 1
            - predicate: not (q_q1.outcome == 3 and q_q6.outcome < current_year - 5)
            - predicate: q_q7.outcome == 11
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
        - id: q_q8
          kind: Question
          title: "Did the respondent look for work in January of this year?"
          precondition:
            - predicate: q_q1.outcome != 1
            - predicate: q_q1.outcome != 3
            - predicate: temp_layoff == 1 or q_q5.outcome == 0 or q_q5.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q9: Methods of job search (multi select, if Q8=Yes)
        - id: q_q9
          kind: Question
          title: "What did the respondent do to find work?"
          precondition:
            - predicate: q_q1.outcome != 1
            - predicate: q_q1.outcome != 3
            - predicate: temp_layoff == 1 or q_q5.outcome == 0 or q_q5.outcome == 1
            - predicate: q_q8.outcome == 1
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
            - predicate: q_q1.outcome != 1
            - predicate: q_q1.outcome != 3
            - predicate: temp_layoff == 1 or q_q5.outcome == 0 or q_q5.outcome == 1
            - predicate: q_q8.outcome == 1
            - predicate: q_q9.outcome % 64 >= 32
          input:
            control: Textarea
            placeholder: "Specify method..."
            maxLength: 200

        # Q10: Looked for work in prior 6 months? (if Q8=No)
        - id: q_q10
          kind: Question
          title: "Did the respondent look for work at any time in the 6 months before that?"
          precondition:
            - predicate: q_q1.outcome != 1
            - predicate: q_q1.outcome != 3
            - predicate: temp_layoff == 1 or q_q5.outcome == 0 or q_q5.outcome == 1
            - predicate: q_q8.outcome == 0
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q11: Reasons for not looking (multi select, if Q10=Yes)
        - id: q_q11
          kind: Question
          title: "What were the reasons the respondent did not look for work in January of this year? (If only answered own illness or personal responsibilities, probe for other reasons.)"
          precondition:
            - predicate: q_q1.outcome != 1
            - predicate: q_q1.outcome != 3
            - predicate: temp_layoff == 1 or q_q5.outcome == 0 or q_q5.outcome == 1
            - predicate: q_q8.outcome == 0
            - predicate: q_q10.outcome == 1
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
            - predicate: q_q1.outcome != 1
            - predicate: q_q1.outcome != 3
            - predicate: temp_layoff == 1 or q_q5.outcome == 0 or q_q5.outcome == 1
            - predicate: q_q8.outcome == 0
            - predicate: q_q10.outcome == 1
            - predicate: q_q11.outcome % 4096 >= 2048
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
            - predicate: q_q1.outcome != 1
            - predicate: q_q1.outcome != 3
            - predicate: q_q5.outcome == 1
            - predicate: q_q6.outcome >= reference_year
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
        - id: q_q12
          kind: Question
          title: "In January of this year, was the respondent attending a school, college or university?"
          precondition:
            - predicate: age <= 64
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q13: Full-time or part-time student? (if Q12=Yes)
        - id: q_q13
          kind: Question
          title: "Was the respondent enrolled as a full-time or part-time student?"
          precondition:
            - predicate: age <= 64
            - predicate: q_q12.outcome == 1
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
            - predicate: q_q5.outcome == 1
            - predicate: q_j1_q2.outcome > q_q6.outcome

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
