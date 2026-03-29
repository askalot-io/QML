qmlVersion: "1.0"
questionnaire:
  title: "PALS 2001 (Children) — Section D: Child Care"
  codeInit: |
    # No extern variables required for this section.

  blocks:
    # =========================================================================
    # BLOCK 1: SECTION D — CHILD CARE (items D1–D7)
    # =========================================================================
    # D1   → Currently use child care? Radio (Yes/No/DK). DK → skip to D6.
    # D2   → Main child care arrangement? Radio 8 options. DK → skip to D6.
    # D3   → Hours per week (main arrangement)? Editbox. Always follows D2.
    # D4   → Any other child care arrangement? Radio (Yes/No/DK). DK/No → D6.
    # D5   → Hours per week (other arrangement)? Editbox. Precondition: D4 = Yes.
    # D6   → Child care program ever refused child? Radio (Yes/No/DK). DK → skip D7.
    # D7   → Types of programs that refused (6 sub-items, Switch). Precondition: D6 = Yes.
    # =========================================================================
    - id: b_child_care
      title: "Child Care"
      items:

        # D1: Currently using child care?
        # 1=Yes, 3=No → D2; x=Don't know → GO TO D6; r=Refusal → D2
        # Model: code 8 = Don't know to gate D2–D5
        - id: q_d1
          kind: Question
          title: "Now, I'd like to ask you some questions about child care arrangements for ..... . Do you CURRENTLY use child care such as day care, babysitting or a before and after school program for ..... while you (or your spouse/partner) are at work or studying?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"

        # D2: Main child care arrangement?
        # Precondition: D1 answered and not DK (i.e. outcome != 8)
        # x=Don't know → GO TO D6; r → D3 (both treated as code 9 here)
        - id: q_d2
          kind: Question
          title: "What is your MAIN child care arrangement for .....?"
          precondition:
            - predicate: q_d1.outcome in [1, 3]
          input:
            control: Radio
            labels:
              1: "Before and after school program"
              2: "Nursery school"
              3: "Day care centre"
              4: "Care in someone else's home by a non-relative"
              5: "Care in someone else's home by a relative"
              6: "Care in child's home by a non-relative"
              7: "Care in child's home by a relative"
              8: "Other, specify"
              9: "Don't know"

        # D3: Hours per week for main arrangement?
        # Precondition: D2 answered (not DK, i.e. outcome != 9) AND D1 not DK
        - id: q_d3
          kind: Question
          title: "Approximately how many hours per WEEK is that? (Main child care arrangement)"
          precondition:
            - predicate: q_d1.outcome in [1, 3]
            - predicate: q_d2.outcome in [1, 2, 3, 4, 5, 6, 7, 8]
          input:
            control: Editbox
            min: 0
            max: 168
            right: "hours per week"

        # D4: Any other child care arrangement?
        # Precondition: D1 not DK
        # 1=Yes → D5; 3=No/x=DK → D6
        - id: q_d4
          kind: Question
          title: "Do you use any other child care arrangement for .....?"
          precondition:
            - predicate: q_d1.outcome in [1, 3]
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"

        # D5: Hours per week for other arrangement?
        # Precondition: D4 = Yes (outcome == 1)
        - id: q_d5
          kind: Question
          title: "Approximately how many hours per WEEK is that? (Other child care arrangement)"
          precondition:
            - predicate: q_d4.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 168
            right: "hours per week"

        # D6: Has a child care program ever refused to take child?
        # 1=Yes → D7; 3=No → D7; x=DK → GO TO D8.edit (skip D7); r → D7
        - id: q_d6
          kind: Question
          title: "Has a child care program or service ever refused to take care of ..... because of his/her condition or health problem?"
          input:
            control: Radio
            labels:
              1: "Yes"
              3: "No"
              8: "Don't know"

        # D7: Types of programs that refused (multi-select Yes/No per sub-item)
        # Precondition: D6 = Yes (outcome == 1)
        # 6 sub-items: (a) Before/after school; (b) Nursery school; (c) Day care centre;
        #              (d) Care in someone else's home; (e) Care in child's home; (f) Other
        - id: qg_d7
          kind: QuestionGroup
          title: "What type of child care programs or services refused to provide care to .....? I will read you a list. Please answer yes or no to each."
          precondition:
            - predicate: q_d6.outcome == 1
          questions:
            - "Before and after school program"
            - "Nursery school"
            - "Day care centre"
            - "Care in someone else's home"
            - "Care in child's home"
            - "Other, specify"
          input:
            control: Switch
            on: "Yes"
            off: "No"
