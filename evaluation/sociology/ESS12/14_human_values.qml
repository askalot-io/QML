qmlVersion: "1.0"

questionnaire:
  title: "ESS Round 12 - Section E: Human Values Scale"

  blocks:
    # ── Human Values (E1-E20) ──
    # Schwartz Portrait Values Questionnaire (PVQ-20)
    # All 20 items share the same 6-point scale, no routing, ASK ALL.
    - id: b_human_values
      title: "Human Values"
      items:
        - id: qg_human_values
          kind: QuestionGroup
          title: "Here we briefly describe different people. Please listen to each description and tell me how much each person is or is not like you."
          questions:
            - "It is important to this person to develop their own opinions."
            - "It is important to this person that the state is strong and can defend its citizens."
            - "It is important to this person to enjoy life's pleasures."
            - "It is important to this person never to make other people angry."
            - "It is important to this person to be very successful."
            - "It is important to this person that everyone be treated justly, even people they don't know."
            - "It is important to this person to have the power to make others comply with what they want."
            - "It is important to this person to be humble."
            - "It is important to this person to protect the natural environment from pollution or destruction."
            - "It is important to this person never to be humiliated."
            - "It is important to this person to have all sorts of new experiences."
            - "It is important to this person to help the people close to them."
            - "It is important to this person to be wealthy."
            - "It is important to this person to be personally safe and secure."
            - "It is important to this person to be tolerant towards all kinds of people and groups."
            - "It is important to this person never to violate rules or regulations."
            - "It is important to this person to make their own decisions about their life."
            - "It is important to this person to follow traditions. These might be cultural, family or religious traditions."
            - "It is important to this person that the people they know have full confidence in them."
            - "It is important to this person that their achievements are recognised by other people."
          input:
            control: Radio
            labels:
              1: "Very much like me"
              2: "Like me"
              3: "Somewhat like me"
              4: "A little like me"
              5: "Not like me"
              6: "Not like me at all"
