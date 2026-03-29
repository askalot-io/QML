qmlVersion: "1.0"
questionnaire:
  title: "SHS 2000 - Section Q: Automobiles and Trucks"

  codeInit: |
    has_vehicle = 0

  blocks:
    # =========================================================================
    # BLOCK 1: VEHICLE SCREENER
    # =========================================================================
    - id: b_vehicle_screener
      title: "Vehicle Ownership Screener"
      items:
        # Q_Q01: Own/lease/operate a vehicle?
        - id: q_q_q01
          kind: Question
          title: "In 2000, did anyone in your household own, lease or operate a car, van or truck for private use?"
          codeBlock: |
            if q_q_q01.outcome == 1:
                has_vehicle = 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

    # =========================================================================
    # BLOCK 2: VEHICLE DETAILS (per-vehicle grid)
    # =========================================================================
    # The original questionnaire repeats Q.2-Q.9 for up to 4 vehicles (A-D).
    # QML cannot dynamically loop, so ONE representative vehicle is modeled.
    # =========================================================================
    - id: b_vehicle_details
      title: "Vehicle Details"
      precondition:
        - predicate: has_vehicle == 1
      items:
        - id: q_q_vehicle_note
          kind: Comment
          title: "The following questions apply to each vehicle owned, leased or operated by household members. In the original paper questionnaire, questions 2-9 repeat in a grid for up to 4 vehicles (A through D). One representative vehicle is modeled here."

        # Q_Q02: Vehicle type
        - id: q_q_q02
          kind: Question
          title: "Which best describes this vehicle?"
          input:
            control: Radio
            labels:
              1: "Car"
              2: "Van/mini-van"
              3: "Truck/SUV"

        # Q_Q03: New or used
        - id: q_q_q03
          kind: Question
          title: "When this vehicle was bought or leased, was it new or used?"
          input:
            control: Radio
            labels:
              1: "New"
              2: "Used"

        # Q_Q04: Bought in 2000?
        - id: q_q_q04
          kind: Question
          title: "Did you buy this vehicle in 2000?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q_Q05: Purchase price
        - id: q_q_q05
          kind: Question
          title: "What was the purchase price after trade-in allowance?"
          precondition:
            - predicate: q_q_q04.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # Q_Q06: Leased?
        - id: q_q_q06
          kind: Question
          title: "Was this vehicle leased in 2000?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # Q_Q06.1: Lease cost
        - id: q_q_q06_1
          kind: Question
          title: "What was the total leasing cost paid in 2000?"
          precondition:
            - predicate: q_q_q06.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # Q_Q07: Status at Dec 31
        - id: q_q_q07
          kind: Question
          title: "What was the status of this vehicle at December 31, 2000?"
          input:
            control: Radio
            labels:
              1: "Owned"
              2: "Leased"
              3: "Returned to lessor"
              4: "Sold/traded-in on lease"
              5: "Traded-in on purchase"
              6: "Owned by non-member"
              7: "Other"

        # Q_Q08: Sale amount (if sold/traded on lease)
        - id: q_q_q08
          kind: Question
          title: "If sold or traded-in on lease, what was the net amount received?"
          precondition:
            - predicate: q_q_q07.outcome == 4
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # Q_Q09: Trade-in value (if traded on purchase)
        - id: q_q_q09
          kind: Question
          title: "If traded-in on purchase, what was the trade-in value?"
          precondition:
            - predicate: q_q_q07.outcome == 5
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK 3: VEHICLE OPERATING EXPENSES
    # =========================================================================
    - id: b_vehicle_operation
      title: "Vehicle Operating Expenses"
      precondition:
        - predicate: has_vehicle == 1
      items:
        # Q_Q10: Gas and fuels
        - id: q_q_q10
          kind: Question
          title: "How much was spent on gas and other fuels?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # Q_Q11: Accessories and attachments
        - id: q_q_q11
          kind: Question
          title: "How much was spent on accessories and attachments (radios, heaters, baby seats)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # Q_Q12: Tires, batteries, parts
        - id: q_q_q12
          kind: Question
          title: "How much was spent on tires, batteries and other parts and supplies?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # Q_Q13: Other maintenance and repair
        - id: q_q_q13
          kind: Question
          title: "How much was spent on other maintenance and repair?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # Q_Q14: Registration fees
        - id: q_q_q14
          kind: Question
          title: "How much was spent on vehicle registration fees?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # Q_Q15: Insurance premiums
        - id: q_q_q15
          kind: Question
          title: "How much was spent on vehicle insurance premiums?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # Q_Q16: Parking costs
        - id: q_q_q16
          kind: Question
          title: "How much was spent on parking costs (work, school, park-and-ride, meters)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # Q_Q17: Other operation services
        - id: q_q_q17
          kind: Question
          title: "How much was spent on other operation services (auto association, towing, tolls)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # Q_Q18: Business percentage
        - id: q_q_q18
          kind: Question
          title: "What amount or percentage of operating expenses was charged to business?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # Q_Q19: Insurance repairs
        - id: q_q_q19
          kind: Question
          title: "What was the value of repair jobs covered by insurance?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK 4: RENTED VEHICLES
    # =========================================================================
    - id: b_rented_vehicles
      title: "Rented Vehicles"
      items:
        # Q_Q20.1: Rented cars
        - id: q_q_q20_1
          kind: Question
          title: "How much was spent on rented cars (rental fees, gas, other expenses)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # Q_Q20.2: Rented trucks
        - id: q_q_q20_2
          kind: Question
          title: "How much was spent on rented trucks or vans (rental fees, gas, other expenses)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # Q_Q21: Licences and tests
        - id: q_q_q21
          kind: Question
          title: "How much was spent on drivers' licences and tests?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # Q_Q22: Driving lessons
        - id: q_q_q22
          kind: Question
          title: "How much was spent on driving lessons?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"
