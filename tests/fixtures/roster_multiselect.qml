qmlVersion: "2.0"
questionnaire:
  title: "Daily Meal Tracker"
  blocks:
    - id: meal_selection
      kind: Group
      title: "Today's meals"
      items:
        - id: q_meals_eaten
          kind: Question
          title: "Which meals did you eat today?"
          input:
            control: Checkbox
            labels:
              1: "Breakfast"
              2: "Lunch"
              4: "Dinner"
              8: "Snack"

    - id: per_meal
      kind: Roster
      title: "Per-meal details"
      iterateOver: "q_meals_eaten.outcome"
      labels:
        1: "Breakfast"
        2: "Lunch"
        4: "Dinner"
        8: "Snack"
      items:
        - id: q_satisfaction
          kind: Question
          title: "How satisfied were you?"
          input:
            control: Slider
            min: 1
            max: 5
        - id: q_notes
          kind: Question
          title: "Any notes?"
          input:
            control: Textarea
