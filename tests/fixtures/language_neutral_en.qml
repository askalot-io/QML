# Language-neutral validation twin, English half (#1973 U7, R10).
#
# language_neutral_<code>.qml for every other supported locale (hu, es, fr,
# de) is the same instrument, item for item, with every title and label
# translated (formal register: Ön, usted, vous, Sie) and the ids, codes and
# conditions byte-identical. Z3 and every validator verdict must be the same
# for all of them, including the two advisory lints that read item text
# (labels below in en / hu / es / fr / de order):
#
# combinable_none_option — POSITIVES (a "none" label tickable beside others):
#   - q_insurance: "None of these" / "Egyik sem" / "Ninguno de estos" /
#     "Aucun" / "Keine davon"
#   - q_symptoms: "Nothing" / "Semmi" / "Nada" / "Rien" / "Nichts"
#   - q_vehicles: "No vehicle" / "Nincs jármű" / "Ningún vehículo" /
#     "Aucun véhicule" / "Kein Fahrzeug"
# combinable_none_option — NEGATIVES (non-substantive options, which share a
# stem with a denial in several languages yet deny nothing):
#   - q_channels: "Don't know" / "Nem tudom" / "No sé" / "Ne sais pas" /
#     "Weiß nicht" is not a denial, and the guarded "None" option carries a
#     postcondition refusing the combination
#   - q_trust: "Prefer not to say", "Not applicable", "No idea", "No opinion"
#     / "Nem kívánok válaszolni", "Nem vonatkozik rám", "Fogalmam sincs",
#     "Nincs véleményem" / "Prefiero no contestar", "No aplica", "No lo sé",
#     "Sin opinión" / "Préfère ne pas répondre", "Sans objet", "Aucune idée",
#     "Sans opinion" / "Keine Angabe", "Trifft nicht zu", "Keine Ahnung",
#     "Keine Meinung" — no postcondition, so any pattern matching one of them
#     warns
# comment_titled_as_question — POSITIVES (an inscription verb, no '?'):
#   - c_postcode: "Please enter …" / "Kérjük, írja be …" / "Por favor,
#     escriba …" / "Veuillez indiquer …" / "Bitte tragen Sie … ein."
#   - c_contact: "Specify …" / "Adja meg …" / "Indique …" / "Précisez …" /
#     "Geben Sie … an, …"
#   - c_list: "List …" / "Sorolja fel …" / "Enumere …" / "Énumérez …" /
#     "Nennen Sie …"
# comment_titled_as_question — NEGATIVES:
#   - c_intro: "Please read … carefully." / "Kérjük, figyelmesen olvassa el …" /
#     "Por favor, lea …" / "Veuillez lire …" / "Bitte lesen Sie … durch."
#   - c_section: a plain section label
#
# The Z3 side carries a gate, a codeBlock variable, a relational postcondition
# and an unreachable item, so the verdict comparison is not vacuous.
qmlVersion: "2.0"

questionnaire:
  title: "Household survey"
  codeInit: |
    vehicle_owner = 0

  blocks:
    - id: b_intro
      title: "Introduction"
      items:
        - id: c_intro
          kind: Comment
          title: "Please read the following questions carefully."
        - id: c_section
          kind: Comment
          title: "Section 1: Household"
        - id: c_postcode
          kind: Comment
          title: "Please enter your postcode in the box below."
        - id: c_contact
          kind: Comment
          title: "Specify the best phone number to reach you."
        - id: c_list
          kind: Comment
          title: "List every person living in this household."

    - id: b_household
      title: "Household"
      items:
        - id: q_size
          kind: Question
          title: "How many people live in your household?"
          input:
            control: Editbox
            min: 1
            max: 12
        - id: q_children
          kind: Question
          title: "How many of them are under 18?"
          input:
            control: Editbox
            min: 0
            max: 12
          postcondition:
            - predicate: "q_children.outcome <= q_size.outcome"
              hint: "There cannot be more children than household members."
        - id: q_insurance
          kind: Question
          title: "Which health insurance plans do you have?"
          input:
            control: Checkbox
            labels:
              1: "Public"
              2: "Private"
              4: "None of these"
        - id: q_symptoms
          kind: Question
          title: "Which symptoms did you have last week?"
          input:
            control: Checkbox
            labels:
              1: "Headache"
              2: "Fever"
              4: "Nothing"
        - id: q_vehicles
          kind: Question
          title: "Which vehicles does your household own?"
          input:
            control: Checkbox
            labels:
              1: "Car"
              2: "Bicycle"
              4: "No vehicle"
          codeBlock: |
            vehicle_owner = 1 if q_vehicles.outcome in (1, 2, 3) else 0
        - id: q_channels
          kind: Question
          title: "Where do you hear news?"
          input:
            control: Checkbox
            labels:
              1: "Television"
              2: "Internet"
              4: "Don't know"
              8: "None"
          postcondition:
            - predicate: "(q_channels.outcome // 8) % 2 == 0 or q_channels.outcome == 8"
              hint: "Untick the other options when you choose None."

        - id: q_trust
          kind: Question
          title: "Which of these sources do you trust?"
          input:
            control: Checkbox
            labels:
              1: "Newspapers"
              2: "Radio"
              4: "Prefer not to say"
              8: "Not applicable"
              16: "No idea"
              32: "No opinion"

    - id: b_vehicle
      title: "Vehicle use"
      precondition:
        - predicate: "vehicle_owner == 1"
      items:
        - id: q_km
          kind: Question
          title: "How many kilometres do you drive in a typical week?"
          input:
            control: Editbox
            min: 0
            max: 5000
        - id: q_never
          kind: Question
          title: "How many vehicles do you own in total?"
          precondition:
            - predicate: "q_size.outcome > 12"
          input:
            control: Editbox
            min: 0
            max: 20
