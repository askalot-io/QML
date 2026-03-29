qmlVersion: '1.0'
questionnaire:
  title: 20 Administration
  codeInit: |
    # Extern variables from prior sections
    is_proxy: {0, 1}
    # Track weight measurement path
    weight_measured = 0
    weight_permission = 0
    height_impossible = 0
    # No extern variables needed for this section
  blocks:
  - id: b_weight_measurement
    title: Weight Measurement
    precondition:
    - predicate: is_proxy == 0
    items:
    - id: q_mhw_n1a
      kind: Question
      title: 'INTERVIEWER: Are there any reasons that make it impossible to measure the respondent''s weight?'
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
      codeBlock: |
        if q_mhw_n1a.outcome == 0:
            weight_measured = 1
    - id: q_mhw_n1b
      kind: Question
      title: 'INTERVIEWER: Select reasons why it is impossible to measure the respondent''s weight.'
      precondition:
      - predicate: q_mhw_n1a.outcome == 1
      input:
        control: Checkbox
        labels:
          1: Unable to stand unassisted
          2: In a wheelchair
          4: Bedridden
          8: Interview setting
          16: Safety concerns
          32: Has already refused to be measured
          64: Other - Specify
      codeBlock: |
        if q_mhw_n1b.outcome % 8 >= 1:
            height_impossible = 1
    - id: q_mhw_s1b
      kind: Question
      title: 'INTERVIEWER: Specify the reason.'
      precondition:
      - predicate: q_mhw_n1a.outcome == 1
      - predicate: q_mhw_n1b.outcome % 128 >= 64
      input:
        control: Textarea
        placeholder: Specify reason...
        maxLength: 200
    - id: q_mhw_r2
      kind: Comment
      title: A person's size is important in understanding health. Because of this, I would like to measure your height and
        weight. The measurements taken will not require any touching.
      precondition:
      - predicate: q_mhw_n1a.outcome == 0
    - id: q_mhw_q2a
      kind: Question
      title: Do I have your permission to measure your weight?
      precondition:
      - predicate: q_mhw_n1a.outcome == 0
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
      codeBlock: |
        if q_mhw_q2a.outcome == 1:
            weight_permission = 1
    - id: q_mhw_n2a
      kind: Question
      title: 'INTERVIEWER: Record weight to the nearest 0.01 kg.'
      precondition:
      - predicate: q_mhw_n1a.outcome == 0
      - predicate: q_mhw_q2a.outcome == 1
      input:
        control: Editbox
        min: 1
        max: 261
        right: kg
    - id: q_mhw_n3a
      kind: Question
      title: 'INTERVIEWER: Were there any articles of clothing or physical characteristics which affected the accuracy of
        this measurement?'
      precondition:
      - predicate: q_mhw_n1a.outcome == 0
      - predicate: q_mhw_q2a.outcome == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_mhw_n3b
      kind: Question
      title: 'INTERVIEWER: Select reasons affecting accuracy.'
      precondition:
      - predicate: q_mhw_n1a.outcome == 0
      - predicate: q_mhw_q2a.outcome == 1
      - predicate: q_mhw_n3a.outcome == 1
      input:
        control: Checkbox
        labels:
          1: Shoes or boots
          2: Heavy sweater or jacket
          4: Jewellery
          8: Other - Specify
    - id: q_mhw_s3b
      kind: Question
      title: 'INTERVIEWER: Specify.'
      precondition:
      - predicate: q_mhw_n1a.outcome == 0
      - predicate: q_mhw_q2a.outcome == 1
      - predicate: q_mhw_n3a.outcome == 1
      - predicate: q_mhw_n3b.outcome % 16 >= 8
      input:
        control: Textarea
        placeholder: Specify reason...
        maxLength: 200
  - id: b_height_measurement
    title: Height Measurement
    precondition:
    - predicate: is_proxy == 0
    items:
    - id: q_mhw_n5a
      kind: Question
      title: 'INTERVIEWER: Are there any reasons that make it impossible to measure the respondent''s height?'
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_mhw_n5b
      kind: Question
      title: 'INTERVIEWER: Select reasons why it is impossible to measure the respondent''s height.'
      precondition:
      - predicate: q_mhw_n5a.outcome == 1
      input:
        control: Checkbox
        labels:
          1: Too tall
          2: Interview setting
          4: Safety concerns
          8: Has already refused to be measured
          16: Other - Specify
    - id: q_mhw_s5b
      kind: Question
      title: 'INTERVIEWER: Specify.'
      precondition:
      - predicate: q_mhw_n5a.outcome == 1
      - predicate: q_mhw_n5b.outcome % 32 >= 16
      input:
        control: Textarea
        placeholder: Specify reason...
        maxLength: 200
    - id: q_mhw_r6
      kind: Comment
      title: A person's size is important in understanding health. Because of this, I would like to measure your height. The
        measurement will not require any touching.
      precondition:
      - predicate: q_mhw_n5a.outcome == 0
      - predicate: q_mhw_n1a.outcome == 1
    - id: q_mhw_q6a
      kind: Question
      title: Do I have your permission to measure your height?
      precondition:
      - predicate: q_mhw_n5a.outcome == 0
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_mhw_n6b
      kind: Question
      title: 'INTERVIEWER: Enter height to nearest 0.5 cm.'
      precondition:
      - predicate: q_mhw_n5a.outcome == 0
      - predicate: q_mhw_q6a.outcome == 1
      input:
        control: Editbox
        min: 90
        max: 250
        right: cm
    - id: q_mhw_n7a
      kind: Question
      title: 'INTERVIEWER: Were there any articles of clothing or physical characteristics which affected the accuracy of
        this measurement?'
      precondition:
      - predicate: q_mhw_n5a.outcome == 0
      - predicate: q_mhw_q6a.outcome == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_mhw_n7b
      kind: Question
      title: 'INTERVIEWER: Select reasons affecting accuracy.'
      precondition:
      - predicate: q_mhw_n5a.outcome == 0
      - predicate: q_mhw_q6a.outcome == 1
      - predicate: q_mhw_n7a.outcome == 1
      input:
        control: Checkbox
        labels:
          1: Shoes or boots
          2: Hairstyle
          4: Hat
          8: Other - Specify
    - id: q_mhw_s7b
      kind: Question
      title: 'INTERVIEWER: Specify.'
      precondition:
      - predicate: q_mhw_n5a.outcome == 0
      - predicate: q_mhw_q6a.outcome == 1
      - predicate: q_mhw_n7a.outcome == 1
      - predicate: q_mhw_n7b.outcome % 16 >= 8
      input:
        control: Textarea
        placeholder: Specify reason...
        maxLength: 200
  - id: b_data_linkage
    title: Data Linkage Consent
    items:
    - id: q_adm_q01a
      kind: Comment
      title: Statistics Canada and your provincial or territorial ministry of health would like your permission to link information
        collected during this interview to your health records. This linked information could help improve our understanding
        of health issues.
    - id: q_adm_q01b
      kind: Question
      title: This linked information will be kept confidential and used only for statistical purposes. Do we have your permission?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_adm_q03a
      kind: Question
      title: Do you have a provincial or territorial health number?
      precondition:
      - predicate: q_adm_q01b.outcome == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_adm_q03b
      kind: Question
      title: For which province or territory is your health number?
      precondition:
      - predicate: q_adm_q01b.outcome == 1
      - predicate: q_adm_q03a.outcome == 1
      input:
        control: Dropdown
        labels:
          1: Newfoundland and Labrador
          2: Prince Edward Island
          3: Nova Scotia
          4: New Brunswick
          5: Quebec
          6: Ontario
          7: Manitoba
          8: Saskatchewan
          9: Alberta
          10: British Columbia
          11: Yukon
          12: Northwest Territories
          13: Nunavut
    - id: q_adm_hn
      kind: Question
      title: What is your health number?
      precondition:
      - predicate: q_adm_q01b.outcome == 1
      - predicate: q_adm_q03a.outcome == 1
      input:
        control: Textarea
        placeholder: Enter health number...
        maxLength: 12
  - id: b_data_sharing
    title: Data Sharing Consent
    items:
    - id: q_adm_q04a
      kind: Comment
      title: Statistics Canada would like your permission to share the information collected in this survey with provincial
        and territorial ministries of health and the Public Health Agency of Canada. This information will allow them to better
        understand issues affecting the health of Canadians.
    - id: q_adm_q04b
      kind: Question
      title: All information will be kept confidential and used only for statistical purposes. Do you agree to share the information
        provided?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
