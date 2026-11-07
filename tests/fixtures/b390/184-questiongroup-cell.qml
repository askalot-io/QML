# #184: QuestionGroup answers had no Z3 model.
# Runtime: Never shown: neither answer can be 3.
# Why: A QuestionGroup had a single scalar, so qg.outcome[i] could not be lowered.
qmlVersion: "2.6.2"
questionnaire:
  title: QuestionGroup answer
  blocks:
    - id: b1
      title: Main
      items:
        - id: qg
          kind: QuestionGroup
          title: Two quick ones
          questions:
            - Coffee?
            - Tea?
          input:
            control: Radio
            labels:
              1: 'Yes'
              2: 'No'
        - id: r
          kind: Question
          title: Never shown
          precondition:
            - predicate: qg.outcome[0] == 3
          input:
            control: Switch
