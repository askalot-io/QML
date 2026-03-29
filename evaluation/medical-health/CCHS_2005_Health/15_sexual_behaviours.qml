qmlVersion: '1.0'
questionnaire:
  title: 15 Sexual Behaviours
  codeInit: |
    # Extern variables from earlier sections
    age: range(15, 49)
    sex: {1, 2}
    is_proxy: {0, 1}
    marital_status: {1, 2, 3, 4, 5, 6}
    # MAM_Q037: currently pregnant (1=Yes, 2=No)
    mam_q037: {1, 2}
  blocks:
  - id: b_sexual_behaviours
    title: Sexual Behaviours
    items:
    - id: q_sxb_r01
      kind: Comment
      title: I would like to ask you a few questions about sexual behaviour. Again, let me assure you that your answers are
        completely confidential.
    - id: q_sxb_q01
      kind: Question
      title: Have you ever had sexual intercourse?
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_sxb_q02
      kind: Question
      title: How old were you the first time?
      precondition:
      - predicate: q_sxb_q01.outcome == 1
      postcondition:
      - predicate: q_sxb_q02.outcome >= 1
        hint: Age at first intercourse must be at least 1.
      - predicate: q_sxb_q02.outcome <= age
        hint: Age at first intercourse cannot exceed current age.
      input:
        control: Editbox
        min: 1
        max: 49
    - id: q_sxb_q03
      kind: Question
      title: In the past 12 months, have you had sexual intercourse?
      precondition:
      - predicate: q_sxb_q01.outcome == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_sxb_q04
      kind: Question
      title: With how many different partners?
      precondition:
      - predicate: q_sxb_q01.outcome == 1
      - predicate: q_sxb_q03.outcome == 1
      input:
        control: Radio
        labels:
          1: 1 partner
          2: 2 partners
          3: 3 partners
          4: 4 or more partners
    - id: q_sxb_q07
      kind: Question
      title: Have you ever been diagnosed with a sexually transmitted disease?
      precondition:
      - predicate: q_sxb_q01.outcome == 1
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_sxb_q08
      kind: Question
      title: Did you use a condom the last time you had sexual intercourse?
      precondition:
      - predicate: q_sxb_q01.outcome == 1
      - predicate: q_sxb_q03.outcome == 1
      - predicate: not (marital_status in [1, 2] and q_sxb_q04.outcome == 1)
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_sxb_r9a
      kind: Comment
      title: Now a few questions about birth control.
      precondition:
      - predicate: q_sxb_q01.outcome == 1
      - predicate: q_sxb_q03.outcome == 1
      - predicate: age <= 24
    - id: q_sxb_r9b
      kind: Comment
      title: I'm going to read you a statement about pregnancy. Please tell me if you strongly agree, agree, neither agree
        nor disagree, disagree, or strongly disagree.
      precondition:
      - predicate: q_sxb_q01.outcome == 1
      - predicate: q_sxb_q03.outcome == 1
      - predicate: age <= 24
      - predicate: sex == 2
      - predicate: mam_q037 != 1
    - id: q_sxb_q09
      kind: Question
      title: It is important to me to avoid getting pregnant right now.
      precondition:
      - predicate: q_sxb_q01.outcome == 1
      - predicate: q_sxb_q03.outcome == 1
      - predicate: age <= 24
      - predicate: sex == 2
      - predicate: mam_q037 != 1
      input:
        control: Radio
        labels:
          1: Strongly agree
          2: Agree
          3: Neither agree nor disagree
          4: Disagree
          5: Strongly disagree
    - id: q_sxb_r10
      kind: Comment
      title: I'm going to read you a statement about pregnancy. Please tell me if you strongly agree, agree, neither agree
        nor disagree, disagree, or strongly disagree.
      precondition:
      - predicate: q_sxb_q01.outcome == 1
      - predicate: q_sxb_q03.outcome == 1
      - predicate: age <= 24
      - predicate: sex == 1
    - id: q_sxb_q10
      kind: Question
      title: It is important to me to avoid getting my partner pregnant right now.
      precondition:
      - predicate: q_sxb_q01.outcome == 1
      - predicate: q_sxb_q03.outcome == 1
      - predicate: age <= 24
      - predicate: sex == 1
      input:
        control: Radio
        labels:
          1: Strongly agree
          2: Agree
          3: Neither agree nor disagree
          4: Disagree
          5: Strongly disagree
          6: Doesn't have a partner right now
    - id: q_sxb_q11
      kind: Question
      title: In the past 12 months, did you and your partner usually use birth control?
      precondition:
      - predicate: q_sxb_q01.outcome == 1
      - predicate: q_sxb_q03.outcome == 1
      - predicate: age <= 24
      input:
        control: Switch
        false: 'No'
        true: 'Yes'
    - id: q_sxb_q12
      kind: Question
      title: What kind of birth control did you and your partner usually use? (Mark all that apply)
      precondition:
      - predicate: q_sxb_q01.outcome == 1
      - predicate: q_sxb_q03.outcome == 1
      - predicate: age <= 24
      - predicate: q_sxb_q11.outcome == 1
      input:
        control: Checkbox
        labels:
          1: Condom (male or female condom)
          2: Birth control pill
          4: Diaphragm
          8: Spermicide (e.g., foam, jelly, film)
          16: Birth control injection (Deprovera)
          32: Other
    - id: q_sxb_q12s
      kind: Question
      title: Specify other birth control method usually used.
      precondition:
      - predicate: q_sxb_q01.outcome == 1
      - predicate: q_sxb_q03.outcome == 1
      - predicate: age <= 24
      - predicate: q_sxb_q11.outcome == 1
      - predicate: q_sxb_q12.outcome % 64 >= 32
      input:
        control: Textarea
        placeholder: Specify other method...
        maxLength: 200
    - id: q_sxb_q13
      kind: Question
      title: What kind of birth control did you and your partner use the last time you had sex? (Mark all that apply)
      precondition:
      - predicate: q_sxb_q01.outcome == 1
      - predicate: q_sxb_q03.outcome == 1
      - predicate: age <= 24
      - predicate: q_sxb_q11.outcome == 1
      - predicate: mam_q037 != 1
      input:
        control: Checkbox
        labels:
          1: Condom (male or female condom)
          2: Birth control pill
          4: Diaphragm
          8: Spermicide (e.g., foam, jelly, film)
          16: Birth control injection (Deprovera)
          32: Nothing
          64: Other
    - id: q_sxb_q13s
      kind: Question
      title: Specify other birth control method used last time.
      precondition:
      - predicate: q_sxb_q01.outcome == 1
      - predicate: q_sxb_q03.outcome == 1
      - predicate: age <= 24
      - predicate: q_sxb_q11.outcome == 1
      - predicate: mam_q037 != 1
      - predicate: q_sxb_q13.outcome % 128 >= 64
      input:
        control: Textarea
        placeholder: Specify other method...
        maxLength: 200
