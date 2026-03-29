qmlVersion: '1.0'
questionnaire:
  title: 10 Smoking Tobacco
  codeInit: |
    # Extern variables from prior sections
    is_proxy: {0, 1}
    age: range(12, 120)
    # HCU_Q01AA: Has regular medical doctor (1=Yes, 0=No)
    hcu_regular_doctor: {0, 1}
    # HCU_Q02E: Number of dentist consultations in past 12 months
    # 0=none, 1-97=count
    hcu_dentist_consult: range(0, 97)
    # DEN_Q130: Visited dentist for check-up (1=Yes, 0=No/not asked)
    den_checkup: {0, 1}
    # DEN_Q132: Visited dentist for other reason (1=Yes, 0=No/not asked)
    den_other_visit: {0, 1}
    # Number of household members (1 = lives alone)
    household_size: range(1, 20)
  blocks:
  - id: b_sun_safety
    title: Sun Safety Behaviours
    precondition:
    - predicate: is_proxy == 0
    items:
    - id: q_ssb_intro
      kind: Comment
      title: The next few questions are about exposure to the sun and sunburns. Sunburn is defined as any reddening or discomfort
        of the skin, that lasts longer than 12 hours after exposure to the sun or other UV sources, such as tanning beds or
        sun lamps.
    - id: q_ssb_sunburnt
      kind: Question
      title: In the past 12 months, has any part of your body been sunburnt?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_ssb_blister
      kind: Question
      title: Did any of your sunburns involve blistering?
      precondition:
      - predicate: q_ssb_sunburnt.outcome == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_ssb_pain
      kind: Question
      title: Did any of your sunburns involve pain or discomfort that lasted for more than 1 day?
      precondition:
      - predicate: q_ssb_sunburnt.outcome == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_ssb_weekend_intro
      kind: Comment
      title: For the next questions, think about a typical weekend, or day off from work or school in the summer months.
    - id: q_ssb_time_in_sun
      kind: Question
      title: About how much time each day do you spend in the sun between 11 am and 4 pm?
      input:
        control: Radio
        labels:
          1: None
          2: Less than 30 minutes
          3: 30 to 59 minutes
          4: 1 hour to less than 2 hours
          5: 2 hours to less than 3 hours
          6: 3 hours to less than 4 hours
          7: 4 hours to less than 5 hours
          8: 5 hours
    - id: q_ssb_shade
      kind: Question
      title: In the summer months, on a typical weekend or day off, when you are in the sun for 30 minutes or more, how often
        do you seek shade?
      precondition:
      - predicate: q_ssb_time_in_sun.outcome >= 3
      input:
        control: Radio
        labels:
          1: Always
          2: Often
          3: Sometimes
          4: Rarely
          5: Never
    - id: q_ssb_hat
      kind: Question
      title: How often do you wear a hat that shades your face, ears and neck?
      precondition:
      - predicate: q_ssb_time_in_sun.outcome >= 3
      input:
        control: Radio
        labels:
          1: Always
          2: Often
          3: Sometimes
          4: Rarely
          5: Never
    - id: q_ssb_long_clothing
      kind: Question
      title: How often do you wear long pants or a long skirt to protect your skin from the sun?
      precondition:
      - predicate: q_ssb_time_in_sun.outcome >= 3
      input:
        control: Radio
        labels:
          1: Always
          2: Often
          3: Sometimes
          4: Rarely
          5: Never
    - id: q_ssb_sunscreen_face
      kind: Question
      title: How often do you use sunscreen on your face?
      precondition:
      - predicate: q_ssb_time_in_sun.outcome >= 3
      input:
        control: Radio
        labels:
          1: Always
          2: Often
          3: Sometimes
          4: Rarely
          5: Never
    - id: q_ssb_spf_face
      kind: Question
      title: What Sun Protection Factor (SPF) do you usually use on your face?
      precondition:
      - predicate: q_ssb_sunscreen_face.outcome in [1, 2, 3]
      input:
        control: Radio
        labels:
          1: Less than 15
          2: 15 to 25
          3: More than 25
    - id: q_ssb_sunscreen_body
      kind: Question
      title: How often do you use sunscreen on your body?
      precondition:
      - predicate: q_ssb_time_in_sun.outcome >= 3
      input:
        control: Radio
        labels:
          1: Always
          2: Often
          3: Sometimes
          4: Rarely
          5: Never
    - id: q_ssb_spf_body
      kind: Question
      title: What Sun Protection Factor (SPF) do you usually use on your body?
      precondition:
      - predicate: q_ssb_sunscreen_body.outcome in [1, 2, 3]
      input:
        control: Radio
        labels:
          1: Less than 15
          2: 15 to 25
          3: More than 25
  - id: b_smoking
    title: Smoking
    items:
    - id: q_smk_intro
      kind: Comment
      title: The next questions are about smoking.
    - id: q_smk_100_cigs
      kind: Question
      title: In your lifetime, have you smoked a total of 100 or more cigarettes (about 4 packs)?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_smk_ever_whole
      kind: Question
      title: Have you ever smoked a whole cigarette?
      precondition:
      - predicate: q_smk_100_cigs.outcome == 0
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_smk_age_first
      kind: Question
      title: At what age did you smoke your first whole cigarette?
      precondition:
      - predicate: q_smk_100_cigs.outcome == 1 or q_smk_ever_whole.outcome == 1
      postcondition:
      - predicate: q_smk_age_first.outcome >= 5
        hint: Age must be at least 5.
      - predicate: q_smk_age_first.outcome <= age
        hint: Age first smoked cannot exceed current age.
      input:
        control: Editbox
        min: 1
        max: 120
    - id: q_smk_status
      kind: Question
      title: At the present time, do you smoke cigarettes daily, occasionally or not at all?
      input:
        control: Radio
        labels:
          1: Daily
          2: Occasionally
          3: Not at all
    - id: q_smk_age_daily
      kind: Question
      title: At what age did you begin to smoke cigarettes daily?
      precondition:
      - predicate: q_smk_status.outcome == 1
      postcondition:
      - predicate: q_smk_age_daily.outcome >= 5
        hint: Age must be at least 5.
      - predicate: q_smk_age_daily.outcome <= age
        hint: Age began daily smoking cannot exceed current age.
      input:
        control: Editbox
        min: 1
        max: 120
    - id: q_smk_cigs_per_day
      kind: Question
      title: How many cigarettes do you smoke each day now?
      precondition:
      - predicate: q_smk_status.outcome == 1
      input:
        control: Editbox
        min: 1
        max: 99
    - id: q_smk_cigs_occasional
      kind: Question
      title: On the days that you do smoke, how many cigarettes do you usually smoke?
      precondition:
      - predicate: q_smk_status.outcome == 2
      input:
        control: Editbox
        min: 1
        max: 99
    - id: q_smk_days_smoked
      kind: Question
      title: In the past month, on how many days have you smoked 1 or more cigarettes?
      precondition:
      - predicate: q_smk_status.outcome == 2
      input:
        control: Editbox
        min: 0
        max: 30
    - id: q_smk_ever_daily
      kind: Question
      title: Have you ever smoked cigarettes daily?
      precondition:
      - predicate: q_smk_status.outcome == 3
      - predicate: q_smk_100_cigs.outcome == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_smk_when_stopped
      kind: Question
      title: 'When did you stop smoking? Was it:'
      precondition:
      - predicate: q_smk_status.outcome == 3
      - predicate: q_smk_100_cigs.outcome == 1
      - predicate: q_smk_ever_daily.outcome == 0
      input:
        control: Radio
        labels:
          1: Less than one year ago
          2: 1 year to less than 2 years ago
          3: 2 years to less than 3 years ago
          4: 3 or more years ago
    - id: q_smk_month_stopped
      kind: Question
      title: In what month did you stop?
      precondition:
      - predicate: q_smk_when_stopped.outcome == 1
      input:
        control: Dropdown
        labels:
          1: January
          2: February
          3: March
          4: April
          5: May
          6: June
          7: July
          8: August
          9: September
          10: October
          11: November
          12: December
    - id: q_smk_years_ago_stopped
      kind: Question
      title: How many years ago was it?
      precondition:
      - predicate: q_smk_when_stopped.outcome == 4
      postcondition:
      - predicate: q_smk_years_ago_stopped.outcome >= 3
        hint: Must be at least 3 years ago.
      - predicate: q_smk_years_ago_stopped.outcome <= age - 5
        hint: Years ago cannot exceed current age minus 5.
      input:
        control: Editbox
        min: 3
        max: 115
    - id: q_smk_former_age_daily
      kind: Question
      title: At what age did you begin to smoke cigarettes daily?
      precondition:
      - predicate: q_smk_ever_daily.outcome == 1
      postcondition:
      - predicate: q_smk_former_age_daily.outcome >= 5
        hint: Age must be at least 5.
      - predicate: q_smk_former_age_daily.outcome <= age
        hint: Age began daily smoking cannot exceed current age.
      input:
        control: Editbox
        min: 1
        max: 120
    - id: q_smk_former_cigs_daily
      kind: Question
      title: How many cigarettes did you usually smoke each day?
      precondition:
      - predicate: q_smk_ever_daily.outcome == 1
      input:
        control: Editbox
        min: 1
        max: 99
    - id: q_smk_when_stopped_daily
      kind: Question
      title: 'When did you stop smoking daily? Was it:'
      precondition:
      - predicate: q_smk_ever_daily.outcome == 1
      input:
        control: Radio
        labels:
          1: Less than one year ago
          2: 1 year to less than 2 years ago
          3: 2 years to less than 3 years ago
          4: 3 or more years ago
    - id: q_smk_month_stopped_daily
      kind: Question
      title: In what month did you stop smoking daily?
      precondition:
      - predicate: q_smk_when_stopped_daily.outcome == 1
      input:
        control: Dropdown
        labels:
          1: January
          2: February
          3: March
          4: April
          5: May
          6: June
          7: July
          8: August
          9: September
          10: October
          11: November
          12: December
    - id: q_smk_years_ago_daily
      kind: Question
      title: How many years ago did you stop smoking daily?
      precondition:
      - predicate: q_smk_when_stopped_daily.outcome == 4
      postcondition:
      - predicate: q_smk_years_ago_daily.outcome >= 3
        hint: Must be at least 3 years ago.
      - predicate: q_smk_years_ago_daily.outcome <= age - 5
        hint: Years ago cannot exceed current age minus 5.
      input:
        control: Editbox
        min: 3
        max: 115
    - id: q_smk_completely_quit
      kind: Question
      title: Was that when you completely quit smoking?
      precondition:
      - predicate: q_smk_ever_daily.outcome == 1
      - predicate: q_smk_status.outcome == 3
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_smk_when_complete_stop
      kind: Question
      title: 'When did you stop smoking completely? Was it:'
      precondition:
      - predicate: q_smk_completely_quit.outcome == 0
      input:
        control: Radio
        labels:
          1: Less than one year ago
          2: 1 year to less than 2 years ago
          3: 2 years to less than 3 years ago
          4: 3 or more years ago
    - id: q_smk_month_complete_stop
      kind: Question
      title: In what month did you stop smoking completely?
      precondition:
      - predicate: q_smk_when_complete_stop.outcome == 1
      input:
        control: Dropdown
        labels:
          1: January
          2: February
          3: March
          4: April
          5: May
          6: June
          7: July
          8: August
          9: September
          10: October
          11: November
          12: December
    - id: q_smk_years_ago_complete
      kind: Question
      title: How many years ago did you stop smoking completely?
      precondition:
      - predicate: q_smk_when_complete_stop.outcome == 4
      postcondition:
      - predicate: q_smk_years_ago_complete.outcome >= 3
        hint: Must be at least 3 years ago.
      - predicate: q_smk_years_ago_complete.outcome <= age - 5
        hint: Years ago cannot exceed current age minus 5.
      input:
        control: Editbox
        min: 3
        max: 115
  - id: b_stages_of_change
    title: Smoking - Stages of Change
    precondition:
    - predicate: is_proxy == 0
    - predicate: q_smk_status.outcome in [1, 2]
    items:
    - id: q_sch_quit_6months
      kind: Question
      title: Are you seriously considering quitting smoking within the next 6 months?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_sch_quit_30days
      kind: Question
      title: Are you seriously considering quitting within the next 30 days?
      precondition:
      - predicate: q_sch_quit_6months.outcome == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_sch_tried_quit
      kind: Question
      title: In the past 12 months, did you stop smoking for at least 24 hours because you were trying to quit?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_sch_quit_times
      kind: Question
      title: How many times did you stop smoking for at least 24 hours because you were trying to quit in the past 12 months?
      precondition:
      - predicate: q_sch_tried_quit.outcome == 1
      input:
        control: Editbox
        min: 1
        max: 95
  - id: b_nicotine_dependence
    title: Nicotine Dependence
    precondition:
    - predicate: is_proxy == 0
    - predicate: q_smk_status.outcome == 1
    items:
    - id: q_nde_first_cig
      kind: Question
      title: How soon after you wake up do you smoke your first cigarette?
      input:
        control: Radio
        labels:
          1: Within 5 minutes
          2: 6 to 30 minutes after waking
          3: 31 to 60 minutes after waking
          4: More than 60 minutes after waking
    - id: q_nde_refrain
      kind: Question
      title: Do you find it difficult to refrain from smoking in places where it is forbidden?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_nde_hate_give_up
      kind: Question
      title: Which cigarette would you most hate to give up?
      input:
        control: Radio
        labels:
          1: The first one of the day
          2: Another one
    - id: q_nde_morning_more
      kind: Question
      title: Do you smoke more frequently during the first hours after waking, compared with the rest of the day?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_nde_smoke_ill
      kind: Question
      title: Do you smoke even if you are so ill that you are in bed most of the day?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
  - id: b_cessation_aids
    title: Smoking Cessation Aids
    precondition:
    - predicate: is_proxy == 0
    items:
    - id: q_sca_patch_former
      kind: Question
      title: In the past 12 months, did you try a nicotine patch to quit smoking?
      precondition:
      - predicate: q_smk_status.outcome == 3
      - predicate: q_smk_when_stopped.outcome == 1 or q_smk_when_stopped_daily.outcome == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_sca_patch_useful
      kind: Question
      title: How useful was that in helping you quit?
      precondition:
      - predicate: q_sca_patch_former.outcome == 1
      input:
        control: Radio
        labels:
          1: Very useful
          2: Somewhat useful
          3: Not very useful
          4: Not useful at all
    - id: q_sca_gum_former
      kind: Question
      title: Did you try Nicorettes or other nicotine gum or candy to quit smoking in the past 12 months?
      precondition:
      - predicate: q_smk_status.outcome == 3
      - predicate: q_smk_when_stopped.outcome == 1 or q_smk_when_stopped_daily.outcome == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_sca_gum_useful
      kind: Question
      title: How useful was that in helping you quit?
      precondition:
      - predicate: q_sca_gum_former.outcome == 1
      input:
        control: Radio
        labels:
          1: Very useful
          2: Somewhat useful
          3: Not very useful
          4: Not useful at all
    - id: q_sca_med_former
      kind: Question
      title: In the past 12 months, did you try medication such as Zyban, Prolev or Wellbutrin to quit smoking?
      precondition:
      - predicate: q_smk_status.outcome == 3
      - predicate: q_smk_when_stopped.outcome == 1 or q_smk_when_stopped_daily.outcome == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_sca_med_useful
      kind: Question
      title: How useful was that in helping you quit?
      precondition:
      - predicate: q_sca_med_former.outcome == 1
      input:
        control: Radio
        labels:
          1: Very useful
          2: Somewhat useful
          3: Not very useful
          4: Not useful at all
    - id: q_sca_tried_quit
      kind: Question
      title: In the past 12 months, did you stop smoking for at least 24 hours because you were trying to quit?
      precondition:
      - predicate: q_smk_status.outcome in [1, 2]
      - predicate: q_sch_tried_quit.outcome == 0
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_sca_patch_current
      kind: Question
      title: 'In the past 12 months, did you try any of the following to quit smoking: a nicotine patch?'
      precondition:
      - predicate: q_smk_status.outcome in [1, 2]
      - predicate: q_sch_tried_quit.outcome == 1 or q_sca_tried_quit.outcome == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_sca_gum_current
      kind: Question
      title: Did you try Nicorettes or other nicotine gum or candy to quit smoking in the past 12 months?
      precondition:
      - predicate: q_smk_status.outcome in [1, 2]
      - predicate: q_sch_tried_quit.outcome == 1 or q_sca_tried_quit.outcome == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_sca_med_current
      kind: Question
      title: Did you try medication such as Zyban, Prolev or Wellbutrin to quit smoking in the past 12 months?
      precondition:
      - predicate: q_smk_status.outcome in [1, 2]
      - predicate: q_sch_tried_quit.outcome == 1 or q_sca_tried_quit.outcome == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
  - id: b_physician_counselling
    title: Smoking - Physician Counselling
    precondition:
    - predicate: is_proxy == 0
    - predicate: q_smk_status.outcome in [1, 2] or q_smk_when_stopped.outcome == 1 or q_smk_when_stopped_daily.outcome == 1
    items:
    - id: q_spc_saw_doctor
      kind: Question
      title: Earlier, you mentioned having a regular medical doctor. In the past 12 months, did you go see this doctor?
      precondition:
      - predicate: hcu_regular_doctor == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_spc_doctor_knows
      kind: Question
      title: Does your doctor know that you smoke cigarettes?
      precondition:
      - predicate: q_spc_saw_doctor.outcome == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_spc_doctor_advise
      kind: Question
      title: In the past 12 months, did your doctor advise you to quit smoking?
      precondition:
      - predicate: q_spc_doctor_knows.outcome == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_spc_doctor_help
      kind: Question
      title: Did your doctor give you any specific help or information to quit smoking?
      precondition:
      - predicate: q_spc_doctor_knows.outcome == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_spc_doctor_help_type
      kind: Question
      title: What type of help did the doctor give?
      precondition:
      - predicate: q_spc_doctor_help.outcome == 1
      input:
        control: Checkbox
        labels:
          1: Referral to a one-on-one cessation program
          2: Referral to a group cessation program
          4: Recommended use of nicotine patch or nicotine gum
          8: Recommended Zyban or other medication
          16: Provided self-help information
          32: Own doctor offered counselling
          64: Other
    - id: q_spc_went_dentist
      kind: Question
      title: Earlier, you mentioned having seen or talked to a dentist in the past 12 months. Did you actually go to the dentist?
      precondition:
      - predicate: den_checkup == 0 and den_other_visit == 0
      - predicate: hcu_dentist_consult >= 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_spc_dentist_knows
      kind: Question
      title: Does your dentist or dental hygienist know that you smoke cigarettes?
      precondition:
      - predicate: den_checkup == 1 or den_other_visit == 1 or q_spc_went_dentist.outcome == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_spc_dentist_advise
      kind: Question
      title: In the past 12 months, did the dentist or hygienist advise you to quit smoking?
      precondition:
      - predicate: q_spc_dentist_knows.outcome == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
  - id: b_youth_smoking
    title: Youth Smoking
    precondition:
    - predicate: is_proxy == 0
    - predicate: age <= 19
    - predicate: q_smk_status.outcome in [1, 2]
    items:
    - id: q_ysm_source
      kind: Question
      title: Where do you usually get your cigarettes?
      input:
        control: Dropdown
        labels:
          1: Buy from - Vending machine
          2: Buy from - Small grocery / corner store
          3: Buy from - Supermarket
          4: Buy from - Drug store
          5: Buy from - Gas station
          6: Buy from - Other store
          7: Buy from - Friend or someone else
          8: Given them by - Brother or sister
          9: Given them by - Mother or father
          10: Given them by - Friend or someone else
          11: Take them from - Mother, father or sibling
          12: Other
    - id: q_ysm_source_other
      kind: Question
      title: 'Please specify where you usually get your cigarettes:'
      precondition:
      - predicate: q_ysm_source.outcome == 12
      input:
        control: Textarea
        placeholder: Specify other source...
        maxLength: 80
    - id: q_ysm_ever_bought
      kind: Question
      title: In the past 12 months, have you bought cigarettes for yourself or for someone else?
      precondition:
      - predicate: q_ysm_source.outcome >= 8
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_ysm_asked_age
      kind: Question
      title: In the past 12 months, have you been asked your age when buying cigarettes in a store?
      precondition:
      - predicate: q_ysm_source.outcome in [1, 2, 3, 4, 5, 6, 7] or q_ysm_ever_bought.outcome == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_ysm_refused_sale
      kind: Question
      title: In the past 12 months, has anyone in a store refused to sell you cigarettes?
      precondition:
      - predicate: q_ysm_source.outcome in [1, 2, 3, 4, 5, 6, 7] or q_ysm_ever_bought.outcome == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_ysm_stranger_buy
      kind: Question
      title: In the past 12 months, have you asked a stranger to buy you cigarettes?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
  - id: b_second_hand_smoke
    title: Exposure to Second-Hand Smoke
    items:
    - id: q_ets_intro
      kind: Comment
      title: The next questions are about exposure to second-hand smoke.
    - id: q_ets_smoke_home
      kind: Question
      title: Including both household members and regular visitors, does anyone smoke inside your home, every day or almost
        every day?
      precondition:
      - predicate: not (household_size == 1 and q_smk_status.outcome in [1, 2])
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_ets_smoke_home_count
      kind: Question
      title: How many people smoke inside your home every day or almost every day?
      precondition:
      - predicate: q_ets_smoke_home.outcome == 1
      input:
        control: Editbox
        min: 1
        max: 15
    - id: q_ets_car
      kind: Question
      title: In the past month, were you exposed to second-hand smoke, every day or almost every day, in a car or other private
        vehicle?
      precondition:
      - predicate: q_smk_status.outcome == 3
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_ets_public
      kind: Question
      title: In the past month, were you exposed to second-hand smoke, every day or almost every day, in public places (such
        as bars, restaurants, shopping malls, arenas, bingo halls, bowling alleys)?
      precondition:
      - predicate: q_smk_status.outcome == 3
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_ets_restrictions
      kind: Question
      title: Are there any restrictions against smoking cigarettes in your home?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_ets_restriction_type
      kind: Question
      title: How is smoking restricted in your home?
      precondition:
      - predicate: q_ets_restrictions.outcome == 1
      input:
        control: Checkbox
        labels:
          1: Smokers are asked to refrain from smoking in the house
          2: Smoking is allowed in certain rooms only
          4: Smoking is restricted in the presence of young children
          8: Other restriction
