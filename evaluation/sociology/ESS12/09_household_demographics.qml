qmlVersion: "1.0"
questionnaire:
  title: "ESS Round 12 - Household Composition and Socio-Demographics (B1-B13)"

  codeInit: |
    has_partner = 0
    has_children_in_hh = 0

  blocks:
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
