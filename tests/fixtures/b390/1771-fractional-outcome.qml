# #1771: A codeBlock writes a fraction to an outcome.
# Refused at load since #1813: QML arithmetic is whole numbers, so '/' and every
# other construct that can make a fraction is refused where it enters, before Z3 or the walk.
qmlVersion: "2.6.2"
questionnaire:
  title: Fractional outcome write
  blocks:
    - id: b1
      title: Main
      items:
        - id: q
          kind: Question
          title: Minutes of exercise
          input:
            control: Editbox
            min: 0
            max: 10
        - id: w
          kind: Question
          title: Writes the score
          codeBlock: t.outcome = q.outcome / 20
          input:
            control: Switch
        - id: t
          kind: Question
          title: Derived score
          input:
            control: Editbox
            min: 0
            max: 10
        - id: r
          kind: Question
          title: Under one hour-equivalent
          precondition:
            - predicate: 0 < t.outcome < 1
          input:
            control: Switch
