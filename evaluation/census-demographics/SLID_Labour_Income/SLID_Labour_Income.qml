qmlVersion: '2.7'
questionnaire:
  title: 1994 PRELIMINARY INTERVIEW QUESTIONNAIRE
  blocks:
  - id: b_s1_p1_preamble
    title: Prefilled values
    items:
    - id: age
      kind: Question
      title: '[age] - the respondent''s age, in years (prefill item, not asked)'
      external: true
      input:
        control: Editbox
        min: 0
        max: 120
    - id: current_year
      kind: Question
      title: '[current year] - prefill item, the year of the interview (1994 for the first annual interviews)'
      external: true
      input:
        control: Editbox
        min: 1900
        max: 2100
    - id: EMPPRE_N6
      kind: Question
      title: 'Internal logic: Date in EMPPRE-Q6 is before January [current year] minus 5 and EMPPRE-Q1=permanently unable to work?'
      external: true
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: EMPPRE_N11A
      kind: Question
      title: 'Internal logic: EMPPRE-Q5=no (never worked at a job or business) or dates last worked (EMPPRE-Q6) is before January [reference year]?'
      external: true
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: EMPPRE_N12
      kind: Question
      title: 'Internal logic: [age] is greater than 64 years?'
      external: true
      precondition:
      - predicate: not (EMPPRE_N11A.outcome == 2)
        hint: Asked only when question EMPPRE-N11A is not "No".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: EMPPRE_J1_N2
      kind: Question
      title: 'Internal logic: Date first started working (EMPPRE-J1.Q2) is before date last worked (EMPPRE-Q6)?'
      external: true
      precondition:
      - predicate: not (EMPPRE_N11A.outcome == 2)
        hint: Asked only when question EMPPRE-N11A is not "No".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Otherwise
  - id: b_s1_p1_status
    title: Work status in January
    precondition:
    - predicate: not (age.outcome < 15)
      hint: Asked only of respondents aged 15 or older
    - predicate: not (EMPPRE_N11A.outcome == 2)
      hint: Asked only when question EMPPRE-N11A is not "No".
    - predicate: not (age.outcome > 64)
      hint: Asked only of respondents aged 64 or younger
    items:
    - id: EMPPRE_Q1
      kind: Question
      title: 'DID [respondent] WORK AT A JOB OR BUSINESS AT THE BEGINNING OF JANUARY OF THIS YEAR? Interviewer: Enter a job regardless of the number of hours worked.'
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Permanently unable to work
          4: DK
          5: R
    - id: EMPPRE_Q2
      kind: Question
      title: DID [respondent] HAVE A JOB OR BUSINESS AT WHICH HE/SHE DID NOT WORK AT THE BEGINNING OF JANUARY?
      precondition:
      - predicate: not (EMPPRE_Q1.outcome == 1)
        hint: Asked only when question EMPPRE-Q1 is not "Yes".
      - predicate: not (EMPPRE_Q1.outcome == 3)
        hint: Asked only when question EMPPRE-Q1 is not "Permanently unable to work".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: DK
          4: R
    - id: EMPPRE_Q3
      kind: Question
      title: WHY WAS [respondent] ABSENT FROM WORK AT THE BEGINNING OF JANUARY?
      precondition:
      - predicate: not (EMPPRE_Q1.outcome == 1)
        hint: Asked only when question EMPPRE-Q1 is not "Yes".
      - predicate: not (EMPPRE_Q1.outcome == 3)
        hint: Asked only when question EMPPRE-Q1 is not "Permanently unable to work".
      - predicate: not (EMPPRE_Q2.outcome in [2, 3, 4])
        hint: Asked only when question EMPPRE-Q2 is none of "No", "DK", "R".
      input:
        control: Dropdown
        labels:
          1: Own illness or disability
          2: Pregnancy
          3: Caring for own children
          4: Caring for elder relatives
          5: Other personal or family responsibilities
          6: School or educational leave
          7: Labour dispute
          8: Temporary layoff due to seasonal conditions
          9: Temporary layoff - non seasonal
          10: Unpaid or partially paid vacation
          11: Other (Specify)
    - id: EMPPRE_Q4
      kind: Question
      title: DID [respondent] RECEIVE ANY PAY FROM HIS/HER EMPLOYER FOR THIS ABSENCE?
      precondition:
      - predicate: not (EMPPRE_Q1.outcome == 1)
        hint: Asked only when question EMPPRE-Q1 is not "Yes".
      - predicate: not (EMPPRE_Q1.outcome == 3)
        hint: Asked only when question EMPPRE-Q1 is not "Permanently unable to work".
      - predicate: not (EMPPRE_Q2.outcome in [2, 3, 4])
        hint: Asked only when question EMPPRE-Q2 is none of "No", "DK", "R".
      - predicate: not (EMPPRE_Q3.outcome == 6)
        hint: Asked only when question EMPPRE-Q3 is not "School or educational leave".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: DK
          4: R
    - id: EMPPRE_Q5
      kind: Question
      title: DID [respondent] EVER WORK AT A JOB OR BUSINESS?
      precondition:
      - predicate: not (EMPPRE_Q1.outcome == 1)
        hint: Asked only when question EMPPRE-Q1 is not "Yes".
      - predicate: not (EMPPRE_Q3.outcome in [8, 9])
        hint: Asked only when question EMPPRE-Q3 is none of "Temporary layoff due to seasonal conditions", "Temporary layoff - non seasonal".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: DK
          4: R
    - id: EMPPRE_Q6
      kind: Question
      title: 'WHEN DID [respondent] LAST WORK AT A JOB OR BUSINESS? Hard Range: Maximum: current year; Minimum: current year-(age-10)'
      precondition:
      - predicate: not (EMPPRE_Q1.outcome == 1)
        hint: Asked only when question EMPPRE-Q1 is not "Yes".
      - predicate: not (EMPPRE_Q3.outcome in [8, 9])
        hint: Asked only when question EMPPRE-Q3 is none of "Temporary layoff due to seasonal conditions", "Temporary layoff - non seasonal".
      - predicate: not (EMPPRE_Q5.outcome == 2 and EMPPRE_Q1.outcome != 3)
        hint: Not asked when question EMPPRE-Q5 is "No" and EMPPRE-Q1 is not "Permanently unable to work".
      postcondition:
      - predicate: EMPPRE_Q6.outcome <= current_year.outcome and EMPPRE_Q6.outcome >= current_year.outcome - age.outcome + 10
        hint: La date du dernier emploi (EMPPRE-Q6) doit se situer entre l'année courante moins (âge - 10) et l'année courante; corrigez EMPPRE-Q6 en tenant compte de l'âge.
      input:
        control: Editbox
        min: 1900
        max: 2100
        right: (year)
    - id: EMPPRE_Q7
      kind: Question
      title: WHAT WAS [respondent]'S MAIN REASON FOR LEAVING THIS JOB?
      precondition:
      - predicate: not (EMPPRE_Q1.outcome == 1)
        hint: Asked only when question EMPPRE-Q1 is not "Yes".
      - predicate: not (EMPPRE_Q3.outcome in [8, 9])
        hint: Asked only when question EMPPRE-Q3 is none of "Temporary layoff due to seasonal conditions", "Temporary layoff - non seasonal".
      - predicate: not (EMPPRE_Q5.outcome == 2 and EMPPRE_Q1.outcome != 3)
        hint: Not asked when question EMPPRE-Q5 is "No" and EMPPRE-Q1 is not "Permanently unable to work".
      input:
        control: Dropdown
        labels:
          1: Own illness, disability
          2: Caring for own children
          3: Caring for elder relatives
          4: Other personal or family responsibilities
          5: Going to school
          6: Quit job for no specific reason
          7: Lost job or laid off job - Paid workers only
          8: Changed residence
          9: Dissatisfied with job
          10: Retired
          11: Other - Specify
    - id: EMPPRE_Q8
      kind: Question
      title: DID [respondent] LOOK FOR WORK IN JANUARY OF THIS YEAR?
      precondition:
      - predicate: not (EMPPRE_Q1.outcome == 1)
        hint: Asked only when question EMPPRE-Q1 is not "Yes".
      - predicate: not (not (EMPPRE_Q3.outcome in [8, 9]))
        hint: Asked only when question EMPPRE-Q3 is a temporary layoff
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: DK
          4: R
    - id: EMPPRE_Q9
      kind: Question
      title: WHAT DID [respondent] DO TO FIND WORK?
      precondition:
      - predicate: not (EMPPRE_Q1.outcome == 1)
        hint: Asked only when question EMPPRE-Q1 is not "Yes".
      - predicate: not (not (EMPPRE_Q3.outcome in [8, 9]))
        hint: Asked only when question EMPPRE-Q3 is a temporary layoff
      - predicate: not (EMPPRE_Q8.outcome in [2, 3, 4])
        hint: Asked only when question EMPPRE-Q8 is none of "No", "DK", "R".
      input:
        control: Checkbox
        labels:
          1: Contacted employer directly
          2: Friend or relative
          4: Placed or answered newspaper ad
          8: Employment agency
          16: Referral from another employer
          32: Other - specify
    - id: EMPPRE_Q10
      kind: Question
      title: DID [respondent] LOOK FOR WORK AT ANY TIME IN THE 6 MONTHS BEFORE THAT?
      precondition:
      - predicate: not (EMPPRE_Q1.outcome == 1)
        hint: Asked only when question EMPPRE-Q1 is not "Yes".
      - predicate: not (not (EMPPRE_Q3.outcome in [8, 9]))
        hint: Asked only when question EMPPRE-Q3 is a temporary layoff
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: DK
          4: R
    - id: EMPPRE_Q11
      kind: Question
      title: 'WHAT WERE THE REASONS [respondent] DID NOT LOOK FOR WORK IN JANUARY OF THIS YEAR? Interviewer: If only answered Own illness or Personal responsibilities, probe for other reasons.'
      precondition:
      - predicate: not (EMPPRE_Q1.outcome == 1)
        hint: Asked only when question EMPPRE-Q1 is not "Yes".
      - predicate: not (not (EMPPRE_Q3.outcome in [8, 9]))
        hint: Asked only when question EMPPRE-Q3 is a temporary layoff
      input:
        control: Checkbox
        labels:
          1: Own illness, disability
          2: Caring for own children
          4: Caring for elder relatives
          8: Other personal or family responsibilities
          16: Going to school
          32: No longer interested in finding work
          64: Waiting for recall (to former job)
          128: Has found new job
          256: Waiting for replies from employers
          512: Believes no work available (in area, or suited to skills)
          1024: No reason given
          2048: Other - Specify
  - id: b_s1_p1_school
    title: School attendance in January
    precondition:
    - predicate: not (age.outcome < 15)
      hint: Asked only of respondents aged 15 or older
    - predicate: not (EMPPRE_Q1.outcome == 1)
      hint: Asked only when question EMPPRE-Q1 is not "Yes".
    - predicate: not (not (EMPPRE_Q3.outcome in [8, 9]))
      hint: Asked only when question EMPPRE-Q3 is a temporary layoff
    - predicate: not (EMPPRE_N11A.outcome == 2)
      hint: Asked only when question EMPPRE-N11A is not "No".
    - predicate: not (age.outcome > 64)
      hint: Asked only of respondents aged 64 or younger
    items:
    - id: EMPPRE_Q12
      kind: Question
      title: IN JANUARY OF THIS YEAR, WAS [respondent] ATTENDING A SCHOOL, COLLEGE OR UNIVERSITY?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: DK
          4: R
    - id: EMPPRE_Q13
      kind: Question
      title: WAS [respondent] ENROLLED AS A FULL-TIME OR PART-TIME STUDENT?
      precondition:
      - predicate: not (EMPPRE_Q12.outcome in [2, 3, 4])
        hint: Asked only when question EMPPRE-Q12 is none of "No", "DK", "R".
      input:
        control: Radio
        labels:
          1: Full-time student
          2: Part-time student
          3: Some of each
  - id: b_s1_p1_jobs
    title: Main job and other job
    precondition:
    - predicate: not (age.outcome < 15)
      hint: Asked only of respondents aged 15 or older
    - predicate: not (age.outcome > 64)
      hint: Asked only of respondents aged 64 or younger
    - predicate: not (EMPPRE_Q12.outcome in [2, 3, 4])
      hint: Asked only when question EMPPRE-Q12 is none of "No", "DK", "R".
    - predicate: not (EMPPRE_Q13.outcome in [1, 2, 3])
      hint: Asked only when question EMPPRE-Q13 is none of "Full-time student", "Part-time student", "Some of each".
    items:
    - id: EMPPRE_J1_Q1
      kind: Question
      title: I WOULD LIKE TO ASK A FEW QUESTIONS ABOUT [respondent]'S MAIN JOB OR BUSINESS IN EARLY JANUARY. FOR WHOM DID [respondent] WORK? (name of business, government department, or agency, or person)
      precondition:
      - predicate: not (EMPPRE_N11A.outcome == 2)
        hint: Asked only when question EMPPRE-N11A is not "No".
      input:
        control: Textarea
    - id: EMPPRE_J1_Q1A
      kind: Question
      title: I WOULD LIKE TO ASK A FEW QUESTIONS ABOUT THE LAST JOB OR BUSINESS HELD BY [respondent] IN [reference year]. FOR WHOM DID [respondent] WORK? (name of business, government department, or agency, or person)
      precondition:
      - predicate: not (EMPPRE_Q1.outcome == 1)
        hint: Asked only when question EMPPRE-Q1 is not "Yes".
      input:
        control: Textarea
    - id: EMPPRE_J1_Q2
      kind: Question
      title: 'WHEN WAS THE FIRST TIME [respondent] STARTED WORKING FOR THIS EMPLOYER? Hard range: Maximum: [current year]; Minimum: [current year]-[age]-10'
      postcondition:
      - predicate: EMPPRE_J1_Q2.outcome <= current_year.outcome and EMPPRE_J1_Q2.outcome >= current_year.outcome - age.outcome - 10
        hint: La date de début chez cet employeur (EMPPRE-J1.Q2) doit se situer entre l'année courante - âge - 10 et l'année courante; corrigez EMPPRE-J1.Q2.
      - predicate: EMPPRE_J1_Q2.outcome <= EMPPRE_Q6.outcome
        hint: The date first started working for this employer (EMPPRE-J1.Q2) cannot be after the date last worked (EMPPRE-Q6); go back and correct EMPPRE-Q6 and/or EMPPRE-J1.Q2.
        invented: true
      input:
        control: Editbox
        min: 1900
        max: 2100
        right: (year)
    - id: EMPPRE_J1_Q2A
      kind: Question
      title: 'Interviewer: Date first started working for this employer (EMPPRE-J1.Q2) is after the date last worked (EMPPRE-Q6). Go back to EMPPRE-Q6 and/or EMPPRE-J1.Q2 to correct inconsistencies, or press <Enter> to continue.'
      precondition:
      - predicate: not (EMPPRE_J1_N2.outcome in [1, 3])
        hint: Asked only when question EMPPRE-J1.N2 is none of "Yes", "Otherwise".
      input:
        control: Textarea
    - id: EMPPRE_J1_Q3
      kind: Question
      title: WHAT KIND OF BUSINESS, INDUSTRY OR SERVICE WAS THIS? (e.g., federal government, canning industry, forestry service)
      input:
        control: Textarea
    - id: EMPPRE_J1_Q4
      kind: Question
      title: WHAT KIND OF WORK WAS [respondent] DOING? (e.g., office clerk, factory worker, forestry technician)
      input:
        control: Textarea
    - id: EMPPRE_J1_Q5
      kind: Question
      title: WHAT WERE [respondent]'S MOST IMPORTANT ACTIVITIES OR DUTIES? (e.g., filing documents, drying vegetables, forest examiner)
      input:
        control: Textarea
    - id: EMPPRE_J1_Q6
      kind: Question
      title: IN THIS JOB, WAS [respondent] A PAID WORKER, SELF-EMPLOYED OR AN UNPAID FAMILY WORKER?
      input:
        control: Dropdown
        labels:
          1: Paid worker
          2: Unpaid family worker
          3: Self-employed Incorporated - With paid help
          4: Self-employed Incorporated - No paid help
          5: Self-employed Unincorporated - With paid help
          6: Self-employed Unincorporated - No paid help
          7: DK
          8: R
    - id: EMPPRE_J1_Q7A
      kind: Question
      title: IN WHICH MONTHS OF [reference year] DID [respondent] WORK AT THIS JOB?
      input:
        control: Radio
        labels:
          1: All months
          2: Started in [current year]
          3: Specify months
          4: Last worked before [reference year]
          5: DK
          6: R
    - id: EMPPRE_J1_Q7B
      kind: Question
      title: 'Interviewer: Specify months [respondent] worked in [reference year]'
      precondition:
      - predicate: not (EMPPRE_J1_Q7A.outcome in [1, 5, 6])
        hint: Asked only when question EMPPRE-J1.Q7A is none of "All months", "DK", "R".
      input:
        control: Checkbox
        labels:
          1: January
          2: February
          4: March
          8: April
          16: May
          32: June
          64: July
          128: August
          256: September
          512: October
          1024: November
          2048: December
    - id: EMPPRE_J1_Q8
      kind: Question
      title: AT THIS JOB, DID [respondent] USUALLY WORK EVERY WEEK OF THE MONTH?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: DK
          4: R
    - id: EMPPRE_J1_Q9
      kind: Question
      title: 'HOW MANY WEEKS DID [respondent] USUALLY WORK EACH MONTH? Hard range: Maximum: 3; Minimum: 1'
      precondition:
      - predicate: not (EMPPRE_J1_Q8.outcome in [1, 3, 4])
        hint: Asked only when question EMPPRE-J1.Q8 is none of "Yes", "DK", "R".
      input:
        control: Editbox
        min: 1
        max: 3
        right: weeks
    - id: EMPPRE_J1_Q10
      kind: Question
      title: 'HOW MANY HOURS PER WEEK DID [respondent] USUALLY GET PAID? Hard range: Maximum: 99.9; Minimum: 1.0'
      input:
        control: Editbox
        min: 10
        max: 999
        right: tenths of an hour (e.g. 375 = 37.5 hours)
    - id: EMPPRE_J1_Q11A
      kind: Question
      title: AT THIS JOB, WHAT WAS [respondent]'S WAGE OR SALARY BEFORE TAXES AND DEDUCTIONS? (As of January of this year or when they last worked for this employer in [reference year]).
      input:
        control: Editbox
        min: 1
        max: 99999999
        right: cents (e.g. 1250 = 12.50)
    - id: EMPPRE_J1_Q11B
      kind: Question
      title: 'Interviewer: Select the appropriate category for reported wage or salary'
      input:
        control: Radio
        labels:
          1: Hourly
          2: Weekly
          3: Every two weeks/twice a month
          4: Monthly
          5: Yearly
          6: Other (specify)
    - id: EMPPRE_J1_Q12
      kind: Question
      title: WHAT WERE [respondent]'S TOTAL EARNINGS FROM THIS JOB IN [reference year]?
      precondition:
      - predicate: not (EMPPRE_J1_Q11B.outcome != 6)
        hint: Asked only when question EMPPRE-J1.Q11B is "Other (specify)".
      input:
        control: Editbox
        min: 1
        max: 99999999
        right: cents (e.g. 1250 = 12.50)
    - id: EMPPRE_J1_Q13
      kind: Question
      title: DID [respondent] RECEIVE ANY COMMISSIONS, TIPS, BONUSES OR PAID OVERTIME FROM THIS JOB IN [reference year]?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: DK
          4: R
    - id: EMPPRE_J1_Q14
      kind: Question
      title: WERE THESE COMMISSIONS, TIPS, BONUSES OR PAID OVERTIME INCLUDED IN THE AMOUNT JUST REPORTED?
      precondition:
      - predicate: not (EMPPRE_J1_Q13.outcome in [2, 3, 4])
        hint: Asked only when question EMPPRE-J1.Q13 is none of "No", "DK", "R".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: DK
          4: R
    - id: EMPPRE_J1_Q15
      kind: Question
      title: WHAT WERE [respondent]'S TOTAL EARNINGS IN [reference year] FROM THESE COMMISSIONS, TIPS, BONUSES, OR PAID OVERTIME?
      precondition:
      - predicate: not (EMPPRE_J1_Q13.outcome in [2, 3, 4])
        hint: Asked only when question EMPPRE-J1.Q13 is none of "No", "DK", "R".
      - predicate: not (EMPPRE_J1_Q14.outcome in [1, 3, 4])
        hint: Asked only when question EMPPRE-J1.Q14 is none of "Yes", "DK", "R".
      input:
        control: Editbox
        min: 1
        max: 99999999
        right: cents (e.g. 1250 = 12.50)
    - id: EMPPRE_J2_Q1
      kind: Question
      title: DID [respondent] HAVE MORE THAN ONE JOB OR BUSINESS IN JANUARY OF THIS YEAR?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: DK
          4: R
    - id: EMPPRE_J2_Q2
      kind: Question
      title: I WOULD LIKE TO ASK A FEW QUESTIONS ABOUT [respondent]'S OTHER JOB OR BUSINESS IN JANUARY OF THIS YEAR. FOR WHOM DID [respondent] WORK? (name of business, government department, or agency, or person)
      input:
        control: Textarea
    - id: EMPPRE_J2_Q3
      kind: Question
      title: 'WHEN DID [respondent] FIRST START WORKING FOR THIS EMPLOYER? Hard range: Maximum: [current year]; Minimum: [current year]-[age]-10'
      postcondition:
      - predicate: EMPPRE_J2_Q3.outcome <= current_year.outcome and EMPPRE_J2_Q3.outcome >= current_year.outcome - age.outcome - 10
        hint: La date de début chez cet employeur (EMPPRE-J2.Q3) doit se situer entre l'année courante - âge - 10 et l'année courante; corrigez EMPPRE-J2.Q3.
      input:
        control: Editbox
        min: 1900
        max: 2100
        right: (year)
    - id: EMPPRE_J2_Q4
      kind: Question
      title: WHAT KIND OF BUSINESS, INDUSTRY OR SERVICE WAS THIS? (e.g., federal government, canning industry, forestry services)
      input:
        control: Textarea
    - id: EMPPRE_J2_Q5
      kind: Question
      title: WHAT KIND OF WORK WAS [respondent] DOING? (e.g., office clerk, factory worker, forestry technician)
      input:
        control: Textarea
    - id: EMPPRE_J2_Q6
      kind: Question
      title: WHAT WERE [respondent]'S MOST IMPORTANT ACTIVITIES OR DUTIES? (e.g., filing documents, drying vegetables, forest examiner)
      input:
        control: Textarea
    - id: EMPPRE_J2_Q7
      kind: Question
      title: IN THIS JOB, WAS [respondent] A PAID WORKER, SELF-EMPLOYED OR AN UNPAID FAMILY WORKER?
      input:
        control: Dropdown
        labels:
          1: Paid worker
          2: Unpaid family worker
          3: Self-employed Incorporated - With paid help
          4: Self-employed Incorporated - No paid help
          5: Self-employed Unincorporated - With paid help
          6: Self-employed Unincorporated - No paid help
          7: DK
          8: R
    - id: EMPPRE_J2_Q8A
      kind: Question
      title: IN WHICH MONTHS OF [reference year] DID [respondent] WORK AT THIS JOB?
      input:
        control: Radio
        labels:
          1: All months
          2: Started in [current year]
          3: Specify months
          4: Last worked before [reference year]
          5: DK
          6: R
    - id: EMPPRE_J2_Q8B
      kind: Question
      title: 'Interviewer: Specify months [respondent] worked in [reference year]?'
      precondition:
      - predicate: not (EMPPRE_J2_Q8A.outcome in [1, 5, 6])
        hint: Asked only when question EMPPRE-J2.Q8A is none of "All months", "DK", "R".
      input:
        control: Checkbox
        labels:
          1: January
          2: February
          4: March
          8: April
          16: May
          32: June
          64: July
          128: August
          256: September
          512: October
          1024: November
          2048: December
    - id: EMPPRE_J2_Q9
      kind: Question
      title: AT THIS JOB, DID [respondent] USUALLY WORK EVERY WEEK OF THE MONTH?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: DK
          4: R
    - id: EMPPRE_J2_Q10
      kind: Question
      title: 'HOW MANY WEEKS DID [respondent] USUALLY WORK EACH MONTH? Hard range: Maximum: 3; Minimum: 1'
      precondition:
      - predicate: not (EMPPRE_J2_Q9.outcome in [1, 3, 4])
        hint: Asked only when question EMPPRE-J2.Q9 is none of "Yes", "DK", "R".
      input:
        control: Editbox
        min: 1
        max: 3
        right: weeks
    - id: EMPPRE_J2_Q11
      kind: Question
      title: 'HOW MANY HOURS PER WEEK DID [respondent] USUALLY GET PAID? Hard range: Maximum: 99.9; Minimum: 1.0'
      input:
        control: Editbox
        min: 10
        max: 999
        right: tenths of an hour (e.g. 375 = 37.5 hours)
    - id: EMPPRE_J2_Q12A
      kind: Question
      title: AT THIS JOB, WHAT WAS [respondent]'S WAGE OR SALARY BEFORE TAXES AND DEDUCTIONS?
      input:
        control: Editbox
        min: 1
        max: 99999999
        right: cents (e.g. 1250 = 12.50)
    - id: EMPPRE_J2_Q12B
      kind: Question
      title: 'Interviewer: Select the appropriate category for reported wage or salary.'
      input:
        control: Radio
        labels:
          1: Hourly
          2: Weekly
          3: Every two weeks/twice a month
          4: Monthly
          5: Yearly
          6: Other (specify)
    - id: EMPPRE_J2_Q13
      kind: Question
      title: WHAT WERE [respondent]'S TOTAL EARNINGS FROM THIS JOB IN [reference year]?
      precondition:
      - predicate: not (EMPPRE_J2_Q12B.outcome != 6)
        hint: Asked only when question EMPPRE-J2.Q12B is "Other (specify)".
      input:
        control: Editbox
        min: 1
        max: 99999999
        right: cents (e.g. 1250 = 12.50)
  - id: b_s1_p2_commissions
    title: Commissions, tips, bonuses and paid overtime
    precondition:
    - predicate: not (age.outcome < 15)
      hint: Asked only of respondents aged 15 or over
    - predicate: not (age.outcome > 64)
      hint: Asked only of respondents aged 64 or under
    - predicate: not (EMPPRE_Q12.outcome in [2, 3, 4])
      hint: Asked only when question EMPPRE-Q12 is none of "No", "DK", "R".
    - predicate: not (EMPPRE_Q13.outcome in [1, 2, 3])
      hint: Asked only when question EMPPRE-Q13 is none of "Full-time student", "Part-time student", "Some of each".
    items:
    - id: EMPPRE_J2_Q14
      kind: Question
      title: DID [respondent] RECEIVE ANY COMMISSIONS, TIPS, BONUSES OR PAID OVERTIME FROM THIS JOB IN [reference year]?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: DK
          4: R
    - id: EMPPRE_J2_Q15
      kind: Question
      title: WERE THESE COMMISSIONS, TIPS, BONUSES OR PAID OVERTIME INCLUDED IN THE AMOUNT JUST REPORTED?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: DK
          4: R
    - id: EMPPRE_J2_Q16
      kind: Question
      title: WHAT WERE [respondent]'S TOTAL EARNINGS IN [reference year] FROM THESE COMMISSIONS, TIPS, BONUSES, OR PAID OVERTIME?
      input:
        control: Editbox
        min: 1
        max: 99999999
        left: 'Amount in cents (0.01 to 999,999.99 dollars):'
  - id: b_s2_preamble
    title: EXPRE external inputs
    items:
    - id: EXPRE_N1
      kind: Question
      title: 'Internal logic: [age] is greater than 69 years?'
      external: true
      precondition:
      - predicate: not (age.outcome < 15)
      - predicate: not (EMPPRE_Q12.outcome in [2, 3, 4])
        hint: Asked only when question EMPPRE-Q12 is none of "No", "DK", "R".
      - predicate: not (EMPPRE_Q13.outcome in [1, 2, 3])
        hint: Asked only when question EMPPRE-Q13 is none of "Full-time student", "Part-time student", "Some of each".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
  - id: b_s2_fulltime_start
    title: Start of full-time work
    items:
    - id: EXPRE_Q1A
      kind: Question
      title: THE NEXT FEW QUESTIONS ARE ABOUT [respondent]'S WORK EXPERIENCE, THINKING BACK TO WHEN HE/SHE FIRST STARTED WORKING AT A JOB OR BUSINESS. DID [respondent] EVER WORK FULL-TIME? (Exclude summer jobs while in school)
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: No, never worked full-time
          3: No, only worked full-time at summer jobs while in school
          4: DK/R
    - id: EXPRE_Q1B
      kind: Question
      title: 'HOW MANY YEARS AGO DID [respondent] FIRST START WORKING FULL-TIME? (Exclude summer jobs while in school) Interviewer: Enter 00 if less than one year. Hard range: Maximum: [age]-10; Minimum: 0'
      postcondition:
      - predicate: EXPRE_Q1B.outcome <= age.outcome - 10
        hint: Years since first full-time work (EXPRE-Q1B) cannot exceed the age (age) minus 10.
      input:
        control: Editbox
        min: 0
        max: 99
    - id: EXPRE_Q2A
      kind: Question
      title: IN THOSE [response given in EXPRE-Q1B] YEARS, WERE THERE ANY YEARS WHEN [respondent] DID NOT WORK AT A JOB OR BUSINESS?
      precondition:
      - predicate: not (EXPRE_Q1B.outcome == 1)
        hint: Asked only when question EXPRE-Q1B is not 1.
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: DK
          4: R
    - id: EXPRE_Q2B
      kind: Question
      title: 'HOW MANY YEARS DID [respondent] NOT WORK AT A JOB OR BUSINESS? Hard range: Maximum: [response given in EXPRE-Q1B]; Minimum: 1'
      precondition:
      - predicate: not (EXPRE_Q1B.outcome == 1)
        hint: Asked only when question EXPRE-Q1B is not 1.
      - predicate: not (EXPRE_Q2A.outcome in [2, 3, 4])
        hint: Asked only when question EXPRE-Q2A is none of "No", "DK", "R".
      postcondition:
      - predicate: EXPRE_Q2B.outcome <= EXPRE_Q1B.outcome
        hint: Years not worked (EXPRE-Q2B) cannot exceed the years since first full-time work (EXPRE-Q1B).
      input:
        control: Editbox
        min: 1
        max: 99
    - id: EXPRE_Q3
      kind: Question
      title: IN THOSE [response given in EXPRE-Q1B] YEARS, DID [respondent] WORK AT LEAST 6 MONTHS EACH AND EVERY YEAR?
      precondition:
      - predicate: not (EXPRE_Q2B.outcome is not None and EXPRE_Q2B.outcome >= 1)
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: DK
          4: R
  - id: b_s2_years_split
    title: Years worked full-time, part-time, or both
    precondition:
    - predicate: not (EXPRE_Q2B.outcome is not None and EXPRE_Q2B.outcome >= 1)
    - predicate: not (EXPRE_Q3.outcome == 2)
      hint: Asked only when question EXPRE-Q3 is not "No".
    items:
    - id: EXPRE_Q4A
      kind: Question
      title: 'HOW MANY YEARS DID HE/SHE WORK ONLY FULL-TIME? (by full-time I mean 30 or more hours per week) Interviewer: If none enter 00'
      postcondition:
      - predicate: EXPRE_Q4A.outcome <= EXPRE_Q1B.outcome
        hint: Years worked only full-time (EXPRE-Q4A) cannot exceed the years since first full-time work (EXPRE-Q1B).
      input:
        control: Editbox
        min: 0
        max: 99
    - id: EXPRE_Q4B
      kind: Question
      title: 'HOW MANY YEARS DID HE/SHE WORK ONLY PART-TIME? Interviewer: If none enter 00'
      postcondition:
      - predicate: EXPRE_Q4B.outcome <= EXPRE_Q1B.outcome
        hint: Years worked only part-time (EXPRE-Q4B) cannot exceed the years since first full-time work (EXPRE-Q1B).
      input:
        control: Editbox
        min: 0
        max: 99
    - id: EXPRE_Q4C
      kind: Question
      title: 'HOW MANY YEARS DID HE/SHE ONLY WORK SOME OF EACH (full-time and part-time) Interviewer: If none enter 00'
      postcondition:
      - predicate: EXPRE_Q4C.outcome <= EXPRE_Q1B.outcome
        hint: Years worked some of each (EXPRE-Q4C) cannot exceed the years since first full-time work (EXPRE-Q1B).
      - predicate: EXPRE_Q4A.outcome + EXPRE_Q4B.outcome + EXPRE_Q4C.outcome == EXPRE_Q1B.outcome
        hint: The years in EXPRE-Q4A, EXPRE-Q4B and EXPRE-Q4C should add up to the years in EXPRE-Q1B; correct them or confirm.
        invented: true
      input:
        control: Editbox
        min: 0
        max: 99
    - id: EXPRE_Q4D
      kind: Question
      title: 'Interviewer: [respondent] has worked full-time for [answer in EXPRE-Q4A] years, part-time for [answer in EXPRE-Q4B] years, and some of each for [answer in EXPRE-Q4C] years. Conflict with when started working full-time [answer in EXPRE-Q1B] years ago. If incorrect go back to previous questions and make necessary changes. Otherwise press <Enter> to continue.'
      input:
        control: Textarea
  - id: b_s2_six_months
    title: Years worked at least 6 months
    items:
    - id: EXPRE_Q5A
      kind: Question
      title: 'SINCE [respondent] FIRST STARTED WORKING, HOW MANY YEARS DID HE/SHE WORK AT LEAST 6 MONTHS OF THE YEAR? Interviewer: If none enter 00. Hard range: Maximum: [response given in EXPRE-Q1B] minus [response given in EXPRE-Q2B] (if 2B not answered use Q1B as maximum). Minimum: 0'
      postcondition:
      - predicate: EXPRE_Q5A.outcome <= EXPRE_Q1B.outcome - EXPRE_Q2B.outcome
        hint: Years worked at least 6 months (EXPRE-Q5A) cannot exceed the years since first full-time work (EXPRE-Q1B) minus the years not worked (EXPRE-Q2B).
      input:
        control: Editbox
        min: 0
        max: 99
    - id: EXPRE_Q6A
      kind: Question
      title: 'IN THOSE [response given in EXPRE-Q5A] YEARS, HOW MANY DID HE/SHE WORK ONLY FULL-TIME ? (by full-time I mean 30 or more hours per week) Interviewer: If none enter 00'
      postcondition:
      - predicate: EXPRE_Q6A.outcome <= EXPRE_Q5A.outcome
        hint: Years worked only full-time (EXPRE-Q6A) cannot exceed the years worked at least 6 months (EXPRE-Q5A).
      input:
        control: Editbox
        min: 0
        max: 99
    - id: EXPRE_Q6B
      kind: Question
      title: 'IN THOSE [response given in EXPRE-Q5A] YEARS, HOW MANY DID HE/SHE WORK ONLY PART-TIME? Interviewer: If none enter 00'
      postcondition:
      - predicate: EXPRE_Q6B.outcome <= EXPRE_Q5A.outcome
        hint: Years worked only part-time (EXPRE-Q6B) cannot exceed the years worked at least 6 months (EXPRE-Q5A).
      - predicate: EXPRE_Q6A.outcome + EXPRE_Q6B.outcome <= EXPRE_Q5A.outcome
        hint: Full-time years (EXPRE-Q6A) plus part-time years (EXPRE-Q6B) cannot exceed the years worked at least 6 months (EXPRE-Q5A).
        invented: true
      input:
        control: Editbox
        min: 0
        max: 99
  - id: b_s3_preamble
    title: External inputs
    items:
    - id: MARITAL_STATUS
      kind: Question
      title: Marital status reported earlier in the interview (DEMPRE-N1 to N1F read it)
      external: true
      input:
        control: Radio
        labels:
          1: Married
          2: Common-law
          3: Separated
          4: Divorced
          5: Widowed
          6: Single (never married)
          7: DK/R
    - id: AGE_2
      kind: Question
      title: '[age] of the respondent, from the date of birth reported earlier in the interview'
      external: true
      input:
        control: Editbox
        min: 0
        max: 120
    - id: SEX
      kind: Question
      title: Sex of the respondent, reported earlier in the interview (read by DEMPRE-N11A)
      external: true
      input:
        control: Radio
        labels:
          1: Male
          2: Female
    - id: CURRENT_YEAR_2
      kind: Question
      title: '[current year] used by the hard ranges (system date)'
      external: true
      input:
        control: Editbox
        min: 1900
        max: 2100
  - id: b_s3_dempre_n11a
    title: Derived female 18+ flag
    items:
    - id: DEMPRE_N11A
      kind: Question
      title: 'DEMPRE-N11A Internal logic: Respondent is female 18 years of age and over? (derived from SEX and AGE)'
      external: true
      precondition:
      - predicate: not (MARITAL_STATUS.outcome == 1)
        hint: Asked only when question MARITAL_STATUS is not "Married".
      - predicate: not (MARITAL_STATUS.outcome == 2)
        hint: Asked only when question MARITAL_STATUS is not "Common-law".
      - predicate: not (MARITAL_STATUS.outcome == 3)
        hint: Asked only when question MARITAL_STATUS is not "Separated".
      - predicate: not (MARITAL_STATUS.outcome == 4)
        hint: Asked only when question MARITAL_STATUS is not "Divorced".
      - predicate: not (MARITAL_STATUS.outcome == 5)
        hint: Asked only when question MARITAL_STATUS is not "Widowed".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
  - id: b_s3_inpath_q12
    title: Derived INPATH-Q12 flag
    items:
    - id: INPATH_Q12
      kind: Question
      title: 'INPATH-Q12 Internal logic: DEMPRE-Q11=yes and DEMPRE-Q14=no and DEMPRE-Q12 = 0? (node id printed as INPATH-Q12, reached by ''Yes Go to INPATH-Q12'' at DEMPRE-Q14)'
      external: true
      precondition:
      - predicate: not (MARITAL_STATUS.outcome == 1)
        hint: Asked only when question MARITAL_STATUS is not "Married".
      - predicate: not (MARITAL_STATUS.outcome == 2)
        hint: Asked only when question MARITAL_STATUS is not "Common-law".
      - predicate: not (MARITAL_STATUS.outcome == 3)
        hint: Asked only when question MARITAL_STATUS is not "Separated".
      - predicate: not (MARITAL_STATUS.outcome == 4)
        hint: Asked only when question MARITAL_STATUS is not "Divorced".
      - predicate: not (MARITAL_STATUS.outcome == 5)
        hint: Asked only when question MARITAL_STATUS is not "Widowed".
      - predicate: not (DEMPRE_N11A.outcome == 1)
        hint: Asked only when question DEMPRE-N11A is not "Yes".
      - predicate: not (DEMPRE_N11A.outcome == 2)
        hint: Asked only when question DEMPRE-N11A is not "No".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
  - id: b_s4_expre
    title: EXPRE (continued)
    precondition:
    - predicate: not (MARITAL_STATUS.outcome == 1)
      hint: Asked only when question MARITAL_STATUS is not "Married".
    - predicate: not (MARITAL_STATUS.outcome == 2)
      hint: Asked only when question MARITAL_STATUS is not "Common-law".
    - predicate: not (MARITAL_STATUS.outcome == 3)
      hint: Asked only when question MARITAL_STATUS is not "Separated".
    - predicate: not (MARITAL_STATUS.outcome == 4)
      hint: Asked only when question MARITAL_STATUS is not "Divorced".
    - predicate: not (MARITAL_STATUS.outcome == 5)
      hint: Asked only when question MARITAL_STATUS is not "Widowed".
    - predicate: not (DEMPRE_N11A.outcome == 1)
      hint: Asked only when question DEMPRE-N11A is not "Yes".
    - predicate: not (DEMPRE_N11A.outcome == 2)
      hint: Asked only when question DEMPRE-N11A is not "No".
    - predicate: not (INPATH_Q12.outcome == 2)
      hint: Asked only when question INPATH-Q12 is not "No".
    items:
    - id: EXPRE_Q6C
      kind: Question
      title: 'IN THOSE [response given in EXPRE-Q5A] YEARS, HOW MANY DID HE/SHE ONLY WORK SOME OF EACH? (full-time and part-time) Interviewer: If none enter 00'
      input:
        control: Editbox
        min: 0
        max: 99
      postcondition:
      - predicate: EXPRE_Q6C.outcome <= EXPRE_Q5A.outcome
        hint: EXPRE-Q6C cannot exceed the number of years given in EXPRE-Q5A.
      - predicate: EXPRE_Q6A.outcome + EXPRE_Q6B.outcome + EXPRE_Q6C.outcome == EXPRE_Q5A.outcome
        hint: Years full-time (EXPRE-Q6A), part-time (EXPRE-Q6B) and some of each (EXPRE-Q6C) must add up to the years in EXPRE-Q5A.
        invented: true
  - id: b_s5_sep
    title: '5. DEMPRE MODULE: Separation'
    precondition:
    - predicate: not (DEMPRE_N11A.outcome == 1)
      hint: Asked only when question DEMPRE-N11A is not "Yes".
    - predicate: not (DEMPRE_N11A.outcome == 2)
      hint: Asked only when question DEMPRE-N11A is not "No".
    - predicate: not (INPATH_Q12.outcome == 2)
      hint: Asked only when question INPATH-Q12 is not "No".
    - predicate: not (MARITAL_STATUS.outcome == 1)
      hint: Asked only when question MARITAL_STATUS is not "Married".
    - predicate: not (MARITAL_STATUS.outcome == 2)
      hint: Asked only when question MARITAL_STATUS is not "Common-law".
    - predicate: not (MARITAL_STATUS.outcome == 5)
      hint: Asked only when question MARITAL_STATUS is not "Widowed".
    items:
    - id: DEMPRE_Q1
      kind: Question
      title: WHAT WAS THE DATE OF [respondent]'S SEPARATION? (Not the date of divorce)
      input:
        control: Editbox
        min: 1880
        max: 2100
        left: Year
      postcondition:
      - predicate: DEMPRE_Q1.outcome <= CURRENT_YEAR_2.outcome and DEMPRE_Q1.outcome >= CURRENT_YEAR_2.outcome - AGE_2.outcome - 14
        hint: The date of separation (DEMPRE-Q1) must not be after the current year nor earlier than the year the respondent was 14.
    - id: DEMPRE_Q2
      kind: Question
      title: WHAT WAS THE DATE OF THIS MARRIAGE?
      input:
        control: Editbox
        min: 1880
        max: 2100
        left: Year
      postcondition:
      - predicate: DEMPRE_Q2.outcome <= CURRENT_YEAR_2.outcome and DEMPRE_Q2.outcome >= CURRENT_YEAR_2.outcome - AGE_2.outcome - 14
        hint: The date of marriage (DEMPRE-Q2) must not be after the current year nor earlier than the year the respondent was 14.
      - predicate: DEMPRE_Q2.outcome <= DEMPRE_Q1.outcome
        hint: The date of marriage (DEMPRE-Q2) must be before the date of separation (DEMPRE-Q1).
        invented: true
  - id: b_s5_first_marriage
    title: '5. DEMPRE MODULE: Current and first marriage'
    precondition:
    - predicate: not (DEMPRE_N11A.outcome == 1)
      hint: Asked only when question DEMPRE-N11A is not "Yes".
    - predicate: not (DEMPRE_N11A.outcome == 2)
      hint: Asked only when question DEMPRE-N11A is not "No".
    - predicate: not (INPATH_Q12.outcome == 2)
      hint: Asked only when question INPATH-Q12 is not "No".
    - predicate: not (MARITAL_STATUS.outcome == 2)
      hint: Asked only when question MARITAL_STATUS is not "Common-law".
    - predicate: not (MARITAL_STATUS.outcome == 5)
      hint: Asked only when question MARITAL_STATUS is not "Widowed".
    items:
    - id: DEMPRE_Q2B
      kind: Question
      title: WHAT WAS THE DATE OF [respondent]'S MARRIAGE?
      precondition:
      - predicate: DEMPRE_Q2.outcome is None or DEMPRE_Q1.outcome is None or not (DEMPRE_Q2.outcome <= DEMPRE_Q1.outcome)
        hint: Asked only when the marriage date (DEMPRE-Q2) was not before the separation date (DEMPRE-Q1).
      input:
        control: Editbox
        min: 1880
        max: 2100
        left: Year
      postcondition:
      - predicate: DEMPRE_Q2B.outcome <= CURRENT_YEAR_2.outcome and DEMPRE_Q2B.outcome >= CURRENT_YEAR_2.outcome - AGE_2.outcome - 14
        hint: The date of marriage (DEMPRE-Q2B) must not be after the current year nor earlier than the year the respondent was 14.
    - id: DEMPRE_Q3
      kind: Question
      title: WAS THIS [respondent]'S FIRST MARRIAGE?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: DK
          4: R
    - id: DEMPRE_Q4
      kind: Question
      title: WHAT WAS THE DATE OF [respondent]'S FIRST MARRIAGE?
      input:
        control: Editbox
        min: 1880
        max: 2100
        left: Year
      postcondition:
      - predicate: DEMPRE_Q4.outcome <= CURRENT_YEAR_2.outcome and DEMPRE_Q4.outcome >= CURRENT_YEAR_2.outcome - AGE_2.outcome - 14
        hint: The date of the first marriage (DEMPRE-Q4) must not be after the current year nor earlier than the year the respondent was 14.
      - predicate: not (MARITAL_STATUS.outcome in [3, 4]) or DEMPRE_Q4.outcome <= DEMPRE_Q2.outcome
        hint: The date of the first marriage (DEMPRE-Q4) should be before the date of the current marriage (DEMPRE-Q2).
        invented: true
      - predicate: MARITAL_STATUS.outcome != 1 or DEMPRE_Q4.outcome <= DEMPRE_Q2B.outcome
        hint: The date of the first marriage (DEMPRE-Q4) should be before the date of the current marriage (DEMPRE-Q2B).
        invented: true
  - id: b_s5_cohab
    title: '5. DEMPRE MODULE: Living together'
    precondition:
    - predicate: not (DEMPRE_N11A.outcome == 1)
      hint: Asked only when question DEMPRE-N11A is not "Yes".
    - predicate: not (DEMPRE_N11A.outcome == 2)
      hint: Asked only when question DEMPRE-N11A is not "No".
    - predicate: not (INPATH_Q12.outcome == 2)
      hint: Asked only when question INPATH-Q12 is not "No".
    - predicate: not (MARITAL_STATUS.outcome == 5)
      hint: Asked only when question MARITAL_STATUS is not "Widowed".
    items:
    - id: DEMPRE_Q5
      kind: Question
      title: WHEN DID [respondent] AND HIS/HER PARTNER BEGIN TO LIVE TOGETHER?
      input:
        control: Editbox
        min: 1880
        max: 2100
        left: Year
      postcondition:
      - predicate: DEMPRE_Q5.outcome <= CURRENT_YEAR_2.outcome and DEMPRE_Q5.outcome >= CURRENT_YEAR_2.outcome - AGE_2.outcome - 14
        hint: The date the couple began living together (DEMPRE-Q5) must not be after the current year nor earlier than the year the respondent was 14.
    - id: DEMPRE_Q6
      kind: Question
      title: HAS [respondent] EVER BEEN MARRIED?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: DK
          4: R
  - id: b_s5_prior_marriage
    title: '5. DEMPRE MODULE: Widowhood and previous marriage'
    precondition:
    - predicate: not (DEMPRE_N11A.outcome == 1)
      hint: Asked only when question DEMPRE-N11A is not "Yes".
    - predicate: not (DEMPRE_N11A.outcome == 2)
      hint: Asked only when question DEMPRE-N11A is not "No".
    - predicate: not (INPATH_Q12.outcome == 2)
      hint: Asked only when question INPATH-Q12 is not "No".
    items:
    - id: DEMPRE_Q7
      kind: Question
      title: WHEN WAS [respondent] WIDOWED?
      precondition:
      - predicate: not (DEMPRE_Q6.outcome == 1)
        hint: Asked only when question DEMPRE-Q6 is not "Yes".
      input:
        control: Editbox
        min: 1880
        max: 2100
        left: Year
      postcondition:
      - predicate: DEMPRE_Q7.outcome <= CURRENT_YEAR_2.outcome and DEMPRE_Q7.outcome >= CURRENT_YEAR_2.outcome - AGE_2.outcome - 14
        hint: The date widowed (DEMPRE-Q7) must not be after the current year nor earlier than the year the respondent was 14.
    - id: DEMPRE_Q8
      kind: Question
      title: WAS THIS [respondent]'S FIRST MARRIAGE?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: DK
          4: R
    - id: DEMPRE_Q9
      kind: Question
      title: WHAT WAS THE DATE OF [respondent]'S MARRIAGE?
      precondition:
      - predicate: not (DEMPRE_Q8.outcome == 2)
        hint: Asked only when question DEMPRE-Q8 is not "No".
      input:
        control: Editbox
        min: 1880
        max: 2100
        left: Year
      postcondition:
      - predicate: DEMPRE_Q9.outcome <= CURRENT_YEAR_2.outcome and DEMPRE_Q9.outcome >= CURRENT_YEAR_2.outcome - AGE_2.outcome - 14
        hint: The date of marriage (DEMPRE-Q9) must not be after the current year nor earlier than the year the respondent was 14.
      - predicate: MARITAL_STATUS.outcome != 5 or DEMPRE_Q9.outcome <= DEMPRE_Q7.outcome
        hint: The date of the previous marriage (DEMPRE-Q9) should be before the date widowed (DEMPRE-Q7).
        invented: true
      - predicate: MARITAL_STATUS.outcome != 2 or DEMPRE_Q9.outcome <= DEMPRE_Q5.outcome
        hint: The date of the previous marriage (DEMPRE-Q9) should be before the date the couple started living together (DEMPRE-Q5).
        invented: true
    - id: DEMPRE_Q10
      kind: Question
      title: WHAT WAS THE DATE OF [respondent]'S FIRST MARRIAGE?
      input:
        control: Editbox
        min: 1880
        max: 2100
        left: Year
      postcondition:
      - predicate: DEMPRE_Q10.outcome <= CURRENT_YEAR_2.outcome and DEMPRE_Q10.outcome >= CURRENT_YEAR_2.outcome - AGE_2.outcome - 14
        hint: The date of the first marriage (DEMPRE-Q10) must not be after the current year nor earlier than the year the respondent was 14.
      - predicate: MARITAL_STATUS.outcome != 2 or DEMPRE_Q10.outcome <= DEMPRE_Q5.outcome
        hint: The date of the first marriage (DEMPRE-Q10) should be before the date the couple started living together (DEMPRE-Q5).
        invented: true
      - predicate: MARITAL_STATUS.outcome != 5 or DEMPRE_Q10.outcome <= DEMPRE_Q7.outcome
        hint: The date of the first marriage (DEMPRE-Q10) should be before the date widowed (DEMPRE-Q7).
        invented: true
  - id: b_s5_children
    title: '5. DEMPRE MODULE: Children'
    precondition:
    - predicate: not (DEMPRE_N11A.outcome == 2)
      hint: Asked only when question DEMPRE-N11A is not "No".
    - predicate: not (INPATH_Q12.outcome == 2)
      hint: Asked only when question INPATH-Q12 is not "No".
    items:
    - id: DEMPRE_Q11
      kind: Question
      title: HAS [respondent] HAD ANY CHILDREN?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: DK
          4: R
    - id: DEMPRE_Q12
      kind: Question
      title: 'HOW MANY CHILDREN WERE EVER BORN TO [respondent]? Interviewer: Enter 0 if none, -1 for DK, -2 for R'
      precondition:
      - predicate: not (DEMPRE_Q11.outcome == 2)
        hint: Asked only when question DEMPRE-Q11 is not "No".
      - predicate: not (DEMPRE_Q11.outcome in [3, 4])
        hint: Asked only when question DEMPRE-Q11 is none of "DK", "R".
      input:
        control: Editbox
        min: -2
        max: 20
    - id: DEMPRE_Q13
      kind: Question
      title: IN WHAT YEAR DID [respondent] GIVE BIRTH TO HER FIRST CHILD?
      precondition:
      - predicate: not (DEMPRE_Q11.outcome == 2)
        hint: Asked only when question DEMPRE-Q11 is not "No".
      - predicate: not (DEMPRE_Q11.outcome in [3, 4])
        hint: Asked only when question DEMPRE-Q11 is none of "DK", "R".
      - predicate: not (DEMPRE_Q12.outcome in [0, -1, -2])
        hint: Asked only when question DEMPRE-Q12 is none of 0, "DK", "R".
      input:
        control: Editbox
        min: 1880
        max: 2100
        left: Year
      postcondition:
      - predicate: DEMPRE_Q13.outcome <= CURRENT_YEAR_2.outcome and DEMPRE_Q13.outcome >= CURRENT_YEAR_2.outcome - AGE_2.outcome - 14
        hint: The year of the first birth (DEMPRE-Q13) must not be after the current year nor earlier than the year the respondent was 14.
    - id: DEMPRE_Q14
      kind: Question
      title: (Other than children [respondent] has given birth to) HAS [respondent] ADOPTED OR RAISED ANY CHILDREN?
      precondition:
      - predicate: not (DEMPRE_Q11.outcome in [3, 4])
        hint: Asked only when question DEMPRE-Q11 is none of "DK", "R".
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: DK
          4: R
  - id: b_s5_adopted
    title: '5. DEMPRE MODULE: Adopted or raised children'
    precondition:
    - predicate: not (DEMPRE_N11A.outcome == 2)
      hint: Asked only when question DEMPRE-N11A is not "No".
    - predicate: not (DEMPRE_Q11.outcome in [3, 4])
      hint: Asked only when question DEMPRE-Q11 is none of "DK", "R".
    items:
    - id: DEMPRE_Q15
      kind: Question
      title: HOW MANY (other) CHILDREN HAS [respondent] ADOPTED OR RAISED?
      precondition:
      - predicate: not (DEMPRE_Q14.outcome in [2, 3, 4])
        hint: Asked only when question DEMPRE-Q14 is none of "No", "DK", "R".
      input:
        control: Range
        min: 1
        max: 20
  - id: b_s5_origin
    title: '5. DEMPRE MODULE: Language and birthplace'
    items:
    - id: DEMPRE_Q16
      kind: Question
      title: WHAT IS THE LANGUAGE THAT [respondent] FIRST LEARNED AT HOME IN CHILDHOOD AND STILL UNDERSTANDS?
      input:
        control: Radio
        labels:
          1: English
          2: French
          3: Other (SPECIFY)
    - id: DEMPRE_Q17
      kind: Question
      title: IN WHAT COUNTRY WAS [respondent] BORN?
      input:
        control: Dropdown
        labels:
          1: Canada
          2: United Kingdom
          3: Italy
          4: U.S.A.
          5: Germany
          6: Poland
          7: Other (SPECIFY)
  - id: b_s5_immigration
    title: '5. DEMPRE MODULE: Immigration'
    precondition:
    - predicate: not (DEMPRE_Q17.outcome == 1)
      hint: Asked only when question DEMPRE-Q17 is not "Canada".
    items:
    - id: DEMPRE_Q18
      kind: Question
      title: DID [respondent] IMMIGRATE TO CANADA?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: No(never immigrated - Canadian citizen by birth)
          3: DK
          4: R
    - id: DEMPRE_Q18B
      kind: Question
      title: IN WHAT YEAR WAS THAT?
      precondition:
      - predicate: not (DEMPRE_Q18.outcome in [2, 3, 4])
        hint: Asked only when question DEMPRE-Q18 is none of "No(never immigrated - Canadian citizen by birth)", "DK", "R".
      input:
        control: Editbox
        min: 1880
        max: 2100
        left: Year
      postcondition:
      - predicate: DEMPRE_Q18B.outcome <= CURRENT_YEAR_2.outcome and DEMPRE_Q18B.outcome >= CURRENT_YEAR_2.outcome - AGE_2.outcome
        hint: The year of immigration (DEMPRE-Q18B) must not be after the current year nor before the respondent's birth year.
  - id: b_s5_background
    title: '5. DEMPRE MODULE: Ethnic background'
    items:
    - id: DEMPRE_Q19
      kind: Question
      title: IS [respondent] A REGISTERED INDIAN AS DEFINED BY THE INDIAN ACT OF CANADA?
      input:
        control: Radio
        labels:
          1: Yes, Registered Indian
          2: No/DK/R
    - id: DEMPRE_Q20
      kind: Question
      title: 'CANADIANS COME FROM MANY ETHNIC, CULTURAL AND RACIAL BACKGROUNDS. FOR EXAMPLE, ENGLISH, FRENCH, NORTH AMERICAN INDIAN, CHINESE, BLACK, FILIPINO OR LEBANESE. WHAT IS [respondent]''S BACKGROUND? Interviewer: if indian, probe for North American or East. Mark all that apply.'
      input:
        control: Checkbox
        labels:
          1: English
          2: Dutch(netherlands)
          4: French
          8: Jewish
          16: German
          32: Polish
          64: Scottish
          128: Black
          256: Italian
          512: Métis
          1024: Irish
          2048: Inuit/eskimo
          4096: Ukrainian
          8192: North american indian
          16384: Chinese
          32768: East indian
          65536: Canadian(probe for any other background)
          131072: Other (specify)
    - id: DEMPRE_Q20A
      kind: Question
      title: 'Interviewer: Enter other ethnic background not already given in previous question.'
      precondition:
      - predicate: not (DEMPRE_Q20.outcome & 131072 == 0)
        hint: Asked only when "Other (specify)" was marked in DEMPRE-Q20.
      input:
        control: Textarea
  - id: b_s6_years
    title: 6. EDUPRE MODULE
    items:
    - id: EDUPRE_Q1
      kind: Question
      title: HOW MANY YEARS OF ELEMENTARY AND HIGH SCHOOL DID [respondent] COMPLETE?
      postcondition:
      - predicate: EDUPRE_Q1.outcome <= AGE_2.outcome - 5
        hint: Years of elementary and high school (EDUPRE-Q1) cannot exceed the respondent's age minus 5.
        invented: true
      input:
        control: Editbox
        min: 0
        max: 15
  - id: b_s6_school
    title: Schooling and enrolment
    precondition:
    - predicate: not (EDUPRE_Q1.outcome > AGE_2.outcome - 5 and EDUPRE_Q1.outcome == 0)
      hint: Asked unless the years of schooling (EDUPRE-Q1) are zero for a respondent old enough to have attended.
    items:
    - id: EDUPRE_Q2
      kind: Question
      title: IN WHICH PROVINCE OR TERRITORY DID [respondent] GET MOST OF HIS/HER ELEMENTARY AND HIGH SCHOOL EDUCATION?
      input:
        control: Dropdown
        labels:
          1: Newfoundland
          2: Prince Edward Island
          3: Nova Scotia
          4: New Brunswick
          5: Quebec
          6: Ontario
          7: Manitoba
          8: Saskatchewan
          9: Alberta
          10: British Columbia
          11: Yukon
          12: Northwest Territories
          13: Outside Canada
    - id: EDUPRE_Q3
      kind: Question
      title: DID [respondent] COMPLETE HIGH SCHOOL?
      precondition:
      - predicate: not (EDUPRE_Q1.outcome >= 1 and EDUPRE_Q1.outcome <= 9)
        hint: Asked only when 9 or fewer years were not reported in EDUPRE-Q1.
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
    - id: EDUPRE_Q4
      kind: Question
      title: EXCLUDING UNIVERSITY, HAS [respondent] EVER BEEN ENROLLED IN ANY OTHER KIND OF SCHOOL, FOR EXAMPLE, A COMMUNITY COLLEGE, BUSINESS SCHOOL, TRADE OR VOCATIONAL SCHOOL, OR CÉGEP?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: DK
          4: R
    - id: EDUPRE_Q12
      kind: Question
      title: HAS [respondent] EVER BEEN ENROLLED IN A UNIVERSITY?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: DK
          4: R
  - id: b_s6_nonuniv
    title: Non-university education
    precondition:
    - predicate: not (EDUPRE_Q1.outcome > AGE_2.outcome - 5 and EDUPRE_Q1.outcome == 0)
      hint: Asked unless the years of schooling (EDUPRE-Q1) are zero for a respondent old enough to have attended.
    - predicate: not (EDUPRE_Q4.outcome == 2)
      hint: Asked only when question EDUPRE-Q4 is not "No".
    items:
    - id: EDUPRE_Q5
      kind: Question
      title: HAS [respondent] RECEIVED ANY CERTIFICATES OR DIPLOMAS AS A RESULT OF THIS EDUCATION?
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: DK
          4: R
    - id: EDUPRE_Q11
      kind: Question
      title: 'IN TOTAL, HOW MANY YEARS OF SCHOOLING DID [respondent] COMPLETE AT A COMMUNITY COLLEGE, TECHNICAL INSTITUTE, TRADE OR VOCATIONAL SCHOOL, OR CÉGEP? Interviewer: Enter 00 if less than one year'
      postcondition:
      - predicate: EDUPRE_Q11.outcome <= AGE_2.outcome - 14
        hint: Years at college or trade school (EDUPRE-Q11) cannot exceed the respondent's age minus 14.
        invented: true
      input:
        control: Editbox
        min: 0
        max: 20
  - id: b_s6_cert
    title: Certificate or diploma
    precondition:
    - predicate: not (EDUPRE_Q1.outcome > AGE_2.outcome - 5 and EDUPRE_Q1.outcome == 0)
      hint: Asked unless the years of schooling (EDUPRE-Q1) are zero for a respondent old enough to have attended.
    - predicate: not (EDUPRE_Q4.outcome == 2)
      hint: Asked only when question EDUPRE-Q4 is not "No".
    - predicate: not (EDUPRE_Q5.outcome == 2)
      hint: Asked only when question EDUPRE-Q5 is not "No".
    items:
    - id: EDUPRE_Q6
      kind: Question
      title: THINKING OF THE MOST RECENT CERTIFICATE OR DIPLOMA (EXCLUDING UNIVERSITY) COULD YOU TELL ME WHAT TYPE OF SCHOOL OR COLLEGE [respondent] ATTENDED? WAS IT A . . .
      input:
        control: Radio
        labels:
          1: COMMUNITY COLLEGE OR INSTITUTE OF APPLIED ARTS AND TECHNOLOGY?
          2: BUSINESS OR COMMERCIAL SCHOOL?
          3: TRADE OR VOCATIONAL SCHOOL?
          4: CÉGEP?
          5: SOME OTHER TYPE (Specify)
    - id: EDUPRE_Q7
      kind: Question
      title: HOW LONG DID IT TAKE [respondent] TO COMPLETE THIS PROGRAM?
      input:
        control: Radio
        labels:
          1: Answer given in months
          2: Answer given in years
          3: DK
          4: R
    - id: EDUPRE_Q7A
      kind: Question
      title: 'Interviewer: Enter # of months it took [respondent] to complete this program.'
      precondition:
      - predicate: not (EDUPRE_Q7.outcome == 2)
        hint: Asked only when question EDUPRE-Q7 is not "Answer given in years".
      - predicate: not (EDUPRE_Q7.outcome in [3, 4])
        hint: Asked only when question EDUPRE-Q7 is none of "DK", "R".
      input:
        control: Editbox
        min: 1
        max: 99
    - id: EDUPRE_Q7B
      kind: Question
      title: 'Interviewer: Enter # of years it took [respondent] to complete this program.'
      precondition:
      - predicate: not (EDUPRE_Q7.outcome in [3, 4])
        hint: Asked only when question EDUPRE-Q7 is none of "DK", "R".
      - predicate: EDUPRE_Q7A.outcome is None or EDUPRE_Q7A.outcome < 1
        hint: Asked only when the number of months (EDUPRE-Q7A) was not given.
      input:
        control: Editbox
        min: 1
        max: 9
    - id: EDUPRE_Q8
      kind: Question
      title: WAS THIS FULL-TIME, PART-TIME OR SOME OF EACH?
      input:
        control: Radio
        labels:
          1: Full-time
          2: Part-time
          3: Some of each
    - id: EDUPRE_Q9
      kind: Question
      title: IN WHAT YEAR DID [respondent] RECEIVE HIS/HER CERTIFICATE OR DIPLOMA?
      postcondition:
      - predicate: EDUPRE_Q9.outcome <= CURRENT_YEAR_2.outcome and EDUPRE_Q9.outcome >= CURRENT_YEAR_2.outcome - AGE_2.outcome - 14
        hint: The year of the certificate or diploma (EDUPRE-Q9) must not be after the current year nor earlier than the year the respondent was 14.
      - predicate: EDUPRE_Q9.outcome < CURRENT_YEAR_2.outcome - AGE_2.outcome - 20 or EDUPRE_Q9.outcome > CURRENT_YEAR_2.outcome - AGE_2.outcome - 14
        hint: The year of the certificate or diploma (EDUPRE-Q9) does not fit the respondent's age (see AGE); verify the year.
        invented: true
      input:
        control: Editbox
        min: 1900
        max: 2100
    - id: EDUPRE_Q10
      kind: Question
      title: WHAT WAS THE MAJOR SUBJECT OR FIELD OF STUDY?
      input:
        control: Textarea
  - id: b_s6_univ
    title: University education
    precondition:
    - predicate: not (EDUPRE_Q1.outcome > AGE_2.outcome - 5 and EDUPRE_Q1.outcome == 0)
      hint: Asked unless the years of schooling (EDUPRE-Q1) are zero for a respondent old enough to have attended.
    - predicate: not (EDUPRE_Q12.outcome == 2)
      hint: Asked only when question EDUPRE-Q12 is not "No".
    items:
    - id: EDUPRE_Q13
      kind: Question
      title: 'HOW MANY YEARS OF UNIVERSITY HAS [respondent] COMPLETED? Interviewer: Enter 00 if attended university but didn''t complete the year.'
      postcondition:
      - predicate: EDUPRE_Q13.outcome <= AGE_2.outcome - 14
        hint: Years of university (EDUPRE-Q13) cannot exceed the respondent's age minus 14.
        invented: true
      input:
        control: Editbox
        min: 0
        max: 20
    - id: EDUPRE_Q14
      kind: Question
      title: WHAT DEGREES, CERTIFICATES OR DIPLOMAS HAS [respondent] RECEIVED FROM A UNIVERSITY?
      input:
        control: Radio
        labels:
          1: None
          2: Specify Degrees
          3: DK
          4: R
  - id: b_s6_degrees
    title: University degrees
    precondition:
    - predicate: not (EDUPRE_Q1.outcome > AGE_2.outcome - 5 and EDUPRE_Q1.outcome == 0)
      hint: Asked unless the years of schooling (EDUPRE-Q1) are zero for a respondent old enough to have attended.
    - predicate: not (EDUPRE_Q12.outcome == 2)
      hint: Asked only when question EDUPRE-Q12 is not "No".
    - predicate: not (EDUPRE_Q14.outcome == 1)
      hint: Asked only when question EDUPRE-Q14 is not "None".
    items:
    - id: EDUPRE_Q14A
      kind: Question
      title: 'Interviewer: Specify degrees, certificates or diplomas [respondent] has received from a university. Mark all that apply.'
      precondition:
      - predicate: not (EDUPRE_Q14.outcome in [3, 4])
        hint: Asked only when question EDUPRE-Q14 is none of "DK", "R".
      input:
        control: Checkbox
        labels:
          1: University certificate/diploma below Bachelor level
          2: Bachelor's degree(s)
          4: University certificate/diploma above Bachelor level
          8: Master's degree(s)
          16: Degree in medicine, dentistry,veterinary medicine or optometry
          32: Doctorate (PhD)
    - id: EDUPRE_Q15
      kind: Question
      title: WHAT YEAR DID [respondent] RECEIVE HIS/HER [highest response category given in EDUPRE-Q14A]?
      postcondition:
      - predicate: EDUPRE_Q15.outcome <= CURRENT_YEAR_2.outcome and EDUPRE_Q15.outcome >= CURRENT_YEAR_2.outcome - AGE_2.outcome - 18
        hint: The year the degree was received (EDUPRE-Q15) must not be after the current year nor earlier than the year the respondent was 18.
      input:
        control: Editbox
        min: 1900
        max: 2100
    - id: EDUPRE_Q16
      kind: Question
      title: WHAT WAS THE MAJOR FIELD OF STUDY?
      input:
        control: Textarea
  - id: b_s6_parents
    title: Parents' education
    items:
    - id: EDUPRE_Q17
      kind: Question
      title: WHAT WAS THE HIGHEST LEVEL OF EDUCATION COMPLETED BY [respondent]'S MOTHER? WAS IT ...
      input:
        control: Radio
        labels:
          1: ELEMENTARY SCHOOL (includes no schooling)?
          2: SOME HIGH SCHOOL?
          3: COMPLETED HIGH SCHOOL?
          4: TRADE/VOCATIONAL SCHOOL?
          5: POST-SECONDARY CERTIFICATE OR DIPLOMA? (e.g., community college, Cégep, teachers' college, school of nursing, etc.)
          6: UNIVERSITY DEGREE?
    - id: EDUPRE_Q18
      kind: Question
      title: WHAT WAS THE HIGHEST LEVEL OF EDUCATION COMPLETED BY [respondent]'S FATHER? WAS IT ...
      input:
        control: Radio
        labels:
          1: ELEMENTARY SCHOOL (includes no schooling)?
          2: SOME HIGH SCHOOL?
          3: COMPLETED HIGH SCHOOL?
          4: TRADE/VOCATIONAL SCHOOL?
          5: POST-SECONDARY CERTIFICATE OR DIPLOMA? (e.g., community college, Cégep, teachers' college, school of nursing, etc.)
          6: UNIVERSITY DEGREE?
