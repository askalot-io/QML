qmlVersion: '1.0'
questionnaire:
  title: 16 Access Waiting
  codeInit: |
    # Extern variables from earlier sections
    age: range(15, 120)
    sex: {1, 2}
    is_proxy: {0, 1}
  blocks:
  - id: b_specialist_care
    title: Specialist Care
    items:
    - id: q_acc_qint10
      kind: Comment
      title: The next questions are about the use of various health care services. I will start by asking about your experiences
        getting health care from a medical specialist.
    - id: q_acc_q10
      kind: Question
      title: In the past 12 months, did you require a visit to a medical specialist for a diagnosis or a consultation?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_acc_q11
      kind: Question
      title: In the past 12 months, did you ever experience any difficulties getting the specialist care you needed for a
        diagnosis or consultation?
      precondition:
      - predicate: q_acc_q10.outcome == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_acc_q12
      kind: Question
      title: What type of difficulties did you experience? (Mark all that apply)
      precondition:
      - predicate: q_acc_q10.outcome == 1
      - predicate: q_acc_q11.outcome == 1
      input:
        control: Checkbox
        labels:
          1: Difficulty getting a referral
          2: Difficulty getting an appointment
          4: No specialists in the area
          8: Waited too long - between booking appointment and visit
          16: Waited too long - to see the doctor (i.e. in-office waiting)
          32: Transportation problems
          64: Language problem
          128: Cost
          256: Personal or family responsibilities
          512: General deterioration of health
          1024: Appointment cancelled or deferred by specialist
          2048: Still waiting for visit
          4096: Unable to leave the house because of a health problem
          8192: Other
    - id: q_acc_q12s
      kind: Question
      title: Please specify the other difficulty you experienced getting specialist care.
      precondition:
      - predicate: q_acc_q10.outcome == 1
      - predicate: q_acc_q11.outcome == 1
      - predicate: q_acc_q12.outcome % 16384 >= 8192
      input:
        control: Textarea
        placeholder: Specify other difficulty...
        maxLength: 200
  - id: b_surgery
    title: Non-Emergency Surgery
    items:
    - id: q_acc_qint20
      kind: Comment
      title: The following questions are about any surgery not provided in an emergency.
    - id: q_acc_q20
      kind: Question
      title: In the past 12 months, did you require any non-emergency surgery?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_acc_q21
      kind: Question
      title: In the past 12 months, did you ever experience any difficulties getting the surgery you needed?
      precondition:
      - predicate: q_acc_q20.outcome == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_acc_q22
      kind: Question
      title: What type of difficulties did you experience? (Mark all that apply)
      precondition:
      - predicate: q_acc_q20.outcome == 1
      - predicate: q_acc_q21.outcome == 1
      input:
        control: Checkbox
        labels:
          1: Difficulty getting an appointment with a surgeon
          2: Difficulty getting a diagnosis
          4: Waited too long - for a diagnostic test
          8: Waited too long - for a hospital bed to become available
          16: Waited too long - for surgery
          32: Service not available in the area
          64: Transportation problems
          128: Language problem
          256: Cost
          512: Personal or family responsibilities
          1024: General deterioration of health
          2048: Appointment cancelled or deferred by surgeon or hospital
          4096: Still waiting for surgery
          8192: Unable to leave the house because of a health problem
          16384: Other
    - id: q_acc_q22s
      kind: Question
      title: Please specify the other difficulty you experienced getting surgery.
      precondition:
      - predicate: q_acc_q20.outcome == 1
      - predicate: q_acc_q21.outcome == 1
      - predicate: q_acc_q22.outcome % 32768 >= 16384
      input:
        control: Textarea
        placeholder: Specify other difficulty...
        maxLength: 200
  - id: b_diagnostic_tests
    title: Diagnostic Tests (MRI, CAT Scan, Angiography)
    items:
    - id: q_acc_qint30
      kind: Comment
      title: Now some questions about MRIs, CAT Scans and angiographies provided in a non-emergency situation.
    - id: q_acc_q30
      kind: Question
      title: In the past 12 months, did you require one of these tests?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_acc_q31
      kind: Question
      title: In the past 12 months, did you ever experience any difficulties getting the tests you needed?
      precondition:
      - predicate: q_acc_q30.outcome == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_acc_q32
      kind: Question
      title: What type of difficulties did you experience? (Mark all that apply)
      precondition:
      - predicate: q_acc_q30.outcome == 1
      - predicate: q_acc_q31.outcome == 1
      input:
        control: Checkbox
        labels:
          1: Difficulty getting a referral
          2: Difficulty getting an appointment
          4: Waited too long - to get an appointment
          8: Waited too long - to get test (i.e. in-office waiting)
          16: Service not available at time required
          32: Service not available in the area
          64: Transportation problems
          128: Language problem
          256: Cost
          512: General deterioration of health
          1024: Did not know where to go (i.e. information problems)
          2048: Still waiting for test
          4096: Unable to leave the house because of a health problem
          8192: Other
    - id: q_acc_q32s
      kind: Question
      title: Please specify the other difficulty you experienced getting the diagnostic test.
      precondition:
      - predicate: q_acc_q30.outcome == 1
      - predicate: q_acc_q31.outcome == 1
      - predicate: q_acc_q32.outcome % 16384 >= 8192
      input:
        control: Textarea
        placeholder: Specify other difficulty...
        maxLength: 200
  - id: b_health_info
    title: Health Information and Advice
    items:
    - id: q_acc_qint40
      kind: Comment
      title: Now I'd like you to think about yourself and family members living in your dwelling. The next questions are about
        your experiences getting health information or advice.
    - id: q_acc_q40
      kind: Question
      title: In the past 12 months, have you required health information or advice for yourself or a family member?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_acc_q40a
      kind: Question
      title: Who did you contact when you needed health information or advice for yourself or a family member? (Mark all that
        apply)
      precondition:
      - predicate: q_acc_q40.outcome == 1
      input:
        control: Checkbox
        labels:
          1: Doctor's office
          2: Community health centre / CLSC
          4: Walk-in clinic
          8: Telephone health line
          16: Hospital emergency room
          32: Other hospital service
          64: Other
    - id: q_acc_q40as
      kind: Question
      title: Please specify the other contact for health information or advice.
      precondition:
      - predicate: q_acc_q40.outcome == 1
      - predicate: q_acc_q40a.outcome % 128 >= 64
      input:
        control: Textarea
        placeholder: Specify other contact...
        maxLength: 200
    - id: q_acc_q41
      kind: Question
      title: In the past 12 months, did you ever experience any difficulties getting the health information or advice you
        needed for yourself or a family member?
      precondition:
      - predicate: q_acc_q40.outcome == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_acc_q42
      kind: Question
      title: Did you experience difficulties during 'regular' office hours (that is, 9:00 am to 5:00 pm, Monday to Friday)?
      precondition:
      - predicate: q_acc_q40.outcome == 1
      - predicate: q_acc_q41.outcome == 1
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Not required at this time
    - id: q_acc_q43
      kind: Question
      title: What type of difficulties did you experience during regular office hours? (Mark all that apply)
      precondition:
      - predicate: q_acc_q40.outcome == 1
      - predicate: q_acc_q41.outcome == 1
      - predicate: q_acc_q42.outcome == 1
      input:
        control: Checkbox
        labels:
          1: Difficulty contacting a physician or nurse
          2: Did not have a phone number
          4: Could not get through (i.e. no answer)
          8: Waited too long to speak to someone
          16: Did not get adequate info or advice
          32: Language problem
          64: Did not know where to go / call / uninformed
          128: Unable to leave the house because of a health problem
          256: Other
    - id: q_acc_q43s
      kind: Question
      title: Please specify the other difficulty during regular office hours.
      precondition:
      - predicate: q_acc_q40.outcome == 1
      - predicate: q_acc_q41.outcome == 1
      - predicate: q_acc_q42.outcome == 1
      - predicate: q_acc_q43.outcome % 512 >= 256
      input:
        control: Textarea
        placeholder: Specify other difficulty...
        maxLength: 200
    - id: q_acc_q44
      kind: Question
      title: Did you experience difficulties getting health information or advice during evenings and weekends (that is, 5:00
        to 9:00 pm Monday to Friday, or 9:00 am to 5:00 pm, Saturdays and Sundays)?
      precondition:
      - predicate: q_acc_q40.outcome == 1
      - predicate: q_acc_q41.outcome == 1
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Not required at this time
    - id: q_acc_q45
      kind: Question
      title: What type of difficulties did you experience during evenings and weekends? (Mark all that apply)
      precondition:
      - predicate: q_acc_q40.outcome == 1
      - predicate: q_acc_q41.outcome == 1
      - predicate: q_acc_q44.outcome == 1
      input:
        control: Checkbox
        labels:
          1: Difficulty contacting a physician or nurse
          2: Did not have a phone number
          4: Could not get through (i.e. no answer)
          8: Waited too long to speak to someone
          16: Did not get adequate info or advice
          32: Language problem
          64: Did not know where to go / call / uninformed
          128: Unable to leave the house because of a health problem
          256: Other
    - id: q_acc_q45s
      kind: Question
      title: Please specify the other difficulty during evenings and weekends.
      precondition:
      - predicate: q_acc_q40.outcome == 1
      - predicate: q_acc_q41.outcome == 1
      - predicate: q_acc_q44.outcome == 1
      - predicate: q_acc_q45.outcome % 512 >= 256
      input:
        control: Textarea
        placeholder: Specify other difficulty...
        maxLength: 200
    - id: q_acc_q46
      kind: Question
      title: Did you experience difficulties getting health information or advice during the middle of the night?
      precondition:
      - predicate: q_acc_q40.outcome == 1
      - predicate: q_acc_q41.outcome == 1
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Not required at this time
    - id: q_acc_q47
      kind: Question
      title: What type of difficulties did you experience during the middle of the night? (Mark all that apply)
      precondition:
      - predicate: q_acc_q40.outcome == 1
      - predicate: q_acc_q41.outcome == 1
      - predicate: q_acc_q46.outcome == 1
      input:
        control: Checkbox
        labels:
          1: Difficulty contacting a physician or nurse
          2: Did not have a phone number
          4: Could not get through (i.e. no answer)
          8: Waited too long to speak to someone
          16: Did not get adequate info or advice
          32: Language problem
          64: Did not know where to go / call / uninformed
          128: Unable to leave the house because of a health problem
          256: Other
    - id: q_acc_q47s
      kind: Question
      title: Please specify the other difficulty during the middle of the night.
      precondition:
      - predicate: q_acc_q40.outcome == 1
      - predicate: q_acc_q41.outcome == 1
      - predicate: q_acc_q46.outcome == 1
      - predicate: q_acc_q47.outcome % 512 >= 256
      input:
        control: Textarea
        placeholder: Specify other difficulty...
        maxLength: 200
  - id: b_routine_care
    title: Routine and On-Going Care
    items:
    - id: q_acc_qint50
      kind: Comment
      title: Now some questions about your experiences when you needed health care services for routine or on-going care.
    - id: q_acc_q50a
      kind: Question
      title: Do you have a regular family doctor?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_acc_q50
      kind: Question
      title: In the past 12 months, did you require any routine or on-going care for yourself or a family member?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_acc_q51
      kind: Question
      title: In the past 12 months, did you ever experience any difficulties getting the routine or on-going care you or a
        family member needed?
      precondition:
      - predicate: q_acc_q50.outcome == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_acc_q52
      kind: Question
      title: Did you experience difficulties getting such care during 'regular' office hours (that is, 9:00 am to 5:00 pm,
        Monday to Friday)?
      precondition:
      - predicate: q_acc_q50.outcome == 1
      - predicate: q_acc_q51.outcome == 1
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Not required at this time
    - id: q_acc_q53
      kind: Question
      title: What type of difficulties did you experience during regular hours? (Mark all that apply)
      precondition:
      - predicate: q_acc_q50.outcome == 1
      - predicate: q_acc_q51.outcome == 1
      - predicate: q_acc_q52.outcome == 1
      input:
        control: Checkbox
        labels:
          1: Difficulty contacting a physician
          2: Difficulty getting an appointment
          4: Do not have personal / family physician
          8: Waited too long - to get an appointment
          16: Waited too long - to see the doctor (i.e. in-office waiting)
          32: Service not available at time required
          64: Service not available in the area
          128: Transportation problems
          256: Language problem
          512: Cost
          1024: Did not know where to go (i.e. information problems)
          2048: Unable to leave the house because of a health problem
          4096: Other
    - id: q_acc_q53s
      kind: Question
      title: Please specify the other difficulty during regular hours for routine care.
      precondition:
      - predicate: q_acc_q50.outcome == 1
      - predicate: q_acc_q51.outcome == 1
      - predicate: q_acc_q52.outcome == 1
      - predicate: q_acc_q53.outcome % 8192 >= 4096
      input:
        control: Textarea
        placeholder: Specify other difficulty...
        maxLength: 200
    - id: q_acc_q54
      kind: Question
      title: Did you experience difficulties getting such care during evenings and weekends (that is, 5:00 to 9:00 pm, Monday
        to Friday or 9:00 am to 5:00 pm, Saturdays and Sundays)?
      precondition:
      - predicate: q_acc_q50.outcome == 1
      - predicate: q_acc_q51.outcome == 1
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Not required at this time
    - id: q_acc_q55
      kind: Question
      title: What type of difficulties did you experience during evenings and weekends? (Mark all that apply)
      precondition:
      - predicate: q_acc_q50.outcome == 1
      - predicate: q_acc_q51.outcome == 1
      - predicate: q_acc_q54.outcome == 1
      input:
        control: Checkbox
        labels:
          1: Difficulty contacting a physician
          2: Difficulty getting an appointment
          4: Do not have personal / family physician
          8: Waited too long - to get an appointment
          16: Waited too long - to see the doctor (i.e. in-office waiting)
          32: Service not available at time required
          64: Service not available in the area
          128: Transportation problems
          256: Language problem
          512: Cost
          1024: Did not know where to go (i.e. information problems)
          2048: Unable to leave the house because of a health problem
          4096: Other
    - id: q_acc_q55s
      kind: Question
      title: Please specify the other difficulty during evenings and weekends for routine care.
      precondition:
      - predicate: q_acc_q50.outcome == 1
      - predicate: q_acc_q51.outcome == 1
      - predicate: q_acc_q54.outcome == 1
      - predicate: q_acc_q55.outcome % 8192 >= 4096
      input:
        control: Textarea
        placeholder: Specify other difficulty...
        maxLength: 200
  - id: b_immediate_care
    title: Immediate Care for Minor Health Problem
    items:
    - id: q_acc_qint60
      kind: Comment
      title: The next questions are about situations when you or a family member have needed immediate care for a minor health
        problem.
    - id: q_acc_q60
      kind: Question
      title: In the past 12 months, have you or a family member required immediate health care services for a minor health
        problem?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_acc_q61
      kind: Question
      title: In the past 12 months, did you ever experience any difficulties getting the immediate care needed for a minor
        health problem for yourself or a family member?
      precondition:
      - predicate: q_acc_q60.outcome == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_acc_q62
      kind: Question
      title: Did you experience difficulties getting such care during 'regular' office hours (that is, 9:00 am to 5:00 pm,
        Monday to Friday)?
      precondition:
      - predicate: q_acc_q60.outcome == 1
      - predicate: q_acc_q61.outcome == 1
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Not required at this time
    - id: q_acc_q63
      kind: Question
      title: What type of difficulties did you experience during regular hours? (Mark all that apply)
      precondition:
      - predicate: q_acc_q60.outcome == 1
      - predicate: q_acc_q61.outcome == 1
      - predicate: q_acc_q62.outcome == 1
      input:
        control: Checkbox
        labels:
          1: Difficulty contacting a physician
          2: Difficulty getting an appointment
          4: Do not have personal / family physician
          8: Waited too long - to get an appointment
          16: Waited too long - to see the doctor (i.e. in-office waiting)
          32: Service not available at time required
          64: Service not available in the area
          128: Transportation problems
          256: Language problem
          512: Cost
          1024: Did not know where to go (i.e. information problems)
          2048: Unable to leave the house because of a health problem
          4096: Other
    - id: q_acc_q63s
      kind: Question
      title: Please specify the other difficulty during regular hours for immediate care.
      precondition:
      - predicate: q_acc_q60.outcome == 1
      - predicate: q_acc_q61.outcome == 1
      - predicate: q_acc_q62.outcome == 1
      - predicate: q_acc_q63.outcome % 8192 >= 4096
      input:
        control: Textarea
        placeholder: Specify other difficulty...
        maxLength: 200
    - id: q_acc_q64
      kind: Question
      title: Did you experience difficulties getting such care during evenings and weekends (that is, 5:00 to 9:00 pm, Monday
        to Friday or 9:00 am to 5:00 pm, Saturdays and Sundays)?
      precondition:
      - predicate: q_acc_q60.outcome == 1
      - predicate: q_acc_q61.outcome == 1
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Not required at this time
    - id: q_acc_q65
      kind: Question
      title: What type of difficulties did you experience during evenings and weekends? (Mark all that apply)
      precondition:
      - predicate: q_acc_q60.outcome == 1
      - predicate: q_acc_q61.outcome == 1
      - predicate: q_acc_q64.outcome == 1
      input:
        control: Checkbox
        labels:
          1: Difficulty contacting a physician
          2: Difficulty getting an appointment
          4: Do not have personal / family physician
          8: Waited too long - to get an appointment
          16: Waited too long - to see the doctor (i.e. in-office waiting)
          32: Service not available at time required
          64: Service not available in the area
          128: Transportation problems
          256: Language problem
          512: Cost
          1024: Did not know where to go (i.e. information problems)
          2048: Unable to leave the house because of a health problem
          4096: Other
    - id: q_acc_q65s
      kind: Question
      title: Please specify the other difficulty during evenings and weekends for immediate care.
      precondition:
      - predicate: q_acc_q60.outcome == 1
      - predicate: q_acc_q61.outcome == 1
      - predicate: q_acc_q64.outcome == 1
      - predicate: q_acc_q65.outcome % 8192 >= 4096
      input:
        control: Textarea
        placeholder: Specify other difficulty...
        maxLength: 200
    - id: q_acc_q66
      kind: Question
      title: Did you experience difficulties getting such care during the middle of the night?
      precondition:
      - predicate: q_acc_q60.outcome == 1
      - predicate: q_acc_q61.outcome == 1
      input:
        control: Radio
        labels:
          1: 'Yes'
          2: 'No'
          3: Not required at this time
    - id: q_acc_q67
      kind: Question
      title: What type of difficulties did you experience during the middle of the night? (Mark all that apply)
      precondition:
      - predicate: q_acc_q60.outcome == 1
      - predicate: q_acc_q61.outcome == 1
      - predicate: q_acc_q66.outcome == 1
      input:
        control: Checkbox
        labels:
          1: Difficulty contacting a physician
          2: Difficulty getting an appointment
          4: Do not have personal / family physician
          8: Waited too long - to get an appointment
          16: Waited too long - to see the doctor (i.e. in-office waiting)
          32: Service not available at time required
          64: Service not available in the area
          128: Transportation problems
          256: Language problem
          512: Cost
          1024: Did not know where to go (i.e. information problems)
          2048: Unable to leave the house because of a health problem
          4096: Other
    - id: q_acc_q67s
      kind: Question
      title: Please specify the other difficulty during the middle of the night for immediate care.
      precondition:
      - predicate: q_acc_q60.outcome == 1
      - predicate: q_acc_q61.outcome == 1
      - predicate: q_acc_q66.outcome == 1
      - predicate: q_acc_q67.outcome % 8192 >= 4096
      input:
        control: Textarea
        placeholder: Specify other difficulty...
        maxLength: 200
  - id: b_wtm_intro
    title: Waiting Times Introduction
    precondition:
    - predicate: q_acc_q10.outcome == 1 or q_acc_q20.outcome == 1 or q_acc_q30.outcome == 1
    items:
    - id: q_wtm_qint
      kind: Comment
      title: Now some additional questions about your experiences waiting for health care services.
  - id: b_wtm_specialist
    title: Waiting Times - Specialist Visit
    precondition:
    - predicate: q_acc_q10.outcome == 1
    items:
    - id: q_wtm_q01
      kind: Question
      title: In the past 12 months, did you require a visit to a medical specialist for a diagnosis or a consultation for
        a new illness or condition?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_wtm_q02
      kind: Question
      title: For what type of condition?
      precondition:
      - predicate: q_wtm_q01.outcome == 1
      postcondition:
      - predicate: not (q_wtm_q02.outcome == 8 and sex == 1)
        hint: Gynaecological problems cannot be selected for male respondents.
      input:
        control: Dropdown
        labels:
          1: Heart condition or stroke
          2: Cancer
          3: Asthma or other breathing conditions
          4: Arthritis or rheumatism
          5: Cataract or other eye conditions
          6: Mental health disorder
          7: Skin conditions
          8: Gynaecological problems
          9: Other
    - id: q_wtm_q02s
      kind: Question
      title: Please specify the type of condition.
      precondition:
      - predicate: q_wtm_q01.outcome == 1
      - predicate: q_wtm_q02.outcome == 9
      input:
        control: Textarea
        placeholder: Specify condition...
        maxLength: 200
    - id: q_wtm_q03
      kind: Question
      title: 'Were you referred by:'
      precondition:
      - predicate: q_wtm_q01.outcome == 1
      input:
        control: Radio
        labels:
          1: A family doctor
          2: Another specialist
          3: Another health care provider
          4: Did not require a referral
    - id: q_wtm_q04
      kind: Question
      title: Have you already visited the medical specialist?
      precondition:
      - predicate: q_wtm_q01.outcome == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_wtm_q05
      kind: Question
      title: Thinking about this visit, did you experience any difficulties seeing the specialist?
      precondition:
      - predicate: q_wtm_q01.outcome == 1
      - predicate: q_wtm_q04.outcome == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_wtm_q06
      kind: Question
      title: What type of difficulties did you experience? (Mark all that apply)
      precondition:
      - predicate: q_wtm_q01.outcome == 1
      - predicate: q_wtm_q04.outcome == 1
      - predicate: q_wtm_q05.outcome == 1
      input:
        control: Checkbox
        labels:
          1: Difficulty getting a referral
          2: Difficulty getting an appointment
          4: No specialists in the area
          8: Waited too long - between booking appointment and visit
          16: Waited too long - to see the doctor (in-office waiting)
          32: Transportation problems
          64: Language problem
          128: Cost
          256: Personal or family responsibilities
          512: General deterioration of health
          1024: Appointment cancelled or deferred by specialist
          2048: Unable to leave the house because of a health problem
          4096: Other
    - id: q_wtm_q06s
      kind: Question
      title: Please specify the other difficulty.
      precondition:
      - predicate: q_wtm_q01.outcome == 1
      - predicate: q_wtm_q04.outcome == 1
      - predicate: q_wtm_q05.outcome == 1
      - predicate: q_wtm_q06.outcome % 8192 >= 4096
      input:
        control: Textarea
        placeholder: Specify other difficulty...
        maxLength: 200
    - id: q_wtm_q07a
      kind: Question
      title: How long did you have to wait between when you and your doctor decided you should see a specialist and when you
        actually visited the specialist?
      precondition:
      - predicate: q_wtm_q01.outcome == 1
      - predicate: q_wtm_q04.outcome == 1
      input:
        control: Editbox
        min: 1
        max: 365
        right: (enter amount)
    - id: q_wtm_n07b
      kind: Question
      title: 'Unit of time for the wait:'
      precondition:
      - predicate: q_wtm_q01.outcome == 1
      - predicate: q_wtm_q04.outcome == 1
      input:
        control: Radio
        labels:
          1: Days
          2: Weeks
          3: Months
    - id: q_wtm_q08a
      kind: Question
      title: How long have you been waiting since you and your doctor decided you should see a specialist?
      precondition:
      - predicate: q_wtm_q01.outcome == 1
      - predicate: q_wtm_q04.outcome == 0
      input:
        control: Editbox
        min: 1
        max: 365
        right: (enter amount)
    - id: q_wtm_n08b
      kind: Question
      title: 'Unit of time for the wait:'
      precondition:
      - predicate: q_wtm_q01.outcome == 1
      - predicate: q_wtm_q04.outcome == 0
      input:
        control: Radio
        labels:
          1: Days
          2: Weeks
          3: Months
    - id: q_wtm_q10
      kind: Question
      title: 'In your view, was the waiting time (or has the waiting time been):'
      precondition:
      - predicate: q_wtm_q01.outcome == 1
      input:
        control: Radio
        labels:
          1: Acceptable
          2: Not acceptable
          3: No view
    - id: q_wtm_q11a
      kind: Question
      title: In this particular case, what do you think is an acceptable waiting time?
      precondition:
      - predicate: q_wtm_q01.outcome == 1
      - predicate: q_wtm_q10.outcome == 2
      input:
        control: Editbox
        min: 1
        max: 365
        right: (enter amount)
    - id: q_wtm_n11b
      kind: Question
      title: 'Unit of time:'
      precondition:
      - predicate: q_wtm_q01.outcome == 1
      - predicate: q_wtm_q10.outcome == 2
      input:
        control: Radio
        labels:
          1: Days
          2: Weeks
          3: Months
    - id: q_wtm_q12
      kind: Question
      title: Was your visit cancelled or postponed at any time?
      precondition:
      - predicate: q_wtm_q01.outcome == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_wtm_q13
      kind: Question
      title: 'Was it cancelled or postponed by: (Mark all that apply)'
      precondition:
      - predicate: q_wtm_q01.outcome == 1
      - predicate: q_wtm_q12.outcome == 1
      input:
        control: Checkbox
        labels:
          1: Yourself
          2: The specialist
          4: Other
    - id: q_wtm_q13s
      kind: Question
      title: Please specify who cancelled or postponed.
      precondition:
      - predicate: q_wtm_q01.outcome == 1
      - predicate: q_wtm_q12.outcome == 1
      - predicate: q_wtm_q13.outcome % 8 >= 4
      input:
        control: Textarea
        placeholder: Specify...
        maxLength: 200
    - id: q_wtm_q14
      kind: Question
      title: Do you think that your health, or other aspects of your life, have been affected in any way because you had to
        wait for this visit?
      precondition:
      - predicate: q_wtm_q01.outcome == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_wtm_q15
      kind: Question
      title: How was your life affected as a result of waiting for this visit? (Mark all that apply)
      precondition:
      - predicate: q_wtm_q01.outcome == 1
      - predicate: q_wtm_q14.outcome == 1
      input:
        control: Checkbox
        labels:
          1: Worry, anxiety, stress
          2: Worry or stress for family or friends
          4: Pain
          8: Problems with activities of daily living
          16: Loss of work
          32: Loss of income
          64: Increased dependence on relatives/friends
          128: Increased use of over-the-counter drugs
          256: Overall health deteriorated, condition got worse
          512: Health problem improved
          1024: Personal relationships suffered
          2048: Other
    - id: q_wtm_q15s
      kind: Question
      title: Please specify how your life was affected.
      precondition:
      - predicate: q_wtm_q01.outcome == 1
      - predicate: q_wtm_q14.outcome == 1
      - predicate: q_wtm_q15.outcome % 4096 >= 2048
      input:
        control: Textarea
        placeholder: Specify...
        maxLength: 200
  - id: b_wtm_surgery
    title: Waiting Times - Surgery
    precondition:
    - predicate: q_acc_q20.outcome == 1
    items:
    - id: q_wtm_q16
      kind: Question
      title: What type of surgery did you require?
      postcondition:
      - predicate: not (q_wtm_q16.outcome == 5 and sex == 1)
        hint: Hysterectomy cannot be selected for male respondents.
      input:
        control: Dropdown
        labels:
          1: Cardiac surgery
          2: Cancer related surgery
          3: Hip or knee replacement surgery
          4: Cataract or other eye surgery
          5: Hysterectomy
          6: Removal of gall bladder
          7: Other
    - id: q_wtm_q16s
      kind: Question
      title: Please specify the type of surgery.
      precondition:
      - predicate: q_wtm_q16.outcome == 7
      input:
        control: Textarea
        placeholder: Specify surgery type...
        maxLength: 200
    - id: q_wtm_q17
      kind: Question
      title: Did you already have this surgery?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_wtm_q18
      kind: Question
      title: Did the surgery require an overnight hospital stay?
      precondition:
      - predicate: q_wtm_q17.outcome == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_wtm_q19
      kind: Question
      title: Did you experience any difficulties getting this surgery?
      precondition:
      - predicate: q_wtm_q17.outcome == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_wtm_q20
      kind: Question
      title: What type of difficulties did you experience? (Mark all that apply)
      precondition:
      - predicate: q_wtm_q17.outcome == 1
      - predicate: q_wtm_q19.outcome == 1
      input:
        control: Checkbox
        labels:
          1: Difficulty getting an appointment with a surgeon
          2: Difficulty getting a diagnosis
          4: Waited too long - for a diagnostic test
          8: Waited too long - for a hospital bed to become available
          16: Waited too long - for surgery
          32: Service not available in the area
          64: Transportation problems
          128: Language problem
          256: Cost
          512: Personal or family responsibilities
          1024: General deterioration of health
          2048: Appointment cancelled or deferred by surgeon or hospital
          4096: Unable to leave the house because of a health problem
          8192: Other
    - id: q_wtm_q20s
      kind: Question
      title: Please specify the other difficulty.
      precondition:
      - predicate: q_wtm_q17.outcome == 1
      - predicate: q_wtm_q19.outcome == 1
      - predicate: q_wtm_q20.outcome % 16384 >= 8192
      input:
        control: Textarea
        placeholder: Specify other difficulty...
        maxLength: 200
    - id: q_wtm_q21a
      kind: Question
      title: How long did you have to wait between when you and the surgeon decided to go ahead with surgery and the day of
        surgery?
      precondition:
      - predicate: q_wtm_q17.outcome == 1
      input:
        control: Editbox
        min: 1
        max: 365
        right: (enter amount)
    - id: q_wtm_n21b
      kind: Question
      title: 'Unit of time for the wait:'
      precondition:
      - predicate: q_wtm_q17.outcome == 1
      input:
        control: Radio
        labels:
          1: Days
          2: Weeks
          3: Months
    - id: q_wtm_q22
      kind: Question
      title: Will the surgery require an overnight hospital stay?
      precondition:
      - predicate: q_wtm_q17.outcome == 0
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_wtm_q23a
      kind: Question
      title: How long have you been waiting since you and the surgeon decided to go ahead with the surgery?
      precondition:
      - predicate: q_wtm_q17.outcome == 0
      input:
        control: Editbox
        min: 1
        max: 365
        right: (enter amount)
    - id: q_wtm_n23b
      kind: Question
      title: 'Unit of time for the wait:'
      precondition:
      - predicate: q_wtm_q17.outcome == 0
      input:
        control: Radio
        labels:
          1: Days
          2: Weeks
          3: Months
    - id: q_wtm_q24
      kind: Question
      title: 'In your view, was the waiting time (or has the waiting time been):'
      input:
        control: Radio
        labels:
          1: Acceptable
          2: Not acceptable
          3: No view
    - id: q_wtm_q25a
      kind: Question
      title: In this particular case, what do you think is an acceptable waiting time?
      precondition:
      - predicate: q_wtm_q24.outcome == 2
      input:
        control: Editbox
        min: 1
        max: 365
        right: (enter amount)
    - id: q_wtm_n25b
      kind: Question
      title: 'Unit of time:'
      precondition:
      - predicate: q_wtm_q24.outcome == 2
      input:
        control: Radio
        labels:
          1: Days
          2: Weeks
          3: Months
    - id: q_wtm_q26
      kind: Question
      title: Was your surgery cancelled or postponed at any time?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_wtm_q27
      kind: Question
      title: 'Was it cancelled or postponed by: (Mark all that apply)'
      precondition:
      - predicate: q_wtm_q26.outcome == 1
      input:
        control: Checkbox
        labels:
          1: Yourself
          2: The surgeon
          4: The hospital
          8: Other
    - id: q_wtm_q27s
      kind: Question
      title: Please specify who cancelled or postponed.
      precondition:
      - predicate: q_wtm_q26.outcome == 1
      - predicate: q_wtm_q27.outcome % 16 >= 8
      input:
        control: Textarea
        placeholder: Specify...
        maxLength: 200
    - id: q_wtm_q28
      kind: Question
      title: Do you think that your health, or other aspects of your life, have been affected in any way due to waiting for
        this surgery?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_wtm_q29
      kind: Question
      title: How was your life affected as a result of waiting for surgery? (Mark all that apply)
      precondition:
      - predicate: q_wtm_q28.outcome == 1
      input:
        control: Checkbox
        labels:
          1: Worry, anxiety, stress
          2: Worry or stress for family or friends
          4: Pain
          8: Problems with activities of daily living
          16: Loss of work
          32: Loss of income
          64: Increased dependence on relatives/friends
          128: Increased use of over-the-counter drugs
          256: Overall health deteriorated, condition got worse
          512: Health problem improved
          1024: Personal relationships suffered
          2048: Other
    - id: q_wtm_q29s
      kind: Question
      title: Please specify how your life was affected.
      precondition:
      - predicate: q_wtm_q28.outcome == 1
      - predicate: q_wtm_q29.outcome % 4096 >= 2048
      input:
        control: Textarea
        placeholder: Specify...
        maxLength: 200
  - id: b_wtm_diagnostic
    title: Waiting Times - Diagnostic Test
    precondition:
    - predicate: q_acc_q30.outcome == 1
    items:
    - id: q_wtm_q30
      kind: Question
      title: What type of test did you require?
      input:
        control: Radio
        labels:
          1: MRI
          2: CAT Scan
          3: Angiography
    - id: q_wtm_q31
      kind: Question
      title: For what type of condition?
      input:
        control: Dropdown
        labels:
          1: Heart disease or stroke
          2: Cancer
          3: Joints or fractures
          4: Neurological or brain disorders
          5: Other
    - id: q_wtm_q31s
      kind: Question
      title: Please specify the type of condition.
      precondition:
      - predicate: q_wtm_q31.outcome == 5
      input:
        control: Textarea
        placeholder: Specify condition...
        maxLength: 200
    - id: q_wtm_q32
      kind: Question
      title: Did you already have this test?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_wtm_q33
      kind: Question
      title: Where was the test done?
      precondition:
      - predicate: q_wtm_q32.outcome == 1
      input:
        control: Radio
        labels:
          1: Hospital
          2: Public clinic
          3: Private clinic
          4: Other
    - id: q_wtm_q33s
      kind: Question
      title: Please specify where the test was done.
      precondition:
      - predicate: q_wtm_q32.outcome == 1
      - predicate: q_wtm_q33.outcome == 4
      input:
        control: Textarea
        placeholder: Specify location...
        maxLength: 200
    - id: q_wtm_q34
      kind: Question
      title: 'Was the clinic located:'
      precondition:
      - predicate: q_wtm_q32.outcome == 1
      - predicate: q_wtm_q33.outcome == 3
      input:
        control: Radio
        labels:
          1: In your province
          2: In another province
          3: Other
    - id: q_wtm_q34s
      kind: Question
      title: Please specify where the clinic was located.
      precondition:
      - predicate: q_wtm_q32.outcome == 1
      - predicate: q_wtm_q33.outcome == 3
      - predicate: q_wtm_q34.outcome == 3
      input:
        control: Textarea
        placeholder: Specify location...
        maxLength: 200
    - id: q_wtm_q35
      kind: Question
      title: Were you a patient in a hospital at the time of the test?
      precondition:
      - predicate: q_wtm_q32.outcome == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_wtm_q36
      kind: Question
      title: Did you experience any difficulties getting this test?
      precondition:
      - predicate: q_wtm_q32.outcome == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_wtm_q37
      kind: Question
      title: What type of difficulties did you experience? (Mark all that apply)
      precondition:
      - predicate: q_wtm_q32.outcome == 1
      - predicate: q_wtm_q36.outcome == 1
      input:
        control: Checkbox
        labels:
          1: Difficulty getting a referral
          2: Difficulty getting an appointment
          4: Waited too long - to get an appointment
          8: Waited too long - to get test (in-office waiting)
          16: Service not available at time required
          32: Service not available in the area
          64: Transportation problems
          128: Language problem
          256: Cost
          512: General deterioration of health
          1024: Did not know where to go
          2048: Unable to leave the house because of a health problem
          4096: Other
    - id: q_wtm_q37s
      kind: Question
      title: Please specify the other difficulty.
      precondition:
      - predicate: q_wtm_q32.outcome == 1
      - predicate: q_wtm_q36.outcome == 1
      - predicate: q_wtm_q37.outcome % 8192 >= 4096
      input:
        control: Textarea
        placeholder: Specify other difficulty...
        maxLength: 200
    - id: q_wtm_q38a
      kind: Question
      title: How long did you have to wait between when you and your doctor decided to go ahead with the test and the day
        of the test?
      precondition:
      - predicate: q_wtm_q32.outcome == 1
      input:
        control: Editbox
        min: 1
        max: 365
        right: (enter amount)
    - id: q_wtm_n38b
      kind: Question
      title: 'Unit of time for the wait:'
      precondition:
      - predicate: q_wtm_q32.outcome == 1
      input:
        control: Radio
        labels:
          1: Days
          2: Weeks
          3: Months
    - id: q_wtm_q39a
      kind: Question
      title: How long have you been waiting for the test since you and your doctor decided to go ahead with the test?
      precondition:
      - predicate: q_wtm_q32.outcome == 0
      input:
        control: Editbox
        min: 1
        max: 365
        right: (enter amount)
    - id: q_wtm_n39b
      kind: Question
      title: 'Unit of time for the wait:'
      precondition:
      - predicate: q_wtm_q32.outcome == 0
      input:
        control: Radio
        labels:
          1: Days
          2: Weeks
          3: Months
    - id: q_wtm_q40
      kind: Question
      title: 'In your view, was the waiting time (or has the waiting time been):'
      input:
        control: Radio
        labels:
          1: Acceptable
          2: Not acceptable
          3: No view
    - id: q_wtm_q41a
      kind: Question
      title: In this particular case, what do you think is an acceptable waiting time?
      precondition:
      - predicate: q_wtm_q40.outcome == 2
      input:
        control: Editbox
        min: 1
        max: 365
        right: (enter amount)
    - id: q_wtm_n41b
      kind: Question
      title: 'Unit of time:'
      precondition:
      - predicate: q_wtm_q40.outcome == 2
      input:
        control: Radio
        labels:
          1: Days
          2: Weeks
          3: Months
    - id: q_wtm_q42
      kind: Question
      title: Was your test cancelled or postponed at any time?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_wtm_q43
      kind: Question
      title: 'Was it cancelled or postponed by:'
      precondition:
      - predicate: q_wtm_q42.outcome == 1
      input:
        control: Dropdown
        labels:
          1: Yourself
          2: The specialist
          3: The hospital
          4: The clinic
          5: Other
    - id: q_wtm_q43s
      kind: Question
      title: Please specify who cancelled or postponed.
      precondition:
      - predicate: q_wtm_q42.outcome == 1
      - predicate: q_wtm_q43.outcome == 5
      input:
        control: Textarea
        placeholder: Specify...
        maxLength: 200
    - id: q_wtm_q44
      kind: Question
      title: Do you think that your health, or other aspects of your life, have been affected in any way due to waiting for
        this test?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_wtm_q45
      kind: Question
      title: How was your life affected as a result of waiting for this test? (Mark all that apply)
      precondition:
      - predicate: q_wtm_q44.outcome == 1
      input:
        control: Checkbox
        labels:
          1: Worry, anxiety, stress
          2: Worry or stress for family or friends
          4: Pain
          8: Problems with activities of daily living
          16: Loss of work
          32: Loss of income
          64: Increased dependence on relatives/friends
          128: Increased use of over-the-counter drugs
          256: Overall health deteriorated, condition got worse
          512: Health problem improved
          1024: Personal relationships suffered
          2048: Other
    - id: q_wtm_q45s
      kind: Question
      title: Please specify how your life was affected.
      precondition:
      - predicate: q_wtm_q44.outcome == 1
      - predicate: q_wtm_q45.outcome % 4096 >= 2048
      input:
        control: Textarea
        placeholder: Specify...
        maxLength: 200
