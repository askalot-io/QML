qmlVersion: "1.0"
questionnaire:
  title: "SHS 2000 - Section R: Recreational Vehicles and Transportation"

  codeInit: |
    has_rec_vehicle = 0
    has_package_trip = 0

  blocks:
    # =========================================================================
    # BLOCK 1: BICYCLES
    # =========================================================================
    - id: b_bicycles
      title: "Bicycles"
      items:
        # R_Q01: Bicycle purchase
        - id: q_r_q01
          kind: Question
          title: "How much was spent on purchase of bicycles, parts and accessories?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # R_Q02: Bicycle maintenance
        - id: q_r_q02
          kind: Question
          title: "How much was spent on bicycle maintenance and repairs?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK 2: RECREATIONAL VEHICLE SCREENER
    # =========================================================================
    - id: b_rec_vehicle_screener
      title: "Recreational Vehicle Screener"
      items:
        # R_Q03: Own rec vehicle?
        - id: q_r_q03
          kind: Question
          title: "In 2000, did anyone in your household own or operate a recreational vehicle for private use? (Motorcycle, snowmobile, tent/travel trailer, truck camper, boat/canoe, outboard motor, motor home, other)"
          codeBlock: |
            if q_r_q03.outcome == 1:
                has_rec_vehicle = 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

    # =========================================================================
    # BLOCK 3: RECREATIONAL VEHICLE DETAILS (per-vehicle grid)
    # =========================================================================
    # The original questionnaire repeats Q.4-Q.13 for up to 4 vehicles (A-D).
    # QML cannot dynamically loop, so ONE representative vehicle is modeled.
    # =========================================================================
    - id: b_rec_vehicle_details
      title: "Recreational Vehicle Details"
      precondition:
        - predicate: has_rec_vehicle == 1
      items:
        - id: q_r_vehicle_note
          kind: Comment
          title: "The following questions apply to each recreational vehicle owned or operated by household members. In the original paper questionnaire, questions 4-13 repeat in a grid for up to 4 vehicles (A through D). One representative vehicle is modeled here."

        # R_Q04: Vehicle type
        - id: q_r_q04
          kind: Question
          title: "What type of recreational vehicle is this? (Enter code from list)"
          input:
            control: Radio
            labels:
              1: "Motorcycle"
              2: "Snowmobile"
              3: "Tent trailer"
              4: "Travel trailer"
              5: "Truck camper"
              6: "Boat/canoe"
              7: "Outboard motor"
              8: "Motor home"
              9: "Other"

        # R_Q05: Purchase price
        - id: q_r_q05
          kind: Question
          title: "If purchased in 2000, what was the price after trade-in allowance?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # R_Q06: Accessories, parts for maintenance/repair
        - id: q_r_q06
          kind: Question
          title: "How much was spent on accessories and parts for maintenance and repair?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # R_Q07: Gasoline, diesel fuel
        - id: q_r_q07
          kind: Question
          title: "How much was spent on gasoline and diesel fuel?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # R_Q08: Maintenance and repair
        - id: q_r_q08
          kind: Question
          title: "How much was spent on maintenance and repair not covered by insurance?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # R_Q09: Vehicle insurance premiums
        - id: q_r_q09
          kind: Question
          title: "How much was spent on vehicle insurance premiums?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # R_Q10: Registration fees and licences
        - id: q_r_q10
          kind: Question
          title: "How much was spent on registration fees and licences?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # R_Q11: Other expenses
        - id: q_r_q11
          kind: Question
          title: "How much was spent on other expenses (parking, hangar, mooring, storage)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # R_Q12: Business percentage
        - id: q_r_q12
          kind: Question
          title: "What amount or percentage of operating expenses was charged to business?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # R_Q13: Sale amount
        - id: q_r_q13
          kind: Question
          title: "If sold separately in 2000, what was the net amount received?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK 4: RENTED RECREATIONAL VEHICLES
    # =========================================================================
    - id: b_rented_rec_vehicles
      title: "Rented Recreational Vehicles"
      items:
        # R_Q14: Rented rec vehicles
        - id: q_r_q14
          kind: Question
          title: "How much was spent on rented or leased recreational vehicles?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK 5: TRANSPORTATION SERVICES
    # =========================================================================
    - id: b_transportation
      title: "Transportation Services"
      items:
        # R_Q15.1: City transit
        - id: q_r_q15_1
          kind: Question
          title: "How much was spent on city bus, subway, streetcar, commuter train?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # R_Q15.2: Taxi
        - id: q_r_q15_2
          kind: Question
          title: "How much was spent on taxi?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # R_Q15.3: Airplane
        - id: q_r_q15_3
          kind: Question
          title: "How much was spent on airplane?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # R_Q15.4: Train
        - id: q_r_q15_4
          kind: Question
          title: "How much was spent on train?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # R_Q15.5: Highway bus
        - id: q_r_q15_5
          kind: Question
          title: "How much was spent on highway bus?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # R_Q15.6: Other passenger transportation
        - id: q_r_q15_6
          kind: Question
          title: "How much was spent on other passenger transportation (ferry, sightseeing, travel insurance)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # R_Q16: Moving services
        - id: q_r_q16
          kind: Question
          title: "How much was spent on household moving, storage and delivery services?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK 6: PACKAGE TRIPS
    # =========================================================================
    - id: b_package_trips
      title: "Package Trips"
      items:
        # R_Q17: Package trip?
        - id: q_r_q17
          kind: Question
          title: "Did any member of your household take a package trip in 2000?"
          codeBlock: |
            if q_r_q17.outcome == 1:
                has_package_trip = 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # R_Q17.1: Cost
        - id: q_r_q17_1
          kind: Question
          title: "What was the total cost of package trips?"
          precondition:
            - predicate: has_package_trip == 1
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"
