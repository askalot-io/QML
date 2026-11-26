# Language-neutral validation twin, Spanish half (#2106 U4, R5).
#
# The same instrument as language_neutral_en.qml, whose header lists every
# positive and negative case: each title and label is in Spanish (formal
# usted register), and the ids, codes and conditions are byte-identical, so Z3
# and every validator verdict must match the English half.
qmlVersion: "2.0"

questionnaire:
  title: "Encuesta de hogares"
  codeInit: |
    vehicle_owner = 0

  blocks:
    - id: b_intro
      title: "Introducción"
      items:
        - id: c_intro
          kind: Comment
          title: "Por favor, lea atentamente las siguientes preguntas."
        - id: c_section
          kind: Comment
          title: "Sección 1: Hogar"
        - id: c_postcode
          kind: Comment
          title: "Por favor, escriba su código postal en la casilla de abajo."
        - id: c_contact
          kind: Comment
          title: "Indique el número de teléfono en el que mejor podemos localizarle."
        - id: c_list
          kind: Comment
          title: "Enumere a todas las personas que viven en este hogar."

    - id: b_household
      title: "Hogar"
      items:
        - id: q_size
          kind: Question
          title: "¿Cuántas personas viven en su hogar?"
          input:
            control: Editbox
            min: 1
            max: 12
        - id: q_children
          kind: Question
          title: "¿Cuántas de ellas son menores de 18 años?"
          input:
            control: Editbox
            min: 0
            max: 12
          postcondition:
            - predicate: "q_children.outcome <= q_size.outcome"
              hint: "No puede haber más menores que miembros del hogar."
        - id: q_insurance
          kind: Question
          title: "¿Qué seguros de salud tiene?"
          input:
            control: Checkbox
            labels:
              1: "Público"
              2: "Privado"
              4: "Ninguno de estos"
        - id: q_symptoms
          kind: Question
          title: "¿Qué síntomas tuvo la semana pasada?"
          input:
            control: Checkbox
            labels:
              1: "Dolor de cabeza"
              2: "Fiebre"
              4: "Nada"
        - id: q_vehicles
          kind: Question
          title: "¿Qué vehículos tiene su hogar?"
          input:
            control: Checkbox
            labels:
              1: "Coche"
              2: "Bicicleta"
              4: "Ningún vehículo"
          codeBlock: |
            vehicle_owner = 1 if q_vehicles.outcome in (1, 2, 3) else 0
        - id: q_channels
          kind: Question
          title: "¿Por qué medios se informa de las noticias?"
          input:
            control: Checkbox
            labels:
              1: "Televisión"
              2: "Internet"
              4: "No sé"
              8: "Ninguno"
          postcondition:
            - predicate: "(q_channels.outcome // 8) % 2 == 0 or q_channels.outcome == 8"
              hint: "Desmarque las demás opciones si elige «Ninguno»."

        - id: q_trust
          kind: Question
          title: "¿En cuáles de estas fuentes confía?"
          input:
            control: Checkbox
            labels:
              1: "Periódicos"
              2: "Radio"
              4: "Prefiero no contestar"
              8: "No aplica"
              16: "No lo sé"
              32: "Sin opinión"

    - id: b_vehicle
      title: "Uso del vehículo"
      precondition:
        - predicate: "vehicle_owner == 1"
      items:
        - id: q_km
          kind: Question
          title: "¿Cuántos kilómetros conduce en una semana normal?"
          input:
            control: Editbox
            min: 0
            max: 5000
        - id: q_never
          kind: Question
          title: "¿Cuántos vehículos tiene en total?"
          precondition:
            - predicate: "q_size.outcome > 12"
          input:
            control: Editbox
            min: 0
            max: 20
