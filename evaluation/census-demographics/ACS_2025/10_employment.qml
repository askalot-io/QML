qmlVersion: "1.0"

questionnaire:
  title: "ACS 2025 - Employment (Person Q30-Q42)"

  codeInit: |
    # Extern: person age from demographics section
    person_age: range(0, 120)

    # Classification: whether person worked last week (set by Q30a/Q30b)
    # Needed because Q30a and Q30b are mutually exclusive paths that both
    # set work status — cannot be expressed as a single outcome reference
    worked_last_week = 0

    # Classification: whether person worked in past 5 years
    # Set by Q30a/Q30b (workers) and Q39 (non-workers who worked 1-5 yrs ago)
    # Consolidates outcomes from mutually exclusive items
    worked_past_5_years = 0

  blocks:
    # =========================================================================
    # BLOCK 1: WORK STATUS — Q30a, Q30b
    # Determines worked_last_week classification variable
    # All items gated on person_age >= 15 (Filter I)
    # =========================================================================
    - id: b_work_status
      title: "Work Status Last Week"
      precondition:
        - predicate: person_age >= 15
      items:
        # Q30a: Worked for pay last week?
        - id: q_p_q30a
          kind: Question
          title: "LAST WEEK, did this person work for pay at a job (or business)?"
          input:
            control: Switch
            off: "No"
            on: "Yes"
          codeBlock: |
            if q_p_q30a.outcome == 1:
                worked_last_week = 1
                worked_past_5_years = 1

        # Q30b: Any work even 1 hour? (only if Q30a = No)
        - id: q_p_q30b
          kind: Question
          title: "LAST WEEK, did this person do ANY work for pay, even for as little as one hour?"
          precondition:
            - predicate: q_p_q30a.outcome == 0
          input:
            control: Switch
            off: "No"
            on: "Yes"
          codeBlock: |
            if q_p_q30b.outcome == 1:
                worked_last_week = 1
                worked_past_5_years = 1

    # =========================================================================
    # BLOCK 2: WORK LOCATION — Q31a-f
    # Gated on worked_last_week == 1
    # =========================================================================
    - id: b_work_location
      title: "Work Location"
      precondition:
        - predicate: person_age >= 15
        - predicate: worked_last_week == 1
      items:
        # Q31a: Work address
        - id: q_p_q31a
          kind: Question
          title: "At what location did this person work LAST WEEK? (Number and street name)"
          input:
            control: Textarea
            placeholder: "Street address"
            maxLength: 200

        # Q31b: City/town
        - id: q_p_q31b
          kind: Question
          title: "Name of city, town, or post office"
          input:
            control: Textarea
            placeholder: "City or town"
            maxLength: 100

        # Q31c: Inside city limits?
        - id: q_p_q31c
          kind: Question
          title: "Is the work location inside the limits of that city or town?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q31d: County
        - id: q_p_q31d
          kind: Question
          title: "Name of county"
          input:
            control: Textarea
            placeholder: "County"
            maxLength: 100

        # Q31e: State or foreign country
        - id: q_p_q31e
          kind: Question
          title: "Name of U.S. state or foreign country"
          input:
            control: Textarea
            placeholder: "State or country"
            maxLength: 100

        # Q31f: ZIP Code
        - id: q_p_q31f
          kind: Question
          title: "ZIP Code"
          input:
            control: Editbox
            min: 0
            max: 99999

    # =========================================================================
    # BLOCK 3: COMMUTE — Q32, Q33, Q34, Q35
    # Gated on worked_last_week == 1
    # Q32 option 11 (Worked from home) → skip Q33-Q35, go to Q40a
    # Filter K: Q32 == 1 (car/truck/van) → Q33 carpool
    # =========================================================================
    - id: b_commute
      title: "Commuting to Work"
      precondition:
        - predicate: person_age >= 15
        - predicate: worked_last_week == 1
      items:
        # Q32: Transport mode — 12 options → Dropdown
        - id: q_p_q32
          kind: Question
          title: "How did this person usually get to work LAST WEEK? If this person usually used more than one method of transportation during the trip, mark the one used for most of the distance."
          input:
            control: Dropdown
            labels:
              1: "Car, truck, or van"
              2: "Bus"
              3: "Subway or elevated rail"
              4: "Long-distance train or commuter rail"
              5: "Light rail, streetcar, or trolley"
              6: "Ferryboat"
              7: "Taxi or ride-hailing services"
              8: "Motorcycle"
              9: "Bicycle"
              10: "Walked"
              11: "Worked from home"
              12: "Other method"

        # Q33: Carpool count — Filter K: only if Q32 == 1 (car/truck/van)
        - id: q_p_q33
          kind: Question
          title: "How many people, including this person, usually rode to work in the car, truck, or van LAST WEEK?"
          precondition:
            - predicate: q_p_q32.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 10

        # Q34: Trip start time — gated on not working from home
        - id: q_p_q34
          kind: Question
          title: "What time did this person usually leave home to go to work LAST WEEK? (Hour, 0-23)"
          precondition:
            - predicate: q_p_q32.outcome != 11
          input:
            control: Editbox
            min: 0
            max: 23

        # Q35: Commute duration — gated on not working from home
        - id: q_p_q35
          kind: Question
          title: "How many minutes did it usually take this person to get from home to work LAST WEEK?"
          precondition:
            - predicate: q_p_q32.outcome != 11
          input:
            control: Editbox
            min: 1
            max: 200

    # =========================================================================
    # BLOCK 4: JOB SEARCH — Q36a-c, Q37, Q38, Q39
    # Filter L: Only if NOT worked last week
    # Complex chain: Q36a → Q36b/Q36c → Q37 → Q38 → Q39
    # =========================================================================
    - id: b_job_search
      title: "Job Search and Layoff Status"
      precondition:
        - predicate: person_age >= 15
        - predicate: worked_last_week == 0
      items:
        # Q36a: On layoff?
        - id: q_p_q36a
          kind: Question
          title: "LAST WEEK, was this person on layoff from a job?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q36b: Temporarily absent? — only if NOT on layoff
        # Yes → skip to Q39; No → go to Q37
        - id: q_p_q36b
          kind: Question
          title: "LAST WEEK, was this person TEMPORARILY absent from a job or business?"
          precondition:
            - predicate: q_p_q36a.outcome == 0
          input:
            control: Radio
            labels:
              1: "Yes — on vacation, temporary illness, maternity leave, other family/personal reasons, bad weather, etc."
              2: "No"

        # Q36c: Recall within 6 months? — only if on layoff (Q36a=Yes)
        # Yes → skip to Q38; No → go to Q37
        - id: q_p_q36c
          kind: Question
          title: "Has this person been informed that he or she will be recalled to work within the next 6 months OR been given a date to return to work?"
          precondition:
            - predicate: q_p_q36a.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q37: Actively looking for work?
        # Reached when: (not on layoff AND not temporarily absent) OR (on layoff AND no recall)
        # i.e., (Q36a=No and Q36b=No/2) OR (Q36a=Yes and Q36c=No)
        - id: q_p_q37
          kind: Question
          title: "During the LAST 4 WEEKS, has this person been ACTIVELY looking for work?"
          precondition:
            - predicate: (q_p_q36a.outcome == 0 and q_p_q36b.outcome == 2) or (q_p_q36a.outcome == 1 and q_p_q36c.outcome == 0)
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q38: Could start a job?
        # Reached when: Q37=Yes (actively looking) OR (Q36a=Yes and Q36c=Yes — on layoff with recall)
        - id: q_p_q38
          kind: Question
          title: "LAST WEEK, could this person have started a job if offered one, or returned to work if recalled?"
          precondition:
            - predicate: q_p_q37.outcome == 1 or (q_p_q36a.outcome == 1 and q_p_q36c.outcome == 1)
          input:
            control: Radio
            labels:
              1: "Yes, could have gone to work"
              2: "No, because of own temporary illness"
              3: "No, because of all other reasons (in school, etc.)"

        # Q39: When last worked?
        # Asked of all non-workers (worked_last_week == 0), except those
        # temporarily absent (Q36b=Yes/1) who skip directly here from the
        # source but don't need Q39 since they have a job. In the ACS paper
        # form, Q36b=Yes routes to Q39. We model this: Q39 is shown when
        # NOT temporarily absent, or when temporarily absent (converging path).
        # Actually per inventory: Q36b=1 → SKIP TO Q39, Q36b=2 → SKIP TO Q37
        # and Q37=No → SKIP TO Q39. So Q39 is reached by multiple paths.
        # Simplest: show Q39 to all non-workers.
        - id: q_p_q39
          kind: Question
          title: "When did this person last work for pay, even for a few days?"
          input:
            control: Radio
            labels:
              1: "Within the past 12 months"
              2: "1 to 5 years ago"
              3: "Over 5 years ago or never worked"
          codeBlock: |
            if q_p_q39.outcome == 1 or q_p_q39.outcome == 2:
                worked_past_5_years = 1

    # =========================================================================
    # BLOCK 5: WORK HISTORY — Q40a, Q40b, Q41
    # Worked in past 12 months: either worked last week OR Q39 == 1
    # =========================================================================
    - id: b_work_history
      title: "Work History (Past 12 Months)"
      precondition:
        - predicate: person_age >= 15
      items:
        # Q40a: Worked every week in past 12 months?
        # Shown when: worked last week OR last worked within past 12 months
        - id: q_p_q40a
          kind: Question
          title: "During the PAST 12 MONTHS (52 weeks), did this person work EVERY week? Include paid vacation, paid sick leave, and military service."
          precondition:
            - predicate: worked_last_week == 1 or q_p_q39.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q40b: Weeks worked — only if Q40a = No
        - id: q_p_q40b
          kind: Question
          title: "During the PAST 12 MONTHS (52 weeks), how many WEEKS did this person work for at least one day? Include paid time off."
          precondition:
            - predicate: worked_last_week == 1 or q_p_q39.outcome == 1
            - predicate: q_p_q40a.outcome == 0
          input:
            control: Editbox
            min: 0
            max: 52

        # Q41: Hours per week
        - id: q_p_q41
          kind: Question
          title: "During the PAST 12 MONTHS, for the weeks worked, how many HOURS did this person usually work each WEEK?"
          precondition:
            - predicate: worked_last_week == 1 or q_p_q39.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 99

    # =========================================================================
    # BLOCK 6: EMPLOYER DETAILS — Q42a-f
    # Filter M: worked in past 5 years
    # Workers (worked_last_week==1) set worked_past_5_years in Q30a/Q30b
    # Non-workers with Q39 in {1,2} set it in Q39 codeBlock
    # =========================================================================
    - id: b_employer
      title: "Employer and Occupation Details"
      precondition:
        - predicate: person_age >= 15
        - predicate: worked_past_5_years == 1
      items:
        # Q42a: Employment type — 9 options → Dropdown
        - id: q_p_q42a
          kind: Question
          title: "Which one of the following best describes this person's employment last week or the most recent employment in the past 5 years?"
          input:
            control: Dropdown
            labels:
              1: "For-profit company or organization"
              2: "Non-profit organization (including tax-exempt and charitable)"
              3: "Local government (city, county, etc.)"
              4: "State government"
              5: "Active duty U.S. Armed Forces or Commissioned Corps"
              6: "Federal government civilian employee"
              7: "Owner of non-incorporated business, professional practice, or farm"
              8: "Owner of incorporated business, professional practice, or farm"
              9: "Worked without pay in a for-profit family business or farm for 15 hours or more per week"

        # Q42b: Employer name
        - id: q_p_q42b
          kind: Question
          title: "What was the name of this person's employer, business, agency, or branch of the Armed Forces?"
          input:
            control: Textarea
            placeholder: "Employer name"
            maxLength: 200

        # Q42c: Business/industry
        - id: q_p_q42c
          kind: Question
          title: "What kind of business or industry was this? Describe the activity at the location where employed. (For example: hospital, newspaper publishing, mail order house, auto engine manufacturing, bank)"
          input:
            control: Textarea
            placeholder: "Type of business or industry"
            maxLength: 200

        # Q42d: Mainly manufacturing/wholesale/retail/other — 4 options → Radio
        - id: q_p_q42d
          kind: Question
          title: "Was this mainly —"
          input:
            control: Radio
            labels:
              1: "Manufacturing?"
              2: "Wholesale trade?"
              3: "Retail trade?"
              4: "Other (agriculture, construction, service, government, etc.)?"

        # Q42e: Main occupation
        - id: q_p_q42e
          kind: Question
          title: "What was this person's main occupation? Describe the kind of work this person did. (For example: 4th grade teacher, entry-level plumber, concrete mason, or stock clerk)"
          input:
            control: Textarea
            placeholder: "Occupation title"
            maxLength: 200

        # Q42f: Duties description
        - id: q_p_q42f
          kind: Question
          title: "Describe this person's most important activities or duties. (For example: instruct and evaluate students, install water pipes and fixtures, mix and pour concrete, keep records of parts and supplies)"
          input:
            control: Textarea
            placeholder: "Main duties"
            maxLength: 200
