qmlVersion: "1.0"
questionnaire:
  title: "European Social Survey Round 12"
  codeInit: |
    # =====================================================================
    # Cross-section variables. With a single codeInit scope and one
    # dependency graph, variables written by an earlier block are visible
    # to every later block without any extern declaration.
    # =====================================================================
    has_partner = 0
    has_children_in_hh = 0
    has_work_history = 0
    in_paid_work = 0
    b16_multiple = 0
    partner_in_paid_work = 0
    partner_has_work = 0
    b45_multiple = 0

  blocks:

    # ===================================================================
    # SECTION: self_completion_intro
    # ===================================================================
    # Section S — Self-Completion Introduction (inventory items S1-S6).
    # Routes between the intended respondent (next-birthday selection), a
    # pass-off message if the wrong person opened the form, the age screen,
    # and the parental-consent gate for under-18 respondents. The rest of
    # the questionnaire runs for respondents who clear this preamble; the
    # survey-termination edge case (S4=2) cannot be modelled as a termination
    # in QML and is documented here as a known limitation.
    # ===================================================================
    - id: b_self_completion_intro
      title: "Self-Completion Introduction"
      items:
        - id: q_s1
          kind: Question
          title: "Are you the person aged 15 or over in your household who has the NEXT birthday?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: q_s2
          kind: Comment
          title: "As stated in the letter you received, we need the person with the NEXT birthday to complete the survey. Please pass the invitation letter to the person (aged 15 or over) in your household with the NEXT birthday and ask them to complete the survey instead."
          precondition:
            - predicate: q_s1.outcome == 2

        - id: q_s3
          kind: Comment
          title: "Welcome to the survey. Thank you for taking part."
          precondition:
            - predicate: q_s1.outcome == 2

        - id: q_s4
          kind: Question
          title: "Are you the person aged 15 or over in your household who has the NEXT birthday?"
          precondition:
            - predicate: q_s1.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: q_s5
          kind: Question
          title: "Are you…?"
          input:
            control: Radio
            labels:
              1: "Aged 18 or over"
              2: "Aged under 18"

        - id: q_s6
          kind: Question
          title: "You are required to obtain permission from a parent/guardian in order to complete this survey. Please confirm below."
          precondition:
            - predicate: q_s5.outcome == 2
          input:
            control: Radio
            labels:
              1: "I confirm I have permission from a parent/guardian to complete this survey"

    # ===================================================================
    # SECTION: local_area_climate
    # ===================================================================
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

    # ===================================================================
    # SECTION: media_internet
    # ===================================================================
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

    # ===================================================================
    # SECTION: social_trust_politics
    # ===================================================================
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

    # ===================================================================
    # SECTION: institutional_trust
    # ===================================================================
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

    # ===================================================================
    # SECTION: voting_participation
    # ===================================================================
    - id: b_voting
      title: "Voting"
      items:
        # A26: Voted in last national election
        - id: q_a26
          kind: Question
          title: "Some people don't vote nowadays for one reason or another. Did you vote in the last [country] national election in [month/year]?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Not eligible to vote"

        # A27: Party voted for (country-specific)
        - id: q_a27
          kind: Question
          title: "Which party did you vote for in that election?"
          precondition:
            - predicate: q_a26.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Party 1"
              2: "Party 2"
              3: "Party 3"
              4: "Party 4"
              5: "Party 5"
              6: "Party 6"
              7: "Party 7"
              8: "Party 8"
              9: "Party 9"
              10: "Party 10"
              11: "Party 11"
              12: "Party 12"
              13: "Party 13"
              14: "Party 14"
              15: "Party 15"
              16: "Party 16"
              17: "Party 17"
              18: "Party 18"
              19: "Party 19"
              20: "Party 20"
              21: "Other"

    - id: b_participation
      title: "Political Participation"
      items:
        # A28: Contacted politician
        - id: q_a28
          kind: Question
          title: "During the last 12 months, have you contacted a politician, government or local government official?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # A29: Donated to or participated in political party/pressure group
        - id: q_a29
          kind: Question
          title: "During the last 12 months, have you donated to or participated in a political party or pressure group?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # A30: Worn/displayed campaign badge/sticker
        - id: q_a30
          kind: Question
          title: "During the last 12 months, have you worn or displayed a campaign badge/sticker?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # A31: Signed a petition
        - id: q_a31
          kind: Question
          title: "During the last 12 months, have you signed a petition?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # A32: Taken part in public demonstration
        - id: q_a32
          kind: Question
          title: "During the last 12 months, have you taken part in a public demonstration?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # A33: Boycotted certain products
        - id: q_a33
          kind: Question
          title: "During the last 12 months, have you boycotted certain products?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # A34: Posted/shared political content online
        - id: q_a34
          kind: Question
          title: "During the last 12 months, have you posted or shared anything about politics online, for example on blogs, via email or on social media such as Facebook, Instagram, TikTok, or X (formerly known as Twitter)?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # A35: Volunteered for not-for-profit/charitable organisation
        - id: q_a35
          kind: Question
          title: "During the last 12 months, have you volunteered for a not-for-profit or charitable organisation?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

    - id: b_party_allegiance
      title: "Party Allegiance"
      items:
        # A36: Feel closer to a particular party
        - id: q_a36
          kind: Question
          title: "Is there a particular political party you feel closer to than all the other parties?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # A37: Which party feel closest to (country-specific)
        - id: q_a37
          kind: Question
          title: "Which political party do you feel closest to?"
          precondition:
            - predicate: q_a36.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Party 1"
              2: "Party 2"
              3: "Party 3"
              4: "Party 4"
              5: "Party 5"
              6: "Party 6"
              7: "Party 7"
              8: "Party 8"
              9: "Party 9"
              10: "Party 10"
              11: "Party 11"
              12: "Party 12"
              13: "Party 13"
              14: "Party 14"
              15: "Party 15"
              16: "Party 16"
              17: "Party 17"
              18: "Party 18"
              19: "Party 19"
              20: "Party 20"
              21: "Other"

        # A38: How close to party
        - id: q_a38
          kind: Question
          title: "How close do you feel to this party?"
          precondition:
            - predicate: q_a36.outcome == 1
          input:
            control: Radio
            labels:
              1: "Very close"
              2: "Quite close"
              3: "Not close"
              4: "Not at all close"

    # ===================================================================
    # SECTION: satisfaction_attitudes
    # ===================================================================
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

    # ===================================================================
    # SECTION: wellbeing_social_crime
    # ===================================================================
    # =========================================================================
    # BLOCK 1: SUBJECTIVE WELLBEING AND SOCIAL LIFE (A60-A63)
    # =========================================================================
    - id: b_wellbeing_social
      title: "Subjective Wellbeing and Social Life"
      items:
        # A60: Happiness (0–10 scale)
        - id: q_a60
          kind: Question
          title: "Taking all things together, how happy would you say you are?"
          input:
            control: Slider
            min: 0
            max: 10
            step: 1
            left: "Extremely unhappy"
            right: "Extremely happy"

        # A61: Social meeting frequency
        - id: q_a61
          kind: Question
          title: "How often do you meet socially with friends, relatives or work colleagues?"
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

        # A62: Number of people for intimate discussion
        - id: q_a62
          kind: Question
          title: "How many people, if any, are there with whom you can discuss intimate and personal matters?"
          input:
            control: Radio
            labels:
              0: "None"
              1: "1"
              2: "2"
              3: "3"
              4: "4-6"
              5: "7-9"
              6: "10 or more"

        # A63: Social activity compared to peers
        - id: q_a63
          kind: Question
          title: "Compared to other people of your age, how often would you say you take part in social activities?"
          input:
            control: Radio
            labels:
              1: "Much less than most"
              2: "Less than most"
              3: "About the same"
              4: "More than most"
              5: "Much more than most"

    # =========================================================================
    # BLOCK 2: CRIME AND SAFETY (A64-A65)
    # =========================================================================
    - id: b_crime_safety
      title: "Crime and Safety"
      items:
        # A64: Crime victimization (Yes/No)
        - id: q_a64
          kind: Question
          title: "Have you or a member of your household been the victim of a burglary or assault in the last 5 years?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # A65: Safety feeling walking alone after dark
        - id: q_a65
          kind: Question
          title: "How safe do you - or would you - feel walking alone in the area you live after dark?"
          input:
            control: Radio
            labels:
              1: "Very safe"
              2: "Safe"
              3: "Unsafe"
              4: "Very unsafe"

    # =========================================================================
    # BLOCK 3: GENERAL HEALTH (A66-A67)
    # =========================================================================
    - id: b_health
      title: "General Health"
      items:
        # A66: Self-rated general health
        - id: q_a66
          kind: Question
          title: "How is your health in general?"
          input:
            control: Radio
            labels:
              1: "Very good"
              2: "Good"
              3: "Fair"
              4: "Bad"
              5: "Very bad"

        # A67: Hampered by longstanding illness/disability
        - id: q_a67
          kind: Question
          title: "Are you hampered in your daily activities in any way by any longstanding illness, or disability, infirmity or mental health problem?"
          input:
            control: Radio
            labels:
              1: "Yes a lot"
              2: "Yes to some extent"
              3: "No"

    # =========================================================================
    # BLOCK 4: NATIONAL AND EUROPEAN ATTACHMENT (A68-A69)
    # =========================================================================
    - id: b_attachment
      title: "National and European Attachment"
      items:
        # A68: Emotional attachment to country (0–10 scale)
        - id: q_a68
          kind: Question
          title: "How emotionally attached do you feel to [country]?"
          input:
            control: Slider
            min: 0
            max: 10
            step: 1
            left: "Not at all emotionally attached"
            right: "Very emotionally attached"

        # A69: Emotional attachment to Europe (0–10 scale)
        - id: q_a69
          kind: Question
          title: "And how emotionally attached do you feel to Europe?"
          input:
            control: Slider
            min: 0
            max: 10
            step: 1
            left: "Not at all emotionally attached"
            right: "Very emotionally attached"

    # ===================================================================
    # SECTION: religion_identity
    # ===================================================================
    # =========================================================================
    # BLOCK 1: RELIGION (A70-A76)
    # =========================================================================
    # Routing chain:
    #   A70=1 (Yes) → A71 → skip to A74
    #   A70=0 (No)  → A72=1 (Yes) → A73 → A74
    #                  A72=0 (No)  → A74
    #   A74-A76: ASK ALL
    # =========================================================================
    - id: b_religion
      title: "Religion"
      items:
        # A70: Belong to a religion? (Yes/No)
        - id: q_a70
          kind: Question
          title: "Do you consider yourself as belonging to any particular religion or denomination?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # A71: Current religion denomination
        # ASK IF A70 = Yes (1). After answering → skip to A74
        - id: q_a71
          kind: Question
          title: "Which religion or denomination do you belong to?"
          precondition:
            - predicate: q_a70.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Roman Catholic"
              2: "Protestant"
              3: "Eastern Orthodox"
              4: "Other Christian denomination"
              5: "Jewish"
              6: "Islam"
              7: "Eastern religions (Buddhism, Hinduism, etc.)"
              8: "Other non-Christian religions"
              9: "Evangelical"
              10: "Pentecostal"
              11: "Anglican"
              12: "Methodist"
              13: "Baptist"
              14: "Lutheran"
              15: "Presbyterian"
              16: "Other"

        # A72: Ever belonged to a religion?
        # ASK IF A70 = No (0)
        - id: q_a72
          kind: Question
          title: "Have you ever considered yourself as belonging to any particular religion or denomination?"
          precondition:
            - predicate: q_a70.outcome == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # A73: Past religion denomination
        # ASK IF A70 = No (0) AND A72 = Yes (1)
        - id: q_a73
          kind: Question
          title: "Which religion or denomination did you belong to in the past?"
          precondition:
            - predicate: q_a70.outcome == 0
            - predicate: q_a72.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Roman Catholic"
              2: "Protestant"
              3: "Eastern Orthodox"
              4: "Other Christian denomination"
              5: "Jewish"
              6: "Islam"
              7: "Eastern religions (Buddhism, Hinduism, etc.)"
              8: "Other non-Christian religions"
              9: "Evangelical"
              10: "Pentecostal"
              11: "Anglican"
              12: "Methodist"
              13: "Baptist"
              14: "Lutheran"
              15: "Presbyterian"
              16: "Other"

        # A74: Religiosity (0–10 scale) — ASK ALL
        - id: q_a74
          kind: Question
          title: "Regardless of whether you belong to a particular religion, how religious would you say you are?"
          input:
            control: Slider
            min: 0
            max: 10
            step: 1
            left: "Not at all religious"
            right: "Very religious"

        # A75: Religious service attendance — ASK ALL
        - id: q_a75
          kind: Question
          title: "Apart from special occasions such as weddings and funerals, about how often do you attend religious services nowadays?"
          input:
            control: Radio
            labels:
              1: "Every day"
              2: "More than once a week"
              3: "Once a week"
              4: "At least once a month"
              5: "Only on special holy days"
              6: "Less often"
              7: "Never"

        # A76: Prayer frequency — ASK ALL
        - id: q_a76
          kind: Question
          title: "Apart from when you are at religious services, how often, if at all, do you pray?"
          input:
            control: Radio
            labels:
              1: "Every day"
              2: "More than once a week"
              3: "Once a week"
              4: "At least once a month"
              5: "Only on special holy days"
              6: "Less often"
              7: "Never"

    # =========================================================================
    # BLOCK 2: DISCRIMINATION (A77-A78)
    # =========================================================================
    # Routing: A77=1 (Yes) → A78; A77=0 (No) → skip A78
    # =========================================================================
    - id: b_discrimination
      title: "Discrimination"
      items:
        # A77: Member of discriminated group? (Yes/No)
        - id: q_a77
          kind: Question
          title: "Would you describe yourself as being a member of a group that is discriminated against in this country?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # A78: Grounds for discrimination (multi-select)
        # ASK IF A77 = Yes (1). Checkbox keys are powers of 2.
        - id: q_a78
          kind: Question
          title: "On what grounds is your group discriminated against?"
          precondition:
            - predicate: q_a77.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "Colour or race"
              2: "Nationality"
              4: "Religion"
              8: "Language"
              16: "Ethnic group"
              32: "Age"
              64: "Gender"
              128: "Sexuality"
              256: "Disability"
              512: "Other"

    # =========================================================================
    # BLOCK 3: CITIZENSHIP AND IMMIGRATION BACKGROUND (A79-A84)
    # =========================================================================
    # Routing:
    #   A79: ASK ALL
    #   A80=1 (Yes, born in country) → skip to A83
    #   A80=0 (No) → A81, A82 → A83
    #   A83, A84: ASK ALL
    # =========================================================================
    - id: b_citizenship
      title: "Citizenship and Immigration Background"
      items:
        # A79: Citizen of country? — ASK ALL
        - id: q_a79
          kind: Question
          title: "Are you a citizen of [country]?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # A80: Born in country?
        - id: q_a80
          kind: Question
          title: "Were you born in [country]?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # A81: Country born in (open text)
        # ASK IF A80 = No (0)
        - id: q_a81
          kind: Question
          title: "In which country were you born?"
          precondition:
            - predicate: q_a80.outcome == 0
          input:
            control: Textarea
            placeholder: "Enter country name"

        # A82: Year first came to live in country
        # ASK IF A80 = No (0)
        - id: q_a82
          kind: Question
          title: "What year did you first come to live in [country]?"
          precondition:
            - predicate: q_a80.outcome == 0
          input:
            control: Editbox
            min: 1900
            max: 2026

        # A83: Languages spoken at home (open text) — ASK ALL
        - id: q_a83
          kind: Question
          title: "What language or languages do you speak most often at home?"
          input:
            control: Textarea
            placeholder: "Enter up to two languages"

        # A84: Same race/ethnic group as majority? — ASK ALL
        - id: q_a84
          kind: Question
          title: "Do you feel you are part of the same race or ethnic group as most people in [country]?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # =========================================================================
    # BLOCK 4: PARENTS' BIRTHPLACE (A85-A88)
    # =========================================================================
    # Routing:
    #   A85=1 or 7 (Yes/Prefer not to answer) → skip to A87
    #   A85=0 (No) → A86 → A87
    #   A87=1 or 7 (Yes/Prefer not to answer) → skip to A89
    #   A87=0 (No) → A88
    #
    # Note: Source uses {1: Yes, 2: No, 7: Prefer not to answer} but Switch
    # only supports 0/1. Use Radio for A85 and A87 since they have 3 options.
    # =========================================================================
    - id: b_parents_birthplace
      title: "Parents' Birthplace"
      items:
        # A85: Father born in country?
        # Three options (Yes/No/Prefer not to answer) → Radio
        - id: q_a85
          kind: Question
          title: "Was your father born in [country]?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Prefer not to answer"

        # A86: Father's birth country (open text)
        # ASK IF A85 = 2 (No)
        - id: q_a86
          kind: Question
          title: "In which country was your father born?"
          precondition:
            - predicate: q_a85.outcome == 2
          input:
            control: Textarea
            placeholder: "Enter country name"

        # A87: Mother born in country?
        # Three options (Yes/No/Prefer not to answer) → Radio — ASK ALL
        - id: q_a87
          kind: Question
          title: "Was your mother born in [country]?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Prefer not to answer"

        # A88: Mother's birth country (open text)
        # ASK IF A87 = 2 (No)
        - id: q_a88
          kind: Question
          title: "In which country was your mother born?"
          precondition:
            - predicate: q_a87.outcome == 2
          input:
            control: Textarea
            placeholder: "Enter country name"

    # =========================================================================
    # BLOCK 5: EU REFERENDUM (A89a-A89b)
    # =========================================================================
    # Mutually exclusive country variants controlled by extern is_eu_member.
    # Only one of A89a or A89b is asked per country.
    # =========================================================================
    - id: b_eu_referendum
      title: "EU Referendum"
      items:
        # A89a: EU member country version
        # ASK IF country is an EU member
        - id: q_a89a
          kind: Question
          title: "Imagine there were a referendum in [country] tomorrow about membership of the European Union. Would you vote for [country] to remain a member of the European Union or to leave the European Union?"
          precondition:
            - predicate: is_eu_member == 1
          input:
            control: Radio
            labels:
              1: "Remain a member of the European Union"
              2: "Leave the European Union"
              33: "(Would submit a blank ballot paper)"
              44: "(Would spoil the ballot paper)"
              55: "(Would not vote)"
              65: "(Not eligible to vote)"

        # A89b: Non-EU member country version
        # ASK IF country is NOT an EU member
        - id: q_a89b
          kind: Question
          title: "Imagine there were a referendum in [country] tomorrow about membership of the European Union. Would you vote for [country] to become a member of the European Union or to remain outside the European Union?"
          precondition:
            - predicate: is_eu_member == 0
          input:
            control: Radio
            labels:
              1: "Become a member of the European Union"
              2: "Remain outside the European Union"
              33: "(Would submit a blank ballot paper)"
              44: "(Would spoil the ballot paper)"
              55: "(Would not vote)"
              65: "(Not eligible to vote)"

    # ===================================================================
    # SECTION: household_demographics
    # ===================================================================
    # =========================================================================
    # BLOCK 1: HOUSEHOLD COMPOSITION (B1-B4)
    # =========================================================================
    - id: b_household_composition
      title: "Household Composition"
      items:
        # B1: Household size (including respondent)
        - id: q_b1
          kind: Question
          title: "Including yourself and any children, how many people live here regularly as members of your household?"
          input:
            control: Editbox
            min: 1
            max: 30

        # B2: Adults aged 15+ in household
        # Postcondition: must not exceed total household size
        - id: q_b2
          kind: Question
          title: "And how many of the people in your household are aged 15 or older, including yourself?"
          postcondition:
            - predicate: q_b2.outcome <= q_b1.outcome
              hint: "Number of adults cannot exceed total household size."
            - predicate: q_b2.outcome >= 1
              hint: "There must be at least one adult (the respondent)."
          input:
            control: Editbox
            min: 1
            max: 30

        # B3: Sex of respondent
        - id: q_b3
          kind: Question
          title: "What is your sex?"
          input:
            control: Radio
            labels:
              1: "Male"
              2: "Female"

        # B4: Birth month and year — modelled as two separate questions
        # B4 month
        - id: q_b4_month
          kind: Question
          title: "In which month were you born?"
          input:
            control: Editbox
            min: 1
            max: 12
            left: "Month:"

        # B4 year
        - id: q_b4_year
          kind: Question
          title: "In which year were you born?"
          input:
            control: Editbox
            min: 1900
            max: 2011
            left: "Year:"

    # =========================================================================
    # BLOCK 2: HOUSEHOLD ROSTER (HHName, B5, B6, B7) — JUSTIFIED OMISSION
    # =========================================================================
    # The source questionnaire collects first name/initial, sex, birth date,
    # and relationship for each additional household member (up to 8 persons),
    # repeating HHName, B5, B6, B7 dynamically per member. QML does not
    # support truly dynamic rosters (variable-length repeating item groups
    # determined at runtime by B1). This section is documented as a justified
    # omission.
    #
    # The relationship data (B7) determines downstream routing:
    #   - B7 = 1 for any member → has_partner = 1
    #   - B7 = 2 for any member → has_children_in_hh = 1
    # These are modelled as extern-like variables initialized in codeInit
    # and would be set by the roster in a full implementation.
    # =========================================================================
    - id: b_household_roster
      title: "Household Members"
      precondition:
        - predicate: q_b1.outcome > 1
      items:
        - id: q_roster_note
          kind: Comment
          title: "The following section would collect details (name, sex, birth date, relationship) for each additional household member. This dynamic roster cannot be fully represented in QML's static item structure and is omitted. Downstream routing uses the has_partner and has_children_in_hh variables."

    # =========================================================================
    # BLOCK 3: MARITAL STATUS (B8-B12)
    # =========================================================================
    # Routing:
    #   B8: ASK IF has_partner = 1 (B7=1 for any household member)
    #       B8 in {1,2} (married/civil union) → B9
    #       B8 in {3,4} (cohabiting) → B10
    #       B8 in {5,6} (separated/divorced) → B9
    #   B9: ASK IF has_partner=0 OR B8 in {1,2,5,6}
    #   B10: ASK ALL
    #   B11: ASK IF has_partner=0 OR B8 in {3,4}
    #   B12: ASK IF has_children_in_hh = 0 (no B7=2)
    # =========================================================================
    - id: b_marital_status
      title: "Marital Status"
      items:
        # B8: Relationship description with partner
        # ASK IF has_partner (living with husband/wife/partner)
        - id: q_b8
          kind: Question
          title: "Which one of the descriptions from the following list describes your relationship to your husband, wife, or partner?"
          precondition:
            - predicate: has_partner == 1
          input:
            control: Radio
            labels:
              1: "Legally married"
              2: "In a legally registered civil union"
              3: "Living with partner (cohabiting) - not legally recognised"
              4: "Living with partner (cohabiting) - legally recognised"
              5: "Legally separated"
              6: "Legally divorced or civil union dissolved"

        # B9: Ever lived with partner without marriage/civil union?
        # ASK IF not living with partner, OR B8 in {1,2,5,6}
        # When has_partner=0, B8 is not reached so we check that case first.
        # When has_partner=1, B8 is answered; show B9 for married/separated/divorced.
        - id: q_b9
          kind: Question
          title: "Have you ever lived with a partner without being married to them or in a civil union?"
          precondition:
            - predicate: has_partner == 0 or q_b8.outcome in [1, 2, 5, 6]
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # B10: Ever divorced or civil union dissolved? — ASK ALL
        - id: q_b10
          kind: Question
          title: "Have you ever been divorced or had a civil union dissolved?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # B11: Legal marital status
        # ASK IF not living with partner, OR B8 in {3,4} (cohabiting)
        - id: q_b11
          kind: Question
          title: "Which one of the descriptions from the following list describes your legal marital status now?"
          precondition:
            - predicate: has_partner == 0 or q_b8.outcome in [3, 4]
          input:
            control: Radio
            labels:
              1: "Legally married"
              2: "In a legally registered civil union"
              3: "Legally separated"
              4: "Legally divorced or civil union dissolved"
              5: "Widowed or civil partner died"
              6: "None of these (NEVER married or in legally registered civil union)"

        # B12: Ever had children living in household?
        # ASK IF no children currently in household
        - id: q_b12
          kind: Question
          title: "Have you ever had any children of your own, step-children, adopted children, foster children or a partner's children living in your household?"
          precondition:
            - predicate: has_children_in_hh == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # =========================================================================
    # BLOCK 4: AREA TYPE (B13)
    # =========================================================================
    - id: b_area_type
      title: "Area Description"
      items:
        # B13: Type of area — ASK ALL
        - id: q_b13
          kind: Question
          title: "Which of the following phrases best describes the area where you live?"
          input:
            control: Radio
            labels:
              1: "A big city"
              2: "The suburbs or outskirts of a big city"
              3: "A town or a small city"
              4: "A country village"
              5: "A farm or home in the countryside"

    # ===================================================================
    # SECTION: education_employment
    # ===================================================================
    # =========================================================================
    # EDUCATION (B14-B15)
    # =========================================================================
    # B14a/b: Highest education level — country-specific ISCED mapping.
    #   Generic ISCED levels used here. ASK ALL.
    # B15: Years of full-time education. ASK ALL.
    # =========================================================================
    - id: b_education
      title: "Education"
      items:
        # B14a/B14b: Highest level of education
        - id: q_b14
          kind: Question
          title: "What is the highest level of education you have achieved?"
          input:
            control: Dropdown
            labels:
              1: "Less than lower secondary (ISCED 0-1)"
              2: "Lower secondary (ISCED 2)"
              3: "Lower tier upper secondary (ISCED 3)"
              4: "Upper tier upper secondary (ISCED 3)"
              5: "Advanced vocational / sub-degree (ISCED 4)"
              6: "Lower tertiary education, BA level (ISCED 5)"
              7: "Higher tertiary education, MA/PhD level (ISCED 6+)"
              8: "Other"

        # B15: Years of full-time education completed
        - id: q_b15
          kind: Question
          title: "About how many years of education have you completed, whether full-time or part-time? Please report in full-time equivalents."
          input:
            control: Editbox
            min: 0
            max: 50
            right: "years"

    # =========================================================================
    # ACTIVITY STATUS (B16-B20)
    # =========================================================================
    # B16: Multi-select activity status (Checkbox, power-of-2 keys). ASK ALL.
    #   If more than one selected → B17 (main activity).
    #   If "In paid work" selected (bit 0) → set in_paid_work=1, has_work_history=1.
    #   If B16 does NOT include "In paid work" → B18.
    #
    # B17: Main activity (single select from B16 options).
    #   Precondition: b16_multiple == 1.
    #
    # B18: Did paid work in last 7 days? Switch.
    #   Precondition: in_paid_work == 0 (not in paid work at B16).
    #   Yes → B21; No → B19.
    #
    # B19: Ever had a paid job? Switch.
    #   Precondition: q_b18.outcome == 0 (no paid work in last 7 days).
    #   Yes → B20; No → skip to B37 (next file).
    #
    # B20: Year last in paid job. Editbox.
    #   Precondition: q_b19.outcome == 1.
    # =========================================================================
    - id: b_activity
      title: "Activity Status"
      items:
        # B16: Activity in last 7 days — multi-select
        - id: q_b16
          kind: Question
          title: "Which of the following descriptions applies to what you have been doing for the last 7 days? Select all that apply."
          codeBlock: |
            if q_b16.outcome % 2 == 1:
                in_paid_work = 1
                has_work_history = 1
            b16_count = 0
            if q_b16.outcome % 2 >= 1:
                b16_count = b16_count + 1
            if q_b16.outcome % 4 >= 2:
                b16_count = b16_count + 1
            if q_b16.outcome % 8 >= 4:
                b16_count = b16_count + 1
            if q_b16.outcome % 16 >= 8:
                b16_count = b16_count + 1
            if q_b16.outcome % 32 >= 16:
                b16_count = b16_count + 1
            if q_b16.outcome % 64 >= 32:
                b16_count = b16_count + 1
            if q_b16.outcome % 128 >= 64:
                b16_count = b16_count + 1
            if q_b16.outcome % 256 >= 128:
                b16_count = b16_count + 1
            if q_b16.outcome % 512 >= 256:
                b16_count = b16_count + 1
            if b16_count > 1:
                b16_multiple = 1
          input:
            control: Checkbox
            labels:
              1: "In paid work (or away temporarily — employee, self-employed, working for family business)"
              2: "In education (not paid for by employer) even if on vacation"
              4: "Unemployed and actively looking for a job"
              8: "Unemployed, wanting a job but not actively looking for a job"
              16: "Permanently sick or disabled"
              32: "Retired"
              64: "In community or military service"
              128: "Doing housework, looking after children or other persons"
              256: "Other"

        # B17: Main activity — asked only when multiple activities selected
        - id: q_b17
          kind: Question
          title: "And which of these descriptions best describes your situation in the last 7 days?"
          precondition:
            - predicate: b16_multiple == 1
          input:
            control: Radio
            labels:
              1: "In paid work"
              2: "In education"
              3: "Unemployed, actively looking"
              4: "Unemployed, wanting job but not looking"
              5: "Permanently sick or disabled"
              6: "Retired"
              7: "Community or military service"
              8: "Housework, looking after children or others"
              9: "Other"

        # B18: Did any paid work of an hour or more in last 7 days?
        # Precondition: B16 does NOT include "In paid work" (bit 0 not set)
        - id: q_b18
          kind: Question
          title: "Just to check, did you do any paid work of an hour or more in the last 7 days?"
          precondition:
            - predicate: in_paid_work == 0
          codeBlock: |
            if q_b18.outcome == 1:
                has_work_history = 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # B19: Ever had a paid job?
        # Precondition: B18 = No (0)
        - id: q_b19
          kind: Question
          title: "Have you ever had a paid job?"
          precondition:
            - predicate: q_b18.outcome == 0
          codeBlock: |
            if q_b19.outcome == 1:
                has_work_history = 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # B20: Year last in a paid job
        # Precondition: B19 = Yes (1)
        - id: q_b20
          kind: Question
          title: "In what year were you last in a paid job?"
          precondition:
            - predicate: q_b19.outcome == 1
          input:
            control: Editbox
            min: 1950
            max: 2026
            right: "year"

    # =========================================================================
    # EMPLOYMENT DETAILS (B21-B36)
    # =========================================================================
    # Block precondition: has_work_history == 1
    #   (respondent is in paid work, did paid work last week, or ever had a job)
    #
    # B21: Employee / self-employed / family business → Radio {1-3}
    #   2 (self-employed) → B22 (number of employees)
    #   1,3 → skip B22, continue B23
    # B22: Number of employees. Precondition: q_b21.outcome == 2
    # B23-B24: Work contract and workplace size. ASK ALL with work history.
    # B25: Supervise others. 1 → B26; 0 → B27
    # B26: How many supervised. Precondition: q_b25.outcome == 1
    # B27-B28: Work autonomy scales. ASK ALL with work history.
    # B29-B30: Contracted and actual hours. ASK ALL with work history.
    # B31-B35: Occupation text descriptions. ASK ALL with work history.
    # B36: Worked abroad. ASK ALL with work history.
    # =========================================================================
    - id: b_employment
      title: "Employment Details"
      precondition:
        - predicate: has_work_history == 1
      items:
        # B21: Employee or self-employed
        - id: q_b21
          kind: Question
          title: "In your main job, are/were you...?"
          input:
            control: Radio
            labels:
              1: "An employee"
              2: "Self-employed"
              3: "Working for your own family's business"

        # B22: Number of employees (self-employed only)
        - id: q_b22
          kind: Question
          title: "How many employees do/did you have?"
          precondition:
            - predicate: q_b21.outcome == 2
          input:
            control: Editbox
            min: 0
            max: 99999

        # B23: Work contract type
        - id: q_b23
          kind: Question
          title: "Do/did you have a work contract of...?"
          input:
            control: Radio
            labels:
              1: "Unlimited duration"
              2: "Limited duration"
              3: "No contract at all"

        # B24: Workplace size
        - id: q_b24
          kind: Question
          title: "Including yourself, about how many people are/were employed at the place where you usually work/worked?"
          input:
            control: Radio
            labels:
              1: "Under 10"
              2: "10 to 24"
              3: "25 to 99"
              4: "100 to 499"
              5: "500 or more"

        # B25: Supervise other employees
        - id: q_b25
          kind: Question
          title: "In your main job, do/did you have any responsibility for supervising the work of other employees?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # B26: Number of people supervised
        # Precondition: B25 = Yes (1)
        - id: q_b26
          kind: Question
          title: "How many people are/were you responsible for?"
          precondition:
            - predicate: q_b25.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 99999

        # B27: Influence over own daily work
        - id: q_b27
          kind: Question
          title: "How much does/did the management at your work allow you to decide how your own daily work is/was organised?"
          input:
            control: Slider
            min: 0
            max: 10
            left: "I have/had no influence"
            right: "I have/had complete control"

        # B28: Influence over organisational policy
        - id: q_b28
          kind: Question
          title: "How much does/did the management at your work allow you to influence policy decisions about the activities of the organisation?"
          input:
            control: Slider
            min: 0
            max: 10
            left: "I have/had no influence"
            right: "I have/had complete control"

        # B29: Contracted hours per week
        - id: q_b29
          kind: Question
          title: "What are/were your total 'basic' or contracted hours each week in your main job?"
          input:
            control: Editbox
            min: 0
            max: 168
            right: "hours per week"

        # B30: Actual hours per week including overtime
        - id: q_b30
          kind: Question
          title: "Regardless of your basic or contracted hours, how many hours do/did you normally work a week in your main job, including any paid or unpaid overtime?"
          input:
            control: Editbox
            min: 0
            max: 168
            right: "hours per week"

        # B31: Employer's main activity
        - id: q_b31
          kind: Question
          title: "What does/did the firm or organisation you work/worked for mainly make or do?"
          input:
            control: Textarea
            placeholder: "Describe main activity of employer"

        # B32: Type of organisation
        - id: q_b32
          kind: Question
          title: "Which of the following types of organisation do/did you work for?"
          input:
            control: Dropdown
            labels:
              1: "Central or local government"
              2: "Other public sector (such as education and health)"
              3: "A state-owned enterprise"
              4: "A private firm"
              5: "Self-employed"
              6: "Other"

        # B33: Main job title
        - id: q_b33
          kind: Question
          title: "What is/was your main job?"
          input:
            control: Textarea
            placeholder: "Job title"

        # B34: Main tasks in job
        - id: q_b34
          kind: Question
          title: "What do/did you mainly do in this job?"
          input:
            control: Textarea
            placeholder: "Describe main tasks"

        # B35: Training or qualifications needed
        - id: q_b35
          kind: Question
          title: "What training or qualifications are/were needed for this job?"
          input:
            control: Textarea
            placeholder: "Describe required training or qualifications"

        # B36: Worked abroad in last 10 years
        - id: q_b36
          kind: Question
          title: "In the last 10 years have you done any paid work in another country for a period of 6 months or more?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # ===================================================================
    # SECTION: income_parents
    # ===================================================================
    # =========================================================================
    # UNEMPLOYMENT HISTORY (B37-B39)
    # =========================================================================
    # B37: Ever unemployed 3+ months? Switch. ASK ALL.
    #   Yes → B38, B39; No → skip to B40.
    # B38: Any period lasted 12+ months? Switch. Precondition: B37 = Yes.
    # B39: Any period in past 5 years? Switch. Precondition: B37 = Yes.
    # =========================================================================
    - id: b_unemployment
      title: "Unemployment History"
      items:
        # B37: Ever unemployed 3+ months
        - id: q_b37
          kind: Question
          title: "Have you ever been unemployed and seeking work for a period of more than 3 months?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # B38: Any period lasted 12 months or more
        - id: q_b38
          kind: Question
          title: "Have any of these periods of unemployment lasted for 12 months or more?"
          precondition:
            - predicate: q_b37.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # B39: Any period in past 5 years
        - id: q_b39
          kind: Question
          title: "Have any of these periods of unemployment, that lasted more than 3 months, been within the past 5 years?"
          precondition:
            - predicate: q_b37.outcome == 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # =========================================================================
    # UNION AND INCOME (B40-B43)
    # =========================================================================
    # All ASK ALL. No routing.
    # B40: Trade union membership.
    # B41: Main household income source.
    # B42: Household income decile (country-specific, simplified to 10 bands).
    # B43: Feeling about household income.
    # =========================================================================
    - id: b_income
      title: "Union Membership and Household Income"
      items:
        # B40: Trade union membership
        - id: q_b40
          kind: Question
          title: "Are you or have you ever been a member of a trade union or similar organisation?"
          input:
            control: Radio
            labels:
              1: "Yes, currently"
              2: "Yes, previously"
              3: "No"

        # B41: Main source of household income
        - id: q_b41
          kind: Question
          title: "Please consider the income of all household members and any income which may be received by the household as a whole. What is the main source of income in your household?"
          input:
            control: Dropdown
            labels:
              1: "Wages or salaries"
              2: "Income from self-employment (excluding farming)"
              3: "Income from farming"
              4: "Pensions"
              5: "Unemployment/redundancy benefit"
              6: "Any other social benefits or grants"
              7: "Income from investment, savings, insurance or property"
              8: "Income from other sources"

        # B42: Household income decile (country-specific bands simplified)
        - id: q_b42
          kind: Question
          title: "Which of the following descriptions comes closest to your household's total net income from all sources, after tax and compulsory deductions?"
          input:
            control: Dropdown
            labels:
              1: "1st decile (lowest)"
              2: "2nd decile"
              3: "3rd decile"
              4: "4th decile"
              5: "5th decile"
              6: "6th decile"
              7: "7th decile"
              8: "8th decile"
              9: "9th decile"
              10: "10th decile (highest)"

        # B43: Feeling about household income
        - id: q_b43
          kind: Question
          title: "Which of the following descriptions comes closest to how you feel about your household's income nowadays?"
          input:
            control: Radio
            labels:
              1: "Living comfortably on present income"
              2: "Coping on present income"
              3: "Finding it difficult on present income"
              4: "Finding it very difficult on present income"

    # =========================================================================
    # PARTNER DETAILS (B44-B52)
    # =========================================================================
    # Block precondition: has_partner == 1
    #
    # B44: Partner's highest education — Dropdown (ISCED). ASK ALL with partner.
    # B45: Partner's activity status — Checkbox (power-of-2).
    #   If more than one selected → B46.
    #   If partner NOT in paid work → B47.
    #   If partner in paid work → B48.
    # B46: Partner's main activity — Radio. Precondition: b45_multiple == 1.
    # B47: Partner did paid work? Switch.
    #   Precondition: partner_in_paid_work == 0.
    #   Yes → B48; No → skip to B53.
    # B48-B52: Partner's job details.
    #   Precondition: partner_has_work == 1.
    # =========================================================================
    - id: b_partner
      title: "Partner's Background"
      precondition:
        - predicate: has_partner == 1
      items:
        # B44a/B44b: Partner's highest education level
        - id: q_b44
          kind: Question
          title: "What is the highest level of education your husband, wife, or partner has achieved?"
          input:
            control: Dropdown
            labels:
              1: "Less than lower secondary (ISCED 0-1)"
              2: "Lower secondary (ISCED 2)"
              3: "Lower tier upper secondary (ISCED 3)"
              4: "Upper tier upper secondary (ISCED 3)"
              5: "Advanced vocational / sub-degree (ISCED 4)"
              6: "Lower tertiary education, BA level (ISCED 5)"
              7: "Higher tertiary education, MA/PhD level (ISCED 6+)"
              8: "Other"

        # B45: Partner's activity in last 7 days — multi-select
        - id: q_b45
          kind: Question
          title: "Which of the following descriptions applies to what your husband, wife, or partner has been doing for the last 7 days? Select all that apply."
          codeBlock: |
            if q_b45.outcome % 2 == 1:
                partner_in_paid_work = 1
                partner_has_work = 1
            b45_count = 0
            if q_b45.outcome % 2 >= 1:
                b45_count = b45_count + 1
            if q_b45.outcome % 4 >= 2:
                b45_count = b45_count + 1
            if q_b45.outcome % 8 >= 4:
                b45_count = b45_count + 1
            if q_b45.outcome % 16 >= 8:
                b45_count = b45_count + 1
            if q_b45.outcome % 32 >= 16:
                b45_count = b45_count + 1
            if q_b45.outcome % 64 >= 32:
                b45_count = b45_count + 1
            if q_b45.outcome % 128 >= 64:
                b45_count = b45_count + 1
            if q_b45.outcome % 256 >= 128:
                b45_count = b45_count + 1
            if q_b45.outcome % 512 >= 256:
                b45_count = b45_count + 1
            if b45_count > 1:
                b45_multiple = 1
          input:
            control: Checkbox
            labels:
              1: "In paid work (or away temporarily)"
              2: "In education (not paid for by employer)"
              4: "Unemployed and actively looking for a job"
              8: "Unemployed, wanting a job but not actively looking"
              16: "Permanently sick or disabled"
              32: "Retired"
              64: "In community or military service"
              128: "Doing housework, looking after children or others"
              256: "Other"

        # B46: Partner's main activity
        - id: q_b46
          kind: Question
          title: "And which of these descriptions best describes your husband, wife, or partner's situation in the last 7 days?"
          precondition:
            - predicate: b45_multiple == 1
          input:
            control: Radio
            labels:
              1: "In paid work"
              2: "In education"
              3: "Unemployed, actively looking"
              4: "Unemployed, wanting job but not looking"
              5: "Permanently sick or disabled"
              6: "Retired"
              7: "Community or military service"
              8: "Housework, looking after children or others"
              9: "Other"

        # B47: Partner did paid work in last 7 days?
        # Precondition: partner NOT in paid work at B45
        - id: q_b47
          kind: Question
          title: "Just to check, did your husband, wife, or partner do any paid work of an hour or more in the last 7 days?"
          precondition:
            - predicate: partner_in_paid_work == 0
          codeBlock: |
            if q_b47.outcome == 1:
                partner_has_work = 1
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # B48: Partner's main job title
        - id: q_b48
          kind: Question
          title: "What is your husband, wife, or partner's main job?"
          precondition:
            - predicate: partner_has_work == 1
          input:
            control: Textarea
            placeholder: "Partner's job title"

        # B49: Partner's main tasks
        - id: q_b49
          kind: Question
          title: "What does your husband, wife, or partner mainly do in their job?"
          precondition:
            - predicate: partner_has_work == 1
          input:
            control: Textarea
            placeholder: "Describe partner's main tasks"

        # B50: Partner's qualifications needed
        - id: q_b50
          kind: Question
          title: "What training or qualifications are needed for your husband, wife, or partner's job?"
          precondition:
            - predicate: partner_has_work == 1
          input:
            control: Textarea
            placeholder: "Describe required training or qualifications"

        # B51: Partner employee or self-employed
        - id: q_b51
          kind: Question
          title: "In your husband, wife, or partner's main job, are they...?"
          precondition:
            - predicate: partner_has_work == 1
          input:
            control: Radio
            labels:
              1: "An employee"
              2: "Self-employed"
              3: "Working for own family's business"

        # B52: Partner's normal working hours
        - id: q_b52
          kind: Question
          title: "How many hours does your husband, wife, or partner normally work a week in their main job?"
          precondition:
            - predicate: partner_has_work == 1
          input:
            control: Editbox
            min: 0
            max: 168
            right: "hours per week"

    # =========================================================================
    # PARENTS' BACKGROUND (B53-B58)
    # =========================================================================
    # B53: Father's education — Dropdown. ASK ALL.
    # B54: Father's work status when respondent was 14 — Radio {1-4,7}.
    #   1,2 → B55 (father's occupation); 3,4,7 → skip to B56.
    # B55: Father's occupation type. Precondition: B54 in [1, 2].
    # B56: Mother's education — Dropdown. ASK ALL.
    # B57: Mother's work status when respondent was 14 — Radio {1-4,7}.
    #   1,2 → B58 (mother's occupation); 3,4,7 → skip to B59.
    # B58: Mother's occupation type. Precondition: B57 in [1, 2].
    # =========================================================================
    - id: b_parents
      title: "Parents' Background"
      items:
        # B53a/B53b: Father's highest education level
        - id: q_b53
          kind: Question
          title: "What is the highest level of education your father achieved?"
          input:
            control: Dropdown
            labels:
              1: "Less than lower secondary (ISCED 0-1)"
              2: "Lower secondary (ISCED 2)"
              3: "Lower tier upper secondary (ISCED 3)"
              4: "Upper tier upper secondary (ISCED 3)"
              5: "Advanced vocational / sub-degree (ISCED 4)"
              6: "Lower tertiary education, BA level (ISCED 5)"
              7: "Higher tertiary education, MA/PhD level (ISCED 6+)"
              8: "Other"
              77: "Prefer not to answer"

        # B54: Father's work status when respondent was 14
        - id: q_b54
          kind: Question
          title: "When you were 14, did your father work as an employee, was he self-employed, or was he not working then?"
          input:
            control: Radio
            labels:
              1: "Employee"
              2: "Self-employed"
              3: "Not working"
              4: "Father deceased or absent when I was 14"
              7: "Prefer not to answer"

        # B55: Father's occupation type
        # Precondition: B54 = employee or self-employed
        - id: q_b55
          kind: Question
          title: "Which one of the descriptions from the following list best describes the sort of work your father did when you were 14?"
          precondition:
            - predicate: q_b54.outcome in [1, 2]
          input:
            control: Dropdown
            labels:
              1: "Professional and technical"
              2: "Higher administrator"
              3: "Clerical"
              4: "Sales"
              5: "Service"
              6: "Skilled worker"
              7: "Semi-skilled worker"
              8: "Unskilled worker"
              9: "Farm worker"
              77: "Prefer not to answer"

        # B56a/B56b: Mother's highest education level
        - id: q_b56
          kind: Question
          title: "What is the highest level of education your mother achieved?"
          input:
            control: Dropdown
            labels:
              1: "Less than lower secondary (ISCED 0-1)"
              2: "Lower secondary (ISCED 2)"
              3: "Lower tier upper secondary (ISCED 3)"
              4: "Upper tier upper secondary (ISCED 3)"
              5: "Advanced vocational / sub-degree (ISCED 4)"
              6: "Lower tertiary education, BA level (ISCED 5)"
              7: "Higher tertiary education, MA/PhD level (ISCED 6+)"
              8: "Other"
              77: "Prefer not to answer"

        # B57: Mother's work status when respondent was 14
        - id: q_b57
          kind: Question
          title: "When you were 14, did your mother work as an employee, was she self-employed, or was she not working then?"
          input:
            control: Radio
            labels:
              1: "Employee"
              2: "Self-employed"
              3: "Not working"
              4: "Mother deceased or absent when I was 14"
              7: "Prefer not to answer"

        # B58: Mother's occupation type
        # Precondition: B57 = employee or self-employed
        - id: q_b58
          kind: Question
          title: "Which one of the descriptions from the following list best describes the sort of work your mother did when you were 14?"
          precondition:
            - predicate: q_b57.outcome in [1, 2]
          input:
            control: Dropdown
            labels:
              1: "Professional and technical"
              2: "Higher administrator"
              3: "Clerical"
              4: "Sales"
              5: "Service"
              6: "Skilled worker"
              7: "Semi-skilled worker"
              8: "Unskilled worker"
              9: "Farm worker"
              77: "Prefer not to answer"

    # =========================================================================
    # TRAINING AND ANCESTRY (B59-B60)
    # =========================================================================
    # B59: Training/courses in past 12 months. Switch. ASK ALL.
    # B60: Ancestry — country-specific, simplified to Dropdown. ASK ALL.
    # =========================================================================
    - id: b_training_ancestry
      title: "Training and Ancestry"
      items:
        # B59: Training or courses in past 12 months
        - id: q_b59
          kind: Question
          title: "During the last twelve months, have you taken any course or attended any lecture or conference to improve your knowledge or skills for work?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # B60: Ancestry (country-specific, simplified to text)
        - id: q_b60
          kind: Question
          title: "How would you describe your ancestry?"
          input:
            control: Textarea
            placeholder: "Describe your ancestry (country-specific options apply)"

    # ===================================================================
    # SECTION: wellbeing_module
    # ===================================================================
    # =========================================================================
    # OPTIMISM (C1)
    # =========================================================================
    - id: b_optimism
      title: "Optimism"
      items:
        # C1: Optimism about future
        - id: q_c1
          kind: Question
          title: "To what extent do you agree or disagree with the following statement? 'I'm always optimistic about my future.'"
          input:
            control: Radio
            labels:
              1: "Agree strongly"
              2: "Agree"
              3: "Neither agree nor disagree"
              4: "Disagree"
              5: "Disagree strongly"

    # =========================================================================
    # PAST-WEEK FEELINGS (C2-C11)
    # =========================================================================
    # Ten items sharing the same 4-point frequency scale.
    # Modelled as a QuestionGroup for compactness.
    # =========================================================================
    - id: b_past_week
      title: "Feelings in the Past Week"
      items:
        # C2-C11: Past-week feelings (4-point frequency)
        - id: qg_past_week
          kind: QuestionGroup
          title: "How much of the time during the past week..."
          questions:
            - "...did you feel depressed?"
            - "...was your sleep restless?"
            - "...were you happy?"
            - "...did you feel lonely?"
            - "...did you enjoy life?"
            - "...did you feel sad?"
            - "...could you not get going?"
            - "...did you have a lot of energy?"
            - "...did you feel anxious?"
            - "...did you feel calm and peaceful?"
          input:
            control: Radio
            labels:
              1: "None or almost none of the time"
              2: "Some of the time"
              3: "Most of the time"
              4: "All or almost all of the time"

    # =========================================================================
    # COMPETENCE AND WORTH (C12-C13)
    # =========================================================================
    - id: b_competence
      title: "Competence and Self-Worth"
      items:
        # C12: Chance to show capability
        - id: q_c12
          kind: Question
          title: "To what extent do you agree or disagree with the following statement? 'In my daily life I get very little chance to show how capable I am.'"
          input:
            control: Radio
            labels:
              1: "Agree strongly"
              2: "Agree"
              3: "Neither agree nor disagree"
              4: "Disagree"
              5: "Disagree strongly"

        # C13: Value and worth of activities
        - id: q_c13
          kind: Question
          title: "To what extent do you agree or disagree with the following statement? 'I generally feel that what I do in my life is valuable and worthwhile.'"
          input:
            control: Radio
            labels:
              1: "Agree strongly"
              2: "Agree"
              3: "Neither agree nor disagree"
              4: "Disagree"
              5: "Disagree strongly"

    # =========================================================================
    # SOCIAL HARMONY AND RESPECT (C14-C16)
    # =========================================================================
    - id: b_social_harmony
      title: "Social Harmony and Respect"
      items:
        # C14: Harmony among people in country
        - id: q_c14
          kind: Question
          title: "In your opinion, to what extent is there harmony among the people who live in [country]?"
          input:
            control: Slider
            min: 0
            max: 6
            left: "Not at all"
            right: "A great deal"

        # C15: People in local area help one another
        - id: q_c15
          kind: Question
          title: "To what extent do you feel that people in your local area help one another?"
          input:
            control: Slider
            min: 0
            max: 6
            left: "Not at all"
            right: "A great deal"

        # C16: Treated with respect
        - id: q_c16
          kind: Question
          title: "To what extent do you feel that people treat you with respect?"
          input:
            control: Slider
            min: 0
            max: 6
            left: "Not at all"
            right: "A great deal"

    # =========================================================================
    # PURPOSE AND SUPPORT (C17-C23)
    # =========================================================================
    - id: b_purpose_support
      title: "Awareness, Purpose, and Support"
      items:
        # C17: Notice and appreciate surroundings (0-10)
        - id: q_c17
          kind: Question
          title: "On a typical day, how often do you take notice of and appreciate your surroundings?"
          input:
            control: Slider
            min: 0
            max: 10
            left: "Never"
            right: "Always"

        # C18: Sense of direction in life (0-10)
        - id: q_c18
          kind: Question
          title: "To what extent do you feel that you have a sense of direction in your life?"
          input:
            control: Slider
            min: 0
            max: 10
            left: "Not at all"
            right: "Completely"

        # C19: Receive help and support (0-6)
        - id: q_c19
          kind: Question
          title: "To what extent do you receive help and support from people you are close to when you need it?"
          input:
            control: Slider
            min: 0
            max: 6
            left: "Not at all"
            right: "Completely"

        # C20: Provide help and support (0-6)
        - id: q_c20
          kind: Question
          title: "And to what extent do you provide help and support to people you are close to when they need it?"
          input:
            control: Slider
            min: 0
            max: 6
            left: "Not at all"
            right: "Completely"

        # C21: Doing things you value (0-6)
        - id: q_c21
          kind: Question
          title: "To what extent are you doing the things you really want and value in your life?"
          input:
            control: Slider
            min: 0
            max: 6
            left: "Not at all"
            right: "Completely"

        # C22: Able to achieve goals (0-6)
        - id: q_c22
          kind: Question
          title: "To what extent are you able to achieve your goals?"
          input:
            control: Slider
            min: 0
            max: 6
            left: "Not at all"
            right: "Completely"

        # C23: Feel safe and secure (0-6)
        - id: q_c23
          kind: Question
          title: "To what extent do you feel safe and secure in your life nowadays?"
          input:
            control: Slider
            min: 0
            max: 6
            left: "Not at all"
            right: "Completely"

    # =========================================================================
    # CONNECTEDNESS (C24-C25)
    # =========================================================================
    - id: b_connectedness
      title: "Connectedness"
      items:
        # C24: Close and connected to other people (0-6)
        - id: q_c24
          kind: Question
          title: "Generally speaking, how close and connected do you feel to other people?"
          input:
            control: Slider
            min: 0
            max: 6
            left: "Not at all"
            right: "Extremely"

        # C25: Connected to people in local area (0-6)
        - id: q_c25
          kind: Question
          title: "How close and connected do you feel to the people in your local area?"
          input:
            control: Slider
            min: 0
            max: 6
            left: "Not at all"
            right: "Extremely"

    # =========================================================================
    # RESILIENCE AND COMPASSION (C26-C30)
    # =========================================================================
    - id: b_resilience
      title: "Resilience and Compassion"
      items:
        # C26: Find something good in difficult periods
        - id: q_c26
          kind: Question
          title: "To what extent do you agree or disagree with the following statement? 'In difficult periods of my life, I can usually find something good that helps me change for the better.'"
          input:
            control: Radio
            labels:
              1: "Agree strongly"
              2: "Agree"
              3: "Neither agree nor disagree"
              4: "Disagree"
              5: "Disagree strongly"

        # C27: Compassion for acquaintance in difficulty (0-6)
        - id: q_c27
          kind: Question
          title: "When you hear about an acquaintance going through a difficult time, how much compassion do you usually feel for them?"
          input:
            control: Slider
            min: 0
            max: 6
            left: "None at all"
            right: "A great deal"

        # C28: Self-care and kindness in difficulty (0-6)
        - id: q_c28
          kind: Question
          title: "When you are going through a difficult time, to what extent do you give yourself the care and kindness you need?"
          input:
            control: Slider
            min: 0
            max: 6
            left: "Not at all"
            right: "A great deal"

        # C29: Harmony in life (0-6)
        - id: q_c29
          kind: Question
          title: "To what extent do you feel there is harmony in your life, that is, you feel balanced and at peace with yourself?"
          input:
            control: Slider
            min: 0
            max: 6
            left: "Not at all"
            right: "A great deal"

        # C30: Pause before reacting in difficulty (0-6)
        - id: q_c30
          kind: Question
          title: "In difficult situations, how often do you manage to take a pause without immediately reacting?"
          input:
            control: Slider
            min: 0
            max: 6
            left: "Never"
            right: "Always"

    # ===================================================================
    # SECTION: immigration_module
    # ===================================================================
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

    # ===================================================================
    # SECTION: human_values
    # ===================================================================
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

    # ===================================================================
    # SECTION: survey_experience
    # ===================================================================
    # ── Survey Experience (F1-F6) ──
    # SC WEB and PAPER only
    - id: b_survey_experience
      title: "Survey Experience"
      items:
        # F1: Understanding of questions
        - id: q_f1
          kind: Question
          title: "Overall, how well did you feel you understood the questions?"
          input:
            control: Radio
            labels:
              1: "Understood only a few of the questions"
              2: "Understood some of the questions"
              3: "Understood most of the questions"
              4: "Understood all or nearly all of the questions"

        # F2: Reluctance to answer
        - id: q_f2
          kind: Question
          title: "Did you feel reluctant to answer any questions?"
          input:
            control: Radio
            labels:
              1: "None of the questions"
              2: "A few of the questions"
              3: "Some of the questions"
              4: "Most of the questions"
              5: "All or nearly all of the questions"

        # F3: Assistance received — 1 (Yes) → F4, F5; 0 (No) → F6
        - id: q_f3
          kind: Question
          title: "Did anyone else assist you in completing this questionnaire?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # F4: Who assisted (only if F3 = Yes)
        - id: q_f4
          kind: Question
          title: "Who assisted you in completing the questionnaire? Please choose all that apply."
          precondition:
            - predicate: "q_f3.outcome == 1"
          input:
            control: Checkbox
            labels:
              1: "Husband, wife, or partner"
              2: "Son or daughter"
              4: "Parent, parent-in-law, step-parent, or partner's parent"
              8: "Other relative"
              16: "Other non-relative"
              32: "The person who delivered the questionnaire"

        # F5: Kind of assistance (only if F3 = Yes)
        - id: q_f5
          kind: Question
          title: "What kind of assistance was given to you in completing the questionnaire? Please choose all that apply."
          precondition:
            - predicate: "q_f3.outcome == 1"
          input:
            control: Checkbox
            labels:
              1: "Understanding the invitation letter and getting started"
              2: "Accessing the online survey"
              4: "Reading the questions aloud to me"
              8: "Providing information for questions about relatives or household members"
              16: "Helping me decide answers to other questions"
              32: "Returning my completed paper questionnaire"
              64: "Other"

        # F6: Further comments
        - id: q_f6
          kind: Question
          title: "Do you have any further comments on this survey or its questions?"
          input:
            control: Textarea
            placeholder: "Type your comments here..."

    # ===================================================================
    # SECTION: recontact_closing
    # ===================================================================
    # ── Recontact (G1-G6) ──
    - id: b_recontact
      title: "Recontact"
      items:
        # G1: Agree to recontact — 1 (Yes) → G2-G5; 0 (No) → H1
        - id: q_g1
          kind: Question
          title: "Thank you for giving your time to complete this survey today. The European Social Survey may want to contact you again to invite you to take part in further research on similar topics to those covered by the questions that you have answered here. Would it be okay if we contact you again, to invite you to take part in a follow-up study?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # G2: Name (only if agreed to recontact)
        - id: q_g2
          kind: Question
          title: "Please enter your first name and surname below."
          precondition:
            - predicate: "q_g1.outcome == 1"
          input:
            control: Textarea
            placeholder: "First name and surname"

        # G3: Email (only if agreed to recontact)
        - id: q_g3
          kind: Question
          title: "Please enter your email address below."
          precondition:
            - predicate: "q_g1.outcome == 1"
          input:
            control: Textarea
            placeholder: "Email address"

        # G4: Address consent (only if agreed to recontact)
        - id: q_g4
          kind: Question
          title: "Do you agree that we may retain your physical address that we used to contact you for this survey?"
          precondition:
            - predicate: "q_g1.outcome == 1"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # G5: Phone number (only if agreed to recontact)
        - id: q_g5
          kind: Question
          title: "Please enter your mobile telephone number below."
          precondition:
            - predicate: "q_g1.outcome == 1"
          input:
            control: Textarea
            placeholder: "Mobile telephone number"

        # G6: Incentive consent
        # 1 (Yes, use details) → end; 2 (No, don't want) → end; 3 (Provide other details) → H1
        - id: q_g6
          kind: Question
          title: "As a thank you for taking part in this survey we will send you a voucher. May we use the contact details you've already provided to ensure it reaches you?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No, I don't want to receive this"
              3: "No, I'd like to provide other details"

    # ── Closing (H1-H3) ──
    - id: b_closing
      title: "Closing"
      items:
        # H1: Contact details for incentive
        # Shown if declined recontact (G1=0) or wants to provide other details (G6=3)
        - id: q_h1
          kind: Question
          title: "Thank you for taking part in this survey today. Please enter your details below to ensure the voucher reaches you."
          precondition:
            - predicate: "q_g1.outcome == 0 or q_g6.outcome == 3"
          input:
            control: Textarea
            placeholder: "Name, email, phone, and/or address"

        # H2: Date of completion
        - id: q_h2
          kind: Question
          title: "Please record the date when you finished completing this questionnaire (day of month)."
          input:
            control: Editbox
            min: 1
            max: 31
            right: "(day)"

        # H3: Coder ID
        - id: q_h3
          kind: Question
          title: "Please enter your data entry coder ID number."
          input:
            control: Editbox
            min: 0
            max: 99999

    # ===================================================================
    # SECTION: interviewer
    # ===================================================================
    # ── Interview Mode and Respondent Behaviour (J1-J5) ──
    - id: b_interview_mode
      title: "Interview Mode and Respondent Behaviour"
      items:
        # J1: Interview mode
        - id: q_j1
          kind: Question
          title: "Please select how the interview was conducted from the list below."
          input:
            control: Radio
            labels:
              1: "In person inside respondent's home"
              2: "In person outside of respondent's home"
              3: "By video"

        # J2: Respondent asked for clarification
        - id: q_j2
          kind: Question
          title: "Did the respondent ask for clarification on any questions?"
          input:
            control: Radio
            labels:
              1: "Never"
              2: "Almost never"
              3: "Now and then"
              4: "Often"
              5: "Very often"

        # J3: Respondent reluctance
        - id: q_j3
          kind: Question
          title: "Did you feel that the respondent was reluctant to answer any questions?"
          input:
            control: Radio
            labels:
              1: "Never"
              2: "Almost never"
              3: "Now and then"
              4: "Often"
              5: "Very often"

        # J4: Respondent effort
        - id: q_j4
          kind: Question
          title: "Did you feel that the respondent tried to answer the questions to the best of his or her ability?"
          input:
            control: Radio
            labels:
              1: "Never"
              2: "Almost never"
              3: "Now and then"
              4: "Often"
              5: "Very often"

        # J5: Respondent understanding
        - id: q_j5
          kind: Question
          title: "Overall, did you feel that the respondent understood the questions?"
          input:
            control: Radio
            labels:
              1: "Never"
              2: "Almost never"
              3: "Now and then"
              4: "Often"
              5: "Very often"

    # ── Interference (J6-J7) ──
    - id: b_interference
      title: "Interference"
      items:
        # J6: Interference during interview — 1 (Yes) → J7; 0 (No) → J8
        - id: q_j6
          kind: Question
          title: "Was anyone else present, who interfered with the interview?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # J7: Who interfered (only if J6 = Yes)
        - id: q_j7
          kind: Question
          title: "Who was this? Code all that apply."
          precondition:
            - predicate: "q_j6.outcome == 1"
          input:
            control: Checkbox
            labels:
              1: "Husband/wife/partner"
              2: "Son/daughter"
              4: "Parent/parent-in-law/step-parent/partner's parent"
              8: "Other relative"
              16: "Other non-relative"

    # ── Interview Details (J8-J10) ──
    - id: b_interview_details
      title: "Interview Details"
      items:
        # J8: Interview language (country-specific; placeholder options)
        - id: q_j8
          kind: Question
          title: "In which language was the interview conducted?"
          input:
            control: Dropdown
            labels:
              1: "Main national language"
              2: "Second national language"
              3: "Third national language"
              4: "Minority language"
              5: "Other language"

        # J9: Interviewer ID
        - id: q_j9
          kind: Question
          title: "Please enter your interviewer ID."
          input:
            control: Textarea
            placeholder: "Interviewer ID"

        # J10: Additional comments
        - id: q_j10
          kind: Question
          title: "If you have any additional comments on the interview, please type them in the space below."
          input:
            control: Textarea
            placeholder: "Additional comments"
