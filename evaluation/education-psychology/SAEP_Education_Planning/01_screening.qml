qmlVersion: "1.0"
questionnaire:
  title: "SAEP - Screening"
  codeInit: |
    num_children = 0
  blocks:
    - id: b_screening
      title: "Introduction and Screening"
      items:
        - id: q_a1_num_children
          kind: Question
          title: "How many children 18 years of age or younger usually live at this dwelling? This includes children who usually live here but are now away at school, in the hospital or somewhere else."
          input:
            control: Editbox
            min: 0
            max: 20
          codeBlock: |
            num_children = q_a1_num_children.outcome

        - id: q_a2_pmk
          kind: Question
          title: "I would like to speak to the person who is the most knowledgeable about these children and about any plans made for their post-secondary education. Would this person be you?"
          precondition:
            - predicate: q_a1_num_children.outcome >= 1
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
