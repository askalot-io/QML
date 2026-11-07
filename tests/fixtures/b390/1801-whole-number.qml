# #1801: Numeric answers are whole numbers.
# Runtime: 3.5 is refused with 'enter a whole number between 0 and 10'; 3 is accepted.
# Why: Z3 models Editbox / Slider answers and Range ends as Int, and the schema already forbade a
# fractional step.
qmlVersion: "2.6.2"
questionnaire:
  title: Whole-number answers
  blocks:
    - id: b1
      title: Main
      items:
        - id: q
          kind: Question
          title: Hours slept
          input:
            control: Slider
            min: 0
            max: 10
