# Language-neutral validation twin, German half (#2106 U4, R5).
#
# The same instrument as language_neutral_en.qml, whose header lists every
# positive and negative case: each title and label is in German (formal
# Sie register), and the ids, codes and conditions are byte-identical, so Z3
# and every validator verdict must match the English half.
qmlVersion: "2.0"

questionnaire:
  title: "Haushaltsbefragung"
  codeInit: |
    vehicle_owner = 0

  blocks:
    - id: b_intro
      title: "Einleitung"
      items:
        - id: c_intro
          kind: Comment
          title: "Bitte lesen Sie die folgenden Fragen sorgfältig durch."
        - id: c_section
          kind: Comment
          title: "Abschnitt 1: Haushalt"
        - id: c_postcode
          kind: Comment
          title: "Bitte tragen Sie Ihre Postleitzahl in das Feld unten ein."
        - id: c_contact
          kind: Comment
          title: "Geben Sie die Telefonnummer an, unter der Sie am besten erreichbar sind."
        - id: c_list
          kind: Comment
          title: "Nennen Sie alle Personen, die in diesem Haushalt leben."

    - id: b_household
      title: "Haushalt"
      items:
        - id: q_size
          kind: Question
          title: "Wie viele Personen leben in Ihrem Haushalt?"
          input:
            control: Editbox
            min: 1
            max: 12
        - id: q_children
          kind: Question
          title: "Wie viele davon sind unter 18 Jahre alt?"
          input:
            control: Editbox
            min: 0
            max: 12
          postcondition:
            - predicate: "q_children.outcome <= q_size.outcome"
              hint: "Es kann nicht mehr Kinder als Haushaltsmitglieder geben."
        - id: q_insurance
          kind: Question
          title: "Welche Krankenversicherungen haben Sie?"
          input:
            control: Checkbox
            labels:
              1: "Gesetzlich"
              2: "Privat"
              4: "Keine davon"
        - id: q_symptoms
          kind: Question
          title: "Welche Beschwerden hatten Sie letzte Woche?"
          input:
            control: Checkbox
            labels:
              1: "Kopfschmerzen"
              2: "Fieber"
              4: "Nichts"
        - id: q_vehicles
          kind: Question
          title: "Welche Fahrzeuge besitzt Ihr Haushalt?"
          input:
            control: Checkbox
            labels:
              1: "Auto"
              2: "Fahrrad"
              4: "Kein Fahrzeug"
          codeBlock: |
            vehicle_owner = 1 if q_vehicles.outcome in (1, 2, 3) else 0
        - id: q_channels
          kind: Question
          title: "Wo informieren Sie sich über Nachrichten?"
          input:
            control: Checkbox
            labels:
              1: "Fernsehen"
              2: "Internet"
              4: "Weiß nicht"
              8: "Keine"
          postcondition:
            - predicate: "(q_channels.outcome // 8) % 2 == 0 or q_channels.outcome == 8"
              hint: "Entfernen Sie die übrigen Häkchen, wenn Sie „Keine“ wählen."

        - id: q_trust
          kind: Question
          title: "Welchen dieser Quellen vertrauen Sie?"
          input:
            control: Checkbox
            labels:
              1: "Zeitungen"
              2: "Radio"
              4: "Keine Angabe"
              8: "Trifft nicht zu"
              16: "Keine Ahnung"
              32: "Keine Meinung"

    - id: b_vehicle
      title: "Fahrzeugnutzung"
      precondition:
        - predicate: "vehicle_owner == 1"
      items:
        - id: q_km
          kind: Question
          title: "Wie viele Kilometer fahren Sie in einer typischen Woche?"
          input:
            control: Editbox
            min: 0
            max: 5000
        - id: q_never
          kind: Question
          title: "Wie viele Fahrzeuge besitzen Sie insgesamt?"
          precondition:
            - predicate: "q_size.outcome > 12"
          input:
            control: Editbox
            min: 0
            max: 20
