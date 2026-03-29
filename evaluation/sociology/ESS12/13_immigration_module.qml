qmlVersion: "1.0"

questionnaire:
  title: "ESS Round 12 - Section D: Immigration Module"

  codeInit: |
    born_in_country: {0, 1}
    sample_group: {1, 2, 3, 4}

  blocks:
    # ── Global Solidarity (D1-D4) ──
    - id: b_global_solidarity
      title: "Global Solidarity"
      items:
        # D1: Importance of helping poorer countries
        - id: q_d1
          kind: Question
          title: "How important do you think it is that people in countries which are better off should help those in poorer countries who are unable to provide for their basic needs?"
          input:
            control: Radio
            labels:
              1: "Very important"
              2: "Important"
              3: "Not very important"
              4: "Not at all important"

        # D2: Acceptability of helping only deserving
        - id: q_d2
          kind: Question
          title: "How acceptable do you think it is that people ONLY help those who genuinely deserve assistance?"
          input:
            control: Radio
            labels:
              1: "Very acceptable"
              2: "Acceptable"
              3: "Not very acceptable"
              4: "Not at all acceptable"

        # D3: World better if others like country's people
        - id: q_d3
          kind: Question
          title: "Would you say that the world would be a better or a worse place if people from other countries were more like the people in this country?"
          input:
            control: Radio
            labels:
              1: "World would be a much better place"
              2: "World would be a better place"
              3: "Would not make it a better or worse place"
              4: "World would be a worse place"
              5: "World would be a much worse place"

        # D4: Ruthless assertion of national interests
        - id: q_d4
          kind: Question
          title: "How often should this country be ruthless in asserting its national interests against other countries?"
          input:
            control: Radio
            labels:
              1: "Always"
              2: "Often"
              3: "Sometimes"
              4: "Hardly ever"
              5: "Never"

    # ── Immigration Criteria (D5-D8) ──
    - id: b_immigration_criteria
      title: "Immigration Criteria"
      items:
        # D5: Importance of good educational qualifications
        - id: q_d5
          kind: Question
          title: "How important should it be for people coming to live here to have good educational qualifications?"
          input:
            control: Slider
            min: 0
            max: 10
            left: "Extremely unimportant"
            right: "Extremely important"

        # D6: Importance of speaking official language
        - id: q_d6
          kind: Question
          title: "How important should it be for people coming to live here to be able to speak the country's official language(s)?"
          input:
            control: Slider
            min: 0
            max: 10
            left: "Extremely unimportant"
            right: "Extremely important"

        # D7: Importance of Christian background
        - id: q_d7
          kind: Question
          title: "How important should it be for people coming to live here to come from a Christian background?"
          input:
            control: Slider
            min: 0
            max: 10
            left: "Extremely unimportant"
            right: "Extremely important"

        # D8: Importance of being white
        - id: q_d8
          kind: Question
          title: "How important should it be for people coming to live here to be white?"
          input:
            control: Slider
            min: 0
            max: 10
            left: "Extremely unimportant"
            right: "Extremely important"

    # ── Immigration Impact (D9-D11) ──
    - id: b_immigration_impact
      title: "Immigration Impact"
      items:
        # D9: Immigrants take jobs or create jobs
        - id: q_d9
          kind: Question
          title: "Would you say that people who come to live here generally take jobs away from workers in this country, or generally help to create new jobs?"
          input:
            control: Slider
            min: 0
            max: 10
            left: "Take jobs away"
            right: "Create new jobs"

        # D10: Immigrants take out or put in more
        - id: q_d10
          kind: Question
          title: "Most people who come to live here work and pay taxes. They also use health and welfare services. On balance, do you think people who come here take out more than they put in or put in more than they take out?"
          input:
            control: Slider
            min: 0
            max: 10
            left: "Generally take out more"
            right: "Generally put in more"

        # D11: Impact on crime
        - id: q_d11
          kind: Question
          title: "Are this country's crime problems made worse or better by people coming to live here from other countries?"
          input:
            control: Slider
            min: 0
            max: 10
            left: "Crime problems made worse"
            right: "Crime problems made better"

    # ── Social Distance (D12-D13) ──
    - id: b_social_distance
      title: "Social Distance"
      items:
        # D12: Mind immigrant as boss
        - id: q_d12
          kind: Question
          title: "How much would you mind or not mind if someone of a different race or ethnic group from most people in this country was appointed as your boss?"
          input:
            control: Slider
            min: 0
            max: 10
            left: "Not mind at all"
            right: "Mind a lot"

        # D13: Mind immigrant marrying close relative
        - id: q_d13
          kind: Question
          title: "How much would you mind or not mind if someone of a different race or ethnic group from most people in this country married a close relative of yours?"
          input:
            control: Slider
            min: 0
            max: 10
            left: "Not mind at all"
            right: "Mind a lot"

    # ── Refugees (D14-D18) ──
    - id: b_refugees
      title: "Refugees"
      items:
        # D14: Country has more than fair share of refugees
        - id: q_d14
          kind: Question
          title: "This country has more than its fair share of people applying for refugee status."
          input:
            control: Radio
            labels:
              1: "Agree strongly"
              2: "Agree"
              3: "Neither agree nor disagree"
              4: "Disagree"
              5: "Disagree strongly"

        # D15: Refugees should be allowed to work
        - id: q_d15
          kind: Question
          title: "While their applications for refugee status are being considered, people should be allowed to work in this country."
          input:
            control: Radio
            labels:
              1: "Agree strongly"
              2: "Agree"
              3: "Neither agree nor disagree"
              4: "Disagree"
              5: "Disagree strongly"

        # D16: Government generous judging refugee applications
        - id: q_d16
          kind: Question
          title: "The government should be generous in judging people's applications for refugee status."
          input:
            control: Radio
            labels:
              1: "Agree strongly"
              2: "Agree"
              3: "Neither agree nor disagree"
              4: "Disagree"
              5: "Disagree strongly"

        # D17: Applicants kept in detention centres
        - id: q_d17
          kind: Question
          title: "While their cases are being considered, applicants should be kept in detention centres."
          input:
            control: Radio
            labels:
              1: "Agree strongly"
              2: "Agree"
              3: "Neither agree nor disagree"
              4: "Disagree"
              5: "Disagree strongly"

        # D18: Estimated proportion born outside country
        - id: q_d18
          kind: Question
          title: "Out of every 100 people living in this country, how many do you think were born outside this country?"
          input:
            control: Editbox
            min: 0
            max: 100
            right: "out of 100"

    # ── Treatment and Contact (D19-D23) ──
    - id: b_treatment_contact
      title: "Treatment and Contact"
      items:
        # D19: Government treatment of immigrants vs natives (born in country only)
        - id: q_d19
          kind: Question
          title: "Compared to people like yourself who were born in this country, how do you think the government treats those who have recently come to live here from other countries?"
          precondition:
            - predicate: "born_in_country == 1"
          input:
            control: Radio
            labels:
              1: "Much better"
              2: "A little better"
              3: "The same"
              4: "A little worse"
              5: "Much worse"

        # D20: Impact on religious beliefs and practices
        - id: q_d20
          kind: Question
          title: "Do you think the religious beliefs and practices in this country are generally undermined or enriched by people coming to live here from other countries?"
          input:
            control: Slider
            min: 0
            max: 10
            left: "Religious beliefs and practices undermined"
            right: "Religious beliefs and practices enriched"

        # D21: Close friends of different race/ethnic group
        - id: q_d21
          kind: Question
          title: "Do you have any close friends who are of a different race or ethnic group from most people in this country?"
          input:
            control: Radio
            labels:
              1: "Yes, several"
              2: "Yes, a few"
              3: "No, none at all"

        # D22: Frequency of contact with different race/ethnic group
        # 1 (Never) → skip D23; 2-7 → ask D23
        - id: q_d22
          kind: Question
          title: "How often do you have any contact with people who are of a different race or ethnic group from most people in this country when you are out and about?"
          input:
            control: Radio
            labels:
              1: "Never"
              2: "Less than once a month"
              3: "Once a month"
              4: "Several times a month"
              5: "Once a week"
              6: "Several times a week"
              7: "Every day"

        # D23: Quality of contact (only if D22 != 1)
        - id: q_d23
          kind: Question
          title: "Thinking about this contact, in general how bad or good is it?"
          precondition:
            - predicate: "q_d22.outcome != 1"
          input:
            control: Slider
            min: 0
            max: 10
            left: "Extremely bad"
            right: "Extremely good"

    # ── Race, Ethnicity, Culture (D24-D27) ──
    - id: b_race_culture
      title: "Race, Ethnicity, and Culture"
      items:
        # D24: Some races born less intelligent
        - id: q_d24
          kind: Question
          title: "Do you think some races or ethnic groups are born less intelligent than others?"
          input:
            control: Radio
            labels:
              1: "Yes, definitely"
              2: "Yes, probably"
              3: "No, probably not"
              4: "No, definitely not"

        # D25: Some races born harder working
        - id: q_d25
          kind: Question
          title: "Do you think some races or ethnic groups are born harder working than others?"
          input:
            control: Radio
            labels:
              1: "Yes, definitely"
              2: "Yes, probably"
              3: "No, probably not"
              4: "No, definitely not"

        # D26: Some cultures much better than others
        - id: q_d26
          kind: Question
          title: "Thinking about the world today, would you say that some cultures are much better than others?"
          input:
            control: Radio
            labels:
              1: "Yes, definitely"
              2: "Yes, probably"
              3: "No, probably not"
              4: "No, definitely not"

        # D27: Protect national culture from influence
        - id: q_d27
          kind: Question
          title: "Do you think that we should protect this country's culture from the influence of other cultures?"
          input:
            control: Radio
            labels:
              1: "Yes, definitely"
              2: "Yes, probably"
              3: "No, probably not"
              4: "No, definitely not"

    # ── Group-Specific Attitudes and Split-Sample Experiment (D28-D30d) ──
    - id: b_group_specific
      title: "Group-Specific Attitudes"
      items:
        # D28: Allow Jewish people
        - id: q_d28
          kind: Question
          title: "To what extent do you think this country should allow Jewish people from other countries to come and live here?"
          input:
            control: Radio
            labels:
              1: "Allow many to come and live here"
              2: "Allow some"
              3: "Allow a few"
              4: "Allow none"

        # D29: Allow Muslims
        - id: q_d29
          kind: Question
          title: "To what extent do you think this country should allow Muslims from other countries to come and live here?"
          input:
            control: Radio
            labels:
              1: "Allow many to come and live here"
              2: "Allow some"
              3: "Allow a few"
              4: "Allow none"

        # D30a: Split-sample A — Christians from European non-EU country, war
        - id: q_d30a
          kind: Question
          title: "Imagine a situation where Christians from a European country outside the EU have to leave their country because war makes their homes unsafe. To what extent do you think this country should allow them to come and live here?"
          precondition:
            - predicate: "sample_group == 1"
          input:
            control: Radio
            labels:
              1: "Allow many to come and live here"
              2: "Allow some"
              3: "Allow a few"
              4: "Allow none"

        # D30b: Split-sample B — Christians from European non-EU country, unemployment
        - id: q_d30b
          kind: Question
          title: "Imagine a situation where Christians from a European country outside the EU have to leave their country because they are unemployed due to a lack of work. To what extent do you think this country should allow them to come and live here?"
          precondition:
            - predicate: "sample_group == 2"
          input:
            control: Radio
            labels:
              1: "Allow many to come and live here"
              2: "Allow some"
              3: "Allow a few"
              4: "Allow none"

        # D30c: Split-sample C — Muslims from Middle Eastern country, war
        - id: q_d30c
          kind: Question
          title: "Imagine a situation where Muslims from a Middle Eastern country have to leave their country because war makes their homes unsafe. To what extent do you think this country should allow them to come and live here?"
          precondition:
            - predicate: "sample_group == 3"
          input:
            control: Radio
            labels:
              1: "Allow many to come and live here"
              2: "Allow some"
              3: "Allow a few"
              4: "Allow none"

        # D30d: Split-sample D — Muslims from Middle Eastern country, unemployment
        - id: q_d30d
          kind: Question
          title: "Imagine a situation where Muslims from a Middle Eastern country have to leave their country because they are unemployed due to a lack of work. To what extent do you think this country should allow them to come and live here?"
          precondition:
            - predicate: "sample_group == 4"
          input:
            control: Radio
            labels:
              1: "Allow many to come and live here"
              2: "Allow some"
              3: "Allow a few"
              4: "Allow none"
