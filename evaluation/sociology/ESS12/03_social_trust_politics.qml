qmlVersion: "1.0"
questionnaire:
  title: "ESS12 — Social Trust and Political Efficacy (A11–A18)"
  blocks:
    - id: b_social_trust
      title: "Social Trust"
      items:
        - id: q_a11
          kind: Question
          title: "Generally speaking, would you say that most people can be trusted, or that you can't be too careful in dealing with people?"
          input:
            control: Slider
            min: 0
            max: 10
            left: "You can't be too careful"
            right: "Most people can be trusted"

        - id: q_a12
          kind: Question
          title: "Do you think that most people would try to take advantage of you if they got the chance, or would they try to be fair?"
          input:
            control: Slider
            min: 0
            max: 10
            left: "Most people would try to take advantage of me"
            right: "Most people would try to be fair"

        - id: q_a13
          kind: Question
          title: "Would you say that most of the time people try to be helpful or that they are mostly looking out for themselves?"
          input:
            control: Slider
            min: 0
            max: 10
            left: "People mostly look out for themselves"
            right: "People mostly try to be helpful"

    - id: b_politics
      title: "Political Interest and Efficacy"
      items:
        - id: q_a14
          kind: Question
          title: "How interested would you say you are in politics?"
          input:
            control: Radio
            labels:
              1: "Very interested"
              2: "Quite interested"
              3: "Hardly interested"
              4: "Not at all interested"

        - id: q_a15
          kind: Question
          title: "How much would you say the political system in [country] allows people like you to have a say in what the government does?"
          input:
            control: Radio
            labels:
              1: "Not at all"
              2: "Very little"
              3: "Some"
              4: "A lot"
              5: "A great deal"

        - id: q_a16
          kind: Question
          title: "How able do you think you are to take an active role in a group involved with political issues?"
          input:
            control: Radio
            labels:
              1: "Not at all able"
              2: "A little able"
              3: "Quite able"
              4: "Very able"
              5: "Completely able"

        - id: q_a17
          kind: Question
          title: "How much would you say the political system in [country] allows people like you to have an influence on politics?"
          input:
            control: Radio
            labels:
              1: "Not at all"
              2: "Very little"
              3: "Some"
              4: "A lot"
              5: "A great deal"

        - id: q_a18
          kind: Question
          title: "How confident are you in your own ability to participate in politics?"
          input:
            control: Radio
            labels:
              1: "Not at all confident"
              2: "A little confident"
              3: "Quite confident"
              4: "Very confident"
              5: "Completely confident"
