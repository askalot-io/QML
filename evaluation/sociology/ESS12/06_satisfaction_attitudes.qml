qmlVersion: "1.0"

questionnaire:
  title: "ESS Round 12 - Satisfaction and Attitudes"

  blocks:
    - id: b_left_right
      title: "Left-Right Placement"
      items:
        # A39: Left-right self-placement
        - id: q_a39
          kind: Question
          title: "In politics people sometimes talk of 'left' and 'right'. Where would you place yourself on this scale, where 0 means the left and 10 means the right?"
          input:
            control: Slider
            min: 0
            max: 10
            left: "Left"
            right: "Right"

    - id: b_satisfaction
      title: "Satisfaction"
      items:
        # A40: Life satisfaction
        - id: q_a40
          kind: Question
          title: "All things considered, how satisfied are you with your life as a whole nowadays?"
          input:
            control: Slider
            min: 0
            max: 10
            left: "Extremely dissatisfied"
            right: "Extremely satisfied"

        # A41: Satisfaction with economy
        - id: q_a41
          kind: Question
          title: "On the whole, how satisfied are you with the present state of the economy in [country]?"
          input:
            control: Slider
            min: 0
            max: 10
            left: "Extremely dissatisfied"
            right: "Extremely satisfied"

        # A42: Satisfaction with government
        - id: q_a42
          kind: Question
          title: "Now thinking about the [country] government, how satisfied are you with the way it is doing its job?"
          input:
            control: Slider
            min: 0
            max: 10
            left: "Extremely dissatisfied"
            right: "Extremely satisfied"

        # A43: Satisfaction with democracy
        - id: q_a43
          kind: Question
          title: "And on the whole, how satisfied are you with the way democracy works in [country]?"
          input:
            control: Slider
            min: 0
            max: 10
            left: "Extremely dissatisfied"
            right: "Extremely satisfied"

    - id: b_state_services
      title: "State of Services"
      items:
        # A44: State of education
        - id: q_a44
          kind: Question
          title: "What do you think overall about the state of education in [country] nowadays?"
          input:
            control: Slider
            min: 0
            max: 10
            left: "Extremely bad"
            right: "Extremely good"

        # A45: State of health services
        - id: q_a45
          kind: Question
          title: "What do you think overall about the state of health services in [country] nowadays?"
          input:
            control: Slider
            min: 0
            max: 10
            left: "Extremely bad"
            right: "Extremely good"

    - id: b_socio_political
      title: "Socio-Political Attitudes"
      items:
        # A46: Government should reduce income differences
        - id: q_a46
          kind: Question
          title: "The government should take measures to reduce differences in income levels."
          input:
            control: Radio
            labels:
              1: "Agree strongly"
              2: "Agree"
              3: "Neither agree nor disagree"
              4: "Disagree"
              5: "Disagree strongly"

        # A47: Gay men and lesbians free to live as they wish
        - id: q_a47
          kind: Question
          title: "Gay men and lesbians should be free to live their own life as they wish."
          input:
            control: Radio
            labels:
              1: "Agree strongly"
              2: "Agree"
              3: "Neither agree nor disagree"
              4: "Disagree"
              5: "Disagree strongly"

        # A48: Ashamed if close family member gay/lesbian
        - id: q_a48
          kind: Question
          title: "If a close family member was a gay man or a lesbian, I would feel ashamed."
          input:
            control: Radio
            labels:
              1: "Agree strongly"
              2: "Agree"
              3: "Neither agree nor disagree"
              4: "Disagree"
              5: "Disagree strongly"

        # A49: Gay/lesbian couples right to adopt
        - id: q_a49
          kind: Question
          title: "Gay male and lesbian couples should have the same rights to adopt children as straight couples."
          input:
            control: Radio
            labels:
              1: "Agree strongly"
              2: "Agree"
              3: "Neither agree nor disagree"
              4: "Disagree"
              5: "Disagree strongly"

        # A50: European unification
        - id: q_a50
          kind: Question
          title: "Now thinking about the European Union, some say European unification should go further. Others say it has already gone too far. Which number on this scale best describes your position?"
          input:
            control: Slider
            min: 0
            max: 10
            left: "Unification has already gone too far"
            right: "Unification should go further"

        # A51: Obedience and respect for authority
        - id: q_a51
          kind: Question
          title: "Obedience and respect for authority are the most important values children should learn."
          input:
            control: Radio
            labels:
              1: "Agree strongly"
              2: "Agree"
              3: "Neither agree nor disagree"
              4: "Disagree"
              5: "Disagree strongly"

        # A52: Loyalty towards leaders
        - id: q_a52
          kind: Question
          title: "What [country] needs most is loyalty towards its leaders."
          input:
            control: Radio
            labels:
              1: "Agree strongly"
              2: "Agree"
              3: "Neither agree nor disagree"
              4: "Disagree"
              5: "Disagree strongly"

    - id: b_immigration_attitudes
      title: "Immigration Attitudes"
      items:
        # A53: Allow same race/ethnic group
        - id: q_a53
          kind: Question
          title: "To what extent do you think [country] should allow people of the same race or ethnic group as most [country] people to come and live here?"
          input:
            control: Radio
            labels:
              1: "Allow many to come and live here"
              2: "Allow some"
              3: "Allow a few"
              4: "Allow none"

        # A54: Allow different race/ethnic group
        - id: q_a54
          kind: Question
          title: "To what extent do you think [country] should allow people of a different race or ethnic group from most [country] people to come and live here?"
          input:
            control: Radio
            labels:
              1: "Allow many to come and live here"
              2: "Allow some"
              3: "Allow a few"
              4: "Allow none"

        # A55: Allow people from poorer countries outside Europe
        - id: q_a55
          kind: Question
          title: "To what extent do you think [country] should allow people from poorer countries outside Europe to come and live here?"
          input:
            control: Radio
            labels:
              1: "Allow many to come and live here"
              2: "Allow some"
              3: "Allow a few"
              4: "Allow none"

        # A56: Allow people fleeing conflict/persecution
        - id: q_a56
          kind: Question
          title: "To what extent do you think [country] should allow people who are forced to leave their country because of armed conflict or persecution to come and live here?"
          input:
            control: Radio
            labels:
              1: "Allow many to come and live here"
              2: "Allow some"
              3: "Allow a few"
              4: "Allow none"

        # A57: Immigration impact on economy
        - id: q_a57
          kind: Question
          title: "Would you say it is generally bad or good for [country]'s economy that people come to live here from other countries?"
          input:
            control: Slider
            min: 0
            max: 10
            left: "Bad for the economy"
            right: "Good for the economy"

        # A58: Immigration impact on cultural life
        - id: q_a58
          kind: Question
          title: "Would you say that [country]'s cultural life is generally undermined or enriched by people coming to live here from other countries?"
          input:
            control: Slider
            min: 0
            max: 10
            left: "Cultural life undermined"
            right: "Cultural life enriched"

        # A59: Immigration impact on place to live
        - id: q_a59
          kind: Question
          title: "Is [country] made a worse or a better place to live by people coming to live here from other countries?"
          input:
            control: Slider
            min: 0
            max: 10
            left: "Worse place to live"
            right: "Better place to live"
