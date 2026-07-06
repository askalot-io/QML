qmlVersion: "2.0"
questionnaire:
  title: "Survey of Labour and Income Dynamics"
  codeInit: |
    # =====================================================================
    # CATI pre-fill constants. The 1994 Preliminary Interview substitutes
    # [current year] and [reference year] from the interviewing system; they
    # are fixed for the run, so they are modelled as codeInit constants (frozen
    # variables). They are read by the temporal / age-at-event postconditions
    # below and never reassigned. reference_year is the calendar year the
    # income and month-worked questions ask about (the year before the
    # interview).
    # =====================================================================
    current_year = 1994
    reference_year = 1993

    # Consolidates the current (most-recent) marriage year from its two mutually
    # exclusive producers: q_demographics_q2 on the separated/divorced path and
    # q_demographics_q2b on the married path. Only one ever runs, so this single
    # name lets the first-marriage ordering check (q_demographics_q4) read the
    # current marriage year without knowing which path produced it. Justification:
    # consolidate (State-Variable Contract).
    current_marriage_year = 0

  blocks:

    # ===================================================================
    # BLOCK: PREAMBLE — respondent classifiers reported earlier in the
    # interview (age, sex, marital status).
    # ===================================================================
    # The SLID Preliminary Interview is a downstream module: it branches on the
    # respondent's date of birth (age), sex, and marital status, which the full
    # interview collected earlier ("...BASED ON THE DATE OF BIRTH AND MARITAL
    # STATUS REPORTED EARLIER IN THE INTERVIEW", DEMPRE-Q1A). Those producers are
    # not in this module's own item list, so this block wires them explicitly:
    # every gate that branches on age/sex/marital status references
    # q_age.outcome / q_sex.outcome / q_marital_status.outcome directly (no
    # pass-through alias variable), keeping each inside the Z3-verified envelope.
    # ===================================================================
    - id: b_preamble
      kind: Group
      title: "Respondent Background"
      items:
        - id: q_age
          kind: Question
          title: "What is the respondent's age?"
          input:
            control: Editbox
            min: 0
            max: 120
            right: "years"

        - id: q_sex
          kind: Question
          title: "What is the respondent's sex?"
          input:
            control: Radio
            labels:
              1: "Male"
              2: "Female"

        - id: q_marital_status
          kind: Question
          title: "What is the respondent's marital status?"
          input:
            control: Dropdown
            labels:
              1: "Married"
              2: "Common-law"
              3: "Separated"
              4: "Divorced"
              5: "Widowed"
              6: "Single (never married)"

    # ===================================================================
    # BLOCK: EMPPRE MAIN — current / recent work activity (Q1-Q11).
    # ===================================================================
    # START-EMPPRE age gate: only respondents aged 15 or more enter EMPPRE.
    # Hoisted to the block precondition (shared by every item here); respondents
    # under 15 skip the whole block and converge on EXPRE/DEMPRE like the source.
    # ===================================================================
    - id: b_emppre_main
      kind: Group
      title: "Current or Recent Work Activity"
      precondition:
        - predicate: q_age.outcome >= 15
      items:
        # Q1: worked at a job in early January?
        - id: q_employment_status_q1
          kind: Question
          title: "Did the respondent work at a job or business at the beginning of January of this year? (Enter a job regardless of the number of hours worked.)"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Permanently unable to work"

        # Q2: had a job but absent? (only if Q1 = No)
        - id: q_employment_status_q2
          kind: Question
          title: "Did the respondent have a job or business at which he/she did not work at the beginning of January?"
          precondition:
            - predicate: q_employment_status_q1.outcome == 2
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q3: why absent? (only if Q2 = Yes)
        - id: q_employment_status_q3
          kind: Question
          title: "Why was the respondent absent from work at the beginning of January?"
          precondition:
            - predicate: q_employment_status_q1.outcome == 2
            - predicate: q_employment_status_q2.outcome == 1
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

        # Q4: received pay during absence? Reached when Q2=Yes and Q3 is not
        # school leave (Q3=6 routes straight to Q5).
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

        # Q5: ever worked? Reached from Q1=permanently-unable, or Q2=No, or
        # Q3=school leave.
        - id: q_employment_status_q5
          kind: Question
          title: "Did the respondent ever work at a job or business?"
          precondition:
            - predicate: q_employment_status_q1.outcome == 3 or (q_employment_status_q1.outcome == 2 and q_employment_status_q2.outcome == 0) or (q_employment_status_q1.outcome == 2 and q_employment_status_q2.outcome == 1 and q_employment_status_q3.outcome == 6)
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q6: when last worked (year)? Only if Q5=Yes.
        # Temporal / age-at-event: cannot be in the future, cannot precede birth.
        - id: q_employment_status_q6
          kind: Question
          title: "When did the respondent last work at a job or business? (Enter the year.)"
          precondition:
            - predicate: q_employment_status_q1.outcome == 3 or (q_employment_status_q1.outcome == 2 and q_employment_status_q2.outcome == 0) or (q_employment_status_q1.outcome == 2 and q_employment_status_q2.outcome == 1 and q_employment_status_q3.outcome == 6)
            - predicate: q_employment_status_q5.outcome == 1
          postcondition:
            - predicate: q_employment_status_q6.outcome <= current_year
              hint: "Year last worked cannot be in the future (after the interview year)."
            - predicate: q_employment_status_q6.outcome >= current_year - q_age.outcome
              hint: "Year last worked cannot be before the respondent was born (interview year minus age)."
          input:
            control: Editbox
            min: 1900
            max: 2010
            right: "year"

        # Q7: main reason for leaving last job. Only if Q5=Yes and NOT filtered
        # by N6 (permanently unable AND last worked more than 5 years ago).
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

        # Q8: looked for work in January? Reached via the temporary-layoff path
        # (Q3 in {8,9}) or the N7 path (ever-worked answered, respondent not
        # permanently unable). q1 != 1/3 keeps the currently-working and
        # permanently-unable respondents out.
        - id: q_employment_status_q8
          kind: Question
          title: "Did the respondent look for work in January of this year?"
          precondition:
            - predicate: q_employment_status_q1.outcome != 1
            - predicate: q_employment_status_q1.outcome != 3
            - predicate: (q_employment_status_q3.outcome in [8, 9]) or q_employment_status_q5.outcome == 0 or q_employment_status_q5.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q9: methods used to find work (multi-select). Only if Q8=Yes.
        - id: q_employment_status_q9
          kind: Question
          title: "What did the respondent do to find work?"
          precondition:
            - predicate: q_employment_status_q1.outcome != 1
            - predicate: q_employment_status_q1.outcome != 3
            - predicate: (q_employment_status_q3.outcome in [8, 9]) or q_employment_status_q5.outcome == 0 or q_employment_status_q5.outcome == 1
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

        # Q9 Other specify (bit 32 set)
        - id: q_q9_other
          kind: Question
          title: "Please specify the other method of job search:"
          precondition:
            - predicate: q_employment_status_q1.outcome != 1
            - predicate: q_employment_status_q1.outcome != 3
            - predicate: (q_employment_status_q3.outcome in [8, 9]) or q_employment_status_q5.outcome == 0 or q_employment_status_q5.outcome == 1
            - predicate: q_employment_status_q8.outcome == 1
            - predicate: q_employment_status_q9.outcome % 64 >= 32
          input:
            control: Textarea
            placeholder: "Specify method..."
            maxLength: 200

        # Q10: looked for work in the prior 6 months? Only if Q8=No.
        - id: q_employment_status_q10
          kind: Question
          title: "Did the respondent look for work at any time in the 6 months before that?"
          precondition:
            - predicate: q_employment_status_q1.outcome != 1
            - predicate: q_employment_status_q1.outcome != 3
            - predicate: (q_employment_status_q3.outcome in [8, 9]) or q_employment_status_q5.outcome == 0 or q_employment_status_q5.outcome == 1
            - predicate: q_employment_status_q8.outcome == 0
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q11: reasons for not looking (multi-select). Only if Q10=Yes.
        - id: q_employment_status_q11
          kind: Question
          title: "What were the reasons the respondent did not look for work in January of this year? (If only own illness or personal responsibilities, probe for other reasons.)"
          precondition:
            - predicate: q_employment_status_q1.outcome != 1
            - predicate: q_employment_status_q1.outcome != 3
            - predicate: (q_employment_status_q3.outcome in [8, 9]) or q_employment_status_q5.outcome == 0 or q_employment_status_q5.outcome == 1
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

        # Q11 Other specify (bit 2048 set)
        - id: q_q11_other
          kind: Question
          title: "Please specify the other reason for not looking for work:"
          precondition:
            - predicate: q_employment_status_q1.outcome != 1
            - predicate: q_employment_status_q1.outcome != 3
            - predicate: (q_employment_status_q3.outcome in [8, 9]) or q_employment_status_q5.outcome == 0 or q_employment_status_q5.outcome == 1
            - predicate: q_employment_status_q8.outcome == 0
            - predicate: q_employment_status_q10.outcome == 1
            - predicate: q_employment_status_q11.outcome % 4096 >= 2048
          input:
            control: Textarea
            placeholder: "Specify reason..."
            maxLength: 200

    # ===================================================================
    # BLOCK: EMPPRE J1 — first employer details (J1.Q1 .. J1.Q15).
    # ===================================================================
    # The block gate is the disjunction of the two mutually exclusive entry
    # conditions the source routes through: the MAIN-job path (J1.Q1) and the
    # LAST-job path (J1.Q1A). The baseline stored this as a has_employer_j1 flag
    # set in the two employer-name items' codeBlocks — but those items are
    # Textarea, whose codeBlocks the static builder does not model, so the flag
    # stayed frozen at 0 and every J1/J2 item classified unreachable. Wiring the
    # entry condition as a direct outcome disjunction (no variable) removes the
    # frozen gate entirely.
    #   ENTER_J1  = Q1=Yes, OR (Q1=No & absent-with-job & not school/layoff)
    #   ENTER_J1A = ever-worked & last worked in/after the reference year
    # ===================================================================
    - id: b_emppre_job1
      kind: Group
      title: "First Employer Details"
      precondition:
        - predicate: q_age.outcome >= 15
        - predicate: (q_employment_status_q1.outcome == 1 or (q_employment_status_q1.outcome == 2 and q_employment_status_q2.outcome == 1 and q_employment_status_q3.outcome not in [6, 8, 9])) or (q_employment_status_q5.outcome == 1 and q_employment_status_q6.outcome >= reference_year)
      items:
        # J1.Q1: main employer name (MAIN-job entry only).
        - id: q_j1_q1
          kind: Question
          title: "I would like to ask a few questions about the respondent's main job or business in early January. For whom did the respondent work? (Name of business, government department, agency, or person.)"
          precondition:
            - predicate: q_employment_status_q1.outcome == 1 or (q_employment_status_q1.outcome == 2 and q_employment_status_q2.outcome == 1 and q_employment_status_q3.outcome not in [6, 8, 9])
          input:
            control: Textarea
            placeholder: "Enter employer name..."
            maxLength: 500

        # J1.Q1A: last employer name (LAST-job entry only).
        - id: q_j1_q1a
          kind: Question
          title: "I would like to ask a few questions about the last job or business held by the respondent in the reference year. For whom did the respondent work? (Name of business, government department, agency, or person.)"
          precondition:
            - predicate: q_employment_status_q5.outcome == 1 and q_employment_status_q6.outcome >= reference_year
          input:
            control: Textarea
            placeholder: "Enter employer name..."
            maxLength: 500

        # J1.Q2: year first started working for this employer.
        # Temporal / age-at-event: not future, not before birth. J1.N2/J1.Q2A
        # consistency screen -> postcondition: on the last-job path (Q5=Yes, so
        # Q6 "last worked" was collected) the start year cannot be after the
        # last-worked year.
        - id: q_j1_q2
          kind: Question
          title: "When was the first time the respondent started working for this employer? (Enter the year.)"
          postcondition:
            - predicate: q_j1_q2.outcome <= current_year
              hint: "Year first started cannot be in the future (after the interview year)."
            - predicate: q_j1_q2.outcome >= current_year - q_age.outcome
              hint: "Year first started cannot be before the respondent was born (interview year minus age)."
            - predicate: q_employment_status_q5.outcome != 1 or q_j1_q2.outcome <= q_employment_status_q6.outcome
              hint: "Year first started working for this employer cannot be after the year the respondent last worked."
          input:
            control: Editbox
            min: 1900
            max: 2010
            right: "year"

        # J1.Q3: industry / kind of business.
        - id: q_j1_q3
          kind: Question
          title: "What kind of business, industry or service was this? (e.g., federal government, canning industry, forestry service)"
          input:
            control: Textarea
            placeholder: "Enter industry or business type..."
            maxLength: 500

        # J1.Q4: occupation / kind of work.
        - id: q_j1_q4
          kind: Question
          title: "What kind of work was the respondent doing? (e.g., office clerk, factory worker, forestry technician)"
          input:
            control: Textarea
            placeholder: "Enter occupation..."
            maxLength: 500

        # J1.Q5: main duties.
        - id: q_j1_q5
          kind: Question
          title: "What were the respondent's most important activities or duties? (e.g., filing documents, drying vegetables, forest examiner)"
          input:
            control: Textarea
            placeholder: "Enter main duties..."
            maxLength: 500

        # J1.Q6: class of worker. Paid worker (1) continues to the paid-worker
        # detail; any other class routes to N12 (block ends here for them).
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

        # J1.Q7A: months worked in the reference year (paid workers only).
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

        # J1.Q7B: specify months (Q7A = specify / last-worked-before).
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

        # J1.Q8: worked every week of the month? Not reached when Q7A=2
        # (started in the current year -> N12).
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

        # J1.Q9: weeks per month (Q8=No).
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

        # J1.Q10: usual paid hours per week.
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

        # J1.Q11A: wage or salary before deductions.
        - id: q_j1_q11a
          kind: Question
          title: "At this job, what was the respondent's wage or salary before taxes and deductions? (As of January, or when they last worked for this employer in the reference year.)"
          precondition:
            - predicate: q_j1_q6.outcome == 1
            - predicate: q_j1_q7a.outcome != 2
          input:
            control: Editbox
            min: 1
            max: 999999
            right: "dollars"

        # J1.Q11B: pay frequency.
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

        # J1.Q12: total earnings (Q11B = Other).
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

        # J1.Q13: received commissions/tips/bonuses/overtime?
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

        # J1.Q14: were those included in the amount reported? (Q13=Yes)
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

        # J1.Q15: total commissions/tips/bonuses (Q14=No).
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

    # ===================================================================
    # BLOCK: EMPPRE J2 — second employer details (J2.Q1 .. J2.Q16).
    # ===================================================================
    # J2 is only reached after the J1 paid-worker wage section (J1.Q6=paid AND
    # J1.Q7A not "started in current year"). Those two gates plus the J1 entry
    # disjunction and the 15+ age gate are shared by every J2 item, so they are
    # hoisted to the block precondition; J2.Q1 keeps no residual, and every later
    # J2 item keeps only its own residual (second job reported, class of worker,
    # etc.).
    # ===================================================================
    - id: b_emppre_job2
      kind: Group
      title: "Second Employer Details"
      precondition:
        - predicate: q_age.outcome >= 15
        - predicate: (q_employment_status_q1.outcome == 1 or (q_employment_status_q1.outcome == 2 and q_employment_status_q2.outcome == 1 and q_employment_status_q3.outcome not in [6, 8, 9])) or (q_employment_status_q5.outcome == 1 and q_employment_status_q6.outcome >= reference_year)
        - predicate: q_j1_q6.outcome == 1
        - predicate: q_j1_q7a.outcome != 2
      items:
        # J2.Q1: more than one job in January?
        - id: q_j2_q1
          kind: Question
          title: "Did the respondent have more than one job or business in January of this year?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # J2.Q2: second employer name (J2.Q1=Yes).
        - id: q_j2_q2
          kind: Question
          title: "I would like to ask a few questions about the respondent's other job or business in January of this year. For whom did the respondent work? (Name of business, government department, agency, or person.)"
          precondition:
            - predicate: q_j2_q1.outcome == 1
          input:
            control: Textarea
            placeholder: "Enter employer name..."
            maxLength: 500

        # J2.Q3: year first started with this employer.
        # Temporal / age-at-event: not future, not before birth.
        - id: q_j2_q3
          kind: Question
          title: "When did the respondent first start working for this employer? (Enter the year.)"
          precondition:
            - predicate: q_j2_q1.outcome == 1
          postcondition:
            - predicate: q_j2_q3.outcome <= current_year
              hint: "Year first started cannot be in the future (after the interview year)."
            - predicate: q_j2_q3.outcome >= current_year - q_age.outcome
              hint: "Year first started cannot be before the respondent was born (interview year minus age)."
          input:
            control: Editbox
            min: 1900
            max: 2010
            right: "year"

        # J2.Q4: industry / kind of business.
        - id: q_j2_q4
          kind: Question
          title: "What kind of business, industry or service was this? (e.g., federal government, canning industry, forestry services)"
          precondition:
            - predicate: q_j2_q1.outcome == 1
          input:
            control: Textarea
            placeholder: "Enter industry or business type..."
            maxLength: 500

        # J2.Q5: occupation / kind of work.
        - id: q_j2_q5
          kind: Question
          title: "What kind of work was the respondent doing? (e.g., office clerk, factory worker, forestry technician)"
          precondition:
            - predicate: q_j2_q1.outcome == 1
          input:
            control: Textarea
            placeholder: "Enter occupation..."
            maxLength: 500

        # J2.Q6: main duties.
        - id: q_j2_q6
          kind: Question
          title: "What were the respondent's most important activities or duties? (e.g., filing documents, drying vegetables, forest examiner)"
          precondition:
            - predicate: q_j2_q1.outcome == 1
          input:
            control: Textarea
            placeholder: "Enter main duties..."
            maxLength: 500

        # J2.Q7: class of worker. Paid worker (1) continues; else -> N12.
        - id: q_j2_q7
          kind: Question
          title: "In this job, was the respondent a paid worker, self-employed or an unpaid family worker?"
          precondition:
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

        # J2.Q8A: months worked in the reference year (paid workers only).
        - id: q_j2_q8a
          kind: Question
          title: "In which months of the reference year did the respondent work at this job?"
          precondition:
            - predicate: q_j2_q1.outcome == 1
            - predicate: q_j2_q7.outcome == 1
          input:
            control: Radio
            labels:
              1: "All months"
              2: "Started in current year"
              3: "Specify months"
              4: "Last worked before reference year"

        # J2.Q8B: specify months (Q8A = specify / last-worked-before).
        - id: q_j2_q8b
          kind: Question
          title: "Specify the months the respondent worked in the reference year:"
          precondition:
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

        # J2.Q9: worked every week of the month? Not reached when Q8A=2.
        - id: q_j2_q9
          kind: Question
          title: "At this job, did the respondent usually work every week of the month?"
          precondition:
            - predicate: q_j2_q1.outcome == 1
            - predicate: q_j2_q7.outcome == 1
            - predicate: q_j2_q8a.outcome != 2
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # J2.Q10: weeks per month (Q9=No).
        - id: q_j2_q10
          kind: Question
          title: "How many weeks did the respondent usually work each month?"
          precondition:
            - predicate: q_j2_q1.outcome == 1
            - predicate: q_j2_q7.outcome == 1
            - predicate: q_j2_q8a.outcome != 2
            - predicate: q_j2_q9.outcome == 0
          input:
            control: Editbox
            min: 1
            max: 3
            right: "weeks"

        # J2.Q11: usual paid hours per week.
        - id: q_j2_q11
          kind: Question
          title: "How many hours per week did the respondent usually get paid?"
          precondition:
            - predicate: q_j2_q1.outcome == 1
            - predicate: q_j2_q7.outcome == 1
            - predicate: q_j2_q8a.outcome != 2
          input:
            control: Editbox
            min: 1
            max: 99
            right: "hours"

        # J2.Q12A: wage or salary before deductions.
        - id: q_j2_q12a
          kind: Question
          title: "At this job, what was the respondent's wage or salary before taxes and deductions?"
          precondition:
            - predicate: q_j2_q1.outcome == 1
            - predicate: q_j2_q7.outcome == 1
            - predicate: q_j2_q8a.outcome != 2
          input:
            control: Editbox
            min: 1
            max: 999999
            right: "dollars"

        # J2.Q12B: pay frequency.
        - id: q_j2_q12b
          kind: Question
          title: "Select the appropriate category for the reported wage or salary:"
          precondition:
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

        # J2.Q13: total earnings (Q12B = Other).
        - id: q_j2_q13
          kind: Question
          title: "What were the respondent's total earnings from this job in the reference year?"
          precondition:
            - predicate: q_j2_q1.outcome == 1
            - predicate: q_j2_q7.outcome == 1
            - predicate: q_j2_q8a.outcome != 2
            - predicate: q_j2_q12b.outcome == 6
          input:
            control: Editbox
            min: 1
            max: 999999
            right: "dollars"

        # J2.Q14: received commissions/tips/bonuses/overtime?
        - id: q_j2_q14
          kind: Question
          title: "Did the respondent receive any commissions, tips, bonuses or paid overtime from this job in the reference year?"
          precondition:
            - predicate: q_j2_q1.outcome == 1
            - predicate: q_j2_q7.outcome == 1
            - predicate: q_j2_q8a.outcome != 2
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # J2.Q15: were those included in the amount reported? (Q14=Yes)
        - id: q_j2_q15
          kind: Question
          title: "Were these commissions, tips, bonuses or paid overtime included in the amount just reported?"
          precondition:
            - predicate: q_j2_q1.outcome == 1
            - predicate: q_j2_q7.outcome == 1
            - predicate: q_j2_q8a.outcome != 2
            - predicate: q_j2_q14.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # J2.Q16: total commissions/tips/bonuses (Q15=No).
        - id: q_j2_q16
          kind: Question
          title: "What were the respondent's total earnings in the reference year from these commissions, tips, bonuses, or paid overtime?"
          precondition:
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
    # BLOCK: EMPPRE SCHOOL — January school attendance (Q12, Q13).
    # ===================================================================
    # N12 convergence: everyone who finishes the EMPPRE paths reaches N12, and
    # only respondents aged 64 or under are asked the school questions (age > 64
    # routes straight to EXPRE). age 15..64 hoisted to the block precondition.
    # ===================================================================
    - id: b_emppre_school
      kind: Group
      title: "School Attendance"
      precondition:
        - predicate: q_age.outcome >= 15
        - predicate: q_age.outcome <= 64
      items:
        # Q12: attending school/college/university in January?
        - id: q_employment_status_q12
          kind: Question
          title: "In January of this year, was the respondent attending a school, college or university?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q13: full-time or part-time student? (Q12=Yes)
        - id: q_employment_status_q13
          kind: Question
          title: "Was the respondent enrolled as a full-time or part-time student?"
          precondition:
            - predicate: q_employment_status_q12.outcome == 1
          input:
            control: Radio
            labels:
              1: "Full-time student"
              2: "Part-time student"
              3: "Some of each"

    # ===================================================================
    # BLOCK: EXPRE — full-time work experience history.
    # ===================================================================
    # EXPRE-N1 age gate: respondents over 69 skip the whole module (route to
    # DEMPRE). Respondents under 15 who skipped EMPPRE also arrive here. The
    # single shared gate is age <= 69, hoisted to the block precondition.
    #
    # The two source sum-check constraint screens (N4/Q4D and N6/Q6D) convert to
    # explicit part-whole equality postconditions on the last component of each
    # trio (Pattern 4 + part-whole mining), so no separate constraint-screen
    # Comment item is emitted.
    # ===================================================================
    - id: b_expre
      kind: Group
      title: "Work Experience"
      precondition:
        - predicate: q_age.outcome <= 69
      items:
        # Q1A: ever worked full-time?
        - id: q_work_experience_q1a
          kind: Question
          title: "The next few questions are about work experience, thinking back to when the respondent first started working. Did the respondent ever work full-time? (Exclude summer jobs while in school.)"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No, never worked full-time"
              3: "No, only worked full-time at summer jobs while in school"

        # Q1B: how many years ago did full-time work first start? (Q1A=Yes)
        # Age-at-event: cannot have started full-time work more years ago than
        # roughly age minus 10 (the source's own hard lower bound on start age).
        - id: q_q1b
          kind: Question
          title: "How many years ago did the respondent first start working full-time? (Exclude summer jobs while in school. Enter 0 if less than one year.)"
          precondition:
            - predicate: q_work_experience_q1a.outcome == 1
          postcondition:
            - predicate: q_q1b.outcome <= q_age.outcome - 10
              hint: "Years since first full-time work cannot exceed the respondent's age minus 10 (nobody starts full-time work before about age 10)."
          input:
            control: Editbox
            min: 0
            max: 60
            right: "years"

        # Q2A: any non-working years? (Q1B >= 2)
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

        # Q2B: how many years not working? (Q2A=Yes)
        # Part-whole: cannot exceed the total years since first full-time work.
        - id: q_work_experience_q2b
          kind: Question
          title: "How many years did the respondent not work at a job or business?"
          precondition:
            - predicate: q_work_experience_q1a.outcome == 1
            - predicate: q_q1b.outcome >= 2
            - predicate: q_q2a.outcome == 1
          postcondition:
            - predicate: q_work_experience_q2b.outcome <= q_q1b.outcome
              hint: "Years not working cannot exceed the total years since the respondent first started full-time work."
          input:
            control: Editbox
            min: 1
            max: 60
            right: "years"

        # Q3: worked 6+ months every year? Reached when Q1B=1 (Q2A/Q2B skipped)
        # or Q1B>=2 and Q2A=No.
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

        # Q4A: years worked only full-time. (Q3=Yes)
        - id: q_q4a
          kind: Question
          title: "How many years did the respondent work only full-time? (By full-time I mean 30 or more hours per week. Enter 0 if none.)"
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

        # Q4B: years worked only part-time.
        - id: q_q4b
          kind: Question
          title: "How many years did the respondent work only part-time? (Enter 0 if none.)"
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

        # Q4C: years worked some of each. Part-whole (N4/Q4D): the three
        # categories must sum to the total years since first full-time work.
        - id: q_q4c
          kind: Question
          title: "How many years did the respondent work some of each (full-time and part-time)? (Enter 0 if none.)"
          precondition:
            - predicate: q_work_experience_q1a.outcome == 1
            - predicate: q_q1b.outcome >= 1
            - predicate: q_q1b.outcome == 1 or q_q2a.outcome == 0
            - predicate: q_work_experience_q3.outcome == 1
          postcondition:
            - predicate: q_q4a.outcome + q_q4b.outcome + q_q4c.outcome == q_q1b.outcome
              hint: "Years full-time, part-time, and some-of-each must add up to the total years since the respondent first started full-time work."
          input:
            control: Editbox
            min: 0
            max: 60
            right: "years"

        # Q5A: years worked 6+ months of the year. Reached via the Q2B path
        # (Q2A=Yes) or the Q3=No path. Part-whole: cannot exceed total years,
        # and when non-working years were reported (Q2A=Yes) cannot exceed the
        # working years (total minus non-working).
        - id: q_q5a
          kind: Question
          title: "Since the respondent first started working, how many years did he/she work at least 6 months of the year? (Enter 0 if none.)"
          precondition:
            - predicate: q_work_experience_q1a.outcome == 1
            - predicate: q_q1b.outcome >= 1
            - predicate: q_q2a.outcome == 1 or q_work_experience_q3.outcome == 0
          postcondition:
            - predicate: q_q5a.outcome <= q_q1b.outcome
              hint: "Years working 6+ months cannot exceed the total years since first full-time work."
            - predicate: q_q2a.outcome != 1 or q_q5a.outcome <= q_q1b.outcome - q_work_experience_q2b.outcome
              hint: "Years working 6+ months cannot exceed the total years minus the years not working."
          input:
            control: Editbox
            min: 0
            max: 60
            right: "years"

        # Q6A: of those years, how many only full-time. (Q5A >= 1)
        - id: q_q6a
          kind: Question
          title: "In those years, how many did the respondent work only full-time? (By full-time I mean 30 or more hours per week. Enter 0 if none.)"
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

        # Q6B: of those years, how many only part-time.
        - id: q_q6b
          kind: Question
          title: "In those years, how many did the respondent work only part-time? (Enter 0 if none.)"
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

        # Q6C: of those years, how many some of each. Part-whole (N6/Q6D): the
        # three categories must sum to the years working 6+ months (Q5A).
        - id: q_q6c
          kind: Question
          title: "In those years, how many did the respondent work some of each (full-time and part-time)? (Enter 0 if none.)"
          precondition:
            - predicate: q_work_experience_q1a.outcome == 1
            - predicate: q_q1b.outcome >= 1
            - predicate: q_q2a.outcome == 1 or q_work_experience_q3.outcome == 0
            - predicate: q_q5a.outcome >= 1
          postcondition:
            - predicate: q_q6a.outcome + q_q6b.outcome + q_q6c.outcome == q_q5a.outcome
              hint: "Years full-time, part-time, and some-of-each must add up to the years the respondent worked 6+ months (Q5A)."
          input:
            control: Editbox
            min: 0
            max: 60
            right: "years"

    # ===================================================================
    # BLOCK: DEMPRE MARITAL HISTORY — marriage/partner dates.
    # ===================================================================
    # DEMPRE-N1..N1F route by marital status. Each item gates on the real
    # q_marital_status.outcome (married=1, common-law=2, separated=3,
    # divorced=4, widowed=5, single=6). The COMPARE-* consistency screens
    # (COMPARE-Q2/Q4/9A/9B/10A/10B) become relational date-ordering
    # postconditions on the later item of each pair, guarded by marital status
    # where the pairing is status-specific. current_marriage_year consolidates
    # the current-marriage year across the married and separated/divorced paths.
    # Every date also carries the age-at-event chain (not future, not before
    # birth = interview year minus age).
    # ===================================================================
    - id: b_marital_history
      kind: Group
      title: "Marital History"
      items:
        # DEMPRE-Q1A: intro (Read).
        - id: q_demographics_q1a
          kind: Comment
          title: "The next few questions are about the respondent's family background and are based on the date of birth and marital status reported earlier in the interview."

        # DEMPRE-Q1: separation date (separated / divorced).
        - id: q_demographics_q1
          kind: Question
          title: "What was the date of the respondent's separation? (Not the date of divorce. Enter the year.)"
          precondition:
            - predicate: q_marital_status.outcome in [3, 4]
          postcondition:
            - predicate: q_demographics_q1.outcome <= current_year
              hint: "Year of separation cannot be in the future (after the interview year)."
            - predicate: q_demographics_q1.outcome >= current_year - q_age.outcome
              hint: "Year of separation cannot be before the respondent was born (interview year minus age)."
          input:
            control: Editbox
            min: 1870
            max: 2010
            right: "year"

        # DEMPRE-Q2: current marriage date (separated / divorced).
        # COMPARE-Q2: marriage must be on/before the separation.
        - id: q_demographics_q2
          kind: Question
          title: "What was the date of this marriage? (Enter the year.)"
          precondition:
            - predicate: q_marital_status.outcome in [3, 4]
          postcondition:
            - predicate: q_demographics_q2.outcome <= q_demographics_q1.outcome
              hint: "Date of marriage must be on or before the date of separation."
            - predicate: q_demographics_q2.outcome <= current_year
              hint: "Year of marriage cannot be in the future (after the interview year)."
            - predicate: q_demographics_q2.outcome >= current_year - q_age.outcome
              hint: "Year of marriage cannot be before the respondent was born (interview year minus age)."
          codeBlock: |
            current_marriage_year = q_demographics_q2.outcome
          input:
            control: Editbox
            min: 1870
            max: 2010
            right: "year"

        # DEMPRE-Q2B: marriage date (married path).
        - id: q_demographics_q2b
          kind: Question
          title: "What was the date of the respondent's marriage? (Enter the year.)"
          precondition:
            - predicate: q_marital_status.outcome == 1
          postcondition:
            - predicate: q_demographics_q2b.outcome <= current_year
              hint: "Year of marriage cannot be in the future (after the interview year)."
            - predicate: q_demographics_q2b.outcome >= current_year - q_age.outcome
              hint: "Year of marriage cannot be before the respondent was born (interview year minus age)."
          codeBlock: |
            current_marriage_year = q_demographics_q2b.outcome
          input:
            control: Editbox
            min: 1870
            max: 2010
            right: "year"

        # DEMPRE-Q3: was this the first marriage? (married + separated/divorced)
        - id: q_demographics_q3
          kind: Question
          title: "Was this the respondent's first marriage?"
          precondition:
            - predicate: q_marital_status.outcome in [1, 3, 4]
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # DEMPRE-Q4: first marriage date (Q3=No).
        # COMPARE-Q4: first marriage must be on/before the current marriage.
        - id: q_demographics_q4
          kind: Question
          title: "What was the date of the respondent's first marriage? (Enter the year.)"
          precondition:
            - predicate: q_marital_status.outcome in [1, 3, 4]
            - predicate: q_demographics_q3.outcome == 2
          postcondition:
            - predicate: q_demographics_q4.outcome <= current_marriage_year
              hint: "Date of first marriage must be on or before the date of the current/most-recent marriage."
            - predicate: q_demographics_q4.outcome <= current_year
              hint: "Year of first marriage cannot be in the future (after the interview year)."
            - predicate: q_demographics_q4.outcome >= current_year - q_age.outcome
              hint: "Year of first marriage cannot be before the respondent was born (interview year minus age)."
          input:
            control: Editbox
            min: 1870
            max: 2010
            right: "year"

        # DEMPRE-Q5: began living together (common-law).
        - id: q_demographics_q5
          kind: Question
          title: "When did the respondent and his/her partner begin to live together? (Enter the year.)"
          precondition:
            - predicate: q_marital_status.outcome == 2
          postcondition:
            - predicate: q_demographics_q5.outcome <= current_year
              hint: "Year the couple began living together cannot be in the future (after the interview year)."
            - predicate: q_demographics_q5.outcome >= current_year - q_age.outcome
              hint: "Year the couple began living together cannot be before the respondent was born (interview year minus age)."
          input:
            control: Editbox
            min: 1870
            max: 2010
            right: "year"

        # DEMPRE-Q6: ever been married? (common-law)
        - id: q_demographics_q6
          kind: Question
          title: "Has the respondent ever been married?"
          precondition:
            - predicate: q_marital_status.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # DEMPRE-Q7: when widowed? (widowed)
        - id: q_demographics_q7
          kind: Question
          title: "When was the respondent widowed? (Enter the year.)"
          precondition:
            - predicate: q_marital_status.outcome == 5
          postcondition:
            - predicate: q_demographics_q7.outcome <= current_year
              hint: "Year widowed cannot be in the future (after the interview year)."
            - predicate: q_demographics_q7.outcome >= current_year - q_age.outcome
              hint: "Year widowed cannot be before the respondent was born (interview year minus age)."
          input:
            control: Editbox
            min: 1870
            max: 2010
            right: "year"

        # DEMPRE-Q8: was this the first marriage? (common-law-ever-married or widowed)
        - id: q_demographics_q8
          kind: Question
          title: "Was this the respondent's first marriage?"
          precondition:
            - predicate: (q_marital_status.outcome == 2 and q_demographics_q6.outcome == 1) or q_marital_status.outcome == 5
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # DEMPRE-Q9: marriage date, first-marriage path (Q8=Yes).
        # COMPARE9A: marriage on/before widowed (widowed path).
        # COMPARE9B: marriage on/before living together (common-law path).
        - id: q_demographics_q9
          kind: Question
          title: "What was the date of the respondent's marriage? (Enter the year.)"
          precondition:
            - predicate: (q_marital_status.outcome == 2 and q_demographics_q6.outcome == 1) or q_marital_status.outcome == 5
            - predicate: q_demographics_q8.outcome == 1
          postcondition:
            - predicate: q_marital_status.outcome != 5 or q_demographics_q9.outcome <= q_demographics_q7.outcome
              hint: "Date of marriage must be on or before the date the respondent was widowed."
            - predicate: q_marital_status.outcome != 2 or q_demographics_q9.outcome <= q_demographics_q5.outcome
              hint: "Date of marriage must be on or before the date the couple began living together."
            - predicate: q_demographics_q9.outcome <= current_year
              hint: "Year of marriage cannot be in the future (after the interview year)."
            - predicate: q_demographics_q9.outcome >= current_year - q_age.outcome
              hint: "Year of marriage cannot be before the respondent was born (interview year minus age)."
          input:
            control: Editbox
            min: 1870
            max: 2010
            right: "year"

        # DEMPRE-Q10: first marriage date, not-first-marriage path (Q8=No).
        # COMPARE10A: first marriage on/before living together (common-law).
        # COMPARE10B: first marriage on/before widowed (widowed).
        - id: q_demographics_q10
          kind: Question
          title: "What was the date of the respondent's first marriage? (Enter the year.)"
          precondition:
            - predicate: (q_marital_status.outcome == 2 and q_demographics_q6.outcome == 1) or q_marital_status.outcome == 5
            - predicate: q_demographics_q8.outcome == 2
          postcondition:
            - predicate: q_marital_status.outcome != 2 or q_demographics_q10.outcome <= q_demographics_q5.outcome
              hint: "Date of first marriage must be on or before the date the couple began living together."
            - predicate: q_marital_status.outcome != 5 or q_demographics_q10.outcome <= q_demographics_q7.outcome
              hint: "Date of first marriage must be on or before the date the respondent was widowed."
            - predicate: q_demographics_q10.outcome <= current_year
              hint: "Year of first marriage cannot be in the future (after the interview year)."
            - predicate: q_demographics_q10.outcome >= current_year - q_age.outcome
              hint: "Year of first marriage cannot be before the respondent was born (interview year minus age)."
          input:
            control: Editbox
            min: 1870
            max: 2010
            right: "year"

    # ===================================================================
    # BLOCK: DEMPRE BIRTH HISTORY — children (female, 18+).
    # ===================================================================
    # DEMPRE-N11A gate: asked only of female respondents aged 18 and over.
    # Hoisted to the block precondition.
    # ===================================================================
    - id: b_birth_history
      kind: Group
      title: "Birth History"
      precondition:
        - predicate: q_sex.outcome == 2
        - predicate: q_age.outcome >= 18
      items:
        # DEMPRE-Q11: has children?
        - id: q_demographics_q11
          kind: Question
          title: "Has the respondent had any children?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Don't know"

        # DEMPRE-Q12: how many children ever born? (Q11=Yes)
        - id: q_demographics_q12
          kind: Question
          title: "How many children were ever born to the respondent? (Enter 0 if none.)"
          precondition:
            - predicate: q_demographics_q11.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 20
            right: "children"

        # DEMPRE-Q13: year of first birth. (Q12 >= 1)
        # Age-at-event: the mother cannot have given birth before her own birth,
        # nor in the future.
        - id: q_demographics_q13
          kind: Question
          title: "In what year did the respondent give birth to her first child?"
          precondition:
            - predicate: q_demographics_q11.outcome == 1
            - predicate: q_demographics_q12.outcome >= 1
          postcondition:
            - predicate: q_demographics_q13.outcome <= current_year
              hint: "Year of first birth cannot be in the future (after the interview year)."
            - predicate: q_demographics_q13.outcome >= current_year - q_age.outcome
              hint: "Year of first birth cannot be before the respondent was born (interview year minus age)."
          input:
            control: Editbox
            min: 1870
            max: 2010
            right: "year"

        # DEMPRE-Q14: adopted or raised children? (Q11 = Yes or No)
        # INPATH-Q12 screener consistency: a respondent who said she had children
        # (Q11=Yes) but that none were born to her (Q12=0) must have raised or
        # adopted children (Q14 cannot be No).
        - id: q_demographics_q14
          kind: Question
          title: "(Other than children the respondent has given birth to) Has the respondent adopted or raised any children?"
          precondition:
            - predicate: q_demographics_q11.outcome in [1, 2]
          postcondition:
            - predicate: q_demographics_q11.outcome != 1 or q_demographics_q12.outcome >= 1 or q_demographics_q14.outcome != 2
              hint: "The respondent reported having children but none born to her, so she must have adopted or raised children."
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # DEMPRE-Q15: how many adopted/raised? (Q14=Yes)
        - id: q_demographics_q15
          kind: Question
          title: "How many (other) children has the respondent adopted or raised?"
          precondition:
            - predicate: q_demographics_q14.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 20
            right: "children"

    # ===================================================================
    # BLOCK: DEMPRE BACKGROUND — language, birthplace, immigration, ethnicity.
    # ===================================================================
    # Reached by every respondent (all marital/birth paths converge here).
    # ===================================================================
    - id: b_background
      kind: Group
      title: "Background"
      items:
        # DEMPRE-Q16: first language learned and still understood.
        - id: q_demographics_q16
          kind: Question
          title: "What is the language that the respondent first learned at home in childhood and still understands?"
          input:
            control: Radio
            labels:
              1: "English"
              2: "French"
              3: "Other"

        # DEMPRE-Q16 Other specify.
        - id: q_q16_other
          kind: Question
          title: "Please specify the language:"
          precondition:
            - predicate: q_demographics_q16.outcome == 3
          input:
            control: Textarea
            placeholder: "Specify language..."
            maxLength: 200

        # DEMPRE-Q17: country of birth.
        - id: q_demographics_q17
          kind: Question
          title: "In what country was the respondent born?"
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

        # DEMPRE-Q17 Other specify.
        - id: q_q17_other
          kind: Question
          title: "Please specify the country:"
          precondition:
            - predicate: q_demographics_q17.outcome == 7
          input:
            control: Textarea
            placeholder: "Specify country..."
            maxLength: 200

        # DEMPRE-Q18: immigrated to Canada? (born outside Canada)
        - id: q_demographics_q18
          kind: Question
          title: "Did the respondent immigrate to Canada?"
          precondition:
            - predicate: q_demographics_q17.outcome != 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No (never immigrated - Canadian citizen by birth)"

        # DEMPRE-Q18B: year of immigration. (Q18=Yes)
        # Age-at-event: cannot immigrate in the future, nor before birth.
        - id: q_q18b
          kind: Question
          title: "In what year was that?"
          precondition:
            - predicate: q_demographics_q17.outcome != 1
            - predicate: q_demographics_q18.outcome == 1
          postcondition:
            - predicate: q_q18b.outcome <= current_year
              hint: "Year of immigration cannot be in the future (after the interview year)."
            - predicate: q_q18b.outcome >= current_year - q_age.outcome
              hint: "Year of immigration cannot be before the respondent was born (interview year minus age)."
          input:
            control: Editbox
            min: 1870
            max: 2010
            right: "year"

        # DEMPRE-Q19: registered Indian?
        - id: q_q19
          kind: Question
          title: "Is the respondent a Registered Indian as defined by the Indian Act of Canada?"
          input:
            control: Radio
            labels:
              1: "Yes, Registered Indian"
              2: "No"

        # DEMPRE-Q20: ethnic/cultural/racial background (multi-select).
        - id: q_q20
          kind: Question
          title: "Canadians come from many ethnic, cultural and racial backgrounds. What is the respondent's background? (Mark all that apply.)"
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

        # DEMPRE-Q20A: specify other background (bit 131072 set).
        - id: q_q20a
          kind: Question
          title: "Please specify the other ethnic background not already given:"
          precondition:
            - predicate: q_q20.outcome % 262144 >= 131072
          input:
            control: Textarea
            placeholder: "Specify ethnic background..."
            maxLength: 200

    # ===================================================================
    # BLOCK: EDUPRE — educational attainment.
    # ===================================================================
    # Reached by every respondent. The source VERIFY-* age-consistency screens
    # (VERIFY-Q1/Q11/Q13) become relational age-bound postconditions: schooling
    # years cannot exceed the years the respondent has been of school age.
    # ===================================================================
    - id: b_edupre
      kind: Group
      title: "Educational Attainment"
      items:
        # Q1: years of elementary and high school.
        # VERIFY-Q1: cannot exceed age minus 5 (school starts about age 5).
        - id: q_education_q1
          kind: Question
          title: "How many years of elementary and high school did the respondent complete?"
          postcondition:
            - predicate: q_education_q1.outcome <= q_age.outcome - 5
              hint: "Years of elementary and high school cannot exceed the respondent's age minus 5."
          input:
            control: Editbox
            min: 0
            max: 15
            right: "years"

        # Q2: province of schooling. (Q1 >= 1; Q1=0 skips to parents' education)
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

        # Q3: completed high school? (EVAL-Q1: only asked when Q1 >= 10)
        - id: q_education_q3
          kind: Question
          title: "Did the respondent complete high school?"
          precondition:
            - predicate: q_education_q1.outcome >= 10
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q4: ever enrolled in a non-university school? (Q1 >= 1)
        - id: q_education_q4
          kind: Question
          title: "Excluding university, has the respondent ever been enrolled in any other kind of school (community college, business school, trade or vocational school, or CEGEP)?"
          precondition:
            - predicate: q_education_q1.outcome >= 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q5: received certificates or diplomas? (Q4=Yes)
        - id: q_education_q5
          kind: Question
          title: "Has the respondent received any certificates or diplomas as a result of this education?"
          precondition:
            - predicate: q_education_q4.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q6: type of school for the most recent certificate. (Q5=Yes)
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

        # Q6 Other specify.
        - id: q_q6_other
          kind: Question
          title: "Please specify the type of school:"
          precondition:
            - predicate: q_education_q6.outcome == 5
          input:
            control: Textarea
            placeholder: "Type of school..."
            maxLength: 200

        # Q7: months or years to complete the program? (Q5=Yes)
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

        # Q7A: number of months. (Q7=months)
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

        # Q7B: number of years. (Q7=years)
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

        # Q8: full-time, part-time, or some of each? (Q5=Yes)
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

        # Q9: year certificate/diploma received. (Q5=Yes)
        # Age-at-event: not future, not before birth.
        - id: q_education_q9
          kind: Question
          title: "In what year did the respondent receive his/her certificate or diploma?"
          precondition:
            - predicate: q_education_q5.outcome == 1
          postcondition:
            - predicate: q_education_q9.outcome <= current_year
              hint: "Year the certificate/diploma was received cannot be in the future (after the interview year)."
            - predicate: q_education_q9.outcome >= current_year - q_age.outcome
              hint: "Year the certificate/diploma was received cannot be before the respondent was born (interview year minus age)."
          input:
            control: Editbox
            min: 1900
            max: 2010
            right: "year"

        # Q10: major field of study (non-university). (Q5=Yes)
        - id: q_education_q10
          kind: Question
          title: "What was the major subject or field of study?"
          precondition:
            - predicate: q_education_q5.outcome == 1
          input:
            control: Textarea
            placeholder: "Major field of study..."
            maxLength: 300

        # Q11: total years of non-university schooling. (Q4=Yes)
        # VERIFY-Q11: cannot exceed age minus 14 (post-secondary starts ~14+).
        - id: q_education_q11
          kind: Question
          title: "In total, how many years of schooling did the respondent complete at a community college, technical institute, trade or vocational school, or CEGEP? (Enter 0 if less than one year.)"
          precondition:
            - predicate: q_education_q4.outcome == 1
          postcondition:
            - predicate: q_education_q11.outcome <= q_age.outcome - 14
              hint: "Years of college/trade schooling cannot exceed the respondent's age minus 14."
          input:
            control: Editbox
            min: 0
            max: 20
            right: "years"

        # Q12: ever enrolled in a university? (Q1 >= 1)
        - id: q_education_q12
          kind: Question
          title: "Has the respondent ever been enrolled in a university?"
          precondition:
            - predicate: q_education_q1.outcome >= 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q13: years of university completed. (Q12=Yes)
        # VERIFY-Q13: cannot exceed age minus 14.
        - id: q_education_q13
          kind: Question
          title: "How many years of university has the respondent completed? (Enter 0 if attended but did not complete the year.)"
          precondition:
            - predicate: q_education_q12.outcome == 1
          postcondition:
            - predicate: q_education_q13.outcome <= q_age.outcome - 14
              hint: "Years of university cannot exceed the respondent's age minus 14."
          input:
            control: Editbox
            min: 0
            max: 20
            right: "years"

        # Q14: university degrees received? (Q12=Yes)
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

        # Q14A: specify degrees (multi-select). (Q14=Specify)
        - id: q_q14a
          kind: Question
          title: "Specify the degrees, certificates, or diplomas the respondent has received from a university. Mark all that apply."
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

        # Q15: year highest degree received. (Q14=Specify or DK/R)
        # Age-at-event: not future, not before birth.
        - id: q_education_q15
          kind: Question
          title: "What year did the respondent receive his/her highest degree?"
          precondition:
            - predicate: q_education_q14.outcome >= 2
          postcondition:
            - predicate: q_education_q15.outcome <= current_year
              hint: "Year the degree was received cannot be in the future (after the interview year)."
            - predicate: q_education_q15.outcome >= current_year - q_age.outcome
              hint: "Year the degree was received cannot be before the respondent was born (interview year minus age)."
          input:
            control: Editbox
            min: 1900
            max: 2010
            right: "year"

        # Q16: major field of study (university). (Q14=Specify)
        - id: q_education_q16
          kind: Question
          title: "What was the major field of study?"
          precondition:
            - predicate: q_education_q14.outcome == 2
          input:
            control: Textarea
            placeholder: "Major field of study..."
            maxLength: 300

        # Q17: mother's highest level of education (everyone).
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

        # Q18: father's highest level of education (everyone; final item).
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
