qmlVersion: "1.0"
questionnaire:
  title: "NLSCY Children and Youth - Literacy (LIT)"
  codeInit: |
    # Variables READ from prior sections
    child_age = 0           # child's age in years (0-11)
    child_age_months = 0    # child's age in months (0-143)

  blocks:
    # =========================================================================
    # BLOCK 1: LITERACY INTRODUCTION
    # =========================================================================
    - id: b_lit_intro
      title: "Literacy"
      items:
        # LIT-I1: Introduction
        - id: q_lit_i1
          kind: Comment
          title: "Children can show their interest in reading or sharing books in different ways. The following are some questions about books and reading."

    # =========================================================================
    # BLOCK 2: INFANT READING (AGE 0-23 MONTHS)
    # =========================================================================
    # LIT-C1: IF AGE IN MONTHS > 23 -> skip to C4 routing
    # Q1-Q3 only for infants aged 0-23 months
    # =========================================================================
    - id: b_lit_infant
      title: "Infant Reading"
      precondition:
        - predicate: child_age_months <= 23
      items:
        # LIT-Q1: Read/show books to baby
        # NO/DK/Refusal -> skip to Activities section (exit this section)
        - id: q_lit_q1
          kind: Question
          title: "Do you or another adult ever read to the child, or show him/her pictures or wordless baby books?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # LIT-Q2: How often read to baby
        # Precondition: Q1 = YES
        - id: q_lit_q2
          kind: Question
          title: "How often do you do this?"
          precondition:
            - predicate: q_lit_q1.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Rarely"
              2: "Less than once a month"
              3: "Once a month"
              4: "A few times a month"
              5: "Once a week"
              6: "A few times a week"
              7: "Daily"
              8: "Many times each day"

        # LIT-Q3: Age when started reading to baby (months)
        # Precondition: Q1 = YES
        - id: q_lit_q3
          kind: Question
          title: "How old was he/she when you started to do this (to the nearest month)?"
          precondition:
            - predicate: q_lit_q1.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 23
            right: "months"

    # =========================================================================
    # BLOCK 3: EARLY CHILDHOOD READING (AGE 2-4)
    # =========================================================================
    # LIT-C4: age 2-4 -> Q4
    # Q4 and Q5 are for children aged 2-4 only
    # =========================================================================
    - id: b_lit_early_childhood
      title: "Early Childhood Reading Habits"
      precondition:
        - predicate: child_age >= 2
        - predicate: child_age <= 4
      items:
        # LIT-Q4: Looking at books on own (age 2-4)
        - id: q_lit_q4
          kind: Question
          title: "How often does the child look at books, magazines, comics, etc. on his/her own? (Think about what he/she does at home only, do not include day care or school.)"
          input:
            control: Dropdown
            labels:
              1: "Never or rarely"
              2: "Less than once a month"
              3: "Once a month"
              4: "A few times a month"
              5: "Once a week"
              6: "A few times a week"
              7: "Daily"
              8: "Many times each day"

        # LIT-Q5: Pretend writing (age 2-4)
        - id: q_lit_q5
          kind: Question
          title: "How often does he/she play with pencils or markers doing real or pretend writing?"
          input:
            control: Dropdown
            labels:
              1: "Never or rarely"
              2: "Less than once a month"
              3: "Once a month"
              4: "A few times a month"
              5: "Once a week"
              6: "A few times a week"
              7: "Daily"
              8: "Many times each day"

    # =========================================================================
    # BLOCK 4: READ ALOUD HISTORY (AGE 2-5)
    # =========================================================================
    # Q6A is reached by ages 2-4 (sequentially after Q5) and age 5 (from C4).
    # Q6B1 follows if Q6A = YES.
    # =========================================================================
    - id: b_lit_read_aloud
      title: "Reading Aloud History"
      precondition:
        - predicate: child_age >= 2
        - predicate: child_age <= 5
      items:
        # LIT-Q6A: Ever read aloud regularly (age 2-5)
        # NO -> skip to Q8; DK -> skip to C9 routing
        - id: q_lit_q6a
          kind: Question
          title: "Have you or another adult ever read aloud to the child on a regular basis?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # LIT-Q6B1: Age when started reading aloud (months)
        # Precondition: Q6A = YES
        - id: q_lit_q6b1
          kind: Question
          title: "How old was he/she when you started (to the nearest month of age)?"
          precondition:
            - predicate: q_lit_q6a.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 71
            right: "months"

    # =========================================================================
    # BLOCK 5: CURRENT READING FREQUENCY (AGE-VARIANT ITEMS)
    # =========================================================================
    # LIT-C7A: age < 5 -> Q7; age >= 5 -> Q7A
    # LIT-Q7: age 2-4, must have answered Q6A=YES
    # LIT-Q7A: age 5-7
    # LIT-Q7B: age 8-11
    # These are mutually exclusive age-variant items measuring the same
    # construct (current adult-child reading frequency).
    # =========================================================================
    - id: b_lit_reading_freq
      title: "Current Reading Frequency"
      precondition:
        - predicate: child_age >= 2
      items:
        # LIT-Q7: Reading frequency (age 2-4, Q6A=YES)
        # From C7A: age < 5 -> Q7 (only reached if Q6A was answered YES)
        - id: q_lit_q7
          kind: Question
          title: "Currently, how often do you or another adult read to him/her? (Also include if he/she reads or pretends to read to adult.)"
          precondition:
            - predicate: child_age >= 2 and child_age <= 4
            - predicate: q_lit_q6a.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Never or rarely"
              2: "Less than once a month"
              3: "Once a month"
              4: "A few times a month"
              5: "Once a week"
              6: "A few times a week"
              7: "Daily"
              8: "Many times each day"

        # LIT-Q7A: Reading frequency (age 5-7)
        # Age 5 arrives from C7A (after Q6B1); ages 6-7 arrive from C4.
        - id: q_lit_q7a
          kind: Question
          title: "Currently, how often do you or another adult read aloud to him/her or listen to him/her read or attempt to read aloud?"
          precondition:
            - predicate: child_age >= 5 and child_age <= 7
          input:
            control: Dropdown
            labels:
              1: "Never or rarely"
              2: "Less than once a month"
              3: "Once a month"
              4: "A few times a month"
              5: "Once a week"
              6: "A few times a week"
              7: "Daily"
              8: "Many times each day"

        # LIT-Q7B: Reading frequency (age 8-11)
        # Arrives directly from C4.
        - id: q_lit_q7b
          kind: Question
          title: "Currently, how often do you or another adult read aloud to him/her or listen to him/her read?"
          precondition:
            - predicate: child_age >= 8 and child_age <= 11
          input:
            control: Dropdown
            labels:
              1: "Never or rarely"
              2: "Less than once a month"
              3: "Once a month"
              4: "A few times a month"
              5: "Once a week"
              6: "A few times a week"
              7: "Daily"
              8: "Many times each day"

    # =========================================================================
    # BLOCK 6: WRITING HELP (AGE 2-5)
    # =========================================================================
    # LIT-C8: IF AGE > 5 -> Q9; OTHERWISE -> Q8
    # Q8 is for age <= 5 only.
    # Also skipped if Q6A = NO (NO -> Q8 per inventory, but only for age 5;
    # ages 2-4 with Q6A=NO also reach Q8 via sequential flow).
    # Q8 requires age 2-5; Q6A=NO skips Q6B1/Q7 but still reaches Q8.
    # =========================================================================
    - id: b_lit_writing_help
      title: "Writing Help"
      precondition:
        - predicate: child_age >= 2
        - predicate: child_age <= 5
      items:
        # LIT-Q8: Help/encourage writing (age 2-5)
        - id: q_lit_q8
          kind: Question
          title: "How often do you help or encourage him/her to write or pretend to write?"
          input:
            control: Dropdown
            labels:
              1: "Never or rarely"
              2: "Less than once a month"
              3: "Once a month"
              4: "A few times a month"
              5: "Once a week"
              6: "A few times a week"
              7: "Daily"
              8: "Many times each day"

    # =========================================================================
    # BLOCK 7: HOMEWORK (AGE 6-11)
    # =========================================================================
    # LIT-C8: IF AGE > 5 -> Q9
    # LIT-C9: IF AGE = 2-4 -> Activities section; age 5 -> Q12
    # So Q9-Q11 are only for ages 6-11.
    # =========================================================================
    - id: b_lit_homework
      title: "Homework"
      precondition:
        - predicate: child_age >= 6
        - predicate: child_age <= 11
      items:
        # LIT-Q9: Homework frequency (age 6-11)
        # NEVER/DK -> skip Q10A-Q11, go to C12A
        - id: q_lit_q9
          kind: Question
          title: "How often is the child assigned homework?"
          input:
            control: Dropdown
            labels:
              1: "Never"
              2: "Less than once a month"
              3: "Once a month"
              4: "A few times a month"
              5: "Once a week"
              6: "A few times a week"
              7: "Daily"

        # LIT-Q10A: Homework time (age 6-11)
        # Only if homework is assigned (Q9 > 1)
        - id: q_lit_q10a
          kind: Question
          title: "On days when he/she is assigned homework, how much time does he/she usually spend doing homework?"
          precondition:
            - predicate: q_lit_q9.outcome >= 2
          input:
            control: Editbox
            min: 1
            max: 480
            right: "minutes"

        # LIT-Q11: Help with homework frequency (age 6-11)
        # Only if homework is assigned (Q9 > 1)
        - id: q_lit_q11
          kind: Question
          title: "How often do you check his/her homework or provide help with homework?"
          precondition:
            - predicate: q_lit_q9.outcome >= 2
          input:
            control: Dropdown
            labels:
              1: "Never or rarely"
              2: "Less than once a month"
              3: "Once a month"
              4: "A few times a month"
              5: "Once a week"
              6: "A few times a week"
              7: "Daily"

    # =========================================================================
    # BLOCK 8: INDEPENDENT READING & LIBRARY (AGE 5-11)
    # =========================================================================
    # LIT-C9: age 2-4 -> Activities (exit); age 5 -> Q12
    # LIT-C12A: age 6 -> Q12; age 7+ -> Q12A
    # Q12: age 5-6 (younger phrasing: "look at books or try to read")
    # Q12A: age 7-11 (older phrasing: "read for pleasure")
    # Q13-Q14: age 5-11 (all who reach this block)
    # =========================================================================
    - id: b_lit_independent_reading
      title: "Independent Reading and Library Use"
      precondition:
        - predicate: child_age >= 5
        - predicate: child_age <= 11
      items:
        # LIT-Q12: Independent reading (age 5-6)
        # Younger phrasing for children who may not yet read independently
        - id: q_lit_q12
          kind: Question
          title: "How often does the child look at books or try to read on his/her own?"
          precondition:
            - predicate: child_age >= 5 and child_age <= 6
          input:
            control: Dropdown
            labels:
              1: "Never or rarely"
              2: "Less than once a month"
              3: "Once a month"
              4: "A few times a month"
              5: "Once a week"
              6: "A few times a week"
              7: "Daily"
              8: "Many times each day"

        # LIT-Q12A: Reading for pleasure (age 7-11)
        # Older phrasing assumes literacy
        - id: q_lit_q12a
          kind: Question
          title: "How often does the child read for pleasure?"
          precondition:
            - predicate: child_age >= 7 and child_age <= 11
          input:
            control: Dropdown
            labels:
              1: "Never or rarely"
              2: "Less than once a month"
              3: "Once a month"
              4: "A few times a month"
              5: "Once a week"
              6: "A few times a week"
              7: "Daily"
              8: "Many times each day"

        # LIT-Q13: Discuss books (age 5-11)
        - id: q_lit_q13
          kind: Question
          title: "How often does he/she talk about a book with family or friends?"
          input:
            control: Dropdown
            labels:
              1: "Never or rarely"
              2: "Less than once a month"
              3: "Once a month"
              4: "A few times a month"
              5: "Once a week"
              6: "A few times a week"
              7: "Daily"
              8: "Many times each day"

        # LIT-Q14: Library visits (age 5-11)
        - id: q_lit_q14
          kind: Question
          title: "How often does he/she go to the library, including the school library?"
          input:
            control: Dropdown
            labels:
              1: "Never or rarely"
              2: "Less than once a month"
              3: "Once a month"
              4: "A few times a month"
              5: "Once a week"
              6: "A few times a week"
              7: "Daily"
              8: "Many times each day"
