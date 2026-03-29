qmlVersion: "1.0"
questionnaire:
  title: "ESS Round 12 - Religion, Discrimination, Citizenship, Parents' Birthplace, EU Referendum (A70-A89b)"

  codeInit: |
    is_eu_member: {0, 1}

  blocks:
    # =========================================================================
    # BLOCK 1: RELIGION (A70-A76)
    # =========================================================================
    # Routing chain:
    #   A70=1 (Yes) → A71 → skip to A74
    #   A70=0 (No)  → A72=1 (Yes) → A73 → A74
    #                  A72=0 (No)  → A74
    #   A74-A76: ASK ALL
    # =========================================================================
    - id: b_religion
      title: "Religion"
      items:
        # A70: Belong to a religion? (Yes/No)
        - id: q_a70
          kind: Question
          title: "Do you consider yourself as belonging to any particular religion or denomination?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # A71: Current religion denomination
        # ASK IF A70 = Yes (1). After answering → skip to A74
        - id: q_a71
          kind: Question
          title: "Which religion or denomination do you belong to?"
          precondition:
            - predicate: q_a70.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Roman Catholic"
              2: "Protestant"
              3: "Eastern Orthodox"
              4: "Other Christian denomination"
              5: "Jewish"
              6: "Islam"
              7: "Eastern religions (Buddhism, Hinduism, etc.)"
              8: "Other non-Christian religions"
              9: "Evangelical"
              10: "Pentecostal"
              11: "Anglican"
              12: "Methodist"
              13: "Baptist"
              14: "Lutheran"
              15: "Presbyterian"
              16: "Other"

        # A72: Ever belonged to a religion?
        # ASK IF A70 = No (0)
        - id: q_a72
          kind: Question
          title: "Have you ever considered yourself as belonging to any particular religion or denomination?"
          precondition:
            - predicate: q_a70.outcome == 0
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # A73: Past religion denomination
        # ASK IF A70 = No (0) AND A72 = Yes (1)
        - id: q_a73
          kind: Question
          title: "Which religion or denomination did you belong to in the past?"
          precondition:
            - predicate: q_a70.outcome == 0
            - predicate: q_a72.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Roman Catholic"
              2: "Protestant"
              3: "Eastern Orthodox"
              4: "Other Christian denomination"
              5: "Jewish"
              6: "Islam"
              7: "Eastern religions (Buddhism, Hinduism, etc.)"
              8: "Other non-Christian religions"
              9: "Evangelical"
              10: "Pentecostal"
              11: "Anglican"
              12: "Methodist"
              13: "Baptist"
              14: "Lutheran"
              15: "Presbyterian"
              16: "Other"

        # A74: Religiosity (0–10 scale) — ASK ALL
        - id: q_a74
          kind: Question
          title: "Regardless of whether you belong to a particular religion, how religious would you say you are?"
          input:
            control: Slider
            min: 0
            max: 10
            step: 1
            left: "Not at all religious"
            right: "Very religious"

        # A75: Religious service attendance — ASK ALL
        - id: q_a75
          kind: Question
          title: "Apart from special occasions such as weddings and funerals, about how often do you attend religious services nowadays?"
          input:
            control: Radio
            labels:
              1: "Every day"
              2: "More than once a week"
              3: "Once a week"
              4: "At least once a month"
              5: "Only on special holy days"
              6: "Less often"
              7: "Never"

        # A76: Prayer frequency — ASK ALL
        - id: q_a76
          kind: Question
          title: "Apart from when you are at religious services, how often, if at all, do you pray?"
          input:
            control: Radio
            labels:
              1: "Every day"
              2: "More than once a week"
              3: "Once a week"
              4: "At least once a month"
              5: "Only on special holy days"
              6: "Less often"
              7: "Never"

    # =========================================================================
    # BLOCK 2: DISCRIMINATION (A77-A78)
    # =========================================================================
    # Routing: A77=1 (Yes) → A78; A77=0 (No) → skip A78
    # =========================================================================
    - id: b_discrimination
      title: "Discrimination"
      items:
        # A77: Member of discriminated group? (Yes/No)
        - id: q_a77
          kind: Question
          title: "Would you describe yourself as being a member of a group that is discriminated against in this country?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # A78: Grounds for discrimination (multi-select)
        # ASK IF A77 = Yes (1). Checkbox keys are powers of 2.
        - id: q_a78
          kind: Question
          title: "On what grounds is your group discriminated against?"
          precondition:
            - predicate: q_a77.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "Colour or race"
              2: "Nationality"
              4: "Religion"
              8: "Language"
              16: "Ethnic group"
              32: "Age"
              64: "Gender"
              128: "Sexuality"
              256: "Disability"
              512: "Other"

    # =========================================================================
    # BLOCK 3: CITIZENSHIP AND IMMIGRATION BACKGROUND (A79-A84)
    # =========================================================================
    # Routing:
    #   A79: ASK ALL
    #   A80=1 (Yes, born in country) → skip to A83
    #   A80=0 (No) → A81, A82 → A83
    #   A83, A84: ASK ALL
    # =========================================================================
    - id: b_citizenship
      title: "Citizenship and Immigration Background"
      items:
        # A79: Citizen of country? — ASK ALL
        - id: q_a79
          kind: Question
          title: "Are you a citizen of [country]?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # A80: Born in country?
        - id: q_a80
          kind: Question
          title: "Were you born in [country]?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # A81: Country born in (open text)
        # ASK IF A80 = No (0)
        - id: q_a81
          kind: Question
          title: "In which country were you born?"
          precondition:
            - predicate: q_a80.outcome == 0
          input:
            control: Textarea
            placeholder: "Enter country name"

        # A82: Year first came to live in country
        # ASK IF A80 = No (0)
        - id: q_a82
          kind: Question
          title: "What year did you first come to live in [country]?"
          precondition:
            - predicate: q_a80.outcome == 0
          input:
            control: Editbox
            min: 1900
            max: 2026

        # A83: Languages spoken at home (open text) — ASK ALL
        - id: q_a83
          kind: Question
          title: "What language or languages do you speak most often at home?"
          input:
            control: Textarea
            placeholder: "Enter up to two languages"

        # A84: Same race/ethnic group as majority? — ASK ALL
        - id: q_a84
          kind: Question
          title: "Do you feel you are part of the same race or ethnic group as most people in [country]?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

    # =========================================================================
    # BLOCK 4: PARENTS' BIRTHPLACE (A85-A88)
    # =========================================================================
    # Routing:
    #   A85=1 or 7 (Yes/Prefer not to answer) → skip to A87
    #   A85=0 (No) → A86 → A87
    #   A87=1 or 7 (Yes/Prefer not to answer) → skip to A89
    #   A87=0 (No) → A88
    #
    # Note: Source uses {1: Yes, 2: No, 7: Prefer not to answer} but Switch
    # only supports 0/1. Use Radio for A85 and A87 since they have 3 options.
    # =========================================================================
    - id: b_parents_birthplace
      title: "Parents' Birthplace"
      items:
        # A85: Father born in country?
        # Three options (Yes/No/Prefer not to answer) → Radio
        - id: q_a85
          kind: Question
          title: "Was your father born in [country]?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Prefer not to answer"

        # A86: Father's birth country (open text)
        # ASK IF A85 = 2 (No)
        - id: q_a86
          kind: Question
          title: "In which country was your father born?"
          precondition:
            - predicate: q_a85.outcome == 2
          input:
            control: Textarea
            placeholder: "Enter country name"

        # A87: Mother born in country?
        # Three options (Yes/No/Prefer not to answer) → Radio — ASK ALL
        - id: q_a87
          kind: Question
          title: "Was your mother born in [country]?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Prefer not to answer"

        # A88: Mother's birth country (open text)
        # ASK IF A87 = 2 (No)
        - id: q_a88
          kind: Question
          title: "In which country was your mother born?"
          precondition:
            - predicate: q_a87.outcome == 2
          input:
            control: Textarea
            placeholder: "Enter country name"

    # =========================================================================
    # BLOCK 5: EU REFERENDUM (A89a-A89b)
    # =========================================================================
    # Mutually exclusive country variants controlled by extern is_eu_member.
    # Only one of A89a or A89b is asked per country.
    # =========================================================================
    - id: b_eu_referendum
      title: "EU Referendum"
      items:
        # A89a: EU member country version
        # ASK IF country is an EU member
        - id: q_a89a
          kind: Question
          title: "Imagine there were a referendum in [country] tomorrow about membership of the European Union. Would you vote for [country] to remain a member of the European Union or to leave the European Union?"
          precondition:
            - predicate: is_eu_member == 1
          input:
            control: Radio
            labels:
              1: "Remain a member of the European Union"
              2: "Leave the European Union"
              33: "(Would submit a blank ballot paper)"
              44: "(Would spoil the ballot paper)"
              55: "(Would not vote)"
              65: "(Not eligible to vote)"

        # A89b: Non-EU member country version
        # ASK IF country is NOT an EU member
        - id: q_a89b
          kind: Question
          title: "Imagine there were a referendum in [country] tomorrow about membership of the European Union. Would you vote for [country] to become a member of the European Union or to remain outside the European Union?"
          precondition:
            - predicate: is_eu_member == 0
          input:
            control: Radio
            labels:
              1: "Become a member of the European Union"
              2: "Remain outside the European Union"
              33: "(Would submit a blank ballot paper)"
              44: "(Would spoil the ballot paper)"
              55: "(Would not vote)"
              65: "(Not eligible to vote)"
