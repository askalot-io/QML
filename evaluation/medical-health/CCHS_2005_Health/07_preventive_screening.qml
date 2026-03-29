qmlVersion: '1.0'
questionnaire:
  title: 07 Preventive Screening
  codeInit: |
    # Extern variables from prior sections
    is_proxy: {0, 1}
    age: range(12, 120)
    sex: {1, 2}
    # Extern from Health Care Utilization section
    # HCU_Q02B: Number of times seen/talked to eye doctor in past 12 months
    # 0 = not seen, 1-75 = number of consultations
    hcu_q02b_eye_doctor: range(0, 75)
    # HCU_Q02E: Number of times seen/talked to dentist in past 12 months
    # 0 = not seen, 1-99 = number of consultations
    hcu_q02e_dentist: range(0, 99)
  blocks:
  - id: b_flu
    title: Flu Shots
    precondition:
    - predicate: is_proxy == 0
    items:
    - id: q_flu_q160
      kind: Question
      title: Now a few questions about your use of various health care services. Have you ever had a flu shot?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_flu_q162
      kind: Question
      title: When did you have your last flu shot?
      precondition:
      - predicate: q_flu_q160.outcome == 1
      input:
        control: Radio
        labels:
          1: Less than 1 year ago
          2: 1 year to less than 2 years ago
          3: 2 years ago or more
    - id: q_flu_q166
      kind: Question
      title: What are the reasons that you have not had a flu shot in the past year?
      precondition:
      - predicate: q_flu_q160.outcome == 0 or (q_flu_q160.outcome == 1 and q_flu_q162.outcome in [2, 3])
      input:
        control: Checkbox
        labels:
          1: Have not gotten around to it
          2: Respondent did not think it was necessary
          4: Doctor did not think it was necessary
          8: Personal or family responsibilities
          16: Not available at time required
          32: Not available at all in the area
          64: Waiting time was too long
          128: Transportation problems
          256: Language problem
          512: Cost
          1024: Did not know where to go / uninformed
          2048: Fear (e.g., painful, embarrassing, find something wrong)
          4096: Bad reaction to previous shot
          8192: Unable to leave the house because of a health problem
          16384: Other - Specify
    - id: q_flu_q166s
      kind: Question
      title: Please specify the other reason.
      precondition:
      - predicate: q_flu_q166.outcome % 32768 >= 16384
      input:
        control: Textarea
        placeholder: Specify...
        maxLength: 200
  - id: b_bpc
    title: Blood Pressure Check
    precondition:
    - predicate: is_proxy == 0
    items:
    - id: q_bpc_q010
      kind: Question
      title: Have you ever had your blood pressure taken?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_bpc_q012
      kind: Question
      title: When was the last time?
      precondition:
      - predicate: q_bpc_q010.outcome == 1
      input:
        control: Radio
        labels:
          1: Less than 6 months ago
          2: 6 months to less than 1 year ago
          3: 1 year to less than 2 years ago
          4: 2 years to less than 5 years ago
          5: 5 or more years ago
    - id: q_bpc_q016
      kind: Question
      title: What are the reasons that you have not had your blood pressure taken in the past 2 years?
      precondition:
      - predicate: age >= 25
      - predicate: q_bpc_q010.outcome == 0 or (q_bpc_q010.outcome == 1 and q_bpc_q012.outcome in [4, 5])
      input:
        control: Checkbox
        labels:
          1: Have not gotten around to it
          2: Respondent did not think it was necessary
          4: Doctor did not think it was necessary
          8: Personal or family responsibilities
          16: Not available at time required
          32: Not available at all in the area
          64: Waiting time was too long
          128: Transportation problems
          256: Language problem
          512: Cost
          1024: Did not know where to go / uninformed
          2048: Fear (e.g., painful, embarrassing, find something wrong)
          4096: Unable to leave the house because of a health problem
          8192: Other - Specify
    - id: q_bpc_q016s
      kind: Question
      title: Please specify the other reason.
      precondition:
      - predicate: q_bpc_q016.outcome % 16384 >= 8192
      input:
        control: Textarea
        placeholder: Specify...
        maxLength: 200
  - id: b_pap
    title: Pap Smear Test
    precondition:
    - predicate: is_proxy == 0
    - predicate: sex == 2
    - predicate: age >= 18
    items:
    - id: q_pap_q020
      kind: Question
      title: Have you ever had a PAP smear test?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_pap_q022
      kind: Question
      title: When was the last time?
      precondition:
      - predicate: q_pap_q020.outcome == 1
      input:
        control: Radio
        labels:
          1: Less than 6 months ago
          2: 6 months to less than 1 year ago
          3: 1 year to less than 3 years ago
          4: 3 years to less than 5 years ago
          5: 5 or more years ago
    - id: q_pap_q026
      kind: Question
      title: What are the reasons that you have not had a PAP smear test in the past 3 years?
      precondition:
      - predicate: q_pap_q020.outcome == 0 or (q_pap_q020.outcome == 1 and q_pap_q022.outcome in [4, 5])
      input:
        control: Checkbox
        labels:
          1: Have not gotten around to it
          2: Respondent did not think it was necessary
          4: Doctor did not think it was necessary
          8: Personal or family responsibilities
          16: Not available at time required
          32: Not available at all in the area
          64: Waiting time was too long
          128: Transportation problems
          256: Language problem
          512: Cost
          1024: Did not know where to go / uninformed
          2048: Fear (e.g., painful, embarrassing, find something wrong)
          4096: Have had a hysterectomy
          8192: Hate / dislike having one done
          16384: Unable to leave the house because of a health problem
          32768: Other - Specify
    - id: q_pap_q026s
      kind: Question
      title: Please specify the other reason.
      precondition:
      - predicate: q_pap_q026.outcome % 65536 >= 32768
      input:
        control: Textarea
        placeholder: Specify...
        maxLength: 200
  - id: b_mam
    title: Mammography
    precondition:
    - predicate: is_proxy == 0
    - predicate: sex == 2
    items:
    - id: q_mam_q030
      kind: Question
      title: Have you ever had a mammogram, that is, a breast x-ray?
      precondition:
      - predicate: age >= 35
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_mam_q031
      kind: Question
      title: Why did you have it?
      precondition:
      - predicate: q_mam_q030.outcome == 1
      input:
        control: Checkbox
        labels:
          1: Family history of breast cancer
          2: Part of regular check-up / routine screening
          4: Age
          8: Previously detected lump
          16: Follow-up of breast cancer treatment
          32: On hormone replacement therapy
          64: Breast problem
          128: Other - Specify
    - id: q_mam_q031s
      kind: Question
      title: Please specify the other reason.
      precondition:
      - predicate: q_mam_q031.outcome % 256 >= 128
      input:
        control: Textarea
        placeholder: Specify...
        maxLength: 200
    - id: q_mam_q032
      kind: Question
      title: When was the last time?
      precondition:
      - predicate: q_mam_q030.outcome == 1
      input:
        control: Radio
        labels:
          1: Less than 6 months ago
          2: 6 months to less than 1 year ago
          3: 1 year to less than 2 years ago
          4: 2 years to less than 5 years ago
          5: 5 or more years ago
    - id: q_mam_q036
      kind: Question
      title: What are the reasons you have not had one in the past 2 years?
      precondition:
      - predicate: age >= 50 and age <= 69
      - predicate: q_mam_q030.outcome == 0 or (q_mam_q030.outcome == 1 and q_mam_q032.outcome in [4, 5])
      input:
        control: Checkbox
        labels:
          1: Have not gotten around to it
          2: Respondent did not think it was necessary
          4: Doctor did not think it was necessary
          8: Personal or family responsibilities
          16: Not available at time required
          32: Not available at all in the area
          64: Waiting time was too long
          128: Transportation problems
          256: Language problem
          512: Cost
          1024: Did not know where to go / uninformed
          2048: Fear (e.g., painful, embarrassing, find something wrong)
          4096: Unable to leave the house because of a health problem
          8192: Breasts removed / Mastectomy
          16384: Other - Specify
    - id: q_mam_q036s
      kind: Question
      title: Please specify the other reason.
      precondition:
      - predicate: q_mam_q036.outcome % 32768 >= 16384
      input:
        control: Textarea
        placeholder: Specify...
        maxLength: 200
    - id: q_mam_q037
      kind: Question
      title: It is important to know when analyzing health whether or not the person is pregnant. Are you pregnant?
      precondition:
      - predicate: age >= 15 and age <= 49
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_mam_q038
      kind: Question
      title: Have you had a hysterectomy? (In other words, has your uterus been removed?)
      precondition:
      - predicate: age >= 18
      - predicate: q_pap_q026.outcome % 8192 < 4096
      - predicate: q_mam_q037.outcome == 0 or age > 49 or age < 15
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
  - id: b_brx
    title: Breast Examinations
    precondition:
    - predicate: is_proxy == 0
    - predicate: sex == 2
    - predicate: age >= 18
    items:
    - id: q_brx_q110
      kind: Question
      title: Other than a mammogram, have you ever had your breasts examined for lumps (tumours, cysts) by a doctor or other
        health professional?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_brx_q112
      kind: Question
      title: When was the last time?
      precondition:
      - predicate: q_brx_q110.outcome == 1
      input:
        control: Radio
        labels:
          1: Less than 6 months ago
          2: 6 months to less than 1 year ago
          3: 1 year to less than 2 years ago
          4: 2 years to less than 5 years ago
          5: 5 or more years ago
    - id: q_brx_q116
      kind: Question
      title: What are the reasons that you have not had a breast exam in the past 2 years?
      precondition:
      - predicate: q_brx_q110.outcome == 0 or (q_brx_q110.outcome == 1 and q_brx_q112.outcome in [4, 5])
      input:
        control: Checkbox
        labels:
          1: Have not gotten around to it
          2: Respondent did not think it was necessary
          4: Doctor did not think it was necessary
          8: Personal or family responsibilities
          16: Not available at time required
          32: Not available at all in the area
          64: Waiting time was too long
          128: Transportation problems
          256: Language problem
          512: Cost
          1024: Did not know where to go / uninformed
          2048: Fear (e.g., painful, embarrassing, find something wrong)
          4096: Unable to leave the house because of a health problem
          8192: Breasts removed / mastectomy
          16384: Other - Specify
    - id: q_brx_q116s
      kind: Question
      title: Please specify the other reason.
      precondition:
      - predicate: q_brx_q116.outcome % 32768 >= 16384
      input:
        control: Textarea
        placeholder: Specify...
        maxLength: 200
  - id: b_bsx
    title: Breast Self-Examinations
    precondition:
    - predicate: is_proxy == 0
    - predicate: sex == 2
    - predicate: age >= 18
    items:
    - id: q_bsx_q120
      kind: Question
      title: Have you ever examined your breasts for lumps (tumours, cysts)?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_bsx_q121
      kind: Question
      title: How often?
      precondition:
      - predicate: q_bsx_q120.outcome == 1
      input:
        control: Radio
        labels:
          1: At least once a month
          2: Once every 2 to 3 months
          3: Less often than every 2 to 3 months
    - id: q_bsx_q122
      kind: Question
      title: How did you learn to do this?
      precondition:
      - predicate: q_bsx_q120.outcome == 1
      input:
        control: Checkbox
        labels:
          1: Doctor
          2: Nurse
          4: Book / magazine / pamphlet
          8: TV / video / film
          16: Family member (e.g., mother, sister, cousin)
          32: Other - Specify
    - id: q_bsx_q122s
      kind: Question
      title: Please specify the other source.
      precondition:
      - predicate: q_bsx_q122.outcome % 64 >= 32
      input:
        control: Textarea
        placeholder: Specify...
        maxLength: 200
  - id: b_eyx
    title: Eye Examinations
    precondition:
    - predicate: is_proxy == 0
    items:
    - id: q_eyx_q140
      kind: Question
      title: It was reported earlier that you have seen or talked to an optometrist or ophthalmologist in the past 12 months.
        Did you actually visit one?
      precondition:
      - predicate: hcu_q02b_eye_doctor >= 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_eyx_q142
      kind: Question
      title: When did you last have an eye examination?
      input:
        control: Radio
        labels:
          1: Less than 1 year ago
          2: 1 year to less than 2 years ago
          3: 2 years to less than 3 years ago
          4: 3 or more years ago
          5: Never
    - id: q_eyx_q146
      kind: Question
      title: What are the reasons that you have not had an eye examination in the past 2 years?
      precondition:
      - predicate: q_eyx_q142.outcome in [3, 4, 5]
      input:
        control: Checkbox
        labels:
          1: Have not gotten around to it
          2: Respondent did not think it was necessary
          4: Doctor did not think it was necessary
          8: Personal or family responsibilities
          16: Not available at time required
          32: Not available at all in the area
          64: Waiting time was too long
          128: Transportation problems
          256: Language problem
          512: Cost
          1024: Did not know where to go / uninformed
          2048: Fear (e.g., painful, embarrassing, find something wrong)
          4096: Unable to leave the house because of a health problem
          8192: Other - Specify
    - id: q_eyx_q146s
      kind: Question
      title: Please specify the other reason.
      precondition:
      - predicate: q_eyx_q146.outcome % 16384 >= 8192
      input:
        control: Textarea
        placeholder: Specify...
        maxLength: 200
  - id: b_pcu
    title: Physical Check-Up
    precondition:
    - predicate: is_proxy == 0
    items:
    - id: q_pcu_q150
      kind: Question
      title: Have you ever had a physical check-up without having a specific health problem?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_pcu_q151
      kind: Question
      title: Have you ever had one during a visit for a health problem?
      precondition:
      - predicate: q_pcu_q150.outcome == 0
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_pcu_q152
      kind: Question
      title: When was the last time?
      precondition:
      - predicate: q_pcu_q150.outcome == 1 or q_pcu_q151.outcome == 1
      input:
        control: Radio
        labels:
          1: Less than 1 year ago
          2: 1 year to less than 2 years ago
          3: 2 years to less than 3 years ago
          4: 3 years to less than 4 years ago
          5: 4 years to less than 5 years ago
          6: 5 or more years ago
    - id: q_pcu_q156
      kind: Question
      title: What are the reasons that you have not had a check-up in the past 3 years?
      precondition:
      - predicate: (q_pcu_q150.outcome == 0 and q_pcu_q151.outcome == 0) or q_pcu_q152.outcome in [4, 5, 6]
      input:
        control: Checkbox
        labels:
          1: Have not gotten around to it
          2: Respondent did not think it was necessary
          4: Doctor did not think it was necessary
          8: Personal or family responsibilities
          16: Not available at time required
          32: Not available at all in the area
          64: Waiting time was too long
          128: Transportation problems
          256: Language problem
          512: Cost
          1024: Did not know where to go / uninformed
          2048: Fear (e.g., painful, embarrassing, find something wrong)
          4096: Unable to leave the house because of a health problem
          8192: Other - Specify
    - id: q_pcu_q156s
      kind: Question
      title: Please specify the other reason.
      precondition:
      - predicate: q_pcu_q156.outcome % 16384 >= 8192
      input:
        control: Textarea
        placeholder: Specify...
        maxLength: 200
  - id: b_psa
    title: Prostate Cancer Screening
    precondition:
    - predicate: is_proxy == 0
    - predicate: sex == 1
    - predicate: age >= 35
    items:
    - id: q_psa_q170
      kind: Question
      title: Have you ever had a prostate specific antigen test for prostate cancer, that is, a PSA blood test?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_psa_q172
      kind: Question
      title: When was the last time?
      precondition:
      - predicate: q_psa_q170.outcome == 1
      input:
        control: Radio
        labels:
          1: Less than 1 year ago
          2: 1 year to less than 2 years ago
          3: 2 years to less than 3 years ago
          4: 3 years to less than 5 years ago
          5: 5 or more years ago
    - id: q_psa_q173
      kind: Question
      title: Why did you have it?
      precondition:
      - predicate: q_psa_q170.outcome == 1
      input:
        control: Checkbox
        labels:
          1: Family history of prostate cancer
          2: Part of regular check-up / routine screening
          4: Age
          8: Race
          16: Follow-up of problem
          32: Follow-up of prostate cancer treatment
          64: Other - Specify
    - id: q_psa_q173s
      kind: Question
      title: Please specify the other reason.
      precondition:
      - predicate: q_psa_q173.outcome % 128 >= 64
      input:
        control: Textarea
        placeholder: Specify...
        maxLength: 200
    - id: q_psa_q174
      kind: Question
      title: A Digital Rectal Exam is an exam in which a gloved finger is inserted into the rectum in order to feel the prostate
        gland. Have you ever had this exam?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_psa_q175
      kind: Question
      title: When was the last time?
      precondition:
      - predicate: q_psa_q174.outcome == 1
      input:
        control: Radio
        labels:
          1: Less than 1 year ago
          2: 1 year to less than 2 years ago
          3: 2 years to less than 3 years ago
          4: 3 years to less than 5 years ago
          5: 5 or more years ago
  - id: b_ccs
    title: Colorectal Cancer Screening
    precondition:
    - predicate: is_proxy == 0
    - predicate: age >= 35
    items:
    - id: q_ccs_q180
      kind: Question
      title: An FOBT is a test to check for blood in your stool, where you have a bowel movement and use a stick to smear
        a small sample on a special card. Have you ever had this test?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_ccs_q182
      kind: Question
      title: When was the last time?
      precondition:
      - predicate: q_ccs_q180.outcome == 1
      input:
        control: Radio
        labels:
          1: Less than 1 year ago
          2: 1 year to less than 2 years ago
          3: 2 years to less than 3 years ago
          4: 3 years to less than 5 years ago
          5: 5 years to less than 10 years ago
          6: 10 or more years ago
    - id: q_ccs_q183
      kind: Question
      title: Why did you have it?
      precondition:
      - predicate: q_ccs_q180.outcome == 1
      input:
        control: Checkbox
        labels:
          1: Family history of colorectal cancer
          2: Part of regular check-up / routine screening
          4: Age
          8: Race
          16: Follow-up of problem
          32: Follow-up of colorectal cancer treatment
          64: Other - Specify
    - id: q_ccs_q183s
      kind: Question
      title: Please specify the other reason.
      precondition:
      - predicate: q_ccs_q183.outcome % 128 >= 64
      input:
        control: Textarea
        placeholder: Specify...
        maxLength: 200
    - id: q_ccs_q184
      kind: Question
      title: A colonoscopy or sigmoidoscopy is when a tube is inserted into the rectum to view the bowel for early signs of
        cancer and other health problems. Have you ever had either of these exams?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_ccs_q185
      kind: Question
      title: When was the last time?
      precondition:
      - predicate: q_ccs_q184.outcome == 1
      input:
        control: Radio
        labels:
          1: Less than 1 year ago
          2: 1 year to less than 2 years ago
          3: 2 years to less than 3 years ago
          4: 3 years to less than 5 years ago
          5: 5 years to less than 10 years ago
          6: 10 or more years ago
    - id: q_ccs_q186
      kind: Question
      title: Why did you have it?
      precondition:
      - predicate: q_ccs_q184.outcome == 1
      input:
        control: Checkbox
        labels:
          1: Family history of colorectal cancer
          2: Part of regular check-up / routine screening
          4: Age
          8: Race
          16: Follow-up of problem
          32: Follow-up of colorectal cancer treatment
          64: Other - Specify
    - id: q_ccs_q186s
      kind: Question
      title: Please specify the other reason.
      precondition:
      - predicate: q_ccs_q186.outcome % 128 >= 64
      input:
        control: Textarea
        placeholder: Specify...
        maxLength: 200
    - id: q_ccs_q187
      kind: Question
      title: Was the colonoscopy or sigmoidoscopy a follow-up of the results of an FOBT?
      precondition:
      - predicate: q_ccs_q180.outcome == 1
      - predicate: q_ccs_q184.outcome == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
  - id: b_den
    title: Dental Visits
    precondition:
    - predicate: is_proxy == 0
    items:
    - id: q_den_q130
      kind: Question
      title: Now dental visits. It was reported earlier that you have seen or talked to a dentist in the past 12 months. Did
        you actually visit one?
      precondition:
      - predicate: hcu_q02e_dentist >= 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_den_r132
      kind: Comment
      title: Now dental visits.
      precondition:
      - predicate: hcu_q02e_dentist == 0
    - id: q_den_q132
      kind: Question
      title: When was the last time that you went to a dentist?
      precondition:
      - predicate: hcu_q02e_dentist == 0 or q_den_q130.outcome == 0
      input:
        control: Radio
        labels:
          1: Less than 1 year ago
          2: 1 year to less than 2 years ago
          3: 2 years to less than 3 years ago
          4: 3 years to less than 4 years ago
          5: 4 years to less than 5 years ago
          6: 5 or more years ago
          7: Never
    - id: q_den_q136
      kind: Question
      title: What are the reasons that you have not been to a dentist in the past 3 years?
      precondition:
      - predicate: q_den_q132.outcome in [4, 5, 6, 7]
      input:
        control: Checkbox
        labels:
          1: Have not gotten around to it
          2: Respondent did not think it was necessary
          4: Dentist did not think it was necessary
          8: Personal or family responsibilities
          16: Not available at time required
          32: Not available at all in the area
          64: Waiting time was too long
          128: Transportation problems
          256: Language problem
          512: Cost
          1024: Did not know where to go / uninformed
          2048: Fear (e.g., painful, embarrassing, find something wrong)
          4096: Wears dentures
          8192: Unable to leave the house because of a health problem
          16384: Other - Specify
    - id: q_den_q136s
      kind: Question
      title: Please specify the other reason.
      precondition:
      - predicate: q_den_q136.outcome % 32768 >= 16384
      input:
        control: Textarea
        placeholder: Specify...
        maxLength: 200
