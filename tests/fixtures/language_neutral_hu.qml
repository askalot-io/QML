# Language-neutral validation twin, Hungarian half (#1973 U7, R10).
#
# The same instrument as language_neutral_en.qml, whose header lists every
# positive and negative case: each title and label is in Hungarian (formal Ön
# register), and the ids, codes and conditions are byte-identical, so Z3 and
# every validator verdict must match the English half.
qmlVersion: "2.0"

questionnaire:
  title: "Háztartási felmérés"
  codeInit: |
    vehicle_owner = 0

  blocks:
    - id: b_intro
      title: "Bevezetés"
      items:
        - id: c_intro
          kind: Comment
          title: "Kérjük, figyelmesen olvassa el az alábbi kérdéseket."
        - id: c_section
          kind: Comment
          title: "1. rész: Háztartás"
        - id: c_postcode
          kind: Comment
          title: "Kérjük, írja be az irányítószámát az alábbi mezőbe."
        - id: c_contact
          kind: Comment
          title: "Adja meg azt a telefonszámot, amelyen a legjobban elérhető."
        - id: c_list
          kind: Comment
          title: "Sorolja fel a háztartásában élő összes személyt."

    - id: b_household
      title: "Háztartás"
      items:
        - id: q_size
          kind: Question
          title: "Hány fő él az Ön háztartásában?"
          input:
            control: Editbox
            min: 1
            max: 12
        - id: q_children
          kind: Question
          title: "Közülük hányan 18 év alattiak?"
          input:
            control: Editbox
            min: 0
            max: 12
          postcondition:
            - predicate: "q_children.outcome <= q_size.outcome"
              hint: "A gyermekek száma nem lehet több a háztartás létszámánál."
        - id: q_insurance
          kind: Question
          title: "Milyen egészségbiztosítással rendelkezik?"
          input:
            control: Checkbox
            labels:
              1: "Állami"
              2: "Magán"
              4: "Egyik sem"
        - id: q_symptoms
          kind: Question
          title: "Milyen tünetei voltak a múlt héten?"
          input:
            control: Checkbox
            labels:
              1: "Fejfájás"
              2: "Láz"
              4: "Semmi"
        - id: q_vehicles
          kind: Question
          title: "Milyen járművei vannak a háztartásnak?"
          input:
            control: Checkbox
            labels:
              1: "Személyautó"
              2: "Kerékpár"
              4: "Nincs jármű"
          codeBlock: |
            vehicle_owner = 1 if q_vehicles.outcome in (1, 2, 3) else 0
        - id: q_channels
          kind: Question
          title: "Honnan tájékozódik a hírekről?"
          input:
            control: Checkbox
            labels:
              1: "Televízió"
              2: "Internet"
              4: "Nem tudom"
              8: "Egyik sem"
          postcondition:
            - predicate: "(q_channels.outcome // 8) % 2 == 0 or q_channels.outcome == 8"
              hint: "Ha az „Egyik sem” lehetőséget választja, vegye ki a többi jelölést."

        - id: q_trust
          kind: Question
          title: "Mely források iránt érez bizalmat?"
          input:
            control: Checkbox
            labels:
              1: "Újságok"
              2: "Rádió"
              4: "Nem kívánok válaszolni"
              8: "Nem vonatkozik rám"
              16: "Fogalmam sincs"
              32: "Nincs véleményem"

    - id: b_vehicle
      title: "Járműhasználat"
      precondition:
        - predicate: "vehicle_owner == 1"
      items:
        - id: q_km
          kind: Question
          title: "Hány kilométert vezet egy átlagos héten?"
          input:
            control: Editbox
            min: 0
            max: 5000
        - id: q_never
          kind: Question
          title: "Összesen hány járműve van?"
          precondition:
            - predicate: "q_size.outcome > 12"
          input:
            control: Editbox
            min: 0
            max: 20
