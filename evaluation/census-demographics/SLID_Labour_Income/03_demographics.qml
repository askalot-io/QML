qmlVersion: '1.0'
questionnaire:
  title: 03 Demographics and Family Background (DEMPRE)
  codeInit: |
    # Extern variables from prior sections
    age: range(0, 120)
    sex: {1, 2}
    marital_status: {1, 2, 3, 4, 5, 6}
    current_year: range(1990, 2100)
    # Tracking variables
    current_marriage_year = 0
  blocks:
  - id: b_marital_history
    title: Marital History
    items:
    - id: q_q1a
      kind: Comment
      title: The next few questions are about the respondent's family background and are based on the date of birth and marital status reported earlier in the interview.

    # --- Separated/Divorced path (marital_status 3 or 4) ---
    - id: q_q1
      kind: Question
      title: What was the date of the respondent's separation? (Not the date of divorce, year only)
      precondition:
      - predicate: marital_status in [3, 4]
      input:
        control: Editbox
        min: 1870
        max: 2100
        right: year

    - id: q_q2
      kind: Question
      title: What was the date of this marriage? (Year only)
      precondition:
      - predicate: marital_status in [3, 4]
      postcondition:
      - predicate: q_q2.outcome <= q_q1.outcome
        hint: Date of marriage should be before date of separation.
      codeBlock: |
        current_marriage_year = q_q2.outcome
      input:
        control: Editbox
        min: 1870
        max: 2100
        right: year

    # --- Married path (marital_status 1) ---
    - id: q_q2b
      kind: Question
      title: What was the date of the respondent's marriage? (Year only)
      precondition:
      - predicate: marital_status == 1
      codeBlock: |
        current_marriage_year = q_q2b.outcome
      input:
        control: Editbox
        min: 1870
        max: 2100
        right: year

    # --- Q3: Convergence for married + separated/divorced ---
    - id: q_q3
      kind: Question
      title: Was this the respondent's first marriage?
      precondition:
      - predicate: marital_status in [1, 3, 4]
      input:
        control: Radio
        labels:
          1: "Yes"
          2: "No"

    - id: q_q4
      kind: Question
      title: What was the date of the respondent's first marriage? (Year only)
      precondition:
      - predicate: marital_status in [1, 3, 4]
      - predicate: q_q3.outcome == 2
      postcondition:
      - predicate: q_q4.outcome <= current_marriage_year
        hint: Date of first marriage should be before date of current/most recent marriage.
      input:
        control: Editbox
        min: 1870
        max: 2100
        right: year

    # --- Common-law path (marital_status 2) ---
    - id: q_q5
      kind: Question
      title: When did the respondent and his/her partner begin to live together? (Year only)
      precondition:
      - predicate: marital_status == 2
      input:
        control: Editbox
        min: 1870
        max: 2100
        right: year

    - id: q_q6
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
    - id: q_q7
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
    - id: q_q8
      kind: Question
      title: Was this the respondent's first marriage?
      precondition:
      - predicate: (marital_status == 2 and q_q6.outcome == 1) or marital_status == 5
      input:
        control: Radio
        labels:
          1: "Yes"
          2: "No"

    # --- Q9: First marriage date (for first-marriage path from Q8) ---
    # Reached when Q8=Yes (first marriage) from common-law or widowed
    - id: q_q9
      kind: Question
      title: What was the date of the respondent's marriage? (Year only)
      precondition:
      - predicate: (marital_status == 2 and q_q6.outcome == 1) or marital_status == 5
      - predicate: q_q8.outcome == 1
      postcondition:
      - predicate: marital_status != 5 or q_q9.outcome <= q_q7.outcome
        hint: Date of marriage should be before date widowed.
      - predicate: marital_status != 2 or q_q9.outcome <= q_q5.outcome
        hint: Date of marriage should be before date started living together.
      input:
        control: Editbox
        min: 1870
        max: 2100
        right: year

    # --- Q10: First marriage date (for not-first-marriage path from Q8) ---
    - id: q_q10
      kind: Question
      title: What was the date of the respondent's first marriage? (Year only)
      precondition:
      - predicate: (marital_status == 2 and q_q6.outcome == 1) or marital_status == 5
      - predicate: q_q8.outcome == 2
      postcondition:
      - predicate: marital_status != 2 or q_q10.outcome <= q_q5.outcome
        hint: Date of first marriage should be before date started living together.
      - predicate: marital_status != 5 or q_q10.outcome <= q_q7.outcome
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
    - id: q_q11
      kind: Question
      title: Has the respondent had any children?
      input:
        control: Radio
        labels:
          1: "Yes"
          2: "No"
          8: "Don't know"

    - id: q_q12
      kind: Question
      title: How many children were ever born to the respondent?
      precondition:
      - predicate: q_q11.outcome == 1
      input:
        control: Editbox
        min: 0
        max: 20
        right: children

    - id: q_q13
      kind: Question
      title: In what year did the respondent give birth to her first child?
      precondition:
      - predicate: q_q11.outcome == 1
      - predicate: q_q12.outcome >= 1
      input:
        control: Editbox
        min: 1870
        max: 2100
        right: year

    - id: q_q14
      kind: Question
      title: (Other than children the respondent has given birth to) Has the respondent adopted or raised any children?
      precondition:
      - predicate: q_q11.outcome in [1, 2]
      postcondition:
      - predicate: q_q11.outcome != 1 or q_q14.outcome != 2 or q_q12.outcome >= 1
        hint: Respondent stated she had children but none were born to her; she should have adopted or raised children.
      input:
        control: Radio
        labels:
          1: "Yes"
          2: "No"

    - id: q_q15
      kind: Question
      title: How many (other) children has the respondent adopted or raised?
      precondition:
      - predicate: q_q14.outcome == 1
      input:
        control: Editbox
        min: 1
        max: 20
        right: children

  - id: b_background
    title: Background
    items:
    - id: q_q16
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
      - predicate: q_q16.outcome == 3
      input:
        control: Textarea
        placeholder: Specify language...
        maxLength: 200

    - id: q_q17
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
      - predicate: q_q17.outcome == 7
      input:
        control: Textarea
        placeholder: Specify country...
        maxLength: 200

    - id: q_q18
      kind: Question
      title: Did the respondent immigrate to Canada?
      precondition:
      - predicate: q_q17.outcome != 1
      input:
        control: Radio
        labels:
          1: "Yes"
          2: "No (never immigrated - Canadian citizen by birth)"

    - id: q_q18b
      kind: Question
      title: In what year was that?
      precondition:
      - predicate: q_q17.outcome != 1
      - predicate: q_q18.outcome == 1
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
