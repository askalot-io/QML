qmlVersion: "1.0"
questionnaire:
  title: "NLSCY Children and Youth - Family Functioning"
  codeInit: |
    # Variables READ from prior sections
    marital_status = 0   # 1=married, 2=common-law, 3=living with partner

  blocks:
    # =========================================================================
    # BLOCK 1: FAMILY FUNCTIONING (FNC)
    # =========================================================================
    # FNC-C1: "IF THIS SECTION HAS BEEN COMPLETED FOR ANOTHER HOUSEHOLD
    #          MEMBER -> SKIP". This is a system-level check that cannot be
    #          expressed in QML; modeled as always shown.
    # =========================================================================
    - id: b_family_functioning
      title: "Family Functioning"
      items:
        # FNC-I1: Intro text
        - id: q_fnc_intro
          kind: Comment
          title: "The following statements are about families and family relationships. For each one, please indicate which response best describes your family: strongly agree, agree, disagree or strongly disagree."

        # FNC-Q1A through FNC-Q1M: 13 family functioning statements
        # All share a 4-point agree/disagree scale.
        # Index mapping:
        #   [0]  Q1A - Planning activities / misunderstand
        #   [1]  Q1B - Crisis support
        #   [2]  Q1C - Cannot talk about sadness
        #   [3]  Q1D - Accepted for what they are
        #   [4]  Q1E - Avoid discussing fears
        #   [5]  Q1F - Express feelings
        #   [6]  Q1G - Bad feelings in family
        #   [7]  Q1H - Feel accepted
        #   [8]  Q1I - Decisions are a problem
        #   [9]  Q1J - Able to solve problems
        #   [10] Q1K - Don't get along well
        #   [11] Q1L - Confide in each other
        #   [12] Q1M - Drinking is source of tension
        - id: qg_fnc
          kind: QuestionGroup
          title: "Please indicate how much you agree or disagree with each of the following statements about your family:"
          questions:
            - "(a) Planning family activities is difficult because we misunderstand each other."
            - "(b) In times of crisis we can turn to each other for support."
            - "(c) We cannot talk to each other about sadness we feel."
            - "(d) Individuals in the family are accepted for what they are."
            - "(e) We avoid discussing our fears or concerns."
            - "(f) We express feelings to each other."
            - "(g) There are lots of bad feelings in our family."
            - "(h) We feel accepted for what we are."
            - "(i) Making decisions is a problem for our family."
            - "(j) We are able to make decisions about how to solve problems."
            - "(k) We don't get along well together."
            - "(l) We confide in each other."
            - "(m) Drinking is a source of tension or disagreement in our family."
          input:
            control: Radio
            labels:
              1: "Strongly agree"
              2: "Agree"
              3: "Disagree"
              4: "Strongly disagree"

        # FNC-C2: IF married/common-law/partner -> Q2; OTHERWISE -> next section
        # FNC-Q2: Marital satisfaction on 1-11 scale
        - id: q_fnc_satisfaction
          kind: Question
          title: "All things considered, how satisfied or dissatisfied are you with your marriage or relationship with your partner? Choose the number that comes closest to how you feel, where 1 is completely dissatisfied and 11 is completely satisfied."
          precondition:
            - predicate: marital_status in [1, 2, 3]
          input:
            control: Slider
            min: 1
            max: 11
            labels:
              1: "Completely dissatisfied"
              6: "Neutral"
              11: "Completely satisfied"
