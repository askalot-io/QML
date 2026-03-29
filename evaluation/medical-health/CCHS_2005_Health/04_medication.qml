qmlVersion: '1.0'
questionnaire:
  title: 04 Medication
  codeInit: |
    # Extern variables from earlier sections
    age: range(12, 120)
    sex: {1, 2}
    # Extern variable from CCC section for soft edit MED_E1G
    # CCC_Q036: asthma medication in past 12 months (Switch: 0=No, 1=Yes)
    ccc_q036_asthma_med: {0, 1}
    # Extern variables from prior sections
    age: range(15, 55)
    is_proxy: {0, 1}
    # SMK_Q202: Current smoking status (1=Daily, 2=Occasionally, 3=Not at all)
    smk_status: {1, 2, 3}
    # SMK_Q201A: Smoked 100+ cigarettes (1=Yes, 0=No)
    smk_100_cigs: {0, 1}
    # SMK_Q201B: Ever smoked whole cigarette (1=Yes, 0=No)
    smk_ever_whole: {0, 1}
    # ALC_Q1: Drank in past 12 months (1=Yes, 0=No)
    alc_past_year: {0, 1}
    # ALC_Q5B: Ever had a drink (1=Yes, 0=No)
    alc_ever: {0, 1}
  blocks:
  - id: b_medication_use
    title: Medication Use
    items:
    - id: q_med_r1
      kind: Comment
      title: Now I'd like to ask a few questions about your use of medications, both prescription and over-the-counter.
    - id: q_med_q1a
      kind: Question
      title: 'In the past month, did you take: ... pain relievers such as aspirin or Tylenol (including arthritis medicine
        and anti-inflammatories)?'
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_med_q1b
      kind: Question
      title: 'In the past month, did you take: ... tranquilizers such as Valium or Ativan?'
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_med_q1c
      kind: Question
      title: 'In the past month, did you take: ... diet pills such as Dexatrim, Ponderal or Fastin?'
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_med_q1d
      kind: Question
      title: 'In the past month, did you take: ... anti-depressants such as Prozac, Paxil or Effexor?'
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_med_q1e
      kind: Question
      title: 'In the past month, did you take: ... codeine, Demerol or morphine?'
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_med_q1f
      kind: Question
      title: 'In the past month, did you take: ... allergy medicine such as Reactine or Allegra?'
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_med_q1g
      kind: Question
      title: 'In the past month, did you take: ... asthma medications such as inhalers or nebulizers?'
      postcondition:
      - predicate: not (q_med_q1g.outcome == 1 and ccc_q036_asthma_med == 0)
        hint: You indicated taking asthma medication this month but previously reported not taking asthma medicine in the
          past 12 months. Please confirm.
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_med_q1h
      kind: Question
      title: 'In the past month, did you take: ... cough or cold remedies?'
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_med_q1i
      kind: Question
      title: 'In the past month, did you take: ... penicillin or other antibiotics?'
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_med_q1j
      kind: Question
      title: 'In the past month, did you take: ... medicine for the heart?'
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_med_q1l
      kind: Question
      title: 'In the past month, did you take: ... diuretics or water pills?'
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_med_q1m
      kind: Question
      title: 'In the past month, did you take: ... steroids?'
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_med_q1p
      kind: Question
      title: 'In the past month, did you take: ... sleeping pills such as Imovane, Nytol or Starnoc?'
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_med_q1q
      kind: Question
      title: 'In the past month, did you take: ... stomach remedies?'
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_med_q1r
      kind: Question
      title: 'In the past month, did you take: ... laxatives?'
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_med_q1s
      kind: Question
      title: 'In the past month, did you take: ... birth control pills?'
      precondition:
      - predicate: sex == 2
      - predicate: age <= 49
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_med_q1t
      kind: Question
      title: 'In the past month, did you take: ... hormones for menopause or ageing symptoms?'
      precondition:
      - predicate: sex == 2
      - predicate: age >= 30
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_med_q1t1
      kind: Question
      title: What type of hormones are you taking?
      precondition:
      - predicate: q_med_q1t.outcome == 1
      input:
        control: Radio
        labels:
          1: Estrogen only
          2: Progesterone only
          3: Both
          4: Neither
    - id: q_med_q1t2
      kind: Question
      title: When did you start this hormone therapy?
      precondition:
      - predicate: q_med_q1t.outcome == 1
      postcondition:
      - predicate: q_med_q1t2.outcome >= 1930
        hint: Year must be 1930 or later.
      - predicate: q_med_q1t2.outcome <= 2005
        hint: Year cannot be in the future.
      input:
        control: Editbox
        min: 1900
        max: 2005
        left: 'Year:'
    - id: q_med_q1u
      kind: Question
      title: 'In the past month, did you take: ... thyroid medication such as Synthroid or Levothyroxine?'
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_med_q1v
      kind: Question
      title: 'In the past month, did you take: ... any other medication?'
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_med_q1vs
      kind: Question
      title: 'Please specify the medication:'
      precondition:
      - predicate: q_med_q1v.outcome == 1
      input:
        control: Textarea
        placeholder: Specify the medication...
        maxLength: 80
  - id: b_medication_exposure
    title: Medication Exposure
    precondition:
    - predicate: is_proxy == 0
    - predicate: sex == 2
    items:
    - id: q_mex_gave_birth
      kind: Question
      title: Have you given birth in the past 5 years?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_mex_birth_year
      kind: Question
      title: In what year was your last baby born?
      precondition:
      - predicate: q_mex_gave_birth.outcome == 1
      input:
        control: Editbox
        min: 2000
        max: 2006
    - id: q_mex_folic_acid
      kind: Question
      title: Did you take a vitamin supplement containing folic acid before your last pregnancy, that is, before you found
        out that you were pregnant?
      precondition:
      - predicate: q_mex_gave_birth.outcome == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_mex_breastfed
      kind: Question
      title: For your last baby, did you breastfeed or try to breastfeed your baby, even if only for a short time?
      precondition:
      - predicate: q_mex_gave_birth.outcome == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_mex_no_bf_reason
      kind: Question
      title: What is the main reason that you did not breastfeed?
      precondition:
      - predicate: q_mex_breastfed.outcome == 0
      input:
        control: Dropdown
        labels:
          1: Bottle feeding easier
          2: Formula as good as breast milk
          3: Breastfeeding is unappealing/disgusting
          4: Father/partner didn't want me to
          5: Returned to work/school early
          6: C-Section
          7: Medical condition - mother
          8: Medical condition - baby
          9: Premature birth
          10: Multiple births
          11: Wanted to drink alcohol
          12: Wanted to smoke
          13: Other
    - id: q_mex_no_bf_other
      kind: Question
      title: 'Please specify the reason you did not breastfeed:'
      precondition:
      - predicate: q_mex_no_bf_reason.outcome == 13
      input:
        control: Textarea
        placeholder: Specify other reason...
        maxLength: 80
    - id: q_mex_still_bf
      kind: Question
      title: Are you still breastfeeding?
      precondition:
      - predicate: q_mex_breastfed.outcome == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_mex_bf_duration
      kind: Question
      title: How long did you breastfeed your last baby?
      precondition:
      - predicate: q_mex_still_bf.outcome == 0
      input:
        control: Dropdown
        labels:
          1: Less than 1 week
          2: 1 to 2 weeks
          3: 3 to 4 weeks
          4: 5 to 8 weeks
          5: 9 weeks to less than 12 weeks
          6: 3 months
          7: 4 months
          8: 5 months
          9: 6 months
          10: 7 to 9 months
          11: 10 to 12 months
          12: More than 1 year
    - id: q_mex_added_food
      kind: Question
      title: How old was your last baby when you first added any other liquids or solid foods to the baby's feeds?
      precondition:
      - predicate: q_mex_breastfed.outcome == 1
      input:
        control: Dropdown
        labels:
          1: Less than 1 week
          2: 1 to 2 weeks
          3: 3 to 4 weeks
          4: 5 to 8 weeks
          5: 9 weeks to less than 12 weeks
          6: 3 months
          7: 4 months
          8: 5 months
          9: 6 months
          10: 7 to 9 months
          11: 10 to 12 months
          12: More than 1 year
          13: Have not added liquids or solids
    - id: q_mex_added_reason
      kind: Question
      title: What is the main reason that you first added other liquids or solid foods?
      precondition:
      - predicate: q_mex_added_food.outcome >= 1 and q_mex_added_food.outcome <= 12
      input:
        control: Dropdown
        labels:
          1: Not enough breast milk
          2: Baby was ready for solid foods
          3: Inconvenience/fatigue
          4: Difficulty with breastfeeding techniques
          5: Medical condition - mother
          6: Medical condition - baby
          7: Advice of doctor/health professional
          8: Returned to work/school
          9: Advice of partner/family/friends
          10: Formula equally healthy
          11: Wanted to drink alcohol
          12: Wanted to smoke
          13: Other
    - id: q_mex_added_other
      kind: Question
      title: 'Please specify the reason you added other liquids or solid foods:'
      precondition:
      - predicate: q_mex_added_reason.outcome == 13
      input:
        control: Textarea
        placeholder: Specify other reason...
        maxLength: 80
    - id: q_mex_vitamin_d
      kind: Question
      title: During the time when your last baby was only fed breast milk, did you give the baby a vitamin supplement containing
        Vitamin D?
      precondition:
      - predicate: q_mex_breastfed.outcome == 1
      - predicate: q_mex_added_food.outcome >= 2 or q_mex_added_food.outcome == 13
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_mex_stop_bf_reason
      kind: Question
      title: What is the main reason that you stopped breastfeeding?
      precondition:
      - predicate: q_mex_breastfed.outcome == 1
      - predicate: q_mex_still_bf.outcome == 0
      input:
        control: Dropdown
        labels:
          1: Not enough breast milk
          2: Baby was ready for solid foods
          3: Inconvenience/fatigue
          4: Difficulty with breastfeeding techniques
          5: Medical condition - mother
          6: Medical condition - baby
          7: Planned to stop at this time
          8: Child weaned him/herself
          9: Advice of doctor/health professional
          10: Returned to work/school
          11: Advice of partner
          12: Formula equally healthy
          13: Wanted to drink alcohol
          14: Wanted to smoke
          15: Other
    - id: q_mex_stop_bf_other
      kind: Question
      title: 'Please specify why you stopped breastfeeding:'
      precondition:
      - predicate: q_mex_stop_bf_reason.outcome == 15
      input:
        control: Textarea
        placeholder: Specify other reason...
        maxLength: 80
    - id: q_mex_preg_smoking
      kind: Question
      title: During your last pregnancy, did you smoke daily, occasionally or not at all?
      precondition:
      - predicate: q_mex_gave_birth.outcome == 1
      - predicate: smk_status in [1, 2] or smk_100_cigs == 1 or smk_ever_whole == 1
      input:
        control: Radio
        labels:
          1: Daily
          2: Occasionally
          3: Not at all
    - id: q_mex_preg_cigs_daily
      kind: Question
      title: How many cigarettes did you usually smoke each day during your last pregnancy?
      precondition:
      - predicate: q_mex_preg_smoking.outcome == 1
      input:
        control: Editbox
        min: 1
        max: 99
    - id: q_mex_preg_cigs_occ
      kind: Question
      title: On the days that you smoked during your last pregnancy, how many cigarettes did you usually smoke?
      precondition:
      - predicate: q_mex_preg_smoking.outcome == 2
      input:
        control: Editbox
        min: 1
        max: 99
    - id: q_mex_bf_smoking
      kind: Question
      title: When you were breastfeeding your last baby, did you smoke daily, occasionally or not at all?
      precondition:
      - predicate: q_mex_breastfed.outcome == 1
      - predicate: smk_status in [1, 2] or smk_100_cigs == 1 or smk_ever_whole == 1
      input:
        control: Radio
        labels:
          1: Daily
          2: Occasionally
          3: Not at all
    - id: q_mex_bf_cigs_daily
      kind: Question
      title: How many cigarettes did you usually smoke each day while breastfeeding?
      precondition:
      - predicate: q_mex_bf_smoking.outcome == 1
      input:
        control: Editbox
        min: 1
        max: 99
    - id: q_mex_bf_cigs_occ
      kind: Question
      title: On the days that you smoked while breastfeeding, how many cigarettes did you usually smoke?
      precondition:
      - predicate: q_mex_bf_smoking.outcome == 2
      input:
        control: Editbox
        min: 1
        max: 99
    - id: q_mex_secondhand
      kind: Question
      title: Did anyone regularly smoke in your presence during or after the pregnancy (about 6 months after)?
      precondition:
      - predicate: q_mex_gave_birth.outcome == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_mex_preg_alcohol
      kind: Question
      title: Did you drink any alcohol during your last pregnancy?
      precondition:
      - predicate: q_mex_gave_birth.outcome == 1
      - predicate: alc_past_year == 1 or alc_ever == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_mex_preg_alc_freq
      kind: Question
      title: How often did you drink during your last pregnancy?
      precondition:
      - predicate: q_mex_preg_alcohol.outcome == 1
      input:
        control: Radio
        labels:
          1: Less than once a month
          2: Once a month
          3: 2 to 3 times a month
          4: Once a week
          5: 2 to 3 times a week
          6: 4 to 6 times a week
          7: Every day
    - id: q_mex_bf_alcohol
      kind: Question
      title: Did you drink any alcohol while you were breastfeeding your last baby?
      precondition:
      - predicate: q_mex_breastfed.outcome == 1
      - predicate: alc_past_year == 1 or alc_ever == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_mex_bf_alc_freq
      kind: Question
      title: How often did you drink while breastfeeding?
      precondition:
      - predicate: q_mex_bf_alcohol.outcome == 1
      input:
        control: Radio
        labels:
          1: Less than once a month
          2: Once a month
          3: 2 to 3 times a month
          4: Once a week
          5: 2 to 3 times a week
          6: 4 to 6 times a week
          7: Every day
