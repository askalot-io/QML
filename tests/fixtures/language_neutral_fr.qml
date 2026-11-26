# Language-neutral validation twin, French half (#2106 U4, R5).
#
# The same instrument as language_neutral_en.qml, whose header lists every
# positive and negative case: each title and label is in French (formal
# vous register), and the ids, codes and conditions are byte-identical, so Z3
# and every validator verdict must match the English half.
qmlVersion: "2.0"

questionnaire:
  title: "Enquête auprès des ménages"
  codeInit: |
    vehicle_owner = 0

  blocks:
    - id: b_intro
      title: "Introduction"
      items:
        - id: c_intro
          kind: Comment
          title: "Veuillez lire attentivement les questions suivantes."
        - id: c_section
          kind: Comment
          title: "Section 1 : Ménage"
        - id: c_postcode
          kind: Comment
          title: "Veuillez indiquer votre code postal dans la case ci-dessous."
        - id: c_contact
          kind: Comment
          title: "Précisez le numéro de téléphone auquel nous pouvons le mieux vous joindre."
        - id: c_list
          kind: Comment
          title: "Énumérez toutes les personnes qui vivent dans ce ménage."

    - id: b_household
      title: "Ménage"
      items:
        - id: q_size
          kind: Question
          title: "Combien de personnes vivent dans votre ménage ?"
          input:
            control: Editbox
            min: 1
            max: 12
        - id: q_children
          kind: Question
          title: "Combien d'entre elles ont moins de 18 ans ?"
          input:
            control: Editbox
            min: 0
            max: 12
          postcondition:
            - predicate: "q_children.outcome <= q_size.outcome"
              hint: "Le nombre d'enfants ne peut pas dépasser le nombre de membres du ménage."
        - id: q_insurance
          kind: Question
          title: "Quelles assurances maladie avez-vous ?"
          input:
            control: Checkbox
            labels:
              1: "Publique"
              2: "Privée"
              4: "Aucun"
        - id: q_symptoms
          kind: Question
          title: "Quels symptômes avez-vous eus la semaine dernière ?"
          input:
            control: Checkbox
            labels:
              1: "Maux de tête"
              2: "Fièvre"
              4: "Rien"
        - id: q_vehicles
          kind: Question
          title: "Quels véhicules votre ménage possède-t-il ?"
          input:
            control: Checkbox
            labels:
              1: "Voiture"
              2: "Vélo"
              4: "Aucun véhicule"
          codeBlock: |
            vehicle_owner = 1 if q_vehicles.outcome in (1, 2, 3) else 0
        - id: q_channels
          kind: Question
          title: "Par quels moyens vous informez-vous de l'actualité ?"
          input:
            control: Checkbox
            labels:
              1: "Télévision"
              2: "Internet"
              4: "Ne sais pas"
              8: "Aucun"
          postcondition:
            - predicate: "(q_channels.outcome // 8) % 2 == 0 or q_channels.outcome == 8"
              hint: "Décochez les autres options si vous choisissez « Aucun »."

        - id: q_trust
          kind: Question
          title: "À quelles sources parmi celles-ci faites-vous confiance ?"
          input:
            control: Checkbox
            labels:
              1: "Journaux"
              2: "Radio"
              4: "Préfère ne pas répondre"
              8: "Sans objet"
              16: "Aucune idée"
              32: "Sans opinion"

    - id: b_vehicle
      title: "Utilisation du véhicule"
      precondition:
        - predicate: "vehicle_owner == 1"
      items:
        - id: q_km
          kind: Question
          title: "Combien de kilomètres parcourez-vous en voiture au cours d'une semaine type ?"
          input:
            control: Editbox
            min: 0
            max: 5000
        - id: q_never
          kind: Question
          title: "Combien de véhicules possédez-vous au total ?"
          precondition:
            - predicate: "q_size.outcome > 12"
          input:
            control: Editbox
            min: 0
            max: 20
