qmlVersion: "1.0"
questionnaire:
  title: "NLSCY Children and Youth - Family & Custody History"
  codeInit: |
    # Variables READ from prior sections
    relationship_to_child = 0   # 1=PMK, 2=spouse/partner, 4=foster parent
    child_age = 0               # child's age in years

    # Routing variables PRODUCED by this section
    # parents_together: 1=parents living together at birth, 0=not together
    parents_together = 0
    # parents_separated: 1=parents broke up, 0=still together or N/A
    parents_separated = 0
    # parent_died: 0=none, 1=mother, 2=father, 3=both, 4=no
    parent_died = 0
    # parents_were_married: 1=parents were married, 0=not
    parents_were_married = 0
    # mother_new_union: 1=mother entered new relationship, 0=no
    mother_new_union = 0
    # father_new_union: 1=father entered new relationship, 0=no
    father_new_union = 0
    # child_lived_with_respondent: 1=yes at birth, 0=no
    child_lived_with_respondent = 0
    # custody_type: 0=none, 1=mother sole, 2=father sole, 3=shared
    custody_type = 0
    # parents_lived_together_ever: 1=yes, 0=no
    parents_lived_together_ever = 0

  blocks:
    # =========================================================================
    # BLOCK 1: SECTION GATE AND LIVING ARRANGEMENT AT BIRTH
    # =========================================================================
    # CUS-C1: Foster parents skip entire section; PMK/spouse continue.
    # CUS-I1: Intro
    # CUS-Q1A: Did child live with you at birth?
    # CUS-Q1B: Age child started living with you
    # CUS-Q1B2: Age in months (if < 1 year)
    # CUS-Q1C: Reason child didn't live with you from birth
    # CUS-Q1D: Siblings not in household?
    # CUS-Q1E: How many siblings outside household?
    # CUS-Q1F: Age of youngest sibling
    # CUS-Q1G: Age of oldest sibling (if >1 sibling)
    # =========================================================================
    - id: b_living_arrangement
      title: "Living Arrangement at Birth"
      precondition:
        - predicate: relationship_to_child != 4
      items:
        # CUS-I1: Section intro
        - id: q_cus_i1
          kind: Comment
          title: "I would now like to ask you some questions about the family history of the child."

        # CUS-Q1A: Did child live with you at birth?
        - id: q_cus_q1a
          kind: Question
          title: "Did the child live with you when he/she was born?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
          codeBlock: |
            if q_cus_q1a.outcome == 1:
                child_lived_with_respondent = 1

        # CUS-Q1B: Age started living with respondent
        # Shown only when child did NOT live with respondent at birth
        - id: q_cus_q1b
          kind: Question
          title: "At what age did the child start living with you?"
          precondition:
            - predicate: q_cus_q1a.outcome == 2
          input:
            control: Dropdown
            labels:
              1: "Less than one year old"
              2: "One year old"
              3: "Two years old"
              4: "Three years old"
              5: "Four years old"
              6: "Five years old"
              7: "Six years old"
              8: "Seven years old"
              9: "Eight years old"
              10: "Nine years old"
              11: "Ten years old"
              12: "Eleven years old"

        # CUS-Q1B2: Age in months if less than one year
        - id: q_cus_q1b2
          kind: Question
          title: "Enter the age in months."
          precondition:
            - predicate: q_cus_q1a.outcome == 2
            - predicate: q_cus_q1b.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 11
            right: "months"

        # CUS-Q1C: Reason child didn't live with respondent from birth
        - id: q_cus_q1c
          kind: Question
          title: "What was the reason the child did not live with you right from birth?"
          precondition:
            - predicate: q_cus_q1a.outcome == 2
          input:
            control: Dropdown
            labels:
              1: "You have adopted him/her"
              2: "He/she is a stepchild"
              3: "He/she was put in your care by a child welfare agency (foster care)"
              4: "He/she was put in your care by another type of agency"
              5: "He/she was sick and had to remain in a hospital or other institution"
              6: "You had to leave him/her in the care of someone else for a while"
              7: "Child was in care of a child welfare agency (foster care) for a time"
              8: "Other"

        # CUS-Q1D: Siblings not regularly in household?
        - id: q_cus_q1d
          kind: Question
          title: "Does the child have any brothers or sisters who do not regularly live in this household, excluding step and half brothers and sisters?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # CUS-Q1E: How many siblings outside household
        - id: q_cus_q1e
          kind: Question
          title: "How many?"
          precondition:
            - predicate: q_cus_q1d.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 20

        # CUS-Q1F: Age of youngest sibling
        - id: q_cus_q1f
          kind: Question
          title: "What is the age of the youngest one? (Enter age in years. If less than one year, enter 0.)"
          precondition:
            - predicate: q_cus_q1d.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 30
            right: "years"

        # CUS-Q1G: Age of oldest sibling (if more than one)
        - id: q_cus_q1g
          kind: Question
          title: "What is the age of the oldest one? (Enter age in years. If less than one year, enter 0.)"
          precondition:
            - predicate: q_cus_q1d.outcome == 1
            - predicate: q_cus_q1e.outcome >= 2
          input:
            control: Editbox
            min: 0
            max: 30
            right: "years"

    # =========================================================================
    # BLOCK 2: PARENTS' UNION DETAILS (Q2-Q3D)
    # =========================================================================
    # CUS-I2: Interviewer note about adoption wording
    # CUS-Q2: Were parents living together at birth?
    # CUS-Q3A: Type of union (married, common-law, etc.)
    # CUS-Q3B: Were they living together before marriage?
    # CUS-Q3C: Date of marriage
    # CUS-Q3D: Since when living together?
    # =========================================================================
    - id: b_parents_union
      title: "Parents' Union at Birth"
      precondition:
        - predicate: relationship_to_child != 4
      items:
        # CUS-I2: Interviewer instruction about adoption wording
        - id: q_cus_i2
          kind: Comment
          title: "If adopted, consider adoptive parents as mother and father for the rest of this section. In questions referring to the time of birth, substitute time of adoption."

        # CUS-Q2: Were parents living together at birth?
        - id: q_cus_q2
          kind: Question
          title: "When the child was born/adopted, were his/her parents (biological/adoptive) living together?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
          codeBlock: |
            if q_cus_q2.outcome == 1:
                parents_together = 1

        # CUS-Q3A: Type of union at birth
        # Only if parents WERE together
        - id: q_cus_q3a
          kind: Question
          title: "When the child was born/adopted, were his/her parents married, were they living together in a common-law relationship, or were they living together and eventually got married?"
          precondition:
            - predicate: q_cus_q2.outcome == 1
          input:
            control: Radio
            labels:
              1: "Married"
              2: "Common-law"
              3: "Common-law but married later"
          codeBlock: |
            if q_cus_q3a.outcome in [1, 3]:
                parents_were_married = 1

        # CUS-Q3B: Had they been living together before getting married?
        # Only if married (Q3A=1)
        - id: q_cus_q3b
          kind: Question
          title: "Had they been living together before getting married?"
          precondition:
            - predicate: q_cus_q2.outcome == 1
            - predicate: q_cus_q3a.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # CUS-Q3C: Date of marriage
        # Shown if common-law but married later (Q3A=3)
        - id: q_cus_q3c
          kind: Question
          title: "What year were they married?"
          precondition:
            - predicate: q_cus_q2.outcome == 1
            - predicate: q_cus_q3a.outcome == 3
          input:
            control: Editbox
            min: 1950
            max: 2010
            right: "year"

        # CUS-Q3D: Since when living together?
        # Shown if common-law (Q3A=2), or common-law married later (Q3A=3),
        # or married but lived together first (Q3A=1, Q3B=1)
        - id: q_cus_q3d
          kind: Question
          title: "Approximately since when had they been living together? (Enter year.)"
          precondition:
            - predicate: q_cus_q2.outcome == 1
            - predicate: q_cus_q3a.outcome == 2 or q_cus_q3a.outcome == 3 or (q_cus_q3a.outcome == 1 and q_cus_q3b.outcome == 1)
          input:
            control: Editbox
            min: 1950
            max: 2010
            right: "year"

    # =========================================================================
    # BLOCK 3: PARENTS NOT TOGETHER PATH (Q4-Q5F)
    # =========================================================================
    # CUS-Q4: Who did child live with?
    # CUS-Q5A: Have parents ever lived together?
    # CUS-Q5B: Before or after birth?
    # CUS-Q5C: Were parents ever married?
    # CUS-Q5D: When did they marry?
    # CUS-Q5E: Since when had parents stopped living together at birth?
    # CUS-Q5F: Steady relationship at birth?
    # =========================================================================
    - id: b_parents_not_together
      title: "Parents Not Living Together"
      precondition:
        - predicate: relationship_to_child != 4
        - predicate: q_cus_q2.outcome == 2
      items:
        # CUS-Q4: Who did child live with?
        - id: q_cus_q4
          kind: Question
          title: "Did the child live with his/her:"
          input:
            control: Radio
            labels:
              1: "Mother alone"
              2: "Father alone"
              3: "Mother and other"
              4: "Father and other"
              5: "Other"

        # CUS-Q5A: Have parents ever lived together?
        - id: q_cus_q5a
          kind: Question
          title: "Have the child's parents ever lived together as a couple?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
          codeBlock: |
            if q_cus_q5a.outcome == 1:
                parents_lived_together_ever = 1

        # CUS-Q5B: Before or after birth?
        - id: q_cus_q5b
          kind: Question
          title: "Was that before or after his/her birth?"
          precondition:
            - predicate: q_cus_q5a.outcome == 1
          input:
            control: Radio
            labels:
              1: "Before"
              2: "After"
              3: "Both before and after"

        # CUS-Q5C: Were parents ever married?
        - id: q_cus_q5c
          kind: Question
          title: "Were the child's parents ever married?"
          precondition:
            - predicate: q_cus_q5a.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
          codeBlock: |
            if q_cus_q5c.outcome == 1:
                parents_were_married = 1

        # CUS-Q5D: When did they marry?
        - id: q_cus_q5d
          kind: Question
          title: "When did they marry? (Enter year.)"
          precondition:
            - predicate: q_cus_q5a.outcome == 1
            - predicate: q_cus_q5c.outcome == 1
          input:
            control: Editbox
            min: 1950
            max: 2010
            right: "year"

        # CUS-Q5E: Since when had parents stopped living together?
        # Shown if parents lived together BEFORE birth (Q5B=1 or Q5B=3)
        # CUS-C5E: IF "AFTER" (Q5B=2) -> skip to Q5F
        - id: q_cus_q5e
          kind: Question
          title: "At the time the child was born, since when had his/her parents stopped living together? (Enter year.)"
          precondition:
            - predicate: q_cus_q5a.outcome == 1
            - predicate: q_cus_q5b.outcome in [1, 3]
          input:
            control: Editbox
            min: 1950
            max: 2010
            right: "year"

        # CUS-Q5F: Steady relationship at time of birth?
        - id: q_cus_q5f
          kind: Question
          title: "Without living together, did the child's parents have a steady relationship at the time of his/her birth?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

    # =========================================================================
    # BLOCK 4: MOTHER'S PRIOR RELATIONSHIPS (Q6A-Q6I)
    # =========================================================================
    # Reached from:
    #   - Parents together path (after Q3D) -> Q6A
    #   - Parents not together, but lived together before (Q5A=1) -> Q6A via routing
    #
    # CUS-Q6A: Mother's prior unions before father?
    # CUS-Q6B: How many prior unions?
    # CUS-Q6C: Prior unions before child's birth?
    # CUS-Q6D: How many prior unions before birth?
    # CUS-Q6E: Mother's prior children before father?
    # CUS-Q6F: How many prior children?
    # CUS-Q6G: Did prior children live in household?
    # CUS-Q6H: How many children did mother have before this child?
    # CUS-Q6I: Did those children live in household?
    # =========================================================================
    - id: b_mother_prior
      title: "Mother's Prior Relationships"
      precondition:
        - predicate: relationship_to_child != 4
        - predicate: q_cus_q2.outcome == 1 or (q_cus_q2.outcome == 2 and q_cus_q5a.outcome == 1)
      items:
        # CUS-Q6A: Mother's prior unions
        - id: q_cus_q6a
          kind: Question
          title: "Had the child's mother been in any common-law relationships or been married before the union with the child's father? (Select all that apply.)"
          input:
            control: Checkbox
            labels:
              1: "Yes, common-law"
              2: "Yes, marriage"
              4: "Yes, common-law which resulted in marriage"
              8: "No"

        # CUS-Q6B: How many prior unions?
        # Shown if mother had prior unions (not "No")
        - id: q_cus_q6b
          kind: Question
          title: "How many times?"
          precondition:
            - predicate: q_cus_q6a.outcome % 8 >= 1
          input:
            control: Editbox
            min: 1
            max: 10

        # CUS-Q6C: Prior unions before child's birth?
        - id: q_cus_q6c
          kind: Question
          title: "Before the child's birth, had his/her mother been in any common-law relationships or been married to a person other than the child's father? (Select all that apply.)"
          precondition:
            - predicate: q_cus_q6a.outcome % 8 >= 1
          input:
            control: Checkbox
            labels:
              1: "Yes, common-law"
              2: "Yes, marriage"
              4: "Yes, common-law which resulted in marriage"
              8: "No"

        # CUS-Q6D: How many prior unions before birth?
        - id: q_cus_q6d
          kind: Question
          title: "How many times?"
          precondition:
            - predicate: q_cus_q6a.outcome % 8 >= 1
            - predicate: q_cus_q6c.outcome % 8 >= 1
          input:
            control: Editbox
            min: 1
            max: 10

        # CUS-Q6E: Mother's prior children before father?
        # Shown if mother had NO prior unions (Q6A has "No" bit set => Q6A % 16 >= 8)
        # OR always shown after Q6D path completes
        - id: q_cus_q6e
          kind: Question
          title: "Did the child's mother have any children before entering into union with the child's father?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # CUS-Q6F: How many prior children?
        - id: q_cus_q6f
          kind: Question
          title: "How many?"
          precondition:
            - predicate: q_cus_q6e.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 20

        # CUS-Q6G: Did prior children live in household?
        - id: q_cus_q6g
          kind: Question
          title: "Did that child/any of those children live at least part time in the household when the child was born?"
          precondition:
            - predicate: q_cus_q6e.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes, all of them full-time"
              2: "Yes, all of them part-time"
              3: "Yes, some of them full-time"
              4: "Yes, some of them part-time"
              5: "No, none of them"

        # CUS-Q6H: How many children did mother have before this child?
        # Shown if mother had prior unions before birth (Q6C has selections)
        - id: q_cus_q6h
          kind: Question
          title: "How many children did the child's mother have before the child?"
          precondition:
            - predicate: q_cus_q6a.outcome % 8 >= 1
            - predicate: q_cus_q6c.outcome % 8 >= 1
          input:
            control: Editbox
            min: 0
            max: 20

        # CUS-Q6I: Did those children live in household?
        # CUS-C6I: IF Q6H=0 AND Q5A=YES -> go to Q7C; IF Q6H=0 AND Q5A=NO -> go to Q8A
        # So Q6I shown only if Q6H > 0
        - id: q_cus_q6i
          kind: Question
          title: "Did that child/any of those children live at least part time in the household when the child was born?"
          precondition:
            - predicate: q_cus_q6a.outcome % 8 >= 1
            - predicate: q_cus_q6c.outcome % 8 >= 1
            - predicate: q_cus_q6h.outcome >= 1
          input:
            control: Radio
            labels:
              1: "Yes, all of them full-time"
              2: "Yes, all of them part-time"
              3: "Yes, some of them full-time"
              4: "Yes, some of them part-time"
              5: "No, none of them"

    # =========================================================================
    # BLOCK 5: FATHER'S PRIOR RELATIONSHIPS (Q7A-Q7I)
    # =========================================================================
    # CUS-C7A: IF Q5A=YES -> Q7C (skip Q7A/Q7B). IF Q5A=NO -> Q8A.
    # When parents were together (Q2=1): Q7A is always shown.
    # When parents not together but lived together (Q5A=1): skip to Q7C.
    # When parents never lived together (Q5A=2): skip entire block -> Q8A.
    # =========================================================================
    - id: b_father_prior
      title: "Father's Prior Relationships"
      precondition:
        - predicate: relationship_to_child != 4
        - predicate: q_cus_q2.outcome == 1 or (q_cus_q2.outcome == 2 and q_cus_q5a.outcome == 1)
      items:
        # CUS-Q7A: Father's prior unions
        # Only shown when parents were together at birth (Q2=1)
        # When Q2=2 and Q5A=1, routing skips to Q7C
        - id: q_cus_q7a
          kind: Question
          title: "Had the child's father been in any common-law relationships or been married before the union with the child's mother? (Select all that apply.)"
          precondition:
            - predicate: q_cus_q2.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "Yes, common-law"
              2: "Yes, marriage"
              4: "Yes, common-law which resulted in marriage"
              8: "No"

        # CUS-Q7B: How many prior unions?
        - id: q_cus_q7b
          kind: Question
          title: "How many times?"
          precondition:
            - predicate: q_cus_q2.outcome == 1
            - predicate: q_cus_q7a.outcome % 8 >= 1
          input:
            control: Editbox
            min: 1
            max: 10

        # CUS-Q7C: Father's prior unions before child's birth
        # Shown from either:
        #   - Parents together (Q2=1) after Q7A/Q7B path
        #   - Parents not together but lived together (Q2=2, Q5A=1) -> jump here
        - id: q_cus_q7c
          kind: Question
          title: "Before the child's birth, had his/her father been in any common-law relationships or been married to a person other than the child's mother? (Select all that apply.)"
          input:
            control: Checkbox
            labels:
              1: "Yes, common-law"
              2: "Yes, marriage"
              4: "Yes, common-law which resulted in marriage"
              8: "No"

        # CUS-Q7D: How many prior unions before birth?
        - id: q_cus_q7d
          kind: Question
          title: "How many times?"
          precondition:
            - predicate: q_cus_q7c.outcome % 8 >= 1
          input:
            control: Editbox
            min: 1
            max: 10

        # CUS-Q7E: Father's prior children before mother?
        # Only shown when parents together (Q2=1); when Q2=2 routing already handled
        - id: q_cus_q7e
          kind: Question
          title: "Did the child's father have any children before entering into union with the child's mother?"
          precondition:
            - predicate: q_cus_q2.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # CUS-Q7F: How many prior children?
        - id: q_cus_q7f
          kind: Question
          title: "How many?"
          precondition:
            - predicate: q_cus_q2.outcome == 1
            - predicate: q_cus_q7e.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 20

        # CUS-Q7G: Did prior children live in household?
        - id: q_cus_q7g
          kind: Question
          title: "Did that child/any of those children live at least part time in the household when the child was born?"
          precondition:
            - predicate: q_cus_q2.outcome == 1
            - predicate: q_cus_q7e.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes, all of them full-time"
              2: "Yes, all of them part-time"
              3: "Yes, some of them full-time"
              4: "Yes, some of them part-time"
              5: "No, none of them"

        # CUS-Q7H: How many children did father have before this child?
        - id: q_cus_q7h
          kind: Question
          title: "How many children did the child's father have before the child?"
          precondition:
            - predicate: q_cus_q7c.outcome % 8 >= 1
          input:
            control: Editbox
            min: 0
            max: 20

        # CUS-Q7I: Did those children live in household?
        # CUS-C7I: IF Q7H=0 -> Q8A. Otherwise Q7I.
        - id: q_cus_q7i
          kind: Question
          title: "Did that child/any of those children live at least part time in the household when the child was born?"
          precondition:
            - predicate: q_cus_q7c.outcome % 8 >= 1
            - predicate: q_cus_q7h.outcome >= 1
          input:
            control: Radio
            labels:
              1: "Yes, all of them full-time"
              2: "Yes, all of them part-time"
              3: "Yes, some of them full-time"
              4: "Yes, some of them part-time"
              5: "No, none of them"

    # =========================================================================
    # BLOCK 6: NON-RESIDENT PARENT CONTACT (Q8A-Q8E)
    # =========================================================================
    # Reached when parents were NOT together at birth (Q2=2).
    # CUS-Q8A: Father on birth certificate?
    # CUS-Q8B: Initial contact type with other parent
    # CUS-Q8C: How many times has contact changed?
    # CUS-Q8D: Age at last change
    # CUS-Q8E: Current contact type
    # =========================================================================
    - id: b_nonresident_contact
      title: "Non-Resident Parent Contact"
      precondition:
        - predicate: relationship_to_child != 4
        - predicate: q_cus_q2.outcome == 2
      items:
        # CUS-Q8A: Father on birth certificate?
        - id: q_cus_q8a
          kind: Question
          title: "Was the child's father declared on his/her birth certificate?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # CUS-Q8B: Initial contact type with other parent
        - id: q_cus_q8b
          kind: Question
          title: "What kind of contact did the child first have with his/her other parent?"
          input:
            control: Dropdown
            labels:
              1: "Sharing living arrangements on an equal time basis"
              2: "Sharing living arrangements with most time with mother"
              3: "Sharing living arrangements with most time with father"
              4: "Regular visiting"
              5: "Irregular visiting"
              6: "Telephone or letter contact only"
              7: "No contact at all"
              8: "Other"

        # CUS-Q8C: How many times has contact changed?
        - id: q_cus_q8c
          kind: Question
          title: "How many times would you say this situation has changed over time?"
          input:
            control: Radio
            labels:
              1: "None"
              2: "Once"
              3: "Twice"
              4: "Three times"
              5: "Four or more times"

        # CUS-Q8D: Age at last change
        - id: q_cus_q8d
          kind: Question
          title: "How old was the child when the last change happened? (Enter age in years. If less than one year, enter 0.)"
          precondition:
            - predicate: q_cus_q8c.outcome >= 2
          input:
            control: Editbox
            min: 0
            max: 18
            right: "years"

        # CUS-Q8E: Current contact type
        # Shown if contact changed (Q8C >= 2) or if Q8B was DK (modeled: always after Q8D path)
        - id: q_cus_q8e
          kind: Question
          title: "What type of contact does the child now have with his/her other parent?"
          precondition:
            - predicate: q_cus_q8c.outcome >= 2 or q_cus_q8c.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Sharing living arrangements on an equal time basis"
              2: "Sharing living arrangements with most time with mother"
              3: "Sharing living arrangements with most time with father"
              4: "Regular visiting"
              5: "Irregular visiting"
              6: "Telephone or letter contact only"
              7: "Both parents now living with the child"
              8: "No contact at all"
              9: "Other"

    # =========================================================================
    # BLOCK 7: PARENT DEATH (Q9A-Q9D)
    # =========================================================================
    # CUS-Q9A: Has a parent died? (for parents-together path)
    # CUS-Q9B: Has a parent died? (for parents-not-together path)
    # CUS-Q9C: When did it happen?
    # CUS-Q9D: With whom did child live?
    # =========================================================================
    - id: b_parent_death
      title: "Parent Death"
      precondition:
        - predicate: relationship_to_child != 4
      items:
        # CUS-Q9A: Has a parent died? (parents together at birth)
        # Reached from parents-together path (Q2=1) via mother/father prior blocks
        - id: q_cus_q9a
          kind: Question
          title: "Between the child's birth and now, has one of his/her parents died?"
          precondition:
            - predicate: q_cus_q2.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes, mother"
              2: "Yes, father"
              3: "Yes, both"
              4: "No"
          codeBlock: |
            if q_cus_q9a.outcome in [1, 2, 3]:
                parent_died = q_cus_q9a.outcome
            elif q_cus_q9a.outcome == 4:
                parent_died = 4

        # CUS-Q9B: Has a parent died? (parents not together, after non-resident contact)
        - id: q_cus_q9b
          kind: Question
          title: "Has one of the child's parents died?"
          precondition:
            - predicate: q_cus_q2.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes, mother"
              2: "Yes, father"
              3: "Yes, both"
              4: "No"
          codeBlock: |
            if q_cus_q9b.outcome in [1, 2, 3]:
                parent_died = q_cus_q9b.outcome
            elif q_cus_q9b.outcome == 4:
                parent_died = 4

        # CUS-Q9C: When did it happen?
        - id: q_cus_q9c
          kind: Question
          title: "When did it happen? (If both, enter date of first death. Enter year.)"
          precondition:
            - predicate: parent_died in [1, 2, 3]
          input:
            control: Editbox
            min: 1950
            max: 2010
            right: "year"

        # CUS-Q9D: With whom did child live?
        - id: q_cus_q9d
          kind: Question
          title: "With whom did the child go on living at the time it happened?"
          precondition:
            - predicate: parent_died in [1, 2, 3]
          input:
            control: Radio
            labels:
              1: "Mother"
              2: "Father"
              3: "Other"

    # =========================================================================
    # BLOCK 8: SEPARATION DETAILS (Q10A-Q11H)
    # =========================================================================
    # CUS-C10 routing (simplified):
    #   - Both parents died -> exit section
    #   - Parents not together (Q2=2) and never lived together (Q5A=2) -> skip to new unions
    #   - One parent died and parents had lived together -> Q10A
    #   - Otherwise -> Q10B
    #
    # CUS-Q10A: Prior to death, did parents break up?
    # CUS-Q10B: Since birth, did parents break up?
    # CUS-Q11A-Q11H: Separation/divorce details, custody orders, support
    # =========================================================================
    - id: b_separation
      title: "Separation Details"
      precondition:
        - predicate: relationship_to_child != 4
        - predicate: parent_died != 3
      items:
        # CUS-Q10A: Prior to death, did parents break up?
        # Shown when one parent died and parents had lived together
        - id: q_cus_q10a
          kind: Question
          title: "Prior to the death of the child's parent, did his/her parents break up and stop living together?"
          precondition:
            - predicate: parent_died in [1, 2]
            - predicate: q_cus_q2.outcome == 1 or parents_lived_together_ever == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # CUS-Q10B: Since birth, did parents break up?
        # Shown when no parent died (parent_died=4) and parents were together (Q2=1)
        - id: q_cus_q10b
          kind: Question
          title: "Since the child's birth, did his/her parents break up and stop living together?"
          precondition:
            - predicate: parent_died == 4
            - predicate: q_cus_q2.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
          codeBlock: |
            if q_cus_q10b.outcome == 1:
                parents_separated = 1

        # CUS-Q11A: When did the separation happen?
        # Shown if parents separated (Q10A=1 or Q10B=1)
        - id: q_cus_q11a
          kind: Question
          title: "When did the separation happen? (Enter year.)"
          precondition:
            - predicate: q_cus_q10a.outcome == 1 or q_cus_q10b.outcome == 1
          input:
            control: Editbox
            min: 1950
            max: 2010
            right: "year"

        # CUS-Q11B: Did parents eventually divorce?
        # CUS-C11B: Shown if parents were married
        - id: q_cus_q11b
          kind: Question
          title: "Did the child's parents eventually divorce?"
          precondition:
            - predicate: q_cus_q10a.outcome == 1 or q_cus_q10b.outcome == 1
            - predicate: parents_were_married == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # CUS-Q11C: When was the divorce pronounced?
        - id: q_cus_q11c
          kind: Question
          title: "When was the divorce pronounced? (Enter year.)"
          precondition:
            - predicate: q_cus_q10a.outcome == 1 or q_cus_q10b.outcome == 1
            - predicate: parents_were_married == 1
            - predicate: q_cus_q11b.outcome == 1
          input:
            control: Editbox
            min: 1950
            max: 2010
            right: "year"

        # CUS-Q11D: Court order concerning custody?
        - id: q_cus_q11d
          kind: Question
          title: "Was there a court order concerning the child's custody when his/her parents separated or divorced?"
          precondition:
            - predicate: q_cus_q10a.outcome == 1 or q_cus_q10b.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "Yes, in progress"
              3: "No"

        # CUS-Q11E: What did the court order?
        - id: q_cus_q11e
          kind: Question
          title: "Did the court order him/her to be put into:"
          precondition:
            - predicate: q_cus_q10a.outcome == 1 or q_cus_q10b.outcome == 1
            - predicate: q_cus_q11d.outcome == 1
          input:
            control: Radio
            labels:
              1: "Sole custody of mother"
              2: "Sole custody of father"
              3: "Shared physical custody of both parents"
              4: "Other"
          codeBlock: |
            if q_cus_q11e.outcome == 1:
                custody_type = 1
            elif q_cus_q11e.outcome == 2:
                custody_type = 2
            elif q_cus_q11e.outcome == 3:
                custody_type = 3

        # CUS-Q11F: Support/maintenance agreement type
        - id: q_cus_q11f
          kind: Question
          title: "What type of agreement was made regarding support/maintenance payments when the child's parents separated or divorced?"
          precondition:
            - predicate: q_cus_q10a.outcome == 1 or q_cus_q10b.outcome == 1
          input:
            control: Radio
            labels:
              1: "None"
              2: "Private agreement between spouses"
              3: "Court-ordered agreement in progress"
              4: "Court-ordered agreement"

        # CUS-Q11G: For child support, spousal support, or both?
        - id: q_cus_q11g
          kind: Question
          title: "Was this:"
          precondition:
            - predicate: q_cus_q10a.outcome == 1 or q_cus_q10b.outcome == 1
            - predicate: q_cus_q11f.outcome == 4
          input:
            control: Radio
            labels:
              1: "For child support only"
              2: "For spousal support only"
              3: "For both"

        # CUS-Q11H: How regular have payments been?
        - id: q_cus_q11h
          kind: Question
          title: "How regular have the maintenance support payments been?"
          precondition:
            - predicate: q_cus_q10a.outcome == 1 or q_cus_q10b.outcome == 1
            - predicate: q_cus_q11f.outcome == 4
          input:
            control: Dropdown
            labels:
              1: "Regular and on time"
              2: "Regular but late sometimes"
              3: "Irregular"
              4: "No payments for the last 6 months"
              5: "No payments for the last year"
              6: "No payments for the last few years"
              7: "Payments never been received"
              8: "Payments stopped due to a change in circumstances"

    # =========================================================================
    # BLOCK 9: POST-SEPARATION CUSTODY AND LIVING ARRANGEMENTS (Q12-Q18B)
    # =========================================================================
    # CUS-C12: IF Q11E=1 or 2 (sole custody) -> Q13. Otherwise -> Q12.
    # CUS-Q12: With whom did child live at separation?
    # CUS-Q13: Contact type with other parent
    # CUS-Q14: Times contact changed
    # CUS-Q15A: Current contact type
    # CUS-Q15B: Time at other parent's home
    # CUS-Q16: Time at other parent's home (shared custody)
    # CUS-Q17: Times living arrangements changed
    # CUS-Q18A: Current living arrangement
    # CUS-Q18B: Current contact type (if visits only)
    # =========================================================================
    - id: b_post_separation_custody
      title: "Post-Separation Custody"
      precondition:
        - predicate: relationship_to_child != 4
        - predicate: q_cus_q10a.outcome == 1 or q_cus_q10b.outcome == 1
      items:
        # CUS-Q12: With whom did child live at separation?
        # CUS-C12: Shown only if NOT sole custody (Q11E != 1 and Q11E != 2)
        # or if no court order (Q11D != 1)
        - id: q_cus_q12
          kind: Question
          title: "With whom did the child go on living at the time of the separation?"
          precondition:
            - predicate: custody_type != 1 and custody_type != 2
          input:
            control: Radio
            labels:
              1: "Mother only"
              2: "Father only"
              3: "Shared time basis, mostly mother"
              4: "Shared time basis, mostly father"
              5: "Equally shared time mother and father"
              6: "Other"

        # CUS-Q13: Initial contact type with other parent
        # Shown when child in sole custody (Q12=1 or 2, or Q11E=1 or 2)
        - id: q_cus_q13
          kind: Question
          title: "At that time, what type of contact did the child have with his/her other parent?"
          precondition:
            - predicate: custody_type in [1, 2] or q_cus_q12.outcome in [1, 2]
          input:
            control: Dropdown
            labels:
              1: "Regular visiting every week"
              2: "Regular visiting every two weeks"
              3: "Regular visiting monthly"
              4: "Irregular visiting on holidays only"
              5: "Irregular visiting without set pattern"
              6: "Telephone or letter contact only"
              7: "No contact at all"
              8: "Other"

        # CUS-Q14: Times contact has changed
        - id: q_cus_q14
          kind: Question
          title: "Since then, how many times has the type of contact changed?"
          precondition:
            - predicate: custody_type in [1, 2] or q_cus_q12.outcome in [1, 2]
          input:
            control: Radio
            labels:
              1: "None"
              2: "Once"
              3: "Twice"
              4: "Three times"
              5: "Four or more times"

        # CUS-Q15A: Current contact type with other parent
        # CUS-C15A: If a parent died -> skip to Q19A. Otherwise show.
        # Shown if contact changed (Q14 >= 2) and no parent died
        - id: q_cus_q15a
          kind: Question
          title: "What type of contact does the child now have with his/her other parent?"
          precondition:
            - predicate: custody_type in [1, 2] or q_cus_q12.outcome in [1, 2]
            - predicate: q_cus_q14.outcome >= 2
            - predicate: parent_died == 4
          input:
            control: Dropdown
            labels:
              1: "Regular visiting every week"
              2: "Regular visiting every two weeks"
              3: "Regular visiting monthly"
              4: "Irregular visiting on holidays only"
              5: "Irregular visiting without set pattern"
              6: "Telephone or letter contact only"
              7: "Lost contact completely"
              8: "Child now shares living arrangements with other parent"
              9: "Parents now living together again"
              10: "Child now lives solely with other parent"

        # CUS-Q15B: Time at other parent's home
        # Shown if Q15A=8 (shares living arrangements with other parent)
        - id: q_cus_q15b
          kind: Question
          title: "How much time does the child live at his/her other parent's home?"
          precondition:
            - predicate: custody_type in [1, 2] or q_cus_q12.outcome in [1, 2]
            - predicate: q_cus_q14.outcome >= 2
            - predicate: parent_died == 4
            - predicate: q_cus_q15a.outcome == 8
          input:
            control: Dropdown
            labels:
              1: "On weekdays, not weekends"
              2: "Every other night"
              3: "One week out of two"
              4: "Two weeks alternately"
              5: "Every weekend"
              6: "One weekend out of two"
              7: "Less than two days every month"
              8: "Some holidays"
              9: "Never"
              10: "All the time"
              11: "Other"

        # CUS-Q16: Time at other parent's home (shared custody path)
        # Shown if shared custody arrangement (Q12=3, 4, or 5)
        - id: q_cus_q16
          kind: Question
          title: "At that time, how much time did the child live at his/her other parent's home?"
          precondition:
            - predicate: q_cus_q12.outcome in [3, 4, 5]
          input:
            control: Dropdown
            labels:
              1: "On weekdays, not weekends"
              2: "Every other night"
              3: "One week out of two"
              4: "Two weeks alternately"
              5: "Every weekend"
              6: "One weekend out of two"
              7: "Less than two days every month"
              8: "Some holidays"
              9: "Other"

        # CUS-Q17: Times living arrangements have changed
        # Shown if child was in "other" arrangement (Q12=6)
        - id: q_cus_q17
          kind: Question
          title: "How many times would you say these living arrangements have changed over time?"
          precondition:
            - predicate: q_cus_q12.outcome == 6 or q_cus_q12.outcome in [3, 4, 5]
          input:
            control: Radio
            labels:
              1: "None"
              2: "Once"
              3: "Twice"
              4: "Three times"
              5: "Four or more times"

        # CUS-Q18A: Current living arrangement
        # CUS-C18A: If parent died -> skip to Q19A. Otherwise show.
        # Shown if arrangements changed (Q17 >= 2) and no parent died
        - id: q_cus_q18a
          kind: Question
          title: "Currently, how much time does the child live at his/her other parent's home?"
          precondition:
            - predicate: q_cus_q12.outcome in [3, 4, 5, 6]
            - predicate: q_cus_q17.outcome >= 2
            - predicate: parent_died == 4
          input:
            control: Dropdown
            labels:
              1: "On weekdays, not weekends"
              2: "Every other night"
              3: "One week out of two"
              4: "Two weeks alternately"
              5: "Every weekend"
              6: "One weekend out of two"
              7: "Less than two days every month"
              8: "Some holidays"
              9: "Visits or letter or telephone calls only"
              10: "No contact"
              11: "All the time"
              12: "Parents now living together again"
              13: "Other"

        # CUS-Q18B: Current contact type (if visits/calls only)
        # CUS-C18B: IF Q18A=12 -> Q19C. IF Q18A=9 -> Q18B. Otherwise -> Q19A.
        - id: q_cus_q18b
          kind: Question
          title: "Which type of contact does the child now have with his/her other parent?"
          precondition:
            - predicate: q_cus_q12.outcome in [3, 4, 5, 6]
            - predicate: q_cus_q17.outcome >= 2
            - predicate: parent_died == 4
            - predicate: q_cus_q18a.outcome == 9
          input:
            control: Dropdown
            labels:
              1: "Regular visiting every week"
              2: "Regular visiting every two weeks"
              3: "Regular visiting monthly"
              4: "Irregular visiting on holidays only"
              5: "Irregular visiting without set pattern"
              6: "Telephone or letter contact only"
              7: "Other"

    # =========================================================================
    # BLOCK 10: CUSTODY MODIFICATIONS (Q19A-Q19C)
    # =========================================================================
    # CUS-Q19A: Court order modified custody?
    # CUS-Q19B: Current custody arrangement
    # CUS-Q19C: Tension over living arrangements
    # =========================================================================
    - id: b_custody_modifications
      title: "Custody Modifications"
      precondition:
        - predicate: relationship_to_child != 4
        - predicate: q_cus_q10a.outcome == 1 or q_cus_q10b.outcome == 1
      items:
        # CUS-Q19A: Has a court order modified custody?
        - id: q_cus_q19a
          kind: Question
          title: "Has a court order modified the custody of the child since his/her parents separated (or divorced)?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # CUS-Q19B: Current custody
        - id: q_cus_q19b
          kind: Question
          title: "Is he/she now in:"
          precondition:
            - predicate: q_cus_q19a.outcome == 1
          input:
            control: Radio
            labels:
              1: "Sole custody of mother"
              2: "Sole custody of father"
              3: "Shared physical custody of both parents"
              4: "Other"

        # CUS-Q19C: Tension over living arrangements
        - id: q_cus_q19c
          kind: Question
          title: "Between the child's parents, has the question of living arrangements or visiting rights been:"
          input:
            control: Radio
            labels:
              1: "A great source of tension"
              2: "Some source of tension"
              3: "Very little source of tension"
              4: "No source of tension at all"

    # =========================================================================
    # BLOCK 11: MOTHER'S NEW RELATIONSHIP (Q20A-Q20I)
    # =========================================================================
    # CUS-C20B routing (simplified):
    #   - Mother died -> skip to father's block (C21)
    #   - Parents together, no death, no separation -> skip to end
    #   - Otherwise -> Q20A
    #
    # CUS-Q20A: Mother entered new union?
    # CUS-Q20B: When did mother start living with new partner?
    # CUS-Q20C: When did marriage take place?
    # CUS-Q20D: Did child live in household with mother's new partner?
    # CUS-Q20E: Did new partner have children?
    # CUS-Q20F: How many?
    # CUS-Q20G: Did they live in household?
    # CUS-Q20H: Did mother have children with new partner?
    # CUS-Q20I: How many?
    # =========================================================================
    - id: b_mother_new_union
      title: "Mother's New Relationship"
      precondition:
        - predicate: relationship_to_child != 4
        - predicate: parent_died != 3
        - predicate: parent_died != 1
        # Show when parents separated, or parents not together, or a parent died
        - predicate: parents_separated == 1 or q_cus_q2.outcome == 2 or q_cus_q10a.outcome == 1
      items:
        # CUS-Q20A: Mother entered new union?
        - id: q_cus_q20a
          kind: Question
          title: "Has the child's mother entered into another marriage, common-law relationship, or common-law relationship that resulted in marriage? (Select all that apply.)"
          input:
            control: Checkbox
            labels:
              1: "Yes, a marriage"
              2: "Yes, a common-law relationship"
              4: "Yes, a common-law relationship that resulted in marriage"
              8: "No"
          codeBlock: |
            if q_cus_q20a.outcome % 8 >= 1:
                mother_new_union = 1

        # CUS-Q20B: When did mother start living with new partner?
        # Shown if common-law or common-law->marriage (Q20A has bit 2 or 4 set)
        - id: q_cus_q20b
          kind: Question
          title: "When did the child's mother start living with her new partner? (Enter year.)"
          precondition:
            - predicate: q_cus_q20a.outcome % 8 >= 2 or q_cus_q20a.outcome % 8 >= 4
          input:
            control: Editbox
            min: 1950
            max: 2010
            right: "year"

        # CUS-Q20C: When did marriage take place?
        # Shown if marriage (Q20A has bit 1 set) or common-law->marriage (bit 4)
        - id: q_cus_q20c
          kind: Question
          title: "When did the marriage take place? (Enter year.)"
          precondition:
            - predicate: q_cus_q20a.outcome % 2 == 1 or q_cus_q20a.outcome % 8 >= 4
          input:
            control: Editbox
            min: 1950
            max: 2010
            right: "year"

        # CUS-Q20D: Did child live with mother's new partner?
        - id: q_cus_q20d
          kind: Question
          title: "When they started living together, did the child live in the household with his/her mother's new partner?"
          precondition:
            - predicate: mother_new_union == 1
          input:
            control: Radio
            labels:
              1: "Yes, full-time"
              2: "Yes, part-time"
              3: "No"

        # CUS-Q20E: Did new partner have children?
        - id: q_cus_q20e
          kind: Question
          title: "Did the mother's new partner have any children of his own?"
          precondition:
            - predicate: mother_new_union == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # CUS-Q20F: How many?
        - id: q_cus_q20f
          kind: Question
          title: "How many?"
          precondition:
            - predicate: mother_new_union == 1
            - predicate: q_cus_q20e.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 20

        # CUS-Q20G: Did they live in household?
        - id: q_cus_q20g
          kind: Question
          title: "Did he/she/they live in the household with their father?"
          precondition:
            - predicate: mother_new_union == 1
            - predicate: q_cus_q20e.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes, all of them full-time"
              2: "Yes, all of them part-time"
              3: "Yes, some of them full-time"
              4: "Yes, some of them part-time"
              5: "No, none of them"

        # CUS-Q20H: Did mother have children with new partner?
        - id: q_cus_q20h
          kind: Question
          title: "Did the child's mother have any children with this new spouse/partner?"
          precondition:
            - predicate: mother_new_union == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # CUS-Q20I: How many children with new partner?
        - id: q_cus_q20i
          kind: Question
          title: "How many?"
          precondition:
            - predicate: mother_new_union == 1
            - predicate: q_cus_q20h.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 20

    # =========================================================================
    # BLOCK 12: FATHER'S NEW RELATIONSHIP (Q21A-Q21I)
    # =========================================================================
    # CUS-C21 routing (simplified):
    #   - Father died -> skip to Q22A (subsequent union breakup)
    #   - Father dead and mother has new union -> Q22A
    #   - Father dead and mother has no new union -> end
    #   - Otherwise -> Q21A
    # =========================================================================
    - id: b_father_new_union
      title: "Father's New Relationship"
      precondition:
        - predicate: relationship_to_child != 4
        - predicate: parent_died != 3
        - predicate: parent_died != 2
        - predicate: parents_separated == 1 or q_cus_q2.outcome == 2 or q_cus_q10a.outcome == 1
      items:
        # CUS-Q21A: Father entered new union?
        - id: q_cus_q21a
          kind: Question
          title: "Has the child's father entered into another marriage, common-law relationship, or common-law relationship that resulted in marriage? (Select all that apply.)"
          input:
            control: Checkbox
            labels:
              1: "Yes, a marriage"
              2: "Yes, a common-law relationship"
              4: "Yes, a common-law relationship that resulted in marriage"
              8: "No"
          codeBlock: |
            if q_cus_q21a.outcome % 8 >= 1:
                father_new_union = 1

        # CUS-Q21B: When did father start living with new partner?
        - id: q_cus_q21b
          kind: Question
          title: "When did the child's father start living with his new partner? (Enter year.)"
          precondition:
            - predicate: q_cus_q21a.outcome % 8 >= 2 or q_cus_q21a.outcome % 8 >= 4
          input:
            control: Editbox
            min: 1950
            max: 2010
            right: "year"

        # CUS-Q21C: When did marriage take place?
        - id: q_cus_q21c
          kind: Question
          title: "When did the marriage take place? (Enter year.)"
          precondition:
            - predicate: q_cus_q21a.outcome % 2 == 1 or q_cus_q21a.outcome % 8 >= 4
          input:
            control: Editbox
            min: 1950
            max: 2010
            right: "year"

        # CUS-Q21D: Did child live with father's new partner?
        - id: q_cus_q21d
          kind: Question
          title: "When they started living together, did the child live in the household with his/her father's new partner?"
          precondition:
            - predicate: father_new_union == 1
          input:
            control: Radio
            labels:
              1: "Yes, full-time"
              2: "Yes, part-time"
              3: "No"

        # CUS-Q21E: Did new partner have children?
        - id: q_cus_q21e
          kind: Question
          title: "Did the father's new partner have any children of her own?"
          precondition:
            - predicate: father_new_union == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # CUS-Q21F: How many?
        - id: q_cus_q21f
          kind: Question
          title: "How many?"
          precondition:
            - predicate: father_new_union == 1
            - predicate: q_cus_q21e.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 20

        # CUS-Q21G: Did they live in household?
        - id: q_cus_q21g
          kind: Question
          title: "Did he/she/they live in the household with their mother?"
          precondition:
            - predicate: father_new_union == 1
            - predicate: q_cus_q21e.outcome == 1
          input:
            control: Radio
            labels:
              1: "Yes, all of them full-time"
              2: "Yes, all of them part-time"
              3: "Yes, some of them full-time"
              4: "Yes, some of them part-time"
              5: "No, none of them"

        # CUS-Q21H: Did father have children with new partner?
        - id: q_cus_q21h
          kind: Question
          title: "Did the child's father have any children with this new spouse/partner?"
          precondition:
            - predicate: father_new_union == 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # CUS-Q21I: How many children with new partner?
        - id: q_cus_q21i
          kind: Question
          title: "How many?"
          precondition:
            - predicate: father_new_union == 1
            - predicate: q_cus_q21h.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 20

    # =========================================================================
    # BLOCK 13: SUBSEQUENT UNION BREAKUP (Q22A-Q23)
    # =========================================================================
    # CUS-C22: IF mother or father entered new relationship -> Q22A
    # Otherwise -> end of section
    # =========================================================================
    - id: b_subsequent_breakup
      title: "Subsequent Union Breakup"
      precondition:
        - predicate: relationship_to_child != 4
        - predicate: parent_died != 3
        - predicate: mother_new_union == 1 or father_new_union == 1
      items:
        # CUS-Q22A: Has this other union broken up?
        - id: q_cus_q22a
          kind: Question
          title: "Has this other union of the child's mother or father broken up?"
          input:
            control: Radio
            labels:
              1: "Yes, mother's union"
              2: "Yes, father's union"
              3: "Yes, both unions"
              4: "No"

        # CUS-Q22B: When did that happen?
        - id: q_cus_q22b
          kind: Question
          title: "When did that happen? (If both unions have broken up, use date of first event. Enter year.)"
          precondition:
            - predicate: q_cus_q22a.outcome in [1, 2, 3]
          input:
            control: Editbox
            min: 1950
            max: 2010
            right: "year"

        # CUS-Q22C: With whom did child live after?
        - id: q_cus_q22c
          kind: Question
          title: "With whom did the child go on living after it happened?"
          precondition:
            - predicate: q_cus_q22a.outcome in [1, 2, 3]
          input:
            control: Radio
            labels:
              1: "Mother full-time"
              2: "Father full-time"
              3: "Part-time mother and father"

        # CUS-Q23: Any other family reconstitution?
        - id: q_cus_q23
          kind: Question
          title: "Did the child live through any other family reconstitution between then and now?"
          precondition:
            - predicate: q_cus_q22a.outcome in [1, 2, 3]
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
