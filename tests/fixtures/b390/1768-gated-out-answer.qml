# #1768: An API answer to an item its gate excludes.
# Runtime: The walk never asks q_b when q_a is No. Before PR #1807 an MCP or REST submit could
# still record an answer.
# Why: process_item checked the domain and the postcondition, but not the item's own precondition.
qmlVersion: "2.6.2"
questionnaire:
  title: Answer to a gated-out item
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
        - id: q_b
          kind: Question
          title: Car or van?
          precondition:
            - predicate: q_a.outcome == 1
          input:
            control: Radio
            labels:
              1: Car
              2: Van
