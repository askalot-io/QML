# #2003: A Textarea's codeBlock sets a variable a later check reads.
# Runtime: the runtime runs every item's codeBlock, a Textarea's included, so t sets x = 1
# and r's postcondition x == 1 holds.
# Why: The builder skipped every item with no outcome model, so it never lowered t's
# codeBlock: x kept codeInit's 0 and r's check was INFEASIBLE (publish refused), with no
# t -> r dependency edge. The codeBlock is now lowered, t's own text opaque.
qmlVersion: "2.6.2"
questionnaire:
  title: textarea codeBlock
  codeInit: |
    x = 0
  blocks:
    - id: b1
      title: Main
      items:
        - id: t
          kind: Question
          title: Any comments?
          codeBlock: |
            x = 1
          input:
            control: Textarea
        - id: r
          kind: Question
          title: Confirm
          postcondition:
            - predicate: x == 1
              hint: Only after the comments
          input:
            control: Radio
            labels:
              1: Confirm
