# #1780: A skipped matrix reads None too.
# Runtime: Skipped for everyone who answered No: m was never asked, so m.outcome[0][0] raises.
# Why: Matrix cells are bound as in-domain numbers unconditionally, and no skip choice exists for
# a matrix (#1769 covered Questions, #184 QuestionGroups).
qmlVersion: "2.6.2"
questionnaire:
  title: Gated matrix cell
  blocks:
    - id: b1
      title: Main
      items:
        - id: q_a
          kind: Question
          title: Do you drive?
          input:
            control: Radio
            labels:
              1: 'Yes'
              2: 'No'
        - id: m
          kind: MatrixQuestion
          title: Rate your car
          precondition:
            - predicate: q_a.outcome == 1
          rows:
            - Comfort
          columns:
            - Score
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
          title: Follow-up on the rating
          precondition:
            - predicate: m.outcome[0][0] != 9
          input:
            control: Switch
