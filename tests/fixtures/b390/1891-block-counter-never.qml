# #1891: An impossible block counter gate (negative_count < 0 while the counter starts at 0
# and only ever grows).
# Runtime: no respondent ever sees an item of the block.
# Why: Precondition reachability read the counter as a free number, so the gate was
# CONDITIONAL; each item now reads the version its earlier writers produce, so every item is
# NEVER (unreachable_item, publish refused).
qmlVersion: "2.6.2"
questionnaire:
  title: impossible block counter
  codeInit: |
    negative_count = 0
  blocks:
    - id: b_concepts
      title: Concepts
      precondition:
        - predicate: negative_count < 0
          hint: Never true
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
