qmlVersion: "1.0"
questionnaire:
  title: "BRFSS 2023 - Module 24: Adverse Childhood Experiences (ACEs)"

  codeInit: |
    # No extern variables required for this section

  blocks:
    # =========================================================================
    # MODULE 24: ADVERSE CHILDHOOD EXPERIENCES (MACE)
    # =========================================================================
    # All 13 items are always asked when this module is selected.
    # No internal skip routing exists within the module.
    #
    # MACE.01–04: Household dysfunction (Switch Yes/No)
    # MACE.05:    Parental separation (Radio — 3 options including "not married")
    # MACE.06–11: Exposure to violence and abuse (Radio — Never/Once/More than once)
    # MACE.12–13: Protective adult presence (Dropdown — 5-point frequency scale)
    # =========================================================================
    - id: b_adverse_childhood
      title: "Module 24: Adverse Childhood Experiences"
      items:
        # MACE.01: Lived with someone who was depressed, mentally ill, or suicidal
        - id: q_mace_01
          kind: Question
          title: "When you were growing up, did you live with anyone who was depressed, mentally ill, or suicidal?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MACE.02: Lived with a problem drinker or alcoholic
        - id: q_mace_02
          kind: Question
          title: "When you were growing up, did you live with anyone who was a problem drinker or alcoholic?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MACE.03: Lived with someone who used illegal street drugs or abused prescription medications
        - id: q_mace_03
          kind: Question
          title: "When you were growing up, did you live with anyone who used illegal street drugs or who abused prescription medications?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MACE.04: Lived with someone who served time in prison, jail, or correctional facility
        - id: q_mace_04
          kind: Question
          title: "When you were growing up, did you live with anyone who served time or was sentenced to serve time in a prison, jail, or other correctional facility?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # MACE.05: Parents separated or divorced (3 options — includes "not married")
        - id: q_mace_05
          kind: Question
          title: "When you were growing up, were your parents separated or divorced?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              8: "Parents not married"

        # MACE.06: Witnessed domestic violence between parents/adults in home
        - id: q_mace_06
          kind: Question
          title: "How often did your parents or adults in your home ever slap, hit, kick, punch, or beat each other up?"
          input:
            control: Radio
            labels:
              1: "Never"
              2: "Once"
              3: "More than once"

        # MACE.07: Physically hurt by parent or adult in home (not spanking)
        - id: q_mace_07
          kind: Question
          title: "Not including spanking, how often did a parent or adult in your home ever hit, beat, kick, or physically hurt you in any way?"
          input:
            control: Radio
            labels:
              1: "Never"
              2: "Once"
              3: "More than once"

        # MACE.08: Verbally abused by parent or adult in home
        - id: q_mace_08
          kind: Question
          title: "How often did a parent or adult in your home ever swear at you, insult you, or put you down?"
          input:
            control: Radio
            labels:
              1: "Never"
              2: "Once"
              3: "More than once"

        # MACE.09: Touched sexually by someone 5+ years older or an adult
        - id: q_mace_09
          kind: Question
          title: "How often did anyone at least 5 years older than you or an adult, ever touch you sexually?"
          input:
            control: Radio
            labels:
              1: "Never"
              2: "Once"
              3: "More than once"

        # MACE.10: Made to touch someone sexually by someone 5+ years older or an adult
        - id: q_mace_10
          kind: Question
          title: "How often did anyone at least 5 years older than you or an adult, try to make you touch them sexually?"
          input:
            control: Radio
            labels:
              1: "Never"
              2: "Once"
              3: "More than once"

        # MACE.11: Forced to have sex by someone 5+ years older or an adult
        - id: q_mace_11
          kind: Question
          title: "How often did anyone at least 5 years older than you or an adult, force you to have sex?"
          input:
            control: Radio
            labels:
              1: "Never"
              2: "Once"
              3: "More than once"

        # MACE.12: Protective adult who made respondent feel safe (5-point scale)
        - id: q_mace_12
          kind: Question
          title: "For how much of your childhood was there an adult in your household who made you feel safe and protected?"
          input:
            control: Dropdown
            labels:
              1: "Never"
              2: "A little of the time"
              3: "Some of the time"
              4: "Most of the time"
              5: "All of the time"

        # MACE.13: Adult who tried hard to meet respondent's basic needs (5-point scale)
        - id: q_mace_13
          kind: Question
          title: "For how much of your childhood was there an adult in your household who tried hard to make sure your basic needs were met?"
          input:
            control: Dropdown
            labels:
              1: "Never"
              2: "A little of the time"
              3: "Some of the time"
              4: "Most of the time"
              5: "All of the time"
