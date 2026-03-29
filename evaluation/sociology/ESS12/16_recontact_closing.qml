qmlVersion: "1.0"

questionnaire:
  title: "ESS Round 12 - Section G: Recontact & Section H: Closing"

  blocks:
    # ── Recontact (G1-G6) ──
    - id: b_recontact
      title: "Recontact"
      items:
        # G1: Agree to recontact — 1 (Yes) → G2-G5; 0 (No) → H1
        - id: q_g1
          kind: Question
          title: "Thank you for giving your time to complete this survey today. The European Social Survey may want to contact you again to invite you to take part in further research on similar topics to those covered by the questions that you have answered here. Would it be okay if we contact you again, to invite you to take part in a follow-up study?"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # G2: Name (only if agreed to recontact)
        - id: q_g2
          kind: Question
          title: "Please enter your first name and surname below."
          precondition:
            - predicate: "q_g1.outcome == 1"
          input:
            control: Textarea
            placeholder: "First name and surname"

        # G3: Email (only if agreed to recontact)
        - id: q_g3
          kind: Question
          title: "Please enter your email address below."
          precondition:
            - predicate: "q_g1.outcome == 1"
          input:
            control: Textarea
            placeholder: "Email address"

        # G4: Address consent (only if agreed to recontact)
        - id: q_g4
          kind: Question
          title: "Do you agree that we may retain your physical address that we used to contact you for this survey?"
          precondition:
            - predicate: "q_g1.outcome == 1"
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # G5: Phone number (only if agreed to recontact)
        - id: q_g5
          kind: Question
          title: "Please enter your mobile telephone number below."
          precondition:
            - predicate: "q_g1.outcome == 1"
          input:
            control: Textarea
            placeholder: "Mobile telephone number"

        # G6: Incentive consent
        # 1 (Yes, use details) → end; 2 (No, don't want) → end; 3 (Provide other details) → H1
        - id: q_g6
          kind: Question
          title: "As a thank you for taking part in this survey we will send you a voucher. May we use the contact details you've already provided to ensure it reaches you?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No, I don't want to receive this"
              3: "No, I'd like to provide other details"

    # ── Closing (H1-H3) ──
    - id: b_closing
      title: "Closing"
      items:
        # H1: Contact details for incentive
        # Shown if declined recontact (G1=0) or wants to provide other details (G6=3)
        - id: q_h1
          kind: Question
          title: "Thank you for taking part in this survey today. Please enter your details below to ensure the voucher reaches you."
          precondition:
            - predicate: "q_g1.outcome == 0 or q_g6.outcome == 3"
          input:
            control: Textarea
            placeholder: "Name, email, phone, and/or address"

        # H2: Date of completion
        - id: q_h2
          kind: Question
          title: "Please record the date when you finished completing this questionnaire (day of month)."
          input:
            control: Editbox
            min: 1
            max: 31
            right: "(day)"

        # H3: Coder ID
        - id: q_h3
          kind: Question
          title: "Please enter your data entry coder ID number."
          input:
            control: Editbox
            min: 0
            max: 99999
