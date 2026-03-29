qmlVersion: "1.0"

questionnaire:
  title: "ESS Round 12 - Voting and Political Participation"

  blocks:
    - id: b_voting
      title: "Voting"
      items:
        # A26: Voted in last national election
        - id: q_a26
          kind: Question
          title: "Some people don't vote nowadays for one reason or another. Did you vote in the last [country] national election in [month/year]?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              3: "Not eligible to vote"

        # A27: Party voted for (country-specific)
        - id: q_a27
          kind: Question
          title: "Which party did you vote for in that election?"
          precondition:
            - predicate: q_a26.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Party 1"
              2: "Party 2"
              3: "Party 3"
              4: "Party 4"
              5: "Party 5"
              6: "Party 6"
              7: "Party 7"
              8: "Party 8"
              9: "Party 9"
              10: "Party 10"
              11: "Party 11"
              12: "Party 12"
              13: "Party 13"
              14: "Party 14"
              15: "Party 15"
              16: "Party 16"
              17: "Party 17"
              18: "Party 18"
              19: "Party 19"
              20: "Party 20"
              21: "Other"

    - id: b_participation
      title: "Political Participation"
      items:
        # A28: Contacted politician
        - id: q_a28
          kind: Question
          title: "During the last 12 months, have you contacted a politician, government or local government official?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # A29: Donated to or participated in political party/pressure group
        - id: q_a29
          kind: Question
          title: "During the last 12 months, have you donated to or participated in a political party or pressure group?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # A30: Worn/displayed campaign badge/sticker
        - id: q_a30
          kind: Question
          title: "During the last 12 months, have you worn or displayed a campaign badge/sticker?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # A31: Signed a petition
        - id: q_a31
          kind: Question
          title: "During the last 12 months, have you signed a petition?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # A32: Taken part in public demonstration
        - id: q_a32
          kind: Question
          title: "During the last 12 months, have you taken part in a public demonstration?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # A33: Boycotted certain products
        - id: q_a33
          kind: Question
          title: "During the last 12 months, have you boycotted certain products?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # A34: Posted/shared political content online
        - id: q_a34
          kind: Question
          title: "During the last 12 months, have you posted or shared anything about politics online, for example on blogs, via email or on social media such as Facebook, Instagram, TikTok, or X (formerly known as Twitter)?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # A35: Volunteered for not-for-profit/charitable organisation
        - id: q_a35
          kind: Question
          title: "During the last 12 months, have you volunteered for a not-for-profit or charitable organisation?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

    - id: b_party_allegiance
      title: "Party Allegiance"
      items:
        # A36: Feel closer to a particular party
        - id: q_a36
          kind: Question
          title: "Is there a particular political party you feel closer to than all the other parties?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # A37: Which party feel closest to (country-specific)
        - id: q_a37
          kind: Question
          title: "Which political party do you feel closest to?"
          precondition:
            - predicate: q_a36.outcome == 1
          input:
            control: Dropdown
            labels:
              1: "Party 1"
              2: "Party 2"
              3: "Party 3"
              4: "Party 4"
              5: "Party 5"
              6: "Party 6"
              7: "Party 7"
              8: "Party 8"
              9: "Party 9"
              10: "Party 10"
              11: "Party 11"
              12: "Party 12"
              13: "Party 13"
              14: "Party 14"
              15: "Party 15"
              16: "Party 16"
              17: "Party 17"
              18: "Party 18"
              19: "Party 19"
              20: "Party 20"
              21: "Other"

        # A38: How close to party
        - id: q_a38
          kind: Question
          title: "How close do you feel to this party?"
          precondition:
            - predicate: q_a36.outcome == 1
          input:
            control: Radio
            labels:
              1: "Very close"
              2: "Quite close"
              3: "Not close"
              4: "Not at all close"
