qmlVersion: '1.0'
questionnaire:
  title: 19 Income Housing
  codeInit: |
    # No extern variables needed for this section
    # Extern variables from prior sections
    age: range(12, 120)
    # Track whether exact household income was given
    hh_income_given = 0
    # Track number of income sources for routing
    income_source_count = 0
    # Extern variables
    has_children: {0, 1}
    # Track food insecurity indicators for routing
    food_insecurity = 0
  blocks:
  - id: b_insurance
    title: Insurance Coverage
    items:
    - id: q_ins_qint
      kind: Comment
      title: Now, turning to your insurance coverage. Please include any private, government or employer-paid plans.
    - id: q_ins_q1
      kind: Question
      title: Do you have insurance that covers all or part of the cost of your prescription medications?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_ins_q1a
      kind: Question
      title: 'Is it: (Mark all that apply)'
      precondition:
      - predicate: q_ins_q1.outcome == 1
      input:
        control: Checkbox
        labels:
          1: A government-sponsored plan
          2: An employer-sponsored plan
          4: A private plan
    - id: q_ins_q2
      kind: Question
      title: Do you have insurance that covers all or part of your dental expenses?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_ins_q2a
      kind: Question
      title: 'Is it: (Mark all that apply)'
      precondition:
      - predicate: q_ins_q2.outcome == 1
      input:
        control: Checkbox
        labels:
          1: A government-sponsored plan
          2: An employer-sponsored plan
          4: A private plan
    - id: q_ins_q3
      kind: Question
      title: Do you have insurance that covers all or part of the costs of eye glasses or contact lenses?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_ins_q3a
      kind: Question
      title: 'Is it: (Mark all that apply)'
      precondition:
      - predicate: q_ins_q3.outcome == 1
      input:
        control: Checkbox
        labels:
          1: A government-sponsored plan
          2: An employer-sponsored plan
          4: A private plan
    - id: q_ins_q4
      kind: Question
      title: Do you have insurance that covers all or part of hospital charges for a private or semi-private room?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_ins_q4a
      kind: Question
      title: 'Is it: (Mark all that apply)'
      precondition:
      - predicate: q_ins_q4.outcome == 1
      input:
        control: Checkbox
        labels:
          1: A government-sponsored plan
          2: An employer-sponsored plan
          4: A private plan
  - id: b_income_sources
    title: Income Sources
    items:
    - id: q_inc_qint
      kind: Comment
      title: Although many health expenses are covered by health insurance, there is still a relationship between health and
        income. The next questions deal with your household income.
    - id: q_inc_q1
      kind: Question
      title: Thinking about the total income for all household members, from which of the following sources did your household
        receive any income in the past 12 months? (Mark all that apply)
      input:
        control: Checkbox
        labels:
          1: Wages and salaries
          2: Income from self-employment
          4: Dividends and interest
          8: Employment insurance
          16: Worker's compensation
          32: Benefits from Canada or Quebec Pension Plan
          64: Retirement pensions, superannuation and annuities
          128: Old Age Security and Guaranteed Income Supplement
          256: Child Tax Benefit
          512: Provincial or municipal social assistance or welfare
          1024: Child support
          2048: Alimony
          4096: Other
          8192: None
      codeBlock: |
        # Count bits set to determine if multiple sources
        count = 0
        for i in range(13):
            if q_inc_q1.outcome % (2 * (2 ** i)) >= (2 ** i):
                count = count + 1
        income_source_count = count
    - id: q_inc_q2
      kind: Question
      title: What was the main source of income?
      precondition:
      - predicate: income_source_count >= 2
      input:
        control: Dropdown
        labels:
          1: Wages and salaries
          2: Income from self-employment
          3: Dividends and interest
          4: Employment insurance
          5: Worker's compensation
          6: Benefits from Canada or Quebec Pension Plan
          7: Retirement pensions, superannuation and annuities
          8: Old Age Security and Guaranteed Income Supplement
          9: Child Tax Benefit
          10: Provincial or municipal social assistance or welfare
          11: Child support
          12: Alimony
          13: Other
  - id: b_household_income
    title: Household Income Amount
    precondition:
    - predicate: q_inc_q1.outcome % 16384 < 8192
    items:
    - id: q_inc_q3
      kind: Question
      title: What is your best estimate of the total income, before taxes and deductions, of all household members from all
        sources in the past 12 months?
      postcondition:
      - predicate: q_inc_q3.outcome <= 150000
        hint: 'Warning: income over $150,000 reported. Please confirm.'
      input:
        control: Editbox
        min: 0
        max: 500000
        left: $
      codeBlock: |
        if q_inc_q3.outcome > 0:
            hh_income_given = 1
    - id: q_inc_q3a
      kind: Question
      title: Can you estimate in which of the following groups your household income falls? Was the total household income
        less than $20,000 or $20,000 or more?
      precondition:
      - predicate: hh_income_given == 0
      input:
        control: Radio
        labels:
          1: Less than $20,000
          2: $20,000 or more
          3: No income
    - id: q_inc_q3b
      kind: Question
      title: Was the total household income from all sources less than $10,000 or $10,000 or more?
      precondition:
      - predicate: hh_income_given == 0
      - predicate: q_inc_q3a.outcome == 1
      input:
        control: Radio
        labels:
          1: Less than $10,000
          2: $10,000 or more
    - id: q_inc_q3c
      kind: Question
      title: Was the total household income from all sources less than $5,000 or $5,000 or more?
      precondition:
      - predicate: hh_income_given == 0
      - predicate: q_inc_q3a.outcome == 1
      - predicate: q_inc_q3b.outcome == 1
      input:
        control: Radio
        labels:
          1: Less than $5,000
          2: $5,000 or more
    - id: q_inc_q3d
      kind: Question
      title: Was the total household income from all sources less than $15,000 or $15,000 or more?
      precondition:
      - predicate: hh_income_given == 0
      - predicate: q_inc_q3a.outcome == 1
      - predicate: q_inc_q3b.outcome == 2
      input:
        control: Radio
        labels:
          1: Less than $15,000
          2: $15,000 or more
    - id: q_inc_q3e
      kind: Question
      title: Was the total household income from all sources less than $40,000 or $40,000 or more?
      precondition:
      - predicate: hh_income_given == 0
      - predicate: q_inc_q3a.outcome == 2
      input:
        control: Radio
        labels:
          1: Less than $40,000
          2: $40,000 or more
    - id: q_inc_q3f
      kind: Question
      title: Was the total household income from all sources less than $30,000 or $30,000 or more?
      precondition:
      - predicate: hh_income_given == 0
      - predicate: q_inc_q3a.outcome == 2
      - predicate: q_inc_q3e.outcome == 1
      input:
        control: Radio
        labels:
          1: Less than $30,000
          2: $30,000 or more
    - id: q_inc_q3g
      kind: Question
      title: 'Was the total household income from all sources:'
      precondition:
      - predicate: hh_income_given == 0
      - predicate: q_inc_q3a.outcome == 2
      - predicate: q_inc_q3e.outcome == 2
      input:
        control: Radio
        labels:
          1: Less than $50,000
          2: $50,000 to less than $60,000
          3: $60,000 to less than $80,000
          4: $80,000 to less than $100,000
          5: $100,000 or more
  - id: b_personal_income
    title: Personal Income
    precondition:
    - predicate: age >= 15
    items:
    - id: q_inc_q4
      kind: Question
      title: What is your best estimate of your total personal income, before taxes and other deductions, from all sources
        in the past 12 months?
      postcondition:
      - predicate: q_inc_q4.outcome <= 150000
        hint: 'Warning: personal income over $150,000 reported. Please confirm.'
      input:
        control: Editbox
        min: 0
        max: 500000
        left: $
    - id: q_inc_q4_dk
      kind: Question
      title: Were you able to provide an exact amount above?
      input:
        control: Switch
        false: No, estimate in brackets
        true: Yes, amount was provided
    - id: q_inc_q4a
      kind: Question
      title: Can you estimate in which of the following groups your personal income falls? Was your total personal income
        less than $20,000 or $20,000 or more?
      precondition:
      - predicate: q_inc_q4_dk.outcome == 0
      input:
        control: Radio
        labels:
          1: Less than $20,000
          2: $20,000 or more
          3: No income
    - id: q_inc_q4b
      kind: Question
      title: Was your total personal income less than $10,000 or $10,000 or more?
      precondition:
      - predicate: q_inc_q4_dk.outcome == 0
      - predicate: q_inc_q4a.outcome == 1
      input:
        control: Radio
        labels:
          1: Less than $10,000
          2: $10,000 or more
    - id: q_inc_q4c
      kind: Question
      title: Was your total personal income less than $5,000 or $5,000 or more?
      precondition:
      - predicate: q_inc_q4_dk.outcome == 0
      - predicate: q_inc_q4a.outcome == 1
      - predicate: q_inc_q4b.outcome == 1
      input:
        control: Radio
        labels:
          1: Less than $5,000
          2: $5,000 or more
    - id: q_inc_q4d
      kind: Question
      title: Was your total personal income less than $15,000 or $15,000 or more?
      precondition:
      - predicate: q_inc_q4_dk.outcome == 0
      - predicate: q_inc_q4a.outcome == 1
      - predicate: q_inc_q4b.outcome == 2
      input:
        control: Radio
        labels:
          1: Less than $15,000
          2: $15,000 or more
    - id: q_inc_q4e
      kind: Question
      title: Was your total personal income less than $40,000 or $40,000 or more?
      precondition:
      - predicate: q_inc_q4_dk.outcome == 0
      - predicate: q_inc_q4a.outcome == 2
      input:
        control: Radio
        labels:
          1: Less than $40,000
          2: $40,000 or more
    - id: q_inc_q4f
      kind: Question
      title: Was your total personal income less than $30,000 or $30,000 or more?
      precondition:
      - predicate: q_inc_q4_dk.outcome == 0
      - predicate: q_inc_q4a.outcome == 2
      - predicate: q_inc_q4e.outcome == 1
      input:
        control: Radio
        labels:
          1: Less than $30,000
          2: $30,000 or more
    - id: q_inc_q4g
      kind: Question
      title: 'Was your total personal income:'
      precondition:
      - predicate: q_inc_q4_dk.outcome == 0
      - predicate: q_inc_q4a.outcome == 2
      - predicate: q_inc_q4e.outcome == 2
      input:
        control: Radio
        labels:
          1: Less than $50,000
          2: $50,000 to less than $60,000
          3: $60,000 to less than $80,000
          4: $80,000 to less than $100,000
          5: $100,000 or more
  - id: b_food_overview
    title: Food Situation Overview
    items:
    - id: q_fsc_r010
      kind: Comment
      title: The following questions are about the food situation for your household in the past 12 months.
    - id: q_fsc_q010
      kind: Question
      title: Which of the following statements best describes the food eaten in your household in the past 12 months?
      input:
        control: Radio
        labels:
          1: Always had enough of the kinds of food you wanted to eat
          2: Had enough to eat, but not always the kinds of food you wanted
          3: Sometimes did not have enough to eat
          4: Often didn't have enough to eat
    - id: q_fsc_r020
      kind: Comment
      title: Now I'm going to read you several statements that may be used to describe the food situation for a household.
        For each statement, please tell me if the statement was often true, sometimes true, or never true for your household
        in the past 12 months.
    - id: q_fsc_q020
      kind: Question
      title: You worried that food would run out before you got money to buy more. Was that often true, sometimes true, or
        never true in the past 12 months?
      input:
        control: Radio
        labels:
          1: Often true
          2: Sometimes true
          3: Never true
    - id: q_fsc_q030
      kind: Question
      title: The food that you bought just didn't last, and there wasn't any money to get more. Was that often true, sometimes
        true, or never true in the past 12 months?
      input:
        control: Radio
        labels:
          1: Often true
          2: Sometimes true
          3: Never true
    - id: q_fsc_q040
      kind: Question
      title: You couldn't afford to eat balanced meals. In the past 12 months was that often true, sometimes true, or never
        true?
      input:
        control: Radio
        labels:
          1: Often true
          2: Sometimes true
          3: Never true
      codeBlock: |
        if q_fsc_q020.outcome in [1, 2] or q_fsc_q030.outcome in [1, 2] or q_fsc_q040.outcome in [1, 2]:
            food_insecurity = 1
  - id: b_child_food
    title: Child Food Situation
    precondition:
    - predicate: has_children == 1
    items:
    - id: q_fsc_r050
      kind: Comment
      title: Now I'm going to read a few statements that may describe the food situation for households with children.
    - id: q_fsc_q050
      kind: Question
      title: You relied on only a few kinds of low-cost food to feed the children because you were running out of money to
        buy food. Was that often true, sometimes true, or never true in the past 12 months?
      input:
        control: Radio
        labels:
          1: Often true
          2: Sometimes true
          3: Never true
    - id: q_fsc_q060
      kind: Question
      title: You couldn't feed the children a balanced meal, because you couldn't afford it. Was that often true, sometimes
        true, or never true in the past 12 months?
      input:
        control: Radio
        labels:
          1: Often true
          2: Sometimes true
          3: Never true
    - id: q_fsc_q070
      kind: Question
      title: The children were not eating enough because you just couldn't afford enough food. Was that often true, sometimes
        true, or never true in the past 12 months?
      precondition:
      - predicate: food_insecurity == 1
      input:
        control: Radio
        labels:
          1: Often true
          2: Sometimes true
          3: Never true
  - id: b_adult_food_detail
    title: Adult Food Insecurity Details
    precondition:
    - predicate: food_insecurity == 1
    items:
    - id: q_fsc_r080
      kind: Comment
      title: The following few questions are about the food situation in the past 12 months for you or any other adults in
        your household.
    - id: q_fsc_q080
      kind: Question
      title: In the past 12 months, did you ever cut the size of your meals or skip meals because there wasn't enough money
        for food?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_fsc_q081
      kind: Question
      title: How often did this happen?
      precondition:
      - predicate: q_fsc_q080.outcome == 1
      input:
        control: Radio
        labels:
          1: Almost every month
          2: Some months but not every month
          3: Only 1 or 2 months
    - id: q_fsc_q090
      kind: Question
      title: In the past 12 months, did you ever eat less than you felt you should because there wasn't enough money to buy
        food?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_fsc_q100
      kind: Question
      title: In the past 12 months, were you ever hungry but didn't eat because you couldn't afford enough food?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_fsc_q110
      kind: Question
      title: In the past 12 months, did you lose weight because you didn't have enough money for food?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_fsc_q120
      kind: Question
      title: In the past 12 months, did you ever not eat for a whole day because there wasn't enough money for food?
      precondition:
      - predicate: q_fsc_q080.outcome == 1 or q_fsc_q090.outcome == 1 or q_fsc_q100.outcome == 1 or q_fsc_q110.outcome ==
          1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_fsc_q121
      kind: Question
      title: How often did this happen?
      precondition:
      - predicate: q_fsc_q080.outcome == 1 or q_fsc_q090.outcome == 1 or q_fsc_q100.outcome == 1 or q_fsc_q110.outcome ==
          1
      - predicate: q_fsc_q120.outcome == 1
      input:
        control: Radio
        labels:
          1: Almost every month
          2: Some months but not every month
          3: Only 1 or 2 months
  - id: b_child_food_detail
    title: Child Food Insecurity Details
    precondition:
    - predicate: has_children == 1
    - predicate: food_insecurity == 1
    items:
    - id: q_fsc_r130
      kind: Comment
      title: Now, a few questions on the food experiences for children in your household.
    - id: q_fsc_q130
      kind: Question
      title: In the past 12 months, did you ever cut the size of any of the children's meals because there wasn't enough money
        for food?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_fsc_q140
      kind: Question
      title: In the past 12 months, did any of the children ever skip meals because there wasn't enough money for food?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_fsc_q141
      kind: Question
      title: How often did this happen?
      precondition:
      - predicate: q_fsc_q140.outcome == 1
      input:
        control: Radio
        labels:
          1: Almost every month
          2: Some months but not every month
          3: Only 1 or 2 months
    - id: q_fsc_q150
      kind: Question
      title: In the past 12 months, were any of the children ever hungry but you just couldn't afford more food?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_fsc_q160
      kind: Question
      title: In the past 12 months, did any of the children ever not eat for a whole day because there wasn't enough money
        for food?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
  - id: b_dwelling
    title: Dwelling Characteristics
    items:
    - id: q_dwl_r01
      kind: Comment
      title: Now a few questions about your dwelling.
    - id: q_dwl_q01
      kind: Question
      title: 'What type of dwelling do you live in? Is it a:'
      input:
        control: Dropdown
        labels:
          1: Single detached
          2: Double (semi-detached)
          3: Row or terrace
          4: Duplex
          5: Low-rise apartment (fewer than 5 stories) or a flat
          6: High-rise apartment (5 stories or more)
          7: Institution
          8: Hotel, rooming/lodging house, camp
          9: Mobile home
          10: Other
    - id: q_dwl_q01s
      kind: Question
      title: 'INTERVIEWER: Specify the dwelling type.'
      precondition:
      - predicate: q_dwl_q01.outcome == 10
      input:
        control: Textarea
        placeholder: Specify dwelling type...
        maxLength: 200
    - id: q_dwl_q02
      kind: Question
      title: How many bedrooms are there in this dwelling?
      postcondition:
      - predicate: q_dwl_q02.outcome <= 10
        hint: 'Warning: more than 10 bedrooms reported. Please confirm.'
      input:
        control: Editbox
        min: 0
        max: 20
        right: bedrooms
    - id: q_dwl_q03
      kind: Question
      title: Is this dwelling owned by a member of this household?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
