qmlVersion: "1.0"
questionnaire:
  title: "NLSCY Children and Youth - Relationships (REL)"
  codeInit: |
    # Variables READ from prior sections
    child_age = 0       # child's age from demographics section
    has_siblings = 0    # 1 if child has brothers/sisters in household

  blocks:
    # =========================================================================
    # BLOCK 1: FRIENDSHIPS (REL-I1, REL-Q1 through REL-Q5)
    # =========================================================================
    # REL-C1: IF AGE < 4 → skip entire section. Modeled as block-level
    #         precondition child_age >= 4.
    # REL-I1: Introduction (all age 4+)
    # REL-Q1: Days with friends (all age 4+)
    # REL-C2: IF AGE < 6 → skip to Q6. Q2 has precondition child_age >= 6.
    # REL-Q2: Close friends count. If NONE → skip Q3-Q5.
    # REL-C3/C4: IF AGE < 8 → skip to Q6. Q3-Q5 have precondition child_age >= 8.
    # REL-Q3: Friends known by name
    # REL-Q4: Making new friends
    # REL-Q5: Friends in trouble
    # =========================================================================
    - id: b_rel_friendships
      title: "Relationships - Friendships"
      precondition:
        - predicate: child_age >= 4
      items:
        # REL-I1: Introduction
        - id: q_rel_intro
          kind: Comment
          title: "The next few questions are about this child's relationships with friends, family and others."

        # REL-Q1: Days with friends (all age 4+)
        - id: q_rel_q1
          kind: Question
          title: "About how many days a week does he/she do things with friends?"
          input:
            control: Radio
            labels:
              1: "Never"
              2: "1 day a week"
              3: "2-3 days a week"
              4: "4-5 days a week"
              5: "6-7 days a week"

        # REL-Q2: Close friends (age 6+ only)
        # REL-C2 routing: IF AGE < 6 → skip to Q6
        # If NONE (outcome == 1) → skip Q3-Q5
        - id: q_rel_q2
          kind: Question
          title: "About how many close friends does he/she have?"
          precondition:
            - predicate: child_age >= 6
          input:
            control: Radio
            labels:
              1: "None"
              2: "1"
              3: "2 or 3"
              4: "4 or 5"
              5: "6 or more"

        # REL-Q3: Friends known by name (age 8+ and Q2 not NONE)
        # REL-C3 routing: IF AGE < 8 → skip to Q6
        - id: q_rel_q3
          kind: Question
          title: "How many of his/her close friends do you know by sight and by first and last name?"
          precondition:
            - predicate: child_age >= 8
            - predicate: q_rel_q2.outcome != 1
          input:
            control: Radio
            labels:
              1: "All"
              2: "Most"
              3: "About half"
              4: "Only a few"
              5: "None"

        # REL-Q4: Making new friends (age 8+ and Q2 not NONE)
        # REL-C4 routing: IF AGE < 8 → skip to Q6
        - id: q_rel_q4
          kind: Question
          title: "When it comes to meeting new children and making new friends, is he/she:"
          precondition:
            - predicate: child_age >= 8
            - predicate: q_rel_q2.outcome != 1
          input:
            control: Radio
            labels:
              1: "Somewhat shy"
              2: "About average"
              3: "Very outgoing - makes friends easily"

        # REL-Q5: Friends in trouble (age 8+ and Q2 not NONE)
        - id: q_rel_q5
          kind: Question
          title: "How often does he/she hang around with kids you think are frequently in trouble?"
          precondition:
            - predicate: child_age >= 8
            - predicate: q_rel_q2.outcome != 1
          input:
            control: Radio
            labels:
              1: "Often"
              2: "Sometimes"
              3: "Seldom"
              4: "Never"

    # =========================================================================
    # BLOCK 2: GETTING ALONG (REL-Q6 through REL-Q9)
    # =========================================================================
    # Q6-Q8: Getting along with others (all age 4+, same 5-point scale)
    # REL-C9: IF no siblings → skip Q9. Modeled with has_siblings == 1.
    # REL-Q9: Getting along with siblings (same scale, conditional)
    # =========================================================================
    - id: b_rel_getting_along
      title: "Relationships - Getting Along"
      precondition:
        - predicate: child_age >= 4
      items:
        # REL-Q6, Q7, Q8: Getting along with peers, teachers, parents
        - id: qg_rel_getting_along
          kind: QuestionGroup
          title: "During the past 6 months, how well has the child gotten along with the following:"
          questions:
            - "Other kids, such as friends or classmates (excluding brothers or sisters)?"
            - "His/her teacher(s) at school?"
            - "His/her parent(s)?"
          input:
            control: Radio
            labels:
              1: "Very well, no problems"
              2: "Quite well, hardly any problems"
              3: "Pretty well, occasional problems"
              4: "Not too well, frequent problems"
              5: "Not well at all, constant problems"
              6: "Not applicable"

        # REL-Q9: Getting along with siblings (only if has siblings)
        # REL-C9 routing: IF no siblings → skip
        - id: q_rel_q9
          kind: Question
          title: "During the past 6 months, how well has the child gotten along with his/her brother(s)/sister(s)?"
          precondition:
            - predicate: has_siblings == 1
          input:
            control: Radio
            labels:
              1: "Very well, no problems"
              2: "Quite well, hardly any problems"
              3: "Pretty well, occasional problems"
              4: "Not too well, frequent problems"
              5: "Not well at all, constant problems"
              6: "Not applicable"
