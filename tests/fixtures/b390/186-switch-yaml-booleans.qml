# #186: YAML turns on/off and true/false into booleans.
# Runtime: Loads as {on: Agree, off: Disagree}.
# Why: YAML 1.1 reads true / false / yes / no / on / off keys as booleans, which the closed schema
# would refuse.
qmlVersion: "2.6.2"
questionnaire:
  title: Switch label spellings
  blocks:
    - id: b1
      title: Main
      items:
        - id: s
          kind: Question
          title: Do you agree?
          input:
            control: Switch
            true: Agree
            false: Disagree
