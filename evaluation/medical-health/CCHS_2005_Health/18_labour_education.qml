qmlVersion: '1.0'
questionnaire:
  title: 18 Labour Education
  codeInit: |
    # Extern variables from prior sections
    age: range(12, 120)
    sex: {1, 2}
    # GEN_Q08: Worked at job past 12 months (from General Health)
    gen_q08: {1, 2}
    # Track multiple-job and weeks-worked for downstream routing
    had_multiple_jobs = 0
    weeks_worked = 0
    weeks_looking = 0
    # Whether there are other household members aged 14+ besides selected respondent
    has_other_hh_members_14plus: {0, 1}
  blocks:
  - id: b_current_employment
    title: Current Employment Status
    precondition:
    - predicate: age >= 15
    - predicate: age <= 75
    items:
    - id: q_lbf_qint
      kind: Comment
      title: The next few questions concern your activities in the last 7 days.
    - id: q_lbf_q01
      kind: Question
      title: Last week, did you work at a job or a business?
      postcondition:
      - predicate: not (gen_q08 == 2 and q_lbf_q01.outcome == 1)
        hint: Earlier you indicated you did not work in the past 12 months, but now report working last week. Please verify.
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Permanently unable to work
    - id: q_lbf_q02
      kind: Question
      title: Last week, did you have a job or business from which you were absent?
      precondition:
      - predicate: q_lbf_q01.outcome == 2
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
  - id: b_job_details
    title: Job Details
    precondition:
    - predicate: age >= 15
    - predicate: age <= 75
    - predicate: q_lbf_q01.outcome == 1 or (q_lbf_q01.outcome == 2 and q_lbf_q02.outcome == 1)
    items:
    - id: q_lbf_q03
      kind: Question
      title: Did you have more than one job or business last week?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_lbf_qint3
      kind: Comment
      title: The next questions are about your current or most recent job or business.
    - id: q_lbf_q31
      kind: Question
      title: Are you an employee or self-employed?
      input:
        control: Radio
        labels:
          1: Employee
          2: Self-employed
          3: Working in a family business without pay
    - id: q_lbf_q31a
      kind: Question
      title: Do you have any employees?
      precondition:
      - predicate: q_lbf_q31.outcome == 2
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_lbf_q32
      kind: Question
      title: What is the name of your business?
      precondition:
      - predicate: q_lbf_q31.outcome == 2
      input:
        control: Textarea
        placeholder: Business name...
        maxLength: 200
    - id: q_lbf_q33
      kind: Question
      title: For whom do you work?
      precondition:
      - predicate: q_lbf_q31.outcome == 1 or q_lbf_q31.outcome == 3
      input:
        control: Textarea
        placeholder: Employer name...
        maxLength: 200
    - id: q_lbf_q34
      kind: Question
      title: What kind of business, industry or service is this?
      input:
        control: Textarea
        placeholder: Business type...
        maxLength: 200
    - id: q_lbf_q35
      kind: Question
      title: What kind of work are you doing?
      input:
        control: Textarea
        placeholder: Kind of work...
        maxLength: 200
    - id: q_lbf_q36
      kind: Question
      title: What are your most important activities or duties?
      input:
        control: Textarea
        placeholder: Activities or duties...
        maxLength: 200
    - id: q_lbf_q36a
      kind: Question
      title: Is your job permanent, or is there some way that it is not permanent?
      input:
        control: Radio
        labels:
          1: Permanent
          2: Not permanent
    - id: q_lbf_q36b
      kind: Question
      title: In what way is your job not permanent?
      precondition:
      - predicate: q_lbf_q36a.outcome == 2
      input:
        control: Radio
        labels:
          1: Seasonal
          2: Temporary, term or contract
          3: Casual job
          4: Work done through a temporary help agency
          5: Other
    - id: q_lbf_q37
      kind: Question
      title: At your place of work, what are the restrictions on smoking?
      input:
        control: Radio
        labels:
          1: Restricted completely
          2: Allowed in designated areas
          3: Restricted only in certain places
          4: Not restricted at all
  - id: b_absence_reason
    title: Reason for Absence
    precondition:
    - predicate: age >= 15
    - predicate: age <= 75
    - predicate: q_lbf_q01.outcome == 2
    - predicate: q_lbf_q02.outcome == 1
    items:
    - id: q_lbf_q41
      kind: Question
      title: What was the main reason you were absent from work last week?
      postcondition:
      - predicate: not (sex == 1 and q_lbf_q41.outcome == 4)
        hint: Maternity leave is only applicable for females.
      - predicate: not (q_lbf_q31.outcome == 1 and q_lbf_q41.outcome in [12, 13])
        hint: Self-employed reasons are not valid for employees.
      - predicate: not (q_lbf_q31.outcome == 2 and q_lbf_q41.outcome in [8, 9, 10, 11])
        hint: Employee reasons are not valid for self-employed.
      - predicate: not (q_lbf_q31.outcome == 3 and q_lbf_q41.outcome in [8, 9, 10, 11, 12])
        hint: These reasons are not valid for unpaid family workers.
      input:
        control: Dropdown
        labels:
          1: Own illness or disability
          2: Caring for own children
          3: Caring for elder relatives
          4: Maternity leave
          5: Other personal or family responsibilities
          6: Vacation
          7: Labour dispute
          8: Temporary layoff due to business conditions
          9: Seasonal layoff
          10: Casual job, no work available
          11: Work schedule
          12: Self-employed, no work available
          13: Seasonal business
          14: School or educational leave
          15: Other
    - id: q_lbf_q41s
      kind: Question
      title: 'INTERVIEWER: Specify.'
      precondition:
      - predicate: q_lbf_q41.outcome == 15
      input:
        control: Textarea
        placeholder: Specify reason...
        maxLength: 200
    - id: q_lbf_q41a
      kind: Question
      title: Was that due to your physical health, to your emotional or mental health, to your use of alcohol or drugs, or
        to another reason?
      precondition:
      - predicate: q_lbf_q41.outcome == 1
      input:
        control: Radio
        labels:
          1: Physical health
          2: Emotional or mental health (including stress)
          3: Use of alcohol or drugs
          4: Another reason
  - id: b_hours_schedule
    title: Hours and Schedule
    precondition:
    - predicate: age >= 15
    - predicate: age <= 75
    - predicate: q_lbf_q01.outcome == 1 or (q_lbf_q01.outcome == 2 and q_lbf_q02.outcome == 1)
    items:
    - id: q_lbf_q42
      kind: Question
      title: About how many hours a week do you usually work at your job or business?
      postcondition:
      - predicate: q_lbf_q42.outcome <= 84
        hint: 'Warning: more than 84 hours per week reported. Please verify.'
      input:
        control: Editbox
        min: 1
        max: 168
        right: hours
    - id: q_lbf_q44
      kind: Question
      title: Which of the following best describes the hours you usually work at your job or business?
      input:
        control: Radio
        labels:
          1: Regular daytime schedule or shift
          2: Regular evening shift
          3: Regular night shift
          4: Rotating shift
          5: Split shift
          6: On call
          7: Irregular schedule
          8: Other
    - id: q_lbf_q44s
      kind: Question
      title: 'INTERVIEWER: Specify.'
      precondition:
      - predicate: q_lbf_q44.outcome == 8
      input:
        control: Textarea
        placeholder: Specify schedule...
        maxLength: 200
    - id: q_lbf_q45
      kind: Question
      title: What is the main reason that you work this schedule?
      precondition:
      - predicate: q_lbf_q44.outcome != 1
      input:
        control: Radio
        labels:
          1: Requirement of job / no choice
          2: Going to school
          3: Caring for own children
          4: Caring for other relatives
          5: To earn more money
          6: Likes to work this schedule
          7: Other
    - id: q_lbf_q45s
      kind: Question
      title: 'INTERVIEWER: Specify.'
      precondition:
      - predicate: q_lbf_q44.outcome != 1
      - predicate: q_lbf_q45.outcome == 7
      input:
        control: Textarea
        placeholder: Specify reason...
        maxLength: 200
    - id: q_lbf_q46
      kind: Question
      title: Do you usually work on weekends at this job or business?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
  - id: b_multiple_jobs
    title: Multiple Jobs Details
    precondition:
    - predicate: age >= 15
    - predicate: age <= 75
    - predicate: q_lbf_q01.outcome == 1 or (q_lbf_q01.outcome == 2 and q_lbf_q02.outcome == 1)
    - predicate: had_multiple_jobs == 1
    items:
    - id: q_lbf_q51
      kind: Question
      title: For how many weeks in a row have you held more than one job?
      input:
        control: Editbox
        min: 1
        max: 52
        right: weeks
    - id: q_lbf_q52
      kind: Question
      title: What is the main reason that you hold more than one job?
      input:
        control: Radio
        labels:
          1: To meet regular household expenses
          2: To pay off debts
          3: To buy something special
          4: To save for the future
          5: To gain experience
          6: To build up a business
          7: Enjoys the work of the second job
          8: Other
    - id: q_lbf_q52s
      kind: Question
      title: 'INTERVIEWER: Specify.'
      precondition:
      - predicate: q_lbf_q52.outcome == 8
      input:
        control: Textarea
        placeholder: Specify reason...
        maxLength: 200
    - id: q_lbf_q53
      kind: Question
      title: About how many hours a week do you usually work at your other job(s)?
      postcondition:
      - predicate: q_lbf_q53.outcome <= 30
        hint: 'Warning: more than 30 hours at other jobs reported. Please verify.'
      input:
        control: Editbox
        min: 1
        max: 167
        right: hours
    - id: q_lbf_q54
      kind: Question
      title: Do you usually work on weekends at your other job(s)?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
  - id: b_job_search
    title: Job Search
    precondition:
    - predicate: age >= 15
    - predicate: age <= 75
    - predicate: q_lbf_q01.outcome == 2
    - predicate: q_lbf_q02.outcome == 0
    items:
    - id: q_lbf_q11
      kind: Question
      title: In the past 4 weeks, did you do anything to find work?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_lbf_q13
      kind: Question
      title: What is the main reason that you are not currently working at a job or business?
      precondition:
      - predicate: q_lbf_q11.outcome == 0
      postcondition:
      - predicate: not (sex == 1 and q_lbf_q13.outcome == 4)
        hint: Pregnancy is only applicable for females.
      input:
        control: Dropdown
        labels:
          1: Own illness or disability
          2: Caring for own children
          3: Caring for elder relatives
          4: Pregnancy
          5: Other personal or family responsibilities
          6: Vacation
          7: School or educational leave
          8: Retired
          9: Believes no work available
          10: Other
    - id: q_lbf_q13s
      kind: Question
      title: 'INTERVIEWER: Specify.'
      precondition:
      - predicate: q_lbf_q11.outcome == 0
      - predicate: q_lbf_q13.outcome == 10
      input:
        control: Textarea
        placeholder: Specify reason...
        maxLength: 200
    - id: q_lbf_q13a
      kind: Question
      title: Is this due to your physical health, to your emotional or mental health, to your use of alcohol or drugs, or
        to another reason?
      precondition:
      - predicate: q_lbf_q11.outcome == 0
      - predicate: q_lbf_q13.outcome == 1
      input:
        control: Radio
        labels:
          1: Physical health
          2: Emotional or mental health (including stress)
          3: Use of alcohol or drugs
          4: Another reason
  - id: b_past_12_months
    title: Past 12 Months Employment
    precondition:
    - predicate: age >= 15
    - predicate: age <= 75
    - predicate: q_lbf_q01.outcome != 1
    items:
    - id: q_lbf_qint2
      kind: Comment
      title: Now some questions about jobs or employment which you have had during the past 12 months.
      precondition:
      - predicate: q_lbf_q01.outcome == 3 or (q_lbf_q01.outcome == 2 and q_lbf_q02.outcome == 0 and q_lbf_q11.outcome == 1)
          or (q_lbf_q01.outcome == 2 and q_lbf_q02.outcome == 0 and q_lbf_q11.outcome == 0 and q_lbf_q13.outcome == 1)
    - id: q_lbf_q21
      kind: Question
      title: Did you work at a job or a business at any time in the past 12 months?
      postcondition:
      - predicate: not (gen_q08 == 2 and q_lbf_q21.outcome == 1)
        hint: Earlier you indicated no work in the past 12 months, but now report working. Please verify.
      - predicate: not (gen_q08 == 1 and q_lbf_q21.outcome == 0)
        hint: Earlier you indicated working in the past 12 months, but now report not working. Please verify.
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_lbf_q22
      kind: Question
      title: During the past 12 months, did you do anything to find work?
      precondition:
      - predicate: q_lbf_q21.outcome == 0
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_lbf_q23
      kind: Question
      title: During that 12 months, did you work at more than one job or business at the same time?
      precondition:
      - predicate: q_lbf_q21.outcome == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
      codeBlock: |
        if q_lbf_q03.outcome == 1 or q_lbf_q23.outcome == 1:
            had_multiple_jobs = 1
  - id: b_weeks_worked
    title: Weeks Worked and Job Search
    precondition:
    - predicate: age >= 15
    - predicate: age <= 75
    - predicate: q_lbf_q01.outcome == 1 or (q_lbf_q01.outcome == 2 and q_lbf_q02.outcome == 1) or q_lbf_q21.outcome == 1
    items:
    - id: q_lbf_q61
      kind: Question
      title: During the past 52 weeks, how many weeks did you do any work at a job or a business?
      input:
        control: Editbox
        min: 1
        max: 52
        right: weeks
      codeBlock: |
        weeks_worked = q_lbf_q61.outcome
    - id: q_lbf_q71a
      kind: Question
      title: That leaves 1 week. During that week, did you look for work?
      precondition:
      - predicate: q_lbf_q61.outcome == 51
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
      codeBlock: |
        if q_lbf_q71a.outcome == 1:
            weeks_looking = 1
        else:
            weeks_looking = 0
    - id: q_lbf_q71
      kind: Question
      title: During the past 52 weeks, how many weeks were you looking for work?
      precondition:
      - predicate: q_lbf_q61.outcome <= 50
      input:
        control: Editbox
        min: 0
        max: 51
        right: weeks
      codeBlock: |
        weeks_looking = q_lbf_q71.outcome
    - id: q_lbf_q72
      kind: Question
      title: That leaves some weeks during which you were neither working nor looking for work. Is that correct?
      precondition:
      - predicate: q_lbf_q61.outcome <= 50
      - predicate: q_lbf_q61.outcome + q_lbf_q71.outcome < 52
      postcondition:
      - predicate: q_lbf_q72.outcome == 1
        hint: The total weeks working and looking for work do not add up to 52. Please go back and correct the values.
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_lbf_q73
      kind: Question
      title: What is the main reason that you were not looking for work?
      precondition:
      - predicate: q_lbf_q61.outcome < 52
      - predicate: q_lbf_q01.outcome == 1 or (q_lbf_q01.outcome == 2 and q_lbf_q02.outcome == 1) or (q_lbf_q01.outcome ==
          2 and q_lbf_q02.outcome == 0 and q_lbf_q11.outcome == 1)
      postcondition:
      - predicate: not (sex == 1 and q_lbf_q73.outcome == 4)
        hint: Pregnancy is only applicable for females.
      input:
        control: Dropdown
        labels:
          1: Own illness or disability
          2: Caring for own children
          3: Caring for elder relatives
          4: Pregnancy
          5: Other personal or family responsibilities
          6: Vacation
          7: Labour dispute
          8: Temporary layoff due to business conditions
          9: Seasonal layoff
          10: Casual job, no work available
          11: Work schedule
          12: School or educational leave
          13: Retired
          14: Believes no work available
          15: Other
    - id: q_lbf_q73s
      kind: Question
      title: 'INTERVIEWER: Specify.'
      precondition:
      - predicate: q_lbf_q61.outcome < 52
      - predicate: q_lbf_q73.outcome == 15
      input:
        control: Textarea
        placeholder: Specify reason...
        maxLength: 200
    - id: q_lbf_q73a
      kind: Question
      title: Was that due to your physical health, to your emotional or mental health, to your use of alcohol or drugs, or
        to another reason?
      precondition:
      - predicate: q_lbf_q61.outcome < 52
      - predicate: q_lbf_q73.outcome == 1
      input:
        control: Radio
        labels:
          1: Physical health
          2: Emotional or mental health (including stress)
          3: Use of alcohol or drugs
          4: Another reason
  - id: b_current_work
    title: Current Work Status
    precondition:
    - predicate: age >= 15
    - predicate: age <= 75
    items:
    - id: q_lf2_r1
      kind: Comment
      title: The next questions concern your activities in the last 7 days.
    - id: q_lf2_q1
      kind: Question
      title: Last week, did you work at a job or a business?
      postcondition:
      - predicate: not (gen_q08 == 2 and q_lf2_q1.outcome == 1)
        hint: Earlier you indicated no work in the past 12 months, but now report working last week. Please verify.
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Permanently unable to work
    - id: q_lf2_q2
      kind: Question
      title: Last week, did you have a job or business from which you were absent?
      precondition:
      - predicate: q_lf2_q1.outcome == 2
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_lf2_q3
      kind: Question
      title: Did you have more than one job or business last week?
      precondition:
      - predicate: q_lf2_q1.outcome == 1 or (q_lf2_q1.outcome == 2 and q_lf2_q2.outcome == 1)
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_lf2_q4
      kind: Question
      title: In the past 4 weeks, did you do anything to find work?
      precondition:
      - predicate: q_lf2_q1.outcome == 2
      - predicate: q_lf2_q2.outcome == 0
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
  - id: b_job_details
    title: Job Details
    precondition:
    - predicate: age >= 15
    - predicate: age <= 75
    - predicate: q_lf2_q1.outcome == 1 or (q_lf2_q1.outcome == 2 and q_lf2_q2.outcome == 1)
    items:
    - id: q_lf2_r5
      kind: Comment
      title: The next questions are about your current job or business.
    - id: q_lf2_q5
      kind: Question
      title: About how many hours a week do you usually work at your job or business?
      postcondition:
      - predicate: q_lf2_q5.outcome <= 84
        hint: 'Warning: more than 84 hours per week reported. Please verify.'
      input:
        control: Editbox
        min: 1
        max: 168
        right: hours
    - id: q_lf2_q6
      kind: Question
      title: At your place of work, what are the restrictions on smoking?
      input:
        control: Radio
        labels:
          1: Restricted completely
          2: Allowed in designated areas
          3: Restricted only in certain places
          4: Not restricted at all
    - id: q_lf2_q7
      kind: Question
      title: About how many hours a week do you usually work at your other job(s)?
      precondition:
      - predicate: q_lf2_q3.outcome == 1
      postcondition:
      - predicate: q_lf2_q7.outcome <= 30
        hint: 'Warning: more than 30 hours at other jobs reported. Please verify.'
      input:
        control: Editbox
        min: 1
        max: 167
        right: hours
  - id: b_respondent_education
    title: Selected Respondent Education
    precondition:
    - predicate: age >= 14
    items:
    - id: q_edu_r01
      kind: Comment
      title: Next, education.
    - id: q_edu_q01
      kind: Question
      title: What is the highest grade of elementary or high school you have ever completed?
      input:
        control: Radio
        labels:
          1: Grade 8 or lower
          2: Grade 9-10
          3: Grade 11-13
    - id: q_edu_q02
      kind: Question
      title: Did you graduate from high school (secondary school)?
      precondition:
      - predicate: q_edu_q01.outcome == 3
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_edu_q03
      kind: Question
      title: Have you received any other education that could be counted towards a degree, certificate or diploma from an
        educational institution?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_edu_q04
      kind: Question
      title: What is the highest degree, certificate or diploma you have obtained?
      precondition:
      - predicate: q_edu_q03.outcome == 1
      input:
        control: Radio
        labels:
          1: No post-secondary degree, certificate or diploma
          2: Trade certificate or diploma
          3: Non-university certificate or diploma (community college, CEGEP, school of nursing, etc.)
          4: University certificate below bachelor's level
          5: Bachelor's degree
          6: University degree or certificate above bachelor's degree
    - id: q_edu_q05
      kind: Question
      title: Are you currently attending a school, college or university?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_edu_q06
      kind: Question
      title: Are you enrolled as a full-time student or a part-time student?
      precondition:
      - predicate: q_edu_q05.outcome == 1
      input:
        control: Radio
        labels:
          1: Full-time
          2: Part-time
  - id: b_other_member_education
    title: Other Household Member Education
    precondition:
    - predicate: has_other_hh_members_14plus == 1
    items:
    - id: q_edu_r07a
      kind: Comment
      title: Now I'd like you to think about the rest of your household.
    - id: q_edu_q07
      kind: Question
      title: What is the highest grade of elementary or high school the other household member ever completed?
      input:
        control: Radio
        labels:
          1: Grade 8 or lower
          2: Grade 9-10
          3: Grade 11-13
    - id: q_edu_q08
      kind: Question
      title: Did he/she graduate from high school (secondary school)?
      precondition:
      - predicate: q_edu_q07.outcome == 3
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_edu_q09
      kind: Question
      title: Has he/she received any other education that could be counted towards a degree, certificate or diploma from an
        educational institution?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_edu_q10
      kind: Question
      title: What is the highest degree, certificate or diploma he/she has obtained?
      precondition:
      - predicate: q_edu_q09.outcome == 1
      input:
        control: Radio
        labels:
          1: No post-secondary degree, certificate or diploma
          2: Trade certificate or diploma
          3: Non-university certificate or diploma (community college, CEGEP, school of nursing, etc.)
          4: University certificate below bachelor's level
          5: Bachelor's degree
          6: University degree or certificate above bachelor's degree
