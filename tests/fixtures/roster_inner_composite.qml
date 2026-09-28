# Roster whose inner items are NON-SCALAR: a QuestionGroup and a
# MatrixQuestion alongside a plain Question.
#
# Exercises the one Roster shape the Bronze extractor could not read (#117):
# `roster_outcomes[block][bit][inner]` holds a List[Any] for the QuestionGroup
# and a List[List[Any]] for the Matrix, so the per-iteration column has to
# expand into per-slot / per-cell columns rather than a single cell.
#
# Two label keys and deliberately small declared shapes (3 sub-questions, 2x2
# grid) so the expected column count stays hand-checkable:
#   2 labels x (1 + 3 + 4) = 16 roster columns, + 1 outer = 17.
qmlVersion: "2.0"

questionnaire:
  title: "Trip Diary"
  blocks:
    - id: trip_selection
      kind: Group
      title: "Which trips?"
      items:
        - id: q_trips
          kind: Question
          title: "Which trips did you take?"
          input:
            control: Checkbox
            labels:
              1: "Commute"
              2: "Leisure"

    - id: per_trip
      kind: Roster
      title: "Per-trip detail"
      iterateOver: "q_trips.outcome"
      labels:
        1: "Commute"
        2: "Leisure"
      items:
        - id: q_trip_rating
          kind: Question
          title: "Overall rating"
          input:
            control: Slider
            min: 1
            max: 5

        - id: q_trip_aspects
          kind: QuestionGroup
          title: "Rate each aspect"
          questions:
            - "Comfort"
            - "Cost"
            - "Speed"
          input:
            control: Radio
            labels:
              1: "Poor"
              2: "Fair"
              3: "Good"

        - id: q_trip_modes
          kind: MatrixQuestion
          title: "Time spent per mode"
          rows:
            - "Outbound"
            - "Return"
          columns:
            - "Walk"
            - "Transit"
          input:
            control: Slider
            min: 0
            max: 60
