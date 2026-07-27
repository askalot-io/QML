qmlVersion: "2.1"
questionnaire:
  title: "Household Labour Force Roster"
  # Corpus-scale Roster instrument. The rest of this corpus was converted from
  # real single-pass questionnaires, none of which used a Roster — so nothing
  # at corpus scale exercised repeated-question traversal, and the constructs
  # below had only 34-94 line hand-written fixtures behind them.
  #
  # Modelled on the household-roster shape every labour force survey uses:
  # enumerate the household once, then repeat a battery per member. The
  # constructs it is here to cover:
  #
  #   * Checkbox forward-tightening — `q_members_present` has power-of-2 label
  #     keys, so its outcome IS the bitmask and feeds `iterateOver` directly.
  #     No decode codeBlock stands between the two.
  #   * `subjectFrom` — the iteration banner shows the name the respondent
  #     typed rather than the static "Member 2" label.
  #   * Roster inner preconditions — the labour battery is gated on the age
  #     answered in the *same* iteration.
  #   * Cross-iteration reads — household totals read `q.outcomes[<bit>]`
  #     from outside the Roster.
  #   * A `count`-capped Group — the rotating module, also uncovered at
  #     corpus scale.

  codeInit: |
    # Working-age threshold used by the labour battery's gates. Reassigned in
    # the screening block so it is a produced variable, not a frozen constant
    # (a frozen gate is statically decidable and lints as frozen_variable).
    working_age = 15

  blocks:
    - id: screening
      kind: Group
      title: "Screening"
      items:
        - id: q_consent
          kind: Question
          title: "Do you agree to take part in this survey?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: q_region
          kind: Question
          title: "In which region is this household located?"
          precondition:
            - predicate: "q_consent.outcome == 1"
              hint: "Asked only of consenting households."
          input:
            control: Dropdown
            labels:
              1: "North"
              2: "Central"
              3: "South"
              4: "Islands"

        - id: q_dwelling_type
          kind: Question
          title: "Which best describes this dwelling?"
          precondition:
            - predicate: "q_consent.outcome == 1"
          input:
            control: Radio
            labels:
              1: "Detached house"
              2: "Apartment"
              3: "Shared accommodation"
              4: "Other"
          codeBlock: |
            # Reassigns the codeInit value so the threshold is a produced
            # variable. Islands use a lower statutory working age.
            working_age = 14 if q_region.outcome == 4 else 15

    - id: composition
      kind: Group
      title: "Household composition"
      precondition:
        - predicate: "q_consent.outcome == 1"
          hint: "Composition is only enumerated for consenting households."
      items:
        - id: q_members_present
          kind: Question
          title: "Which household member slots are occupied?"
          # Power-of-2 keys: the Checkbox outcome is the sum of the selected
          # keys, which IS the roster bitmask. Nothing decodes it.
          input:
            control: Checkbox
            labels:
              1: "Member 1"
              2: "Member 2"
              4: "Member 3"
              8: "Member 4"

        - id: q_household_type
          kind: Question
          title: "Which best describes this household?"
          input:
            control: Radio
            labels:
              1: "Single person"
              2: "Couple, no children"
              3: "Couple with children"
              4: "Single parent"
              5: "Other"

    - id: member_demographics
      kind: Roster
      title: "Member demographics"
      # Straight from the Checkbox outcome — the forward-tightening contract.
      iterateOver: "q_members_present.outcome"
      labels:
        1: "Member 1"
        2: "Member 2"
        4: "Member 3"
        8: "Member 4"
      subjectFrom: q_member_name
      items:
        - id: q_member_name
          kind: Question
          title: "What is this person's first name?"
          input:
            control: Textarea

        - id: q_member_age
          kind: Question
          title: "How old is this person?"
          input:
            control: Slider
            min: 0
            max: 120

        - id: q_member_sex
          kind: Question
          title: "What is this person's sex?"
          input:
            control: Radio
            labels:
              1: "Female"
              2: "Male"
              3: "Prefer not to say"

        - id: q_member_relationship
          kind: Question
          title: "Relationship to the person answering?"
          input:
            control: Dropdown
            labels:
              1: "Self"
              2: "Spouse or partner"
              3: "Child"
              4: "Parent"
              5: "Other relative"
              6: "Unrelated"

    - id: member_labour
      kind: Roster
      title: "Member labour force status"
      iterateOver: "q_members_present.outcome"
      labels:
        1: "Member 1"
        2: "Member 2"
        4: "Member 3"
        8: "Member 4"
      subjectFrom: q_member_name
      items:
        - id: q_activity_status
          kind: Question
          title: "What was this person's main activity last week?"
          # Gated on the age answered in THIS iteration, against a produced
          # variable — the inner-precondition path.
          precondition:
            - predicate: "q_member_age.outcome >= working_age"
              hint: "The labour battery applies from working age upward."
          input:
            control: Radio
            labels:
              1: "Employed"
              2: "Unemployed, seeking work"
              3: "Retired"
              4: "In education"
              5: "Home duties"
              6: "Unable to work"

        - id: q_usual_hours
          kind: Question
          title: "How many hours does this person usually work per week?"
          precondition:
            - predicate: "q_member_age.outcome >= working_age and q_activity_status.outcome == 1"
              hint: "Hours are asked of employed members only."
          input:
            control: Slider
            min: 0
            max: 80
          postcondition:
            - predicate: "q_usual_hours.outcome > 0"
              hint: "An employed person works more than zero hours."

        - id: q_sector
          kind: Question
          title: "In which sector does this person work?"
          precondition:
            - predicate: "q_member_age.outcome >= working_age and q_activity_status.outcome == 1"
          input:
            control: Dropdown
            labels:
              1: "Agriculture"
              2: "Industry"
              3: "Construction"
              4: "Services"
              5: "Public administration"

        - id: q_contract_type
          kind: Question
          title: "Is this an open-ended or fixed-term arrangement?"
          precondition:
            - predicate: "q_member_age.outcome >= working_age and q_activity_status.outcome == 1"
          input:
            control: Radio
            labels:
              1: "Open-ended"
              2: "Fixed-term"
              3: "No written contract"

        - id: q_search_duration
          kind: Question
          title: "For how many months has this person been seeking work?"
          precondition:
            - predicate: "q_member_age.outcome >= working_age and q_activity_status.outcome == 2"
              hint: "Search duration is asked of job seekers only."
          input:
            control: Slider
            min: 0
            max: 120

        - id: q_search_method
          kind: Question
          title: "What is the main method used to seek work?"
          precondition:
            - predicate: "q_member_age.outcome >= working_age and q_activity_status.outcome == 2"
          input:
            control: Dropdown
            labels:
              1: "Public employment office"
              2: "Direct applications"
              3: "Personal contacts"
              4: "Online platforms"
              5: "Other"

    - id: household_totals
      kind: Group
      title: "Household totals"
      precondition:
        - predicate: "q_consent.outcome == 1"
      items:
        - id: q_totals_confirm
          kind: Question
          title: "Are the household totals below correct?"
          # Cross-iteration reads: `q.outcomes[<bit>]` is the dict-shaped
          # accessor for a Roster item, read from outside the Roster.
          codeBlock: |
            employed_count = 0
            for bit in [1, 2, 4, 8]:
                status = q_activity_status.outcomes.get(bit)
                if status == 1:
                    employed_count = employed_count + 1
            household_size = 0
            for bit in [1, 2, 4, 8]:
                if q_member_age.outcomes.get(bit) is not None:
                    household_size = household_size + 1
          input:
            control: Radio
            labels:
              1: "Yes, correct"
              2: "No, needs correction"

        - id: q_totals_correction
          kind: Question
          title: "What should be corrected?"
          precondition:
            - predicate: "q_totals_confirm.outcome == 2"
              hint: "Asked only when the respondent disputes the totals."
          input:
            control: Textarea

    - id: rotating_module
      kind: Group
      title: "Rotating module"
      # count-capped: exactly two of these are asked, in canonical order, from
      # whichever are precondition-eligible. Inner items are mutually
      # independent, as a capped Group requires.
      count: 2
      precondition:
        - predicate: "q_consent.outcome == 1"
      items:
        - id: q_module_training
          kind: Question
          title: "Has anyone in the household attended training in the last month?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: q_module_commute
          kind: Question
          title: "What is the longest one-way commute in the household, in minutes?"
          input:
            control: Slider
            min: 0
            max: 240

        - id: q_module_remote
          kind: Question
          title: "Does anyone in the household work remotely at least one day a week?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: q_module_secondjob
          kind: Question
          title: "Does anyone in the household hold a second job?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

    - id: closing
      kind: Group
      title: "Closing"
      items:
        - id: q_interview_difficulty
          kind: Question
          title: "How difficult was this interview to complete?"
          precondition:
            - predicate: "q_consent.outcome == 1"
          input:
            control: Slider
            min: 1
            max: 5

        - id: q_recontact
          kind: Question
          title: "May we contact this household for the next wave?"
          precondition:
            - predicate: "q_consent.outcome == 1"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        - id: q_final_comments
          kind: Question
          title: "Any further comments?"
          input:
            control: Textarea
