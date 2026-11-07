# #1767: Python's / is not Z3's /.
# Refused at load since #1813: QML arithmetic is whole numbers, so '/' and every
# other construct that can make a fraction is refused where it enters, before Z3 or the walk.
qmlVersion: "2.6.2"
questionnaire:
  title: True division
  blocks:
    - id: b1
      title: Main
      items:
        - id: q
          kind: Question
          title: Household size
          input:
            control: Editbox
            min: 0
            max: 10
        - id: r
          kind: Question
          title: Only for a household of one
          precondition:
            - predicate: q.outcome / 2 == 0.5
          input:
            control: Switch
