qmlVersion: "1.0"

questionnaire:
  title: "ACS 2025 - Housing Technology & Vehicles"

  blocks:
    - id: b_housing_technology
      title: "Technology, Vehicles & Energy"
      items:
        # H_Q10a-c: Computer types (QuestionGroup for uniform Yes/No items)
        - id: qg_h10_computers
          kind: QuestionGroup
          title: "At this house, apartment, or mobile home — do you or any member of this household own or use:"
          questions:
            - "A desktop or laptop?"
            - "A smartphone?"
            - "A tablet or other portable wireless computer?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # H_Q10d: Other computer type (separate to allow specify follow-up)
        - id: q_h10d_other_computer
          kind: Question
          title: "Do you or any member of this household own or use some other type of computer?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # H_Q10d follow-up: Specify other computer
        - id: q_h10d_specify
          kind: Question
          title: "Please specify the other type of computer."
          precondition:
            - predicate: "q_h10d_other_computer.outcome == 1"
          input:
            control: Textarea
            placeholder: "Specify type of computer"

        # H_Q11: Internet access
        - id: q_h11_internet
          kind: Question
          title: "At this house, apartment, or mobile home — do you or any member of this household have access to the Internet?"
          input:
            control: Radio
            labels:
              1: "Yes, by paying a cell phone company or Internet service provider"
              2: "Yes, without paying a cell phone company or Internet service provider"
              3: "No access to the Internet at this house, apartment, or mobile home"

        # H_Q12a-e: Internet service types (gated on paying for internet)
        - id: qg_h12_internet_types
          kind: QuestionGroup
          title: "Do you or any member of this household have access to the Internet using —"
          precondition:
            - predicate: "q_h11_internet.outcome == 1"
          questions:
            - "A cellular data plan for a smartphone or other mobile device?"
            - "Broadband (high speed) Internet service such as cable, fiber optic, or DSL?"
            - "Satellite Internet service?"
            - "Dial-up Internet service?"
            - "Some other service?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # H_Q13: Number of vehicles
        - id: q_h13_vehicles
          kind: Question
          title: "How many automobiles, vans, and trucks of one-ton capacity or less are kept at home for use by members of this household?"
          input:
            control: Dropdown
            labels:
              0: "None"
              1: "1"
              2: "2"
              3: "3"
              4: "4"
              5: "5"
              6: "6 or more"

        # H_Q14: Electric vehicle (gated on having at least 1 vehicle)
        - id: q_h14_ev
          kind: Question
          title: "Do you or any member of this household own or lease an electric vehicle? Include both all-electric and plug-in hybrid electric vehicles."
          precondition:
            - predicate: "q_h13_vehicles.outcome >= 1"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # H_Q15: Heating fuel
        - id: q_h15_fuel
          kind: Question
          title: "Which FUEL is used MOST for heating this house, apartment, or mobile home?"
          input:
            control: Dropdown
            labels:
              1: "Gas: Natural gas from underground pipes"
              2: "Gas: Bottled or tank (propane, butane, etc.)"
              3: "Electricity"
              4: "Fuel oil, kerosene, etc."
              5: "Coal or coke"
              6: "Wood"
              7: "Solar energy"
              8: "Other fuel"
              9: "No fuel used"

        # H_Q16: Solar panels
        - id: q_h16_solar
          kind: Question
          title: "Does this house, apartment, or mobile home use solar panels that generate electricity?"
          input:
            control: Switch
            off: "No"
            on: "Yes"
