questionnaire:
  title: "Quality Scorecard - Roster Burden Spread"
  blocks:
    - id: screening
      title: "Screening"
      items:
        - id: q_vehicles
          kind: Question
          title: "Which vehicles does your household own?"
          input:
            control: Checkbox
            labels:
              1: Car
              2: Motorcycle
              4: Bicycle
        - id: q_open
          kind: Question
          title: "Anything else about your household mobility?"
          precondition:
            - predicate: "q_vehicles.outcome >= 3"
              hint: "Owns more than one vehicle kind"
          input:
            control: Textarea
    # Worst case runs the two inner items once per declared label (3 labels);
    # guaranteed burden is zero iterations (bitmask can be 0) — the D8 spread
    # between guaranteed and worst-case burden comes from here.
    - id: vehicle_details
      kind: Roster
      title: "Per-vehicle details"
      iterateOver: "q_vehicles.outcome"
      labels:
        1: Car
        2: Motorcycle
        4: Bicycle
      items:
        - id: q_vehicle_year
          kind: Question
          title: "What year is this vehicle?"
          input:
            control: Editbox
            min: 1950
            max: 2030
        - id: q_vehicle_use
          kind: Question
          title: "How often do you use it?"
          input:
            control: Radio
            labels:
              1: Daily
              2: Weekly
              3: Rarely
