qmlVersion: "1.0"
questionnaire:
  title: "ESS Round 12 - Income, Partner, and Parents (B37-B60)"

  codeInit: |
    # Extern variable from household/marital section
    has_partner: {0, 1}
    partner_in_paid_work = 0
    partner_has_work = 0
    b45_multiple = 0

  blocks:
    # =========================================================================
    # UNEMPLOYMENT HISTORY (B37-B39)
    # =========================================================================
    # B37: Ever unemployed 3+ months? Switch. ASK ALL.
    #   Yes → B38, B39; No → skip to B40.
    # B38: Any period lasted 12+ months? Switch. Precondition: B37 = Yes.
    # B39: Any period in past 5 years? Switch. Precondition: B37 = Yes.
    # =========================================================================
    - id: b_unemployment
      title: "Unemployment History"
      items:
        # B37: Ever unemployed 3+ months
        - id: q_b37
          kind: Question
          title: "Have you ever been unemployed and seeking work for a period of more than 3 months?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # B38: Any period lasted 12 months or more
        - id: q_b38
          kind: Question
          title: "Have any of these periods of unemployment lasted for 12 months or more?"
          precondition:
            - predicate: q_b37.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # B39: Any period in past 5 years
        - id: q_b39
          kind: Question
          title: "Have any of these periods of unemployment, that lasted more than 3 months, been within the past 5 years?"
          precondition:
            - predicate: q_b37.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # =========================================================================
    # UNION AND INCOME (B40-B43)
    # =========================================================================
    # All ASK ALL. No routing.
    # B40: Trade union membership.
    # B41: Main household income source.
    # B42: Household income decile (country-specific, simplified to 10 bands).
    # B43: Feeling about household income.
    # =========================================================================
    - id: b_income
      title: "Union Membership and Household Income"
      items:
        # B40: Trade union membership
        - id: q_b40
          kind: Question
          title: "Are you or have you ever been a member of a trade union or similar organisation?"
          input:
            control: Radio
            labels:
              1: "Yes, currently"
              2: "Yes, previously"
              3: "No"

        # B41: Main source of household income
        - id: q_b41
          kind: Question
          title: "Please consider the income of all household members and any income which may be received by the household as a whole. What is the main source of income in your household?"
          input:
            control: Dropdown
            labels:
              1: "Wages or salaries"
              2: "Income from self-employment (excluding farming)"
              3: "Income from farming"
              4: "Pensions"
              5: "Unemployment/redundancy benefit"
              6: "Any other social benefits or grants"
              7: "Income from investment, savings, insurance or property"
              8: "Income from other sources"

        # B42: Household income decile (country-specific bands simplified)
        - id: q_b42
          kind: Question
          title: "Which of the following descriptions comes closest to your household's total net income from all sources, after tax and compulsory deductions?"
          input:
            control: Dropdown
            labels:
              1: "1st decile (lowest)"
              2: "2nd decile"
              3: "3rd decile"
              4: "4th decile"
              5: "5th decile"
              6: "6th decile"
              7: "7th decile"
              8: "8th decile"
              9: "9th decile"
              10: "10th decile (highest)"

        # B43: Feeling about household income
        - id: q_b43
          kind: Question
          title: "Which of the following descriptions comes closest to how you feel about your household's income nowadays?"
          input:
            control: Radio
            labels:
              1: "Living comfortably on present income"
              2: "Coping on present income"
              3: "Finding it difficult on present income"
              4: "Finding it very difficult on present income"

    # =========================================================================
    # PARTNER DETAILS (B44-B52)
    # =========================================================================
    # Block precondition: has_partner == 1
    #
    # B44: Partner's highest education — Dropdown (ISCED). ASK ALL with partner.
    # B45: Partner's activity status — Checkbox (power-of-2).
    #   If more than one selected → B46.
    #   If partner NOT in paid work → B47.
    #   If partner in paid work → B48.
    # B46: Partner's main activity — Radio. Precondition: b45_multiple == 1.
    # B47: Partner did paid work? Switch.
    #   Precondition: partner_in_paid_work == 0.
    #   Yes → B48; No → skip to B53.
    # B48-B52: Partner's job details.
    #   Precondition: partner_has_work == 1.
    # =========================================================================
    - id: b_partner
      title: "Partner's Background"
      precondition:
        - predicate: has_partner == 1
      items:
        # B44a/B44b: Partner's highest education level
        - id: q_b44
          kind: Question
          title: "What is the highest level of education your husband, wife, or partner has achieved?"
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

        # B45: Partner's activity in last 7 days — multi-select
        - id: q_b45
          kind: Question
          title: "Which of the following descriptions applies to what your husband, wife, or partner has been doing for the last 7 days? Select all that apply."
          codeBlock: |
            if q_b45.outcome % 2 == 1:
                partner_in_paid_work = 1
                partner_has_work = 1
            b45_count = 0
            if q_b45.outcome % 2 >= 1:
                b45_count = b45_count + 1
            if q_b45.outcome % 4 >= 2:
                b45_count = b45_count + 1
            if q_b45.outcome % 8 >= 4:
                b45_count = b45_count + 1
            if q_b45.outcome % 16 >= 8:
                b45_count = b45_count + 1
            if q_b45.outcome % 32 >= 16:
                b45_count = b45_count + 1
            if q_b45.outcome % 64 >= 32:
                b45_count = b45_count + 1
            if q_b45.outcome % 128 >= 64:
                b45_count = b45_count + 1
            if q_b45.outcome % 256 >= 128:
                b45_count = b45_count + 1
            if q_b45.outcome % 512 >= 256:
                b45_count = b45_count + 1
            if b45_count > 1:
                b45_multiple = 1
          input:
            control: Checkbox
            labels:
              1: "In paid work (or away temporarily)"
              2: "In education (not paid for by employer)"
              4: "Unemployed and actively looking for a job"
              8: "Unemployed, wanting a job but not actively looking"
              16: "Permanently sick or disabled"
              32: "Retired"
              64: "In community or military service"
              128: "Doing housework, looking after children or others"
              256: "Other"

        # B46: Partner's main activity
        - id: q_b46
          kind: Question
          title: "And which of these descriptions best describes your husband, wife, or partner's situation in the last 7 days?"
          precondition:
            - predicate: b45_multiple == 1
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

        # B47: Partner did paid work in last 7 days?
        # Precondition: partner NOT in paid work at B45
        - id: q_b47
          kind: Question
          title: "Just to check, did your husband, wife, or partner do any paid work of an hour or more in the last 7 days?"
          precondition:
            - predicate: partner_in_paid_work == 0
          codeBlock: |
            if q_b47.outcome == 1:
                partner_has_work = 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # B48: Partner's main job title
        - id: q_b48
          kind: Question
          title: "What is your husband, wife, or partner's main job?"
          precondition:
            - predicate: partner_has_work == 1
          input:
            control: Textarea
            placeholder: "Partner's job title"

        # B49: Partner's main tasks
        - id: q_b49
          kind: Question
          title: "What does your husband, wife, or partner mainly do in their job?"
          precondition:
            - predicate: partner_has_work == 1
          input:
            control: Textarea
            placeholder: "Describe partner's main tasks"

        # B50: Partner's qualifications needed
        - id: q_b50
          kind: Question
          title: "What training or qualifications are needed for your husband, wife, or partner's job?"
          precondition:
            - predicate: partner_has_work == 1
          input:
            control: Textarea
            placeholder: "Describe required training or qualifications"

        # B51: Partner employee or self-employed
        - id: q_b51
          kind: Question
          title: "In your husband, wife, or partner's main job, are they...?"
          precondition:
            - predicate: partner_has_work == 1
          input:
            control: Radio
            labels:
              1: "An employee"
              2: "Self-employed"
              3: "Working for own family's business"

        # B52: Partner's normal working hours
        - id: q_b52
          kind: Question
          title: "How many hours does your husband, wife, or partner normally work a week in their main job?"
          precondition:
            - predicate: partner_has_work == 1
          input:
            control: Editbox
            min: 0
            max: 168
            right: "hours per week"

    # =========================================================================
    # PARENTS' BACKGROUND (B53-B58)
    # =========================================================================
    # B53: Father's education — Dropdown. ASK ALL.
    # B54: Father's work status when respondent was 14 — Radio {1-4,7}.
    #   1,2 → B55 (father's occupation); 3,4,7 → skip to B56.
    # B55: Father's occupation type. Precondition: B54 in [1, 2].
    # B56: Mother's education — Dropdown. ASK ALL.
    # B57: Mother's work status when respondent was 14 — Radio {1-4,7}.
    #   1,2 → B58 (mother's occupation); 3,4,7 → skip to B59.
    # B58: Mother's occupation type. Precondition: B57 in [1, 2].
    # =========================================================================
    - id: b_parents
      title: "Parents' Background"
      items:
        # B53a/B53b: Father's highest education level
        - id: q_b53
          kind: Question
          title: "What is the highest level of education your father achieved?"
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
              77: "Prefer not to answer"

        # B54: Father's work status when respondent was 14
        - id: q_b54
          kind: Question
          title: "When you were 14, did your father work as an employee, was he self-employed, or was he not working then?"
          input:
            control: Radio
            labels:
              1: "Employee"
              2: "Self-employed"
              3: "Not working"
              4: "Father deceased or absent when I was 14"
              7: "Prefer not to answer"

        # B55: Father's occupation type
        # Precondition: B54 = employee or self-employed
        - id: q_b55
          kind: Question
          title: "Which one of the descriptions from the following list best describes the sort of work your father did when you were 14?"
          precondition:
            - predicate: q_b54.outcome in [1, 2]
          input:
            control: Dropdown
            labels:
              1: "Professional and technical"
              2: "Higher administrator"
              3: "Clerical"
              4: "Sales"
              5: "Service"
              6: "Skilled worker"
              7: "Semi-skilled worker"
              8: "Unskilled worker"
              9: "Farm worker"
              77: "Prefer not to answer"

        # B56a/B56b: Mother's highest education level
        - id: q_b56
          kind: Question
          title: "What is the highest level of education your mother achieved?"
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
              77: "Prefer not to answer"

        # B57: Mother's work status when respondent was 14
        - id: q_b57
          kind: Question
          title: "When you were 14, did your mother work as an employee, was she self-employed, or was she not working then?"
          input:
            control: Radio
            labels:
              1: "Employee"
              2: "Self-employed"
              3: "Not working"
              4: "Mother deceased or absent when I was 14"
              7: "Prefer not to answer"

        # B58: Mother's occupation type
        # Precondition: B57 = employee or self-employed
        - id: q_b58
          kind: Question
          title: "Which one of the descriptions from the following list best describes the sort of work your mother did when you were 14?"
          precondition:
            - predicate: q_b57.outcome in [1, 2]
          input:
            control: Dropdown
            labels:
              1: "Professional and technical"
              2: "Higher administrator"
              3: "Clerical"
              4: "Sales"
              5: "Service"
              6: "Skilled worker"
              7: "Semi-skilled worker"
              8: "Unskilled worker"
              9: "Farm worker"
              77: "Prefer not to answer"

    # =========================================================================
    # TRAINING AND ANCESTRY (B59-B60)
    # =========================================================================
    # B59: Training/courses in past 12 months. Switch. ASK ALL.
    # B60: Ancestry — country-specific, simplified to Dropdown. ASK ALL.
    # =========================================================================
    - id: b_training_ancestry
      title: "Training and Ancestry"
      items:
        # B59: Training or courses in past 12 months
        - id: q_b59
          kind: Question
          title: "During the last twelve months, have you taken any course or attended any lecture or conference to improve your knowledge or skills for work?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # B60: Ancestry (country-specific, simplified to text)
        - id: q_b60
          kind: Question
          title: "How would you describe your ancestry?"
          input:
            control: Textarea
            placeholder: "Describe your ancestry (country-specific options apply)"
