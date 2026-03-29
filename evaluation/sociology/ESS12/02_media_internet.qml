qmlVersion: "1.0"
questionnaire:
  title: "ESS12 — Media and Internet Use (A8–A10)"
  blocks:
    - id: b_media
      title: "Media Use"
      items:
        - id: q_a8_hours
          kind: Question
          title: "On a typical day, about how much time do you spend watching, reading or listening to news about politics and current affairs? (Hours)"
          input:
            control: Editbox
            min: 0
            max: 24
            right: "hours"

        - id: q_a8_minutes
          kind: Question
          title: "On a typical day, about how much time do you spend watching, reading or listening to news about politics and current affairs? (Minutes)"
          postcondition:
            - predicate: not (q_a8_hours.outcome == 24 and q_a8_minutes.outcome > 0)
              hint: "If hours is 24, minutes must be 0."
          input:
            control: Editbox
            min: 0
            max: 59
            right: "minutes"

    - id: b_internet
      title: "Internet Use"
      items:
        - id: q_a9
          kind: Question
          title: "How often do you use the internet on these or any other devices, whether for work or personal use?"
          input:
            control: Radio
            labels:
              1: "Never"
              2: "Only occasionally"
              3: "A few times a week"
              4: "Most days"
              5: "Every day"

        - id: q_a10_hours
          kind: Question
          title: "On a typical day, about how much time do you spend using the internet on a computer, tablet, smartphone or other device, whether for work or personal use? (Hours)"
          precondition:
            - predicate: q_a9.outcome in [4, 5]
          input:
            control: Editbox
            min: 0
            max: 24
            right: "hours"

        - id: q_a10_minutes
          kind: Question
          title: "On a typical day, about how much time do you spend using the internet on a computer, tablet, smartphone or other device, whether for work or personal use? (Minutes)"
          precondition:
            - predicate: q_a9.outcome in [4, 5]
          postcondition:
            - predicate: not (q_a10_hours.outcome == 24 and q_a10_minutes.outcome > 0)
              hint: "If hours is 24, minutes must be 0."
          input:
            control: Editbox
            min: 0
            max: 59
            right: "minutes"
