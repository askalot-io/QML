qmlVersion: "1.0"
questionnaire:
  title: "NLSCY Children and Youth Survey - Medical/Biological (MED)"
  codeInit: |
    # Variables READ from prior sections
    child_age = 0           # age of child in years (0-11)
    child_age_months = 0    # age of child in months (0-143)
    is_bio_mother = 0       # 1=respondent is biological mother
    is_bio_father = 0       # 1=respondent is biological father

  blocks:
    # =========================================================================
    # BLOCK 1: PRENATAL CONDITIONS AND CARE
    # =========================================================================
    # MED-C1: IF AGE > 3 → skip section
    # MED-C1A: IF biological mother → prenatal; father → birth; else → skip
    # MED-C1C: IF AGE IN MONTHS > 23 → skip to birth questions
    # Q1A-Q10B: Pregnancy complications, prenatal care, smoking, alcohol, meds
    # =========================================================================
    - id: b_prenatal
      title: "Prenatal Conditions and Care"
      precondition:
        - predicate: child_age <= 3
        - predicate: is_bio_mother == 1
        - predicate: child_age_months <= 23
      items:
        # MED-Q1A/Q1B/Q1C: Pregnancy complications
        - id: qg_med_q1
          kind: QuestionGroup
          title: "The following are prenatal questions concerning your child. During the pregnancy, did you suffer from any of the following:"
          questions:
            - "(a) Pregnancy diabetes?"
            - "(b) High blood pressure?"
            - "(c) Other physical problems?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MED-Q2: Prenatal care provider
        - id: q_med_q2
          kind: Question
          title: "From whom did you receive pre-natal care?"
          input:
            control: Radio
            labels:
              1: "A doctor"
              2: "A nurse"
              3: "A midwife"
              4: "Other"
              5: "Nobody"

        # MED-Q3: Smoking during pregnancy
        - id: q_med_q3
          kind: Question
          title: "Did you smoke during your pregnancy with this child?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MED-Q4: Cigarettes per day (only if smoked)
        - id: q_med_q4
          kind: Question
          title: "How many cigarettes per day did you smoke during your pregnancy?"
          precondition:
            - predicate: q_med_q3.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 100
            right: "cigarettes per day"

        # MED-Q5: Stage of pregnancy when smoking
        - id: q_med_q5
          kind: Question
          title: "At what stage in your pregnancy did you smoke this amount?"
          precondition:
            - predicate: q_med_q3.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "During the first three months"
              2: "During the second three months"
              4: "During the third three months"
              8: "Throughout"

        # MED-Q6: Alcohol frequency during pregnancy
        - id: q_med_q6
          kind: Question
          title: "How frequently did you consume alcohol during your pregnancy (e.g. beer, wine, liquor)?"
          input:
            control: Radio
            labels:
              1: "Never"
              2: "Less than once a month"
              3: "1-3 times a month"
              4: "Once a week"
              5: "2-3 times a week"
              6: "4-6 times a week"
              7: "Everyday"

        # MED-Q7: Drinks per occasion (only if drank)
        - id: q_med_q7
          kind: Question
          title: "On the days when you drank, how many drinks did you usually have?"
          precondition:
            - predicate: q_med_q6.outcome >= 2
          input:
            control: Radio
            labels:
              1: "1 to 2"
              2: "3 to 4"
              3: "5 or more"

        # MED-Q8: Stage of pregnancy when drinking
        - id: q_med_q8
          kind: Question
          title: "At what stage in your pregnancy did you consume this quantity?"
          precondition:
            - predicate: q_med_q6.outcome >= 2
          input:
            control: Checkbox
            labels:
              1: "During the first three months"
              2: "During the second three months"
              4: "During the third three months"
              8: "Throughout"

        # MED-Q9A: Prescription medications during pregnancy
        - id: q_med_q9a
          kind: Question
          title: "Did you take any prescription medications during your pregnancy?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MED-Q9B: Stage of pregnancy for prescription meds
        - id: q_med_q9b
          kind: Question
          title: "At what stage in your pregnancy did you take these prescription medications?"
          precondition:
            - predicate: q_med_q9a.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "During the first three months"
              2: "During the second three months"
              4: "During the third three months"
              8: "Throughout"

        # MED-Q10A: Over-the-counter drugs during pregnancy
        - id: q_med_q10a
          kind: Question
          title: "Did you take any over-the-counter drugs during your pregnancy?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MED-Q10B: Stage of pregnancy for OTC drugs
        - id: q_med_q10b
          kind: Question
          title: "At what stage in your pregnancy did you take these over-the-counter drugs?"
          precondition:
            - predicate: q_med_q10a.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "During the first three months"
              2: "During the second three months"
              4: "During the third three months"
              8: "Throughout"

    # =========================================================================
    # BLOCK 2: BIRTH DETAILS
    # =========================================================================
    # MED-Q12A through Q15: Due date, weight, length, single/multiple birth
    # All respondents (bio mother or bio father) with child age 0-3
    # =========================================================================
    - id: b_birth
      title: "Birth Details"
      precondition:
        - predicate: child_age <= 3
        - predicate: is_bio_mother == 1 or is_bio_father == 1
      items:
        # MED-Q12A: Born before or after due date
        - id: q_med_q12a
          kind: Question
          title: "The following are questions concerning your child's birth. Was he/she born before or after the due date?"
          input:
            control: Radio
            labels:
              1: "Before"
              2: "After"
              3: "On due date"

        # MED-Q12B: Days/weeks early or late (skip if on due date)
        - id: q_med_q12b
          kind: Question
          title: "How many days before or after the due date was he/she born?"
          precondition:
            - predicate: q_med_q12a.outcome == 1 or q_med_q12a.outcome == 2
          input:
            control: Editbox
            min: 1
            max: 120
            right: "days"

        # MED-Q13A: Birth weight in grams
        - id: q_med_q13a
          kind: Question
          title: "What was his/her birth weight?"
          input:
            control: Editbox
            min: 500
            max: 6000
            right: "grams"

        # MED-Q14A: Length at birth in centimetres
        - id: q_med_q14a
          kind: Question
          title: "What was his/her length at birth?"
          input:
            control: Editbox
            min: 25
            max: 65
            right: "cm"

        # MED-Q15: Single or multiple birth
        - id: q_med_q15
          kind: Question
          title: "Was this a single birth or twins, or triplets?"
          input:
            control: Radio
            labels:
              1: "Single birth"
              2: "Twins"
              3: "Triplets"
              4: "More than triplets"

    # =========================================================================
    # BLOCK 3: DELIVERY DETAILS
    # =========================================================================
    # MED-C16: IF AGE IN MONTHS >= 12 → skip to neonatal care
    # Q16-Q18: Delivery method, presentation, birthing aids
    # Only for children age 0-11 months
    # =========================================================================
    - id: b_delivery
      title: "Delivery Details"
      precondition:
        - predicate: child_age <= 3
        - predicate: is_bio_mother == 1 or is_bio_father == 1
        - predicate: child_age_months <= 11
      items:
        # MED-Q16: Delivery method
        - id: q_med_q16
          kind: Question
          title: "Was the delivery vaginal or caesarian?"
          input:
            control: Radio
            labels:
              1: "Vaginal"
              2: "Caesarian"

        # MED-Q17: Born head first (only if vaginal)
        - id: q_med_q17
          kind: Question
          title: "Was the child born head first?"
          precondition:
            - predicate: q_med_q16.outcome == 1
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MED-Q18: Birthing aids (only if vaginal)
        - id: q_med_q18
          kind: Question
          title: "Were birthing aids used?"
          precondition:
            - predicate: q_med_q16.outcome == 1
          input:
            control: Radio
            labels:
              1: "None"
              2: "Forceps"
              3: "Cupping glass (suction cup)"

    # =========================================================================
    # BLOCK 4: NEONATAL CARE
    # =========================================================================
    # MED-Q21A through Q22: Special medical care after birth, health at birth
    # Asked for ages 0-23 months (bio mother or bio father)
    # =========================================================================
    - id: b_neonatal
      title: "Neonatal Care"
      precondition:
        - predicate: child_age <= 3
        - predicate: is_bio_mother == 1 or is_bio_father == 1
        - predicate: child_age_months <= 23
      items:
        # MED-Q21A: Special medical care after birth
        - id: q_med_q21a
          kind: Question
          title: "Did your child receive special medical care following his/her birth?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MED-Q21B: Type of special medical care (only if yes)
        - id: q_med_q21b
          kind: Question
          title: "What type of special medical care was received?"
          precondition:
            - predicate: q_med_q21a.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "Intensive care"
              2: "Ventilation/oxygen"
              4: "Transfer to a specialized hospital"
              8: "Other"

        # MED-Q21C: Duration of special care (only if received care)
        - id: q_med_q21c
          kind: Question
          title: "For how many days, in total, was this care received?"
          precondition:
            - predicate: q_med_q21a.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 365
            right: "days"

        # MED-Q22: Health at birth compared to other babies
        - id: q_med_q22
          kind: Question
          title: "Compared to other babies in general, would you say that your child's health at birth was:"
          input:
            control: Radio
            labels:
              1: "Excellent"
              2: "Very good"
              3: "Good"
              4: "Fair"
              5: "Poor"

    # =========================================================================
    # BLOCK 5: POSTNATAL COMPLICATIONS
    # =========================================================================
    # MED-C23A: IF AGE IN MONTHS >= 12 → skip to breastfeeding
    # Q23A-Q24B: Postnatal complications for the mother
    # Only for children age 0-11 months, bio mother respondent
    # =========================================================================
    - id: b_postnatal
      title: "Postnatal Complications"
      precondition:
        - predicate: child_age <= 3
        - predicate: is_bio_mother == 1
        - predicate: child_age_months <= 11
      items:
        # MED-Q23A: Postpartum haemorrhage
        - id: q_med_q23a
          kind: Question
          title: "After the delivery, did you suffer from postpartum haemorrhage?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MED-Q23B: Postpartum infection
        - id: q_med_q23b
          kind: Question
          title: "Did you suffer from postpartum infection?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MED-Q23C1: Postpartum depression
        - id: q_med_q23c1
          kind: Question
          title: "Did you suffer from postpartum depression?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MED-Q23C2: Duration of postpartum depression (only if yes)
        - id: q_med_q23c2
          kind: Question
          title: "For how long did the postpartum depression last?"
          precondition:
            - predicate: q_med_q23c1.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 365
            right: "days"

        # MED-Q23D: Postpartum hypertension
        - id: q_med_q23d
          kind: Question
          title: "Did you suffer from postpartum hypertension?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MED-Q24A: Mother hospitalized after birth
        - id: q_med_q24a
          kind: Question
          title: "Were you hospitalized for special medical care for any period immediately following the birth?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MED-Q24B: Duration of hospitalization (only if yes)
        - id: q_med_q24b
          kind: Question
          title: "For how many days were you hospitalized?"
          precondition:
            - predicate: q_med_q24a.outcome == 1
          input:
            control: Editbox
            min: 1
            max: 365
            right: "days"

    # =========================================================================
    # BLOCK 6: BREASTFEEDING
    # =========================================================================
    # MED-Q25 through Q28: Current and past breastfeeding
    # Asked for ages 0-23 months (bio mother or bio father)
    # =========================================================================
    - id: b_breastfeeding
      title: "Breastfeeding"
      precondition:
        - predicate: child_age <= 3
        - predicate: is_bio_mother == 1 or is_bio_father == 1
        - predicate: child_age_months <= 23
      items:
        # MED-Q25: Currently breast-feeding
        - id: q_med_q25
          kind: Question
          title: "Are you currently breast-feeding your child?"
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MED-Q26: Ever breast-fed (only if not currently)
        - id: q_med_q26
          kind: Question
          title: "Did you breast-feed him/her even if only for a short time?"
          precondition:
            - predicate: q_med_q25.outcome == 0
          input:
            control: Switch
            off: "No"
            on: "Yes"

        # MED-Q27: Duration of breastfeeding (only if ever breast-fed)
        - id: q_med_q27
          kind: Question
          title: "For how long did you breast-feed?"
          precondition:
            - predicate: q_med_q25.outcome == 0
            - predicate: q_med_q26.outcome == 1
          input:
            control: Radio
            labels:
              1: "Less than 1 week"
              2: "1-4 weeks"
              3: "5-8 weeks"
              4: "9-12 weeks"
              5: "3-6 months"
              6: "7-9 months"
              7: "10-12 months"
              8: "13-16 months"
              9: "More than 16 months"

        # MED-Q28: Reason for stopping breastfeeding
        - id: q_med_q28
          kind: Question
          title: "What was the main reason you stopped breast-feeding?"
          precondition:
            - predicate: q_med_q25.outcome == 0
            - predicate: q_med_q26.outcome == 1
          input:
            control: Checkbox
            labels:
              1: "Not enough milk/hungry baby"
              2: "Inconvenienced/fatigue"
              4: "Difficulty with breastfeeding techniques"
              8: "Sore nipples/engorged breast"
              16: "Mother's illness"
              32: "Planned to stop at this time"
              64: "Baby weaned himself/herself"
              128: "Physician told me to stop"
              256: "Returned to work/school"
              512: "Partner/father wanted me to stop"
              1024: "Formula feeding preferable"
              2048: "Wanted to drink alcohol"
              4096: "Other"
