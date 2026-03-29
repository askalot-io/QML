qmlVersion: "1.0"
questionnaire:
  title: "NLSCY Children and Youth - Social Support (SUP)"

  blocks:
    # =========================================================================
    # BLOCK 1: SOCIAL SUPPORT (SUP)
    # =========================================================================
    # SUP-C1: "IF THIS SECTION HAS BEEN COMPLETED FOR ANOTHER HOUSEHOLD
    #          MEMBER → SKIP TO NEXT SECTION" — system-level check that
    #          cannot be modeled declaratively. Always show this section.
    # =========================================================================
    - id: b_social_support
      title: "Social Support"
      items:
        # SUP-I1: Introduction
        - id: q_sup_i1
          kind: Comment
          title: "The following statements are about relationships and the support which you get from others. For each of the following, please tell me whether you strongly disagree, disagree, agree, or strongly agree."

        # SUP-Q1A through SUP-Q1F: Six relationship support statements
        # 4-point agreement scale (1=Strongly Disagree to 4=Strongly Agree)
        # DON'T KNOW (8) and REFUSAL (9) are interviewer codes, omitted in
        # the declarative model — the respondent must choose 1-4.
        - id: qg_sup_q1
          kind: QuestionGroup
          title: "Please tell me whether you strongly disagree, disagree, agree, or strongly agree with each of the following statements:"
          questions:
            - "(a) If something went wrong, no one would help me."
            - "(b) I have family and friends who help me feel safe, secure and happy."
            - "(c) There is someone I trust whom I would turn to for advice if I were having problems."
            - "(d) There is no one I feel comfortable talking about problems with."
            - "(e) I lack a feeling of closeness with another person."
            - "(f) There are people I can count on in an emergency."
          input:
            control: Radio
            labels:
              1: "Strongly disagree"
              2: "Disagree"
              3: "Agree"
              4: "Strongly agree"

        # SUP-Q2A through SUP-Q2D: Help sources in past 12 months (Yes/No)
        - id: qg_sup_q2
          kind: QuestionGroup
          title: "Besides your friends and family, did any of the following help with your personal problems during the past 12 months?"
          questions:
            - "(a) Community or social service professionals?"
            - "(b) Health professionals?"
            - "(c) Religious or spiritual leaders or communities?"
            - "(d) Books or magazines?"
          input:
            control: Switch
            off: "No"
            on: "Yes"
