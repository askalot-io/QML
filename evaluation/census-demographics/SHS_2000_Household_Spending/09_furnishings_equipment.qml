qmlVersion: "1.0"
questionnaire:
  title: "SHS 2000 - Section L: Household Furnishings and Equipment"

  blocks:
    # =========================================================================
    # BLOCK 1: FURNISHINGS, ART AND ANTIQUES (L_Q01-Q08)
    # =========================================================================
    # No routing — all sequential expenditure items.
    # Include purchases for vacation homes. Include sales taxes.
    # Exclude business expenses.
    # =========================================================================
    - id: b_furnishings_art
      title: "Furnishings, Art and Antiques"
      items:
        # L_Q01: Furniture
        - id: q_l_q01
          kind: Question
          title: "How much did your household spend in 2000 on furniture for indoor or outdoor use? (Include mattresses)"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q02: Mirrors and frames
        - id: q_l_q02
          kind: Question
          title: "Glass mirrors, and mirror and picture frames?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q03: Lamps
        - id: q_l_q03
          kind: Question
          title: "Lamps and lampshades?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q04: Rugs
        - id: q_l_q04
          kind: Question
          title: "Rugs, mats and underpadding?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q05: Window coverings and textiles
        - id: q_l_q05
          kind: Question
          title: "Window coverings and household textiles (curtains, blinds, bedding, towels)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q06: Art
        - id: q_l_q06
          kind: Question
          title: "Works of art, carvings and vases?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q07: Antiques
        - id: q_l_q07
          kind: Question
          title: "Antiques (100+ years old)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q08: Maintenance/repair of furniture
        - id: q_l_q08
          kind: Question
          title: "Maintenance and repair of furniture, carpeting and textiles?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK 2: HOME ENTERTAINMENT EQUIPMENT (L_Q09-Q13)
    # =========================================================================
    # Net purchase price after trade-in.
    # =========================================================================
    - id: b_entertainment_equipment
      title: "Home Entertainment Equipment"
      items:
        # L_Q09: Audio equipment
        - id: q_l_q09
          kind: Question
          title: "Audio equipment (tape players, CD players, receivers, speakers)? (Net purchase price after trade-in)"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q10: TVs, VCRs, camcorders
        - id: q_l_q10
          kind: Question
          title: "TVs, VCRs, camcorders and video components?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q11: Pre-recorded media
        - id: q_l_q11
          kind: Question
          title: "CDs, pre-recorded audiotapes, videos and videodiscs?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q12: Blank media
        - id: q_l_q12
          kind: Question
          title: "Blank audio and video tapes?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q13: Other entertainment equipment
        - id: q_l_q13
          kind: Question
          title: "Other home entertainment equipment (satellite dishes, headphones, etc.)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK 3: COMPUTER EQUIPMENT (L_Q14.1-Q16)
    # =========================================================================
    - id: b_computer_equipment
      title: "Computer Equipment"
      items:
        # L_Q14.1: Computer hardware (new)
        - id: q_l_q14_1
          kind: Question
          title: "Computer hardware purchased new?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q14.2: Computer hardware (used)
        - id: q_l_q14_2
          kind: Question
          title: "Computer hardware purchased used?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q14.3: Sale of computer hardware (Category B)
        - id: q_l_q14_3
          kind: Question
          title: "Amount received from sale of computer hardware? (Category B — deducted from total)"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q15: Computer software
        - id: q_l_q15
          kind: Question
          title: "Computer software?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q16: Computer supplies
        - id: q_l_q16
          kind: Question
          title: "Computer supplies and other equipment?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK 4: HOME ENTERTAINMENT SERVICES (L_Q17-Q20)
    # =========================================================================
    - id: b_entertainment_services
      title: "Home Entertainment Services"
      items:
        # L_Q17: Video rentals
        - id: q_l_q17
          kind: Question
          title: "Rental of videos and videodiscs?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q18: Maintenance/repair of entertainment equipment
        - id: q_l_q18
          kind: Question
          title: "Maintenance and repair of home entertainment equipment?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q19: Cablevision/satellite
        - id: q_l_q19
          kind: Question
          title: "Rental of cablevision and satellite services?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q20: Rental of entertainment equipment
        - id: q_l_q20
          kind: Question
          title: "Rental of home entertainment equipment and other services?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK 5: MAJOR HOUSEHOLD APPLIANCES (L_Q21-Q31)
    # =========================================================================
    # Net purchase price after trade-in.
    # =========================================================================
    - id: b_major_appliances
      title: "Major Household Appliances"
      items:
        # L_Q21: Refrigerators/freezers
        - id: q_l_q21
          kind: Question
          title: "Refrigerators and freezers? (Net purchase price after trade-in)"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q22: Stoves/ranges
        - id: q_l_q22
          kind: Question
          title: "Cooking stoves and ranges?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q23: Microwave/convection ovens
        - id: q_l_q23
          kind: Question
          title: "Microwave and convection ovens?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q24: Washers/dryers
        - id: q_l_q24
          kind: Question
          title: "Washers and dryers?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q25: Vacuum cleaners
        - id: q_l_q25
          kind: Question
          title: "Vacuum cleaners and rug cleaning equipment?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q26: Sewing machines
        - id: q_l_q26
          kind: Question
          title: "Sewing machines?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q27: Portable dishwashers
        - id: q_l_q27
          kind: Question
          title: "Portable dishwashers?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q28: Gas barbecues
        - id: q_l_q28
          kind: Question
          title: "Gas barbecues?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q29: Air conditioners, humidifiers
        - id: q_l_q29
          kind: Question
          title: "Room air conditioners, humidifiers and dehumidifiers?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q30.1: Attachments and parts
        - id: q_l_q30_1
          kind: Question
          title: "Attachments and parts for major appliances?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q30.2: Maintenance/repair of appliances
        - id: q_l_q30_2
          kind: Question
          title: "Maintenance and repair of major appliances?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q31: Sale of major appliances (Category B)
        - id: q_l_q31
          kind: Question
          title: "Amount received from sale of major appliances? (Category B — deducted from total)"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK 6: SMALL APPLIANCES AND FOOD EQUIPMENT (L_Q32-Q36)
    # =========================================================================
    - id: b_small_appliances
      title: "Small Electrical Appliances and Food Equipment"
      items:
        # L_Q32: Electric food preparation
        - id: q_l_q32
          kind: Question
          title: "Electric food preparation appliances?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q33: Electric personal care
        - id: q_l_q33
          kind: Question
          title: "Electric hairstyling and personal care appliances?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q34: Other electric appliances
        - id: q_l_q34
          kind: Question
          title: "All other electric appliances and equipment?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q35: Tableware
        - id: q_l_q35
          kind: Question
          title: "Tableware, flatware and knives?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q36: Non-electric kitchen equipment
        - id: q_l_q36
          kind: Question
          title: "Non-electric kitchen and cooking equipment?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK 7: TOOLS AND OTHER EQUIPMENT (L_Q37-Q47)
    # =========================================================================
    - id: b_tools_equipment
      title: "Tools, Equipment and Services"
      items:
        # L_Q37: Power lawn/garden equipment
        - id: q_l_q37
          kind: Question
          title: "Power lawn and garden equipment?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q38: Snow blowers
        - id: q_l_q38
          kind: Question
          title: "Snow blowers?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q39: Other lawn/garden/snow tools
        - id: q_l_q39
          kind: Question
          title: "Other lawn, garden and snow removal tools?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q40: Power tools
        - id: q_l_q40
          kind: Question
          title: "Power tools and equipment?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q41: Other tools
        - id: q_l_q41
          kind: Question
          title: "Other tools?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q42: Non-electric cleaning equipment
        - id: q_l_q42
          kind: Question
          title: "Non-electric cleaning equipment?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q43: Luggage
        - id: q_l_q43
          kind: Question
          title: "Luggage?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q44: Home security equipment
        - id: q_l_q44
          kind: Question
          title: "Home security equipment?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q45: Other household equipment
        - id: q_l_q45
          kind: Question
          title: "Other household equipment, parts and accessories?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q46: Maintenance/repair of household equipment
        - id: q_l_q46
          kind: Question
          title: "Maintenance and repair of household equipment (not previously reported)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # L_Q47: Other furnishings/equipment services
        - id: q_l_q47
          kind: Question
          title: "Other services related to furnishings and equipment (security services, key-making, installations, rentals)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"
