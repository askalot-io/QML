qmlVersion: "1.0"
questionnaire:
  title: "NLSCY Children and Youth Survey - Income"
  codeInit: |
    # Gate variables
    has_income = 0              # 1=household has any income source, 0=none
    source_count = 0            # count of income sources selected
    multiple_sources = 0        # 1=more than one source selected
    household_income_known = 0  # bracket estimation fallback
    personal_income_known = 0

  blocks:
    # =========================================================================
    # BLOCK 1: HOUSEHOLD INCOME SOURCES
    # =========================================================================
    # INCOM-Q1: Sources of household income (mark all that apply)
    #   Option 14=None → GO TO NEXT SECTION (modeled as gate question)
    # INCOM-C1A: IF more than one source → ask Q2; otherwise skip Q2
    # INCOM-Q2: Main source of income (only when multiple sources)
    # =========================================================================
    - id: b_income_sources
      title: "Household Income Sources"
      items:
        # INCOM-Q1 gate: option 14=None (GO TO NEXT SECTION)
        # Modeled as a switch since "None" is exclusive with all other options
        - id: q_incom_has_income
          kind: Question
          title: "Did your household receive income from any source in the past 12 months?"
          codeBlock: |
            has_income = q_incom_has_income.outcome
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # INCOM-Q1: Income sources (mark all that apply)
        # Only shown when household has income
        - id: q_incom_q1
          kind: Question
          title: "From which of the following sources did your household receive income in the past 12 months? (Mark all that apply.)"
          precondition:
            - predicate: has_income == 1
          codeBlock: |
            # INCOM-C1A: check if multiple sources selected
            # With power-of-2 encoding, a single source is always a power of 2.
            # If outcome is not a power of 2, multiple sources were selected.
            # Check: n > 0 and (n & (n-1)) != 0 → multiple sources.
            # Since bitwise ops aren't available, count set bits via explicit checks.
            source_count = 0
            if q_incom_q1.outcome >= 4096: source_count = source_count + 1
            if q_incom_q1.outcome % 4096 >= 2048: source_count = source_count + 1
            if q_incom_q1.outcome % 2048 >= 1024: source_count = source_count + 1
            if q_incom_q1.outcome % 1024 >= 512: source_count = source_count + 1
            if q_incom_q1.outcome % 512 >= 256: source_count = source_count + 1
            if q_incom_q1.outcome % 256 >= 128: source_count = source_count + 1
            if q_incom_q1.outcome % 128 >= 64: source_count = source_count + 1
            if q_incom_q1.outcome % 64 >= 32: source_count = source_count + 1
            if q_incom_q1.outcome % 32 >= 16: source_count = source_count + 1
            if q_incom_q1.outcome % 16 >= 8: source_count = source_count + 1
            if q_incom_q1.outcome % 8 >= 4: source_count = source_count + 1
            if q_incom_q1.outcome % 4 >= 2: source_count = source_count + 1
            if q_incom_q1.outcome % 2 >= 1: source_count = source_count + 1
            if source_count > 1:
                multiple_sources = 1
          input:
            control: Checkbox
            labels:
              1: "Wages and salaries"
              2: "Income from self-employment"
              4: "Dividends and interest (e.g., on bonds, deposits, etc.)"
              8: "Unemployment insurance"
              16: "Worker's compensation"
              32: "Benefits from Canada or Quebec Pension Plan"
              64: "Retirement pensions, superannuation and annuities"
              128: "Old Age Security and Guaranteed Income Supplement"
              256: "Child Tax Benefit"
              512: "Provincial or municipal social assistance or welfare"
              1024: "Child support"
              2048: "Alimony"
              4096: "Other (e.g., other government, rental income, scholarships)"

        # INCOM-Q2: Main source of income
        # INCOM-C1A: only asked when multiple sources indicated
        - id: q_incom_q2
          kind: Question
          title: "What was the main source of income for your household?"
          precondition:
            - predicate: has_income == 1
            - predicate: multiple_sources == 1
          input:
            control: Dropdown
            labels:
              1: "Wages and salaries"
              2: "Income from self-employment"
              3: "Dividends and interest (e.g., on bonds, deposits, etc.)"
              4: "Unemployment insurance"
              5: "Worker's compensation"
              6: "Benefits from Canada or Quebec Pension Plan"
              7: "Retirement pensions, superannuation and annuities"
              8: "Old Age Security and Guaranteed Income Supplement"
              9: "Child Tax Benefit"
              10: "Provincial or municipal social assistance or welfare"
              11: "Child support"
              12: "Alimony"
              13: "Other (e.g., other government, rental income, scholarships)"

    # =========================================================================
    # BLOCK 2: HOUSEHOLD INCOME AMOUNT
    # =========================================================================
    # INCOM-Q3: Exact household income
    # INCOM-Q3_GATE: Can respondent estimate exact amount?
    # INCOM-Q3B: Household income bracket (fallback when exact unknown)
    # =========================================================================
    - id: b_household_income
      title: "Household Income"
      precondition:
        - predicate: has_income == 1
      items:
        # Gate question: Can the respondent estimate exact household income?
        - id: q_incom_q3_gate
          kind: Question
          title: "Can you estimate the exact total household income before taxes and deductions from all sources in the past 12 months?"
          codeBlock: |
            household_income_known = q_incom_q3_gate.outcome
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # INCOM-Q3: Exact household income (shown when respondent can estimate)
        - id: q_incom_q3
          kind: Question
          title: "What is your best estimate of the total income before taxes and deductions of all household members from all sources in the past 12 months?"
          precondition:
            - predicate: household_income_known == 1
          input:
            control: Editbox
            min: 0
            max: 999999
            left: "$"

        # INCOM-Q3B: Household income bracket (shown when exact amount unknown)
        # Original uses a cascading binary search tree; modeled here as a
        # single Dropdown with the final bracket options.
        - id: q_incom_q3b
          kind: Question
          title: "Can you estimate in which of the following groups your household income falls?"
          precondition:
            - predicate: household_income_known == 0
          input:
            control: Dropdown
            labels:
              1: "Less than $5,000"
              2: "$5,000 to less than $10,000"
              3: "$10,000 to less than $15,000"
              4: "$15,000 to less than $20,000"
              5: "$20,000 to less than $30,000"
              6: "$30,000 to less than $40,000"
              7: "$40,000 to less than $50,000"
              8: "$50,000 to less than $60,000"
              9: "$60,000 to less than $80,000"
              10: "$80,000 or more"

    # =========================================================================
    # BLOCK 3: PERSONAL INCOME AMOUNT
    # =========================================================================
    # INCOM-Q4: Exact personal income
    # INCOM-Q4_GATE: Can respondent estimate exact amount?
    # INCOM-Q4B: Personal income bracket (fallback when exact unknown)
    # =========================================================================
    - id: b_personal_income
      title: "Personal Income"
      precondition:
        - predicate: has_income == 1
      items:
        # Gate question: Can the respondent estimate exact personal income?
        - id: q_incom_q4_gate
          kind: Question
          title: "Can you estimate the exact total personal income before taxes and deductions from all sources in the past 12 months?"
          codeBlock: |
            personal_income_known = q_incom_q4_gate.outcome
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # INCOM-Q4: Exact personal income (shown when respondent can estimate)
        - id: q_incom_q4
          kind: Question
          title: "What is your best estimate of your total personal income before taxes and deductions from all sources in the past 12 months?"
          precondition:
            - predicate: personal_income_known == 1
          input:
            control: Editbox
            min: 0
            max: 999999
            left: "$"

        # INCOM-Q4B: Personal income bracket (shown when exact amount unknown)
        # Same cascading-to-Dropdown simplification as INCOM-Q3B.
        - id: q_incom_q4b
          kind: Question
          title: "Can you estimate in which of the following groups your personal income falls?"
          precondition:
            - predicate: personal_income_known == 0
          input:
            control: Dropdown
            labels:
              1: "Less than $5,000"
              2: "$5,000 to less than $10,000"
              3: "$10,000 to less than $15,000"
              4: "$15,000 to less than $20,000"
              5: "$20,000 to less than $30,000"
              6: "$30,000 to less than $40,000"
              7: "$40,000 to less than $50,000"
              8: "$50,000 to less than $60,000"
              9: "$60,000 to less than $80,000"
              10: "$80,000 or more"
