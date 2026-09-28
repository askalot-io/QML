questionnaire:
  title: "Quality Scorecard - Bound Coverage Over Gateable Items"
  # Purpose-built for D3 (#528). Four numeric inputs, two of them bounded by a
  # constraining postcondition, giving bound_coverage = 0.5 — comfortably in
  # the strong band and unaffected by the eight choice items padding the file,
  # which is the length-independence the dimension exists to have.
  blocks:
    - id: main
      title: "Main"
      items:
        # Bounded numeric #1 — a real validity bound, narrower than the
        # control's own min/max, so it classifies CONSTRAINING.
        - id: q_age
          kind: Question
          title: "How old are you?"
          postcondition:
            - predicate: "q_age.outcome >= 18 and q_age.outcome <= 120"
              hint: "Adults only"
          input:
            control: Editbox
            min: 0
            max: 150

        # Bounded numeric #2 — relational, tying one numeric to another. Still
        # a bound on a gateable item, so it counts in the numerator exactly as
        # a local one does.
        - id: q_years_here
          kind: Question
          title: "How many years have you lived at this address?"
          postcondition:
            - predicate: "q_years_here.outcome <= q_age.outcome"
              hint: "Cannot exceed your age"
          input:
            control: Editbox
            min: 0
            max: 150

        # Unbounded numeric #1 — appears in offenders as actionable.
        - id: q_household_size
          kind: Question
          title: "How many people live in your household?"
          input:
            control: Editbox
            min: 0
            max: 30

        # Unbounded numeric #2 — a Slider is gateable for the same reason an
        # Editbox is: its min/max are the control's, not a validity rule.
        - id: q_satisfaction
          kind: Question
          title: "How satisfied are you?"
          input:
            control: Slider
            min: 1
            max: 5

        # Eight choice items. None is gateable, so none may move the rate —
        # this is the padding that pins length-independence.
        - id: q_c1
          kind: Question
          title: "Do you rent or own?"
          input:
            control: Radio
            labels:
              1: "Rent"
              2: "Own"
        - id: q_c2
          kind: Question
          title: "Do you have a car?"
          input:
            control: Switch
            on: "Yes"
            off: "No"
        - id: q_c3
          kind: Question
          title: "Which region?"
          input:
            control: Dropdown
            labels:
              1: "North"
              2: "South"
        - id: q_c4
          kind: Question
          title: "Employed?"
          input:
            control: Switch
            on: "Yes"
            off: "No"
        - id: q_c5
          kind: Question
          title: "Any pets?"
          input:
            control: Switch
            on: "Yes"
            off: "No"
        - id: q_c6
          kind: Question
          title: "Highest qualification?"
          input:
            control: Dropdown
            labels:
              1: "School"
              2: "Degree"
        # A CONSTRAINING postcondition on a CHOICE item: a real consistency
        # rule, counted as consistency_gates and deliberately kept out of the
        # coverage rate.
        - id: q_c7
          kind: Question
          title: "Do you drive to work?"
          postcondition:
            - predicate: "q_c7.outcome == 2 or q_c2.outcome == 1"
              hint: "Driving to work requires having a car"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
        - id: q_c8
          kind: Question
          title: "Anything to add?"
          input:
            control: Textarea
            maxLength: 200
