qmlVersion: "1.0"
questionnaire:
  title: "SHS 2000 - Section O: Clothing"

  blocks:
    # =========================================================================
    # BLOCK 1: WOMEN'S AND GIRLS' CLOTHING (O_Q01-Q04)
    # =========================================================================
    # The original questionnaire collects per-person amounts for up to 5
    # women/girls aged 4+. Since QML cannot model dynamic person loops,
    # each category is modeled as a single household-total dollar amount.
    # Interviewers should sum amounts across all persons in each category.
    # =========================================================================
    - id: b_womens_clothing
      title: "Women and Girls 4 Years and Over"
      items:
        # Explanatory comment
        - id: q_o_womens_note
          kind: Comment
          title: "Report the TOTAL household amount for each category below, summed across all women and girls aged 4 and over in the household."

        # O_Q01: Clothing
        - id: q_o_q01
          kind: Question
          title: "Clothing (outerwear, suits, dresses, skirts, slacks, sweaters, hosiery) for women and girls 4+?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # O_Q02: Footwear
        - id: q_o_q02
          kind: Question
          title: "Footwear for women and girls 4+?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # O_Q03: Accessories
        - id: q_o_q03
          kind: Question
          title: "Accessories (gloves, hats, purses, umbrellas) for women and girls 4+?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # O_Q04: Jewellery and watches
        - id: q_o_q04
          kind: Question
          title: "Jewellery and watches for women and girls 4+?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK 2: MEN'S AND BOYS' CLOTHING (O_Q05-Q08)
    # =========================================================================
    - id: b_mens_clothing
      title: "Men and Boys 4 Years and Over"
      items:
        # Explanatory comment
        - id: q_o_mens_note
          kind: Comment
          title: "Report the TOTAL household amount for each category below, summed across all men and boys aged 4 and over in the household."

        # O_Q05: Clothing
        - id: q_o_q05
          kind: Question
          title: "Clothing (outerwear, suits, pants, shirts, sweaters, socks) for men and boys 4+?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # O_Q06: Footwear
        - id: q_o_q06
          kind: Question
          title: "Footwear for men and boys 4+?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # O_Q07: Accessories
        - id: q_o_q07
          kind: Question
          title: "Accessories (gloves, hats, ties, belts, wallets) for men and boys 4+?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # O_Q08: Jewellery and watches
        - id: q_o_q08
          kind: Question
          title: "Jewellery and watches for men and boys 4+?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK 3: CHILDREN'S CLOTHING (O_Q09-Q11)
    # =========================================================================
    - id: b_childrens_clothing
      title: "Children Under 4 Years"
      items:
        # Explanatory comment
        - id: q_o_childrens_note
          kind: Comment
          title: "Report the TOTAL household amount for each category below, summed across all children under 4 in the household."

        # O_Q09: Outerwear, daywear, sleepwear
        - id: q_o_q09
          kind: Question
          title: "Outerwear, daywear, sleepwear and cloth diapers for children under 4?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # O_Q10: Disposable diapers
        - id: q_o_q10
          kind: Question
          title: "Disposable diapers for children under 4?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # O_Q11: Footwear
        - id: q_o_q11
          kind: Question
          title: "Footwear for children under 4?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK 4: CLOTHING GIFTS (O_Q12.1-Q12.3)
    # =========================================================================
    - id: b_clothing_gifts
      title: "Gifts of Clothing"
      items:
        # O_Q12.1: Gifts for women/girls
        - id: q_o_q12_1
          kind: Question
          title: "Gifts of clothing for women and girls 4+ who are not household members?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # O_Q12.2: Gifts for men/boys
        - id: q_o_q12_2
          kind: Question
          title: "Gifts of clothing for men and boys 4+ who are not household members?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # O_Q12.3: Gifts for children under 4
        - id: q_o_q12_3
          kind: Question
          title: "Gifts of clothing for children under 4 who are not household members?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK 5: CLOTHING SERVICES (O_Q13-Q16)
    # =========================================================================
    - id: b_clothing_services
      title: "Clothing Materials and Services"
      items:
        # O_Q13: Clothing material
        - id: q_o_q13
          kind: Question
          title: "Clothing material?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # O_Q14: Notions
        - id: q_o_q14
          kind: Question
          title: "Notions (patterns, buttons, zippers, needles)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # O_Q15: Dressmaking, tailoring, storage
        - id: q_o_q15
          kind: Question
          title: "Dressmaking, tailoring, clothing storage and services?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # O_Q16: Maintenance, repair and alteration
        - id: q_o_q16
          kind: Question
          title: "Maintenance, repair and alteration of clothing, footwear and watches?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"
