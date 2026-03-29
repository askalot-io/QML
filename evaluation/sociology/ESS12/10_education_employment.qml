qmlVersion: "1.0"
questionnaire:
  title: "ESS Round 12 - Education and Employment (B14-B36)"

  codeInit: |
    has_work_history = 0
    in_paid_work = 0
    b16_multiple = 0

  blocks:
    # =========================================================================
    # EDUCATION (B14-B15)
    # =========================================================================
    # B14a/b: Highest education level — country-specific ISCED mapping.
    #   Generic ISCED levels used here. ASK ALL.
    # B15: Years of full-time education. ASK ALL.
    # =========================================================================
    - id: b_education
      title: "Education"
      items:
        # B14a/B14b: Highest level of education
        - id: q_b14
          kind: Question
          title: "What is the highest level of education you have achieved?"
          input:
            control: Dropdown
            labels:
              1: "Less than lower secondary (ISCED 0-1)"
              2: "Lower secondary (ISCED 2)"
              3: "Lower tier upper secondary (ISCED 3)"
              4: "Upper tier upper secondary (ISCED 3)"
              5: "Advanced vocational / sub-degree (ISCED 4)"
              6: "Lower tertiary education, BA level (ISCED 5)"
              7: "Higher tertiary education, MA/PhD level (ISCED 6+)"
              8: "Other"

        # B15: Years of full-time education completed
        - id: q_b15
          kind: Question
          title: "About how many years of education have you completed, whether full-time or part-time? Please report in full-time equivalents."
          input:
            control: Editbox
            min: 0
            max: 50
            right: "years"

    # =========================================================================
    # ACTIVITY STATUS (B16-B20)
    # =========================================================================
    # B16: Multi-select activity status (Checkbox, power-of-2 keys). ASK ALL.
    #   If more than one selected → B17 (main activity).
    #   If "In paid work" selected (bit 0) → set in_paid_work=1, has_work_history=1.
    #   If B16 does NOT include "In paid work" → B18.
    #
    # B17: Main activity (single select from B16 options).
    #   Precondition: b16_multiple == 1.
    #
    # B18: Did paid work in last 7 days? Switch.
    #   Precondition: in_paid_work == 0 (not in paid work at B16).
    #   Yes → B21; No → B19.
    #
    # B19: Ever had a paid job? Switch.
    #   Precondition: q_b18.outcome == 0 (no paid work in last 7 days).
    #   Yes → B20; No → skip to B37 (next file).
    #
    # B20: Year last in paid job. Editbox.
    #   Precondition: q_b19.outcome == 1.
    # =========================================================================
    - id: b_activity
      title: "Activity Status"
      items:
        # B16: Activity in last 7 days — multi-select
        - id: q_b16
          kind: Question
          title: "Which of the following descriptions applies to what you have been doing for the last 7 days? Select all that apply."
          codeBlock: |
            if q_b16.outcome % 2 == 1:
                in_paid_work = 1
                has_work_history = 1
            b16_count = 0
            if q_b16.outcome % 2 >= 1:
                b16_count = b16_count + 1
            if q_b16.outcome % 4 >= 2:
                b16_count = b16_count + 1
            if q_b16.outcome % 8 >= 4:
                b16_count = b16_count + 1
            if q_b16.outcome % 16 >= 8:
                b16_count = b16_count + 1
            if q_b16.outcome % 32 >= 16:
                b16_count = b16_count + 1
            if q_b16.outcome % 64 >= 32:
                b16_count = b16_count + 1
            if q_b16.outcome % 128 >= 64:
                b16_count = b16_count + 1
            if q_b16.outcome % 256 >= 128:
                b16_count = b16_count + 1
            if q_b16.outcome % 512 >= 256:
                b16_count = b16_count + 1
            if b16_count > 1:
                b16_multiple = 1
          input:
            control: Checkbox
            labels:
              1: "In paid work (or away temporarily — employee, self-employed, working for family business)"
              2: "In education (not paid for by employer) even if on vacation"
              4: "Unemployed and actively looking for a job"
              8: "Unemployed, wanting a job but not actively looking for a job"
              16: "Permanently sick or disabled"
              32: "Retired"
              64: "In community or military service"
              128: "Doing housework, looking after children or other persons"
              256: "Other"

        # B17: Main activity — asked only when multiple activities selected
        - id: q_b17
          kind: Question
          title: "And which of these descriptions best describes your situation in the last 7 days?"
          precondition:
            - predicate: b16_multiple == 1
          input:
            control: Radio
            labels:
              1: "In paid work"
              2: "In education"
              3: "Unemployed, actively looking"
              4: "Unemployed, wanting job but not looking"
              5: "Permanently sick or disabled"
              6: "Retired"
              7: "Community or military service"
              8: "Housework, looking after children or others"
              9: "Other"

        # B18: Did any paid work of an hour or more in last 7 days?
        # Precondition: B16 does NOT include "In paid work" (bit 0 not set)
        - id: q_b18
          kind: Question
          title: "Just to check, did you do any paid work of an hour or more in the last 7 days?"
          precondition:
            - predicate: in_paid_work == 0
          codeBlock: |
            if q_b18.outcome == 1:
                has_work_history = 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # B19: Ever had a paid job?
        # Precondition: B18 = No (0)
        - id: q_b19
          kind: Question
          title: "Have you ever had a paid job?"
          precondition:
            - predicate: q_b18.outcome == 0
          codeBlock: |
            if q_b19.outcome == 1:
                has_work_history = 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # B20: Year last in a paid job
        # Precondition: B19 = Yes (1)
        - id: q_b20
          kind: Question
          title: "In what year were you last in a paid job?"
          precondition:
            - predicate: q_b19.outcome == 1
          input:
            control: Editbox
            min: 1950
            max: 2026
            right: "year"

    # =========================================================================
    # EMPLOYMENT DETAILS (B21-B36)
    # =========================================================================
    # Block precondition: has_work_history == 1
    #   (respondent is in paid work, did paid work last week, or ever had a job)
    #
    # B21: Employee / self-employed / family business → Radio {1-3}
    #   2 (self-employed) → B22 (number of employees)
    #   1,3 → skip B22, continue B23
    # B22: Number of employees. Precondition: q_b21.outcome == 2
    # B23-B24: Work contract and workplace size. ASK ALL with work history.
    # B25: Supervise others. 1 → B26; 0 → B27
    # B26: How many supervised. Precondition: q_b25.outcome == 1
    # B27-B28: Work autonomy scales. ASK ALL with work history.
    # B29-B30: Contracted and actual hours. ASK ALL with work history.
    # B31-B35: Occupation text descriptions. ASK ALL with work history.
    # B36: Worked abroad. ASK ALL with work history.
    # =========================================================================
    - id: b_employment
      title: "Employment Details"
      precondition:
        - predicate: has_work_history == 1
      items:
        # B21: Employee or self-employed
        - id: q_b21
          kind: Question
          title: "In your main job, are/were you...?"
          input:
            control: Radio
            labels:
              1: "An employee"
              2: "Self-employed"
              3: "Working for your own family's business"

        # B22: Number of employees (self-employed only)
        - id: q_b22
          kind: Question
          title: "How many employees do/did you have?"
          precondition:
            - predicate: q_b21.outcome == 2
          input:
            control: Editbox
            min: 0
            max: 99999

        # B23: Work contract type
        - id: q_b23
          kind: Question
          title: "Do/did you have a work contract of...?"
          input:
            control: Radio
            labels:
              1: "Unlimited duration"
              2: "Limited duration"
              3: "No contract at all"

        # B24: Workplace size
        - id: q_b24
          kind: Question
          title: "Including yourself, about how many people are/were employed at the place where you usually work/worked?"
          input:
            control: Radio
            labels:
              1: "Under 10"
              2: "10 to 24"
              3: "25 to 99"
              4: "100 to 499"
              5: "500 or more"

        # B25: Supervise other employees
        - id: q_b25
          kind: Question
          title: "In your main job, do/did you have any responsibility for supervising the work of other employees?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # B26: Number of people supervised
        # Precondition: B25 = Yes (1)
        - id: q_b26
          kind: Question
          title: "How many people are/were you responsible for?"
          precondition:
            - predicate: q_b25.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 99999

        # B27: Influence over own daily work
        - id: q_b27
          kind: Question
          title: "How much does/did the management at your work allow you to decide how your own daily work is/was organised?"
          input:
            control: Slider
            min: 0
            max: 10
            left: "I have/had no influence"
            right: "I have/had complete control"

        # B28: Influence over organisational policy
        - id: q_b28
          kind: Question
          title: "How much does/did the management at your work allow you to influence policy decisions about the activities of the organisation?"
          input:
            control: Slider
            min: 0
            max: 10
            left: "I have/had no influence"
            right: "I have/had complete control"

        # B29: Contracted hours per week
        - id: q_b29
          kind: Question
          title: "What are/were your total 'basic' or contracted hours each week in your main job?"
          input:
            control: Editbox
            min: 0
            max: 168
            right: "hours per week"

        # B30: Actual hours per week including overtime
        - id: q_b30
          kind: Question
          title: "Regardless of your basic or contracted hours, how many hours do/did you normally work a week in your main job, including any paid or unpaid overtime?"
          input:
            control: Editbox
            min: 0
            max: 168
            right: "hours per week"

        # B31: Employer's main activity
        - id: q_b31
          kind: Question
          title: "What does/did the firm or organisation you work/worked for mainly make or do?"
          input:
            control: Textarea
            placeholder: "Describe main activity of employer"

        # B32: Type of organisation
        - id: q_b32
          kind: Question
          title: "Which of the following types of organisation do/did you work for?"
          input:
            control: Dropdown
            labels:
              1: "Central or local government"
              2: "Other public sector (such as education and health)"
              3: "A state-owned enterprise"
              4: "A private firm"
              5: "Self-employed"
              6: "Other"

        # B33: Main job title
        - id: q_b33
          kind: Question
          title: "What is/was your main job?"
          input:
            control: Textarea
            placeholder: "Job title"

        # B34: Main tasks in job
        - id: q_b34
          kind: Question
          title: "What do/did you mainly do in this job?"
          input:
            control: Textarea
            placeholder: "Describe main tasks"

        # B35: Training or qualifications needed
        - id: q_b35
          kind: Question
          title: "What training or qualifications are/were needed for this job?"
          input:
            control: Textarea
            placeholder: "Describe required training or qualifications"

        # B36: Worked abroad in last 10 years
        - id: q_b36
          kind: Question
          title: "In the last 10 years have you done any paid work in another country for a period of 6 months or more?"
          input:
            control: Switch
            on: "Yes"
            off: "No"
