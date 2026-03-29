qmlVersion: "1.0"
questionnaire:
  title: "NPHS - Drug Use and Mental Health"

  codeInit: |
    # Extern variables from household section
    age: range(0, 120)
    sex: {1, 2}

  blocks:
    # =========================================================================
    # BLOCK 1: DRUG USE (DRUG-INT to DRUG-Q5)
    # =========================================================================
    # Routing summary:
    #   DRUG-Q1 (medications checkbox)
    #     Any selected (outcome > 0 and not none-only) → Q2 → Q3 → Q4
    #     None selected (DGC4_NON only, outcome = 0)   → Q4
    #   DRUG-Q4 (health products): always asked
    #     Yes (1) → Q5
    #     No / DK/R → end of section
    #
    # Sex/age gating on DRUG-Q1:
    #   DGC4_1T (hormones for menopause): sex=female (2), age >= 30
    #   DGC4_1S (birth control pills):   sex=female (2), age 12-49
    #   Both items are individual Switch questions placed after the main
    #   Checkbox so their preconditions are evaluated independently.
    #
    # DGC4_NON (None of the above) is modelled as value 0 in the Checkbox
    # (respondent selects nothing). The main Checkbox captures the 18 items
    # without sex/age gates (keys 1..2^17). The two gated items are separate.
    # =========================================================================
    - id: b_drug_use
      title: "Drug Use"
      items:
        # DRUG-INT: Section introduction (no response)
        - id: q_drug_int
          kind: Comment
          title: "Now I'd like to ask a few questions about ...(r/'s) use of medications, both prescription and over-the-counter as well as other health products."

        # DRUG-Q1 / DGC4_1A-DGC4_1V, DGC4_NON:
        # Medications taken in the past month (mark all that apply).
        # Items without sex/age restrictions. Power-of-2 keys for all 18 items.
        # DGC4_1T (hormones) and DGC4_1S (birth control) are separate questions below.
        - id: q_drug_q1
          kind: Question
          title: "In the past month, did ... take any of the following medications? (Read list. Mark all that apply.)"
          input:
            control: Checkbox
            labels:
              1: "Pain relievers (aspirin, tylenol, anti-inflammatories)"
              2: "Tranquilizers (valium)"
              4: "Diet pills"
              8: "Anti-depressants"
              16: "Codeine, Demerol or Morphine"
              32: "Allergy medicine (Sinutab)"
              64: "Asthma medications"
              128: "Cough or cold remedies"
              256: "Penicillin or other antibiotic"
              512: "Medicine for the heart"
              1024: "Medicine for blood pressure"
              2048: "Diuretics or water pills"
              4096: "Steroids"
              8192: "Insulin"
              16384: "Pills to control diabetes"
              32768: "Sleeping pills"
              65536: "Stomach remedies"
              131072: "Laxatives"
              262144: "Any other medication (Specify)"
              0: "None of the above"

        # DRUG-Q1T / DGC4_1T: Hormones for menopause or aging symptoms
        # Sex/age gate: female (sex=2) AND age >= 30
        - id: q_drug_q1t
          kind: Question
          title: "In the past month, did ... take — Hormones for menopause or aging symptoms?"
          precondition:
            - predicate: sex == 2 and age >= 30
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # DRUG-Q1S / DGC4_1S: Birth control pills
        # Sex/age gate: female (sex=2) AND age 12-49
        - id: q_drug_q1s
          kind: Question
          title: "In the past month, did ... take — Birth control pills?"
          precondition:
            - predicate: sex == 2 and age >= 12 and age <= 49
          input:
            control: Switch
            on: "Yes"
            off: "No"

        # DRUG-C1: If any drug(s) specified in DRUG-Q1 → Q2. Otherwise → Q4.
        # Modelled via precondition on Q2/Q3.
        # "Any drug" = q_drug_q1.outcome > 0 (Checkbox non-zero selection)
        #              OR q_drug_q1t.outcome == 1 OR q_drug_q1s.outcome == 1
        # "None" = q_drug_q1.outcome == 0 AND q_drug_q1t.outcome != 1
        #          AND q_drug_q1s.outcome != 1

        # DRUG-Q2 / DGC4_2: Count of medications taken yesterday/day before
        # Precondition: any medication was selected in Q1/Q1T/Q1S
        # DK/R → GO TO DRUG-Q4; If 0 → GO TO DRUG-Q4
        - id: q_drug_q2
          kind: Question
          title: "Now, I am referring to yesterday and the day before yesterday. During those two days, how many different medications did you/he/she take?"
          precondition:
            - predicate: q_drug_q1.outcome > 0 or q_drug_q1t.outcome == 1 or q_drug_q1s.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 12
            right: "medications"

        # DRUG-Q3 / DGC4_3nC: Exact name of each medication taken
        # Precondition: Q2 > 0 (at least one medication taken yesterday/day before)
        # Modelled as single Textarea (source has up to 12 iterations)
        - id: q_drug_q3
          kind: Question
          title: "What is the exact name of the medication that ... took? (Ask the person to look at the bottle, tube or box.)"
          precondition:
            - predicate: q_drug_q1.outcome > 0 or q_drug_q1t.outcome == 1 or q_drug_q1s.outcome == 1
            - predicate: q_drug_q2.outcome > 0
          input:
            control: Textarea
            placeholder: "List medication names (up to 12)"
            maxLength: 500

        # DRUG-Q4 / DGC4_4: Other health products
        # Always asked (no precondition). After drug medications path or directly.
        - id: q_drug_q4
          kind: Question
          title: "There are many other health products such as ointments, vitamins, herbs, minerals, teas or protein drinks which people use to prevent illness or to improve or maintain their health. Do/Does ... use any of these or other health products?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Refused"

        # DRUG-Q5 / DGC4_5nn: Exact name of health product(s)
        # Precondition: Q4 = Yes
        - id: q_drug_q5
          kind: Question
          title: "What is the exact name of the health product that ... use(s)? (Ask the person to look at the bottle, tube or box.)"
          precondition:
            - predicate: q_drug_q4.outcome == 1
          input:
            control: Textarea
            placeholder: "List health product names (up to 12)"
            maxLength: 500

    # =========================================================================
    # BLOCK 2: MENTAL HEALTH (MHLTH-INTa to MHLTH-Q28)
    # =========================================================================
    # Non-proxy only — proxy status not modelled; block always presented.
    #
    # Routing summary:
    #
    # DISTRESS SCALE (Q1a-Q1f, Q1g-Q1k):
    #   Q1a-Q1f: frequency scale 1-5 (1=All of the time … 5=None of the time)
    #   DK/R on any Q1a-Q1f → skip to Q1k
    #   C1g: if all Q1a-Q1f = 5 (None) → skip to Q1k
    #   Q1g: 1=More often → Q1h → Q1j
    #         2=Less often → Q1i → Q1k
    #         3=Same       → Q1j
    #         4=Never / DK/R → Q1k
    #   Q1h: all → Q1j
    #   Q1i: all → Q1k
    #   Q1j: always when Q1g in [1, 2, 3]
    #   Q1k: always (mental health professional contact)
    #   Q1l: if Q1k = Yes
    #
    # DEPRESSION PATHWAY (Q2-Q15):
    #   Q2 = Yes (1) → Q3
    #   Q2 = No (2)  → Q16
    #   Q2 = DK/R    → end section (Social Support)
    #   Q3: options 1-2 continue; 3-4 → Q16; DK/R → end section
    #   Q4: options 1-2 continue; 3 → Q16; DK/R → end section
    #   Q5-Q13: all asked if Q2=Yes AND Q3 in [1,2] AND Q4 in [1,2]
    #   Q7: 1=Gained / 2=Lost → Q8 → Q9; 3=Same / 4=Diet → Q9; DK/R → end
    #   Q9: Yes → Q10 → Q11; No → Q11; DK/R → end
    #   C14: any Yes in Q5,Q6,Q9,Q11,Q12,Q13 or Q7 in [1,2] → Q14; else → Q16
    #   Q14 → Q15 → Q16
    #
    # LOSS OF INTEREST PATHWAY (Q16-Q28):
    #   Q16 = Yes (1) → Q17
    #   Q16 = No / DK/R → end section
    #   Q17: 1-2 continue; 3-4 → end; DK/R → end
    #   Q18: 1-2 continue; 3 → end; DK/R → end
    #   Q19-Q26: all asked if Q16=Yes AND Q17 in [1,2] AND Q18 in [1,2]
    #   Q20: 1=Gained / 2=Lost → Q21 → Q22; 3=Same / 4=Diet → Q22; DK/R → end
    #   Q22: Yes → Q23 → Q24; No → Q24; DK/R → end
    #   C27: any Yes in Q19,Q22,Q24,Q25,Q26 or Q20 in [1,2] → Q27; else → end
    #   Q27 → Q28 → end section
    # =========================================================================
    - id: b_mental_health
      title: "Mental Health"
      items:
        # MHLTH-INTa: Section introduction
        - id: q_mhlth_int
          kind: Comment
          title: "Now some questions about mental and emotional well-being. During the past month, about how often did you feel:"

        # MHLTH-Q1a / MHC4_1A: Sad feelings
        # DK/R → GO TO MHLTH-Q1k (modelled: no precondition; Q1g+ gated on distress_any)
        - id: q_mhlth_q1a
          kind: Question
          title: "... so sad that nothing could cheer you up?"
          input:
            control: Radio
            labels:
              1: "All of the time"
              2: "Most of the time"
              3: "Some of the time"
              4: "A little of the time"
              5: "None of the time"

        # MHLTH-Q1b / MHC4_1B: Nervous
        - id: q_mhlth_q1b
          kind: Question
          title: "... nervous?"
          input:
            control: Radio
            labels:
              1: "All of the time"
              2: "Most of the time"
              3: "Some of the time"
              4: "A little of the time"
              5: "None of the time"

        # MHLTH-Q1c / MHC4_1C: Restless or fidgety
        - id: q_mhlth_q1c
          kind: Question
          title: "... restless or fidgety?"
          input:
            control: Radio
            labels:
              1: "All of the time"
              2: "Most of the time"
              3: "Some of the time"
              4: "A little of the time"
              5: "None of the time"

        # MHLTH-Q1d / MHC4_1D: Hopeless
        - id: q_mhlth_q1d
          kind: Question
          title: "... hopeless?"
          input:
            control: Radio
            labels:
              1: "All of the time"
              2: "Most of the time"
              3: "Some of the time"
              4: "A little of the time"
              5: "None of the time"

        # MHLTH-Q1e / MHC4_1E: Worthless
        - id: q_mhlth_q1e
          kind: Question
          title: "... worthless?"
          input:
            control: Radio
            labels:
              1: "All of the time"
              2: "Most of the time"
              3: "Some of the time"
              4: "A little of the time"
              5: "None of the time"

        # MHLTH-Q1f / MHC4_1F: Everything was an effort
        - id: q_mhlth_q1f
          kind: Question
          title: "During the past month, about how often did you feel that everything was an effort?"
          input:
            control: Radio
            labels:
              1: "All of the time"
              2: "Most of the time"
              3: "Some of the time"
              4: "A little of the time"
              5: "None of the time"

        # MHLTH-C1g: If all Q1a-Q1f = 5 (None of the time) → skip to Q1k
        # Modelled via precondition on Q1g: requires at least one < 5

        # MHLTH-Q1g / MHC4_1G: Change in frequency of feelings
        # Precondition: at least one Q1a-Q1f answered with distress (< 5)
        # 1=More often → Q1h; 2=Less often → Q1i; 3=Same → Q1j; 4=Never / DK/R → Q1k
        - id: q_mhlth_q1g
          kind: Question
          title: "Taking them altogether, did these feelings occur more often in the past month than is usual for you, less often than usual, or about the same as usual?"
          precondition:
            - predicate: q_mhlth_q1a.outcome < 5 or q_mhlth_q1b.outcome < 5 or q_mhlth_q1c.outcome < 5 or q_mhlth_q1d.outcome < 5 or q_mhlth_q1e.outcome < 5 or q_mhlth_q1f.outcome < 5
          input:
            control: Radio
            labels:
              1: "More often"
              2: "Less often"
              3: "About the same"
              4: "Never have had any"

        # MHLTH-Q1h / MHC4_1H: How much more often
        # Precondition: Q1g = 1 (More often)
        # All → GO TO Q1j
        - id: q_mhlth_q1h
          kind: Question
          title: "Is that a lot more, somewhat or only a little more often than usual?"
          precondition:
            - predicate: q_mhlth_q1a.outcome < 5 or q_mhlth_q1b.outcome < 5 or q_mhlth_q1c.outcome < 5 or q_mhlth_q1d.outcome < 5 or q_mhlth_q1e.outcome < 5 or q_mhlth_q1f.outcome < 5
            - predicate: q_mhlth_q1g.outcome == 1
          input:
            control: Radio
            labels:
              1: "A lot more"
              2: "Somewhat more"
              3: "A little more"

        # MHLTH-Q1i / MHC4_1I: How much less often
        # Precondition: Q1g = 2 (Less often)
        # DK/R → Q1k; otherwise → Q1k (inventory: Q1i → Q1k)
        - id: q_mhlth_q1i
          kind: Question
          title: "Is that a lot less, somewhat or only a little less often than usual?"
          precondition:
            - predicate: q_mhlth_q1a.outcome < 5 or q_mhlth_q1b.outcome < 5 or q_mhlth_q1c.outcome < 5 or q_mhlth_q1d.outcome < 5 or q_mhlth_q1e.outcome < 5 or q_mhlth_q1f.outcome < 5
            - predicate: q_mhlth_q1g.outcome == 2
          input:
            control: Radio
            labels:
              1: "A lot less"
              2: "Somewhat less"
              3: "A little less"

        # MHLTH-Q1j / MHC4_1J: Interference with life/activities
        # Precondition: Q1g in [1, 2, 3] (not "Never" and not skip-to-Q1k paths)
        # Q1i → Q1k so Q1j is only reached from Q1g=1 (via Q1h) or Q1g=3 (direct)
        - id: q_mhlth_q1j
          kind: Question
          title: "How much do these experiences usually interfere with your life or activities?"
          precondition:
            - predicate: q_mhlth_q1a.outcome < 5 or q_mhlth_q1b.outcome < 5 or q_mhlth_q1c.outcome < 5 or q_mhlth_q1d.outcome < 5 or q_mhlth_q1e.outcome < 5 or q_mhlth_q1f.outcome < 5
            - predicate: q_mhlth_q1g.outcome == 1 or q_mhlth_q1g.outcome == 3
          input:
            control: Radio
            labels:
              1: "A lot"
              2: "Some"
              3: "A little"
              4: "Not at all"

        # MHLTH-Q1k / MHC4_1K: Seen mental health professional in past 12 months
        # Always asked (no precondition within mental health block)
        # No (2) / DK/R → Q2; Yes (1) → Q1l
        - id: q_mhlth_q1k
          kind: Question
          title: "In the past 12 months, have you seen or talked on the telephone to a health professional about your emotional or mental health?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Refused"

        # MHLTH-Q1l / MHC4_1L: How many times seen mental health professional
        # Precondition: Q1k = Yes
        - id: q_mhlth_q1l
          kind: Question
          title: "How many times (in the past 12 months)?"
          precondition:
            - predicate: q_mhlth_q1k.outcome == 1
          input:
            control: Editbox
            min: 0
            max: 999
            right: "times"

        # =====================================================================
        # DEPRESSION PATHWAY (Q2-Q15)
        # =====================================================================

        # MHLTH-Q2 / MHC4_2: Sad/blue/depressed for 2+ weeks
        # Yes (1) → Q3; No (2) → Q16; DK/R → end section
        - id: q_mhlth_q2
          kind: Question
          title: "During the past 12 months, was there ever a time when you felt sad, blue, or depressed for 2 weeks or more in a row?"
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Refused"

        # MHLTH-Q3 / MHC4_3: How long did feelings last during worst 2-week period
        # Precondition: Q2 = Yes
        # 1=All day / 2=Most of day → continue; 3=Half day / 4=Less than half → Q16
        # DK/R → end section
        - id: q_mhlth_q3
          kind: Question
          title: "For the next few questions, please think of the 2-week period during the past 12 months when these feelings were worst. During that time how long did these feelings usually last?"
          precondition:
            - predicate: q_mhlth_q2.outcome == 1
          input:
            control: Radio
            labels:
              1: "All day long"
              2: "Most of the day"
              3: "About half of the day"
              4: "Less than half the day"

        # MHLTH-Q4 / MHC4_4: How often felt this way during those 2 weeks
        # Precondition: Q2=Yes AND Q3 in [1,2]
        # 1=Every day / 2=Almost every day → continue; 3=Less often → Q16
        # DK/R → end section
        - id: q_mhlth_q4
          kind: Question
          title: "How often did you feel this way during those 2 weeks?"
          precondition:
            - predicate: q_mhlth_q2.outcome == 1
            - predicate: q_mhlth_q3.outcome == 1 or q_mhlth_q3.outcome == 2
          input:
            control: Radio
            labels:
              1: "Every day"
              2: "Almost every day"
              3: "Less often"

        # Gate for Q5-Q13: Q2=Yes AND Q3 in [1,2] AND Q4 in [1,2]
        # (used as shared precondition for depression symptom questions)

        # MHLTH-Q5 / MHC4_5: Lost interest in most things
        - id: q_mhlth_q5
          kind: Question
          title: "During those 2 weeks did you lose interest in most things?"
          precondition:
            - predicate: q_mhlth_q2.outcome == 1
            - predicate: q_mhlth_q3.outcome == 1 or q_mhlth_q3.outcome == 2
            - predicate: q_mhlth_q4.outcome == 1 or q_mhlth_q4.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # MHLTH-Q6 / MHC4_6: Tired out or low on energy all the time
        - id: q_mhlth_q6
          kind: Question
          title: "Did you feel tired out or low on energy all of the time?"
          precondition:
            - predicate: q_mhlth_q2.outcome == 1
            - predicate: q_mhlth_q3.outcome == 1 or q_mhlth_q3.outcome == 2
            - predicate: q_mhlth_q4.outcome == 1 or q_mhlth_q4.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # MHLTH-Q7 / MHC4_7: Weight change
        # 1=Gained / 2=Lost → Q8; 3=Same / 4=Diet → Q9; DK/R → end
        - id: q_mhlth_q7
          kind: Question
          title: "Did you gain weight, lose weight or stay about the same?"
          precondition:
            - predicate: q_mhlth_q2.outcome == 1
            - predicate: q_mhlth_q3.outcome == 1 or q_mhlth_q3.outcome == 2
            - predicate: q_mhlth_q4.outcome == 1 or q_mhlth_q4.outcome == 2
          input:
            control: Radio
            labels:
              1: "Gained weight"
              2: "Lost weight"
              3: "Stayed about the same"
              4: "Was on a diet"

        # MHLTH-Q8 / MHC4_8LB / MHC4_8KG: How much gained/lost
        # Precondition: Q7 in [1, 2] (gained or lost weight)
        - id: q_mhlth_q8
          kind: Question
          title: "About how much did you (gain/lose)?"
          precondition:
            - predicate: q_mhlth_q2.outcome == 1
            - predicate: q_mhlth_q3.outcome == 1 or q_mhlth_q3.outcome == 2
            - predicate: q_mhlth_q4.outcome == 1 or q_mhlth_q4.outcome == 2
            - predicate: q_mhlth_q7.outcome == 1 or q_mhlth_q7.outcome == 2
          input:
            control: Editbox
            min: 0
            max: 500
            right: "pounds or kilograms"

        # MHLTH-Q9 / MHC4_9: Trouble falling asleep
        # No (2) / DK/R → Q11
        - id: q_mhlth_q9
          kind: Question
          title: "Did you have more trouble falling asleep than you usually do?"
          precondition:
            - predicate: q_mhlth_q2.outcome == 1
            - predicate: q_mhlth_q3.outcome == 1 or q_mhlth_q3.outcome == 2
            - predicate: q_mhlth_q4.outcome == 1 or q_mhlth_q4.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # MHLTH-Q10 / MHC4_10: How often had trouble falling asleep
        # Precondition: Q9 = Yes
        - id: q_mhlth_q10
          kind: Question
          title: "How often did that happen?"
          precondition:
            - predicate: q_mhlth_q2.outcome == 1
            - predicate: q_mhlth_q3.outcome == 1 or q_mhlth_q3.outcome == 2
            - predicate: q_mhlth_q4.outcome == 1 or q_mhlth_q4.outcome == 2
            - predicate: q_mhlth_q9.outcome == 1
          input:
            control: Radio
            labels:
              1: "Every night"
              2: "Nearly every night"
              3: "Less often"

        # MHLTH-Q11 / MHC4_11: Trouble concentrating
        - id: q_mhlth_q11
          kind: Question
          title: "Did you have a lot more trouble concentrating than usual?"
          precondition:
            - predicate: q_mhlth_q2.outcome == 1
            - predicate: q_mhlth_q3.outcome == 1 or q_mhlth_q3.outcome == 2
            - predicate: q_mhlth_q4.outcome == 1 or q_mhlth_q4.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # MHLTH-Q12 / MHC4_12: Feeling down on yourself / worthless
        - id: q_mhlth_q12
          kind: Question
          title: "At these times, people sometimes feel down on themselves, no good, or worthless. Did you feel this way?"
          precondition:
            - predicate: q_mhlth_q2.outcome == 1
            - predicate: q_mhlth_q3.outcome == 1 or q_mhlth_q3.outcome == 2
            - predicate: q_mhlth_q4.outcome == 1 or q_mhlth_q4.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # MHLTH-Q13 / MHC4_13: Thoughts about death
        - id: q_mhlth_q13
          kind: Question
          title: "Did you think a lot about death - either your own, someone else's, or death in general?"
          precondition:
            - predicate: q_mhlth_q2.outcome == 1
            - predicate: q_mhlth_q3.outcome == 1 or q_mhlth_q3.outcome == 2
            - predicate: q_mhlth_q4.outcome == 1 or q_mhlth_q4.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # MHLTH-C14: If any Yes in Q5, Q6, Q9, Q11, Q12, Q13 or Q7 in [1,2] → Q14
        # Modelled via precondition on Q14

        # MHLTH-Q14 / MHC4_14: Total weeks sad/depressed
        # Precondition: depression path AND at least one symptom present
        - id: q_mhlth_q14
          kind: Question
          title: "Reviewing what you just told me, you had 2 weeks in a row during the past 12 months when you were sad, blue, or depressed and also had some other things. About how many weeks altogether did you feel this way during the past 12 months?"
          precondition:
            - predicate: q_mhlth_q2.outcome == 1
            - predicate: q_mhlth_q3.outcome == 1 or q_mhlth_q3.outcome == 2
            - predicate: q_mhlth_q4.outcome == 1 or q_mhlth_q4.outcome == 2
            - predicate: q_mhlth_q5.outcome == 1 or q_mhlth_q6.outcome == 1 or q_mhlth_q9.outcome == 1 or q_mhlth_q11.outcome == 1 or q_mhlth_q12.outcome == 1 or q_mhlth_q13.outcome == 1 or q_mhlth_q7.outcome == 1 or q_mhlth_q7.outcome == 2
          input:
            control: Editbox
            min: 0
            max: 52
            right: "weeks"

        # MHLTH-Q15 / MHC4_15: Month of last episode (depression)
        # Precondition: same as Q14
        - id: q_mhlth_q15
          kind: Question
          title: "Think about the last time you felt this way for 2 weeks or more in a row. In what month was that?"
          precondition:
            - predicate: q_mhlth_q2.outcome == 1
            - predicate: q_mhlth_q3.outcome == 1 or q_mhlth_q3.outcome == 2
            - predicate: q_mhlth_q4.outcome == 1 or q_mhlth_q4.outcome == 2
            - predicate: q_mhlth_q5.outcome == 1 or q_mhlth_q6.outcome == 1 or q_mhlth_q9.outcome == 1 or q_mhlth_q11.outcome == 1 or q_mhlth_q12.outcome == 1 or q_mhlth_q13.outcome == 1 or q_mhlth_q7.outcome == 1 or q_mhlth_q7.outcome == 2
          input:
            control: Radio
            labels:
              1: "January"
              2: "February"
              3: "March"
              4: "April"
              5: "May"
              6: "June"
              7: "July"
              8: "August"
              9: "September"
              10: "October"
              11: "November"
              12: "December"

        # =====================================================================
        # LOSS OF INTEREST PATHWAY (Q16-Q28)
        # =====================================================================

        # MHLTH-Q16 / MHC4_16: Lost interest in most things for 2+ weeks
        # Reached from: Q2=No, Q3 in [3,4], Q4=3, or after Q14/Q15
        # Yes (1) → Q17; No (2) / DK/R → end section
        - id: q_mhlth_q16
          kind: Question
          title: "During the past 12 months, was there ever a time lasting 2 weeks or more when you lost interest in most things like hobbies, work, or activities that usually give you pleasure?"
          precondition:
            - predicate: q_mhlth_q2.outcome == 1 or q_mhlth_q2.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"
              7: "Don't know / Refused"

        # MHLTH-Q17 / MHC4_17: Duration of loss of interest during worst 2-week period
        # Precondition: Q16 = Yes
        # 1-2 → continue; 3-4 → end; DK/R → end
        - id: q_mhlth_q17
          kind: Question
          title: "For the next few questions, please think of the 2-week period during the past 12 months when you had the most complete loss of interest in things. During that 2-week period, how long did the loss of interest usually last?"
          precondition:
            - predicate: q_mhlth_q2.outcome == 1 or q_mhlth_q2.outcome == 2
            - predicate: q_mhlth_q16.outcome == 1
          input:
            control: Radio
            labels:
              1: "All day long"
              2: "Most of the day"
              3: "About half of the day"
              4: "Less than half the day"

        # MHLTH-Q18 / MHC4_18: How often lost interest during those 2 weeks
        # Precondition: Q16=Yes AND Q17 in [1,2]
        # 1-2 → continue; 3 → end; DK/R → end
        - id: q_mhlth_q18
          kind: Question
          title: "How often did you feel this way during those 2 weeks?"
          precondition:
            - predicate: q_mhlth_q2.outcome == 1 or q_mhlth_q2.outcome == 2
            - predicate: q_mhlth_q16.outcome == 1
            - predicate: q_mhlth_q17.outcome == 1 or q_mhlth_q17.outcome == 2
          input:
            control: Radio
            labels:
              1: "Every day"
              2: "Almost every day"
              3: "Less often"

        # Gate for Q19-Q26: Q16=Yes AND Q17 in [1,2] AND Q18 in [1,2]

        # MHLTH-Q19 / MHC4_19: Tired out or low on energy (loss of interest pathway)
        - id: q_mhlth_q19
          kind: Question
          title: "During those 2 weeks did you feel tired out or low on energy all the time?"
          precondition:
            - predicate: q_mhlth_q2.outcome == 1 or q_mhlth_q2.outcome == 2
            - predicate: q_mhlth_q16.outcome == 1
            - predicate: q_mhlth_q17.outcome == 1 or q_mhlth_q17.outcome == 2
            - predicate: q_mhlth_q18.outcome == 1 or q_mhlth_q18.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # MHLTH-Q20 / MHC4_20: Weight change (loss of interest pathway)
        # 1=Gained / 2=Lost → Q21; 3=Same / 4=Diet → Q22; DK/R → end
        - id: q_mhlth_q20
          kind: Question
          title: "Did you gain weight, lose weight, or stay about the same?"
          precondition:
            - predicate: q_mhlth_q2.outcome == 1 or q_mhlth_q2.outcome == 2
            - predicate: q_mhlth_q16.outcome == 1
            - predicate: q_mhlth_q17.outcome == 1 or q_mhlth_q17.outcome == 2
            - predicate: q_mhlth_q18.outcome == 1 or q_mhlth_q18.outcome == 2
          input:
            control: Radio
            labels:
              1: "Gained weight"
              2: "Lost weight"
              3: "Stayed about the same"
              4: "Was on a diet"

        # MHLTH-Q21 / MHC4_21L / MHC4_21K: How much gained/lost (loss of interest pathway)
        # Precondition: Q20 in [1, 2]
        - id: q_mhlth_q21
          kind: Question
          title: "About how much did you (gain/lose)?"
          precondition:
            - predicate: q_mhlth_q2.outcome == 1 or q_mhlth_q2.outcome == 2
            - predicate: q_mhlth_q16.outcome == 1
            - predicate: q_mhlth_q17.outcome == 1 or q_mhlth_q17.outcome == 2
            - predicate: q_mhlth_q18.outcome == 1 or q_mhlth_q18.outcome == 2
            - predicate: q_mhlth_q20.outcome == 1 or q_mhlth_q20.outcome == 2
          input:
            control: Editbox
            min: 0
            max: 500
            right: "pounds or kilograms"

        # MHLTH-Q22 / MHC4_22: Trouble falling asleep (loss of interest pathway)
        # No (2) / DK/R → Q24
        - id: q_mhlth_q22
          kind: Question
          title: "Did you have more trouble falling asleep than you usually do?"
          precondition:
            - predicate: q_mhlth_q2.outcome == 1 or q_mhlth_q2.outcome == 2
            - predicate: q_mhlth_q16.outcome == 1
            - predicate: q_mhlth_q17.outcome == 1 or q_mhlth_q17.outcome == 2
            - predicate: q_mhlth_q18.outcome == 1 or q_mhlth_q18.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # MHLTH-Q23 / MHC4_23: How often trouble falling asleep (loss of interest pathway)
        # Precondition: Q22 = Yes
        - id: q_mhlth_q23
          kind: Question
          title: "How often did that happen during those 2 weeks?"
          precondition:
            - predicate: q_mhlth_q2.outcome == 1 or q_mhlth_q2.outcome == 2
            - predicate: q_mhlth_q16.outcome == 1
            - predicate: q_mhlth_q17.outcome == 1 or q_mhlth_q17.outcome == 2
            - predicate: q_mhlth_q18.outcome == 1 or q_mhlth_q18.outcome == 2
            - predicate: q_mhlth_q22.outcome == 1
          input:
            control: Radio
            labels:
              1: "Every night"
              2: "Nearly every night"
              3: "Less often"

        # MHLTH-Q24 / MHC4_24: Trouble concentrating (loss of interest pathway)
        - id: q_mhlth_q24
          kind: Question
          title: "Did you have a lot more trouble concentrating than usual?"
          precondition:
            - predicate: q_mhlth_q2.outcome == 1 or q_mhlth_q2.outcome == 2
            - predicate: q_mhlth_q16.outcome == 1
            - predicate: q_mhlth_q17.outcome == 1 or q_mhlth_q17.outcome == 2
            - predicate: q_mhlth_q18.outcome == 1 or q_mhlth_q18.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # MHLTH-Q25 / MHC4_25: Feeling down on yourself (loss of interest pathway)
        - id: q_mhlth_q25
          kind: Question
          title: "At these times, people sometimes feel down on themselves, no good, or worthless. Did you feel this way?"
          precondition:
            - predicate: q_mhlth_q2.outcome == 1 or q_mhlth_q2.outcome == 2
            - predicate: q_mhlth_q16.outcome == 1
            - predicate: q_mhlth_q17.outcome == 1 or q_mhlth_q17.outcome == 2
            - predicate: q_mhlth_q18.outcome == 1 or q_mhlth_q18.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # MHLTH-Q26 / MHC4_26: Thoughts about death (loss of interest pathway)
        - id: q_mhlth_q26
          kind: Question
          title: "Did you think a lot about death - either your own, someone else's, or death in general?"
          precondition:
            - predicate: q_mhlth_q2.outcome == 1 or q_mhlth_q2.outcome == 2
            - predicate: q_mhlth_q16.outcome == 1
            - predicate: q_mhlth_q17.outcome == 1 or q_mhlth_q17.outcome == 2
            - predicate: q_mhlth_q18.outcome == 1 or q_mhlth_q18.outcome == 2
          input:
            control: Radio
            labels:
              1: "Yes"
              2: "No"

        # MHLTH-C27: If any Yes in Q19, Q22, Q24, Q25, Q26 or Q20 in [1,2] → Q27
        # Modelled via precondition on Q27

        # MHLTH-Q27 / MHC4_27: Total weeks with loss of interest
        # Precondition: loss-of-interest path AND at least one symptom present
        - id: q_mhlth_q27
          kind: Question
          title: "Reviewing what you just told me, you had 2 weeks in a row during the past 12 months when you lost interest in most things and also had some other things. About how many weeks did you feel this way during the past 12 months?"
          precondition:
            - predicate: q_mhlth_q2.outcome == 1 or q_mhlth_q2.outcome == 2
            - predicate: q_mhlth_q16.outcome == 1
            - predicate: q_mhlth_q17.outcome == 1 or q_mhlth_q17.outcome == 2
            - predicate: q_mhlth_q18.outcome == 1 or q_mhlth_q18.outcome == 2
            - predicate: q_mhlth_q19.outcome == 1 or q_mhlth_q22.outcome == 1 or q_mhlth_q24.outcome == 1 or q_mhlth_q25.outcome == 1 or q_mhlth_q26.outcome == 1 or q_mhlth_q20.outcome == 1 or q_mhlth_q20.outcome == 2
          input:
            control: Editbox
            min: 0
            max: 52
            right: "weeks"

        # MHLTH-Q28 / MHC4_28: Month of last episode (loss of interest)
        # Precondition: same as Q27
        - id: q_mhlth_q28
          kind: Question
          title: "Think about the last time you had 2 weeks in a row when you felt this way. In what month was that?"
          precondition:
            - predicate: q_mhlth_q2.outcome == 1 or q_mhlth_q2.outcome == 2
            - predicate: q_mhlth_q16.outcome == 1
            - predicate: q_mhlth_q17.outcome == 1 or q_mhlth_q17.outcome == 2
            - predicate: q_mhlth_q18.outcome == 1 or q_mhlth_q18.outcome == 2
            - predicate: q_mhlth_q19.outcome == 1 or q_mhlth_q22.outcome == 1 or q_mhlth_q24.outcome == 1 or q_mhlth_q25.outcome == 1 or q_mhlth_q26.outcome == 1 or q_mhlth_q20.outcome == 1 or q_mhlth_q20.outcome == 2
          input:
            control: Radio
            labels:
              1: "January"
              2: "February"
              3: "March"
              4: "April"
              5: "May"
              6: "June"
              7: "July"
              8: "August"
              9: "September"
              10: "October"
              11: "November"
              12: "December"
