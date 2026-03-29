qmlVersion: "1.0"
questionnaire:
  title: "ESS Round 12 - Wellbeing Module (C1-C30)"

  blocks:
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
