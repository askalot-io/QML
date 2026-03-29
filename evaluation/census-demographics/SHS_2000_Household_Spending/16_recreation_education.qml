qmlVersion: "1.0"
questionnaire:
  title: "SHS 2000 - Section S: Recreation, Reading Materials and Education"

  blocks:
    # =========================================================================
    # BLOCK 1: SPORTS AND CAMPING EQUIPMENT
    # =========================================================================
    - id: b_sports_camping
      title: "Sports and Camping Equipment"
      items:
        # S_Q01: Sports equipment
        - id: q_s_q01
          kind: Question
          title: "How much was spent on sports and athletic equipment?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # S_Q02: Camping equipment
        - id: q_s_q02
          kind: Question
          title: "How much was spent on camping and picnic equipment?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK 2: PHOTOGRAPHIC
    # =========================================================================
    - id: b_photographic
      title: "Photographic"
      items:
        # S_Q03: Cameras
        - id: q_s_q03
          kind: Question
          title: "How much was spent on cameras, parts, accessories and photographic goods?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # S_Q04: Film and processing
        - id: q_s_q04
          kind: Question
          title: "How much was spent on film, processing, prints and enlargements?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # S_Q05: Photographers' services
        - id: q_s_q05
          kind: Question
          title: "How much was spent on photographers' services?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK 3: MUSIC AND RECREATION EQUIPMENT
    # =========================================================================
    - id: b_music_recreation
      title: "Music and Other Recreation Equipment"
      items:
        # S_Q06: Musical instruments
        - id: q_s_q06
          kind: Question
          title: "How much was spent on musical instruments, parts and accessories?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # S_Q07: Artists' materials
        - id: q_s_q07
          kind: Question
          title: "How much was spent on artists' materials, handicraft and hobbycraft supplies?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # S_Q08: Electronic games
        - id: q_s_q08
          kind: Question
          title: "How much was spent on electronic games and parts?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # S_Q09: Toys and games
        - id: q_s_q09
          kind: Question
          title: "How much was spent on toys and other games?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # S_Q10: Playground equipment
        - id: q_s_q10
          kind: Question
          title: "How much was spent on playground equipment and swimming pool accessories?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # S_Q11: Collectors' items
        - id: q_s_q11
          kind: Question
          title: "How much was spent on collectors' items (stamps, coins)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # S_Q12: Parts and supplies
        - id: q_s_q12
          kind: Question
          title: "How much was spent on parts and supplies for recreation equipment (camp fuels, pool chemicals, ammunition)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # S_Q13: Rental of video games
        - id: q_s_q13
          kind: Question
          title: "How much was spent on rental of video games?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # S_Q14: Rental, maintenance and repair
        - id: q_s_q14
          kind: Question
          title: "How much was spent on rental, maintenance and repair of recreation and sports equipment?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK 4: ADMISSIONS
    # =========================================================================
    - id: b_admissions
      title: "Admissions"
      items:
        # S_Q15.1: Movie theatres
        - id: q_s_q15_1
          kind: Question
          title: "How much was spent on admission to movie theatres?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # S_Q15.2: Live performing arts
        - id: q_s_q15_2
          kind: Question
          title: "How much was spent on admission to live performing arts (plays, concerts, festivals)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # S_Q15.3: Heritage facilities
        - id: q_s_q15_3
          kind: Question
          title: "How much was spent on admission to heritage facilities (museums, zoos, fairs, historic sites)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # S_Q15.4: Live sports events
        - id: q_s_q15_4
          kind: Question
          title: "How much was spent on admission to live sports events?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK 5: RECREATION SERVICES
    # =========================================================================
    - id: b_recreation_services
      title: "Recreation Services"
      items:
        # S_Q16: Coin-operated and carnival games
        - id: q_s_q16
          kind: Question
          title: "How much was spent on coin-operated and carnival games?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # S_Q17: Membership fees
        - id: q_s_q17
          kind: Question
          title: "How much was spent on membership fees for sports, recreation and health clubs?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # S_Q18: Single usage fees
        - id: q_s_q18
          kind: Question
          title: "How much was spent on single usage fees for sports, recreation and health clubs?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # S_Q19: Children's camps
        - id: q_s_q19
          kind: Question
          title: "How much was spent on children's camps (day camps, summer camps)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # S_Q20: Other cultural/recreational services
        - id: q_s_q20
          kind: Question
          title: "How much was spent on other cultural and recreational services (fishing/hunting licences, party planning)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK 6: READING MATERIALS
    # =========================================================================
    - id: b_reading
      title: "Reading Materials"
      items:
        # S_Q21: Newspapers
        - id: q_s_q21
          kind: Question
          title: "How much was spent on newspapers?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # S_Q22: Magazines and periodicals
        - id: q_s_q22
          kind: Question
          title: "How much was spent on magazines and periodicals?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # S_Q23: Books and pamphlets
        - id: q_s_q23
          kind: Question
          title: "How much was spent on books and pamphlets?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # S_Q24: Maps, sheet music
        - id: q_s_q24
          kind: Question
          title: "How much was spent on maps, sheet music and other printed matter?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # S_Q25: Services
        - id: q_s_q25
          kind: Question
          title: "How much was spent on services (duplicating, library charges, book rentals, bookbinding)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

    # =========================================================================
    # BLOCK 7: EDUCATION
    # =========================================================================
    - id: b_education
      title: "Education"
      items:
        # S_Q26: Elementary/secondary education (tuition, books, supplies)
        - id: qg_s_q26
          kind: QuestionGroup
          title: "How much was spent on elementary and secondary education?"
          questions:
            - "Tuition"
            - "Books"
            - "Supplies"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # S_Q27: Post-secondary education (tuition, books, supplies)
        - id: qg_s_q27
          kind: QuestionGroup
          title: "How much was spent on post-secondary education?"
          questions:
            - "Tuition"
            - "Books"
            - "Supplies"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # S_Q28: Other courses and lessons
        - id: q_s_q28
          kind: Question
          title: "How much was spent on other courses and lessons (music, dancing, sports, crafts)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"

        # S_Q29: Other educational services
        - id: q_s_q29
          kind: Question
          title: "How much was spent on other educational services (rental of school books/equipment)?"
          input:
            control: Editbox
            min: 0
            max: 9999999
            right: "$"
