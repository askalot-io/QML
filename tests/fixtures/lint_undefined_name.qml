# Undefined-name lint fixture (U1).
#
# Reproduces the corpus "phantom identifier" pattern (BRFSS `smoking_status`,
# CCHS `smk_status`): a precondition references a bare variable name that no
# codeInit / codeBlock ever produces, while an item whose id is `q_<name>`
# exists. The predicate evaluation namespace is closed (see python_runner), so
# the bare name fails open at runtime and is a free symbol to Z3 — the gate
# silently enforces nothing. The undefined_name lint turns it into a hard error
# and suggests the intended `q_<name>.outcome` reference.
#
# The rest of the file is clean: the only validation issue this fixture yields
# is the single undefined_name error on `q_cigarettes_per_day`.
qmlVersion: "2.0"

questionnaire:
  title: "Undefined Name Lint Fixture"
  blocks:
    - id: b_smoking
      kind: Group
      title: "Smoking"
      items:
        - id: q_smoking_status
          kind: Question
          title: "Do you currently smoke?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
        - id: q_cigarettes_per_day
          kind: Question
          title: "How many cigarettes per day?"
          precondition:
            - predicate: "smoking_status == 1"
              hint: "Only for current smokers"
          input:
            control: Editbox
            min: 0
            max: 100
