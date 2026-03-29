qmlVersion: "1.0"
questionnaire:
  title: "SHS 2000 - Section P: Personal and Health Care"

  blocks:
    # =========================================================================
    # BLOCK 1: PERSONAL CARE (P_Q01-Q04)
    # =========================================================================
    # No routing — all sequential expenditure items.
    # =========================================================================
    - id: b_personal_care
      title: "Personal Care"
      items:
        # P_Q01: Hair grooming
        - id: q_p_q01
          kind: Question
          title: "How much did your household spend in 2000 on hair grooming services?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # P_Q02: Other personal services
        - id: q_p_q02
          kind: Question
          title: "Other personal services (hair removal, manicures, facials)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # P_Q03: Personal care preparations
        - id: q_p_q03
          kind: Question
          title: "Personal care preparations (soap, shampoo, makeup, sunscreen)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # P_Q04: Personal care supplies and equipment
        - id: q_p_q04
          kind: Question
          title: "Personal care supplies and equipment (brushes, wigs, razors)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK 2: HEALTH INSURANCE PREMIUMS (P_Q05.1-Q05.4)
    # =========================================================================
    - id: b_health_insurance
      title: "Health Insurance Premiums"
      items:
        # P_Q05.1: Provincial/territorial plans
        - id: q_p_q05_1
          kind: Question
          title: "How much did your household spend in 2000 on provincial/territorial hospital, medical and drug plans?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # P_Q05.2: Private health insurance
        - id: q_p_q05_2
          kind: Question
          title: "Private health insurance plans?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # P_Q05.3: Dental plans
        - id: q_p_q05_3
          kind: Question
          title: "Dental plans (separate policies)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # P_Q05.4: Accident and disability insurance
        - id: q_p_q05_4
          kind: Question
          title: "Accident and disability insurance?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK 3: DIRECT HEALTH COSTS (P_Q06-Q16)
    # =========================================================================
    - id: b_direct_health
      title: "Direct Health Costs"
      items:
        # P_Q06: Prescription eye wear
        - id: q_p_q06
          kind: Question
          title: "How much did your household spend in 2000 on prescription eye wear?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # P_Q07: Other eye care goods
        - id: q_p_q07
          kind: Question
          title: "Other eye care goods?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # P_Q08: Eye care services
        - id: q_p_q08
          kind: Question
          title: "Eye exams, eye surgery and other eye care services?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # P_Q09: Dental services
        - id: q_p_q09
          kind: Question
          title: "Dental services and orthodontic/periodontal procedures?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # P_Q10: Physicians' care
        - id: q_p_q10
          kind: Question
          title: "Physicians' care?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # P_Q11: Other health care practitioners
        - id: q_p_q11
          kind: Question
          title: "Other health care practitioners?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # P_Q12: Hospital care
        - id: q_p_q12
          kind: Question
          title: "Hospital care?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # P_Q13: Other medical services
        - id: q_p_q13
          kind: Question
          title: "Weight control, quit-smoking, other medical services?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # P_Q14: Prescribed medicines
        - id: q_p_q14
          kind: Question
          title: "Prescribed medicines, drugs and pharmaceuticals?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # P_Q15: OTC medicines
        - id: q_p_q15
          kind: Question
          title: "Other medicines, drugs and pharmaceuticals (over-the-counter, vitamins)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # P_Q16: Health care supplies
        - id: q_p_q16
          kind: Question
          title: "Health care supplies and goods (first aid, hearing aids, wheelchairs)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"
