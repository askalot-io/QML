# #1811: Fraction tracking is per name, not per version.
# Refused at load since #1813: QML arithmetic is whole numbers, so '/' and every
# other construct that can make a fraction is refused where it enters, before Z3 or the walk.
qmlVersion: "2.6.2"
questionnaire:
  title: Per-name fraction tracking
  codeInit: |
    x = 1
  blocks:
    - id: b1
      title: Main
      items:
        - id: r
          kind: Question
          title: Never shown (x is 1 here)
          precondition:
            - predicate: x > 5
          input:
            control: Switch
        - id: w
          kind: Question
          title: Halves x later
          codeBlock: x = x / 2
          input:
            control: Switch
