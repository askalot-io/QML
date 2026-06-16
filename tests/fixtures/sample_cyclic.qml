qmlVersion: "1.0"
questionnaire:
  title: "Sample Cyclic Component — is_random, cycle-tolerant linearization"
  blocks:
    - id: intro_block
      kind: Sequence
      title: "Intro"
      items:
        - id: q_go
          kind: Question
          title: "Start?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

    # is_random=true. q_x and q_y reference each other's outcome in their
    # preconditions → a 2-node CYCLE: one connected component. q_z is
    # independent → second component. T = 2 (≤ cap). The cyclic component is
    # NOT specially rejected — it is linearized via the topology's existing
    # cycle-tolerant Kahn's order (a backward edge is broken in QML file
    # order) and emitted contiguously, exactly like an acyclic component.
    - id: loop_sample
      kind: Sample
      title: "Mutually-referential pair plus a loner"
      count: 2
      is_random: true
      items:
        - id: q_x
          kind: Question
          title: "X"
          precondition:
            - predicate: "q_y.outcome >= 0 or True"
          input:
            control: Slider
            min: 1
            max: 5
        - id: q_y
          kind: Question
          title: "Y"
          precondition:
            - predicate: "q_x.outcome >= 0 or True"
          input:
            control: Slider
            min: 1
            max: 5
        - id: q_z
          kind: Question
          title: "Z (independent)"
          input:
            control: Slider
            min: 1
            max: 5
