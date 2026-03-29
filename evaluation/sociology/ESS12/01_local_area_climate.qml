qmlVersion: "1.0"
questionnaire:
  title: "ESS12 — Local Area and Climate (A1–A7)"
  blocks:
    - id: b_local_area
      title: "Local Area"
      items:
        - id: q_a1
          kind: Question
          title: "Overall, how satisfied or dissatisfied are you with your local area as a place to live?"
          input:
            control: Radio
            labels:
              1: "Very satisfied"
              2: "Fairly satisfied"
              3: "Neither satisfied nor dissatisfied"
              4: "Fairly dissatisfied"
              5: "Very dissatisfied"

        - id: q_a2
          kind: Question
          title: "Over the past two years, has the local area where you live got better, worse, or not changed much?"
          input:
            control: Radio
            labels:
              1: "Got better"
              2: "Got worse"
              3: "Not changed much (has not got better or worse)"
              4: "I have not lived here long enough to say"

        - id: q_a3
          kind: Question
          title: "How much do you feel you belong to your local area?"
          input:
            control: Slider
            min: 0
            max: 6
            left: "Not at all"
            right: "A great deal"

        - id: q_a4
          kind: Question
          title: "How often do you chat to your neighbours, more than to just say hello?"
          input:
            control: Radio
            labels:
              1: "On most days"
              2: "Once or twice a week"
              3: "Once or twice a month"
              4: "Less than once a month"
              5: "Never"
              6: "I don't have any neighbours"

    - id: b_climate
      title: "Climate Change"
      items:
        - id: q_a5
          kind: Question
          title: "Do you think that climate change is caused by natural processes, human activity, or both?"
          input:
            control: Radio
            labels:
              1: "Entirely by natural processes"
              2: "Mainly by natural processes"
              3: "About equally by natural processes and human activity"
              4: "Mainly by human activity"
              5: "Entirely by human activity"
              55: "I don't think climate change is happening"

        - id: q_a6
          kind: Question
          title: "To what extent do you feel a personal responsibility to try to reduce climate change?"
          precondition:
            - predicate: q_a5.outcome != 55
          input:
            control: Slider
            min: 0
            max: 10
            left: "Not at all"
            right: "A great deal"

        - id: q_a7
          kind: Question
          title: "How worried are you about climate change?"
          precondition:
            - predicate: q_a5.outcome != 55
          input:
            control: Radio
            labels:
              1: "Not at all worried"
              2: "Not very worried"
              3: "Somewhat worried"
              4: "Very worried"
              5: "Extremely worried"
