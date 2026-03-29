qmlVersion: "1.0"

questionnaire:
  title: "ESS Round 12 - Institutional Trust"

  blocks:
    - id: b_institutional_trust
      title: "Institutional Trust"
      items:
        # A19: Trust in parliament
        - id: qg_trust
          kind: QuestionGroup
          title: "Please tell me on a score of 0-10 how much you personally trust each of the institutions I read out."
          questions:
            - "[Country]'s parliament"
            - "The legal system"
            - "The police"
            - "Politicians"
            - "Political parties"
            - "The European Parliament"
            - "The United Nations"
          input:
            control: Slider
            min: 0
            max: 10
            left: "No trust at all"
            right: "Complete trust"
