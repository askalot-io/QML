# #1784: A shown-but-blank answer is unknown.
# Runtime: Skipped when the respondent leaves q blank: a blank answer makes the condition
# undecided, and an undecided precondition is False.
# Why: q has no precondition, so Z3 assumes it is always answered. Every channel can submit it
# blank.
qmlVersion: "2.6.2"
questionnaire:
  title: Ungated blank Question
  blocks:
    - id: b1
      title: Main
      items:
        - id: q
          kind: Question
          title: How satisfied are you? (1-5)
          input:
            control: Radio
            labels:
              1: '1'
              2: '2'
              3: '3'
              4: '4'
              5: '5'
        - id: r
          kind: Question
          title: Follow-up
          precondition:
            - predicate: q.outcome != 9
          input:
            control: Switch
