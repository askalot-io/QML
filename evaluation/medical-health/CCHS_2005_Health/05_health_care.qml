qmlVersion: '1.0'
questionnaire:
  title: 05 Health Care
  codeInit: |
    # Extern variables from prior sections
    age: range(12, 120)
    sex: {1, 2}
    is_proxy: {0, 1}
    # Derived: did respondent have any health care contact?
    had_health_contact = 0
  blocks:
  - id: b_health_care_satisfaction
    title: Health Care System Satisfaction
    precondition:
    - predicate: is_proxy == 0
    - predicate: age >= 15
    items:
    - id: q_hcs_province_availability
      kind: Question
      title: 'Now, a few questions about health care services in your province. Overall, how would you rate the availability
        of health care services in your province? Would you say it is:'
      input:
        control: Radio
        labels:
          1: Excellent
          2: Good
          3: Fair
          4: Poor
    - id: q_hcs_province_quality
      kind: Question
      title: Overall, how would you rate the quality of the health care services that are available in your province?
      input:
        control: Radio
        labels:
          1: Excellent
          2: Good
          3: Fair
          4: Poor
    - id: q_hcs_community_availability
      kind: Question
      title: Overall, how would you rate the availability of health care services in your community?
      input:
        control: Radio
        labels:
          1: Excellent
          2: Good
          3: Fair
          4: Poor
    - id: q_hcs_community_quality
      kind: Question
      title: Overall, how would you rate the quality of the health care services that are available in your community?
      input:
        control: Radio
        labels:
          1: Excellent
          2: Good
          3: Fair
          4: Poor
  - id: b_regular_doctor_hospital
    title: Regular Doctor and Hospital Stays
    items:
    - id: q_hcu_r01
      kind: Comment
      title: Now I'd like to ask about your contacts with various health professionals during the past 12 months.
    - id: q_hcu_q01aa
      kind: Question
      title: Do you have a regular medical doctor?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_hcu_q01ab
      kind: Question
      title: Why do you not have a regular medical doctor? (Mark all that apply)
      precondition:
      - predicate: q_hcu_q01aa.outcome == 0
      input:
        control: Checkbox
        labels:
          1: No medical doctors available in the area
          2: Medical doctors in the area are not taking new patients
          4: Have not tried to contact one
          8: Had a medical doctor who left or retired
          16: Other
    - id: q_hcu_q01abs
      kind: Question
      title: Please specify the reason you do not have a regular medical doctor.
      precondition:
      - predicate: q_hcu_q01aa.outcome == 0
      - predicate: q_hcu_q01ab.outcome % 32 >= 16
      input:
        control: Textarea
        placeholder: Specify reason...
        maxLength: 200
    - id: q_hcu_q01ac
      kind: Question
      title: Do you and this doctor usually speak in English, in French, or in another language?
      precondition:
      - predicate: q_hcu_q01aa.outcome == 1
      input:
        control: Dropdown
        labels:
          1: English
          2: French
          3: Arabic
          4: Chinese
          5: Cree
          6: German
          7: Greek
          8: Hungarian
          9: Italian
          10: Korean
          11: Persian (Farsi)
          12: Polish
          13: Portuguese
          14: Punjabi
          15: Spanish
          16: Tagalog (Pilipino)
          17: Ukrainian
          18: Vietnamese
          19: Dutch
          20: Hindi
          21: Russian
          22: Tamil
          23: Other
    - id: q_hcu_q01acs
      kind: Question
      title: Please specify the language.
      precondition:
      - predicate: q_hcu_q01aa.outcome == 1
      - predicate: q_hcu_q01ac.outcome == 23
      input:
        control: Textarea
        placeholder: Specify language...
        maxLength: 200
    - id: q_hcu_q01ba
      kind: Question
      title: In the past 12 months, have you been a patient overnight in a hospital, nursing home or convalescent home?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_hcu_q01bb
      kind: Question
      title: For how many nights in the past 12 months?
      precondition:
      - predicate: q_hcu_q01ba.outcome == 1
      postcondition:
      - predicate: q_hcu_q01bb.outcome <= 100
        hint: 'Warning: more than 100 nights reported. Please confirm.'
      input:
        control: Editbox
        min: 1
        max: 366
        right: nights
  - id: b_professional_contacts
    title: Contacts with Health Professionals
    items:
    - id: q_hcu_q02a
      kind: Question
      title: In the past 12 months, how many times have you seen, or talked on the telephone, about your physical, emotional
        or mental health with a family doctor, pediatrician or general practitioner?
      postcondition:
      - predicate: q_hcu_q02a.outcome <= 12
        hint: 'Warning: more than 12 visits reported. Please confirm.'
      input:
        control: Editbox
        min: 0
        max: 366
        right: times
    - id: q_hcu_q02b
      kind: Question
      title: How many times have you seen an eye specialist (such as an ophthalmologist or optometrist)?
      postcondition:
      - predicate: q_hcu_q02b.outcome <= 3
        hint: 'Warning: more than 3 visits reported. Please confirm.'
      input:
        control: Editbox
        min: 0
        max: 75
        right: times
    - id: q_hcu_q02c
      kind: Question
      title: How many times have you seen any other medical doctor (such as a surgeon, allergist, orthopedist, gynaecologist
        or psychiatrist)?
      postcondition:
      - predicate: q_hcu_q02c.outcome <= 7
        hint: 'Warning: more than 7 visits reported. Please confirm.'
      input:
        control: Editbox
        min: 0
        max: 300
        right: times
    - id: q_hcu_q02d
      kind: Question
      title: How many times have you seen a nurse for care or advice?
      postcondition:
      - predicate: q_hcu_q02d.outcome <= 15
        hint: 'Warning: more than 15 visits reported. Please confirm.'
      input:
        control: Editbox
        min: 0
        max: 366
        right: times
    - id: q_hcu_q02e
      kind: Question
      title: How many times have you seen a dentist or orthodontist?
      postcondition:
      - predicate: q_hcu_q02e.outcome <= 4
        hint: 'Warning: more than 4 visits reported. Please confirm.'
      input:
        control: Editbox
        min: 0
        max: 99
        right: times
    - id: q_hcu_q02f
      kind: Question
      title: How many times have you seen a chiropractor?
      postcondition:
      - predicate: q_hcu_q02f.outcome <= 20
        hint: 'Warning: more than 20 visits reported. Please confirm.'
      input:
        control: Editbox
        min: 0
        max: 366
        right: times
    - id: q_hcu_q02g
      kind: Question
      title: How many times have you seen a physiotherapist?
      postcondition:
      - predicate: q_hcu_q02g.outcome <= 30
        hint: 'Warning: more than 30 visits reported. Please confirm.'
      input:
        control: Editbox
        min: 0
        max: 366
        right: times
    - id: q_hcu_q02h
      kind: Question
      title: How many times have you seen a social worker or counsellor?
      postcondition:
      - predicate: q_hcu_q02h.outcome <= 20
        hint: 'Warning: more than 20 visits reported. Please confirm.'
      input:
        control: Editbox
        min: 0
        max: 366
        right: times
    - id: q_hcu_q02i
      kind: Question
      title: How many times have you seen a psychologist?
      postcondition:
      - predicate: q_hcu_q02i.outcome <= 25
        hint: 'Warning: more than 25 visits reported. Please confirm.'
      input:
        control: Editbox
        min: 0
        max: 366
        right: times
    - id: q_hcu_q02j
      kind: Question
      title: How many times have you seen a speech, audiology or occupational therapist?
      postcondition:
      - predicate: q_hcu_q02j.outcome <= 12
        hint: 'Warning: more than 12 visits reported. Please confirm.'
      input:
        control: Editbox
        min: 0
        max: 200
        right: times
      codeBlock: |
        if q_hcu_q01ba.outcome == 1:
            had_health_contact = 1
        if q_hcu_q02a.outcome > 0:
            had_health_contact = 1
        if q_hcu_q02b.outcome > 0:
            had_health_contact = 1
        if q_hcu_q02c.outcome > 0:
            had_health_contact = 1
        if q_hcu_q02d.outcome > 0:
            had_health_contact = 1
        if q_hcu_q02e.outcome > 0:
            had_health_contact = 1
        if q_hcu_q02f.outcome > 0:
            had_health_contact = 1
        if q_hcu_q02g.outcome > 0:
            had_health_contact = 1
        if q_hcu_q02h.outcome > 0:
            had_health_contact = 1
        if q_hcu_q02i.outcome > 0:
            had_health_contact = 1
        if q_hcu_q02j.outcome > 0:
            had_health_contact = 1
  - id: b_contact_location
    title: Location of Most Recent Contact
    precondition:
    - predicate: q_hcu_q02a.outcome > 0 or q_hcu_q02c.outcome > 0 or q_hcu_q02d.outcome > 0
    items:
    - id: q_hcu_q03
      kind: Question
      title: Where did the most recent contact take place?
      input:
        control: Dropdown
        labels:
          1: Doctor's office
          2: Hospital emergency room
          3: Hospital outpatient clinic
          4: Walk-in clinic
          5: Appointment clinic
          6: Community health centre / CLSC
          7: At work
          8: At school
          9: At home
          10: Telephone consultation only
          11: Other
    - id: q_hcu_q03s
      kind: Question
      title: Please specify the location of the most recent contact.
      precondition:
      - predicate: q_hcu_q03.outcome == 11
      input:
        control: Textarea
        placeholder: Specify location...
        maxLength: 200
    - id: q_hcu_q03_1
      kind: Question
      title: 'Did this most recent contact occur:'
      precondition:
      - predicate: q_hcu_q03.outcome in [3, 5, 6]
      input:
        control: Radio
        labels:
          1: In-person (face-to-face)
          2: Through a videoconference
          3: Through another method
  - id: b_selfhelp_alternative
    title: Self-Help and Alternative Care
    items:
    - id: q_hcu_q04a
      kind: Question
      title: In the past 12 months, have you attended a meeting of a self-help group such as AA or a cancer support group?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_hcu_q04
      kind: Question
      title: In the past 12 months, have you seen or talked to an alternative health care provider such as an acupuncturist,
        homeopath or massage therapist about your physical, emotional or mental health?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_hcu_q05
      kind: Question
      title: Who did you see or talk to? (Mark all that apply)
      precondition:
      - predicate: q_hcu_q04.outcome == 1
      input:
        control: Checkbox
        labels:
          1: Massage therapist
          2: Acupuncturist
          4: Homeopath or naturopath
          8: Feldenkrais or Alexander teacher
          16: Relaxation therapist
          32: Biofeedback teacher
          64: Rolfer
          128: Herbalist
          256: Reflexologist
          512: Spiritual healer
          1024: Religious healer
          2048: Other
    - id: q_hcu_q05s
      kind: Question
      title: Please specify the alternative health care provider.
      precondition:
      - predicate: q_hcu_q04.outcome == 1
      - predicate: q_hcu_q05.outcome % 4096 >= 2048
      input:
        control: Textarea
        placeholder: Specify alternative provider...
        maxLength: 200
  - id: b_unmet_needs
    title: Unmet Health Care Needs
    items:
    - id: q_hcu_q06
      kind: Question
      title: During the past 12 months, was there ever a time when you felt that you needed health care but you didn't receive
        it?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_hcu_q07
      kind: Question
      title: Thinking of the most recent time, why didn't you get care? (Mark all that apply)
      precondition:
      - predicate: q_hcu_q06.outcome == 1
      input:
        control: Checkbox
        labels:
          1: Not available in the area
          2: Not available at time required
          4: Waiting time too long
          8: Felt would be inadequate
          16: Cost
          32: Too busy
          64: Didn't get around to it / didn't bother
          128: Didn't know where to go
          256: Transportation problems
          512: Language problems
          1024: Personal or family responsibilities
          2048: Dislikes doctors / afraid
          4096: Decided not to seek care
          8192: Doctor didn't think it was necessary
          16384: Unable to leave the house because of a health problem
          32768: Other
    - id: q_hcu_q07s
      kind: Question
      title: Please specify the reason for not getting care.
      precondition:
      - predicate: q_hcu_q06.outcome == 1
      - predicate: q_hcu_q07.outcome % 65536 >= 32768
      input:
        control: Textarea
        placeholder: Specify reason...
        maxLength: 200
    - id: q_hcu_q08
      kind: Question
      title: Again, thinking of the most recent time, what was the type of care that was needed? (Mark all that apply)
      precondition:
      - predicate: q_hcu_q06.outcome == 1
      input:
        control: Checkbox
        labels:
          1: Treatment of a physical health problem
          2: Treatment of an emotional or mental health problem
          4: A regular check-up (including regular pre-natal care)
          8: Care of an injury
          16: Other
    - id: q_hcu_q08s
      kind: Question
      title: Please specify the type of care needed.
      precondition:
      - predicate: q_hcu_q06.outcome == 1
      - predicate: q_hcu_q08.outcome % 32 >= 16
      input:
        control: Textarea
        placeholder: Specify type of care...
        maxLength: 200
    - id: q_hcu_q09
      kind: Question
      title: Where did you try to get the service you were seeking? (Mark all that apply)
      precondition:
      - predicate: q_hcu_q06.outcome == 1
      input:
        control: Checkbox
        labels:
          1: Doctor's office
          2: Hospital emergency room
          4: Hospital overnight patient
          8: Hospital outpatient clinic
          16: Walk-in clinic
          32: Appointment clinic
          64: Community health centre / CLSC
          128: Other
    - id: q_hcu_q09s
      kind: Question
      title: Please specify the location where you tried to get the service.
      precondition:
      - predicate: q_hcu_q06.outcome == 1
      - predicate: q_hcu_q09.outcome % 256 >= 128
      input:
        control: Textarea
        placeholder: Specify location...
        maxLength: 200
  - id: b_government_home_care
    title: Government-Covered Home Care
    precondition:
    - predicate: age >= 18
    items:
    - id: q_hmc_r09
      kind: Comment
      title: Now some questions on home care services. These are health care, homemaker or other support services received
        at home.
    - id: q_hmc_q09
      kind: Question
      title: Have you received any home care services in the past 12 months, with the cost being entirely or partially covered
        by government?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_hmc_q10
      kind: Question
      title: What type of services have you received? (Mark all that apply. Cost must be entirely or partially covered by
        government.)
      precondition:
      - predicate: q_hmc_q09.outcome == 1
      input:
        control: Checkbox
        labels:
          1: Nursing care
          2: Other health care services
          4: Medical equipment or supplies
          8: Personal care
          16: Housework
          32: Meal preparation or delivery
          64: Shopping
          128: Respite care
          256: Other
    - id: q_hmc_q10s
      kind: Question
      title: Please specify the type of government-covered home care service.
      precondition:
      - predicate: q_hmc_q09.outcome == 1
      - predicate: q_hmc_q10.outcome % 512 >= 256
      input:
        control: Textarea
        placeholder: Specify service type...
        maxLength: 200
  - id: b_private_home_care
    title: Non-Government Home Care
    precondition:
    - predicate: age >= 18
    items:
    - id: q_hmc_q11
      kind: Question
      title: 'Have you received any other home care services in the past 12 months, with the cost not covered by government
        (for example: care provided by a private agency or by a spouse or friends)?'
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_hmc_q12
      kind: Question
      title: Who provided these home care services? (Mark all that apply)
      precondition:
      - predicate: q_hmc_q11.outcome == 1
      input:
        control: Checkbox
        labels:
          1: Nurse from a private agency
          2: Homemaker or other support services from a private agency
          4: Physiotherapist or other therapist from a private agency
          8: Neighbour or friend
          16: Family member or spouse
          32: Volunteer
          64: Other
    - id: q_hmc_q12s
      kind: Question
      title: Please specify the other provider of home care.
      precondition:
      - predicate: q_hmc_q11.outcome == 1
      - predicate: q_hmc_q12.outcome % 128 >= 64
      input:
        control: Textarea
        placeholder: Specify provider...
        maxLength: 200
    - id: q_hmc_q13
      kind: Question
      title: What type of services have you received from your non-government home care providers? (Mark all that apply)
      precondition:
      - predicate: q_hmc_q11.outcome == 1
      input:
        control: Checkbox
        labels:
          1: Nursing care
          2: Other health care services
          4: Medical equipment or supplies
          8: Personal care
          16: Housework
          32: Meal preparation or delivery
          64: Shopping
          128: Respite care
          256: Other
    - id: q_hmc_q13s
      kind: Question
      title: Please specify the other type of service from non-government provider.
      precondition:
      - predicate: q_hmc_q11.outcome == 1
      - predicate: q_hmc_q13.outcome % 512 >= 256
      input:
        control: Textarea
        placeholder: Specify service type...
        maxLength: 200
  - id: b_unmet_home_care
    title: Unmet Home Care Needs
    precondition:
    - predicate: age >= 18
    items:
    - id: q_hmc_q14
      kind: Question
      title: During the past 12 months, was there ever a time when you felt that you needed home care services but you didn't
        receive them?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_hmc_q15
      kind: Question
      title: Thinking of the most recent time, why didn't you get these services? (Mark all that apply)
      precondition:
      - predicate: q_hmc_q14.outcome == 1
      input:
        control: Checkbox
        labels:
          1: Not available in the area
          2: Not available at time required
          4: Waiting time too long
          8: Felt would be inadequate
          16: Cost
          32: Too busy
          64: Didn't get around to it / didn't bother
          128: Didn't know where to go / call
          256: Language problems
          512: Personal or family responsibilities
          1024: Decided not to seek services
          2048: Doctor did not think it was necessary
          4096: Did not qualify / not eligible for homecare
          8192: Still waiting for homecare
          16384: Other
    - id: q_hmc_q15s
      kind: Question
      title: Please specify the reason for not getting home care.
      precondition:
      - predicate: q_hmc_q14.outcome == 1
      - predicate: q_hmc_q15.outcome % 32768 >= 16384
      input:
        control: Textarea
        placeholder: Specify reason...
        maxLength: 200
    - id: q_hmc_q16
      kind: Question
      title: Again, thinking of the most recent time, what type of home care was needed? (Mark all that apply)
      precondition:
      - predicate: q_hmc_q14.outcome == 1
      input:
        control: Checkbox
        labels:
          1: Nursing care
          2: Other health care services
          4: Medical equipment or supplies
          8: Personal care
          16: Housework
          32: Meal preparation or delivery
          64: Shopping
          128: Respite care
          256: Other
    - id: q_hmc_q16s
      kind: Question
      title: Please specify the type of home care needed.
      precondition:
      - predicate: q_hmc_q14.outcome == 1
      - predicate: q_hmc_q16.outcome % 512 >= 256
      input:
        control: Textarea
        placeholder: Specify type of care...
        maxLength: 200
    - id: q_hmc_q17
      kind: Question
      title: Where did you try to get this home care service? (Mark all that apply)
      precondition:
      - predicate: q_hmc_q14.outcome == 1
      input:
        control: Checkbox
        labels:
          1: A government sponsored program
          2: A private agency
          4: A family member, friend or neighbour
          8: A volunteer organization
          16: Other
  - id: b_overall_satisfaction
    title: Overall Health Care Satisfaction
    precondition:
    - predicate: is_proxy == 0
    - predicate: age >= 15
    items:
    - id: q_pas_r1
      kind: Comment
      title: Earlier, I asked about your use of health care services in the past 12 months. Now I'd like to get your opinion
        on the quality of the care you received.
    - id: q_pas_q11
      kind: Question
      title: In the past 12 months, have you received any health care services?
      precondition:
      - predicate: had_health_contact == 0
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_pas_q12
      kind: Question
      title: Overall, how would you rate the quality of the health care you received?
      precondition:
      - predicate: had_health_contact == 1 or q_pas_q11.outcome == 1
      input:
        control: Radio
        labels:
          1: Excellent
          2: Good
          3: Fair
          4: Poor
    - id: q_pas_q13
      kind: Question
      title: Overall, how satisfied were you with the way health care services were provided?
      precondition:
      - predicate: had_health_contact == 1 or q_pas_q11.outcome == 1
      input:
        control: Radio
        labels:
          1: Very satisfied
          2: Somewhat satisfied
          3: Neither satisfied nor dissatisfied
          4: Somewhat dissatisfied
          5: Very dissatisfied
  - id: b_hospital_satisfaction
    title: Hospital Care Satisfaction
    precondition:
    - predicate: is_proxy == 0
    - predicate: age >= 15
    - predicate: had_health_contact == 1 or q_pas_q11.outcome == 1
    items:
    - id: q_pas_q21a
      kind: Question
      title: In the past 12 months, have you received any health care services at a hospital, for any diagnostic or day surgery
        service, overnight stay, or as an emergency room patient?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_pas_q21b
      kind: Question
      title: 'Thinking of your most recent hospital visit, were you:'
      precondition:
      - predicate: q_pas_q21a.outcome == 1
      input:
        control: Radio
        labels:
          1: Admitted overnight or longer (inpatient)
          2: Patient at a diagnostic or day surgery clinic (outpatient)
          3: Emergency room patient
    - id: q_pas_q22
      kind: Question
      title: Thinking of this most recent hospital visit, how would you rate the quality of the care you received?
      precondition:
      - predicate: q_pas_q21a.outcome == 1
      input:
        control: Radio
        labels:
          1: Excellent
          2: Good
          3: Fair
          4: Poor
    - id: q_pas_q23
      kind: Question
      title: Thinking of this most recent hospital visit, how satisfied were you with the way hospital services were provided?
      precondition:
      - predicate: q_pas_q21a.outcome == 1
      input:
        control: Radio
        labels:
          1: Very satisfied
          2: Somewhat satisfied
          3: Neither satisfied nor dissatisfied
          4: Somewhat dissatisfied
          5: Very dissatisfied
  - id: b_physician_satisfaction
    title: Physician Care Satisfaction
    precondition:
    - predicate: is_proxy == 0
    - predicate: age >= 15
    - predicate: had_health_contact == 1 or q_pas_q11.outcome == 1
    items:
    - id: q_pas_q31a
      kind: Question
      title: In the past 12 months, not counting hospital visits, have you received any health care services from a family
        doctor or other physician?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_pas_q31b
      kind: Question
      title: 'Thinking of the most recent time, was care provided by:'
      precondition:
      - predicate: q_pas_q31a.outcome == 1
      input:
        control: Radio
        labels:
          1: A family doctor (general practitioner)
          2: A medical specialist
    - id: q_pas_q32
      kind: Question
      title: Thinking of this most recent care from a physician, how would you rate the quality of the care you received?
      precondition:
      - predicate: q_pas_q31a.outcome == 1
      input:
        control: Radio
        labels:
          1: Excellent
          2: Good
          3: Fair
          4: Poor
    - id: q_pas_q33
      kind: Question
      title: Thinking of this most recent care from a physician, how satisfied were you with the way physician care was provided?
      precondition:
      - predicate: q_pas_q31a.outcome == 1
      input:
        control: Radio
        labels:
          1: Very satisfied
          2: Somewhat satisfied
          3: Neither satisfied nor dissatisfied
          4: Somewhat dissatisfied
          5: Very dissatisfied
  - id: b_community_satisfaction
    title: Community-Based Care Satisfaction
    precondition:
    - predicate: is_proxy == 0
    - predicate: age >= 15
    - predicate: had_health_contact == 1 or q_pas_q11.outcome == 1
    items:
    - id: q_pas_r2
      kind: Comment
      title: 'The next questions are about community-based health care which includes any health care received outside of
        a hospital or doctor''s office. Examples are: home nursing care, home-based counselling or therapy, personal care
        and community walk-in clinics.'
    - id: q_pas_q41
      kind: Question
      title: In the past 12 months, have you received any community-based care?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_pas_q42
      kind: Question
      title: Overall, how would you rate the quality of the community-based care you received?
      precondition:
      - predicate: q_pas_q41.outcome == 1
      input:
        control: Radio
        labels:
          1: Excellent
          2: Good
          3: Fair
          4: Poor
    - id: q_pas_q43
      kind: Question
      title: Overall, how satisfied were you with the way community-based care was provided?
      precondition:
      - predicate: q_pas_q41.outcome == 1
      input:
        control: Radio
        labels:
          1: Very satisfied
          2: Somewhat satisfied
          3: Neither satisfied nor dissatisfied
          4: Somewhat dissatisfied
          5: Very dissatisfied
  - id: b_telehealth_satisfaction
    title: Telehealth Satisfaction
    precondition:
    - predicate: is_proxy == 0
    - predicate: age >= 15
    items:
    - id: q_pas_q51
      kind: Question
      title: In the past 12 months, have you used a telephone health line or telehealth service?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_pas_q52
      kind: Question
      title: Overall, how would you rate the quality of the service you received?
      precondition:
      - predicate: q_pas_q51.outcome == 1
      input:
        control: Radio
        labels:
          1: Excellent
          2: Good
          3: Fair
          4: Poor
