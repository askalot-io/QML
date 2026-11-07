qmlVersion: "2.0"
questionnaire:
  title: "Guard tree branches"
  blocks:
    - id: screener
      kind: Group
      title: "Screener"
      items:
        - id: q_screen
          kind: Question
          title: "Do you own a car?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
    # Branch A: one guard on the block, shared by a run of two items.
    - id: owners
      kind: Group
      title: "Car owners"
      precondition:
        - predicate: "q_screen.outcome == 1"
      items:
        - id: q_brand
          kind: Question
          title: "Which brand is it?"
          input:
            control: Radio
            labels:
              1: Domestic
              2: Imported
        - id: q_age
          kind: Question
          title: "How old is it?"
          input:
            control: Editbox
            min: 0
            max: 50
        # B nested under A: the block guard plus its own.
        - id: q_import_reason
          kind: Question
          title: "Why an imported car?"
          precondition:
            - predicate: "q_brand.outcome == 2"
          input:
            control: Radio
            labels:
              1: Price
              2: Quality
    # Branch not-A: the same guard written on each item, a shared-guard run too.
    - id: non_owners
      kind: Group
      title: "Non-owners"
      items:
        - id: q_transport
          kind: Question
          title: "How do you travel?"
          precondition:
            - predicate: "q_screen.outcome != 1"
          input:
            control: Radio
            labels:
              1: Transit
              2: Bicycle
        - id: q_plan
          kind: Question
          title: "Do you plan to buy a car?"
          precondition:
            - predicate: "q_screen.outcome != 1"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
    - id: closing
      kind: Group
      title: "Closing"
      items:
        - id: q_contact
          kind: Question
          title: "May we contact you again?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
        # Overlaps both screener branches: a parallel optional run.
        - id: q_email
          kind: Question
          title: "Your e-mail?"
          precondition:
            - predicate: "q_contact.outcome == 1"
          input:
            control: Editbox
            min: 0
            max: 1
