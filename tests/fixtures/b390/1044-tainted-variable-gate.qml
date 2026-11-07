# #1844 (runtime #1044): A gate reading a variable a codeBlock computed from an answer left blank.
# Runtime: q_a may be submitted blank; its codeBlock reads that blank, so the runtime marks
# flag unknown (#1044), the gate on flag is undecided and r is skipped.
# Why: The model gave flag a fresh value under the blank (#1848) but no unknown mark, so a
# gate true for every number (flag < 5 or flag >= 5) was proven ALWAYS; the mark now makes
# the leaf unknown as a blank answer does, so r is CONDITIONAL.
qmlVersion: "2.6.2"
questionnaire:
  title: tainted variable gate
  codeInit: |
    flag = 0
  blocks:
    - id: b1
      title: Main
      items:
        - id: q_a
          kind: Question
          title: Do you drive?
          codeBlock: |
            flag = 1 if q_a.outcome == 1 else 2
          input:
            control: Radio
            labels:
              1: 'Yes'
              2: 'No'
        - id: r
          kind: Question
          title: Follow-up
          precondition:
            - predicate: flag < 5 or flag >= 5
              hint: Asked once flag is known
          input:
            control: Radio
            labels:
              1: Confirm
