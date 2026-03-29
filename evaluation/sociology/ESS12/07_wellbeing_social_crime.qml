qmlVersion: "1.0"
questionnaire:
  title: "ESS Round 12 - Wellbeing, Social Life, Crime, Health, and Attachment (A60-A69)"

  codeInit: |
    # No extern variables required — all items ASK ALL, no routing

  blocks:
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
