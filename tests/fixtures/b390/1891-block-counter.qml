# #1891: A block counter (each item's codeBlock increments it, the block precondition reads it).
# Runtime: the walk asks the items in file order and re-checks the block gate before each
# one, so after the third "No" the rest of the block is skipped and the follow-up is shown.
# Why: The validator read the counter through every writer, so each pair of items waited
# for each other (dependency_cycle, publish refused); a reader now sees the writers before it
# in file order (D91), and the gate is verified: items 1-3 ALWAYS, items 4-6 CONDITIONAL.
qmlVersion: "2.6.2"
questionnaire:
  title: block counter
  codeInit: |
    negative_count = 0
  blocks:
    - id: b_concepts
      title: Concepts
      precondition:
        - predicate: negative_count < 3
          hint: Stop after the third negative answer
      items:
        - id: q_concept_1
          kind: Question
          title: Do you like concept 1?
          codeBlock: |
            if q_concept_1.outcome == 0:
                negative_count = negative_count + 1
          input:
            control: Radio
            labels:
              0: 'No'
              1: 'Yes'
        - id: q_concept_2
          kind: Question
          title: Do you like concept 2?
          codeBlock: |
            if q_concept_2.outcome == 0:
                negative_count = negative_count + 1
          input:
            control: Radio
            labels:
              0: 'No'
              1: 'Yes'
        - id: q_concept_3
          kind: Question
          title: Do you like concept 3?
          codeBlock: |
            if q_concept_3.outcome == 0:
                negative_count = negative_count + 1
          input:
            control: Radio
            labels:
              0: 'No'
              1: 'Yes'
        - id: q_concept_4
          kind: Question
          title: Do you like concept 4?
          codeBlock: |
            if q_concept_4.outcome == 0:
                negative_count = negative_count + 1
          input:
            control: Radio
            labels:
              0: 'No'
              1: 'Yes'
        - id: q_concept_5
          kind: Question
          title: Do you like concept 5?
          codeBlock: |
            if q_concept_5.outcome == 0:
                negative_count = negative_count + 1
          input:
            control: Radio
            labels:
              0: 'No'
              1: 'Yes'
        - id: q_concept_6
          kind: Question
          title: Do you like concept 6?
          codeBlock: |
            if q_concept_6.outcome == 0:
                negative_count = negative_count + 1
          input:
            control: Radio
            labels:
              0: 'No'
              1: 'Yes'
    - id: b_follow_up
      title: Follow-up
      precondition:
        - predicate: negative_count >= 3
          hint: Only after three negative answers
      items:
        - id: q_why
          kind: Question
          title: What put you off?
          input:
            control: Radio
            labels:
              1: Price
              2: Design
